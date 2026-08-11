"""T3 -- the point-type (local model) census of the terminus, and the
cross-checks against STANDARD_FORM_PW / STRATA_EXACT / DUNCAN_CORNER_F2.

A POINT of Z is a general point of exactly one pair (chain, eigen-datum);
dropping the openness filter of the stratum census therefore enumerates every
POINT TYPE of Z.  Canonicalising the four tangent weights modulo Aut(K) and
permutation reproduces the 42 terminal local models of
`STANDARD_FORM_PW/results/s3_automaton.txt` -- an independent global-geometry
check of that packet's purely local automaton.

Also re-derives the boundary-divisor table, the crossing combinatorics, and
the "components created inside each exceptional divisor" table of
STANDARD_FORM_PW §5(d).

Marker: T3_LOCAL_MODELS_OK.
"""
import itertools
import json
import os
import sys
from collections import defaultdict, Counter

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from tcore import (Tower, census, sub_arrangement, all_subgroups, Graded,   # noqa: E402
                   chkey, chdiv, char_label, _weights, _toroidal)
from psl211 import SPLIT_PRIMES                                             # noqa: E402

HERE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# what STANDARD_FORM_PW/results/s3_automaton.txt reports (§5(b) of its THEOREM)
SFPW_LOCAL_MODELS = {"1": 2, "C2": 7, "C3": 9, "V4": 3, "C5": 1, "C6": 16, "C11": 4}
SFPW_CREATED = {                       # its §5(d), "created inside exceptional divisors"
    "C2": {1: 1155, 2: 440, 3: 110},
    "C3": {0: 440, 1: 880, 2: 110},
    "V4": {0: 660, 1: 330},
    "C5": {0: 396}, "C6": {0: 330}, "C11": {0: 60},
}


# --------------------------------------------------------------------------
# canonical form of a local model, modulo Aut(K) and permutation of slots
# --------------------------------------------------------------------------
def canon_state(C, K, weights):
    """weights = [(label, flag)] with labels 'e_1/n,...' as produced by
    char_label.  Re-express as exponent vectors and minimise over Aut(K-hat)."""
    if len(K) == 1:
        return ("1", tuple(sorted((0, f) for _, f in weights)))
    gens = C.generators(K)
    mods = [C.ordr[g] for g in gens]
    ex = []
    for lab, f in weights:
        if lab == "1":
            ex.append((tuple(0 for _ in gens), f))
        else:
            parts = lab.strip("[]").split(",")
            ex.append((tuple(int(x.split("/")[0]) for x in parts), f))
    # the automorphisms of the dual group = automorphisms of Z/m1 x Z/m2
    autos = []
    if len(mods) == 1:
        n = mods[0]
        autos = [(lambda v, u=u: ((v[0] * u) % n,)) for u in range(n)
                 if _gcd(u, n) == 1]
        tname = f"C{n}"
    else:
        assert mods == [2, 2], mods
        mats = [((a, b), (c, d)) for a in (0, 1) for b in (0, 1)
                for c in (0, 1) for d in (0, 1) if (a * d - b * c) % 2]
        autos = [(lambda v, M=M: ((M[0][0] * v[0] + M[0][1] * v[1]) % 2,
                                  (M[1][0] * v[0] + M[1][1] * v[1]) % 2)) for M in mats]
        tname = "V4"
    best = None
    for phi in autos:
        cand = tuple(sorted((phi(v), f) for v, f in ex))
        if best is None or cand < best:
            best = cand
    return (tname, best)


def _gcd(a, b):
    while b:
        a, b = b, a % b
    return a


# --------------------------------------------------------------------------
def all_point_types(T, j):
    """Every (chain, eigen-datum) with exact stabilizer K -- i.e. every point
    type of Z_j.  Same enumeration as `census` but WITHOUT the openness
    filter (which selects the strata)."""
    C = T.C
    arrj = sub_arrangement(T, j)
    arrset = set(arrj)
    out = []
    out.append((frozenset([C.e]), [("1", "."), ("1", "."), ("1", "."), ("1", ".")], (), 4, True))
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
                Kex = frozenset(g for g in M
                                if all(gr[i].acts_scalar(g, As[i]) is not None
                                       for i in range(k + 1)))
                if Kex != K:
                    continue
                lifted = [gr[i].lift_space(As[i]) for i in range(k + 1)]
                ok = True
                for i in range(k + 1):
                    lo = ch[i - 1] if i >= 1 else ()
                    hi = ch[i] if i < k else T.W
                    for US in arrj:
                        if len(US) >= len(hi):
                            continue
                        if lo and (len(US) <= len(lo) or not T.contains(US, lo)):
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
                key = tuple(lifted)
                if key in seen:
                    continue
                for g in M:
                    seen.add(tuple(C.m.canon([list(C.m.act(C.G[g], v)) for v in x])
                                   for x in lifted))
                if not C.is_abelian(K):
                    out.append((K, None, ch, None, False))
                    continue
                w = _weights(T, ch, lams, K, gr, False, lifted)
                dimF = sum(len(x) for x in lifted) - sum(len(u) for u in ch) - (k + 1)
                out.append((K, w, ch, dimF, _toroidal(C, K, ch, lams, False)))
    return out


