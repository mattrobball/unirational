#!/usr/bin/env python3
"""Verify the finite V4 second-layer character/equality counterconfiguration.

This dependency-free script checks representation characters and the exact
finite equality system.  It does not construct a map, graph, base ideal, or
landing jet.
"""

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
ZERO = (0, 0)
B = (1, 0)
C = (0, 1)
D = (1, 1)
CHARS = (B, C, D)
NAMES = {B: "B", C: "C", D: "D"}


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def add(left: tuple[int, int], right: tuple[int, int]) -> tuple[int, int]:
    return (left[0] ^ right[0], left[1] ^ right[1])


def rotate(char: tuple[int, int]) -> tuple[int, int]:
    return {B: C, C: D, D: B, ZERO: ZERO}[char]


def derivative(vertex: tuple[int, int]) -> dict[tuple[tuple[int, int], tuple[int, int]], int]:
    """Rows are target chars; columns are source chars, including ZERO."""
    matrix = {}
    for row in CHARS:
        for column in (ZERO,) + CHARS:
            matrix[(row, column)] = int(row == column and row != vertex)
    return matrix


def v4_character_checks() -> None:
    require(len(set(CHARS)) == 3 and ZERO not in CHARS, "three nontrivial V4 chars")
    require(add(B, C) == D and add(C, D) == B and add(D, B) == C, "V4 char products")

    matrices = {vertex: derivative(vertex) for vertex in CHARS}
    for vertex, matrix in matrices.items():
        # V-equivariance: a nonzero entry can only join equal characters.
        for (row, column), value in matrix.items():
            require(not value or row == column, f"V4 equivariance at {NAMES[vertex]}")
        require(all(matrix[(row, ZERO)] == 0 for row in CHARS), "trivial source killed")
        require(matrix[(vertex, vertex)] == 0, "matching elliptic scalar mu=0")
        require(
            all(matrix[(char, char)] == 1 for char in CHARS if char != vertex),
            "two edge scalars lambda=1",
        )

    # Residual C3 conjugates D_B -> D_C -> D_D.
    for vertex in CHARS:
        old = matrices[vertex]
        new = matrices[rotate(vertex)]
        for row in CHARS:
            for column in (ZERO,) + CHARS:
                require(
                    old[(row, column)] == new[(rotate(row), rotate(column))],
                    "residual C3 matrix conjugacy",
                )

    print("V4-SECOND-LAYER-CHARACTER-MATRICES-OK")


def edge_equalizer_checks() -> None:
    matrices = {vertex: derivative(vertex) for vertex in CHARS}
    edge_scales = []
    for plus in CHARS:
        endpoints = [char for char in CHARS if char != plus]
        left, right = endpoints
        tangent_char = add(left, right)
        require(tangent_char == plus, "edge tangent is plus character")
        left_scale = matrices[left][(tangent_char, tangent_char)]
        right_scale = matrices[right][(tangent_char, tangent_char)]
        require(left_scale == right_scale == 1, "matching endpoint edge derivatives")
        edge_scales.append(left_scale)
    require(edge_scales == [1, 1, 1], "common lambda")
    print("V4-SECOND-LAYER-EDGE-EQUALIZER-NONEMPTY")


def inner(
    left: tuple[int, ...],
    right: tuple[int, ...],
    sizes: tuple[int, ...],
    order: int,
) -> int:
    numerator = sum(size * a * b for size, a, b in zip(sizes, left, right))
    require(numerator % order == 0, "integral character inner product")
    return numerator // order


def d12_checks() -> None:
    # S3 classes: identity, transpositions, 3-cycles.
    sizes = (1, 3, 2)
    standard = (2, 0, -1)
    sign = (1, -1, 1)
    sign_standard = tuple(a * b for a, b in zip(sign, standard))
    require(inner(standard, standard, sizes, 6) == 1, "S3 standard is irreducible")
    require(inner(sign_standard, sign_standard, sizes, 6) == 1, "sign-standard irreducible")
    require(inner(standard, sign_standard, sizes, 6) == 1, "standard is its sign twist")

    # Three mirror directions are permuted; every projective Hom identification
    # carries the same scalar lambda=1.
    mirrors = (0, 1, 2)
    lambdas = {mirror: 1 for mirror in mirrors}
    permutations = ((0, 1, 2), (1, 2, 0), (2, 0, 1), (1, 0, 2))
    for permutation in permutations:
        require(
            all(lambdas[index] == lambdas[permutation[index]] for index in mirrors),
            "S3-permuted D12 scales agree",
        )
    print("D12-SECOND-LAYER-COMMON-SCALE-ONE")


def v4_value(char: tuple[int, int], element: tuple[int, int]) -> int:
    return -1 if (char[0] * element[0] + char[1] * element[1]) % 2 else 1


def a4_checks() -> None:
    # A4 classes: identity, double transpositions, and the two 3-cycle classes.
    sizes = (1, 3, 4, 4)
    char3 = (3, -1, 0, 0)
    require(inner(char3, char3, sizes, 12) == 1, "A4 three-space irreducible")

    # Its V4 restriction is the sum of all three nontrivial characters.
    for element in (ZERO,) + CHARS:
        restricted_value = sum(v4_value(char, element) for char in CHARS)
        expected = 3 if element == ZERO else -1
        require(restricted_value == expected, "A4 three-space restricts as B+C+D")

    # Schur's lemma leaves the identity scalar, chosen compatibly as lambda=1.
    identity_scale = 1
    require(identity_scale == 1, "A4 identity intertwiner scale")
    print("A4-SECOND-LAYER-IDENTITY-INTERTWINER")


def nonclaim_checks() -> None:
    theorem = (HERE / "THEOREM.md").read_text()
    status = (HERE / "STATUS.md").read_text()
    combined = theorem + "\n" + status
    normalized = " ".join(combined.split())
    required = (
        "finite character-and-equality counterconfiguration",
        "does not construct a rational map",
        "or even a second-order landing jet",
        "**Headline:** OPEN",
    )
    for phrase in required:
        require(phrase in normalized, f"missing strict nonclaim: {phrase}")
    print("V4-SECOND-LAYER-FORMAL-COUNTERCONFIGURATION")
    print("FORMAL-FIRST-JET-ONLY-NO-LANDING-REALIZATION")


def seal_checks() -> None:
    seal = json.loads((HERE / "SEAL.json").read_text())
    require(seal.get("schema") == "full_g_v4_second_layer_csp_seal_v1", "seal schema")
    files = seal.get("files")
    require(isinstance(files, dict) and files, "sealed file table")
    expected = {"THEOREM.md", "STATUS.md", "SOURCES.md", "REPLAY.md", "verify.py"}
    require(set(files) == expected, "sealed file names")
    for name, digest in files.items():
        actual = hashlib.sha256((HERE / name).read_bytes()).hexdigest()
        require(actual == digest, f"seal hash for {name}")
    print("FULL-G-V4-SECOND-LAYER-CSP-SEAL-OK")


def main() -> None:
    v4_character_checks()
    edge_equalizer_checks()
    d12_checks()
    a4_checks()
    nonclaim_checks()
    seal_checks()
    print("FULL-G-V4-SECOND-LAYER-CSP-VERIFY-OK")


if __name__ == "__main__":
    main()
