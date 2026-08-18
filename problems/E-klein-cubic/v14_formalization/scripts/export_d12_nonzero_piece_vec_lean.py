#!/usr/bin/env python3
"""Emit bounded vector certificates for the nonzero D12 character pieces."""

from __future__ import annotations

import argparse
import hashlib
import json
from fractions import Fraction
from pathlib import Path

from export_d12_piece_vec_lean import (
    DEFAULT_JSON, add_vectors, as_fractions, emit_htarget, emit_mul_sum,
    emit_cell_scaled, emit_scale_thm, emit_vecz_match, lcm_denoms, q_fraction, reduced_mul,
    scalar_vec_def_eq,
    scale_ints, scalar_vec_def, vec_fractions, write_if_changed,
)


def emit_matrix(lines: list[str], name: str, data: list, rows: int, cols: int,
                col_apply: bool = False, published: bool = False) -> None:
    """`published` emits the equations that let the table drop `@[expose]`:
    the per-entry projection, the flat value equation each evaluating
    consumer rewrites with, and the scaled characterisation the split
    certificates use.  Off for matrices that live inside a certificate
    module (`C` in the PP Plucker base), which nothing else reduces through
    and which has no D12VecScaleIntro in scope."""
    for i, row in enumerate(data):
        assert len(row) == cols
        for j, entry in enumerate(row):
            coeffs = entry if entry and isinstance(entry[0], Fraction) else as_fractions(entry)
            lines += scalar_vec_def(f"{name}Cell{i}_{j}", coeffs) + [""]
            if published:
                lines += scalar_vec_def_eq(f"{name}Cell{i}_{j}", coeffs) + [""]
                lines += emit_cell_scaled(f"{name}Cell{i}_{j}", coeffs) + [""]
        lines += [f"def {name}Row{i} (j : Fin {cols}) : Vec :=", "  match j.val with"]
        for j in range(cols):
            lines.append(f"  | {j} => {name}Cell{i}_{j}")
        lines += ["  | _ => 0", ""]
    assert len(data) == rows
    lines += [f"def {name}Vec : Matrix (Fin {rows}) (Fin {cols}) Vec :=",
              "  fun i j => match i.val with"]
    for i in range(rows):
        lines.append(f"  | {i} => {name}Row{i} j")
    lines += ["  | _ => 0", ""]
    # Projection equations, one per entry.  The certificates that consume this
    # table used to reach them with `change {name}Cell{i}_{j} = …`, which makes
    # the exported context unfold `{name}Vec` and its rows and so pins
    # `@[expose]` on the whole table.  Published as theorems, the consumer
    # rewrites instead of forcing defeq, and the bodies can stay internal.
    for i in (range(rows) if published else []):
        for j in range(cols):
            lines += [
                f"public theorem {name}Vec_apply_{i}_{j} :",
                f"    {name}Vec ({i} : Fin {rows}) ({j} : Fin {cols}) = {name}Cell{i}_{j} := by",
                "  rfl",
                "",
            ]
    if col_apply:
        # A binder-friendly form of the same equations, one per column.  The
        # Plucker certificate rewrites `KVec k 0` under a `∑ k : Fin 10`, where
        # the per-index equations cannot fire: after `Fin.sum_univ_succ` the
        # index reads `(Fin.succ 2).succ.succ.succ.succ`, which matches no
        # numeral. Emitted only for the matrices that are consumed under a
        # binder, since the proof is a `fin_cases` and is not free.
        for j in range(cols):
            entries = ", ".join(f"{name}Cell{i}_{j}" for i in range(rows))
            lines += [
                f"public theorem {name}Vec_col{j} (i : Fin {rows}) :",
                f"    {name}Vec i ({j} : Fin {cols}) = ![{entries}] i := by",
                "  fin_cases i <;> rfl",
                "",
            ]


def emit_data(payload: dict, sha: str, piece: str) -> str:
    p = payload["pieces"][piece]
    d = p["dim"]
    lines = [
        f"/- {piece} vector data. Auto-generated. -/",
        "import V14Formalization.D12PieceVecBase",
        "import V14Formalization.D12VecScaleIntro", "", "noncomputable section",
        "open Matrix", f"namespace V14Formalization.D12Piece{piece}Data",
        "open D12CyclotomicVec D12CyclotomicVecZ D12PieceVecBase",
        f'def payloadSha256 : String := "{sha}"', "",
    ]
    emit_matrix(lines, "A", p["A20x10"], 20, 10, published=True)
    emit_matrix(lines, "X", p["X10x20"], 10, 20, published=True)
    emit_matrix(lines, "K", p["K10xd"], 10, d, col_apply=True, published=True)
    emit_matrix(lines, "Y", p["Ydx10"], d, 10, published=True)
    lines += [f"end V14Formalization.D12Piece{piece}Data", ""]
    return "\n".join(lines)


def emit_ambient_basis(payload: dict, sha: str) -> str:
    data = payload["m"]["B15x10"]
    lines = [
        "/- Sparse ambient image-basis matrix in the rational-vector model. -/",
        "import V14Formalization.D12PieceVecBase", "", "noncomputable section",
        "open Matrix", "namespace V14Formalization.D12PieceAmbientVec",
        "open D12CyclotomicVec D12PieceVecBase D12PolynomialData D12PolynomialEvaluation",
        f'def payloadSha256 : String := "{sha}"', "",
    ]
    for i, row in enumerate(data):
        for j, entry in enumerate(row):
            coeffs = as_fractions(entry)
            assert all(x == 0 for x in coeffs[1:])
            lines += [f"def BCell{i}_{j} : Vec := constVec ({q_fraction(coeffs[0])})", ""]
        lines += [f"def BRow{i} (j : Fin 10) : Vec :=", "  match j.val with"]
        for j in range(10):
            lines.append(f"  | {j} => BCell{i}_{j}")
        lines += ["  | _ => 0", ""]
    lines += ["def BVec : Matrix (Fin 15) (Fin 10) Vec :=", "  fun i j => match i.val with"]
    for i in range(15):
        lines.append(f"  | {i} => BRow{i} j")
    lines += ["  | _ => 0", ""]
    for i in range(15):
        cell_names = ", ".join(f"BCell{i}_{j}" for j in range(10))
        lines += [
            f"theorem eval_BRow{i} (j : Fin 10) :",
            f"    D12CyclotomicVec.eval (BRow{i} j) = evalK (B_poly ({i} : Fin 15) j) := by",
            "  fin_cases j <;>",
            f"    simp [BRow{i}, {cell_names}, B_poly, evalK, evalPolyAt]", "",
        ]
    lines += [
        "theorem evalMatrix_BVec : evalMatrix BVec = evalMatrixK B_poly := by",
        "  ext i j", "  fin_cases i",
    ]
    for i in range(15):
        lines.append(f"  · exact eval_BRow{i} j")
    lines += ["", "end V14Formalization.D12PieceAmbientVec", ""]
    return "\n".join(lines)


