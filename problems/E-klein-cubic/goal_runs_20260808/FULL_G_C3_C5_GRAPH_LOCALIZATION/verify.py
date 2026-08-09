#!/usr/bin/env python3
"""Verify the formal C3/C5 graph-localization calculations.

Only finite-field arithmetic, permutation orbitals, mixed intersections, and
seal hashes are checked.  No graph, map, effective cycle, or landing covariant
is constructed.
"""

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def product(values: list[int], modulus: int) -> int:
    answer = 1
    for value in values:
        answer = answer * value % modulus
    return answer


def c3_add(left: tuple[int, int], right: tuple[int, int]) -> tuple[int, int]:
    return (left[0] ^ right[0], left[1] ^ right[1])


Q3 = ((0, 0), (0, 1), (1, 0), (1, 1))
A3 = (("A", 0, 0), ("A", 1, 0))
B3 = tuple(("B", a, b) for a, b in Q3)
POINTS3 = A3 + B3


def c3_act(q: tuple[int, int], point: tuple[str, int, int]) -> tuple[str, int, int]:
    orbit, a, b = point
    aa, bb = c3_add(q, (a, b))
    return (orbit, aa, 0 if orbit == "A" else bb)


def c3_euler(point: tuple[str, int, int]) -> int:
    return 1 if point[1] == 0 else 2


def c3_orbital(source: tuple[str, int, int], target: tuple[str, int, int]) -> int:
    source_orbit, sa, sb = source
    target_orbit, ta, tb = target
    da = sa ^ ta
    if source_orbit == "A" and target_orbit == "A":
        return da
    if source_orbit == "A" and target_orbit == "B":
        return 2 + da
    if source_orbit == "B" and target_orbit == "A":
        return 4 + da
    difference = (da, sb ^ tb)
    return 6 + {(0, 0): 0, (0, 1): 1, (1, 0): 2, (1, 1): 3}[difference]


C3_SOLUTIONS = {
    0: (0, 0, 0, 2, 0, 0, 0, 0, 0, 1),
    1: (0, 0, 0, 2, 0, 1, 0, 0, 0, 0),
    2: (0, 0, 2, 0, 1, 0, 0, 0, 0, 0),
}


def c3_checks() -> None:
    p = 3
    require(product([2, 1, 1], p) == 2, "C3 Euler on U1")
    require(product([1, 2, 2], p) == 1, "C3 Euler on U2")
    require(len(A3) == 2 and len(B3) == 4, "C3 fixed orbit sizes")

    expected_mixed = (0, 0, 0, 0)
    for delta, solution in C3_SOLUTIONS.items():
        def matrix(source: tuple[str, int, int], target: tuple[str, int, int]) -> int:
            return solution[c3_orbital(source, target)]

        for q in Q3:
            for source in POINTS3:
                for target in POINTS3:
                    require(
                        matrix(c3_act(q, source), c3_act(q, target)) == matrix(source, target),
                        "C3 normalizer invariance",
                    )

        for source in POINTS3:
            require(sum(matrix(source, target) for target in POINTS3) % p == 1, "C3 row push")
        for target in POINTS3:
            weighted = sum(
                c3_euler(target) * matrix(source, target) * pow(c3_euler(source), -1, p)
                for source in POINTS3
            ) % p
            require(weighted == delta, "C3 column push")

        # The hyperplane restriction equals the Euler sign in this labeling.
        mixed = []
        for b in range(4):
            value = sum(
                pow(c3_euler(source), 3 - b, p)
                * pow(c3_euler(target), b, p)
                * matrix(source, target)
                * pow(c3_euler(source), -1, p)
                for source in POINTS3
                for target in POINTS3
            ) % p
            mixed.append(value)
        require(tuple(mixed) == expected_mixed, f"C3 mixed residues at delta={delta}")

        # Unnormalized coefficients transform with the cubic sign under inversion.
        inverter = (1, 0)
        for source in POINTS3:
            for target in POINTS3:
                coefficient = matrix(source, target) * c3_euler(target) % p
                moved = matrix(c3_act(inverter, source), c3_act(inverter, target))
                moved = moved * c3_euler(c3_act(inverter, target)) % p
                require(moved == -coefficient % p, "C3 cubic coefficient inversion")

    print("C3-GRAPH-DEGREE-RESIDUES-FORMALLY-SURJECTIVE")
    print("C3-NORMALIZER-COUPLING-AND-MIXED-DEGREES-OK")


POINTS5 = (1, 4, 2, 3)
C5_REPRESENTATIVES = ((1, 1), (1, 4), (1, 2), (1, 3), (2, 1), (2, 4), (2, 2), (2, 3))
C5_ORBITAL = {}
for index, (source, target) in enumerate(C5_REPRESENTATIVES):
    C5_ORBITAL[(source, target)] = index
    C5_ORBITAL[(-source % 5, -target % 5)] = index

C5_SOLUTIONS = {
    0: (0, 0, 0, 1, 0, 0, 2, 4),
    1: (1, 0, 0, 0, 0, 0, 1, 0),
    2: (0, 0, 0, 1, 1, 0, 0, 0),
    3: (0, 0, 1, 0, 0, 1, 0, 0),
    4: (0, 1, 0, 0, 0, 0, 0, 1),
}

C5_MIXED = {
    0: (3, 4, 0, 0),
    1: (3, 3, 3, 3),
    2: (3, 4, 2, 1),
    3: (3, 1, 2, 4),
    4: (3, 2, 3, 2),
}

