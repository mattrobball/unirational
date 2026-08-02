#!/usr/bin/env python3
"""Fail-closed ordinary-msolve pair-split run for one immutable r66 chart.

RSS and process census do **not** require `ps`.  On Darwin they use libproc
(`proc_listpids` / `proc_pidinfo`) plus `sysctl(KERN_PROCARGS2)` for command
lines.  Every unavailable census or RSS poll fails closed.

Hard review: the historical 4.5 GiB fence was theater after a ~4.28 GiB
incomplete stop.  Default RSS fence is therefore 16 GiB on a 128 GiB host;
override with --rss-gib in [8, 32].
"""

from __future__ import annotations

import argparse
import ctypes
from ctypes import (
    POINTER,
    Structure,
    byref,
    c_char,
    c_int,
    c_int32,
    c_uint32,
    c_uint64,
    c_void_p,
    create_string_buffer,
    sizeof,
)
import hashlib
import json
import os
from pathlib import Path
import re
import resource
import signal
import subprocess
import sys
import time


HERE = Path(__file__).resolve().parent
P25 = HERE.parents[1]
SOURCE = HERE / "r66_stageB_q0_1_b1_0_1_m100.ms"
MANIFEST = HERE / "input_manifest.json"
MSOLVE = Path("/opt/homebrew/bin/msolve")
LEADING = HERE / "r66_stageB_q0_1_b1_0_1_m100.leading"
LOG = HERE / "r66_stageB_q0_1_b1_0_1_m100.log"
RUN_RECORD = HERE / "r66_stageB_q0_1_b1_0_1_m100.run.json"
PRELAUNCH = HERE / "r66_stageB_q0_1_b1_0_1_m100.prelaunch.json"

EXPECTED_SOURCE_SHA256 = "9fc5d17aeb9c2bf1341c0871ffd1e0fce07682701a1490a12b2f64ed3378f34b"
EXPECTED_MSOLVE_SHA256 = "b2008fb403f38f6a2ae230d12e3023776ae0196761c49966d97fe10747131c60"
MIN_FREE_SPEC_BYTES = 14 * (1 << 30)
# Hard review: 4.5 GiB is theater after ~4.28 GiB incomplete stop.
DEFAULT_RSS_GIB = 16.0
MIN_RSS_GIB = 8.0
MAX_RSS_GIB = 32.0
DEFAULT_TIMEOUT_SECONDS = 1200.0
MIN_TIMEOUT_SECONDS = 60.0
MAX_TIMEOUT_SECONDS = 3600.0
THREADS = 4
MAX_PAIRS = 100
ALLOWED_SHARED_PID = 13036

PROC_ALL_PIDS = 1
PROC_PIDTASKINFO = 4
PROC_PIDTBSDINFO = 3
CTL_KERN = 1
KERN_PROCARGS2 = 49


class ProcTaskInfo(Structure):
    _fields_ = [
        ("virtual_size", c_uint64),
        ("resident_size", c_uint64),
        ("total_user", c_uint64),
        ("total_system", c_uint64),
        ("threads_user", c_uint64),
        ("threads_system", c_uint64),
        ("policy", c_int32),
        ("faults", c_int32),
        ("pageins", c_int32),
        ("cow_faults", c_int32),
        ("messages_sent", c_int32),
        ("messages_received", c_int32),
        ("syscalls_mach", c_int32),
        ("syscalls_unix", c_int32),
        ("context_switches", c_int32),
        ("thread_count", c_int32),
        ("running_threads", c_int32),
        ("priority", c_int32),
    ]


class ProcBsdInfo(Structure):
    _fields_ = [
        ("pbi_flags", c_uint32),
        ("pbi_status", c_uint32),
        ("pbi_xstatus", c_uint32),
        ("pbi_pid", c_uint32),
        ("pbi_ppid", c_uint32),
        ("pbi_uid", c_uint32),
        ("pbi_gid", c_uint32),
        ("pbi_ruid", c_uint32),
        ("pbi_rgid", c_uint32),
        ("pbi_svuid", c_uint32),
        ("pbi_svgid", c_uint32),
        ("pbi_rfu", c_uint32),
        ("pbi_comm", c_char * 16),
        ("pbi_name", c_char * 32),
        ("pbi_nfiles", c_uint32),
        ("pbi_pgid", c_uint32),
        ("pbi_pjobc", c_uint32),
        ("e_tdev", c_uint32),
        ("e_tpgid", c_uint32),
        ("pbi_nice", c_int32),
        ("pbi_start_tvsec", c_uint64),
        ("pbi_start_tvusec", c_uint64),
    ]


