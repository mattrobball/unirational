#!/usr/bin/env python3
"""Replay preparation of the direct full-28 weighted degree-eight job."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path
import subprocess


HERE = Path(__file__).resolve().parent
PRODUCER = HERE / "produce_full28_degree8_job.py"
SCRIPT = HERE / "direct_full690_all28_degree8.sing"
MANIFEST = HERE / "direct_full690_all28_degree8.json"
RESULT = HERE / "verify_full28_degree8_job_result.json"
WEIGHTS = [0] + [1] * 6 + [2] * 21
EXPONENTS = [8] + [7] * 6 + [6] * 21


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def main() -> None:
    script_hash = sha256(SCRIPT)
    manifest_hash = sha256(MANIFEST)
    subprocess.run(["/opt/homebrew/bin/python3", str(PRODUCER)], check=True)
    if sha256(SCRIPT) != script_hash or sha256(MANIFEST) != manifest_hash:
        raise AssertionError("immutable rebuild changed an artifact")
    payload = json.loads(MANIFEST.read_text())
    if payload["status"] != "PREPARED_NOT_RUN" or payload["launched"] is not False:
        raise AssertionError("job must remain unlaunched")
    if payload["module"]["component_weights"] != WEIGHTS:
        raise AssertionError("component weights mismatch")
    if payload["targets"]["component_exponents"] != EXPONENTS:
        raise AssertionError("component exponents mismatch")
    text = SCRIPT.read_text()
    if text.count("module G=std(N)") != 1:
        raise AssertionError("standard basis must be computed once")
    if text.count("rem=reduce(target,G);") != 1036:
        raise AssertionError("expected 1,036 target reductions")
    for axis in range(37):
        for component, exponent in enumerate(EXPONENTS):
            target = f"target=q{axis}^{exponent}*gen({component + 1});"
            if text.count(target) != 1:
                raise AssertionError(f"target occurrence mismatch: {target}")
    result = {
        "status": "PASS_IMMUTABLE_FULL28_DEGREE8_JOB_REPLAY",
        "script_sha256": script_hash,
        "manifest_sha256": manifest_hash,
        "standard_basis_calls": 1,
        "target_reductions": 1036,
        "component_weights": WEIGHTS,
        "component_exponents": EXPONENTS,
        "launched": False,
    }
    RESULT.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    print("PASS: immutable full-28 degree-eight job replayed; not launched")


if __name__ == "__main__":
    main()

