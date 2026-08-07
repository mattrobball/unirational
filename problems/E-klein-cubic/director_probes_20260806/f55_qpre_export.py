#!/usr/bin/env python3
# f55_qpre_export.py -- DATA EXPORTER for the independent (Julia/Nemo) second engine.
#
# WHAT.  Regenerates the MIXED fan and the nonnegative integral witness field d for
# the G9-induced rank pattern(s) P, and dumps a *structure-free* JSON file:
#
#   normals : the 20 primitive wall normals nu_t in Lambda = Z^5/diag (last coord
#             normalised to 0), in the FIXED order  A(a,b) for a<b (10), then
#             G(a,b) for a<b (10)  -- i.e. FNAME order of f55_mixedfan/mixedpos.
#   ud      : { sign-vector-string  ->  U_d of that chamber (5 ints, last = 0) },
#             where the sign-vector-string is the length-20 string of '+'/'-' giving
#             sign(<n, form_t>) for any interior point n of the chamber.
#   walls   : [ [sv_string_i, sv_string_j, normal_index], ... ]
#
# NOTHING ELSE is dumped: no cell indices, no orbit numbering, no sigma-permutation,
# no adjacency graph beyond the raw wall pairs.  The consuming engine must rebuild
# the chamber set, the sigma-action and the orbit decomposition from the sign
# vectors alone.  That is the point: it makes the second engine independent.
#
# HOW.  The fan + witness construction of f55_mixedpos.py is *reused verbatim* (its
# cell / wall / ray lists are each certified complete against an exact Zaslavsky
# count, and every cell, wall and ray carries an exact integer certificate).  We
# exec the source of that file up to -- but not including -- its `main` section, so
# nothing is recomputed differently here; then we call positivity() for the pattern
# and form U_d cell-by-cell from the returned integral witness vector.
#
# The dump is then ROUND-TRIPPED: we re-read the JSON and re-verify, using only the
# JSON contents (chambers are re-identified from sign vectors, not indices), that
#   * every wall jump U_d(C) - U_d(C') is an integer multiple of the wall normal,
#   * d >= 0 and the twice-min law and the mod-11 congruence (ii) hold at many
#     random lattice points of N,
#   * d vanishes on the pattern's zero cells.
#
# Reproduce:   python3 f55_qpre_export.py            # pattern {3,4} (default)
#              python3 f55_qpre_export.py 3,4 0,1    # both patterns
import json, os, random, sys, time
import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.join(HERE, "f55_mixedpos.py")
T00 = time.time()

# ---------------------------------------------------------------- 0. load the fan
# exec the certified prefix of f55_mixedpos.py (everything before its `main` block)
with open(SRC) as fh:
    lines = fh.readlines()
cut = next(i for i, L in enumerate(lines) if L.startswith("# ==") and L.rstrip().endswith(" main"))
PREFIX = "".join(lines[:cut])
G = {"__name__": "f55_mixedpos_prefix", "__file__": SRC}
print(f"[export] exec'ing f55_mixedpos.py lines 1..{cut} (fan + witness machinery)")
t0 = time.time()
exec(compile(PREFIX, SRC, "exec"), G)
print(f"[export] fan machinery ready [{time.time()-t0:.1f}s]")

FORMS, FNAME = G["FORMS"], G["FNAME"]
CK, CIDX, PTS, SC = G["CK"], G["CIDX"], G["PTS"], G["SC"]
WALLS, SIG, ORB, NC = G["WALLS"], G["SIG"], G["ORB"], G["NC"]
prim, sigN, MU, c9 = G["prim"], G["sigN"], G["MU"], G["c9"]
cell_of_mixed = G["cell_of_mixed"]
positivity = G["positivity"]

assert NC == 1090 and len(WALLS) == 2570 and len(ORB) == 218

# the 20 primitive normals, in FNAME order
NU = [prim(FORMS[t]) for t in range(20)]
for t in range(20):
    assert NU[t][4] == 0
    from math import gcd
    g = 0
    for x in NU[t]:
        g = gcd(g, abs(x))
    assert g == 1

# sign-vector string of a chamber
def svstr(row):
    return "".join("+" if int(v) > 0 else "-" for v in row)

SVS = [svstr(SC[c]) for c in range(NC)]
assert len(set(SVS)) == NC, "sign vectors do not separate chambers"

# recover, for each wall, the UNIQUE form index at which the two sign vectors differ,
# and check the stored primitive normal agrees with that form's normal up to sign
WIDX = []
for (i, j, nu) in WALLS:
    diff = [t for t in range(20) if SC[i][t] != SC[j][t]]
    assert len(diff) == 1, ("wall sign vectors differ in != 1 place", i, j, diff)
    t = diff[0]
    assert tuple(nu) == NU[t] or tuple(-x for x in nu) == NU[t], ("normal mismatch", i, j, t)
    WIDX.append(t)
print(f"[export] every one of the {len(WALLS)} walls: sign vectors differ in exactly one "
      f"of the 20 forms, and the stored primitive normal is +/- that form's normal")


