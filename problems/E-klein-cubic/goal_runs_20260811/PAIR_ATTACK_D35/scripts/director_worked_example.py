#!/usr/bin/env python3
"""Director worked example (2026-08-11): the value layer, done concretely.

Stage A (universal): the six forced flip conditions at d = 35.
  At the residue of 35 every coherent m = 1 pattern flips the six
  V4-children over the type-I plus-plane points (ODDZERO: at odd d the
  level-0 value is the forbidden vertex).  Flipping child j means the
  level-0 evaluation vanishes: lambda_j(T) = 0 -- ONE linear condition per
  child, because Theorem 15.1 rigidity confines the value to a line.
  This script constructs the six attaching pairs from scratch (three
  V4-groups through one involution z, joint eigenspaces), extracts the
  bidegree-(34,1) leading datum of every basis covariant of M_35 by
  polarization (jet_rows, t^1 block along the line w + t*y), and imposes
  the six functionals on the sealed 39-dim Layer-0 slice.

  Machine anchors, all fatal if violated:
   R1 (rigidity / frame correctness): for ALL 637 basis covariants and all
      six children, the W^-_z-component transverse to the character line
      vanishes identically.                       [637 x 6 zeros, per prime]
   R2 (profile): on the 39-dim slice the W^+_z-components of the (34,1)
      datum vanish at the six children (the ladder's (P+) cut).
   R3 (sealed corank): the six functionals factor through V((34,1),1),
      where their joint rank is exactly 2 (ODDZERO F1); so their AMBIENT
      rank on M_35 is <= 2.

Stage B (one pair, end to end): pattern id 0 of patterns_r5_p331.json.
  Port its D_{P_sigma} child assignments through the STAGE1_TIGHTEN
  FullSweep frame (whose W^- basis is stored in Klein coordinates -- the
  frame alignment), identify its flip-set (assigned value != level-0
  value), impose those functionals on the slice, and decide the cell:
  dim of the closed cut, and the keep-children nonvanishing check.

Usage: python3 director_worked_example.py [p]
"""
import json
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import paths  # noqa: E402  (installs D34 / STRAT / TIGHTEN on sys.path)
import slicelib as SL  # noqa: E402

PACKET = os.path.dirname(HERE)
RES = os.path.join(PACKET, "results")
DEG = 35


def rref_basis(M, p):
    """Row-reduce M mod p; return (rank, basis rows)."""
    M = np.array(M, dtype=np.int64) % p
    r = SL.rref_rank(M, p)
    return r


def nullspace_rows(M, p):
    return SL.nullspace(np.array(M, dtype=np.int64) % p, p)


def eig_split(Ms, p, signs):
    """Joint eigenspace of the commuting involutions Ms for the sign vector."""
    I5 = np.eye(5, dtype=np.int64)
    B = I5.copy()
    for M, s in zip(Ms, signs):
        rows = nullspace_rows((M - (s % p) * I5) % p, p)  # right-null of M - sI
        # intersect span(B) with span(rows): solve B stacked
        # represent both as row-spans; intersection via nullspace trick
        # x in both spans: x = a@B = b@rows
        big = np.concatenate([B, (-rows) % p], axis=0)
        ker = nullspace_rows(big.T % p, p)   # combos (a|b) with a@B - b@rows=0
        if ker.shape[0] == 0:
            return np.zeros((0, 5), dtype=np.int64)
        B = (ker[:, :B.shape[0]] @ B) % p
        # re-reduce to a basis
        keep = []
        for v in B:
            test = np.array(keep + [v], dtype=np.int64)
            if SL.rref_rank(test % p, p) == len(keep) + 1:
                keep.append(v % p)
        B = np.array(keep, dtype=np.int64) if keep else np.zeros((0, 5),
                                                                 dtype=np.int64)
    return B % p


