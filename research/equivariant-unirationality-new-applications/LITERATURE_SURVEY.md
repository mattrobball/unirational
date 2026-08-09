# Current literature boundary

**Search cutoff:** 2026-08-09.  
**Purpose:** identify theorem targets, not provide a general bibliography.

## 1. Equivariant unirationality and versality

Duncan–Reichstein supply the versality dictionary used throughout: for complete varieties, failure of a rational map from the generic linear torsor gives failure of weak versality; dominant maps from linear representations are the `very versal` or `G`-unirational condition.

Duncan's theorem settles equivariant unirationality of many del Pezzo surfaces of degree at least 3 under fixed-point hypotheses. It does not give a comparable classification in degrees 1 and 2.

Cheltsov–Tschinkel–Zhang's current Fano-threefold program is strongest for index at least 2 and supplies positive constructions in many families. It does not classify the smooth quartic-double-solid actions used in this packet, and it does not reach most prime index-1 Fanos.

Tschinkel–Zhang's 2026 paper `Cohomological obstructions to equivariant unirationality` computes ordinary and third Amitsur obstructions for del Pezzo surfaces and Kummer quartic double solids. It shows in particular that selected Q8 actions satisfy Condition (A) but have nonzero \(\operatorname{Am}^3\). Those are already decided and are not new fixed-geometry targets.

Scavia–Tschinkel–Zhang prove stable birational invariance of all higher Amitsur groups and show that vanishing of the equivariant universal-torsor obstruction implies vanishing of every higher Amitsur group. This is applied to the smooth quartic double solid in this packet.

## 2. Del Pezzo surfaces of degrees 1 and 2

The current equivariant birational classification is now very detailed, including the 2026 classification by Cheltsov–Tschinkel–Zhang. The classification literature usually asks birational rigidity or linearizability, not weak versality.

The application audit nevertheless found no second degree-2 action for which the Problem-F exceptional path can simply be copied:

- the Klein \(\operatorname{PSL}_2(\mathbf F_7)\) action is already closed by Problem F;
- the Fermat-quartic order-16 actions with an appropriate central involution are already closed by the repository's central theorem;
- the Q8 degree-2 actions singled out by current cohomology are already closed by nonzero \(\operatorname{Am}^3\);
- other actions either fail Condition (A), have a global fixed point, or require a new endpoint/incidence analysis.

Degree-1 actions remain possible targets for failure of `very` versality, but a global fixed point makes non-weak-versality impossible and neutralizes the present central theorem. A new path theorem would have to distinguish dominance from mere existence of a map.

## 3. Rational conic-bundle surfaces

Dolgachev–Iskovskikh give the weighted model and automorphism structure of exceptional conic bundles. Later equivariant Sarkisov work, including Pinardin's classification of \(G\)-solid rational surfaces, determines their birational position.

No source found studies weak versality of the explicit odd-genus action

\[
(S_g,D_{2g}\times C_2)
\]

used here. `G`-solidity or nonlinearizability does not imply non-\(G\)-unirationality. The central fixed hyperelliptic curve supplies a new conclusion.

## 4. Rational Fano conic-bundle threefolds

Abe studies rational Fano threefolds of Mori–Mukai family No. 2.18, extends the equivariant intermediate-Jacobian torsor obstruction, computes automorphism groups, and proves linearizability for the general member. Special members have much larger automorphism groups.

The two highest-value special discriminants are:

- the Fermat quartic, with an automorphism group of the total space of order 192;
- the Klein quartic, with a large liftable subgroup of its quartic automorphism group.

These papers decide linearizability questions, not equivariant unirationality. The covering involution fixes a rational degree-2 del Pezzo surface, so the basic central obstruction fails. This is the cleanest setting for a three-dimensional fixed-network theorem.

## 5. Smooth quartic double solids

Avila–Ortiz–Troncoso classify smooth quartic surfaces invariant under finite primitive subgroups of \(\operatorname{PGL}_4\), including the unique \(\operatorname{PSL}_2(\mathbf F_7)\)-invariant quartic used here.

The current equivariant-unirationality and double-solid literature focuses on:

- positive constructions for broad Fano families;
- birational rigidity and automorphisms;
- singular Kummer quartic double solids;
- linearizability and cohomological obstructions.

No treatment of weak versality for the subgroup

\[
(C_7\rtimes C_3)\times C_2^{\rm deck}
\]

on this smooth quartic double solid was found. The action is particularly valuable because its universal-torsor and all higher-Amitsur obstructions vanish.

## 6. Kummer quartic double solids

Cheltsov classifies their equivariant birational rigidity. Tschinkel–Zhang compute the third Amitsur obstruction for the special model

\[
w^2=x_1^4+x_2^4+x_3^4+x_4^4-4ix_1x_2x_3x_4.
\]

Under Condition (A), their nonzero \(\operatorname{Am}^3\) cases are exactly those containing specified Q8 subgroups. These are already non-\(G\)-unirational.

The geometric opening is therefore a subgroup without those Q8s. The deck-fixed resolved Kummer surface contains the 16 exceptional and 16 trope curves, so the residual-RCC theorem reduces the question to an exact residual permutation/stabilizer calculation rather than to the false assertion that the fixed surface contains no rational curves.

## 7. Index-1 Fano threefolds

The repository's \(V_{14}\) theorem is currently the cleanest centralizer application: an involution fixes a genus-one sextic plus points and its \(D_{12}\) centralizer has empty fixed locus.

The search found no published second example with all these data already tabulated. The strongest candidate is the Mukai–Umemura \(V_{22}\) with an icosahedral \(A_5\)-subgroup of \(\operatorname{PGL}_2\). Its involution centralizer is \(V_4\), but the required scheme-theoretic fixed loci have not been extracted.

Most other prime index-1 families are penalized because ordinary rationality/unirationality is unresolved or their finite automorphism groups are too small to create a useful deeper fixed-locus obstruction.

## 8. Singular rational Fanos and moduli spaces

The Segre cubic and Burkhardt quartic have extensive current equivariant-birational analyses. They remain useful test beds, but singular exceptional divisors make the fixed b-complex substantially larger, and many subgroup actions already have cohomological or Burnside obstructions.

The Gross–Popescu level-11 moduli space is already represented in the repository by the natural \(V_{14}\) action and its centralizer theorem. No second moduli-space action with comparably explicit positive-genus fixed loci and silent cohomology was found in this pass.

## Status labels used

- `OPEN-CONFIRMED`: searched under the original and standard birational models; no decision found.
- `PARTIALLY-COVERED`: some subgroups or stronger/weaker properties are decided, but the named action is not.
- `ALREADY-DECIDED`: an existing theorem settles equivariant unirationality or weak versality.
- `LITERATURE-STATUS-UNCERTAIN`: construction is explicit, but the citation/fixed-locus chain is incomplete.
