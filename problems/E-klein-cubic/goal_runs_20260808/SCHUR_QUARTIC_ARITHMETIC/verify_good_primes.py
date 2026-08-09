#!/usr/bin/env python3
"""Two-good-prime regression for the localized rank-exactly-20 chart.

The theorem is characteristic zero and is proved in THEOREM.md.  These two
reductions independently guard the 25 x 21 gauge slice, the 12 x 5 inverse
contraction, and their common codimension-five germ against coefficient or
indexing errors.
"""

from __future__ import annotations

import json
from pathlib import Path
import runpy

from sympy.polys.domains import GF
from sympy.polys.matrices import DomainMatrix


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
ALIGNMENT = ROOT / "tmp/pfaffian_representation_alignment"


def main() -> None:
    exact = runpy.run_path(str(HERE / "verify_exact.py"))
    alignment = runpy.run_path(str(ALIGNMENT / "core.py"))
    certificate = json.loads((ALIGNMENT / "certificate.json").read_text())
    serialized = certificate["exact_intertwiner"]["embedding_15x5"]
    embedding = alignment["deserialize_matrix"](serialized).to_list()
    pairs = alignment["PAIR_INDEX"]

    for prime, zeta_value in ((23, 2), (67, 9)):
        field = GF(prime)

        def reduce_entry(entry):
            total = 0
            for exponent, (numerator, denominator) in enumerate(
                alignment["coefficients"](entry, 10)
            ):
                total += (
                    numerator
                    * pow(denominator, -1, prime)
                    * pow(zeta_value, exponent, prime)
                )
            return field(total % prime)

        reduced_embedding = [
            [reduce_entry(entry) for entry in row] for row in embedding
        ]
        forms = []
        for form_index in range(5):
            matrix = [[field.zero for _ in range(6)] for _ in range(6)]
            for row, (left, right) in enumerate(pairs):
                matrix[left][right] = reduced_embedding[row][form_index]
                matrix[right][left] = -reduced_embedding[row][form_index]
            forms.append(matrix)

        def dm(rows):
            return DomainMatrix(rows, (len(rows), len(rows[0])), field)

        modular_core = {"dm": dm}
        y = [1, 1, 1, -2, 0]
        ay = [
            [
                sum(
                    (field(y[index]) * forms[index][row][column] for index in range(5)),
                    field.zero,
                )
                for column in range(6)
            ]
            for row in range(6)
        ]
        ay_dm = dm(ay)
        assert ay_dm.rank() == 4
        kernel_basis = ay_dm.nullspace().to_list()
        b_rank, c_rank, codimension = exact["exact_rank_chart"](
            modular_core, field, forms, kernel_basis
        )
        assert (b_rank, c_rank, codimension) == (20, 4, 5)
        print(
            f"p={prime}, zeta11={zeta_value}: "
            "rank(B)=20, rank(C)=4, common codimension=5"
        )

    print("SCHUR-QUARTIC-RANK20-TWO-GOOD-PRIMES-OK")


if __name__ == "__main__":
    main()
