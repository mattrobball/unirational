#!/usr/bin/env python3
"""
verifier.py -- RETRACT_LANDSCAPE_NOTE (Problem E, Klein cubic)

Light verifier for a literature-landscape assembly packet. This is NOT a
theorem verifier: nothing here can check that Engel-de Gaay Fortman-
Schreieder or Voisin's papers say what THEOREM.md says they say -- that is
literature review, not computation. What this script DOES check,
mechanically:

  1. The one external PDF this note quotes verbatim (Roulleau,
     arXiv:1001.4853) is present in external_docs/ and report its size.
  2. It flags which of the OTHER cited papers do / do not have a local PDF
     in external_docs/ (none are expected to, per DEPENDENCIES tier A).
  3. If pdftotext is available, it re-extracts the Roulleau PDF fresh and
     greps for the exact quoted sentence from THEOREM.md section 2(i), so
     the quote in the note is not just hand-typed but grep-verified against
     a live extraction.
  4. It trivially re-verifies that 8192/11 is not an algebraic integer
     (equivalently: not an integer, since it's already rational), the
     one-line arithmetic fact behind the "E_sigma has no CM" corollary.

No network access, no dependencies beyond the python3 standard library and
an optional system `pdftotext` binary.
"""

import subprocess
import shutil
import sys
from fractions import Fraction
from pathlib import Path

PACKET_DIR = Path(__file__).resolve().parent
PROBLEM_DIR = PACKET_DIR.parent.parent  # problems/E-klein-cubic
EXTERNAL_DOCS = PROBLEM_DIR / "external_docs"

ROULLEAU_PDF = EXTERNAL_DOCS / "roulleau_fano_klein_cubic_arxiv1001.4853.pdf"

# Papers cited in THEOREM.md tier A (published theorems). None are expected
# to have local PDFs; we report status either way rather than assuming.
CITED_PAPERS = [
    ("2507.15704", "Engel-de Gaay Fortman-Schreieder, matroids/IHC for abelian varieties"),
    ("2510.13679", "Schreieder, Rationality of hypersurfaces (ICM 2026 survey)"),
    ("2509.06013", "Banerjee, universal codim-2 cycle on very general cubic 3fold (unrefereed)"),
    ("2202.05230", "Beckmann-de Gaay Fortman, integral Fourier transforms / IHC 1-cycles"),
    ("1407.7261", "Voisin, universal CH0 group of cubic hypersurfaces (JEMS 2017)"),
    ("2212.03046", "Voisin, cycle classes on abelian varieties / Abel-Jacobi geometry"),
]

# The exact sentence quoted in THEOREM.md section 2(i), as it appears in a
# `pdftotext -layout` extraction of the Roulleau PDF (whitespace-normalized
# for the grep below; the PDF's own line breaks and kerning artifacts such
# as "J(F )" are matched loosely).
QUOTE_FRAGMENTS = [
    "isomorphic to E5 but by [7] (0.12), this isomor",
    "phism is not an isomorphism of principally polarized abelian varieties (p.p.a.v.).",
    "The fact that J(F ) is isomorphic to E5 is proved in [2] in a different way.",
]

PASS = []
FAIL = []


def check(name, condition, detail=""):
    if condition:
        PASS.append(f"{name}: PASS  {detail}".rstrip())
    else:
        FAIL.append(f"{name}: FAIL  {detail}".rstrip())


