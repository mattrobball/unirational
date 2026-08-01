#!/usr/bin/env python3
"""Audit whether the displayed F_89 degree-11 points lift modulo 89^2.

This is deliberately stronger than checking a nonzero 4x4 Jacobian minor:
for every F_89 point in the recorded a0=1 lexicographic fibres, it tests the
linearized lifting equations for all 468 landing coefficients at once.
"""

from __future__ import annotations

import importlib.util
from pathlib import Path
import subprocess
import tempfile

import sympy as sp


ROOT = Path(__file__).resolve().parent.parent
ATTACK = ROOT / "point_attack_degree11_20260801"
P = 89
P2 = P * P


def import_file(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


hensel = import_file("h3_hensel_degree11_audit", ATTACK / "hensel_degree11.py")
exact = hensel.exact
modular = hensel.modular
low = hensel.low


def lift_square_root(root: int, radicand: int) -> int:
    """The unique lift mod p^2 of root mod p for an odd unramified prime."""
    error = (root * root - radicand) // P
    correction = -error * pow(2 * root, -1, P) % P
    lifted = root + P * correction
    assert lifted % P == root
    assert (lifted * lifted - radicand) % P2 == 0
    return lifted


SQRT5_P2 = lift_square_root(19, 5)
SQRT_MINUS11_P2 = lift_square_root(16, -11)


def reduce_covariants(covariants):
    mons = low.monomials(11)
    assert tuple(mons) == tuple(exact.MONS11)
    return [
        [
            [
                exact.qmod(covariant[output].get(exponent, exact.ZERO), P2, SQRT5_P2)
                for exponent in mons
            ]
            for output in range(5)
        ]
        for covariant in covariants
    ]


def cubic_for_class(class_index: int):
    radical = -SQRT_MINUS11_P2 if class_index == 1 else SQRT_MINUS11_P2
    lam = (13 + radical) * pow(18, -1, P2) % P2
    first, second = exact.canonical.CUBIC_BASIS
    cubic = {}
    for exponent in exact.canonical.MONS3:
        coefficient = (first.get(exponent, 0) + lam * second.get(exponent, 0)) % P2
        if coefficient:
            cubic[exponent] = coefficient
    return lam, cubic


def parse_lex(class_index: int):
    variables = sp.symbols("a1:5")
    locals_map = {str(variable): variable for variable in variables}
    polynomials = []
    text = (ATTACK / f"class_{class_index}_lex.txt").read_text()
    assert text.splitlines()[0].strip() == "NONUNIT"
    for line in text.splitlines()[1:]:
        if "=" not in line:
            continue
        expression = line.split("=", 1)[1].replace("^", "**")
        polynomials.append(
            sp.Poly(sp.sympify(expression, locals=locals_map), *variables, modulus=P)
        )
    assert polynomials
    return variables, polynomials


def lex_points(class_index: int):
    variables, polynomials = parse_lex(class_index)
    assignments = [{}]
    for variable in reversed(variables):
        expanded = []
        for assignment in assignments:
            for value in range(P):
                candidate = dict(assignment)
                candidate[variable] = value
                relevant = [
                    polynomial
                    for polynomial in polynomials
                    if polynomial.as_expr().free_symbols <= set(candidate)
                ]
                if all(int(poly.as_expr().subs(candidate)) % P == 0 for poly in relevant):
                    expanded.append(candidate)
        assignments = expanded
        assert assignments
    points = []
    for assignment in assignments:
        if all(int(poly.as_expr().subs(assignment)) % P == 0 for poly in polynomials):
            points.append((1,) + tuple(int(assignment[v]) for v in variables))
    return points


def evaluate(polynomial, point, modulus: int):
    total = 0
    for exponent, coefficient in polynomial.items():
        value = coefficient % modulus
        for coordinate, power in zip(point, exponent):
            value = value * pow(coordinate, power, modulus) % modulus
        total = (total + value) % modulus
    return total


def gradient_mod_p(polynomial, point, variable_indices):
    row = []
    for variable in variable_indices:
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


def rank(matrix):
    if not matrix:
        return 0
    work = [[value % P for value in row] for row in matrix]
    pivot_row = 0
    for column in range(len(work[0])):
        pivot = next((i for i in range(pivot_row, len(work)) if work[i][column]), None)
        if pivot is None:
            continue
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        inverse = pow(work[pivot_row][column], -1, P)
        work[pivot_row] = [inverse * value % P for value in work[pivot_row]]
        for i in range(len(work)):
            if i != pivot_row and work[i][column]:
                scalar = work[i][column]
                work[i] = [
                    (a - scalar * b) % P for a, b in zip(work[i], work[pivot_row])
                ]
        pivot_row += 1
    return pivot_row


def audit_point(equations, point, chart):
    variable_indices = tuple(range(chart + 1, 5))
    rows = []
    rhs = []
    labels = []
    for label, polynomial in sorted(equations.items()):
        value = evaluate(polynomial, point, P2)
        assert value % P == 0
        rows.append(gradient_mod_p(polynomial, point, variable_indices))
        rhs.append(-(value // P) % P)
        labels.append(label)
    matrix_rank = rank(rows)
    augmented_rank = rank([row + [value] for row, value in zip(rows, rhs)])
    assert matrix_rank == len(variable_indices)
    if augmented_rank == matrix_rank:
        return {
            "point": point,
            "rank": matrix_rank,
            "augmented_rank": augmented_rank,
            "lifts_mod_89_squared": True,
        }

    # Produce an explicit failing equation after solving an independent square subsystem.
    selected_rows = []
    selected_rhs = []
    selected_labels = []
    for label, row, value in zip(labels, rows, rhs):
        if rank(selected_rows + [row]) > len(selected_rows):
            selected_rows.append(row)
            selected_rhs.append(value)
            selected_labels.append(label)
            if len(selected_rows) == len(variable_indices):
                break
    augmented = [row[:] + [value] for row, value in zip(selected_rows, selected_rhs)]
    dimension = len(variable_indices)
    for column in range(dimension):
        pivot = next(i for i in range(column, dimension) if augmented[i][column] % P)
        augmented[column], augmented[pivot] = augmented[pivot], augmented[column]
        inverse = pow(augmented[column][column], -1, P)
        augmented[column] = [inverse * value % P for value in augmented[column]]
        for i in range(dimension):
            if i != column and augmented[i][column]:
                scalar = augmented[i][column]
                augmented[i] = [
                    (a - scalar * b) % P
                    for a, b in zip(augmented[i], augmented[column])
                ]
    delta = [augmented[i][dimension] for i in range(dimension)]
    failures = [
        (label, (sum(a * d for a, d in zip(row, delta)) - value) % P)
        for label, row, value in zip(labels, rows, rhs)
        if (sum(a * d for a, d in zip(row, delta)) - value) % P
    ]
    assert failures
    return {
        "point": point,
        "rank": matrix_rank,
        "augmented_rank": augmented_rank,
        "lifts_mod_89_squared": False,
        "four_equation_labels": selected_labels,
        "forced_correction": delta,
        "failed_equation_count": len(failures),
        "first_failed_equation": failures[0],
    }


def reduce_equations_mod_p(equations):
    reduced = {}
    for label, polynomial in equations.items():
        row = {
            exponent: coefficient % P
            for exponent, coefficient in polynomial.items()
            if coefficient % P
        }
        if row:
            reduced[label] = row
    return reduced


def expression_on_chart(polynomial, chart):
    terms = []
    for exponent, coefficient in polynomial.items():
        if any(exponent[index] for index in range(chart)):
            continue
        signed = coefficient % P
        if signed > P // 2:
            signed -= P
        factors = []
        for index in range(chart + 1, 5):
            power = exponent[index]
            if power:
                factors.append(f"a{index}" if power == 1 else f"a{index}^{power}")
        terms.append(f"({signed})*{'*'.join(factors) if factors else '1'}")
    return "+".join(terms) if terms else "0"


def chart_f89_points(equations, class_index, chart):
    """All rational points in the disjoint chart a_0=...=a_{r-1}=0,a_r=1."""
    if chart == 4:
        point = (0, 0, 0, 0, 1)
        return [point] if all(evaluate(poly, point, P) == 0 for poly in equations.values()) else []
    variable_names = [f"a{index}" for index in range(chart + 1, 5)]
    expressions = [expression_on_chart(poly, chart) for poly in equations.values()]
    expressions = [expression for expression in expressions if expression != "0"]
    with tempfile.TemporaryDirectory(prefix=f"h3_a5_c{class_index}_chart{chart}_") as directory:
        input_path = Path(directory) / "chart.sing"
        input_path.write_text(
            f"ring r={P},({','.join(variable_names)}),lp;\n"
            f"ideal I={','.join(expressions) if expressions else '0'};\n"
            "ideal J=std(I);\n"
            'if (reduce(1,J)==0) { print("UNIT"); } else { print("NONUNIT"); J; }\n'
            "quit;\n"
        )
        result = subprocess.run(
            ["/opt/homebrew/bin/Singular", "-q", str(input_path)],
            check=True,
            capture_output=True,
            text=True,
        )
    lines = result.stdout.splitlines()
    assert lines and lines[0].strip() in {"UNIT", "NONUNIT"}
    if lines[0].strip() == "UNIT":
        return []
    variables = sp.symbols(" ".join(variable_names), seq=True)
    locals_map = {str(variable): variable for variable in variables}
    polynomials = []
    for line in lines[1:]:
        if "=" not in line:
            continue
        expression = line.split("=", 1)[1].replace("^", "**")
        polynomials.append(
            sp.Poly(sp.sympify(expression, locals=locals_map), *variables, modulus=P)
        )
    assignments = [{}]
    for variable in reversed(variables):
        expanded = []
        for assignment in assignments:
            for value in range(P):
                candidate = dict(assignment)
                candidate[variable] = value
                relevant = [
                    polynomial
                    for polynomial in polynomials
                    if polynomial.as_expr().free_symbols <= set(candidate)
                ]
                if all(int(poly.as_expr().subs(candidate)) % P == 0 for poly in relevant):
                    expanded.append(candidate)
        assignments = expanded
        assert assignments
    points = []
    for assignment in assignments:
        if all(int(poly.as_expr().subs(assignment)) % P == 0 for poly in polynomials):
            point = tuple([0] * chart + [1] + [int(assignment[v]) for v in variables])
            assert all(evaluate(poly, point, P) == 0 for poly in equations.values())
            points.append(point)
    return points


def main():
    print(f"sqrt5_mod_89_squared={SQRT5_P2}")
    print(f"sqrt_minus11_mod_89_squared={SQRT_MINUS11_P2}")
    covariants, _seeds, actions = exact.reynolds_basis()
    exact.verify_covariance(covariants, actions)
    space = reduce_covariants(covariants)
    for class_index in (1, 2):
        lam, cubic = cubic_for_class(class_index)
        equations = modular.general_landing_equations(space, cubic, 11, P2)
        # Some exact rows can vanish only after reduction modulo 89, so the
        # mod-89^2 system can contain more source-coefficient equations than
        # the 468 recorded by the special-fibre computation.
        print(f"class={class_index} equations_mod_89_squared={len(equations)}")
        equations_p = reduce_equations_mod_p(equations)
        assert len(equations_p) == 468
        chart_points = {0: lex_points(class_index)}
        for chart in range(1, 5):
            chart_points[chart] = chart_f89_points(equations_p, class_index, chart)
        print(
            f"class={class_index} lambda_mod_89_squared={lam} "
            f"chart_point_counts={[len(chart_points[c]) for c in range(5)]}"
        )
        for chart, points in chart_points.items():
            for point in points:
                print(f"chart={chart}", audit_point(equations, point, chart))
    print("H3_A5_DEGREE11_FULL_P2_AUDIT_OK")


if __name__ == "__main__":
    main()
