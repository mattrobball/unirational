#!/usr/bin/env python3
"""
Export bounded D12 polynomial modules from results/d12_lean_K.json.

Accepted R layer (FROZEN — do not rewrite this milestone):
  * D12PolynomialCore, D12PolynomialRM, D12PolynomialRRow0..14,
    D12PolynomialRFull, D12PolynomialData

Milestone (current) — final F rows 10..14 + compact FFull + Data:
  * D12PolynomialFRow10..FRow14.lean
  * D12PolynomialFFull.lean (after shards pass)
  * D12PolynomialData.lean thin re-export update (after FFull)

Frozen: Core, RM, all RRow*, RFull, SM, FRow0..FRow9.

Architecture: shared outer-row SM_poly + SM_poly_row* (never simp [SM_poly]);
10 separately elaborated coordinate certificates per F row;
compact FFull via mul_row_of_eq + Matrix.ext (mirror RFull).

Two consecutive runs must be byte-identical for every generated file.
"""
from __future__ import annotations

import hashlib
import json
import re
import sys
from fractions import Fraction
from pathlib import Path
from typing import Dict, List, Sequence, Tuple

ROOT = Path(__file__).resolve().parents[1]
JSON_PATH = ROOT / "results" / "d12_lean_K.json"
OUT_DIR = ROOT / "V14Formalization"
SCHEMA = "v14.fix_ix.d12_poly.v31_F_rows_10_14_FFull"

CORE_PATH = OUT_DIR / "D12PolynomialCore.lean"
RM_PATH = OUT_DIR / "D12PolynomialRM.lean"
SM_PATH = OUT_DIR / "D12PolynomialSM.lean"
RFULL_PATH = OUT_DIR / "D12PolynomialRFull.lean"
DATA_PATH = OUT_DIR / "D12PolynomialData.lean"

FROW_PATHS = {r: OUT_DIR / f"D12PolynomialFRow{r}.lean" for r in range(15)}
ROW_PATHS = {r: OUT_DIR / f"D12PolynomialRRow{r}.lean" for r in range(15)}

# Active F emit set this milestone.
F_MILESTONE_ROWS = [10, 11, 12, 13, 14]
# Accepted F shards (byte-frozen).
F_FROZEN_ROWS = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
ALL_F_ROWS = list(range(15))
FFULL_PATH = OUT_DIR / "D12PolynomialFFull.lean"

Poly = List[Fraction]

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

R_ROWS = list(range(15))
B_ROW_MAP = {
    0: (0, Fraction(1)), 1: (1, Fraction(1)), 2: (2, Fraction(1)),
    3: (3, Fraction(1)), 4: (4, Fraction(1)), 5: (3, Fraction(-1, 2)),
    6: (5, Fraction(1)), 7: (6, Fraction(1)), 8: (1, Fraction(1, 2)),
    9: (7, Fraction(1)), 10: (2, Fraction(-1, 2)), 11: (8, Fraction(1)),
    12: (4, Fraction(1, 2)), 13: (0, Fraction(-1, 2)), 14: (9, Fraction(1)),
}


def pnorm(p: Poly) -> Poly:
    while p and p[-1] == 0:
        p.pop()
    return p


def pfrom(pairs: Sequence[Sequence[int]]) -> Poly:
    return pnorm([Fraction(int(n), int(d)) for n, d in pairs])


def pad(p: Poly, n: int = 10) -> List[Fraction]:
    return list(p) + [Fraction(0)] * max(0, n - len(p))


def padd(a: Poly, b: Poly) -> Poly:
    n = max(len(a), len(b))
    r = [Fraction(0)] * n
    for i, x in enumerate(a):
        r[i] += x
    for i, y in enumerate(b):
        r[i] += y
    return pnorm(r)


def pmul(a: Poly, b: Poly) -> Poly:
    if not a or not b:
        return []
    r = [Fraction(0)] * (len(a) + len(b) - 1)
    for i, x in enumerate(a):
        if x:
            for j, y in enumerate(b):
                if y:
                    r[i + j] += x * y
    return pnorm(r)


