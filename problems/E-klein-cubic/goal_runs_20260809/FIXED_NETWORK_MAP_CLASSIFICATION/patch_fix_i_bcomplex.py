#!/usr/bin/env python3
"""Apply the binding 2026-08-09 correction to theory/FIX_I_bcomplex.md.

The script is idempotent and fails if any expected source anchor has drifted.
It repairs only the arbitrary-model RCC/funnel overreach; the per-blowup
character calculation and graph functoriality are retained.
"""

from __future__ import annotations

from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[3]
PATH = ROOT / "theory" / "FIX_I_bcomplex.md"
MARKER = "FIX-I-BINDING-CORRECTION-20260809"


def replace_once(text: str, old: str, new: str, label: str) -> str:
    count = text.count(old)
    if count != 1:
        raise RuntimeError(f"{label}: expected one source block, found {count}")
    return text.replace(old, new, 1)


def main() -> None:
    text = PATH.read_text()
    if MARKER in text:
        print("FIX_I_BCOMPLEX_ALREADY_PATCHED")
        return

    status = (
        "Author: director (Fable). Status: DRAFT-FOR-DERIVATION — every statement here\n"
        "is to be treated as claimed-until-derived-or-checked; the acceptance tests\n"
        "T1–T5 in §6 are the validation gate. No claim in this note is consumable for\n"
        "headline routing until the gate passes.\n"
    )
    correction = status + """
> **Binding correction — 2026-08-09 (`FIX-I-BINDING-CORRECTION-20260809`).**
> The per-blowup character calculation in Theorem 2.1 and graph
> functoriality in Theorem 4.1 remain valid. The every-model conclusion
> formerly attached to Lemma 4.3 and the arbitrary-resolved-graph Klein
> funnel formerly stated as Corollary 5.2 are withdrawn. A legal smooth
> equivariant center can have positive-genus fixed part, and a type-I or
> type-II blowup in dimension three creates an exceptional `P^2` with
> disconnected subgroup-fixed loci and rational bypass lines. The corrected
> scope is stated below and in
> `goal_runs_20260809/FIXED_NETWORK_MAP_CLASSIFICATION/RESOLUTION_CATEGORY.md`.
"""
    text = replace_once(text, status, correction, "status correction")

    lemma_pattern = re.compile(
        r"\*\*Lemma 4\.3 \(RCC propagation through the calculus\)\.\*\*.*?"
        r"\n\n\*\*Corollary 4\.4",
        re.S,
    )
    lemma_replacement = """**Lemma 4.3 (RCC propagation along a controlled tower).** In Theorem 2.1,
every exceptional stratum `P(N^χ)` is a projectivized bundle over `F_Z`,
hence RCC whenever `F_Z` is; strict transforms preserve `δ_bir`.
Consequently RCC propagates along a chosen equivariant blowup tower
**provided every fixed component of every center used in that tower is
RCC**. It does not follow that every fixed stratum on every equivariant
model is RCC. A later smooth invariant center may have fixed part of
arbitrary genus; see Correction I-C and the binding correction at the head
of this note.

**Corollary 4.4"""
    text, count = lemma_pattern.subn(lemma_replacement, text, count=1)
    if count != 1:
        raise RuntimeError(f"Lemma 4.3: replacement count {count}")

    old_scope = (
        "Cor 4.4/5.2 hold on the\n"
        "> stabilizer-stratified cofinal class (which suffices for every use made\n"
        "> of them in T1/T2, whose towers blow up orbit-strata only);"
    )
    new_scope = (
        "Cor 4.4 holds on the\n"
        "> stabilizer-stratified towers used in T1/T2 (these towers are **not** a\n"
        "> cofinal class of arbitrary equivariant models); the former Cor 5.2 is\n"
        "> withdrawn for actual graph resolutions;"
    )
    text = replace_once(text, old_scope, new_scope, "Correction I-C scope")

    old_boundary = """1. **The escape is real (no cheap Klein contradiction).** Modulo the FIX-A0
   verification: for an involution `σ` (class 2A, 55 of them; `χ_W(2A) = 1`
   forces the `(3,2)` eigensplit), `X^σ = E_t ⊔ L_t` — a plane cubic and a
   line, with the derived normal types both `(−1)^{⊕2}` in `X`. Corollary
   4.4 then funnels the entire source complex into the **55-line/point
   arrangement**: the elliptic curves `E_t` receive only points. But the
   lines are rational, so line-valued images are permitted — and Fable's
   A4-trisection ([E15]) realizes them. The obstruction content therefore
   cannot be local-constancy; it must be global compatibility over the
   arrangement (Note III's cosheaf `H⁰`)."""
    new_boundary = """1. **The escape is real (no cheap Klein contradiction).** For an involution
   `σ`, `X^σ = E_t ⊔ L_t` is a plane cubic and a line. RCC strata on a
   chosen stabilizer-stratified source tower map only to points of `E_t`,
   while line-valued images are permitted. This does **not** funnel the
   fixed strata of an arbitrary resolved graph away from `E_t`: legal
   centers can create positive-genus fixed carriers, and the actual landing
   ideal can create exceptional horizontal carriers over the forced
   plus-plane base. Any Klein obstruction must therefore classify those
   carriers and their global compatibility, not invoke local RCC for the
   entire b-complex."""
    text = replace_once(text, old_boundary, new_boundary, "Klein boundary")

    cor_pattern = re.compile(
        r"\*\*Corollary 5\.2 \(Klein funnel, conditional on FIX-A0/A1\)\.\*\*.*?"
        r"\n\n## 6\. Acceptance tests",
        re.S,
    )
    cor_replacement = """**Withdrawn Corollary 5.2 (arbitrary-model Klein funnel).** The former
statement quantified over every fixed stratum of every model and is false.
The exact replacement is conditional:

> On a specified stabilizer-stratified tower whose center-fixed components
> are RCC, each RCC fixed stratum maps to a point of an elliptic target
> component or to an RCC subvariety of a rational target component.

This conditional statement does not classify the fixed components of an
actual principalization of a landing base ideal and supplies no finite
fixed-network theorem. In dimension three the first blowup of a `V4` type-I
or type-II point has exceptional `P^2`; its involution-fixed lines can map
to the rational target lines, its `V4` fixed locus is disconnected, and it
contains rational curves with faithful `V4` action. The missing replacement
is a refinement-invariant normalized-Rees carrier theorem.

## 6. Acceptance tests"""
    text, count = cor_pattern.subn(cor_replacement, text, count=1)
    if count != 1:
        raise RuntimeError(f"Corollary 5.2: replacement count {count}")

    PATH.write_text(text)
    print("FIX_I_BCOMPLEX_PATCH_OK")


if __name__ == "__main__":
    main()
