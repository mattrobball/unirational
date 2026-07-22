# Exclusion of the proper-sixfold stratum in class `(1,1)`

## Statement

Work over an algebraically closed field of characteristic zero.  Let

\[
 A\in \mathbf P H^0(\mathbf P^2_x\times\mathbf P^2_y,
 \mathcal O(2,3))=\mathbf P^{59}
\]

and let `sigma` be a nonzero triple of linear forms in `y`, regarded as a
projective `3 x 3` matrix.  Put

\[
 B_{A,\sigma}=\sigma^t\operatorname{adj}(A)\sigma.
\]

For a general `A`, there is no `sigma` of rank two or three for which
\(B_{A,\sigma}\) has a proper point of multiplicity at least six.  Rank-one
`sigma` reduces to the already certified class `(1,0)` case.  Consequently,
the one-`t=3` row of the square-free octic rationality frontier in
`certificates/k1_frontier.md` does not occur for a general `(2,3)`
hypersurface.

The proof is a characteristic-zero dimension argument.  It replaces the
incomplete 27-chart finite-field computation in
`certificates/k1_sixfold_screen.log` for this particular stratum.  It does
not address the three-`t=2` octic strata or any square-factor row.

## 1. Matrix-rank orbits and the required codimensions

The group

\[
 G=\operatorname{PGL}(3)_x\times\operatorname{PGL}(3)_y
\]

acts on pairs `(A,sigma)`.  Its orbits on the projective space of nonzero
`3 x 3` matrices are the three rank strata.  Their dimensions are

\[
 \dim O_r=r(6-r)-1,
 \qquad (\dim O_3,\dim O_2,\dim O_1)=(8,7,4).
\]

It is therefore enough to fix one canonical `sigma` of each rank and prove
that the bad locus in `P_A^59` has codimension strictly larger than the
corresponding orbit dimension.  Indeed, a codimension-`c` locus for one
canonical matrix sweeps a subset of dimension at most

\[
 (59-c)+\dim O_r
\]

in the universal incidence.

More explicitly, the stabilizer of a canonical matrix preserves its bad
`A`-locus, and the incidence over its rank orbit is the associated family
`G x^(Stab(sigma)) R_sigma`.  Its dimension is therefore
`dim(O_r)+dim(R_sigma)`.  This avoids adding the full 16-dimensional group
instead of the orbit dimension.

For every fixed rank-two or rank-three bilinear form `H_sigma`, restriction
to `Y_sigma={H_sigma=0}` gives

\[
 0\longrightarrow H^0(\mathcal O(1,2))
 \xrightarrow{\cdot H_\sigma} H^0(\mathcal O(2,3))
 \longrightarrow H^0(Y_\sigma,\mathcal O(2,3))\longrightarrow0.
\]

The dimensions are `18`, `60`, and `42`.  Hence a codimension calculation in
the 42-dimensional restriction space has the same codimension in the
60-dimensional coefficient space of `A`.  Formally, all contact conditions
below define homogeneous cones containing the zero section.  Their inverse
images under the surjective linear restriction map have exactly the same
codimension.  Projectivizing does not change that codimension; the projective
kernel has codimension 42 and creates no additional large component.

## 2. A one-variable determinant-contact lemma

Let `t` be a coordinate at a point of `P^1`, and consider a symmetric binary
quadratic form

\[
 q(t)=\begin{pmatrix}a(t)&b(t)\\b(t)&c(t)\end{pmatrix}.
\]

We need the following three contact calculations.

1. In

   \[
   V_{543}=H^0(\mathcal O(5))\oplus H^0(\mathcal O(4))
             \oplus H^0(\mathcal O(3)),
   \]

   the locus `ord_t(det q)>=6` has codimension at least six.  Over a fixed
   nonzero rank-one value of `q(0)`, the condition on the tail coefficients
   has codimension at least five.  Over `q(0)=0`, it has codimension at least
   four in the tails.

2. The same three bounds, `6`, `5`, and `4`, hold for order six in
   `V_333=H^0(O(3))^3`.

3. In `V_333`, the locus `ord_t(det q)>=4` has codimension at least four.
   After the constant coefficient of one specified diagonal entry has been
   fixed to zero, it still has codimension at least four in that hyperplane.

Here is an exhaustive proof, including the truncated-degree cases.  Write
`a_i,b_i,c_i` for the coefficients of `t^i`.

For `V_543`, first suppose that `q(0)` is nonzero of rank one and is fixed.
If `c_0` is nonzero, the coefficients of `t^1,...,t^5` in `ac-b^2` solve
successively for `a_1,...,a_5`, giving five tail conditions.  This includes
the case `b_0` nonzero, because rank one then forces both diagonal constants
to be nonzero.  The only remaining orientation has

