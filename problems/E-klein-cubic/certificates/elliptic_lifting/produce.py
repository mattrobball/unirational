#!/usr/bin/env python3
"""WP-E1 producer: Pic^0-valued obstruction on the marked elliptic E_t.

Recovers the order-twelve quadratic-trace obstruction as a regression theorem
of the Pic^0 formalism, then tests the same trace machine on the live WP-L2
families.

Does NOT import verify.py.  No timing fields.  Headline OPEN.
Read-only use of fable packets after hash-check.
"""

from __future__ import annotations

import hashlib
import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
CERT = HERE.parent
ROOT = CERT.parent

FABLE_DIV = ROOT / "tmp" / "fable_relative_divisor_trace_obstruction"
FABLE_Q = ROOT / "tmp" / "fable_relative_q_trace_obstruction"

# Expected hashes from the accepted packets (hash-check before use)
FABLE_HASHES = {
    "tmp/fable_relative_divisor_trace_obstruction/REPORT.md":
        "cfcda8682c86eb48222bfda6888aeec6580d362afd0a29d18a267b3696425573",
    "tmp/fable_relative_divisor_trace_obstruction/PROOF_AUDIT.md":
        "0cb5758e391e7b6b1986873139dbc99797fa1aa87bd96df63d253b7cfca5b499",
    "tmp/fable_relative_divisor_trace_obstruction/verify.py":
        "cdc46b4568f152b3bc24636949674e4f58ce924124c295ed89e32851c5361ca5",
    "tmp/fable_relative_q_trace_obstruction/REPORT.md":
        "bda7bf9a58025c15c097ce183f43655a9743f23e6e535776af3712f004bc452c",
    "tmp/fable_relative_q_trace_obstruction/PROOF_AUDIT.md":
        "bce1914db25b3c6d1cb451ffdca7c05e6e69b3dc97c8b974afcf41a85d0e29e7",
    "tmp/fable_relative_q_trace_obstruction/verify.py":
        "f9884d21a6d39170ba029348f3c10d21076c5b280937313382111408e5d82c40",
}


