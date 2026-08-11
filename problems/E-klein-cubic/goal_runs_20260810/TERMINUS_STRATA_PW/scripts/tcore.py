"""Core engine for the TERMINUS_STRATA_PW packet: the orbit-type (exact
stabilizer) stratification of the blowup tower over `P(W)`.

Builds on the packet-local copies of `psl211.py` / `sfcore.py` taken from
`goal_runs_20260810/STANDARD_FORM_PW` (which in turn extend
`DUNCAN_CORNER_F2`).  Adds the structure theory the census needs.

--------------------------------------------------------------------------
THE MODEL
--------------------------------------------------------------------------
`A` = the arrangement of linear subspaces of `W = C^5` spanned by the
level-0 fixed-locus components: 940 lines (the special points), 220 planes
(the special lines), 55 3-spaces (the plus-planes).  `A` is closed under
intersection, so the tower

    T0 = blow up the 940 points,
    T1 = blow up the 220 (strict transforms of) lines,
    T2 = blow up the 55 (strict transforms of) plus-planes

is exactly the maximal De Concini--Procesi wonderful model of `A`.  Write
`Z_0 = P(W)`, `Z_1` (after T0), `Z_2` (after T1), `Z = Z_3` (after T2), and
let `A_j` be the sub-arrangement blown up so far (`A_0 = {}` , `A_1` = the
points, `A_2` = points+lines, `A_3 = A`).

STRATIFICATION.  `Z_j = ⊔_C str°(C)` over chains `C : U_1 ⊊ … ⊊ U_k` in
`A_j` (including the empty chain), where

    str°(C) = { (x, β_1, …, β_k) },
      x  ∈ P(U_1),                    x ∉ any smaller element of A_j
      β_i ∈ P(U_{i+1}/U_i),           β_i ∉ P(U_S/U_i) for U_i ⊊ U_S ⊊ U_{i+1}
                                      (U_{k+1} := W)

and `D_{S_1} ∩ … ∩ D_{S_k}` is the union of the `str°(C')` for `C' ⊇ C`.
This is derived in THEOREM.md §2 and machine-checked in `t1_arrangement.py`
(dimension count, chart derivation) and `t6_charts.m2` (exact charts).

TANGENT WEIGHTS.  At `z = (x, β_1, …, β_k)` with `v = ⟨x⟩`, `λ_0` = the
character of the stabilizer on `v`, `λ_i` = its character on the line
`β_i ⊂ U_{i+1}/U_i`, the four tangent weights of `Z_j` at `z` are

    λ_0^{-1}·(U_1/v)            free      (dim U_1 - 1 of them)
    λ_0^{-1}λ_1                 BOUNDARY  (the branch D_{S_1})
    λ_1^{-1}·((U_2/U_1)/β_1)    free
    λ_1^{-1}λ_2                 BOUNDARY  (the branch D_{S_2})
    …
    λ_k^{-1}·((W/U_k)/β_k)      free

so `Z_j^K` is smooth at `z` of dimension  dim(stratum) + #{i : λ_{i-1}=λ_i on K}.

OPENNESS.  Hence a piece `P(A_0) × ∏ P(A_i)` (the `A_i` the `K`-eigenspaces)
is a component of `Z_j^K` — equivalently the closure of a component of the
orbit-type stratum `Z_{j,=K}` — **iff `λ_{i-1} ≠ λ_i` as characters of `K`
for every i = 1..k**.  This is exactly clause (iii) of `FIX_I_bcomplex.md`
Theorem 2.1 (the trivial normal character belongs to a strict transform).
"""
from collections import defaultdict
import itertools
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from psl211 import Model, SPLIT_PRIMES              # noqa: E402
from sfcore import Core, Rep, rref, nullspace       # noqa: E402


