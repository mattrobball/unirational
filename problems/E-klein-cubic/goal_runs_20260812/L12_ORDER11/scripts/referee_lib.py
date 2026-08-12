"""Referee library — INDEPENDENT implementation for auditing L12_ORDER11.

Written by the hostile referee, 2026-08-12.  Deliberately does NOT import any
packet module.  Differences from the packet implementation:
  * field elements live in the cyclic representation Z[z]/(z^11 - 1),
    canonicalised by zeroing the z^10 coefficient via the all-ones relation
    (Phi_11(z) = 0  <=>  1 + z + ... + z^10 = 0);
  * multiplication is cyclic convolution (no polynomial tail reduction);
  * sigma_m is a pure index permutation in the cyclic representation;
  * characters chi_{Sym^k W^(*)}(g) are computed by an integer DP over
    composition weights (no composition enumeration);
  * the Atiyah-Bott component term is re-derived from the blowup geometry
    (see ab_comp docstring) and implemented with its own series code;
  * both sign conventions are first-class: conv=+1 is the adopted (A)
    convention  1/prod(1 - z^{-w}),  conv=-1 is (B)  1/prod(1 - z^{+w}).

python3 stdlib only, Fractions only, no floats.
"""
from fractions import Fraction as Fr

N = 11

# ---------------------------------------------------------------------------
# Q(zeta_11) in the cyclic representation: a tuple of 10 Fractions
# (c_0, ..., c_9) meaning  sum c_i z^i,  with z^10 = -(1 + z + ... + z^9).
# Canonical: we always store the representative with zero z^10 coefficient.
# ---------------------------------------------------------------------------
ZERO = (Fr(0),) * 10
ONE = (Fr(1),) + (Fr(0),) * 9


def canon11(v11):
    """Canonicalise an 11-vector (coeffs of z^0..z^10 in Z[z]/(z^11-1)) to the
    10-tuple representative with zero z^10 coefficient: subtract c_10 * (all
    ones), which is legal because 1 + z + ... + z^10 == 0 in Q(zeta_11)."""
    t = v11[10]
    return tuple(v11[i] - t for i in range(10))


def zpow(e):
    e %= N
    v = [Fr(0)] * 11
    v[e] = Fr(1)
    return canon11(v)


def add(a, b):
    return tuple(x + y for x, y in zip(a, b))


def sub(a, b):
    return tuple(x - y for x, y in zip(a, b))


def neg(a):
    return tuple(-x for x in a)


def smul(r, a):
    r = Fr(r)
    return tuple(r * x for x in a)


def mul(a, b):
    v = [Fr(0)] * 11
    for i, x in enumerate(a):
        if x:
            for j, y in enumerate(b):
                if y:
                    v[(i + j) % 11] += x * y
    return canon11(v)


def is_zero(a):
    return all(x == 0 for x in a)


def eq(a, b):
    return a == b


def from_int(n):
    return (Fr(n),) + (Fr(0),) * 9


def total(items):
    r = ZERO
    for x in items:
        r = add(r, x)
    return r


def prod(items):
    r = ONE
    for x in items:
        r = mul(r, x)
    return r


_INV = {}


def inv(a):
    if a in _INV:
        return _INV[a]
    if is_zero(a):
        raise ZeroDivisionError
    # solve  a * x = 1  in the 10-dim canonical basis
    cols = []
    for j in range(10):
        e = [Fr(0)] * 10
        e[j] = Fr(1)
        cols.append(mul(a, tuple(e)))
    M = [[cols[j][i] for j in range(10)] + ([Fr(1)] if i == 0 else [Fr(0)])
         for i in range(10)]
    x = gauss_solve(M)
    r = tuple(x)
    _INV[a] = r
    return r


def gauss_solve(Aug):
    """Gaussian elimination on an augmented n x (n+1) matrix of Fractions."""
    n = len(Aug)
    A = [row[:] for row in Aug]
    for c in range(n):
        p = next(r for r in range(c, n) if A[r][c] != 0)
        A[c], A[p] = A[p], A[c]
        pc = A[c][c]
        A[c] = [v / pc for v in A[c]]
        for r in range(n):
            if r != c and A[r][c] != 0:
                f = A[r][c]
                A[r] = [v - f * w for v, w in zip(A[r], A[c])]
    return [A[i][n] for i in range(n)]


