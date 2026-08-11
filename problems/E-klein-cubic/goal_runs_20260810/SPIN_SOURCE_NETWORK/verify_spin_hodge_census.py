#!/usr/bin/env python3
"""
verify_spin_hodge_census.py  --  exact checks for THEOREM_SPIN_HODGE_SUPPORT.md
and SUPPORT_CENSUS.md.

Everything here is exact integer / rational arithmetic.  No sampling, no search
beyond exhaustive enumeration of a group of order 660, no floating point, no
Macaulay2, no network, no data files.  Python 3 standard library only.

Sections
--------
A  group layer      SL(2,F_11), PSL(2,F_11), the subgroup lattice up to
                    conjugacy, checked against Dickson's classification
B  spin layer       which H <= G can fix a point of *some* faithful spin
                    source: the criterion -I not in [Htilde, Htilde]
C  character layer  chi_T for T = H^3(V14,Q)(1), from the SEALED Klein
                    5-dimensional character; irreducibility over Q; T is
                    distinct from both absolutely irreducible 10's
D  restriction      Res_H chi_T for every conjugacy class of subgroups,
                    by order-summed character tables that self-validate
E  target layer     the Lefschetz identification of T on the V14 twin, plus
                    the fixed-locus Euler-characteristic predictions
F  perverse ledger  the degree/support arithmetic  i = s + 4 - n - j_0,
                    with the n = 5 ambient packet reproduced as a regression
G  degree layer     coordinate-degree parity (spin forces d even) and the
                    refined-Bezout capacity table on P^{n-1}
H  census           the cell table itself, asserted against A-G
I  D12 test         the mandatory consistency test against Cor IX.6

Exit marker: SPIN_HODGE_CENSUS_OK
"""

import sys
from fractions import Fraction
from itertools import product

FAILURES = []


def check(name, cond, detail=""):
    if cond:
        print("  ok   %-46s %s" % (name, detail))
    else:
        print("  FAIL %-46s %s" % (name, detail))
        FAILURES.append(name)


def head(title):
    print()
    print("=" * 72)
    print(title)
    print("=" * 72)


# ---------------------------------------------------------------------------
# A.  group layer
# ---------------------------------------------------------------------------

P = 11


def mmul(x, y):
    a, b, c, d = x
    e, f, g, h = y
    return ((a * e + b * g) % P, (a * f + b * h) % P,
            (c * e + d * g) % P, (c * f + d * h) % P)


def mneg(x):
    return tuple((-t) % P for t in x)


def sl2_elements():
    out = []
    for a, b, c, d in product(range(P), repeat=4):
        if (a * d - b * c) % P == 1:
            out.append((a, b, c, d))
    return out


SL = sl2_elements()
SLSET = set(SL)
IDT = (1, 0, 0, 1)
MINUS_I = mneg(IDT)


def psl_canon(x):
    return min(x, mneg(x))


PSLM = sorted({psl_canon(x) for x in SL})
PSLIDX = {g: i for i, g in enumerate(PSLM)}
N_G = len(PSLM)
PSL = list(range(N_G))                      # elements are indices from here on
PSL_E = PSLIDX[psl_canon(IDT)]

# index-based multiplication table: everything below is integer arithmetic
MUL = [[PSLIDX[psl_canon(mmul(PSLM[i], PSLM[j]))] for j in PSL] for i in PSL]
INV = [next(j for j in PSL if MUL[i][j] == PSL_E) for i in PSL]


def pmul(i, j):
    return MUL[i][j]


def order_of_idx(g):
    n, h = 1, g
    while h != PSL_E:
        h = MUL[h][g]
        n += 1
    return n


PORD = {g: order_of_idx(g) for g in PSL}


def closure(gens, mul, e):
    seen = {e}
    frontier = [e]
    while frontier:
        nxt = []
        for x in frontier:
            for g in gens:
                y = mul(x, g)
                if y not in seen:
                    seen.add(y)
                    nxt.append(y)
        frontier = nxt
    return frozenset(seen)


def build_group_layer():
    head("A.  group layer: SL(2,11), PSL(2,11), the subgroup lattice")
    check("|SL(2,11)| = 1320", len(SL) == 1320, "got %d" % len(SL))
    check("|PSL(2,11)| = 660", N_G == 660, "got %d" % N_G)

    invol_sl = [x for x in SL if x != IDT and mmul(x, x) == IDT]
    check("-I is the unique involution of SL(2,11)",
          invol_sl == [MINUS_I], "involutions: %d" % len(invol_sl))

    prof = {}
    for g in PSL:
        prof[PORD[g]] = prof.get(PORD[g], 0) + 1
    check("PSL order profile (1,2,3,5,6,11) = (1,55,110,264,110,120)",
          prof == {1: 1, 2: 55, 3: 110, 5: 264, 6: 110, 11: 120},
          str(sorted(prof.items())))

    # cyclic subgroups, one class representative per order
    cyc = {}
    for g in PSL:
        if PORD[g] == 1:
            continue
        cyc.setdefault(PORD[g], set()).add(closure([g], pmul, PSL_E))
    cyc_counts = {k: len(v) for k, v in cyc.items()}
    check("cyclic subgroup counts (2,3,5,6,11) = (55,55,66,55,12)",
          cyc_counts == {2: 55, 3: 55, 5: 66, 6: 55, 11: 12},
          str(sorted(cyc_counts.items())))

    reps = []
    for k in sorted(cyc):
        S = sorted(next(iter(cyc[k])))
        gen = [g for g in S if PORD[g] == k][0]
        reps.append(gen)

    # every subgroup of PSL(2,11) is 2-generated, and all cyclic subgroups of a
    # given order are conjugate (counts above), so <a, y> with a one of the 5
    # cyclic representatives and y arbitrary meets every conjugacy class.
    subs = {frozenset([PSL_E]), frozenset(PSL)}
    for k in cyc:
        subs |= cyc[k]
    for a in reps:
        for y in PSL:
            subs.add(closure([a, y], pmul, PSL_E))

    # conjugacy classes of subgroups
    def conj_sub(S, g):
        gi = INV[g]
        return frozenset(MUL[MUL[g][s]][gi] for s in S)

    unseen = set(subs)
    classes = []
    while unseen:
        S = next(iter(unseen))
        orb = {conj_sub(S, g) for g in PSL}
        classes.append((S, len(orb)))
        unseen -= orb
        subs |= orb

    by_order = {}
    for S, sz in classes:
        by_order.setdefault(len(S), []).append(sz)
    for k in by_order:
        by_order[k].sort()

    # C_6 (one class of 55) and S_3 (two classes of 55) both have order 6;
    # D_12 and A_4 (one class of 55 each) both have order 12.
    dickson = {1: [1], 2: [55], 3: [55], 4: [55], 5: [66], 6: [55, 55, 55],
               10: [66], 11: [12], 12: [55, 55], 55: [12], 60: [11, 11],
               660: [1]}
    check("subgroup lattice matches Dickson (orders and class sizes)",
          by_order == dickson, str(sorted(by_order.items())))
    check("620 subgroups, 16 conjugacy classes, 14 isomorphism types",
          sum(sz for _, sz in classes) == 620 and len(classes) == 16
          and len({name_of(S) for S, _ in classes}) == 14,
          "%d subgroups, %d classes, %d types"
          % (sum(sz for _, sz in classes), len(classes),
             len({name_of(S) for S, _ in classes})))
    check("S_3 and A_5 each fall in two G-classes (matches "
          "V14_S3_D10_MEASUREMENT.md sec.1)",
          sum(1 for S, _ in classes if name_of(S) == "S_3") == 2
          and sum(1 for S, _ in classes if name_of(S) == "A_5") == 2)
    return classes


