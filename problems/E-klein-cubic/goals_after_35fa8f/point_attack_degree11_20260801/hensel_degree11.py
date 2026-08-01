#!/usr/bin/env python3
"""Smooth F_89 diagnostics for the exact degree-11 landing schemes.

The exact Reynolds covariants are constructed by ``exact_degree11.py`` and
then reduced at the split prime

    sqrt(5) -> 19,  sqrt(-11) -> 73  (mod 89).

For each of the two exact Klein pencil parameters this script computes the
complete landing equations, finds an F_89 point on the a0=1 chart, and
certifies a nonzero 4x4 Jacobian minor.  This does *not* by itself prove a
characteristic-zero point, because the other landing equations could create
vertical torsion.  The exact proof is ``exact_six_rref.py``.
"""

from __future__ import annotations

import hashlib
import importlib.util
import json
from pathlib import Path
import subprocess
import sys

import sympy as sp


HERE = Path(__file__).resolve().parent


def import_file(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


exact = import_file("h3_exact_degree11", HERE / "exact_degree11.py")
modular = import_file("h3_canonical_modp", HERE / "canonical_modp.py")
low = modular.low
landing = modular.landing


P = 89
SQRT5 = 19
SQRT_MINUS11 = 73
assert SQRT5 * SQRT5 % P == 5
assert SQRT_MINUS11 * SQRT_MINUS11 % P == -11 % P


def reduce_covariants(covariants):
    mons = low.monomials(11)
    assert tuple(mons) == tuple(exact.MONS11)
    return [
        [
            [
                exact.qmod(covariant[output].get(exponent, exact.ZERO), P, SQRT5)
                for exponent in mons
            ]
            for output in range(5)
        ]
        for covariant in covariants
    ]


def cubic_for_class(class_index):
    inverse18 = pow(18, -1, P)
    radical = -SQRT_MINUS11 if class_index == 1 else SQRT_MINUS11
    lam = (13 + radical) * inverse18 % P
    assert lam == (56 if class_index == 1 else 74)
    first, second = exact.canonical.CUBIC_BASIS
    cubic = {}
    for exponent in exact.canonical.MONS3:
        coefficient = (first.get(exponent, 0) + lam * second.get(exponent, 0)) % P
        if coefficient:
            cubic[exponent] = coefficient
    return lam, cubic


def chart_expression(polynomial):
    # a0=1 and variables a1,...,a4.
    terms = []
    for exponent, coefficient in polynomial.items():
        coefficient %= P
        if not coefficient:
            continue
        signed = coefficient if coefficient <= P // 2 else coefficient - P
        factors = []
        for index, power in enumerate(exponent[1:], 1):
            if power:
                factors.append(f"a{index}" if power == 1 else f"a{index}^{power}")
        terms.append(f"({signed})*{'*'.join(factors) if factors else '1'}")
    return "+".join(terms) if terms else "0"


def lex_groebner(class_index, equations):
    input_path = HERE / f"class_{class_index}_lex.sing"
    output_path = HERE / f"class_{class_index}_lex.txt"
    expressions = [chart_expression(polynomial) for polynomial in equations.values()]
    expressions = [expression for expression in expressions if expression != "0"]
    content = (
        f"ring r={P},(a1,a2,a3,a4),lp;\n"
        f"ideal I={','.join(expressions)};\n"
        "ideal J=std(I);\n"
        'if (reduce(1,J)==0) { print("UNIT"); } else { print("NONUNIT"); J; }\n'
        "quit;\n"
    )
    input_path.write_text(content)
    result = subprocess.run(
        ["/opt/homebrew/bin/Singular", "-q", str(input_path)],
        check=True,
        capture_output=True,
        text=True,
    )
    output_path.write_text(result.stdout)
    assert result.stdout.splitlines()[0].strip() == "NONUNIT"
    variables = sp.symbols("a1:5")
    locals_map = {str(variable): variable for variable in variables}
    polynomials = []
    for line in result.stdout.splitlines()[1:]:
        if "=" not in line:
            continue
        expression = line.split("=", 1)[1].replace("^", "**")
        polynomials.append(sp.Poly(sp.sympify(expression, locals=locals_map), *variables, modulus=P))
    assert polynomials
    return input_path, output_path, polynomials


def evaluate(poly, assignment):
    return int(poly.as_expr().subs(assignment)) % P


def find_point(lex_polynomials):
    a1, a2, a3, a4 = sp.symbols("a1:5")
    assignments = [{}]
    # Lex order yields a triangular basis; enumerate from the last variable.
    for variable in (a4, a3, a2, a1):
        expanded = []
        for assignment in assignments:
            for value in range(P):
                candidate = dict(assignment)
                candidate[variable] = value
                relevant = [
                    polynomial for polynomial in lex_polynomials
                    if polynomial.as_expr().free_symbols <= set(candidate)
                ]
                if all(evaluate(polynomial, candidate) == 0 for polynomial in relevant):
                    expanded.append(candidate)
        assignments = expanded
        assert assignments, f"no partial assignment after {variable}"
    complete = [
        assignment for assignment in assignments
        if all(evaluate(polynomial, assignment) == 0 for polynomial in lex_polynomials)
    ]
    assert complete
    assignment = complete[0]
    return [1, assignment[a1], assignment[a2], assignment[a3], assignment[a4]], len(complete)


def eval_parameter_poly(polynomial, point):
    total = 0
    for exponent, coefficient in polynomial.items():
        value = coefficient % P
        for coordinate, power in zip(point, exponent):
            value = value * pow(coordinate, power, P) % P
        total = (total + value) % P
    return total


def gradient(polynomial, point):
    row = []
    for variable in range(1, 5):
        total = 0
        for exponent, coefficient in polynomial.items():
            power = exponent[variable]
            if not power:
                continue
            value = coefficient * power % P
            for index, (coordinate, item_power) in enumerate(zip(point, exponent)):
                if index == variable:
                    item_power -= 1
                value = value * pow(coordinate, item_power, P) % P
            total = (total + value) % P
        row.append(total)
    return row


def determinant(matrix):
    work = [[value % P for value in row] for row in matrix]
    result = 1
    for column in range(len(work)):
        pivot = next((row for row in range(column, len(work)) if work[row][column]), None)
        if pivot is None:
            return 0
        if pivot != column:
            work[column], work[pivot] = work[pivot], work[column]
            result = -result
        value = work[column][column] % P
        result = result * value % P
        inverse = pow(value, -1, P)
        for row in range(column + 1, len(work)):
            scalar = work[row][column] * inverse % P
            work[row] = [(a - scalar * b) % P for a, b in zip(work[row], work[column])]
    return result % P


def jacobian_minor(equations, point):
    selected = []
    selected_labels = []
    rank = 0
    for label, polynomial in sorted(equations.items()):
        row = gradient(polynomial, point)
        candidate = selected + [row]
        matrix = sp.Matrix(candidate)
        new_rank = modular.low.nullspace_mod([]) if False else None
        # Rank modulo P by checking row echelon directly.
        work = [[value % P for value in item] for item in candidate]
        pivot_row = 0
        for column in range(4):
            pivot = next((i for i in range(pivot_row, len(work)) if work[i][column]), None)
            if pivot is None:
                continue
            work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
            inverse = pow(work[pivot_row][column], -1, P)
            work[pivot_row] = [inverse * value % P for value in work[pivot_row]]
            for i in range(len(work)):
                if i != pivot_row and work[i][column]:
                    scalar = work[i][column]
                    work[i] = [(a - scalar * b) % P for a, b in zip(work[i], work[pivot_row])]
            pivot_row += 1
        if pivot_row > rank:
            selected.append(row)
            selected_labels.append(label)
            rank = pivot_row
            if rank == 4:
                break
    assert rank == 4
    det = determinant(selected)
    assert det
    return selected_labels, selected, det


def run_class(space, class_index):
    lam, cubic = cubic_for_class(class_index)
    low.P = P
    landing.P = P
    equations = modular.general_landing_equations(space, cubic, 11, P)
    assert len(equations) == 468
    input_path, output_path, lex_polynomials = lex_groebner(class_index, equations)
    point, rational_point_count = find_point(lex_polynomials)
    assert all(eval_parameter_poly(polynomial, point) == 0 for polynomial in equations.values())
    labels, rows, det = jacobian_minor(equations, point)
    payload = {
        "format": "h3-a5-degree11-smooth-special-fibre-diagnostic-v2",
        "class": class_index,
        "degree": 11,
        "covariant_dimension": 5,
        "prime": P,
        "residue_embeddings": {"sqrt5": SQRT5, "sqrt_minus11": SQRT_MINUS11},
        "pencil_parameter_mod_89": lam,
        "chart": "a0=1",
        "point": point,
        "all_468_landing_equations_vanish": True,
        "lex_basis": [str(poly.as_expr()).replace("**", "^") for poly in lex_polynomials],
        "f89_points_found_on_chart": rational_point_count,
        "jacobian_variables": ["a1", "a2", "a3", "a4"],
        "jacobian_source_exponents": [list(label) for label in labels],
        "jacobian_rows_mod_89": rows,
        "jacobian_determinant_mod_89": det,
        "singular_input": input_path.name,
        "singular_input_sha256": hashlib.sha256(input_path.read_bytes()).hexdigest(),
        "singular_output": output_path.name,
        "singular_output_sha256": hashlib.sha256(output_path.read_bytes()).hexdigest(),
        "scope_warning": (
            "The smooth special-fibre point alone is not a characteristic-zero "
            "transfer: the remaining equations could impose vertical torsion. "
            "Consume exact_six_rref.py and its NONUNIT lex certificates instead."
        ),
    }
    output = HERE / f"class_{class_index}_hensel.json"
    output.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(
        f"class={class_index} point={point} jacobian_det={det} "
        f"chart_points={rational_point_count}",
        flush=True,
    )
    print("wrote", output, flush=True)


def main():
    covariants, seeds, actions = exact.reynolds_basis()
    exact.verify_covariance(covariants, actions)
    space = reduce_covariants(covariants)
    for class_index in (1, 2):
        run_class(space, class_index)
    print("H3_A5_DEGREE11_SPECIAL_FIBRE_DIAGNOSTIC_ONLY")


if __name__ == "__main__":
    main()
