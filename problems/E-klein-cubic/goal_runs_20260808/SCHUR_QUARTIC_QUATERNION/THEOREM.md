# Quaternion descent of the canonical Schur quartic

Date: 2026-08-08

## 1. Outcome

Let (T/K) be the genuine generic
(G=\operatorname {PSL}_2(\mathbf F_{11}))-torsor, let

\[
 \beta=\partial(T)\in \operatorname {Br}(K)[2],
 \qquad D/K\text{ the quaternion division algebra of class }\beta,
\]

and let (Y_T) and (X_T) be the Klein cubic and orthogonal (V_{14})
twists.  The degree-six projective spin algebra is

\[
 A_\beta\simeq M_3(D).
\]

There is an intrinsic, finite parameter scheme over (K) for the canonical
quartics normalized by (C_\beta=\operatorname {SB}(D)).  It is the
basepoint-free rank-exactly-(20) locus of a descended bundle map

\[
 \boxed{B_\beta:\mathcal V_{21}\longrightarrow\mathcal H_{25}}
\]

on

\[
 S=\operatorname {SB}_2(A_\beta)=\mathbf P_D^2.
\]

The construction does not split (D), and its scalar extension is exactly
the forced (25\times21) companion matrix from the split calculation.

The arithmetic verdict is an exact circularity theorem:

\[
 \boxed{
 \mathscr H_{(1,3),\beta}^{\mathrm{good}}(X_T)
 \simeq Y_T^\circ,
 }
\]

where (Y_T^\circ) is the complement of the kernel lines meeting the
singular curve of the Palatini quartic.  The natural compactification of the
left side is (Y_T) itself.  Under the isomorphism, a quartic is sent back to
the unique point (y) whose skew form has its distinguished line as kernel.

Consequently the finite quaternionic equations are a faithful coordinate
presentation of the original Klein twist.  They do not supply a smaller
arithmetic target.  Pfaffian, Brauer, discriminant, and Dieudonne-determinant
tests on this presentation either recover the original cubic equation, the
constant class (\beta), or a Fitting ideal defining (Y_T).  No new
obstruction is obtained.

This is not a proof that (Y_T(K)) is empty.

## 2. Intrinsic construction over the nonsplit quaternion

Use the (\mu _2)-gerbe (\mathscr G_\beta\) representing (\beta).  On it
there is a weight-one rank-six vector bundle (\mathcal U) with

\[
 \operatorname {End}(\mathcal U)=A_\beta.
\]

The central involution acts trivially on (\bigwedge^2\mathcal U^\vee), so
the five-dimensional alternating net is defined over (K):

\[
 f:\mathcal A_5\longrightarrow\bigwedge^2\mathcal U^\vee.
\]

The twisted Grassmannian of rank-two subspaces of (\mathcal U) descends to

\[
 S=\operatorname {SB}_2(A_\beta).
\]

Let (\mathcal K\) be its weight-one universal rank-two subbundle on
(\mathscr G_\beta\times S).  Projectivization kills the central weight, so

\[
 p:\mathcal C=\mathbf P_S(\mathcal K)\longrightarrow S
\]

is an honest family of conics over (K).  Every geometric fibre is a line,
and every fibre over a (K)-point of (S) is a conic of Brauer class
(\beta).  Write (\mathcal L=\mathcal O_{\mathcal C}(-1)); it is a
weight-one line on the pulled-back gerbe.

A companion for a geometrically split bundle

\[
 \mathcal O(-1)\oplus\mathcal O(-3)
\]

is a map (\mathcal L^{\otimes3}\to\mathcal U\).  Adding a map through the
tautological inclusion (\mathcal L\hookrightarrow\mathcal U) does not
change the resulting two-plane.  This gives the rank-(21) bundle

\[
 \mathcal V=
 \frac{p_*\mathcal Hom(\mathcal L^{\otimes3},\mathcal U)}
 {p_*\mathcal Hom(\mathcal L^{\otimes3},\mathcal L)}.
\]

Indeed, after geometric splitting, its two terms have ranks

\[
 6h^0(\mathcal O(3))=24,
 \qquad h^0(\mathcal O(2))=3.
\]

Pairing the tautological vector with its cubic companion using all five
forms produces five binary quartics.  Thus the target is

\[
 \mathcal H=
 \mathcal A_5^\vee\otimes p_*(\mathcal L^{-4}),
 \qquad \operatorname {rk}(\mathcal H)=5h^0(\mathcal O(4))=25,
\]

