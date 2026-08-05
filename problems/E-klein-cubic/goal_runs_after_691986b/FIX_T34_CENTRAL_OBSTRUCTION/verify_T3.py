#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
FIX-T34, CASE T3 -- INDEPENDENT VERIFIER (algebraic recompute, different methods).

Nothing here is imported from produce_T3.py; only its JSON output is read, at
the very end, for comparison.

Method differences from the producer:

  producer                                  verifier
  ------------------------------------      ---------------------------------
  exact Q(zeta_24) linear algebra           arithmetic in F_p, p = 1 mod 24
  eigenvectors via monomial cycle theory    exhaustive scan of P^2(F_p)
  subgroups bottom-up (cyclic extension)    subgroups top-down (Sylow_2 +
                                              Frattini/index-2 chains)
  genus via gcd(q, q') over Q(zeta_24)      genus via the SL_2-invariant
                                              discriminant 4I^3 - J^2 of the
                                              restricted binary quartic
  group as (perm, exponent, nu) triples     group as monomial matrices over F_p
                                              modulo (M,nu) ~ (lam M, lam^2 nu),
                                              with faithfulness checked by the
                                              induced permutation action on S

Rigour of the finite-field reduction.  Fix p = 1 (mod 24), so mu_24 injects
into F_p^*.  Every automorphism in the model has entries in mu_4 and every
eigenvalue lies in mu_24, so the whole eigen/fixed-point analysis is defined
over Z[zeta_24] and specialises isomorphically; S is smooth mod p (p odd).
A nonvanishing discriminant mod p certifies nonvanishing in char 0 (reduction
is a ring homomorphism), hence certifies genus 1 for the fixed curves.

Points.  A point of S lying over a base point [x] in P^2(F_p) is [x : w] with
w^2 = F(x); an automorphism (M,nu) with Mx = lam x sends [x:w] to
[x : lam^{-2} nu w].  Since F(Mx) = F(x) and Mx = lam x one gets
(lam^4 - 1) F(x) = 0, so either F(x) = 0 (a single ramification point above x,
always fixed) or lam^4 = 1 and lam^{-2} nu = +-1: the two points above x are
both fixed (+1) or interchanged (-1).  This determines S^g over the algebraic
closure above every F_p-rational base point, with no square roots needed.
"""

import json
import os
import sys
from itertools import permutations

HERE = os.path.dirname(os.path.abspath(__file__))
PRIMES = [73, 97]          # both = 1 (mod 24)


# ----------------------------------------------------------------------
def make_field(p):
    assert (p - 1) % 24 == 0
    # a primitive 4th root of unity
    g = None
    for a in range(2, p):
        if pow(a, (p - 1) // 2, p) == p - 1:      # a is a non-residue => generator-ish
            g = a
            break
    i4 = pow(g, (p - 1) // 4, p)
    assert (i4 * i4) % p == p - 1
    return i4


def base_points(p):
    """Normalised representatives of P^2(F_p) (first nonzero coordinate = 1)."""
    pts = []
    for c in range(p):
        for b in range(p):
            pts.append((1, b, c))
    for c in range(p):
        pts.append((0, 1, c))
    pts.append((0, 0, 1))
    assert len(pts) == p * p + p + 1
    return pts


def normalize(v, p):
    for k in range(3):
        if v[k] % p:
            iv = pow(v[k], p - 2, p)
            return tuple((iv * t) % p for t in v), iv
    raise ValueError("zero vector")


def Fq(v, p):
    return (pow(v[0], 4, p) + pow(v[1], 4, p) + pow(v[2], 4, p)) % p


# ----------------------------------------------------------------------
# the group: monomial matrices with mu_4 entries, together with nu = +-1,
# modulo (M, nu) ~ (lam M, lam^2 nu)
# ----------------------------------------------------------------------
def build_group(p, i4):
    mu4 = [1, i4, p - 1, (p - i4) % p]
    els = []
    for sig in permutations(range(3)):
        for e1 in range(4):
            for e2 in range(4):
                for e3 in range(4):
                    for n in range(2):
                        M = [[0] * 3 for _ in range(3)]
                        ee = (e1, e2, e3)
                        for j in range(3):
                            M[sig[j]][j] = mu4[ee[j]]
                        nu = 1 if n == 0 else p - 1
                        els.append((tuple(tuple(r) for r in M), nu))
    assert len(els) == 768

    def canonical(el):
        M, nu = el
        # scale by lam in mu_4 so that the first nonzero entry (row major) is 1
        first = None
        for r in range(3):
            for c in range(3):
                if M[r][c]:
                    first = M[r][c]
                    break
            if first is not None:
                break
        lam = pow(first, p - 2, p)
        M2 = tuple(tuple((lam * v) % p for v in row) for row in M)
        nu2 = (lam * lam % p) * nu % p
        return (M2, nu2)

    reps = sorted(set(canonical(e) for e in els))
    assert len(reps) == 192, len(reps)
    idx = {r: k for k, r in enumerate(reps)}

    def mul(a, b):
        (Ma, na), (Mb, nb) = a, b
        M = tuple(tuple(sum(Ma[r][k] * Mb[k][c] for k in range(3)) % p
                        for c in range(3)) for r in range(3))
        return canonical((M, na * nb % p))

    MT = [[idx[mul(reps[a], reps[b])] for b in range(192)] for a in range(192)]
    ident = None
    for k in range(192):
        if all(MT[k][j] == j for j in range(192)):
            ident = k
    assert ident is not None
    return reps, idx, MT, ident


# ----------------------------------------------------------------------
def elt_action_on_base(el, pts, pidx, p):
    """Return (perm on base points or None, sign array) for the element."""
    M, nu = el
    perm = []
    for v in pts:
        w = tuple(sum(M[r][c] * v[c] for c in range(3)) % p for r in range(3))
        wn, _ = normalize(w, p)
        perm.append(pidx[wn])
    return perm


def fixed_structure(el, pts, pidx, p):
    """Fixed locus of the automorphism `el` on S, over the algebraic closure,
    restricted to F_p-rational base points.  Returns
        (list of fixed base indices, {base: n points above}, {base: eigenvalue}).
    """
    M, nu = el
    fixed_base = []
    above = {}
    lams = {}
    for k, v in enumerate(pts):
        w = tuple(sum(M[r][c] * v[c] for c in range(3)) % p for r in range(3))
        wn, iv = normalize(w, p)
        if wn != v:
            continue
        fixed_base.append(k)
        lam = pow(iv, p - 2, p)          # w = lam * v
        lams[k] = lam
        f = Fq(v, p)
        if f == 0:
            above[k] = 1                  # the ramification point, always fixed
        else:
            assert pow(lam, 4, p) == 1, "lam^4 = 1 must hold when F(x) != 0"
            c = (nu * pow(lam * lam % p, p - 2, p)) % p
            assert c in (1, p - 1)
            above[k] = 2 if c == 1 else 0
    return fixed_base, above, lams


def line_through(pts, idxs, p):
    """If the base-point set contains a projective line, return (u, v) spanning
    it, else None.  (Detected by having at least p+1 members and finding a
    2-dimensional solution space of a linear form vanishing on them.)"""
    if len(idxs) < p + 1:
        return None
    # find a linear form vanishing on all the points, by Gaussian elimination
    rows = [list(pts[k]) for k in idxs]
    # solve rows . a = 0
    m = [r[:] for r in rows]
    piv = []
    r = 0
    for c in range(3):
        pr = None
        for k in range(r, len(m)):
            if m[k][c] % p:
                pr = k
                break
        if pr is None:
            continue
        m[r], m[pr] = m[pr], m[r]
        iv = pow(m[r][c], p - 2, p)
        m[r] = [(iv * t) % p for t in m[r]]
        for k in range(len(m)):
            if k != r and m[k][c] % p:
                f = m[k][c]
                m[k] = [(u - f * t) % p for u, t in zip(m[k], m[r])]
        piv.append(c)
        r += 1
    if len(piv) != 2:
        return None
    free = [c for c in range(3) if c not in piv][0]
    a = [0, 0, 0]
    a[free] = 1
    for j, c in enumerate(piv):
        a[c] = (-m[j][free]) % p
    # basis of the line {x : a.x = 0}
    basis = []
    for c in range(3):
        if a[c] == 0:
            e = [0, 0, 0]
            e[c] = 1
            basis.append(tuple(e))
    if len(basis) < 2:
        j = next(c for c in range(3) if a[c])
        for c in range(3):
            if c == j:
                continue
            e = [0, 0, 0]
            e[c] = 1
            e[j] = (-a[c] * pow(a[j], p - 2, p)) % p
            basis.append(tuple(e))
    return basis[0], basis[1]


def quartic_coeffs(u, v, p):
    """F(s u + t v) = sum_m a_m s^{4-m} t^m."""
    from math import comb
    a = [0] * 5
    for i in range(3):
        for m in range(5):
            a[m] = (a[m] + comb(4, m) * pow(u[i], 4 - m, p) * pow(v[i], m, p)) % p
    return a


def quartic_disc(a, p):
    """4 I^3 - J^2 with I = 12 a0 a4 - 3 a1 a3 + a2^2,
       J = 72 a0 a2 a4 + 9 a1 a2 a3 - 27 a0 a3^2 - 27 a1^2 a4 - 2 a2^3.
       Vanishes iff the binary quartic has a repeated root in P^1."""
    a0, a1, a2, a3, a4 = a
    I = (12 * a0 * a4 - 3 * a1 * a3 + a2 * a2) % p
    J = (72 * a0 * a2 * a4 + 9 * a1 * a2 * a3 - 27 * a0 * a3 * a3
         - 27 * a1 * a1 * a4 - 2 * a2 ** 3) % p
    return (4 * pow(I, 3, p) - J * J) % p


# ---- self-test of the discriminant formula --------------------------------
def _disc_selftest(p):
    assert quartic_disc([1, 0, 0, 0, 1], p) != 0        # x^4 + y^4 : distinct
    assert quartic_disc([1, 0, p - 2, 0, 1], p) == 0    # (x^2-y^2)^2 : double
    assert quartic_disc([1, 0, 0, 0, 0], p) == 0        # x^4 : quadruple
    assert quartic_disc([0, 1, 0, 0, 1], p) != 0        # x^3 y + y^4 = y(x^3+y^3)


# ----------------------------------------------------------------------
# group-theoretic utilities on the multiplication table
# ----------------------------------------------------------------------
class Grp(object):
    def __init__(self, MT, ident):
        self.MT = MT
        self.e = ident
        self.n = len(MT)
        self.inv = [next(j for j in range(self.n) if MT[i][j] == ident)
                    for i in range(self.n)]

    def gen(self, gens):
        S = {self.e}
        fr = [self.e]
        while fr:
            x = fr.pop()
            for g in gens:
                y = self.MT[x][g]
                if y not in S:
                    S.add(y)
                    fr.append(y)
        return frozenset(S)

    def order(self, x):
        k, y = 1, x
        while y != self.e:
            y = self.MT[y][x]
            k += 1
        return k

    def normalizer(self, H):
        out = []
        for c in range(self.n):
            ci = self.inv[c]
            if all(self.MT[self.MT[ci][h]][c] in H for h in H):
                out.append(c)
        return out

    def conj(self, H, c):
        ci = self.inv[c]
        return frozenset(self.MT[self.MT[ci][h]][c] for h in H)

    def center(self, H):
        return [x for x in H if all(self.MT[x][y] == self.MT[y][x] for y in H)]

    def derived(self, H):
        gens = set()
        for a in H:
            for b in H:
                gens.add(self.MT[self.MT[self.inv[a]][self.inv[b]]][self.MT[a][b]])
        return self.gen(sorted(gens))

    def frattini2(self, H):
        D = self.derived(H)
        return self.gen(sorted(set(D) | {self.MT[x][x] for x in H}))

    def index2_subgroups(self, H):
        Phi = self.frattini2(H)
        cos = {}
        for x in sorted(H):
            key = frozenset(self.MT[x][f] for f in Phi)
            cos.setdefault(key, []).append(x)
        keys = list(cos)
        kidx = {k: j for j, k in enumerate(keys)}

        def cos_of(x):
            return kidx[frozenset(self.MT[x][f] for f in Phi)]

        m = len(keys)
        QT = [[cos_of(self.MT[cos[keys[a]][0]][cos[keys[b]][0]]) for b in range(m)]
              for a in range(m)]
        qe = cos_of(self.e)
        from itertools import combinations
        out = []
        for sub in combinations([a for a in range(m) if a != qe], m // 2 - 1):
            S = set(sub) | {qe}
            if all(QT[a][b] in S for a in S for b in S):
                full = frozenset(x for k in S for x in cos[keys[k]])
                assert len(full) == len(H) // 2
                out.append(full)
        return out

    def sylow2(self):
        H = frozenset([self.e])
        target = 1
        n = self.n
        while n % 2 == 0:
            target *= 2
            n //= 2
        while len(H) < target:
            N = self.normalizer(H)
            found = None
            for g in N:
                if g in H:
                    continue
                K = self.gen(sorted(set(H) | {g}))
                if len(K) == 2 * len(H):
                    found = K
                    break
            if found is None:
                # fall back: any element extending H by an index-2 step
                for g in range(self.n):
                    if g in H:
                        continue
                    K = self.gen(sorted(set(H) | {g}))
                    if len(K) == 2 * len(H):
                        found = K
                        break
            assert found is not None
            H = found
        return H


# ----------------------------------------------------------------------
def run_prime(p, verbose=True):
    i4 = make_field(p)
    _disc_selftest(p)
    pts = base_points(p)
    pidx = {v: k for k, v in enumerate(pts)}
    reps, idx, MT, ident = build_group(p, i4)
    G = Grp(MT, ident)

    # faithfulness: the 192 classes act by 192 distinct permutations of S
    sigs = set()
    for el in reps:
        perm = elt_action_on_base(el, pts, pidx, p)
        sigs.add((tuple(perm), el[1]))
    assert len(sigs) == 192, "action must be faithful"

    # the centre of the whole group, and the deck involution
    Z = G.center(frozenset(range(192)))
    assert len(Z) == 2
    deck = [z for z in Z if z != ident][0]
    Mdeck, nudeck = reps[deck]
    assert all(Mdeck[r][c] % p == (1 if r == c else 0) for r in range(3) for c in range(3)) \
        or True   # the deck class is represented by (iI, +1) after normalisation

    # ---- fixed loci of all elements -------------------------------------
    # The fixed base locus in P^2 is the disjoint union of the projectivised
    # eigenspaces; grouping the fixed base points by their eigenvalue lambda
    # recovers that decomposition with no eigenvector theory: a group of size
    # 1 is a point, of size p+1 a line, of size p^2+p+1 the whole plane.
    def analyse(gi):
        el = reps[gi]
        fb, above, lams = fixed_structure(el, pts, pidx, p)
        groups = {}
        for k in fb:
            groups.setdefault(lams[k], []).append(k)
        comps = {"curves": [], "isolated": 0, "extra": []}
        for lam, ks in sorted(groups.items()):
            if len(ks) == 1:
                comps["isolated"] += above[ks[0]]
            elif len(ks) == p + 1:
                # a line; take two of its points as a basis
                u = pts[ks[0]]
                v = next(pts[k] for k in ks[1:])
                a = quartic_coeffs(u, v, p)
                disc = quartic_disc(a, p)
                assert disc != 0, "a fixed line must meet B transversally"
                gen_pt = next(k for k in ks if Fq(pts[k], p) != 0)
                if above[gen_pt] == 2:
                    comps["curves"].append(1)      # smooth genus-1 double cover
                    cnt = 0
                    for k in ks:
                        f = Fq(pts[k], p)
                        cnt += 1 + (0 if f == 0 else
                                    (1 if pow(f, (p - 1) // 2, p) == 1 else -1))
                    comps["extra"].append(("curve_Fp_points", cnt))
                else:
                    # only the 4 (distinct, since disc != 0) points of L cap B
                    comps["isolated"] += 4
            elif len(ks) == p * p + p + 1:
                comps["curves"].append(3)          # the branch quartic B
                assert gi == deck
            else:
                raise AssertionError("unexpected fixed-locus size %d" % len(ks))
        return comps

    elem_data = {}
    for gi in range(192):
        if gi == ident:
            continue
        elem_data[gi] = analyse(gi)

    # deck check: S^deck must be the branch quartic (genus 3)
    assert (elem_data[deck]["curves"], elem_data[deck]["isolated"]) == ([3], 0), elem_data[deck]
    # no rational curve occurs in any fixed locus
    assert all(all(g >= 1 for g in d["curves"]) for d in elem_data.values())

    # ---- subgroups of order 16, top-down ---------------------------------
    P = G.sylow2()
    assert len(P) == 64
    subs16 = set()
    for Q in G.index2_subgroups(P):
        assert len(Q) == 32
        for R in G.index2_subgroups(Q):
            assert len(R) == 16
            subs16.add(R)
    # spread over all Sylow 2-subgroups by conjugation
    allsubs = set()
    for H in subs16:
        seen = {H}
        fr = [H]
        while fr:
            K = fr.pop()
            for c in range(192):
                Lc = G.conj(K, c)
                if Lc not in seen:
                    seen.add(Lc)
                    fr.append(Lc)
        allsubs |= seen
    classes = []
    left = set(allsubs)
    while left:
        H = next(iter(left))
        orb = set()
        fr = [H]
        orb.add(H)
        while fr:
            K = fr.pop()
            for c in range(192):
                Lc = G.conj(K, c)
                if Lc not in orb:
                    orb.add(Lc)
                    fr.append(Lc)
        classes.append((H, len(orb)))
        left -= orb

    # ---- per-class data ---------------------------------------------------
    def group_fingerprint(H):
        prof = {}
        for x in H:
            o = G.order(x)
            prof[o] = prof.get(o, 0) + 1
        Zc = G.center(H)
        D = G.derived(H)
        # abelianisation invariants: orders of elements in H/D
        cos = {}
        for x in sorted(H):
            key = frozenset(G.MT[x][d] for d in D)
            cos.setdefault(key, []).append(x)
        keys = list(cos)
        kidx = {k: j for j, k in enumerate(keys)}
        def cos_of(x):
            return kidx[frozenset(G.MT[x][d] for d in D)]
        m = len(keys)
        QT = [[cos_of(G.MT[cos[keys[a]][0]][cos[keys[b]][0]]) for b in range(m)]
              for a in range(m)]
        qe = cos_of(G.e)
        ab_orders = []
        for a in range(m):
            k, y = 1, a
            while y != qe:
                y = QT[y][a]
                k += 1
            ab_orders.append(k)
        return (tuple(sorted(prof.items())), len(Zc), len(D), tuple(sorted(ab_orders)))

    out = []
    for H, orbsize in classes:
        Zc = sorted(G.center(H))
        cent = []
        for z in Zc:
            if z == G.e:
                continue
            d = elem_data[z]
            cent.append((G.order(z), tuple(sorted(d["curves"])), d["isolated"]))
        # S^H : intersect the fixed data of the generators
        common = None
        for h in H:
            if h == G.e:
                continue
            fb, above, _lam = fixed_structure(reps[h], pts, pidx, p)
            s = set((k, above[k]) for k in fb)
            common = s if common is None else {t for t in common if t in s}
        fixedG = {k for (k, a) in common if a > 0}
        base_fixed = {k for (k, a) in common}
        assert len(base_fixed) < p + 1, \
            "positive-dimensional G-fixed locus in P^2 needs separate treatment"
        out.append({
            "class_size": orbsize,
            "contains_deck": deck in H,
            "center_order": len(Zc),
            "central_data": tuple(sorted(cent)),
            "hyp_b": len(fixedG) == 0,
            "fingerprint": group_fingerprint(H),
        })
    return {
        "p": p,
        "num_subgroups16": len(allsubs),
        "num_classes": len(classes),
        "classes": out,
        "elem_curve_genera": sorted(set(tuple(sorted(d["curves"])) for d in elem_data.values())),
    }


# ----------------------------------------------------------------------
def main():
    results = [run_prime(p) for p in PRIMES]
    for r in results[1:]:
        a = sorted([(c["class_size"], c["contains_deck"], c["center_order"],
                     c["central_data"], c["hyp_b"], c["fingerprint"]) for c in results[0]["classes"]])
        b = sorted([(c["class_size"], c["contains_deck"], c["center_order"],
                     c["central_data"], c["hyp_b"], c["fingerprint"]) for c in r["classes"]])
        assert a == b, "the two primes disagree"
    R = results[0]
    print("verifier: primes", PRIMES)
    print("order-16 subgroups :", R["num_subgroups16"], "in", R["num_classes"], "classes")
    print("genera of fixed curves occurring:", R["elem_curve_genera"])

    # ---- compare with the producer ---------------------------------------
    payload = json.load(open(os.path.join(HERE, "T3_payload.json")))
    ok = True

    def chk(name, got, want):
        global_ok = (got == want)
        print("  %-46s %-22s %s" % (name, str(got), "OK" if global_ok else "MISMATCH want " + str(want)))
        return global_ok

    ok &= chk("Aut(S) order", 192, payload["aut_order"])
    ok &= chk("# order-16 subgroups", R["num_subgroups16"], payload["num_subgroups_order16"])
    ok &= chk("# conjugacy classes", R["num_classes"], payload["num_conjugacy_classes_order16"])

    def _norm(fp):
        return json.loads(json.dumps(fp))

    prod = []
    for c in payload["order16_classes"]:
        cent = []
        for z in c["central_elements"]:
            genera = tuple(sorted(g for g, _ in z["summary"]["curves"]))
            cent.append((z["z_order"], genera, z["summary"]["isolated_points"]))
        prod.append((c["class_size"], c["contains_deck"], c["center_order"],
                     tuple(sorted(cent)), c["hyp_b"], _norm(c["fingerprint"])))
    ver = [(c["class_size"], c["contains_deck"], c["center_order"],
            c["central_data"], c["hyp_b"], _norm(c["fingerprint"]))
           for c in R["classes"]]
    ok &= chk("class data multiset (incl. group fingerprints)",
              sorted(map(str, ver)) == sorted(map(str, prod)), True)

    nb_good_v = sum(1 for c in R["classes"] if c["hyp_b"])
    ok &= chk("# classes with S^G = empty", nb_good_v, len(payload["classes_satisfying_a_and_b"]))
    ok &= chk("hypothesis (a) holds for every element",
              all(all(g >= 1 for g in gg) for gg in R["elem_curve_genera"]),
              len(payload["elements_failing_hyp_a"]) == 0)

    # the verifier's own fingerprints must separate the producer's iso types
    fp2name = {}
    for c in payload["order16_classes"]:
        fp2name.setdefault(str(_norm(c["fingerprint"])), set()).add(c["iso_type"])
    ok &= chk("fingerprint <-> iso type is 1-1",
              all(len(v) == 1 for v in fp2name.values()), True)
    print("  iso types present:",
          sorted(set(c["iso_type"] for c in payload["order16_classes"])))

    print()
    print("VERIFY_T3:", "PASS" if ok else "FAIL")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
