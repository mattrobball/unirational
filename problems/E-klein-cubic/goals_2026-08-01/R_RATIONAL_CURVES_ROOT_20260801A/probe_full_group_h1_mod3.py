#!/opt/homebrew/bin/python3
"""Compute H^1(PSL_2(F_11), J(X)[3]) from the exact period lattice.

The full order-660 Weil representation is conjugated into Roulleau's
integral period-lattice basis.  A Cayley-graph derivation calculation then
computes 1-cocycles and principal 1-cocycles over F_3.
"""

from __future__ import annotations

from collections import deque
from fractions import Fraction
import json
from pathlib import Path

from sympy import CRootOf, QQ, Symbol, cyclotomic_poly


N = 5
HERE = Path(__file__).resolve().parent


def mat_identity(one, zero):
    return [[one if i == j else zero for j in range(N)] for i in range(N)]


def matmul(a, b, zero):
    return [
        [sum((a[i][k] * b[k][j] for k in range(N)), zero) for j in range(N)]
        for i in range(N)
    ]


def matvec(a, v, zero):
    return [sum((a[i][j] * v[j] for j in range(N)), zero) for i in range(N)]


def matpow(a, exponent, one, zero):
    result = mat_identity(one, zero)
    base = a
    while exponent:
        if exponent & 1:
            result = matmul(result, base, zero)
        base = matmul(base, base, zero)
        exponent >>= 1
    return result


def mat_inverse(a, one, zero):
    aug = [row[:] + ident[:] for row, ident in zip(a, mat_identity(one, zero))]
    for col in range(N):
        pivot = next(row for row in range(col, N) if aug[row][col] != zero)
        aug[col], aug[pivot] = aug[pivot], aug[col]
        scale = one / aug[col][col]
        aug[col] = [scale * x for x in aug[col]]
        for row in range(N):
            if row == col:
                continue
            scale = aug[row][col]
            if scale != zero:
                aug[row] = [x - scale * y for x, y in zip(aug[row], aug[col])]
    return [row[N:] for row in aug]


def columns(cols):
    return [[cols[j][i] for j in range(len(cols))] for i in range(len(cols[0]))]


def anp_to_qnu(value, nu, field) -> tuple[int, int]:
    """Recognize an algebraic integer as a+b*nu, with a,b in Z."""
    rep = list(value.rep)
    rep = [field.dom.to_sympy(x) for x in rep]
    rep = [0] * (10 - len(rep)) + rep
    # Coefficients are in descending zeta degree 9,...,0.
    a = rep[9]
    b = rep[8]
    assert getattr(a, "q", 1) == 1 and getattr(b, "q", 1) == 1, (a, b, rep)
    candidate = field.convert(int(a)) + field.convert(int(b)) * nu
    assert value == candidate, (value, candidate)
    return int(a), int(b)


def restriction_matrix(matrix, nu, field) -> list[list[int]]:
    result = [[0] * 10 for _ in range(10)]
    for i in range(5):
        for j in range(5):
            a, b = anp_to_qnu(matrix[i][j], nu, field)
            result[2 * i][2 * j] = a
            result[2 * i + 1][2 * j] = b
            result[2 * i][2 * j + 1] = -3 * b
            result[2 * i + 1][2 * j + 1] = a - b
    return result


def mul_mod(a, b, prime):
    return [
        [sum(a[i][k] * b[k][j] for k in range(len(b))) % prime for j in range(len(b[0]))]
        for i in range(len(a))
    ]


def add_mod(a, b, prime):
    return [[(x + y) % prime for x, y in zip(ar, br)] for ar, br in zip(a, b)]


def sub_mod(a, b, prime):
    return [[(x - y) % prime for x, y in zip(ar, br)] for ar, br in zip(a, b)]


def eye_mod(n):
    return [[1 if i == j else 0 for j in range(n)] for i in range(n)]


def rank_mod(matrix, prime):
    a = [[x % prime for x in row] for row in matrix]
    rank = 0
    cols = len(a[0]) if a else 0
    for col in range(cols):
        pivot = next((r for r in range(rank, len(a)) if a[r][col]), None)
        if pivot is None:
            continue
        a[rank], a[pivot] = a[pivot], a[rank]
        inv = pow(a[rank][col], -1, prime)
        a[rank] = [(inv * x) % prime for x in a[rank]]
        for r in range(len(a)):
            if r != rank and a[r][col]:
                scale = a[r][col]
                a[r] = [(x - scale * y) % prime for x, y in zip(a[r], a[rank])]
        rank += 1
    return rank


def fmul(a, b):
    return tuple(sum(a[2 * i + k] * b[2 * k + j] for k in range(2)) % 11 for i in range(2) for j in range(2))


def fcanon(a):
    a = tuple(x % 11 for x in a)
    b = tuple((-x) % 11 for x in a)
    return min(a, b)


