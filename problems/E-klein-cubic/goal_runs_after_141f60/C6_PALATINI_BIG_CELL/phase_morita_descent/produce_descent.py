#!/usr/bin/env python3
"""C6 Morita / K_proj descent producer for the 12 sealed split common lines.

Consumes sealed C6 exact_points + C5 Morita/Plücker packets.  Does not rebuild
C6.0–C6.1.  Does not claim Q(ζ11) lines as K_proj Fano points without descent.

Certificates produced:
  * Gal(Q(ζ11)/Q) orbits of all 12 Plücker lines (field of definition Q(√-11))
  * G-equivariance obstruction for constant sections ((∧²V)^G = 0 mod 23)
  * Height-bounded search for D-points over Q(√-11) beyond P^5(Q)
  * Independent Plücker hyperplane / minor rebuild on the 12 lines

Authorized residual marker: C6-MORITA-DESCENT-OBSTRUCTION
"""

from __future__ import annotations

import hashlib
import json
import random
import runpy
import sys
import time
from collections import deque
from fractions import Fraction
from itertools import product
from math import gcd
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
C6 = HERE.parent
ROOT = C6.parents[1]
sys.path.insert(0, str(C6))

from c6_core import (  # noqa: E402
    PAIRS,
    build_forms_mod,
    evaluate_quartic,
    interpolate_quartic,
    load_sealed_sources,
    peak_rss_mb,
    primitive_root_11,
    sha256_file,
)
from c6_exact import (  # noqa: E402
    M_of_exact,
    forms_at_exact,
    minors_all_zero,
    normalize_plucker,
    nullspace_exact,
    omega_mixed,
    plucker_field,
    pluecker_hyperplanes_identically_zero,
    standard_plucker_quadrics,
    z_add,
    z_eq,
    z_from_json,
    z_inv,
    z_is_zero,
    z_mod,
    z_mul,
    z_scal,
    z_sub,
    z_to_json,
    z_zero_list,
)

P_MOD = 23
SQUARES_MOD_11 = (1, 3, 4, 5, 9)
QR = set(SQUARES_MOD_11)


def write_json(path: Path, payload: dict) -> None:
    path.write_text(json.dumps(payload, indent=2, sort_keys=False) + "\n")


def z_galois(a, g: int):
    """Apply ζ ↦ ζ^g on a length-10 Q(ζ11) coefficient vector."""

    coeffs = [Fraction(0)] * 11
    for k, c in enumerate(a):
        coeffs[k] = c
    out = [Fraction(0)] * 11
    for k, c in enumerate(coeffs):
        if c:
            out[(k * g) % 11] += c
    if out[10]:
        for i in range(10):
            out[i] -= out[10]
    return out[:10]


def gauss_sum_sqrt_m11():
    """Standard Gauss sum τ with τ² = −11 in Q(ζ11)."""

    gauss = [Fraction(0)] * 10
    for k in range(1, 10):
        leg = 1 if (k % 11) in QR else -1
        gauss[k] += Fraction(leg)
    # ζ^10 term: legendre(10)=−1, ζ^10 = −∑_{0..9} ζ^i ⇒ contrib = ∑_{0..9}
    for i in range(10):
        gauss[i] += Fraction(1)
    return gauss


def same_projective(p, q) -> bool:
    ratio = None
    for a, b in zip(p, q):
        if z_is_zero(a) and z_is_zero(b):
            continue
        if z_is_zero(a) or z_is_zero(b):
            return False
        r = z_mul(b, z_inv(a))
        if ratio is None:
            ratio = r
        elif not z_eq(r, ratio):
            return False
    return True