def emit_product(lines: list[str], name: str, left_name: str, right_name: str,
                 left: list[Fraction], right: list[Fraction]) -> tuple[str, list[Fraction]]:
    value = reduced_mul(left, right)
    lzero = all(x == 0 for x in left)
    rzero = all(x == 0 for x in right)
    lines += [f"def {name} : Vec := mul {left_name} {right_name}", ""]
    if lzero or rzero:
        zero_name = left_name if lzero else right_name
        side = "left" if lzero else "right"
        zero_lemma = "mul_zero_left" if lzero else "mul_zero_right"
        lines += [
            f"theorem {name}_{side}_eq_zero : {zero_name} = 0 := by",
            "  funext n", "  fin_cases n <;> rfl", "",
            f"theorem {name}_eq : {name} = 0 := by",
            f"  rw [{name}, {name}_{side}_eq_zero, {zero_lemma}]", "",
        ]
        return "0", value
    valname = f"{name}Value"
    lines += scalar_vec_def(valname, value) + [""]
    for degree in range(10):
        lines += [
            f"theorem {name}_apply_{degree} :",
            f"    {name} ({degree} : Fin 10) = {valname} ({degree} : Fin 10) := by",
            f"  norm_num [{name}, {valname}, {left_name}, {right_name}, "
            f"mul_apply_{degree}]", "",
        ]
    lines += [f"theorem {name}_eq : {name} = {valname} := by", "  funext n", "  fin_cases n"]
    for degree in range(10):
        lines.append(f"  · exact {name}_apply_{degree}")
    lines.append("")
    return valname, value


def emit_sum(lines: list[str], tag: str, count: int, targets: list[str],
             values: list[list[Fraction]]) -> list[Fraction]:
    total = add_vectors(values)
    lines += [f"def {tag}Result (k : Fin {count}) : Vec :=", "  match k.val with"]
    for k, target in enumerate(targets):
        lines.append(f"  | {k} => {target}")
    lines += ["  | _ => 0", "", f"theorem {tag}MatrixProduct (k : Fin {count}) :",
              f"    {tag}MatrixTerm k = {tag}Result k := by", "  fin_cases k"]
    for k in range(count):
        lines.append(f"  · exact {tag}MatrixProduct{k}")
    lines += [
        "",
        f"theorem {tag}MatrixTerm_sum_eq :",
        f"    (∑ k : Fin {count}, {tag}MatrixTerm k) =",
        f"      ∑ k : Fin {count}, {tag}Result k := by",
        "  apply Finset.sum_congr rfl",
        "  intro k _",
        f"  exact {tag}MatrixProduct k",
        "",
    ]
    nz = [x for x in targets if x != "0"]
    for degree, value in enumerate(total):
        lines += [
            f"theorem {tag}Result_sum_apply_{degree} :",
            f"    (∑ k : Fin {count}, {tag}Result k) ({degree} : Fin 10) =",
            f"      {q_fraction(value)} := by",
        ]
        if nz:
            lines.append(f"  norm_num [{tag}Result, Fin.sum_univ_succ,")
            for index, target in enumerate(nz):
                suffix = "," if index + 1 < len(nz) else "]"
                lines.append(f"    {target}{suffix}")
        else:
            lines.append(f"  norm_num [{tag}Result, Fin.sum_univ_succ]")
        lines.append("")
    lines += [
        f"theorem {tag}Result_sum_eq :",
        f"    (∑ k : Fin {count}, {tag}Result k) = {vec_fractions(total)} := by",
        "  funext n", "  fin_cases n",
    ]
    for degree in range(10):
        lines.append(f"  · exact {tag}Result_sum_apply_{degree}")
    lines.append("")
    return total


