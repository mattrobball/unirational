#!/usr/bin/env python3
"""Independent verifier for ``line_frobenius_specializations.json``.

The load-bearing line equations are reconstructed by a small dictionary
polynomial engine, not by importing the producer or repeating its SymPy
substitution.  Singular independently recomputes smoothness, quotient lengths,
and eliminants.  A pure-Python distinct-degree factorization check recovers the
Frobenius cycle lengths from the stored eliminant coefficients.
"""

from __future__ import annotations

import hashlib
import json
import re
import subprocess
from collections import Counter, deque
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
MODEL_PATH = HERE / "fibration_model.json"
CERT_PATH = HERE / "line_frobenius_specializations.json"

IDENTITY = [[int(row == column) for column in range(4)] for row in range(4)]
EXPECTED_SPECS = [
    (23, 0, IDENTITY),
    (
        23,
        1,
        [
            [10, 22, 8, 4],
            [6, 5, 6, 6],
            [20, 14, 16, 3],
            [13, 21, 1, 0],
        ],
    ),
    (23, 3, IDENTITY),
    (67, 0, IDENTITY),
    (67, 1, IDENTITY),
    (67, 2, IDENTITY),
]

EXPECTED_CYCLE_TYPES = {
    (23, 0): [1, 4, 4, 6, 12],
    (23, 1): [1, 1, 1, 1, 1, 2, 4, 4, 4, 4, 4],
    (23, 3): [1, 4, 4, 6, 12],
    (67, 0): [3, 12, 12],
    (67, 1): [1, 1, 1, 2, 2, 2, 6, 6, 6],
    (67, 2): [1, 2, 2, 2, 2, 3, 3, 6, 6],
}

EXPECTED_W_COUNTS = {
    (1, 4, 4, 6, 12): 4320,
    (1, 1, 1, 1, 1, 2, 4, 4, 4, 4, 4): 1620,
    (3, 12, 12): 4320,
    (1, 1, 1, 2, 2, 2, 6, 6, 6): 1440,
    (1, 2, 2, 2, 2, 3, 3, 6, 6): 2160,
}


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def canonical_hash(value: object) -> str:
    return sha256_bytes(
        json.dumps(value, separators=(",", ":"), sort_keys=True).encode()
    )


def singular(script: str) -> str:
    result = subprocess.run(
        ["Singular", "-q"],
        input=script,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=True,
        timeout=600,
    )
    require("?" not in result.stdout, "Singular diagnostic:\n" + result.stdout)
    return result.stdout


def marker(output: str, name: str) -> str:
    match = re.search(rf"^{re.escape(name)}=(.*)$", output, re.MULTILINE)
    require(match is not None, f"missing marker {name}:\n{output}")
    return match.group(1).strip()


def determinant_mod(matrix: list[list[int]], prime: int) -> int:
    data = [[int(value) % prime for value in row] for row in matrix]
    determinant = 1
    for column in range(4):
        pivot = next((row for row in range(column, 4) if data[row][column]), None)
        if pivot is None:
            return 0
        if pivot != column:
            data[column], data[pivot] = data[pivot], data[column]
            determinant = -determinant
        pivot_value = data[column][column]
        determinant = determinant * pivot_value % prime
        inverse = pow(pivot_value, -1, prime)
        for row in range(column + 1, 4):
            multiplier = data[row][column] * inverse % prime
            for index in range(column, 4):
                data[row][index] = (
                    data[row][index] - multiplier * data[column][index]
                ) % prime
    return determinant % prime


def add_to(target: dict[tuple[int, ...], int], source: dict, prime: int) -> None:
    for monomial, coefficient in source.items():
        value = (target.get(monomial, 0) + coefficient) % prime
        if value:
            target[monomial] = value
        else:
            target.pop(monomial, None)


def multiply_dicts(left: dict, right: dict, prime: int) -> dict[tuple[int, ...], int]:
    answer: dict[tuple[int, ...], int] = {}
    for left_monomial, left_coefficient in left.items():
        for right_monomial, right_coefficient in right.items():
            monomial = tuple(
                left_value + right_value
                for left_value, right_value in zip(left_monomial, right_monomial)
            )
            coefficient = left_coefficient * right_coefficient % prime
            answer[monomial] = (answer.get(monomial, 0) + coefficient) % prime
    return {monomial: value for monomial, value in answer.items() if value}


