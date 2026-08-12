#!/usr/bin/env python3
"""Emit plus Segre spanV/Qplus/Bplus data and coefficient identities.

Writes only under --out-dir.  Each (s, m) coefficient identity is a separate
Lean file so the stock heartbeat budget stays inside the working LH pattern.
"""
from __future__ import annotations

import argparse
import sys
from fractions import Fraction
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))
import export_sigma_plus_identities as g

JSON_PATH = ROOT / "results" / "sigma_plus_segre_Ki.json"
SIGMA_JSON = ROOT / "results" / "sigma_normal_form_K.json"

MONS = [(i, j) for i in range(6) for j in range(i, 6)]
MINOR_ORDER = [
    (0, 1, 0, 1), (0, 1, 0, 2), (0, 1, 1, 2),
    (0, 2, 0, 1), (0, 2, 0, 2), (0, 2, 1, 2),
    (1, 2, 0, 1), (1, 2, 0, 2), (1, 2, 1, 2),
]
PLUCKER = [
    (0, 9, 1, 6, 2, 5),
    (0, 10, 1, 7, 3, 5),
    (0, 11, 1, 8, 4, 5),
    (0, 12, 2, 7, 3, 6),
    (0, 13, 2, 8, 4, 6),
    (0, 14, 3, 8, 4, 7),
    (1, 12, 2, 10, 3, 9),
    (1, 13, 2, 11, 4, 9),
    (1, 14, 3, 11, 4, 10),
    (2, 14, 3, 13, 4, 12),
    (5, 12, 6, 10, 7, 9),
    (5, 13, 6, 11, 8, 9),
    (5, 14, 7, 11, 8, 10),
    (6, 14, 7, 13, 8, 12),
    (9, 14, 10, 13, 11, 12),
]
BPLUS_SRC = {
    0: (0, Fraction(1)),
    1: (1, Fraction(1)),
    2: (2, Fraction(1)),
    3: (3, Fraction(1)),
    4: (4, Fraction(1)),
    5: (3, Fraction(-1, 2)),
    6: (5, Fraction(1)),
    7: (6, Fraction(1)),
    8: (1, Fraction(1, 2)),
    9: (7, Fraction(1)),
    10: (2, Fraction(-1, 2)),
    11: (8, Fraction(1)),
    12: (4, Fraction(1, 2)),
    13: (0, Fraction(-1, 2)),
    14: (9, Fraction(1)),
}

ADD_LEMMA = {
    2: "ofLadj_add",
    3: "ofLadj_add3",
    4: "ofLadj_add4",
    5: "ofLadj_add5",
    6: "ofLadj_add6",
    7: "ofLadj_add7",
    8: "ofLadj_add8",
    9: "ofLadj_add9",
    12: "ofLadj_add12",
    15: "ofLadj_add15",
}

EVAL_SIMP = (
    "  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,\n"
    "    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,\n"
    "    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]"
)


def isz_k(a) -> bool:
    return not any(a)


def isz_l(x) -> bool:
    return isz_k(x[0]) and isz_k(x[1])


def pad10(a):
    a = list(a) + [Fraction(0)] * 10
    return a[:10]


def ladd_raw(x, y):
    return (g.add(x[0], y[0]), g.add(x[1], y[1]))


def lsub_raw(x, y):
    return (g.sub(x[0], y[0]), g.sub(x[1], y[1]))


def lneg_raw(x):
    return (g.neg(x[0]), g.neg(x[1]))


def kpoly(rows, i, j):
    return g.kdec(rows[i][j])


def load_qplus(sn) -> list[list[list[Fraction]]]:
    raw = sn["restricted_plucker"]["plus_15_quadrics"]
    idx = {ij: k for k, ij in enumerate(MONS)}
    out = []
    for q in raw:
        row = [[Fraction(0)] * 10 for _ in range(21)]
        for term in q:
            row[idx[(term["i"], term["j"])]] = pad10(g.kdec(term["c"]))
        out.append(row)
    return out


def bilin_k(a, b, m):
    i, j = MONS[m]
    if i == j:
        return g.mul(a[i], b[i])
    return g.add(g.mul(a[i], b[j]), g.mul(a[j], b[i]))


def bilin_l(a, b, m):
    i, j = MONS[m]
    if i == j:
        return g.lmul_raw(a[i], b[i])
    return ladd_raw(g.lmul_raw(a[i], b[j]), g.lmul_raw(a[j], b[i]))


def emit_named_matrix(name: str, M, rows: int, cols: int, imag=True) -> list[str]:
    lines = []
    for i in range(rows):
        for j in range(cols):
            if imag:
                re, im = M[i][j]
            else:
                re, im = M[i][j], []
            lines += [
                f"def {name}_re_{i}_{j} : Polynomial ℚ := {g.lean_poly(re)}",
                f"def {name}_im_{i}_{j} : Polynomial ℚ := {g.lean_poly(im)}",
                f"def {name}_entry_{i}_{j} : Ki := ofLadj {name}_re_{i}_{j} {name}_im_{i}_{j}",
                "",
            ]
        lines.append(f"def {name}_row{i} : Fin {cols} → Ki := fun j =>")
        lines.append("  match j.val with")
        for j in range(cols):
            lines.append(f"  | {j} => {name}_entry_{i}_{j}")
        lines += [f"  | _ => {name}_entry_{i}_0", ""]
    lines += [
        f"def {name} : Matrix (Fin {rows}) (Fin {cols}) Ki :=",
        "  fun i =>",
        "    match i.val with",
    ]
    for i in range(rows):
        lines.append(f"    | {i} => {name}_row{i}")
    lines += [f"    | _ => {name}_row0", ""]
    return lines


