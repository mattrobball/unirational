#!/usr/bin/env python3
"""Emitter pass: route the generated SplitRow certificates through shared lemmas.

Pipeline position
-----------------
    export_d12_piece_vec_lean.py  ->  D12Piece{fam}SplitEntry{r}_{c}.lean
    merge_split_entry_rows.py     ->  D12Piece{fam}SplitRow{r}.lean
    THIS PASS                     ->  D12Piece{fam}SplitRow{r}.lean  (in place)

Never hand-edit the SplitRow files; re-run this instead.  The pass is strict
(every rewritable proof must match one of the known shapes, and the totals are
asserted) and idempotent (an already-converted file rewrites to itself).

What it changes, and why
------------------------
Only *proofs*.  Every theorem statement is preserved byte-for-byte; the script
asserts that at the end by diffing the statement lines of the input against the
output.

1. `funext i; fin_cases i; (· change …; exact …) x10`
   ->  one application of `D12CyclotomicVecZ.toVec_eq_smul10`.

   `fin_cases` inlines a `List.Mem.casesOn` over `List.finRange 10` with
   `Finset.univ` `HEq` motives into *every* coordinate case, ~2,900 of every
   3,000 Expr nodes.  There are 16,800 such blocks across the 40 SplitRow
   modules.  Proving the case split once and applying it turns each generated
   proof into a single application over the ten arithmetic certificates.
   Measured on D12PieceAASplitRow0 (pilot e92f2b91): 1,381,831 -> 150,385
   deduped Expr nodes, 129.9M -> 1.49M raw, olean 24.5 MB -> 3.2 MB.

2. `fin_cases k; (· simp […]; exact …_j) xN`  ->  `forall_fin{N}`.
3. `rw [entry_eq]; funext n; fin_cases n <;> simp […]`
   ->  `entry_eq.trans (matrixOne_diag10 i).symm` / `(matrixOne_off10 i j _)`.
4. `fin_cases j; (· exact …entry_eq_matrixOne) x10`
   ->  `D12CyclotomicVecZ.forall_fin10`.
5. `theorem entryZ_eq … := by decide +kernel`
   ->  `eq_of_eqZ (by decide +kernel)`.

   (5) is what removes the `import all` lines.  `VecZ = Vector Int 10`, and the
   toolchain's `instDecidableEqVector.decEq` / `Array.instDecidableEqImpl` are
   `public` but not `@[expose]`d, so `decide` on a `Vector` equality is stuck in
   any `module` file and no project-side annotation can help.  `eqZ` (defined in
   D12CyclotomicVecZ, where `VecZ` lives) tests the ten coordinates as `Int`s
   and returns a `Bool`; that reduces in the kernel.  Same arithmetic, no
   `import all`.

6. Header: drop `import all …`, add `public import V14Formalization.D12VecScaleIntro`.
"""

import re
import sys
import os
import glob

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

INTRO_IMPORT = "public import V14Formalization.D12VecScaleIntro"
IMPORT_ALL = re.compile(r"^import all (Init\.Data\.Vector\.Basic|Init\.Data\.Array\.DecidableEq)$")

# theorem <name> : toVec (<expr>) = (scale : ℚ) • <cell> := by
CELL_HEAD = re.compile(
    r"^theorem (?P<name>\w+) : toVec \((?P<expr>[^()]*)\) = \(scale : ℚ\) • (?P<cell>\S+) := by$"
)
# theorem <name> (k : Fin <n>) :
AGG_HEAD = re.compile(r"^theorem (?P<name>\w+) \(k : Fin (?P<n>\d+)\) :$")
ROW_HEAD = re.compile(r"^(?P<vis>public )?theorem row_eq \(j : Fin 10\) :$")
MATONE_HEAD = re.compile(r"^theorem entry_eq_matrixOne :$")
ENTRYZ = re.compile(r"^theorem entryZ_eq : entryZ = (?P<rhs>.+) := by$")
FIN_IDX = re.compile(r"\((?P<i>\d+) : Fin 10\) \((?P<j>\d+) : Fin 10\) =$")


class Fail(Exception):
    pass


def scan_statement(lines, j, n, what):
    """Collect statement lines from `j` up to the proof opener.  Returns
    (stmt, next_index, tactic_mode); `tactic_mode` is False when the block is
    already in term mode, which is how this pass stays idempotent."""
    stmt = []
    while j < n and not re.search(r":=( by)?$", lines[j]):
        stmt.append(lines[j])
        j += 1
    if j >= n:
        raise Fail(f"{what}: no proof opener")
    if lines[j].endswith(":= by"):
        stmt.append(lines[j][: -len(" := by")])
        return stmt, j + 1, True
    stmt.append(lines[j][: -len(" :=")])
    return stmt, j + 1, False



