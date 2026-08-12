#!/usr/bin/env python3
"""
REFEREE spot-check R5 (geometry layer) -- independent replay of the 19
certified covering-family witnesses, and of the census rebuild they stand on.

Own linear algebra and own arrangement build (only the 660 matrices come
from the shared raw model psl211.py):

  W1  the arrangement of eigen-subspaces of the non-trivial elements of G,
      closed under intersection, has exactly 940 points / 220 lines / 55
      planes in 14 G-orbits, orbit_size x |setwise stab| = 660 for all 14
      (independent re-derivation of verifier group C);
  W2  every one of the 19 stored witness lines (per prime) passes through
      its stored general point z, lies in no arrangement member, and its
      incidence vector -- recomputed with an independent implementation of
      Lemma E3-T's V_min rule -- equals the stored one (labels compared
      with the (a)/(b) tags collapsed: the two C5, two C6 and two A4
      orbits are intrinsically unordered; nothing downstream distinguishes
      them);
  W3  z is really general: z lies on no arrangement member;
  W4  negative-control corroboration: a COVERING family must put a clean
      witness through EVERY general z.  For sampled tuples of 4 plus-planes
      (resp. two line-centres) and 3 sampled general z, no tuple covers all
      3 z's.  Two kinds of sporadic single-z hits are expected and are NOT
      counterexamples: (i) tuple members meeting each other -- the line
      through the shared point exists for every z but its Lemma-E3-T
      incidence collapses to the deeper stratum (packet section 5.3's
      "sporadic hits"); (ii) z landing on the transversal locus of the
      tuple (e.g. the 3-fold scroll of transversals of two skew lines) --
      a clean witness exists at that special z, but the locus is proper,
      so such a tuple still fails at the other z's.  The check therefore
      asserts per-tuple coverage < 3/3, mirroring the packet's own
      12-point covering criterion.

Default: full replay at p = 331 and p = 661 (a few minutes).
"""

import itertools
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, "scripts"))

from psl211 import Model, SPLIT_PRIMES

FAILS = []


def chk(name, ok, detail=""):
    print("[%s] %s %s" % ("PASS" if ok else "FAIL", name, detail))
    if not ok:
        FAILS.append(name)


# ------------------------- own linear algebra ------------------------------

class Lin:
    def __init__(self, p):
        self.p = p

    def rref(self, rows):
        p = self.p
        M = [list(r) for r in rows]
        r = 0
        for c in range(5):
            piv = next((i for i in range(r, len(M)) if M[i][c] % p), None)
            if piv is None:
                continue
            M[r], M[piv] = M[piv], M[r]
            iv = pow(M[r][c], p - 2, p)
            M[r] = [x * iv % p for x in M[r]]
            for i in range(len(M)):
                if i != r and M[i][c] % p:
                    f = M[i][c]
                    M[i] = [(x - f * y) % p for x, y in zip(M[i], M[r])]
            r += 1
        return tuple(tuple(row) for row in M[:r])

    def rank(self, rows):
        return len(self.rref(rows))

    def nullspace(self, rows):
        p = self.p
        R = self.rref(rows)
        piv = []
        for row in R:
            piv.append(next(c for c in range(5) if row[c]))
        free = [c for c in range(5) if c not in piv]
        out = []
        for f in free:
            v = [0] * 5
            v[f] = 1
            for i, c in enumerate(piv):
                v[c] = (-R[i][f]) % p
            out.append(v)
        return self.rref(out) if out else ()

    def inter(self, U, V):
        """U cap V via double perp."""
        if not U or not V:
            return ()
        pu = self.nullspace([list(x) for x in U])
        pv = self.nullspace([list(x) for x in V])
        return self.nullspace([list(x) for x in pu] + [list(x) for x in pv])

    def meet_dim(self, U, V):
        return len(U) + len(V) - self.rank([list(x) for x in U]
                                           + [list(x) for x in V])

    def contains(self, U, V):
        """V subseteq U ?"""
        return self.rank([list(x) for x in U] + [list(x) for x in V]) == len(U)


# ------------------------- arrangement build -------------------------------

