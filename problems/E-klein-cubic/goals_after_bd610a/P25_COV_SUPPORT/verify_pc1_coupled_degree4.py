#!/usr/bin/env python3
"""Independent replay of the coupled PC.1 degree-four certificate.

This verifier does not import ``produce_pc1_coupled_degree4``.  It rebuilds
the universal commutator path graph, a canonical 105-cycle basis, the formal
transition and commutator rows, and the selected non-pure-q restriction from
the sealed finite-presentation tensors.  The stored 2,297-row pure-q kernel
witness is checked against those rebuilt objects before it is used to
recompute the coupled residual.  Final ranks are obtained with FLINT nmod,
independently of the producer's FFLAS-FFPACK paths.

The theorem is only an exact degree-four statement over F_89.  It is not a
stabilization, regularity, support, or characteristic-zero certificate.
"""

from __future__ import annotations

import hashlib
from itertools import combinations_with_replacement
import json
from pathlib import Path
import shlex
import struct
import subprocess
from typing import Iterable

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
FINITE = ROOT / "certificates" / "degree25_finite_module"
RELATION = FINITE / "relation_matrix.npz"
MULTIPLICATION = FINITE / "multiplication_matrices.npz"
REWRITE = FINITE / "rewrite_rules.npz"
PC0_KERNEL = HERE / "pc0_multiplication_kernel.npz"
PC0_CERTIFICATE = HERE / "pc0_rank_certificate.json"
PRODUCER_SCRIPT = HERE / "produce_pc1_coupled_degree4.py"
PRODUCER_RESULT = HERE / "pc1_coupled_degree4.json"
PRODUCER_ARTIFACT = HERE / "pc1_coupled_degree4_certificate.npz"
OUTPUT = HERE / "verify_pc1_coupled_degree4_result.json"

P = 89
NQ, NK, NQUAD = 37, 6, 21
NSEED, NW, NV = 690, 56, 746
NOLD = NQ * NSEED
NTRANS = NK * NSEED
NCOMM_RAW, NCOMM_BASIS, NCOMM_CYCLES = 315, 210, 105
NEXTRA = NTRANS + NCOMM_BASIS
NCANDIDATE = NOLD + NEXTRA
FORMAL_W = NQ * NW
FORMAL_KERNEL = NEXTRA - FORMAL_W
MU_KERNEL_DIMENSION = 19
PURE_Q_KERNEL = FORMAL_KERNEL + MU_KERNEL_DIMENSION
NONPURE_F4 = 69597


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 22):
            digest.update(block)
    return digest.hexdigest()


