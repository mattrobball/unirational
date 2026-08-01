#!/usr/bin/env python3
"""Independent replay for the exact H2 A4 point certificate.

The verifier deliberately does not import exact_degree3_map.py, canonical_model.py,
produce.py, or a4_direct_search.py.  It reconstructs the two generator tests,
the Klein landing ideal, the decomposition, and the installed-source change
from the sealed JSON payloads and the repository's exact Weil matrices.
"""

from __future__ import annotations

from collections import deque
from fractions import Fraction
import hashlib
import json
from pathlib import Path
import subprocess
import sys

import sympy as sp
from sympy.polys.domains import QQ


HERE = Path(__file__).resolve().parent
REPO = next(
    parent for parent in HERE.parents
    if (parent / "certificates" / "exact_weil_check.py").is_file()
    and (parent / "goals_2026-08-01" / "H_SUBGROUP_TWISTS_ROOT_019FBE10" / "twists.json").is_file()
)
sys.path.insert(0, str(REPO / "certificates"))
import exact_weil_check as ew  # noqa: E402

X = sp.symbols("X")
PHI33 = sp.cyclotomic_poly(33, X)
K = QQ.alg_field_from_poly(sp.Poly(PHI33, X))
T, ZERO, ONE = K.unit, K.zero, K.one
ZETA11, OMEGA = T**3, T**11


def q(value):
    return K.convert(sp.Rational(value.numerator, value.denominator))


def embed(value):
    return sum((q(Fraction(coefficient)) * ZETA11**i for i, coefficient in enumerate(value.a)), ZERO)


def deserialize(value):
    return sum((q(Fraction(numerator, denominator)) * T**i
                for i, (numerator, denominator) in enumerate(value)), ZERO)


def monomials(degree):
    return tuple((a, b, degree - a - b) for a in range(degree + 1) for b in range(degree - a + 1))


def padd(left, right):
    result = dict(left)
    for exponent, coefficient in right.items():
        result[exponent] = result.get(exponent, ZERO) + coefficient
        if result[exponent] == ZERO:
            del result[exponent]
    return result


def pscale(scalar, polynomial):
    return {exponent: scalar * coefficient for exponent, coefficient in polynomial.items() if scalar * coefficient != ZERO}


def pmul(left, right):
    result = {}
    for a, ca in left.items():
        for b, cb in right.items():
            exponent = tuple(x + y for x, y in zip(a, b))
            result[exponent] = result.get(exponent, ZERO) + ca * cb
    return {exponent: coefficient for exponent, coefficient in result.items() if coefficient != ZERO}


def ppow(polynomial, power, variable_count):
    result = {(0,) * variable_count: ONE}
    for _ in range(power):
        result = pmul(result, polynomial)
    return result


def substitute(polynomial, matrix):
    variable_count = len(matrix)
    forms = [
        {tuple(int(i == j) for i in range(variable_count)): value
         for j, value in enumerate(row) if value != ZERO}
        for row in matrix
    ]
    result = {}
    for exponent, coefficient in polynomial.items():
        term = {(0,) * variable_count: coefficient}
        for form, power in zip(forms, exponent):
            term = pmul(term, ppow(form, power, variable_count))
        result = padd(result, term)
    return result


def outputs(mons, vector):
    count = len(mons)
    return [
        {exponent: vector[row * count + column]
         for column, exponent in enumerate(mons) if vector[row * count + column] != ZERO}
        for row in range(5)
    ]


def rational_string(value):
    numerator, denominator = int(value.numerator), int(value.denominator)
    return str(numerator) if denominator == 1 else f"({numerator}/{denominator})"


def field_string(value):
    terms = []
    for (exponent,), coefficient in sorted(value.to_dict().items()):
        monomial = "1" if exponent == 0 else ("t" if exponent == 1 else f"t^{exponent}")
        terms.append(f"({rational_string(coefficient)})*{monomial}")
    return "+".join(terms) if terms else "0"


