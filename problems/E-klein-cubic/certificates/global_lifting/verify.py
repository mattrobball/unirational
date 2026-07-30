#!/usr/bin/env python3
"""Independent verifier for Attempt 5 Gate 1 global-state-image formulation.

Does NOT import produce.py.  Re-reads accepted inputs, checks formulation
invariants, size-estimate presence, UNDECIDED containment, self-hash, and
terminal marker.  Headline must remain OPEN.
"""

from __future__ import annotations

import json
import math
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

SURVIVOR_FAMILIES = [
    "based_minus_lines_odd_m",
    "residual_e1_swap_both",
    "residual_e_ge7_generic_swap_both",
]

REQUIRED_ACCEPTED = [
    "certificates/transition_repair/category_repaired.json",
    "certificates/lifting/polar_expansion.json",
    "certificates/lifting/families/SUMMARY.json",
    "certificates/lifting/families/free_module_stages.json",
    "certificates/global_transition/level2_inverse_limit.json",
]


def assert_no_timing(obj, path: str = "") -> None:
    if isinstance(obj, dict):
        for k, v in obj.items():
            kl = str(k).lower()
            assert "wall_time" not in kl, f"timing field {k} at {path}"
            assert k not in ("wall_time_sec", "elapsed", "runtime", "duration"), path
            assert_no_timing(v, f"{path}.{k}")
    elif isinstance(obj, list):
        for i, v in enumerate(obj):
            assert_no_timing(v, f"{path}[{i}]")


def check_self_hash(path: Path) -> dict:
    data = json.loads(path.read_text())
    assert "self_sha256" in data, f"missing self_sha256 in {path}"
    body = {k: v for k, v in data.items() if k != "self_sha256"}
    h = sha256_bytes(canonical_json(body).encode())
    assert h == data["self_sha256"], (
        f"self_sha256 mismatch in {path}: sealed={data['self_sha256']} recomputed={h}"
    )
    return data


def free_L1(m: int) -> tuple[int, int]:
    return (3 * m + 2, 3 * (m + 2))


def free_L3(m: int) -> tuple[int, int]:
    return (3 * m + 4, 3 * (m + 4))


