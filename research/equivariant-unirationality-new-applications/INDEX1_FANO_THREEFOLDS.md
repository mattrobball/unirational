# Index-one Fano threefolds

## 1. Literature gap

The current systematic equivariant-unirationality paper of
Cheltsov--Tschinkel--Zhang focuses on Fano threefolds of index at least two.
It explicitly presents the index-one range as outside that systematic
treatment. The repository's `V_14` centralizer theorem therefore points to
a real gap rather than a family already classified by the standard
unirationality constructions.

The search separated three kinds of index-one examples:

1. rational products and higher-Picard-rank Fanos, where exact fixed
   geometry is easy;
2. rational Fano conic bundles, where a deck involution fixes a surface;
3. prime Picard-rank-one Fanos, where fixed-locus tables are much less
   complete and ordinary unirationality may itself be delicate.

## 2. Closed example: `P^1 x` Fermat degree-two del Pezzo

Let

\[
Y_F=\mathbf P^1\times
\{w^2=x^4+y^4+z^4\}
\]

with `G=C_2(Geiser) x S_3` acting trivially on the first factor.

- `Y_F` is smooth and rational.
- `-K_{Y_F}=2H+(-K_{S_F})` is ample.
- `-K_{S_F}` is primitive, so the Fano index is one.
- the central fixed divisor is `P^1 x B_F`, where `B_F` is the Fermat
  genus-three quartic;
- this divisor contains rational rulings, but no `G`-stable RCC
  subvariety, because projection to `B_F` would give an `S_3`-fixed point;
- `B_F^{S_3}=emptyset`.

Theorem G1 proves that `Y_F` is not weakly `G`-versal. This is a genuine
index-one application of the refined theorem, although it is not prime and
has high Picard rank.

## 3. Rational Fano conic bundles of Mori--Mukai No. 2.18

Abe studies smooth rational Fano threefolds of No. 2.18, modeled as double
covers of `P^1 x P^2` ramified in a smooth divisor `B` of bidegree `(2,2)`.
The general member is linearizable for its full automorphism group and is
therefore **ALREADY-DECIDED**.

The central deck route also fails uniformly on special members. Adjunction
shows `-K_B=H_2|_B` and `(-K_B)^2=2`; hence `B` is a degree-two del Pezzo
surface. The fixed divisor is therefore rationally connected and is itself
a residual-stable positive-dimensional RCC subvariety. Theorem G1 cannot
apply, regardless of the enlarged residual group. Any useful obstruction
would have to constrain which dimensions or incidence classes of RCC images
can actually arise after resolution.

This is an audited mechanism failure, not an open top candidate.
Feasibility: 22/100.

## 4. Burkhardt quartic

The Burkhardt quartic is rational, highly symmetric, and carries four
published subgroup actions whose linearizability remains open. It is
singular rather than a smooth prime Fano, but it is an important test for
the centralizer philosophy.

The most tempting action, `C_3 rtimes C_4`, has central involution
`z=sigma_4^2`. The exact eigenspace substitution gives a three-nodal plane
quartic of geometric genus zero and two isolated points. Hence the fixed
locus itself contains a stable rational carrier, and Theorem G1 fails.
A coordinate-transposition involution also fails because its centralizer
fixes a point on the quartic.

Thus the Burkhardt does not supply the next `V_14` by the obvious elements.
See `BURKHARDT_AUDIT.md`.

## 5. Prime Picard-rank-one search outcome

No second smooth prime Picard-rank-one index-one Fano was found for which
all of the following were simultaneously available:

1. ordinary rationality or unirationality;
2. an exact substantial finite action;
3. a published complete fixed-locus calculation for a useful element;
4. empty centralizer fixed locus;
5. a Condition-(A) and higher-Amitsur audit.

This is not a claim that no such example exists. It is the precise search
boundary reached here. The most efficient next literature project would be
to extract involution and centralizer fixed-locus tables from the
classification of automorphisms of special genus-10 and genus-12 prime
Fanos, then intersect that list with varieties already known to be
rational.

## 6. Answer to the `V_14` recurrence question

The exact `V_14` pattern—centerless group, involution with positive-genus
fixed curve, and empty full-centralizer fixed locus—was not located on a
second natural prime index-one Fano. The product example proves that the
underlying theorem generalizes, but not yet that the same prime-Fano
phenomenon recurs.