and the pairing is the promised map

\[
 B_\beta:\mathcal V\longrightarrow\mathcal H.
\]

This construction really descends.  Modulo two, the central weights are

\[
 1-3=0,\qquad 1-3=0,\qquad -4=0.
\]

Hence both bundles and (B_\beta) have weight zero.  On the affine
quaternion chart (S\simeq D^2), the same construction uses a right
(D)-line in (D^3) and the five descended quaternionic Hermitian forms.
After any Morita splitting it becomes the (25\times21) matrix with
(24-3) companion coefficients and (5\cdot5) isotropy coefficients.
Changing the splitting only changes frames of (\mathcal V) and
(\mathcal H).

Define the companion incidence

\[
 \mathcal I=\{(s,[c])\in\mathbf P_S(\mathcal V):B_\beta(s)c=0\}.
\]

On the locally closed locus where

\[
 \operatorname {rank}B_\beta=20
\]

the companion is unique up to scalar.  Requiring the complementary minors
to be basepoint-free makes (\mathcal L\oplus\mathcal L^3\to\mathcal U) a
subbundle and gives a morphism from the fibre conic to (X_T).  This is the
intrinsic (K)-scheme
(\mathscr H_{(1,3),\beta}^{\mathrm{good}}(X_T)).

## 3. The inverse and the circularity theorem

For (y\in Y_T), the alternating form (f(y)) has rank four.  Its
weight-one kernel (\mathcal K_y\) has rank two, and

\[
 \mathbf P(\mathcal K_y)\simeq C_\beta.
\]

The kernel-line map

\[
 h_T:Y_T\longrightarrow S,
 \qquad y\longmapsto\ker f(y),
\]

is the twist of the equivariant closed embedding
(h:Y\to F_1(Q)\subset\operatorname {Gr}(2,U)).  Away from the ruled
boundary, its unique companion has rank (20), is basepoint-free, and gives
the canonical quartic.

Conversely, a good ((1,3)) quartic has a unique geometrically maximal
(\mathcal O(-1)) subline.  Uniqueness makes its Harder--Narasimhan
filtration descend as a weight-one twisted line.  Its projectivization is a
twisted line (s\in S).  Intrinsically, contraction gives

\[
 C_s:\mathcal A_5\longrightarrow
 \mathcal K_s^\vee\otimes\mathcal U^\vee,
 \qquad a\longmapsto f(a)|_{\mathcal K_s\times\mathcal U}.
\]

Both factors have odd central weight, so (C_s) is defined over (K).  On
the good rank-(20) locus it has rank four.  Therefore

\[
 \mathbf P(\ker C_s)=\{y\}
\]

is a single (K)-point, and (\mathcal K_s=\ker f(y)).  This construction
is the inverse to (h_T), in families.  It proves

\[
 \mathscr H_{(1,3),\beta}^{\mathrm{good}}(X_T)\simeq Y_T^\circ.
\]

The split line-bundle relation (d_X+d_Y=4) and the kernel-line closed
embedding show that the closure of this locus in the Palatini line scheme is
exactly (h_T(Y_T)\simeq Y_T).  No choice of a splitting field enters the
isomorphism.

There is a mild distinction between parameterized maps and image curves.
The normalization of every image above is the conic
(\mathbf P(\mathcal K_s)), whose Brauer class is (\beta), hence it is
(K)-isomorphic to (C_\beta).  Choosing such an isomorphism only adds the
expected (\operatorname {Aut}(C_\beta))-torsor of parameterizations; it
does not change existence of a (K)-morphism or the unparameterized moduli
point.

## 4. Arithmetic invariant audit

### 4.1 Pfaffian

The Pfaffian of the descended (6\times6) alternating matrix is

\[
 \operatorname {Pf}(f(y))=\lambda F_T(y),\qquad \lambda\in K^\times,
\]

where (F_T=0) is the twisted Klein cubic.  Its (4\times4) Pfaffian
cofactors are the Pluecker coordinates of (h_T(y)).  The contraction map
(C_s) recovers (y).  Thus the Pfaffian test is literally the headline
cubic equation, not an additional obstruction.

### 4.2 Quaternion and descent class

For every point of the compactified component,

\[
 [\operatorname {End}(\mathcal K_y)]=\beta,
 \qquad [\mathbf P(\mathcal K_y)]=\beta.
\]

