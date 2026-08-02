# Exact degree-four interpolation incidence

## Scope and current witness boundary

This note gives the exact incidence attached to one transported closed point

\[
 Z=\operatorname {Spec}(L)\longrightarrow X_T\subset \mathbf P^4_K,
 \qquad [L:K]=11,
\]

where `L/K` is separable and

\[
 P=(P_0:\cdots:P_4)\in X_T(L)
\]

is a fixed nonzero representative.  Nothing in the abstract derivation below
constructs `L` or `P`; those are inputs from `SUBGROUP_DESCENT.md`.  The final
table records the independently replayed good-reduction witnesses for the two
transported cycles.

Write

\[
 U=\langle P_0,\ldots ,P_4\rangle_K\subset L,
 \qquad r=\dim_K U.
\]

The distinction between `r=5` and `r<5` is binding.  The familiar equality
with a five-term power segment is valid only when `r=5`; in general the right
condition is an inclusion.

## Affine parameter for the degree-eleven point

Every exact degree-eleven point of `P1(L)` is finite in every fixed
`K`-rational affine chart: the omitted point at infinity is `K`-rational.
Thus write

\[
 \tau=(1:x),\qquad x\in L.
\]

Since `[L:K]=11` is prime, `tau` has exact degree eleven if and only if
`x notin K`.  In that case `K(x)=L`, and

\[
 1,x,x^2,\ldots ,x^{10}
\]

are linearly independent.  In particular evaluation in degree at most four

\[
 \operatorname {ev}_x:K[T]_{\leq4}\longrightarrow L,
 \qquad q\longmapsto q(x),
\tag{2.1}
\]

is injective.  Put

\[
 V_x=\langle1,x,x^2,x^3,x^4\rangle_K\subset L.
\tag{2.2}
\]

If `1,e_1,...,e_10` is the fixed replay basis of `L`, the exact-degree open
inside the affine eleven-space of `x` is the complement of

\[
 x_1=\cdots=x_{10}=0.
\tag{2.3}
\]

Consequently a projective or affine elimination must saturate by the ideal
`(x_1,...,x_10)`.  Merely solving one normalization chart is not an
emptiness certificate.

## The exact `55 x 36` linear system

Let

\[
 q_j(T)=\sum_{k=0}^4 c_{j,k}T^k,
 \qquad 0\leq j\leq4,
\]

and let `a=sum a_l e_l in L` be the common projective multiplier.  The
interpolation equations are

\[
 q_j(x)=aP_j\quad(0\leq j\leq4).
\tag{3.1}
\]

Let `E(x)` be the `11 x 5` matrix whose columns are the coordinates of
`1,x,...,x^4`, and let `M(P_j)` be the `11 x 11` multiplication matrix of
`P_j` in the replay basis.  Expanding (3.1) gives

\[
 A_P(x)
 \begin{pmatrix}c_0\\c_1\\c_2\\c_3\\c_4\\a\end{pmatrix}=0,
\tag{3.2}
\]

with the exact block matrix

\[
A_P(x)=
\begin{pmatrix}
E(x)&0&0&0&0&-M(P_0)\\
0&E(x)&0&0&0&-M(P_1)\\
0&0&E(x)&0&0&-M(P_2)\\
0&0&0&E(x)&0&-M(P_3)\\
0&0&0&0&E(x)&-M(P_4)
\end{pmatrix}.
\tag{3.3}
\]

This is a `55 x 36` matrix: there are twenty-five quartic coefficients and
eleven coordinates of `a`.  For exact-degree `x`, `E(x)` has rank five.  If
a vector in the kernel had `a=0`, injectivity of (2.1) would force every
`c_j=0`.  Hence every nonzero kernel vector automatically has `a != 0`, and
`a` is a unit because `L` is a field.  It follows that

\[
 \boxed{\text{degree-four projective interpolation at }x
 \iff \operatorname {rank}A_P(x)\leq35.}
\tag{3.4}
\]

Thus all `36 x 36` minors of (3.3), together with the exact-degree
saturation (2.3), give a complete determinantal formulation.  The kernel is
projective, so (3.2) already quotients the common `K^*` scaling of the five
quartics and `a`.

For computations it is often smaller to use the equivalent inclusion
matrix.  If `u_1,...,u_r` is a basis of `U`, form the `11 x (5+r)` matrix

\[
 B(x,a)=
 [\,1\;x\;x^2\;x^3\;x^4\;au_1\;\cdots\;au_r\,].
\tag{3.5}
\]

With `[a] in P(L)=P^{10}_K`, interpolation is equivalent to all `6 x 6`
minors of (3.5) vanishing.  This is precisely the condition
`aU subset V_x` proved next.

