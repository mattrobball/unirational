#!/usr/bin/env python3
"""Solve one independently built ambient degree-12 chart over a split prime."""

from __future__ import annotations

import argparse
import json
import subprocess
import time
from pathlib import Path


HERE = Path(__file__).resolve().parent


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--prime", type=int, required=True)
    parser.add_argument("--zeta", type=int)
    parser.add_argument("--threads", type=int, default=4)
    parser.add_argument("--timeout", type=int, default=1800)
    args = parser.parse_args()
    suffix = f"_zeta{args.zeta % args.prime}" if args.zeta is not None else ""
    source = HERE / f"ambient_degree12_p{args.prime}{suffix}.in"
    assert source.is_file()
    affine = HERE / f"ambient_degree12_p{args.prime}{suffix}_a47.in"
    answer = HERE / f"ambient_degree12_p{args.prime}{suffix}_a47.rur"
    metadata = HERE / f"ambient_degree12_p{args.prime}{suffix}_a47.json"
    lines = source.read_text().rstrip().splitlines()
    # This is the generic staircase order found by the first p=23 solve.
    # Supplying it initially avoids msolve's internal retry, whose returned
    # coordinate blocks are ambiguous relative to the displayed name order.
    lines[0] = ",".join(["a47", *[f"a{i}" for i in range(1, 47)], "a0"])
    affine.write_text("\n".join(lines) + ",\na47-1\n")
    command = [
        "msolve", "-f", str(affine), "-o", str(answer),
        "-t", str(args.threads), "-v", "2", "-l", "2",
        "--random-seed", "0",
    ]
    started = time.monotonic()
    completed = subprocess.run(
        command,
        cwd=HERE,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        timeout=args.timeout,
        check=False,
    )
    elapsed = time.monotonic() - started
    print(completed.stdout, end="")
    assert completed.returncode == 0
    assert answer.is_file() and answer.stat().st_size > 0
    output = answer.read_text()
    assert output.strip() not in {"[-1]", "[1, 48, -1,[]]"}
    metadata.write_text(json.dumps({
        "format": "ambient-projector-chart-rur-v1",
        "scope": "modular auxiliary projector scheme only",
        "prime": args.prime,
        "zeta11": args.zeta % args.prime if args.zeta is not None else None,
        "chart": "a47=1",
        "threads": args.threads,
        "elapsed_seconds": elapsed,
        "rur_bytes": len(output.encode()),
        "theorem_boundary": (
            "a modular RUR is not a characteristic-zero projector and does not "
            "impose the distinguished Fano section"
        ),
    }, indent=2) + "\n")
    print(f"WROTE {answer}")
    print("AMBIENT-PROJECTOR-CHART-RUR-COMPUTED")


if __name__ == "__main__":
    main()
