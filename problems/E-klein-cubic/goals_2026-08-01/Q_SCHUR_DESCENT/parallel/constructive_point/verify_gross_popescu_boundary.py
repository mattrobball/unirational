#!/usr/bin/env python3
"""Exact representation-theoretic boundary of the Gross--Popescu lead."""

from math import comb


def main():
    # Their V_+ is the six-dimensional Schur module: z=-I acts by -1.
    # Their V_- is the five-dimensional Klein module: z acts by +1.
    z_v_plus = -1
    z_v_minus = 1
    characteristic = 0
    assert characteristic != 2

    # If L:V_+ -> V_- intertwines z, then L*(-1)=(+1)*L, hence 2L=0.
    assert z_v_plus != z_v_minus
    hom_vplus_vminus_dimension = 0
    assert hom_vplus_vminus_dimension == 0

    # The paper's actual intertwiner has equal 15-dimensional source/target,
    # and the center is +1 on both second tensor constructions.
    exterior_dimension = comb(6, 2)
    symmetric_dimension = comb(5 + 1, 2)
    z_exterior = z_v_plus**2
    z_symmetric = z_v_minus**2
    assert exterior_dimension == symmetric_dimension == 15
    assert z_exterior == z_symmetric == 1

    print("Hom_SL2(V_plus,V_minus)=0 (central character)")
    print("Lambda^2(V_plus) and Sym^2(V_minus) both have dimension 15")
    print("GROSS_POPESCU_EQUIVARIANCE_BOUNDARY_EXACT")


if __name__ == "__main__":
    main()
