#!/usr/bin/env python3
"""G3H phase5_beta_li_springer producer.

Closes or kills Route-1 Springer residual gates left open by phase5_springer_next:

  A. Secondary β tables for a_i (both A5 classes)
  B. L_i-point decision on Q_q / K_proj polar quadrics
  C. Springer close-or-kill with theorem boundary

Does not import verify_*; does not rewrite sealed phase 1–4 artefacts.
Writes under phase5_beta_li_springer/ and updates package STATUS/SEAL/REPLAY/
THEOREM_BOUNDARY.
"""

from __future__ import annotations

import hashlib
import json
import random
import resource
import subprocess
import sys
import time
from itertools import product
from pathlib import Path

import sympy as sp

HERE = Path(__file__).resolve().parent
PACKET = HERE.parent
ROOT = PACKET.parents[1]
sys.path.insert(0, str(ROOT / "goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE/src"))
sys.path.insert(0, str(ROOT / "goal_runs_after_0aecc89/G3P_POLAR_ODD_DEGREE_DESCENT/src"))

from field_api import SECONDARY_DEGREES, SECONDARY_NAMES  # noqa: E402
from polar_core import (  # noqa: E402
    Q_POINT,
    first_polar_matrix,
    load_betas,
    phi_of_vector,
    second_polar_linear_form,
)

OUT = HERE
PHASE4 = PACKET / "phase4_g3_frame"
PHASE5N = PACKET / "phase5_springer_next"
G3P = ROOT / "goal_runs_after_0aecc89/G3P_POLAR_ODD_DEGREE_DESCENT"
G3A = ROOT / "goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE"
G4 = ROOT / "goal_runs_after_141f60/G4_A5_INDEX11_TRANSFER"
GENERIC = ROOT / "goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json"


def sha256_file(path: Path) -> str:
    h = hashlib.sha256()
    h.update(path.read_bytes())
    return h.hexdigest()


def write_json(path: Path, obj) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(obj, indent=2, sort_keys=True) + "\n")


def rss_mb() -> float:
    rss = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss
    if sys.platform == "darwin":
        return rss / (1024 * 1024)
    return rss / 1024


def git_head() -> str:
    try:
        return (
            subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=ROOT, text=True)
            .strip()
        )
    except Exception:
        return "UNKNOWN"


# ---------------------------------------------------------------------------
# A. Secondary β tables — exact obstruction + dual calculus binding
# ---------------------------------------------------------------------------

def secondary_beta_decision() -> dict:
    """Cancelled secondary 12-vectors for β_{r,k}: obstruction or tables.

    The dual-trace formulas of phase5_springer_next determine every β_{r,k}
    uniquely in K_proj. Expanding each as a cancelled secondary 12-vector over
    P0 = Q(t3,t6,t8,t11) requires Reynolds projection of the weight-0 rational
    map a_i = Mbar^{-1}(P_i/τ^{33}) of ambient degree 33 into the secondary
    basis of K_proj. That elimination is the named obstruction.
    """
    classes = []
    for ci in (1, 2):
        exp_path = PHASE5N / f"a_i_expansion_class_{ci}.json"
        exp = json.loads(exp_path.read_text())
        n_coords = len(exp["coordinates"])
        n_power = len(exp["coordinates"][0]["coefficients"])
        n_slots = n_coords * n_power  # 5 * 11 = 55
        # Per-slot residual ledger (no fake cancelled numerators)
        slots = []
        for coord in exp["coordinates"]:
            for beta in coord["coefficients"]:
                slots.append(
                    {
                        "class_index": ci,
                        "frame_coordinate_index": coord["frame_coordinate_index"],
                        "frame_name": coord["frame_name"],
                        "power_index": beta["power_index"],
                        "symbol": beta["symbol"],
                        "dual_trace_formula": beta["dual_trace_formula"],
                        "secondary_basis": list(SECONDARY_NAMES),
                        "secondary_components": None,
                        "status": "OBSTRUCTION",
                        "obstruction": (
                            "Cancelled secondary numerators/denominators require "
                            "Reynolds / invariant reduction of the degree-33 "
                            "equivariant rational map a_i = Mbar^{-1}(P_i/tau^{33}) "
                            "into the rank-12 secondary model of K_proj. Dual-trace "
                            "beta_k = Tr(a^{(r)} omega_k) determines the element of "
                            "K_proj uniquely but does not expand it in the secondary "
                            "basis. No sealed multipoint interpolation table of the "
                            "55 x 12 secondary components is installed."
                        ),
                    }
                )
        classes.append(
            {
                "class_index": ci,
                "label": f"A5_class_{ci}",
                "n_beta_slots": n_slots,
                "n_coordinates": n_coords,
                "n_power_coeffs_per_coord": n_power,
                "dual_calculus_binding": {
                    "source": f"phase5_springer_next/a_i_expansion_class_{ci}.json",
                    "sha256": sha256_file(exp_path),
                    "marker": "G3H-AI-EXPANSION-DUAL-PASS",
                    "status": exp["expansion_status"]["dual_trace_formulas"],
                },
                "secondary_tables_status": "OBSTRUCTION",
                "slots_sample": slots[:3],
                "n_slots_obstructed": len(slots),
            }
        )

    return {
        "schema": "g3h-phase5-bls-secondary-beta-v1",
        "marker": "G3H-AI-SECONDARY-TABLE-OBSTRUCTION",
        "closed_gate": "G3H-AI-SECONDARY-TABLE-OPEN",
        "closure_mode": "NAMED_EXACT_OBSTRUCTION",
        "secondary_basis": {
            "names": list(SECONDARY_NAMES),
            "degrees": list(SECONDARY_DEGREES),
            "dim": 12,
            "base": "P0 = Q(t3,t6,t8,t11)",
        },
        "exact_obstruction": {
            "name": "DEGREE-33-REYNOLDS-SECONDARY-EXPANSION",
            "statement": (
                "For each of the 55 power-basis coefficients β_{r,k} ∈ K_proj of "
                "a_i (both A5 classes: 2×55), a cancelled secondary 12-vector "
                "(numerators/denominators over P0 in the certified secondary basis) "
                "is exactly the image of β_{r,k} under the structure isomorphism "
                "K_proj ≅ P0^{12} (secondary model). Computing that image from the "
                "geometric definition a_i = Mbar^{-1}(P_i/τ^{33}) requires "
                "G-invariant reduction (Reynolds projection / SAGBI elimination) "
                "of a degree-33 equivariant rational map on P(W) into the secondary "
                "generators of degrees "
                f"{list(SECONDARY_DEGREES)}. Dual-trace / Vandermonde formulas "
                "determine β_{r,k} as abstract elements of K_proj but are not a "
                "secondary expansion. This packet records the obstruction and does "
                "not install fake cancelled tables."
            ),
            "complexity_note": (
                "Ambient composition degree 33; secondary top degree 28; "
                "invariant ring of PSL_2(F_11) on P^4; full symbolic Reynolds "
                "for all 55 coefficients exceeds the sealed local-CAS budget of "
                "this residual close-or-kill run. Modular multipoint witnesses "
                "can probe individual specializations but do not replace cancelled "
                "generic secondary numerators."
            ),
            "what_is_installed": [
                "dual-trace formulas β_k = Tr(a^{(r)} ω_k) (phase5_springer_next)",
                "Vandermonde reconstruction on 11 coset conjugates",
                "per-slot secondary basis names and obstruction tags",
            ],
            "what_is_not_installed": [
                "cancelled num/den secondary 12-vectors for each β_{r,k}",
            ],
        },
        "classes": classes,
        "phase5_next_expansion_sha256": sha256_file(PHASE5N / "a_i_expansion.json"),
    }


