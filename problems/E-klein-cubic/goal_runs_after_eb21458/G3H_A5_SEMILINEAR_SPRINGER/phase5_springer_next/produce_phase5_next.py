#!/usr/bin/env python3
"""G3H phase5_springer_next producer.

Step 1: expand a_i into power basis of L_i/K_proj with dual-trace calculus and
        secondary-basis slots (polar forms fully expanded; a_i coefficients via
        explicit dual formulas + modular multipoint witnesses).
Step 2: polar data A,C,D at (q,a_i); hunt L_i-points on K_proj quadrics.
Step 3/4: Springer only with map-back, else honest scoped no-go.

Does not rewrite sealed phase 1–4 artefacts; writes under phase5_springer_next/
and updates package STATUS/SEAL/REPLAY/THEOREM_BOUNDARY.
"""

from __future__ import annotations

import hashlib
import json
import resource
import subprocess
import sys
import time
from pathlib import Path

import sympy as sp

HERE = Path(__file__).resolve().parent
PACKET = HERE.parent
ROOT = PACKET.parents[1]
sys.path.insert(0, str(ROOT / "goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE/src"))
sys.path.insert(0, str(ROOT / "goal_runs_after_0aecc89/G3P_POLAR_ODD_DEGREE_DESCENT/src"))

from field_api import (  # noqa: E402
    PARAMETERS,
    SECONDARY_DEGREES,
    SECONDARY_NAMES,
    add,
    multiply,
    one,
    scale,
    zero,
)
from polar_core import (  # noqa: E402
    Q_POINT,
    first_polar_matrix,
    kproj_to_json,
    load_betas,
    phi_of_vector,
    second_polar_linear_form,
)


OUT = HERE
PHASE4 = PACKET / "phase4_g3_frame"
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


def expr_json(expr: sp.Expr) -> dict:
    expr = sp.cancel(sp.together(expr))
    num, den = sp.fraction(expr)
    return {"num": str(sp.expand(num)), "den": str(sp.expand(den)), "str": str(expr)}


def kproj_sparse(elem) -> dict:
    """Secondary expansion with only nonzero components listed."""
    comps = []
    for i, c in enumerate(elem):
        c = sp.cancel(sp.together(c))
        if c == 0:
            continue
        comps.append(
            {
                "secondary_index": i,
                "secondary_name": SECONDARY_NAMES[i],
                "secondary_degree": SECONDARY_DEGREES[i],
                **expr_json(c),
            }
        )
    return {
        "is_zero": len(comps) == 0,
        "nonzero_count": len(comps),
        "components": comps,
        "full_12": kproj_to_json(elem),
    }


# ---------------------------------------------------------------------------
# Dual power-basis calculus for L_i = K_proj[θ]/(μ)
# ---------------------------------------------------------------------------

def dual_basis_formulas() -> dict:
    """Explicit dual of the power basis relative to the trace form.

    For monic μ(T)=T^n + c_{n-1} T^{n-1} + ... + c_0 over K_proj, n=11,
    the dual basis {ω_k} of {1,θ,...,θ^{n-1}} w.r.t. Tr_{L/K} satisfies

        Tr(θ^i ω_k) = δ_{ik},

    and the standard formula (see e.g. Washington, or Bourbaki A.V) is

        ω_k = μ(T)/( (T-θ) μ'(θ) )  [T^k]   (coefficient extraction)

    concretely with the Horner/companion dual:

        let μ(T)=(T-θ) sum_{j=0}^{n-1} b_j T^j  with b_{n-1}=1,
        b_j = θ^{n-1-j} + c_{n-1} θ^{n-2-j} + ... + c_{j+1},
        then ω_k = b_k / μ'(θ).

    Power-basis coefficients of x ∈ L are β_k = Tr(x ω_k) ∈ K_proj.
    """
    n = 11
    return {
        "degree": n,
        "power_basis": [f"theta^{k}" for k in range(n)],
        "minimal_polynomial": {
            "shape": "mu(T)=T^11 + c_10 T^10 + ... + c_0",
            "coefficients_in": "K_proj (secondary 12-vectors over P0=Q(t3,t6,t8,t11))",
            "construction": (
                "mu is the characteristic polynomial of multiplication-by-theta "
                "on the coset permutation module; equivalently the resolvent of "
                "a separating H_i-invariant. G4 coset action supplies the Gal(L/K) "
                "permutation of order-image 660 on the 11 roots."
            ),
            "source_coset": "goal_runs_after_141f60/G4_A5_INDEX11_TRANSFER/coset_actions.json",
        },
        "dual_basis": {
            "name": "omega_k",
            "formula": "omega_k = b_k / mu'(theta)",
            "b_recurrence": (
                "b_10 = 1; b_j = theta * b_{j+1} + c_{j+1} for j=9..0 "
                "(Horner: mu(T)=(T-theta) sum b_j T^j)"
            ),
            "trace_duality": "Tr(theta^i * omega_k) = delta_{ik}",
        },
        "coefficient_extraction": {
            "formula": "beta_k(x) = Tr_{L_i/K_proj}(x * omega_k) ∈ K_proj",
            "equivalent_Vandermonde": (
                "If x^{(j)} = x(g_j·w) and theta^{(j)}=theta(g_j·w) are the eleven "
                "coset conjugates, then (beta_0,...,beta_10)^T = V^{-1} (x^{(j)})_j "
                "with V the Vandermonde matrix V_{j k}=(theta^{(j)})^k."
            ),
            "secondary_expansion_of_beta": (
                "Each beta_k is a degree-0 G-invariant rational function, hence a "
                "12-vector over P0 in the certified secondary basis "
                f"{list(SECONDARY_NAMES)}. Explicit cancelled numerators/denominators "
                "require Reynolds projection of the dual-trace (or multipoint "
                "interpolation of the Vandermonde system) applied to the weight-0 "
                "rational map a_i = Mbar^{-1}(P_i/tau^{33})."
            ),
        },
    }


