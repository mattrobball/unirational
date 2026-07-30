#!/usr/bin/env python3
"""WP-R0 producer: source / normal-direction / target separation.

Repairs the global transition category so that the three isomorphic residual
D12-spaces P(E_-(t)) are distinguished:

  1. L_t^src  = P(E_-(t)) subset P(W)           (source fixed line)
  2. P(E_-)^{N}  factor of P(N_{Z_t/Y})        (exceptional normal direction)
  3. L_t^tgt  = P(E_-(t)) subset X^t           (target fixed line)

Does NOT import verify.py.  No timing fields.  Exact arithmetic only.
Headline remains OPEN.  No negative theorem is inferred from the repair.
"""

from __future__ import annotations

import hashlib
import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
CERT = HERE.parent
ROOT = CERT.parent
GT = CERT / "global_transition"
sys.path.insert(0, str(GT))

from common_global import (  # noqa: E402
    ACCEPTED_INPUTS,
    canonical_json,
    input_hashes,
    load_json,
    sha256_bytes,
    sha256_file,
)

ARROW_TYPES = (
    "SOURCE-RESTRICTION",
    "NORMAL-CONE-SPECIALIZATION",
    "TARGET-EVALUATION",
    "COEFFICIENT-COUPLING",
)

# Three distinguished copies of P(E_-), distinguished by path and type.
THREE_COPIES = {
    "L_t_src": {
        "id": "L_t_src",
        "symbol": "L_t^{src}",
        "definition": "P(E_-(t)) subset P(W)",
        "role": "source_fixed_line",
        "ambient": "P(W)",
        "on_X": True,
        "meets_Z_t": False,
        "disjointness": "L_t^{src} ∩ Z_t = empty (E_+ ∩ E_- = 0)",
        "path_tag": "SOURCE",
    },
    "P_E_minus_normal": {
        "id": "P_E_minus_normal",
        "symbol": "P(E_-)^{N}",
        "definition": "second factor of P(N_{Z_t/Y}) ≅ Z_t × P(E_-(t))",
        "role": "exceptional_normal_direction",
        "ambient": "P(N_{Z_t/Y})",
        "on_X": "fiberwise target of leading odd-m jet lands in X",
        "meets_Z_t": "projects to Z_t along the P1-bundle",
        "path_tag": "NORMAL",
    },
    "L_t_tgt": {
        "id": "L_t_tgt",
        "symbol": "L_t^{tgt}",
        "definition": "P(E_-(t)) subset X^t",
        "role": "target_fixed_line",
        "ambient": "X^t subset X",
        "on_X": True,
        "path_tag": "TARGET",
        "note": "image of the odd-m leading normal map from the exceptional divisor",
    },
}


