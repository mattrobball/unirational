#!/usr/bin/env python3
"""Produce the exact PC.1 finite-state border-stability certificate.

This calculation uses the order ideal

    B = 1 + K + Sym^2(K)

and the canonical operators P_1=1, P_{k_i}=T_i, and
P_{k_i k_j}=T_i T_j for i <= j.  Let C be the lexicographic 210-edge
forest in the graph of the 315 quadratic commutator defects.  For every
cubic K-monomial m=k_i*b and every quadratic basis vector e_u, it constructs
an explicit identity

    D_m(e_u) = sum a[j,c] q_j C_c + sum z[h,c] T_h(C_c),

where D_m=T_i P_b-sum r_{m,c}(q)P_c.  There are 56*21=1176 such identities.
The coefficients are obtained by telescoping paths in the universal
commutator forest, so they prove all polynomial coordinates at once; finite
field specializations are diagnostics only.

The resulting stable hull is finite but deliberately nonminimal.  This
producer does not compute the degree-five quotient rank or a minimal graded
Betti ledger and therefore does not authorize PC25-STABLE-PRESENTATION-PASS.
"""

from __future__ import annotations

import hashlib
from itertools import combinations_with_replacement
import json
from pathlib import Path
import time

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
FINITE = ROOT / "certificates" / "degree25_finite_module"
RELATION = FINITE / "relation_matrix.npz"
MULTIPLICATION = FINITE / "multiplication_matrices.npz"
REWRITE = FINITE / "rewrite_rules.npz"
COUPLED = HERE / "pc1_coupled_degree4_certificate.npz"
COUPLED_RESULT = HERE / "pc1_coupled_degree4.json"
COUPLED_VERIFY = HERE / "verify_pc1_coupled_degree4_result.json"
ARTIFACT = HERE / "pc1_border_stability_certificate.npz"
RESULT = HERE / "pc1_border_stability.json"
PREFLIGHT = HERE / "preflight_pc1_border_stability.json"

P = 89
NQ, NK, NQUAD, NBASIS = 37, 6, 21, 28
NSEED, NCUBIC = 690, 56
NCOMM_RAW, NCOMM_FOREST = 315, 210
NLINEAR_DEFECT, NQUAD_DEFECT = NCUBIC * NK, NCUBIC * NQUAD
DIAGNOSTIC_SEED = 2026080141
DIAGNOSTIC_POINTS = 4


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


def order_basis() -> tuple[np.ndarray, np.ndarray, np.ndarray]:
    basis = [tuple([0] * NK)]
    for variable in range(NK):
        exponent = [0] * NK
        exponent[variable] = 1
        basis.append(tuple(exponent))
    quadratic_words: list[tuple[int, int]] = []
    for left, right in combinations_with_replacement(range(NK), 2):
        exponent = [0] * NK
        exponent[left] += 1
        exponent[right] += 1
        basis.append(tuple(exponent))
        quadratic_words.append((left, right))
    if len(basis) != NBASIS or len(quadratic_words) != NQUAD:
        raise AssertionError("basis order changed")
    exponents = np.asarray(basis, dtype=np.int8)
    degrees = exponents.sum(axis=1).astype(np.int8)
    return exponents, degrees, np.asarray(quadratic_words, dtype=np.int8)


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


