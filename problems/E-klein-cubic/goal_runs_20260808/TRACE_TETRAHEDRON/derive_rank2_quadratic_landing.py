#!/usr/bin/env python3
"""Universal cyclic-factor equations for a rank-two quadratic landing form.

In the cyclic-factor branch, l_0,...,l_3 are coordinates and
l_4=-(l_0+...+l_3).  Write m_0=sum_{k=0}^3 a_k*l_k and obtain m_i by cyclic
shift.  This derives the coefficient ideal of sum_i (l_i*m_i)^2
(l_(i+1)*m_(i+1)).  It is not a lattice/support enumeration.
"""

import sympy as sp


L = sp.symbols("L0:4")
a = sp.symbols("a0:4")
L5 = (*L, -sum(L))


def shifted(index):
    return sum(a[k] * L5[(index + k) % 5] for k in range(4))


def coefficient_equations():
    M = [shifted(i) for i in range(5)]
    Q = [L5[i] * M[i] for i in range(5)]
    landing = sp.expand(sum(Q[i] ** 2 * Q[(i + 1) % 5] for i in range(5)))
    polynomial = sp.Poly(landing, *L)
    equations = tuple(sp.factor(coefficient) for _, coefficient in polynomial.terms())
    return landing, equations


def main():
    landing, equations = coefficient_equations()
    print("RANK2_CYCLIC_LANDING_DEGREE", sp.Poly(landing, *L).total_degree())
    print("RANK2_CYCLIC_COEFFICIENT_EQUATIONS", len(equations))
    basis = sp.groebner(equations, *a, order="grevlex")
    print("RANK2_CYCLIC_GROEBNER_SIZE", len(basis.polys))
    print("RANK2_CYCLIC_ZERO_DIMENSIONAL", basis.is_zero_dimensional)
    for polynomial in basis.polys:
        print("G", sp.factor(polynomial.as_expr()))


if __name__ == "__main__":
    main()