def emit_entry(payload: dict, sha: str, piece: str, row: int, col: int) -> str:
    p = payload["pieces"][piece]
    d = p["dim"]
    ns = f"D12Piece{piece}SplitEntry{row}_{col}"
    xs = [as_fractions(p["X10x20"][row][k]) for k in range(20)]
    a_cols = [as_fractions(p["A20x10"][k][col]) for k in range(20)]
    ks = [as_fractions(p["K10xd"][row][k]) for k in range(d)]
    ys = [as_fractions(p["Ydx10"][k][col]) for k in range(d)]
    xa_total = add_vectors([reduced_mul(xs[k], a_cols[k]) for k in range(20)])
    ky_total = add_vectors([reduced_mul(ks[k], ys[k]) for k in range(d)]) \
        if d else [Fraction() for _ in range(10)]
    total = add_vectors([xa_total, ky_total])
    assert total == [Fraction(int(row == col))] + [Fraction()] * 9
    scale = lcm_denoms(xs + a_cols + ks + ys)
    x_scaled = [scale_ints(v, scale) for v in xs]
    a_scaled = [scale_ints(v, scale) for v in a_cols]
    k_scaled = [scale_ints(v, scale) for v in ks]
    y_scaled = [scale_ints(v, scale) for v in ys]
    expected_z = "scaleSqE0 scale" if row == col else "zeroZ"
    lines = [
        f"/- {piece} split identity entry ({row},{col}). Auto-generated. -/",
        f"import V14Formalization.D12Piece{piece}Data",
        "import V14Formalization.D12CyclotomicVecZ",
        "",
        "noncomputable section",
        "open Matrix",
        f"namespace V14Formalization.{ns}",
        f"open D12CyclotomicVec D12CyclotomicVecZ D12Piece{piece}Data",
        f'def payloadSha256 : String := "{sha}"',
        "",
        f"def scale : ℤ := {scale}",
        "",
    ]
    lines += emit_vecz_match("XZ", 20, x_scaled)
    lines += emit_vecz_match("AZ", 20, a_scaled)
    lines += emit_vecz_match("KZ", d, k_scaled)
    lines += emit_vecz_match("YZ", d, y_scaled)
    xa_lines, _xa_ints = emit_mul_sum("xa", "XZ", "AZ", xs, a_cols, scale)
    ky_lines, _ky_ints = emit_mul_sum("ky", "KZ", "YZ", ks, ys, scale)
    lines += xa_lines
    lines += ky_lines
    lines += [
        "def xaEntryZ : VecZ := sumFin (fun k => mulZ (XZ k) (AZ k))",
        "def kyEntryZ : VecZ := sumFin (fun k => mulZ (KZ k) (YZ k))",
        "def entryZ : VecZ := addZ xaEntryZ kyEntryZ",
        "",
        f"theorem entryZ_eq : entryZ = {expected_z} := by",
        "  unfold entryZ xaEntryZ kyEntryZ",
        "  rw [xaSum_eq, kySum_eq]",
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
        [f"XVec_apply_{row}_{k}" for k in range(20)])
    lines += emit_scale_thm(
        "AZ_scale", "AZ",
        f"(scale : ℚ) • AVec k ({col} : Fin 10)",
        [f"ACell{k}_{col}" for k in range(20)],
        [f"AVec_apply_{k}_{col}" for k in range(20)])
    lines += emit_scale_thm(
        "KZ_scale", "KZ",
        f"(scale : ℚ) • KVec ({row} : Fin 10) k",
        [f"KCell{row}_{k}" for k in range(d)],
        [f"KVec_apply_{row}_{k}" for k in range(d)])
    lines += emit_scale_thm(
        "YZ_scale", "YZ",
        f"(scale : ℚ) • YVec k ({col} : Fin 10)",
        [f"YCell{k}_{col}" for k in range(d)],
        [f"YVec_apply_{k}_{col}" for k in range(d)])
    lines += [
        "theorem entry_eq :",
        "    (matrixMul XVec AVec + matrixMul KVec YVec)",
        f"        ({row} : Fin 10) ({col} : Fin 10) = {vec_fractions(total)} := by",
        # No `change`: rewrite with the published entry equations instead of
        # asking the exported context to reduce the whole goal.
        "  rw [Matrix.add_apply, matrixMul_apply, matrixMul_apply]",
        "  refine add_sum_mul_eq_of_scaled scale scale_ne_zero",
        f"    (fun k => XVec ({row} : Fin 10) k)",
        f"    (fun k => AVec k ({col} : Fin 10))",
        f"    (fun k => KVec ({row} : Fin 10) k)",
        f"    (fun k => YVec k ({col} : Fin 10))",
        "    XZ AZ KZ YZ XZ_scale AZ_scale KZ_scale YZ_scale entryZ rfl _ ?_",
    ]
    lines += emit_htarget(row == col)
    lines += [
        "",
        "theorem entry_eq_matrixOne :",
        "    (matrixMul XVec AVec + matrixMul KVec YVec)",
        f"        ({row} : Fin 10) ({col} : Fin 10) =",
        f"      matrixOne (Fin 10) ({row} : Fin 10) ({col} : Fin 10) := by",
        "  rw [entry_eq]",
    ]
    if row != col:
        lines.append(f"  have hne : ({row} : Fin 10) ≠ ({col} : Fin 10) := by decide")
    lines += [
        "  funext n",
        "  fin_cases n <;> simp [matrixOne, *]",
        "",
        f"end V14Formalization.{ns}",
        "",
    ]
    return "\n".join(lines)


def emit_row(piece: str, row: int) -> str:
    assert 0 <= row < 10
    ns = f"D12Piece{piece}SplitRow{row}"
    lines = [f"/- {piece} split identity row {row}. Auto-generated. -/"]
    for col in range(10):
        lines.append(f"import V14Formalization.D12Piece{piece}SplitEntry{row}_{col}")
    lines += [
        "", "noncomputable section", f"namespace V14Formalization.{ns}",
        f"open D12CyclotomicVec D12Piece{piece}Data", "",
        "theorem row_eq (j : Fin 10) :",
        "    (matrixMul XVec AVec + matrixMul KVec YVec)",
        f"      ({row} : Fin 10) j = matrixOne (Fin 10) ({row} : Fin 10) j := by",
        "  fin_cases j",
    ]
    for col in range(10):
        lines.append(f"  · exact D12Piece{piece}SplitEntry{row}_{col}.entry_eq_matrixOne")
    lines += ["", f"end V14Formalization.{ns}", ""]
    return "\n".join(lines)


def emit_full(piece: str) -> str:
    lines = [f"/- Complete {piece} split identity. Auto-generated structural assembly. -/"]
    for row in range(10):
        lines.append(f"import V14Formalization.D12Piece{piece}SplitRow{row}")
    lines += [
        "", "noncomputable section", f"namespace V14Formalization.D12Piece{piece}Split",
        f"open D12CyclotomicVec D12Piece{piece}Data", "",
        "theorem split_identity :",
        "    matrixMul XVec AVec + matrixMul KVec YVec = matrixOne (Fin 10) := by",
        "  apply Matrix.ext", "  intro i j", "  fin_cases i",
    ]
    for row in range(10):
        lines.append(f"  · exact D12Piece{piece}SplitRow{row}.row_eq j")
    lines += ["", f"end V14Formalization.D12Piece{piece}Split", ""]
    return "\n".join(lines)


def piece_signs(piece: str) -> tuple[int, int]:
    return (1 if piece[0] == "P" else -1, 1 if piece[1] == "P" else -1)


