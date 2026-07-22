# Equigeneric attempt for the square-free three-`t=2` row

## Verdict

This route does **not** give an exclusion theorem.  Its first proposed input is
false: [`three_center_genus_counterexample.md`](three_center_genus_counterexample.md)
gives a reduced octic with exactly the required three `t=2` centers and both
cluster-system vanishings, but normalization genus four rather than at most
three.  The later
[`proper_three_center_theorem.md`](proper_three_center_theorem.md) excludes the
all-proper subrow for a general determinantal branch, but this counterexample
has an infinitely-near essential center and therefore showed that this route
could not close the boundary that was then unresolved.  The later direct
marked-incidence theorems now exclude that boundary without a uniform genus
bound.

The exact root-tree reduction and its limits are in
[`contact_cubic_observation.md`](contact_cubic_observation.md): root type
`[1,1,1]` has only proper centers or immediate `(3,4)` clusters, whereas
ancestor types `[2,1]` and `[3]` cannot be removed by the two cluster
vanishings alone.  The later direct incidence theorem
[`adjacent_nested_pair_theorem.md`](adjacent_nested_pair_theorem.md) does
exclude every adjacent `[2,1]` skeleton and the proper-root successive-free
adjacent `[3]` chain.  The later
[`three_singleton_first_near_theorem.md`](three_singleton_first_near_theorem.md)
excludes every `[1,1,1]` diagram.  The later
[`root_two_one_separator_theorem.md`](root_two_one_separator_theorem.md) and
[`root_three_completion_theorem.md`](root_three_completion_theorem.md), with
the separator and free-separator lemmas they cite, exclude the remaining
`[2,1]` and `[3]` diagrams.  Thus this conditional equigeneric route is now
historical rather than a missing step in the class-`(1,1)` theorem.

There is a second, independent gap.  Even after a valid curve-side genus bound,
one needs a uniform bound on the fibers of the symmetric determinant map over
highly singular octics.  Generic finiteness over smooth octics does not supply
it: singular curves outside the ADE range can have positive-dimensional
families of torsion-free theta-characteristics.

The separate source-and-deformation audit
[`determinant_fiber_limits.md`](determinant_fiber_limits.md) proves the precise
reduction to varying local self-dual types, checks that two-generation does not
restore finiteness, and records a fixed-determinant tangent space of dimension
at least six at any nonzero-determinant point of a natural ambient jet
stratum.  An
exact symmetric-cubic witness has reduced octic determinant, so this
first-order obstruction occurs on the reduced locus; it is still not an actual
six-dimensional fiber.

The exact curve identity, adjusted numerical margins, and missing theorems are
given below.

## 1. Plane-curve count and the failed genus-three premise

Let `V_(8,<=g_0)` be the locus of reduced plane octics for which the sum of the
genera of the normalization components is at most `g_0`.  For integral plane
curves of degree `d` and geometric genus `g`, the characteristic-zero
equigeneric dimension bound is

\[
 \dim V_{d,g}\le 3d+g-1.
\]

The corresponding reduced-curve bound follows componentwise.  If there are
`s` components of degrees `d_j` and genera `g_j`, their product stratum has
dimension at most

\[
 \sum_j(3d_j+g_j-1)
 =24+\sum_jg_j-s\le23+g_0.
\]

Thus `g_0=3` would give dimension at most 26 and codimension at least 18 in
the full `P^44` of octics; `g_0=4` would instead give dimension at most 27 and
codimension at least 17.