def classify_legacy_flag(flag: dict) -> dict:
    """Classify each legacy diagram flag into one of the four arrow types.

    The unique legacy conflation is plane_to_minus_line (C2_plane -> C2_line),
    which mixed normal-cone specialization, target evaluation, and the
    coefficient coupling of the source-line restriction.  It is replaced, not
    retained as a single arrow.
    """
    fid = flag["id"]
    src = flag["source"]
    tgt = flag["target"]
    geom = flag.get("geometry", "")
    map_type = flag.get("specialization", {}).get("map_type", "")

    # --- the conflated arrow: split, do not keep as one edge ---
    if fid == "plane_to_minus_line":
        return {
            "legacy_id": fid,
            "legacy_source": src,
            "legacy_target": tgt,
            "status": "REPLACED",
            "reason": (
                "Conflated three copies of P(E_-): treated L_t as both the "
                "boundary of the normal cone of Z_t and the source fixed line. "
                "L_t^{src} ∩ Z_t = empty, so no ordinary restriction map "
                "Z_t -> L_t exists."
            ),
            "replacement_span": [
                "normal_cone_projection",
                "normal_cone_to_target_line",
                "source_line_restriction",
                "coefficient_coupling_terminal",
            ],
            "forbidden_identification": {
                "claim": "L_t^{src} is a subvariety of Z_t = P(E_+)",
                "status": "REJECTED",
                "reason": "E_+ ∩ E_- = 0 in W, so P(E_-) ∩ P(E_+) = empty in P(W)",
            },
        }

    # --- source restrictions: evaluate / restrict from ambient source geometry ---
    if fid in {
        "minus_line_to_type_I",
        "minus_line_to_C6",
        "C3_line_to_C6",
        "C3_line_to_A4",
        "plane_to_elliptic",
        "plane_to_D10",
        "plane_to_D12",
        "V4_line_to_D12",
        "V4_line_to_A4",
        "A4_to_planes",
    }:
        # A4_to_planes is incidence reverse (point to planes): still a
        # geometric restriction/incidence of source strata, not normal-cone.
        return {
            "legacy_id": fid,
            "legacy_source": src,
            "legacy_target": tgt,
            "status": "RETAINED",
            "arrow_type": "SOURCE-RESTRICTION",
            "geometry": geom,
            "map_type": map_type,
            "P_E_minus_involvement": "none_or_source_line_only",
            "note": (
                "Ordinary incidence restriction between source strata "
                "(or source-stratum evaluation). Does not identify the three "
                "copies of P(E_-)."
            ),
        }

    # --- normal-cone specializations along forced base (plus-plane / V4) ---
    if fid in {
        "plane_to_triple_line",
        "V4_line_to_type_I",
        "V4_line_to_type_II",
    }:
        return {
            "legacy_id": fid,
            "legacy_source": src,
            "legacy_target": tgt,
            "status": "RETAINED",
            "arrow_type": "NORMAL-CONE-SPECIALIZATION",
            "geometry": geom,
            "map_type": map_type,
            "note": (
                "Specialization of normal jets along forced base components "
                "(plane normalization → triple-line equalizer, or pure character "
                "normal directions on the V4 line). Lives on the source / normal "
                "side; target charges are labels, not L_t^{tgt}."
            ),
        }

    # --- target evaluation: marked elliptic charges and their transport ---
    if fid in {
        "type_II_to_three_elliptics",
        "type_I_to_one_elliptic",
    }:
        return {
            "legacy_id": fid,
            "legacy_source": src,
            "legacy_target": tgt,
            "status": "RETAINED",
            "arrow_type": "TARGET-EVALUATION",
            "geometry": geom,
            "map_type": map_type,
            "note": (
                "Charge / residual evaluation on the target marked elliptic "
                "X ∩ Z_t (and its type-I/II points). Distinct from source-line "
                "restriction and from the exceptional normal factor."
            ),
        }

    raise AssertionError(f"unclassified legacy flag: {fid}")


def repaired_objects() -> dict:
    """Objects of the repaired incidence category (orbit types + three copies)."""
    legacy = load_json(GT / "diagram.json")
    objects = dict(legacy["incidence_category"]["objects"])

    # Split C2_line into source vs target roles; keep orbit metadata.
    c2_line = objects["C2_line"]
    objects["L_t_src"] = {
        **{k: v for k, v in c2_line.items() if k not in ("closure", "note")},
        "id": "L_t_src",
        "role": "source_fixed_line",
        "closure": "L_t^{src} = P(E_-(t)) subset P(W), and L_t^{src} subset X",
        "three_copy": "L_t_src",
        "disjoint_from_Z_t": True,
        "module_ref": c2_line.get("module_ref"),
        "note": (
            "SOURCE copy of P(E_-). Restriction of a covariant to E_- is the "
            "terminal normal coefficient p_d(0,y), not a restriction of the "
            "first normal jet of p along Z_t."
        ),
    }
    objects["L_t_tgt"] = {
        "id": "L_t_tgt",
        "role": "target_fixed_line",
        "H": "C2",
        "N_G": "D12",
        "orbit_size": 55,
        "on_X": True,
        "closure": "L_t^{tgt} = P(E_-(t)) subset X^t",
        "three_copy": "L_t_tgt",
        "forced_base": False,
        "module_ref": "transitions/d12_binary_line/module.json",
        "note": (
            "TARGET copy of P(E_-). For odd first normal order m the leading "
            "normal map on P(N_{Z_t/Y}) dominates L_t^{tgt} (4A.3)."
        ),
    }
    objects["P_N_Zt_Y"] = {
        "id": "P_N_Zt_Y",
        "role": "exceptional_normal_projectivization",
        "definition": "P(N_{Z_t/Y}) ≅ Z_t × P(E_-(t))",
        "factors": {
            "base": "Z_t = P(E_+(t)) = C2_plane",
            "fiber": "P(E_-)^{N}  (NORMAL copy of P(E_-))",
        },
        "three_copy_fiber": "P_E_minus_normal",
        "H": "C2",
        "N_G": "D12",
        "orbit_size": 55,
        "note": (
            "Exceptional divisor of the blowup of Y along Z_t. The NORMAL copy "
            "of P(E_-) is the fiber, not L_t^{src}."
        ),
    }
    objects["C2_plane"] = {
        **objects["C2_plane"],
        "also_called": "Z_t^{src}",
        "note_repair": (
            "Source plus-plane. Forced base (4A.1). First normal order m odd. "
            "Does not contain L_t^{src}."
        ),
    }
    # Keep C2_line as a deprecated alias pointing at the split.
    objects["C2_line"] = {
        **c2_line,
        "deprecated_as_single_object": True,
        "split_into": ["L_t_src", "L_t_tgt", "P_E_minus_normal"],
        "note": (
            "DEPRECATED as a single incidence object. Use L_t_src / L_t_tgt / "
            "P_E_minus_normal. Residual D12-modules still apply to each copy "
            "separately by transport of structure."
        ),
    }
    return objects