def div(a, b):
    return mul(a, inv(b))


def sigma(a, m):
    """Galois z -> z^m; in the cyclic representation this is an index map."""
    assert m % N != 0
    v = [Fr(0)] * 11
    for i, x in enumerate(a):
        v[(i * m) % 11] += x
    return canon11(v)


def one_minus_zpow(e):
    assert e % N != 0
    return sub(ONE, zpow(e))


PI = one_minus_zpow(1)


def is_alg_int(a):
    # canonical rep has integer coords iff the element is in Z[zeta]
    return all(x.denominator == 1 for x in a)


def res_pi(a):
    assert is_alg_int(a)
    return sum(int(x) for x in a) % 11


def val_pi(a, cap=50):
    """(1-z)-adic valuation of ANY element of Q(zeta_11) (may be negative)."""
    if is_zero(a):
        return cap
    v = 0
    # clear denominators: multiply by lcm; 11 = unit * pi^10
    den = 1
    for x in a:
        den = den * x.denominator // _gcd(den, x.denominator)
    b = smul(den, a)
    # v_pi(den): den = 11^e * m with gcd(m,11)=1 -> v = 10 e
    e = 0
    d = den
    while d % 11 == 0:
        d //= 11
        e += 1
    shift = 10 * e
    piinv = inv(PI)
    w = 0
    while w < cap + shift + 1:
        if res_pi(b) != 0:
            return w - shift
        b = mul(b, piinv)
        if not is_alg_int(b):
            raise AssertionError("valuation bookkeeping broken")
        w += 1
    return cap


def _gcd(a, b):
    while b:
        a, b = b, a % b
    return a


# ---------------------------------------------------------------------------
# geometry of the order-11 action
# ---------------------------------------------------------------------------
A = (1, 9, 4, 3, 5)                    # a_i = 9^i mod 11; F = sum x_i^2 x_{i+1} invariant
QR = frozenset({1, 3, 4, 5, 9})
QRL = sorted(QR)
IDX = {A[i]: i for i in range(5)}


def tangent_P4(j):
    return tuple((A[i] - A[j]) % 11 for i in range(5) if i != j)


def tangent_X(j):
    return tuple((A[i] - A[j]) % 11 for i in range(5)
                 if i not in (j, (j + 1) % 5))


def det_factor(ws, conv=+1):
    """conv=+1 (adopted A): prod(1 - z^{-w}); conv=-1 (B): prod(1 - z^{+w})."""
    return prod([one_minus_zpow(-conv * w) for w in ws])


def D_X(j, conv=+1):
    return det_factor(tangent_X(j), conv)


def D_P4(j, conv=+1):
    return det_factor(tangent_P4(j), conv)


def chi_sym(k, dual=True):
    """chi_{Sym^k W*}(g) (dual=True) or chi_{Sym^k W}(g), by integer DP."""
    if k < 0:
        return ZERO
    # dp[r] = number of 5-compositions of k with  sum alpha_i a_i = r (mod 11)
    dp = [[0] * 11 for _ in range(k + 1)]
    dp[0][0] = 1
    for i in range(5):
        nxt = [[0] * 11 for _ in range(k + 1)]
        for t in range(k + 1):
            for r in range(11):
                c = dp[t][r]
                if c:
                    e, tt = 0, t
                    rr = r
                    while tt <= k:
                        nxt[tt][rr] += c
                        tt += 1
                        rr = (rr + A[i]) % 11
        dp = nxt
    s = ZERO
    for r in range(11):
        if dp[k][r]:
            s = add(s, smul(dp[k][r], zpow(-r if dual else r)))
    return s


def chi_OX(k, dual=True):
    """chi_g(X, O_X(k)) via the Koszul sequence (F has weight 0)."""
    r = chi_sym(k, dual)
    if k >= 3:
        r = sub(r, chi_sym(k - 3, dual))
    return r


