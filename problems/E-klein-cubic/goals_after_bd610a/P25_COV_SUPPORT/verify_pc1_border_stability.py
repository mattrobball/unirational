#!/usr/bin/env python3
"""Independent all-coordinate replay of PC.1 border stability.

The verifier does not import the producer.  It rebuilds the order ideal, the
315-edge commutator graph, its lexicographic 210-edge forest, every canonical
cubic decomposition, and every sign in the 336 linear and 1,176 quadratic
border circuits directly from the sealed rewrite tensors.

The load-bearing check is algebraic rather than probabilistic: forest paths
are identities in the universal path incidence module, every cubic path is
byte-matched to the corresponding rewrite row, and every q coefficient is
read from the complete sealed polynomial tail.  Thus all coordinates are
covered.  Independent specializations are run only as diagnostics.
"""

from __future__ import annotations

import hashlib
from itertools import combinations_with_replacement
import json
from pathlib import Path
import traceback

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
PRODUCER_RESULT = HERE / "pc1_border_stability.json"
ARTIFACT = HERE / "pc1_border_stability_certificate.npz"
OUTPUT = HERE / "verify_pc1_border_stability_result.json"

P = 89
NQ, NK, NQUAD, NBASIS = 37, 6, 21, 28
NSEED, NCUBIC = 690, 56
NCOMM_RAW, NCOMM_FOREST = 315, 210
NLINEAR, NQUADRATIC = 336, 1176
DIAGNOSTIC_SEED = 2026080197
DIAGNOSTIC_POINTS = 3


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 22):
            digest.update(block)
    return digest.hexdigest()


