"""ADJUDICATION of PR #31 (2026-08-11) -- a fully INDEPENDENT re-derivation of
the TERMINUS_STRATA_PW census.  Run: `python3 scripts/adj_indep_census.py 331`
(and 661).  Output: `results/adj_indep_census.txt`.

Shares with the packet ONLY the sealed group model `psl211.Model` (the 660
matrices of PSL(2,11) on W = F_p^5, byte-identical to the merged
STANDARD_FORM_PW copy) and its linear-algebra primitives.  Everything about
the census -- the arrangement, the chains, the eigen-data, the exactness test,
the dedup and the counting -- is written here from scratch, and in particular:

  * the arrangement A is built from the eigenspaces of the 659 non-identity
    ELEMENTS (the packet builds it from SUBGROUP character subspaces);
  * ALL chains are enumerated, not G-orbit representatives, and components are
    counted ONE BY ONE -- so a dedup bug of the kind the packet reports in
    STANDARD_FORM_PW's s5_terminus.py cannot hide;
  * eigen-pieces are computed by successive splitting of lifted subspaces of W
    (the packet uses quotient representations and character tables).

Prints components and G-orbits at each stage, by exact stabilizer.
"""
import os
import sys
from collections import defaultdict

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from psl211 import Model                                     # noqa: E402

P = int(sys.argv[1]) if len(sys.argv) > 1 else 331
m = Model(P)
p = P
G = m.G
n = len(G)
Gidx = {A: i for i, A in enumerate(G)}
ID = Gidx[m.Id]
FULL = tuple(tuple(int(i == j) for j in range(5)) for i in range(5))


def canon(rows):
    return m.canon([list(r) for r in rows])


_actc = {}


def act_sp(g, U):
    k = (g, U)
    r = _actc.get(k)
    if r is None:
        r = canon([m.act(G[g], v) for v in U])
        _actc[k] = r
    return r


_perpc = {}


def perpm(U):
    r = _perpc.get(U)
    if r is None:
        r = FULL if not U else m.nullspace(list(U))
        _perpc[U] = r
    return r


def contains(U, V):
    """V subset of U?"""
    return m.rank([list(x) for x in U] + [list(x) for x in V]) == len(U)


# --------------------------------------------------------------------------
# 1.  the arrangement, from ELEMENT eigenspaces + intersection closure
# --------------------------------------------------------------------------
print("building the arrangement from element eigenspaces ...", flush=True)
subs = set()
for A in G:
    if A == m.Id:
        continue
    o = m.order[A]
    z = m._root(o)
    for k in range(o):
        E = m.eigsp(A, pow(z, k, p))
        if E and len(E) < 5:
            subs.add(canon(E))
print(f"  from elements: {len(subs)} proper eigenspaces, dims "
      f"{sorted(set(len(U) for U in subs))}", flush=True)

while True:
    big = [U for U in subs if len(U) >= 2]
    new = set()
    for i, U in enumerate(big):
        for V in big[i + 1:]:
            X = m.inter(U, V)
            if X and len(X) < 5:
                X = canon(X)
                if X not in subs:
                    new.add(X)
    if not new:
        break
    subs |= new
    print(f"  intersection closure added {len(new)}", flush=True)
print("  A is closed under intersection: PASS", flush=True)

ARR = sorted(subs, key=lambda U: (len(U), U))
bydim = defaultdict(list)
for U in ARR:
    bydim[len(U)].append(U)
print(f"  ARRANGEMENT: {len(bydim[1])} lines (= points of P^4), "
      f"{len(bydim[2])} planes (= lines of P^4), {len(bydim[3])} 3-spaces "
      f"(= plus-planes); dim4: {len(bydim[4])}; total {len(ARR)}", flush=True)

AIDX = {U: i for i, U in enumerate(ARR)}
NA = len(ARR)

# --------------------------------------------------------------------------
# 2.  the G-action on A as permutations; setwise stabilisers
# --------------------------------------------------------------------------
print("permutation action ...", flush=True)
PERM = [tuple(AIDX[act_sp(g, U)] for U in ARR) for g in range(n)]
STAB = [frozenset(g for g in range(n) if PERM[g][i] == i) for i in range(NA)]
orbit_of, orbits = {}, []
for i in range(NA):
    if i in orbit_of:
        continue
    orb = frozenset(PERM[g][i] for g in range(n))
    for j in orb:
        orbit_of[j] = len(orbits)
    orbits.append(orb)
print(f"  {len(orbits)} G-orbits of arrangement elements, sizes "
      f"{sorted(len(o) for o in orbits)}", flush=True)

