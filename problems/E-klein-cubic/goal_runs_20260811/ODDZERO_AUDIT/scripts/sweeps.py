"""The 15 sweep-capable rows, their children, and the Thm-15.1 evaluation
rule -- all rebuilt independently from the census produced by build_census.py."""
import sys, os, pickle, itertools
from collections import defaultdict
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from ozlib import Ambient, Band

BASE = os.environ.get(
    "OZ_CACHE",
    os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
                 "_cache"))
os.makedirs(BASE, exist_ok=True)


class Sigma:
    def __init__(self, p):
        self.p = p
        self.amb = pickle.load(open(os.path.join(BASE, "amb_%d.pkl" % p), "rb"))
        self.m = self.amb.m
        self.band = Band(self.amb)
        (self.keys, self.H, self.orbit_of, self.reps, self.rows) = pickle.load(
            open(os.path.join(BASE, "census_%d.pkl" % p), "rb"))
        self.index = {k: i for i, k in enumerate(self.keys)}
        self.W = self.amb.W

    # ---------- basics ----------
    def act(self, g, k):
        U, A = k
        return (tuple(self.amb.gact(g, X) for X in U),
                tuple(self.amb.gact(g, X) for X in A))

    def dim_of(self, k):
        U, A = k
        Us = [()] + list(U)
        return sum(len(A[i]) - len(Us[i]) - 1 for i in range(len(A)))

    def setwise(self, k):
        return frozenset(g for g in self.m.G if self.act(g, k) == k)

    def normpt(self, v):
        p = self.p
        for x in v:
            if x % p:
                iv = pow(x, p - 2, p)
                return tuple(y * iv % p for y in v)
        return None

    # ---------- closure at component level ----------
    def closure_le(self, kd, kt):
        """component kd lies in the closure of component kt (kd != kt)."""
        amb = self.amb
        C, L = kd
        Cp, Lp = kt
        if kd == kt:
            return False
        if not set(Cp) <= set(C):
            return False
        Us = [()] + list(C)
        His = list(C) + [amb.W]
        for r in range(len(C) + 1):
            lo, hi = Us[r], His[r]
            s = sum(1 for U in Cp if amb.sub(U, lo))
            Ap = Lp[s]
            I = self.m.inter(Ap, hi) if hi != amb.W else Ap
            Ind = amb.span(I, lo) if (I or lo) else ()
            if not amb.sub(L[r], Ind):
                return False
        return True

    def children(self, kt):
        return [k for k in self.keys if self.closure_le(k, kt)]

    # ---------- slot data of a component ----------
    def slots(self, k):
        U, A = k
        Us = [()] + list(U)
        return [(Us[i], A[i]) for i in range(len(A))]

    # ---------- the Thm 15.1 evaluation rule ----------
    def eval_data(self, kt, kd):
        """(Lam, [mu_i], posdim) for the child kd of the sweep component kt.
        mu_i is the Lam-character on the child's limiting coordinate in the
        i-th slot of kt;  posdim[i] = True iff the i-th slot of kt is
        positive-dimensional (carries a genuine multidegree)."""
        amb = self.amb
        Ct, Lt = kt
        Cd, Ld = kd
        Gam = self.setwise(kt)
        Hd = self.H[kd]
        Lam = Gam & Hd
        Ust = [()] + list(Ct)
        mus, posdim = [], []
        for i in range(len(Lt)):
            lo = Ust[i]
            # the child's slot with the same lower end
            j = next(t for t, (lo2, _) in enumerate(self.slots(kd)) if lo2 == lo)
            Ar = Ld[j]
            mu = {g: amb.scalar_value(g, lo, Ar) for g in Lam}
            mus.append(mu)
            posdim.append(len(Lt[i]) - len(lo) >= 2)
        return Lam, mus, posdim

    def target_line(self, kt):
        """W-_w for the involution w generating the pointwise stabilizer of the
        sweep component kt (the row sweeps onto L_w)."""
        H = self.H[kt]
        w = [g for g in H if g != self.m.Id]
        assert len(w) == 1
        return self.m.minus_line(w[0]), w[0]

    def evaluate(self, kt, kd, degs, psi):
        """value of the child kd, as a point of P(W), for the sweep component
        kt carrying multidegree `degs` (on its positive-dimensional slots, in
        order) and character psi (dict g -> scalar over the setwise stab)."""
        p = self.p
        Lam, mus, posdim = self.eval_data(kt, kd)
        Wm, w = self.target_line(kt)
        it = iter(degs)
        chi = {g: 1 for g in Lam}
        for i, pd in enumerate(posdim):
            if not pd:
                continue
            a = next(it)
            for g in Lam:
                chi[g] = chi[g] * pow(mus[i][g], a, p) % p
        for g in Lam:
            chi[g] = chi[g] * pow(psi[g], p - 2, p) % p
        cur = Wm
        for g in Lam:
            if g == self.m.Id:
                continue
            cur = self.m.inter(cur, self.m.eigsp(g, chi[g])) if cur else ()
            if not cur:
                return "DEGENERATE"
        if len(cur) == 2:
            return "FREE"
        return self.normpt(cur[0])
