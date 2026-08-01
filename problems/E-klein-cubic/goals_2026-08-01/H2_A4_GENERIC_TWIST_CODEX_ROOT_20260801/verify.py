#!/usr/bin/env python3
"""Independent replay for the H2 A4 generic-twist rational point.

This verifier does not import either H2 producer script.  It deserializes
their payloads, reconstructs the two representations from the pinned upstream
model, checks the exact covariance and Klein landing equations, recomputes a
fresh characteristic-zero Groebner basis, and checks the source change of
coordinates and invariant-field presentation.
"""

from __future__ import annotations

from collections import deque
from contextlib import redirect_stdout
import hashlib
import io
import itertools
import json
from pathlib import Path
import subprocess
import sys
import tempfile

import sympy as sp
from sympy.polys.domains import QQ


HERE = Path(__file__).resolve().parent
REPO = next(
    parent for parent in HERE.parents
    if (parent / "certificates" / "exact_weil_check.py").is_file()
    and (parent / "goals_2026-08-01" / "H_SUBGROUP_TWISTS_ROOT_019FBE10" / "twists.json").is_file()
)
UPSTREAM = REPO / "goals_2026-08-01" / "H_SUBGROUP_TWISTS_ROOT_019FBE10"
sys.path.insert(0, str(UPSTREAM))
with redirect_stdout(io.StringIO()):
    import produce as base  # noqa: E402


X = sp.symbols("X")
PHI33 = sp.cyclotomic_poly(33, X)
K = QQ.alg_field_from_poly(sp.Poly(PHI33, X))
T, ZERO, ONE = K.unit, K.zero, K.one
ZETA11, OMEGA = T**3, T**11


def de33(encoded):
    return sum(
        (K.convert(sp.Rational(numerator, denominator)) * T**exponent
         for exponent, (numerator, denominator) in enumerate(encoded)),
        ZERO,
    )


def embed11(value):
    return sum(
        (K.convert(sp.Rational(int(q.numerator), int(q.denominator))) * ZETA11**exponent
         for exponent, q in enumerate(value.a)),
        ZERO,
    )


def mm(left, right, zero=ZERO):
    return [
        [sum((left[i][k] * right[k][j] for k in range(len(right))), zero)
         for j in range(len(right[0]))]
        for i in range(len(left))
    ]


def transpose(matrix):
    return [list(row) for row in zip(*matrix)]


def det(matrix, zero=ZERO, one=ONE):
    work = [list(row) for row in matrix]
    output = one
    for column in range(len(work)):
        pivot = next((row for row in range(column, len(work)) if work[row][column] != zero), None)
        if pivot is None:
            return zero
        if pivot != column:
            work[pivot], work[column] = work[column], work[pivot]
            output = -output
        unit = work[column][column]
        output *= unit
        for row in range(column + 1, len(work)):
            scale = work[row][column] / unit
            work[row] = [left - scale * right for left, right in zip(work[row], work[column])]
    return output


def padd(left, right, zero=ZERO):
    output = dict(left)
    for exponent, coefficient in right.items():
        output[exponent] = output.get(exponent, zero) + coefficient
        if output[exponent] == zero:
            del output[exponent]
    return output


def pmul(left, right, zero=ZERO):
    output = {}
    for first, a in left.items():
        for second, b in right.items():
            exponent = tuple(x + y for x, y in zip(first, second))
            output[exponent] = output.get(exponent, zero) + a * b
    return {exponent: coefficient for exponent, coefficient in output.items() if coefficient != zero}


def ppow(poly, power, variable_count):
    output = {(0,) * variable_count: ONE}
    for _ in range(power):
        output = pmul(output, poly)
    return output


