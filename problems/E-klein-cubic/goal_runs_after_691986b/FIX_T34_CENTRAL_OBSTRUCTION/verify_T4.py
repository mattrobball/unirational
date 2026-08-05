#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
FIX-T34, CASE T4 -- INDEPENDENT VERIFIER (algebraic recompute).

Nothing is imported from produce_T4.py; only its JSON output is read for the
final comparison.

  producer                                     verifier
  ----------------------------------------     --------------------------------
  exact Q(zeta_9) linear algebra               arithmetic in F_p, p = 1 mod 9
  eigenvectors from monomial cycle theory      exhaustive scan of P^4(F_p)
  subgroups bottom-up: order-9 elements +      subgroups top-down: a Sylow
    normalisers of <a>                           3-subgroup (order 243) and its
                                                 index-3 chains via the
                                                 Frattini quotient over F_3
  X^z read off the coordinate blocks of a      X^z computed pointwise, its
    diagonal z                                   components recovered by
                                                 grouping fixed points by
                                                 eigenvalue, genus from
                                                 smoothness + the plane-curve
                                                 genus formula, the 3 points on
                                                 the line certified by the
                                                 binary-cubic discriminant

Rigour of the reduction: p = 1 (mod 9) so mu_9 injects into F_p^*; all matrix
entries lie in mu_3 and all eigenvalues of elements of a C9:C3 in mu_9, so
every eigenspace is F_p-rational and the fixed-point analysis specialises
faithfully.  X is smooth mod p for p != 3.
"""

import json
import os
import sys
from itertools import permutations

HERE = os.path.dirname(os.path.abspath(__file__))
P = 19            # 19 = 1 mod 9
N = 5


def w3(p):
    for a in range(2, p):
        if pow(a, 3, p) == 1 and a != 1:
            return a
    raise RuntimeError


# ----------------------------------------------------------------------
# group: monomial matrices with mu_3 entries modulo scalars
# element = (sigma, c) with M[sigma(j)][j] = c[j], c[j] in mu_3
# ----------------------------------------------------------------------
def build(p):
    om = w3(p)
    mu3 = [1, om, om * om % p]

    def canon(el):
        s, c = el
        iv = pow(c[0], p - 2, p)
        return (s, tuple((iv * x) % p for x in c))

    els = []
    for s in permutations(range(N)):
        for i0 in range(3):
            for i1 in range(3):
                for i2 in range(3):
                    for i3 in range(3):
                        for i4 in range(3):
                            c = (mu3[i0], mu3[i1], mu3[i2], mu3[i3], mu3[i4])
                            els.append(canon((s, c)))
    els = sorted(set(els))
    assert len(els) == 9720, len(els)

    def mul(a, b):
        # (M_a M_b)[s_a(s_b(j))][j] = c_a[s_b(j)] * c_b[j]
        sa, ca = a
        sb, cb = b
        s = tuple(sa[sb[j]] for j in range(N))
        c = tuple((ca[sb[j]] * cb[j]) % p for j in range(N))
        return canon((s, c))

    def inv(a):
        s, c = a
        si = [0] * N
        for j in range(N):
            si[s[j]] = j
        si = tuple(si)
        ci = tuple(pow(c[si[j]], p - 2, p) for j in range(N))
        return canon((si, ci))

    ident = canon((tuple(range(N)), (1,) * N))
    return els, mul, inv, ident, om


def act(el, v, p):
    s, c = el
    out = [0] * N
    for j in range(N):
        out[s[j]] = (c[j] * v[j]) % p
    return tuple(out)


_INV = {}


def normalize(v, p):
    if not _INV:
        for a in range(1, p):
            _INV[a] = pow(a, p - 2, p)
    for k in range(N):
        if v[k] % p:
            iv = _INV[v[k] % p]
            return tuple((iv * t) % p for t in v)
    raise ValueError


def proj_points(p, n=N):
    pts = []
    for k in range(n):
        head = (0,) * k + (1,)
        tails = [()]
        for _ in range(n - k - 1):
            tails = [t + (v,) for t in tails for v in range(p)]
        for t in tails:
            pts.append(head + t)
    assert len(pts) == sum(p ** i for i in range(n))
    return pts


def cubic(v, p):
    return sum(pow(x, 3, p) for x in v) % p


# ----------------------------------------------------------------------
# generic finite-group helpers (dictionary based; no multiplication table)
# ----------------------------------------------------------------------
class G(object):
    def __init__(self, els, mul, inv, ident):
        self.els = els
        self.mul = mul
        self.inv = inv
        self.e = ident

    def closure(self, gens):
        S = {self.e}
        fr = [self.e]
        while fr:
            x = fr.pop()
            for g in gens:
                y = self.mul(x, g)
                if y not in S:
                    S.add(y)
                    fr.append(y)
        return frozenset(S)

    def order(self, x):
        k, y = 1, x
        while y != self.e:
            y = self.mul(y, x)
            k += 1
        return k

    def conj(self, x, c):
        return self.mul(self.mul(self.inv(c), x), c)

    def conj_set(self, H, c):
        return frozenset(self.conj(x, c) for x in H)

    def centre(self, H):
        return [x for x in H if all(self.mul(x, y) == self.mul(y, x) for y in H)]

    def derived(self, H):
        gens = set()
        for a in H:
            for b in H:
                gens.add(self.mul(self.mul(self.inv(a), self.inv(b)), self.mul(a, b)))
        return self.closure(sorted(gens))

    def frattini3(self, H):
        Dg = self.derived(H)
        cubes = {self.mul(self.mul(x, x), x) for x in H}
        return self.closure(sorted(set(Dg) | cubes))

    def closure_bounded(self, gens, limit):
        """closure, aborting (None) as soon as it exceeds `limit` elements"""
        S = {self.e}
        fr = [self.e]
        while fr:
            x = fr.pop()
            for g in gens:
                y = self.mul(x, g)
                if y not in S:
                    S.add(y)
                    if len(S) > limit:
                        return None
                    fr.append(y)
        return frozenset(S)

    def index3_subgroups(self, H):
        """All subgroups of index 3 in the 3-group H: preimages of the
        hyperplanes of the elementary abelian quotient H/Phi(H)."""
        Phi = self.frattini3(H)
        cos = {}
        for x in sorted(H):
            cos.setdefault(frozenset(self.mul(x, f) for f in Phi), []).append(x)
        keys = list(cos)
        kidx = {k: j for j, k in enumerate(keys)}
        reps = [cos[k][0] for k in keys]
        m = len(keys)

        def cos_of(x):
            return kidx[frozenset(self.mul(x, f) for f in Phi)]

        # coordinates on H/Phi(H) (elementary abelian, so this is well defined)
        coord = {cos_of(self.e): ()}
        while len(coord) < m:
            j = next(t for t in range(m) if t not in coord)
            b = reps[j]
            new = {}
            for ci, co in coord.items():
                x = cos[keys[ci]][0]
                for t in range(3):
                    y = x
                    for _ in range(t):
                        y = self.mul(y, b)
                    new[cos_of(y)] = co + (t,)
            coord = new
        k = len(next(iter(coord.values())))
        assert 3 ** k == m, (3 ** k, m)
        vecs = [()]
        for _ in range(k):
            vecs = [v + (t,) for v in vecs for t in range(3)]
        out, seen = [], set()
        for cv in vecs:
            if all(t == 0 for t in cv):
                continue
            key = min(cv, tuple((2 * t) % 3 for t in cv))
            if key in seen:
                continue
            seen.add(key)
            ker = frozenset(x for x in H
                            if sum(a * b for a, b in zip(coord[cos_of(x)], cv)) % 3 == 0)
            assert len(ker) == len(H) // 3, (len(ker), len(H))
            out.append(ker)
        return out

    def sylow3(self, target):
        """Grow a 3-subgroup one index-3 step at a time (possible as long as
        the current 3-group is not Sylow, since H < N_S(H) in any p-group S)."""
        H = frozenset([self.e])
        while len(H) < target:
            found = None
            for g in self.els:
                if g in H:
                    continue
                K = self.closure_bounded(sorted(set(H) | {g}), 3 * len(H))
                if K is not None and len(K) == 3 * len(H):
                    found = K
                    break
            assert found is not None, "Sylow growth stuck at %d" % len(H)
            H = found
        return H


def is_M27(gr, H):
    if len(H) != 27:
        return False
    if max(gr.order(x) for x in H) != 9:
        return False
    Hl = sorted(H)
    return any(gr.mul(a, b) != gr.mul(b, a) for a in Hl for b in Hl)


def binary_cubic_disc(a, p):
    """disc of a0 s^3 + a1 s^2 t + a2 s t^2 + a3 t^3."""
    a0, a1, a2, a3 = a
    return (18 * a0 * a1 * a2 * a3 - 4 * a1 ** 3 * a3 + a1 ** 2 * a2 ** 2
            - 4 * a0 * a2 ** 3 - 27 * a0 ** 2 * a3 ** 2) % p


def main():
    p = P
    els, mul, inv, ident, om = build(p)
    gr = G(els, mul, inv, ident)
    print("Aut(X) order:", len(els))

    # faithfulness on P^4: distinct elements act distinctly on a small test set
    test = [tuple(1 if j == i else 0 for j in range(N)) for i in range(N)]
    test += [(1,) * N, (1, 2, 3, 4, 5), (1, 1, 2, 3, 5)]
    sig = set()
    for el in els:
        sig.add(tuple(normalize(act(el, v, p), p) for v in test))
    assert len(sig) == 9720, "the action on P^4 must be faithful (%d)" % len(sig)

    # generators (independent choice)
    gens = [((0, 1, 2, 3, 4), (1, om, 1, 1, 1)),
            ((1, 0, 2, 3, 4), (1,) * N),
            ((1, 2, 3, 4, 0), (1,) * N)]
    gens = [(s, tuple(c)) for s, c in gens]
    gens = [g if g in set(els) else None for g in gens]
    assert all(g is not None for g in gens)
    assert len(gr.closure(gens)) == 9720

    # ---- Sylow 3-subgroup and all order-27 subgroups, top-down -----------
    Syl = gr.sylow3(243)
    assert len(Syl) == 243
    subs27 = set()
    for Q in gr.index3_subgroups(Syl):
        assert len(Q) == 81
        for R in gr.index3_subgroups(Q):
            assert len(R) == 27
            subs27.add(R)
    m27 = [H for H in subs27 if is_M27(gr, H)]
    print("order-27 subgroups of a Sylow 3-subgroup:", len(subs27),
          "of which C9:C3:", len(m27))

    allm27 = set()
    for H in m27:
        orb = {H}
        fr = [H]
        while fr:
            K = fr.pop()
            for c in gens:
                L = gr.conj_set(K, c)
                if L not in orb:
                    orb.add(L)
                    fr.append(L)
        allm27 |= orb
    classes = []
    left = set(allm27)
    while left:
        H = next(iter(left))
        orb = {H}
        fr = [H]
        while fr:
            K = fr.pop()
            for c in gens:
                L = gr.conj_set(K, c)
                if L not in orb:
                    orb.add(L)
                    fr.append(L)
        classes.append((H, len(orb)))
        left -= orb
    print("C9:C3 subgroups of Aut(X):", len(allm27), "in", len(classes), "classes")

    # ---- points ----------------------------------------------------------
    pts = proj_points(p)
    pidx = {v: k for k, v in enumerate(pts)}
    onX = [k for k, v in enumerate(pts) if cubic(v, p) == 0]
    onXset = set(onX)
    print("|P^4(F_p)| =", len(pts), "  |X(F_p)| =", len(onX))

    def fixed_pts(el):
        out = []
        for k, v in enumerate(pts):
            if normalize(act(el, v, p), p) == v:
                out.append(k)
        return out

    def eigen_split(el, fp):
        """group the fixed base points by eigenvalue"""
        groups = {}
        for k in fp:
            v = pts[k]
            w = act(el, v, p)
            j = next(t for t in range(N) if v[t] % p)
            lam = (w[j] * pow(v[j], p - 2, p)) % p
            groups.setdefault(lam, []).append(k)
        return groups

    def analyse_z(el):
        fp = fixed_pts(el)
        comps = []
        for lam, ks in sorted(eigen_split(el, fp).items()):
            d = None
            for dd in range(1, N + 1):
                if len(ks) == sum(p ** i for i in range(dd)):
                    d = dd
            assert d is not None, len(ks)
            xs = [k for k in ks if k in onXset]
            rec = {"dim_linear": d - 1, "n_points_of_X": len(xs)}
            if d == 1:
                rec["type"] = "point" if xs else "point off X"
                rec["dim"] = 0 if xs else -1
            elif d == 2:
                # binary cubic on the line: two spanning points
                u, v = pts[ks[0]], pts[ks[1]]
                from math import comb
                co = [sum(comb(3, m) * pow(u[i], 3 - m, p) * pow(v[i], m, p)
                          for i in range(N)) % p for m in range(4)]
                assert binary_cubic_disc(co, p) != 0, "the binary cubic must be separable"
                rec["type"] = "3 distinct points on a line (separable binary cubic)"
                rec["dim"] = 0
                rec["npoints"] = 3
                assert len(xs) == 3
            elif d == 3:
                # The eigenspace is spanned by 3 of the coordinate vectors
                # (z is diagonal), so the component is the Fermat plane cubic
                # sum_{i in T} x_i^3 = 0, whose Jacobian (3 x_i^2) has no
                # projective zero in char != 3: smooth, hence of genus
                # (3-1)(3-2)/2 = 1.
                supp = set()
                for k in ks:
                    for t in range(N):
                        if pts[k][t] % p:
                            supp.add(t)
                assert len(supp) == 3, supp
                for k in ks:
                    assert all(pts[k][t] == 0 for t in range(N) if t not in supp)
                # no F_p-rational singular point either
                assert not [k for k in ks if k in onXset
                            and all((3 * pow(t, 2, p)) % p == 0 for t in pts[k])]
                rec["type"] = "smooth Fermat plane cubic on coordinates %s" % sorted(
                    t + 1 for t in supp)
                rec["dim"] = 1
                rec["genus"] = 1        # smooth plane cubic: (d-1)(d-2)/2 = 1
                rec["Fp_points"] = len(xs)
            else:
                rec["type"] = "linear space of dimension %d" % (d - 1)
                rec["dim"] = d - 2
            comps.append(rec)
        return comps

    out = []
    for H, size in classes:
        Zc = sorted(gr.centre(H))
        assert len(Zc) == 3
        cent = []
        for z in Zc:
            if z == ident:
                continue
            comps = analyse_z(z)
            cent.append({"order": gr.order(z), "components": comps,
                         "hyp_a": all(c["dim"] < 1 or c.get("genus", 0) >= 1
                                      for c in comps)})
        # X^H
        gg = []
        cur = {ident}
        for x in sorted(H):
            if x in cur:
                continue
            gg.append(x)
            cur = gr.closure(gg)
            if len(cur) == 27:
                break
        fixG = None
        for g in gg:
            s = set(fixed_pts(g))
            fixG = s if fixG is None else (fixG & s)
        onXfix = fixG & onXset
        line_in_fix = len(fixG) >= p + 1
        out.append({
            "class_size": size,
            "exponent": max(gr.order(x) for x in H),
            "centre_order": len(Zc),
            "central": cent,
            "hyp_a": all(c["hyp_a"] for c in cent),
            "n_fixed_points_P4": len(fixG),
            "positive_dim_fixed_locus_in_P4": line_in_fix,
            "n_fixed_points_on_X": len(onXfix),
            "hyp_b": (len(onXfix) == 0 and not line_in_fix),
        })

    for r in out:
        print("  class size %-4d exponent %d |Z| %d  (a) %s  Fix(G,P^4): %d pts%s"
              " X^G: %d  => (b) %s"
              % (r["class_size"], r["exponent"], r["centre_order"], r["hyp_a"],
                 r["n_fixed_points_P4"],
                 " (contains a line)" if r["positive_dim_fixed_locus_in_P4"] else "",
                 r["n_fixed_points_on_X"], r["hyp_b"]))

    # ---- compare with the producer ---------------------------------------
    payload = json.load(open(os.path.join(HERE, "T4_payload.json")))
    ok = True

    def chk(name, got, want):
        good = (got == want)
        print("  %-52s %-14s %s" % (name, str(got), "OK" if good else "MISMATCH want " + str(want)))
        return good

    ok &= chk("Aut(X) order", 9720, payload["aut_order"])
    ok &= chk("# C9:C3 subgroups", len(allm27), payload["num_M27_subgroups_total"])
    ok &= chk("# conjugacy classes", len(classes), payload["num_M27_classes"])
    prod = sorted((c["class_size"], c["exponent"], c["centre_order"], c["hyp_a"], c["hyp_b"])
                  for c in payload["M27_classes"])
    ver = sorted((r["class_size"], r["exponent"], r["centre_order"], r["hyp_a"], r["hyp_b"])
                 for r in out)
    ok &= chk("class data multiset", ver == prod, True)
    ok &= chk("classes with (a)+(b)",
              sum(1 for r in out if r["hyp_a"] and r["hyp_b"]),
              len(payload["classes_satisfying_a_and_b"]))
    # the shape of X^z: a genus-1 plane cubic plus 3 points, for every class
    shapes = set()
    for r in out:
        for c in r["central"]:
            shapes.add(tuple(sorted((x["dim"], x.get("genus"), x.get("npoints",
                                     x.get("Fp_points"))) for x in c["components"])))
    ok &= chk("every central z: one genus-1 curve + 3 points",
              all(sorted(d for d, _, _ in s) == [0, 1] for s in shapes), True)
    prodshape = set()
    for c in payload["M27_classes"]:
        for z in c["central_elements"]:
            prodshape.add(tuple(sorted((comp["dim"], comp.get("genus"))
                                       for comp in z["X^z"])))
    ok &= chk("producer's X^z shapes", sorted(prodshape), [((0, None), (1, 1))])

    print()
    print("VERIFY_T4:", "PASS" if ok else "FAIL")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
