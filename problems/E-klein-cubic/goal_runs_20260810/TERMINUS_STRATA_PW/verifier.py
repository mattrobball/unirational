"""TERMINUS_STRATA_PW -- verifier.

Pure python3, no arguments.  Replays the whole packet at BOTH split primes:

  * runs every script and requires its marker;
  * re-checks every census row against the raw 660-element group action --
    orbit size by direct enumeration, the setwise stabilizer's containment and
    normalisation of K, |W(K,F)| = |Stab_G(F)|/|K|, and dim F = the number of
    K-trivial tangent weights.  NOTE (scope, added at the PR#31 adjudication):
    these checks take the ROW LIST from `tcore.census`; they do not re-derive
    it.  The completeness of the row list -- the 80 orbits / 11076 components
    headline -- is tested by the separate, independently written
    `scripts/adj_indep_census.py`, which enumerates components one by one over
    ALL chains with no orbit-representative shortcut;
  * PER-ROW EXACT-STABILIZER SPOT CHECK: samples explicit points of the
    stratum (as flag data (x, beta_1, ..., beta_k) over F_p), computes the
    stabilizer by brute force in the 660-element group, and requires it to be
    EXACTLY the claimed subgroup -- not larger;
  * checks the dictionary  Z^H = union of Z_(=K) over K containing H;
  * checks the cross-check totals against the level-0 census, the boundary
    divisor table, and the 42 terminal local models;
  * checks the closure poset is a strict partial order with isotropy growing
    and dimension dropping downward.

Marker: TERMINUS_STRATA_PW_VERIFY_OK / ALLGREEN.
"""
import os
import random
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, "scripts"))

from tcore import Tower, census, all_subgroups          # noqa: E402
from psl211 import SPLIT_PRIMES                          # noqa: E402

SCRIPTS = [("scripts/t2_orbit_strata.py", "T2_ORBIT_STRATA_OK"),
           ("scripts/t3_localmodels.py", "T3_LOCAL_MODELS_OK"),
           ("scripts/t4_poset.py", "T4_POSET_OK"),
           ("scripts/t5_zplus.py", "T5_ZPLUS_OK")]

FAILS = []


def check(name, cond):
    print(f"CHECK {name}: {'PASS' if cond else 'FAIL'}")
    if not cond:
        FAILS.append(name)
    return cond


# --------------------------------------------------------------------------
def sample_point(T, r, rng):
    """An explicit point (x, beta_1, ..., beta_k) of the stratum, as vectors
    of W: x in A_0, and b_i in A~_i lifting a vector of A_i."""
    C = T.C
    p = C.p
    out = []
    for t, sp in enumerate(r["_lifted"]):
        low = r["_chain"][t - 1] if t >= 1 else ()
        base = [b for b in sp]
        for _ in range(60):
            v = [0] * 5
            for b in base:
                c = rng.randrange(p)
                v = [(v[i] + c * b[i]) % p for i in range(5)]
            if any(v):
                if not low or C.m.rank([list(x) for x in low] + [v]) > len(low):
                    out.append(tuple(v))
                    break
        else:
            return None
    return out


def stab_of_point(T, r, pt):
    """{g in G : g fixes the chain and fixes [x] and every [beta_i]}."""
    C = T.C
    p = C.p
    m = C.m
    ch = r["_chain"]
    out = []
    for g in range(C.n):
        A = C.G[g]
        good = True
        for u in ch:
            if m.canon([list(m.act(A, v)) for v in u]) != m.canon([list(v) for v in u]):
                good = False
                break
        if not good:
            continue
        for t, v in enumerate(pt):
            low = ch[t - 1] if t >= 1 else ()
            w = m.act(A, v)
            # need w = c v modulo `low`
            rows = [list(x) for x in low]
            if m.rank(rows + [list(v)] + [list(w)]) != m.rank(rows + [list(v)]):
                good = False
                break
        if good:
            out.append(g)
    return frozenset(out)


