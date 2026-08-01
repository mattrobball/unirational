#!/usr/bin/env python3
"""Independent spectral check for the auxiliary projector dictionary."""

from __future__ import annotations


def elementary_symmetric(roots: list[int]) -> tuple[int, int, int]:
    c1 = sum(roots)
    c2 = roots[0]*roots[1] + roots[0]*roots[2] + roots[1]*roots[2]
    c3 = roots[0]*roots[1]*roots[2]
    return c1, c2, c3


def q_value(value: int, c1: int, c2: int) -> int:
    return value*value - c1*value + c2


def main() -> None:
    # A right-D-line projector has split matrix rank two, hence Pfaffian
    # eigenvalues (1,0,0).  It is not itself on c3=0,c2!=0.
    projector_roots = [1, 0, 0]
    pc1, pc2, pc3 = elementary_symmetric(projector_roots)
    assert (pc1, pc2, pc3) == (1, 0, 0)

    # Its complement a=1-p has roots (0,1,1), polynomial T(T-1)^2,
    # and lies on the spectral open.
    complement_roots = [0, 1, 1]
    c1, c2, c3 = elementary_symmetric(complement_roots)
    assert (c1, c2, c3) == (2, 1, 0)
    assert [q_value(root, c1, c2)//c2 for root in complement_roots] == [1, 0, 0]

    # Scaling a by lambda scales (c1,c2,c3) by (lambda,lambda^2,lambda^3)
    # and leaves the functional projector values unchanged.
    for lam in (2, -3, 5):
        scaled = [lam*root for root in complement_roots]
        sc1, sc2, sc3 = elementary_symmetric(scaled)
        assert (sc1, sc2, sc3) == (lam*c1, lam*lam*c2, lam**3*c3)
        assert [q_value(root, sc1, sc2)//sc2 for root in scaled] == [1, 0, 0]

    print("B_PROJECTOR_COMPLEMENT_SECTION_ACCEPT")
    print("B_PROJECTOR_PROJECTIVIZATION_ACCEPT")


if __name__ == "__main__":
    main()