C5_LIFTS = {
    0: (5, (3, 9, 15, 15)),
    1: (1, (3, 3, 3, 3)),
    2: (2, (3, 9, 12, 6)),
    3: (3, (3, 6, 12, 9)),
    4: (4, (3, 12, 13, 12)),
}


def c5_euler(a: int) -> int:
    return 2 * pow(a, -1, 5) % 5


def c5_hyperplane(a: int) -> int:
    return -a % 5


def c5_checks() -> None:
    p = 5
    require(len(C5_ORBITAL) == 16, "all C5 fixed pairs classified")
    eulers = []
    for a in range(1, 5):
        tangent_weights = [(b - a) % p for b in range(p) if b not in (a, 3 * a % p)]
        direct = product(tangent_weights, p)
        require(direct == c5_euler(a), f"C5 tangent Euler at a={a}")
        eulers.append(direct)
    require(tuple(eulers) == (2, 1, 4, 3), "C5 Euler vector")
    h3 = sum(pow(c5_hyperplane(a), 3, p) * pow(c5_euler(a), -1, p) for a in POINTS5) % p
    require(h3 == 3, "C5 hyperplane cube")

    for delta, solution in C5_SOLUTIONS.items():
        def matrix(source: int, target: int) -> int:
            return solution[C5_ORBITAL[(source, target)]]

        for source in POINTS5:
            for target in POINTS5:
                require(matrix(-source % p, -target % p) == matrix(source, target), "C5 normalizer invariance")
        for source in POINTS5:
            require(sum(matrix(source, target) for target in POINTS5) % p == 1, "C5 row push")
        for target in POINTS5:
            weighted = sum(
                c5_euler(target) * matrix(source, target) * pow(c5_euler(source), -1, p)
                for source in POINTS5
            ) % p
            require(weighted == delta, "C5 column push")

        mixed = []
        for b in range(4):
            value = sum(
                pow(c5_hyperplane(source), 3 - b, p)
                * pow(c5_hyperplane(target), b, p)
                * matrix(source, target)
                * pow(c5_euler(source), -1, p)
                for source in POINTS5
                for target in POINTS5
            ) % p
            mixed.append(value)
        require(tuple(mixed) == C5_MIXED[delta], f"C5 mixed residues at delta={delta}")

        for source in POINTS5:
            for target in POINTS5:
                coefficient = matrix(source, target) * c5_euler(target) % p
                moved = matrix(-source % p, -target % p) * c5_euler(-target % p) % p
                require(moved == -coefficient % p, "C5 cubic coefficient inversion")

        actual_delta, lift = C5_LIFTS[delta]
        require(tuple(value % p for value in lift) == C5_MIXED[delta], "C5 lift residues")
        require(lift[0] == 3 and lift[1] % 3 == 0, "C5 graph endpoint and a1 divisibility")
        require(lift[3] == 3 * actual_delta, "C5 lift top degree")
        require(lift[1] ** 2 >= lift[0] * lift[2], "C5 first log-concavity")
        require(lift[2] ** 2 >= lift[1] * lift[3], "C5 second log-concavity")

    print("C5-GRAPH-DEGREE-RESIDUES-FORMALLY-SURJECTIVE")
    print("C5-NORMALIZER-MIXED-DEGREE-POSITIVE-LIFTS-OK")


def simultaneous_delta_two_checks() -> None:
    lift = (3, 114, 57, 6)
    require(tuple(value % 11 for value in lift) == (3, 4, 2, 6), "delta2 C11 residues")
    require(tuple(value % 5 for value in lift) == C5_MIXED[2], "delta2 C5 residues")
    require(tuple(value % 3 for value in lift) == (0, 0, 0, 0), "delta2 C3 residues")
    require(lift[1] == 3 * 38 and lift[3] == 3 * 2, "delta2 graph endpoint degrees")
    require(lift[1] ** 2 >= lift[0] * lift[2], "delta2 first log-concavity")
    require(lift[2] ** 2 >= lift[1] * lift[3], "delta2 second log-concavity")
    print("C3-C5-C11-DELTA2-SIMULTANEOUS-FORMAL-LIFT")


def nonclaim_checks() -> None:
    theorem = (HERE / "THEOREM.md").read_text()
    status = (HERE / "STATUS.md").read_text()
    normalized = " ".join((theorem + "\n" + status).split())
    required = (
        "not asserted to come from an effective irreducible graph",
        "simultaneous formal localization counterconfiguration only",
        "do not construct a compatible integral cycle",
        "**Headline:** OPEN",
    )
    for phrase in required:
        require(phrase in normalized, f"missing strict nonclaim: {phrase}")
    print("FORMAL-FIXED-RESTRICTIONS-ONLY-NO-GRAPH")


def seal_checks() -> None:
    seal = json.loads((HERE / "SEAL.json").read_text())
    require(seal.get("schema") == "full_g_c3_c5_graph_localization_seal_v1", "seal schema")
    files = seal.get("files")
    require(isinstance(files, dict) and files, "sealed file table")
    expected = {"THEOREM.md", "STATUS.md", "SOURCES.md", "REPLAY.md", "verify.py"}
    require(set(files) == expected, "sealed file names")
    for name, digest in files.items():
        actual = hashlib.sha256((HERE / name).read_bytes()).hexdigest()
        require(actual == digest, f"seal hash for {name}")
    print("FULL-G-C3-C5-GRAPH-LOCALIZATION-SEAL-OK")


def main() -> None:
    c3_checks()
    c5_checks()
    simultaneous_delta_two_checks()
    nonclaim_checks()
    seal_checks()
    print("FULL-G-C3-C5-GRAPH-LOCALIZATION-VERIFY-OK")


if __name__ == "__main__":
    main()
