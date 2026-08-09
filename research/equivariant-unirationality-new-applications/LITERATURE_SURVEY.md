# Literature survey and theorem-development audit

This is not a catalogue of finite group actions. It records only actions
that survived at least one geometric screening step and identifies exactly
where the current fixed-stratum machinery applies or fails.

## 1. Current equivariant-unirationality boundary

### Del Pezzo surfaces

Duncan's theorem settles degree at least three: Condition (A) is equivalent
to `G`-unirationality. The degree-one and degree-two cases remain outside
that theorem. Tschinkel--Zhang, arXiv:2504.10204v2 (2026-07-07), classify
all del Pezzo actions detected by their `Am^3` obstruction. In degree two,
the Condition-(A)-passing negative cases they identify are quaternionic:
a `Q_8` subgroup is responsible for nonzero `Am^3`. They also record that
every finite action on a degree-one del Pezzo has a global fixed point and
therefore vanishing `Am^2` and `Am^3` for every subgroup.

The repository's Problem F supplies a different negative degree-two action:
`PSL(2,7)` on the Klein double plane, killed by an all-degree exceptional
path. The Fermat `C_2 x S_3` action proved in this packet is a third type:
Condition (A) passes, all higher Amitsur groups vanish, and a central
positive-genus fixed curve with empty deeper fixed locus kills weak
versality.

### Fano threefolds

Cheltsov--Tschinkel--Zhang's current systematic equivariant-unirationality
work is strongest for Fano threefolds of index at least two. The repository's
`V_14` result is already an index-one centralizer example. The product
`P^1 x S_F` in this packet is a smooth rational index-one Fano with a
central fixed divisor containing rational curves; it is closed by the new
residual-RCC theorem.

This is not evidence that prime Picard-rank-one index-one Fanos are now
systematically tractable. The search found no second natural smooth prime
Fano with the exact `V_14` pattern `X^sigma = positive-genus curve + points`
and `X^{C_G(sigma)}=emptyset`.

### Cohomological obstructions

Tschinkel--Zhang define and compute `Am^2` and `Am^3` in the relevant del
Pezzo and Kummer families. Scavia--Tschinkel--Zhang,
arXiv:2605.02763, prove stable birational invariance of all higher Amitsur
groups and show that, for free finitely generated Picard group, vanishing
of the equivariant universal-torsor obstruction forces vanishing in every
degree `n>=2`. Hassett--Tschinkel's universal-torsor formalism gives the
fixed-point criterion used in the Sylow transfer argument.

This makes “every Sylow subgroup fixes a point” an efficient silence test.
It holds for both new theorem families here, so the geometric obstruction
is strictly stronger than the entire present higher-Amitsur package on
those examples.

## 2. Conic-bundle surface literature

The finite-subgroup and Cremona literature of Dolgachev--Iskovskikh,
Blanc, Trepalin, and others treats de Jonquières involutions and finite
automorphism groups of rational conic bundles in detail. In particular,
positive-genus curves fixed pointwise by fiberwise involutions are a
classical conjugacy invariant: Blanc proves that a finite cyclic plane
Cremona action is linearizable exactly when no nontrivial element fixes a
positive-genus curve.

That literature addresses conjugacy and linearizability, not the exact
weak-versality question asked here. The odd-dihedral action

\[
C_2(\delta)\times D_{2m}\curvearrowright
\{UV=(X^{2m}+Z^{2m})W^2\}
\]

is an explicit regular model whose central fixed curve is the hyperelliptic
curve `y^2=x^{2m}+1`. No prior equivariant-unirationality or weak-versality
verdict for this action was located. The theorem in this packet closes it.

This is conceptually distinct from Blanc's nonlinearizability result:
nonlinearizability alone would not exclude a dominant equivariant map from
a higher-dimensional representation. The central fixed-stratum theorem
does.

## 3. Rational Fano conic-bundle threefolds

Abe, arXiv:2506.15042v2, studies Mori--Mukai No. 2.18. Such an `X` is a
double cover of `P^1 x P^2` branched in a smooth `(2,2)` divisor; it is
rational, admits a standard conic bundle over `P^2` with plane-quartic
discriminant, and has finite automorphism group. Abe proves that a general
member has automorphism group `C_2` and is linearizable for this full group.
Therefore the general member is not a negative target.

Special No. 2.18 members can have enlarged automorphism groups, but
the central deck involution does **not** give the residual-RCC funnel sought
here. Its fixed divisor is the smooth branch surface
`B in |O_{P^1 x P^2}(2,2)|`. Adjunction gives

\[
-K_B=H_2|_B,\qquad (-K_B)^2=2,
\]

so `B` is a degree-two del Pezzo surface and is itself rationally connected.
It is therefore an `H`-stable positive-dimensional RCC subvariety of the
deck fixed locus for every residual group `H`. Theorem G1 fails before any
classification of invariant rational curves. A special No. 2.18 application
would need source-dimension, incidence, or exceptional-network information
that prevents the selected survivor from dominating `B`; the central
fixed-divisor criterion alone has no leverage.

The product family `P^1 x S_m` is rational and a conic bundle over a
surface, but is generally not Fano. It nevertheless proves the requested
threefold mechanism cleanly.

## 4. Kummer quartic double solids

Cheltsov's work gives explicit rational Kummer quartic double solids and
their automorphism groups. Tschinkel--Zhang study the two maximally
symmetric genus-two Jacobian models. For

