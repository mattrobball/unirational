"""Experiment B -- the 55 Menelaus axes at generic and at special source points."""
import json
import os
import sys
import time

import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import movelib as ML
from movelib import check, note, Fv, chord, rand_pt, norm_pt

ROOT = ML.ROOT
p = 67
t0 = time.time()
rng = np.random.default_rng(4242)
S = ML.Setup(p)
n = 55


def axes_at(v):
    """Return per-V4 axis data at source v."""
    out = []
    prj = []
    for t in range(n):
        w = S.proj[t] @ v % p
        prj.append(w if w.any() else None)
    for t, (i, j, k) in enumerate(S.v4):
        pts = [prj[i], prj[j], prj[k]]
        if any(q is None for q in pts):
            out.append({"status": "proj_undefined"})
            continue
        cs = []
        for (a, b) in ((1, 2), (2, 0), (0, 1)):
            c = chord(pts[a], pts[b], p)
            cs.append(c)
        if any(c is None for c in cs):
            out.append({"status": "chord_undefined",
                        "ndef": sum(c is not None for c in cs)})
            continue
        M = np.array(cs, dtype=np.int64) % p
        r = ML.rank_p(M, p)
        keys = sorted({norm_pt(c, p) for c in cs})
        out.append({"status": "ok", "rank": r, "ndistinct_pts": len(keys),
                    "pts": [list(map(int, c)) for c in cs]})
    return out, prj


def line_of(ax):
    M = np.array(ax["pts"], dtype=np.int64) % p
    R, piv = ML.rref(M, p)
    return R[:2]


def summarize(v, label):
    ax, prj = axes_at(v)
    ok = [a for a in ax if a["status"] == "ok"]
    rk2 = [a for a in ok if a["rank"] == 2]
    rk1 = [a for a in ok if a["rank"] == 1]
    rk3 = [a for a in ok if a["rank"] == 3]
    bases = [line_of(a) for a in rk2]
    plks = [ML.plucker(b[0], b[1], p) for b in bases]
    prank = ML.rank_p(np.array(plks, dtype=np.int64), p) if plks else 0
    # distinct axes
    axkeys = {tuple(map(int, (pl * pow(int(pl[np.nonzero(pl)[0][0]]), p - 2, p)) % p))
              for pl in plks}
    # pairwise meets
    meets = 0
    for a in range(len(bases)):
        for b in range(a + 1, len(bases)):
            if ML.rank_p(np.concatenate([bases[a], bases[b]]), p) <= 3:
                meets += 1
    # incidences of the axis LINES with the canonical loci
    in_plusplane = 0
    thru_vertex = 0
    axis_pts_on_lines = 0
    npts = 0
    for a in rk2:
        B = line_of(a)
        for q in range(55):
            if not (S.Pcut[q] @ B.T % p).any():
                in_plusplane += 1
                break
        for c in a["pts"]:
            npts += 1
            x = np.array(c, dtype=np.int64)
            if S.on_line(x):
                axis_pts_on_lines += 1
            if S.is_vertex(x):
                thru_vertex += 1
    ent = {"label": label, "v": [int(t) for t in v],
           "proj_undefined": sum(1 for a in ax if a["status"] == "proj_undefined"),
           "chord_undefined": sum(1 for a in ax if a["status"] == "chord_undefined"),
           "axes_ok": len(ok), "rank2": len(rk2), "rank1_collapsed": len(rk1),
           "rank3_noncollinear": len(rk3), "distinct_axes": len(axkeys),
           "plucker_rank": int(prank), "meeting_axis_pairs": meets,
           "axes_in_a_plusplane": in_plusplane,
           "axis_points_on_lines": [axis_pts_on_lines, npts],
           "axis_points_that_are_vertices": thru_vertex}
    print(ent, flush=True)
    return ent


# ------------------------------------------------------------- source points
def rand_on(pred, tries=200000):
    for _ in range(tries):
        v = rand_pt(rng, p)
        if pred(v):
            return v
    return None


sources = []
for t in range(3):
    sources.append(("generic", rand_pt(rng, p)))
for t in range(2):
    sources.append(("on_X", rand_on(lambda v: Fv(v, p) == 0)))
for t in range(2):
    sources.append(("on_VH_offX", rand_on(lambda v: S.Hval(v) == 0 and Fv(v, p) != 0)))
for t in range(2):
    q = int(rng.integers(0, 55))
    B = S.Pbas[q]
    sources.append(("in_plusplane_%d" % q,
                    (rng.integers(1, p) * B[0] + rng.integers(0, p) * B[1]
                     + rng.integers(0, p) * B[2]) % p))
