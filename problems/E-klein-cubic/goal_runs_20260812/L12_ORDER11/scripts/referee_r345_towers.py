"""Referee spot-checks R3/R4/R5(+FLAG-T): independent tower enumeration.

Scopes:
  PACKET scope  : multiplicity residues mu in {1..10} at every level
                  (this is what the packet enumerated);
  EXTENDED scope: residues {0..10} — mu = 0 here means mu == 0 (mod 11)
                  with actual multiplicity >= 11 (11, 22, 33 <= d = 35),
                  which STAGE2 Thm 1.2 permits and the sealed 10-entry menu
                  CANNOT exclude at level 1 (a mu==0 row is all-UNDEF,
                  identical as a labeled row to the sealed mu=2 row).

Checks:
  T0  frame: mass conservation over ALL states/mu encountered (deterministic
      analogue of anchor A5), rho conservation, v_pi(term) = -4 on every
      site incl. components, FLAG-T counterexample.
  T1  (R4) depth<=3 exhaustion in PACKET scope: per-mu1 vector counts
      (21,1134,90,126,30,3,7,90,9,30 -> 1540), 0 genus-0 passes, 118
      integrality survivors, 0 menu passes + failure-reason histogram,
      n_x range; brute-force (non-memoized) cross-check for small mu1.
  T2  (R3) depth-1/depth-2 closure landscape and the forced-depth bounds:
      Psi-by-depth in both scopes; the >= 3 statement re-derived; the exact
      saturation depths (THEOREM.md says "saturates ... once depth >= 4").
  T3  (R4/R5) EXTENDED scope: does any conclusion change when mu == 0
      (mod 11) residues are allowed?  (counts, genus-0 passes, integrality
      survivors, menu passes, forced depths.)
  T4  (R5) menu math: span rank = 6, kernel, brute-force agreement b = 2..6,
      tr = 1 -> b = 2, tr = 2 -> b = 4.
  T5  sealed-menu reproduction + the mu==0-row ambiguity, from Thm 1.2 alone.
"""
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import referee_lib as R          # noqa: E402
import referee_r345_lib as MEN   # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))
PROBLEM = os.path.abspath(os.path.join(HERE, "..", "..", ".."))
FAIL = []
NOTES = []


def chk(name, ok, detail=""):
    print(f"  [{'PASS' if ok else 'FAIL'}] {name}" + (f" ({detail})" if detail else ""))
    if not ok:
        FAIL.append(name)


def note(s):
    NOTES.append(s)
    print("  [NOTE] " + s)


# --------------------------------------------------------------------- T0
def t0():
    print("--- T0: model frame (deterministic) ---")
    root = R.site_pt(R.tangent_P4(0), 35)
    # reachable point-states to depth 3, all mu in 0..10
    states = set()
    frontier = {root}
    for _ in range(3):
        nxt = set()
        for s in frontier:
            for mu in range(0, 11):
                for k in R.blowup(s, mu):
                    if k[0] == "pt":
                        nxt.add(k)
        states |= frontier
        frontier = nxt - states
    ok_mass = ok_rho = True
    nbl = ncomp = 0
    off4 = {}
    seen = set()
    for s in sorted(states):
        for mu in range(0, 11):
            kids = R.blowup(s, mu)
            nbl += 1
            ncomp += sum(1 for k in kids if k[0] == "comp")
            tot = R.total([R.site_term(k) for k in kids])
            ok_mass &= R.eq(tot, R.site_term(s))
            ok_rho &= (sum(R.rho(k) for k in kids) % 11 == R.rho(s))
            for k in kids:
                key = (k[0], k[1], k[2] if k[0] == "comp" else None)
                if key in seen:
                    continue
                seen.add(key)
                v = R.val_pi(R.site_term(k))
                if v != -4:
                    off4[key] = (v, R.rho(k))
    chk(f"T0 exact mass identity on ALL {nbl} (state,mu) blowups reachable "
        f"to depth 3 ({ncomp} with components)", ok_mass)
    chk("T0 rho (= res_pi(pi^4 AB)) is conserved on all of them", ok_rho)
    chk("T0 v_pi(AB term) >= -4 for every reachable site, = -4 for all "
        "isolated points; EXACTLY three component types have v_pi = -3 "
        "(rho = 0), so THEOREM.md sec.6 'every site term has v_pi = -4' is "
        "overstated but the integrality argument (which needs only >= -4) "
        "is unaffected",
        all(k[0] == "comp" and v == (-3, 0) for k, v in off4.items())
        and len(off4) == 3,
        f"off-4 sites: {sorted(off4)}")
    chk("T0 rho(root over e_0) = 9 (hand: (8*3*2*4)^{-1} = 192^{-1} = 5^{-1} "
        "= 9 mod 11)", R.rho(root) == 9)

    # FLAG-T counterexample re-derivation
    tw1 = R.blowup(root, 1)  # mu irrelevant for tangent data
    child = [k for k in tw1 if k[0] == "pt" and k[1][0] == 1
             and sorted(k[1]) == sorted(((2, 8 - 2, 3 - 2, 4 - 2)))]
    ok = False
    for k in tw1:
        if k[0] == "pt" and sorted(k[1]) == [1, 2, 2, 6]:
            gk = R.blowup(k, 1)
            ok = any(g[0] == "comp" and g[2] == 2 for g in gk)
    chk("T0 FLAG-T: the e_0 -> (dir of e_3, c = 2) child has tangent multiset "
        "{1,2,2,6}; blowing it up yields a fixed P^1 at eigenvalue 2", ok)
    chk("T0 FLAG-T: same multiset as the SMITH_I3 director-correction "
        "example {1,2,2,6}", sorted((2, 6, 1, 2)) == [1, 2, 2, 6])


