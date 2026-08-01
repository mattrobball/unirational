#!/usr/bin/env python3
"""Independent replay of the five genuine-twist axis valuations.

This verifier does not import the producer.  It reconstructs the Hilbert--90
frame from the accepted exact source, checks the saved plane restrictions by
polynomial-identity interpolation, and uses Singular (rather than the
producer's Macaulay2 call) for the geometric smoothness tests.
"""

from __future__ import annotations

from hashlib import sha256
import json
import math
from pathlib import Path
import subprocess
import sys


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
PAYLOAD = HERE / "axis_divisors.json"
SOURCE = PROBLEM / "certificates/exact_covariants_check.py"
PRIME = 23
FRAME_NAMES = ("x", "C", "D", "E", "K")
FRAME_DEGREES = (1, 4, 5, 6, 7)

sys.path.insert(0, str(PROBLEM / "tmp/generic_twist"))
sys.path.insert(0, str(PROBLEM / "tmp/kproj_arithmetic"))
from phi_coefficients import all_coefficients, evaluate, evaluate_vector, load_source  # noqa: E402
from core import forms  # noqa: E402


def file_sha256(path: Path) -> str:
    digest = sha256()
    with path.open("rb") as handle:
        while chunk := handle.read(1 << 20):
            digest.update(chunk)
    return digest.hexdigest()


def evaluate_mod(polynomial, point):
    return evaluate(polynomial, point) % PRIME


def determinant_mod(columns):
    # Independent small Gaussian determinant over F_p.
    matrix = [[columns[column][row] % PRIME for column in range(5)] for row in range(5)]
    determinant = 1
    for column in range(5):
        pivot = next((row for row in range(column, 5) if matrix[row][column]), None)
        if pivot is None:
            return 0
        if pivot != column:
            matrix[pivot], matrix[column] = matrix[column], matrix[pivot]
            determinant = -determinant
        pivot_value = matrix[column][column] % PRIME
        determinant = determinant * pivot_value % PRIME
        inverse = pow(pivot_value, -1, PRIME)
        matrix[column] = [entry * inverse % PRIME for entry in matrix[column]]
        for row in range(column + 1, 5):
            multiple = matrix[row][column] % PRIME
            if multiple:
                matrix[row] = [
                    (entry - multiple * base) % PRIME
                    for entry, base in zip(matrix[row], matrix[column])
                ]
    return determinant % PRIME


def saved_polynomial(record):
    return {
        tuple(term["exponents"]): int(term["coefficient"]) % PRIME
        for term in record["smooth_plane_section_mod_23"]["restricted"]["terms"]
    }


def polynomial_digest(polynomial):
    terms = [
        {"exponents": list(exponents), "coefficient": polynomial[exponents] % PRIME}
        for exponents in sorted(polynomial, reverse=True)
        if polynomial[exponents] % PRIME
    ]
    raw = json.dumps(terms, sort_keys=True, separators=(",", ":")).encode()
    return sha256(raw).hexdigest()


def evaluate_ternary(polynomial, point):
    return sum(
        coefficient * math.prod(pow(value, exponent, PRIME) for value, exponent in zip(point, exponents))
        for exponents, coefficient in polynomial.items()
    ) % PRIME


def verify_plane_identity(axis_polynomial, record):
    matrix = record["smooth_plane_section_mod_23"]["matrix"]
    saved = saved_polynomial(record)
    degree = record["degree"]
    assert {sum(exponents) for exponents in saved} == {degree}
    assert polynomial_digest(saved) == record["smooth_plane_section_mod_23"]["restricted"]["sha256"]

    # Fixed-degree homogenization makes q(y0,y1,y2) -> q(y0,y1,1)
    # injective.  Each variable degree is <= degree < 23, so equality on the
    # (degree+1)^2 grid proves the exact polynomial identity over F_23.
    for y0 in range(degree + 1):
        for y1 in range(degree + 1):
            source_point = tuple(
                (matrix[row][0] * y0 + matrix[row][1] * y1 + matrix[row][2]) % PRIME
                for row in range(5)
            )
            assert evaluate_mod(axis_polynomial, source_point) == evaluate_ternary(saved, (y0, y1, 1))
    return saved


def singular_polynomial(polynomial, names):
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


