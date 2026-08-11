"""T5 (appendix) -- the census DELTA  Z -> Z+  for the corner refinement.

`DUNCAN_CORNER_F2`'s T3 blows up the 165 surfaces `M_tau^V = P(N_{ell_V} cap
W_tau^-)` inside `E_V`.  On the terminus `Z` of this packet that surface is a
stratum row of its own: exact stabilizer `<tau> = C2`, dim 2, 165 components,
`Stab_G = V4`, sitting on the single boundary branch `D_{ell_V}`.

This script

  1. identifies that row and checks it against DUNCAN_CORNER_F2's data;
  2. checks that the 165 copies are pairwise DISJOINT on Z (so the blowup is
     legal in one round) -- the corner packet's W2 separation, re-derived;
  3. lists the strata contained in M (the poset restricted below it);
  4. computes the normal bundle N_M along each of them as a module over the
     stratum's own stabilizer, and applies FIX_I_bcomplex Theorem 2.1 to get
     the DELTA: which rows are consumed, which survive, which are new;
  5. verifies that the new crossing `E_tau^V cap D_{P_z}` has pointwise
     stabilizer V4 -- the 330 fabulous corners, 2 G-orbits of 165.

Marker: T5_ZPLUS_OK.
"""
import os
import sys
from collections import defaultdict

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from tcore import (Tower, census, chkey, chdiv, char_label, all_subgroups,   # noqa: E402
                   Graded, sub_arrangement)
from t4_poset import induced                                                 # noqa: E402
from psl211 import SPLIT_PRIMES                                              # noqa: E402

