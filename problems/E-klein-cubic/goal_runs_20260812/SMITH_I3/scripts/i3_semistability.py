#!/usr/bin/env python3
"""
I3 -- the Hilbert-Mumford semistability support test for tuples
T in Sym^d W* (x) W, W = C^5, under SL(W) = SL(5).

CONVENTION (pinned by DATA_SPEC_SMITH_I3_20260812.md sec.1, verbatim):

  support element  = (alpha, c),  alpha in Z^5_{>=0}, |alpha| = d,  c in {0..4}
                     (the monomial x^alpha tensor e_c, i.e. the seed X^alpha e_c)
  1-PS             = integer weight vector r in Z^5 with sum(r) = 0,
                     acting by  x_i -> t^{-r_i} x_i  on coordinates
                     (so e_i -> t^{r_i} e_i on W)
  weight of (a,c)  = <r, alpha> - r_c
  T is UNSTABLE   iff  some r makes the weight of EVERY support element
                        strictly positive.
  T is SEMISTABLE iff  no such r exists.

EXACT REFORMULATION (Gordan's theorem; no floating point anywhere).
Put  w(alpha,c) := alpha - e_c  in Z^5.  The weight is <r, w>.  Note
sum_i w_i = d - 1 for every support element, a constant.  Gordan:

    exists r in R^5 with sum(r) = 0 and <r,w> > 0 for all w in S
  <=>
    0 is NOT in conv( pi(S) ),   pi = orthogonal projection onto {sum = 0}

  <=> the barycentric target  t := ((d-1)/5) * (1,1,1,1,1)  is NOT in conv(S).

So:  T is SEMISTABLE  <=>  t in conv{ alpha - e_c : (alpha,c) in supp T }.

That membership is decided EXACTLY by a Phase-I simplex over Fraction:
minimise the sum of artificial variables subject to
    sum_j lambda_j * w_j = t ,  sum_j lambda_j = 1 ,  lambda >= 0.
Optimum 0 <=> semistable.  Optimum > 0 <=> unstable, and the Phase-I dual
vector y = (r, s) in Q^6 satisfies  <r,w_j> + s <= 0 for all j  and
<r,t> + s > 0; setting r' := r - (sum_i r_i / 5) * (1,..,1) (so sum r' = 0)
gives <r', w_j> < 0 for all j, hence  r_destab := -r'  scaled to primitive
integers is an explicit destabilising 1-PS with all weights > 0.
Rational r is enough: the weight function is homogeneous of degree 1 in r,
so clearing denominators keeps every weight strictly positive.

Only python3 + the standard library (fractions) is used.
"""

from fractions import Fraction
from math import gcd
from functools import reduce
import itertools


# ---------------------------------------------------------------- exact LP

def _phase1(A, b):
    """
    Exact Phase-I simplex.

    A : list of m rows, each a list of n Fractions (the equality system A x = b)
    b : list of m Fractions

    Returns (opt, y) where opt is the minimal value of sum(artificials)
    (a Fraction >= 0) and y is the final dual vector (list of m Fractions)
    with the standard property:  at optimum, for every original column A_j,
    y . A_j <= 0, and y . b = opt.

    Bland's rule is used, so termination is guaranteed (no cycling).
    """
    m = len(A)
    n = len(A[0]) if m else 0

    # make b >= 0 by row sign flips
    A = [row[:] for row in A]
    b = b[:]
    for i in range(m):
        if b[i] < 0:
            A[i] = [-v for v in A[i]]
            b[i] = -b[i]

    # tableau columns: n originals, then m artificials
    N = n + m
    T = [A[i] + [Fraction(1) if k == i else Fraction(0) for k in range(m)] + [b[i]]
         for i in range(m)]
    basis = [n + i for i in range(m)]

    # cost row: minimise sum of artificials -> reduced costs after pricing out
    # z_j - c_j with c_j = 0 (originals), 1 (artificials)
    def price():
        row = [Fraction(0)] * (N + 1)
        for i in range(m):
            for j in range(N + 1):
                row[j] += T[i][j]
        for i in range(m):
            row[n + i] -= Fraction(1)
        return row

    obj = price()

    while True:
        # Bland: smallest index with positive reduced cost
        piv_col = -1
        for j in range(N):
            if obj[j] > 0:
                piv_col = j
                break
        if piv_col < 0:
            break
        # ratio test, Bland tie-break on the basis index
        piv_row = -1
        best = None
        for i in range(m):
            if T[i][piv_col] > 0:
                ratio = T[i][N] / T[i][piv_col]
                if best is None or ratio < best or (ratio == best and basis[i] < basis[piv_row]):
                    best = ratio
                    piv_row = i
        if piv_row < 0:
            raise RuntimeError("unbounded phase-I (impossible)")
        # pivot
        pv = T[piv_row][piv_col]
        T[piv_row] = [v / pv for v in T[piv_row]]
        for i in range(m):
            if i != piv_row and T[i][piv_col] != 0:
                f = T[i][piv_col]
                T[i] = [T[i][j] - f * T[piv_row][j] for j in range(N + 1)]
        f = obj[piv_col]
        obj = [obj[j] - f * T[piv_row][j] for j in range(N + 1)]
        basis[piv_row] = piv_col

    opt = obj[N]
    # dual vector: y_i = (reduced cost of artificial i) shifted back; the
    # artificial columns of the priced objective row carry  y_i - 1 .
    y = [obj[n + i] + Fraction(1) for i in range(m)]
    return opt, y


