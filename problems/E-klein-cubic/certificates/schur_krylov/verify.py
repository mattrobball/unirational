#!/usr/bin/env python3
"""Master independent verifier for certificates/schur_krylov (Path A).

Does NOT import any producer module.  Runs gate verifiers as subprocesses
and checks SEAL.json hashes after the last content byte is fixed.
"""
from __future__ import annotations

import hashlib
import json
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
PY = Path("/opt/homebrew/bin/python3")

GATES = [
    ("verify_p1_reduction.py", "A1_P1_REDUCTION_PASS"),
    ("verify_field_algebra.py", "SCHUR_KRYLOV_A2_FIELD_ALGEBRA_SEALED"),
    ("verify_marked_point.py", "SCHUR_KRYLOV_A2_MARKED_POINT_SEALED"),
    ("verify_krylov_incidence.py", "SCHUR_KRYLOV_A3_INCIDENCE_FORMULATED_A_STOP"),
    ("candidate_verifier.py", "CANDIDATE_VERIFIER_READY"),
]


def sha256_file(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 16), b""):
            h.update(chunk)
    return h.hexdigest()


def main() -> int:
    # A1 hard prerequisite: must pass before A2/A3 are considered authorized
    for script, marker in GATES:
        path = HERE / script
        assert path.is_file(), path
        proc = subprocess.run(
            [str(PY), "-u", str(path)],
            cwd=str(HERE.parents[1]),
            capture_output=True,
            text=True,
        )
        out = proc.stdout + proc.stderr
        if proc.returncode != 0:
            print(out)
            print(f"FAIL {script} exit {proc.returncode}")
            return 1
        if marker not in out:
            print(out)
            print(f"FAIL {script} missing marker {marker}")
            return 1
        print(f"PASS {script}")

    seal_path = HERE / "SEAL.json"
    assert seal_path.is_file(), "SEAL.json missing"
    seal = json.loads(seal_path.read_text(encoding="utf-8"))

    assert seal["headline"] == "OPEN"
    assert seal["decision_exit"] == "A-STOP"
    assert seal["gates"]["A1"] == "A1-PASS"
    assert seal["gates"]["A2_field_algebra"] == "SEALED"
    assert seal["gates"]["A2_marked_point"] == "SEALED"
    assert seal["gates"]["A3"] == "A-STOP"
    assert seal.get("N_A_claimed") is False
    assert "HANDOFF.md" in seal.get("forbidden_edits_respected", [])

    # Content hashes (exclude SEAL self-hash field comparison of files)
    deliverable_sha = seal["deliverable_sha256"]
    for rel, expected in deliverable_sha.items():
        path = HERE / rel
        assert path.is_file(), rel
        actual = sha256_file(path)
        assert actual == expected, f"hash mismatch {rel}: {actual} != {expected}"

    # Self-hash: hash of SEAL with seal_sha256_self blank/removed
    seal_obj = json.loads(seal_path.read_text(encoding="utf-8"))
    claimed = seal_obj.pop("seal_sha256_self", None)
    canonical = json.dumps(seal_obj, indent=2, sort_keys=True) + "\n"
    actual_self = hashlib.sha256(canonical.encode("utf-8")).hexdigest()
    assert claimed == actual_self, f"self-hash mismatch {claimed} != {actual_self}"

    print("SCHUR_KRYLOV_GATES_A1_A2_A3_VERIFY_OK")
    print("SCHUR_KRYLOV_DECISION_A_STOP")
    print("HEADLINE_OPEN")
    print("SCHUR_KRYLOV_PATH_A_A_STOP_HEADLINE_OPEN")
    return 0


if __name__ == "__main__":
    sys.exit(main())
