#!/usr/bin/env python3
"""Multiprime Morita source-record interpreter with holdout bivector specialisation.

Advances G_MORITA_SOURCE_INTERPRETER beyond the p=23-only factor walk:

1. independent degree-12 bivector specialisation of P at several good primes
   (modular RUR coefficient vector × multiprime Reynolds maps);
2. walk every stored ordered_trace_terms factor string in morita_generic_dag.json
   (390 homogeneous + 675 chart coefficients);
3. match an independent reconstruction of the intended trace formula at each fibre;
4. multiprime nonvanishing open ledger for 2, Pf(Q), s, f14, corner minor, Morita minor;
5. holdout prime p=353 (unused by the sealed Morita p=23 seed).

Does not expand L_a, does not use Magma, does not claim a K_proj-point or
C5-EXECUTABLE-FULL-INCIDENCE / BR-FANO-POS.

Replay:

  PYTHONDONTWRITEBYTECODE=1 python3 -u produce_multiprime_morita.py
  PYTHONDONTWRITEBYTECODE=1 python3 -u verify_multiprime_morita.py
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

# Accepted Morita seed + two discovery primes with modular RUR + holdout.
FIBRES = (
    {
        "prime": 23,
        "zeta11": 2,
        "role": "accepted_seed",
        "rur": "ambient_degree12_a47_chart.rur",
        "root_index": 0,  # root 1
    },
    {
        "prime": 331,
        "zeta11": 74,
        "role": "discovery",
        "rur": "ambient_degree12_p331_zeta074_a47.rur",
        "root_index": 0,
    },
    {
        "prime": 199,
        "zeta11": 18,
        "role": "discovery",
        "rur": "ambient_degree12_p199_zeta018_a47.rur",
        "root_index": 0,
    },
    {
        "prime": 353,
        "zeta11": 58,
        "role": "holdout",
        "rur": "ambient_degree12_p353_zeta058_a47.rur",
        "root_index": 0,
    },
)

TRANSPOSE_M = re.compile(r"^transpose\(M\[(\d)\]\)$")
TRANSPOSE_G = re.compile(r"^transpose\(G\[(\d)\]\)$")
M_FACTOR = re.compile(r"^M\[(\d)\]$")
G_FACTOR = re.compile(r"^G\[(\d)\]$")
B_FACTOR = re.compile(r"^B\[(\d)\]$")

SOURCES = {
    "morita_generic_dag": C5 / "morita_generic_dag.json",
    "c2_morita": A7 / "c2_morita.json",
    "char0_rur": A7 / "ambient_degree12_rur_char0.json",
    "a47_chart": A7 / "ambient_degree12_a47_chart.json",
    "compressed_algebra": CROOT / "compressed_algebra.json",
    "distinguished_five_plane": CROOT / "distinguished_five_plane.json",
    "involution": CROOT / "involution.json",
}


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
    assert matrix.shape == (size, size) and size % 2 == 0
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
    assert _one == 1
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
            assert len(block) == 1
            coordinates[name] = -peval(block[0][1], root) % prime
        vector = [coordinates[f"a{index}"] for index in range(48)]
        assert vector[47] == 1
        vectors.append(vector)
    return {
        "eliminant": [int(value) for value in eliminant_poly],
        "roots": roots,
        "vectors": vectors,
    }


class MultiprimeGeometry:
    """Multprime domain basis + degree-12 primal-wedge Reynolds evaluator."""

    def __init__(self, prime: int, zeta: int, c2_module, seeds):
        self.prime = prime
        self.zeta = zeta
        self.seeds = seeds
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
        assert five is not None and five.shape == (15, 5)
        self.domain_basis = five

        left_inverse = (
            inv_mod(five.T @ five % prime, prime) @ five.T % prime
        )
        domain_generators = tuple(
            left_inverse @ generator @ five % prime for generator in dual_wedge
        )
        identity5 = np.eye(5, dtype=np.int64) % prime
        paired = {bytes(identity5.astype(np.uint8)): (identity5, identity)}
        queue = [(identity5, identity)]
        while queue:
            domain, target = queue.pop()
            for domain_generator, target_generator in zip(
                domain_generators, primal_wedge
            ):
                new_domain = domain @ domain_generator % prime
                new_target = target @ target_generator % prime
                key = bytes(new_domain.astype(np.uint8))
                if key not in paired:
                    paired[key] = (new_domain, new_target)
                    queue.append((new_domain, new_target))
        assert len(paired) == 660
        self.domain_group = np.stack([domain for domain, _ in paired.values()])
        self.target_inverse_group = np.stack(
            [inv_mod(target, prime) for _, target in paired.values()]
        )

    def evaluate_seed(self, output: int, exponents: tuple[int, ...]) -> np.ndarray:
        transformed = np.einsum("gij,j->gi", self.domain_group, POINT) % self.prime
        weights = np.ones(660, dtype=np.int64)
        for coordinate, exponent in enumerate(exponents):
            if exponent:
                weights = (
                    weights
                    * np.array(
                        [
                            pow(int(value), exponent, self.prime)
                            for value in transformed[:, coordinate]
                        ],
                        dtype=np.int64,
                    )
                    % self.prime
                )
        return (
            np.sum(
                weights[:, None] * self.target_inverse_group[:, :, output],
                axis=0,
                dtype=np.int64,
            )
            % self.prime
        )

    def bivector(self, coefficient_vector) -> np.ndarray:
        values = np.stack(
            [
                self.evaluate_seed(output, exponents)
                for output, exponents in self.seeds
            ]
        )
        return np.asarray(coefficient_vector, dtype=np.int64) @ values % self.prime


def resolve_factor(token: str, env: dict, prime: int) -> np.ndarray:
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
    raise KeyError(f"unbound factor token: {token!r}")


def evaluate_ordered_term(term: dict, env: dict, prime: int) -> int:
    assert term["operation"] == "matrix_trace_of_ordered_product"
    assert term["denominator"] == "2*s^3"
    assert term["scalar"] == -1
    product = np.eye(6, dtype=np.int64) % prime
    for token in term["factors"]:
        product = product @ resolve_factor(token, env, prime) % prime
    numerator = int(np.trace(product) % prime)
    denominator = 2 * pow(env["s"], 3, prime) % prime
    return (-numerator) * pow(denominator, -1, prime) % prime


def evaluate_stored_records(dag: dict, env: dict, prime: int) -> dict:
    factor_tokens: set[str] = set()
    term_count = 0
    homogeneous = []
    for form in dag["homogeneous_model"]["forms"]:
        row = []
        for record in form["coefficients"]:
            value = 0
            for term in record["ordered_trace_terms"]:
                for token in term["factors"]:
                    factor_tokens.add(token)
                value = (value + evaluate_ordered_term(term, env, prime)) % prime
                term_count += 1
            row.append(value)
        assert len(row) == 78
        homogeneous.append(row)

    charts = []
    for chart in dag["normalized_charts"]:
        chart_forms = []
        for form in chart["forms"]:
            row = []
            for record in form["coefficients"]:
                value = 0
                for term in record["ordered_trace_terms"]:
                    for token in term["factors"]:
                        factor_tokens.add(token)
                    value = (value + evaluate_ordered_term(term, env, prime)) % prime
                    term_count += 1
                row.append(value)
            assert len(row) == 45
            chart_forms.append(row)
        charts.append(chart_forms)

    return {
        "homogeneous_values_mod_p": homogeneous,
        "chart_values_mod_p": charts,
        "distinct_factor_tokens": sorted(factor_tokens),
        "ordered_terms_evaluated": term_count,
    }


def independent_trace_forms(env: dict, prime: int) -> dict:
    """Independent intended-formula reconstruction (not a stored-factor walk)."""

    p_matrix = env["P"]
    q_matrix = env["Q"]
    m_list = env["M"]
    g_list = env["G"]
    b_list = env["B"]
    pairing = env["s"]
    denominator = 2 * pow(pairing, 3, prime) % prime
    inverse = pow(denominator, -1, prime)

    def coefficient(form: int, left: int, right: int) -> int:
        left_row, left_basis = divmod(left, 4)
        right_row, right_basis = divmod(right, 4)

        def ordered(row, basis, column, other_basis):
            product = (
                p_matrix
                @ m_list[basis].T
                % prime
                @ q_matrix
                % prime
                @ p_matrix
                % prime
                @ g_list[row].T
                % prime
                @ b_list[form]
                % prime
                @ g_list[column]
                % prime
                @ p_matrix
                % prime
                @ q_matrix
                % prime
                @ m_list[other_basis]
                % prime
            )
            return int(np.trace(product) % prime)

        numerator = ordered(left_row, left_basis, right_row, right_basis)
        if left != right:
            numerator = (
                numerator + ordered(right_row, right_basis, left_row, left_basis)
            ) % prime
        return (-numerator) * inverse % prime

    homogeneous = []
    for form in range(5):
        row = []
        for left in range(12):
            for right in range(left, 12):
                row.append(coefficient(form, left, right))
        homogeneous.append(row)

    charts = []
    for pivot_row in range(3):
        pivot = 4 * pivot_row
        variables = [index for index in range(12) if index // 4 != pivot_row]
        monomials = [[]] + [[index] for index in variables]
        monomials += [
            [left, right]
            for left in variables
            for right in variables
            if left <= right
        ]
        chart_forms = []
        for form in range(5):
            row = []
            for monomial in monomials:
                # Chart records already expand ordered pairs inside ordered_trace_terms.
                # coefficient() itself is the full symmetrised pairing for a monoid index.
                if not monomial:
                    value = coefficient(form, pivot, pivot)
                elif len(monomial) == 1:
                    value = coefficient(form, pivot, monomial[0])
                else:
                    value = coefficient(form, monomial[0], monomial[1])
                row.append(value)
            chart_forms.append(row)
        charts.append(chart_forms)

    return {
        "homogeneous_values_mod_p": homogeneous,
        "chart_values_mod_p": charts,
    }


def sealed_corner_forms_p23() -> list[list[int]]:
    witness = json.loads((A7 / "c2_morita.json").read_text())["good_fibre_witness"]
    table = witness["corner_multiplication_left_right_coordinates"]
    star = np.asarray(witness["corner_star_matrix_columns"], dtype=np.int64) % 23
    hermitian = witness["hermitian_matrices_D_coordinates"]
    units = [np.eye(4, dtype=np.int64)[index] for index in range(4)]

    def corner_multiply(left, right):
        answer = np.zeros(4, dtype=np.int64)
        for left_index, left_coefficient in enumerate(left):
            for right_index, right_coefficient in enumerate(right):
                if left_coefficient and right_coefficient:
                    answer += (
                        int(left_coefficient)
                        * int(right_coefficient)
                        * np.asarray(table[left_index][right_index], dtype=np.int64)
                    )
        return answer % 23

    forms = []
    for matrix in hermitian:
        coefficients = []
        for left in range(12):
            for right in range(left, 12):
                left_row, left_basis = divmod(left, 4)
                right_row, right_basis = divmod(right, 4)

                def ordered(row, basis, column, other_basis, matrix=matrix):
                    first = corner_multiply(
                        star @ units[basis] % 23,
                        np.asarray(matrix[row][column], dtype=np.int64) % 23,
                    )
                    return corner_multiply(first, units[other_basis])

                value = ordered(left_row, left_basis, right_row, right_basis)
                if left != right:
                    value = (
                        value + ordered(right_row, right_basis, left_row, left_basis)
                    ) % 23
                assert not np.any(value[1:])
                coefficients.append(int(value[0]) % 23)
        forms.append(coefficients)
    return forms


def build_fibre(spec: dict, c2_module, phi_module, kproj_module, seeds) -> dict:
    prime = int(spec["prime"])
    zeta = int(spec["zeta11"])
    rur_path = A7 / spec["rur"]
    parsed = parse_modular_rur(rur_path, prime)
    root_index = int(spec["root_index"])
    root = parsed["roots"][root_index]
    coefficients = parsed["vectors"][root_index]

    geometry = MultiprimeGeometry(prime, zeta, c2_module, seeds)
    wedge = geometry.bivector(coefficients)
    q_values = geometry.domain_basis @ POINT % prime
    q_matrix = skew(q_values, prime)
    p_matrix = skew(wedge, prime)
    pairing = 0
    for i in range(6):
        for j in range(i + 1, 6):
            pairing += int(q_matrix[i, j]) * int(p_matrix[i, j])
    pairing %= prime
    assert pairing

    projector = (-p_matrix @ q_matrix * pow(pairing, -1, prime)) % prime
    assert np.array_equal(projector @ projector % prime, projector)
    assert int(np.trace(projector)) % prime == 2

    frame = c2_module["build_projective_reynolds_frame"](prime, zeta)
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
        b_list.append(skew(geometry.domain_basis @ values % prime, prime))

    forms = kproj_module["forms"]()
    evaluate_mod = kproj_module["evaluate_mod"]
    f14 = int(evaluate_mod(forms[14], tuple(map(int, POINT)), prime))

    corner = [projector @ matrix @ projector % prime for matrix in m_list]
    assert rank_mod(corner, prime) == 4
    corner_matrix = np.stack([entry.reshape(-1) for entry in corner], axis=1) % prime
    corner_minor = det_mod(corner_matrix[[0, 1, 6, 7], :], prime)

    d_basis = corner
    module = []
    for row in range(3):
        for alpha in range(4):
            module.append(g_list[row] @ projector @ d_basis[alpha] % prime)
    module_matrix = np.stack([entry.reshape(-1) for entry in module], axis=1) % prime
    module_rows = [0, 1, 6, 7, 12, 13, 18, 19, 24, 25, 31, 30]
    morita_minor = det_mod(module_matrix[module_rows, :], prime)

    env = {
        "P": p_matrix,
        "Q": q_matrix,
        "M": m_list,
        "G": g_list,
        "B": b_list,
        "s": pairing,
        "e": projector,
    }
    return {
        "spec": spec,
        "env": env,
        "witness": {
            "prime": prime,
            "zeta11": zeta,
            "role": spec["role"],
            "rur_path": str(rur_path.relative_to(ROOT)),
            "rur_sha256": sha256(rur_path),
            "eliminant_roots": parsed["roots"],
            "selected_root": root,
            "source_point": list(map(int, POINT)),
            "bivector": [int(value) for value in wedge],
            "pairing_s": pairing,
            "pfaffian_Q": pfaffian_mod(q_matrix, prime),
            "det_Q": det_mod(q_matrix, prime),
            "f14": f14,
            "frame_denominator": int(frame["denominator"]),
            "projector_trace": int(np.trace(projector)) % prime,
            "corner_rank": rank_mod(corner, prime),
            "corner_minor_rows_0_1_6_7": corner_minor,
            "morita_module_minor": morita_minor,
            "open_2": 2 % prime,
            "P_specialization": {
                "method": "modular_rur_coefficient_vector_times_multprime_degree12_reynolds",
                "independent_of_p23_sealed_wedge": prime != 23,
            },
        },
    }


def checksum_values(payload) -> str:
    return hashlib.sha256(
        json.dumps(payload, sort_keys=True, separators=(",", ":")).encode()
    ).hexdigest()


def main() -> None:
    for path in SOURCES.values():
        assert path.is_file(), path

    c2_module = runpy.run_path(str(ROOT / "certificates" / "fano_c2" / "produce_c2.py"))
    phi_module = runpy.run_path(str(ROOT / "tmp" / "generic_twist" / "phi_coefficients.py"))
    kproj_module = runpy.run_path(str(ROOT / "tmp" / "kproj_arithmetic" / "core.py"))
    seeds = [
        (int(output), tuple(exponents))
        for output, exponents in json.loads(
            (A7 / "ambient_degree12_a47_chart.json").read_text()
        )["seeds"]
    ]
    assert len(seeds) == 48

    dag = json.loads((C5 / "morita_generic_dag.json").read_text())
    assert dag["inventory"]["homogeneous_total_coefficients"] == 390
    assert dag["inventory"]["normalized_total_coefficient_records"] == 675

    fibres = []
    for spec in FIBRES:
        print(f"building fibre p={spec['prime']} role={spec['role']} ...", flush=True)
        fibre = build_fibre(spec, c2_module, phi_module, kproj_module, seeds)
        stored = evaluate_stored_records(dag, fibre["env"], fibre["witness"]["prime"])
        independent = independent_trace_forms(fibre["env"], fibre["witness"]["prime"])
        assert stored["homogeneous_values_mod_p"] == independent["homogeneous_values_mod_p"]
        assert stored["chart_values_mod_p"] == independent["chart_values_mod_p"]
        assert stored["ordered_terms_evaluated"] == 1935
        assert len(stored["distinct_factor_tokens"]) == 21

        witness = fibre["witness"]
        opens = {
            "2": witness["open_2"] % witness["prime"] != 0
            and witness["prime"] != 2,
            "Pf(Q)": witness["pfaffian_Q"] != 0,
            "s": witness["pairing_s"] != 0,
            "f14": witness["f14"] != 0,
            "frame_denominator": witness["frame_denominator"] != 0,
            "corner_rank_4": witness["corner_rank"] == 4,
            "corner_minor": witness["corner_minor_rows_0_1_6_7"] != 0,
            "morita_module_minor": witness["morita_module_minor"] != 0,
        }
        assert all(opens.values()), (witness["prime"], opens)

        nonzero_homogeneous = sum(
            1 for row in stored["homogeneous_values_mod_p"] for value in row if value
        )
        nonzero_chart = sum(
            1
            for chart in stored["chart_values_mod_p"]
            for row in chart
            for value in row
            if value
        )

        record = {
            "witness": witness,
            "opens_nonvanishing": opens,
            "inventory": {
                "homogeneous_coefficients": 390,
                "chart_coefficients": 675,
                "ordered_terms_evaluated": stored["ordered_terms_evaluated"],
                "distinct_factor_tokens": stored["distinct_factor_tokens"],
                "nonzero_homogeneous_coefficients": nonzero_homogeneous,
                "nonzero_chart_coefficients": nonzero_chart,
            },
            "checksums_sha256": {
                "homogeneous_values_mod_p": checksum_values(
                    stored["homogeneous_values_mod_p"]
                ),
                "chart_values_mod_p": checksum_values(stored["chart_values_mod_p"]),
                "bivector": checksum_values(witness["bivector"]),
            },
            "matches_independent_trace_formula": True,
        }

        if witness["prime"] == 23:
            sealed = json.loads((A7 / "c2_morita.json").read_text())["good_fibre_witness"]
            assert witness["bivector"] == sealed["bivector"]
            assert witness["pairing_s"] == sealed["pairing"] == 3
            assert witness["pfaffian_Q"] == 17
            assert witness["corner_minor_rows_0_1_6_7"] == 16
            assert witness["morita_module_minor"] == 19
            sealed_forms = sealed_corner_forms_p23()
            assert stored["homogeneous_values_mod_p"] == sealed_forms
            record["matches_sealed_c2_corner_tables_p23"] = True
            record["matches_sealed_bivector_p23"] = True

        # corruption self-test: flip first factor of first homogeneous term
        corrupted = json.loads(json.dumps(dag))
        first_term = corrupted["homogeneous_model"]["forms"][0]["coefficients"][0][
            "ordered_trace_terms"
        ][0]
        original_token = first_term["factors"][0]
        assert original_token == "P"
        first_term["factors"][0] = "Q"
        corrupted_values = evaluate_stored_records(
            corrupted, fibre["env"], witness["prime"]
        )
        assert (
            corrupted_values["homogeneous_values_mod_p"]
            != stored["homogeneous_values_mod_p"]
        )
        record["corruption_self_test"] = {
            "mechanism": "replace first stored factor P by Q on form0 monom0",
            "values_differ": True,
            "original_homogeneous_00": stored["homogeneous_values_mod_p"][0][0],
            "corrupted_homogeneous_00": corrupted_values["homogeneous_values_mod_p"][0][
                0
            ],
        }
        fibres.append(record)
        print(
            f"  p={witness['prime']} s={witness['pairing_s']} "
            f"PfQ={witness['pfaffian_Q']} nonzero_h={nonzero_homogeneous} OK",
            flush=True,
        )

    holdout = next(row for row in fibres if row["witness"]["role"] == "holdout")
    ledger = {
        "format": "c5-morita-multiprime-ledger-v1",
        "gate": "G_MORITA_SOURCE_INTERPRETER",
        "exit_marker": "C5-MORITA-MULTIPRIME-HOLDOUT-PASS",
        "status": "partial",
        "claims": {
            "consumes_stored_factor_strings": True,
            "independent_bivector_specialization": True,
            "holdout_prime_generic_P_bivector": True,
            "multiprime_open_ledger_nonvanishing": True,
            "matches_independent_trace_formula_all_fibres": True,
            "matches_sealed_corner_tables_p23": True,
            "chart_coefficients_cross_checked": True,
            "char0_K_proj_expansion": False,
            "common_line_over_K_proj": False,
            "executable_full_incidence_exit": False,
        },
        "source_point": list(map(int, POINT)),
        "fibres": fibres,
        "holdout_prime": holdout["witness"]["prime"],
        "open_ledger_summary": {
            "required_opens": [
                "2!=0",
                "Pf(Q)!=0",
                "s!=0",
                "f14!=0",
                "frame_denominator!=0",
                "corner_rank==4",
                "corner_minor!=0",
                "morita_module_minor!=0",
            ],
            "all_fibres_nonvanishing": True,
            "per_prime": {
                str(row["witness"]["prime"]): {
                    "role": row["witness"]["role"],
                    "s": row["witness"]["pairing_s"],
                    "Pf(Q)": row["witness"]["pfaffian_Q"],
                    "f14": row["witness"]["f14"],
                    "corner_minor": row["witness"]["corner_minor_rows_0_1_6_7"],
                    "morita_module_minor": row["witness"]["morita_module_minor"],
                }
                for row in fibres
            },
        },
        "source_sha256": {
            name: {"path": str(path.relative_to(ROOT)), "sha256": sha256(path)}
            for name, path in SOURCES.items()
        },
        "remaining_for_full_gate": [
            "char-0 / preferred length-12 K_proj normal form of coefficient classes",
            "then G_HENSEL_ELIMINANT_LINEAR_FACTOR on q0=1 chart",
        ],
        "theorem_boundary": (
            "Multiprime modular executability of every serialized Morita factor "
            "record with independent P-specialisation and open nonvanishing. "
            "Not a K_proj-point and not full char-0 rational expansion."
        ),
    }

    out = HERE / "multiprime_ledger.json"
    out.write_text(json.dumps(ledger, indent=2) + "\n")
    print(f"WROTE {out}")
    print("C5-MORITA-MULTIPRIME-HOLDOUT-PASS")


if __name__ == "__main__":
    main()