\[
 a_0\ne0,\qquad b_0=c_0=0.
\]

The coefficients of orders one through three solve for `c_1,c_2,c_3`.
Put `nu=ord_t(b)`, so `nu>=1`.

- If `nu=1`, the order-four and order-five equations solve successively for
  `b_3` and `b_4`.
- If `nu=2`, then `b_1=0` is already one tail condition and the order-four
  coefficient is `-b_2^2`, so this locally closed stratum has no solutions.
- If `nu>=3`, the two conditions `b_1=b_2=0`, together with
  `c_1=c_2=c_3=0`, give five tail conditions; the last two determinant
  coefficients then vanish automatically.

Thus the conditional codimension is at least five for every rank-one
orientation.  The nonzero rank-one cone has codimension one in the
three-dimensional space of constant symmetric matrices, giving total
codimension at least six on this stratum.

If `q(0)=0`, the three constant coefficients vanish and `q=tq_1`; the degree
pattern for `q_1` is `(4,3,2)`, and order six becomes order four.  If
`q_1(0)` has rank one, the same argument gives four total determinant
conditions: when the degree-two diagonal is a unit, four coefficients of the
degree-four diagonal are solved; in the opposite orientation two coefficients
of the short diagonal are solved, and the last coefficient either solves a
coefficient of `b` or forces the same number of its initial coefficients to
vanish.  If `q_1(0)=0`, three more constants vanish, factoring `t` leaves an
order-two determinant condition, and that condition has codimension at least
two.  Hence the order-four locus in the tails has codimension at least four,
including all deeper zero-jet strata.  This proves the `V_543` assertions.

For `V_333`, constant congruence by `GL_2` preserves the coefficient space.
On the rank-one stratum we may therefore normalize the fixed constant matrix
to `diag(1,0)`.  The first three tail equations solve `c_1,c_2,c_3`.  Again
put `nu=ord_t(b)>=1`.

- For `nu=1`, the order-four equation solves `b_3`; after that substitution,
  the order-five equation is linear in `a_3` with nonzero coefficient
  `-b_1^2`.
- The stratum `nu=2` is impossible because the order-four coefficient is
  `-b_2^2`.
- For `nu>=3`, the five conditions are
  `c_1=c_2=c_3=b_1=b_2=0`.

This proves conditional codimension five and total codimension six.  At the
zero constant matrix, factor `t`; one obtains three quadratic polynomials and
an order-four determinant condition.  Its rank-one constant stratum has one
constant determinant condition and three tail conditions.  Its zero constant
stratum costs three constants and, after one more factor of `t`, an order-two
condition of codimension at least two.  Therefore the conditional codimension
over `q(0)=0` is at least four.

The same last paragraph with order four as the starting order proves item 3.
For clarity, after additionally fixing `c_0=0`, either `a_0` is nonzero, in
which case `b_0=0` and the next three equations solve `c_1,c_2,c_3`, or
`a_0=0`, in which case `a_0=b_0=0` costs two conditions and the factored
order-two determinant condition costs two more.  Thus every component in
that hyperplane has codimension at least four.

Now take two one-variable forms, of either of the degree patterns above, and
require them to share their constant matrix.  The ambient space is the fiber
product of their coefficient spaces over `Sym^2(k^2)`.  Stratify it by the
rank of that common constant.  Over the nonzero rank-one cone, the base has
codimension one and the two tail loci have codimension at least five each.
Over the zero matrix, the base has codimension three and the two tail loci
have codimension at least four each.  A rank-two constant is incompatible
with positive determinant order.  Hence every irreducible component has
codimension at least

\[
 \min\{1+5+5,\;3+4+4\}=11.
\]

This is a dimension statement on all rank strata, not merely at their generic
points; nilpotent structure in equations such as `b_0^2=0` does not change
Krull dimension.  The shared-constant formulation is important: simply
adding two codimension-six counts would count the determinant of the common
constant matrix twice.

As an independent algebra check, `proper_sixfold_local_checks.m2` computes
the exact heights of the `(5,4,3)` and `(3,3,3)` contact ideals, their
zero-constant fibers, and the order-four ideal with a fixed zero diagonal
constant.  Its passing output is recorded in
`proper_sixfold_local_checks.log`.  These checks corroborate the local lemma;
the characteristic-zero conclusion rests on the preceding uniform
coefficient argument, not on specialization from one finite field.

## 3. Rank three

Normalize

\[
 H_\sigma=x_0y_0+x_1y_1+x_2y_2.
\]