def build_arrangement(m, L):
    p = m.p
    base = set()
    for A in m.G:
        n = m.order[A]
        if n == 1:
            continue
        # eigenvalues are n-th roots of unity mod p
        z = None
        for g in range(2, p):
            r = pow(g, (p - 1) // n, p)
            if r != 1:
                z = r
                break
        seen = set()
        for k in range(n):
            lam = pow(z, k, p)
            if lam in seen:
                continue
            seen.add(lam)
            rows = [[(A[i][j] - (lam if i == j else 0)) % p for j in range(5)]
                    for i in range(5)]
            U = L.nullspace(rows)
            if U and 1 <= len(U) <= 4:
                base.add(U)
    # close under intersection (points cannot create anything new)
    cur = set(base)
    gens = [U for U in base if len(U) >= 2]
    frontier = [U for U in cur if len(U) >= 2]
    while frontier:
        new = []
        for U in frontier:
            for V in gens:
                I = L.inter(U, V)
                if I and I not in cur:
                    cur.add(I)
                    if len(I) >= 2:
                        new.append(I)
        frontier = new
    return {U for U in cur if 1 <= len(U) <= 3}


def orbits_of(m, L, spaces):
    """G-orbits via a 2-element generating set."""
    gens = None
    for A in m.G[1:]:
        for B in m.G[1:]:
            if m.order[A] == 2 and m.order[B] == 11:
                # <invol, 11-element>: order divisible by 22 -> = 660
                S = {m.Id}
                fr = [m.Id]
                while fr:
                    nf = []
                    for X in fr:
                        for gmat in (A, B):
                            Y = m.mm(X, gmat)
                            if Y not in S:
                                S.add(Y)
                                nf.append(Y)
                    fr = nf
                if len(S) == 660:
                    gens = (A, B)
                    break
        if gens:
            break
    assert gens is not None
    remaining = set(spaces)
    orbs = []
    while remaining:
        U = next(iter(remaining))
        orb = {U}
        fr = [U]
        while fr:
            nf = []
            for V in fr:
                for gmat in gens:
                    Wv = L.rref([list(m.act(gmat, v)) for v in V])
                    if Wv not in orb:
                        orb.add(Wv)
                        nf.append(Wv)
            fr = nf
        orbs.append(sorted(orb))
        remaining -= set(orb)
    return orbs


def label_orbit(m, L, orb, planes_set):
    """Census label with (a)/(b) collapsed; intrinsic data only."""
    rep = orb[0]
    d = len(rep) - 1
    n = len(orb)
    if d == 2:
        return "P_sigma"
    if d == 1:
        if n == 110:
            return "C3line"
        inside = any(L.contains(Q, rep) for Q in planes_set)
        return "ell_V" if inside else "Lminus_sigma"
    stab = [A for A in m.G
            if L.rref([list(m.act(A, v)) for v in rep]) == rep]
    so = len(stab)
    if so == 11:
        return "pt_C11"
    if so == 10:
        return "pt_D10"
    if so == 4:
        return "pt_V4I"
    if so == 5:
        return "pt_C5"
    if so == 6:
        return "pt_C6"
    if so == 12:
        ninv = sum(1 for A in stab if m.order[A] == 2)
        return "pt_A4" if ninv == 3 else "pt_D12"
    return "?%d" % so


def collapse(lab):
    return lab.replace("(a)", "").replace("(b)", "")


def main():
    D = json.load(open(os.path.join(HERE, "results", "e_ledger.json")))
    for p in SPLIT_PRIMES:
        if str(p) not in D["e3_by_prime"]:
            continue
        m = Model(p)
        L = Lin(p)
        spaces = build_arrangement(m, L)
        pts = [U for U in spaces if len(U) == 1]
        lns = [U for U in spaces if len(U) == 2]
        pls = [U for U in spaces if len(U) == 3]
        chk("W1_p%d_940_220_55" % p,
            (len(pts), len(lns), len(pls)) == (940, 220, 55),
            (len(pts), len(lns), len(pls)))
        orbs = orbits_of(m, L, spaces)
        chk("W1_p%d_14_orbits" % p, len(orbs) == 14, len(orbs))
        sizes = sorted(len(o) for o in orbs)
        chk("W1_p%d_orbit_size_multiset" % p,
            sizes == sorted([60, 66, 55, 55, 165, 132, 132, 110, 110, 55,
                             110, 55, 55, 55]), sizes)
        planes_set = set(pls)
        member_label = {}
        stab_ok = True
        for o in orbs:
            lab = label_orbit(m, L, o, planes_set)
            # orbit size x |setwise stab| = 660, via the rep's stabiliser
            rep = o[0]
            so = sum(1 for A in m.G
                     if L.rref([list(m.act(A, v)) for v in rep]) == rep)
            stab_ok = stab_ok and (so * len(o) == 660)
            for U in o:
                member_label[U] = lab
        chk("W1_p%d_orbit_size_times_stab_660_all_14" % p, stab_ok)

        # ---------------- W2/W3: the 19 witnesses ------------------------
        cert = D["e3_by_prime"][str(p)]
        packet_labels = cert["labels"]
        members = sorted(spaces, key=len)
        n_ok = 0
        for f in cert["certified"]:
            if f["status"] != "CERTIFIED":
                continue
            name = f["name"]
            Lw = L.rref([list(r) for r in f["line"]])
            z = list(f["z"])
            ok = len(Lw) == 2
            ok = ok and L.rank([list(r) for r in Lw] + [z]) == 2  # z on line
            ok = ok and not any(L.contains(U, [z]) for U in spaces)  # z general
            # incidence via own V_min rule
            hits = {}
            contained = False
            for U in members:
                dd = L.meet_dim(Lw, U)
                if dd >= 2:
                    contained = True
                    break
                if dd == 1:
                    I = L.inter(Lw, U)
                    hits.setdefault(I, []).append(U)
            ok = ok and not contained
            got = {}
            if not contained:
                for pt_, lst in hits.items():
                    vmin = None
                    for U in lst:
                        if all(L.contains(V, U) for V in lst):
                            vmin = U
                            break
                    if vmin is None:
                        ok = False
                        break
                    lab = member_label[vmin]
                    got[lab] = got.get(lab, 0) + 1
            want = {}
            for k, v in f["incidence"].items():
                lab = collapse(packet_labels[k])
                want[lab] = want.get(lab, 0) + v
            ok = ok and got == want
            if ok:
                n_ok += 1
            else:
                chk("W2_p%d_%s" % (p, name), False,
                    "got %r want %r" % (got, want))
        chk("W2_p%d_all_19_witnesses_reverified" % p, n_ok == 19, n_ok)

        # ---------------- W4: negative controls --------------------------
        import random
        rng = random.Random(20260812)
        zs = []
        while len(zs) < 3:
            z = [rng.randrange(p) for _ in range(5)]
            if any(z) and not any(L.contains(U, [z]) for U in spaces):
                zs.append(z)

        def clean_target_realised(z, cap, target):
            """
            Does some line through z with direction in `cap` realise the
            clean incidence `target` (a dict label -> count) under the
            V_min rule?  Scans P(cap): every line through z inside cap is
            spanned by z and one direction from a small spanning sweep.
            When dim cap = 2 the line is unique (= cap itself).
            """
            dirs = [list(v) for v in cap]
            for i in range(len(cap)):
                for j in range(i + 1, len(cap)):
                    for t in (1, 2, 3, 5):
                        dirs.append([(cap[i][k] + t * cap[j][k]) % p
                                     for k in range(5)])
            seen = set()
            for w in dirs:
                Lw = L.rref([list(z), w])
                if len(Lw) != 2 or Lw in seen:
                    continue
                seen.add(Lw)
                got = {}
                bad = False
                hits = {}
                for U in members:
                    dd = L.meet_dim(Lw, U)
                    if dd >= 2:
                        bad = True
                        break
                    if dd == 1:
                        I = L.inter(Lw, U)
                        hits.setdefault(I, []).append(U)
                if bad:
                    continue
                for pt_, lst in hits.items():
                    vmin = next((U for U in lst
                                 if all(L.contains(V, U) for V in lst)), None)
                    if vmin is None:
                        bad = True
                        break
                    lab = member_label[vmin]
                    got[lab] = got.get(lab, 0) + 1
                if not bad and got == target:
                    return True
            return False

        pls_l = sorted(planes_set)
        hits4 = collapsed4 = special4 = 0
        maxcov4 = 0
        for _ in range(25):
            Vs = rng.sample(pls_l, 4)
            cov = 0
            for z in zs:
                cap = None
                for V in Vs:
                    S = L.rref([list(v) for v in V] + [z])
                    cap = S if cap is None else L.inter(cap, S)
                if cap and len(cap) >= 2:
                    hits4 += 1
                    if clean_target_realised(z, cap, {"P_sigma": 4}):
                        special4 += 1
                        cov += 1
                    else:
                        collapsed4 += 1
            maxcov4 = max(maxcov4, cov)
        chk("W4_p%d_no_4_plane_tuple_covers_all_sampled_z" % p,
            maxcov4 < len(zs),
            "cap hits=%d (collapsed=%d, special-z clean=%d), max "
            "coverage=%d/%d" % (hits4, collapsed4, special4, maxcov4,
                                len(zs)))

        lns_l = sorted(U for U in spaces if len(U) == 2)
        hits2 = collapsed2 = special2 = 0
        maxcov2 = 0
        for _ in range(25):
            Va, Vb = rng.sample(lns_l, 2)
            la, lb = member_label[Va], member_label[Vb]
            tgt = {la: 2} if la == lb else {la: 1, lb: 1}
            cov = 0
            for z in zs:
                Sa = L.rref([list(v) for v in Va] + [z])
                Sb = L.rref([list(v) for v in Vb] + [z])
                I = L.inter(Sa, Sb)
                if I and len(I) >= 2:
                    hits2 += 1
                    if clean_target_realised(z, I, tgt):
                        special2 += 1     # z on the transversal scroll
                        cov += 1
                    else:
                        collapsed2 += 1   # lines meet; V_min collapse
            maxcov2 = max(maxcov2, cov)
        chk("W4_p%d_no_line_pair_covers_all_sampled_z" % p,
            maxcov2 < len(zs),
            "cap hits=%d (collapsed=%d, special-z clean=%d), max "
            "coverage=%d/%d" % (hits2, collapsed2, special2, maxcov2,
                                len(zs)))

    print()
    print("referee_e3_witness: %d failures" % len(FAILS))
    return 1 if FAILS else 0


if __name__ == "__main__":
    sys.exit(main())
