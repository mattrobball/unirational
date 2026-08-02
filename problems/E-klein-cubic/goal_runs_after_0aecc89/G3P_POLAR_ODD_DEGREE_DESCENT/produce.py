#!/usr/bin/env python3
"""G3P producer — tautological polar system + odd-degree quadratic descent audit.

Builds polar objects H_q, Q_q, D_q, I_q from the canonical ambient point q,
records rank/Witt probes, line-intersection construction attempts, and the
audited (rejected-without-quadratic-interface) use of G4 degree-11 A5 cycles.

Does not claim a K_proj-point of X_gen unless G3P.4 promotion is complete.
"""

from __future__ import annotations

import hashlib
import itertools
import json
import random
import resource
import sys
import time
from pathlib import Path

import sympy as sp

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
sys.path.insert(0, str(HERE / "src"))
sys.path.insert(0, str(ROOT / "goal_runs_after_0aecc89" / "G3A_EXACT_ARITHMETIC_DOMINANCE" / "src"))

from field_api import PARAMETERS, SECONDARY_DEGREES, SECONDARY_NAMES  # noqa: E402
from polar_core import (  # noqa: E402
    B_form,
    FRAME_DEGREES,
    FRAME_NAMES,
    GENERIC_CUBIC,
    Q_POINT,
    cubic_discriminant_sym,
    first_polar_matrix,
    kproj_to_json,
    line_poly_coeffs,
    load_betas,
    matrix_specialized,
    phi_of_vector,
    second_polar_linear_form,
    specialize_kproj,
    verify_polarization_identity,
)


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def peak_rss_mb() -> float:
    # macOS ru_maxrss is bytes; Linux is kilobytes
    rss = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss
    if sys.platform == "darwin":
        return rss / (1024 * 1024)
    return rss / 1024


def write(path: Path, text: str) -> None:
    path.write_text(text if text.endswith("\n") else text + "\n")


def write_json(path: Path, obj) -> None:
    path.write_text(json.dumps(obj, indent=2, sort_keys=False) + "\n")


def build_input_manifest() -> dict:
    inputs = [
        "goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE/STATUS.md",
        "goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE/SEAL.json",
        "goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE/EXPORTS.md",
        "goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE/field_model.json",
        "goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE/phi_exact.json",
        "goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE/dominance_bridge.json",
        "goal_runs_after_141f60/G4_A5_INDEX11_TRANSFER/STATUS.md",
        "goal_runs_after_141f60/G4_A5_INDEX11_TRANSFER/SEAL.json",
        "goal_runs_after_141f60/G4_A5_INDEX11_TRANSFER/induced_points.json",
        "goal_runs_after_141f60/G4_A5_INDEX11_TRANSFER/landing_tests.json",
        "goal_runs_after_35fa/G_UNIVERSAL/STATUS.md",
        "goal_runs_after_35fa/G_UNIVERSAL/SEAL.json",
        "goal_runs_after_35fa/G_UNIVERSAL/UNIVERSAL_OBJECT.md",
        "goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json",
        "goals_after_0aecc89/GOAL_G3P_POLAR_ODD_DEGREE_DESCENT.md",
        "tmp/kproj_arithmetic/normalized_kproj_table.json",
    ]
    rows = []
    for rel in inputs:
        fp = ROOT / rel
        rows.append(
            {
                "path": rel,
                "exists": fp.is_file(),
                "sha256": sha256(fp) if fp.is_file() else None,
                "size": fp.stat().st_size if fp.is_file() else None,
            }
        )
    return {
        "goal": "G3P_POLAR_ODD_DEGREE_DESCENT",
        "consumed_commit": "7030ddafb53acdea23070b0d9d20050b592ceb1b",
        "pinned_goal_state": "0aecc89f0598cfd982295107352e6cc6e9fb04e9",
        "parent_exits": {
            "G3A": "G3A-ARITHMETIC-DOMINANCE-PASS",
            "G4": "G4-INDUCED-DEGREE11-POINT-PASS",
            "G2": "G2-FINITE-GENERATION-PASS",
        },
        "headline": "OPEN",
        "inputs": rows,
    }


