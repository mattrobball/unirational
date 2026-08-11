"""STAGE1_COMPLEX_MAPS -- verifier.

Replays the whole Stage-1 classification from scratch at two split primes
(331, 661) plus the exact Z[zeta_6] character computation of Layer 3, checks
every number quoted in THEOREM.md, checks the witness section row by row
against all 145 closure relations, and checks the four sanity anchors.

    python3 verifier.py            # both primes (~7 min)
    python3 verifier.py 331        # one prime

Emits `CHECK <name> : PASS/FAIL` lines and, if nothing failed,
`STAGE1_COMPLEX_MAPS_VERIFY_OK` and `ALLGREEN`.
"""
import json
import os
import sys
from collections import Counter
from math import comb

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, "scripts"))

from psl211 import Model                                   # noqa: E402
from s1enum import Stage1                                  # noqa: E402
from s1window import exact_window, window_table            # noqa: E402
from produce import solve_block, witness, chain_invols, cellname, prod   # noqa: E402

FAILS = []
CHECKS = []


def closed_N(d, mm):
    """THEOREM.md sec.14's audit-derived closed form for N(d,m), with
    W^+ = triv (+) std, W^- = std:
        N(d,m) = (1/3)[ C(d-m+2,2)(m+1) - eps ],
        eps = [3 | d-m] * c(m),  c(m) = 1, -1, 0  for m = 0, 1, 2 (mod 3).
    """
    eps = {0: 1, 1: -1, 2: 0}[mm % 3] if (d - mm) % 3 == 0 else 0
    num = comb(d - mm + 2, 2) * (mm + 1) - eps
    assert num % 3 == 0, (d, mm, num)
    return num // 3


def check(name, cond, detail=""):
    CHECKS.append((name, bool(cond), detail))
    print("CHECK %-58s : %s%s" % (name, "PASS" if cond else "FAIL",
                                  ("  " + str(detail)) if detail else ""), flush=True)
    if not cond:
        FAILS.append(name)


# ---- the sealed census, carried as an input snapshot -----------------------
def sealed_rows():
    f = os.path.join(HERE, "inputs", "terminus_t2_strata.json")
    d = json.load(open(f))["331"]["3"]
    return sorted((r["K"], r["dim"], r["n_orbit"], r["setwise"]) for r in d)


def sealed_relations():
    f = os.path.join(HERE, "inputs", "terminus_t4_poset.json")
    d = json.load(open(f))["331"]["below"]
    return sum(len(v) for v in d.values())


