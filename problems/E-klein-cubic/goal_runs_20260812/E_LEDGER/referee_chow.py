#!/usr/bin/env python3
"""
REFEREE spot-check R1 -- the blowup Chow anchors, by a route the packet does
NOT use.

The packet derives deg(H^{4-b} E^b) on Bl_Z P^4 (Z = P^delta linear) from the
Grothendieck relation on P(N) (scripts/chow.py `_reduce_PN`).  This referee
script recomputes the same 15 numbers from the PRODUCT MODEL of P(N):

    N = O_Z(1)^r = O^r (x) O_Z(1)   ==>   E = P(N) = P^delta x P^{r-1},

and in Fulton's sub-bundle convention  O_{P(N)}(-1) = pr2* O(-1) (x) pr1* O(1),
so  xi = c1(O_{P(N)}(1)) = eta - h  with eta the P^{r-1} hyperplane class and
h the P^delta hyperplane class.  Then, using only E|_E = -xi and H|_E = h,

    deg(H^{4-b} E^b) = int_{P^delta x P^{r-1}} (-(eta - h))^{b-1} h^{4-b}
                     = coefficient of h^delta eta^{r-1},

a computation in the ring Z[h,eta]/(h^{delta+1}, eta^r) that never touches the
Grothendieck relation.  The sign convention is pinned independently by the
point case (E = P^3, O_E(E) = O(-1), E^4 = deg c1(O(-1))^3 = -1) and by the
projection identity (H-E)^4 = 0, which fails under any sign flip.

Also re-checked here: the Segre closed form, the level-4/level-3 local forms
s(delta), t(delta), and E.D^3 = mu^3 at an isolated point centre (the input to
the E4 ND corollary's 3 | mu step).

Run:  python3 referee_chow.py     (exits 0 iff every check passes)
"""

import os
import sys
from fractions import Fraction

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, "scripts"))

import chow  # the packet's implementation, compared against, never trusted


def binom(n, k):
    if k < 0 or k > n:
        return 0
    out = 1
    for i in range(k):
        out = out * (n - i) // (i + 1)
    return out


def product_model_number(delta, b):
    """deg(H^{4-b} E^b) via E = P^delta x P^{r-1}, xi = eta - h."""
    r = 4 - delta
    if b == 0:
        return 1                      # deg H^4 on the blowup
    # (-(eta-h))^{b-1} * h^{4-b}, coefficient of h^delta eta^{r-1}
    # (h-eta)^{b-1} = sum_j C(b-1,j) h^{b-1-j} (-eta)^j
    need_eta = r - 1
    coeff = 0
    for j in range(b):
        he = (b - 1 - j) + (4 - b)    # total h exponent
        if j == need_eta and he == delta:
            coeff += binom(b - 1, j) * ((-1) ** j)
    return coeff


def main():
    fails = []

    def chk(name, ok, detail=""):
        print("[%s] %s %s" % ("PASS" if ok else "FAIL", name, detail))
        if not ok:
            fails.append(name)

    expected = {  # THEOREM.md section 1 table, b = 0..4
        0: [1, 0, 0, 0, -1],
        1: [1, 0, 0, 1, 3],
        2: [1, 0, -1, -2, -3],
    }

    for delta in (0, 1, 2):
        mine = [product_model_number(delta, b) for b in range(5)]
        packet = [chow.blowup_numbers(delta)[b] for b in range(5)]
        chk("product_model_matches_packet_delta=%d" % delta,
            [Fraction(x) for x in mine] == packet, "%s vs %s" % (mine, packet))
        chk("table_in_THEOREM_md_delta=%d" % delta,
            mine == expected[delta], str(mine))
        # Segre closed form (Fulton 4.4), third route
        seg = [1] + [
            (0 if b < 4 - delta
             else ((-1) ** (delta + 1)) * binom(b - 1, b - 4 + delta))
            for b in range(1, 5)]
        chk("segre_closed_form_delta=%d" % delta, seg == mine, str(seg))
        # projection identity (H-E)^4 = 0 -- pins every sign
        val = sum(((-1) ** b) * binom(4, b) * mine[b] for b in range(5))
        chk("(H-E)^4=0_delta=%d" % delta, val == 0, "got %d" % val)

    # sign-flip control: flipping the sign of the odd-b entries must BREAK
    # (H-E)^4 = 0 for the plane centre (so the identity really pins signs)
    flipped = [1, 0, -1, 2, -3]
    val = sum(((-1) ** b) * binom(4, b) * flipped[b] for b in range(5))
    chk("sign_flip_control_breaks_projection_identity", val != 0, "got %d" % val)

    # local forms, recomputed from the product-model numbers alone:
    # s = d^4 - deg((dH-mE)^4),  t = d^3 - deg(H (dH-mE)^3), as polynomials.
    # Compare coefficient dictionaries {(pow_d, pow_m): coeff}.
    def s_poly(delta):
        out = {}
        for b in range(1, 5):
            c = -binom(4, b) * product_model_number(delta, b) * ((-1) ** b)
            if c:
                out[(4 - b, b)] = c
        return out

    def t_poly(delta):
        out = {}
        for b in range(1, 4):
            c = -binom(3, b) * product_model_number(delta, b) * ((-1) ** b)
            if c:
                out[(3 - b, b)] = c
        return out

    exp_s = {0: {(0, 4): 1},
             1: {(1, 3): 4, (0, 4): -3},
             2: {(2, 2): 6, (1, 3): -8, (0, 4): 3}}
    exp_t = {0: {},
             1: {(0, 3): 1},
             2: {(1, 2): 3, (0, 3): -2}}
    for delta in (0, 1, 2):
        chk("level4_local_form_delta=%d" % delta, s_poly(delta) == exp_s[delta],
            str(s_poly(delta)))
        chk("level3_local_form_delta=%d" % delta, t_poly(delta) == exp_t[delta],
            str(t_poly(delta)))
        # and against the packet's Poly objects
        sp = chow.local_contribution_level4(delta)
        got = {e: c for e, c in sp.terms.items()}
        chk("level4_matches_packet_delta=%d" % delta,
            {k: Fraction(v) for k, v in exp_s[delta].items()} == got)

    # E.D^3 at an isolated point centre (D = dH - mE):
    # E.(dH-mE)^3 = d^3 H^3E - 3d^2m H^2E^2 + 3dm^2 HE^3 - m^3 E^4
    #             = -m^3 * (-1) = m^3.
    n0 = [product_model_number(0, b) for b in range(5)]
    # coefficient of the m^3 term and vanishing of the rest:
    chk("E_dot_D3_point_is_mu^3",
        n0[1] == 0 and n0[2] == 0 and n0[3] == 0 and -1 * n0[4] == 1,
        "H3E,H2E2,HE3,E4 = %s" % (n0[1:],))

    print()
    print("referee_chow: %d failures" % len(fails))
    return 1 if fails else 0


if __name__ == "__main__":
    sys.exit(main())
