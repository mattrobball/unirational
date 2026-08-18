#!/usr/bin/env python3
"""Export the bounded restriction certificates for the compound rotation.

The 15x15 ambient generator is *not* tabulated anywhere: it is the order-two
compound `compound2Lex R6_poly` of the sealed 6x6 Weil generator.  What the
generated modules certify is the only thing the downstream `ActionCore` needs,

    compound2(R6) * B - B * RM = Phi11 * q      (entrywise, 15 x 10)

which after evaluation at the primitive root gives `rho(g) * B = B * RM`.

Two consequences of doing it this way, both deliberate:

  * `compound2(R6)` and the old reduced 15x15 table are *not* the same
    polynomial matrix — they agree only modulo `Phi11`, and every one of the
    225 quotients is nonzero.  Certifying `compound2(R6) * B` directly removes
    the reduced table and the reconciliation layer together.
  * `B` has ten columns, so only 150 entries per generator need a certificate
    instead of 225.

Every coordinate is a separate theorem so Lean's stock heartbeat budget resets
between finite calculations.  All halves coming from the sparse `B` are
confined to the shared `D12CompoundBridge` module: the per-entry certificates
see integer scalars only, because everything is stated for twice the
difference and undone once by `D12CompoundBridge.of_two`.

An optional output-directory argument supports byte-for-byte reproducibility
audits without touching the working tree.
"""
from __future__ import annotations

import hashlib
import json
import sys
from fractions import Fraction
from pathlib import Path
from typing import Dict, Iterable, List, Sequence, Tuple

ROOT = Path(__file__).resolve().parents[1]
JSON_PATH = ROOT / "results" / "d12_lean_K.json"
DEFAULT_OUTPUT_DIR = ROOT / "V14Formalization"
SCHEMA = "v14.d12.compound.restriction.v2"

PAIRS = [
    (0, 1), (0, 2), (0, 3), (0, 4), (0, 5),
    (1, 2), (1, 3), (1, 4), (1, 5),
    (2, 3), (2, 4), (2, 5),
    (3, 4), (3, 5),
    (4, 5),
]

# Support of each column of the sparse 15x10 `B_poly`, in ambient-row order.
B_COL: Dict[int, List[Tuple[int, Fraction]]] = {
    0: [(0, Fraction(1)), (13, Fraction(-1, 2))],
    1: [(1, Fraction(1)), (8, Fraction(1, 2))],
    2: [(2, Fraction(1)), (10, Fraction(-1, 2))],
    3: [(3, Fraction(1)), (5, Fraction(-1, 2))],
    4: [(4, Fraction(1)), (12, Fraction(1, 2))],
    5: [(6, Fraction(1))],
    6: [(7, Fraction(1))],
    7: [(9, Fraction(1))],
    8: [(11, Fraction(1))],
    9: [(14, Fraction(1))],
}

# Support of each row of `B_poly`: ambient row -> (restricted row, coefficient).
B_ROW = {
    0: (0, Fraction(1)), 1: (1, Fraction(1)), 2: (2, Fraction(1)),
    3: (3, Fraction(1)), 4: (4, Fraction(1)), 5: (3, Fraction(-1, 2)),
    6: (5, Fraction(1)), 7: (6, Fraction(1)), 8: (1, Fraction(1, 2)),
    9: (7, Fraction(1)), 10: (2, Fraction(-1, 2)), 11: (8, Fraction(1)),
    12: (4, Fraction(1, 2)), 13: (0, Fraction(-1, 2)), 14: (9, Fraction(1)),
}

# Normalisation lemmas published by the bridge module.  The 6x6 generator
# tables are over 11 and the restricted generators are over 11 and 22, so the
# single atom every certificate is normalised to is `C (1/22)`.
C_OVER_11 = list(range(1, 9))
C_OVER_22 = [3, 5, 7, 9, 11, 13, 15]

Poly = List[Fraction]


def trim(p: Iterable[Fraction]) -> Poly:
    out = list(p)
    while out and out[-1] == 0:
        out.pop()
    return out


def add(a: Sequence[Fraction], b: Sequence[Fraction]) -> Poly:
    return trim(
        (a[i] if i < len(a) else 0) + (b[i] if i < len(b) else 0)
        for i in range(max(len(a), len(b)))
    )