def run_prime(p):
    print("\n===== p = %d =====" % p, flush=True)
    E = Stage1(p, verbose=False)
    S, T, m = E.S, E.T, E.m

    # ---------------- A. group, arrangement, source complex ----------------
    check("A1 |G| = 660 (p=%d)" % p, len(m.G) == 660)
    prof = Counter(m.order[g] for g in m.G)
    check("A2 element-order profile 1,55,110,264,110,120 (p=%d)" % p,
          [prof[k] for k in (1, 2, 3, 5, 6, 11)] == [1, 55, 110, 264, 110, 120])
    check("A3 arrangement A = 940 pts + 220 lines + 55 planes (p=%d)" % p,
          {d: len(v) for d, v in S.byd.items()} == {1: 940, 2: 220, 3: 55})
    check("A4 A closed under intersection (p=%d)" % p,
          all((m.inter(U, V) in S.Aset or not m.inter(U, V))
              for U in S.A[:60] for V in S.A[:60]))
    check("A5 terminus Z: 11076 components in 80 G-orbits (p=%d)" % p,
          len(S.comps) == 11076 and len(E.rows) == 80,
          "%d / %d" % (len(S.comps), len(E.rows)))
    mine = sorted((r["K"], r["dim"], r["n_orbit"], r["setwise"]) for r in E.rows)
    check("A6 row multiset = sealed TERMINUS_STRATA_PW census (p=%d)" % p,
          mine == sealed_rows())
    check("A7 145 closure relations, = sealed poset (p=%d)" % p,
          len(E.orbit_relations) == sealed_relations() == 145,
          len(E.orbit_relations))
    check("A8 every exact stabilizer abelian in {1,C2,C3,V4,C5,C6,C11} (p=%d)" % p,
          set(r["K"] for r in E.rows) == {"1", "C2", "C3", "V4", "C5", "C6", "C11"})
    check("A9 #components = 660/|Stab| for every row (p=%d)" % p,
          all(r["n_orbit"] * r["setwise_order"] == 660 for r in E.rows))

    # ---------------- B. target complex (RECEIVER_LEDGER_X) ----------------
    sizes = {c: len(v) for c, v in T.comp.items()}
    check("B1 target cell sizes 1/55/55/165/165/110/220/132/132/60 (p=%d)" % p,
          sizes == {"X": 1, "E": 55, "L": 55, "PI": 165, "PII": 165, "P6": 110,
                    "P3": 220, "P5a": 132, "P5b": 132, "P11": 60}, sizes)
    sig = T.invols[0]
    Wm = T.minus[sig]
    check("B2 L_sigma = P(W^-) lies on X, all p+1 points (p=%d)" % p,
          all(m.F(tuple((Wm[0][i] + a * Wm[1][i]) % p for i in range(5))) % p == 0
              for a in range(p)) and m.F(Wm[1]) % p == 0)
    check("B3 165 type-I vertices lie on X, each on 2 L's and 1 E (p=%d)" % p,
          all(len(T.on_L[("PI", l)]) == 2 and len(T.on_E[("PI", l)]) == 1
              for l in T.comp["PI"]))
    check("B4 110 C6-points lie on X and on the minus-line L_t (p=%d)" % p,
          all(m.F(l[0]) % p == 0 and len(T.on_L[("P6", l)]) == 1
              for l in T.comp["P6"]))
    # X^{D12} = X^{A4} = X^{D10} = X^{F55} = empty  (the base-locus hypotheses)
    empt = {}
    for name, order in (("D12", 12), ("A4", 12), ("D10", 10), ("F55", 55)):
        pass
    d12pt = None
    for g in m.G:
        if m.order[g] == 3:
            U = m.eigsp(g, 1)
            if len(U) == 1:
                d12pt = U
                break
    check("B5 X^{D12} = empty : the D12-point is off X (p=%d)" % p,
          d12pt is not None and m.F(d12pt[0]) % p != 0)
    K0 = m.klein_fours()[0]
    lv = m.ell_V(K0)
    a4pts = 0
    for g in m.G:
        if m.order[g] == 3 and all(m.canon([list(m.act(g, v)) for v in lv]) == lv
                                   for _ in (0,)):
            for lam in range(1, p):
                E1 = m.eigsp(g, lam)
                I = m.inter(E1, lv) if E1 else ()
                if I and len(I) == 1:
                    a4pts += 1 if m.F(I[0]) % p != 0 else 0
            break
    check("B6 X^{A4} = empty : both A4-points on ell_V are off X (p=%d)" % p,
          a4pts == 2, a4pts)
    d10 = None
    for g in m.G:
        if m.order[g] == 5:
            U = m.eigsp(g, 1)
            if len(U) == 1:
                d10 = U
                break
    check("B7 X^{D10} = empty : the C5-invariant point is off X (p=%d)" % p,
          d10 is not None and m.F(d10[0]) % p != 0)
    check("B8 dim W^{C3} = dim W^{C5} = 1, dim W^{V4} = 2 (p=%d)" % p,
          len(d12pt) == 1 and len(d10) == 1 and len(lv) == 2)

    # ---------------- C. Layer 1 ------------------------------------------
    v4 = [r["id"] for r in E.rows if r["K"] == "V4"]
    check("C1 18 V4-rows, EVERY value is a type-I vertex ((F2)) (p=%d)" % p,
          len(v4) == 18 and all(all(v[1] == "PI" for v in E.dom[i]) for i in v4))
    kill = True
    for i in v4:
        r = [q for q in E.rows if q["id"] == i][0]
        keep = set(T.typeI_of[l][1] for _k, _c, l in E.dom[i])
        for kind, s in chain_invols(E, r):
            if kind in ("P_sigma", "Lminus_sigma") and s in keep:
                kill = False
    check("C2 the killed vertex is exactly v_sigma for each boundary sigma (p=%d)" % p,
          kill)
    forced = [r["id"] for r in E.rows if len(E.dom[r["id"]]) == 1]
    fs = [i for i in forced if E.dom[i][0][0] == "dom" and E.dom[i][0][1] == "L"]
    check("C3 exactly 3 rows forced to sweep L_sigma (p=%d)" % p, len(fs) == 3, fs)
    check("C4 the 3 forced sweeps are the D12-stabilised C2-rows (p=%d)" % p,
          all([q for q in E.rows if q["id"] == i][0]["setwise"] == "D12" for i in fs))
    may = [r["id"] for r in E.rows
           if any(v[0] == "dom" and v[1] == "L" for v in E.dom[r["id"]])]
    check("C5 exactly 15 rows may sweep, and they are the 15 C2-rows (p=%d)" % p,
          len(may) == 15 and all([q for q in E.rows if q["id"] == i][0]["K"] == "C2"
                                 for i in may))
    check("C6 no row can dominate E_sigma (rationality) (p=%d)" % p,
          all(not (v[0] == "dom" and v[1] == "E") for r in E.rows
              for v in E.dom[r["id"]]))
    egen = [r["id"] for r in E.rows
            if any(v[0] == "gen" and v[1] == "E" for v in E.dom[r["id"]])]
    check("C7 exactly one row may land on the E-cell (the D10 C2-line) (p=%d)" % p,
          len(egen) == 1 and
          [q for q in E.rows if q["id"] == egen[0]][0]["setwise"] == "C2", egen)
    check("C8 no row with Stab >= D12 has a constant value (X^{D12}=0) (p=%d)" % p,
          all(all(v[0] == "dom" for v in E.dom[r["id"]])
              for r in E.rows if r["setwise"] in ("D12", "PSL(2,11)")))
    check("C9 every C3-row with Stab = C6 is pinned to X^{C6} (2 points) (p=%d)" % p,
          all(len(E.dom[r["id"]]) == 2 and all(v[1] == "P6" for v in E.dom[r["id"]])
              for r in E.rows if r["K"] == "C3" and r["setwise"] == "C6"))
    blocks = E.blocks()
    counts = sorted((len(b), len(solve_block(E, b)[0])) for b in blocks if len(b) > 1)
    check("C10 constraint blocks: nine of size 3 with 2 solutions, one of size 18 "
          "with 84 (p=%d)" % p,
          counts == [(3, 2)] * 9 + [(18, 84)], counts)
    total = 1
    for b in blocks:
        total *= len(solve_block(E, b)[0])
    inb = set(i for b in blocks for i in b)
    for r in E.rows:
        if len(E.dom[r["id"]]) > 1 and r["id"] not in inb:
            total *= len(E.dom[r["id"]])
    check("C11 ARC-CONSISTENT (pre-coherence) count = 69686233329838325760000 "
          "(p=%d)" % p, total == 69686233329838325760000, total)
    check("C12 that count factors as 2^9 . 84 . 23 . 6^8 . 4^10 . 2^6 . 5^4 (p=%d)" % p,
          total == 2 ** 9 * 84 * 23 * 6 ** 8 * 4 ** 10 * 2 ** 6 * 5 ** 4)

    # ---------------- D. witness section -----------------------------------
    W = witness(E, lambda v: (0 if v[0] == "dom" else 1, str(v[1])))
    bad = [(a, b) for (a, ta, b, tb) in E.cons if not E.img_contains(W[a], ta, W[b], tb)]
    check("D1 witness section satisfies all closure constraints (p=%d)" % p,
          len(bad) == 0 and len(E.cons) == 145, "%d constraints" % len(E.cons))
    check("D2 witness sweeps all 15 sweepable rows (p=%d)" % p,
          sorted(i for i in W if W[i][0] == "dom" and W[i][1] == "L") == sorted(may))
    check("D3 witness lands on NO type-II point and NO E-cell point (p=%d)" % p,
          not any(W[i][1] == "PII" for i in W) and
          not any(W[i][0] == "gen" and W[i][1] == "E" for i in W))
    # minimal-sweep witness: BEFORE coherence, only the three order-0 forced rows
    # sweep.  (Evaluation coherence removes this section -- see H7.)
    dom2 = {r["id"]: ([v for v in E.dom[r["id"]] if v[0] != "dom"]
                      if r["id"] in may and r["id"] not in fs else E.dom[r["id"]])
            for r in E.rows}
    ok2 = try_solve(E, dom2)
    check("D4 arc-consistency alone admits a 3-sweep section (p=%d)" % p, ok2)
    # a section with no elliptic landing anywhere
    dom3 = {r["id"]: [v for v in E.dom[r["id"]] if not (v[0] == "gen" and v[1] == "E")]
            for r in E.rows}
    check("D5 a section exists with NO landing on any E_sigma (p=%d)" % p,
          try_solve(E, dom3))

    # ---------------- E. anchors -------------------------------------------
    check("E1 ANCHOR sweep rows have solutions (witness exists) (p=%d)" % p,
          len(bad) == 0)
    # isogeny packet: X^{C6} = the two rho-fixed points of L_t, swapped by D12/C6
    lab = T.comp["P6"][0]
    H6, t6 = T.c6_of[lab]
    rho = [g for g in H6 if m.order[g] == 3][0]
    fix = [l for l in T.comp["P6"] if T.c6_of[l][0] == H6]
    Lt = T.minus[t6]
    rho_fixed = []
    for lam in range(1, p):
        Ez = m.eigsp(rho, lam)
        I = m.inter(Ez, Lt) if Ez else ()
        if I and len(I) == 1:
            rho_fixed.append(I)
    check("E2 ANCHOR isogeny packet Thm 4: X^{C6} = the two rho-fixed points of "
          "L_t (p=%d)" % p,
          len(fix) == 2 and sorted(fix) == sorted(rho_fixed))
    swapped = any(T.act(g, "P6", fix[0]) == fix[1]
                  for g in m.G if m.mm(g, t6) == m.mm(t6, g))
    check("E3 ANCHOR the residual C2 = D12/C6 swaps them (p=%d)" % p, swapped)
    check("E4 ANCHOR isogeny Thm 3(a): X^sigma has no S3-fixed point (p=%d)" % p,
          m.F(d12pt[0]) % p != 0)
    # T5 / FIX-D2 cells are populated
    lv_rows = [r["id"] for r in E.rows
               if any(k == "ell_V" for k in [])] or []
    from s1label import row_label
    labels = {r["id"]: row_label(E, r) for r in E.rows}
    t5 = [i for i, s in labels.items() if "ell_V" in s]
    d2 = [i for i, s in labels.items() if "pt_D12" in s]
    check("E5 ANCHOR T5 cells (the ell_V band) are populated (p=%d)" % p,
          len(t5) >= 7 and all(len(E.dom[i]) >= 1 for i in t5), sorted(t5))
    check("E6 ANCHOR FIX-D2 cells (the D12-point band) are populated, and the "
          "D12-point C2-row is FORCED to sweep (p=%d)" % p,
          all(len(E.dom[i]) >= 1 for i in d2) and
          any(i in fs for i in d2), sorted(d2))
    check("E7 ANCHOR no section violates (F2) / base-locus rows / X^{D12}=0 (p=%d)" % p,
          all(all(v[1] == "PI" for v in E.dom[i]) for i in v4) and
          all(all(v[0] == "dom" for v in E.dom[r["id"]])
              for r in E.rows if r["setwise"] == "D12"))

    # ---------------- F. Layer 2 / Layer 3 ---------------------------------
    ex = exact_window(m, sig, dmax=45)
    check("F1 N(d,m) = 0 for every EVEN m (minus half has odd order) (p=%d)" % p,
          all(ex[(d, mm)][0] == 0 for (d, mm) in ex if mm % 2 == 0))
    check("F2 N^+(d,m) = 0 for every ODD m (plus half has even order) (p=%d)" % p,
          all(ex[(d, mm)][1] == 0 for (d, mm) in ex if mm % 2 == 1))
    check("F3 N(d,m) > 0 for EVERY odd m <= d <= 45 (no order-0 exclusion) (p=%d)" % p,
          all(ex[(d, mm)][0] > 0 for (d, mm) in ex if mm % 2 == 1))
    check("F4 window values N(1,1)=1, N(3,1)=4, N(25,3)=368, N(34,1)=397, "
          "N(43,1)=631 (p=%d)" % p,
          (ex[(1, 1)][0], ex[(3, 1)][0], ex[(25, 3)][0], ex[(34, 1)][0],
           ex[(43, 1)][0]) == (1, 4, 368, 397, 631))
    mp = window_table(m, sig, dmax=20)
    check("F5 mod-p and exact Z[zeta_6] character routes agree (d<=20) (p=%d)" % p,
          all(mp[(d, mm)][0] % p == ex[(d, mm)][0] % p for (d, mm) in mp))
    # F7/F8: the audit-derived closed form of sec.14, which is what removes the
    # d <= 45 restriction from Theorem 9(ii).  Added by the PR #32 adjudication:
    # sec.14 asserted it without a machine check.
    odd = [(d, mm) for (d, mm) in ex if mm % 2 == 1]
    check("F7 audit closed form N(d,m) = (1/3)[C(d-m+2,2)(m+1) - eps] agrees "
          "with the exact Z[zeta_6] route on every odd m <= d <= 45 (p=%d)" % p,
          all(ex[k][0] == closed_N(*k) for k in odd), "%d cases" % len(odd))
    check("F8 hence Theorem 9(ii) for ALL d: C(d-m+2,2)(m+1) >= 2 > 1 >= eps, "
          "so N(d,m) >= 1 for every odd m <= d (p=%d)" % p,
          all(comb(d - mm + 2, 2) * (mm + 1) >= 2
              for mm in range(1, 400, 2) for d in range(mm, 400)) and
          all(closed_N(*k) >= 1 for k in odd))
    # Layer 2 cross-check: the F_p linear-algebra module dimension at (a,b)=(2,1)
    from s1layer2 import sweep_moduli
    out, dims, ng = sweep_moduli(E, fs_row(E, "P_sigma"), maxdeg=3)
    triv = tuple([1] * 4)
    got = {k: v for k, v in out.items()}
    ok = True
    for (a, b), dd in got.items():
        want = ex[(a + b, b)][0]
        have = max(dd.values()) if dd else 0
        if b % 2 == 1 and want != max(dd.get(k, 0) for k in dd):
            ok = ok and (want in dd.values())
    check("F6 Layer-2 module dims = Layer-3 character dims on the P_sigma row "
          "(p=%d)" % p, ok)

    # ---------------- H. evaluation coherence (audit repair) ----------------
    from s1recount import build_tables, coherent_count, sweep_rows
    from produce_coherence import verdicts as coh_verdicts
    tables, cmeta = build_tables(E)
    check("H1 RIGIDITY: the evaluation of every component of every M_S at every "
          "child is 0- or 1-dimensional, never 2 (p=%d)" % p,
          sum(m["rigid_fail"] for m in cmeta.values()) == 0)
    vd = coh_verdicts(E, tables)
    nonsurj = sorted(k for k, v in vd.items() if not v["surjective"])
    check("H2 exactly two evaluation maps are NOT surjective, and they are the "
          "two dim-3 divisors (p=%d)" % p,
          len(nonsurj) == 2 and all(
              [q for q in E.rows if q["id"] == k][0]["dim"] == 3 and
              [q for q in E.rows if q["id"] == k][0]["setwise"] == "D12"
              for k in nonsurj), nonsurj)
    check("H3 the other 13 evaluation maps ARE surjective onto their "
          "arc-consistent products (p=%d)" % p,
          all(v["surjective"] for k, v in vd.items() if k not in nonsurj))
    img = {k: (vd[k]["n_image"], vd[k]["n_arc_consistent"]) for k in nonsurj}
    check("H4 the two proper images have sizes 128 (of 262144) and 64 (of 128) "
          "(p=%d)" % p, sorted(img.values()) == [(64, 128), (128, 262144)], img)
    ctotal, cblocks = coherent_count(E, tables)
    check("H5 COHERENT count = 1088847395778723840000 (p=%d)" % p,
          ctotal == 1088847395778723840000, ctotal)
    check("H6 it factors as 2^11 . 21 . 23 . 6^8 . 4^10 . 5^4 (p=%d)" % p,
          ctotal == 2 ** 11 * 21 * 23 * 6 ** 8 * 4 ** 10 * 5 ** 4)
    check("H7 coherence divides the arc-consistent count by exactly 64 = 2^6 "
          "(p=%d)" % p, total == 64 * ctotal)
    core = max(cblocks, key=lambda b: b["size"])
    check("H8 the coupled core is one block of 51 rows with 43008 = 2^11 . 21 "
          "patterns (p=%d)" % p,
          core["size"] == 51 and core["solutions"] == 43008,
          (core["size"], core["solutions"]))
    imm = [b for b in cblocks if b["size"] == 1]
    immprod = 1
    for b in imm:
        immprod *= b["solutions"]
    check("H9 the coherence-immune factor is 23 . 6^8 . 4^10 . 5^4 -- the D10 row "
          "and the odd-order point rows (p=%d)" % p,
          immprod == 23 * 6 ** 8 * 4 ** 10 * 5 ** 4, immprod)
    check("H10 every coherence-immune row has the free stratum as its only "
          "proper parent (p=%d)" % p,
          all(all(E.byoid[E.S.orbit_of[j]]["id"] == 0
                  for j in E.above[b["rows"][0]]) for b in imm))
    # the newly forced rows
    newforced = coherent_forced(E, tables, core["rows"])
    swept5 = [i for i in newforced if E.dom[i][0][0] == "dom" or
              any(v[0] == "dom" for v in E.dom[i])]
    nf_sweep = [i for i in newforced
                if all(v[0] == "dom" for v in [newforced[i]])]
    check("H11 coherence forces 15 more rows to a single value: 5 C2-rows to "
          "sweep and 10 V4-rows to one vertex (p=%d)" % p,
          len(newforced) == 15 and
          sum(1 for i, v in newforced.items() if v[0] == "dom") == 5 and
          sum(1 for i, v in newforced.items() if v[1] == "PI") == 10,
          sorted(newforced))
    check("H12 hence 8 rows sweep in EVERY coherent section (3 by order 0 + 5 by "
          "coherence) and 12 of the 18 V4-rows are pinned (p=%d)" % p,
          len(fs) + sum(1 for i, v in newforced.items() if v[0] == "dom") == 8)
    # the witness section must still be coherent
    okW = all(any(all(W.get(r0) == v for r0, v in a.items()) for a in tables[s])
              for s in sweep_rows(E)
              if W[s][0] == "dom" and W[s][1] == "L")
    check("H13 the maximal-sweep witness section is evaluation-coherent (p=%d)" % p,
          okW)
    check("H14 the pre-coherence 3-sweep section is NOT coherent (5 more rows "
          "must sweep) (p=%d)" % p,
          not coherent_solvable(E, tables, fs, may))
    return E