def specialized_cubic_dict(terms: list[dict], q0: int, prime: int) -> dict:
    cubic: dict[tuple[int, ...], int] = {}
    for term in terms:
        exponents = tuple(int(value) for value in term["exponents"])
        coefficient = (
            int(term["coefficient"]) * pow(q0, exponents[4], prime)
        ) % prime
        monomial = exponents[:4]
        cubic[monomial] = (cubic.get(monomial, 0) + coefficient) % prime
    return {monomial: value for monomial, value in cubic.items() if value}


def chart_linear_forms(matrix: list[list[int]], prime: int) -> list[dict]:
    # Exponent order is S,T,u0,u1,u2,u3.  This independently expands
    # x = matrix * (S,T,u0*S+u1*T,u2*S+u3*T)^t.
    forms: list[dict[tuple[int, ...], int]] = []
    monomials = [
        (1, 0, 0, 0, 0, 0),
        (0, 1, 0, 0, 0, 0),
        (1, 0, 1, 0, 0, 0),
        (0, 1, 0, 1, 0, 0),
        (1, 0, 0, 0, 1, 0),
        (0, 1, 0, 0, 0, 1),
    ]
    for row in matrix:
        coefficients = [row[0], row[1], row[2], row[2], row[3], row[3]]
        forms.append(
            {
                monomial: coefficient % prime
                for monomial, coefficient in zip(monomials, coefficients)
                if coefficient % prime
            }
        )
    return forms


def line_equation_dicts(
    terms: list[dict], q0: int, matrix: list[list[int]], prime: int
) -> list[dict]:
    forms = chart_linear_forms(matrix, prime)
    restricted: dict[tuple[int, ...], int] = {}
    zero = (0, 0, 0, 0, 0, 0)
    for term in terms:
        exponents = [int(value) for value in term["exponents"]]
        coefficient = (
            int(term["coefficient"]) * pow(q0, exponents[4], prime)
        ) % prime
        summand: dict[tuple[int, ...], int] = {zero: coefficient}
        for coordinate, exponent in enumerate(exponents[:4]):
            for _ in range(exponent):
                summand = multiply_dicts(summand, forms[coordinate], prime)
        add_to(restricted, summand, prime)

    equations: list[dict[tuple[int, ...], int]] = []
    for t_power in range(4):
        target = (3 - t_power, t_power)
        equation = {
            monomial[2:]: coefficient
            for monomial, coefficient in restricted.items()
            if monomial[:2] == target
        }
        equations.append(equation)
    return equations


def canonical_terms(polynomial: dict) -> list[dict]:
    return [
        {
            "exponents": list(monomial),
            "coefficient_mod_p": int(polynomial[monomial]),
        }
        for monomial in sorted(polynomial, reverse=True)
    ]


def polynomial_text(polynomial: dict, names: tuple[str, ...]) -> str:
    terms: list[str] = []
    for monomial in sorted(polynomial, reverse=True):
        coefficient = polynomial[monomial]
        factors = [] if coefficient == 1 else [str(coefficient)]
        for name, exponent in zip(names, monomial):
            if exponent == 1:
                factors.append(name)
            elif exponent:
                factors.append(f"{name}^{exponent}")
        terms.append("*".join(factors) if factors else "1")
    return "+".join(terms) if terms else "0"


def parse_eliminant(text: str, prime: int) -> list[int]:
    u3 = sp.symbols("u3")
    poly = sp.Poly(
        sp.sympify(text.replace("^", "**"), locals={"u3": u3}),
        u3,
        modulus=prime,
    )
    coefficients = [int(value) % prime for value in reversed(poly.all_coeffs())]
    inverse = pow(coefficients[-1], -1, prime)
    return [(value * inverse) % prime for value in coefficients]


# Elementary ascending-coefficient polynomial arithmetic over F_p.
def trim(poly: list[int]) -> list[int]:
    answer = list(poly)
    while len(answer) > 1 and answer[-1] == 0:
        answer.pop()
    return answer or [0]


def poly_sub(left: list[int], right: list[int], prime: int) -> list[int]:
    size = max(len(left), len(right))
    return trim(
        [
            ((left[index] if index < len(left) else 0)
             - (right[index] if index < len(right) else 0))
            % prime
            for index in range(size)
        ]
    )


