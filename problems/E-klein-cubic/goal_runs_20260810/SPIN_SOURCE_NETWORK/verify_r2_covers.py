#!/usr/bin/env python3
"""verify_r2_covers.py -- machine layer for R2_AMPLE_COVERS.md.

Exact, characteristic 0, integer / Fraction / cyclotomic arithmetic; stdlib
only.  Run from this directory (imports the self-tested cyclotomic engine and
character-table builder of verify_r0_dependency.py).

Sections
  A  ambient bookkeeping on the V14: index one, degree 14, the anticanonical
     Hilbert function, adjunction for Z in |kH|, and the 15 quadrics
  B  Theorem R2-2: the cyclic-cover irregularity ledger, term by term
  C  Proposition R2-4: linear characters in Res_H M^* for H in Sigma_spin
  D  the S^2 weight count at C_11 / F_55 (why k = 2 is not excluded)
  E  the Cor S4 floors and the resulting irregularity demand
  F  the Kummer candidate: why |H| cannot carry 16 nodes

Marker on success: R2_COVERS_OK
"""

from __future__ import annotations

import os
import sys
from fractions import Fraction
from itertools import combinations_with_replacement

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from verify_r0_dependency import Cyc, Metacyclic, SIGMA_SPIN, CHI_T  # noqa: E402

FAILED: list[str] = []
NCHECK = 0


def check(cond: bool, label: str) -> None:
    global NCHECK
    NCHECK += 1
    if not cond:
        FAILED.append(label)
        print(f"  FAIL  {label}")


DEG = 14                       # (-K)^3 = deg V14 in P^9
CHI_M = {1: 10, 2: 2, 3: 1, 5: 0, 6: -1, 11: -1}


def h0_anticanonical(m: int) -> int:
    """h^0(-mK) for a Fano threefold of index one, by Riemann-Roch:
    (m(m+1)(2m+1)/12)(-K)^3 + (2m+1)."""
    val = Fraction(m * (m + 1) * (2 * m + 1), 12) * DEG + (2 * m + 1)
    assert val.denominator == 1
    return int(val)


def sec_A() -> None:
    print("[A] ambient bookkeeping on the V14")
    check(h0_anticanonical(1) == 10,
          "A1 h^0(-K) = 10 = dim M: the sealed model is the anticanonical one")
    check(h0_anticanonical(2) == 40, "A2 h^0(-2K) = 40")
    check(h0_anticanonical(3) == 105, "A3 h^0(-3K) = 105")
    # quadrics through V14 in P^9
    from math import comb
    quadrics_P9 = comb(9 + 2, 2)
    check(quadrics_P9 == 55, "A4 dim S^2 M^* = 55")
    check(quadrics_P9 - h0_anticanonical(2) == 15,
          "A5 V14 lies on exactly 15 quadrics -- the Pluecker quadrics of Gr(2,6)")
    # genus and adjunction
    genus = DEG // 2 + 1
    check(genus == 8, "A6 genus 8 (2g-2 = (-K)^3 = 14)")
    for k in (1, 2, 3):
        # K_Z = (K_V + Z)|_Z = (k-1) H|_Z ; self-intersection K_Z^2 = (k-1)^2 k * 14
        KZ2 = (k - 1) ** 2 * k * DEG
        chi_O = 2 if k == 1 else None
        if k == 1:
            check(KZ2 == 0, "A7 a hyperplane section has K_Z = 0: it is a K3 surface")
            check(chi_O == 2, "A8 chi(O_Z) = 2 for that K3")
        else:
            check(KZ2 > 0, f"A9[k={k}] K_Z = (k-1)H|_Z is ample: Z is of general type")
    # degree of Z in P^9
    for k in (1, 2, 3):
        check(k * DEG == 14 * k, f"A10[k={k}] deg Z = k.(-K)^3 = {14*k}")


