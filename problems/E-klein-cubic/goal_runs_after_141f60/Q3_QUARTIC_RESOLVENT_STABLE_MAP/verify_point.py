#!/usr/bin/env python3
"""Independent verifier: no K_Schur-point claim; STATUS/SEAL consistency.

Does not import produce.py.
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent


def main() -> int:
    status = (HERE / "STATUS.md").read_text()
    first = status.splitlines()[0].strip()
    meta = json.loads((HERE / "produce_meta.json").read_text())
    bridge = json.loads((HERE / "bridge_status.json").read_text())
    mon = json.loads((HERE / "monodromy.json").read_text())

    allowed = {
        "Q3-STABLE-MAP-HEADLINE-POSITIVE",
        "Q3-GENERALIZED-TWISTED-CUBIC-HEADLINE-POSITIVE",
        "Q3-SCHUR-MONODROMY-PASS",
        "Q3-BOUNDARY-REDUCTION-PASS",
        "Q3-QUARTIC-RESOLVENT-MODEL-PASS",
        "Q3-UNDECIDED",
        "Q3-CANONICAL-INPUT-FAIL",
    }
    assert first in allowed, first
    assert meta["exit"] == first
    assert meta["headline"] == "OPEN"

    # No point without bridge
    if first not in {
        "Q3-STABLE-MAP-HEADLINE-POSITIVE",
        "Q3-GENERALIZED-TWISTED-CUBIC-HEADLINE-POSITIVE",
    }:
        assert not (HERE / "POINT.md").exists()
        assert not (HERE / "BRIDGE_STABLE_CUBIC_POS.md").exists()
        assert bridge["point_md"] is False
        assert meta["stable_map_found"] is False
        assert meta["gtc_point_found"] is False

    # Monodromy pass requires model pass content
    if first == "Q3-SCHUR-MONODROMY-PASS":
        model = json.loads((HERE / "quartic_resolvent.json").read_text())
        assert model["marker"] == "Q3-QUARTIC-RESOLVENT-MODEL-PASS"
        assert mon["marker_achieved"] is True
        assert "Q3-QUARTIC-RESOLVENT-MODEL-PASS" in status
        assert "OPEN" in status

    # Peak RSS reported
    assert meta["peak_rss_mb"] > 0
    assert "peak RSS" in status or "peak_rss" in status.lower() or "Peak resource" in status

    # Hard fence: virtual count not used as point
    assert mon["forbidden_inference"]
    assert "virtual count eight" in mon["forbidden_inference"]

    print("Q3_POINT_VERIFY_OK")
    return 0


if __name__ == "__main__":
    sys.exit(main())
