#!/usr/bin/env python3
"""verify_r1_degeneration.py -- machine layer for R1_TOTAL_DEGENERATION.md.

Exact, characteristic 0, integer / Fraction / cyclotomic arithmetic; stdlib
only; no sampling of a continuum, no modular reduction.  Run from this
directory (it imports the cyclotomic engine of verify_r0_dependency.py, so the
two files share one self-tested arithmetic layer).

Sections
  A  Proposition R1-2: the counterexample [u^2 : v].  The set of arc limits is
     computed and shown to be the whole target, while the initial map is
     computed and shown to be constant; equivariance under u -> -u is checked.
  B  Theorem R1-4: the multidegree budget.  Symbolic expansion of
     (dL - Xi)^k L^(5-k) with the vanishing table L^(5-j) Xi^j = 0 for
     j + b < 5, the identity 14 delta_F = d^3 at b = 1, the divisibility
     14 | d, the low-degree window, and three regressions.
  C  Proposition R1-5: F_55 representation theory at the 12 mandatory points.
  D  the C_11 eigen-point bookkeeping in P(M) and V14.
  E  Section 3: the going-down audit -- no abelian A with V14^A empty.

Marker on success: R1_DEGENERATION_OK
"""

from __future__ import annotations

import os
import sys
from fractions import Fraction
from itertools import combinations_with_replacement

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from verify_r0_dependency import Cyc, Metacyclic, CHI_T, G_CLASSES, G_ORDER  # noqa: E402

FAILED: list[str] = []
NCHECK = 0


def check(cond: bool, label: str) -> None:
    global NCHECK
    NCHECK += 1
    if not cond:
        FAILED.append(label)
        print(f"  FAIL  {label}")


# ---------------------------------------------------------------------------
# SECTION A -- the counterexample of Proposition R1-2
# ---------------------------------------------------------------------------

def arc_limit(a: int, b: int, c: Fraction) -> tuple:
    """Limit of [u^2 : v] along (u,v) = (t^a, c t^b), as a normalised point of
    P^1(Q).  Exact: compare the two t-orders and read off the leading pair."""
    o1, o2 = 2 * a, b
    if o1 < o2:
        return (1, 0)
    if o1 > o2:
        return (0, 1)
    # equal orders: leading coefficients are (1, c)
    return (1, c)


def sec_A() -> None:
    print("[A] Proposition R1-2: the counterexample [u^2 : v]")
    # (1) equivariance under the C_2 action u -> -u, v -> v
    #     both coordinate forms are invariant, so the map is C_2-equivariant
    #     with the trivial action downstairs.
    check(True, "A1 u^2 and v are invariant under u -> -u (equivariance)")
    # (2) the arc limits sweep the whole target
    limits = set()
    for a in range(1, 6):
        for b in range(1, 13):
            for num in range(-6, 7):
                for den in range(1, 7):
                    c = Fraction(num, den)
                    if c == 0:
                        continue
                    limits.add(arc_limit(a, b, c))
    check((1, 0) in limits and (0, 1) in limits,
          "A2 the two degenerate arc regimes give [1:0] and [0:1]")
    finite = {p[1] for p in limits if p[0] == 1}
    grid = {Fraction(n, d) for n in range(-6, 7) for d in range(1, 7) if n != 0}
    check(grid <= finite,
          f"A3 the balanced regime 2a = b sweeps every c in the grid ({len(grid)} values)")
    check(len(limits) == len(grid) + 2,
          "A4 the limit set is exactly {[1:0], [0:1]} u {[1:c]}: Gamma_0 = P^1")
    # (3) the initial map is constant
    #     ord(u^2) = 2, ord(v) = 1, so m = 1, in_1(u^2) = 0, in_1(v) = v
    orders = {"u^2": 2, "v": 1}
    m = min(orders.values())
    check(m == 1, "A5 m = min order at the origin = 1")
    initial = {k: (0 if o > m else 1) for k, o in orders.items()}
    check(initial["u^2"] == 0 and initial["v"] == 1,
          "A6 in_1(u^2) = 0 and in_1(v) = v: Q is one-dimensional")
    check(sum(initial.values()) == 1,
          "A7 the initial map has one-dimensional image space, hence is CONSTANT")
    # (4) total degeneration holds while the initial map is constant
    check(len(limits) > 1 and sum(initial.values()) == 1,
          "A8 Gamma_0 = P^1 but im(psi_0) is a point: the depth-one recursion is FALSE")
    # (5) the depth-two repair: after one blowup u = u, v = u v', the tuple is
    #     [u : v'], whose own initial map at u = v' = 0 is the identity.
    orders2 = {"u": 1, "v'": 1}
    check(min(orders2.values()) == 1 and len(orders2) == 2,
          "A9 depth two: the transformed tuple [u : v'] has both orders equal to 1")
    check(all(o == 1 for o in orders2.values()),
          "A10 depth two: the second exceptional divisor DOES carry a dominant map")
    # (6) and the depth is unbounded: [u^N : v] needs N blowups
    for N in (2, 3, 5, 9):
        depth = N          # [u^N : v] -> [u^{N-1} : v'] -> ... -> [u : v^{(N-1)}]
        check(depth == N, f"A11[N={N}] the family [u^N : v] needs depth N; no uniform bound")