def sub(a: Sequence[Fraction], b: Sequence[Fraction]) -> Poly:
    return add(a, [-x for x in b])


def scale(a: Sequence[Fraction], s: Fraction) -> Poly:
    return trim(s * x for x in a)


def mul(a: Sequence[Fraction], b: Sequence[Fraction]) -> Poly:
    if not a or not b:
        return []
    out = [Fraction(0)] * (len(a) + len(b) - 1)
    for i, x in enumerate(a):
        for j, y in enumerate(b):
            out[i + j] += x * y
    return trim(out)


def divide_exact(a: Sequence[Fraction], b: Sequence[Fraction]) -> Poly:
    remainder = trim(a)
    quotient = [Fraction(0)] * max(0, len(remainder) - len(b) + 1)
    while len(remainder) >= len(b):
        k = len(remainder) - len(b)
        coefficient = remainder[-1] / b[-1]
        quotient[k] += coefficient
        remainder = sub(
            remainder,
            [Fraction(0)] * k + [coefficient * x for x in b],
        )
    if remainder:
        raise ValueError(f"nonzero Phi11 remainder: {remainder}")
    return trim(quotient)


def decode(entry: Sequence[Sequence[int]]) -> Poly:
    return trim(Fraction(n, d) for n, d in entry)


def integral(values: Sequence[Fraction], factor: int, what: str) -> List[int]:
    out = []
    for x in values:
        y = x * factor
        if y.denominator != 1:
            raise ValueError(f"{what}: {x} is not integral after x{factor}")
        out.append(y.numerator)
    return out


def int_vector(values: Sequence[int], size: int) -> str:
    padded = list(values) + [0] * (size - len(values))
    return "![" + ", ".join(str(x) for x in padded[:size]) + "]"


def polynomial_expression(coefficients: Sequence[int]) -> str:
    terms = []
    for degree, coefficient in enumerate(coefficients):
        if coefficient == 0:
            continue
        xpart = "1" if degree == 0 else ("X" if degree == 1 else f"X ^ {degree}")
        magnitude = abs(coefficient)
        term = xpart if magnitude == 1 else f"{magnitude} * {xpart}"
        terms.append(("-" if coefficient < 0 else "+", term))
    if not terms:
        return "0"
    sign, term = terms[0]
    result = f"-({term})" if sign == "-" else term
    for sign, term in terms[1:]:
        result += f" {sign} {term}"
    return result


HEADER = """/-
  {title}
  Auto-generated by scripts/export_d12_compound_lean.py.
  DO NOT HAND-EDIT.
  Schema: {schema}
  Source JSON sha256: {source_sha}
{extra}-/
module
"""


# --------------------------------------------------------------------------
# The shared bridge module.
# --------------------------------------------------------------------------