for t in range(2):
    q = int(rng.integers(0, 55))
    B = S.Lbas[q]
    sources.append(("on_line_%d" % q,
                    (rng.integers(1, p) * B[0] + rng.integers(0, p) * B[1]) % p))
for t in range(2):
    sources.append(("vertex", np.array(S.vertices[int(rng.integers(0, 165))],
                                       dtype=np.int64)))
cpts = [x for x in S.Cpts]
sextet = [x for x in cpts if S.on_plusplane(x)]
note("hessian_sextet_Fp",
     "%d of the %d F_p-points of the Hessian curve C lie on a plus-plane "
     "(C cap P_sigma over F_67)" % (len(sextet), len(cpts)))
for t in range(2):
    sources.append(("Hcurve", cpts[int(rng.integers(0, len(cpts)))]))
if sextet:
    for t in range(min(2, len(sextet))):
        sources.append(("sextet", sextet[t]))

rows = [summarize(v, lab) for lab, v in sources if v is not None]

gen = [r for r in rows if r["label"] == "generic"]
check("axes_generic_rank10",
      all(r["plucker_rank"] == 10 for r in gen),
      "at generic v the 55 Menelaus axes have Plucker rank %s (max 10)"
      % [r["plucker_rank"] for r in gen])
# WHICH pairs of axes meet?  The 165 line-sharing triangle pairs have
# Pi_s cap Pi_t = L_i, so their two axes each meet L_i in one point and coincide
# there in codimension ONE -- unlike the 1320 other pairs (codimension two).
share = {(a, b) for a in range(n) for b in range(a + 1, n)
         if len(set(S.v4[a]) & set(S.v4[b])) == 1}
nmeet = nshare = 0
for _ in range(12):
    v = rand_pt(rng, p)
    bases = {}
    for t, (i, j, k) in enumerate(S.v4):
        q = [S.proj[m] @ v % p for m in (i, j, k)]
        cs = [chord(q[1], q[2], p), chord(q[2], q[0], p), chord(q[0], q[1], p)]
        if any(c is None for c in cs):
            continue
        R, piv = ML.rref(np.array(cs, dtype=np.int64) % p, p)
        if len(piv) == 2:
            bases[t] = R[:2]
    ks = sorted(bases)
    for a in range(len(ks)):
        for b in range(a + 1, len(ks)):
            if ML.rank_p(np.concatenate([bases[ks[a]], bases[ks[b]]]), p) <= 3:
                nmeet += 1
                nshare += ((ks[a], ks[b]) in share)
exp_share = 12 * 165.0 / p
exp_other = 12 * 1320.0 / p ** 2
check("axes_meet_only_via_shared_lines",
      nshare >= 0.9 * nmeet and abs((nmeet - nshare) - exp_other) < 4,
      "the brief expected NO two axes to meet at generic v; in fact %s pairs "
      "meet per source. Over 12 random v, %d of %d meets are between the 165 "
      "LINE-SHARING triangle pairs (Pi_s cap Pi_t = L_i: both axes cross L_i, "
      "coincidence is codim 1; %.1f/v observed vs the naive 165/p = 2.5/v, the "
      "excess coming from vertex-forced Menelaus points) and the residual %d among the "
      "other 1320 pairs matches the codim-2 rate 1320/p^2 (expected %.1f). "
      "So: no canonical axis incidence, only the shared-line codim-1 family."
      % ([r["meeting_axis_pairs"] for r in gen], nshare, nmeet, nshare / 12.0,
         nmeet - nshare, exp_other))
check("axis_points_on_lines_always",
      all(r["axis_points_on_lines"][0] == r["axis_points_on_lines"][1] for r in rows),
      "every well-defined axis point lies on a V4-line, at all %d source types"
      % len(rows))
drops = [(r["label"], r["plucker_rank"], r["meeting_axis_pairs"], r["rank1_collapsed"])
         for r in rows if r["plucker_rank"] < 10 or r["meeting_axis_pairs"] > 0
         or r["rank1_collapsed"] > 0]
check("axes_special_source_effects", True,
      "(label, Plucker rank, meeting pairs, collapsed axes) at special sources: %s"
      % (drops or "none -- rank 10 and no incidences at every tested source"))

json.dump({"p": p, "rows": rows, "sextet_points_Fp": len(sextet),
           "seconds": round(time.time() - t0, 1)},
          open(os.path.join(ROOT, "payload", "axes_table.json"), "w"), indent=1)
print("seconds", round(time.time() - t0, 1))