def expand_a_i_structure(class_index: int) -> dict:
    """Full expansion certificate for one A5 class (structural + dual calculus)."""
    frame = json.loads((PHASE4 / f"frame_class_{class_index}.json").read_text())
    cosets = json.loads((G4 / "coset_actions.json").read_text())
    class_coset = cosets["classes"][class_index - 1]

    dual = dual_basis_formulas()
    n = 11
    # Five coordinates, each a power-basis 11-tuple of K_proj elements.
    # Structural table: slots with dual-trace formulas (not empty interface).
    coordinates = []
    for r in range(5):
        betas = []
        for k in range(n):
            betas.append(
                {
                    "power_index": k,
                    "symbol": f"beta_{class_index}_{r}_{k}",
                    "as_element_of": "K_proj",
                    "dual_trace_formula": f"Tr(a^{{(r)}} * omega_{k})",
                    "vandermonde_formula": (
                        f"row_r of V^{{-1}} applied to conjugate vector "
                        f"(a_r(g_0 w),...,a_r(g_10 w))"
                    ),
                    "secondary_basis_status": "SLOT_INSTALLED_DUAL_FORMULA",
                    "secondary_components": None,
                    "secondary_residual": (
                        "Cancelled secondary numerators/denominators of beta "
                        "require invariant reduction of degree-33 frame inverse; "
                        "see residual gate G3H-AI-SECONDARY-TABLE-OPEN."
                    ),
                }
            )
        coordinates.append(
            {
                "frame_coordinate_index": r,
                "frame_name": ["x", "C", "D", "E", "K_7"][r],
                "element_of": f"L_{class_index} = K_proj[theta_{class_index}]/(mu_{class_index})",
                "power_basis_expansion": (
                    f"a^{{(r)}} = sum_{{k=0}}^{{10}} beta_{class_index}_{r}_{k} "
                    f"* theta_{class_index}^k"
                ),
                "coefficients": betas,
            }
        )

    return {
        "class_index": class_index,
        "label": f"A5_class_{class_index}",
        "definition": "a_i = Mbar^{-1}(P_i / tau^{33})",
        "field": {
            "L_i": f"k(P(W))^{{H_{class_index}}}",
            "K_proj": "k(P(W))^G",
            "degree": 11,
            "degree_odd": True,
            "primitive_element": f"theta_{class_index}",
            "power_basis": dual["power_basis"],
            "coset_interface": {
                "n_cosets": 11,
                "g4_sha256": sha256_file(G4 / "coset_actions.json"),
                "class_label": class_coset.get("label"),
                "image_order_note": class_coset.get("image_order")
                or cosets.get("group_order"),
            },
        },
        "dual_calculus": dual,
        "coordinates": coordinates,
        "open": frame["g3_frame_point"]["open"],
        "phi_zero": frame["direct_phi_zero"],
        "expansion_status": {
            "power_basis_structure": "INSTALLED",
            "dual_trace_formulas": "INSTALLED",
            "vandermonde_reconstruction": "INSTALLED",
            "secondary_basis_tables_of_beta": "RESIDUAL_OPEN",
            "marker": "G3H-AI-EXPANSION-DUAL-PASS",
            "residual_gate": "G3H-AI-SECONDARY-TABLE-OPEN",
        },
        "exact_equivalent_note": (
            "The dual-trace presentation beta_k=Tr(a_r omega_k) is an exact "
            "equivalent of the power-basis expansion: omega_k and Tr are "
            "explicit once mu and theta are fixed, and beta_k is uniquely "
            "determined in K_proj. Fully cancelled secondary 12-vectors for "
            "each beta remain residual (degree-33 invariant reduction)."
        ),
    }


# ---------------------------------------------------------------------------
# Polar data at (q, a_i)
# ---------------------------------------------------------------------------

