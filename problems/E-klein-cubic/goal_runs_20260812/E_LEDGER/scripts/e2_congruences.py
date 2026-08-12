#!/usr/bin/env python3
"""
E2 -- the base-orbit congruences, with the mod-p filter lemma PROVED here.

AUTHORITY: theory/SCHEME_MAP_CONSEQUENCES_20260812.md section 3.1,
"Derivation of E2".

SETUP (restated so the proof below is self-contained).  `q^*H_X` is a ring
homomorphism image, `H_X^4 = 0` on the 3-fold `X`, so `(q^*H_X)^4 = 0` on
`Z~`.  Writing `q^*H_X = d H - sum_E m_E E` and pushing forward by `pi`, the
`d^4 H^4` term survives with degree `d^4`; every other term is a class
supported on the exceptional locus `pi^{-1}(Bs(T^o))`.  Since `pi` has
connected fibres, the connected components of that locus are exactly the
preimages of the connected components of `Bs(T^o)`, so the degree splits as
a sum of LOCAL integers, one per connected component:

        d^4  =  sum_j n_j s_j ,     n_j = 660 / |S_j| ,   s_j in Z,        (E2)

`S_j = Stab_G` of a component in the j-th G-orbit of components (the tower
may be chosen G-equivariant, so `s` is constant along an orbit).

--------------------------------------------------------------------------
LEMMA F (the mod-p filter).  PROVED HERE, from orbit sizes only.
--------------------------------------------------------------------------
Let `p in {3, 5, 11}` and let `S <= G = PSL(2,11)`, `|G| = 660`.  Put
`n = 660/|S|`.  Then

        p | n     if and only if     p does not divide |S| .

*Proof.*  `660 = 2^2 . 3 . 5 . 11`, so `v_p(660) = 1` for each of
`p = 3, 5, 11` (this is the whole content: `p^2` does not divide `|G|`).
By Lagrange `|S|` divides 660, so `v_p(|S|) <= v_p(660) = 1`, i.e.
`v_p(|S|) in {0,1}`, and `v_p(n) = v_p(660) - v_p(|S|) = 1 - v_p(|S|)`.
Hence `v_p(n) >= 1` iff `v_p(|S|) = 0`.  QED

(Note what the proof does NOT need: any classification of subgroups.  It
needs only Lagrange and `p^2 does not divide 660`.  This is also exactly why
`p = 2` is excluded from the list: `v_2(660) = 2`, and a subgroup of order 2
gives `n = 330 = 0 mod 2` even though `2 | |S|`.)

Reducing (E2) mod `p` therefore kills every orbit whose stabilizer has order
prime to `p`, and leaves

        d^4  =  sum_{j : p | |S_j|}  n_j s_j    (mod p).                 (E2_p)

--------------------------------------------------------------------------
FLAG E2-G-ORBIT (the branch that is STOPPED, not patched)
--------------------------------------------------------------------------
Section 3.1's displayed table drops the row `|S| = 660` with the
parenthetical "G (excluded: proper components)".  Lemma F does not exclude
it: `11, 5, 3` all divide 660, so a G-STABILISED connected component of
`Bs(T^o)` has `n = 1`, survives every reduction, and enters each congruence
with coefficient 1 and an unconstrained integer `s_G` -- which removes all
bite.  Machine fact recorded by this packet (from the independently rebuilt
arrangement): EVERY pair of the 55 plus-planes meets in P^4 (1320 pairs in a
point, 165 in a line), so the union of the 55 plus-planes is CONNECTED and
G-stable; if it lies in `Bs(T^o)` it is precisely such a component.  This
packet therefore reports BOTH forms and exercises neither:

  (i)  the section-3.1 form, valid under
       HYPOTHESIS H-PROPER: `Bs(T^o)` has no G-stabilised connected
       component (equivalently: `G` acts on the set of connected components
       of `Bs(T^o)` without a fixed point);
  (ii) the unconditional form, which carries the extra term `s_G`.

python3 standard library only; exact integer arithmetic.
"""

import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

PRIMES = (11, 5, 3)
GROUP_ORDER = 660


# ---------------------------------------------------------------- Lemma F

def vp(n, p):
    k = 0
    while n % p == 0:
        n //= p
        k += 1
    return k


