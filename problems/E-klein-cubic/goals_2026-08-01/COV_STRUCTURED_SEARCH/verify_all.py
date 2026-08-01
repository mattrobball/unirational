#!/usr/bin/env python3
"""One-command independent audit of the sealed structured-search packet."""

from __future__ import annotations

import hashlib
import json
import math
from pathlib import Path
import subprocess
import sys


HERE = Path(__file__).resolve().parent
HSOP = (3, 5, 6, 8, 11)
COV_NUMERATOR = {
    1: 1, 4: 1, 5: 1, 6: 1, 7: 1, 8: 4, 9: 2, 10: 4,
    11: 4, 12: 5, 13: 4, 14: 5, 15: 5, 16: 3, 17: 4,
    18: 3, 19: 3, 20: 2, 21: 2, 22: 2, 23: 1, 24: 1, 26: 1,
}
INV_NUMERATOR = {
    0: 1, 7: 1, 9: 1, 10: 1, 12: 1, 14: 2,
    16: 1, 18: 1, 19: 1, 21: 1, 28: 1,
}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def hilbert_coefficient(numerator, degree):
    denominator = [0] * (degree + 1)
    denominator[0] = 1
    for weight in HSOP:
        for index in range(weight, degree + 1):
            denominator[index] += denominator[index - weight]
    return sum(
        multiplicity * denominator[degree - shift]
        for shift, multiplicity in numerator.items()
        if shift <= degree
    )


def verify_seals() -> None:
    inputs = json.loads((HERE / "INPUTS.json").read_text())
    for record in inputs["files"]:
        path = (HERE / record["path"]).resolve()
        assert path.is_file()
        assert sha256(path) == record["sha256"]
        assert path.stat().st_size == record["size"]

    seal = json.loads((HERE / "SEAL.json").read_text())
    assert seal["schema"] == "cov-structured-search-content-seal-v1"
    assert seal["input_manifest_sha256"] == sha256(HERE / "INPUTS.json")
    sealed = set()
    for record in seal["files"]:
        path = HERE / record["path"]
        assert path.is_file()
        assert sha256(path) == record["sha256"]
        assert path.stat().st_size == record["size"]
        sealed.add(record["path"])
    actual = {
        str(path.relative_to(HERE))
        for path in HERE.rglob("*")
        if path.is_file()
        and path.name != "SEAL.json"
        and "__pycache__" not in path.parts
    }
    assert sealed == actual


def verify_summary_semantics() -> None:
    assert (HERE / "STATUS.md").read_text().splitlines()[0] == "COV-NEW-ANSATZ-STRUCTURAL"
    ranking = json.loads((HERE / "degree_ranking.json").read_text())
    assert ranking["ranking"] == [31, 35, 25]
    expected = {
        25: (189, 43, 2343, 59, 43, 18, 13),
        31: (410, 89, 5349, 198, 176, 28, 24),
        35: (637, 139, 8555, 361, 335, 32, 21),
    }
    for record in ranking["selected_degrees"]:
        degree = int(record["degree"])
        cov, inv, landing, arrangement, strict, mixed, corank = expected[degree]
        assert hilbert_coefficient(COV_NUMERATOR, degree) == cov == record["self_covariants"]
        assert hilbert_coefficient(INV_NUMERATOR, degree) == inv == record["scalar_invariants"]
        assert hilbert_coefficient(INV_NUMERATOR, 3 * degree) == landing == record["landing_target_invariants_degree_3d"]
        assert record["arrangement_dimension_good_fibres"] == arrangement
        assert record["strict_dimension_good_fibres"] == strict
        assert record["plane_order_at_least_3_dimensions"] == [0, 0]
        assert record["combined_ansatz_dimension"] == mixed
        assert record["combined_ansatz_primes"] == [199, 353]
        assert record["combined_ansatz_cubic_coranks"] == [corank, corank]
        assert record["combined_ansatz_quartic_dual_nullities"] == [0, 0]
        assert record["combined_ansatz_char0"] == "empty_projective_combined_ansatz"
        candidate = json.loads((HERE / f"degree_{degree}/candidate.json").read_text())
        assert candidate["candidate_found"] is False


def run_independent_replays() -> None:
    for script in (
        "verify_ansatz.py",
        "verify_cross_ansatz.py",
        "verify_global_modules.py",
        "verify_combined_ansatz.py",
    ):
        subprocess.run([sys.executable, "-B", str(HERE / script)], check=True, cwd=HERE)


def main() -> None:
    verify_seals()
    verify_summary_semantics()
    run_independent_replays()
    print("COV_STRUCTURED_SEARCH_VERIFIED")


if __name__ == "__main__":
    main()