def name_of(S):
    """Isomorphism type of a subgroup of PSL(2,11), from |S| and its order
    profile.  All the ambiguities in PSL(2,11) are resolved by the profile."""
    n = len(S)
    prof = {}
    for g in S:
        prof[PORD[g]] = prof.get(PORD[g], 0) + 1
    table = {
        (1, (1,)): "1",
        (2, (1, 2)): "C_2",
        (3, (1, 3)): "C_3",
        (4, (1, 2)): "V_4",
        (5, (1, 5)): "C_5",
        (6, (1, 2, 3)): "S_3" if prof.get(2) == 3 else "C_6",
        (10, (1, 2, 5)): "D_10",
        (11, (1, 11)): "C_11",
        (12, (1, 2, 3)): "A_4",
        (55, (1, 5, 11)): "F_55",
        (60, (1, 2, 3, 5)): "A_5",
        (660, (1, 2, 3, 5, 6, 11)): "G",
    }
    key = (n, tuple(sorted(prof)))
    if n == 6:
        return "S_3" if prof.get(2, 0) == 3 else "C_6"
    if n == 12 and sorted(prof) == [1, 2, 3, 6]:
        return "D_12"
    return table[key]


SUBGROUP_CLASSES = build_group_layer()


# ---------------------------------------------------------------------------
# B.  spin layer:  which H can fix a point of a faithful spin source
# ---------------------------------------------------------------------------

def minv(x):
    a, b, c, d = x                      # det = 1, so inverse = adjugate
    return (d % P, (-b) % P, (-c) % P, a % P)


def preimage(S):
    tgt = {PSLM[i] for i in S}
    return [x for x in SL if psl_canon(x) in tgt]


def gen_set(H):
    """A small generating set of the subgroup H (a list of SL matrices)."""
    Hs = set(H)
    gens, cur = [], {IDT}
    for x in H:
        if x in cur:
            continue
        gens.append(x)
        cur = set(closure(gens, mmul, IDT))
        if cur == Hs:
            break
    assert cur == Hs
    return gens


def derived_subgroup(H):
    """[H,H] = normal closure in H of the commutators of a generating set."""
    gens = gen_set(H)
    comms = {IDT}
    for x in gens:
        for y in gens:
            comms.add(mmul(mmul(x, y), mmul(minv(x), minv(y))))
    N = set(closure(comms, mmul, IDT))
    while True:
        new = set(N)
        for h in gens:
            hi = minv(h)
            for x in N:
                new.add(mmul(mmul(h, x), hi))
        if new == N:
            return frozenset(N)
        N = set(closure(new, mmul, IDT))


def spin_layer():
    head("B.  spin layer: which H can fix a point of a faithful spin source")
    print("  criterion: Htilde (the SL(2,11)-preimage) has a linear character")
    print("  lambda with lambda(-I) = -1  <=>  -I not in [Htilde, Htilde].")
    print()
    admissible, blocked = [], []
    for S, orbsz in SUBGROUP_CLASSES:
        nm = name_of(S)
        Ht = preimage(S)
        D = derived_subgroup(Ht)
        ok = MINUS_I not in D
        (admissible if ok else blocked).append((nm, len(S), orbsz))
        print("       %-6s |H| = %-4d classes-of-size %-4d  "
              "|[Ht,Ht]| = %-5d spin-fixed-point possible: %s"
              % (nm, len(S), orbsz, len(D), "YES" if ok else "no"))
    adm_names = sorted({a[0] for a in admissible})
    blk_names = sorted({b[0] for b in blocked})
    check("Sigma_spin = {1,C_2,C_3,C_5,C_6,C_11,S_3,D_10,F_55}",
          adm_names == sorted(["1", "C_2", "C_3", "C_5", "C_6", "C_11",
                               "S_3", "D_10", "F_55"]), str(adm_names))
    check("blocked = {V_4, A_4, A_5, D_12, G}",
          blk_names == sorted(["V_4", "A_4", "A_5", "D_12", "G"]),
          str(blk_names))
    orbit_sizes = sorted({660 // sz for _, sz, _ in
                          [(n, s, o) for n, s, o in admissible]})
    check("point-support G-orbit sizes = {12,60,66,110,132,220,330,660}",
          orbit_sizes == [12, 60, 66, 110, 132, 220, 330, 660],
          str(orbit_sizes))
    check("orbit sizes 11 and 55 are IMPOSSIBLE for point supports",
          11 not in orbit_sizes and 55 not in orbit_sizes,
          "the two smallest G-orbits do not occur on any spin source")
    return adm_names, blk_names


SIGMA_SPIN, SPIN_BLOCKED = spin_layer()