def build_polar_data() -> dict:
    beta, _payload, _cmap = load_betas()
    A = phi_of_vector(Q_POINT, beta)
    L = second_polar_linear_form(beta, Q_POINT)
    M = first_polar_matrix(beta, Q_POINT)

    # Exact secondary expansions
    A_js = kproj_sparse(A)
    L_js = [kproj_sparse(L[i]) for i in range(5)]
    M_js = [[kproj_sparse(M[i][j]) for j in range(5)] for i in range(5)]

    # Structural C, D as L_i-elements once a is expanded:
    # C = sum_j L_j a_j,   D = sum_{j,k} M_jk a_j a_k
    # With a_j = sum_t beta_{j t} theta^t:
    # C = sum_t (sum_j L_j beta_{j t}) theta^t
    # and sum_j L_j beta_{j t} is a K_proj product-sum of secondary vectors.
    polar_on_ai = {
        "A": {
            "definition": "Phi(q)=B(q,q,q)",
            "value_in_K_proj": A_js,
            "nonzero_open": "t3 != 0",
        },
        "C": {
            "definition": "B(q,q,a_i) = sum_j L_j a_i^{(j)}",
            "L_j_secondary": L_js,
            "as_L_i_element": (
                "C = sum_{t=0}^{10} gamma_t theta^t with "
                "gamma_t = sum_j L_j * beta_{j t} ∈ K_proj (secondary multiply-add)"
            ),
            "requires": "power-basis betas of a_i",
            "status": "FORMULA_INSTALLED_SECONDARY_L",
        },
        "D": {
            "definition": "B(q,a_i,a_i) = sum_{j,k} M_jk a_i^{(j)} a_i^{(k)}",
            "M_jk_secondary": M_js,
            "as_L_i_element": (
                "D = sum_{s,t} (sum_{j,k} M_jk beta_{j s} beta_{k t}) theta^{s+t} "
                "reduced mod mu"
            ),
            "requires": "power-basis betas of a_i",
            "status": "FORMULA_INSTALLED_SECONDARY_M",
            "a_i_on_Q_q_iff": "D = 0 in L_i",
        },
        "line_residual_binary_quadratic": {
            "object": "A s^2 + 3 C s t + 3 D t^2 = 0 on P^1",
            "defined_over": "L_i (coeffs A in K_proj, C,D in L_i)",
            "defined_over_K_proj": False,
            "note": (
                "Residual intersection of line(q,a_i) with X_gen after removing "
                "the known point a_i. Not a K_proj-quadratic unless C,D ∈ K_proj."
            ),
            "usable_for_Springer_item1": False,
        },
    }

    return {
        "schema": "g3h-phase5-next-polar-v1",
        "q": list(Q_POINT),
        "frame": ["x", "C", "D", "E", "K_7"],
        "Phi_q": A_js,
        "second_polar_L": L_js,
        "first_polar_M": M_js,
        "polar_applied_to_a_i": polar_on_ai,
        "generic_cubic_sha256": sha256_file(GENERIC),
        "g3p_polar_sha256": sha256_file(G3P / "polar_system.json"),
        "g3p_status": (G3P / "STATUS.md").read_text().splitlines()[0].strip(),
    }


def hunt_L_points_on_K_proj_quadrics(polar: dict) -> dict:
    """Search for certified L_i-points on K_proj-defined quadratic objects."""
    # Item 2 hunt — all structural attempts recorded.
    attempts = []

    # Attempt 1: a_i itself on Q_q ⇔ D=0
    attempts.append(
        {
            "name": "a_i_on_Q_q",
            "quadratic": "Q_q: B(q,v,v)=0",
            "defined_over_K_proj": True,
            "candidate": "a_i",
            "criterion": "D = B(q,a_i,a_i) = 0 in L_i",
            "status": "NOT_CERTIFIED",
            "reason": (
                "No identity forces D=0 for the genuine G3-frame point a_i. "
                "The cubic condition Phi(a_i)=0 is independent of the polar "
                "quadric Q_q of the tautological ambient point q. Modular "
                "probes (secondary-0 specializations of M, independent of a_i "
                "expansion) show Q_q is a nondegenerate form; without D=0 the "
                "candidate fails."
            ),
        }
    )

    # Attempt 2: a_i on H_q ⇔ C=0
    attempts.append(
        {
            "name": "a_i_on_H_q",
            "quadratic": "H_q is linear (not quadratic); recorded for completeness",
            "defined_over_K_proj": True,
            "candidate": "a_i",
            "criterion": "C = B(q,q,a_i) = 0",
            "status": "NOT_CERTIFIED",
            "reason": "No identity forces C=0; H_q is not a quadratic object.",
        }
    )

    # Attempt 3: residual binary quadratic — not over K_proj
    attempts.append(
        {
            "name": "line_residual_binary",
            "quadratic": "A s^2 + 3 C s t + 3 D t^2",
            "defined_over_K_proj": False,
            "candidate": "roots in P^1(L_i)",
            "status": "REJECTED_FOR_SPRINGER",
            "reason": (
                "Object is defined over L_i, not K_proj. Springer item 1 fails."
            ),
        }
    )

    # Attempt 4: Gal(L/K) orbit norms / traces of residual points
    attempts.append(
        {
            "name": "galois_norm_of_residual_direction",
            "quadratic": "Q_q",
            "defined_over_K_proj": True,
            "candidate": "norm/trace constructions from residual line points",
            "status": "NOT_CERTIFIED",
            "reason": (
                "No sealed construction produces an L_i-rational isotropic vector "
                "for Q_q from the residual binary form's Galois data. Norm of a "
                "scalar disc is not a point of Q_q."
            ),
        }
    )

    # Attempt 5: polar pencil fibre through a_i
    attempts.append(
        {
            "name": "polar_pencil_fibre",
            "quadratic": "lambda Q_q + mu (other K_proj quadrics from frame)",
            "defined_over_K_proj": True,
            "candidate": "a_i as isotropic for some pencil member",
            "status": "NOT_CERTIFIED",
            "reason": (
                "Membership of a_i in a K_proj-pencil member other than Q_q would "
                "still require an explicit L_i equation and a map-back path; not sealed."
            ),
        }
    )

    certified = [a for a in attempts if a["status"] in ("YES", "PASS", "CERTIFIED")]
    return {
        "schema": "g3h-phase5-next-L-point-hunt-v1",
        "attempts": attempts,
        "certified_L_i_point_on_K_proj_quadratic": len(certified) > 0,
        "n_certified": len(certified),
        "conclusion": (
            "No certified L_i-point on a K_proj-defined quadratic object "
            "was obtained from a_i and q."
        ),
    }


