#!/usr/bin/env python3
"""
I3 -- where the current pipeline admits non-semistable supports.

The DATA_SPEC pins the places to check:
  * `produce_d34.py:basis_seeds`  (seed generation),
  * ansatz searches,
  * the RT lane's restricted tuples,
and pins the correct verdict shape: if the pipeline only ever handles
G-equivariant objects, the theorem makes the filter vacuous there and the
verdict is SUBSUMED "with the statement of exactly that".

This script produces the machine half of that determination:
 (1) the classification of a SINGLE-MONOMIAL seed -- the object every seed
     generator in the record emits -- as a point of P(Sym^d W* (x) W);
 (2) the actual d = 35 stored seed arrays run through the exact test;
 (3) the C11-eigenbasis corollary of I3 with its explicit numeric threshold
     at d = 34 and d = 35, which is the form in which I3 is checkable at zero
     cost on any residue-enumerated support.
"""

import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from i3_semistability import hm_test, weight_of, run_anchors

ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)),
                                    "..", "..", ".."))
SEED_A = os.path.join(ROOT, "goal_runs_20260811", "PAIR_ATTACK_D35",
                      "results", "layer0_A_p331.npy")
SEED_C = os.path.join(ROOT, "goal_runs_20260811", "PAIR_ATTACK_D35",
                      "results", "layer0_C_p331.npy")


# --------------------------------------------------------------- (1)
def single_monomial_criterion(d):
    """
    A single-monomial tuple x^alpha (x) e_c is SEMISTABLE  iff
    alpha - e_c = ((d-1)/5)*(1,1,1,1,1), which needs 5 | d-1 and
    alpha = ((d-1)/5)*(1,1,1,1,1) + e_c.  Otherwise it is UNSTABLE.
    (Immediate from the convex-hull form: the hull of one point is that
    point, and the target is the barycentre.)
    """
    if (d - 1) % 5:
        return {"d": d, "any_semistable_single_monomial": False,
                "reason": "5 does not divide d-1, so the barycentre "
                          "((d-1)/5)*(1,1,1,1,1) is not an integer vector"}
    q = (d - 1) // 5
    witnesses = []
    for c in range(5):
        alpha = [q] * 5
        alpha[c] += 1
        witnesses.append({"alpha": alpha, "c": c})
    return {"d": d, "any_semistable_single_monomial": True,
            "the_only_ones": witnesses}


# --------------------------------------------------------------- (2)
def scan_stored_seeds():
    """Run the exact test on every stored d = 35 layer-0 seed."""
    try:
        import numpy as np
    except ImportError:
        return {"status": "numpy unavailable", "checked": 0}
    if not (os.path.exists(SEED_A) and os.path.exists(SEED_C)):
        return {"status": "seed arrays not found", "path": SEED_A, "checked": 0}
    A = np.load(SEED_A)
    C = np.load(SEED_C)
    n = A.shape[0]
    verdicts = {"SEMISTABLE": 0, "UNSTABLE": 0}
    examples = []
    for i in range(n):
        alpha = tuple(int(x) for x in A[i])
        c = int(C[i])
        r = hm_test([(alpha, c)])
        verdicts[r["verdict"]] += 1
        if len(examples) < 3:
            examples.append({"i": i, "alpha": list(alpha), "c": c,
                             "verdict": r["verdict"],
                             "destabiliser": r.get("certificate"),
                             "min_weight": r.get("min_weight")})
    return {"status": "ok", "file": os.path.relpath(SEED_A, ROOT),
            "n_seeds": n, "degree": int(A.sum(1)[0]),
            "verdicts": verdicts, "examples": examples}


