#!/usr/bin/env python3
"""Fail-closed ordinary-msolve pair-split run for one immutable r66 chart."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import resource
import signal
import subprocess
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
RSS_LIMIT_BYTES = int(4.5 * (1 << 30))
TIMEOUT_SECONDS = 1200.0
THREADS = 4
MAX_PAIRS = 100
ALLOWED_SHARED_PID = 13036


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


def ps_rows() -> list[dict[str, object]]:
    try:
        completed = subprocess.run(
            ["ps", "-axo", "pid=,ppid=,pgid=,rss=,command="],
            check=True,
            capture_output=True,
            text=True,
            timeout=10,
        )
    except (OSError, subprocess.SubprocessError) as exc:
        detail = getattr(exc, "stderr", "") or str(exc)
        raise RuntimeError(f"live ps unavailable: {detail.strip()}") from exc
    rows: list[dict[str, object]] = []
    for line in completed.stdout.splitlines():
        fields = line.strip().split(None, 4)
        if len(fields) != 5:
            continue
        try:
            pid, ppid, pgid, rss_kib = map(int, fields[:4])
        except ValueError:
            continue
        rows.append(
            {"pid": pid, "ppid": ppid, "pgid": pgid, "rss_kib": rss_kib, "command": fields[4]}
        )
    if not rows:
        raise RuntimeError("live ps returned no parseable process rows")
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
    # This is deliberately stricter than the requested P25-only gate: without
    # permission to inspect process working directories, every non-ancestor CAS
    # process is treated as competing. This cannot admit a hidden relative-path
    # P25 probe.
    markers = ("msolve", "singular", "run_singular", "run_msolve", "run_bounded")
    answer: list[dict[str, object]] = []
    for row in rows:
        pid = int(row["pid"])
        command = str(row["command"])
        lowered = command.lower()
        if pid in skip:
            continue
        if (
            pid == ALLOWED_SHARED_PID
            and "singular" in lowered
            and "syzygy_r48_boundary_bfirst.sing" in lowered
        ):
            continue
        if any(marker in lowered for marker in markers):
            answer.append(row)
    return answer


def process_group_rss(rows: list[dict[str, object]], pgid: int, leader: int) -> int:
    members = [row for row in rows if int(row["pgid"]) == pgid]
    if not members or not any(int(row["pid"]) == leader for row in members):
        raise RuntimeError("msolve process group missing from live ps census")
    return sum(int(row["rss_kib"]) for row in members) * 1024


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
    args = parser.parse_args()
    if not args.confirm_parent_notified:
        raise SystemExit("refusing launch: parent-notification attestation is required")
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
    rows = ps_rows()
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
    }
    if memory["free_plus_speculative_bytes"] < MIN_FREE_SPEC_BYTES:
        prelaunch["status"] = "BLOCKED_MEMORY_GATE"
    if competing:
        prelaunch["status"] = "BLOCKED_COMPETING_PROBE_GATE"
    if prelaunch["status"] != "PASS_PRELAUNCH_GATES":
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
                    observed = process_group_rss(ps_rows(), process.pid, process.pid)
                except RuntimeError as exc:
                    # Avoid misclassifying the narrow race where the process exits
                    # successfully between poll() and the ps census.
                    if process.poll() is not None:
                        break
                    reason = f"rss_poll_unavailable:{exc}"
                    terminate_group(process)
                    break
                peak = max(peak, observed)
                elapsed = time.monotonic() - started
                if elapsed > TIMEOUT_SECONDS:
                    reason = "timeout"
                elif observed > RSS_LIMIT_BYTES:
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
        "rss_limit_bytes": RSS_LIMIT_BYTES,
        "timeout_seconds": TIMEOUT_SECONDS,
        "returncode": returncode,
        "stop_reason": reason,
        "complete": complete,
        "unit_ideal": unit,
        "leading_sha256": sha256(LEADING) if LEADING.exists() else None,
        "log_sha256": sha256(LOG),
        "child_ru_maxrss_macos_bytes": resource.getrusage(resource.RUSAGE_CHILDREN).ru_maxrss,
        "binding_resource_guard": "live aggregate process-group ps RSS; fail closed",
        "criterion": (
            "Only a completed exact unit ideal is decisive, and only for this chart. "
            "Every other result is a nonverdict."
        ),
    }
    RUN_RECORD.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(json.dumps(payload, sort_keys=True))


if __name__ == "__main__":
    main()
