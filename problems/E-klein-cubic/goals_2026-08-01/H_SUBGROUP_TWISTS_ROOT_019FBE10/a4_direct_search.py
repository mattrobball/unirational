#!/usr/bin/env python3
"""Complete degree-1..4 projective A4-equivariant search at a good prime.

For each degree this computes the full Hom_A4(Sym^d(V3),W5), substitutes a
general member in the Klein cubic, and tests geometric projective emptiness
on every coefficient chart by Groebner bases over F_331.  All three linear
characters of A4 are included, so this is projective rather than merely
linear equivariance.
"""

from __future__ import annotations

import json
from pathlib import Path

import sympy as sp

import produce as base


HERE, P = Path(__file__).resolve().parent, 331


def multiplicative_order(x):
    value = 1
    for n in range(1, P):
        value = value * x % P
        if value == 1:
            return n
    raise AssertionError


ZETA11 = next(x for x in range(2, P) if multiplicative_order(x) == 11)
SQRT5 = next(x for x in range(P) if x*x % P == 5)
OMEGA = next(x for x in range(2, P) if multiplicative_order(x) == 3)


def reduce_cyclotomic(x):
    return sum(
        int(q.numerator) * pow(int(q.denominator), -1, P) * pow(ZETA11, i, P)
        for i, q in enumerate(x.a)
    ) % P


RHO = {
    g: [[reduce_cyclotomic(x) for x in row] for row in base.ew.rho[g]]
    for g in base.GROUP
}


def source_a5():
    inv2 = pow(2, -1, P)
    alpha = -(1 + SQRT5) * inv2 % P
    g5, g3 = (1, 2, 3, 4, 0), (0, 1, 3, 4, 2)
    M5 = [[alpha, -alpha % P, -1 % P], [alpha, 1, 0], [alpha, -alpha % P, 0]]
    M3 = [[0, -1 % P, -alpha % P], [0, 0, 1], [-1 % P, -alpha % P, 0]]
    identity = tuple(range(5))
    reps = {identity: [[1, 0, 0], [0, 1, 0], [0, 0, 1]]}
    from collections import deque
    queue = deque([identity])
    while queue:
        x = queue.popleft()
        for g, M in ((g5, M5), (g3, M3)):
            y = base.pc(x, g)
            YM = [[sum(reps[x][i][k] * M[k][j] for k in range(3)) % P
                   for j in range(3)] for i in range(3)]
            if y in reps:
                assert reps[y] == YM
            else:
                reps[y] = YM
                queue.append(y)
    assert len(reps) == 60
    return reps


SOURCE_A5 = source_a5()


def monomials(d):
    return tuple((a, b, d-a-b) for a in range(d + 1) for b in range(d-a + 1))


def padd(a, b):
    out = dict(a)
    for e, c in b.items():
        out[e] = (out.get(e, 0) + c) % P
        if not out[e]: del out[e]
    return out


def pmul(a, b):
    out = {}
    for ea, ca in a.items():
        for eb, cb in b.items():
            e = tuple(x+y for x, y in zip(ea, eb)); out[e] = (out.get(e, 0) + ca*cb) % P
    return {e: c for e, c in out.items() if c}


def ppow(a, n, variables):
    out = {(0,) * variables: 1}
    for _ in range(n): out = pmul(out, a)
    return out


def symmetric_action(M, mons):
    index = {e: i for i, e in enumerate(mons)}; n = len(mons)
    linear = [{tuple(int(j == k) for j in range(3)): M[i][k] for k in range(3) if M[i][k]}
              for i in range(3)]
    out = [[0] * n for _ in range(n)]
    for col, e in enumerate(mons):
        poly = {(0, 0, 0): 1}
        for i in range(3): poly = pmul(poly, ppow(linear[i], e[i], 3))
        for exponent, coefficient in poly.items(): out[index[exponent]][col] = coefficient
    return out


def nullspace_mod(rows):
    A = [[x % P for x in row] for row in rows]; m, n = len(A), len(A[0]); pivots = []
    r = 0
    for c in range(n):
        pivot = next((i for i in range(r, m) if A[i][c]), None)
        if pivot is None: continue
        A[r], A[pivot] = A[pivot], A[r]
        u = pow(A[r][c], -1, P); A[r] = [u*x % P for x in A[r]]
        for i in range(m):
            if i != r and A[i][c]:
                q = A[i][c]; A[i] = [(x-q*y) % P for x, y in zip(A[i], A[r])]
        pivots.append(c); r += 1
        if r == m: break
    free = [c for c in range(n) if c not in pivots]; basis = []
    for f in free:
        v = [0] * n; v[f] = 1
        for i, c in reversed(list(enumerate(pivots))): v[c] = -sum(A[i][j]*v[j] for j in free) % P
        basis.append(v)
    return basis