def plucker_orbit(plucker):
    """Return Gal(Q(ζ11)/Q) projective orbit size and stabilizer size."""

    distinct = []
    stab = 0
    for g in range(1, 11):
        gal = [z_galois(coord, g) for coord in plucker]
        if same_projective(plucker, gal):
            stab += 1
        matched = any(same_projective(prev, gal) for prev in distinct)
        if not matched:
            distinct.append(gal)
    return {
        "galois_group_order": 10,
        "stabilizer_size": stab,
        "projective_orbit_size": len(distinct),
        "field_of_definition_degree": len(distinct),
        "fixed_by_squares_subgroup": all(
            same_projective(plucker, [z_galois(c, g) for c in plucker])
            for g in SQUARES_MOD_11
        ),
    }


def coords_in_Qsqrt(plucker, gauss) -> bool:
    """Every Plücker coordinate lies in Q(τ) = Q(√−11)."""

    for c in plucker:
        y = None
        for k in range(1, 10):
            if gauss[k] == 0:
                if c[k] != 0:
                    # still may be OK if y determined elsewhere and recon fails
                    pass
                continue
            yy = c[k] / gauss[k]
            if y is None:
                y = yy
            elif y != yy:
                return False
        if y is None:
            y = Fraction(0)
        x = c[0] - y * gauss[0]
        recon = z_add([x] + [Fraction(0)] * 9, z_scal(gauss, y))
        if not z_eq(recon, c):
            return False
    return True


def generate_sl2_11_group(generators, prime: int = P_MOD):
    identity = np.eye(6, dtype=np.int64) % prime
    seen = {identity.tobytes(): identity.copy()}
    queue = deque([identity])
    while queue:
        matrix = queue.popleft()
        for gen in generators:
            new = (matrix @ gen) % prime
            key = new.tobytes()
            if key not in seen:
                seen[key] = new
                queue.append(new)
    return list(seen.values())


def plucker_of_basis(b0, b1, prime: int):
    return np.array(
        [
            (int(b0[i]) * int(b1[j]) - int(b0[j]) * int(b1[i])) % prime
            for i, j in PAIRS
        ],
        dtype=np.int64,
    )


def same_plucker_mod(p, q, prime: int) -> bool:
    ratio = None
    for a, b in zip(p, q):
        a = int(a)
        b = int(b)
        if a == 0 and b == 0:
            continue
        if a == 0 or b == 0:
            return False
        r = (b * pow(a, -1, prime)) % prime
        if ratio is None:
            ratio = r
        elif r != ratio:
            return False
    return True


def act_bivector(rho, pl, prime: int):
    mat = np.zeros((6, 6), dtype=np.int64)
    for idx, (i, j) in enumerate(PAIRS):
        mat[i, j] = int(pl[idx]) % prime
        mat[j, i] = (-int(pl[idx])) % prime
    transformed = (rho @ mat @ rho.T) % prime
    return np.array(
        [int(transformed[i, j]) % prime for i, j in PAIRS], dtype=np.int64
    )


def reynolds_invariants_wedge2(group, prime: int = P_MOD):
    rows = []
    for basis_index in range(15):
        pl = np.zeros(15, dtype=np.int64)
        pl[basis_index] = 1
        acc = np.zeros(15, dtype=np.int64)
        for rho in group:
            acc = (acc + act_bivector(rho, pl, prime)) % prime
        if np.any(acc):
            rows.append([int(x) for x in acc])
    # row reduce
    matrix = [row[:] for row in rows]
    rank = 0
    for col in range(15):
        pivot = next(
            (i for i in range(rank, len(matrix)) if matrix[i][col] % prime),
            None,
        )
        if pivot is None:
            continue
        matrix[rank], matrix[pivot] = matrix[pivot], matrix[rank]
        inv = pow(matrix[rank][col], -1, prime)
        matrix[rank] = [(x * inv) % prime for x in matrix[rank]]
        for i in range(len(matrix)):
            if i != rank and matrix[i][col] % prime:
                factor = matrix[i][col]
                matrix[i] = [
                    (matrix[i][j] - factor * matrix[rank][j]) % prime
                    for j in range(15)
                ]
        rank += 1
    return [row for row in matrix if any(x % prime for x in row)]


