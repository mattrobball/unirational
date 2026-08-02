#!/usr/bin/env python3
"""Produce the primary mod-89 A5Q rank witnesses from sealed exact inputs.

Conventions and formulas
------------------------
Matrices act on column vectors and group words multiply from left to right.
For a maximal ``H=A5`` and its icosahedral representation ``sigma``, set

    B_H(v) = sum_{h in H} sigma(h)^(-1) * ((rho6(h)v)_5)^4,
    Y_H(v) = B_H(v)e_0.

The even degree makes this independent of signs in the projective Schur
representation.  Reindexing proves ``B_H(rho6(h)v)=sigma(h)B_H(v)``.
For a sealed degree-eleven landing covariant ``Phi`` and intertwiner ``J``,
the eleven common-frame conjugates, indexed by left cosets ``H g``, are

    P_g = Q(v)^(-1) rho5(g)^(-1) J Phi(Y_H(rho6(g)v)).

Here ``Q`` is reconstructed directly from its 660-term degree-eight Reynolds
formula in ``exact_frame.json``.  No stored success boolean is consumed.

For a degree-four map ``phi:P1->P4``, pulling quadrics back along ``phi``
lands in ``H^0(P1,O(8))``, of dimension nine.  Thus eleven interpolated
points have quadratic-evaluation rank at most nine.  This producer records a
nonzero rank-eleven minor for each selected A5 cycle.
"""

from __future__ import annotations

from fractions import Fraction
from hashlib import sha256
import importlib.util
import itertools
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
P = 89
ZETA11 = 2
SQRT5 = 19

CORE_PATH = ROOT / "goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/exact_schur_frame/exact_representation_core.py"
FRAME_PATH = ROOT / "goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/exact_schur_frame/exact_frame.json"
TWISTS_PATH = ROOT / "goals_2026-08-01/H_SUBGROUP_TWISTS_ROOT_019FBE10/twists.json"
A5_ROOT = ROOT / "goal_runs_after_35fa/H_A5_TWISTS"
RAW_PATH = A5_ROOT / "common/degree11_covariants_raw_exact.json"
EXACT_REYNOLDS_PATH = A5_ROOT / "common/exact_reynolds.py"
OUTPUT_PATH = HERE / "rank_witness.json"

CLASS_SELECTION = {
    "A5_class_1": {"witness": [22, 2, 13, 21, 22, 4], "alpha": 80},
    "A5_class_2": {"witness": [71, 10, 17, 18, 13, 44], "alpha": 49},
}

# This second prime was not used to select the primary nonvanishing minors.
# Only its input seeds are serialized: the independent verifier must rebuild
# every representation, frame, point, and rank from scratch at this prime.
HOLDOUT = {
    "p": 199,
    "zeta11": 18,
    "sqrt5": 76,
    "sqrt_minus11": 136,
    "classes": {
        "A5_class_1": {"witness": [141, 180, 170, 70, 138, 170], "alpha": 76},
        "A5_class_2": {"witness": [39, 25, 181, 57, 69, 50], "alpha": 120},
    },
}