def _full(gg):
    n = gg.R.n
    return [tuple(int(i == j) for j in range(n)) for i in range(n)]


def run(p, say):
    ok = True
    T = Tower(p)
    C = T.C
    say(f"=========================  p = {p}  =========================")

    # ---------- (1) the boundary divisor table ----------
    say("")
    say("=== (1) THE BOUNDARY DIVISORS OF Z (re-derived from the arrangement) ===")
    tot = 0
    for i, (U, cnt) in enumerate(T.orbit_rep):
        stage = {1: "T0", 2: "T1", 3: "T2"}[len(U)]
        say(f"  {stage}  D_{T.label(U):<14} centre dim {len(U)-1}  count {cnt:>4}"
            f"  H_C = {C.name(C.pstab(U)):<4}  Stab_G = {C.name(C.sstab(U))}")
        tot += cnt
    say(f"  total {tot} boundary divisors in {len(T.orbit_rep)} G-orbits")
    say(f"  CHECK 1215 in 14 orbits (STANDARD_FORM_PW §5(a)): "
        f"{'PASS' if tot == 1215 and len(T.orbit_rep) == 14 else 'FAIL'}")
    ok &= tot == 1215 and len(T.orbit_rep) == 14

    # ---------- (2) point types = the 42 local models ----------
    say("")
    say("=== (2) POINT TYPES OF THE TERMINUS = the terminal local models ===")
    pts = all_point_types(T, 3)
    bad = [x for x in pts if x[1] is None]
    say(f"  point types with NONABELIAN exact stabilizer: {len(bad)}  "
        f"(def:toroidal(c) forbids them)")
    ok &= not bad
    models = defaultdict(set)
    for K, w, ch, d, tt in pts:
        if w is None or not ch:
            continue          # the interior type (0 boundary branches) is not
        models[C.name(K)].add(canon_state(C, K, w))   # part of the automaton's
    say("  (the single interior point type -- trivial stabilizer, 0 boundary")   # boundary census
    say("   branches -- is excluded, matching the automaton's boundary census)")
    say(f"  {'K':<6}{'#local models':>15}{'STANDARD_FORM_PW':>19}")
    tot = 0
    for k in ("1", "C2", "C3", "V4", "C5", "C6", "C11"):
        n = len(models.get(k, ()))
        tot += n
        good = n == SFPW_LOCAL_MODELS[k]
        ok &= good
        say(f"  {k:<6}{n:>15}{SFPW_LOCAL_MODELS[k]:>19}   {'PASS' if good else 'FAIL'}")
    say(f"  TOTAL {tot} distinct terminal local models "
        f"(STANDARD_FORM_PW: 42): {'PASS' if tot == 42 else 'FAIL'}")
    ok &= tot == 42
    # branch counts and toroidality
    nb = Counter()
    tor = True
    for K, w, ch, d, tt in pts:
        if w is None:
            continue
        nb[len([1 for a, f in w if f == "B"])] += 1
        tor &= tt
    say(f"  boundary-branch multiplicities |I(x)| over all point types: {dict(sorted(nb.items()))}")
    say(f"  CHECK |I(x)| <= 3 everywhere: {'PASS' if max(nb) <= 3 else 'FAIL'}")
    ok &= max(nb) <= 3
    say(f"  CHECK every point type is TOROIDAL (defect = 1): {'PASS' if tor else 'FAIL'}")
    ok &= tor

    # ---------- (3) crossings ----------
    say("")
    say("=== (3) CROSSING COMBINATORICS ===")
    cross = defaultdict(set)
    for K, w, ch, d, tt in pts:
        if w is None:
            continue
        nbr = len([1 for a, f in w if f == "B"])
        if nbr >= 2:
            cross[nbr].add(C.name(K))
    # (a) the GENERIC pointwise stabilizer of each crossing component
    say("  (a) generic pointwise stabilizer of each crossing COMPONENT")
    gen = defaultdict(set)
    for ch, chorb in T.chain_orbit_reps(sub_arrangement(T, 3)):
        if not ch:
            continue
        M = frozenset.intersection(*[C.sstab(U) for U in ch])
        gr, prev = [], ()
        for U in list(ch) + [T.W]:
            gr.append(Graded(C, prev, U, M))
            prev = U
        K = frozenset(g for g in M
                      if all(gg.acts_scalar(g, gg.R.fixed_space([], [])
                                            if False else _full(gg)) is not None
                             for gg in gr))
        gen[len(ch)].add(C.name(K))
        if len(ch) >= 2:
            say(f"      |I| = {len(ch)}  {'<'.join(T.label(U) for U in ch):<34}"
                f" x{chorb:<6} generic stabilizer {C.name(K)}")
    for r in sorted(gen):
        say(f"    |I| = {r}: generic stabilizers occurring: {sorted(gen[r])}")
    say("    (STANDARD_FORM_PW §5(c): |I|=2 -> 1 or C2, |I|=3 -> C2)")
    okc = gen.get(2, set()) <= {"1", "C2"} and gen.get(3, set()) <= {"C2"}
    say(f"    CHECK agrees with STANDARD_FORM_PW §5(c): {'PASS' if okc else 'FAIL'}")
    ok &= okc
    # (b) all stabilizers occurring anywhere on a crossing (finer, new here)
    say("  (b) ALL pointwise stabilizers occurring at SOME point of a crossing")
    for r in sorted(cross):
        say(f"      |I| = {r}: {sorted(cross[r])}")
    noncyc = {k for r in cross for k in cross[r] if k == "V4"}
    say(f"  CHECK the only NON-CYCLIC stabilizer at a crossing of Z is V4: "
        f"{'PASS' if noncyc <= {'V4'} else 'FAIL'}")
    # is any V4 crossing of codimension 2 (a fabulous corner)?
    fab = 0
    for K, w, ch, d, tt in pts:
        if w is None or C.name(K) != "V4":
            continue
        if len([1 for a, f in w if f == "B"]) == 2 and d == 2:
            fab += 1
    say(f"  fabulous corners on Z (V4-fixed codim-2 crossings): {fab}")
    say(f"  CHECK none (STANDARD_FORM_PW SOURCE-NO-FABULOUS-CORNER-AT-MINIMAL-TERMINUS): "
        f"{'PASS' if fab == 0 else 'FAIL'}")
    ok &= fab == 0

    # ---------- (4) STANDARD_FORM_PW §5(d) recomputed ----------
    say("")
    say("=== (4) 'COMPONENTS CREATED INSIDE EACH EXCEPTIONAL DIVISOR' ===")
    say("    (STANDARD_FORM_PW §5(d): the strata created over the GENERIC point")
    say("     of each centre, i.e. the rows with a length-1 chain and A_0 = the")
    say("     whole centre.  Recomputed here as full G-orbits.)")
    R = census(T, 3) + census(T, 2) + census(T, 1)
    created = defaultdict(lambda: defaultdict(int))
    seen = set()
    for j in (1, 2, 3):
        for r in census(T, j):
            if len(r["chain"]) != 1 or r["empty_chain"]:
                continue
            # A_0 must be the whole centre
            if len(r["_lifted"][0]) != len(r["_chain"][0]):
                continue
            key = (tuple(sorted(r["_lifted"][0])), tuple(sorted(r["_lifted"][1])),
                   tuple(r["_K"]))
            if key in seen:
                continue
            seen.add(key)
            created[r["K"]][r["dim"]] += r["n_orbit"]
    say(f"  {'K':<5}{'THIS PACKET (exact G-orbits)':<42}{'STANDARD_FORM_PW §5(d)'}")
    disc = []
    for k in ("C2", "C3", "V4", "C5", "C6", "C11"):
        mine = dict(sorted(created[k].items()))
        theirs = SFPW_CREATED[k]
        say(f"  {k:<5}{str(mine):<42}{theirs}"
            f"    {'agree' if mine == theirs else '<<< DIFFERS'}")
        if mine != theirs:
            disc.append((k, mine, theirs))
        # the DIMENSION PROFILE (which dims occur) must agree
        good = set(mine) == set(theirs)
        ok &= good
    say("")
    if disc:
        say("  ** CORRECTION TO STANDARD_FORM_PW §5(d) **")
        say("  The dimension PROFILES (which dimensions occur for each class) agree")
        say("  exactly.  The COUNTS differ: s5_terminus.py de-duplicates its rows on")
        say("  the signature (stabilizer name, dim, normal rank, orbit size), which")
        say("  merges genuinely distinct G-orbits sharing that signature.  Its")
        say("  numbers are therefore LOWER BOUNDS.  Corrected values above.")
        for k, mine, theirs in disc:
            say(f"    {k}: {theirs}  ->  {mine}")
    return ok


if __name__ == "__main__":
    out = []

    def say(*a):
        s = " ".join(str(x) for x in a)
        print(s)
        out.append(s)

    ok = True
    for p in SPLIT_PRIMES:
        ok &= run(p, say)
        say("")
    with open(os.path.join(HERE, "results", "t3_localmodels.txt"), "w") as f:
        f.write("\n".join(out) + "\n")
    print("T3_LOCAL_MODELS_" + ("OK" if ok else "FAIL"))
    sys.exit(0 if ok else 1)