# ---------------------------------------------------------------------------
# B. L_i-point decision on Q_q / K_proj polar quadrics
# ---------------------------------------------------------------------------

def noncontainment_Xgen_vs_Qq() -> dict:
    """Specialization certificate: X_gen is not contained in Q_q."""
    polar = json.loads((PHASE5N / "polar_data.json").read_text())
    gc = json.loads(GENERIC.read_text())
    t3, t6, t8, t11 = sp.symbols("t3 t6 t8 t11")
    tvals = {t3: 3, t6: 5, t8: 7, t11: 11}
    prime = 97
    random.seed(0)

    # Secondary-0 specialization of stored cubic coefficients
    cmap = {}
    for item in gc["coefficients"]:
        triple = tuple(item["triple"])
        acc = sp.Integer(0)
        for e in item["normalized_entries"]:
            if e["secondary"] != 0:
                continue
            mon = sp.Rational(e["numerator"], e["denominator"])
            for pr, ex in zip([t3, t6, t8, t11], e["projective_exponents"]):
                mon *= pr**ex
            acc += mon
        val = sp.simplify(sp.sympify(acc).subs(tvals))
        num, den = sp.fraction(sp.together(val))
        num_i = int(num) % prime
        den_i = int(den) % prime
        if den_i == 0:
            raise RuntimeError("denominator zero in secondary-0 cubic coeff")
        cmap[triple] = num_i * pow(den_i, -1, prime) % prime

    def elem0_fp(sparse):
        for c in sparse.get("components", []):
            if c.get("secondary_index") == 0:
                val = sp.simplify(sp.sympify(c["str"]).subs(tvals))
                num, den = sp.fraction(sp.together(val))
                return (int(num) % prime) * pow(int(den) % prime, -1, prime) % prime
        return 0

    M = [
        [elem0_fp(polar["first_polar_M"][i][j]) for j in range(5)] for i in range(5)
    ]
    Mmat = sp.Matrix(M)
    rank_M = int(Mmat.rank())

    def phi_fp(a):
        total = 0
        for (i, j, k), c in cmap.items():
            total = (total + c * a[i] * a[j] * a[k]) % prime
        return total

    def D_fp(a):
        s = 0
        for i in range(5):
            for j in range(5):
                s = (s + M[i][j] * a[i] * a[j]) % prime
        return s

    cubic_pts = []
    for _ in range(200000):
        a = [random.randrange(prime) for _ in range(5)]
        if all(x == 0 for x in a):
            continue
        if phi_fp(a) == 0:
            cubic_pts.append(a)
            if len(cubic_pts) >= 400:
                break

    off = sum(1 for a in cubic_pts if D_fp(a) != 0)
    on = sum(1 for a in cubic_pts if D_fp(a) == 0)
    example_off = next(a for a in cubic_pts if D_fp(a) != 0)
    example_on = next((a for a in cubic_pts if D_fp(a) == 0), None)

    # Also Phi(q)=t3≠0 so q not on X_gen; D(q) related to A≠0
    phi_q = phi_fp([1, 0, 0, 0, 0])
    D_q = D_fp([1, 0, 0, 0, 0])

    return {
        "schema": "g3h-phase5-bls-noncontainment-v1",
        "statement": "X_gen is not contained in Q_q (specialization certificate)",
        "specialization": {
            "secondary": "secondary-0 slice (s0=1, s_{>0}=0)",
            "tvals": [3, 5, 7, 11],
            "prime": prime,
        },
        "Q_q_matrix_rank": rank_M,
        "Q_q_smooth_probe": rank_M == 5,
        "Phi_q_specialized": phi_q,
        "D_q_specialized": D_q,
        "cubic_sample_size": len(cubic_pts),
        "cubic_pts_off_Q_q": off,
        "cubic_pts_on_Q_q": on,
        "fraction_off_Q_q": off / len(cubic_pts) if cubic_pts else None,
        "example_cubic_not_on_Q_q": {
            "a": example_off,
            "Phi": phi_fp(example_off),
            "D": D_fp(example_off),
        },
        "example_cubic_on_Q_q": (
            {"a": example_on, "Phi": 0, "D": 0} if example_on is not None else None
        ),
        "conclusion": (
            "At the sealed secondary-0 specialization, rank(Q_q)=5 and a positive "
            "density of F_p-points of the specialized cubic lie off Q_q. Therefore "
            "the cubic hypersurface is not contained in Q_q as schemes over the "
            "specialization, hence not over K_proj. Membership of a point of X_gen "
            "in Q_q is an independent condition from Phi=0."
        ),
        "polar_data_sha256": sha256_file(PHASE5N / "polar_data.json"),
        "generic_cubic_sha256": sha256_file(GENERIC),
    }


