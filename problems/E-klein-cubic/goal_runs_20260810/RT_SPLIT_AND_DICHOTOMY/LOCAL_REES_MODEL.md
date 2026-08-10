# The `S subset X` local normalized-Rees model

## 1. Completed generic setup

Let `S` be a surface contained in the cubic threefold `X`.  At the generic
point of `S`, complete in the two ambient normal directions:
\[
R=K[[F,h]],
\qquad
K=\mathbf C(S),
\qquad
X=(F),
\qquad
S=(F,h).
\]
Write the ambient landing tuple as
\[
P_i=h^m a_i+F b_i,
\qquad m\ge1,
\tag{1.1}
\]
with the tuple `(a_i mod h)` primitive.  On a target affine chart choose
`a_0` a unit.  Let
\[
I=(P_0,\ldots,P_4)\subset R
\]
and define the cross-difference ideal
\[
C=(a_0b_i-a_ib_0: i=1,\ldots,4).
\tag{1.2}
\]
The exact identities
\[
a_0P_i-a_iP_0=F(a_0b_i-a_ib_0)
\tag{1.3}
\]
separate the rank-two and rank-one branches.

On `F=0`, the tuple is `h^m(a_i)`.  Removing the common factor `h^m`, the
restricted graph is built from the primitive tuple `(a_i)`; the ambient
normalized blowup, by contrast, retains the two-parameter `(F,h)` geometry.

## 2. Unit-minor/rank-two branch

### Proposition 2.1

If
\[
C=R,
\tag{2.1}
\]
then
\[
I=(F,h^m).
\tag{2.2}
\]

#### Proof

Equation (1.3) and (2.1) give `F in I`.  Then
`P_0-Fb_0=h^m a_0` and `a_0` is a unit, so `h^m in I`.  The reverse inclusion
is immediate from (1.1).  ∎

The integral closure of every power is the monomial ideal
\[
\overline{I^n}
=(F^a h^b: ma+b\ge mn).
\tag{2.3}
\]
The normalized blowup is the toric modification with fan rays
\[
e_F=(1,0),
\qquad
r=(m,1),
\qquad
e_h=(0,1).
\tag{2.4}
\]
Its two affine charts are
\[
U_h=\operatorname{Spec}K[[h,z]],
\qquad F=zh^m,
\tag{2.5}
\]
and
\[
U_F=\operatorname{Spec}
K[[F,h,w]]/(h^m-Fw).
\tag{2.6}
\]
The second is the normal `A_{m-1}` toric surface singularity.  Let `E` be the
exceptional prime and `D` the strict transform of `X=(F)`.  On (2.5),
\[
E=(h),
\qquad
D=(z),
\qquad
D\cap E=(h,z),
\tag{2.7}
\]
and as divisors
\[
p^*X=D+mE.
\tag{2.8}
\]
Thus the vertical and dominant components do meet in this rank-two branch.

After division by `h^m`, the target ratios on `E` are
\[
[P_0:\cdots:P_4]|_E
=[a_0+zb_0:\cdots:a_4+zb_4].
\tag{2.9}
\]
They sweep a target line exactly when the residue vectors `a` and `b` are
linearly independent.  This is the elementary local carrier geometry, not yet
a Hodge-transfer theorem.

## 3. What the specialization map actually is

The phrase “apply `psi_h` to the vertical strict-support block” is not correct
literally.  If a Hodge module `N` is already supported on `h=0`, then its
restriction to `h!=0` is zero and therefore
\[
\psi_h(N)=0.
\tag{3.1}
\]
Nearby cycles can detect gluing only when applied to the **total** direct-image
object before decomposing it into isolated strict-support summands.

In the smooth/unit-minor model, the cohomological base-change map from the
ambient exceptional summand to the dominant transform is the excess/Gysin
map.  For a class `alpha` on `S`, the exceptional class is represented by
`j_*rho^*alpha`; restricting to `D` and using the transverse intersection
(2.7) gives
\[
\widetilde i^{\,*}j_*\rho^*\alpha=i_{S*}\alpha.
\tag{3.2}
\]
Consequently, in this branch the corrected criterion is
\[
\boxed{
\text{the selected class reaches the dominant component}
\iff i_{S*}\alpha\ne0.
}
\tag{3.3}
\]
For the ambient `H^3` carrier this is the map
\[
H^1(S)(-1)\longrightarrow H^3(X).
\tag{3.4}
\]
Neither the local Rees equations nor equivariance force (3.4) to be nonzero on
the selected `V`-isotypic class.

## 4. Rank-one/degenerate branch

If
\[
C\subset(F,h),
\tag{4.1}
\]
then (1.1) does not determine the normalized Rees algebra.  Rees valuations
now depend on the valuations of all cross differences, higher minors, and
higher-order terms.  New exceptional rays may intervene between `E` and `D`,
exactly as in the CT1 toric countermodel.  Even after the fan is known, the
map on Hodge modules requires the gluing morphism of the total `IC` object;
it cannot be recovered from the strict-support list alone.

The exact unresolved step is therefore:

```text
compute the normalized Rees fan and the IC base-change/Gysin morphism in the
rank-one branch, and prove that the selected V-isotypic class has nonzero
image.
```

## 5. Validation against the exact `V4` local landing ideals

The prior `EXCEPTIONAL_CARRIER_RIGIDITY` packet records three decisive local
behaviors, all reproduced by the two-stage criterion

1. **joint-residue survival in the normalized Rees algebra**, then
2. **nonzero IC/Gysin gluing to the dominant component**.

### 5.1 The exact `(v,w)` ideal

For
\[
(p_s,p_r)=(v,w),
\]
the ideal is the smooth-axis ideal `(v,w)`.  Its normalized graph is the
ordinary blowup; the exceptional `P1` fiber maps by
\[
[V:W]\longmapsto[V:W]
\]
onto the target line.  The joint target residue has the required
transcendence degree, so the carrier survives.  This is the rank-two ordinary
model.

### 5.2 Weak line divisor that contracts

For
\[
p_s=uw+v^3,
\qquad
p_r=uv+w^3,
\]
the first weak transform has coefficient determinant
\[
W^4-V^4.
\]
The determinant is generically nonzero, so a divisor appears on the next weak
blowup.  Nevertheless the original pair has only a one-dimensional joint
target residue field; the divisor contracts to a curve on the normalized
Rees graph.  A unit weak determinant alone is not a survival criterion.

### 5.3 Weak conic divisor that contracts

For
\[
h_0=u^2+v^2+w^2,
\qquad
p_s=h_0v+u^3w,
\qquad
p_r=h_0w+u^3v,
\]
the weak conic determinant is
\[
u^3(v^2-w^2).
\]
Again a weak divisor is created but its joint target residue has transcendence
degree one, so it contracts.  This is precisely the rank-one warning in
Section 4.

`verify_local_rees.py` checks the toric rays and chart determinants, as well as
both displayed `V4` determinants, with exact integer/polynomial arithmetic.

## 6. Exit

The rank-two normalized Rees comparison and the corrected Gysin criterion are
proved.  They do not prove nonzero transfer, and the rank-one branch remains
unclassified.  Moreover, the requested standalone `psi_h` formulation is
false by (3.1).  The honest exit is

```text
SXX-LOCAL-REES-UNDECIDED
```