def covariant_basis(source, target, degree):
    mons = monomials(degree); n = len(mons); rows = []
    for S, R in zip(source, target):
        M = symmetric_action(S, mons)
        for i in range(5):
            for j in range(n):
                row = [0] * (5*n)
                for k in range(n): row[i*n+k] = (row[i*n+k] - M[k][j]) % P
                for k in range(5): row[k*n+j] = (row[k*n+j] + R[i][k]) % P
                rows.append(row)
    return mons, nullspace_mod(rows)


def landing_coefficients(mons, basis):
    q, variables = len(basis), 3 + len(basis); comps = []
    for i in range(5):
        poly = {}
        for r, vector in enumerate(basis):
            for j, e in enumerate(mons):
                c = vector[i*len(mons)+j] % P
                if c:
                    exponent = e + tuple(int(k == r) for k in range(q))
                    poly[exponent] = (poly.get(exponent, 0) + c) % P
        comps.append(poly)
    cubic = {}
    for i in range(5): cubic = padd(cubic, pmul(pmul(comps[i], comps[i]), comps[(i+1)%5]))
    coeffs = {}
    for e, c in cubic.items():
        source_e, parameter_e = e[:3], e[3:]
        coeffs.setdefault(source_e, {})[parameter_e] = c
    return tuple(coeffs.values())


def to_sympy(poly, variables):
    return sum(c * sp.prod(x**e for x, e in zip(variables, exponent)) for exponent, c in poly.items())


def projective_empty(coeffs, q):
    params = sp.symbols(f"p0:{q}"); charts = []
    for k in range(q):
        remaining = tuple(params[i] for i in range(q) if i != k)
        equations = [sp.expand(to_sympy(poly, params).subs(params[k], 1)) for poly in coeffs]
        if not remaining:
            unit = any(int(value) % P for value in equations)
            basis_size = int(unit)
        else:
            gb = sp.groebner(equations, *remaining, modulus=P)
            unit = gb.contains(sp.Integer(1)); basis_size = len(gb.polys)
        charts.append({"chart": k, "unit_ideal": bool(unit), "basis_size": basis_size})
    return all(row["unit_ideal"] for row in charts), charts


def main():
    first, _ = base.two_a5_classes(); a, b, A5 = first; mapping = base.iso(a, b, A5)
    involutions = [g for g in A5 if base.ORDERS[g] == 2]
    V4 = next(frozenset({base.ew.fone, x, y, base.gmul(x, y)}) for i, x in enumerate(involutions)
              for y in involutions[i+1:] if base.gmul(x, y) == base.gmul(y, x))
    A4 = base.normalizer(V4, A5); ga, gb = base.gens(A4)
    source = [SOURCE_A5[mapping[g]] for g in (ga, gb)]
    quotient_generator = next(g for g in A4 if base.ORDERS[g] == 3)
    cosets = [
        frozenset(base.gmul(v, base.gpow(quotient_generator, e)) for v in V4)
        for e in range(3)
    ]
    character_exponent = {
        g: next(e for e, coset in enumerate(cosets) if g in coset)
        for g in A4
    }
    assert all(
        character_exponent[base.gmul(x, y)] == (character_exponent[x] + character_exponent[y]) % 3
        for x in A4 for y in A4
    )
    records = []
    for degree in (1, 2, 3, 4):
        for character in range(3):
            target = [
                [[pow(OMEGA, character * character_exponent[g], P) * x % P for x in row]
                 for row in RHO[g]]
                for g in (ga, gb)
            ]
            mons, basis = covariant_basis(source, target, degree)
            coeffs = landing_coefficients(mons, basis)
            empty, charts = projective_empty(coeffs, len(basis))
            records.append({"degree": degree, "character_exponent": character,
                            "source_monomials": len(mons), "covariant_dimension": len(basis),
                            "landing_coefficient_count": len(coeffs),
                            "geometrically_empty": empty, "charts": charts})
            print(f"degree={degree} character={character} covariant_dimension={len(basis)} geometric_empty={empty}")
    payload = {"format": "H-A4-DIRECT-SEARCH-v2", "prime": P,
               "zeta11": ZETA11, "sqrt5": SQRT5, "omega3": OMEGA,
               "transfer": "projective coefficient scheme; empty good fibre implies empty characteristic-zero generic fibre",
               "records": records}
    (HERE / "a4_direct_search.json").write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("H_A4_DIRECT_SEARCH_OK")


if __name__ == "__main__": main()