def commutator_forest(
    quadratic_words: np.ndarray, cubic_exponents: np.ndarray
) -> tuple[np.ndarray, np.ndarray, np.ndarray, np.ndarray, np.ndarray]:
    cubic_index = {
        tuple(map(int, exponent)): index
        for index, exponent in enumerate(cubic_exponents)
    }
    node_count = NK * NCUBIC
    incidence = np.zeros((NCOMM_RAW, node_count), dtype=np.uint8)
    labels: list[tuple[int, int, int]] = []
    endpoints: list[tuple[int, int]] = []
    for left in range(NK):
        for right in range(left + 1, NK):
            for source, word in enumerate(quadratic_words):
                quadratic = np.bincount(word, minlength=NK).astype(np.int8)
                right_cubic = quadratic.copy()
                right_cubic[right] += 1
                left_cubic = quadratic.copy()
                left_cubic[left] += 1
                first = left * NCUBIC + cubic_index[tuple(map(int, right_cubic))]
                second = right * NCUBIC + cubic_index[tuple(map(int, left_cubic))]
                row = len(labels)
                incidence[row, first] = 1
                incidence[row, second] = P - 1
                labels.append((left, right, source))
                endpoints.append((first, second))
    if len(labels) != NCOMM_RAW:
        raise AssertionError("commutator row count changed")

    union = UnionFind(node_count)
    forest_rows: list[int] = []
    adjacency: list[list[tuple[int, int]]] = [[] for _ in range(node_count)]
    for edge, (first, second) in enumerate(endpoints):
        if union.union(first, second):
            position = len(forest_rows)
            forest_rows.append(edge)
            adjacency[first].append((second, position))
            adjacency[second].append((first, position))
    components = len({union.find(node) for node in range(node_count)})
    if (components, len(forest_rows)) != (126, NCOMM_FOREST):
        raise AssertionError(
            f"unexpected commutator forest ({components}, {len(forest_rows)})"
        )
    return (
        incidence,
        np.asarray(labels, dtype=np.int16),
        np.asarray(endpoints, dtype=np.int32),
        np.asarray(forest_rows, dtype=np.int32),
        np.asarray(adjacency, dtype=object),
    )


def forest_path(
    start: int,
    end: int,
    adjacency: np.ndarray,
    forest_endpoints: np.ndarray,
) -> np.ndarray:
    """Coefficients x with x*forest_incidence = e_start-e_end."""
    answer = np.zeros(NCOMM_FOREST, dtype=np.uint8)
    if start == end:
        return answer
    predecessor: dict[int, tuple[int, int]] = {start: (-1, -1)}
    queue = [start]
    for node in queue:
        if node == end:
            break
        for neighbor, edge_position in adjacency[node]:
            neighbor = int(neighbor)
            if neighbor not in predecessor:
                predecessor[neighbor] = (node, int(edge_position))
                queue.append(neighbor)
    if end not in predecessor:
        raise AssertionError(f"forest path missing between nodes {start} and {end}")
    node = end
    while node != start:
        previous, edge_position = predecessor[node]
        first, second = map(int, forest_endpoints[edge_position])
        # The traversed segment previous -> node must contribute
        # e_previous-e_node.
        answer[edge_position] = 1 if (first, second) == (previous, node) else P - 1
        node = previous
    return answer


def cubic_node(
    outer: int,
    cubic: np.ndarray,
    cubic_index: dict[tuple[int, ...], int],
) -> int:
    return outer * NCUBIC + cubic_index[tuple(map(int, cubic))]


def sparse_circuit(dense: np.ndarray) -> tuple[np.ndarray, np.ndarray, np.ndarray, np.ndarray]:
    """CSR-like encoding for an array (test, kind, forest)."""
    if dense.ndim != 3 or dense.shape[2] != NCOMM_FOREST:
        raise AssertionError("circuit tensor shape changed")
    indptr = [0]
    kinds: list[int] = []
    forests: list[int] = []
    values: list[int] = []
    for test in range(dense.shape[0]):
        kind_index, forest_index = np.nonzero(dense[test])
        kinds.extend(map(int, kind_index))
        forests.extend(map(int, forest_index))
        values.extend(map(int, dense[test, kind_index, forest_index]))
        indptr.append(len(values))
    return (
        np.asarray(indptr, dtype=np.int32),
        np.asarray(kinds, dtype=np.int16),
        np.asarray(forests, dtype=np.int16),
        np.asarray(values, dtype=np.uint8),
    )


def monomial_values(exponents: list[tuple[int, ...]], point: np.ndarray) -> np.ndarray:
    values = np.ones(len(exponents), dtype=np.int64)
    for row, exponent in enumerate(exponents):
        value = 1
        for variable, power in enumerate(exponent):
            if power:
                value = value * pow(int(point[variable]), int(power), P) % P
        values[row] = value
    return values.astype(np.uint8)


