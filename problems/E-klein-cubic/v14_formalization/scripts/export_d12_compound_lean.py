#!/usr/bin/env python3
"""Export bounded certificates that R15 is the second compound of R6.

For each of the 225 entries this script checks, over Q[X],

  compound2(R6)[i,j] - R15[i,j] = Phi11 * q[i,j].

The Lean output is split into one module per 15-entry row.  Every coordinate
is a separate theorem so Lean's stock heartbeat budget resets between finite
calculations.  An optional output-directory argument supports byte-for-byte
reproducibility audits without touching the working tree.
"""
from __future__ import annotations

import hashlib
import json
import sys
from fractions import Fraction
from pathlib import Path
from typing import Iterable, List, Sequence

ROOT = Path(__file__).resolve().parents[1]
JSON_PATH = ROOT / "results" / "d12_lean_K.json"
DEFAULT_OUTPUT_DIR = ROOT / "V14Formalization"
SCHEMA = "v14.d12.compound.polynomial.v1"
PAIRS = [
    (0, 1), (0, 2), (0, 3), (0, 4), (0, 5),
    (1, 2), (1, 3), (1, 4), (1, 5),
    (2, 3), (2, 4), (2, 5),
    (3, 4), (3, 5),
    (4, 5),
]

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


def row_certificates(m6, m15, row: int):
    phi11 = [Fraction(1)] * 11
    result = []
    for column in range(15):
        a, b = PAIRS[row]
        c, d = PAIRS[column]
        compound = sub(
            mul(m6[a][c], m6[b][d]),
            mul(m6[a][d], m6[b][c]),
        )
        quotient = divide_exact(sub(compound, m15[row][column]), phi11)
        quotient_numerators = []
        for coefficient in quotient:
            scaled = coefficient * 121
            if scaled.denominator != 1:
                raise ValueError(
                    f"entry ({row},{column}) quotient coefficient {coefficient} "
                    "is not integral after multiplying by 121"
                )
            quotient_numerators.append(scaled.numerator)
        target_numerators = []
        for coefficient in m15[row][column]:
            scaled = coefficient * 11
            if scaled.denominator != 1:
                raise ValueError(
                    f"entry ({row},{column}) target coefficient {coefficient} "
                    "is not integral after multiplying by 11"
                )
            target_numerators.append(scaled.numerator)
        result.append((column, a, b, c, d, quotient_numerators, target_numerators))
    return result


