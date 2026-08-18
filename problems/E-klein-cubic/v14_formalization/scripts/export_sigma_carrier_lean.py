#!/usr/bin/env python3
"""Emit bounded Lean certificates for the two restricted sigma carriers.

The source packet stores ambient plus/minus bases.  This exporter first
recomputes their coordinates in the already checked ten-dimensional D12 basis
and fail-closes that multiplying those coordinates by the D12 basis recovers
the stored ambient bases.  Lean only receives the smaller 10x6 and 10x4
coordinate matrices.

The generated bridge shards first identify the symbolic restricted action with
an explicit degree-<10 representative, one bounded matrix entry at a time.
The eigen shards then prove one column of

    Srestricted_reduced_poly * Kplus_poly  =  Kplus_poly
    Srestricted_reduced_poly * Kminus_poly = -Kminus_poly

modulo Phi_11.  Thus no declaration expands both the compound Fourier matrix
and a carrier matrix product.  No resource-limit options or evaluator escapes
are emitted.
"""

from __future__ import annotations

import argparse
import hashlib
import json
from fractions import Fraction
from math import lcm
from pathlib import Path
from typing import Iterable

ROOT = Path(__file__).resolve().parents[1]
SIGMA_JSON = ROOT / "results" / "sigma_normal_form_K.json"
D12_JSON = ROOT / "results" / "d12_lean_K.json"
OUT = ROOT / "V14Formalization"

KDim = 10


def add(a: list[Fraction], b: list[Fraction]) -> list[Fraction]:
    n = max(len(a), len(b))
    return [(a[i] if i < len(a) else 0) + (b[i] if i < len(b) else 0)
            for i in range(n)]


def neg(a: list[Fraction]) -> list[Fraction]:
    return [-x for x in a]


def sub(a: list[Fraction], b: list[Fraction]) -> list[Fraction]:
    return add(a, neg(b))


def mul(a: list[Fraction], b: list[Fraction]) -> list[Fraction]:
    if not a or not b:
        return []
    out = [Fraction(0)] * (len(a) + len(b) - 1)
    for i, x in enumerate(a):
        for j, y in enumerate(b):
            out[i + j] += x * y
    return trim(out)


def trim(a: list[Fraction]) -> list[Fraction]:
    while a and a[-1] == 0:
        a.pop()
    return a


def monomial(n: int, c: Fraction = Fraction(1)) -> list[Fraction]:
    return [Fraction(0)] * n + [c]


PHI = [Fraction(1)] * 11


def div_exact(a: list[Fraction], b: list[Fraction]) -> list[Fraction]:
    a = trim(a[:])
    b = trim(b[:])
    if not b:
        raise ZeroDivisionError
    q = [Fraction(0)] * max(0, len(a) - len(b) + 1)
    while len(a) >= len(b):
        d = len(a) - len(b)
        c = a[-1] / b[-1]
        q[d] += c
        a = sub(a, monomial(d, c) if b == [1] else mul(monomial(d, c), b))
        a = trim(a)
    if a:
        raise ValueError(f"nonzero remainder {a}")
    return trim(q)


def kdecode(x: list[list[int]]) -> list[Fraction]:
    if len(x) != KDim:
        raise ValueError("expected ten coefficients")
    return [Fraction(int(n), int(d)) for n, d in x]


def kreduce(a: list[Fraction]) -> list[Fraction]:
    a = a[:] + [Fraction(0)] * max(0, 19 - len(a))
    for n in range(len(a) - 1, 9, -1):
        c = a[n]
        if c:
            a[n] = 0
            for j in range(n - 10, n):
                a[j] -= c
    return (a[:10] + [Fraction(0)] * 10)[:10]


def kmul(a: list[Fraction], b: list[Fraction]) -> list[Fraction]:
    return kreduce(mul(a, b))


def kadd(a: list[Fraction], b: list[Fraction]) -> list[Fraction]:
    return [x + y for x, y in zip(a, b)]


def kmatmul(a, b):
    if len(a[0]) != len(b):
        raise ValueError("matrix shape")
    return [[sum_k([kmul(a[i][t], b[t][j]) for t in range(len(b))])
             for j in range(len(b[0]))] for i in range(len(a))]