The class is constant along the component.  The odd-looking geometric
splitting ((1,3)) is consistent precisely because its two summands are
weight-one (\beta)-twisted lines; only their projectivization and total
degree descend.  There is no second Clifford or descent class.

### 4.3 Discriminants and Fitting ideals

The intrinsic equation is a rank condition on a rectangular
(25\)-by-(21) map.  It has no determinant.  Its coordinate-free
invariants are the Fitting ideals of (\operatorname {coker}B_\beta).
On the basepoint-free rank-(20) component those ideals define
(h_T(Y_T)).  The apparent discriminant at the complement is the ruled
boundary (R_{Y,T}\subset Y_T), where a kernel line meets
(\operatorname {Sing}(Q_T)); it is not a new arithmetic cover.

Likewise, the Maroni determinant-of-cohomology section cuts the unbalanced
((1,3)) divisor inside the four-dimensional quartic Hilbert component.
Its compactification is again (Y_T).  A geometric discriminant
calculation on either presentation therefore returns a divisor on the
original cubic.

### 4.4 Dieudonne determinants

The quaternionic presentation does not produce a square (D)-linear
endomorphism: (B_\beta) is an honest (K)-linear map of ranks (21) and
(25).  A square pivot appears only after choosing a Morita frame and a
rank chart.  Changing that frame multiplies the pivot by ordinary units and
reduced norms.  Hence a Dieudonne determinant of a chosen pivot is a chart
unit, not an invariant of the quartic.  The frame-independent datum is the
same Fitting ideal already identified with (Y_T).

### 4.5 Ordinary Brauer group

For a smooth cubic threefold (Y_T\subset\mathbf P^4_K),

\[
 \operatorname {Pic}(Y_{\bar K})=\mathbf Z[H],
 \qquad \operatorname {Br}(Y_{\bar K})=0.
\]

The generator (H) descends from the split ambient projective space and
(H^1(K,\mathbf Z)=0).  Hochschild--Serre therefore gives

\[
 \boxed{\operatorname {Br}(Y_T)/\operatorname {Br}(K)=0.}
\]

Thus an unramified Brauer or quaternion class on the compactified quartic
component is constant.  Classes ramified along (R_{Y,T}) live only on the
open complement.  They cannot create a separate compactification
obstruction: if (Y_T(K)\ne\varnothing), then the smooth cubic is
(K)-unirational over the infinite field (K), so (K)-points are dense
and one lies outside (R_{Y,T}).

## 5. The soluble `D12` countermode

The constant class (\beta) cannot by itself obstruct a point.  Let
(V_4\subset D_{12}\subset G).  Its inverse image in the Schur cover is
(Q_8).  The generic (V_4)-torsor over (\mathbf C(s,t)) has boundary
quaternion

\[
 (s,t)\ne0.
\]

After extension of structure group to (D_{12}), naturality preserves this
nonzero Schur boundary.  On the other hand, the five-dimensional Klein
representation restricted to (D_{12}) contains an honest
two-dimensional subrepresentation whose projective line lies identically in
the Klein cubic.  Twisting this honest subrepresentation gives a split
(\mathbf P^1) in every (D_{12})-twist.  Hence there are twists with

\[
 \beta\ne0\qquad\text{and}\qquad Y_\tau(K)\ne\varnothing.
\]

By the circularity theorem they also have good canonical Schur quartics.
This is an explicit counterexample to any proposed obstruction depending
only on nonsplitting of (D), the normalization conic, or a functorial
Dieudonne/discriminant class extracted from that quaternion.

## 6. CAS boundary and headline status

The exact finite computation is useful: it catches the false target
`rank(B)<=20`, isolates the correct rank-(20) component, and verifies the
inverse contraction.  But geometric Groebner emptiness cannot decide its
(K)-points, because the component is geometrically the nonempty
threefold (Y_T).  Running a larger elimination on this finite scheme would
only re-solve the original rational-point problem in different coordinates.

The remaining target is therefore not an omitted bounded CAS case.  It is
the arithmetic pointlessness of the genuine generic Klein twist itself (or
an independent obstruction such as the full semilinear trace gate).

Terminal markers:

```text
SCHUR-QUARTIC-QUATERNION-DESCENT-EXACT
SCHUR-QUARTIC-RANK20-FUNCTOR-IS-KLEIN
SCHUR-QUARTIC-BRAUER-DIEUDONNE-TAUTOLOGICAL
HEADLINE-OPEN
```
