#!/usr/bin/env python3
"""Check that ProjectiveGVariety is a Mathlib scheme, not a point-set fake."""

from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
pgv = (ROOT / "V14Formalization/ProjectiveGVariety.lean").read_text()
defs = (ROOT / "V14Formalization/Definitions.lean").read_text()
head = (ROOT / "V14Formalization/FaithfulHeadline.lean").read_text()
proj = (ROOT / "V14Formalization/SchemeProjectiveAction.lean").read_text()

errors = []

def expect(cond, msg):
    if not cond:
        errors.append(msg)

expect("AlgebraicGeometry.Scheme" in pgv or "abbrev toScheme" in pgv and "Scheme :=" in pgv,
       "ProjectiveGVariety.toScheme must be a Scheme")
expect("action.V.left" in pgv, "toScheme must be the Action scheme")
expect("ProjectiveSpace" in pgv and "IsClosedImmersion" in pgv,
       "must be a closed subscheme of ProjectiveSpace")
expect("Action (Over (Spec (.of k))) G" in pgv,
       "G-action must live in Over (Spec k)")
expect("SchemeGeometry.HasEquivariantRationalMap" in pgv,
       "maps must be the scheme RationalMap notion")

expect("embed : X ↪ ℙ k ambient" in defs,
       "old SmoothProjectiveGVariety is still the point-set model")
expect("GEquivariantMorphism" in defs and "toFun : X.X → Y.X" in defs,
       "old morphisms are total point-maps")
expect("does **not** carry a Mathlib `AlgebraicGeometry.Scheme`" in defs
       or "does **not** carry a Mathlib" in defs,
       "old definition must warn it is not a Scheme")

expect("noEquivariantRationalMap_projectiveGVariety" in head,
       "headline must be restated on ProjectiveGVariety")
expect("ProjectiveGVariety.ofFaithfulRep" in head and "ProjectiveGVariety.v14" in head,
       "headline must compare ofFaithfulRep to v14")
expect("PlusMinusCoords.ofRep" in head and "exists_plus_minus_projective_bases" in head,
       "bases must be chosen internally from nondegeneracy")
expect("not_degenerates" in head,
       "nondegeneracy must be derived, not assumed on the public type")

# Public headlines take only a faithful representation (no Basis binders).
for thm in ("noEquivariantRationalMap_from_ambient",
            "noEquivariantRationalMap_projectiveGVariety"):
    m = re.search(
        rf"theorem {thm}\b(.*?):=\s",
        head, re.S)
    expect(m is not None, f"missing theorem {thm}")
    if m:
        sig = m.group(1)
        expect("Basis" not in sig,
               f"public {thm} must not take eigenspace bases")
        expect("DegeneratesToPlusMinusId" not in sig,
               f"public {thm} must not assume nondegeneracy")
        expect("(p q : ℕ)" not in sig and "(p q : Nat)" not in sig,
               f"public {thm} must not take dimension parameters p/q")
        expect("constancy" not in sig.lower()
               and "dominance" not in sig.lower()
               and "certificate" not in sig.lower(),
               f"public {thm} must not take leftover proof hypotheses")
        expect("FaithfulLinearRep" in sig, f"public {thm} must take a representation")
        expect("HasEquivariantRationalMap" in sig,
               f"public {thm} must deny an equivariant rational map")

# Chart path: nondegeneracy → existence → numbered plus/minus ambient.
ofrep = re.search(
    r"def PlusMinusCoords\.ofRep\b.*?:=\n(?:.*\n){0,8}",
    head, re.S)
expect(ofrep is not None, "missing PlusMinusCoords.ofRep")
if ofrep:
    body = ofrep.group(0)
    expect("exists_plus_minus_projective_bases" in body,
           "ofRep must choose bases from exists_plus_minus_projective_bases")
    expect("not_degenerates" in body,
           "ofRep must use proved nondegeneracy, not assume it")

expect("abbrev ambientOf" in head and "ambientFor" in head
       and "plusMinusAmbientBasis" in head,
       "source must be the existing numbered plus/minus ambient")
