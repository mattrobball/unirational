#!/usr/bin/env python3
"""Exact small-matrix core for the Pfaffian representation alignment.

The only characteristic-zero coefficient field used for the linear
alignment is Q(zeta_11).  The two 12-dimensional ordinary constituents of
End(V6) have character field Q(sqrt(5)); they are certified independently as
the two principal-series inductions from the Borel quotient C5.
"""

from __future__ import annotations

from collections import Counter, deque
from hashlib import sha256
from itertools import combinations
from pathlib import Path
from typing import Iterable

from sympy.polys.domains import QQ
from sympy.polys.matrices import DomainMatrix


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]

P = 23
PAIR_INDEX = tuple(combinations(range(6), 2))

# Uppercase words use the standard repository Weil generators S,T.
# Uppercase A,B denote the projective images of the supporting Pfaffian
# matrices m1,m2.  Products are read left to right as right matrix products.
PFAFFIAN_TO_WEIL = {
    "A": "TSTS",
    "B": "TTTTTTTTS",  # T^8 S
}
WEIL_TO_PFAFFIAN = {
    "S": "BABAB",
    "T": "AABABAB",
}

SOURCE_PATHS = (
    "certificates/exact_weil_check.py",
    "certificates/exact_covariants_check.py",
    "certificates/modular_covariant_scan.py",
    "tmp/fano14_twist/fano_covariant_scan.py",
    "tmp/fano14_twist/REPORT.md",
    "tmp/fano14_degree12/fano_module_hilbert.py",
    "tmp/fano14_degree12/REPORT.md",
    "tmp/pfaffian_explicit_descent/certificate.json",
    "tmp/pfaffian_explicit_descent/REPORT.md",
    "tmp/generic_twist/phi_coefficients.py",
    "tmp/xcd_invariant_field/f10_probe/reconstruct_generators.py",
    "tmp/kproj_arithmetic/core.py",
    "tmp/kproj_arithmetic/model.py",
    "tmp/kproj_arithmetic/certificate.json",
    "tmp/kproj_connection/certificate.json",
)

PRIMARY_SOURCE = {
    "url": (
        "https://raw.githubusercontent.com/zhijiazhangz/"
        "zhijiazhangz.github.io/main/pfaffian/PSL211"
    ),
    "sha256": "1221bfb1d0c93dd517d78bee9153c43d9134c5746312d419170e7d733f6f4eb3",
    "bytes": 39985,
}


def file_sha256(path: Path) -> str:
    digest = sha256()
    with path.open("rb") as handle:
        while chunk := handle.read(1 << 20):
            digest.update(chunk)
    return digest.hexdigest()


def source_hashes() -> dict[str, str]:
    return {relative: file_sha256(ROOT / relative) for relative in SOURCE_PATHS}


# ---------------------------------------------------------------------------
# Abstract PSL_2(F_11), represented by determinant-one 2 x 2 matrices modulo
# the central signs.  These routines make the generator-word identification
# independent of either five- or six-dimensional matrix realization.


F2 = tuple[int, int, int, int]


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


def finv(matrix: F2) -> F2:
    return fcanon((matrix[3], -matrix[1], -matrix[2], matrix[0]))


FONE = fcanon((1, 0, 0, 1))
FS = fcanon((0, 2, 5, 0))
FT = fcanon((1, 2, 0, 1))


def fpow(matrix: F2, exponent: int) -> F2:
    result = FONE
    while exponent:
        if exponent & 1:
            result = fcanon(fmul(result, matrix))
        matrix = fcanon(fmul(matrix, matrix))
        exponent //= 2
    return result


def forder(matrix: F2) -> int:
    result = FONE
    for exponent in range(1, 100):
        result = fcanon(fmul(result, matrix))
        if result == FONE:
            return exponent
    raise AssertionError("order exceeded safe PSL_2(F_11) bound")


def feval(word: str, generators: dict[str, F2]) -> F2:
    result = FONE
    for letter in word:
        result = fcanon(fmul(result, generators[letter]))
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


