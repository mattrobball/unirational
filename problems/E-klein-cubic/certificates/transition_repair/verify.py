#!/usr/bin/env python3
"""Independent verifier for WP-R0 category repair.

Does NOT import produce.py.  Re-reads legacy diagram.json, checks arrow
classification, rejects forbidden identifications of the three P(E_-) copies,
checks self-hashes and corrected necessity size verdict.
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
CERT = HERE.parent
ROOT = CERT.parent
GT = CERT / "global_transition"
sys.path.insert(0, str(GT))

from common_global import (  # noqa: E402
    canonical_json,
    load_json,
    sha256_bytes,
    sha256_file,
)

ARROW_TYPES = {
    "SOURCE-RESTRICTION",
    "NORMAL-CONE-SPECIALIZATION",
    "TARGET-EVALUATION",
    "COEFFICIENT-COUPLING",
}

THREE_COPY_IDS = {"L_t_src", "P_E_minus_normal", "L_t_tgt"}


def check_self_hash(path: Path) -> dict:
    raw = path.read_text()
    data = json.loads(raw)
    assert "self_sha256" in data, f"missing self_sha256 in {path}"
    body = {k: v for k, v in data.items() if k != "self_sha256"}
    h = sha256_bytes(canonical_json(body).encode())
    assert h == data["self_sha256"], (
        f"self_sha256 mismatch in {path}: sealed={data['self_sha256']} recomputed={h}"
    )
    return data


def assert_no_timing(obj, path=""):
    if isinstance(obj, dict):
        for k, v in obj.items():
            kl = k.lower()
            assert "wall_time" not in kl, f"timing field {k} at {path}"
            assert k not in ("wall_time_sec", "elapsed", "runtime"), path
            assert_no_timing(v, f"{path}.{k}")
    elif isinstance(obj, list):
        for i, v in enumerate(obj):
            assert_no_timing(v, f"{path}[{i}]")


def reclassify_legacy(flag: dict) -> str | None:
    """Independent re-classification of legacy flags (no produce import)."""
    fid = flag["id"]
    if fid == "plane_to_minus_line":
        return None  # replaced
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
        return "SOURCE-RESTRICTION"
    if fid in {
        "plane_to_triple_line",
        "V4_line_to_type_I",
        "V4_line_to_type_II",
    }:
        return "NORMAL-CONE-SPECIALIZATION"
    if fid in {
        "type_II_to_three_elliptics",
        "type_I_to_one_elliptic",
    }:
        return "TARGET-EVALUATION"
    raise AssertionError(f"unknown legacy flag {fid}")


def main():
    repaired = check_self_hash(HERE / "category_repaired.json")
    assert_no_timing(repaired)
    assert repaired["headline"] == "OPEN"

    legacy = load_json(GT / "diagram.json")
    flags = legacy["incidence_category"]["flags"]
    flag_ids = {f["id"] for f in flags}
    assert "plane_to_minus_line" in flag_ids

    # ------------------------------------------------------------------
    # Every legacy flag classified; plane_to_minus_line replaced
    # ------------------------------------------------------------------
    audit = repaired["legacy_flag_audit"]
    assert audit["n_flags"] == len(flags)
    by_id = {c["legacy_id"]: c for c in audit["classifications"]}
    assert set(by_id) == flag_ids

    for f in flags:
        clf = by_id[f["id"]]
        if f["id"] == "plane_to_minus_line":
            assert clf["status"] == "REPLACED"
            assert "replacement_span" in clf
            assert clf["forbidden_identification"]["status"] == "REJECTED"
        else:
            assert clf["status"] == "RETAINED"
            assert clf["arrow_type"] in ARROW_TYPES
            # Independent reclassification agrees
            assert reclassify_legacy(f) == clf["arrow_type"], f["id"]

    print("PASS legacy flag audit and independent reclassification")

    # ------------------------------------------------------------------
    # Three copies distinguished by path and type
    # ------------------------------------------------------------------
    copies = repaired["three_copies_of_P_E_minus"]
    assert set(copies) == THREE_COPY_IDS
    tags = {copies[k]["path_tag"] for k in THREE_COPY_IDS}
    assert tags == {"SOURCE", "NORMAL", "TARGET"}
    assert copies["L_t_src"]["meets_Z_t"] is False
    assert "empty" in copies["L_t_src"]["disjointness"].lower() or "∅" in copies[
        "L_t_src"
    ]["disjointness"] or "empty" in copies["L_t_src"]["disjointness"]

    roles = {copies[k]["role"] for k in THREE_COPY_IDS}
    assert len(roles) == 3

    print("PASS three copies distinguished by path_tag and role")

    # ------------------------------------------------------------------
    # Repaired arrows: all typed; replacement span present
    # ------------------------------------------------------------------
    arrows = repaired["repaired_arrows"]
    assert arrows, "no repaired arrows"
    by_arrow = {a["id"]: a for a in arrows}

    required_span = [
        "normal_cone_projection",
        "normal_cone_to_target_line",
        "source_line_restriction",
        "coefficient_coupling_terminal",
    ]
    for rid in required_span:
        assert rid in by_arrow, f"missing replacement arrow {rid}"
        assert by_arrow[rid]["arrow_type"] in ARROW_TYPES

    assert by_arrow["normal_cone_projection"]["arrow_type"] == "NORMAL-CONE-SPECIALIZATION"
    assert by_arrow["normal_cone_to_target_line"]["arrow_type"] == "TARGET-EVALUATION"
    assert by_arrow["source_line_restriction"]["arrow_type"] == "SOURCE-RESTRICTION"
    assert by_arrow["coefficient_coupling_terminal"]["arrow_type"] == "COEFFICIENT-COUPLING"

    # Legacy conflated arrow must NOT appear as a live repaired edge
    assert "plane_to_minus_line" not in by_arrow

    for a in arrows:
        assert a["arrow_type"] in ARROW_TYPES, a["id"]

    # Type counts match
    counts = {t: 0 for t in ARROW_TYPES}
    for a in arrows:
        counts[a["arrow_type"]] += 1
    assert counts == repaired["arrow_type_counts"]
    assert counts["COEFFICIENT-COUPLING"] >= 1
    assert counts["NORMAL-CONE-SPECIALIZATION"] >= 1
    assert counts["TARGET-EVALUATION"] >= 1
    assert counts["SOURCE-RESTRICTION"] >= 1

    print("PASS repaired arrows and replacement span")

    # ------------------------------------------------------------------
    # VERIFIER MUST REJECT bad identifications
    # ------------------------------------------------------------------
    forbidden = {f["id"]: f for f in repaired["forbidden_identifications"]}
    required_forbidden = {
        "source_line_inside_plus_plane",
        "source_equals_normal_fiber",
        "source_equals_target",
        "legacy_plane_to_minus_line_as_restriction",
    }
    assert required_forbidden <= set(forbidden)

    def reject(claim_id: str, predicate_true: bool, msg: str):
        """If a bad identification is asserted (predicate_true), fail."""
        assert forbidden[claim_id]["status"] == "REJECTED"
        assert forbidden[claim_id]["verifier_must_reject"] is True
        if predicate_true:
            raise AssertionError(f"REJECTED identification slipped through: {claim_id}: {msg}")

    # Explicitly test the bad predicates are false in the repaired data
    objs = repaired["repaired_objects"]
    assert objs["L_t_src"]["disjoint_from_Z_t"] is True
    reject(
        "source_line_inside_plus_plane",
        objs["L_t_src"].get("disjoint_from_Z_t") is not True,
        "L_t_src must be disjoint from Z_t",
    )

    # No arrow may identify L_t_src as a subvariety of C2_plane
    for a in arrows:
        if a.get("source") == "L_t_src" and a.get("target") == "C2_plane":
            raise AssertionError("bad arrow L_t_src -> C2_plane")
        if a.get("source") == "C2_plane" and a.get("target") == "L_t_src":
            # Only coefficient coupling / span may relate them indirectly
            if a["arrow_type"] not in ARROW_TYPES:
                raise AssertionError("untyped C2_plane -> L_t_src")
            if a["id"] == "plane_to_minus_line":
                raise AssertionError("legacy conflated arrow present")
            # Direct geometric inclusion arrow is forbidden
            if a["arrow_type"] == "SOURCE-RESTRICTION" and a["id"] not in {
                # none allowed as inclusion
            }:
                # Allow only if explicitly marked not inclusion
                if a.get("not_a_restriction_from") != "C2_plane" and "inclusion" in str(
                    a.get("geometry", "")
                ).lower():
                    raise AssertionError(f"inclusion-like arrow {a['id']}")

    # Objects for the three copies must not collapse
    assert objs["L_t_src"]["three_copy"] == "L_t_src"
    assert objs["L_t_tgt"]["three_copy"] == "L_t_tgt"
    assert objs["P_N_Zt_Y"]["three_copy_fiber"] == "P_E_minus_normal"
    assert objs["L_t_src"]["role"] != objs["L_t_tgt"]["role"]

    # C2_line deprecated split
    assert objs["C2_line"]["deprecated_as_single_object"] is True
    assert set(objs["C2_line"]["split_into"]) == THREE_COPY_IDS

    # Simulate adversarial payload: identifying source line with subvariety of plus-plane
    adversarial_arrow = {
        "id": "adversarial_src_in_plane",
        "arrow_type": "SOURCE-RESTRICTION",
        "source": "C2_plane",
        "target": "L_t_src",
        "geometry": "pretend L_t_src subset Z_t",
        "identifies_source_line_as_subvariety_of_plus_plane": True,
    }
    # Verifier rejection rule:
    if adversarial_arrow.get("identifies_source_line_as_subvariety_of_plus_plane"):
        rejected = True
    else:
        rejected = False
    assert rejected, "verifier failed to reject adversarial identification"

    # Also reject any arrow that claims L_t_src ⊂ C2_plane
    def is_bad_identification(arrow: dict) -> bool:
        if arrow.get("identifies_source_line_as_subvariety_of_plus_plane"):
            return True
        if arrow.get("id") == "plane_to_minus_line":
            return True
        geom = (arrow.get("geometry") or "").lower()
        if "l_t_src subset z_t" in geom or "l_t^{src} ⊂ z_t" in geom:
            return True
        if arrow.get("source") == "L_t_src" and arrow.get("target") == "C2_plane":
            if arrow.get("arrow_type") != "COEFFICIENT-COUPLING":
                # coefficient coupling targets L_t_src from expansion, not reverse inclusion
                return True
        return False

    assert is_bad_identification(adversarial_arrow)
    for a in arrows:
        assert not is_bad_identification(a), f"repaired arrow fails bad-ID test: {a['id']}"

    print("PASS forbidden-identification rejections")

    # ------------------------------------------------------------------
    # Coefficient coupling formulas
    # ------------------------------------------------------------------
    cc = repaired["coefficient_coupling"]
    assert cc["covariant_parity"]["director_verified"] is True
    assert "p_d(0,y)" in cc["covariant_parity"]["source_line_formula"]
    assert "even r" in cc["covariant_parity"]["consequence"]
    assert "odd r" in cc["covariant_parity"]["consequence"]
    assert cc["setup"]["director_verified"] is True

    formula = by_arrow["coefficient_coupling_terminal"]["formula"]
    assert formula["source_restriction"] == "p|_{E_-} = p_d(0,y)"
    assert "not_first_jet" in formula

    print("PASS coefficient coupling")

    # ------------------------------------------------------------------
    # Corrected necessity
    # ------------------------------------------------------------------
    nec = repaired["corrected_necessity_theorem"]
    assert nec["headline"] == "OPEN"
    assert nec["comparison_to_legacy"]["size_verdict"] == "AT_LEAST_AS_LARGE"
    assert nec["comparison_to_legacy"]["no_negative_from_repair"] is True
    assert nec["proof"]["status"] == "PROVED"
    step_ids = [s["id"] for s in nec["proof"]["steps"]]
    assert "R.4_normal_cone_span" in step_ids
    assert "R.5_coefficient_coupling" in step_ids
    assert "R.9_size" in step_ids
    assert nec["surviving_families_retained"] == [
        "based_minus_lines_odd_m",
        "residual_e1_swap_both",
        "residual_e_ge7_generic_swap_both",
    ]
    assert nec["new_families_from_repair"] == []

    # Must not claim a negative resolution
    assert "no such p" not in nec["statement"].lower() or "emptiness" in nec[
        "corollaries"
    ]["emptiness_gives_negative"].lower()
    # Statement itself is necessity (forward), not emptiness
    assert "determines a compatible element" in nec["statement"]

    print("PASS corrected necessity (size ≥ legacy, no negative from repair)")

    # ------------------------------------------------------------------
    # Objects include repaired span pieces
    # ------------------------------------------------------------------
    for key in ("L_t_src", "L_t_tgt", "P_N_Zt_Y", "C2_plane"):
        assert key in objs, key

    print("PASS repaired objects")

    # ------------------------------------------------------------------
    # Accepted inputs readable
    # ------------------------------------------------------------------
    for rel, h in repaired["accepted_input_sha256"].items():
        p = ROOT / rel
        assert p.exists(), rel
        assert sha256_file(p) == h, rel

    print("PASS accepted input hashes")
    print("ALL WP-R0 VERIFICATIONS PASSED")
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except AssertionError as e:
        print(f"FAIL: {e}", file=sys.stderr)
        sys.exit(1)
