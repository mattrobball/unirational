#!/usr/bin/env python3
"""Emit bounded rational-vector data for the D12 character pieces.

The generated Lean arithmetic uses the ten-coordinate cyclotomic model in
`D12CyclotomicVec`.  This exporter never asks Lean to normalize one large
polynomial expression: every matrix coefficient is exposed separately.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import math
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_JSON = ROOT / "results" / "d12_lean_K.json"


def write_if_changed(path: Path, text: str) -> None:
    if path.exists() and path.read_text() == text:
        return
    path.write_text(text)


def q(pair: list[int]) -> str:
    num, den = pair
    if num == 0:
        return "0"
    if den == 1:
        return str(num)
    return f"({num} / {den} : ℚ)"


def vec(entry: list[list[int]]) -> str:
    assert len(entry) == 10
    return "![" + ", ".join(q(x) for x in entry) + "]"


def as_fractions(entry: list[list[int]]) -> list[Fraction]:
    return [Fraction(num, den) for num, den in entry]


def raw_conv(a: list[Fraction], b: list[Fraction], n: int) -> Fraction:
    return sum((a[i] * b[n - i]
                for i in range(10) if 0 <= n - i < 10), Fraction())


def reduced_mul(a: list[Fraction], b: list[Fraction]) -> list[Fraction]:
    c10 = raw_conv(a, b, 10)
    return [raw_conv(a, b, k) + raw_conv(a, b, k + 11) - c10
            for k in range(10)]


def add_vectors(vs: list[list[Fraction]]) -> list[Fraction]:
    return [sum((v[i] for v in vs), Fraction()) for i in range(10)]


def vec_fractions(v: list[Fraction]) -> str:
    return "![" + ", ".join(q_fraction(x) for x in v) + "]"


def q_fraction(x: Fraction) -> str:
    return q([x.numerator, x.denominator])


def lcm_denoms(vecs: list[list[Fraction]]) -> int:
    acc = 1
    for vec in vecs:
        for value in vec:
            acc = math.lcm(acc, value.denominator)
    return acc


def scale_ints(vec: list[Fraction], scale: int) -> list[int]:
    out: list[int] = []
    for value in vec:
        scaled = value * scale
        if scaled.denominator != 1:
            raise ValueError(f"scale {scale} does not clear {value}")
        out.append(int(scaled.numerator))
    return out


def vecz_lit(ints: list[int]) -> str:
    return "#v[" + ", ".join(str(n) for n in ints) + "]"


def emit_vecz_match(name: str, count: int, rows: list[list[int]]) -> list[str]:
    lines = [f"def {name} (k : Fin {count}) : VecZ :=", "  match k.val with"]
    for index, row in enumerate(rows):
        lines.append(f"  | {index} => {vecz_lit(row)}")
    lines += ["  | _ => zeroZ", ""]
    return lines


def emit_coord_case(n: int, value: Fraction) -> list[str]:
    if value == 0:
        return [
            f"  · change (({n} : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)",
            "    exact eq_smul_zero scale",
        ]
    if value.denominator == 1:
        return [
            f"  · change (({n} : ℤ) : ℚ) = (scale : ℚ) * ({value.numerator} : ℚ)",
            f"    exact eq_smul_int ({n}) scale ({value.numerator}) (by decide)",
        ]
    return [
        f"  · change (({n} : ℤ) : ℚ) = (scale : ℚ) * "
        f"({value.numerator} / {value.denominator} : ℚ)",
        f"    exact eq_smul_div ({n}) scale ({value.numerator}) "
        f"({value.denominator}) (by decide) (by decide)",
    ]


def emit_scale_thm(thm: str, fn: str, rhs: str, cells: list[str],
                   matrix_simps: list[str], scaled_rows: list[list[int]],
                   frac_rows: list[list[Fraction]]) -> list[str]:
    lines: list[str] = []
    for index, cell in enumerate(cells):
        lines += [
            f"theorem {thm}_{index} : toVec ({fn} {index}) = (scale : ℚ) • {cell} := by",
            "  funext i",
            "  fin_cases i",
        ]
        for n, value in zip(scaled_rows[index], frac_rows[index], strict=True):
            lines += emit_coord_case(n, value)
        lines.append("")
    count = len(cells)
    lines += [
        f"theorem {thm} (k : Fin {count}) :",
        f"    toVec ({fn} k) = {rhs} := by",
        "  fin_cases k",
    ]
    for index, matrix_simp in enumerate(matrix_simps):
        lines.append(f"  · simp [{matrix_simp}]; exact {thm}_{index}")
    lines.append("")
    return lines


def emit_mul_sum(tag: str, left_fn: str, right_fn: str,
                 lefts: list[list[Fraction]], rights: list[list[Fraction]],
                 scale: int) -> tuple[list[str], list[int]]:
    sq = scale * scale
    lines: list[str] = []
    lits: list[list[int]] = []
    count = len(lefts)
    for index, (left, right) in enumerate(zip(lefts, rights, strict=True)):
        ints = scale_ints(reduced_mul(left, right), sq)
        lits.append(ints)
        lines += [
            f"theorem {tag}MulZ{index} :",
            f"    mulZ ({left_fn} {index}) ({right_fn} {index}) = {vecz_lit(ints)} := by",
            "  decide",
            "",
        ]
    total = [sum(col) for col in zip(*lits)] if lits else [0] * 10
    lines += [f"def {tag}Muls (k : Fin {count}) : VecZ :=", "  match k.val with"]
    for index, ints in enumerate(lits):
        lines.append(f"  | {index} => {vecz_lit(ints)}")
    lines += [
        "  | _ => zeroZ",
        "",
        f"theorem {tag}MulZ (k : Fin {count}) :",
        f"    mulZ ({left_fn} k) ({right_fn} k) = {tag}Muls k := by",
        "  fin_cases k",
    ]
    for index in range(count):
        lines.append(f"  · exact {tag}MulZ{index}")
    lines += [
        "",
        f"theorem {tag}Sum_eq :",
        f"    sumFin (fun k => mulZ ({left_fn} k) ({right_fn} k)) = {vecz_lit(total)} := by",
        f"  have h : sumFin (fun k => mulZ ({left_fn} k) ({right_fn} k)) =",
        f"      sumFin {tag}Muls := congrArg sumFin (funext {tag}MulZ)",
        "  rw [h]",
        "  decide",
        "",
    ]
    return lines, total


def emit_htarget(diagonal: bool) -> list[str]:
    if diagonal:
        return ["  rw [entryZ_eq, toVec_scaleSqE0, constVec_one_eq]"]
    return ["  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]"]


def row_def(name: str, row: list[list[list[int]]], cols: int) -> list[str]:
    assert len(row) == cols
    out = [f"def {name} (j : Fin {cols}) : Vec :=", "  match j.val with"]
    for j, entry in enumerate(row):
        out.append(f"  | {j} => {vec(entry)}")
    out.append("  | _ => 0")
    return out


def scalar_vec_def(name: str, entry: list[Fraction]) -> list[str]:
    assert len(entry) == 10
    out = [f"def {name} (i : Fin 10) : ℚ :=", "  match i.val with"]
    for i, value in enumerate(entry):
        out.append(f"  | {i} => {q_fraction(value)}")
    out.append("  | _ => 0")
    return out


def emit_base(payload_sha: str) -> str:
    lines = [
        "/-",
        "  D12 character-piece rational-vector action base.",
        "  Auto-generated by scripts/export_d12_piece_vec_lean.py.",
        f"  Payload sha256: {payload_sha}",
        "-/",
        "import V14Formalization.D12CyclotomicVec",
        "import V14Formalization.D12PieceAction",
        "import V14Formalization.D12PolynomialRM",
        "import V14Formalization.D12PolynomialSM",
        "",
        "noncomputable section",
        "",
        "open Matrix Polynomial",
        "",
        "namespace V14Formalization.D12PieceVecBase",
        "",
        "open D12CyclotomicVec D12PolynomialData D12PolynomialEvaluation",
        "",
        "theorem eval_of10 (v : Coeff10) :",
        "    D12CyclotomicVec.eval v = evalK (of10 v) := by",
        "  unfold D12CyclotomicVec.eval",
        "  simp [evalK, evalPolyAt, of10, map_sum, map_mul, map_pow, aeval_def]",
        "",
    ]
    for prefix in ("RM", "SM"):
        for i in range(10):
            lines += [
                f"def {prefix}VecRow{i} (j : Fin 10) : Vec :=",
                "  match j.val with",
            ]
            for j in range(10):
                lines.append(f"  | {j} => {prefix}{i}c{j}")
            lines += ["  | _ => 0", ""]
        lines += [
            f"def {prefix}Vec : Matrix (Fin 10) (Fin 10) Vec :=",
            "  fun i j => match i.val with",
        ]
        for i in range(10):
            lines.append(f"  | {i} => {prefix}VecRow{i} j")
        lines += ["  | _ => 0", ""]
        for i in range(10):
            lines += [
                f"theorem {prefix}VecRow{i}_of10 (j : Fin 10) :",
                f"    of10 ({prefix}VecRow{i} j) = {prefix}row{i} j := by",
                "  fin_cases j <;> rfl",
                "",
            ]
        lines += [
            f"theorem {prefix}Vec_of10 (i j : Fin 10) :",
            f"    of10 ({prefix}Vec i j) = {prefix}_poly i j := by",
            "  fin_cases i",
        ]
        for i in range(10):
            lines.append(
                f"  · exact {prefix}VecRow{i}_of10 j"
            )
        lines += [
            "",
            f"theorem evalMatrix_{prefix}Vec :",
            f"    evalMatrix {prefix}Vec = evalMatrixK {prefix}_poly := by",
            "  ext i j",
            f"  change D12CyclotomicVec.eval ({prefix}Vec i j) =",
            f"    evalK ({prefix}_poly i j)",
            f"  rw [eval_of10, {prefix}Vec_of10]",
            "",
        ]
    lines += [
        "def characterStackVec",
        "    (RM SM : Matrix (Fin 10) (Fin 10) Vec) (r s : ℚ) :",
        "    Matrix (Fin 20) (Fin 10) Vec :=",
        "  fun i j =>",
        "    Fin.addCases",
        "      (fun a : Fin 10 => RM a j - if a = j then constVec r else 0)",
        "      (fun b : Fin 10 => SM b j - if b = j then constVec s else 0)",
        "      (i : Fin (10 + 10))",
        "",
        "theorem eval_characterStackVec",
        "    (RM SM : Matrix (Fin 10) (Fin 10) Vec) (r s : ℚ) :",
        "    evalMatrix (characterStackVec RM SM r s) =",
        "      D12PieceAction.characterStack (evalMatrix RM) (evalMatrix SM)",
        "        (algebraMap ℚ WeilRep.K r) (algebraMap ℚ WeilRep.K s) := by",
        "  ext i j",
        "  change D12CyclotomicVec.eval",
        "      (Fin.addCases",
        "        (fun a : Fin 10 => RM a j - if a = j then constVec r else 0)",
        "        (fun b : Fin 10 => SM b j - if b = j then constVec s else 0) i) =",
        "    Fin.addCases",
        "      (fun a : Fin 10 => D12CyclotomicVec.eval (RM a j) -",
        "        if a = j then algebraMap ℚ WeilRep.K r else 0)",
        "      (fun b : Fin 10 => D12CyclotomicVec.eval (SM b j) -",
        "        if b = j then algebraMap ℚ WeilRep.K s else 0) i",
        "  refine Fin.addCases (m := 10) (n := 10)",
        "    (fun a => ?_) (fun b => ?_) (i : Fin (10 + 10))",
        "  · simp only [Fin.addCases_left]",
        "    by_cases h : a = j <;>",
        "      simp [h, D12CyclotomicVec.eval_sub]",
        "  · simp only [Fin.addCases_right]",
        "    by_cases h : b = j <;>",
        "      simp [h, D12CyclotomicVec.eval_sub]",
        "",
        "end V14Formalization.D12PieceVecBase",
        "",
    ]
    return "\n".join(lines)


def emit_pa_probe(payload: dict, payload_sha: str) -> str:
    x = payload["pieces"]["PA"]["X10x20"]
    a = payload["pieces"]["PA"]["A20x10"]
    products00 = [
        reduced_mul(as_fractions(x[0][k]), as_fractions(a[k][0]))
        for k in range(20)
    ]
    total00 = add_vectors(products00)
    assert total00 == [Fraction(1)] + [Fraction()] * 9
    lines = [
        "/- Bounded PA split-identity probe. -/",
        "import V14Formalization.D12PieceVecBase",
        "",
        "noncomputable section",
        "open Matrix",
        "namespace V14Formalization.D12PiecePAProbe",
        "open D12CyclotomicVec D12PieceVecBase",
        f'def payloadSha256 : String := "{payload_sha}"',
        "",
    ]
    for i, row in enumerate(x):
        for j, entry in enumerate(row):
            lines += scalar_vec_def(f"XCell{i}_{j}", as_fractions(entry)) + [""]
        lines += [f"def XRow{i} (j : Fin 20) : Vec :=", "  match j.val with"]
        for j in range(20):
            lines.append(f"  | {j} => XCell{i}_{j}")
        lines += ["  | _ => 0", ""]
    for i, row in enumerate(a):
        for j, entry in enumerate(row):
            lines += scalar_vec_def(f"ACell{i}_{j}", as_fractions(entry)) + [""]
        lines += [f"def ARow{i} (j : Fin 10) : Vec :=", "  match j.val with"]
        for j in range(10):
            lines.append(f"  | {j} => ACell{i}_{j}")
        lines += ["  | _ => 0", ""]
    lines += [
        "def XVec : Matrix (Fin 10) (Fin 20) Vec :=",
        "  fun i j => match i.val with",
    ]
    for i in range(10):
        lines.append(f"  | {i} => XRow{i} j")
    lines += [
        "  | _ => 0",
        "",
        "def AVec : Matrix (Fin 20) (Fin 10) Vec :=",
        "  fun i j => match i.val with",
    ]
    for i in range(20):
        lines.append(f"  | {i} => ARow{i} j")
    lines += [
        "  | _ => 0",
        "",
    ]
    for k in range(20):
        xk = as_fractions(x[0][k])
        lines += [f"def product00_{k} : Vec := mul XCell0_{k} ACell{k}_0", ""]
        if all(value == 0 for value in xk):
            lines += [
                f"theorem XCell0_{k}_eq_zero : XCell0_{k} = 0 := by",
                "  funext n",
                "  fin_cases n <;> rfl",
                "",
                f"theorem product00_{k}_eq : product00_{k} = 0 := by",
                f"  rw [product00_{k}, XCell0_{k}_eq_zero, mul_zero_left]",
                "",
            ]
        else:
            lines += scalar_vec_def(f"productValue00_{k}", products00[k]) + [""]
            for degree, value in enumerate(products00[k]):
                lines += [
                    f"theorem product00_{k}_apply_{degree} :",
                    f"    product00_{k} ({degree} : Fin 10) =",
                    f"      productValue00_{k} ({degree} : Fin 10) := by",
                    f"  norm_num [product00_{k}, productValue00_{k}, XCell0_{k}, ACell{k}_0,",
                    "    mul, conv, coeffAt, Fin.sum_univ_succ]",
                    "",
                ]
            lines += [
                f"theorem product00_{k}_eq :",
                f"    product00_{k} = productValue00_{k} := by",
                "  funext n",
                "  fin_cases n",
            ]
            for degree in range(10):
                lines.append(f"  · exact product00_{k}_apply_{degree}")
            lines.append("")
        lines += [
            f"theorem matrixProduct00_{k}_eq :",
            f"    mul (XVec 0 ({k} : Fin 20)) (AVec ({k} : Fin 20) 0) =",
            f"      {'0' if all(value == 0 for value in products00[k]) else f'productValue00_{k}'} := by",
            f"  change product00_{k} = _",
            f"  exact product00_{k}_eq",
            "",
        ]
    lines += [
        "def productResult00 (k : Fin 20) : Vec :=",
        "  match k.val with",
    ]
    for k in range(20):
        result = "0" if all(value == 0 for value in products00[k]) else f"productValue00_{k}"
        lines.append(f"  | {k} => {result}")
    lines += [
        "  | _ => 0",
        "",
        "theorem matrixProduct00 (k : Fin 20) :",
        "    mul (XVec 0 k) (AVec k 0) = productResult00 k := by",
        "  fin_cases k",
    ]
    for k in range(20):
        lines.append(f"  · exact matrixProduct00_{k}_eq")
    lines += [
        "",
    ]
    value_names = [f"productValue00_{k}" for k in range(20)
                   if not all(value == 0 for value in products00[k])]
    for degree, value in enumerate(total00):
        lines += [
            f"theorem productResult00_sum_apply_{degree} :",
            f"    (∑ k : Fin 20, productResult00 k) ({degree} : Fin 10) =",
            f"      {q_fraction(value)} := by",
            "  norm_num [productResult00, Fin.sum_univ_succ,",
        ]
        for idx, name in enumerate(value_names):
            suffix = "," if idx < len(value_names) - 1 else "]"
            lines.append(f"    {name}{suffix}")
        lines.append("")
    lines += [
        "theorem productResult00_sum_eq :",
        f"    (∑ k : Fin 20, productResult00 k) = {vec_fractions(total00)} := by",
        "  funext n",
        "  fin_cases n",
    ]
    for degree in range(10):
        lines.append(f"  · exact productResult00_sum_apply_{degree}")
    lines += [
        "",
        "def splitEntry00 : Vec := (matrixMul XVec AVec) 0 0",
        "",
        "theorem splitEntry00_eq :",
        f"    splitEntry00 = {vec_fractions(total00)} := by",
        "  unfold splitEntry00 matrixMul",
        "  calc",
        "    (∑ k : Fin 20, mul (XVec 0 k) (AVec k 0)) =",
        "        ∑ k : Fin 20, productResult00 k := by",
        "      apply Finset.sum_congr rfl",
        "      intro k _",
        "      exact matrixProduct00 k",
        "    _ = _ := productResult00_sum_eq",
    ]
    lines.append("")
    lines += [
        "end V14Formalization.D12PiecePAProbe",
        "",
    ]
    return "\n".join(lines)


def emit_pa_data(payload: dict, payload_sha: str) -> str:
    x = payload["pieces"]["PA"]["X10x20"]
    a = payload["pieces"]["PA"]["A20x10"]
    lines = [
        "/- PA vector data. Auto-generated; arithmetic lives in entry shards. -/",
        "import V14Formalization.D12PieceVecBase",
        "",
        "noncomputable section",
        "open Matrix",
        "namespace V14Formalization.D12PiecePAData",
        "open D12CyclotomicVec D12PieceVecBase",
        f'def payloadSha256 : String := "{payload_sha}"',
        "",
    ]
    for i, row in enumerate(x):
        for j, entry in enumerate(row):
            lines += scalar_vec_def(f"XCell{i}_{j}", as_fractions(entry)) + [""]
        lines += [f"def XRow{i} (j : Fin 20) : Vec :=", "  match j.val with"]
        for j in range(20):
            lines.append(f"  | {j} => XCell{i}_{j}")
        lines += ["  | _ => 0", ""]
    for i, row in enumerate(a):
        for j, entry in enumerate(row):
            lines += scalar_vec_def(f"ACell{i}_{j}", as_fractions(entry)) + [""]
        lines += [f"def ARow{i} (j : Fin 10) : Vec :=", "  match j.val with"]
        for j in range(10):
            lines.append(f"  | {j} => ACell{i}_{j}")
        lines += ["  | _ => 0", ""]
    lines += [
        "def XVec : Matrix (Fin 10) (Fin 20) Vec :=",
        "  fun i j => match i.val with",
    ]
    for i in range(10):
        lines.append(f"  | {i} => XRow{i} j")
    lines += ["  | _ => 0", "", "def AVec : Matrix (Fin 20) (Fin 10) Vec :=",
              "  fun i j => match i.val with"]
    for i in range(20):
        lines.append(f"  | {i} => ARow{i} j")
    lines += ["  | _ => 0", "", "end V14Formalization.D12PiecePAData", ""]
    return "\n".join(lines)


def emit_pa_entry(payload: dict, payload_sha: str, row: int, col: int,
                  direct_products: bool = False,
                  grouped_products: bool = False) -> str:
    del direct_products, grouped_products
    assert 0 <= row < 10 and 0 <= col < 10
    x = payload["pieces"]["PA"]["X10x20"]
    a = payload["pieces"]["PA"]["A20x10"]
    xs = [as_fractions(x[row][k]) for k in range(20)]
    a_cols = [as_fractions(a[k][col]) for k in range(20)]
    products = [reduced_mul(xs[k], a_cols[k]) for k in range(20)]
    total = add_vectors(products)
    expected = [Fraction(int(row == col))] + [Fraction()] * 9
    assert total == expected
    scale = lcm_denoms(xs + a_cols)
    x_scaled = [scale_ints(v, scale) for v in xs]
    a_scaled = [scale_ints(v, scale) for v in a_cols]
    ns = f"D12PiecePASplitEntry{row}_{col}"
    expected_z = "scaleSqE0 scale" if row == col else "zeroZ"
    lines = [
        f"/- PA split identity, entry ({row},{col}). Auto-generated. -/",
        "import V14Formalization.D12PiecePAData",
        "import V14Formalization.D12CyclotomicVecZ",
        "",
        "noncomputable section",
        "open Matrix",
        f"namespace V14Formalization.{ns}",
        "open D12CyclotomicVec D12CyclotomicVecZ D12PiecePAData",
        f'def payloadSha256 : String := "{payload_sha}"',
        "",
        f"def scale : ℤ := {scale}",
        "",
    ]
    lines += emit_vecz_match("XZ", 20, x_scaled)
    lines += emit_vecz_match("AZ", 20, a_scaled)
    mul_lines, _xa_ints = emit_mul_sum("xa", "XZ", "AZ", xs, a_cols, scale)
    lines += mul_lines
    lines += [
        "def entryZ : VecZ := sumFin (fun k => mulZ (XZ k) (AZ k))",
        "",
        f"theorem entryZ_eq : entryZ = {expected_z} := by",
        "  unfold entryZ",
        "  rw [xaSum_eq]",
        "  decide",
        "",
        "theorem scale_ne_zero : scale ≠ 0 := by",
        "  decide",
        "",
    ]
    lines += emit_scale_thm(
        "XZ_scale", "XZ",
        f"(scale : ℚ) • XVec ({row} : Fin 10) k",
        [f"XCell{row}_{k}" for k in range(20)],
        [f"XVec, XRow{row}"] * 20, x_scaled, xs)
    lines += emit_scale_thm(
        "AZ_scale", "AZ",
        f"(scale : ℚ) • AVec k ({col} : Fin 10)",
        [f"ACell{k}_{col}" for k in range(20)],
        [f"AVec, ARow{k}" for k in range(20)], a_scaled, a_cols)
    lines += [
        "theorem entry_eq :",
        f"    (matrixMul XVec AVec) ({row} : Fin 10) ({col} : Fin 10) =",
        f"      {vec_fractions(total)} := by",
        "  unfold matrixMul",
        "  refine sum_mul_eq_of_scaled scale scale_ne_zero",
        f"    (fun k => XVec ({row} : Fin 10) k)",
        f"    (fun k => AVec k ({col} : Fin 10))",
        "    XZ AZ XZ_scale AZ_scale entryZ rfl _ ?_",
    ]
    lines += emit_htarget(row == col)
    lines += [
        "",
        "theorem entry_eq_matrixOne :",
        f"    (matrixMul XVec AVec) ({row} : Fin 10) ({col} : Fin 10) =",
        f"      matrixOne (Fin 10) ({row} : Fin 10) ({col} : Fin 10) := by",
        "  rw [entry_eq]",
    ]
    if row != col:
        lines += [
            f"  have hne : ({row} : Fin 10) ≠ ({col} : Fin 10) := by decide",
        ]
    lines += [
        "  funext n",
        "  fin_cases n <;> simp [matrixOne, *]",
        "",
        f"end V14Formalization.{ns}",
        "",
    ]
    return "\n".join(lines)


def emit_pa_row(row: int) -> str:
    assert 0 <= row < 10
    ns = f"D12PiecePASplitRow{row}"
    lines = [f"/- PA split identity, row {row}. Auto-generated. -/"]
    for col in range(10):
        lines.append(f"import V14Formalization.D12PiecePASplitEntry{row}_{col}")
    lines += [
        "",
        "noncomputable section",
        f"namespace V14Formalization.{ns}",
        "open D12CyclotomicVec D12PiecePAData",
        "",
        "theorem row_eq (j : Fin 10) :",
        f"    (matrixMul XVec AVec) ({row} : Fin 10) j =",
        f"      matrixOne (Fin 10) ({row} : Fin 10) j := by",
        "  fin_cases j",
    ]
    for col in range(10):
        lines.append(
            f"  · exact D12PiecePASplitEntry{row}_{col}.entry_eq_matrixOne"
        )
    lines += ["", f"end V14Formalization.{ns}", ""]
    return "\n".join(lines)


def emit_pa_full() -> str:
    lines = ["/- Complete PA split identity. Auto-generated structural assembly. -/"]
    for row in range(10):
        lines.append(f"import V14Formalization.D12PiecePASplitRow{row}")
    lines += [
        "",
        "noncomputable section",
        "namespace V14Formalization.D12PiecePASplit",
        "open D12CyclotomicVec D12PiecePAData",
        "",
        "theorem split_identity : matrixMul XVec AVec = matrixOne (Fin 10) := by",
        "  apply Matrix.ext",
        "  intro i j",
        "  fin_cases i",
    ]
    for row in range(10):
        lines.append(f"  · exact D12PiecePASplitRow{row}.row_eq j")
    lines += ["", "end V14Formalization.D12PiecePASplit", ""]
    return "\n".join(lines)


def emit_pa_action_row(row: int) -> str:
    assert 0 <= row < 20
    ns = f"D12PiecePAActionRow{row}"
    is_rot = row < 10
    block_row = row if is_rot else row - 10
    prefix = "RM" if is_rot else "SM"
    lines = [
        f"/- PA character-stack identification, row {row}. Auto-generated. -/",
        "import V14Formalization.D12PiecePAData",
        "",
        "noncomputable section",
        f"namespace V14Formalization.{ns}",
        "open D12CyclotomicVec D12PieceVecBase D12PiecePAData",
        "",
    ]
    for col in range(10):
        diagonal = block_row == col
        correction = "constVec 1" if is_rot else "constVec (-1)"
        if not diagonal:
            correction = "0"
        lines += [
            f"theorem entry{col} :",
            f"    AVec ({row} : Fin 20) ({col} : Fin 10) =",
            "      characterStackVec RMVec SMVec 1 (-1)",
            f"        ({row} : Fin 20) ({col} : Fin 10) := by",
            f"  change ACell{row}_{col} = {prefix}Vec {block_row} {col} - {correction}",
            "  funext n",
            "  fin_cases n <;>",
            f"    norm_num [ACell{row}_{col}, {prefix}Vec, {prefix}VecRow{block_row},",
            f"      D12PolynomialData.{prefix}{block_row}c{col}, constVec, basis]",
            "",
        ]
    lines += [
        "theorem row_eq (j : Fin 10) :",
        f"    AVec ({row} : Fin 20) j =",
        f"      characterStackVec RMVec SMVec 1 (-1) ({row} : Fin 20) j := by",
        "  fin_cases j",
    ]
    for col in range(10):
        lines.append(f"  · exact entry{col}")
    lines += ["", f"end V14Formalization.{ns}", ""]
    return "\n".join(lines)


def emit_pa_action_full() -> str:
    lines = ["/- PA literal action matrix equals the generic character stack. -/"]
    for row in range(20):
        lines.append(f"import V14Formalization.D12PiecePAActionRow{row}")
    lines += [
        "",
        "noncomputable section",
        "namespace V14Formalization.D12PiecePAAction",
        "open D12PieceVecBase D12PiecePAData",
        "",
        "theorem action_matrix :",
        "    AVec = characterStackVec RMVec SMVec 1 (-1) := by",
        "  apply Matrix.ext",
        "  intro i j",
        "  fin_cases i",
    ]
    for row in range(20):
        lines.append(f"  · exact D12PiecePAActionRow{row}.row_eq j")
    lines += ["", "end V14Formalization.D12PiecePAAction", ""]
    return "\n".join(lines)


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--json", type=Path, default=DEFAULT_JSON)
    ap.add_argument("--base-out", type=Path)
    ap.add_argument("--pa-probe-out", type=Path)
    ap.add_argument("--pa-data-out", type=Path)
    ap.add_argument("--pa-entry-out", type=Path)
    ap.add_argument("--pa-entry", nargs=2, type=int, metavar=("ROW", "COL"))
    ap.add_argument("--pa-entry-direct", action="store_true")
    ap.add_argument("--pa-entry-grouped", action="store_true")
    ap.add_argument("--pa-row-dir", type=Path)
    ap.add_argument("--pa-row", type=int)
    ap.add_argument("--pa-all-dir", type=Path)
    ap.add_argument("--pa-action-dir", type=Path)
    args = ap.parse_args()
    raw = args.json.read_bytes()
    payload_sha = hashlib.sha256(raw).hexdigest()
    payload = json.loads(raw)
    if args.base_out:
        write_if_changed(args.base_out, emit_base(payload_sha))
    if args.pa_probe_out:
        write_if_changed(args.pa_probe_out, emit_pa_probe(payload, payload_sha))
    if args.pa_data_out:
        write_if_changed(args.pa_data_out, emit_pa_data(payload, payload_sha))
    if args.pa_entry_out:
        if args.pa_entry is None:
            ap.error("--pa-entry-out requires --pa-entry ROW COL")
        write_if_changed(args.pa_entry_out,
            emit_pa_entry(payload, payload_sha, args.pa_entry[0], args.pa_entry[1],
                          args.pa_entry_direct, args.pa_entry_grouped))
    if args.pa_row_dir:
        if args.pa_row is None:
            ap.error("--pa-row-dir requires --pa-row ROW")
        row = args.pa_row
        for col in range(10):
            path = args.pa_row_dir / f"D12PiecePASplitEntry{row}_{col}.lean"
            write_if_changed(path, emit_pa_entry(payload, payload_sha, row, col))
        row_path = args.pa_row_dir / f"D12PiecePASplitRow{row}.lean"
        write_if_changed(row_path, emit_pa_row(row))
    if args.pa_all_dir:
        for row in range(10):
            for col in range(10):
                path = args.pa_all_dir / f"D12PiecePASplitEntry{row}_{col}.lean"
                write_if_changed(path, emit_pa_entry(payload, payload_sha, row, col))
            row_path = args.pa_all_dir / f"D12PiecePASplitRow{row}.lean"
            write_if_changed(row_path, emit_pa_row(row))
        write_if_changed(args.pa_all_dir / "D12PiecePASplit.lean", emit_pa_full())
    if args.pa_action_dir:
        for row in range(20):
            path = args.pa_action_dir / f"D12PiecePAActionRow{row}.lean"
            write_if_changed(path, emit_pa_action_row(row))
        write_if_changed(args.pa_action_dir / "D12PiecePAAction.lean",
                         emit_pa_action_full())


if __name__ == "__main__":
    main()
    __import__("sys").path.insert(0, __import__("os").path.dirname(__import__("os").path.abspath(__file__)))
    from module_annotation_hook import reapply_module_annotations
    reapply_module_annotations()
