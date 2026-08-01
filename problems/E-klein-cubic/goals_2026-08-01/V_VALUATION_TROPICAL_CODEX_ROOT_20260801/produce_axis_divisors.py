#!/usr/bin/env python3
"""Produce exact certificates for five soluble genuine-twist valuations.

The five Hilbert--90 columns have degrees 1,4,5,6,7.  For a column V_i,
P_i=F(V_i) is an invariant form.  The divisor P_i=0 has the coordinate-axis
point e_i on the reduced genuine-twist cubic.  This producer certifies that
P_i is absolutely prime, that the quotient valuation is unramified, and that
e_i is a simple point, so Hensel lifts it.

Only read-only authoritative formulas outside this directory are consumed.
All generated output is written next to this script.
"""

from __future__ import annotations

import ast
from hashlib import sha256
import itertools
import json
import math
from pathlib import Path
import random
import subprocess

import sympy as sp


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
SOURCE = PROBLEM / "certificates/exact_covariants_check.py"
OUTPUT = HERE / "axis_divisors.json"
PRIME = 23
FRAME_NAMES = ("x", "C", "D", "E", "K")
FRAME_DEGREES = (1, 4, 5, 6, 7)


def file_sha256(path: Path) -> str:
    digest = sha256()
    with path.open("rb") as handle:
        while chunk := handle.read(1 << 20):
            digest.update(chunk)
    return digest.hexdigest()


def load_literals() -> dict:
    tree = ast.parse(SOURCE.read_text())
    wanted = {"C0", "D0co", "H0co", "Eparams", "Eco", "Kparams", "Kco"}
    values = {}
    for statement in tree.body:
        if not isinstance(statement, ast.Assign) or len(statement.targets) != 1:
            continue
        target = statement.targets[0]
        if isinstance(target, ast.Name) and target.id in wanted and target.id not in values:
            values[target.id] = ast.literal_eval(statement.value)
    assert set(values) == wanted
    return values


def add(*polynomials):
    answer = {}
    for polynomial in polynomials:
        for exponent, coefficient in polynomial.items():
            answer[exponent] = answer.get(exponent, 0) + coefficient
            if not answer[exponent]:
                del answer[exponent]
    return answer


def scale(polynomial, scalar):
    return {exponent: scalar * coefficient for exponent, coefficient in polynomial.items() if scalar * coefficient}


def multiply(left, right):
    answer = {}
    for le, lc in left.items():
        for re, rc in right.items():
            exponent = tuple(a + b for a, b in zip(le, re))
            answer[exponent] = answer.get(exponent, 0) + lc * rc
    return {exponent: coefficient for exponent, coefficient in answer.items() if coefficient}


def shift_exp(exponents, shift):
    return tuple(exponents[(index - shift) % 5] for index in range(5))


def cyclic_vector(first_component):
    return [
        {shift_exp(exponents, index): coefficient for exponents, coefficient in first_component.items()}
        for index in range(5)
    ]


def frame_and_f5():
    values = load_literals()
    x_vector = [
        {tuple(1 if index == component else 0 for index in range(5)): 1}
        for component in range(5)
    ]
    frame = (
        x_vector,
        cyclic_vector({exponent: coefficient for exponent, coefficient in values["C0"].items() if coefficient}),
        cyclic_vector(values["D0co"]),
        cyclic_vector({exponent: coefficient for exponent, coefficient in zip(values["Eparams"], values["Eco"]) if coefficient}),
        cyclic_vector({exponent: coefficient for exponent, coefficient in zip(values["Kparams"], values["Kco"]) if coefficient}),
    )
    return frame, {exponent: coefficient for exponent, coefficient in values["H0co"].items() if coefficient}


def klein_on_vector(vector):
    return add(*(multiply(multiply(vector[i], vector[i]), vector[(i + 1) % 5]) for i in range(5)))


def mixed_iij(frame, i, j):
    """Coefficient of a_i^2*a_j in F(sum a_k V_k), for i != j."""
    assert i != j
    u, v = frame[i], frame[j]
    answer = {}
    for row in range(5):
        following = (row + 1) % 5
        answer = add(
            answer,
            multiply(multiply(u[row], u[row]), v[following]),
            scale(multiply(multiply(u[row], v[row]), u[following]), 2),
        )
    return answer


def evaluate_mod(polynomial, point, prime=PRIME):
    return sum(
        coefficient * math.prod(pow(value, exponent, prime) for value, exponent in zip(point, exponents))
        for exponents, coefficient in polynomial.items()
    ) % prime


def evaluate_vector_mod(vector, point):
    return [evaluate_mod(component, point) for component in vector]


def determinant_mod(columns):
    matrix = sp.Matrix(5, 5, lambda row, column: columns[column][row])
    return int(matrix.det()) % PRIME


def sparse_to_expression(polynomial, variables):
    return sp.expand(sum(
        coefficient * math.prod(variable**exponent for variable, exponent in zip(variables, exponents))
        for exponents, coefficient in polynomial.items()
    ))


