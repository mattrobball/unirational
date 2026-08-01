#!/usr/bin/env python3
"""Independent top-level replay for the exact 11:5 sparse trace packet."""

from __future__ import annotations

from hashlib import sha256
import json
from pathlib import Path
import subprocess
import sys


HERE = Path(__file__).resolve().parent


def repository_root() -> Path:
    for candidate in (HERE, *HERE.parents):
        if candidate.name == "E-klein-cubic":
            return candidate
    raise AssertionError("repository root not found")


def run(script: str, marker: str) -> None:
    result = subprocess.run(
        [sys.executable, str(HERE/script)], cwd=HERE, text=True,
        capture_output=True, check=True,
    )
    print(result.stdout, end="")
    assert marker in result.stdout, (script, marker)


def verify_sources() -> None:
    manifest = json.loads((HERE/"source_manifest.json").read_text())
    assert manifest["format"] == "Q-11_5-TRACE-SPARSE-SOURCE-MANIFEST-v1"
    root = repository_root()
    for record in manifest["sources"]:
        path = root/record["repo_relative_path"]
        assert path.is_file(), path
        assert sha256(path.read_bytes()).hexdigest() == record["sha256"]
    print("PASS immutable installed 11:5 trace sources")


def verify_docs() -> None:
    theorem = (HERE/"THEOREM.md").read_text()
    status = (HERE/"STATUS.md").read_text()
    assert "absolutely irreducible cubic" in theorem
    assert "66,144" in theorem
    assert "do not cover arbitrary rational-function ratios" in theorem
    assert status.startswith("Q-UNDECIDED")
    assert "No rational point" in status
    print("PASS theorem scope and strict nonclaims")


def verify_seal() -> None:
    seal = json.loads((HERE/"SEAL.json").read_text())
    assert seal["format"] == "Q-11_5-TRACE-SPARSE-SEAL-v1"
    expected = {
        path.relative_to(HERE).as_posix(): sha256(path.read_bytes()).hexdigest()
        for path in HERE.rglob("*")
        if path.is_file() and path.name != "SEAL.json" and "__pycache__" not in path.parts
    }
    assert seal["files"] == expected
    print(f"PASS recursive packet seal files={len(expected)}")


def main() -> None:
    verify_sources()
    run("factor_binary_kummer_singular.py", "H_TRACE_FOURIER_BINARY_FULL_FIELD_IRREDUCIBLE_OK")
    run("newton_binary_absolute.py", "H_TRACE_FOURIER_BINARY_NEWTON_ABSOLUTE_OK")
    run("absolute_specialization_pair04.py", "PAIR_0_4_ABSOLUTE_SPECIALIZATION_OK")
    run("screen_ternary_monomial_ratios.py", "H_TRACE_FOURIER_TERNARY_LAURENT_EXCLUSION_OK")
    verify_docs()
    verify_seal()
    print("Q_11_5_TRACE_SPARSE_PACKET_VERIFY_ALL_OK")


if __name__ == "__main__":
    main()