def pC(q: Fraction) -> Poly:
    return pnorm([q])


def psub(a: Poly, b: Poly) -> Poly:
    return padd(a, [-x for x in b])


def mat_poly(M):
    return [[pfrom(e) for e in row] for row in M]


def mmul_p(A, B):
    n, pdim, m = len(A), len(B), len(B[0]) if B else 0
    C = [[[] for _ in range(m)] for _ in range(n)]
    for i in range(n):
        for k in range(pdim):
            if not A[i][k]:
                continue
            for j in range(m):
                if B[k][j]:
                    C[i][j] = padd(C[i][j], pmul(A[i][k], B[k][j]))
    return C


def meye_p(n: int):
    return [[pC(Fraction(1 if i == j else 0)) for j in range(n)] for i in range(n)]


def frac_lean(x: Fraction) -> str:
    if x.denominator == 1:
        return str(int(x.numerator))
    return f"({int(x.numerator)} / {int(x.denominator)} : \u211a)"


def coeffs_lean(p: Poly, n: int = 10) -> str:
    return "![" + ", ".join(frac_lean(c) for c in pad(p, n)) + "]"


def req(cond: bool, msg: str) -> None:
    if not cond:
        raise SystemExit(f"REQUIRE failed: {msg}")


def write_text(path: Path, text: str) -> None:
    if not text.endswith("\n"):
        text += "\n"
    path.write_text(text, encoding="utf-8")


def f_coord_defs_for(row: int, j: int) -> str:
    """F-column coeff defs (B-support of col j) + canonical SM source coeff."""
    br, _ = B_ROW_MAP[row]
    defs = [f"F{row}c{k}" for k, _ in B_COL[j]]
    defs.append(f"SM{br}c{j}")
    seen: List[str] = []
    for d in defs:
        if d not in seen:
            seen.append(d)
    return ", ".join(seen)


# ---------------------------------------------------------------------------
# Module-system migration of the byte-frozen D12PolynomialCore.
#
# The code that originally emitted Core predates this repository's history
# (Core froze several milestones ago), so Core cannot be re-derived from
# JSON by the current script.  Instead the migration is a deterministic,
# invertible transformation of the frozen bytes, performed here so that the
# generated file is never hand-edited: strip any existing annotations,
# require the pristine bytes to hash to the frozen sha256, then re-insert
# the annotations.  Two consecutive runs are byte-identical.
# ---------------------------------------------------------------------------
CORE_FROZEN_SHA = "401ecc8eb7cdb7bbcccd20124a2e4e000554a10d25de5a30f5c04ae42e2dc299"
# Downstream-referenced names (usage scan over all importers, 2026-08-17).
# Defs the importers unfold via `simp [B_poly]`, `simp [Phi11]`, rfl checks.
CORE_EXPOSE_DEFS = {"of10", "Phi11", "B_poly", "L_poly", "payloadSha256"}
# Theorems importers cite by name.
CORE_PUBLIC_THMS = {"of10_add", "C_mul_of10", "of10_mul_C", "L_mul_B_poly"}
# Abbrevs in downstream signatures (public abbrevs are exposed by default).
CORE_PUBLIC_ABBREVS = {"PolyQ", "Coeff10"}


def migrate_core_annotations() -> None:
    text = CORE_PATH.read_text(encoding="utf-8")
    # Invert a previous run: drop the module header and annotation prefixes.
    lines = []
    for ln in text.split("\n"):
        if ln == "module":
            continue
        ln = re.sub(r"^public import ", "import ", ln)
        ln = re.sub(r"^(?:@\[expose\] )?public (def|theorem|abbrev) ", r"\1 ", ln)
        lines.append(ln)
    pristine = "\n".join(lines)
    # The `module` line is followed by a blank separator we also inserted.
    pristine = pristine.replace("-/\n\nimport ", "-/\nimport ", 1)
    got = hashlib.sha256(pristine.encode("utf-8")).hexdigest()
    if got != CORE_FROZEN_SHA:
        raise SystemExit(
            f"REQUIRE failed: D12PolynomialCore pristine sha {got} != {CORE_FROZEN_SHA}"
        )
    out = []
    first_import_seen = False
    for ln in pristine.split("\n"):
        if ln.startswith("import "):
            if not first_import_seen:
                out.append("module")
                out.append("")
                first_import_seen = True
            out.append("public " + ln)
            continue
        m = re.match(r"^(def|theorem|abbrev) ([\w'«»]+)[ :]", ln)
        if m:
            kind, name = m.groups()
            if kind == "def" and name in CORE_EXPOSE_DEFS:
                ln = "@[expose] public " + ln
            elif kind == "theorem" and name in CORE_PUBLIC_THMS:
                ln = "public " + ln
            elif kind == "abbrev" and name in CORE_PUBLIC_ABBREVS:
                ln = "public " + ln
        out.append(ln)
    write_text(CORE_PATH, "\n".join(out))
    print(f"Migrated {CORE_PATH.relative_to(ROOT)} (module annotations, frozen body)")


