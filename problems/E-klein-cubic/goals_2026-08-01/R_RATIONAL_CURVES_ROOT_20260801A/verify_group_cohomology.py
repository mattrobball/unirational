#!/usr/bin/env python3
"""Independent verifier for group_cohomology_payload.json.

This verifier does not import the producer.  It re-enumerates PSL_2(F_11)
from concrete 2 x 2 generators, transports the supplied integral action over
F_3 around the Cayley graph, reconstructs every derivation-consistency
equation, and compares Z^1 and B^1.
"""

from __future__ import annotations

from collections import deque
import json
from pathlib import Path

from sympy import Matrix, eye


HERE = Path(__file__).resolve().parent
PRIME = 3


def mul_mod(a, b):
    return [
        [sum(a[i][k] * b[k][j] for k in range(len(b))) % PRIME for j in range(len(b[0]))]
        for i in range(len(a))
    ]


def add_mod(a, b):
    return [[(x + y) % PRIME for x, y in zip(ar, br)] for ar, br in zip(a, b)]


def sub_mod(a, b):
    return [[(x - y) % PRIME for x, y in zip(ar, br)] for ar, br in zip(a, b)]


def identity(n):
    return [[1 if i == j else 0 for j in range(n)] for i in range(n)]


def rank_mod(matrix):
    a = [[x % PRIME for x in row] for row in matrix]
    rank = 0
    columns = len(a[0]) if a else 0
    for column in range(columns):
        pivot = next((row for row in range(rank, len(a)) if a[row][column]), None)
        if pivot is None:
            continue
        a[rank], a[pivot] = a[pivot], a[rank]
        inverse = pow(a[rank][column], -1, PRIME)
        a[rank] = [(inverse * x) % PRIME for x in a[rank]]
        for row in range(len(a)):
            if row != rank and a[row][column]:
                scale = a[row][column]
                a[row] = [(x - scale * y) % PRIME for x, y in zip(a[row], a[rank])]
        rank += 1
    return rank


def finite_mul(a, b):
    return tuple(
        sum(a[2 * i + k] * b[2 * k + j] for k in range(2)) % 11
        for i in range(2)
        for j in range(2)
    )


def canonical_projective(a):
    a = tuple(x % 11 for x in a)
    negative = tuple((-x) % 11 for x in a)
    return min(a, negative)


def main() -> None:
    payload = json.loads((HERE / "group_cohomology_payload.json").read_text(encoding="utf-8"))
    assert payload["schema"] == "klein-jacobian-group-cohomology-v1"
    assert payload["coefficient_prime"] == PRIME
    assert payload["module_dimension"] == 10

    s_integer = Matrix(payload["generators"]["S_matrix_Z"])
    t_integer = Matrix(payload["generators"]["T_matrix_Z"])
    ident_integer = eye(10)
    assert s_integer**2 == ident_integer
    assert t_integer**11 == ident_integer
    assert (s_integer * t_integer) ** 3 == ident_integer

    s = [[int(s_integer[i, j]) % PRIME for j in range(10)] for i in range(10)]
    t = [[int(t_integer[i, j]) % PRIME for j in range(10)] for i in range(10)]
    ident = identity(10)

    finite_one = canonical_projective((1, 0, 0, 1))
    finite_s = canonical_projective((0, 2, 5, 0))
    finite_t = canonical_projective((1, 2, 0, 1))
    representations = {finite_one: ident}
    derivations = {finite_one: [[0] * 20 for _ in range(10)]}
    queue = deque([finite_one])
    d_s = [row + [0] * 10 for row in ident]
    d_t = [[0] * 10 + row for row in ident]
    equations = []

    while queue:
        group_element = queue.popleft()
        for finite_generator, linear_generator, generator_derivation in (
            (finite_s, s, d_s),
            (finite_t, t, d_t),
        ):
            product = canonical_projective(finite_mul(group_element, finite_generator))
            product_representation = mul_mod(representations[group_element], linear_generator)
            product_derivation = add_mod(
                derivations[group_element],
                mul_mod(representations[group_element], generator_derivation),
            )
            if product in representations:
                assert representations[product] == product_representation
                equations.extend(sub_mod(product_derivation, derivations[product]))
            else:
                representations[product] = product_representation
                derivations[product] = product_derivation
                queue.append(product)

    equation_rank = rank_mod(equations)
    z1_dimension = 20 - equation_rank
    coboundary = [
        [(s[i][j] - ident[i][j]) % PRIME for j in range(10)] for i in range(10)
    ] + [
        [(t[i][j] - ident[i][j]) % PRIME for j in range(10)] for i in range(10)
    ]
    b1_dimension = rank_mod(coboundary)
    h1_dimension = z1_dimension - b1_dimension

    checks = payload["checks"]
    assert len(representations) == payload["group_order"] == 660
    assert equation_rank == checks["derivation_equation_rank_mod_3"] == 10
    assert z1_dimension == checks["Z1_dimension_mod_3"] == 10
    assert b1_dimension == checks["B1_dimension_mod_3"] == 10
    assert h1_dimension == checks["H1_dimension_mod_3"] == 0
    assert payload["deduction"]["statement"] == "H^1(PSL_2(F_11), J(X)[3]) = 0"

    print("INDEPENDENT_INTEGRAL_GENERATOR_RELATIONS_OK")
    print("INDEPENDENT_CAYLEY_ENUMERATION_ORDER_660_OK")
    print("INDEPENDENT_DERIVATION_AND_COBOUNDARY_RANKS_OK")
    print("KLEIN_JACOBIAN_H1_MOD_3_TRIVIAL")


if __name__ == "__main__":
    main()