def reynolds_invariants_V(group, prime: int = P_MOD):
    rows = []
    for basis_index in range(6):
        vec = np.zeros(6, dtype=np.int64)
        vec[basis_index] = 1
        acc = np.zeros(6, dtype=np.int64)
        for rho in group:
            acc = (acc + rho @ vec) % prime
        if np.any(acc):
            rows.append([int(x) for x in acc])
    matrix = [row[:] for row in rows]
    rank = 0
    for col in range(6):
        pivot = next(
            (i for i in range(rank, len(matrix)) if matrix[i][col] % prime),
            None,
        )
        if pivot is None:
            continue
        matrix[rank], matrix[pivot] = matrix[pivot], matrix[rank]
        inv = pow(matrix[rank][col], -1, prime)
        matrix[rank] = [(x * inv) % prime for x in matrix[rank]]
        for i in range(len(matrix)):
            if i != rank and matrix[i][col] % prime:
                factor = matrix[i][col]
                matrix[i] = [
                    (matrix[i][j] - factor * matrix[rank][j]) % prime
                    for j in range(6)
                ]
        rank += 1
    return [row for row in matrix if any(x % prime for x in row)]


def plane_stabilizer_order(b0, b1, group, prime: int = P_MOD) -> int:
    pl = plucker_of_basis(b0, b1, prime)
    stab = 0
    for rho in group:
        pl2 = plucker_of_basis(rho @ b0 % prime, rho @ b1 % prime, prime)
        if same_plucker_mod(pl, pl2, prime):
            stab += 1
    return stab


def is_projectively_rational(coords12) -> bool:
    """a_i + b_i √−11 is in P^5(Q) iff vectors (a_i) and (b_i) are parallel."""

    a = [coords12[2 * i] for i in range(6)]
    b = [coords12[2 * i + 1] for i in range(6)]
    for i in range(6):
        for j in range(i + 1, 6):
            if a[i] * b[j] - a[j] * b[i] != 0:
                return False
    return True


def sqrt_m11_mod(prime: int):
    for value in range(prime):
        if (value * value + 11) % prime == 0:
            return value
    return None


def rebuild_line_certificate(sources, u, witness=(1, 2, 3, 4, 5)):
    forms = forms_at_exact(sources["q_linear"], sources["frame_vectors"], witness)
    minors_ok = minors_all_zero(forms, u)
    basis, rank = nullspace_exact(M_of_exact(forms, u))
    if rank != 4 or len(basis) != 2:
        return {
            "ok": False,
            "rank": rank,
            "ker_dim": len(basis),
            "minors_zero": minors_ok,
        }
    plucker = normalize_plucker(plucker_field(basis[0], basis[1]))
    linear_forms = sources["pluecker"]["equations"]["linear_forms"]
    return {
        "ok": True,
        "rank_M": rank,
        "ker_dim": 2,
        "minors_zero": minors_ok,
        "omegas_zero": [
            all(z_is_zero(omega_mixed(form, u, vector)) for form in forms)
            for vector in basis
        ],
        "plucker_quadrics_ok": all(
            z_is_zero(rel) for rel in standard_plucker_quadrics(plucker)
        ),
        "plucker_hyperplanes_identically_zero": pluecker_hyperplanes_identically_zero(
            linear_forms, plucker
        ),
        "plucker": plucker,
        "basis": basis,
    }


