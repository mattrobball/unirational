"""Stage 2: the odd-order pinning engine.

Two INDEPENDENT integer code paths compute the same thing:

  PATH A  (closed form)  weight(value) = d*a_k + sum_l mu_l * c_l   (mod n)
  PATH B  (enumeration)  enumerate every degree-d monomial in the g-eigenbasis,
                         keep those satisfying the covariance congruence, and
                         read off which target eigenspace the coefficient of the
                         relevant local monomial can sit in.

Path B never uses the closed form; it rebuilds the local expansion from the
global monomial list.  Both are pure Z/n arithmetic - no floating point.

Conventions (proved in THEOREM.md sec.1):
  T in (Sym^d W* tensor W)^G,   T(g v) = g T(v)   (G perfect => no character twist)
  g of order n, eigenbasis e_0..e_4 with g e_i = zeta_n^{a_i} e_i
  monomial x^alpha occurs in T_i only if sum_j alpha_j a_j = a_i (mod n).
"""
from itertools import product

# ---------------------------------------------------------------- spectra
# weight multiset of a generator on W, and which weight-eigenpoints lie on X.
# (verified in s2eigen.py at p = 331 and p = 661)
SPECTRUM = {
    3:  {"weights": (0, 1, 1, 2, 2), "onX": {0: False}},     # 1,2 are eigenLINES
    5:  {"weights": (0, 1, 2, 3, 4), "onX": {0: False, 1: True, 2: True,
                                             3: True, 4: True}},
    6:  {"weights": (0, 1, 2, 4, 5), "onX": {0: False, 1: True, 2: False,
                                             4: False, 5: True}},
    11: {"weights": (1, 3, 4, 5, 9), "onX": {1: True, 3: True, 4: True,
                                             5: True, 9: True}},
}
QR11 = (1, 3, 4, 5, 9)


def wset(n):
    return set(SPECTRUM[n]["weights"])


def onX_weights(n):
    """weights whose eigenSPACE meets X in a point that is a g-fixed point of X."""
    return {w for w, f in SPECTRUM[n]["onX"].items() if f}


# ---------------------------------------------------------------- PATH A
def pathA_weight(n, d, a_k, chain):
    """chain = [(mu_1,c_1),(mu_2,c_2),...]; returns the value weight mod n."""
    w = d * a_k
    for mu, c in chain:
        w += mu * c
    return w % n


# ---------------------------------------------------------------- PATH B
def _monomials(deg, nvar=5):
    if nvar == 1:
        yield (deg,)
        return
    for k in range(deg + 1):
        for rest in _monomials(deg - k, nvar - 1):
            yield (k,) + rest


def pathB_level0(n, d):
    """For each eigenpoint index k, the set of target eigenSPACE weights the
    value T(e_k) can occupy - obtained by enumerating monomials, not by
    the closed form."""
    a = SPECTRUM[n]["weights"]
    out = {}
    for k in range(5):
        alpha = [0] * 5
        alpha[k] = d
        wt = sum(alpha[j] * a[j] for j in range(5)) % n
        targets = {a[i] for i in range(5) if a[i] % n == wt}
        out[k] = (wt, targets)
    return out


def pathB_level1(n, d, k, mu):
    """Coefficient of y_j^mu in the local expansion at e_k: which target
    eigenspace weights are allowed, for each normal direction j != k.
    Rebuilt by enumerating the GLOBAL monomial x_k^{d-mu} x_j^{mu}."""
    a = SPECTRUM[n]["weights"]
    out = {}
    if mu > d:
        return out
    for j in range(5):
        if j == k:
            continue
        alpha = [0] * 5
        alpha[k] = d - mu
        alpha[j] = mu
        wt = sum(alpha[t] * a[t] for t in range(5)) % n
        out[j] = (wt, {a[i] for i in range(5) if a[i] % n == wt})
    return out


