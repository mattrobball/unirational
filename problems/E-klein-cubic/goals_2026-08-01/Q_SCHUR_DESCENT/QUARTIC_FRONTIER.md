# Exact quartic frontier

Let `X=X_Schur/K` be the genuine generic Schur twist.  Choose a general
`K`-hyperplane in the split ambient `P4`.  Bertini over the infinite field
`K`, together with avoidance of the finite orbit of 55 lines and their
pairwise intersections, gives a smooth cubic surface

\[
S=X\cap\mathbf P^3_K
\]

whose intersection with the certified `D12` line orbit is a reduced closed
point of exact degree 55.  A general line in this `P3` also cuts a degree-3
cycle.  Hence `S` has index one.

Claire Voisin's Theorem 1.5 and Remarks 1.6--1.7 in *Rank 2 vector bundles
and degrees of points of del Pezzo surfaces*, arXiv:2509.17996v2, imply

\[
S(K)\ne\varnothing
\quad\text{or}\quad
S\text{ has an effective zero-cycle of degree }4.
\]

The source is <https://arxiv.org/abs/2509.17996>.  It applies over every
characteristic-zero field; no arithmetic-field or local-global hypothesis is
used.

If `X(K)` is empty, the degree-four cycle cannot have a degree-one component.
It also cannot have a degree-two component: the line through the quadratic
conjugate pair has a residual `K`-point on the cubic, with the contained-line
case even easier.  Thus the alternative sharpens to

\[
\boxed{X(K)\ne\varnothing\quad\text{or}\quad
X\text{ has one integral closed point of exact degree }4.}
\]

There is one further exact refinement.  If the Galois group of the quartic
point preserves a partition of its four embeddings into two pairs, take the
residual third intersection on each conjugate-pair secant.  The two residual
points form a degree-two cycle over `K`, again forcing a `K`-point.  Therefore,
under the no-point hypothesis, the quartic action is primitive.  Exhaustion
inside `S4` leaves precisely `A4` and `S4` as possible Galois-closure groups.

The quartic must also span the full hyperplane `P3`.  A span of dimension at
most one gives a `K`-point or a `K`-line contained in the cubic.  If it spans
a plane, the at least two-dimensional linear system of plane conics through
the quartic has a member meeting the plane cubic properly.  Bezout leaves an
effective cycle of degree `2`, and secant descent again gives a `K`-point.

Let `E/K` be the certified Schur splitting field, with Galois group
`PSL(2,11)`, and let `N/K` be the Galois closure of the surviving quartic.
Then

\[
E\cap N=K.
\]

Indeed, the intersection is Galois over `K`, so its Galois group is a common
quotient of the simple group `PSL(2,11)` and `A4` or `S4`.  The only quotient
of `PSL(2,11)` small enough is trivial.  Thus the quartic is linearly disjoint
from `E`; the absence of index-four subgroups in `PSL(2,11)` cannot eliminate
it.

There is nevertheless a canonical cubic-resolvent descent.  Over `N`, write
the four conjugates as `P0,...,P3`.  No chord `PiPj` can lie in the smooth
cubic surface: `A4` and `S4` are transitive on the six chords, while a cubic
surface containing all six edges of a tetrahedron is singular at its four
vertices.  Let `Qij` be the third point of `PiPj` on the surface.  For each of
the three partitions

```text
01|23,  02|13,  03|12,
```

the pair of residual points is defined over the corresponding cubic
resolvent field `M`.  If they coincide, their common point is in `S(M)`; if
their joining line is contained in `S`, that `M`-line has an `M`-point; and
otherwise its third intersection is in `S(M)`.  Hence the quartic supplies a
point over a degree-three field.  Its Galois closure is `C3` in the `A4` case
and `S3` in the `S4` case.

This cubic point is not a ground-field point: every cubic surface already has
degree-three zero-cycles from line sections.  The construction is recorded
because it is the exact resolvent geometry that any further descent must use.

The tempting next identity also fails.  If the three partition-residual
points were always collinear, their line would be `K`-defined and its third
intersection could force a point.  The exact audit in `parallel/root_secant/`
constructs five smooth cubic surfaces over `QQ` through four marked vertices;
in every example the three residuals have projective rank three.  This
refutes universal collinearity, while leaving open a genuinely Schur-specific
identity.

There is a twisted-cubic link, but no decreasing ladder.  After a primitive
element is chosen, the full
span quartic determines a `K`-twisted cubic whose intersection with `S` is
the reduced partition `4+5`.  Balestrieri's construction applied to the
linked quintic uses the same lift and returns the original quartic:

```text
4 -> 5 -> 4.
```

The quartic and quintic residue fields are linearly disjoint and have
compositum degree 20.  Their Galois closures are disjoint in the `A4` case;
in the `S4` case their only possible overlap is the discriminant quadratic,
over which the quintic remains integral.  The combined Galois closure is
also disjoint from the degree-660 Schur field.  Finally, restriction of cubic
forms to the twisted cubic is surjective, so sharing that curve imposes no
hidden splitting-field relation.  Exact certificates are in
`parallel/quartic_descent/`.

Known rational-curve counts do not presently close the gap.  After the
relation `H^3=3[pt]` and the divisor equation are both applied, Zinger's
degree-three invariant gives 8 twisted cubics through three general points;
the degree-four virtual invariant gives 192 rational quartics through four
general points.  The latter permits fixed-point-free regular `A4` and `S4`
orbits.  In the `A4` branch the resolvent group is `C3`, so a reduced
enumerative eight-element fibre whose curves split over that cubic closure
would have a fixed twisted cubic.  However, neither splitting nor membership
of the special secant-resolvent triple in the general locus is proved, and
specialization can introduce boundary maps or multiplicities; in the
`S4/S3` branch even an eight-element set can be fixed-point-free.  See
`parallel/curve_incidence/` for the exact conditional gate and replay.

The two missing hypotheses have now been separated exactly.  A rational
quartet on the split Klein cubic has resolvent differential ranks `9`, `10`,
and `6` for the absolute, joint-hyperplane, and fixed-section maps, proving
that general quartets do land in the good incidence locus.  Voisin's passage
to a generic Hilbert subscheme followed by Fulton specialization gives no
avoidance theorem for the particular quartic, however.  Independently, the
generic three-marked twisted-cubic incidence space is integral and maps to
`X^3` with degree eight.  Thus, even after the three marked points are split,
the generic incidence algebra is one degree-eight field; it is not split by
their cubic closure.  Details and replays are in `parallel/incidence_generality/`
and `parallel/incidence_splitting/`.

If an individual incidence object did descend, the remaining bridge would
be automatic.  The proof in `parallel/fixed_curve_bridge/` shows that every
actual `K`-defined genus-zero stable map of odd projective degree has a
`K`-point on its domain, even when reducible.  It also extends the audited
theta-desingularization argument from `K_proj` to the correct Schur field and
shows that every actual generalized-twisted-cubic Hilbert point yields a
point on `X`.

This is a strict frontier, not a headline resolution.  Primitive quartic
points are the surviving Coray--Cassels--Swinnerton-Dyer case, and their
residue fields are in fact linearly disjoint from the degree-660 Schur
splitting field in the no-point branch.  Voisin's proof works with cycle
classes, generic Hilbert schemes, and Fulton specialization; it does not
preserve the support field of the original degree-55 point.