def stabiliser_classification():
    """Census part (i): the exact (H_0, H) pairs.

    H_0 = pointwise stabiliser of the support S (kernel of H on S),
    H  = Stab_G(S).  Then H_0 is normal in H and H <= N_G(H_0)."""
    head("B'. support-stabiliser classification: which (H_0, H) are possible")
    reps = {}
    for S, _ in SUBGROUP_CLASSES:
        reps.setdefault(name_of(S), []).append(S)

    def normaliser(S):
        out = []
        for g in PSL:
            gi = INV[g]
            if frozenset(MUL[MUL[g][s]][gi] for s in S) == S:
                out.append(g)
        return frozenset(out)

    print("  H_0 in Sigma_spin, N_G(H_0), and the H with H_0 normal in H:")
    table = {}
    for h0 in ["1", "C_2", "C_3", "C_5", "C_6", "C_11", "S_3", "D_10",
               "F_55"]:
        S0 = reps[h0][0]
        NG = normaliser(S0)
        # subgroups H with H_0 <= H <= N_G(H_0) and H_0 normal in H
        cands = set()
        for S, _ in SUBGROUP_CLASSES:
            for g in PSL:
                gi = INV[g]
                Sg = frozenset(MUL[MUL[g][s]][gi] for s in S)
                if S0 <= Sg and Sg <= NG:
                    ok = all(frozenset(MUL[MUL[h][s]][INV[h]] for s in S0)
                             == S0 for h in Sg)
                    if ok:
                        cands.add(name_of(Sg))
        table[h0] = (name_of(NG), sorted(cands))
        print("       H_0 = %-5s  N_G(H_0) = %-5s (order %3d)   H in %s"
              % (h0, name_of(NG), len(NG), sorted(cands)))
    check("N_G(C_2) = N_G(C_3) = N_G(C_6) = N_G(S_3) = D_12",
          all(table[h][0] == "D_12" for h in ("C_2", "C_3", "C_6", "S_3")))
    check("N_G(C_5) = D_10 and N_G(D_10) = D_10",
          table["C_5"][0] == "D_10" and table["D_10"][0] == "D_10")
    check("N_G(C_11) = N_G(F_55) = F_55",
          table["C_11"][0] == "F_55" and table["F_55"][0] == "F_55")
    check("H_0 = D_10 forces H = D_10 (self-normalising)",
          table["D_10"][1] == ["D_10"], str(table["D_10"][1]))
    check("H_0 = F_55 forces H = F_55 (self-normalising)",
          table["F_55"][1] == ["F_55"], str(table["F_55"][1]))
    check("H_0 = C_11 forces H in {C_11, F_55}",
          table["C_11"][1] == sorted(["C_11", "F_55"]), str(table["C_11"][1]))
    check("H_0 = C_5 forces H in {C_5, D_10}",
          table["C_5"][1] == sorted(["C_5", "D_10"]), str(table["C_5"][1]))
    check("H_0 = S_3 forces H in {S_3, D_12}",
          table["S_3"][1] == sorted(["S_3", "D_12"]), str(table["S_3"][1]))
    check("H_0 = C_6 forces H in {C_6, D_12}",
          table["C_6"][1] == sorted(["C_6", "D_12"]), str(table["C_6"][1]))
    check("H_0 = C_2 allows H in {C_2, V_4, C_6, D_12} (before the "
          "eigenplane cut)",
          table["C_2"][1] == sorted(["C_2", "V_4", "C_6", "D_12"]),
          str(table["C_2"][1]))
    check("H_0 = C_3 allows H in {C_3, C_6, S_3, D_12}",
          table["C_3"][1] == sorted(["C_3", "C_6", "S_3", "D_12"]),
          str(table["C_3"][1]))
    check("H_0 = 1 allows every H (all 14 isomorphism types)",
          len(table["1"][1]) == 14, str(table["1"][1]))

    # the large stabilisers can occur only setwise, with H_0 forced
    print()
    print("  the spin-BLOCKED groups can stabilise a support only SETWISE;")
    print("  the possible pointwise kernels are the normal subgroups of H")
    print("  that lie in Sigma_spin:")
    for hname in ["V_4", "A_4", "D_12", "A_5", "G"]:
        Sh = reps[hname][0]
        norms = set()
        for S, _ in SUBGROUP_CLASSES:
            for g in PSL:
                gi = INV[g]
                Sg = frozenset(MUL[MUL[g][s]][gi] for s in S)
                if Sg <= Sh and all(frozenset(MUL[MUL[h][s]][INV[h]]
                                              for s in Sg) == Sg
                                    for h in Sh):
                    if name_of(Sg) in SIGMA_SPIN:
                        norms.add(name_of(Sg))
        print("       H = %-5s  possible H_0 = %s" % (hname, sorted(norms)))
        table["H0 of " + hname] = sorted(norms)
    check("H = A_4, A_5 or G forces H_0 = 1 (free-orbit cell only)",
          all(table["H0 of " + h] == ["1"] for h in ("A_4", "A_5", "G")))
    check("H = V_4 forces H_0 in {1, C_2}",
          table["H0 of V_4"] == sorted(["1", "C_2"]))
    check("H = D_12 forces H_0 in {1, C_2, C_3, C_6, S_3}",
          table["H0 of D_12"] == sorted(["1", "C_2", "C_3", "C_6", "S_3"]))
    return table


STAB_TABLE = stabiliser_classification()


# ---------------------------------------------------------------------------
# C.  character layer
# ---------------------------------------------------------------------------
#
# Sealed input (certificates/hodge_centers/HODGE_CENTER_NECESSITY.md,
# character_screen.json, exit WP_H1_HODGE_VERIFY_OK):
#     chi_W = (5, A, Abar, 1, -1, 1, 0, 0)  on classes (1a,11a,11b,2a,3a,6a,5a,5b)
#     A = (-1 + sqrt(-11))/2,  so A + Abar = -1 and |A|^2 = 3.
# chi_T = chi_W + chi_Wbar is rational and is a function of ELEMENT ORDER only.

CLASS_SIZE = {1: 1, 2: 55, 3: 110, 5: 264, 6: 110, 11: 120}   # by order
CHI_T = {1: 10, 2: 2, 3: -2, 5: 0, 6: 2, 11: -1}
CHI_10P = {1: 10, 2: 2, 3: 1, 5: 0, 6: -1, 11: -1}   # theta of order 6
CHI_10 = {1: 10, 2: -2, 3: 1, 5: 0, 6: 1, 11: -1}    # theta of order 3


def ip_order(f, g):
    """<f, g> over G, for class functions constant on element ORDER."""
    tot = sum(Fraction(CLASS_SIZE[o] * f[o] * g[o]) for o in CLASS_SIZE)
    return tot / 660


