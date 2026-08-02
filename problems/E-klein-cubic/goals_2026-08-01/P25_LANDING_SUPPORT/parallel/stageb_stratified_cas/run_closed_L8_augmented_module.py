#!/usr/bin/env python3
"""Run one prepared augmented-module Singular job with time/RSS fencing."""

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

SINGULAR = "/opt/homebrew/bin/Singular"


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def parse_result(path: Path) -> dict[str, str]:
    answer: dict[str, str] = {}
    for line in path.read_text(errors="replace").splitlines():
        if "=" in line:
            key, value = line.split("=", 1)
            answer[key.strip()] = value.strip()
    return answer


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("order", choices=("degrevlex", "deglex"))
    parser.add_argument("--timeout", type=int, default=900)
    parser.add_argument("--rss-gib", type=float, default=4.0)
    args = parser.parse_args()
    script = HERE / f"closed_L8_augmented_module_{args.order}.sing"
    result = HERE / f"closed_L8_augmented_module_{args.order}.result"
    log = HERE / f"closed_L8_augmented_module_{args.order}.log"
    report = HERE / f"closed_L8_augmented_module_{args.order}_run.json"
    if not script.is_file():
        raise FileNotFoundError(script)
    result.unlink(missing_ok=True)
    log.write_text("")
    command = [SINGULAR, "-q", str(script)]
    started = time.monotonic()
    peak = 0
    stop_reason: str | None = None
    process: subprocess.Popen[str] | None = None
    try:
        with log.open("w") as handle:
            process = subprocess.Popen(
                command,
                stdout=handle,
                stderr=subprocess.STDOUT,
                text=True,
                start_new_session=True,
            )
            while process.poll() is None:
                peak = max(peak, rss(process.pid))
                elapsed = time.monotonic() - started
                if peak >= args.rss_gib * 1024**3:
                    stop_reason = "memory"
                    os.killpg(process.pid, signal.SIGKILL)
                    break
                if elapsed >= args.timeout:
                    stop_reason = "timeout"
                    os.killpg(process.pid, signal.SIGKILL)
                    break
                time.sleep(0.2)
            returncode = process.wait()
    except KeyboardInterrupt:
        if process is not None and process.poll() is None:
            os.killpg(process.pid, signal.SIGKILL)
            process.wait()
        raise

    parsed = parse_result(result) if result.is_file() else {}
    complete = returncode == 0 and stop_reason is None and parsed.get("status") == "COMPLETE"
    quotient_dimension = (
        int(parsed["quotient_dimension"])
        if complete and "quotient_dimension" in parsed
        else None
    )
    terminal_empty = complete and quotient_dimension == 0
    payload = {
        "status": (
            "PASS_CLOSED_L8_STAGEC_EMPTY"
            if terminal_empty
            else "COMPLETE_NONTERMINAL"
            if complete
            else "INCOMPLETE_RESOURCE_BOUND"
        ),
        "tool": subprocess.run(
            [SINGULAR, "--version"], text=True, capture_output=True, check=True
        ).stdout.splitlines()[0],
        "command": command,
        "order": args.order,
        "script_sha256": sha256(script),
        "returncode": returncode,
        "stop_reason": stop_reason,
        "complete": complete,
        "quotient_dimension": quotient_dimension,
        "quotient_vector_dimension": (
            int(parsed["quotient_vector_dimension"])
            if complete and "quotient_vector_dimension" in parsed
            else None
        ),
        "gb_generators": (
            int(parsed["gb_generators"])
            if complete and "gb_generators" in parsed
            else None
        ),
        "closed_L8_stageC_empty": terminal_empty,
        "elapsed_seconds": time.monotonic() - started,
        "peak_rss_bytes": peak,
        "rss_limit_bytes": int(args.rss_gib * 1024**3),
        "result_sha256": sha256(result) if result.is_file() else None,
        "log_sha256": sha256(log),
        "scope": (
            "A zero quotient dimension is terminal for normalized Stage C on "
            "projective L8. Any nonzero dimension, timeout, or memory stop is a "
            "nonverdict and does not exhibit a point."
        ),
    }
    report.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(json.dumps(payload, sort_keys=True), flush=True)


if __name__ == "__main__":
    main()
