# Exclusion of squared line factors in class `(1,1)`

## Statement

Work over an algebraically closed field of characteristic zero.  For a
general

\[
A\in\mathbf P H^0(\mathbf P^2_x\times\mathbf P^2_y,
\mathcal O(2,3))=\mathbf P^{59},
\]

there is no linear triple `sigma` of rank two or three such that

\[
B_{A,\sigma}=\sigma^t\operatorname{adj}(A)\sigma
\]

is divisible by the square of a line in `P^2_y`.  Rank-one `sigma` always
contributes such a square, but its horizontal component is a class `(1,0)`
member and is nonrational for general `A` by the certified `k=0` theorem.

Consequently, the entire `e=1`, residual-sextic row of the class `(1,1)`
rationality table in `certificates/k1_frontier.md` is absent as a rationality
possibility for a general `A`.  (Rank-one triples still have the displayed
factorization, but their horizontal component is nonrational.)  More generally,
for rank two or three the theorem removes every
square-factor stratum whose maximal square factor has a linear component.  It
does **not** remove an irreducible quadratic or irreducible cubic square
factor.

The theorem also removes the branch-map base locus \(B_{A,\sigma}=0\): for ranks
two and three the zero polynomial is divisible by every squared line, while
rank one reduces to `k=0` as above.

## 1. Orbit reduction

As in `proper_sixfold_theorem.md`, the projective matrix-rank orbits for
`sigma` have dimensions

\[
\dim O_3=8,\qquad \dim O_2=7,\qquad \dim O_1=4.
\]

For a fixed rank-two or rank-three `sigma`, restriction of the coefficient
space of `A` to the bilinear divisor `Y_sigma` is a surjection onto a
42-dimensional vector space, with 18-dimensional kernel.  All divisibility
conditions below are homogeneous cones, so their codimension is unchanged on
pulling back to the 60-dimensional vector space of `A` or on projectivizing.

It is enough to obtain, for one canonical matrix of each rank, a codimension
strictly larger than its orbit dimension after the line is allowed to move.
The incidence over a rank orbit is the associated family under the stabilizer
of the canonical matrix, so its dimension is the fixed-matrix dimension plus
the orbit dimension.

## 2. Rank three: restriction to a double line

Normalize

\[
H_\sigma=x_0y_0+x_1y_1+x_2y_2.
\]

With

\[
E\simeq\Omega^1_{\mathbf P^2}(1),\qquad
\mathcal Q=\operatorname{Sym}^2(E^\vee)\otimes\mathcal O(3),
\]

the restricted equation is a binary quadratic form
\(q\in W=H^0(\mathcal Q)\), where \(\dim W=42\), and
\(\det(q)=B_{A,\sigma}\).  The resolution

\[
0\longrightarrow V_x^\vee\otimes\mathcal O(2)
\longrightarrow\operatorname{Sym}^2V_x^\vee\otimes\mathcal O(3)
\longrightarrow\mathcal Q\longrightarrow0
\]

gives `H^1(Q(-2))=0`.  Hence for every line `L`

\[
W\longrightarrow H^0(2L,\mathcal Q|_{2L})
\]

is surjective.  On `L`,

\[
E^\vee|_L\simeq\mathcal O(1)\oplus\mathcal O,
\qquad
\mathcal Q|_L\simeq
\mathcal O(5)\oplus\mathcal O(4)\oplus\mathcal O(3).
\]

The first normal part is

\[
\mathcal Q|_L(-1)\simeq
\mathcal O(4)\oplus\mathcal O(3)\oplus\mathcal O(2).
\]

Both bundles have vanishing `H^1`, so

\[
h^0(\mathcal Q|_{2L})=15+12=27.
\]

Choose a normal coordinate `z` and write, noncanonically,

\[
q=q_0+zq_1\pmod {z^2},
\]

where

\[
q_0=\begin{pmatrix}a&b\\b&c\end{pmatrix},\qquad
(a,b,c)\in H^0(O(5))\oplus H^0(O(4))\oplus H^0(O(3)),
\]

and

\[
q_1=(\alpha,\beta,\gamma)
\in H^0(O(4))\oplus H^0(O(3))\oplus H^0(O(2)).
\]

The condition `L^2 | det(q)` is

\[
ac-b^2=0,
\qquad
c\alpha+a\gamma-2b\beta=0.
\tag{2.1}
\]

A different splitting of the restriction sequence changes the second
equation by an affine translation for fixed `q_0`; its linear part is always
contraction with `adj(q_0)`.  Thus the fiber-dimension estimates below are
intrinsic.

### 2.1 Complete determinant-zero classification

Suppose first that all three entries are nonzero.  Since the homogeneous
coordinate ring of `P^1` is a UFD, after extracting the maximal common factor
one has

\[
(a,b,c)=h(u^2,uv,v^2),
\]

with `u,v` coprime.  Degree comparison gives exactly two possibilities:

\[
\begin{array}{c|c|c|c|c}
d=\deg h&\deg u&\deg v&\dim\{q_0\}\text{ as an affine cone}
&\operatorname{rank}(q_1\mapsto (\det q)_1)\\ \hline
1&2&1&2+3+2-1=6&7\\
3&1&0&4+2+1-1=6&5.
\end{array}
\]

