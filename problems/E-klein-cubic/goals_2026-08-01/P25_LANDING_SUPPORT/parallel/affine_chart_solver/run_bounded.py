#!/usr/bin/env python3
"""Run one local Singular input with hard wall-clock and RSS fences."""

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
    LIBPROC.proc_pidinfo.argtypes = [
        ctypes.c_int, ctypes.c_int, ctypes.c_uint64, ctypes.c_void_p, ctypes.c_int
    ]
    LIBPROC.proc_pidinfo.restype = ctypes.c_int


def rss(pid: int) -> int:
    if LIBPROC is None:
        return 0
    info = ProcTaskInfo()
    got = LIBPROC.proc_pidinfo(pid, 4, 0, ctypes.byref(info), ctypes.sizeof(info))
    return int(info.resident_size) if got == ctypes.sizeof(info) else 0


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("input")
    parser.add_argument("--timeout", type=float, default=600.0)
    parser.add_argument("--rss-gib", type=float, default=8.0)
    args = parser.parse_args()
    if not (0 < args.timeout <= 600):
        raise SystemExit("this worker is fenced to at most 600 seconds")
    if not (0 < args.rss_gib <= 8):
        raise SystemExit("this worker is fenced to at most 8 GiB")
    source = Path(args.input).resolve()
    if source.parent != HERE or source.suffix != ".sing" or not source.is_file():
        raise SystemExit("input must be a .sing file in this worker directory")

    log = HERE / f"{source.stem}.log"
    record = HERE / f"{source.stem}.run.json"
    command = ["/opt/homebrew/bin/Singular", "-q", str(source)]
    started = time.monotonic()
    peak = 0
    stop_reason = None
    with log.open("w") as output:
        process = subprocess.Popen(
            command, stdout=output, stderr=subprocess.STDOUT, start_new_session=True
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
            time.sleep(0.05)
        returncode = process.wait()
    payload = {
        "command": command,
        "input": source.name,
        "input_sha256": sha256_file(source),
        "input_bytes": source.stat().st_size,
        "elapsed_seconds": round(time.monotonic() - started, 6),
        "peak_rss_bytes_polled": peak,
        "rss_limit_bytes": int(args.rss_gib * 1024**3),
        "timeout_seconds": args.timeout,
        "returncode": returncode,
        "stop_reason": stop_reason,
        "complete": returncode == 0 and stop_reason is None,
        "log": log.name,
        "log_sha256": sha256_file(log),
        "log_bytes": log.stat().st_size,
    }
    record.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(json.dumps(payload, sort_keys=True), flush=True)


if __name__ == "__main__":
    main()
