#!/usr/bin/env python3
"""Fail-closed future CAS launcher for the sealed r66 Stage-C q0 chart.

By default this is a dry run.  A CAS is started only with the explicit
``--execute`` flag.  Inputs are hash-bound to the preparation manifest, all
outputs must be absent, wall/RSS fences are live, and an unavailable RSS
measurement kills the process group.  Only a completed exact unit sentinel
is promoted; every other outcome is recorded as a nonverdict.
"""

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
STEM = "r66_stageC_q0_1_b0_1"
MANIFEST = HERE / f"{STEM}.json"
MSOLVE_INPUT = HERE / f"{STEM}.ms"
SINGULAR_INPUT = HERE / f"{STEM}.sing"
SINGULAR_RESULT = HERE / f"{STEM}.singular.result.txt"


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


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def rss_bytes(pid: int) -> int | None:
    if LIBPROC is None:
        return None
    info = ProcTaskInfo()
    got = LIBPROC.proc_pidinfo(pid, 4, 0, ctypes.byref(info), ctypes.sizeof(info))
    return int(info.resident_size) if got == ctypes.sizeof(info) else None


def terminate_group(process: subprocess.Popen[bytes]) -> None:
    try:
        os.killpg(process.pid, signal.SIGTERM)
        process.wait(timeout=5)
    except ProcessLookupError:
        return
    except subprocess.TimeoutExpired:
        try:
            os.killpg(process.pid, signal.SIGKILL)
        except ProcessLookupError:
            pass