The subtraction by one is the common rescaling of `(u,v)` against `h`.
For `d=1`, the normal map before multiplication by `h` is

\[
H^0(O(4))\oplus H^0(O(3))\oplus H^0(O(2))
\longrightarrow H^0(O(6)),
\]

\[
(\alpha,\beta,\gamma)\longmapsto
v^2\alpha-2uv\beta+u^2\gamma.
\]

It is surjective.  Indeed, after taking `v=s` and writing the coprime
quadratic `u` with a nonzero `t^2` term, the three summands span respectively
all degree-six monomials with `s`-exponent at least two, the remaining
monomial with `s`-exponent one, and the remaining monomial `t^6`.  For `d=3`,
`v` is a nonzero constant, so the `v^2 alpha` term already spans `H^0(O(4))`.

All boundary components must also be retained:

\[
\begin{array}{c|c|c|c|c}
q_0&\dim\{q_0\}&\text{normal equation}&\text{normal rank}
&\dim\{(q_0,q_1)\}\\ \hline
(a,0,0),\ a\ne0&6&a\gamma=0&3&6+(12-3)=15\\
(0,0,c),\ c\ne0&4&c\alpha=0&5&4+(12-5)=11\\
0&0&0=0&0&12.
\end{array}
\]

Together with the two nonboundary factor types, whose total dimensions are
`6+(12-7)=11` and `6+(12-5)=13`, this is exhaustive.  The largest dimension
is 15 inside the 27-dimensional double-line restriction space.  Therefore
the fixed-line locus has codimension at least

\[
27-15=12.
\]

Lines move in a two-dimensional dual plane, so for the fixed rank-three
`sigma` the locus with some squared line has codimension at least `12-2=10`.
Since `10>dim O_3=8`, its sweep cannot dominate `P_A^59`.

## 3. Rank two: lines away from the base point

Normalize

\[
H_\sigma=x_0y_0+x_1y_1,
\qquad b=[0:0:1].
\]

Let `Y=Y_sigma`.  For every line `L` not containing `b`, the triple `sigma`
has no base point on the double line `2L`, and its kernel is a rank-two bundle
whose restriction to \(L\) is \(\mathcal O\oplus\mathcal O(-1)\).  Thus the restricted quadratic
form has exactly the same `(5,4,3)` and first-normal `(4,3,2)` degree patterns
as in Section 2.

The required restriction map is again surjective.  On `Y`, restriction to
the pullback of `2L` fits into

\[
0\longrightarrow O_Y(2,1)\longrightarrow O_Y(2,3)
\longrightarrow O_{Y|_{2L}}(2,3)\longrightarrow0.
\]

The ambient restriction sequence

\[
0\longrightarrow O(1,0)\xrightarrow{\cdot H_\sigma}O(2,1)
\longrightarrow O_Y(2,1)\longrightarrow0
\]

and Kunneth cohomology give `H^1(Y,O_Y(2,1))=0`.  Hence the 42-dimensional
restriction space surjects onto the same 27-dimensional double-line data.

For a fixed line the codimension is therefore at least 12.  Lines avoiding
`b` form a two-dimensional open set, so the fixed-`sigma` codimension is at
least 10.  This is greater than the rank-two orbit dimension seven.

## 4. Rank two: lines through the base point

The preceding bundle calculation cannot simply be extended across `b`.
The stabilizer of the rank-two matrix is transitive on the pencil of lines
through `b`, so take

\[
L=\{y_1=0\}.
\]

On `L`, use homogeneous coordinates `[y_0:y_2]`.  Put

\[
a=A_{11}|_L,\qquad b_1=A_{12}|_L,\qquad c=A_{22}|_L,
\]

and denote their first normal derivatives by `alpha,beta,gamma`, which are
quadratic forms on `L`.  Also put

\[
r=A_{01}|_L,\qquad s=A_{02}|_L.
\]

Thus `(a,b_1,c)` is a triple of cubics, `(alpha,beta,gamma)` a triple of
quadratics, and `(r,s)` a pair of cubics.  The branch is

\[
B=y_0^2C_{00}+2y_0y_1C_{01}+y_1^2C_{11}.
\]

Consequently `y_1^2 | B` is equivalent to

\[
ac-b_1^2=0,
\tag{4.1}
\]

and

\[
\Phi=
y_0(c\alpha+a\gamma-2b_1\beta)+2(sb_1-rc)=0
\quad\text{in }H^0(L,O(6)).
\tag{4.2}
\]

These 29 data coordinates are independent images of the coefficients of
`A`.  For each of `A_11,A_12,A_22`, restriction to the double line gives
`4+3=7` coefficients and is surjective because its kernel consists of cubics
divisible by `y_1^2`.  The restrictions of `A_01,A_02` give four coefficients
each.  Hence the map from `A` onto the `21+8=29` displayed coordinates is
surjective.

### 4.1 All determinant-zero and normal-rank strata

For three cubic entries, the nonzero determinant-zero locus again has the
factorization

\[
(a,b_1,c)=h(u^2,uv,v^2).
\]