def emit_row(output_dir: Path, source_sha: str, payload_sha: str,
             m6, m15, row: int, mode: str = "R") -> Path:
    certificates = row_certificates(m6, m15, row)
    if mode not in {"R", "F"}:
        raise ValueError(f"unsupported compound mode: {mode}")
    word = "rotation" if mode == "R" else "reflection"
    small_namespace = "D12U6PolynomialData" if mode == "R" else "D12F6PolynomialData"
    small_poly = "R6_poly" if mode == "R" else "F6_poly"
    small_entry = "R6c" if mode == "R" else "F6c"
    small_import = "D12U6PolynomialSeal" if mode == "R" else "D12F6PolynomialSeal"
    full_row = f"{mode}Row{row}"
    full_poly = f"{mode}_poly"
    module_prefix = f"D12Compound{mode}Row"
    quotient_size = max(1, max(len(entry[5]) for entry in certificates))
    lines: List[str] = []
    append = lines.append
    append("/-")
    append(f"  D12 compound-matrix polynomial seal, ambient row {row}.")
    append("  Auto-generated by scripts/export_d12_compound_lean.py.")
    append("  DO NOT HAND-EDIT.")
    append(f"  Schema: {SCHEMA}")
    append(f"  Source JSON sha256: {source_sha}")
    if mode == "R":
        append(f"  R6/R15 payload sha256: {payload_sha}")
    else:
        append(f"  F6/F15 payload sha256: {payload_sha}")
    append("-/")
    append(f"import V14Formalization.{small_import}")
    append(f"import V14Formalization.D12Polynomial{mode}Row{row}")
    append("import V14Formalization.PluckerNaturality")
    append("import Mathlib.Tactic.FinCases")
    append("")
    append("noncomputable section")
    append("open Matrix Polynomial")
    append(f"namespace V14Formalization.{module_prefix}{row}")
    append(f"open D12PolynomialData {small_namespace}")
    append("")
    for n in (2, 3, 4):
        append(f"private theorem C_{n}_over_11 :")
        append(
            f"    C ({n} / 11 : ℚ) = "
            f"({n} : Polynomial ℚ) * C (1 / 11 : ℚ) := by"
        )
        append(
            f"  rw [show ({n} : Polynomial ℚ) = C {n} by "
            f"exact (map_natCast C {n}).symm, ← map_mul]"
        )
        append("  norm_num")
    append("private theorem C_one_over_11_sq :")
    append("    C (1 / 11 : ℚ) =")
    append("      (11 : Polynomial ℚ) *")
    append("        (C (1 / 11 : ℚ) * C (1 / 11 : ℚ)) := by")
    append(
        "  rw [show (11 : Polynomial ℚ) = C (11 : ℚ) by rfl, "
        "← map_mul, ← map_mul]"
    )
    append("  congr 1")
    append("  ring_nf")
    append("")
    append(f"abbrev QuotCoeff := Fin {quotient_size} → ℤ")
    append("def ofQuotNumerator (v : QuotCoeff) : Polynomial ℚ :=")
    append(f"  ∑ i : Fin {quotient_size}, (v i : Polynomial ℚ) *")
    append("    (C (1 / 11 : ℚ) * C (1 / 11 : ℚ)) * X ^ i.val")
    append("")
    for column, a, b, c, d, quotient, target in certificates:
        append(f"def compoundEntry_{column} : Polynomial ℚ :=")
        append(
            f"  {small_entry}_{a}_{c} * {small_entry}_{b}_{d} - "
            f"{small_entry}_{a}_{d} * {small_entry}_{b}_{c}"
        )
        append(f"def quotient_{column} : Polynomial ℚ :=")
        append(f"  ofQuotNumerator {int_vector(quotient, quotient_size)}")
        append(f"theorem cert_{column} :")
        append(
            f"    compoundEntry_{column} - "
            f"D12PolynomialData.{full_row}.{full_poly} {row} {column} ="
        )
        append(f"      Phi11 * quotient_{column} := by")
        append(
            f"  norm_num [compoundEntry_{column}, quotient_{column}, "
            "ofQuotNumerator,"
        )
        append(
            f"    {small_entry}_{a}_{c}, {small_entry}_{b}_{d}, "
            f"{small_entry}_{a}_{d}, {small_entry}_{b}_{c},"
        )
        append(
            f"    D12PolynomialData.{full_row}.{full_poly}, "
            f"D12PolynomialData.{full_row}.{mode}{row}c{column},"
        )
        append("    D12PolynomialData.of10, Phi11,")
        append("    Fin.sum_univ_succ, Finset.sum_range_succ]")
        append("  simp only [C_2_over_11, C_3_over_11, C_4_over_11]")
        append("  norm_num")
        append(
            f"  linear_combination (-({polynomial_expression(target)})) * "
            "C_one_over_11_sq"
        )
        append("")
    append("theorem row_cert (j : Fin 15) :")
    append("    ∃ q : Polynomial ℚ,")
    append(
        f"      (PluckerNaturality.compound2Lex {small_poly}) {row} j -"
    )
    append(f"          D12PolynomialData.{full_row}.{full_poly} {row} j = Phi11 * q := by")
    append("  fin_cases j")
    for column, *_ in certificates:
        append(f"  · refine ⟨quotient_{column}, ?_⟩")
        append("    simp only [PluckerNaturality.compound2Lex, Matrix.of_apply,")
        append("      PluckerNaturality.pairEmb_eq_pairLexEmb,")
        append("      PluckerNaturality.pairLexEmb, PluckerNaturality.pairLexVec,")
        append(f"      Matrix.det_fin_two, {small_poly}]")
        append(f"    exact cert_{column}")
    append("")
    append(f"end V14Formalization.{module_prefix}{row}")
    output = output_dir / f"{module_prefix}{row}.lean"
    output.write_text("\n".join(lines) + "\n", encoding="utf-8")
    return output


def main() -> None:
    output_dir = Path(sys.argv[1]) if len(sys.argv) > 1 else DEFAULT_OUTPUT_DIR
    mode = sys.argv[2].upper() if len(sys.argv) > 2 else "R"
    if mode not in {"R", "F"}:
        raise SystemExit("usage: export_d12_compound_lean.py [OUTPUT_DIR] [R|F]")
    output_dir.mkdir(parents=True, exist_ok=True)
    raw_json = JSON_PATH.read_bytes()
    data = json.loads(raw_json)
    key6 = f"{mode}6x6"
    key15 = f"{mode}15x15"
    m6 = [[decode(entry) for entry in row] for row in data["operators"][key6]]
    m15 = [[decode(entry) for entry in row] for row in data["operators"][key15]]
    if len(m6) != 6 or any(len(row) != 6 for row in m6):
        raise ValueError(f"operators.{key6} is not 6 by 6")
    if len(m15) != 15 or any(len(row) != 15 for row in m15):
        raise ValueError(f"operators.{key15} is not 15 by 15")
    source_sha = hashlib.sha256(raw_json).hexdigest()
    payload_bytes = json.dumps(
        {key6: data["operators"][key6],
         key15: data["operators"][key15]},
        separators=(",", ":"), sort_keys=True,
    ).encode()
    payload_sha = hashlib.sha256(payload_bytes).hexdigest()
    for row in range(15):
        output = emit_row(output_dir, source_sha, payload_sha, m6, m15, row, mode)
        print(f"Wrote {output} ({output.stat().st_size} bytes)")
    print(f"SCHEMA={SCHEMA}")
    print(f"SOURCE_SHA256={source_sha}")
    print(f"{mode}6_{mode}15_PAYLOAD_SHA256={payload_sha}")


if __name__ == "__main__":
    main()
    sys.path.insert(0, __import__("os").path.dirname(__import__("os").path.abspath(__file__)))
    from module_annotation_hook import reapply_module_annotations
    reapply_module_annotations()