The integral bound is classical; see E. Arbarello and M. Cornalba, *A few
remarks about the variety of irreducible plane curves of given degree and
genus*, Ann. Sci. Ecole Norm. Sup. (4) **16** (1983), 467--488,
[doi:10.24033/asens.1456](https://www.numdam.org/articles/10.24033/asens.1456/).

### Exact genus identity

In the canonical double-plane resolution, the recorded number is

\[
 t_i=\left\lfloor r_i/2\right\rfloor,
\]

where `r_i` is the multiplicity of the **corrected branch**, including any odd
exceptional components through the center.  By contrast, the delta invariant
of the reduced plane curve is computed from the multiplicities `m_i` of its
strict transforms (together with the component correction in the reducible
case).  Thus \(\sum_i\binom{t_i}{2}=3\) is not itself the equality
`delta=18`.

There is, however, a useful exact identity.  Let

- `G` be the total genus of the normalization components;
- `s` be the number of original irreducible components;
- `n_1` be the number of canonical blowups with `t=1`; and
- `o` be the number of blowups at which the corrected multiplicity is odd,
  equivalently the number of exceptional curves inserted into the branch.

A canonical blowup with value `t` replaces the corrected branch class by its
pullback minus `2tE`, lowering its arithmetic genus by
\(\binom{2t}{2}\).  Starting from a plane octic of arithmetic genus 21, three
`t=2` centers and `n_1` centers with `t=1` therefore leave final corrected
branch arithmetic genus `3-n_1`.  The final branch is the disjoint union of
the original normalizations and `o` rational exceptional curves, so its
arithmetic genus is `G-(s+o)+1`.  Hence

\[
 G=2+s+o-n_1.
 \tag{1.1}
\]

If `n_5` counts the three essential centers with corrected multiplicity five
and `n_2` counts the `t=1` centers with corrected multiplicity two, the odd
`t=1` centers cancel between `o` and `n_1`, giving the equivalent formula

\[
 G=2+s+n_5-n_2.
 \tag{1.2}
\]

### The genus-three implication is false

The proposed conclusion `G<=3` fails even after both cluster vanishings are
imposed.  The exact certificate
[`three_center_genus_counterexample.md`](three_center_genus_counterexample.md)
uses

\[
 C=\{yF=0\},\qquad
 F=x^3(x-z)^4+xy^2z^4+y^3(x^4+z^4).
\]

Here the septic `(F=0)` is absolutely irreducible of genus four and the other
component is a line.  The corrected centers are two proper `r=4` points and
one `(r_p,r_q)=(3,4)` cluster.  Their three essential origins are noncollinear,
and the doubled conic conditions are independent, so both cluster systems
vanish.  Formula (1.1) gives `G=2+2+1-1=4`, agreeing with the direct delta
calculation.  The accompanying
[`Macaulay2 certificate`](three_center_genus_counterexample.m2) and
[`log`](three_center_genus_counterexample.log) verify irreducibility, complete
singular support, local types, cluster ranks, and genus.

A universal bound `G<=4` would amount by (1.1) to
`n_1-o >= s-2`.  Degree partitions and the doubled-conic vanishing make this
plausible, but an exhaustive proximity proof for arbitrary Enriques diagrams
is not supplied.  It must therefore remain a separate missing theorem.

## 2. Rank three: theta-characteristic description

Fix a rank-three `sigma`.  Put

\[
 E=\Omega^1_{\mathbf P^2}(1),\qquad
 W=H^0\!\left(\operatorname{Sym}^2E^\vee\otimes O(3)\right),
 \qquad \dim W=42.
\]

A point `q` of `P(W)=P^41` is a symmetric map

\[
 q:E\longrightarrow E^\vee(3),
\]

and its determinant is a plane octic.  Suppose `C=(det q=0)` is reduced and
let `L` be the rank-one torsion-free cokernel on `C`.  Setting `M=L(-3)` gives

\[
 0\longrightarrow E(-3)\xrightarrow{q}E^\vee
 \longrightarrow i_*M\longrightarrow0.
 \tag{2.1}
\]

Dualizing (2.1) into `O(-3)` and using symmetry gives

\[
 M\simeq\mathcal Hom_C(M,\omega_C).
\]

Thus `M` is a torsion-free theta-characteristic.  Cohomology of (2.1) gives
`h^0(M)=3`.  Since `E` is stable and simple, `Aut(E)=G_m`; after
projectivizing there is no positive-dimensional congruence orbit.  Moreover,

\[
 \operatorname{Ext}^1(E^\vee,E(-3))
 =H^1(E\otimes E(-3))=0,
\]

so a fixed `M` has a unique minimal locally free resolution of the displayed
bundle type, up to its bundle automorphisms.  It therefore contributes at most
finitely many projective symmetric maps.  On a smooth octic there are only
finitely many theta-characteristics; hence the determinant map is generically
finite onto its image.

This smooth-curve statement is not enough.  Let `f_3(C)` be the projective
dimension of the fiber over a fixed reduced octic `C`.  If one first proves a
valid uniform curve-side bound `G<=g_0`, Section 1 gives

\[
 \dim\{q:\det q\in V_{(8,\le g_0)}\}
 \le 23+g_0+\sup_C f_3(C).
\]

Hence the fixed-`sigma` codimension in `P^41` is at least

\[
 41-(23+g_0+\sup f_3)=18-g_0-\sup f_3.
\]

The rank-three matrix orbit has dimension eight.  The sweep would therefore
be excluded if one knew the uniform bound

\[
 f_3(C)\le9-g_0.
 \tag{2.2}
\]

For the disproved value `g_0=3` this reads `f_3<=6`.  A still-unproved sharp
replacement `g_0=4` would require the stronger `f_3<=5`.

### Why generic finiteness cannot replace (2.2)

J. Piontkowski, *Theta-characteristics on singular curves*, J. London Math.
Soc. (2) **75** (2007), 479--494,
[doi:10.1112/jlms/jdm021](https://doi.org/10.1112/jlms/jdm021), proves and
emphasizes that curves with non-ADE singularities can have infinitely many
torsion-free theta-characteristics; finite counts are recovered only after a
local type is fixed.  The three-`t=2` frontier includes non-ADE and
infinitely-near singularities.  Consequently, finiteness on smooth curves, or
even on ADE curves, gives no uniform bound on the required fibers.

The local source of this failure is made explicit in J. Piontkowski,
*Self-dual modules over local rings of curve singularities*, J. Pure Appl.
Algebra **207** (2006), 327--339,
[doi:10.1016/j.jpaa.2005.10.001](https://doi.org/10.1016/j.jpaa.2005.10.001):
finite self-dual representation type is a special property, and outside it
there are families of self-dual torsion-free modules.

The two-generator condition by itself does not restore finiteness.  Specialize
Case 1a of the 2006 paper to
\(R=\mathbf C[[t^4,t^5]]\), with normalization
\(\widetilde R=\mathbf C[[t]]\).  Piontkowski's one-parameter family of
pairwise nonisomorphic rank-one self-dual modules becomes

\[
 M_\lambda=R+R(t^2+\lambda t^3)
 =\langle1,t^2+\lambda t^3\rangle+t^4\widetilde R,
\]

which are already generated by two elements.  What is additionally special
here is the **global** Euler-bundle resolution (2.1), including its cohomology
and symmetric identification.  It is possible that this imposes the required
bound `9-g_0` (five under a hypothetical genus-four theorem), but that would be
a new theorem, not a consequence of local generator count or of the usual
smooth determinantal-representation correspondence.

## 3. Rank two: the forced base point and the three-dimensional orbit

Fix the canonical rank-two triple and let `b` be its base point.  On

\[
 Z=\operatorname{Bl}_b\mathbf P^2,
\]

write `H` for the pullback of a line, `R` for the exceptional curve, and
`D=H-R`.  After the common base point is removed, the kernel bundle is

\[
 K=O_Z\oplus O_Z(-D).
\]

The 42-dimensional restricted coefficient space is

\[
 W_2=H^0\!\left(\operatorname{Sym}^2K^\vee\otimes O_Z(3H)\right),
\]

and

\[
 \det(q)\in |8H-2R|\simeq\mathbf P^{41}.
\]

Thus every plane branch octic has a forced double point at `b`.  Moreover,

\[
 \dim\bigl(\operatorname{Aut}(K)/\mathbf G_m\bigr)=3:
\]

the two diagonal scalars and the two-dimensional space
`Hom(O(-D),O)=H^0(O(D))` give a four-dimensional automorphism group, and the
central scalars act trivially after projectivization.  Congruence by this group
preserves the projective determinant.  This explains the generic
three-dimensional determinant fiber.

When the plane octic has multiplicity exactly two at `b` and its strict
transform is reduced, the analogue of (2.1) is a self-dual rank-one
torsion-free sheaf for

\[
 O_C(C-3H)=O_C(5H-2R).
\]

It is not literally an ordinary theta-characteristic on the strict transform,
whose dualizing sheaf is `O_C(5H-R)`.  Any singular-fiber theorem must retain
this marked exceptional-divisor twist.  There is a further boundary issue: if
the reduced plane octic has multiplicity greater than two at `b`, then its
divisor in `|8H-2R|` contains `R`, with multiplicity `mult_b(C)-2`, and can be
nonreduced.  The final three-`t=2` row does not exclude `b` itself from being
an essential center.  Therefore a theorem only about torsion-free sheaves on
reduced strict transforms would still miss part of the rank-two incidence.

The required curve dimension still has a clean plane formulation, conditional
on a valid bound `G<=g_0`.  The incidence of such a reduced octic together with
a singular point has dimension at most `23+g_0`: a reduced curve has only
finitely many singular points.  Projective linear invariance and transitivity
on `P^2` then show that the fiber in which the singular point is the fixed
point `b` has dimension at most `21+g_0`.  Equivalently, this is the expected
surface formula

\[
 -K_Z\mathbin{\cdot}(8H-2R)+g_0-1=21+g_0.
\]

Let `f_2(C)` denote the **total** projective determinant-fiber dimension,
including the three-dimensional congruence orbit.  The fixed-`sigma`
codimension would be at least

\[
 41-(21+g_0+\sup f_2)=20-g_0-\sup f_2.
\]

Since the rank-two matrix orbit has dimension seven, the desired sweep would
be excluded by the uniform bound

\[
 f_2(C)\le12-g_0.
 \tag{3.1}
\]

For `g_0=3` this is the old bound `f_2<=9`; for a conjectural `g_0=4` it is
`f_2<=8`.  Equivalently, after quotienting by `Aut(K)/G_m`, the compatible
self-dual-sheaf family would need dimension at most `9-g_0`.  If one does not
exploit the fixed double point, the required total fiber bound becomes the
stronger `f_2<=10-g_0`.

The generic value `f_2=3` does not prove (3.1): the same singular local-type
jumping that obstructs rank three can enlarge the quotient fiber.

## 4. Exact missing theorem package

The equigeneric strategy would become a proof only after all of the following
were established for some valid integer `g_0`.

1. **Curve-side genus bound:** every reduced octic in the frontier has
   `G<=g_0`.  The proposed value three is false by the explicit counterexample;
   the candidate value four remains unproved for arbitrary reducible and
   infinitely-near diagrams.
2. **Rank-three singular representation bound:** every resulting reduced
   octic `C` satisfies `f_3(C)<=9-g_0` for the resolution-compatible self-dual
   sheaves in (2.1).  If `g_0=4`, the required bound is five.
3. **Rank-two singular representation bound:** every relevant total
   projective determinant fiber satisfies `f_2(C)<=12-g_0`.  For `g_0=4` this
   is eight, or five after quotienting by `Aut(K)/G_m`.  Higher multiplicity
   at `b` also requires the exceptional, possibly nonreduced determinant
   strata.
4. **Rank-two equigeneric bound:** the dimension-at-most-`21+g_0` estimate in
   the fixed-base-point linear system, including reducible curves.

Items 2 and 3 are substantially stronger than generic finiteness of symmetric
determinantal representations.  Piontkowski's result shows why a statement
about all singular theta-characteristics would be false; the bounds must use
the displayed resolutions and their local generator type.  The exact scope of
the available singular-theta results, including the rank-two exceptional
twist and nonreduced strata, is audited in
[`determinant_fiber_limits.md`](determinant_fiber_limits.md).

The genus-three premise has therefore been refuted.  The equigeneric/theta
route remains only a two-stage conditional framework and does not itself
exclude the square-free three-`t=2` row.  The later marked singleton and
separator incidence theorems exclude that row by a different method.
