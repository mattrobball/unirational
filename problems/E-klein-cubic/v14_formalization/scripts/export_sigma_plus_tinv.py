#!/usr/bin/env python3
"""Emit K = last three columns of T⁻¹ and the identities L*K=0, N*K=I."""
from __future__ import annotations

import argparse
import hashlib
import json
from fractions import Fraction
from pathlib import Path

import export_sigma_plus_identities as g

ROOT = Path(__file__).resolve().parents[1]
JSON_PATH = ROOT / "results" / "sigma_plus_segre_Ki.json"


def emit_k_core(K) -> list[str]:
    lines = [
        "/-",
        "Last three columns of T⁻¹, the invertible completion of (L; N).",
        "-/",
        "import V14Formalization.D12SigmaPlusSegreEval",
        "",
        "noncomputable section",
        "open Matrix Polynomial",
        "namespace V14Formalization.D12SigmaPlusSegreCore",
        "",
    ]
    for i in range(9):
        for j in range(3):
            re, im = K[i][j]
            lines += [
                f"def K_re_{i}_{j} : Polynomial ℚ := {g.lean_poly(re)}",
                f"def K_im_{i}_{j} : Polynomial ℚ := {g.lean_poly(im)}",
                f"def K_entry_{i}_{j} : Ki := ofLadj K_re_{i}_{j} K_im_{i}_{j}",
                "",
            ]
    lines += [
        "def K : Matrix (Fin 9) (Fin 3) Ki :=",
        "  Matrix.of fun i j =>",
        "    match i.val, j.val with",
    ]
    for i in range(9):
        for j in range(3):
            lines.append(f"    | {i}, {j} => K_entry_{i}_{j}")
    lines += [
        "    | _, _ => K_entry_0_0",
        "",
        "end V14Formalization.D12SigmaPlusSegreCore",
        "",
    ]
    return lines


# ---------------------------------------------------------------------------
# STALE EMITTER GUARD (2026-08-18)
#
# This emitter still produces the proofs its outputs had BEFORE the
# integer-interpolation (`interpQ`) rewrite and before `ring` -> `grind`.
# Running it over V14Formalization/ reverts both, and additionally writes
# hundreds of files that are no longer part of the tree.  Measured on
# 2026-08-18: 273 tracked files rewritten backwards, plus 378 files
# created across the three stale emitters that the build does not use.
#
# The in-tree sources are the authority for these families.  To change their
# proofs, use a statement-preserving post-pass instead:
#     scripts/ring_to_grind_rewrite.py
#     scripts/table_interface_rewrite.py
#     scripts/change_to_rewrite.py
#
# If you have re-derived this emitter so that it round-trips, prove it: emit
# into a scratch directory, diff against V14Formalization/, and only then pass
# --emitter-is-current to re-enable it.
# ---------------------------------------------------------------------------
_STALE_MESSAGE = """
export_sigma_plus_tinv.py is STALE and refuses to run.

Its output would revert the interpQ rewrite and the grind rewrite, and would
add files the tree no longer contains.  See MODULE_MIGRATION.md, "THREE
EMITTERS ARE STALE".  Use a post-pass on the in-tree sources instead.

Re-enable only after demonstrating a byte-identical round-trip, with
--emitter-is-current.
"""


def _refuse_if_stale() -> None:
    import sys as _sys
    if "--emitter-is-current" in _sys.argv:
        _sys.argv.remove("--emitter-is-current")
        return
    _sys.stderr.write(_STALE_MESSAGE.format(name="export_sigma_plus_tinv.py"))
    raise SystemExit(2)