# --------------------------------------------------------------------- T1
def survey(mus, budget, label):
    memo = {}
    per = {}
    agg = dict(towers=0, genus0=0, integral=0, menu=0)
    reasons = {}
    nx_all = set()
    survivors = []
    mu1s = sorted(set(list(mus) + ([0] if 0 in mus else [])))
    for mu1 in [m for m in mu1s if True]:
        vecs = R.towers_over_e0(35, mu1, budget, tuple(mus), memo)
        g0 = ni = nm = 0
        for v in sorted(vecs):
            M, cnt = R.globalize(v)
            E = R.residual_Ek(M, 3)
            assert R.is_zero(E[0]), "k=0 identity must be automatic"
            nx = cnt[R.QRL[0]]
            assert len(set(cnt.values())) == 1
            nx_all.add(nx)
            if all(R.is_zero(E[k]) for k in (1, 2, 3)):
                g0 += 1
            Rv = R.R_vector(M)
            if any(x != 0 for x in Rv.values()):
                continue
            ni += 1
            tr = R.forced_traces(M)
            oks = [MEN.in_menu(tr[w], b_required=nx) for w in R.QRL]
            if all(o[0] for o in oks):
                nm += 1
                survivors.append((mu1, v))
            else:
                why = next(o[2] for o in oks if not o[0])
                reasons[why] = reasons.get(why, 0) + 1
        per[mu1] = dict(towers=len(vecs), genus0=g0, integral=ni, menu=nm)
        agg["towers"] += len(vecs)
        agg["genus0"] += g0
        agg["integral"] += ni
        agg["menu"] += nm
    return per, agg, reasons, nx_all, survivors


def brute_force_mu1(mu1, budget=2):
    """Non-memoized, non-deduplicating enumeration for cross-checking:
    recursively assign a mu to every undefined point site, depth-capped."""
    out = []

    def close(sites, depth_left):
        # sites: list of (site, depth_remaining) all needing closure
        undef = [i for i, (s, dl) in enumerate(sites) if not R.defined(s)]
        if not undef:
            v = {w: (R.ZERO, 0) for w in R.QRL}
            for s, dl in sites:
                v[s[-1]] = (R.add(v[s[-1]][0], R.site_term(s)), v[s[-1]][1] + 1)
            out.append(tuple(v[w] for w in R.QRL))
            return
        i = undef[0]
        s, dl = sites[i]
        if s[0] == "comp" or dl <= 0:
            return
        rest = sites[:i] + sites[i + 1:]
        for mu in range(1, 11):
            kids = [(k, dl - 1) for k in R.blowup(s, mu)]
            close(rest + kids, depth_left)

    root = R.site_pt(R.tangent_P4(0), 35)
    kids = [(k, budget) for k in R.blowup(root, mu1)]
    close(kids, budget)
    return set(out)


