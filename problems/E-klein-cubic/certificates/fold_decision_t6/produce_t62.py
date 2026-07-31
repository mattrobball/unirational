#!/usr/bin/env python3
"""T6.2 producer — R1 binary decision seal (UNDECIDED)."""
from __future__ import annotations

import json
import os
import resource
import sys
from hashlib import sha256
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
CEILING_MIB = 8192
CAP_ENV = "T62_PRODUCER_MIB"


def enforce_limit() -> None:
    ceiling = CEILING_MIB * 1024**2
    try:
        resource.setrlimit(resource.RLIMIT_AS, (ceiling, ceiling))
    except (OSError, ValueError):
        if sys.platform != "darwin":
            raise
        if os.environ.get(CAP_ENV) == str(CEILING_MIB):
            return
        env = dict(os.environ)
        env[CAP_ENV] = str(CEILING_MIB)
        os.execve(
            "/usr/sbin/taskpolicy",
            ["taskpolicy", "-m", str(CEILING_MIB), sys.executable, *sys.argv],
            env,
        )


def file_hash(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def main() -> None:
    enforce_limit()
    md = HERE / "R1_DECISION.md"
    js = HERE / "r1_decision.json"
    assert md.is_file() and js.is_file()
    text = md.read_text()
    dec = json.loads(js.read_text())
    assert "T2R-UNDECIDED" in text
    assert dec["exit"] == "T2R-UNDECIDED"
    assert dec["R1"] is None
    assert dec["dim_Sing_S_G"] is None
    assert dec["upper_bound"]["status"] == "PROVED"
    assert dec["lower_bound"]["status"] == "NOT_PROVED"
    assert "BOTTLENECK" in text

    payload = {
        "schema": "klein-cubic-T62-payload-v1",
        "gate": "T6.2",
        "exit": "T2R-UNDECIDED",
        "R1": None,
        "dim_Sing_S_G": None,
        "upper_bound_le_2": "PROVED",
        "lower_bound_ge_2": "NOT_PROVED",
        "T6_3_started": False,
        "r1_decision_sha256": file_hash(js),
        "r1_md_sha256": file_hash(md),
    }
    out = HERE / "t62_payload.json"
    out.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    payload["payload_sha256"] = file_hash(out)
    out.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("T62_PRODUCER_SEALED", payload["exit"])


if __name__ == "__main__":
    main()