HERE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def run(p, say):
    ok = True
    T = Tower(p)
    C = T.C
    m = C.m
    R = census(T, 3)
    say(f"=========================  p = {p}  =========================")

    # ---------- 1. the T3 centre as a row of the terminus census ----------
    cand = [r for r in R if r["K"] == "C2" and r["dim"] == 2
            and r["chain"] == ["ell_V"] and r["n_orbit"] == 165]
    say("")
    say("=== 1. THE T3 CENTRE M_tau^V AS A ROW OF THE TERMINUS CENSUS ===")
    say(f"  rows with K = C2, dim 2, 165 components, on D_ell_V: {len(cand)}")
    good = len(cand) == 1 and cand[0]["setwise"] == "V4"
    r0 = cand[0]
    say(f"    K = {r0['K']}   dim {r0['dim']}   #components {r0['n_orbit']}"
        f"   Stab_G(M) = {r0['setwise']}   W(K,M) = {r0['residual']}")
    say(f"    weights at a general point: "
        f"{[(a, f) for a, f in r0['weights']]}")
    say(f"  CHECK matches DUNCAN_CORNER_F2 (165 surfaces, G_M = <tau> = C2, "
        f"Stab_G = V4): {'PASS' if good else 'FAIL'}")
    ok &= good
    # its normal bundle: the two nontrivial weights
    nb = [(a, f) for a, f in r0["weights"] if a != "1"]
    iso = len({a for a, f in nb}) == 1
    say(f"  normal bundle N_M as a <tau>-module: {nb}")
    say(f"  CHECK N_M is <tau>-ISOTYPIC (Lemma B => G_{{E_tau^V}} = <tau>): "
        f"{'PASS' if iso and len(nb) == 2 else 'FAIL'}")
    ok &= iso and len(nb) == 2
    say(f"  CHECK exactly one of the two normal directions is a boundary branch "
        f"(D_ell_V): {'PASS' if sorted(f for a, f in nb) == ['.', 'B'] else 'FAIL'}")
    ok &= sorted(f for a, f in nb) == [".", "B"]

    # ---------- 2. disjointness of the 165 copies on Z ----------
    say("")
    say("=== 2. ARE THE 165 SURFACES M_tau^V PAIRWISE DISJOINT ON Z ? ===")
    copies = set()
    for g in range(C.n):
        copies.add((tuple(m.canon([list(m.act(C.G[g], v)) for v in u])
                          for u in r0["_chain"]),
                    tuple(m.canon([list(m.act(C.G[g], v)) for v in x])
                          for x in r0["_lifted"])))
    copies = sorted(copies)
    say(f"  number of copies: {len(copies)}")
    ok &= len(copies) == 165
    # two copies meet iff some stratum of Z lies in both; test via the poset rule
    meets = 0
    for i, r in enumerate(R):
        chF = tuple(r["_chain"])
        datF = [m.canon([list(v) for v in x]) for x in r["_lifted"]]
        hit = 0
        for ch, dat in copies:
            if not set(ch) <= set(chF):
                continue
            ind = induced(T, ch, dat, chF)
            if ind is None:
                continue
            if all(T.contains(ind[t], datF[t]) for t in range(len(chF) + 1)):
                hit += 1
        if hit >= 2:
            meets += 1
    say(f"  stratum orbits lying inside TWO OR MORE of the 165 copies: {meets}")
    say(f"  CHECK the copies are pairwise disjoint on Z (DUNCAN_CORNER_F2 W2: "
        f"'separated by T2'): {'PASS' if meets == 0 else 'FAIL'}")
    ok &= meets == 0

    # ---------- 3./4. the delta ----------
    say("")
    say("=== 3./4. THE CENSUS DELTA  Z -> Z+  ===")
    inside = []
    for i, r in enumerate(R):
        chF = tuple(r["_chain"])
        datF = [m.canon([list(v) for v in x]) for x in r["_lifted"]]
        for ch, dat in copies:
            if not set(ch) <= set(chF):
                continue
            ind = induced(T, ch, dat, chF)
            if ind is None:
                continue
            if all(T.contains(ind[t], datF[t]) for t in range(len(chF) + 1)):
                inside.append((i, r, ch, dat, ind))
                break
    say(f"  stratum orbits contained in M (including M itself): {len(inside)}")
    say("")
    say("  (a) CONSUMED / REPLACED: every stratum orbit inside M is replaced by")
    say("      its exceptional pieces (FIX_I_bcomplex Thm 2.1(ii),(iii)):")
    newrows = []
    for i, r, ch, dat, ind in inside:
        chF = list(r["_chain"])
        K = frozenset(r["_K"])
        gens = C.generators(K) if len(K) > 1 else []
        # normal bundle of M along this stratum, from the graded description
        Msub = set(tuple(u) for u in ch)
        U = [()] + chF + [T.W]
        Mfl = frozenset.intersection(*[C.sstab(u) for u in chF]) if chF else \
            frozenset(range(C.n))
        gr, prev = [], ()
        for u in chF + [T.W]:
            gr.append(Graded(C, prev, u, Mfl))
            prev = u
        lam = []
        for t in range(len(chF) + 1):
            F = [tuple(x) for x in _coords(gr[t], r["_lifted"][t], C)]
            lam.append({g: gr[t].acts_scalar(g, F) for g in K})
        nchars = []
        for t in range(len(chF) + 1):
            hi = U[t + 1]
            q = Graded(C, ind[t], hi, K)           # U_{t+1} / Ind_t
            mods = q.module_chars(K)
            if mods is None:
                nchars = None
                break
            for v in mods:
                nchars.append((char_label(C, K, chdiv(C, K, v, lam[t]), gens),
                               "." if t < len(chF) else "."))
        if nchars is None:
            say(f"      (nonabelian stabilizer: skipped)")
            continue
        for t in range(1, len(chF) + 1):
            if tuple(chF[t - 1]) in Msub:          # M lies inside this branch
                nchars.append((char_label(C, K, chdiv(C, K, lam[t], lam[t - 1]),
                                          gens), "B"))
        rk = len(nchars)
        say(f"      [{r['K']}] dim {r['dim']} x{r['n_orbit']} on "
            f"{'<'.join(r['chain']) if r['chain'] else '(off D)'}   "
            f"N_M rank {rk}: {nchars}")
        if rk != 4 - 2:
            say(f"         !! FAIL normal rank {rk} != codim(M) = 2")
            ok = False
        cnt = defaultdict(int)
        for a, f in nchars:
            cnt[a] += 1
        for a in sorted(cnt):
            if a == "1":
                continue                            # Thm 2.1(iii): strict transform
            newrows.append((r, a, cnt[a], r["dim"] + cnt[a] - 1))
    say("")
    say("  (b) NEW ROWS on Z+ (one per nontrivial character of the normal")
    say("      bundle of M along each stratum inside it):")
    for r, a, mult, d in newrows:
        say(f"      new: dim {d}  over [{r['K']}] dim {r['dim']} x{r['n_orbit']} on "
            f"{'<'.join(r['chain']) if r['chain'] else '(off D)'}"
            f"   normal character {a} (multiplicity {mult})")
    say("")
    say("  (c) UNCHANGED: every stratum orbit NOT inside M survives as its strict")
    say(f"      transform with dim, count, K, Stab_G, W(K,F) and normal")
    say(f"      characters unchanged (Thm 2.1(i)): "
        f"{len(R) - len(inside)} of the {len(R)} rows.")

    # ---------- 5. the fabulous corners on Z+ ----------
    say("")
    say("=== 5. THE 330 FABULOUS V4-CORNERS ON Z+ ===")
    say("  E_tau^V = P(N_M) is a divisor with G_E = <tau> (step 1, Lemma B).")
    say("  It meets the strict transform of D_{P_z} for the OTHER involutions")
    say("  z of V; at that crossing both <tau> and <z> act trivially, so the")
    say("  crossing stabilizer is <tau,z> = V4, non-cyclic, hence FABULOUS")
    say("  (thm:pairs, EXTERNAL-UNVERIFIED).")
    # the labels (V, z, s): 55 V4 x ordered pairs of distinct involutions
    v4s = [H for H in C.subgroup_classes() if C.name(H) == "V4"]
    nv4 = sum(1 for U in [None] for _ in [0])
    allv4 = set()
    for H in v4s:
        for g in range(C.n):
            allv4.add(C.conj(H, g))
    lab = sum(len([1 for a in H for b in H
                   if a != C.e and b != C.e and a != b]) for H in allv4)
    say(f"  Klein four-subgroups of G: {len(allv4)}")
    say(f"  corner labels (V, z, s) with z != s in V minus 1: {lab}")
    say(f"  CHECK 55 V4's and 330 corner labels (DUNCAN_CORNER_F2 W3 PART 1): "
        f"{'PASS' if len(allv4) == 55 and lab == 330 else 'FAIL'}")
    ok &= len(allv4) == 55 and lab == 330
    fabrows = [(r, a, mult, d) for (r, a, mult, d) in newrows
               if d == 2 and r["K"] == "V4"]
    nfab = sum(r["n_orbit"] for r, a, mult, d in fabrows)
    say(f"  NEW ROWS of Z+ of dimension 2 with V4 acting trivially: "
        f"{len(fabrows)} orbits, {nfab} components")
    say(f"  CHECK these ARE the fabulous corners: 2 G-orbits of 165 = 330, "
        f"V4-fixed of codim 2: {'PASS' if len(fabrows) == 2 and nfab == 330 else 'FAIL'}")
    ok &= len(fabrows) == 2 and nfab == 330
    say("  (the 330 split into 2 G-orbits of 165 -- the ordered pair (z,s) records")
    say("   which involution is G_{D_i} and which is G_{D_j}; setwise stabilizer V4.)")
    return ok


def _coords(gg, sub, C):
    """The subspace `sub` of W, expressed in the coordinates of the graded
    piece gg (assumes sub contains gg.Usub and lies in gg.Ubig)."""
    p = C.p
    out = []
    for b in sub:
        co = [b[c] for c in gg.piv]
        # reduce modulo the sub-part
        from sfcore import rref
        if gg.Usub:
            B2, piv2 = rref([[list(x)[c] for c in gg.piv] for x in gg.Usub],
                            len(gg.B), p)
            for i, c in enumerate(piv2):
                f = co[c]
                if f:
                    co = [(y - f * z) % p for y, z in zip(co, B2[i])]
        out.append([co[c] for c in gg.free])
    from sfcore import rref as _r
    R2 = _r(out, gg.R.n, p)[0]
    return R2


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
    with open(os.path.join(HERE, "results", "t5_zplus.txt"), "w") as f:
        f.write("\n".join(out) + "\n")
    print("T5_ZPLUS_" + ("OK" if ok else "FAIL"))
    sys.exit(0 if ok else 1)
