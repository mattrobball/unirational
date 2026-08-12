#!/usr/bin/env python3
"""Emit per-entry L*H and N*H identities over K(i)."""
from __future__ import annotations

import argparse
import json
from fractions import Fraction
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def trim(a):
    while a and a[-1] == 0:
        a.pop()
    return a


def add(a, b):
    n = max(len(a), len(b))
    return trim([(a[i] if i < len(a) else 0) + (b[i] if i < len(b) else 0)
                 for i in range(n)])


def sub(a, b):
    return add(a, [-x for x in b])


def mul(a, b):
    if not a or not b:
        return []
    out = [Fraction(0)] * (len(a) + len(b) - 1)
    for i, x in enumerate(a):
        for j, y in enumerate(b):
            out[i + j] += x * y
    return trim(out)


def reduce_phi(a):
    a = a[:] + [Fraction(0)] * max(0, 19 - len(a))
    for n in range(len(a) - 1, 9, -1):
        c = a[n]
        if c:
            a[n] = 0
            for j in range(n - 10, n):
                a[j] -= c
    return (a[:10] + [Fraction(0)] * 10)[:10]


def kdec(x):
    return [Fraction(int(a), int(b)) for a, b in x]


def ldec(cell):
    return kdec(cell["re"]), kdec(cell["im"])


def lmul(x, y):
    a, b = x
    c, d = y
    return (reduce_phi(sub(mul(a, c), mul(b, d))),
            reduce_phi(add(mul(a, d), mul(b, c))))


def ladd(x, y):
    return (reduce_phi(add(x[0], y[0])), reduce_phi(add(x[1], y[1])))


def lzero():
    return ([Fraction(0)] * 10, [Fraction(0)] * 10)


def lone():
    re = [Fraction(0)] * 10
    re[0] = Fraction(1)
    return (re, [Fraction(0)] * 10)


def lmat(rows):
    return [[ldec(c) for c in r] for r in rows]


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--out-dir", type=Path, required=True)
    args = parser.parse_args()
    out = args.out_dir.resolve()
    out.mkdir(parents=True, exist_ok=True)
    data = json.loads((ROOT / "results" / "sigma_plus_segre_Ki.json").read_text())
    H = lmat(data["cross_coordinate_H_9x6"])
    L = lmat(data["left_inverse_L_6x9"])
    N = lmat(data["annihilator_N_3x9"])
    lines = [
        "/-",
        "Auto-generated L*H and N*H identities.",
        "-/",
        "import V14Formalization.D12SigmaPlusSegreMul",
        "",
        "noncomputable section",
        "open Matrix",
        "namespace V14Formalization.D12SigmaPlusSegreData",
        "open D12SigmaPlusSegreCore",
        "",
    ]
    for i in range(6):
        for j in range(6):
            acc = lzero()
            for t in range(9):
                acc = ladd(acc, lmul(L[i][t], H[t][j]))
            want = lone() if i == j else lzero()
            if acc != want:
                raise SystemExit(f"L*H failed {i},{j}")
            rhs = "1" if i == j else "0"
            lines += [
                f"theorem LH_entry_{i}_{j} : (L * H) {i} {j} = {rhs} := by",
                "  simp [Matrix.mul_apply, Finset.sum_univ_succ, L, H,",
                "    ofLadj_mul, ofLadj_add, ofLadj_zero, ofLadj_one]",
                "",
            ]
    lines += [
        "theorem L_mul_H : L * H = 1 := by",
        "  ext i j",
        "  fin_cases i <;> fin_cases j",
    ]
    for i in range(6):
        for j in range(6):
            lines.append(f"  · exact LH_entry_{i}_{j}")
    lines += ["", ""]
    for i in range(3):
        for j in range(6):
            acc = lzero()
            for t in range(9):
                acc = ladd(acc, lmul(N[i][t], H[t][j]))
            if acc != lzero():
                raise SystemExit(f"N*H failed {i},{j}")
            lines += [
                f"theorem NH_entry_{i}_{j} : (N * H) {i} {j} = 0 := by",
                "  simp [Matrix.mul_apply, Finset.sum_univ_succ, N, H,",
                "    ofLadj_mul, ofLadj_add, ofLadj_zero]",
                "",
            ]
    lines += [
        "theorem N_mul_H : N * H = 0 := by",
        "  ext i j",
        "  fin_cases i <;> fin_cases j",
    ]
    for i in range(3):
        for j in range(6):
            lines.append(f"  · exact NH_entry_{i}_{j}")
    lines += [
        "",
        "end V14Formalization.D12SigmaPlusSegreData",
        "",
    ]
    path = out / "D12SigmaPlusSegreData.lean"
    path.write_text("\n".join(lines))
    print("wrote", path)


if __name__ == "__main__":
    main()
