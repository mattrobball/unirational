#!/usr/bin/env python3
"""Search Galois-symmetric words in a cubic projector triple.

The search is modular discovery only.  A survivor would require reconstructing
the full cubic RUR and verifying the word identity in characteristic zero.
"""

from __future__ import annotations

import json
import runpy
from itertools import combinations, permutations, product
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
EXTRACT = runpy.run_path(str(HERE / "extract_ambient_projector_points.py"))
AUDIT = runpy.run_path(str(HERE / "audit_projector_triple.py"))
PRIME = 23
ZETA = 4
POINTS = (
    (2, 5, 7, 11, 13),
    (3, 1, 4, 1, 5),
    (16, 19, 13, 8, 10),
    (10, 20, 3, 4, 20),
    (20, 11, 1, 14, 11),
    (0, 14, 17, 22, 8),
    (22, 5, 16, 12, 22),
    (1, 3, 2, 3, 3),
    (12, 20, 19, 12, 12),
    (1, 4, 15, 1, 16),
    (1, 6, 17, 14, 11),
    (8, 21, 1, 12, 15),
    (2, 20, 17, 16, 20),
    (21, 20, 18, 2, 12),
)


def reduced_word(word: tuple[int, ...]) -> tuple[int, ...]:
    answer = []
    for letter in word:
        if not answer or answer[-1] != letter:
            answer.append(letter)
    return tuple(answer)


def orbit(word: tuple[int, ...]) -> tuple[tuple[int, ...], ...]:
    words = set()
    for permutation in permutations(range(3)):
        transformed = reduced_word(tuple(permutation[letter] for letter in word))
        words.add(transformed)
        words.add(tuple(reversed(transformed)))
    return tuple(sorted(words))


def projectors_at_points():
    metadata = json.loads((HERE / "ambient_degree12_p23_zeta4.json").read_text())
    _degree, _eliminant, roots, vectors = EXTRACT["parse_rur"](
        HERE / "ambient_degree12_p23_zeta4_a47.rur", PRIME
    )
    assert len(roots) == len(vectors) == 3
    namespace = runpy.run_path(
        str(ROOT / "tmp/pfaffian_rank2_idempotent_attack/full_wedge.py")
    )
    live = namespace["FullWedgeScanner"].__init__.__globals__
    fano_live = live["fano"]["six_dimensional_generators"].__globals__
    live["P"] = PRIME
    fano_live["P"] = PRIME
    fano_live["ZETA"] = ZETA
    scanner = namespace["FullWedgeScanner"]()
    fano = live["fano"]
    seeds = [(entry[0], tuple(entry[1])) for entry in metadata["seeds"]]
    six = fano["six_dimensional_generators"]()
    dual = tuple(fano["inv"](generator).T % PRIME for generator in six)
    dual_wedge = tuple(fano["exterior_square"](generator) for generator in dual)
    domain_basis, _ = fano["invariant_summands"](dual_wedge)
    pairs = tuple(combinations(range(6), 2))
    output = []
    for point_tuple in POINTS:
        point = np.array(point_tuple, dtype=np.int64) % PRIME
        values = np.stack([
            scanner.evaluate_seed(seed_output, exponents, point)
            for seed_output, exponents in seeds
        ])
        q = EXTRACT["skew"](domain_basis @ point % PRIME, pairs, PRIME)
        projectors = []
        try:
            for vector in vectors:
                wedge = np.array(vector, dtype=np.int64) @ values % PRIME
                projectors.append(EXTRACT["projector"](wedge, q, pairs, PRIME))
        except (AssertionError, StopIteration):
            continue
        output.append((point_tuple, q, projectors))
    return output


def word_matrix(word: tuple[int, ...], projectors: list[np.ndarray]) -> np.ndarray:
    answer = np.eye(6, dtype=np.int64)
    for letter in word:
        answer = answer @ projectors[letter] % PRIME
    return answer


def orbit_matrix(words: tuple[tuple[int, ...], ...], projectors: list[np.ndarray]) -> np.ndarray:
    return sum(
        (word_matrix(word, projectors) for word in words),
        np.zeros((6, 6), dtype=np.int64),
    ) % PRIME


