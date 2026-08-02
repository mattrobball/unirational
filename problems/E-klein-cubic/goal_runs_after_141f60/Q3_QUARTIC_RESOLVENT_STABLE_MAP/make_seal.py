#!/usr/bin/env python3
"""Seal the Q3 packet after verifiers are green."""

from __future__ import annotations

import json
from pathlib import Path

from q3_core import sha256_file

HERE = Path(__file__).resolve().parent


def main() -> None:
    status_first = (HERE / "STATUS.md").read_text().splitlines()[0].strip()
    meta = json.loads((HERE / "produce_meta.json").read_text())

    files = [
        "INPUT_MANIFEST.json",
        "quartic_resolvent.json",
        "monodromy.json",
        "dominance_sample.json",
        "sym_cube.json",
        "boundary.json",
        "bridge_status.json",
        "produce_meta.json",
        "QUARTIC_RESOLVENT_MODEL.md",
        "DEGREE8_PULLBACK.md",
        "SYMMETRIC_CUBE_PULLBACK.md",
        "BOUNDARY_STABLE_MAPS.md",
        "STATUS.md",
        "REPLAY.md",
        "produce.py",
        "q3_core.py",
        "verify_monodromy.py",
        "verify_stable_map.py",
        "verify_point.py",
        "make_seal.py",
    ]
    payload = {
        "format": "q3-seal-v1",
        "primary_exit": status_first,
        "also_achieved": [
            "Q3-QUARTIC-RESOLVENT-MODEL-PASS",
            "Q3-SCHUR-MONODROMY-PASS",
        ],
        "not_achieved": [
            "Q3-STABLE-MAP-HEADLINE-POSITIVE",
            "Q3-GENERALIZED-TWISTED-CUBIC-HEADLINE-POSITIVE",
            "Q3-BOUNDARY-REDUCTION-PASS",
            "BRIDGE_STABLE_CUBIC_POS",
        ],
        "headline": "OPEN",
        "pinned_goal_baseline": "141f6042f628f984771fc79d8d16beb12cedcb94",
        "peak_rss_mb": meta.get("peak_rss_mb"),
        "wall_s": meta.get("wall_s"),
        "files": {
            name: {
                "sha256": sha256_file(HERE / name),
                "bytes": (HERE / name).stat().st_size,
            }
            for name in files
            if (HERE / name).exists()
        },
        "nonclaims": [
            "no K_Schur-point from virtual count eight",
            "no fabricated stable map or GTC Hilbert point",
            "no replacement of installed Schur quartic by a general quartet",
            "modular Klein probes are not char-0 reconstruction",
        ],
        "marker": "Q3_SEAL_OK",
    }
    (HERE / "SEAL.json").write_text(json.dumps(payload, indent=2) + "\n")
    print("Q3_SEAL_OK")


if __name__ == "__main__":
    main()