def statements(text):
    """Statement lines: everything from a `theorem` line up to the `:= by` /
    `:=` that opens the proof.  Used to assert statements never change."""
    out = []
    lines = text.split("\n")
    i = 0
    while i < len(lines):
        if re.match(r"^(public )?theorem ", lines[i]):
            chunk = []
            while i < len(lines):
                l = lines[i]
                chunk.append(re.sub(r"\s*:=( by)?$", "", l))
                i += 1
                if re.search(r":=( by)?$", l):
                    break
            out.append("\n".join(chunk).rstrip())
        else:
            i += 1
    return out


def convert(text, counts):
    lines = text.split("\n")
    out = []
    i = 0
    n = len(lines)
    while i < n:
        line = lines[i]

        # --- (6) header -------------------------------------------------
        if IMPORT_ALL.match(line):
            counts["import_all_dropped"] += 1
            i += 1
            continue

        # --- (5) entryZ_eq ----------------------------------------------
        m = ENTRYZ.match(line)
        if m and i + 1 < n and lines[i + 1].strip() == "decide +kernel":
            out.append(f"theorem entryZ_eq : entryZ = {m.group('rhs')} :=")
            out.append("  eq_of_eqZ (by decide +kernel)")
            counts["entryZ_eq"] += 1
            i += 2
            continue

        # --- (1) coordinate scale lemma ---------------------------------
        m = CELL_HEAD.match(line)
        if m and i + 2 < n and lines[i + 1] == "  funext i" and lines[i + 2] == "  fin_cases i":
            j = i + 3
            proofs = []
            while j + 1 < n and lines[j].startswith("  · change ") and lines[j + 1].startswith("    exact "):
                proofs.append(lines[j + 1][len("    exact "):])
                j += 2
            if len(proofs) != 10:
                raise Fail(f"{m.group('name')}: {len(proofs)} coordinate cases, expected 10")
            name, expr, cell = m.group("name"), m.group("expr"), m.group("cell")
            out.append(f"theorem {name} : toVec ({expr}) = (scale : ℚ) • {cell} :=")
            out.append(f"  toVec_eq_smul10 ({expr}) scale {cell}")
            out.extend(f"    ({p})" for p in proofs)
            counts["toVec_eq_smul10"] += 1
            i = j
            continue

        # --- (2) aggregated scale lemma ---------------------------------
        m = AGG_HEAD.match(line)
        if m:
            name, cnt = m.group("name"), int(m.group("n"))
            stmt, j, tactic = scan_statement(lines, i + 1, n, name)
            if not tactic:
                out.append(line)
                i += 1
                continue
            if lines[j] != "  fin_cases k":
                raise Fail(f"{name}: expected `fin_cases k`, got {lines[j]!r}")
            j += 1
            args = []
            while j < n and lines[j].startswith("  · simp ["):
                mm = re.search(r"exact (\w+)$", lines[j])
                if not mm:
                    raise Fail(f"{name}: unparsed case {lines[j]!r}")
                args.append(mm.group(1))
                j += 1
            if len(args) != cnt:
                raise Fail(f"{name}: {len(args)} cases, expected {cnt}")
            body = " ".join(x.strip() for x in stmt)
            out.append(f"theorem {name} (k : Fin {cnt}) :")
            out.extend(stmt[:-1])
            out.append(stmt[-1] + " :=")
            out.append(f"  forall_fin{cnt} (P := fun k => {body})")
            out.append("    " + " ".join(args) + " k")
            counts[f"forall_fin{cnt}"] += 1
            i = j
            continue

        # --- (3) entry_eq_matrixOne -------------------------------------
        if MATONE_HEAD.match(line):
            stmt, j, tactic = scan_statement(lines, i + 1, n, "entry_eq_matrixOne")
            if not tactic:
                out.append(line)
                i += 1
                continue
            if lines[j] != "  rw [entry_eq]":
                raise Fail(f"entry_eq_matrixOne: expected rw, got {lines[j]!r}")
            j += 1
            hne = None
            mh = re.match(r"^  have hne : \((\d+) : Fin 10\) ≠ \((\d+) : Fin 10\) := by decide$", lines[j])
            if mh:
                hne = (mh.group(1), mh.group(2))
                j += 1
            if lines[j] != "  funext n":
                raise Fail(f"entry_eq_matrixOne: expected funext, got {lines[j]!r}")
            j += 1
            if not lines[j].startswith("  fin_cases n <;> simp ["):
                raise Fail(f"entry_eq_matrixOne: expected fin_cases n, got {lines[j]!r}")
            j += 1
            idx = None
            for s in stmt:
                mi = FIN_IDX.search(s)
                if mi:
                    idx = (mi.group("i"), mi.group("j"))
            if idx is None:
                raise Fail("entry_eq_matrixOne: cannot read entry indices from statement")
            if hne is not None and hne != idx:
                raise Fail(f"entry_eq_matrixOne: hne {hne} disagrees with statement {idx}")
            r, c = idx
            out.append("theorem entry_eq_matrixOne :")
            out.extend(stmt[:-1])
            out.append(stmt[-1] + " :=")
            if r == c:
                if hne is not None:
                    raise Fail("entry_eq_matrixOne: diagonal entry carries an hne")
                out.append(f"  entry_eq.trans (matrixOne_diag10 ({r} : Fin 10)).symm")
                counts["matrixOne_diag10"] += 1
            else:
                if hne is None:
                    raise Fail("entry_eq_matrixOne: off-diagonal entry without hne")
                out.append(
                    f"  entry_eq.trans (matrixOne_off10 ({r} : Fin 10) ({c} : Fin 10) (by decide)).symm"
                )
                counts["matrixOne_off10"] += 1
            i = j
            continue

        # --- (4) row_eq --------------------------------------------------
        m = ROW_HEAD.match(line)
        if m:
            vis = m.group("vis") or ""
            stmt, j, tactic = scan_statement(lines, i + 1, n, "row_eq")
            if not tactic:
                out.append(line)
                i += 1
                continue
            if lines[j] != "  fin_cases j":
                raise Fail(f"row_eq: expected `fin_cases j`, got {lines[j]!r}")
            j += 1
            args = []
            while j < n and lines[j].startswith("  · exact "):
                args.append(lines[j][len("  · exact "):])
                j += 1
            if len(args) != 10:
                raise Fail(f"row_eq: {len(args)} cases, expected 10")
            body = " ".join(x.strip() for x in stmt)
            out.append(f"{vis}theorem row_eq (j : Fin 10) :")
            out.extend(stmt[:-1])
            out.append(stmt[-1] + " :=")
            out.append("  D12CyclotomicVecZ.forall_fin10")
            out.append(f"    (P := fun j => {body})")
            out.extend(f"    {a}" for a in args)
            out.append("    j")
            counts["row_eq"] += 1
            i = j
            continue

        out.append(line)
        i += 1

    text2 = "\n".join(out)
    # (6) add the intro import next to the other project imports
    if INTRO_IMPORT not in text2:
        text2 = text2.replace(
            "public import V14Formalization.D12CyclotomicVecZ",
            "public import V14Formalization.D12CyclotomicVecZ\n" + INTRO_IMPORT,
            1,
        )
    return text2


