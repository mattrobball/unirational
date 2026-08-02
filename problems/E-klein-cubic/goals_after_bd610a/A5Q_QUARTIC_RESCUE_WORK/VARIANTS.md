# Post-refutation variant ledger

This file records only exact consequences for the two transported
degree-eleven cycles.  It does not turn a residual zero-cycle, a gcd of
degrees, or a Galois-orbit calculation into a rational point.

## Exact coset-action screen

Write `Omega_i=G/H_i` for the two nonisomorphic eleven-point transitive
`G=PSL_2(F_11)`-sets.  Enumeration from the two sealed matrix-generator
pairs gives the following characteristic-independent table.

| construction | orbit sizes | point/pair stabilizer |
|---|---:|---|
| `Omega_i` | `11` | `A5`, order `60` |
| ordered distinct pairs in one `Omega_i` | `110` | `S3`, order `6` |
| unordered pairs in one `Omega_i` | `55` | dihedral, order `12` |
| `Omega_1 x Omega_2` | `55 + 66` | respectively `A4` and dihedral of order `10` |

Thus each action on `Omega_i` is doubly transitive.  The two cross-orbits
have valencies five and six on both sides.  In particular there is no
`G`-equivariant bijection `Omega_1 -> Omega_2`: such a bijection would
conjugate `H_1` to `H_2`, contrary to the sealed two-class enumeration.

This has one precise geometric consequence.  A descended construction that
joins *one corresponding conjugate* of the first cycle to one corresponding
conjugate of the second cannot exist.  Every nonempty `G`-stable relation of
cross-pairs contains `55`, `66`, or all `121` pairs, not eleven.  It therefore
does not produce an eleven-line matching, nor a ruling whose distinguished
fibres pair the two cycles one-to-one.

This does **not** exclude a common scroll or rational curve by itself.  A
`K`-rational `P1` can carry closed points with the two nonisomorphic
degree-eleven residue fields, and a scroll can contain the cycles without
its ruling inducing a matching.  Excluding those possibilities requires an
actual common ideal/rank calculation.  The rank-eleven certificate for each
cycle separately only excludes genus-zero stable maps of total degree at
most four through that cycle; it is not a combined two-cycle theorem.

## Degree-five residual quartic

For a genus-zero stable map of degree `d` through either cycle, quadratic
evaluation factors through a space of dimension `2d+1`.  Since the replayed
quadratic rank is eleven, `d>=5`; at `d=5` the inequality is an equality and
gives no obstruction.  The next exact gate is therefore

```text
a U_i subset <1,x,x^2,x^3,x^4,x^5>_K
```

for a primitive `x in L_i` and `a in L_i^*`, together with the basepoint and
cubic checks.  No solution of this incidence is asserted here.

Conditionally, suppose a basepoint-free quintic map `phi` does interpolate
one cycle.  Then

```text
F(phi)=g_tau q_4,
```

where `q_4` is a binary quartic over `K`; if the left side is nonzero, the
irreducible degree-eleven factor `g_tau` is automatically coprime to `q_4`.
Hence `q_4` gives a scheme-theoretic effective degree-four residual
zero-cycle on `X_T`.  There are three cases.

1. If `F(phi)=0`, the image is already a `K`-rational curve on `X_T`.
2. If `q_4` is reducible, nonreduced, or irreducible with an imprimitive
   transitive Galois group (`C4`, `V4`, or `D4`), repeated quadratic secant
   descent produces a `K`-point (or a `K`-line in a contained-line case).
3. The only quartic-field cases not decided by that elementary descent are
   the primitive groups `A4` and `S4`.

The last two groups are exactly the arithmetic types left open by the
installed Sarkisov quartic analysis.  This is only compatibility of Galois
type.  The residual divisor above is a zero-dimensional cycle over `K` on
`X_T`, whereas the Sarkisov object is an integral curve finite of degree four
over the pencil base, equivalently a point of the generic cubic surface over
`K(q)`.  Identifying them would require a family of quintic interpolations
over `K(q)`, the graph equation, normalization/flatness, and all centre and
denominator checks.  A single quintic interpolation over `K` supplies none
of that data.

## Direct secants and tangents

For either one cycle, all unordered pairs form the single orbit of size
`55`.  If their lines are not contained in the cubic, residual third
intersection defines a `G`-equivariant map from that orbit.  Its stabilizer
contains the order-twelve dihedral pair stabilizer, which is maximal in
`G`; consequently its image has degree `1` or `55`.

The degree-one case cannot occur for this direct construction.  If every
pair had the same residual point, every pairwise joining line would pass
through that point, forcing all eleven points to be collinear.  The replayed
point rank is five (and the quadratic rank is eleven), so they are not
collinear.  Thus the residuals form a degree-`55` orbit.  If one pair-line is
contained in the cubic, pair transitivity makes the whole pair orbit a
contained-line construction instead; there is then no residual point to
promote.

For cross-secants, the two domains have sizes `55` and `66`.  A constant
residual is again impossible.  At a fixed endpoint there are respectively
five or six partners.  Constancy would put at least five points of the other
cycle on one line, whereas quadratic rank eleven makes every four of its
eleven points linearly independent as quadratic evaluation rows.  The
possible noncontained residual outputs therefore have degree `11`, `55`, or
`66`, but not degree one; degree `11` is the uniform-tangency collapse to an
endpoint projection.  Contained cross-lines again give no residual point.

A tangent construction is different.  One must first specify over `L_i` an
actual tangent line at `P_i` and descend its eleven conjugates.  An
equivariant residual map from `Omega_i` can have image degree `1` or `11`
because `H_i` is maximal.  The group action does not decide between them,
and this packet supplies no descended tangent direction or residual point.

## Authorized scope

The exact variant screen proves:

* degree five is the first interpolation degree not killed by quadratic
  rank, but no degree-five map has been constructed;
* nonconjugacy kills the naïve eleven-line matching, not every common scroll
  or rational curve;
* direct secants of the installed conjugates do not yield a degree-one
  residual cycle; and
* tangent residuals remain uninstantiated.

Accordingly no variant supplies the actual point or explicit rational curve
required by A5Q.4, and no additional exit or headline is claimed.