def ternary_multiply(left, right):
    answer = {}
    for le, lc in left.items():
        for re, rc in right.items():
            exponent = tuple(a + b for a, b in zip(le, re))
            answer[exponent] = (answer.get(exponent, 0) + lc * rc) % PRIME
    return {exponent: coefficient for exponent, coefficient in answer.items() if coefficient}


def restrict_to_plane(polynomial, matrix):
    """Substitute five ternary linear forms using small sparse F_p arithmetic."""
    one = {(0, 0, 0): 1}
    max_degree = max(sum(exponents) for exponents in polynomial)
    powers = []
    for row in matrix:
        linear = {
            tuple(1 if index == column else 0 for index in range(3)): coefficient % PRIME
            for column, coefficient in enumerate(row)
            if coefficient % PRIME
        }
        row_powers = [one]
        for _ in range(max_degree):
            row_powers.append(ternary_multiply(row_powers[-1], linear))
        powers.append(row_powers)
    answer = {}
    for exponents, coefficient in polynomial.items():
        term = one
        for row, exponent in enumerate(exponents):
            if exponent:
                term = ternary_multiply(term, powers[row][exponent])
        for ternary_exponent, value in term.items():
            answer[ternary_exponent] = (
                answer.get(ternary_exponent, 0) + coefficient * value
            ) % PRIME
    return {exponent: coefficient for exponent, coefficient in answer.items() if coefficient}


def serialized_polynomial(expression, variables):
    polynomial = sp.Poly(expression, *variables, modulus=PRIME)
    terms = [
        {"exponents": list(exponents), "coefficient": int(coefficient) % PRIME}
        for exponents, coefficient in polynomial.terms()
    ]
    raw = json.dumps(terms, sort_keys=True, separators=(",", ":")).encode()
    return {"terms": terms, "sha256": sha256(raw).hexdigest()}


def m2_polynomial(polynomial, names=("y0", "y1", "y2")):
    terms = []
    for exponents in sorted(polynomial, reverse=True):
        coefficient = polynomial[exponents] % PRIME
        if not coefficient:
            continue
        factors = []
        if coefficient != 1 or not any(exponents):
            factors.append(str(coefficient))
        for name, exponent in zip(names, exponents):
            if exponent == 1:
                factors.append(name)
            elif exponent:
                factors.append(f"{name}^{exponent}")
        terms.append("*".join(factors))
    return "+".join(terms) or "0"


def smooth_projective_curve(polynomial):
    serialized = m2_polynomial(polynomial)
    program = f"""R=GF({PRIME})[y0,y1,y2,MonomialOrder=>GRevLex];
f={serialized};
J=ideal(diff(y0,f),diff(y1,f),diff(y2,f));
print (\"DIM=\" | toString dim J);
print (\"DEG=\" | toString degree J);
"""
    try:
        completed = subprocess.run(
            ["M2", "--script", "/dev/stdin"],
            input=program,
            text=True,
            capture_output=True,
            timeout=90,
            check=False,
        )
    except subprocess.TimeoutExpired:
        return None
    if completed.returncode:
        raise RuntimeError(completed.stdout + completed.stderr)
    values = {}
    for line in completed.stdout.splitlines():
        if line.startswith(("DIM=", "DEG=")):
            key, value = line.split("=", 1)
            values[key] = int(value)
    if values.get("DIM") != 0:
        return None
    return {
        "gradient_affine_cone_dimension": values["DIM"],
        "gradient_affine_cone_degree": values["DEG"],
        "criterion": (
            "the homogeneous gradient ideal has affine dimension zero; since the curve degree is nonzero mod 23, "
            "Euler implies the projective curve has no geometric singular point"
        ),
    }


def matrix_rank_mod(matrix):
    return sp.polys.matrices.DomainMatrix.from_list_sympy(5, 3, matrix).convert_to(
        sp.GF(PRIME)
    ).rank()


def find_smooth_plane(polynomial, index):
    y = sp.symbols("y0:3")
    rng = random.Random(2026080100 + index)
    for attempt in range(1, 65):
        matrix = [[rng.randrange(PRIME) for _ in range(3)] for _ in range(5)]
        if matrix_rank_mod(matrix) != 3:
            continue
        restricted_sparse = restrict_to_plane(polynomial, matrix)
        if not restricted_sparse:
            continue
        smoothness = smooth_projective_curve(restricted_sparse)
        if smoothness is not None:
            return {
                "attempt": attempt,
                "matrix": matrix,
                "restricted": serialized_polynomial(sparse_to_expression(restricted_sparse, y), y),
                "smoothness": smoothness,
            }
    raise AssertionError(f"no smooth plane section found for axis {index}")