def sum_k(xs: Iterable[list[Fraction]]) -> list[Fraction]:
    out = [Fraction(0)] * 10
    for x in xs:
        out = kadd(out, x)
    return out


def pmatmul(a, b):
    if len(a[0]) != len(b):
        raise ValueError("matrix shape")
    return [[sum_p([mul(a[i][t], b[t][j]) for t in range(len(b))])
             for j in range(len(b[0]))] for i in range(len(a))]


def sum_p(xs: Iterable[list[Fraction]]) -> list[Fraction]:
    out: list[Fraction] = []
    for x in xs:
        out = add(out, x)
    return trim(out)


def scalar(n: int) -> list[Fraction]:
    return [Fraction(n)]


def s6_entry(i: int, j: int) -> list[Fraction]:
    cf = [Fraction(-1, 11), Fraction(-2, 11), 0, Fraction(-2, 11),
          Fraction(-2, 11), Fraction(-2, 11), 0, 0, 0, Fraction(-2, 11)]
    if j == 0:
        return cf
    a = (i * j) % 11
    return mul(cf, add(monomial(a), monomial((-a) % 11)))


PAIRS = [(0, 1), (0, 2), (0, 3), (0, 4), (0, 5),
         (1, 2), (1, 3), (1, 4), (1, 5), (2, 3),
         (2, 4), (2, 5), (3, 4), (3, 5), (4, 5)]
FREE_ROWS = [0, 1, 2, 3, 4, 6, 7, 9, 11, 14]


def compound_s6() -> list[list[list[Fraction]]]:
    s6 = [[s6_entry(i, j) for j in range(6)] for i in range(6)]
    out = []
    for ia, ib in PAIRS:
        row = []
        for ja, jb in PAIRS:
            row.append(sub(mul(s6[ia][ja], s6[ib][jb]),
                           mul(s6[ia][jb], s6[ib][ja])))
        out.append(row)
    return out


def lean_rat(x: Fraction) -> str:
    if x.denominator == 1:
        return str(x.numerator)
    return f"({x.numerator} / {x.denominator} : ℚ)"


def lean_poly(a: list[Fraction]) -> str:
    terms = []
    for i, c in enumerate(trim(a[:])):
        if not c:
            continue
        cr = lean_rat(c)
        if i == 0:
            terms.append(f"C ({cr})")
        elif i == 1:
            terms.append(f"C ({cr}) * X")
        else:
            terms.append(f"C ({cr}) * X ^ {i}")
    return " + ".join(terms) if terms else "0"


def zlist(a: list[Fraction]) -> tuple[int, list[int]]:
    """Common positive denominator and integer numerators, trailing zeros cut."""
    d = 1
    for coeff in a:
        d = lcm(d, coeff.denominator)
    ns = [int(coeff * d) for coeff in a]
    while ns and ns[-1] == 0:
        ns.pop()
    return d, ns


def lean_interp(a: list[Fraction]) -> str:
    """`interpQ d [n...]` -- the integer reflection of `D12PolyZReflection`.

    Certificates over these are decided by kernel list arithmetic instead of
    `ring_nf` + `module` over rational `C` coefficients, which is what made the
    sigma families the top of the closure table.
    """
    d, ns = zlist(a)
    return "interpQ " + str(d) + " [" + ", ".join(str(n) for n in ns) + "]"


def emit_matrix(name: str, rows, r: int, c: int) -> list[str]:
    lines: list[str] = []
    for i in range(r):
        lines += [f"def {name}_row{i} : Fin {c} → Polynomial ℚ := fun j =>",
                  "  match j.val with"]
        for j in range(c):
            lines.append(f"  | {j} => {lean_interp(trim(rows[i][j][:]))}")
        lines += ["  | _ => 0", ""]
    lines += [f"def {name} : Matrix (Fin {r}) (Fin {c}) (Polynomial ℚ) :=",
              "  Matrix.of fun i =>", "    match i.val with"]
    for i in range(r):
        lines.append(f"    | {i} => {name}_row{i}")
    lines.append(f"    | _ => {name}_row0")
    return lines