# --------------------------------------------------------------------------
# 3.  containment, chains
# --------------------------------------------------------------------------
print("containment + chains ...", flush=True)
inside = defaultdict(list)
for j, V in enumerate(ARR):
    if len(V) == 1:
        continue
    for i, U in enumerate(ARR):
        if len(U) < len(V) and contains(V, U):
            inside[j].append(i)
CH1 = [(i,) for i in range(NA)]
CH2 = [(i, j) for j in range(NA) for i in inside[j]]
CH3 = [(i, j, k) for k in range(NA) for j in inside[k] for i in inside[j]]
ALLCH = CH1 + CH2 + CH3
print(f"  chains: {len(CH1)} len-1, {len(CH2)} len-2, {len(CH3)} len-3; "
      f"total {len(ALLCH)}", flush=True)

# --------------------------------------------------------------------------
# 4.  subgroups
# --------------------------------------------------------------------------
MUL = [[Gidx[m.mm(G[a], G[b])] for b in range(n)] for a in range(n)]


def generate(gens):
    S, fr = {ID}, [ID]
    while fr:
        nf = []
        for a in fr:
            for b in gens:
                c = MUL[a][b]
                if c not in S:
                    S.add(c)
                    nf.append(c)
        fr = nf
    return frozenset(S)


_subc = {}


def subgroups(M):
    if M in _subc:
        return _subc[M]
    out, fr = {frozenset([ID])}, [frozenset([ID])]
    while fr:
        nf = []
        for K in fr:
            for g in M:
                if g in K:
                    continue
                L = generate(list(K) + [g])
                if L <= M and L not in out:
                    out.add(L)
                    nf.append(L)
        fr = nf
    res = sorted(out, key=lambda K: (len(K), sorted(K)))
    _subc[M] = res
    return res


# --------------------------------------------------------------------------
# 5.  scalar action / eigen-pieces on hi/lo, as LIFTED subspaces of W
# --------------------------------------------------------------------------
def scalar_on(lo, V, g):
    """the scalar by which g acts on V/lo, or None (lo assumed g-stable)."""
    A = G[g]
    L = perpm(lo)
    c = None
    for v in V:
        fv = None
        for f in L:
            t = sum(f[i] * v[i] for i in range(5)) % p
            if t:
                fv = (f, t)
                break
        if fv is None:
            continue                       # v is in lo
        w = m.act(A, v)
        f, t = fv
        cc = sum(f[i] * w[i] for i in range(5)) % p * m.inv(t) % p
        if c is None:
            c = cc
        elif cc != c:
            return None
        d = [(w[i] - c * v[i]) % p for i in range(5)]
        if any(sum(f2[i] * d[i] for i in range(5)) % p for f2 in L):
            return None
    return c


def solve_scalar(Pp, lo, g, c):
    """{v in Pp : (g - c) v in lo}, lifted."""
    A = G[g]
    rows = [tuple(sum(f[i] * ((A[i][j] - (c if i == j else 0)) % p)
                      for i in range(5)) % p for j in range(5))
            for f in perpm(lo)]
    rows += [list(x) for x in perpm(Pp)]
    ns = m.nullspace(rows)
    return canon(ns) if ns else ()


_eigc = {}


def eigen_pieces(lo, hi, K):
    key = (lo, hi, K)
    r = _eigc.get(key)
    if r is not None:
        return r
    pieces = [hi]
    for g in sorted(K):
        if g == ID:
            continue
        o = m.order[G[g]]
        z = m._root(o)
        new = []
        for Pp in pieces:
            for k in range(o):
                Q = solve_scalar(Pp, lo, g, pow(z, k, p))
                if Q and len(Q) > len(lo):
                    new.append(Q)
        pieces = new
    _eigc[key] = pieces
    return pieces


# --------------------------------------------------------------------------
# 6.  the census at a stage
# --------------------------------------------------------------------------
def stage_arr(j):
    out = set()
    for d in range(1, j + 1):
        out |= {AIDX[U] for U in bydim[d]}
    return out


_candc = {}


def candidates(lo, hi, AJ):
    """arrangement elements US in A_j with lo < US < hi (strictly)."""
    key = (lo, hi)
    r = _candc.get(key)
    if r is None:
        r = []
        for iu in range(NA):
            US = ARR[iu]
            if len(US) >= len(hi):
                continue
            if lo:
                if len(US) <= len(lo) or not contains(US, lo):
                    continue
            if len(hi) < 5 and not contains(hi, US):
                continue
            r.append(iu)
        _candc[key] = r
    return [ARR[i] for i in r if i in AJ]