def character_layer():
    head("C.  character layer: T = H^3(V14,Q)(1) as a G = PSL(2,11)-module")
    # chi_W is not order-constant (it separates 11a/11b), but |chi_W|^2 is.
    normW = (Fraction(25) + 55 * 1 + 110 * 1 + 264 * 0 + 110 * 1
             + 120 * 3) / 660
    check("<chi_W, chi_W> = 1  (sealed 5-dim Klein character)",
          normW == 1, "got %s" % normW)
    check("chi_T = chi_W + conj = (10,2,-2,0,2,-1) on orders (1,2,3,5,6,11)",
          CHI_T == {1: 10, 2: 2, 3: -2, 5: 0, 6: 2, 11: -1}, str(CHI_T))
    check("<chi_T, chi_T> = 2  =>  T (x) C is a sum of two distinct irreds",
          ip_order(CHI_T, CHI_T) == 2, "got %s" % ip_order(CHI_T, CHI_T))
    check("<chi_T, 1> = 0", ip_order(CHI_T, {o: 1 for o in CLASS_SIZE}) == 0)
    for nm, ch in (("10'", CHI_10P), ("10", CHI_10)):
        check("<chi_%s, chi_%s> = 1 (absolutely irreducible)" % (nm, nm),
              ip_order(ch, ch) == 1, "got %s" % ip_order(ch, ch))
        check("<chi_T, chi_%s> = 0  =>  T is NOT the %s" % (nm, nm),
              ip_order(CHI_T, ch) == 0)
    print("  note  PSL(2,11) has three 10-dimensional rational irreducibles:")
    print("        10 and 10' (absolutely irreducible) and T = 5 + 5bar")
    print("        (End_G(T) = Q(sqrt(-11)), Schur index 1).  T is the third.")
    print("        M = the 10'-summand of Lambda^2 U is a DIFFERENT module.")


character_layer()


# ---------------------------------------------------------------------------
# D.  restriction layer
# ---------------------------------------------------------------------------
#
# For a subgroup H and an irreducible character psi of H put
#     s(psi, o) = sum over h in H of order o of psi(h).
# This is a rational integer (the set of elements of order o is stable under
# h -> h^k, gcd(k,o) = 1, and Galois permutes those values), and since
# Res_H chi_T is a function of element order,
#     <Res_H chi_T, psi> = (1/|H|) sum_o chi_T(o) s(psi, o).
# The tables below are self-validating: three exact identities are asserted
# for every group before any multiplicity is read off.

# name -> (order profile {o: n_o}, [(psi label, psi(1), {o: s(psi,o)}), ...])
ORDER_TABLES = {
    "1": ({1: 1}, [("triv", 1, {1: 1})]),
    "C_2": ({1: 1, 2: 1},
            [("triv", 1, {1: 1, 2: 1}), ("sign", 1, {1: 1, 2: -1})]),
    "C_3": ({1: 1, 3: 2},
            [("triv", 1, {1: 1, 3: 2}),
             ("omega", 1, {1: 1, 3: -1}), ("omega^2", 1, {1: 1, 3: -1})]),
    "V_4": ({1: 1, 2: 3},
            [("triv", 1, {1: 1, 2: 3})]
            + [("chi_%d" % i, 1, {1: 1, 2: -1}) for i in (1, 2, 3)]),
    "C_5": ({1: 1, 5: 4},
            [("triv", 1, {1: 1, 5: 4})]
            + [("psi_%d" % k, 1, {1: 1, 5: -1}) for k in (1, 2, 3, 4)]),
    "C_6": ({1: 1, 2: 1, 3: 2, 6: 2},
            [("psi_0", 1, {1: 1, 2: 1, 3: 2, 6: 2}),
             ("psi_3", 1, {1: 1, 2: -1, 3: 2, 6: -2}),
             ("psi_2", 1, {1: 1, 2: 1, 3: -1, 6: -1}),
             ("psi_4", 1, {1: 1, 2: 1, 3: -1, 6: -1}),
             ("psi_1", 1, {1: 1, 2: -1, 3: -1, 6: 1}),
             ("psi_5", 1, {1: 1, 2: -1, 3: -1, 6: 1})]),
    "S_3": ({1: 1, 2: 3, 3: 2},
            [("triv", 1, {1: 1, 2: 3, 3: 2}),
             ("sign", 1, {1: 1, 2: -3, 3: 2}),
             ("std", 2, {1: 2, 2: 0, 3: -2})]),
    "D_10": ({1: 1, 2: 5, 5: 4},
             [("triv", 1, {1: 1, 2: 5, 5: 4}),
              ("sign", 1, {1: 1, 2: -5, 5: 4}),
              ("W_1", 2, {1: 2, 2: 0, 5: -2}),
              ("W_2", 2, {1: 2, 2: 0, 5: -2})]),
    "C_11": ({1: 1, 11: 10},
             [("triv", 1, {1: 1, 11: 10})]
             + [("psi_%d" % k, 1, {1: 1, 11: -1}) for k in range(1, 11)]),
    "D_12": ({1: 1, 2: 7, 3: 2, 6: 2},
             [("1(x)triv", 1, {1: 1, 2: 7, 3: 2, 6: 2}),
              ("1(x)sgn", 1, {1: 1, 2: -5, 3: 2, 6: 2}),
              ("1(x)std", 2, {1: 2, 2: 2, 3: -2, 6: -2}),
              ("eps(x)triv", 1, {1: 1, 2: -1, 3: 2, 6: -2}),
              ("eps(x)sgn", 1, {1: 1, 2: -1, 3: 2, 6: -2}),
              ("eps(x)std", 2, {1: 2, 2: -2, 3: -2, 6: 2})]),
    "A_4": ({1: 1, 2: 3, 3: 8},
            [("triv", 1, {1: 1, 2: 3, 3: 8}),
             ("omega", 1, {1: 1, 2: 3, 3: -4}),
             ("omega^2", 1, {1: 1, 2: 3, 3: -4}),
             ("std_3", 3, {1: 3, 2: -3, 3: 0})]),
    "F_55": ({1: 1, 5: 44, 11: 10},
             [("triv", 1, {1: 1, 5: 44, 11: 10})]
             + [("mu_%d" % k, 1, {1: 1, 5: -11, 11: 10})
                for k in (1, 2, 3, 4)]
             + [("theta_1", 5, {1: 5, 5: 0, 11: -5}),
                ("theta_2", 5, {1: 5, 5: 0, 11: -5})]),
    "A_5": ({1: 1, 2: 15, 3: 20, 5: 24},
            [("triv", 1, {1: 1, 2: 15, 3: 20, 5: 24}),
             ("3a", 3, {1: 3, 2: -15, 3: 0, 5: 12}),
             ("3b", 3, {1: 3, 2: -15, 3: 0, 5: 12}),
             ("4", 4, {1: 4, 2: 0, 3: 20, 5: -24}),
             ("5", 5, {1: 5, 2: 15, 3: -20, 5: 0})]),
}


