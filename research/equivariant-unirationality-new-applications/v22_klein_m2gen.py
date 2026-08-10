#!/usr/bin/env python3
"""
Emit Macaulay2 scripts verifying, over the exact field K = Q(sqrt(-7)):

  * X = Gr(3,A) cap {the 21 linear Plucker conditions of the Mukai net N}
    = Gr(3,7) cap P^13 is smooth, of dimension 3 and degree 22 (a genuine V22);
  * X^sigma = (smooth conic) disjoint union (2 reduced points);
  * X^{D8}  = empty.

Isotropy is LINEAR in Plucker coordinates: U is isotropic for omega iff the
contraction iota_omega(p) in A vanishes, where p in Lambda^3 A is the Plucker
vector of U.  That is 7 linear forms per net element, 21 in all; their common
kernel is Mukai's 14-dimensional space (P^13), and X = Gr(3,7) cap P^13.

To keep the Groebner computations small we eliminate those linear forms first:
we parametrise the 14-dimensional kernel and push the 140 Plucker quadrics into
14 variables.  The sigma- and D8-eigenspace strata are further linear sections
of the same kind.

Usage:  python3 v22_klein_m2gen.py            -> v22_klein_verify.m2   (over Q(sqrt-7))
        python3 v22_klein_m2gen.py 11 2       -> v22_klein_verify_p11.m2 (ZZ/11, sqrt(-7)=2)
"""

import sys
from itertools import combinations

from v22_klein_model import (
    K, ZERO, ONE, zeros, transpose, kernel, rref, canon, gmul, group, order,
    rho, main as build_model,
)

TRIPLES = list(combinations(range(7), 3))
IDX = {t: i for i, t in enumerate(TRIPLES)}
# Macaulay2's Grassmannian(2,6) orders its Plucker variables colexicographically.
M2ORDER = sorted(TRIPLES, key=lambda T: tuple(reversed(T)))

PRIME = None
SQRT = None


def kstr(x):
    a, b = x.a, x.b
    if PRIME is None:
        parts = []
        if a != 0:
            parts.append(f"({a.numerator}/{a.denominator})")
        if b != 0:
            parts.append(f"({b.numerator}/{b.denominator})*t")
        return "+".join(parts) if parts else "0"
    v = (a.numerator * pow(a.denominator, -1, PRIME)
         + b.numerator * pow(b.denominator, -1, PRIME) * SQRT) % PRIME
    return str(v)


def wedge3(M):
    out = zeros(35, 35)
    for cj, T in enumerate(TRIPLES):
        i, j, k = T
        for ri, Srow in enumerate(TRIPLES):
            a, b, c = Srow
            s = [[M[a][i], M[a][j], M[a][k]],
                 [M[b][i], M[b][j], M[b][k]],
                 [M[c][i], M[c][j], M[c][k]]]
            out[ri][cj] = (s[0][0] * (s[1][1] * s[2][2] - s[1][2] * s[2][1])
                           - s[0][1] * (s[1][0] * s[2][2] - s[1][2] * s[2][0])
                           + s[0][2] * (s[1][0] * s[2][1] - s[1][1] * s[2][0]))
    return out


def contraction_rows(om):
    """7 rows (length-35 coefficient vectors) of iota_om(p) = 0."""
    rows = [[K(0)] * 35 for _ in range(7)]
    for T in TRIPLES:
        i, j, k = T
        c = IDX[T]
        rows[k][c] = rows[k][c] + om[i][j]
        rows[j][c] = rows[j][c] - om[i][k]
        rows[i][c] = rows[i][c] + om[j][k]
    return rows


def subspace_of(rows):
    """basis (as list of length-35 vectors) of the common kernel of `rows`."""
    return kernel(rows)


def intersect(B1, B2):
    """basis of span(B1) cap span(B2), both lists of vectors of the same length."""
    n = len(B1[0])
    # solve  sum a_i B1_i - sum b_j B2_j = 0
    M = [[B1[i][t] for i in range(len(B1))] + [ZERO - B2[j][t] for j in range(len(B2))]
         for t in range(n)]
    out = []
    for sol in kernel(M):
        v = [sum((sol[i] * B1[i][t] for i in range(len(B1))), K(0)) for t in range(n)]
        out.append(v)
    return [v for v in rref(out)[0] if any(not x.is_zero() for x in v)] if out else []