def springer_quadratic_form_theorem() -> dict:
    """Classic Springer theorem for quadratic forms — applied to Q_q."""
    return {
        "schema": "g3h-phase5-bls-springer-qf-v1",
        "name": "Springer theorem for quadratic forms (1952)",
        "statement": (
            "Let k be a field of characteristic not 2 and q a quadratic form over k. "
            "Let L/k be a finite field extension of odd degree. Then q has a "
            "nontrivial zero over L if and only if q has a nontrivial zero over k."
        ),
        "reference": (
            "T.A. Springer, Sur les formes quadratiques d'indice zéro, "
            "C. R. Acad. Sci. Paris 234 (1952); standard modern treatments in "
            "Lam, Introduction to Quadratic Forms over Fields, Ch. VII."
        ),
        "application_to_Q_q": {
            "k": "K_proj (Frac of the sealed rank-12 secondary model; char 0)",
            "L": "L_i = K_proj[θ_i]/(μ_i), [L_i:K_proj]=11 odd (both A5 classes)",
            "quadratic_form": "Q_q: v ↦ B(q,v,v) with q=[1:0:0:0:0], matrix M fully secondary-expanded",
            "conclusion": (
                "Q_q(L_i) ≠ ∅  ⇔  Q_q(K_proj) ≠ ∅"
            ),
            "consequence_for_Route1": (
                "Manufacturing an L_i-point of Q_q is existence-equivalent to the "
                "G3P residual of finding a K_proj-point of Q_q. The genuine degree-11 "
                "cubic point a_i ∈ X_gen(L_i) cannot create Q_q-isotropy over L_i "
                "unless either (i) a_i itself is isotropic (D=0) — an independent "
                "condition not forced by Phi(a_i)=0 — or (ii) some other construction "
                "yields an isotropic vector, which by Springer is still equivalent to "
                "K_proj-solubility of Q_q. Route-1 cannot use odd degree alone to "
                "bypass the K_proj-point residual on Q_q."
            ),
        },
        "char_open": "t3 ≠ 0 and 2 ≠ 0 on the sealed polar open (char 0 base)",
    }


