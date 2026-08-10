# Characteristic-five fixed-line and Hasse-jet audit

**Date:** 2026-08-08  
**Status:** `EXACT FIRST-JET LEMMA / UNIFORM FINITE-HASSE CLOSURE REFUTED`  
**Strict verdict:** the all-degree covariant-dominance theorem and
`ed_k(F55)` remain open.

Let `k` be algebraically closed of characteristic five, let

\[
 u=(1,1,1,1,1),\qquad
 v_a=s^au=(\zeta^{aw_0},\ldots,\zeta^{aw_4}),
 \quad a\in\mathbf Z/11,
\]

and write `Lambda_a=k v_a`.  These are the eleven affine lines fixed
pointwise by the eleven Sylow `C5` subgroups.  Let

\[
 T_f=(f,\rho f,\ldots,\rho^4f),\qquad c=f(u),
\]

where `f` is homogeneous of degree `d` and has `C11`-weight one.

## 1. Exact circulant Jacobian

Equivariance and homogeneity give, for every `r in k`,

\[
             T_f(rv_a)=c r^d v_a.                         \tag{1.1}
\]

Put `A=D T_f|_u`.  Since `u` is fixed by `t`, differentiating
`T_f(tx)=tT_f(x)` at `u` shows that `A` commutes with the five-cycle `t`.
Thus

\[
 A=P(t)\in k[t]/(t^5-1)=k[\Delta]/(\Delta^5),
 \qquad \Delta=t-1.                                    \tag{1.2}
\]

In particular `A` is circulant.  Euler's identity gives

\[
 A u=dT_f(u)=dc,u,
 \qquad P(1)=dc.                                       \tag{1.3}
\]

Since `t=1+Delta` and `Delta^5=0`, the only eigenvalue of `A` is `dc`.
Consequently

\[
 \boxed{\det A=(dc)^5.}                                 \tag{1.4}
\]

More precisely, if `dc=0` and `A=Delta^r U` with `U` a unit and
`1<=r<=4`, then

\[
                 \operatorname{rank}A=5-r.             \tag{1.5}
\]

At every nonzero point of every fixed line,

\[
 D T_f|_{rv_a}=r^{d-1}s^aAs^{-a},\qquad
 \det D T_f|_{rv_a}=r^{5(d-1)}(dc)^5.                  \tag{1.6}
\]

Thus the eleven tests are conjugate copies of one test; they do not give
eleven independent conditions.  In particular, nondominance implies only

\[
                        5\mid d\quad\hbox{or}\quad c=0. \tag{1.7}
\]

Both alternatives occur for dominant covariants, so (1.7) has no converse.

## 2. The extra first-jet consequence of Klein landing

For

\[
                         K(y)=\sum_i y_i^2y_{i+1},
\]

one has `K(u)=0` and

\[
 D K|_{cu}=3c^2(1,1,1,1,1).
\]

Because a circulant matrix has the same row and column sum, the linear
Hasse term of `K(T_f)` at `u` is

\[
                  3dc^3(z_0+\cdots+z_4).               \tag{2.1}
\]

Hence landing implies `5|d` or `c=0`, exactly as in (1.7).

There is a sharper statement in the `c=0` branch.  The cubic Hasse term of
the identity `K(T_f(u+z))=0` is

\[
                              K(Az)=0.                  \tag{2.2}
\]

The `Delta`-adic condition in (2.2) is exact.  With the convention
`te_i=e_(i+1)`, a basis of `im Delta^3` is

\[
 (4,3,2,1,0),\qquad(0,4,3,2,1),                        \tag{2.3}
\]

and direct substitution gives

\[
 K\bigl(a(4,3,2,1,0)+b(0,4,3,2,1)\bigr)=0.             \tag{2.4}
\]

On the other hand `(1,3,1,0,0)` lies in `im Delta^2` and

\[
                         K(1,3,1,0,0)=2\ne0.            \tag{2.5}
\]

If `A=Delta^rU`, then `im A=im Delta^r`.  Equations (2.4)--(2.5)
therefore prove

\[
 \boxed{c=0\ \hbox{and}\ K(T_f)=0
        \quad\Longrightarrow\quad
        A\in(\Delta^3),\quad\operatorname{rank}A\le2.} \tag{2.6}
\]

The same statement holds at all eleven fixed lines by conjugacy.  This is a
uniform all-degree landing lemma.  It does not say that `df=0`: it controls
only the value of `df` along the eleven fixed lines.

## 3. A primitive counterfamily to finite fixed-line closure

Put

\[
 B_i=x_i^{11}-x_{i+1}^{11}.
\]

Every `B_i` vanishes on every `Lambda_a`.  For any positive integer
`M congruent to 1 mod 5`, define

\[
                         f_M=B_0^M x_1^5.               \tag{3.1}
\]

This is homogeneous of degree `11M+5` and has `C11`-weight one.  It has the
following exact properties.

1. It is `p`-primitive:

   \[
     df_M=M B_0^{M-1}x_1^5,dB_0\ne0.                  \tag{3.2}
   \]

2. Its five cyclic coordinates have gcd one.  Indeed, the irreducible
   factors of `B_i` are the forms `x_i-xi*x_(i+1)` with `xi^11=1`; no such
   factor, and no coordinate variable, divides all five cyclic products.

3. Since `M=5q+1`,

   \[
     f_M=(x_0^{11}-x_1^{11})(B_0^q x_1)^5.             \tag{3.3}
   \]

   Its two Frobenius residues are `e_0` and `e_1`.  Their difference is
   `e_1-e_0`, not a nonzero diagonal vector.  Thus it is neither a single
   Frobenius residue nor one of the sixteen progression families isolated
   in `CHAR5_MINIMAL_REDUCTION.md`.

4. For the ideal `I_a` of `Lambda_a`, every coordinate of `T_(f_M)` lies
   in `I_a^M`.  Hence all fixed-line Hasse derivatives of `T_(f_M)` of
   order `<M` vanish, while

   \[
                         K(T_{f_M})\in I_a^{3M}.         \tag{3.4}
   \]

   Thus all fixed-line Hasse equations for landing of order `<3M` hold
   trivially.

5. The Newton polytope of `f_M` is a segment.  The segment theorem in
   `CHAR5_NORMAL_FAN_ADDENDUM.md` therefore proves that `T_(f_M)` is
   dominant.  In particular `K(T_(f_M))` is not the zero polynomial.

Given any prescribed jet order `N`, choose `M>N` with `M congruent to 1
mod 5`.  Then (3.1) is gcd-one, `p`-primitive, outside the progression
families, and indistinguishable from the zero landing map by all fixed-line
Hasse tests through order `N`, yet its covariant is dominant.

Therefore no degree-independent finite collection of differential or
Hasse-jet conditions at the eleven fixed lines can force Frobenius descent,
force the progression classification, or decide dominance.  Allowing all
Hasse orders up to the degree simply reconstructs the full global identity
`K(T_f)=0` and gives no degree descent.

## 4. Strict boundary

The exact new positive statement is (2.6).  The exact no-go statement is the
primitive family (3.1).  The family is not a landing covariant and is not a
compression; it refutes only the proposed uniform finite fixed-line method.
No nonzero landing covariant is constructed, no all-degree dominance theorem
is proved, and the characteristic-five `F55` essential-dimension question
remains open.

Replay:

```sh
/opt/homebrew/bin/python3 verify_char5_fixed_line_hasse.py
```

Expected marker:

```text
F55-CHAR5-FIXED-LINE-HASSE-BOUNDARY-EXACT
```