def repaired_arrows() -> list:
    """Full arrow list of the repaired category."""
    arrows = []

    # ---- replacement span for the conflated plane_to_minus_line ----
    arrows.append(
        {
            "id": "normal_cone_projection",
            "arrow_type": "NORMAL-CONE-SPECIALIZATION",
            "source": "P_N_Zt_Y",
            "target": "C2_plane",
            "geometry": "bundle projection P(N_{Z_t/Y}) → Z_t",
            "three_copy_path": {
                "uses": ["P_E_minus_normal"],
                "as": "fiber of the P1-bundle",
            },
            "replaces_part_of": "plane_to_minus_line",
            "exactness_level": (
                "sheaf-level on the exceptional divisor; literal graded pieces "
                "may differ by irrelevant torsion T_m"
            ),
        }
    )
    arrows.append(
        {
            "id": "normal_cone_to_target_line",
            "arrow_type": "TARGET-EVALUATION",
            "source": "P_N_Zt_Y",
            "target": "L_t_tgt",
            "geometry": (
                "For odd m, leading normal jet is E_--valued and induces a "
                "C_G(t)-equivariant map P(N_{Z_t/Y}) → L_t^{tgt} dominating "
                "the target fixed line (4A.3)."
            ),
            "three_copy_path": {
                "from": "P_E_minus_normal",
                "to": "L_t_tgt",
                "identification": (
                    "fiber coordinate = target line coordinate as residual "
                    "D12-spaces; geometrically this is evaluation of the leading "
                    "jet, not the source-line embedding"
                ),
            },
            "replaces_part_of": "plane_to_minus_line",
            "for_odd_m": "leading jet lands in E_- and dominates L_t^{tgt}",
            "for_even_m": "forbidden for landing (4A.2)",
        }
    )
    arrows.append(
        {
            "id": "source_line_restriction",
            "arrow_type": "SOURCE-RESTRICTION",
            "source": "L_t_src",
            "target": "X_t_fixed",  # conceptual target: X^t as ambient for restriction values
            "geometry": (
                "Restriction of a global polynomial map p: W → W to the source "
                "fixed line L_t^{src} = P(E_-). Lands in X^t when F(p)=0."
            ),
            "three_copy_path": {"uses": ["L_t_src"], "as": "domain of restriction"},
            "replaces_part_of": "plane_to_minus_line",
            "not_a_restriction_from": "C2_plane",
            "reason_not_from_plane": "L_t^{src} ∩ Z_t = empty",
        }
    )
    arrows.append(
        {
            "id": "coefficient_coupling_terminal",
            "arrow_type": "COEFFICIENT-COUPLING",
            "source": "normal_expansion_of_p",
            "target": "L_t_src",
            "geometry": (
                "Terminal coefficient coupling: write x = z + y with z ∈ E_+, "
                "y ∈ E_-. Decompose p(z,y) = sum_{r=0}^d p_r(z,y) with "
                "p_r ∈ Sym^{d-r} E_+^∨ ⊗ Sym^r E_-^∨ ⊗ W. Then "
                "p|_{E_-} = p_d(0,y). Equivariance forces p_r E_+-valued for "
                "even r and E_--valued for odd r."
            ),
            "formula": {
                "decomposition": "p(z,y) = sum_{r=0}^d p_r(z,y)",
                "parity": (
                    "p_r is E_+-valued for even r and E_--valued for odd r"
                ),
                "source_restriction": "p|_{E_-} = p_d(0,y)",
                "based_family": (
                    "based_minus_lines_odd_m forces p_d(0,y) = 0 "
                    "(entire source line based)"
                ),
                "residual_family": (
                    "residual families force p_d(0,y) = Δ_t^m h_t with "
                    "h_t det-twisted of residual degree e = d - 6m"
                ),
                "not_first_jet": (
                    "p|_{E_-} is NOT the restriction of the order-m normal jet "
                    "along Z_t; that jet lives on P(N_{Z_t/Y})"
                ),
            },
            "three_copy_path": {
                "couples": ["P_E_minus_normal", "L_t_src"],
                "mechanism": (
                    "same residual D12-module transport, different geometric "
                    "realization: normal fiber coordinate vs source embedding"
                ),
            },
            "replaces_part_of": "plane_to_minus_line",
        }
    )

    # ---- retained legacy arrows with types ----
    legacy = load_json(GT / "diagram.json")
    for flag in legacy["incidence_category"]["flags"]:
        clf = classify_legacy_flag(flag)
        if clf["status"] == "REPLACED":
            continue
        arrows.append(
            {
                "id": flag["id"],
                "arrow_type": clf["arrow_type"],
                "source": flag["source"],
                "target": flag["target"],
                "geometry": flag.get("geometry"),
                "specialization": flag.get("specialization"),
                "multiplicity_per_source": flag.get("multiplicity_per_source"),
                "multiplicity_global_flags": flag.get("multiplicity_global_flags"),
                "legacy_status": "RETAINED",
                "three_copy_path": {
                    "uses": [],
                    "note": clf.get("note"),
                },
            }
        )
    return arrows


