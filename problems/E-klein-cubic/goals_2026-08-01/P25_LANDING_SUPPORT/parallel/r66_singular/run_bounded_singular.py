#!/usr/bin/env python3
"""Fail-closed runner for one prepared local Singular job.

This file is preparation only.  The producer and verifier never import it and
never launch Singular.
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
    LIBPROC.proc_pidinfo.argtypes = [ctypes.c_int, ctypes.c_int, ctypes.c_uint64, ctypes.c_void_p, ctypes.c_int]
    LIBPROC.proc_pidinfo.restype = ctypes.c_int


def rss(pid: int) -> int | None:
    if LIBPROC is None:
        return None
    info = ProcTaskInfo()
    got = LIBPROC.proc_pidinfo(pid, 4, 0, ctypes.byref(info), ctypes.sizeof(info))
    return int(info.resident_size) if got == ctypes.sizeof(info) else None


def alive_or_uncheckable(pid: int) -> bool:
    try:
        os.kill(pid, 0)
        return True
    except ProcessLookupError:
        return False
    except (PermissionError, OSError):
        return True


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("job")
    parser.add_argument("--timeout", type=float, default=7200.0)
    parser.add_argument("--rss-gib", type=float, default=4.0)
    parser.add_argument("--shared-pid", type=int, default=13036)
    args = parser.parse_args()
    if not (0 < args.timeout <= 43200):
        raise SystemExit("timeout must lie in (0,43200]")
    if not (0 < args.rss_gib <= 6):
        raise SystemExit("RSS fence must lie in (0,6] GiB")
    if args.shared_pid > 0 and alive_or_uncheckable(args.shared_pid):
        raise SystemExit(f"refusing launch while shared PID {args.shared_pid} is alive or uncheckable")
    source = Path(args.job).resolve()
    if source.parent != HERE or source.suffix != ".sing" or not source.is_file():
        raise SystemExit("job must be a prepared .sing file in this directory")
    manifest = json.loads((HERE / "jobs_manifest.json").read_text())
    entry = manifest["jobs"].get(source.name)
    if entry is None:
        prepared = json.loads((HERE / "preconditioned_manifest.json").read_text())
        candidate = prepared["job"]
        if candidate["file"] == source.name:
            entry = candidate
    if entry is None or entry["sha256"] != sha256(source):
        raise SystemExit("job is absent from or mismatches the immutable manifest")

    log = HERE / f"{source.stem}.log"
    record = HERE / f"{source.stem}.run.json"
    if log.exists() or record.exists():
        raise SystemExit("refusing to overwrite an existing run artifact")
    command = ["/opt/homebrew/bin/Singular", "-q", str(source)]
    started = time.monotonic()
    peak = 0
    stop_reason = None
    with log.open("x") as output:
        process = subprocess.Popen(command, cwd=HERE, stdout=output, stderr=subprocess.STDOUT, start_new_session=True)
        while process.poll() is None:
            current = rss(process.pid)
            if current is None:
                stop_reason = "rss_poll_unavailable"
                os.killpg(process.pid, signal.SIGKILL)
                break
            peak = max(peak, current)
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
        "status": "COMPLETED_PENDING_RESULT_AUDIT" if returncode == 0 and stop_reason is None else "BOUNDED_NONVERDICT",
        "command": command,
        "input": source.name,
        "input_sha256": sha256(source),
        "elapsed_seconds": round(time.monotonic() - started, 6),
        "peak_rss_bytes_polled": peak,
        "rss_limit_bytes": int(args.rss_gib * 1024**3),
        "timeout_seconds": args.timeout,
        "returncode": returncode,
        "stop_reason": stop_reason,
        "log": log.name,
        "log_sha256": sha256(log),
        "scope_guard": "Only an independently audited unit/full result is decisive; every stop is a nonverdict.",
    }
    record.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(json.dumps(payload, sort_keys=True), flush=True)


if __name__ == "__main__":
    main()
