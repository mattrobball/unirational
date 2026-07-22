# Exclusion of irreducible conic factors in class `(1,1)`

## Statement

Work over an algebraically closed field of characteristic zero.  For a
general

\[
A\in\mathbf P H^0(\mathbf P^2_x\times\mathbf P^2_y,
\mathcal O(2,3))=\mathbf P^{59},
\]

there is no linear triple `sigma` of rank two or three and no irreducible
plane conic `C` such that

\[
C\mid B_{A,\sigma},\qquad
B_{A,\sigma}=\sigma^t\operatorname{adj}(A)\sigma.
\]

This is stronger than needed for the rationality frontier: it excludes a
single conic factor, hence in particular an irreducible conic square factor.
Together with `square_line_theorem.md`, it removes the complete residual
quartic row of `k1_frontier.md`; the later `cubic_factor_theorem.md` removes
the final residual-conic row.  Rank-one `sigma` reduces, as before, to the
certified nonrational class `(1,0)` horizontal component.

## 1. Orbit reduction and a determinant-zero lemma

The projective rank-three and rank-two matrix orbits for `sigma` have
dimensions eight and seven.  As in the preceding certificates, it is enough
to fix a canonical matrix and show that the bad `A`-locus has codimension
strictly greater than the appropriate orbit dimension after the conic moves.

We use three elementary rank-one calculations on `P^1`.  For a triple of
binary forms `(a,b,c)` satisfying

\[
ac-b^2=0,
\]

the nonboundary part has the UFD factorization

\[
(a,b,c)=h(u^2,uv,v^2),
\]

after common factors have been absorbed into `h` and `u,v` have been made
coprime.  If one diagonal entry is zero, then `b=0`; these give the two
diagonal boundaries, together with the zero triple.  Degree comparison gives
the following exhaustive affine-dimension bounds:

\[
\begin{array}{c|c|c|c}
(\deg a,\deg b,\deg c)&\dim V&
\dim\{ac=b^2\}&\operatorname{codim}\{ac=b^2\}\subset V\\ \hline
(8,8,8)&27&10&17\\
(10,8,6)&27&11&16\\
(8,7,6)&24&9&15.
\end{array}
\]

For `(8,8,8)`, write `deg(u)=deg(v)=r` and
`deg(h)=8-2r`; the parameter count is always

\[
(9-2r)+(r+1)+(r+1)-1=10.
\]

For `(10,8,6)`, write `deg(v)=r`, `deg(u)=r+2`, and
`deg(h)=6-2r`; the nonboundary count is ten, while the boundary
`(a,0,0)` has dimension eleven.  For `(8,7,6)`, the analogous degrees are
`r+1,r,6-2r`; both the nonboundary maximum and the longest diagonal boundary
have dimension nine.  Thus the table includes every factorization and every
boundary component, not merely the generic rank-one form.

## 2. Rank three

Normalize

\[
H_\sigma=x_0y_0+x_1y_1+x_2y_2.
\]

On the incidence threefold the restricted equation is a section of

\[
\mathcal Q=\operatorname{Sym}^2(E^\vee)\otimes O(3),
\qquad E=\Omega^1_{\mathbf P^2}(1),
\qquad h^0(\mathcal Q)=42.
\]

Let `C` be a smooth conic and identify its normalization with `P^1`, so that
`O_C(1)=O_{P^1}(2)`.  Pulling back the Euler sequence gives

\[
E^\vee|_C\simeq O(1)\oplus O(1).
\]

For example, the quotient sequence
`0 -> O(-2) -> O^3 -> E^vee|_C -> 0`, after twisting by `O(-2)`,
distinguishes this balanced splitting from `O(2) + O`.
Consequently

\[
\mathcal Q|_C\simeq O(8)^3,
\qquad h^0(\mathcal Q|_C)=27.
\]

The symmetric-square Euler resolution gives
`H^1(P^2,Q(-2))=0`, so restriction

\[
H^0(\mathcal Q)\longrightarrow H^0(\mathcal Q|_C)
\]

is surjective.  If `C | B`, then the determinant of the restricted binary
quadratic form vanishes identically on `C`.  By the first row of the table,
this has codimension 17 for a fixed conic.  Smooth conics move in a
five-dimensional projective space, leaving fixed-`sigma` codimension at least

\[
17-5=12>8=\dim O_3.
\]

Thus the rank-three incidence cannot dominate `P_A^59`.

## 3. Rank two away from the base point

Normalize

\[
H_\sigma=x_0y_0+x_1y_1,
\qquad b=[0:0:1].
\]

If `b` is not on `C`, the two sections `y_0|_C,y_1|_C` form a basepoint-free
pencil in `O(2)`.  The kernel of

