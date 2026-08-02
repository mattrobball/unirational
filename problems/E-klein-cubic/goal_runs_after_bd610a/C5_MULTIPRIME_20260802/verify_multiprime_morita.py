#!/usr/bin/env python3
"""Independent verifier for the multiprime Morita holdout ledger.

Does not import produce_multiprime_morita.py.  Rebuilds each fibre's P,Q,frame,B_i
from sealed modular RUR + multiprime Reynolds/Hilbert-90 data, walks every stored
ordered_trace_terms factor list, matches the independent intended trace formula,
checks the multiprime open ledger, and confirms the p=23 fibre against sealed
c2_morita corner tables.
"""

from __future__ import annotations

import ast
import hashlib
import json
import re
import runpy
from itertools import combinations
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
C5 = ROOT / "goals_after_bd610a" / "C5_PROJECTOR_INCIDENCE"
A7 = ROOT / "goals_2026-08-01" / "C_PFAFFIAN_FANO_CODEX_ROOT_20260801_A7C3"
CROOT = ROOT / "goals_2026-08-01" / "C_PFAFFIAN_FANO_CODEX_ROOT"

PAIRS = tuple(combinations(range(6), 2))
POINT = np.array([1, 2, 3, 4, 5], dtype=np.int64)

TRANSPOSE_M = re.compile(r"^transpose\(M\[(\d)\]\)$")
TRANSPOSE_G = re.compile(r"^transpose\(G\[(\d)\]\)$")
M_FACTOR = re.compile(r"^M\[(\d)\]$")
G_FACTOR = re.compile(r"^G\[(\d)\]$")
B_FACTOR = re.compile(r"^B\[(\d)\]$")


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def inv_mod(matrix: np.ndarray, prime: int) -> np.ndarray:
    matrix = np.asarray(matrix, dtype=np.int64) % prime
    size = matrix.shape[0]
    work = np.concatenate((matrix.copy(), np.eye(size, dtype=np.int64)), axis=1)
    for column in range(size):
        candidates = np.flatnonzero(work[column:, column])
        assert len(candidates)
        pivot = column + int(candidates[0])
        work[[column, pivot]] = work[[pivot, column]]
        work[column] = work[column] * pow(int(work[column, column]), -1, prime) % prime
        for row in range(size):
            if row != column and work[row, column]:
                work[row] = (work[row] - work[row, column] * work[column]) % prime
    return work[:, size:] % prime


def det_mod(matrix: np.ndarray, prime: int) -> int:
    work = np.asarray(matrix, dtype=np.int64).copy() % prime
    answer = 1
    for column in range(work.shape[0]):
        candidates = np.flatnonzero(work[column:, column])
        if not len(candidates):
            return 0
        pivot = column + int(candidates[0])
        if pivot != column:
            work[[column, pivot]] = work[[pivot, column]]
            answer = -answer
        value = int(work[column, column]) % prime
        answer = answer * value % prime
        work[column] = work[column] * pow(value, -1, prime) % prime
        for row in range(column + 1, work.shape[0]):
            if work[row, column]:
                work[row] = (work[row] - work[row, column] * work[column]) % prime
    return answer % prime


def pfaffian_mod(matrix: np.ndarray, prime: int) -> int:
    matrix = np.asarray(matrix, dtype=np.int64) % prime
    size = matrix.shape[0]
    if size == 0:
        return 1
    answer = 0
    for column in range(1, size):
        keep = [index for index in range(1, size) if index != column]
        sign = 1 if column % 2 else -1
        answer += (
            sign
            * int(matrix[0, column])
            * pfaffian_mod(matrix[np.ix_(keep, keep)], prime)
        )
    return answer % prime


def rank_mod(columns: list[np.ndarray], prime: int) -> int:
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


def nullspace_mod(matrix: np.ndarray, prime: int) -> np.ndarray:
    reduced = np.asarray(matrix, dtype=np.int64).copy() % prime
    rows, columns = reduced.shape
    pivots: list[int] = []
    pivot_row = 0
    for column in range(columns):
        candidates = np.flatnonzero(reduced[pivot_row:, column])
        if not len(candidates):
            continue
        row = pivot_row + int(candidates[0])
        reduced[[pivot_row, row]] = reduced[[row, pivot_row]]
        reduced[pivot_row] = (
            reduced[pivot_row] * pow(int(reduced[pivot_row, column]), -1, prime) % prime
        )
        for other in range(rows):
            if other != pivot_row and reduced[other, column]:
                reduced[other] = (
                    reduced[other] - reduced[other, column] * reduced[pivot_row]
                ) % prime
        pivots.append(column)
        pivot_row += 1
        if pivot_row == rows:
            break
    free = [column for column in range(columns) if column not in pivots]
    basis = np.zeros((columns, len(free)), dtype=np.int64)
    for basis_column, free_column in enumerate(free):
        basis[free_column, basis_column] = 1
        for index, pivot_column in enumerate(pivots):
            basis[pivot_column, basis_column] = (-reduced[index, free_column]) % prime
    return basis