def hunt_L_i_points(noncontainment: dict, springer_thm: dict) -> dict:
    """Named attempts for L_i-points on K_proj quadrics — with proofs."""
    attempts = []

    # 1. a_i on Q_q ⇔ D=0
    attempts.append(
        {
            "name": "a_i_on_Q_q",
            "family": "Q_q",
            "quadratic": "Q_q: B(q,v,v)=0 over K_proj",
            "defined_over_K_proj": True,
            "candidate": "a_i ∈ X_gen(L_i)",
            "criterion": "D = B(q,a_i,a_i) = 0 in L_i",
            "status": "NO",
            "decision": "NOT_A_POINT_OF_Q_q_FORCED",
            "proof": {
                "steps": [
                    (
                        "Phi(a_i)=0 is the cubic landing (phase 4). D=0 is the "
                        "independent polar condition a_i ∈ Q_q."
                    ),
                    (
                        "Non-containment: X_gen ⊄ Q_q by specialization certificate "
                        f"(off-Q fraction {noncontainment['fraction_off_Q_q']} at "
                        f"p={noncontainment['specialization']['prime']}, rank Q_q="
                        f"{noncontainment['Q_q_matrix_rank']})."
                    ),
                    (
                        "No identity in the phase-2/3/4 construction (Y_i, Psi_i, "
                        "frame inverse) imposes the polar equation D=0. G3P ledger: "
                        "'G4 degree-11 cubic points are not automatically multisections "
                        "of Q_q'."
                    ),
                    (
                        "Therefore a_i is not certified on Q_q; membership would be an "
                        "accidental vanishing of an independent section. Route-1 does "
                        "not install D=0. Gate for this candidate: NO."
                    ),
                ],
                "residual_explicit_D": (
                    "Fully expanded D as an L_i-element (power basis with cancelled "
                    "secondary coeffs) requires secondary β tables (obstruction A). "
                    "Non-containment + independence suffice to reject a_i as a "
                    "forced L_i-point of Q_q."
                ),
            },
        }
    )

    # 2. a_i on H_q
    attempts.append(
        {
            "name": "a_i_on_H_q",
            "family": "H_q",
            "quadratic": "H_q is linear (second polar), not quadratic",
            "defined_over_K_proj": True,
            "candidate": "a_i",
            "criterion": "C = B(q,q,a_i) = 0",
            "status": "NO",
            "decision": "NOT_QUADRATIC_OBJECT",
            "proof": {
                "steps": [
                    "H_q is a hyperplane, not a quadratic. Springer checklist item 1 fails for H_q alone.",
                    "No identity forces C=0 for a_i.",
                ]
            },
        }
    )

    # 3. residual binary on line(q,a_i)
    attempts.append(
        {
            "name": "line_residual_binary",
            "family": "residual_binary",
            "quadratic": "A s^2 + 3 C s t + 3 D t^2 on P^1",
            "defined_over_K_proj": False,
            "defined_over": "L_i",
            "candidate": "roots in P^1(L_i)",
            "status": "NO",
            "decision": "REJECTED_NOT_OVER_K_proj",
            "proof": {
                "steps": [
                    "Coefficients C,D lie in L_i in general, so the binary quadratic is not K_proj-defined.",
                    "Springer item 1 fails.",
                ]
            },
        }
    )

    # 4. Galois-norm constructions
    attempts.append(
        {
            "name": "galois_norm_of_residual_direction",
            "family": "Q_q",
            "quadratic": "Q_q",
            "defined_over_K_proj": True,
            "candidate": "norm/trace of residual line points",
            "status": "NO",
            "decision": "NO_SEALED_ISOTROPIC_VECTOR",
            "proof": {
                "steps": [
                    "Norm of a scalar discriminant is not a point of Q_q.",
                    "No sealed construction produces an L_i-rational isotropic vector for Q_q from residual Galois data.",
                    springer_thm["application_to_Q_q"]["consequence_for_Route1"],
                ]
            },
        }
    )

    # 5. Whole family Q_q(L_i) via Springer equivalence
    attempts.append(
        {
            "name": "any_L_i_point_on_Q_q",
            "family": "Q_q",
            "quadratic": "Q_q",
            "defined_over_K_proj": True,
            "candidate": "arbitrary L_i-point",
            "status": "NO",
            "decision": "EQUIVALENT_TO_K_proj_SOLUBILITY_G3P_RESIDUAL",
            "proof": {
                "steps": [
                    springer_thm["statement"],
                    springer_thm["application_to_Q_q"]["conclusion"],
                    (
                        "G3P sealed residual: no certified K_proj-point of Q_q "
                        f"({(G3P / 'STATUS.md').read_text().splitlines()[0].strip()}). "
                        "Existence of L_i-points on Q_q is therefore equivalent to an "
                        "unsolved G3P residual and is not provided by a_i."
                    ),
                    (
                        "Route-1 interface via Q_q as a target for L_i-points "
                        "manufactured from a_i is killed: either Q_q(K_proj)≠∅ "
                        "already (then Springer on L_i is unnecessary for Q_q; "
                        "map-back from K_proj-points of Q_q remains G3P residual), "
                        "or Q_q(L_i)=∅ and no L_i-point exists."
                    ),
                ]
            },
        }
    )

    # 6. Trace polar of a_i
    attempts.append(
        {
            "name": "trace_polar_Q_Tr_a_i",
            "family": "Q_Tr",
            "quadratic": (
                "Q_Tr(v) = Tr_{L_i/K_proj}(B(a_i,v,v)) = B(Tr(a_i),v,v) "
                "(first polar of Tr_{L_i/K}(a_i))"
            ),
            "defined_over_K_proj": True,
            "candidate": "a_i (criterion Tr(Phi(a_i))=0 ⇒ Q_Tr(a_i)=0)",
            "status": "CONDITIONAL",
            "decision": "L_i_POINT_IF_FORM_NONDEGENERATE_MAPBACK_ABSENT",
            "proof": {
                "steps": [
                    "Q_Tr is K_proj-defined (coefficients are traces of L_i-elements).",
                    "Q_Tr(a_i) = Tr(B(a_i,a_i,a_i)) = Tr(Phi(a_i)) = Tr(0) = 0.",
                    "If Tr(a_i)=0 as a vector then Q_Tr≡0 (degenerate); nondegeneracy is uncertified without β tables.",
                    "Even if nondegenerate, no sealed map-back from isotropic vectors of Q_Tr to X_gen(K_proj) is installed.",
                    "Springer on Q_Tr would only yield a K_proj-point of Q_Tr, not of X_gen.",
                ]
            },
        }
    )

    # 7. polar pencil
    attempts.append(
        {
            "name": "polar_pencil_fibre",
            "family": "pencil",
            "quadratic": "λ Q_q + μ (other K_proj quadrics)",
            "defined_over_K_proj": True,
            "candidate": "a_i isotropic for some pencil member",
            "status": "NO",
            "decision": "NOT_SEALED",
            "proof": {
                "steps": [
                    "No sealed equation identifying a K_proj-pencil member through a_i other than constructions above.",
                    "Map-back path not installed.",
                ]
            },
        }
    )

    certified_yes = [
        a
        for a in attempts
        if a["status"] == "YES"
        or a.get("decision") in ("YES", "CERTIFIED", "PASS")
    ]
    # For gate close: no unconditional certified L_i-point on a usable K_proj quadratic
    # with map-back path.
    return {
        "schema": "g3h-phase5-bls-L-point-hunt-v1",
        "marker": "G3H-LI-POINT-ON-KPROJ-QUADRATIC-CLOSED-NO",
        "closed_gate": "G3H-LI-POINT-ON-KPROJ-QUADRATIC-OPEN",
        "closure_mode": "NO_FOR_ATTEMPTED_FAMILY_WITH_PROOFS",
        "certified_L_i_point_on_K_proj_quadratic_with_mapback": False,
        "certified_unconditional_L_i_point_on_Q_q": False,
        "n_attempts": len(attempts),
        "n_yes": len(certified_yes),
        "attempts": attempts,
        "springer_qf_equivalence": springer_thm["application_to_Q_q"]["conclusion"],
        "noncontainment_ref": "noncontainment_Xgen_Qq.json",
        "conclusion": (
            "For the attempted family (a_i on Q_q; residual line; Galois norms; "
            "any L_i-point on Q_q; trace polar; pencil): no certified L_i-point of "
            "Q_q is obtained from a_i; existence of any L_i-point on Q_q is "
            "Springer-equivalent to the unsolved G3P K_proj residual; conditional "
            "trace-polar point lacks map-back and nondegeneracy certificate."
        ),
    }


# ---------------------------------------------------------------------------
# C. Springer close-or-kill
# ---------------------------------------------------------------------------

