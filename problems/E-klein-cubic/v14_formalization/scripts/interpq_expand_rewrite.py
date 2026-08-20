#!/usr/bin/env python3
"""Emitter post-pass: route the generated `interpQ` bridges through shared lemmas.

    python3 scripts/interpq_expand_rewrite.py --emit-lemmas   # writes D12PolyZExpand.lean
    python3 scripts/interpq_expand_rewrite.py                 # rewrites the certificates

The generated Segre certificates state, 3,711 times, that a `Polynomial ℚ`
written out term by term equals an integer interpolation:

    def HM_5_0_A_pre : Polynomial ℚ := C 4 + C 16 * X + … + C 4 * X ^ 18
    theorem z_HM_5_0_A_pre : HM_5_0_A_pre = interpQ 1 [4, 16, …, 4] := by
      refine Polynomial.funext fun r => ?_
      simp [HM_5_0_A_pre, interpQ, toPolyZ, Polynomial.eval_add, …]
      try ring

All 3,711 have exactly that proof shape, and each costs ~15,000 `Expr` nodes
because the `simp` certificate is re-derived per polynomial.  They are 89% of
an HM module and 73% of a VQ module — the same defect the SplitRow
certificates had with `funext` + `fin_cases`.

The remedy is the same: prove the expansion once and apply it.  It cannot be
one lemma per degree, because the emitter OMITS terms whose coefficient is
zero, so the left-hand side is sparse and not definitionally the dense sum.
It is one lemma per (length, support) pattern instead — 153 of them across the
whole tree, generated into `V14Formalization/D12PolyZExpand.lean` by
`--emit-lemmas`.  Each generated proof then becomes an application of its
present coefficients.

Measured on the degree-18 dense case: 14,784 nodes -> 152, a 97x cut, with the
shared lemma's 13,522 paid once for every use of that pattern.

Only denominator 1 is rewritten (8,954 of the 9,108 bridges); the 154 with
denominator 2 or 4, the 658 whose left-hand side is not a top-level
`def … : Polynomial ℚ := …`, and the 5,397 empty-list bridges (already
`interpQ_nil`) keep their existing proofs.

Statements are preserved byte-for-byte: the pass extracts the statement text
from input and output and refuses to write if any differs.  Strict and
idempotent — pattern discovery reads the *statements*, so it gives the same
answer before and after the rewrite.
"""

import re
import sys
import os
import glob

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LEMMA_FILE = os.path.join(ROOT, "V14Formalization", "D12PolyZExpand.lean")
EXPAND_IMPORT = "V14Formalization.D12PolyZExpand"
NS = "V14Formalization.D12PolyZReflection"

# `theorem z_X : X = interpQ 1 [..] :=` with or without a trailing `by`
HEAD = re.compile(
    r"^theorem (?P<name>\S+) : (?P<lhs>\S+) = interpQ (?P<den>\d+) \[(?P<coeffs>[^\]]*)\] :=(?P<by> by)?$"
)
DEF = re.compile(r"^def (\S+) : Polynomial ℚ := (.*)$")
TERM = re.compile(r"C \((-?\d+)\)(\s*\*\s*X\s*\^\s*(\d+)|\s*\*\s*X(?!\s*\^))?")


def support_of(body):
    """Degrees present in a written-out `Polynomial ℚ` body, in source order."""
    degs = []
    for m in TERM.finditer(body):
        k = m.group(3)
        degs.append(int(k) if k else (1 if m.group(2) else 0))
    return degs


def scan(paths):
    """Every rewritable bridge, as (path, line index, name, lhs, coeffs, support)."""
    hits = []
    for p in paths:
        txt = open(p).read()
        if "= interpQ " not in txt:
            continue
        lines = txt.split("\n")
        defs = {}
        for l in lines:
            m = DEF.match(l)
            if m:
                defs[m.group(1)] = m.group(2)
        for i, l in enumerate(lines):
            m = HEAD.match(l)
            if not m or m.group("den") != "1":
                continue
            coeffs = [c.strip() for c in m.group("coeffs").split(",") if c.strip()]
            if not coeffs:
                continue
            body = defs.get(m.group("lhs"))
            if body is None:
                continue
            sup = support_of(body)
            if not sup or len(set(sup)) != len(sup) or max(sup) >= len(coeffs):
                continue
            # the written-out body must agree with the list, zeros omitted
            dense = ["0"] * len(coeffs)
            for d, mt in zip(sup, TERM.finditer(body)):
                dense[d] = mt.group(1)
            if dense != coeffs:
                continue
            hits.append((p, i, m.group("name"), m.group("lhs"), coeffs, sup))
    return hits


def pattern_names(hits):
    """Deterministic lemma name per (length, sorted support)."""
    pats = sorted({(len(c), tuple(sorted(s))) for _, _, _, _, c, s in hits})
    return {p: f"interpQ_expand_{p[0]}_{i}" for i, p in enumerate(pats)}


def wrap(parts, indent):
    out, cur = [], ""
    for t in parts:
        if cur and len(cur) + len(t) + 3 > 70:
            out.append(cur)
            cur = t
        else:
            cur = t if not cur else cur + " + " + t
    out.append(cur)
    return (" +\n" + indent).join(out)


