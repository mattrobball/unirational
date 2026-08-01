# Centre realizability and the global countermodel

## 1. What must be decided

Goal J asks for a class of invariants carried by **every** source-side
equivariant resolution tree and disjoint from the target fixed/Prym/Hodge
data.  Resolution towers are not minimal objects: after resolving a rational
map, one may blow up any further smooth \(G\)-invariant centre, and the
composite is still a resolution of the same map.  Thus every proposed
obstruction must either be invariant under such refinements or impose a
canonical minimality theorem tied to the base ideal.

The listed one-motive and Hodge data are not refinement-invariant.  There is
also a prior functoriality gap: equivariant dominance does not imply dominance
on fixed loci.  For example, let an involution act on an elliptic curve \(A\)
by translation by a nonzero point of \(A[2]\), hence freely, and act trivially
on a smooth projective variety \(Y\).  The projection

\[
A\times Y\longrightarrow Y
\]

is a dominant equivariant morphism, but \((A\times Y)^t=\varnothing\) while
\(Y^t=Y\).  Thus no general theorem forces the target elliptic component
\(E_t\subset X^t\) to receive a map from \(Z^t\).  The propagation result in
`BLOWUP_FORMULA.md` begins only after such a nonconstant fixed-component map
has independently been proved.

## 2. Free-orbit embedding lemma

**Lemma.** Let a finite group \(G\) act faithfully on \(\mathbf P^n\), with
\(n\ge4\), and suppose every nonidentity element has projective fixed locus
of codimension at least two.  Let \(C\) be a smooth projective curve.  For a
sufficiently positive embedding parameter, a general embedding
\(i:C\hookrightarrow\mathbf P^n\) has

\[
i(C)\cap g i(C)=\varnothing\qquad(g\ne1).
\]

**Proof.** Work in a nonempty open parameter space of embeddings obtained
from a sufficiently positive line bundle.  For fixed \(g\ne1\), consider

\[
\{(i,x,y):i(x)=g i(y)\}.
\]

For \(x\ne y\), two-point evaluation is dominant and the graph of \(g\) has
codimension \(n\) in \(\mathbf P^n\times\mathbf P^n\).  Allowing
\((x,y)\in C^2\setminus\Delta\) leaves codimension at least \(n-2>0\) in
the embedding parameter space.  On the diagonal, the condition is
\(i(x)\in\operatorname{Fix}(g)\); one-point evaluation is dominant and the
fixed locus has codimension at least two, so allowing \(x\in C\) again leaves
positive codimension.  Avoid the finitely many resulting proper closed
subsets, one for each \(g\ne1\).  Then all translates are disjoint, and
equality \(g i(C)=i(C)\) is impossible.  \(\square\)

For the exact Klein representation, the hypothesis is certified by the
eigenspace stratification: an involution has largest fixed projective
component \(\mathbf P^2\subset\mathbf P^4\), and every other nonidentity
class has fixed components of no larger dimension.

Taking \(n=4\),

\[
B=\bigsqcup_{g\in G}g i(C)
\]

is a smooth \(G\)-invariant centre with 660 components and trivial component
stabilizer.

## 3. Realizing the target Hodge and polarization data

Choose \(C\) as in `HODGE_ISOGENY.md`, so \(J(X)\) is an isogeny factor of
\(J(C)\), and apply the free-orbit embedding lemma.  Blowing up \(B\)
realizes the split \(G\)-Hodge inclusion

\[
H^3(X,\mathbf Q)\hookrightarrow
H^1(C,\mathbf Q)(-1)\otimes\mathbf Q[G].
\]

The induced positive form is a positive rational multiple of the natural
theta form.  Since no nontrivial subgroup fixes a component, this operation
does not alter any \(Z^H\) for \(H\ne1\).  It also accounts for the warning in
Goal J about exchanged centres: such orbits contribute global invariant
diagonals without appearing in the corresponding fixed tree.

This construction is available as a further refinement of any existing
resolution.  The images in \(\mathbf P^4\) of the finitely many original
blowup centres have codimension at least two.  Add their avoidance to the
incidence conditions in the lemma; the free orbit then lifts isomorphically
to the resolved space and remains smooth and disjoint.  Blowing up that lift
preserves the resolved morphism.  No base-locus property is needed for a
refinement.

## 4. Realizing the fixed affine and incidence data

The source ambient projective space and the target ambient projective space
are the same \(G\)-variety \(\mathbf P(W)\).  Consequently the actual target
arrangement

\[
\mathcal A=\bigcup_t(E_t\cup L_t)\subset\mathbf P(W)
\]

is already a \(G\)-stable closed arrangement in the source.  It carries,
tautologically, the same:

- \(D_{12}/C_2\simeq S_3\) affine action on each \(E_t\);
- type-I, type-II, and \(C_6\) marked permutation sets;
- \(V_4,A_4,D_{12}\) and other multiple-fixed incidences;
- restrictions and norms induced by subgroup inclusions.

Characteristic-zero functorial embedded resolution of the ideal of
\(\mathcal A\) is \(G\)-equivariant.  After resolving its point and
multiple-curve intersections, the strict transforms of the elliptic
components are a disjoint smooth \(G\)-stable centre.  Blowing them up creates
exceptional projective bundles over \(E_t\).  By `BLOWUP_FORMULA.md`, their
Albanese torsors and generalized Picard varieties are exactly those of the
base elliptics, with the same normalizer action.  The preceding exceptional
divisors record the resolved marked-incidence tree.

This is an admissible source blowup tower carrying the target fixed-centre
one-motive data.  It is not asserted to resolve a landing covariant; its role
is to refute the claimed separation of *all admissible source trees* by the
listed invariant.

## 5. Combining the two stabilizations

Choose the free-orbit curve \(B\) generally disjoint from the finite union of
curves in \(\mathcal A\).  The two constructions can then be performed in
either order.  One resulting smooth \(G\)-equivariant blowup tower over
\(\mathbf P^4\) has simultaneously:

1. the target affine Albanese class and marked generalized-Jacobian
   restriction/norm/incidence system;
2. a split copy of the complete target \(G\)-Hodge structure;
3. the target polarization up to the positive rational scalar that the
   dominant-map splitting can detect;
4. no interaction between the free-orbit Hodge centre and nontrivial-subgroup
   fixed loci.

This is the global countermodel required for a route-level decision.

## 6. Why degree, genus, and Hilbert screens cannot repair the invariant

The construction uses sufficiently positive embeddings.  Therefore no
finite degree or genus budget independent of the degree of the hypothetical
landing map can exclude it.  The current repository has no all-degree bound
forcing resolution centres to belong to a finite Hilbert list.  Adding such a
bound would be a new base-ideal/landing-equation theorem, not a refinement of
the one-motive or Hodge invariant.

Similarly, declaring only "minimal" resolutions admissible does not repair
the argument without:

- a canonical equivariant minimal resolution in dimension four;
- proof that every dominant rational map admits it;
- proof that its centre data are invariant under allowed factorizations; and
- an exact coupling to the polynomial base ideal.

None is available, and arbitrary smooth refinements are explicitly allowed
by the phrase "any resolved dominant map."

## 7. Global verdict

The exact J4 incompatibility statement is refuted for the invariant as
specified.  The correct exit is

```text
J-INVARIANT-TOO-WEAK
```

The route is completely decided at its honest theorem boundary.  The overall
\(\operatorname{PSL}_2(\mathbf F_{11})\)-unirationality problem remains
open.