def coefficient_coupling_block() -> dict:
    """Explicit coefficient coupling (director-verified algebra)."""
    return {
        "name": "normal_expansion_coefficient_coupling",
        "setup": {
            "involution": "t acts +1 on E_+, −1 on E_-",
            "coordinates": "x = z + y, z ∈ E_+, y ∈ E_-",
            "F_parity": (
                "F is G-invariant and t ∈ G, so F(z+y)=F(z−y). Every term odd "
                "in y dies. Combined with F|_{E_-}=0 one obtains "
                "F(z+y) = F(z) + 3 Φ(z,y,y) = F_+(z) + B(z;y,y)."
            ),
            "director_verified": True,
        },
        "covariant_parity": {
            "condition": "p(t x) = t p(x)",
            "consequence": (
                "p_r is E_+-valued for even r and E_--valued for odd r"
            ),
            "source_line_formula": "p|_{E_-} = p_d(0,y)",
            "director_verified": True,
        },
        "decomposition": {
            "p": "sum_{r=0}^d p_r",
            "p_r_space": "Sym^{d-r} E_+^∨ ⊗ Sym^r E_-^∨ ⊗ W",
            "normal_order": "r (I(Z_t)-adic order along the plus-plane)",
            "global_degree": "d (homogeneous polynomial degree on W)",
            "distinction": (
                "local normal order r and global degree d are independent "
                "gradings; never conflate them"
            ),
        },
        "three_copies_in_coupling": {
            "normal_jet_on_Z_t": (
                "associated-graded piece of order m lives in "
                "H^0(Z_t, Sym^m N^∨ ⊗ O(d)) ⊗ W and on P(N) uses P(E_-)^{N}"
            ),
            "source_restriction": (
                "p|_{L_t^{src}} uses L_t^{src}; equals terminal coefficient only"
            ),
            "target_line": (
                "odd-m leading jet evaluates to a map into L_t^{tgt}"
            ),
        },
    }