def census(j, verbose=True):
    AJ = stage_arr(j)
    rows = []
    seen = set()
    chains = [ch for ch in ALLCH if all(i in AJ for i in ch)]
    if verbose:
        print(f"  stage {j}: {len(chains)} chains in A_{j}", flush=True)
    # empty chain
    rows.append(((), (FULL,), frozenset([ID]), frozenset(range(n)), 4))
    for i in range(NA):
        if i in AJ:
            continue
        U = ARR[i]
        K = frozenset(g for g in range(n) if scalar_on((), U, g) is not None)
        rows.append(((), (U,), K, STAB[i], len(U) - 1))
    for nch, ch in enumerate(chains):
        Ms = frozenset.intersection(*[STAB[i] for i in ch])
        flags = [()] + [ARR[i] for i in ch]
        his = [ARR[i] for i in ch] + [FULL]
        k = len(ch)
        cand = [candidates(flags[i], his[i], AJ) for i in range(k + 1)]
        for K in subgroups(Ms):
            eig = [eigen_pieces(flags[i], his[i], K) for i in range(k + 1)]
            if any(not e for e in eig):
                continue
            stack = [()]
            for i in range(k + 1):
                stack = [s + (Q,) for s in stack for Q in eig[i]]
            for sps in stack:
                cs = {}
                Kex = []
                for g in Ms:
                    v = [scalar_on(flags[i], sps[i], g) for i in range(k + 1)]
                    if all(x is not None for x in v):
                        Kex.append(g)
                        cs[g] = v
                Kex = frozenset(Kex)
                if Kex != K:
                    continue
                ks = sorted(K)
                chars = [tuple(cs[g][i] for g in ks) for i in range(k + 1)]
                if any(chars[i - 1] == chars[i] for i in range(1, k + 1)):
                    continue
                ok = True
                for i in range(k + 1):
                    for US in cand[i]:
                        if contains(US, sps[i]):
                            ok = False
                            break
                    if not ok:
                        break
                if not ok:
                    continue
                key = (tuple(ch), sps)
                if key in seen:
                    continue
                seen.add(key)
                sw = frozenset(g for g in Ms
                               if all(act_sp(g, sps[i]) == sps[i]
                                      for i in range(k + 1)))
                dim = sum(len(sps[i]) - len(flags[i]) - 1 for i in range(k + 1))
                rows.append((tuple(ch), sps, K, sw, dim))
        if verbose and (nch + 1) % 250 == 0:
            print(f"    ... {nch + 1}/{len(chains)} chains, {len(rows)} "
                  f"components", flush=True)
    return rows


def gname(K):
    q = len(K)
    if q == 1:
        return "1"
    ords = sorted(m.order[G[g]] for g in K)
    if q == 4:
        return "C4" if 4 in ords else "V4"
    if q == 6:
        return "C6" if 6 in ords else "S3"
    if q == 12:
        return "D12" if 6 in ords else "A4"
    if q == 10:
        return "C10" if 10 in ords else "D10"
    if q == 55:
        return "11:5"
    if q == 60:
        return "A5"
    if q == 660:
        return "PSL(2,11)"
    return f"C{q}"


def report(j, rows):
    bycls = defaultdict(lambda: defaultdict(int))
    swcls = defaultdict(int)
    for ch, sps, K, sw, dim in rows:
        bycls[gname(K)][dim] += 1
    allkeys = {(ch, sps) for ch, sps, K, sw, dim in rows}
    seen, norb, orbsz = set(), 0, defaultdict(int)
    bad = 0
    for ch, sps, K, sw, dim in rows:
        if (ch, sps) in seen:
            continue
        orb = set()
        for g in range(n):
            orb.add((tuple(PERM[g][i] for i in ch),
                     tuple(act_sp(g, S) for S in sps)))
        if any(o not in allkeys for o in orb):
            bad += 1
        if len(orb) * len(sw) != n:
            bad += 1
        seen |= orb
        norb += 1
        orbsz[len(orb)] += 1
        swcls[gname(sw)] += 1
    print(f"STAGE {j}: COMPONENTS = {len(rows)},  G-ORBITS = {norb}")
    for cls in sorted(bycls, key=lambda s: (len(s), s)):
        d = dict(sorted(bycls[cls].items()))
        print(f"    K = {cls:<6} by dim {d}   total {sum(d.values())}")
    print(f"    orbit sizes: {dict(sorted(orbsz.items()))}")
    print(f"    setwise stabiliser classes: {dict(sorted(swcls.items()))}")
    print(f"    orbit-closure / orbit-size anomalies: {bad}")
    return len(rows), norb


if __name__ == "__main__":
    for j in [int(x) for x in os.environ.get("STAGES", "0,1,2,3").split(",")]:
        report(j, census(j))
        print(flush=True)
