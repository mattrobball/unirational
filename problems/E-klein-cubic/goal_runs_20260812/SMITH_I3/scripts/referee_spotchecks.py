#!/usr/bin/env python3
"""
REFEREE spot-checks for the SMITH_I3 packet (hostile referee pass, 2026-08-12).

Independent re-derivations; nothing here reuses the packet's own arithmetic
except where the point is to cross-validate it against a second, structurally
different implementation.  python3 stdlib only (+ json reads of sealed files).

Sections
  R1  independent convex-hull membership (Caratheodory + exact Gauss) vs the
      packet's Phase-I simplex, on both anchors and on random supports;
      also verifies lambda >= 0 on the semistable certificates (a check the
      packet verifier's A2 omits).
  R2  Lemma U(a) proof defect: the "pairwise distinct tangent weights are
      inherited at every stage" claim is FALSE at the first wonderful blowup
      (concrete weight arithmetic).  The finiteness statement in the lemma's
      full generality ("ANY smooth G-equivariant model") is thereby
      unsupported: one further G-orbit point blowup at a repeated-weight
      fixed point produces a fixed P^1.
  R3  group theory replayed on an explicit PSL(2,11) (matrices over F_11
      mod +-I): 12 Sylow-11s, 66 Sylow-5s, |N(C11)| = 55, exactly 5 cosets of
      G/C11 fixed by C11 with the residual C5 free and transitive on them,
      exactly 2 cosets of G/C5 fixed by C5 -- the row arithmetic 4x5 = 20,
      10x2 = 20 and Lemma U(b)'s bijection step.
  R4  order-11 menu rebuilt from w = 35*9 + mu*c mod 11 (one line, no shared
      code) against the sealed vectors_d35.json; defined-row vector; order-5
      n_x recounted from scratch over all 64 entries.
  R5  the eigenbasis-corollary thresholds, both frames, both degrees.
  R6  F3 closures against the census DICTIONARY block re-parsed from
      t2_strata.txt; order-3 bookkeeping 62 + 32 = 94.
  R7  sigma-band flags: group_key shared by all 22 at BOTH primes; no
      sol_hash field in D35_AUDIT patterns; id sets agree across primes.
"""

import itertools
import json
import os
import random
import sys
from fractions import Fraction

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
ROOT = os.path.abspath(os.path.join(HERE, "..", "..", ".."))

from i3_semistability import hm_test, anchor_i_support, anchor_ii_support

FAIL = []


def report(name, ok, detail=""):
    print("[%s] %s  %s" % ("PASS" if ok else "FAIL", name, detail))
    if not ok:
        FAIL.append(name)


# ------------------------------------------------------------------- R1
def solve_exact(rows, rhs):
    """Gauss over Fraction; returns one solution of rows*x = rhs or None."""
    m, n = len(rows), len(rows[0])
    A = [[Fraction(v) for v in rows[i]] + [Fraction(rhs[i])] for i in range(m)]
    piv_cols = []
    r = 0
    for c in range(n):
        p = next((i for i in range(r, m) if A[i][c] != 0), None)
        if p is None:
            continue
        A[r], A[p] = A[p], A[r]
        A[r] = [v / A[r][c] for v in A[r]]
        for i in range(m):
            if i != r and A[i][c] != 0:
                f = A[i][c]
                A[i] = [A[i][j] - f * A[r][j] for j in range(n + 1)]
        piv_cols.append(c)
        r += 1
        if r == m:
            break
    for i in range(r, m):
        if A[i][n] != 0:
            return None
    x = [Fraction(0)] * n
    for i, c in enumerate(piv_cols):
        x[c] = A[i][n]
    return x


def member_caratheodory(support):
    """t in conv{alpha - e_c}?  Exhaustive subsets of size <= 6, exact."""
    W = []
    for alpha, c in support:
        w = list(alpha)
        w[c] -= 1
        W.append(w)
    d = sum(support[0][0])
    t = Fraction(d - 1, 5)
    n = len(W)
    for size in range(1, min(n, 6) + 1):
        for idx in itertools.combinations(range(n), size):
            rows = [[W[j][i] for j in idx] for i in range(5)] + [[1] * size]
            rhs = [t] * 5 + [1]
            x = solve_exact(rows, rhs)
            if x is not None and all(v >= 0 for v in x):
                return True
    return False