def coherent_forced(E, tables, coreids):
    """rows of the coupled core whose value is unique once coherence is imposed."""
    from s1recount import forced_sweeps
    ids = sorted(coreids)
    idset = set(ids)
    cons = [(a, ta, b, tb) for (a, ta, b, tb) in E.cons if a in idset and b in idset]
    forced = set(forced_sweeps(E))
    rel = [rid for rid, tab in tables.items()
           if (set().union(*[set(a) for a in tab]) | {rid}) & idset]
    order = sorted(ids, key=lambda i: (0 if i in tables else 1, len(E.dom[i]), i))
    val, seen = {}, {i: set() for i in ids}

    def sweeping(s):
        if s in forced:
            return True
        if s not in val:
            return None
        return val[s][0] == "dom" and val[s][1] == "L"

    def tok():
        for s in rel:
            if sweeping(s) is not True:
                continue
            if not any(all(val.get(r0) in (None, v) for r0, v in a.items())
                       for a in tables[s]):
                return False
        return True

    def rec(k):
        if k == len(order):
            for i in ids:
                seen[i].add(val[i])
            return
        i = order[k]
        for v in E.dom[i]:
            val[i] = v
            if all(E.img_contains(val[a], ta, val[b], tb) for (a, ta, b, tb) in cons
                   if a in val and b in val and (a == i or b == i)) and tok():
                rec(k + 1)
            val.pop(i, None)

    rec(0)
    return {i: next(iter(seen[i])) for i in ids
            if len(seen[i]) == 1 and len(E.dom[i]) > 1}


