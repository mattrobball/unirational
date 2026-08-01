#!/usr/bin/env python3
"""Exact six-evaluation solve for the canonical degree-11 A5 covariants.

This is an independent small-equation consumer for the exact Reynolds
covariants produced by ``point_attack_degree11_20260801/exact_reynolds.py``.
The key compression is that an invariant of degree 33 is in

    f15 * <f2^9, f2^6*f6, f2^3*f6^2, f6^3, f2^4*f10, f2*f6*f10>.

Consequently six evaluations whose invariant-value matrix is nonsingular
give the complete landing ideal, rather than merely a sampled ideal.
"""

from __future__ import annotations

from collections import deque
from fractions import Fraction
import importlib.util
import itertools
import json
from math import gcd, lcm
from pathlib import Path
import subprocess


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
POINT_DIR = ROOT / "point_attack_degree11_20260801"
PAYLOAD = POINT_DIR / "degree11_covariants_exact.json"
P = 89
SQRT5_MOD = 19

Q5 = tuple[Fraction, Fraction]
U4 = tuple[Fraction, Fraction, Fraction, Fraction]
ZERO5: Q5 = (Fraction(0), Fraction(0))
ONE5: Q5 = (Fraction(1), Fraction(0))
ZEROU: U4 = (Fraction(0),) * 4
ONEU: U4 = (Fraction(1), Fraction(0), Fraction(0), Fraction(0))


def q5(a=0, b=0) -> Q5:
    return Fraction(a), Fraction(b)


def qadd(left: Q5, right: Q5) -> Q5:
    return left[0] + right[0], left[1] + right[1]


def qmul(left: Q5, right: Q5) -> Q5:
    a, b = left
    c, d = right
    return a * c + 5 * b * d, a * d + b * c


def qpow(value: Q5, exponent: int) -> Q5:
    out = ONE5
    while exponent:
        if exponent & 1:
            out = qmul(out, value)
        value = qmul(value, value)
        exponent //= 2
    return out


def qmod(value: Q5) -> int:
    def reduce_fraction(item: Fraction) -> int:
        return item.numerator * pow(item.denominator, -1, P) % P

    return (reduce_fraction(value[0]) + SQRT5_MOD * reduce_fraction(value[1])) % P


def uscale(scalar, value: U4) -> U4:
    scalar = Fraction(scalar)
    return tuple(scalar * coefficient for coefficient in value)  # type: ignore[return-value]


def uadd(left: U4, right: U4) -> U4:
    return tuple(a + b for a, b in zip(left, right))  # type: ignore[return-value]


def umul(left: U4, right: U4) -> U4:
    """Multiply modulo u^4+12u^2+256, where u=sqrt(5)+sqrt(-11)."""
    raw = [Fraction(0)] * 7
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            raw[i + j] += a * b
    for degree in range(6, 3, -1):
        coefficient = raw[degree]
        raw[degree - 2] -= 12 * coefficient
        raw[degree - 4] -= 256 * coefficient
    return tuple(raw[:4])  # type: ignore[return-value]


def q5_to_u(value: Q5) -> U4:
    # sqrt(5)=(4u-u^3)/32.
    a, b = value
    return a, b / 8, Fraction(0), -b / 32


def mmul(left, right):
    out = []
    for i in range(len(left)):
        row = []
        for j in range(len(right[0])):
            value = ZERO5
            for k in range(len(right)):
                value = qadd(value, qmul(left[i][k], right[k][j]))
            row.append(value)
        out.append(row)
    return out


def identity(size):
    return [[ONE5 if i == j else ZERO5 for j in range(size)] for i in range(size)]


def load_group_module():
    path = ROOT.parents[0] / "goals_2026-08-01" / "H_SUBGROUP_TWISTS_CODEX_ROOT_20260801" / "build_a5_twists.py"
    spec = importlib.util.spec_from_file_location("degree11_group", path)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


GROUP = load_group_module()


def source_representation():
    alpha = q5(Fraction(-1, 2), Fraction(-1, 2))
    generators = (
        ((1, 2, 3, 4, 0), [
            [alpha, q5(-alpha[0], -alpha[1]), q5(-1)],
            [alpha, ONE5, ZERO5],
            [alpha, q5(-alpha[0], -alpha[1]), ZERO5],
        ]),
        ((0, 1, 3, 4, 2), [
            [ZERO5, q5(-1), q5(-alpha[0], -alpha[1])],
            [ZERO5, ZERO5, ONE5],
            [q5(-1), q5(-alpha[0], -alpha[1]), ZERO5],
        ]),
    )
    out = {GROUP.PID: identity(3)}
    queue = deque([GROUP.PID])
    while queue:
        current = queue.popleft()
        for generator, matrix in generators:
            candidate = GROUP.pcompose(current, generator)
            candidate_matrix = mmul(out[current], matrix)
            if candidate in out:
                assert out[candidate] == candidate_matrix
            else:
                out[candidate] = candidate_matrix
                queue.append(candidate)
    assert len(out) == 60
    return out


