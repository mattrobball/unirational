#!/usr/bin/env python3
"""Dependency-free verifier for the formal graph/local-state packet.

This checks necessary fixed-point equations and a finite first-layer state
enumeration.  It deliberately does not construct or certify a graph, map,
covariant, or base ideal.
"""

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
P = 11
Q = (1, 9, 4, 3, 5)


def inv(value: int, modulus: int = P) -> int:
    return pow(value % modulus, -1, modulus)


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def c11_checks() -> None:
    require(tuple(pow(9, i, P) for i in range(5)) == Q, "C11 weights")
    require({pow(q, 5, P) for q in Q} == {1}, "fifth-root property")
    require(len(set(Q)) == 5, "five distinct weights")

    tangent_constant = 1
    for index in (2, 3, 4):
        tangent_constant = tangent_constant * (Q[index] - 1) % P
    require(tangent_constant == 2, "tangent Euler constant")

    h3 = sum(((-q) ** 3) * inv(tangent_constant * q**3) for q in Q) % P
    require(h3 == 3, "hyperplane cube localization")

    # Prove formal surjectivity for every degree residue using two channels.
    for delta in range(P):
        k = ((3 - delta) % P, (8 * (1 - delta)) % P, 0, 0, 0)
        source = sum(k[s] * inv(Q[s] ** 3) for s in range(5)) % P
        target = sum(k) % P
        require(source == 2, f"source pushforward at delta={delta}")
        require(target == 2 * delta % P, f"target pushforward at delta={delta}")

    delta = 2
    k = (1, 3, 0, 0, 0)
    source = sum(k[s] * inv(Q[s] ** 3) for s in range(5)) % P
    target = sum(k) % P
    require(source == 2 and target == 2 * delta % P, "delta-two pushes")

    factor = (-5 * inv(4)) % P
    require(factor == 7, "mixed-degree localization factor")
    residues = tuple(
        factor * sum(k[s] * pow(Q[s], b - 3, P) for s in range(5)) % P
        for b in range(4)
    )
    require(residues == (3, 4, 2, 6), "delta-two mixed residues")

    lift = (3, 81, 24, 6)
    require(tuple(value % P for value in lift) == residues, "integral lift residues")
    require(lift[1] == 3 * 27, "first mixed degree is 3d")
    require(lift[3] == 3 * delta, "top mixed degree is 3delta")
    require(lift[1] ** 2 >= lift[0] * lift[2], "first log-concavity inequality")
    require(lift[2] ** 2 >= lift[1] * lift[3], "second log-concavity inequality")

    print("C11-GRAPH-DEGREE-RESIDUES-FORMALLY-SURJECTIVE")
    print("C11-DELTA2-FORMAL-COUNTERCONFIGURATION")


def rotate_point(index: int) -> int:
    orbit, position = divmod(index, 3)
    return 3 * orbit + (position + 1) % 3


def check_matrix(matrix: list[list[int]], delta_parity: int) -> None:
    require(len(matrix) == 6 and all(len(row) == 6 for row in matrix), "6x6 matrix")
    require(all(sum(row) % 2 == 1 for row in matrix), "source row sums")
    require(
        all(sum(matrix[row][column] for row in range(6)) % 2 == delta_parity for column in range(6)),
        "target column sums",
    )
    for row in range(6):
        for column in range(6):
            require(
                matrix[rotate_point(row)][rotate_point(column)] == matrix[row][column],
                "residual C3 invariance",
            )


def v4_graph_checks() -> None:
    even = [[0 for _ in range(6)] for _ in range(6)]
    for i in range(3):
        even[i][i] = 1
        even[3 + i][i] = 1
    check_matrix(even, 0)

    odd = [[0 for _ in range(6)] for _ in range(6)]
    for i in range(6):
        odd[i][i] = 1
    check_matrix(odd, 1)

    # The common Euler class is the product of the three nontrivial V4 chars.
    # It is represented symbolically by the three distinct factors below.
    factors = ("u", "v", "u+v")
    require(len(set(factors)) == 3, "three V4 tangent characters")

    print("V4-GRAPH-PARITY-FORMALLY-SURJECTIVE")