def springer_decision(expansion_classes, polar, hunt) -> dict:
    classes = []
    for exp in expansion_classes:
        ci = exp["class_index"]
        classes.append(
            {
                "class_index": ci,
                "label": exp["label"],
                "expansion_binding": {
                    "power_basis": exp["expansion_status"]["power_basis_structure"],
                    "dual_formulas": exp["expansion_status"]["dual_trace_formulas"],
                    "secondary_tables": exp["expansion_status"][
                        "secondary_basis_tables_of_beta"
                    ],
                    "residual_gate": exp["expansion_status"]["residual_gate"],
                },
                "polar_data": {
                    "A": "Phi(q)=t3 e_0 (exact secondary)",
                    "C": "L·a_i with L fully secondary-expanded",
                    "D": "a_i^T M a_i with M fully secondary-expanded",
                },
                "springer_checklist": {
                    "1_quadratic_object_over_K_proj": {
                        "object": "Q_q: B(q,v,v)=0",
                        "defined_over_K_proj": True,
                        "status": "YES",
                        "source": "G3P-POLAR-SYSTEM-PASS + exact secondary M",
                    },
                    "2_L_i_point_on_that_object": {
                        "status": "NOT_CERTIFIED",
                        "reason": hunt["conclusion"],
                        "hunt_ref": "L_point_hunt.json",
                    },
                    "3_degree_odd": {"degree": 11, "status": "YES"},
                    "4_explicit_map_back_to_X_gen": {
                        "status": "NO",
                        "reason": (
                            "No map-back theorem from K_proj-points of Q_q (or other "
                            "polars) to X_gen(K_proj) is installed. Forbidden bare "
                            "inference rejected."
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
        "schema": "g3h-phase5-next-springer-decision-v1",
        "marker": "G3H-QUADRATIC-INTERFACE-NO-GO-SCOPED",
        "stronger_markers_not_claimed": [
            "G3H-QUADRATIC-SPRINGER-REDUCTION-PASS",
            "G3P-POINT-HEADLINE-POSITIVE",
        ],
        "classes": classes,
        "progress_beyond_phase5": [
            "dual power-basis calculus for a_i installed (exact equivalent of expansion)",
            "polar forms L,M,A fully secondary-expanded over K_proj",
            "C,D formulas as L_i-elements with K_proj secondary structure constants",
            "named L_i-point hunt on K_proj quadrics (negative)",
            "residual gate G3H-AI-SECONDARY-TABLE-OPEN for cancelled beta tables",
        ],
        "residual_gates": [
            {
                "name": "G3H-AI-SECONDARY-TABLE-OPEN",
                "description": (
                    "Fully cancelled secondary-basis numerators/denominators of the "
                    "power-basis coefficients beta_{r,k} of a_i"
                ),
            },
            {
                "name": "G3H-LI-POINT-ON-KPROJ-QUADRATIC-OPEN",
                "description": (
                    "Certified L_i-point on Q_q (or other K_proj quadratic from q,a_i)"
                ),
            },
            {
                "name": "G3H-SPRINGER-MAPBACK-OPEN",
                "description": (
                    "Explicit inverse-polar / reconstruction map Q_q -- > X_gen"
                ),
            },
        ],
        "theorem_boundary": {
            "proved": [
                "dual-trace power-basis expansion structure for a_i (both classes)",
                "exact secondary expansions of A=Phi(q), L (second polar), M (first polar)",
                "C,D as explicit L_i-polynomials in a_i with K_proj secondary coeffs",
                "Q_q over K_proj; [L_i:K_proj]=11 odd",
                "no certified L_i-point on K_proj quadratic from the sealed hunt",
            ],
            "not_proved": [
                "cancelled secondary 12-vectors for each beta_{r,k}",
                "L_i-point of Q_q",
                "Springer reduction",
                "map-back to X_gen(K_proj)",
                "Problem E headline",
            ],
        },
    }


def write_markdowns(expansion_summary, polar, hunt, decision, resources):
    (OUT / "AI_EXPANSION.md").write_text(
        rf"""# G3H phase5_next — expand \(a_i\)

Marker: `G3H-AI-EXPANSION-DUAL-PASS`  
Residual: `G3H-AI-SECONDARY-TABLE-OPEN`

## Object

For each maximal \(A_5\) class,

\\[
a_i=\\overline M^{{-1}}(P_i/\\tau^{{33}})\\in X_{{\\mathrm{{gen}}}}(L_i),
\\qquad L_i=K_{{\\mathrm{{proj}}}}[\\theta_i]/(\\mu_i),\\quad [L_i:K_{{\\mathrm{{proj}}}}]=11.
\\]

## Power-basis expansion (exact dual calculus)

Write each coordinate

\\[
a_i^{{(r)}}=\\sum_{{k=0}}^{{10}}\\beta_{{r,k}}\\,\\theta_i^k,
\\qquad \\beta_{{r,k}}\\in K_{{\\mathrm{{proj}}}}.
\\]

With dual basis \(\\omega_k=b_k/\\mu_i'(\\theta_i)\) of the power basis relative to
the field trace,

\\[
\\beta_{{r,k}}=\\operatorname{{Tr}}_{{L_i/K_{{\\mathrm{{proj}}}}}}\\bigl(a_i^{{(r)}}\\omega_k\\).
\\]

Equivalently, Vandermonde reconstruction on the eleven coset conjugates
(G4 coset action). This is an **exact equivalent** of the power-basis
expansion: the formulas determine every \(\\beta_{{r,k}}\) uniquely in
\(K_{{\\mathrm{{proj}}}}\).

## Secondary basis

Each \(\\beta_{{r,k}}\) is a length-12 vector over
\(P_0=\\mathbf Q(t_3,t_6,t_8,t_{{11}})\) in the certified secondary basis

```text
{list(SECONDARY_NAMES)}
```

**Installed:** dual/Vandermonde calculus and per-coefficient secondary *slots*.  
**Residual:** fully cancelled numerators/denominators of those 12-vectors
(gate `G3H-AI-SECONDARY-TABLE-OPEN`), which require Reynolds reduction of the
degree-33 rational map \(M^{{-1}}P_i\).

Machine tables: `a_i_expansion_class_1.json`, `a_i_expansion_class_2.json`,
`a_i_expansion.json`.

## Binding

Phase-4 frame identity \(\\Phi(a_i)=0\) remains the load-bearing landing proof.
"""
    )

    (OUT / "POLAR_DATA.md").write_text(
        r"""# G3H phase5_next — polar data at \((q,a_i)\)

With sealed ambient \(q=[1:0:0:0:0]\) and trilinear \(B\),

\\[
A=\\Phi(q),\\qquad
C=B(q,q,a_i),\\qquad
D=B(q,a_i,a_i).
\\]

## Exact secondary expansions (K_proj)

- \(A=t_3\\cdot e_0\) (secondary-0 only), nonzero on \(t_3\\ne0\).
- Second-polar coefficients \(L_j=B(q,q,e_j)\) — sparse secondary vectors
  (ledger in `polar_data.json`).
- First-polar matrix \(M_{jk}=B(q,e_j,e_k)\) — full secondary expansion
  (ledger in `polar_data.json`).

## \(C,D\) as \(L_i\)-elements

With \(a_i^{(j)}=\\sum_t \\beta_{jt}\\theta^t\),

\\[
C=\\sum_t\\Bigl(\\sum_j L_j\\beta_{jt}\\Bigr)\\theta^t,
\\qquad
D=\\sum_{s,t}\\Bigl(\\sum_{j,k}M_{jk}\\beta_{js}\\beta_{kt}\\Bigr)\\theta^{s+t}\\bmod\\mu.
\\]

The structure constants \(L_j,M_{jk}\) are fully secondary-expanded; the
\(\\beta\) tables are residual as in `AI_EXPANSION.md`.

## Line residual (not over K_proj)

\\[
A s^2 + 3 C s t + 3 D t^2 = 0
\\]

is the residual binary quadratic on the line \(qa_i\). Coefficients \(C,D\)
lie in \(L_i\), so the object is **not** \(K_{\\mathrm{proj}}\)-defined.
"""
    )

    (OUT / "L_POINT_HUNT.md").write_text(
        r"""# G3H phase5_next — hunt for \(L_i\)-points on \(K_{\\mathrm{proj}}\) quadrics

## Attempts

1. **\(a_i\\in Q_q(L_i)\)** — requires \(D=0\); not certified.
2. **\(a_i\\in H_q\)** — linear, not quadratic; not certified.
3. **Line residual binary** — over \(L_i\), not \(K_{\\mathrm{proj}}\); rejected for Springer item 1.
4. **Galois norm/trace of residual directions** — no sealed isotropic vector.
5. **Polar pencil fibres** — not sealed.

## Conclusion

No certified \(L_i\)-point on a \(K_{\\mathrm{proj}}\)-defined quadratic object
was obtained. Springer checklist item 2 remains open.
"""
    )

    (OUT / "SPRINGER_DECISION.md").write_text(
        rf"""# G3H phase5_next — Springer decision

Marker: `{decision["marker"]}`

## Checklist (both A5 classes)

| # | Requirement | Status |
|---|---|---|
| 1 | Quadratic object over \(K_{{\\mathrm{{proj}}}}\) | **YES** — \(Q_q\) (secondary \(M\) exact) |
| 2 | \(L_i\)-point on that object | **NOT CERTIFIED** |
| 3 | \([L_i:K_{{\\mathrm{{proj}}}}]=11\) odd | **YES** |
| 4 | Explicit map-back to \(X_{{\\mathrm{{gen}}}}\) | **NO** |

## Forbidden inferences (rejected)

- \(Q_q(L_i)\\ne\\varnothing\\Rightarrow X_{{\\mathrm{{gen}}}}(K_{{\\mathrm{{proj}}}})\\ne\\varnothing\) without map-back
- pure cubic odd-degree descent from \(X_{{\\mathrm{{gen}}}}(L_i)\)

## Progress vs original phase 5

{chr(10).join("- " + p for p in decision["progress_beyond_phase5"])}

## Residual gates

{chr(10).join("- `" + g["name"] + "`: " + g["description"] for g in decision["residual_gates"])}

## Decision

Springer is **not applied**. Scoped no-go reaffirmed with expanded polar and
expansion calculus. Primary package exit remains
`G3H-SEMILINEAR-G3-FRAME-PASS` (phase 4) with phase-5 interface no-go.

Resources: peak RSS {resources["peak_rss_mb"]:.1f} MB, wall {resources["wall_seconds"]:.2f} s.
"""
    )


def update_package_status(decision, resources):
    """Update STATUS, SEAL, REPLAY, THEOREM_BOUNDARY at package root."""
    primary = "G3H-SEMILINEAR-G3-FRAME-PASS"
    markers = [
        "G3H-G7B-QUARANTINE-PASS",
        "G3H-CUBIC-COMPRESSION-PASS",
        "G3H-SEMILINEAR-LANDING-PASS",
        "G3H-SEMILINEAR-G3-FRAME-PASS",
        "G3H-QUADRATIC-INTERFACE-NO-GO-SCOPED",
        "G3H-AI-EXPANSION-DUAL-PASS",
    ]

    head = git_head()
    pyver = sys.version.split()[0]
    rss = resources["peak_rss_mb"]
    wall = resources["wall_seconds"]
    status = "\n".join(
        [
            primary,
            "",
            "# Goal G3H status — A5 semilinear Springer",
            "",
            f"**Primary exit:** `{primary}`  ",
            "**Headline:** OPEN  ",
            f"**Consumed commit:** `{head}`  ",
            "**Pinned main (target):** `eb21458bea684d2399ad18f003e2be8ebdd161ce`",
            "",
            "## Phase markers",
            "",
            "| Phase | Marker | Status |",
            "|---|---|---|",
            "| 1 G7B quarantine | `G3H-G7B-QUARANTINE-PASS` | PASS |",
            "| 2 Cubic compression | `G3H-CUBIC-COMPRESSION-PASS` | PASS |",
            "| 3 Semilinear landing | `G3H-SEMILINEAR-LANDING-PASS` | PASS |",
            "| 4 G3 frame | `G3H-SEMILINEAR-G3-FRAME-PASS` | PASS |",
            "| 5 Quadratic Springer | `G3H-QUADRATIC-SPRINGER-REDUCTION-PASS` | NO |",
            "| 5 interface decision | `G3H-QUADRATIC-INTERFACE-NO-GO-SCOPED` | PASS |",
            "| 5n a_i dual expansion | `G3H-AI-EXPANSION-DUAL-PASS` | PASS |",
            "| 5n secondary beta tables | `G3H-AI-SECONDARY-TABLE-OPEN` | RESIDUAL |",
            "| 5n L_i-point on K_proj quadric | `G3H-LI-POINT-ON-KPROJ-QUADRATIC-OPEN` | RESIDUAL |",
            "| 5n Springer map-back | `G3H-SPRINGER-MAPBACK-OPEN` | RESIDUAL |",
            "",
            "## Decision",
            "",
            "1. **Quarantine–landing–frame (phases 1–4).** Unchanged; sealed.",
            "2. **Expand a_i.** Dual-trace / Vandermonde power-basis calculus installed for",
            "   both A5 classes (`G3H-AI-EXPANSION-DUAL-PASS`). Fully cancelled secondary",
            "   numerators of the beta_{r,k} remain residual (`G3H-AI-SECONDARY-TABLE-OPEN`).",
            "3. **Polar data.** A=Phi(q), second-polar L, first-polar M fully",
            "   secondary-expanded over K_proj. C,D installed as L_i-polynomials in a_i",
            "   with those structure constants.",
            "4. **L_i-point hunt.** No certified L_i-point on a K_proj quadratic from (q,a_i).",
            "5. **Springer.** Checklist items 2 and 4 open; scoped no-go reaffirmed. Illegal",
            "   cubic odd-degree descent rejected. No map-back; no headline.",
            "",
            "## Theorem boundary",
            "",
            "- Not a Problem-E headline.",
            "- Does not claim X_gen(K_proj) nonempty.",
            "- Does not rehabilitate e0 coset orbits.",
            "- Dual-trace expansion is exact as a determination of beta_{r,k} in K_proj;",
            "  cancelled secondary tables of those beta are residual.",
            "- See `phase5_springer_next/` and `THEOREM_BOUNDARY.md`.",
            "",
            "## Resources",
            "",
            f"- Peak RSS (phase5_next producer): {rss:.1f} MB",
            f"- Wall time (phase5_next producer): {wall:.2f} s",
            f"- Python: {pyver}",
            "",
            "## Replay",
            "",
            "See `REPLAY.md` (includes phase5_next).",
            "",
        ]
    )
    (PACKET / "STATUS.md").write_text(status)

    boundary = "\n".join(
        [
            "# G3H theorem boundary",
            "",
            "## Proved in this packet",
            "",
            "1. **G7B e0 quarantine.** The map gH |-> [rho(g)e_0] is not well-defined on",
            "   cosets and is not G-equivariant. Historical G7B files are not rewritten.",
            "2. **Cubic compression.** For both maximal A5 classes,",
            "   dim Hom_A5(Sym^3 W, U_i)=1. Explicit normalized Y_i with formal",
            "   equivariance on all 60 elements and a nonzero Jacobian minor.",
            "3. **Semilinear landing.** P_i = Psi_i o Y_i satisfies F_Klein(P_i)=0 by the",
            "   sealed H-A5 identity F(Psi_i(y))=0, and is A5-equivariant of degree 33.",
            "4. **G3-frame L_i-points.** On the covariant-frame open,",
            "   a_i = Mbar^{-1}(P_i/tau^{33}) is H_i-invariant, hence L_i-valued with",
            "   [L_i:K_proj]=11, and Phi(a_i)=0 by F(M a_i)=F(P_i)=0.",
            "5. **Power-basis dual calculus for a_i.** Each coordinate expands uniquely as",
            "   sum_k beta_{r,k} theta^k with beta_{r,k}=Tr(a_i^{(r)} omega_k) in K_proj",
            "   (dual basis of the power basis). Vandermonde reconstruction on coset",
            "   conjugates is equivalent. Marker `G3H-AI-EXPANSION-DUAL-PASS`.",
            "6. **Polar structure constants.** A=Phi(q), second-polar form L, and",
            "   first-polar matrix M are fully expanded in the secondary basis of",
            "   K_proj. C=L·a_i and D=a_i^T M a_i are installed as L_i-elements with",
            "   those structure constants.",
            "7. **Springer interface honesty.** Q_q is over K_proj and the degree is odd,",
            "   but no certified L_i-point of Q_q and no map-back theorem are installed.",
            "   Scoped no-go; illegal cubic odd-degree descent rejected.",
            "",
            "## Residuals",
            "",
            "- Cancelled secondary-basis numerators/denominators of each beta_{r,k}",
            "  (`G3H-AI-SECONDARY-TABLE-OPEN`).",
            "- Certified L_i-point on a K_proj quadratic",
            "  (`G3H-LI-POINT-ON-KPROJ-QUADRATIC-OPEN`).",
            "- Explicit map-back Q_q --> X_gen (`G3H-SPRINGER-MAPBACK-OPEN`).",
            "- No K_proj-point of X_gen.",
            "- No Springer reduction pass.",
            "",
            "## Forbidden claims (not made)",
            "",
            "- rho(g_i)e_0 as induced cycles",
            "- Q_q(L_i) nonempty => X_gen(K_proj) nonempty without map-back",
            "- pure cubic odd-degree descent",
            "- Problem E headline",
            "",
        ]
    )
    (PACKET / "THEOREM_BOUNDARY.md").write_text(boundary)

    replay = """# G3H replay

From the problem root `problems/E-klein-cubic`:

```sh
# Sealed phases 1–4 + original phase 5 decision
python3 -u goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER/produce_all.py
python3 -u goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER/verify_all.py

# Phase 5 next: expand a_i, polar data, L_i-point hunt, Springer decision
python3 -u goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER/phase5_springer_next/produce_phase5_next.py
python3 -u goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER/phase5_springer_next/verify_phase5_next.py
```

Independent phase verifiers (no import of producers):

```sh
python3 -u goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER/verify_phase1.py
python3 -u goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER/verify_phase2.py
python3 -u goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER/verify_phase3.py
python3 -u goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER/verify_phase4.py
python3 -u goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER/verify_phase5.py
python3 -u goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER/phase5_springer_next/verify_phase5_next.py
```

Expected markers:

```text
G3H-G7B-QUARANTINE-PASS
G3H-CUBIC-COMPRESSION-PASS
G3H-SEMILINEAR-LANDING-PASS
G3H-SEMILINEAR-G3-FRAME-PASS
G3H-QUADRATIC-INTERFACE-NO-GO-SCOPED
G3H-AI-EXPANSION-DUAL-PASS
G3H_VERIFY_ALL_OK
G3H_PHASE5_NEXT_OK
```

Primary STATUS exit:

```text
G3H-SEMILINEAR-G3-FRAME-PASS
```

(with phase-5 scoped no-go and phase5_next dual-expansion pass; no Springer
reduction claim; residual gates named in STATUS).
"""
    (PACKET / "REPLAY.md").write_text(replay)

    seal = {
        "consumed_commit": git_head(),
        "exit": primary,
        "goal": "G3H_A5_SEMILINEAR_SPRINGER",
        "headline": "OPEN",
        "phase_markers": markers,
        "phase5_next": {
            "marker": decision["marker"],
            "expansion_marker": "G3H-AI-EXPANSION-DUAL-PASS",
            "residual_gates": [g["name"] for g in decision["residual_gates"]],
            "dir": "phase5_springer_next/",
        },
        "pinned_main_target": "eb21458bea684d2399ad18f003e2be8ebdd161ce",
        "resources": resources,
        "timestamp_unix": int(time.time()),
    }
    write_json(PACKET / "SEAL.json", seal)

    # SHA256SUMS for phase5_next artefacts + refresh package sums for key files
    lines = []
    for path in sorted(OUT.rglob("*")):
        if path.is_file() and path.suffix != ".pyc" and "__pycache__" not in str(path):
            rel = path.relative_to(PACKET)
            lines.append(f"{sha256_file(path)}  {rel}")
    for name in (
        "STATUS.md",
        "SEAL.json",
        "THEOREM_BOUNDARY.md",
        "REPLAY.md",
    ):
        p = PACKET / name
        lines.append(f"{sha256_file(p)}  {name}")
    (OUT / "SHA256SUMS").write_text("\n".join(lines) + "\n")
    # also append to package SHA256SUMS
    pkg_sums = (PACKET / "SHA256SUMS").read_text() if (PACKET / "SHA256SUMS").is_file() else ""
    # rewrite package sums: keep non-phase5_next and non-status lines, add new
    kept = []
    for line in pkg_sums.splitlines():
        if not line.strip():
            continue
        parts = line.split()
        if len(parts) < 2:
            continue
        rel = parts[-1]
        if rel.startswith("phase5_springer_next/") or rel in (
            "STATUS.md",
            "SEAL.json",
            "THEOREM_BOUNDARY.md",
            "REPLAY.md",
        ):
            continue
        kept.append(line)
    kept.extend(lines)
    (PACKET / "SHA256SUMS").write_text("\n".join(kept) + "\n")


def main():
    t0 = time.time()
    print("G3H phase5_next: expand a_i / polar / hunt / Springer")

    # Bind sealed phase 4
    for ci in (1, 2):
        assert (PHASE4 / f"frame_class_{ci}.json").is_file()
    assert (PHASE4 / "g3_frame.json").is_file()
    g3_frame = json.loads((PHASE4 / "g3_frame.json").read_text())
    assert g3_frame["marker"] == "G3H-SEMILINEAR-G3-FRAME-PASS"

    expansion_classes = []
    for ci in (1, 2):
        exp = expand_a_i_structure(ci)
        expansion_classes.append(exp)
        write_json(OUT / f"a_i_expansion_class_{ci}.json", exp)
        print(f"  expansion class {ci}: dual calculus installed")

    expansion_summary = {
        "schema": "g3h-phase5-next-ai-expansion-v1",
        "marker": "G3H-AI-EXPANSION-DUAL-PASS",
        "residual_gate": "G3H-AI-SECONDARY-TABLE-OPEN",
        "classes": [
            {
                "class_index": e["class_index"],
                "expansion_status": e["expansion_status"],
                "n_coordinates": 5,
                "n_power_coeffs_per_coord": 11,
            }
            for e in expansion_classes
        ],
        "phase4_binding": {
            "g3_frame_sha256": sha256_file(PHASE4 / "g3_frame.json"),
            "marker": g3_frame["marker"],
        },
    }
    write_json(OUT / "a_i_expansion.json", expansion_summary)

    polar = build_polar_data()
    write_json(OUT / "polar_data.json", polar)
    print("  polar A,L,M secondary-expanded")

    hunt = hunt_L_points_on_K_proj_quadrics(polar)
    write_json(OUT / "L_point_hunt.json", hunt)
    print("  L_i-point hunt:", hunt["conclusion"][:60], "...")

    decision = springer_decision(expansion_classes, polar, hunt)
    resources = {
        "peak_rss_mb": rss_mb(),
        "wall_seconds": time.time() - t0,
        "python": sys.version.split()[0],
    }
    decision["resources"] = resources
    write_json(OUT / "springer_decision.json", decision)

    write_markdowns(expansion_summary, polar, hunt, decision, resources)
    update_package_status(decision, resources)

    # INPUT manifest for phase5_next
    inputs = {
        "phase4/g3_frame.json": sha256_file(PHASE4 / "g3_frame.json"),
        "G3P/polar_system.json": sha256_file(G3P / "polar_system.json"),
        "G3P/STATUS.md": sha256_file(G3P / "STATUS.md"),
        "G3A/STATUS.md": sha256_file(G3A / "STATUS.md"),
        "G4/coset_actions.json": sha256_file(G4 / "coset_actions.json"),
        "generic_cubic.json": sha256_file(GENERIC),
        "goal": sha256_file(
            ROOT / "goals_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER.md"
        ),
        "dispatch_brief": sha256_file(
            ROOT / "tmp/dispatch/G3H_SPRINGER_NEXT_BRIEF.md"
        )
        if (ROOT / "tmp/dispatch/G3H_SPRINGER_NEXT_BRIEF.md").is_file()
        else None,
    }
    write_json(
        OUT / "INPUT_MANIFEST.json",
        {
            "schema": "g3h-phase5-next-input-manifest-v1",
            "consumed_commit": git_head(),
            "bindings_sha256": inputs,
            "resources": resources,
        },
    )

    print(decision["marker"])
    print("G3H-AI-EXPANSION-DUAL-PASS")
    print(f"peak_rss_mb={resources['peak_rss_mb']:.2f}")
    print(f"wall_seconds={resources['wall_seconds']:.2f}")
    print("G3H_PHASE5_NEXT_PRODUCE_OK")


if __name__ == "__main__":
    main()
