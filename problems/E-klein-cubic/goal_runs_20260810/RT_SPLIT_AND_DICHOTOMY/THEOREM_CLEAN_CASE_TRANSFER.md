# Ambient support not contained in the cubic: what the Artin argument proves

## 1. Statement actually proved

Let

\[
i:X\hookrightarrow\mathbf P^4,
\qquad
j:U=\mathbf P^4\setminus X\hookrightarrow\mathbf P^4,
\]

and let

\[
\mathcal M=\mathcal M_{S,j_0}
\subset{}^pH^{j_0}(Rp_*IC_Y^H)
\]

be an ambient strict-support block receiving the actual copy of `V`.  Assume

\[
S\not\subset X,
\qquad
j_0\ge0.
\tag{1.1}
\]

Put `k=-1-j0`.  Then the restriction map

\[
H^k(\mathbf P^4,\mathcal M)
\longrightarrow
H^k(X,i^*\mathcal M)
\tag{1.2}
\]

is injective.  Consequently the selected `V`-class is nonzero after **raw
derived base change** to

\[
Y_X=Y\times_{\mathbf P^4}X.
\tag{1.3}
\]

This closes the proposed Artin-vanishing step, including its exact perverse
range.  It does not by itself close dominant-component selection.

## 2. Artin-vanishing proof

The triangle

\[
j_!j^*\mathcal M\longrightarrow\mathcal M
\longrightarrow i_*i^*\mathcal M\xrightarrow{+1}
\tag{2.1}
\]

gives

\[
H_c^k(U,\mathcal M|_U)
\longrightarrow H^k(\mathbf P^4,\mathcal M)
\longrightarrow H^k(X,i^*\mathcal M).
\tag{2.2}
\]

The complement `U` is affine and `M|U` is perverse.  Artin vanishing gives

\[
H_c^r(U,\mathcal M|_U)=0
\qquad(r<0).
\tag{2.3}
\]

Because `k=-1-j0<=-1`, (1.2) is injective.  This is the exact reason for the
hypothesis `j0>=0`.  When `j0=-1`, one has `k=0`, and (2.3) supplies no
injectivity; that is the point/curve-support channel treated separately in
`DEGREE_ACCOUNTING.md`.

Proper base change identifies the target of (1.2) with the corresponding
summand in

\[
R(p_X)_*\widetilde i^*IC_Y^H.
\tag{2.4}
\]

Thus CT2's possible total vanishing is excluded on the raw fiber product in
this degree range.

## 3. The requested CT1 assertion is false without another hypothesis

Let `F=0` define `X`.  If an exceptional prime `E` dominates a support
`S not subset X`, then

\[
\operatorname{ord}_E(F)=0.
\tag{3.1}
\]

This proves that `E` itself is not an irreducible component of the Cartier
pullback `p^{-1}(X)`.  It does **not** prove that

\[
E\cap p^{-1}(X)
\]

meets the component dominating `X`.

A local iterated-blowup model gives the obstruction.  On a smooth fourfold,
let `S` be a smooth codimension-two center not contained in `X`, blow up `S`,
and call the exceptional divisor `E1`.  The strict transform `D1` of `X`
meets `E1` over `T=S cap X`.  Now blow up the smooth codimension-two
intersection

\[
C=E_1\cap D_1.
\]

On the resulting normal model, the strict transforms `E1'` and `D2` are
disjoint; the new exceptional divisor `E2`, which maps into `T`, lies between
them:

\[
E_1'\cap p^{-1}(X)=E_1'\cap E_2,
\qquad
E_1'\cap D_2=\varnothing.
\tag{3.2}
\]

The composite projective birational morphism is, after choosing a relatively
ample exceptional divisor and a Veronese, the normalized blowup of a coherent
ideal.  Hence (3.2) is a normalized-Rees local model, not merely a forbidden
arbitrary resolution.  It shows:

```text
ord_E(F)=0
```

does not imply direct incidence with the dominant transform.  A selected
strict-support class can first specialize to a component centered in `T`; an
additional Hodge comparison is needed to show that it crosses that component
to `D2`.

Thus the proposed CT1 sentence, as stated in the work order, cannot be used as
a theorem for every landing ideal.

## 4. Normalization does not repair the missing comparison

Let `D` denote the component of the raw fiber product dominating `X`, and let

\[
\nu:\Gamma\longrightarrow D
\]

be its finite normalization.  The correct statement is that

\[
\nu_*IC_\Gamma^H
\]

is semisimple perverse, contains `IC_D^H`, and can contain additional proper-
support summands recording branch separation.  No statement that a finite or
small map simply preserves `IC` is used.

However, semisimplicity only describes the target **after** a nonzero map to
the dominant component has been constructed.  It does not supply a morphism
from a class supported on an intervening vertical component such as `E2` in
(3.2).  Therefore it cannot turn the raw-base-change injection (1.2) into the
required comparison with `Gamma`.

A sufficient additional hypothesis would be any one of the following, stated
at the selected strict-support generic point:

1. the closure carrying the selected local system meets `D` directly;
2. the base-changed normalized Rees algebra has no intervening minimal prime
   centered in `S cap X` on that block; or
3. an explicitly constructed specialization/Gysin morphism is nonzero on the
   selected `V`-isotypic class through every intervening component.

None is presently proved for an arbitrary ambient landing ideal.

## Exit

```text
CLEAN-CASE-TRANSFER-UNDECIDED
```

Exact failing step: Artin vanishing proves nonzero raw restriction, but
`S not subset X` does not prove CT1 for the selected component, and finite
normalization does not manufacture the missing CT3 map.
