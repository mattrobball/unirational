# Residual horizontality through the primitive divisor

## Status and verdict

This is a proof certificate, not a completed Lean proof.  It gives a source-faithful route from
the primitive residual equation to horizontality and records the exact interfaces still missing
from the repository.

The key correction is:

* primitivity by itself does **not** say that the chosen residual component is the whole divisor;
  the source explicitly allows other components supported over proper subsets of
  `P^2_x`;
* on a smooth `(2,3)` hypersurface, Grothendieck--Lefschetz and three elementary restriction-sequence
  vanishings turn any such vertical remainder into a common first-block factor of the residual
  equation;
* primitivity then rules out that factor, so the primitive residual divisor is exactly the chosen
  component;
* a positive-first-degree equation together with the quadratic fibre equation always has a common
  point in `P^2_x`.  Hence that divisor, and therefore the component, surjects onto `P^2_y`.

This route proves the no-homogeneous-relation form of horizontality.  Recovering the explicit
nonzero `3 x 3` Jacobian determinant additionally requires the converse Jacobian criterion in
characteristic zero; that converse is not presently in the project.

## Notation

Let

* `P = P^2_x x P^2_y`;
* `X = V(F) subset P`, where `F` has bidegree `(2,3)` and `X` is smooth;
* `M = lineFrame p0 q0 r` and `M * N = 1`;
* `qraw = residualEquationOn M N F`, of bidegree `(10,1)`;
* `qraw = B q`, where `B` uses only the first block and `q` is primitive over the first block;
* `q` has bidegree `(a,1)`, with `a > 0`;
* `D = V_X(q)` is the primitive residual divisor;
* `T` is the scheme-theoretic image of the tangent-residual map from the chosen line surface
  `S_L`.

Here `hgood : ResidualLineNonconstantOn M N F` is the moving-residual-line condition.  It is not
the source's separate condition that `[-2]` be injective on the three points of `C_eta cap L`.

## The proof

### 1. Produce a genuinely bihomogeneous primitive equation

The already-proved facts are

1. `ResidualDivisor.residualEquationOn_isBihomogeneous M N hF`:
   `qraw` has bidegree `(10,1)`;
2. `residualEquationOn_ne_zero_of_nonconstant M N F hgood`:
   `qraw != 0`;
3. `exists_primitive_residualEquationOn_factorization_with_degree_control`:
   `qraw = B q`, `B` has right weight zero, `q` has right weight one, `q` is primitive, and any
   bidegree `(a,1)` carried by this `q` has `a > 0`.

What is still needed is the homogeneous-content theorem: the gcd of the three homogeneous
degree-ten coefficients of `qraw` can be chosen homogeneous.  It gives integers `e,a`, with
`e+a=10`, such that `B` has bidegree `(e,0)` and `q` has bidegree `(a,1)`.  The preceding positivity
lemma then gives `a>0`.

A useful target declaration is:

```lean
theorem exists_primitive_residualEquationOn_bihomogeneous_factorization
    (hF : IsBidegree23 F) (hgood : ResidualLineNonconstantOn M N F) :
    exists e a B q,
      e + a = 10 and
      IsBihomogeneousOfBidegree e 0 B and
      IsBihomogeneousOfBidegree a 1 q and
      q != 0 and IsPrimitiveOverFirstBlock q and
      residualEquationOn M N F = B * q and 0 < a
```

This is not a new geometric hypothesis; it is missing commutative-algebra infrastructure.

### 2. Put the residual component inside `D`

The residual identity gives `qraw=0` on the explicit tangent-residual point.  The relevant
existing identities are `eval_residualYCoordsOn_residualLinearFormOn` and the elementary
evaluation formula for `residualEquationOn` (currently also named `eval_residualEquationOn` in
`ResidualHorizontalityLine.lean`; the formula should be moved to an axiom-free upstream module).

To pass from `qraw = B q` to `q=0`, evaluate in the localized domain used to construct
`residualComponentOn`.  The first-coordinate chart map is injective under smoothness, `v 2 != 0`,
and a nonzero chart denominator; this is the content of
`injective_standardChartEvalAlgebra_residualComponentOnXCoordsNorm`.  Consequently a nonzero
homogeneous `B(x)` stays nonzero.  Since the localized ring is a domain,

