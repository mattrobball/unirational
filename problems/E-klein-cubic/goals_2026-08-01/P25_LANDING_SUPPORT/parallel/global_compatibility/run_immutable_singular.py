#!/usr/bin/env python3
"""Run one local immutable Singular input with wall/RSS fences.

The runner refuses to overwrite a result, log, or run record.  Archive those
files explicitly before a deliberate rerun.
"""

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


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def local_file(raw: str, suffix: str | None = None) -> Path:
    path = (HERE / raw).resolve()
    if path.parent != HERE or (suffix is not None and path.suffix != suffix):
        raise SystemExit(f"path must be a local {suffix or 'file'}: {raw}")
    return path


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("script")
    parser.add_argument("result")
    parser.add_argument("--timeout", type=float, default=43200.0)
    parser.add_argument("--rss-gib", type=float, default=16.0)
    args = parser.parse_args()
    script = local_file(args.script, ".sing")
    result = local_file(args.result)
    if not script.is_file():
        raise FileNotFoundError(script)
    log = HERE / f"{script.stem}.log"
    record = HERE / f"{script.stem}.run.json"
    existing = [path.name for path in (result, log, record) if path.exists()]
    if existing:
        raise SystemExit(f"refusing to overwrite immutable run artifacts: {existing}")

    command = ["/opt/homebrew/bin/Singular", "-q", str(script)]
    started = time.monotonic()
    peak = 0
    stop_reason = None
    with log.open("x") as output:
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
            time.sleep(0.1)
        returncode = process.wait()
    payload = {
        "command": command,
        "input": script.name,
        "input_sha256": sha256(script),
        "input_bytes": script.stat().st_size,
        "elapsed_seconds": round(time.monotonic() - started, 6),
        "peak_rss_bytes_polled": peak,
        "rss_limit_bytes": int(args.rss_gib * 1024**3),
        "timeout_seconds": args.timeout,
        "returncode": returncode,
        "stop_reason": stop_reason,
        "complete": returncode == 0 and stop_reason is None and result.is_file(),
        "result": result.name,
        "result_sha256": sha256(result) if result.is_file() else None,
        "log": log.name,
        "log_sha256": sha256(log),
        "log_bytes": log.stat().st_size,
    }
    record.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(json.dumps(payload, sort_keys=True), flush=True)


if __name__ == "__main__":
    main()