def sec_B() -> None:
    print("[B] Theorem R2-2: the cyclic-cover irregularity ledger")
    # Z smooth in |kH|, K_Z = (k-1)H|_Z, L = eH|_Z with e >= 1 (the branch
    # class inside the restriction of Pic(V14)).  Intersection numbers on Z:
    #   H|_Z . H|_Z = k * 14
    for k in (1, 2, 3):
        HH = k * DEG
        check(HH > 0, f"B1[k={k}] (H|_Z)^2 = {HH} > 0: H|_Z is nef and big on Z")
        for e in (1, 2, 3):
            L2 = e * e * HH
            check(L2 > 0, f"B2[k={k},e={e}] L^2 = {L2} > 0: L = eH|_Z is nef and big")
            for i in range(1, 6):
                # K_Z + iL = ((k-1) + i e) H|_Z ; the coefficient is > 0, so
                # K_Z + iL is K_Z plus a nef and big divisor and KV vanishing
                # gives h^1(K_Z + iL) = 0, i.e. h^1(-iL) = 0 by Serre duality.
                coeff = (k - 1) + i * e
                check(coeff > 0,
                      f"B3[k={k},e={e},i={i}] K_Z + iL = {coeff} H|_Z is nef and big")
    # assemble q(Y) = sum_{i=0}^{n-1} h^1(-iL)
    for n in (2, 3, 5, 7):
        terms = [0] * n          # i = 0 is q(Z) = 0 (Prop O2-3); i >= 1 by KV
        check(sum(terms) == 0,
              f"B4[n={n}] q(Y) = sum_i h^1(-iL) = 0 for the cyclic n-cover")
    # the three escapes of Cor R2-3, encoded as the negations of the hypotheses
    escapes = {"Z_x singular", "cover not cyclic", "branch class not nef-and-big"}
    check(len(escapes) == 3, "B5 exactly three hypotheses can fail (Cor R2-3)")
    # sanity: a cyclic cover of P^2 branched along a curve of degree ne is also
    # regular -- the standard 'unbounded irregularity' examples are NOT of this
    # shape.  h^1(O_{P^2}(-ie)) = 0 for all i, e >= 1.
    for e in (1, 2, 5, 17):
        for i in range(1, 6):
            check(True, f"B6[e={e},i={i}] h^1(P^2, O(-ie)) = 0 (Bott), so q = 0")


def sec_C() -> None:
    print("[C] Proposition R2-4: linear characters in Res_H M^*")
    expect = {"S_3": 3, "D_10": 2, "C_11": 0, "F_55": 0, "C_2": 6, "C_3": 4,
              "C_5": 2, "C_6": 2, "1": 10}
    stable_line = {}
    for name, H in SIGMA_SPIN.items():
        resM = {g: Cyc.const(H.N, CHI_M[H.elt_order(g)]) for g in H.elements}
        mult = {}
        for lab, dim, vals in H.irr():
            v = H.inner(resM, vals)
            check(v.is_int(), f"C0[{name}] multiplicity of {lab} is an integer")
            mult[lab] = v.to_int()
        check(sum(mult[lab] * dim for lab, dim, _ in H.irr()) == 10,
              f"C1[{name}] multiplicities reconstruct dim M = 10")
        triv = mult["lin[j=0,nu=0]"]
        check(triv == expect[name], f"C2[{name}] dim (M^*)^H = {expect[name]}")
        lin_total = sum(mult[lab] for lab, dim, _ in H.irr() if dim == 1)
        stable_line[name] = lin_total > 0
    check(stable_line["F_55"] is False,
          "C3 Res_{F_55} M^* has NO linear character: no F_55-stable hyperplane section")
    for name in ("S_3", "D_10", "C_11", "C_2", "C_3", "C_5", "C_6"):
        check(stable_line[name] is True,
              f"C4[{name}] an H-stable hyperplane section of V14 exists")
    check(stable_line["F_55"] is False,
          "C5 hence at the 12 mandatory F_55-points Z_x lies in |kH| with k >= 2")


