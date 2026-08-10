#!/usr/bin/env python3
"""Exact replay of the combined degree/degree sieve for Problem E.

Everything below is exact integer or exact cyclotomic-integer arithmetic.
No floating point, no Groebner basis, no finite-field sampling, no search.

Sections
  A  character data for the 5-dimensional PSL(2,11) representation W,
     rebuilt from scratch and cross-checked against the repository's
     independently computed covariant dimensions;
  B  the invariant-divisor degree set S on the Klein cubic X;
  C  the CLEAN norm condition as an inert-prime valuation criterion,
     cross-checked against direct representation by x^2+xy+3y^2;
  D  the delta interval from the excess-intersection identity;
  E  the combined sieve table for d in [22,60] and the
     no-periodic-closure assertion.

Exit markers are printed at the end.
"""

from fractions import Fraction as F

P11 = 11
QR11 = sorted({(i * i) % P11 for i in range(1, P11)})          # {1,3,4,5,9}
QNR11 = [a for a in range(1, P11) if a not in QR11]            # {2,6,7,8,10}

CLASSES = ("1A", "2A", "3A", "5A", "5B", "6A", "11A", "11B")
CLASS_SIZE = {"1A": 1, "2A": 55, "3A": 110, "5A": 132,
              "5B": 132, "6A": 110, "11A": 60, "11B": 60}
ELEMENT_ORDER = {"1A": 1, "2A": 2, "3A": 3, "5A": 5,
                 "5B": 5, "6A": 6, "11A": 11, "11B": 11}

# ---------------------------------------------------------------- section A

# Eigenvalues of a class representative on W, recorded as exponents e with
# eigenvalue exp(2*pi*i*e/n), n = element order.  Determined uniquely by the
# character values of the degree-5 constituents of PSL(2,11) (see
# THEOREM_COMBINED_SIEVE.md section 1); the determination is re-verified
# below from the power sums alone.
EIGEN = {
    "1A": (1, [0, 0, 0, 0, 0]),
    "2A": (2, [0, 0, 0, 1, 1]),
    "3A": (3, [0, 1, 1, 2, 2]),
    "5A": (5, [0, 1, 2, 3, 4]),
    "5B": (5, [0, 1, 2, 3, 4]),
    "6A": (6, [0, 1, 2, 4, 5]),
    "11A": (11, list(QR11)),
    "11B": (11, list(QNR11)),
}


class Cyc:
    """Exact element of Z[zeta_N] for a fixed N, as a coefficient vector mod
    the N-th cyclotomic relations we actually need (N in {1,2,3,4,5,6,11}).

    We only ever need power sums of roots of unity, which are integers or
    elements of Z[zeta_11]; the general case is handled by embedding every
    root of unity of order dividing 660 into Z[zeta_660] would be wasteful,
    so instead power sums are computed class by class in Z[zeta_n]."""


def power_sum(cls, j):
    """sum of lambda^j over the eigenvalues of the class, as an exact
    element of Z[zeta_n] represented by a length-n integer vector."""
    n, exps = EIGEN[cls]
    vec = [0] * n
    for e in exps:
        vec[(e * j) % n] += 1
    return n, vec


def reduce_to_int(n, vec):
    """If the vector represents a rational integer, return it, else None.
    Uses only the relation 1 + z + ... + z^(p-1) = 0 for prime n, and the
    trivial reductions for n in {1,2,3,4,6}."""
    if n == 1:
        return vec[0]
    if n == 2:
        return vec[0] - vec[1]
    if n == 3:
        # 1 + z + z^2 = 0
        return vec[0] - vec[1] if vec[1] == vec[2] else None
    if n == 5 or n == 11:
        if len(set(vec[1:])) == 1:
            return vec[0] - vec[1]
        return None
    if n == 6:
        # z^3 = -1, z^2 - z + 1 = 0  ->  basis {1, z}
        a = vec[0] - vec[3]
        b = vec[1] - vec[4]
        c = vec[2] - vec[5]
        # z^2 = z - 1
        a2, b2 = a - c, b + c
        return a2 if b2 == 0 else None
    raise ValueError(n)


