#!/usr/bin/env python3
"""Exact finite collision-arrangement classifier for three Laurent terms.

This is deliberately only the analytically forced support stage.  It works
over F=Q[zeta_5].  A three-term Laurent polynomial has shifted exponent
vertices z_0,z_1,z_2 in F and its eighteen base trace contributions have
linear exponent forms

    L_(p,q;r)(z) = z_p + z_q + zeta*z_r,  p <= q.

Two base contributions have the same cyclic Laurent orbit exactly when
L_t(z)=zeta^k L_u(z).  For any nonzero z in F^3, all such collision rows lie
in the two-dimensional annihilator of z.  Hence collision coverage is an
exact finite rank-at-most-two hyperplane-arrangement problem.

No exponent box and no degree cutoff occurs here.
"""

from __future__ import annotations

from collections import defaultdict
from dataclasses import dataclass
from fractions import Fraction
from functools import cache

import sympy as sp


# Elements of Q[zeta_5] in the basis 1,zeta,zeta^2,zeta^3.  A tiny custom
# implementation is substantially faster here than generic ANP arithmetic.
ZERO = (Fraction(0),) * 4
ONE = (Fraction(1), Fraction(0), Fraction(0), Fraction(0))
ZETA = (Fraction(0), Fraction(1), Fraction(0), Fraction(0))


def fadd(a, b):
    return tuple(a[i] + b[i] for i in range(4))


def fneg(a):
    return tuple(-value for value in a)


def fsub(a, b):
    return tuple(a[i] - b[i] for i in range(4))


def fmul(a, b):
    work = [Fraction(0)] * 7
    for i in range(4):
        for j in range(4):
            work[i + j] += a[i] * b[j]
    for degree in range(6, 3, -1):
        value = work[degree]
        for target in range(degree - 4, degree):
            work[target] -= value
    return tuple(work[:4])


@cache
def fpow(a, exponent: int):
    if exponent == 0:
        return ONE
    if exponent < 0:
        return fpow(finv(a), -exponent)
    result = ONE
    base = a
    while exponent:
        if exponent & 1:
            result = fmul(result, base)
        base = fmul(base, base)
        exponent //= 2
    return result


@cache
def finv(a):
    assert a != ZERO
    # Solve the 4-by-4 rational multiplication matrix a*b=1.
    matrix = []
    for row in range(4):
        matrix.append([fmul(a, tuple(Fraction(1) if j == column else Fraction(0)
                                     for j in range(4)))[row]
                       for column in range(4)] + [ONE[row]])
    for column in range(4):
        pivot = next(i for i in range(column, 4) if matrix[i][column])
        matrix[column], matrix[pivot] = matrix[pivot], matrix[column]
        scale = matrix[column][column]
        matrix[column] = [value / scale for value in matrix[column]]
        for i in range(4):
            if i == column:
                continue
            scale = matrix[i][column]
            matrix[i] = [matrix[i][j] - scale * matrix[column][j]
                         for j in range(5)]
    result = tuple(matrix[i][4] for i in range(4))
    assert fmul(a, result) == ONE
    return result


@dataclass(frozen=True)
class Term:
    p: int
    q: int
    r: int
    form: tuple
    coeff_counts: tuple[int, int, int]
    multiplicity: int


def terms() -> tuple[Term, ...]:
    answer = []
    for p in range(3):
        for q in range(p, 3):
            for r in range(3):
                form = [ZERO, ZERO, ZERO]
                counts = [0, 0, 0]
                form[p] = fadd(form[p], ONE)
                form[q] = fadd(form[q], ONE)
                form[r] = fadd(form[r], ZETA)
                counts[p] += 1
                counts[q] += 1
                counts[r] += 1
                answer.append(Term(
                    p, q, r, tuple(form), tuple(counts), 1 if p == q else 2
                ))
    assert len(answer) == 18
    return tuple(answer)


TERMS = terms()


def collision_row(t: int, u: int, k: int) -> tuple:
    return tuple(
        fsub(TERMS[t].form[j], fmul(fpow(ZETA, k), TERMS[u].form[j]))
        for j in range(3)
    )