def specialize_polyvector(
    vector: np.ndarray,
    point: np.ndarray,
    offsets3: np.ndarray,
    basis_degrees: np.ndarray,
    qmonomials: dict[int, list[tuple[int, ...]]],
) -> np.ndarray:
    monomial_cache = {
        degree: monomial_values(qmonomials[degree], point) for degree in range(4)
    }
    answer = np.zeros(NBASIS, dtype=np.uint8)
    for component, basis_degree in enumerate(basis_degrees):
        start, stop = int(offsets3[component]), int(offsets3[component + 1])
        coefficient = vector[start:stop].astype(np.int64)
        values = monomial_cache[3 - int(basis_degree)].astype(np.int64)
        answer[component] = int(coefficient @ values % P)
    return answer


def specialization_diagnostic(
    tquad: np.ndarray,
    rules: np.ndarray,
    offsets3: np.ndarray,
    basis_degrees: np.ndarray,
    low_target: np.ndarray,
    quadratic_words: np.ndarray,
    decompositions: np.ndarray,
    commutator_labels: np.ndarray,
    forest_rows: np.ndarray,
    linear_coefficients: np.ndarray,
    q_coefficients: np.ndarray,
    t_coefficients: np.ndarray,
) -> dict[str, object]:
    qmonomials = {degree: weak_compositions(degree, NQ) for degree in range(4)}
    rng = np.random.default_rng(DIAGNOSTIC_SEED)
    points = rng.integers(0, P, size=(DIAGNOSTIC_POINTS, NQ), dtype=np.int64)
    checked_linear = checked_quadratic = 0
    digest = hashlib.sha256()
    for point in points:
        operators = np.zeros((NK, NBASIS, NBASIS), dtype=np.uint8)
        for operator in range(NK):
            for source in range(7):
                target = int(low_target[operator, source])
                operators[operator, target, source] = 1
            for source in range(NQUAD):
                operators[operator, :, 7 + source] = specialize_polyvector(
                    tquad[operator, source],
                    point,
                    offsets3,
                    basis_degrees,
                    qmonomials,
                )

        canonical = np.zeros((NBASIS, NBASIS, NBASIS), dtype=np.uint8)
        canonical[0] = np.eye(NBASIS, dtype=np.uint8)
        for operator in range(NK):
            canonical[1 + operator] = operators[operator]
        for source, (left, right) in enumerate(quadratic_words):
            canonical[7 + source] = (
                operators[int(left)].astype(np.int64)
                @ operators[int(right)].astype(np.int64)
                % P
            ).astype(np.uint8)

        raw_commutators = np.zeros((NCOMM_RAW, NBASIS), dtype=np.uint8)
        for row, (left, right, source) in enumerate(commutator_labels):
            basis_source = 7 + int(source)
            first = (
                operators[int(left)].astype(np.int64)
                @ operators[int(right)].astype(np.int64)
            )[:, basis_source]
            second = (
                operators[int(right)].astype(np.int64)
                @ operators[int(left)].astype(np.int64)
            )[:, basis_source]
            raw_commutators[row] = ((first - second) % P).astype(np.uint8)
        commutators = raw_commutators[forest_rows]

        specialized_rules = np.vstack(
            [
                specialize_polyvector(
                    rule, point, offsets3, basis_degrees, qmonomials
                )
                for rule in rules
            ]
        ).astype(np.uint8)
        for rule_index, (operator, quadratic) in enumerate(decompositions):
            left_operator = (
                operators[int(operator)].astype(np.int64)
                @ canonical[7 + int(quadratic)].astype(np.int64)
                % P
            )
            rhs_operator = np.zeros((NBASIS, NBASIS), dtype=np.int64)
            for component in range(NBASIS):
                rhs_operator += (
                    int(specialized_rules[rule_index, component])
                    * canonical[component].astype(np.int64)
                )
            defect = (left_operator - rhs_operator) % P
            for source in range(NK):
                test = rule_index * NK + source
                expected = (
                    linear_coefficients[test].astype(np.int64)
                    @ commutators.astype(np.int64)
                    % P
                )
                actual = defect[:, 1 + source].astype(np.int64)
                if not np.array_equal(actual % P, expected % P):
                    raise AssertionError(
                        f"linear defect specialization mismatch {rule_index},{source}"
                    )
                digest.update(actual.astype(np.uint8).tobytes())
                checked_linear += 1
            if np.any(defect[:, 0]):
                raise AssertionError(f"constant defect mismatch for rule {rule_index}")
            for source in range(NQUAD):
                test = rule_index * NQUAD + source
                expected = np.zeros(NBASIS, dtype=np.int64)
                for variable in range(NQ):
                    coefficients = q_coefficients[test, variable].astype(np.int64)
                    if np.any(coefficients):
                        expected += (
                            int(point[variable])
                            * (coefficients @ commutators.astype(np.int64) % P)
                        )
                for outer in range(NK):
                    coefficients = t_coefficients[test, outer].astype(np.int64)
                    if np.any(coefficients):
                        vector = coefficients @ commutators.astype(np.int64) % P
                        expected += operators[outer].astype(np.int64) @ vector
                actual = defect[:, 7 + source].astype(np.int64)
                if not np.array_equal(actual % P, expected % P):
                    raise AssertionError(
                        f"quadratic defect specialization mismatch {rule_index},{source}"
                    )
                digest.update(actual.astype(np.uint8).tobytes())
                checked_quadratic += 1
    return {
        "seed": DIAGNOSTIC_SEED,
        "points": DIAGNOSTIC_POINTS,
        "linear_defects_checked": checked_linear,
        "quadratic_defects_checked": checked_quadratic,
        "defect_values_sha256": digest.hexdigest(),
        "role": "diagnostic only; the forest circuit derivation is the all-coordinate proof",
    }


