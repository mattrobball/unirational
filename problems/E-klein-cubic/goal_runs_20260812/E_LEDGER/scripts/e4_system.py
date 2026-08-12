#!/usr/bin/env python3
"""
E4 -- the projection-formula system across the census, emitted
machine-readably, with its rank and its forced entries.

AUTHORITY: theory/SCHEME_MAP_CONSEQUENCES_20260812.md section 3.1, "E4
shape".  Solving the system is explicitly NOT required; its rank and any
forced entries are.

UNKNOWNS (per residue class; here instantiated at d = 35 where a value is
wanted, otherwise kept symbolic):

  d                    the reduced degree                       (parameter)
  m_i,  i = 1..14      the census orbit multiplicities, m_i = ord_{D_i}(q^*H_X)
  s_i,  i = 1..14      the LEVEL-4 local total at a component of orbit i
  s_G                  the level-4 local total at a G-stabilised component
  t_i,  t_G            the LEVEL-3 analogues
  nu                   H . C, C the generic fibre curve
  eb_i, i = 1..14      the ORBIT-SUMMED fibre degree  sum_{E in orbit i} E.C
  g                    the genus of C

EQUATIONS (all four are exact identities of the intersection ledger; the
first two are the pushforwards of section 3.1's level-4 and level-3 rows,
the last two are C1, reproduced from this packet's own Chow implementation
in chow.py):

  R1  sum_i n_i s_i + s_G                 = d^4
  R2  sum_i n_i t_i + t_G + 3 nu          = d^3
  R3  d nu - sum_i m_i eb_i               = 0
  R4  (2d-5) nu + sum_i (a_i - 2 m_i) eb_i - 2g + 2 = 0

with n_i the census orbit size and a_i = 3 - dim(centre) the blowup
discrepancy.  R1/R2 also carry, on the left, the unknown EXTRA orbits that
Group G forces to exist; those columns are declared in the emitted system
and are exactly what makes it under-determined.

Reduced mod p in {11,5,3}, R1 and R2 become the E2 congruences (e2_congruences.py).
Together with the E3 inequality block (e3_movable.py) this is "one linear
system over the census".

python3 standard library only; exact Fractions.
"""

import os
import sys
from fractions import Fraction

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

from census import CENSUS                          # noqa: E402
import chow                                        # noqa: E402


ORDER = ["pt_C11", "pt_D10", "pt_A4(a)", "pt_A4(b)", "pt_V4I", "pt_C5(a)",
         "pt_C5(b)", "pt_C6(a)", "pt_C6(b)", "pt_D12", "C3line",
         "Lminus_sigma", "ell_V", "P_sigma"]


def _rank(rows):
    """Exact rank of a list of Fraction rows."""
    M = [list(r) for r in rows]
    n = len(M[0]) if M else 0
    r = 0
    for c in range(n):
        pr = None
        for i in range(r, len(M)):
            if M[i][c] != 0:
                pr = i
                break
        if pr is None:
            continue
        M[r], M[pr] = M[pr], M[r]
        pv = M[r][c]
        M[r] = [x / pv for x in M[r]]
        for i in range(len(M)):
            if i != r and M[i][c] != 0:
                f = M[i][c]
                M[i] = [a - f * b for a, b in zip(M[i], M[r])]
        r += 1
    return r


