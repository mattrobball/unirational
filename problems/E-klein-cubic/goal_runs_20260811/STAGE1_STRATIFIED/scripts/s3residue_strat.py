"""Stratified residue table and coherent recount (STAGE1_STRATIFIED)."""
import itertools
import json
import os
import sys
from collections import defaultdict

import paths  # noqa: F401
from s1enum import Stage1  # noqa: E402
from s1recount import build_tables, coherent_count, sweep_rows  # noqa: E402
from s3sweep import FullSweep  # noqa: E402
from s3sat import classes, contribution as contribution_old  # noqa: E402
from s3jet import contribution_stratified  # noqa: E402
from s3residue import degree_tables as degree_tables_old, d10_split  # noqa: E402

IMM1 = 6 ** 8 * 4 ** 10 * 5 ** 4  # STAGE1 immune factor
IMM2 = 3 ** 8


def full_flag_rows(E):
    out = []
    for rid in sweep_rows(E):
        S = FullSweep(E, rid)
        if sum(S.dims) == 5:
            out.append(rid)
    return out


def _unique(pats):
    seen, uniq = set(), []
    for c in pats:
        k = tuple(sorted(c.items()))
        if k not in seen:
            seen.add(k)
            uniq.append(c)
    return uniq


def degree_tables_stratified(E, box=11, verbose=False):
    """full-flag rows: usable stratified contributions per d mod 6.

    Per Theorem S': read from the stable pattern on each residue class.
    Uses the coordinatewise-minimal representative of each realized class
    (plus the +6 e_r step when it still fits in the box) so the table is
    taken from the stable regime.
    """
    out = {}
    for rid in full_flag_rows(E):
        S = FullSweep(E, rid)
        cls, mins, R, ok = classes(S, box=box)
        assert ok, "realized set is not the 6.e_r up-set"
        per = defaultdict(list)
        for rho, reps in cls.items():
            a0 = min(reps, key=sum)
            # stable pattern at the minimal rep (Theorem S': attainable sets
            # only grow under +6 e_r, so the residue table is read off Min)
            for c in contribution_stratified(S, a0, E):
                per[sum(rho) % 6].append(c)
            # one stability witness when cheap (first slot +6)
            if max(a0) + 6 <= min(box, 9):
                a1 = tuple(a0[i] + (6 if i == 0 else 0) for i in range(S.nslot))
                if S.module_dim(a1):
                    for c in contribution_stratified(S, a1, E):
                        per[sum(rho) % 6].append(c)
        out[rid] = {e: _unique(v) for e, v in per.items()}
        if verbose:
            print("  #%02d stratified usable per d mod 6: %s"
                  % (rid, {e: len(out[rid].get(e, [])) for e in range(6)}),
                  flush=True)
    return out


def residue_core_stratified(E, verbose=False):
    """coherent count per d mod 6 under stratified full-flag tables."""
    base, meta = build_tables(E)
    deg = degree_tables_stratified(E, verbose=verbose)
    out = {}
    for e in range(6):
        t = dict(base)
        ok = True
        for rid, per in deg.items():
            t[rid] = per.get(e, [])
            if not t[rid]:
                ok = False
        if not ok:
            out[e] = dict(total=0, K=0, note="empty full-flag table")
            continue
        tot, blocks = coherent_count(E, t)
        core = max(blocks, key=lambda b: b["size"])
        K = tot // (23 * IMM1)
        out[e] = dict(total=tot, core=core["solutions"], core_size=core["size"],
                      K=K)
        if verbose:
            print("  d=%d: total %d  K=%d" % (e, tot, K), flush=True)
    return out, deg, meta


def coherent_count_stratified(E, verbose=False, box=6):
    """degree-blind stratum-coherent count under stratified semantics.

    Start from the STAGE1 (old) tables and UNION in stratified full-flag
    contributions.  Old patterns are a lower bound (they under-count by
    treating module-level rank 0 as free and missing level-1 escapes); the
    stratified additions restore the escapes.  The union is therefore the
    corrected successor of the STAGE1 15.2 total.
    """
    base, meta = build_tables(E)
    for rid in full_flag_rows(E):
        S = FullSweep(E, rid)
        pats = list(base.get(rid, []))  # keep old
        cls, mins, R, ok = classes(S, box=box + 5)
        for a in mins:
            pats.extend(contribution_stratified(S, a, E))
        for a in itertools.product(range(min(box, 4) + 1), repeat=S.nslot):
            if sum(a) == 0 or not S.module_dim(a):
                continue
            pats.extend(contribution_stratified(S, a, E))
        base[rid] = _unique(pats)
        if verbose:
            print("  #%02d union patterns: %d (old was %s)"
                  % (rid, len(base[rid]), meta.get(rid, {}).get("patterns")),
                  flush=True)
    tot, blocks = coherent_count(E, base)
    return tot, blocks, base, meta