```text
0 = qraw(x,y) = B(x) q(x,y),   B(x) != 0
```

implies `q(x,y)=0`.  The scheme-theoretic image therefore factors as a closed subscheme
`T -> D`.

The exact missing consumer should have the shape

```lean
def primitiveResidualZeroLocus ... (q : CoxPolynomial) ... : Scheme

def residualComponentOnToPrimitiveResidualZeroLocus ... : T --> D

instance : IsClosedImmersion residualComponentOnToPrimitiveResidualZeroLocus
```

The source conditions below also imply that the residual-coordinate triple is not identically
zero, allowing the proof to choose a nonzero standard-chart denominator.  This chart-existence
adapter is not yet present without appealing to the current determinant theorem.

### 3. Identify the generic fibres

Let `eta` be the generic point of `P^2_x`, `K0 = k(P^2_x)`, and `C_eta` the generic plane cubic.
Add the two source conditions which `GoodLineExistence.lean` explicitly says are not yet stated or
proved:

* `hlineReduced`: `C_eta cap L` is geometrically reduced of length three;
* `hminusTwoInjective`: the tangent-residual map, equivalently `[-2]` after the usual cubic-group
  identification, is injective on those three geometric points.

Generic smoothness for `X -> P^2_x` makes `C_eta` a smooth, hence geometrically integral, plane
cubic.  The universal residual identity places the three images on `C_eta cap V(q_eta)`.  The
latter is therefore a cubic cut by a nonzero line, with no common component, and has length three.
Three distinct image points exhaust it.
Therefore the base change of `T -> D` over `eta` is an isomorphism, and this generic fibre is
reduced of length three.  In particular:

* `T` is the unique component of `D` dominating `P^2_x`;
* its multiplicity in the Cartier divisor `D` is one;
* every remaining component of `D` is vertical over `P^2_x`.

For formalization, the clean intermediate interface is stronger and safer than a mere cardinality
of underlying points:

```lean
theorem genericFiber_residualComponentOnToPrimitiveResidualZeroLocus_isIso
    (hlineReduced : GenericLineSectionGeometricallyReducedLengthThree ...)
    (hminusTwoInjective : GenericTangentResidualInjectiveOnLineSection ...) :
    IsIso (baseChangeToGenericPoint
      residualComponentOnToPrimitiveResidualZeroLocus)
```

A `Fintype.card = 3` statement alone forgets multiplicities and does not justify subtracting `T`
with coefficient one from `D`.  The repository theorem
`isIso_of_isClosedImmersion_of_genericFibers_card_three_of_noVerticalComponents` is useful only
after reducedness and the no-vertical-components input have separately been supplied.

The generic-fibre adapter itself needs:

1. a scheme model for `C_eta cap L`;
2. the generic-smoothness adapter making `C_eta` geometrically integral;
3. a finite-flat/Bezout length-three theorem for a line section of a plane cubic;
4. the tangent-residual morphism on that scheme;
5. the identification of this morphism with the residual-coordinate formula;
6. the reduced-injective-three-points lemma upgrading it to an isomorphism onto
   `C_eta cap V(q_eta)`.

None of these six interfaces is assembled in the required form.  In particular,
`Standard/ResidualLineMapInjective.lean` proves rigidity of the map from lines to residual lines;
it is not the required injectivity of `[-2]` on the three points of one line section.

### 4. Eliminate every vertical remainder

This is the new Picard/primitivity bridge.

Because `X` is smooth, the prime divisor `T` and the Cartier divisor `D` may be compared as Weil
divisors.  By Step 3,

```text
D = T + E
```

with `E` an effective divisor supported vertically over `P^2_x`.

Grothendieck--Lefschetz for the smooth ample `(2,3)` divisor gives

```text
Pic(X) = Z Hx + Z Hy.
```

Write `[T] = alpha Hx + beta Hy`.  Restriction to a general cubic fibre of
`X -> P^2_x` has degree `3 beta`; Step 3 says that this degree is three, hence `beta=1`.  Since
`[D]=a Hx+Hy`,

```text
[E] = c Hx,   c = a-alpha.
```

