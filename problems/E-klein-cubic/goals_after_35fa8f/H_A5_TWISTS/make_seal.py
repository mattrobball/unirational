#!/usr/bin/env python3
"""Create or check the combined hash seal for Goal H3."""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import subprocess


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
REPOSITORY = PROBLEM.parents[1]
SEAL = HERE / "SEAL.json"

PINNED_STATE = "35fa8f59b6a1423cc89300aeaceefe91552be5ba"
EXPECTED_HEAD = "37d61c19a108781cf74af837e24810a9f7f7c3be"

EXTERNAL = {
    "goals_2026-08-01/H_SUBGROUP_TWISTS_ROOT_019FBE10/BRIDGE.md":
        "660577dd5848eb5f9acb747b4c82877968d3ba5c59181581eb4ba8907d8aa2f8",
    "goals_2026-08-01/H_SUBGROUP_TWISTS_ROOT_019FBE10/twists.json":
        "e97a32d6f22a8028528bc2b4d27ee009901caeb047fd2ffe5ac2bdd1fab743cd",
    "goals_2026-08-01/H_SUBGROUP_TWISTS_ROOT_019FBE10/produce.py":
        "29961a81786f493bc0362b67b4a4a9979224ccee9874a5e1046af5aa942e1f8b",
    "goals_2026-08-01/H_SUBGROUP_TWISTS_ROOT_019FBE10/verify.py":
        "c4af286410a24443a5abfe3394964347ad2e9404e453847723aea416ef3b3381",
    "certificates/exact_weil_check.py":
        "14c9bda195ccc39e3ae2cd6d6d42bbb8f45397e114b5137947fb41dd665cc2b2",
    "certificates/subgroup_orbit_check.py":
        "68e6f18b00d520ae24fdfc0ea1524e5255f9a72b523c141627565e3a5a45bfd7",
}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def files() -> dict[str, str]:
    result = {}
    for path in sorted(HERE.rglob("*")):
        if not path.is_file() or path == SEAL:
            continue
        relative = path.relative_to(HERE)
        if "__pycache__" in relative.parts or relative.name in {".DS_Store"}:
            continue
        result[str(relative)] = sha256(path)
    return result


def expected() -> dict:
    head = subprocess.run(
        ["git", "rev-parse", "HEAD"],
        cwd=REPOSITORY,
        check=True,
        capture_output=True,
        text=True,
    ).stdout.strip()
    assert head == EXPECTED_HEAD, (head, EXPECTED_HEAD)
    for relative, digest in EXTERNAL.items():
        assert sha256(PROBLEM / relative) == digest, relative
    return {
        "format": "klein-h3-two-a5-twists-seal-v1",
        "audit_boundary": PINNED_STATE,
        "repository_head_consumed": EXPECTED_HEAD,
        "produced_commit": None,
        "produced_state": "uncommitted hash-sealed worktree artifact",
        "authoritative_packet_creation_commit":
            "2301a439261d3fe84b4c7a65ec8dcf4cc3309f21",
        "authoritative_packet_binding_commit":
            "53e267a59b2d24de93c58dd9ddacc2f995fc2d68",
        "exits": [
            "H-A5-CLASS1-RATIONAL-POINT",
            "H-A5-CLASS2-RATIONAL-POINT",
            "H-A5-STRUCTURAL-MODEL-PASS",
        ],
        "external_dependencies": EXTERNAL,
        "files": files(),
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    data = expected()
    if args.check:
        assert SEAL.is_file()
        assert json.loads(SEAL.read_text()) == data
    else:
        SEAL.write_text(json.dumps(data, indent=2, sort_keys=True) + "\n")
    print(f"PASS combined seal files={len(data['files'])} external={len(EXTERNAL)}")
    print("H3_A5_TWISTS_SEAL_OK")


if __name__ == "__main__":
    main()

