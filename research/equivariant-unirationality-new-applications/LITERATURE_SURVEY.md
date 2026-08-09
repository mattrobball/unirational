# Current literature boundary

**Search cutoff:** 2026-08-09  
**Purpose:** isolate theorem targets rather than provide a general bibliography.

## 1. Equivariant unirationality, versality, and current obstructions

Duncan–Reichstein supply the versality dictionary used throughout. For a complete `G`-variety, a rational point on every twist is weak versality; a dominant rational map from a linear representation is very versality, called `G`-unirationality in the recent Fano literature. To disprove weak versality it is enough to obstruct the point on the generic linear twist, equivalently every equivariant rational map from a faithful linear source.

Duncan proves Condition-(A) sufficiency for broad del Pezzo classes of degree at least 3. His degree-2 example with `(C7:C3)×C2` already shows that Condition (A) is not sufficient in lower degree. Scavia's 2026 theorem places that example in the sharper essential-dimension/Sylow-detection framework.

Cheltsov–Tschinkel–Zhang's current Fano-threefold program is strongest for index at least 2. It supplies positive constructions for many actions and an explicit exception list, but does not classify the smooth quartic-double-solid action proved negative here and does not cover most prime index-one Fanos.

Tschinkel–Zhang compute ordinary and third Amitsur obstructions for del Pezzo surfaces and Kummer quartic double solids. In particular, specified Q8 actions pass Condition (A) but have nonzero `Am^3`; those actions are already decided and are not new fixed-geometry targets.

Scavia–Tschinkel–Zhang prove that the equivariant universal-torsor obstruction controls the entire hierarchy: when the equivariant universal torsor exists, every higher Amitsur group vanishes. This is applied both to the smooth quartic double solid proved here and to the rational Klein `V22` candidate.

## 2. Del Pezzo surfaces of degrees 1 and 2

The equivariant birational classification is now very detailed, including the 2026 classification of actions on del Pezzo surfaces. The classification literature usually asks rigidity, conjugacy, or linearizability rather than weak versality.

The audit found no second degree-2 action for which the Problem-F exceptional path can simply be copied:

- the Klein `PSL2(F7)` action is already closed by Problem F;
- 13 class-named order-16 actions on the Fermat degree-2 surface are already closed by the repository central theorem;
- the Q8 actions isolated by current cohomology are already closed by nonzero `Am^3`;
- remaining actions either fail Condition (A), have a global fixed point, or require a new endpoint/incidence calculation.

Degree-1 actions have the common anticanonical base point, fixed by the full automorphism group. Thus weak versality is automatic. They may still fail very versality, but that requires a dominance-sensitive theorem rather than the current fixed-point contradiction.

## 3. Rational conic-bundle surfaces

Dolgachev–Iskovskikh give the weighted model and automorphism structure of exceptional conic bundles. Modern equivariant Sarkisov work and the classification of projectively linearizable plane Cremona subgroups determine their birational position, but do not decide weak versality.

No source found treats the explicit family

\[
(S_g,D_{2g}\times C_2),
\qquad g\ge3\text{ odd},
\]

constructed in this packet. Nonlinearizability follows from the positive-genus de Jonquières fixed curve, but nonlinearizability alone is weaker than non-`G`-unirationality. The central fixed hyperelliptic curve and empty full-group fixed locus produce the new theorem.

This answers the conic-bundle branch of the rational-surface `G`-MMP affirmatively: Condition (A) is not sufficient even on explicit rational conic bundles, for an infinite family of groups and genera.

## 4. Rational Fano conic-bundle threefolds

Abe studies rational Fano threefolds of Mori–Mukai family No. 2.18, extends the equivariant intermediate-Jacobian torsor obstruction, computes automorphism groups, and proves linearizability for the general member. Special members have much larger automorphism groups.

The two most useful discriminants are:

- the Fermat quartic, for which the total-space automorphism group has order 192;
- the Klein quartic, for which the automorphism-lifting problem itself is nontrivial.

For the Fermat member, Abe gives explicit generators and a subgroup `C4×C2deck` that is not projectively linearizable. That subgroup has a fixed point, hence is weakly versal; its `G`-unirationality is a dominance question. The more relevant target is a nonabelian subgroup of the full order-192 group with Condition (A) and empty global fixed locus.

The covering involution fixes the branch `(2,2)` surface, a degree-2 del Pezzo surface and therefore rational. Thus the basic central obstruction fails for a structural reason: the fixed surface itself is an allowed residual-stable RCC image. This is the cleanest current setting for a genuinely three-dimensional connected-fiber/fixed-network theorem.