def abstract_alignment() -> dict:
    image_a = feval(PFAFFIAN_TO_WEIL["A"], {"S": FS, "T": FT})
    image_b = feval(PFAFFIAN_TO_WEIL["B"], {"S": FS, "T": FT})
    recovered_s = feval(
        WEIL_TO_PFAFFIAN["S"], {"A": image_a, "B": image_b}
    )
    recovered_t = feval(
        WEIL_TO_PFAFFIAN["T"], {"A": image_a, "B": image_b}
    )
    assert recovered_s == FS
    assert recovered_t == FT
    assert forder(image_a) == 3
    assert forder(image_b) == 5
    assert forder(fcanon(fmul(image_a, image_b))) == 11
    group, _ = abstract_group()
    generated = {FONE}
    queue = deque([FONE])
    while queue:
        current = queue.popleft()
        for generator in (image_a, image_b):
            candidate = fcanon(fmul(current, generator))
            if candidate not in generated:
                generated.add(candidate)
                queue.append(candidate)
    assert len(generated) == len(group) == 660
    return {
        "pfaffian_to_weil": dict(PFAFFIAN_TO_WEIL),
        "weil_to_pfaffian": dict(WEIL_TO_PFAFFIAN),
        "orders_A_B_AB": [3, 5, 11],
        "generated_projective_order": 660,
    }


# ---------------------------------------------------------------------------
# Exact Q(zeta_11) matrices.


K11 = QQ.cyclotomic_field(11)
ZETA11 = K11.unit
KZERO = K11.zero
KONE = K11.one


def dm(rows: list[list], domain=K11) -> DomainMatrix:
    return DomainMatrix(rows, (len(rows), len(rows[0])), domain)


def identity(size: int, domain=K11) -> DomainMatrix:
    return DomainMatrix(
        [
            [domain.one if row == column else domain.zero for column in range(size)]
            for row in range(size)
        ],
        (size, size),
        domain,
    )


def matrix_power(matrix: DomainMatrix, exponent: int) -> DomainMatrix:
    result = identity(matrix.shape[0], matrix.domain)
    while exponent:
        if exponent & 1:
            result = result.matmul(matrix)
        matrix = matrix.matmul(matrix)
        exponent //= 2
    return result


def matrix_word(
    word: str, generators: dict[str, DomainMatrix], size: int
) -> DomainMatrix:
    result = identity(size, next(iter(generators.values())).domain)
    for letter in word:
        result = result.matmul(generators[letter])
    return result


def matrix_trace(matrix: DomainMatrix):
    entries = matrix.to_list()
    return sum(entries[index][index] for index in range(matrix.shape[0]))


def scalar_matrix(scalar, size: int, domain=K11) -> DomainMatrix:
    return dm(
        [
            [scalar if row == column else domain.zero for column in range(size)]
            for row in range(size)
        ],
        domain,
    )


def weil_generators() -> tuple[DomainMatrix, DomainMatrix]:
    quadratic_residues = {1, 3, 4, 5, 9}
    gauss = sum(
        (KONE if exponent in quadratic_residues else -KONE) * ZETA11**exponent
        for exponent in range(1, 11)
    )
    assert gauss * gauss == K11(-11)
    indices = [1, 3, 2, 5, 4]
    signs = [1, 1, -1, 1, 1]
    first = dm(
        [
            [
                (K11(signs[column]) / K11(signs[row]))
                * (
                    ZETA11 ** ((9 * left * right) % 11)
                    - ZETA11 ** ((-9 * left * right) % 11)
                )
                * (-gauss)
                / K11(11)
                for column, right in enumerate(indices)
            ]
            for row, left in enumerate(indices)
        ]
    )
    second = dm(
        [
            [
                ZETA11 ** ((indices[row] * indices[row]) % 11)
                if row == column
                else KZERO
                for column in range(5)
            ]
            for row in range(5)
        ]
    )
    assert matrix_power(first, 2) == identity(5)
    assert matrix_power(second, 11) == identity(5)
    assert matrix_power(first.matmul(second), 3) == identity(5)
    return first, second


