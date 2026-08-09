# Literature audit

**Checked through:** 2026-08-09.

## 1. Main finding

No located theorem classifies dominant rational selfmaps of the Klein cubic,
or of a fixed smooth cubic threefold, in a way that implies degree one.
The literature sharply separates:

- regular endomorphisms;
- birational selfmaps and Mori fibre structures;
- rational selfmaps of very general hypersurfaces;
- tangent/secant constructions for cubic hypersurfaces;
- correspondences on the Fano surface and intermediate Jacobian.

The selfmap theorem in this packet is obtained by combining a classical
cubic tangent-residual map with descent through the free \(G\)-quotient and a
new elementary dominant-section lemma.

## 2. Tangent-residual antecedent

Cheltsov--Tschinkel--Zhang,
*Equivariant unirationality of Fano threefolds*, arXiv:2502.19598,
Proposition 3.5, constructs the equivariant rational map from a tangent bundle
to a cubic hypersurface by sending a tangent direction to the residual third
intersection point. Their application starts from a \(G\)-unirational
invariant hyperplane section and proves \(G\)-unirationality of the cubic.

This is the direct geometric antecedent for

\[
\rho:\mathbf P(T_X)\dashrightarrow X.
\]

The paper does not choose a rational section of the tangent bundle over the
free quotient and does not state the resulting selfmap existence theorem.
It also lists the Klein cubic actions of
\(C_5\rtimes C_{11}\) and \(\operatorname{PSL}_2(\mathbf F_{11})\) among the
remaining possible exceptions to its cubic-threefold unirationality theorem.

Source:
<https://arxiv.org/abs/2502.19598>.

## 3. Regular endomorphisms

Beauville, *Endomorphisms of hypersurfaces and other manifolds*, proves the
standard nonexistence theorem for endomorphisms of degree greater than one on
smooth hypersurfaces in the relevant range.

This settles the branch where a rational selfmap is everywhere regular. It
does not apply to the tangent-residual selfmaps, which necessarily have base
locus because their degrees are greater than one.

Source:
<https://arxiv.org/abs/math/0008205>.

The Hwang--Mok and Amerik--Rovinsky--Van de Ven circles likewise concern
surjective/finite morphisms, tangent-bundle positivity, or closely related
regular-map settings. None removes the indeterminacy of a rational graph.

## 4. Rational endomorphisms of hypersurfaces

Chen--Stapleton, *Rational endomorphisms of Fano hypersurfaces*,
arXiv:2103.12207, establishes degree restrictions for rational selfmaps of
very general Fano hypersurfaces in specified numerical ranges. It also
emphasizes that cubic hypersurfaces are unirational and admit many rational
endomorphisms.

Those very-general deformation arguments do not specialize to a degree-one
theorem for the highly symmetric Klein cubic, and they do not impose
\(G\)-equivariance. They are consistent with the existence theorem here.

Source:
<https://arxiv.org/abs/2103.12207>.

Searches for later papers on rational selfmaps of cubic threefolds and Fano
hypersurfaces found no 2026 result superseding this boundary.

## 5. Birational rigidity

Cheltsov--Shramov, *Five embeddings of one simple group*, and the later
Cheltsov--Krylov--Ma'u preprint,
*G-birationally rigid cubic threefolds*, arXiv:2604.20426, place the full
Klein action in the \(G\)-birationally superrigid class.

This gives

\[
\operatorname{Bir}^G(X)=\operatorname{Aut}^G(X)=1
\]

and therefore classifies degree-one selfmaps. The definition concerns
birational maps between Mori fibre spaces. It does not say that a generically
finite rational selfmap is birational, and the tangent-residual theorem gives
actual counterexamples to that extrapolation.

Sources:
<https://arxiv.org/abs/0910.1783>,
<https://arxiv.org/abs/2604.20426>.

Blanc--Lamy and the wider Sarkisov literature study birational maps arising
from curves on cubic threefolds. These results illuminate possible exceptional
centres but do not classify finite-degree rational selfmaps.

## 6. Fano surface and intermediate Jacobian

Roulleau, *The Fano surface of the Klein cubic threefold*, describes the
special period lattice, automorphisms, and Albanese/intermediate-Jacobian
geometry of the Klein cubic. This supports the exact CM norm calculation in
the degree-three audit.

Source:
<https://arxiv.org/abs/1001.4853>.

Clemens--Griffiths, Murre, and modern treatments such as Huybrechts,
*The Geometry of Cubic Hypersurfaces*, provide the graph-correspondence and
intermediate-Jacobian framework. They do not give the uncorrected identity
\(u^\dagger u=[\deg\varphi]\) for a rational map whose resolution blows up
curves. Exceptional Jacobian summands must be retained.

Source:
<https://doi.org/10.1017/9781009280020>.

## 7. Equivariant resolution, quotient torsors, and going down

Reichstein--Youssin and Kollár--Szabó justify equivariant resolution and
fixed-point going-down principles. Twisting/torsor methods in the
Duncan--Reichstein and Cheltsov--Tschinkel--Zhang literature explain why a
\(G\)-map is encoded generically by a quotient map preserving the generic
\(G\)-torsor.

These tools justify the generic-torsor classification in this packet. They do
not make that classification finite.

Sources:
<https://arxiv.org/abs/math/0006099>,
<https://arxiv.org/abs/math/9905053>.

## 8. Dynamical literature

For dominant rational selfmaps, dynamical degrees, algebraic stability, and
iteration can be studied after suitable models. In the present problem no
general dynamical theorem forbids a degree-greater-than-one map on a rationally
connected cubic threefold. The construction here instead makes iteration a
positive conclusion:

\[
\deg(\varphi^m)=(\deg\varphi)^m.
\]

Picard rank one controls the first pullback class only after base corrections
are accounted for; it does not force regularity.

## 9. Novelty and exact literature boundary

Known input:

- tangent residual intersection on a cubic;
- equivariance of that construction;
- free quotients and descent of vector bundles;
- birational rigidity in degree one;
- Beauville's regular-endomorphism theorem.

New deduction in this packet:

- descent of the projectivized tangent bundle to the free quotient;
- the dominant-section lemma for a rational map from a projective bundle back
  to its base;
- application to obtain a nonidentity dominant full-\(G\) rational selfmap;
- degree at least three from the accepted degree-one and degree-two theorems;
- unbounded degrees by iteration.

No located source already states this selfmap existence theorem for the Klein
cubic. The literature therefore does not supply Target A or Target B; rather,
the tangent construction shows why both targets fail outside the
ambient-extendable subclass.