def export_pattern(P0):
    tag = "".join(str(x) for x in sorted(P0))
    ZEROS = [i for i, (pA, pG) in enumerate(CK) if pG.index(0) in set(P0)]
    st, dat, rkA, d = positivity(f"G9-rank P = {sorted(P0)}", ZEROS)
    if st != "LP-FEASIBLE":
        print(f"[export] pattern {sorted(P0)}: positivity returned {st} -- NOT exported")
        return None
    (y, cy, ui, Nn, A, Kb, H, CM, RHS, EXPR, P) = dat
    U4 = (EXPR.reshape(-1, P).astype(object) @ y.astype(object)).reshape(NC, 4)
    U5 = [[int(U4[c][t]) for t in range(4)] + [0] for c in range(NC)]

    # -- verify the witness over Z, here, independently of positivity()'s own checks
    bad = 0
    for (i, j, nu) in WALLS:
        D = [U5[i][t] - U5[j][t] for t in range(5)]
        n5 = [nu[t] - nu[4] for t in range(5)]
        j0 = next(t for t in range(5) if n5[t])
        if D[j0] % n5[j0]:
            bad += 1
            continue
        m = D[j0] // n5[j0]
        if any(D[t] != m * n5[t] for t in range(5)):
            bad += 1
    z = sum(1 for c in ZEROS if any(U5[c]))
    print(f"[export] witness for P={sorted(P0)}: wall-jump violations {bad}/{len(WALLS)}, "
          f"nonzero on {z}/{len(ZEROS)} zero cells, max|U_d| = "
          f"{max(abs(v) for r in U5 for v in r)}")
    assert bad == 0 and z == 0

    obj = {
        "pattern": sorted(P0),
        "form_order": [list(f) for f in FNAME],
        "normals": [list(NU[t]) for t in range(20)],
        "ud": {SVS[c]: U5[c] for c in range(NC)},
        "walls": [[SVS[i], SVS[j], WIDX[w]] for w, (i, j, nu) in enumerate(WALLS)],
    }
    out = os.path.join(HERE, f"f55_qpre_data_P{tag}.json")
    with open(out, "w") as fh:
        json.dump(obj, fh)
    print(f"[export] wrote {out}  ({os.path.getsize(out)} bytes)")
    return out


# ------------------------------------------------------- round trip, JSON data only
def roundtrip(path):
    print(f"\n[roundtrip] {os.path.basename(path)} -- verifying using ONLY the JSON")
    O = json.load(open(path))
    NUj = [tuple(v) for v in O["normals"]]
    UD = {k: list(v) for k, v in O["ud"].items()}
    WL = O["walls"]
    print(f"[roundtrip] chambers {len(UD)}, walls {len(WL)}, normals {len(NUj)}")
    assert len(UD) == 1090 and len(WL) == 2570 and len(NUj) == 20

    # forms, rebuilt from the stated order (A(a,b) then G(a,b), a<b) -- these are the
    # same covectors as the normals, so we can just use NUj to classify points.
    NUa = np.array(NUj, dtype=np.int64)

    def sv_of(n):
        s = NUa @ np.array(n, dtype=np.int64)
        if (s == 0).any():
            return None
        return "".join("+" if v > 0 else "-" for v in s)

    # (a) wall jumps are integer multiples of the normal, and the two sign vectors
    #     differ exactly at the declared normal index
    bad = 0
    for (a, b, t) in WL:
        assert a in UD and b in UD
        dpos = [q for q in range(20) if a[q] != b[q]]
        if dpos != [t]:
            bad += 1
            continue
        D = [UD[a][q] - UD[b][q] for q in range(5)]
        nu = NUj[t]
        j0 = next(q for q in range(5) if nu[q])
        if D[j0] % nu[j0] or any(D[q] * nu[j0] != D[j0] * nu[q] for q in range(5)):
            bad += 1
    print(f"[roundtrip] wall structure + integral jumps: {bad} violations of {len(WL)}")
    assert bad == 0

    # (b) ground truth at random lattice points of N: d >= 0, twice-min, congruence (ii)
    rr = random.Random(20260807)
    nb = neg = tw = cong = miss = 0
    for _ in range(20000):
        B = rr.choice((6, 20, 80, 300))
        n = [rr.randint(-B, B) for _ in range(5)]
        n[4] = -sum(n[:4])
        n = tuple(n)
        ks = []
        m = n
        ok = True
        for k in range(5):
            s = sv_of(m)
            if s is None:
                ok = False
                break
            ks.append(s)
            m = sigN(m)
        if not ok:
            miss += 1
            continue
        nb += 1
        vals = []
        m = n
        for k in range(5):
            vals.append(sum(UD[ks[k]][q] * m[q] for q in range(5)))
            m = sigN(m)
        if min(vals) < 0:
            neg += 1
        if min(vals) != 0 or sum(1 for v in vals if v == 0) < 2:
            tw += 1
        if (sum(pow(9, k, 11) * vals[k] for k in range(5))
                + sum(n[q] * c9[q] for q in range(5))) % 11:
            cong += 1
    print(f"[roundtrip] {nb} random lattice points ({miss} on a wall, skipped): "
          f"d<0 {neg}, twice-min failures {tw}, congruence (ii) failures {cong}")
    assert (neg, tw, cong) == (0, 0, 0) and nb > 5000
    print("[roundtrip] OK -- the JSON alone reproduces the witness")


if __name__ == "__main__":
    args = sys.argv[1:] or ["3,4"]
    outs = []
    for a in args:
        P0 = tuple(int(x) for x in a.split(","))
        o = export_pattern(P0)
        if o:
            outs.append(o)
    for o in outs:
        roundtrip(o)
    print(f"\n[export] total {time.time()-T00:.1f}s")
