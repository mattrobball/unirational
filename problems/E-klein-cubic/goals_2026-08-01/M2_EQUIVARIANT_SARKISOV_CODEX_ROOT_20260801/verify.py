#!/usr/bin/env python3
"""Sealed top-level replay for Goal M2's explicit descended Sarkisov link."""

from __future__ import annotations

import hashlib
import json
import os
import subprocess
import sys
from pathlib import Path


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
WORK = PROBLEM / "goals_2026-08-01"
SEAL_PATH = HERE / "SEAL.json"


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def run(label: str, script: Path, marker: str) -> None:
    environment = os.environ.copy()
    environment["PYTHONDONTWRITEBYTECODE"] = "1"
    completed = subprocess.run(
        [sys.executable, str(script)],
        cwd=WORK,
        env=environment,
        check=True,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )
    if marker not in completed.stdout:
        raise AssertionError(f"{label}: missing replay marker {marker!r}")
    print(f"PASS {label}")


def resolve_upstream(root: str, relative: str) -> Path:
    roots = {"problem": PROBLEM, "work": WORK}
    if root not in roots:
        raise AssertionError(f"unknown sealed root {root!r}")
    return roots[root] / relative


def verify_seal(seal: dict) -> None:
    assert seal["schema"] == "m2-equivariant-sarkisov-seal-v1"
    assert seal["exit"] == "M2-EXPLICIT-LINK-PASS"
    assert seal["headline"] == "OPEN"
    assert seal["goal_pinned_state"] == "35fa8f59b6a1423cc89300aeaceefe91552be5ba"

    actual = {
        path.relative_to(HERE).as_posix()
        for path in HERE.rglob("*")
        if path.is_file() and path != SEAL_PATH and "__pycache__" not in path.parts
    }
    expected = set(seal["local_files"])
    assert actual == expected, (
        f"sealed local inventory mismatch; missing={sorted(expected - actual)}, "
        f"extra={sorted(actual - expected)}"
    )
    for relative, expected_digest in sorted(seal["local_files"].items()):
        path = HERE / relative
        assert sha256(path) == expected_digest, f"local hash mismatch: {relative}"

    for item in seal["upstream_files"]:
        path = resolve_upstream(item["root"], item["path"])
        assert path.is_file(), f"missing sealed input: {path}"
        assert sha256(path) == item["sha256"], f"upstream hash mismatch: {path}"

    for item in seal["source_statuses"]:
        path = resolve_upstream(item["root"], item["path"])
        first_line = path.read_text().splitlines()[0]
        assert first_line == item["marker"], f"status drift: {path}"

    print("PASS sealed local inventory, upstream hashes, and source statuses")


def verify_payload_reproduction() -> None:
    producer = HERE / "links" / "schur_plane_012_dp3" / "produce.py"
    stored_path = HERE / "links" / "schur_plane_012_dp3" / "link_payload.json"
    environment = os.environ.copy()
    environment["PYTHONDONTWRITEBYTECODE"] = "1"
    completed = subprocess.run(
        [sys.executable, str(producer)],
        cwd=WORK,
        env=environment,
        check=True,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )
    assert json.loads(completed.stdout) == json.loads(stored_path.read_text())
    print("PASS exact producer reproduces the stored link payload")


def verify_semantic_contract() -> None:
    required = {
        "CENTRE_CENSUS.md",
        "DIVISOR_COX.md",
        "DESCENT.md",
        "THEOREM.md",
        "COMPLETION_AUDIT.md",
        "payload/centre_census.json",
        "payload/mori_cox.json",
        "links/schur_plane_012_dp3/link_payload.json",
        "links/schur_plane_012_dp3/verify_link.py",
        "verify_census.py",
    }
    assert all((HERE / relative).is_file() for relative in required)
    assert (HERE / "STATUS.md").read_text().splitlines()[0] == "M2-EXPLICIT-LINK-PASS"
    theorem = (HERE / "THEOREM.md").read_text()
    theorem_words = " ".join(theorem.split())
    audit = (HERE / "COMPLETION_AUDIT.md").read_text()
    for phrase in (
        "degree-3 del Pezzo Mori fibre space",
        "degree-55 multisection",
        "proves no negative rigidity statement",
    ):
        assert phrase in theorem_words
    assert "M2-EXPLICIT-LINK-PASS" in audit
    assert "M2.3 positive" in audit and "NOT CLAIMED" in audit
    assert "M2.3 negative" in audit and "NOT CLAIMED" in audit
    print("PASS output contract and explicit-link theorem boundary")


def main() -> None:
    seal = json.loads(SEAL_PATH.read_text())
    verify_seal(seal)

    run(
        "characteristic-zero equal-degree Schur frame",
        PROBLEM / "tmp" / "projective_source" / "degree8_rational_frame.py",
        "PASS invariant rational coefficients in this frame exhaust all rational projective Schur-source maps",
    )
    run(
        "all ten Schur coordinate-plane smoothness routes",
        PROBLEM / "tmp" / "schur_structural_routes" / "verify.py",
        "SCHUR_STRUCTURAL_ROUTES_EXACT",
    )
    run(
        "exact normal-character certificate",
        PROBLEM / "certificates" / "strata" / "verify_normal_characters.py",
        "NORMAL_CHARACTERS_VERIFY_OK",
    )
    run(
        "degree-55 D12 line and zero-cycle ledger",
        WORK / "Q_SCHUR_DESCENT" / "verify_zero_cycle_ledger.py",
        "Q_SCHUR_ZERO_CYCLE_LEDGER_EXACT",
    )
    verify_payload_reproduction()
    run(
        "independent selected-link reconstruction",
        HERE / "links" / "schur_plane_012_dp3" / "verify_link.py",
        "M2_SCHUR_PLANE_LINK_INDEPENDENT_VERIFY_OK",
    )
    run(
        "independent center-census and line-normal reconstruction",
        HERE / "verify_census.py",
        "M2_CENTRE_CENSUS_INDEPENDENT_VERIFY_OK",
    )
    verify_semantic_contract()
    print("M2-EXPLICIT-LINK-PASS")


if __name__ == "__main__":
    main()