## Power-segment criterion, including dependent coordinates

**Proposition 4.1.**  For primitive `x` the following are equivalent.

1. There are five binary quartics over `K` and `a in L^*` satisfying
   `q_j(1,x)=aP_j` for all `j`.
2. `aU subset V_x` for some `a in L^*`.

If `r=5`, these are further equivalent to

\[
 aU=V_x.
\tag{4.1}
\]

*Proof.*  Evaluation (2.1) identifies the five-dimensional vector space of
binary quartics with `V_x`.  Equations (3.1) therefore imply
`aU subset V_x`.  Conversely, each `aP_j in V_x` has a unique inverse under
(2.1), producing the required `q_j`.  If `r=5`, multiplication by nonzero
`a` preserves dimension, so the inclusion of two five-dimensional spaces is
an equality.  This also proves the converse.  QED.

When `r=5`, the coefficient rows `q_0,...,q_4` are linearly independent:
their evaluations are the independent elements `aP_0,...,aP_4` and (2.1)
is injective.  Hence their `5 x 5` coefficient matrix is invertible.  They
form a basis of `H0(P1,O(4))`, are automatically basepoint-free, and define
a target-linear transform of the rational normal quartic.  No separate
basepoint saturation is needed in this case.

When `r<5`, (4.1) is false for dimension reasons even when interpolation
exists.  The exact criterion remains the inclusion `aU subset V_x`; the
resulting linear system has dimension `r` and may have basepoints or a
linearly degenerate image.  An emptiness argument based only on equality in
(4.1) would therefore be invalid unless `r=5` has first been certified.

The criterion is independent of the chosen representative of `P`.  Replacing
`P` by `dP`, `d in L^*`, replaces `U` by `dU` and `a` by `ad^{-1}`.

## `PGL2` and exact quotient scope

For

\[
 y=\frac{\alpha x+\beta}{\gamma x+\delta},
 \qquad
 \begin{pmatrix}\alpha&\beta\\\gamma&\delta\end{pmatrix}
 \in\operatorname {GL}_2(K),
\]

the denominator cannot vanish: otherwise primitive `x` would lie in `K`.
The fourth symmetric-power change of basis gives

\[
 V_y=(\gamma x+\delta)^{-4}V_x.
\tag{5.1}
\]

Thus `aU subset V_x` is carried to
`a(\gamma x+\delta)^{-4}U subset V_y`.  The incidence and every rank below
are therefore `PGL2(K)`-invariant.  The stabilizer of primitive `x` is
trivial: a fractional-linear equation fixing `x` is a quadratic equation
over `K`, impossible for an element of degree eleven unless the
transformation is scalar.

For emptiness, retaining the three redundant `PGL2` dimensions is exact and
safer than an unsupported gauge.  If a quotient is desired, the correct
object is the free quotient stack of the primitive incidence by `PGL2`, or
cross-ratio slices after passing to an ordered splitting cover and imposing
Galois descent.  Three ad hoc coefficient normalizations are not a complete
affine cover.

## The invariant square-rank obstruction

Multiplication in `L` defines

\[
 \mu_2:\operatorname {Sym}^2(U)\longrightarrow L,
 \qquad u\cdot v\longmapsto uv,
\tag{6.1}
\]

whose image is denoted `U^2`.  In a basis of `U`, its exact matrix has eleven
rows and `r(r+1)/2` columns.  For `r=5` it is the `11 x 15` matrix with
columns the replay-basis coordinates of `P_iP_j`, `0<=i<=j<=4`.

**Theorem 6.1 (honest quartic).**  If `r=5` and an interpolation exists, then

\[
 \dim_K U^2=9.
\tag{6.2}
\]

*Proof.*  By (4.1), `aU=V_x`.  Hence

\[
 a^2U^2=V_x^2
 =\langle1,x,x^2,\ldots,x^8\rangle_K.
\]

The last nine powers are independent because `x` has degree eleven.  QED.

The rank-nine condition is invariant under arbitrary `L^*` rescaling of
the representative `P`.  It is also independent of a primitive parameter
and of all `PGL2` charts.  Therefore one exact nonzero `10 x 10` minor of
the product matrix proves

\[
 \operatorname {rank}\mu_2\geq10
 \quad\Longrightarrow\quad
 \text{no degree-four interpolation exists.}
\tag{6.3}
\]

This implication does not require a bounded search or an elimination in
`x`.

There is a useful geometric strengthening that controls compactification
boundaries as well.

**Theorem 6.2 (all stable degree-four degenerations).**  If the eleven
geometric conjugates of `Z` occur as marked evaluations of any genus-zero
stable map of total degree four to `P4`, then

