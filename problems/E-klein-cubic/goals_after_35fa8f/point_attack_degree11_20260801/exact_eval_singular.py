#!/usr/bin/env python3
"""Fast exact landing solver using six injective degree-33 evaluations."""

from __future__ import annotations

from fractions import Fraction
from math import gcd, lcm
from pathlib import Path
import hashlib
import json
import subprocess
import sys


HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import exact_reynolds as exact  # noqa: E402


POINTS = ((1, 2, 3), (1, 2, 4), (1, 2, 5), (1, 2, 6), (1, 2, 7), (1, 3, 2))
PARAMETER_MONOMIALS = exact.modp.monomials(5, 3)


def evaluate_source_polynomial(polynomial, point):
    total = exact.ZERO
    for exponent, coefficient in polynomial.items():
        scalar = 1
        for coordinate, power in zip(point, exponent):
            scalar *= coordinate ** power
        total = exact.qadd(total, exact.qscale(scalar, coefficient))
    return total


def evaluated_covariants(covariants, point):
    return [
        [evaluate_source_polynomial(component, point) for component in covariant]
        for covariant in covariants
    ]


def one_evaluation_equation(covariants, point, t_upoly=exact.T_UPOLY):
    values = evaluated_covariants(covariants, point)
    equation = {}
    for orbit_index, cubic in enumerate((exact.O0, exact.O1)):
        for target_exponent, target_coefficient in cubic.items():
            coordinates = []
            for coordinate, multiplicity in enumerate(target_exponent):
                coordinates.extend([coordinate] * multiplicity)
            for selections in __import__("itertools").product(range(5), repeat=3):
                coefficient = target_coefficient
                for selection, coordinate in zip(selections, coordinates):
                    coefficient = exact.qmul(coefficient, values[selection][coordinate])
                parameter_exponent = tuple(selections.count(index) for index in range(5))
                embedded = exact.q5_upoly(coefficient)
                if orbit_index:
                    embedded = exact.umul(embedded, t_upoly)
                equation[parameter_exponent] = exact.uadd(
                    equation.get(parameter_exponent, (Fraction(0),) * 4), embedded
                )
    return {exponent: coefficient for exponent, coefficient in equation.items() if any(coefficient)}


def modular_rank_add(basis, vector, prime):
    work = [value % prime for value in vector]
    for pivot, old in basis:
        if work[pivot]:
            scalar = work[pivot]
            work = [(a - scalar * b) % prime for a, b in zip(work, old)]
    pivot = next((index for index, value in enumerate(work) if value), None)
    if pivot is None:
        return False
    inverse = pow(work[pivot], -1, prime)
    work = [inverse * value % prime for value in work]
    for index, (old_pivot, old) in enumerate(basis):
        if old[pivot]:
            scalar = old[pivot]
            basis[index] = (
                old_pivot,
                [(a - scalar * b) % prime for a, b in zip(old, work)],
            )
    basis.append((pivot, work))
    basis.sort()
    return True


def evaluation_injectivity_mod89():
    prime, sqrt5 = 89, 19
    source = exact.modp.base.source_representation(prime, sqrt5)
    degree33 = exact.modp.monomials(3, 33)
    basis = []
    witnesses = []
    for exponent in degree33:
        evaluations = []
        for point in POINTS:
            total = 0
            for g in exact.modp.base.A5_PERMS:
                moved = exact.modp.base.mv(source[g], point, prime)
                value = 1
                for coordinate, power in zip(moved, exponent):
                    value = value * pow(coordinate, power, prime) % prime
                total = (total + value) % prime
            evaluations.append(total)
        if modular_rank_add(basis, evaluations, prime):
            witnesses.append((exponent, evaluations))
            if len(basis) == 6:
                break
    assert len(basis) == 6
    return witnesses


def chart_expression(polynomial):
    variables = ("1", "a1", "a2", "a3", "a4")
    terms = []
    for exponent, coefficient in sorted(polynomial.items()):
        factors = []
        for variable, power in zip(variables, exponent):
            if variable == "1" or not power:
                continue
            factors.append(variable if power == 1 else f"{variable}^{power}")
        monomial = "*".join(factors) if factors else "1"
        terms.append(f"({exact.upoly_text(coefficient)})*{monomial}")
    return "+".join(terms) if terms else "0"


def remove_rational_content(polynomial):
    entries = [entry for coefficient in polynomial.values() for entry in coefficient if entry]
    common_denominator = 1
    for entry in entries:
        common_denominator = lcm(common_denominator, entry.denominator)
    common_numerator = 0
    for entry in entries:
        integer = entry.numerator * (common_denominator // entry.denominator)
        common_numerator = gcd(common_numerator, abs(integer))
    assert common_numerator
    content = Fraction(common_numerator, common_denominator)
    return {
        exponent: tuple(entry / content for entry in coefficient)
        for exponent, coefficient in polynomial.items()
    }


def write_singular(equations):
    path = HERE / "degree11_exact_six_evaluations.sing"
    expressions = [chart_expression(remove_rational_content(equation)) for equation in equations]
    path.write_text(
        "ring r=(0,u),(a1,a2,a3,a4),lp;\n"
        "minpoly=u^4+12*u^2+256;\n"
        f"ideal I={','.join(expressions)};\n"
        "ideal J=std(I);\n"
        'if (reduce(1,J)==0) { print("UNIT"); } else { print("NONUNIT"); J; }\n'
        'print("VDIM"); vdim(J);\n'
        "quit;\n"
    )
    return path


def main():
    source = exact.exact_source_representation()
    covariants = [exact.reynolds_covariant(*seed, source) for seed in exact.SEEDS]
    for covariant in covariants:
        exact.verify_covariant(covariant, source)
    witnesses = evaluation_injectivity_mod89()
    print("degree33_evaluation_rank_mod89=6")
    print("reynolds_witnesses=", witnesses)
    equations = [one_evaluation_equation(covariants, point) for point in POINTS]
    assert all(equation for equation in equations)
    input_path = write_singular(equations)
    result = subprocess.run(
        ["/opt/homebrew/bin/Singular", "-q", str(input_path)],
        check=True,
        capture_output=True,
        text=True,
    )
    transcript_path = HERE / "degree11_exact_six_evaluations.txt"
    transcript_path.write_text(result.stdout)
    print(result.stdout, end="")
    assert result.stdout.splitlines()[0].strip() == "NONUNIT"
    payload = {
        "coefficient_field": {
            "primitive_element": "u=sqrt(5)+sqrt(-11)",
            "minimal_polynomial": "u^4+12*u^2+256",
            "sqrt5": "(4*u-u^3)/32",
            "sqrt_minus11": "(u^3+28*u)/32",
            "class_parameter_used": "t=(13+sqrt(-11))/18",
            "conjugate_class_parameter": "(13-sqrt(-11))/18",
        },
        "degree_33_invariant_dimension": 6,
        "evaluation_points": [list(point) for point in POINTS],
        "evaluation_rank_mod_89": 6,
        "evaluation_reynolds_witnesses": [
            {"seed_exponent": list(exponent), "values": values}
            for exponent, values in witnesses
        ],
        "chart": "a0=1",
        "singular_input_sha256": hashlib.sha256(input_path.read_bytes()).hexdigest(),
        "singular_transcript_sha256": hashlib.sha256(transcript_path.read_bytes()).hexdigest(),
    }
    payload_path = HERE / "degree11_exact_six_evaluations.json"
    payload_path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("H3_EXACT_SIX_EVALUATION_SOLVER_OK")


if __name__ == "__main__":
    main()
