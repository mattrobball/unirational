#!/usr/bin/env python3
"""Independently replay the systematic decomposition and leading-term check."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path
import subprocess

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[3]
RELATION = ROOT / "certificates" / "degree25_finite_module" / "relation_matrix.npz"
P = 89


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def weak_compositions(total: int, parts: int) -> list[tuple[int, ...]]:
    if parts == 1:
        return [(total,)]
    return [
        (first,) + tail
        for first in range(total + 1)
        for tail in weak_compositions(total - first, parts - 1)
    ]


def main() -> None:
    certificate = json.loads((HERE / "systematic_leading_terms.json").read_text())
    if certificate["source"]["sha256"] != sha256(RELATION):
        raise AssertionError("certificate source hash mismatch")
    with np.load(RELATION, allow_pickle=False) as frozen:
        seeds = frozen["seed_F3"].astype(np.uint8)
        offsets = frozen["off3"].astype(np.int32)
        if int(frozen["prime"]) != P:
            raise AssertionError("prime mismatch")
    q1 = weak_compositions(1, 37)
    variable_of = [monomial.index(1) for monomial in q1]
    m2 = np.empty((690, 21, 37), dtype=np.uint8)
    for component in range(21):
        block = seeds[:, int(offsets[7 + component]) : int(offsets[8 + component])]
        for monomial_index, variable in enumerate(variable_of):
            m2[:, component, variable] = block[:, monomial_index]
    flatten = m2.reshape(690, 777)
    nnz = np.count_nonzero(flatten, axis=0)
    unit_columns = np.flatnonzero(nnz == 1).astype(np.int32)
    free_columns = np.flatnonzero(nnz > 1).astype(np.int32)
    unit_rows = np.asarray(
        [int(np.flatnonzero(flatten[:, column])[0]) for column in unit_columns],
        dtype=np.int32,
    )
    if len(unit_columns) != 690 or len(free_columns) != 87:
        raise AssertionError("systematic dimensions mismatch")
    if not np.array_equal(
        flatten[unit_rows][:, unit_columns], np.eye(690, dtype=np.uint8)
    ):
        raise AssertionError("identity minor replay failed")
    tail = flatten[unit_rows][:, free_columns]
    packet_path = HERE / certificate["decomposition"]["file"]
    if sha256(packet_path) != certificate["decomposition"]["sha256"]:
        raise AssertionError("decomposition packet hash mismatch")
    with np.load(packet_path, allow_pickle=False) as packet:
        expected = {
            "unit_columns": unit_columns,
            "free_columns": free_columns,
            "unit_rows": unit_rows,
            "tail": tail,
        }
        for key, value in expected.items():
            if not np.array_equal(packet[key], value):
                raise AssertionError(f"decomposition packet mismatch: {key}")
    for job in certificate["jobs"]:
        script = HERE / job["script"]["file"]
        if sha256(script) != job["script"]["sha256"]:
            raise AssertionError(f"job hash mismatch: {script.name}")

    check_manifest = json.loads((HERE / "systematic_stageB_leading_check.json").read_text())
    check_script = HERE / check_manifest["script"]["file"]
    if sha256(check_script) != check_manifest["script"]["sha256"]:
        raise AssertionError("leading-check script hash mismatch")
    completed = subprocess.run(
        ["/opt/homebrew/bin/Singular", "-q", str(check_script)],
        text=True, capture_output=True, timeout=120, check=False,
    )
    output = completed.stdout + completed.stderr
    leading_ok = (
        completed.returncode == 0
        and "SYSTEMATIC_LT_CHECK=1" in output
        and "LEADING_CHECK_ONLY_COMPLETE" in output
        and "LT_FAIL" not in output
    )
    if not leading_ok:
        raise AssertionError(f"Singular leading-term replay failed:\n{output[-4000:]}")
    payload = {
        "status": "PASS_INDEPENDENT_SYSTEMATIC_LEADING_TERMS",
        "source_sha256": sha256(RELATION),
        "flattening_shape": list(flatten.shape),
        "unit_columns": len(unit_columns),
        "free_columns": len(free_columns),
        "identity_minor": True,
        "tail_nnz": int(np.count_nonzero(tail)),
        "decomposition_sha256": sha256(packet_path),
        "leading_check_script_sha256": sha256(check_script),
        "singular_returncode": completed.returncode,
        "singular_markers": [
            "SYSTEMATIC_LT_CHECK=1",
            "LEADING_CHECK_ONLY_COMPLETE",
        ],
        "standard_basis_completed": False,
        "scope": "Exact term-order verification only; no Stage-B or P25 verdict.",
    }
    result = HERE / "verify_systematic_result.json"
    result.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(json.dumps(payload, sort_keys=True))


if __name__ == "__main__":
    main()

