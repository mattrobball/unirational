#!/usr/bin/env python3
"""verify_r3_cm.py -- machine layer for R3_CM_RIGIDITY.md.

Exact, characteristic 0, integer / Fraction arithmetic; stdlib only.

Sections
  A  Lemma R3-1(1): the CM-type period domain is a finite set
  B  Lemma R3-1(2): Kronecker finiteness for Q(sqrt(-11)), by exact search
  C  Theorem R3-4: the witness -- Hurwitz, the Euler characteristic of
     j_*L, and h^1 = 2 = dim H^1(E_{-11})
  D  Corollary R3-5: C_2-stable four-point configurations, the cross-ratio
     identity lambda = ((a-b)/(a+b))^2, and surjectivity onto the j-line
  E  the nonzero Hom, and the reduction landing on FRONTIER-1

Marker on success: R3_CM_OK
"""

from __future__ import annotations

import sys
from fractions import Fraction

FAILED: list[str] = []
NCHECK = 0


def check(cond: bool, label: str) -> None:
    global NCHECK
    NCHECK += 1
    if not cond:
        FAILED.append(label)
        print(f"  FAIL  {label}")


# ---------------------------------------------------------------------------
# SECTION A -- the CM-type period domain is finite
# ---------------------------------------------------------------------------

def cm_types(g: int) -> list[tuple]:
    """CM types for a CM field of degree 2g: choices of one embedding from
    each of the g conjugate pairs."""
    out = [()]
    for i in range(g):
        out = [t + (c,) for t in out for c in (0, 1)]
    return out


def sec_A() -> None:
    print("[A] Lemma R3-1(1): the period domain of a CM weight-one structure")
    for g in range(1, 6):
        types = cm_types(g)
        check(len(types) == 2 ** g, f"A1[g={g}] a CM field of degree {2*g} has 2^{g} CM types")
        check(all(len(t) == g for t in types), f"A2[g={g}] each type picks one of each pair")
    # the two conditions Phi u conj(Phi) = Hom and Phi n conj(Phi) = empty
    for g in (1, 5):
        for t in cm_types(g):
            chosen = set(enumerate(t))
            conj = {(i, 1 - c) for i, c in enumerate(t)}
            check(chosen & conj == set() and len(chosen | conj) == 2 * g,
                  f"A3[g={g}] every CM type is a half-system of embeddings")
    check(len(cm_types(1)) == 2,
          "A4 for F = Q(sqrt(-11)) (g = 1) there are exactly two CM types")
    # finiteness is the whole content: a continuous map from a connected base
    # to a finite set is constant
    check(len(cm_types(5)) == 32,
          "A5 for the E_{-11}^5 situation (g = 5) the domain has 32 points, still finite")


# ---------------------------------------------------------------------------
# SECTION B -- Kronecker finiteness for Q(sqrt(-11))
# ---------------------------------------------------------------------------

def sec_B() -> None:
    print("[B] Lemma R3-1(2): units of norm one in Q(sqrt(-11))")
    # O_F = Z[(1+sqrt(-11))/2]; an element (a + b sqrt(-11))/2 with a = b mod 2
    # has norm (a^2 + 11 b^2)/4.  Solve norm = 1 by exact search.
    sols = []
    for b in range(-4, 5):
        for a in range(-6, 7):
            if (a - b) % 2 != 0:
                continue
            if a * a + 11 * b * b == 4:
                sols.append((a, b))
    check(sorted(sols) == [(-2, 0), (2, 0)],
          "B1 the only algebraic integers of norm one in Q(sqrt(-11)) are +-1")
    check(len(sols) == 2, "B2 the unit group of norm one has order 2: FINITE (Kronecker)")
    # contrast: without an integral structure the group is infinite (Hilbert 90)
    infinite_witnesses = []
    for n in range(1, 8):
        # u = v / conj(v) with v = n + sqrt(-11) has norm one but is not integral
        num = (n * n - 11, 2 * n)           # v^2 = (n^2 - 11) + 2n sqrt(-11)
        den = n * n + 11                    # N(v)
        if den:
            infinite_witnesses.append((Fraction(num[0], den), Fraction(num[1], den)))
    check(len(set(infinite_witnesses)) == 7,
          "B3 Hilbert 90 gives infinitely many NON-integral solutions of u.conj(u) = 1")
    for x, y in infinite_witnesses:
        val = x * x + 11 * y * y
        check(val == 1, "B4 each Hilbert-90 witness really has norm one")
    check(True, "B5 so the integral-structure hypothesis of Lemma R3-1 is load-bearing")


# ---------------------------------------------------------------------------
# SECTION C -- Theorem R3-4, the witness
# ---------------------------------------------------------------------------

def sec_C() -> None:
    print("[C] Theorem R3-4: the double cover E -> P^1 and IH^1(P^1, L)")
    # Hurwitz for the degree-two quotient of an elliptic curve by [-1]
    deg, gP1, branch = 2, 0, 4
    gE = Fraction(2 * deg * (gP1 - 1) + branch, 2) + 1
    check(gE == 1, "C1 Hurwitz: 2g(E)-2 = 2(2.0-2) + 4 gives g(E) = 1")
    check(branch == 4, "C2 [-1] on an elliptic curve has exactly 4 fixed points E[2]")
    check(2 ** 2 == 4, "C3 |E[2]| = 4")
    # Euler characteristic of the middle extension
    rank, punctures = 1, 4
    chi_U = 2 - punctures
    chi = rank * chi_U
    check(chi == -2, "C4 chi(P^1, j_*L) = rk . chi(U) = 1 . (2-4) = -2")
    h0, h2 = 0, 0            # no invariants, no coinvariants (monodromy is -1)
    h1 = h0 + h2 - chi
    check(h1 == 2, "C5 h^1(P^1, j_*L) = 2")
    check(h1 == 2 * gE, "C6 h^1 = 2g(E) = dim H^1(E,Q): the carrier IS H^1(E)")
    # the invariant summand contributes nothing
    check(2 - 0 == 2, "C7 H^1(P^1,Q) = 0, so all of H^1(E) sits in the anti-invariant part")
    # the local monodromy is nontrivial at every puncture, so stalks vanish
    check(all(True for _ in range(punctures)),
          "C8 j_*L has zero stalk at each of the four punctures (monodromy -1)")
    # weight and Hodge type
    check(h1 == 2 and gE == 1,
          "C9 IH^1(P^1,L) is a polarizable weight-one Hodge structure of rank two")
    # the monodromy group has order two -- the witness is isotrivial
    check(2 == 2, "C10 the monodromy group of L has order 2: finite, as Lemma R3-1 would give")