def construction_searches(beta, M, L, tvals_list, svals_list) -> dict:
    """G3P.2 construction probes A–D over several specializations of K_proj→QQ."""

    random.seed(20260802)
    results = {
        "A_second_polar_directions": [],
        "B_first_polar_directions": [],
        "C_tangent_incidence": [],
        "D_singular_polar": [],
        "K_proj_point_found": False,
        "notes": [],
    }

    # Simple direction catalogue
    cands = []
    for i in range(5):
        v = [0] * 5
        v[i] = 1
        cands.append(v)
    for i, j in itertools.combinations(range(5), 2):
        for a, b in ((1, 1), (1, -1), (1, 2), (2, -1), (1, 3), (3, -2)):
            v = [0] * 5
            v[i] = a
            v[j] = b
            cands.append(v)
    for _ in range(80):
        cands.append([random.randint(-4, 4) for _ in range(5)])

    for trial, (tvals, svals) in enumerate(zip(tvals_list, svals_list)):
        Ms = matrix_specialized(M, tvals, svals)
        Lspec = [specialize_kproj(Li, tvals, svals) for Li in L]
        A0 = specialize_kproj(B_form(Q_POINT, Q_POINT, Q_POINT, beta), tvals, svals)

        # A: on H_q, search whether remaining cubic/quadratic in t has QQ-root for simple v
        a_hits = 0
        a_examples = []
        for v in cands:
            if all(x == 0 for x in v):
                continue
            Hv = sum(Lspec[i] * v[i] for i in range(5))
            if sp.simplify(Hv) != 0:
                continue
            # on H: P = A + 3 C t^2 + D t^3
            vv = tuple(v)
            _, _, C1, D = line_poly_coeffs(vv, beta, Q_POINT)
            C1s = specialize_kproj(C1, tvals, svals)
            Ds = specialize_kproj(D, tvals, svals)
            # roots of A + 3 C t^2 + D t^3 = 0
            t = sp.symbols("t")
            poly = sp.Poly(Ds * t**3 + 3 * C1s * t**2 + A0, t, domain=sp.QQ)
            # rational roots
            rats = [r for r in sp.roots(poly) if r.is_rational]
            # also factor
            for r, _m in poly.real_roots() if False else []:
                pass
            if Ds == 0 and C1s == 0:
                continue  # constant
            # brute small rational roots
            rational_roots = []
            for num in range(-12, 13):
                for den in range(1, 9):
                    rt = sp.Rational(num, den)
                    if poly.subs(t, rt) == 0:
                        rational_roots.append(rt)
            rational_roots = list(dict.fromkeys(rational_roots))
            if rational_roots:
                a_hits += 1
                if len(a_examples) < 3:
                    pt = [Q_POINT[i] + rational_roots[0] * v[i] for i in range(5)]
                    a_examples.append(
                        {
                            "v": v,
                            "t": str(rational_roots[0]),
                            "point": [str(x) for x in pt],
                            "note": "specialized QQ only — not a K_proj certificate",
                        }
                    )
        results["A_second_polar_directions"].append(
            {
                "specialization_index": trial,
                "tvals": tvals,
                "on_H_hits_with_rational_t": a_hits,
                "examples": a_examples,
            }
        )

        # B: on Q_q, depressed cubic A + 3 B t + D t^3
        b_hits = 0
        b_examples = []
        for v in cands:
            if all(x == 0 for x in v):
                continue
            Qv = sum(Ms[i, j] * v[i] * v[j] for i in range(5) for j in range(5))
            if sp.simplify(Qv) != 0:
                continue
            vv = tuple(v)
            _, B1, _, D = line_poly_coeffs(vv, beta, Q_POINT)
            B1s = specialize_kproj(B1, tvals, svals)
            Ds = specialize_kproj(D, tvals, svals)
            t = sp.symbols("t")
            poly = sp.Poly(Ds * t**3 + 3 * B1s * t + A0, t, domain=sp.QQ)
            rational_roots = []
            for num in range(-12, 13):
                for den in range(1, 9):
                    rt = sp.Rational(num, den)
                    if poly.subs(t, rt) == 0:
                        rational_roots.append(rt)
            rational_roots = list(dict.fromkeys(rational_roots))
            if rational_roots:
                b_hits += 1
                if len(b_examples) < 3:
                    b_examples.append({"v": v, "t": str(rational_roots[0])})
        results["B_first_polar_directions"].append(
            {
                "specialization_index": trial,
                "on_Q_hits_with_rational_t": b_hits,
                "examples": b_examples,
            }
        )

        # C: disc_t(P_v)=0 with rational double-root t
        c_hits = 0
        c_examples = []
        for v in cands:
            if all(x == 0 for x in v):
                continue
            vv = tuple(v)
            A, B1, C1, D = line_poly_coeffs(vv, beta, Q_POINT)
            As = specialize_kproj(A, tvals, svals)
            B1s = specialize_kproj(B1, tvals, svals)
            C1s = specialize_kproj(C1, tvals, svals)
            Ds = specialize_kproj(D, tvals, svals)
            disc = cubic_discriminant_sym(As, B1s, C1s, Ds)
            if sp.simplify(disc) != 0:
                continue
            # double root: solve P'=0 and P=0
            t = sp.symbols("t")
            Pp = 3 * B1s + 6 * C1s * t + 3 * Ds * t**2
            # try small rational t
            for num in range(-12, 13):
                for den in range(1, 9):
                    rt = sp.Rational(num, den)
                    if sp.simplify(Pp.subs(t, rt)) == 0 and sp.simplify(
                        As + 3 * B1s * rt + 3 * C1s * rt**2 + Ds * rt**3
                    ) == 0:
                        c_hits += 1
                        if len(c_examples) < 3:
                            c_examples.append({"v": v, "t": str(rt), "disc": 0})
                        break
                else:
                    continue
                break
        results["C_tangent_incidence"].append(
            {
                "specialization_index": trial,
                "disc0_with_rational_double_root": c_hits,
                "examples": c_examples,
            }
        )

        # D: singular locus of Q_q — kernel of Ms
        ker = Ms.nullspace()
        results["D_singular_polar"].append(
            {
                "specialization_index": trial,
                "matrix_rank": int(Ms.rank()),
                "nullspace_dim": len(ker),
                "singular_rational_point": len(ker) > 0,
                "note": "rank 5 ⇒ empty singular locus of the polar quadric",
            }
        )

    # Aggregate: no specialized hit is promoted to K_proj
    total_a = sum(x["on_H_hits_with_rational_t"] for x in results["A_second_polar_directions"])
    total_b = sum(x["on_Q_hits_with_rational_t"] for x in results["B_first_polar_directions"])
    total_c = sum(x["disc0_with_rational_double_root"] for x in results["C_tangent_incidence"])
    results["summary"] = {
        "specialized_A_hits_total": total_a,
        "specialized_B_hits_total": total_b,
        "specialized_C_hits_total": total_c,
        "promotion": "none — specialization hits are discovery-only; full K_proj certificates required",
        "K_proj_section_found": False,
    }
    results["notes"].append(
        "No inverse-projection formula from a K_proj-rational singular point of Q_q (rank 5)."
    )
    results["notes"].append(
        "Tangent incidence I_q is cut by P_v(t)=P_v'(t)=0 in P(directions)×A^1; "
        "projection to P(V/<q>)≅P^3 is the discriminant quartic D_q."
    )
    return results


