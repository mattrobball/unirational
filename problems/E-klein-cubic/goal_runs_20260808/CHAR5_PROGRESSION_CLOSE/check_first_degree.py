#!/usr/bin/env python3
"""Exact first-allowed-degree audit for the 16 char-5 progression families.

For root degree n=2, each required C11 weight space has dimension at most
two.  We expand the full Klein landing identity over F5 and cover the open
H != 0, K != 0 in the single projective coefficient space by charts.  A
chart is empty exactly when its localized coefficient ideal has Groebner
basis [1].

This is a bounded theorem-forced audit, not an all-degree argument.
"""

from itertools import combinations_with_replacement, product

import sympy as sp


P = 5
W = (1, 9, 4, 3, 5)


def rho(e, power=1):
    power %= 5
    return tuple(e[(j - power) % 5] for j in range(5))


def add(*vectors):
    return tuple(sum(v[j] for v in vectors) for j in range(5))


def scale(a, vector):
    return tuple(a * x for x in vector)


def weight(e):
    return sum(x * w for x, w in zip(e, W)) % 11


def monomial_basis(degree, target_weight):
    result = []
    for indices in combinations_with_replacement(range(5), degree):
        e = tuple(indices.count(j) for j in range(5))
        if weight(e) == target_weight:
            result.append(e)
    return result


def coefficient_equations(d, r, n, h_coeffs, k_coeffs):
    a = tuple((d * j) % 5 for j in range(5))
    b = tuple((entry + r) % 5 for entry in a)
    A = weight(a)
    B = weight(b)
    wh = 9 * (1 - A) % 11
    wk = 9 * (1 - B) % 11
    hb = monomial_basis(n, wh)
    kb = monomial_basis(n, wk)
    assert len(hb) == len(h_coeffs)
    assert len(kb) == len(k_coeffs)

    # Coefficients are the chosen fifth roots.  Every term of K(T_f) has a
    # fifth-power coefficient; injectivity of Frobenius reduces its vanishing
    # to the cubic equations accumulated here.
    fterms = [
        (add(a, scale(5, e)), coefficient)
        for e, coefficient in zip(hb, h_coeffs)
    ] + [
        (add(b, scale(5, e)), coefficient)
        for e, coefficient in zip(kb, k_coeffs)
    ]

    accum = {}
    for i in range(5):
        left = [(rho(e, i), c) for e, c in fterms]
        right = [(rho(e, i + 1), c) for e, c in fterms]
        for (e1, c1), (e2, c2), (e3, c3) in product(left, left, right):
            exponent = add(e1, e2, e3)
            accum[exponent] = accum.get(exponent, 0) + c1 * c2 * c3

    equations = []
    for expression in accum.values():
        polynomial = sp.Poly(sp.expand(expression),
                             *(tuple(h_coeffs) + tuple(k_coeffs)), modulus=P)
        if not polynomial.is_zero:
            equations.append(polynomial.as_expr())
    return hb, kb, equations


def chart_is_empty(d, r, n, hdim, kdim, hi, ki):
    """Test the chart h_hi != 0 and k_ki != 0 correctly.

    There is only one common projective scaling: the bucket equations mix
    the H/K copy numbers, so H and K must not be normalized independently.
    We set h_hi=1 and localize at k_ki by adjoining tau*k_ki-1.
    """
    variables = sp.symbols(f"h0:{hdim}") + sp.symbols(f"k0:{kdim}")
    hs = variables[:hdim]
    ks = variables[hdim:]
    hb, kb, equations = coefficient_equations(d, r, n, hs, ks)
    substitutions = {hs[hi]: 1}
    remaining = tuple(v for v in variables if v not in substitutions)
    tau = sp.Symbol("tau")
    localized_variables = remaining + (tau,)
    equations = [sp.Poly(e.subs(substitutions), *localized_variables,
                         modulus=P).as_expr() for e in equations]
    equations.append(tau * ks[ki] - 1)
    equations = [e for e in equations if e != 0]
    basis = sp.groebner(equations, *localized_variables, modulus=P)
    empty = len(basis.polys) == 1 and basis.polys[0].as_expr() == 1
    return empty, localized_variables, [p.as_expr() for p in basis.polys]


def main():
    survivors = []
    unavailable = []
    for d in range(1, 5):
        a = tuple((d * j) % 5 for j in range(5))
        A = weight(a)
        for r in range(1, 5):
            b = tuple((entry + r) % 5 for entry in a)
            B = weight(b)
            wh = 9 * (1 - A) % 11
            wk = 9 * (1 - B) % 11
            hb = monomial_basis(2, wh)
            kb = monomial_basis(2, wk)
            if not hb or not kb:
                unavailable.append((d, r))
                print(f"FAMILY {(d,r)} n=2 unavailable dims={len(hb)},{len(kb)}")
                continue
            all_empty = True
            chart_count = 0
            for hi in range(len(hb)):
                for ki in range(len(kb)):
                    chart_count += 1
                    empty, variables, basis = chart_is_empty(
                        d, r, 2, len(hb), len(kb), hi, ki
                    )
                    if not empty:
                        all_empty = False
                        survivors.append((d, r, hi, ki, variables, basis))
                        print(f"NONEMPTY {(d,r)} chart={(hi,ki)} vars={variables} gb={basis}")
            print(f"FAMILY {(d,r)} n=2 charts={chart_count} empty={all_empty}")

    print(f"UNAVAILABLE_N2={unavailable}")
    print(f"NONEMPTY_CHART_COUNT={len(survivors)}")
    if not survivors:
        print("F55-CHAR5-PROGRESSION-DEGREE20-EMPTY-EXACT")
    else:
        print("F55-CHAR5-PROGRESSION-DEGREE20-HIT")

    # Once n=2 is empty, root degree three is the theorem-forced next layer
    # for every family.  It is also the first possible layer for
    # (2,2),(3,3),(4,3).
    n3_survivors = []
    for d in range(1, 5):
      for r in range(1, 5):
        a = tuple((d * j) % 5 for j in range(5))
        b = tuple((entry + r) % 5 for entry in a)
        wh = 9 * (1 - weight(a)) % 11
        wk = 9 * (1 - weight(b)) % 11
        hb = monomial_basis(3, wh)
        kb = monomial_basis(3, wk)
        print(f"FAMILY {(d,r)} n=3 dims={len(hb)},{len(kb)}")
        for hi in range(len(hb)):
            for ki in range(len(kb)):
                empty, variables, basis = chart_is_empty(
                    d, r, 3, len(hb), len(kb), hi, ki
                )
                if not empty:
                    n3_survivors.append((d, r, hi, ki, variables, basis))
                    print(f"NONEMPTY_N3 {(d,r)} chart={(hi,ki)} "
                          f"vars={variables} gb={basis}")
        print(f"FAMILY {(d,r)} n=3 nonempty_charts="
              f"{sum(x[:2] == (d,r) for x in n3_survivors)}")
    print(f"NONEMPTY_N3_CHART_COUNT={len(n3_survivors)}")
    if not n3_survivors:
        print("F55-CHAR5-PROGRESSION-DEGREE25-EMPTY-EXACT")


if __name__ == "__main__":
    main()
