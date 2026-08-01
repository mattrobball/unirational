#!/usr/bin/env python3
"""Install a lazy exact Morita model from the exact degree-12 bivector.

The characteristic-zero objects are specified by rational circuits.  A fresh
good-fibre calculation selects bases and proves that their determinant
circuits are nonzero.  Nothing in this file asserts a point of the genuine
Fano section.
"""

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


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def rank_mod(columns: list[np.ndarray], prime: int = P) -> int:
    if not columns:
        return 0
    matrix = np.stack([column.reshape(-1) for column in columns], axis=1) % prime
    row = 0
    for column in range(matrix.shape[1]):
        pivots = np.flatnonzero(matrix[row:, column])
        if not len(pivots):
            continue
        pivot = row + int(pivots[0])
        matrix[[row, pivot]] = matrix[[pivot, row]]
        matrix[row] = matrix[row] * pow(int(matrix[row, column]), -1, prime) % prime
        for other in range(matrix.shape[0]):
            if other != row and matrix[other, column]:
                matrix[other] = (
                    matrix[other] - matrix[other, column] * matrix[row]
                ) % prime
        row += 1
        if row == matrix.shape[0]:
            break
    return row


def left_inverse_coordinates(basis: list[np.ndarray], prime: int = P):
    """Return a coordinate oracle for an independent list of column vectors."""
    matrix = np.stack([entry.reshape(-1) for entry in basis], axis=1) % prime
    work = matrix.copy()
    rows = []
    rank = 0
    for column in range(work.shape[1]):
        pivot = next(
            (candidate for candidate in range(rank, work.shape[0]) if work[candidate, column]),
            None,
        )
        assert pivot is not None
        work[[rank, pivot]] = work[[pivot, rank]]
        rows.append(pivot)
        scalar = pow(int(work[rank, column]), -1, prime)
        work[rank] = work[rank] * scalar % prime
        for other in range(work.shape[0]):
            if other != rank and work[other, column]:
                work[other] = (work[other] - work[other, column] * work[rank]) % prime
        rank += 1
    assert rank == len(basis)
    square = matrix[rows, :] % prime
    inverse = inv_mod(square, prime)

    def coordinates(value: np.ndarray) -> np.ndarray:
        answer = inverse @ value.reshape(-1)[rows] % prime
        assert np.array_equal(matrix @ answer % prime, value.reshape(-1) % prime)
        return answer

    return rows, coordinates


def inv_mod(matrix: np.ndarray, prime: int = P) -> np.ndarray:
    n = matrix.shape[0]
    work = np.concatenate(
        [matrix.copy() % prime, np.eye(n, dtype=np.int64)], axis=1
    )
    for column in range(n):
        pivots = np.flatnonzero(work[column:, column])
        assert len(pivots)
        pivot = column + int(pivots[0])
        work[[column, pivot]] = work[[pivot, column]]
        work[column] = (
            work[column] * pow(int(work[column, column]), -1, prime) % prime
        )
        for row in range(n):
            if row != column and work[row, column]:
                work[row] = (work[row] - work[row, column] * work[column]) % prime
    return work[:, n:]


def skew(values, pairs, prime=P):
    result = np.zeros((6, 6), dtype=np.int64)
    for value, (left, right) in zip(values, pairs):
        result[left, right] = int(value) % prime
        result[right, left] = -int(value) % prime
    return result


def modular_projector():
    extraction = runpy.run_path(str(HERE / "extract_ambient_degree12_points.py"))
    _w, roots, vectors = extraction["parse_rur"]()
    assert roots == [1, 6, 11]
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
    assert len(seeds) == 48
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
    assert pairing == 3
    projector = -bivector @ q * pow(pairing, -1, P) % P
    q_inverse = inv_mod(q)
    assert np.array_equal(projector @ projector % P, projector)
    assert int(np.trace(projector)) % P == 2
    assert np.array_equal(q_inverse @ projector.T @ q % P, projector)
    return projector, q, domain_basis, pairs, wedge


def hilbert90_values():
    phi = runpy.run_path(str(ROOT / "tmp" / "generic_twist" / "phi_coefficients.py"))
    names, frame, _ = phi["all_coefficients"]()
    values = [
        [int(phi["evaluate"](component, POINT)) % P for component in vector]
        for vector in frame
    ]
    assert list(names) == ["x", "C", "D", "E", "K"]
    return list(names), values


