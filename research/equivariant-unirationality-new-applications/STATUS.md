# New applications of the fixed-locus obstruction machinery

**Search cutoff:** 2026-08-09  
**Packet:** `research/equivariant-unirationality-new-applications/`

## Executive verdict

This audit produces two new non-weak-versality theorems and one reusable strengthening of the repository obstruction.

```text
NEW-EQUIVARIANT-NONUNIRATIONALITY-THEOREM
FIXED-LOCUS-OBSTRUCTION-GENERALIZED
NEW-APPLICATIONS-TOP-CANDIDATES-CLASSIFIED
```

The new theorems are:

1. an infinite family of rational exceptional conic-bundle surfaces
   \[
   (S_g,G_g),\qquad G_g=D_{2g}\times C_2,\qquad g\ge3\text{ odd},
   \]
   where `D_{2g}` has order `2g`; every abelian subgroup has a fixed point, but `S_g` is not weakly `G_g`-versal;
2. the smooth quartic double solid branched over the unique primitive
   `PSL2(F7)`-invariant quartic, with
   \[
   G=(C_7\rtimes C_3)\times C_2^{\rm deck},
   \]
   which is classically unirational, satisfies Condition (A), has vanishing equivariant universal-torsor and all higher-Amitsur obstructions, but is not weakly `G`-versal.

The second theorem is the sharpest comparison with current obstruction theory: all presently available Amitsur-type invariants are silent, while the residual action on the deck-fixed K3 surface excludes every positive-dimensional stable RCC image.

## General theorem proved

`GENERALIZATIONS.md` proves the **residual-RCC centralizer obstruction**. For `N=C_G(σ)`, it replaces

> `Y^σ` contains no rational curve

by the strictly weaker condition

> every irreducible `N`-stable RCC subvariety of `Y^σ` is a point.

Together with `Y^N=∅`, this excludes every rational map from a faithful linear source and therefore excludes weak versality. The proof follows one controlled eigenspace survivor through an equivariant resolution; it does not use the withdrawn assertion that every fixed stratum on every model remains RCC.

## Ranked outcome

| rank | action | status after this packet | feasibility |
|---:|---|---|---:|
| 1 | smooth Klein-invariant quartic double solid, `(C7:C3)×C2deck` | **new theorem** | 100 |
| 2 | odd exceptional conic bundles, `D_{2g}×C2`, `g≥3` odd | **new infinite family** | 99 |
| 3 | rational genus-12 `V22=VSP(Klein quartic,6)`, `PSL2(F7)` | best remaining open target | 94 |
| 4 | rational Mori–Mukai No. 2.18 with Fermat discriminant and an explicit finite subgroup | finite threefold-network target | 78 |
| 5 | non-Q8 subgroup on the special Kummer quartic double solid | residual-curve audit target | 71 |

The improved third-place target is the rational `V22` of Cheltsov–Shramov. It is a smooth index-one Fano threefold of degree 22 with `PSL2(F7)`-action. The entire deformation family satisfies Condition (A), `Pic(V22)=Z[-K]`, the canonical generator is equivariantly linearized, and hence all higher Amitsur obstructions vanish. The literature search found no decision of its `G`-unirationality or weak versality. The finite missing calculation is

\[
V_{22}^{\sigma}
\quad\text{and}\quad
V_{22}^{C_G(\sigma)}=V_{22}^{D_8}
\]

for an involution `σ`.

## Answers to the eight required questions

1. **Additional degree-1/2 del Pezzo path cases?** No second verbatim Problem-F path application was found. The strongest degree-2 cases are already closed by Problem F, the repository central theorem, or nonzero third Amitsur groups. Degree-1 surfaces have a global anticanonical base point, so non-weak-versality needs a different, dominance-sensitive theorem.
2. **Rational conic-bundle surfaces passing Condition (A) but not `G`-unirational?** Yes: the family `(S_g,D_{2g}×C2)` proved here.
3. **Central fiber involutions on conic-bundle threefolds?** They naturally produce a discriminant-cover fixed surface. The residual-RCC theorem applies when that surface is non-uniruled and has no residual-stable rational curve. In Mori–Mukai No. 2.18 the fixed surface is rational, so a three-dimensional network theorem is required.
4. **Special rational Fano conic bundles with enlarged groups?** Yes: Abe's Fermat- and Klein-discriminant members of No. 2.18. The Fermat member is the best finite target.
5. **Kummer double solids?** Q8-containing actions are already detected by the third Amitsur group. A specific non-Q8 subgroup is isolated here, but its Condition-(A) and 32-curve residual permutation audits remain open.
6. **A second `V14`-type index-one phenomenon?** The best current candidate is the rational `V22` with `PSL2(F7)`; its involution/D8 fixed schemes are the exact missing data.
7. **Published silent-invariant examples still unresolved?** Yes: `V22` has Condition (A) and vanishing universal-torsor/higher-Amitsur obstructions, while no equivariant-unirationality decision was found. The Abe No. 2.18 special actions are additional partially audited cases.
8. **Best single remaining case?** `V22` with `PSL2(F7)`, because the variety is rational, the group/action are exact, Condition (A) is published, the cohomological hierarchy vanishes, and only one involution-centralizer fixed-scheme calculation is missing.

## Verification

```text
cd research/equivariant-unirationality-new-applications
python3 verify_klein_quartic_double_solid.py
python3 verify_odd_exceptional_conic_bundle.py --g 5
```

Expected markers:

```text
KLEIN_PSL27_QUARTIC_DOUBLE_SOLID_VERIFY_OK
ODD_EXCEPTIONAL_CONIC_BUNDLE_VERIFY_OK g=5
```

`verification_output.txt` records successful runs for the quartic double solid and for `g=3,5,7,9`.

## Honest boundary

No theorem is claimed for the `V22`, Abe No. 2.18, or non-Q8 Kummer candidates. Their exact finite gaps are recorded in `TOP5.md`, `INDEX1_FANO_THREEFOLDS.md`, `CONIC_BUNDLES.md`, and `KUMMER_DOUBLE_SOLIDS.md`.

A third completed application, the rational conic-bundle threefold over `F1` with a *ruled* central fixed divisor and `G=C2×S3`, is in `THEOREM_RULED_CONIC_BUNDLE_THREEFOLD.md` (adjudication: `ADJUDICATION_PR13.md`).