def main():
    _refuse_if_stale()
    parser = argparse.ArgumentParser()
    parser.add_argument("--out-dir", type=Path, required=True)
    parser.add_argument("--only", type=str, default="")
    args = parser.parse_args()
    out = args.out_dir.resolve()
    out.mkdir(parents=True, exist_ok=True)
    data = json.loads(JSON_PATH.read_text())
    L = g.lmat(data["left_inverse_L_6x9"])
    N = g.lmat(data["annihilator_N_3x9"])
    Tinv = g.lmat(data["completion_T_inv"])
    K = [[Tinv[i][6 + j] for j in range(3)] for i in range(9)]
    only = args.only

    if only in ("", "K", "apply"):
        (out / "D12SigmaPlusSegreK.lean").write_text("\n".join(emit_k_core(K)))
        apply = g.header_import(
            ["import V14Formalization.D12SigmaPlusSegreK"])
        for i in range(9):
            for j in range(3):
                apply += [
                    f"theorem K_apply_{i}_{j} :",
                    f"    K ({i} : Fin 9) ({j} : Fin 3) = K_entry_{i}_{j} := by",
                    "  unfold K",
                    "  simp [Matrix.of_apply]",
                    "",
                ]
        apply += g.footer()
        (out / "D12SigmaPlusSegreApplyK.lean").write_text("\n".join(apply))
        print("wrote K and ApplyK")

    lk_pairs = []
    for i in range(6):
        for j in range(3):
            acc_re, acc_im, terms = [], [], []
            for t in range(9):
                pre, pim = g.lmul_raw(L[i][t], K[t][j])
                terms.append((pre, pim))
                acc_re = g.add(acc_re, pre)
                acc_im = g.add(acc_im, pim)
            qre, rre = g.divmod_phi(acc_re)
            qim, rim = g.divmod_phi(acc_im)
            if rre != [Fraction(0)] * 10 or rim != [Fraction(0)] * 10:
                raise SystemExit(f"L*K remainder failed at {i},{j}: {rre},{rim}")
            lk_pairs.append((i, j))
            tag = f"LK_{i}_{j}"
            if only in ("", tag):
                path = out / f"D12SigmaPlusSegreLK_{i}_{j}.lean"
                path.write_text("\n".join(g.emit_entry(
                    "LK", "L", "K", i, j, 9, terms, qre, qim, rre, rim, False,
                    mul_lemma="mul_apply_fin9_LK")))
                print("wrote", path.name)

    nk_pairs = []
    for i in range(3):
        for j in range(3):
            acc_re, acc_im, terms = [], [], []
            for t in range(9):
                pre, pim = g.lmul_raw(N[i][t], K[t][j])
                terms.append((pre, pim))
                acc_re = g.add(acc_re, pre)
                acc_im = g.add(acc_im, pim)
            qre, rre = g.divmod_phi(acc_re)
            qim, rim = g.divmod_phi(acc_im)
            want = ([Fraction(1)] + [Fraction(0)] * 9, [Fraction(0)] * 10) if i == j else (
                [Fraction(0)] * 10, [Fraction(0)] * 10)
            if rre != want[0] or rim != want[1]:
                raise SystemExit(f"N*K remainder failed at {i},{j}: {rre},{rim}")
            nk_pairs.append((i, j))
            tag = f"NK_{i}_{j}"
            if only in ("", tag):
                path = out / f"D12SigmaPlusSegreNK_{i}_{j}.lean"
                path.write_text("\n".join(g.emit_entry(
                    "NK", "N", "K", i, j, 9, terms, qre, qim, rre, rim, i == j,
                    mul_lemma="mul_apply_fin9_NK")))
                print("wrote", path.name)

    if only == "":
        lines = ["/-", "L*K = 0 and N*K = 1, so T = (L;N) is invertible.", "-/"]
        for i, j in lk_pairs:
            lines.append(f"import V14Formalization.D12SigmaPlusSegreLK_{i}_{j}")
        for i, j in nk_pairs:
            lines.append(f"import V14Formalization.D12SigmaPlusSegreNK_{i}_{j}")
        lines += [
            "",
            "noncomputable section",
            "open Matrix",
            "namespace V14Formalization.D12SigmaPlusSegreData",
            "open D12SigmaPlusSegreCore",
            "",
            "theorem L_mul_K : L * K = 0 := by",
            "  ext i j",
            "  fin_cases i <;> fin_cases j",
        ]
        for i, j in lk_pairs:
            lines.append(f"  · exact LK_entry_{i}_{j}")
        lines += [
            "",
            "theorem N_mul_K : N * K = 1 := by",
            "  ext i j",
            "  fin_cases i <;> fin_cases j",
        ]
        for i, j in nk_pairs:
            lines.append(f"  · exact NK_entry_{i}_{j}")
        lines += [
            "",
            "end V14Formalization.D12SigmaPlusSegreData",
            "",
        ]
        path = out / "D12SigmaPlusSegreTinv.lean"
        path.write_text("\n".join(lines))
        print("wrote", path.name)
    print("json_sha", hashlib.sha256(JSON_PATH.read_bytes()).hexdigest())


if __name__ == "__main__":
    main()
