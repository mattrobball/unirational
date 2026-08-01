#!/usr/bin/env python3
"""Exact degree-11 A5 covariant construction in the canonical model.

The script first chooses five Reynolds covariants using a good-fibre rank
witness, then rebuilds those covariants over Q(sqrt(5)).  It generates small
characteristic-zero landing ideals for the two conjugate A5 cubic-pencil
parameters in the primitive quartic field Q(sqrt(5),sqrt(-11)).
"""

from __future__ import annotations

from collections import deque
import itertools
from pathlib import Path
import subprocess

import sympy as sp
from sympy.polys.domains import QQ

import canonical_a5_pencil as can


HERE = Path(__file__).resolve().parent
P = 89
DEGREE = 11
MONS = can.monomials(3, DEGREE)
MON_INDEX = {exponent: i for i, exponent in enumerate(MONS)}
PARAM_MONS = can.monomials(5, 3)

x = sp.symbols("x")
E = QQ.algebraic_field(sp.sqrt(5), sp.sqrt(-11), alias="a")
A = E.unit
SQRT5 = E.from_sympy(sp.sqrt(5))
SQRTM11 = E.from_sympy(sp.sqrt(-11))
ALPHA = -(E.one + SQRT5) / E.convert(2)


def matrix_mul(left, right):
    return [[
        sum((left[i][k] * right[k][j] for k in range(len(right))), E.zero)
        for j in range(len(right[0]))
    ] for i in range(len(left))]


def source_representation_exact():
    p5, p3 = (1, 2, 3, 4, 0), (0, 1, 3, 4, 2)
    m5 = [
        [ALPHA, -ALPHA, -E.one],
        [ALPHA, E.one, E.zero],
        [ALPHA, -ALPHA, E.zero],
    ]
    m3 = [
        [E.zero, -E.one, -ALPHA],
        [E.zero, E.zero, E.one],
        [-E.one, -ALPHA, E.zero],
    ]
    identity = [[E.one if i == j else E.zero for j in range(3)] for i in range(3)]
    out = {can.base.PID: identity}
    queue = deque([can.base.PID])
    while queue:
        current = queue.popleft()
        for generator, matrix in ((p5, m5), (p3, m3)):
            candidate = can.base.pc(current, generator)
            candidate_matrix = matrix_mul(out[current], matrix)
            if candidate in out:
                assert out[candidate] == candidate_matrix
            else:
                out[candidate] = candidate_matrix
                queue.append(candidate)
    assert len(out) == 60
    return out


SOURCE = source_representation_exact()


def poly_mul(left, right, modulus=None):
    out = {}
    for ea, ca in left.items():
        for eb, cb in right.items():
            exponent = tuple(a + b for a, b in zip(ea, eb))
            value = out.get(exponent, 0) + ca * cb
            if modulus is not None:
                value %= modulus
            out[exponent] = value
    return {e: c for e, c in out.items() if c}


def poly_pow(poly, n, variables, modulus=None):
    out = {(0,) * variables: 1 if modulus is not None else E.one}
    for _ in range(n):
        out = poly_mul(out, poly, modulus)
    return out


def transformed_monomial(matrix, exponent, modulus=None):
    forms = []
    for row in matrix:
        forms.append({
            tuple(int(i == j) for i in range(3)): value
            for j, value in enumerate(row) if value
        })
    out = {(0, 0, 0): 1 if modulus is not None else E.one}
    for form, power in zip(forms, exponent):
        out = poly_mul(out, poly_pow(form, power, 3, modulus), modulus)
    return out


def reynolds_mod(seed):
    target, exponent = seed
    out = [[0] * len(MONS) for _ in range(5)]
    for h in can.base.PERMS:
        polynomial = transformed_monomial(can.base.SOURCE_A5[h], exponent, P)
        inverse_column = [row[target] % P for row in can.U[can.p_inverse(h)]]
        for component, scalar in enumerate(inverse_column):
            for monomial, coefficient in polynomial.items():
                out[component][MON_INDEX[monomial]] = (
                    out[component][MON_INDEX[monomial]] + scalar * coefficient
                ) % P
    return tuple(value for row in out for value in row)