def pfaffian_coefficients(matrix: np.ndarray, q: np.ndarray):
    q_inverse = EXTRACT["inv_mod"](q, PRIME)
    assert np.array_equal(q_inverse @ matrix.T @ q % PRIME, matrix)
    c1 = int(np.trace(matrix)) * pow(2, -1, PRIME) % PRIME
    c2 = (2 * c1 * c1 - int(np.trace(matrix @ matrix % PRIME))) * pow(4, -1, PRIME) % PRIME
    c3 = AUDIT["pfaffian6"](q @ matrix % PRIME, PRIME) * pow(
        AUDIT["pfaffian6"](q, PRIME), -1, PRIME
    ) % PRIME
    return c1, c2, c3


def main() -> None:
    fibres = projectors_at_points()
    orbit_records = {}
    for length in range(1, 7):
        for word in product(range(3), repeat=length):
            word = reduced_word(word)
            if not word:
                continue
            words = orbit(word)
            orbit_records.setdefault(words, word)
    orbits = sorted(orbit_records)
    evaluations = [
        [orbit_matrix(words, projectors) for _point, q, projectors in fibres]
        for words in orbits
    ]

    candidates = []
    for index, matrices in enumerate(evaluations):
        coefficients = [
            pfaffian_coefficients(matrix, q)
            for matrix, (_point, q, _) in zip(matrices, fibres)
        ]
        if all(c3 == 0 and c2 != 0 for _c1, c2, c3 in coefficients):
            candidates.append({"terms": [[index, 1]], "coefficients": coefficients})

    for left in range(len(orbits)):
        for right in range(left + 1, len(orbits)):
            for sign in (1, -1):
                matrices = [
                    (evaluations[left][point] + sign * evaluations[right][point]) % PRIME
                    for point in range(len(fibres))
                ]
                coefficients = [
                    pfaffian_coefficients(matrix, q)
                    for matrix, (_point, q, _) in zip(matrices, fibres)
                ]
                if all(c3 == 0 and c2 != 0 for _c1, c2, c3 in coefficients):
                    candidates.append({
                        "terms": [[left, 1], [right, sign]],
                        "coefficients": coefficients,
                    })

    for left in range(len(orbits)):
        for middle in range(left + 1, len(orbits)):
            for right in range(middle + 1, len(orbits)):
                for middle_sign in (1, -1):
                    for right_sign in (1, -1):
                        matrices = [
                            (
                                evaluations[left][point]
                                + middle_sign * evaluations[middle][point]
                                + right_sign * evaluations[right][point]
                            ) % PRIME
                            for point in range(len(fibres))
                        ]
                        coefficients = [
                            pfaffian_coefficients(matrix, q)
                            for matrix, (_point, q, _) in zip(matrices, fibres)
                        ]
                        if all(c3 == 0 and c2 != 0 for _c1, c2, c3 in coefficients):
                            candidates.append({
                                "terms": [
                                    [left, 1], [middle, middle_sign], [right, right_sign]
                                ],
                                "coefficients": coefficients,
                            })

    payload = {
        "format": "cubic-projector-symmetric-word-screen-v1",
        "scope": "mod-23 discovery screen; not characteristic-zero descent",
        "prime": PRIME,
        "zeta11": ZETA,
        "candidate_points": [list(point) for point in POINTS],
        "valid_points": [list(point) for point, _q, _projectors in fibres],
        "maximum_raw_word_length": 6,
        "orbit_count": len(orbits),
        "orbits": [[list(word) for word in words] for words in orbits],
        "single_signed_pair_and_signed_triple_candidate_count": len(candidates),
        "candidates": candidates,
        "theorem_boundary": (
            "a modular symmetric-word survivor requires full RUR reconstruction "
            "and exact Pfaffian/projector verification over K_proj"
        ),
    }
    (HERE / "projector_descent_word_screen_p23.json").write_text(
        json.dumps(payload, indent=2) + "\n"
    )
    print(json.dumps({
        "orbit_count": len(orbits),
        "candidate_count": len(candidates),
        "first_candidates": candidates[:10],
    }, indent=2))
    print("PROJECTOR-DESCENT-SYMMETRIC-WORD-SCREENED")


if __name__ == "__main__":
    main()