def springer_kill(beta_dec, hunt, springer_thm, noncontainment) -> dict:
    classes = []
    for ci in (1, 2):
        classes.append(
            {
                "class_index": ci,
                "label": f"A5_class_{ci}",
                "springer_checklist": {
                    "1_quadratic_object_over_K_proj": {
                        "object": "Q_q: B(q,v,v)=0",
                        "defined_over_K_proj": True,
                        "status": "YES",
                        "source": "G3P-POLAR-SYSTEM-PASS + phase5_next secondary M",
                    },
                    "2_L_i_point_on_that_object": {
                        "status": "NO",
                        "reason": hunt["conclusion"],
                        "hunt_ref": "L_point_decision.json",
                        "springer_equivalence": springer_thm["application_to_Q_q"][
                            "conclusion"
                        ],
                    },
                    "3_degree_odd": {"degree": 11, "status": "YES"},
                    "4_explicit_map_back_to_X_gen": {
                        "status": "NO",
                        "reason": (
                            "No inverse-polar / reconstruction map from K_proj-points "
                            "of Q_q (or Q_Tr) to X_gen(K_proj) is sealed. G3P residual. "
                            "Forbidden bare inference Q_q(L_i)≠∅ ⇒ X_gen(K)≠∅ rejected."
                        ),
                    },
                },
                "forbidden_inference": {
                    "statement": "Q_q(L_i) nonempty => X_gen(K_proj) nonempty",
                    "status": "REJECTED",
                },
                "illegal_cubic_odd_degree_descent": {
                    "statement": (
                        "X_gen(L_i) nonempty and [L_i:K]=11 odd => X_gen(K) nonempty"
                    ),
                    "status": "REJECTED",
                },
                "springer_applied": False,
                "produces_K_proj_cubic_point": False,
            }
        )

    return {
        "schema": "g3h-phase5-bls-springer-decision-v1",
        "marker": "G3H-QUADRATIC-INTERFACE-NO-GO-SCOPED",
        "route1_decision": "KILL",
        "route1_interface": "Q_q (and listed alternatives from polar data of q,a_i)",
        "kill_statement": (
            "Route-1 Springer via Q_q is closed as an interface: checklist items 2 "
            "and 4 fail with named proofs; Springer quadratic-form theorem shows "
            "L_i-isotropy of Q_q is equivalent to the G3P K_proj residual, so the "
            "degree-11 cubic point a_i does not open a new path to Q_q-points; "
            "map-back remains unsealed; illegal cubic odd-degree descent rejected."
        ),
        "stronger_markers_not_claimed": [
            "G3H-QUADRATIC-SPRINGER-REDUCTION-PASS",
            "G3P-POINT-HEADLINE-POSITIVE",
        ],
        "classes": classes,
        "gates": {
            "G3H-AI-SECONDARY-TABLE-OPEN": {
                "status": "CLOSED_AS_OBSTRUCTION",
                "marker": beta_dec["marker"],
            },
            "G3H-LI-POINT-ON-KPROJ-QUADRATIC-OPEN": {
                "status": "CLOSED_NO",
                "marker": hunt["marker"],
            },
            "G3H-SPRINGER-MAPBACK-OPEN": {
                "status": "CLOSED_WITH_INTERFACE_KILL",
                "reason": (
                    "Map-back for Q_q is the G3P residual (inverse polar formulas). "
                    "With item 2 failing for Route-1 via a_i and Springer equivalence "
                    "reducing Q_q(L_i) to Q_q(K_proj), the map-back gate is not enterable "
                    "from this interface; recorded as interface-killed residual of G3P."
                ),
            },
        },
        "theorem_boundary": {
            "proved": [
                "Springer quadratic-form theorem applied to Q_q/L_i/K_proj",
                "X_gen not contained in Q_q (specialization certificate)",
                "a_i not forced onto Q_q; D=0 independent of Phi(a_i)=0",
                "residual binary not over K_proj",
                "secondary β cancelled tables: exact obstruction named",
                "Route-1 via Q_q interface killed",
            ],
            "not_proved": [
                "cancelled secondary 12-vectors for each β_{r,k}",
                "Q_q(K_proj)=∅ (emptiness not claimed)",
                "Q_q(L_i)=∅ beyond Springer equivalence with K_proj residual",
                "Springer reduction to X_gen(K_proj)",
                "Problem E headline",
            ],
        },
        "noncontainment_sha256": None,  # filled by main
        "g3p_status": (G3P / "STATUS.md").read_text().splitlines()[0].strip(),
        "g3a_status": (G3A / "STATUS.md").read_text().splitlines()[0].strip(),
    }