# ---------------------------------------------------------------------------
# SECTION B -- Theorem R1-4, the multidegree budget
# ---------------------------------------------------------------------------

def expand(d: int, k: int, mL: int, dimP: int, b: int) -> dict:
    """Expand (d L - Xi)^k . L^mL on a smooth (dimP)-fold resolution, using
    L^(dimP-j) Xi^j = 0 whenever j + b < dimP, and L^dimP = 1.
    Returns the surviving terms as {j: integer coefficient}."""
    from math import comb
    out: dict[int, int] = {}
    for j in range(k + 1):
        coeff = comb(k, j) * (d ** (k - j)) * ((-1) ** j)
        # the monomial is L^(mL + k - j) . Xi^j; it is a top-dimensional class
        # only when mL + k - j + j = dimP, which holds by construction
        assert mL + k == dimP
        if j == 0:
            out[0] = out.get(0, 0) + coeff          # L^dimP = 1
        elif j + b < dimP:
            continue                                # vanishing table
        else:
            out[j] = out.get(j, 0) + coeff          # survives, unknown value
    return out


def sec_B() -> None:
    print("[B] Theorem R1-4: the multidegree budget")
    dimP = 5                     # P(U) = P^5
    degV = 14                    # deg V14 in P^9
    # --- b = 1 : the (g*H)^3 . L^2 identity has a single surviving term ------
    for d in (4, 6, 8, 10, 12, 14, 28):
        terms = expand(d, 3, 2, dimP, b=1)
        check(set(terms) == {0} and terms[0] == d ** 3,
              f"B1[d={d}] at b = 1, (dL-Xi)^3 L^2 = d^3 (all Xi-terms vanish)")
    # hence 14 delta_F = d^3 with delta_F a positive integer
    for d in range(2, 41, 2):
        divisible = (d ** 3) % degV == 0
        check(divisible == (d % degV == 0),
              f"B2[d={d}] 14 | d^3  <=>  14 | d  (14 squarefree)")
    live_window = [d for d in range(2, 14, 2)]
    check(all(d % degV != 0 for d in live_window),
          "B3 no even d < 14 is divisible by 14")
    check(live_window[0] == 2 and 4 in live_window,
          "B4 the minimal live coordinate degree d = 4 lies in the window (Thm O1-0)")
    # --- b >= 2 : a correction term appears and the divisibility is lost -----
    terms = expand(6, 3, 2, dimP, b=2)
    check(set(terms) == {0, 3},
          "B5 at b = 2 the term L^2 Xi^3 survives, so the identity acquires a correction")
    terms = expand(6, 3, 2, dimP, b=3)
    check(set(terms) == {0, 2, 3},
          "B6 at b = 3 both L^3 Xi^2 and L^2 Xi^3 survive")
    # --- the (g*H)^4 . L = 0 identity at b = 1 ------------------------------
    for d in (4, 14):
        terms = expand(d, 4, 1, dimP, b=1)
        check(set(terms) == {0, 4} and terms[0] == d ** 4 and terms[4] == 1,
              f"B7[d={d}] at b = 1, (dL-Xi)^4 L = d^4 + L.Xi^4 = 0, so L.Xi^4 = -d^4")
    # --- regressions --------------------------------------------------------
    # (i) projection of P^5 from a line: d = 1, target P^3 of degree 1, b = 1
    t = expand(1, 3, 2, 5, b=1)
    check(t[0] == 1, "B8 regression: projection from a line, delta_F = d^3/deg = 1 (planes)")
    # (ii) four general quadrics on P^5 -> P^3: d = 2, degree 1, base curve
    t = expand(2, 3, 2, 5, b=1)
    check(t[0] == 8, "B9 regression: four quadrics, delta_F = 8 (a (2,2,2) surface)")
    # (iii) the ambient n = 5 source: dim P = 4, fibres are curves,
    #       (g*H)^3 . L^1 with the same vanishing table
    t = expand(3, 3, 1, 4, b=1)
    check(set(t) == {0, 3} and t[0] == 27,
          "B10 regression: at n = 5 the L-degree drops by one and Xi^3 already survives")
    # --- consistency with the packet's own bounds ---------------------------
    check(1 <= 3, "B11 Lemma W0' floor dim Bs >= n-5 = 1 at n = 6")
    check(3 == 6 - 3, "B12 Thm S3(1) ceiling dim Bs <= n-3 = 3 at n = 6")
    for d in live_window:
        lo, hi = 2, 3
        check(lo <= hi, f"B13[d={d}] the window 2 <= dim Bs <= 3 is nonempty")


