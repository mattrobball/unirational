#!/usr/bin/env python3
# f55_witness_dump.py -- CONVENTION-FREE EXPORT of the f55_mixedpos.py nonnegative
# integral witness, for independent re-verification by a second engine (f55_verify.jl).
#
# WHAT THIS DOES.  It re-runs *only* the witness-producing machinery of
# f55_mixedpos.py (sections 0-4; the __main__ driver and the (e)-family sweep are
# truncated away), then writes a JSON file that contains NO project conventions:
#   * the 20 hyperplane normals as integer 5-vectors, in the fixed order
#         [ e_a - e_b : a<b ]  ++  [ mu_a - mu_b : a<b ],   mu_k[j] = G9[(j+k) % 5]
#     (this order is rebuilt here FROM THE DEFINITIONS and asserted equal to the
#      probe's own list; a mismatch would be reported, not silently accepted);
#   * for each rank pattern P, a dict  signvector -> slope U (integer 5-vector),
#     the sign vector being the length-20 string of '+'/'-' recording
#     sign(<nu_t, n>) for a point n in that cell;
#   * the list of sign vectors of the zero cells.
# NO cell indices, no orbit numbering, no ray list, no wall list -- those are exactly
# the conventions under test.
#
# ROUND TRIP.  After writing, the JSON is re-read from disk and d is re-evaluated at
# 1000 random lattice points of N *from the JSON alone* (normals rebuilt from the
# definitions, cell found by sign lookup) and compared against the probe's own
# d(n) = <U_{cell_of_mixed(n)}, n>.  Any mismatch aborts.
#
# Run:  python3 f55_witness_dump.py           (writes f55_witness.json)

import json, os, random, sys, time
from itertools import combinations

HERE = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.join(HERE, "f55_mixedpos.py")
OUT = os.path.join(HERE, "f55_witness.json")
MARKER = "# ==================================================== main"

T0 = time.time()

# ---------------------------------------------------------------- 1. run the probe
src = open(SRC).read()
cut = src.index(MARKER)
if cut < 0:
    sys.exit("marker not found")
body = src[:cut]
ns = {"__name__": "f55_mixedpos_partial", "__file__": SRC}
print("### executing f55_mixedpos.py sections 0-4 (driver truncated) ...")
exec(compile(body, SRC, "exec"), ns)
print(f"### probe machinery loaded [{time.time()-T0:.1f}s]")

import numpy as np

NC = ns["NC"]
CK = ns["CK"]
PTS = ns["PTS"]
SC = ns["SC"]
G9 = ns["G9"]
c9 = ns["c9"]
sigN = ns["sigN"]
cell_of_mixed = ns["cell_of_mixed"]
positivity = ns["positivity"]

# ------------------------------------------- 2. normals, rebuilt from definitions
MU_def = [tuple(G9[(j + k) % 5] for j in range(5)) for k in range(5)]
NORMALS = []
for a, b in combinations(range(5), 2):          # A4 block: e_a - e_b
    v = [0] * 5
    v[a] = 1
    v[b] = -1
    NORMALS.append(tuple(v))
for a, b in combinations(range(5), 2):          # G9 block: mu_a - mu_b
    NORMALS.append(tuple(MU_def[a][j] - MU_def[b][j] for j in range(5)))

probeF = [tuple(int(x) for x in row) for row in ns["F"]]
if probeF != NORMALS:
    print("!! WARNING: normal order rebuilt from the brief's definitions DIFFERS from")
    print("!! the probe's internal list.  brief:", NORMALS)
    print("!! probe:", probeF)
    sys.exit("normal-order mismatch -- refusing to export")
print("### 20 normals rebuilt from definitions == probe's list: True")

NARR = np.array(NORMALS, dtype=np.int64)


def sgnkey_from_point(n):
    """length-20 string of '+'/'-' ; None if n lies on any wall."""
    vals = [sum(int(NORMALS[t][j]) * int(n[j]) for j in range(5)) for t in range(20)]
    if any(v == 0 for v in vals):
        return None
    return "".join("+" if v > 0 else "-" for v in vals)


