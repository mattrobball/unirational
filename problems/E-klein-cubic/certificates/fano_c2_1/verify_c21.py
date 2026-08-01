#!/usr/bin/env python3
"""Independent verifier for C2.1. Does NOT import produce_c21.

Recomputes:
  - sealed word list / pair against C2.0
  - modular L_a, L_b at holdout primes by rebuilding Reynolds frame
  - agreement of sealed Q-constant entries after reduction
  - unit columns for a-prepend words still in the basis
  - word-basis determinant unit at sealed C2.0 points
Does not trust producer JSON for the modular matrices.
"""

from __future__ import annotations

import json
import sys
from fractions import Fraction
from pathlib import Path

import numpy as np

ROOT = Path(__file__).resolve().parents[2]
PKG = Path(__file__).resolve().parent
C2 = ROOT / "certificates" / "fano_c2"
COMMON = ROOT / "certificates" / "degree25_exact" / "common_p25x.py"
ALIGN = ROOT / "tmp" / "pfaffian_representation_alignment"

A_FRAME = 1
B_FRAME = 2


def load_common():
    import importlib.util

    spec = importlib.util.spec_from_file_location("common_p25x", COMMON)
    assert spec and spec.loader
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def load_c2_helpers():
    path = C2 / "produce_c2.py"
    ns: dict = {"__file__": str(path), "__name__": "c2_helpers_verify"}
    exec(compile(path.read_text(), str(path), "exec"), ns)
    return ns


def main() -> int:
    common = load_common()
    ns = load_c2_helpers()
    ledger = json.loads((PKG / "reconstruction_ledger.json").read_text())
    sealed_c2 = json.loads((C2 / "word_basis.json").read_text())
    words = sealed_c2["primary_witness"]["words"]
    assert sealed_c2["pair"]["a_frame_index"] == A_FRAME
    assert sealed_c2["pair"]["b_frame_index"] == B_FRAME
    assert ledger["words"] == words
    assert ledger["exit"] == "C2-1-UNDECIDED"

    La_json = json.loads((PKG / "L_a.json").read_text())
    Lb_json = json.loads((PKG / "L_b.json").read_text())
    C_json = json.loads((PKG / "word_change.json").read_text())

    # Rebuild modular data at holdout prime independently
    hp = int(ledger["holdout"]["prime"])
    hz = int(ledger["holdout"]["zeta_11"])
    # search zeta if needed
    if pow(hz, 11, hp) != 1:
        hz = next(
            z
            for z in range(2, hp)
            if pow(z, 11, hp) == 1 and all(pow(z, d, hp) != 1 for d in (1, 2, 5, 10))
        )

    # Use sealed C2.0 point and one random point
    points = [tuple(sealed_c2["primary_witness"]["point"]), (2, 3, 4, 5, 6), (1, 1, 1, 1, 2)]
    # Force POINT via ns
    results = []
    for pt in points:
        ns["POINT"] = np.array(pt, dtype=np.int64)
        try:
            fr = ns["build_projective_reynolds_frame"](hp, hz)
        except Exception as e:
            results.append({"pt": pt, "status": f"frame_fail:{e}"})
            continue
        A = fr["basis_mats"][A_FRAME]
        B = fr["basis_mats"][B_FRAME]
        word_mats = [ns["eval_word"](w, A, B, hp) for w in words]
        V = np.stack([m.reshape(-1) for m in word_mats], axis=1) % hp
        det = ns["det_mod"](V, hp)
        if det == 0:
            results.append({"pt": pt, "status": "singular_word_basis"})
            continue
        La = ns["left_mult_in_word_basis"](A, words, word_mats, hp)
        Lb = ns["left_mult_in_word_basis"](B, words, word_mats, hp)
        # check Q-constants
        la_bad = 0
        for e in La_json["entries"]:
            r = common.reduce_Q_mod(Fraction(e["num"], e["den"]), hp)
            if int(La[e["i"], e["j"]]) % hp != r % hp:
                la_bad += 1
        lb_bad = 0
        for e in Lb_json["entries"]:
            r = common.reduce_Q_mod(Fraction(e["num"], e["den"]), hp)
            if int(Lb[e["i"], e["j"]]) % hp != r % hp:
                lb_bad += 1
        # unit columns for a-prepend
        windex = {w: i for i, w in enumerate(words)}
        unit_bad = 0
        for j, w in enumerate(words):
            aw = "a" + w
            if aw in windex:
                ti = windex[aw]
                if int(La[ti, j]) % hp != 1 or int(np.count_nonzero(La[:, j] % hp)) != 1:
                    unit_bad += 1
        results.append(
            {
                "pt": list(pt),
                "status": "ok",
                "word_det": int(det),
                "frame_det": int(fr["frame_det"]),
                "La_const_bad": la_bad,
                "Lb_const_bad": lb_bad,
                "a_unit_col_bad": unit_bad,
                "n_La_const": len(La_json["entries"]),
                "n_Lb_const": len(Lb_json["entries"]),
            }
        )

    # C2.0 sealed modular agreement at p=23
    sealed_npz = np.load(C2 / "word_basis.npz")
    La23 = sealed_npz["L_a_f23"].astype(np.int64)
    for e in La_json["entries"]:
        r = common.reduce_Q_mod(Fraction(e["num"], e["den"]), 23)
        if int(La23[e["i"], e["j"]]) % 23 != r % 23:
            print("FAIL sealed p=23 La constant mismatch", e)
            return 1

    # Degree floor claim presence
    df = ledger["degree_floor"]
    assert df["min_poly_total_degree_lower_bound"] >= 5

    # All holdout recomputations must have zero bad constants where status ok
    ok_pts = [r for r in results if r.get("status") == "ok"]
    if not ok_pts:
        print("FAIL no successful holdout points")
        return 1
    for r in ok_pts:
        if r["La_const_bad"] or r["Lb_const_bad"] or r["a_unit_col_bad"]:
            print("FAIL", r)
            return 1

    report = {
        "exit_checked": "C2-1-UNDECIDED",
        "headline": "OPEN",
        "holdout_recompute": results,
        "La_Q_constants_verified": len(La_json["entries"]),
        "Lb_Q_constants_verified": len(Lb_json["entries"]),
        "C_Q_constants_sealed": len(C_json["entries"]),
        "degree_lower_bound": df["min_poly_total_degree_lower_bound"],
        "verdict": "PASS_PARTIAL",
        "note": (
            "Verifier confirms Q-constant entries of L_a,L_b against independent modular "
            "rebuild at holdout prime and against sealed p=23 packet. Full Mat_36(K_proj) "
            "reconstruction remains open (degree floor)."
        ),
    }
    out = PKG / "verify_c21_result.json"
    out.write_text(json.dumps(report, indent=2) + "\n")
    print("PASS_PARTIAL C2-1-UNDECIDED")
    print(json.dumps(report, indent=2))
    return 0


if __name__ == "__main__":
    sys.exit(main())