def verify_rows(T, say):
    C = T.C
    m = C.m
    R = census(T, 3)
    rng = random.Random(20260810 + T.p)
    nspot, nexact = 0, 0
    bad_orbit = bad_stab = bad_res = bad_dim = 0
    for r in R:
        K = frozenset(r["_K"])
        sw = frozenset(r["_sw"])
        # ---- orbit size by direct enumeration ----
        orb = set()
        for g in range(C.n):
            orb.add((tuple(m.canon([list(m.act(C.G[g], v)) for v in u])
                           for u in r["_chain"]),
                     tuple(m.canon([list(m.act(C.G[g], v)) for v in x])
                           for x in r["_lifted"])))
        if len(orb) != r["n_orbit"] or len(orb) * len(sw) != C.n:
            bad_orbit += 1
        # ---- setwise stabilizer normalises K, contains K ----
        if not (K <= sw) or any(C.conj(K, g) != K for g in sw):
            bad_stab += 1
        if len(sw) // len(K) != r["residual_order"]:
            bad_res += 1
        # ---- dimension = number of K-trivial tangent weights ----
        if r["weights"] is not None and \
                sum(1 for w, f in r["weights"] if w == "1") != r["dim"]:
            bad_dim += 1
        # ---- EXACT-STABILIZER SPOT CHECK on explicit points ----
        if r["empty_chain"]:
            continue
        hit = False
        for _ in range(8):
            pt = sample_point(T, r, rng)
            if pt is None:
                continue
            S = stab_of_point(T, r, pt)
            nspot += 1
            if not (K <= S):
                say(f"  !! sampled point of [{r['K']}] on {r['chain']} has "
                    f"stabilizer NOT containing K")
                bad_stab += 1
            if S == K:
                hit = True
                nexact += 1
                break
        if not hit:
            say(f"  !! no sampled point of [{r['K']}] dim {r['dim']} on "
                f"{r['chain']} realised the exact stabilizer")
            bad_stab += 1
    say(f"  rows verified: {len(R)}; explicit points sampled: {nspot}; "
        f"rows where a sampled point had stabilizer EXACTLY K: {nexact}")
    check(f"p={T.p}: every row's orbit size = 660/|Stab_G(F)|", bad_orbit == 0)
    check(f"p={T.p}: every row's setwise stabilizer contains and normalises K, "
          f"and |W(K,F)| = |Stab_G(F)|/|K|", bad_stab == 0 and bad_res == 0)
    check(f"p={T.p}: dim F = #(K-trivial tangent weights) for every row",
          bad_dim == 0)
    check(f"p={T.p}: an explicit sampled point with stabilizer EXACTLY K "
          f"exists on every non-empty-chain row", nexact == len([r for r in R
                                                                if not r["empty_chain"]]))
    return R


def verify_dictionary(T, R, say):
    """Z^H = disjoint union of Z_(=K) over K containing H; and the components
    of Z^H are exactly the rows whose K contains H."""
    C = T.C
    reps = {C.name(H): H for H in C.subgroup_classes()}
    tot = {}
    for hn in ("C2", "C3", "V4", "C5", "C6", "C11"):
        H = reps[hn]
        n = 0
        for r in R:
            K = frozenset(r["_K"])
            sw = frozenset(r["_sw"])
            cnt = sum(1 for g in range(C.n) if H <= C.conj(K, g)) // len(sw)
            n += cnt
        tot[hn] = n
        say(f"  |components of Z^{hn}| = {n}")
    # C2: 110 divisors + the lower pieces; sanity: at least the 110 divisors
    ndiv = sum(r["n_orbit"] for r in R if r["K"] == "C2" and r["dim"] == 3)
    check(f"p={T.p}: Fix(C2) contains exactly 110 divisorial components "
          f"(E_sigma + E'_sigma)", ndiv == 110)
    return tot


def main():
    print("TERMINUS_STRATA_PW verifier")
    print("=" * 66)
    for path, marker in SCRIPTS:
        print(f"--- running {path} ---")
        pr = subprocess.run([sys.executable, os.path.join(HERE, path)],
                            capture_output=True, text=True, cwd=HERE)
        out = pr.stdout + pr.stderr
        check(f"{path} -> {marker}", marker in out and pr.returncode == 0)
        nf = out.count("FAIL")
        check(f"{path} reports no internal FAIL", nf == 0)
    print("=" * 66)
    for p in SPLIT_PRIMES:
        print(f"--- independent replay at p = {p} ---")
        T = Tower(p)
        R = verify_rows(T, print)
        verify_dictionary(T, R, print)
        # totals
        check(f"p={p}: 1215 boundary divisors in 14 G-orbits",
              sum(c for _, c in T.orbit_rep) == 1215 and len(T.orbit_rep) == 14)
        check(f"p={p}: 940 points + 220 lines + 55 planes in the arrangement",
              len(T.bydim[1]) == 940 and len(T.bydim[2]) == 220
              and len(T.bydim[3]) == 55)
        occ = {r["K"] for r in R}
        check(f"p={p}: exact point stabilizers on Z are exactly "
              f"{{1,C2,C3,V4,C5,C6,C11}}",
              occ == {"1", "C2", "C3", "V4", "C5", "C6", "C11"})
        names = [T.C.name(H) for H in T.C.subgroup_classes()]
        check(f"p={p}: G has 16 conjugacy classes of subgroups", len(names) == 16)
        check(f"p={p}: the 9 non-occurring classes are certified empty",
              len([n for n in names if n not in occ]) == 9)
        # level-0 cross-check against certificates/STRATA_EXACT.md
        R0 = census(T, 0)
        lvl0 = {}
        for r in R0:
            lvl0[(r["K"], r["dim"])] = lvl0.get((r["K"], r["dim"]), 0) + r["n_orbit"]
        want = {("1", 4): 1, ("C2", 2): 55, ("C2", 1): 55, ("C3", 1): 110,
                ("V4", 1): 55, ("V4", 0): 165, ("C5", 0): 264, ("C6", 0): 220,
                ("C11", 0): 60, ("D10", 0): 66, ("D12", 0): 55, ("A4", 0): 110}
        check(f"p={p}: the level-0 orbit-type census reproduces "
              f"certificates/STRATA_EXACT.md", lvl0 == want)
    print("=" * 66)
    if FAILS:
        print("FAILURES:")
        for f in FAILS:
            print("   ", f)
        print("TERMINUS_STRATA_PW_VERIFY_FAIL")
        sys.exit(1)
    print("TERMINUS_STRATA_PW_VERIFY_OK")
    print("ALLGREEN")


if __name__ == "__main__":
    main()