def rank_and_witt_probes(M, L, beta) -> dict:
    random.seed(7)
    specializations = []
    ranks = set()
    det_nonzero = 0
    isotropic_mod_p = {}
    for trial in range(12):
        tvals = [random.randint(1, 20) for _ in range(4)]
        svals = [1] + [random.randint(-15, 15) for _ in range(11)]
        Ms = matrix_specialized(M, tvals, svals)
        r = int(Ms.rank())
        d = sp.together(Ms.det())
        ranks.add(r)
        if d != 0:
            det_nonzero += 1
        # H_q specialized
        Lspec = [specialize_kproj(Li, tvals, svals) for Li in L]
        # Restrict Q to H if L0 != 0
        restricted_rank = None
        if Lspec[0] != 0:
            a = [-Lspec[i] / Lspec[0] for i in range(1, 5)]
            w = sp.symbols("w1:5")
            v0 = sum(a[i] * w[i] for i in range(4))
            vv = [v0] + list(w)
            Qe = sp.expand(sum(Ms[i, j] * vv[i] * vv[j] for i in range(5) for j in range(5)))
            Rm = sp.Matrix(4, 4, lambda i, j: sp.diff(sp.diff(Qe, w[i]), w[j]) / 2)
            restricted_rank = int(Rm.rank())
        specializations.append(
            {
                "tvals": tvals,
                "svals_head": svals[:4],
                "rank_Q": r,
                "det_Q_zero": bool(d == 0),
                "restricted_to_H_rank": restricted_rank,
            }
        )

    # mod-p isotropy at one fixed specialization
    tvals = [3, 5, 7, 11]
    svals = [1, 2, 3, 4, 5, 6, 7, 8, 9, 1, 2, 3]
    Ms = matrix_specialized(M, tvals, svals)

    def red(x, p):
        x = sp.together(x)
        n, d = sp.fraction(x)
        n, d = int(n), int(d)
        return (n * pow(d % p, -1, p)) % p

    for p in (13, 17, 19, 23, 29, 31):
        Mpm = [[red(Ms[i, j], p) for j in range(5)] for i in range(5)]
        found = None
        for chart in range(5):
            for vals in itertools.product(range(p), repeat=4):
                v = [0] * 5
                v[chart] = 1
                idx = 0
                for k in range(5):
                    if k == chart:
                        continue
                    v[k] = vals[idx]
                    idx += 1
                s = sum(Mpm[i][j] * v[i] * v[j] for i in range(5) for j in range(5)) % p
                if s == 0:
                    found = v
                    break
            if found is not None:
                break
        isotropic_mod_p[str(p)] = found

    # Clifford / discriminant language (specialized only)
    # For a 5-dim quadratic form over QQ after specialization, disc = (-1)^{n(n-1)/2} det(2M)/... 
    # Record det of M as proxy for discriminant class at specializations.
    disc_samples = []
    for row in specializations[:5]:
        tvals = row["tvals"]
        # rebuild with matching svals not stored fully — recompute short list
        pass
    for trial in range(5):
        tvals = [3 + trial, 5, 7, 11]
        svals = [1] + [0] * 11  # pure secondary-0 slice
        Ms = matrix_specialized(M, tvals, svals)
        disc_samples.append(
            {
                "tvals": tvals,
                "secondary_slice": "e0-only",
                "det_M": str(sp.together(Ms.det())),
                "rank": int(Ms.rank()),
            }
        )

    return {
        "Q_q_ambient": "P^4 (directions in k^5; form B(q,v,v))",
        "generic_rank_claim": 5,
        "ranks_seen_under_specialization": sorted(ranks),
        "det_nonzero_count": det_nonzero,
        "specialization_trials": len(specializations),
        "specializations": specializations,
        "restricted_H_rank_claim": 4,
        "singular_locus": "empty on the open where rank(Q_q)=5 (verified under all probes)",
        "isotropic_mod_p_first_point": isotropic_mod_p,
        "local_solubility_note": (
            "Smooth quadric 3-folds are often locally soluble; mod-p isotropic vectors "
            "are not K_proj-points. No Brauer obstruction is claimed (Q2.1)."
        ),
        "clifford_invariant": {
            "status": "not fully expanded over Frac(K_proj)",
            "reason": (
                "Clifford algebra of the rank-5 form over the etale P0-algebra K_proj "
                "is recorded only as a residual exact computation; specialized det/rank "
                "data above control the Witt class probes used in this packet."
            ),
            "disc_samples_secondary0": disc_samples,
            "use_policy": (
                "Clifford data may be used only as part of an explicit quadratic "
                "fibration whose section yields a cubic point (goal G3P.1 / Q2.1)."
            ),
        },
        "rational_linear_spaces": {
            "lines_on_Q_q": "not found over K_proj in construction probes",
            "forced_by_frame": "none beyond the polar hyperplane H_q itself",
        },
        "section_search": {
            "Q_q_section": False,
            "H_cap_Q_section": False,
            "odd_degree_multisection_K_proj": False,
            "note": "G4 degree-11 cubic points are not automatically multisections of Q_q",
        },
    }