def emit_poly_matrix(name: str, M, rows: int, cols: int) -> list[str]:
    lines = []
    for i in range(rows):
        for j in range(cols):
            lines += [
                f"def {name}_{i}_{j} : Polynomial ℚ := {g.lean_poly(M[i][j])}",
                "",
            ]
        lines.append(f"def {name}_row{i} : Fin {cols} → Polynomial ℚ := fun j =>")
        lines.append("  match j.val with")
        for j in range(cols):
            lines.append(f"  | {j} => {name}_{i}_{j}")
        lines += [f"  | _ => {name}_{i}_0", ""]
    lines += [
        f"def {name} : Matrix (Fin {rows}) (Fin {cols}) (Polynomial ℚ) :=",
        "  fun i =>",
        "    match i.val with",
    ]
    for i in range(rows):
        lines.append(f"    | {i} => {name}_row{i}")
    lines += [f"    | _ => {name}_row0", ""]
    return lines


def emit_apply_ki_row(name: str, i: int, rows: int, cols: int,
                      extra_imports=None) -> list[str]:
    lines = g.header_import(extra_imports or [])
    for j in range(cols):
        lines += [
            f"theorem {name}_apply_{i}_{j} :",
            f"    {name} ({i} : Fin {rows}) ({j} : Fin {cols}) = {name}_entry_{i}_{j} := by",
            f"  unfold {name} {name}_row{i}",
            "  rfl",
            "",
        ]
    lines += g.footer()
    return lines


def emit_apply_poly_row(name: str, i: int, rows: int, cols: int,
                        extra_imports=None) -> list[str]:
    lines = g.header_import(extra_imports or [])
    for j in range(cols):
        lines += [
            f"theorem {name}_apply_{i}_{j} :",
            f"    {name} ({i} : Fin {rows}) ({j} : Fin {cols}) = {name}_{i}_{j} := by",
            f"  unfold {name} {name}_row{i}",
            "  rfl",
            "",
        ]
    lines += g.footer()
    return lines


def emit_funext_eq(thm: str, lhs: str, rhs: str, names: list[str], phi=False) -> list[str]:
    unfold = ", ".join(names)
    lines = [
        f"theorem {thm} :",
        f"    {lhs} = {rhs} := by",
        "  refine Polynomial.funext fun r => ?_",
    ]
    if phi:
        lines.append("  rw [Phi11_expand]")
    lines += [
        f"  simp only [{unfold}]",
        EVAL_SIMP,
        "  try ring",
        "",
    ]
    return lines


def add_lemma_for(n: int) -> str:
    if n in ADD_LEMMA:
        return ADD_LEMMA[n]
    if n == 1:
        return ""
    raise SystemExit(f"no ofLadj_add lemma for {n} terms")


def emit_core(out: Path, U, V, Q, Bplus):
    lines = [
        "/-",
        "Plus Segre span matrices U, V over Ki.",
        "-/",
        "import V14Formalization.D12SigmaPlusSegreEval",
        "",
        "noncomputable section",
        "open Matrix Polynomial",
        "namespace V14Formalization.D12SigmaPlusSegreCore",
        "",
    ]
    lines += emit_named_matrix("spanU", U, 15, 9, imag=True)
    lines += emit_named_matrix("spanV", V, 9, 15, imag=True)
    lines += ["end V14Formalization.D12SigmaPlusSegreCore", ""]
    (out / "D12SigmaPlusSegreSpanCore.lean").write_text("\n".join(lines))

    qL = [[(Q[q][m], []) for m in range(21)] for q in range(15)]
    qlines = [
        "/-",
        "Restricted Plücker coefficient matrix of Bplus, as ofLadj elements.",
        "-/",
        "import V14Formalization.D12SigmaPlusSegreEval",
        "",
        "noncomputable section",
        "open Matrix Polynomial",
        "namespace V14Formalization.D12SigmaPlusSegreCore",
        "",
    ]
    qlines += emit_named_matrix("Qplus", qL, 15, 21, imag=True)
    qlines += ["end V14Formalization.D12SigmaPlusSegreCore", ""]
    (out / "D12SigmaPlusSegreQplus.lean").write_text("\n".join(qlines))

    blines = [
        "/-",
        "Polynomial representative of the concrete plus carrier Bplus.",
        "-/",
        "import V14Formalization.D12SigmaPlusSegreEval",
        "",
        "noncomputable section",
        "open Matrix Polynomial",
        "namespace V14Formalization.D12SigmaPlusSegreCore",
        "",
    ]
    blines += emit_poly_matrix("Bplus_poly", Bplus, 15, 6)
    blines += ["end V14Formalization.D12SigmaPlusSegreCore", ""]
    (out / "D12SigmaPlusSegreBplusPoly.lean").write_text("\n".join(blines))
    print("wrote span/Qplus/Bplus data")