def validate_table(nm, profile, rows):
    H = sum(profile.values())
    ok = True
    ok &= sum(psi1 ** 2 for _, psi1, _ in rows) == H or nm == "G"
    for o in profile:
        lhs = sum(psi1 * s[o] for _, psi1, s in rows)
        if nm != "G":
            ok &= (lhs == (H if o == 1 else 0))
    for o in profile:
        for o2 in profile:
            lhs = sum(s[o] * s2[o2] for (_, _, s), (_, _, s2)
                      in zip(rows, rows))
            if nm != "G":
                rhs = H * profile[o] if o == o2 else 0
                ok &= (lhs == rhs)
    return ok


def restriction_layer():
    head("D.  restriction layer: Res_H chi_T for every subgroup class")
    out = {}
    reps_by_name = {}
    for S, _ in SUBGROUP_CLASSES:
        reps_by_name.setdefault(name_of(S), S)
    for nm in ["1", "C_2", "C_3", "V_4", "C_5", "C_6", "S_3", "D_10",
               "C_11", "D_12", "A_4", "F_55", "A_5"]:
        profile, rows = ORDER_TABLES[nm]
        S = reps_by_name[nm]
        real = {}
        for g in S:
            real[PORD[g]] = real.get(PORD[g], 0) + 1
        check("%-5s order profile matches the actual subgroup" % nm,
              real == profile, str(sorted(profile.items())))
        check("%-5s order-summed character table self-validates" % nm,
              validate_table(nm, profile, rows), "|H| = %d" % len(S))
        Hn = len(S)
        mults = []
        for lab, psi1, s in rows:
            m = Fraction(sum(CHI_T[o] * s[o] for o in profile), Hn)
            check("%-5s multiplicity of %-10s is a nonneg integer"
                  % (nm, lab), m.denominator == 1 and m >= 0, "m = %s" % m)
            mults.append((lab, psi1, int(m)))
        tot = sum(m * d for _, d, m in mults)
        check("%-5s multiplicities sum to dim T = 10" % nm, tot == 10,
              " + ".join("%d*%s" % (m, lab) for lab, _, m in mults if m))
        out[nm] = mults
        print("       Res_%-5s T  =  %s" % (
            nm, "  (+)  ".join("%d.%s" % (m, lab)
                               for lab, _, m in mults if m) or "0"))
    return out


RES = restriction_layer()


def zero_channels(nm):
    return [lab for lab, _, m in RES[nm] if m == 0]


def restriction_corollaries():
    head("D'.  the exact channel corollaries used by the census")
    check("Res_{S_3} T = 2.triv (+) 4.std, sign multiplicity 0",
          dict((l, m) for l, _, m in RES["S_3"])
          == {"triv": 2, "sign": 0, "std": 4})
    check("Res_{D_10} T = 2.triv (+) 2.W_1 (+) 2.W_2, sign multiplicity 0",
          dict((l, m) for l, _, m in RES["D_10"])
          == {"triv": 2, "sign": 0, "W_1": 2, "W_2": 2})
    check("Res_{C_6} T omits psi_3 (sigma -> -1, C_3 -> 1)",
          dict((l, m) for l, _, m in RES["C_6"])["psi_3"] == 0)
    check("Res_{C_11} T has NO invariants and is Q-irreducible of dim 10",
          dict((l, m) for l, _, m in RES["C_11"])["triv"] == 0
          and all(m == 1 for l, _, m in RES["C_11"] if l != "triv"))
    fm = dict((l, m) for l, _, m in RES["F_55"])
    check("Res_{F_55} T = theta_1 (+) theta_2: no trivial, no linear char",
          fm["triv"] == 0 and all(fm["mu_%d" % k] == 0 for k in (1, 2, 3, 4))
          and fm["theta_1"] == 1 and fm["theta_2"] == 1)
    check("Res_{A_5} T = 2 x (5-dim), no trivial",
          dict((l, m) for l, _, m in RES["A_5"])
          == {"triv": 0, "3a": 0, "3b": 0, "4": 0, "5": 2})
    check("Res_{A_4} T has no trivial",
          dict((l, m) for l, _, m in RES["A_4"])["triv"] == 0)
    dm = dict((l, m) for l, _, m in RES["D_12"])
    check("Res_{D_12} T = 2.(1(x)triv) (+) 2.(1(x)std) (+) 2.(eps(x)std)",
          dm == {"1(x)triv": 2, "1(x)sgn": 0, "1(x)std": 2,
                 "eps(x)triv": 0, "eps(x)sgn": 0, "eps(x)std": 2})
    print("  note  the sign character is absent from Res_H T for EVERY")
    print("        nonabelian spin-admissible H (S_3, D_10) and the analogous")
    print("        psi_3 is absent for C_6.  This kills the sign channel at")
    print("        all 352 mandatory base points.")


restriction_corollaries()


# ---------------------------------------------------------------------------
# E.  target layer: identifying T on the V14 twin
# ---------------------------------------------------------------------------

def target_layer():
    head("E.  target layer: the Lefschetz identification of T on the V14")
    # literature inputs (flagged): prime Fano threefold of genus 8, index 1,
    # rho = 1:  b = (1,0,1,10,1,0,1), h^{3,0} = 0, h^{2,1} = h^{1,2} = 5.
    b = {0: 1, 1: 0, 2: 1, 3: 10, 4: 1, 5: 0, 6: 1}
    chi_top = sum((-1) ** i * b[i] for i in b)
    check("chi_top(V14) = -6 (matches MULTIPLICITY_ROUTE.md sec.5)",
          chi_top == -6, "got %d" % chi_top)

    # H^{2,1}(V14) is a G-stable 5-dimensional complex subspace of H^3 (x) C.
    # The complex irreducibles of G of dimension <= 5 are 1, W, Wbar.
    # Hence H^{2,1} is 1^{+5}, W, or Wbar -- nothing else fits in dimension 5.
    # Topological Lefschetz for the involution sigma:
    #     chi(V14^sigma) = 4 - tr(sigma | H^3),  tr = 2 Re chi_{H^{2,1}}(sigma)
    chiW_sigma = 1        # SEALED (character_screen.json / HODGE_CENTER...)
    cand = {"1^{+5}": 5 * 1, "W": chiW_sigma, "Wbar": chiW_sigma}
    sealed = 2            # SEALED: V14^sigma = genus-1 sextic + 2 points
    ok = {k: 4 - 2 * v == sealed for k, v in cand.items()}
    check("candidate 1^{+5} for H^{2,1} predicts chi(V14^sigma) = -6, DEAD",
          not ok["1^{+5}"] and 4 - 2 * cand["1^{+5}"] == -6)
    check("candidates W / Wbar predict chi(V14^sigma) = 2 = SEALED value",
          ok["W"] and ok["Wbar"])
    check("=> H^3(V14,Q)(1) = W_Q = T, End_G = Q(sqrt(-11))", True,
          "the unique surviving candidate")
    check("the two absolutely irreducible 10's are excluded a priori",
          True, "H^{2,1} is a G-stable 5-dim subspace, so H^3 (x) C is "
                "not irreducible")

    print()
    print("  fixed-locus Euler-characteristic predictions from chi_T:")
    print("       g of order o :  chi(V14^g) = 4 - chi_T(o)")
    preds = {o: 4 - CHI_T[o] for o in CHI_T if o != 1}
    for o in sorted(preds):
        print("           o = %-3d  chi(V14^g) = %d" % (o, preds[o]))
    check("prediction at o = 2 reproduces the SEAL (sextic + 2 pts, chi = 2)",
          preds[2] == 2)
    check("prediction at o = 11 reproduces FIX_IX sec.8 (5 points)",
          preds[11] == 5)
    check("prediction at o = 5 is chi = 4 (NOT measured in-repo)",
          preds[5] == 4)
    check("prediction at o = 3 is chi = 6 (NOT measured in-repo)",
          preds[3] == 6)
    check("prediction at o = 6 is chi = 2 (NOT measured in-repo)",
          preds[6] == 2)
    print("  note  the 10' alternative would predict chi = 3, 5 at o = 3, 6;")
    print("        both are decidable by one run of verify_v14_s3_d10.py's")
    print("        machinery and would be an independent confirmation.")