def main() -> int:
    data = json.loads(JSON_PATH.read_text(encoding="utf-8"))
    R = mat_poly(data["operators"]["R15x15"])
    F = mat_poly(data["operators"]["F15x15"])
    B = mat_poly(data["m"]["B15x10"])
    L = mat_poly(data["m"]["L10x15"])
    RM = mat_poly(data["m"]["RM10x10"])
    SM = mat_poly(data["m"]["SM10x10"])

    for j, supp in B_COL.items():
        for i, v in supp:
            req(B[i][j] == pC(v), f"B[{i},{j}] != {v}")
        for i in range(15):
            if all(i != ii for ii, _ in supp):
                req(B[i][j] == [], f"B[{i},{j}] unexpected nonzero")

    LB = mmul_p(L, B)
    I10 = meye_p(10)
    for i in range(10):
        for j in range(10):
            req(psub(LB[i][j], I10[i][j]) == [], f"L*B[{i},{j}]")

    # Independent exact-arithmetic residual checks (R and F layers).
    RB = mmul_p(R, B)
    BRM = mmul_p(B, RM)
    r_resid = 0
    for row in R_ROWS:
        for j in range(10):
            if psub(RB[row][j], BRM[row][j]) != []:
                r_resid += 1
    req(r_resid == 0, f"R*B-B*RM residuals: {r_resid}")

    FB = mmul_p(F, B)
    BSM = mmul_p(B, SM)
    f_resid = 0
    for row in range(15):
        for j in range(10):
            if psub(FB[row][j], BSM[row][j]) != []:
                f_resid += 1
    req(f_resid == 0, f"F*B-B*SM residuals: {f_resid}")
    print(f"EXACT_ARITH residual counts: R*B-B*RM={r_resid} F*B-B*SM={f_resid}")

    for row in range(15):
        br, bv = B_ROW_MAP[row]
        req(B[row][br] == pC(bv), f"B[{row},{br}] scale mismatch")

    # F entries are degree ≤9 (of10 / Coeff10).
    for i in range(15):
        for k in range(15):
            req(len(F[i][k]) <= 10, f"F[{i},{k}] degree too high: {len(F[i][k])}")
    for i in range(10):
        for j in range(10):
            req(len(SM[i][j]) <= 10, f"SM[{i},{j}] degree too high")

    f_cols = list(range(15))  # F ambient rows are dense in practice

    payload = {
        "schema": SCHEMA,
        "json_sha256": data.get("sha256", ""),
        "f_milestone_rows": F_MILESTONE_ROWS,
        "f_frozen_rows": F_FROZEN_ROWS,
        "modules": [
            "D12PolynomialCore",
            "D12PolynomialSM",
            *[f"D12PolynomialFRow{r}" for r in F_MILESTONE_ROWS],
            "D12PolynomialFFull",
            "D12PolynomialData",
        ],
        "frozen": [
            "D12PolynomialCore",
            "D12PolynomialRM",
            "D12PolynomialSM",
            *[f"D12PolynomialRRow{r}" for r in range(15)],
            "D12PolynomialRFull",
            *[f"D12PolynomialFRow{r}" for r in F_FROZEN_ROWS],
        ],
    }
    sha = hashlib.sha256(json.dumps(payload, sort_keys=True).encode()).hexdigest()

    # SM frozen this milestone (accepted v28 bytes).
    _ = SM_PATH

    # ---------- F ROW SHARDS (no local SM; shared canonical SM_poly) ----------
    def emit_f_row_shard(path: Path, row: int) -> None:
        br, bv = B_ROW_MAP[row]
        lines: List[str] = []
        a = lines.append
        a(f"""/-
  D12 polynomial F-row shard — ambient row {row}.
  Auto-generated by scripts/export_d12_poly_lean.py — DO NOT HAND-EDIT.
  Schema: {SCHEMA}
  Payload sha256: {sha}
  Depends on: D12PolynomialCore + D12PolynomialSM (canonical SM_poly)

  * F*B = B*SM on ambient row {row} (SM source row {br}, B-scale {bv}).
  * Shared SM_poly only — no local SM copy.
  * BSM: collapse sparse B, rw SM_poly_row{br}, SMrow{br}_j; never simp [SM_poly].
  * FB: of10 algebra + funext/fin_cases/norm_num on coefficient vectors.
-/
import V14Formalization.D12PolynomialCore
import V14Formalization.D12PolynomialSM
import Mathlib.Tactic.FinCases

noncomputable section

open Polynomial BigOperators Matrix
open V14Formalization.D12PolynomialData

namespace V14Formalization
namespace D12PolynomialData
namespace FRow{row}

def ambientRow : Nat := {row}
def smSourceRow : Nat := {br}
""")

        a(f"/-! ### F row {row} coefficient vectors -/")
        for k in f_cols:
            a(f"def F{row}c{k} : Coeff10 := {coeffs_lean(F[row][k])}")
        a("")
        a("def F_poly : Matrix (Fin 15) (Fin 15) PolyQ :=")
        a("  Matrix.of fun i j =>")
        a("    match i.val, j.val with")
        for k in f_cols:
            a(f"    | {row}, {k} => of10 F{row}c{k}")
        a("    | _, _ => 0")
        a("")

        a(f"/-! ### F * B = B * SM on ambient row {row} (shared SM_poly) -/")
        for j in range(10):
            dlist = f_coord_defs_for(row, j)
            if bv == 1:
                bsm_target = f"of10 SM{br}c{j}"
                bsm_close = f"""  rw [SM_poly_row{br}]
  exact SMrow{br}_{j}"""
            else:
                bsm_target = f"C ({frac_lean(bv)}) * of10 SM{br}c{j}"
                bsm_close = f"""  rw [SM_poly_row{br}, SMrow{br}_{j}]"""

            a(f"""
theorem BSM_{row}_{j} :
    (B_poly * SM_poly) ({row} : Fin 15) ({j} : Fin 10) = {bsm_target} := by
  simp only [Matrix.mul_apply]
  -- Collapse sparse B only — do not unfold SM_poly.
  simp [Fin.sum_univ_succ, B_poly, Matrix.of_apply,
    mul_zero, zero_mul, add_zero, zero_add, one_mul, mul_one]
  -- Single surviving SM entry via row-selection + fixed-column accessor.
{bsm_close}

theorem FB_{row}_{j} :
    (F_poly * B_poly) ({row} : Fin 15) ({j} : Fin 10) = {bsm_target} := by
  simp only [Matrix.mul_apply]
  simp [Fin.sum_univ_succ, F_poly, B_poly, Matrix.of_apply,
    mul_zero, zero_mul, add_zero, zero_add, mul_one, one_mul]
  try rw [of10_mul_C, C_mul_of10]
  try simp only [of10_mul_C, C_mul_of10, of10_add, mul_one, one_mul]
  first
  | rfl
  | · apply congrArg of10
      funext t; fin_cases t <;> norm_num [{dlist}]

theorem F_mul_B_eq_B_mul_SM_row{row}_j{j} :
    (F_poly * B_poly - B_poly * SM_poly) ({row} : Fin 15) ({j} : Fin 10) =
      (0 : PolyQ) := by
  simp only [Matrix.sub_apply, FB_{row}_{j}, BSM_{row}_{j}, sub_self]
""")

        arms_j = "\n".join(
            f"  | \u27e8{j}, _\u27e9 => F_mul_B_eq_B_mul_SM_row{row}_j{j}" for j in range(10)
        )
        a(f"""
/-- Pure row dispatcher for ambient F row {row}. -/
theorem F_mul_B_eq_B_mul_SM_row{row} (j : Fin 10) :
    (F_poly * B_poly - B_poly * SM_poly) ({row} : Fin 15) j = (0 : PolyQ) :=
  match j with
{arms_j}

#print axioms F_mul_B_eq_B_mul_SM_row{row}
#print axioms F_mul_B_eq_B_mul_SM_row{row}_j0
#print axioms F_mul_B_eq_B_mul_SM_row{row}_j5
#print axioms F_mul_B_eq_B_mul_SM_row{row}_j9

end FRow{row}
end D12PolynomialData
end V14Formalization
""")
        write_text(path, "\n".join(lines))

    # Frozen: Core, RM, SM, all RRow*, RFull, FRow0..9.
    # Data/FFull may be rewritten only when EMIT_FFULL is true (after shard accept).
    EMIT_FFULL = True  # compact FFull + Data after final F batch
    _ = (CORE_PATH, RM_PATH, SM_PATH, RFULL_PATH, ROW_PATHS, FROW_PATHS)

    written: List[Path] = []
    for row in F_MILESTONE_ROWS:
        emit_f_row_shard(FROW_PATHS[row], row)
        written.append(FROW_PATHS[row])

    if EMIT_FFULL:
        # ---------- COMPACT FFull (mirror RFull) ----------
        ffull: List[str] = []
        f = ffull.append
        row_imports = "\n".join(
            f"import V14Formalization.D12PolynomialFRow{r}" for r in ALL_F_ROWS
        )
        f_match = "\n".join(
            f"    | {r} => FRow{r}.F_poly i j" for r in ALL_F_ROWS
        )
        row_thms: List[str] = []
        for r in ALL_F_ROWS:
            row_thms.append(f"""
private theorem row{r} (j : Fin 10) :
    (F_poly * B_poly - B_poly * SM_poly) ({r} : Fin 15) j = (0 : PolyQ) := by
  have hF : ∀ k : Fin 15,
      F_poly ({r} : Fin 15) k = FRow{r}.F_poly ({r} : Fin 15) k := by
    intro k; simp [F_poly, Matrix.of_apply]
  have hFB := mul_row_of_eq F_poly FRow{r}.F_poly ({r} : Fin 15) j hF
  simpa [Matrix.sub_apply, hFB] using FRow{r}.F_mul_B_eq_B_mul_SM_row{r} j
""")
        dispatch_arms = "\n".join(
            f"  | ⟨{r}, _⟩ =>\n"
            f"    have h := row{r} j\n"
            f"    simp only [Matrix.sub_apply] at h\n"
            f"    exact sub_eq_zero.mp h"
            for r in ALL_F_ROWS
        )
        f(f"""/-
  D12 polynomial F-full aggregate — compact structural identity F*B = B*SM.
  Auto-generated by scripts/export_d12_poly_lean.py — DO NOT HAND-EDIT.
  Schema: {SCHEMA}
  Payload sha256: {sha}

  * Assembled F_poly from the 15 certified ambient F-row shards.
  * Exact shared D12PolynomialData.SM_poly (no redefinition / alias / unfold).
  * One generic mul_row_of_eq glue (F-row transport only; never opens B/SM).
  * One small theorem per ambient row → certified shard theorem.
  * Final Matrix.ext + 15-way ambient-row dispatch only (no inner fin_cases).
-/
import V14Formalization.D12PolynomialCore
import V14Formalization.D12PolynomialSM
{row_imports}

noncomputable section

open Polynomial BigOperators Matrix
open V14Formalization.D12PolynomialData

namespace V14Formalization
namespace D12PolynomialData
namespace FFull

/-- Global F assembled row-wise from the 15 ambient F-row shards. -/
def F_poly : Matrix (Fin 15) (Fin 15) PolyQ :=
  Matrix.of fun i j =>
    match i.val with
{f_match}
    | _ => 0

/-- Generic F-row transport: never opens B or SM. -/
private lemma mul_row_of_eq
    (Ffull Flocal : Matrix (Fin 15) (Fin 15) PolyQ)
    (i : Fin 15) (j : Fin 10)
    (hF : ∀ k : Fin 15, Ffull i k = Flocal i k) :
    (Ffull * B_poly) i j = (Flocal * B_poly) i j := by
  simp only [Matrix.mul_apply]
  exact Finset.sum_congr rfl fun k _ => congrArg (· * B_poly k j) (hF k)
{"".join(row_thms)}
/-- Full matrix identity F_poly * B_poly = B_poly * SM_poly. -/
theorem F_mul_B_eq_B_mul_SM :
    F_poly * B_poly = B_poly * SM_poly := by
  apply Matrix.ext
  intro i j
  match i with
{dispatch_arms}

#print axioms F_mul_B_eq_B_mul_SM
#print axioms row0
#print axioms row5
#print axioms row14

end FFull
end D12PolynomialData
end V14Formalization
""")
        write_text(FFULL_PATH, "\n".join(ffull))
        written.append(FFULL_PATH)

        # ---------- thin Data aggregator (R + F layers) ----------
        modules = (
            ["D12PolynomialCore", "D12PolynomialRM", "D12PolynomialSM"]
            + [f"D12PolynomialRRow{r}" for r in range(15)]
            + ["D12PolynomialRFull"]
            + [f"D12PolynomialFRow{r}" for r in ALL_F_ROWS]
            + ["D12PolynomialFFull"]
        )
        tree_lines = []
        for i, m in enumerate(modules):
            branch = "└─" if i == len(modules) - 1 else "├─"
            if m == "D12PolynomialCore":
                note = "(B, L, of10, L*B=1)"
            elif m == "D12PolynomialRM":
                note = "(canonical RM_poly)"
            elif m == "D12PolynomialSM":
                note = "(canonical SM_poly)"
            elif m == "D12PolynomialRFull":
                note = "(R*B = B*RM)"
            elif m == "D12PolynomialFFull":
                note = "(F*B = B*SM)"
            elif m.startswith("D12PolynomialRRow"):
                note = f"(R row {m.replace('D12PolynomialRRow', '')})"
            elif m.startswith("D12PolynomialFRow"):
                note = f"(F row {m.replace('D12PolynomialFRow', '')})"
            else:
                note = ""
            tree_lines.append(f"      {branch} {m:<24} {note}")
        imports = "\n".join(f"import V14Formalization.{m}" for m in modules)
        mods_list = ", ".join(f'"{m}"' for m in modules)
        data_text = f"""/-
  D12 polynomial data — thin re-export of R layer + F layer.
  Auto-generated by scripts/export_d12_poly_lean.py — DO NOT HAND-EDIT.
  Schema: {SCHEMA}
  Payload sha256: {sha}

  Dependency graph:
    D12PolynomialData
{chr(10).join(tree_lines)}
-/
{imports}

namespace V14Formalization
namespace D12PolynomialData

-- Re-export markers for discoverability (no new proofs).
def modules : List String :=
  [{mods_list}]

end D12PolynomialData
end V14Formalization
"""
        write_text(DATA_PATH, data_text)
        written.append(DATA_PATH)

    migrate_core_annotations()

    for path in written:
        text = path.read_text(encoding="utf-8")
        print(f"Wrote {path.relative_to(ROOT)} ({len(text)} bytes, {text.count(chr(10))} lines)")
    print(f"SCHEMA={SCHEMA} sha256={sha}")
    print(
        f"F milestone rows: {F_MILESTONE_ROWS}; frozen F: {F_FROZEN_ROWS}; "
        f"EMIT_FFULL={EMIT_FFULL}"
    )
    return 0


if __name__ == "__main__":
    if "--migrate-core-only" in sys.argv[1:]:
        migrate_core_annotations()
        sys.exit(0)
    sys.exit(main())
