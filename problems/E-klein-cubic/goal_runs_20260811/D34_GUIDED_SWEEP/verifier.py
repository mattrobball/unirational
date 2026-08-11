#!/usr/bin/env python3
"""D34_GUIDED_SWEEP -- verifier.

Independent replay of every load-bearing number in THEOREM.md.  Nothing is
read from a payload written by the producers except for cross-checking; the
decisive rank computation is re-run FROM SCRATCH at a prime and with a random
seed that neither producer used (p = 661, seed 20260812).

Prints one `CHECK [OK ]/[FAIL]` line per assertion and ends with
`D34_GUIDED_SWEEP_VERIFY_OK` + `ALLGREEN` (exit 0) or
`D34_GUIDED_SWEEP_VERIFY_FAILED` (exit 1).

Usage:  python3 verifier.py [--fast]      (--fast skips the replay at p = 661)
"""
import json
import os
import sys
import time

import numpy as np

import slicelib as SL
import p2lib as P2
import d34lib as D34
import produce_dims34 as DIMS
import produce_d34 as PD
import produce_ladder as PL

HERE = os.path.dirname(os.path.abspath(__file__))
RES = os.path.join(HERE, "results")
T0 = time.time()
NCHK = [0]
FAIL = []


def check(name, cond, detail=""):
    NCHK[0] += 1
    if cond:
        print("CHECK [OK ] %-64s %s" % (name, detail), flush=True)
    else:
        print("CHECK [FAIL] %-64s %s" % (name, detail), flush=True)
        FAIL.append(name)


def load(fn):
    with open(os.path.join(RES, fn)) as fh:
        return json.load(fh)