def normalize(vector: tuple) -> tuple:
    pivot = next(value for value in vector if value != ZERO)
    inverse = finv(pivot)
    return tuple(fmul(inverse, value) for value in vector)


def cross(left: tuple, right: tuple) -> tuple:
    return (
        fsub(fmul(left[1], right[2]), fmul(left[2], right[1])),
        fsub(fmul(left[2], right[0]), fmul(left[0], right[2])),
        fsub(fmul(left[0], right[1]), fmul(left[1], right[0])),
    )


def dot(left: tuple, right: tuple):
    result = ZERO
    for j in range(3):
        result = fadd(result, fmul(left[j], right[j]))
    return result


RAW_ROWS = tuple(
    collision_row(t, u, k)
    for t in range(18)
    for u in range(t + 1, 18)
    for k in range(5)
)

ALL_ROWS = tuple(sorted({normalize(row) for row in RAW_ROWS}, key=repr))
PAIR_ROWS = {
    (t, u): tuple({normalize(collision_row(t, u, k)) for k in range(5)})
    for t in range(18)
    for u in range(t + 1, 18)
}

# A state is (rank, datum).  At rank one datum is the normalized row.  At
# rank two it is the normalized one-dimensional right kernel.  This avoids
# repeated algebraic-field RREFs: membership is equality or one dot product.
ZERO_STATE = (0, ())


def extend(state, row):
    rank, datum = state
    if rank == 0:
        return 1, row
    if rank == 1:
        if row == datum:
            return state
        kernel = cross(datum, row)
        assert any(value != ZERO for value in kernel)
        return 2, normalize(kernel)
    if dot(row, datum) == ZERO:
        return state
    return None


def in_span(row: tuple, state) -> bool:
    rank, datum = state
    if not any(value != ZERO for value in row):
        return True
    if rank == 0:
        return False
    if rank == 1:
        return row == datum
    return dot(row, datum) == ZERO


def associated(t: int, u: int, state) -> bool:
    if t == u:
        return True
    pair = (t, u) if t < u else (u, t)
    # Reversing a collision row only scales it by a nonzero root of unity, so
    # the normalized hyperplane list is unchanged.
    return any(in_span(row, state) for row in PAIR_ROWS[pair])


def components(state) -> tuple[tuple[int, ...], ...]:
    unseen = set(range(18))
    answer = []
    while unseen:
        seed = min(unseen)
        component = {u for u in unseen if associated(seed, u, state)}
        # Association is mathematically transitive; assert it in the replay.
        assert all(associated(t, u, state) for t in component for u in component)
        unseen -= component
        answer.append(tuple(sorted(component)))
    return tuple(answer)


def covered(state) -> bool:
    return all(len(component) >= 2 for component in components(state))


def branch_covering_spaces() -> tuple[set, set]:
    """Find every rank-one and rank-two collision rowspace covering 18 terms."""
    accepted = {1: set(), 2: set()}
    visited = set()

    def visit(state):
        if state in visited:
            return
        visited.add(state)
        rank, _ = state
        comps = components(state)
        if all(len(component) >= 2 for component in comps):
            accepted[rank].add(state)
            if rank == 1:
                # Special points in this hyperplane can acquire an additional
                # independent collision.  Enumerate all such rank-two strata.
                for row in ALL_ROWS:
                    extension = extend(state, row)
                    if extension is not None and extension[0] == 2 and covered(extension):
                        accepted[2].add(extension)
            return
        if rank == 2:
            return
        singleton = next(component[0] for component in comps if len(component) == 1)
        extensions = set()
        for u in range(18):
            if u == singleton:
                continue
            pair = (singleton, u) if singleton < u else (u, singleton)
            for row in PAIR_ROWS[pair]:
                extension = extend(state, row)
                if extension is not None and extension[0] == rank + 1:
                    extensions.add(extension)
        for extension in extensions:
            visit(extension)

    visit(ZERO_STATE)
    return accepted[1], accepted[2]


