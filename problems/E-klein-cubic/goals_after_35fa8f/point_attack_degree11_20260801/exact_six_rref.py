#!/usr/bin/env python3
"""Fast exact characteristic-zero degree-11 landing decision.

This uses the row-reduced exact Reynolds basis from ``exact_degree11.py``.
For an A5-invariant degree-33 source form, evaluation at the six displayed
source points is injective; this is certified by a rank-six Reynolds witness
modulo 89 together with the degree-33 Molien coefficient.  Hence the full
landing identity is equivalent to six cubic equations in P^4.

The two exact Klein pencil parameters are handled separately over the
quartic field Q(u), u=sqrt(5)+sqrt(-11), u^4+12u^2+256=0.
"""

from __future__ import annotations

from fractions import Fraction
from itertools import product
from math import gcd, lcm
from pathlib import Path
import hashlib
import importlib.util
import json
import subprocess


HERE = Path(__file__).resolve().parent


def import_file(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


exact = import_file("h3_exact_degree11_rref", HERE / "exact_degree11.py")


UPoly = tuple[Fraction, Fraction, Fraction, Fraction]
UZERO: UPoly = (Fraction(0),) * 4
UONE: UPoly = (Fraction(1), Fraction(0), Fraction(0), Fraction(0))

POINTS = ((1, 2, 3), (1, 2, 4), (1, 2, 5), (1, 2, 6), (1, 2, 7), (1, 3, 2))
PARAMETER_MONOMIALS = exact.canonical.monomials(5, 3)


def uadd(left: UPoly, right: UPoly) -> UPoly:
    return tuple(a + b for a, b in zip(left, right))  # type: ignore[return-value]


def uneg(value: UPoly) -> UPoly:
    return tuple(-item for item in value)  # type: ignore[return-value]


def umul(left: UPoly, right: UPoly) -> UPoly:
    raw = [Fraction(0)] * 7
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            raw[i + j] += a * b
    # u^4=-12u^2-256.
    for degree in range(6, 3, -1):
        coefficient = raw[degree]
        raw[degree - 2] -= 12 * coefficient
        raw[degree - 4] -= 256 * coefficient
    return tuple(raw[:4])  # type: ignore[return-value]


def q5_to_u(value):
    # sqrt(5)=(4u-u^3)/32.
    a, b = value
    return a, b / 8, Fraction(0), -b / 32


SQRT_MINUS11_U: UPoly = (Fraction(0), Fraction(7, 8), Fraction(0), Fraction(1, 32))
LAMBDA = {
    1: uadd((Fraction(13, 18), Fraction(0), Fraction(0), Fraction(0)),
            tuple(-item / 18 for item in SQRT_MINUS11_U)),
    2: uadd((Fraction(13, 18), Fraction(0), Fraction(0), Fraction(0)),
            tuple(item / 18 for item in SQRT_MINUS11_U)),
}


def evaluate_q5_polynomial(polynomial, point):
    total = exact.ZERO
    for exponent, coefficient in polynomial.items():
        scalar = 1
        for coordinate, power in zip(point, exponent):
            scalar *= coordinate ** power
        total = exact.qadd(total, exact.qscale(scalar, coefficient))
    return total


def evaluated_covariants(covariants, point):
    return [
        [evaluate_q5_polynomial(component, point) for component in covariant]
        for covariant in covariants
    ]


def evaluation_equation(covariants, point, class_index):
    values = evaluated_covariants(covariants, point)
    equation = {}
    first, second = exact.canonical.CUBIC_BASIS
    for pencil_index, cubic in enumerate((first, second)):
        for target_exponent, target_coefficient in cubic.items():
            coordinates = []
            for coordinate, multiplicity in enumerate(target_exponent):
                coordinates.extend([coordinate] * multiplicity)
            for selections in product(range(5), repeat=3):
                coefficient = exact.q5(target_coefficient)
                for selection, coordinate in zip(selections, coordinates):
                    coefficient = exact.qmul(coefficient, values[selection][coordinate])
                embedded = q5_to_u(coefficient)
                if pencil_index:
                    embedded = umul(embedded, LAMBDA[class_index])
                parameter_exponent = tuple(selections.count(i) for i in range(5))
                equation[parameter_exponent] = uadd(
                    equation.get(parameter_exponent, UZERO), embedded
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
    # Reduce the exact Q(sqrt(5)) source matrices already reconstructed from
    # the authoritative ROOT_019FBE10 packet.  This deliberately avoids the
    # older exploratory subgroup packet.
    source = {
        g: [[exact.qmod(entry, prime, sqrt5) for entry in row] for row in matrix]
        for g, matrix in exact.SOURCE.items()
    }
    degree33 = exact.canonical.monomials(3, 33)
    basis = []
    witnesses = []
    for exponent in degree33:
        evaluations = []
        for point in POINTS:
            total = 0
            for g in exact.base.PERMS:
                moved = exact.base.mv(source[g], point)
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
    # Coefficient of t^33 in (1+t^15)/((1-t^2)(1-t^6)(1-t^10)).
    dimension = sum(
        1
        for use_15 in (0, 1)
        for a in range(17)
        for b in range(6)
        for c in range(4)
        if 15 * use_15 + 2 * a + 6 * b + 10 * c == 33
    )
    assert dimension == 6
    return witnesses


def fraction_text(value):
    return str(value.numerator) if value.denominator == 1 else f"({value.numerator}/{value.denominator})"


def upoly_text(value):
    terms = []
    for power, coefficient in enumerate(value):
        if not coefficient:
            continue
        monomial = "1" if power == 0 else ("u" if power == 1 else f"u^{power}")
        terms.append(f"({fraction_text(coefficient)})*{monomial}")
    return "+".join(terms) if terms else "0"


def remove_content(polynomial):
    entries = [entry for coefficient in polynomial.values() for entry in coefficient if entry]
    denominator = 1
    for entry in entries:
        denominator = lcm(denominator, entry.denominator)
    numerator = 0
    for entry in entries:
        numerator = gcd(numerator, abs(entry.numerator * (denominator // entry.denominator)))
    assert numerator
    content = Fraction(numerator, denominator)
    return {
        exponent: tuple(entry / content for entry in coefficient)
        for exponent, coefficient in polynomial.items()
    }


def chart_expression(polynomial):
    variables = ("1", "a1", "a2", "a3", "a4")
    terms = []
    for exponent, coefficient in sorted(polynomial.items()):
        factors = []
        for variable, power in zip(variables, exponent):
            if variable != "1" and power:
                factors.append(variable if power == 1 else f"{variable}^{power}")
        terms.append(f"({upoly_text(coefficient)})*{'*'.join(factors) if factors else '1'}")
    return "+".join(terms) if terms else "0"


def run_singular(class_index, equations):
    input_path = HERE / f"class_{class_index}_exact_rref_dp.sing"
    transcript_path = HERE / f"class_{class_index}_exact_rref_dp.txt"
    expressions = [chart_expression(remove_content(equation)) for equation in equations]
    input_path.write_text(
        "ring r=(0,u),(a1,a2,a3,a4),dp;\n"
        "minpoly=u^4+12*u^2+256;\n"
        f"ideal I={','.join(expressions)};\n"
        "option(redSB); ideal J=std(I);\n"
        'if (reduce(1,J)==0) { print("UNIT"); } else { print("NONUNIT"); J; }\n'
        'print("VDIM"); vdim(J);\n'
        "quit;\n"
    )
    result = subprocess.run(
        ["/opt/homebrew/bin/Singular", "-q", str(input_path)],
        check=True,
        capture_output=True,
        text=True,
    )
    transcript_path.write_text(result.stdout)
    print(result.stdout, end="", flush=True)
    assert result.stdout.splitlines()[0].strip() == "NONUNIT"
    return input_path, transcript_path


def run_lex(class_index, equations):
    input_path = HERE / f"class_{class_index}_exact_rref_lex.sing"
    transcript_path = HERE / f"class_{class_index}_exact_rref_lex.txt"
    expressions = [chart_expression(remove_content(equation)) for equation in equations]
    input_path.write_text(
        "ring r=(0,u),(a1,a2,a3,a4),lp;\n"
        "minpoly=u^4+12*u^2+256;\n"
        f"ideal I={','.join(expressions)};\n"
        "ideal J=stdfglm(I,\"std\");\n"
        'if (reduce(1,J)==0) { print("UNIT"); } else { print("NONUNIT"); J; }\n'
        "ideal R=reduce(I,J);\n"
        "int reductions_ok=1; int reduction_index;\n"
        "for (reduction_index=1; reduction_index<=size(R); reduction_index++) "
        "{ if (R[reduction_index]!=0) { reductions_ok=0; } }\n"
        'if (reductions_ok==1) { print("ALL_SIX_REDUCE_ZERO"); } '
        'else { print("REDUCTION_FAILURE"); R; }\n'
        'print("VDIM"); vdim(J);\n'
        "quit;\n"
    )
    result = subprocess.run(
        ["/opt/homebrew/bin/Singular", "-q", str(input_path)],
        check=True,
        capture_output=True,
        text=True,
    )
    transcript_path.write_text(result.stdout)
    print(result.stdout, end="", flush=True)
    lines = result.stdout.splitlines()
    assert lines[0].strip() == "NONUNIT"
    assert "ALL_SIX_REDUCE_ZERO" in lines
    assert lines[-2:] == ["VDIM", "3"]
    lex_basis = [line for line in lines if line.startswith("J[")]
    assert len(lex_basis) == 4
    return input_path, transcript_path, lex_basis


def main():
    raw, seeds, actions = exact.reynolds_basis()
    covariants = exact.rref_covariants(raw)
    exact.verify_covariance(covariants, actions)
    witnesses = evaluation_injectivity_mod89()
    print("degree33_invariant_dimension=6", flush=True)
    print("evaluation_rank_mod89=6", flush=True)
    print("evaluation_witnesses=", witnesses, flush=True)
    for class_index in (1, 2):
        equations = [
            evaluation_equation(covariants, point, class_index)
            for point in POINTS
        ]
        assert all(equations)
        input_path, transcript_path = run_singular(class_index, equations)
        lex_input, lex_transcript, lex_basis = run_lex(class_index, equations)
        payload = {
            "format": "h3-a5-exact-degree11-rref-v1",
            "class": class_index,
            "coefficient_field": {
                "primitive_element": "u=sqrt(5)+sqrt(-11)",
                "minimal_polynomial": "u^4+12*u^2+256",
                "sqrt5": "(4*u-u^3)/32",
                "sqrt_minus11": "(u^3+28*u)/32",
                "pencil_parameter": (
                    "(13-sqrt(-11))/18" if class_index == 1
                    else "(13+sqrt(-11))/18"
                ),
            },
            "reynolds_seeds": [[output, list(exponent)] for output, exponent in seeds],
            "covariant_basis": "exact RREF of the five Reynolds covariants",
            "degree33_invariant_dimension": 6,
            "evaluation_points": [list(point) for point in POINTS],
            "evaluation_rank_mod89": 6,
            "singular_input": input_path.name,
            "singular_input_sha256": hashlib.sha256(input_path.read_bytes()).hexdigest(),
            "singular_transcript": transcript_path.name,
            "singular_transcript_sha256": hashlib.sha256(transcript_path.read_bytes()).hexdigest(),
            "lex_input": lex_input.name,
            "lex_input_sha256": hashlib.sha256(lex_input.read_bytes()).hexdigest(),
            "lex_transcript": lex_transcript.name,
            "lex_transcript_sha256": hashlib.sha256(lex_transcript.read_bytes()).hexdigest(),
            "lex_basis": lex_basis,
            "all_six_equations_reduce_to_zero": True,
            "algebraic_point": {
                "coordinates": "[1 : a1(theta) : a2(theta) : a3(theta) : theta]",
                "theta": "any root of J[1] in an algebraic closure of Q(u)",
                "a3": "the unique quadratic polynomial in theta determined by J[2]=0",
                "a2": "the unique quadratic polynomial in theta determined by J[3]=0",
                "a1": "the unique quadratic polynomial in theta determined by J[4]=0",
            },
        }
        output = HERE / f"class_{class_index}_exact_rref.json"
        output.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
        print("wrote", output, flush=True)
    print("H3_EXACT_DEGREE11_RREF_OK")


if __name__ == "__main__":
    main()