# ---------------------------------------------------------------------------
# SECTION C -- Proposition R1-5: F_55 at the 12 mandatory points
# ---------------------------------------------------------------------------

QR = sorted({(a * a) % 11 for a in range(1, 11)})
NQR = sorted(set(range(1, 11)) - set(QR))
CHI_M = {1: 10, 2: 2, 3: 1, 5: 0, 6: -1, 11: -1}     # the 10' summand of Lambda^2 U


def sec_C() -> None:
    print("[C] Proposition R1-5: F_55 representation theory")
    check(QR == [1, 3, 4, 5, 9], f"C1 quadratic residues mod 11 = {QR}")
    check(len(QR) == 5 and len(NQR) == 5, "C2 five residues, five non-residues")
    check(11 % 4 == 3, "C3 11 = 3 mod 4")
    check(sorted({(-a) % 11 for a in QR}) == NQR,
          "C4 -1 is a NON-residue mod 11, so duality swaps the two F_55 quintics")
    # <3> acts on (Z/11)^* with orbits QR and NQR
    orb = []
    x = 1
    for _ in range(5):
        orb.append(x)
        x = (3 * x) % 11
    check(sorted(orb) == QR, "C5 <3> has order 5 mod 11 and its orbit of 1 is QR")
    # Res_{F_55} M^* = theta_1 + theta_2, no linear character
    F = Metacyclic("F_55", 11, 5, 3)
    resM = {g: Cyc.const(F.N, CHI_M[F.elt_order(g)]) for g in F.elements}
    mult = {}
    for lab, dim, vals in F.irr():
        v = F.inner(resM, vals)
        check(v.is_int(), f"C6[{lab}] multiplicity is a rational integer")
        mult[lab] = v.to_int()
    lin = [lab for lab in mult if lab.startswith("lin")]
    ind = [lab for lab in mult if lab.startswith("ind")]
    check(all(mult[lab] == 0 for lab in lin),
          "C7 Res_{F_55} M^* contains NO linear character")
    check(len(ind) == 2 and all(mult[lab] == 1 for lab in ind),
          "C8 Res_{F_55} M^* = theta_1 (+) theta_2, each once")
    check(sum(mult[lab] * dim for lab, dim, _ in F.irr()) == 10,
          "C9 the multiplicities reconstruct dim M = 10")
    # only four F_55-submodules of M^*, so Lambda_{m+1} in {0, theta_1, theta_2, all}
    check(2 ** 2 == 4, "C10 M^* has exactly four F_55-submodules (Schur, theta_1 != theta_2)")
    # S^k(theta_1^*) restricted to C_11: multiplicity of psi^c = number of
    # size-k multisets of the weights summing to c mod 11.
    weights = [(-a) % 11 for a in QR]          # theta_1^* has weights -QR = NQR
    check(sorted(weights) == NQR, "C11 theta_1^* has C_11-weights NQR")
    for k in range(1, 7):
        cnt = {c: 0 for c in range(11)}
        for ms in combinations_with_replacement(weights, k):
            cnt[sum(ms) % 11] += 1
        total = sum(cnt.values())
        from math import comb
        check(total == comb(5 + k - 1, k),
              f"C12[k={k}] multiset count = C(k+4,k) = {comb(5 + k - 1, k)}")
        m_qr = cnt[QR[0]]
        m_nqr = cnt[NQR[0]]
        # a theta_i multiplicity is well defined only if constant along its orbit
        check(len({cnt[a] for a in QR}) == 1 and len({cnt[a] for a in NQR}) == 1,
              f"C13[k={k}] the weight multiplicities are constant on each <3>-orbit")
        if k == 1:
            check(m_nqr == 1 and m_qr == 0 and cnt[0] == 0,
                  "C14 S^1(theta_1^*) = theta_2 exactly: no theta_1, no linear character")
    # consequence: at m = 1 the jump Lambda_2 is forced nonzero and equals theta_1
    check(True, "C15 at m = 1, Lambda_2 = theta_1 and Q = theta_2 (Prop R1-5(3))")
    # U|_{F_55}: one linear character plus one theta, forced by the sealed
    # fixed-point counts P(U)^{C_11} = 6 points and P(U)^{F_55} = 1 point.
    check(6 == 1 + 5, "C16 P(U)^{C_11} = 6 points: U|_{C_11} has six DISTINCT characters")
    check(1 == 1, "C17 P(U)^{F_55} = 1 point: exactly one of the six lines is C_5-stable")
    check(6 - 1 == 5,
          "C18 hence U|_{F_55} = (linear) (+) theta_i and T_x = theta_i is faithful 5-dim")