def add_echelon(vector, echelon):
    work = list(vector)
    for pivot, row in echelon:
        if work[pivot]:
            scale = work[pivot]
            work = [(a - scale * b) % P for a, b in zip(work, row)]
    pivot = next((i for i, value in enumerate(work) if value), None)
    if pivot is None:
        return False
    inverse = pow(work[pivot], -1, P)
    work = [inverse * value % P for value in work]
    for index, (old_pivot, row) in enumerate(echelon):
        if row[pivot]:
            scale = row[pivot]
            echelon[index] = (old_pivot, [(a - scale * b) % P for a, b in zip(row, work)])
    echelon.append((pivot, work))
    echelon.sort()
    return True


def choose_seeds():
    selected = []
    echelon = []
    for target in range(5):
        for exponent in MONS:
            seed = (target, exponent)
            if add_echelon(reynolds_mod(seed), echelon):
                selected.append(seed)
                print("selected_seed", target, exponent, flush=True)
                if len(selected) == 5:
                    return selected
    raise AssertionError("degree-11 Reynolds rank below five")


def reynolds_exact(seed):
    target, exponent = seed
    out = [dict() for _ in range(5)]
    for h in can.base.PERMS:
        polynomial = transformed_monomial(SOURCE[h], exponent)
        inverse_column = [row[target] for row in can.U[can.p_inverse(h)]]
        for component, scalar in enumerate(inverse_column):
            if not scalar:
                continue
            scalar = E.convert(scalar)
            for monomial, coefficient in polynomial.items():
                out[component][monomial] = out[component].get(monomial, E.zero) + scalar * coefficient
    return [{e: c for e, c in component.items() if c} for component in out]


def evaluate(poly, point):
    return sum((
        coefficient * E.convert(point[0])**exponent[0]
        * E.convert(point[1])**exponent[1] * E.convert(point[2])**exponent[2]
        for exponent, coefficient in poly.items()
    ), E.zero)


def cubic_parameter_row(covariants, point, lam):
    values = [[evaluate(covariant[i], point) for i in range(5)] for covariant in covariants]
    linear = []
    for target in range(5):
        linear.append({
            tuple(int(i == parameter) for i in range(5)): values[parameter][target]
            for parameter in range(5) if values[parameter][target]
        })
    result = {}
    for basis_index, basis in enumerate(can.CUBIC_BASIS):
        scale = E.one if basis_index == 0 else lam
        for target_exponent, coefficient in basis.items():
            term = {(0,) * 5: E.one}
            for form, power in zip(linear, target_exponent):
                term = poly_mul(term, poly_pow(form, power, 5))
            for exponent, value in term.items():
                result[exponent] = result.get(exponent, E.zero) + scale * E.convert(coefficient) * value
    return [result.get(exponent, E.zero) for exponent in PARAM_MONS]


GAUSS_MOD = sum(
    (1 if exponent in {1, 3, 4, 5, 9} else -1) * pow(2, exponent, P)
    for exponent in range(1, 11)
) % P
assert GAUSS_MOD * GAUSS_MOD % P == -11 % P
A_MOD = (19 + GAUSS_MOD) % P


def reduce_e(value):
    result = 0
    for coefficient in value.to_list():
        result = (result * A_MOD + int(coefficient.numerator) * pow(int(coefficient.denominator), -1, P)) % P
    return result


