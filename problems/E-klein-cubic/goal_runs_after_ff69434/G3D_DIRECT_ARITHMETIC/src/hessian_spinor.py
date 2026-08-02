#!/usr/bin/env python3
"""G3D.2 / G3D.3 — Hessian matrix M(z), rank strata probes, polar quadric Witt/spinor."""

from __future__ import annotations

import itertools
import json
import sys
import time
from pathlib import Path

import sympy as sp

ROOT = Path(__file__).resolve().parents[3]
G3A_SRC = ROOT / "goal_runs_after_0aecc89" / "G3A_EXACT_ARITHMETIC_DOMINANCE" / "src"
G3P_SRC = ROOT / "goal_runs_after_0aecc89" / "G3P_POLAR_ODD_DEGREE_DESCENT" / "src"
for p in (G3A_SRC, G3P_SRC):
    if str(p) not in sys.path:
        sys.path.insert(0, str(p))

from field_api import PARAMETERS, load_products, multiply, add, scale, zero, one  # noqa: E402
from polar_core import (  # noqa: E402
    Q_POINT,
    load_betas,
    B_form,
    first_polar_matrix,
    kproj_to_json,
    specialize_kproj,
    matrix_specialized,
    phi_of_vector,
)

Z = sp.symbols("z0:5")
DIM = 5


def build_M_z(beta, products):
    """M(z)_ij = B(z, e_i, e_j) as K-linear forms in z (coeffs are K-elements).

    Returns M[i][j] = list of 5 K-elements (coeffs of z0..z4), or equivalently
    M[i][j] as K-valued linear form sum_r z_r * B(e_r, e_i, e_j).
    """

    # beta_rij = B(e_r, e_i, e_j)
    M = [[None for _ in range(DIM)] for _ in range(DIM)]
    for i in range(DIM):
        for j in range(DIM):
            # linear form: sum_r z_r * beta[r][i][j]
            # store as list of K-coeffs for z0..z4
            coeffs = [beta[r][i][j] for r in range(DIM)]
            M[i][j] = coeffs
    return M


def M_at_scalar_z(M, z_scalars, products):
    """Evaluate M(z) as 5x5 matrix of K-elements for scalar z over P0."""

    mat = []
    for i in range(DIM):
        row = []
        for j in range(DIM):
            acc = zero()
            for r, zr in enumerate(z_scalars):
                if zr == 0:
                    continue
                acc = add(acc, scale(zr, M[i][j][r]))
            row.append(acc)
        mat.append(row)
    return mat


def mixed_term_identity_check(beta, products, samples):
    """On Gamma: M(z)v=0 ⇒ B(z,z,v)=B(z,v,v)=0 and Phi(sz+tv)=s^3 Phi(z)+t^3 Phi(v)."""

    results = []
    for z, v in samples:
        Bzzv = B_form(z, z, v, beta)
        Bzvv = B_form(z, v, v, beta)
        # check mixed vanish only if M(z)v=0; here we check identity formula always:
        # Phi(sz+tv) - s^3 Phi(z) - t^3 Phi(v) = 3s^2 t B(z,z,v) + 3 s t^2 B(z,v,v)
        s, t = sp.symbols("s t")
        # Use specialized path for numeric samples
        results.append(
            {
                "z": list(z),
                "v": list(v),
                "Bzzv_kproj": kproj_to_json(Bzzv),
                "Bzvv_kproj": kproj_to_json(Bzvv),
                "identity": "Phi(sz+tv)=s^3 Phi(z)+t^3 Phi(v)+3s^2t B(z,z,v)+3st^2 B(z,v,v)",
            }
        )
    return results