def main() -> None:
    e, q, domain_basis, pairs, wedge = modular_projector()
    c3 = runpy.run_path(str(ROOT / "certificates" / "fano_c3" / "produce_c3.py"))
    c2 = c3["load_c2_helpers"]()
    frame = c2["build_projective_reynolds_frame"](P, ZETA)
    matrices = [matrix % P for matrix in frame["basis_mats"]]
    identity = np.eye(6, dtype=np.int64) % P

    # Select D=eAe.  The exact candidates are e and e M_i e.
    corner = [e]
    corner_labels = [{"kind": "projector"}]
    for index, matrix in enumerate(matrices):
        candidate = e @ matrix @ e % P
        if rank_mod([*corner, candidate]) > len(corner):
            corner.append(candidate)
            corner_labels.append({"kind": "sandwich_frame", "frame_index": index})
        if len(corner) == 4:
            break
    assert len(corner) == rank_mod(corner) == 4
    corner_rows, corner_coordinates = left_inverse_coordinates(corner)

    def sigma(value):
        return inv_mod(q) @ value.T @ q % P

    star_columns = [corner_coordinates(sigma(value)) for value in corner]
    star_matrix = np.stack(star_columns, axis=1) % P
    assert np.array_equal(star_matrix @ star_matrix % P, np.eye(4, dtype=np.int64) % P)
    corner_multiplication = []
    for left in corner:
        corner_multiplication.append(
            [[int(v) for v in corner_coordinates(left @ right % P)] for right in corner]
        )

    def corner_mul(left, right):
        answer = np.zeros(4, dtype=np.int64)
        for i, a in enumerate(left):
            for j, b in enumerate(right):
                answer += int(a) * int(b) * np.array(corner_multiplication[i][j], dtype=np.int64)
        return answer % P

    units = [np.eye(4, dtype=np.int64)[index] for index in range(4)]
    pure = [(index, (units[index] - star_matrix @ units[index]) % P) for index in range(1, 4)]
    symbol = None
    for i_index, i_coordinates in pure:
        i_square = corner_mul(i_coordinates, i_coordinates)
        if any(i_square[1:]) or not i_square[0]:
            continue
        for j_index, j0_coordinates in pure:
            if j_index == i_index:
                continue
            anticommutator = (
                corner_mul(i_coordinates, j0_coordinates)
                + corner_mul(j0_coordinates, i_coordinates)
            ) % P
            if any(anticommutator[1:]):
                continue
            scalar = anticommutator[0] * pow(2 * int(i_square[0]) % P, -1, P) % P
            j_coordinates = (j0_coordinates - scalar * i_coordinates) % P
            j_square = corner_mul(j_coordinates, j_coordinates)
            ij = corner_mul(i_coordinates, j_coordinates)
            if any(j_square[1:]) or not j_square[0]:
                continue
            if not np.array_equal(
                (corner_mul(i_coordinates, j_coordinates) + corner_mul(j_coordinates, i_coordinates)) % P,
                np.zeros(4, dtype=np.int64),
            ):
                continue
            if rank_mod([corner[0], *[
                sum((int(coordinate) * basis for coordinate, basis in zip(vector, corner)), np.zeros((6, 6), dtype=np.int64)) % P
                for vector in (i_coordinates, j_coordinates, ij)
            ]]) != 4:
                continue
            symbol = {
                "i_source_basis_index": i_index,
                "j0_source_basis_index": j_index,
                "orthogonalization_scalar_mod_23": int(scalar),
                "i_coordinates_mod_23": [int(value) for value in i_coordinates],
                "j_coordinates_mod_23": [int(value) for value in j_coordinates],
                "ij_coordinates_mod_23": [int(value) for value in ij],
                "a_mod_23": int(i_square[0]),
                "b_mod_23": int(j_square[0]),
            }
            break
        if symbol is not None:
            break
    assert symbol is not None

    # Select three generators g_r e whose right-D spans form Ae.
    g_matrices = [identity]
    g_labels = [{"kind": "identity"}]
    module_basis = [identity @ e @ d % P for d in corner]
    assert rank_mod(module_basis) == 4
    for index, matrix in enumerate(matrices):
        candidate_block = [matrix @ e @ d % P for d in corner]
        if rank_mod([*module_basis, *candidate_block]) == len(module_basis) + 4:
            g_matrices.append(matrix)
            g_labels.append({"kind": "frame", "frame_index": index})
            module_basis.extend(candidate_block)
        if len(g_matrices) == 3:
            break
    assert len(g_matrices) == 3 and rank_mod(module_basis) == 12

    # The distinguished sigma-symmetric elements S_j=Q(x)^-1 Q(V_j(x)).
    names, frame_values = hilbert90_values()
    symmetric = []
    for vector in frame_values:
        alternating = skew(domain_basis @ np.array(vector, dtype=np.int64) % P, pairs)
        element = inv_mod(q) @ alternating % P
        assert np.array_equal(sigma(element), element)
        symmetric.append(element)
    assert rank_mod(symmetric) == 5

    # H_j[r,s] = e sigma(g_r) S_j g_s e, in the selected D basis.
    hermitian = []
    for section in symmetric:
        matrix = []
        for left in g_matrices:
            row = []
            for right in g_matrices:
                entry = e @ sigma(left) @ section @ right @ e % P
                row.append([int(v) for v in corner_coordinates(entry)])
            matrix.append(row)
        hermitian.append(matrix)
    for matrix in hermitian:
        for row in range(3):
            for column in range(3):
                left = np.array(matrix[row][column], dtype=np.int64)
                right = np.array(matrix[column][row], dtype=np.int64)
                assert np.array_equal(star_matrix @ left % P, right)
    flattened_forms = [
        np.array(matrix, dtype=np.int64).reshape(-1) for matrix in hermitian
    ]
    assert rank_mod(flattened_forms) == 5

    output = {
        "format": "c2-lazy-exact-morita-v1",
        "scope": "exact C2 Morita data; not a common line and not a Fano point",
        "field": "C(P(W))^PSL_2(F_11)",
        "constant_presentation": {
            "cyclotomic_generator": "zeta11",
            "projector_parameter": "t",
            "relation_source": "ambient_degree12_rur_char0.json",
            "explanation": "C is algebraically closed, so a chosen root t is a constant already in the stated base field",
        },
        "projector_circuit": {
            "bivector": "p(x,t)=sum_i c_i(t) R_i(x), using the 48 sealed degree-12 Reynolds maps",
            "bivector_matrix": "P_ij=p_ij, P_ji=-p_ij",
            "pairing": "s=sum_{i<j} Q_ij(x) p_ij(x,t)",
            "formula": "e=-P Q/s",
            "identities": ["e^2=e", "sigma(e)=e", "reduced_rank(e)=2"],
        },
        "corner": {
            "definition": "D=e A_proj e",
            "basis_circuits": corner_labels,
            "dimension": 4,
            "multiplication": "multiply the sandwich circuits and recover four coordinates by the saved Cramer minor",
            "involution": "sigma restricted to D",
            "quaternion_symbol_circuit": {
                "i": "d_r-star(d_r), with r selected below",
                "j0": "d_s-star(d_s), with s selected below",
                "j": "j0-((i*j0+j0*i)/(2*i^2))*i",
                "a": "i^2",
                "b": "j^2",
                "relations": ["i^2=a", "j^2=b", "i*j=-j*i"],
                "selected_basis_indices": [symbol["i_source_basis_index"], symbol["j0_source_basis_index"]],
            },
        },
        "morita": {
            "module": "P=A_proj e as a right D-module",
            "right_rank": 3,
            "basis_generator_circuits": g_labels,
            "hermitian_pairing": "h(xe,ye)=e sigma(x) y e",
            "algebra_map": "A_proj -> End_D(P) by left multiplication",
        },
        "distinguished_hermitian_forms": {
            "names": names,
            "section_elements": "S_j=Q(x)^-1 Q(V_j(x)), V_j in [x,C,D,E,K]",
            "entry_formula": "H_j[r,s]=e sigma(g_r) S_j g_s e",
            "count": 5,
        },
        "good_fibre_witness": {
            "prime": P,
            "zeta11": ZETA,
            "point": list(POINT),
            "rur_root": 1,
            "pairing": 3,
            "projector_trace": int(np.trace(e) % P),
            "corner_basis_rows": corner_rows,
            "corner_basis_rank": rank_mod(corner),
            "corner_basis_values": [entry.astype(int).tolist() for entry in corner],
            "corner_star_matrix_columns": star_matrix.astype(int).tolist(),
            "corner_multiplication_left_right_coordinates": corner_multiplication,
            "quaternion_symbol": symbol,
            "morita_basis_rank": rank_mod(module_basis),
            "hermitian_matrices_D_coordinates": hermitian,
            "hermitian_span_rank": rank_mod(flattened_forms),
            "bivector": wedge.astype(int).tolist(),
        },
        "source_sha256": {
            "char0_rur": sha256(HERE / "ambient_degree12_rur_char0.json"),
            "global_pluecker": sha256(HERE / "ambient_degree12_global_exact.json"),
            "compressed_algebra": sha256(HERE.parent / "C_PFAFFIAN_FANO_CODEX_ROOT" / "compressed_algebra.json"),
            "distinguished_five_plane": sha256(HERE.parent / "C_PFAFFIAN_FANO_CODEX_ROOT" / "distinguished_five_plane.json"),
        },
        "theorem_boundary": "C2 is installed lazily; C3 still requires one right D-line common to all five matrices",
    }
    path = HERE / "c2_morita.json"
    path.write_text(json.dumps(output, indent=2) + "\n")
    print(f"cornerBasis={corner_labels} moritaGenerators={g_labels}")
    print(f"WROTE {path}")
    print("C2-MORITA-FIVE-HERMITIAN-LAZY-EXACT")


if __name__ == "__main__":
    main()
