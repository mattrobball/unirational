#!/usr/bin/env python3
"""Audit or explicitly launch one immutable global PC.2 module job.

The sealed Singular inputs live in the read-only historical packet and contain
hard-coded result paths in that packet.  This runner first verifies the exact
historical SHA-256/size/shape guards.  With no ``--run`` flag it performs no
writes.  An explicit run streams a path-patched copy into this writable packet,
then executes Singular under wall-clock and sampled-RSS fences.

A completed ``dim(S^7/N)=0`` output is an exact CAS discovery result.  For a
transparent final certificate, independently rerun the immutable input or
extract and verify a polynomial lift/standard-basis witness.  Every timeout,
RSS stop, crash, missing result, or positive dimension is a nonverdict.
"""

from __future__ import annotations

import argparse
import ctypes
from datetime import datetime, timezone
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
PROBLEM_ROOT = HERE.parent.parent
HISTORICAL = (
    PROBLEM_ROOT
    / "goals_2026-08-01"
    / "P25_LANDING_SUPPORT"
    / "parallel"
    / "enlarged_closure"
)
SINGULAR = Path("/opt/homebrew/bin/Singular")

JOBS = {
    "r43": {
        "source": HISTORICAL / "augmented_r43_p4_p3_module.sing",
        "bytes": 72_308_419,
        "sha256": "64bbcca64a403676c7e0204f992ab543da420be6e7efd5453ec94b4587d54ebe",
        "rows": 43,
        "terms": 1_571_280 + 2_936_758,
        "old_result": HISTORICAL / "augmented_r43_p4_p3_module_result.txt",
    },
    "r64": {
        "source": HISTORICAL / "augmented_r64_p4_p3_module.sing",
        "bytes": 104_646_907,
        "sha256": "51eb2699740375a6bedf6db7529254a430d1c714e66cbe314518406a696eb809",
        "rows": 64,
        "terms": 2_254_680 + 4_265_696,
        "old_result": HISTORICAL / "augmented_r64_p4_p3_module_result.txt",
    },
}

MAX_TIMEOUT_SECONDS = 7_200.0
MAX_RSS_GIB = 32.0
LARGE_TIMEOUT_SECONDS = 600.0
LARGE_RSS_GIB = 8.0


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


def rss_bytes(pid: int) -> int:
    """Return sampled resident bytes for the Singular process on macOS."""
    if LIBPROC is None:
        return 0
    info = ProcTaskInfo()
    got = LIBPROC.proc_pidinfo(pid, 4, 0, ctypes.byref(info), ctypes.sizeof(info))
    return int(info.resident_size) if got == ctypes.sizeof(info) else 0


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def audit_source(label: str) -> dict[str, object]:
    job = JOBS[label]
    source = Path(job["source"])
    if not source.is_file():
        raise SystemExit(f"missing immutable source: {source}")
    size = source.stat().st_size
    digest = sha256_file(source)
    if size != job["bytes"] or digest != job["sha256"]:
        raise SystemExit(
            f"immutable {label} source mismatch: bytes={size}, sha256={digest}"
        )

    line_count = 0
    guards = {
        b"ring R=89,(q0,q1,q2": False,
        b"module N=": False,
        b"module G=std(N)": False,
        b"int d=dim(G); int decisive=(d==0);": False,
    }
    old_result = str(job["old_result"]).encode()
    old_result_occurrences = 0
    with source.open("rb") as handle:
        for line in handle:
            line_count += 1
            old_result_occurrences += line.count(old_result)
            for needle in guards:
                if needle in line:
                    guards[needle] = True
    expected_lines = int(job["rows"]) + 9
    if line_count != expected_lines:
        raise SystemExit(
            f"unexpected {label} line count: {line_count} != {expected_lines}"
        )
    if not all(guards.values()) or old_result_occurrences != 1:
        raise SystemExit(
            f"{label} semantic/footer guard failed: guards={guards}, "
            f"result_occurrences={old_result_occurrences}"
        )
    return {
        "label": label,
        "source": str(source),
        "source_bytes": size,
        "source_sha256": digest,
        "rows": int(job["rows"]),
        "nonzero_terms": int(job["terms"]),
        "line_count": line_count,
        "semantic_guards": True,
        "historical_result_exists": Path(job["old_result"]).exists(),
    }


def stream_path_patched_copy(label: str, destination: Path, result: Path) -> int:
    job = JOBS[label]
    old = str(job["old_result"]).encode()
    new = str(result.resolve()).encode()
    temporary = destination.with_suffix(destination.suffix + ".partial")
    if destination.exists() or temporary.exists() or result.exists():
        raise SystemExit("refusing to overwrite an existing run artifact")
    replacements = 0
    try:
        with Path(job["source"]).open("rb") as source, temporary.open("xb") as target:
            for line in source:
                replacements += line.count(old)
                target.write(line.replace(old, new))
        if replacements != 1:
            raise RuntimeError(f"expected one result-path replacement, got {replacements}")
        os.replace(temporary, destination)
    except BaseException:
        if temporary.exists():
            temporary.unlink()
        raise
    return replacements