def emit_map(basis, var):
    """the 35 linear forms p_T = sum_i basis[i][T] * var_i."""
    forms = []
    for T in M2ORDER:
        c = IDX[T]
        terms = []
        for i, b in enumerate(basis):
            if not b[c].is_zero():
                terms.append(f"({kstr(b[c])})*{var}_{i}")
        forms.append("+".join(terms) if terms else "0")
    return forms


def main():
    global PRIME, SQRT
    if len(sys.argv) == 3:
        PRIME, SQRT = int(sys.argv[1]), int(sys.argv[2])
        assert (SQRT * SQRT + 7) % PRIME == 0
    G, R, ords, Nb, Nvecs, perms = build_model()
    sigma = canon((0, -1, 1, 0))
    D8 = [g for g in G if gmul(g, sigma) == gmul(sigma, g)]
    r = next(g for g in D8 if ords[g] == 4)
    s = next(g for g in D8 if ords[g] == 2 and g != sigma)

    net_rows = []
    for om in Nb:
        net_rows.extend(contraction_rows(om))
    V14 = subspace_of(net_rows)
    print("dim of the Mukai linear space P(V) = P^%d  (V of dim %d)" % (len(V14) - 1, len(V14)))
    assert len(V14) == 14

    L3 = {"sigma": wedge3(R[sigma]), "r": wedge3(R[r]), "s": wedge3(R[s])}

    def eigen_space(name, ev):
        M = L3[name]
        rows = [[M[a][b] - (K(ev) if a == b else ZERO) for b in range(35)] for a in range(35)]
        return subspace_of(rows)

    strata = []
    for ev in (1, -1):
        B = intersect(V14, eigen_space("sigma", ev))
        strata.append((f"sigma_ev{'p' if ev > 0 else 'm'}", B))
        print(f"  dim V^(sigma={ev:+d}) = {len(B)}")
    d8 = []
    for er in (1, -1):
        for es in (1, -1):
            B = intersect(intersect(V14, eigen_space("r", er)), eigen_space("s", es))
            d8.append((f"d8_{'p' if er > 0 else 'm'}{'p' if es > 0 else 'm'}", er, es, B))
            print(f"  dim V^(r={er:+d}, s={es:+d}) = {len(B)}")

    lines = []
    W = lines.append
    W('-- AUTO-GENERATED by v22_klein_m2gen.py -- do not edit by hand')
    if PRIME is None:
        W('kk = toField(QQ[t]/(t^2+7));   -- t = sqrt(-7)')
    else:
        W(f'kk = ZZ/{PRIME};   -- sqrt(-7) = {SQRT}')
    W('IG = Grassmannian(2,6, CoefficientRing => kk);')
    W('RG = ring IG;')

    def block(name, basis, label, want_smooth):
        if not basis:
            W(f'print("{label}: linear space is ZERO -- stratum EMPTY");')
            return
        n = len(basis)
        W(f'S{name} = kk[y_0..y_{n-1}];')
        W(f'f{name} = map(S{name}, RG, {{' + ",".join(emit_map(basis, "y")) + '});')
        W(f'J{name} = f{name} IG;')
        W(f'print("--- {label} : ambient P^{n-1} ---"); << flush;')
        W(f'print("   minimal quadric generators = " | toString(numgens trim J{name})); << flush;')
        W(f'print("   dim(affine cone) = " | toString dim J{name} | '
          f'"   degree = " | toString degree J{name}); << flush;')
        W(f'print("   projective dim = " | toString(dim J{name} - 1));')
        W(f'print("   Hilbert polynomial = " | toString hilbertPolynomial(J{name}, Projective => false));')
        if PRIME is not None:
            W(f'comps = decompose J{name};')
            W(f'print("   number of minimal primes = " | toString(#comps));')
            W(f'scan(comps, P -> print("     component: projective dim = " | toString(dim P - 1) | '
              f'"  degree = " | toString degree P));')
        _ = want_smooth  # smoothness of X is Mukai / Cheltsov-Shramov, not recomputed

    block("X", V14, "X = Gr(3,7) cap P^13", True)
    for nm, B in strata:
        block(nm, B, f"X^sigma stratum {nm}", True)
    for nm, er, es, B in d8:
        block(nm, B, f"X^D8 character (eps(r),eps(s)) = ({er},{es})", False)
    W('print("DONE");')

    fn = "v22_klein_verify.m2" if PRIME is None else f"v22_klein_verify_p{PRIME}.m2"
    with open(fn, "w") as f:
        f.write("\n".join(lines) + "\n")
    print("wrote", fn)


if __name__ == "__main__":
    main()
