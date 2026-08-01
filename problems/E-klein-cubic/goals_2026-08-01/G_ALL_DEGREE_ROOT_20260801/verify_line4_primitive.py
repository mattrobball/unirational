#!/usr/bin/env python3
"""Reconstruct and independently certify the degree-four primitive charts.

The chart linear forms are eliminated symbolically before either solver is
called.  This avoids msolve's unsafe affine-linear coordinate preprocessing.
Both msolve and Singular must then return the unit ideal on all three charts.
"""

from __future__ import annotations

import json
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path


HERE = Path(__file__).resolve().parent
ANALYZER = HERE / "analyze_line_boundary_recurrence.py"
EXPECTED_ELIMINATED = ["z_6", "z_9", "z_10"]


def run(command: list[str]) -> str:
    return subprocess.run(
        command,
        check=True,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    ).stdout


def noncomment_payload(path: Path) -> str:
    return "\n".join(
        line.strip()
        for line in path.read_text().splitlines()
        if line.strip() and not line.startswith("#")
    )


def main() -> None:
    msolve = shutil.which("msolve")
    singular = shutil.which("Singular")
    assert msolve is not None, "msolve is required"
    assert singular is not None, "Singular is required"

    with tempfile.TemporaryDirectory(prefix="goal_g_line4_") as temporary:
        temporary = Path(temporary)
        output = temporary / "line4.json"
        run(
            [
                sys.executable,
                str(ANALYZER),
                "--order", "3",
                "--max-line-degree", "4",
                "--boundary-power-start", "4",
                "--power-count", "1",
                "--emit-m2-line-degree", "4",
                "--emit-directory", str(temporary),
                "--output", str(output),
            ]
        )
        payload = json.loads(output.read_text())
        record = next(
            record for record in payload["records"] if record["line_degree"] == 4
        )
        assert record["source_dimension"] == 19
        assert record["central_equation_rank"] == 8
        assert record["central_kernel_dimension"] == 11
        assert record["D_L_times_degree_minus_3_dimension"] == 8
        assert record["central_quotient_landing_row_rank"] == 24

        for chart, eliminated in enumerate(EXPECTED_ELIMINATED):
            stem = temporary / (
                "m3_line4_central_landing_primitive_elim_chart" + str(chart)
            )
            stored_stem = HERE / stem.name
            for suffix in (".ms", ".m2", ".sing"):
                assert stem.with_suffix(suffix).read_bytes() == stored_stem.with_suffix(
                    suffix
                ).read_bytes(), (chart, suffix)

            gb_path = stem.with_suffix(".gb")
            run(
                [
                    msolve,
                    "-g", "2",
                    "-c", "0",
                    "--random-seed", "0",
                    "-f", str(stem.with_suffix(".ms")),
                    "-o", str(gb_path),
                ]
            )
            assert noncomment_payload(gb_path) == "[1]:", chart
            assert gb_path.read_bytes() == stored_stem.with_suffix(".gb").read_bytes()

            singular_output = run([singular, str(stem.with_suffix(".sing"))])
            marker = (
                f"SINGULAR_CHART\n{chart}\n"
                f"ELIMINATED_VARIABLE\n{eliminated}\n"
                "SINGULAR_NF1\n0\nSINGULAR_DIM\n-1"
            )
            assert marker in singular_output, (chart, singular_output)

    print("PASS reconstructed line-degree-four source 19 -> central kernel 11")
    print("PASS D_L-multiple subspace dimension 8 and primitive quotient dimension 3")
    print("PASS all three eliminated affine charts are unit ideals in msolve")
    print("PASS all three eliminated affine charts are unit ideals in Singular")
    print("SCOPE split F_67 first transverse layer; inherited D_L multiples remain")
    print("M3_LINE4_PRIMITIVE_EMPTY_OK")


if __name__ == "__main__":
    main()
