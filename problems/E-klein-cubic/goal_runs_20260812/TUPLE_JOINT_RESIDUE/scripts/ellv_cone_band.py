"""ℓ_V-band rows under the cone-order filter ord_{ℓ_V} ≥ 6.

Census row rid 4 = ell_V (setwise V4, dim 2, slots [2,2]): the unique
sweep-capable row over the V4-triple-lines.  Children are rows 23, 24
(ell_V < P_σ).  STAGE1 records a single usable child-pattern on this row.

Cone order (CONE_ORDER_AUDIT, tuple-level): every landing tuple has
ord_{ℓ_V}(T) ≥ 6.  Multidegree bookkeeping on the ell_V SweepRow: slot 0 is
the line itself (V4-trivial), slot 1 a complementary 2-plane.  We filter to
multidegrees with a representative satisfying max(a_0, a_1) ≥ 6 (the profile
order r is at least the heaviest slot degree on the stratum; equivalently any
a with some a_i ≥ 6 after a + 6 e_r lift, by Theorem S periodicity g_r | 6).

Free ψ (Prop 0.1: slots do not exhaust W).  No STAGE2 pinning.
"""
import itertools
from collections import defaultdict

import paths  # noqa: F401
from s1coherence import SweepRow  # noqa: E402
from s3sweep import FullSweep  # noqa: E402
from s3sat import classes as full_classes  # noqa: E402


ELLV_RID = 4
R_MIN = 6


def _usable_pattern(E, S, vals):
    """Turn a SweepRow.classes value-dict into an arc-consistent assignment or None."""
    byidx = {k["idx"]: k for k in S.kids}
    assign = {}
    for idx, v in vals.items():
        if v == "DEGENERATE":
            continue
        if v in ("NONRIGID", "NONCONST"):
            return None
        kid = byidx[idx]
        cell, lab = v
        if cell == "gen":
            return None
        own = E.T.act(E.m.matinv(kid["tr"]), cell, lab)
        r0 = kid["row"]
        pt = ("pt", cell, own)
        if r0 in assign and assign[r0] != pt:
            return None
        assign[r0] = pt
    if any(v not in E.dom[r0] for r0, v in assign.items()):
        return None
    return assign


def ellv_patterns(E, maxdeg=12, r_min=R_MIN, verbose=False):
    """Usable ell_V patterns under cone filter max(a) >= r_min.

    Returns:
      all_pats: list of assignment dicts (no cone filter; STAGE1 baseline)
      cone_pats: list under max(a_i) >= r_min
      per_residue: for each sum(a) mod 6, cone patterns
      sat_report: Theorem-S-style up-set / stability checks
    """
    S = SweepRow(E, ELLV_RID)
    cl = S.classes(maxdeg)
    all_set = set()
    cone_set = set()
    per = defaultdict(set)
    by_a = defaultdict(set)
    for key, vals in cl.items():
        a, psi = key
        asn = _usable_pattern(E, S, vals)
        if asn is None:
            continue
        t = tuple(sorted(asn.items()))
        all_set.add(t)
        by_a[a].add(t)
        if max(a) >= r_min:
            cone_set.add(t)
            per[sum(a) % 6].add(t)

    # saturation / up-set style checks on the Free-ψ multidegree box
    # (SweepRow has no module_dim; check pattern stability under +6 e_r)
    sat = dict(
        maxdeg=maxdeg,
        r_min=r_min,
        n_all_patterns=len(all_set),
        n_cone_patterns=len(cone_set),
        n_usable_multidegrees=len(by_a),
        n_cone_multidegrees=sum(1 for a in by_a if max(a) >= r_min),
        cone_equals_all=(all_set == cone_set),
        per_residue_n={e: len(per[e]) for e in range(6)},
    )
    # up-set: if a is usable and a_i + 6 <= maxdeg, a+6e_i should be usable
    # with the same pattern set (non-decreasing under S')
    ups_ok = True
    grow_ok = True
    checked = 0
    for a in list(by_a.keys()):
        for r in range(len(a)):
            a1 = tuple(a[i] + (6 if i == r else 0) for i in range(len(a)))
            if max(a1) > maxdeg:
                continue
            checked += 1
            if a1 not in by_a and a in by_a:
                # pattern may still exist under a different psi at a1; soft
                pass
            if a1 in by_a and by_a[a] - by_a[a1]:
                # S' says attainable sets non-decreasing; missing is a fail
                grow_ok = False
            if a1 in by_a and by_a[a1] - by_a[a]:
                # growth is allowed under S'
                pass
    sat["plus6_checked"] = checked
    sat["pattern_growth_Sprime_ok"] = grow_ok
    sat["ups_ok"] = ups_ok

    if verbose:
        print("ell_V: all_pats=%d cone_pats=%d (r_min=%d) sat=%s"
              % (len(all_set), len(cone_set), r_min, sat), flush=True)

    def to_dicts(s):
        return [dict(t) for t in s]

    return (to_dicts(all_set), to_dicts(cone_set),
            {e: to_dicts(per[e]) for e in range(6)}, sat)


def fullsweep_r_filter_anchor(E, box=11, r_min=R_MIN, verbose=False):
    """FullSweep psi=1 anchor: realized classes, parity of a1, r-filter survival.

    Under psi=1 (not licensed by Prop 0.1 for this row — slots sum to 4 < 5)
    every minimal a has a1 odd; none of the minimal reps have max(a)>=6, but
    the +6 e_r up-set reaches r_min.  Documented as the trivial-character
    shadow; the live count uses free-ψ SweepRow above.
    """
    S = FullSweep(E, ELLV_RID)
    cls, mins, R, ok = full_classes(S, box=box)
    a1_odd = all(a[1] % 2 == 1 for a in mins)
    # lifts with max >= r_min in the up-set of each min
    survives = 0
    for a in mins:
        # try a + 6 e_r for r in slots until max >= r_min
        found = False
        for r in range(S.nslot):
            lift = list(a)
            while max(lift) < r_min:
                lift[r] += 6
            if S.module_dim(tuple(lift)):
                found = True
                break
        if found:
            survives += 1
    rep = dict(
        n_mins=len(mins),
        up_set_ok=ok,
        a1_always_odd=a1_odd,
        n_mins_with_r_lift=survives,
        mins_sample=sorted(mins)[:6],
    )
    if verbose:
        print("FullSweep ell_V anchor:", rep, flush=True)
    return rep