# ------------------------------------------------------ 3. regenerate the witness
def witness_for(P0):
    Z = [i for i, (pA, pG) in enumerate(CK) if pG.index(0) in P0]
    st, dat, rkA, d = positivity(f"G9-rank P = {list(P0)}", Z)
    if st != "LP-FEASIBLE":
        return None
    (y, cy, ui, Nn, A, Kb, H, CM, RHS, EXPR, P) = dat
    U4 = (EXPR.reshape(-1, P).astype(object) @ y.astype(object)).reshape(NC, 4)
    U5 = [[int(U4[c][t]) for t in range(4)] + [0] for c in range(NC)]
    return U5, Z


PATTERNS = {}
PROBE_U5 = {}
for P0 in [(3, 4), (0, 1)]:
    tag = ",".join(str(x) for x in P0)
    res = witness_for(P0)
    if res is None:
        print(f"### pattern {P0}: no LP-feasible witness; skipped")
        continue
    U5, Z = res
    PROBE_U5[tag] = U5
    cellmap = {}
    for c in range(NC):
        k = sgnkey_from_point(PTS[c])
        assert k is not None, ("witness point on a wall", c)
        assert k not in cellmap, ("duplicate sign key", c)
        cellmap[k] = U5[c]
    assert len(cellmap) == NC
    zk = sorted(sgnkey_from_point(PTS[c]) for c in Z)
    PATTERNS[tag] = {"cells": cellmap, "zero_cells": zk}
    print(f"### pattern {tag}: {len(cellmap)} cells, {len(zk)} zero cells, "
          f"max|U| = {max(abs(v) for r in U5 for v in r)}")

assert PATTERNS, "no witness produced"

# --------------------------------------------------- 4. a few cross-check samples
rrs = random.Random(20260807)
samples = []
tagmain = "3,4" if "3,4" in PATTERNS else sorted(PATTERNS)[0]
while len(samples) < 200:
    B = rrs.choice((5, 20, 100, 1000))
    n = [rrs.randint(-B, B) for _ in range(5)]
    n[4] = -sum(n[:4])
    c = cell_of_mixed(tuple(n))
    if c is None:
        continue
    samples.append({"n": n, "d": sum(PROBE_U5[tagmain][c][t] * n[t] for t in range(5))})

DUMP = {
    "note": ("convention-free export of the f55_mixedpos.py witness; "
             "keys are sign vectors over the 20 normals, values are cell slopes U"),
    "G9": list(G9),
    "c9": list(c9),
    "normals": [list(v) for v in NORMALS],
    "normal_order": ("10 A4 normals e_a-e_b for a<b in lex order, then 10 G9 normals "
                     "mu_a-mu_b for a<b in lex order, mu_k[j] = G9[(j+k) mod 5]"),
    "patterns": PATTERNS,
    "crosscheck_pattern": tagmain,
    "crosscheck_samples": samples,
}
with open(OUT, "w") as f:
    json.dump(DUMP, f)
print(f"### wrote {OUT}  ({os.path.getsize(OUT)} bytes)")

# ------------------------------------------------------------- 5. ROUND TRIP TEST
J = json.load(open(OUT))
NRM = [tuple(v) for v in J["normals"]]
assert NRM == NORMALS


def d_from_json(tag, n):
    vals = [sum(NRM[t][j] * n[j] for j in range(5)) for t in range(20)]
    if any(v == 0 for v in vals):
        return None
    k = "".join("+" if v > 0 else "-" for v in vals)
    U = J["patterns"][tag]["cells"].get(k)
    if U is None:
        return "MISSINGCELL"
    return sum(U[t] * n[t] for t in range(5))


rr = random.Random(4242)
for tag in J["patterns"]:
    nb = bad = miss = 0
    while nb < 1000:
        B = rr.choice((5, 20, 100, 1000))
        n = [rr.randint(-B, B) for _ in range(5)]
        n[4] = -sum(n[:4])
        c = cell_of_mixed(tuple(n))
        if c is None:
            continue
        nb += 1
        got = d_from_json(tag, n)
        if got == "MISSINGCELL":
            miss += 1
            continue
        want = sum(PROBE_U5[tag][c][t] * n[t] for t in range(5))
        if got != want:
            bad += 1
            if bad < 4:
                print("   mismatch at", n, got, want)
    print(f"### ROUND TRIP pattern {tag}: {nb} random lattice points, "
          f"{bad} value mismatches, {miss} missing cells")
    assert bad == 0 and miss == 0

print(f"### round trip OK.  total {time.time()-T0:.1f}s")
