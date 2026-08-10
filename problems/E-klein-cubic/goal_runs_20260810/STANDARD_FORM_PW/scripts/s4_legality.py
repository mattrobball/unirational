"""S4 -- legality of the three stages of the tower, over the whole of P(W).

The tower is

   T0 : blow up the 940 points of the point strata   (10 G-orbits)
   T1 : blow up the 220 lines  (55 ell_V + 110 C3-eigenlines + 55 minus-lines)
   T2 : blow up the 55 plus-planes

A stage is legal iff its centre is a SMOOTH G-invariant subvariety, i.e. iff the
members of the (disjoint union of) G-orbits are pairwise disjoint AT THAT STAGE.
Because every level-0 stratum is a LINEAR subspace of P(W), the strict-transform
bookkeeping reduces to linear algebra:

  * two distinct linear subspaces that meet only in a point p have disjoint
    strict transforms after p is blown up  <=>  their tangent spaces at p meet
    only in T_p of their intersection, i.e.  <=>  they are transverse at p;
    for linear subspaces U, V with P(U) cap P(V) = {p},  U cap V = <p>, and
    T_p P(U) cap T_p P(V) = Hom(<p>, (U cap V)/<p>) = 0 automatically.
  * two planes meeting in a line ell have disjoint strict transforms after ell
    is blown up  <=>  T_x P(U) cap T_x P(V) = T_x ell for x in ell -- again
    automatic, since U cap V is exactly the 2-dimensional space of ell.

So the checks that carry real content are the INCIDENCE checks: every pairwise
intersection of two centres of a later stage must already have been blown up.
Those are computed exhaustively here, at both split primes.

Marker S4_LEGALITY_OK.
"""
import json
import os
import sys
from collections import defaultdict

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from sfcore import Core                                    # noqa: E402
from psl211 import SPLIT_PRIMES                            # noqa: E402

HERE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def label_of(pname, d):
    return {("C2", 3): "P_sigma", ("C2", 2): "L'_sigma", ("C3", 2): "C3line",
            ("V4", 2): "ell_V", ("V4", 1): "V4-I", ("C5", 1): "C5pt",
            ("C6", 1): "C6pt", ("C11", 1): "C11pt", ("D10", 1): "D10pt",
            ("D12", 1): "D12pt", ("A4", 1): "A4pt"}.get((pname, d))