def build_v4_children(fr, p, verbose=True):
    """Three V4s through z; per K the lines B, C, D; six attaching pairs."""
    RHO, orders = fr["RHO"], fr["orders"]
    I5 = np.eye(5, dtype=np.int64)

    invs = [g for g in range(660) if orders[g] == 2]
    z = None
    # pick z = an involution with >= 2 commuting partner involutions
    for cand in invs:
        Z = RHO[cand] % p
        partners = [h for h in invs if h != cand and
                    np.array_equal((RHO[h] @ Z) % p, (Z @ RHO[h]) % p)]
        if len(partners) >= 4:
            z, plist = cand, partners
            break
    assert z is not None, "no involution with a V4-rich centralizer found"
    Z = RHO[z] % p
    assert np.array_equal((Z @ Z) % p, I5), "rep not honest on z"

    # group partners into K = {z, s, zs}
    Ks, used = [], set()
    for s in plist:
        if s in used:
            continue
        ZS = (Z @ RHO[s]) % p
        mate = [h for h in plist if np.array_equal(RHO[h] % p, ZS)]
        assert len(mate) == 1, "zs not in partner list"
        used.update({s, mate[0]})
        Ks.append((s, mate[0]))
    if verbose:
        print("z = g%d; V4 partners paired into %d Kleins" % (z, len(Ks)))
    assert len(Ks) == 3, "expected exactly three V4s through z, got %d" % len(Ks)

    Wplus = nullspace_rows((Z - I5) % p, p)      # 3-dim
    Wminus = nullspace_rows((Z + I5) % p, p)     # 2-dim
    assert Wplus.shape[0] == 3 and Wminus.shape[0] == 2

    children = []
    for (s, zs) in Ks:
        Sm = RHO[s] % p
        Apl = eig_split([Z, Sm], p, [1, 1])
        Bln = eig_split([Z, Sm], p, [1, -1])
        Cln = eig_split([Z, Sm], p, [-1, 1])
        Dln = eig_split([Z, Sm], p, [-1, -1])
        assert (Apl.shape[0], Bln.shape[0], Cln.shape[0], Dln.shape[0]) \
            == (2, 1, 1, 1), "character decomposition dims wrong"
        # two children over [B]: attach along C and along D
        for (y, yperp, tag) in ((Cln[0], Dln[0], "C"), (Dln[0], Cln[0], "D")):
            children.append({
                "K": (z, s, zs), "w": Bln[0] % p, "y": y % p,
                "yperp": yperp % p, "tag": tag,
            })
    assert len(children) == 6
    return z, Z, Wplus, Wminus, children


def inv_mod(M, p):
    """Inverse of a square matrix mod p by Gauss-Jordan."""
    n = M.shape[0]
    A = np.concatenate([M % p, np.eye(n, dtype=np.int64)], axis=1) % p
    r = 0
    for c in range(n):
        piv = None
        for i in range(r, n):
            if A[i, c] % p:
                piv = i
                break
        assert piv is not None, "singular matrix"
        A[[r, piv]] = A[[piv, r]]
        A[r] = (A[r] * pow(int(A[r, c]), p - 2, p)) % p
        for i in range(n):
            if i != r and A[i, c] % p:
                A[i] = (A[i] - A[i, c] * A[r]) % p
        r += 1
    return A[:, n:] % p


def child_basis_inv(kid, wplus, p):
    """Inverse of the basis matrix [y-line, yperp-line, wplus] as rows,
    so that components = val @ Binv gives (c_y, c_yperp, c_plus...)."""
    Bmat = np.concatenate([kid["y"][None, :], kid["yperp"][None, :],
                           wplus], axis=0) % p
    return inv_mod(Bmat.T % p, p)   # solves x @ Bmat = val via val @ (Bmat^T)^{-1}... see note

# note: x @ Bmat = val  <=>  Bmat^T @ x^T = val^T  <=>  x = val @ (Bmat^T)^{-1 T}
# We use components(val) = (inv(Bmat^T) @ val^T)^T = val @ inv(Bmat^T).T;
# implemented below by comp = VAL @ CINV where CINV = inv(Bmat^T).T.