SOURCE = source_representation()


def linear_value(row, point) -> Q5:
    out = ZERO5
    for coefficient, value in zip(row, point):
        out = qadd(out, qmul(coefficient, q5(value)))
    return out


def invariant_values_mod(point):
    values = {}
    derivatives = {}
    for degree in (2, 6, 10):
        total = ZERO5
        gradient = [ZERO5, ZERO5, ZERO5]
        for matrix in SOURCE.values():
            linear = linear_value(matrix[2], point)
            total = qadd(total, qpow(linear, degree))
            power = qpow(linear, degree - 1)
            for coordinate in range(3):
                gradient[coordinate] = qadd(
                    gradient[coordinate],
                    qmul(q5(degree), qmul(power, matrix[2][coordinate])),
                )
        values[degree] = qmod(total)
        derivatives[degree] = [qmod(item) for item in gradient]
    jacobian = [derivatives[degree] for degree in (2, 6, 10)]
    f15 = (
        jacobian[0][0] * (jacobian[1][1] * jacobian[2][2] - jacobian[1][2] * jacobian[2][1])
        - jacobian[0][1] * (jacobian[1][0] * jacobian[2][2] - jacobian[1][2] * jacobian[2][0])
        + jacobian[0][2] * (jacobian[1][0] * jacobian[2][1] - jacobian[1][1] * jacobian[2][0])
    ) % P
    f2, f6, f10 = values[2], values[6], values[10]
    return [
        f15 * pow(f2, 9, P),
        f15 * pow(f2, 6, P) * f6,
        f15 * pow(f2, 3, P) * pow(f6, 2, P),
        f15 * pow(f6, 3, P),
        f15 * pow(f2, 4, P) * f10,
        f15 * f2 * f6 * f10,
    ]


def echelon_add(echelon, original):
    row = [value % P for value in original]
    for pivot, old in echelon:
        if row[pivot]:
            scalar = row[pivot]
            row = [(a - scalar * b) % P for a, b in zip(row, old)]
    pivot = next((i for i, value in enumerate(row) if value), None)
    if pivot is None:
        return False
    inverse = pow(row[pivot], -1, P)
    row = [inverse * value % P for value in row]
    for index, (old_pivot, old) in enumerate(echelon):
        if old[pivot]:
            scalar = old[pivot]
            echelon[index] = (
                old_pivot,
                [(a - scalar * b) % P for a, b in zip(old, row)],
            )
    echelon.append((pivot, row))
    echelon.sort()
    return True


def choose_six_points():
    points = []
    echelon = []
    preferred = (
        (1, 2, 3), (1, 2, 4), (1, 2, 5),
        (1, 2, 6), (1, 2, 7), (1, 3, 2),
    )
    candidates = itertools.chain(
        preferred,
        ((y0, y1, 1) for y0 in range(10) for y1 in range(10)),
    )
    for point in candidates:
        if echelon_add(echelon, invariant_values_mod(point)):
            points.append(point)
            if len(points) == 6:
                return points
    raise AssertionError("no six-point invariant interpolation witness found")


def deserialize_q5(item) -> Q5:
    rational = item["rational"]
    radical = item["sqrt5"]
    return q5(Fraction(*rational), Fraction(*radical))


def load_covariants():
    data = json.loads(PAYLOAD.read_text())
    assert data["field"] == "Q(s), s^2=5"
    result = []
    for covariant in data["covariants"]:
        result.append([
            {
                tuple(map(int, exponent.split(","))): deserialize_q5(coefficient)
                for exponent, coefficient in component.items()
            }
            for component in covariant
        ])
    assert len(result) == 5 and all(len(item) == 5 for item in result)
    return result, data["seeds"]


def evaluate_poly(polynomial, point) -> Q5:
    out = ZERO5
    for exponent, coefficient in polynomial.items():
        scalar = coefficient
        for value, power in zip(point, exponent):
            scalar = qmul(scalar, q5(value ** power))
        out = qadd(out, scalar)
    return out


PARAMETER_MONOMIALS = tuple(
    exponent
    for exponent in itertools.product(range(4), repeat=5)
    if sum(exponent) == 3
)


def parameter_add(left, right):
    out = dict(left)
    for exponent, coefficient in right.items():
        out[exponent] = uadd(out.get(exponent, ZEROU), coefficient)
        if not any(out[exponent]):
            del out[exponent]
    return out


def parameter_mul(left, right):
    out = {}
    for ea, ca in left.items():
        for eb, cb in right.items():
            exponent = tuple(a + b for a, b in zip(ea, eb))
            out[exponent] = uadd(out.get(exponent, ZEROU), umul(ca, cb))
    return {exponent: coefficient for exponent, coefficient in out.items() if any(coefficient)}


O_PLUS = (
    (0, 1, 2), (0, 1, 3), (0, 2, 4), (0, 3, 5), (0, 4, 5),
    (1, 2, 5), (1, 3, 4), (1, 4, 5), (2, 3, 4), (2, 3, 5),
)
O_MINUS = (
    (0, 1, 4), (0, 1, 5), (0, 2, 3), (0, 2, 5), (0, 3, 4),
    (1, 2, 3), (1, 2, 4), (1, 3, 5), (2, 4, 5), (3, 4, 5),
)