def schur_generators() -> tuple[DomainMatrix, DomainMatrix]:
    c = ZETA11**9 + ZETA11**5 + ZETA11**4 + ZETA11**3 + ZETA11
    first = dm(
        [
            [KZERO, c, -KONE, KONE, KZERO, KZERO],
            [KZERO, c + KONE, KZERO, -c, -KONE, KZERO],
            [KZERO, c - KONE, KZERO, KONE, KZERO, KONE],
            [KZERO, c + K11(2), KZERO, -c - KONE, KZERO, KZERO],
            [KZERO, KONE, KZERO, -KONE, KZERO, KZERO],
            [-KONE, K11(2), KZERO, -KONE, KZERO, KZERO],
        ]
    )
    second = dm(
        [
            [KONE, -KONE, KZERO, KZERO, KZERO, KZERO],
            [KONE, KZERO, KZERO, -KONE, KZERO, KZERO],
            [c + KONE, KZERO, -KONE, KZERO, KZERO, KZERO],
            [KONE, KZERO, KZERO, KZERO, -KONE, KZERO],
            [KONE, KZERO, KZERO, KZERO, KZERO, KZERO],
            [-c, KZERO, KZERO, KZERO, KZERO, -KONE],
        ]
    )
    assert matrix_power(first, 3) == identity(6)
    assert matrix_power(second, 5) == scalar_matrix(-KONE, 6)
    assert matrix_power(first.matmul(second), 11) == scalar_matrix(-KONE, 6)
    return first, second


def exterior_square(matrix: DomainMatrix) -> DomainMatrix:
    entries = matrix.to_list()
    return dm(
        [
            [
                entries[row_a][column_a] * entries[row_b][column_b]
                - entries[row_a][column_b] * entries[row_b][column_a]
                for column_a, column_b in PAIR_INDEX
            ]
            for row_a, row_b in PAIR_INDEX
        ]
    )


def alignment_system() -> tuple[DomainMatrix, tuple[DomainMatrix, ...]]:
    weil_s, weil_t = weil_generators()
    schur_a, schur_b = schur_generators()
    action_a = exterior_square(schur_a.inv().transpose())
    action_b = exterior_square(schur_b.inv().transpose())
    image_a = matrix_word(PFAFFIAN_TO_WEIL["A"], {"S": weil_s, "T": weil_t}, 5)
    image_b = matrix_word(PFAFFIAN_TO_WEIL["B"], {"S": weil_s, "T": weil_t}, 5)

    rows = []
    for ambient, source in ((action_a, image_a), (action_b, image_b)):
        ambient_entries = ambient.to_list()
        source_entries = source.to_list()
        for ambient_row in range(15):
            for source_column in range(5):
                equation = [KZERO] * 75
                for ambient_inner in range(15):
                    equation[5 * ambient_inner + source_column] += ambient_entries[
                        ambient_row
                    ][ambient_inner]
                for source_inner in range(5):
                    equation[5 * ambient_row + source_inner] -= source_entries[
                        source_inner
                    ][source_column]
                rows.append(equation)
    return dm(rows), (action_a, action_b, image_a, image_b)


def normalized_intertwiner() -> tuple[DomainMatrix, int]:
    system, actions = alignment_system()
    kernel = system.nullspace()
    assert kernel.shape == (1, 75)
    vector = kernel.to_list()[0]
    first_nonzero = next(entry for entry in vector if entry)
    vector = [entry / first_nonzero for entry in vector]
    embedding = dm([vector[5 * row : 5 * row + 5] for row in range(15)])
    action_a, action_b, image_a, image_b = actions
    assert action_a.matmul(embedding) == embedding.matmul(image_a)
    assert action_b.matmul(embedding) == embedding.matmul(image_b)
    assert embedding.rank() == 5
    return embedding, kernel.shape[0]


def coefficients(element, degree: int) -> list[list[int]]:
    """Ascending power-basis coefficients as [numerator,denominator]."""
    raw = list(reversed(element.to_list()))
    raw += [QQ.zero] * (degree - len(raw))
    assert len(raw) == degree
    return [[int(value.numerator), int(value.denominator)] for value in raw]


def from_coefficients(data: list[list[int]], domain) -> object:
    result = domain.zero
    power = domain.one
    for numerator, denominator in data:
        result += domain(numerator) / domain(denominator) * power
        power *= domain.unit
    return result


def serialize_matrix(matrix: DomainMatrix, degree: int) -> list:
    return [
        [coefficients(entry, degree) for entry in row] for row in matrix.to_list()
    ]