def emit_apply_bundle(out: Path, name: str, rows: int, cols: int,
                      data_mod: str, poly=False, decl: str | None = None):
    decl = decl or name
    extras = [f"import V14Formalization.{data_mod}"]
    imports = []
    for i in range(rows):
        fname = f"D12SigmaPlusSegreApply_{name}_{i}.lean"
        if poly:
            text = emit_apply_poly_row(decl, i, rows, cols, extras)
        else:
            text = emit_apply_ki_row(decl, i, rows, cols, extras)
        (out / fname).write_text("\n".join(text))
        imports.append(f"import V14Formalization.D12SigmaPlusSegreApply_{name}_{i}")
    agg = [
        "/-",
        f"Apply lemmas for {decl}.",
        "-/",
        *imports,
        "",
    ]
    (out / f"D12SigmaPlusSegreApply_{name}.lean").write_text("\n".join(agg))


def emit_apply_all(out: Path):
    emit_apply_bundle(out, "spanV", 9, 15, "D12SigmaPlusSegreSpanCore")
    emit_apply_bundle(out, "spanU", 15, 9, "D12SigmaPlusSegreSpanCore")
    emit_apply_bundle(out, "Qplus", 15, 21, "D12SigmaPlusSegreQplus")
    emit_apply_bundle(out, "BplusPoly", 15, 6,
                      "D12SigmaPlusSegreBplusPoly", poly=True,
                      decl="Bplus_poly")
    print("wrote apply modules")


def emit_bplus_eq(out: Path):
    lines = [
        "/-",
        "Identify the emitted Bplus polynomial matrix with B_poly * Kplus_poly",
        "and with the concrete plus carrier after evaluation.",
        "-/",
        "import V14Formalization.D12SigmaPlusSegreApply_BplusPoly",
        "import V14Formalization.D12SigmaPlusQuadric6",
        "import V14Formalization.D12SigmaCarrierConcrete",
        "import V14Formalization.D12SigmaCarrierPolynomialCore",
        "",
        "noncomputable section",
        "open Matrix Polynomial",
        "namespace V14Formalization.D12SigmaPlusSegreCore",
        "open D12PolynomialData D12PolynomialEvaluation",
        "open D12SigmaCarrierPolynomial D12SigmaPlusQuadric6",
        "",
    ]
    krows = ", ".join(f"Kplus_poly_row{k}" for k in range(10))
    for i in range(15):
        for j in range(6):
            lines += [
                f"theorem B_mul_Kplus_poly_{i}_{j} :",
                f"    (B_poly * Kplus_poly) ({i} : Fin 15) ({j} : Fin 6) =",
                f"      Bplus_poly_{i}_{j} := by",
                "  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,",
                f"    {krows}, Bplus_poly_{i}_{j}]",
                "  try ring",
                "",
            ]
    for i in range(15):
        applies = ", ".join(f"Bplus_poly_apply_{i}_{j}" for j in range(6))
        muls = ", ".join(f"B_mul_Kplus_poly_{i}_{j}" for j in range(6))
        lines += [
            f"theorem B_mul_Kplus_row{i} (j : Fin 6) :",
            f"    (B_poly * Kplus_poly) (⟨{i}, by decide⟩ : Fin 15) j =",
            f"      Bplus_poly (⟨{i}, by decide⟩ : Fin 15) j := by",
            "  fin_cases j <;>",
            f"    simp [{applies}, {muls}]",
            "",
        ]
    lines += [
        "theorem B_mul_Kplus_poly : B_poly * Kplus_poly = Bplus_poly := by",
        "  apply Matrix.ext",
        "  intro i j",
        "  fin_cases i",
    ]
    for i in range(15):
        lines.append(f"  · exact B_mul_Kplus_row{i} j")
    lines += [
        "",
        "theorem evalMatrixK_Bplus_poly :",
        "    evalMatrixK Bplus_poly = D12SigmaCarrierConcrete.core.Bplus := by",
        "  rw [← B_mul_Kplus_poly]",
        "  change evalMatrixAt WeilRep.ζ (B_poly * Kplus_poly) = _",
        "  rw [evalMatrixAt_mul]",
        "  rfl",
        "",
        "def BplusKi : Matrix (Fin 15) (Fin 6) Ki :=",
        "  (D12SigmaCarrierConcrete.core.Bplus).map (algebraMap k Ki)",
        "",
        "theorem BplusKi_eq_map_eval :",
        "    BplusKi = (evalMatrixK Bplus_poly).map (algebraMap k Ki) := by",
        "  rw [BplusKi, evalMatrixK_Bplus_poly]",
        "",
        "theorem restrictedPluckerCoeffs_BplusKi_map (q : Fin 15) :",
        "    restrictedPluckerCoeffs BplusKi q =",
        "      fun m => algebraMap k Ki",
        "        (restrictedPluckerCoeffs (evalMatrixK Bplus_poly) q m) := by",
        "  rw [BplusKi_eq_map_eval]",
        "  exact restrictedPluckerCoeffs_map (algebraMap k Ki)",
        "    (evalMatrixK Bplus_poly) q",
        "",
        "theorem restrictedPluckerCoeffs_evalMatrixK (q : Fin 15) :",
        "    restrictedPluckerCoeffs (evalMatrixK Bplus_poly) q =",
        "      fun m => ofPoly (restrictedPluckerCoeffs Bplus_poly q m) := by",
        "  simpa [evalMatrixK, evalMatrixAt, ofPoly] using",
        "    restrictedPluckerCoeffs_map (evalPolyAt WeilRep.ζ) Bplus_poly q",
        "",
        "end V14Formalization.D12SigmaPlusSegreCore",
        "",
    ]
    (out / "D12SigmaPlusSegreBplus.lean").write_text("\n".join(lines))
    print("wrote Bplus identification")