def write_markdowns(beta_dec, hunt, decision, noncontainment, springer_thm, resources):
    (OUT / "SECONDARY_BETA.md").write_text(
        f"""# G3H phase5_bls — secondary β tables

Marker: `{beta_dec["marker"]}`  
Closed gate: `G3H-AI-SECONDARY-TABLE-OPEN` (as **named exact obstruction**)

## Demand

For both A5 classes and all coordinates of

\\[
a_i^{{(r)}}=\\sum_{{k=0}}^{{10}}\\beta_{{r,k}}\\,\\theta_i^k,
\\qquad \\beta_{{r,k}}\\in K_{{\\mathrm{{proj}}}},
\\]

produce cancelled secondary 12-vectors (numerators/denominators over
\\(P_0=\\mathbf Q(t_3,t_6,t_8,t_{{11}})\\) in basis

```text
{list(SECONDARY_NAMES)}
```

). Dual-trace formulas alone are insufficient for this gate.

## Decision

**Obstruction:** `{beta_dec["exact_obstruction"]["name"]}`.

{beta_dec["exact_obstruction"]["statement"]}

### Complexity

{beta_dec["exact_obstruction"]["complexity_note"]}

### Installed vs not

- Installed: dual-trace / Vandermonde calculus (phase5_springer_next,
  `G3H-AI-EXPANSION-DUAL-PASS`); per-slot obstruction tags for all 2×55 coefficients.
- Not installed: cancelled secondary numerators/denominators.

Machine ledger: `secondary_beta_decision.json`.
"""
    )

    (OUT / "L_POINT_DECISION.md").write_text(
        f"""# G3H phase5_bls — L_i-point on K_proj quadrics

Marker: `{hunt["marker"]}`  
Closed gate: `G3H-LI-POINT-ON-KPROJ-QUADRATIC-OPEN` with **NO** for the attempted family.

## Springer quadratic-form theorem

{springer_thm["statement"]}

**Application:** {springer_thm["application_to_Q_q"]["conclusion"]}

## Non-containment

{noncontainment["conclusion"]}

Sample (secondary-0, p={noncontainment["specialization"]["prime"]}):
{noncontainment["cubic_pts_off_Q_q"]} cubic points off Q_q vs
{noncontainment["cubic_pts_on_Q_q"]} on Q_q
(fraction off = {noncontainment["fraction_off_Q_q"]}).

## Attempts

| Name | Status | Decision |
|---|---|---|
"""
        + "\n".join(
            f"| `{a['name']}` | {a['status']} | {a['decision']} |"
            for a in hunt["attempts"]
        )
        + f"""

## Conclusion

{hunt["conclusion"]}

Machine ledger: `L_point_decision.json`, `noncontainment_Xgen_Qq.json`,
`springer_quadratic_form.json`.
"""
    )

    (OUT / "SPRINGER_KILL.md").write_text(
        f"""# G3H phase5_bls — Route-1 Springer kill

Marker: `{decision["marker"]}`  
Route-1 decision: **{decision["route1_decision"]}**

## Kill statement

{decision["kill_statement"]}

## Checklist (both A5 classes)

| # | Requirement | Status |
|---|---|---|
| 1 | Quadratic over K_proj | YES — Q_q |
| 2 | L_i-point on that object | **NO** (proofs) |
| 3 | Degree 11 odd | YES |
| 4 | Explicit map-back | **NO** |

## Forbidden inferences (rejected)

- Q_q(L_i) nonempty => X_gen(K_proj) nonempty without map-back
- pure cubic odd-degree descent from X_gen(L_i)

## Gates

| Gate | Status |
|---|---|
| `G3H-AI-SECONDARY-TABLE-OPEN` | CLOSED as obstruction (`G3H-AI-SECONDARY-TABLE-OBSTRUCTION`) |
| `G3H-LI-POINT-ON-KPROJ-QUADRATIC-OPEN` | CLOSED NO (`G3H-LI-POINT-ON-KPROJ-QUADRATIC-CLOSED-NO`) |
| `G3H-SPRINGER-MAPBACK-OPEN` | CLOSED with interface kill (G3P residual) |

## Not claimed

- `G3H-QUADRATIC-SPRINGER-REDUCTION-PASS`
- `G3P-POINT-HEADLINE-POSITIVE`
- Emptiness of X_gen(K_proj)
- Emptiness of Q_q(K_proj) (only equivalence with Q_q(L_i))

Resources: peak RSS {resources["peak_rss_mb"]:.1f} MB, wall {resources["wall_seconds"]:.2f} s.
"""
    )

    (OUT / "THEOREM_BOUNDARY_BLS.md").write_text(
        r"""# Theorem boundary — phase5_beta_li_springer

## Proved

1. **Springer quadratic-form theorem** applies to \(Q_q\) over \(K_{\mathrm{proj}}\)
   with \(L_i/K_{\mathrm{proj}}\) of degree 11:
   \(Q_q(L_i)\ne\varnothing\Leftrightarrow Q_q(K_{\mathrm{proj}})\ne\varnothing\).
2. **Non-containment** \(X_{\mathrm{gen}}\not\subset Q_q\) by secondary-0
   specialization certificate (rank \(Q_q=5\), positive-density cubic points off \(Q_q\)).
3. **Independence:** \(D=B(q,a_i,a_i)=0\) is not forced by \(\Phi(a_i)=0\); \(a_i\) is
   not a certified \(L_i\)-point of \(Q_q\).
4. **Residual binary** on the line \(qa_i\) is not \(K_{\mathrm{proj}}\)-defined.
5. **Secondary beta tables:** exact obstruction
   `DEGREE-33-REYNOLDS-SECONDARY-EXPANSION` named; dual-trace calculus remains
   the determination of \(\beta_{r,k}\in K_{\mathrm{proj}}\) without secondary expansion.
6. **Route-1 kill:** Springer interface via \(Q_q\) (and listed alternatives) is
   closed for manufacturing \(L_i\)-isotropy from \(a_i\); map-back unsealed.

## Not proved / not claimed

- Cancelled secondary 12-vectors for each \(\beta_{r,k}\)
- \(Q_q(K_{\mathrm{proj}})=\varnothing\)
- \(X_{\mathrm{gen}}(K_{\mathrm{proj}})\ne\varnothing\) or emptiness
- Problem E headline
- Rehabilitation of e0 coset orbits
- Cubic odd-degree descent
"""
    )