def deserialize_matrix(data: list, domain=K11) -> DomainMatrix:
    return DomainMatrix(
        [
            [from_coefficients(entry, domain) for entry in row]
            for row in data
        ],
        (len(data), len(data[0])),
        domain,
    )


def reduce_k11(element, zeta_value: int = 2, modulus: int = P) -> int:
    total = 0
    for exponent, (numerator, denominator) in enumerate(coefficients(element, 10)):
        total += (
            numerator
            * pow(denominator, -1, modulus)
            * pow(zeta_value, exponent, modulus)
        )
    return total % modulus


def modular_rank(matrix: list[list[int]], modulus: int = P) -> int:
    reduced = [row[:] for row in matrix]
    rows = len(reduced)
    columns = len(reduced[0])
    pivot_row = 0
    for column in range(columns):
        pivot = next(
            (row for row in range(pivot_row, rows) if reduced[row][column] % modulus),
            None,
        )
        if pivot is None:
            continue
        reduced[pivot_row], reduced[pivot] = reduced[pivot], reduced[pivot_row]
        scale = pow(reduced[pivot_row][column] % modulus, -1, modulus)
        reduced[pivot_row] = [(value * scale) % modulus for value in reduced[pivot_row]]
        for row in range(rows):
            if row == pivot_row:
                continue
            factor = reduced[row][column] % modulus
            if factor:
                reduced[row] = [
                    (left - factor * right) % modulus
                    for left, right in zip(reduced[row], reduced[pivot_row])
                ]
        pivot_row += 1
        if pivot_row == rows:
            break
    return pivot_row


# ---------------------------------------------------------------------------
# Exact ordinary-character decomposition of End(V6).


def conjugacy_classes() -> tuple[list[tuple[F2, set[F2]]], dict[F2, str]]:
    group, words = abstract_group()
    remaining = set(group)
    classes = []
    while remaining:
        representative = min(remaining, key=lambda x: (len(words[x]), words[x]))
        conjugates = {
            fcanon(fmul(fmul(element, representative), finv(element)))
            for element in group
        }
        remaining -= conjugates
        classes.append((representative, conjugates))
    classes.sort(
        key=lambda item: (forder(item[0]), len(item[1]), words[item[0]])
    )
    assert [(forder(rep), len(cls)) for rep, cls in classes] == [
        (1, 1),
        (2, 55),
        (3, 110),
        (5, 132),
        (5, 132),
        (6, 110),
        (11, 60),
        (11, 60),
    ]
    return classes, words


def p1_fixed_points(matrix: F2) -> int:
    points = [(1, value) for value in range(11)] + [(0, 1)]

    def normalize(vector: tuple[int, int]) -> tuple[int, int]:
        first, second = vector[0] % 11, vector[1] % 11
        if first:
            return (1, second * pow(first, -1, 11) % 11)
        return (0, 1)

    fixed = 0
    for point in points:
        image = (
            matrix[0] * point[0] + matrix[1] * point[1],
            matrix[2] * point[0] + matrix[3] * point[1],
        )
        fixed += normalize(image) == point
    return fixed


def borel_exponent(matrix: F2) -> int:
    assert matrix[2] == 0
    powers = {}
    value = 1
    for exponent in range(10):
        powers[value] = exponent % 5
        value = value * 2 % 11
    return powers[matrix[0]]


