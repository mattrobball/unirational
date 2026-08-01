#!/usr/bin/env python3
"""Independently verify the S19 continuation-2 seal and theorem boundary."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
PARENT = HERE.parent / "CODEX_ROOT_20260801_7B4E"


def sha256(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def main():
    seal = json.loads((HERE / "SEAL.json").read_text())
    assert seal["schema"] == "s19-marked-curve-continuation-2-seal-v1"
    assert seal["decision_exit"] == "S19-UNDECIDED"
    assert seal["terminal_marker"] == "S19_MARKED_CURVE_CONTINUATION_2_SEALED_UNDECIDED"
    assert seal["parent_seal_sha256"] == sha256(PARENT / "SEAL.json")
    assert (HERE / "STATUS.md").read_text().splitlines()[0] == "S19-UNDECIDED"
    for name, expected in seal["artifact_sha256"].items():
        assert sha256(HERE / name) == expected, name

    hankel = json.loads((HERE / "hankel_probe.json").read_text())
    tested = sum(hankel["tested_distinct_by_family"].values())
    assert hankel["schema"] == "s19-hankel-incidence-probe-v2"
    assert tested == 5468 and hankel["rank_histogram"] == {"20": tested}
    assert hankel["candidate"] is None

    trisecant = json.loads((HERE / "trisecant_degeneration.json").read_text())
    assert trisecant["terminal_marker"] == "S19_EXACT_TRISECANT_DEGENERATION_CERTIFIED"
    assert trisecant["orbit_triangle_configuration"]["minimum_cover_size"] == 21
    union = trisecant["nineteen_line_cover"]
    assert union["component_count"] == 17
    assert union["hilbert_polynomial"] == "19*t+17"
    assert union["arithmetic_genus"] == -16

    family = json.loads((HERE / "two_transversal_family_mod67.json").read_text())
    assert family["terminal_marker"] == "S19_TWO_TRANSVERSAL_AFFINE_H4_MOD67_NO_LINE_TREE"
    closure = family["algebraic_closure_audit"]
    assert closure["required_nonidentical_edges_for_connected_graph"] == 16
    assert closure["points_with_at_least_16_nonidentical_edges_and_distinct_55_marks_and_19_lines"] == 0
    assert any("finite-characteristic" in claim for claim in family["strict_nonclaims"])

    assert "No qualifying degree-19 integral rational curve" in (HERE / "STATUS.md").read_text()
    assert "NOT ENTERED" in (HERE / "RESIDUAL_GATE.md").read_text()
    print("PASS seal hashes, parent linkage, and S19-UNDECIDED boundary")
    print("PASS lossless Hankel, exact wrong-Hilbert degeneration, and modular chart scopes")
    print("S19_CONTINUATION_2_SEAL_VERIFIED")


if __name__ == "__main__":
    main()