def chart_string(polynomial):
    terms = []
    for exponent, coefficient in sorted(polynomial.items()):
        factors = []
        for index, power in enumerate(exponent):
            if index == 0 or power == 0:
                continue
            factors.append(f"p{index}" if power == 1 else f"p{index}^{power}")
        terms.append(f"({field_string(coefficient)})*{'*'.join(factors) if factors else '1'}")
    return "+".join(terms) if terms else "0"


def landing_equations(mons, basis):
    maps = [outputs(mons, vector) for vector in basis]
    equations = {}
    for coordinate in range(5):
        successor = (coordinate + 1) % 5
        for i in range(4):
            for j in range(4):
                square = pmul(maps[i][coordinate], maps[j][coordinate])
                for k in range(4):
                    term = pmul(square, maps[k][successor])
                    parameter = tuple(int(i == r) + int(j == r) + int(k == r) for r in range(4))
                    for source_exponent, coefficient in term.items():
                        polynomial = equations.setdefault(source_exponent, {})
                        polynomial[parameter] = polynomial.get(parameter, ZERO) + coefficient
    return {
        source: {parameter: coefficient for parameter, coefficient in polynomial.items() if coefficient != ZERO}
        for source, polynomial in equations.items()
        if any(coefficient != ZERO for coefficient in polynomial.values())
    }


def matmul(left, right):
    return [[sum((left[i][k] * right[k][j] for k in range(len(right))), ZERO)
             for j in range(len(right[0]))] for i in range(len(left))]


def determinant(matrix):
    work = [list(row) for row in matrix]
    result = ONE
    for column in range(len(work)):
        pivot = next((row for row in range(column, len(work)) if work[row][column] != ZERO), None)
        if pivot is None:
            return ZERO
        if pivot != column:
            work[pivot], work[column] = work[column], work[pivot]
            result = -result
        unit = work[column][column]
        result *= unit
        for row in range(column + 1, len(work)):
            scale = work[row][column] / unit
            work[row] = [a - scale * b for a, b in zip(work[row], work[column])]
    return result


def klein_after_change(matrix):
    linear = [
        {tuple(int(i == j) for i in range(5)): value for j, value in enumerate(row) if value != ZERO}
        for row in matrix
    ]
    result = {}
    for i in range(5):
        result = padd(result, pmul(pmul(linear[i], linear[i]), linear[(i + 1) % 5]))
    return result


def pc(a, b):
    return tuple(a[b[i]] for i in range(5))


def exact_icosahedral_source():
    root5 = sp.sqrt(5)
    alpha = -(1 + root5) / 2
    g5, g3 = (1, 2, 3, 4, 0), (0, 1, 3, 4, 2)
    m5 = sp.Matrix([[alpha, -alpha, -1], [alpha, 1, 0], [alpha, -alpha, 0]])
    m3 = sp.Matrix([[0, -1, -alpha], [0, 0, 1], [-1, -alpha, 0]])
    identity = tuple(range(5))
    reps, queue = {identity: sp.eye(3)}, deque([identity])
    while queue:
        current = queue.popleft()
        for generator, matrix in ((g5, m5), (g3, m3)):
            successor, candidate = pc(current, generator), reps[current] * matrix
            if successor not in reps:
                reps[successor] = candidate.applyfunc(sp.simplify)
                queue.append(successor)
            else:
                assert all(sp.simplify(value) == 0 for value in reps[successor] - candidate)
    assert len(reps) == 60
    return reps


