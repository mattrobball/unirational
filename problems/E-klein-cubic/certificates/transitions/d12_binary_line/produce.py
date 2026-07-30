#!/usr/bin/env python3
"""WP-4B producer: universal D12 binary line transition module.

Full residual-S3 / D12-equivariant module of maps on L_t = P(E_-) over the
binary invariant ring, with all-degree endpoint classification.

Does not claim global G-extension of local D12 models.
"""

from __future__ import annotations

import hashlib
import json
import math
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
TRANS = HERE.parent
CERT = TRANS.parent
ROOT = CERT.parent
sys.path.insert(0, str(TRANS))
sys.path.insert(0, str(CERT))
import common  # noqa: E402
import exact_weil_check as ew  # noqa: E402


def allowed_exponents_ordinary(degree: int) -> list[int]:
    """a such that q_a = (x^a y^{d-a}, x^{d-a} y^a) is ordinary D12-covariant."""
    if degree % 2 == 0:
        return []
    return [a for a in range(degree + 1) if (2 * a - degree - 1) % 6 == 0]


def dim_cov(degree: int) -> int:
    if degree % 2 == 0:
        return 0
    return (degree + 2) // 3


def dim_twisted(degree: int) -> int:
    """Det-twisted covariants: same dimensions (sign flip on second component)."""
    return dim_cov(degree)


def residual_module_after_delta(m: int, d: int) -> dict:
    """After mandatory Δ^m from m odd plane-order, residual degree e = d - 6m.

    For odd m, Δ^m has reflection character det, so residual is det-twisted of
    degree e (when the restriction is nonzero and d odd).
    """
    if d % 2 == 0:
        return {
            "restriction_identically_zero_or_line_base": True,
            "reason": "even d: p|_{E_-} = 0 or entire L_t is a base component",
        }
    if m % 2 == 0:
        return {
            "note": "first plane order m is odd by 4A; even m not the leading plane order",
            "dim_ordinary": dim_cov(d),
        }
    e = d - 6 * m
    if e < 0:
        return {
            "e": e,
            "forced_zero_restriction": True,
            "reason": "deg Δ^m = 6m > d, so odd restriction vanishes",
        }
    return {
        "e": e,
        "residual_type": "det_twisted",
        "dim": dim_twisted(e),
        "mandatory_factor": "Delta_t^m with Delta_t = x^6 - y^6",
    }


def endpoint_classification(e: int) -> dict:
    """Classify endpoint ledgers for det-twisted residual of degree e.

    Endpoints: the two vertices of a residual reflection, labelled (+)=[1:1],
    (-)=[1:-1] in canonical binary coordinates where s:(x,y)↔(y,x).

    Det-twisted nonzero value at a reflection-fixed vector of sign ε has
    projective sign −ε, so the *minimal* nonzero model swaps both endpoints.
    Extra vanishing of the residual at endpoints produces all four ledgers.
    """
    if e < 0:
        return {"defined": False, "reason": "negative residual degree"}
    if e % 2 == 0:
        return {
            "defined": False,
            "reason": "even residual degree: det-twisted module vanishes (same as ordinary)",
            "dim": 0,
        }
    dim = dim_twisted(e)
    # Generic ledger for nonzero det-twisted without extra endpoint factors: swap
    # Special lines in the module for e≥5 give mixed/preserve ledgers.
    if e == 1:
        return {
            "e": 1,
            "dim": 1,
            "generic_ledger": ("-", "+"),  # swap both
            "all_ledgers": ["swap_both"],
            "models": {"swap_both": "(x, -y)"},
            "endpoint_vanishing_possible": False,
        }
    if e == 3:
        return {
            "e": 3,
            "dim": 1,
            "generic_ledger": ("-", "+"),
            "all_ledgers": ["swap_both"],
            "models": {"swap_both": "(x^2 y, -x y^2) ~ (x,-y) after cancel xy? wait: actually (x^2 y, -x y^2)=(xy)(x,-y)"},
            "note": "module 1-dimensional; projective map is swap after removing invariant factors",
            "endpoint_vanishing_possible": False,
        }
    if e == 5:
        return {
            "e": 5,
            "dim": 2,
            "generic_ledger": ("-", "+"),
            "special_lines": {
                "plus_fixed_minus_to_plus": ("+", "+"),
                "plus_to_minus_minus_fixed": ("-", "-"),
            },
            "all_ledgers_in_module": [
                "swap_both",
                "plus_fixed_minus_to_plus",
                "plus_to_minus_minus_fixed",
            ],
            "preserve_both_absent": True,
            "note": "preserve_both requires higher e (e≥7) or extra (xy) factors",
        }
    # e >= 7 odd
    return {
        "e": e,
        "dim": dim,
        "generic_ledger": ("-", "+"),
        "all_ledgers": [
            "swap_both",
            "plus_fixed_minus_to_plus",
            "plus_to_minus_minus_fixed",
            "preserve_both",
        ],
        "construction": (
            "Multiply the four displayed ordinary models of degrees 7,11,11,13 "
            "(all divisible by Δ) by powers of the endpoint-nonvanishing invariant "
            "xy, or work directly in the det-twisted residual module of degree e."
        ),
        "endpoint_vanishing_orders": (
            "A full transition state must record vanishing orders at the two "
            "endpoints, not only a binary preserve/swap label."
        ),
    }


