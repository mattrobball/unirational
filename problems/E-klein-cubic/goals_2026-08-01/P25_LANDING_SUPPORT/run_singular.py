#!/usr/bin/env python3
"""Run one exact Singular saturation with time/RSS fencing and a result seal."""

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
SINGULAR = "/opt/homebrew/bin/Singular"


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
    returned = LIBPROC.proc_pidinfo(pid, 4, 0, ctypes.byref(info), ctypes.sizeof(info))
    return int(info.resident_size) if returned == ctypes.sizeof(info) else 0


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(2**20):
            digest.update(block)
    return digest.hexdigest()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("script")
    parser.add_argument("result")
    parser.add_argument("--stem", required=True)
    parser.add_argument("--timeout", type=int, default=43200)
    parser.add_argument("--rss-gib", type=float, default=64.0)
    args = parser.parse_args()

    script = (HERE / args.script).resolve()
    result = (HERE / args.result).resolve()
    if script.parent != HERE or result.parent != HERE or not script.is_file():
        raise SystemExit("script and result must be files inside this packet")
    log = HERE / f"{args.stem}.log"
    report = HERE / f"{args.stem}.json"
    result.unlink(missing_ok=True)
    log.write_text("")
    command = [SINGULAR, "-q", str(script)]
    started = time.monotonic()
    peak = 0
    stop_reason = None
    process: subprocess.Popen[str] | None = None
    try:
        with log.open("w") as handle:
            process = subprocess.Popen(
                command, text=True, stdout=handle, stderr=subprocess.STDOUT,
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

    complete = returncode == 0 and stop_reason is None and result.is_file()
    result_text = result.read_text(errors="replace") if result.is_file() else ""
    unit = complete and result_text.startswith(("unit=true", "unit=1"))
    payload = {
        "tool": subprocess.run(
            [SINGULAR, "--version"], text=True, capture_output=True, check=True
        ).stdout.splitlines()[0],
        "command": command,
        "script_sha256": sha256(script),
        "returncode": returncode,
        "stop_reason": stop_reason,
        "complete": complete,
        "saturated_unit_ideal": unit,
        "elapsed_seconds": time.monotonic() - started,
        "peak_rss_bytes": peak,
        "result_sha256": sha256(result) if result.is_file() else None,
        "log_sha256": sha256(log),
    }
    report.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(json.dumps(payload, sort_keys=True), flush=True)


if __name__ == "__main__":
    main()
