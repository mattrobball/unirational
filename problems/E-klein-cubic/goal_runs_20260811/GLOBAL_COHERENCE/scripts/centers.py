"""Inventory of the 22 immune rows by CENTER orbit.

Reuses IMMUNE_ROWS and the master weight formula from sealed s2pin.py.
Does not rewrite chain data or either w(R) code path.
"""
from math import gcd
from itertools import product

from paths import S2PIN_SCRIPTS, D10_E_BRANCH, D10_L_BRANCH  # noqa: F401
from s2pin import (  # noqa: E402
    IMMUNE_ROWS, pathA_weight, pathB_level0, pathB_level1, pathB_level2,
    value_set, QR11, SPECTRUM,
)

# ---------------------------------------------------------------- centers
# Each center orbit carries one shared mu-sequence.  Rows over that center
# are listed with their chains; values are computed from the shared mus via
# Theorem 1.2:  w = d * base + sum mu_l * c_l  (mod n).

CENTERS = [
    {
        "id": "C11",
        "n": 11,
        "base": 9,          # representative C11-point (weight 9)
        "mu_names": ("mu",),
        "rows": [r for r in IMMUNE_ROWS if r["n"] == 11],
        # truncation: values depend on mu only mod 11/gcd(c,11)=11
        "periods": (11,),
    },
    {
        "id": "C5a",
        "n": 5,
        "base": 1,
        "mu_names": ("mu",),
        "rows": [r for r in IMMUNE_ROWS if r["n"] == 5 and r["base"] == 1],
        "periods": (5,),
    },
    {
        "id": "C5b",
        "n": 5,
        "base": 2,
        "mu_names": ("mu",),
        "rows": [r for r in IMMUNE_ROWS if r["n"] == 5 and r["base"] == 2],
        "periods": (5,),
    },
    {
        "id": "D10",
        "n": 5,
        "base": 0,          # always a base point; value weight = mu0 * c
        "mu_names": ("mu0",),
        "rows": [r for r in IMMUNE_ROWS if r["n"] == 5 and r["base"] == 0],
        "periods": (5,),
    },
    {
        "id": "A4a",
        "n": 3,
        "base": 1,
        "mu_names": ("mu1", "mu2"),
        "rows": [r for r in IMMUNE_ROWS if r["n"] == 3 and r["base"] == 1],
        "periods": (3, 3),
    },
    {
        "id": "A4b",
        "n": 3,
        "base": 2,
        "mu_names": ("mu1", "mu2"),
        "rows": [r for r in IMMUNE_ROWS if r["n"] == 3 and r["base"] == 2],
        "periods": (3, 3),
    },
]

ROW_ORDER = [r["name"] for r in IMMUNE_ROWS]
assert len(ROW_ORDER) == 22
assert sum(len(c["rows"]) for c in CENTERS) == 22


def row_weight(n, d, base, chain, mus):
    """w(R) via sealed PATH A (closed form).  mus is a tuple aligned to chain."""
    pairs = [(mus[i], chain[i]) for i in range(len(chain))]
    return pathA_weight(n, d % n, base, pairs)


def residual_count_A4(mu1):
    """STAGE2_SECOND_ORDER Theorem 2.2: residual values per immune C3-row.

    mu=1 impossible; mu=2,4 valueless; mu=3 excludes X^{C6} (2 values);
    mu>=5 all three realisable.  For mu>5 the sealed packet verified only
    mu=5; we take residual 3 (the Tier-3 extension named there).
    """
    if mu1 < 2:
        return None          # impossible
    if mu1 in (2, 4):
        return 0
    if mu1 == 3:
        return 2
    return 3                 # mu >= 5


def residual_labels(n, weight, rcount):
    """Concrete residual value labels for a row of weight `weight`.

    rcount = 0  -> only the undefined token
    rcount = 2  -> the two exact-C3 points (C6 excluded)  [A4, mu=3]
    rcount = 3  -> full value_set (C6 + two exact-C3)
    For n != 3 the residual is 0 or 1 (single eigenpoint or undefined).
    """
    if rcount == 0:
        return ("UNDEF",)
    vs = value_set(n, weight)
    if not vs:
        return ("UNDEF",)
    if n == 3 and rcount == 2:
        return tuple(v for v in vs if v.startswith("exactC3"))
    if n == 3 and rcount == 3:
        return tuple(vs)
    # C5 / C11: single eigenpoint when on X
    return (vs[0],)


def admissible_mus_C11(d):
    """mu >= 0 if d in QR11; mu >= 1 otherwise.  Truncate mod 11."""
    d11 = d % 11
    if d11 in QR11:
        return list(range(0, 11))
    return list(range(1, 12))   # 1..11 covers all nonzero classes mod 11


def admissible_mus_C5(d):
    """mu = 0 open iff 5 does not divide d; else mu >= 1.  Truncate mod 5.
    When 5 | d the congruence requires 5 does not divide mu for values on X
    (otherwise the two pt_D10 / the C5 rows go deeper)."""
    d5 = d % 5
    if d5 != 0:
        return [0]            # mu=0 collapse: all four rows share T(q)
    return [1, 2, 3, 4]       # 5 does not divide mu; mu=5 == mu=0 invalid here


def admissible_mus_D10():
    """mu0 >= 1 always (D10-points always base); 5 does not divide mu0."""
    return [1, 2, 3, 4]


def admissible_mus_A4():
    """mu1 >= 2 (Prop 2.1 of STAGE2_SECOND_ORDER); mu2 >= 1 (Prop 2.3 sealed).

    Enumerate a complete set of (weight-class, residual-type) representatives:
      mu1 in {2,3,4,5,6,7,8}  covers every class mod 3 with residual types
      0 (mu=2,4), 2 (mu=3), 3 (mu>=5).
      mu2 in {1,2,3}          covers every class mod 3 (period 3).
    """
    return list(product([2, 3, 4, 5, 6, 7, 8], [1, 2, 3]))


