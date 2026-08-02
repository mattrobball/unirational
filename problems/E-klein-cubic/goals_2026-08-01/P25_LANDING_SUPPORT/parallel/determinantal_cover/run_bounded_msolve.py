#!/usr/bin/env python3
"""Run one immutable msolve chart under hard wall/RSS fences."""

from __future__ import annotations

import argparse
import hashlib
import json
import resource
from pathlib import Path
import signal
import subprocess
import time


HERE = Path(__file__).resolve().parent


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def rss_bytes(pid: int) -> int | None:
    try:
        output = subprocess.check_output(
            ["ps", "-o", "rss=", "-p", str(pid)], text=True
        ).strip()
        return int(output or 0) * 1024
    except (OSError, subprocess.SubprocessError, ValueError):
        return None


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("stem")
    parser.add_argument("--timeout", type=float, default=600.0)
    parser.add_argument("--rss-gib", type=float, default=4.0)
    parser.add_argument("--threads", type=int, default=4)
    parser.add_argument("--signature", type=int, choices=(0, 1), default=0)
    parser.add_argument("--run-tag", default="")
    args = parser.parse_args()
    source = HERE / f"{args.stem}.ms"
    manifest = HERE / f"{args.stem}.json"
    if not source.is_file() or not manifest.is_file():
        raise FileNotFoundError(source if not source.is_file() else manifest)
    suffix = f".{args.run_tag}" if args.run_tag else ""
    leading = HERE / f"{args.stem}{suffix}.leading"
    log = HERE / f"{args.stem}{suffix}.log"
    record = HERE / f"{args.stem}{suffix}.run.json"
    existing = [path.name for path in (leading, log, record) if path.exists()]
    if existing:
        raise SystemExit(f"refusing to overwrite run artifacts: {existing}")

    command = [
        "/opt/homebrew/bin/msolve",
        "-f", str(source),
        "-o", str(leading),
        "-t", str(args.threads),
        "-v", "2",
        "-g", "1",
        "-l", "2",
        "-q", str(args.signature),
        "-r", "0",
        "-s", "20",
        "-m", "0",
        "--random-seed", "2026080189",
    ]
    address_limit = int(args.rss_gib * (1 << 30))
    started = time.monotonic()
    peak = 0
    reason: str | None = None
    with log.open("wb") as handle:
        process = subprocess.Popen(
            command,
            stdout=handle,
            stderr=subprocess.STDOUT,
            start_new_session=True,
        )
        while process.poll() is None:
            observed_rss = rss_bytes(process.pid)
            if observed_rss is None:
                reason = "rss_poll_unavailable"
            else:
                peak = max(peak, observed_rss)
            elapsed = time.monotonic() - started
            if elapsed > args.timeout:
                reason = "timeout"
            elif peak > address_limit:
                reason = "rss_limit"
            if reason is not None:
                try:
                    process.send_signal(signal.SIGTERM)
                    process.wait(timeout=5)
                except subprocess.TimeoutExpired:
                    process.kill()
                break
            time.sleep(0.25)
        returncode = process.wait()
    elapsed = time.monotonic() - started
    leading_text = leading.read_text(errors="replace") if leading.exists() else ""
    complete = returncode == 0 and reason is None and bool(leading_text.strip())
    normalized = leading_text.strip().replace(" ", "")
    unit = complete and (normalized.endswith("[1]:") or normalized in {"[1]", "[-1]", "[-1]:"})
    child_maxrss = resource.getrusage(resource.RUSAGE_CHILDREN).ru_maxrss
    payload = {
        "status": "PASS_EXACT_CHART_EMPTY" if unit else "BOUNDED_NONVERDICT",
        "input": source.name,
        "input_sha256": sha256(source),
        "command": command,
        "elapsed_seconds": elapsed,
        "peak_rss_bytes_polled": peak,
        "child_ru_maxrss_macos_bytes": child_maxrss,
        "binding_resource_guard": "live_ps_rss_poll_fail_closed",
        "rss_limit_bytes": address_limit,
        "timeout_seconds": args.timeout,
        "returncode": returncode,
        "stop_reason": reason,
        "signature_mode": args.signature,
        "complete": complete,
        "unit_ideal": unit,
        "leading": leading.name,
        "leading_bytes": leading.stat().st_size if leading.exists() else 0,
        "leading_sha256": sha256(leading) if leading.exists() else None,
        "log": log.name,
        "log_bytes": log.stat().st_size,
        "log_sha256": sha256(log),
        "scope_guard": (
            "Only this one affine q/b flag chart. Unit is decisive emptiness; "
            "every other outcome is a nonverdict."
        ),
    }
    record.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(json.dumps(payload, sort_keys=True))


if __name__ == "__main__":
    main()