def poly_multiply(left: list[int], right: list[int], prime: int) -> list[int]:
    answer = [0] * (len(left) + len(right) - 1)
    for left_index, left_value in enumerate(left):
        for right_index, right_value in enumerate(right):
            answer[left_index + right_index] = (
                answer[left_index + right_index] + left_value * right_value
            ) % prime
    return trim(answer)


def poly_divmod(
    dividend: list[int], divisor: list[int], prime: int
) -> tuple[list[int], list[int]]:
    dividend = trim([value % prime for value in dividend])
    divisor = trim([value % prime for value in divisor])
    require(divisor != [0], "polynomial division by zero")
    if len(dividend) < len(divisor):
        return [0], dividend
    quotient = [0] * (len(dividend) - len(divisor) + 1)
    remainder = list(dividend)
    inverse = pow(divisor[-1], -1, prime)
    while remainder != [0] and len(remainder) >= len(divisor):
        shift = len(remainder) - len(divisor)
        coefficient = remainder[-1] * inverse % prime
        quotient[shift] = coefficient
        for index, value in enumerate(divisor):
            remainder[index + shift] = (
                remainder[index + shift] - coefficient * value
            ) % prime
        remainder = trim(remainder)
    return trim(quotient), remainder


def poly_monic(poly: list[int], prime: int) -> list[int]:
    poly = trim(poly)
    require(poly != [0], "zero polynomial cannot be monic")
    inverse = pow(poly[-1], -1, prime)
    return [(value * inverse) % prime for value in poly]


def poly_gcd(left: list[int], right: list[int], prime: int) -> list[int]:
    left, right = trim(left), trim(right)
    while right != [0]:
        _, remainder = poly_divmod(left, right, prime)
        left, right = right, remainder
    return poly_monic(left, prime)


def poly_mod(poly: list[int], modulus: list[int], prime: int) -> list[int]:
    return poly_divmod(poly, modulus, prime)[1]


def poly_powmod(
    base: list[int], exponent: int, modulus: list[int], prime: int
) -> list[int]:
    answer = [1]
    base = poly_mod(base, modulus, prime)
    while exponent:
        if exponent & 1:
            answer = poly_mod(poly_multiply(answer, base, prime), modulus, prime)
        exponent >>= 1
        if exponent:
            base = poly_mod(poly_multiply(base, base, prime), modulus, prime)
    return answer


def squarefree(coefficients: list[int], prime: int) -> bool:
    derivative = [
        index * coefficients[index] % prime
        for index in range(1, len(coefficients))
    ]
    return len(poly_gcd(coefficients, derivative, prime)) == 1