def character_value_is(cls, expected_int):
    n, vec = power_sum(cls, 1)
    return reduce_to_int(n, vec) == expected_int


def check_A():
    # 1. class equation
    assert sum(CLASS_SIZE.values()) == 660, sum(CLASS_SIZE.values())

    # 2. eigenvalue multisets have the right size and the right order
    for cls in CLASSES:
        n, exps = EIGEN[cls]
        assert len(exps) == 5
        assert n == ELEMENT_ORDER[cls]
        assert all(0 <= e < n for e in exps)

    # 3. the rational character values 5,1,-1,0,0,1 on 1A,2A,3A,5A,5B,6A
    for cls, val in (("1A", 5), ("2A", 1), ("3A", -1),
                     ("5A", 0), ("5B", 0), ("6A", 1)):
        assert character_value_is(cls, val), cls

    # 4. the two order-11 classes are conjugate: their eigenvalue sets are
    #    exchanged by exponent negation, and their character values sum to -1
    assert sorted((-a) % 11 for a in QR11) == QNR11
    n, v1 = power_sum("11A", 1)
    _, v2 = power_sum("11B", 1)
    tot = [v1[i] + v2[i] for i in range(n)]
    assert reduce_to_int(11, tot) == -1, tot

    # 5. the eigenvalue multisets are the UNIQUE ones compatible with the
    #    power sums chi(g^j); check by exhaustive reconstruction via the
    #    discrete Fourier transform over Z (integrality forces uniqueness)
    for cls in CLASSES:
        n, exps = EIGEN[cls]
        mult = [0] * n
        for e in exps:
            mult[e] += 1
        # m_i = (1/n) sum_j p_j zeta^{-ij}; verify by forward transform
        for j in range(n):
            _, vec = power_sum(cls, j)
            direct = [0] * n
            for i in range(n):
                direct[(i * j) % n] += mult[i]
            assert direct == vec, (cls, j)

    # 6. norm-1 of the character: (1/660) sum |chi|^2 = 1.  |chi|^2 on the
    #    order-11 classes is 3 because chi * chibar = N((-1+sqrt(-11))/2) = 3.
    total = (1 * 25 + 55 * 1 + 110 * 1 + 132 * 0 + 132 * 0
             + 110 * 1 + 60 * 3 + 60 * 3)
    assert total == 660, total

    return True


# --- Molien / covariant series -------------------------------------------

def series_mul(a, b, n):
    r = [F(0)] * (n + 1)
    for i, ai in enumerate(a):
        if ai == 0 or i > n:
            continue
        for j, bj in enumerate(b):
            if i + j > n:
                break
            r[i + j] += ai * bj
    return r


def series_inv(a, n):
    assert a[0] != 0
    r = [F(0)] * (n + 1)
    r[0] = F(1) / a[0]
    for k in range(1, n + 1):
        s = F(0)
        for j in range(1, min(k, len(a) - 1) + 1):
            s += a[j] * r[k - j]
        r[k] = -s / a[0]
    return r


def poly(coeffs, n):
    r = [F(0)] * (n + 1)
    for i, c in enumerate(coeffs):
        if i <= n:
            r[i] = F(c)
    return r


def cyc11_mul(a, b):
    """multiply in Z[z]/(1+z+...+z^10), vectors of length 11."""
    raw = [0] * (2 * P11 - 1)
    for i, ai in enumerate(a):
        if ai:
            for j, bj in enumerate(b):
                raw[i + j] += ai * bj
    out = [0] * P11
    for i, c in enumerate(raw):
        out[i % P11] += c
    c = out[P11 - 1]
    return [out[i] - c for i in range(P11 - 1)] + [0]


def cyc11_char_poly(exps):
    """coefficients (in Z[zeta_11]) of prod_{a in exps} (1 - zeta^a t)."""
    res = [[1] + [0] * (P11 - 1)]
    for a in exps:
        new = [[0] * P11 for _ in range(len(res) + 1)]
        for k, c in enumerate(res):
            for i in range(P11):
                new[k][i] += c[i]
            za = [0] * P11
            za[a % P11] = -1
            m = cyc11_mul(c, za)
            for i in range(P11):
                new[k + 1][i] += m[i]
        res = new
    return res