Initially `c` is an integer.  If `E` is nonempty, its canonical section is a nonzero element of
`H^0(X,O_X(c,0))`.  The restriction sequence for `X` and

```text
H^1(P^2 x P^2, O(c-2,-3)) = 0
```

show that this section lifts from the ambient product.  A nonzero ambient section forces `c>=0`;
if `c=0` it is constant and has empty divisor.  Thus a nonempty `E` forces `c>0`, and the lifted
section is a homogeneous polynomial `b(x)` of degree `c` with `E=div_X(b)`.

Since `E <= div_X(q)`, division by its canonical section produces

```text
r_X in H^0(X,O_X(a-c,1)),   q|_X = b|_X * r_X.
```

The two further vanishings

```text
H^1(P^2 x P^2, O(a-c-2,-2)) = 0,
H^0(P^2 x P^2, O(a-2,-2)) = 0
```

first lift `r_X` to a bihomogeneous polynomial `r` of bidegree `(a-c,1)` and then make the equality
unique upstairs.  Hence

```text
q = b(x) r
```

in the Cox polynomial ring itself.  Primitivity says `b` is a unit.  A nonzero homogeneous
first-block polynomial of positive degree is not a unit, so `c=0`; the only effective divisor in
the resulting constant linear system is the empty divisor.  Therefore `E=0` and

```text
D = T
```

scheme-theoretically.

The needed formal Picard/divisor package is:

1. integrality/regularity of the smooth ample hypersurface `X`;
2. Grothendieck--Lefschetz in the form `Pic(X) ~= Z x Z`, identifying `(a,b)` with
   `O_X(a,b)`;
3. conversion of a codimension-one integral closed subscheme of regular `X` to an effective
   Cartier divisor;
4. additivity of divisor classes and computation of the `Hy` coefficient from the degree on a
   generic cubic fibre;
5. the three displayed cohomology vanishings and the induced surjectivity/injectivity statements
   on global sections;
6. the elementary algebraic endpoint saying that a bihomogeneous first-block factor of a
   primitive polynomial is a unit.

Mathlib currently has no usable Grothendieck--Lefschetz/Picard implementation for this step.  The
three cohomology calculations are standard Kunneth calculations using
`H^1(P^2,O(d))=0` for every `d`; they should be exposed directly as the exact restriction-map
lemmas consumed here.

### 5. A positive-first-degree complete intersection is horizontal

Now fix any geometric point `y` of `P^2_y`.  Specialization in `y` gives two homogeneous
polynomials in the three `x`-coordinates:

```text
F_y       of degree 2,
q_y       of degree a > 0.
```

Over an algebraically closed field, two positive-degree homogeneous polynomials in three variables
have a common nonzero zero.  This is already formalized as
`exists_common_nonzero_zero_pair`.  Thus every `y` has a lift to `D`.  The projection
`D -> P^2_y` is proper, so closed-point surjectivity gives scheme-theoretic surjectivity (the
existing proof of `surjective_residualImageToBase_of_smooth_bidegree23` is the model to
generalize).

Since `D=T`, the residual component dominates, in fact surjects onto, `P^2_y`.  If a homogeneous
form `Psi(y)` vanishes on the explicit residual coordinates, it vanishes on the scheme-theoretic
image `T`, hence at every projective `y`.  For positive degree it also vanishes at the origin, so
polynomial extensionality gives `Psi=0`; degree zero is immediate.  This proves the conclusion of
`eq_zero_of_aeval_residualYCoordsOn_of_isHomogeneous` without using the determinant.

A reusable target theorem is:

```lean
theorem surjective_primitiveResidualZeroLocusToSecond
    (hF : IsBidegree23 F)
    (hq : IsBihomogeneousOfBidegree a 1 q) (ha : 0 < a) :
    Surjective (primitiveResidualZeroLocusToSecond F q)
```

Its pointwise core is already `exists_common_nonzero_zero_pair`; only the arbitrary-`q`
zero-locus packaging and proper/Jacobson upgrade are missing.

### 6. Relation to the explicit determinant

The preceding argument proves dominance/no homogeneous relation.  The current sorry is stated as
the stronger coordinate certificate

```text
det [Y; dY/dt; dY/ds] != 0.
```