Then `Y_sigma` is the incidence threefold.  Under its projection to
`P^2_y`, write

\[
 E=\ker(V_x\otimes\mathcal O\longrightarrow\mathcal O(1))
   \simeq\Omega^1_{\mathbf P^2}(1).
\]

Restriction of `A` is a binary quadratic form in

\[
 W=H^0(\mathbf P^2,\mathcal Q),\qquad
 \mathcal Q=\operatorname{Sym}^2(E^\vee)\otimes\mathcal O(3),
 \qquad \dim W=42,
\]

and its determinant is \(B_{A,\sigma}\).  Since
\(E^\vee=T_{\mathbf P^2}(-1)\), the Euler
sequence and its symmetric square give

\[
 0\longrightarrow\mathcal O(-1)
 \longrightarrow V_x^\vee\otimes\mathcal O
 \longrightarrow E^\vee\longrightarrow0,
\]

and, after twisting by `O(3)`,

\[
 0\longrightarrow V_x^\vee\otimes\mathcal O(2)
 \longrightarrow \operatorname{Sym}^2V_x^\vee\otimes\mathcal O(3)
 \longrightarrow\mathcal Q\longrightarrow0.
\]

The first map is injective fiberwise: for a line `l` in `V_x^vee`, its image
inside `Sym^2(V_x^vee)` is the three-dimensional subspace `l V_x^vee`.
Thus the displayed symmetric-square sequence is exact.  It also gives
\(h^0(\mathcal Q)=6\cdot10-3\cdot6=42\).

Let `p` be a fixed point and let `L_1,L_2` be two distinct lines through it.
For `D=L_1+L_2`, twisting the displayed resolution by `O(-2)` shows

\[
 0\longrightarrow V_x^\vee\otimes\mathcal O
 \longrightarrow \operatorname{Sym}^2V_x^\vee\otimes\mathcal O(1)
 \longrightarrow\mathcal Q(-2)\longrightarrow0,
 \qquad
 H^1(\mathcal Q(-2))=0,
\]

because `H^1(O)=H^1(O(1))=H^2(O)=0` on `P^2`.  The Cartier-divisor sequence

\[
0\longrightarrow\mathcal Q(-2)\longrightarrow\mathcal Q
\longrightarrow\mathcal Q|_D\longrightarrow0
\]

therefore makes restriction \(W\to H^0(D,\mathcal Q|_D)\) surjective.  On either line

\[
 E^\vee|_L\simeq\mathcal O(1)\oplus\mathcal O,
 \qquad
 \mathcal Q|_L\simeq\mathcal O(5)\oplus\mathcal O(4)\oplus\mathcal O(3).
\]

Thus each line contributes 15 coefficients, and the two restrictions share
the three coefficients of `q(p)`:

\[
 h^0(D,\mathcal Q|_D)=15+15-3=27.
\]

The splittings on the two lines need not use the same basis.  Both restriction
spaces map canonically to the common fiber
\(\operatorname{Sym}^2(E_p^\vee)\), and the shared-constant rank stratification of Section 2 is
performed in that fiber; no literal identification of the two splitting
bases is required.

If `mult_p(B)>=6`, the determinant has order at least six on both lines.
By Section 2 this necessary condition has codimension at least eleven for a
fixed `p`.  Surjectivity of restriction transports the same codimension to
`W`.  Allowing `p` to move costs at most two dimensions, so the locus in `W`
with some proper sixfold point has codimension at least

\[
 11-2=9.
\]

The choice of two transverse lines can be made on a finite affine cover of
the point incidence, so this estimate applies to its closure.  Since
`9>dim(O_3)=8`, the rank-three incidence cannot dominate `P_A^59`.

## 4. Rank two away from the base point

Normalize

\[
 H_\sigma=x_0y_0+x_1y_1,
 \qquad b=[0:0:1].
\]

The stabilizer is transitive on `P^2_y-{b}`.  Normalize a point in this open
orbit to `p=[1:0:0]` and use affine coordinates `u=y_1/y_0`, `v=y_2/y_0`.
Then `sigma=(1,u,0)` and eliminating `x_0=-u x_1` produces a binary
quadratic form.  On the `u`-axis its three entries have degrees `(5,4,3)`;
on the `v`-axis they are three cubics.

The combined restriction map from the 42-dimensional quotient is surjective
onto the fiber product of these two spaces over their common constant matrix,
which has dimension

\[
 15+12-3=24.
\]

This can be seen directly.  The restrictions of `A_11,A_12,A_22` prescribe
the two cubic triples with their common value, giving 21 coefficients.  Along
the `u`-axis, `A_01,A_02,A_00` independently supply the two extra coefficients
of the degree-five entry and the one extra coefficient of the degree-four
entry.  They vanish from the `v`-axis correction because `u=0` there.

