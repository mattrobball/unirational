#!/usr/bin/env python3
"""Solve the exact degree-11 A5 landing schemes in the canonical model.

The identity test uses the lower triangular interpolation grid
  (i,j,1), i,j >= 0, i+j <= 33.
This has 595 points and is unisolvent for ternary homogeneous forms of
degree 33 (equivalently for bivariate polynomials of total degree <= 33).
Thus the resulting cubic parameter equations are exact, not a point sample.
"""

from __future__ import annotations

import itertools

import sympy as sp
from sympy.polys.domains import QQ

import canonical_a5_pencil as model
import exact_a5_degree11 as degree11


PARAM_MONS = model.monomials(5, 3)
PARAM_INDEX = {exponent: i for i, exponent in enumerate(PARAM_MONS)}

R5_EXPR = sp.sqrt(5)
G_EXPR = sp.sqrt(-11)
E = QQ.algebraic_field(R5_EXPR, G_EXPR)
R5 = E.from_sympy(R5_EXPR)
G = E.from_sympy(G_EXPR)


def embed_k5(value):
    coefficients = value.to_list()
    if not coefficients:
        return E.zero
    if len(coefficients) == 1:
        return E.convert(coefficients[0])
    assert len(coefficients) == 2
    return E.convert(coefficients[0]) * R5 + E.convert(coefficients[1])


def exact_rref_covariants(selected):
    vectors = [degree11.flatten(covariant) for _, _, covariant in selected]
    pivots = []
    row = 0
    columns = len(vectors[0])
    for column in range(columns):
        pivot = next((i for i in range(row, len(vectors)) if vectors[i][column]), None)
        if pivot is None:
            continue
        vectors[row], vectors[pivot] = vectors[pivot], vectors[row]
        inverse = degree11.K5.one / vectors[row][column]
        vectors[row] = [inverse * value for value in vectors[row]]
        for i in range(len(vectors)):
            if i == row or not vectors[i][column]:
                continue
            scale = vectors[i][column]
            vectors[i] = [a - scale*b for a, b in zip(vectors[i], vectors[row])]
        pivots.append(column)
        row += 1
        if row == len(vectors):
            break
    assert len(pivots) == 5
    covariants = []
    for vector in vectors:
        components = []
        for component in range(5):
            block = vector[component * len(degree11.MONS):(component + 1) * len(degree11.MONS)]
            components.append({
                exponent: coefficient
                for exponent, coefficient in zip(degree11.MONS, block) if coefficient
            })
        covariants.append(components)
    return covariants, pivots


def evaluate(polynomial, point):
    return sum(
        (coefficient * (point[0]**exponent[0]) * (point[1]**exponent[1]) * (point[2]**exponent[2])
         for exponent, coefficient in polynomial.items()),
        degree11.K5.zero,
    )


def parameter_poly_add(left, right):
    out = dict(left)
    for exponent, coefficient in right.items():
        out[exponent] = out.get(exponent, E.zero) + coefficient
        if not out[exponent]:
            del out[exponent]
    return out


def parameter_poly_mul(left, right):
    out = {}
    for ea, ca in left.items():
        for eb, cb in right.items():
            exponent = tuple(a+b for a, b in zip(ea, eb))
            out[exponent] = out.get(exponent, E.zero) + ca*cb
    return {e: c for e, c in out.items() if c}


def parameter_poly_pow(polynomial, power):
    out = {(0, 0, 0, 0, 0): E.one}
    for _ in range(power):
        out = parameter_poly_mul(out, polynomial)
    return out


def evaluated_landing_row(covariants, point, lam):
    target_forms = []
    for target_component in range(5):
        form = {}
        for parameter, covariant in enumerate(covariants):
            value = embed_k5(evaluate(covariant[target_component], point))
            if value:
                form[tuple(int(i == parameter) for i in range(5))] = value
        target_forms.append(form)
    total = {}
    for which, scalar in ((0, E.one), (1, lam)):
        for target_exponent, coefficient in model.CUBIC_BASIS[which].items():
            term = {(0, 0, 0, 0, 0): scalar * E.convert(coefficient)}
            for form, power in zip(target_forms, target_exponent):
                term = parameter_poly_mul(term, parameter_poly_pow(form, power))
            total = parameter_poly_add(total, term)
    return [total.get(exponent, E.zero) for exponent in PARAM_MONS]


def rowspace_basis(rows):
    work = [list(row) for row in rows if any(row)]
    pivots = []
    pivot_row = 0
    for column in range(len(PARAM_MONS)):
        pivot = next((i for i in range(pivot_row, len(work)) if work[i][column]), None)
        if pivot is None:
            continue
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        inverse = E.one / work[pivot_row][column]
        work[pivot_row] = [inverse * value for value in work[pivot_row]]
        for i in range(len(work)):
            if i == pivot_row or not work[i][column]:
                continue
            scale = work[i][column]
            work[i] = [a - scale*b for a, b in zip(work[i], work[pivot_row])]
        pivots.append(column)
        pivot_row += 1
        if pivot_row == len(work):
            break
    return work[:pivot_row], pivots


def to_sympy_equation(row, chart):
    parameters = sp.symbols("a0:5")
    expression = sum(
        E.to_sympy(coefficient) * sp.prod(variable**power for variable, power in zip(parameters, exponent))
        for exponent, coefficient in zip(PARAM_MONS, row) if coefficient
    )
    return sp.expand(expression.subs(parameters[chart], 1))


def solve_class(covariants, label, lam):
    grid = [(i, j, 1) for i in range(34) for j in range(34 - i)]
    assert len(grid) == 595
    rows = []
    for index, point in enumerate(grid):
        rows.append(evaluated_landing_row(covariants, point, lam))
        if index % 100 == 99:
            print(f"{label} evaluations={index + 1}", flush=True)
    equations, pivots = rowspace_basis(rows)
    print(f"{label} cubic_equation_rank={len(equations)} pivots={pivots}", flush=True)
    parameters = sp.symbols("a0:5")
    results = []
    for chart in range(5):
        variables = tuple(parameters[i] for i in range(5) if i != chart)
        expressions = [to_sympy_equation(row, chart) for row in equations]
        basis = sp.groebner(
            expressions,
            *variables,
            extension=[R5_EXPR, G_EXPR],
            order="lex",
        )
        serialized = [sp.factor(poly.as_expr(), extension=[R5_EXPR, G_EXPR]) for poly in basis.polys]
        unit = basis.contains(sp.Integer(1))
        print(f"{label} chart={chart} unit={unit} gb_size={len(serialized)}", flush=True)
        if not unit:
            for polynomial in serialized:
                print(f"  {polynomial}")
        results.append((chart, variables, basis))
    return results


def main():
    selected, _ = degree11.select_basis()
    covariants, pivots = exact_rref_covariants(selected)
    for covariant in covariants:
        degree11.verify_covariance(covariant)
    print("exact_rref_pivots=", pivots)
    for label, lam in (
        ("A5_class_1", (E.convert(13) - G) / E.convert(18)),
        ("A5_class_2", (E.convert(13) + G) / E.convert(18)),
    ):
        solve_class(covariants, label, lam)
    print("EXACT_A5_DEGREE11_LANDING_SOLVE_OK")


if __name__ == "__main__":
    main()
