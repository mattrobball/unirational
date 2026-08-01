#!/usr/bin/env python3
"""Replay the split-F67 scheme and normal-rank certificates in line degree 4."""

from __future__ import annotations

import hashlib
import json
import subprocess
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path


HERE = Path(__file__).resolve().parent
DATA = HERE / "line4_normal_rigidity"


def run(path: Path) -> str:
    completed = subprocess.run(
        ["Singular", "-q", str(path)],
        check=True,
        text=True,
        capture_output=True,
    )
    return completed.stdout


def main() -> None:
    payload = json.loads((DATA / "certificate.json").read_text())
    assert payload["prime"] == 67
    assert payload["landing_cubic_count"] == 24
    assert payload["inherited_coordinate_count"] == 8
    assert payload["normal_coordinate_count"] == 3
    assert payload["normal_minor_count"] == 2024
    source = HERE / payload["source"]
    assert hashlib.sha256(source.read_bytes()).hexdigest() == payload["source_sha256"]

    tasks = []
    for record in payload["charts"]:
        assert record["chart"] in range(8)
        rank_path = DATA / record["path"]
        scheme_path = DATA / record["scheme_path"]
        assert hashlib.sha256(rank_path.read_bytes()).hexdigest() == record["sha256"]
        assert hashlib.sha256(scheme_path.read_bytes()).hexdigest() == record["scheme_sha256"]

        tasks.append((record, rank_path, scheme_path))

    with ThreadPoolExecutor(max_workers=16) as executor:
        futures = [
            (record, executor.submit(run, rank_path), executor.submit(run, scheme_path))
            for record, rank_path, scheme_path in tasks
        ]
    for record, rank_future, scheme_future in futures:
        rank_output = rank_future.result()
        assert f"CHART={record['chart']}\n" in rank_output
        assert "NF1\n0\nDIM\n-1\n" in rank_output

        scheme_output = scheme_future.result()
        assert f"SCHEME_CHART={record['chart']}\n" in scheme_output
        assert "NORMAL_FORMS\n0\n0\n0\n" in scheme_output
        assert "DIM\n0\nVDIM_IF_ZERO\n48\n" in scheme_output

    print("PASS all 8 inherited charts have scheme length 48")
    print("PASS all 3 primitive coordinates vanish in every chart algebra")
    print("PASS normal Jacobian has rank 3 at every geometric inherited point")
    print("SCOPE split F_67 line-degree-four central-compatible landing scheme")
    print("LINE4_NORMAL_RIGIDITY_VERIFY_OK")


if __name__ == "__main__":
    main()