expect("ofLinearRep" in head and "plusMinusAmbientBasis" in head,
       "ofFaithfulRep must be numbered Proj via plusMinusAmbientBasis")
expect("homogeneousSubmodule" not in head
       and "Sym (" not in head and "symmetricAlgebra" not in head,
       "must not invent a basis-free Proj of V")

pub = re.search(
    r"theorem noEquivariantRationalMap_from_ambient\b.*?:=\n(?:.*\n){0,4}",
    head, re.S)
expect(pub is not None, "missing public ambient theorem body")
if pub:
    expect("PlusMinusCoords.ofRep" in pub.group(0),
           "public proof must choose coordinates internally")
    expect("noEquivariantRationalMap_from_ambient_of_plusMinusBases" in pub.group(0),
           "public proof must reuse the numbered-chart lemma")

eqv = (ROOT / "V14Formalization/SchemeEquivariant.lean").read_text()
expect("def HasEquivariantRationalMap" in eqv
       and "EquivariantRationalMap" in eqv
       and "Scheme.RationalMap" in eqv,
       "HasEquivariantRationalMap must remain the Scheme.RationalMap notion")

# ProjectiveSpace is Mathlib Proj
space = (ROOT.parent.parent / "B-conic-bundle-multisections" /
         "BConicBundleMultisections/ProjectiveSpace.lean")
if not space.exists():
    space = Path("/Users/worker/unirational/problems/B-conic-bundle-multisections/"
                 "BConicBundleMultisections/ProjectiveSpace.lean")
if space.exists():
    txt = space.read_text()
    expect("Proj (MvPolynomial.homogeneousSubmodule" in txt,
           "ProjectiveSpace must be Mathlib Proj")
else:
    errors.append(f"missing ProjectiveSpace.lean at {space}")

check_lean = ROOT / "scripts/check_headline.lean"
expect(check_lean.is_file(), "missing scripts/check_headline.lean")
if check_lean.is_file():
    src = check_lean.read_text()
    expect("import V14Formalization.FaithfulHeadline" in src,
           "Lean driver must import the shipped headline module")
    expect("#check @noEquivariantRationalMap_from_ambient" in src,
           "Lean driver must #check the public ambient theorem")
    expect("#check @noEquivariantRationalMap_projectiveGVariety" in src,
           "Lean driver must #check the ProjectiveGVariety packaging")

# When LEAN_PATH is set (overlay typecheck), drive the real Lean type.
import os
import subprocess
if os.environ.get("LEAN_PATH") and check_lean.is_file() and not errors:
    proc = subprocess.run(
        ["lean", str(check_lean)],
        cwd=ROOT, text=True, capture_output=True)
    out = (proc.stdout or "") + (proc.stderr or "")
    if proc.returncode != 0:
        errors.append("lean scripts/check_headline.lean failed:\n" + out[-4000:])
    else:
        expect("Basis" not in out, "Lean #check type must not mention Basis")
        expect("DegeneratesToPlusMinusId" not in out,
               "Lean #check type must not mention DegeneratesToPlusMinusId")
        expect("HasEquivariantRationalMap" in out,
               "Lean #check must print HasEquivariantRationalMap")
        expect("propext" in out and "Classical.choice" in out and "Quot.sound" in out,
               "Lean #print axioms must report the three standard axioms")
        axioms = set()
        blob = " ".join(out.split())
        for chunk in blob.split("depends on axioms:")[1:]:
            if "[" not in chunk:
                continue
            inside = chunk.split("[", 1)[1].split("]", 1)[0]
            axioms.update(part.strip() for part in inside.split(",") if part.strip())
        if axioms:
            expect(axioms <= {"propext", "Classical.choice", "Quot.sound"},
                   f"unexpected axioms: {sorted(axioms)}")

if errors:
    print("FAIL")
    for e in errors:
        print(" -", e)
    sys.exit(1)
print("OK: ProjectiveGVariety is a Mathlib closed subscheme of Proj with a G-action")
print("OK: SmoothProjectiveGVariety remains the linear-algebra point model")
print("OK: headline is stated for ProjectiveGVariety.ofFaithfulRep → v14")
print("OK: public type is a faithful representation alone")
