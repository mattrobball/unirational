"""Semi-regular Hilbert series and degree of regularity.

For m homogeneous cubics in n variables the generating function is
    H(t) = (1 - t^3)^m * (1 - t)^{-n}
= sum_d c_d t^d with
    c_d = sum_{j>=0, 3j <= d}  binom(m,j) (-1)^j binom(d - 3j + n - 1, n - 1).

Following Bardet–Faugère–Salvy, d_reg is the smallest d with c_d <= 0
(the first degree at which a semi-regular sequence has vanishing Hilbert
function). This is a model for a generic sequence of that size, not a
measurement of the landing ideal.
"""
import math


def hilbert_coeff(n, m, d, deg_poly=3):
    s = 0
    j = 0
    while deg_poly * j <= d:
        sign = -1 if (j & 1) else 1
        s += sign * math.comb(m, j) * math.comb(d - deg_poly * j + n - 1, n - 1)
        j += 1
        if j > m:
            break
    return s


def degree_of_regularity(n, m, deg_poly=3, dmax=80):
    coeffs = []
    for d in range(0, dmax + 1):
        c = hilbert_coeff(n, m, d, deg_poly=deg_poly)
        coeffs.append(c)
        if c <= 0 and d >= 1:
            return d, coeffs
    return None, coeffs


def macaulay_columns(n, d):
    return math.comb(d + n - 1, d)