# ==========================================================================
# graded representations along a flag
# ==========================================================================
class Graded:
    """The representation of a subgroup M <= G on `Ubig / Usub`, together with
    a lift of its vectors back to W."""

    def __init__(self, C, Usub, Ubig, M):
        p = C.p
        self.C, self.p = C, p
        B, piv = rref([list(b) for b in Ubig], 5, p)
        self.B, self.piv = B, piv
        d = len(B)
        mats = {}
        for g in M:
            A = C.G[g]
            cols = [[C.m.act(A, b)[c] for c in piv] for b in B]
            mats[g] = tuple(tuple(cols[j][i] for j in range(d)) for i in range(d))
        R = Rep(mats, d, p, keys=sorted(M))
        if Usub:
            sub = [[list(b)[c] for c in piv] for b in Usub]
            B2, piv2 = rref(sub, d, p)
            self.free = [c for c in range(d) if c not in piv2]
            self.R = R.quot_rep(sub)
            self._B2, self._piv2 = B2, piv2
        else:
            self.free = list(range(d))
            self.R = R
            self._B2, self._piv2 = (), ()
        self.n = self.R.n
        self.Usub = Usub
        self.Ubig = Ubig

    def lift(self, w):
        """A vector of the quotient -> a vector of W."""
        d = len(self.B)
        co = [0] * d
        for k, c in enumerate(self.free):
            co[c] = w[k] % self.p
        out = [0] * 5
        for j in range(d):
            if co[j]:
                for t in range(5):
                    out[t] = (out[t] + co[j] * self.B[j][t]) % self.p
        return tuple(out)

    def lift_space(self, F):
        """A subspace of the quotient -> its preimage in W (contains Usub)."""
        rows = [list(b) for b in self.Usub] + [list(self.lift(w)) for w in F]
        return self.C.m.canon(rows) if rows else ()

    def acts_scalar(self, g, F):
        M = self.R.mats[g]
        p, n = self.p, self.R.n
        c = None
        for b in F:
            w = tuple(sum(M[r][s] * b[s] for s in range(n)) % p for r in range(n))
            j = next(t for t in range(n) if b[t] % p)
            if w[j] % p == 0:
                return None
            cc = w[j] * pow(b[j], p - 2, p) % p
            if c is None:
                c = cc
            elif cc != c:
                return None
            if any((w[t] - c * b[t]) % p for t in range(n)):
                return None
        return c

    def preserves(self, g, F):
        M = self.R.mats[g]
        p, n = self.p, self.R.n
        img = [[sum(M[r][s] * b[s] for s in range(n)) % p for r in range(n)] for b in F]
        return rref(img, n, p)[0] == rref([list(b) for b in F], n, p)[0]

    def eigen_pieces(self, K):
        """[(character-as-dict, subspace)] : maximal subspaces on which K acts
        by a scalar.  Works for nonabelian K too (linear characters only)."""
        gens, chars = self.C.linear_characters(K)
        out = []
        for lams, val in chars:
            F = self.R.fixed_space(gens, list(lams))
            if F:
                out.append((val, F))
        return out

    def module_chars(self, K):
        """The full multiset of K-characters of this module (K abelian and the
        module a sum of characters); returns None if not diagonalisable."""
        tot, out = 0, []
        for val, F in self.eigen_pieces(K):
            tot += len(F)
            out += [val] * len(F)
        return out if tot == self.R.n else None


