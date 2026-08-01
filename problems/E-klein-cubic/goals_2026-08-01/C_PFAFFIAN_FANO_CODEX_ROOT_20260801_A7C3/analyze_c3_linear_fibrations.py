#!/usr/bin/env python3
"""Analyze linear fibrations of the normalized Morita common-line chart.

At the primary good fibre put the first quaternion coordinate equal to 1.
This leaves five quadrics in eight scalar variables.  For every largest set
of variables which never multiply each other, the equations are jointly
linear in that set.  When the set has four variables, consistency is the
determinant of a 5 by 5 augmented matrix.  Factoring those determinants is a
cheap structural search for rational sections of the genuine C3 system.
"""

from __future__ import annotations

import itertools
import json
import re
import subprocess
from pathlib import Path

import numpy as np
import sympy as sp

import scan_c3_morita_zero_charts as charts


HERE = Path(__file__).resolve().parent
P = 23
VARIABLES = tuple(range(4, 12))


def normalized_terms(form, pairs):
    """Return {(variable indices): coefficient} after q_0=1,q_1=q_2=q_3=0."""
    terms: dict[tuple[int, ...], int] = {}
    for coefficient, (left, right) in zip(form, pairs):
        coefficient %= P
        if not coefficient:
            continue
        if left == 0 and right == 0:
            key = ()
        elif left == 0 and right in VARIABLES:
            key = (right,)
        elif left in VARIABLES and right in VARIABLES:
            key = (left, right)
        else:
            continue
        terms[key] = (terms.get(key, 0) + coefficient) % P
    return {key: value for key, value in terms.items() if value}


def linearizing_subsets(forms):
    result = []
    for size in range(len(VARIABLES), 0, -1):
        for subset in itertools.combinations(VARIABLES, size):
            chosen = set(subset)
            if all(
                not (len(key) == 2 and key[0] in chosen and key[1] in chosen)
                for form in forms
                for key in form
            ):
                result.append(subset)
        if result:
            return result
    raise AssertionError("no nonempty linearizing subset")


def expression(terms, symbols):
    answer = 0
    for key, coefficient in terms.items():
        monomial = 1
        for variable in key:
            monomial *= symbols[variable]
        answer += coefficient * monomial
    return sp.Poly(answer, *symbols.values(), modulus=P).as_expr()


def split_coordinate_change(witness):
    """Return old-corner coordinates as linear forms in 2x2 matrix entries."""
    corner = [np.array(value, dtype=np.int64) % P for value in witness["corner_basis_values"]]
    projector = corner[0]
    image_columns = None
    for left, right in itertools.combinations(range(6), 2):
        candidate = projector[:, [left, right]] % P
        if any(
            (int(candidate[top, 0]) * int(candidate[bottom, 1])
             - int(candidate[top, 1]) * int(candidate[bottom, 0])) % P
            for top, bottom in itertools.combinations(range(6), 2)
        ):
            image_columns = candidate
            break
    assert image_columns is not None
    pivot_rows = None
    for top, bottom in itertools.combinations(range(6), 2):
        minor = image_columns[[top, bottom], :] % P
        determinant = int(round(np.linalg.det(minor.astype(float)))) % P
        if determinant:
            pivot_rows = (top, bottom)
            break
    assert pivot_rows is not None
    minor = sp.Matrix(image_columns[list(pivot_rows), :].tolist())
    inverse_minor = minor.inv_mod(P)
    representation_columns = []
    for value in corner:
        restricted = inverse_minor * sp.Matrix((value @ image_columns % P)[list(pivot_rows), :].tolist())
        # Row-major entries of the 2 by 2 matrix.
        representation_columns.append(
            [int(restricted[row, column]) % P for row in range(2) for column in range(2)]
        )
    representation = sp.Matrix(4, 4, lambda row, column: representation_columns[column][row])
    assert int(representation.det()) % P
    old_from_entries = representation.inv_mod(P)
    # Directly verify d B = B rho(d) for each corner basis element.
    for value, column in zip(corner, representation_columns):
        matrix = np.array(column, dtype=np.int64).reshape(2, 2) % P
        assert np.array_equal(value @ image_columns % P, image_columns @ matrix % P)
    return [[int(old_from_entries[row, column]) % P for column in range(4)] for row in range(4)]


def terms_from_expression(value, symbols):
    polynomial = sp.Poly(value, *(symbols[variable] for variable in VARIABLES), modulus=P)
    result = {}
    for exponents, coefficient in polynomial.terms():
        key = []
        for variable, exponent in zip(VARIABLES, exponents):
            key.extend([variable] * exponent)
        result[tuple(key)] = int(coefficient) % P
    return result