def singular_gradient_invariants(polynomial, names):
    serialized = singular_polynomial(polynomial, names)
    variables = ",".join(names)
    program = f"""ring r={PRIME},({variables}),dp;
poly f={serialized};
ideal J=jacob(f);
ideal G=std(J);
print(\"DIM=\"+string(dim(G)));
print(\"DEG=\"+string(vdim(G)));
"""
    completed = subprocess.run(
        ["Singular", "-q"],
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
    if "DIM" not in values:
        raise RuntimeError(completed.stdout + completed.stderr)
    assert values["DIM"] == 0
    return values


def verify_klein_smooth(payload):
    klein = {
        tuple(2 if j == i else 1 if j == (i + 1) % 5 else 0 for j in range(5)): 1
        for i in range(5)
    }
    values = singular_gradient_invariants(klein, tuple(f"z{i}" for i in range(5)))
    assert values == payload["klein_smooth_mod_23_gradient_ideal"]


def main():
    payload = json.loads(PAYLOAD.read_text())
    assert payload["schema"] == "klein-genuine-twist-axis-valuations-v1"
    assert payload["prime"] == PRIME
    assert payload["source_sha256"] == file_sha256(SOURCE)
    assert payload["field"] == "K_aff=C(W)^G"

    names, frame, coefficients = all_coefficients()
    assert tuple(names) == FRAME_NAMES
    axis_polynomials = [coefficients[(index, index, index)] for index in range(5)]
    invariant_forms = forms()
    assert axis_polynomials[0] == invariant_forms[3]
    assert axis_polynomials[1] == invariant_forms[12]
    f5 = load_source().H
    f8 = coefficients[(0, 0, 3)]

    records = payload["records"]
    assert len(records) == 5
    for index, record in enumerate(records):
        assert record["index"] == index
        assert record["column"] == FRAME_NAMES[index]
        assert record["column_degree"] == FRAME_DEGREES[index]
        assert record["degree"] == 3 * FRAME_DEGREES[index] < PRIME
        assert record["term_count"] == len(axis_polynomials[index])
        assert record["source_order"] == record["ramification_index"] == record["downstairs_order"] == 1

        restricted = verify_plane_identity(axis_polynomials[index], record)
        singular_values = singular_gradient_invariants(restricted, ("y0", "y1", "y2"))
        saved_smoothness = record["smooth_plane_section_mod_23"]["smoothness"]
        assert singular_values["DIM"] == saved_smoothness["gradient_affine_cone_dimension"]
        assert singular_values["DEG"] == saved_smoothness["gradient_affine_cone_degree"]

        witness = record["simple_axis_witness_mod_23"]
        point = tuple(witness["source_point"])
        assert evaluate_mod(axis_polynomials[index], point) == 0
        assert evaluate_mod(axis_polynomials[0], point) == witness["f3"]
        assert evaluate_mod(f5, point) == witness["f5"]
        assert evaluate_mod(f8, point) == witness["f8"]
        columns = [[value % PRIME for value in evaluate_vector(vector, point)] for vector in frame]
        assert determinant_mod(columns) == witness["frame_determinant"] != 0

        derivatives = []
        for j in range(5):
            if j == index:
                derivatives.append(3 * evaluate_mod(axis_polynomials[index], point) % PRIME)
            else:
                triple = tuple(sorted((index, index, j)))
                derivatives.append(evaluate_mod(coefficients[triple], point))
        assert derivatives == witness["axis_derivatives"]
        assert any(derivatives)
        assert record["uniformizer"] == f"P_{FRAME_NAMES[index]}"

    verify_klein_smooth(payload)
    index_data = payload["index_one"]
    degrees = index_data["effective_cycle_degrees"]
    bezout = index_data["bezout_coefficients"]
    assert sum(a * b for a, b in zip(degrees, bezout)) == 1
    assert math.gcd(*degrees) == 1
    assert 220 - 73 * index_data["linear_section_degree"] == 1

    print("PASS five absolutely prime genuine-twist divisors")
    print("PASS five unramified quotient valuations with simple axis residue points")
    print("PASS independent Singular smoothness and interpolation replay")
    print("PASS global and completion index-one arithmetic")
    print("V_AXIS_DIVISORS_INDEPENDENT_ACCEPT")


if __name__ == "__main__":
    main()