\[
C_1:y^2=x(x^4-1),\qquad
C_2:y^2=x^5+1,
\]

the corresponding automorphism groups are

\[
C_2.(C_2^4\rtimes S_4),\qquad
C_2.(C_2^4\rtimes C_5).
\]

For the first model they prove that, subject to Condition (A), a subgroup
has nonzero `Am^3` somewhere exactly when it contains one of two specified
`Q_8` subgroups. These attractive examples are therefore already decided
cohomologically.

The deck involution fixes the Kummer quartic. After resolving its sixteen
nodes, the fixed surface is a K3 containing the sixteen exceptional curves
and the trope configuration. The naive central theorem fails because the
fixed surface contains rational curves. The refined theorem asks a sharper
question: does the residual group preserve an irreducible RCC subvariety?
Transitivity on nodes or tropes is not enough to answer this, because an
invariant rational curve may lie outside the classical 16+16 configuration.
A proof would require a residual-equivariant classification in the Kummer
Neron--Severi lattice or a direct curve-orbit theorem. No such classification
was found for a cohomology-silent subgroup.

Verdict: Kummer double solids remain a stress test, but not the best next
new theorem. The known `Q_8` cases are `ALREADY-DECIDED`; the rest are
`LITERATURE-STATUS-UNCERTAIN` with a substantial K3-curve gap.

## 5. Burkhardt quartic audit

Cheltsov--Tschinkel--Zhang settle linearizability for all but four subgroup
classes of `Aut(X_4)=PSp_4(F_3)`:

\[
S_3,\quad D_5,\quad D_6,\quad C_3\rtimes C_4.
\]

These are open for **linearizability**, not automatically for
`G`-unirationality. They are nevertheless natural fixed-locus targets
because the Burkhardt quartic is rational and explicit.

Two exact tests fail:

1. A coordinate-transposition involution has an anti-invariant eigenline
   represented in the six-coordinate model by
   `[1:-1:0:0:0:0]`. This point lies on `e_1=e_4=0`; its one-dimensional anti-eigenspace is
   preserved by the full centralizer, so the deeper fixed locus is nonempty.
2. For the explicit `C_3 rtimes C_4=<sigma_3,sigma_4>` action of their
   Section 7, the center is `z=sigma_4^2`. In the standard `P^4` equation

   \[
   y_1(y_1^3+y_2^3+y_3^3+y_4^3+y_5^3)+3y_2y_3y_4y_5=0,
   \]

   the positive eigenspace of `z` cuts out

   \[
   a^4+2ab^3+2ac^3+3q^2b^2c^2=0,\qquad q^2+q+1=0.
   \]

   It has the three nodes
   `[-q^2 t^2:1:t]`, `t^3=1`, and hence normalization `P^1`. The negative
   eigenspace contributes two points. Thus the central fixed locus contains
   an invariant rational curve, and the residual-RCC hypothesis fails.

The Burkhardt quartic is retained as an important audited near-miss, not a
headline candidate.

## 6. Other index-one Fanos and special rational threefolds

- **Mukai--Umemura `V_22`:** large automorphism group and explicit finite
  subgroups, but the search did not find a fixed-locus package giving the
  required positive-genus funnel; status uncertain and ordinary
  birational geometry is not as favorable as the product example.
- **Special quartic threefolds:** many have finite automorphisms, but
  ordinary unirationality/rationality is often unresolved or the varieties
  are known irrational. These were heavily penalized.
- **Singular rational Fanos:** many current papers concern linearizability
  and have rational fixed surfaces or fixed singular points, which usually
  defeat the centralizer theorem. The Burkhardt quartic is the most
  instructive case.
- **Existing repository cubics and `V_14`:** excluded from the “new
  application” ranking except as controls.

## 7. Answers to the eight required questions

1. **Additional degree-1/2 path cases?** A new degree-two negative action is
   proved, but it is central rather than path-dependent. No second genuine
   Problem-F exceptional-path action was verified. Degree one is blocked
   for the central Bertini route by the global anticanonical base point.
2. **Rational conic bundles with Condition (A) but not `G`-unirational?**
   Yes: the odd-dihedral `S_m` family.
3. **Central fiber involution on a conic-bundle threefold?** Yes. The fixed
   discriminant cover naturally gives the obstruction; `P^1 x S_m`
   demonstrates the residual-MRC form.
4. **Special rational Fano conic bundles?** The obvious No. 2.18 deck
   route fails uniformly: its fixed branch surface is a degree-two del
   Pezzo and hence is itself a residual-stable RCC carrier. The general
   member is already linearizable; special members would require a new
   dimension/incidence obstruction, not just Theorem G1.
5. **Kummer double solids geometrically?** Not yet in a new
   cohomology-silent case. The quaternionic cases are already killed by
   `Am^3`; the residual K3 curve problem remains.
6. **The `V_14` phenomenon elsewhere?** The refined fixed-stratum
   phenomenon occurs on the index-one Fano `P^1 x S_F`. No second prime
   Picard-rank-one example was found.
7. **Condition (A) and cohomology silent but unresolved?** The broad
   degree-one/two boundary contains such actions; the two explicit actions
   closed here were not decided by the current cohomological classification.
   Non-quaternionic Kummer subgroups remain only partially audited. No.
   2.18 is an audited failure of the central deck route because its fixed
   surface is RCC.
8. **Best single case?** The six-fiber de Jonquières conic bundle
   `(S_3,C_2 x S_3)`.
