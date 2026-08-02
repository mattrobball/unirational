#!/usr/bin/env python3
"""Find deterministic good-fibre line sections and audit the d=4 boundary.

The output is modular reconnaissance only.  A degree-one section in a split
good fibre is a rational line on that fibre and does not descend to the
projective Schur field.  Multiplying its tuple by a binary cubic gives a raw
degree-four solution with a common factor; the script records it to expose
the main false component of the quartic coefficient scheme.
"""

from __future__ import annotations

import argparse
import importlib.util
import json
from pathlib import Path

import numpy as np
import sympy as sp


HERE = Path(__file__).resolve().parent
PRODUCER_PATH = HERE / "probe_section_modp.py"


def load_probe():
    spec = importlib.util.spec_from_file_location("m3_probe_section_modp", PRODUCER_PATH)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def klein_batch(points: np.ndarray, frame: np.ndarray, prime: int) -> np.ndarray:
    target = points @ frame.T % prime
    return np.sum(target * target % prime * np.roll(target, -1, axis=1), axis=1) % prime


def inverse_2x2(matrix: np.ndarray, prime: int) -> np.ndarray:
    determinant = int(matrix[0, 0] * matrix[1, 1] - matrix[0, 1] * matrix[1, 0]) % prime
    assert determinant
    scale = pow(determinant, -1, prime)
    return scale * np.array(
        [[matrix[1, 1], -matrix[0, 1]], [-matrix[1, 0], matrix[0, 0]]],
        dtype=np.int64,
    ) % prime


def inverse_matrix(matrix: np.ndarray, prime: int) -> np.ndarray:
    size = matrix.shape[0]
    augmented = np.concatenate((matrix.copy() % prime, np.eye(size, dtype=np.int64)), axis=1)
    for column in range(size):
        choices = np.flatnonzero(augmented[column:, column])
        assert len(choices)
        pivot = column + int(choices[0])
        augmented[[column, pivot]] = augmented[[pivot, column]]
        augmented[column] = augmented[column] * pow(int(augmented[column, column]), -1, prime) % prime
        for row in range(size):
            if row != column and augmented[row, column]:
                augmented[row] = (augmented[row] - augmented[row, column] * augmented[column]) % prime
    return augmented[:, size:] % prime


def nullspace(matrix: np.ndarray, prime: int) -> np.ndarray:
    reduced = matrix.copy() % prime
    rows, columns = reduced.shape
    pivots: list[int] = []
    row = 0
    for column in range(columns):
        choices = np.flatnonzero(reduced[row:, column])
        if not len(choices):
            continue
        pivot = row + int(choices[0])
        reduced[[row, pivot]] = reduced[[pivot, row]]
        reduced[row] = reduced[row] * pow(int(reduced[row, column]), -1, prime) % prime
        for other in range(rows):
            if other != row and reduced[other, column]:
                reduced[other] = (reduced[other] - reduced[other, column] * reduced[row]) % prime
        pivots.append(column)
        row += 1
        if row == rows:
            break
    free = [column for column in range(columns) if column not in pivots]
    vectors = []
    for column in free:
        vector = np.zeros(columns, dtype=np.int64)
        vector[column] = 1
        for pivot_row, pivot_column in enumerate(pivots):
            vector[pivot_column] = -reduced[pivot_row, column] % prime
        vectors.append(vector)
    return np.stack(vectors, axis=1) if vectors else np.zeros((columns, 0), dtype=np.int64)


def target_generators(certificate: dict, probe, prime: int, zeta: int) -> dict[str, np.ndarray]:
    matrices = []
    for serialized in certificate["target_generators_ST"]:
        matrices.append(
            np.array(
                [
                    [probe.reduce_k11(entry, prime, zeta) for entry in row]
                    for row in serialized
                ],
                dtype=np.int64,
            )
            % prime
        )
    return {"S": matrices[0], "T": matrices[1]}