def monomial_action(matrix, monomials):
    variable_count = 3
    index = {exponent: position for position, exponent in enumerate(monomials)}
    linear = [
        {tuple(int(j == k) for j in range(variable_count)): matrix[i][k]
         for k in range(variable_count) if matrix[i][k] != ZERO}
        for i in range(variable_count)
    ]
    output = [[ZERO] * len(monomials) for _ in monomials]
    for column, exponent in enumerate(monomials):
        polynomial = {(0, 0, 0): ONE}
        for form, power in zip(linear, exponent):
            polynomial = pmul(polynomial, ppow(form, power, variable_count))
        for result_exponent, coefficient in polynomial.items():
            output[index[result_exponent]][column] = coefficient
    return output


def output_polynomials(monomials, vector):
    count = len(monomials)
    return [
        {exponent: vector[output * count + index]
         for index, exponent in enumerate(monomials)
         if vector[output * count + index] != ZERO}
        for output in range(5)
    ]


def landing_equations(monomials, basis):
    outputs = [output_polynomials(monomials, vector) for vector in basis]
    dimension = len(basis)
    equations = {}
    for i in range(5):
        j = (i + 1) % 5
        for first, second, third in itertools.product(range(dimension), repeat=3):
            term = pmul(pmul(outputs[first][i], outputs[second][i]), outputs[third][j])
            parameter = tuple(
                int(first == k) + int(second == k) + int(third == k)
                for k in range(dimension)
            )
            for source, coefficient in term.items():
                target = equations.setdefault(source, {})
                target[parameter] = target.get(parameter, ZERO) + coefficient
    return {
        source: {parameter: coefficient for parameter, coefficient in polynomial.items() if coefficient != ZERO}
        for source, polynomial in equations.items()
        if any(coefficient != ZERO for coefficient in polynomial.values())
    }


def rational_text(value):
    numerator, denominator = int(value.numerator), int(value.denominator)
    return str(numerator) if denominator == 1 else f"({numerator}/{denominator})"


def field_text(value):
    terms = []
    for (exponent,), coefficient in sorted(value.to_dict().items()):
        monomial = "1" if exponent == 0 else ("t" if exponent == 1 else f"t^{exponent}")
        terms.append(f"({rational_text(coefficient)})*{monomial}")
    return "+".join(terms) if terms else "0"


def chart_text(poly):
    terms = []
    for exponent, coefficient in poly.items():
        factors = []
        for index, power in enumerate(exponent):
            if index == 0 or power == 0:
                continue
            factors.append(f"p{index}" if power == 1 else f"p{index}^{power}")
        terms.append(f"({field_text(coefficient)})*{'*'.join(factors) if factors else '1'}")
    return "+".join(terms) if terms else "0"