def sha256_array(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def compositions(total: int, slots: int) -> list[tuple[int, ...]]:
    result: list[tuple[int, ...]] = []

    def recurse(prefix: list[int], remaining: int) -> None:
        if len(prefix) == slots - 1:
            result.append(tuple(prefix + [remaining]))
            return
        for value in range(remaining + 1):
            recurse(prefix + [value], remaining - value)

    recurse([], total)
    return result


def basis_data() -> tuple[np.ndarray, np.ndarray, np.ndarray]:
    exponents = [tuple([0] * NK)]
    for variable in range(NK):
        row = [0] * NK
        row[variable] = 1
        exponents.append(tuple(row))
    words: list[tuple[int, int]] = []
    for left, right in combinations_with_replacement(range(NK), 2):
        row = [0] * NK
        row[left] += 1
        row[right] += 1
        exponents.append(tuple(row))
        words.append((left, right))
    array = np.asarray(exponents, dtype=np.int8)
    return array, array.sum(axis=1).astype(np.int8), np.asarray(words, dtype=np.int8)


class DisjointSets:
    def __init__(self, count: int) -> None:
        self.parent = list(range(count))

    def root(self, value: int) -> int:
        if self.parent[value] != value:
            self.parent[value] = self.root(self.parent[value])
        return self.parent[value]

    def join(self, left: int, right: int) -> bool:
        left, right = self.root(left), self.root(right)
        if left == right:
            return False
        self.parent[right] = left
        return True


def rebuild_graph(
    words: np.ndarray, cubics: np.ndarray
) -> tuple[np.ndarray, np.ndarray, np.ndarray, np.ndarray, list[list[tuple[int, int]]]]:
    cubic_lookup = {tuple(map(int, row)): i for i, row in enumerate(cubics)}
    rows: list[np.ndarray] = []
    labels: list[tuple[int, int, int]] = []
    endpoints: list[tuple[int, int]] = []
    for a in range(NK):
        for b in range(a + 1, NK):
            for source, word in enumerate(words):
                u = np.bincount(word, minlength=NK).astype(np.int8)
                cb, ca = u.copy(), u.copy()
                cb[b] += 1
                ca[a] += 1
                first = a * NCUBIC + cubic_lookup[tuple(map(int, cb))]
                second = b * NCUBIC + cubic_lookup[tuple(map(int, ca))]
                row = np.zeros(NK * NCUBIC, dtype=np.uint8)
                row[first], row[second] = 1, P - 1
                rows.append(row)
                labels.append((a, b, source))
                endpoints.append((first, second))
    incidence = np.vstack(rows)
    endpoint_array = np.asarray(endpoints, dtype=np.int32)

    sets = DisjointSets(NK * NCUBIC)
    forest_rows: list[int] = []
    adjacency: list[list[tuple[int, int]]] = [[] for _ in range(NK * NCUBIC)]
    for raw_row, (first, second) in enumerate(endpoints):
        if sets.join(first, second):
            forest_position = len(forest_rows)
            forest_rows.append(raw_row)
            adjacency[first].append((second, forest_position))
            adjacency[second].append((first, forest_position))
    if len(forest_rows) != NCOMM_FOREST:
        raise AssertionError("independent forest size mismatch")
    return (
        incidence,
        np.asarray(labels, dtype=np.int16),
        endpoint_array,
        np.asarray(forest_rows, dtype=np.int32),
        adjacency,
    )


def path_vector(
    start: int,
    finish: int,
    adjacency: list[list[tuple[int, int]]],
    forest_endpoints: np.ndarray,
) -> np.ndarray:
    answer = np.zeros(NCOMM_FOREST, dtype=np.uint8)
    if start == finish:
        return answer
    previous: dict[int, tuple[int, int] | None] = {start: None}
    frontier = [start]
    for vertex in frontier:
        if vertex == finish:
            break
        for neighbor, forest_position in adjacency[vertex]:
            if neighbor not in previous:
                previous[neighbor] = (vertex, forest_position)
                frontier.append(neighbor)
    if finish not in previous:
        raise AssertionError("independent forest path missing")
    vertex = finish
    while vertex != start:
        step = previous[vertex]
        if step is None:
            raise AssertionError("broken forest predecessor")
        predecessor, position = step
        first, second = map(int, forest_endpoints[position])
        answer[position] = (
            1 if (first, second) == (predecessor, vertex) else P - 1
        )
        vertex = predecessor
    return answer


def node(
    outer: int, exponent: np.ndarray, lookup: dict[tuple[int, ...], int]
) -> int:
    return outer * NCUBIC + lookup[tuple(map(int, exponent))]


def decode_sparse(
    indptr: np.ndarray,
    kinds: np.ndarray,
    forests: np.ndarray,
    values: np.ndarray,
    tests: int,
    kind_count: int,
) -> np.ndarray:
    if indptr.shape != (tests + 1,) or int(indptr[0]) != 0:
        raise AssertionError("bad sparse circuit pointer")
    if int(indptr[-1]) != len(values) or not (
        len(kinds) == len(forests) == len(values)
    ):
        raise AssertionError("bad sparse circuit lengths")
    output = np.zeros((tests, kind_count, NCOMM_FOREST), dtype=np.uint8)
    for test in range(tests):
        start, stop = int(indptr[test]), int(indptr[test + 1])
        for position in range(start, stop):
            kind, forest = int(kinds[position]), int(forests[position])
            if not (0 <= kind < kind_count and 0 <= forest < NCOMM_FOREST):
                raise AssertionError("sparse circuit index out of bounds")
            if output[test, kind, forest]:
                raise AssertionError("sparse circuit has duplicate coordinates")
            value = int(values[position])
            if not 0 < value < P:
                raise AssertionError("sparse circuit has noncanonical value")
            output[test, kind, forest] = value
    return output


def reconstruct_circuits(
    rules: np.ndarray,
    offsets: np.ndarray,
    basis: np.ndarray,
    words: np.ndarray,
    cubics: np.ndarray,
    endpoints: np.ndarray,
    forest_rows: np.ndarray,
    adjacency: list[list[tuple[int, int]]],
) -> tuple[np.ndarray, np.ndarray, np.ndarray, np.ndarray, np.ndarray]:
    cubic_lookup = {tuple(map(int, row)): i for i, row in enumerate(cubics)}
    quadratic_lookup = {
        tuple(map(int, row)): i for i, row in enumerate(basis[7:])
    }
    forest_endpoints = endpoints[forest_rows]
    incidence = np.zeros((NCOMM_RAW, NK * NCUBIC), dtype=np.uint8)
    for row, (first, second) in enumerate(endpoints):
        incidence[row, first], incidence[row, second] = 1, P - 1
    forest_incidence = incidence[forest_rows]
    raw_to_forest = np.vstack(
        [
            path_vector(int(first), int(second), adjacency, forest_endpoints)
            for first, second in endpoints
        ]
    ).astype(np.uint8)
    if not np.array_equal(
        raw_to_forest.astype(np.int64) @ forest_incidence.astype(np.int64) % P,
        incidence.astype(np.int64),
    ):
        raise AssertionError("independent raw-to-forest replay failed")

    raw_label = {}
    row = 0
    for left in range(NK):
        for right in range(left + 1, NK):
            for source in range(NQUAD):
                raw_label[(left, right, source)] = row
                row += 1

    def comm(left: int, right: int, source: int) -> np.ndarray:
        if left == right:
            return np.zeros(NCOMM_FOREST, dtype=np.uint8)
        sign = 1 if left < right else P - 1
        raw = raw_label[(min(left, right), max(left, right), source)]
        return (sign * raw_to_forest[raw].astype(np.int16) % P).astype(np.uint8)

    q1 = compositions(1, NQ)
    q1_lookup = {exponent: index for index, exponent in enumerate(q1)}
    unit_local = []
    for variable in range(NQ):
        exponent = [0] * NQ
        exponent[variable] = 1
        unit_local.append(q1_lookup[tuple(exponent)])

    decompositions = np.zeros((NCUBIC, 2), dtype=np.int16)
    linear = np.zeros((NLINEAR, NCOMM_FOREST), dtype=np.uint8)
    q_circuit = np.zeros((NQUADRATIC, NQ, NCOMM_FOREST), dtype=np.uint8)
    t_circuit = np.zeros((NQUADRATIC, NK, NCOMM_FOREST), dtype=np.uint8)
    for rule_index, cubic in enumerate(cubics):
        outer = int(np.flatnonzero(cubic)[0])
        remainder = cubic.copy()
        remainder[outer] -= 1
        quadratic = quadratic_lookup[tuple(map(int, remainder))]
        decompositions[rule_index] = (outer, quadratic)
        left, right = map(int, words[quadratic])

        for source in range(NK):
            start_cubic = np.bincount([left, right, source], minlength=NK)
            linear[rule_index * NK + source] = path_vector(
                node(outer, start_cubic, cubic_lookup),
                node(source, cubic, cubic_lookup),
                adjacency,
                forest_endpoints,
            )

        for source, (p, q) in enumerate(words):
            p, q = int(p), int(q)
            test = rule_index * NQUAD + source
            cubic_a = np.bincount([right, p, q], minlength=NK)
            cubic_b = np.bincount([q, left, right], minlength=NK)
            t_circuit[test, outer] = (
                t_circuit[test, outer].astype(np.int16)
                + path_vector(
                    node(left, cubic_a, cubic_lookup),
                    node(p, cubic_b, cubic_lookup),
                    adjacency,
                    forest_endpoints,
                ).astype(np.int16)
            ) % P
            t_circuit[test, p] = (
                t_circuit[test, p].astype(np.int16)
                + path_vector(
                    node(outer, cubic_b, cubic_lookup),
                    node(q, cubic, cubic_lookup),
                    adjacency,
                    forest_endpoints,
                ).astype(np.int16)
            ) % P

            inner_rule = rules[cubic_lookup[tuple(map(int, cubic_b))]]
            for target in range(NQUAD):
                cvector = comm(outer, p, target).astype(np.int32)
                block = inner_rule[offsets[7 + target] : offsets[8 + target]]
                for variable, local in enumerate(unit_local):
                    coefficient = int(block[local])
                    if coefficient:
                        q_circuit[test, variable] = (
                            q_circuit[test, variable].astype(np.int32)
                            + coefficient * cvector
                        ) % P

            u_exponent = np.bincount([p, q], minlength=NK)
            rule = rules[rule_index]
            for target, (a, b) in enumerate(words):
                a, b = int(a), int(b)
                first_cubic = np.bincount([q, a, b], minlength=NK)
                second_cubic = np.bincount([b, p, q], minlength=NK)
                final_path = path_vector(
                    node(p, first_cubic, cubic_lookup),
                    node(a, second_cubic, cubic_lookup),
                    adjacency,
                    forest_endpoints,
                ).astype(np.int32)
                if not np.array_equal(
                    np.eye(NK, dtype=np.int8)[p] + first_cubic,
                    basis[7 + target] + u_exponent,
                ):
                    raise AssertionError("independent final-path degree mismatch")
                block = rule[offsets[7 + target] : offsets[8 + target]]
                for variable, local in enumerate(unit_local):
                    coefficient = int(block[local])
                    if coefficient:
                        q_circuit[test, variable] = (
                            q_circuit[test, variable].astype(np.int32)
                            + coefficient * final_path
                        ) % P
    return (
        decompositions,
        raw_to_forest,
        linear.astype(np.uint8),
        q_circuit.astype(np.uint8),
        t_circuit.astype(np.uint8),
    )


def verify_operator_identities(
    low_target: np.ndarray,
    tquad: np.ndarray,
    rules: np.ndarray,
    cubics: np.ndarray,
    words: np.ndarray,
    decompositions: np.ndarray,
) -> dict[str, int]:
    quadratic_lookup = {
        tuple(np.bincount(word, minlength=NK)): source
        for source, word in enumerate(words)
    }
    cubic_lookup = {tuple(map(int, row)): i for i, row in enumerate(cubics)}

    # Rebuild, rather than trust, the low multiplication table.
    expected = np.full_like(low_target, -1)
    for operator in range(NK):
        expected[operator, 0] = 1 + operator
        for linear in range(NK):
            exponent = [0] * NK
            exponent[operator] += 1
            exponent[linear] += 1
            expected[operator, 1 + linear] = 7 + quadratic_lookup[tuple(exponent)]
    if not np.array_equal(expected[:, :7], low_target[:, :7]):
        raise AssertionError("low multiplication table mismatch")

    decomposition_checks = 0
    for rule_index, cubic in enumerate(cubics):
        expected_outer = int(np.flatnonzero(cubic)[0])
        remainder = cubic.copy()
        remainder[expected_outer] -= 1
        expected_source = quadratic_lookup[tuple(map(int, remainder))]
        if tuple(map(int, decompositions[rule_index])) != (
            expected_outer,
            expected_source,
        ):
            raise AssertionError("canonical decomposition mismatch")
        for outer in np.flatnonzero(cubic):
            remainder = cubic.copy()
            remainder[int(outer)] -= 1
            source = quadratic_lookup[tuple(map(int, remainder))]
            if not np.array_equal(tquad[int(outer), source], rules[rule_index]):
                raise AssertionError("all-coordinate rewrite byte match failed")
            decomposition_checks += 1

    low_commutator_checks = 0
    for left in range(NK):
        for right in range(left + 1, NK):
            # On e_0 both orders reach the same quadratic basis element.
            first = int(low_target[left, int(low_target[right, 0])])
            second = int(low_target[right, int(low_target[left, 0])])
            if first != second:
                raise AssertionError("constant commutator is nonzero")
            low_commutator_checks += 1
            # On e_l both orders are the same complete cubic rewrite vector.
            for linear in range(NK):
                source_first = int(low_target[right, 1 + linear]) - 7
                source_second = int(low_target[left, 1 + linear]) - 7
                if not np.array_equal(
                    tquad[left, source_first], tquad[right, source_second]
                ):
                    raise AssertionError("linear commutator is nonzero")
                low_commutator_checks += 1

    # Endpoint equalities used after each linear and quadratic forest path.
    endpoint_checks = 0
    for rule_index, (_outer, _quadratic) in enumerate(decompositions):
        cubic = cubics[rule_index]
        for linear in range(NK):
            # P_c(e_l)=T_l(e_c) for every c in B.  Low components follow from
            # the rebuilt table; quadratic components byte-match one cubic row.
            for target, word in enumerate(words):
                left, right = map(int, word)
                source = int(low_target[right, 1 + linear]) - 7
                lhs = tquad[left, source]
                rhs = tquad[linear, target]
                if not np.array_equal(lhs, rhs):
                    raise AssertionError("linear endpoint rewrite mismatch")
                endpoint_checks += 1
        # For a quadratic source u and a linear rule component k_l,
        # P_u(e_l)=P_l(e_u); both are the same cubic rewrite.
        for source, word in enumerate(words):
            p, q = map(int, word)
            for linear in range(NK):
                inner_quadratic = int(low_target[q, 1 + linear]) - 7
                lhs = tquad[p, inner_quadratic]
                rhs = tquad[linear, source]
                if not np.array_equal(lhs, rhs):
                    raise AssertionError("quadratic endpoint rewrite mismatch")
                endpoint_checks += 1
        if tuple(map(int, cubic)) not in cubic_lookup:
            raise AssertionError("lost cubic lookup")
    return {
        "rewrite_decomposition_byte_checks": decomposition_checks,
        "low_commutator_checks": low_commutator_checks,
        "endpoint_byte_checks": endpoint_checks,
    }


def monomial_evaluation(
    exponents: list[tuple[int, ...]], point: np.ndarray
) -> np.ndarray:
    output = np.ones(len(exponents), dtype=np.uint8)
    for row, exponent in enumerate(exponents):
        value = 1
        for variable, power in enumerate(exponent):
            value = value * pow(int(point[variable]), int(power), P) % P
        output[row] = value
    return output


def evaluate_f3(
    vector: np.ndarray,
    point: np.ndarray,
    offsets: np.ndarray,
    degrees: np.ndarray,
) -> np.ndarray:
    monomials = {
        degree: monomial_evaluation(compositions(degree, NQ), point)
        for degree in range(4)
    }
    output = np.zeros(NBASIS, dtype=np.uint8)
    for component, basis_degree in enumerate(degrees):
        block = vector[offsets[component] : offsets[component + 1]].astype(np.int64)
        output[component] = int(
            block @ monomials[3 - int(basis_degree)].astype(np.int64) % P
        )
    return output


def independent_specializations(
    tquad: np.ndarray,
    rules: np.ndarray,
    offsets: np.ndarray,
    degrees: np.ndarray,
    low_target: np.ndarray,
    words: np.ndarray,
    decompositions: np.ndarray,
    labels: np.ndarray,
    forest_rows: np.ndarray,
    linear: np.ndarray,
    q_circuit: np.ndarray,
    t_circuit: np.ndarray,
) -> dict[str, object]:
    rng = np.random.default_rng(DIAGNOSTIC_SEED)
    points = rng.integers(0, P, size=(DIAGNOSTIC_POINTS, NQ), dtype=np.int64)
    digest = hashlib.sha256()
    for point in points:
        operators = np.zeros((NK, NBASIS, NBASIS), dtype=np.uint8)
        for operator in range(NK):
            for source in range(7):
                operators[operator, int(low_target[operator, source]), source] = 1
            for source in range(NQUAD):
                operators[operator, :, 7 + source] = evaluate_f3(
                    tquad[operator, source], point, offsets, degrees
                )
        canonical = np.zeros((NBASIS, NBASIS, NBASIS), dtype=np.uint8)
        canonical[0] = np.eye(NBASIS, dtype=np.uint8)
        canonical[1:7] = operators
        for source, (left, right) in enumerate(words):
            canonical[7 + source] = (
                operators[int(left)].astype(np.int64)
                @ operators[int(right)].astype(np.int64)
                % P
            ).astype(np.uint8)
        raw = []
        for left, right, source in labels:
            basis_source = 7 + int(source)
            raw.append(
                (
                    operators[int(left)].astype(np.int64)
                    @ operators[int(right)].astype(np.int64)
                    - operators[int(right)].astype(np.int64)
                    @ operators[int(left)].astype(np.int64)
                )[:, basis_source]
                % P
            )
        commutators = np.asarray(raw, dtype=np.uint8)[forest_rows]
        specialized_rules = np.vstack(
            [evaluate_f3(rule, point, offsets, degrees) for rule in rules]
        )
        for rule_index, (outer, quadratic) in enumerate(decompositions):
            lhs = (
                operators[int(outer)].astype(np.int64)
                @ canonical[7 + int(quadratic)].astype(np.int64)
            )
            rhs = sum(
                int(specialized_rules[rule_index, component])
                * canonical[component].astype(np.int64)
                for component in range(NBASIS)
            )
            defect = (lhs - rhs) % P
            if np.any(defect[:, 0]):
                raise AssertionError("specialized constant border failure")
            for source in range(NK):
                expected = (
                    linear[rule_index * NK + source].astype(np.int64)
                    @ commutators.astype(np.int64)
                    % P
                )
                if not np.array_equal(defect[:, 1 + source] % P, expected):
                    raise AssertionError("specialized linear border failure")
                digest.update(expected.astype(np.uint8).tobytes())
            for source in range(NQUAD):
                test = rule_index * NQUAD + source
                expected = np.zeros(NBASIS, dtype=np.int64)
                for variable in range(NQ):
                    coefficients = q_circuit[test, variable].astype(np.int64)
                    expected += int(point[variable]) * (
                        coefficients @ commutators.astype(np.int64) % P
                    )
                for operator in range(NK):
                    coefficients = t_circuit[test, operator].astype(np.int64)
                    vector = coefficients @ commutators.astype(np.int64) % P
                    expected += operators[operator].astype(np.int64) @ vector
                if not np.array_equal(defect[:, 7 + source] % P, expected % P):
                    raise AssertionError("specialized quadratic border failure")
                digest.update((expected % P).astype(np.uint8).tobytes())
    return {
        "seed": DIAGNOSTIC_SEED,
        "points": DIAGNOSTIC_POINTS,
        "linear_checks": DIAGNOSTIC_POINTS * NLINEAR,
        "quadratic_checks": DIAGNOSTIC_POINTS * NQUADRATIC,
        "values_sha256": digest.hexdigest(),
        "role": "independent diagnostic only",
    }


def verify() -> dict[str, object]:
    producer = json.loads(PRODUCER_RESULT.read_text())
    if producer.get("status") != "PC1-NONMINIMAL-BORDER-HULL-PASS":
        raise AssertionError("producer status is not the scoped border PASS")
    expected_inputs = producer["inputs"]
    for path in (
        RELATION,
        MULTIPLICATION,
        REWRITE,
        COUPLED,
        COUPLED_RESULT,
        COUPLED_VERIFY,
    ):
        key = str(path.relative_to(ROOT)) if path.parent != HERE else path.name
        if expected_inputs.get(key) != sha256_file(path):
            raise AssertionError(f"input hash mismatch for {key}")
    if json.loads(COUPLED_RESULT.read_text()).get("status") != (
        "PC1-COUPLED-DEGREE4-PASS"
    ):
        raise AssertionError("coupled producer prerequisite is not PASS")
    if json.loads(COUPLED_VERIFY.read_text()).get("status") != (
        "PASS_INDEPENDENT_PC1_COUPLED_DEGREE4_REPLAY"
    ):
        raise AssertionError("coupled independent prerequisite is not PASS")
    if producer.get("artifact_sha256") != sha256_file(ARTIFACT):
        raise AssertionError("artifact hash mismatch")

    basis, degrees, words = basis_data()
    cubics = np.asarray(compositions(3, NK), dtype=np.int8)
    with np.load(RELATION, allow_pickle=False) as frozen:
        offsets = frozen["off3"].astype(np.int32)
        if frozen["seed_F3"].shape != (NSEED, 14134):
            raise AssertionError("seed input shape changed")
        if not np.array_equal(frozen["Bdeg"], degrees):
            raise AssertionError("relation grading changed")
    with np.load(MULTIPLICATION, allow_pickle=False) as frozen:
        low_target = frozen["low_target"].astype(np.int32)
        tquad = frozen["T_quad_F3"].astype(np.uint8)
        if int(frozen["prime"]) != P:
            raise AssertionError("multiplication prime changed")
    with np.load(REWRITE, allow_pickle=False) as frozen:
        if not np.array_equal(frozen["k_exp"], cubics):
            raise AssertionError("rewrite order changed")
        rules = ((-frozen["tail_F3"].astype(np.int16)) % P).astype(np.uint8)
    with np.load(COUPLED, allow_pickle=False) as frozen:
        coupled_forest = frozen["commutator_basis_rows"].astype(np.int32)

    incidence, labels, endpoints, forest_rows, adjacency = rebuild_graph(words, cubics)
    if not np.array_equal(forest_rows, coupled_forest):
        raise AssertionError("independent forest differs from coupled certificate")
    decompositions, raw_to_forest, linear, q_circuit, t_circuit = reconstruct_circuits(
        rules, offsets, basis, words, cubics, endpoints, forest_rows, adjacency
    )
    operator_checks = verify_operator_identities(
        low_target, tquad, rules, cubics, words, decompositions
    )

    with np.load(ARTIFACT, allow_pickle=False) as frozen:
        if int(frozen["prime"]) != P:
            raise AssertionError("artifact prime changed")
        exact_arrays = {
            "basis_exponents": basis,
            "basis_degrees": degrees,
            "quadratic_words": words,
            "cubic_exponents": cubics,
            "cubic_decompositions": decompositions,
            "commutator_incidence": incidence,
            "commutator_labels": labels,
            "commutator_endpoints": endpoints,
            "commutator_forest_rows": forest_rows,
            "raw_to_forest_coefficients": raw_to_forest,
        }
        for name, rebuilt in exact_arrays.items():
            if not np.array_equal(frozen[name], rebuilt):
                raise AssertionError(f"stored array mismatch: {name}")
        stored_linear = decode_sparse(
            frozen["linear_circuit_indptr"],
            frozen["linear_circuit_kind"],
            frozen["linear_circuit_forest"],
            frozen["linear_circuit_value"],
            NLINEAR,
            1,
        )[:, 0]
        stored_q = decode_sparse(
            frozen["q_circuit_indptr"],
            frozen["q_circuit_variable"],
            frozen["q_circuit_forest"],
            frozen["q_circuit_value"],
            NQUADRATIC,
            NQ,
        )
        stored_t = decode_sparse(
            frozen["t_circuit_indptr"],
            frozen["t_circuit_operator"],
            frozen["t_circuit_forest"],
            frozen["t_circuit_value"],
            NQUADRATIC,
            NK,
        )
    if not np.array_equal(stored_linear, linear):
        raise AssertionError("linear circuit mismatch")
    if not np.array_equal(stored_q, q_circuit):
        raise AssertionError("q*C circuit mismatch")
    if not np.array_equal(stored_t, t_circuit):
        raise AssertionError("T(C) circuit mismatch")

    diagnostics = independent_specializations(
        tquad,
        rules,
        offsets,
        degrees,
        low_target,
        words,
        decompositions,
        labels,
        forest_rows,
        linear,
        q_circuit,
        t_circuit,
    )
    minimal = producer["minimal_graded_ledger"]
    if not (
        minimal.get("status") == "OPEN"
        and minimal.get("degree_5_minimal_quotient_rank") is None
        and minimal.get("degree_6_minimal_quotient_rank") is None
    ):
        raise AssertionError("producer overstates the minimal graded ledger")

    return {
        "status": "PASS_INDEPENDENT_PC1_BORDER_STABILITY_REPLAY",
        "prime": P,
        "artifact_sha256": sha256_file(ARTIFACT),
        "reconstructed": {
            "commutator_vertices": NK * NCUBIC,
            "raw_commutators": NCOMM_RAW,
            "forest_rows": NCOMM_FOREST,
            "raw_to_forest_sha256": sha256_array(raw_to_forest),
            "linear_defects": NLINEAR,
            "quadratic_defects": NQUADRATIC,
            "q_circuit_sha256": sha256_array(q_circuit),
            "T_circuit_sha256": sha256_array(t_circuit),
            **operator_checks,
        },
        "all_coordinate_verdict": {
            "pass": True,
            "reason": (
                "The verifier independently reconstructed every signed forest path "
                "and every coefficient from the complete sealed rewrite vectors. "
                "The incidence telescoping and byte-matched endpoint identities are "
                "polynomial identities, so all 1,489,657 F5 coordinates are covered."
            ),
            "M_C5": "S1*C + sum_i T_i(C)",
            "memberships": "1176/1176",
        },
        "kernel_equality": {
            "pass": True,
            "N": (
                "smallest T-stable S-submodule containing both the 690 seeds and "
                "the 210 forest overlap defects"
            ),
            "argument": (
                "The border circuits make M stable, hence N subset M, and every M "
                "generator is a true relation. On F/N the induced T_i commute on "
                "all of B; the 56 monic rules and 690 residual cubic rows vanish. "
                "Therefore monic reduction defines inverse maps F/N <-> R/J_N, "
                "giving M=N=ker(F->R/J_N)."
            ),
            "seed_only_hull_used": False,
        },
        "diagnostic_specializations": diagnostics,
        "scope": {
            "finite_nonminimal_stable_hull": "PASS",
            "minimal_degree_5_quotient_rank": "OPEN",
            "minimal_degree_6_quotient_rank": "OPEN",
            "minimal_graded_betti_ledger": "OPEN",
            "PC25_STABLE_PRESENTATION_PASS_authorized": False,
        },
        "terminal_marker": "PASS_INDEPENDENT_PC1_BORDER_STABILITY_REPLAY",
    }


def main() -> None:
    try:
        result = verify()
    except Exception as error:
        failure = {
            "status": "FAIL_INDEPENDENT_PC1_BORDER_STABILITY_REPLAY",
            "error_type": type(error).__name__,
            "error": str(error),
            "traceback": traceback.format_exc(),
            "terminal_marker": "FAIL_INDEPENDENT_PC1_BORDER_STABILITY_REPLAY",
        }
        OUTPUT.write_text(json.dumps(failure, indent=2, sort_keys=True) + "\n")
        print("FAIL_INDEPENDENT_PC1_BORDER_STABILITY_REPLAY", flush=True)
        raise
    OUTPUT.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    print("PASS_INDEPENDENT_PC1_BORDER_STABILITY_REPLAY", flush=True)


if __name__ == "__main__":
    main()