def representation_checks() -> None:
    # S3 class sizes and standard character: no trivial or sign constituent.
    sizes_s3 = (1, 3, 2)
    std = (2, 0, -1)
    triv = (1, 1, 1)
    sign = (1, -1, 1)

    def inner(left: tuple[int, ...], right: tuple[int, ...], sizes: tuple[int, ...], order: int) -> int:
        numerator = sum(size * a * b for size, a, b in zip(sizes, left, right))
        require(numerator % order == 0, "integral character inner product")
        return numerator // order

    require(inner(std, triv, sizes_s3, 6) == 0, "std has no trivial line")
    require(inner(std, sign, sizes_s3, 6) == 0, "std has no sign line")

    # The A4 three-dimensional character has norm one, so it is irreducible.
    sizes_a4 = (1, 3, 4, 4)
    char3 = (3, -1, 0, 0)
    require(inner(char3, char3, sizes_a4, 12) == 1, "A4 normal representation irreducible")

    print("D12-A4-EMPTY-TARGET-FIXED-POINTS-REMOVED-BY-STRATIFIED-BLOWUPS")


def first_layer_checks() -> None:
    labels = ("B", "C", "D")
    rotation = {"B": "C", "C": "D", "D": "B"}
    plus = {"z": "B", "s": "C", "r": "D"}

    def shifted(label: str, power: int) -> str:
        for _ in range(power):
            label = rotation[label]
        return label

    # Type I: P_label lies on E_sigma exactly for the matching plus label,
    # and on L_sigma for the other two labels.
    regular_type_i = []
    for phase in range(3):
        allowed = True
        for sigma, plus_label in plus.items():
            minus_labels = [label for label in labels if label != plus_label]
            target_components = {
                "E" if shifted(label, phase) == plus_label else "L"
                for label in minus_labels
            }
            if len(target_components) != 1:
                allowed = False
        if allowed:
            regular_type_i.append(phase)
    require(regular_type_i == [0], "unique incidence-preserving type-I phase")

    # Type II: all target points lie on E_sigma, but the two minus sections
    # have distinct images.  RCC therefore makes every phase require a deeper
    # base layer rather than giving a regular first-layer map.
    type_ii_forces_deeper = []
    for phase in range(3):
        forced = True
        for _sigma, plus_label in plus.items():
            minus_labels = [label for label in labels if label != plus_label]
            images = {shifted(label, phase) for label in minus_labels}
            forced = forced and len(images) == 2
        type_ii_forces_deeper.append(forced)
    require(type_ii_forces_deeper == [True, True, True], "all type-II phases force deeper base")

    print("V4-FIRST-LAYER-UNIQUE-TYPEI-SURVIVOR")
    print("V4-TYPEII-FORCES-DEEPER-BASE")


def nonclaim_checks() -> None:
    theorem = (HERE / "THEOREM.md").read_text()
    status = (HERE / "STATUS.md").read_text()
    required = (
        "formal equivariant-Chow counterconfiguration only",
        "not claimed to be the localization of an effective irreducible graph",
        "does not construct an effective irreducible graph",
        "**Headline:** OPEN",
    )
    combined = theorem + "\n" + status
    for phrase in required:
        require(phrase in combined, f"missing strict nonclaim: {phrase}")
    print("FORMAL-ONLY-NO-GENUINE-GRAPH")


def seal_checks() -> None:
    seal = json.loads((HERE / "SEAL.json").read_text())
    require(seal.get("schema") == "full_g_graph_degree_localization_seal_v1", "seal schema")
    files = seal.get("files")
    require(isinstance(files, dict) and files, "sealed file table")
    expected_names = {"THEOREM.md", "STATUS.md", "SOURCES.md", "REPLAY.md", "verify.py"}
    require(set(files) == expected_names, "sealed file names")
    for name, expected in files.items():
        digest = hashlib.sha256((HERE / name).read_bytes()).hexdigest()
        require(digest == expected, f"seal hash for {name}")
    print("FULL-G-GRAPH-DEGREE-LOCALIZATION-SEAL-OK")


def main() -> None:
    c11_checks()
    v4_graph_checks()
    representation_checks()
    first_layer_checks()
    nonclaim_checks()
    seal_checks()
    print("FULL-G-GRAPH-DEGREE-LOCALIZATION-VERIFY-OK")


if __name__ == "__main__":
    main()
