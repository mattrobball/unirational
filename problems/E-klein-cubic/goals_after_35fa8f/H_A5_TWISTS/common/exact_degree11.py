#!/usr/bin/env python3
"""Exact degree-11 A5 covariants and landing points for both Klein classes.

The source is the faithful three-space over Q(sqrt(5)).  The target is the
rational augmentation representation on the six Sylow-5 subgroups, in the
basis e_0-e_5,...,e_4-e_5 used by ``../canonical_a5_pencil.py``.  Reynolds
averaging constructs a full five-dimensional degree-11 covariant space.

For the two transported Klein cubics we use the exact pencil parameters

    lambda_1 = (13-sqrt(-11))/18,
    lambda_2 = (13+sqrt(-11))/18.

The script computes the landing ideal over Q(sqrt(5),sqrt(-11)), eliminates
it on a projective chart, and emits a triangular algebraic point certificate.
"""

from __future__ import annotations

from fractions import Fraction
from itertools import product
from pathlib import Path
import argparse
import importlib.util
import json
import sys

import sympy as sp
from sympy.polys.domains import QQ


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent

spec = importlib.util.spec_from_file_location(
    "canonical_a5_pencil", ROOT / "canonical_a5_pencil.py"
)
assert spec and spec.loader
canonical = importlib.util.module_from_spec(spec)
spec.loader.exec_module(canonical)
base = canonical.base


# Elements a+b*s of Q(s), s^2=5, represented by pairs of Fractions.
Q5 = tuple[Fraction, Fraction]
ZERO: Q5 = (Fraction(0), Fraction(0))
ONE: Q5 = (Fraction(1), Fraction(0))


def q5(value=0, radical=0) -> Q5:
    return Fraction(value), Fraction(radical)


def qadd(left: Q5, right: Q5) -> Q5:
    return left[0] + right[0], left[1] + right[1]


def qneg(value: Q5) -> Q5:
    return -value[0], -value[1]


def qsub(left: Q5, right: Q5) -> Q5:
    return qadd(left, qneg(right))


def qmul(left: Q5, right: Q5) -> Q5:
    a, b = left
    c, d = right
    return a * c + 5 * b * d, a * d + b * c


def qinv(value: Q5) -> Q5:
    a, b = value
    denominator = a * a - 5 * b * b
    assert denominator
    return a / denominator, -b / denominator


def qdiv(left: Q5, right: Q5) -> Q5:
    return qmul(left, qinv(right))


def qscale(integer: int, value: Q5) -> Q5:
    return integer * value[0], integer * value[1]


def qpow(value: Q5, exponent: int) -> Q5:
    out = ONE
    while exponent:
        if exponent & 1:
            out = qmul(out, value)
        value = qmul(value, value)
        exponent //= 2
    return out


def qmod(value: Q5, prime: int, sqrt5: int) -> int:
    def reduce_fraction(item: Fraction) -> int:
        return item.numerator * pow(item.denominator, -1, prime) % prime

    return (reduce_fraction(value[0]) + sqrt5 * reduce_fraction(value[1])) % prime


def mmul(left, right):
    out = []
    for i in range(len(left)):
        row = []
        for j in range(len(right[0])):
            value = ZERO
            for k in range(len(right)):
                value = qadd(value, qmul(left[i][k], right[k][j]))
            row.append(value)
        out.append(row)
    return out


def identity(n):
    return [[ONE if i == j else ZERO for j in range(n)] for i in range(n)]


def exact_source_representation():
    alpha = q5(Fraction(-1, 2), Fraction(-1, 2))
    g5 = (1, 2, 3, 4, 0)
    g3 = (0, 1, 3, 4, 2)
    m5 = [
        [alpha, qneg(alpha), q5(-1)],
        [alpha, q5(1), ZERO],
        [alpha, qneg(alpha), ZERO],
    ]
    m3 = [
        [ZERO, q5(-1), qneg(alpha)],
        [ZERO, ZERO, q5(1)],
        [q5(-1), qneg(alpha), ZERO],
    ]
    representation = {base.PID: identity(3)}
    queue = [base.PID]
    while queue:
        current = queue.pop(0)
        for generator, matrix in ((g5, m5), (g3, m3)):
            candidate = base.pc(current, generator)
            candidate_matrix = mmul(representation[current], matrix)
            if candidate in representation:
                assert representation[candidate] == candidate_matrix
            else:
                representation[candidate] = candidate_matrix
                queue.append(candidate)
    assert set(representation) == set(base.PERMS)
    return representation


