#!/usr/bin/env python3
"""Tiny exact regressions for the TRACE_COBOUNDARY theorem packet.

This does not search supports or degrees.  It checks only the mod-11 row,
the explicit additive primitive, and the local nondegenerate boundary model.
"""

from itertools import combinations


MOD = 11
MU = (1, 5, 3, 4, 9)
ZERO_Z = (0, 0, 0, 0)
ONE_Z = (1, 0, 0, 0)
ZETA = (0, 1, 0, 0)


def add(p, q):
    out = dict(p)
    for e, c in q.items():
        out[e] = out.get(e, 0) + c
        if out[e] == 0:
            del out[e]
    return out


def neg(p):
    return {e: -c for e, c in p.items()}


def valuation(p):
    return min(p)


def zadd(a, b):
    return tuple(a[i] + b[i] for i in range(4))


def zmul(a, b):
    coeffs = [0] * 7
    for i, ai in enumerate(a):
        for j, bj in enumerate(b):
            coeffs[i + j] += ai * bj
    # Descending reduction by zeta^4=-(1+zeta+zeta^2+zeta^3).
    for degree in range(6, 3, -1):
        c = coeffs[degree]
        if not c:
            continue
        coeffs[degree] = 0
        shift = degree - 4
        for j in range(4):
            coeffs[shift + j] -= c
    return tuple(coeffs[:4])


def zpow(a, n):
    out = ONE_Z
    base = a
    while n:
        if n & 1:
            out = zmul(out, base)
        base = zmul(base, base)
        n //= 2
    return out


def poly_zadd(a, b):
    return tuple(zadd(a[i], b[i]) for i in range(len(a)))


def poly_zscale(c, a):
    return tuple(zmul(c, ai) for ai in a)