def find_orbit_line(certificate: dict, probe, frame: np.ndarray, prime: int, zeta: int):
    generators = target_generators(certificate, probe, prime, zeta)
    identity = np.eye(5, dtype=np.int64) % prime
    target_to_a = inverse_matrix(frame, prime)
    seen = set()
    candidates = []
    for word in certificate["projective_words"]:
        matrix = identity.copy()
        for letter in word:
            matrix = matrix @ generators[letter] % prime
        key = tuple(map(int, matrix.reshape(-1)))
        if key in seen:
            continue
        seen.add(key)
        if not np.array_equal(matrix, identity) and np.array_equal(matrix @ matrix % prime, identity):
            line_target = nullspace(matrix + identity, prime)
            assert line_target.shape == (5, 2)
            line_a = target_to_a @ line_target % prime
            p, q = line_a[:, 0], line_a[:, 1]
            minor = int(p[3] * q[4] - p[4] * q[3]) % prime
            candidates.append((minor, p, q))
    assert len(seen) == 660 and len(candidates) == 55
    usable = [record for record in candidates if record[0]]
    if not usable:
        raise RuntimeError("all 55 orbit lines meet the selected plane at this reduction")
    usable.sort(key=lambda record: tuple(map(int, np.concatenate((record[1], record[2])))))
    minor, p, q = usable[0]
    return p, q, len(candidates), len(usable), minor


def find_line(frame: np.ndarray, prime: int, seed: int) -> tuple[np.ndarray, np.ndarray, int]:
    rng = np.random.default_rng(seed)
    attempts = 0
    batch_size = 200_000
    while attempts < 100_000_000:
        p = rng.integers(0, prime, size=(batch_size, 5), dtype=np.int64)
        q = rng.integers(0, prime, size=(batch_size, 5), dtype=np.int64)
        nonzero = np.any(p, axis=1) & np.any(q, axis=1)
        independent_projection = (p[:, 3] * q[:, 4] - p[:, 4] * q[:, 3]) % prime != 0
        mask = nonzero & independent_projection
        for points in (p, q, (p + q) % prime, (p + 2 * q) % prime):
            mask &= klein_batch(points, frame, prime) == 0
        indices = np.flatnonzero(mask)
        attempts += batch_size
        if len(indices):
            index = int(indices[0])
            return p[index] % prime, q[index] % prime, attempts - batch_size + index + 1
    raise RuntimeError("deterministic line search exhausted")


def line_parameters(p: np.ndarray, q: np.ndarray, prime: int) -> list[int]:
    projection = np.array([[p[3], q[3]], [p[4], q[4]]], dtype=np.int64) % prime
    inverse = inverse_2x2(projection, prime)
    coefficients = []
    for coordinate in range(3):
        row = np.array([p[coordinate], q[coordinate]], dtype=np.int64) @ inverse % prime
        coefficients.extend(map(int, row))
    coefficients.append(1)
    return coefficients


def multiply_line_by_cubic(line: list[int], cubic: list[int], prime: int) -> list[int]:
    # Parameter order is A0[0..4], A1[0..4], A2[0..4], b[0..3].
    result: list[int] = []
    for coordinate in range(3):
        linear = line[2 * coordinate : 2 * coordinate + 2]
        product = [0] * 5
        for i, left in enumerate(linear):
            for j, right in enumerate(cubic):
                product[i + j] = (product[i + j] + left * right) % prime
        result.extend(product)
    result.extend((line[-1] * value) % prime for value in cubic)
    return result


def evaluate_poly(poly: sp.Poly, point: list[int], prime: int) -> int:
    value = 0
    for exponents, coefficient in poly.terms():
        term = int(coefficient) % prime
        for coordinate, exponent in zip(point, exponents):
            term = term * pow(int(coordinate), exponent, prime) % prime
        value = (value + term) % prime
    return value


def jacobian_rank(equations: list[sp.Poly], parameters: list[sp.Symbol], point: list[int], prime: int) -> int:
    matrix = np.array(
        [
            [evaluate_poly(sp.Poly(sp.diff(equation.as_expr(), parameter), *parameters, modulus=prime), point, prime)
             for parameter in parameters]
            for equation in equations
        ],
        dtype=np.int64,
    ) % prime
    rank = 0
    for column in range(matrix.shape[1]):
        choices = np.flatnonzero(matrix[rank:, column])
        if not len(choices):
            continue
        pivot = rank + int(choices[0])
        matrix[[rank, pivot]] = matrix[[pivot, rank]]
        matrix[rank] = matrix[rank] * pow(int(matrix[rank, column]), -1, prime) % prime
        for row in range(matrix.shape[0]):
            if row != rank and matrix[row, column]:
                matrix[row] = (matrix[row] - matrix[row, column] * matrix[rank]) % prime
        rank += 1
        if rank == matrix.shape[0]:
            break
    return rank


