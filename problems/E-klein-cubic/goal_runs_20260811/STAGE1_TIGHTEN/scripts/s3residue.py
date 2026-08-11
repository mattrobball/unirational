"""STAGE1_TIGHTEN -- the residue-indexed count.

Where the degree enters the sigma-band, RIGOROUSLY.  A stratum's leading datum is
a multigraded piece of T; STAGE1's Layer-2 parametrisation (multidegree a on the
positive-dimensional slots, character psi of Gamma = Stab_G(F)) is correct
because psi absorbs the degrees along the directions TRANSVERSE to the stratum.
G-invariance of T (STAGE2 Lemma 0.1) forces psi = 1 only when the stratum's slots
EXHAUST W -- and that happens for exactly two rows of the census:

    D_{P_sigma}   = P(W^+) x P(W^-)    slot dims 3 + 2 = 5
    D_{L^-_sigma} = P(W^-) x P(W^+)    slot dims 2 + 3 = 5

For those two, and only those two, the component is a multidegree a with
sum a_r = d and psi = 1, so the available component classes at degree d are the
realized classes rho mod 6 with sum rho_r = d (mod 6).  That is the exact point
where the covariant degree enters the order-0 sigma-band, and it makes the
STAGE1 core count a function of d mod 6.

Everything else in the sigma-band keeps its STAGE1 table (all psi): imposing
psi = 1 there would be an error, because the transverse degrees are real.
"""
import os
import sys
from collections import defaultdict

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from s3sweep import FullSweep                       # noqa: E402
from s3sat import classes, contribution             # noqa: E402
from s1recount import build_tables, coherent_count, sweep_rows   # noqa: E402

FULL_FLAG = None      # computed: the rows whose slot dims sum to 5


def full_flag_rows(E):
    out = []
    for rid in sweep_rows(E):
        S = FullSweep(E, rid)
        if sum(S.dims) == 5:
            out.append(rid)
    return out


def degree_tables(E, box=17, verbose=False):
    """for the two full-flag divisors: table[e] = contributions available when
    d = e (mod 6)."""
    out = {}
    for rid in full_flag_rows(E):
        S = FullSweep(E, rid)
        cls, mins, R, ok = classes(S, box=box)
        assert ok
        per = defaultdict(list)
        for rho, reps in cls.items():
            a = min(reps, key=sum)
            c = contribution(S, a, E)
            if c is None or any(v not in E.dom[r0] for r0, v in c.items()):
                continue
            per[sum(rho) % 6].append(c)
        out[rid] = dict(per)
        if verbose:
            print("  #%02d realized classes %d; usable per (d mod 6): %s"
                  % (rid, len(cls), {e: len(v) for e, v in sorted(per.items())}),
                  flush=True)
    return out


def residue_core(E, verbose=False):
    """the coherent count of the whole system, per d mod 6."""
    base, meta = build_tables(E)
    deg = degree_tables(E, verbose=verbose)
    out = {}
    for e in range(6):
        t = dict(base)
        ok = True
        for rid, per in deg.items():
            t[rid] = per.get(e, [])
            if not t[rid]:
                ok = False
        if not ok:
            out[e] = dict(total=0, note="a forced sweep has no component at this residue")
            continue
        tot, blocks = coherent_count(E, t)
        core = max(blocks, key=lambda b: b["size"])
        out[e] = dict(total=tot, core=core["solutions"], core_size=core["size"])
        if verbose:
            print("  d = %d (mod 6): total %d, core %d rows -> %d"
                  % (e, tot, core["size"], core["solutions"]), flush=True)
    return out, deg, meta


# ---------------------------------------------------------------- D10 row
def d10_split(E):
    """the 23 values of the D10 C2-line, split by the tau-weight of the value."""
    rid = [r["id"] for r in E.rows if r["setwise"] == "C2"][0]
    m, T = E.m, E.T
    r = [q for q in E.rows if q["id"] == rid][0]
    sig = [x for x in r["H"] if x != m.Id][0]
    plus, minus = T.plus[sig], T.minus[sig]
    onE, onL = [], []
    for v in E.dom[rid]:
        k, cell, lab = v
        if k == "dom":
            onL.append(v)
        elif k == "gen":
            (onE if cell == "E" else onL).append(v)
        else:
            u = lab[0] if cell in ("PI", "P6") else None
            if u is None:
                onE.append(v)          # type-II: on all three E's, on no L
            elif m.rank([list(x) for x in minus] + [list(u)]) == 2:
                onL.append(v)
            else:
                onE.append(v)
    return rid, onE, onL
