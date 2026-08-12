#!/usr/bin/env python3
"""
REFEREE spot-checks R2 and R4 -- Lemma F, its p = 2 sharpness, the
congruence coefficient tables, and the d = 35 arithmetic.

Everything here is exact integer arithmetic, independent of the packet's
e2_congruences.py (compared against its published claims, not its code).
The subgroup-order set is re-derived from the 660 matrices with an
independent closure implementation, sweeping <rep, h> over conjugacy-class
representatives rep and all h in G (valid because every subgroup of
PSL(2,11) is 2-generated: by Dickson's classification the subgroups are
cyclic, dihedral, V4, A4, F55 = 11:5, A5 and G itself -- all 2-generated).

Run:  python3 referee_arith.py     (a few minutes; the sweep is 8 x 660
closures).  Set REFEREE_FAST=1 to skip the sweep and use the classical
order list (the sweep result is asserted equal to it when run).
"""

import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, "scripts"))

from psl211 import Model, SPLIT_PRIMES

FAILS = []
CLASSICAL_ORDERS = [1, 2, 3, 4, 5, 6, 10, 11, 12, 55, 60, 660]


def chk(name, ok, detail=""):
    print("[%s] %s %s" % ("PASS" if ok else "FAIL", name, detail))
    if not ok:
        FAILS.append(name)


def vp(n, p):
    k = 0
    while n % p == 0:
        n //= p
        k += 1
    return k


def derive_orders(m):
    inv = {A: m.matinv(A) for A in m.G}
    reps, seen = [], set()
    for A in m.G:
        if A in seen:
            continue
        cls = {m.mm(m.mm(X, A), inv[X]) for X in m.G}
        seen |= cls
        reps.append(A)

    def closure(gens):
        S = {m.Id}
        frontier = [m.Id]
        while frontier:
            nf = []
            for A in frontier:
                for g in gens:
                    B = m.mm(A, g)
                    if B not in S:
                        S.add(B)
                        nf.append(B)
            frontier = nf
        return len(S)

    orders = set()
    for A in reps:
        orders.add(closure([A]))
        for h in m.G:
            orders.add(closure([A, h]))
    return sorted(orders)