def t1():
    print("--- T1 (R4): depth<=3 exhaustion, PACKET scope (mu in 1..10) ---")
    per, agg, reasons, nx_all, surv = survey(tuple(range(1, 11)), 2, "packet")
    packet_counts = {1: 21, 2: 1134, 3: 90, 4: 126, 5: 30,
                     6: 3, 7: 7, 8: 90, 9: 9, 10: 30}
    chk("T1 per-mu1 distinct value-mass vectors match the packet table "
        + str([per[m]['towers'] for m in range(1, 11)]),
        all(per[m]["towers"] == packet_counts[m] for m in range(1, 11)))
    chk(f"T1 total = 1540", agg["towers"] == 1540)
    chk(f"T1 genus-0 passes = 0 of 1540", agg["genus0"] == 0)
    chk(f"T1 integrality survivors = 118", agg["integral"] == 118,
        f"got {agg['integral']}")
    chk(f"T1 menu passes = 0", agg["menu"] == 0)
    chk("T1 menu failure reasons: 117 'not in span', 1 'b < sum|D|' "
        f"(got {reasons})",
        reasons.get("not in span", 0) == 117
        and reasons.get("b < sum|D|", 0) == 1
        and sum(reasons.values()) == 118)
    chk(f"T1 n_x over towers all >= 6 (min {min(nx_all)}, max {max(nx_all)})",
        min(nx_all) >= 6)
    # brute-force cross-check (raw recursion, no memo, no vector dedup)
    for mu1 in (1, 5, 6, 7, 9, 10):
        memo = {}
        a = R.towers_over_e0(35, mu1, 2, tuple(range(1, 11)), memo)
        b = brute_force_mu1(mu1, 2)
        chk(f"T1 brute-force vector set equals DP vector set for mu1={mu1} "
            f"({len(b)} vectors)", a == b)
    return per, agg


# --------------------------------------------------------------------- T2
def psi_by_depth(mu1, mus, maxextra=6):
    """Achievable Psi = sum_W r_W W^{-1} in F_11 for closed towers, as a
    function of the extra depth below level 1 (referee's own DP)."""
    memo = {}

    def rec(s, budget):
        key = (s, budget)
        if key in memo:
            return memo[key]
        if R.defined(s):
            r = frozenset({R.rho(s) * pow(s[-1], 9, 11) % 11})
            memo[key] = r
            return r
        if s[0] == "comp" or budget <= 0:
            memo[key] = frozenset()
            return frozenset()
        acc = set()
        for mu in mus:
            parts = [rec(k, budget - 1) for k in R.blowup(s, mu)]
            if any(not p for p in parts):
                continue
            cur = {0}
            for p in parts:
                cur = {(x + y) % 11 for x in cur for y in p}
            acc |= cur
        memo[key] = frozenset(acc)
        return memo[key]

    root = R.site_pt(R.tangent_P4(0), 35)
    kids = R.blowup(root, mu1)
    out = {}
    for cap in range(0, maxextra + 1):
        parts = [rec(k, cap) for k in kids]
        if any(not p for p in parts):
            out[cap] = None
            continue
        cur = {0}
        for p in parts:
            cur = {(x + y) % 11 for x in cur for y in p}
        out[cap] = sorted(cur)
    return out


