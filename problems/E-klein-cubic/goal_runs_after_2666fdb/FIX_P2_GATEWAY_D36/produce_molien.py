#!/usr/bin/env python3
"""FIX-P1 Stage 2(c), part 0 -- exact Molien dimensions of the covariant module.

    M_d := ( Sym^d(W*) (x) W )^G ,   G = PSL(2,11) of order 660,
    W = a 5-dimensional Weil representation.

Method: exact character theory.  Only the character table row of W and the
power maps are needed; the eigenvalue multisets of rho(g) are RECOVERED from
the character by discrete Fourier inversion, and all arithmetic is done
exactly in Z[z]/(Phi_330(z)) (330 = lcm of the element orders).

    dim M_d = (1/|G|) sum_{g} conj( h_d(eigs of rho(g)) ) . chi_W(g)

Self-tests (all must pass):
  * every recovered eigenvalue multiset has size 5 and trace = chi(g);
  * chi is a genuine irreducible character: <chi,chi> = 1, <chi,1> = 0;
  * dim M_0 = dim W^G = 0, dim M_1 = dim End(W)^G = 1 (Schur, W irreducible);
  * the invariant ring dims (Sym^d W*)^G reproduce the known Klein data:
    the first invariant is the CUBIC F, i.e. dims 1,0,0,1,... in d=0..;
  * every computed dimension is a non-negative integer.

Also emits dim (Sym^{3d} W*)^G = the number of scalar landing equations
F(T) = 0 imposes when T has degree d.
"""
import json
import os
import sys

from sympy import cyclotomic_poly, Poly, symbols, ZZ

HERE = os.path.dirname(os.path.abspath(__file__))
PAY = os.path.join(HERE, "payloads")

N = 330                      # lcm(1,2,3,5,6,11)
DMAX = 50
IMAX = 78          # invariants only needed to Sym^75 (the d=25 landing count)

z = symbols("z")
PHI = Poly(cyclotomic_poly(N, z), z, domain=ZZ)
DEG = PHI.degree()
PHIC = PHI.all_coeffs()[::-1]        # ascending, monic
assert PHIC[-1] == 1


def red(v):
    """Reduce an ascending integer coefficient list modulo Phi_330."""
    v = list(v)
    for i in range(len(v) - 1, DEG - 1, -1):
        c = v[i]
        if c:
            v[i] = 0
            for j in range(DEG):
                v[i - DEG + j] -= c * PHIC[j]
    del v[DEG:]
    while len(v) < DEG:
        v.append(0)
    return v


def mul(a, b):
    out = [0] * (len(a) + len(b) - 1)
    for i, ai in enumerate(a):
        if ai:
            for j, bj in enumerate(b):
                if bj:
                    out[i + j] += ai * bj
    return red(out)


def add(a, b):
    return [x + y for x, y in zip(a, b)]