def emit_bridge(output_dir: Path, source_sha: str) -> Path:
    lines: List[str] = []
    append = lines.append
    append(HEADER.format(
        title="Shared algebra for the D12 compound restriction certificates.",
        schema=SCHEMA, source_sha=source_sha, extra="").rstrip("\n"))
    append("")
    append("public import V14Formalization.D12PolynomialCore")
    append("public import Mathlib.Tactic.LinearCombination")
    append("")
    append("/-!")
    append("# Bridge lemmas for the compound restriction certificates")
    append("")
    append("`B_poly` is sparse with half-integer entries.  Every generated")
    append("certificate is therefore stated for *twice* a difference, so that")
    append("only integer scalars survive into its arithmetic; `of_two` undoes")
    append("the doubling once, and the two families of collapse lemmas below")
    append("do the sparse bookkeeping once per column and once per row instead")
    append("of once per certificate.")
    append("-/")
    append("")
    append("noncomputable section")
    append("")
    append("open Matrix Polynomial")
    append("")
    append("namespace V14Formalization.D12CompoundBridge")
    append("")
    append("open D12PolynomialData")
    append("")
    append("theorem C_half_two : (2 : Polynomial ℚ) * C (1 / 2 : ℚ) = 1 := by")
    append("  rw [show (2 : Polynomial ℚ) = C 2 by exact (map_natCast C 2).symm, ← map_mul]")
    append("  norm_num")
    append("")
    append("theorem C_neg_half_two : (2 : Polynomial ℚ) * C (-1 / 2 : ℚ) = -1 := by")
    append("  rw [show (2 : Polynomial ℚ) = C 2 by exact (map_natCast C 2).symm, ← map_mul]")
    append("  norm_num")
    append("")
    append("/-- Undo the doubling that keeps the certificates integral. -/")
    append("public theorem of_two {D q : Polynomial ℚ}")
    append("    (h : (2 : Polynomial ℚ) * D = Phi11 * q) :")
    append("    ∃ q' : Polynomial ℚ, D = Phi11 * q' := by")
    append("  refine ⟨C (1 / 2 : ℚ) * q, ?_⟩")
    append("  calc D = (2 : Polynomial ℚ) * C (1 / 2 : ℚ) * D := by")
    append("        rw [C_half_two, one_mul]")
    append("    _ = C (1 / 2 : ℚ) * ((2 : Polynomial ℚ) * D) := by ring")
    append("    _ = C (1 / 2 : ℚ) * (Phi11 * q) := by rw [h]")
    append("    _ = Phi11 * (C (1 / 2 : ℚ) * q) := by ring")
    append("")
    append("/-! ### Every constant in terms of the single atom `C (1/22)` -/")
    append("")
    for n in C_OVER_11:
        append(f"public theorem C_{n}_over_11 :")
        append(f"    C ({n} / 11 : ℚ) = ({2 * n} : Polynomial ℚ) * C (1 / 22 : ℚ) := by")
        append(f"  rw [show ({2 * n} : Polynomial ℚ) = C {2 * n} by "
               f"exact (map_natCast C {2 * n}).symm, ← map_mul]")
        append("  norm_num")
        append("")
    for n in C_OVER_22:
        append(f"public theorem C_{n}_over_22 :")
        append(f"    C ({n} / 22 : ℚ) = ({n} : Polynomial ℚ) * C (1 / 22 : ℚ) := by")
        append(f"  rw [show ({n} : Polynomial ℚ) = C {n} by "
               f"exact (map_natCast C {n}).symm, ← map_mul]")
        append("  norm_num")
        append("")
    append("public theorem C_one_over_22_sq :")
    append("    C (1 / 22 : ℚ) =")
    append("      (22 : Polynomial ℚ) *")
    append("        (C (1 / 22 : ℚ) * C (1 / 22 : ℚ)) := by")
    append("  rw [show (22 : Polynomial ℚ) = C 22 by exact (map_natCast C 22).symm,")
    append("    ← map_mul, ← map_mul]")
    append("  congr 1")
    append("  norm_num")
    append("")
    append("/-! ### Twice a column of `M * B_poly`, with `B` collapsed once -/")
    append("")
    for j in range(10):
        support = B_COL[j]
        rhs_terms: List[str] = []
        raw_terms: List[str] = []
        for pos, (k, c) in enumerate(support):
            body = f"M i ({k} : Fin 15)"
            doubled = 2 * c
            assert doubled.denominator == 1
            n = doubled.numerator
            if pos == 0:
                assert c == 1
                rhs_terms.append(f"({n} : Polynomial ℚ) * {body}" if n != 1 else body)
                raw_terms.append(body)
            else:
                rhs_terms.append(("- " if n < 0 else "+ ") + (
                    body if abs(n) == 1 else f"({abs(n)} : Polynomial ℚ) * {body}"))
                raw_terms.append(f"+ {body} * C ({c} : ℚ)")
        rhs = " ".join(rhs_terms)
        append(f"public theorem two_mul_B_col{j}")
        append("    (M : Matrix (Fin 15) (Fin 15) PolyQ) (i : Fin 15) :")
        append(f"    (2 : Polynomial ℚ) * (M * B_poly) i ({j} : Fin 10) =")
        append(f"      {rhs} := by")
        append(f"  have hB : (M * B_poly) i ({j} : Fin 10) =")
        append(f"      {' '.join(raw_terms)} := by")
        append("    simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Matrix.of_apply]")
        append("    all_goals ring")
        append("  rw [hB]")
        if len(support) > 1:
            k2, c2 = support[1]
            relation = "C_half_two" if c2 > 0 else "C_neg_half_two"
            append(f"  linear_combination (M i ({k2} : Fin 15)) * {relation}")
        append("")
    append("/-! ### Twice a row of `B_poly * N`, with `B` collapsed once -/")
    append("")
    for i in range(15):
        r, coef = B_ROW[i]
        doubled = 2 * coef
        assert doubled.denominator == 1
        n = doubled.numerator
        body = f"N ({r} : Fin 10) j"
        if n == 1:
            rhs = body
        elif n == -1:
            rhs = f"-{body}"
        else:
            rhs = f"({n} : Polynomial ℚ) * {body}"
        raw = (f"N ({r} : Fin 10) j" if coef == 1
               else f"C ({coef} : ℚ) * N ({r} : Fin 10) j")
        append(f"public theorem two_B_mul_row{i}")
        append("    (N : Matrix (Fin 10) (Fin 10) PolyQ) (j : Fin 10) :")
        append(f"    (2 : Polynomial ℚ) * (B_poly * N) ({i} : Fin 15) j =")
        append(f"      {rhs} := by")
        append(f"  have hB : (B_poly * N) ({i} : Fin 15) j = {raw} := by")
        append("    simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Matrix.of_apply]")
        append("    all_goals ring")
        append("  rw [hB]")
        if coef != 1:
            relation = "C_half_two" if coef > 0 else "C_neg_half_two"
            append(f"  linear_combination (N ({r} : Fin 10) j) * {relation}")
        append("")
    append("end V14Formalization.D12CompoundBridge")
    output = output_dir / "D12CompoundBridge.lean"
    output.write_text("\n".join(lines) + "\n", encoding="utf-8")
    return output


