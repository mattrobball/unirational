#!/usr/bin/env python3
"""Structured landing search inside the 55-plane arrangement module.

The generalized cross product of gradients of four invariants is a covariant
for this determinant-one representation.  On an involution plus-plane all
four gradients lie in the three-dimensional plus-space, so the cross product
vanishes.  Thus every direction below is globally in the 55-plane arrangement
ideal before any landing equations are imposed.
"""

from __future__ import annotations

import ctypes
import hashlib
import itertools
import json
import math
from pathlib import Path
import sys

import numpy as np


HERE = Path(__file__).resolve().parent
E_ROOT = HERE.parents[1]
sys.path.insert(0, str(E_ROOT / "tmp/generic_twist"))
sys.path.insert(0, str(E_ROOT / "tmp/kproj_arithmetic"))

import phi_coefficients as phi  # noqa: E402
import core as invcore  # noqa: E402


FFPACK = "/opt/homebrew/lib/libffpack_c.dylib"
TARGETS = (25, 31, 35)
PRIMES = ((89, 2026081089), (199, 2026081199))
INVARIANT_NAMES = ("I3", "I5", "I6", "I7", "I8", "I9")


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def rank_details(matrix: np.ndarray, prime: int):
    value = np.array(matrix, dtype=np.int32, order="C", copy=True)
    row_lapack = np.empty(value.shape[0], dtype=np.uintp)
    col_lapack = np.empty(value.shape[1], dtype=np.uintp)
    library = ctypes.CDLL(FFPACK)
    function = library.RowEchelonForm_modular_int32_t
    function.argtypes = [
        ctypes.c_int32, ctypes.c_size_t, ctypes.c_size_t,
        ctypes.POINTER(ctypes.c_int32), ctypes.c_size_t,
        ctypes.POINTER(ctypes.c_size_t), ctypes.POINTER(ctypes.c_size_t),
        ctypes.c_bool, ctypes.c_int, ctypes.c_bool,
    ]
    function.restype = ctypes.c_size_t
    rank = int(function(
        prime, value.shape[0], value.shape[1],
        value.ctypes.data_as(ctypes.POINTER(ctypes.c_int32)), value.shape[1],
        row_lapack.ctypes.data_as(ctypes.POINTER(ctypes.c_size_t)),
        col_lapack.ctypes.data_as(ctypes.POINTER(ctypes.c_size_t)),
        False, 2, True,
    ))
    row_order = np.empty_like(row_lapack)
    convert = library.LAPACKPerm2MathPerm
    convert.argtypes = [
        ctypes.POINTER(ctypes.c_size_t), ctypes.POINTER(ctypes.c_size_t), ctypes.c_size_t
    ]
    convert(
        row_order.ctypes.data_as(ctypes.POINTER(ctypes.c_size_t)),
        row_lapack.ctypes.data_as(ctypes.POINTER(ctypes.c_size_t)),
        len(row_order),
    )
    return rank, row_order.astype(np.int64)


def rank_mod(matrix: np.ndarray, prime: int):
    return rank_details(matrix, prime)[0]


def derivative(polynomial, variable: int):
    result = {}
    for exponents, coefficient in polynomial.items():
        if exponents[variable]:
            lowered = list(exponents)
            lowered[variable] -= 1
            result[tuple(lowered)] = coefficient * exponents[variable]
    return result


def invariant_data():
    forms = invcore.forms()
    selected = {f"I{degree}": forms[degree] for degree in (3, 5, 6, 7, 8, 9)}
    gradients = {
        name: [derivative(polynomial, variable) for variable in range(5)]
        for name, polynomial in selected.items()
    }
    return selected, gradients


def eval_poly(polynomial, point, prime: int):
    total = 0
    for exponents, coefficient in polynomial.items():
        term = coefficient % prime
        for value, exponent in zip(point, exponents):
            term = term * pow(int(value), int(exponent), prime) % prime
        total = (total + term) % prime
    return int(total)


def determinant(matrix, prime: int):
    total = 0
    for permutation in itertools.permutations(range(len(matrix))):
        inversions = sum(
            permutation[i] > permutation[j]
            for i in range(len(permutation))
            for j in range(i + 1, len(permutation))
        )
        term = 1
        for row, column in enumerate(permutation):
            term = term * int(matrix[row][column]) % prime
        total = total - term if inversions % 2 else total + term
    return total % prime


def cross_value(names, gradients, point, prime: int):
    rows = [
        [eval_poly(component, point, prime) for component in gradients[name]]
        for name in names
    ]
    answer = []
    for omitted in range(5):
        minor = [[row[column] for column in range(5) if column != omitted] for row in rows]
        value = determinant(minor, prime)
        answer.append(value if omitted % 2 == 0 else -value)
    return np.asarray(answer, dtype=np.int64) % prime


def invariant_labels(degree: int):
    labels = []
    for secondary, secondary_degree in enumerate(invcore.SECONDARY_DEGREES):
        if secondary_degree <= degree:
            for exponents in invcore.weighted_exponents(degree - secondary_degree):
                labels.append((secondary, tuple(map(int, exponents))))
    return labels


def multiplier(label):
    secondary, exponents = label
    return phi.multiply(
        invcore.primary_monomial(exponents),
        invcore.secondary_polynomials()[secondary],
    )


