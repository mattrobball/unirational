#!/usr/bin/env python3
"""Produce exact Frobenius data for the 27 lines on six smooth fibres.

The finite computations use the Grassmann chart

    [S:T:u0*S+u1*T:u2*S+u3*T]

after the recorded linear change of projective coordinates.  Four equations
are obtained by setting the coefficients of S^3, S^2*T, S*T^2, T^3 equal to
zero.  Singular verifies that the resulting quotient has dimension 27 and
that u3 has a squarefree degree-27 eliminant.  Thus u3 is a primitive
coordinate on the complete reduced 27-line scheme of the smooth cubic, and
the irreducible factor degrees are the Frobenius cycle lengths.

This producer deliberately does not infer full W(E6) monodromy.  The final
JSON records exactly which modular arithmetic groups are constrained and the
extra bridge needed before drawing a characteristic-zero conclusion.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import math
import re
import subprocess
import warnings
from collections import Counter, deque
from pathlib import Path

import sympy as sp
from sympy.utilities.exceptions import SymPyDeprecationWarning


HERE = Path(__file__).resolve().parent
MODEL_PATH = HERE / "fibration_model.json"
OUTPUT_PATH = HERE / "line_frobenius_specializations.json"

IDENTITY = [[int(row == column) for column in range(4)] for row in range(4)]
SPECIALIZATIONS = [
    {"prime": 23, "q0": 0, "coordinate_matrix": IDENTITY},
    {
        "prime": 23,
        "q0": 1,
        "coordinate_matrix": [
            [10, 22, 8, 4],
            [6, 5, 6, 6],
            [20, 14, 16, 3],
            [13, 21, 1, 0],
        ],
    },
    {"prime": 23, "q0": 3, "coordinate_matrix": IDENTITY},
    {"prime": 67, "q0": 0, "coordinate_matrix": IDENTITY},
    {"prime": 67, "q0": 1, "coordinate_matrix": IDENTITY},
    {"prime": 67, "q0": 2, "coordinate_matrix": IDENTITY},
]

S, T = sp.symbols("S T")
X = sp.symbols("x0:4")
U = sp.symbols("u0:4")


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def canonical_hash(value: object) -> str:
    return sha256_bytes(
        json.dumps(value, separators=(",", ":"), sort_keys=True).encode()
    )


def run_singular(script: str, timeout: int = 600) -> str:
    completed = subprocess.run(
        ["Singular", "-q"],
        input=script,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=True,
        timeout=timeout,
    )
    require("?" not in completed.stdout, "Singular diagnostic:\n" + completed.stdout)
    return completed.stdout


def marker(output: str, name: str) -> str:
    match = re.search(rf"^{re.escape(name)}=(.*)$", output, re.MULTILINE)
    require(match is not None, f"missing marker {name}:\n{output}")
    return match.group(1).strip()


def determinant_mod(matrix: list[list[int]], prime: int) -> int:
    data = [[entry % prime for entry in row] for row in matrix]
    answer = 1
    for column in range(4):
        pivot = next((row for row in range(column, 4) if data[row][column]), None)
        if pivot is None:
            return 0
        if pivot != column:
            data[column], data[pivot] = data[pivot], data[column]
            answer = -answer
        value = data[column][column]
        answer = answer * value % prime
        inverse = pow(value, -1, prime)
        data[column] = [entry * inverse % prime for entry in data[column]]
        for row in range(column + 1, 4):
            multiple = data[row][column]
            if multiple:
                data[row] = [
                    (left - multiple * right) % prime
                    for left, right in zip(data[row], data[column])
                ]
    return answer % prime


def specialized_cubic(reduction: dict, q0: int) -> sp.Poly:
    prime = int(reduction["prime"])
    expression = 0
    for term in reduction["generic_fibre_terms_a0_a1_a2_u_q"]:
        exponents = [int(value) for value in term["exponents"]]
        coefficient = int(term["coefficient"]) * pow(q0, exponents[4], prime)
        monomial = coefficient
        for variable, exponent in zip(X, exponents[:4]):
            monomial *= variable**exponent
        expression += monomial
    return sp.Poly(expression, X, modulus=prime)


def line_equations(
    cubic: sp.Poly, matrix: list[list[int]], prime: int
) -> list[sp.Poly]:
    chart = (S, T, U[0] * S + U[1] * T, U[2] * S + U[3] * T)
    original_coordinates = [
        sum(matrix[row][column] * chart[column] for column in range(4))
        for row in range(4)
    ]
    restricted = sp.Poly(
        cubic.as_expr().subs(dict(zip(X, original_coordinates))),
        S,
        T,
        *U,
        modulus=prime,
    )
    equations: list[sp.Poly] = []
    for t_power in range(4):
        s_power = 3 - t_power
        expression = 0
        for monomial, coefficient in restricted.terms():
            if monomial[0] == s_power and monomial[1] == t_power:
                expression += coefficient * sp.prod(
                    variable**exponent
                    for variable, exponent in zip(U, monomial[2:])
                )
        equations.append(sp.Poly(expression, U, modulus=prime))
    return equations


def canonical_terms(poly: sp.Poly, prime: int) -> list[dict]:
    return [
        {
            "exponents": [int(value) for value in monomial],
            "coefficient_mod_p": int(coefficient) % prime,
        }
        for monomial, coefficient in poly.terms()
        if int(coefficient) % prime
    ]


def singular_text(poly: sp.Poly) -> str:
    return str(poly.as_expr()).replace("**", "^")


def parse_eliminant(text: str, prime: int) -> tuple[sp.Poly, list[int]]:
    expression = sp.sympify(text.replace("^", "**"), locals={"u3": U[3]})
    polynomial = sp.Poly(expression, U[3], modulus=prime).monic()
    coefficients_descending = [int(value) % prime for value in polynomial.all_coeffs()]
    return polynomial, list(reversed(coefficients_descending))


def factor_degrees(poly: sp.Poly, prime: int) -> list[int]:
    with warnings.catch_warnings():
        warnings.simplefilter("ignore", SymPyDeprecationWarning)
        _, factors = sp.factor_list(poly, modulus=prime)
    return sorted(
        int(factor.degree())
        for factor, multiplicity in factors
        for _ in range(int(multiplicity))
    )


def check_smooth(cubic: sp.Poly, prime: int) -> dict[str, bool]:
    f = singular_text(cubic)
    lines = [
        f"ring r={prime},(x0,x1,x2,x3),dp;",
        f"poly F={f};",
        "ideal J=F,diff(F,x0),diff(F,x1),diff(F,x2),diff(F,x3);",
    ]
    for variable in ("x0", "x1", "x2", "x3"):
        lines.extend(
            [
                f"ideal I_{variable}=J,{variable}-1;",
                f"ideal G_{variable}=std(I_{variable});",
                f'print("SMOOTH_{variable}="+string(reduce(1,G_{variable})==0));',
            ]
        )
    output = run_singular("\n".join(lines))
    return {
        variable: marker(output, f"SMOOTH_{variable}") == "1"
        for variable in ("x0", "x1", "x2", "x3")
    }


def line_classes() -> list[tuple[int, ...]]:
    lines: list[tuple[int, ...]] = []
    for index in range(6):
        vector = [0] * 7
        vector[index + 1] = 1
        lines.append(tuple(vector))
    for left in range(6):
        for right in range(left + 1, 6):
            vector = [0] * 7
            vector[0] = 1
            vector[left + 1] = vector[right + 1] = -1
            lines.append(tuple(vector))
    for omitted in range(6):
        vector = [2] + [-1] * 6
        vector[omitted + 1] = 0
        lines.append(tuple(vector))
    require(len(set(lines)) == 27, "line-class construction")
    return sorted(lines)


def simple_roots() -> list[tuple[int, ...]]:
    roots: list[tuple[int, ...]] = []
    for index in range(1, 6):
        root = [0] * 7
        root[index], root[index + 1] = 1, -1
        roots.append(tuple(root))
    roots.append((1, -1, -1, -1, 0, 0, 0))
    return roots


def reflect(vector: tuple[int, ...], root: tuple[int, ...]) -> tuple[int, ...]:
    pairing = vector[0] * root[0] - sum(
        vector[index] * root[index] for index in range(1, 7)
    )
    return tuple(vector[index] + pairing * root[index] for index in range(7))


def permutation_cycle_type(permutation: tuple[int, ...]) -> tuple[int, ...]:
    seen: set[int] = set()
    lengths: list[int] = []
    for start in range(len(permutation)):
        if start in seen:
            continue
        current = start
        length = 0
        while current not in seen:
            seen.add(current)
            length += 1
            current = permutation[current]
        lengths.append(length)
    return tuple(sorted(lengths))


def weyl_cycle_inventory() -> Counter[tuple[int, ...]]:
    lines = line_classes()
    indices = {line: index for index, line in enumerate(lines)}
    generators = [
        tuple(indices[reflect(line, root)] for line in lines)
        for root in simple_roots()
    ]
    identity = tuple(range(27))
    group = {identity}
    queue: deque[tuple[int, ...]] = deque([identity])
    while queue:
        permutation = queue.popleft()
        for generator in generators:
            product = tuple(generator[permutation[index]] for index in range(27))
            if product not in group:
                group.add(product)
                queue.append(product)
    require(len(group) == 51840, "unexpected W(E6) order")
    return Counter(permutation_cycle_type(permutation) for permutation in group)


def specialization_certificate(reduction: dict, specification: dict) -> dict:
    prime = int(specification["prime"])
    q0 = int(specification["q0"])
    matrix = specification["coordinate_matrix"]
    require(determinant_mod(matrix, prime) != 0, "singular coordinate matrix")
    cubic = specialized_cubic(reduction, q0)
    smooth_charts = check_smooth(cubic, prime)
    require(all(smooth_charts.values()), f"p={prime}, q0={q0}: singular surface")

    equations = line_equations(cubic, matrix, prime)
    ideal = ",".join(singular_text(poly) for poly in equations)
    dimension_output = run_singular(
        "\n".join(
            [
                f"ring r={prime},(u0,u1,u2,u3),dp;",
                f"ideal I={ideal}; ideal G=std(I);",
                'print("VDIM="+string(vdim(G)));',
            ]
        )
    )
    quotient_dimension = int(marker(dimension_output, "VDIM"))
    require(quotient_dimension == 27, f"p={prime}, q0={q0}: line length")

    elimination_output = run_singular(
        "\n".join(
            [
                f"ring r={prime},(u0,u1,u2,u3),lp;",
                f"ideal I={ideal}; ideal G=std(I);",
                "ideal E=eliminate(G,u0*u1*u2);",
                'print("ESIZE="+string(size(E)));',
                'print("ELIM="+string(E[1]));',
                'print("EDEG="+string(deg(E[1])));',
                'print("GCDDEG="+string(deg(gcd(E[1],diff(E[1],u3)))));',
            ]
        )
    )
    require(int(marker(elimination_output, "ESIZE")) == 1, "elimination size")
    require(int(marker(elimination_output, "EDEG")) == 27, "eliminant degree")
    require(int(marker(elimination_output, "GCDDEG")) == 0, "eliminant squarefree")
    eliminant, coefficients = parse_eliminant(marker(elimination_output, "ELIM"), prime)
    degrees = factor_degrees(eliminant, prime)
    require(sum(degrees) == 27, "factor degrees")

    return {
        "prime": prime,
        "q0": q0,
        "specialized_cubic_terms": canonical_terms(cubic, prime),
        "smooth_surface": {
            "method": "projective gradient ideal is the unit ideal in every xi=1 chart",
            "projective_gradient_unit_by_chart": smooth_charts,
        },
        "grassmann_chart": {
            "coordinate_matrix_original_x_equals_matrix_times_chart_y_mod_p": matrix,
            "matrix_determinant_mod_p": determinant_mod(matrix, prime),
            "chart_parametrization_y": [
                "S",
                "T",
                "u0*S+u1*T",
                "u2*S+u3*T",
            ],
            "plucker_open": "p01 != 0 after the recorded coordinate change",
        },
        "line_scheme": {
            "coefficient_order": ["S^3", "S^2*T", "S*T^2", "T^3"],
            "coefficient_equations": [canonical_terms(poly, prime) for poly in equations],
            "quotient_dimension_over_Fp": quotient_dimension,
            "elimination_ideal_in_Fp_u3_generator_coefficients_ascending": coefficients,
            "eliminant_sha256": canonical_hash(coefficients),
            "eliminant_degree": eliminant.degree(),
            "eliminant_squarefree": True,
            "u3_is_primitive": True,
            "u3_primitive_reason": (
                "the u3 minimal polynomial and the line quotient algebra both have dimension 27"
            ),
            "irreducible_factor_degrees": degrees,
            "frobenius_cycle_lengths_on_27_lines": degrees,
            "frobenius_permutation_order": math.lcm(*degrees),
            "all_27_geometric_lines_lie_in_this_chart": True,
            "completeness_reason": (
                "the surface is smooth, hence has exactly 27 geometric lines; "
                "this affine line scheme is reduced of length 27"
            ),
        },
    }


def build_certificate() -> dict:
    model_bytes = MODEL_PATH.read_bytes()
    model = json.loads(model_bytes)
    reductions = {int(entry["prime"]): entry for entry in model["good_reductions"]}
    specializations = [
        specialization_certificate(reductions[int(spec["prime"])], spec)
        for spec in SPECIALIZATIONS
    ]

    inventory = weyl_cycle_inventory()
    observed_types = sorted(
        {
            tuple(entry["line_scheme"]["frobenius_cycle_lengths_on_27_lines"])
            for entry in specializations
        }
    )
    require(all(inventory[cycle_type] for cycle_type in observed_types), "W(E6) cycle type")

    by_prime: dict[str, list[list[int]]] = {}
    for entry in specializations:
        by_prime.setdefault(str(entry["prime"]), []).append(
            entry["line_scheme"]["frobenius_cycle_lengths_on_27_lines"]
        )

    return {
        "schema": "m3-27-line-frobenius-specializations-v1",
        "producer": "produce_line_frobenius.py",
        "input": {
            "fibration_model": MODEL_PATH.name,
            "fibration_model_sha256": sha256_bytes(model_bytes),
            "generic_fibre_term_key": "generic_fibre_terms_a0_a1_a2_u_q",
        },
        "specializations": specializations,
        "modular_arithmetic_monodromy_constraints": {
            "meaning": (
                "For each characteristic separately, the arithmetic monodromy of "
                "the 27-line cover over the smooth q-locus contains Frobenius "
                "elements with every displayed cycle type."
            ),
            "cycle_types_by_prime": by_prime,
        },
        "ambient_W_E6_compatibility": {
            "basis": ["h", "e1", "e2", "e3", "e4", "e5", "e6"],
            "line_classes": "6 exceptional + 15 transforms of plane lines + 6 transforms of conics",
            "enumerated_group_order": 51840,
            "line_action_degree": 27,
            "observed_cycle_type_element_counts_in_full_W_E6": [
                {
                    "cycle_type": list(cycle_type),
                    "element_count": inventory[cycle_type],
                }
                for cycle_type in observed_types
            ],
            "meaning": "Every observed factor pattern is a cycle type occurring in W(E6).",
        },
        "strict_scope": {
            "unconditional": [
                "six displayed finite-field cubic surfaces are smooth",
                "each displayed Grassmann chart contains the complete reduced 27-line scheme",
                "the displayed factor degrees are exact Frobenius cycle lengths",
                "the p=23 and p=67 modular arithmetic monodromy groups contain the recorded types",
            ],
            "characteristic_zero_bridge": (
                "Transferring these Frobenius classes to one characteristic-zero arithmetic "
                "generic group requires a verified common integral 27-line cover and the relevant "
                "specialization maps; transferring them to geometric monodromy requires an "
                "additional constant-field/geometric argument."
            ),
            "not_established": [
                "simultaneous labels for Frobenius elements from different fibres or primes",
                "the Schlaefli incidence graph in any displayed line algebra",
                "generators or the order of the actual generic line-monodromy subgroup",
                "full arithmetic or geometric W(E6) monodromy",
                "the algebraic Brauer group or a rational point or section",
            ],
            "status_marker": "ACTUAL_GENERIC_27_LINE_MONODROMY_UNRESOLVED",
        },
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    certificate = build_certificate()
    rendered = json.dumps(certificate, indent=2, sort_keys=True) + "\n"
    if args.write:
        OUTPUT_PATH.write_text(rendered)
    else:
        require(OUTPUT_PATH.exists(), f"missing {OUTPUT_PATH.name}; use --write")
        require(OUTPUT_PATH.read_text() == rendered, "stored certificate differs from replay")
    for entry in certificate["specializations"]:
        print(
            f"P{entry['prime']}_Q{entry['q0']}_27_LINES="
            + ",".join(
                str(value)
                for value in entry["line_scheme"]["frobenius_cycle_lengths_on_27_lines"]
            )
        )
    print("M3_27_LINE_FROBENIUS_SPECIALIZATIONS_EXACT")
    print("ACTUAL_GENERIC_27_LINE_MONODROMY_UNRESOLVED")


if __name__ == "__main__":
    main()
