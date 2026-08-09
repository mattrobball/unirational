# Literature audit

## Scope and date

This audit was checked through 2026-08-09. It asks whether the required theorem—classification of actual fixed-component maps on a resolved threefold graph, invariant under further equivariant blowups—already follows from standard going-down, surface fixed-graph, Burnside, or rigidity results.

## 1. Reichstein-Youssin and Kollár-Szabó

### Antecedents

- Z. Reichstein and B. Youssin, **Equivariant Resolution of Points of Indeterminacy**, arXiv:math/0006099.
- J. Kollár and E. Szabó, **Fixed points of group actions and rational maps**, arXiv:math/9905053.
- The Reichstein-Youssin going-down circle beginning with arXiv:math/9903162.

These results justify equivariant elimination of indeterminacy in characteristic zero and supply fixed-point consequences for equivariant rational maps. They are the correct antecedents for choosing a smooth equivariant graph resolution and for statements of the form

\[
C\subset Z^H\Longrightarrow q(C)\subset X^H.
\]

### What they do not provide

They do not classify the irreducible components of `Z^H` created by a sequence of blowups, do not select horizontal components of the normalized Rees algebra, and do not integrate associated-graded normal data into maps on those components. Going down detects the existence/location of fixed images; it does not force a pointwise-fixed rational curve to map constantly when the target fixed locus has a rational component.

The present use of equivariant principalization and the per-blowup character formula is standard. The proposed all-degree carrier classification is not contained in these theorems.

## 2. Dolgachev-Iskovskikh and surface fixed-graph methods

### Antecedents

- I. Dolgachev and V. Iskovskikh, **Finite subgroups of the plane Cremona group**, arXiv:math/0610595.
- I. Dolgachev and A. Duncan, **Fixed points of a finite subgroup of the plane Cremona group**, arXiv:1408.4042.
- The wider equivariant conic-bundle and del Pezzo-surface literature.

On a resolved surface, exceptional fibers and reducible conic fibers are curves. Their dual graphs are one-dimensional, frequently trees, and finite-group actions on individual exceptional `P^1`s have strong kernel/fixed-point restrictions. These are genuine antecedents for the successful exceptional-path theorem in Problem F.

### Threefold failure

At a type-I or type-II point of the Klein cubic, the first exceptional object is

\[
P(\chi_z\oplus\chi_s\oplus\chi_r)=P^2,
\]

not a union of `P^1`s. It contains:

- involution-fixed rational lines that can map to `L_t`;
- a disconnected `V_4` fixed locus;
- rational curves with faithful `V_4` action;
- paths that bypass a chosen character direction through a surface.

Thus the surface dual-tree mechanism does not generalize formally. A threefold theorem would need an additional carrier-incidence object extracted from the actual base ideal.

## 3. Kresch-Tschinkel Burnside and fixed-stratum invariants

### Antecedents

- A. Kresch and Y. Tschinkel, **Burnside groups and orbifold invariants of birational maps**, arXiv:2208.05835.
- Related equivariant Burnside and fixed-stratum constructions, including later threefold refinements.

This theory records stabilizers, fixed strata, normal characters, and blowup relations in a birationally invariant package. It is the closest conceptual antecedent to the repository's exact strata and character ledgers.

### Limitation for this mission

Burnside classes are invariants of equivariant birational geometry. The hypothetical map here is dominant and may have degree greater than one. The required datum is not merely the birational class of the resolved source, but the actual morphism

\[
q:Z\to X
\]

on each horizontal fixed carrier, including its degree, branch divisor, and base multiplicity. Burnside relations do not supply an integration theorem from a formal normal state to a component of the normalized Rees algebra, and they do not collapse the infinite monoid of residual-equivariant maps on `E_t` and `L_t` to a finite list.

The use of stabilizer/normal-character data is known. The proposed morphism-enriched carrier invariant would be new.

## 4. Prokhorov-Shramov and equivariant MMP/fixed-point arguments