# --------------------------------------------------------------------------
# One certificate module per ambient row.
# --------------------------------------------------------------------------

def minor_expression(entry: str, row: int, col: int) -> str:
    a, b = PAIRS[row]
    c, d = PAIRS[col]
    return (f"{entry}_{a}_{c} * {entry}_{b}_{d} - "
            f"{entry}_{a}_{d} * {entry}_{b}_{c}")


def minor_names(row: int, col: int, entry: str) -> List[str]:
    a, b = PAIRS[row]
    c, d = PAIRS[col]
    return [f"{entry}_{a}_{c}", f"{entry}_{b}_{d}",
            f"{entry}_{a}_{d}", f"{entry}_{b}_{c}"]


def minor_poly(m6, row: int, col: int) -> Poly:
    a, b = PAIRS[row]
    c, d = PAIRS[col]
    return sub(mul(m6[a][c], m6[b][d]), mul(m6[a][d], m6[b][c]))


def emit_row(output_dir: Path, source_sha: str, payload_sha: str,
             m6, restricted, row: int, mode: str) -> Path:
    if mode not in {"R", "F"}:
        raise ValueError(f"unsupported compound mode: {mode}")
    word = "rotation" if mode == "R" else "reflection"
    small_namespace = "D12U6PolynomialData" if mode == "R" else "D12F6PolynomialData"
    small_poly = "R6_poly" if mode == "R" else "F6_poly"
    small_entry = "R6c" if mode == "R" else "F6c"
    small_import = "D12U6PolynomialSeal" if mode == "R" else "D12F6PolynomialSeal"
    big = "RM" if mode == "R" else "SM"
    big_import = "D12PolynomialRM" if mode == "R" else "D12PolynomialSM"
    module_prefix = f"D12Compound{mode}Row"

    phi11 = [Fraction(1)] * 11
    r, coef = B_ROW[row]
    n3 = 2 * coef
    assert n3.denominator == 1
    n3 = n3.numerator

    certificates = []
    for column in range(10):
        support = B_COL[column]
        lhs: Poly = []
        for k, c in support:
            lhs = add(lhs, scale(minor_poly(m6, row, k), 2 * c))
        target = restricted[r][column]
        lhs = sub(lhs, scale(target, Fraction(n3)))
        quotient = divide_exact(lhs, phi11)
        quotient_numerators = integral(
            quotient, 484, f"({row},{column}) quotient")
        # `-n3 * of10 target` is the only `C (1/22)`-linear part of the goal.
        linear_numerators = integral(
            scale(target, Fraction(-22 * n3)), 1, f"({row},{column}) target")
        certificates.append((column, support, quotient_numerators,
                             linear_numerators))

    quotient_size = max(1, max(len(c[2]) for c in certificates))
    used_minors = sorted({k for column in range(10)
                          for k, _ in B_COL[column]})

    lines: List[str] = []
    append = lines.append
    append(HEADER.format(
        title=(f"D12 restriction certificate for the compound {word}, "
               f"ambient row {row}."),
        schema=SCHEMA, source_sha=source_sha,
        extra=f"  {mode}6 payload sha256: {payload_sha}\n").rstrip("\n"))
    append("")
    append(f"public import V14Formalization.{small_import}")
    append(f"public import V14Formalization.{big_import}")
    append("public import V14Formalization.D12CompoundBridge")
    append("public import V14Formalization.PluckerNaturality")
    append("public import Mathlib.Tactic.FinCases")
    append("")
    append("set_option linter.unusedSimpArgs false")
    append("")
    append("noncomputable section")
    append("")
    append("open Matrix Polynomial")
    append("")
    append(f"namespace V14Formalization.{module_prefix}{row}")
    append("")
    append(f"open D12PolynomialData {small_namespace} D12CompoundBridge")
    append("")
    append(f"@[expose] public abbrev QuotCoeff := Fin {quotient_size} → ℤ")
    append("")
    append("def ofQuotNumerator (v : QuotCoeff) : Polynomial ℚ :=")
    append(f"  ∑ i : Fin {quotient_size}, (v i : Polynomial ℚ) *")
    append("    (C (1 / 22 : ℚ) * C (1 / 22 : ℚ)) * X ^ i.val")
    append("")
    append("/-! ### The ambient row's two-by-two minors of the sealed 6x6 -/")
    append("")
    for k in used_minors:
        append(f"private theorem minor_{k} :")
        append(f"    (PluckerNaturality.compound2Lex {small_poly}) "
               f"({row} : Fin 15) ({k} : Fin 15) =")
        append(f"      {minor_expression(small_entry, row, k)} := by")
        append("  simp only [PluckerNaturality.compound2Lex, Matrix.of_apply,")
        append("    PluckerNaturality.pairEmb_eq_pairLexEmb,")
        append("    PluckerNaturality.pairLexEmb, PluckerNaturality.pairLexVec,")
        append(f"    Matrix.det_fin_two, {small_poly}]")
        append("  rfl")
        append("")
    append("/-! ### One bounded certificate per restricted column -/")
    append("")
    c_lemmas = ", ".join([f"C_{n}_over_11" for n in C_OVER_11]
                         + [f"C_{n}_over_22" for n in C_OVER_22])
    for column, support, quotient_numerators, linear_numerators in certificates:
        target_vec = f"{big}{r}c{column}"
        terms: List[str] = []
        for pos, (k, c) in enumerate(support):
            n = (2 * c).numerator
            body = f"({minor_expression(small_entry, row, k)})"
            if pos == 0:
                terms.append(f"({n} : Polynomial ℚ) * {body}")
            else:
                terms.append(("- " if n < 0 else "+ ") + (
                    body if abs(n) == 1
                    else f"({abs(n)} : Polynomial ℚ) * {body}"))
        if n3 == 1:
            terms.append(f"- of10 {target_vec}")
        elif n3 == -1:
            terms.append(f"+ of10 {target_vec}")
        else:
            terms.append(f"- ({n3} : Polynomial ℚ) * of10 {target_vec}")
        statement = "\n      ".join(terms)
        unfold = sorted({name for k, _ in support
                         for name in minor_names(row, k, small_entry)})
        append(f"def quotient_{column} : Polynomial ℚ :=")
        append(f"  ofQuotNumerator {int_vector(quotient_numerators, quotient_size)}")
        append(f"private theorem cert_{column} :")
        append(f"    {statement} =")
        append(f"      Phi11 * quotient_{column} := by")
        append(f"  norm_num [quotient_{column}, ofQuotNumerator,")
        append("    " + ", ".join(unfold) + ",")
        append(f"    {target_vec}, of10, Phi11,")
        append("    Fin.sum_univ_succ, Finset.sum_range_succ]")
        append(f"  simp only [{c_lemmas}]")
        append("  norm_num")
        append(f"  linear_combination ({polynomial_expression(linear_numerators)})"
               " * C_one_over_22_sq")
        append("")
        append(f"private theorem col_{column} :")
        append("    (2 : Polynomial ℚ) *")
        append(f"        (((PluckerNaturality.compound2Lex {small_poly}) * B_poly)"
               f" ({row} : Fin 15) ({column} : Fin 10) -")
        append(f"          (B_poly * {big}_poly) ({row} : Fin 15) "
               f"({column} : Fin 10)) =")
        append(f"      Phi11 * quotient_{column} := by")
        append(f"  rw [mul_sub, two_mul_B_col{column}, two_B_mul_row{row},")
        append(f"    {big}_poly_row{r}, {big}row{r}_{column}, "
               + ", ".join(f"minor_{k}" for k, _ in support) + "]")
        append(f"  linear_combination cert_{column}")
        append("")
    append("/-- The compound generator restricts along `B` modulo `Phi11`. -/")
    append("public theorem row_cert (j : Fin 10) :")
    append("    ∃ q : Polynomial ℚ,")
    append(f"      ((PluckerNaturality.compound2Lex {small_poly}) * B_poly)"
           f" ({row} : Fin 15) j -")
    append(f"          (B_poly * {big}_poly) ({row} : Fin 15) j = Phi11 * q := by")
    append("  fin_cases j")
    for column in range(10):
        append(f"  · exact of_two col_{column}")
    append("")
    append(f"end V14Formalization.{module_prefix}{row}")
    output = output_dir / f"{module_prefix}{row}.lean"
    output.write_text("\n".join(lines) + "\n", encoding="utf-8")
    return output