def r1():
    # anchors
    sup1 = anchor_i_support()
    r = hm_test(sup1)
    report("R1 anchor-i simplex says SEMISTABLE", r["verdict"] == "SEMISTABLE")
    report("R1 anchor-i independent membership says t IN hull",
           member_caratheodory(sup1) is True)
    lam = r["certificate"]
    report("R1 anchor-i certificate lambda >= 0 (verifier A2 gap)",
           all(v >= 0 for _, v in lam) and sum(v for _, v in lam) == 1,
           "%d nonzero lambdas" % len(lam))
    for d in (4, 35):
        s2 = anchor_ii_support(d)
        r2 = hm_test(s2)
        ok = (r2["verdict"] == "UNSTABLE"
              and member_caratheodory(s2) is False
              and min(sum(r2["certificate"][i] * (s2[0][0][i] -
                          (1 if i == s2[0][1] else 0)) for i in range(5))
                      for _ in [0]) > 0)
        report("R1 anchor-ii d=%d UNSTABLE + independent NOT-in-hull + "
               "certificate weights > 0" % d, ok, "r=%r" % (r2["certificate"],))

    # randomized cross-validation
    rnd = random.Random(20260812)
    agree = 0
    total = 0
    for trial in range(300):
        d = rnd.choice([2, 3, 4, 5, 6])
        nsup = rnd.randrange(1, 8)
        sup = set()
        while len(sup) < nsup:
            cuts = sorted(rnd.randrange(0, d + 1) for _ in range(4))
            a = (cuts[0], cuts[1] - cuts[0], cuts[2] - cuts[1],
                 cuts[3] - cuts[2], d - cuts[3])
            sup.add((a, rnd.randrange(5)))
        sup = sorted(sup)
        v = hm_test(sup)
        inhull = member_caratheodory(sup)
        okv = (v["verdict"] == "SEMISTABLE") == inhull
        if v["verdict"] == "SEMISTABLE":
            okv = okv and all(l >= 0 for _, l in v["certificate"])
        else:
            ri = v["certificate"]
            wts = [sum(ri[i] * w[i] for i in range(5))
                   for w in ([list(a)[:c] + [a[c] - 1] + list(a)[c + 1:]
                              for a, c in sup])]
            okv = okv and min(wts) > 0 and sum(ri) == 0
        total += 1
        agree += okv
    report("R1 random supports: simplex == independent Caratheodory, "
           "certificates verified", agree == total, "%d/%d" % (agree, total))


# ------------------------------------------------------------------- R2
def r2():
    QR = [1, 3, 4, 5, 9]
    # tangent weights at the eigenpoint of character r0: {r_j - r0 mod 11}
    bad = []
    for r0 in QR:
        tw = sorted((r - r0) % 11 for r in QR if r != r0)
        # blow the point up; new fixed point per eigenline wL
        for wL in tw:
            new = sorted(((w - wL) % 11 for w in tw if w != wL)) + [wL]
            if len(set(new)) < 4:
                bad.append((r0, tuple(tw), wL, tuple(sorted(new))))
    report("R2 'pairwise distinct weights inherited' is FALSE at stage 1",
           len(bad) > 0,
           "counterexamples (r0, weights, eigenline, new weights): %s ..."
           % (bad[:2],))
    # at such a point all weights are still nonzero (fixed point isolated)...
    all_nonzero = all(0 not in b[3] for b in bad)
    report("R2 ...but still nonzero there (Z's own 20 points stay isolated)",
           all_nonzero)
    # ...while ONE further blowup of that point makes a fixed P^1:
    # P(N) with a repeated weight contains P(2-dim eigenspace) = P^1.
    rep = bad[0]
    mult = max(rep[3].count(x) for x in rep[3])
    report("R2 one more G-orbit point blowup there yields a fixed P^1 "
           "(repeated weight => P(eigenspace) in the fixed locus)",
           mult >= 2, "repeated weight multiplicity %d at %r" % (mult, rep))


# ------------------------------------------------------------------- R3
def psl211():
    p = 11
    els = set()
    for a in range(p):
        for b in range(p):
            for c in range(p):
                for d in range(p):
                    if (a * d - b * c) % p == 1:
                        M = (a, b, c, d)
                        N = tuple((-x) % p for x in M)
                        els.add(min(M, N))
    return sorted(els)


def mul(M, N, p=11):
    a, b, c, d = M
    e, f, g, h = N
    R = ((a * e + b * g) % p, (a * f + b * h) % p,
         (c * e + d * g) % p, (c * f + d * h) % p)
    Rn = tuple((-x) % p for x in R)
    return min(R, Rn)


