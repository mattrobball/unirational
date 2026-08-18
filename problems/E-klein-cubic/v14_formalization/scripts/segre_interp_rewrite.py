#!/usr/bin/env python3
"""Integer-reflection post-pass for the Segre `Det` and `SmoothC{U,V,W}` families.

Those families prove polynomial identities the expensive way — `Polynomial.funext`,
a full-width eval `simp`, then `grind` — which inlines the whole normalisation
trace into the proof term.  `V14Formalization/D12PolyZReflection.lean` carries
the alternative: a polynomial is `interpQ d [n...]`, products fold to an
unevaluated `convList`, and `interp_eq` reduces the goal to a `List Int`
all-zero test the kernel runs for free.  See MODULE_MIGRATION.md,
"The integer reflection, applied everywhere".

Neither family has an emitter in `scripts/`, so this is a post-pass in the shape
of `scripts/interp_simp_arg_rewrite.py`.  It is strict and idempotent, and it
refuses to write if a theorem statement line would change.

Three modes:

  --tables   convert a coefficient table (`BezoutData`, `Partials`): the
             `public def X : Polynomial ℚ := C (..) + ..` bodies and the
             matching `public theorem X_def` statements both become
             `interpQ d [n...]`.  The `_def` proof stays `rfl`.
  --certs    convert a certificate family (`Det*`, `SmoothC*`): the file-local
             `def`s become `interpQ D [n...]` over one denominator per file, and
             every `Polynomial.funext` + eval-`simp` + `grind` proof becomes
             fold-and-`decide`.
  --emit-fplus-bridge PATH
             write the shared module holding `z_Fplus_{re,im}_*` and
             `phi11_interpQ`, read off `D12SigmaPlusSegreCore`.

Safety.  Every polynomial body is parsed to exact `Fraction` coefficients and
re-rendered; the pass aborts unless the re-render is byte-identical to the text
it replaced, so a body it did not fully understand can never be rewritten.  The
`interpQ` form it emits is checked to represent the same rationals.

    python3 scripts/segre_interp_rewrite.py --certs [--check] FILE...
"""

from __future__ import annotations

import argparse
import re
import sys
from fractions import Fraction
from math import lcm
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CORE = ROOT / "V14Formalization" / "D12SigmaPlusSegreCore.lean"

REFLECT_IMPORT = "public import V14Formalization.D12PolyZReflection"
REFLECT_OPEN = "open V14Formalization.D12PolyZReflection"

# Which module publishes each `interpQ` equation a rewritten proof reaches for.
BRIDGE_MODULE = {
    "z_N": "V14Formalization.D12SigmaPlusSegreApplyN",
    "z_Fplus": "V14Formalization.D12SigmaPlusSegreFplusZ",
    "phi11_interpQ": "V14Formalization.D12SigmaPlusSegreFplusZ",
}

FOLD_SIMP = [
    "  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,",
    "    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,",
    "    interp_sub_gen, Nat.reduceMul]",
    "  apply interp_eq",
    "  · decide",
    "  · decide",
    "  · decide",
]

_DECL_HEAD = re.compile(
    r"^\s*(?:@\[[^\]]*\]\s*)?(?:public\s+|private\s+|protected\s+)?"
    r"(?:noncomputable\s+)?(theorem|lemma|def|abbrev|instance|structure)\s+"
    r"([A-Za-z_][A-Za-z0-9_']*)")

_POLY_DEF = re.compile(
    r"^((?:@\[expose\]\s+)?(?:public\s+)?def\s+([A-Za-z_][A-Za-z0-9_']*)"
    r"\s*:\s*Polynomial ℚ\s*:=\s*)(.*)$")

_DEF_THM = re.compile(
    r"^((?:public\s+)?theorem\s+([A-Za-z_][A-Za-z0-9_']*)_def\s*:\s*"
    r"\2\s*=\s*)(.*?)( := by)$")


# ---------------------------------------------------------------- polynomials

def _rat(text: str) -> Fraction | None:
    text = text.strip()
    m = re.fullmatch(r"\((-?\d+) / (\d+) : ℚ\)", text)
    if m:
        return Fraction(int(m.group(1)), int(m.group(2)))
    if re.fullmatch(r"-?\d+", text):
        return Fraction(int(text))
    return None


def parse_poly(body: str) -> dict[int, Fraction] | None:
    """`C (a) + C (b) * X + C (c) * X ^ k` -> {degree: coefficient}."""
    body = body.strip()
    if body == "(0 : Polynomial ℚ)":
        return {}
    coeffs: dict[int, Fraction] = {}
    for term in body.split(" + "):
        term = term.strip()
        m = re.fullmatch(r"C \((.*)\)", term)
        deg = 0
        if not m:
            m = re.fullmatch(r"C \((.*)\) \* X", term)
            deg = 1
        if not m:
            m = re.fullmatch(r"C \((.*)\) \* X \^ (\d+)", term)
            if m:
                deg = int(m.group(2))
        if not m:
            return None
        c = _rat(m.group(1))
        if c is None or deg in coeffs:
            return None
        coeffs[deg] = c
    return coeffs