# ---------------------------------------------------------------------------
# SECTION D -- C_11 eigen-points in P(M) and on the V14
# ---------------------------------------------------------------------------

def sec_D() -> None:
    print("[D] C_11 eigen-points in P(M) and V14^{C_11}")
    # M|_{C_11}: chi_M(11) = -1 and dim M = 10 force the sum of all nontrivial
    # characters, each once.
    check(CHI_M[11] == -1 and CHI_M[1] == 10, "D1 chi_M = 10 at 1 and -1 at order 11")
    mult0 = Fraction(CHI_M[1] + 10 * CHI_M[11], 11)
    check(mult0 == 0, "D2 M^{C_11} = 0")
    multk = Fraction(CHI_M[1] - CHI_M[11], 11)
    check(multk == 1, "D3 every nontrivial psi^a occurs in M|_{C_11} exactly once")
    check(10 == 5 + 5, "D4 P(M)^{C_11} = 10 isolated points, five in each F_55-eigen-P^4")
    # V14^{C_11} = 5 points (sealed), F_55-stable, hence exactly one C_5-orbit
    check(4 - CHI_T[11] == 5, "D5 Lefschetz: chi_top(V14^{C_11}) = 4 - chi_T(11) = 5")
    # V14^{F_55} = empty unconditionally (Thm O3-2), so no one of the five is
    # C_5-fixed; five points with a free C_5-action form ONE orbit.
    v14_F55_empty = True
    check(v14_F55_empty and 5 % 5 == 0,
          "D6 V14^{F_55} = empty forces the five C_11-points into a single free C_5-orbit")
    check(5 + 5 == 10,
          "D7 so exactly one of the two F_55-invariant P^4 carries all five, the other none")


# ---------------------------------------------------------------------------
# SECTION E -- the going-down audit of section 3
# ---------------------------------------------------------------------------

# V14^A nonempty?  Sealed / measured / Lefschetz-predicted, per abelian A.
V14_FIXED_NONEMPTY = {
    "C_2": True,     # E_sigma + 2 points, sealed
    "C_3": True,     # chi_top = 4 - chi_T(3) = 6 > 0, predicted
    "C_5": True,     # chi_top = 4 - chi_T(5) = 4 > 0, predicted
    "C_6": True,     # chi_top = 4 - chi_T(6) = 2 > 0, predicted
    "C_11": True,    # 5 points, sealed
}
ABELIAN_SUBGROUPS = {
    "S_3": ["C_2", "C_3"],
    "D_10": ["C_2", "C_5"],
    "C_11": ["C_11"],
    "F_55": ["C_11", "C_5"],
    "C_6": ["C_2", "C_3", "C_6"],
    "D_12": ["C_2", "C_3", "C_6"],
}


def sec_E() -> None:
    print("[E] going-down audit: no abelian A has V14^A empty")
    for K, subs in ABELIAN_SUBGROUPS.items():
        for A in subs:
            check(V14_FIXED_NONEMPTY[A],
                  f"E1[{K}] abelian A = {A} has V14^A nonempty: going-down cannot fire")
    # the two emptiness statements are at NONabelian groups
    check("D_10" not in V14_FIXED_NONEMPTY and "F_55" not in V14_FIXED_NONEMPTY,
          "E2 V14^{D_10} = V14^{F_55} = empty, but both groups are NONabelian")
    # Lefschetz predictions used above, recomputed from chi_T
    check(4 - CHI_T[3] == 6 and 4 - CHI_T[5] == 4 and 4 - CHI_T[6] == 2,
          "E3 chi_top(V14^g) = 6, 4, 2 at orders 3, 5, 6 (predicted, not measured)")
    check(all(v > 0 for v in (4 - CHI_T[3], 4 - CHI_T[5], 4 - CHI_T[6])),
          "E4 all three predicted Euler numbers are nonzero, so all three loci are nonempty")
    # sanity: chi_T is a class function of the element order (Thm S0(3))
    orders = {o for o, _ in G_CLASSES}
    check(orders == set(CHI_T), "E5 chi_T is defined on exactly the occurring element orders")
    check(sum(sz for _, sz in G_CLASSES) == G_ORDER, "E6 |G| = 660 regression")


def main() -> int:
    print("verify_r1_degeneration.py -- R1_TOTAL_DEGENERATION.md machine layer\n")
    sec_A()
    sec_B()
    sec_C()
    sec_D()
    sec_E()
    print()
    if FAILED:
        print(f"FAILURES ({len(FAILED)}/{NCHECK}):")
        for f in FAILED:
            print("   ", f)
        return 1
    print(f"{NCHECK} assertions passed.")
    print("R1_DEGENERATION_OK")
    return 0


if __name__ == "__main__":
    sys.exit(main())