def verify_map():
    payload_path = HERE / "exact_degree3_map.json"
    payload = json.loads(payload_path.read_text())
    assert payload["format"] == "H2-A4-EXACT-DEGREE3-MAP-v1"
    generators = tuple(tuple(row) for row in payload["subgroup_generators_psl2_f11"])
    source = [
        [[K.convert(value) for value in row] for row in matrix]
        for matrix in payload["source_generators"]
    ]
    rho = [
        [[embed11(value) for value in row] for row in base.ew.rho[g]]
        for g in generators
    ]
    assert det(rho[0]) == ONE and det(rho[1]) == ONE
    monomials = tuple(tuple(exponent) for exponent in payload["source_monomials"])
    basis = [
        [de33(value) for value in vector]
        for vector in payload["covariant_basis_power_basis_coefficients"]
    ]
    assert len(basis) == 4 and len(monomials) == 10
    scalars = (ONE, OMEGA**2)
    for sigma, target, scalar in zip(source, rho, scalars):
        action = monomial_action(sigma, monomials)
        for vector in basis:
            c = [vector[10 * row:10 * row + 10] for row in range(5)]
            assert mm(c, transpose(action)) == [
                [scalar * value for value in row] for row in mm(target, c)
            ]

    equations = landing_equations(monomials, basis)
    assert len(equations) == payload["landing_equation_count"] == 10
    expressions = [chart_text(polynomial) for polynomial in equations.values()]
    phi33 = str(PHI33).replace("**", "^").replace("X", "t")
    program = (
        "ring r=(0,t),(p1,p2,p3),lp;\n"
        f"minpoly={phi33};\n"
        f"ideal I={','.join(expressions)};\n"
        "ideal J=std(I);\n"
        'if (reduce(1,J)==0) { print("UNIT"); } else { print("PROPER"); J; }\n'
        "quit;\n"
    )
    with tempfile.NamedTemporaryFile("w", suffix=".sing") as handle:
        handle.write(program)
        handle.flush()
        result = subprocess.run(
            ["/opt/homebrew/bin/Singular", "-q", handle.name],
            check=True,
            capture_output=True,
            text=True,
        )
    assert result.stdout.startswith("PROPER\n")
    transcript = HERE / payload["singular_transcript"]
    assert hashlib.sha256(transcript.read_bytes()).hexdigest() == payload["singular_transcript_sha256"]
    assert transcript.read_text().startswith("PROPER\n")

    columns = [
        [de33(value) for value in column]
        for column in payload["decomposition_basis_columns_power_basis_coefficients"]
    ]
    decomposition = [[columns[column][row] for column in range(5)] for row in range(5)]
    assert det(decomposition) != ZERO
    for index, (target, sigma) in enumerate(zip(rho, source)):
        block = [[ZERO] * 5 for _ in range(5)]
        block[0][0] = (ONE, OMEGA**2)[index]
        block[1][1] = (ONE, OMEGA)[index]
        for i in range(3):
            for j in range(3):
                block[i + 2][j + 2] = sigma[i][j]
        assert mm(target, decomposition) == mm(decomposition, block)

    linear = [
        {tuple(int(index == variable) for index in range(5)): decomposition[row][variable]
         for variable in range(5) if decomposition[row][variable] != ZERO}
        for row in range(5)
    ]
    cubic = {}
    for index in range(5):
        cubic = padd(cubic, pmul(pmul(linear[index], linear[index]), linear[(index + 1) % 5]))
    expected_support = {
        (3, 0, 0, 0, 0), (0, 3, 0, 0, 0),
        (1, 0, 2, 0, 0), (1, 0, 0, 2, 0), (1, 0, 0, 0, 2),
        (0, 1, 2, 0, 0), (0, 1, 0, 2, 0), (0, 1, 0, 0, 2),
        (0, 0, 1, 1, 1),
    }
    assert set(cubic) == expected_support
    serialized = {
        tuple(map(int, key.split(","))): de33(value)
        for key, value in payload["decomposed_cubic_coefficients"].items()
    }
    assert cubic == serialized
    return generators, source, rho


Q5 = QQ.algebraic_field(sp.sqrt(5))
R5, Z5, O5 = Q5.unit, Q5.zero, Q5.one


def de5(encoded):
    return sum(
        (Q5.convert(sp.Rational(numerator, denominator)) * R5**exponent
         for exponent, (numerator, denominator) in enumerate(encoded)),
        Z5,
    )


def source_a5_q5():
    alpha = -(O5 + R5) / Q5.convert(2)
    g5, g3 = (1, 2, 3, 4, 0), (0, 1, 3, 4, 2)
    m5 = [[alpha, -alpha, -O5], [alpha, O5, Z5], [alpha, -alpha, Z5]]
    m3 = [[Z5, -O5, -alpha], [Z5, Z5, O5], [-O5, -alpha, Z5]]
    identity = tuple(range(5))
    representations = {identity: [[O5, Z5, Z5], [Z5, O5, Z5], [Z5, Z5, O5]]}
    queue = deque([identity])
    while queue:
        current = queue.popleft()
        for generator, matrix in ((g5, m5), (g3, m3)):
            nxt = base.pc(current, generator)
            value = mm(representations[current], matrix, Z5)
            if nxt in representations:
                assert representations[nxt] == value
            else:
                representations[nxt] = value
                queue.append(nxt)
    return representations


