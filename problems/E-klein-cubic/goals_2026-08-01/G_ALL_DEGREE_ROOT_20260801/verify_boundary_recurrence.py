#!/usr/bin/env python3
"""Rebuild the exact split-67 line-to-D12 boundary frontier.

This verifier does not trust the saved JSON records.  It reruns the raw
group/plane reconstruction for the three boundary-power residues and for the
first degree beyond the finite D12 residual point module, then audits the
resulting ranks and nonlinear chart ideals.
"""

from __future__ import annotations

import hashlib
import json
import subprocess
import sys
import tempfile
from pathlib import Path


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
ANALYZER = HERE / "analyze_line_boundary_recurrence.py"
EXPECTED_HASHES = {
    "tmp/m3_line_point_boundary/analyze.py":
        "212df94d65be4ef4d2807af733d807a5999d8edb1d45ba191d89956bab099466",
    "tmp/m3_line_point_boundary/compute.py":
        "e0fdf3bf7c0b500e10df3b324d31fde2da418f5b19bb3b06ceb5425199b110b1",
    "tmp/symbolic_compatibility_complex/boundary_interface.json":
        "32f013a4691dbea6f04c6a2ba1392d636f717b42d2d0168c00a162203554aa36",
    "tmp/symbolic_compatibility_complex/point_symbolic/character_results.json":
        "0e3e3f9ae15e6aae4409dbb7c558104f9a6747d653500cf373971791d18c68f8",
    "tmp/symbolic_compatibility_complex/point_symbolic/local_interface_f67.py":
        "35a9b50e01bf6655ce4c88743b5151b1485e65e4fb3a9bf8751064ffbd7da73b",
    "tmp/symbolic_compatibility_complex/line_landing_bigraded.py":
        "efaa3975152bf03a80e691a7521638cdeba01dc7ad80e46981ec1608780d4a62",
}


def check_hashes() -> None:
    for relative, expected in EXPECTED_HASHES.items():
        actual = hashlib.sha256((PROBLEM / relative).read_bytes()).hexdigest()
        assert actual == expected, (relative, expected, actual)


def rebuild(output: Path, start: int, count: int, maximum: int) -> dict:
    command = [
        sys.executable,
        str(ANALYZER),
        "--order", "3",
        "--max-line-degree", str(maximum),
        "--boundary-power-start", str(start),
        "--power-count", str(count),
        "--output", str(output),
    ]
    subprocess.run(command, check=True)
    return json.loads(output.read_text())


def by_key(payload: dict) -> dict[tuple[int, int], dict]:
    return {
        (record["boundary_power"], record["line_degree"]): record
        for record in payload["records"]
    }


def check_low_residues(payload: dict) -> None:
    assert payload["prime"] == 67
    assert payload["symbolic_order"] == 3
    assert payload["tested_boundary_powers"] == [4, 6]
    records = by_key(payload)
    for power in (4, 5, 6):
        zero = records[power, 0]
        one = records[power, 1]
        two = records[power, 2]
        three = records[power, 3]
        assert (zero["source_dimension"], zero["central_equation_rank"]) == (3, 3)
        assert (one["source_dimension"], one["central_equation_rank"]) == (8, 8)
        assert (two["source_dimension"], two["central_equation_rank"]) == (11, 8)
        assert (three["source_dimension"], three["central_equation_rank"]) == (14, 8)
        assert two["central_kernel_dimension"] == 3
        assert three["central_kernel_dimension"] == 6
        assert two["residual_rank_on_central_kernel"] == 3
        assert three["residual_rank_on_central_kernel"] == 3
        assert two["survivor_dimension_after_residual"] == 0
        assert three["survivor_dimension_after_residual"] == 3
        assert two["survivor_equals_D_L_multiple"] is True
        assert three["survivor_equals_D_L_multiple"] is True
        for record, row_rank in ((two, 4), (three, 14)):
            assert record["central_quotient_landing_projectively_empty"] is True
            assert record["central_quotient_landing_row_rank"] == row_rank
            assert record["boundary_value_landing_projectively_empty"] is False
            assert record["boundary_value_landing_row_rank"] == 1


def check_residual_termination(payload: dict) -> None:
    records = by_key(payload)
    assert payload["tested_boundary_powers"] == [23, 23]
    record = records[23, 2]
    assert record["point_degree"] == 29
    assert record["central_kernel_dimension"] == 3
    assert record["residual_rank_on_central_kernel"] == 0
    assert record["survivor_dimension_after_residual"] == 3
    assert record["D_L_times_degree_minus_3_dimension"] == 0
    assert record["survivor_equals_D_L_multiple"] is False
    assert record["central_quotient_landing_projectively_empty"] is True
    assert record["boundary_value_landing_projectively_empty"] is False

    characters = json.loads(
        (
            PROBLEM
            / "tmp/symbolic_compatibility_complex/point_symbolic/character_results.json"
        ).read_text()
    )
    table = characters["residual_point_characters"]["D12"]["3"]
    degrees = sorted(int(degree) for degree in table)
    assert degrees == list(range(6, 29))
    assert table["28"]["dimension"] == 1


def main() -> None:
    check_hashes()
    with tempfile.TemporaryDirectory(prefix="goal_g_boundary_") as temporary:
        temporary = Path(temporary)
        low = rebuild(temporary / "low.json", 4, 3, 3)
        high = rebuild(temporary / "high.json", 23, 1, 2)
    check_low_residues(low)
    check_residual_termination(high)
    print("PASS authoritative boundary input hashes")
    print("PASS boundary-power residues 4,5,6 reconstructed")
    print("PASS line degrees 2,3: whole-line empty but boundary-value nonempty")
    print("PASS finite D12 residual ends in degree 28")
    print("PASS degree-29 linear survivor is not a D_L multiple")
    print("SCOPE split F_67 boundary frontier; no headline or characteristic-zero decision")
    print("G_LINE_BOUNDARY_RECURRENCE_FRONTIER_OK")


if __name__ == "__main__":
    main()