def t2():
    print("--- T2 (R3): closure landscape and forced depth ---")
    # depth-1: which mu1 close at depth 1?  (all four level-1 children defined)
    root = R.site_pt(R.tangent_P4(0), 35)
    d1 = [mu1 for mu1 in range(0, 11)
          if all(R.defined(k) for k in R.blowup(root, mu1))]
    chk("T2 no mu1 in 0..10 closes at depth 1 (STAGE2 Thm 2.1, NQR: at most "
        "3 of 4 rows defined)", d1 == [])
    for scope, mus in (("packet", tuple(range(1, 11))),
                       ("extended", tuple(range(0, 11)))):
        # depth-2 closures and their Psi
        memo = {}
        d2 = {}
        for mu1 in (range(1, 11) if scope == "packet" else range(0, 11)):
            vecs = R.towers_over_e0(35, mu1, 1, mus, memo)
            if vecs:
                psis = set()
                Rzero = False
                for v in vecs:
                    M, _ = R.globalize(v)
                    Rv = R.R_vector(M)
                    psis.add(tuple(sorted(Rv.values())))
                    if all(x == 0 for x in Rv.values()):
                        Rzero = True
                d2[mu1] = (len(vecs), Rzero)
        if scope == "packet":
            chk("T2 [packet scope] only mu1 = 7 closes at depth 2 "
                f"(got {sorted(d2)})", sorted(d2) == [7])
        else:
            note(f"[extended scope] depth-2 closures exist for mu1 in "
                 f"{sorted(d2)} (counts {[d2[m][0] for m in sorted(d2)]})")
        chk(f"T2 [{scope} scope] NO depth<=2 closed tower has R == 0: "
            "forced total blowup depth >= 3 over every C11-point",
            all(not z for (_, z) in d2.values()))
        # forced-depth table
        firsts = {}
        for mu1 in (range(1, 11) if scope == "packet" else range(0, 11)):
            tab = psi_by_depth(mu1, mus, 5)
            first = None
            for cap in sorted(tab):
                if tab[cap] is not None and 0 in tab[cap]:
                    first = cap
                    break
            firsts[mu1] = (first, tab)
        if scope == "packet":
            want = {1: 2, 2: 2, 3: 2, 4: 2, 5: 2, 6: 3, 7: 4, 8: 2, 9: 3, 10: 2}
            chk("T2 [packet scope] first extra depth with R==0 achievable = "
                + str({m: firsts[m][0] for m in sorted(firsts)}),
                all(firsts[m][0] == want[m] for m in want))
            # saturation depths (the THEOREM.md sec.5 sentence)
            sat = {m: next((cap for cap in sorted(firsts[m][1])
                            if firsts[m][1][cap] is not None
                            and len(firsts[m][1][cap]) == 11), None)
                   for m in firsts}
            note(f"[packet scope] Psi saturates ALL of F_11 first at extra "
                 f"depth {sat} (total = extra + 1)")
            chk("T2 true saturation profile (total depth): 3 for mu1 in "
                "{2,3,4,8,10}, 4 for {1,5,6,9}, 5 for {7}; hence THEOREM.md "
                "sec.5 'saturates ... once depth >= 4 is allowed' is wrong "
                "for mu1 = 7 read at total depth (only 9 of 11 residues, 0 "
                "not among them, at total depth 4) and conservative for "
                "{2,3,4,8,10}; correct blanket statement: saturation for "
                "every mu1 from total depth 5 on",
                sat == {1: 3, 2: 2, 3: 2, 4: 2, 5: 3, 6: 3, 7: 4, 8: 2,
                        9: 3, 10: 2}
                and len(firsts[7][1][3]) == 9 and 0 not in firsts[7][1][3])
            # entry-by-entry comparison with the packet's own JSON
            jp = os.path.join(HERE, "..", "results", "l12_order11.json")
            I3 = json.load(open(jp))["integrality_info"]["I3"]
            ok = True
            for m in range(1, 11):
                tab = I3[str(m)]["psi_by_depth"]
                for cap in range(0, 6):
                    mine = firsts[m][1][cap]
                    theirs = tab[str(cap)]
                    ok &= ((mine is None and theirs is None)
                           or (mine is not None and theirs is not None
                               and sorted(mine) == sorted(theirs)))
            chk("T2 referee Psi-by-depth tables agree ENTRY-BY-ENTRY with "
                "the packet's results JSON (extra depth 0..5, all mu1)", ok)
        else:
            note("[extended scope] first extra depth with R==0: "
                 + str({m: firsts[m][0] for m in sorted(firsts)}))
            chk("T2 [extended scope] forced depth >= 3 still holds for every "
                "mu1 (first extra depth >= 2 everywhere)",
                all(f is not None and f >= 2 for f, _ in firsts.values()))
            chk("T2 [extended scope] the sharper bounds >= 4 for mu1 in "
                "{6,9} and >= 5 for mu1 = 7 survive mu==0-residue blowups",
                firsts[6][0] >= 3 and firsts[9][0] >= 3 and firsts[7][0] >= 4,
                f"6->{firsts[6][0]} 9->{firsts[9][0]} 7->{firsts[7][0]}")