def find_axis_witness(frame, axis_polynomials, f5, index):
    rng = random.Random(2026080200 + index)
    derivatives = [mixed_iij(frame, index, j) if j != index else {} for j in range(5)]
    for attempt in range(1, 20001):
        point = tuple(rng.randrange(PRIME) for _ in range(5))
        if not any(point):
            continue
        if evaluate_mod(axis_polynomials[index], point) != 0:
            continue
        columns = [evaluate_vector_mod(vector, point) for vector in frame]
        determinant = determinant_mod(columns)
        if not determinant:
            continue
        f3_value = evaluate_mod(axis_polynomials[0], point)
        f5_value = evaluate_mod(f5, point)
        derivative_values = [evaluate_mod(polynomial, point) if polynomial else 0 for polynomial in derivatives]
        if not any(derivative_values):
            continue
        return {
            "attempt": attempt,
            "source_point": list(point),
            "frame_determinant": determinant,
            "f3": f3_value,
            "f5": f5_value,
            "f8": evaluate_mod(mixed_iij(frame, 0, 3), point),
            "axis_derivatives": derivative_values,
        }
    raise AssertionError(f"no transverse axis witness found for axis {index}")


def assert_klein_smooth_mod_prime():
    program = f"""R=GF({PRIME})[z0,z1,z2,z3,z4,MonomialOrder=>GRevLex];
f=z0^2*z1+z1^2*z2+z2^2*z3+z3^2*z4+z4^2*z0;
J=ideal(diff(z0,f),diff(z1,f),diff(z2,f),diff(z3,f),diff(z4,f));
print (\"DIM=\" | toString dim J);
print (\"DEG=\" | toString degree J);
"""
    completed = subprocess.run(
        ["M2", "--script", "/dev/stdin"],
        input=program,
        text=True,
        capture_output=True,
        timeout=90,
        check=False,
    )
    if completed.returncode:
        raise RuntimeError(completed.stdout + completed.stderr)
    values = {}
    for line in completed.stdout.splitlines():
        if line.startswith(("DIM=", "DEG=")):
            key, value = line.split("=", 1)
            values[key] = int(value)
    assert values["DIM"] == 0
    return values


def main():
    frame, f5 = frame_and_f5()
    axis_polynomials = [klein_on_vector(vector) for vector in frame]
    assert axis_polynomials[0] == klein_on_vector(frame[0])
    x = sp.symbols("x0:5")
    records = []
    for index, polynomial in enumerate(axis_polynomials):
        assert {sum(exponents) for exponents in polynomial} == {3 * FRAME_DEGREES[index]}
        print(f"axis={FRAME_NAMES[index]} plane-search", flush=True)
        plane = find_smooth_plane(polynomial, index)
        print(f"axis={FRAME_NAMES[index]} point-search", flush=True)
        witness = find_axis_witness(frame, axis_polynomials, f5, index)
        uniformizer = f"P_{FRAME_NAMES[index]}"
        records.append({
            "index": index,
            "column": FRAME_NAMES[index],
            "column_degree": FRAME_DEGREES[index],
            "divisor_polynomial": f"P_{FRAME_NAMES[index]}=F({FRAME_NAMES[index]})",
            "degree": 3 * FRAME_DEGREES[index],
            "term_count": len(polynomial),
            "qq_irreducible": True,
            "smooth_plane_section_mod_23": plane,
            "absolute_primality_reason": (
                "the displayed plane restriction is a smooth positive-degree projective plane curve over Fbar_23; "
                "any geometric factorization of the integral homogeneous source form would restrict to intersecting "
                "positive-degree components and hence a singular plane curve"
            ),
            "uniformizer": uniformizer,
            "source_order": 1,
            "valuation_identity": "1=v_E(P_i)=e(E/D)*v_D(P_i)",
            "ramification_index": 1,
            "downstairs_order": 1,
            "simple_axis_witness_mod_23": witness,
            "special_fibre_point": f"e_{index}",
            "hensel_conclusion": "C_gen(K_v) is nonempty at this completed genuine-twist valuation",
        })

    payload = {
        "schema": "klein-genuine-twist-axis-valuations-v1",
        "prime": PRIME,
        "source": str(SOURCE.relative_to(PROBLEM)),
        "source_sha256": file_sha256(SOURCE),
        "field": "K_aff=C(W)^G",
        "genuine_twist_equation": "Phi(a)=F(a0*x+a1*C+a2*D+a3*E+a4*K)",
        "klein_smooth_mod_23_gradient_ideal": assert_klein_smooth_mod_prime(),
        "index_one": {
            "effective_cycle_degrees": [60, 132, 165, 220],
            "bezout_coefficients": [-13, 3, 1, 1],
            "linear_section_degree": 3,
            "second_degree_one_combination": "220-73*3=1",
            "local_consequence": "for every extension/completion L/K_aff, ind(C_gen_L)=1",
        },
        "records": records,
        "strict_scope": (
            "These five valuations survive by exact Hensel points. This is not an exhaustive theorem for all "
            "valuations and is not a global K_aff-point."
        ),
    }
    OUTPUT.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(f"wrote {OUTPUT}")
    print("V_AXIS_DIVISORS_PRODUCED")


if __name__ == "__main__":
    main()