def exterior_square(generator: np.ndarray, prime: int) -> np.ndarray:
    matrix = np.zeros((15, 15), dtype=np.int64)
    for right, (a, b) in enumerate(PAIRS):
        left_a = generator[:, a] % prime
        left_b = generator[:, b] % prime
        for left, (c, d) in enumerate(PAIRS):
            matrix[left, right] = (
                int(left_a[c]) * int(left_b[d]) - int(left_a[d]) * int(left_b[c])
            ) % prime
    return matrix


def skew(values, prime: int) -> np.ndarray:
    answer = np.zeros((6, 6), dtype=np.int64)
    for value, (left, right) in zip(values, PAIRS):
        answer[left, right] = int(value) % prime
        answer[right, left] = -int(value) % prime
    return answer % prime


def parse_modular_rur(path: Path, expected_prime: int):
    data = ast.literal_eval(path.read_text().strip().rstrip(":"))
    assert data[0] == 0
    prime, nvars, degree, names, _linear, tail = data[1]
    assert prime == expected_prime and nvars == 48 and degree == 3
    _one, (eliminant, _denominator, coordinate_blocks) = tail
    eliminant_poly = eliminant[1]

    def peval(coefficients, value):
        return sum(
            int(coefficient) * pow(value, exponent, prime)
            for exponent, coefficient in enumerate(coefficients)
        ) % prime

    roots = [value for value in range(prime) if peval(eliminant_poly, value) == 0]
    vectors = []
    for root in roots:
        coordinates = {names[-1]: root}
        for name, block in zip(names[:-1], coordinate_blocks):
            coordinates[name] = -peval(block[0][1], root) % prime
        vectors.append([coordinates[f"a{index}"] for index in range(48)])
    return roots, vectors


