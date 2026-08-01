#!/usr/bin/env python3
"""Packet-level verification for the isolated Goal V route result."""

from __future__ import annotations

from hashlib import sha256
import json
from pathlib import Path
import subprocess
import sys


HERE = Path(__file__).resolve().parent
REQUIRED_FILES = {
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
}
REPLAYS = (
    ("verify_axis_divisors.py", "V_AXIS_DIVISORS_INDEPENDENT_ACCEPT"),
    ("verify_hessian_line.py", "V_F5_HESSIAN_LINE_INDEPENDENT_ACCEPT"),
    ("verify_tropical_rank_one.py", "V_RANK_ONE_TROPICAL_SUPPORT_ACCEPT"),
)


def digest(path: Path) -> str:
    value = sha256()
    with path.open("rb") as handle:
        while chunk := handle.read(1 << 20):
            value.update(chunk)
    return value.hexdigest()


def replay(script: str, marker: str) -> None:
    completed = subprocess.run(
        [sys.executable, "-u", str(HERE / script)],
        cwd=HERE.parent,
        text=True,
        capture_output=True,
        timeout=600,
        check=False,
    )
    if completed.stdout:
        print(completed.stdout, end="")
    if completed.stderr:
        print(completed.stderr, end="", file=sys.stderr)
    assert completed.returncode == 0, f"{script} exited {completed.returncode}"
    assert marker in completed.stdout, f"missing {marker}"


def main() -> None:
    status = (HERE / "STATUS.md").read_text().splitlines()
    assert status and status[0] == "V-UNDECIDED"

    decision = json.loads((HERE / "route_decision.json").read_text())
    assert decision["schema"] == "klein-goal-v-decision-v1"
    assert decision["exit_code"] == status[0]
    assert decision["headline"] == "OPEN"
    assert "a pointless completion of the genuine twist" in decision["not_proved"]
    assert "an exhaustive theorem for all divisorial or higher-rank valuations" in decision["not_proved"]

    axis = json.loads((HERE / "axis_divisors.json").read_text())
    assert axis["schema"] == "klein-genuine-twist-axis-valuations-v1"
    assert len(axis["records"]) == 5
    assert axis["index_one"]["effective_cycle_degrees"] == [60, 132, 165, 220]

    hessian = json.loads((HERE / "hessian_line.json").read_text())
    assert hessian["schema"] == "klein-f5-hessian-kernel-line-v1"
    assert "does not prove" in hessian["strict_scope"]

    for script, marker in REPLAYS:
        replay(script, marker)

    seal = json.loads((HERE / "SEAL.json").read_text())
    assert seal["schema"] == "klein-goal-v-packet-seal-v1"
    assert seal["exit_code"] == decision["exit_code"]
    assert seal["headline"] == decision["headline"]
    assert seal["repository_head_at_start"] == decision["repository_head_at_start"]
    assert seal["pinned_mathematical_baseline"] == decision["pinned_mathematical_baseline"]
    assert set(seal["files"]) == REQUIRED_FILES
    for name, expected in seal["files"].items():
        assert digest(HERE / name) == expected, f"seal mismatch: {name}"

    print("PASS exact V-UNDECIDED theorem boundary")
    print("PASS three independent symbolic/CAS/combinatorial certificate replays")
    print("PASS authoritative artifact content seal")
    print("V_VALUATION_TROPICAL_PACKET_ACCEPT")


if __name__ == "__main__":
    main()
