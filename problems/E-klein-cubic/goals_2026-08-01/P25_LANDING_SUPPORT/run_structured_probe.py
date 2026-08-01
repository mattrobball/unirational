#!/usr/bin/env python3
"""Run one exact homogeneous msolve probe with explicit resource bounds."""

from __future__ import annotations

import argparse
import ctypes
import hashlib
import json
import os
from pathlib import Path
import re
import signal
import subprocess
import sys
import time


HERE = Path(__file__).resolve().parent
MSOLVE = "/opt/homebrew/bin/msolve"


class ProcTaskInfo(ctypes.Structure):
    _fields_ = [
        ("virtual_size", ctypes.c_uint64),
        ("resident_size", ctypes.c_uint64),
        ("total_user", ctypes.c_uint64),
        ("total_system", ctypes.c_uint64),
        ("threads_user", ctypes.c_uint64),
        ("threads_system", ctypes.c_uint64),
        ("policy", ctypes.c_int32),
        ("faults", ctypes.c_int32),
        ("pageins", ctypes.c_int32),
        ("cow_faults", ctypes.c_int32),
        ("messages_sent", ctypes.c_int32),
        ("messages_received", ctypes.c_int32),
        ("syscalls_mach", ctypes.c_int32),
        ("syscalls_unix", ctypes.c_int32),
        ("context_switches", ctypes.c_int32),
        ("thread_count", ctypes.c_int32),
        ("running_threads", ctypes.c_int32),
        ("priority", ctypes.c_int32),
    ]


LIBPROC = ctypes.CDLL("/usr/lib/libproc.dylib") if sys.platform == "darwin" else None
if LIBPROC is not None:
    LIBPROC.proc_pidinfo.argtypes = [
        ctypes.c_int,
        ctypes.c_int,
        ctypes.c_uint64,
        ctypes.c_void_p,
        ctypes.c_int,
    ]
    LIBPROC.proc_pidinfo.restype = ctypes.c_int


def rss(pid: int) -> int:
    if LIBPROC is None:
        return 0
    info = ProcTaskInfo()
    returned = LIBPROC.proc_pidinfo(pid, 4, 0, ctypes.byref(info), ctypes.sizeof(info))
    return int(info.resident_size) if returned == ctypes.sizeof(info) else 0


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def pure_power_variables(output: str) -> dict[str, int]:
    """Extract pure monomial generators from msolve's leading-ideal output."""
    if "[" not in output or "]" not in output:
        return {}
    body = output[output.index("[") + 1 : output.rindex("]")]
    answer: dict[str, int] = {}
    for raw in body.split(","):
        expression = raw.strip()
        match = re.fullmatch(r"([qk]\d+)(?:\^(\d+))?", expression)
        if match:
            answer[match.group(1)] = int(match.group(2) or 1)
    return answer


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--size", type=int, choices=(96, 128, 160, 192, 256), default=128)
    parser.add_argument("--timeout", type=int, default=1800)
    parser.add_argument("--memory-gib", type=float, default=32.0)
    parser.add_argument("--max-pairs", type=int, default=512)
    parser.add_argument("--threads", type=int, default=8)
    parser.add_argument("--linear-algebra", type=int, choices=(1, 2), default=2)
    args = parser.parse_args()

    metadata = json.loads((HERE / "probe_metadata.json").read_text())
    record = next(item for item in metadata["probes"] if item["equations"] == args.size)
    source = HERE / record["input"]
    assert sha256(source) == record["sha256"]

    stem = f"probe_{args.size:03d}_m{args.max_pairs}_l{args.linear_algebra}"
    answer = HERE / f"{stem}.leading.out"
    log = HERE / f"{stem}.log"
    result_path = HERE / f"{stem}.result.json"
    answer.write_text("")
    command = [
        MSOLVE,
        "-f",
        str(source),
        "-o",
        str(answer),
        "-t",
        str(args.threads),
        "-v",
        "2",
        "-g",
        "1",
        "-l",
        str(args.linear_algebra),
        "-m",
        str(args.max_pairs),
        "--random-seed",
        "2026080125",
    ]
    memory_limit = int(args.memory_gib * 1024**3)
    started = time.monotonic()
    process = subprocess.Popen(
        command,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        start_new_session=True,
    )
    peak = 0
    stop_reason = None
    chunks: list[str] = []
    while process.poll() is None:
        peak = max(peak, rss(process.pid))
        elapsed = time.monotonic() - started
        if peak >= memory_limit:
            stop_reason = "memory"
            os.killpg(process.pid, signal.SIGKILL)
            break
        if elapsed >= args.timeout:
            stop_reason = "timeout"
            os.killpg(process.pid, signal.SIGKILL)
            break
        time.sleep(0.10)
    stdout, _ = process.communicate()
    chunks.append(stdout)
    log.write_text("".join(chunks))
    leading = answer.read_text() if answer.exists() else ""
    powers = pure_power_variables(leading)
    variables = metadata["variable_order"]
    complete = process.returncode == 0 and stop_reason is None
    artinian = complete and all(variable in powers for variable in variables)
    result = {
        "tool": subprocess.run(
            [MSOLVE, "--version"], text=True, capture_output=True, check=True
        ).stdout.strip(),
        "command": command,
        "input": source.name,
        "input_sha256": record["sha256"],
        "equations": args.size,
        "monic_K3_rules": record["monic_K3_rules"],
        "residual_rows": record["residual_rows"],
        "threads": args.threads,
        "max_pairs_per_matrix": args.max_pairs,
        "linear_algebra": args.linear_algebra,
        "timeout_seconds": args.timeout,
        "memory_limit_bytes": memory_limit,
        "seconds": round(time.monotonic() - started, 6),
        "peak_rss_bytes_polled": peak,
        "returncode": process.returncode,
        "stop_reason": stop_reason,
        "complete": complete,
        "leading_output_bytes": len(leading.encode()),
        "leading_output_sha256": sha256(answer) if answer.exists() else None,
        "log_sha256": sha256(log),
        "pure_power_variables": powers,
        "all_43_pure_powers": artinian,
        "projective_probe_empty": artinian,
        "complete_landing_empty_consequence": artinian,
        "scope": (
            "A complete Artinian leading ideal proves the homogeneous probe has only "
            "the affine origin and hence empty Proj. Timeout, crash, or non-Artinian "
            "completion is inconclusive."
        ),
    }
    result_path.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    print(json.dumps(result, sort_keys=True), flush=True)
    if artinian:
        print("P25_STRUCTURED_SUBSYSTEM_PROJECTIVELY_EMPTY", flush=True)
    elif not complete:
        print("P25_STRUCTURED_PROBE_INCOMPLETE", flush=True)
    else:
        print("P25_STRUCTURED_PROBE_NONARTINIAN", flush=True)


if __name__ == "__main__":
    main()