def parse_result(path: Path) -> dict[str, int] | None:
    if not path.is_file():
        return None
    match = re.fullmatch(
        r"decisive=(-?\d+),dim=(-?\d+),std_gens=(-?\d+),elapsed_ms=(-?\d+)\s*",
        path.read_text(),
    )
    if match is None:
        return None
    keys = ("decisive", "dim", "std_gens", "elapsed_ms")
    return {key: int(value) for key, value in zip(keys, match.groups())}


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("label", choices=tuple(JOBS))
    parser.add_argument("--run", action="store_true", help="actually launch Singular")
    parser.add_argument("--timeout", type=float, default=LARGE_TIMEOUT_SECONDS)
    parser.add_argument("--rss-gib", type=float, default=LARGE_RSS_GIB)
    parser.add_argument(
        "--acknowledge-large",
        action="store_true",
        help="required above 10 minutes or 8 GiB",
    )
    parser.add_argument(
        "--run-id",
        default=datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ"),
    )
    args = parser.parse_args()

    if not re.fullmatch(r"[A-Za-z0-9_.-]+", args.run_id):
        raise SystemExit("run-id may contain only letters, digits, dot, underscore, hyphen")
    if not (0 < args.timeout <= MAX_TIMEOUT_SECONDS):
        raise SystemExit(f"timeout must lie in (0,{MAX_TIMEOUT_SECONDS}]")
    if not (0 < args.rss_gib <= MAX_RSS_GIB):
        raise SystemExit(f"rss-gib must lie in (0,{MAX_RSS_GIB}]")
    if (
        args.timeout > LARGE_TIMEOUT_SECONDS or args.rss_gib > LARGE_RSS_GIB
    ) and not args.acknowledge_large:
        raise SystemExit(
            "settings above 600 seconds or 8 GiB require --acknowledge-large"
        )

    audit = audit_source(args.label)
    plan = {
        **audit,
        "run_requested": bool(args.run),
        "timeout_seconds": args.timeout,
        "rss_limit_bytes": int(args.rss_gib * 1024**3),
        "criterion": "dim(S^7/N)=0",
        "nonverdicts": "positive dimension, timeout, RSS stop, crash, or missing output",
    }
    if not args.run:
        print(json.dumps(plan, indent=2, sort_keys=True))
        print("AUDIT_ONLY_NO_SINGULAR_LAUNCHED")
        return
    if not SINGULAR.is_file():
        raise SystemExit(f"Singular executable missing: {SINGULAR}")

    stem = f"pc2_global_{args.label}_{args.run_id}"
    source_copy = HERE / f"{stem}.sing"
    result = HERE / f"{stem}_result.txt"
    log = HERE / f"{stem}.log"
    record = HERE / f"{stem}.run.json"
    if any(path.exists() for path in (source_copy, result, log, record)):
        raise SystemExit("refusing to overwrite an existing run id")
    replacements = stream_path_patched_copy(args.label, source_copy, result)
    local_hash = sha256_file(source_copy)

    command = [str(SINGULAR), "-q", str(source_copy)]
    started = time.monotonic()
    peak = 0
    stop_reason = None
    with log.open("xb") as output:
        process = subprocess.Popen(
            command,
            stdout=output,
            stderr=subprocess.STDOUT,
            start_new_session=True,
        )
        while process.poll() is None:
            peak = max(peak, rss_bytes(process.pid))
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
    parsed = parse_result(result)
    complete = returncode == 0 and stop_reason is None and parsed is not None
    decisive = bool(
        complete and parsed is not None and parsed["decisive"] == 1 and parsed["dim"] == 0
    )
    if decisive:
        verdict = "EXACT_CAS_DISCOVERY_DIMENSION_ZERO_REQUIRES_INDEPENDENT_REPLAY"
    elif complete:
        verdict = "COMPLETE_NONDECISIVE_GLOBAL_PC2_NONVERDICT"
    else:
        verdict = "BOUNDED_RESOURCE_NONVERDICT"
    payload = {
        **plan,
        "path_replacements": replacements,
        "local_input": source_copy.name,
        "local_input_bytes": source_copy.stat().st_size,
        "local_input_sha256": local_hash,
        "command": command,
        "elapsed_seconds": round(elapsed, 6),
        "peak_rss_bytes_polled": peak,
        "returncode": returncode,
        "stop_reason": stop_reason,
        "complete": complete,
        "parsed_result": parsed,
        "result_sha256": sha256_file(result) if result.is_file() else None,
        "log": log.name,
        "log_bytes": log.stat().st_size,
        "log_sha256": sha256_file(log),
        "verdict": verdict,
        "theorem_boundary": (
            "Only a completed exact dim=0 result excludes the selected lower-presentation "
            "Stage B/C support over the algebraic closure of F_89. Resource stops and "
            "positive dimension do not produce a point or decide PC.2."
        ),
    }
    record.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(json.dumps(payload, sort_keys=True), flush=True)


if __name__ == "__main__":
    main()