def emit_plucker_fin1(payload: dict, sha: str, piece: str) -> str:
    assert piece in ("AP", "AA")
    p = payload["pieces"][piece]
    assert p["dim"] == 1
    b = [[as_fractions(x) for x in row] for row in payload["m"]["B15x10"]]
    k = [[as_fractions(x) for x in row] for row in p["K10xd"]]
    bk = []
    for i in range(15):
        value = add_vectors([reduced_mul(b[i][r], k[r][0]) for r in range(10)])
        asserted = as_fractions(p["Bpiece15xd"][i][0])
        assert value == asserted
        bk.append(value)
    needed = (0, 9, 1, 6, 2, 5)
    coeff = add_vectors([
        reduced_mul(bk[0], bk[9]),
        [-x for x in reduced_mul(bk[1], bk[6])],
        reduced_mul(bk[2], bk[5]),
    ])
    delta_raw = as_fractions(p["determinant"])
    delta = [x / 2 for x in delta_raw]
    assert coeff == delta
    ns = f"D12Piece{piece}Plucker"
    lines = [
        f"/- Normalized Plucker coefficient for the {piece} character line. -/",
        "import V14Formalization.D12MatrixCertificate",
        "import V14Formalization.D12PieceAmbientVec",
        f"import V14Formalization.D12Piece{piece}Data", "", "noncomputable section",
        "open Matrix", f"namespace V14Formalization.{ns}",
        f"open D12Certificate D12CyclotomicVec D12PieceAmbientVec D12Piece{piece}Data",
        "open D12PolynomialData D12PolynomialEvaluation",
        f'def payloadSha256 : String := "{sha}"', "",
        "def BKVec : Matrix (Fin 15) (Fin 1) Vec := matrixMul BVec KVec", "",
        "theorem mul_constVec_left (r : ℚ) (v : Vec) :",
        "    mul (constVec r) v = r • v := by",
        "  apply eval_injective",
        "  rw [eval_mul, eval_constVec, eval_smul]", "",
    ]
    # Rewrite with the table's published entry equations rather than unfolding
    # `KVec` / `KRow*` / the cells, so D12Piece{piece}Data needs no `@[expose]`.
    k_defs = ", ".join(f"KCell{r}_0_def" for r in range(10))
    for i in needed:
        lines += scalar_vec_def(f"BKCoord{i}", bk[i]) + [""]
        b_names = ", ".join(f"BCell{i}_{r}" for r in range(10))
        lines += [
            f"theorem BKVec_{i} : BKVec ({i} : Fin 15) 0 = BKCoord{i} := by",
            "  funext n", "  fin_cases n <;>",
            f"    norm_num [BKVec, matrixMul, BVec, BRow{i}, {b_names},",
            f"      KVec_col0, {k_defs}, BKCoord{i},",
            "      mul_constVec_left, Fin.sum_univ_succ]", "",
        ]
    lines += scalar_vec_def("deltaVec", delta) + [""]
    lines += [
        "def coefficientVec : Vec :=",
        "  mul BKCoord0 BKCoord9 - mul BKCoord1 BKCoord6 + mul BKCoord2 BKCoord5", "",
    ]
    for degree in range(10):
        lines += [
            f"theorem coefficientVec_apply_{degree} :",
            f"    coefficientVec ({degree} : Fin 10) = deltaVec ({degree} : Fin 10) := by",
            "  norm_num [coefficientVec, deltaVec, BKCoord0, BKCoord9, BKCoord1, BKCoord6,",
            f"    BKCoord2, BKCoord5, mul_apply_{degree}]", "",
        ]
    lines += ["theorem coefficientVec_eq : coefficientVec = deltaVec := by",
              "  funext n", "  fin_cases n"]
    for degree in range(10):
        lines.append(f"  · exact coefficientVec_apply_{degree}")
    lines += [
        "", "theorem eval_coefficient :",
        "    eval BKCoord0 * eval BKCoord9 - eval BKCoord1 * eval BKCoord6 +",
        "        eval BKCoord2 * eval BKCoord5 = eval deltaVec := by",
        "  calc",
        "    _ = eval coefficientVec := by",
        "      simp only [coefficientVec, eval_add, eval_sub, eval_mul]",
        "    _ = eval deltaVec := congrArg eval coefficientVec_eq", "",
        "theorem evalMatrix_BKVec :",
        "    evalMatrix BKVec = evalMatrixK B_poly * evalMatrix KVec := by",
        "  change evalMatrix (matrixMul BVec KVec) = _",
        "  rw [evalMatrix_mul, evalMatrix_BVec]", "",
        "theorem mulVec_fin1 (M : Matrix (Fin 15) (Fin 1) WeilRep.K)",
        "    (t : Fin 1 → WeilRep.K) (i : Fin 15) :",
        "    M.mulVec t i = M i 0 * t 0 := by",
        "  change (∑ j : Fin 1, M i j * t j) = _",
        "  rw [Fin.sum_univ_succ]", "  simp", "",
        "theorem plucker_coefficient (t : Fin 1 → WeilRep.K) :",
        "    pluckerValue ((evalMatrix BKVec).mulVec t) 0 =",
        "      eval deltaVec * (t 0 * t 0) := by",
        "  change ((evalMatrix BKVec).mulVec t) 0 * ((evalMatrix BKVec).mulVec t) 9 -",
        "      ((evalMatrix BKVec).mulVec t) 1 * ((evalMatrix BKVec).mulVec t) 6 +",
        "      ((evalMatrix BKVec).mulVec t) 2 * ((evalMatrix BKVec).mulVec t) 5 = _",
        "  simp_rw [mulVec_fin1]",
        "  change (eval (BKVec 0 0) * t 0) * (eval (BKVec 9 0) * t 0) -",
        "      (eval (BKVec 1 0) * t 0) * (eval (BKVec 6 0) * t 0) +",
        "      (eval (BKVec 2 0) * t 0) * (eval (BKVec 5 0) * t 0) = _",
        "  rw [BKVec_0, BKVec_9, BKVec_1, BKVec_6, BKVec_2, BKVec_5]",
        "  rw [← eval_coefficient]", "  ring", "",
        "theorem delta_ne_zero : eval deltaVec ≠ 0 := by",
        "  intro h", "  have hv : deltaVec = 0 := (eval_eq_zero_iff deltaVec).mp h",
    ]
    witness = next(i for i, x in enumerate(delta) if x != 0)
    lines += [f"  have hz := congrFun hv ({witness} : Fin 10)",
              "  norm_num [deltaVec] at hz", "", f"end V14Formalization.{ns}", ""]
    return "\n".join(lines)