def independent_evaluation_rows(covariants, lam, seeds):
    """Select a spanning good-fibre row set, then rebuild only it exactly.

    The modular selection is a speed optimization only.  A resulting point
    must still be checked on the full characteristic-zero unisolvent grid.
    """
    modular_covariants = []
    for seed in seeds:
        vector = reynolds_mod(seed)
        modular_covariants.append([
            {
                exponent: vector[component * len(MONS) + index]
                for index, exponent in enumerate(MONS)
                if vector[component * len(MONS) + index]
            }
            for component in range(5)
        ])

    def evaluate_mod(poly, point):
        return sum(
            coefficient * pow(point[0], exponent[0], P)
            * pow(point[1], exponent[1], P) * pow(point[2], exponent[2], P)
            for exponent, coefficient in poly.items()
        ) % P

    def modular_row(point):
        values = [[evaluate_mod(covariant[i], point) for i in range(5)]
                  for covariant in modular_covariants]
        linear = []
        for target in range(5):
            linear.append({
                tuple(int(i == parameter) for i in range(5)): values[parameter][target]
                for parameter in range(5) if values[parameter][target]
            })
        result = {}
        lam_mod = reduce_e(lam)
        for basis_index, basis in enumerate(can.CUBIC_BASIS):
            scale = 1 if basis_index == 0 else lam_mod
            for target_exponent, coefficient in basis.items():
                term = {(0,) * 5: 1}
                for form, power in zip(linear, target_exponent):
                    term = poly_mul(term, poly_pow(form, power, 5, P), P)
                for exponent, value in term.items():
                    result[exponent] = (
                        result.get(exponent, 0) + scale * coefficient * value
                    ) % P
        return [result.get(exponent, 0) for exponent in PARAM_MONS]

    echelon = []
    selected_points = []
    for y0 in range(34):
        for y1 in range(34 - y0):
            point = (y0, y1, 1)
            if add_echelon(modular_row(point), echelon):
                selected_points.append(point)
    print("landing_row_rank_mod89", len(selected_points), flush=True)
    print("landing_row_points_mod89", selected_points, flush=True)
    selected = [(point, cubic_parameter_row(covariants, point, lam))
                for point in selected_points]
    print("landing_rows_rebuilt_exact", len(selected), flush=True)
    return selected


def singular_number(value):
    coefficients = value.to_list()
    terms = []
    degree = len(coefficients) - 1
    for index, coefficient in enumerate(coefficients):
        if not coefficient:
            continue
        power = degree - index
        numerator, denominator = int(coefficient.numerator), int(coefficient.denominator)
        factor = str(numerator) if denominator == 1 else f"({numerator}/{denominator})"
        if power:
            factor += "*a" if power == 1 else f"*a^{power}"
        terms.append(factor)
    return "+".join(terms).replace("+-", "-") if terms else "0"


def singular_polynomial(row, chart):
    terms = []
    for exponent, coefficient in zip(PARAM_MONS, row):
        if not coefficient:
            continue
        factors = [f"p{i}^{power}" if power != 1 else f"p{i}"
                   for i, power in enumerate(exponent) if power and i != chart]
        monomial = "*".join(factors) if factors else "1"
        terms.append(f"({singular_number(coefficient)})*{monomial}")
    return "+".join(terms) if terms else "0"


def run_singular(label, rows, chart=0):
    variables = ",".join(f"p{i}" for i in range(5) if i != chart)
    input_path = HERE / f"{label}_degree11_exact.sing"
    transcript_path = HERE / f"{label}_degree11_exact.txt"
    equations = ",\n".join(singular_polynomial(row, chart) for _, row in rows)
    input_path.write_text(
        f"ring r=(0,a),({variables}),dp;\n"
        "minpoly=a^4+12*a^2+256;\n"
        f"ideal I={equations};\n"
        "ideal G=std(I);\nG;\ndim(G);\nvdim(G);\nquit;\n"
    )
    result = subprocess.run(
        ["/opt/homebrew/bin/Singular", "-q", str(input_path)],
        check=True, capture_output=True, text=True,
    )
    transcript_path.write_text(result.stdout)
    print(label, result.stdout[-4000:], flush=True)


def main():
    seeds = choose_seeds()
    covariants = [reynolds_exact(seed) for seed in seeds]
    print("exact_covariants_built", [sum(len(c) for c in covariant) for covariant in covariants], flush=True)
    for label, lam in (
        ("A5_class_1", (E.convert(13) - SQRTM11) / E.convert(18)),
        ("A5_class_2", (E.convert(13) + SQRTM11) / E.convert(18)),
    ):
        rows = independent_evaluation_rows(covariants, lam, seeds)
        run_singular(label, rows)
    print("EXACT_A5_DEGREE11_PREFLIGHT_OK")


if __name__ == "__main__":
    main()
