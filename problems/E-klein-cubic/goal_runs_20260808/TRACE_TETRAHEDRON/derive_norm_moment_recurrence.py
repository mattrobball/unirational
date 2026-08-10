#!/usr/bin/env python3
"""Low-order coefficients of the exact norm-conic restricted trace series.

After z_j,2*z_j,3=lambda, put m_n=sum_j A_j*u_j^n.  The common lambda
power is omitted.  This script prints only the analytically reduced
two-variable trace coefficients with m_-1=m_0=m_1=0.
"""

from math import comb

import sympy as sp


z = sp.symbols("z")
phi5 = z**4 + z**3 + z**2 + z + 1
MAX_TOTAL = 10
m = {n: sp.symbols(f"m{n}" if n >= 0 else f"mn{-n}") for n in range(-MAX_TOTAL, MAX_TOTAL + 1)}


def reduce_z(expression):
    return sp.Poly(sp.expand(expression), z, domain="EX").rem(
        sp.Poly(phi5, z, domain="EX")
    ).as_expr()


def triples(total):
    for a in range(total + 1):
        for b in range(total - a + 1):
            yield a, b, total - a - b


def multinomial3(total, parts):
    a, b, c = parts
    return comb(total, a) * comb(total - a, b)


def coefficient(P, Q):
    if (P - Q) % 5:
        return 0
    answer = 0
    for ps in triples(P):
        cp = multinomial3(P, ps)
        for qs in triples(Q):
            cq = multinomial3(Q, qs)
            ns = tuple(ps[i] - qs[i] for i in range(3))
            answer += (
                cp
                * cq
                * z ** ((2 * ns[2]) % 5)
                * m[ns[0]]
                * m[ns[1]]
                * m[ns[2]]
            )
    return sp.factor(reduce_z(answer.subs({m[-1]: 0, m[0]: 0, m[1]: 0})))


def main():
    for total in range(0, MAX_TOTAL + 1):
        rows = []
        for P in range(total + 1):
            Q = total - P
            value = coefficient(P, Q)
            if value != 0:
                rows.append((P, Q, value))
        if rows:
            print("TOTAL", total)
            for P, Q, value in rows:
                print("E", P, Q, value)


if __name__ == "__main__":
    main()