PP_RELATIONS = {
    0: (1, (0, 10, 1, 7, 3, 5)),
    1: (2, (0, 11, 1, 8, 4, 5)),
    2: (9, (2, 14, 3, 13, 4, 12)),
}


def pp_bk_vectors(payload: dict) -> list[list[list[Fraction]]]:
    p = payload["pieces"]["PP"]
    b = [[as_fractions(x) for x in row] for row in payload["m"]["B15x10"]]
    k = [[as_fractions(x) for x in row] for row in p["K10xd"]]
    out = []
    for i in range(15):
        row = []
        for col in range(2):
            value = add_vectors([reduced_mul(b[i][r], k[r][col]) for r in range(10)])
            assert value == as_fractions(p["Bpiece15xd"][i][col])
            row.append(value)
        out.append(row)
    return out


def emit_pp_plucker_base(payload: dict, sha: str) -> str:
    p = payload["pieces"]["PP"]
    bk = pp_bk_vectors(payload)
    needed = sorted({i for _, rel in PP_RELATIONS.values() for i in rel})
    c = [[[x / 2 for x in as_fractions(p["coeff_matrix"][i][j])]
          for j in range(3)] for i in range(3)]
    delta = [x / 8 for x in as_fractions(p["determinant"])]
    lines = [
        "/- Normalized Plucker data for the PP character plane. -/",
        "import V14Formalization.D12MatrixCertificate",
        "import V14Formalization.D12PieceAmbientVec",
        "import V14Formalization.D12PiecePPData", "", "noncomputable section",
        "open Matrix", "namespace V14Formalization.D12PiecePPPluckerBase",
        "open D12Certificate D12CyclotomicVec D12PieceAmbientVec D12PiecePPData",
        "open D12PolynomialData D12PolynomialEvaluation",
        f'def payloadSha256 : String := "{sha}"', "",
        "def BKVec : Matrix (Fin 15) (Fin 2) Vec := matrixMul BVec KVec", "",
        "theorem mul_constVec_left (r : ℚ) (v : Vec) :",
        "    mul (constVec r) v = r • v := by",
        "  apply eval_injective", "  rw [eval_mul, eval_constVec, eval_smul]", "",
    ]
    # Same substitution as the Fin 1 Plucker: rewrite with the table's
    # published column and cell equations rather than unfolding `KVec`.
    k_cols = ", ".join(f"KVec_col{j}" for j in range(2))
    k_defs = ", ".join(f"KCell{r}_{j}_def" for r in range(10) for j in range(2))
    for i in needed:
        b_names = ", ".join(f"BCell{i}_{r}" for r in range(10))
        for col in range(2):
            lines += scalar_vec_def(f"BKCoord{i}_{col}", bk[i][col]) + [""]
            lines += [
                f"theorem BKVec_{i}_{col} :",
                f"    BKVec ({i} : Fin 15) ({col} : Fin 2) = BKCoord{i}_{col} := by",
                "  funext n", "  fin_cases n <;>",
                f"    norm_num [BKVec, matrixMul, BVec, BRow{i}, {b_names},",
                f"      {k_cols}, {k_defs}, BKCoord{i}_{col},",
                "      mul_constVec_left, Fin.sum_univ_succ]", "",
            ]
    emit_matrix(lines, "C", c, 3, 3)
    lines += scalar_vec_def("deltaVec", delta) + [""]
    lines += [
        "theorem evalMatrix_BKVec :",
        "    evalMatrix BKVec = evalMatrixK B_poly * evalMatrix KVec := by",
        "  change evalMatrix (matrixMul BVec KVec) = _",
        "  rw [evalMatrix_mul, evalMatrix_BVec]", "",
        "theorem delta_ne_zero : eval deltaVec ≠ 0 := by",
        "  intro h", "  have hv : deltaVec = 0 := (eval_eq_zero_iff deltaVec).mp h",
        "  have hz := congrFun hv (0 : Fin 10)",
        "  norm_num [deltaVec] at hz", "",
        "end V14Formalization.D12PiecePPPluckerBase", "",
    ]
    return "\n".join(lines)


def pp_coeff_terms(row: int, monomial: int) -> list[tuple[int, tuple[int, int, int, int]]]:
    _, (a, b, c, d, e, f) = PP_RELATIONS[row]
    pairs = ((1, a, b), (-1, c, d), (1, e, f))
    terms: list[tuple[int, tuple[int, int, int, int]]] = []
    if monomial == 0:
        terms = [(sgn, (u, 0, v, 0)) for sgn, u, v in pairs]
    elif monomial == 2:
        terms = [(sgn, (u, 1, v, 1)) for sgn, u, v in pairs]
    else:
        for sgn, u, v in pairs:
            terms.append((sgn, (u, 0, v, 1)))
            terms.append((sgn, (u, 1, v, 0)))
    return terms


def signed_expression(parts: list[tuple[int, str]]) -> str:
    assert parts and parts[0][0] == 1
    out = parts[0][1]
    for sign, term in parts[1:]:
        out += (" + " if sign == 1 else " - ") + term
    return out