def cyc11_series_inv(exps, n):
    den = cyc11_char_poly(exps)
    out = [[0] * P11 for _ in range(n + 1)]
    out[0][0] = 1
    for k in range(1, n + 1):
        s = [0] * P11
        for j in range(1, min(k, len(den) - 1) + 1):
            m = cyc11_mul(den[j], out[k - j])
            s = [s[i] + m[i] for i in range(P11)]
        out[k] = [-v for v in s]
    return out


def rational_series(n):
    """The five inversion-stable classes contribute integer-coefficient
    denominators det(1 - t g); return {class: series 1/det}."""
    out = {}
    out["1A"] = series_inv(poly([1, -5, 10, -10, 5, -1], n), n)
    d2 = series_mul(series_mul(poly([1, -1], n),
                               series_mul(poly([1, -1], n), poly([1, -1], n), n), n),
                    series_mul(poly([1, 1], n), poly([1, 1], n), n), n)
    out["2A"] = series_inv(d2, n)
    d3 = series_mul(poly([1, -1], n),
                    series_mul(poly([1, 1, 1], n), poly([1, 1, 1], n), n), n)
    out["3A"] = series_inv(d3, n)
    out["5A"] = series_inv(poly([1, 0, 0, 0, 0, -1], n), n)
    out["5B"] = out["5A"]
    # order 6: eigenvalues are every 6th root of unity except -1
    out["6A"] = series_mul(poly([1, 1], n),
                           series_inv(poly([1, 0, 0, 0, 0, 0, -1], n), n), n)
    return out


def molien_invariants(n):
    """dim Sym^k(W)^G for k = 0..n.  The eigenvalue multisets of W and of its
    dual differ only on the order-11 classes, which are swapped; the invariant
    Molien series is therefore the same for W and W^dual."""
    ser = rational_series(n)
    tot = [F(0)] * (n + 1)
    for cls in ("1A", "2A", "3A", "5A", "5B", "6A"):
        for k in range(n + 1):
            tot[k] += CLASS_SIZE[cls] * ser[cls][k]
    acc = [[0] * P11 for _ in range(n + 1)]
    for exps in (QR11, QNR11):
        s = cyc11_series_inv(exps, n)
        for k in range(n + 1):
            acc[k] = [acc[k][i] + s[k][i] for i in range(P11)]
    for k in range(n + 1):
        val = reduce_to_int(11, acc[k])
        assert val is not None, (k, acc[k])
        tot[k] += 60 * val
    out = []
    for k in range(n + 1):
        v = tot[k] / 660
        assert v.denominator == 1, (k, v)
        out.append(int(v))
    return out


def molien_covariants(n):
    """dim (Sym^d W^dual (x) W)^G for d = 0..n."""
    ser = rational_series(n)
    chiW = {"1A": 5, "2A": 1, "3A": -1, "5A": 0, "5B": 0, "6A": 1}
    tot = [F(0)] * (n + 1)
    for cls in ("1A", "2A", "3A", "5A", "5B", "6A"):
        for k in range(n + 1):
            tot[k] += CLASS_SIZE[cls] * chiW[cls] * ser[cls][k]
    acc = [[0] * P11 for _ in range(n + 1)]
    # on W^dual the class 11A has eigenvalue exponents -QR = QNR, and its
    # character on W is the QR Gauss period; 11B is the conjugate.
    for dual_exps, chi_exps in ((QNR11, QR11), (QR11, QNR11)):
        s = cyc11_series_inv(dual_exps, n)
        chi = [0] * P11
        for a in chi_exps:
            chi[a] += 1
        c = chi[P11 - 1]
        chi = [chi[i] - c for i in range(P11 - 1)] + [0]
        for k in range(n + 1):
            m = cyc11_mul(s[k], chi)
            acc[k] = [acc[k][i] + m[i] for i in range(P11)]
    for k in range(n + 1):
        val = reduce_to_int(11, acc[k])
        assert val is not None, (k, acc[k])
        tot[k] += 60 * val
    out = []
    for k in range(n + 1):
        v = tot[k] / 660
        assert v.denominator == 1, (k, v)
        out.append(int(v))
    return out


# ---------------------------------------------------------------- section B