def emit_lemmas(hits):
    names = pattern_names(hits)
    blocks = []
    for (n, sup), lemma in sorted(names.items(), key=lambda kv: kv[1]):
        binders = " ".join(f"(a{d} : ℤ)" for d in sup)
        terms = []
        for d in sup:
            if d == 0:
                terms.append(f"C ((a{d} : ℚ))")
            elif d == 1:
                terms.append(f"C ((a{d} : ℚ)) * X")
            else:
                terms.append(f"C ((a{d} : ℚ)) * X ^ {d}")
        lst = ", ".join(f"a{i}" if i in sup else "0" for i in range(n))
        blocks.append(
            f"public theorem {lemma} {binders} :\n"
            f"    {wrap(terms, '      ')} =\n"
            f"      interpQ 1 [{lst}] := by\n"
            f"  simp [interpQ, toPolyZ]\n"
            f"  try grind\n"
        )
    header = f'''/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.D12PolyZReflection

/-!
# Dense-expansion bridges for `interpQ`

GENERATED by `scripts/interpq_expand_rewrite.py --emit-lemmas`; do not edit.

The generated Segre certificates state {len(hits)} times that a `Polynomial ℚ`
written out term by term equals `interpQ 1 [..]`, and each proof re-derived it
with `Polynomial.funext` + a full-width `simp` + `ring` — ~15,000 `Expr` nodes
per polynomial, which is 89% of an HM module and 73% of a VQ module.  These
lemmas prove the expansion once per (length, support) pattern, so each
generated proof becomes an application of its coefficients.  Measured on the
degree-18 dense case: 14,784 nodes -> 152.

The emitter omits terms whose coefficient is zero, so the pattern has to carry
the support, not just the degree; {len(pattern_names(hits))} patterns occur.
-/

noncomputable section

namespace {NS}

open Polynomial

'''
    open(LEMMA_FILE, "w").write(header + "\n".join(blocks) + f"\nend {NS}\n")
    return names


def statements(text):
    out, lines, i = [], text.split("\n"), 0
    while i < len(lines):
        if re.match(r"^(public )?(theorem|lemma) ", lines[i]):
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


def rewrite(hits, names):
    total, touched, skipped = 0, 0, 0
    byfile = {}
    for p, i, name, lhs, coeffs, sup in hits:
        byfile.setdefault(p, []).append((i, name, lhs, coeffs, sup))
    for p, items in sorted(byfile.items()):
        src = open(p).read()
        lines = src.split("\n")
        out, i, n = [], 0, len(lines)
        idx = {i0: rest for i0, *rest in items}
        while i < n:
            if i not in idx:
                out.append(lines[i])
                i += 1
                continue
            name, lhs, coeffs, sup = idx[i]
            m = HEAD.match(lines[i])
            j = i + 1
            body = []
            while j < n and lines[j].startswith(" "):
                body.append(lines[j])
                j += 1
            if m.group("by") is None:
                # already converted
                out.append(lines[i])
                out.extend(body)
                i = j
                continue
            ok = (
                len(body) >= 3
                and body[0] == "  refine Polynomial.funext fun r => ?_"
                and body[1].startswith("  simp [")
                and body[-1] == "  try ring"
                and all(b.startswith("    ") for b in body[2:-1])
            )
            if not ok:
                skipped += 1
                out.append(lines[i])
                out.extend(body)
                i = j
                continue
            args = " ".join(
                (coeffs[d] if not coeffs[d].startswith("-") else f"({coeffs[d]})")
                for d in sup
            )
            lemma = names[(len(coeffs), tuple(sorted(sup)))]
            out.append(
                f"theorem {name} : {lhs} = interpQ 1 [{', '.join(coeffs)}] :="
            )
            out.append(f"  {NS}.{lemma} {args}")
            total += 1
            i = j
        dst = "\n".join(out)
        if EXPAND_IMPORT not in dst and total:
            mm = list(re.finditer(r"^(public )?import V14Formalization\.\S+$", dst, re.M))
            if mm:
                last = mm[-1]
                pre = "public import " if last.group(1) else "import "
                dst = dst[: last.end()] + "\n" + pre + EXPAND_IMPORT + dst[last.end():]
        if statements(src) != statements(dst):
            raise SystemExit(f"{p}: STATEMENT CHANGED")
        if dst != src:
            open(p, "w").write(dst)
            touched += 1
    return total, touched, skipped


def main(argv):
    paths = sorted(glob.glob(os.path.join(ROOT, "V14Formalization", "*.lean")))
    paths = [p for p in paths if not p.endswith("D12PolyZExpand.lean")]
    hits = scan(paths)
    if "--emit-lemmas" in argv:
        names = emit_lemmas(hits)
        print(f"bridges found: {len(hits)}; patterns emitted: {len(names)}")
        return
    names = pattern_names(hits)
    total, touched, skipped = rewrite(hits, names)
    print(f"rewritten: {total}; files touched: {touched}; unexpected proof shapes skipped: {skipped}")


if __name__ == "__main__":
    main(sys.argv)