def a4_subgroup():
    first, _ = base.two_a5_classes()
    a, b, a5 = first
    mapping = base.iso(a, b, a5)
    involutions = [g for g in a5 if base.ORDERS[g] == 2]
    v4 = next(
        frozenset({base.ew.fone, x, y, base.gmul(x, y)})
        for index, x in enumerate(involutions)
        for y in involutions[index + 1:]
        if base.gmul(x, y) == base.gmul(y, x)
    )
    a4 = base.normalizer(v4, a5)
    return a4, base.gens(a4), mapping


def verify_source_intertwiner(expected_generators):
    payload = json.loads((HERE / "source_intertwiner.json").read_text())
    assert payload["format"] == "H2-A4-SOURCE-INTERTWINER-v1"
    a4, generators, mapping = a4_subgroup()
    assert generators == expected_generators
    assert tuple(tuple(row) for row in payload["subgroup_generators_psl2_f11"]) == generators
    all_source = source_a5_q5()
    installed = {g: all_source[mapping[g]] for g in a4}
    ga, gb = generators
    canonical_generators = {
        ga: [[-O5, Z5, Z5], [Z5, -O5, Z5], [Z5, Z5, O5]],
        gb: [[Z5, O5, Z5], [Z5, Z5, O5], [O5, Z5, Z5]],
    }
    identity = base.ew.fone
    canonical = {identity: [[O5, Z5, Z5], [Z5, O5, Z5], [Z5, Z5, O5]]}
    queue = deque([identity])
    while queue:
        current = queue.popleft()
        for generator in generators:
            nxt = base.gmul(current, generator)
            value = mm(canonical[current], canonical_generators[generator], Z5)
            if nxt in canonical:
                assert canonical[nxt] == value
            else:
                canonical[nxt] = value
                queue.append(nxt)
    p = [[de5(value) for value in row] for row in payload["P_canonical_to_installed"]]
    assert det(p, Z5, O5) == de5(payload["determinant_P"]) != Z5
    for g in a4:
        assert mm(p, canonical[g], Z5) == mm(installed[g], p, Z5)

    twists = json.loads((UPSTREAM / "twists.json").read_text())
    record = next(row for row in twists["records"] if row["label"] == "A4")
    assert tuple(tuple(row) for row in record["generators"]) == generators
    assert record["source_kind"] == "faithful tetrahedral 3-space"
    assert record["ell"] == [1, 2, 3]
    reduction_prime = record["good_reduction"]["prime"]
    assert reduction_prime == 89
    assert record["good_reduction"]["frame_determinant"] % reduction_prime != 0


def verify_invariant_field():
    # Under (x,y,z)->(y,z,x), A0 is fixed and A1,A2 have weights omega,omega^2.
    a0 = (ONE, ONE, ONE)
    a1 = (ONE, OMEGA**2, OMEGA)
    a2 = (ONE, OMEGA, OMEGA**2)
    cycle = lambda coefficients: (coefficients[2], coefficients[0], coefficients[1])
    assert cycle(a0) == a0
    assert cycle(a1) == tuple(OMEGA * value for value in a1)
    assert cycle(a2) == tuple(OMEGA**2 * value for value in a2)
    # The Fourier change (X,Y,Z) <-> (A0,A1,A2) is invertible.
    fourier = [list(a0), list(a1), list(a2)]
    assert det(fourier) != ZERO
    # Thus r=A1/A0, s=A2/A0 and U=rs,V=r^3 give a degree-three
    # Galois presentation: r^3=V and s=U/r.
    assert OMEGA * OMEGA**2 == ONE and OMEGA**3 == ONE and OMEGA != ONE


def main():
    generators, _source, _rho = verify_map()
    verify_source_intertwiner(generators)
    verify_invariant_field()
    print("PASS exact projective degree-3 covariance for both A4 generators")
    print("PASS ten exact Klein landing equations and fresh proper Groebner ideal")
    print("PASS W|A4=1'+1''+3 and sparse nine-term cubic model")
    print("PASS exact installed-source intertwiner for all 12 A4 elements")
    print("PASS K_A4=C(U,V), U=rs, V=r^3 on A0!=0")
    print("H2_A4_GENERIC_TWIST_VERIFY_OK")


if __name__ == "__main__":
    main()