x, y = sp.symbols("x y")


def component_polynomial(component: tuple[int, ...]):
    polynomial = 0
    for index in component:
        term = TERMS[index]
        polynomial += (
            term.multiplicity
            * x ** term.coeff_counts[1]
            * y ** term.coeff_counts[2]
        )
    return sp.expand(polynomial)


def q_linear_triangle_rank(state) -> int:
    rank, kernel = state
    assert rank == 2
    differences = [fsub(kernel[1], kernel[0]), fsub(kernel[2], kernel[0])]
    return sp.Matrix([[value for value in difference] for difference in differences]).rank()


def torus_coefficient_solution(state):
    polynomials = tuple(component_polynomial(c) for c in components(state))
    # The sum of all class polynomials is (1+x+y)^3.  Therefore a common
    # zero has y=-1-x.  The remaining exact torus decision is just a gcd of
    # univariate polynomials, after removing the forbidden roots x=0,-1.
    specialized = [
        sp.Poly(sp.expand(poly.subs(y, -1 - x)), x, domain=sp.QQ)
        for poly in polynomials
    ]
    nonzero = [poly for poly in specialized if not poly.is_zero]
    if not nonzero:
        return True, polynomials, sp.Poly(0, x, domain=sp.QQ)
    common = nonzero[0]
    for poly in nonzero[1:]:
        common = sp.gcd(common, poly)
    for forbidden in (sp.Poly(x, x), sp.Poly(x + 1, x)):
        while common.degree() > 0 and sp.rem(common, forbidden).is_zero:
            common = sp.quo(common, forbidden)
    return common.degree() > 0, polynomials, common.monic()


def main() -> None:
    assert fpow(ZETA, 5) == ONE
    assert sum((fpow(ZETA, k)[0] for k in range(5)), Fraction(0)) == 0
    assert tuple(sum((fpow(ZETA, k)[j] for k in range(5)), Fraction(0))
                 for j in range(4)) == ZERO
    assert not any(all(value == ZERO for value in row) for row in RAW_ROWS)

    rank1, rank2 = branch_covering_spaces()
    patterns = defaultdict(int)
    viable = []
    for rank, spaces in ((1, rank1), (2, rank2)):
        for state in spaces:
            comps = components(state)
            patterns[(rank, tuple(sorted(map(len, comps))))] += 1
            has_solution, polynomials, common_gcd = torus_coefficient_solution(state)
            if has_solution:
                viable.append((rank, state, comps, polynomials, common_gcd))

    print("TERMS", len(TERMS))
    print("UNIQUE_COLLISION_HYPERPLANES", len(ALL_ROWS))
    print("RANK1_COVERING_SPACES", len(rank1))
    print("RANK2_COVERING_SPACES", len(rank2))
    print("COMPONENT_SIZE_PATTERNS")
    for key, count in sorted(patterns.items()):
        print(key, count)
    print("COEFFICIENT_TORUS_VIABLE", len(viable))
    for index, item in enumerate(viable):
        rank, state, comps, polynomials, common_gcd = item
        print("VIABLE", index, "RANK", rank, "SIZES", tuple(map(len, comps)))
        print("STATE", state)
        print("Q_LINEAR_TRIANGLE_RANK", q_linear_triangle_rank(state))
        print("COMPONENTS", comps)
        print("POLYNOMIALS", polynomials)
        print("SPECIALIZED_COMMON_GCD", common_gcd.as_expr())

    assert len(rank1) == 0
    assert len(rank2) == 61
    assert len(viable) == 1
    assert viable[0][2] == (tuple(range(18)),)
    assert sp.expand(viable[0][3][0] - (1 + x + y)**3) == 0
    assert viable[0][1] == (2, (ONE, ONE, ONE))
    assert q_linear_triangle_rank(viable[0][1]) == 0
    print("F55-TRACE-THREE-TERM-ALL-EXPONENT-EXCLUSION-OK")


if __name__ == "__main__":
    main()