The shared-constant determinant-contact lemma again gives codimension at
least eleven for a fixed `p`, hence at least nine after `p` moves in the
two-dimensional open orbit.  Since `9>dim(O_2)=7`, this part of the rank-two
incidence cannot dominate.

## 5. The rank-two base point

It remains to inspect the point `b`, which is determined by `sigma` and hence
has no moving-point allowance.  Put `y_2=1` and use local coordinates
`u=y_0`, `v=y_1`; then `sigma=(u,v,0)`.  Write `C_ij` for the cofactors of
`A`.  Locally

\[
 B=u^2C_{00}+2uvC_{01}+v^2C_{11}.
\]

Therefore `mult_b(B)>=6` implies the two necessary conditions

\[
 \operatorname{ord}_u C_{00}(u,0)\ge4,
 \qquad
 \operatorname{ord}_v C_{11}(0,v)\ge4.
\]

The first is the order-four determinant condition for the cubic triple
`(A_11,A_12,A_22)` on the `u`-axis; the second is the same condition for
`(A_00,A_02,A_22)` on the `v`-axis.  Their coefficient spaces share only
`A_22(b)`.  The map from the coefficients of `A` onto these two cubic triples
with that common scalar is surjective, and its target has dimension
`12+12-1=23`.

If `A_22(b)` is nonzero, each order-four contact condition has codimension
four by solving successively in the other diagonal entry, so the pair has
codimension eight.  If `A_22(b)=0`, fixing this scalar costs one condition.
For either cubic triple, if the other diagonal constant is nonzero, the four
determinant equations successively force the off-diagonal constant, the first
coefficient of `A_22`, and then solve its next two coefficients.  If the other
diagonal constant is also zero, the two off-diagonal/diagonal constants vanish
and factoring `t` leaves an order-two determinant condition.  Thus even over
`A_22(b)=0`, each of the two conditional loci has codimension at least four;
that stratum has total codimension at least `1+4+4=9`.

The minimum is therefore eight.  Since `b` does not move and
`8>dim(O_2)=7`, the base-point incidence also cannot dominate.

## 6. Rank one and conclusion

For rank-one `sigma`, the bilinear divisor is the union of a divisor pulled
back from `P^2_x` and one pulled back from `P^2_y`.  Its horizontal component
is a class `(1,0)` member.  The certified theorem in
`certificates/k0_no_triple.m2` excludes a rational normalization of that
horizontal component for general `A`.

Combining the orbit dimensions with the fixed-matrix estimates gives

\[
 \begin{array}{c|c|c|c}
 \operatorname{rank}(\sigma)&\text{case}&
 \operatorname{codim}_{\mathbf P_A}(\text{bad locus})&\dim O_r\\ \hline
 3&\text{moving proper point}&\ge9&8\\
 2&p\ne b&\ge9&7\\
 2&p=b&\ge8&7.
 \end{array}
\]

Every swept incidence has dimension at most 58, strictly below 59.  Hence a
general `A` has no class `(1,1)` branch with a proper point of multiplicity
six or seven.  By the argument in `certificates/k1_frontier.md`, a lone
`t=3` center in correction sum three is necessarily proper.  This proves the
claimed exclusion of that complete rationality stratum.

Taken alone, this proper-sixfold proof leaves the square-free octic row with
three `t=2` centers and both cluster-system vanishings, as well as residual
branch degrees six, four, and two after square factors are removed.  The
companion certificate `square_line_theorem.md` subsequently excludes the
residual-degree-six row and every reducible degree-two or degree-three square
factor, `conic_factor_theorem.md` excludes the residual-degree-four row, and
`cubic_factor_theorem.md` excludes the remaining irreducible cubic factor.
The later `proper_three_center_theorem.md` excludes the all-proper part of the
last row, and `adjacent_nested_pair_theorem.md` excludes every adjacent
`[2,1]` skeleton and the proper-root successive-free adjacent `[3]` chain.
The later `three_singleton_first_near_theorem.md` excludes all of root type
`[1,1,1]`.  Finally, `root_two_one_separator_theorem.md` excludes the
separated part of `[2,1]`, while `root_three_separator_theorem.md`,
`root_three_free_separator_theorem.md`, and
`root_three_completion_theorem.md` classify and exclude the rest of `[3]`.
Thus the full class-`(1,1)` rationality frontier is now excluded for a general
equation.

The branch-map base locus `B_sigma=0` is already excluded: for ranks two and
three it would have multiplicity at least six at every point, and rank one
reduces to the certified `k=0` theorem.
