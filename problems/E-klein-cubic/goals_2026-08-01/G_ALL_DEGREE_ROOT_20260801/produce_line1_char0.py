#!/usr/bin/env python3
"""Reconstruct the m=3, line-degree-one landing algebra over Q(zeta_11)."""

from __future__ import annotations

import functools
import argparse
import hashlib
import importlib.util
import itertools
import json
import math
import sys
from fractions import Fraction
from pathlib import Path

import numpy as np
import sympy as sp


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
CERT = PROBLEM / "certificates"
SOURCE = PROBLEM / "tmp" / "symbolic_compatibility_complex" / "line_landing_bigraded.py"
P = 67
ZETA_MOD = 64


def load(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


ew = load("goal_g_exact_weil", CERT / "exact_weil_check.py")
common = load("goal_g_transition_common", CERT / "transitions" / "common.py")
modular = load("goal_g_line1_modular", SOURCE)
C = ew.C


def is_zero(value: C) -> bool:
    return value == 0


@functools.lru_cache(maxsize=None)
def inverse_coefficients(coefficients: tuple[Fraction, ...]) -> tuple[Fraction, ...]:
    variable = sp.Symbol("Z")
    polynomial = sp.Poly(
        sum(sp.Rational(value.numerator, value.denominator) * variable**index
            for index, value in enumerate(coefficients)),
        variable,
        domain=sp.QQ,
    )
    cyclotomic = sp.Poly(sum(variable**index for index in range(11)), variable, domain=sp.QQ)
    inverse = sp.invert(polynomial, cyclotomic)
    result = [Fraction(0)] * 10
    for (exponent,), value in sp.Poly(inverse, variable, domain=sp.QQ).terms():
        result[exponent] = Fraction(int(value.p), int(value.q))
    return tuple(result)


def cinv(value: C) -> C:
    assert not is_zero(value)
    return C(inverse_coefficients(value.a))


def matmul(left, right):
    return [
        [sum(left[i][k] * right[k][j] for k in range(len(right)))
         for j in range(len(right[0]))]
        for i in range(len(left))
    ]


def transpose(matrix):
    return [list(row) for row in zip(*matrix)]


def rref(matrix):
    answer = [[C(value) for value in row] for row in matrix]
    rows = len(answer)
    columns = len(answer[0]) if rows else 0
    pivots = []
    target = 0
    for column in range(columns):
        pivot = next((row for row in range(target, rows) if not is_zero(answer[row][column])), None)
        if pivot is None:
            continue
        answer[target], answer[pivot] = answer[pivot], answer[target]
        scale = cinv(answer[target][column])
        answer[target] = [scale * value for value in answer[target]]
        for row in range(rows):
            if row == target or is_zero(answer[row][column]):
                continue
            scale = answer[row][column]
            answer[row] = [
                answer[row][index] - scale * answer[target][index]
                for index in range(columns)
            ]
        pivots.append(column)
        target += 1
        if target == rows:
            break
    return answer, pivots


def nullspace(matrix):
    reduced, pivots = rref(matrix)
    columns = len(matrix[0])
    free = [column for column in range(columns) if column not in pivots]
    result = []
    for free_column in free:
        vector = [C(0) for _ in range(columns)]
        vector[free_column] = C(1)
        for row, pivot in enumerate(pivots):
            vector[pivot] = -reduced[row][free_column]
        result.append(vector)
    return result


def matrix_inverse(matrix):
    size = len(matrix)
    augmented = [
        list(row) + [C(i == j) for j in range(size)]
        for i, row in enumerate(matrix)
    ]
    reduced, pivots = rref(augmented)
    assert pivots[:size] == list(range(size))
    return [row[size:] for row in reduced]


def cmod(value: C) -> int:
    return common.cmod(value, P, ZETA_MOD)


def matrix_mod(matrix):
    return np.asarray([[cmod(value) for value in row] for row in matrix], dtype=np.int64)


def matrix_key(matrix) -> tuple[int, ...]:
    return tuple(int(value) % P for value in np.asarray(matrix).flat)


def lift_rows(exact_space, target_rows, modular_audit):
    reduction = matrix_mod(exact_space)
    _, pivots = modular_audit.rref(reduction)
    pivots = pivots[: len(exact_space)]
    square_inverse = modular.d12.inverse(reduction[:, pivots])
    result = []
    for target in target_rows:
        coefficients = np.asarray(target, dtype=np.int64)[pivots] @ square_inverse % P
        lifted = [
            sum(C(int(coefficients[row])) * exact_space[row][column]
                for row in range(len(exact_space)))
            for column in range(5)
        ]
        assert np.array_equal(matrix_mod([lifted])[0] % P, np.asarray(target) % P)
        result.append(lifted)
    return result


def independent_projector_columns(projector, expected_dimension):
    candidates = transpose(projector)
    result = []
    modular_rank = 0
    for candidate in candidates:
        trial = matrix_mod(result + [candidate])
        _, pivots = modular.audit.rref(trial)
        if len(pivots) > modular_rank:
            result.append(candidate)
            modular_rank += 1
    assert len(result) == expected_dimension
    return result


def exact_records(module, adapted_mod, installed_records_mod):
    exact_by_reduction = {
        matrix_key(matrix_mod(matrix)): key for key, matrix in ew.rho.items()
    }
    inverse_keys = [exact_by_reduction[matrix_key(record[0])] for record in installed_records_mod]
    group_keys = [common.inv_key(key) for key in inverse_keys]
    assert len(set(group_keys)) == 12
    v4 = [key for key in group_keys if common.order_key(key) in (1, 2)]
    assert len(v4) == 4

    # The columns of the Reynolds projector onto V4 invariants give a small
    # exact basis of the fixed line directly.
    line_projector = [
        [sum(ew.rho[key][i][j] for key in v4) / 4 for j in range(5)]
        for i in range(5)
    ]
    line_space = independent_projector_columns(line_projector, 2)

    # Reproduce the installed quotient-vector selection and lift each chosen
    # vector inside its exact incident involution plane.  This retains the
    # three branch axes of the triple-line symbolic ideal in characteristic
    # zero; an arbitrary complement does not.
    involutions_mod, planes_mod = modular.d12.planes_audit.plus_planes()
    incident = [
        index for index, plane in enumerate(planes_mod)
        if all(modular.d12.planes_audit.contains(plane, vector)
               for vector in adapted_mod[:2])
    ]
    assert len(incident) == 3
    chosen = []
    running = [np.asarray(row, dtype=np.int64) % P for row in adapted_mod[:2]]
    for plane_index in incident:
        for vector in planes_mod[plane_index]:
            trial = np.vstack([*running, vector])
            if modular.audit.rank(trial) > len(running):
                chosen.append((plane_index, np.asarray(vector, dtype=np.int64) % P))
                running.append(np.asarray(vector, dtype=np.int64) % P)
                break
    assert len(chosen) == 3
    assert np.array_equal(np.vstack(running) % P, np.asarray(adapted_mod) % P)

    exact_quotient = []
    running_exact = list(line_space)
    for plane_index, target in chosen:
        involution_key = exact_by_reduction[matrix_key(involutions_mod[plane_index])]
        plane_projector = [
            [
                (C(i == j) + ew.rho[involution_key][i][j]) / 2
                for j in range(5)
            ]
            for i in range(5)
        ]
        plane_space = independent_projector_columns(plane_projector, 3)
        old_rank = modular.audit.rank(matrix_mod(running_exact))
        quotient_vector = next(
            candidate for candidate in plane_space
            if modular.audit.rank(matrix_mod(running_exact + [candidate])) > old_rank
        )
        exact_quotient.append(quotient_vector)
        running_exact.append(quotient_vector)

    adapted = line_space + exact_quotient
    assert modular.audit.rank(matrix_mod(adapted)) == 5
    change_mod = matrix_mod(adapted) @ modular.d12.inverse(np.asarray(adapted_mod)) % P
    assert not np.any(change_mod[:2, 2:])
    transverse_change = change_mod[2:, 2:]
    assert all(np.count_nonzero(row) == 1 for row in transverse_change)
    assert all(np.count_nonzero(column) == 1 for column in transverse_change.T)
    adapted_inverse = matrix_inverse(adapted)

    result = []
    result_mod = []
    for inverse_key, group_key in zip(inverse_keys, group_keys):
        action = matmul(matmul(adapted, transpose(ew.rho[group_key])), adapted_inverse)
        assert all(is_zero(action[i][j]) for i in range(2) for j in range(2, 5))
        line = [row[:2] for row in action[:2]]
        transverse = [row[2:] for row in action[2:]]
        assert all(sum(not is_zero(value) for value in row) == 1 for row in transverse)
        result.append((ew.rho[inverse_key], line, transverse))
        result_mod.append(
            (
                matrix_mod(ew.rho[inverse_key]) % P,
                matrix_mod(line) % P,
                matrix_mod(transverse) % P,
            )
        )
    return result, result_mod, adapted, change_mod


def monomial_value(exponents, point):
    result = C(1)
    for exponent, coordinate in zip(exponents, point):
        result *= coordinate**exponent
    return result


def evaluate_seed(record_data, seed, line_point, transverse_point):
    line_exponents, transverse_exponents, output = seed
    answer = [C(0) for _ in range(5)]
    for inverse, line_action, transverse_action in record_data:
        transformed_line = [
            sum(line_point[i] * line_action[i][j] for i in range(2))
            for j in range(2)
        ]
        transformed_transverse = [
            sum(transverse_point[i] * transverse_action[i][j] for i in range(3))
            for j in range(3)
        ]
        scalar = (
            monomial_value(line_exponents, transformed_line)
            * monomial_value(transverse_exponents, transformed_transverse)
        )
        for coordinate in range(5):
            answer[coordinate] += scalar * inverse[coordinate][output]
    return answer


def parameter_monomials():
    result = []

    def visit(prefix, remaining, slots):
        if slots == 1:
            result.append(prefix + (remaining,))
            return
        for exponent in range(remaining + 1):
            visit(prefix + (exponent,), remaining - exponent, slots - 1)

    visit((), 3, 8)
    return result


def cubic_row(values):
    monomials = parameter_monomials()
    index = {powers: position for position, powers in enumerate(monomials)}
    row = [C(0) for _ in monomials]
    for coordinate in range(5):
        for left in range(8):
            for middle in range(8):
                product = values[left][coordinate] * values[middle][coordinate]
                if is_zero(product):
                    continue
                for right in range(8):
                    powers = [0] * 8
                    powers[left] += 1
                    powers[middle] += 1
                    powers[right] += 1
                    row[index[tuple(powers)]] += product * values[right][(coordinate + 1) % 5]
    return row


def c_render(value: C) -> str:
    denominator = math.lcm(*(coefficient.denominator for coefficient in value.a))
    terms = []
    for index in range(9, -1, -1):
        numerator = value.a[index].numerator * (denominator // value.a[index].denominator)
        if not numerator:
            continue
        monomial = "" if index == 0 else ("z" if index == 1 else f"z^{index}")
        if not monomial:
            terms.append(str(numerator))
        elif numerator == 1:
            terms.append(monomial)
        elif numerator == -1:
            terms.append("-" + monomial)
        else:
            terms.append(f"{numerator}*{monomial}")
    numerator_polynomial = "+".join(terms).replace("+-", "-") or "0"
    if denominator == 1:
        return numerator_polynomial
    return f"({numerator_polynomial})/{denominator}"


def equation_render(row):
    variables = ["1"] + [f"a_{index}" for index in range(1, 8)]
    terms = []
    for coefficient, powers in zip(row, parameter_monomials()):
        if is_zero(coefficient):
            continue
        monomial = "*".join(
            variable if exponent == 1 else f"{variable}^{exponent}"
            for variable, exponent in zip(variables, powers)
            if exponent and variable != "1"
        ) or "1"
        terms.append(f"({c_render(coefficient)})*{monomial}")
    return "+".join(terms) if terms else "0"


def equation_render_mod(row):
    variables = ["1"] + [f"a_{index}" for index in range(1, 8)]
    terms = []
    for coefficient, powers in zip(row, parameter_monomials()):
        coefficient = int(coefficient) % P
        if not coefficient:
            continue
        monomial = "*".join(
            variable if exponent == 1 else f"{variable}^{exponent}"
            for variable, exponent in zip(variables, powers)
            if exponent and variable != "1"
        ) or "1"
        terms.append(f"{coefficient}*{monomial}")
    return "+".join(terms) if terms else "0"


def equation_render_mod_boundary(row):
    variables = [f"a_{index}" for index in range(8)]
    terms = []
    for coefficient, powers in zip(row, parameter_monomials()):
        coefficient = int(coefficient) % P
        if not coefficient or powers[0]:
            continue
        monomial = "*".join(
            variable if exponent == 1 else f"{variable}^{exponent}"
            for variable, exponent in zip(variables, powers)
            if exponent
        ) or "1"
        terms.append(f"{coefficient}*{monomial}")
    return "+".join(terms) if terms else "0"


def main(output_directory: Path = HERE) -> None:
    reynolds = modular.audit.load(modular.audit.REYNOLDS, "goal_g_line1_char0_reynolds")
    module = reynolds.load_reynolds_module()
    modular.base.module_global = module
    _adapted_mod, installed_records_mod = modular.line_records(module)
    records, records_mod, adapted, change_mod = exact_records(
        module, _adapted_mod, installed_records_mod
    )
    selected, _ = modular.select_basis(module, records_mod, 3, 6, 1)
    assert len(selected) == 8

    line_points = modular.binary_grid(3)
    transverse_points = modular.transverse_grid(18)
    values_mod = modular.evaluate_basis(records_mod, selected, line_points, transverse_points)
    echelon = []
    pivot_points = []
    for line_index in range(len(line_points)):
        for transverse_index in range(len(transverse_points)):
            row = module.cubic_coefficient_row(values_mod[line_index, transverse_index])
            before = len(echelon)
            module.add_echelon_row(echelon, row)
            if len(echelon) > before:
                pivot_points.append((line_index, transverse_index))
    assert len(pivot_points) == 14, len(pivot_points)

    exact_rows = []
    modular_rows = []
    for line_index, transverse_index in pivot_points:
        line_point = [C(int(value)) for value in line_points[line_index]]
        transverse_point = [C(int(value)) for value in transverse_points[transverse_index]]
        values = [
            evaluate_seed(records, seed, line_point, transverse_point)
            for seed in selected
        ]
        assert np.array_equal(
            np.asarray([[cmod(value) for value in vector] for vector in values], dtype=np.int64) % P,
            values_mod[line_index, transverse_index] % P,
        )
        row = cubic_row(values)
        modular_row = module.cubic_coefficient_row(values_mod[line_index, transverse_index])
        assert [cmod(value) for value in row] == [int(value) % P for value in modular_row]
        exact_rows.append(row)
        modular_rows.append(modular_row)

    # Their reductions already prove independence.  The exact RREF records
    # pivot columns used below to certify that every interpolation row lies
    # in their characteristic-zero span.
    reduced_rows, exact_pivots = rref(exact_rows)
    exact_rank = len(exact_pivots)
    assert exact_rank == 14
    pivot_row_lookup = {
        point: row for point, row in zip(pivot_points, exact_rows)
    }
    interpolation_rows_checked = 0
    for line_index, line_mod in enumerate(line_points):
        line_point = [C(int(value)) for value in line_mod]
        for transverse_index, transverse_mod in enumerate(transverse_points):
            point = (line_index, transverse_index)
            row = pivot_row_lookup.get(point)
            if row is None:
                transverse_point = [C(int(value)) for value in transverse_mod]
                values = [
                    evaluate_seed(records, seed, line_point, transverse_point)
                    for seed in selected
                ]
                row = cubic_row(values)
            modular_row = module.cubic_coefficient_row(
                values_mod[line_index, transverse_index]
            )
            assert [cmod(value) for value in row] == [
                int(value) % P for value in modular_row
            ], point
            remainder = list(row)
            for reduced, pivot in zip(reduced_rows, exact_pivots):
                scale = remainder[pivot]
                if is_zero(scale):
                    continue
                remainder = [
                    value - scale * basis_value
                    for value, basis_value in zip(remainder, reduced)
                ]
            assert all(is_zero(value) for value in remainder), point
            interpolation_rows_checked += 1
    assert interpolation_rows_checked == len(line_points) * len(transverse_points) == 760
    variables = ",".join(f"a_{index}" for index in range(1, 8))
    singular = "\n".join(
        [
            f"ring r=(0,z),({variables}),dp;",
            "minpoly=z^10+z^9+z^8+z^7+z^6+z^5+z^4+z^3+z^2+z+1;",
            "ideal I=\n  " + ",\n  ".join(equation_render(row) for row in exact_rows) + ";",
            "ideal G=slimgb(I);",
            'print("CHAR0_DIM");',
            "print(dim(G));",
            'print("CHAR0_VDIM_IF_ZERO");',
            "if (dim(G)==0) { print(vdim(G)); } else { print(-1); }",
            'print("CHAR0_GB_SIZE");',
            "print(size(G));",
            "quit;",
        ]
    ) + "\n"
    output_directory.mkdir(parents=True, exist_ok=True)
    output = output_directory / "m3_line1_char0.sing"
    output.write_text(singular)
    reduction = "\n".join(
        [
            f"ring r={P},({variables}),dp;",
            "ideal I=\n  " + ",\n  ".join(equation_render_mod(row) for row in modular_rows) + ";",
            "ideal G=std(I);",
            'print("SPECIAL_DIM");',
            "print(dim(G));",
            'print("SPECIAL_VDIM_IF_ZERO");',
            "if (dim(G)==0) { print(vdim(G)); } else { print(-1); }",
            'print("SPECIAL_GB_SIZE");',
            "print(size(G));",
            "quit;",
        ]
    ) + "\n"
    reduction_output = output_directory / "m3_line1_reduction.sing"
    reduction_output.write_text(reduction)
    boundary_lines = [
        f"ring r={P},({variables}),dp;",
        "ideal H=\n  "
        + ",\n  ".join(equation_render_mod_boundary(row) for row in modular_rows)
        + ";",
    ]
    for chart in range(1, 8):
        boundary_lines.extend(
            [
                f"ideal I_{chart}=subst(H,a_{chart},1);",
                f"ideal G_{chart}=std(I_{chart});",
                f'print("BOUNDARY_CHART_{chart}_UNIT");',
                f"if (reduce(1,G_{chart})==0) {{ print(1); }} else {{ print(0); }}",
            ]
        )
    boundary_lines.append("quit;")
    boundary_output = output_directory / "m3_line1_reduction_boundary.sing"
    boundary_output.write_text("\n".join(boundary_lines) + "\n")
    metadata = {
        "field": "Q(zeta_11)",
        "cyclotomic_polynomial": "z^10+z^9+z^8+z^7+z^6+z^5+z^4+z^3+z^2+z+1",
        "parameter_dimension": 8,
        "landing_row_rank": exact_rank,
        "coefficient_interpolation_rows_checked": interpolation_rows_checked,
        "all_coefficient_rows_in_exact_span": True,
        "all_coefficient_rows_reduce_to_split_model": True,
        "pivot_source_points": pivot_points,
        "selected_seeds": [
            [list(line), list(transverse), int(output_coordinate)]
            for line, transverse, output_coordinate in selected
        ],
        "modular_regression": {"prime": P, "zeta_11": ZETA_MOD},
        "branch_adapted_basis_mod67": matrix_mod(adapted).tolist(),
        "change_from_installed_basis_mod67": change_mod.tolist(),
        "singular_input": output.name,
        "singular_sha256": hashlib.sha256(output.read_bytes()).hexdigest(),
        "reduction_input": reduction_output.name,
        "reduction_sha256": hashlib.sha256(reduction_output.read_bytes()).hexdigest(),
        "reduction_boundary_input": boundary_output.name,
        "reduction_boundary_sha256": hashlib.sha256(boundary_output.read_bytes()).hexdigest(),
        "scope": (
            "Exact characteristic-zero reconstruction of the local m=3, "
            "transverse-degree-six, line-degree-one landing ideal on a0=1."
        ),
    }
    (output_directory / "m3_line1_char0.json").write_text(
        json.dumps(metadata, indent=2) + "\n"
    )
    print(f"SELECTED_SEEDS={len(selected)}")
    print(f"LANDING_ROW_RANK={exact_rank}")
    print("LINE1_CHAR0_INPUT_OK")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--output-dir", type=Path, default=HERE)
    arguments = parser.parse_args()
    main(arguments.output_dir)