def load_data():
    sigma = json.loads(SIGMA_JSON.read_text())
    d12 = json.loads(D12_JSON.read_text())
    kd = lambda m: [[kdecode(x) for x in row] for row in m]
    B = kd(d12["m"]["B15x10"])
    L = kd(d12["m"]["L10x15"])
    bp = kd(sigma["eigenspaces"]["Bplus_15x6"])
    bm = kd(sigma["eigenspaces"]["Bminus_15x4"])
    kp = kmatmul(L, bp)
    km = kmatmul(L, bm)
    if kmatmul(B, kp) != bp or kmatmul(B, km) != bm:
        raise ValueError("restricted coordinates do not recover ambient bases")
    if kp[:6] != [[[Fraction(1) if i == j else Fraction(0)] +
                    [Fraction(0)] * 9 for j in range(6)] for i in range(6)]:
        raise ValueError("plus top block is not identity")
    if km[:4] != [[[Fraction(1) if i == j else Fraction(0)] +
                    [Fraction(0)] * 9 for j in range(4)] for i in range(4)]:
        raise ValueError("minus top block is not identity")
    Bp = [[trim(x[:]) for x in row] for row in B]
    sr = [row[:] for row in pmatmul(compound_s6(), Bp)]
    sr = [sr[i] for i in FREE_ROWS]
    sr_reduced = [[trim(kreduce(x)[:]) for x in row] for row in sr]
    qsr = [[div_exact(sub(sr[i][j], sr_reduced[i][j]), PHI)
            for j in range(10)] for i in range(10)]
    plus_res = pmatmul(sr_reduced, kp)
    minus_res = pmatmul(sr_reduced, km)
    qplus = [[div_exact(sub(plus_res[i][j], kp[i][j]), PHI)
              for j in range(6)] for i in range(10)]
    qminus = [[div_exact(add(minus_res[i][j], km[i][j]), PHI)
               for j in range(4)] for i in range(10)]
    return kp, km, sr, sr_reduced, qsr, qplus, qminus


def header() -> list[str]:
    payload = hashlib.sha256(SIGMA_JSON.read_bytes()).hexdigest()
    return ["/- Auto-generated by scripts/export_sigma_carrier_lean.py.",
            f"   Sigma packet SHA256: {payload}",
            "   Stock-limit, kernel-checkable polynomial certificates. -/"]


def module_scalar_helpers(include_nat_casts: bool = True) -> list[str]:
    lines = [
        "private theorem C_eq_smul_one (a : ℚ) :",
        "    C a = a • (1 : Polynomial ℚ) := by",
        "  rw [Polynomial.smul_eq_C_mul, mul_one]",
        "",
        "private theorem smul_one_sq (a : ℚ) :",
        "    (a • (1 : Polynomial ℚ)) ^ 2 =",
        "      (a * a) • (1 : Polynomial ℚ) := by",
        "  rw [pow_two, smul_mul_assoc, one_mul, smul_smul]",
        "",
    ]
    if include_nat_casts:
        for n in range(2, 41):
            lines += [
                f"private theorem nat{n}_as_C : ({n} : Polynomial ℚ) = C {n} :=",
                f"  (map_natCast C {n}).symm",
            ]
    lines.append("")
    return lines


def module_scalar_simp() -> list[str]:
    names = ", ".join(f"nat{n}_as_C" for n in range(2, 41))
    return [
        f"  (try simp only [{names},",
        "    C_eq_smul_one, smul_one_sq, smul_mul_assoc, mul_smul_comm,",
        "    one_mul, mul_one, smul_smul]) <;>",
        "  module",
    ]