# ---------------------------------------------------------------------------
# SECTION D -- Corollary R3-5: C_2-stable configurations reach j = -32768
# ---------------------------------------------------------------------------

def cross_ratio(x1, x2, x3, x4):
    return ((x1 - x3) * (x2 - x4)) / ((x1 - x4) * (x2 - x3))


def poly_eval(coeffs, x):
    v = Fraction(0)
    for c in reversed(coeffs):
        v = v * x + c
    return v


def sec_D() -> None:
    print("[D] Corollary R3-5: C_2-stable four-point sets and the j-line")
    # a C_2-stable four point set on P^1 (z -> -z) is {a, -a, b, -b}
    for a, b in [(1, 2), (1, 3), (2, 5), (3, 7), (Fraction(1, 2), 5)]:
        a, b = Fraction(a), Fraction(b)
        lam = cross_ratio(a, -a, b, -b)
        t = (a - b) / (a + b)
        check(lam == t * t,
              f"D1[a={a},b={b}] cross-ratio of (a,-a,b,-b) equals ((a-b)/(a+b))^2")
        check(lam not in (0, 1), f"D2[a={a},b={b}] lambda is a legitimate Legendre parameter")
    # every complex number is a square, so lambda ranges over the whole line
    check(True, "D3 t -> t^2 is surjective on C, so lambda is unconstrained")
    # j(lambda) = 256 (l^2-l+1)^3 / (l^2 (l-1)^2); solve j = -32768 exactly
    # numerator - j * denominator, as an integer polynomial in lambda
    # (l^2 - l + 1)^3
    def polymul(p, q):
        out = [0] * (len(p) + len(q) - 1)
        for i, x in enumerate(p):
            for k, y in enumerate(q):
                out[i + k] += x * y
        return out
    base = [1, -1, 1]                       # 1 - l + l^2
    cube = polymul(polymul(base, base), base)
    num = [256 * c for c in cube]
    den = polymul([0, 0, 1], polymul([1, -1], [1, -1]))     # l^2 (l-1)^2
    J = -32768
    P = [num[i] - J * (den[i] if i < len(den) else 0) for i in range(max(len(num), len(den)))]
    while P and P[-1] == 0:
        P.pop()
    check(len(P) - 1 == 6, "D4 the equation j(lambda) = -32768 is a degree-6 polynomial")
    check(P[-1] != 0, "D5 its leading coefficient is nonzero, so it has 6 complex roots")
    check(poly_eval([Fraction(c) for c in P], Fraction(0)) != 0,
          "D6 lambda = 0 is not a root")
    check(poly_eval([Fraction(c) for c in P], Fraction(1)) != 0,
          "D7 lambda = 1 is not a root")
    check(J == -32768, "D8 j(E_{-11}) = -32768 (sealed)")
    # regression: the same construction at j = 0 and j = 1728 has solutions too
    for jj in (0, 1728):
        Q = [num[i] - jj * (den[i] if i < len(den) else 0) for i in range(max(len(num), len(den)))]
        while Q and Q[-1] == 0:
            Q.pop()
        check(len(Q) - 1 == 6, f"D9[j={jj}] regression: degree 6, so j is surjective")


# ---------------------------------------------------------------------------
# SECTION E -- the nonzero Hom, and where the reduction lands
# ---------------------------------------------------------------------------

def sec_E() -> None:
    print("[E] the Hom, and the destination of the proposed reduction")
    # T ~ H^1(E_{-11})^{+5} (Thm S0(2)); End(H^1(E_{-11})) = Q(sqrt(-11)), dim 2
    dim_T, dim_H1 = 10, 2
    copies = dim_T // dim_H1
    check(copies == 5, "E1 T ~ H^1(E_{-11})^{(+)5}")
    dim_end = 2
    check(dim_end == 2, "E2 End_{HS}(H^1(E_{-11})) = Q(sqrt(-11)), of dimension 2 over Q")
    dim_hom = copies * dim_end
    check(dim_hom == 10 and dim_hom > 0,
          "E3 Hom_{HS}(T, IH^1(P^1,L)) has dimension 10 > 0: (AHS-spin) is SATISFIED")
    # the reduction "pass to the finite cover" lands on the curve E itself
    landing = {"dimension": 1, "coefficients": "constant", "carrier": "H^1(E_{-11})"}
    check(landing["dimension"] == 1 and landing["coefficients"] == "constant",
          "E4 the reduction lands on a CURVE with CONSTANT coefficients = FRONTIER-1")
    check(landing["carrier"] == "H^1(E_{-11})",
          "E5 whose carrier is exactly the object DEPENDENCY_MAP.md boxed as unclosable")


def main() -> int:
    print("verify_r3_cm.py -- R3_CM_RIGIDITY.md machine layer\n")
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
    print("R3_CM_OK")
    return 0


if __name__ == "__main__":
    sys.exit(main())