if sys.platform != "darwin":
    LIBPROC = None
    LIBC = None
else:
    LIBPROC = ctypes.CDLL("/usr/lib/libproc.dylib")
    LIBPROC.proc_pidinfo.argtypes = [c_int, c_int, c_uint64, c_void_p, c_int]
    LIBPROC.proc_pidinfo.restype = c_int
    LIBPROC.proc_listpids.argtypes = [c_int, c_uint32, c_void_p, c_int]
    LIBPROC.proc_listpids.restype = c_int
    LIBPROC.proc_pidpath.argtypes = [c_int, c_void_p, c_uint32]
    LIBPROC.proc_pidpath.restype = c_int
    LIBC = ctypes.CDLL(None)
    LIBC.sysctl.argtypes = [
        POINTER(c_int), c_uint32, c_void_p, POINTER(c_uint64), c_void_p, c_uint64
    ]
    LIBC.sysctl.restype = c_int


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def vm_free_speculative() -> dict[str, int]:
    try:
        completed = subprocess.run(
            ["vm_stat"], check=True, capture_output=True, text=True, timeout=10
        )
    except (OSError, subprocess.SubprocessError) as exc:
        raise RuntimeError(f"vm_stat unavailable: {exc}") from exc
    lines = completed.stdout.splitlines()
    page_match = re.search(r"page size of (\d+) bytes", lines[0] if lines else "")
    values: dict[str, int] = {}
    for line in lines[1:]:
        match = re.match(r"([^:]+):\s+(\d+)\.", line)
        if match:
            values[match.group(1)] = int(match.group(2))
    if not page_match or "Pages free" not in values or "Pages speculative" not in values:
        raise RuntimeError("could not parse vm_stat free/speculative pages")
    page_size = int(page_match.group(1))
    free_pages = values["Pages free"]
    speculative_pages = values["Pages speculative"]
    return {
        "page_size": page_size,
        "free_pages": free_pages,
        "speculative_pages": speculative_pages,
        "free_plus_speculative_bytes": (free_pages + speculative_pages) * page_size,
    }


def _proc_args(pid: int) -> str:
    """Best-effort argv string via sysctl(KERN_PROCARGS2); empty if denied."""
    if LIBC is None:
        return ""
    mib = (c_int * 3)(CTL_KERN, KERN_PROCARGS2, int(pid))
    size = c_uint64(0)
    if LIBC.sysctl(mib, 3, None, byref(size), None, 0) != 0 or size.value < 4:
        return ""
    buf = create_string_buffer(size.value)
    if LIBC.sysctl(mib, 3, buf, byref(size), None, 0) != 0:
        return ""
    raw = buf.raw[: size.value]
    argc = int.from_bytes(raw[:4], "little")
    rest = raw[4:]
    try:
        path_end = rest.index(0)
    except ValueError:
        return ""
    path = rest[:path_end].decode(errors="replace")
    rest = rest[path_end + 1 :]
    while rest and rest[0] == 0:
        rest = rest[1:]
    args: list[str] = []
    while rest and len(args) < max(argc, 1):
        try:
            end = rest.index(0)
        except ValueError:
            break
        piece = rest[:end].decode(errors="replace")
        if piece:
            args.append(piece)
        rest = rest[end + 1 :]
    if not args:
        return path
    return " ".join(args)


def _rss_bytes(pid: int) -> int | None:
    if LIBPROC is None:
        return None
    info = ProcTaskInfo()
    got = LIBPROC.proc_pidinfo(int(pid), PROC_PIDTASKINFO, 0, byref(info), sizeof(info))
    if got != sizeof(info):
        return None
    return int(info.resident_size)