# ==========================================================================
# the arrangement
# ==========================================================================
class Tower:
    def __init__(self, p, verbose=False):
        self.C = Core(p)
        self.p = p
        C = self.C
        self.m = C.m
        self.W = C.m.canon([[int(i == j) for j in range(5)] for i in range(5)])
        # ---- all fixed-locus components of P(W): the arrangement ----
        subs = set()
        self.classes = [H for H in C.subgroup_classes()]
        for H in self.classes:
            if len(H) == 1:
                continue
            for val, U in C.char_subspaces(H):
                if len(U) < 5:
                    for g in range(C.n):
                        subs.add(C.m.canon([list(C.m.act(C.G[g], v)) for v in U]))
        self.arr = sorted(subs, key=lambda U: (len(U), U))
        self.bydim = defaultdict(list)
        for U in self.arr:
            self.bydim[len(U)].append(U)
        # ---- G-orbit labels ----
        self.orbit_of = {}
        self.orbit_rep = []
        for U in self.arr:
            if U in self.orbit_of:
                continue
            k = len(self.orbit_rep)
            orb = set()
            for g in range(C.n):
                orb.add(C.m.canon([list(C.m.act(C.G[g], v)) for v in U]))
            for V in orb:
                self.orbit_of[V] = k
            self.orbit_rep.append((U, len(orb)))
        self.orbit_name = [self._name_orbit(U) for U, _ in self.orbit_rep]
        # ---- containment ----
        self.below = defaultdict(list)     # U -> arrangement elements strictly inside
        self.above = defaultdict(list)
        for U in self.arr:
            for V in self.arr:
                if len(V) < len(U) and self.contains(U, V):
                    self.below[U].append(V)
                    self.above[V].append(U)

    # ---------------- small helpers ----------------
    def contains(self, U, V):
        """V subset of U ?"""
        return self.m.rank([list(x) for x in U] + [list(x) for x in V]) == len(U)

    def stab_set(self, U):
        return self.C.sstab(U)

    def pstab(self, U):
        return self.C.pstab(U)

    def _name_orbit(self, U):
        C = self.C
        ps, ss = C.pstab(U), C.sstab(U)
        d = len(U)
        pn, sn = C.name(ps), C.name(ss)
        if d == 3:
            return "P_sigma"
        if d == 2:
            return {"V4": "ell_V", "C3": "C3line", "C2": "Lminus_sigma"}[pn]
        return {("D12", "D12"): "pt_D12", ("A4", "A4"): "pt_A4", ("D10", "D10"): "pt_D10",
                ("C11", "C11"): "pt_C11", ("C6", "C6"): "pt_C6", ("C5", "C5"): "pt_C5",
                ("V4", "V4"): "pt_V4I"}[(pn, sn)]

    def label(self, U):
        i = self.orbit_of[U]
        n = self.orbit_name[i]
        same = [j for j in range(len(self.orbit_rep)) if self.orbit_name[j] == n]
        if len(same) == 1:
            return n
        return f"{n}({'abcd'[same.index(i)]})"

    # ---------------- chains ----------------
    def chains(self, arrj):
        """All chains (as tuples of subspaces, increasing) inside the given
        sub-arrangement, of length 1..3, plus the empty chain."""
        S = set(arrj)
        out = [()]
        singles = [(U,) for U in arrj]
        out += singles
        cur = singles
        while cur:
            nxt = []
            for ch in cur:
                for V in self.above[ch[-1]]:
                    if V in S:
                        nxt.append(ch + (V,))
            out += nxt
            cur = nxt
        return out

    def chain_orbit_reps(self, arrj):
        """G-orbit representatives of the chains, with orbit sizes."""
        seen, reps = set(), []
        for ch in self.chains(arrj):
            if ch in seen:
                continue
            orb = set()
            for g in range(self.C.n):
                orb.add(tuple(self.m.canon([list(self.m.act(self.C.G[g], v)) for v in U])
                              for U in ch))
            seen |= orb
            reps.append((ch, len(orb)))
        return reps


# ==========================================================================
# subgroups of a small group, by index
# ==========================================================================
def all_subgroups(C, M):
    out = {frozenset([C.e])}
    fr = [frozenset([C.e])]
    while fr:
        nf = []
        for K in fr:
            for g in M:
                if g in K:
                    continue
                L = C.gen(list(K) + [g])
                if L <= M and L not in out:
                    out.add(L)
                    nf.append(L)
        fr = nf
    return sorted(out, key=lambda K: (len(K), sorted(K)))


def chkey(K, val):
    return tuple(val[i] for i in sorted(K))


def chinv(C, K, val):
    return {i: pow(val[i], C.p - 2, C.p) for i in K}


def chmul(C, K, a, b):
    return {i: a[i] * b[i] % C.p for i in K}


def chdiv(C, K, a, b):
    return {i: a[i] * pow(b[i], C.p - 2, C.p) % C.p for i in K}


def is_triv(K, val):
    return all(val[i] == 1 for i in K)


def char_order(C, K, val):
    o = 1
    cur = dict(val)
    while not is_triv(K, cur):
        cur = chmul(C, K, cur, val)
        o += 1
    return o


def char_label(C, K, val, gens):
    """A stable label: exponents on the chosen generators (discrete logs)."""
    if is_triv(K, val):
        return "1"
    ex = []
    for g in gens:
        n = C.ordr[g]
        z = C.m._root(n)
        v = val[g] % C.p
        j = next(t for t in range(n) if pow(z, t, C.p) == v)
        ex.append(f"{j}/{n}")
    return "[" + ",".join(ex) + "]"


# ==========================================================================
# the orbit-type census of a stage of the tower
# ==========================================================================
STAGE_NAME = {0: "Z_0 = P(W)", 1: "Z_1 (after T0)", 2: "Z_2 (after T1)", 3: "Z = Z_3 (after T2)"}


def sub_arrangement(T, j):
    """A_j : what has been blown up by the end of stage j."""
    out = []
    if j >= 1:
        out += T.bydim[1]
    if j >= 2:
        out += T.bydim[2]
    if j >= 3:
        out += T.bydim[3]
    return out


