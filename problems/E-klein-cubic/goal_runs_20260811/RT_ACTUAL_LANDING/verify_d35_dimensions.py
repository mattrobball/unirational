#!/usr/bin/env python3
"""
Exact Molien / character arithmetic for the d = 35 branch table.

Everything here is exact: Python integers and `fractions.Fraction` only.  No
floating point is used anywhere, and no cyclotomic-field library is needed,
because the five-dimensional character of `G = PSL(2,11)` on `W` lets every
class contribution be written as a rational (or `Z[sqrt(-11)]`) linear
recurrence.

WHAT IS COMPUTED
----------------
    I(k) = dim (Sym^k W^v)^G                    (ambient invariants)
    C(k) = dim (Sym^k W^v (x) W)^G              (ambient covariant 5-tuples)
    S(n) = dim H^0(X, O_X(n))^G = I(n) - I(n-3) (invariants on the Klein cubic)

The last identity is Lemma 2.3 of
`goal_runs_20260810/COMBINED_DEGREE_SIEVE/THEOREM_COMBINED_SIEVE.md`
(multiplication by `F` is an injective `G`-map `Sym^{n-3} -> Sym^n`, and taking
`G`-invariants is exact in characteristic zero).

CLASS DATA (as supplied by the repository, not looked up elsewhere)
------------------------------------------------------------------
|G| = 660, eight classes with sizes 1A:1, 2A:55, 3A:110, 5A:132, 5B:132,
6A:110, 11A:60, 11B:60, and eigenvalues of a representative on `W^v`:

    1A  (1,1,1,1,1)                     char poly (1-t)^5
    2A  (1,1,1,-1,-1)                   char poly (1-t)^3 (1+t)^2
    3A  (1,w,w,w^2,w^2)                 char poly (1-t)(1+t+t^2)^2
    5A  all five 5th roots once         char poly 1-t^5
    5B  all five 5th roots once         char poly 1-t^5
    6A  all six 6th roots except -1     char poly (1-t^6)/(1+t)
    11A z^a, a in QR = {1,3,4,5,9}      char poly 1 - a1 t - t^2 + t^3 + a2 t^4 - t^5
    11B z^b, b in NQR                   char poly 1 - a2 t - t^2 + t^3 + a1 t^4 - t^5

with  a1 = (-1+sqrt(-11))/2,  a2 = (-1-sqrt(-11))/2  the two Gauss periods.

The 2A/3A/5A/6A eigenvalue multisets are *forced* by the character values
chi_W = (5, 1, -1, 0, 0, 1, a1, a2) together with the element orders; the
script re-derives that forcing (block A) rather than assuming it.  The
elementary symmetric functions of the QR set are re-derived too (block A'):
e1 = a1, e2 = -1, e3 = -1, e4 = a2, e5 = 1.

The generating function of `h_k` (the complete homogeneous symmetric function of
the eigenvalues, i.e. the character of `Sym^k`) is `1/charpoly(t)`, so each
class contributes a linear recurrence with the char-poly coefficients.

TERMINAL MARKER: prints `RESULT: PASS` iff every assertion holds.
"""

import sys
from fractions import Fraction

FAILURES = []
CHECKS = 0


def check(name, got, want):
    global CHECKS
    CHECKS += 1
    if got != want:
        FAILURES.append(f"{name}: got {got!r}, want {want!r}")
        print(f"  FAIL {name}: got {got!r}, want {want!r}")
    return got == want