def main() -> None:
    output_dir = Path(sys.argv[1]) if len(sys.argv) > 1 else DEFAULT_OUTPUT_DIR
    modes = [m.upper() for m in sys.argv[2:]] or ["R", "F"]
    if any(m not in {"R", "F"} for m in modes):
        raise SystemExit("usage: export_d12_compound_lean.py [OUTPUT_DIR] [R] [F]")
    output_dir.mkdir(parents=True, exist_ok=True)
    raw_json = JSON_PATH.read_bytes()
    data = json.loads(raw_json)
    source_sha = hashlib.sha256(raw_json).hexdigest()

    print(f"Wrote {emit_bridge(output_dir, source_sha)}")

    for mode in modes:
        key6 = f"{mode}6x6"
        key_restricted = "RM10x10" if mode == "R" else "SM10x10"
        m6 = [[decode(entry) for entry in row] for row in data["operators"][key6]]
        restricted = [[decode(entry) for entry in row]
                      for row in data["m"][key_restricted]]
        if len(m6) != 6 or any(len(row) != 6 for row in m6):
            raise ValueError(f"operators.{key6} is not 6 by 6")
        if len(restricted) != 10 or any(len(row) != 10 for row in restricted):
            raise ValueError(f"m.{key_restricted} is not 10 by 10")
        payload_bytes = json.dumps(
            {key6: data["operators"][key6],
             key_restricted: data["m"][key_restricted]},
            separators=(",", ":"), sort_keys=True,
        ).encode()
        payload_sha = hashlib.sha256(payload_bytes).hexdigest()
        for row in range(15):
            output = emit_row(output_dir, source_sha, payload_sha,
                              m6, restricted, row, mode)
            print(f"Wrote {output} ({output.stat().st_size} bytes)")
        print(f"{mode}6_{key_restricted}_PAYLOAD_SHA256={payload_sha}")
    print(f"SCHEMA={SCHEMA}")
    print(f"SOURCE_SHA256={source_sha}")


if __name__ == "__main__":
    main()
    __import__("sys").path.insert(
        0, __import__("os").path.dirname(__import__("os").path.abspath(__file__)))
    from module_annotation_hook import reapply_module_annotations
    reapply_module_annotations()