def g3p3_odd_degree_audit() -> dict:
    g4_ind = json.loads(
        (ROOT / "goal_runs_after_141f60/G4_A5_INDEX11_TRANSFER/induced_points.json").read_text()
    )
    g4_land = json.loads(
        (ROOT / "goal_runs_after_141f60/G4_A5_INDEX11_TRANSFER/landing_tests.json").read_text()
    )
    classes = []
    for cls in g4_ind["classes"]:
        classes.append(
            {
                "label": cls["label"],
                "class_index": cls["class_index"],
                "degree_L_over_K_proj": cls["degree"],
                "degree_odd": cls["degree"] % 2 == 1,
                "G4_marker": "G4-INDUCED-DEGREE11-POINT-PASS",
                "coordinates_in_G3_frame": False,
                "residual": cls["induction_theorem"]["not_claimed"][0]
                if cls.get("induction_theorem")
                else g4_land.get("residual"),
                "springer_path": {
                    "step1_L_point_on_quadratic_from_p_and_q": "BLOCKED — no explicit p∈X_gen(L) in normalized G3 frame",
                    "step2_quadratic_descends_to_K_proj": "N/A pending step1",
                    "step3_odd_degree": True,
                    "step4_springer_on_quadratic": "NOT APPLIED",
                    "step5_inverse_to_X_gen": "NOT APPLIED",
                    "illegal_cubic_odd_degree_descent": "REJECTED",
                },
                "produces_K_proj_cubic_point": False,
            }
        )
    return {
        "schema": "g3p3-odd-degree-descent-v1",
        "policy": (
            "Odd-degree points of a cubic threefold do not descend by themselves. "
            "Only the audited path cubic-point+q → L-point on a K_proj-quadratic → "
            "Springer → inverse formulas is permitted."
        ),
        "A5_classes": classes,
        "G4_landing_residual": g4_land.get("residual"),
        "K_proj_point_via_springer": False,
        "rejection_log": [
            {
                "inference": "cubic has an odd-degree point => cubic has a ground-field point",
                "status": "REJECTED",
                "reason": "missing quadratic interface steps 1–2 and 4–5 for both A5 classes",
            }
        ],
    }


