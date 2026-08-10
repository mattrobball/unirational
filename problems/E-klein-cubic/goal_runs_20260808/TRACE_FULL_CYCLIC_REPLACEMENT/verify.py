#!/usr/bin/env python3
"""Small exact checks for the full-cyclic-span replacement packet."""

import json
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]


def multiply(left, right):
    """C11 semidirect_9 C5 in pair coordinates."""
    i, j = left
    k, ell = right
    return ((i + pow(9, j, 11) * k) % 11, (j + ell) % 5)


def main():
    group = [(i, j) for i in range(11) for j in range(5)]
    identity = (0, 0)
    center = [
        element
        for element in group
        if all(multiply(element, other) == multiply(other, element) for other in group)
    ]
    assert len(group) == 55
    assert center == [identity]
    assert pow(9, 5, 11) == 1
    assert all(pow(9, exponent, 11) != 1 for exponent in range(1, 5))

    source_dimension = 5 - 1
    target_dimension = 4 - 1
    assert source_dimension >= target_dimension

    isogeny_path = (
        ROOT
        / "goal_runs_after_141f60"
        / "H6A_PROJECTIVE_11_ISOGENY"
        / "isogeny.json"
    )
    isogeny = json.loads(isogeny_path.read_text())
    diagonal = isogeny["augmentation_restriction"]["smith_normal_form_diagonal"]
    assert diagonal == [1, 1, 1, 11]
    degree = sp.prod(diagonal)
    assert degree == 11
    z = sp.symbols("z")
    phi5 = z**4 + z**3 + z**2 + z + 1
    assert sp.expand(phi5.subs(z, -2)) == 11

    # A fifth root of unity of order five modulo 11 gives an exact reduction
    # certificate that the five Fourier rows are independent.  Removing the
    # invariant row leaves rank four on the trace-zero hyperplane.
    root = 3
    assert pow(root, 5, 11) == 1 and root != 1
    fourier = sp.Matrix(
        [[pow(root, (-q * i) % 5, 11) for i in range(5)] for q in range(5)]
    )
    assert fourier.inv_mod(11) is not None
    nontrivial_rank = sp.polys.matrices.DomainMatrix.from_Matrix(
        fourier[1:, :]
    ).convert_to(sp.GF(11)).rank()
    assert nontrivial_rank == 4

    theorem = (HERE / "THEOREM.md").read_text()
    status = (HERE / "STATUS.md").read_text()
    marker = "F55-TRACE-FULL-CYCLIC-SPAN-REPLACEMENT"
    assert marker in theorem and marker in status
    assert "F55-GLOBAL-QUESTION-OPEN" in theorem
    assert "F55-GLOBAL-QUESTION-OPEN" in status

    print("F55_ORDER", len(group))
    print("F55_CENTER_SIZE", len(center))
    print("PROJECTIVE_SOURCE_DIMENSION", source_dimension)
    print("KLEIN_TARGET_DIMENSION", target_dimension)
    print("PROJECTIVE_ISOGENY_DEGREE", degree)
    print("PROJECTIVE_ISOGENY_SNF", diagonal)
    print("NONTRIVIAL_FOURIER_RANK", nontrivial_rank)
    print("F55-TRACE-FULL-CYCLIC-SPAN-REPLACEMENT-OK")


if __name__ == "__main__":
    main()