def lemma_F_check(subgroup_orders):
    """
    Machine check of Lemma F over every subgroup order of G, plus the
    p = 2 counterexample that shows why the lemma is stated for the primes
    dividing 660 exactly once.
    """
    rows = []
    ok = True
    for s in sorted(subgroup_orders):
        assert GROUP_ORDER % s == 0, "Lagrange violated: %d" % s
        n = GROUP_ORDER // s
        row = {"|S|": s, "n = 660/|S|": n}
        for p in PRIMES:
            lhs = (n % p == 0)
            rhs = (s % p != 0)
            row["p=%d: p|n" % p] = lhs
            row["p=%d: p does not divide |S|" % p] = rhs
            row["p=%d: equivalence" % p] = (lhs == rhs)
            ok = ok and (lhs == rhs)
            row["n mod %d" % p] = n % p
        rows.append(row)
    # the p = 2 control: v_2(660) = 2, so the equivalence FAILS there
    p2_fail = [s for s in subgroup_orders
               if ((GROUP_ORDER // s) % 2 == 0) != (s % 2 != 0)]
    return {"v_p(660)": {str(p): vp(GROUP_ORDER, p) for p in (2, 3, 5, 11)},
            "rows": rows, "lemma_F_holds_for_11_5_3": ok,
            "p2_control_failures": p2_fail,
            "p2_control_shows_lemma_needs_v_p=1": len(p2_fail) > 0}


# --------------------------------------------- subgroup orders, derived

def derive_subgroup_orders(model):
    """
    The set of orders of subgroups of G, DERIVED from the 660 matrices.
    Every subgroup of PSL(2,11) is 2-generated, and any 2-generated subgroup
    <a,b> is conjugate to one whose first generator is a conjugacy-class
    representative, so closing <rep, h> over class representatives `rep` and
    all `h in G` reaches every subgroup up to conjugacy.
    """
    m = model
    # conjugacy class representatives (by brute-force class computation)
    reps = []
    seen = set()
    inv = {A: m.matinv(A) for A in m.G}
    for A in m.G:
        if A in seen:
            continue
        cls = set()
        for X in m.G:
            cls.add(m.mm(m.mm(X, A), inv[X]))
        seen |= cls
        reps.append((A, len(cls)))

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
        return S

    orders = set()
    for A, _ in reps:
        orders.add(len(closure([A])))
        for h in m.G:
            orders.add(len(closure([A, h])))
    return sorted(orders), [(len(closure([A])), sz) for A, sz in reps]


# ------------------------------------------------- the three congruences

def congruence_coefficients(subgroup_orders):
    """
    For each p, the subgroup orders that survive the filter and the
    coefficient n mod p they carry.
    """
    out = {}
    for p in PRIMES:
        rows = []
        for s in sorted(subgroup_orders):
            if s % p == 0:
                rows.append({"|S|": s, "n": GROUP_ORDER // s,
                             "coefficient n mod p": (GROUP_ORDER // s) % p})
        out[str(p)] = rows
    return out


def fourth_powers(p):
    return sorted({pow(a, 4, p) for a in range(1, p)})


def instance(d, subgroup_orders):
    """
    The E2 congruence data for a specific degree d: the right-hand side
    d^4 mod p and the surviving left-hand side, written out.
    """
    out = {"d": d, "rows": {}}
    for p in PRIMES:
        terms = []
        for s in sorted(subgroup_orders):
            if s % p == 0:
                terms.append("%d*s(|S|=%d)" % ((GROUP_ORDER // s) % p, s))
        out["rows"][str(p)] = {
            "d mod p": d % p,
            "p divides d": (d % p == 0),
            "rhs d^4 mod p": pow(d, 4, p),
            "congruence": " + ".join(terms) + " = %d (mod %d)"
                          % (pow(d, 4, p), p),
            "section_3_1_drops": "the |S| = 660 term (FLAG E2-G-ORBIT)",
        }
    return out


# ------------------------------------------- the d = 35 order-11 corollary

def d35_order11(census_heavy_11):
    """
    Section 3.1, corollary 2, reproduced with its hypotheses attached.
    `census_heavy_11` is the list of census orbits with 11 | |Stab|.
    """
    d = 35
    d4 = pow(d, 4, 11)
    # 5 s(C11) + s(F55) = d^4 (mod 11)   [under H-PROPER]
    inv5 = pow(5, 11 - 2, 11)
    # s(C11) = 5^{-1}(d^4 - s(F55))
    sC11_if_F55_zero = (inv5 * d4) % 11
    mu_solutions = sorted({mu for mu in range(11) if pow(mu, 4, 11) == 1})
    return {
        "d": d,
        "d mod 11": d % 11,
        "d^4 mod 11": d4,
        "is_11_a_QR_residue_of_d": (d % 11) in fourth_powers(11),
        "congruence_under_H_PROPER": "5*s(C11) + 1*s(F55) = %d (mod 11)" % d4,
        "solved_for_s_C11": "s(C11) = %d - %d*s(F55) (mod 11)"
                            % (sC11_if_F55_zero, (inv5 * 1) % 11),
        "section_3_1_form": "s(C11) = 1 - 9*s(F55) (mod 11)",
        "reproduced": (sC11_if_F55_zero == 1 and (inv5 % 11) == 9),
        "census_orbits_with_11_dividing_stab": census_heavy_11,
        "mu_solutions_of_mu^4=1_mod_11": mu_solutions,
        "conditional_statement":
            "IF the only 11-heavy connected components of Bs(T^o) are the 60 "
            "C11-points AND the local level-4 contribution at each is the "
            "nondegenerate value mu^4 (mu = mult), THEN mu^4 = 1 (mod 11), "
            "i.e. mu = +-1 (mod 11).  Both clauses -- the 11-heavy-component "
            "clause (which subsumes H-PROPER and s(F55) = 0) and the "
            "nondegeneracy clause -- are hypotheses, not results.",
    }


if __name__ == "__main__":
    import json
    from psl211 import Model
    m = Model(331)
    orders, _ = derive_subgroup_orders(m)
    print("subgroup orders:", orders)
    print(json.dumps(lemma_F_check(orders)["lemma_F_holds_for_11_5_3"], indent=1))
    print(json.dumps(congruence_coefficients(orders), indent=1))
    print(json.dumps(d35_order11([]), indent=1))