def verify_canonical_payload(canonical, installed_record):
    reps = exact_icosahedral_source()
    source_map = {tuple(row["h"]): tuple(row["permutation"]) for row in installed_record["source_map"]}
    installed = [reps[source_map[tuple(generator)]] for generator in installed_record["generators"]]
    standard = [sp.diag(-1, -1, 1), sp.Matrix([[0, 1, 0], [0, 0, 1], [1, 0, 0]])]
    P = sp.Matrix([[sp.sympify(value.replace("^", "**")) for value in row]
                   for row in canonical["source_intertwiner_P"]])
    assert sp.simplify(P.det()) != 0
    for source, target in zip(standard, installed):
        assert all(sp.simplify(value) == 0 for value in target * P - P * source)

    x, y, z, omega = sp.symbols("x y z omega")
    S = x*x + y*y + z*z
    L = x*x + omega*y*y + omega**2*z*z
    M = x*x + omega**2*y*y + omega*z*z
    qxyz = x*y*z
    delta = (x*x-y*y)*(x*x-z*z)*(y*y-z*z)
    Q = sp.Matrix([
        [S*x/qxyz, y*z/S, x**3/qxyz],
        [S*y/qxyz, z*x/S, y**3/qxyz],
        [S*z/qxyz, x*y/S, z**3/qxyz],
    ])
    assert sp.cancel(Q.det() - delta/qxyz**2) == 0

    def reduce_omega(value):
        numerator, denominator = sp.fraction(sp.cancel(value))
        numerator = sp.rem(sp.Poly(numerator, omega), sp.Poly(omega**2+omega+1, omega)).as_expr()
        denominator = sp.rem(sp.Poly(denominator, omega), sp.Poly(omega**2+omega+1, omega)).as_expr()
        return sp.cancel(numerator/denominator)

    vector = sp.Matrix([x, y, z])
    for index, matrix in enumerate(standard):
        changed = matrix * vector
        substitution = {x: changed[0], y: changed[1], z: changed[2]}
        q_changed = Q.applyfunc(lambda value: value.subs(substitution, simultaneous=True))
        assert all(reduce_omega(value) == 0 for value in q_changed - matrix*Q)
        assert reduce_omega((L/S).subs(substitution, simultaneous=True) - (1, omega**2)[index]*(L/S)) == 0
        assert reduce_omega((M/S).subs(substitution, simultaneous=True) - (1, omega)[index]*(M/S)) == 0
        assert sp.cancel(qxyz.subs(substitution, simultaneous=True) - qxyz) == 0
        assert reduce_omega(((L/S)**3).subs(substitution, simultaneous=True) - (L/S)**3) == 0
        assert reduce_omega(((L*M/S**2).subs(substitution, simultaneous=True) - L*M/S**2)) == 0


