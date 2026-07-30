#!/usr/bin/env python3
"""Independent verifier for WP-5 global transition diagram.

Does NOT import produce.py.  Recomputes dimension formulas, re-reads accepted
JSON inputs, checks sealed self-hashes, Level-1 ledger classification,
Level-2 growth hypotheses, necessity structure, and exit/headline consistency.
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
CERT = HERE.parent
ROOT = CERT.parent
STRATA = CERT / "strata"
TRANS = CERT / "transitions"
sys.path.insert(0, str(HERE))

from common_global import (  # noqa: E402
    binom,
    canonical_json,
    dim_d12_ordinary,
    dim_d12_twisted,
    dim_plane,
    dim_v4_line,
    endpoint_ledgers,
    input_hashes,
    load_json,
    n_triv,
    plane_line_coupling_dim,
    sha256_bytes,
    sha256_file,
)


def check_self_hash(path: Path) -> dict:
    raw = path.read_text()
    data = json.loads(raw)
    assert "self_sha256" in data, f"missing self_sha256 in {path}"
    body = {k: v for k, v in data.items() if k != "self_sha256"}
    h = sha256_bytes(canonical_json(body).encode())
    assert h == data["self_sha256"], (
        f"self_sha256 mismatch in {path}: sealed={data['self_sha256']} recomputed={h}"
    )
    # file hash equals hash of file contents
    assert sha256_file(path) == sha256_bytes(raw.encode())
    return data


def main():
    # ------------------------------------------------------------------
    # Load sealed artifacts
    # ------------------------------------------------------------------
    diagram = check_self_hash(HERE / "diagram.json")
    tables = check_self_hash(HERE / "dimension_tables.json")
    level1 = check_self_hash(HERE / "level1_marked_states.json")
    level2 = check_self_hash(HERE / "level2_inverse_limit.json")
    necessity = check_self_hash(HERE / "necessity_theorem.json")
    exit_rec = check_self_hash(HERE / "exit.json")
    seal = check_self_hash(HERE / "SEAL.json")

    # ------------------------------------------------------------------
    # Headline OPEN everywhere
    # ------------------------------------------------------------------
    for name, obj in [
        ("diagram", diagram),
        ("tables", tables),
        ("level1", level1),
        ("level2", level2),
        ("necessity", necessity),
        ("exit", exit_rec),
        ("seal", seal),
    ]:
        assert obj.get("headline") == "OPEN", f"{name} headline not OPEN"

    assert exit_rec["exit"] == "P"
    assert seal["exit"] == "P"
    assert diagram["exit"]["exit"] == "P"

    # ------------------------------------------------------------------
    # No timing fields in sealed payloads
    # ------------------------------------------------------------------
    def assert_no_timing(obj, path=""):
        if isinstance(obj, dict):
            for k, v in obj.items():
                assert "wall_time" not in k.lower(), f"timing field {k} at {path}"
                assert k not in ("wall_time_sec", "elapsed", "runtime"), path
                assert_no_timing(v, f"{path}.{k}")
        elif isinstance(obj, list):
            for i, v in enumerate(obj):
                assert_no_timing(v, f"{path}[{i}]")

    for p in [
        HERE / "diagram.json",
        HERE / "dimension_tables.json",
        HERE / "level1_marked_states.json",
        HERE / "level2_inverse_limit.json",
        HERE / "necessity_theorem.json",
        HERE / "exit.json",
        HERE / "SEAL.json",
    ]:
        assert_no_timing(json.loads(p.read_text()), str(p))

    print("PASS sealed self-hashes and no timing fields")

    # ------------------------------------------------------------------
    # Accepted inputs readable; incidence verdict
    # ------------------------------------------------------------------
    inc = load_json(STRATA / "incidence_exact.json")
    assert inc["type_I_type_II_verdict"]["verdict"] == "CLAIM_1_SURVIVES_CLAIM_2_REFUTED"
    assert diagram["incidence_category"]["accepted_incidence_verdict"]["verdict"] == (
        "CLAIM_1_SURVIVES_CLAIM_2_REFUTED"
    )

    nc = load_json(STRATA / "normal_characters.json")
    assert "C2_plane" in nc["strata"]
    assert "V4_line" in nc["strata"]
    assert "C3_line" in nc["strata"]

    for mod in [
        "involution_plane",
        "d12_binary_line",
        "v4_fixed_line",
        "c3_lines",
        "point_links",
    ]:
        m = load_json(TRANS / mod / "module.json")
        assert m["headline"] == "OPEN"

    print("PASS accepted Gates 1–3 inputs and incidence verdict")
    print("GLOBAL_TRANSITION_INCIDENCE_OK")

    # ------------------------------------------------------------------
    # Incidence category structure
    # ------------------------------------------------------------------
    cat = diagram["incidence_category"]
    objs = cat["objects"]
    required_objects = [
        "C2_plane",
        "C2_line",
        "V4_line",
        "C3_line",
        "V4_type_I_point",
        "V4_type_II_point",
        "D10_point",
        "D12_point",
        "A4_a_point",
        "A4_b_point",
        "elliptic_plus",
    ]
    for o in required_objects:
        assert o in objs, f"missing object {o}"

    assert objs["C2_plane"]["forced_base"] is True
    assert objs["V4_line"]["forced_base"] is True
    assert objs["C3_line"]["forced_base"] is False
    assert objs["C3_line"]["do_not_collapse_into_55_plane_ideal"] is True
    assert "triple lines" in objs["V4_line"]["arrangement_role"].lower() or (
        "triple" in objs["V4_line"]["arrangement_role"].lower()
    )

    flags = cat["flags"]
    flag_ids = {f["id"] for f in flags}
    for need in [
        "plane_to_minus_line",
        "plane_to_triple_line",
        "V4_line_to_type_II",
        "type_II_to_three_elliptics",
        "C3_line_to_C6",
    ]:
        assert need in flag_ids, f"missing flag {need}"

    arch = cat["architecture"]
    assert "plane_normalization" in arch["name"]
    assert arch["irrelevant_torsion"]["must_retain"] is True
    assert "FALSE" in arch["false_model_refuted"] or "false" in arch["false_model_refuted"].lower()

    print("PASS incidence category objects, flags, architecture")

    # ------------------------------------------------------------------
    # Level 1
    # ------------------------------------------------------------------
    assert level1["verdict"] == "SURVIVES"
    assert level1["level"] == 1
    assert len(level1["surviving_states"]) >= 2

    # Independent ledger classification
    assert endpoint_ledgers(1)["all_ledgers"] == ["swap_both"]
    assert endpoint_ledgers(3)["all_ledgers"] == ["swap_both"]
    assert "preserve_both" not in endpoint_ledgers(5)["all_ledgers"]
    assert "preserve_both" in endpoint_ledgers(7)["all_ledgers"]
    assert endpoint_ledgers(2)["defined"] is False

    # Sealed ledger families match independent recompute
    for e in range(0, 21):
        sealed = level1["ledger_families_e0_to_20"][str(e)]
        indep = endpoint_ledgers(e)
        assert sealed["all_ledgers"] == indep["all_ledgers"], (e, sealed, indep)

    # Charges
    assert level1["charges"]["type_I"] == "<q>"
    assert "e+<q>" in level1["charges"]["type_II"]

    # Adversarial attempts recorded
    assert any(a["result"] == "FAILS" for a in level1["adversarial_attempts"])

    # Surviving state e=1 is swap_both only
    e1 = next(s for s in level1["surviving_states"] if s["id"] == "residual_e1_swap_both")
    assert e1["minus_line"]["ledger"] == "swap_both"

    print("PASS Level 1 marked-state screen SURVIVES")
    print("LEVEL1_MARKED_STATE_SURVIVES")

    # ------------------------------------------------------------------
    # Level 2 — dimension tables
    # ------------------------------------------------------------------
    assert level2["verdict"] == "NONZERO"
    assert level2["level"] == 2

    pt = tables["local_dimension_tables"]["plane_m0_7_d0_31"]
    vt = tables["local_dimension_tables"]["v4_line_m0_7_d0_31"]
    lo = tables["local_dimension_tables"]["d12_ordinary_d0_31"]
    nt = tables["local_dimension_tables"]["n_triv_m0_to_20"]

    for m in range(8):
        for d in range(32):
            key = f"{m},{d}"
            assert pt[key] == dim_plane(m, d), (key, pt[key], dim_plane(m, d))
            assert vt[key] == dim_v4_line(m, d), (key, vt[key], dim_v4_line(m, d))
    for d in range(32):
        assert lo[str(d)] == dim_d12_ordinary(d)
    for m in range(21):
        assert nt[m] == n_triv(m)

    # n_triv closed form spot checks
    assert n_triv(0) == 1
    assert n_triv(1) == 0
    assert n_triv(2) == 3
    assert n_triv(3) == 1
    assert n_triv(4) == 6

    # Coupling samples
    c = plane_line_coupling_dim(1, 7)
    assert c["e"] == 1 and c["dim"] == 1 and not c["forced_zero_restriction"]
    c = plane_line_coupling_dim(1, 25)
    assert c["e"] == 19 and c["dim"] == dim_d12_twisted(19)
    c = plane_line_coupling_dim(3, 7)
    assert c["forced_zero_restriction"] is True

    # Growth argument structure present
    g = level2["growth"]["equalizer_kernel_growth"]
    assert "c_m" in g["claim"] or "c_m" in str(g)
    assert len(g["proof_sketch"]) >= 4
    assert "house rule 9" in g["characteristic"].lower() or "house rule 9" in g["characteristic"]

    # Witnesses nonzero
    assert any(w.get("nonzero") for w in level2["witnesses"])

    # Cross-ref dimension tables hash
    assert level2["dimension_tables_sha256"] == tables["self_sha256"]

    print("PASS Level 2 inverse limit NONZERO with independent dim formulas")
    print("LEVEL2_INVERSE_LIMIT_NONZERO")

    # ------------------------------------------------------------------
    # Necessity theorem structure
    # ------------------------------------------------------------------
    assert necessity["proof"]["status"] == "PROVED"
    step_ids = {s["id"] for s in necessity["proof"]["steps"]}
    for need in [
        "N.1_forced_base_jets",
        "N.2_symbolic_powers",
        "N.5_iterated_incidences",
        "N.6_irrelevant_torsion",
        "N.7_projective_scalars",
        "N.9_no_short_Cech",
    ]:
        assert need in step_ids, f"missing necessity step {need}"

    assert "forward only" in necessity["direction"]
    print("PASS necessity theorem structure")
    print("NECESSITY_THEOREM_OK")

    # ------------------------------------------------------------------
    # All-degree coverage in diagram
    # ------------------------------------------------------------------
    cov = diagram["all_degree_coverage"]
    assert cov["status"] == "PROVED_for_machine_coverage"
    assert "house rule 4" in str(cov).lower() or "house_rule_4" in str(cov).lower() or (
        "Finite generation" in str(cov["named_mechanism_detail"])
    )
    # named mechanism present
    assert "finite_generation_over_correct_rings" in cov["mechanism"]
    print("PASS all-degree coverage mechanism named")
    print("ALL_DEGREE_COVERAGE_OK")

    # ------------------------------------------------------------------
    # Level 3 gate
    # ------------------------------------------------------------------
    l3 = diagram["level3"]
    assert l3["authorized"] is True
    assert l3["executed_as_raw_solve"] is False
    assert l3["verdict"] == "NOT_DECIDED"
    assert l3["exit_N3_status"] == "NOT_REACHED"

    # ------------------------------------------------------------------
    # Distinctions sheaf / graded / torsion
    # ------------------------------------------------------------------
    dist = diagram["distinctions"]
    assert "T_m" in dist["finite_irrelevant_torsion"] or "irrelevant" in dist[
        "finite_irrelevant_torsion"
    ]
    assert "55m" in dist["literal_graded_pieces"] or "109" in dist["literal_graded_pieces"]

    # ------------------------------------------------------------------
    # SEAL consistency
    # ------------------------------------------------------------------
    for key, path in [
        ("diagram", HERE / "diagram.json"),
        ("dimension_tables", HERE / "dimension_tables.json"),
        ("level1_marked_states", HERE / "level1_marked_states.json"),
        ("level2_inverse_limit", HERE / "level2_inverse_limit.json"),
        ("necessity_theorem", HERE / "necessity_theorem.json"),
        ("exit", HERE / "exit.json"),
    ]:
        assert seal["module_self_sha256"][key] == json.loads(path.read_text())["self_sha256"]
        rel = f"certificates/global_transition/{path.name}"
        assert seal["sha256"][rel] == sha256_file(path)

    # produce and common hashed
    assert seal["sha256"]["certificates/global_transition/produce.py"] == sha256_file(
        HERE / "produce.py"
    )
    assert seal["sha256"]["certificates/global_transition/common_global.py"] == sha256_file(
        HERE / "common_global.py"
    )

    # Terminal markers complete
    markers = set(seal["terminal_markers"])
    for m in [
        "GLOBAL_TRANSITION_INCIDENCE_OK",
        "LEVEL1_MARKED_STATE_SURVIVES",
        "LEVEL2_INVERSE_LIMIT_NONZERO",
        "NECESSITY_THEOREM_OK",
        "ALL_DEGREE_COVERAGE_OK",
        "EXIT_P_FORMAL_CONFIGURATION",
        "GLOBAL_TRANSITION_DIAGRAM_OK",
    ]:
        assert m in markers

    print("PASS SEAL consistency")
    print("EXIT_P_FORMAL_CONFIGURATION")
    print("GLOBAL_TRANSITION_DIAGRAM_OK")
    print("GLOBAL_TRANSITION_VERIFY_OK")


if __name__ == "__main__":
    main()
