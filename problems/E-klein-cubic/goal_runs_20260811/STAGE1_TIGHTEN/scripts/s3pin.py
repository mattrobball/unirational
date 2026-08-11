"""STAGE1_TIGHTEN -- STAGE2 Theorem 1.2 applied to ALL 80 rows of the terminus.

STAGE2_ODD_ORDER_PINNING pinned the 22 odd-order rows with the master weight
formula

     w(R)  =  d.a_k  +  sum_l  mu_l . c_l      (mod n)                    (*)

for a cyclic g of order n, where a_k is the g-weight of the level-0 centre and
c_l the relative g-weights of the successive exceptional directions.  Here (*)
is applied to every row of the census, for every g in the row's pointwise
stabiliser simultaneously.

Translation into the wonderful-model chart data of TERMINUS_STRATA_PW: a stratum
with chain U_1 < ... < U_k and eigen-datum (A_0, ..., A_k) has a generic point
(x, beta_1, ..., beta_k), x in P(A_0), beta_l in P(A_l / U_l).  Writing
lambda_l(g) for the g-character on that line, the level-0 centre is x with weight
lambda_0 and the l-th exceptional direction has RELATIVE weight
c_l = lambda_l - lambda_{l-1}.  So

     w(R)(g)  =  d.lambda_0(g)  +  sum_{l=1..k} mu_l . (lambda_l - lambda_{l-1})(g)

with mu_1, ..., mu_k the successive multiplicities of T along the chain -- the
SAME mu's for every g, and shared with every other row on the same chain prefix.
That sharing is where the coherence lives.

A NOTE ON THE STAGE-1 CHARACTER CONVENTION.  STAGE1's Layer-2 parametrisation
(multidegree a on the positive-dimensional slots, linear character psi of
Stab_G(F)) is correct precisely because psi absorbs the degrees along the
directions TRANSVERSE to the stratum.  Only for the two dimension-3 divisors
D_{P_sigma} and D_{L^-_sigma} do the slots exhaust W (dims 3+2 and 2+3), and only
there is the character forced to be trivial by G-invariance of T.  Imposing
psi = 1 on the other rows is WRONG and this module does not do it.
"""
import itertools
import os
import sys
from collections import defaultdict

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))


class Pinner:
    def __init__(self, E):
        self.E = E
        self.m = E.m
        self.p = E.p if hasattr(E, "p") else E.m.p
        self._prep()

    # ------------------------------------------------------------------
    def weights(self, comp_idx):
        """lambda_0..lambda_k as dicts g -> exponent, for g in the pointwise stab."""
        S, m, p = self.E.S, self.m, self.m.p
        C, L, H = S.comps[comp_idx]
        Us = [()] + list(C)
        lam = []
        for i in range(len(L)):
            lo, A = Us[i], L[i]
            # a generic line of A/lo, on which H acts by a scalar
            d = {}
            for g in sorted(H):
                if g == m.Id:
                    d[g] = 0
                    continue
                n = m.order[g]
                z = self._proot(n)
                found = None
                for e in range(n):
                    lamv = pow(z, e, p)
                    Ez = m.eigsp(g, lamv)
                    EL = m.canon(list(Ez) + list(lo)) if lo else Ez
                    if Ez and S.sub(A, EL):
                        found = e
                        break
                if found is None:
                    return None
                d[g] = found
            lam.append(d)
        return lam

    def _proot(self, n):
        if not hasattr(self, "_pr"):
            self._pr = {}
        if n not in self._pr:
            p = self.m.p
            self._pr[n] = next(x for x in range(2, p) if pow(x, n, p) == 1 and
                               all(pow(x, n // q, p) != 1 for q in self._primes(n)))
        return self._pr[n]

    @staticmethod
    def _primes(n):
        out, k, x = set(), 2, n
        while k * k <= x:
            while x % k == 0:
                out.add(k)
                x //= k
            k += 1
        if x > 1:
            out.add(x)
        return out or {1}

    # ------------------------------------------------------------------
    def _prep(self):
        """target inventory: for each cell, the g-weights of its points."""
        E, m, p = self.E, self.m, self.m.p
        self.tgt = defaultdict(list)          # (cellname) -> [(label, {g: weight})]
        T = E.T
        for cell in ("PI", "P6"):
            for lab in T.comp[cell]:
                self.tgt[cell].append(lab)
        self.rowdata = {}
        for r in E.rows:
            lam = self.weights(r["rep"])
            self.rowdata[r["id"]] = dict(lam=lam, H=sorted(r["H"]),
                                         K=r["K"], dim=r["dim"],
                                         nchain=len(S_chain(E, r)))

    # ------------------------------------------------------------------
    def value_weights(self, rid, d, mus):
        """{g: w} for the row rid at covariant degree d with multiplicities mus."""
        rd = self.rowdata[rid]
        lam = rd["lam"]
        if lam is None:
            return None
        out = {}
        for g in rd["H"]:
            if g == self.m.Id:
                continue
            n = self.m.order[g]
            w = d * lam[0][g]
            for l in range(1, len(lam)):
                w += mus[l - 1] * (lam[l][g] - lam[l - 1][g])
            out[g] = w % n
        return out

    def point_of_weights(self, cell, w, H):
        """the component of `cell` whose g-weights match w for every g in H."""
        m, p = self.m, self.m.p
        out = []
        for lab in self.tgt[cell]:
            v = lab[0]
            ok = True
            for g in H:
                if g == m.Id:
                    continue
                n = m.order[g]
                z = self._proot(n)
                img = m.act(g, v)
                j0 = next(b for b in range(5) if v[b] % p)
                c = img[j0] * m.inv(v[j0]) % p
                e = next((x for x in range(n) if pow(z, x, p) == c), None)
                if e is None or e != w.get(g):
                    ok = False
                    break
            if ok:
                out.append(lab)
        return out


def S_chain(E, r):
    return E.S.comps[r["rep"]][0]