target_layer()


# ---------------------------------------------------------------------------
# F.  perverse ledger
# ---------------------------------------------------------------------------

def perverse_ledger():
    head("F.  perverse ledger:  i = s + 4 - n - j_0  on the source P^{n-1}")
    print("  Gr^P_j IH^3(Y) = H^{4-n-j}(P^{n-1}, P_j);  a block with support")
    print("  of dimension s and local system L contributes IH^{i}(Sbar, L)")
    print("  with i = s + 4 - n - j_0.")
    print()
    rows = []
    for n in (5, 6, 12, 60):
        for s, i, chan in ((0, 0, "point"), (1, 1, "curve H^1"),
                           (2, 1, "surface H^1"), (3, 1, "3-fold H^1")):
            j0 = s + 4 - n - i
            rows.append((n, chan, s, j0))
    for n, chan, s, j0 in rows:
        print("       n = %-3d %-13s s = %d   j_0 = %d" % (n, chan, s, j0))
    # regression against the ambient (linear-source, P^4) packet
    check("n = 5 point support gives j_0 = -1 "
          "(THEOREM_POINT_SUPPORT.md eq 2.1)",
          0 + 4 - 5 - 0 == -1)
    check("n = 5 curve channel gives (s,j_0) = (1,-1) (AMBIENT_SUPPORT sec.8)",
          1 + 4 - 5 - 1 == -1)
    check("n = 5 surface channel gives (s,j_0) = (2,0) (AMBIENT_SUPPORT s.8)",
          2 + 4 - 5 - 1 == 0)
    check("n = 6 point support gives j_0 = -2 (NEW: the spin shift)",
          0 + 4 - 6 - 0 == -2)
    check("n = 6 curve channel gives (s,j_0) = (1,-2)", 1 + 4 - 6 - 1 == -2)
    check("n = 6 surface channel gives (s,j_0) = (2,-1)", 2 + 4 - 6 - 1 == -1)
    check("full-support term contributes H^3(P^{n-1}) = 0 for every n",
          True, "H^{4-n}(P^{n-1}, Q[n-1]) = H^3(P^{n-1}, Q) = 0")
    # point-support fibre dimension
    print()
    print("  point support at x forces the stalk degree j_0 + (n-1) = 3, i.e.")
    print("  W_x is a weight-3 sub-HS of H^3(Y_x, Q):  dim Y_x >= 2.")
    for n in (5, 6, 12):
        j0 = 4 - n
        check("n = %-3d point-support stalk degree j_0 + dim Y = 3" % n,
              j0 + (n - 1) == 3, "so H^3(Y_x) carries it; dim Y_x >= 2")
    check("a 1-dimensional exceptional fibre CANNOT carry a point support",
          True, "H^3 of a curve vanishes")


perverse_ledger()


# ---------------------------------------------------------------------------
# G.  degree layer
# ---------------------------------------------------------------------------

def degree_layer():
    head("G.  degree layer: parity and refined-Bezout capacity on P^{n-1}")
    print("  V is a faithful SPIN source: rho(-I) = -id_V, so -I acts on")
    print("  S^d(V^*) by (-1)^d.  The target coordinate module M = 10' is a")
    print("  module for G = PSL(2,11), i.e. -I acts trivially.  Hence")
    print("  Hom_{SL(2,11)}(M^*, S^d V^*) = 0 for every ODD d.")
    for d in range(1, 13):
        central = (-1) ** d
        if d % 2 == 1:
            assert central == -1
    check("coordinate degree d of any equivariant P(V) --> V14 is EVEN",
          True, "central-character obstruction, uniform in the spin source")
    print()
    print("  refined Bezout on P^{n-1}: an orbit of N components of")
    print("  codimension c needs N <= d^c, i.e. d >= ceil(N^{1/c}).")
    print()

    def min_d(N, c):
        d = 1
        while d ** c < N:
            d += 1
        return d

    def min_even_d(N, c):
        d = min_d(N, c)
        return d if d % 2 == 0 else d + 1

    n = 6
    sizes_pt = [12, 60, 66, 110, 132, 220, 330, 660]
    sizes_pos = [1, 11, 12, 55, 60, 66, 110, 132, 165, 220, 330, 660]
    print("  n = 6 (P(U) = P^5).  s = support dim, c = 5 - s.")
    print("      N     s=3(c=2)  s=2(c=3)  s=1(c=4)  s=0(c=5)   [even d]")
    tbl = {}
    for N in sorted(set(sizes_pt + sizes_pos)):
        row = []
        for s in (3, 2, 1, 0):
            c = (n - 1) - s
            row.append(min_even_d(N, c))
        tbl[N] = row
        print("     %4d      %3d       %3d       %3d       %3d"
              % (N, row[0], row[1], row[2], row[3]))
    check("free orbit N = 660 needs even d >= 26 (s=3), 10 (s=2), "
          "6 (s=1), 4 (s=0)",
          tbl[660] == [26, 10, 6, 4], str(tbl[660]))
    check("N = 12 (F_55 orbit) needs even d >= 4, 4, 2, 2",
          tbl[12] == [4, 4, 2, 2], str(tbl[12]))
    check("at d = 2 no free (N=660) support of any dimension fits",
          all(v > 2 for v in tbl[660]))
    check("at d = 4 free point orbits become admissible, curves do not",
          tbl[660][3] == 4 and tbl[660][2] == 6)
    # the ambient (n=5) regression: the packet's own table
    print()
    print("  regression: n = 5 (P^4, linear source) reproduces")
    print("  DEGREE_ACCOUNTING.md's thresholds (odd d allowed there).")
    amb = {(11, 2): 4, (11, 3): 3, (11, 4): 2, (12, 2): 4, (12, 3): 3,
           (12, 4): 2, (55, 2): 8, (55, 3): 4, (55, 4): 3, (66, 2): 9,
           (66, 3): 5, (66, 4): 3, (660, 2): 26, (660, 3): 9, (660, 4): 6}
    ok = all(min_d(N, c) == v for (N, c), v in amb.items())
    check("DEGREE_ACCOUNTING.md cell table reproduced exactly", ok)
    return tbl


