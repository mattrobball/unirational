#!/usr/bin/env python3
"""Run one local CAS preflight with a hard wall/RSS fence and JSON record."""

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
    LIBPROC.proc_pidinfo.argtypes = [ctypes.c_int, ctypes.c_int, ctypes.c_uint64, ctypes.c_void_p, ctypes.c_int]
    LIBPROC.proc_pidinfo.restype = ctypes.c_int


def rss(pid: int) -> int:
    if LIBPROC is None:
        return 0
    info = ProcTaskInfo()
    got = LIBPROC.proc_pidinfo(pid, 4, 0, ctypes.byref(info), ctypes.sizeof(info))
    return int(info.resident_size) if got == ctypes.sizeof(info) else 0


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("input")
    parser.add_argument("--engine", choices=("singular", "msolve"), default="singular")
    parser.add_argument("--timeout", type=float, default=60.0)
    parser.add_argument("--rss-gib", type=float, default=3.5)
    args = parser.parse_args()
    raw = Path(args.input)
    source = (HERE / raw).resolve() if not raw.is_absolute() else raw.resolve()
    expected_suffix = ".sing" if args.engine == "singular" else ".ms"
    if source.suffix != expected_suffix or not source.is_file():
        raise SystemExit(f"input must be an existing {expected_suffix} file")
    stem = source.stem
    log = HERE / f"{stem}.log"
    record = HERE / f"{stem}.run.json"
    if args.engine == "singular":
        command = ["/opt/homebrew/bin/Singular", "-q", str(source)]
    else:
        answer = HERE / f"{stem}.msolve.out"
        command = [
            "/opt/homebrew/bin/msolve", "-f", str(source), "-o", str(answer),
            "-t", "4", "-v", "2", "-g", "1", "-l", "2", "-m", "256",
            "--random-seed", "2026080131",
        ]
    started = time.monotonic()
    peak = 0
    stop_reason = None
    with log.open("w") as output:
        process = subprocess.Popen(command, stdout=output, stderr=subprocess.STDOUT, start_new_session=True)
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
            time.sleep(0.05)
        returncode = process.wait()
    elapsed = time.monotonic() - started
    payload = {
        "command": command,
        "engine": args.engine,
        "input": source.name,
        "input_sha256": sha256(source),
        "input_bytes": source.stat().st_size,
        "elapsed_seconds": round(elapsed, 6),
        "peak_rss_bytes_polled": peak,
        "rss_limit_bytes": int(args.rss_gib * 1024**3),
        "timeout_seconds": args.timeout,
        "returncode": returncode,
        "stop_reason": stop_reason,
        "complete": returncode == 0 and stop_reason is None,
        "log": log.name,
        "log_sha256": sha256(log),
        "log_bytes": log.stat().st_size,
    }
    record.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(json.dumps(payload, sort_keys=True), flush=True)


if __name__ == "__main__":
    main()