def lean_rat(x: Fraction) -> str:
    if x.denominator == 1:
        return str(x.numerator)
    return f"({x.numerator} / {x.denominator} : ℚ)"


def render_poly(coeffs: dict[int, Fraction]) -> str:
    terms = []
    for i in sorted(coeffs):
        c = coeffs[i]
        if i == 0:
            terms.append(f"C ({lean_rat(c)})")
        elif i == 1:
            terms.append(f"C ({lean_rat(c)}) * X")
        else:
            terms.append(f"C ({lean_rat(c)}) * X ^ {i}")
    return " + ".join(terms) if terms else "(0 : Polynomial ℚ)"


def denom(coeffs: dict[int, Fraction]) -> int:
    d = 1
    for c in coeffs.values():
        d = lcm(d, c.denominator)
    return d


def render_interp(coeffs: dict[int, Fraction], d: int) -> str:
    if not coeffs:
        return "interpQ 1 []"
    ns = []
    for i in range(max(coeffs) + 1):
        c = coeffs.get(i, Fraction(0))
        n = c * d
        assert n.denominator == 1, "denominator does not clear"
        ns.append(int(n))
    while ns and ns[-1] == 0:
        ns.pop()
    return f"interpQ {d} [" + ", ".join(str(n) for n in ns) + "]"


def parse_interp(body: str) -> tuple[int, list[int]] | None:
    m = re.fullmatch(r"interpQ (\d+) \[(.*)\]", body.strip())
    if not m:
        return None
    d = int(m.group(1))
    inner = m.group(2).strip()
    ns = [int(x) for x in inner.split(", ")] if inner else []
    return d, ns


# ------------------------------------------------------------------- bridging

def bridge_name(name: str) -> str | None:
    """Map a name whose body is still `C (..) + ..` to its `interpQ` equation."""
    if name.endswith("_def"):
        return name
    if re.fullmatch(r"N_(re|im)_\d+_\d+", name):
        return "z_" + name
    if re.fullmatch(r"Fplus_(re|im)_\d+", name):
        return "z_" + name
    return None


# ------------------------------------------------------------------ structure

def statement_lines(text: str) -> list[str]:
    """Theorem signature lines — everything a rewrite must leave alone."""
    keep: list[str] = []
    lines = text.split("\n")
    i = 0
    while i < len(lines):
        m = _DECL_HEAD.match(lines[i])
        if m and m.group(1) in ("theorem", "lemma"):
            while i < len(lines):
                keep.append(lines[i])
                if ":=" in lines[i]:
                    break
                i += 1
        i += 1
    return keep


def blocks(lines: list[str]) -> list[tuple[int, int]]:
    """(start, end) index pairs, one per top-level declaration."""
    heads = [i for i, l in enumerate(lines) if _DECL_HEAD.match(l)]
    out = []
    for k, i in enumerate(heads):
        j = heads[k + 1] if k + 1 < len(heads) else len(lines)
        out.append((i, j))
    return out


# -------------------------------------------------------------- table rewrite

def rewrite_table(text: str) -> str:
    lines = text.split("\n")
    coeffs: dict[str, dict[int, Fraction]] = {}
    dens: dict[str, int] = {}
    out: list[str] = []
    for line in lines:
        m = _POLY_DEF.match(line)
        if m and parse_interp(m.group(3)) is None:
            c = parse_poly(m.group(3))
            if c is None or render_poly(c) != m.group(3).strip():
                out.append(line)
                continue
            name = m.group(2)
            coeffs[name] = c
            dens[name] = denom(c)
            out.append(m.group(1) + render_interp(c, dens[name]))
            continue
        if m:
            d, ns = parse_interp(m.group(3))
            coeffs[m.group(2)] = {i: Fraction(n, d) for i, n in enumerate(ns) if n}
            dens[m.group(2)] = d
        out.append(line)

    final: list[str] = []
    for line in out:
        m = _DEF_THM.match(line)
        if m and m.group(2) in coeffs:
            name = m.group(2)
            final.append(m.group(1) + render_interp(coeffs[name], dens[name])
                         + m.group(4))
            continue
        final.append(line)
    return add_reflection_header("\n".join(final), [])


# --------------------------------------------------------------- cert rewrite

_FUNEXT = "  refine Polynomial.funext fun r => ?_"
_PHI_EXPAND = "  rw [Phi11_expand]"


