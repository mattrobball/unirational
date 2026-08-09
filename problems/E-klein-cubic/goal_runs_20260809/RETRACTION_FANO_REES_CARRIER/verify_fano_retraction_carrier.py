#!/usr/bin/env python3
"""Dependency-free exact checks for the retraction Fano-carrier packet."""

from fractions import Fraction


CLASSES = (1, 3, 2)  # identity, transpositions, 3-cycles in S3
IRREPS = {
    "triv": (1, 1, 1),
    "sign": (1, -1, 1),
    "std": (2, 0, -1),
}


def inner_product(chi, psi):
    value = sum(size * a * b for size, a, b in zip(CLASSES, chi, psi))
    assert value % 6 == 0
    return value // 6


def main():
    # R_t has class 3A+2B on E x P1, with K=-2B.
    r_square_product = 2 * 3 * 2
    k_dot_r_product = -2 * 3
    genus_product = 1 + (r_square_product + k_dot_r_product) // 2
    assert genus_product == 4

    # On the Fano surface R_t=C-D_t.
    c_square = 5
    c_dot_d = 2
    d_square = -4
    r_square_fano = c_square - 2 * c_dot_d + d_square
    k_dot_r_fano = 3 * (c_square - c_dot_d)
    genus_fano = 1 + (r_square_fano + k_dot_r_fano) // 2
    assert (r_square_fano, k_dot_r_fano, genus_fano) == (-3, 9, 4)

    # Residual S3 character of H^0(R_t,Omega^1).
    chi_r = (4, 0, 1)
    decomposition = {
        name: inner_product(chi_r, chi) for name, chi in IRREPS.items()
    }
    assert decomposition == {"triv": 1, "sign": 1, "std": 1}

    # t=+ part of W_5 is triv+std; E_t differentials are sign.
    chi_w_plus = (3, 1, 0)
    chi_e = (1, -1, 1)
    assert inner_product(chi_w_plus, chi_r) == 2
    assert inner_product(chi_w_plus, chi_e) == 0

    # Curve-image branch: deg B=3(d-1)=K_S.(nC)=15n.
    for n in range(1, 100):
        d = 5 * n + 1
        assert 3 * (d - 1) == 15 * n

    # n=1 has arithmetic genus 11, below the faithful-G minimum 26.
    p_a_n1 = 1 + (5 + 15) // 2
    assert p_a_n1 == 11

    print("FANO_FIXED_CURVE_GENUS4_OK")
    print("FANO_RESIDUAL_S3_CHARACTER_OK")
    print("FANO_WEIL_CARRIER_MULTIPLICITY_OK")
    print("FANO_ELLIPTIC_NONCARRIER_OK")
    print("RETRACTION_CURVE_BRANCH_DEGREE_CONGRUENCE_OK")
    print("RETRACTION_FANO_CARRIER_VERIFY_OK")


if __name__ == "__main__":
    main()