# ---------------------------------------------------------------------------
# Atiyah-Bott terms.  conv=+1 is the adopted convention (A); conv=-1 is (B),
# implemented directly (all weights negated), NOT as sigma_{-1} of (A) — so
# that (B) == sigma_{-1}((A)) can be *checked*, not built in.
# ---------------------------------------------------------------------------
def ab_point(tw, conv=+1):
    return inv(det_factor(tw, conv))


# --- truncated series with coefficients in Q(zeta_11) ---
def ser_mul(a, b, t):
    out = [ZERO] * t
    for i, x in enumerate(a):
        if is_zero(x):
            continue
        for j, y in enumerate(b):
            if i + j >= t:
                break
            out[i + j] = add(out[i + j], mul(x, y))
    return out


def ser_inv(a, t):
    i0 = inv(a[0])
    out = [ZERO] * t
    out[0] = i0
    for n in range(1, t):
        acc = ZERO
        for i in range(1, n + 1):
            if i < len(a):
                acc = add(acc, mul(a[i], out[n - i]))
        out[n] = neg(mul(i0, acc))
    return out


def ser_exp(eps, t):
    out, f = [], 1
    for n in range(t):
        if n:
            f *= n
        out.append(smul(Fr(eps ** n, f), ONE))
    return out


def ser_todd(t):
    """h / (1 - e^{-h})."""
    den, f = [], 1
    for n in range(t):
        f2 = 1
        for i in range(1, n + 2):
            f2 *= i
        den.append(smul(Fr((-1) ** n, f2), ONE))
    return ser_inv(den, t)


def ab_comp(parent_tw, c, conv=+1):
    """AB term of the fixed component P^{m-1} created by blowing up a fixed
    point with tangent multiset parent_tw at an eigenvalue c of multiplicity
    m >= 2.  Independent derivation:

      Y = P(V_c) = P^{m-1} inside E = P(T_p).  Normal bundle of Y in the
      blowup:  O_Y(-1) with g-weight c   (from N_{E/Bl} = O_E(-1))
        (+)    O_Y(1) x line of weight (w - c) for each tangent weight w != c
               (from T_E|_Y = Hom(O(-1), T_p/O(-1)), the V_c part being T_Y).
      Holomorphic Lefschetz (Atiyah-Singer III), conv=+1:
        contribution = int_Y td(T_Y) / [ (1 - z^{-c} e^{+h})
                        * prod_{w != c} (1 - z^{-(w-c)} e^{-h}) ] ,
      the coefficient of h^{m-1} (Chern roots: c_1(O_Y(-1)) = -h, so
      e^{-x} = e^{+h} on that summand).  conv=-1 negates every weight.
    """
    m = sum(1 for w in parent_tw if (w - c) % 11 == 0)
    assert m >= 2
    t = m
    num = ser_todd(t)
    acc = num
    for _ in range(m - 1):
        acc = ser_mul(acc, num, t)
    e_plus = ser_exp(+1, t)
    e_minus = ser_exp(-1, t)
    den = [sub(x, y) for x, y in
           zip([ONE] + [ZERO] * (t - 1),
               [mul(zpow(-conv * c), u) for u in e_plus])]
    for w in parent_tw:
        if (w - c) % 11 == 0:
            continue
        f = [sub(x, y) for x, y in
             zip([ONE] + [ZERO] * (t - 1),
                 [mul(zpow(-conv * (w - c)), u) for u in e_minus])]
        den = ser_mul(den, f, t)
    ser = ser_mul(acc, ser_inv(den, t), t)
    return ser[m - 1]


# ---------------------------------------------------------------------------
# tower model (referee's own): sites, blowup, enumeration
# ---------------------------------------------------------------------------
def site_pt(tw, vw):
    return ("pt", tuple(sorted(w % 11 for w in tw)), vw % 11)


def site_comp(ptw, c, vw):
    return ("comp", tuple(sorted(w % 11 for w in ptw)), c % 11, vw % 11)


def defined(s):
    return s[-1] in QR