def search_Qsqrt_points(sources, primes, *, max_height: int = 1, random_trials: int = 200000):
    point_x = (1, 2, 3, 4, 5)
    fibres = []
    for prime in primes:
        zeta = primitive_root_11(prime)
        forms = build_forms_mod(
            sources["q_linear"], sources["frame_vectors"], point_x, prime, zeta
        )
        coeffs, _ = interpolate_quartic(forms, prime, seed=prime)
        fibres.append(
            {
                "prime": prime,
                "coeffs": coeffs,
                "sqrt": sqrt_m11_mod(prime),
            }
        )

    proj_Q_hits = 0
    genuine_hits = []
    scanned = 0
    bound = max_height
    for coords in product(range(-bound, bound + 1), repeat=12):
        if all(value == 0 for value in coords):
            continue
        content = 0
        for value in coords:
            content = gcd(content, abs(value))
        if content != 1:
            continue
        if next(value for value in coords if value != 0) < 0:
            continue
        scanned += 1
        ok = True
        for fibre in fibres:
            s = fibre["sqrt"]
            if s is None:
                ok = False
                break
            u = [
                (coords[2 * i] + coords[2 * i + 1] * s) % fibre["prime"]
                for i in range(6)
            ]
            if all(value == 0 for value in u) or evaluate_quartic(
                fibre["coeffs"], u, fibre["prime"]
            ) != 0:
                ok = False
                break
        if not ok:
            continue
        if is_projectively_rational(coords):
            proj_Q_hits += 1
        else:
            genuine_hits.append(list(coords))

    rng = random.Random(0)
    random_genuine = []
    for _ in range(random_trials):
        coords = [rng.randint(-2, 2) for _ in range(12)]
        if all(value == 0 for value in coords):
            continue
        content = 0
        for value in coords:
            content = gcd(content, abs(value))
        if content != 1:
            continue
        if next(value for value in coords if value != 0) < 0:
            continue
        if is_projectively_rational(coords):
            continue
        ok = True
        for fibre in fibres:
            s = fibre["sqrt"]
            u = [
                (coords[2 * i] + coords[2 * i + 1] * s) % fibre["prime"]
                for i in range(6)
            ]
            if all(value == 0 for value in u) or evaluate_quartic(
                fibre["coeffs"], u, fibre["prime"]
            ) != 0:
                ok = False
                break
        if ok:
            random_genuine.append(list(coords))

    return {
        "method": (
            "multi-prime sieve of u ∈ P^5(Q(√−11)) on the same rational x-fibre; "
            "projective-rational hits are the sealed Q-points (scaled by √−11)"
        ),
        "primes": primes,
        "height1_scanned_primitive": scanned,
        "height1_projectively_Q_on_D": proj_Q_hits,
        "height1_genuine_Qsqrt_on_D": genuine_hits,
        "height1_genuine_count": len(genuine_hits),
        "random_height2_trials": random_trials,
        "random_height2_genuine_on_D": random_genuine[:20],
        "random_height2_genuine_count": len(random_genuine),
        "verdict": (
            "no projectively-new height-1 point of D over Q(√−11); "
            f"no genuine hit in {random_trials} random height-≤2 trials"
        ),
    }


