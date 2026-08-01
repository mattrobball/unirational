#!/usr/bin/env python3
"""Scan 56 zero-dimensional subcharts of q=(1,x,y) at the C2 good fibre."""

from __future__ import annotations

import ast
import itertools
import json
import subprocess
import tempfile
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
P = 23


def multiplication(table, left, right):
    answer = np.zeros(4, dtype=np.int64)
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            if a and b:
                answer += int(a) * int(b) * np.array(table[i][j], dtype=np.int64)
    return answer % P


def quadratic_forms(payload):
    witness = payload["good_fibre_witness"]
    table = witness["corner_multiplication_left_right_coordinates"]
    star = np.array(witness["corner_star_matrix_columns"], dtype=np.int64) % P
    hermitian = witness["hermitian_matrices_D_coordinates"]
    units = [np.eye(4, dtype=np.int64)[index] for index in range(4)]
    starred = [star @ unit % P for unit in units]
    pairs = [(left, right) for left in range(12) for right in range(left, 12)]
    forms = []
    for matrix in hermitian:
        coefficients = []
        for left, right in pairs:
            lr, la = divmod(left, 4)
            rr, ra = divmod(right, 4)

            def term(row, a, column, b):
                first = multiplication(table, starred[a], matrix[row][column])
                return multiplication(table, first, units[b])

            value = term(lr, la, rr, ra)
            if left != right:
                value = (value + term(rr, ra, lr, la)) % P
            assert not any(value[1:]), (left, right, value.tolist())
            coefficients.append(int(value[0]))
        forms.append(coefficients)
    return pairs, forms


def polynomial(form, pairs, free):
    # z0=1; z1,z2,z3 and the selected extra coordinates are zero.
    free_index = {variable: index for index, variable in enumerate(free)}
    terms = {}
    for coefficient, (left, right) in zip(form, pairs):
        coefficient %= P
        if not coefficient:
            continue
        if left == 0 and right == 0:
            key = ()
        elif left == 0 and right in free_index:
            key = (free_index[right],)
        elif left in free_index and right in free_index:
            key = tuple(sorted((free_index[left], free_index[right])))
        else:
            continue
        terms[key] = (terms.get(key, 0) + coefficient) % P
    expressions = []
    for key in sorted(terms, key=lambda item: (len(item), item), reverse=True):
        coefficient = terms[key] % P
        if not coefficient:
            continue
        factors = [str(coefficient)] if coefficient != 1 or not key else []
        for variable, group in itertools.groupby(key):
            exponent = len(list(group))
            factors.append(f"u{variable}" if exponent == 1 else f"u{variable}^{exponent}")
        expressions.append("*".join(factors))
    return "+".join(expressions) or "0"


def parse_result(text):
    stripped = text.strip().rstrip(":")
    if stripped == "[-1]":
        return {"kind": "empty", "degree": 0, "rational_roots": []}
    data = ast.literal_eval(stripped)
    if data[0] == 1:
        return {"kind": "positive_dimensional", "degree": None, "rational_roots": []}
    assert data[0] == 0
    prime, variables, degree, names, linear_form, tail = data[1]
    # msolve may add its genericity variable A, making this six.
    assert prime == P and 1 <= variables <= 6
    eliminant = tail[1][0][1]

    def evaluate(coefficients, value):
        return sum(int(coefficient) * pow(value, exponent, P) for exponent, coefficient in enumerate(coefficients)) % P

    roots = [value for value in range(P) if evaluate(eliminant, value) == 0]
    return {
        "kind": "zero_dimensional",
        "degree": degree,
        "parameter_variable": names[-1],
        "linear_form": linear_form,
        "eliminant_coefficients_ascending": eliminant,
        "rational_roots": roots,
    }


def main():
    payload = json.loads((HERE / "c2_morita.json").read_text())
    pairs, forms = quadratic_forms(payload)
    candidates = list(range(4, 12))
    records = []
    with tempfile.TemporaryDirectory(prefix="c3-morita-zero-charts-") as directory:
        temporary = Path(directory)
        for zero in itertools.combinations(candidates, 3):
            free = [variable for variable in candidates if variable not in zero]
            source = temporary / "chart.in"
            answer = temporary / "chart.out"
            source.write_text(
                ",".join(f"u{index}" for index in range(5))
                + f"\n{P}\n"
                + ",\n".join(polynomial(form, pairs, free) for form in forms)
                + "\n"
            )
            completed = subprocess.run(
                ["msolve", "-f", str(source), "-o", str(answer), "-t", "2", "-v", "0", "-l", "2", "--random-seed", "0"],
                cwd=HERE,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                text=True,
                check=False,
            )
            assert completed.returncode == 0 and answer.is_file(), completed.stdout
            result = parse_result(answer.read_text())
            result.update({"zero_coordinates": list(zero), "free_coordinates": free})
            records.append(result)
            print(
                f"zero={zero} kind={result['kind']} degree={result['degree']} roots={result['rational_roots']}",
                flush=True,
            )
    summary = {
        "format": "c3-morita-zero-chart-scan-p23-v1",
        "scope": "one split good fibre; discovery only",
        "prime": P,
        "zeta11": 2,
        "point": [1, 2, 3, 4, 5],
        "normalization": "q_first_D_coordinate=e; its other three D coordinates are zero",
        "charts": records,
        "counts": {
            kind: sum(record["kind"] == kind for record in records)
            for kind in ("empty", "zero_dimensional", "positive_dimensional")
        },
        "minimum_nonzero_degree": min(
            (record["degree"] for record in records if record["degree"]), default=None
        ),
        "theorem_boundary": "a residue root is not a K_proj common line without characteristic-zero reconstruction and global verification",
    }
    output = HERE / "c3_morita_zero_chart_scan_p23.json"
    output.write_text(json.dumps(summary, indent=2) + "\n")
    print(f"WROTE {output}")
    print("C3-MORITA-ZERO-CHART-SCAN-COMPLETED")


if __name__ == "__main__":
    main()
