"""Stage 3(d), part 1: reproduce the sealed FIX-P2 (1,6)/d=34 slice dimension.

Runs the FIX-P2 code itself (verbatim copies in `p2copy/`) with the same
degree, profile, rng seed and npair formula as `produce_sweep2.py`, on TWO
frames:

  * `p2`   -- FIX-P2's own frame (slicelib.build_frame): must reproduce the
              sealed number 16 at p = 67.
  * `gate` -- the frame built from THIS packet's Stage-1 generators, so that
              the n1 computed in stage3_profile.py is comparable.
"""
import json
import os
import sys
import time

import numpy as np

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)),
                                "p2copy"))
import slicelib as SL          # noqa: E402
import p2lib as P2             # noqa: E402
import produce_cascade as PC   # noqa: E402

from gatelib import check      # noqa: E402
import stage1_group as S1      # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))
D = 34
M, R = 1, 6
DIM_M = 576
SEALED_P67 = 16


def slice_dim(fr, p, d=D, m=M, r=R, dimM=DIM_M, seed=20260806):
    """Exactly produce_sweep2's computation for the first profile of degree d."""
    rng = np.random.default_rng(seed)
    t0 = time.time()
    A, C, got = PC.basis_seeds(fr, d, dimM, p, rng)
    assert A is not None, "seed shortfall %d/%d" % (got, dimM)
    print("    seeds ok (%d) %.0fs" % (got, time.time() - t0), flush=True)
    npair = max(40, dimM // 8 + 20)
    c1, _ = PC.plane_blocks(fr, A, C, d, m, npair, p, rng)
    lb = PC.line_block(fr, A, C, d, r, npair, p, rng)
    MM = np.concatenate([c1, lb], axis=1)
    sd = int(dimM - P2.rref_rank_fast(MM, p))
    print("    slice dim = %d   (%.0fs, npair=%d, cols=%d)"
          % (sd, time.time() - t0, npair, MM.shape[1]), flush=True)
    return sd, dict(npair=npair, ncols=int(MM.shape[1]),
                    seconds=round(time.time() - t0, 1))


def same_group(frA, frB, p):
    a = {A.tobytes() for A in frA["RHO"]}
    b = {A.tobytes() for A in frB["RHO"]}
    return a == b


def main():
    primes = [int(a) for a in (sys.argv[1:] or ["67", "199"])]
    out = {}
    for p in primes:
        print("=== P2 cross-check, p=%d ===" % p, flush=True)
        frP2 = P2.adapted_frame(SL.build_frame(p))
        frGate = P2.adapted_frame(S1.make_frame(p, tag="", do_checks=False))
        eq = same_group(frP2, frGate, p)
        check("group_matches_P2_p%d" % p, eq,
              "Stage-1 group %s FIX-P2's slicelib group"
              % ("==" if eq else "!="))
        print("  [p2 frame]", flush=True)
        sd_p2, info_p2 = slice_dim(frP2, p)
        print("  [gate frame]", flush=True)
        sd_gate, info_gate = slice_dim(frGate, p)
        out[str(p)] = {"p2_frame": sd_p2, "gate_frame": sd_gate,
                       "info_p2": info_p2, "info_gate": info_gate}
        if p == 67:
            check("p2_replay_sealed_p67", sd_p2 == SEALED_P67,
                  "reproduced %d, sealed SWEEP2_p67_34_38 says %d"
                  % (sd_p2, SEALED_P67))
        check("p2_frame_independent_p%d" % p, sd_p2 == sd_gate,
              "s34(p2 frame)=%d s34(gate frame)=%d" % (sd_p2, sd_gate))
        with open(os.path.join(HERE, "payload", "s34_replay.json"), "w") as f:
            json.dump(out, f, indent=1, sort_keys=True)
    print(json.dumps(out, indent=1, sort_keys=True))


if __name__ == "__main__":
    sys.exit(main())