In characteristic zero the two statements are equivalent after choosing a nonzero `Y_j`: the
displayed determinant, divided by `Y_j^3`, is the two-variable Jacobian determinant of two affine
ratios `Y_i/Y_j`; algebraic independence of those ratios forces that Jacobian to be nonzero.
Only the forward direction is presently formalized in `AlgebraicIndependenceJacobian.lean`.

Therefore there are two honest implementation choices:

1. make the no-homogeneous-relation theorem the primary geometric result and route downstream
   dominance through it, leaving the determinant as a separate optional certificate; or
2. add a characteristic-zero converse Jacobian criterion for two rational functions and derive
   `det_residualYCoordsOn_ne_zero` from the geometric theorem.

The first option is shorter and matches the theorem actually consumed downstream.

## Hypotheses to add to the current theorem

The current signature already contains the field, smoothness, moving-line, section, and stereo
nondegeneracy assumptions.  For this primitive-divisor proof, add either the following natural
source hypotheses:

```text
hlineReduced:
  the geometric generic line section C_eta cap L is reduced of length three;

hminusTwoInjective:
  the tangent-residual map is injective on those three geometric points.
```

or, at the lower-level scheme theorem, replace them by the single packaged consequence

```text
hgenericIso:
  the generic-fibre base change of T -> D is an isomorphism onto a reduced length-three scheme.
```

The source's condition that the generic conic of `S_L -> L` be smooth is already a consequence of
the current smoothness/frame assumptions at the polynomial level via
`lineConicDiscriminant_ne_zero_of_smooth`.  What remains to be proved is the scheme-level adapter
from that discriminant statement and the nondegenerate stereo parametrization to integrality and
birational parametrization of `S_L`.  If that adapter is not built first, an interim theorem must
also assume this packaged `S_L` integrality/birationality statement.

Likewise, smoothness of the generic cubic of `X -> P^2_x` follows mathematically from generic
smoothness in characteristic zero, as in section 1 of the source certificate.  Its exact
scheme/function-field adapter is still a formal lemma to provide, not an independent geometric
hypothesis of the final theorem.

The primitive bihomogeneous factorization, Grothendieck--Lefschetz, restriction-map results, and
common-zero surjectivity are consequences to prove from the existing hypotheses, not additional
geometric assumptions.  If the goal is an immediately typecheckable bridge before those libraries
exist, package them explicitly as hypotheses in a lower-level theorem; do not present that
lower-level theorem as the all-smooth result.

## A route that must not be used

Do not try to deduce

```text
rename Sum.inr Psi in radical(span {F,q})
```

merely from projective vanishing on `D=T`.  At the irrelevant affine locus `x=0`, both positive
first-degree equations `F` and `q` vanish automatically while a nonzero `Psi(y)` need not vanish.
Projective equality therefore gives only saturated/localized membership.  This is exactly why the
obvious ideal inclusion for a chosen component points in the wrong direction in
`component_secondBlock_comap_eq_bot_of_le_completeIntersection`.

The divisor-factor argument above is what removes the first-block denominator honestly.

## Formal boundary

The conditional algebraic endpoint is now installed in
`BConicBundleMultisections/ResidualPrimitiveDivisorExhaustion.lean`:

* `ResidualPrimitiveDivisorExhaustedOn` is the closed-point relation-kernel consequence of `T=D`;
* `SourceFaithfulGoodLineOn` packages it with a positive-bidegree primitive factorization and the
  moving-line condition;
* `eq_zero_of_aeval_residualYCoordsOn_of_primitiveDivisorExhausted` proves the no-relation theorem
  from that interface and `exists_common_nonzero_zero_pair`.

That file is axiom-clean, but the geometry producing its exhaustion hypothesis is not yet
installed.  In particular:

* `ResidualHorizontalityLine.lean` has not been edited;
* no claim is made that the current `sorry` is closed;
* the strongest axiom-clean pieces already on disk are the primitive right-degree-one
  factorization, the bidegree `(10,1)` calculation, first-projection dominance of the explicit
  chart, the abstract generic-fibre/no-vertical exhaustion criterion, and the projective
  common-zero theorem;
* the two genuinely large missing packages are the generic three-point scheme adapter and the
  Grothendieck--Lefschetz/effective-divisor restriction argument.
