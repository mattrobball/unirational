"""T4 -- the closure poset of the orbit-type strata of the terminus.

`closure(Z_{=K'} component F') contains F` iff the chain of F refines that of
F' and the eigen-data of F is contained in the data INDUCED from F' along the
refinement.  The induction rule (derived in THEOREM.md §2.4): inserting `U_j`
between `U_{j-1}` and `U_{j+1}` splits the datum `A'` living in
`U_{j+1}/U_{j-1}` into

    A_{j-1} = A' cap (U_j/U_{j-1})     and     A_j = image of A' in U_{j+1}/U_j ,

i.e. in terms of the lifted subspaces of W:  Ind_r = (A'~ cap U_{r+1}) + U_r .

Reported at G-orbit level: (K,F) <= (K',F') iff some G-translate of F lies in
F' (equivalently K' ⊆ K up to conjugacy, and the data is induced).
Marker: T4_POSET_OK.
"""
import json
import os
import sys
from collections import defaultdict

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from tcore import Tower, census, sub_arrangement            # noqa: E402
from psl211 import SPLIT_PRIMES                             # noqa: E402

HERE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def rowname(T, r, i):
    ch = "<".join(r["chain"]) if r["chain"] else "(off D)"
    return f"#{i:02d} [{r['K']}] dim {r['dim']} x{r['n_orbit']} on {ch}"


def induced(T, chain, dat, chainF):
    """The data of F' (chain `chain`, lifted subspaces `dat`) induced along the
    finer chain `chainF`.  Returns the list of lifted subspaces, or None."""
    m = T.m
    Up = [()] + list(chain) + [T.W]        # U'_0 .. U'_{m+1}
    U = [()] + list(chainF) + [T.W]
    out = []
    for r in range(len(chainF) + 1):
        lo, hi = U[r], U[r + 1]
        t = None
        for s in range(len(chain) + 1):
            a, b = Up[s], Up[s + 1]
            if (not a or T.contains(lo, a)) and T.contains(b, hi):
                t = s
                break
        if t is None:
            return None
        inter = m.inter(dat[t], hi) if dat[t] and hi else ()
        rows = [list(x) for x in inter] + [list(x) for x in lo]
        out.append(m.canon(rows) if rows else ())
    return out