# ---------------------------------------------------------------- the test

def support_vectors(support):
    """support: iterable of (alpha, c). Returns list of w = alpha - e_c."""
    out = []
    for alpha, c in support:
        w = list(alpha)
        w[c] -= 1
        out.append(w)
    return out


def hm_test(support, d=None):
    """
    support : iterable of (alpha, c) with alpha a length-5 tuple of
              non-negative ints summing to d, c in {0..4}.
    Returns a dict:
      verdict   : 'SEMISTABLE' or 'UNSTABLE'
      d         : the degree
      n_support : |support|
      certificate : for UNSTABLE, a primitive integer r with sum(r)=0 and
                    min weight > 0; for SEMISTABLE, a rational convex
                    combination (lambda) witnessing the barycentre, given as
                    a list of (index, Fraction) with nonzero lambda.
      min_weight : for UNSTABLE, the minimal weight attained by the
                   certificate (a positive int).
    """
    support = list(support)
    if not support:
        raise ValueError("empty support: the zero tuple is unstable by fiat "
                         "and is excluded from the statement of I3")
    degs = {sum(a) for a, c in support}
    if len(degs) != 1:
        raise ValueError("support is not homogeneous: degrees %r" % (sorted(degs),))
    dd = degs.pop()
    if d is not None and d != dd:
        raise ValueError("declared d=%d but support has degree %d" % (d, dd))
    d = dd
    for alpha, c in support:
        if len(alpha) != 5 or any(x < 0 for x in alpha):
            raise ValueError("bad alpha %r" % (alpha,))
        if not (0 <= c <= 4):
            raise ValueError("bad c %r" % (c,))

    W = support_vectors(support)
    n = len(W)
    target = Fraction(d - 1, 5)

    # rows: 5 coordinate equations + 1 normalisation
    A = [[Fraction(W[j][i]) for j in range(n)] for i in range(5)]
    A.append([Fraction(1)] * n)
    b = [target] * 5 + [Fraction(1)]

    opt, y = _phase1(A, b)

    res = {"d": d, "n_support": n}
    if opt == 0:
        # recover a feasible lambda by re-solving: rerun the tableau is more
        # code than needed; instead certify membership directly by exhibiting
        # the convex combination via a second exact solve (least-index basis).
        lam = _recover_lambda(A, b)
        res["verdict"] = "SEMISTABLE"
        res["certificate"] = [(j, lam[j]) for j in range(n) if lam[j] != 0]
        # sanity: the combination reproduces the target
        for i in range(5):
            s = sum(lam[j] * A[i][j] for j in range(n))
            assert s == target, "lambda check failed"
        assert sum(lam) == 1
        return res

    # unstable: build the integer destabiliser from the dual
    r = [y[i] for i in range(5)]
    tot = sum(r)
    rp = [r[i] - tot / 5 for i in range(5)]
    rd = [-v for v in rp]
    # clear denominators
    from fractions import Fraction as F
    den = reduce(lambda a, bb: a * bb // gcd(a, bb), [v.denominator for v in rd], 1)
    ri = [int(v * den) for v in rd]
    g = reduce(gcd, [abs(v) for v in ri if v != 0], 0)
    if g:
        ri = [v // g for v in ri]
    assert sum(ri) == 0, "destabiliser not traceless: %r" % (ri,)
    weights = [sum(ri[i] * W[j][i] for i in range(5)) for j in range(n)]
    mw = min(weights)
    assert mw > 0, "dual did not certify instability: min weight %r" % (mw,)
    res["verdict"] = "UNSTABLE"
    res["certificate"] = ri
    res["min_weight"] = mw
    return res


def _recover_lambda(A, b):
    """Exact feasible non-negative solution of A x = b (known feasible),
    by a Phase-I simplex that also returns the primal basic solution."""
    m = len(A)
    n = len(A[0])
    Aw = [row[:] for row in A]
    bw = b[:]
    for i in range(m):
        if bw[i] < 0:
            Aw[i] = [-v for v in Aw[i]]
            bw[i] = -bw[i]
    N = n + m
    T = [Aw[i] + [Fraction(1) if k == i else Fraction(0) for k in range(m)] + [bw[i]]
         for i in range(m)]
    basis = [n + i for i in range(m)]
    obj = [Fraction(0)] * (N + 1)
    for i in range(m):
        for j in range(N + 1):
            obj[j] += T[i][j]
    for i in range(m):
        obj[n + i] -= Fraction(1)
    while True:
        piv_col = -1
        for j in range(N):
            if obj[j] > 0:
                piv_col = j
                break
        if piv_col < 0:
            break
        piv_row = -1
        best = None
        for i in range(m):
            if T[i][piv_col] > 0:
                ratio = T[i][N] / T[i][piv_col]
                if best is None or ratio < best or (ratio == best and basis[i] < basis[piv_row]):
                    best = ratio
                    piv_row = i
        if piv_row < 0:
            raise RuntimeError("unbounded")
        pv = T[piv_row][piv_col]
        T[piv_row] = [v / pv for v in T[piv_row]]
        for i in range(m):
            if i != piv_row and T[i][piv_col] != 0:
                f = T[i][piv_col]
                T[i] = [T[i][j] - f * T[piv_row][j] for j in range(N + 1)]
        f = obj[piv_col]
        obj = [obj[j] - f * T[piv_row][j] for j in range(N + 1)]
        basis[piv_row] = piv_col
    x = [Fraction(0)] * n
    for i in range(m):
        if basis[i] < n:
            x[basis[i]] = T[i][N]
    return x


def weight_of(alpha, c, r):
    """The pinned weight <r, alpha> - r_c."""
    return sum(r[i] * alpha[i] for i in range(5)) - r[c]


# --------------------------------------------------------- the two anchors

def klein_F_monomials():
    """
    F = sum_i x_i^2 x_{i+1}  (indices mod 5) -- the Klein-cubic normal form
    named by the spec.  Returns the list of exponent vectors alpha with
    |alpha| = 3.
    """
    out = []
    for i in range(5):
        a = [0] * 5
        a[i] += 2
        a[(i + 1) % 5] += 1
        out.append(tuple(a))
    return out


def anchor_i_support():
    """
    Anchor (i): the tuple  F * x , i.e. the tuple whose c-th coordinate is
    F * x_c ; support = { (alpha_F + e_c, c) : alpha_F monomial of F,
    c in 0..4 }.  Degree d = 4.
    """
    sup = []
    for a in klein_F_monomials():
        for c in range(5):
            al = list(a)
            al[c] += 1
            sup.append((tuple(al), c))
    return sup


def anchor_ii_support(d):
    """Anchor (ii): the single-seed tuple x_0^d e_0."""
    return [((d, 0, 0, 0, 0), 0)]


def run_anchors(d_for_anchor_ii=35):
    out = {}

    sup1 = anchor_i_support()
    r1 = hm_test(sup1)
    out["anchor_i_F_times_x"] = {
        "expected": "SEMISTABLE",
        "got": r1["verdict"],
        "pass": r1["verdict"] == "SEMISTABLE",
        "d": r1["d"],
        "n_support": r1["n_support"],
        "convex_certificate": [[j, str(l)] for j, l in r1.get("certificate", [])],
    }

    sup2 = anchor_ii_support(d_for_anchor_ii)
    r2 = hm_test(sup2)
    pinned = [4, -1, -1, -1, -1]
    pinned_weights = [weight_of(a, c, pinned) for a, c in sup2]
    out["anchor_ii_x0d_e0"] = {
        "expected": "UNSTABLE",
        "got": r2["verdict"],
        "pass": r2["verdict"] == "UNSTABLE",
        "d": r2["d"],
        "n_support": r2["n_support"],
        "found_destabiliser": r2.get("certificate"),
        "min_weight_found": r2.get("min_weight"),
        "pinned_destabiliser": pinned,
        "pinned_destabiliser_weights": pinned_weights,
        "pinned_destabiliser_works": all(w > 0 for w in pinned_weights),
    }

    # also run anchor (ii) at the anchor-(i) degree, to show the verdict is
    # not an artefact of d
    r3 = hm_test(anchor_ii_support(4))
    out["anchor_ii_at_d4"] = {"got": r3["verdict"], "pass": r3["verdict"] == "UNSTABLE"}

    out["all_pass"] = all(v.get("pass", True) for v in out.values() if isinstance(v, dict))
    return out


if __name__ == "__main__":
    import json
    res = run_anchors()
    print(json.dumps(res, indent=2))