def singular_factor(polynomial, parameter_symbols):
    names = ",".join(str(symbol) for symbol in parameter_symbols)
    source = (
        f"ring r={P},({names}),dp;\n"
        f"poly f={str(polynomial.as_expr()).replace('**', '^')};\n"
        'list L=factorize(f); print("FACTOR-BEGIN"); L; print("FACTOR-END");\n'
    )
    completed = subprocess.run(
        ["Singular", "-q"], input=source, text=True,
        stdout=subprocess.PIPE, stderr=subprocess.STDOUT, check=False,
    )
    assert completed.returncode == 0, completed.stdout
    match = re.search(r"FACTOR-BEGIN\n(.*?)FACTOR-END", completed.stdout, re.S)
    assert match is not None, completed.stdout
    body = match.group(1)
    factor_part, exponent_part = body.split("[2]:", 1)
    raw_factors = [
        expression.strip()
        for _index, expression in re.findall(r"_\[(\d+)\]=(.*)", factor_part)
    ]
    exponent_line = next(line.strip() for line in exponent_part.splitlines() if line.strip())
    exponents = [int(value) for value in exponent_line.split(",")]
    assert len(raw_factors) == len(exponents)
    parsed = [
        sp.Poly(sp.sympify(value.replace("^", "**")), *parameter_symbols, modulus=P)
        for value in raw_factors
    ]
    product = sp.Poly(1, *parameter_symbols, modulus=P)
    for factor, exponent in zip(parsed, exponents):
        product *= factor ** exponent
    assert product.monic() == polynomial.monic()
    unit = int(parsed[0].LC()) % P
    records = [
        {
            "total_degree": int(factor.total_degree()),
            "exponent": int(exponent),
            "expression": str(factor.as_expr()),
        }
        for factor, exponent in zip(parsed[1:], exponents[1:])
    ]
    return unit, records


def projective_points(size):
    for pivot in range(size):
        for tail in itertools.product(range(P), repeat=size - pivot - 1):
            yield (0,) * pivot + (1,) + tail


def evaluate_poly(polynomial, values):
    answer = 0
    for exponents, coefficient in polynomial.terms():
        term = int(coefficient)
        for value, exponent in zip(values, exponents):
            term *= pow(int(value), int(exponent), P)
        answer += term
    return answer % P


def main():
    payload = json.loads((HERE / "c2_morita.json").read_text())
    pairs, coefficient_forms = charts.quadratic_forms(payload)
    old_forms = [normalized_terms(form, pairs) for form in coefficient_forms]
    old_symbols = {variable: sp.Symbol(f"u{variable}") for variable in VARIABLES}
    symbols = {variable: sp.Symbol(f"z{variable}") for variable in VARIABLES}
    old_from_entries = split_coordinate_change(payload["good_fibre_witness"])
    substitution = {}
    for block_start in (4, 8):
        for old_offset in range(4):
            substitution[old_symbols[block_start + old_offset]] = sum(
                old_from_entries[old_offset][new_offset] * symbols[block_start + new_offset]
                for new_offset in range(4)
            )
    expressions = [
        sp.Poly(expression(form, old_symbols).subs(substitution), *(symbols[v] for v in VARIABLES), modulus=P).as_expr()
        for form in old_forms
    ]
    forms = [terms_from_expression(value, symbols) for value in expressions]
    subsets = linearizing_subsets(forms)
    maximum = len(subsets[0])
    print(f"maximumJointLinearVariableCount={maximum}")
    print(f"maximumSubsetCount={len(subsets)}")
    records = []
    if maximum == 4:
        for subset in subsets:
            parameters = tuple(variable for variable in VARIABLES if variable not in subset)
            zero_substitution = {symbols[variable]: 0 for variable in subset}
            rows = []
            for equation in expressions:
                coefficients = [sp.diff(equation, symbols[variable]) for variable in subset]
                constant = sp.expand(equation.subs(zero_substitution))
                rows.append(coefficients + [constant])
            determinant = sp.Poly(sp.det(sp.Matrix(rows)), *(symbols[v] for v in parameters), modulus=P)
            coefficient, factor_degrees = singular_factor(
                determinant, tuple(symbols[v] for v in parameters)
            )
            derivatives = [determinant.diff(symbols[v]) for v in parameters]
            rational_points = []
            singular_points = []
            for point in projective_points(len(parameters)):
                if evaluate_poly(determinant, point):
                    continue
                rational_points.append(list(point))
                if all(not evaluate_poly(derivative, point) for derivative in derivatives):
                    singular_points.append(list(point))
            record = {
                "linear_variables": list(subset),
                "parameter_variables": list(parameters),
                "determinant_total_degree": int(determinant.total_degree()),
                "determinant_term_count": len(determinant.terms()),
                "factor_unit": coefficient,
                "factors": factor_degrees,
                "projective_rational_point_count": len(rational_points),
                "first_projective_rational_points": rational_points[:20],
                "projective_singular_point_count": len(singular_points),
                "projective_singular_points": singular_points,
            }
            records.append(record)
            print(
                f"linear={subset} parameters={parameters} degree={determinant.total_degree()} "
                f"terms={len(determinant.terms())} factors="
                f"{[(row['total_degree'], row['exponent']) for row in factor_degrees]} "
                f"points={len(rational_points)} singular={len(singular_points)}",
                flush=True,
            )
    output = {
        "format": "c3-linear-fibration-analysis-p23-v1",
        "scope": "primary split good fibre only; structural discovery",
        "prime": P,
        "zeta11": 2,
        "point": [1, 2, 3, 4, 5],
        "normalization": "first D coordinate equals the corner identity",
        "coordinate_change": {
            "description": "each remaining D coordinate is written in row-major Mat_2(F_23) entries",
            "old_corner_coordinates_from_matrix_entries": old_from_entries,
        },
        "maximum_joint_linear_variable_count": maximum,
        "maximum_linearizing_subsets": [list(subset) for subset in subsets],
        "determinantal_fibrations": records,
        "theorem_boundary": "a special-fibre factor is not a K_proj common line without generic reconstruction and original-equation verification",
    }
    path = HERE / "c3_linear_fibrations_p23.json"
    path.write_text(json.dumps(output, indent=2) + "\n")
    print(f"WROTE {path}")
    print("C3-LINEAR-FIBRATION-SPECIAL-FIBRE-ANALYZED")


if __name__ == "__main__":
    main()