def main(argv):
    paths = argv[1:] or sorted(glob.glob(os.path.join(ROOT, "V14Formalization", "D12Piece??SplitRow*.lean")))
    grand = {}
    for p in paths:
        src = open(p).read()
        counts = {
            k: 0
            for k in (
                "import_all_dropped", "entryZ_eq", "toVec_eq_smul10", "forall_fin20",
                "forall_fin10", "forall_fin2", "forall_fin1", "matrixOne_diag10", "matrixOne_off10", "row_eq",
            )
        }
        dst = convert(src, counts)
        before, after = statements(src), statements(dst)
        if before != after:
            for a, b in zip(before, after):
                if a != b:
                    raise SystemExit(f"{p}: STATEMENT CHANGED\n--- {a}\n+++ {b}")
            raise SystemExit(f"{p}: statement count changed {len(before)} -> {len(after)}")
        if dst != src:
            open(p, "w").write(dst)
        for k, v in counts.items():
            grand[k] = grand.get(k, 0) + v
        print(os.path.basename(p), {k: v for k, v in counts.items() if v})
    print("TOTALS", grand)
    if "INTRO_CHECK" in os.environ:
        assert grand["import_all_dropped"] == 2 * len(paths), grand


if __name__ == "__main__":
    main(sys.argv)