def emit_pp_coefficient(payload: dict, sha: str, row: int, monomial: int) -> str:
    assert 0 <= row < 3 and 0 <= monomial < 3
    p = payload["pieces"]["PP"]
    bk = pp_bk_vectors(payload)
    terms = pp_coeff_terms(row, monomial)
    values = []
    for sign, (i, ci, j, cj) in terms:
        value = reduced_mul(bk[i][ci], bk[j][cj])
        values.append([Fraction(sign) * x for x in value])
    total = add_vectors(values)
    expected = [x / 2 for x in as_fractions(p["coeff_matrix"][row][monomial])]
    assert total == expected
    ns = f"D12PiecePPCoeff{row}_{monomial}"
    split_products = monomial == 1
    vec_parts = [(sign, (f"D12PiecePPCoeff{row}_{monomial}Product{index}.productValue"
                         if split_products else
                         f"mul BKCoord{i}_{ci} BKCoord{j}_{cj}"))
                 for index, (sign, (i, ci, j, cj)) in enumerate(terms)]
    field_parts = [(sign, f"eval BKCoord{i}_{ci} * eval BKCoord{j}_{cj}")
                   for sign, (i, ci, j, cj) in terms]
    coord_names = sorted({f"BKCoord{i}_{ci}" for _, (i, ci, j, cj) in terms} |
                         {f"BKCoord{j}_{cj}" for _, (i, ci, j, cj) in terms})
    lines = [
        f"/- PP Plucker coefficient ({row},{monomial}). Auto-generated. -/",
    ]
    if split_products:
        for index in range(len(terms)):
            lines.append(
                f"import V14Formalization.D12PiecePPCoeff{row}_{monomial}Product{index}")
    else:
        lines.append("import V14Formalization.D12PiecePPPluckerBase")
    lines += ["", "noncomputable section",
        f"namespace V14Formalization.{ns}",
        "open D12CyclotomicVec D12PiecePPPluckerBase", f'def payloadSha256 : String := "{sha}"', "",
        "def coefficientVec : Vec :=", f"  {signed_expression(vec_parts)}", "",
    ]
    for degree in range(10):
        lines += [
            f"theorem coefficientVec_apply_{degree} :",
            f"    coefficientVec ({degree} : Fin 10) = CCell{row}_{monomial} ({degree} : Fin 10) := by",
            f"  norm_num [coefficientVec, CCell{row}_{monomial}, " +
            ((", ".join(
                f"D12PiecePPCoeff{row}_{monomial}Product{index}.productValue"
                for index in range(len(terms)))) if split_products else
             f"{', '.join(coord_names)}, mul_apply_{degree}") + "]", "",
        ]
    lines += [f"theorem coefficientVec_eq : coefficientVec = CCell{row}_{monomial} := by",
              "  funext n", "  fin_cases n"]
    for degree in range(10):
        lines.append(f"  · exact coefficientVec_apply_{degree}")
    lines += [
        "", "theorem eval_coefficient :", f"    {signed_expression(field_parts)} =",
        f"      eval CCell{row}_{monomial} := by", "  calc",
    ]
    if split_products:
        lines += [
            f"    _ = {signed_expression([(sign, f'eval D12PiecePPCoeff{row}_{monomial}Product{index}.productValue') for index, (sign, _) in enumerate(terms)])} := by",
            f"      rw [{', '.join(f'D12PiecePPCoeff{row}_{monomial}Product{index}.eval_product' for index in range(len(terms)))}]",
            "    _ = eval coefficientVec := by",
            "      simp only [coefficientVec, eval_add, eval_sub]",
        ]
    else:
        lines += [
            "    _ = eval coefficientVec := by",
            "      simp only [coefficientVec, eval_add, eval_sub, eval_mul]",
        ]
    lines += [
        "    _ = _ := congrArg eval coefficientVec_eq", "",
        f"end V14Formalization.{ns}", "",
    ]
    return "\n".join(lines)


def emit_pp_coefficient_product(payload: dict, sha: str, row: int,
                                monomial: int, term_index: int) -> str:
    """Emit one bounded product used by a mixed PP Plucker coefficient."""
    assert 0 <= row < 3 and monomial == 1
    terms = pp_coeff_terms(row, monomial)
    assert 0 <= term_index < len(terms)
    _, (i, ci, j, cj) = terms[term_index]
    bk = pp_bk_vectors(payload)
    value = reduced_mul(bk[i][ci], bk[j][cj])
    ns = f"D12PiecePPCoeff{row}_{monomial}Product{term_index}"
    lines = [
        f"/- Bounded product {term_index} for PP Plucker coefficient ({row},{monomial}). -/",
        "import V14Formalization.D12PiecePPPluckerBase", "", "noncomputable section",
        f"namespace V14Formalization.{ns}",
        "open D12CyclotomicVec D12PiecePPPluckerBase",
        f'def payloadSha256 : String := "{sha}"', "",
        f"def productVec : Vec := mul BKCoord{i}_{ci} BKCoord{j}_{cj}", "",
    ]
    lines += scalar_vec_def("productValue", value) + [""]
    for degree in range(10):
        lines += [
            f"theorem productVec_apply_{degree} :",
            f"    productVec ({degree} : Fin 10) = productValue ({degree} : Fin 10) := by",
            f"  norm_num [productVec, productValue, BKCoord{i}_{ci}, BKCoord{j}_{cj}, "
            f"mul_apply_{degree}]", "",
        ]
    lines += ["theorem productVec_eq : productVec = productValue := by",
              "  funext n", "  fin_cases n"]
    for degree in range(10):
        lines.append(f"  · exact productVec_apply_{degree}")
    lines += [
        "", "theorem eval_product :",
        f"    eval BKCoord{i}_{ci} * eval BKCoord{j}_{cj} = eval productValue := by",
        "  calc",
        "    _ = eval productVec := by simp only [productVec, eval_mul]",
        "    _ = _ := congrArg eval productVec_eq", "",
        f"end V14Formalization.{ns}", "",
    ]
    return "\n".join(lines)