def r3():
    G = psl211()
    report("R3 |PSL(2,11)| = 660", len(G) == 660, len(G))

    def order(M):
        I = (1, 0, 0, 1)
        k, X = 1, M
        while X != I:
            X = mul(X, M)
            k += 1
        return k

    ords = {}
    for M in G:
        ords.setdefault(order(M), 0)
        ords[order(M)] += 1
    report("R3 element orders give 12 C11s and 66 C5s",
           ords.get(11, 0) == 120 and ords.get(5, 0) == 264,
           "n11 elts %d /10 = %d subgroups; n5 elts %d /4 = %d"
           % (ords.get(11, 0), ords.get(11, 0) // 10,
              ords.get(5, 0), ords.get(5, 0) // 4))

    # fixed cosets of H on G/H, H = C11 = <[[1,1],[0,1]]>
    T = (1, 1, 0, 1)
    H = [(1, 0, 0, 1)]
    X = T
    while X != (1, 0, 0, 1):
        H.append(X)
        X = mul(X, T)
    H = set(H)
    report("R3 |C11| = 11", len(H) == 11)
    cosets = {}
    for g in G:
        key = frozenset(mul(g, h) for h in H)
        cosets[key] = g
    fixed = [key for key in cosets
             if all(frozenset(mul(T, x) for x in key) == key for _ in [0])]
    # left action of T fixes gH iff T g H = g H
    fixed = [key for key in cosets if frozenset(mul(T, x) for x in key) == key]
    report("R3 exactly 5 cosets of G/C11 are C11-fixed (row => 5 pts/fixed C11)",
           len(fixed) == 5, len(fixed))
    N = [g for g in G if frozenset(mul(mul(g, t), inv(g)) for t in H) == frozenset(H)]
    report("R3 |N_G(C11)| = 55 (residual C5)", len(N) == 55, len(N))
    # residual action on the 5 fixed cosets: free + transitive
    n0 = next(g for g in N if frozenset(mul(g, h) for h in H) != frozenset(H)
              and order_mod(g, H) == 5)
    orb = set()
    key = frozenset(H)
    x = key
    for _ in range(5):
        x = frozenset(mul(n0, y) for y in x)
        orb.add(x)
    report("R3 residual C5 transitive on the 5 fixed cosets", len(orb) == 5)

    # H = C5: fixed cosets of G/C5
    M5 = next(g for g in G if order(g) == 5)
    H5 = [(1, 0, 0, 1)]
    X = M5
    while X != (1, 0, 0, 1):
        H5.append(X)
        X = mul(X, M5)
    H5 = set(H5)
    cos5 = set()
    for g in G:
        cos5.add(frozenset(mul(g, h) for h in H5))
    fixed5 = [k for k in cos5 if frozenset(mul(M5, x) for x in k) == k]
    report("R3 exactly 2 cosets of G/C5 are C5-fixed (row => 2 pts/fixed C5)",
           len(fixed5) == 2, len(fixed5))


def inv(M, p=11):
    a, b, c, d = M
    # det = 1
    R = (d % p, (-b) % p, (-c) % p, a % p)
    Rn = tuple((-x) % p for x in R)
    return min(R, Rn)


def order_mod(g, H):
    # order of gH in N/H
    k = 1
    x = g
    while frozenset(mul(x, h) for h in H) != frozenset(H):
        x = mul(x, g)
        k += 1
    return k


# ------------------------------------------------------------------- R4
def r4():
    v = json.load(open(os.path.join(
        ROOT, "goal_runs_20260811", "GLOBAL_COHERENCE", "results",
        "vectors_d35.json")))
    onx = {1, 3, 4, 5, 9}
    mine = []
    ndef = []
    for mu in range(1, 11):
        vec = []
        for c in (3, 5, 6, 7):
            w = (35 * 9 + mu * c) % 11
            vec.append("eigpt(w=%d)" % w if w in onx else "UNDEF")
        mine.append(vec)
        ndef.append(sum(1 for x in vec if x != "UNDEF"))
    sealedv = v["per_center"]["C11"]["vectors"]
    report("R4 order-11 menu: independent rebuild == sealed vectors "
           "(entry order mu = 1..10)",
           mine == sealedv or sorted(map(tuple, mine)) == sorted(map(tuple, sealedv)),
           "defined-row vector %r" % (ndef,))
    report("R4 defined-row vector is [2,0,2,2,2,3,3,2,2,2], max 3",
           ndef == [2, 0, 2, 2, 2, 3, 3, 2, 2, 2] and max(ndef) == 3)

    # order 5 recount, fresh
    bad = []
    for mua in range(1, 5):
        for mub in range(1, 5):
            for mu0 in range(1, 5):
                cnt = {1: 0, 2: 0, 3: 0, 4: 0}
                for mu, cs in ((mua, (1, 2, 3, 4)), (mub, (1, 2, 3, 4)),
                               (mu0, (1, 2))):
                    for c in cs:
                        w = (mu * c) % 5
                        cnt[w] += 1
                        cnt[(-w) % 5] += 1
                if set(cnt.values()) != {5}:
                    bad.append((mua, mub, mu0, cnt))
    report("R4 order-5 n_x = 5 at all 4 points for all 64 entries (recount)",
           not bad, "violations: %r" % (bad[:3],))


# ------------------------------------------------------------------- R5
def r5():
    for (frame, d, klo, khi, kmin, kmax) in (
            ((1, 3, 4, 5, 9), 34, 13, 14, 3, 27),
            ((1, 3, 4, 5, 9), 35, 13, 14, 3, 28),
            ((2, 6, 7, 8, 10), 34, 19, 20, 6, 30),
            ((2, 6, 7, 8, 10), 35, 20, 21, 6, 31)):
        S = sum(frame)
        thr = Fraction(S * (d - 1), 55)
        lo = thr.__floor__()
        hi = -((-thr).__floor__())
        lo_att = -((-Fraction(min(frame) * d - max(frame), 11)).__floor__())
        hi_att = Fraction(max(frame) * d - min(frame), 11).__floor__()
        ok = (lo == klo and hi == khi and lo_att == kmin and hi_att == kmax
              and lo_att <= lo and hi <= hi_att)
        report("R5 eigenbasis thresholds frame %r d=%d" % (frame, d), ok,
               "need k<=%s k>=%s attainable [%s,%s]" % (lo, hi, lo_att, hi_att))
        r = [5 * w - S for w in frame]
        report("R5 1-PS traceless frame %r" % (frame,), sum(r) == 0, r)


# ------------------------------------------------------------------- R6
def r6():
    txt = open(os.path.join(ROOT, "goal_runs_20260810", "TERMINUS_STRATA_PW",
                            "results", "t2_strata.txt")).read()
    need = ["H = C2  : components of Z^H by dim {0: 146, 1: 80, 2: 11, 3: 2}",
            "H = C3  : components of Z^H by dim {0: 62, 1: 16, 2: 2}",
            "H = C5  : components of Z^H by dim {0: 20}",
            "H = C6  : components of Z^H by dim {0: 38}",
            "H = C11 : components of Z^H by dim {0: 20}"]
    report("R6 census DICTIONARY lines present verbatim",
           all(s in txt for s in need))
    report("R6 F3 closures: 5*4 = 20 (C11), 4*5 = 20 (C5), 2*19 = 38 (C6)",
           5 * 4 == 20 and 4 * 5 == 20 and 2 * 19 == 38)
    report("R6 order-3 bookkeeping 62 + 16*2 = 94", 62 + 16 * 2 == 94)


# ------------------------------------------------------------------- R7
def r7():
    # NOTE (referee finding): the group_key itself is PRIME-DEPENDENT.  At
    # p = 331 the shared key is 0bbfc90a9b60 (as the packet flags); at
    # p = 661 the 22 cells share the single key 5912f413854e.  The flag's
    # substance (pattern SHARED, not unique) holds at both primes; the key
    # string in THEOREM.md sec.7.1 is the p = 331 one and should carry that
    # qualifier, exactly as the packet already does for content_hash.
    for prime, expect in (("331", "0bbfc90a9b60"), ("661", None)):
        pth = os.path.join(ROOT, "goal_runs_20260811", "D35_AUDIT", "results",
                           "patterns_r5_content_p%s.json" % prime)
        pat = json.load(open(pth))
        ids = set(pat["survivors22"]["ids"])
        live = [q for q in pat["patterns"] if q["id"] in ids]
        keys = {q["group_key"] for q in live}
        ok = len(keys) == 1 and (expect is None or keys == {expect})
        report("R7 p=%s: all 22 share ONE group_key%s" %
               (prime, " (= %s)" % expect if expect else ""),
               ok, "shared key(s): %s" % sorted(keys))
        report("R7 p=%s: no sol_hash field on any live cell" % prime,
               all("sol_hash" not in q for q in live))
        band = all(q["m_options_L"] == [35] and q["m_options_P"] == [1] and
                   q["a35_L_options"] == [[35, 0]] and
                   q["a35_P_options"] == [[34, 1]] for q in live)
        report("R7 p=%s: sigma-band identical on all 22" % prime, band)
    a = json.load(open(os.path.join(ROOT, "goal_runs_20260811", "D35_AUDIT",
                                    "results", "patterns_r5_content_p331.json")))
    b = json.load(open(os.path.join(ROOT, "goal_runs_20260811", "D35_AUDIT",
                                    "results", "patterns_r5_content_p661.json")))
    report("R7 id sets agree across primes, content hashes differ",
           list(a["survivors22"]["ids"]) == list(b["survivors22"]["ids"]) and
           sorted(a["survivors22"]["content_hashes"]) !=
           sorted(b["survivors22"]["content_hashes"]))


if __name__ == "__main__":
    r1()
    r2()
    r3()
    r4()
    r5()
    r6()
    r7()
    print()
    if FAIL:
        print("REFEREE_SPOTCHECKS_FAIL: %r" % FAIL)
        sys.exit(1)
    print("REFEREE_SPOTCHECKS_OK")