def main(p):
    print("== director worked example, p =", p)
    fr = SL.build_frame(p, verbose=False)
    # seed exponents/components are prime-independent (deterministic
    # seed_exponents order); the worker saved them once, at p = 331
    A6 = np.load(os.path.join(RES, "layer0_A_p331.npy"))
    C6 = np.load(os.path.join(RES, "layer0_C_p331.npy"))
    NUL = np.load(os.path.join(RES, "layer0_null_p%d.npy" % p)) % p
    ns, nsl = A6.shape[0], NUL.shape[0]
    assert (ns, nsl) == (637, 39)

    z, Z, Wplus, Wminus, kids6 = build_v4_children(fr, p)

    Wmat = np.array([k["w"] for k in kids6], dtype=np.int64) % p
    Ymat = np.array([k["y"] for k in kids6], dtype=np.int64) % p
    JR = SL.jet_rows(fr, A6, C6, Wmat, Ymat, 2, deg=DEG)   # (637,6,5,2)
    VAL = JR[:, :, :, 1] % p                               # t^1 block

    # R1: rigidity -- transverse W^- component vanishes for ALL seeds
    lam_amb = np.zeros((ns, 6), dtype=np.int64)
    r1_bad = 0
    CINVS = []
    for j, kid in enumerate(kids6):
        Bmat = np.concatenate([kid["y"][None, :], kid["yperp"][None, :],
                               Wplus], axis=0) % p
        CINV = inv_mod(Bmat.T % p, p).T % p      # comp = val @ CINV
        CINVS.append(CINV)
        comp = (VAL[:, j, :] @ CINV) % p         # (637, 5)
        lam_amb[:, j] = comp[:, 0]
        r1_bad += int(np.count_nonzero(comp[:, 1] % p))
    print("R1 rigidity zeros: %d violations of %d checks"
          % (r1_bad, ns * 6))
    assert r1_bad == 0, "R1 FAILED: frame or extraction wrong"

    # R3: ambient rank of the six functionals is <= 2 (sealed F1 corank)
    r_amb = SL.rref_rank(lam_amb.T % p, p)
    print("R3 ambient rank of six functionals on M_35:", r_amb, "(sealed <= 2)")
    assert r_amb <= 2, "R3 FAILED: functionals do not factor through V((34,1),1)"

    # R2: on the slice, W^+ components vanish at the six children
    r2_bad = 0
    SLICE_VAL = np.einsum('ks,sjc->kjc', NUL % p, VAL) % p   # (39,6,5)
    for j in range(6):
        comp = (SLICE_VAL[:, j, :] @ CINVS[j]) % p           # (39, 5)
        r2_bad += int(np.count_nonzero(comp[:, 2:] % p))
    print("R2 profile zeros on slice: %d violations of %d checks"
          % (r2_bad, nsl * 6 * 3))
    assert r2_bad == 0, "R2 FAILED: (P+) cut not active on slice"

    # Universal cut: rank of the six functionals ON THE SLICE
    LAM_SLICE = (NUL % p) @ (lam_amb % p) % p            # (39, 6)
    r6 = SL.rref_rank(LAM_SLICE.T % p, p)
    dim_univ = nsl - r6
    print("UNIVERSAL: rank of six flip functionals on slice = %d "
          "-> every live m=1 cell has dim <= %d" % (r6, dim_univ))

    # ---- Stage B: pattern id 0, D_{P_sigma} row, full assignment ----
    import s3sweep  # TIGHTEN machinery (paths put it on sys.path)
    patt = json.load(open(os.path.join(
        RES, "patterns_r5_p%d.json" % p)))["patterns"][0]
    out = {
        "p": p, "z": int(z), "r1_checks": ns * 6, "r3_ambient_rank": int(r_amb),
        "r6_slice_rank": int(r6), "dim_universal": int(dim_univ),
        "pattern_id": patt["id"], "pattern_hash": patt["hash"],
    }

    from s1enum import Stage1
    from patterns_r5 import build_tagged_ff_tables
    E = Stage1(p)
    S1 = s3sweep.FullSweep(E, 1)              # rid 1 = D_{P_sigma}

    # A0: TIGHTEN's sigma matrix must belong to the D34 frame's matrix group
    # (same realization of W over F_p; sig is stored as the matrix itself)
    Z1 = np.array(S1.sig, dtype=np.int64) % p
    hits = [i for i in range(660)
            if np.array_equal(fr["RHO"][i] % p, Z1)]
    assert hits, "A0 FAILED: TIGHTEN and D34 use different realizations"
    print("A0: TIGHTEN sigma = D34 group element g%d (same realization)"
          % hits[0])
    inv2 = pow(2, p - 2, p)
    Pminus = ((np.eye(5, dtype=np.int64) - Z1) * inv2) % p
    Wp1 = nullspace_rows((Z1 - np.eye(5, dtype=np.int64)) % p, p)  # 3-dim
    assert Wp1.shape[0] == 3

    a35 = tuple(patt["targets_meta"][0]["a35"])          # (34, 1)
    idx1 = patt["targets_meta"][0]["idx"]
    _plain, tagged = build_tagged_ff_tables(E)
    entry = tagged[1][idx1]
    # entry-identity anchors: the rebuilt table entry must be the one the
    # pattern references (same class data; index listed as compatible)
    assert idx1 in patt["compat_ff"]["1"], "entry index not compatible"
    assert list(entry.get("a35", a35)) == list(a35), "a35 mismatch"
    assert entry.get("m_or_nu", patt["targets_meta"][0]["m_or_nu"]) \
        == patt["targets_meta"][0]["m_or_nu"], "m mismatch"
    assign = entry["assign"]                             # {row_id: label}
    assign = {int(k): tuple(v) if isinstance(v, list) else v
              for k, v in assign.items()}

    comp0 = np.array(S1.slots[0][2], dtype=np.int64) % p   # W^+ basis (3x5)
    comp1 = np.array(S1.slots[1][2], dtype=np.int64) % p   # complement (2x5)

    flips, keeps, skipped = [], [], 0
    for kid in S1.kids:
        r0 = kid["row"]
        if r0 not in assign:
            continue
        U0 = S1.value(a35, kid, None)
        if U0 is None or kid.get("mu") is None:
            skipped += 1
            continue
        lab0 = S1.own_frame(kid, U0)
        if lab0 is None:
            skipped += 1
            continue
        # attaching pair in Klein coordinates
        q0 = np.array(kid["qs"][0][0], dtype=np.int64) % p
        q1 = np.array(kid["qs"][1][0], dtype=np.int64) % p
        w = (q0 @ comp0) % p
        y = ((q1 @ comp1) @ Pminus.T) % p
        if not np.any(y % p):
            skipped += 1
            continue
        # transverse line inside W^-: the other eigenline if available
        def vec5(U):
            a = np.array(U, dtype=np.int64).reshape(-1) % p
            assert a.size == 5, "eigenline is not a single 5-vector"
            return a
        U0v = vec5(U0)
        others = [vec5(U) for (_chi, U) in kid["lines"]
                  if not np.array_equal(vec5(U), U0v)]
        if not others:
            skipped += 1
            continue
        rec = dict(kid_idx=kid["idx"], row=r0, w=w, y=y,
                   U0=U0v, Ut=others[0],
                   assigned=assign[r0], lab0=lab0)
        if assign[r0] == lab0:
            keeps.append(rec)
        else:
            flips.append(rec)

    print("Stage B: pattern 0 row-1: %d flips, %d keeps, %d skipped "
          "(of %d assigned rows)" % (len(flips), len(keeps), skipped,
                                     len(assign)))

    def functionals(recs):
        if not recs:
            return np.zeros((ns, 0), dtype=np.int64), 0
        Wm_ = np.array([r["w"] for r in recs], dtype=np.int64) % p
        Ym_ = np.array([r["y"] for r in recs], dtype=np.int64) % p
        J2 = SL.jet_rows(fr, A6, C6, Wm_, Ym_, 2, deg=DEG)[:, :, :, 1] % p
        lam = np.zeros((ns, len(recs)), dtype=np.int64)
        rig_bad = 0
        for j, r in enumerate(recs):
            Bmat = np.concatenate([r["U0"][None, :], r["Ut"][None, :],
                                   Wp1], axis=0) % p
            CINV = inv_mod(Bmat.T % p, p).T % p
            comp = (J2[:, j, :] @ CINV) % p
            lam[:, j] = comp[:, 0]
            rig_bad += int(np.count_nonzero(comp[:, 1] % p))
        return lam, rig_bad

    lam_flip, rb1 = functionals(flips)
    lam_keep, rb2 = functionals(keeps)
    print("Stage B rigidity: %d violations of %d checks"
          % (rb1 + rb2, ns * (len(flips) + len(keeps))))
    assert rb1 + rb2 == 0, "Stage-B rigidity FAILED"

    # DIAGNOSTIC: keep functionals that vanish on the WHOLE slice (before
    # any pattern cut) -- such a row's level-0 value is unattainable by any
    # slice element, killing EVERY pattern that keeps it.
    KP = ((NUL % p) @ lam_keep) % p if keeps else np.zeros((nsl, 0))
    keep_zero_slice = [int(keeps[j]["kid_idx"]) for j in range(len(keeps))
                       if not np.any(KP[:, j] % p)]
    print("DIAGNOSTIC: %d of %d keep functionals vanish on the WHOLE "
          "39-slice" % (len(keep_zero_slice), len(keeps)))

    # combine with the universal six (independent frame) and cut the slice
    ALLF = np.concatenate([LAM_SLICE, (NUL % p) @ lam_flip % p], axis=1)
    r_all = SL.rref_rank(ALLF.T % p, p)
    dim_cell = nsl - r_all
    print("CELL: universal(6) + pattern flips(%d): rank %d on slice "
          "-> closed cell dim = %d" % (len(flips), r_all, dim_cell))

    verdict = "LIVE"
    dead_keep = []
    if dim_cell == 0:
        verdict = "DEAD (closed cut empty)"
    else:
        # basis of the closed cut S_r inside the slice:
        # rows x with x @ ALLF = 0, i.e. right-null of ALLF^T
        KB = SL.nullspace(ALLF.T % p, p) % p   # (dim_cell, 39)
        assert KB.shape == (dim_cell, nsl)
        LK = (KB @ ((NUL % p) @ lam_keep % p)) % p if keeps else None
        if keeps:
            for j, r in enumerate(keeps):
                if not np.any(LK[:, j] % p):
                    dead_keep.append(int(r["kid_idx"]))
            if dead_keep:
                verdict = ("DEAD (keep-functional identically zero on the "
                           "closed cut: kids %s)" % dead_keep)
    print("VERDICT for pattern 0 (row-1 layer):", verdict)

    # ---- Stage C: the pattern-independent vanishing census, all kids, ----
    # ---- then the label sweep over ALL 756 stored patterns.          ----
    allrecs = []
    for kid in S1.kids:
        U0 = S1.value(a35, kid, None)
        if U0 is None or kid.get("mu") is None:
            continue
        lab0 = S1.own_frame(kid, U0)
        if lab0 is None:
            continue
        q0 = np.array(kid["qs"][0][0], dtype=np.int64) % p
        q1 = np.array(kid["qs"][1][0], dtype=np.int64) % p
        w = (q0 @ comp0) % p
        y = ((q1 @ comp1) @ Pminus.T) % p
        if not np.any(y % p):
            continue

        def vec5c(U):
            aa = np.array(U, dtype=np.int64).reshape(-1) % p
            return aa
        U0v = vec5c(U0)
        others = [vec5c(U) for (_chi, U) in kid["lines"]
                  if not np.array_equal(vec5c(U), U0v)]
        if not others:
            continue
        allrecs.append(dict(kid_idx=kid["idx"], row=kid["row"], w=w, y=y,
                            U0=U0v, Ut=others[0], lab0=lab0))
    lam_all, rb3 = functionals(allrecs)
    assert rb3 == 0, "Stage-C rigidity FAILED"
    KALL = ((NUL % p) @ lam_all) % p
    zero_on_slice = {}
    lab0_by_row = {}
    for j, r in enumerate(allrecs):
        zero_on_slice.setdefault(r["row"], []).append(
            not bool(np.any(KALL[:, j] % p)))
        lab0_by_row[r["row"]] = r["lab0"]
    dead_rows = sorted(r0 for r0, zs in zero_on_slice.items() if all(zs))
    print("Stage C: %d of %d value-defined rows have level-0 unattainable "
          "on the whole slice (forced deeper): %s"
          % (len(dead_rows), len(zero_on_slice), dead_rows))

    # sweep all 756 stored patterns: dead if any assigned row keeps a
    # forced-deeper row at its level-0 label
    pats = json.load(open(os.path.join(
        RES, "patterns_r5_p%d.json" % p)))["patterns"]
    n_dead_m35 = n_dead_value = n_alive = 0
    dead_ids, alive_ids = [], []
    for pt in pats:
        if pt["min_m"] != 1:
            n_dead_m35 += 1
            continue
        idx = pt["targets_meta"][0]["idx"]
        asg = tagged[1][idx]["assign"]
        asg = {int(k): tuple(v) if isinstance(v, list) else v
               for k, v in asg.items()}
        dead = any(r0 in dead_rows and asg[r0] == lab0_by_row.get(r0)
                   for r0 in asg)
        if dead:
            n_dead_value += 1
            dead_ids.append(pt["id"])
        else:
            n_alive += 1
            alive_ids.append(pt["id"])
    print("Stage C census over 756 stored patterns: %d dead by multidegree, "
          "%d dead by unattainable level-0 keeps, %d still alive (row-1 "
          "layer only)" % (n_dead_m35, n_dead_value, n_alive))

    out.update({
        "stage_b": "ok", "a35": list(a35), "n_flips": len(flips),
        "n_keeps": len(keeps), "n_skipped": skipped,
        "n_keep_zero_on_whole_slice": len(keep_zero_slice),
        "keep_zero_on_whole_slice": keep_zero_slice,
        "stage_c_rows_defined": len(zero_on_slice),
        "stage_c_forced_deeper_rows": [int(x) for x in dead_rows],
        "census_dead_multidegree": n_dead_m35,
        "census_dead_value_keep": n_dead_value,
        "census_alive_row1_layer": n_alive,
        "census_alive_ids": alive_ids[:60],
        "nondeterminism_flag": ("tagged-table rebuild is run-dependent; "
                                "pattern->entry linkage via idx is fragile; "
                                "census valid for THIS rebuild (see writeup)"),
        "universal_matrix_6x39": (LAM_SLICE.T % p).tolist(),
        "rank_univ_plus_flips": int(r_all), "dim_cell_closed": int(dim_cell),
        "dead_keep_kids": dead_keep, "verdict_row1": verdict,
        "flip_kids": [int(r["kid_idx"]) for r in flips],
        "keep_kids": [int(r["kid_idx"]) for r in keeps],
    })
    with open(os.path.join(RES, "worked_example_p%d.json" % p), "w") as f:
        json.dump(out, f, indent=1)
    print(json.dumps(out, indent=1))
    return out


if __name__ == "__main__":
    main(int(sys.argv[1]) if len(sys.argv) > 1 else 331)