def emit_qrel(out: Path, q: int, Bplus, Q):
    p1, p2, p3, p4, p5, p6 = PLUCKER[q]
    extras = [
        "import V14Formalization.D12SigmaPlusSegreQplus",
        "import V14Formalization.D12SigmaPlusSegreApply_Qplus",
        "import V14Formalization.D12SigmaPlusSegreApply_BplusPoly",
        "import V14Formalization.D12SigmaPlusSegreBplus",
        "import V14Formalization.D12SigmaPlusQuadric6",
    ]
    lines = g.header_import(extras)
    lines += [
        "open D12SigmaPlusQuadric6",
        "",
    ]
    row_names = ", ".join(
        f"Bplus_poly_row{r}" for r in (p1, p2, p3, p4, p5, p6))
    for m in range(21):
        i, j = MONS[m]
        raw = g.add(
            g.sub(bilin_k(Bplus[p1], Bplus[p2], m),
                  bilin_k(Bplus[p3], Bplus[p4], m)),
            bilin_k(Bplus[p5], Bplus[p6], m))
        quot, rem = g.divmod_phi(raw)
        tgt = pad10(Q[q][m])
        if rem != tgt:
            raise SystemExit(f"Qrel remainder failed at {q},{m}")
        if i == j:
            expand = (
                f"Bplus_poly_{p1}_{i} * Bplus_poly_{p2}_{i} - "
                f"Bplus_poly_{p3}_{i} * Bplus_poly_{p4}_{i} + "
                f"Bplus_poly_{p5}_{i} * Bplus_poly_{p6}_{i}"
            )
            unfold = [
                f"Bplus_poly_{p1}_{i}", f"Bplus_poly_{p2}_{i}",
                f"Bplus_poly_{p3}_{i}", f"Bplus_poly_{p4}_{i}",
                f"Bplus_poly_{p5}_{i}", f"Bplus_poly_{p6}_{i}",
            ]
        else:
            expand = (
                f"(Bplus_poly_{p1}_{i} * Bplus_poly_{p2}_{j} + "
                f"Bplus_poly_{p1}_{j} * Bplus_poly_{p2}_{i}) - "
                f"(Bplus_poly_{p3}_{i} * Bplus_poly_{p4}_{j} + "
                f"Bplus_poly_{p3}_{j} * Bplus_poly_{p4}_{i}) + "
                f"(Bplus_poly_{p5}_{i} * Bplus_poly_{p6}_{j} + "
                f"Bplus_poly_{p5}_{j} * Bplus_poly_{p6}_{i})"
            )
            unfold = [
                f"Bplus_poly_{p1}_{i}", f"Bplus_poly_{p1}_{j}",
                f"Bplus_poly_{p2}_{i}", f"Bplus_poly_{p2}_{j}",
                f"Bplus_poly_{p3}_{i}", f"Bplus_poly_{p3}_{j}",
                f"Bplus_poly_{p4}_{i}", f"Bplus_poly_{p4}_{j}",
                f"Bplus_poly_{p5}_{i}", f"Bplus_poly_{p5}_{j}",
                f"Bplus_poly_{p6}_{i}", f"Bplus_poly_{p6}_{j}",
            ]
        lines += [
            f"def Qraw_{q}_{m} : Polynomial ℚ := {g.lean_poly(raw)}",
            f"def Qquot_{q}_{m} : Polynomial ℚ := {g.lean_poly(quot)}",
            "",
            f"theorem Qexpand_{q}_{m} :",
            f"    restrictedPluckerCoeffs Bplus_poly ({q} : Fin 15) ({m} : Fin 21) =",
            f"      {expand} := by",
            "  simp [restrictedPluckerCoeffs, bilinearCoeffs,",
            f"    monomPair_{m}, pluckerRelation_{q}, Bplus_poly, {row_names}]",
            "  try ring",
            "",
        ]
        lines += emit_funext_eq(
            f"Qraw_eq_{q}_{m}",
            expand,
            f"Qraw_{q}_{m}",
            unfold + [f"Qraw_{q}_{m}"],
        )
        lines += emit_funext_eq(
            f"Qrel_{q}_{m}",
            f"Qraw_{q}_{m}",
            f"Qplus_re_{q}_{m} + Phi11 * Qquot_{q}_{m}",
            [f"Qraw_{q}_{m}", f"Qplus_re_{q}_{m}", f"Qquot_{q}_{m}"],
            phi=True,
        )
        lines += [
            f"theorem Qplus_eq_restricted_{q}_{m} :",
            f"    restrictedPluckerCoeffs BplusKi ({q} : Fin 15) ({m} : Fin 21) =",
            f"      Qplus_entry_{q}_{m} := by",
            f"  rw [congrFun (restrictedPluckerCoeffs_BplusKi_map ({q} : Fin 15)) ({m} : Fin 21),",
            f"    congrFun (restrictedPluckerCoeffs_evalMatrixK ({q} : Fin 15)) ({m} : Fin 21),",
            f"    Qexpand_{q}_{m}, Qraw_eq_{q}_{m}, Qrel_{q}_{m}, ofPoly_add_Phi11]",
            f"  simp [Qplus_entry_{q}_{m}, Qplus_im_{q}_{m}, ofLadj_ofPoly]",
            "",
        ]
    lines += [
        f"theorem Qplus_eq_restricted_row_{q} (m : Fin 21) :",
        f"    restrictedPluckerCoeffs BplusKi ({q} : Fin 15) m = Qplus ({q} : Fin 15) m := by",
        "  fin_cases m",
    ]
    for m in range(21):
        lines.append(
            f"  · simpa [Qplus_apply_{q}_{m}] using Qplus_eq_restricted_{q}_{m}")
    lines += ["", *g.footer()]
    path = out / f"D12SigmaPlusSegreQrel_{q}.lean"
    path.write_text("\n".join(lines))
    print("wrote", path.name)


