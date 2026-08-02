#!/usr/bin/env python3
"""Independent mod-89 replay of the A5Q subgroup descent certificate.

This verifier deliberately does not import any producer.  It rebuilds the
abstract group, both modular representations, the two maximal A5 actions,
the sealed degree-eleven landing maps, the Schur Reynolds frame, and the
eleven coset conjugates directly from JSON records and elementary finite
field arithmetic.
"""

from __future__ import annotations

from collections import deque
from fractions import Fraction
from hashlib import sha256
from itertools import combinations
import json
from pathlib import Path
from typing import Iterable


HERE = Path(__file__).resolve().parent


def repository_root() -> Path:
    for candidate in HERE.parents:
        if (candidate / "SPEC.md").is_file() and (candidate / "certificates").is_dir():
            return candidate
    raise AssertionError("Problem E repository root not found")


ROOT = repository_root()
RANK_PATH = HERE / "rank_witness.json"
TWISTS_PATH = ROOT / "goals_2026-08-01/H_SUBGROUP_TWISTS_ROOT_019FBE10/twists.json"
A5_ROOT = ROOT / "goal_runs_after_35fa/H_A5_TWISTS"
RAW_COVARIANTS_PATH = A5_ROOT / "common/degree11_covariants_raw_exact.json"
SCHUR_PATH = ROOT / "goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/exact_schur_frame/exact_frame.json"


F2 = tuple[int, int, int, int]
Perm = tuple[int, ...]