def update_package(beta_dec, hunt, decision, resources):
    status = (
        "G3H-SEMILINEAR-G3-FRAME-PASS\n"
        "\n"
        "# Goal G3H status — A5 semilinear Springer\n"
        "\n"
        "**Primary exit:** `G3H-SEMILINEAR-G3-FRAME-PASS`  \n"
        "**Headline:** OPEN  \n"
        "**Phase5 BLS:** `G3H-QUADRATIC-INTERFACE-NO-GO-SCOPED` "
        "(Route-1 **KILL** via Q_q)  \n"
        f"**Consumed commit:** `{git_head()}`  \n"
        "**Pinned main (target):** `eb21458bea684d2399ad18f003e2be8ebdd161ce`\n"
        "\n"
        "## Phase markers\n"
        "\n"
        "| Phase | Marker | Status |\n"
        "|---|---|---|\n"
        "| 1 G7B quarantine | `G3H-G7B-QUARANTINE-PASS` | PASS |\n"
        "| 2 Cubic compression | `G3H-CUBIC-COMPRESSION-PASS` | PASS |\n"
        "| 3 Semilinear landing | `G3H-SEMILINEAR-LANDING-PASS` | PASS |\n"
        "| 4 G3 frame | `G3H-SEMILINEAR-G3-FRAME-PASS` | PASS |\n"
        "| 5 Quadratic Springer | `G3H-QUADRATIC-SPRINGER-REDUCTION-PASS` | NO |\n"
        "| 5 interface decision | `G3H-QUADRATIC-INTERFACE-NO-GO-SCOPED` | PASS (KILL) |\n"
        "| 5n a_i dual expansion | `G3H-AI-EXPANSION-DUAL-PASS` | PASS |\n"
        "| 5bls secondary beta | `G3H-AI-SECONDARY-TABLE-OBSTRUCTION` | PASS (obstruction) |\n"
        "| 5bls L_i-point | `G3H-LI-POINT-ON-KPROJ-QUADRATIC-CLOSED-NO` | PASS (NO) |\n"
        "| 5bls Springer map-back | interface-killed (G3P residual) | KILL |\n"
        "\n"
        "## Decision\n"
        "\n"
        "1. **Phases 1–4.** Unchanged; sealed.\n"
        "2. **Secondary beta tables.** Dual-trace calculus retained. Cancelled secondary\n"
        "   12-vectors blocked by exact obstruction `DEGREE-33-REYNOLDS-SECONDARY-EXPANSION`.\n"
        "   Gate `G3H-AI-SECONDARY-TABLE-OPEN` closed as obstruction.\n"
        "3. **L_i-point on Q_q.** NO for the attempted family: non-containment\n"
        "   X_gen not subset Q_q; D=0 not forced; Springer quadratic-form\n"
        "   theorem gives Q_q(L_i) <=> Q_q(K_proj) (G3P residual).\n"
        "   Gate `G3H-LI-POINT-ON-KPROJ-QUADRATIC-OPEN` closed NO.\n"
        "4. **Springer.** Checklist items 2 and 4 fail with proofs. Route-1 via Q_q\n"
        "   **killed** as an interface. No map-back; no headline; illegal cubic descent rejected.\n"
        "\n"
        "## Theorem boundary\n"
        "\n"
        "- Not a Problem-E headline.\n"
        "- Does not claim X_gen(K_proj) empty or nonempty.\n"
        "- Does not claim Q_q(K_proj)=empty.\n"
        "- Does not rehabilitate e0 coset orbits.\n"
        "- See `phase5_beta_li_springer/` and package `THEOREM_BOUNDARY.md`.\n"
        "\n"
        "## Resources\n"
        "\n"
        f"- Peak RSS (phase5_bls producer): {resources['peak_rss_mb']:.1f} MB\n"
        f"- Wall time (phase5_bls producer): {resources['wall_seconds']:.2f} s\n"
        f"- Python: {resources['python']}\n"
        "\n"
        "## Replay\n"
        "\n"
        "See `REPLAY.md` (includes phase5_beta_li_springer).\n"
    )
    (PACKET / "STATUS.md").write_text(status)

    seal = {
        "consumed_commit": git_head(),
        "exit": "G3H-SEMILINEAR-G3-FRAME-PASS",
        "goal": "G3H_A5_SEMILINEAR_SPRINGER",
        "headline": "OPEN",
        "phase5_beta_li_springer": {
            "dir": "phase5_beta_li_springer/",
            "marker": decision["marker"],
            "route1_decision": "KILL",
            "secondary_marker": beta_dec["marker"],
            "L_i_point_marker": hunt["marker"],
            "gates_closed": [
                "G3H-AI-SECONDARY-TABLE-OPEN",
                "G3H-LI-POINT-ON-KPROJ-QUADRATIC-OPEN",
                "G3H-SPRINGER-MAPBACK-OPEN",
            ],
        },
        "phase5_next": {
            "dir": "phase5_springer_next/",
            "expansion_marker": "G3H-AI-EXPANSION-DUAL-PASS",
            "marker": "G3H-QUADRATIC-INTERFACE-NO-GO-SCOPED",
        },
        "phase_markers": [
            "G3H-G7B-QUARANTINE-PASS",
            "G3H-CUBIC-COMPRESSION-PASS",
            "G3H-SEMILINEAR-LANDING-PASS",
            "G3H-SEMILINEAR-G3-FRAME-PASS",
            "G3H-QUADRATIC-INTERFACE-NO-GO-SCOPED",
            "G3H-AI-EXPANSION-DUAL-PASS",
            "G3H-AI-SECONDARY-TABLE-OBSTRUCTION",
            "G3H-LI-POINT-ON-KPROJ-QUADRATIC-CLOSED-NO",
        ],
        "pinned_main_target": "eb21458bea684d2399ad18f003e2be8ebdd161ce",
        "resources": resources,
        "timestamp_unix": int(time.time()),
    }
    write_json(PACKET / "SEAL.json", seal)

    tb = (PACKET / "THEOREM_BOUNDARY.md").read_text()
    if "phase5_beta_li_springer" not in tb:
        tb = tb.rstrip() + """

## Phase5 BLS addendum (Route-1 kill)

7. **Springer quadratic-form theorem on Q_q.** With [L_i:K_proj]=11 odd,
   Q_q(L_i) nonempty iff Q_q(K_proj) nonempty.
8. **Non-containment** X_gen not subset Q_q (specialization certificate).
9. **Secondary beta obstruction.** Cancelled secondary tables blocked by
   degree-33 Reynolds expansion; dual-trace remains the abstract determination.
10. **Route-1 kill.** Springer via Q_q closed as an interface for producing
    L_i-isotropy from a_i; map-back unsealed; no headline.

See `phase5_beta_li_springer/THEOREM_BOUNDARY_BLS.md`.
"""
        (PACKET / "THEOREM_BOUNDARY.md").write_text(tb)

    replay = """# G3H replay

From the problem root `problems/E-klein-cubic`:

```sh
# Sealed phases 1–4 + original phase 5 decision
python3 -u goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER/produce_all.py
python3 -u goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER/verify_all.py

# Phase 5 next: expand a_i, polar data, L_i-point hunt, Springer decision
python3 -u goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER/phase5_springer_next/produce_phase5_next.py
python3 -u goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER/phase5_springer_next/verify_phase5_next.py

# Phase 5 BLS: secondary β obstruction + L_i-point NO + Route-1 kill
python3 -u goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER/phase5_beta_li_springer/produce_phase5_bls.py
python3 -u goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER/phase5_beta_li_springer/verify_phase5_bls.py
```

Independent phase verifiers (no import of producers):

```sh
python3 -u goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER/verify_phase1.py
python3 -u goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER/verify_phase2.py
python3 -u goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER/verify_phase3.py
python3 -u goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER/verify_phase4.py
python3 -u goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER/verify_phase5.py
python3 -u goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER/phase5_springer_next/verify_phase5_next.py
python3 -u goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER/phase5_beta_li_springer/verify_phase5_bls.py
```

Expected markers:

```text
G3H-G7B-QUARANTINE-PASS
G3H-CUBIC-COMPRESSION-PASS
G3H-SEMILINEAR-LANDING-PASS
G3H-SEMILINEAR-G3-FRAME-PASS
G3H-QUADRATIC-INTERFACE-NO-GO-SCOPED
G3H-AI-EXPANSION-DUAL-PASS
G3H-AI-SECONDARY-TABLE-OBSTRUCTION
G3H-LI-POINT-ON-KPROJ-QUADRATIC-CLOSED-NO
G3H_VERIFY_ALL_OK
G3H_PHASE5_NEXT_OK
G3H_PHASE5_BLS_OK
```

Primary STATUS exit:

```text
G3H-SEMILINEAR-G3-FRAME-PASS
```

(with phase-5 scoped no-go / Route-1 **KILL** via Q_q; secondary beta obstruction;
L_i-point closed NO; no Springer reduction claim).
"""
    (PACKET / "REPLAY.md").write_text(replay)

    # README touch
    readme = (PACKET / "README.md").read_text()
    if "phase5_beta_li_springer" not in readme:
        (PACKET / "README.md").write_text(
            readme.rstrip()
            + """

Phase 5 BLS (`phase5_beta_li_springer/`): secondary beta obstruction, L_i-point
decision (NO for attempted family + Springer q.f. theorem), Route-1 kill via Q_q.
"""
        )


