#!/usr/bin/env python3
"""Discovery screen for very sparse points in the natural (t,u,v) frame.

The screen is deliberately bounded and cannot certify nonexistence.  A hit
must be reconstructed over characteristic zero by a separate producer.
"""

from __future__ import annotations

from itertools import combinations_with_replacement, product

import numpy as np

from model import specialized_cubic, specialized_field


SAMPLES = (
    {"A": 1, "B": 2, "Y": 3, "Z": 4},
    {"A": 1, "B": 1, "Y": 1, "Z": 1},
    {"A": 2, "B": 3, "Y": 5, "Z": 7},
    {"A": 3, "B": 1, "Y": 4, "Z": 2},
)


def monomials(field, maximum_degree=3):
    generators = (field.t_element, field.u_element, field.v_element)
    names = ("t", "u", "v")
    result = [("1", field.element(1))]
    for degree in range(1, maximum_degree + 1):
        for indices in combinations_with_replacement(range(3), degree):
            value = field.element(1)
            exponents = [0, 0, 0]
            for index in indices:
                value = field.mul(value, generators[index])
                exponents[index] += 1
            name = "*".join(
                names[index] if exponent == 1 else f"{names[index]}^{exponent}"
                for index, exponent in enumerate(exponents)
                if exponent
            )
            result.append((name, value))
    return result


def vector(field, value):
    reduced = field.element(value)
    return np.array(
        [int(reduced.nth(index)) % field.prime for index in range(6)],
        dtype=np.int64,
    )


def multiplication_tensor(field):
    tensor = np.zeros((6, 6, 6), dtype=np.int64)
    powers = [field.element(1)]
    for _ in range(1, 11):
        powers.append(field.mul(powers[-1], field.u_element))
    for left in range(6):
        for right in range(6):
            tensor[left, right] = vector(field, powers[left + right])
    return tensor


def mul(left, right, tensor, prime):
    return np.einsum("i,j,ijk->k", left, right, tensor, optimize=True) % prime


def cubic_scalar_table(field, X, y, w, tensor, scalar_pairs):
    """Evaluate all [sx*X:sy*y:w] rows at once."""

    p = field.prime
    q, r = specialized_cubic(field.values, p, 9)
    X2, y2, w2 = (mul(value, value, tensor, p) for value in (X, y, w))
    coefficients = np.stack(
        (
            mul(X2, X, tensor, p),
            q[0] * mul(X, y2, tensor, p) % p,
            q[1] * mul(mul(X, y, tensor, p), w, tensor, p) % p,
            q[2] * mul(X, w2, tensor, p) % p,
            r[0] * mul(y2, y, tensor, p) % p,
            r[1] * mul(y2, w, tensor, p) % p,
            r[2] * mul(y, w2, tensor, p) % p,
            r[3] * mul(w2, w, tensor, p) % p,
        )
    )
    scalar_rows = np.asarray(
        [
            (sx**3, sx * sy**2, sx * sy, sx, sy**3, sy**2, sy, 1)
            for sx, sy in scalar_pairs
        ],
        dtype=np.int64,
    )
    return scalar_rows @ coefficients % p


def main() -> None:
    fields = [specialized_field(sample) for sample in SAMPLES]
    monomial_sets = [monomials(field) for field in fields]
    vector_sets = [
        [vector(field, value) for _, value in rows]
        for field, rows in zip(fields, monomial_sets)
    ]
    tensors = [multiplication_tensor(field) for field in fields]
    names = [name for name, _ in monomial_sets[0]]
    assert all([name for name, _ in rows] == names for rows in monomial_sets)

    # Overall projective scaling is normalized by leaving w unscaled.
    scalars = (1, -1, 2, -2, 3, -3, 4, -4)
    scalar_pairs = tuple(product(scalars, repeat=2))
    hits = []
    tested = 0
    for ix, iy, iw in product(range(len(names)), repeat=3):
        survivor_indices = np.arange(len(scalar_pairs))
        for field, rows, tensor in zip(fields, vector_sets, tensors):
            values = cubic_scalar_table(
                field, rows[ix], rows[iy], rows[iw], tensor, scalar_pairs
            )
            survivor_indices = survivor_indices[
                np.all(values[survivor_indices] == 0, axis=1)
            ]
            if not len(survivor_indices):
                break
        tested += len(scalar_pairs)
        for survivor in survivor_indices:
            sx, sy = scalar_pairs[int(survivor)]
            hits.append((sx, names[ix], sy, names[iy], names[iw]))

    print(f"samples={len(fields)}")
    print(f"monomials={len(names)}")
    print(f"tested={tested}")
    print(f"hits={hits}")
    print("SPARSE_MONOMIAL_POINT_SCREEN_DONE")


if __name__ == "__main__":
    main()
