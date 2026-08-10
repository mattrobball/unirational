# New applications of the fixed-locus obstruction machinery

**Search cutoff:** 2026-08-09  
**Packet:** `research/equivariant-unirationality-new-applications/`

## Executive verdict

This audit now produces **three** new non-weak-versality theorem families and
one reusable strengthening of the repository obstruction.

```text
NEW-EQUIVARIANT-NONUNIRATIONALITY-THEOREM
FIXED-LOCUS-OBSTRUCTION-GENERALIZED
NEW-APPLICATIONS-TOP-CANDIDATES-CLASSIFIED
```

The completed negative results are:

1. the smooth quartic double solid branched over the primitive
   `PSL2(F7)`-invariant quartic, with
   \[
   G=(C_7\rtimes C_3)\times C_2^{\rm deck};
   \]
2. an infinite family of rational exceptional conic-bundle surfaces
   \[
   (S_g,D_{2g}\times C_2),\qquad g\ge3\text{ odd};
   \]
3. an infinite family of smooth unirational cubic-surface bundles
   \[
   (\mathcal X_{n,F_0,F_1},C_3\times D_{2n}),
   \qquad n\ge3\text{ odd},
   \]
   where the central order-three fixed locus contains a smooth curve of
   genus \(4n-2\).

All three pass Condition (A). The quartic-double-solid and cubic-bundle
families also have equivariant universal torsors, hence every higher Amitsur
group vanishes. Their failure of weak versality is detected only by fixed
geometry.

## General theorem proved

`GENERALIZATIONS.md` proves the **residual-RCC centralizer obstruction**. For
`N=C_G(σ)`, it replaces

> `Y^σ` contains no rational curve

by the strictly weaker condition

> every irreducible `N`-stable RCC subvariety of `Y^σ` is a point.

Together with `Y^N=∅`, this excludes every rational map from a faithful
linear source and therefore excludes weak versality. The proof follows one
controlled eigenspace survivor through an equivariant resolution; it does not
use the withdrawn assertion that every fixed stratum on every model remains
RCC.

## New cubic-surface-bundle theorem

For odd `n>=3`, set

\[
A_0=S^{2n}+T^{2n},\qquad A_1=(ST)^n,
\qquad G_n=C_3\times D_{2n}.
\]

For general binary cubics `F0,F1`, define

\[
\begin{aligned}
\mathcal X_{n,F_0,F_1}:\quad
0={}&A_0(U^3+V^3)+UV(A_0X+A_1Y)\\
&+A_0F_0(X,Y)+A_1F_1(X,Y)
\end{aligned}
\]

in `P1 x P3`. Then:

```text
smooth projective cubic-surface bundle              PROVED
ordinary unirationality via three sections          PROVED
Condition (A)                                       PROVED
central fixed curve genus 4n-2                      PROVED
full G_n-fixed locus                                EMPTY
equivariant universal torsor                        EXISTS
all higher Amitsur groups                           ZERO
weak G_n-versality                                  FALSE
```

See `THEOREM_CUBIC_SURFACE_BUNDLE_FAMILY.md`.

## Quadratic double-solid audit

`QUADRATIC_DOUBLE_SOLIDS.md` separates two meanings.

- A double cover of `P3` branched over a quadric is itself a smooth quadric
  threefold. Current theory proves Condition (A) sufficient for stable
  linearizability, so this is `ALREADY-DECIDED` and cannot yield a negative
  theorem.
- A double cover of a smooth quadric threefold branched in a quartic section
  is a genuine index-one **double quadric**. Its deck-fixed canonical surface
  is promising, but the best large-group examples are singular or lack a
  known ordinary-unirationality boundary.

The audit proves a local screening lemma: if an invariant branch section
vanishes at an isolated subgroup-fixed point and the line-bundle fiber
character is trivial, then the branch divisor is singular there. This rules
out several natural permutation `C4 x C2deck` attempts at Condition (A).

## Ranked outcome