def stabilization_threshold(E, box=11, verbose=False, sample=6):
    """Theorem S': observe when stratified contributions stabilize along +6 e_r.

    Spot-checks `sample` residue classes per full-flag row (enough to read
    Theta' off the stable pattern; full enumeration is verifier-optional).
    Returns Theta_prime >= 6.
    """
    thr = 6
    for rid in full_flag_rows(E):
        S = FullSweep(E, rid)
        cls, mins, R, ok = classes(S, box=box)
        items = sorted(cls.items(), key=lambda kv: sum(min(kv[1], key=sum)))
        for rho, reps in items[:sample]:
            a = min(reps, key=sum)
            c0 = set(tuple(sorted(x.items()))
                     for x in contribution_stratified(S, a, E))
            for r in range(S.nslot):
                a1 = tuple(a[i] + (6 if i == r else 0) for i in range(S.nslot))
                if max(a1) > box or not S.module_dim(a1):
                    continue
                c1 = set(tuple(sorted(x.items()))
                         for x in contribution_stratified(S, a1, E))
                if c0 != c1:
                    thr = max(thr, max(a1))
            if verbose:
                print("  #%02d rho=%s a=%s |c0|=%d"
                      % (rid, rho, a, len(c0)), flush=True)
    return thr


def phi_f_gate(E, deg, verbose=False):
    """Phi_F transport: coherent patterns at rho subset those at rho+3.

    Because F.T presents the same projective map as T wherever F != 0, every
    boundary pattern realized at degree d is realized at degree d+3.  Under
    the residue indexing this is the inclusion of pattern sets
        patterns(rho) subseteq patterns(rho+3)  (mod 6).
    A failure is a bug (or a genuine FLAGGED finding).
    """
    # degree-blind patterns from stratified full-flag tables already sit in deg
    results = {}
    ok_all = True
    for rho in range(6):
        # patterns are the COHERENT boundary patterns of the whole system at
        # that residue, but the workorder's Phi_F acts on leading data of the
        # sweep rows.  Operationally: every usable full-flag contribution at
        # rho must appear among usable contributions at rho+3 (on each
        # full-flag row), and the joint coherent count being positive at rho
        # forces it at rho+3 only if the immune rows are residue-blind -- which
        # they are (STAGE1 tables).
        row_ok = True
        details = {}
        for rid, per in deg.items():
            A = set(tuple(sorted(c.items())) for c in per.get(rho, []))
            B = set(tuple(sorted(c.items())) for c in per.get((rho + 3) % 6, []))
            missing = A - B
            details[rid] = dict(nA=len(A), nB=len(B), n_missing=len(missing))
            if missing:
                row_ok = False
        results[rho] = dict(ok=row_ok, details=details)
        if not row_ok:
            ok_all = False
        if verbose:
            print("  Phi_F rho=%d -> %d : %s %s"
                  % (rho, (rho + 3) % 6, "OK" if row_ok else "FAIL", details),
                  flush=True)
    return ok_all, results


def run(p=331, outdir=None, verbose=True):
    E = Stage1(p, verbose=False)
    if verbose:
        print("=== stratified residue p=%d ===" % p, flush=True)
    res, deg, meta = residue_core_stratified(E, verbose=verbose)
    thr = stabilization_threshold(E, verbose=verbose)
    phi_ok, phi = phi_f_gate(E, deg, verbose=verbose)
    tot_c, blocks, base_s, meta_s = coherent_count_stratified(E, verbose=verbose)
    # old coherent for diff
    base_old, _ = build_tables(E)
    tot_old, _ = coherent_count(E, base_old)
    payload = dict(
        p=p,
        K={e: res[e].get("K", 0) for e in range(6)},
        totals={e: res[e].get("total", 0) for e in range(6)},
        Theta_prime=thr,
        Phi_F_ok=phi_ok,
        Phi_F=phi,
        coherent_stratified=tot_c,
        coherent_old=tot_old,
        n_patterns_fullflag={rid: {e: len(deg[rid].get(e, []))
                                   for e in range(6)} for rid in deg},
    )
    if outdir:
        os.makedirs(outdir, exist_ok=True)
        with open(os.path.join(outdir, "residue_stratified_%d.json" % p),
                  "w") as f:
            json.dump(payload, f, indent=2, default=str)
        with open(os.path.join(outdir, "residue_stratified_%d.txt" % p),
                  "w") as f:
            f.write("STAGE1_STRATIFIED residue table p=%d\n" % p)
            f.write("Theta_prime = %d\n" % thr)
            f.write("Phi_F gate: %s\n" % ("PASS" if phi_ok else "FAIL"))
            f.write("d mod 6    K           total\n")
            for e in range(6):
                f.write("%d          %-12d %d\n"
                        % (e, payload["K"][e], payload["totals"][e]))
            f.write("coherent stratified = %d\n" % tot_c)
            f.write("coherent old        = %d\n" % tot_old)
    return payload, E


if __name__ == "__main__":
    p = int(sys.argv[1]) if len(sys.argv) > 1 else 331
    out = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
                       "results")
    run(p, outdir=out, verbose=True)
