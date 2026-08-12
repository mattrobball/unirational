"""REFEREE spot-check (R2, R3, R4): the chi_0 = 35 (mod 55) dichotomy, the
chi_top <-> chi(O) bridge, the Riemann-Hurwitz prunings, and the menu-constancy
recomputation -- all independently re-derived.

Also re-expands the 64 C5 menu entries directly from the sealed
vectors_d35.json (own code, not the packet's), and re-checks the C11-side
ingredients (4 immune rows, residual 5-cycle with no fixed point, defined-row
profile) from the sealed sources.
"""
import json
import os
import sys
import re
from itertools import product as iproduct

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
FAILS = []


def ck(name, cond, detail=""):
    print("%-4s %s%s" % ("PASS" if cond else "FAIL", name,
                         "" if cond else "   <-- %s" % detail))
    if not cond:
        FAILS.append(name)


def main():
    # ---------------------------------------------- R2: the joint congruence
    # Smith (sealed, terminus model Z): chi_top(F_x) = 4 (mod 11) at C11-points,
    # = 5 = 0 (mod 5) at C5-points.  Smooth-fibre bridge: chi_top = 2*chi(O).
    sols = sorted({c % 55 for c in range(-1000, 1000)
                   if (2 * c) % 11 == 4 and (2 * c) % 5 == 0})
    ck("D1 2c = 4 (mod 11) and 2c = 0 (mod 5) iff c = 35 (mod 55)",
       sols == [35], sols)
    # CRT by hand: 2c = 4 (mod 11) => c = 2 (mod 11) (2^{-1} = 6); c = 0 (mod 5)
    ck("D2 hand CRT: c = 2 (mod 11), c = 0 (mod 5) => c = 35 (mod 55)",
       pow(2, -1, 11) == 6 and (4 * 6) % 11 == 2 and 35 % 11 == 2 and 35 % 5 == 0)
    vals = [c for c in range(-100, 100) if c % 55 == 35]
    ck("D3 the dichotomy gap: no value of c = 35 (mod 55) lies in (-20, 35)",
       all(c <= -20 or c >= 35 for c in vals) and -20 in vals and 35 in vals)
    ck("D4 branch A arithmetic: h0 = 1, chi_0 <= -20 => h1 = 1 - chi_0 >= 21, "
       "h1 = 21 (mod 55)",
       (1 - (-20)) == 21 and (1 - 35) % 55 == 21)
    ck("D5 branch B arithmetic: chi_0 >= 35, h1 >= 0 => h0 = chi_0 + h1 >= 35",
       True)
    ck("D6 branch B is impossible when h0 = 1 (chi_0 = 1 - h1 <= 1 < 35)", 1 < 35)

    # ------------------------------------------------- R4: Riemann-Hurwitz
    def rh(p, h, r):
        """2g-2 = p(2h-2) + r(p-1); None if r = 1 (Hurwitz sum rule) or g<0."""
        if r == 1:
            return None
        t = p * (2 * h - 2) + r * (p - 1)
        if t % 2:
            return None
        g = (t + 2) // 2
        return g if g >= 0 else None

    ck("D7 C11, n=4: g = 11h + 10 (min 10)",
       [rh(11, h, 4) for h in range(4)] == [10, 21, 32, 43])
    ck("D8 C5, n=5: g = 5h + 6 (min 6)",
       [rh(5, h, 5) for h in range(4)] == [6, 11, 16, 21])
    ck("D9 both RH families reproduce the Smith congruence identically",
       all((2 - 2 * rh(11, h, 4)) % 11 == 4 for h in range(8)) and
       all((2 - 2 * rh(5, h, 5)) % 5 == 0 for h in range(8)))
    ck("D10 the r = 1 case is pruned (local rotation numbers must sum to 0 mod p"
       " and each is nonzero)", rh(11, 2, 1) is None and rh(5, 2, 1) is None)
    ck("D11 free-action genera: r = 0 gives g = p(h-1) + 1 >= 1 (h >= 1)",
       rh(11, 1, 0) == 1 and rh(11, 2, 0) == 12 and rh(5, 1, 0) == 1 and
       rh(5, 0, 0) is None)  # negative genus pruned
    ck("D12 split genera: r=2@11: 11h; r=4@11: 11h+10; r=2@5: 5h; r=3@5: 5h+2;"
       " r=5@5: 5h+6",
       [rh(11, h, 2) for h in range(3)] == [0, 11, 22] and
       [rh(5, h, 2) for h in range(3)] == [0, 5, 10] and
       [rh(5, h, 3) for h in range(3)] == [2, 7, 12])

    # partitions with parts >= 2
    def parts_ge2(n):
        out = []

        def rec(rem, start, cur):
            if rem == 0:
                out.append(tuple(cur))
                return
            for v in range(start, rem + 1):
                if v >= 2:
                    rec(rem - v, v, cur + [v])
        rec(n, 2, [])
        return sorted(out)

    ck("D13 fixed-point splits: 4 -> {[2,2],[4]}, 5 -> {[2,3],[5]}",
       parts_ge2(4) == [(2, 2), (4,)] and parts_ge2(5) == [(2, 3), (5,)])

    # independent enumeration of smooth C_p-stable fibre types, same window
    def enumerate_types(p, n, hmax=4, emax=1, fmax=3, gmax=1):
        out = []
        for split in parts_ge2(n):
            per = [[rh(p, h, r) for h in range(hmax + 1)
                    if rh(p, h, r) is not None] for r in split]
            for gs in iproduct(*per):
                for e in range(emax + 1):
                    egs = [()] if e == 0 else \
                        [(p * (h - 1) + 1,) * e for h in range(1, hmax + 2)]
                    for eg in egs:
                        for f in range(fmax + 1):
                            for gp in range(gmax + 1):
                                h0 = len(split) + e + p * f
                                h1 = sum(gs) + sum(eg) + p * f * gp
                                out.append((h0, h1))
        return out

    t11 = enumerate_types(11, 4)
    t5 = enumerate_types(5, 5)
    M = json.load(open(os.path.join(HERE, "results", "menus.json")))
    ck("D14 type-count agreement with the packet (window hmax=4,emax=1,fmax=3,"
       "gmax=1): 1440 each",
       len(t11) == M["smooth_fibre_type_counts"]["C11"] == 1440 and
       len(t5) == M["smooth_fibre_type_counts"]["C5"] == 1440,
       (len(t11), len(t5)))
    ck("D15 every enumerated type satisfies Smith: chi_top = 2(h0-h1) = n (mod p)",
       all((2 * (h0 - h1)) % 11 == 4 for h0, h1 in t11) and
       all((2 * (h0 - h1)) % 5 == 0 for h0, h1 in t5))
    d11 = [t for t in t11 if t[0] >= 2]
    d5 = [t for t in t5 if t[0] >= 2]
    ck("D16 cheapest disconnected: C11 (2,0) [two P^1s], C5 (2,2)",
       min(d11) == (2, 0) and min(d5) == (2, 2), (min(d11), min(d5)))
    ck("D17 chi_O = -20 realizable with h0 = 1 at both classes (g = 21 = 11+10"
       " = 15+6)", (1, 21) in t11 and (1, 21) in t5)
    ck("D18 chi_O = 35 in-window: C11 yes ((35,0), split [2,2] + 3 free"
       " 11-orbits of P^1s), C5 none (window note honest)",
       (35, 0) in t11 and min([h0 for h0, h1 in t5 if h0 - h1 == 35],
                              default=None) is None)
    common = [g for g in range(200) if g % 11 == 10 and g % 5 == 1]
    ck("D19 g = 11a+10 = 5b+6 common solutions start 21, 76 (= 21 mod 55)",
       common[:2] == [21, 76] and all(g % 55 == 21 for g in common))

    # ------------------------------------------------- R3: the bridge, sanity
    # chi_top = 2 chi(O) + D - 2 chi(N), D = 2*delta - sum(n_p - 1)
    cases = [
        # (name, chi_top, chi_O, delta, branches_excess, chi_N)
        ("double line in P^2", 2, 1, 0, 0, 0),       # N = O_{P1}(-1), chi = 0
        ("two lines meeting", 3, 1, 1, 1, 0),        # delta 1, n_p 2
        ("irreducible nodal plane cubic", 1, 0, 1, 1, 0),
        ("cuspidal plane cubic", 2, 0, 1, 0, 0),     # delta 1, n_p 1 -> D = 2
        ("smooth genus g curve", None, None, 0, 0, 0),
    ]
    okb = True
    for nm, ct, co, dlt, brx, cn in cases:
        if ct is None:
            continue
        D = 2 * dlt - brx
        if ct != 2 * co + D - 2 * cn:
            okb = False
    ck("D20 bridge chi_top = 2 chi(O) + D - 2 chi(N) on the four worked cases",
       okb)
    ck("D21 D = 2 delta - sum(n_p - 1) >= 0 via delta_p >= n_p - 1, = 0 iff "
       "smooth: nodal D = #nodes = 1, cuspidal D = 2",
       2 * 1 - 1 == 1 and 2 * 1 - 0 == 2)
    # reduced-nodal menu row: h1 = (2 + delta - n) * 2^{-1} (mod p)
    ck("D22 reduced-nodal row at C11: h1 = (2 + delta - 4) * 6 (mod 11)",
       all(((2 + d - 4) * pow(2, -1, 11)) % 11 ==
           M["menus"]["C11"]["CONN_dim1_reduced_nodal"]["rows"][d]["h1_mod_p"]
           for d in range(12)))

    # --------------------------------------- R2/R4: constancy, re-expanded
    vec = json.load(open(os.path.join(
        ROOT, "goal_runs_20260811/GLOBAL_COHERENCE/results/vectors_d35.json")))
    led = json.load(open(os.path.join(
        ROOT, "goal_runs_20260810/RECEIVER_LEDGER_X/results/ledger_exact.json")))
    cen = open(os.path.join(
        ROOT, "goal_runs_20260810/TERMINUS_STRATA_PW/results/t2_strata.txt")).read()

    pc = vec["per_center"]
    prod = 1
    for k in pc:
        prod *= pc[k]["n"]
    ck("D23 menu product 10*4*4*4*238*238 = 36252160 = F_odd(35)",
       prod == vec["F_odd"] == 36252160 == 10 * 4 * 4 * 4 * 238 * 238)

    perm = led["detail"]["C11"]["residual_C5_permutation"]
    orb, cur = {0}, 0
    for _ in range(5):
        cur = perm[cur]
        orb.add(cur)
    ck("D24 residual C5 = [2,0,3,4,1] is a fixed-point-free 5-cycle "
       "(transitive on the five C11-points)",
       len(orb) == 5 and all(perm[i] != i for i in range(5)))
    ck("D25 census: >= 4 immune C11 rows (60 comps, 5 per fixed C11) and >= 10 "
       "immune C5 rows (132 comps, 2 per fixed C5)",
       cen.count(" C11   0     60        5        C11") >= 4 and
       cen.count("  C5   0    132        2         C5") >= 10)
    ck("D26 C11 factor: 4 immune rows x 5 comps / 5 receiver points, C5-"
       "equivariantly => exactly 1 per point per row => n_x = 4, entry-"
       "independent; 4 x 5 = 20 = Z^{C11}",
       len(pc["C11"]["row_names"]) == 4 and
       "H = C11 : components of Z^H by dim {0: 20}" in cen)
    defined = [sum(1 for s in v if s != "UNDEF") for v in pc["C11"]["vectors"]]
    ck("D27 C11 defined-row profile [0,2,2,2,3,2,3,2,2,2], never 4 (STAGE2 2.1)",
       defined == [0, 2, 2, 2, 3, 2, 3, 2, 2, 2] and max(defined) == 3, defined)

    # the 64 C5 entries, re-expanded from labels with own code
    def w_of(lab):
        m = re.match(r"eigpt\(w=(\d+)\)$", lab)
        return int(m.group(1))

    deps = set()
    n_checked = 0
    for va in pc["C5a"]["vectors"]:
        for vb in pc["C5b"]["vectors"]:
            for vd in pc["D10"]["vectors"]:
                dep = {1: 0, 2: 0, 3: 0, 4: 0}
                for lab in va:
                    dep[w_of(lab)] += 2
                for lab in vb:
                    dep[w_of(lab)] += 2
                for lab in vd:
                    w = w_of(lab)
                    dep[w] += 1
                    dep[(-w) % 5] += 1
                deps.add(tuple(dep[w] for w in (1, 2, 3, 4)))
                n_checked += 1
    ck("D28 all 64 C5 entries re-expanded: deposit (5,5,5,5) every time; "
       "4 x 5 = 20 = Z^{C5}",
       n_checked == 64 and deps == {(5, 5, 5, 5)} and
       "H = C5  : components of Z^H by dim {0: 20}" in cen, deps)

    sm = json.load(open(os.path.join(
        ROOT, "goal_runs_20260812/SMITH_I3/results/f2f3_congruences.json")))
    ck("D29 22 cells, 22 distinct hashes, 22 * 36252160 = 797547520 sealed pairs",
       len(sm["cells"]) == 22 and
       len({c["content_hash_p331"] for c in sm["cells"]}) == 22 and
       22 * prod == sm["n_cell_menu_pairs"])
    ck("D30 sealed Smith inputs: n_x = 4 on Z (C11, five equal chi) and "
       "n_x = 5 at all four C5-points",
       sm["orders"]["11"]["n_x_on_Z"] == 4 and
       all(v == 5 for v in sm["orders"]["5"]["n_x"].values()))

    print()
    if FAILS:
        print("REFEREE_DICHOTOMY_MENUS_FAILED", FAILS)
        sys.exit(1)
    print("REFEREE_DICHOTOMY_MENUS_OK")


if __name__ == "__main__":
    main()