def main():
    payload = json.loads((HERE / "exact_degree3_map.json").read_text())
    canonical = json.loads((HERE / "canonical_model.json").read_text())
    uv_model = json.loads((HERE / "twist_over_Cuv.json").read_text())
    installed = json.loads((REPO / "goals_2026-08-01" / "H_SUBGROUP_TWISTS_ROOT_019FBE10" / "twists.json").read_text())
    installed_record = next(row for row in installed["records"] if row["label"] == "A4")
    assert payload["format"] == "H2-A4-EXACT-DEGREE3-MAP-v1"
    assert canonical["format"] == "H2-A4-CANONICAL-MODEL-v1"
    assert uv_model["format"] == "H2-A4-TWIST-OVER-CUV-v1"
    assert uv_model["base_field"] == "C(u,v)"
    assert len(uv_model["coefficients"]) == 35
    assert sum(value != "0" for value in uv_model["coefficients"].values()) == 22
    assert uv_model["coefficients"]["3,0,0,0,0"] == "a*u"
    assert uv_model["coefficients"]["0,3,0,0,0"] == "b*v^3/u"
    assert uv_model["coefficients"]["0,0,0,0,3"] == "e"
    assert uv_model["equivalence_open_over_Cuv"] == "u*v*(u^2-v^3)*(u^2-3*u*v+u+v^3) != 0"
    assert payload["phi_33_coefficients_high_to_low"] == [int(c) for c in sp.Poly(PHI33, X).all_coeffs()]
    generators = [tuple(g) for g in payload["subgroup_generators_psl2_f11"]]
    assert generators == [tuple(g) for g in installed_record["generators"]]
    rho = [[[embed(value) for value in row] for row in ew.rho[g]] for g in generators]
    source = [[[K.convert(value) for value in row] for row in matrix] for matrix in payload["source_generators"]]
    mons = tuple(tuple(exponent) for exponent in payload["source_monomials"])
    basis = [[deserialize(value) for value in vector]
             for vector in payload["covariant_basis_power_basis_coefficients"]]
    assert mons == monomials(3) and len(basis) == 4

    # Direct polynomial substitution, independent of the producer's matrix convention.
    for vector in basis:
        polynomial_map = outputs(mons, vector)
        for generator_index, (sigma, target) in enumerate(zip(source, rho)):
            scalar = (ONE, OMEGA**2)[generator_index]
            for row in range(5):
                left = substitute(polynomial_map[row], sigma)
                right = {}
                for column in range(5):
                    right = padd(right, pscale(scalar * target[row][column], polynomial_map[column]))
                assert left == right

    equations = landing_equations(mons, basis)
    assert len(equations) == payload["landing_equation_count"] == 10
    expressions = [chart_string(polynomial) for _, polynomial in sorted(equations.items())]
    phi33_string = str(PHI33).replace("**", "^").replace("X", "t")
    expected_input = (
        "ring r=(0,t),(p1,p2,p3),lp;\n"
        f"minpoly={phi33_string};\n"
        f"ideal I={','.join(expressions)};\n"
        "ideal J=std(I);\n"
        'if (reduce(1,J)==0) { print("UNIT"); } else { print("PROPER"); J; }\n'
        "quit;\n"
    )
    input_path = HERE / payload["singular_input"]
    transcript_path = HERE / payload["singular_transcript"]
    assert input_path.read_text() == expected_input
    assert hashlib.sha256(input_path.read_bytes()).hexdigest() == payload["singular_input_sha256"]
    result = subprocess.run(["/opt/homebrew/bin/Singular", "-q", str(input_path)], check=True,
                            capture_output=True, text=True)
    assert result.stdout.startswith("PROPER\n")
    assert result.stdout == transcript_path.read_text()
    assert hashlib.sha256(transcript_path.read_bytes()).hexdigest() == payload["singular_transcript_sha256"]

    D_columns = [[deserialize(value) for value in column]
                 for column in payload["decomposition_basis_columns_power_basis_coefficients"]]
    D = [[D_columns[column][row] for column in range(5)] for row in range(5)]
    assert determinant(D) != ZERO
    blocks = [
        [[ONE, ZERO, ZERO, ZERO, ZERO], [ZERO, ONE, ZERO, ZERO, ZERO],
         [ZERO, ZERO, *source[0][0]], [ZERO, ZERO, *source[0][1]], [ZERO, ZERO, *source[0][2]]],
        [[OMEGA**2, ZERO, ZERO, ZERO, ZERO], [ZERO, OMEGA, ZERO, ZERO, ZERO],
         [ZERO, ZERO, *source[1][0]], [ZERO, ZERO, *source[1][1]], [ZERO, ZERO, *source[1][2]]],
    ]
    for target, block in zip(rho, blocks):
        assert matmul(target, D) == matmul(D, block)
    decomposed = klein_after_change(D)
    recorded = {tuple(map(int, exponent.split(","))): deserialize(value)
                for exponent, value in payload["decomposed_cubic_coefficients"].items()}
    assert decomposed == recorded
    constants = {name: deserialize(value)
                 for name, value in payload["norm_form_constants_power_basis_coefficients"].items()}
    assert all(value != ZERO for value in constants.values())
    assert recorded[(3,0,0,0,0)] == constants["a"]
    assert recorded[(0,3,0,0,0)] == constants["b"]
    assert recorded[(1,0,2,0,0)] == constants["c"]
    assert recorded[(1,0,0,2,0)] == constants["c"]*OMEGA**2
    assert recorded[(1,0,0,0,2)] == constants["c"]*OMEGA
    assert recorded[(0,1,2,0,0)] == constants["d"]
    assert recorded[(0,1,0,2,0)] == constants["d"]*OMEGA
    assert recorded[(0,1,0,0,2)] == constants["d"]*OMEGA**2
    assert recorded[(0,0,1,1,1)] == constants["e"]

    verify_canonical_payload(canonical, installed_record)
    messages = [
        "PASS direct degree-3 projective covariance for 4 basis maps",
        "PASS exact Klein landing ideal is proper on p0=1",
        "PASS 1'+1''+3 norm-form decomposition and canonical invariant frame",
        "H2_A4_RATIONAL_POINT_VERIFIED",
    ]
    (HERE / "verification.log").write_text("\n".join(messages) + "\n")
    print("\n".join(messages))


if __name__ == "__main__":
    main()