SOURCE = exact_source_representation()
MONS11 = canonical.monomials(3, 11)
MONS11_INDEX = {exponent: i for i, exponent in enumerate(MONS11)}


def poly_add(left, right):
    out = dict(left)
    for exponent, coefficient in right.items():
        out[exponent] = qadd(out.get(exponent, ZERO), coefficient)
        if out[exponent] == ZERO:
            del out[exponent]
    return out


def poly_scale(scalar: Q5, polynomial):
    return {
        exponent: qmul(scalar, coefficient)
        for exponent, coefficient in polynomial.items()
        if qmul(scalar, coefficient) != ZERO
    }


def poly_mul(left, right):
    out = {}
    for a, ca in left.items():
        for b, cb in right.items():
            exponent = tuple(x + y for x, y in zip(a, b))
            out[exponent] = qadd(out.get(exponent, ZERO), qmul(ca, cb))
    return {exponent: coefficient for exponent, coefficient in out.items() if coefficient != ZERO}


def poly_pow(polynomial, exponent):
    out = {(0, 0, 0): ONE}
    while exponent:
        if exponent & 1:
            out = poly_mul(out, polynomial)
        polynomial = poly_mul(polynomial, polynomial)
        exponent //= 2
    return out


def transformed_monomial(matrix, exponent):
    forms = []
    for row in matrix:
        forms.append({
            tuple(int(i == variable) for i in range(3)): coefficient
            for variable, coefficient in enumerate(row)
            if coefficient != ZERO
        })
    out = {(0, 0, 0): ONE}
    for form, power in zip(forms, exponent):
        out = poly_mul(out, poly_pow(form, power))
    return out


def precompute_monomial_actions():
    return {
        (g, exponent): transformed_monomial(SOURCE[g], exponent)
        for g in base.PERMS
        for exponent in MONS11
    }


def reynolds_seed(output_index, exponent, actions):
    outputs = [{} for _ in range(5)]
    for g in base.PERMS:
        inverse_target = canonical.U[canonical.p_inverse(g)]
        polynomial = actions[g, exponent]
        for output in range(5):
            scalar = inverse_target[output][output_index]
            if scalar:
                outputs[output] = poly_add(
                    outputs[output], poly_scale(q5(scalar), polynomial)
                )
    if not any(outputs):
        return None
    return outputs


def flatten_mod(covariant, prime=89, sqrt5=19):
    return [
        qmod(covariant[output].get(exponent, ZERO), prime, sqrt5)
        for output in range(5)
        for exponent in MONS11
    ]


def echelon_add(basis, vector, prime):
    work = [value % prime for value in vector]
    for pivot, row in basis:
        if work[pivot]:
            scalar = work[pivot]
            work = [(a - scalar * b) % prime for a, b in zip(work, row)]
    pivot = next((i for i, value in enumerate(work) if value), None)
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


def reynolds_basis():
    actions = precompute_monomial_actions()
    modular_basis = []
    covariants = []
    seeds = []
    for output in range(5):
        for exponent in MONS11:
            candidate = reynolds_seed(output, exponent, actions)
            if candidate is None:
                continue
            if echelon_add(modular_basis, flatten_mod(candidate), 89):
                covariants.append(candidate)
                seeds.append((output, exponent))
                print("accepted_reynolds_seed", output, exponent, flush=True)
                if len(covariants) == 5:
                    return covariants, seeds, actions
    raise AssertionError("Reynolds image did not reach dimension five")