def census(T, j):
    """Every G-orbit of components of the orbit-type strata Z_{j,=K}."""
    C = T.C
    arrj = sub_arrangement(T, j)
    arrset = set(arrj)
    rows = []

    # ---------- the empty chain: strict transforms of level-0 components ----
    # the free stratum Z_{=1}
    rows.append(_mkrow(T, j, (), [T.W], [None], frozenset([C.e]), frozenset(range(C.n)),
                       empty_chain=True))
    for i, (U, cnt) in enumerate(T.orbit_rep):
        if U in arrset:
            continue                      # already blown up: no strict transform
        rows.append(_mkrow(T, j, (), [U], [None], C.pstab(U), C.sstab(U), empty_chain=True))

    # ---------- nonempty chains ----------
    for ch, chorb in T.chain_orbit_reps(arrj):
        if not ch:
            continue
        M = frozenset.intersection(*[C.sstab(U) for U in ch])
        gr, prev = [], ()
        for U in list(ch) + [T.W]:
            gr.append(Graded(C, prev, U, M))
            prev = U
        k = len(ch)
        seen = set()
        for K in all_subgroups(C, M):
            eig = [g.eigen_pieces(K) for g in gr]
            if any(len(e) == 0 for e in eig):
                continue
            for combo in itertools.product(*eig):
                lams = [v for v, F in combo]
                As = [F for v, F in combo]
                # exact pointwise stabilizer must be K itself
                Kex = frozenset(g for g in M
                                if all(gr[i].acts_scalar(g, As[i]) is not None
                                       for i in range(k + 1)))
                if Kex != K:
                    continue
                # OPENNESS: consecutive characters distinct on K
                if any(chkey(K, lams[i - 1]) == chkey(K, lams[i]) for i in range(1, k + 1)):
                    continue
                # VALIDITY: generic point really lies in str-open(chain)
                lifted = [gr[i].lift_space(As[i]) for i in range(k + 1)]
                ok = True
                for i in range(k + 1):
                    lo = ch[i - 1] if i >= 1 else ()
                    hi = ch[i] if i < k else T.W
                    for US in arrj:
                        if len(US) >= len(hi):
                            continue
                        if lo and not T.contains(US, lo):
                            continue
                        if lo and len(US) <= len(lo):
                            continue
                        if not T.contains(hi, US):
                            continue
                        if T.contains(US, lifted[i]):
                            ok = False
                            break
                    if not ok:
                        break
                if not ok:
                    continue
                key = tuple(C.m.canon([list(b) for b in x]) for x in lifted)
                if key in seen:
                    continue
                for g in M:                        # dedup the M-orbit
                    seen.add(tuple(C.m.canon([list(C.m.act(C.G[g], v)) for v in x])
                                   for x in lifted))
                sw = frozenset(g for g in M
                               if all(gr[i].preserves(g, As[i]) for i in range(k + 1)))
                rows.append(_mkrow(T, j, ch, lifted, lams, K, sw, gr=gr, As=As))
    return rows


