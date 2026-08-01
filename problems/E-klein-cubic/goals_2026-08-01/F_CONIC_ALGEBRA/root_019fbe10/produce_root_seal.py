#!/usr/bin/env python3
"""Seal the isolated terminal Goal F audit."""

from __future__ import annotations

from hashlib import sha256
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
FILES = (
    "STATUS.md",
    "RESOLUTION.md",
    "REPLAY.md",
    "verify_root_audit.py",
    "produce_root_seal.py",
    "build_net_normality_probe.py",
    "NET_NORMALITY_CERTIFICATE.json",
    "agent_valuation_classgroup/AUDIT.md",
    "agent_valuation_classgroup/verify_lift_hypotheses.py",
    "../SEAL.json",
    "../INFINITY_OBSTRUCTION.md",
    "../infinity_obstruction.json",
    "../verify_infinity_obstruction.py",
)
FILES += tuple(
    f"net_normality_{plane}_{lam}_p89.sing"
    for plane in ("X", "y", "w")
    for lam in ("l0", "l1", "l2")
)


def digest(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def main() -> None:
    payload = {
        "format": "goal-F-root-terminal-audit-v2",
        "exit": "F-CONIC-CRITERION-EMPTY",
        "headline": "OPEN",
        "scope": "auxiliary fixed-frame cubic over K_proj",
        "sha256": {name: digest(HERE / name) for name in FILES},
    }
    (HERE / "SEAL.json").write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("ROOT_GOAL_F_TERMINAL_SEAL_WRITTEN")


if __name__ == "__main__":
    main()