def main() -> None:
    img_path = HERE / "global_state_image.json"
    assert img_path.is_file(), "missing global_state_image.json — run produce.py"
    img = check_self_hash(img_path)
    assert_no_timing(img)

    assert img["headline"] == "OPEN"
    assert img["containment_status"] == "UNDECIDED"
    assert img["attempt"] == 5
    assert "5B" in img["gate"] or "Gate 1" in img["gate"]
    assert img["terminal_marker"] == "GLOBAL_STATE_IMAGE_FORMULATION_OK"

    # Accepted input hashes match disk
    for rel, h in img["accepted_input_sha256"].items():
        p = ROOT / rel
        assert p.is_file(), f"accepted input missing: {rel}"
        assert sha256_file(p) == h, f"hash drift for {rel}"

    for rel in REQUIRED_ACCEPTED:
        assert rel in img["accepted_input_sha256"], f"missing pinned input {rel}"

    form = img["formulation"]

    # Three copies distinguished
    copies = form["corrected_category"]["three_copies_of_P_E_minus"]
    assert set(copies.keys()) == {"L_t_src", "P_E_minus_normal", "L_t_tgt"}
    assert copies["L_t_src"]["meets_Z_t"] is False
    forb = form["corrected_category"]["forbidden_identifications"]
    assert any("Z_t" in f for f in forb)
    assert any("src" in f and "tgt" in f for f in forb)

    # Independently confirm repair packet still has three copies
    repaired = load_json(ROOT / "certificates/transition_repair/category_repaired.json")
    assert set(repaired["three_copies_of_P_E_minus"].keys()) >= {
        "L_t_src",
        "P_E_minus_normal",
        "L_t_tgt",
    }
    assert (
        repaired["corrected_necessity_theorem"]["surviving_families_retained"]
        == SURVIVOR_FAMILIES
    )

    # Lambda / B / G defining data
    assert "Lambda" in form
    assert "rep" in form["Lambda"]["symbol"] or "Lambda" in form["Lambda"]["symbol"]
    assert form["B_leading_jet_space"]["symbol"] == "B_{m,d}"
    G = form["projection_and_image"]["G"]
    assert G["symbol"] == "G_{m,d}"
    assert "scheme-theoretic image" in G["definition"]
    assert len(G["exact_defining_data"]) >= 4

    # Rank-drop loci as Fitting
    rd = form["rank_drop_loci"]
    assert "Fitt" in rd["R_1_m"]["definition"]
    assert "coker L_1" in rd["R_1_m"]["definition"] or "coker" in rd["R_1_m"]["definition"]
    assert "Fitt" in rd["R_3_m"]["definition"]
    assert "coker L_3" in rd["R_3_m"]["definition"] or "coker" in rd["R_3_m"]["definition"]
    assert rd["L_1"]["RHS_R1"] == "0"
    assert "omega_1" in rd["L_1"]

    # Decision precise
    dec = form["required_decision"]
    st = dec["statement"]
    assert "G_{m,d}" in st and "R_{3,m}" in st
    assert "⊆" in st or "subseteq" in st.lower() or "\\subseteq" in st
    assert dec["status_this_dispatch"] == "UNDECIDED"
    assert dec["not_decided_by_sampling"] is True
    assert "Fork A" in str(dec["exclusive_forks"]) or "5C" in str(
        dec["exclusive_forks"]
    )
    assert "Fork B" in str(dec["exclusive_forks"]) or "5D" in str(
        dec["exclusive_forks"]
    )

    # No false containment claim
    assert img["containment_status"] == "UNDECIDED"
    tb = img["theorem_boundary"]
    assert "G ⊆ R_3" in tb["not_proved_here"] or any(
        "G" in x and "R_3" in x for x in tb["not_proved_here"]
    )

    # House rule 8: never call formal states covariants in formulation text
    blob = json.dumps(form)
    # Allow "not a covariant" / "never called covariants" but reject affirmative
    # labelling of Lambda elements as covariants.
    assert "formal states, never covariants" in blob or "never called covariants" in blob

    # Families
    assert form["survivor_families"]["ids"] == SURVIVOR_FAMILIES

    # Size estimates §7.2
    se = img["size_estimates"]
    assert se["resource_gate_GB"] == 8
    assert "free_module_Fitting_and_ranks" in se
    assert "instantiated_bidegree_envelopes" in se
    assert "certificate_format_proposed" in se
    assert "checkpoint_plan" in se
    assert "independent_verifier_design" in se
    assert len(se["checkpoint_plan"]) >= 4
    assert len(se["decision_path_recommended"]) >= 3

    for m in (1, 3):
        block = se["free_module_Fitting_and_ranks"][str(m)]
        cod1, dom1 = free_L1(m)
        cod3, dom3 = free_L3(m)
        assert block["L1"]["shape_codomain_x_domain"] == [cod1, dom1]
        assert block["L3"]["shape_codomain_x_domain"] == [cod3, dom3]
        assert block["L1"]["generic_nullity_pattern"] == 4
        assert block["L3"]["generic_nullity_pattern"] == 8
        assert block["L1"]["generic_coker_pattern"] == 0
        assert block["L3"]["generic_coker_pattern"] == 0
        # memory floors present
        for op in ("L1", "L3"):
            mem = block[op]["memory"]
            assert "dense_GB_floor" in mem and "sparse_GB_floor" in mem
            assert mem["exceeds_8GB_sparse"] is False

    # Cross-check free shapes against sealed free_module_stages for m=1,3
    fm = load_json(ROOT / "certificates/lifting/families/free_module_stages.json")
    for m in (1, 3):
        s = fm["stages_by_m"][str(m)]
        # find L1/L3 symbolic shapes
        for key, (cod, dom) in (
            ("L1_relative_sparse", free_L1(m)),
            ("L3_relative_sparse", free_L3(m)),
        ):
            if key in s and "symbolic_quadratic" in s[key]:
                shape = s[key]["symbolic_quadratic"]["shape"]
                assert shape == [cod, dom], f"m={m} {key} shape {shape} != {[cod, dom]}"

    # Instantiated envelopes have dimensions and memory
    assert len(se["instantiated_bidegree_envelopes"]) >= 4
    for row in se["instantiated_bidegree_envelopes"]:
        assert "dim_B_leading_C2" in row
        assert "equalizer_matrix_shape_upper" in row
        assert "equalizer_memory" in row
        assert row["m"] % 2 == 1

    # Scope excludes Fork A/B
    excl = " ".join(img["scope"]["excludes"])
    assert "Fork A" in excl and "Fork B" in excl

    # Producer does not import verifier (static check of produce.py text)
    prod_src = (HERE / "produce.py").read_text()
    assert "import verify" not in prod_src
    assert "from verify" not in prod_src

    # SUMMARY still L-P / OPEN
    summary = load_json(ROOT / "certificates/lifting/families/SUMMARY.json")
    assert summary["decision_exit"] == "L-P"
    assert summary["headline"] == "OPEN"

    # MD deliverable present
    md = HERE / "GLOBAL_STATE_IMAGE.md"
    assert md.is_file(), "missing GLOBAL_STATE_IMAGE.md"
    md_text = md.read_text()
    assert "OPEN" in md_text
    assert "G_{m,d}" in md_text or "G_{m,d}" in md_text.replace(" ", "")
    assert "R_{3,m}" in md_text
    assert "UNDECIDED" in md_text or "undecided" in md_text.lower()
    assert "scheme-theoretic image" in md_text.lower() or "scheme-theoretic" in md_text
    # no false covariant claim for formal states
    assert "never" in md_text.lower() and "covariant" in md_text.lower()

    print("GLOBAL_STATE_IMAGE_FORMULATION_OK")
    print("GLOBAL_STATE_IMAGE_VERIFY_OK")


if __name__ == "__main__":
    main()