def rewrite_certs(text: str, path: Path) -> str:
    lines = text.split("\n")

    # 1. file-local polynomial defs -> one common denominator
    local: dict[str, dict[int, Fraction]] = {}
    for line in lines:
        m = _POLY_DEF.match(line)
        if not m:
            continue
        if parse_interp(m.group(3)) is not None:
            d, ns = parse_interp(m.group(3))
            local[m.group(2)] = {i: Fraction(n, d) for i, n in enumerate(ns) if n}
            continue
        c = parse_poly(m.group(3))
        if c is None or render_poly(c) != m.group(3).strip():
            continue
        local[m.group(2)] = c
    if not local:
        return text
    D = 1
    for c in local.values():
        D = lcm(D, denom(c))

    out: list[str] = []
    for line in lines:
        m = _POLY_DEF.match(line)
        if m and m.group(2) in local:
            out.append(m.group(1) + render_interp(local[m.group(2)], D))
        else:
            out.append(line)
    lines = out

    # 2. proofs
    spans = blocks(lines)
    out = list(lines[:spans[0][0]]) if spans else list(lines)
    used: set[str] = set()
    for (i, j) in spans:
        head = _DECL_HEAD.match(lines[i])
        body = lines[i:j]
        if head.group(1) not in ("theorem", "lemma"):
            out += body
            continue
        out += rewrite_proof(body, local, path, used)
    lines = out

    extra = set()
    for name in used:
        for prefix, module in BRIDGE_MODULE.items():
            if name == prefix or name.startswith(prefix + "_"):
                extra.add(module)
    return add_reflection_header("\n".join(lines), sorted(extra))


def rewrite_proof(body: list[str], local: dict, path: Path,
                  used: set[str]) -> list[str]:
    """Rewrite one `funext` + eval-`simp` + `grind` proof; else leave it."""
    try:
        k = body.index(_FUNEXT)
    except ValueError:
        return rewrite_bare_simp(body, local, path, used)
    sig, rest = body[:k], body[k + 1:]
    phi = False
    if rest and rest[0] == _PHI_EXPAND:
        phi = True
        rest = rest[1:]
    if not rest or not rest[0].startswith("  simp only ["):
        raise SystemExit(f"{path}: unexpected proof shape at {body[0][:60]!r}")
    # the `simp only [..]` list may wrap
    m = 0
    while "]" not in rest[m]:
        m += 1
    simp_only = " ".join(l.strip() for l in rest[:m + 1])
    rest = rest[m + 1:]
    names = re.fullmatch(r"simp only \[(.*)\]", simp_only)
    if not names:
        raise SystemExit(f"{path}: cannot read {simp_only!r}")
    args = [a.strip() for a in names.group(1).split(",")]
    # the eval simp + `try grind` that follows is what we are replacing
    while rest and rest[0].strip() and not rest[0].startswith("  try "):
        rest = rest[1:]
    if rest and rest[0].startswith("  try "):
        rest = rest[1:]
    if any(l.strip() for l in rest):
        raise SystemExit(f"{path}: trailing tactics after {body[0][:60]!r}")

    mapped = []
    for a in args:
        if a in local:
            mapped.append(a)
            continue
        b = bridge_name(a)
        if b is None:
            raise SystemExit(f"{path}: no interpQ bridge for {a!r}")
        mapped.append(b)

    proof: list[str] = []
    if phi:
        proof.append("  rw [phi11_interpQ]")
        used.add("phi11_interpQ")
    used.update(n for n in mapped if n.startswith("z_"))
    proof.append(wrap_simp_only(mapped))
    proof += FOLD_SIMP
    return sig + proof + rest


def rewrite_bare_simp(body: list[str], local: dict, path: Path,
                      used: set[str]) -> list[str]:
    """The degenerate certificates (`Det222`) are a lone `simp [defs]`.

    Their defs are now `interpQ`, so the eval `simp` no longer sees a Horner
    form to unfold; they take the same fold-and-`decide` route as the rest.
    Only a proof whose every `simp` argument is a reflected polynomial is
    touched, which leaves the `ofLadj` bookkeeping proofs alone.
    """
    tail = [i for i, l in enumerate(body) if l.startswith("  simp [")]
    if len(tail) != 1 or tail[0] != len(body) - 1 and any(
            l.strip() for l in body[tail[0] + 1:]):
        return body
    i = tail[0]
    names = re.fullmatch(r"simp \[(.*)\]", body[i].strip())
    if not names:
        return body
    args = [a.strip() for a in names.group(1).split(",")]
    mapped = []
    for a in args:
        if a in local:
            mapped.append(a)
            continue
        b = bridge_name(a)
        if b is None:
            return body
        mapped.append(b)
    sig = body[:i]
    proof: list[str] = []
    if any("Phi11" in l for l in sig):
        proof.append("  rw [phi11_interpQ]")
        used.add("phi11_interpQ")
    used.update(n for n in mapped if n.startswith("z_"))
    proof.append(wrap_simp_only(mapped))
    proof += FOLD_SIMP
    return sig + proof + body[i + 1:]