# --------------------------------------------------------------------- T3
def t3():
    print("--- T3 (R4/R5): EXTENDED scope (mu == 0 mod 11 allowed) ---")
    per, agg, reasons, nx_all, surv = survey(tuple(range(0, 11)), 2, "ext")
    note(f"[extended] per-mu1 towers: { {m: per[m]['towers'] for m in sorted(per)} }")
    note(f"[extended] totals: {agg}, menu failure reasons {reasons}")
    chk(f"T3 extended scope grows the depth<=3 tower menu beyond 1540 "
        f"(got {agg['towers']}) — the packet's '1540/exhaustive' is "
        "exhaustive ONLY for mu-residues 1..10", agg["towers"] > 1540)
    chk("T3 [extended] genus-0 passes STILL 0", agg["genus0"] == 0,
        f"got {agg['genus0']}")
    chk("T3 [extended] menu passes STILL 0", agg["menu"] == 0,
        f"got {agg['menu']}")
    note(f"[extended] integrality survivors: {agg['integral']} "
         f"(packet scope: 118)")


# --------------------------------------------------------------------- T4
def t4():
    print("--- T4 (R5): the trace-menu criterion ---")
    rank, kern_ok, one_ok = MEN.span_rank_and_kernel()
    chk("T4 E_u + E_{-u} = 1 for the five pairs", one_ok)
    chk("T4 span{E_1..E_10} has Q-dimension exactly 6", rank == 6)
    chk("T4 the four claimed kernel generators vanish", kern_ok)
    ok = True
    n = 0
    for b in range(2, 7):
        for t, combos in MEN.brute_menu(b).items():
            n += 1
            passes, bb, why = MEN.in_menu(list(t))
            ok &= passes and (bb == b)
    chk(f"T4 criterion agrees with brute force MENU_b for b = 2..6 "
        f"({n} distinct traces, incl. b uniqueness)", ok)
    p1, b1, _ = MEN.in_menu(R.ONE)
    p2, b2, _ = MEN.in_menu(R.from_int(2))
    chk("T4 tr = 1 forces b = 2; tr = 2 forces b = 4",
        p1 and b1 == 2 and p2 and b2 == 4)


# --------------------------------------------------------------------- T5
def t5():
    print("--- T5: sealed C11 menu reproduction and the mu==0 ambiguity ---")
    # Thm 1.2 rows over the base point of a-weight 9 (e_1), chains c in
    # tangent_P4(1) = {3,5,6,7}, receiver weight 35*9 + mu*c
    rows = {}
    for mu in range(0, 11):
        rows[mu] = tuple(
            ("eigpt(w=%d)" % ((35 * 9 + mu * c) % 11)
             if (35 * 9 + mu * c) % 11 in R.QR else "UNDEF")
            for c in (3, 5, 6, 7))
    vp = os.path.join(PROBLEM, "goal_runs_20260811", "GLOBAL_COHERENCE",
                      "results", "vectors_d35.json")
    sealed = json.load(open(vp))["per_center"]["C11"]
    order = [int(nm.split("c=")[1]) for nm in sealed["row_names"]]
    perm = [(3, 5, 6, 7).index(c) for c in order]
    sealed_set = {tuple(v) for v in sealed["vectors"]}
    mine = {tuple(rows[mu][p] for p in perm) for mu in range(1, 11)}
    chk(f"T5 sealed 10-entry C11 menu reproduced from Thm 1.2 with "
        f"mu = 1..10", mine == sealed_set)
    chk("T5 the mu == 0 (mod 11) row is all-UNDEF and IDENTICAL to the "
        "mu = 2 row: the sealed menu cannot exclude mu == 0 residues at "
        "level 1", rows[0] == rows[2] == ("UNDEF",) * 4)


def main():
    t0()
    t1()
    t2()
    t3()
    t4()
    t5()
    print()
    print("referee R3/R4/R5: " + ("ALL GREEN" if not FAIL
                                  else f"FAILURES: {FAIL}"))
    for s in NOTES:
        print("NOTE: " + s)
    return 0 if not FAIL else 1


if __name__ == "__main__":
    sys.exit(main())