def build(d, m_values=None, n_extra_orbits=1):
    """
    Emit the system.  `m_values` may be None (symbolic; the rank is then
    computed at generic integer specialisations and certified by an explicit
    non-vanishing minor) or a dict label -> int.
    """
    n = {lab: CENSUS[lab][1] for lab in ORDER}
    a = {lab: chow.discrepancy(CENSUS[lab][0]) for lab in ORDER}

    variables = []
    for lab in ORDER:
        variables.append({"name": "m[%s]" % lab, "kind": "integer >= 0",
                          "role": "orbit multiplicity ord_{D}(q^*H_X)"})
    for lab in ORDER:
        variables.append({"name": "s[%s]" % lab, "kind": "integer",
                          "role": "level-4 local total at a component"})
    variables.append({"name": "s[G]", "kind": "integer",
                      "role": "level-4 local total at a G-stabilised component "
                              "(see FLAG E2-G-ORBIT)"})
    for k in range(n_extra_orbits):
        variables.append({"name": "s[extra%d]" % k, "kind": "integer",
                          "role": "level-4 local total at an UNKNOWN extra "
                                  "orbit (Group G forces at least one)"})
        variables.append({"name": "n[extra%d]" % k, "kind": "integer, 660/|S|",
                          "role": "its orbit size"})
    for lab in ORDER:
        variables.append({"name": "t[%s]" % lab, "kind": "integer",
                          "role": "level-3 local total"})
    variables.append({"name": "t[G]", "kind": "integer"})
    variables.append({"name": "nu", "kind": "integer >= 1", "role": "H . C"})
    for lab in ORDER:
        variables.append({"name": "eb[%s]" % lab, "kind": "integer >= 0",
                          "role": "orbit-summed fibre degree sum_{E in orbit} E.C"})
    variables.append({"name": "g", "kind": "integer >= 0", "role": "genus of C"})

    equations = [
        {"name": "R1_level4",
         "source": "SCHEME_MAP_CONSEQUENCES section 3.1 'Derivation of E2'; "
                   "coefficients = census orbit sizes",
         "kind": "linear in s",
         "lhs": ({"s[%s]" % lab: n[lab] for lab in ORDER}
                 | {"s[G]": 1}
                 | {"s[extra%d]" % k: "n[extra%d]" % k
                    for k in range(n_extra_orbits)}),
         "rhs": "d^4"},
        {"name": "R2_level3",
         "source": "SCHEME_MAP_CONSEQUENCES section 3.1, the level-3 row "
                   "'3 nu = d^3 - sum (level-3 orbit terms)'",
         "kind": "linear in t and nu",
         "lhs": ({"t[%s]" % lab: n[lab] for lab in ORDER}
                 | {"t[G]": 1, "nu": 3}),
         "rhs": "d^3"},
        {"name": "R3_pairing",
         "source": "CONSTRAINT_ADDITIONS C1, third relation; reproduced by "
                   "chow.run_c1_reproduction()['C1b_projection_pairing']",
         "kind": "linear in nu and eb, coefficients (d, m)",
         "lhs": {"nu": "d"} | {"eb[%s]" % lab: "-m[%s]" % lab for lab in ORDER},
         "rhs": "0"},
        {"name": "R4_genus",
         "source": "CONSTRAINT_ADDITIONS C1, genus package; reproduced by "
                   "chow.run_c1_reproduction()['C1c_genus_package']",
         "kind": "linear in nu, eb, g; coefficients (d, m)",
         "lhs": ({"nu": "2d-5"}
                 | {"eb[%s]" % lab: "%d - 2*m[%s]" % (a[lab], lab)
                    for lab in ORDER}
                 | {"g": -2}),
         "rhs": "-2"},
    ]

    # ---- rank of the linear part ------------------------------------
    # Blocks are variable-disjoint: {s, s_G, s_extra} for R1;
    # {t, t_G, nu} for R2; {nu, eb} for R3; {nu, eb, g} for R4.  Only R2,
    # R3, R4 share the column `nu`.  We compute the rank exactly at generic
    # integer specialisations of (d, m) and certify it with an explicit
    # non-vanishing minor.
    cols = (["s[%s]" % l for l in ORDER] + ["s[G]"]
            + ["t[%s]" % l for l in ORDER] + ["t[G]", "nu"]
            + ["eb[%s]" % l for l in ORDER] + ["g"])
    ci = {c: k for k, c in enumerate(cols)}

    def numeric_rows(dv, mv):
        R = [[Fraction(0)] * len(cols) for _ in range(4)]
        for lab in ORDER:
            R[0][ci["s[%s]" % lab]] = Fraction(n[lab])
            R[1][ci["t[%s]" % lab]] = Fraction(n[lab])
        R[0][ci["s[G]"]] = Fraction(1)
        R[1][ci["t[G]"]] = Fraction(1)
        R[1][ci["nu"]] = Fraction(3)
        R[2][ci["nu"]] = Fraction(dv)
        R[3][ci["nu"]] = Fraction(2 * dv - 5)
        for lab in ORDER:
            R[2][ci["eb[%s]" % lab]] = Fraction(-mv[lab])
            R[3][ci["eb[%s]" % lab]] = Fraction(a[lab] - 2 * mv[lab])
        R[3][ci["g"]] = Fraction(-2)
        return R

    if m_values is None:
        trials = []
        for k in range(1, 6):
            mv = {lab: (7 * k + 3 * j + 1) for j, lab in enumerate(ORDER)}
            trials.append(_rank(numeric_rows(d, mv)))
        rank = max(trials)
        rank_note = ("generic rank over Q(d, m); max over 5 integer "
                     "specialisations, all giving %r" % (trials,))
    else:
        rank = _rank(numeric_rows(d, m_values))
        rank_note = "rank at the supplied (d, m)"

    # explicit non-vanishing 4x4 minor certifying rank 4
    minor_cols = ["s[G]", "t[G]", "eb[%s]" % ORDER[0], "g"]
    mv = {lab: 1 for lab in ORDER}
    sub = [[numeric_rows(d, mv)[i][ci[c]] for c in minor_cols] for i in range(4)]
    minor_rank = _rank(sub)

    # ---- forced entries ---------------------------------------------
    forced = []
    if rank < len(cols):
        forced_note = ("the linear part has %d equations in %d declared "
                       "unknowns (plus the unknown extra-orbit columns), so "
                       "NO variable is forced by the linear part alone"
                       % (rank, len(cols)))
    else:
        forced_note = "unexpected: full rank"

    return {"d": d, "orbit_sizes": n, "discrepancies": a,
            "variables": variables, "equations": equations,
            "linear_part": {"columns": cols, "rank": rank,
                            "rank_note": rank_note,
                            "certifying_minor_columns": minor_cols,
                            "certifying_minor_rank": minor_rank},
            "forced_entries": forced, "forced_note": forced_note}