def emit_core(kp, km, sr_reduced, out: Path):
    lines = header() + [
        "import V14Formalization.D12SigmaCarrier",
        "import V14Formalization.D12U6PolynomialSeal",
        "import V14Formalization.D12PolyZReflection",
        "",
        "noncomputable section",
        "open Matrix Polynomial",
        "namespace V14Formalization.D12SigmaCarrierPolynomial",
        "open D12PolynomialData D12PolynomialEvaluation",
        "open D12GeneratorPolynomialCore D12GeneratorInvariance",
        "open V14Formalization.D12PolyZReflection",
        "",
        "theorem z_Phi11 :",
        "    (Phi11 : Polynomial ℚ) = interpQ 1 [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1] := by",
        "  simp [Phi11, interpQ, toPolyZ, Finset.sum_range_succ]",
        "  ring",
        "",
    ]
    lines += emit_matrix("Kplus_poly", kp, 10, 6) + [""]
    lines += emit_matrix("Kminus_poly", km, 10, 4) + [""]
    lines += emit_matrix("Srestricted_reduced_poly", sr_reduced, 10, 10) + [""]
    lines += [
        "def Srestricted_poly : Matrix (Fin 10) (Fin 10) (Polynomial ℚ) :=",
        "  restrictedAction (PluckerNaturality.compound2Lex S6_poly * B_poly)",
        "",
        "theorem evalMatrixK_Srestricted_poly :",
        "    evalMatrixK Srestricted_poly = SrestrictedAction := by",
        "  rfl",
        "",
        "theorem eval_eq_of_modPhi",
        "    {R : Type*} [CommRing R] [Algebra ℚ R] (z : R)",
        "    (hPhi : evalPolyAt z Phi11 = 0) (a b q : Polynomial ℚ)",
        "    (h : a - b = Phi11 * q) : evalPolyAt z a = evalPolyAt z b := by",
        "  simpa using eval_relation_of_modPhi z hPhi a b q 1 (by simpa using h)",
        "",
        "end V14Formalization.D12SigmaCarrierPolynomial",
        "",
    ]
    out.write_text("\n".join(lines))


def s6_explicit_expr(i: int, j: int) -> str:
    if j == 0:
        return "D12U6Semantic.cFourierPoly"
    a = (i * j) % 11
    b = (-a) % 11
    return ("D12U6Semantic.cFourierPoly * "
            f"(X ^ {a} + X ^ {b})")


def emit_s6_explicit(out: Path):
    lines = header() + [
        "import V14Formalization.D12SigmaCarrierPolynomialCore",
        "",
        "noncomputable section",
        "open Matrix Polynomial",
        "namespace V14Formalization.D12SigmaCarrierS6Explicit",
        "open D12GeneratorPolynomialCore",
        "",
    ]
    for i in range(6):
        lines += [f"def S6_explicit_row{i} : Fin 6 → Polynomial ℚ := fun j =>",
                  "  match j.val with"]
        for j in range(6):
            lines.append(f"  | {j} => {s6_explicit_expr(i, j)}")
        lines += ["  | _ => 0", ""]
        for j in range(6):
            lines += [
                f"theorem entry_{i}_{j} :",
                f"    S6_poly ({i} : Fin 6) ({j} : Fin 6) =",
                f"      S6_explicit_row{i} ({j} : Fin 6) := by",
            ]
            if j == 0:
                lines += [f"  rfl", ""]
            else:
                a = (i * j) % 11
                b = (-a) % 11
                lines += [
                    f"  have hj : ({j} : Fin 6).val ≠ 0 := by decide",
                    f"  have ha : ((((({i} : Fin 6).val : ZMod 11) *",
                    f"      (({j} : Fin 6).val : ZMod 11))).val = {a}) := by decide",
                    f"  have hb : ((-(((({i} : Fin 6).val : ZMod 11) *",
                    f"      (({j} : Fin 6).val : ZMod 11)))).val = {b}) := by decide",
                    f"  simp only [S6_poly, Matrix.of_apply, if_neg hj,",
                    "    D12U6Semantic.phasePoly]",
                    "  rw [ha, hb]",
                    f"  rfl",
                    "",
                ]
        lines += [
            f"theorem row_{i} (j : Fin 6) :",
            f"    S6_poly ({i} : Fin 6) j = S6_explicit_row{i} j := by",
            "  fin_cases j",
        ]
        for j in range(6):
            lines.append(f"  · exact entry_{i}_{j}")
        lines.append("")
    lines += [
        "def S6_explicit_poly : Matrix (Fin 6) (Fin 6) (Polynomial ℚ) :=",
        "  Matrix.of fun i =>",
        "    match i.val with",
    ]
    for i in range(6):
        lines.append(f"    | {i} => S6_explicit_row{i}")
    lines += ["    | _ => S6_explicit_row0", "", "theorem S6_poly_eq_explicit :",
              "    S6_poly = S6_explicit_poly := by",
              "  apply Matrix.ext", "  intro i j", "  fin_cases i"]
    for i in range(6):
        lines.append(f"  · exact row_{i} j")
    lines += ["", "end V14Formalization.D12SigmaCarrierS6Explicit", ""]
    out.write_text("\n".join(lines))


