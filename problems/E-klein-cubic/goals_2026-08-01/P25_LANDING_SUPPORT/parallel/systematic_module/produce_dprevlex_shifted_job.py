#!/usr/bin/env python3
"""Prepare and validate the graded h-block / dp-tie shifted Stage-B order."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path
import subprocess


HERE = Path(__file__).resolve().parent
SOURCE_JOB = HERE / "systematic_stageB_homogenized_all222.sing"
SOURCE_CHECK = HERE / "systematic_stageB_leading_check.sing"
TARGET_JOB = HERE / "systematic_stageB_hblock_dp_all222.sing"
TARGET_CHECK = HERE / "systematic_stageB_hblock_dp_leading_check.sing"
MANIFEST = HERE / "systematic_stageB_hblock_dp_all222.json"


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def immutable(path: Path, data: bytes) -> None:
    if path.exists():
        if path.read_bytes() != data:
            raise RuntimeError(f"refusing to overwrite mismatching artifact: {path}")
        return
    path.write_bytes(data)


def transform(source: Path) -> bytes:
    text = source.read_text()
    old = ",(Dp,C);"
    weights = ",".join(["1"] * 38)
    new = f",(a({weights}),lp(1),dp(37),C);"
    if text.count(old) != 1:
        raise RuntimeError(f"unique ring-order marker absent in {source.name}")
    return text.replace(old, new, 1).encode()


def main() -> None:
    immutable(TARGET_JOB, transform(SOURCE_JOB))
    immutable(TARGET_CHECK, transform(SOURCE_CHECK))
    completed = subprocess.run(
        ["/opt/homebrew/bin/Singular", "-q", str(TARGET_CHECK)],
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
        raise RuntimeError(f"dp shifted leading check failed:\n{output[-4000:]}")
    payload = {
        "status": "PASS_EXACT_HBLOCK_DP_LEADING_TERMS_PREPARED_NOT_RUN",
        "source_job": {"file": SOURCE_JOB.name, "sha256": sha256(SOURCE_JOB)},
        "script": {
            "file": TARGET_JOB.name,
            "sha256": sha256(TARGET_JOB),
            "bytes": TARGET_JOB.stat().st_size,
        },
        "leading_check": {
            "file": TARGET_CHECK.name,
            "sha256": sha256(TARGET_CHECK),
            "bytes": TARGET_CHECK.stat().st_size,
            "returncode": completed.returncode,
            "markers": ["SYSTEMATIC_LT_CHECK=1", "LEADING_CHECK_ONLY_COMPLETE"],
        },
        "term_order": (
            "a(total degree), lp(h block), dp(q5..q36,q4,q0..q3), C"
        ),
        "proof": (
            "The a-row compares total degree first; all transformed row terms tie. "
            "lp(1) then makes h*M2 exceed M1. The q order keeps every pivot "
            "q5..q36 above free q4,q0..q3; q4 pivot ties are resolved by C exactly "
            "as in the Dp packet. Runtime checks verify all 690 rows."
        ),
        "criterion": (
            "Only a completed terminal passed=222,all_member=1 would prove the "
            "222 memberships. This packet has not run std."
        ),
        "scope": "Exact leading terms and immutable job only; no membership verdict.",
    }
    immutable(MANIFEST, (json.dumps(payload, indent=2, sort_keys=True) + "\n").encode())
    print(json.dumps(payload, sort_keys=True))


if __name__ == "__main__":
    main()