def free_presentation_ordinary():
    """⊕_d Hom_{D12}(Sym^d V, V) as module over R = Q[u,v], u=xy, v=x^6+y^6."""
    return {
        "base_ring": {
            "name": "R = Q[u, v]",
            "generators": {"u": "xy (degree 2)", "v": "x^6 + y^6 (degree 6)"},
            "relations": "none — R is a polynomial ring",
            "invariant_ring_of": "binary D12 on V = E_-(t) ≅ Q^2",
            "note": (
                "Δ^2 = (x^6 − y^6)^2 = v^2 − 4 u^6, so Δ is integral over R but "
                "not an R-element; Δ is anti-invariant under reflections."
            ),
        },
        "ordinary_module_O": {
            "definition": "O = ⊕_{d≥0} Hom_{D12}(Sym^d V, V)  (ordinary, twist=1)",
            "dimension": "dim O_d = 0 (d even); floor((d+2)/3) (d odd)",
            "free": True,
            "rank": 2,
            "generators": [
                {
                    "name": "g1",
                    "degree": 1,
                    "formula": "(x, y)",
                    "ledger_if_primitive": "preserve_both after viewing projectively as id",
                },
                {
                    "name": "g5",
                    "degree": 5,
                    "formula": "(y^5, x^5)  [the a=0 basis vector at d=5]",
                    "independent_of": "u^2 g1 = (x^3 y^2, x^2 y^3)",
                },
            ],
            "relations": "none (free of rank 2 over R)",
            "hilbert_series": {
                "formula": "t/(1-t^2) * (1 + t^4) / (1 - t^6)  with only odd powers nonzero",
                "check": "coeff of t^d = floor((d+2)/3) for d odd",
                "simplified": (
                    "sum_{k≥0} floor((2k+1+2)/3) t^{2k+1} = sum_k floor((2k+3)/3) t^{2k+1}"
                ),
                "rational_form": "(t + t^5) / ( (1 - t^2) (1 - t^6) )",
            },
            "verification_of_freeness": (
                "dim O_{2k+1} = floor((2k+3)/3).  The free module R·g1 ⊕ R·g5 has "
                "Hilbert series (t + t^5)/((1-t^2)(1-t^6)).  Expanding: "
                "1/((1-t^2)(1-t^6)) = sum_{a,b≥0} t^{2a+6b}; times t gives degrees "
                "1+2a+6b; times t^5 gives 5+2a+6b.  For odd d=2k+1 the number of "
                "representations equals floor((d+2)/3).  Checked computationally "
                "for d≤60 in the verifier."
            ),
        },
        "det_twisted_module_T": {
            "definition": "T = ⊕_d Hom_{D12}^{det}(Sym^d V, V)  (q(gv)=det(g) g q(v))",
            "dimension": "same as ordinary",
            "free": True,
            "rank": 2,
            "generators": [
                {"name": "h1", "degree": 1, "formula": "(x, -y)", "ledger": "swap_both"},
                {
                    "name": "h5",
                    "degree": 5,
                    "formula": "(y^5, -x^5)",
                    "independent_of": "u^2 h1",
                },
            ],
            "relations": "none",
            "hilbert_series": "identical to ordinary: (t + t^5)/((1-t^2)(1-t^6))",
            "relation_to_ordinary": (
                "Multiplication by Δ (degree 6, det character) gives R-module maps "
                "O → T and T → O shifting degree by 6."
            ),
        },
        "line_base_module": {
            "note": (
                "If L_t itself is a base component of transverse order n, then "
                "d+n odd (by the same character argument as 4A), and the leading "
                "exceptional map dominates L_t.  The leading module is again a "
                "copy of O or T at the residual degree."
            ),
        },
    }