def rref_covariants(covariants):
    """Canonical row-reduced basis of the five-dimensional covariant space."""
    rows = [
        [
            covariant[output].get(exponent, ZERO)
            for output in range(5)
            for exponent in MONS11
        ]
        for covariant in covariants
    ]
    pivot_row = 0
    for column in range(len(rows[0])):
        pivot = next(
            (row for row in range(pivot_row, len(rows)) if rows[row][column] != ZERO),
            None,
        )
        if pivot is None:
            continue
        rows[pivot_row], rows[pivot] = rows[pivot], rows[pivot_row]
        inverse = qinv(rows[pivot_row][column])
        rows[pivot_row] = [qmul(inverse, value) for value in rows[pivot_row]]
        for row in range(len(rows)):
            if row == pivot_row or rows[row][column] == ZERO:
                continue
            scalar = rows[row][column]
            rows[row] = [
                qsub(a, qmul(scalar, b))
                for a, b in zip(rows[row], rows[pivot_row])
            ]
        pivot_row += 1
        if pivot_row == len(rows):
            break
    assert pivot_row == 5
    out = []
    for row in rows:
        covariant = []
        for output in range(5):
            block = row[output * len(MONS11):(output + 1) * len(MONS11)]
            covariant.append({
                exponent: coefficient
                for exponent, coefficient in zip(MONS11, block)
                if coefficient != ZERO
            })
        out.append(covariant)
    return out


def substitute_poly(polynomial, matrix, actions=None):
    out = {}
    for exponent, coefficient in polynomial.items():
        image = (
            actions[matrix, exponent]
            if actions is not None and (matrix, exponent) in actions
            else transformed_monomial(SOURCE[matrix] if matrix in SOURCE else matrix, exponent)
        )
        out = poly_add(out, poly_scale(coefficient, image))
    return out


def verify_covariance(covariants, actions):
    for index, covariant in enumerate(covariants):
        for generator in (base.PA, base.PB):
            left = []
            for polynomial in covariant:
                transformed = {}
                for exponent, coefficient in polynomial.items():
                    transformed = poly_add(
                        transformed,
                        poly_scale(coefficient, actions[generator, exponent]),
                    )
                left.append(transformed)
            right = []
            for output in range(5):
                polynomial = {}
                for source_output in range(5):
                    scalar = canonical.U[generator][output][source_output]
                    if scalar:
                        polynomial = poly_add(
                            polynomial,
                            poly_scale(q5(scalar), covariant[source_output]),
                        )
                right.append(polynomial)
            assert left == right
        print("verified_covariant", index, flush=True)


def embed_q5(field, value: Q5):
    s = sp.sqrt(5)
    return field.from_sympy(sp.Rational(value[0].numerator, value[0].denominator)
                            + sp.Rational(value[1].numerator, value[1].denominator) * s)


def field_row_basis(rows, field):
    basis = []
    for original in rows:
        row = list(original)
        for pivot, old in basis:
            if row[pivot]:
                scalar = row[pivot]
                row = [a - scalar * b for a, b in zip(row, old)]
        pivot = next((i for i, value in enumerate(row) if value), None)
        if pivot is None:
            continue
        inverse = field.one / row[pivot]
        row = [inverse * value for value in row]
        for index, (old_pivot, old) in enumerate(basis):
            if old[pivot]:
                scalar = old[pivot]
                basis[index] = (
                    old_pivot,
                    [a - scalar * b for a, b in zip(old, row)],
                )
        basis.append((pivot, row))
        basis.sort()
    return [row for _pivot, row in basis]