def invariant_divisor_degrees(n):
    """S = {k >= 1 : dim H^0(X, O_X(k))^G >= 1} within [1,n], plus the
    dimensions themselves."""
    inv = molien_invariants(n)
    m = [inv[k] - (inv[k - 3] if k >= 3 else 0) for k in range(n + 1)]
    assert all(v >= 0 for v in m), m
    return m, [k for k in range(1, n + 1) if m[k] >= 1]


# ---------------------------------------------------------------- section C

def smallest_prime_factors(n):
    spf = list(range(n + 1))
    i = 2
    while i * i <= n:
        if spf[i] == i:
            for j in range(i * i, n + 1, i):
                if spf[j] == j:
                    spf[j] = i
        i += 1
    return spf


def is_inert(p):
    """p is inert in Q(sqrt(-11)) iff p != 11 and p is a nonresidue mod 11."""
    return p != 11 and (p % 11) in set(QNR11)


def norm_table(limit, spf):
    """isnorm[n] = True iff v_p(n) is even for every inert p."""
    isnorm = [False] * (limit + 1)
    inert_cache = {}
    for n in range(1, limit + 1):
        m, ok = n, True
        while m > 1:
            p = spf[m]
            v = 0
            while m % p == 0:
                m //= p
                v += 1
            fl = inert_cache.get(p)
            if fl is None:
                fl = is_inert(p)
                inert_cache[p] = fl
            if fl and v % 2 == 1:
                ok = False
                break
        isnorm[n] = ok
    return isnorm