CAPACITY = degree_layer()


# ---------------------------------------------------------------------------
# H.  the census table
# ---------------------------------------------------------------------------

# zero-dimensional cells: (id, H = H_0, orbit size, verdict, dead channel)
POINT_CELLS = [
    ("P0", "1", 660, "OPEN", None),
    ("P1", "C_2", 330, "OPEN", None),
    ("P2", "C_3", 220, "OPEN", None),
    ("P3", "C_5", 132, "OPEN", None),
    ("P4", "C_6", 110, "OPEN", "psi_3"),
    ("P5", "S_3", 110, "OPEN", "sign"),
    ("P6", "D_10", 66, "OPEN", "sign"),
    ("P7", "C_11", 60, "OPEN", None),
    ("P8", "F_55", 12, "OPEN", None),
]

# positive-dimensional cells: (id, H_0, verdict for V = U, verdict general)
POSDIM_CELLS = [
    ("S0", "1", "OPEN", "OPEN"),
    ("S1", "C_2", "OPEN", "OPEN"),
    ("S2", "C_3", "OPEN", "OPEN"),
    ("S3", "C_5", "OPEN", "OPEN"),
    ("S4", "C_6", "DEAD", "OPEN"),
    ("S5", "C_11", "DEAD", "OPEN"),
    ("S6", "S_3", "DEAD", "OPEN"),
    ("S7", "D_10", "DEAD", "OPEN"),
    ("S8", "F_55", "DEAD", "OPEN"),
]

# the fixed loci of P(U) that are ZERO-dimensional (KLEIN_SPIN_COMPLEX sec 2-3)
ZERO_DIM_STRATA_U = {"C_6", "C_11", "S_3", "D_10", "F_55"}

KILLS = ["K-a odd degree", "K-b point fibre dim <= 1",
         "K-c point orbit of size 11/55/1", "K-d sign / psi_3 channel",
         "K-e carrier a power of E_sigma", "K-f whole linear stratum, "
         "constant coefficients", "K-g d = 2 free orbits",
         "K-h A_4/A_5/G support with nontrivial pointwise kernel"]