def main() -> None:
    started = time.monotonic()
    for required in (
        RELATION,
        MULTIPLICATION,
        REWRITE,
        COUPLED,
        COUPLED_RESULT,
        COUPLED_VERIFY,
    ):
        if not required.exists():
            raise SystemExit(f"missing prerequisite: {required}")
    if json.loads(COUPLED_RESULT.read_text()).get("status") != (
        "PC1-COUPLED-DEGREE4-PASS"
    ):
        raise AssertionError("coupled degree-four producer is not PASS")
    if json.loads(COUPLED_VERIFY.read_text()).get("status") != (
        "PASS_INDEPENDENT_PC1_COUPLED_DEGREE4_REPLAY"
    ):
        raise AssertionError("coupled degree-four independent replay is not PASS")

    basis_exponents, basis_degrees, quadratic_words = order_basis()
    cubic_exponents = np.asarray(weak_compositions(3, NK), dtype=np.int8)
    cubic_index = {
        tuple(map(int, exponent)): index
        for index, exponent in enumerate(cubic_exponents)
    }
    quadratic_index = {
        tuple(map(int, exponent)): index
        for index, exponent in enumerate(basis_exponents[7:])
    }

    with np.load(RELATION, allow_pickle=False) as frozen:
        seeds = frozen["seed_F3"].astype(np.uint8)
        offsets3 = frozen["off3"].astype(np.int32)
        relation_degrees = frozen["Bdeg"].astype(np.int8)
        if int(frozen["prime"]) != P:
            raise AssertionError("relation prime changed")
    with np.load(MULTIPLICATION, allow_pickle=False) as frozen:
        low_target = frozen["low_target"].astype(np.int32)
        tquad = frozen["T_quad_F3"].astype(np.uint8)
        multiplication_degrees = frozen["Bdeg"].astype(np.int8)
        if int(frozen["prime"]) != P:
            raise AssertionError("multiplication prime changed")
    with np.load(REWRITE, allow_pickle=False) as frozen:
        sealed_cubics = frozen["k_exp"].astype(np.int8)
        rule_tails = frozen["tail_F3"].astype(np.uint8)
        if int(frozen["prime"]) != P:
            raise AssertionError("rewrite prime changed")
    with np.load(COUPLED, allow_pickle=False) as frozen:
        coupled_forest_rows = frozen["commutator_basis_rows"].astype(np.int32)

    if seeds.shape != (NSEED, 14134):
        raise AssertionError(f"seed shape changed: {seeds.shape}")
    if tquad.shape != (NK, NQUAD, 14134):
        raise AssertionError(f"T_quad shape changed: {tquad.shape}")
    if not (
        np.array_equal(basis_degrees, relation_degrees)
        and np.array_equal(basis_degrees, multiplication_degrees)
        and np.array_equal(cubic_exponents, sealed_cubics)
    ):
        raise AssertionError("sealed basis/rule order changed")
    rules = np.ascontiguousarray((-rule_tails.astype(np.int16)) % P, dtype=np.uint8)

    # Every displayed cubic rewrite must agree for every decomposition m=k_i*b.
    decompositions = np.zeros((NCUBIC, 2), dtype=np.int16)
    decomposition_matches = 0
    for rule_index, cubic in enumerate(cubic_exponents):
        operator = int(np.flatnonzero(cubic)[0])
        quadratic = cubic.copy()
        quadratic[operator] -= 1
        source = quadratic_index[tuple(map(int, quadratic))]
        decompositions[rule_index] = (operator, source)
        for alternative in np.flatnonzero(cubic):
            remainder = cubic.copy()
            remainder[int(alternative)] -= 1
            alternative_source = quadratic_index[tuple(map(int, remainder))]
            if not np.array_equal(tquad[int(alternative), alternative_source], rules[rule_index]):
                raise AssertionError("cubic rewrite decomposition mismatch")
            decomposition_matches += 1

    (
        incidence,
        commutator_labels,
        endpoints,
        forest_rows,
        adjacency,
    ) = commutator_forest(quadratic_words, cubic_exponents)
    if not np.array_equal(forest_rows, coupled_forest_rows):
        raise AssertionError("coupled degree-four forest changed")
    forest_endpoints = endpoints[forest_rows]
    forest_incidence = incidence[forest_rows]

    # Express all 315 raw commutators in the canonical 210-row forest.
    raw_to_forest = np.zeros((NCOMM_RAW, NCOMM_FOREST), dtype=np.uint8)
    for row, (first, second) in enumerate(endpoints):
        raw_to_forest[row] = forest_path(
            int(first), int(second), adjacency, forest_endpoints
        )
    reconstructed_incidence = (
        raw_to_forest.astype(np.int64) @ forest_incidence.astype(np.int64) % P
    ).astype(np.uint8)
    if not np.array_equal(reconstructed_incidence, incidence):
        raise AssertionError("forest does not span every raw commutator")
    raw_label_index = {
        tuple(map(int, label)): row for row, label in enumerate(commutator_labels)
    }

    def commutator_coeff(left: int, right: int, source: int) -> np.ndarray:
        if left == right:
            return np.zeros(NCOMM_FOREST, dtype=np.uint8)
        sign = 1 if left < right else P - 1
        row = raw_label_index[(min(left, right), max(left, right), source)]
        return (sign * raw_to_forest[row].astype(np.int16) % P).astype(np.uint8)

    qmonomial1 = weak_compositions(1, NQ)
    qindex1 = {monomial: index for index, monomial in enumerate(qmonomial1)}
    unit_local = []
    for variable in range(NQ):
        unit = [0] * NQ
        unit[variable] = 1
        unit_local.append(qindex1[tuple(unit)])

    linear_coefficients = np.zeros(
        (NLINEAR_DEFECT, NCOMM_FOREST), dtype=np.uint8
    )
    q_coefficients = np.zeros(
        (NQUAD_DEFECT, NQ, NCOMM_FOREST), dtype=np.uint8
    )
    t_coefficients = np.zeros(
        (NQUAD_DEFECT, NK, NCOMM_FOREST), dtype=np.uint8
    )

    # The linear border columns are degree-four forest paths.
    for rule_index, cubic in enumerate(cubic_exponents):
        operator, source = map(int, decompositions[rule_index])
        left, right = map(int, quadratic_words[source])
        if tuple(map(int, cubic)) != tuple(
            np.bincount([operator, left, right], minlength=NK)
        ):
            raise AssertionError("canonical cubic decomposition failed")
        for linear_source in range(NK):
            inner = np.bincount(
                [left, right, linear_source], minlength=NK
            ).astype(np.int8)
            start = cubic_node(operator, inner, cubic_index)
            end = cubic_node(linear_source, cubic, cubic_index)
            linear_coefficients[rule_index * NK + linear_source] = forest_path(
                start, end, adjacency, forest_endpoints
            )

        # The 21 quadratic border columns have two T(C) paths and two q*C
        # contributions, exactly as described in the result theorem proof.
        for quadratic_source, (p_outer, q_inner) in enumerate(quadratic_words):
            p_outer, q_inner = int(p_outer), int(q_inner)
            test = rule_index * NQUAD + quadratic_source

            inner_start = np.bincount(
                [right, p_outer, q_inner], minlength=NK
            ).astype(np.int8)
            inner_end = np.bincount(
                [q_inner, left, right], minlength=NK
            ).astype(np.int8)
            first_path = forest_path(
                cubic_node(left, inner_start, cubic_index),
                cubic_node(p_outer, inner_end, cubic_index),
                adjacency,
                forest_endpoints,
            )
            t_coefficients[test, operator] = (
                t_coefficients[test, operator].astype(np.int16)
                + first_path.astype(np.int16)
            ) % P

            second_path = forest_path(
                cubic_node(operator, inner_end, cubic_index),
                cubic_node(q_inner, cubic, cubic_index),
                adjacency,
                forest_endpoints,
            )
            t_coefficients[test, p_outer] = (
                t_coefficients[test, p_outer].astype(np.int16)
                + second_path.astype(np.int16)
            ) % P

            # Swap the first two operators after the first forest path.  The
            # commutator vanishes on B-degrees 0 and 1; its quadratic part is
            # a q-linear combination of the raw C_{operator,p_outer,v}.
            inner_rule_index = cubic_index[tuple(map(int, inner_end))]
            inner_rule = rules[inner_rule_index]
            leading_commutators = [
                commutator_coeff(operator, p_outer, target)
                for target in range(NQUAD)
            ]
            for target in range(NQUAD):
                block = inner_rule[
                    offsets3[7 + target] : offsets3[8 + target]
                ]
                for variable, local in enumerate(unit_local):
                    coefficient = int(block[local])
                    if coefficient:
                        q_coefficients[test, variable] = (
                            q_coefficients[test, variable].astype(np.int32)
                            + coefficient
                            * leading_commutators[target].astype(np.int32)
                        ) % P

            # Finally commute the quadratic source u past each quadratic
            # component of R_m.  Every difference is one degree-four forest
            # path, multiplied by the corresponding q-linear coefficient.
            rule = rules[rule_index]
            u_exponent = np.bincount(
                [p_outer, q_inner], minlength=NK
            ).astype(np.int8)
            for target, (a_outer, b_inner) in enumerate(quadratic_words):
                a_outer, b_inner = int(a_outer), int(b_inner)
                first_cubic = np.bincount(
                    [q_inner, a_outer, b_inner], minlength=NK
                ).astype(np.int8)
                second_cubic = np.bincount(
                    [b_inner, p_outer, q_inner], minlength=NK
                ).astype(np.int8)
                if not np.array_equal(
                    np.eye(NK, dtype=np.int8)[p_outer] + first_cubic,
                    basis_exponents[7 + target] + u_exponent,
                ):
                    raise AssertionError("final path multidegree mismatch")
                final_path = forest_path(
                    cubic_node(p_outer, first_cubic, cubic_index),
                    cubic_node(a_outer, second_cubic, cubic_index),
                    adjacency,
                    forest_endpoints,
                )
                block = rule[offsets3[7 + target] : offsets3[8 + target]]
                for variable, local in enumerate(unit_local):
                    coefficient = int(block[local])
                    if coefficient:
                        q_coefficients[test, variable] = (
                            q_coefficients[test, variable].astype(np.int32)
                            + coefficient * final_path.astype(np.int32)
                        ) % P

    linear_coefficients = np.ascontiguousarray(linear_coefficients, dtype=np.uint8)
    q_coefficients = np.ascontiguousarray(q_coefficients, dtype=np.uint8)
    t_coefficients = np.ascontiguousarray(t_coefficients, dtype=np.uint8)
    diagnostic = specialization_diagnostic(
        tquad,
        rules,
        offsets3,
        basis_degrees,
        low_target,
        quadratic_words,
        decompositions,
        commutator_labels,
        forest_rows,
        linear_coefficients,
        q_coefficients,
        t_coefficients,
    )

    linear_sparse = sparse_circuit(linear_coefficients[:, None, :])
    q_sparse = sparse_circuit(q_coefficients)
    t_sparse = sparse_circuit(t_coefficients)
    np.savez_compressed(
        ARTIFACT,
        prime=np.int32(P),
        basis_exponents=basis_exponents,
        basis_degrees=basis_degrees,
        quadratic_words=quadratic_words,
        cubic_exponents=cubic_exponents,
        cubic_decompositions=decompositions,
        commutator_incidence=incidence,
        commutator_labels=commutator_labels,
        commutator_endpoints=endpoints,
        commutator_forest_rows=forest_rows,
        raw_to_forest_coefficients=raw_to_forest,
        linear_circuit_indptr=linear_sparse[0],
        linear_circuit_kind=linear_sparse[1],
        linear_circuit_forest=linear_sparse[2],
        linear_circuit_value=linear_sparse[3],
        q_circuit_indptr=q_sparse[0],
        q_circuit_variable=q_sparse[1],
        q_circuit_forest=q_sparse[2],
        q_circuit_value=q_sparse[3],
        t_circuit_indptr=t_sparse[0],
        t_circuit_operator=t_sparse[1],
        t_circuit_forest=t_sparse[2],
        t_circuit_value=t_sparse[3],
    )

    status = "PC1-NONMINIMAL-BORDER-HULL-PASS"
    result = {
        "status": status,
        "prime": P,
        "inputs": {
            str(RELATION.relative_to(ROOT)): sha256_file(RELATION),
            str(MULTIPLICATION.relative_to(ROOT)): sha256_file(MULTIPLICATION),
            str(REWRITE.relative_to(ROOT)): sha256_file(REWRITE),
            COUPLED.name: sha256_file(COUPLED),
            COUPLED_RESULT.name: sha256_file(COUPLED_RESULT),
            COUPLED_VERIFY.name: sha256_file(COUPLED_VERIFY),
        },
        "canonical_state_hull": {
            "basis_size": NBASIS,
            "seed_states": {
                "degree_3": NSEED,
                "degree_4": NK * NSEED,
                "degree_5": NQUAD * NSEED,
                "total": NBASIS * NSEED,
            },
            "commutator_forest_states": {
                "degree_4": NCOMM_FOREST,
                "degree_5": NK * NCOMM_FOREST,
                "degree_6": NQUAD * NCOMM_FOREST,
                "total": NBASIS * NCOMM_FOREST,
            },
            "total_state_generators_nonminimal": NBASIS
            * (NSEED + NCOMM_FOREST),
        },
        "forest": {
            "raw_commutators": NCOMM_RAW,
            "vertices": NK * NCUBIC,
            "quartic_components": 126,
            "forest_rows": NCOMM_FOREST,
            "cycle_dimension": NCOMM_RAW - NCOMM_FOREST,
            "all_raw_rows_replayed": True,
            "raw_to_forest_sha256": sha256_array(raw_to_forest),
        },
        "border_gate": {
            "constant_defects": NCUBIC,
            "constant_defects_zero": NCUBIC,
            "linear_defects": NLINEAR_DEFECT,
            "linear_defects_in_C4": NLINEAR_DEFECT,
            "quadratic_defects": NQUAD_DEFECT,
            "quadratic_defects_in_M_C5": NQUAD_DEFECT,
            "M_C5_source_rows": NQ * NCOMM_FOREST + NK * NCOMM_FOREST,
            "q_C_source_rows": NQ * NCOMM_FOREST,
            "T_C_source_rows": NK * NCOMM_FOREST,
            "linear_circuit_nonzeros": int(len(linear_sparse[3])),
            "q_circuit_nonzeros": int(len(q_sparse[3])),
            "T_circuit_nonzeros": int(len(t_sparse[3])),
            "all_coordinate_proof": (
                "Each circuit is a coefficientwise polynomial identity. Forest "
                "paths telescope in the 336-vertex universal incidence graph; "
                "all decompositions of every cubic rewrite are byte-matched; the "
                "only scalar coefficients used are the sealed q-linear quadratic "
                "tail coefficients. Hence the identities hold on all 1,489,657 "
                "coordinates of F5, not merely at diagnostic points."
            ),
        },
        "stability_and_kernel_equality": {
            "M_definition": (
                "M=sum_{b in B} S P_b({690 seeds} union {210 forest commutators})"
            ),
            "M_C_definition": (
                "M_C=sum_{b in B} S P_b({210 forest commutators})"
            ),
            "stability": (
                "For deg(b)<=1, T_i P_b is canonical modulo C. For quadratic b, "
                "T_i P_b=sum_c r_c P_c+D_m. The certified constant, linear, and "
                "quadratic columns give D_m(F) subset M_C. Thus T_i(M) subset M."
            ),
            "N_definition": (
                "N is the smallest T-stable S-submodule containing the 690 residual "
                "seeds and the 210 forest overlap/commutator defects. It is not the "
                "seed-only hull asserted in the obsolete finite-presentation note."
            ),
            "stable_hull_inclusion": (
                "M is T-stable and contains the defining seeds and forest defects, "
                "so N is contained in M. Every displayed state in M is a true "
                "polynomial relation, so M is contained in ker(F->R/J_N)."
            ),
            "kernel_congruence_argument": (
                "On F/N the induced T_i commute: their commutators vanish exactly on "
                "basis degrees 0 and 1, while all quadratic columns are spanned by "
                "the forest generators. Hence p(k) maps to p(T)e_0 independently "
                "of word order. The 56 monic cubics vanish by the byte-matched border "
                "rules and the remaining 690 cubic generators vanish by the seeds. "
                "Thus R/J_N maps to F/N. The reverse map sends e_b to b; both "
                "compositions fix the algebra generators and B, so they are inverse. "
                "Consequently ker(F->R/J_N)=N=M."
            ),
        },
        "diagnostic_specializations": diagnostic,
        "minimal_graded_ledger": {
            "degree_3_new_rank": NSEED,
            "degree_4_new_rank": 4350,
            "degree_4_breakdown": {"seed_transitions": 4140, "commutators": 210},
            "degree_5_candidate_states": 15750,
            "degree_5_candidate_breakdown": {
                "quadratic_seed_states": NQUAD * NSEED,
                "linear_commutator_states": NK * NCOMM_FOREST,
            },
            "degree_5_minimal_quotient_rank": None,
            "degree_6_quadratic_commutator_states": NQUAD * NCOMM_FOREST,
            "degree_6_minimal_quotient_rank": None,
            "status": "OPEN",
            "consequence": (
                "The stable hull is an exact finite but possibly redundant S-module "
                "presentation. It is not the required minimal homogeneous relation "
                "module or per-stage Betti/character ledger."
            ),
        },
        "artifact": ARTIFACT.name,
        "artifact_sha256": sha256_file(ARTIFACT),
        "resource": {"elapsed_seconds": time.monotonic() - started},
        "theorem_boundary": {
            "proves": (
                "Over F_89, all 1,176 quadratic border defects lie in "
                "M_C5=S1*C+sum_i T_i(C), all 336 linear border defects lie in C, "
                "and the displayed finite nonminimal hull equals the T-stable "
                "relation kernel."
            ),
            "does_not_prove": (
                "The degree-five or degree-six minimal quotient ranks, a minimal "
                "graded Betti ledger, representation characters, projective support, "
                "or any characteristic-zero statement. PC25-STABLE-PRESENTATION-PASS "
                "remains unauthorized."
            ),
        },
    }
    RESULT.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    PREFLIGHT.write_text(
        json.dumps(
            {
                "status": "READY_FOR_INDEPENDENT_REPLAY",
                "producer_status": status,
                "artifact": ARTIFACT.name,
                "artifact_sha256": sha256_file(ARTIFACT),
                "expected_independent_marker": (
                    "PASS_INDEPENDENT_PC1_BORDER_STABILITY_REPLAY"
                ),
                "quadratic_defects": NQUAD_DEFECT,
                "full_coordinate_algebraic_replay_required": True,
                "diagnostic_specializations_are_not_proof": True,
                "minimal_graded_ledger": "OPEN",
                "authorized_exit": "PC1-NONMINIMAL-BORDER-HULL-PASS",
                "unauthorized_exit": "PC25-STABLE-PRESENTATION-PASS",
            },
            indent=2,
            sort_keys=True,
        )
        + "\n"
    )
    print(status, flush=True)


if __name__ == "__main__":
    main()