def wrap_simp_only(names: list[str]) -> str:
    return "  simp only [" + ", ".join(names) + "]"


# ---------------------------------------------------------------------- header

def add_reflection_header(text: str, extra_modules: list[str]) -> str:
    lines = text.split("\n")
    imports = [i for i, l in enumerate(lines) if l.startswith("public import ")]
    if not imports:
        raise SystemExit("no `public import` line to anchor")
    last = imports[-1]
    add = []
    if REFLECT_IMPORT not in lines:
        add.append(REFLECT_IMPORT)
    for module in extra_modules:
        line = f"public import {module}"
        if line not in lines:
            add.append(line)
    if add:
        lines[last + 1:last + 1] = add
    opens = [i for i, l in enumerate(lines) if l.startswith("open ")]
    if REFLECT_OPEN not in lines:
        lines.insert(opens[-1] + 1, REFLECT_OPEN)
    return "\n".join(lines)


# ------------------------------------------------------------- Fplus z-module

FPLUSZ_HEADER = """/-
Integer reflections of the determinantal cubic's coefficients.

GENERATED by `scripts/segre_interp_rewrite.py --emit-fplus-bridge`; do not edit.

`D12SigmaPlusSegreDet*` states its Phi11 remainders against `Fplus_{re,im}_*`,
whose bodies are still written out term by term.  Each equation below is proved
once here so those certificates can fold and `decide` instead of re-deriving
the expansion; `phi11_interpQ` is the same service for `Phi11` itself.
-/
module

public import V14Formalization.D12SigmaPlusSegreEval
public import V14Formalization.D12PolyZReflection

noncomputable section
open Matrix Polynomial
namespace V14Formalization.D12SigmaPlusSegreCore
open D12PolynomialData
open V14Formalization.D12PolyZReflection

public theorem phi11_interpQ :
    (Phi11 : Polynomial ℚ) = interpQ 1 [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1] := by
  rw [Phi11_expand]
  refine Polynomial.funext fun r => ?_
  simp [interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try grind
"""


def emit_fplus_bridge() -> str:
    text = CORE.read_text(encoding="utf8")
    out = [FPLUSZ_HEADER]
    found = 0
    for line in text.split("\n"):
        m = _POLY_DEF.match(line)
        if not m or not re.fullmatch(r"Fplus_(re|im)_\d+", m.group(2)):
            continue
        c = parse_poly(m.group(3))
        if c is None or render_poly(c) != m.group(3).strip():
            raise SystemExit(f"cannot parse {m.group(2)}")
        found += 1
        out.append(f"""
public theorem z_{m.group(2)} :
    {m.group(2)} = {render_interp(c, denom(c))} := by
  refine Polynomial.funext fun r => ?_
  simp [{m.group(2)}, interpQ, toPolyZ,
    Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X,
    Polynomial.eval_pow]
  try grind""")
    if found == 0:
        raise SystemExit("no Fplus coefficients found")
    out.append("\nend V14Formalization.D12SigmaPlusSegreCore\n")
    return "\n".join(out)


# ----------------------------------------------------------------------- main

def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--check", action="store_true")
    ap.add_argument("--tables", action="store_true")
    ap.add_argument("--certs", action="store_true")
    ap.add_argument("--emit-fplus-bridge", type=Path)
    ap.add_argument("files", nargs="*", type=Path)
    args = ap.parse_args()

    if args.emit_fplus_bridge:
        out = emit_fplus_bridge()
        if args.check:
            print(f"would write {args.emit_fplus_bridge}")
        else:
            args.emit_fplus_bridge.write_text(out, encoding="utf8")
            print(f"wrote {args.emit_fplus_bridge}")
        return 0

    rc = 0
    for path in args.files:
        old = path.read_text(encoding="utf8")
        new = rewrite_table(old) if args.tables else rewrite_certs(old, path)
        if statement_lines(old) != statement_lines(new) and not args.tables:
            print(f"REFUSED {path}: a statement line would change",
                  file=sys.stderr)
            rc = 1
            continue
        if old == new:
            print(f"unchanged {path}")
            continue
        if args.check:
            print(f"would rewrite {path}")
        else:
            path.write_text(new, encoding="utf8")
            print(f"rewrote {path}")
    return rc


if __name__ == "__main__":
    raise SystemExit(main())