Its two nonboundary types and every boundary type give:

\[
\begin{array}{c|c|c|c}
\text{type}&\dim\{q_0\}&\operatorname{rank}(\Phi\text{ in the 17 auxiliary variables})
&\dim\{\Phi=0\}\\ \hline
\deg h=1,\ \deg u=\deg v=1&5&5\text{ or }6&\le16\\
\deg h=3,\ u,v\text{ nonzero constants}&5&4&5+(17-4)=18\\
(a,0,0),\ a\ne0&4&3&4+(17-3)=18\\
(0,0,c),\ c\ne0&4&4&4+(17-4)=17\\
0&0&0&17.
\end{array}
\]

Here are uniform proofs of the asserted ranks.

- In the degree-one-factor type, `u,v` are coprime linear forms and hence a
  basis of `H^0(O(1))`.  The `alpha,beta,gamma` part of `Phi/h` contains

  \[
  y_0\bigl(v^2H^0(O(2))+uvH^0(O(2))+u^2H^0(O(2))\bigr)
  =y_0H^0(O(4)),
  \]

  a five-dimensional subspace.  The `r,s` part also contains
  \(vH^0(O(4))\).  Hence the full image is
  \(y_0H^0(O(4))+vH^0(O(4))\): it has dimension six unless \(v\) is
  proportional to \(y_0\), and dimension five on that codimension-one
  sublocus of the five-dimensional `q_0` family.  The two corresponding total
  dimensions are therefore respectively `5+(17-6)=16` and
  `4+(17-5)=16`.
- In the degree-three-factor type with `u,v` both nonzero, the `r` term alone is
  `-2v^2r` and spans `H^0(O(3))`; after the common factor `h` is removed, the
  whole expression also lies in that space, so the rank is exactly four.  The case
  `v=0` is the first diagonal boundary, and `u=0` is the second.
- For `(a,0,0)`, equation (4.2) is `y_0a gamma`; multiplication is injective
  on the three-dimensional `H^0(O(2))`.
- For `(0,0,c)`, the term `-2rc` alone is the injective image of the
  four-dimensional `H^0(O(3))`.
- At the zero triple, equation (4.2) vanishes identically, but imposing the
  zero triple already has codimension 12.

The largest stratum has dimension 18 in the 29-dimensional data space.
Thus a fixed line through `b` has codimension at least 11.  Such lines form a
one-dimensional pencil, leaving fixed-`sigma` codimension at least
`11-1=10`, again greater than `dim O_2=7`.

The two rank-two line positions, \(b\notin L\) and \(b\in L\), are exhaustive.
Therefore no rank-two squared-line incidence dominates.

## 5. Rank one and the rationality table

If `sigma` has rank one, write

\[
\sigma=m(y)v
\]

with `m` linear and `v` constant.  Then

\[
B_{A,\sigma}=m^2B_{A,v},
\qquad
B_{A,v}=v^t\operatorname{adj}(A)v
\]

is the branch sextic of the horizontal class `(1,0)` component.  The
bilinear divisor itself is reducible: its other component is vertical.  The
theorem certified by `certificates/k0_no_triple.m2` says that for general
`A`, every such horizontal component has K3 minimal resolution and is not
rational.  Therefore the automatic squared line for rank-one `sigma` does
not produce a rational degree-two multisection.

This proves the promised consequence for the rationality table.  If the
maximal square factor has degree one, it is a line and the residual branch has
degree six.  Ranks two and three are excluded by Sections 2--4, and rank one
is excluded by the `k=0` theorem.  Hence the entire `e=1` row is absent as a
rationality possibility for a general `A`.

If a degree-two or degree-three square factor is reducible, it has a line
component and is also excluded for ranks two and three.  At the stage of this
proof, the remaining square-factor possibilities were an irreducible conic or
an irreducible cubic.  The companion `conic_factor_theorem.md` subsequently
excludes even a single irreducible conic factor, and
`cubic_factor_theorem.md` excludes even a single integral cubic factor.  Thus
no square-factor row remains, apart from the separate rank-one reduction
already handled by `k=0`.

Finally, \(B_{A,\sigma}=0\) is no longer a separate unresolved branch-map base
locus.  For ranks two and three it lies in every squared-line incidence and
is excluded above.  For rank one it would force \(B_{A,v}=0\), contradicting
the `k=0` no-triple-point theorem, since the zero sextic has multiplicity at
least three at every point.

## 6. Exact local checks

The script `square_line_local_checks.py` computes over `Q` the exact ranks of
the multiplication maps used above:

- ranks seven and five for the two rank-three factor types;
- ranks three and five on the rank-three diagonal boundaries;
- minimum rank five for the rank-two degree-one type through `b`;
- rank four for the rank-two degree-three type;
- ranks three and four on its two diagonal boundaries.

It also computes the bidegree `(2,3)` quotient by the canonical incidence
equation and a doubled line, obtaining the 27-dimensional double-line
restriction space.  These calculations are recorded in
`square_line_local_checks.log`.  They corroborate
the displayed polynomial-span arguments; the theorem itself is the uniform
characteristic-zero dimension proof above.
