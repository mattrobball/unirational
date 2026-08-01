#!/usr/bin/env python3
"""Rerun the three CPU-starved affine charts sequentially with a long limit."""

from __future__ import annotations

import json
import time
from pathlib import Path

from run_degree6_charts import solve


HERE = Path(__file__).resolve().parent
CHARTS = (5, 10, 13)
TIMEOUT = 3600


def main() -> None:
    started = time.monotonic()
    records = []
    for chart in CHARTS:
        record = solve(chart, TIMEOUT)
        records.append(record)
        print(
            f"chart={chart:02d} status={record['status']} "
            f"seconds={record['elapsed_seconds']:.3f}",
            flush=True,
        )
        if record["status"] != "empty":
            raise RuntimeError(f"chart {chart} did not complete with the unit ideal")
    payload = {
        "schema": "klein-f55-degree6-chi0-p23-hard-chart-results-v1",
        "execution": "sequential isolated rerun after four-worker timeouts",
        "timeout_seconds_per_chart": TIMEOUT,
        "elapsed_seconds": time.monotonic() - started,
        "records": records,
        "all_hard_charts_empty": True,
    }
    (HERE / "degree6_chi0_p23_hard_chart_results.json").write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n"
    )
    print("Q_F55_DEGREE6_CHI0_P23_HARD_CHARTS_EMPTY_EXACT")


if __name__ == "__main__":
    main()
