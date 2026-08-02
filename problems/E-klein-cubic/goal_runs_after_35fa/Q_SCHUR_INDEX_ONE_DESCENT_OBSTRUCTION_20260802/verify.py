#!/usr/bin/env python3
"""Independent finite consistency verifier for the Q2.1 close-out packet."""

from __future__ import annotations

import hashlib
import json
import math
from pathlib import Path

ROOT = Path(__file__).resolve().parent
PAYLOAD = ROOT / "audit_payload.json"
SEAL = ROOT / "SEAL.json"

EXPECTED_SOURCE_BLOBS = {
    "goal": "d2fc6ebd90be1452b9ee272930abd5a7fb8a478f",
    "zero_cycle_ledger": "c3fcc5d56532683dd03ae00610926236b949a438",
    "descent_obstruction": "0cd8c3ab7bf3f91295ff0e13c17941e1bd87e59a",
    "status": "bd79079b67bfa6551186903bc4485839828b359b",
    "continuation_audit": "c57e19f7d7405d51edf2cb0da001ae1f7e182c69",
}


def git_blob_sha1(path: Path) -> str:
    data = path.read_bytes()
    header = f"blob {len(data)}\0".encode("ascii")
    return hashlib.sha1(header + data).hexdigest()


def require(condition: bool, message: str) -> None:
    if not condition:
        raise SystemExit(f"VERIFY_FAIL: {message}")


def main() -> None:
    payload = json.loads(PAYLOAD.read_text(encoding="utf-8"))
    require(payload["goal_exit"] == "Q-UNDECIDED", "dishonest goal exit")
    require(
        payload["scoped_exit"] == "Q2.1-DESCENT-OBSTRUCTION-AUDIT-PASS",
        "wrong scoped exit",
    )
    require(payload["binary_claim_made"] is False, "binary claim must be false")

    degrees = payload["effective_zero_cycle_degrees"]
    require(degrees == [3, 55], "zero-cycle degrees changed")
    require(payload["degree_3_cycle_separable"] is True, "degree-3 separability flag missing")
    require(payload["degree_55_is_single_closed_point"] is True, "degree-55 point flag missing")
    require(math.gcd(*degrees) == 1, "degrees are not coprime")

    bezout = payload["bezout"]
    value = (
        bezout["coefficient_degree_3"] * degrees[0]
        + bezout["coefficient_degree_55"] * degrees[1]
    )
    require(value == bezout["value"] == 1, "Bezout identity failed")

    require(payload["geometric_etale_pi1_trivial"] is True, "pi1 flag missing")
    require(
        payload["surviving_local_decomposition_groups"]
        == ["PSL(2,11)", "11:5"],
        "local survivor list changed",
    )
    require(payload["source_blobs"] == EXPECTED_SOURCE_BLOBS, "source drift")

    theorem = (ROOT / "TRANSFER_AND_DESCENT_THEOREM.md").read_text(encoding="utf-8")
    frontier = (ROOT / "OBSTRUCTION_FRONTIER.md").read_text(encoding="utf-8")
    status = (ROOT / "STATUS.md").read_text(encoding="utf-8")

    for marker in (
        "Universal transfer-annihilation lemma",
        "Constant finite nonabelian recipients",
        "Finite descent over the cubic is geometrically empty",
        "A broad connected nonabelian no-go theorem",
        "arXiv:1009.4621",
        "arXiv:1702.00516",
    ):
        require(marker in theorem, f"missing theorem marker: {marker}")

    require(status.startswith("Q-UNDECIDED\n"), "STATUS must remain nonterminal")
    require(
        "Q2.1-DESCENT-OBSTRUCTION-AUDIT-PASS" in status,
        "scoped status marker missing",
    )
    require("PSL(2,11), 11:5" in frontier, "valuation survivor marker missing")
    require("The binary point problem\nremains open" in frontier, "open boundary missing")

    seal = json.loads(SEAL.read_text(encoding="utf-8"))
    require(seal["schema"] == "q2.1-descent-obstruction-seal-v1", "bad seal schema")
    require(seal["goal_exit"] == "Q-UNDECIDED", "bad sealed goal exit")
    require(
        seal["scoped_exit"] == "Q2.1-DESCENT-OBSTRUCTION-AUDIT-PASS",
        "bad sealed scoped exit",
    )
    for rel, digest in seal["git_blob_sha1"].items():
        path = ROOT / rel
        require(path.is_file(), f"missing sealed file: {rel}")
        require(git_blob_sha1(path) == digest, f"git blob mismatch: {rel}")

    print("Q2_1_DESCENT_OBSTRUCTION_AUDIT_ACCEPT")


if __name__ == "__main__":
    main()