def main():
    fast = "--fast" in sys.argv

    # =============================================================== A. ledger
    P = DIMS.big_prime()
    check("A1 verification prime P = 1 (mod 330)", (P - 1) % 330 == 0, "P=%d" % P)
    check("A2 P exceeds 5*C(38,4) = 369075 (dimensions read off uniquely)",
          P > 369075, "P=%d" % P)
    dimA, chi = DIMS.pathA_dimM(P, dmax=42)
    n1, n0 = DIMS.pathA_selftest(P, chi)
    check("A3 <chi_W,chi_W> = 1  (W irreducible)", n1 == 1)
    check("A4 <chi_W,1> = 0", n0 == 0)
    check("A5 sealed Molien row dim M_d = 1,0,0,2,1,2,4 for d=1..7",
          dimA[1:8] == [1, 0, 0, 2, 1, 2, 4], str(dimA[1:8]))
    check("A6 dim M_25 = 189 (FIX-P1)", dimA[25] == 189)
    check("A7 dim M_34 = 576", dimA[34] == 576)
    check("A8 dim M_36 = 706 (FIX-P2)", dimA[36] == 706)
    L = load("dimension_ledger.json")
    check("A9 ledger PATH A = PATH B on dim M_d, all d <= 40",
          L["dim_M_d_agree"] is True)
    for k in ("N_plane", "N_minus", "N_line", "N_c3", "N_D10", "N_C6pt",
              "N_D12pt"):
        check("A10 ledger PATH A = PATH B on %s" % k,
              L["targets_agree"][k] is True,
              "= %d" % L["targets_pathA"][k])
    tA = DIMS.pathA_targets(P)
    check("A11 N_plane  = dim (Sym^34 (W^+)* ox W)^{D12} = 324",
          tA["N_plane"] == 324)
    check("A12 N_minus  = dim (Sym^34 (W^-)* ox W)^{D12} = 18",
          tA["N_minus"] == 18)
    check("A13 N_line(6)= dim (+)_{k<6} (Sym^k Q* ox Sym^{34-k} U* ox W)^{A4}"
          " = 732", tA["N_line"] == 732)
    check("A14 N_c3     = dim (Sym^34 (W_w)* ox W/<p_w>)^{C6} = 18",
          tA["N_c3"] == 18)
    check("A15 N_D10 = N_C6pt = N_D12pt = 1",
          tA["N_D10"] == 1 and tA["N_C6pt"] == 1 and tA["N_D12pt"] == 1)
    check("A16 C6 weights on X are {1,5}", L["C6_weights_on_X"] == [1, 5])
    check("A17 the D10-point is off X", L["D10_point_off_X"] is True)
    check("A18 STAGE1's leading-datum count N(34,1) = 397 reproduced",
          DIMS.N_leading(P, 34, 1) == 397,
          "N(34,1) = %d" % DIMS.N_leading(P, 34, 1))
    check("A19 STAGE1 sample row N(1,1)=1, N(3,1)=4, N(3,3)=1, N(5,1)=10, "
          "N(7,1)=19, N(34,3)=704",
          [DIMS.N_leading(P, *x) for x in
           ((1, 1), (3, 1), (3, 3), (5, 1), (7, 1), (34, 3))] ==
          [1, 4, 1, 10, 19, 704],
          str([DIMS.N_leading(P, *x) for x in
               ((1, 1), (3, 1), (3, 3), (5, 1), (7, 1), (34, 3))]))

    # ===================================================== B. the d=34 sieve
    profs = PL.profiles(34)
    check("B1 d=34 has 30 admissible profiles (FIX-P2 corrected bound)",
          len(profs) == 30, "n=%d" % len(profs))
    check("B2 every admissible profile at d=34 has m >= 1",
          min(x["m"] for x in profs) == 1)
    check("B3 every admissible profile at d=34 has r >= 6",
          min(x["r"] for x in profs) == 6,
          "min r = %d" % min(x["r"] for x in profs))
    check("B4 (m,r)=(1,6) is admissible with n = d-r = 28",
          {"m": 1, "r": 6, "e": 5, "n": 28} in profs)

    # ============================================ C. producer runs, 3 primes
    seen = {}
    for p in (67, 199, 331):
        fn = "cascade34_p%d.json" % p
        if not os.path.exists(os.path.join(RES, fn)):
            check("C0 cascade payload present for p=%d" % p, False)
            continue
        j = load(fn)
        seen[p] = j
        check("C1 p=%d frame/adapted/stage2 self-tests all pass" % p,
              all(j["adapted_self_tests"].values()) and
              all(j["stage2_self_tests"].values()))
        check("C2 p=%d Lemma 1.1 control: ann(W_w).T|_{ell_w} has rank 0 on "
              "all of M_34" % p, j["lemma11_control_rank_zero"] is True)
        check("C3 p=%d FIX-P2 baseline reproduced: (P)+(P+)+(L) leaves dim 16"
              % p, j["fixp2_baseline_reproduced"] is True,
              "B3 = %d" % j["cascade_B_profile_first"][3])
        check("C4 p=%d + (M) minus-lines: 16 -> 2" % p,
              j["cascade_B_profile_first"][4] == 2,
              "B4 = %d" % j["cascade_B_profile_first"][4])
        check("C5 p=%d + (E) C3-eigenlines: 2 -> 0" % p,
              j["cascade_B_profile_first"][5] == 0,
              "B5 = %d" % j["cascade_B_profile_first"][5])
        check("C6 p=%d structure-first cascade ends at 0 as well" % p,
              j["cascade_A_structure_first"][-1] == 0)
        check("C7 p=%d base-point block (D10,D12,X^{C6}) adds nothing "
              "(implied)" % p,
              j["cascade_A_structure_first"][5] ==
              j["cascade_A_structure_first"][4])
        check("C8 p=%d saturation control stable at 0" % p,
              j["saturation_stable"] is True and j["saturation_dim"] == 0)
        check("C9 p=%d verdict D34-ONESIX-WINDOW-EMPTY" % p,
              j["verdict"] == "D34-ONESIX-WINDOW-EMPTY", j["verdict"])
    check("C10 all three primes agree on the whole cascade B row",
          len({tuple(v["cascade_B_profile_first"]) for v in seen.values()}) == 1,
          str(sorted({tuple(v["cascade_B_profile_first"])
                      for v in seen.values()})))

    # ================================================= D. the ladder payload
    lp = os.path.join(RES, "ladder_p331_34_42.json")
    if os.path.exists(lp):
        j = json.load(open(lp))
        rows = {r["d"]: r for r in j["rows"]}
        check("D1 ladder d=34 EMPTY", rows[34]["verdict"] == "EMPTY")
        check("D2 ladder d=34 reproduces FIX-P2 profile-only dim 16",
              rows[34]["dim_profile_only_(1,r0)"] == 16)
        check("D3 ladder d=35 survives (first open window moves to 35)",
              rows.get(35, {}).get("verdict", "").startswith("ALIVE"),
              rows.get(35, {}).get("verdict", "-"))
        check("D4 every degree 34..42 has r0 = 6 (monotonicity applies)",
              all(r.get("r0") == 6 for r in j["rows"] if "r0" in r))
    else:
        check("D0 ladder payload present", False)

    # ============================== E. independent replay at a FRESH prime
    if fast:
        print("[verifier] --fast: skipping the p=661 replay")
    else:
        p = 661
        rng = np.random.default_rng(20260812)          # a seed no producer used
        fr = D34.stage2_frame(P2.adapted_frame(SL.build_frame(p, verbose=False)),
                              verbose=False)
        A, C, got = PD.basis_seeds(fr, 34, 576, p, rng)
        check("E1 p=661 seeds span M_34 (dim 576)", A is not None,
              "got %s" % got)
        if A is not None:
            npair, npt = 110, 85
            c1, c2 = PD.plane_blocks(fr, A, C, 34, 1, npair, p, rng)
            lb = PD.line_block(fr, A, C, 34, 6, npair, p, rng)
            mb = D34.minus_line_block(fr, A, C, 34, npt, p, rng)
            eb, ectl = D34.eigenline_block(fr, A, C, 34, npt, p, rng, 1)
            eb2, ectl2 = D34.eigenline_block(fr, A, C, 34, npt, p, rng, 2)

            def dm(bl):
                return int(576 - P2.rref_rank_fast(
                    np.concatenate(bl, axis=1), p))
            check("E2 p=661 Lemma 1.1 control rank 0",
                  P2.rref_rank_fast(ectl, p) == 0 and
                  P2.rref_rank_fast(ectl2, p) == 0)
            b1 = dm([c1])
            b2 = dm([c1, c2])
            b3 = dm([c1, c2, lb])
            b4 = dm([c1, c2, lb, mb])
            b5 = dm([c1, c2, lb, mb, eb, eb2])
            check("E3 p=661 (P) alone leaves 316", b1 == 316, "= %d" % b1)
            check("E4 p=661 (P+) is vacuous (parity identity)", b2 == b1,
                  "%d -> %d" % (b1, b2))
            check("E5 p=661 + (L) r=6 leaves 16 (FIX-P2 baseline)", b3 == 16,
                  "= %d" % b3)
            check("E6 p=661 + (M) leaves 2", b4 == 2, "= %d" % b4)
            check("E7 p=661 + (E) leaves 0  -- WINDOW EMPTY", b5 == 0,
                  "= %d" % b5)
            check("E8 p=661 (M) alone has rank <= N_minus = 18",
                  P2.rref_rank_fast(mb, p) <= 18,
                  "rank = %d" % P2.rref_rank_fast(mb, p))
            check("E9 p=661 (E) alone has rank <= N_c3 = 18",
                  P2.rref_rank_fast(np.concatenate([eb, eb2], axis=1),
                                    p) <= 18)
            # UNIT control: a condition that must NOT kill everything
            check("E10 UNIT control: (M) alone leaves a positive-dimensional "
                  "space", dm([mb]) > 0, "= %d" % dm([mb]))
            # UNIT control: an impossible condition must kill everything
            lbig = PD.line_block(fr, A, C, 34, 14, npair, p, rng)
            check("E11 UNIT control: ord_{ell_V} >= 14 kills M_34",
                  dm([lbig]) == 0, "= %d" % dm([lbig]))

    print("\n%d checks, %d failures   [%.1f s]"
          % (NCHK[0], len(FAIL), time.time() - T0))
    if FAIL:
        print("D34_GUIDED_SWEEP_VERIFY_FAILED:", FAIL)
        return 1
    print("D34_GUIDED_SWEEP_VERIFY_OK")
    print("ALLGREEN")
    return 0


if __name__ == "__main__":
    sys.exit(main())