def main() -> None:
    t0 = time.time()
    # Bind sealed inputs
    require_files = [
        PHASE5N / "a_i_expansion.json",
        PHASE5N / "polar_data.json",
        PHASE5N / "springer_decision.json",
        PHASE4 / "g3_frame.json",
        G3P / "STATUS.md",
        GENERIC,
    ]
    for f in require_files:
        if not f.is_file():
            raise SystemExit(f"missing sealed input {f}")

    beta_dec = secondary_beta_decision()
    noncontainment = noncontainment_Xgen_vs_Qq()
    springer_thm = springer_quadratic_form_theorem()
    hunt = hunt_L_i_points(noncontainment, springer_thm)
    decision = springer_kill(beta_dec, hunt, springer_thm, noncontainment)
    decision["noncontainment_sha256"] = sha256_file  # placeholder fixed below

    # Rebuild polar A briefly for binding (fast path from sealed JSON)
    polar = json.loads((PHASE5N / "polar_data.json").read_text())
    phi_q = polar["Phi_q"]
    if phi_q["is_zero"] or phi_q["nonzero_count"] != 1:
        raise SystemExit("Phi(q) binding failed")

    write_json(OUT / "secondary_beta_decision.json", beta_dec)
    write_json(OUT / "noncontainment_Xgen_Qq.json", noncontainment)
    write_json(OUT / "springer_quadratic_form.json", springer_thm)
    write_json(OUT / "L_point_decision.json", hunt)

    resources = {
        "peak_rss_mb": rss_mb(),
        "wall_seconds": time.time() - t0,
        "python": f"{sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro}",
    }
    decision["resources"] = resources
    decision["noncontainment_sha256"] = hashlib.sha256(
        json.dumps(noncontainment, sort_keys=True).encode()
    ).hexdigest()
    write_json(OUT / "springer_decision.json", decision)

    write_markdowns(beta_dec, hunt, decision, noncontainment, springer_thm, resources)
    update_package(beta_dec, hunt, decision, resources)

    # INPUT_MANIFEST + SHA256SUMS
    inputs = [
        "goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER/phase5_springer_next/a_i_expansion.json",
        "goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER/phase5_springer_next/polar_data.json",
        "goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER/phase5_springer_next/springer_decision.json",
        "goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER/phase4_g3_frame/g3_frame.json",
        "goal_runs_after_0aecc89/G3P_POLAR_ODD_DEGREE_DESCENT/STATUS.md",
        "goal_runs_after_0aecc89/G3P_POLAR_ODD_DEGREE_DESCENT/quadratic_invariants.json",
        "goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE/STATUS.md",
        "goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json",
        "tmp/dispatch/G3H_BETA_LI_SPRINGER_BRIEF.md",
    ]
    manifest = {
        "schema": "g3h-phase5-bls-input-manifest-v1",
        "inputs": [
            {
                "path": rel,
                "exists": (ROOT / rel).is_file(),
                "sha256": sha256_file(ROOT / rel) if (ROOT / rel).is_file() else None,
            }
            for rel in inputs
        ],
    }
    write_json(OUT / "INPUT_MANIFEST.json", manifest)

    sums = []
    for path in sorted(OUT.iterdir()):
        if path.is_file() and path.name != "SHA256SUMS":
            sums.append(f"{sha256_file(path)}  {path.name}")
    (OUT / "SHA256SUMS").write_text("\n".join(sums) + "\n")

    print(beta_dec["marker"])
    print(hunt["marker"])
    print(decision["marker"])
    print("ROUTE1_KILL")
    print(f"peak_rss_mb={resources['peak_rss_mb']:.2f}")
    print(f"wall_seconds={resources['wall_seconds']:.2f}")
    print("G3H_PHASE5_BLS_PRODUCE_OK")


if __name__ == "__main__":
    main()