def main():
    # ---------------- R2: the subgroup-order set --------------------------
    if os.environ.get("REFEREE_FAST"):
        orders = CLASSICAL_ORDERS
        print("(REFEREE_FAST: using the classical Dickson order list)")
    else:
        orders = derive_orders(Model(SPLIT_PRIMES[0]))
    chk("subgroup_orders_are_the_dickson_list", orders == CLASSICAL_ORDERS,
        orders)

    # ---------------- R2: Lemma F, from Lagrange alone --------------------
    # The proof needs only |S| | 660 and v_p(660) = 1, so it must hold for
    # EVERY divisor of 660, not just realised subgroup orders.  Check that.
    chk("660_factorisation", 660 == 2 * 2 * 3 * 5 * 11)
    chk("v_p_660", (vp(660, 2), vp(660, 3), vp(660, 5), vp(660, 11))
        == (2, 1, 1, 1))
    divisors = [s for s in range(1, 661) if 660 % s == 0]
    for p in (11, 5, 3):
        ok = all(((660 // s) % p == 0) == (s % p != 0) for s in divisors)
        chk("lemma_F_all_divisors_p%d" % p, ok)
    # p = 2 sharpness: the equivalence fails exactly at v_2(s) = 1; among
    # actual subgroup orders that is {2, 6, 10} -- as THEOREM.md section 3.2
    # claims -- and nowhere else.
    fail2 = [s for s in orders if ((660 // s) % 2 == 0) != (s % 2 != 0)]
    chk("p2_sharpness_fails_exactly_at_2_6_10", fail2 == [2, 6, 10], fail2)
    chk("p2_failures_are_exactly_v2_equals_1",
        fail2 == [s for s in orders if vp(s, 2) == 1])

    # ---------------- R2/R4: coefficient tables ---------------------------
    expected = {
        11: {11: 5, 55: 1, 660: 1},
        5:  {5: 2, 10: 1, 55: 2, 60: 1, 660: 1},
        3:  {3: 1, 6: 2, 12: 1, 60: 2, 660: 1},
    }
    for p, exp in expected.items():
        got = {s: (660 // s) % p for s in orders if s % p == 0}
        chk("coefficients_mod_%d" % p, got == exp, got)
    # section 3.1's printed class coefficients (by class, order-aggregated):
    chk("sec3_1_mod11_C11_F55", (60 % 11, 12 % 11) == (5, 1))
    chk("sec3_1_mod5_C5_D10_F55_A5",
        (132 % 5, 66 % 5, 12 % 5, 11 % 5) == (2, 1, 2, 1))
    chk("sec3_1_mod3_C3_S3_C6_A4_D12_A5",
        (220 % 3, 110 % 3, 110 % 3, 55 % 3, 55 % 3, 11 % 3)
        == (1, 2, 2, 1, 1, 2))

    # ---------------- R4: the d = 35 instance ------------------------------
    chk("35_mod_11_is_2_nonresidue", 35 % 11 == 2
        and 2 not in {pow(a, 2, 11) for a in range(1, 11)})
    chk("fourth_powers_mod_11_are_QRs",
        sorted({pow(a, 4, 11) for a in range(1, 11)}) == [1, 3, 4, 5, 9])
    chk("35^4_mod_11_is_5", pow(35, 4, 11) == 5)
    chk("inverse_of_5_mod_11_is_9", (5 * 9) % 11 == 1)
    # 5 s(C11) + s(F55) = 5  =>  s(C11) = 9(5 - s(F55)) = 45 - 9 s(F55)
    #                                  = 1 - 9 s(F55) (mod 11)
    chk("solved_form_1_minus_9_sF55", (9 * 5) % 11 == 1)
    ok = all((5 * ((1 - 9 * sf) % 11) + sf) % 11 == 5 for sf in range(11))
    chk("solved_form_checks_for_all_sF55", ok)
    chk("mu4_eq_1_solutions_pm1",
        sorted(mu for mu in range(11) if pow(mu, 4, 11) == 1) == [1, 10])
    # mod 5 and mod 3 right-hand sides at d = 35
    chk("35^4_mod_5_is_0_not_1", pow(35, 4, 5) == 0)
    chk("35^4_mod_3_is_1", pow(35, 4, 3) == 1)
    chk("fermat_for_p_not_dividing_d",
        all(pow(a, 4, 5) == 1 for a in range(1, 5))
        and all(pow(a, 4, 3) == 1 for a in range(1, 3)))

    # ---------------- R4/R6: the {12, 21} narrowing ------------------------
    # mu in [1, 35], mu = +-1 (mod 11)  [E2 conditional],  3 | mu  [ND
    # corollary: E.D^3 = mu^3 = 3 e_E with e_E in Z, and 3 prime].
    chk("3_divides_mu3_iff_3_divides_mu",
        all((mu ** 3 % 3 == 0) == (mu % 3 == 0) for mu in range(1, 100)))
    cands = [mu for mu in range(1, 36) if pow(mu, 4, 11) == 1 and mu % 3 == 0]
    chk("candidates_are_12_21", cands == [12, 21], cands)
    # hypothesis-necessity controls: drop a hypothesis, the set grows
    no3 = [mu for mu in range(1, 36) if pow(mu, 4, 11) == 1]
    chk("without_3|mu_set_is_larger", no3 == [1, 10, 12, 21, 23, 32, 34], no3)
    no11 = [mu for mu in range(1, 36) if mu % 3 == 0]
    chk("without_mod11_set_is_larger", len(no11) == 11, no11)

    print()
    print("referee_arith: %d failures" % len(FAILS))
    return 1 if FAILS else 0


if __name__ == "__main__":
    sys.exit(main())
