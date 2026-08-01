#!/usr/bin/env python3
"""Solve and record all 19 exact affine charts of the p=23 system."""

from __future__ import annotations

import argparse
import concurrent.futures
import hashlib
import json
import subprocess
import time
from pathlib import Path


HERE = Path(__file__).resolve().parent
MSOLVE = "/opt/homebrew/bin/msolve"
DIMENSION = 19


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def solve(chart: int, timeout: int) -> dict[str, object]:
    source = HERE / f"degree6_chi0_p23_chart{chart:02d}.in"
    answer = HERE / f"degree6_chi0_p23_chart{chart:02d}.out"
    log = HERE / f"degree6_chi0_p23_chart{chart:02d}.log"
    command = [
        MSOLVE,
        "-f",
        source.name,
        "-o",
        answer.name,
        "-t",
        "4",
        "-g",
        "1",
        "-v",
        "2",
        "-l",
        "2",
        "-q",
        "0",
        "-r",
        "0",
        "-s",
        "20",
        "-m",
        "2000",
        "--random-seed",
        "0",
    ]
    started = time.monotonic()
    try:
        completed = subprocess.run(
            command,
            cwd=HERE,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            timeout=timeout,
            check=False,
        )
    except subprocess.TimeoutExpired as error:
        output = error.stdout or ""
        if isinstance(output, bytes):
            output = output.decode(errors="replace")
        log.write_text(output)
        return {
            "chart": chart,
            "status": "timeout",
            "elapsed_seconds": time.monotonic() - started,
            "input_file": source.name,
            "input_sha256": sha256(source),
            "log_file": log.name,
            "log_sha256": sha256(log),
        }
    log.write_text(completed.stdout)
    unit_output = (
        completed.returncode == 0
        and answer.is_file()
        and "Grobner basis has a single element" in completed.stdout
        and "No solution" in completed.stdout
        and "#length of basis:      1 element" in answer.read_text()
        and answer.read_text().rstrip().endswith("[1]:")
    )
    return {
        "chart": chart,
        "status": "empty" if unit_output else "solver_failure_or_nonempty",
        "returncode": completed.returncode,
        "elapsed_seconds": time.monotonic() - started,
        "input_file": source.name,
        "input_sha256": sha256(source),
        "leading_file": answer.name if answer.is_file() else None,
        "leading_sha256": sha256(answer) if answer.is_file() else None,
        "log_file": log.name,
        "log_sha256": sha256(log),
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--workers", type=int, default=4)
    parser.add_argument("--timeout", type=int, default=600)
    arguments = parser.parse_args()
    assert 1 <= arguments.workers <= 8 and 30 <= arguments.timeout <= 3600
    started = time.monotonic()
    with concurrent.futures.ThreadPoolExecutor(max_workers=arguments.workers) as pool:
        futures = {
            pool.submit(solve, chart, arguments.timeout): chart
            for chart in range(DIMENSION)
        }
        records = []
        for future in concurrent.futures.as_completed(futures):
            record = future.result()
            records.append(record)
            print(
                f"chart={record['chart']:02d} status={record['status']} "
                f"seconds={record['elapsed_seconds']:.3f}",
                flush=True,
            )
    records.sort(key=lambda record: record["chart"])
    payload = {
        "schema": "klein-f55-degree6-chi0-p23-affine-chart-results-v1",
        "prime": 23,
        "workers": arguments.workers,
        "timeout_seconds_per_chart": arguments.timeout,
        "elapsed_seconds": time.monotonic() - started,
        "records": records,
        "all_charts_empty": all(record["status"] == "empty" for record in records),
        "conclusion": (
            "The complete homogeneous character-zero degree-six landing scheme "
            "has empty projectivization over the algebraic closure of F_23."
        ),
    }
    (HERE / "degree6_chi0_p23_chart_results.json").write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n"
    )
    if not payload["all_charts_empty"]:
        raise RuntimeError("not every affine chart was proved empty")
    print("Q_F55_DEGREE6_CHI0_P23_ALL_AFFINE_CHARTS_EMPTY_EXACT")


if __name__ == "__main__":
    main()