def section_polynomials(probe, phi: sp.Poly, degree: int, prime: int):
    # Reconstruct the equations as Poly objects rather than parsing the
    # serialized Singular text.
    s, t = sp.symbols("s t")
    blocks = [tuple(sp.symbols(f"A{i}_0:{degree + 1}")) for i in range(3)]
    b_block = tuple(sp.symbols(f"b_0:{degree}"))
    forms = [sum(block[j] * s ** (degree - j) * t**j for j in range(degree + 1)) for block in blocks]
    b = sum(b_block[j] * s ** (degree - 1 - j) * t**j for j in range(degree))
    old = phi.gens
    identity = sp.expand(phi.as_expr().subs({old[0]: forms[0], old[1]: forms[1], old[2]: forms[2], old[3]: s * b, old[4]: t * b}))
    binary = sp.Poly(identity, s, t)
    parameters = [item for block in (*blocks, b_block) for item in block]
    equations = [
        sp.Poly(binary.coeff_monomial(s ** (3 * degree - k) * t**k), *parameters, modulus=prime)
        for k in range(3 * degree + 1)
    ]
    return parameters, equations


def squarefree_cubic(prime: int) -> list[int]:
    s, t = sp.symbols("s t")
    for values in ([1, 0, 1, 1], [1, 1, 0, 1], [1, 2, 3, 4]):
        polynomial = sum(values[j] * s ** (3 - j) * t**j for j in range(4))
        # A homogeneous binary cubic is squarefree iff the two partials have
        # no common projective zero.  The affine discriminant suffices here
        # because the leading and trailing coefficients are nonzero.
        if values[0] % prime and values[-1] % prime:
            univariate = sp.Poly(polynomial.subs(t, 1), s, modulus=prime)
            if sp.gcd(univariate, sp.diff(univariate, s)).degree() == 0:
                return [value % prime for value in values]
    raise AssertionError("no deterministic squarefree cubic")


def build(prime: int) -> dict:
    probe = load_probe()
    certificate = json.loads(probe.FRAME.read_text())
    zeta, frame_rows = probe.frame_mod_prime(certificate, prime)
    frame = np.asarray(frame_rows, dtype=np.int64) % prime
    p, q, orbit_count, usable_count, orbit_minor = find_orbit_line(
        certificate, probe, frame, prime, zeta
    )
    line = line_parameters(p, q, prime)
    phi = probe.transformed_klein(frame_rows, prime)
    parameters1, equations1 = section_polynomials(probe, phi, 1, prime)
    assert not any(evaluate_poly(equation, line, prime) for equation in equations1)
    cubic = squarefree_cubic(prime)
    boundary = multiply_line_by_cubic(line, cubic, prime)
    parameters4, equations4 = section_polynomials(probe, phi, 4, prime)
    assert not any(evaluate_poly(equation, boundary, prime) for equation in equations4)
    # Every coordinate form, including b, is divisible by this cubic, so the
    # raw d=4 point is excluded from the common-zero-free section open.
    rank = jacobian_rank(equations4, parameters4, boundary, prime)
    return {
        "schema": "m3-projective-schur-modular-line-boundary-v1",
        "scope": "modular discovery only",
        "prime": prime,
        "zeta11": zeta,
        "line_source": "first lexicographic usable involution-minus-line",
        "involution_line_count": orbit_count,
        "involution_lines_disjoint_from_selected_plane": usable_count,
        "line_basis_vectors": [p.tolist(), q.tolist()],
        "projection_minor_a3a4": orbit_minor,
        "degree1_section_parameters": line,
        "degree1_equations_zero": True,
        "degree4_common_factor": cubic,
        "degree4_boundary_parameters": boundary,
        "degree4_equations_zero": True,
        "degree4_common_zero_free": False,
        "degree4_jacobian_rank_at_boundary": rank,
        "degree4_raw_local_affine_dimension_upper_bound": 19 - rank,
        "theorem_boundary": "A split-fibre line and its common-factor quartic boundary do not define a K_Schur section.",
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--prime", type=int, default=23)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    payload = build(args.prime)
    text = json.dumps(payload, indent=2, sort_keys=True) + "\n"
    if args.write:
        (HERE / f"modular_section_boundary_p{args.prime}.json").write_text(text)
    else:
        print(text, end="")


if __name__ == "__main__":
    main()