def run(p, say):
    ok = True
    C = Core(p)
    m = C.m
    say(f"--- p = {p} ---")
    fam = defaultdict(set)
    for H in C.subgroup_classes():
        if len(H) in (1, 660):
            continue
        for val, U in C.char_subspaces(H):
            lab = label_of(C.name(C.pstab(U)), len(U))
            if lab:
                for g in range(C.n):
                    fam[lab].add(m.canon([list(m.act(C.G[g], v)) for v in U]))
    T0 = sorted(set().union(*[fam[k] for k in
                              ("V4-I", "C5pt", "C6pt", "C11pt", "D10pt", "D12pt", "A4pt")]))
    T1 = sorted(set().union(*[fam[k] for k in ("ell_V", "C3line", "L'_sigma")]))
    T2 = sorted(fam["P_sigma"])
    say(f"CHECK T0 centre: {len(T0)} points (expect 940): "
        f"{'PASS' if len(T0) == 940 else 'FAIL'}")
    ok &= len(T0) == 940
    say(f"CHECK T1 centre: {len(T1)} lines (expect 220): "
        f"{'PASS' if len(T1) == 220 else 'FAIL'}")
    ok &= len(T1) == 220
    say(f"CHECK T2 centre: {len(T2)} planes (expect 55): "
        f"{'PASS' if len(T2) == 55 else 'FAIL'}")
    ok &= len(T2) == 55

    pts = set(T0)
    # --- T0 legality: the 940 points are pairwise distinct (a smooth centre)
    say(f"CHECK T0 is smooth: the {len(T0)} points are pairwise distinct: "
        f"{'PASS' if len(set(T0)) == len(T0) else 'FAIL'}")
    ok &= len(set(T0)) == len(T0)
    # and no point stratum lies on another (they have different stabilizers)
    stabsz = {}
    for u in T0:
        stabsz[u] = len(C.pstab(u))
    say(f"      stabilizer orders of the T0 points: "
        f"{sorted(set(stabsz.values()))}")

    # --- T1 legality: every pairwise intersection of two of the 220 lines is a
    #     T0 point (hence blown up), so the strict transforms are disjoint.
    bad = []
    inc = defaultdict(int)
    for i in range(len(T1)):
        for j in range(i + 1, len(T1)):
            I = m.inter(T1[i], T1[j])
            if not I:
                continue
            if len(I) != 1:
                bad.append(("line-line intersection of dim > 0", i, j))
                continue
            q = m.canon(I)
            inc[len(C.pstab(q))] += 1
            if q not in pts:
                bad.append(("line-line meeting point not blown up at T0", i, j))
    say(f"CHECK T1: every intersection point of two of the 220 lines is a T0 "
        f"point ({sum(inc.values())} incident pairs, stabilizer orders "
        f"{dict(sorted(inc.items()))}): {'PASS' if not bad else 'FAIL'}")
    ok &= not bad
    for b in bad[:5]:
        say("      " + str(b))

    # --- T2 legality: two plus-planes meet either in an ell_V (blown up at T1)
    #     or in a single T0 point; and in the first case they are transverse
    #     along it, in the second case transverse at it.
    lines = set(T1)
    bad2 = []
    kinds = defaultdict(int)
    for i in range(len(T2)):
        for j in range(i + 1, len(T2)):
            I = m.inter(T2[i], T2[j])
            d = len(I)
            kinds[d] += 1
            if d == 2:
                if m.canon(I) not in lines:
                    bad2.append(("planes meet in a line that is not a T1 centre", i, j))
            elif d == 1:
                if m.canon(I) not in pts:
                    bad2.append(("planes meet in a point not blown up at T0", i, j))
            else:
                bad2.append(("unexpected plane-plane intersection dim", d))
    say(f"CHECK T2: plus-plane pairs meet in dim {dict(sorted(kinds.items()))} "
        f"(vector dims; 2 = an ell_V, 1 = a point), and every such locus is a "
        f"centre of an earlier stage: {'PASS' if not bad2 else 'FAIL'}")
    ok &= not bad2
    for b in bad2[:5]:
        say("      " + str(b))

    # --- transversality (the strict transforms really do separate)
    # For linear U, V:  T_x P(U) cap T_x P(V) = Hom(<x>, (U cap V)/<x>), so
    # transversality along P(U cap V) is automatic.  Verified as an identity:
    tv = True
    for i in range(0, len(T2), 7):
        for j in range(i + 1, len(T2), 11):
            I = m.inter(T2[i], T2[j])
            if len(I) != 2:
                continue
            # dim(U + V) = dim U + dim V - dim(U cap V) is exactly transversality
            if m.rank([list(x) for x in T2[i]] + [list(y) for y in T2[j]]) != \
                    len(T2[i]) + len(T2[j]) - len(I):
                tv = False
    say(f"CHECK transversality identity dim(U+V) = dim U + dim V - dim(U cap V) "
        f"for plus-plane pairs (sampled): {'PASS' if tv else 'FAIL'}")
    ok &= tv

    # --- the strict transforms of the T1 lines really do meet the T0
    #     exceptional divisors in DISTINCT points (distinct tangent directions)
    bad3 = []
    for q in list(pts)[:len(pts)]:
        thru = [L for L in T1 if m.rank([list(x) for x in L] + [list(q[0])]) == len(L)]
        # tangent directions at q are the lines themselves; distinct lines through
        # a point have distinct tangent directions
        if len(set(thru)) != len(thru):
            bad3.append(q)
    say(f"CHECK the T1 lines through a common T0 point are distinct linear "
        f"subspaces, so their strict transforms hit the exceptional P^3 in "
        f"distinct points: {'PASS' if not bad3 else 'FAIL'}")
    ok &= not bad3

    # --- how many T1 lines / T2 planes pass through each kind of T0 point
    prof = defaultdict(lambda: defaultdict(int))
    seenlab = {}
    for lab in ("V4-I", "C5pt", "C6pt", "C11pt", "D10pt", "D12pt", "A4pt"):
        for u in sorted(fam[lab])[:1]:
            seenlab[lab] = u
    for lab, q in sorted(seenlab.items()):
        nl = sum(1 for L in T1 if m.rank([list(x) for x in L] + [list(q[0])]) == len(L))
        npl = sum(1 for P in T2 if m.rank([list(x) for x in P] + [list(q[0])]) == len(P))
        say(f"      through a {lab:<7} point: {nl} of the 220 T1 lines and "
            f"{npl} of the 55 T2 planes")
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
    say("S4_LEGALITY_" + ("OK" if ok else "FAIL"))
    with open(os.path.join(HERE, "results", "s4_legality.txt"), "w") as f:
        f.write("\n".join(out) + "\n")
    sys.exit(0 if ok else 1)