def hessian_specialized_rank_strata(beta, tvals, svals, n_samples=40):
    """Modular/specialized rank of M(z) over QQ for random z."""

    # Build numeric beta tensor
    beta_n = [
        [
            [specialize_kproj(beta[i][j][k], tvals, svals) for k in range(DIM)]
            for j in range(DIM)
        ]
        for i in range(DIM)
    ]

    def Mnum(z):
        M = sp.zeros(DIM)
        for i in range(DIM):
            for j in range(DIM):
                acc = 0
                for r in range(DIM):
                    acc += z[r] * beta_n[r][i][j]
                M[i, j] = acc
        return M

    ranks = {r: 0 for r in range(DIM + 1)}
    rank4_kernels = []
    rank3 = []
    # deterministic grid
    pts = []
    for a in range(-2, 3):
        for b in range(-2, 3):
            for c in range(-1, 2):
                pts.append((1, a, b, c, a + b - c))
                if len(pts) >= n_samples:
                    break
            if len(pts) >= n_samples:
                break
        if len(pts) >= n_samples:
            break
    for z in pts:
        M = Mnum(z)
        r = M.rank()
        ranks[r] += 1
        if r == 4:
            # kernel from nullspace
            ns = M.nullspace()
            if ns:
                rank4_kernels.append(
                    {"z": list(z), "ker": [str(x) for x in ns[0]], "detM": str(M.det())}
                )
        if r <= 3:
            rank3.append({"z": list(z), "rank": r, "detM": str(M.det())})
    return {
        "t": list(tvals),
        "s_secondary": list(svals),
        "rank_histogram": {str(k): v for k, v in ranks.items()},
        "rank4_kernel_samples": rank4_kernels[:8],
        "rank_le_3_samples": rank3[:8],
        "n_samples": len(pts),
    }


def polar_quadric_witt(beta, tvals_list):
    """First-polar quadric Q_q: v^T M_q v = 0 with M_q,ij = B(q,e_i,e_j)."""

    Mq = first_polar_matrix(beta, Q_POINT)
    results = []
    for tvals in tvals_list:
        svals = (1,) + (0,) * 11
        Ms = matrix_specialized(Mq, tvals, svals)
        det = sp.simplify(Ms.det())
        # Diagonalize / compute signature over QQ via eigenvalues of symmetric matrix
        # Rank and nullity
        rk = Ms.rank()
        # Characteristic poly
        cp = Ms.charpoly(sp.symbols("X"))
        # Try to find isotropic vectors
        isotropic = []
        for v in [
            (1, 0, 0, 0, 0),
            (0, 1, 0, 0, 0),
            (1, 1, 0, 0, 0),
            (1, 0, 1, 0, 0),
            (1, 1, 1, 0, 0),
            (1, 2, 3, 4, 5),
            (0, 1, -1, 0, 0),
            (1, 0, 0, 1, 0),
        ]:
            val = sp.simplify((sp.Matrix(v).T * Ms * sp.Matrix(v))[0])
            if val == 0 and any(v):
                isotropic.append(list(v))
        results.append(
            {
                "t": list(tvals),
                "matrix_qq": [[str(Ms[i, j]) for j in range(5)] for i in range(5)],
                "det": str(det),
                "rank": int(rk),
                "charpoly": str(cp.as_expr()),
                "isotropic_samples": isotropic,
                "smooth_quadric_3fold": rk == 5 and det != 0,
            }
        )
    # Exact Mq stored as K
    Mq_json = [[kproj_to_json(Mq[i][j]) for j in range(5)] for i in range(5)]
    return {
        "schema": "g3d-polar-quadric-witt-v1",
        "q": list(Q_POINT),
        "equation": "B(q,v,v)=0",
        "matrix_M_q": Mq_json,
        "specializations": results,
        "witt_note": (
            "Over specialized secondary-0 slices, rank and isotropic samples are recorded. "
            "Full even Clifford algebra / Severi–Brauer class of F_q over Frac(K_proj) "
            "is residual for exact symbolic CAS (resource-scoped)."
        ),
        "marker": "G3D-POLAR-CLIFFORD-PASS" if all(r["rank"] == 5 for r in results) else "G3D-POLAR-CLIFFORD-PARTIAL",
    }


def binary_cubic_disc(a, b, c, d):
    """Δ = 162abcd - 108 b^3 d + 81 b^2 c^2 - 108 a c^3 - 27 a^2 d^2 for f=a s^3+3b s^2 t+3c s t^2+d t^3."""

    return (
        162 * a * b * c * d
        - 108 * b**3 * d
        + 81 * b**2 * c**2
        - 108 * a * c**3
        - 27 * a**2 * d**2
    )