def distinct_factor_degrees(coefficients: list[int], prime: int) -> list[int]:
    remaining = poly_monic(coefficients, prime)
    degrees: list[int] = []
    x = [0, 1]
    for degree in range(1, len(coefficients)):
        if len(remaining) == 1:
            break
        frobenius = poly_powmod(x, prime**degree, remaining, prime)
        factor = poly_gcd(remaining, poly_sub(frobenius, x, prime), prime)
        factor_degree = len(factor) - 1
        if factor_degree:
            require(factor_degree % degree == 0, "distinct-degree divisibility")
            degrees.extend([degree] * (factor_degree // degree))
            quotient, remainder = poly_divmod(remaining, factor, prime)
            require(remainder == [0], "distinct-degree exact quotient")
            remaining = poly_monic(quotient, prime)
    require(len(remaining) == 1, "distinct-degree factorization incomplete")
    return sorted(degrees)


def line_classes() -> list[tuple[int, ...]]:
    classes: list[tuple[int, ...]] = []
    for index in range(1, 7):
        vector = [0] * 7
        vector[index] = 1
        classes.append(tuple(vector))
    for left in range(1, 7):
        for right in range(left + 1, 7):
            vector = [0] * 7
            vector[0], vector[left], vector[right] = 1, -1, -1
            classes.append(tuple(vector))
    for omitted in range(1, 7):
        vector = [2] + [-1] * 6
        vector[omitted] = 0
        classes.append(tuple(vector))
    require(len(set(classes)) == 27, "27 Picard line classes")
    return sorted(classes)


def roots() -> list[tuple[int, ...]]:
    answer: list[tuple[int, ...]] = []
    for index in range(1, 6):
        vector = [0] * 7
        vector[index], vector[index + 1] = 1, -1
        answer.append(tuple(vector))
    answer.append((1, -1, -1, -1, 0, 0, 0))
    return answer


def reflection(vector: tuple[int, ...], root: tuple[int, ...]) -> tuple[int, ...]:
    pairing = vector[0] * root[0] - sum(
        vector[index] * root[index] for index in range(1, 7)
    )
    return tuple(vector[index] + pairing * root[index] for index in range(7))


def cycle_type(permutation: tuple[int, ...]) -> tuple[int, ...]:
    unseen = set(range(len(permutation)))
    cycles: list[int] = []
    while unseen:
        start = min(unseen)
        current = start
        length = 0
        while current in unseen:
            unseen.remove(current)
            length += 1
            current = permutation[current]
        cycles.append(length)
    return tuple(sorted(cycles))


def weyl_inventory() -> Counter[tuple[int, ...]]:
    classes = line_classes()
    index = {line: position for position, line in enumerate(classes)}
    generators = [
        tuple(index[reflection(line, root)] for line in classes)
        for root in roots()
    ]
    identity = tuple(range(27))
    group = {identity}
    queue: deque[tuple[int, ...]] = deque([identity])
    while queue:
        permutation = queue.popleft()
        for generator in generators:
            product = tuple(permutation[generator[position]] for position in range(27))
            if product not in group:
                group.add(product)
                queue.append(product)
    require(len(group) == 51840, "full W(E6) enumeration")
    return Counter(cycle_type(permutation) for permutation in group)


def verify_specialization(reduction: dict, retained: dict, expected: tuple) -> None:
    prime, q0, matrix = expected
    require(retained["prime"] == prime and retained["q0"] == q0, "specialization identity")
    stored_matrix = retained["grassmann_chart"][
        "coordinate_matrix_original_x_equals_matrix_times_chart_y_mod_p"
    ]
    require(stored_matrix == matrix, f"p={prime},q={q0}: coordinate matrix")
    determinant = determinant_mod(matrix, prime)
    require(determinant != 0, f"p={prime},q={q0}: invertible matrix")
    require(
        retained["grassmann_chart"]["matrix_determinant_mod_p"] == determinant,
        f"p={prime},q={q0}: determinant retained",
    )

    terms = reduction["generic_fibre_terms_a0_a1_a2_u_q"]
    cubic = specialized_cubic_dict(terms, q0, prime)
    require(
        canonical_terms(cubic) == retained["specialized_cubic_terms"],
        f"p={prime},q={q0}: specialized cubic",
    )
    equations = line_equation_dicts(terms, q0, matrix, prime)
    require(
        [canonical_terms(equation) for equation in equations]
        == retained["line_scheme"]["coefficient_equations"],
        f"p={prime},q={q0}: independently expanded line equations",
    )

    f = polynomial_text(cubic, ("x0", "x1", "x2", "x3"))
    smooth_lines = [
        f"ring r={prime},(x0,x1,x2,x3),dp;",
        f"poly F={f};",
        "ideal J=F,diff(F,x0),diff(F,x1),diff(F,x2),diff(F,x3);",
    ]
    for variable in ("x0", "x1", "x2", "x3"):
        smooth_lines.extend(
            [
                f"ideal I_{variable}=J,{variable}-1; ideal G_{variable}=std(I_{variable});",
                f'print("SMOOTH_{variable}="+string(reduce(1,G_{variable})==0));',
            ]
        )
    smooth_output = singular("\n".join(smooth_lines))
    smooth = {
        variable: marker(smooth_output, f"SMOOTH_{variable}") == "1"
        for variable in ("x0", "x1", "x2", "x3")
    }
    require(all(smooth.values()), f"p={prime},q={q0}: smoothness")
    require(
        smooth == retained["smooth_surface"]["projective_gradient_unit_by_chart"],
        f"p={prime},q={q0}: retained smoothness",
    )

    ideal = ",".join(
        polynomial_text(equation, ("u0", "u1", "u2", "u3"))
        for equation in equations
    )
    dp_output = singular(
        "\n".join(
            [
                f"ring r={prime},(u0,u1,u2,u3),dp;",
                f"ideal I={ideal}; ideal G=std(I);",
                'print("VDIM="+string(vdim(G)));',
            ]
        )
    )
    quotient_dimension = int(marker(dp_output, "VDIM"))
    require(quotient_dimension == 27, f"p={prime},q={q0}: quotient dimension")
    require(
        retained["line_scheme"]["quotient_dimension_over_Fp"] == 27,
        f"p={prime},q={q0}: retained quotient dimension",
    )

    lp_output = singular(
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
    require(int(marker(lp_output, "ESIZE")) == 1, f"p={prime},q={q0}: elimination size")
    require(int(marker(lp_output, "EDEG")) == 27, f"p={prime},q={q0}: eliminant degree")
    require(int(marker(lp_output, "GCDDEG")) == 0, f"p={prime},q={q0}: Singular squarefree")
    coefficients = parse_eliminant(marker(lp_output, "ELIM"), prime)
    stored_coefficients = retained["line_scheme"][
        "elimination_ideal_in_Fp_u3_generator_coefficients_ascending"
    ]
    require(coefficients == stored_coefficients, f"p={prime},q={q0}: eliminant coefficients")
    require(canonical_hash(coefficients) == retained["line_scheme"]["eliminant_sha256"], f"p={prime},q={q0}: eliminant hash")
    require(squarefree(coefficients, prime), f"p={prime},q={q0}: independent squarefree")
    degrees = distinct_factor_degrees(coefficients, prime)
    require(degrees == EXPECTED_CYCLE_TYPES[(prime, q0)], f"p={prime},q={q0}: expected factor degrees")
    require(degrees == retained["line_scheme"]["irreducible_factor_degrees"], f"p={prime},q={q0}: retained factor degrees")
    require(degrees == retained["line_scheme"]["frobenius_cycle_lengths_on_27_lines"], f"p={prime},q={q0}: retained cycle lengths")
    require(retained["line_scheme"]["u3_is_primitive"] is True, f"p={prime},q={q0}: primitive flag")
    require(retained["line_scheme"]["all_27_geometric_lines_lie_in_this_chart"] is True, f"p={prime},q={q0}: complete chart flag")
    print(f"P{prime}_Q{q0}_27_LINE_CYCLE_TYPE=" + ",".join(str(value) for value in degrees))


def main() -> None:
    model_bytes = MODEL_PATH.read_bytes()
    model = json.loads(model_bytes)
    certificate = json.loads(CERT_PATH.read_text())
    require(certificate["schema"] == "m3-27-line-frobenius-specializations-v1", "schema")
    require(certificate["input"]["fibration_model_sha256"] == sha256_bytes(model_bytes), "input hash")
    require(len(certificate["specializations"]) == len(EXPECTED_SPECS), "specialization count")
    reductions = {int(entry["prime"]): entry for entry in model["good_reductions"]}
    for retained, expected in zip(certificate["specializations"], EXPECTED_SPECS):
        verify_specialization(reductions[expected[0]], retained, expected)

    inventory = weyl_inventory()
    require(
        {cycle_type: inventory[cycle_type] for cycle_type in EXPECTED_W_COUNTS}
        == EXPECTED_W_COUNTS,
        "observed W(E6) cycle-type counts",
    )
    retained_counts = {
        tuple(entry["cycle_type"]): int(entry["element_count"])
        for entry in certificate["ambient_W_E6_compatibility"][
            "observed_cycle_type_element_counts_in_full_W_E6"
        ]
    }
    require(retained_counts == EXPECTED_W_COUNTS, "retained W(E6) counts")
    require(certificate["ambient_W_E6_compatibility"]["enumerated_group_order"] == 51840, "retained W(E6) order")

    scope = certificate["strict_scope"]
    require(scope["status_marker"] == "ACTUAL_GENERIC_27_LINE_MONODROMY_UNRESOLVED", "scope marker")
    require(any("full arithmetic or geometric W(E6)" in item for item in scope["not_established"]), "full-W nonclaim")
    require(any("rational point or section" in item for item in scope["not_established"]), "section nonclaim")
    require("common integral 27-line cover" in scope["characteristic_zero_bridge"], "specialization bridge boundary")
    print("W_E6_OBSERVED_CYCLE_TYPES_COMPATIBLE")
    print("M3_27_LINE_FROBENIUS_SPECIALIZATIONS_EXACT")
    print("ACTUAL_GENERIC_27_LINE_MONODROMY_UNRESOLVED")


if __name__ == "__main__":
    main()