def sha256_file(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def canonical_json(obj) -> str:
    return json.dumps(obj, indent=2, sort_keys=True) + "\n"


def hash_check_fable() -> dict:
    out = {}
    for rel, exp in FABLE_HASHES.items():
        p = ROOT / rel
        assert p.exists(), rel
        h = sha256_file(p)
        assert h == exp, (rel, h, exp)
        out[rel] = h
    return out


def pic0_formalism() -> dict:
    """Record the Pic^0 formalism on E_t."""
    return {
        "curve": "E_t = X ∩ P(E_+(t)), smooth plane cubic",
        "j_invariant": "8192/11",
        "no_CM": True,
        "Aut_group_origin": "{±1}",
        "identification": (
            "After origin choice O ∈ E_t, Pic^0(E_t) ≅ E_t via "
            "L ↦ sum n_i(P_i) with deg 0 ↔ Σ n_i P_i in the group law."
        ),
        "origin_convention": (
            "Prefer a type-I point as origin so type-I = <q>, "
            "type-II = e+<q> for 0≠e∈E[2] (accepted WP-3)."
        ),
        "house_rule_7": (
            "Full Pic^0 class is the invariant; do not argue from finite "
            "E[2]-charge alone."
        ),
        "residual_actions": {
            "translation_by_q": {
                "element": "order-3 ρ ∈ residual S3 ≅ C_G(t)/<t>",
                "action_on_E": "P ↦ P + q,  0 ≠ q ∈ E_t[3]",
                "action_on_Pic0": (
                    "pullback ρ^* : Pic^0 → Pic^0 is translation by q on the "
                    "identified elliptic, i.e. L ↦ t_q^* L.  On degree-0 "
                    "divisor classes [P−O] ↦ [P+q − O] only after adjusting "
                    "origin; more invariantly, ρ acts as translation on E≅Pic^0."
                ),
                "proof_ref": "certificates/strata/marked_s3_geometry.json; j≠0",
            },
            "reflections": {
                "elements": "three residual order-2 elements of S3",
                "action_on_E": "P ↦ e_i − P for the three nonzero e_i ∈ E[2]",
                "action_on_Pic0": (
                    "hyperelliptic involution through e_i: on Pic^0, "
                    "inversion composed with translation by e_i."
                ),
            },
        },
        "trace_and_norm": {
            "quadratic_extension": (
                "L/K separable quadratic with deck involution τ, K=C(P) or "
                "function field of the plane / a rational base."
            ),
            "trace_Pic0": (
                "For a class ξ ∈ Pic^0(E)(L), set Tr_{L/K}(ξ) = ξ + τ(ξ) ∈ "
                "Pic^0(E)(K).  Under E≅Pic^0 this is the elliptic sum of "
                "Gal(τ)-conjugates."
            ),
            "norm_Pic0": (
                "Nm_{L/K}(ξ) = ξ + τ(ξ) in the abelian group Pic^0 (same as "
                "trace for elliptic group law written additively)."
            ),
            "constancy": (
                "Any K-point of E with K=C(P²) is constant: no nonconstant "
                "rational map P² → E (restrict to general lines → P¹→E)."
            ),
        },
    }


def order12_regression_theorem() -> dict:
    """Recover the order-twelve quadratic-trace obstruction as a Pic^0 theorem."""
    return {
        "name": "Order-twelve quadratic-trace obstruction (Pic^0 form)",
        "status": "PROVED_AS_REGRESSION",
        "strength": "residual_S3_equivariant_identity on one elliptic",
        "strength_not": [
            "global_G_equivariant_gluing_theorem",
            "obstruction_to_all_formal_lifts_of_all_families",
        ],
        "antecedent": {
            "ansatz": (
                "Factorized first-gate germ on a fixed involution plane: "
                "p_3 = q_P R_P, p_4 = ι_{Γ_{R_P}} η_P, with the audited "
                "nonzero three-line Fable boundary."
            ),
            "Z_P": (
                "Primitive horizontal degree-two part of V(q_P) ⊂ P(N_{P/P(W)})."
            ),
            "necessary_residue": (
                "F(p_4)|_{Z_P} = 0 is necessary for the order-12 landing "
                "gate; allowed I^{(5)}/I^{(7)} corrections cannot change it "
                "(order-twelve residue ledger)."
            ),
            "source_packets": [
                "tmp/fable_relative_divisor_trace_obstruction/",
                "tmp/fable_relative_q_trace_obstruction/",
            ],
        },
        "construction_of_class": {
            "step1": (
                "If F(p_4)|_{Z_P}=0 and p_4 generically nonzero on Z_P, then "
                "f = [p_4] : Z_P ⇢ E_t is a rational map to the plus-plane "
                "elliptic (p_4 is E_+-valued of even normal order)."
            ),
            "step2_Pic0": (
                "On a horizontal component with function field L, the point "
                "f determines ξ = [f − O] ∈ Pic^0(E_t)(L) ≅ E_t(L)."
            ),
            "step3_trace": (
                "For irreducible horizontal quadratic L/K, K=C(P), the "
                "trace Tr(ξ) = ξ + τξ lies in Pic^0(E_t)(K) ≅ E_t(K).  "
                "Constancy of maps P²⇢E forces Tr(ξ) = C constant in E_t(C)."
            ),
            "step4_translation": (
                "Residual order-three ρ acts on E_t by P ↦ P+q, q≠0 in E[3], "
                "and normalizes the quadratic cover (commutes with τ).  "
                "Equivariance of f (residual S3 / stabilizer equivariance of "
                "the germ) gives ρ·ξ = t_q(ξ) in Pic^0."
            ),
            "step5_contradiction": (
                "C = Tr(ξ) = Tr(ρ·ξ) = Tr(ξ + q) = Tr(ξ) + 2q = C + 2q.  "
                "Since 3q=0, 2q = −q ≠ 0, contradiction."
            ),
            "split_and_nonreduced": (
                "Split horizontal quadratic: each component birational to P, "
                "so f constant on each, equivariance ⇒ c = c+q.  Nonreduced: "
                "unique reduced component, same.  Vertical factors irrelevant "
                "after taking primitive horizontal part."
            ),
        },
        "finite_quotient_exhibit": {
            "quotient": "E_t[3] ≅ (Z/3)² ⊂ Pic^0(E_t), via the translation class q",
            "invariant_class": (
                "The obstruction is the nonzero class 2q = −q in E_t[3] ⊂ "
                "Pic^0, forced to vanish by equivariant trace constancy."
            ),
            "independence_of_choices": [
                "Origin change replaces q by ±q; 2q=−q still nonzero",
                "Scale of p_4 does not change [p_4] in P(E_+)",
                "Representative of p_4 mod I^{(5)} does not change the residue",
                "Choice of horizontal component: both give the same contradiction pattern",
            ],
            "protocol": (
                "House rule 12: invariant class exhibited in the exact finite "
                "quotient E[3] of Pic^0; independence recorded; STOP for this "
                "ansatz — do not add higher-order corrections around it."
            ),
        },
        "scope": (
            "Kills the factorized Fable/Koszul full relative-divisor antecedent "
            "with audited nonzero three-line boundary at the order-twelve gate.  "
            "Does not kill nonfactorized first normal forms, unrelated "
            "full-threefold constructions, or the three WP-5 survivor families "
            "without additional hypotheses."
        ),
        "proof_type": "function-field / Pic^0 trace; no resolution of singularities required",
    }


def induced_divisor_class_from_jets() -> dict:
    """How WP-L2 jets induce Pic^0 data on E_t."""
    return {
        "leading_a_m": {
            "target": "E_- (odd normal order)",
            "evaluation_on_E_t": (
                "a_m is E_--valued; it does not directly define a map to E_t.  "
                "Restriction of a_m to the zero section of the normal cone is "
                "zero for m>0.  The associated map on the exceptional divisor "
                "P(N) → L_t = P(E_-) is the projectivized leading jet "
                "(dominates L_t by 4A.3).  Pic^0(E_t) is not the target of a_m."
            ),
            "divisor_on_E_t": (
                "No canonical degree-0 class on E_t from a pure E_--valued jet.  "
                "Finite E[2]-charge labels on marked points remain discrete "
                "WP-3 data (house rule 7: not sufficient alone)."
            ),
        },
        "correction_b_m1": {
            "target": "E_+ (even normal order m+1)",
            "evaluation_on_E_t": (
                "At a point z ∈ E_t ⊂ P(E_+), if the normal-order-(m+1) piece "
                "b_{m+1}(z, y) is considered as a polynomial in the normal "
                "variable y with values in E_+, its vanishing or its "
                "projectivization can define maps from subschemes of the "
                "normal cone to E_t."
            ),
            "L1_constraint": (
                "L_1(b)=B(b;a,a)=0 is a scalar condition on the normal cone, "
                "not the same as F(b)|_{E_t}=0.  Only when an auxiliary "
                "horizontal quadratic (or higher) cover Z → P is cut out so "
                "that b defines f: Z ⇢ E_t does a Pic^0 class appear."
            ),
            "transformation_P_to_P_plus_q": (
                "If f: Z ⇢ E_t is residual-order-three equivariant, then "
                "f(ρ·z) = f(z) + q in E_t."
            ),
            "transformation_under_reflections": (
                "If f is residual-reflection equivariant, "
                "f(σ_i·z) = e_i − f(z)."
            ),
        },
        "stage_r3_residual": {
            "R3": "2 B(b; a, a2) + F_+(b)",
            "F_plus_on_E_t": (
                "F_+ vanishes on E_t by definition of E_t = X ∩ P(E_+).  "
                "The class of F_+(b) as a section vanishing on E_t relates to "
                "the divisor of contact of the image of b with E_t, but is not "
                "automatically a Pic^0 obstruction without a cover and trace."
            ),
        },
    }


def trace_tests() -> dict:
    """Apply the quadratic-trace machine to the four listed cases."""

    def case(name, applies, strength, reason, missing=None):
        return {
            "case": name,
            "trace_obstruction_applies": applies,
            "strength": strength,
            "reason": reason,
            "missing_for_stronger": missing,
        }

    return {
        "protocol": (
            "Each claim is labelled by strength: (D) divisor identity on one "
            "elliptic; (S3) residual-S3-equivariant identity; (G) global "
            "G-equivariant gluing theorem.  These are not interchangeable."
        ),
        "cases": [
            case(
                name="based_minus_lines_odd_m — arbitrary odd m",
                applies=False,
                strength="not_applicable_without_extra_ansatz",
                reason=(
                    "(D)/(S3): The based family has p|_{E_-}=0 and leading jet "
                    "a_m : exceptional → L_t.  There is no built-in horizontal "
                    "quadratic cover Z_P from a factorized q_P, and b_{m+1} is "
                    "constrained by B(b;a,a)=0 rather than by F(b)|_{Z_P}=0.  "
                    "The order-twelve quadratic-trace hypothesis (equivariant "
                    "map Z_P ⇢ E_t from an even jet with quadratic horizontal "
                    "trace) is not part of the based-family definition.  "
                    "Hence the Pic^0 trace contradiction does not fire on the "
                    "raw based family."
                ),
                missing=(
                    "A theorem producing, from a based formal lift, a residual-"
                    "S3-equivariant rational map from a quadratic cover of the "
                    "plane to E_t with nonzero translation equivariance — not "
                    "established in this dispatch."
                ),
            ),
            case(
                name="residual_e1_swap_both — unique e=1 all-swap",
                applies=False,
                strength="not_applicable_without_extra_ansatz",
                reason=(
                    "(D)/(S3): The e=1 swap_both residual fixes the source-line "
                    "coefficient coupling p|_{E_-}=Δ^m h with h of degree 1.  "
                    "This is a coefficient coupling on L_t^{src}, orthogonal to "
                    "the normal-cone Pic^0 data on E_t.  No quadratic horizontal "
                    "cover of the plus-plane is forced by e=1 alone.  The "
                    "order-twelve trace obstruction does not apply as stated."
                ),
                missing=(
                    "Identification of a quadratic cover from the e=1 residual "
                    "or from L_1-kernel geometry, with residual-S3 equivariance "
                    "of the induced map to E_t."
                ),
            ),
            case(
                name="residual_e_ge7_generic_swap_both — generic odd e≥7",
                applies=False,
                strength="not_applicable_without_extra_ansatz",
                reason=(
                    "(D)/(S3): Generic e≥7 enlarges the det-twisted residual "
                    "module but still supplies source-line data, not a "
                    "quadratic cover of P(E_+).  Same gap as e=1."
                ),
                missing=(
                    "Same as e=1: a bridge from residual line data or L_r "
                    "kernels to an equivariant quadratic cover map into E_t."
                ),
            ),
            case(
                name="non-planewise corrections",
                applies=False,
                strength="not_applicable",
                reason=(
                    "(G): Non-planewise corrections (jets not supported on a "
                    "single plus-plane normal cone) fall outside the single-"
                    "involution Pic^0 formalism developed here.  A global G-"
                    "equivariant gluing theorem would be required; none is "
                    "claimed.  The order-twelve trace obstruction is a "
                    "single-plane residual-S3 statement and does not "
                    "automatically globalize."
                ),
                missing=(
                    "Global G-gluing of Pic^0 classes across the 55-plane "
                    "orbit, or a different global blocker (WP-T1 / WP-H1)."
                ),
            ),
            case(
                name="REGRESSION: factorized Fable order-twelve gate",
                applies=True,
                strength="residual_S3_equivariant (S3); finite quotient E[3]⊂Pic^0",
                reason=(
                    "Recovered above as the order-twelve quadratic-trace "
                    "theorem.  The obstruction class is the nonzero 2q∈E[3].  "
                    "STOP for that ansatz (house rule 12)."
                ),
                missing=None,
            ),
        ],
        "summary": {
            "regression_order12": "RECOVERED",
            "live_families_killed_by_same_trace": False,
            "note": (
                "A structural kill of the three WP-5 families by Pic^0 trace "
                "is not available without additional geometric input producing "
                "an equivariant quadratic cover map to E_t.  That is a "
                "precisely delimited gap, not a negative or positive theorem."
            ),
        },
    }


def build_payload() -> dict:
    hashes = hash_check_fable()
    pic = pic0_formalism()
    reg = order12_regression_theorem()
    jets = induced_divisor_class_from_jets()
    tests = trace_tests()

    # Accepted geometry hashes
    accepted = {}
    for rel in [
        "certificates/strata/marked_s3_geometry.json",
        "certificates/lifting/polar_expansion.json",
        "certificates/transition_repair/category_repaired.json",
    ]:
        p = ROOT / rel
        if p.exists():
            accepted[rel] = sha256_file(p)

    return {
        "work_package": "WP-E1",
        "headline": "OPEN",
        "gate": "Second dispatch — Pic^0 obstruction parallel to WP-L2",
        "fable_hash_check": hashes,
        "pic0_formalism": pic,
        "order12_quadratic_trace_regression": reg,
        "induced_classes_from_WP_L2_jets": jets,
        "trace_tests": tests,
        "obstruction_protocol_house_rule_12": {
            "order12_ansatz": (
                "Invariant class −q ∈ E[3] ⊂ Pic^0 exhibited; independence "
                "recorded; STOP for the factorized Fable order-twelve gate."
            ),
            "live_families": (
                "No certified nonzero invariant class in a finite quotient of "
                "Pic^0 obstructing the three WP-5 families was found; do not "
                "fake one.  Continue with WP-L2 tower / other blockers."
            ),
        },
        "theorem_boundary": {
            "proved": [
                "Pic^0 formalism on E_t with residual translation by q and reflections",
                "Trace/norm on Pic^0(E_t)-valued data through quadratic extensions",
                "Order-twelve quadratic-trace obstruction recovered as Pic^0 regression theorem",
                "Invariant class −q in E[3] for that ansatz; independence of choices",
                "Trace test applied to four listed cases with D / S3 / G labels",
            ],
            "not_proved": [
                "Pic^0 kill of based_minus_lines_odd_m for arbitrary odd m",
                "Pic^0 kill of residual_e1_swap_both",
                "Pic^0 kill of residual_e_ge7_generic_swap_both",
                "Pic^0 kill of non-planewise corrections",
                "Global G-equivariant gluing of elliptic Pic^0 classes",
            ],
        },
        "accepted_input_sha256": accepted,
        "producer": {
            "script": "certificates/elliptic_lifting/produce.py",
            "does_not_import": "verify.py",
        },
    }


def write_json(path: Path, body: dict) -> str:
    payload = dict(body)
    payload.pop("self_sha256", None)
    text = canonical_json(payload)
    h = sha256_bytes(text.encode())
    payload["self_sha256"] = h
    path.write_text(canonical_json(payload))
    return h


def main():
    body = build_payload()
    write_json(HERE / "picard_data.json", body)
    print("wrote picard_data.json")
    print("order12 recovered:", body["order12_quadratic_trace_regression"]["status"])
    print("live families killed:", body["trace_tests"]["summary"]["live_families_killed_by_same_trace"])


if __name__ == "__main__":
    main()
