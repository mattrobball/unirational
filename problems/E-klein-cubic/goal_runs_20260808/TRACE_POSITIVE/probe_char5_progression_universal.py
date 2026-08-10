#!/usr/bin/env python3
"""Exact F5 torus probe for the fixed progression-bucket system.

This enumerates only the 4^5 possible ratio vectors and 4^5 possible
linearized torus vectors for each of the four universal patterns.  It does
not enumerate polynomial degrees or supports.
"""

from itertools import product

P = 5
NONZERO = range(1, P)


def equations(c, a, z):
    out = []
    for t in range(5):
        i0 = t
        i1 = (t + c) % 5
        i2 = (t + 2 * c) % 5
        i3 = (t + 3 * c) % 5
        out.append((
            a[i0]
            + a[i1] * (z[(i1 + 1) % 5] + 2 * z[i1])
            + a[i2] * (2 * z[i2] * z[(i2 + 1) % 5] + z[i2] ** 2)
            + a[i3] * z[i3] ** 2 * z[(i3 + 1) % 5]
        ) % P)
    return tuple(out)


def jacobian(c, a, z):
    rows = []
    for t in range(5):
        i0 = t
        i1 = (t + c) % 5
        i2 = (t + 2 * c) % 5
        i3 = (t + 3 * c) % 5
        row = [0] * 10
        row[i0] += 1
        row[i1] += z[(i1 + 1) % 5] + 2 * z[i1]
        row[i2] += 2 * z[i2] * z[(i2 + 1) % 5] + z[i2] ** 2
        row[i3] += z[i3] ** 2 * z[(i3 + 1) % 5]
        row[5 + i1] += 2 * a[i1]
        row[5 + (i1 + 1) % 5] += a[i1]
        row[5 + i2] += a[i2] * (2 * z[(i2 + 1) % 5] + 2 * z[i2])
        row[5 + (i2 + 1) % 5] += 2 * a[i2] * z[i2]
        row[5 + i3] += 2 * a[i3] * z[i3] * z[(i3 + 1) % 5]
        row[5 + (i3 + 1) % 5] += a[i3] * z[i3] ** 2
        rows.append([entry % P for entry in row])
    return rows


def coefficient_matrix(c, z):
    # The first five Jacobian columns are the coefficients of the a_i.
    return [row[:5] for row in jacobian(c, (1, 1, 1, 1, 1), z)]


def rank_mod_p(matrix):
    matrix = [row[:] for row in matrix]
    rank = 0
    for col in range(len(matrix[0])):
        pivot = next((i for i in range(rank, len(matrix))
                      if matrix[i][col] % P), None)
        if pivot is None:
            continue
        matrix[rank], matrix[pivot] = matrix[pivot], matrix[rank]
        inv = pow(matrix[rank][col], -1, P)
        matrix[rank] = [(inv * x) % P for x in matrix[rank]]
        for i in range(len(matrix)):
            if i != rank and matrix[i][col] % P:
                factor = matrix[i][col]
                matrix[i] = [(x - factor * y) % P
                             for x, y in zip(matrix[i], matrix[rank])]
        rank += 1
        if rank == len(matrix):
            break
    return rank


for c in NONZERO:
    witness = None
    for z in product(NONZERO, repeat=5):
        if len(set(z)) == 1:  # v is proportional to u
            continue
        for a in product(NONZERO, repeat=5):
            if any(equations(c, a, z)):
                continue
            klein_u = sum(a) % P
            klein_v = sum(a[i] * z[i] ** 2 * z[(i + 1) % 5]
                          for i in range(5)) % P
            if klein_u and klein_v:
                witness = (a, z, klein_u, klein_v)
                break
        if witness:
            break
    assert witness is not None
    jac_rank = rank_mod_p(jacobian(c, witness[0], witness[1]))
    matrix_rank = rank_mod_p(coefficient_matrix(c, witness[1]))
    assert jac_rank == 5
    assert matrix_rank == 4
    print(f"c={c} a={witness[0]} z={witness[1]} "
          f"K_u={witness[2]} K_v={witness[3]} "
          f"Mrank={matrix_rank} Jrank={jac_rank}")

print("F55-CHAR5-PROGRESSION-UNIVERSAL-FORCING-REFUTED")