| rank | action | status after this packet | feasibility |
|---:|---|---|---:|
| 1 | smooth Klein-invariant quartic double solid, `(C7:C3)xC2deck` | **new theorem** | 100 |
| 2 | cubic-surface bundles `X_n`, `C3xD_{2n}`, odd `n>=3` | **new infinite theorem family** | 99 |
| 3 | odd exceptional conic bundles, `D_{2g}xC2`, odd `g>=3` | **new infinite theorem family** | 98 |
| 4 | rational genus-12 `V22=VSP(Klein quartic,6)`, `PSL2(F7)` | best remaining direct-centralizer target | 94 |
| 5 | rational Mori–Mukai No. 2.18 with Fermat discriminant | finite threefold-network target | 78 |

The nodal `A6` double quadric enters the broader table at score 61: its group
theory is attractive, but singular-target resolution, Condition (A), and
ordinary unirationality remain unresolved.

## Answers to the eight required questions

1. **Additional degree-1/2 del Pezzo path cases?** No second verbatim
   Problem-F path application was found. The strongest degree-2 cases are
   already closed by Problem F, the repository central theorem, or nonzero
   third Amitsur groups. Degree-1 surfaces have a global anticanonical base
   point, so non-weak-versality needs a different, dominance-sensitive
   theorem.
2. **Rational conic-bundle surfaces passing Condition (A) but not
   `G`-unirational?** Yes: the family `(S_g,D_{2g}xC2)` proved here.
3. **Central fiber involutions on conic-bundle threefolds?** They naturally
   produce a discriminant-cover fixed surface. The residual-RCC theorem
   applies when that surface has no residual-stable RCC subvariety. In
   Mori–Mukai No. 2.18 the fixed surface is rational, so a
   three-dimensional network theorem is required.
4. **Special rational Fano conic bundles with enlarged groups?** Yes: Abe's
   Fermat- and Klein-discriminant members of No. 2.18. The Fermat member is
   the best finite target.
5. **Kummer double solids?** `Q8`-containing actions are already detected by
   the third Amitsur group. A non-`Q8` subgroup is isolated in the packet,
   but its Condition-(A) and 32-curve residual permutation audits remain
   open.
6. **A second `V14`-type index-one phenomenon?** The best current candidate
   is the rational `V22` with `PSL2(F7)`; its involution/`D8` fixed schemes
   are the exact missing data. Double quadrics have promising deck-fixed
   canonical surfaces but a worse ordinary-geometry boundary.
7. **Published silent-invariant examples still unresolved?** Yes: `V22`
   has Condition (A) and vanishing universal-torsor/higher-Amitsur
   obstructions, while no equivariant-unirationality decision was found.
   The cubic-bundle family constructed here gives a second completed example
   where the same hierarchy is silent.
8. **Best single remaining case?** `V22` with `PSL2(F7)`, because the
   variety is rational, the action is exact, Condition (A) is published,
   the cohomological hierarchy vanishes, and only one
   involution-centralizer fixed-scheme calculation is missing.

## Verification

```text
cd research/equivariant-unirationality-new-applications
python3 verify_klein_quartic_double_solid.py
python3 verify_odd_exceptional_conic_bundle.py --g 5
python3 verify_cubic_surface_bundle_family.py --n 3
python3 verify_cubic_surface_bundle_family.py --n 5
python3 verify_cubic_surface_bundle_family.py --n 7
```

New expected markers:

```text
CUBIC_SURFACE_BUNDLE_FAMILY_VERIFY_OK n=3
CUBIC_SURFACE_BUNDLE_FAMILY_VERIFY_OK n=5
CUBIC_SURFACE_BUNDLE_FAMILY_VERIFY_OK n=7
```

## Honest boundary

No theorem is claimed for the `V22`, Abe No. 2.18, non-`Q8` Kummer, or
large-group double-quadric candidates. Their exact finite or geometric gaps
are recorded in `TOP5.md`, `INDEX1_FANO_THREEFOLDS.md`,
`CONIC_BUNDLES.md`, `KUMMER_DOUBLE_SOLIDS.md`, and
`QUADRATIC_DOUBLE_SOLIDS.md`.