def main() -> None:
    x = Symbol("x")
    root = CRootOf(cyclotomic_poly(11, x), 0)
    field = QQ.algebraic_field(root)
    zeta = field.from_sympy(root)
    zero, one = field.zero, field.one

    powers = [zeta ** i for i in range(11)]
    quadratic_residues = {1, 3, 4, 5, 9}
    gauss = sum(((1 if i in quadratic_residues else -1) * powers[i] for i in range(1, 11)), zero)
    assert gauss * gauss == field.convert(-11)

    js = [1, 3, 2, 5, 4]
    signs = [1, 1, -1, 1, 1]
    s_weil = [
        [
            field.convert(Fraction(signs[k], signs[i]))
            * (powers[(9 * j * ell) % 11] - powers[(-9 * j * ell) % 11])
            * (-gauss)
            / field.convert(11)
            for k, ell in enumerate(js)
        ]
        for i, j in enumerate(js)
    ]
    exponents = [(j * j) % 11 for j in js]
    t_weil = [[powers[exponents[i]] if i == j else zero for j in range(5)] for i in range(5)]
    ident5 = mat_identity(one, zero)
    assert matpow(s_weil, 2, one, zero) == ident5
    assert matpow(t_weil, 11, one, zero) == ident5
    assert matpow(matmul(s_weil, t_weil, zero), 3, one, zero) == ident5

    # Roulleau's v_k Fourier basis and integral O=Z[nu] period basis.
    v_matrix = [[powers[(exponents[i] * k) % 11] for k in range(5)] for i in range(5)]
    nu = sum((powers[i] for i in quadratic_residues), zero)
    assert nu * nu + nu + field.convert(3) == zero
    delta = one + field.convert(2) * nu
    assert delta * delta == field.convert(-11)
    lattice_cols = [
        [one / delta, field.convert(-3) / delta, field.convert(3) / delta, -one / delta, zero],
        [zero, one / delta, field.convert(-3) / delta, field.convert(3) / delta, -one / delta],
        [one, zero, zero, zero, zero],
        [zero, one, zero, zero, zero],
        [zero, zero, one, zero, zero],
    ]
    lattice_v = columns(lattice_cols)
    lattice_e = matmul(v_matrix, lattice_v, zero)
    lattice_e_inv = mat_inverse(lattice_e, one, zero)
    s_lattice = matmul(matmul(lattice_e_inv, s_weil, zero), lattice_e, zero)
    t_lattice = matmul(matmul(lattice_e_inv, t_weil, zero), lattice_e, zero)
    s_z = restriction_matrix(s_lattice, nu, field)
    t_z = restriction_matrix(t_lattice, nu, field)

    # Exact group relations after passage to the integral rank-10 lattice.
    prime = 3
    s3 = [[entry % prime for entry in row] for row in s_z]
    t3 = [[entry % prime for entry in row] for row in t_z]
    ident10 = eye_mod(10)
    assert mul_mod(s3, s3, prime) == ident10
    t_power = ident10
    for _ in range(11):
        t_power = mul_mod(t_power, t3, prime)
    assert t_power == ident10

    # Enumerate the Cayley graph and all derivation consistency equations.
    fone = fcanon((1, 0, 0, 1))
    fs = fcanon((0, 2, 5, 0))
    ft = fcanon((1, 2, 0, 1))
    rep = {fone: ident10}
    derivation = {fone: [[0] * 20 for _ in range(10)]}
    queue = deque([fone])
    d_s = [row + [0] * 10 for row in ident10]
    d_t = [[0] * 10 + row for row in ident10]
    equations: list[list[int]] = []
    while queue:
        g = queue.popleft()
        for abstract_generator, linear_generator, d_generator in ((fs, s3, d_s), (ft, t3, d_t)):
            h = fcanon(fmul(g, abstract_generator))
            rep_h = mul_mod(rep[g], linear_generator, prime)
            deriv_h = add_mod(derivation[g], mul_mod(rep[g], d_generator, prime), prime)
            if h in rep:
                assert rep[h] == rep_h
                equations.extend(sub_mod(deriv_h, derivation[h], prime))
            else:
                rep[h] = rep_h
                derivation[h] = deriv_h
                queue.append(h)
    assert len(rep) == 660

    equation_rank = rank_mod(equations, prime)
    z1_dimension = 20 - equation_rank
    coboundary = [
        [(s3[i][j] - ident10[i][j]) % prime for j in range(10)]
        for i in range(10)
    ] + [
        [(t3[i][j] - ident10[i][j]) % prime for j in range(10)]
        for i in range(10)
    ]
    b1_dimension = rank_mod(coboundary, prime)
    h1_dimension = z1_dimension - b1_dimension
    assert b1_dimension == 10
    assert h1_dimension == 0

    payload = {
        "schema": "klein-jacobian-group-cohomology-v1",
        "description": (
            "Exact rank-10 integral period-lattice action of the standard "
            "PSL_2(F_11) generators and a Cayley-graph computation of "
            "H^1(PSL_2(F_11), J(X)[3])."
        ),
        "coefficient_prime": prime,
        "module_dimension": 10,
        "group_order": len(rep),
        "generators": {
            "S_matrix_Z": s_z,
            "T_matrix_Z": t_z,
            "presentation_relations": ["S^2=1", "T^11=1", "(ST)^3=1"],
        },
        "checks": {
            "derivation_unknowns": 20,
            "derivation_equation_rank_mod_3": equation_rank,
            "Z1_dimension_mod_3": z1_dimension,
            "B1_dimension_mod_3": b1_dimension,
            "H1_dimension_mod_3": h1_dimension,
        },
        "deduction": {
            "statement": "H^1(PSL_2(F_11), J(X)[3]) = 0",
            "scope": "The Klein cubic intermediate-Jacobian 3-torsion module.",
        },
    }
    output = HERE / "group_cohomology_payload.json"
    output.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8")

    print("integral_full_group_matrices", len(s_z), "x", len(s_z[0]))
    print("cayley_group_order", len(rep))
    print("derivation_equation_rank_mod_3", equation_rank)
    print("Z1_dimension_mod_3", z1_dimension)
    print("B1_dimension_mod_3", b1_dimension)
    print("H1_dimension_mod_3", h1_dimension)
    print("wrote", output.name)
    print("KLEIN_JACOBIAN_H1_MOD_3_TRIVIAL")


if __name__ == "__main__":
    main()