def bridge_scalar_finish() -> list[str]:
    return [
        "  ring_nf <;>",
        "  simp only [nat2_as_C, nat3_as_C, nat4_as_C, nat5_as_C,",
        "    nat6_as_C, nat7_as_C, nat8_as_C,",
        "    C_eq_smul_one, smul_one_sq, smul_mul_assoc,",
        "    mul_smul_comm, one_mul, mul_one, smul_smul] <;>",
        "  module",
    ]


def emit_split_bridge_relation(lines: list[str], row: int, j: int,
                               raw, reduced, quotient) -> None:
    """Emit a bounded proof for the rare dense raw/cyclotomic relation.

    The quotient is partitioned into five-degree windows.  Each multiplication
    by Phi11 is checked in its own declaration, so no tactic sees both the
    35-degree raw entry and the full quotient product.
    """
    chunks = []
    for lo in range(0, len(quotient), 5):
        q = [Fraction(0)] * lo + quotient[lo:lo + 5]
        q = trim(q)
        if q:
            chunks.append((q, mul(PHI, q)))
    lines += [f"def raw_{j} : Polynomial ℚ := {lean_poly(raw)}", ""]
    for k, (q, r) in enumerate(chunks):
        lines += [
            f"def quotient_{j}_chunk{k} : Polynomial ℚ := {lean_poly(q)}",
            f"def residual_{j}_chunk{k} : Polynomial ℚ := {lean_poly(r)}",
            "",
            f"theorem residual_{j}_chunk{k}_eq :",
            f"    Phi11 * quotient_{j}_chunk{k} = residual_{j}_chunk{k} := by",
            f"  simp only [Phi11, quotient_{j}_chunk{k}, residual_{j}_chunk{k},",
            "    Finset.sum_range_succ]",
        ] + bridge_scalar_finish() + [""]
    rsum = " + ".join(f"residual_{j}_chunk{k}" for k in range(len(chunks)))
    qsum = " + ".join(f"quotient_{j}_chunk{k}" for k in range(len(chunks)))
    lines += [
        f"theorem raw_{j}_eq :",
        f"    Srestricted_poly ({row} : Fin 10) ({j} : Fin 10) = raw_{j} := by",
        "  unfold Srestricted_poly",
        "  rw [show S6_poly = S6_explicit_poly from S6_poly_eq_explicit]",
        "  simp only [restrictedAction, Matrix.of_apply, Matrix.mul_apply,",
        "    D12GeneratorPolynomialCore.compound2Lex_apply_pairLex,",
        "    S6_explicit_poly, S6_explicit_row0, S6_explicit_row1,",
        "    S6_explicit_row2, S6_explicit_row3, S6_explicit_row4,",
        "    S6_explicit_row5, D12U6Semantic.cFourierPoly,",
        "    D12PolynomialData.B_poly, D12GeneratorPolynomialCore.freeRow,",
        f"    PluckerNaturality.pairLexVec, raw_{j}]",
        "  simp [Fin.sum_univ_succ]",
        "  simp only [S6_explicit_row0, S6_explicit_row1,",
        "    S6_explicit_row2, S6_explicit_row3, S6_explicit_row4,",
        "    S6_explicit_row5, D12U6Semantic.cFourierPoly]",
        "  norm_num",
    ] + bridge_scalar_finish() + [""]
    coeff_defs = (f"raw_{j}, Srestricted_reduced_poly, "
                  f"Srestricted_reduced_poly_row{row}, interpQ, toPolyZ, " +
                  ", ".join(f"residual_{j}_chunk{k}"
                            for k in range(len(chunks))))
    for n in range(36):
        lines += [
            f"theorem raw_{j}_sub_reduced_coeff_{n} :",
            f"    (raw_{j} - Srestricted_reduced_poly ({row} : Fin 10) ({j} : Fin 10)).coeff {n} =",
            f"      ({rsum}).coeff {n} := by",
            f"  norm_num [{coeff_defs}]",
            "",
        ]
    lines += [
        f"private theorem raw_{j}_degree_le : raw_{j}.natDegree ≤ 35 := by",
        f"  unfold raw_{j}",
        "  compute_degree",
        "",
        f"private theorem reduced_{j}_degree_le :",
        f"    (Srestricted_reduced_poly ({row} : Fin 10) ({j} : Fin 10)).natDegree ≤ 35 := by",
        f"  change (Srestricted_reduced_poly_row{row} ({j} : Fin 10)).natDegree ≤ 35",
        f"  simp only [Srestricted_reduced_poly_row{row}]",
        "  exact le_trans (natDegree_interpQ_le _ _) (by decide)",
        "",
        f"private theorem residual_{j}_degree_le : ({rsum}).natDegree ≤ 35 := by",
    ]
    for k in range(len(chunks)):
        lines.append(f"  unfold residual_{j}_chunk{k}")
    lines += [
        "  compute_degree",
        "",
        f"theorem raw_{j}_sub_reduced :",
        f"    raw_{j} - Srestricted_reduced_poly ({row} : Fin 10) ({j} : Fin 10) =",
        f"      {rsum} := by",
        "  apply (Polynomial.ext_iff_natDegree_le",
        f"    ((Polynomial.natDegree_sub_le _ _).trans (max_le raw_{j}_degree_le reduced_{j}_degree_le))",
        f"    residual_{j}_degree_le).2",
        "  intro i hi",
        "  interval_cases i",
    ]
    for n in range(36):
        lines.append(f"  · exact raw_{j}_sub_reduced_coeff_{n}")
    lines += [
        "",
        f"def quotient_{j} : Polynomial ℚ := {qsum}",
        "",
        f"theorem relation_{j} :",
        f"    Srestricted_poly ({row} : Fin 10) ({j} : Fin 10) -",
        f"        Srestricted_reduced_poly ({row} : Fin 10) ({j} : Fin 10) =",
        f"      Phi11 * quotient_{j} := by",
        f"  rw [raw_{j}_eq, raw_{j}_sub_reduced]",
    ]
    for k in range(len(chunks)):
        lines.append(f"  rw [← residual_{j}_chunk{k}_eq]")
    lines += [
        f"  simp only [quotient_{j}]",
        "  ring",
        "",
    ]


