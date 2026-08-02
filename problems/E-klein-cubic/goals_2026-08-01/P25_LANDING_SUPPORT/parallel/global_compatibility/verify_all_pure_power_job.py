#!/usr/bin/env python3
"""Replay the immutable all-222 direct weighted-module job preparation."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path
import subprocess


HERE = Path(__file__).resolve().parent
PRODUCER = HERE / "produce_all_pure_power_job.py"
SCRIPT = HERE / "direct_690_all_222_degree5.sing"
MANIFEST = HERE / "direct_690_all_222_degree5.json"
RESULT = HERE / "verify_all_pure_power_job_result.json"


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def main() -> None:
    before_script = sha256(SCRIPT)
    before_manifest = sha256(MANIFEST)
    subprocess.run(["/opt/homebrew/bin/python3", str(PRODUCER)], check=True)
    if sha256(SCRIPT) != before_script or sha256(MANIFEST) != before_manifest:
        raise AssertionError("immutable rebuild changed an artifact")
    payload = json.loads(MANIFEST.read_text())
    if payload["status"] != "PREPARED_NOT_RUN" or payload["launched"] is not False:
        raise AssertionError("job must remain unlaunched")
    if payload["module"]["component_weights"] != [0] * 6 + [1] * 21:
        raise AssertionError("component weights changed")
    if payload["module"]["degree_bound"] != 5:
        raise AssertionError("degree bound changed")
    text = SCRIPT.read_text()
    if text.count("rem=reduce(target,G);") != 222:
        raise AssertionError("script does not reduce exactly 222 targets")
    if text.count("module G=std(N)") != 1:
        raise AssertionError("script must compute the standard basis once")
    for axis in range(37):
        for component in range(6):
            needle = f"target=q{axis}^5*gen({component + 1});"
            if text.count(needle) != 1:
                raise AssertionError(f"target occurrence mismatch: {needle}")
    result = {
        "status": "PASS_IMMUTABLE_ALL_222_JOB_REPLAY",
        "script_sha256": before_script,
        "manifest_sha256": before_manifest,
        "standard_basis_calls": 1,
        "target_reductions": 222,
        "component_weights": [0] * 6 + [1] * 21,
        "launched": False,
    }
    RESULT.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    print("PASS: immutable direct-690 all-222 job replayed; not launched")


if __name__ == "__main__":
    main()

