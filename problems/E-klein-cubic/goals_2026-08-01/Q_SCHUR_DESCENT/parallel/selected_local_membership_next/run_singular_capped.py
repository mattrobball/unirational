#!/usr/bin/env python3
"""Run one Singular script with explicit memory and wall-clock limits."""

from __future__ import annotations

import argparse
import os
from pathlib import Path
import resource
import signal
import subprocess
import sys
import time


HERE = Path(__file__).resolve().parent


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--script", type=Path, default=HERE / "singular_local_membership_p13.sing")
    parser.add_argument("--timeout", type=int, default=300)
    parser.add_argument("--memory-mib", type=int, default=2048)
    parser.add_argument("--log", type=Path, default=HERE / "singular_local_membership_p13.log")
    args = parser.parse_args()

    started = time.monotonic()
    process = subprocess.Popen(
        [
            "/usr/sbin/taskpolicy",
            "-m",
            str(args.memory_mib),
            "/opt/homebrew/bin/Singular",
            "-q",
            str(args.script.resolve()),
        ],
        cwd=HERE,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
        start_new_session=True,
    )
    timed_out = False
    try:
        output, _ = process.communicate(timeout=args.timeout)
    except subprocess.TimeoutExpired:
        timed_out = True
        os.killpg(process.pid, signal.SIGKILL)
        output, _ = process.communicate()

    elapsed = time.monotonic() - started
    maximum_rss = resource.getrusage(resource.RUSAGE_CHILDREN).ru_maxrss
    maximum_rss_bytes = int(maximum_rss if sys.platform == "darwin" else maximum_rss * 1024)
    trailer = (
        f"RUN_SINGULAR_WALL_SECONDS={elapsed:.3f}\n"
        f"RUN_SINGULAR_MAX_RSS_BYTES={maximum_rss_bytes}\n"
        f"RUN_SINGULAR_TIMED_OUT={timed_out}\n"
        f"RUN_SINGULAR_RETURN_CODE={process.returncode}\n"
    )
    args.log.resolve().write_text(output + trailer)
    print(output, end="")
    print(trailer, end="")
    print(f"RUN_SINGULAR_LOG={args.log.resolve()}")
    raise SystemExit(124 if timed_out else process.returncode)


if __name__ == "__main__":
    main()