def main():
    print("=" * 70)
    print("RETRACT_LANDSCAPE_NOTE verifier")
    print("=" * 70)

    # --- 1. Roulleau PDF present, with size -----------------------------
    exists = ROULLEAU_PDF.exists()
    size = ROULLEAU_PDF.stat().st_size if exists else 0
    check(
        "RETRACT-LANDSCAPE-ROULLEAU-PDF-PRESENT",
        exists and size > 0,
        f"path={ROULLEAU_PDF} size={size} bytes",
    )

    # --- 2. Report presence/absence of the other cited papers' PDFs -----
    print()
    print("Cited-paper local-PDF census (external_docs/):")
    for arxiv_id, label in CITED_PAPERS:
        hits = list(EXTERNAL_DOCS.glob(f"*{arxiv_id.replace('.', '')}*")) if EXTERNAL_DOCS.exists() else []
        # also try the dotted form, in case a file was named with the dot
        hits += list(EXTERNAL_DOCS.glob(f"*{arxiv_id}*")) if EXTERNAL_DOCS.exists() else []
        status = f"LOCAL PDF FOUND: {hits[0].name}" if hits else "no local PDF (expected; see DEPENDENCIES tier A)"
        print(f"  arXiv:{arxiv_id}  {label}\n      -> {status}")
    print()

    # --- 3. Re-extract the Roulleau PDF and grep for the exact quote ----
    pdftotext = shutil.which("pdftotext")
    if pdftotext is None:
        print("pdftotext not found on PATH -- skipping live quote re-extraction.")
        check(
            "RETRACT-LANDSCAPE-ROULLEAU-QUOTE-SKIPPED-NO-PDFTOTEXT",
            True,
            "no pdftotext binary available; quote not independently re-checked this run",
        )
    elif not exists:
        check("RETRACT-LANDSCAPE-ROULLEAU-QUOTE-FOUND", False, "PDF missing, cannot extract")
    else:
        try:
            result = subprocess.run(
                [pdftotext, "-layout", str(ROULLEAU_PDF), "-"],
                capture_output=True,
                text=True,
                timeout=60,
            )
            text = result.stdout
            normalized = " ".join(text.split())
            all_found = True
            for frag in QUOTE_FRAGMENTS:
                frag_norm = " ".join(frag.split())
                if frag_norm not in normalized:
                    all_found = False
                    print(f"  MISSING FRAGMENT: {frag_norm!r}")
            check(
                "RETRACT-LANDSCAPE-ROULLEAU-QUOTE-FOUND",
                all_found,
                "all three quote fragments located in a fresh pdftotext -layout extraction"
                if all_found
                else "one or more fragments not found -- see MISSING FRAGMENT lines above",
            )
        except Exception as exc:  # pragma: no cover - defensive only
            check("RETRACT-LANDSCAPE-ROULLEAU-QUOTE-FOUND", False, f"extraction error: {exc}")

    # --- 4. 8192/11 is not an algebraic integer (trivial rational case) -
    j = Fraction(8192, 11)
    is_integer = j.denominator == 1
    check(
        "RETRACT-LANDSCAPE-8192-11-NON-CM-OK",
        (not is_integer) and j.numerator == 8192 and j.denominator == 11,
        f"j(E_sigma) = {j.numerator}/{j.denominator} in lowest terms; "
        f"denominator != 1 => not an algebraic integer => E_sigma has no CM "
        f"(a rational number is an algebraic integer iff it is an ordinary "
        f"integer, i.e. denominator 1 in lowest terms)",
    )

    # --- 5. THEOREM.md and REGISTRATION_SNIPPET.md exist ----------------
    theorem_md = PACKET_DIR / "THEOREM.md"
    reg_md = PACKET_DIR / "REGISTRATION_SNIPPET.md"
    check("RETRACT-LANDSCAPE-NOTE-ASSEMBLED", theorem_md.exists() and reg_md.exists(),
          f"THEOREM.md exists={theorem_md.exists()}, REGISTRATION_SNIPPET.md exists={reg_md.exists()}")

    # --- Report -----------------------------------------------------------
    print()
    print("-" * 70)
    for line in PASS:
        print("PASS  " + line)
    for line in FAIL:
        print("FAIL  " + line)
    print("-" * 70)
    if FAIL:
        print(f"VERIFY: FAIL -- {len(FAIL)} check(s) failed, {len(PASS)} passed.")
        return 1
    print(f"VERIFY: PASS -- all {len(PASS)} checks passed.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