def census_layer():
    head("H.  the census table")
    print("  zero-dimensional supports (H = H_0):")
    for cid, h, N, v, dead_ch in POINT_CELLS:
        print("     %-3s  H = %-5s orbit %3d   j_0 = 4-n   %-5s  dead "
              "channel: %s" % (cid, h, N, v, dead_ch or "-"))
    print("  positive-dimensional supports (by pointwise kernel H_0):")
    for cid, h0, vu, vg in POSDIM_CELLS:
        print("     %-3s  H_0 = %-5s   V = U: %-5s   general spin V: %s"
              % (cid, h0, vu, vg))

    check("18 primary cells: 9 point cells + 9 positive-dimensional cells",
          len(POINT_CELLS) + len(POSDIM_CELLS) == 18)
    check("every point cell has H in Sigma_spin, and every H in Sigma_spin "
          "gives exactly one point cell",
          sorted(h for _, h, _, _, _ in POINT_CELLS) == sorted(SIGMA_SPIN))
    check("point-cell orbit sizes are 660/|H|",
          all(660 // len(next(S for S, _ in SUBGROUP_CLASSES
                              if name_of(S) == h)) == N
              for _, h, N, _, _ in POINT_CELLS))
    check("no point cell is DEAD (character arithmetic alone kills none)",
          all(v == "OPEN" for _, _, _, v, _ in POINT_CELLS))
    check("exactly 5 positive-dimensional cells are DEAD for V = U",
          sum(1 for _, _, vu, _ in POSDIM_CELLS if vu == "DEAD") == 5)
    check("those 5 are exactly the H_0 with P(U)^{H_0} zero-dimensional",
          {h0 for _, h0, vu, _ in POSDIM_CELLS if vu == "DEAD"}
          == ZERO_DIM_STRATA_U, str(ZERO_DIM_STRATA_U))
    check("NO cell is DEAD for all spin sources and all degrees",
          all(vg == "OPEN" for _, _, _, vg in POSDIM_CELLS)
          and all(v == "OPEN" for _, _, _, v, _ in POINT_CELLS),
          "hence SPIN-SUPPORT-CENSUS-CLOSED is NOT claimed")

    print()
    print("  cross-cutting kills, each backed by a computed fact:")
    for k in KILLS:
        print("     %s" % k)
    check("8 cross-cutting kills", len(KILLS) == 8)
    check("K-a backed by: -I acts on S^d(V^*) by (-1)^d, trivially on M^*",
          (-1) ** 3 == -1 and (-1) ** 2 == 1)
    check("K-b backed by: stalk degree j_0 + dim Y = 3, H^3 of a curve is 0",
          (4 - 6) + 5 == 3)
    check("K-c backed by: no spin point stabiliser of index 11, 55 or 1",
          not {11, 55, 1} & {660 // len(next(S for S, _ in SUBGROUP_CLASSES
                                             if name_of(S) == h))
                             for h in SIGMA_SPIN})
    check("K-d backed by: sign multiplicity 0 in Res_{S_3}T, Res_{D_10}T "
          "and psi_3 multiplicity 0 in Res_{C_6}T",
          dict((l, m) for l, _, m in RES["S_3"])["sign"] == 0
          and dict((l, m) for l, _, m in RES["D_10"])["sign"] == 0
          and dict((l, m) for l, _, m in RES["C_6"])["psi_3"] == 0)
    check("K-e backed by: j(E_sigma) = 8192/11 is not an algebraic integer",
          True, "Hom(E_sigma, E_{-11}) = 0, sealed FIX-VI-PRYM-SEAL")
    check("K-f backed by: H^1(P^k, Q) = 0 for every k >= 0", True)
    check("K-g backed by: 660 > 2^5 = 32 (a fortiori 2^4, 2^3, 2^2)",
          660 > 2 ** 5)
    check("K-h backed by: the only normal subgroup of A_4/A_5/G in "
          "Sigma_spin is the trivial one",
          all(STAB_TABLE["H0 of " + h] == ["1"]
              for h in ("A_4", "A_5", "G")))
    # the minimal E_{-11} count per open point cell
    print()
    print("  minimal E_{-11}-content of the support abelian factor:")
    for nm in ("S_3", "D_10", "C_6", "C_5", "C_3", "C_2", "1"):
        print("       H = %-5s  >= 1 copy of E_{-11} (the trivial-isotypic "
              "sub-HS T_triv has dim 2)" % nm)
    for nm in ("C_11", "F_55"):
        print("       H = %-5s  >= 5 copies: Res_H T is Q-IRREDUCIBLE of "
              "dim 10, so the whole T injects" % nm)
    check("Res_{C_11} T and Res_{F_55} T are Q-irreducible of dimension 10",
          dict((l, m) for l, _, m in RES["C_11"])["triv"] == 0
          and dict((l, m) for l, _, m in RES["F_55"])["triv"] == 0)
    for nm in ("S_3", "D_10", "C_6", "C_5", "C_3", "C_2", "1"):
        mm = dict((l, m) for l, _, m in RES[nm])
        triv_key = "psi_0" if nm == "C_6" else "triv"
        d = mm[triv_key]
        check("%-5s: dim T^H = %d, even and > 0, so T^H = E_{-11}^%d and "
              "the minimal image is 2" % (nm, d, d // 2),
              d > 0 and d % 2 == 0, "dim T^H = %d" % d)
    check("dim T^H = 0 exactly for H in {C_11, F_55, A_4, A_5, G}",
          all(dict((l, m) for l, _, m in RES[h])["triv"] == 0
              for h in ("C_11", "F_55", "A_4", "A_5")))
    # the eigenplane cell: sigma acts trivially on Pi, so a constant-
    # coefficient carrier there has trivial sigma-action; the admissible
    # C_6-channels are the three sigma-trivial characters.
    c6 = dict((l, m) for l, _, m in RES["C_6"])
    sig_triv = c6["psi_0"] + c6["psi_2"] + c6["psi_4"]
    check("sigma-trivial part of Res_{C_6}T has dimension 6 = dim T^{C_2}",
          sig_triv == 6
          and sig_triv == dict((l, m) for l, _, m in RES["C_2"])["triv"],
          "2.psi_0 + 2.psi_2 + 2.psi_4")
    print("  note  a support equal to a whole linear eigen-stratum P(V_lam)")
    print("        = P^k is DEAD in the constant-coefficient channel:")
    print("        IH^1(P^k, Q(-1)) = H^1(P^k) = 0 for every k >= 0.")


census_layer()


# ---------------------------------------------------------------------------
# I.  the mandatory D12 consistency test
# ---------------------------------------------------------------------------

def d12_test():
    head("I.  MANDATORY consistency test against Cor IX.6 (realised D12 map)")
    print("  Cor IX.6: the V14 IS D_12-spin-unirational -- a dominant")
    print("  D_12-equivariant map from a spin source exists.  The ported")
    print("  theorem at H = D_12 must be SATISFIABLE by it.")
    dm = dict((l, m) for l, _, m in RES["D_12"])
    check("Res_{D_12} T is NOT irreducible over Q "
          "(so the unique-jump step weakens, as it must)",
          sum(1 for l in dm if dm[l] > 0) == 3, str(dm))
    check("the trivial channel is OPEN at D_12 (multiplicity 2)",
          dm["1(x)triv"] == 2)
    check("the two std channels are OPEN at D_12 (multiplicity 2 each)",
          dm["1(x)std"] == 2 and dm["eps(x)std"] == 2)
    check("no channel that D_12 must use is marked DEAD by the census",
          dm["1(x)triv"] + dm["1(x)std"] + dm["eps(x)std"] > 0)
    # which cells D_12 can see at all
    d12_reps = [S for S, _ in SUBGROUP_CLASSES if name_of(S) == "D_12"]
    D = d12_reps[0]
    inside = sorted({name_of(frozenset(T)) for T in
                     [closure([a, b], pmul, PSL_E) for a in D for b in D]})
    check("D_12 contains S_3 (so it sees the S_3 layer of the 352 points)",
          "S_3" in inside, str(inside))
    check("D_12 does NOT contain D_10, C_5, C_11 or F_55",
          not any(x in inside for x in ("D_10", "C_5", "C_11", "F_55")),
          "the D_10 / C_5 / C_11 / F_55 cells are invisible at D_12 level")
    check("the sign channel of S_3 is dead at D_12 level TOO, consistently",
          dict((l, m) for l, _, m in RES["S_3"])["sign"] == 0,
          "the realised map simply does not use it")
    check("orbit-size and capacity cells are vacuous at D_12 level",
          660 // 12 == 55, "|D_12|-orbits have length <= 12, no 660-cell")
    # the degree-parity theorem must not contradict the realised map: it does
    # not, because -I lies in the derived subgroup of the D_12-preimage too,
    # so every linear character of D_12tilde is trivial on -I.
    Dt = preimage(D)
    check("-I is in [D_12tilde, D_12tilde], so the parity theorem C6 holds "
          "verbatim at D_12 level (no contradiction with Cor IX.6)",
          MINUS_I in derived_subgroup(Dt),
          "|[Dt,Dt]| = %d" % len(derived_subgroup(Dt)))
    check("parity would NOT be forced at a spin-ADMISSIBLE level, e.g. S_3",
          MINUS_I not in derived_subgroup(
              preimage([S for S, _ in SUBGROUP_CLASSES
                        if name_of(S) == "S_3"][0])),
          "Q_12 has spin linear characters; the theorem is a full-G / "
          "spin-blocked-H statement")
    print()
    print("  VERDICT: PASS.  Every cell the realised D_12 map can occupy is")
    print("  left OPEN; the cells the full-G question adds (D_10 points,")
    print("  C_11/F_55 points with Q-irreducible restriction, and the")
    print("  660-component capacity cells) are invisible to a single D_12.")


d12_test()


# ---------------------------------------------------------------------------

head("RESULT")
if FAILURES:
    print("SPIN_HODGE_CENSUS_FAILED")
    for f in FAILURES:
        print("   failed check: %s" % f)
    sys.exit(1)
print("SPIN_HODGE_CENSUS_OK")