def landing_rows(covariants, class_sign):
    """Rows of F_lambda(sum a_i C_i), as cubics in five parameters."""
    s, r = sp.sqrt(5), sp.sqrt(-11)
    field = QQ.algebraic_field(s, r)
    radical = r if class_sign > 0 else -r
    lam = field.from_sympy((13 + radical) / 18)
    cubic = {}
    for exponent in canonical.MONS3:
        value = field.convert(canonical.CUBIC_BASIS[0].get(exponent, 0))
        value += lam * field.convert(canonical.CUBIC_BASIS[1].get(exponent, 0))
        if value:
            cubic[exponent] = value

    outputs = [
        [
            {exponent: embed_q5(field, coefficient) for exponent, coefficient in covariant[output].items()}
            for output in range(5)
        ]
        for covariant in covariants
    ]
    parameter_monomials = canonical.monomials(5, 3)
    parameter_index = {exponent: i for i, exponent in enumerate(parameter_monomials)}
    equations = {}
    for target_exponent, target_coefficient in cubic.items():
        coordinates = []
        for coordinate, multiplicity in enumerate(target_exponent):
            coordinates.extend([coordinate] * multiplicity)
        for selections in product(range(5), repeat=3):
            source_polynomial = {(0, 0, 0): field.one}
            for selection, coordinate in zip(selections, coordinates):
                new = {}
                for ea, ca in source_polynomial.items():
                    for eb, cb in outputs[selection][coordinate].items():
                        exponent = tuple(a + b for a, b in zip(ea, eb))
                        new[exponent] = new.get(exponent, field.zero) + ca * cb
                source_polynomial = {e: c for e, c in new.items() if c}
            parameter_exponent = tuple(selections.count(i) for i in range(5))
            parameter_position = parameter_index[parameter_exponent]
            for source_exponent, coefficient in source_polynomial.items():
                row = equations.setdefault(
                    source_exponent, [field.zero] * len(parameter_monomials)
                )
                row[parameter_position] += target_coefficient * coefficient

    independent = field_row_basis(equations.values(), field)
    assert len(independent) == 6
    return field, parameter_monomials, independent


def groebner_certificate(field, parameter_monomials, rows):
    a = sp.symbols("a0:5")
    equations = []
    for row in rows:
        expression = sp.Integer(0)
        for coefficient, exponent in zip(row, parameter_monomials):
            if coefficient:
                expression += field.to_sympy(coefficient) * sp.prod(
                    variable ** power for variable, power in zip(a, exponent)
                )
        equations.append(sp.expand(expression.subs(a[0], 1)))
    print("starting_exact_groebner", flush=True)
    groebner = sp.groebner(
        equations,
        a[1], a[2], a[3], a[4],
        extension=[sp.sqrt(5), sp.sqrt(-11)],
        order="lex",
    )
    assert not groebner.is_zero_dimensional or len(groebner.polys) > 0
    return a, equations, groebner


def serialize_expr(expression):
    return str(sp.factor(expression)).replace("**", "^")


def run_class(covariants, class_index):
    # class 1 uses (13-sqrt(-11))/18, class 2 the conjugate parameter.
    sign = -1 if class_index == 1 else 1
    field, parameter_monomials, rows = landing_rows(covariants, sign)
    print(f"class_{class_index}_independent_landing_equations={len(rows)}", flush=True)
    variables, equations, groebner = groebner_certificate(field, parameter_monomials, rows)
    print(f"class_{class_index}_groebner_length={len(groebner.polys)}", flush=True)
    for polynomial in groebner.polys:
        print("GB", sp.factor(polynomial.as_expr()), flush=True)
    payload = {
        "class": class_index,
        "pencil_parameter": "(13-sqrt(-11))/18" if class_index == 1 else "(13+sqrt(-11))/18",
        "chart": "a0=1",
        "independent_landing_equation_count": len(rows),
        "groebner_basis": [serialize_expr(polynomial.as_expr()) for polynomial in groebner.polys],
        "field_relations": ["sqrt5^2=5", "sqrt_minus11^2=-11"],
    }
    output = HERE / f"class_{class_index}_exact_groebner.json"
    output.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("wrote", output, flush=True)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--class", dest="class_index", type=int, choices=(1, 2))
    args = parser.parse_args()
    covariants, seeds, actions = reynolds_basis()
    assert len(covariants) == 5
    verify_covariance(covariants, actions)
    seed_path = HERE / "reynolds_seeds.json"
    seed_path.write_text(json.dumps({
        "degree": 11,
        "seeds": [[output, list(exponent)] for output, exponent in seeds],
        "normalization": "first nonzero coefficient equals one",
    }, indent=2, sort_keys=True) + "\n")
    print("wrote", seed_path, flush=True)
    classes = (args.class_index,) if args.class_index else (1, 2)
    for class_index in classes:
        run_class(covariants, class_index)
    print("H3_EXACT_DEGREE11_OK")


if __name__ == "__main__":
    main()
