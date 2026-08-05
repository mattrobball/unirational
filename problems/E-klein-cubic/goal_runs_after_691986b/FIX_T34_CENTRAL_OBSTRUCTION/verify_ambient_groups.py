#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
FIX-T34 -- the two ambient automorphism groups, verified rather than cited.

Both computations rest on one classical covariant.  For a form C in n+1
variables, the Hessian determinant satisfies

        Hess(C o A) = det(A)^2 * (Hess C) o A                          (*)

(because the Hessian matrix of C o A is A^T (H C o A) A).  For a Fermat form
C = sum x_i^d the Hessian matrix is diagonal, H C = diag(d(d-1) x_i^{d-2}), so

        Hess(C) = (d(d-1))^{n+1} * prod_i x_i^{d-2},

whose divisor is the sum of the n+1 coordinate hyperplanes (d >= 3).  By (*),
any A with C o A = C permutes those hyperplanes, i.e. A is monomial.  Then
C o A = C forces every entry of A to be a d-th root of unity.  Hence

    Lin(C) := {A in GL_{n+1} : C(Ax) = C(x)}  =  mu_d^{n+1} : S_{n+1},
    Aut(P^n, {C=0}) = Lin(C)/mu_d   (scalars in Lin(C) are exactly mu_d).

T3:  C = x1^4+x2^4+x3^4 :  |Lin| = 4^3*6 = 384, |Aut(P^2,B)| = 96,
     and |Aut(S)| = 2*96 = 192 for the double cover S: w^2 = C (the deck
     involution generates the kernel of Aut(S) -> Aut(P^2,B), which is onto
     because the anticanonical morphism of the degree-2 del Pezzo S is the
     double cover).
T4:  C = x1^3+...+x5^3 : |Lin| = 3^5*120 = 29160, |Aut(X)| = 29160/3 = 9720
     (all automorphisms of a smooth hypersurface of dimension >= 2 and degree
     >= 3 are linear -- Matsumura-Monsky).

This script checks (*) and the Hessian evaluation symbolically with sympy, and
enumerates the monomial solutions to confirm the orders.
"""

import itertools
import sympy as sp


def check_case(nvars, d, expect_lin, label):
    xs = sp.symbols("x0:%d" % nvars)
    C = sum(x ** d for x in xs)
    Hm = sp.hessian(C, xs)
    H = sp.factor(sp.expand(Hm.det()))
    want = sp.Integer(d * (d - 1)) ** nvars * sp.prod([x ** (d - 2) for x in xs])
    assert sp.simplify(H - want) == 0, (H, want)

    # covariance (*) on a generic matrix
    A = sp.Matrix(nvars, nvars, lambda i, j: sp.Symbol("a_%d_%d" % (i, j)))
    y = A * sp.Matrix(list(xs))
    CA = sum(y[i] ** d for i in range(nvars))
    lhs = sp.hessian(CA, xs)
    rhs = A.T * Hm.subs(list(zip(xs, list(y))), simultaneous=True) * A
    assert sp.simplify(sp.expand(lhs - rhs)) == sp.zeros(nvars, nvars)

    # enumerate the monomial elements of Lin(C)
    roots = [sp.exp(2 * sp.pi * sp.I * k / d) for k in range(d)]
    count = 0
    for sigma in itertools.permutations(range(nvars)):
        for e in itertools.product(range(d), repeat=nvars):
            M = sp.zeros(nvars, nvars)
            for j in range(nvars):
                M[sigma[j], j] = roots[e[j]]
            z = A * 0
            yy = M * sp.Matrix(list(xs))
            val = sp.expand(sum(yy[i] ** d for i in range(nvars)) - C)
            if sp.simplify(val) == 0:
                count += 1
    assert count == expect_lin, (count, expect_lin)
    print("%s: Hess = %s ; |Lin(C)| (monomial, and by (*) there are no others) = %d ; "
          "|Aut(P^%d,{C=0})| = %d"
          % (label, want, count, nvars - 1, count // d))
    return count


def main():
    n3 = check_case(3, 4, 4 ** 3 * 6, "T3  C = x1^4+x2^4+x3^4")
    print("     => |Aut(S)| = 2 * %d = %d   (S : w^2 = C, degree-2 del Pezzo)"
          % (n3 // 4, 2 * (n3 // 4)))
    n4 = check_case(5, 3, 3 ** 5 * 120, "T4  C = x1^3+...+x5^3")
    print("     => |Aut(X)| = %d   (X = {C=0} in P^4, cubic threefold)" % (n4 // 3))
    assert 2 * (n3 // 4) == 192
    assert n4 // 3 == 9720
    print()
    print("VERIFY_AMBIENT: PASS")


if __name__ == "__main__":
    main()
