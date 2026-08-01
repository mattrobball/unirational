#!/usr/bin/env python3
"""Solve a cyclotomic conjugate of the degree-12 ambient chart over F_23."""

from __future__ import annotations

import argparse
import hashlib
import json
import runpy
import subprocess
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
P = 23


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--zeta", type=int, required=True)
    args = parser.parse_args()
    zeta = args.zeta % P
    assert zeta != 1 and pow(zeta, 11, P) == 1
    stem = f"ambient_degree12_zeta{zeta:02d}_a47"
    source = HERE / f"{stem}.in"
    output = HERE / f"{stem}.rur"
    metadata = HERE / f"{stem}.json"

    fw = runpy.run_path(str(ROOT / "tmp" / "pfaffian_rank2_idempotent_attack" / "full_wedge.py"))
    fw_globals = fw["FullWedgeScanner"].__init__.__globals__
    fw_globals["P"] = P
    fano_namespace = fw_globals["fano"]
    fano_globals = fano_namespace["six_dimensional_generators"].__globals__
    fano_globals["P"] = P
    fano_globals["ZETA"] = zeta
    assert fano_namespace["six_dimensional_generators"].__globals__["ZETA"] == zeta
    generator_digest = hashlib.sha256(
        bytes(fano_namespace["six_dimensional_generators"]()[0].astype("uint8"))
    ).hexdigest()
    scanner = fw["FullWedgeScanner"]()
    seeds = scanner.covariant_basis(12)
    expected = json.loads((HERE / "ambient_degree12_a47_chart.json").read_text())["seeds"]
    assert [[int(index), list(exponents)] for index, exponents in seeds] == expected
    equations = scanner.landing_equations(seeds, extra_points=180)
    rows = [row for _pivot, row in equations]
    assert len(rows) == 471
    text = fw["msolve_input"](rows, 48).rstrip()
    lines = text.splitlines()
    lines[0] = ",".join(["a47", *[f"a{i}" for i in range(1, 47)], "a0"])
    source.write_text("\n".join(lines) + ",\na47-1\n")
    print(f"BEGIN zeta={zeta} input={source.name}", flush=True)
    command = [
        "msolve", "-f", str(source), "-o", str(output), "-t", "4",
        "-v", "1", "-l", "2", "--random-seed", "0", "-c", "0",
    ]
    completed = subprocess.run(command, cwd=ROOT, timeout=1200, check=False)
    assert completed.returncode == 0, completed.returncode
    assert output.is_file() and output.stat().st_size > 0
    rur = output.read_text()
    assert rur.lstrip().startswith("[0,")
    metadata.write_text(json.dumps({
        "prime": P,
        "zeta11": zeta,
        "degree": 12,
        "dimension": 48,
        "quadratic_rank": 471,
        "chart": "a47=1",
        "first_generator_sha256": generator_digest,
        "rur_bytes": len(rur.encode()),
    }, indent=2) + "\n")
    print(f"WROTE {output}", flush=True)
    print(f"AMBIENT-D12-CONJUGATE-RUR-{zeta}", flush=True)


if __name__ == "__main__":
    main()
