#!/usr/bin/env python3
"""Run the immutable local msolve input with hard wall/RSS fences."""

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


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--timeout", type=float, default=600.0)
    parser.add_argument("--rss-gib", type=float, default=8.0)
    parser.add_argument("--threads", type=int, default=4)
    args = parser.parse_args()
    manifest_path = HERE / "affine_q0_b1_0_all690.json"
    manifest = json.loads(manifest_path.read_text())
    source = HERE / manifest["input"]["file"]
    if sha256(source) != manifest["input"]["sha256"]:
        raise RuntimeError("immutable msolve input hash mismatch")
    leading = HERE / "affine_q0_b1_0_all690.leading"
    log = HERE / "affine_q0_b1_0_all690.log"
    record = HERE / "affine_q0_b1_0_all690.run.json"
    existing = [path.name for path in (leading, log, record) if path.exists()]
    if existing:
        raise SystemExit(f"refusing to overwrite immutable run artifacts: {existing}")
    command = [
        "/opt/homebrew/bin/msolve", "-f", str(source), "-o", str(leading),
        "-t", str(args.threads), "-v", "2", "-g", "1", "-l", "2",
        "-q", "0", "-r", "0", "-s", "20", "-m", "0",
        "--random-seed", "2026080189",
    ]
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
    elapsed = time.monotonic() - started
    leading_text = leading.read_text(errors="replace") if leading.exists() else ""
    complete = returncode == 0 and stop_reason is None and bool(leading_text.strip())
    unit_ideal = complete and leading_text.rstrip().endswith("[1]:")
    payload = {
        "tool": subprocess.run(
            ["/opt/homebrew/bin/msolve", "--version"],
            text=True, capture_output=True, check=True,
        ).stdout.strip(),
        "command": command,
        "input": source.name,
        "input_sha256": sha256(source),
        "elapsed_seconds": round(elapsed, 6),
        "peak_rss_bytes_polled": peak,
        "rss_limit_bytes": int(args.rss_gib * 1024**3),
        "timeout_seconds": args.timeout,
        "returncode": returncode,
        "stop_reason": stop_reason,
        "complete": complete,
        "unit_ideal": unit_ideal,
        "chart_empty": unit_ideal,
        "leading": leading.name,
        "leading_sha256": sha256(leading) if leading.exists() else None,
        "leading_bytes": leading.stat().st_size if leading.exists() else 0,
        "log": log.name,
        "log_sha256": sha256(log),
        "log_bytes": log.stat().st_size,
        "scope": "Only the chart q0=1,b1_0=1; never a global Stage-B verdict.",
    }
    record.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(json.dumps(payload, sort_keys=True), flush=True)


if __name__ == "__main__":
    main()

