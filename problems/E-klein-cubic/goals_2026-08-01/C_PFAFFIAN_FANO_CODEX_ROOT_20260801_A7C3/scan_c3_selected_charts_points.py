#!/usr/bin/env python3
"""Holdout-point screen for residue-root zero charts in the Morita model."""

from __future__ import annotations

import json
import runpy
import subprocess
import tempfile
from pathlib import Path

import numpy as np

import scan_c3_morita_zero_charts as charts
import search_c3_constant_morita as base


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
P = 23
ZETA = 2
SELECTED = ((4, 5, 7), (8, 9, 10), (8, 10, 11), (9, 10, 11))


def main():
    c2_payload = json.loads((HERE / "c2_morita.json").read_text())
    root_vector = json.loads((HERE / "ambient_degree12_points_p23.json").read_text())["checks"][0]["coefficient_vector"]
    fw = runpy.run_path(str(ROOT / "tmp" / "pfaffian_rank2_idempotent_attack" / "full_wedge.py"))
    scanner = fw["FullWedgeScanner"]()
    seeds = [(int(o), tuple(e)) for o, e in json.loads((HERE / "ambient_degree12_a47_chart.json").read_text())["seeds"]]
    fano = fw["fano"]
    six = fano["six_dimensional_generators"]()
    dual = tuple(fano["inv"](generator).T % P for generator in six)
    dual_wedge = tuple(fano["exterior_square"](generator) for generator in dual)
    domain_basis, _ = fano["invariant_summands"](dual_wedge)
    pairs6 = tuple(fano["PAIR_INDEX"])
    c3 = runpy.run_path(str(ROOT / "certificates" / "fano_c3" / "produce_c3.py"))
    c2 = c3["load_c2_helpers"]()
    algebra = base.AlgebraFrameEvaluator(c2)
    phi = runpy.run_path(str(ROOT / "tmp" / "generic_twist" / "phi_coefficients.py"))
    _names, hilbert_frame, _ = phi["all_coefficients"]()
    corner_labels = c2_payload["corner"]["basis_circuits"]
    generator_labels = c2_payload["morita"]["basis_generator_circuits"]
    rng = np.random.default_rng(20260802)
    point_candidates = [
        tuple(int(value) for value in rng.integers(0, P, size=5)) for _ in range(120)
    ]
    records = []
    with tempfile.TemporaryDirectory(prefix="c3-selected-chart-points-") as directory:
        temporary = Path(directory)
        for point_tuple in point_candidates:
            point = np.array(point_tuple, dtype=np.int64)
            ambient = np.stack([scanner.evaluate_seed(output, exponents, point) for output, exponents in seeds])
            wedge = np.array(root_vector, dtype=np.int64) @ ambient % P
            q_values = domain_basis @ point % P
            q = base.skew(q_values, pairs6)
            try:
                qinv = base.inv(q)
            except ValueError:
                continue
            pairing = int(np.dot(q_values, wedge) % P)
            if not pairing:
                continue
            e = -base.skew(wedge, pairs6) @ q * pow(pairing, -1, P) % P
            if not np.array_equal(e @ e % P, e):
                continue
            try:
                matrices = algebra.evaluate(point_tuple)
            except ValueError:
                continue
            corner = [
                e if label["kind"] == "projector" else e @ matrices[label["frame_index"]] @ e % P
                for label in corner_labels
            ]
            if base.rank(corner) != 4:
                continue
            identity = np.eye(6, dtype=np.int64) % P
            generators = [
                identity if label["kind"] == "identity" else matrices[label["frame_index"]]
                for label in generator_labels
            ]
            module_basis = [generator @ e @ d % P for generator in generators for d in corner]
            if base.rank(module_basis) != 12:
                continue
            sigma = lambda matrix: qinv @ matrix.T @ q % P
            forms = []
            for vector in hilbert_frame:
                value = np.array([int(phi["evaluate"](component, point_tuple)) % P for component in vector])
                section = qinv @ base.skew(domain_basis @ value % P, pairs6) % P
                matrix_rows = base.quadratic_matrix_rows(module_basis, sigma, section)
                row = next(candidate for candidate in matrix_rows if np.any(candidate))
                forms.append(row)
            assert len(forms) == 5
            point_record = {"point": list(point_tuple), "charts": []}
            for zero in SELECTED:
                free = [variable for variable in range(4, 12) if variable not in zero]
                source = temporary / "chart.in"
                answer = temporary / "chart.out"
                pairs12 = base.coefficient_pairs(12)
                source.write_text(
                    ",".join(f"u{index}" for index in range(5)) + f"\n{P}\n"
                    + ",\n".join(charts.polynomial(form, pairs12, free) for form in forms) + "\n"
                )
                completed = subprocess.run(
                    ["msolve", "-f", str(source), "-o", str(answer), "-t", "2", "-v", "0", "-l", "2", "--random-seed", "0"],
                    cwd=HERE, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, check=False,
                )
                assert completed.returncode == 0 and answer.is_file(), completed.stdout
                try:
                    result = charts.parse_result(answer.read_text())
                except AssertionError:
                    print("UNPARSED", answer.read_text(), flush=True)
                    raise
                result["zero_coordinates"] = list(zero)
                point_record["charts"].append(result)
            records.append(point_record)
            print(
                f"point={point_tuple} roots={[row['rational_roots'] for row in point_record['charts']]}",
                flush=True,
            )
            if len(records) == 12:
                break
    assert len(records) == 12
    survivors = []
    for chart_index, zero in enumerate(SELECTED):
        if all(record["charts"][chart_index]["rational_roots"] for record in records):
            survivors.append(list(zero))
    output = {
        "format": "c3-selected-zero-charts-holdout-p23-v1",
        "scope": "four selected coordinate-zero chart formulas only",
        "prime": P,
        "zeta11": ZETA,
        "records": records,
        "charts_with_a_rational_root_at_every_regular_point": survivors,
        "theorem_boundary": "rejects only the selected chart patterns; no conclusion about arbitrary D^3 lines",
    }
    path = HERE / "c3_selected_zero_charts_holdout_p23.json"
    path.write_text(json.dumps(output, indent=2) + "\n")
    print(f"survivors={survivors}")
    print(f"WROTE {path}")
    print("C3-SELECTED-ZERO-CHART-HOLDOUT-SCREEN-COMPLETED")


if __name__ == "__main__":
    main()