## 5. Smooth quartic double solids

Avila–Ortiz–Troncoso classify smooth quartic surfaces invariant under primitive finite subgroups of `PGL4`, including the unique `PSL2(F7)`-invariant quartic used here. Smooth quartic double solids are classically unirational.

The current equivariant literature focuses on positive constructions for broad Fano families, birational rigidity, automorphisms, singular Kummer double solids, and cohomological linearizability obstructions. The targeted search found no treatment of weak versality for

\[
(C_7:C_3)\times C_2^{\rm deck}
\]

on this smooth double solid.

This action is especially valuable because:

```text
Condition (A)                              passes;
equivariant universal torsor               exists;
all higher Amitsur groups                  vanish;
residual stable RCC geometry               obstructs weak versality.
```

It is therefore a genuine application beyond the current cohomological hierarchy.

## 6. Kummer quartic double solids

Cheltsov develops their equivariant birational geometry, and Tschinkel–Zhang compute third-Amitsur obstructions for special models. Under Condition (A), the published nonzero `Am^3` cases are controlled by specified Q8 subgroups.

The geometric opening is a subgroup without those Q8s. On the resolved double solid, the deck-fixed Kummer K3 contains the classical 16 exceptional and 16 trope rational curves. The simple no-rational-curves theorem cannot apply, but the residual-RCC theorem reduces the question to finite data:

- permutation orbits of the 32 distinguished curves;
- their stabilizers and normal characters;
- the existence of any irreducible residual-stable rational curve;
- the deeper full-group fixed locus.

Natural very large Kummer groups often fail Condition (A) through their elementary-abelian translation subgroup, while the Q8 groups that pass it are already cohomologically obstructed. This is why Kummer double solids rank below the two new theorems and the Klein `V22`.

## 7. Index-one Fano threefolds

The repository's `V14` theorem is the benchmark: an involution fixes a smooth genus-one sextic plus two points, and its `D12` centralizer has empty fixed locus.

The strongest second target is not the Mukai–Umemura member but the rational Klein threefold

\[
X_{22}=\operatorname{VSP}(C_{\rm Klein},6)
\]

with `G=PSL2(F7)`. Cheltsov–Shramov prove:

- `X22` is smooth and rational;
- `Pic(X22)=Z[-K]` and `(-K)^3=22`;
- the action is `G`-birationally superrigid.

The 2025 Condition-(A) classification proves that every smooth member of Mori–Mukai family No. 1.10 satisfies Condition (A). Since `-K` is naturally `G`-linearized, the equivariant universal-torsor obstruction and all higher Amitsur groups vanish. The targeted search found no theorem deciding the exact action's `G`-unirationality or weak versality.

For an involution,

\[
C_G(\sigma)=D_8.
\]

Thus the exact remaining finite target is

\[
(X_{22}^{\sigma},X_{22}^{D_8}).
\]

The Mukai–Umemura `V22` with `A5⊂PGL2` remains a secondary candidate, but the Klein action has a larger simple group, published Condition (A), a silent cohomological hierarchy, and a more structured `D8` residual action.

## 8. Singular rational Fanos and moduli spaces

The Segre cubic, Burkhardt quartic, and related singular rational Fanos have extensive equivariant-birational analyses. They remain useful test beds, but singular exceptional divisors enlarge the fixed b-complex, and many subgroups already have Burnside, Picard, or cohomological obstructions.

The Gross–Popescu level-11 moduli space is already represented in the repository by the natural `V14` action and its centralizer theorem. The Klein `V22` is itself a compactification of a moduli space of `(1,7)`-polarized abelian surfaces, giving a second moduli-flavored target with a finite fixed-locus gap.

## 9. Exact status labels

- `OPEN-CONFIRMED`: the original model, standard birational models, current preprints, and direct equivariant-unirationality terminology were searched; no decision was found through the cutoff.
- `PARTIALLY-COVERED`: some subgroups or stronger/weaker properties are decided, but the named action is not.
- `ALREADY-DECIDED`: an existing theorem settles equivariant unirationality or weak versality.
- `LITERATURE-STATUS-UNCERTAIN`: the construction is explicit, but the citation or lift/fixed-locus chain is not yet complete.

## 10. Search conclusion

The literature is not exhausted. It contains at least one published rational action—Klein `V22` with `PSL2(F7)`—where Condition (A) and the full higher-Amitsur hierarchy are silent and the fixed-centralizer computation has not been performed. The two new theorems in this packet show that the repository obstruction is already strong enough to produce new results without waiting for that calculation.