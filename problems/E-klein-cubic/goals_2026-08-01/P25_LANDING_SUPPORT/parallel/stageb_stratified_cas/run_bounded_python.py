#!/usr/bin/env python3
"""Run a Python producer in this packet with a hard wall/RSS fence."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
from pathlib import Path
import signal
import subprocess
import sys
import time


HERE = Path(__file__).resolve().parent
P25 = HERE.parents[1]
sys.path.insert(0, str(P25))
from run_singular import rss  # noqa: E402


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("script")
    parser.add_argument("--timeout", type=float, default=1800.0)
    parser.add_argument("--rss-gib", type=float, default=6.0)
    parser.add_argument("--min-free-gib", type=float, default=25.0)
    args = parser.parse_args()
    script = (HERE / args.script).resolve()
    if script.parent != HERE or script.suffix != ".py" or not script.is_file():
        raise SystemExit("script must be an existing Python file in this packet")
    stem = script.stem
    log = HERE / f"{stem}.log"
    report = HERE / f"{stem}.run.json"
    command = [
        "/opt/homebrew/bin/python3",
        str(script),
        "--min-free-gib",
        str(args.min_free_gib),
    ]
    started = time.monotonic()
    peak = 0
    stop_reason: str | None = None
    process: subprocess.Popen[str] | None = None
    try:
        with log.open("w") as output:
            process = subprocess.Popen(
                command,
                stdout=output,
                stderr=subprocess.STDOUT,
                text=True,
                start_new_session=True,
            )
            while process.poll() is None:
                peak = max(peak, rss(process.pid))
                elapsed = time.monotonic() - started
                if peak >= args.rss_gib * 1024**3:
                    stop_reason = "rss"
                    os.killpg(process.pid, signal.SIGKILL)
                    break
                if elapsed >= args.timeout:
                    stop_reason = "timeout"
                    os.killpg(process.pid, signal.SIGKILL)
                    break
                time.sleep(0.1)
            returncode = process.wait()
    except KeyboardInterrupt:
        if process is not None and process.poll() is None:
            os.killpg(process.pid, signal.SIGKILL)
            process.wait()
        raise
    payload = {
        "command": command,
        "script_sha256": sha256(script),
        "elapsed_seconds": time.monotonic() - started,
        "peak_rss_bytes_polled": peak,
        "rss_limit_bytes": int(args.rss_gib * 1024**3),
        "timeout_seconds": args.timeout,
        "returncode": returncode,
        "stop_reason": stop_reason,
        "complete": returncode == 0 and stop_reason is None,
        "log_sha256": sha256(log),
        "log_bytes": log.stat().st_size,
    }
    report.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(json.dumps(payload, sort_keys=True), flush=True)


if __name__ == "__main__":
    main()