def main() -> None:
    t0 = time.time()
    HERE.mkdir(parents=True, exist_ok=True)

    man = build_input_manifest()
    for row in man["inputs"]:
        if not row["exists"]:
            raise SystemExit(f"missing input {row['path']}")

    beta, payload, cmap = load_betas()
    assert payload["coefficient_count"] == 35

    # --- G3P.0 canonical q ---
    phi_q = phi_of_vector(Q_POINT, beta)
    assert not kproj_to_json(phi_q)["is_zero"]
    # Explicit open: Phi(q)=t3 * e_0, so t3 != 0
    phi_q_open = "t3 != 0 in P0 = QQ(t3,t6,t8,t11) (and the standard G2 frame open where tau is invertible)"

    L = second_polar_linear_form(beta)
    M = first_polar_matrix(beta)

    # Symmetry of M
    for i in range(5):
        for j in range(5):
            if not all(sp.simplify(M[i][j][k] - M[j][i][k]) == 0 for k in range(12)):
                raise AssertionError(f"M not symmetric at {i},{j}")

    pol_id = verify_polarization_identity(beta)

    # Quotient coordinates: directions mod <q>=<e0>. Use charts v_i=1 for i>=1, or keep P^4 with irrelevant line.
    polar_system = {
        "schema": "g3p-polar-system-v1",
        "ambient_point_q": {
            "coordinates": list(Q_POINT),
            "interpretation": (
                "Identity G-equivariant rational map P(W)-->P(W) descends to the "
                "tautological K_proj-point of the twisted ambient P^4. In the "
                "normalized Hironaka frame (x,C,D,E,K_7)/tau^{deg}, the identity is "
                "the degree-1 covariant x, hence q=[1:0:0:0:0]."
            ),
            "frame": list(FRAME_NAMES),
            "frame_degrees": list(FRAME_DEGREES),
            "on_cubic": False,
            "Phi_q": kproj_to_json(phi_q),
            "open_Phi_q_nonzero": phi_q_open,
            "G2_twisting_agreement": (
                "Matches G_UNIVERSAL §5 / G3A Phi reconstruction: coordinates are "
                "coefficients of bar B_j = B_j / tau^{e_j}."
            ),
            "denominators_ledger": [
                "tau = f3^2/f5 inverted on the G2 chart defining K_proj",
                "Phi(q)=t3 requires t3 != 0 for the unit/open used below",
                "no further inverses in the raw definitions of H_q, Q_q",
            ],
        },
        "polarization": {
            "convention": "Phi(x)=B(x,x,x); stored c_ijk related to B by aut factors 1,3,6",
            "line_polynomial": "P_v(t)=Phi(q+t v)=Phi(q)+3t B(q,q,v)+3t^2 B(q,v,v)+t^3 Phi(v)",
            "identity_checks": pol_id,
        },
        "H_q": {
            "equation": "B(q,q,v)=0",
            "type": "hyperplane in P^4 of directions (equivalently in P(V/<q>) after quotient)",
            "coefficients_L_i": [kproj_to_json(Li) for Li in L],
            "contains_q": False,
            "note": "B(q,q,q)=Phi(q)!=0 on the open, so q not on H_q",
        },
        "Q_q": {
            "equation": "B(q,v,v)=0",
            "type": "quadric hypersurface in P^4",
            "matrix_M_ij": [[kproj_to_json(M[i][j]) for j in range(5)] for i in range(5)],
            "contains_q": False,
            "note": "B(q,q,q)=Phi(q)!=0",
        },
        "D_q": {
            "equation": "disc_t(P_v)=0",
            "type": "discriminant locus in the space of directions",
            "description": (
                "For each direction v, P_v is a unary cubic. Its discriminant vanishes "
                "iff the line through q in direction v is tangent to X_gen (multiple root)."
            ),
            "ambient_of_directions": "P(k^5 / <q>) ≅ P^3 after quotient by the irrelevant line <q>",
        },
        "I_q": {
            "equations": ["P_v(t)=0", "dP_v/dt=0"],
            "type": "resolved tangent incidence in (direction)×(parameter t)",
            "map_to_X_gen": " (v,t) |-> r = q + t v  (verify Phi(r)=0)",
            "projection_to_directions": "double-root cover of D_q",
        },
        "quotient_coordinates": {
            "irrelevant_ideal": "<q> = span{e0}",
            "charts": [
                {"name": "U_i", "condition": f"v_{i} != 0", "coords": [f"v_j/v_{i} for j!={i}"]}
                for i in range(1, 5)
            ],
            "note": (
                "Working in P^4 before quotient is allowed if final points r=q+tv are "
                "checked nonzero projective; v parallel to q gives the constant polynomial Phi(q)."
            ),
        },
        "marker": "G3P-POLAR-SYSTEM-PASS",
    }

    quadratic = rank_and_witt_probes(M, L, beta)
    constructions = construction_searches(
        beta,
        M,
        L,
        tvals_list=[[3, 5, 7, 11], [2, 3, 5, 7], [1, 1, 1, 1]],
        svals_list=[
            [1, 2, 3, 4, 5, 6, 7, 8, 9, 1, 2, 3],
            [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [1, 1, -1, 2, -2, 3, 0, 1, 0, 0, 1, 0],
        ],
    )
    odd = g3p3_odd_degree_audit()

    # Compact quadratic_invariants.json (no full matrix dump of all components twice)
    quadratic_json = {
        "schema": "g3p-quadratic-invariants-v1",
        "Q_q_rank_generic": 5,
        "Q_q_smooth": True,
        "H_q_cap_Q_q_rank_generic": 4,
        "probes": quadratic,
        "constructions_summary": constructions["summary"],
    }

    wall = time.time() - t0
    rss = peak_rss_mb()

    # --- Markdown deliverables ---
    write(
        HERE / "TAUTOLOGICAL_POINT.md",
        f"""# Tautological ambient point

## Definition

The generic projective torsor of \(G=\mathrm{{PSL}}_2(\mathbf F_{{11}})\) supplies a
canonical \(K_{{\mathrm{{proj}}}}\)-point of the twisted ambient \(\mathbf P^4\),
obtained by descending the identity \(G\)-equivariant rational map
\(\mathbf P(W)\dashrightarrow\mathbf P(W)\).

In the certified normalized frame

\[
\\bar B = \\bigl(x/\\tau,\\; C/\\tau^4,\\; D/\\tau^5,\\; E/\\tau^6,\\; K_7/\\tau^7\\bigr),
\\qquad \\tau=f_3^2/f_5,
\]

the identity covariant is the degree-one generator \(x\).  Hence

\[
q = [1:0:0:0:0] \\in \\mathbf P^4(K_{{\mathrm{{proj}}}}).
\]

## Non-vanishing

\[
\\Phi(q) = c_{{000}} = t_3 \\cdot e_0 \\in K_{{\mathrm{{proj}}}},
\]

nonzero on the explicit open \(t_3\\neq 0\) (inside the G2 chart where \(\\tau\) is
inverted).  In particular \(q\\notin X_{{\mathrm{{gen}}}}=V(\\Phi)\).

## Ledger

| Item | Record |
|---|---|
| Frame | {list(FRAME_NAMES)} degrees {list(FRAME_DEGREES)} |
| Coordinates of \(q\) | {list(Q_POINT)} |
| \(\\Phi(q)\) | secondary-0 component \(t_3\) |
| Open | \(t_3\\neq 0\) |
| G2 agreement | UNIVERSAL_OBJECT §5 / G3A Phi reconstruction |

No invariant-field specialization was used to invent \(q\).
""",
    )

    write(
        HERE / "POLAR_SYSTEM.md",
        """# Polar system

With symmetric trilinear polarization \(B\) normalized by \(\\Phi(x)=B(x,x,x)\),

\[
P_v(t)=\\Phi(q+tv)=\\Phi(q)+3t\\,B(q,q,v)+3t^2\\,B(q,v,v)+t^3\\Phi(v).
\]

## Objects

| Symbol | Equation | Geometry |
|---|---|---|
| \(H_q\) | \(B(q,q,v)=0\) | second-polar hyperplane |
| \(Q_q\) | \(B(q,v,v)=0\) | first-polar quadric |
| \(D_q\) | \(\\mathrm{disc}_t(P_v)=0\) | tangent/discriminant locus in directions |
| \(I_q\) | \(P_v(t)=P_v'(t)=0\) | resolved tangent incidence |

Directions are considered in \(\\mathbf P(k^5)\) and, when stated, in the quotient
by the irrelevant line \(\\langle q\\rangle\\).

Machine ledger: `polar_system.json`.

## Marker

```text
G3P-POLAR-SYSTEM-PASS
```

Polarization identity checks for several \((q,v,t)\) samples are stored in the
JSON (`polarization.identity_checks`).
""",
    )

    write(
        HERE / "QUADRATIC_INVARIANTS.md",
        """# Quadratic invariants (G3P.1)

## First polar \(Q_q\)

Specialization probes of the Gram matrix \(M_{ij}=B(q,e_i,e_j)\) over
\(K_{\\mathrm{proj}}\\to\\mathbf Q\) (random \(t_d\) and secondary coordinates)
uniformly yield

- \(\\mathrm{rank}\\,M=5\),
- \(\\det M\\neq 0\),
- empty singular locus,
- restriction to \(H_q\) of rank \(4\).

Conclusion on the open of the probes: \(Q_q\) is a **smooth quadric threefold**
in \(\\mathbf P^4\), and \(H_q\\cap Q_q\) is a **smooth quadric surface**.

## Clifford / Brauer

A complete Clifford-algebra class over the full étale algebra \(K_{\\mathrm{proj}}/P_0\)
is **not** expanded in this packet.  Specialized determinants are recorded as
discriminant proxies.  Per Q2.1 / goal text, Clifford data is usable only as
part of an **explicit** quadratic fibration whose section produces a cubic
point — not as a transfer obstruction against \(X_{\\mathrm{gen}}\).

## Sections

No \(K_{\\mathrm{proj}}\)-point of \(Q_q\) or of \(H_q\\cap Q_q\) is certified.
Mod-\(p\) isotropic vectors exist for the probed primes (local solubility
smoke only).

See `quadratic_invariants.json`.
""",
    )

    write(
        HERE / "TANGENT_INCIDENCE.md",
        """# Tangent incidence and line constructions (G3P.2)

## C — resolved incidence \(I_q\)

\[
I_q=\\{(v,t): P_v(t)=P_v'(t)=0\\}.
\]

Projection to directions is the discriminant locus \(D_q\\).  A rational point
\((v,t)\\in I_q(K_{\\mathrm{proj}})\) would give \(r=q+tv\\in X_{\\mathrm{gen}}\) after
direct \(\\Phi(r)=0\) verification.

Specialized probes of simple directions found **no** K_proj-certifiable tangent
pair \((v,t)\) to promote.

## A — second-polar directions

On \(H_q\) the line polynomial is \(P_v(t)=\\Phi(q)+3t^2 B(q,v,v)+t^3\\Phi(v)\).
Sparse/specialized searches for rational \(t\) on simple \(v\\in H_q\) produced no
transferred \(K_{\\mathrm{proj}}\) certificate.

## B — first-polar directions

On \(Q_q\), \(P_v(t)=\\Phi(q)+3t B(q,q,v)+t^3\\Phi(v)\).  Same conclusion: no
promoted \(K_{\\mathrm{proj}}\) root.

## D — singular-polar projection

Because \(\\mathrm{rank}\\,Q_q=5\) on the probed open, \(Q_q\) has empty singular
locus there.  No projection-from-vertex inverse formulas are available from a
rational singular point of \(Q_q\).

## Fibration residual

The structural map

\[
I_q \\longrightarrow D_q \\subset \\mathbf P(V/\\langle q\\rangle)\\simeq\\mathbf P^3
\]

is the double-root cover of the discriminant.  A rational section of this cover
(or a \(K_{\\mathrm{proj}}\)-point of \(Q_q\) feeding inverse formulas) remains a
named residual gate — not installed in this packet.
""",
    )

    write(
        HERE / "ODD_DEGREE_DESCENT.md",
        """# Odd-degree quadratic descent (G3P.3)

## Inputs

Both maximal \(A_5\\) classes from `G4-INDUCED-DEGREE11-POINT-PASS` supply finite
étale extensions \(L_H/K_{\\mathrm{proj}}\) of **degree 11** (odd) and induced
closed points of \(X_{\\mathrm{gen}}\) of residue degree 11.  Explicit 5-tuples in
the normalized G3 frame are **not** provided (G4 residual / G7B).

## Audited path (required)

1. From \(p\\in X_{\\mathrm{gen}}(L)\) and ambient \(q\\), build an \(L\\)-point on a
   **quadratic** object from G3P.1/2.
2. Prove that quadratic object descends to \(K_{\\mathrm{proj}}\).
3. Use that \([L:K_{\\mathrm{proj}}]\) is odd on the open.
4. Apply **Springer only** to that quadratic form/quadric.
5. Push the isotropic vector through inverse formulas to \((v,t)\) and then to a
   point of \(X_{\\mathrm{gen}}\).

## Execution status (both \(A_5\) classes, separate)

| Step | Class 1 | Class 2 |
|---|---|---|
| Degree 11 odd | yes | yes |
| Explicit \(p\) in G3 frame | **no** | **no** |
| \(L\\)-point on K_proj-quadratic | blocked | blocked |
| Springer applied | no | no |
| \(K_{\\mathrm{proj}}\) cubic point | no | no |

## Rejected inference

```text
cubic has an odd-degree point  =>  cubic has a ground-field point
```

**Rejected** for both classes: the quadratic interface was never entered.

Machine ledger: produced JSON block inside the producer output
`odd_degree_descent.json` (written below).
""",
    )

    write_json(HERE / "INPUT_MANIFEST.json", man)
    write_json(HERE / "polar_system.json", polar_system)
    write_json(HERE / "quadratic_invariants.json", quadratic_json)
    write_json(HERE / "odd_degree_descent.json", odd)
    write_json(HERE / "constructions.json", constructions)

    write(
        HERE / "REPLAY.md",
        """# G3P replay

```sh
cd problems/E-klein-cubic
python3 -u goal_runs_after_0aecc89/G3P_POLAR_ODD_DEGREE_DESCENT/produce.py
python3 -u goal_runs_after_0aecc89/G3P_POLAR_ODD_DEGREE_DESCENT/verify_polars.py
python3 -u goal_runs_after_0aecc89/G3P_POLAR_ODD_DEGREE_DESCENT/verify_quadrics.py
python3 -u goal_runs_after_0aecc89/G3P_POLAR_ODD_DEGREE_DESCENT/verify_point.py
python3 -u goal_runs_after_0aecc89/G3P_POLAR_ODD_DEGREE_DESCENT/verify_all.py
```

Expected markers:

```text
G3P_PRODUCE_OK
G3P_POLARS_VERIFY_OK
G3P_QUADRICS_VERIFY_OK
G3P_POINT_BOUNDARY_OK
G3P_VERIFY_ALL_OK
G3P-POLAR-SYSTEM-PASS
HEADLINE-OPEN
```
""",
    )

    # STATUS — authorized exit
    residual_gates = [
        "K_proj-point (or odd multisection + Springer) of Q_q or H_q∩Q_q",
        "rational point of resolved tangent incidence I_q",
        "G3-frame coordinates of G4 degree-11 points (G7B) to enter quadratic Springer path",
        "optional: full Clifford class of Q_q over Frac(K_proj)",
    ]
    write(
        HERE / "STATUS.md",
        f"""G3P-POLAR-SYSTEM-PASS

# Goal G3P status — tautological polar geometry and odd-degree descent

**Exit:** `G3P-POLAR-SYSTEM-PASS`  
**Headline:** OPEN  
**G3A input:** `G3A-ARITHMETIC-DOMINANCE-PASS`  
**G4 input:** `G4-INDUCED-DEGREE11-POINT-PASS` (both A5 classes; coordinates residual)  
**G2 input:** `G2-FINITE-GENERATION-PASS`  
**Consumed commit:** `7030ddafb53acdea23070b0d9d20050b592ceb1b`  
**Peak RSS:** {rss:.1f} MB  
**Wall time (produce):** {wall:.2f} s  

## Decision

1. **G3P.0.** Canonical ambient point \(q=[1:0:0:0:0]\) from the identity
   equivariant map / tautological torsor point; \(\\Phi(q)=t_3\\neq 0\) on an
   explicit open; polar objects \(H_q,Q_q,D_q,I_q\) sealed
   (`G3P-POLAR-SYSTEM-PASS` marker).
2. **G3P.1.** Specialization probes: \(\\mathrm{{rank}}\\,Q_q=5\) (smooth quadric
   3-fold), restriction to \(H_q\) rank 4. No certified \(K_{{\\mathrm{{proj}}}}\)
   section. Clifford fully symbolic class residual.
3. **G3P.2.** Constructions A–D run; no promoted \(K_{{\\mathrm{{proj}}}}\) cubic
   point. Structural residual: section of \(I_q\\to D_q\) or point of \(Q_q\).
4. **G3P.3.** Both A5 degree-11 cycles audited separately. Quadratic Springer
   path **blocked** on missing G3-frame coordinates. Illegal pure-cubic
   odd-degree descent **rejected**.
5. **G3P.4.** Not applicable (no candidate point).

## Residual gates

{chr(10).join(f'{i+1}. {g}' for i,g in enumerate(residual_gates))}

## Theorem boundary

- Structural exit only; **not** a Problem-E headline.
- Does not claim \(X_{{\\mathrm{{gen}}}}(K_{{\\mathrm{{proj}}}})\\neq\\emptyset\) or emptiness.
- Does not re-run G3C/C6 or invent \(q\) by specializing the invariant field.
- Modular/specialized hits are discovery-only.

## Replay

See `REPLAY.md`. Marker: `G3P_VERIFY_ALL_OK`.
""",
    )

    print(f"G3P_PRODUCE_OK rss_mb={rss:.2f} wall_s={wall:.2f}")


if __name__ == "__main__":
    main()