def evaluated_landing_equation(covariants, point, class_index):
    forms = []
    for coordinate in range(5):
        form = {}
        for parameter, covariant in enumerate(covariants):
            coefficient = q5_to_u(evaluate_poly(covariant[coordinate], point))
            if any(coefficient):
                exponent = tuple(int(i == parameter) for i in range(5))
                form[exponent] = coefficient
        forms.append(form)
    sixth = {}
    for form in forms:
        sixth = parameter_add(sixth, {
            exponent: uscale(-1, coefficient) for exponent, coefficient in form.items()
        })
    forms.append(sixth)

    # lambda_1=(13-r)/18 and lambda_2=(13+r)/18, r=sqrt(-11).
    sign = -1 if class_index == 1 else 1
    lam = (
        Fraction(13, 18),
        sign * Fraction(7, 144),
        Fraction(0),
        sign * Fraction(1, 576),
    )
    out = {}
    for orbit, scalar in ((O_PLUS, ONEU), (O_MINUS, lam)):
        for i, j, k in orbit:
            term = parameter_mul(parameter_mul(forms[i], forms[j]), forms[k])
            out = parameter_add(out, {
                exponent: umul(scalar, coefficient) for exponent, coefficient in term.items()
            })
    return out


def fraction_text(value: Fraction):
    if value.denominator == 1:
        return str(value.numerator)
    return f"({value.numerator}/{value.denominator})"


def u_text(value: U4):
    terms = []
    for power, coefficient in enumerate(value):
        if not coefficient:
            continue
        factor = fraction_text(coefficient)
        if power:
            factor += "*u" if power == 1 else f"*u^{power}"
        terms.append(factor)
    return "+".join(terms).replace("+-", "-") if terms else "0"


def equation_text(polynomial, chart=0):
    variables = [f"a{i}" for i in range(5)]
    terms = []
    for exponent, coefficient in sorted(polynomial.items()):
        factors = []
        for index, power in enumerate(exponent):
            if index == chart or not power:
                continue
            factors.append(variables[index] if power == 1 else f"{variables[index]}^{power}")
        monomial = "*".join(factors) if factors else "1"
        terms.append(f"({u_text(coefficient)})*{monomial}")
    return "+".join(terms) if terms else "0"


def remove_rational_content(polynomial):
    entries = [
        entry
        for coefficient in polynomial.values()
        for entry in coefficient
        if entry
    ]
    denominator = 1
    for entry in entries:
        denominator = lcm(denominator, entry.denominator)
    numerator = 0
    for entry in entries:
        numerator = gcd(
            numerator,
            abs(entry.numerator * (denominator // entry.denominator)),
        )
    assert numerator
    content = Fraction(numerator, denominator)
    return {
        exponent: tuple(entry / content for entry in coefficient)
        for exponent, coefficient in polynomial.items()
    }


def singular_solve(class_index, equations):
    input_path = HERE / f"class_{class_index}_six_eval_dp.sing"
    output_path = HERE / f"class_{class_index}_six_eval_dp.txt"
    expressions = ",\n".join(
        equation_text(remove_rational_content(equation))
        for equation in equations
    )
    input_path.write_text(
        "ring r=(0,u),(a1,a2,a3,a4),dp;\n"
        "minpoly=u^4+12*u^2+256;\n"
        f"ideal I={expressions};\n"
        "option(redSB);\n"
        "ideal G=std(I);\n"
        'if (reduce(1,G)==0) { print("UNIT"); } else { print("NONUNIT"); G; }\n'
        "dim(G);\n"
        "vdim(G);\n"
        "quit;\n"
    )
    result = subprocess.run(
        ["/opt/homebrew/bin/Singular", "-q", str(input_path)],
        check=True,
        capture_output=True,
        text=True,
    )
    output_path.write_text(result.stdout)
    return result.stdout


def main():
    assert pow(SQRT5_MOD, 2, P) == 5
    points = choose_six_points()
    assert len(points) == 6
    covariants, seeds = load_covariants()
    print("six_exact_interpolation_points", points, flush=True)
    print("degree11_reynolds_seeds", seeds, flush=True)
    # Class 1 is obtained from class 2 by the coefficient-field automorphism
    # sqrt(-11) -> -sqrt(-11), so one exact nonemptiness computation suffices.
    for class_index in (2,):
        equations = [
            evaluated_landing_equation(covariants, point, class_index)
            for point in points
        ]
        assert all(equations)
        transcript = singular_solve(class_index, equations)
        print(f"class_{class_index}_singular", flush=True)
        print(transcript, end="", flush=True)
    print("class_1_follows_by_sqrt_minus11_conjugation", flush=True)
    print("H3_A5_DEGREE11_SIX_EVAL_OK")


if __name__ == "__main__":
    main()