def c6_and_marked_behavior():
    return {
        "C6_points_on_L_t": {
            "count": 2,
            "description": "Fix of residual C3 on L_t; size-two S3-orbit",
            "coordinates_canonical": (
                "In eigenbasis of the order-6 rotation r:(x,y)→(λx, λ^{-1}y), "
                "the C6 points are [1:0] and [0:1] (the two coordinate points)."
            ),
            "under_det_twisted_maps": (
                "h1=(x,-y) sends [1:0]→[1:0] and [0:1]→[0:1] (fixes both C6 points "
                "setwise as points; the sign is in the linear lift).  Higher maps: "
                "a det-twisted map (f, −ĝ) or similar — projective self-maps of P^1 "
                "preserving the D12-action must preserve the C6 pair setwise."
            ),
            "vanishing": (
                "Extra vanishing at a C6 point is possible for high residual degree; "
                "it is recorded as a vanishing order in the transition state."
            ),
        },
        "type_I_endpoints": {
            "count": 6,
            "description": "two per residual reflection (three reflections)",
            "six_plane_intersections": "Z_s ∩ L_t for the six noncentral involutions s∈C_G(t)",
            "Delta": "x^6 − y^6 = product of the six linear forms at those points",
        },
        "entire_line_based": {
            "possible": True,
            "when": (
                "p|_{E_-}=0 (always for even d; optionally for odd d).  Then the "
                "line is an additional base component with transverse parity "
                "constraint d+n ≡ 1 (mod 2)."
            ),
        },
        "WP3_marked_strata_restriction": {
            "reference": "certificates/strata/marked_s3_geometry.json",
            "maps_restrict_to": [
                "two C6 points (size-two orbit)",
                "six type-I V4 points (three reflection pairs)",
            ],
            "charge_link": (
                "Endpoint type-I points on L_t are the triangle vertices; their "
                "E[2]-charge lives on the elliptic side (4C), not on L_t."
            ),
        },
    }


def theorem_statements():
    return {
        "headline": "OPEN",
        "statements": [
            {
                "id": "4B.1_even_odd_restriction",
                "claim": (
                    "For a homogeneous G-covariant p of degree d: if d even then "
                    "p|_{E_-(t)}=0; if d odd then p|_{E_-} is an ordinary binary "
                    "D12-covariant E_-→E_- (or zero)."
                ),
                "status": "PROVED",
            },
            {
                "id": "4B.2_Delta_factor",
                "claim": (
                    "If the common plus-plane order is the odd integer m and the odd "
                    "restriction is nonzero, then p|_{E_-} = Δ_t^m h_t with h_t "
                    "det-twisted of degree d−6m."
                ),
                "status": "PROVED",
            },
            {
                "id": "4B.3_module_presentation",
                "claim": (
                    "The ordinary and det-twisted binary covariant modules are free of "
                    "rank 2 over R=Q[xy, x^6+y^6], generated in degrees 1 and 5.  "
                    "Hilbert series (t+t^5)/((1-t^2)(1-t^6)).  This controls ALL degrees."
                ),
                "status": "PROVED",
            },
            {
                "id": "4B.4_endpoint_classification",
                "claim": (
                    "For residual degree e=1 or 3: only swap_both.  For e=5: three "
                    "ledgers (not preserve_both).  For e≥7 odd: all four ledgers occur "
                    "in the local D12 module.  Centralizer symmetry alone does not "
                    "force a unique global transition."
                ),
                "status": "PROVED_locally",
            },
            {
                "id": "4B.5_not_global",
                "claim": (
                    "The four local endpoint ledgers are not claimed to extend to "
                    "global G-covariants; global restriction maps may cut the module."
                ),
                "status": "THEOREM_BOUNDARY",
            },
        ],
        "not_proved": [
            "Which residual ledgers survive global G-equivariance and landing",
            "A numerical common plane order m for an actual covariant",
            "unirationality / ed_C(G)",
        ],
    }