\[
 \dim_K U^2\leq9.
\tag{6.4}
\]

*Proof.*  Work over an algebraic closure and let
`f:C -> P4` be the stable map.  The domain is a connected nodal tree of
arithmetic genus zero.  Put `M=f^*O(1)`.  Its degree is nonnegative on every
component and its total degree is four.  Thus `H1(C,M^2)=0`, and

\[
 h^0(C,M^2)=\deg(M^2)+1=9.
\]

Evaluation of every ambient quadric at the eleven markings factors through
`H0(C,M^2)`.  The rank of the quadratic evaluation map, which is exactly
`dim U^2`, is therefore at most nine.  QED.

Consequently a certified rank at least ten empties the whole fiber of the
proper stable-map incidence, including reducible domains, multiple covers,
contracted tails, and limits of basepointed coefficient tuples.  It empties
every affine `x`, multiplier, coefficient, and `PGL2` chart at once.  This is
the correct scope of a rank-ten certificate.

Rank nine alone is **not** a solution theorem over the present base field.
Let

\[
 \operatorname {ev}_2:K[X_0,\ldots,X_4]_2\longrightarrow L,
 \qquad X_iX_j\longmapsto P_iP_j.
\tag{6.5}
\]

For `r=5` and rank nine its kernel is a six-dimensional space `Q` of
quadrics through `Z`.  An interpolation exists if these six quadrics cut
out a rational normal quartic scheme-theoretically.  Conversely, any
rational normal quartic through `Z` has exactly these six quadrics: a
section of `O_P1(8)` vanishing on the reduced degree-eleven divisor is zero.
If the quadratic base locus is a `K`-form of a rational normal quartic, its
degree-eleven point makes it split (a genus-zero curve has index dividing
two, while the odd point makes the index divide eleven).  It is then
`P1_K`, and its parametrization reconstructs `x` and `a` in (4.1).

Thus a safe converse to (6.2) is

\[
 \operatorname {rank}\mu_2=9
 \quad+\quad
 V(Q)\text{ is a rational normal quartic}
 \quad\Longleftrightarrow\quad
 \text{interpolation}.
\tag{6.6}
\]

It is enough instead to certify that the eleven conjugates are in linear
general position: then rank nine and Castelnuovo's lemma give the unique
rational normal quartic.  Without that hypothesis, the square-rank minors
can contain extra degenerate components; no linear-Vosper converse is being
assumed here.

For dependent coordinates one can remove `x` and `a` only at the price of an
auxiliary Grassmannian incidence.  Interpolation is equivalent to the
existence of a five-space `W` with

\[
 U\subset W\subset L,
 \qquad W=a^{-1}V_x.
\tag{6.7}
\]

The candidate spaces lie in the projective Schubert variety
`Gr(5-r,L/U)`.  The `10 x 10` minors of
`Sym^2(W) -> L` give a fast necessary degeneracy locus.  A surviving `W`
must still pass the rational-normal-quartic base-locus test; the minors alone
are a relaxation, not an exact converse.

## Expected ranks and codimensions

The following are dimension heuristics, not emptiness certificates.

* The coefficient incidence has `x` in affine eleven-space and a kernel
  point in `P35`.  Fifty-five scalar equations give naive expected dimension
  `11+35-55=-9`.
* Equivalently, rank at most 35 for a general `55 x 36` matrix has expected
  codimension `(55-35)(36-35)=20`, greater than the eleven dimensions of
  `x`.
* Scaled power five-spaces form a family of dimension
  `11+10-3=18`: eleven for `x`, ten for `[a] in P(L)`, and minus three for
  the free `PGL2` action.  Since `Gr(5,11)` has dimension thirty, the
  expected codimension is twelve.
* For a general `11 x 15` multiplication matrix, rank at most nine has
  determinantal expected codimension `(11-9)(15-9)=12`, matching the power
  family calculation.

These matching codimensions explain why the square-rank gate is the natural
first computation.  They do not prove that its degeneracy locus has only
the power-segment component.

## Basepoints and the `F(phi)` branches

For `r=5`, basepoint freeness was proved above from invertibility of the
coefficient matrix.  For `r<5`, let

\[
 \mathcal M_q:
 K[s,t]_3^{\oplus5}\longrightarrow K[s,t]_7,
 \qquad (h_j)\longmapsto\sum_jh_jq_j.
\tag{8.1}
\]

The five quartics have no common geometric zero if and only if this `8 x 20`
Macaulay matrix has rank eight.  Hence basepoint freeness is the union of
the exact affine opens defined by its `8 x 8` minors, or equivalently is
implemented by saturation by their ideal.  A single chosen minor is only
one chart.

