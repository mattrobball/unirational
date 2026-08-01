#!/usr/bin/env python3
"""Replay the exact full-Schur Palatini/self-covariant certificate."""
from __future__ import annotations

import hashlib
import importlib.util
import json
import subprocess
import sys
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
PYTHON = "/opt/homebrew/bin/python3"
P = 23


def run(name: str, *args: str) -> str:
    result = subprocess.run([PYTHON, str(HERE / name), *args], cwd=HERE,
                            text=True, stdout=subprocess.PIPE,
                            stderr=subprocess.STDOUT, check=False)
    assert result.returncode == 0, result.stdout
    return result.stdout


def rank_mod(a: np.ndarray) -> int:
    a = a.astype(np.int64) % P
    row = 0
    for column in range(a.shape[1]):
        pivots = np.flatnonzero(a[row:, column])
        if not len(pivots):
            continue
        pivot = row + int(pivots[0])
        a[[row, pivot]] = a[[pivot, row]]
        a[row] = a[row] * pow(int(a[row, column]), -1, P) % P
        for i in range(a.shape[0]):
            if i != row and a[i, column]:
                a[i] = (a[i] - a[i, column] * a[row]) % P
        row += 1
        if row == a.shape[0]:
            break
    return row


def main() -> None:
    manifest = json.loads((HERE / "source_manifest.json").read_text())
    root = Path(manifest["root"])
    for relative, expected in manifest["sources"].items():
        assert hashlib.sha256((root / relative).read_bytes()).hexdigest() == expected, relative
    print("SOURCE_MANIFEST_OK")

    molien = run("schur_self_molien.py")
    for d, multiplicity in enumerate([0, 1, 0, 1, 0, 3, 0, 8]):
        assert f"{d:2d} {multiplicity:6d}" in molien

    for degree, expected_shape, expected_hash in [
        (5, (15, 15), "032b0a5296714a9d4a1b996fd5cd516edc8bfa9190b818b1b8afa87363f95f50"),
        (7, (319, 330), "30c2a3558c18fac5ee3f7e458f6366a1d7ea4098a1be4b1eef04e778456fdbde"),
    ]:
        path = HERE / f"self_pal_d{degree}_rows.npz"
        assert hashlib.sha256(path.read_bytes()).hexdigest() == expected_hash
        rows = np.load(path)["rows"]
        assert rows.shape == expected_shape
        assert rank_mod(rows) == expected_shape[0]
        meta = json.loads((HERE / f"self_pal_d{degree}.json").read_text())
        assert meta["equation_rank"] == expected_shape[0]

    spec = importlib.util.spec_from_file_location("schur_frame_probe", HERE / "probe_self_covariants_palatinian.py")
    assert spec and spec.loader
    probe_module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = probe_module
    spec.loader.exec_module(probe_module)
    probe = probe_module.Probe()
    basis = probe.basis(7, 8)
    witness = np.array([9, 18, 15, 18, 2, 19], dtype=np.int64)
    frame = np.stack([probe.eval_seed(*seed, witness) for seed in basis[:6]], axis=1)
    assert rank_mod(frame) == 6

    palatini = run("verify_palatinian_equation.py")
    assert "PALATINI_REYNOLDS_I4_IDENTITY_OK" in palatini
    assert "PALATINI_ALL_SIX_MAXIMAL_MINOR_SYZYGIES_OK" in palatini
    lift = run("verify_char0_palatinian_lift.py")
    assert "CHAR0_B5_REDUCTION_MATCH_OK" in lift
    assert "CHAR0_V6_INVARIANT_QUARTIC_DIMENSION_ONE" in lift
    assert "CHAR0_PALATINI_EQUALS_REYNOLDS_I4_LIFT_OK" in lift
    singular = run("solve_self_palatinian.py", "7")
    assert "GB_SIZE=330" in singular
    assert "AFFINE_DIM=0" in singular
    assert "VDIM=176" in singular
    print("FULL_SCHUR_CHAR0_PALATINI_PACKET_OK")
    print("SCOPE: exact char-0 quartic model and bounded exclusions; no K_Schur point and no binary Q verdict")


if __name__ == "__main__":
    main()