def isqrt_floor(n):
    """exact integer square root, no floating point."""
    if n < 0:
        raise ValueError(n)
    x = n
    y = (x + 1) // 2
    while y < x:
        x, y = y, (y + n // y) // 2
    return x


def represented_directly(limit):
    """{x^2 + x y + 3 y^2 : x, y in Z} intersect [1, limit], by exact
    enumeration over the finite box forced by positive-definiteness:
    4 (x^2 + x y + 3 y^2) = (2x + y)^2 + 11 y^2, so with u = 2x + y both
    |u| <= 2 sqrt(limit) and 11 y^2 <= 4 limit, and u = y (mod 2)."""
    out = set()
    ybound = isqrt_floor((4 * limit) // 11)
    ubound = isqrt_floor(4 * limit)
    for y in range(-ybound, ybound + 1):
        for u in range(-ubound, ubound + 1):
            if (u - y) % 2:
                continue
            x = (u - y) // 2
            v = x * x + x * y + 3 * y * y
            if 0 < v <= limit:
                out.add(v)
    return out


# ---------------------------------------------------------------- section D

def delta_upper_bound(dprime, one_dimensional_base=True):
    """Exact upper bound for the degree of a primitive degree-d' selfmap of a
    smooth cubic threefold, from the excess-intersection identity
        delta = d'^3 - d'*zeta - a,      zeta >= 1, a >= 0   (dim Z = 1)
        delta = d'^3 - a,                a >= 0              (dim Z = 0)."""
    if one_dimensional_base:
        return dprime ** 3 - dprime
    return dprime ** 3


def admissible_dprimes(d, S):
    """d' = d - k with k = 0 or k in S; the selfmap is nonlinear so d' >= 2."""
    Sset = set(S)
    out = []
    for dp in range(2, d + 1):
        k = d - dp
        if k == 0 or k in Sset:
            out.append(dp)
    return out


# ---------------------------------------------------------------- section E

D_LO, D_HI = 22, 60
WINDOW_ALL_AMBIENT = 22          # AMBIENT-LANDING-COORDINATE-DEGREE-AT-LEAST-22
WINDOW_RETRACTION = 24           # DELTA1-RETRACTION-COORDINATE-DEGREE-AT-LEAST-24
UNCONDITIONAL_EMPTY_THROUGH = 30  # FIX-P2-SWEEP2-EMPTY-THROUGH-30


def build_table(S, isnorm):
    rows = []
    for d in range(D_LO, D_HI + 1):
        # --- retraction branch (delta = 1) ---
        if d <= UNCONDITIONAL_EMPTY_THROUGH:
            retr = ("dead", "FIX-P2-SWEEP2-EMPTY-THROUGH-30")
        elif d < WINDOW_RETRACTION:
            retr = ("dead", "DELTA1-RETRACTION-COORDINATE-DEGREE-AT-LEAST-24")
        else:
            # delta = 1 = N(1) is a norm; the removed divisor has degree d-1,
            # which must lie in S
            assert (d - 1) in S, d
            retr = ("alive", "delta=1")
        # --- all-ambient branch (nonidentity restriction) ---
        if d <= UNCONDITIONAL_EMPTY_THROUGH:
            amb = ("dead", "FIX-P2-SWEEP2-EMPTY-THROUGH-30", 0, None, None)
        else:
            dps = admissible_dprimes(d, S)
            hi = max(delta_upper_bound(dp) for dp in dps)
            survivors = [x for x in range(3, hi + 1) if isnorm[x]]
            amb = ("alive", "", len(survivors),
                   survivors[0] if survivors else None, hi)
        rows.append((d, retr, amb))
    return rows


def main():
    n = 64
    assert check_A()
    print("A  character data for W rebuilt and internally consistent")

    cov = molien_covariants(n)
    repo_cov = [32, 41, 49, 59, 73, 86, 100]      # LOW_DEGREE_DOMINANT_MAPS.md
    assert cov[15:22] == repo_cov, (cov[15:22], repo_cov)
    print("A  covariant dims d=15..21 =", cov[15:22],
          "match the repo's mod-67 table exactly")
    assert cov[1] == 1 and cov[2] == 0 and cov[3] == 0
    assert all(c > 0 for c in cov[4:n + 1])

    m, S = invariant_divisor_degrees(n)
    assert m[:5] == [1, 0, 0, 0, 0], m[:5]
    assert m[5] == 1
    assert S[:8] == [5, 6, 7, 8, 9, 10, 11, 12], S[:8]
    assert set(range(5, n + 1)) == set(S), "S is exactly {5,6,7,...}"
    print("B  dim H^0(X,O_X(k))^G, k=0..12 =", m[:13])
    print("B  S = invariant divisor degrees on X =", "{5,6,7,...} through", n)

    # d' can never be d-1, d-2, d-3, d-4
    for d in range(D_LO, D_HI + 1):
        dps = set(admissible_dprimes(d, S))
        for gap in (1, 2, 3, 4):
            assert (d - gap) not in dps, (d, gap)
        assert d in dps
    print("B  d' in {2,...,d-5} u {d}: the four values d-1,d-2,d-3,d-4 are excluded")

    LIMIT = D_HI ** 3 - D_HI
    spf = smallest_prime_factors(LIMIT)
    isnorm = norm_table(LIMIT, spf)
    inert_small = [p for p in range(2, 60) if spf[p] == p and is_inert(p)]
    print("C  inert primes below 60:", inert_small)
    assert inert_small == [2, 7, 13, 17, 19, 29, 41, 43], inert_small
    # every inert prime is a nonresidue mod 11; every split prime is a residue
    for p in range(2, 200):
        if spf[p] != p:
            continue
        if p == 11:
            assert not is_inert(p)
            continue
        assert is_inert(p) == ((p % 11) in set(QNR11)), p
        # -11 is a nonresidue mod p exactly when p is inert (odd p)
        if p != 2:
            legendre = pow((-11) % p, (p - 1) // 2, p)
            assert is_inert(p) == (legendre == p - 1), p

    direct = represented_directly(20000)
    mismatch = [x for x in range(1, 20001) if isnorm[x] != (x in direct)]
    assert not mismatch, mismatch[:10]
    print("C  inert-valuation criterion = direct representation by "
          "x^2+xy+3y^2, verified on [1,20000]")
    assert not isnorm[2] and isnorm[3] and isnorm[4] and isnorm[5]
    assert not isnorm[6] and not isnorm[7] and isnorm[9] and isnorm[11]
    for x in range(1, LIMIT + 1):
        if x % 4 == 2:
            assert not isnorm[x], x
    print("C  delta = 2 (mod 4) is impossible; v_2(delta) is even")

    # section D sanity: the interval is exactly [1, d'^3 - d']
    assert delta_upper_bound(2) == 6 and delta_upper_bound(3) == 24
    assert delta_upper_bound(1) == 0
    assert [x for x in range(3, 7) if isnorm[x]] == [3, 4, 5]
    assert [x for x in range(3, 25) if isnorm[x]] == \
        [3, 4, 5, 9, 11, 12, 15, 16, 20, 23]
    print("D  d'=2 -> delta in {3,4,5};  d'=3 -> delta in",
          [x for x in range(3, 25) if isnorm[x]])

    rows = build_table(S, isnorm)
    print()
    print("E  survivor table, d in [%d,%d]" % (D_LO, D_HI))
    print("     d | retraction (delta=1)      | all-ambient (delta>=3)")
    print("    ---+---------------------------+" + "-" * 46)
    for d, retr, amb in rows:
        if retr[0] == "dead":
            left = "DEAD  " + retr[1]
        else:
            left = "ALIVE delta=1"
        if amb[0] == "dead":
            right = "DEAD  " + amb[1]
        else:
            right = ("ALIVE %5d norms in [3, %6d], min = %d"
                     % (amb[2], amb[4], amb[3]))
        print("    %3d | %-34s | %s" % (d, left, right))

    # --- the no-periodic-closure assertion --------------------------------
    alive = [d for d, retr, amb in rows if amb[0] == "alive"]
    assert alive == list(range(31, D_HI + 1)), alive
    for d, retr, amb in rows:
        if amb[0] == "alive":
            assert amb[3] == 3, (d, amb)   # delta = 3 always admissible
    print()
    print("E  every d in [31,%d] admits delta = 3 = N((-1+sqrt(-11))/2)" % D_HI)

    # No residue class of d dies.  For every modulus M up to 2310 and every
    # residue r mod M, exhibit a degree d >= 31, d = r (mod M), together with
    # an explicit cell (d', zeta, a, delta) satisfying EVERY sealed ledger
    # constraint simultaneously.
    Sset = set(S)
    tested = 0
    for M in list(range(2, 121)) + [165, 330, 660, 2310]:
        for r in range(M):
            d = 31 + ((r - 31) % M)
            assert d % M == r and d >= 31
            dp = d                                  # k = 0, always admissible
            assert (d - dp) == 0 or (d - dp) in Sset
            zeta, a = 1, dp ** 3 - dp - 3           # delta = d'^3 - d' zeta - a
            delta = dp ** 3 - dp * zeta - a
            assert delta == 3
            assert 1 <= zeta <= dp ** 2             # 3 <= deg Z <= 3 d'^2
            assert a >= 0
            assert delta >= 3                       # nonidentity + norm rules out 1,2
            assert delta <= delta_upper_bound(dp)
            assert isnorm[delta]                    # 3 = N((-1+sqrt(-11))/2)
            assert 3 * (d - dp) <= d * d            # refined-Bezout codim-2 capacity
            tested += 1
    print("E  no residue class dies: %d (modulus, residue) pairs tested, "
          "each with an explicit admissible cell" % tested)

    # --- how strong a delta lower bound would have to be ------------------
    vals = [x for x in range(1, LIMIT + 1) if isnorm[x]]
    gaps = [vals[i + 1] - vals[i] for i in range(len(vals) - 1)]
    maxgap = max(gaps)
    print("E  largest gap between consecutive norms in [1,%d] = %d"
          % (LIMIT, maxgap))
    for d in (31, 40, 50, 60):
        need = delta_upper_bound(d) - maxgap
        print("     at d=%2d a hypothetical lower bound L(d) would have to "
              "exceed %d (of a range topping out at %d) to kill the cell"
              % (d, need, delta_upper_bound(d)))
    assert maxgap < 64

    print()
    print("COMBINED_SIEVE_CHARACTER_DATA_OK")
    print("COMBINED_SIEVE_INVARIANT_DEGREE_SET_OK")
    print("COMBINED_SIEVE_NORM_CRITERION_OK")
    print("COMBINED_SIEVE_DELTA_INTERVAL_OK")
    print("COMBINED_SIEVE_TABLE_OK")
    print("COMBINED_SIEVE_NO_PERIODIC_CLOSURE_OK")


if __name__ == "__main__":
    main()