def hilbert_free_check(max_d=60):
    """Verify free rank-2 Hilbert series matches dim_cov."""
    # series (t + t^5) / ((1-t^2)(1-t^6))
    # coeff of t^d = number of (a,b) with 1+2a+6b = d plus number with 5+2a+6b = d
    errs = []
    for d in range(0, max_d + 1):
        count = 0
        # 1+2a+6b = d ⇒ 2a+6b = d-1
        if d >= 1:
            rem = d - 1
            for b in range(rem // 6 + 1):
                if (rem - 6 * b) % 2 == 0:
                    count += 1
        if d >= 5:
            rem = d - 5
            for b in range(rem // 6 + 1):
                if (rem - 6 * b) % 2 == 0:
                    count += 1
        expected = dim_cov(d)
        if count != expected:
            errs.append((d, count, expected))
    return errs


def main():
    errs = hilbert_free_check()
    assert not errs, errs[:10]

    dims = {str(d): dim_cov(d) for d in range(32)}
    exponents = {str(d): allowed_exponents_ordinary(d) for d in range(0, 32, 1)}

    # endpoint tables for residual e
    endpoint_table = {str(e): endpoint_classification(e) for e in range(0, 21)}

    # residual after Delta for sample (m,d)
    residual_samples = {}
    for m in [1, 3, 5]:
        for d in [7, 11, 13, 19, 25]:
            residual_samples[f"m{m}_d{d}"] = residual_module_after_delta(m, d)

    recovery = {
        "tmp/d12_line_restriction/REPORT.md": common.sha256_file(
            ROOT / "tmp/d12_line_restriction/REPORT.md"
        ),
        "tmp/d12_line_restriction/verify.py": common.sha256_file(
            ROOT / "tmp/d12_line_restriction/verify.py"
        ),
    }

    payload = {
        "work_package": "WP-4B",
        "headline": "OPEN",
        "stratum": {
            "label": "C2_line",
            "closure": "L_t = P(E_-(t)) ≅ P^1 ⊂ X",
            "orbit_size": 55,
            "generic_stabilizer_H": "C2 = <t>",
            "setwise_stabilizer": "D12 = C_G(t)",
            "residual": "S3",
            "on_X": True,
        },
        "binary_representation": {
            "V": "E_-(t), dim 2",
            "canonical_action": {
                "rotation_r": "r(x,y) = (λ x, λ^{-1} y), λ^6=1 primitive",
                "reflection_s": "s(x,y) = (y, x)",
                "involution_t": "r^3 = −Id on V (projectively id on L_t)",
            },
            "identification": (
                "Certified inside the 5-dimensional Klein representation at good "
                "prime 67 by the upstream d12_line_restriction verifier; intrinsic "
                "binary module is characteristic-zero."
            ),
        },
        "module": {
            "definition_ordinary": "O_d = Hom_{D12}(Sym^d V, V)",
            "definition_det_twisted": "T_d = Hom_{D12}^{det}(Sym^d V, V)",
            "dimension_formula": {
                "even_d": 0,
                "odd_d": "floor((d+2)/3)",
            },
            "dimensions_d0_to_31": dims,
            "basis_exponents_ordinary": exponents,
            "finite_presentation": free_presentation_ordinary(),
            "controls": "ALL source degrees d and ALL residual orders after Δ^m",
            "hilbert_series_ordinary": "(t + t^5) / ((1 - t^2) (1 - t^6))",
            "hilbert_series_det_twisted": "(t + t^5) / ((1 - t^2) (1 - t^6))",
            "free_check_d_le_60": True,
        },
        "plus_plane_coupling": {
            "mandatory_Delta": "Δ_t = x^6 − y^6",
            "for_odd_plane_order_m": "p|_{E_-} = Δ_t^m * h_t, h_t ∈ T_{d-6m}",
            "residual_samples": residual_samples,
        },
        "endpoint_classification": endpoint_table,
        "C6_and_marked": c6_and_marked_behavior(),
        "geometric_theorem": theorem_statements(),
        "recovery": {
            "packet": "tmp/d12_line_restriction/",
            "terminal_marker_upstream": "D12_LINE_RESTRICTION_AUDIT_OK",
            "sha256": recovery,
        },
        "regressions": {
            "dim_d1": 1,
            "dim_d5": 2,
            "dim_d7": 3,
            "dim_d11": 4,
            "example_ledgers_local": {
                "swap_both": {"degree": 7, "ledger": ["-", "+"]},
                "plus_fixed_minus_to_plus": {"degree": 11, "ledger": ["+", "+"]},
                "plus_to_minus_minus_fixed": {"degree": 11, "ledger": ["-", "-"]},
                "fix_both": {"degree": 13, "ledger": ["+", "-"]},
            },
        },
        "producer": "certificates/transitions/d12_binary_line/produce.py",
        "verifier": "certificates/transitions/d12_binary_line/verify.py",
        "theorem_boundary": (
            "Complete free presentation of the binary D12 transition module and "
            "local endpoint classification in all degrees.  Local models are not "
            "global G-covariants.  Headline OPEN."
        ),
    }

    body_obj = dict(payload)
    body = json.dumps(body_obj, indent=2, sort_keys=True) + "\n"
    payload["self_sha256"] = hashlib.sha256(body.encode()).hexdigest()
    out_path = HERE / "module.json"
    out_path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("wrote", out_path)
    print("self_sha256", payload["self_sha256"])
    print("D12_BINARY_LINE_MODULE_PRODUCED")


if __name__ == "__main__":
    main()
