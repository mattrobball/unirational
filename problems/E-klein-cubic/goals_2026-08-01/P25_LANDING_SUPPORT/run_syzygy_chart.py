#!/usr/bin/env python3
"""Run one exact syzygy-incidence chart with explicit resource fencing."""

from __future__ import annotations

import argparse
import ctypes
import hashlib
import json
import os
from pathlib import Path
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


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("input")
    parser.add_argument("--timeout", type=int, default=3600)
    parser.add_argument("--memory-gib", type=float, default=48.0)
    parser.add_argument("--threads", type=int, default=8)
    parser.add_argument("--max-pairs", type=int, default=256)
    parser.add_argument("--linear-algebra", type=int, choices=(1, 2), default=2)
    parser.add_argument("--full-basis", action="store_true")
    args = parser.parse_args()

    source = (HERE / args.input).resolve()
    if source.parent != HERE or not source.is_file():
        raise SystemExit("input must name a file inside P25_LANDING_SUPPORT")
    stem = source.stem + f"_m{args.max_pairs}_l{args.linear_algebra}"
    answer = HERE / f"{stem}.out"
    log = HERE / f"{stem}.log"
    result_path = HERE / f"{stem}.result.json"
    answer.write_text("")
    log.write_text("")
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
        "2" if args.full_basis else "1",
        "-l",
        str(args.linear_algebra),
        "-m",
        str(args.max_pairs),
        "--random-seed",
        "2026080127",
    ]
    memory_limit = int(args.memory_gib * 1024**3)
    started = time.monotonic()
    peak = 0
    stop_reason = None
    process: subprocess.Popen[str] | None = None
    try:
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
                if peak >= memory_limit:
                    stop_reason = "memory"
                    os.killpg(process.pid, signal.SIGKILL)
                    break
                if elapsed >= args.timeout:
                    stop_reason = "timeout"
                    os.killpg(process.pid, signal.SIGKILL)
                    break
                time.sleep(0.10)
            returncode = process.wait()
    except KeyboardInterrupt:
        stop_reason = "interrupt"
        if process is not None and process.poll() is None:
            os.killpg(process.pid, signal.SIGKILL)
            process.wait()
        raise

    output = answer.read_text(errors="replace")
    normalized = "".join(output.split())
    complete = returncode == 0 and stop_reason is None
    unit_output = complete and normalized in {"[-1]:", "[-1]", "[1]:", "[1]"}
    payload = {
        "tool": subprocess.run(
            [MSOLVE, "--version"], text=True, capture_output=True, check=True
        ).stdout.strip(),
        "command": command,
        "input": source.name,
        "input_sha256": sha256(source),
        "input_bytes": source.stat().st_size,
        "output": answer.name,
        "output_sha256": sha256(answer),
        "output_bytes": answer.stat().st_size,
        "log": log.name,
        "log_sha256": sha256(log),
        "returncode": returncode,
        "stop_reason": stop_reason,
        "complete": complete,
        "unit_output_discovery_only": unit_output,
        "accepted_certificate": False,
        "accepted_certificate_note": (
            "A solver unit/empty output is discovery only. Acceptance requires an "
            "independent replay plus an explicit unit or irrelevant-power certificate."
        ),
        "elapsed_seconds": round(time.monotonic() - started, 6),
        "peak_rss_bytes": peak,
        "memory_limit_bytes": memory_limit,
    }
    result_path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(json.dumps(payload, sort_keys=True), flush=True)


if __name__ == "__main__":
    main()