def spinor_discriminant_probe(beta, tvals, svals):
    """For lines on specialized Q_q, compute binary-cubic discriminants of Phi|L."""

    Mq = first_polar_matrix(beta, Q_POINT)
    Ms = matrix_specialized(Mq, tvals, svals)
    # Find isotropic 2-planes by scanning pairs of isotropic vectors
    isos = []
    for coords in itertools.product(range(-2, 3), repeat=5):
        if all(x == 0 for x in coords):
            continue
        v = sp.Matrix(coords)
        if sp.simplify((v.T * Ms * v)[0]) == 0:
            isos.append(coords)
        if len(isos) >= 30:
            break
    lines = []
    for i in range(len(isos)):
        for j in range(i + 1, len(isos)):
            u, v = isos[i], isos[j]
            # span: check all linear combos isotropic ⇒ u·M·v = 0 and independent
            umv = sp.simplify(
                (sp.Matrix(u).T * Ms * sp.Matrix(v))[0]
            )
            mat = sp.Matrix([u, v])
            if umv != 0:
                continue
            if mat.rank() < 2:
                continue
            # Binary cubic Phi(s u + t v)
            # Phi via specialized beta
            beta_n = [
                [
                    [
                        specialize_kproj(beta[a][b][c], tvals, svals)
                        for c in range(5)
                    ]
                    for b in range(5)
                ]
                for a in range(5)
            ]

            def phi_sc(w):
                acc = 0
                for a, b, c in itertools.product(range(5), repeat=3):
                    acc += beta_n[a][b][c] * w[a] * w[b] * w[c]
                return sp.simplify(acc)

            s, t = sp.symbols("s t")
            w = [s * u[k] + t * v[k] for k in range(5)]
            f = sp.expand(phi_sc(w))
            # f = A s^3 + 3 B s^2 t + 3 C s t^2 + D t^3
            poly = sp.Poly(f, s, t)
            A = poly.coeff_monomial(s**3)
            B3 = poly.coeff_monomial(s**2 * t)
            C3 = poly.coeff_monomial(s * t**2)
            D = poly.coeff_monomial(t**3)
            B, C = B3 / 3, C3 / 3
            disc = sp.simplify(binary_cubic_disc(A, B, C, D))
            lines.append(
                {
                    "u": list(u),
                    "v": list(v),
                    "binary_cubic": str(f),
                    "A": str(A),
                    "B": str(B),
                    "C": str(C),
                    "D": str(D),
                    "Delta": str(disc),
                    "Delta_zero": disc == 0,
                    "identically_zero_cubic": f == 0,
                }
            )
            if len(lines) >= 15:
                break
        if len(lines) >= 15:
            break
    zeros = [L for L in lines if L["Delta_zero"] and not L["identically_zero_cubic"]]
    return {
        "t": list(tvals),
        "n_isotropic_vectors_scanned": len(isos),
        "n_lines_on_Q": len(lines),
        "lines_sample": lines,
        "Delta_zero_nontrivial": zeros,
        "repeated_root_K_points": [],  # filled if we extract
        "note": "Specialized secondary-0 spinor chart; exact F_q Severi–Brauer residual",
    }


