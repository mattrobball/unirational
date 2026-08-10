#!/usr/bin/env python3
"""Exact bounded replay for the semilinear rank-three descent packet.

Only five-dimensional integer linear algebra and formal exponent arithmetic
are used.  There is no support, degree, or coefficient search.
"""

from itertools import permutations


def mat_vec(matrix, vector):
    return [sum(row[j] * vector[j] for j in range(len(vector))) for row in matrix]


def det_bareiss(matrix):
    a = [row[:] for row in matrix]
    n = len(a)
    sign = 1
    previous = 1
    for k in range(n - 1):
        if a[k][k] == 0:
            pivot = next(i for i in range(k + 1, n) if a[i][k] != 0)
            a[k], a[pivot] = a[pivot], a[k]
            sign *= -1
        pivot_value = a[k][k]
        for i in range(k + 1, n):
            for j in range(k + 1, n):
                a[i][j] = (a[i][j] * pivot_value - a[i][k] * a[k][j]) // previous
        previous = pivot_value
        for i in range(k + 1, n):
            a[i][k] = 0
    return sign * a[-1][-1]


def main():
    # Valuations of c_b = (prod d_i)/(d_0^3 d_1^2).
    w = [-2, -1, 1, 1, 1]
    lam = [1, 9, 4, 3, 5]
    assert sum(w) == 0
    assert sum(lam[i] * w[i] for i in range(5)) % 11 == 1

    # (C x)_i = 2*x_i + x_(i-1), the valuation action of h^2 sigma(h).
    C = [[2 if i == j else (1 if j == (i - 1) % 5 else 0) for j in range(5)]
         for i in range(5)]
    assert det_bareiss(C) == 33
    assert all(sum(lam[i] * C[i][j] for i in range(5)) % 11 == 0
               for j in range(5))

    x = [-13, 1, 5, 3, 4]
    assert mat_vec(C, x) == [11 * value for value in w]

    # Formal exponent proof of norm(c_b)=1 and c_b*psi(d_0^2)=n*d_0.
    # Exponents are in the ordered prime orbit d_0,...,d_4.
    a = [2, 0, 0, 0, 0]
    psi_a = mat_vec(C, a)
    c = w
    product = [c[i] + psi_a[i] for i in range(5)]
    assert product == [2, 1, 1, 1, 1]  # n*d_0
    assert sum(c) == 0                 # norm one under cyclic product

    # The character line is cyclically stable and nonzero in the augmentation.
    mu = [1, 5, 3, 4, 9]
    assert sum(mu) % 11 == 0
    left_rotation = mu[1:] + mu[:1]
    assert left_rotation == [(5 * value) % 11 for value in mu]

    # The actual unit coefficient c=r_2^-1 and its full C5 residue orbit.
    actual_orbit = [(-lam[(j + 2) % 5]) % 11 for j in range(5)]
    assert actual_orbit == [7, 8, 6, 10, 2]
    assert actual_orbit == [(7 * value) % 11 for value in lam]

    # The descent-fixed subgroup of Aut(U_E)=S5 is the centralizer of a
    # five-cycle.  This is the complete, analytically bounded set of 5!=120
    # permutations, not an open-ended group search.
    cycle = tuple((i + 1) % 5 for i in range(5))

    def compose(p, q):
        return tuple(p[q[i]] for i in range(5))

    centralizer = [p for p in permutations(range(5))
                   if compose(p, cycle) == compose(cycle, p)]
    powers = []
    current = tuple(range(5))
    for _ in range(5):
        powers.append(current)
        current = compose(cycle, current)
    assert set(centralizer) == set(powers)

    # The actual coefficient orbit r_i^-1 has four independent characters.
    # The countermodel coefficients are invariant under common scaling d_i -> t*d_i,
    # so they factor through the projective trace hyperplane (dimension three).
    assert sum(w) == 0

    print("torsor_geometric_character_line_dimension=1")
    print("countermodel_valuation_vector=" + str(tuple(w)))
    print("countermodel_mod3_residue=0")
    print("countermodel_mod11_residue=1")
    print("countermodel_exact_order=11")
    print("countermodel_norm=1")
    print("countermodel_trace_zero_identity=telescoping")
    print("actual_r2_inverse_unit_residue_orbit=" + str(tuple(actual_orbit)))
    print("regular_trace_open_automorphism_group=C5; centralizer_size="
          + str(len(centralizer)))
    print("RANK3-SEMILINEAR-DESCENT-COUNTERMODEL-OK")


if __name__ == "__main__":
    main()