def process_rows() -> list[dict[str, object]]:
    """Live process census without `ps` (libproc + optional sysctl argv)."""
    if LIBPROC is None:
        raise RuntimeError("libproc unavailable: non-Darwin or load failure")
    need = LIBPROC.proc_listpids(PROC_ALL_PIDS, 0, None, 0)
    if need <= 0:
        raise RuntimeError("proc_listpids failed to size the pid buffer")
    buf = (c_int * (need // sizeof(c_int) + 16))()
    filled = LIBPROC.proc_listpids(PROC_ALL_PIDS, 0, buf, sizeof(buf))
    if filled <= 0:
        raise RuntimeError("proc_listpids failed to fill the pid buffer")
    pids = [int(buf[i]) for i in range(filled // sizeof(c_int)) if int(buf[i]) > 0]
    rows: list[dict[str, object]] = []
    for pid in pids:
        bsd = ProcBsdInfo()
        got = LIBPROC.proc_pidinfo(pid, PROC_PIDTBSDINFO, 0, byref(bsd), sizeof(bsd))
        if got != sizeof(bsd):
            continue
        rss = _rss_bytes(pid)
        if rss is None:
            continue
        path_buf = create_string_buffer(4096)
        path_len = LIBPROC.proc_pidpath(pid, path_buf, 4096)
        path = path_buf.value.decode(errors="replace") if path_len > 0 else ""
        comm = bsd.pbi_comm.decode(errors="replace")
        argv = _proc_args(pid)
        command = argv or (path if path else comm)
        rows.append(
            {
                "pid": int(bsd.pbi_pid),
                "ppid": int(bsd.pbi_ppid),
                "pgid": int(bsd.pbi_pgid),
                "rss_bytes": rss,
                "path": path,
                "comm": comm,
                "command": command,
            }
        )
    if not rows:
        raise RuntimeError("libproc census returned no parseable process rows")
    return rows


def ancestors(rows: list[dict[str, object]], pid: int) -> set[int]:
    parents = {int(row["pid"]): int(row["ppid"]) for row in rows}
    found = {pid}
    while pid in parents and parents[pid] > 0 and parents[pid] not in found:
        pid = parents[pid]
        found.add(pid)
    return found


def competing_p25_probes(rows: list[dict[str, object]]) -> list[dict[str, object]]:
    skip = ancestors(rows, os.getpid())
    # Stricter than P25-only: without cwd inspection, every non-ancestor CAS
    # binary/script marker is treated as competing.
    markers = ("msolve", "singular", "run_singular", "run_msolve", "run_bounded", "run_pair_split")
    answer: list[dict[str, object]] = []
    for row in rows:
        pid = int(row["pid"])
        command = str(row["command"])
        path = str(row.get("path", ""))
        lowered = f"{command} {path}".lower()
        if pid in skip:
            continue
        if (
            pid == ALLOWED_SHARED_PID
            and "singular" in lowered
            and "syzygy_r48_boundary_bfirst.sing" in lowered
        ):
            continue
        if any(marker in lowered for marker in markers):
            answer.append(
                {
                    "pid": pid,
                    "ppid": row["ppid"],
                    "pgid": row["pgid"],
                    "rss_bytes": row["rss_bytes"],
                    "command": command,
                    "path": path,
                }
            )
    return answer


def process_group_rss(rows: list[dict[str, object]], pgid: int, leader: int) -> int:
    members = [row for row in rows if int(row["pgid"]) == pgid]
    if not members or not any(int(row["pid"]) == leader for row in members):
        # Fallback: leader-only RSS (msolve is typically single-process, multi-thread).
        leader_rows = [row for row in rows if int(row["pid"]) == leader]
        if not leader_rows:
            raise RuntimeError("msolve leader missing from live libproc census")
        return int(leader_rows[0]["rss_bytes"])
    return sum(int(row["rss_bytes"]) for row in members)


def terminate_group(process: subprocess.Popen[bytes]) -> None:
    try:
        os.killpg(process.pid, signal.SIGTERM)
    except ProcessLookupError:
        return
    try:
        process.wait(timeout=5)
    except subprocess.TimeoutExpired:
        try:
            os.killpg(process.pid, signal.SIGKILL)
        except ProcessLookupError:
            pass


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--confirm-parent-notified",
        action="store_true",
        help="required attestation that the parent was messaged immediately before launch",
    )
    parser.add_argument(
        "--rss-gib",
        type=float,
        default=DEFAULT_RSS_GIB,
        help=f"RSS hard stop in GiB (default {DEFAULT_RSS_GIB}; allowed [{MIN_RSS_GIB}, {MAX_RSS_GIB}])",
    )
    parser.add_argument(
        "--timeout-seconds",
        type=float,
        default=DEFAULT_TIMEOUT_SECONDS,
        help=(
            f"wall timeout in seconds (default {DEFAULT_TIMEOUT_SECONDS}; "
            f"allowed [{MIN_TIMEOUT_SECONDS}, {MAX_TIMEOUT_SECONDS}])"
        ),
    )
    args = parser.parse_args()
    if not args.confirm_parent_notified:
        raise SystemExit("refusing launch: parent-notification attestation is required")
    if not (MIN_RSS_GIB <= args.rss_gib <= MAX_RSS_GIB):
        raise SystemExit(f"RSS fence must lie in [{MIN_RSS_GIB}, {MAX_RSS_GIB}] GiB")
    if not (MIN_TIMEOUT_SECONDS <= args.timeout_seconds <= MAX_TIMEOUT_SECONDS):
        raise SystemExit(
            f"timeout must lie in [{MIN_TIMEOUT_SECONDS}, {MAX_TIMEOUT_SECONDS}] seconds"
        )
    rss_limit_bytes = int(args.rss_gib * (1 << 30))
    timeout_seconds = float(args.timeout_seconds)

    if any(path.exists() for path in (LEADING, LOG, RUN_RECORD, PRELAUNCH)):
        raise SystemExit("refusing to overwrite distinct immutable run artifacts")
    if not SOURCE.is_file() or not MANIFEST.is_file():
        raise SystemExit("run prepare_chart.py first")
    if sha256(SOURCE) != EXPECTED_SOURCE_SHA256:
        raise SystemExit("refusing launch: source hash mismatch")
    source_manifest = json.loads(MANIFEST.read_text())
    required_manifest = {
        "status": "PASS_IMMUTABLE_R66_CHART_REGENERATED",
        "prime": 89,
        "input_sha256": EXPECTED_SOURCE_SHA256,
        "equations": 66,
        "variables": 41,
    }
    for key, value in required_manifest.items():
        if source_manifest.get(key) != value:
            raise SystemExit(f"refusing launch: manifest field {key} mismatch")
    if source_manifest.get("chart") != {"q0": 1, "b1_0": 1}:
        raise SystemExit("refusing launch: manifest chart mismatch")
    if sha256(MSOLVE.resolve()) != EXPECTED_MSOLVE_SHA256:
        raise SystemExit("refusing launch: msolve binary hash mismatch")

    memory = vm_free_speculative()
    try:
        rows = process_rows()
    except RuntimeError as exc:
        raise SystemExit(f"BLOCKED_PROCESS_CENSUS:{exc}") from exc
    competing = competing_p25_probes(rows)
    prelaunch = {
        "status": "PASS_PRELAUNCH_GATES",
        "memory": memory,
        "minimum_free_plus_speculative_bytes": MIN_FREE_SPEC_BYTES,
        "allowed_shared_pid": ALLOWED_SHARED_PID,
        "competing_p25_bounded_probes": competing,
        "source_sha256": sha256(SOURCE),
        "msolve_sha256": sha256(MSOLVE.resolve()),
        "parent_notified": True,
        "census_backend": "libproc+sysctl_no_ps",
        "rss_limit_bytes": rss_limit_bytes,
        "rss_limit_gib": args.rss_gib,
        "timeout_seconds": timeout_seconds,
        "hard_review_note": (
            "4.5 GiB fence retired as theater after ~4.28 GiB incomplete stop; "
            "default fence is 16 GiB (flag range 8-32) on 128 GiB host"
        ),
    }
    if memory["free_plus_speculative_bytes"] < MIN_FREE_SPEC_BYTES:
        prelaunch["status"] = "BLOCKED_MEMORY_GATE"
    if competing:
        prelaunch["status"] = "BLOCKED_COMPETING_PROBE_GATE"
    if prelaunch["status"] != "PASS_PRELAUNCH_GATES":
        PRELAUNCH.write_text(json.dumps(prelaunch, indent=2, sort_keys=True) + "\n")
        raise SystemExit(prelaunch["status"])
    PRELAUNCH.write_text(json.dumps(prelaunch, indent=2, sort_keys=True) + "\n")

    command = [
        str(MSOLVE),
        "-f", str(SOURCE),
        "-o", str(LEADING),
        "-t", str(THREADS),
        "-v", "2",
        "-g", "1",
        "-l", "2",
        "-q", "0",
        "-r", "0",
        "-s", "20",
        "-m", str(MAX_PAIRS),
        "--random-seed", "2026080189",
    ]
    started = time.monotonic()
    peak = 0
    reason: str | None = None
    with LOG.open("wb") as handle:
        process = subprocess.Popen(
            command, stdout=handle, stderr=subprocess.STDOUT, start_new_session=True
        )
        try:
            while process.poll() is None:
                try:
                    observed = process_group_rss(process_rows(), process.pid, process.pid)
                except RuntimeError as exc:
                    # Avoid misclassifying the narrow race where the process exits
                    # successfully between poll() and the census.
                    if process.poll() is not None:
                        break
                    reason = f"rss_poll_unavailable:{exc}"
                    terminate_group(process)
                    break
                peak = max(peak, observed)
                elapsed = time.monotonic() - started
                if elapsed > timeout_seconds:
                    reason = "timeout"
                elif observed > rss_limit_bytes:
                    reason = "rss_limit"
                if reason is not None:
                    terminate_group(process)
                    break
                time.sleep(0.25)
        except BaseException as exc:
            if process.poll() is None:
                reason = f"runner_interrupted:{type(exc).__name__}"
                terminate_group(process)
            raise
        returncode = process.wait()

    elapsed = time.monotonic() - started
    leading_text = LEADING.read_text(errors="replace") if LEADING.exists() else ""
    normalized = "".join(leading_text.split())
    complete = returncode == 0 and reason is None and bool(normalized)
    unit = complete and normalized in {"[-1]", "[-1]:", "[1]", "[1]:"}
    payload = {
        "status": "PASS_EXACT_THIS_CHART_EMPTY" if unit else "BOUNDED_NONVERDICT",
        "scope": "r66 Stage-B affine chart q0=1,b1_0=1 only",
        "command": command,
        "only_baseline_option_change": "-m 0 -> -m 100",
        "hash_table_reset": "OFF (-u omitted, as in baseline)",
        "source_sha256": sha256(SOURCE),
        "msolve_sha256": sha256(MSOLVE.resolve()),
        "elapsed_seconds": elapsed,
        "peak_process_group_rss_bytes": peak,
        "rss_limit_bytes": rss_limit_bytes,
        "rss_limit_gib": args.rss_gib,
        "timeout_seconds": timeout_seconds,
        "returncode": returncode,
        "stop_reason": reason,
        "complete": complete,
        "unit_ideal": unit,
        "leading_sha256": sha256(LEADING) if LEADING.exists() else None,
        "log_sha256": sha256(LOG),
        "child_ru_maxrss_macos_bytes": resource.getrusage(resource.RUSAGE_CHILDREN).ru_maxrss,
        "binding_resource_guard": "live aggregate process-group libproc RSS; fail closed; no ps",
        "census_backend": "libproc+sysctl_no_ps",
        "criterion": (
            "Only a completed exact unit ideal is decisive, and only for this chart. "
            "Every other result is a nonverdict."
        ),
    }
    RUN_RECORD.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(json.dumps(payload, sort_keys=True))


if __name__ == "__main__":
    main()
