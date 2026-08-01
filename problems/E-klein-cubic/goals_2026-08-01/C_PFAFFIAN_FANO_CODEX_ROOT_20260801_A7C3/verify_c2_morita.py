#!/usr/bin/env python3
"""Independent replay of the lazy exact C2 projector and Morita transport."""

from __future__ import annotations

import hashlib
import json
import runpy
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
P = 23
ZETA = 2
POINT = (1, 2, 3, 4, 5)


def digest(path):
    value = hashlib.sha256()
    with path.open("rb") as stream:
        while block := stream.read(1 << 20):
            value.update(block)
    return value.hexdigest()


def inv(matrix):
    n = matrix.shape[0]
    work = np.concatenate([matrix.copy() % P, np.eye(n, dtype=np.int64)], axis=1)
    for column in range(n):
        options = np.flatnonzero(work[column:, column])
        assert len(options)
        pivot = column + int(options[0])
        work[[column, pivot]] = work[[pivot, column]]
        work[column] = work[column] * pow(int(work[column, column]), -1, P) % P
        for row in range(n):
            if row != column and work[row, column]:
                work[row] = (work[row] - work[row, column] * work[column]) % P
    return work[:, n:]


def rank(entries):
    if not entries:
        return 0
    work = np.stack([entry.reshape(-1) for entry in entries], axis=1) % P
    pivot_row = 0
    for column in range(work.shape[1]):
        options = np.flatnonzero(work[pivot_row:, column])
        if not len(options):
            continue
        pivot = pivot_row + int(options[0])
        work[[pivot_row, pivot]] = work[[pivot, pivot_row]]
        work[pivot_row] = work[pivot_row] * pow(int(work[pivot_row, column]), -1, P) % P
        for row in range(work.shape[0]):
            if row != pivot_row and work[row, column]:
                work[row] = (work[row] - work[row, column] * work[pivot_row]) % P
        pivot_row += 1
        if pivot_row == work.shape[0]:
            break
    return pivot_row


def coordinate_oracle(basis, rows):
    columns = np.stack([entry.reshape(-1) for entry in basis], axis=1) % P
    square_inverse = inv(columns[rows, :])

    def coordinates(value):
        answer = square_inverse @ value.reshape(-1)[rows] % P
        assert np.array_equal(columns @ answer % P, value.reshape(-1) % P)
        return answer

    return coordinates


def skew(values, pairs):
    answer = np.zeros((6, 6), dtype=np.int64)
    for value, (left, right) in zip(values, pairs):
        answer[left, right] = int(value) % P
        answer[right, left] = -int(value) % P
    return answer


def reduce_exact_rur():
    payload = json.loads((HERE / "ambient_degree12_rur_char0.json").read_text())
    assert payload["format"] == "ambient-degree12-rur-char0-qzeta11-v1"

    def reduce_k11(coefficients):
        return sum(
            (int(numerator) % P)
            * pow(int(denominator) % P, -1, P)
            * pow(ZETA, power, P)
            for power, (numerator, denominator) in enumerate(coefficients)
        ) % P

    flat = [reduce_k11(entry) for entry in payload["raw_rur_coefficients_power_basis"]]
    assert flat[:4] == [3, 14, 5, 1]
    names = ["a47", *[f"a{index}" for index in range(1, 47)]]
    vectors = []
    for root in (1, 6, 11):
        coordinates = {"a0": root}
        for block, name in enumerate(names):
            coordinates[name] = -sum(
                flat[4 + 3 * block + power] * pow(root, power, P)
                for power in range(3)
            ) % P
        vectors.append([coordinates[f"a{index}"] for index in range(48)])
    sealed = json.loads((HERE / "ambient_degree12_points_p23.json").read_text())
    assert sealed["roots"] == [1, 6, 11]
    assert vectors == [row["coefficient_vector"] for row in sealed["checks"]]
    return vectors