def corrected_necessity() -> dict:
    """Re-prove necessity in the corrected category.

    Verdict: corrected linear state space is at least as large as the old one.
    No negative conclusion from the repair itself (house rule 2).
    """
    return {
        "name": "Corrected normal-cone necessity theorem",
        "headline": "OPEN",
        "statement": (
            "Every nonzero homogeneous landing self-covariant p: W → W with "
            "F(p)=0 determines a compatible element of the corrected inverse "
            "limit Λ^rep of the stabilizer-decorated associated-graded landing "
            "modules assembled with the repaired incidence category "
            "(source line, exceptional normal factor, and target line "
            "distinguished). The forgetful map Λ^rep → Λ_legacy to the "
            "pre-repair equalizer is surjective on underlying linear data; in "
            "particular dim Λ^rep_{m,d} ≥ dim Λ_legacy_{m,d} whenever either "
            "is defined. Nonemptiness of Λ_legacy (WP-5 Exit P) therefore "
            "implies nonemptiness of the image of Λ^rep in the legacy state "
            "space, and the corrected state space is at least as large."
        ),
        "direction": (
            "forward only (emptiness of Λ^rep ⇒ no such p; nonemptiness of "
            "Λ^rep ⇏ existence of p)"
        ),
        "comparison_to_legacy": {
            "legacy_statement_ref": "certificates/global_transition/necessity_theorem.json",
            "legacy_defect": (
                "Legacy N.4 treated plane→minus-line as ordinary normal-cone "
                "restriction, identifying L_t^{src} with a boundary of the "
                "normal cone of Z_t."
            ),
            "repair": (
                "Replace that arrow by the span "
                "Z_t^{src} ← P(N_{Z_t/Y}) → L_t^{tgt} together with the "
                "separate source restriction L_t^{src} ⇢ X^t and the "
                "coefficient coupling p|_{E_-} = p_d(0,y)."
            ),
            "size_verdict": "AT_LEAST_AS_LARGE",
            "size_reason": (
                "Every legacy equalizer constraint is retained (plane "
                "normalization, triple-line equalizer, residual point kernel, "
                "C3/A4/marked data, V4 charges). The conflated plane→line "
                "constraint is refined into four explicitly weaker/orthogonal "
                "constraints whose common solutions map onto the legacy "
                "solutions by forgetting the source/target/normal labels. "
                "Refinement of a constraint system cannot shrink the solution "
                "set below a quotient of a larger set; here the forgetful map "
                "from corrected states to legacy states is surjective because "
                "every legacy plane-line coupling (Δ_t^m h_t) lifts to a "
                "coefficient-coupling datum plus a normal-cone leading jet "
                "with the same residual D12 class (transport of structure on "
                "isomorphic residual modules). Hence |corrected| ≥ |legacy|."
            ),
            "no_negative_from_repair": True,
            "house_rule_2": (
                "Do not infer a negative theorem from first-normal-state "
                "existence/nonexistence without this corrected necessity proof. "
                "The repair itself yields no emptiness."
            ),
        },
        "proof": {
            "status": "PROVED",
            "steps": [
                {
                    "id": "R.1_forced_base_jets",
                    "claim": (
                        "By 4A/4C, p vanishes to a common odd order m on every "
                        "plus-plane Z_t and vanishes on every V4 fixed line. "
                        "The first nonzero normal jet along Z_t is an "
                        "H-equivariant section of Sym^m N_{Z_t/Y}^∨ ⊗ O(d) ⊗ W, "
                        "i.e. lives on P(N_{Z_t/Y}), not on L_t^{src}."
                    ),
                    "source": "WP-4A.1–3, WP-4C.1",
                },
                {
                    "id": "R.2_symbolic_powers",
                    "claim": (
                        "Vanishing to order ≥ m on every conjugate plus-plane "
                        "means p ∈ (A_m ⊗ W)^G with A_m = ∩_t I(Z_t)^m."
                    ),
                    "source": "legacy N.2, retained",
                },
                {
                    "id": "R.3_associated_graded",
                    "claim": (
                        "The class of p in [M_m ⊗ W]^G = [A_m/A_{m+2} ⊗ W]^G is "
                        "the associated-graded leading piece at exact order m."
                    ),
                    "source": "legacy N.3, retained",
                },
                {
                    "id": "R.4_normal_cone_span",
                    "claim": (
                        "Along each involution, the leading jet determines a "
                        "point of the span Z_t^{src} ← P(N_{Z_t/Y}) → L_t^{tgt}: "
                        "projection to Z_t is the base of the exceptional "
                        "divisor; for odd m the jet is E_--valued and evaluates "
                        "to a dominant map onto L_t^{tgt} (4A.3)."
                    ),
                    "source": "WP-R0 replacement span",
                },
                {
                    "id": "R.5_coefficient_coupling",
                    "claim": (
                        "Independently, p|_{E_-} = p_d(0,y) is a terminal "
                        "coefficient condition on L_t^{src}. For based families "
                        "this vanishes; for residual families it equals "
                        "Δ_t^m h_t. This is COEFFICIENT-COUPLING, not "
                        "normal-cone restriction from Z_t."
                    ),
                    "source": "director-verified covariant parity",
                },
                {
                    "id": "R.6_other_incidences",
                    "claim": (
                        "All other incidence specializations (triple-line "
                        "equalizer, residual points, C3/A4, type-I/II charges) "
                        "are retained with their legacy types "
                        "(SOURCE-RESTRICTION / NORMAL-CONE-SPECIALIZATION / "
                        "TARGET-EVALUATION) and are satisfied by jets of a "
                        "single global p."
                    ),
                    "source": "legacy N.5, N.8 repaired classification",
                },
                {
                    "id": "R.7_irrelevant_torsion",
                    "claim": (
                        "Finite irrelevant torsion T_m is retained; low-degree "
                        "graded pieces may differ from sheaf-level H^0."
                    ),
                    "source": "legacy N.6, house rule 5",
                },
                {
                    "id": "R.8_equalizer",
                    "claim": (
                        "The collection of all repaired stratum jets of p lies "
                        "in the equalizer Λ^rep of all repaired specialization, "
                        "evaluation, and coefficient-coupling maps."
                    ),
                    "source": "definition of Λ^rep",
                },
                {
                    "id": "R.9_size",
                    "claim": (
                        "Forgetful map Λ^rep → Λ_legacy is surjective on the "
                        "linear data used by WP-5 (every legacy plane-line "
                        "coupling lifts by residual D12 transport). Therefore "
                        "the corrected state space is at least as large, and "
                        "Exit P nonemptiness persists. No negative theorem "
                        "follows from the repair."
                    ),
                    "source": "WP-R0 comparison",
                },
            ],
        },
        "corollaries": {
            "emptiness_gives_negative": (
                "If Λ^rep = 0 then no nonzero homogeneous landing self-covariant "
                "exists. Conversion to ed_C(G)=4 uses the accepted exhaustiveness "
                "theorem as a separate step."
            ),
            "nonemptiness_not_positive": (
                "Nonzero elements of Λ^rep are necessary formal configurations "
                "only — not parametrizations and not existence of p."
            ),
            "legacy_exit_P_survives": (
                "WP-5 Exit P is not overturned: the repair enlarges or preserves "
                "the linear state space."
            ),
        },
        "surviving_families_retained": [
            "based_minus_lines_odd_m",
            "residual_e1_swap_both",
            "residual_e_ge7_generic_swap_both",
        ],
        "new_families_from_repair": [],
        "note_on_new_families": (
            "The repair refines arrows; it does not create a new marked-state "
            "family beyond the three accepted WP-5 survivors. Coefficient "
            "coupling makes the based vs residual distinction sharper but "
            "does not add a fourth discrete family at Level 1."
        ),
    }


