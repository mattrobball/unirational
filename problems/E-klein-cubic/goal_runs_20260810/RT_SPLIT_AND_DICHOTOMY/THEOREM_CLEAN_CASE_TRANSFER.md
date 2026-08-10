# Clean-case ambient-to-restricted transfer: exact partial theorem and CT1 countermodel

## 1. Setup

Let
\[
p:Y\longrightarrow \mathbf P^4
\]
be the ambient normalized Rees graph and let
\[
M=\mathcal M_{S,j_0}
\subset {}^pH^{j_0}(Rp_*IC_Y^H)
\]
be a selected strict-support perverse Hodge-module block satisfying `(AHS)`.
Assume
\[
S\not\subset X.
\]
Write
\[
j:U=\mathbf P^4\setminus X\hookrightarrow\mathbf P^4,
\qquad
i:X\hookrightarrow\mathbf P^4.
\]
The complement `U` is affine because `X` is a hypersurface.

## 2. The perverse-degree injection is proved

### Proposition 2.1

For every perverse Hodge module `M` on `P4`, the restriction map
\[
H^k(\mathbf P^4,M)\longrightarrow H^k(X,i^*M)
\tag{2.1}
\]
is injective for `k<=-1`.

#### Proof

Apply hypercohomology to
\[
j_!j^*M\longrightarrow M\longrightarrow i_*i^*M\xrightarrow{+1}.
\]
Since `U` is affine and `j^*M` is perverse, Artin vanishing gives
\[
H_c^k(U,j^*M)=0\qquad(k<0).
\]
The term immediately to the left of (2.1) is therefore zero for `k<=-1`,
which proves injectivity.  ∎

For the ambient block, the relevant degree is
\[
k=-1-j_0.
\]
Thus the hypothesis is **exactly**
\[
j_0\ge0.
\tag{2.2}
\]
Under (2.2), a nonzero ambient `(AHS)` class remains nonzero after derived
restriction to `X`.  The point-support channel `j_0=-1` lies exactly outside
this statement and is treated separately.

## 3. The normalization statement is proved in the required form

Let `D` be an irreducible dominant component of the scheme-theoretic base
change of the ambient graph and let
\[
\nu:\Gamma\longrightarrow D
\]
be its finite normalization.  Because `nu` is finite, `nu_*` is perverse
`t`-exact.  Proper direct image of the pure object `IC_Gamma^H` is semisimple,
and because `nu` is birational it has a unique full-support constituent
`IC_D^H`.  Hence
\[
\nu_*IC_\Gamma^H
\simeq IC_D^H\oplus K_{\rm br},
\tag{3.1}
\]
where every simple constituent of `K_br` has proper support contained in the
branch/non-normal locus.  No assertion that a finite or small map “preserves
`IC`” is made.  The possible extra summands are harmless for a theorem whose
conclusion only asks for proper support on `Gamma`.

## 4. CT1 is false under `S not subset X`

The missing geometric assertion was:

> base change by `X` cannot create a component over `S cap X` that separates
> the exceptional divisor dominating `S` from the dominant transform.

The following exact normalized-Rees model disproves it.

### Proposition 4.1 — toric CT1 countermodel

Work on
\[
\mathbf A^4=\operatorname{Spec}k[x,y,t,s],
\qquad
X=(t),
\qquad
S=(x,y).
\]
Then `S` is not contained in `X` and `T=S cap X=(x,y,t)` is a line.  Take the
monomial ideal
\[
I=(x,y)(x,y,t)=(x^2,xy,y^2,xt,yt).
\tag{4.1}
\]
Its Newton polyhedron has the noncoordinate facet inequalities
\[
a+b\ge1,
\qquad
a+b+c\ge2.
\]
The normalized blowup has rays
\[
r_S=(1,1,0),
\qquad
r_T=(1,1,1),
\]
and maximal cones
\[
\begin{aligned}
&\langle e_x,r_S,r_T\rangle,
&&\langle e_y,r_S,r_T\rangle,\\
&\langle e_x,r_T,e_t\rangle,
&&\langle e_y,r_T,e_t\rangle.
\end{aligned}
\tag{4.2}
\]
Every determinant in (4.2) has absolute value one, so this is already a smooth
normal toric model.

The ray `r_S` is the exceptional divisor dominating `S`; the ray `e_t` is the
strict transform of `X`.  No cone in (4.2) contains both rays.  Therefore
\[
E_S\cap\widetilde X=\varnothing.
\tag{4.3}
\]
The ray `r_T`, centered over `T`, lies between them and separates them.  On
restriction to `t=0`, the ideal is
\[
I|_X=(x,y)^2,
\]
whose normalized blowup is the ordinary blowup of `(x,y)`.  Thus the
restricted graph has exceptional geometry over `T`, but it does not receive
the ambient divisor over the generic point of `S`.

The extra coordinate `s` makes the model four-dimensional and makes `S` a
surface, exactly matching the ambient codimension-two geometry.  ∎

This countermodel does not assert that the selected Klein block actually
occurs in (4.1).  It proves the logically necessary point: `S not subset X`
and `j_0>=0` do **not** imply CT1.  Any positive transfer theorem needs an
additional hypothesis excluding intervening Rees valuations centered on
`S cap X`, or it must prove such exclusion from the global landing identity.

## 5. Exit

The Artin and finite-normalization parts are proved, but the requested theorem
fails at CT1 under its stated hypotheses.  Therefore the honest exit is

```text
CLEAN-CASE-TRANSFER-UNDECIDED
```

Exact failing step:

```text
CT1 (dominant-component incidence) is false for the normalized Rees algebra
of I=(x,y)(x,y,t): the divisor over S=(x,y) and the strict transform X=(t)
share no cone and are disjoint.
```

`verify_local_rees.py` checks the primitive rays, the four unimodular cones,
and the nonincidence (4.3) exactly.