There is also a useful boundary fact.  If the `q_j` have a common divisor
`h` of positive degree `d`, the degree-eleven point cannot be a zero of `h`.
After cancellation, `q'_j=q_j/h` still interpolate `P`, but have degree
`4-d`.  The pullback cubic `F(q')` has degree at most
`3(4-d)<=9` and vanishes at a degree-eleven point, so it is identically
zero.  Thus a basepointed interpolation, once verified and cancelled
exactly, already produces a lower-degree rational curve on the twist; it is
not a residual-degree-one construction and must be reported under the
rational-curve branch.

For a basepoint-free solution put `Q(s,t)=F(q_0,...,q_4)`.  Its thirteen
coefficients define the open condition `Q != 0`.  Since `Q(tau)=0`, the
homogeneous degree-eleven orbit polynomial `g_tau` divides `Q`.  Therefore:

* if `Q=0`, the map lands in the cubic and gives the rational-curve branch;
* if `Q!=0`, then `Q=g_tau ell` for a unique nonzero `K`-linear form `ell`.
  Separability and irreducibility of `g_tau` make the factors coprime, so
  this is the scheme-theoretic degree-eleven plus degree-one intersection.

Accordingly `F(phi)!=0` must not be imposed when deciding whether A5Q has a
positive exit: it only separates the residual-point exit from the stronger
rational-curve exit.  It plays no role in the square-rank obstruction.

## Exact compactification and scoped emptiness

The intrinsic proper compactification is the ordered evaluation morphism

\[
 \mathrm{ev}:\overline M_{0,11}(\mathbf P^4,4)
 \longrightarrow(\mathbf P^4)^{11}.
\tag{9.1}
\]

After passing to a normal closure, take the fiber over the ordered eleven
conjugates of `P` and impose the natural Galois descent.  Its open locus with
smooth irreducible source and the required orbit of markings is the honest
degree-four interpolation incidence.  The boundary consists of stable
maps, not automatically of honest quartics.  A point only on that boundary
cannot be promoted without a smoothing or its own rational-curve argument.
Theorem 6.2 shows that rank at least ten makes the entire proper fiber empty,
so in that case no boundary analysis is necessary.

For direct elimination, homogenize the affine `x` coordinates in (3.3),
projectivize the thirty-six kernel coordinates, and saturate successively by

1. the affine homogenizing coordinate;
2. `(x_1,...,x_10)`, removing the nonprimitive diagonal;
3. the irrelevant kernel ideal;
4. for a dependent-coordinate residual-only search, the Macaulay
   basepoint ideal and the thirteen coefficients of `F(phi)`.

The full set of projective charts or the corresponding ideal saturations is
required.  A timeout, a bounded-support search, one multiplier chart, or one
basepoint minor is not scoped emptiness.

## Witness-specific completion table

The independent replay at the exact good-reduction specialization `p=89`
reconstructs the eleven conjugates from the sealed subgroup, landing-map,
and Schur-frame inputs.  Each projective orbit row is canonically normalized
so that its first nonzero coordinate is `1`.  It obtains the following
values.  The product columns use the lexicographically sorted pairs `(i,j)`,
`0<=i<=j<=4`; the displayed determinant is the minor using all eleven orbit
rows and the first eleven product columns.

| class | `dim_K U` | rank `mu_2` | exact nonzero minor | consequence |
|---|---:|---:|---|---|
| maximal `A5` class 1 | `5` | `11` | first `11 x 11` minor is `84 mod 89` | degree-four incidence empty |
| maximal `A5` class 2 | `5` | `11` | first `11 x 11` minor is `19 mod 89` | degree-four incidence empty |

The verifier does not infer these ranks from stored booleans: it reconstructs
the two eleven-point orbits, checks point-matrix rank five, rebuilds all
fifteen quadratic columns, recomputes rank eleven, and recomputes the two
nonzero determinants.  All exact input denominators and frame determinants
are units at `p=89`.  Hence a characteristic-zero determinant that were
identically zero would reduce to zero, contrary to `84` and `19`.  The exact
characteristic-zero product ranks are therefore at least eleven, hence equal
to eleven because the target `L` has dimension eleven.

In particular Theorem 6.2 applies separately to both fixed transported
cycles and empties every honest degree-four interpolation chart as well as
the full stable-map boundary.  This is a refutation only of the A5Q
degree-four rescue mechanism, not of the Klein-cubic headline problem.  The
authorized exit is

```text
A5Q-DEGREE4-RESCUE-EMPTY-SCOPED
```