def build_payload() -> dict:
    legacy = load_json(GT / "diagram.json")
    flags = legacy["incidence_category"]["flags"]
    classifications = [classify_legacy_flag(f) for f in flags]

    # Count types among retained + replacement arrows
    arrows = repaired_arrows()
    type_counts = {t: 0 for t in ARROW_TYPES}
    for a in arrows:
        type_counts[a["arrow_type"]] += 1

    replaced = [c for c in classifications if c["status"] == "REPLACED"]
    retained = [c for c in classifications if c["status"] == "RETAINED"]

    body = {
        "work_package": "WP-R0",
        "gate": "First dispatch — category repair",
        "headline": "OPEN",
        "theorem_boundary": {
            "proved": [
                "Classification of every legacy diagram arrow into the four types",
                "Distinction of three copies of P(E_-) by path and type",
                "Replacement of C2_plane→C2_line by the normal-cone span plus source restriction and coefficient coupling",
                "Corrected necessity theorem with size comparison ≥ legacy",
            ],
            "not_proved": [
                "Existence or nonexistence of a landing covariant",
                "Emptiness of nonlinear lifting support",
                "ed_C(G) or unirationality",
            ],
        },
        "three_copies_of_P_E_minus": THREE_COPIES,
        "arrow_types": list(ARROW_TYPES),
        "legacy_flag_audit": {
            "source": "certificates/global_transition/diagram.json",
            "n_flags": len(flags),
            "n_replaced": len(replaced),
            "n_retained": len(retained),
            "classifications": classifications,
        },
        "repaired_objects": repaired_objects(),
        "repaired_arrows": arrows,
        "arrow_type_counts": type_counts,
        "coefficient_coupling": coefficient_coupling_block(),
        "corrected_necessity_theorem": corrected_necessity(),
        "forbidden_identifications": [
            {
                "id": "source_line_inside_plus_plane",
                "claim": "L_t^{src} subset Z_t",
                "status": "REJECTED",
                "reason": "L_t^{src} ∩ Z_t = empty",
                "verifier_must_reject": True,
            },
            {
                "id": "source_equals_normal_fiber",
                "claim": "L_t^{src} = P(E_-)^{N} as geometric objects",
                "status": "REJECTED",
                "reason": (
                    "Isomorphic as residual D12-spaces but live in different "
                    "ambients (P(W) vs P(N_{Z_t/Y}))"
                ),
                "verifier_must_reject": True,
            },
            {
                "id": "source_equals_target",
                "claim": "L_t^{src} = L_t^{tgt} as incidence objects",
                "status": "REJECTED",
                "reason": (
                    "Source restriction domain vs target of leading normal jet; "
                    "same abstract P(E_-) but different path/type tags"
                ),
                "verifier_must_reject": True,
            },
            {
                "id": "legacy_plane_to_minus_line_as_restriction",
                "claim": (
                    "plane_to_minus_line is an ordinary restriction of the "
                    "first normal jet on Z_t to a subvariety of Z_t"
                ),
                "status": "REJECTED",
                "reason": "No such subvariety; replaced by the span + coupling",
                "verifier_must_reject": True,
            },
        ],
        "accepted_input_sha256": {
            rel: sha256_file(ROOT / rel)
            for rel in [
                "certificates/global_transition/diagram.json",
                "certificates/global_transition/necessity_theorem.json",
                "certificates/global_transition/level1_marked_states.json",
                "certificates/transitions/involution_plane/module.json",
                "certificates/transitions/d12_binary_line/module.json",
                "certificates/strata/incidence_exact.json",
            ]
            if (ROOT / rel).exists()
        },
        "producer": {
            "script": "certificates/transition_repair/produce.py",
            "does_not_import": "verify.py",
        },
    }
    return body


def write_json(path: Path, body: dict) -> dict:
    """Write canonical JSON with self_sha256 after last content byte."""
    payload = dict(body)
    payload.pop("self_sha256", None)
    # First write without hash
    text = canonical_json(payload)
    h = sha256_bytes(text.encode())
    payload["self_sha256"] = h
    path.write_text(canonical_json(payload))
    # Recompute on final file bytes consistency
    final = path.read_text()
    data = json.loads(final)
    body2 = {k: v for k, v in data.items() if k != "self_sha256"}
    assert sha256_bytes(canonical_json(body2).encode()) == data["self_sha256"]
    return data


def main():
    body = build_payload()
    out = HERE / "category_repaired.json"
    data = write_json(out, body)
    print(f"Wrote {out}")
    print(f"self_sha256={data['self_sha256']}")
    print(f"n_arrows={len(data['repaired_arrows'])}")
    print(f"type_counts={data['arrow_type_counts']}")
    print(f"size_verdict={data['corrected_necessity_theorem']['comparison_to_legacy']['size_verdict']}")
    print("HEADLINE", data["headline"])


if __name__ == "__main__":
    main()
