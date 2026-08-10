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
| 3 | rational genus-12 `V22=VSP(Klein quartic,6)`, `PSL2(F7)` | **computed 2026-08-10: gate (a) FAILS, gate (b) holds — route BLOCKED** (`EXIT_KLEIN_V22.md`, marker `V22-D8-GATE-FAILS`) | — |
| 4 | rational Mori–Mukai No. 2.18 with Fermat discriminant and an explicit finite subgroup | finite threefold-network target | 78 |
| 5 | non-Q8 subgroup on the special Kummer quartic double solid | residual-curve audit target | 71 |

The former third-place target, the rational `V22` of Cheltsov–Shramov, has now been computed and is **blocked** (2026-08-10, `EXIT_KLEIN_V22.md`). Exactly over `Q(√−7)` in Mukai's model `X=Gr(3,7)∩P^13` built on the 7-dimensional irreducible of `PSL2(F7)`:

```text
X^σ   =  (smooth rational curve, anticanonical degree 6, Hilbert polynomial 6i+1)
         ⊔ (2 points, one D8-orbit with stabilizer C4)          χ = 2 + 2 = 4
X^{D8} = ∅
gate (a) FAILS  — the curve is an irreducible D8-stable rational curve
gate (b) HOLDS
```

The failure is character-forced: `χ7(2A)=χ3(2A)=−1` gives eigenvalue profiles `(3,4)` on the 7-dimensional module and `(1,2)` on the net, and with that profile the positive-dimensional part of `X^σ` is always a plane conic in `P(A_+)≅P²`, hence always rational. Two further facts recorded there generalize:

* **Euler rigidity.** On any Fano threefold with `b₂=1, b₃=0` (`P³, Q³, V₅, V₂₂`) every finite-order automorphism has `χ(X^g)=4`, so `X^g≠∅` always and gate (b) forces a **non-cyclic** centralizer. In `PSL2(F7)` only the involution qualifies, so no other element can be substituted.
* The escape shape is the `FIX_IX §6` one: `D8/⟨σ⟩≅V4` acts on the fixed curve as the Klein four-group in `PGL2`, fixed-point free. Named open theory task `V22-D8-NORMAL-CHAIN`; if it were closed, gate (b) alone would suffice.

`G`-unirationality and weak `G`-versality of the Klein `V22` remain **open**; no literature computes either fixed locus.

## Answers to the eight required questions

1. **Additional degree-1/2 del Pezzo path cases?** No second verbatim Problem-F path application was found. The strongest degree-2 cases are already closed by Problem F, the repository central theorem, or nonzero third Amitsur groups. Degree-1 surfaces have a global anticanonical base point, so non-weak-versality needs a different, dominance-sensitive theorem.
2. **Rational conic-bundle surfaces passing Condition (A) but not `G`-unirational?** Yes: the family `(S_g,D_{2g}×C2)` proved here.
3. **Central fiber involutions on conic-bundle threefolds?** They naturally produce a discriminant-cover fixed surface. The residual-RCC theorem applies when that surface is non-uniruled and has no residual-stable rational curve. In Mori–Mukai No. 2.18 the fixed surface is rational, so a three-dimensional network theorem is required.
4. **Special rational Fano conic bundles with enlarged groups?** Yes: Abe's Fermat- and Klein-discriminant members of No. 2.18. The Fermat member is the best finite target.
5. **Kummer double solids?** Q8-containing actions are already detected by the third Amitsur group. A specific non-Q8 subgroup is isolated here, but its Condition-(A) and 32-curve residual permutation audits remain open.
6. **A second `V14`-type index-one phenomenon?** The candidate was the rational `V22` with `PSL2(F7)`. Its involution and `D8` fixed schemes are now computed (`EXIT_KLEIN_V22.md`): `X^{D8}=∅` but `X^σ` contains a `D8`-stable smooth rational curve, so the `V14` phenomenon does **not** recur there. No second index-one instance is currently in hand.
7. **Published silent-invariant examples still unresolved?** Yes: `V22` has Condition (A) and vanishing universal-torsor/higher-Amitsur obstructions, and no equivariant-unirationality decision exists — the centralizer machine is now known not to supply one (gate (a) fails). The Abe No. 2.18 special actions are additional partially audited cases.
8. **Best single remaining case?** After the `V22` block, the Fermat-discriminant Mori-Mukai No. 2.18 action (`TOP5.md` #4), followed by the non-`Q8` Kummer subgroup (#5). Both need new theory, not just a fixed-scheme computation; the selection criterion extracted from the `V22` run is to read the involution's eigenvalue profiles off the character table first, since they decide both gates up to one sign.

## Verification

```text
cd research/equivariant-unirationality-new-applications
python3 verify_klein_quartic_double_solid.py
python3 verify_odd_exceptional_conic_bundle.py --g 5
python3 verify_klein_v22.py                 # the V22 exit, exact over Q(sqrt(-7))
```

Expected markers:

```text
KLEIN_PSL27_QUARTIC_DOUBLE_SOLID_VERIFY_OK
ODD_EXCEPTIONAL_CONIC_BUNDLE_VERIFY_OK g=5
VERDICT: V22-D8-GATE-FAILS
```

`verification_output.txt` records successful runs for the quartic double solid and for `g=3,5,7,9`.

## Honest boundary

No theorem is claimed for the `V22`, Abe No. 2.18, or non-Q8 Kummer candidates. For the `V22` the gates are now decided negatively and the route is closed (`EXIT_KLEIN_V22.md`); this decides the applicability of the machine, **not** the `G`-unirationality or weak `G`-versality of the Klein `V22`, both of which remain open. The remaining exact finite gaps are recorded in `TOP5.md`, `INDEX1_FANO_THREEFOLDS.md`, `CONIC_BUNDLES.md`, and `KUMMER_DOUBLE_SOLIDS.md`.