def _mkrow(T, j, ch, lifted, lams, K, sw, empty_chain=False, gr=None, As=None):
    C = T.C
    k = len(ch)
    dim = sum(len(x) for x in lifted) - sum(len(u) for u in ch) - (k + 1) if not empty_chain \
        else len(lifted[0]) - 1
    row = {
        "stage": j,
        "chain": [T.label(U) for U in ch],
        "chain_dims": [len(U) - 1 for U in ch],
        "K": C.name(K), "K_order": len(K),
        "dim": dim,
        "n_orbit": C.n // len(sw),
        "setwise": C.name(sw), "setwise_order": len(sw),
        "empty_chain": empty_chain,
        "genre": ("free/strict-transform" if empty_chain else
                  {1: "T0 point-exceptional", 2: "T1 line-exceptional",
                   3: "T2 plane-exceptional"}[len(ch[-1])]),
        "created_at": (None if empty_chain else
                       {1: "T0", 2: "T1", 3: "T2"}[len(ch[-1])]),
        "anchor": (None if empty_chain else
                   ("generic point of the centre " + T.label(ch[-1]) if len(ch) == 1
                    else "the stratum on " + T.label(ch[-1]) + " with chain "
                         + "<".join(T.label(u) for u in ch[:-1]))),
    }
    # birational model: the closure of F is a smooth blowup of the product
    # P(A_0) x prod_i P(A_i) of projective spaces -- hence RATIONAL.
    if empty_chain:
        row["factors"] = [len(lifted[0]) - 1]
    else:
        row["factors"] = [len(lifted[0]) - 1] + \
            [len(lifted[i]) - len(ch[i - 1]) - 1 for i in range(1, k + 1)]
    row["bir"] = ("rational: blowup of P^" +
                  " x P^".join(str(d) for d in row["factors"]))
    row["_lifted"] = [tuple(tuple(int(y) for y in b) for b in x) for x in lifted]
    row["_chain"] = [tuple(tuple(int(y) for y in b) for b in u) for u in ch]
    row["_K"] = sorted(K)
    row["_sw"] = sorted(sw)
    # residual action W(K,F) = Stab_{N_G(K)}(F)/K  (sw normalises K)
    row["residual_order"] = len(sw) // len(K)
    row["residual"] = _quot_name(C, sw, K)
    # number of components of Z_{=K} for ONE fixed K
    NG = frozenset(g for g in range(C.n) if C.conj(K, g) == K)
    row["n_for_fixed_K"] = len(NG) // len(sw)
    row["NG_order"] = len(NG)
    # weights / normal characters
    row["weights"] = None
    if C.is_abelian(K):
        wts = _weights(T, ch, lams, K, gr, empty_chain, lifted)
        row["weights"] = wts
        row["dim_check"] = sum(1 for w, f in wts if w == "1")
        row["normal_chars"] = sorted([(w, f) for w, f in wts if w != "1"])
        row["toroidal"] = _toroidal(C, K, ch, lams, empty_chain)
    return row


def _quot_name(C, sw, K):
    if len(sw) == len(K):
        return "1"
    if len(K) == 1:
        return C.name(sw)
    q = len(sw) // len(K)
    # identify the quotient by the orders of its elements (cosets)
    cos = {}
    for g in sw:
        key = frozenset(C.mul[g][x] for x in K)
        cos.setdefault(key, g)
    reps = list(cos)
    def cmul(a, b):
        ga, gb = cos[a], cos[b]
        return frozenset(C.mul[C.mul[ga][gb]][x] for x in K)
    ident = frozenset(K)
    ords = []
    for a in reps:
        n, cur = 1, a
        while cur != ident:
            cur = cmul(cur, a)
            n += 1
        ords.append(n)
    if q == 1:
        return "1"
    if max(ords) == q:
        return f"C{q}"
    if q == 4:
        return "V4"
    if q == 6:
        return "S3"
    if q == 12:
        return "A4" if 6 not in ords else "D12"
    if q == 10:
        return "D10"
    return f"Q{q}"


def _weights(T, ch, lams, K, gr, empty_chain, lifted=None):
    """The 4 tangent weights at a general point of the stratum, each tagged
    'B' (a boundary branch) or '.' (free).  Weight '1' = trivial on K."""
    C = T.C
    gens = C.generators(K) if len(K) > 1 else []
    if empty_chain:
        gg = Graded(C, (), T.W, K)
        mods = [gg.module_chars(K)]
        A0 = lifted[0]
        lam0 = {g: gg.acts_scalar(g, [[x for x in b] for b in A0]) for g in K}
        lams, k = [lam0], 0
    else:
        mods = [g.module_chars(K) for g in gr]
        k = len(ch)
    out = []
    for i in range(k + 1):
        if mods[i] is None:
            return None
        mod = list(mods[i])
        li = lams[i]
        for t, v in enumerate(mod):
            if chkey(K, v) == chkey(K, li):
                mod.pop(t)
                break
        else:
            return None
        for v in mod:
            out.append((char_label(C, K, chdiv(C, K, v, li), gens), "."))
        if i < k:
            out.append((char_label(C, K, chdiv(C, K, lams[i + 1], li), gens), "B"))
    return out


def _toroidal(C, K, ch, lams, empty_chain):
    """def:toroidal(c): the boundary weights must generate K-hat, i.e. the
    defect (the intersection of their kernels) must be trivial."""
    if empty_chain:
        return len(K) == 1
    k = len(ch)
    bnd = [chdiv(C, K, lams[i + 1], lams[i]) for i in range(k)]
    defect = [g for g in K if all(b[g] == 1 for b in bnd)]
    return len(defect) == 1