def sha256_array(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def weak_compositions(total: int, slots: int) -> list[tuple[int, ...]]:
    output: list[tuple[int, ...]] = []

    def visit(prefix: tuple[int, ...], remaining: int, left: int) -> None:
        if left == 1:
            output.append(prefix + (remaining,))
            return
        for exponent in range(remaining + 1):
            visit(prefix + (exponent,), remaining - exponent, left - 1)

    visit((), total, slots)
    return output


def order_basis() -> tuple[list[tuple[int, ...]], np.ndarray]:
    basis = [tuple([0] * NK)]
    for variable in range(NK):
        exponent = [0] * NK
        exponent[variable] = 1
        basis.append(tuple(exponent))
    for left, right in combinations_with_replacement(range(NK), 2):
        exponent = [0] * NK
        exponent[left] += 1
        exponent[right] += 1
        basis.append(tuple(exponent))
    assert len(basis) == 28
    return basis, np.asarray([sum(exponent) for exponent in basis], dtype=np.int8)


class UnionFind:
    def __init__(self, size: int) -> None:
        self.parent = list(range(size))
        self.rank = [0] * size

    def find(self, value: int) -> int:
        while self.parent[value] != value:
            self.parent[value] = self.parent[self.parent[value]]
            value = self.parent[value]
        return value

    def union(self, left: int, right: int) -> bool:
        left_root, right_root = self.find(left), self.find(right)
        if left_root == right_root:
            return False
        if self.rank[left_root] < self.rank[right_root]:
            left_root, right_root = right_root, left_root
        self.parent[right_root] = left_root
        if self.rank[left_root] == self.rank[right_root]:
            self.rank[left_root] += 1
        return True


def universal_commutator_graph() -> tuple[
    np.ndarray, np.ndarray, np.ndarray, np.ndarray
]:
    """Return incidence, labels, lexicographic forest, and a cycle basis."""

    basis, degrees = order_basis()
    quadratics = [basis[index] for index in np.flatnonzero(degrees == 2)]
    cubics = weak_compositions(3, NK)
    cubic_index = {monomial: index for index, monomial in enumerate(cubics)}
    node_count = NK * len(cubics)
    incidence = np.zeros((NCOMM_RAW, node_count), dtype=np.uint8)
    labels: list[tuple[int, int, int]] = []
    endpoints: list[tuple[int, int]] = []
    for left in range(NK):
        for right in range(left + 1, NK):
            for source, quadratic in enumerate(quadratics):
                right_cubic = list(quadratic)
                right_cubic[right] += 1
                left_cubic = list(quadratic)
                left_cubic[left] += 1
                first = left * len(cubics) + cubic_index[tuple(right_cubic)]
                second = right * len(cubics) + cubic_index[tuple(left_cubic)]
                row = len(labels)
                incidence[row, first] = 1
                incidence[row, second] = P - 1
                labels.append((left, right, source))
                endpoints.append((first, second))
    assert len(labels) == NCOMM_RAW and node_count == 336

    forest = UnionFind(node_count)
    tree_rows: list[int] = []
    cycle_rows: list[int] = []
    adjacency: list[list[tuple[int, int]]] = [[] for _ in range(node_count)]
    for edge, (first, second) in enumerate(endpoints):
        if forest.union(first, second):
            tree_rows.append(edge)
            adjacency[first].append((second, edge))
            adjacency[second].append((first, edge))
        else:
            cycle_rows.append(edge)
    component_count = len({forest.find(node) for node in range(node_count)})
    assert (component_count, len(tree_rows), len(cycle_rows)) == (126, 210, 105)

    cycles = np.zeros((NCOMM_RAW, NCOMM_CYCLES), dtype=np.uint8)
    for cycle_column, extra_edge in enumerate(cycle_rows):
        first, second = endpoints[extra_edge]
        # The extra edge contributes first-second.  The tree path from second
        # to first contributes second-first, so their sum is zero.
        predecessor: dict[int, tuple[int, int]] = {second: (-1, -1)}
        queue = [second]
        for node in queue:
            if node == first:
                break
            for neighbor, tree_edge in adjacency[node]:
                if neighbor not in predecessor:
                    predecessor[neighbor] = (node, tree_edge)
                    queue.append(neighbor)
        assert first in predecessor
        cycles[extra_edge, cycle_column] = 1
        node = first
        while node != second:
            previous, tree_edge = predecessor[node]
            edge_first, edge_second = endpoints[tree_edge]
            # Traversal is previous -> node and should contribute previous-node.
            coefficient = 1 if (edge_first, edge_second) == (previous, node) else P - 1
            cycles[tree_edge, cycle_column] = coefficient
            node = previous
    product = incidence.T.astype(np.int64) @ cycles.astype(np.int64) % P
    assert not np.any(product)
    return (
        incidence,
        np.asarray(labels, dtype=np.int16),
        np.asarray(tree_rows, dtype=np.int32),
        cycles,
    )


SparseBasis = dict[int, dict[int, int]]


def reduce_sparse(row: np.ndarray, basis: SparseBasis) -> dict[int, int]:
    current = {int(index): int(row[index]) for index in np.flatnonzero(row)}
    while current:
        pivot = min(current)
        reducer = basis.get(pivot)
        if reducer is None:
            break
        coefficient = current[pivot]
        for column, value in reducer.items():
            replacement = (current.get(column, 0) - coefficient * value) % P
            if replacement:
                current[column] = replacement
            else:
                current.pop(column, None)
    return current


def sparse_row_profile(matrix: np.ndarray) -> tuple[np.ndarray, SparseBasis]:
    basis: SparseBasis = {}
    profile: list[int] = []
    for row_index, row in enumerate(matrix):
        remainder = reduce_sparse(row, basis)
        if not remainder:
            continue
        pivot = min(remainder)
        inverse = pow(remainder[pivot], -1, P)
        if inverse != 1:
            remainder = {
                column: value * inverse % P for column, value in remainder.items()
            }
        basis[pivot] = remainder
        profile.append(row_index)
    return np.asarray(profile, dtype=np.int32), basis


def rows_in_basis(rows: Iterable[np.ndarray], basis: SparseBasis) -> bool:
    return all(not reduce_sparse(row, basis) for row in rows)


FLINT_SOURCE = r"""
#include <cstdint>
#include <fstream>
#include <iostream>
#include <stdexcept>
#include <vector>
#include <flint/nmod_mat.h>

template <class T>
void read_exact(std::ifstream& input, T* target, std::size_t count) {
    input.read(reinterpret_cast<char*>(target),
               static_cast<std::streamsize>(count * sizeof(T)));
    if (!input) throw std::runtime_error("short input");
}

int main(int argc, char** argv) {
    if (argc != 2) return 2;
    std::ifstream input(argv[1], std::ios::binary);
    if (!input) throw std::runtime_error("cannot open matrix");
    std::uint64_t rows = 0, columns = 0, prime = 0;
    read_exact(input, &rows, 1);
    read_exact(input, &columns, 1);
    read_exact(input, &prime, 1);
    std::vector<std::uint8_t> data(static_cast<std::size_t>(rows * columns));
    read_exact(input, data.data(), data.size());
    nmod_mat_t matrix;
    nmod_mat_init(matrix, static_cast<slong>(rows), static_cast<slong>(columns),
                  static_cast<ulong>(prime));
    for (std::uint64_t row = 0; row < rows; ++row)
        for (std::uint64_t column = 0; column < columns; ++column)
            nmod_mat_entry(matrix, static_cast<slong>(row), static_cast<slong>(column)) =
                data[static_cast<std::size_t>(row * columns + column)];
    const slong rank = nmod_mat_rank(matrix);
    nmod_mat_clear(matrix);
    flint_cleanup_master();
    std::cout << "rank=" << rank << "\n";
    return 0;
}
"""


def compile_flint_ranker(scratch: Path) -> Path:
    source = scratch / "verify_rank_u8_flint.cpp"
    binary = scratch / "verify_rank_u8_flint"
    source.write_text(FLINT_SOURCE)
    flags = shlex.split(
        subprocess.check_output(["pkg-config", "--cflags", "--libs", "flint"], text=True).strip()
    )
    subprocess.run(
        ["clang++", "-O3", "-std=c++17", str(source), "-o", str(binary), *flags],
        check=True,
    )
    return binary


def flint_rank(binary: Path, scratch: Path, name: str, matrix: np.ndarray) -> int:
    matrix = np.ascontiguousarray(matrix, dtype=np.uint8)
    path = scratch / f"{name}.bin"
    with path.open("wb") as handle:
        handle.write(struct.pack("<QQQ", matrix.shape[0], matrix.shape[1], P))
        handle.write(matrix.tobytes())
    run = subprocess.run([str(binary), str(path)], check=True, text=True, capture_output=True)
    rank = int(run.stdout.strip().split("=", 1)[1])
    print(f"  FLINT {name}: shape={matrix.shape} rank={rank}", flush=True)
    return rank


def formal_sources(
    seeds: np.ndarray, offsets3: np.ndarray, tquad: np.ndarray
) -> tuple[np.ndarray, np.ndarray, np.ndarray, np.ndarray, np.ndarray]:
    pure_tail = np.ascontiguousarray(
        tquad[:, :, offsets3[0] : offsets3[1]].reshape(NK * NQUAD, -1),
        dtype=np.uint8,
    )
    w = np.ascontiguousarray(np.unique(pure_tail, axis=0), dtype=np.uint8)
    assert w.shape == (NW, 9139)
    lookup = {row.tobytes(): index for index, row in enumerate(w)}
    tail_to_w = np.zeros((NK * NQUAD, NW), dtype=np.uint8)
    for row, vector in enumerate(pure_tail):
        tail_to_w[row, lookup[vector.tobytes()]] = 1
    tail_to_w = tail_to_w.reshape(NK, NQUAD, NW)

    quadratic_coefficients = np.stack(
        [seeds[:, offsets3[7 + block] : offsets3[8 + block]] for block in range(NQUAD)],
        axis=1,
    ).astype(np.uint8)
    transition_blocks = []
    for operator in range(NK):
        block = (
            quadratic_coefficients.transpose(0, 2, 1).astype(np.int64)
            @ tail_to_w[operator].astype(np.int64)
        ) % P
        transition_blocks.append(
            np.ascontiguousarray(block.reshape(NSEED, FORMAL_W), dtype=np.uint8)
        )
    transitions = np.ascontiguousarray(np.vstack(transition_blocks), dtype=np.uint8)

    quadratic_action = np.empty((NK, NQUAD, NQUAD, NQ), dtype=np.uint8)
    for operator in range(NK):
        for source in range(NQUAD):
            for target in range(NQUAD):
                quadratic_action[operator, source, target] = tquad[
                    operator,
                    source,
                    offsets3[7 + target] : offsets3[8 + target],
                ]
    commutators = []
    for left in range(NK):
        for right in range(left + 1, NK):
            for source in range(NQUAD):
                first = (
                    quadratic_action[right, source].T.astype(np.int64)
                    @ tail_to_w[left].astype(np.int64)
                )
                second = (
                    quadratic_action[left, source].T.astype(np.int64)
                    @ tail_to_w[right].astype(np.int64)
                )
                commutators.append(
                    np.ascontiguousarray((first - second) % P, dtype=np.uint8).reshape(-1)
                )
    return (
        transitions,
        np.ascontiguousarray(np.vstack(commutators), dtype=np.uint8),
        quadratic_coefficients,
        w,
        tail_to_w,
    )


def verify_path_inputs(
    tquad: np.ndarray, rule_exponents: np.ndarray, rule_tails: np.ndarray
) -> tuple[np.ndarray, str]:
    basis, degrees = order_basis()
    quadratics = [basis[index] for index in np.flatnonzero(degrees == 2)]
    rules = {
        tuple(map(int, exponent)): np.ascontiguousarray(
            (-tail.astype(np.int16)) % P, dtype=np.uint8
        )
        for exponent, tail in zip(rule_exponents, rule_tails, strict=True)
    }
    assert len(rules) == 56
    ordered_rules = np.ascontiguousarray(
        np.vstack([rules[monomial] for monomial in weak_compositions(3, NK)]),
        dtype=np.uint8,
    )
    matched = []
    for left in range(NK):
        for right in range(left + 1, NK):
            for source, quadratic in enumerate(quadratics):
                right_cubic = list(quadratic)
                right_cubic[right] += 1
                left_cubic = list(quadratic)
                left_cubic[left] += 1
                assert np.array_equal(tquad[right, source], rules[tuple(right_cubic)])
                assert np.array_equal(tquad[left, source], rules[tuple(left_cubic)])
                matched.extend([tquad[right, source], tquad[left, source]])
    return ordered_rules, sha256_array(np.ascontiguousarray(np.vstack(matched), dtype=np.uint8))


def selected_labels(
    selected: np.ndarray, bdeg: np.ndarray
) -> tuple[np.ndarray, list[tuple[int, int, tuple[int, ...]]], dict[int, list[tuple[int, ...]]], dict[int, dict[tuple[int, ...], int]]]:
    monomials = {degree: weak_compositions(degree, NQ) for degree in range(5)}
    monomials[0] = [tuple([0] * NQ)]
    indices = {
        degree: {monomial: index for index, monomial in enumerate(monomials[degree])}
        for degree in range(5)
    }
    offsets4 = [0]
    for degree in bdeg:
        offsets4.append(offsets4[-1] + len(monomials[4 - int(degree)]))
    offsets4_array = np.asarray(offsets4, dtype=np.int32)
    assert (int(offsets4_array[1]), int(offsets4_array[-1])) == (91390, 160987)
    labels = []
    for local in selected:
        absolute = int(offsets4_array[1]) + int(local)
        component = int(np.searchsorted(offsets4_array, absolute, side="right") - 1)
        monomial_index = absolute - int(offsets4_array[component])
        labels.append(
            (
                component,
                monomial_index,
                monomials[4 - int(bdeg[component])][monomial_index],
            )
        )
    return offsets4_array, labels, monomials, indices


def apply_operator_selected(
    vectors: np.ndarray,
    operator: int,
    offsets3: np.ndarray,
    bdeg: np.ndarray,
    low_target: np.ndarray,
    tquad: np.ndarray,
    labels: list[tuple[int, int, tuple[int, ...]]],
    monomials: dict[int, list[tuple[int, ...]]],
    indices: dict[int, dict[tuple[int, ...], int]],
) -> np.ndarray:
    """Apply one sealed T operator to a batch of F3 vectors on selected F4 coordinates."""

    batch = np.ascontiguousarray(vectors, dtype=np.uint8)
    quadratic = np.stack(
        [batch[:, offsets3[7 + source] : offsets3[8 + source]] for source in range(NQUAD)],
        axis=1,
    ).reshape(len(batch), NQUAD * NQ)
    hmap = np.zeros((NQUAD * NQ, len(labels)), dtype=np.uint8)
    direct = np.zeros((len(batch), len(labels)), dtype=np.uint8)
    units = monomials[1]
    for column, (target, _monomial_index, exponent) in enumerate(labels):
        for source in range(7):
            if int(low_target[operator, source]) == target:
                source_index = int(offsets3[source]) + indices[3 - int(bdeg[source])][exponent]
                direct[:, column] = (
                    direct[:, column].astype(np.uint16)
                    + batch[:, source_index].astype(np.uint16)
                ) % P
        tail_degree = 3 - int(bdeg[target])
        for unit_index, unit in enumerate(units):
            variable = next(index for index, value in enumerate(unit) if value)
            if not exponent[variable]:
                continue
            predecessor = list(exponent)
            predecessor[variable] -= 1
            tail_index = int(offsets3[target]) + indices[tail_degree][tuple(predecessor)]
            for source in range(NQUAD):
                hmap[source * NQ + unit_index, column] = tquad[
                    operator, source, tail_index
                ]
    product = np.rint(quadratic.astype(np.float64) @ hmap.astype(np.float64)).astype(np.int64) % P
    return np.ascontiguousarray((product + direct.astype(np.int64)) % P, dtype=np.uint8)


def selected_candidate_matrix(
    seeds: np.ndarray,
    offsets3: np.ndarray,
    bdeg: np.ndarray,
    low_target: np.ndarray,
    tquad: np.ndarray,
    selected: np.ndarray,
    commutator_basis_rows: np.ndarray,
    ordered_rules: np.ndarray,
    incidence: np.ndarray,
) -> tuple[np.ndarray, np.ndarray, np.ndarray, list[tuple[int, int, tuple[int, ...]]], np.ndarray]:
    offsets4, labels, monomials, indices = selected_labels(selected, bdeg)
    old = np.zeros((NOLD, len(selected)), dtype=np.uint8)
    for column, (component, _monomial_index, exponent) in enumerate(labels):
        source_degree = 3 - int(bdeg[component])
        for variable, power in enumerate(exponent):
            if power:
                predecessor = list(exponent)
                predecessor[variable] -= 1
                source_index = int(offsets3[component]) + indices[source_degree][tuple(predecessor)]
                old[variable * NSEED : (variable + 1) * NSEED, column] = seeds[:, source_index]

    transition_blocks = []
    for operator in range(NK):
        transition_blocks.append(
            apply_operator_selected(
                seeds,
                operator,
                offsets3,
                bdeg,
                low_target,
                tquad,
                labels,
                monomials,
                indices,
            )
        )
        print(f"  rebuilt selected T_{operator} seed block", flush=True)
    transitions = np.ascontiguousarray(np.vstack(transition_blocks), dtype=np.uint8)

    # Directly evaluate every one of the 336 path nodes from the corresponding
    # sealed monic-rule tail, then apply the universal incidence matrix.
    path_blocks = []
    for operator in range(NK):
        path_blocks.append(
            apply_operator_selected(
                ordered_rules,
                operator,
                offsets3,
                bdeg,
                low_target,
                tquad,
                labels,
                monomials,
                indices,
            )
        )
    path_images = np.ascontiguousarray(np.vstack(path_blocks), dtype=np.uint8)
    raw_commutators = np.rint(
        incidence.astype(np.float64) @ path_images.astype(np.float64)
    ).astype(np.int64) % P
    raw_commutators = np.ascontiguousarray(raw_commutators, dtype=np.uint8)
    candidate = np.ascontiguousarray(
        np.vstack([old, transitions, raw_commutators[commutator_basis_rows]]),
        dtype=np.uint8,
    )
    assert candidate.shape == (NCANDIDATE, len(selected))
    return candidate, raw_commutators, path_images, labels, offsets4


def block_product(left: np.ndarray, right: np.ndarray, block_size: int = 200) -> np.ndarray:
    """Exact mod-89 product through binary64 with bounded, checked dot lengths."""

    assert left.shape[1] == right.shape[0]
    assert left.shape[1] * (P - 1) ** 2 < 2**53
    left_float = left.astype(np.float64)
    output = np.empty((left.shape[0], right.shape[1]), dtype=np.uint8)
    for start in range(0, right.shape[1], block_size):
        stop = min(start + block_size, right.shape[1])
        output[:, start:stop] = (
            np.rint(left_float @ right[:, start:stop].astype(np.float64)).astype(np.int64) % P
        ).astype(np.uint8)
    return output


def main() -> None:
    producer = json.loads(PRODUCER_RESULT.read_text())
    pc0 = json.loads(PC0_CERTIFICATE.read_text())
    assert producer["status"] == "PC1-COUPLED-DEGREE4-PASS"
    assert producer["prime"] == P
    assert pc0["status"] == "PC0-INDEPENDENT-RANK-REPLICATION-PASS"
    assert pc0["prime"] == P
    assert pc0["multiplication_map"]["full_image_rank"] == 27583
    assert pc0["multiplication_map"]["kernel_dimension"] == MU_KERNEL_DIMENSION

    expected_producer_inputs = {
        str(RELATION.relative_to(ROOT)): sha256_file(RELATION),
        str(MULTIPLICATION.relative_to(ROOT)): sha256_file(MULTIPLICATION),
        str(REWRITE.relative_to(ROOT)): sha256_file(REWRITE),
        PC0_KERNEL.name: sha256_file(PC0_KERNEL),
    }
    assert producer["inputs"] == expected_producer_inputs
    assert expected_producer_inputs[str(RELATION.relative_to(ROOT))] == pc0["inputs"][
        str(RELATION.relative_to(ROOT))
    ]
    assert expected_producer_inputs[str(MULTIPLICATION.relative_to(ROOT))] == pc0["inputs"][
        str(MULTIPLICATION.relative_to(ROOT))
    ]
    assert expected_producer_inputs[PC0_KERNEL.name] == pc0["multiplication_map"][
        "kernel_basis_file_sha256"
    ]
    assert sha256_file(PRODUCER_ARTIFACT) == producer["artifact_sha256"]

    with np.load(RELATION, allow_pickle=False) as frozen:
        assert int(frozen["prime"]) == P
        seeds = frozen["seed_F3"].astype(np.uint8)
        offsets3 = frozen["off3"].astype(np.int32)
        bdeg = frozen["Bdeg"].astype(np.int8)
    with np.load(MULTIPLICATION, allow_pickle=False) as frozen:
        assert int(frozen["prime"]) == P
        low_target = frozen["low_target"].astype(np.int32)
        tquad = frozen["T_quad_F3"].astype(np.uint8)
        assert np.array_equal(frozen["off3"], offsets3)
        assert np.array_equal(frozen["Bdeg"], bdeg)
    with np.load(REWRITE, allow_pickle=False) as frozen:
        assert int(frozen["prime"]) == P
        rule_exponents = frozen["k_exp"].astype(np.int8)
        rule_tails = frozen["tail_F3"].astype(np.uint8)
        assert np.array_equal(frozen["off3"], offsets3)
        assert np.array_equal(frozen["Bdeg"], bdeg)
    with np.load(PC0_KERNEL, allow_pickle=False) as frozen:
        assert int(frozen["prime"]) == P
        mu_kernel = frozen["kernel"].astype(np.uint8)
    assert seeds.shape == (NSEED, 14134)
    assert mu_kernel.shape == (NQ * NV, MU_KERNEL_DIMENSION)
    _basis, expected_bdeg = order_basis()
    assert np.array_equal(bdeg, expected_bdeg)

    scratch = Path("/tmp/p25_cov_verify_pc1_coupled")
    scratch.mkdir(parents=True, exist_ok=True)
    flint_binary = compile_flint_ranker(scratch)

    incidence, labels, forest_profile, canonical_cycles = universal_commutator_graph()
    assert flint_rank(flint_binary, scratch, "incidence", incidence) == NCOMM_BASIS
    assert flint_rank(flint_binary, scratch, "canonical_cycles", canonical_cycles.T) == NCOMM_CYCLES
    ordered_rules, path_input_hash = verify_path_inputs(tquad, rule_exponents, rule_tails)

    transitions, commutators, _quadratic_coefficients, w, tail_to_w = formal_sources(
        seeds, offsets3, tquad
    )
    assert not np.any(commutators.T.astype(np.int64) @ canonical_cycles.astype(np.int64) % P)
    transition_profile, transition_basis = sparse_row_profile(transitions)
    assert len(transition_profile) == FORMAL_W
    assert rows_in_basis(commutators, transition_basis)
    commutator_basis = np.ascontiguousarray(commutators[forest_profile], dtype=np.uint8)
    extra_formal = np.ascontiguousarray(
        np.vstack([transitions, commutator_basis]), dtype=np.uint8
    )
    extra_profile, _extra_basis = sparse_row_profile(extra_formal)
    assert len(extra_profile) == FORMAL_W
    assert flint_rank(flint_binary, scratch, "formal_transitions", transitions) == FORMAL_W
    assert flint_rank(flint_binary, scratch, "formal_commutator_basis", commutator_basis) == NCOMM_BASIS

    with np.load(PRODUCER_ARTIFACT, allow_pickle=False) as artifact:
        assert set(artifact.files) == {
            "prime",
            "selection_seed",
            "selected_coupled_columns",
            "selected_components",
            "selected_component_monomials",
            "formal_transition_profile",
            "formal_extra_profile",
            "commutator_path_incidence",
            "commutator_labels",
            "commutator_basis_rows",
            "commutator_cycle_syzygies",
            "pure_q_dependency_coefficients",
            "selected_coupled_residual",
            "residual_row_profile",
        }
        assert int(artifact["prime"]) == P
        selection_seed = int(artifact["selection_seed"])
        selected = artifact["selected_coupled_columns"].astype(np.int32)
        stored_components = artifact["selected_components"].astype(np.int16)
        stored_component_monomials = artifact["selected_component_monomials"].astype(np.int32)
        stored_syzygies = artifact["commutator_cycle_syzygies"].astype(np.uint8)
        dependency = artifact["pure_q_dependency_coefficients"].astype(np.uint8)
        stored_residual = artifact["selected_coupled_residual"].astype(np.uint8)
        residual_profile = artifact["residual_row_profile"].astype(np.int32)
        assert np.array_equal(artifact["commutator_path_incidence"], incidence)
        assert np.array_equal(artifact["commutator_labels"], labels)
        assert np.array_equal(artifact["commutator_basis_rows"], forest_profile)
        assert np.array_equal(artifact["formal_transition_profile"], transition_profile)
        assert np.array_equal(artifact["formal_extra_profile"], extra_profile)

    expected_selected = np.sort(
        np.random.default_rng(selection_seed)
        .choice(NONPURE_F4, size=len(selected), replace=False)
        .astype(np.int32)
    )
    assert np.array_equal(selected, expected_selected)
    assert sha256_array(selected) == producer["coupled_residual"]["selected_columns_sha256"]

    # Independently reconstructed universal cycles need not equal FFLAS's
    # stored basis, but both must be full bases of the same 105-dimensional
    # incidence kernel.
    assert stored_syzygies.shape == (NCOMM_RAW, NCOMM_CYCLES)
    assert not np.any(incidence.T.astype(np.int64) @ stored_syzygies.astype(np.int64) % P)
    assert flint_rank(flint_binary, scratch, "stored_cycle_syzygies", stored_syzygies.T) == NCOMM_CYCLES

    v0_indices = np.asarray(
        [variable * NV + seed for variable in range(NQ) for seed in range(NSEED)],
        dtype=np.int32,
    )
    w_indices = np.asarray(
        [variable * NV + NSEED + basis for variable in range(NQ) for basis in range(NW)],
        dtype=np.int32,
    )
    mu_v0 = np.ascontiguousarray(mu_kernel[v0_indices].T, dtype=np.uint8)
    mu_w = np.ascontiguousarray(mu_kernel[w_indices].T, dtype=np.uint8)
    assert dependency.shape == (PURE_Q_KERNEL, NCANDIDATE)
    formal_dependencies = dependency[:FORMAL_KERNEL]
    lifted_dependencies = dependency[FORMAL_KERNEL:]
    assert not np.any(formal_dependencies[:, :NOLD])
    formal_coefficients = np.ascontiguousarray(formal_dependencies[:, NOLD:], dtype=np.uint8)
    assert not np.any(block_product(formal_coefficients, extra_formal, 128))
    assert flint_rank(flint_binary, scratch, "formal_dependency_witness", formal_coefficients) == FORMAL_KERNEL
    assert np.array_equal(lifted_dependencies[:, :NOLD], mu_v0)
    lifted_formal = block_product(
        np.ascontiguousarray(lifted_dependencies[:, NOLD:], dtype=np.uint8),
        extra_formal,
        128,
    )
    assert np.array_equal(lifted_formal, mu_w)
    assert flint_rank(flint_binary, scratch, "mu_v0_projection", mu_v0) == MU_KERNEL_DIMENSION
    assert sha256_array(dependency) == producer["pure_q_projection"]["dependency_basis_sha256"]

    candidate, selected_raw_commutators, path_images, selected_labels_list, offsets4 = (
        selected_candidate_matrix(
            seeds,
            offsets3,
            bdeg,
            low_target,
            tquad,
            selected,
            forest_profile,
            ordered_rules,
            incidence,
        )
    )
    rebuilt_components = np.asarray(
        [label[0] for label in selected_labels_list], dtype=np.int16
    )
    rebuilt_monomials = np.asarray(
        [label[1] for label in selected_labels_list], dtype=np.int32
    )
    assert np.array_equal(stored_components, rebuilt_components)
    assert np.array_equal(stored_component_monomials, rebuilt_monomials)
    assert not np.any(
        selected_raw_commutators.T.astype(np.int64)
        @ canonical_cycles.astype(np.int64)
        % P
    )
    assert not np.any(
        selected_raw_commutators.T.astype(np.int64)
        @ stored_syzygies.astype(np.int64)
        % P
    )
    assert sha256_array(candidate) == producer["coupled_residual"][
        "candidate_restriction_sha256"
    ]

    # Recompute D*C on the selected non-pure-q coordinates.  The split avoids
    # multiplying the 2,278 formal dependencies by the identically zero old
    # coefficient block.
    residual = np.empty_like(stored_residual)
    residual[:FORMAL_KERNEL] = block_product(
        formal_coefficients, candidate[NOLD:], 200
    )
    lifted_old = block_product(
        np.ascontiguousarray(lifted_dependencies[:, :NOLD], dtype=np.uint8),
        candidate[:NOLD],
        200,
    )
    lifted_extra = block_product(
        np.ascontiguousarray(lifted_dependencies[:, NOLD:], dtype=np.uint8),
        candidate[NOLD:],
        200,
    )
    residual[FORMAL_KERNEL:] = (
        lifted_old.astype(np.uint16) + lifted_extra.astype(np.uint16)
    ) % P
    residual = np.ascontiguousarray(residual, dtype=np.uint8)
    assert np.array_equal(residual, stored_residual)
    assert sha256_array(residual) == producer["coupled_residual"]["residual_sha256"]
    residual_rank = flint_rank(flint_binary, scratch, "coupled_residual", residual)
    assert residual_rank == PURE_Q_KERNEL
    assert np.array_equal(residual_profile, np.arange(PURE_Q_KERNEL, dtype=np.int32))

    assert producer["candidate_ledger"] == {
        "old_q_seed_rows": NOLD,
        "transition_rows": NTRANS,
        "quadratic_commutator_rows_raw": NCOMM_RAW,
        "quadratic_commutator_rank": NCOMM_BASIS,
        "quadratic_commutator_cycle_syzygies": NCOMM_CYCLES,
        "commutator_path_inputs_sha256": path_input_hash,
        "all_coordinate_factorization": producer["candidate_ledger"][
            "all_coordinate_factorization"
        ],
        "raw_total_rows": NOLD + NTRANS + NCOMM_RAW,
        "minimal_candidate_rows": NCANDIDATE,
    }
    assert producer["pure_q_projection"]["kernel_dimension"] == PURE_Q_KERNEL
    assert producer["coupled_residual"]["residual_rank"] == PURE_Q_KERNEL
    assert producer["full_degree4"]["rank"] == NCANDIDATE
    assert producer["full_degree4"]["kernel_dimension"] == 0

    result = {
        "status": "PASS_INDEPENDENT_PC1_COUPLED_DEGREE4_REPLAY",
        "ok": True,
        "prime": P,
        "inputs": {
            **expected_producer_inputs,
            PC0_CERTIFICATE.name: sha256_file(PC0_CERTIFICATE),
            PRODUCER_SCRIPT.name: sha256_file(PRODUCER_SCRIPT),
            PRODUCER_RESULT.name: sha256_file(PRODUCER_RESULT),
            PRODUCER_ARTIFACT.name: sha256_file(PRODUCER_ARTIFACT),
            Path(__file__).name: sha256_file(Path(__file__)),
        },
        "universal_commutator_cycles": {
            "path_nodes": 336,
            "quartic_components": 126,
            "raw_edges": NCOMM_RAW,
            "incidence_rank": NCOMM_BASIS,
            "cycle_dimension": NCOMM_CYCLES,
            "incidence_sha256": sha256_array(incidence),
            "canonical_cycle_basis_sha256": sha256_array(canonical_cycles),
            "stored_cycle_basis_sha256": sha256_array(stored_syzygies),
            "path_inputs_sha256": path_input_hash,
            "all_coordinate_factorization_checked": True,
            "selected_path_images_sha256": sha256_array(path_images),
        },
        "formal_projection": {
            "transition_rank": len(transition_profile),
            "commutator_rank": NCOMM_BASIS,
            "extra_rank": len(extra_profile),
            "formal_dependency_dimension": FORMAL_KERNEL,
            "transition_sha256": sha256_array(transitions),
            "commutator_sha256": sha256_array(commutators),
            "W_sha256": sha256_array(w),
            "tail_to_W_sha256": sha256_array(tail_to_w),
        },
        "pure_q_kernel_witness": {
            "formal_dependencies": FORMAL_KERNEL,
            "lifted_pc0_dependencies": MU_KERNEL_DIMENSION,
            "total_dimension": PURE_Q_KERNEL,
            "dependency_sha256": sha256_array(dependency),
        },
        "selected_coupled_residual": {
            "selected_columns": len(selected),
            "selection_seed": selection_seed,
            "F4_offsets_sha256": sha256_array(offsets4),
            "candidate_restriction_sha256": sha256_array(candidate),
            "residual_shape": list(residual.shape),
            "residual_sha256": sha256_array(residual),
            "rank": residual_rank,
            "rank_backend": "FLINT nmod_mat_rank over F_89, independent of producer FFLAS-FFPACK",
        },
        "degree4_ledger": {
            "old_q_seed_rows": NOLD,
            "new_transition_generators": NTRANS,
            "new_commutator_generators": NCOMM_BASIS,
            "independent_candidate_rows": NCANDIDATE,
            "full_degree4_kernel_dimension": 0,
        },
        "theorem_boundary": {
            "proves": (
                "Exactly over F_89, the 315 raw quadratic commutators have a "
                "105-dimensional universal cycle space and rank 210.  After one "
                "commutator basis is selected, the 29,880 coupled degree-four "
                "candidate relations are linearly independent."
            ),
            "does_not_prove": (
                "T-stability in degree five or above, a finite stabilization or "
                "regularity bound, representation characters, projective support, "
                "or any characteristic-zero statement."
            ),
        },
    }
    OUTPUT.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    print("PASS_INDEPENDENT_PC1_COUPLED_DEGREE4_REPLAY", flush=True)


if __name__ == "__main__":
    main()