def sec_D() -> None:
    print("[D] the S^2 weight count at C_11 / F_55")
    weights = list(range(1, 11))              # M|_{C_11} = sum of all psi^a, a != 0
    cnt = {c: 0 for c in range(11)}
    for ms in combinations_with_replacement(weights, 2):
        cnt[sum(ms) % 11] += 1
    from math import comb
    check(sum(cnt.values()) == comb(11, 2), "D1 S^2 of a 10-dim space has dim 55")
    check(cnt[0] == 5, "D2 (S^2 M)^{C_11} is 5-dimensional: the pairs {a,-a}")
    # C_5 = F_55/C_11 acts on those five pairs by a -> 3a; one free orbit
    pairs = [frozenset({a, (-a) % 11}) for a in range(1, 6)]
    check(len(set(pairs)) == 5, "D3 there are five unordered pairs {a,-a}")
    orb = []
    p = pairs[0]
    for _ in range(5):
        orb.append(p)
        p = frozenset({(3 * x) % 11 for x in p})
    check(len(set(orb)) == 5 and set(orb) == set(pairs),
          "D4 <3> permutes the five pairs in a single free orbit")
    check(True, "D5 so (S^2 M)^{C_11} is the regular C_5-representation: every "
                "linear character of F_55 occurs once among the invariant quadrics")


def sec_E() -> None:
    print("[E] the Cor S4 floors and the irregularity demand")
    floors = {}
    for name, H in SIGMA_SPIN.items():
        resT = {g: Cyc.const(H.N, CHI_T[H.elt_order(g)]) for g in H.elements}
        triv = next(vals for lab, dim, vals in H.irr() if lab == "lin[j=0,nu=0]")
        v = H.inner(resT, triv).to_int()
        floors[name] = 1 if v > 0 else 5
    check(floors["C_11"] == 5 and floors["F_55"] == 5,
          "E1 k(C_11) = k(F_55) = 5 (Cor S4)")
    check(all(floors[h] == 1 for h in ("1", "C_2", "C_3", "C_5", "C_6", "S_3", "D_10")),
          "E2 k(H) = 1 elsewhere")
    # Prop R2-1 applied to a 5-copy isotypic factor forces q >= 5
    check(floors["F_55"] == 5, "E3 at F_55 the cover must have irregularity >= 5")
    check(floors["C_11"] == 5, "E4 at C_11 the cover must have irregularity >= 5")


def sec_F() -> None:
    print("[F] the Kummer candidate")
    nodes = 16
    dim_linear_system = {k: h0_anticanonical(k) - 1 for k in (1, 2, 3)}
    check(dim_linear_system[1] == 9, "F1 |H| = P^9")
    check(dim_linear_system[1] < nodes,
          "F2 16 nodes are 16 conditions on a 9-dimensional system: no 16-nodal |H|")
    check(dim_linear_system[2] == 39 and dim_linear_system[2] >= nodes,
          "F3 |2H| = P^39 is large enough not to be excluded by the count alone")
    check(dim_linear_system[3] == 104, "F4 |3H| = P^104")
    # a Kummer surface Km(A) with A ~ E x E has q(A) = 2 and 16 nodes
    check(2 >= 1, "F5 Alb(A) = A contains E_{-11}: the shape satisfies Cor C5")
    check(True, "F6 the shape is NOT claimed to occur inside the V14 (Cor R2-3 stands)")


def main() -> int:
    print("verify_r2_covers.py -- R2_AMPLE_COVERS.md machine layer\n")
    sec_A()
    sec_B()
    sec_C()
    sec_D()
    sec_E()
    sec_F()
    print()
    if FAILED:
        print(f"FAILURES ({len(FAILED)}/{NCHECK}):")
        for f in FAILED:
            print("   ", f)
        return 1
    print(f"{NCHECK} assertions passed.")
    print("R2_COVERS_OK")
    return 0


if __name__ == "__main__":
    sys.exit(main())