def emit_pp_determinant(payload: dict, sha: str) -> str:
    p = payload["pieces"]["PP"]
    c = [[[x / 2 for x in as_fractions(p["coeff_matrix"][i][j])]
          for j in range(3)] for i in range(3)]
    delta = [x / 8 for x in as_fractions(p["determinant"])]
    triples = [
        (1, ((0, 0), (1, 1), (2, 2))),
        (-1, ((0, 0), (1, 2), (2, 1))),
        (-1, ((0, 1), (1, 0), (2, 2))),
        (1, ((0, 1), (1, 2), (2, 0))),
        (1, ((0, 2), (1, 0), (2, 1))),
        (-1, ((0, 2), (1, 1), (2, 0))),
    ]
    lines = [
        "/- Determinant of the normalized PP Plucker coefficient matrix. -/",
        "import V14Formalization.D12PiecePPPluckerBase", "", "noncomputable section",
        "open Matrix", "namespace V14Formalization.D12PiecePPDeterminant",
        "open D12CyclotomicVec D12PiecePPPluckerBase", f'def payloadSha256 : String := "{sha}"', "",
    ]
    triple_values: list[list[Fraction]] = []
    for index, (_, ((i, j), (k, l), (m, n))) in enumerate(triples):
        pair_name, pair_value = emit_product(
            lines, f"detPair{index}", f"CCell{i}_{j}", f"CCell{k}_{l}", c[i][j], c[k][l])
        triple_name, triple_value = emit_product(
            lines, f"detTriple{index}", pair_name, f"CCell{m}_{n}", pair_value, c[m][n])
        triple_values.append(triple_value)
        lines += [
            f"theorem detTriple{index}_actual :",
            f"    mul (mul CCell{i}_{j} CCell{k}_{l}) CCell{m}_{n} = {triple_name} := by",
            "  calc",
            f"    _ = mul detPair{index}Value CCell{m}_{n} :=",
            f"      congrArg (fun v => mul v CCell{m}_{n}) detPair{index}_eq",
            f"    _ = _ := detTriple{index}_eq", "", f"theorem eval_detTriple{index} :",
            f"    eval CCell{i}_{j} * eval CCell{k}_{l} * eval CCell{m}_{n} =",
            f"      eval {triple_name} := by", "  calc",
            f"    _ = eval (mul (mul CCell{i}_{j} CCell{k}_{l}) CCell{m}_{n}) := by",
            "      simp only [eval_mul]",
            f"    _ = _ := congrArg eval detTriple{index}_actual", "",
        ]
    signed_vals = [[Fraction(sign) * x for x in val]
                   for (sign, _), val in zip(triples, triple_values)]
    det_value = add_vectors(signed_vals)
    assert det_value == delta
    det_parts = [(sign, f"detTriple{index}Value") for index, (sign, _) in enumerate(triples)]
    field_parts = []
    for sign, ((i, j), (k, l), (m, n)) in triples:
        field_parts.append((sign,
            f"eval CCell{i}_{j} * eval CCell{k}_{l} * eval CCell{m}_{n}"))
    lines += ["def determinantVec : Vec :=", f"  {signed_expression(det_parts)}", ""]
    for degree in range(10):
        lines += [
            f"theorem determinantVec_apply_{degree} :",
            f"    determinantVec ({degree} : Fin 10) = deltaVec ({degree} : Fin 10) := by",
            f"  norm_num [determinantVec, deltaVec, {', '.join(f'detTriple{i}Value' for i in range(6))}]",
            "",
        ]
    lines += ["theorem determinantVec_eq : determinantVec = deltaVec := by",
              "  funext n", "  fin_cases n"]
    for degree in range(10):
        lines.append(f"  · exact determinantVec_apply_{degree}")
    lines += [
        "", "theorem eval_determinant :", f"    {signed_expression(field_parts)} =",
        "      eval deltaVec := by", "  calc",
        f"    _ = {signed_expression([(sign, f'eval detTriple{i}Value') for i, (sign, _) in enumerate(triples)])} := by",
        f"      rw [{', '.join(f'eval_detTriple{i}' for i in range(6))}]",
        "    _ = eval determinantVec := by",
        "      simp only [determinantVec, eval_add, eval_sub]",
        "    _ = eval deltaVec := congrArg eval determinantVec_eq", "",
        "theorem det_evalMatrix_CVec : (evalMatrix CVec).det = eval deltaVec := by",
        "  rw [Matrix.det_fin_three]",
        "  change eval CCell0_0 * eval CCell1_1 * eval CCell2_2 -",
        "      eval CCell0_0 * eval CCell1_2 * eval CCell2_1 -",
        "      eval CCell0_1 * eval CCell1_0 * eval CCell2_2 +",
        "      eval CCell0_1 * eval CCell1_2 * eval CCell2_0 +",
        "      eval CCell0_2 * eval CCell1_0 * eval CCell2_1 -",
        "      eval CCell0_2 * eval CCell1_1 * eval CCell2_0 = _",
        "  exact eval_determinant", "",
        "theorem det_ne_zero : (evalMatrix CVec).det ≠ 0 := by",
        "  rw [det_evalMatrix_CVec]", "  exact delta_ne_zero", "",
        "end V14Formalization.D12PiecePPDeterminant", "",
    ]
    return "\n".join(lines)


def emit_action_row(piece: str, row: int) -> str:
    assert 0 <= row < 20
    rot_sign, refl_sign = piece_signs(piece)
    ns = f"D12Piece{piece}ActionRow{row}"
    is_rot = row < 10
    block_row = row if is_rot else row - 10
    prefix = "RM" if is_rot else "SM"
    sign = rot_sign if is_rot else refl_sign
    correction = q_fraction(Fraction(sign))
    lines = [
        f"/- {piece} character-stack identification row {row}. Auto-generated. -/",
        f"import V14Formalization.D12Piece{piece}Data", "", "noncomputable section",
        f"namespace V14Formalization.{ns}",
        f"open D12CyclotomicVec D12PieceVecBase D12Piece{piece}Data", "",
    ]
    for col in range(10):
        diagonal = block_row == col
        correction_expr = f"constVec ({correction})" if diagonal else "0"
        lines += [
            f"theorem entry{col} :",
            f"    AVec ({row} : Fin 20) ({col} : Fin 10) =",
            f"      characterStackVec RMVec SMVec ({q_fraction(Fraction(rot_sign))})",
            f"        ({q_fraction(Fraction(refl_sign))}) ({row} : Fin 20) ({col} : Fin 10) := by",
            # No `change`: rewrite with the projection equations the data
            # module and D12PieceVecBase publish, so neither side has to be
            # unfolded in the exported context.
            f"  rw [AVec_apply_{row}_{col}, characterStackVec_apply_{row}_{col}]",
            "  funext n", "  fin_cases n <;>",
            f"    norm_num [ACell{row}_{col}_def, {prefix}Vec, {prefix}VecRow{block_row},",
            f"      D12PolynomialData.{prefix}{block_row}c{col}, constVec, basis]", "",
        ]
    lines += [
        "theorem row_eq (j : Fin 10) :",
        f"    AVec ({row} : Fin 20) j =",
        f"      characterStackVec RMVec SMVec ({q_fraction(Fraction(rot_sign))})",
        f"        ({q_fraction(Fraction(refl_sign))}) ({row} : Fin 20) j := by",
        "  fin_cases j",
    ]
    for col in range(10):
        lines.append(f"  · exact entry{col}")
    lines += ["", f"end V14Formalization.{ns}", ""]
    return "\n".join(lines)


