#!/usr/bin/env python3
"""Independent replay of the bounded C5 descent-compatible ansatz audit.

The default invocation reruns every finite computation, including all
3,612,280 degree-17 supports of size four.  ``--max-support`` is provided for
fast smoke tests; only the default value 4 verifies the complete certificate.
"""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
import re
import runpy
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
CERTIFICATE = HERE / "descent_compatible_ansatz_audit.json"
P = 23


def check(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as source:
        while block := source.read(1024 * 1024):
            digest.update(block)
    return digest.hexdigest()


def rank_mod(matrix: np.ndarray, prime: int = P) -> int:
    reduced = np.asarray(matrix, dtype=np.int64).copy() % prime
    rows, columns = reduced.shape
    pivot_row = 0
    for column in range(columns):
        candidates = np.flatnonzero(reduced[pivot_row:, column])
        if not len(candidates):
            continue
        row = pivot_row + int(candidates[0])
        reduced[[pivot_row, row]] = reduced[[row, pivot_row]]
        reduced[pivot_row] *= pow(int(reduced[pivot_row, column]), -1, prime)
        reduced[pivot_row] %= prime
        for other in range(rows):
            if other != pivot_row and reduced[other, column]:
                reduced[other] -= reduced[other, column] * reduced[pivot_row]
                reduced[other] %= prime
        pivot_row += 1
        if pivot_row == rows:
            break
    return pivot_row


def inverse_mod(matrix: np.ndarray, prime: int = P) -> np.ndarray:
    matrix = np.asarray(matrix, dtype=np.int64) % prime
    size = matrix.shape[0]
    check(matrix.shape == (size, size), "inverse requested for nonsquare matrix")
    augmented = np.concatenate(
        (matrix.copy(), np.eye(size, dtype=np.int64)), axis=1
    )
    for column in range(size):
        candidates = np.flatnonzero(augmented[column:, column])
        check(bool(len(candidates)), "singular matrix")
        row = column + int(candidates[0])
        augmented[[column, row]] = augmented[[row, column]]
        augmented[column] *= pow(int(augmented[column, column]), -1, prime)
        augmented[column] %= prime
        for other in range(size):
            if other != column and augmented[other, column]:
                augmented[other] -= augmented[other, column] * augmented[column]
                augmented[other] %= prime
    return augmented[:, size:] % prime


def skew(vector: np.ndarray, pairs: tuple[tuple[int, int], ...]) -> np.ndarray:
    result = np.zeros((6, 6), dtype=np.int64)
    for coefficient, (left, right) in zip(vector, pairs):
        result[left, right] = int(coefficient)
        result[right, left] = -int(coefficient)
    return result % P


def verify_hashes(certificate: dict) -> None:
    for relative, expected in certificate["sources"].items():
        path = ROOT / relative
        check(path.is_file(), f"missing pinned source: {relative}")
        actual = sha256(path)
        check(actual == expected, f"hash mismatch for {relative}: {actual}")
    print("SOURCE HASHES PASS")


class AcceptedModel:
    """Reconstruct the accepted p=23 Morita data from upstream sources."""

    def __init__(self, certificate: dict):
        sources = certificate["sources"]
        full_wedge_path = next(
            ROOT / name for name in sources if name.endswith("full_wedge.py")
        )
        phi_path = next(
            ROOT / name for name in sources if name.endswith("phi_coefficients.py")
        )
        points_path = next(
            ROOT / name
            for name in sources
            if name.endswith("ambient_degree12_points_p23.json")
        )
        chart_path = next(
            ROOT / name
            for name in sources
            if name.endswith("ambient_degree12_a47_chart.json")
        )

        full_wedge = runpy.run_path(str(full_wedge_path))
        self.fano = full_wedge["fano"]
        self.scanner = full_wedge["FullWedgeScanner"]()
        self.pairs = tuple(self.fano["PAIRS"])

        six = self.fano["six_dimensional_generators"]()
        dual = tuple(self.fano["inv"](generator).T % P for generator in six)
        dual_wedge = tuple(
            self.fano["exterior_square"](generator) for generator in dual
        )
        self.domain_basis, _ = self.fano["invariant_summands"](dual_wedge)
        check(self.domain_basis.shape == (15, 5), "unexpected five-space basis")

        points_data = json.loads(points_path.read_text(encoding="utf-8"))
        chart_data = json.loads(chart_path.read_text(encoding="utf-8"))
        self.root_vector = np.asarray(
            points_data["checks"][0]["coefficient_vector"], dtype=np.int64
        )
        self.seeds = tuple(
            (int(output), tuple(int(value) for value in exponents))
            for output, exponents in chart_data["seeds"]
        )
        check(len(self.root_vector) == len(self.seeds) == 48, "degree-12 mismatch")

        self.phi = runpy.run_path(str(phi_path))
        _, self.frame, _ = self.phi["all_coefficients"]()
        check(len(self.frame) == 5, "unexpected Hilbert frame")
        self.cache: dict[tuple[int, ...], tuple[np.ndarray, tuple[np.ndarray, ...]]] = {}

    def context(self, coordinates: tuple[int, ...]):
        if coordinates in self.cache:
            return self.cache[coordinates]
        point = np.asarray(coordinates, dtype=np.int64) % P
        q_vector = self.domain_basis @ point % P
        q = skew(q_vector, self.pairs)
        check(rank_mod(q) == 6, f"singular q at {coordinates}")
        q_inverse = inverse_mod(q)

        ambient = np.stack(
            [
                self.scanner.evaluate_seed(output, exponents, point)
                for output, exponents in self.seeds
            ]
        )
        wedge = self.root_vector @ ambient % P
        pairing = int(q_vector @ wedge % P)
        check(pairing != 0, f"zero degree-12 pairing at {coordinates}")
        e0 = -skew(wedge, self.pairs) @ q * pow(pairing, -1, P) % P
        check(np.array_equal(e0 @ e0 % P, e0), f"non-idempotent e0 at {coordinates}")
        check(rank_mod(e0) == 2, f"wrong rank e0 at {coordinates}")
        check(np.array_equal(q_inverse @ e0.T @ q % P, e0), f"e0 not self-adjoint")

        sections = []
        for vector in self.frame:
            values = np.asarray(
                [self.phi["evaluate"](component, point) % P for component in vector],
                dtype=np.int64,
            )
            section = q_inverse @ skew(self.domain_basis @ values % P, self.pairs) % P
            check(
                np.array_equal(q_inverse @ section.T @ q % P, section),
                f"section not self-adjoint at {coordinates}",
            )
            sections.append(section)
        check(
            np.array_equal(sections[0], np.eye(6, dtype=np.int64)),
            f"S0 is not the identity at {coordinates}",
        )
        result = e0, tuple(sections)
        self.cache[coordinates] = result
        return result


def words_through_length(maximum: int) -> list[tuple[int, ...]]:
    return [()] + [
        word
        for length in range(1, maximum + 1)
        for word in itertools.product(range(1, 5), repeat=length)
    ]


def word_matrices(
    sections: tuple[np.ndarray, ...], words: list[tuple[int, ...]]
) -> np.ndarray:
    matrices = []
    for word in words:
        matrix = np.eye(6, dtype=np.int64)
        for letter in word:
            matrix = matrix @ sections[letter] % P
        matrices.append(matrix)
    return np.stack(matrices)


def sigma_batch(matrices: np.ndarray, q: np.ndarray) -> np.ndarray:
    q_inverse = inverse_mod(q)
    return np.einsum("ij,akj,kl->ail", q_inverse, matrices, q) % P


def q_from_sections(sections: tuple[np.ndarray, ...]) -> np.ndarray:
    """Recover q up to scalar from S0 construction is unnecessary; caller stores it.

    This helper is deliberately unused.  The verifier computes sigma(g) from
    sigma(g)=easily reversed words, avoiding dependence on a recovered q.
    """
    raise AssertionError("unused")


def sigma_words(
    sections: tuple[np.ndarray, ...], words: list[tuple[int, ...]]
) -> np.ndarray:
    """Because each S_i is self-adjoint, sigma reverses every word."""
    return word_matrices(sections, [tuple(reversed(word)) for word in words])


def verify_short_words(model: AcceptedModel, certificate: dict) -> None:
    data = certificate["descent_compatible_word_ansatz"]["short_word_screen"]
    words = words_through_length(int(data["maximum_word_length"]))
    check(len(words) == data["word_count"] == 341, "short-word count mismatch")
    left, right = np.asarray(
        list(itertools.combinations(range(len(words)), 2)), dtype=np.int64
    ).T
    constants = np.arange(1, P, dtype=np.int64)
    constants_squared = constants * constants % P
    pair_alive = np.ones((len(left), P - 1), dtype=bool)
    single_alive = np.ones(len(words), dtype=bool)
    coordinates_used = 0

    for fibre in map(tuple, data["fibres"]):
        e0, sections = model.context(fibre)
        matrices = word_matrices(sections, words)
        adjoints = sigma_words(sections, words)
        right_factors = np.einsum("aij,jk->aik", matrices, e0) % P
        for section in sections:
            left_factors = np.einsum(
                "ij,ajk,kl->ail", e0, adjoints, section
            ) % P
            for row in range(6):
                for column in range(6):
                    bilinear = (
                        left_factors[:, row, :] @ right_factors[:, :, column].T
                    ) % P
                    diagonal = np.diag(bilinear).copy()
                    cross = (bilinear + bilinear.T) % P
                    single_alive &= diagonal == 0
                    values = (
                        diagonal[left, None]
                        + constants[None, :] * cross[left, right, None]
                        + constants_squared[None, :] * diagonal[right, None]
                    ) % P
                    pair_alive &= values == 0
                    coordinates_used += 1
                    if not np.any(single_alive) and not np.any(pair_alive):
                        break
                if not np.any(single_alive) and not np.any(pair_alive):
                    break
            if not np.any(single_alive) and not np.any(pair_alive):
                break
        if not np.any(single_alive) and not np.any(pair_alive):
            break

    single_survivors = int(np.count_nonzero(single_alive))
    pair_survivors = int(np.count_nonzero(pair_alive))
    check(single_survivors == data["single_word_survivors"] == 0, "single survivor")
    check(pair_survivors == data["two_word_scalar_survivors"] == 0, "pair survivor")
    check(len(left) * (P - 1) == data["two_word_scalar_tests"], "pair count")
    print(
        "SHORT WORDS PASS:",
        len(words),
        "single and",
        len(left) * (P - 1),
        "two-word tests;",
        coordinates_used,
        "residual coordinates suffice",
    )


def verify_twelve_word_rank(model: AcceptedModel, certificate: dict) -> None:
    data = certificate["descent_compatible_word_ansatz"][
        "constant_twelve_word_screen"
    ]
    words = [tuple(word) for word in data["basis_words"]]
    coefficient_pairs = tuple(itertools.combinations_with_replacement(range(12), 2))
    check(len(words) == 12 and len(coefficient_pairs) == 78, "word-basis size")
    all_rows: list[np.ndarray] = []
    cumulative = []
    module_rank = None

    for fibre_index, fibre in enumerate(map(tuple, data["fibres"])):
        e0, sections = model.context(fibre)
        matrices = word_matrices(sections, words)
        adjoints = sigma_words(sections, words)
        if fibre_index == 0:
            module_rank = rank_mod(
                np.stack([(matrix @ e0 % P).reshape(-1) for matrix in matrices])
            )
        for section in sections:
            coefficient_matrices = []
            for left, right in coefficient_pairs:
                if left == right:
                    value = e0 @ adjoints[left] @ section @ matrices[left] @ e0
                else:
                    value = e0 @ (
                        adjoints[left] @ section @ matrices[right]
                        + adjoints[right] @ section @ matrices[left]
                    ) @ e0
                coefficient_matrices.append(value % P)
            block = np.stack(coefficient_matrices).transpose(1, 2, 0).reshape(36, 78)
            all_rows.extend(block)
        cumulative.append(rank_mod(np.stack(all_rows)))

    check(module_rank == data["primary_fibre_module_rank"] == 12, "module rank")
    check(cumulative == data["cumulative_quadratic_ranks"], f"ranks {cumulative}")
    check(cumulative[-1] == data["final_quadratic_rank"] == 78, "final rank")
    print("TWELVE-WORD RANK PASS:", cumulative)


TERM = re.compile(r"^(?:(\d+)\*)?a(\d+)(?:\^2|\*a(\d+))$")


def parse_degree17(path: Path) -> tuple[np.ndarray, np.ndarray]:
    pairs = tuple(
        (left, right) for left in range(98) for right in range(left, 98)
    )
    pair_index = {pair: index for index, pair in enumerate(pairs)}
    rows = []
    with path.open(encoding="utf-8") as source:
        variables = next(source).strip().split(",")
        check(variables == [f"a{index}" for index in range(98)], "variable header")
        check(int(next(source)) == P, "degree-17 prime")
        for line_number, line in enumerate(source, start=3):
            polynomial = line.strip().rstrip(",")
            check(bool(polynomial), f"empty polynomial at line {line_number}")
            row = np.zeros(len(pairs), dtype=np.int16)
            for term in polynomial.split("+"):
                match = TERM.match(term)
                check(match is not None, f"bad term at line {line_number}: {term}")
                coefficient = int(match.group(1) or 1) % P
                left = int(match.group(2))
                right = int(match.group(3)) if match.group(3) else left
                if right < left:
                    left, right = right, left
                column = pair_index[(left, right)]
                row[column] = (int(row[column]) + coefficient) % P
            rows.append(row)
    return np.stack(rows), np.asarray(pairs, dtype=np.int16)


def full_column_rank_batch(matrices: np.ndarray) -> np.ndarray:
    """Exact vectorized full-column-rank test for B x 10 x m, m <= 10."""
    work = np.asarray(matrices, dtype=np.int64).copy() % P
    batch, rows, columns = work.shape
    check(columns <= rows, "projection has fewer rows than columns")
    good = np.ones(batch, dtype=bool)
    inverses = np.zeros(P, dtype=np.int64)
    inverses[1:] = [pow(value, -1, P) for value in range(1, P)]
    indices = np.arange(batch)
    for column in range(columns):
        nonzero = work[:, column:, column] != 0
        has_pivot = np.any(nonzero, axis=1)
        good &= has_pivot
        pivot_rows = column + np.argmax(nonzero, axis=1)
        old_pivot = work[:, column, :].copy()
        work[:, column, :] = work[indices, pivot_rows, :]
        work[indices, pivot_rows, :] = old_pivot
        scales = inverses[work[:, column, column]]
        work[:, column, column:] *= scales[:, None]
        work[:, column, column:] %= P
        for row in range(column + 1, rows):
            factors = work[:, row, column].copy()
            work[:, row, column:] -= factors[:, None] * work[:, column, column:]
            work[:, row, column:] %= P
    return good


def support_batches(size: int, batch_size: int = 10_000):
    iterator = itertools.combinations(range(98), size)
    while batch := list(itertools.islice(iterator, batch_size)):
        yield np.asarray(batch, dtype=np.int16)


def verify_degree17(certificate: dict, maximum_support: int) -> None:
    data = certificate["degree17_sparse_support"]
    input_path = next(
        ROOT / name
        for name in certificate["sources"]
        if name.endswith("degree17_fano_p23.in")
    )
    equations, pairs = parse_degree17(input_path)
    check(equations.shape == (1597, 4851), f"degree-17 shape {equations.shape}")
    check(data["landing_equation_rank"] == 1597, "recorded landing rank")

    pair_index = np.empty((98, 98), dtype=np.int64)
    for column, (left, right) in enumerate(pairs):
        pair_index[left, right] = pair_index[right, left] = column

    projection = data["projection_certificate"]
    rng = np.random.default_rng(int(projection["seed"]))
    random_maps = rng.integers(
        0,
        P,
        size=(int(projection["projection_count"]), int(projection["projection_rows"]), 1597),
        dtype=np.int64,
    )
    equations64 = equations.astype(np.int64)
    projected = np.stack([mapping @ equations64 % P for mapping in random_maps])

    for support_size in range(1, maximum_support + 1):
        monomial_positions = tuple(
            itertools.combinations_with_replacement(range(support_size), 2)
        )
        required_rank = support_size * (support_size + 1) // 2
        deficient = 0
        checked = 0
        for supports in support_batches(support_size):
            checked += len(supports)
            columns = np.stack(
                [
                    pair_index[supports[:, left], supports[:, right]]
                    for left, right in monomial_positions
                ],
                axis=1,
            )
            unresolved = np.ones(len(supports), dtype=bool)
            for block in projected:
                active = np.flatnonzero(unresolved)
                if not len(active):
                    break
                matrices = block[:, columns[active]].transpose(1, 0, 2)
                certified = full_column_rank_batch(matrices)
                unresolved[active[certified]] = False
            for index in np.flatnonzero(unresolved):
                if rank_mod(equations[:, columns[index]]) < required_rank:
                    deficient += 1
        expected_count = int(data["support_counts"][str(support_size)])
        expected_deficient = int(data["deficient_support_counts"][str(support_size)])
        check(checked == expected_count, f"support count {support_size}: {checked}")
        check(deficient == expected_deficient == 0, f"deficient size {support_size}")
        check(required_rank == data["required_restricted_ranks"][str(support_size)], "rank")
        print(
            f"DEGREE-17 SUPPORT {support_size} PASS:",
            checked,
            "supports, 0 deficient",
        )


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--max-support",
        type=int,
        choices=range(1, 5),
        default=4,
        help="largest degree-17 support size to replay (default: complete audit, 4)",
    )
    parser.add_argument(
        "--skip-short-words",
        action="store_true",
        help="skip the 1,275,340 short-word tests (smoke testing only)",
    )
    arguments = parser.parse_args()

    certificate = json.loads(CERTIFICATE.read_text(encoding="utf-8"))
    check(certificate["format"] == "c5-descent-compatible-ansatz-audit-v1", "format")
    check(certificate["prime"] == P and certificate["zeta11"] == 2, "field")
    verify_hashes(certificate)
    model = AcceptedModel(certificate)
    verify_twelve_word_rank(model, certificate)
    if not arguments.skip_short_words:
        verify_short_words(model, certificate)
    verify_degree17(certificate, arguments.max_support)
    completeness = (
        arguments.max_support == 4 and not arguments.skip_short_words
    )
    if completeness:
        print("ALL CHECKS PASS -- BOUNDED AUDIT ONLY; NO ALL-DEGREE VERDICT")
    else:
        print("SMOKE TEST PASS -- exhaustive certificate replay was intentionally reduced")


if __name__ == "__main__":
    main()