def label_json(label):
    secondary, exponents = label
    return {
        "secondary_index": secondary,
        "secondary_name": invcore.SECONDARY_NAMES[secondary],
        "secondary_degree": invcore.SECONDARY_DEGREES[secondary],
        "primary_exponents": list(exponents),
    }


def directions(target: int):
    occurrence = {}
    result = []
    for names in itertools.combinations(INVARIANT_NAMES, 4):
        degree = sum(int(name[1:]) - 1 for name in names)
        residual = target - degree
        labels = invariant_labels(residual) if residual >= 0 else []
        if not labels:
            continue
        index = occurrence.get(residual, 0) % len(labels)
        occurrence[residual] = occurrence.get(residual, 0) + 1
        label = labels[index]
        result.append({
            "invariants": names,
            "cross_degree": degree,
            "multiplier_degree": residual,
            "multiplier_label": label,
            "multiplier": multiplier(label),
        })
    return result


def cubic_row(vectors: np.ndarray, prime: int):
    n = len(vectors)
    monomials = tuple(itertools.combinations_with_replacement(range(n), 3))
    index = {monomial: column for column, monomial in enumerate(monomials)}
    row = np.zeros(len(monomials), dtype=np.int32)
    for r in range(n):
        for s in range(n):
            product = vectors[r] * vectors[s] % prime
            for t in range(n):
                coefficient = sum(
                    int(product[i]) * int(vectors[t, (i + 1) % 5])
                    for i in range(5)
                ) % prime
                column = index[tuple(sorted((r, s, t)))]
                row[column] = (int(row[column]) + coefficient) % prime
    return row


def quartic_rows(cubics: np.ndarray, n: int):
    cubmons = tuple(itertools.combinations_with_replacement(range(n), 3))
    quarmons = tuple(itertools.combinations_with_replacement(range(n), 4))
    qindex = {monomial: index for index, monomial in enumerate(quarmons)}
    result = np.zeros((len(cubics) * n, len(quarmons)), dtype=np.int32)
    for row_index, cubic in enumerate(cubics):
        for variable in range(n):
            target = result[row_index * n + variable]
            for coefficient, monomial in zip(cubic, cubmons):
                if coefficient:
                    target[qindex[tuple(sorted(monomial + (variable,)))]] = coefficient
    return result


def main() -> None:
    _forms, gradients = invariant_data()
    summary = {}
    for target in TARGETS:
        directory = HERE / f"degree_{target}"
        selected = directions(target)
        n = len(selected)
        sym3 = math.comb(n + 2, 3)
        records = []
        for prime, seed in PRIMES:
            rng = np.random.default_rng(seed + target)
            points = rng.integers(0, prime, size=(sym3 + 48, 5), dtype=np.int64)
            rows = []
            for point in points:
                values = []
                for direction in selected:
                    cross = cross_value(direction["invariants"], gradients, point, prime)
                    scalar = eval_poly(direction["multiplier"], point, prime)
                    values.append(cross * scalar % prime)
                rows.append(cubic_row(np.asarray(values), prime))
            rows = np.asarray(rows, dtype=np.int32)
            rank, order = rank_details(rows, prime)
            independent = order[:rank]
            quartic = None
            if rank < sym3:
                matrix = quartic_rows(rows[independent], n)
                quartic = {
                    "shape": list(matrix.shape),
                    "rank": rank_mod(matrix, prime),
                    "target_dimension": math.comb(n + 3, 4),
                }
                quartic["contains_all_quartics"] = quartic["rank"] == quartic["target_dimension"]
                del matrix
            output = directory / f"cross_landing_p{prime}.npz"
            np.savez_compressed(
                output,
                points=points.astype(np.int32),
                rows=rows,
                independent_row_indices=independent.astype(np.int32),
            )
            records.append({
                "prime": prime,
                "rank": rank,
                "payload": output.name,
                "payload_sha256": sha256(output),
                "quartic_closure": quartic,
            })
            print(f"cross degree={target} prime={prime} n={n} sym3={sym3} rank={rank} quartic={quartic}", flush=True)
        payload = {
            "degree": target,
            "direction_count": n,
            "symmetric_cube_dimension": sym3,
            "directions": [
                {
                    "gradient_invariants": list(direction["invariants"]),
                    "cross_degree": direction["cross_degree"],
                    "multiplier_degree": direction["multiplier_degree"],
                    "multiplier": label_json(direction["multiplier_label"]),
                }
                for direction in selected
            ],
            "arrangement_proof": (
                "At a point of an involution plus-plane, gradients of invariant "
                "forms lie in the 3-dimensional plus eigenspace. Four such "
                "gradients are dependent, so their generalized cross product "
                "vanishes. Equivariance propagates this to all 55 planes."
            ),
            "prime_records": records,
            "characteristic_zero_conclusion": (
                "empty_projective_arrangement_ansatz"
                if all(
                    record["rank"] == sym3
                    or record["quartic_closure"]["contains_all_quartics"]
                    for record in records
                )
                else "not_decided"
            ),
        }
        (directory / "cross_ansatz.json").write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
        summary[str(target)] = payload
    (HERE / "cross_ansatz_summary.json").write_text(json.dumps(summary, indent=2, sort_keys=True) + "\n")
    print("COV_CROSS_ANSATZ_PRODUCED")


if __name__ == "__main__":
    main()
