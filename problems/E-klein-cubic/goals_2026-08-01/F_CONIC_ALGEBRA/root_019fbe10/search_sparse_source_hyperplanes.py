#!/usr/bin/env python3
"""Find low-support hyperplanes with trivial exact stabilizer certificate.

The stabilizer test is performed after good reduction modulo 331.  A trivial
reduced stabilizer forces the characteristic-zero stabilizer to be trivial.
"""

from __future__ import annotations

from itertools import combinations, product

import verify_source_hyperplane_stabilizer as verify


def canonical(covector):
    first = next(value for value in covector if value)
    if first < 0:
        return tuple(-value for value in covector)
    return tuple(covector)


def main() -> None:
    reduced = [verify.reduce_matrix(matrix) for matrix in verify.ew.rho.values()]
    seen = set()
    hits = []
    for support_size in range(1, 5):
        for support in combinations(range(5), support_size):
            for values in product((-2, -1, 1, 2), repeat=support_size):
                covector = [0] * 5
                for index, value in zip(support, values):
                    covector[index] = value
                covector = canonical(covector)
                if covector in seen:
                    continue
                seen.add(covector)
                reduced_covector = tuple(value % verify.PRIME for value in covector)
                stabilizer_size = sum(
                    verify.proportional(
                        verify.covector_times_matrix(reduced_covector, matrix),
                        reduced_covector,
                    )
                    for matrix in reduced
                )
                if stabilizer_size == 1:
                    hits.append(covector)
                    print(f"support={support_size} covector={covector}")
                    if len(hits) == 20:
                        print("SPARSE_TRIVIAL_STABILIZER_SEARCH_ACCEPT")
                        return
    print(f"hits={len(hits)}")
    print("SPARSE_TRIVIAL_STABILIZER_SEARCH_ACCEPT")


if __name__ == "__main__":
    main()