def center_value_vectors(center, d, sharing=True):
    """Return the set of distinct value-tuples for the rows of `center`.

    Each tuple has length = #rows of the center, entries are value labels
    or 'UNDEF'.  With sharing=True the mu-sequence is shared; with
    sharing=False the STAGE2 residual product is used for A4 and a single
    forced pattern for C5/C11/D10 (the §4 anchors).
    """
    n = center["n"]
    base = center["base"]
    rows = center["rows"]
    cid = center["id"]
    out = set()

    if not sharing:
        # ---- anchors of STAGE2 §4 ------------------------------------
        # A4: independent residual 3 per row (the overcount shared-mu removes).
        # STAGE2 counts 3^8 after pinning the eigenline; weights are fixed by
        # a map's mu, residual choices are independent across the 8 rows.
        if cid.startswith("A4"):
            labels = ("res0", "res1", "res2")   # abstract residual 3
            for choice in product(labels, repeat=len(rows)):
                out.add(choice)
            return out
        # C5 / C11 / D10: single pattern per residue (STAGE2 §4)
        if cid == "C11":
            mu = 0 if (d % 11) in QR11 else 1
        elif cid in ("C5a", "C5b"):
            mu = 0 if (d % 5) != 0 else 1
        elif cid == "D10":
            mu = 1
        else:
            mu = 0
        vec = []
        for r in rows:
            ch = r["chain"]
            w = row_weight(n, d, base, ch, (mu,))
            on = (n == 3 and w != 0) or (n == 5 and w != 0) or (
                n == 11 and w in QR11)
            labs = residual_labels(n, w, 1 if on else 0)
            vec.append(labs[0])
        out.add(tuple(vec))
        return out

    # ---- sharing ON --------------------------------------------------
    if cid == "C11":
        for mu in admissible_mus_C11(d):
            vec = []
            for r in rows:
                w = row_weight(n, d, base, r["chain"], (mu,))
                # on X iff w in QR11
                labs = residual_labels(n, w, 1 if w in QR11 else 0)
                vec.append(labs[0])
            out.add(tuple(vec))
        return out

    if cid in ("C5a", "C5b"):
        for mu in admissible_mus_C5(d):
            vec = []
            for r in rows:
                w = row_weight(n, d, base, r["chain"], (mu,))
                labs = residual_labels(n, w, 1 if w != 0 else 0)
                vec.append(labs[0])
            out.add(tuple(vec))
        return out

    if cid == "D10":
        for mu0 in admissible_mus_D10():
            vec = []
            for r in rows:
                w = row_weight(n, d, base, r["chain"], (mu0,))
                labs = residual_labels(n, w, 1 if w != 0 else 0)
                vec.append(labs[0])
            out.add(tuple(vec))
        return out

    if cid.startswith("A4"):
        for mu1, mu2 in admissible_mus_A4():
            rc = residual_count_A4(mu1)
            if rc is None:
                continue
            weights = []
            for r in rows:
                ch = r["chain"]
                mus = (mu1,) if len(ch) == 1 else (mu1, mu2)
                w = row_weight(n, d, base, ch, mus)
                weights.append(w)
            if rc == 0:
                # all rows of this orbit valueless
                out.add(tuple("UNDEF" for _ in rows))
                continue
            label_lists = []
            for w in weights:
                if w == 0:
                    label_lists.append(("UNDEF",))
                else:
                    label_lists.append(residual_labels(3, w, rc))
            for choice in product(*label_lists):
                out.add(choice)
        return out

    raise ValueError("unknown center %s" % cid)


def d10_branch_for_mu0(mu0, d=0):
    """D10 C2-line branch size from shared mu0 at the D10-point.

    STAGE1_TIGHTEN Prop 2.1: parity of d*a_k + mu1 selects the branch.
    At a D10-point the C5-weight is 0; under the involution tau the centre
    is fixed (a_k even), so the parity is that of mu0.  Even -> E-branch
    (13), odd -> L-branch (10).
    """
    return D10_E_BRANCH if (mu0 % 2 == 0) else D10_L_BRANCH


def d10_mu0_from_vector(vec):
    """Recover mu0 mod 5 from a D10 value-vector (two eigpt labels), or None."""
    # labels look like 'eigpt(w=%d)' ; w = mu0 * c for c=1,2
    ws = []
    for lab in vec:
        if lab == "UNDEF" or not lab.startswith("eigpt"):
            return None
        # eigpt(w=k)
        w = int(lab.split("=")[1].rstrip(")"))
        ws.append(w)
    if len(ws) != 2:
        return None
    # w1 = mu0 * 1, w2 = mu0 * 2  (mod 5)
    for mu0 in (1, 2, 3, 4):
        if (mu0 * 1) % 5 == ws[0] and (mu0 * 2) % 5 == ws[1]:
            return mu0
    return None


def d10_available_branches(d10_vec):
    """Which D10 C2-line branch sizes are attainable for this D10 sub-vector.

    Values depend on mu0 only mod 5, so mu0 and mu0+5 give the same vector
    with opposite parity.  Both branches are therefore attainable whenever
    the vector is defined (mu0 in {1,2,3,4}).  We still report the pair
    (13, 10) so the join can either take one (per-map) or both (pattern
    union).  For the exact global pattern count G we sum, over realizing
    mu0 classes, the branch size of that class — see phase2.
    """
    mu0 = d10_mu0_from_vector(d10_vec)
    if mu0 is None:
        return []
    # both parities: mu0 and mu0+5 (same values mod 5)
    return [D10_E_BRANCH, D10_L_BRANCH]