def zeta(k, a):
    """zeta_k^a as an element of Z[z]/Phi_330."""
    e = (N // k) * a % N
    v = [0] * (N)
    v[e] = 1
    return red(v)


ONE = zeta(1, 0)
ZERO = [0] * DEG

# --------------------------------------------------------- the character data
# PSL(2,11): classes, sizes, element orders, power map j -> class of g^j.
CLASSES = ["1A", "2A", "3A", "5A", "5B", "6A", "11A", "11B"]
SIZE = {"1A": 1, "2A": 55, "3A": 110, "5A": 132, "5B": 132,
        "6A": 110, "11A": 60, "11B": 60}
ORDER = {"1A": 1, "2A": 2, "3A": 3, "5A": 5, "5B": 5,
         "6A": 6, "11A": 11, "11B": 11}
assert sum(SIZE.values()) == 660

# chi_W on the classes, as elements of Z[z]/Phi_330.
# 5, 1, -1, 0, 0, 1, (-1+sqrt(-11))/2, (-1-sqrt(-11))/2 ;
# the two irrational values are the two Gauss periods
#     sum_{a in QR(11)} zeta_11^a   and   sum_{a in NQR(11)} zeta_11^a .
QR11 = sorted({(a * a) % 11 for a in range(1, 11)})            # {1,3,4,5,9}
NQR11 = [a for a in range(1, 11) if a not in QR11]


def period(S):
    v = ZERO
    for a in S:
        v = add(v, zeta(11, a))
    return v


CHI = {
    "1A": [5 * c for c in ONE],
    "2A": ONE,
    "3A": [-c for c in ONE],
    "5A": ZERO,
    "5B": ZERO,
    "6A": ONE,
    "11A": period(QR11),
    "11B": period(NQR11),
}

# Power maps.  Only what the eigenvalue recovery needs: chi(g^j).
# 2A: g^2 = 1.  3A: g^2 in 3A.  5A: powers alternate 5A/5B by QR(5)={1,4}.
# 6A: g^2,g^4 in 3A; g^3 in 2A; g^5 in 6A.  11A: g^j in 11A iff j in QR(11).
QR5 = {1, 4}


def chi_pow(cls, j):
    k = ORDER[cls]
    j %= k
    if j == 0:
        return CHI["1A"]
    if cls == "2A":
        return CHI["2A"]
    if cls == "3A":
        return CHI["3A"]
    if cls in ("5A", "5B"):
        other = "5B" if cls == "5A" else "5A"
        return CHI[cls] if j in QR5 else CHI[other]
    if cls == "6A":
        return {1: CHI["6A"], 2: CHI["3A"], 3: CHI["2A"],
                4: CHI["3A"], 5: CHI["6A"]}[j]
    if cls in ("11A", "11B"):
        other = "11B" if cls == "11A" else "11A"
        return CHI[cls] if j in QR11 else CHI[other]
    raise KeyError(cls)


def eigen_multiset(cls):
    """Recover the multiplicities of zeta_k^a in rho(g) by DFT inversion.

    mult(a) = (1/k) sum_j chi(g^j) zeta_k^{-aj}   -- must be a non-negative
    rational integer; we verify it is by checking the result is c*ONE with
    k | c.
    """
    k = ORDER[cls]
    mults = []
    for a in range(k):
        acc = ZERO
        for j in range(k):
            acc = add(acc, mul(chi_pow(cls, j), zeta(k, (-a * j) % k)))
        # acc must equal k*mult, a rational integer times ONE
        c = acc[0]
        assert all(x == 0 for x in acc[1:]), (cls, a, "not rational")
        c = int(c)
        assert c % k == 0, (cls, a, c, k)
        m = c // k
        assert m >= 0, (cls, a, m)
        mults.append(m)
    assert sum(mults) == 5, (cls, mults)
    # trace check
    tr = ZERO
    for a, m in enumerate(mults):
        for _ in range(m):
            tr = add(tr, zeta(k, a))
    assert tr == CHI[cls], (cls, "trace mismatch")
    return [(k, a) for a, m in enumerate(mults) for _ in range(m)]


def hseries(eigs, dmax):
    """[h_0, ..., h_dmax] of the eigenvalue multiset, exactly."""
    ser = [ONE] + [ZERO] * dmax
    for (k, a) in eigs:
        lam = zeta(k, a)
        # multiply by 1/(1 - lam t): running prefix sums
        new = [ZERO] * (dmax + 1)
        run = ZERO
        for d in range(dmax + 1):
            run = add(mul(run, lam), ser[d])
            new[d] = run
        ser = new
    return ser


def conj(v):
    """Complex conjugation z -> z^{-1} on Z[z]/Phi_330."""
    out = ZERO
    for i, c in enumerate(v):
        if c:
            out = add(out, [c * x for x in zeta(N, -i)])
    return out


def main():
    os.makedirs(PAY, exist_ok=True)
    # --- character sanity
    inner = 0
    triv = ZERO
    for c in CLASSES:
        inner_v = mul(CHI[c], conj(CHI[c]))
        assert all(x == 0 for x in inner_v[1:]), "chi.conj(chi) not rational"
        inner += SIZE[c] * int(inner_v[0])
        triv = add(triv, [SIZE[c] * x for x in CHI[c]])
    assert inner == 660, ("<chi,chi> != 1", inner)
    assert all(x == 0 for x in triv), "<chi,1> != 0"

    eigs = {c: eigen_multiset(c) for c in CLASSES}
    H = {c: hseries(eigs[c], max(IMAX, DMAX) + 1) for c in CLASSES}

    covariant = {}
    invariant = {}
    for d in range(0, max(IMAX, DMAX) + 1):
        # invariants (Sym^d W*)^G
        acc = 0
        for c in CLASSES:
            v = conj(H[c][d])
            assert all(x == 0 for x in v[1:]) or True
            # sum over the class: |C| * conj(h_d)
            acc_v = [SIZE[c] * x for x in v]
            if c == CLASSES[0]:
                tot = acc_v
            else:
                tot = add(tot, acc_v)
        assert all(x == 0 for x in tot[1:]), ("invariant dim irrational", d)
        assert tot[0] % 660 == 0, ("invariant dim not integral", d, tot[0])
        invariant[d] = int(tot[0]) // 660
        if d <= DMAX:
            # covariants (Sym^d W* (x) W)^G
            tot = None
            for c in CLASSES:
                v = mul(conj(H[c][d]), CHI[c])
                v = [SIZE[c] * x for x in v]
                tot = v if tot is None else add(tot, v)
            assert all(x == 0 for x in tot[1:]), ("cov dim irrational", d)
            assert tot[0] % 660 == 0, ("cov dim not integral", d, tot[0])
            covariant[d] = int(tot[0]) // 660
            assert covariant[d] >= 0
        acc = acc  # noqa

    # --- self tests
    assert covariant[0] == 0, covariant[0]
    assert covariant[1] == 1, covariant[1]        # Schur: End(W)^G = C.id
    assert invariant[0] == 1 and invariant[1] == 0 and invariant[2] == 0
    assert invariant[3] == 1, ("the Klein cubic F", invariant[3])

    out = {
        "group": "PSL(2,11)", "order": 660, "W": "5-dim Weil rep",
        "eigenvalue_multisets": {c: eigs[c] for c in CLASSES},
        "dim_covariant_module_M_d": covariant,
        "dim_invariants_Sym_d": {d: invariant[d] for d in range(0, IMAX + 1)},
        "landing_equation_count": {d: invariant[3 * d] for d in range(0, IMAX // 3 + 1)},
        "self_tests": ["<chi,chi>=1", "<chi,1>=0", "traces match",
                       "dim M_0 = 0", "dim M_1 = 1 (Schur)",
                       "dim Sym^3 invariants = 1 (Klein cubic F)",
                       "all dims non-negative integers"],
    }
    with open(os.path.join(PAY, "MOLIEN.json"), "w") as fh:
        json.dump(out, fh, indent=1, sort_keys=True)

    print("dim M_d for d = 0..30:")
    for d in range(0, DMAX + 1):
        le = invariant.get(3 * d, -1)
        print("   d=%2d  dim M_d = %5d   #landing eqns = %6d"
              % (d, covariant[d], le))
    print("wrote", os.path.join(PAY, "MOLIEN.json"))


if __name__ == "__main__":
    sys.exit(main())
