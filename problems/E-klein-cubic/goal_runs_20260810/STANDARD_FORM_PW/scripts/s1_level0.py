"""S1 -- the level-0 atlas of P(W): stratification, tangent/normal modules,
Lemma B, and the complete incidence table.

Everything here RE-VERIFIES the consumed certificates
`certificates/STRATA_EXACT.md` (orbit table, line 108-123) and
`certificates/NORMAL_CHARACTERS.md` (normal characters, lines 71-90) rather
than importing them, and adds the incidence data the blow-up schedule needs.

Runs at both split primes.  CHECK lines; marker S1_LEVEL0_OK.
"""
import json
import os
import sys
from collections import defaultdict

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from sfcore import Core                                   # noqa: E402
from psl211 import SPLIT_PRIMES                           # noqa: E402

HERE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# ---- expected values, from the sealed certificates (regression targets) ----
EXPECT_STRATA = {
    # label            : (proj dim, |H|, H name, orbit sizes, on X)
    "P_sigma":  (2, 2,  "C2",  [55], False),
    "L'_sigma": (1, 2,  "C2",  [55], True),
    "C3line":   (1, 3,  "C3",  [110], False),
    "ell_V":    (1, 4,  "V4",  [55], False),
    "V4-I":     (0, 4,  "V4",  [165], True),
    "C5pt":     (0, 5,  "C5",  [132, 132], True),
    "C6pt":     (0, 6,  "C6",  [110, 110], None),
    "C11pt":    (0, 11, "C11", [60], True),
    "D10pt":    (0, 10, "D10", [66], False),
    "D12pt":    (0, 12, "D12", [55], False),
    "A4pt":     (0, 12, "A4",  [55, 55], False),
}
EXPECT_SUBGROUP_CLASSES = 16
EXPECT_ABELIAN_TYPES = ["1", "C2", "C3", "C5", "C6", "C11", "V4"]


def label_of(pname, d):
    return {("C2", 3): "P_sigma", ("C2", 2): "L'_sigma", ("C3", 2): "C3line",
            ("V4", 2): "ell_V", ("V4", 1): "V4-I", ("C5", 1): "C5pt",
            ("C6", 1): "C6pt", ("C11", 1): "C11pt", ("D10", 1): "D10pt",
            ("D12", 1): "D12pt", ("A4", 1): "A4pt"}.get((pname, d))


def dlog(base, x, n, p):
    for k in range(n):
        if pow(base, k, p) == x:
            return k
    raise ValueError("not a root of unity")