def emit_plucker_dispatch(out: Path):
    lines = [
        "/-",
        "Dispatch restricted Plücker coefficients of BplusKi to Qplus.",
        "-/",
    ]
    for q in range(15):
        lines.append(f"import V14Formalization.D12SigmaPlusSegreQrel_{q}")
    lines += [
        "",
        "noncomputable section",
        "open Matrix",
        "namespace V14Formalization.D12SigmaPlusSegreCore",
        "open D12SigmaPlusQuadric6",
        "",
        "theorem Qplus_eq_restricted (q : Fin 15) (m : Fin 21) :",
        "    restrictedPluckerCoeffs BplusKi q m = Qplus q m := by",
        "  fin_cases q",
    ]
    for q in range(15):
        lines.append(f"  · exact Qplus_eq_restricted_row_{q} m")
    lines += [
        "",
        "end V14Formalization.D12SigmaPlusSegreCore",
        "",
    ]
    (out / "D12SigmaPlusSegrePlucker.lean").write_text("\n".join(lines))
    print("wrote Plucker dispatcher")


def emit_span_sm(out: Path, s: int, m: int, H, V, Q):
    a0, a1, b0, b1 = MINOR_ORDER[s]
    rA, rB = 3 * a0 + b0, 3 * a1 + b1
    rC, rD = 3 * a0 + b1, 3 * a1 + b0
    ii, jj = MONS[m]
    prefix = f"SP_{s}_{m}"
    extras = [
        "import V14Formalization.D12SigmaPlusSegreGeom",
        "import V14Formalization.D12SigmaPlusSegreApplyH",
        "import V14Formalization.D12SigmaPlusSegreApply_spanV",
        "import V14Formalization.D12SigmaPlusSegreApply_Qplus",
    ]
    lines = g.header_import(extras)
    lines += ["open D12SigmaPlusQuadric6", ""]

    def hprod(ra, ca, rb, cb, tag):
        pre, pim = g.lmul_raw(H[ra][ca], H[rb][cb])
        lines.append(f"def {prefix}_{tag}_re : Polynomial ℚ := {g.lean_poly(pre)}")
        lines.append(f"def {prefix}_{tag}_im : Polynomial ℚ := {g.lean_poly(pim)}")
        lines.extend(emit_funext_eq(
            f"{prefix}_{tag}_re_eq",
            f"H_re_{ra}_{ca} * H_re_{rb}_{cb} - H_im_{ra}_{ca} * H_im_{rb}_{cb}",
            f"{prefix}_{tag}_re",
            [f"H_re_{ra}_{ca}", f"H_im_{ra}_{ca}",
             f"H_re_{rb}_{cb}", f"H_im_{rb}_{cb}", f"{prefix}_{tag}_re"],
        ))
        lines.extend(emit_funext_eq(
            f"{prefix}_{tag}_im_eq",
            f"H_re_{ra}_{ca} * H_im_{rb}_{cb} + H_im_{ra}_{ca} * H_re_{rb}_{cb}",
            f"{prefix}_{tag}_im",
            [f"H_re_{ra}_{ca}", f"H_im_{ra}_{ca}",
             f"H_re_{rb}_{cb}", f"H_im_{rb}_{cb}", f"{prefix}_{tag}_im"],
        ))
        lines.extend([
            f"theorem {prefix}_{tag}_term :",
            f"    H_entry_{ra}_{ca} * H_entry_{rb}_{cb} =",
            f"      ofLadj {prefix}_{tag}_re {prefix}_{tag}_im := by",
            f"  rw [H_entry_{ra}_{ca}, H_entry_{rb}_{cb}, ofLadj_mul,",
            f"    {prefix}_{tag}_re_eq, {prefix}_{tag}_im_eq]",
            "",
        ])
        return (pre, pim)

    if ii == jj:
        t1 = hprod(rA, ii, rB, ii, "t1")
        t2 = hprod(rC, ii, rD, ii, "t2")
        lhs = lsub_raw(t1, t2)
        happlies = [
            f"H_apply_{rA}_{ii}", f"H_apply_{rB}_{ii}",
            f"H_apply_{rC}_{ii}", f"H_apply_{rD}_{ii}",
        ]
        lines += [
            f"theorem {prefix}_minor_expand :",
            f"    minorCoeffsH ({s} : Fin 9) ({m} : Fin 21) =",
            f"      H_entry_{rA}_{ii} * H_entry_{rB}_{ii} -",
            f"        H_entry_{rC}_{ii} * H_entry_{rD}_{ii} := by",
            "  simp only [minorCoeffsH, bilinearCoeffs, Hrow,",
            f"    minorOrder_{s}, monomPair_{m}]",
            f"  simp only [{', '.join(happlies)}]",
            "",
            f"theorem {prefix}_minor_ofLadj :",
            f"    minorCoeffsH ({s} : Fin 9) ({m} : Fin 21) =",
            f"      ofLadj ({prefix}_t1_re - {prefix}_t2_re)",
            f"        ({prefix}_t1_im - {prefix}_t2_im) := by",
            f"  rw [{prefix}_minor_expand, {prefix}_t1_term, {prefix}_t2_term, ofLadj_sub]",
            "",
        ]
        lhs_re_expr = f"{prefix}_t1_re - {prefix}_t2_re"
        lhs_im_expr = f"{prefix}_t1_im - {prefix}_t2_im"
        lhs_names = [
            f"{prefix}_t1_re", f"{prefix}_t2_re",
            f"{prefix}_t1_im", f"{prefix}_t2_im",
        ]
    else:
        t1a = hprod(rA, ii, rB, jj, "t1a")
        t1b = hprod(rA, jj, rB, ii, "t1b")
        t2a = hprod(rC, ii, rD, jj, "t2a")
        t2b = hprod(rC, jj, rD, ii, "t2b")
        lhs = lsub_raw(ladd_raw(t1a, t1b), ladd_raw(t2a, t2b))
        happlies = [
            f"H_apply_{rA}_{ii}", f"H_apply_{rA}_{jj}",
            f"H_apply_{rB}_{ii}", f"H_apply_{rB}_{jj}",
            f"H_apply_{rC}_{ii}", f"H_apply_{rC}_{jj}",
            f"H_apply_{rD}_{ii}", f"H_apply_{rD}_{jj}",
        ]
        lines += [
            f"theorem {prefix}_minor_expand :",
            f"    minorCoeffsH ({s} : Fin 9) ({m} : Fin 21) =",
            f"      (H_entry_{rA}_{ii} * H_entry_{rB}_{jj} +",
            f"        H_entry_{rA}_{jj} * H_entry_{rB}_{ii}) -",
            f"        (H_entry_{rC}_{ii} * H_entry_{rD}_{jj} +",
            f"          H_entry_{rC}_{jj} * H_entry_{rD}_{ii}) := by",
            "  simp only [minorCoeffsH, bilinearCoeffs, Hrow,",
            f"    minorOrder_{s}, monomPair_{m}]",
            f"  simp only [{', '.join(happlies)}]",
            "",
            f"theorem {prefix}_minor_ofLadj :",
            f"    minorCoeffsH ({s} : Fin 9) ({m} : Fin 21) =",
            f"      ofLadj (({prefix}_t1a_re + {prefix}_t1b_re) -",
            f"          ({prefix}_t2a_re + {prefix}_t2b_re))",
            f"        (({prefix}_t1a_im + {prefix}_t1b_im) -",
            f"          ({prefix}_t2a_im + {prefix}_t2b_im)) := by",
            f"  rw [{prefix}_minor_expand, {prefix}_t1a_term, {prefix}_t1b_term,",
            f"    {prefix}_t2a_term, {prefix}_t2b_term, ofLadj_add, ofLadj_add,",
            "    ofLadj_sub]",
            "",
        ]
        lhs_re_expr = (
            f"({prefix}_t1a_re + {prefix}_t1b_re) - "
            f"({prefix}_t2a_re + {prefix}_t2b_re)")
        lhs_im_expr = (
            f"({prefix}_t1a_im + {prefix}_t1b_im) - "
            f"({prefix}_t2a_im + {prefix}_t2b_im)")
        lhs_names = [
            f"{prefix}_t1a_re", f"{prefix}_t1b_re",
            f"{prefix}_t2a_re", f"{prefix}_t2b_re",
            f"{prefix}_t1a_im", f"{prefix}_t1b_im",
            f"{prefix}_t2a_im", f"{prefix}_t2b_im",
        ]

    nz = []
    acc = ([], [])
    for q in range(15):
        term = g.lmul_raw(V[s][q], (Q[q][m], []))
        if isz_l(term):
            continue
        nz.append(q)
        acc = ladd_raw(acc, term)
        pre, pim = term
        lines.append(f"def {prefix}_pre_{q} : Polynomial ℚ := {g.lean_poly(pre)}")
        lines.append(f"def {prefix}_pim_{q} : Polynomial ℚ := {g.lean_poly(pim)}")
        lines.extend(emit_funext_eq(
            f"{prefix}_pre_eq_{q}",
            f"spanV_re_{s}_{q} * Qplus_re_{q}_{m} - spanV_im_{s}_{q} * Qplus_im_{q}_{m}",
            f"{prefix}_pre_{q}",
            [f"spanV_re_{s}_{q}", f"spanV_im_{s}_{q}",
             f"Qplus_re_{q}_{m}", f"Qplus_im_{q}_{m}", f"{prefix}_pre_{q}"],
        ))
        lines.extend(emit_funext_eq(
            f"{prefix}_pim_eq_{q}",
            f"spanV_re_{s}_{q} * Qplus_im_{q}_{m} + spanV_im_{s}_{q} * Qplus_re_{q}_{m}",
            f"{prefix}_pim_{q}",
            [f"spanV_re_{s}_{q}", f"spanV_im_{s}_{q}",
             f"Qplus_re_{q}_{m}", f"Qplus_im_{q}_{m}", f"{prefix}_pim_{q}"],
        ))
        lines += [
            f"theorem {prefix}_term_{q} :",
            f"    spanV_entry_{s}_{q} * Qplus_entry_{q}_{m} =",
            f"      ofLadj {prefix}_pre_{q} {prefix}_pim_{q} := by",
            f"  rw [spanV_entry_{s}_{q}, Qplus_entry_{q}_{m}, ofLadj_mul,",
            f"    {prefix}_pre_eq_{q}, {prefix}_pim_eq_{q}]",
            "",
        ]
    if not nz:
        raise SystemExit(f"no span terms at {s},{m}")

    diff = lsub_raw(acc, lhs)
    qre, rre = g.divmod_phi(diff[0])
    qim, rim = g.divmod_phi(diff[1])
    if rre != [Fraction(0)] * 10 or rim != [Fraction(0)] * 10:
        raise SystemExit(f"span remainder failed at {s},{m}: {rre}, {rim}")

    lines += [
        f"def {prefix}_qre : Polynomial ℚ := {g.lean_poly(qre)}",
        f"def {prefix}_qim : Polynomial ℚ := {g.lean_poly(qim)}",
        "",
    ]
    re_sum = " + ".join(f"{prefix}_pre_{q}" for q in nz)
    im_sum = " + ".join(f"{prefix}_pim_{q}" for q in nz)
    term_sum = " + ".join(
        f"spanV_entry_{s}_{q} * Qplus_entry_{q}_{m}" for q in nz)
    term_thms = ", ".join(f"{prefix}_term_{q}" for q in nz)
    addN = add_lemma_for(len(nz))
    add_args = " ".join(
        f"{prefix}_pre_{q} {prefix}_pim_{q}" for q in nz)

    pre_names = [f"{prefix}_pre_{q}" for q in nz]
    pim_names = [f"{prefix}_pim_{q}" for q in nz]
    lines += emit_funext_eq(
        f"{prefix}_sum_poly_re",
        re_sum,
        f"{lhs_re_expr} + Phi11 * {prefix}_qre",
        pre_names + lhs_names + [f"{prefix}_qre"],
        phi=True,
    )
    lines += emit_funext_eq(
        f"{prefix}_sum_poly_im",
        im_sum,
        f"{lhs_im_expr} + Phi11 * {prefix}_qim",
        pim_names + lhs_names + [f"{prefix}_qim"],
        phi=True,
    )
    lines += [
        f"theorem {prefix}_sum_entries :",
        f"    {term_sum} =",
        f"      ofLadj ({re_sum}) ({im_sum}) := by",
        f"  simp only [{term_thms}]",
    ]
    if len(nz) == 1:
        lines.append("  rfl")
    else:
        lines.append(f"  simpa [add_assoc] using {addN} {add_args}")
    qplus_sum = " + ".join(
        f"spanV ({s} : Fin 9) ({q} : Fin 15) * Qplus ({q} : Fin 15) ({m} : Fin 21)"
        for q in nz)
    lines += [
        "",
        f"theorem {prefix}_eval :",
        f"    ofLadj ({re_sum}) ({im_sum}) =",
        f"      ofLadj ({lhs_re_expr}) ({lhs_im_expr}) := by",
        f"  rw [{prefix}_sum_poly_re, {prefix}_sum_poly_im, ofLadj_add_Phi11]",
        "",
        f"theorem {prefix}_on_Qplus :",
        f"    minorCoeffsH ({s} : Fin 9) ({m} : Fin 21) =",
        f"      {qplus_sum} := by",
        f"  rw [{prefix}_minor_ofLadj]",
    ]
    for q in nz:
        lines.append(f"  rw [spanV_apply_{s}_{q}, Qplus_apply_{q}_{m}]")
    lines += [
        f"  exact ({prefix}_sum_entries).trans {prefix}_eval",
        "",
    ]
    zero_qs = [q for q in range(15) if q not in nz]
    for q in zero_qs:
        lines += [
            f"theorem {prefix}_zero_{q} :",
            f"    spanV ({s} : Fin 9) ({q} : Fin 15) * Qplus ({q} : Fin 15) ({m} : Fin 21) =",
            "      0 := by",
            f"  rw [spanV_apply_{s}_{q}, Qplus_apply_{q}_{m},",
            f"    spanV_entry_{s}_{q}, Qplus_entry_{q}_{m}]",
            "  simp [ofLadj_mul, ofLadj_zero]",
            "",
        ]
    lines += [
        f"theorem span_coeff_{s}_{m} :",
        f"    minorCoeffsH ({s} : Fin 9) ({m} : Fin 21) =",
        "      ∑ q : Fin 15, spanV ({s} : Fin 9) q * Qplus q ({m} : Fin 21) := by",
        "  rw [sum_fin15]",
    ]
    for q in zero_qs:
        lines.append(f"  rw [{prefix}_zero_{q}]")
    lines += [
        "  simp only [add_zero, zero_add]",
        f"  exact {prefix}_on_Qplus",
        "",
    ]
    lines += g.footer()
    path = out / f"D12SigmaPlusSegreSpanV_{s}_{m}.lean"
    path.write_text("\n".join(lines))
    print("wrote", path.name, "nnz", len(nz))