def digest(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def is_prime(n: int) -> bool:
    if n < 2:
        return False
    divisor = 2
    while divisor * divisor <= n:
        if n % divisor == 0:
            return False
        divisor += 1
    return True


def fmul(left: F2, right: F2) -> F2:
    return tuple(
        sum(left[2 * i + k] * right[2 * k + j] for k in range(2)) % 11
        for i in range(2)
        for j in range(2)
    )  # type: ignore[return-value]


def fcanon(matrix: Iterable[int]) -> F2:
    positive = tuple(entry % 11 for entry in matrix)
    negative = tuple((-entry) % 11 for entry in positive)
    return min(positive, negative)  # type: ignore[return-value]


FONE = fcanon((1, 0, 0, 1))
FS = fcanon((0, 2, 5, 0))
FT = fcanon((1, 2, 0, 1))


def finv(matrix: F2) -> F2:
    return fcanon((matrix[3], -matrix[1], -matrix[2], matrix[0]))


def feval(word: str) -> F2:
    result = FONE
    for letter in word:
        result = fcanon(fmul(result, {"S": FS, "T": FT}[letter]))
    return result


def abstract_group() -> tuple[list[F2], dict[F2, str]]:
    words = {FONE: ""}
    queue = deque([FONE])
    while queue:
        current = queue.popleft()
        for generator, letter in ((FS, "S"), (FT, "T")):
            candidate = fcanon(fmul(current, generator))
            if candidate not in words:
                words[candidate] = words[current] + letter
                queue.append(candidate)
    assert len(words) == 660
    return list(words), words


def pc(left: Perm, right: Perm) -> Perm:
    return tuple(left[right[i]] for i in range(len(left)))


def pinv(permutation: Perm) -> Perm:
    answer = [0] * len(permutation)
    for source, image in enumerate(permutation):
        answer[image] = source
    return tuple(answer)


def ppower(permutation: Perm, exponent: int) -> Perm:
    answer = tuple(range(len(permutation)))
    for _ in range(exponent):
        answer = pc(answer, permutation)
    return answer


def porder(permutation: Perm) -> int:
    answer = tuple(range(len(permutation)))
    for exponent in range(1, 61):
        answer = pc(answer, permutation)
        if answer == tuple(range(len(permutation))):
            return exponent
    raise AssertionError("permutation order exceeded 60")


def pclosure(generators: Iterable[Perm]) -> frozenset[Perm]:
    generators = tuple(generators)
    identity = tuple(range(len(generators[0])))
    found = {identity}
    queue = deque([identity])
    while queue:
        current = queue.popleft()
        for generator in generators:
            candidate = pc(current, generator)
            if candidate not in found:
                found.add(candidate)
                queue.append(candidate)
    return frozenset(found)


def mat_identity(size: int) -> list[list[int]]:
    return [[int(i == j) for j in range(size)] for i in range(size)]


def mat_mul(left: list[list[int]], right: list[list[int]], p: int) -> list[list[int]]:
    return [
        [
            sum(left[i][k] * right[k][j] for k in range(len(right))) % p
            for j in range(len(right[0]))
        ]
        for i in range(len(left))
    ]


def mat_vec(matrix: list[list[int]], vector: list[int] | tuple[int, ...], p: int) -> list[int]:
    return [sum(a * b for a, b in zip(row, vector)) % p for row in matrix]


def mat_inverse(matrix: list[list[int]], p: int) -> list[list[int]] | None:
    size = len(matrix)
    work = [
        [entry % p for entry in matrix[row]]
        + [int(row == column) for column in range(size)]
        for row in range(size)
    ]
    for column in range(size):
        pivot = next((row for row in range(column, size) if work[row][column]), None)
        if pivot is None:
            return None
        work[column], work[pivot] = work[pivot], work[column]
        unit = pow(work[column][column], -1, p)
        work[column] = [unit * entry % p for entry in work[column]]
        for row in range(size):
            if row == column:
                continue
            scalar = work[row][column]
            if scalar:
                work[row] = [
                    (a - scalar * b) % p
                    for a, b in zip(work[row], work[column])
                ]
    return [row[size:] for row in work]


def determinant(matrix: list[list[int]], p: int) -> int:
    work = [[entry % p for entry in row] for row in matrix]
    rows = len(work)
    assert rows == len(work[0])
    answer = 1
    for column in range(rows):
        pivot = next((row for row in range(column, rows) if work[row][column]), None)
        if pivot is None:
            return 0
        if pivot != column:
            work[pivot], work[column] = work[column], work[pivot]
            answer = -answer
        unit = work[column][column] % p
        answer = answer * unit % p
        inverse = pow(unit, -1, p)
        for row in range(column + 1, rows):
            scalar = work[row][column] * inverse % p
            if scalar:
                work[row] = [
                    (a - scalar * b) % p
                    for a, b in zip(work[row], work[column])
                ]
    return answer % p


def matrix_rank(matrix: list[list[int]], p: int) -> int:
    if not matrix:
        return 0
    work = [[entry % p for entry in row] for row in matrix]
    row_count, column_count = len(work), len(work[0])
    pivot_row = 0
    for column in range(column_count):
        pivot = next((row for row in range(pivot_row, row_count) if work[row][column]), None)
        if pivot is None:
            continue
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        inverse = pow(work[pivot_row][column], -1, p)
        work[pivot_row] = [inverse * entry % p for entry in work[pivot_row]]
        for row in range(row_count):
            if row == pivot_row:
                continue
            scalar = work[row][column]
            if scalar:
                work[row] = [
                    (a - scalar * b) % p
                    for a, b in zip(work[row], work[pivot_row])
                ]
        pivot_row += 1
        if pivot_row == row_count:
            break
    return pivot_row


def nullspace(matrix: list[list[int]], p: int) -> list[list[int]]:
    assert matrix
    work = [[entry % p for entry in row] for row in matrix]
    row_count, column_count = len(work), len(work[0])
    pivots: list[int] = []
    pivot_row = 0
    for column in range(column_count):
        pivot = next((row for row in range(pivot_row, row_count) if work[row][column]), None)
        if pivot is None:
            continue
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        inverse = pow(work[pivot_row][column], -1, p)
        work[pivot_row] = [inverse * entry % p for entry in work[pivot_row]]
        for row in range(row_count):
            if row == pivot_row:
                continue
            scalar = work[row][column]
            if scalar:
                work[row] = [
                    (a - scalar * b) % p
                    for a, b in zip(work[row], work[pivot_row])
                ]
        pivots.append(column)
        pivot_row += 1
        if pivot_row == row_count:
            break
    free = [column for column in range(column_count) if column not in pivots]
    answer = []
    for free_column in free:
        vector = [0] * column_count
        vector[free_column] = 1
        for row, pivot in reversed(list(enumerate(pivots))):
            vector[pivot] = -sum(
                work[row][column] * vector[column] for column in free
            ) % p
        answer.append(vector)
    return answer


def projective(vector: list[int], p: int) -> tuple[int, ...]:
    pivot = next((entry for entry in vector if entry % p), None)
    assert pivot is not None
    inverse = pow(pivot, -1, p)
    return tuple(entry * inverse % p for entry in vector)


def projectively_equal(left: list[int], right: list[int], p: int) -> bool:
    return projective(left, p) == projective(right, p)


def matrix_projectively_equal(left: list[list[int]], right: list[list[int]], p: int) -> bool:
    flat_left = [entry for row in left for entry in row]
    flat_right = [entry for row in right for entry in row]
    return projectively_equal(flat_left, flat_right, p)


def reduce_fraction(value, p: int) -> int:
    fraction = Fraction(value)
    return fraction.numerator * pow(fraction.denominator, -1, p) % p


def deserialize_entry(coefficients, zeta: int, p: int) -> int:
    return sum(
        int(numerator) * pow(int(denominator), -1, p) * pow(zeta, exponent, p)
        for exponent, (numerator, denominator) in enumerate(coefficients)
    ) % p


def deserialize_matrix(data, zeta: int, p: int) -> list[list[int]]:
    return [
        [deserialize_entry(entry, zeta, p) for entry in row]
        for row in data
    ]


def word_matrix(word: str, generators: dict[str, list[list[int]]], size: int, p: int) -> list[list[int]]:
    answer = mat_identity(size)
    for letter in word:
        answer = mat_mul(answer, generators[letter], p)
    return answer


def reconstruct_representations(frame, group, words, zeta: int, p: int):
    source_generators = {
        letter: deserialize_matrix(data, zeta, p)
        for letter, data in zip("ST", frame["source_generators_ST"])
    }
    target_generators = {
        letter: deserialize_matrix(data, zeta, p)
        for letter, data in zip("ST", frame["target_generators_ST"])
    }
    source = {g: word_matrix(words[g], source_generators, 6, p) for g in group}
    target = {g: word_matrix(words[g], target_generators, 5, p) for g in group}
    for g in group:
        for generator, letter in ((FS, "S"), (FT, "T")):
            product = fcanon(fmul(g, generator))
            assert matrix_projectively_equal(
                mat_mul(source[g], source_generators[letter], p), source[product], p
            )
            assert mat_mul(target[g], target_generators[letter], p) == target[product]
    return source, target


def subgroup_closure(generators: Iterable[F2]) -> frozenset[F2]:
    generators = tuple(generators)
    found = {FONE}
    queue = deque([FONE])
    while queue:
        current = queue.popleft()
        for generator in generators:
            candidate = fcanon(fmul(current, generator))
            if candidate not in found:
                found.add(candidate)
                queue.append(candidate)
    return frozenset(found)


def canonical_left_cosets(group: list[F2], subgroup: frozenset[F2]) -> list[tuple[F2, frozenset[F2]]]:
    uncovered = set(group)
    answer = []
    for representative in group:
        if representative not in uncovered:
            continue
        coset = frozenset(fcanon(fmul(h, representative)) for h in subgroup)
        answer.append((representative, coset))
        uncovered -= coset
    assert not uncovered and len(answer) == 11
    assert all(len(coset) == 60 for _representative, coset in answer)
    return answer


def decode_coset_representatives(record, words, group, subgroup):
    stored = record.get("coset_representatives_ST")
    canonical = canonical_left_cosets(group, subgroup)
    if stored is None:
        return [representative for representative, _coset in canonical]
    representatives = []
    for item in stored:
        if isinstance(item, str):
            representatives.append(feval(item))
        elif isinstance(item, dict) and "word" in item:
            representatives.append(feval(item["word"]))
        else:
            representatives.append(fcanon(tuple(int(entry) for entry in item)))
    assert len(representatives) == 11
    cosets = [frozenset(fcanon(fmul(h, g)) for h in subgroup) for g in representatives]
    assert len(set(cosets)) == 11
    assert set().union(*map(set, cosets)) == set(group)
    if all(isinstance(item, str) for item in stored):
        assert [words[g] for g in representatives] == stored
    return representatives


def exact_a5_representation(sqrt5: int, p: int) -> dict[Perm, list[list[int]]]:
    inv2 = pow(2, -1, p)
    alpha = -(1 + sqrt5) * inv2 % p
    p5 = (1, 2, 3, 4, 0)
    p3 = (0, 1, 3, 4, 2)
    m5 = [
        [alpha, -alpha % p, -1 % p],
        [alpha, 1, 0],
        [alpha, -alpha % p, 0],
    ]
    m3 = [
        [0, -1 % p, -alpha % p],
        [0, 0, 1],
        [-1 % p, -alpha % p, 0],
    ]
    identity = tuple(range(5))
    mapping = {identity: mat_identity(3)}
    queue = deque([identity])
    while queue:
        permutation = queue.popleft()
        matrix = mapping[permutation]
        for generator, generator_matrix in ((p5, m5), (p3, m3)):
            candidate = pc(permutation, generator)
            candidate_matrix = mat_mul(matrix, generator_matrix, p)
            if candidate in mapping:
                assert mapping[candidate] == candidate_matrix
            else:
                mapping[candidate] = candidate_matrix
                queue.append(candidate)
    assert len(mapping) == 60
    return mapping


def sylow_five_subgroups(a5_group: Iterable[Perm]) -> tuple[frozenset[Perm], ...]:
    groups = {
        frozenset(ppower(element, exponent) for exponent in range(5))
        for element in a5_group
        if porder(element) == 5
    }
    answer = tuple(sorted(groups, key=lambda item: tuple(sorted(item))))
    assert len(answer) == 6
    return answer


def augmentation_matrix(permutation: Perm, sylow5, p: int) -> list[list[int]]:
    inverse = pinv(permutation)
    action = tuple(
        sylow5.index(
            frozenset(pc(pc(permutation, h), inverse) for h in subgroup)
        )
        for subgroup in sylow5
    )
    answer = [[0] * 5 for _ in range(5)]
    for column in range(5):
        positive, negative = action[column], action[5]
        if positive < 5:
            answer[positive][column] += 1
        if negative < 5:
            answer[negative][column] -= 1
    return [[entry % p for entry in row] for row in answer]


def subgroup_source(record, a5_rep, p: int):
    h_to_perm = {
        fcanon(tuple(item["h"])): tuple(item["permutation"])
        for item in record["source_map"]
    }
    subgroup = frozenset(fcanon(tuple(item)) for item in record["subgroup_elements"])
    assert set(h_to_perm) == set(subgroup)
    assert set(h_to_perm.values()) == set(a5_rep)
    for left in subgroup:
        for right in subgroup:
            assert h_to_perm[fcanon(fmul(left, right))] == pc(h_to_perm[left], h_to_perm[right])
    sigma = {h: a5_rep[h_to_perm[h]] for h in subgroup}
    return subgroup, h_to_perm, sigma


def reconstruct_intertwiner(record, subgroup, h_to_perm, target, augmentation, p: int):
    equations = []
    generators = [fcanon(tuple(item)) for item in record["generators"]]
    assert subgroup_closure(generators) == subgroup
    for h in generators:
        rho = target[h]
        abstract = augmentation[h_to_perm[h]]
        for row in range(5):
            for column in range(5):
                equation = [0] * 25
                for inner in range(5):
                    equation[5 * inner + column] += rho[row][inner]
                    equation[5 * row + inner] -= abstract[inner][column]
                equations.append([entry % p for entry in equation])
    kernel = nullspace(equations, p)
    assert len(kernel) == 1
    vector = kernel[0]
    scalar = pow(next(entry for entry in vector if entry), -1, p)
    vector = [scalar * entry % p for entry in vector]
    matrix = [vector[5 * row : 5 * row + 5] for row in range(5)]
    assert determinant(matrix, p)
    for h in subgroup:
        assert mat_mul(target[h], matrix, p) == mat_mul(matrix, augmentation[h_to_perm[h]], p)
    return matrix


def parse_seed(map_record) -> tuple[int, int]:
    seed = map_record.get("seed", {})
    if isinstance(seed, dict):
        degree = int(seed.get("degree", map_record.get("degree", 4)))
        coordinate = int(seed.get("source_coordinate", seed.get("coordinate", 5)))
    elif isinstance(seed, list) and len(seed) == 2 and isinstance(seed[1], list):
        exponent = seed[1]
        degree = sum(int(entry) for entry in exponent)
        nonzero = [index for index, entry in enumerate(exponent) if entry]
        assert len(nonzero) == 1
        coordinate = nonzero[0]
    elif isinstance(seed, list) and len(seed) == 2:
        coordinate, degree = map(int, seed)
    else:
        degree, coordinate = 4, 5
    assert degree % 2 == 0 and 0 <= coordinate < 6
    return degree, coordinate


def hilbert_frame(v, subgroup, sigma, source, degree: int, coordinate: int, p: int):
    answer = [[0] * 3 for _ in range(3)]
    for h in subgroup:
        scalar = pow(mat_vec(source[h], v, p)[coordinate], degree, p)
        inverse = sigma[finv(h)]
        for row in range(3):
            for column in range(3):
                answer[row][column] = (answer[row][column] + scalar * inverse[row][column]) % p
    return answer


def reduce_raw_covariants(raw, sqrt5: int, p: int):
    answer = []
    for covariant in raw["covariants"]:
        components = []
        for component in covariant:
            polynomial = {}
            for exponent, coefficient in component.items():
                rational = Fraction(*coefficient["rational"])
                radical = Fraction(*coefficient["sqrt5"])
                value = (reduce_fraction(rational, p) + sqrt5 * reduce_fraction(radical, p)) % p
                if value:
                    polynomial[tuple(map(int, exponent.split(",")))] = value
            components.append(polynomial)
        answer.append(components)
    assert len(answer) == 5 and all(len(item) == 5 for item in answer)
    return answer


def polynomial_evaluate(polynomial, point, p: int) -> int:
    return sum(
        coefficient
        * pow(point[0], exponent[0], p)
        * pow(point[1], exponent[1], p)
        * pow(point[2], exponent[2], p)
        for exponent, coefficient in polynomial.items()
    ) % p


def evaluate_landing(covariants, point, parameters, p: int) -> list[int]:
    return [
        sum(
            parameters[index] * polynomial_evaluate(covariants[index][output], point, p)
            for index in range(5)
        ) % p
        for output in range(5)
    ]


def constant_relations(point_payload, sqrt5: int, sqrt_minus11: int, p: int):
    basis = (1, sqrt5, sqrt_minus11, sqrt5 * sqrt_minus11 % p)
    return {
        name: sum(reduce_fraction(entry, p) * value for entry, value in zip(entries, basis)) % p
        for name, entries in point_payload["closed_point_relations"].items()
    }


def alpha_roots(relations, p: int) -> list[int]:
    return [
        value
        for value in range(p)
        if (
            value**3
            + relations["p2"] * value**2
            + relations["p1"] * value
            + relations["p0"]
        ) % p == 0
    ]


def landing_parameters(relations, alpha: int, p: int) -> list[int]:
    return [1] + [
        sum(relations[f"a{coordinate}_{degree}"] * pow(alpha, degree, p) for degree in range(3)) % p
        for coordinate in range(1, 4)
    ] + [alpha]


def klein(vector: list[int], p: int) -> int:
    return sum(vector[i] * vector[i] * vector[(i + 1) % 5] for i in range(5)) % p


def schur_frame(v, group, source, target_inverse, p: int):
    frame = [[0] * 5 for _ in range(5)]
    invariant = 0
    for g in group:
        scalar = pow(mat_vec(source[g], v, p)[5], 8, p)
        invariant = (invariant + scalar) % p
        inverse = target_inverse[g]
        for row in range(5):
            for column in range(5):
                frame[row][column] = (frame[row][column] + scalar * inverse[row][column]) % p
    return frame, invariant


def quadratic_rows(points: list[list[int]], p: int):
    monomials = list(combinations(range(5), 2)) + [(i, i) for i in range(5)]
    monomials = sorted(monomials)
    assert len(monomials) == 15
    rows = [[point[i] * point[j] % p for i, j in monomials] for point in points]
    return monomials, rows


def polynomial_from_roots(roots: list[int], p: int) -> list[int]:
    coefficients = [1]
    for root in roots:
        next_coefficients = [0] * (len(coefficients) + 1)
        for degree, coefficient in enumerate(coefficients):
            next_coefficients[degree] = (next_coefficients[degree] - root * coefficient) % p
            next_coefficients[degree + 1] = (next_coefficients[degree + 1] + coefficient) % p
        coefficients = next_coefficients
    return coefficients


def companion_matrix(coefficients: list[int], p: int) -> list[list[int]]:
    assert len(coefficients) == 12 and coefficients[-1] % p == 1
    answer = [[0] * 11 for _ in range(11)]
    for column in range(10):
        answer[column + 1][column] = 1
    for row in range(11):
        answer[row][10] = -coefficients[row] % p
    return answer


def linear_form(record, key: str, default_index: int) -> list[int]:
    value = record.get(key)
    if value is None:
        return [int(index == default_index) for index in range(5)]
    if isinstance(value, int):
        return [int(index == value) for index in range(5)]
    if isinstance(value, dict):
        if "coordinate" in value:
            return [int(index == int(value["coordinate"])) for index in range(5)]
        value = value.get("coefficients", value.get("vector"))
    assert isinstance(value, list) and len(value) == 5
    return [int(entry) for entry in value]


def form_value(coefficients: list[int], point: list[int], p: int) -> int:
    return sum(a * b for a, b in zip(coefficients, point)) % p


def compare_optional(record: dict, key: str, actual, p: int | None = None) -> None:
    if key not in record:
        return
    expected = record[key]
    if isinstance(actual, bool):
        assert bool(expected) == actual, (key, expected, actual)
    elif isinstance(actual, int):
        assert int(expected) % (p or (1 << 1000)) == actual, (key, expected, actual)
    else:
        assert expected == actual, (key, expected, actual)


def extract_prime_record(payload):
    records = payload.get("primes", [])
    assert records, "rank_witness.json has no prime records"
    record = next((item for item in records if int(item.get("p", item.get("prime", 0))) == 89), records[0])
    return record


def extract_map_record(class_record):
    maps = class_record.get("maps", {})
    if "canonical_quartic" in maps:
        return maps["canonical_quartic"]
    if "selected" in maps:
        return maps["selected"]
    if maps:
        return next(iter(maps.values()))
    return class_record


def witness_vector(map_record, class_record):
    for record in (map_record, class_record):
        for key in ("witness", "source_witness", "v", "schur_witness"):
            if key in record:
                value = record[key]
                if isinstance(value, dict):
                    value = value.get("v", value.get("point", value.get("coordinates")))
                if value is not None:
                    assert len(value) == 6
                    return [int(entry) for entry in value]
    raise AssertionError("class record does not contain a six-coordinate Schur witness")


def branch_alpha(branch):
    value = branch.get("alpha")
    if isinstance(value, dict):
        value = value.get("value", value.get("root"))
    assert value is not None
    return int(value)


def verify_input_hashes(payload) -> None:
    for item in payload.get("inputs", []):
        if isinstance(item, str):
            continue
        relative = item.get("path")
        expected = item.get("sha256")
        if not relative or not expected:
            continue
        path = Path(relative)
        if not path.is_absolute():
            candidates = (ROOT / path, ROOT.parents[1] / path, HERE / path)
            path = next((candidate for candidate in candidates if candidate.is_file()), candidates[0])
        assert digest(path) == expected, relative


def verify_class(
    label,
    record,
    witness_record,
    p,
    sqrt5,
    sqrt_minus11,
    group,
    words,
    source,
    target,
    target_inverse,
    a5_rep,
    augmentation,
    covariants,
):
    subgroup, h_to_perm, sigma = subgroup_source(record, a5_rep, p)
    assert len(subgroup) == int(record["order"]) == 60
    class_record = witness_record["classes"][label]
    representatives = decode_coset_representatives(class_record, words, group, subgroup)
    map_record = extract_map_record(class_record)
    degree, coordinate = parse_seed(map_record)
    assert degree == 4 and coordinate == 5
    seed_record = map_record.get("seed", {})
    if isinstance(seed_record, dict) and "target_basis_column" in seed_record:
        assert int(seed_record["target_basis_column"]) == 0
    v = [entry % p for entry in witness_vector(map_record, class_record)]

    # The fixed-field interpretation requires a free specialization of the
    # generic Schur torsor.  In particular the selected source point must not
    # acquire any nontrivial projective stabilizer after reduction.
    source_orbit_size = len(
        {projective(mat_vec(source[g], v, p), p) for g in group}
    )
    assert source_orbit_size == 660
    compare_optional(map_record, "projective_G_orbit_size", source_orbit_size, p)
    compare_optional(class_record, "projective_G_orbit_size", source_orbit_size, p)

    b_frame = hilbert_frame(v, subgroup, sigma, source, degree, coordinate, p)
    b_det = determinant(b_frame, p)
    assert b_det
    compare_optional(map_record, "B_det", b_det, p)
    if "coefficient_matrix" in map_record:
        assert [[int(entry) % p for entry in row] for row in map_record["coefficient_matrix"]] == b_frame
    if "B_at_witness" in map_record:
        assert [[int(entry) % p for entry in row] for row in map_record["B_at_witness"]] == b_frame
    y = [b_frame[row][0] for row in range(3)]
    if "Y_at_witness" in map_record:
        assert [int(entry) % p for entry in map_record["Y_at_witness"]] == y
    orbit_size = len({projective(mat_vec(sigma[h], y, p), p) for h in subgroup})
    assert orbit_size == 60
    compare_optional(map_record, "projective_H_orbit_size", orbit_size, p)
    for h in subgroup:
        moved_v = mat_vec(source[h], v, p)
        moved_b = hilbert_frame(moved_v, subgroup, sigma, source, degree, coordinate, p)
        assert moved_b == mat_mul(sigma[h], b_frame, p)

    j_matrix = reconstruct_intertwiner(record, subgroup, h_to_perm, target, augmentation, p)
    point_payload = json.loads((A5_ROOT / label / "point.json").read_text())
    relations = constant_relations(point_payload, sqrt5, sqrt_minus11, p)
    roots = alpha_roots(relations, p)
    if "alpha_roots" in class_record:
        assert sorted(int(entry) % p for entry in class_record["alpha_roots"]) == roots
    if "alpha_polynomial" in class_record:
        stored = class_record["alpha_polynomial"]
        if isinstance(stored, dict):
            stored = stored.get("ascending", stored.get("coefficients"))
        if isinstance(stored, list):
            actual = [relations["p0"], relations["p1"], relations["p2"], 1]
            assert [int(entry) % p for entry in stored] == actual

    q_frame, i8 = schur_frame(v, group, source, target_inverse, p)
    q_det = determinant(q_frame, p)
    assert q_det
    assert i8
    compare_optional(map_record, "I8", i8, p)
    q_inverse = mat_inverse(q_frame, p)
    assert q_inverse is not None
    if "Q_det" in map_record:
        assert int(map_record["Q_det"]) % p == q_det
    if "Q_det" in class_record:
        assert int(class_record["Q_det"]) % p == q_det

    branches = map_record.get("branches", [])
    assert branches, f"{label} has no selected alpha branches"
    for branch in branches:
        alpha = branch_alpha(branch) % p
        assert alpha in roots
        parameters = landing_parameters(relations, alpha, p)
        if "parameter" in branch:
            assert [int(entry) % p for entry in branch["parameter"]] == parameters

        points = []
        landing_vectors = []
        phi_vectors = []
        for representative in representatives:
            moved_v = mat_vec(source[representative], v, p)
            moved_b = hilbert_frame(moved_v, subgroup, sigma, source, degree, coordinate, p)
            moved_y = [moved_b[row][0] for row in range(3)]
            phi = evaluate_landing(covariants, moved_y, parameters, p)
            assert any(phi)
            installed = mat_vec(j_matrix, phi, p)
            assert klein(installed, p) == 0
            common = mat_vec(target_inverse[representative], installed, p)
            coordinates = mat_vec(q_inverse, common, p)
            assert any(coordinates)
            assert klein(mat_vec(q_frame, coordinates, p), p) == 0
            points.append(coordinates)
            landing_vectors.append(installed)
            phi_vectors.append(phi)

        assert len({projective(point, p) for point in points}) == 11
        # Fix the scalar ambiguity in the independently reconstructed
        # intertwiner before comparing determinants or serialized rows.
        points = [list(projective(point, p)) for point in points]
        if "points" in branch:
            stored_points = branch["points"]
            if isinstance(stored_points, dict):
                stored_points = stored_points.get("coordinates", stored_points.get("rows"))
            assert len(stored_points) == 11
            normalized_stored = [
                list(projective([int(entry) % p for entry in stored], p))
                for stored in stored_points
            ]
            assert normalized_stored == points
        if "Phi_at_identity" in branch:
            assert [int(entry) % p for entry in branch["Phi_at_identity"]] == phi_vectors[0]
        if "points_semantics" in branch:
            assert branch["points_semantics"] == (
                "11x5 projective rows in the common Q(v) frame, ordered by "
                "coset_representatives_ST and normalized by first nonzero coordinate=1"
            )
        compare_optional(branch, "Phi_nonzero", True)
        compare_optional(branch, "klein_value", 0, p)

        point_rank = matrix_rank(points, p)
        assert point_rank == 5
        if "point_rank" in branch:
            assert int(branch["point_rank"]) == point_rank
        monomials, products = quadratic_rows(points, p)
        product_rank = matrix_rank(products, p)
        assert product_rank == 11
        compare_optional(branch, "quadratic_rank", product_rank, p)

        minor_record = branch.get("minor", {})
        if minor_record:
            rows = [int(entry) for entry in minor_record.get("rows", range(11))]
            columns = [int(entry) for entry in minor_record.get("columns", [])]
            if "monomials" in minor_record:
                stored_monomials = [tuple(map(int, item)) for item in minor_record["monomials"]]
                if columns:
                    assert stored_monomials == [monomials[column] for column in columns]
                else:
                    columns = [monomials.index(item) for item in stored_monomials]
            assert len(rows) == len(columns) == 11
            minor = [[products[row][column] for column in columns] for row in rows]
            minor_det = determinant(minor, p)
            assert minor_det
            if "det" in minor_record:
                assert int(minor_record["det"]) % p == minor_det

        tau_record = branch.get("tau", {})
        if "definition" in tau_record:
            assert tau_record["definition"].replace("_", "") == "P0/P2"
        numerator = linear_form(tau_record, "numerator_form", 0)
        denominator = linear_form(tau_record, "denominator_form", 2)
        assert numerator == [1, 0, 0, 0, 0]
        assert denominator == [0, 0, 1, 0, 0]
        tau_values = []
        for point in points:
            den = form_value(denominator, point, p)
            assert den
            tau_values.append(form_value(numerator, point, p) * pow(den, -1, p) % p)
        assert len(set(tau_values)) == 11, (label, alpha, tau_values)
        if "values" in tau_record:
            assert [int(entry) % p for entry in tau_record["values"]] == tau_values
        orbit_polynomial = polynomial_from_roots(tau_values, p)
        stored_polynomial = tau_record.get("orbit_polynomial_ascending")
        if stored_polynomial is not None:
            assert [int(entry) % p for entry in stored_polynomial] == orbit_polynomial
        trace = sum(tau_values) % p
        norm = 1
        for value in tau_values:
            norm = norm * value % p
        compare_optional(tau_record, "trace", trace, p)
        compare_optional(tau_record, "norm", norm, p)
        companion = companion_matrix(orbit_polynomial, p)
        if "companion" in tau_record:
            assert [[int(entry) % p for entry in row] for row in tau_record["companion"]] == companion

        print(
            f"PASS {label} alpha={alpha} H90det={b_det} Qdet={q_det} "
            f"sourceOrbit=660 pointRank={point_rank} "
            f"quadraticRank={product_rank} tauOrbit=11"
        )
    return len(branches), representatives


def main() -> None:
    assert RANK_PATH.is_file(), "rank_witness.json is required"
    payload = json.loads(RANK_PATH.read_text())
    assert payload["format"] == "a5q-canonical-quartic-rank-witness-v1"
    verify_input_hashes(payload)
    frame = json.loads(SCHUR_PATH.read_text())
    twists = json.loads(TWISTS_PATH.read_text())
    raw = json.loads(RAW_COVARIANTS_PATH.read_text())
    assert frame["format"] == "q-schur-exact-degree8-frame-v1"
    assert twists["format"] == "H-SUBGROUP-GENERIC-TWISTS-v1"
    assert raw["format"] == "a5-degree11-raw-reynolds-covariants-v1"

    group, words = abstract_group()
    assert frame["projective_words"] == [words[g] for g in group]
    records = {record["label"]: record for record in twists["records"]}
    prime_records = payload.get("primes", [])
    assert prime_records
    assert any(int(item.get("p", item.get("prime", 0))) == 89 for item in prime_records)
    total_branches = 0
    for prime_record in prime_records:
        p = int(prime_record.get("p", prime_record.get("prime")))
        zeta = int(prime_record["zeta11"]) % p
        sqrt5 = int(prime_record["sqrt5"]) % p
        sqrt_minus11 = int(prime_record["sqrt_minus11"]) % p
        assert is_prime(p)
        assert 660 % p
        compare_optional(prime_record, "group_order_invertible", True)
        assert pow(zeta, 11, p) == 1 and all(
            pow(zeta, degree, p) != 1 for degree in range(1, 11)
        )
        assert sum(pow(zeta, degree, p) for degree in range(11)) % p == 0
        assert sqrt5 * sqrt5 % p == 5
        assert sqrt_minus11 * sqrt_minus11 % p == -11 % p
        residues = {1, 3, 4, 5, 9}
        gauss = (
            sum(pow(zeta, exponent, p) for exponent in residues)
            - sum(
                pow(zeta, exponent, p)
                for exponent in range(1, 11)
                if exponent not in residues
            )
        ) % p
        assert sqrt_minus11 == gauss

        source, target = reconstruct_representations(frame, group, words, zeta, p)
        target_inverse = {g: mat_inverse(target[g], p) for g in group}
        assert all(matrix is not None for matrix in target_inverse.values())
        a5_rep = exact_a5_representation(sqrt5, p)
        sylow5 = sylow_five_subgroups(a5_rep)
        augmentation = {
            permutation: augmentation_matrix(permutation, sylow5, p)
            for permutation in a5_rep
        }
        covariants = reduce_raw_covariants(raw, sqrt5, p)
        assert set(prime_record["classes"]) >= {"A5_class_1", "A5_class_2"}
        monomials, _rows = quadratic_rows([[0] * 5], p)
        if "quadratic_monomial_order" in prime_record:
            assert [tuple(map(int, item)) for item in prime_record["quadratic_monomial_order"]] == monomials

        branch_count = 0
        for label in ("A5_class_1", "A5_class_2"):
            class_record = prime_record["classes"][label]
            compare_optional(class_record, "subgroup_order", 60)
            compare_optional(class_record, "index", 11)
            count, _representatives = verify_class(
                label,
                records[label],
                prime_record,
                p,
                sqrt5,
                sqrt_minus11,
                group,
                words,
                source,
                target,
                target_inverse,  # type: ignore[arg-type]
                a5_rep,
                augmentation,
                covariants,
            )
            branch_count += count
        total_branches += branch_count
        print(
            f"PASS p={p} reconstructed both maximal A5 11-coset actions "
            f"and full Schur substitutions branches={branch_count}"
        )

    print("PASS reconstructed PSL2(11), both maximal A5 subgroups, and 11-coset actions")
    print(
        f"PASS sealed degree-11 Phi maps and full Schur Q substitutions "
        f"primeRecords={len(prime_records)} branches={total_branches}"
    )
    print("A5Q_INDEX11_CLOSED_POINT_OK")
    print("A5Q_DEGREE4_QUADRATIC_RANK11_OK")
    print("A5Q_INDEPENDENT_REPLAY_OK")


if __name__ == "__main__":
    main()
