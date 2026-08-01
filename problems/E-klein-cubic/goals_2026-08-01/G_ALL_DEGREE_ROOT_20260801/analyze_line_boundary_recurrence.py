#!/usr/bin/env python3
"""Audit the central D12 boundary recurrence and its failure over F_67.

For the m=3, transverse-degree-six first surviving line layer, compare the
kernel of the assembled central-branch equality at a D12 point with
multiplication by the invariant binary cubic D_L cutting out the three D12
points on the representative line.
"""

from __future__ import annotations

import argparse
import importlib.util
import json
import sys
from pathlib import Path

import numpy as np
import sympy as sp


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
BOUNDARY_DIR = PROBLEM / "tmp" / "m3_line_point_boundary"
PACKET = PROBLEM / "tmp" / "symbolic_compatibility_complex"
P = 67


def load(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def rowspace_key(core, matrix):
    reduced, pivots = core.audit.rref(np.asarray(matrix, dtype=np.int64) % P)
    return tuple(tuple(int(x) for x in row) for row in reduced[: len(pivots)])


def polynomial_expression(poly, variable_names):
    """Render an exponent-dictionary polynomial with coefficients in [0,P)."""

    terms = []
    for powers in sorted(poly, reverse=True):
        coefficient = int(poly[powers]) % P
        coefficient = int(coefficient) % P
        if not coefficient:
            continue
        factors = [
            (name if exponent == 1 else f"{name}^{exponent}")
            for name, exponent in zip(variable_names, powers)
            if exponent
        ]
        monomial = "*".join(factors) if factors else "1"
        terms.append(monomial if coefficient == 1 else f"{coefficient}*{monomial}")
    return "+".join(terms) if terms else "0"


def multiply_sparse(left, right):
    answer = {}
    for left_powers, left_coefficient in left.items():
        for right_powers, right_coefficient in right.items():
            powers = tuple(
                a + b for a, b in zip(left_powers, right_powers)
            )
            answer[powers] = (
                answer.get(powers, 0)
                + int(left_coefficient) * int(right_coefficient)
            ) % P
    return {powers: coefficient for powers, coefficient in answer.items() if coefficient}


def affine_chart_polynomial(row, monomials, linear_row, pivot):
    """Substitute the chart equation linear_row*z=1 without dense expansion."""

    remaining_indices = [index for index in range(len(linear_row)) if index != pivot]
    zero = (0,) * len(remaining_indices)
    pivot_inverse = pow(int(linear_row[pivot]), -1, P)
    replacement = {zero: pivot_inverse}
    for target, source in enumerate(remaining_indices):
        coefficient = -pivot_inverse * int(linear_row[source]) % P
        if coefficient:
            powers = [0] * len(remaining_indices)
            powers[target] = 1
            replacement[tuple(powers)] = coefficient
    replacement_powers = [{zero: 1}]
    for _ in range(3):
        replacement_powers.append(
            multiply_sparse(replacement_powers[-1], replacement)
        )

    answer = {}
    for coefficient, powers in zip(row, monomials):
        coefficient = int(coefficient) % P
        if not coefficient:
            continue
        base = tuple(powers[index] for index in remaining_indices)
        for replacement_powers_tuple, replacement_coefficient in (
            replacement_powers[powers[pivot]].items()
        ):
            output_powers = tuple(
                a + b for a, b in zip(base, replacement_powers_tuple)
            )
            answer[output_powers] = (
                answer.get(output_powers, 0)
                + coefficient * replacement_coefficient
            ) % P
    return {powers: coefficient for powers, coefficient in answer.items() if coefficient}


def restricted_landing_is_empty(
    core,
    module,
    records,
    selected,
    kernel,
    line_degree,
    transverse_degree,
    line_points=None,
    m2_path=None,
    excluded_subspace_linears=None,
):
    dimension = len(kernel)
    assert dimension > 0
    if line_points is None:
        line_points = core.line_model.binary_grid(3 * line_degree)
    else:
        line_points = np.asarray(line_points, dtype=np.int64) % P
    transverse_points = core.line_model.transverse_grid(3 * transverse_degree)
    values = core.line_model.evaluate_basis(
        records, selected, line_points, transverse_points
    )
    restricted = np.einsum("abdk,ed->abek", values, kernel) % P
    echelon = []
    for point_values in restricted.reshape(-1, dimension, 5):
        module.add_echelon_row(
            echelon, module.cubic_coefficient_row(point_values)
        )
    rows = np.stack([row for _, row in echelon]).astype(np.int64) % P
    monomials = core.point.weak_compositions(3, dimension)
    if m2_path is not None:
        variable_names = [f"z_{index}" for index in range(dimension)]
        expressions = []
        for row in rows:
            terms = []
            for coefficient, powers in zip(row, monomials):
                coefficient = int(coefficient) % P
                if not coefficient:
                    continue
                factors = [
                    (name if exponent == 1 else f"{name}^{exponent}")
                    for name, exponent in zip(variable_names, powers)
                    if exponent
                ]
                monomial = "*".join(factors) if factors else "1"
                terms.append(monomial if coefficient == 1 else f"{coefficient}*{monomial}")
            expressions.append("+".join(terms) if terms else "0")
        script = [
            "kk=GF(67);",
            "R=kk[" + ",".join(variable_names) + ",MonomialOrder=>GRevLex];",
            "I=ideal(\n  " + ",\n  ".join(expressions) + "\n);",
            'print("INPUT generators="|toString(numgens source gens I));',
        ]
        if excluded_subspace_linears is not None:
            linear_expressions = []
            for row in excluded_subspace_linears:
                terms = [
                    (
                        name
                        if int(coefficient) % P == 1
                        else f"{int(coefficient) % P}*{name}"
                    )
                    for name, coefficient in zip(variable_names, row)
                    if int(coefficient) % P
                ]
                linear_expressions.append("+".join(terms) if terms else "0")
            script.extend(
                [
                    "Dmultiple=ideal("
                    + ",".join(linear_expressions)
                    + ");",
                    "J=saturate(I,Dmultiple);",
                    'print("PRIMITIVE_SATURATED_UNIT="|toString(J==ideal(1_R)));',
                    'print("PRIMITIVE_SATURATED_DIM="|toString(dim J));',
                ]
            )
        else:
            script.extend(
                [
                    "D=dim I;",
                    'print("AFFINE_CONE_DIM="|toString(D));',
                    'print("PROJECTIVELY_EMPTY="|toString(D==0));',
                ]
            )
        script.append("exit 0;")
        m2_path = Path(m2_path)
        m2_path.write_text("\n".join(script) + "\n")
        m2_path.with_suffix(".ms").write_text(
            ",".join(variable_names)
            + f"\n{P}\n"
            + ",\n".join(expressions)
            + "\n"
        )
        singular_script = [
            "option(redSB);",
            f"ring r={P},({','.join(variable_names)}),dp;",
            "ideal I=\n  " + ",\n  ".join(expressions) + ";",
            "ideal G=std(I);",
            'print("SINGULAR_DIM");',
            "print(dim(G));",
            'print("SINGULAR_VDIM_IF_ZERO");',
            "if (dim(G)==0) { print(vdim(G)); } else { print(-1); }",
            "quit;",
        ]
        m2_path.with_suffix(".sing").write_text(
            "\n".join(singular_script) + "\n"
        )
        if excluded_subspace_linears is not None:
            for chart, linear_expression in enumerate(linear_expressions):
                linear_row = np.asarray(
                    excluded_subspace_linears[chart], dtype=np.int64
                ) % P
                pivot = max(index for index, value in enumerate(linear_row) if value)
                remaining_names = [
                    name
                    for index, name in enumerate(variable_names)
                    if index != pivot
                ]
                affine_polynomials = [
                    affine_chart_polynomial(
                        row, monomials, linear_row, pivot
                    )
                    for row in rows
                ]
                affine_expressions = [
                    polynomial_expression(poly, remaining_names)
                    for poly in affine_polynomials
                ]
                chart_stem = m2_path.with_name(
                    m2_path.stem + f"_primitive_elim_chart{chart}"
                )
                chart_m2 = [
                    "needsPackage \"Msolve\";",
                    "kk=ZZ/67;",
                    "R=kk["
                    + ",".join(remaining_names)
                    + ",MonomialOrder=>GRevLex];",
                    "I=ideal(\n  "
                    + ",\n  ".join(affine_expressions)
                    + "\n);",
                    "G=msolveGB(I,Threads=>1);",
                    "J=ideal G;",
                    "H=gb J;",
                    'print("CHART="|toString('
                    + str(chart)
                    + "));",
                    'print("ELIMINATED_VARIABLE=' + variable_names[pivot] + '");',
                    'print("INPUT_REMAINDER_ZERO="|toString(gens I % H == 0));',
                    "LT=monomialIdeal leadTerm G;",
                    'print("CHART_DIM="|toString(dim LT));',
                    'print("CHART_DEGREE="|toString(degree LT));',
                    'print("UNIT_NORMAL_FORM="|toString(1_R % H));',
                    "exit 0;",
                ]
                chart_stem.with_suffix(".m2").write_text(
                    "\n".join(chart_m2) + "\n"
                )
                chart_stem.with_suffix(".ms").write_text(
                    ",".join(remaining_names)
                    + f"\n{P}\n"
                    + ",\n".join(affine_expressions)
                    + "\n"
                )
                chart_singular = [
                    "option(redSB);",
                    f"ring r={P},({','.join(remaining_names)}),dp;",
                    "ideal I=\n  "
                    + ",\n  ".join(affine_expressions)
                    + ";",
                    "ideal G=std(I);",
                    'print("SINGULAR_CHART");',
                    f"print({chart});",
                    'print("ELIMINATED_VARIABLE");',
                    f'print("{variable_names[pivot]}");',
                    'print("SINGULAR_NF1");',
                    "print(reduce(1,G));",
                    'print("SINGULAR_DIM");',
                    "print(dim(G));",
                    "quit;",
                ]
                chart_stem.with_suffix(".sing").write_text(
                    "\n".join(chart_singular) + "\n"
                )
        return None, len(rows)
    variables = sp.symbols(f"z0:{dimension}")
    polynomials = []
    for row in rows:
        expression = sum(
            int(coefficient)
            * sp.prod(variable**exponent for variable, exponent in zip(variables, powers))
            for coefficient, powers in zip(row, monomials)
        )
        polynomials.append(sp.Poly(expression, *variables, modulus=P).as_expr())
    for chart in range(dimension):
        remaining = [v for index, v in enumerate(variables) if index != chart]
        affine = [
            sp.Poly(poly.subs(variables[chart], 1), *remaining, modulus=P).as_expr()
            for poly in polynomials
        ]
        basis = sp.groebner(affine, *remaining, modulus=P, order="lex")
        if not (len(basis.polys) == 1 and basis.polys[0].as_expr() == 1):
            return False, len(rows)
    return True, len(rows)


def binary_boundary_value(point, roots):
    left, right = (int(x) % P for x in point)
    value = 1
    for root in roots:
        value = value * (right - root * left) % P
    return value


def multiplication_coordinates(
    core, records, lower, upper, degree, roots, transverse_degree
):
    """Rows express D_L*lower basis in the selected upper basis."""

    line_points = core.line_model.binary_grid(degree)
    transverse_points = core.line_model.transverse_grid(transverse_degree)
    upper_values = core.line_model.evaluate_basis(
        records, upper, line_points, transverse_points
    )
    upper_matrix = upper_values.transpose(0, 1, 3, 2).reshape(-1, len(upper)) % P
    _, pivot_observations = core.audit.rref(upper_matrix.T)
    assert len(pivot_observations) == len(upper)
    square = upper_matrix[list(pivot_observations), :] % P
    square_inverse = core.d12.inverse(square)

    lower_values = core.line_model.evaluate_basis(
        records, lower, line_points, transverse_points
    )
    divisor = np.asarray(
        [binary_boundary_value(point, roots) for point in line_points],
        dtype=np.int64,
    )
    targets = (
        lower_values * divisor[:, None, None, None]
    ).transpose(0, 1, 3, 2).reshape(-1, len(lower)) % P
    coordinates = (
        square_inverse @ targets[list(pivot_observations), :]
    ).T % P
    assert not np.any(upper_matrix @ coordinates.T % P - targets)
    return coordinates


def incident_coefficients_at_power(
    core,
    adapted_basis,
    records,
    selected,
    roots,
    target_point,
    target_bridge,
    triple,
    matrix,
    point_degree,
    boundary_power,
    monomials,
):
    """Generalization of the installed power-four associated-graded map."""

    target_adapted_basis = adapted_basis @ matrix.T % P
    target_adapted_inverse = core.d12.inverse(target_adapted_basis)
    triple_forward = core.point.eq.branch_forward_matrix(triple) % P
    flag_to_adapted = (
        target_adapted_inverse.T
        @ target_bridge["frame"][:, 1:]
        @ target_bridge["change"]
        @ triple_forward
    ) % P
    target_center = target_point.reshape(1, 5) @ target_adapted_inverse % P
    assert not np.any(target_center[0, 2:])
    assert not np.any(flag_to_adapted[2:, 0])
    normal_quotient = flag_to_adapted[2:, 1:] % P
    assert core.audit.rank(normal_quotient) == 3
    gradient = core.binary_boundary_gradient(target_center[0, :2], roots)
    h_coefficient = int(gradient @ flag_to_adapted[:2, 0] % P)
    assert h_coefficient
    boundary = core.poly_power(
        core.linear_poly([h_coefficient, 0, 0, 0]), boundary_power
    )
    monomial_index = {exponents: index for index, exponents in enumerate(monomials)}
    coefficients = np.zeros(
        (len(selected), 5, len(monomials)), dtype=np.int64
    )
    line_point = target_center[:, :2]
    for seed_index, (line_exponents, transverse_exponents, output) in enumerate(selected):
        for inverse, line_action, transverse_action in records:
            transformed_line = line_point @ line_action % P
            line_value = core.line_model.monomial_value(
                line_exponents, transformed_line[0]
            )
            if not line_value:
                continue
            transverse_xyz = transverse_action.T @ normal_quotient % P
            transverse_forms = np.column_stack(
                (np.zeros(3, dtype=np.int64), transverse_xyz)
            )
            transverse_polynomial = core.monomial_poly(
                transverse_forms, transverse_exponents
            )
            polynomial = core.poly_mul(boundary, transverse_polynomial)
            assert all(sum(exponents) == point_degree for exponents in polynomial)
            target_output = matrix @ inverse[:, output] % P
            for exponents, scalar in polynomial.items():
                coefficients[seed_index, :, monomial_index[exponents]] = (
                    coefficients[seed_index, :, monomial_index[exponents]]
                    + scalar * line_value * target_output
                ) % P
    local_from_normal = core.d12.inverse(triple_forward)
    substitution = assembled_substitution_matrix(
        core, local_from_normal, point_degree, monomials
    )
    return np.einsum("som,mn->son", coefficients, substitution) % P


def assembled_substitution_matrix(core, linear_map, degree, monomials):
    index = {exponents: position for position, exponents in enumerate(monomials)}
    answer = np.zeros((len(monomials), len(monomials)), dtype=np.int64)
    forms = [core.linear_poly(row) for row in linear_map]
    for source, exponents in enumerate(monomials):
        polynomial = {(0, 0, 0, 0): 1}
        for form, exponent in zip(forms, exponents):
            if exponent:
                polynomial = core.poly_mul(
                    polynomial, core.poly_power(form, exponent)
                )
        for target, coefficient in polynomial.items():
            answer[source, index[target]] = coefficient
    return answer


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--order", type=int, default=3)
    parser.add_argument("--max-line-degree", type=int, default=8)
    parser.add_argument("--power-count", type=int, default=6)
    parser.add_argument("--boundary-power-start", type=int)
    parser.add_argument("--emit-m2-line-degree", type=int)
    parser.add_argument("--emit-directory", type=Path, default=HERE)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    assert args.order >= 3 and args.order % 2 == 1
    r = (args.order - 1) // 2
    transverse_degree = 3 * r + 3
    first_boundary_power = 3 * r + 1
    boundary_power_start = (
        args.boundary_power_start
        if args.boundary_power_start is not None
        else first_boundary_power
    )
    assert boundary_power_start >= first_boundary_power
    # The producer's compute module expects its helper under the literal name
    # ``analyze``.  Load both without executing either main routine.
    core = load("analyze", BOUNDARY_DIR / "analyze.py")
    assembled = load("goal_g_boundary_compute", BOUNDARY_DIR / "compute.py")
    source = json.loads((PACKET / "boundary_interface.json").read_text())
    reynolds = core.audit.load(core.audit.REYNOLDS, "goal_g_boundary_reynolds")
    module = reynolds.load_reynolds_module()
    adapted_basis, records = core.line_model.line_records(module)
    _, planes = core.planes_audit.plus_planes()
    source_points = [
        np.asarray(record["ambient_vector"], dtype=np.int64) % P
        for record in source["D12_points_on_representative_line"]
    ]
    source_line_coordinates = [
        record["representative_line_coordinates"]
        for record in source["D12_points_on_representative_line"]
    ]
    roots = [int(coordinates[1]) % P for coordinates in source_line_coordinates]
    source_bridges = [
        core.conjugation(
            point,
            tuple(record["incident_plane_indices"]),
            planes,
            module.GROUP,
        )
        for point, record in zip(
            source_points, source["D12_points_on_representative_line"]
        )
    ]
    representative_line = np.asarray(source["representative_line_rows"], dtype=np.int64) % P
    target_point = source_points[0]
    target_bridge = source_bridges[0]
    branch_to_plane = target_bridge["normal_branch_to_plane"]
    triples = ((0, 3, 6), (1, 4, 6), (2, 5, 6))
    target_lines = [
        assembled.line_intersection(
            tuple(branch_to_plane[index] for index in triple), planes
        )
        for triple in triples
    ]
    transports = [
        assembled.find_transports(
            module.GROUP,
            representative_line,
            source_points,
            target_line,
            target_point,
        )[0]
        for target_line in target_lines
    ]
    saved_selected = {
        line_degree: core.line_model.select_basis(
            module, records, args.order, transverse_degree, line_degree
        )[0]
        for line_degree in range(0, args.max_line_degree + 1)
    }
    records_out = []

    for boundary_power in range(
        boundary_power_start, boundary_power_start + args.power_count
    ):
        point_degree = transverse_degree + boundary_power
        local_data = core.point.d12_local_data(args.order, point_degree)
        monomials = core.point.weak_compositions(point_degree, 4)
        central_slice = assembled.normal_branch_slice(local_data, 6)
        for line_degree in range(0, args.max_line_degree + 1):
            selected = saved_selected[line_degree]
            contributions = []
            for triple, (matrix, _source_index, _image_scalar) in enumerate(transports):
                coefficients = incident_coefficients_at_power(
                    core,
                    adapted_basis,
                    records,
                    selected,
                    roots,
                    target_point,
                    target_bridge,
                    triple,
                    matrix,
                    point_degree,
                    boundary_power,
                    monomials,
                )
                jets = np.stack(
                    [
                        coefficients[:, output, :]
                        @ local_data["normalization_jet_matrix"].T
                        % P
                        for output in range(5)
                    ],
                    axis=1,
                )
                contributions.append(jets)
            equations = []
            for triple in (1, 2):
                difference = (
                    contributions[triple][:, :, central_slice]
                    - contributions[0][:, :, central_slice]
                ) % P
                equations.append(
                    difference.transpose(1, 2, 0).reshape(-1, len(selected))
                )
            equations = np.vstack(equations) % P
            reduced, pivots = core.independent_rows(equations)
            kernel = core.nullspace_rows(reduced)
            if line_degree < 3:
                multiplication = np.zeros((0, len(selected)), dtype=np.int64)
            else:
                multiplication = multiplication_coordinates(
                    core,
                    records,
                    saved_selected[line_degree - 3],
                    selected,
                    line_degree,
                    roots,
                    transverse_degree,
                )
            excluded_subspace_linears = None
            if len(multiplication):
                _, pivot_columns = core.audit.rref(kernel)
                assert len(pivot_columns) == len(kernel)
                square = kernel[:, list(pivot_columns)] % P
                coordinates = (
                    multiplication[:, list(pivot_columns)]
                    @ core.d12.inverse(square)
                ) % P
                assert not np.any(coordinates @ kernel % P - multiplication)
                excluded_subspace_linears = core.nullspace_rows(coordinates)
                assert len(excluded_subspace_linears) == len(kernel) - len(multiplication)
            quotient_landing_empty = None
            quotient_landing_row_rank = None
            boundary_quotient_landing_empty = None
            boundary_quotient_landing_row_rank = None
            if (
                args.emit_m2_line_degree == line_degree
                or (
                    args.emit_m2_line_degree is None
                    and line_degree in (2, 3)
                )
            ):
                quotient_landing_empty, quotient_landing_row_rank = (
                    restricted_landing_is_empty(
                        core,
                        module,
                        records,
                        selected,
                        kernel,
                        line_degree,
                        transverse_degree,
                        m2_path=(
                            args.emit_directory
                            / f"m{args.order}_line{line_degree}_central_landing.m2"
                            if args.emit_m2_line_degree == line_degree
                            else None
                        ),
                        excluded_subspace_linears=excluded_subspace_linears,
                    )
                )
                (
                    boundary_quotient_landing_empty,
                    boundary_quotient_landing_row_rank,
                ) = restricted_landing_is_empty(
                    core,
                    module,
                    records,
                    selected,
                    kernel,
                    line_degree,
                    transverse_degree,
                    line_points=source_line_coordinates,
                )

            branch_slices = [
                assembled.normal_branch_slice(local_data, branch)
                for branch in range(7)
            ]
            assembled_by_output = []
            for output in range(5):
                point_rows = np.zeros(
                    (
                        len(kernel),
                        7 * len(local_data["normalization_basis"]),
                    ),
                    dtype=np.int64,
                )
                for triple, (left, right, _central) in enumerate(triples):
                    for branch in (left, right):
                        point_rows[:, branch_slices[branch]] = (
                            kernel
                            @ contributions[triple][
                                :, output, branch_slices[branch]
                            ]
                            % P
                        )
                point_rows[:, branch_slices[6]] = (
                    kernel @ contributions[0][:, output, branch_slices[6]] % P
                )
                assert not np.any(
                    local_data["line_constraint_matrix"] @ point_rows.T % P
                )
                assembled_by_output.append(point_rows)
            residual = np.concatenate(
                [
                    core.point.quotient_coordinates(local_data, rows)
                    for rows in assembled_by_output
                ],
                axis=1,
            )
            residual_rank = core.audit.rank(residual) if residual.size else 0
            residual_kernel = assembled.left_kernel_rows(residual)
            survivor = residual_kernel @ kernel % P
            survivor = (
                core.independent_rows(survivor)[0]
                if len(survivor)
                else np.zeros((0, len(selected)), dtype=np.int64)
            )

            equality = rowspace_key(core, survivor) == rowspace_key(
                core, multiplication
            )
            record = {
                "boundary_power": boundary_power,
                "point_degree": point_degree,
                "line_degree": line_degree,
                "source_dimension": len(selected),
                "central_equation_rank": len(pivots),
                "central_kernel_dimension": len(kernel),
                "central_quotient_landing_projectively_empty": quotient_landing_empty,
                "central_quotient_landing_row_rank": quotient_landing_row_rank,
                "boundary_value_landing_projectively_empty": boundary_quotient_landing_empty,
                "boundary_value_landing_row_rank": boundary_quotient_landing_row_rank,
                "residual_rank_on_central_kernel": residual_rank,
                "survivor_dimension_after_residual": len(survivor),
                "D_L_times_degree_minus_3_dimension": len(multiplication),
                "survivor_equals_D_L_multiple": equality,
            }
            records_out.append(record)
            print(record)

    payload = {
        "prime": P,
        "symbolic_order": args.order,
        "transverse_degree": transverse_degree,
        "boundary_divisor": "D_L=(l1-42*l0)(l1-58*l0)(l1-66*l0)",
        "tested_boundary_powers": [
            boundary_power_start,
            boundary_power_start + args.power_count - 1,
        ],
        "tested_line_degrees": [0, args.max_line_degree],
        "records": records_out,
        "scope": (
            "Finite split-F67 reconstruction of the central evaluation map. "
            "The low-degree residual divisibility equality stops after the "
            "finite residual point module; this is not an all-degree or "
            "characteristic-zero headline conclusion."
        ),
    }
    output_path = args.output or (
        HERE / f"m{args.order}_line_boundary_recurrence_f67.json"
    )
    output_path.write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n"
    )
    print("G_LINE_BOUNDARY_RECURRENCE_F67_OK")


if __name__ == "__main__":
    main()