def run(p, say):
    ok = True
    C = Core(p)
    m = C.m
    reps = C.subgroup_classes()
    say(f"--- p = {p} ---")
    say(f"CHECK subgroup conjugacy classes = {len(reps)} "
        f"(expected {EXPECT_SUBGROUP_CLASSES}): "
        f"{'PASS' if len(reps) == EXPECT_SUBGROUP_CLASSES else 'FAIL'}")
    ok &= len(reps) == EXPECT_SUBGROUP_CLASSES

    ab = sorted(set(C.name(H) for H in reps if C.is_abelian(H)),
                key=lambda s: (len(s), s))
    say(f"CHECK abelian subgroup types = {ab}: "
        f"{'PASS' if sorted(ab) == sorted(EXPECT_ABELIAN_TYPES) else 'FAIL'}")
    ok &= sorted(ab) == sorted(EXPECT_ABELIAN_TYPES)

    # ---------- strata ----------
    seeds = defaultdict(set)
    for H in reps:
        if len(H) in (1, 660):
            continue
        for val, U in C.char_subspaces(H):
            lab = label_of(C.name(C.pstab(U)), len(U))
            if lab:
                seeds[lab].add(m.canon(U))

    def orbit(u):
        return frozenset(m.canon([list(m.act(C.G[g], v)) for v in u])
                         for g in range(C.n))

    FAM, ORB = {}, {}
    for lab, S in sorted(seeds.items()):
        full = set()
        for U in S:
            full |= orbit(U)
        FAM[lab] = sorted(full)
        rem, sizes, k = set(full), [], 0
        while rem:
            u = sorted(rem)[0]
            o = orbit(u)
            k += 1
            nm = lab if len(full) == len(o) else f"{lab}({chr(96+k)})"
            ORB[nm] = (u, o)
            sizes.append(len(o))
            rem -= o
        d, hh, hn, esz, _ = EXPECT_STRATA[lab]
        got_H = C.pstab(FAM[lab][0])
        good = (len(FAM[lab][0]) - 1 == d and len(got_H) == hh
                and C.name(got_H) == hn and sorted(sizes) == sorted(esz))
        say(f"CHECK stratum {lab:<9} projdim {len(FAM[lab][0])-1} H={C.name(got_H)} "
            f"orbits {sorted(sizes)} (expect dim {d}, {hn}, {sorted(esz)}): "
            f"{'PASS' if good else 'FAIL'}")
        ok &= good
    say(f"CHECK the stratification has exactly {len(EXPECT_STRATA)} labels: "
        f"{'PASS' if set(FAM) == set(EXPECT_STRATA) else 'FAIL'}")
    ok &= set(FAM) == set(EXPECT_STRATA)

    # every subgroup with a fixed point on P(W), and what that point is
    s3ok = True
    for H in reps:
        nm = C.name(H)
        if nm in ("1", "PSL(2,11)"):
            continue
        fps = [(val, U) for val, U in C.char_subspaces(H)]
        if nm == "S3":
            got = sorted(set((len(U), C.name(C.pstab(U))) for _, U in fps))
            good = got == [(1, "D12")]
            s3ok &= good
            say(f"CHECK an S3 (one of the TWO classes) fixes {len(fps)} point(s) "
                f"of P(W), all of type {got}: no stratum has pointwise "
                f"stabilizer S3: {'PASS' if good else 'FAIL'}")
        if nm in ("A5", "11:5") and fps:
            s3ok = False
            say(f"CHECK {nm} has no fixed point on P(W): FAIL")
        elif nm in ("A5", "11:5"):
            say(f"CHECK {nm} has no fixed point on P(W): PASS")
    ok &= s3ok

    # ---------- normal / tangent characters and Lemma B ----------
    say("")
    say("Lemma B (Duncan corner packet): for a centre with generic pointwise")
    say("stabilizer H and normal representation N, G_E = ker(H -> PGL(N)); so")
    say("G_E != 1 iff N is H-isotypic.")
    LEMMA_B = {"P_sigma": True, "L'_sigma": True, "C3line": False, "ell_V": False,
               "V4-I": False, "C5pt": False, "C6pt": False, "C11pt": False}
    weights = {}
    for H in reps:
        nm = C.name(H)
        if nm not in ("C2", "C3", "C5", "C6", "C11", "V4"):
            continue
        gens = C.generators(H)
        if nm == "V4":
            z, s = gens

            def enc(val, z=z, s=s):
                return (0 if val[z] == 1 else 1, 0 if val[s] == 1 else 1)
            NN = (2, 2)
        else:
            g = gens[0]
            nord = C.ordr[g]
            zt = m._root(nord)

            def enc(val, g=g, nord=nord, zt=zt):
                return (dlog(zt, val[g], nord, p),)
            NN = (nord,)
        for val, U in C.char_subspaces(H):
            if C.pstab(U) != H:
                continue
            lab = label_of(nm, len(U))
            N = [enc(t) for t in C.normal_weights(H, U)]
            iso = len(set(N)) == 1
            good = iso == LEMMA_B[lab]
            say(f"CHECK {lab:<9} H={nm:<4} normal weights {sorted(N)} "
                f"isotypic={iso} (expect {LEMMA_B[lab]}): {'PASS' if good else 'FAIL'}")
            ok &= good
            T = ([0] * (len(U) - 1) if len(U) > 1 else [])
            tw = ([enc(t) for t in C.tangent_weights(H, U)] if len(U) == 1
                  else [tuple([0] * len(NN))] * (len(U) - 1) + N)
            weights.setdefault(lab, []).append(
                {"H": nm, "modulus": NN, "char_of_line": enc(val),
                 "normal": sorted(N), "tangent": sorted(tw)})

    # ---------- incidences ----------
    say("")

    def contains(U, V):
        return m.rank([list(x) for x in U] + [list(y) for y in V]) == len(U)

    poss = sorted(k for k in ORB if len(ORB[k][0]) >= 2)
    ptl = sorted(k for k in ORB if len(ORB[k][0]) == 1)
    INC = {}
    for pl in ptl:
        pt = ORB[pl][0]
        cnt = {}
        for ql in poss:
            c = sum(1 for U in ORB[ql][1] if contains(U, pt))
            if c:
                cnt[ql] = c
        INC[pl] = cnt
        say(f"INCIDENCE {pl:<9} lies on " +
            (", ".join(f"{k} x{v}" for k, v in sorted(cnt.items())) or "(no positive-dim stratum)"))
    for ql in poss:
        U0 = ORB[ql][0]
        cnt = {}
        for pl in ptl:
            c = sum(1 for V in ORB[pl][1] if contains(U0, V))
            if c:
                cnt[pl] = c
        up = {}
        for rl in poss:
            c = sum(1 for V in ORB[rl][1] if V != U0 and contains(V, U0))
            if c:
                up[rl] = c
        INC[ql] = {"points": cnt, "inside": up}
        say(f"INCIDENCE {ql:<9} contains " + ", ".join(f"{k} x{v}" for k, v in sorted(cnt.items()))
            + "; sits inside " + (", ".join(f"{k} x{v}" for k, v in sorted(up.items())) or "-"))

    # sibling intersections inside each family (needed for the disjointness plan)
    SIB = {}
    for ql in poss:
        U0 = ORB[ql][0]
        dims = defaultdict(int)
        for V in ORB[ql][1]:
            if V != U0:
                dims[len(m.inter(U0, V))] += 1
        SIB[ql] = dict(sorted(dims.items()))
        say(f"SIBLINGS  {ql:<9} pairwise intersection vector-dims {SIB[ql]}")

    # the two facts the schedule turns on
    f1 = SIB["ell_V"].get(1, 0) == 6 and SIB["ell_V"].get(0, 0) == 48
    say(f"CHECK the 55 ell_V meet 6 siblings in a point, 48 not at all: "
        f"{'PASS' if f1 else 'FAIL'}")
    ok &= f1
    dis = all(len(m.inter(ORB["ell_V"][0], V)) == 0 for V in ORB["L'_sigma"][1])
    say(f"CHECK ell_V is disjoint from every minus-line (all 55): "
        f"{'PASS' if dis else 'FAIL'}   [re-derives DUNCAN_CORNER_F2 W2.3b]")
    ok &= dis
    return ok, {"orbits": {k: len(v[1]) for k, v in ORB.items()},
                "incidence": INC, "siblings": SIB, "weights": weights}


if __name__ == "__main__":
    out, payload = [], {}

    def say(*a):
        s = " ".join(str(x) for x in a)
        print(s)
        out.append(s)

    ok = True
    for p in SPLIT_PRIMES:
        r, pay = run(p, say)
        ok &= r
        payload[str(p)] = pay
        say("")
    say("S1_LEVEL0_" + ("OK" if ok else "FAIL"))
    with open(os.path.join(HERE, "results", "s1_level0.txt"), "w") as f:
        f.write("\n".join(out) + "\n")
    with open(os.path.join(HERE, "results", "s1_level0.json"), "w") as f:
        json.dump(payload, f, indent=1, sort_keys=True)
    sys.exit(0 if ok else 1)