def induced_borel_character(
    representative: F2, character_power: int, group: list[F2]
) -> list[int]:
    """Ind_B^G(theta^k), in the basis 1,z5,z5^2,z5^3."""
    borel = {element for element in group if element[2] == 0}
    assert len(borel) == 55
    counts: Counter[int] = Counter()
    for conjugator in group:
        conjugate = fcanon(
            fmul(fmul(finv(conjugator), representative), conjugator)
        )
        if conjugate in borel:
            counts[(character_power * borel_exponent(conjugate)) % 5] += 1
    assert all(counts[exponent] % 55 == 0 for exponent in range(5))
    coefficients5 = [counts[exponent] // 55 for exponent in range(5)]
    # z5^4 = -1-z5-z5^2-z5^3.
    return [coefficients5[index] - coefficients5[4] for index in range(4)]


def integer_k11(element) -> int:
    data = coefficients(element, 10)
    assert all(numerator == 0 for numerator, _ in data[1:]), data
    numerator, denominator = data[0]
    assert denominator == 1
    return numerator


def inner_product(
    left: list, right_inverse: list, sizes: list[int], domain
):
    return sum(
        domain(size) * left_value * right_value
        for size, left_value, right_value in zip(sizes, left, right_inverse)
    ) / domain(660)


def character_decomposition() -> dict:
    classes, words = conjugacy_classes()
    group, _ = abstract_group()
    weil_s, weil_t = weil_generators()
    schur_a, schur_b = schur_generators()
    schur_s = matrix_word(
        WEIL_TO_PFAFFIAN["S"], {"A": schur_a, "B": schur_b}, 6
    )
    schur_t = matrix_word(
        WEIL_TO_PFAFFIAN["T"], {"A": schur_a, "B": schur_b}, 6
    )
    assert matrix_power(schur_s, 2) == scalar_matrix(-KONE, 6)
    assert matrix_power(schur_t, 11) == identity(6)
    assert matrix_power(schur_s.matmul(schur_t), 3) == scalar_matrix(-KONE, 6)

    class_rows = []
    chi_w = []
    chi_w_inverse = []
    chi_end = []
    chi_11 = []
    chi_12a_coefficients = []
    chi_12b_coefficients = []
    for representative, conjugates in classes:
        word = words[representative]
        weil = matrix_word(word, {"S": weil_s, "T": weil_t}, 5)
        schur = matrix_word(word, {"S": schur_s, "T": schur_t}, 6)
        w_value = matrix_trace(weil)
        w_inverse_value = matrix_trace(weil.inv())
        end_value = matrix_trace(schur) * matrix_trace(schur.inv())
        end_w_value = w_value * w_inverse_value
        eleven_value = p1_fixed_points(representative) - 1
        twelve_a = induced_borel_character(representative, 1, group)
        twelve_b = induced_borel_character(representative, 2, group)
        chi_w.append(w_value)
        chi_w_inverse.append(w_inverse_value)
        chi_end.append(end_value)
        chi_11.append(K11(eleven_value))
        chi_12a_coefficients.append(twelve_a)
        chi_12b_coefficients.append(twelve_b)
        class_rows.append(
            {
                "order": forder(representative),
                "size": len(conjugates),
                "shortest_word_ST": word,
                "chi_W_qzeta11": coefficients(w_value, 10),
                "chi_End": integer_k11(end_value),
                "chi_End_W": integer_k11(end_w_value),
                "chi_11": eleven_value,
                "chi_12a_qzeta5": twelve_a,
                "chi_12b_qzeta5": twelve_b,
            }
        )

    inverse_class = []
    for representative, _ in classes:
        inverse = finv(representative)
        inverse_class.append(
            next(
                index
                for index, (_, conjugates) in enumerate(classes)
                if inverse in conjugates
            )
        )
    sizes = [row["size"] for row in class_rows]
    # Since chi_W(g^{-1}) was already recorded at each class, the character
    # norm is sum chi_W(g)chi_W(g^{-1}), without another inversion.
    assert inner_product(chi_w, chi_w_inverse, sizes, K11) == KONE

    K5 = QQ.cyclotomic_field(5)

    def k5(vector: list[int]):
        return from_coefficients([[value, 1] for value in vector], K5)

    end5 = [K5(integer_k11(value)) for value in chi_end]
    end_w5 = [K5(row["chi_End_W"]) for row in class_rows]
    trivial5 = [K5.one] * len(classes)
    eleven5 = [K5(integer_k11(value)) for value in chi_11]
    twelve_a5 = [k5(value) for value in chi_12a_coefficients]
    twelve_b5 = [k5(value) for value in chi_12b_coefficients]
    for index in range(len(classes)):
        assert end5[index] == (
            trivial5[index]
            + eleven5[index]
            + twelve_a5[index]
            + twelve_b5[index]
        )
        assert end_w5[index] == (
            trivial5[index] + twelve_a5[index] + twelve_b5[index]
        )

    characters = {
        "1": trivial5,
        "11": eleven5,
        "12a": twelve_a5,
        "12b": twelve_b5,
    }
    gram = {}
    for left_name, left in characters.items():
        for right_name, right in characters.items():
            right_inverse = [right[index] for index in inverse_class]
            value = inner_product(left, right_inverse, sizes, K5)
            gram[f"{left_name},{right_name}"] = integer_k11(K11.convert(K5.to_sympy(value)))
    assert all(
        value == (1 if left == right else 0)
        for key, value in gram.items()
        for left, right in [key.split(",")]
    )
    assert [row["chi_End"] for row in class_rows] == [36, 0, 0, 1, 1, 0, 3, 3]
    return {
        "class_table": class_rows,
        "decomposition": "End(V6) = 1 + 11 + 12a + 12b",
        "end_W_decomposition": "End(W) = 1 + 12a + 12b",
        "complement_identity": "End(V6) = End(W) + 11 at the character level",
        "dimensions": [1, 11, 12, 12],
        "multiplicities": [1, 1, 1, 1],
        "character_gram": gram,
        "twelve_construction": (
            "12a=Ind_B^G(theta), 12b=Ind_B^G(theta^2), "
            "where B/U=C5 and inverse characters induce the same modules"
        ),
        "twelve_character_field": "Q(zeta_5+zeta_5^-1)=Q(sqrt(5))",
    }


def compute_certificate(include_intertwiner: bool = True) -> dict:
    from end36_frame import compute_end36_frame
    import runpy

    alignment = abstract_alignment()
    exact = {}
    if include_intertwiner:
        embedding, hom_dimension = normalized_intertwiner()
        reduction = [
            [reduce_k11(entry) for entry in row] for row in embedding.to_list()
        ]
        assert modular_rank(reduction) == 5
        fano = runpy.run_path(str(ROOT / "tmp/fano14_twist/fano_covariant_scan.py"))
        upstream_b5, _, _ = fano["representation_data"]()
        joint_span = [
            [int(value) for value in upstream_b5[row].tolist()] + reduction[row]
            for row in range(15)
        ]
        assert modular_rank(joint_span) == 5
        top_minor = dm([embedding.to_list()[row] for row in range(5)]).det()
        assert top_minor
        coefficient_data = serialize_matrix(embedding, 10)
        numerators = [
            abs(numerator)
            for row in coefficient_data
            for entry in row
            for numerator, _ in entry
        ]
        denominators = [
            denominator
            for row in coefficient_data
            for entry in row
            for _, denominator in entry
        ]
        exact = {
            "field": "Q(zeta_11), Phi_11(zeta_11)=0",
            "ambient_basis": [
                f"e{left + 1}^* wedge e{right + 1}^*"
                for left, right in PAIR_INDEX
            ],
            "source_basis": ["x1", "x2", "x3", "x4", "x5"],
            "equations": "Lambda2(m_i^-T) J = J rho(image_i), i=1,2",
            "hom_dimension": hom_dimension,
            "rank": 5,
            "normalization": "first nonzero row-major entry equals 1",
            "coefficient_max_abs_numerator": max(numerators),
            "coefficient_max_denominator": max(denominators),
            "top_five_rows_minor": coefficients(top_minor, 10),
            "embedding_15x5": coefficient_data,
            "good_reduction": {
                "prime": 23,
                "zeta_11": 2,
                "rank": modular_rank(reduction),
                "joint_span_rank_with_upstream_B5": modular_rank(joint_span),
                "matches_upstream_B5": True,
                "matrix": reduction,
            },
        }
    return {
        "format": "pfaffian-representation-alignment-v1",
        "headline": "OPEN",
        "primary_source": dict(PRIMARY_SOURCE),
        "source_hashes": source_hashes(),
        "generator_alignment": alignment,
        "exact_intertwiner": exact,
        "end_v6": character_decomposition(),
        "end36_reynolds_frame": compute_end36_frame(),
        "resource_ceiling_bytes": 2 * 1024**3,
        "achieved": [
            "exact characteristic-zero B5 alignment",
            "exact multiplicity-free ordinary-character decomposition of End(V6)",
            "explicit degree-at-most-eight generic K_proj vector-space frame for the descended algebra",
        ],
        "not_constructed": [
            "the generic degree-six descent algebra over K_proj",
            "an explicit symplectic involution on that descended algebra",
            "a reduced-rank-two Morita idempotent",
            "a quaternion symbol over K_proj",
            "five global Hermitian matrices",
            "a simultaneous common isotropic right line",
        ],
    }