The Prokhorov-Shramov circle, and related work on finite groups acting on rationally connected threefolds, provides strong restrictions on finite groups, fixed points, and equivariant Mori fiber structures. See, for example, the rationally connected threefold literature represented by arXiv:1809.09226 and its references.

These methods are global and birational/MMP-based. They do not furnish a theorem saying that the fixed locus inside a three-dimensional exceptional fiber is connected, tree-like, or forced into nonrational target components. The explicit first exceptional `P^2` in this packet is a local obstruction to any such unconditional statement.

No published Prokhorov-Shramov-style theorem was found that classifies the actual component maps of a generically finite self-map through a normalized Rees fiber.

## 5. Cheltsov-Tschinkel-Zhang: equivariant unirationality

I. Cheltsov, Y. Tschinkel, and Z. Zhang, **Equivariant unirationality of Fano threefolds**, arXiv:2502.19598, defines `G`-unirationality by a dominant equivariant map from a projective representation and develops fixed-point and invariant-section constructions.

Its current version states that a smooth cubic threefold satisfying the abelian fixed-point condition is `G`-unirational with explicit possible exceptions. Among those exceptions are the Klein cubic with

\[
G=PSL_2(F_{11})
\]

and with `C_5 semidirect C_11`. The paper therefore treats the present headline as open rather than supplying a positive or negative solution.

The constructions in that paper are antecedents for positive approaches using fixed points, index-two descent, or invariant hyperplane sections. They do not provide the fixed-network carrier theorem requested here.

## 6. Current Klein-cubic rigidity work

I. Cheltsov, I. Krylov, and S. Ma'u, **G-birationally rigid cubic threefolds**, arXiv:2604.20426, classifies `G`-birationally rigid cubic-threefold pairs and includes the Klein cubic with the `PSL_2(F_11)` action in the rigid/superrigid circle.

This is highly relevant but logically different. Birational rigidity controls equivariant birational maps and Mori fiber structures. A dominant self-map of degree greater than one is not birational. Therefore rigidity does not by itself exclude the degree-25 covariant branch or any other generically finite equivariant self-map.

The repository's selfmap audit correctly treats superrigidity as insufficient for the present all-degree question.

## 7. Known versus new

### Known antecedents used here

- existence of equivariant resolution/principalization;
- going-down inclusion of fixed images;
- character decomposition of fixed loci in an exceptional projective bundle;
- surface exceptional-tree and conic-bundle methods as a model;
- fixed-stratum/normal-character Burnside packages;
- global equivariant MMP and birational rigidity constraints;
- the fact that the Klein `PSL_2(F_11)` unirationality case remains an explicit exception in current Fano-threefold work.

### New elementary deductions in this packet

- correction of the marked reflection formula to `P -> iq-P`;
- exact residual-equivariant self-map classification `P -> [n]P+a` with `a in E[2]`;
- exact centralizer classification `R(z)=zA(z^3)`, `A(u)A(u^-1)=1`;
- construction of genuine degree-three equivariant maps `E_t->L_t`;
- the infinite family of genuine `G`-morphisms `Phi_{n,m}` of the reduced fixed network;
- explicit first-blowup counterexamples to an unconditional threefold exceptional-path theorem;
- the base-corrected polarization equation `3n^2=3d delta-F.C`.

### Genuinely new theorem still required

An **ambient base-carrier rigidity theorem** would be new in the needed form. It would enrich fixed-stratum/Burnside data by the actual dominant morphism and normalized Rees algebra, construct refinement-invariant horizontal carriers, classify their component maps and base multiplicities, and prove a finite global coupling theorem across the 55 `V_4` configurations.

No antecedent located in this audit supplies that theorem.

## 8. Novelty boundary

This packet does not claim novelty for equivariant resolution, going down, fixed-stratum character data, or surface path arguments. Its negative structural conclusion is that those antecedents do not imply the requested finite profile theorem in dimension three. The new proposed direction is specifically the morphism-enriched normalized-Rees carrier theory needed to bridge formal transition states and actual component maps.