def import_file(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


erc = import_file("a5q_rank_exact_representation_core", CORE_PATH)
exact_reynolds = import_file("a5q_rank_exact_reynolds", EXACT_REYNOLDS_PATH)


def mm(left, right):
    return [
        [sum(left[i][k] * right[k][j] for k in range(len(right))) % P
         for j in range(len(right[0]))]
        for i in range(len(left))
    ]


def mv(matrix, vector):
    return [sum(a * b for a, b in zip(row, vector)) % P for row in matrix]


def identity(size):
    return [[int(i == j) for j in range(size)] for i in range(size)]


def inverse(matrix):
    size = len(matrix)
    work = [
        [entry % P for entry in row] + [int(i == j) for j in range(size)]
        for i, row in enumerate(matrix)
    ]
    for column in range(size):
        pivot = next((row for row in range(column, size) if work[row][column]), None)
        assert pivot is not None
        work[column], work[pivot] = work[pivot], work[column]
        unit = pow(work[column][column], -1, P)
        work[column] = [unit * entry % P for entry in work[column]]
        for row in range(size):
            if row == column:
                continue
            scalar = work[row][column]
            if scalar:
                work[row] = [(a - scalar * b) % P
                             for a, b in zip(work[row], work[column])]
    return [row[size:] for row in work]


def determinant(matrix):
    size = len(matrix)
    assert size and all(len(row) == size for row in matrix)
    work = [[entry % P for entry in row] for row in matrix]
    answer = 1
    for column in range(size):
        pivot = next((row for row in range(column, size) if work[row][column]), None)
        if pivot is None:
            return 0
        if pivot != column:
            work[column], work[pivot] = work[pivot], work[column]
            answer = -answer
        value = work[column][column] % P
        answer = answer * value % P
        inverse_value = pow(value, -1, P)
        for row in range(column + 1, size):
            scalar = work[row][column] * inverse_value % P
            if scalar:
                work[row] = [(a - scalar * b) % P
                             for a, b in zip(work[row], work[column])]
    return answer % P


def rref(matrix):
    work = [[entry % P for entry in row] for row in matrix]
    rows, columns = len(work), len(work[0])
    pivots = []
    pivot_row = 0
    for column in range(columns):
        pivot = next((row for row in range(pivot_row, rows) if work[row][column]), None)
        if pivot is None:
            continue
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        unit = pow(work[pivot_row][column], -1, P)
        work[pivot_row] = [unit * entry % P for entry in work[pivot_row]]
        for row in range(rows):
            if row == pivot_row:
                continue
            scalar = work[row][column]
            if scalar:
                work[row] = [(a - scalar * b) % P
                             for a, b in zip(work[row], work[pivot_row])]
        pivots.append(column)
        pivot_row += 1
        if pivot_row == rows:
            break
    return work, pivots


def nullspace(matrix):
    reduced, pivots = rref(matrix)
    columns = len(matrix[0])
    free = [column for column in range(columns) if column not in pivots]
    answer = []
    for free_column in free:
        vector = [0] * columns
        vector[free_column] = 1
        for row, pivot in reversed(list(enumerate(pivots))):
            vector[pivot] = -sum(
                reduced[row][column] * vector[column] for column in free
            ) % P
        answer.append(vector)
    return answer


def rank(matrix):
    return len(rref(matrix)[1])


def projective(vector):
    pivot = next(entry % P for entry in vector if entry % P)
    unit = pow(pivot, -1, P)
    return [entry * unit % P for entry in vector]


def reduce_fraction(value):
    value = Fraction(value)
    return value.numerator * pow(value.denominator, -1, P) % P


def reduce_domain_matrix(matrix):
    return [[erc.reduce_k11(entry, ZETA11, P) for entry in row]
            for row in matrix.to_list()]


GROUP, WORDS = erc.abstract_group()
WEIL_S, WEIL_T = erc.weil_generators()
SCHUR_A, SCHUR_B = erc.schur_generators()
SCHUR_S = erc.matrix_word(
    erc.WEIL_TO_PFAFFIAN["S"], {"A": SCHUR_A, "B": SCHUR_B}, 6
)
SCHUR_T = erc.matrix_word(
    erc.WEIL_TO_PFAFFIAN["T"], {"A": SCHUR_A, "B": SCHUR_B}, 6
)


def matrix_word(word, generators, size):
    answer = identity(size)
    for letter in word:
        answer = mm(answer, generators[letter])
    return answer


WEIL = {
    element: matrix_word(
        WORDS[element], {"S": reduce_domain_matrix(WEIL_S), "T": reduce_domain_matrix(WEIL_T)}, 5
    )
    for element in GROUP
}
SCHUR = {
    element: matrix_word(
        WORDS[element], {"S": reduce_domain_matrix(SCHUR_S), "T": reduce_domain_matrix(SCHUR_T)}, 6
    )
    for element in GROUP
}
WEIL_INVERSE = {element: inverse(matrix) for element, matrix in WEIL.items()}


TWISTS = json.loads(TWISTS_PATH.read_text())
RECORDS = {record["label"]: record for record in TWISTS["records"]}
RAW = json.loads(RAW_PATH.read_text())["covariants"]


def group_element(data):
    return erc.fcanon(tuple(data))


def pc(left, right):
    return tuple(left[right[i]] for i in range(len(left)))


def source_a5():
    permutation_identity = tuple(range(5))
    inv2 = pow(2, -1, P)
    scalar = -(1 + SQRT5) * inv2 % P
    g5, g3 = (1, 2, 3, 4, 0), (0, 1, 3, 4, 2)
    m5 = [[scalar, -scalar % P, -1 % P], [scalar, 1, 0], [scalar, -scalar % P, 0]]
    m3 = [[0, -1 % P, -scalar % P], [0, 0, 1], [-1 % P, -scalar % P, 0]]
    answer = {permutation_identity: identity(3)}
    queue = [permutation_identity]
    while queue:
        current = queue.pop(0)
        for generator, matrix in ((g5, m5), (g3, m3)):
            candidate = pc(current, generator)
            candidate_matrix = mm(answer[current], matrix)
            if candidate in answer:
                assert answer[candidate] == candidate_matrix
            else:
                answer[candidate] = candidate_matrix
                queue.append(candidate)
    assert len(answer) == 60
    return answer


SOURCE_A5 = source_a5()


def subgroup_data(record):
    permutation_of = {
        group_element(row["h"]): tuple(row["permutation"])
        for row in record["source_map"]
    }
    subgroup = frozenset(group_element(row) for row in record["subgroup_elements"])
    sigma = {h: SOURCE_A5[permutation_of[h]] for h in subgroup}
    return subgroup, permutation_of, sigma


def canonical_coset_representatives(subgroup):
    uncovered = set(GROUP)
    representatives = []
    for representative in GROUP:
        if representative not in uncovered:
            continue
        coset = {erc.fcanon(erc.fmul(h, representative)) for h in subgroup}
        representatives.append(representative)
        uncovered -= coset
    assert not uncovered and len(representatives) == 11
    return representatives


def modular_intertwiner(record):
    _subgroup, permutation_of, _sigma = subgroup_data(record)
    rows = []
    for generator_data in record["generators"]:
        generator = group_element(generator_data)
        rho = WEIL[generator]
        abstract = [[entry % P for entry in row]
                    for row in exact_reynolds.EXACT_TARGET[permutation_of[generator]]]
        for i in range(5):
            for j in range(5):
                equation = [0] * 25
                for k in range(5):
                    equation[5 * k + j] += rho[i][k]
                    equation[5 * i + k] -= abstract[k][j]
                rows.append([entry % P for entry in equation])
    kernel = nullspace(rows)
    assert len(kernel) == 1
    matrix = [kernel[0][5 * row:5 * row + 5] for row in range(5)]
    assert determinant(matrix)
    return matrix


def hilbert_frame(record, vector):
    subgroup, _permutation_of, sigma = subgroup_data(record)
    answer = [[0] * 3 for _ in range(3)]
    for h in subgroup:
        scalar = pow(mv(SCHUR[h], vector)[5], 4, P)
        inverse_sigma = inverse(sigma[h])
        for i in range(3):
            for j in range(3):
                answer[i][j] = (answer[i][j] + scalar * inverse_sigma[i][j]) % P
    return answer


def schur_frame(vector):
    answer = [[0] * 5 for _ in range(5)]
    invariant = 0
    for g in GROUP:
        scalar = pow(mv(SCHUR[g], vector)[5], 8, P)
        invariant = (invariant + scalar) % P
        inverse_rho = WEIL_INVERSE[g]
        for i in range(5):
            for j in range(5):
                answer[i][j] = (answer[i][j] + scalar * inverse_rho[i][j]) % P
    return answer, invariant


def reduce_q5(coefficient):
    rational = Fraction(*coefficient["rational"])
    radical = Fraction(*coefficient["sqrt5"])
    return (reduce_fraction(rational) + SQRT5 * reduce_fraction(radical)) % P


def evaluate_covariant(covariant, y):
    answer = []
    for component in covariant:
        value = 0
        for exponent_text, coefficient in component.items():
            exponent = tuple(map(int, exponent_text.split(",")))
            term = reduce_q5(coefficient)
            for coordinate, power in zip(y, exponent):
                term = term * pow(coordinate, power, P) % P
            value = (value + term) % P
        answer.append(value)
    return answer


def constant_relations(label):
    payload = json.loads((A5_ROOT / label / "point.json").read_text())
    basis = (1, SQRT5, 73, SQRT5 * 73 % P)
    return {
        name: sum(reduce_fraction(value) * base for value, base in zip(values, basis)) % P
        for name, values in payload["closed_point_relations"].items()
    }


def alpha_data(label):
    relations = constant_relations(label)
    p2, p1, p0 = (relations[name] for name in ("p2", "p1", "p0"))
    roots = [a for a in range(P) if (a**3 + p2 * a**2 + p1 * a + p0) % P == 0]
    return relations, [p0, p1, p2, 1], roots


def landing_parameter(relations, alpha):
    return [1] + [
        sum(relations[f"a{coordinate}_{degree}"] * pow(alpha, degree, P)
            for degree in range(3)) % P
        for coordinate in (1, 2, 3)
    ] + [alpha]


def point_map(y, parameter, intertwiner):
    columns = [evaluate_covariant(covariant, y) for covariant in RAW]
    canonical = [
        sum(parameter[column] * columns[column][row] for column in range(5)) % P
        for row in range(5)
    ]
    return canonical, mv(intertwiner, canonical)


def klein(vector):
    return sum(vector[i] * vector[i] * vector[(i + 1) % 5] for i in range(5)) % P


QUADRATIC_MONOMIALS = list(itertools.combinations_with_replacement(range(5), 2))


def quadratic_rows(points):
    return [[point[i] * point[j] % P for i, j in QUADRATIC_MONOMIALS]
            for point in points]


def polynomial_from_roots(roots):
    coefficients = [1]
    for root in roots:
        new = [0] * (len(coefficients) + 1)
        for degree, coefficient in enumerate(coefficients):
            new[degree] = (new[degree] - root * coefficient) % P
            new[degree + 1] = (new[degree + 1] + coefficient) % P
        coefficients = new
    return coefficients


def companion(coefficients):
    answer = [[0] * 11 for _ in range(11)]
    for column in range(10):
        answer[column + 1][column] = 1
    for row in range(11):
        answer[row][10] = -coefficients[row] % P
    return answer


def digest(path):
    return sha256(path.read_bytes()).hexdigest()


def holdout_class_seed(label):
    selection = HOLDOUT["classes"][label]
    return {
        "subgroup_order": 60,
        "index": 11,
        "maps": {
            "canonical_quartic": {
                "seed": {
                    "degree": 4,
                    "source_coordinate": 5,
                    "target_basis_column": 0,
                    "formula": "B(v)=sum_h sigma(h)^(-1)*((rho6(h)v)_5)^4; Y=B(v)e0",
                },
                "witness": selection["witness"],
                "branches": [{
                    "alpha": selection["alpha"],
                    "tau": {
                        "definition": "P0/P2",
                        "numerator_form": {"coordinate": 0},
                        "denominator_form": {"coordinate": 2},
                    },
                }],
            },
        },
    }


def produce_class(label):
    record = RECORDS[label]
    selection = CLASS_SELECTION[label]
    witness = selection["witness"]
    alpha = selection["alpha"]
    subgroup, _permutation_of, sigma = subgroup_data(record)
    representatives = canonical_coset_representatives(subgroup)

    b_frame = hilbert_frame(record, witness)
    b_det = determinant(b_frame)
    assert b_det
    y = [row[0] for row in b_frame]
    h_orbit = {tuple(projective(mv(sigma[h], y))) for h in subgroup}
    assert len(h_orbit) == 60
    g_orbit = {tuple(projective(mv(SCHUR[g], witness))) for g in GROUP}
    assert len(g_orbit) == 660

    q_frame, i8 = schur_frame(witness)
    q_det = determinant(q_frame)
    assert q_det and i8
    q_inverse = inverse(q_frame)
    intertwiner = modular_intertwiner(record)
    relations, alpha_polynomial, roots = alpha_data(label)
    assert alpha in roots
    parameter = landing_parameter(relations, alpha)

    points = []
    phi_at_cosets = []
    for representative in representatives:
        moved = mv(SCHUR[representative], witness)
        moved_b = hilbert_frame(record, moved)
        moved_y = [row[0] for row in moved_b]
        phi, installed = point_map(moved_y, parameter, intertwiner)
        assert any(phi) and any(installed) and klein(installed) == 0
        common = mv(WEIL_INVERSE[representative], installed)
        point = mv(q_inverse, common)
        assert any(point) and klein(mv(q_frame, point)) == 0
        points.append(projective(point))
        phi_at_cosets.append(phi)
    assert len({tuple(point) for point in points}) == 11
    assert rank(points) == 5

    products = quadratic_rows(points)
    assert rank(products) == 11
    columns = list(range(11))
    minor = [[row[column] for column in columns] for row in products]
    minor_det = determinant(minor)
    assert minor_det

    # The requested primitive element is tau=P_0/P_2 in the common Q-frame.
    tau_values = []
    for point in points:
        assert point[2]
        tau_values.append(point[0] * pow(point[2], -1, P) % P)
    assert len(set(tau_values)) == 11
    orbit_polynomial = polynomial_from_roots(tau_values)
    trace = sum(tau_values) % P
    norm = 1
    for value in tau_values:
        norm = norm * value % P

    return {
        "subgroup_order": 60,
        "index": 11,
        "coset_representatives_ST": [WORDS[representative] for representative in representatives],
        "alpha_polynomial": {"ascending": alpha_polynomial},
        "alpha_roots": roots,
        "maps": {
            "canonical_quartic": {
                "seed": {
                    "degree": 4,
                    "source_coordinate": 5,
                    "target_basis_column": 0,
                    "formula": "B(v)=sum_h sigma(h)^(-1)*((rho6(h)v)_5)^4; Y=B(v)e0",
                    "covariance": "B(rho6(h)v)=sigma(h)B(v)",
                },
                "witness": witness,
                # The independent verifier reconstructs and asserts the
                # 660-point orbit directly.  It is not serialized because
                # scalar finite-field comparison is reserved for F_p data.
                "B_at_witness": b_frame,
                "B_det": b_det,
                "Y_at_witness": y,
                "projective_H_orbit_size": len(h_orbit),
                "Q_det": q_det,
                "I8": i8,
                "branches": [{
                    "alpha": alpha,
                    "parameter": parameter,
                    "Phi_at_identity": phi_at_cosets[0],
                    "Phi_nonzero": True,
                    "klein_value": 0,
                    "points_semantics": "11x5 projective rows in the common Q(v) frame, ordered by coset_representatives_ST and normalized by first nonzero coordinate=1",
                    "points": points,
                    "point_rank": 5,
                    "quadratic_rank": 11,
                    "minor": {
                        "rows": list(range(11)),
                        "columns": columns,
                        "monomials": [list(QUADRATIC_MONOMIALS[column]) for column in columns],
                        "det": minor_det,
                    },
                    "tau": {
                        "definition": "P0/P2",
                        "numerator_form": {"coordinate": 0},
                        "denominator_form": {"coordinate": 2},
                        "values": tau_values,
                        "orbit_polynomial_ascending": orbit_polynomial,
                        "trace": trace,
                        "norm": norm,
                        "companion": companion(orbit_polynomial),
                    },
                }],
            }
        },
    }


def main():
    assert P not in (2, 3, 5, 11)
    assert pow(ZETA11, 11, P) == 1 and all(pow(ZETA11, degree, P) != 1 for degree in range(1, 11))
    assert SQRT5 * SQRT5 % P == 5
    gauss = sum((1 if exponent in {1, 3, 4, 5, 9} else -1) * pow(ZETA11, exponent, P)
                for exponent in range(1, 11)) % P
    assert gauss == 73 and gauss * gauss % P == -11 % P

    inputs = [CORE_PATH, FRAME_PATH, TWISTS_PATH, RAW_PATH,
              A5_ROOT / "common/degree11_reconstructed_relations.json",
              A5_ROOT / "A5_class_1/point.json", A5_ROOT / "A5_class_2/point.json"]
    payload = {
        "format": "a5q-canonical-quartic-rank-witness-v1",
        "theorem_boundary": (
            "A nonzero good-reduction rank-11 minor proves that each selected exact "
            "degree-eleven cycle is not interpolated by a basepoint-free degree-four "
            "map. It is scoped to these canonical quartic specializations."
        ),
        "inputs": [
            {"path": str(path.relative_to(ROOT)), "sha256": digest(path)}
            for path in inputs
        ],
        "primes": [{
            "p": P,
            "role": "primary good-reduction nonvanishing witness",
            "zeta11": ZETA11,
            "sqrt5": SQRT5,
            "sqrt_minus11": gauss,
            "group_order_invertible": 660 % P != 0,
            "quadratic_monomial_order": [list(monomial) for monomial in QUADRATIC_MONOMIALS],
            "classes": {
                label: produce_class(label)
                for label in ("A5_class_1", "A5_class_2")
            },
        }, {
            "p": HOLDOUT["p"],
            "role": "unused holdout; seed data only, all outcomes reconstructed by independent verifier",
            "zeta11": HOLDOUT["zeta11"],
            "sqrt5": HOLDOUT["sqrt5"],
            "sqrt_minus11": HOLDOUT["sqrt_minus11"],
            "group_order_invertible": True,
            "classes": {
                label: holdout_class_seed(label)
                for label in ("A5_class_1", "A5_class_2")
            },
        }],
    }
    OUTPUT_PATH.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    for label, record in payload["primes"][0]["classes"].items():
        selected = record["maps"]["canonical_quartic"]
        branch = selected["branches"][0]
        print(
            label,
            "Bdet", selected["B_det"],
            "Qdet", selected["Q_det"],
            "alpha", branch["alpha"],
            "rank", branch["quadratic_rank"],
            "minor", branch["minor"]["det"],
            "tau", branch["tau"]["values"],
        )
    print("wrote", OUTPUT_PATH)
    print("A5Q_RANK_WITNESS_PRODUCER_OK")


if __name__ == "__main__":
    main()
