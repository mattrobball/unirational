#!/usr/bin/env python3
"""Create the deterministic content seal for the Goal V packet."""

from __future__ import annotations

from hashlib import sha256
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
FILES = (
    "COMPLETION_AUDIT.md",
    "HESSIAN_LINE.md",
    "MODEL.md",
    "REPLAY.md",
    "STATUS.md",
    "THEOREM.md",
    "VALUATION_CENSUS.md",
    "WORK_SCOPE.md",
    "axis_divisors.json",
    "hessian_line.json",
    "make_seal.py",
    "produce_axis_divisors.py",
    "produce_hessian_line.py",
    "route_decision.json",
    "verify.py",
    "verify_axis_divisors.py",
    "verify_hessian_line.py",
    "verify_tropical_rank_one.py",
)


def digest(path: Path) -> str:
    value = sha256()
    with path.open("rb") as handle:
        while chunk := handle.read(1 << 20):
            value.update(chunk)
    return value.hexdigest()


def main() -> None:
    decision = json.loads((HERE / "route_decision.json").read_text())
    payload = {
        "schema": "klein-goal-v-packet-seal-v1",
        "artifact_root": HERE.name,
        "exit_code": decision["exit_code"],
        "headline": decision["headline"],
        "repository_head_at_start": decision["repository_head_at_start"],
        "pinned_mathematical_baseline": decision["pinned_mathematical_baseline"],
        "files": {name: digest(HERE / name) for name in FILES},
    }
    (HERE / "SEAL.json").write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("V_VALUATION_TROPICAL_SEAL_WRITTEN")


if __name__ == "__main__":
    main()