# ------------------------------------------------------- the ND corollary

def nd_corollary(d, pinned):
    """
    Under HYPOTHESIS ND at an ISOLATED point centre (the only exceptional
    divisor over it is the first blowup, with multiplicity mu), chow.py gives
        E . D^3 = mu^3    and    E . D^3 = 3 (E.C) = 3 e_E ,
    so 3 | mu^3, hence 3 | mu.  Combined with E2's d = 35 order-11 corollary
    (mu = +-1 mod 11) and E3's d >= mu this narrows mu to a finite set.

    ISOLATED census point orbits (they occur in NO crossing of
    TERMINUS_STRATA_PW/results/t3_localmodels.txt section (3)): pt_C11,
    pt_C5(a), pt_C5(b).  Everything below is CONDITIONAL on ND at those
    centres and, for the mod-11 clause, on the E2 hypotheses.
    """
    V = ("d", "m")
    ED3 = None
    T = chow.DisjointTower([0])
    D = T.qstarH()
    Ecls = (T.zero(), [chow.Poly.const(T.vars, 1)])
    ED3 = T.deg([Ecls, D, D, D])
    mu_ok = [mu for mu in range(1, d + 1)
             if pow(mu, 4, 11) == 1 and mu % 3 == 0]
    return {"E_dot_D3_at_an_isolated_point_centre": repr(ED3),
            "identity": "E.D^3 = 3 e_E with e_E = E.C in Z, so 3 | mu^3, "
                        "hence 3 | mu",
            "isolated_census_point_orbits": ["pt_C11", "pt_C5(a)", "pt_C5(b)"],
            "mu_range_used": "1 <= mu <= d (E3: d >= m at a point centre)",
            "mu_candidates_at_d=%d_under_ND_and_the_mod11_clause" % d: mu_ok,
            "status": "CONDITIONAL -- hypotheses ND (nondegenerate isolated "
                      "centre) and the E2 order-11 hypotheses; NOT a result"}