def pathB_level2(n, d, k, j, mu1, mu2):
    """Two-step chain: order mu1 at e_k, then order mu2 in direction j, then
    the second-level direction j2.  Rebuilt from the global monomial
    x_k^{d-mu1} x_j^{mu1-mu2} x_{j2}^{mu2}   (the monomial whose local
    bidegree realises the chain)."""
    a = SPECTRUM[n]["weights"]
    out = {}
    if mu1 > d or mu2 > mu1:
        return out
    for j2 in range(5):
        if j2 in (k, j):
            continue
        alpha = [0] * 5
        alpha[k] = d - mu1
        alpha[j] = mu1 - mu2
        alpha[j2] = mu2
        wt = sum(alpha[t] * a[t] for t in range(5)) % n
        out[j2] = (wt, {a[i] for i in range(5) if a[i] % n == wt})
    return out


# ---------------------------------------------------------------- rows
# The 22 coherence-immune rows of the terminus Z (STAGE1 THEOREM.md sec.15.5),
# identified with their eigen-data from TERMINUS_STRATA_PW results/t2_strata.txt
# (stage 3 block).  base = g-weight of the level-0 centre; chain = relative
# weights c_1 (, c_2) of the exceptional directions (the STARRED weights).
IMMUNE_ROWS = [
    # ---- C11 : 4 rows, over the 60 C11-points, base weight k = 9 (representative)
    dict(name="C11/pt_C11 c=3", n=11, base=9, chain=(3,), dim=0, ncomp=60,
         stab="C11", cell="P11", nvalues=5),
    dict(name="C11/pt_C11 c=5", n=11, base=9, chain=(5,), dim=0, ncomp=60,
         stab="C11", cell="P11", nvalues=5),
    dict(name="C11/pt_C11 c=6", n=11, base=9, chain=(6,), dim=0, ncomp=60,
         stab="C11", cell="P11", nvalues=5),
    dict(name="C11/pt_C11 c=7", n=11, base=9, chain=(7,), dim=0, ncomp=60,
         stab="C11", cell="P11", nvalues=5),
    # ---- C5 : 8 rows over the two exact-C5 point orbits, base a = 1 resp. 2
    dict(name="C5/pt_C5(a) c=1", n=5, base=1, chain=(1,), dim=0, ncomp=132,
         stab="C5", cell="P5", nvalues=4),
    dict(name="C5/pt_C5(a) c=2", n=5, base=1, chain=(2,), dim=0, ncomp=132,
         stab="C5", cell="P5", nvalues=4),
    dict(name="C5/pt_C5(a) c=3", n=5, base=1, chain=(3,), dim=0, ncomp=132,
         stab="C5", cell="P5", nvalues=4),
    dict(name="C5/pt_C5(a) c=4", n=5, base=1, chain=(4,), dim=0, ncomp=132,
         stab="C5", cell="P5", nvalues=4),
    dict(name="C5/pt_C5(b) c=1", n=5, base=2, chain=(1,), dim=0, ncomp=132,
         stab="C5", cell="P5", nvalues=4),
    dict(name="C5/pt_C5(b) c=2", n=5, base=2, chain=(2,), dim=0, ncomp=132,
         stab="C5", cell="P5", nvalues=4),
    dict(name="C5/pt_C5(b) c=3", n=5, base=2, chain=(3,), dim=0, ncomp=132,
         stab="C5", cell="P5", nvalues=4),
    dict(name="C5/pt_C5(b) c=4", n=5, base=2, chain=(4,), dim=0, ncomp=132,
         stab="C5", cell="P5", nvalues=4),
    # ---- C5 : 2 rows over the D10-points (base weight 0 : ALWAYS a base point)
    dict(name="C5/pt_D10 c=1", n=5, base=0, chain=(1,), dim=0, ncomp=132,
         stab="C5", cell="P5", nvalues=4),
    dict(name="C5/pt_D10 c=2", n=5, base=0, chain=(2,), dim=0, ncomp=132,
         stab="C5", cell="P5", nvalues=4),
    # ---- C3 : 8 rows over the two A4-point orbits
    dict(name="C3/pt_A4(a) dim1 c=1", n=3, base=1, chain=(1,), dim=1, ncomp=220,
         stab="C3", cell="P3+P6", nvalues=6),
    dict(name="C3/pt_A4(a) dim0 c=2", n=3, base=1, chain=(2,), dim=0, ncomp=220,
         stab="C3", cell="P3+P6", nvalues=6),
    dict(name="C3/pt_A4(a)<ell_V c=(1,1)", n=3, base=1, chain=(1, 1), dim=0,
         ncomp=220, stab="C3", cell="P3+P6", nvalues=6),
    dict(name="C3/pt_A4(a)<ell_V c=(1,2)", n=3, base=1, chain=(1, 2), dim=0,
         ncomp=220, stab="C3", cell="P3+P6", nvalues=6),
    dict(name="C3/pt_A4(b) dim1 c=2", n=3, base=2, chain=(2,), dim=1, ncomp=220,
         stab="C3", cell="P3+P6", nvalues=6),
    dict(name="C3/pt_A4(b) dim0 c=1", n=3, base=2, chain=(1,), dim=0, ncomp=220,
         stab="C3", cell="P3+P6", nvalues=6),
    dict(name="C3/pt_A4(b)<ell_V c=(2,2)", n=3, base=2, chain=(2, 2), dim=0,
         ncomp=220, stab="C3", cell="P3+P6", nvalues=6),
    dict(name="C3/pt_A4(b)<ell_V c=(2,1)", n=3, base=2, chain=(2, 1), dim=0,
         ncomp=220, stab="C3", cell="P3+P6", nvalues=6),
]