def emit_bridge_row(row: int, raw_entries, reduced_entries, qs, out: Path):
    ns = f"V14Formalization.D12SigmaCarrierBridgeRow{row}"
    free_pairs = [
        (0, 1), (0, 2), (0, 3), (0, 4), (0, 5),
        (1, 3), (1, 4), (2, 3), (2, 5), (4, 5),
    ]
    pair_a, pair_b = free_pairs[row]
    lines = header() + [
        "import V14Formalization.D12SigmaCarrierS6Explicit",
        "",
        "noncomputable section",
        "open Matrix Polynomial",
        f"namespace {ns}",
        "open D12PolynomialData D12PolynomialEvaluation",
        "open D12GeneratorPolynomialCore D12SigmaCarrierPolynomial",
        "open D12SigmaCarrierS6Explicit",
        "open V14Formalization.D12PolyZReflection",
        "",
    ] + module_scalar_helpers()
    for j in range(10):
        if (row, j) in {(5, 3), (6, 0), (7, 4), (8, 1), (9, 2)}:
            emit_split_bridge_relation(lines, row, j, raw_entries[row][j],
                                       reduced_entries[row][j], qs[row][j])
            lines += [
                f"theorem eval_relation_{j} :",
                f"    evalMatrixK Srestricted_poly ({row} : Fin 10) ({j} : Fin 10) =",
                f"      evalMatrixK Srestricted_reduced_poly ({row} : Fin 10) ({j} : Fin 10) := by",
                f"  exact eval_eq_of_modPhi WeilRep.ζ D12U6PolynomialSeal.evalPhi11_ζ _ _ _ relation_{j}",
                "",
            ]
            continue
        qn = f"quotient_{j}"
        lines += [f"def {qn} : Polynomial ℚ := {lean_poly(qs[row][j])}", ""]
        lines += [
            f"theorem relation_{j} :",
            f"    Srestricted_poly ({row} : Fin 10) ({j} : Fin 10) -",
            f"        Srestricted_reduced_poly ({row} : Fin 10) ({j} : Fin 10) =",
            f"      Phi11 * {qn} := by",
            "  unfold Srestricted_poly",
            "  rw [show S6_poly = S6_explicit_poly from S6_poly_eq_explicit]",
            "  simp only [restrictedAction, Matrix.of_apply,",
            "    Matrix.mul_apply, Matrix.sub_apply, Srestricted_reduced_poly,",
            f"    Srestricted_reduced_poly_row{row},",
            "    D12GeneratorPolynomialCore.compound2Lex_apply_pairLex,",
            "    S6_explicit_poly, S6_explicit_row0, S6_explicit_row1,",
            "    S6_explicit_row2, S6_explicit_row3, S6_explicit_row4,",
            "    S6_explicit_row5, D12U6Semantic.cFourierPoly,",
            "    D12PolynomialData.B_poly, D12GeneratorPolynomialCore.freeRow,",
            f"    PluckerNaturality.pairLexVec, {qn}]",
            "  simp [Fin.sum_univ_succ]",
            "  simp only [S6_explicit_row0, S6_explicit_row1,",
            "    S6_explicit_row2, S6_explicit_row3, S6_explicit_row4,",
            "    S6_explicit_row5, D12U6Semantic.cFourierPoly,",
            f"    Srestricted_reduced_poly_row{row},",
            "    interpQ, toPolyZ]",
            "  norm_num",
            "  simp only [Phi11, Finset.sum_range_succ]",
            "  ring_nf",
            "  simp only [nat2_as_C, nat3_as_C, nat4_as_C, nat5_as_C,",
            "    nat6_as_C, nat7_as_C, nat8_as_C,",
            "    C_eq_smul_one, smul_one_sq, smul_mul_assoc,",
            "    mul_smul_comm, one_mul, mul_one, smul_smul]",
            "  module",
        ] + [
            "",
            f"theorem eval_relation_{j} :",
            f"    evalMatrixK Srestricted_poly ({row} : Fin 10) ({j} : Fin 10) =",
            f"      evalMatrixK Srestricted_reduced_poly ({row} : Fin 10) ({j} : Fin 10) := by",
            f"  exact eval_eq_of_modPhi WeilRep.ζ D12U6PolynomialSeal.evalPhi11_ζ _ _ _ relation_{j}",
            "",
        ]
    lines += [
        f"theorem eval_row (j : Fin 10) :",
        f"    evalMatrixK Srestricted_poly ({row} : Fin 10) j =",
        f"      evalMatrixK Srestricted_reduced_poly ({row} : Fin 10) j := by",
        "  fin_cases j",
    ]
    for j in range(10):
        lines.append(f"  · exact eval_relation_{j}")
    lines += ["", "end " + ns, ""]
    out.write_text("\n".join(lines))