# --------------------------------------------------------------- (3)
def c11_eigenbasis_corollary(d, weights=(1, 3, 4, 5, 9)):
    """
    In a C11-eigenbasis of W with integer weight representatives
    v = (v_0..v_4), the traceless integer 1-PS
          r  =  5*v  -  (sum v) * (1,1,1,1,1)
    has, on a support element (alpha, c) obeying the C11-equivariance
    condition  <v, alpha> - v_c == 0 (mod 11)  (write that quantity 11k),
          weight(alpha, c)  =  55k - (sum v)*(d-1)  =  11*(5k - S(d-1)/11)...
    concretely  weight = 5*(11k) - (sum v)*(d-1).
    I3 forbids all weights strictly positive AND all strictly negative, so
    the support must contain a level k with  5*11*k <= (sum v)*(d-1)  and one
    with  5*11*k >= (sum v)*(d-1):  a two-sided LEVEL condition, checkable at
    zero cost on any residue-enumerated support.
    """
    S = sum(weights)
    r = [5 * w - S for w in weights]
    assert sum(r) == 0
    thr_num = S * (d - 1)          # threshold on 55k
    k_lo = thr_num // 55           # largest k with 55k <= thr
    k_hi = -((-thr_num) // 55)     # smallest k with 55k >= thr
    # attainable level range for degree d
    lo_val = min(weights) * d - max(weights)
    hi_val = max(weights) * d - min(weights)
    k_min = -((-lo_val) // 11)
    k_max = hi_val // 11
    return {
        "d": d,
        "weights_v": list(weights),
        "one_PS_r": r,
        "sum_r": sum(r),
        "threshold_on_55k": thr_num,
        "threshold_on_k": "%d/%d" % (thr_num, 55),
        "need_some_level_k_le": k_lo,
        "need_some_level_k_ge": k_hi,
        "attainable_level_range": [k_min, k_max],
        "vacuous": not (k_min <= k_lo and k_hi <= k_max),
    }


def main():
    out = {"anchors": run_anchors(),
           "single_monomial_criterion": {str(d): single_monomial_criterion(d)
                                         for d in (34, 35, 36, 25, 11)},
           "stored_seed_scan": scan_stored_seeds(),
           "c11_eigenbasis_corollary": {
               "QR_frame_v=(1,3,4,5,9)": {str(d): c11_eigenbasis_corollary(d)
                                          for d in (34, 35)},
               "non_QR_frame_v=(2,6,7,8,10)": {
                   str(d): c11_eigenbasis_corollary(d, (2, 6, 7, 8, 10))
                   for d in (34, 35)},
           },
           "pipeline_stages": PIPELINE_STAGES,
           "verdict": VERDICT}
    here = os.path.dirname(os.path.abspath(__file__))
    dest = os.path.join(here, "..", "results", "i3_scan.json")
    with open(dest, "w") as f:
        json.dump(out, f, indent=1, sort_keys=True)
    print("wrote %s" % os.path.normpath(dest))
    print("anchors all_pass:", out["anchors"]["all_pass"])
    print("stored seeds:", out["stored_seed_scan"].get("verdicts"))
    for d in (34, 35, 36):
        c = out["single_monomial_criterion"][str(d)]
        print("d=%d single-monomial seed semistable possible: %s"
              % (d, c["any_semistable_single_monomial"]))
    print("verdict:", VERDICT["verdict"])


# ---------------------------------------------------------------- findings
# Every entry below is a first-hand read of the cited file at the cited line.
PIPELINE_STAGES = [
    {"stage": "seed generation",
     "file": "goal_runs_20260811/D34_GUIDED_SWEEP/slicelib.py:276-299",
     "symbol": "seed_exponents",
     "emits": "raw single monomials (alpha, c0), NOT symmetrised",
     "class": "b (raw non-symmetrised monomial supports)",
     "consumed_as": "arguments of jet_rows, never as candidate tuples"},
    {"stage": "basis construction",
     "file": "goal_runs_20260811/D34_GUIDED_SWEEP/produce_d34.py:90-109",
     "symbol": "basis_seeds",
     "emits": "the kept (alpha, c0) pairs kA, kC",
     "class": "b, but every independence test is run on jet_rows(...) output",
     "consumed_as": "indices of Reynolds images"},
    {"stage": "symmetrisation",
     "file": "goal_runs_20260811/D34_GUIDED_SWEEP/slicelib.py:302-314",
     "symbol": "jet_rows",
     "emits": "R(s)(v) = sum_g rho(g)^{-1} s(rho(g) v), the Reynolds image",
     "class": "a (G-covariant)",
     "consumed_as": "THE object every downstream rank/jet test sees"},
    {"stage": "stored layer-0 seeds (d = 35)",
     "file": "goal_runs_20260811/PAIR_ATTACK_D35/results/layer0_A_p331.npy "
             "+ layer0_C_p331.npy",
     "symbol": "-",
     "emits": "637 raw (alpha, c) pairs of degree 35",
     "class": "b",
     "consumed_as": "seeds re-Reynolds-summed at every evaluation "
                    "(D35_LANDING/scripts/landlib.py:64, "
                    "D35_AUDIT/scripts/reynolds.py:18)"},
    {"stage": "RT lane",
     "file": "goal_runs_20260810/RT_SPLIT_AND_DICHOTOMY/, "
             "goal_runs_20260810/AMBIENT_HODGE_REES_BRIDGE/"
             "RESTRICTED_TRANSFER.md",
     "symbol": "-",
     "emits": "nothing monomial: 'restricted' there means restriction of a "
              "Hodge module from the ambient P^4 to X, not a restricted "
              "monomial support",
     "class": "n/a -- enumerates no supports",
     "consumed_as": "-"},
    {"stage": "ansatz searches",
     "file": "REMAINING_GOALS_NOTE.md:71 ('COV structured (0801), "
             "named-ansatz empty'); SPEC.md:588 (invariant-coefficient "
             "ansatz in degrees 0,4,6,8,10)",
     "symbol": "-",
     "emits": "invariant-COEFFICIENT ansatze, i.e. already G-equivariant",
     "class": "a",
     "consumed_as": "terminal front, not on active dispatch"},
    {"stage": "C13 sibling prefilter (tropical/Newton)",
     "file": "goal_runs_20260811/PAIR_ATTACK_D35/scripts/layer0_base.py:11,201",
     "symbol": "-",
     "emits": "the recorded status 'C13: automatic (Reynolds G-orbit support "
              "on seeds)'",
     "class": "a",
     "consumed_as": "the exact slot I3 would occupy"},
]

VERDICT = {
    "verdict": "SUBSUMED",
    "statement": (
        "Every stage of the current d = 34 / d = 35 pipeline that tests an "
        "object tests a Reynolds image R(s), which is by construction a "
        "G-covariant; by the theorem of sec.3 every nonzero G-covariant is "
        "SL(W)-semistable, so the I3 prefilter is VACUOUS on every object the "
        "pipeline handles.  It is therefore subsumed exactly as C13 already "
        "is at layer0_base.py:201.  No pipeline stage admits a "
        "NON-SEMISTABLE CANDIDATE TUPLE."),
    "where_unstable_supports_do_appear": (
        "The seed enumerators (slicelib.py:seed_exponents, "
        "produce_d34.py:basis_seeds, and the stored layer0_A/C arrays) do "
        "emit unstable supports -- at d = 34 and d = 35 EVERY single-monomial "
        "seed is unstable, because 5 does not divide d-1 -- but a seed is an "
        "argument of the Reynolds operator, not a candidate tuple.  Admitting "
        "them is correct, not a leak."),
    "the_one_live_consumer": (
        "I3 acquires content only where a support is enumerated by a "
        "RESIDUE condition rather than produced by the Reynolds operator.  "
        "The C11-eigenbasis corollary below is that content, and no current "
        "stage runs such an enumeration, so the corollary has no live "
        "consumer at d = 35 today."),
    "not_claimed": (
        "No cut of the 22 live d = 35 cells; no degree excluded; the filter "
        "is registered as necessary-and-currently-vacuous."),
}


if __name__ == "__main__":
    main()