def coherent_solvable(E, tables, fs, may):
    """is there a coherent section in which only the rows `fs` sweep?"""
    from s1recount import forced_sweeps
    dom = {r["id"]: ([v for v in E.dom[r["id"]] if v[0] != "dom"]
                     if r["id"] in may and r["id"] not in fs else E.dom[r["id"]])
           for r in E.rows}
    if any(not d for d in dom.values()):
        return False
    forced = set(forced_sweeps(E))
    rel = list(tables)
    order = sorted(dom, key=lambda i: len(dom[i]))
    val = {}

    def tok():
        for s in rel:
            sw = (s in forced) or (s in val and val[s][0] == "dom")
            if not sw:
                continue
            if not any(all(val.get(r0) in (None, v) for r0, v in a.items())
                       for a in tables[s]):
                return False
        return True

    def rec(k):
        if k == len(order):
            return True
        i = order[k]
        for v in dom[i]:
            val[i] = v
            if all(E.img_contains(val[a], ta, val[b], tb) for (a, ta, b, tb) in E.cons
                   if a in val and b in val) and tok():
                if rec(k + 1):
                    return True
            val.pop(i, None)
        return False

    return rec(0)


def fs_row(E, chainname):
    from s1label import row_label
    for r in E.rows:
        if row_label(E, r) == chainname:
            return r["id"]
    raise KeyError(chainname)