def main():
    assert sum(MU) % MOD == 0
    assert all(x % MOD for x in MU)

    # w_j=2*x_j+x_(j+1).  MU is a left null row modulo eleven.
    for j in range(5):
        assert (2 * MU[j] + MU[(j - 1) % 5]) % MOD == 0

    # Exact local five-edge relation from Theorem (6.3).
    ds = (
        {0: 1},
        {1: 1},
        {2: 1},
        {0: 1},
        {0: -2, 1: -1, 2: -1},
    )
    total = {}
    for d in ds:
        total = add(total, d)
    assert total == {}

    # Every proper subsum is nonzero.
    for size in range(1, 5):
        for inds in combinations(range(5), size):
            subtotal = {}
            for i in inds:
                subtotal = add(subtotal, ds[i])
            assert subtotal != {}, inds

    vals = tuple(valuation(d) for d in ds)
    assert vals == (0, 1, 2, 0, 0)
    assert sum(MU[i] * vals[i] for i in range(5)) == 11

    # Consecutive vertices u_(i+1)-u_i=d_i and u_5=u_0.
    vertices = [{}]
    for d in ds:
        vertices.append(add(vertices[-1], d))
    assert vertices[-1] == vertices[0]
    for i, d in enumerate(ds):
        assert add(vertices[i + 1], neg(vertices[i])) == d

    # The valuation vector is exactly (2I+shift)e_2 in the term convention.
    x = (0, 0, 1, 0, 0)
    w = tuple(2 * x[j] + x[(j + 1) % 5] for j in range(5))
    assert w == vals

    # Full-spark check for every 5 x 3 submatrix of the four possible
    # nontrivial-character triples.  3 has order five in F_11; a nonzero
    # reduction proves the corresponding cyclotomic determinant is nonzero
    # in characteristic zero.
    zeta_mod_11 = 3
    assert pow(zeta_mod_11, 5, MOD) == 1
    assert all(pow(zeta_mod_11, d, MOD) != 1 for d in range(1, 5))
    for chars in combinations(range(1, 5), 3):
        for rows in combinations(range(5), 3):
            mat = [
                [pow(zeta_mod_11, chars[c] * rows[r], MOD) for c in range(3)]
                for r in range(3)
            ]
            det = (
                mat[0][0] * (mat[1][1] * mat[2][2] - mat[1][2] * mat[2][1])
                - mat[0][1] * (mat[1][0] * mat[2][2] - mat[1][2] * mat[2][0])
                + mat[0][2] * (mat[1][0] * mat[2][1] - mat[1][1] * mat[2][0])
            ) % MOD
            assert det != 0, (chars, rows)

    # The two cyclic pair types and their least positive representatives.
    for i in range(5):
        assert (MU[i] + 2 * MU[(i + 1) % 5]) % MOD == 0
        assert (2 * MU[i] + 3 * MU[(i + 2) % 5]) % MOD == 0
        adjacent = [
            (a + b, a, b)
            for a in range(1, MOD + 1)
            for b in range(1, MOD + 1)
            if (MU[i] * a + MU[(i + 1) % 5] * b) % MOD == 0
        ]
        diagonal = [
            (a + b, a, b)
            for a in range(1, MOD + 1)
            for b in range(1, MOD + 1)
            if (MU[i] * a + MU[(i + 2) % 5] * b) % MOD == 0
        ]
        assert min(adjacent) == (3, 1, 2)
        assert min(diagonal) == (5, 2, 3)

        # Full integral lifts, including the mod-three Smith factor.
        x_adj = [0] * 5
        x_adj[(i + 1) % 5] = 1
        w_adj = tuple(2 * x_adj[j] + x_adj[(j + 1) % 5] for j in range(5))
        expected_adj = tuple(1 if j == i else 2 if j == (i + 1) % 5 else 0 for j in range(5))
        assert w_adj == expected_adj

        x_diag = [0] * 5
        x_diag[i] = 2
        x_diag[(i + 2) % 5] = 2
        x_diag[(i + 3) % 5] = 1
        w_diag = tuple(2 * x_diag[j] + x_diag[(j + 1) % 5] for j in range(5))
        expected_diag = tuple(
            4 if j == i else 5 if j == (i + 2) % 5 else 2 for j in range(5)
        )
        assert w_diag == expected_diag

    # Formal D/E pair-divisor configuration: each term has degree eight and
    # every deletion passes the refined four-term Wronskian budget 23.
    # A factor is represented by the two term multiplicities it carries.
    factors = []
    for i in range(5):
        adj = [0] * 5
        adj[i] = 1
        adj[(i + 1) % 5] = 2
        factors.append(tuple(adj))
        diag = [0] * 5
        diag[i] = 2
        diag[(i + 2) % 5] = 3
        factors.append(tuple(diag))
    term_degrees = [sum(f[j] for f in factors) for j in range(5)]
    assert term_degrees == [8] * 5
    for deleted in range(5):
        retained = [j for j in range(5) if j != deleted]
        weights = []
        for f in factors:
            divides = sum(f[j] > 0 for j in retained)
            assert divides in (1, 2)
            weights.append(2 if divides == 1 else 3)
        assert weights.count(2) == 4
        assert weights.count(3) == 6
        assert -3 + sum(weights) == 23
        assert max(term_degrees[j] for j in retained) == 8

    # Exact rank-three local Fourier net over Z[zeta_5].
    local_z = (
        (ZERO_Z, ONE_Z, ZERO_Z),
        (ZERO_Z, ZERO_Z, ONE_Z),
        (ONE_Z, ZERO_Z, ZERO_Z),
        ((0, 1, 1, 1), ZETA, (0, 1, 1, 0)),
        ((-1, -1, -1, -1), (-1, -1, 0, 0), (-1, -1, -1, 0)),
    )
    fourier_z = []
    for k in range(5):
        component = (ZERO_Z, ZERO_Z, ZERO_Z)
        for j in range(5):
            component = poly_zadd(component, poly_zscale(zpow(ZETA, k * j), local_z[j]))
        fourier_z.append(component)
    zero_poly_z = (ZERO_Z, ZERO_Z, ZERO_Z)
    assert fourier_z[0] == zero_poly_z
    assert fourier_z[1] == zero_poly_z
    assert all(fourier_z[k] != zero_poly_z for k in (2, 3, 4))
    for i, j in combinations(range(5), 2):
        assert poly_zadd(local_z[i], local_z[j]) != zero_poly_z
    local_vals = tuple(next(d for d, c in enumerate(poly) if c != ZERO_Z) for poly in local_z)
    assert local_vals == (1, 2, 0, 0, 0)
    assert sum(MU[i] * local_vals[i] for i in range(5)) == 11

    print("F55-TRACE-COBOUNDARY-RANK3-BOUNDARY-OK")


if __name__ == "__main__":
    main()