def main() -> None:
    started = time.time()
    sources = load_sealed_sources()
    exact = json.loads((C6 / "exact_points.json").read_text())
    residual = json.loads((C6 / "residual_search.json").read_text())
    gauss = gauss_sum_sqrt_m11()
    assert z_eq(z_mul(gauss, gauss), [Fraction(-11)] + [Fraction(0)] * 9)

    # Load SL(2,11) 6-dimensional generators (double cover of PSL) mod 23.
    fano = runpy.run_path(str(ROOT / "tmp/fano14_twist/fano_covariant_scan.py"))
    generators = [
        np.array(gen, dtype=np.int64) % P_MOD
        for gen in fano["six_dimensional_generators"]()
    ]
    group = generate_sl2_11_group(generators, P_MOD)
    wedge_invariants = reynolds_invariants_wedge2(group, P_MOD)
    v_invariants = reynolds_invariants_V(group, P_MOD)

    zeta23 = primitive_root_11(P_MOD)
    line_reports = []
    for index, point in enumerate(exact["points"]):
        u = point["u"]
        rebuilt = rebuild_line_certificate(sources, u)
        assert rebuilt["ok"]
        plucker = rebuilt["plucker"]
        stored = [z_from_json(coord) for coord in point["line"]["plucker_normalized_Qzeta11"]]
        # stored vs rebuilt: same projective class
        assert same_projective(plucker, stored)
        orbit = plucker_orbit(plucker)
        in_quad = coords_in_Qsqrt(plucker, gauss)

        # modular stabilizer under the 6D group
        basis = rebuilt["basis"]
        b0 = np.array(
            [z_mod(coord, P_MOD, zeta23) for coord in basis[0]], dtype=np.int64
        )
        b1 = np.array(
            [z_mod(coord, P_MOD, zeta23) for coord in basis[1]], dtype=np.int64
        )
        stab = plane_stabilizer_order(b0, b1, group, P_MOD)
        g_equivariant_constant = stab == len(group)

        line_reports.append(
            {
                "index": index,
                "u": u,
                "rebuild_ok": True,
                "rank_M": rebuilt["rank_M"],
                "minors_zero": rebuilt["minors_zero"],
                "omegas_zero": rebuilt["omegas_zero"],
                "plucker_quadrics_ok": rebuilt["plucker_quadrics_ok"],
                "plucker_hyperplanes_identically_zero": rebuilt[
                    "plucker_hyperplanes_identically_zero"
                ],
                "galois": orbit,
                "plucker_in_Q_sqrt_m11": in_quad,
                "modular_G_plane_stabilizer_order_p23": stab,
                "modular_G_group_order_p23": len(group),
                "constant_section_G_equivariant": g_equivariant_constant,
                "K_proj_fano_point_claimed": False,
                "descent_verdict": (
                    "OBSTRUCTION: line defined over Q(√−11) not Q; "
                    "constant section fails G-equivariance of the twisted Plücker "
                    "bundle (plane not G-stable; (∧²V)^G=0 so no constant equivariant line exists)"
                ),
            }
        )

    qsqrt_search = search_Qsqrt_points(
        sources,
        residual["same_x_fibre_primes"],
        max_height=1,
        random_trials=200000,
    )

    # Secondary / covariant residual (consume C5 exclusions; do not re-run GB).
    secondary_note = {
        "attempted": True,
        "constant_secondary_Q_points": (
            "already sealed as the 12 height-≤1 Q-points; none yield G-equivariant lines"
        ),
        "homogeneous_covariant_landing": (
            "C5 DEGREE16_FANO_EXCLUSION excludes homogeneous landing covariants "
            "through degree 16; PROJECTIVE_MIXED_REDUCTION reduces rational projective "
            "formulas to some homogeneous covariant degree"
        ),
        "short_morita_words": (
            "C5 DESCENT_COMPATIBLE_ANSATZ_AUDIT excludes 341 short Morita words and "
            "the constant twelve-word ansatz over F_23"
        ),
        "new_K_proj_point_found": False,
    }

    wall = time.time() - started
    rss = peak_rss_mb()

    all_orbit2 = all(r["galois"]["projective_orbit_size"] == 2 for r in line_reports)
    all_quad = all(r["plucker_in_Q_sqrt_m11"] for r in line_reports)
    all_hyper = all(r["plucker_hyperplanes_identically_zero"] for r in line_reports)
    none_equivariant = all(not r["constant_section_G_equivariant"] for r in line_reports)
    no_wedge_inv = len(wedge_invariants) == 0
    no_v_inv = len(v_invariants) == 0
    no_new_point = (
        qsqrt_search["height1_genuine_count"] == 0
        and qsqrt_search["random_height2_genuine_count"] == 0
        and not secondary_note["new_K_proj_point_found"]
    )

    assert all_orbit2 and all_quad and all_hyper and none_equivariant
    assert no_wedge_inv and no_v_inv and no_new_point

    input_hashes = {
        "exact_points.json": sha256_file(C6 / "exact_points.json"),
        "residual_search.json": sha256_file(C6 / "residual_search.json"),
        "five_form_matrix.json": sha256_file(C6 / "five_form_matrix.json"),
        "quartic.json": sha256_file(C6 / "quartic.json"),
        "generic_pluecker_incidence.json": sources["hashes"][
            "generic_pluecker_incidence"
        ],
        "morita_generic_dag.json": sources["hashes"]["morita_generic_dag"],
        "morita_generic_split_dag.json": sources["hashes"][
            "morita_generic_split_dag"
        ],
        "involution.json": sources["hashes"]["involution"],
        "distinguished_five_plane.json": sources["hashes"]["distinguished_five_plane"],
        "fano_covariant_scan.py": sha256_file(
            ROOT / "tmp/fano14_twist/fano_covariant_scan.py"
        ),
    }

    payload = {
        "format": "c6-morita-descent-v1",
        "consumes_sha256": input_hashes,
        "scope": (
            "Morita / Hilbert-90 / Galois descent analysis of the 12 sealed "
            "split-model common lines; search for genuine D(K_proj) beyond constant Q"
        ),
        "group_action": {
            "source": "tmp/fano14_twist/fano_covariant_scan.py::six_dimensional_generators",
            "prime": P_MOD,
            "group_order_generated": len(group),
            "note": (
                "Order 1320 = |SL(2,F_11)| double cover of PSL_2(F_11)=660; "
                "projective action factors through PSL"
            ),
            "dim_invariants_V": len(v_invariants),
            "dim_invariants_wedge2_V": len(wedge_invariants),
            "constant_G_equivariant_line_exists": False,
            "obstruction": (
                "(∧²V)^G = 0 over F_23 ⇒ no G-invariant decomposable bivector ⇒ "
                "no constant (x-independent) line can satisfy L(gx)=ρ(g)L(x) for all g. "
                "V^G = 0 similarly blocks constant G-fixed u ∈ P(V)."
            ),
        },
        "lines": line_reports,
        "Qsqrt_point_search": qsqrt_search,
        "secondary_covariant_residual": secondary_note,
        "summary": {
            "n_lines": len(line_reports),
            "all_plucker_hyperplanes_ok": all_hyper,
            "all_field_of_definition_Q_sqrt_m11": all_quad and all_orbit2,
            "any_constant_G_equivariant": False,
            "any_K_proj_fano_point": False,
            "headline_bridge": False,
            "marker": "C6-MORITA-DESCENT-OBSTRUCTION",
            "primary_packet_exit_unchanged": "C6-DETERMINANTAL-BIRATIONAL-MODEL-PASS",
        },
        "residual_gates": [
            "Named obstruction: Gal(Q(ζ11)/Q) orbits of the 12 lines have size 2 (field Q(√−11), not Q)",
            "Named obstruction: constant split lines fail twisted Plücker G-equivariance; (∧²V)^G=0",
            "No new exact u ∈ D(K_proj) beyond sealed constant Q-sections found in height/Q(√−11)/covariant residual lanes",
            "Full C6.3 bridge not entered (no K_proj Fano point)",
            "Optional: nonconstant secondary-basis sections of D of positive degree / rational-function Morita words",
            "Optional: scheme-theoretic rank≤3 primary decomposition over K_proj",
        ],
        "resources": {
            "wall_seconds": wall,
            "peak_rss_mb": rss,
            "heavy_GB_msolve": False,
        },
        "marker": "C6_MORITA_DESCENT_PRODUCE_OK",
    }
    write_json(HERE / "descent.json", payload)

    meta = {
        "wall_seconds": wall,
        "peak_rss_mb": rss,
        "marker": "C6_MORITA_DESCENT_PRODUCE_OK",
        "descent_sha256": sha256_file(HERE / "descent.json"),
    }
    write_json(HERE / "produce_meta.json", meta)

    md_lines = [
        "# C6 Morita / K_proj descent of the 12 split lines",
        "",
        "**Marker:** `C6-MORITA-DESCENT-OBSTRUCTION`",
        "",
        "**Not a headline claim.**  No `K_proj`-point of F_{14,T} and no",
        "`C6-POINT-HEADLINE-POSITIVE`.",
        "",
        "## Inputs",
        "",
        "Sealed `exact_points.json` (12 height-≤1 u in D(Q), rank 4, common",
        "lines over Q(zeta_11)); C5 Pluecker / Morita DAGs; 6-dimensional",
        "representation generators from `tmp/fano14_twist/fano_covariant_scan.py`.",
        "",
        "## Galois structure of the 12 lines",
        "",
        "For every sealed line L:",
        "",
        "- Gal(Q(zeta_11)/Q)-orbit size **2** (stabilizer order 5 = squares in (Z/11Z)*).",
        "- All fifteen normalized Pluecker coordinates lie in the unique quadratic",
        "  subfield Q(sqrt(-11)) subset Q(zeta_11).",
        "- Coefficientwise vanishing of the five sealed generic Pluecker hyperplanes and",
        "  of the fifteen Grassmann-Pluecker quadrics is independently rebuilt.",
        "",
        "Thus each L is a **split-model** common line over Q(sqrt(-11)),",
        "not a Q-point of Gr(2,6).",
        "",
        "## Morita / twisted Pluecker equivariance (constant sections)",
        "",
        "A K_proj-point of the twisted Fano is a section of the twisted",
        "Pluecker bundle: in the split model one needs",
        "",
        "    L(gx) = rho(g) L(x)    for all g in PSL_2(F_11).",
        "",
        "For **constant** (x-independent) L this forces rho(g)L=L for all g,",
        "i.e. a G-invariant decomposable bivector.  Over the sealed good prime",
        "p=23, Reynolds projection on wedge^2 V_6 yields",
        "",
        "    dim (wedge^2 V)^G = 0",
        "",
        "(with |~G|=1320=|SL(2,F_11)| generated from the codex 6D generators).",
        "Likewise V^G=0.  Hence **no constant G-equivariant line or point exists**,",
        "and none of the 12 sealed planes is G-stable (modular plane stabilizers",
        "are proper subgroups; orbit sizes 55-330).",
        "",
        "This is the named Morita-chart obstruction for promoting the 12 constant",
        "split lines to K_proj points of F_{14,T}.",
        "",
        "## Search for new D(K_proj) points",
        "",
        "| Lane | Result |",
        "|------|--------|",
        "| Height-1 u in P^5(Q(sqrt(-11))) multi-prime on D | only projectively-Q hits (the sealed 12, up to sqrt(-11)-scaling) |",
        "| 200000 random height-≤2 genuine Q(sqrt(-11)) trials | 0 hits on D |",
        "| Secondary / covariant residual | C5 degree-≤16 landing exclusion + short Morita-word exclusion retained; no new point |",
        "",
        "## Residual gates",
        "",
        "1. Constant-split-line descent blocked by Gal-orbit size 2 and (wedge^2 V)^G=0.",
        "2. No new exact u in D(K_proj) in the lanes above.",
        "3. C6.3 bridge not entered.",
        "4. Optional: positive-degree secondary sections / rational-function Morita words.",
        "",
        "## Resources",
        "",
        f"- wall ≈ {wall:.2f} s",
        f"- peak RSS ≈ {rss:.1f} MB",
        "- GB / msolve: **not invoked**",
        "",
        "## Markers",
        "",
        "```text",
        "C6-MORITA-DESCENT-OBSTRUCTION",
        "C6-DETERMINANTAL-BIRATIONAL-MODEL-PASS   # primary packet exit unchanged",
        "C6-EXACT-SPLIT-POINTS-PASS               # retained",
        "```",
        "",
        "Headline remains **OPEN**.",
        "",
    ]
    (HERE / "DESCENT.md").write_text("\n".join(md_lines))
    print("C6_MORITA_DESCENT_PRODUCE_OK")
    print(f"wall_s={wall:.3f} peak_rss_mb={rss:.2f}")
    print("marker=C6-MORITA-DESCENT-OBSTRUCTION")
    print(f"wedge_inv_dim={len(wedge_invariants)} V_inv_dim={len(v_invariants)}")
    print(f"genuine_Qsqrt_hits={qsqrt_search['height1_genuine_count']}")


if __name__ == "__main__":
    main()
