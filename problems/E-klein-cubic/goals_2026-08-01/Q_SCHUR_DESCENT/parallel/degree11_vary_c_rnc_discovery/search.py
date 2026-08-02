#!/usr/bin/env python3
"""Exhaust P^2(F_89) for varying constant columns in the A5 transfer.

Discovery scope only: absence of F_89-points on the rank-drop locus is not a
characteristic-zero emptiness theorem.  The two non-rational class-1 roots
are Frobenius conjugate, so they have identical ranks for c in P^2(F_89).
"""

from __future__ import annotations

from collections import Counter
import importlib.util
import itertools
import json
from pathlib import Path
import sys
import time

import numpy as np


HERE = Path(__file__).resolve().parent
SECANT = HERE.parent / "degree11_secant_descent_agent" / "analyze.py"


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


SEC = load_module("sealed_degree11_secant", SECANT)
BASE = SEC.BASE
P = 89
NS = 65
INV = [0] + [pow(value, -1, P) for value in range(1, P)]


def projective_plane_points():
    points = [(1, a, b) for a in range(P) for b in range(P)]
    points += [(0, 1, b) for b in range(P)]
    points += [(0, 0, 1)]
    assert len(points) == P * P + P + 1 == 8011
    return np.asarray(points, dtype=np.int64)


def coefficient_tensor(covariants):
    exponents = sorted(
        {exponent for covariant in covariants for polynomial in covariant for exponent in polynomial}
    )
    location = {exponent: index for index, exponent in enumerate(exponents)}
    tensor = np.zeros((5, 5, len(exponents)), dtype=np.int64)
    for covariant_index, covariant in enumerate(covariants):
        for output, polynomial in enumerate(covariant):
            for exponent, coefficient in polynomial.items():
                tensor[covariant_index, output, location[exponent]] = coefficient
    assert len(exponents) == 75
    return exponents, tensor


def monomial_values(points, exponents):
    powers = []
    for coordinate in range(3):
        table = np.ones((len(points), 12), dtype=np.int64)
        for degree in range(1, 12):
            table[:, degree] = table[:, degree - 1] * points[:, coordinate] % P
        powers.append(table)
    values = np.ones((len(points), len(exponents)), dtype=np.int64)
    for index, exponent in enumerate(exponents):
        for coordinate, degree in enumerate(exponent):
            values[:, index] = values[:, index] * powers[coordinate][:, degree] % P
    return values


def basis_orbits(record, constants, exponents, tensor):
    subgroup = tuple(tuple(value) for value in record["subgroup_elements"])
    generators = tuple(tuple(value) for value in record["generators"])
    abstract_map = {
        tuple(row["h"]): tuple(row["permutation"]) for row in record["source_map"]
    }
    intertwiner = np.asarray(BASE.ambient_intertwiner(generators, abstract_map), dtype=np.int64)
    representatives = BASE.right_coset_representatives(subgroup)
    vector = (1, 4, 5, 5, 6)
    answer = np.zeros((len(constants), 11, 5, 5), dtype=np.int64)
    for coset_index, representative in enumerate(representatives):
        moved = BASE.mat_vec(
            BASE.PRODUCE.RHO[BASE.PRODUCE.ginv(representative)], vector
        )
        frame = BASE.transfer_frame(moved, subgroup, abstract_map)
        assert frame is not None and BASE.determinant(frame)
        source = constants @ np.asarray(frame, dtype=np.int64).T % P
        monomials = monomial_values(source, exponents)
        # n=source point, k=covariant number, o=canonical target coordinate.
        evaluated = np.einsum("nm,kom->nko", monomials, tensor, optimize=True) % P
        transform = (
            np.asarray(BASE.PRODUCE.RHO[representative], dtype=np.int64)
            @ intertwiner
        ) % P
        answer[:, coset_index, :, :] = (
            np.einsum("nko,jo->nkj", evaluated, transform, optimize=True) % P
        )
    return answer


def parameter_components(parameters):
    real = np.asarray([SEC.F89x2.coerce(value).a for value in parameters], dtype=np.int64)
    imag = np.asarray([SEC.F89x2.coerce(value).b for value in parameters], dtype=np.int64)
    return real, imag


def combine_basis(basis, parameters):
    real_coefficients, imag_coefficients = parameter_components(parameters)
    real = np.einsum("ngko,k->ngo", basis, real_coefficients, optimize=True) % P
    imag = np.einsum("ngko,k->ngo", basis, imag_coefficients, optimize=True) % P
    return real, imag


def quadratic_rows(real, imag):
    count = len(real)
    qr = np.empty((count, 11, 15), dtype=np.int64)
    qi = np.empty_like(qr)
    column = 0
    for left in range(5):
        for right in range(left, 5):
            qr[:, :, column] = (
                real[:, :, left] * real[:, :, right]
                + NS * imag[:, :, left] * imag[:, :, right]
            ) % P
            qi[:, :, column] = (
                real[:, :, left] * imag[:, :, right]
                + imag[:, :, left] * real[:, :, right]
            ) % P
            column += 1
    return qr, qi