def try_solve(E, dom):
    ids = [r["id"] for r in E.rows]
    if any(not dom[i] for i in ids):
        return False
    order = sorted(ids, key=lambda i: len(dom[i]))
    assign = {}

    def rec(k):
        if k == len(order):
            return True
        i = order[k]
        for v in dom[i]:
            assign[i] = v
            if all(E.img_contains(assign[a], ta, assign[b], tb)
                   for (a, ta, b, tb) in E.cons if a in assign and b in assign):
                if rec(k + 1):
                    return True
            assign.pop(i, None)
        return False

    return rec(0)


def main():
    ps = [int(x) for x in sys.argv[1:]] or [331, 661]
    Es = [run_prime(p) for p in ps]
    if len(Es) == 2:
        a, b = Es
        sa = sorted((r["K"], r["dim"], r["n_orbit"], r["setwise"],
                     len(a.dom[r["id"]]),
                     tuple(sorted(Counter(cellname(v) for v in a.dom[r["id"]]).items())))
                    for r in a.rows)
        sb = sorted((r["K"], r["dim"], r["n_orbit"], r["setwise"],
                     len(b.dom[r["id"]]),
                     tuple(sorted(Counter(cellname(v) for v in b.dom[r["id"]]).items())))
                    for r in b.rows)
        check("G1 the two primes give identical classifications", sa == sb)
    print("\n%d checks, %d failures" % (len(CHECKS), len(FAILS)))
    with open(os.path.join(HERE, "results", "verifier_stdout.txt"), "w") as f:
        for n, c, d in CHECKS:
            f.write("CHECK %-58s : %s  %s\n" % (n, "PASS" if c else "FAIL", d))
        f.write("\n%d checks, %d failures\n" % (len(CHECKS), len(FAILS)))
        if not FAILS:
            f.write("STAGE1_COMPLEX_MAPS_VERIFY_OK\nALLGREEN\n")
    if FAILS:
        print("FAILURES:", FAILS)
        sys.exit(1)
    print("STAGE1_COMPLEX_MAPS_VERIFY_OK")
    print("ALLGREEN")


if __name__ == "__main__":
    main()