def emit_assembler(out: Path):
    lines = [
        "/-",
        "Each 2×2 minor of reshape(H u) is a Ki-linear combination of the",
        "fifteen restricted Plücker quadrics of Bplus * u.",
        "-/",
    ]
    for s in range(9):
        for m in range(21):
            lines.append(
                f"import V14Formalization.D12SigmaPlusSegreSpanV_{s}_{m}")
    lines += [
        "import V14Formalization.D12SigmaPlusSegrePlucker",
        "",
        "noncomputable section",
        "open Matrix",
        "open scoped BigOperators",
        "namespace V14Formalization.D12SigmaPlusSegreCore",
        "open D12SigmaPlusQuadric6",
        "",
        "theorem minorCoeffsH_eq_spanV_Qplus",
        "    (s : Fin 9) (m : Fin 21) :",
        "    minorCoeffsH s m =",
        "      ∑ q : Fin 15, spanV s q * Qplus q m := by",
        "  fin_cases s <;> fin_cases m",
    ]
    for s in range(9):
        for m in range(21):
            lines.append(f"  · exact span_coeff_{s}_{m}")
    lines += [
        "",
        "theorem minorCoeffsH_eq_spanV_restrictedPlucker",
        "    (s : Fin 9) (m : Fin 21) :",
        "    minorCoeffsH s m =",
        "      ∑ q : Fin 15, spanV s q *",
        "        restrictedPluckerCoeffs BplusKi q m := by",
        "  simpa [Qplus_eq_restricted] using minorCoeffsH_eq_spanV_Qplus s m",
        "",
        "theorem minorCoeffsH_eq_spanV_smul (s : Fin 9) :",
        "    minorCoeffsH s =",
        "      ∑ q : Fin 15, spanV s q • restrictedPluckerCoeffs BplusKi q := by",
        "  funext m",
        "  simp only [Finset.sum_apply, Pi.smul_apply, smul_eq_mul]",
        "  exact minorCoeffsH_eq_spanV_restrictedPlucker s m",
        "",
        "theorem reshapeMinor_eq_spanV_plucker",
        "    (u : Fin 6 → Ki) (s : Fin 9) :",
        "    D12SigmaPlusQuadric6.reshapeMinor (H.mulVec u) s =",
        "      ∑ q : Fin 15, spanV s q *",
        "        D12Certificate.pluckerValue",
        "          ((D12SigmaCarrierConcrete.core.Bplus).map",
        "            (algebraMap k Ki)).mulVec u) q := by",
        "  rw [reshapeMinor_H_mulVec, minorCoeffsH_eq_spanV_smul]",
        "  rw [quadValue_linear]",
        "  refine Finset.sum_congr rfl fun q _ => ?_",
        "  rw [quadValue_restrictedPluckerCoeffs]",
        "  rfl",
        "",
        "end V14Formalization.D12SigmaPlusSegreCore",
        "",
    ]
    (out / "D12SigmaPlusSegreSpan.lean").write_text("\n".join(lines))
    print("wrote assembler")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--out-dir", type=Path, required=True)
    parser.add_argument("--only", type=str, default="")
    args = parser.parse_args()
    out = args.out_dir.resolve()
    out.mkdir(parents=True, exist_ok=True)
    data = g.json.loads(JSON_PATH.read_text()) if hasattr(g, "json") else None
    import json
    data = json.loads(JSON_PATH.read_text())
    sn = json.loads(SIGMA_JSON.read_text())
    U = g.lmat(data["span_witnesses"]["Qplus_eq_U_times_minors"])
    V = g.lmat(data["span_witnesses"]["minors_eq_V_times_Qplus"])
    H = g.lmat(data["cross_coordinate_H_9x6"])
    Q = load_qplus(sn)
    Bplus = [[g.kdec(c) for c in r] for r in sn["eigenspaces"]["Bplus_15x6"]]
    only = args.only

    if only in ("", "core"):
        emit_core(out, U, V, Q, Bplus)
    if only in ("", "apply"):
        emit_apply_all(out)
    if only in ("", "bplus"):
        emit_bplus_eq(out)
    if only.startswith("Qrel_"):
        emit_qrel(out, int(only.split("_")[1]), Bplus, Q)
    elif only in ("", "qrel"):
        for q in range(15):
            emit_qrel(out, q, Bplus, Q)
    if only in ("", "plucker"):
        emit_plucker_dispatch(out)
    if only.startswith("span_"):
        _, s, m = only.split("_")
        emit_span_sm(out, int(s), int(m), H, V, Q)
    elif only in ("", "span"):
        for s in range(9):
            for m in range(21):
                emit_span_sm(out, s, m, H, V, Q)
    if only in ("", "asm"):
        emit_assembler(out)


if __name__ == "__main__":
    main()