def emit_action_full(piece: str) -> str:
    rot_sign, refl_sign = piece_signs(piece)
    lines = [f"/- {piece} literal action matrix equals its character stack. -/"]
    for row in range(20):
        lines.append(f"import V14Formalization.D12Piece{piece}ActionRow{row}")
    lines += [
        "", "noncomputable section", f"namespace V14Formalization.D12Piece{piece}Action",
        f"open D12PieceVecBase D12Piece{piece}Data", "", "theorem action_matrix :",
        f"    AVec = characterStackVec RMVec SMVec ({q_fraction(Fraction(rot_sign))})",
        f"      ({q_fraction(Fraction(refl_sign))}) := by",
        "  apply Matrix.ext", "  intro i j", "  fin_cases i",
    ]
    for row in range(20):
        lines.append(f"  · exact D12Piece{piece}ActionRow{row}.row_eq j")
    lines += ["", f"end V14Formalization.D12Piece{piece}Action", ""]
    return "\n".join(lines)


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("piece", choices=["AP", "AA", "PP"])
    ap.add_argument("--json", type=Path, default=DEFAULT_JSON)
    ap.add_argument("--data-out", type=Path)
    ap.add_argument("--ambient-basis-out", type=Path)
    ap.add_argument("--plucker-fin1-out", type=Path)
    ap.add_argument("--pp-plucker-base-out", type=Path)
    ap.add_argument("--pp-coeff-out", type=Path)
    ap.add_argument("--pp-coeff", nargs=2, type=int, metavar=("ROW", "MONOMIAL"))
    ap.add_argument("--pp-coeff-product-out", type=Path)
    ap.add_argument("--pp-coeff-product", nargs=3, type=int,
                    metavar=("ROW", "MONOMIAL", "TERM"))
    ap.add_argument("--pp-det-out", type=Path)
    ap.add_argument("--entry-out", type=Path)
    ap.add_argument("--entry", nargs=2, type=int, metavar=("ROW", "COL"))
    ap.add_argument("--all-dir", type=Path)
    ap.add_argument("--action-dir", type=Path)
    args = ap.parse_args()
    raw = args.json.read_bytes(); sha = hashlib.sha256(raw).hexdigest(); payload = json.loads(raw)
    if args.data_out:
        write_if_changed(args.data_out, emit_data(payload, sha, args.piece))
    if args.ambient_basis_out:
        write_if_changed(args.ambient_basis_out, emit_ambient_basis(payload, sha))
    if args.plucker_fin1_out:
        if args.piece not in ("AP", "AA"):
            ap.error("--plucker-fin1-out requires piece AP or AA")
        write_if_changed(args.plucker_fin1_out,
                         emit_plucker_fin1(payload, sha, args.piece))
    if args.pp_plucker_base_out:
        if args.piece != "PP":
            ap.error("--pp-plucker-base-out requires piece PP")
        write_if_changed(args.pp_plucker_base_out, emit_pp_plucker_base(payload, sha))
    if args.pp_coeff_out:
        if args.piece != "PP" or args.pp_coeff is None:
            ap.error("--pp-coeff-out requires piece PP and --pp-coeff ROW MONOMIAL")
        write_if_changed(args.pp_coeff_out,
                         emit_pp_coefficient(payload, sha, *args.pp_coeff))
    if args.pp_coeff_product_out:
        if args.piece != "PP" or args.pp_coeff_product is None:
            ap.error("--pp-coeff-product-out requires piece PP and --pp-coeff-product ROW MONOMIAL TERM")
        write_if_changed(args.pp_coeff_product_out,
                         emit_pp_coefficient_product(payload, sha,
                                                     *args.pp_coeff_product))
    if args.pp_det_out:
        if args.piece != "PP":
            ap.error("--pp-det-out requires piece PP")
        write_if_changed(args.pp_det_out, emit_pp_determinant(payload, sha))
    if args.entry_out:
        if args.entry is None:
            ap.error("--entry-out requires --entry ROW COL")
        write_if_changed(args.entry_out, emit_entry(payload, sha, args.piece, *args.entry))
    if args.all_dir:
        for row in range(10):
            for col in range(10):
                path = args.all_dir / f"D12Piece{args.piece}SplitEntry{row}_{col}.lean"
                write_if_changed(path, emit_entry(payload, sha, args.piece, row, col))
            write_if_changed(args.all_dir / f"D12Piece{args.piece}SplitRow{row}.lean",
                             emit_row(args.piece, row))
        write_if_changed(args.all_dir / f"D12Piece{args.piece}Split.lean",
                         emit_full(args.piece))
    if args.action_dir:
        for row in range(20):
            write_if_changed(args.action_dir / f"D12Piece{args.piece}ActionRow{row}.lean",
                             emit_action_row(args.piece, row))
        write_if_changed(args.action_dir / f"D12Piece{args.piece}Action.lean",
                         emit_action_full(args.piece))


if __name__ == "__main__":
    main()
    __import__("sys").path.insert(0, __import__("os").path.dirname(__import__("os").path.abspath(__file__)))
    from module_annotation_hook import reapply_module_annotations
    reapply_module_annotations()
