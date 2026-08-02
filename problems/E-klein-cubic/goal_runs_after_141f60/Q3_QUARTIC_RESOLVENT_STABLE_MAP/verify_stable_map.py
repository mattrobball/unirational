#!/usr/bin/env python3
"""Independent verifier: no fabricated stable map / GTC; boundary honesty.

Does not import produce.py.
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

from q3_core import evaluate_poly, on_cubic, projective_rank, resolvent_triple

HERE = Path(__file__).resolve().parent


def load(name: str):
    path = HERE / name
    if not path.is_file():
        return None
    return json.loads(path.read_text())


def main() -> int:
    boundary = load("boundary.json")
    sym = load("sym_cube.json")
    bridge = load("bridge_status.json")
    status = (HERE / "STATUS.md").read_text()
    model = load("quartic_resolvent.json")

    assert boundary is not None and sym is not None and bridge is not None

    # No K_Schur stable map claimed
    assert boundary["conclusions"]["any_boundary_stable_map_over_K_Schur"] is False
    assert boundary["conclusions"]["boundary_reduction_pass"] is False
    assert boundary["marker_achieved"] is False
    assert bridge["stable_map_or_gtc_obtained"] is False
    assert bridge["bridge_stable_cubic_pos"] is False
    assert bridge["headline_candidate_exits"]["Q3-STABLE-MAP-HEADLINE-POSITIVE"] is False
    assert bridge["headline_candidate_exits"][
        "Q3-GENERALIZED-TWISTED-CUBIC-HEADLINE-POSITIVE"
    ] is False

    # Symmetric cube: no section
    assert sym["searches"]["rational_section_over_R"]["result"] == "NOT FOUND"
    assert sym["searches"]["low_degree_multisection"]["result"] == "NOT FOUND"
    assert sym["installed_quartic_check"]["coordinates_of_voisin_quartic"] == "NOT EXHIBITED"

    # STATUS does not claim headline positive
    first = status.splitlines()[0].strip()
    assert first in {
        "Q3-SCHUR-MONODROMY-PASS",
        "Q3-QUARTIC-RESOLVENT-MODEL-PASS",
        "Q3-BOUNDARY-REDUCTION-PASS",
        "Q3-UNDECIDED",
        "Q3-CANONICAL-INPUT-FAIL",
    }, first
    assert "Q3-STABLE-MAP-HEADLINE-POSITIVE" not in first
    assert "HEADLINE-POSITIVE" not in first or first.startswith("Q3-SCHUR")

    # Forbidden files for unearned claims
    assert not (HERE / "BRIDGE_STABLE_CUBIC_POS.md").exists()
    assert not (HERE / "POINT.md").exists()
    # STABLE_MAP / HILBERT_POINT only if obtained — must not exist on this exit
    assert not (HERE / "STABLE_MAP.md").exists()
    assert not (HERE / "HILBERT_POINT.md").exists()

    # Boundary types all recorded
    for key in (
        "line_plus_conic",
        "three_lines",
        "double_line_plus_line",
        "nonreduced_gtc",
        "embedded_point_boundary",
    ):
        assert key in boundary["boundary_types"]

    # Double line excluded
    assert boundary["conclusions"]["double_line_excluded_by_no_K_line"] is True

    # GTC bridge readiness is only conditional
    assert "actual K_Schur" in model["gtc_hilbert_compactification"]["bridge_theorem"] or \
        "actual K_Schur" in bridge["output_bridge_ready"] or \
        "odd-degree" in bridge["output_bridge_ready"]

    # If a rational sample quartet exists, re-check it lies on the Klein cubic
    dom = load("dominance_sample.json")
    if dom and dom.get("status") == "COMPUTED":
        four = [tuple(p) for p in dom["sample_quartet"]]
        assert all(on_cubic(p) for p in four)
        triple = resolvent_triple(four)
        assert all(on_cubic(r) for r in triple)
        # ranks consistent
        assert projective_rank(four) == 4

    # Modular scan is labelled modular-only
    assert "modular" in boundary["modular_scan"]["scope"].lower() or \
        "not char-0" in boundary["modular_scan"]["scope"].lower()

    print("Q3_STABLE_MAP_VERIFY_OK")
    return 0


if __name__ == "__main__":
    sys.exit(main())