def run(p, say):
    ok = True
    T = Tower(p)
    C = T.C
    R = census(T, 3)
    R.sort(key=lambda r: (-r["dim"], r["K_order"], tuple(r["chain"])))
    say(f"=========================  p = {p}  =========================")
    say(f"the terminus has {len(R)} G-orbits of orbit-type strata; "
        f"{sum(r['n_orbit'] for r in R)} components in all")

    # index every G-translate of every row by its chain
    bychain = defaultdict(list)
    for i, r in enumerate(R):
        seen = set()
        for g in range(C.n):
            ch = tuple(C.m.canon([list(C.m.act(C.G[g], v)) for v in u])
                       for u in r["_chain"])
            dat = tuple(C.m.canon([list(C.m.act(C.G[g], v)) for v in x])
                        for x in r["_lifted"])
            if (ch, dat) in seen:
                continue
            seen.add((ch, dat))
            bychain[ch].append((i, ch, dat))
        if len(seen) != r["n_orbit"]:
            say(f"  !! FAIL orbit size {len(seen)} != {r['n_orbit']} for {rowname(T,r,i)}")
            ok = False

    def subchains(ch):
        out = [()]
        n = len(ch)
        for msk in range(1, 1 << n):
            out.append(tuple(ch[b] for b in range(n) if msk >> b & 1))
        return out

    rel = defaultdict(set)          # i -> { j : F_i is inside F_j }
    mult = {}
    for i, r in enumerate(R):
        chF = tuple(r["_chain"])
        datF = [C.m.canon([list(v) for v in x]) for x in r["_lifted"]]
        for sc in subchains(chF):
            for (j, ch, dat) in bychain.get(sc, ()):
                if j == i:
                    continue
                ind = induced(T, ch, dat, chF)
                if ind is None:
                    continue
                if all(T.contains(ind[t], datF[t]) for t in range(len(chF) + 1)):
                    rel[i].add(j)
                    mult[(i, j)] = mult.get((i, j), 0) + 1
    # the free stratum contains everything (its closure is Z)
    free = next(i for i, r in enumerate(R) if r["K"] == "1")
    for i in range(len(R)):
        if i != free:
            rel[i].add(free)

    say("")
    say("=== CLOSURE POSET  (K,F) <= (K',F')  iff  F is contained in F'   ===")
    say("=== listed as: each stratum orbit, then the orbits whose closure  ===")
    say("=== contains it (its COVERS are marked *)                         ===")
    for i, r in enumerate(R):
        ups = sorted(rel[i], key=lambda j: (R[j]["dim"], R[j]["K_order"]))
        cov = [j for j in ups if not any(j in rel[k] for k in ups if k != j)]
        say(f"  {rowname(T, r, i)}")
        if not ups:
            say("      (maximal)")
        for j in ups:
            star = "*" if j in cov else " "
            say(f"      {star}  <  {rowname(T, R[j], j)}"
                f"   [{mult.get((i,j),0)} translate(s) of it contain it]")
    # sanity: the order is a partial order (no 2-cycles), and K grows downwards
    for i in rel:
        for j in rel[i]:
            if i in rel.get(j, ()):
                ok = False
                say(f"  !! FAIL cycle {i} <-> {j}")
            if R[i]["K_order"] % R[j]["K_order"]:
                ok = False
                say(f"  !! FAIL {R[j]['K']} does not divide {R[i]['K']}")
            if R[i]["dim"] > R[j]["dim"]:
                ok = False
                say(f"  !! FAIL dim increases downward")
    # consistency: for each row with stabilizer K and each subgroup H < K, the
    # component of Z^H through the row is unique (Z^H smooth => components disjoint)
    say("")
    say("=== CONSISTENCY: uniqueness of the ambient Z^H component ===")
    from tcore import all_subgroups
    bad = 0
    for i, r in enumerate(R):
        K = frozenset(r["_K"])
        for H in all_subgroups(C, K):
            if len(H) == 1:
                continue
            hosts = [j for j in rel[i] if H <= frozenset(R[j]["_K"])] + \
                    ([i] if True else [])
            # F itself is a component of Z^H iff its own stabilizer contains H
            # (always true here); the *containing* strata with H in their
            # stabilizer must form a chain
            hs = [j for j in rel[i] if H <= frozenset(R[j]["_K"])]
            for a in hs:
                for b in hs:
                    if a != b and b not in rel[a] and a not in rel[b]:
                        bad += 1
    say(f"  incomparable pairs of H-fixed strata above a common stratum: {bad}")
    say(f"  CHECK Z^H components are pairwise disjoint (0 expected): "
        f"{'PASS' if bad == 0 else 'FAIL'}")
    ok &= bad == 0

    say("")
    say(f"CHECK the relation is a strict partial order, isotropy grows downward, "
        f"dimension drops downward: {'PASS' if ok else 'FAIL'}")

    # ---- which strata meet which crossings ----
    say("")
    say("=== WHICH STRATA MEET WHICH CROSSINGS ===")
    say("(a stratum whose own chain has length k lies IN a k-fold crossing; it")
    say(" MEETS the deeper crossings of the strata below it in the poset)")
    for i, r in enumerate(R):
        own = "<".join(r["chain"]) if r["chain"] else "(off D)"
        deeper = sorted({"<".join(R[j]["chain"]) for j in range(len(R))
                         if i in rel.get(j, ()) and len(R[j]["chain"]) > len(r["chain"])})
        say(f"  {rowname(T, r, i)}")
        say(f"      lies in the |I| = {len(r['chain'])} crossing {own}")
        if deeper:
            say(f"      meets deeper crossings: {', '.join(deeper)}")
    return ok, R, rel


if __name__ == "__main__":
    out = []

    def say(*a):
        s = " ".join(str(x) for x in a)
        print(s)
        out.append(s)

    ok = True
    dump = {}
    for p in SPLIT_PRIMES:
        o, R, rel = run(p, say)
        ok &= o
        dump[str(p)] = {"rows": [rowname(None, r, i) for i, r in enumerate(R)],
                        "below": {str(i): sorted(rel[i]) for i in sorted(rel)}}
        say("")
    with open(os.path.join(HERE, "results", "t4_poset.txt"), "w") as f:
        f.write("\n".join(out) + "\n")
    with open(os.path.join(HERE, "results", "t4_poset.json"), "w") as f:
        json.dump(dump, f, indent=1)
    print("T4_POSET_" + ("OK" if ok else "FAIL"))
    sys.exit(0 if ok else 1)