def domain_and_reynolds(prime: int, zeta: int, c2_module, seeds):
    six = c2_module["schur_generators"](prime, zeta)
    dual = tuple(inv_mod(generator, prime).T % prime for generator in six)
    dual_wedge = tuple(exterior_square(generator, prime) for generator in dual)
    primal_wedge = tuple(exterior_square(generator, prime) for generator in six)

    identity = np.eye(15, dtype=np.int64) % prime
    seen = {bytes(identity.astype(np.uint8)): identity}
    queue = [identity]
    while queue:
        element = queue.pop()
        for generator in dual_wedge:
            product = element @ generator % prime
            key = bytes(product.astype(np.uint8))
            if key not in seen:
                seen[key] = product
                queue.append(product)
    group = list(seen.values())
    assert len(group) == 660
    inverses = [inv_mod(element, prime) for element in group]

    five = None
    candidate_evals = {0, 1, prime - 1, 660 % prime, (660 // 2) % prime, 2, 3, 4, 5}
    for diagonal in range(15):
        seed = np.zeros((15, 15), dtype=np.int64)
        seed[diagonal, diagonal] = 1
        commuting = np.zeros((15, 15), dtype=np.int64)
        for element, element_inverse in zip(group, inverses):
            commuting = (commuting + element @ seed @ element_inverse) % prime
        for eigenvalue in candidate_evals:
            space = nullspace_mod(
                commuting - eigenvalue * np.eye(15, dtype=np.int64) % prime, prime
            )
            if space.shape[1] == 5:
                five = space
                break
        if five is not None:
            break
    assert five is not None

    left_inverse = inv_mod(five.T @ five % prime, prime) @ five.T % prime
    domain_generators = tuple(
        left_inverse @ generator @ five % prime for generator in dual_wedge
    )
    identity5 = np.eye(5, dtype=np.int64) % prime
    paired = {bytes(identity5.astype(np.uint8)): (identity5, identity)}
    queue = [(identity5, identity)]
    while queue:
        domain, target = queue.pop()
        for domain_generator, target_generator in zip(domain_generators, primal_wedge):
            new_domain = domain @ domain_generator % prime
            new_target = target @ target_generator % prime
            key = bytes(new_domain.astype(np.uint8))
            if key not in paired:
                paired[key] = (new_domain, new_target)
                queue.append((new_domain, new_target))
    assert len(paired) == 660
    domain_group = np.stack([domain for domain, _ in paired.values()])
    target_inverse = np.stack([inv_mod(target, prime) for _, target in paired.values()])

    values = []
    for output, exponents in seeds:
        transformed = np.einsum("gij,j->gi", domain_group, POINT) % prime
        weights = np.ones(660, dtype=np.int64)
        for coordinate, exponent in enumerate(exponents):
            if exponent:
                weights = (
                    weights
                    * np.array(
                        [
                            pow(int(value), exponent, prime)
                            for value in transformed[:, coordinate]
                        ],
                        dtype=np.int64,
                    )
                    % prime
                )
        values.append(
            np.sum(
                weights[:, None] * target_inverse[:, :, output],
                axis=0,
                dtype=np.int64,
            )
            % prime
        )
    return five, np.stack(values)


def resolve(token: str, env: dict, prime: int) -> np.ndarray:
    if token == "P":
        return env["P"]
    if token == "Q":
        return env["Q"]
    match = TRANSPOSE_M.match(token)
    if match:
        return env["M"][int(match.group(1))].T % prime
    match = TRANSPOSE_G.match(token)
    if match:
        return env["G"][int(match.group(1))].T % prime
    match = M_FACTOR.match(token)
    if match:
        return env["M"][int(match.group(1))]
    match = G_FACTOR.match(token)
    if match:
        return env["G"][int(match.group(1))]
    match = B_FACTOR.match(token)
    if match:
        return env["B"][int(match.group(1))]
    raise KeyError(token)


def walk_term(term: dict, env: dict, prime: int) -> int:
    product = np.eye(6, dtype=np.int64) % prime
    for token in term["factors"]:
        product = product @ resolve(token, env, prime) % prime
    numerator = int(np.trace(product) % prime)
    denominator = 2 * pow(env["s"], 3, prime) % prime
    return (-numerator) * pow(denominator, -1, prime) % prime


def walk_dag(dag: dict, env: dict, prime: int):
    homogeneous = []
    tokens = set()
    term_count = 0
    for form in dag["homogeneous_model"]["forms"]:
        row = []
        for record in form["coefficients"]:
            value = 0
            for term in record["ordered_trace_terms"]:
                tokens.update(term["factors"])
                value = (value + walk_term(term, env, prime)) % prime
                term_count += 1
            row.append(value)
        homogeneous.append(row)
    charts = []
    for chart in dag["normalized_charts"]:
        chart_forms = []
        for form in chart["forms"]:
            row = []
            for record in form["coefficients"]:
                value = 0
                for term in record["ordered_trace_terms"]:
                    tokens.update(term["factors"])
                    value = (value + walk_term(term, env, prime)) % prime
                    term_count += 1
                row.append(value)
            chart_forms.append(row)
        charts.append(chart_forms)
    return homogeneous, charts, sorted(tokens), term_count


def independent_homogeneous(env: dict, prime: int) -> list[list[int]]:
    den_inv = pow(2 * pow(env["s"], 3, prime) % prime, -1, prime)
    forms = []
    for form in range(5):
        row = []
        for left in range(12):
            for right in range(left, 12):
                left_row, left_basis = divmod(left, 4)
                right_row, right_basis = divmod(right, 4)

                def ordered(r, a, s, b):
                    product = (
                        env["P"]
                        @ env["M"][a].T
                        % prime
                        @ env["Q"]
                        % prime
                        @ env["P"]
                        % prime
                        @ env["G"][r].T
                        % prime
                        @ env["B"][form]
                        % prime
                        @ env["G"][s]
                        % prime
                        @ env["P"]
                        % prime
                        @ env["Q"]
                        % prime
                        @ env["M"][b]
                        % prime
                    )
                    return int(np.trace(product) % prime)

                numerator = ordered(left_row, left_basis, right_row, right_basis)
                if left != right:
                    numerator = (
                        numerator + ordered(right_row, right_basis, left_row, left_basis)
                    ) % prime
                row.append((-numerator) * den_inv % prime)
        forms.append(row)
    return forms


def sealed_corner_forms() -> list[list[int]]:
    witness = json.loads((A7 / "c2_morita.json").read_text())["good_fibre_witness"]
    table = witness["corner_multiplication_left_right_coordinates"]
    star = np.asarray(witness["corner_star_matrix_columns"], dtype=np.int64) % 23
    hermitian = witness["hermitian_matrices_D_coordinates"]
    units = [np.eye(4, dtype=np.int64)[index] for index in range(4)]

    def corner_multiply(left, right):
        answer = np.zeros(4, dtype=np.int64)
        for i, a in enumerate(left):
            for j, b in enumerate(right):
                if a and b:
                    answer += int(a) * int(b) * np.asarray(table[i][j], dtype=np.int64)
        return answer % 23

    forms = []
    for matrix in hermitian:
        coefficients = []
        for left in range(12):
            for right in range(left, 12):
                lr, lb = divmod(left, 4)
                rr, rb = divmod(right, 4)

                def ordered(row, basis, col, other, matrix=matrix):
                    first = corner_multiply(
                        star @ units[basis] % 23,
                        np.asarray(matrix[row][col], dtype=np.int64) % 23,
                    )
                    return corner_multiply(first, units[other])

                value = ordered(lr, lb, rr, rb)
                if left != right:
                    value = (value + ordered(rr, rb, lr, lb)) % 23
                assert not np.any(value[1:])
                coefficients.append(int(value[0]) % 23)
        forms.append(coefficients)
    return forms


def checksum(payload) -> str:
    return hashlib.sha256(
        json.dumps(payload, sort_keys=True, separators=(",", ":")).encode()
    ).hexdigest()


def rebuild_fibre(row: dict, c2_module, phi_module, kproj_module, seeds, dag: dict):
    witness = row["witness"]
    prime = int(witness["prime"])
    zeta = int(witness["zeta11"])
    rur_path = ROOT / witness["rur_path"]
    assert sha256(rur_path) == witness["rur_sha256"]
    roots, vectors = parse_modular_rur(rur_path, prime)
    assert roots == witness["eliminant_roots"]
    root = witness["selected_root"]
    root_index = roots.index(root)
    coefficients = vectors[root_index]

    domain_basis, reynolds = domain_and_reynolds(prime, zeta, c2_module, seeds)
    wedge = np.asarray(coefficients, dtype=np.int64) @ reynolds % prime
    assert [int(value) for value in wedge] == witness["bivector"]

    q_matrix = skew(domain_basis @ POINT % prime, prime)
    p_matrix = skew(wedge, prime)
    pairing = 0
    for i in range(6):
        for j in range(i + 1, 6):
            pairing += int(q_matrix[i, j]) * int(p_matrix[i, j])
    pairing %= prime
    assert pairing == witness["pairing_s"]
    assert pfaffian_mod(q_matrix, prime) == witness["pfaffian_Q"]

    projector = (-p_matrix @ q_matrix * pow(pairing, -1, prime)) % prime
    assert np.array_equal(projector @ projector % prime, projector)
    assert int(np.trace(projector)) % prime == witness["projector_trace"] == 2

    frame = c2_module["build_projective_reynolds_frame"](prime, zeta)
    assert int(frame["denominator"]) == witness["frame_denominator"]
    matrices = [value % prime for value in frame["basis_mats"]]
    identity = np.eye(6, dtype=np.int64) % prime
    m_list = [identity, matrices[1], matrices[2], matrices[3]]
    g_list = [identity, matrices[1], matrices[2]]

    names, hilbert, _ = phi_module["all_coefficients"]()
    assert list(names) == ["x", "C", "D", "E", "K"]
    b_list = []
    for vector in hilbert:
        values = np.array(
            [
                int(phi_module["evaluate"](component, tuple(map(int, POINT)))) % prime
                for component in vector
            ],
            dtype=np.int64,
        )
        b_list.append(skew(domain_basis @ values % prime, prime))

    forms = kproj_module["forms"]()
    f14 = int(kproj_module["evaluate_mod"](forms[14], tuple(map(int, POINT)), prime))
    assert f14 == witness["f14"]

    corner = [projector @ matrix @ projector % prime for matrix in m_list]
    assert rank_mod(corner, prime) == 4 == witness["corner_rank"]
    corner_matrix = np.stack([entry.reshape(-1) for entry in corner], axis=1) % prime
    assert det_mod(corner_matrix[[0, 1, 6, 7], :], prime) == witness[
        "corner_minor_rows_0_1_6_7"
    ]

    module = [
        g_list[row] @ projector @ corner[alpha] % prime
        for row in range(3)
        for alpha in range(4)
    ]
    module_matrix = np.stack([entry.reshape(-1) for entry in module], axis=1) % prime
    module_rows = [0, 1, 6, 7, 12, 13, 18, 19, 24, 25, 31, 30]
    assert det_mod(module_matrix[module_rows, :], prime) == witness["morita_module_minor"]

    env = {
        "P": p_matrix,
        "Q": q_matrix,
        "M": m_list,
        "G": g_list,
        "B": b_list,
        "s": pairing,
    }
    homogeneous, charts, tokens, term_count = walk_dag(dag, env, prime)
    independent = independent_homogeneous(env, prime)
    assert homogeneous == independent
    assert term_count == 1935
    assert len(tokens) == 21
    assert checksum(homogeneous) == row["checksums_sha256"]["homogeneous_values_mod_p"]
    assert checksum(charts) == row["checksums_sha256"]["chart_values_mod_p"]
    assert checksum(witness["bivector"]) == row["checksums_sha256"]["bivector"]
    assert all(row["opens_nonvanishing"].values())

    # corruption self-test
    corrupted = json.loads(json.dumps(dag))
    corrupted["homogeneous_model"]["forms"][0]["coefficients"][0]["ordered_trace_terms"][
        0
    ]["factors"][0] = "Q"
    corrupted_homogeneous, _, _, _ = walk_dag(corrupted, env, prime)
    assert corrupted_homogeneous != homogeneous
    assert (
        corrupted_homogeneous[0][0]
        == row["corruption_self_test"]["corrupted_homogeneous_00"]
    )

    if prime == 23:
        sealed = json.loads((A7 / "c2_morita.json").read_text())["good_fibre_witness"]
        assert witness["bivector"] == sealed["bivector"]
        assert homogeneous == sealed_corner_forms()

    return True


def main() -> None:
    ledger_path = HERE / "multiprime_ledger.json"
    ledger = json.loads(ledger_path.read_text())
    assert ledger["format"] == "c5-morita-multiprime-ledger-v1"
    assert ledger["exit_marker"] == "C5-MORITA-MULTIPRIME-HOLDOUT-PASS"
    assert ledger["holdout_prime"] == 353
    assert ledger["claims"]["holdout_prime_generic_P_bivector"] is True
    assert ledger["claims"]["executable_full_incidence_exit"] is False
    assert ledger["claims"]["common_line_over_K_proj"] is False

    for name, record in ledger["source_sha256"].items():
        path = ROOT / record["path"]
        assert path.is_file(), path
        assert sha256(path) == record["sha256"], name

    dag_path = C5 / "morita_generic_dag.json"
    assert sha256(dag_path) == ledger["source_sha256"]["morita_generic_dag"]["sha256"]
    dag = json.loads(dag_path.read_text())

    c2_module = runpy.run_path(str(ROOT / "certificates" / "fano_c2" / "produce_c2.py"))
    phi_module = runpy.run_path(str(ROOT / "tmp" / "generic_twist" / "phi_coefficients.py"))
    kproj_module = runpy.run_path(str(ROOT / "tmp" / "kproj_arithmetic" / "core.py"))
    seeds = [
        (int(output), tuple(exponents))
        for output, exponents in json.loads(
            (A7 / "ambient_degree12_a47_chart.json").read_text()
        )["seeds"]
    ]

    roles = {row["witness"]["role"] for row in ledger["fibres"]}
    assert "holdout" in roles and "accepted_seed" in roles
    assert ledger["open_ledger_summary"]["all_fibres_nonvanishing"] is True

    for row in ledger["fibres"]:
        prime = row["witness"]["prime"]
        print(f"verify p={prime} role={row['witness']['role']} ...", flush=True)
        rebuild_fibre(row, c2_module, phi_module, kproj_module, seeds, dag)
        print(f"  PASS p={prime}", flush=True)

    print("PASS multiprime stored-factor walks match independent trace formula")
    print("PASS holdout p=353 independent bivector specialisation")
    print("PASS open ledger nonvanishing at all fibres")
    print("PASS sealed p=23 bivector and corner Hermitian tables")
    print("PASS corruption of a stored factor string changes values")
    print("SCOPE multiprime modular executability; no K_proj point")
    print("C5-MORITA-MULTIPRIME-HOLDOUT-PASS")


if __name__ == "__main__":
    main()
