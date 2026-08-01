#!/usr/bin/env python3
"""Run a bounded exact msolve leading-ideal computation with live logging."""

from __future__ import annotations

import argparse
import ctypes
import hashlib
import json
import os
import re
import signal
import subprocess
import sys
import time
from pathlib import Path


HERE = Path(__file__).resolve().parent


class ProcTaskInfo(ctypes.Structure):
    _fields_ = [
        ("virtual_size", ctypes.c_uint64), ("resident_size", ctypes.c_uint64),
        ("total_user", ctypes.c_uint64), ("total_system", ctypes.c_uint64),
        ("threads_user", ctypes.c_uint64), ("threads_system", ctypes.c_uint64),
        ("policy", ctypes.c_int32), ("faults", ctypes.c_int32),
        ("pageins", ctypes.c_int32), ("cow_faults", ctypes.c_int32),
        ("messages_sent", ctypes.c_int32), ("messages_received", ctypes.c_int32),
        ("syscalls_mach", ctypes.c_int32), ("syscalls_unix", ctypes.c_int32),
        ("context_switches", ctypes.c_int32), ("thread_count", ctypes.c_int32),
        ("running_threads", ctypes.c_int32), ("priority", ctypes.c_int32),
    ]


LIBPROC = ctypes.CDLL("/usr/lib/libproc.dylib") if sys.platform == "darwin" else None
if LIBPROC is not None:
    LIBPROC.proc_pidinfo.argtypes = [
        ctypes.c_int, ctypes.c_int, ctypes.c_uint64, ctypes.c_void_p, ctypes.c_int
    ]
    LIBPROC.proc_pidinfo.restype = ctypes.c_int


def rss(pid: int) -> int:
    if LIBPROC is None:
        return 0
    info = ProcTaskInfo()
    returned = LIBPROC.proc_pidinfo(
        pid, 4, 0, ctypes.byref(info), ctypes.sizeof(info)
    )
    return int(info.resident_size) if returned == ctypes.sizeof(info) else 0


def sha256_file(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def pure_powers(text: str) -> dict[str, int]:
    answer: dict[str, int] = {}
    for match in re.finditer(r"(?<![A-Za-z0-9_])(q\d+|k\d+)(?:\^(\d+))?(?![*A-Za-z0-9_])", text):
        token_start = match.start()
        token_end = match.end()
        left = text[token_start - 1] if token_start else ""
        right = text[token_end] if token_end < len(text) else ""
        if left == "*" or right == "*":
            continue
        variable = match.group(1)
        exponent = int(match.group(2) or 1)
        answer[variable] = min(answer.get(variable, exponent), exponent)
    return answer


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--timeout", type=int, default=43200)
    parser.add_argument("--rss-gib", type=float, default=64.0)
    parser.add_argument("--threads", type=int, default=4)
    parser.add_argument("--max-pairs", type=int, default=0)
    parser.add_argument("--metadata", default="msolve_input.json")
    parser.add_argument("--stem", default="landing_746")
    args = parser.parse_args()

    metadata = json.loads((HERE / args.metadata).read_text())
    source = HERE / metadata["input"]
    assert sha256_file(source) == metadata["input_sha256"]
    leading = HERE / f"{args.stem}_leading.out"
    log = HERE / f"{args.stem}_msolve.log"
    result_path = HERE / f"{args.stem}_msolve_result.json"
    leading.write_text("")
    log.write_text("")

    command = [
        "/opt/homebrew/bin/msolve", "-f", str(source), "-o", str(leading),
        "-t", str(args.threads), "-v", "2", "-g", "1", "-l", "2",
        # Only the leading ideal is needed for the irrelevant-power
        # certificate.  Reducing the full Groebner basis can be substantially
        # more expensive and contributes nothing to that implication.
        "-q", "0", "-r", "0", "-s", "20",
        "-m", str(args.max_pairs), "--random-seed", "2026080189",
    ]
    started = time.monotonic()
    peak = 0
    stop_reason = None
    with log.open("w") as log_handle:
        process = subprocess.Popen(
            command,
            text=True,
            stdout=log_handle,
            stderr=subprocess.STDOUT,
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

    elapsed = time.monotonic() - started
    leading_text = leading.read_text(errors="replace")
    powers = pure_powers(leading_text)
    variables = [f"k{i}" for i in range(6)] + [f"q{i}" for i in range(37)]
    complete = returncode == 0 and stop_reason is None
    projective_empty = complete and all(variable in powers for variable in variables)
    payload = {
        "tool": subprocess.run(
            ["/opt/homebrew/bin/msolve", "--version"],
            text=True, capture_output=True, check=True,
        ).stdout.strip(),
        "command": command,
        "input_sha256": metadata["input_sha256"],
        "returncode": returncode,
        "stop_reason": stop_reason,
        "complete": complete,
        "elapsed_seconds": elapsed,
        "peak_rss_bytes": peak,
        "leading_output_sha256": sha256_file(leading),
        "leading_output_bytes": leading.stat().st_size,
        "log_sha256": sha256_file(log),
        "pure_power_variables": powers,
        "all_43_pure_powers": projective_empty,
        "projective_special_fibre_empty": projective_empty,
    }
    result_path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(json.dumps(payload, sort_keys=True), flush=True)


if __name__ == "__main__":
    main()