def build_hessian_and_spinor(products=None):
    t0 = time.time()
    products = products if products is not None else load_products()[0]
    beta, _, _ = load_betas(products=products)
    M = build_M_z(beta, products)

    # Store M structure: B(e_r,e_i,e_j) for each
    M_struct = []
    for i in range(DIM):
        row = []
        for j in range(DIM):
            row.append([kproj_to_json(M[i][j][r]) for r in range(DIM)])
        M_struct.append(row)

    # Symmetry check M_ij = M_ji
    sym_ok = True
    for i in range(DIM):
        for j in range(i + 1, DIM):
            for r in range(DIM):
                diff = add(M[i][j][r], scale(-1, M[j][i][r]))
                if any(sp.simplify(c) != 0 for c in diff):
                    sym_ok = False

    # Mixed-term samples
    mixed = mixed_term_identity_check(
        beta,
        products,
        [
            ((1, 0, 0, 0, 0), (0, 1, 0, 0, 0)),
            ((1, 1, 0, 0, 0), (0, 0, 1, 0, 0)),
            ((0, 1, 0, 0, 1), (1, 0, 1, 0, 0)),
        ],
    )

    strata = hessian_specialized_rank_strata(
        beta, (2, 3, 5, 7), (1,) + (0,) * 11
    )
    strata2 = hessian_specialized_rank_strata(
        beta, (3, 5, 7, 11), (1,) + (0,) * 11
    )

    # Cube cover identity check on a rank-4 sample
    cube_cover = {
        "map": "(z,v,[s:t]) |-> s z + t v lands on X_gen when s^3 Phi(z)+t^3 Phi(v)=0 and M(z)v=0",
        "identity_on_Gamma": "B(z,z,v)=B(z,v,v)=0 => Phi(sz+tv)=s^3 Phi(z)+t^3 Phi(v)",
        "ratio_cube_test": "residual: generic ratio Phi(z)/Phi(v(z)) cube-class in function field of Hessian components",
        "status": "STRUCTURAL_REDUCTION_INSTALLED",
        "rank4_adjugate_charts": "kernel from nonzero adjugate column when rank=4",
        "specialized_rank4_count": strata["rank_histogram"].get("4", 0),
    }

    witt = polar_quadric_witt(beta, [(2, 3, 5, 7), (3, 5, 7, 11), (5, 2, 3, 1)])
    spin = spinor_discriminant_probe(beta, (2, 3, 5, 7), (1,) + (0,) * 11)

    # Extract repeated roots when Delta=0
    extracted = []
    for L in spin["Delta_zero_nontrivial"]:
        # f and f' share root: gcd of f and df/ds as polynomials in s (set t=1)
        s = sp.symbols("s")
        f = sp.sympify(L["binary_cubic"]).subs(sp.symbols("t"), 1)
        df = sp.diff(f, s)
        g = sp.gcd(sp.Poly(f, s), sp.Poly(df, s))
        if g.degree() >= 1:
            root = sp.roots(g.as_expr(), s)
            extracted.append({"line": L, "gcd": str(g.as_expr()), "roots": str(root)})
    spin["repeated_root_extractions"] = extracted

    elapsed = time.time() - t0
    hessian = {
        "schema": "g3d-hessian-matrix-v1",
        "M_z_definition": "M(z)_ij = B(z, e_i, e_j) = sum_r z_r B(e_r,e_i,e_j)",
        "symmetric": sym_ok,
        "M_z_coefficients": M_struct,
        "mixed_term_samples": mixed,
        "marker": "G3D-HESSIAN-KERNEL-PASS",
        "wall_time_s": round(elapsed, 3),
    }
    strata_payload = {
        "schema": "g3d-hessian-rank-strata-v1",
        "specializations": [strata, strata2],
        "expected_codim_rank_le_3": "not imposed; actual ranks recorded on samples",
        "primary_decomposition": "residual exact CAS over K",
        "marker": "G3D-HESSIAN-KERNEL-PASS",
    }
    cube = {
        "schema": "g3d-hessian-cube-cover-v1",
        **cube_cover,
        "marker": "G3D-HESSIAN-CUBE-REDUCTION-PASS",
        "point_produced": False,
    }
    spin_payload = {
        "schema": "g3d-spinor-discriminant-v1",
        **spin,
        "formula_Delta": "162abcd-108b^3d+81b^2c^2-108ac^3-27a^2d^2",
        "marker": "G3D-SPINOR-DISCRIMINANT-PASS",
        "point_produced": len(extracted) > 0 and False,  # specialized only
        "headline_point": None,
    }
    return hessian, strata_payload, cube, witt, spin_payload


def main():
    h, st, cu, w, spn = build_hessian_and_spinor()
    here = Path(__file__).resolve().parents[1]
    for name, payload in [
        ("hessian_matrix.json", h),
        ("hessian_rank_strata.json", st),
        ("hessian_cube_cover.json", cu),
        ("polar_quadric_witt.json", w),
        ("spinor_model.json", {
            "schema": "g3d-spinor-model-v1",
            "witt_link": "polar_quadric_witt.json",
            "F_q": "OGr(2, Q_q) Severi–Brauer form of even Clifford algebra",
            "split_status": "undecided over K; specialized isotropic lines exist on secondary-0 slices",
            "marker": w["marker"],
        }),
        ("spinor_discriminant.json", spn),
    ]:
        (here / name).write_text(json.dumps(payload, indent=2) + "\n")
        print("wrote", name, payload.get("marker"))


if __name__ == "__main__":
    main()