def main():
    payload = json.loads((HERE / "c2_morita.json").read_text())
    assert payload["format"] == "c2-lazy-exact-morita-v1"
    shared = HERE.parent / "C_PFAFFIAN_FANO_CODEX_ROOT"
    expected_hashes = {
        "char0_rur": digest(HERE / "ambient_degree12_rur_char0.json"),
        "global_pluecker": digest(HERE / "ambient_degree12_global_exact.json"),
        "compressed_algebra": digest(shared / "compressed_algebra.json"),
        "distinguished_five_plane": digest(shared / "distinguished_five_plane.json"),
    }
    assert payload["source_sha256"] == expected_hashes
    global_result = json.loads((HERE / "ambient_degree12_global_exact.json").read_text())
    assert global_result["all_exact_zero"] is True
    vectors = reduce_exact_rur()
    print("PASS exact Q(zeta11) RUR reduces to all three sealed p=23 residue vectors")

    fw = runpy.run_path(
        str(ROOT / "tmp" / "pfaffian_rank2_idempotent_attack" / "full_wedge.py")
    )
    scanner = fw["FullWedgeScanner"]()
    seeds = [
        (int(output), tuple(exponents))
        for output, exponents in json.loads(
            (HERE / "ambient_degree12_a47_chart.json").read_text()
        )["seeds"]
    ]
    point = np.array(POINT, dtype=np.int64)
    values = np.stack(
        [scanner.evaluate_seed(output, exponents, point) for output, exponents in seeds]
    )
    wedge = np.array(vectors[0], dtype=np.int64) @ values % P
    fano = fw["fano"]
    six = fano["six_dimensional_generators"]()
    dual = tuple(fano["inv"](generator).T % P for generator in six)
    dual_wedge = tuple(fano["exterior_square"](generator) for generator in dual)
    domain_basis, _ = fano["invariant_summands"](dual_wedge)
    pairs = tuple(fano["PAIR_INDEX"])
    q_values = domain_basis @ point % P
    q = skew(q_values, pairs)
    bivector = skew(wedge, pairs)
    pairing = int(np.dot(q_values, wedge) % P)
    assert pairing == payload["good_fibre_witness"]["pairing"] == 3
    e = -bivector @ q * pow(pairing, -1, P) % P
    qinv = inv(q)
    sigma = lambda matrix: qinv @ matrix.T @ q % P
    assert np.array_equal(e @ e % P, e)
    assert np.array_equal(sigma(e), e)
    assert int(np.trace(e)) % P == 2
    assert wedge.astype(int).tolist() == payload["good_fibre_witness"]["bivector"]
    print("PASS independently rebuilt e=-P Q/s with idempotence, self-adjointness, and rank two")

    c3 = runpy.run_path(str(ROOT / "certificates" / "fano_c3" / "produce_c3.py"))
    c2 = c3["load_c2_helpers"]()
    frame = c2["build_projective_reynolds_frame"](P, ZETA)
    matrices = [entry % P for entry in frame["basis_mats"]]
    corner = []
    for label in payload["corner"]["basis_circuits"]:
        if label["kind"] == "projector":
            corner.append(e)
        else:
            corner.append(e @ matrices[label["frame_index"]] @ e % P)
    assert rank(corner) == 4
    assert [entry.astype(int).tolist() for entry in corner] == payload["good_fibre_witness"]["corner_basis_values"]
    coordinates = coordinate_oracle(corner, payload["good_fibre_witness"]["corner_basis_rows"])
    star = np.stack([coordinates(sigma(entry)) for entry in corner], axis=1) % P
    assert star.astype(int).tolist() == payload["good_fibre_witness"]["corner_star_matrix_columns"]
    assert np.array_equal(star @ star % P, np.eye(4, dtype=np.int64) % P)
    multiplication = [
        [[int(v) for v in coordinates(left @ right % P)] for right in corner]
        for left in corner
    ]
    assert multiplication == payload["good_fibre_witness"]["corner_multiplication_left_right_coordinates"]
    symbol = payload["good_fibre_witness"]["quaternion_symbol"]

    def corner_mul(left, right):
        answer = np.zeros(4, dtype=np.int64)
        for i, a in enumerate(left):
            for j, b in enumerate(right):
                answer += int(a) * int(b) * np.array(multiplication[i][j], dtype=np.int64)
        return answer % P

    i_coordinates = np.array(symbol["i_coordinates_mod_23"], dtype=np.int64)
    j_coordinates = np.array(symbol["j_coordinates_mod_23"], dtype=np.int64)
    ij_coordinates = np.array(symbol["ij_coordinates_mod_23"], dtype=np.int64)
    assert np.array_equal(star @ i_coordinates % P, -i_coordinates % P)
    assert np.array_equal(star @ j_coordinates % P, -j_coordinates % P)
    i_square = corner_mul(i_coordinates, i_coordinates)
    j_square = corner_mul(j_coordinates, j_coordinates)
    assert i_square.tolist() == [symbol["a_mod_23"], 0, 0, 0]
    assert j_square.tolist() == [symbol["b_mod_23"], 0, 0, 0]
    assert np.array_equal(corner_mul(i_coordinates, j_coordinates), ij_coordinates)
    assert np.array_equal(
        (corner_mul(i_coordinates, j_coordinates) + corner_mul(j_coordinates, i_coordinates)) % P,
        np.zeros(4, dtype=np.int64),
    )
    assert rank([corner[0], *[
        sum((int(coordinate) * basis for coordinate, basis in zip(vector, corner)), np.zeros((6, 6), dtype=np.int64)) % P
        for vector in (i_coordinates, j_coordinates, ij_coordinates)
    ]]) == 4
    print("PASS corner has an executable quaternion symbol (a,b), multiplication, and canonical involution")

    identity = np.eye(6, dtype=np.int64) % P
    generators = []
    for label in payload["morita"]["basis_generator_circuits"]:
        generators.append(identity if label["kind"] == "identity" else matrices[label["frame_index"]])
    module_basis = [generator @ e @ d % P for generator in generators for d in corner]
    assert rank(module_basis) == 12
    print("PASS three selected generators give a right-D basis of A_proj e")

    phi = runpy.run_path(str(ROOT / "tmp" / "generic_twist" / "phi_coefficients.py"))
    names, hilbert_frame, _ = phi["all_coefficients"]()
    assert list(names) == payload["distinguished_hermitian_forms"]["names"]
    section = []
    for vector in hilbert_frame:
        value = np.array(
            [int(phi["evaluate"](component, POINT)) % P for component in vector],
            dtype=np.int64,
        )
        element = qinv @ skew(domain_basis @ value % P, pairs) % P
        assert np.array_equal(sigma(element), element)
        section.append(element)
    assert rank(section) == 5
    hermitian = []
    for element in section:
        form = []
        for left in generators:
            row = []
            for right in generators:
                row.append([int(v) for v in coordinates(e @ sigma(left) @ element @ right @ e % P)])
            form.append(row)
        hermitian.append(form)
    assert hermitian == payload["good_fibre_witness"]["hermitian_matrices_D_coordinates"]
    for form in hermitian:
        for row in range(3):
            for column in range(3):
                assert np.array_equal(
                    star @ np.array(form[row][column], dtype=np.int64) % P,
                    np.array(form[column][row], dtype=np.int64),
                )
    assert rank([np.array(form, dtype=np.int64) for form in hermitian]) == 5
    print("PASS all five intended Hilbert-90 section elements transport to Hermitian 3x3(D) matrices")
    print("SCOPE C2 only: no simultaneous common right D-line has been supplied")
    print("C2-MORITA-FIVE-HERMITIAN-INDEPENDENTLY-VERIFIED")


if __name__ == "__main__":
    main()