def exact_write(path: Path, payload: dict) -> None:
    text = json.dumps(payload, indent=2, sort_keys=True) + "\n"
    if path.exists():
        raise SystemExit(f"refusing to overwrite run record {path}")
    path.write_text(text)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--engine", choices=("msolve", "singular"), required=True)
    parser.add_argument("--tag", required=True)
    parser.add_argument("--pair-cap", type=int, default=0)
    parser.add_argument("--threads", type=int, default=4)
    parser.add_argument("--timeout", type=float, default=43200)
    parser.add_argument("--rss-gib", type=float, default=32)
    parser.add_argument("--execute", action="store_true")
    args = parser.parse_args()
    if not re.fullmatch(r"[a-z0-9_]+", args.tag):
        raise SystemExit("tag must contain only lowercase letters, digits, underscores")
    if args.pair_cap < 0:
        raise SystemExit("pair cap must be nonnegative")
    if args.engine == "singular" and args.pair_cap != 0:
        raise SystemExit("pair cap is an msolve-only option")
    if not (1 <= args.threads <= 8):
        raise SystemExit("thread fence is [1,8]")
    if not (1 <= args.timeout <= 43200):
        raise SystemExit("wall fence is [1,43200] seconds")
    if not (0.25 <= args.rss_gib <= 64):
        raise SystemExit("RSS fence is [0.25,64] GiB")

    manifest = json.loads(MANIFEST.read_text())
    if manifest.get("status") != "PREPARED_NOT_RUN" or manifest.get("cas_launched") is not False:
        raise SystemExit("input manifest is not an unlaunched preparation")
    source = MSOLVE_INPUT if args.engine == "msolve" else SINGULAR_INPUT
    source_entry = manifest["inputs"][args.engine]
    if source.name != source_entry["file"] or sha256_file(source) != source_entry["sha256"]:
        raise SystemExit("source/manifest hash binding failed")

    suffix = f".{args.engine}.{args.tag}"
    log = HERE / f"{STEM}{suffix}.log"
    record = HERE / f"{STEM}{suffix}.run.json"
    if args.engine == "msolve":
        result = HERE / f"{STEM}{suffix}.result.txt"
        command = [
            "/opt/homebrew/bin/msolve", "-f", str(source), "-o", str(result),
            "-t", str(args.threads), "-v", "2", "-g", "1", "-l", "2",
            "-q", "0", "-r", "0", "-s", "20", "-m", str(args.pair_cap),
            "--random-seed", "2026080189",
        ]
    else:
        result = SINGULAR_RESULT
        command = [
            "/opt/homebrew/bin/Singular", "-q", "--no-shell",
            f"--threads={args.threads}", str(source),
        ]
    occupied = [path.name for path in (log, record, result) if path.exists()]
    if occupied:
        raise SystemExit(f"refusing stale/overwriting outputs: {occupied}")

    dry_payload = {
        "status": "DRY_RUN_NO_CAS",
        "command": command,
        "input": source.name,
        "input_sha256": sha256_file(source),
        "engine": args.engine,
        "pair_cap": args.pair_cap,
        "threads": args.threads,
        "timeout_seconds": args.timeout,
        "rss_limit_bytes": int(args.rss_gib * (1 << 30)),
        "would_write": [log.name, result.name, record.name],
        "scope_guard": "one D(q0), b0=1 selected necessary-equation chart only",
    }
    if not args.execute:
        print(json.dumps(dry_payload, sort_keys=True))
        return

    peak = 0
    stop_reason: str | None = None
    started = time.monotonic()
    with log.open("wb") as output:
        process = subprocess.Popen(
            command, cwd=HERE, stdout=output, stderr=subprocess.STDOUT,
            start_new_session=True,
        )
        while process.poll() is None:
            observed = rss_bytes(process.pid)
            if observed is None:
                stop_reason = "rss_poll_unavailable"
            else:
                peak = max(peak, observed)
            elapsed = time.monotonic() - started
            if stop_reason is None and peak >= args.rss_gib * (1 << 30):
                stop_reason = "rss_limit"
            if stop_reason is None and elapsed >= args.timeout:
                stop_reason = "timeout"
            if stop_reason is not None:
                terminate_group(process)
                break
            time.sleep(0.1)
        returncode = process.wait()
    elapsed = time.monotonic() - started

    result_text = result.read_text(errors="replace") if result.exists() else ""
    complete = returncode == 0 and stop_reason is None and bool(result_text.strip())
    unit = False
    parsed_result: dict[str, object] = {}
    if args.engine == "msolve" and complete:
        final_line = next((line.strip() for line in reversed(result_text.splitlines()) if line.strip()), "")
        unit = final_line in {"[1]", "[1]:", "[-1]", "[-1]:"}
        parsed_result = {"final_nonempty_line": final_line}
    elif args.engine == "singular" and complete:
        match = re.fullmatch(
            r"R66_STAGEC_Q0_COMPLETE unit=([01]),dim=(-?\d+),std_gens=(\d+),elapsed_ms=(\d+)\s*",
            result_text,
        )
        if match:
            parsed_result = {
                "unit": int(match.group(1)), "dimension": int(match.group(2)),
                "standard_basis_generators": int(match.group(3)),
                "singular_elapsed_ms": int(match.group(4)),
            }
            unit = parsed_result["unit"] == 1 and parsed_result["dimension"] == -1

    payload = {
        **dry_payload,
        "status": "PASS_EXACT_ONE_CHART_EMPTY" if unit else "BOUNDED_NONVERDICT",
        "elapsed_seconds": elapsed,
        "peak_rss_bytes": peak,
        "returncode": returncode,
        "stop_reason": stop_reason,
        "complete": complete,
        "unit_ideal": unit,
        "result_exists": result.exists(),
        "result_bytes": result.stat().st_size if result.exists() else 0,
        "result_sha256": sha256_file(result) if result.exists() else None,
        "log_bytes": log.stat().st_size,
        "log_sha256": sha256_file(log),
        "parsed_result": parsed_result,
        "scope_guard": (
            "Unit proves emptiness of only this selected affine chart. A complete "
            "nonunit, timeout, RSS stop, crash, parser failure, or missing result is a nonverdict."
        ),
    }
    exact_write(record, payload)
    print(json.dumps(payload, sort_keys=True))


if __name__ == "__main__":
    main()