def rank_fp(matrix):
    work = [[int(value) for value in row] for row in matrix]
    rows, columns = len(work), len(work[0])
    pivot_row = 0
    for column in range(columns):
        pivot = next((row for row in range(pivot_row, rows) if work[row][column]), None)
        if pivot is None:
            continue
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        inverse = INV[work[pivot_row][column]]
        work[pivot_row] = [value * inverse % P for value in work[pivot_row]]
        for row in range(pivot_row + 1, rows):
            scalar = work[row][column]
            if scalar:
                work[row] = [
                    (a - scalar * b) % P
                    for a, b in zip(work[row], work[pivot_row])
                ]
        pivot_row += 1
        if pivot_row == rows:
            break
    return pivot_row


def fp2_mul(x, y):
    return ((x[0] * y[0] + NS * x[1] * y[1]) % P,
            (x[0] * y[1] + x[1] * y[0]) % P)


def fp2_inv(x):
    norm = (x[0] * x[0] - NS * x[1] * x[1]) % P
    unit = INV[norm]
    return (x[0] * unit % P, -x[1] * unit % P)


def rank_fp2(real, imag):
    work = [
        [(int(a), int(b)) for a, b in zip(real_row, imag_row)]
        for real_row, imag_row in zip(real, imag)
    ]
    rows, columns = len(work), len(work[0])
    pivot_row = 0
    for column in range(columns):
        pivot = next(
            (row for row in range(pivot_row, rows) if work[row][column] != (0, 0)),
            None,
        )
        if pivot is None:
            continue
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        inverse = fp2_inv(work[pivot_row][column])
        work[pivot_row] = [fp2_mul(value, inverse) for value in work[pivot_row]]
        for row in range(pivot_row + 1, rows):
            scalar = work[row][column]
            if scalar != (0, 0):
                product = [fp2_mul(scalar, value) for value in work[pivot_row]]
                work[row] = [
                    ((a[0] - b[0]) % P, (a[1] - b[1]) % P)
                    for a, b in zip(work[row], product)
                ]
        pivot_row += 1
        if pivot_row == rows:
            break
    return pivot_row


def normalized_fp2_point(real, imag):
    pivot = next(
        index for index in range(5) if real[index] or imag[index]
    )
    inverse = fp2_inv((int(real[pivot]), int(imag[pivot])))
    return tuple(
        fp2_mul((int(real[index]), int(imag[index])), inverse)
        for index in range(5)
    )


def scan_map(constants, basis, parameters, label):
    started = time.time()
    real, imag = combine_basis(basis, parameters)
    defined = np.all(np.any((real != 0) | (imag != 0), axis=2), axis=1)
    qr, qi = quadratic_rows(real, imag)
    ranks = Counter()
    candidates = []
    rank_ten_points = []
    extension = bool(np.any(imag))
    for index in range(len(constants)):
        if not defined[index]:
            ranks["undefined"] += 1
            continue
        if extension:
            current_rank = rank_fp2(qr[index], qi[index])
        else:
            current_rank = rank_fp(qr[index])
        ranks[str(current_rank)] += 1
        if current_rank == 10:
            rank_ten_points.append([int(value) for value in constants[index]])
        if current_rank <= 9:
            normalized = {
                normalized_fp2_point(real[index, orbit], imag[index, orbit])
                for orbit in range(11)
            }
            candidates.append(
                {
                    "c": [int(value) for value in constants[index]],
                    "quadric_rank": current_rank,
                    "distinct_orbit_points": len(normalized),
                }
            )
    elapsed = time.time() - started
    print(label, "COUNTS", dict(sorted(ranks.items())), "CANDIDATES", len(candidates), "SECONDS", round(elapsed, 3), flush=True)
    return {
        "label": label,
        "parameter_vector": [SEC.vector_to_json(parameters)[i] for i in range(5)],
        "field": "F_89(u), u^2=65" if extension else "F_89",
        "rank_counts": dict(sorted(ranks.items())),
        "rank_at_most_9_candidates": candidates,
        "rank_10_points": rank_ten_points,
        "elapsed_seconds": elapsed,
    }


def main():
    constants = projective_plane_points()
    twists = json.loads((BASE.SUBGROUP / "twists.json").read_text())
    covariants = BASE.load_covariants()
    exponents, tensor = coefficient_tensor(covariants)
    results = []
    for class_index, (record, radical_sign, roots) in enumerate(
        (
            (twists["records"][0], -1, SEC.class1_roots()),
            (twists["records"][1], 1, SEC.class2_roots()),
        )
    ):
        basis = basis_orbits(record, constants, exponents, tensor)
        root_indices = (0, 1) if class_index == 0 else (0, 1, 2)
        for root_index in root_indices:
            parameters = SEC.parameter_vector(radical_sign, roots[root_index])
            label = f"{record['label']}_root_{root_index}"
            result = scan_map(constants, basis, parameters, label)
            if class_index == 0 and root_index == 1:
                result["covers_frobenius_conjugate_root"] = 2
            results.append(result)
    payload = {
        "format": "A5-VARY-CONSTANT-C-RNC-DISCOVERY-v1",
        "prime": P,
        "projective_source_points": len(constants),
        "maps_scanned": 6,
        "independent_rank_scans": 5,
        "results": results,
        "scope": (
            "Exhaustive only for c in P2(F_89). No rank-drop point over F_89 "
            "does not imply geometric emptiness or characteristic-zero emptiness."
        ),
    }
    (HERE / "results.json").write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("A5_VARY_C_P2_F89_DISCOVERY_COMPLETE")


if __name__ == "__main__":
    main()