\[
O^3\longrightarrow O(2),\qquad(x_0,x_1,x_2)\longmapsto
x_0y_0+x_1y_1,
\]

is `O(-2) + O`.  Hence the restricted quadratic form has degree pattern

\[
(10,8,6),
\qquad 11+9+7=27\text{ coefficients}.
\]

Let `Y={H_sigma=0}`.  Restriction to the inverse image of `C` fits into

\[
0\to O_Y(2,1)\to O_Y(2,3)\to O_{Y|C}(2,3)\to0.
\]

The ambient sequence

\[
0\to O(1,0)\xrightarrow{\cdot H_\sigma}O(2,1)
\to O_Y(2,1)\to0
\]

and Kunneth cohomology give `H^1(Y,O_Y(2,1))=0`.  Thus the restriction map
from the 42-dimensional quotient is surjective.  The second row of the table
gives fixed-conic codimension 16.  Allowing the five-dimensional open family
of conics avoiding `b` leaves codimension

\[
16-5=11>7=\dim O_2.
\]

## 4. Rank two through the base point

Now suppose that the smooth conic contains `b`.  On its normalization,
`y_0|_C` and `y_1|_C` have one common linear factor `ell`; after removing it,
the residual pair is a basis of `H^0(O(1))`.  Thus the original map
`O^3 -> O(2)` has image `O(1)` and a length-one cokernel, while its kernel is
the locally free bundle

\[
K\simeq O(-1)\oplus O,
\]

and the restricted quadratic form has degree pattern

\[
(8,7,6),
\qquad 9+8+7=24\text{ coefficients}.
\]

In coordinates

\[
C:\ y_0y_2-y_1^2=0,
\qquad [s:t]\longmapsto[s^2:st:t^2],
\]

the common factor is `s`.  Direct substitution gives

\[
B|_C=s^2\det(q_C).
\]

Since `s` is not the zero section, `C | B` is equivalent to
`det(q_C)=0` identically.  There is no extra hidden condition at `s=0`.

The coefficient map is surjective onto the 24 displayed coefficients.  After
the common factor is removed, the coefficient of the square of the moving
kernel vector is generated by

\[
H^0(O(6))\cdot H^0(O(2))=H^0(O(8));
\]

the mixed coefficient is generated by
`H^0(O(6))*H^0(O(1))=H^0(O(7))`, and the last coefficient is an arbitrary
section of `O(6)`.  Equivalently, on `Bl_b(P^2)` the three residual bundles
have vanishing `H^1`.

The final row of the determinant table therefore gives fixed-conic
codimension 15.  Conics through `b` form a four-dimensional projective
space, so the moving-conic codimension is

\[
15-4=11>7.
\]

This handles the rank-two base point without assuming a false surjectivity
statement on a doubled conic; only restriction to the reduced conic is used.

## 5. Boundary conics, rank one, and conclusion

Over an algebraically closed field an irreducible conic is smooth, so Sections
2--4 already prove the stated theorem.  Reducible conics have a line
component, and doubled conics are doubled lines; their square-factor
applications were already removed by `square_line_theorem.md`.

If `sigma=m(y)v` has rank one, then

\[
B_{A,\sigma}=m^2B_{A,v}.
\]

Its horizontal component is the class `(1,0)` member associated with `v`,
whose minimal resolution is K3 for general `A` by `k0_no_triple.m2`.  It is
not a rational multisection.

Combining the fixed-matrix estimates with the rank-orbit dimensions gives

\[
\begin{array}{c|c|c|c}
\operatorname{rank}(\sigma)&\text{conic position}&
\operatorname{codim}_{P_A}(\text{moving bad locus})&\dim O_r\\ \hline
3&\text{any smooth conic}&\ge12&8\\
2&b\notin C&\ge11&7\\
2&b\in C&\ge11&7.
\end{array}
\]

Every swept incidence has dimension strictly below 59.  Thus a general `A`
has no rank-two or rank-three branch divisible by an irreducible conic.  In
particular the irreducible-conic square-factor row in the class `(1,1)`
rationality frontier is empty.

## 6. Exact local checks

The script `conic_factor_local_checks.py` verifies over `Q` that the two
reduced-conic restriction quotients have dimension 27, that the rank-two
component maps have ranks `11+9+7` away from the base point and `9+8+7`
through it, and that the codimension arithmetic from the proved UFD bounds is
`17,16,15`.  Its output is recorded in `conic_factor_local_checks.log`.  The
quotient and multiplication ranks are exact matrix checks; the determinant
locus dimensions come from the exhaustive written UFD classification above.
The theorem is the uniform characteristic-zero dimension proof.