# ----------------------------------------------------------------------
# Exact arithmetic in Z[(1+sqrt(-11))/2]:  represent (p + q*sqrt(-11))/2
# with p, q integers of equal parity.  Stored as the pair (p, q).
# ----------------------------------------------------------------------
class Q11:
    __slots__ = ("p", "q")

    def __init__(self, p, q=0):
        self.p, self.q = p, q          # value = (p + q sqrt(-11))/2

    @staticmethod
    def rat(n):                        # rational integer n
        return Q11(2 * n, 0)

    def __add__(self, o):
        return Q11(self.p + o.p, self.q + o.q)

    def __sub__(self, o):
        return Q11(self.p - o.p, self.q - o.q)

    def __mul__(self, o):
        # (p+q s)(P+Q s)/4 with s^2 = -11  ->  (pP - 11qQ + (pQ+qP) s)/4
        num_p = self.p * o.p - 11 * self.q * o.q
        num_q = self.p * o.q + self.q * o.p
        assert num_p % 2 == 0 and num_q % 2 == 0
        return Q11(num_p // 2, num_q // 2)

    def __neg__(self):
        return Q11(-self.p, -self.q)

    def conj(self):
        return Q11(self.p, -self.q)

    def is_rational(self):
        return self.q == 0

    def to_int(self):
        assert self.q == 0 and self.p % 2 == 0, f"not a rational integer: {self}"
        return self.p // 2

    def __eq__(self, o):
        return self.p == o.p and self.q == o.q

    def __repr__(self):
        return f"({self.p}+{self.q}sqrt(-11))/2"


A1 = Q11(-1, 1)     # (-1 + sqrt(-11))/2
A2 = Q11(-1, -1)    # (-1 - sqrt(-11))/2
ONE = Q11.rat(1)
ZERO = Q11.rat(0)

print("=" * 72)
print("verify_d35_dimensions.py -- exact character arithmetic for G = PSL(2,11)")
print("=" * 72)

# ----------------------------------------------------------------------
# (A) The eigenvalue multisets are forced by the character values.
# ----------------------------------------------------------------------
print("\n(A) eigenvalue multisets forced by chi_W and element orders")


def forced_multiset(order, chi_powers):
    """Multiplicities m_j of zeta_order^j on a 5-dim rep, from chi(g^l).

    m_j = (1/order) sum_l chi(g^l) zeta^{-jl}; computed exactly by expanding in
    the integral basis of Q(zeta_order) is unnecessary here because we only use
    orders 2,3,6 whose cyclotomic sums are rational.  We do it by brute force
    over integer multiplicity vectors instead: enumerate all m with sum 5 and
    check every power trace.  That is an exact, assumption-free derivation.
    """
    import itertools

    sols = []
    for m in itertools.product(range(6), repeat=order):
        if sum(m) != 5:
            continue
        ok = True
        for l in range(order):
            # trace of g^l = sum_j m_j zeta^{jl}; compare with chi_powers[l]
            # evaluate the cyclotomic sum exactly by grouping exponents mod order
            coeff = [0] * order
            for j in range(order):
                coeff[(j * l) % order] += m[j]
            # reduce sum_e coeff[e] zeta^e using 1+zeta+...+zeta^{order-1}=0
            # only valid when order is prime; for 4,6 use the minimal poly.
            val = cyclotomic_sum_value(coeff, order)
            if val != chi_powers[l]:
                ok = False
                break
        if ok:
            sols.append(m)
    return sols


def cyclotomic_sum_value(coeff, order):
    """Exact value of sum_e coeff[e] * zeta_order^e when that value is rational;
    returns None if it is not rational."""
    # Write in terms of a Z-basis of Z[zeta_order].
    # order = 2: basis {1}, zeta = -1
    # order = 3: basis {1, w}, w^2 = -1-w
    # order = 5: basis {1,z,z^2,z^3}, z^4 = -1-z-z^2-z^3
    # order = 6: basis {1, u}, u = zeta_6, u^2 = u-1, u^3=-1, u^4=-u, u^5=1-u
    if order == 2:
        return coeff[0] - coeff[1]
    if order == 3:
        a = coeff[0] - coeff[2]
        b = coeff[1] - coeff[2]
        return a if b == 0 else None
    if order == 5:
        a = [coeff[i] - coeff[4] for i in range(4)]
        return a[0] if a[1] == a[2] == a[3] == 0 else None
    if order == 6:
        # 1, u, u^2=u-1, u^3=-1, u^4=-u, u^5=1-u
        c = [(1, 0), (0, 1), (-1, 1), (-1, 0), (0, -1), (1, -1)]
        a = sum(coeff[e] * c[e][0] for e in range(6))
        b = sum(coeff[e] * c[e][1] for e in range(6))
        return a if b == 0 else None
    raise ValueError(order)


# chi_W on powers: chi(1A)=5, chi(2A)=1, chi(3A)=-1, chi(5A)=chi(5B)=0, chi(6A)=1
sol2 = forced_multiset(2, [5, 1])
check("2A multiset unique", len(sol2), 1)
check("2A multiset = (1,1,1,-1,-1)", sol2[0], (3, 2))
sol3 = forced_multiset(3, [5, -1, -1])
check("3A multiset unique", len(sol3), 1)
check("3A multiset = (1,w,w,w2,w2)", sol3[0], (1, 2, 2))
sol5 = forced_multiset(5, [5, 0, 0, 0, 0])
check("5A multiset unique", len(sol5), 1)
check("5A multiset = all fifth roots once", sol5[0], (1, 1, 1, 1, 1))
sol6 = forced_multiset(6, [5, 1, -1, 1, -1, 1])
check("6A multiset unique", len(sol6), 1)
check("6A multiset = all sixth roots but -1", sol6[0], (1, 1, 1, 0, 1, 1))
print(f"  2A {sol2[0]}   3A {sol3[0]}   5A {sol5[0]}   6A {sol6[0]}")

# ----------------------------------------------------------------------
# (A') Elementary symmetric functions of the quadratic residues mod 11.
# ----------------------------------------------------------------------
print("\n(A') elementary symmetric functions of {z^a : a in QR}, QR mod 11")
QR = [1, 3, 4, 5, 9]
NQR = [2, 6, 7, 8, 10]
check("QR is the set of squares mod 11", sorted(QR),
      sorted({(i * i) % 11 for i in range(1, 11)}))
check("QR and NQR partition (Z/11)^*", sorted(QR + NQR), list(range(1, 11)))


def esym_exponents(expset):
    """e_i of {z^a : a in expset} as a dict {exponent mod 11 : multiplicity},
    exact, then reduced with 1+z+...+z^10 = 0 to the basis {1,z,...,z^9}."""
    import itertools

    out = []
    for i in range(1, 6):
        d = {}
        for comb in itertools.combinations(expset, i):
            e = sum(comb) % 11
            d[e] = d.get(e, 0) + 1
        out.append(d)
    return out


def reduce_mod_phi11(d):
    """Reduce sum_e d[e] z^e using z^10 = -(1+z+...+z^9); return length-10 list.
    Then test whether the result is (i) rational, or (ii) equal to a1 or a2."""
    v = [d.get(e, 0) for e in range(11)]
    top = v[10]
    v = [v[e] - top for e in range(10)]
    return v


A1_RED = [(1 if e in QR else 0) - (1 if 10 in QR else 0) for e in range(10)]
A2_RED = [(1 if e in NQR else 0) - (1 if 10 in NQR else 0) for e in range(10)]


def identify(v):
    """Identify a reduced vector (basis 1,z,...,z^9) as a rational integer,
    as a1 = sum_{QR} z^a, or as a2 = sum_{NQR} z^b."""
    if all(c == 0 for c in v[1:]):
        return ("rat", v[0])
    if v == A1_RED:
        return ("a1", None)
    if v == A2_RED:
        return ("a2", None)
    return None


ess = esym_exponents(QR)
red = [reduce_mod_phi11(d) for d in ess]
ids = [identify(v) for v in red]
check("e1(QR) = a1", ids[0], ("a1", None))
check("e2(QR) = -1", ids[1], ("rat", -1))
check("e3(QR) = -1", ids[2], ("rat", -1))
check("e4(QR) = a2", ids[3], ("a2", None))
check("e5(QR) = 1", ids[4], ("rat", 1))
print(f"  e1..e5 = {[i[0] if i[1] is None else i[1] for i in ids]}")

# ----------------------------------------------------------------------
# (B) h_k per class by linear recurrence from 1/charpoly(t).
# ----------------------------------------------------------------------
KMAX = 90


def hseq_int(den):
    """h_k coefficients of 1/den(t), den a list of integer coefficients with
    den[0] = 1.  Exact integer recurrence."""
    h = [0] * (KMAX + 1)
    h[0] = 1
    for k in range(1, KMAX + 1):
        s = 0
        for i in range(1, min(k, len(den) - 1) + 1):
            s -= den[i] * h[k - i]
        h[k] = s
    return h


def polymul(a, b):
    out = [0] * (len(a) + len(b) - 1)
    for i, x in enumerate(a):
        for j, y in enumerate(b):
            out[i + j] += x * y
    return out


den_1A = [1]
for _ in range(5):
    den_1A = polymul(den_1A, [1, -1])
den_2A = [1]
for _ in range(3):
    den_2A = polymul(den_2A, [1, -1])
for _ in range(2):
    den_2A = polymul(den_2A, [1, 1])
den_3A = polymul([1, -1], polymul([1, 1, 1], [1, 1, 1]))
den_5A = [1, 0, 0, 0, 0, -1]
# 6A: charpoly = (1-t^6)/(1+t); 1/charpoly = (1+t)/(1-t^6)
h_6A = [0] * (KMAX + 1)
for k in range(KMAX + 1):
    h_6A[k] = (1 if k % 6 == 0 else 0) + (1 if k % 6 == 1 else 0)

h_1A = hseq_int(den_1A)
h_2A = hseq_int(den_2A)
h_3A = hseq_int(den_3A)
h_5A = hseq_int(den_5A)

check("h_k(1A) = binom(k+4,4) at k=7", h_1A[7], 330)
check("h_k(6A) is 1,1,0,0,0,0 periodic", [h_6A[i] for i in range(8)],
      [1, 1, 0, 0, 0, 0, 1, 1])

# 11A: den = 1 - a1 t - t^2 + t^3 + a2 t^4 - t^5   (11B: swap a1,a2)
den_11A = [ONE, -A1, -ONE, ONE, A2, -ONE]
den_11B = [ONE, -A2, -ONE, ONE, A1, -ONE]

# cross-check f*g = 1+t+...+t^10
prod = [ZERO] * 11
for i, x in enumerate(den_11A):
    for j, y in enumerate(den_11B):
        prod[i + j] = prod[i + j] + x * y
check("charpoly(11A)*charpoly(11B) = 1+t+...+t^10",
      [c.to_int() for c in prod], [1] * 11)


def hseq_q11(den):
    h = [ZERO] * (KMAX + 1)
    h[0] = ONE
    for k in range(1, KMAX + 1):
        s = ZERO
        for i in range(1, min(k, len(den) - 1) + 1):
            s = s - den[i] * h[k - i]
        h[k] = s
    return h


h_11A = hseq_q11(den_11A)
h_11B = hseq_q11(den_11B)
for k in range(0, 20):
    assert h_11B[k] == h_11A[k].conj(), k

# ----------------------------------------------------------------------
# (C) I(k) and C(k).
# ----------------------------------------------------------------------
SIZES = {"1A": 1, "2A": 55, "3A": 110, "5A": 132, "5B": 132, "6A": 110,
         "11A": 60, "11B": 60}
ORDER = 660
# chi_W = conj(chi_{W^v}); on W^v the 11A eigenvalues are the QR powers, so
# chi_{W^v}(11A) = a1 and chi_W(11A) = a2.
CHI_W_RAT = {"1A": 5, "2A": 1, "3A": -1, "5A": 0, "5B": 0, "6A": 1}


def I(k):
    tot = Fraction(
        SIZES["1A"] * h_1A[k] + SIZES["2A"] * h_2A[k] + SIZES["3A"] * h_3A[k]
        + SIZES["5A"] * h_5A[k] + SIZES["5B"] * h_5A[k] + SIZES["6A"] * h_6A[k])
    # 60*(h_11A + h_11B) = 60 * p   where h_11A = (p + q sqrt(-11))/2
    tot += Fraction(60 * h_11A[k].p)
    val = tot / ORDER
    assert val.denominator == 1, (k, val)
    return int(val)


def C(k):
    tot = Fraction(
        SIZES["1A"] * CHI_W_RAT["1A"] * h_1A[k]
        + SIZES["2A"] * CHI_W_RAT["2A"] * h_2A[k]
        + SIZES["3A"] * CHI_W_RAT["3A"] * h_3A[k]
        + SIZES["5A"] * CHI_W_RAT["5A"] * h_5A[k]
        + SIZES["5B"] * CHI_W_RAT["5B"] * h_5A[k]
        + SIZES["6A"] * CHI_W_RAT["6A"] * h_6A[k])
    # 60 * ( chi_W(11A) h_11A + chi_W(11B) h_11B ) = 60 * ( a2*h_11A + a1*h_11B )
    z = A2 * h_11A[k] + A1 * h_11B[k]
    assert z.is_rational(), (k, z)
    tot += Fraction(60 * z.to_int())
    val = tot / ORDER
    assert val.denominator == 1, (k, val)
    return int(val)


def S(n):
    """dim H^0(X, O_X(n))^G = I(n) - I(n-3)."""
    return I(n) - (I(n - 3) if n >= 3 else 0)


print("\n(C) cross-check against the packet's published tables")
# FOLIATION_REFORMULATION.md section 2 table, k = 0..24
PUB_I = [1, 0, 0, 1, 0, 1, 2, 1, 2, 3, 3, 4, 6, 5, 8, 10, 10, 13, 17, 17, 22,
         26, 28, 33, 40]
PUB_C = [0, 1, 0, 0, 2, 1, 2, 4, 5, 6, 10, 12, 16, 21, 26, 32, 41, 49, 59, 73,
         86, 100, 121, 140, 161]
ok = True
for k in range(25):
    ok &= check(f"I({k})", I(k), PUB_I[k])
    ok &= check(f"C({k})", C(k), PUB_C[k])
print(f"  I(k), C(k) for k = 0..24 reproduce FOLIATION_REFORMULATION.md: {ok}")

# COMBINED_DEGREE_SIEVE Lemma 2.3 table for S(n) = dim H^0(X,O_X(n))^G
PUB_S = [1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 2, 3]
ok = True
for n in range(13):
    ok &= check(f"S({n})", S(n), PUB_S[n])
print(f"  S(n) for n = 0..12 reproduces the sealed sieve table:            {ok}")
check("sieve: k in {0} u {5,6,...} for k <= 80",
      [k for k in range(81) if S(k) > 0], [0] + list(range(5, 81)))

# ----------------------------------------------------------------------
# (D) The restricted-degree exclusion input:  S(2d'-2).
# ----------------------------------------------------------------------
print("\n(D) EXCLUSION_DPRIME_2_3 input: dim H^0(X,O_X(2d'-2))^G")
print("     d'  | 2d'-2 | dim")
print("    -----+-------+-----")
zero_dprimes = []
for dp in range(1, 41):
    v = S(2 * dp - 2)
    if dp <= 8:
        print(f"    {dp:4d} | {2*dp-2:5d} | {v:3d}")
    if v == 0:
        zero_dprimes.append(dp)
check("the only d' >= 1 with H^0(X,O_X(2d'-2))^G = 0 are 2 and 3 (d' <= 40)",
      zero_dprimes, [2, 3])
check("d'=2 target space is zero", S(2), 0)
check("d'=3 target space is zero", S(4), 0)
check("d'=1 target space is C (the constants)", S(0), 1)
check("d'=4 target space is one-dimensional", S(6), 1)
check("d'=5 target space is one-dimensional", S(8), 1)
# structural: multiplication by a degree-5 invariant is injective on X, so
# S(n) > 0 for all n >= 5 once S(5..9) > 0.
check("S(5..9) all positive (base of the induction)",
      [S(n) for n in range(5, 10)], [1, 1, 1, 1, 1])

# ----------------------------------------------------------------------
# (E) The d = 35 branch table.
# ----------------------------------------------------------------------
print("\n(E) d = 35 branch table")
d = 35
check("dim H^0(X,O_X(68))^G = 254", S(68), 254)
print(f"    dim H^0(X,O_X(2d-2))^G = dim H^0(X,O_X(68))^G = {S(68)}")

print("\n    k   d'   dim H^0(X,O(68-2k))^G   dim H^0(X,O(2d'-2))^G   status")
rows = []
for k in [0] + list(range(5, 36)):
    dp = d - k
    if dp < 1:
        continue
    a = S(68 - 2 * k)         # space Delta_T/H^2 lives in
    b = S(2 * dp - 2)         # space j_phi lives in
    status = "EXCLUDED" if b == 0 else ("retraction" if dp == 1 else "open")
    rows.append((k, dp, a, b, status))
for (k, dp, a, b, st) in rows:
    if k <= 9 or dp <= 5 or k == 0:
        print(f"   {k:3d}  {dp:3d}   {a:12d}   {b:19d}   {st}")

# the (42) table
tab42 = {k: S(68 - 2 * k) for k in range(5, 10)}
check("(42) k=5..9 table 160,145,131,117,105",
      [tab42[k] for k in range(5, 10)], [160, 145, 131, 117, 105])
check("(43) k=30, d'=5: dim H^0(X,O_X(8))^G = 1", S(8), 1)
check("(43) k=31, d'=4: dim H^0(X,O_X(6))^G = 1", S(6), 1)
check("k=32 (d'=3) excluded", S(2 * (35 - 32) - 2), 0)
check("k=33 (d'=2) excluded", S(2 * (35 - 33) - 2), 0)

# one-dimensional actionable cells: those with dim H^0(X,O(2d'-2))^G = 1
onedim = [(k, d - k) for k in ([0] + list(range(5, 35)))
          if S(2 * (d - k) - 2) == 1 and d - k >= 2]
print(f"\n    one-dimensional j_phi cells at d=35 (k, d'): {onedim}")
check("one-dimensional j_phi cells at d = 35 are exactly k=30,31",
      onedim, [(30, 5), (31, 4)])

# ----------------------------------------------------------------------
# (F) The divergence-free covariant count at d = 35 (source (50)).
# ----------------------------------------------------------------------
print("\n(F) divergence-free covariants at d = 35 (m = 2d-4 = 66)")
m = 66
check("C(66) = 6992", C(66), 6992)
check("I(65) = 1357", I(65), 1357)
check("dim ker(div)^G = C(66) - I(65) = 5635", C(66) - I(65), 5635)
print(f"    C(66) = {C(66)}, I(65) = {I(65)}, ker(div)^G = {C(66)-I(65)}")

# ----------------------------------------------------------------------
# (G) The Chern-class numerology of sections 3 and 8.
# ----------------------------------------------------------------------
print("\n(G) Chern numerology")
from math import comb


def c4_T_twist(a):
    """int_{P^4} c_4(T_{P^4}(a)) = sum_{i=0}^{4} binom(5,i) a^{4-i}."""
    return sum(comb(5, i) * a ** (4 - i) for i in range(5))


for mm in range(0, 80):
    check(f"c_4(T(m-1)) = m^4+m^3+m^2+m+1 at m={mm}", c4_T_twist(mm - 1),
          mm ** 4 + mm ** 3 + mm ** 2 + mm + 1) if mm < 3 else None
    assert c4_T_twist(mm - 1) == mm ** 4 + mm ** 3 + mm ** 2 + mm + 1
check("(31) m = 66 singular-scheme length", c4_T_twist(65), 19266655)
check("(31) equals 66^4+66^3+66^2+66+1", 66 ** 4 + 66 ** 3 + 66 ** 2 + 66 + 1,
      19266655)
check("c_4 never vanishes for m >= 0", min(c4_T_twist(mm - 1)
                                           for mm in range(0, 200)), 1)

# ch_2 balance of section 8: coefficient of H^2 is -10(d-1)
# ch_2(T^*T_X) - ch_2(T_{P^4}) + ch_2(O(5-2d))
#   = -2 d^2 - 5/2 + (5-2d)^2/2 = 10 - 10 d.
for dd in range(1, 60):
    lhs = Fraction(-2 * dd ** 2) - Fraction(5, 2) + Fraction((5 - 2 * dd) ** 2, 2)
    assert lhs == 10 - 10 * dd, dd
check("(48) codim-2 coefficient is -10(d-1) for all d", True, True)
check("(49) threshold at d = 35 is 340", 10 * (35 - 1), 340)
# ch_1 cancels: 2d - 5 + (5-2d) = 0
for dd in range(1, 60):
    assert 2 * dd - 5 + (5 - 2 * dd) == 0
check("(45) ch_1 cancellation holds identically", True, True)

# ----------------------------------------------------------------------
# (H) Section 10 arithmetic: 2 is inert in Q(sqrt(-11)).
# ----------------------------------------------------------------------
print("\n(H) generic-fibre arithmetic")
check("-11 = 5 mod 8, so 2 is inert in Q(sqrt(-11))", (-11) % 8, 5)
# every even value of x^2+xy+3y^2 is divisible by 4
norms = set()
for x in range(-60, 61):
    for y in range(-60, 61):
        n = x * x + x * y + 3 * y * y
        if 0 < n <= 400:
            norms.add(n)
bad = [n for n in sorted(norms) if n % 2 == 0 and n % 4 != 0]
check("no even norm is 2 mod 4 (checked to 400)", bad, [])
check("3 is a norm", 3 in norms, True)
check("2 is not a norm", 2 in norms, False)

# ----------------------------------------------------------------------
print("\n" + "=" * 72)
print(f"checks run: {CHECKS}, failures: {len(FAILURES)}")
for f in FAILURES:
    print("  " + f)
print("RESULT: " + ("PASS" if not FAILURES else "FAIL"))
sys.exit(0 if not FAILURES else 1)