def emit_shard(sign: str, col: int, kp, km, qs, out: Path):
    plus = sign == "plus"
    kname = "Kplus_poly" if plus else "Kminus_poly"
    cols = 6 if plus else 4
    relation_op = "-" if plus else "+"
    ns = f"V14Formalization.D12SigmaCarrier{sign.capitalize()}Col{col}"
    lines = header() + [
        "import V14Formalization.D12SigmaCarrierPolynomialCore",
        "",
        "noncomputable section",
        "open Matrix Polynomial",
        f"namespace {ns}",
        "open D12PolynomialData D12PolynomialEvaluation",
        "open D12GeneratorPolynomialCore D12SigmaCarrierPolynomial",
        "open V14Formalization.D12PolyZReflection",
        "",
    ]
    for i in range(10):
        qn = f"quotient_{i}"
        lines += [f"def {qn} : Polynomial ℚ := {lean_interp(qs[i][col])}", ""]
        lines += [
            f"theorem relation_{i} :",
            f"    (Srestricted_reduced_poly * {kname}) ({i} : Fin 10) ({col} : Fin {cols}) {relation_op}",
            f"        {kname} ({i} : Fin 10) ({col} : Fin {cols}) = Phi11 * {qn} := by",
            "  rw [z_Phi11]",
            "  simp only [Matrix.mul_apply, Matrix.sub_apply, Matrix.add_apply,",
            f"    Srestricted_reduced_poly, {kname}, {qn}]",
            f"  simp [Fin.sum_univ_succ, Srestricted_reduced_poly_row{i},",
            "    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2,",
            "    Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5,",
            "    Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8,",
            "    Kplus_poly_row9, Kminus_poly_row0, Kminus_poly_row1,",
            "    Kminus_poly_row2, Kminus_poly_row3, Kminus_poly_row4,",
            "    Kminus_poly_row5, Kminus_poly_row6, Kminus_poly_row7,",
            "    Kminus_poly_row8, Kminus_poly_row9]",
            "  simp (disch := decide) only [interp_mul, interp_add_gen,",
            "    interp_sub_gen, Nat.reduceMul]",
            "  apply interp_eq",
            "  · decide",
            "  · decide",
            "  · decide",
        ] + [
            "",
            f"theorem eval_relation_{i}",
            "    {R : Type*} [CommRing R] [Algebra ℚ R] (z : R)",
            "    (hPhi : evalPolyAt z Phi11 = 0) :",
            f"    (evalMatrixAt z Srestricted_reduced_poly * evalMatrixAt z {kname})",
            f"        ({i} : Fin 10) ({col} : Fin {cols}) =",
            (f"      evalMatrixAt z {kname} ({i} : Fin 10) ({col} : Fin {cols}) := by" if plus
             else f"      -evalMatrixAt z {kname} ({i} : Fin 10) ({col} : Fin {cols}) := by"),
            "  rw [← evalMatrixAt_mul]",
        ]
        if plus:
            lines += [
                "  exact eval_eq_of_modPhi z hPhi _ _ _ relation_" + str(i),
            ]
        else:
            lines += [
                "  have h := congrArg (evalPolyAt z) relation_" + str(i),
                "  simp only [map_add, map_mul, hPhi, zero_mul] at h",
                "  simpa [evalMatrixAt] using (add_eq_zero_iff_eq_neg.mp h)",
            ]
        lines.append("")
    lines += [
        f"theorem eval_column",
        "    {R : Type*} [CommRing R] [Algebra ℚ R] (z : R)",
        "    (hPhi : evalPolyAt z Phi11 = 0) (i : Fin 10) :",
        f"    (evalMatrixAt z Srestricted_reduced_poly * evalMatrixAt z {kname})",
        f"        i ({col} : Fin {cols}) =",
        (f"      evalMatrixAt z {kname} i ({col} : Fin {cols}) := by" if plus
         else f"      -evalMatrixAt z {kname} i ({col} : Fin {cols}) := by"),
        "  fin_cases i",
    ]
    for i in range(10):
        lines.append(f"  · exact eval_relation_{i} z hPhi")
    lines += ["", "end " + ns, ""]
    out.write_text("\n".join(lines))


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--core", action="store_true")
    parser.add_argument("--s6-explicit", action="store_true")
    parser.add_argument("--sign", choices=["plus", "minus"])
    parser.add_argument("--bridge-row", type=int)
    parser.add_argument("--column", type=int)
    parser.add_argument("--out", type=Path)
    args = parser.parse_args()
    kp, km, sr, sr_reduced, qsr, qp, qm = load_data()
    if args.core:
        target = args.out or OUT / "D12SigmaCarrierPolynomialCore.lean"
        emit_core(kp, km, sr_reduced, target)
        return
    if args.s6_explicit:
        target = args.out or OUT / "D12SigmaCarrierS6Explicit.lean"
        emit_s6_explicit(target)
        return
    if args.bridge_row is not None:
        if not 0 <= args.bridge_row < 10:
            parser.error("bridge row out of range")
        target = args.out or OUT / (
            f"D12SigmaCarrierBridgeRow{args.bridge_row}.lean")
        emit_bridge_row(args.bridge_row, sr, sr_reduced, qsr, target)
        return
    if args.sign is None or args.column is None:
        parser.error("provide --core or --sign and --column")
    cols = 6 if args.sign == "plus" else 4
    if not 0 <= args.column < cols:
        parser.error("column out of range")
    target = args.out or OUT / (
        f"D12SigmaCarrier{args.sign.capitalize()}Col{args.column}.lean")
    emit_shard(args.sign, args.column, kp, km, qp if args.sign == "plus" else qm,
               target)


if __name__ == "__main__":
    main()
    __import__("sys").path.insert(0, __import__("os").path.dirname(__import__("os").path.abspath(__file__)))
    from module_annotation_hook import reapply_module_annotations
    reapply_module_annotations()