# The C6-band rows touched by the consistency system (Stab_G = C6, values in
# X^{C6} = the two weight-1 / weight-5 points of L_t).
C6_BAND_ROWS = [
    dict(name="C3line dim2 c=1", n=3, base=1, chain=(1,), stab="C6"),
    dict(name="C3line dim1 c=2", n=3, base=1, chain=(2,), stab="C6"),
    dict(name="C3/pt_D12 dim1 c=1", n=3, base=0, chain=(1,), stab="C6"),
    dict(name="C3/pt_C6(a) dim1 c=1", n=3, base=1, chain=(1,), stab="C6"),
    dict(name="C3/pt_C6(b) dim1 c=1", n=3, base=2, chain=(1,), stab="C6"),
]

# number of points of X in each C3 eigenline (RECEIVER_LEDGER_X 3.1):
#   weight-1 line: 1 C6-point + 2 exact-C3 points;  same for weight-2.
C3_LINE_XPOINTS = 3


def value_set(n, weight):
    """Which points of X^{<g>} sit in the weight-`weight` eigenspace."""
    if n == 3:
        if weight == 0:
            return []                      # the D12-point, OFF X
        return ["C6pt(w=%d)" % weight] + ["exactC3_%d(w=%d)" % (t, weight)
                                          for t in (1, 2)]
    if SPECTRUM[n]["onX"].get(weight, False):
        return ["eigpt(w=%d)" % weight]
    return []


# ------------------------------------------------- first-order character table
def tangent_weights(n, a):
    """relative weights of T_p P(W) at the weight-a eigenpoint (mult-1 spectra)."""
    ws = list(SPECTRUM[n]["weights"])
    ws.remove(a)
    return sorted((w - a) % n for w in ws)


def forbidden_relative_weight(n, a):
    """dF at the weight-a eigenpoint is supported on the weight-(-2a) eigenspace,
    so ker(dF) drops exactly the relative weight (-2a) - a = -3a."""
    return (-3 * a) % n


def diff_blocks(n, d, a_k):
    """Relative weights c on which dT_p can be non-zero, for the pinned point
    p of weight a_k mapping to the point of weight d*a_k."""
    a_i = (d * a_k) % n
    if not SPECTRUM[n]["onX"].get(a_i, False):
        return None                        # not a pinned point: value off X
    src = set(tangent_weights(n, a_k))
    tgt = set(tangent_weights(n, a_i))
    tgt.discard(forbidden_relative_weight(n, a_i))
    return sorted(src & tgt)