def blowup(s, mu):
    """Blow up an isolated fixed point site; mu is a residue mod 11 (the
    geometric multiplicity enters the value weight only through its residue).
    Returns the list of fixed sites on the exceptional locus."""
    assert s[0] == "pt"
    tw, vw = s[1], s[2]
    out = []
    for c in sorted(set(tw)):
        m = tw.count(c)
        nvw = (vw + mu * c) % 11
        if m == 1:
            rest = tuple((w - c) % 11 for w in tw if w != c)
            out.append(site_pt((c,) + rest, nvw))
        else:
            out.append(site_comp(tw, c, nvw))
    return out


_TERM = {}


def site_term(s, conv=+1):
    key = (s, conv)
    if key in _TERM:
        return _TERM[key]
    if s[0] == "pt":
        r = ab_point(s[1], conv)
    else:
        r = ab_comp(s[1], s[2], conv)
    _TERM[key] = r
    return r


def rho(s):
    """res_pi(pi^4 * AB(s)) for a 4-fold tower site (conv A)."""
    x = mul(prod([PI] * 4), site_term(s, +1))
    assert is_alg_int(x)
    return res_pi(x)


# ------------------------------------------------------------- enumeration
def subtree_vectors(s, budget, mus, memo):
    """All achievable value-graded (mass, count) vectors of CLOSED sub-towers
    rooted at site s within `budget` further blowups, multiplicity residues
    drawn from `mus`.  A vector is a tuple over QRL of (element, int).
    Returns a set of vectors (empty = cannot close)."""
    key = (s, budget)
    if key in memo:
        return memo[key]
    if defined(s):
        base = tuple((site_term(s) if w == s[-1] else ZERO,
                      1 if w == s[-1] else 0) for w in QRL)
        memo[key] = {base}
        return {base}
    if s[0] == "comp" or budget <= 0:
        memo[key] = set()
        return set()
    acc = set()
    for mu in mus:
        kids = blowup(s, mu)
        parts = [subtree_vectors(k, budget - 1, mus, memo) for k in kids]
        if any(not p for p in parts):
            continue
        cur = {tuple((ZERO, 0) for _ in QRL)}
        for p in parts:
            cur = {vsum(a, b) for a in cur for b in p}
        acc |= cur
    memo[key] = acc
    return acc


def vsum(a, b):
    return tuple((add(x[0], y[0]), x[1] + y[1]) for x, y in zip(a, b))


def towers_over_e0(d, mu1, budget, mus, memo):
    """Closed-tower vectors over e_0 with level-1 residue mu1 and `budget`
    further levels below level 1."""
    root = site_pt(tangent_P4(0), d * A[0])
    assert not defined(root)
    kids = blowup(root, mu1)
    parts = [subtree_vectors(k, budget, mus, memo) for k in kids]
    if any(not p for p in parts):
        return set()
    cur = {tuple((ZERO, 0) for _ in QRL)}
    for p in parts:
        cur = {vsum(a, b) for a in cur for b in p}
    return cur


def globalize(v0):
    """Value-graded masses over all five receiver points by N_G(C11)
    transport (tower over the a-weight-s point = s-scaling, terms by sigma_s).
    Returns (M dict, n_x dict)."""
    M = {w: ZERO for w in QRL}
    cnt = {w: 0 for w in QRL}
    for s in QRL:
        for i, w in enumerate(QRL):
            t = (s * w) % 11
            M[t] = add(M[t], sigma(v0[i][0], s))
            cnt[t] += v0[i][1]
    return M, cnt


def residual_Ek(M, kmax=3, conv=+1):
    """E_k = sum_W z^{-conv k W} M(W) - chi_g(X, O(k)) in the convention."""
    out = []
    for k in range(kmax + 1):
        s = total([mul(zpow(-conv * k * w), M[w]) for w in QRL])
        out.append(sub(s, chi_OX(k, dual=(conv == +1))))
    return out


def R_vector(M):
    return {w: res_pi(mul(prod([PI] * 4), M[w])) for w in QRL}


def forced_traces(M, conv=+1):
    return {w: mul(D_X(IDX[w], conv), M[w]) for w in QRL}
