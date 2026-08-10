# The codimension-two local Rees model for `S subset X`

## 1. Generic transverse algebra

At the generic point of a surface

\[
S=(F,h)\subset X=(F)\subset \mathbf P^4,
\]

adjoin the function field `K=C(S)` and work in the complete regular local ring

\[
R=K[[F,h]].
\]

Write the ambient tuple as

\[
P_i=h^m a_i+F b_i,\qquad m\ge 1,
\tag{1.1}
\]

with `a` primitive modulo `h`. Choose `a_0` a unit and put

\[
c_i=a_0b_i-a_ib_0.
\tag{1.2}
\]

If some `c_i` is a unit, exact row operations give

\[
(P_0,\ldots,P_4)=(F,h^m).
\tag{1.3}
\]

Indeed, `P_i-(a_i/a_0)P_0=F c_i/a_0`, and then (1.1) recovers `h^m`. Thus the normalized Rees algebra is the normalized monomial Rees algebra of `(F,h^m)`, with primitive exceptional valuation

\[
v(h)=1,\qquad v(F)=m.
\tag{1.4}
\]

After restricting to `F=0`, the tuple is `h^m a`; primitive reduction removes `h^m` and leaves the unit tuple `a`. Consequently

\[
\Gamma\simeq X
\quad\text{over the generic point of }S.
\tag{1.5}
\]

The raw base change of the ambient blowup still has a vertical monomial component meeting the dominant component over `h=0`, but the restricted normalized graph retains only the normalization of the component dominating `X`.

If every `c_i` lies in `(F,h)`, the first-order vectors have rank one. Then (1.1) does not determine the normalized Rees algebra. One must know the Newton data and all higher orders of the minors

\[
a_ib_j-a_jb_i.
\tag{1.6}
\]

Multiple Rees valuations can occur. This is the first exact local-model boundary.

## 2. Why the proposed nearby-cycle criterion is not determined by (1.1)

The ambient-to-restricted comparison is base change by `F=0`; the relevant nearby and vanishing cycles are therefore `psi_F` and `phi_F`. The parameter `h` cuts out `S` inside `X`. Thus `psi_h` describes approach to `S` along the restricted geometry, but is not by itself the ambient-to-restricted comparison functor.

There is also a categorical obstruction. A strict-support Hodge module supported entirely on a vertical component contained in `h=0` restricts to zero on `h\ne0`, hence

\[
\psi_h(\mathcal M_{\mathrm{vertical}})=0.
\tag{2.1}
\]

Possible transfer to the dominant component is encoded in the gluing morphism of the whole intersection complex before strict-support projection, or in an explicit Gysin/specialization map at the intersection of the components. That morphism depends on local monodromy and the IC extension data. It is not determined by the normalized Rees semigroup, the integer `m`, or the rank of `a(0),b(0)`.

Thus even in the rank-two monomial model the following are different data:

1. the vertical and dominant components meet;
2. an IC class restricts nontrivially to their intersection;
3. `psi_h` of a summand supported on the vertical component is nonzero; and
4. the selected global `V`-isotypic Hodge class has a nonzero map to the dominant restricted graph.

Only item 1 follows from (1.3). The requested theorem concerns item 4.

## 3. Validation against the exact `V4` models

The prior packet `EXCEPTIONAL_CARRIER_RIGIDITY/LOCAL_REES_MODEL.md` supplies three load-bearing checks.

### The `(v,w)` ideal

For the exact ideal `(v,w)`, the normalized graph is the ordinary blowup of the incident source curve. Its exceptional `P^1` fiber maps nonconstantly to the bypass line. Actual component attachment is present, so a restriction/Gysin map can be nonzero. This is not a point-centered Rees divisor and is not inferred from a weak divisor on a refinement.

### The contracted weak line

For

\[
(uw+v^3,\ uv+w^3),
\]

the weak-line determinant is

\[
W^4-V^4.
\]

It is generically nonzero, so a refinement creates a divisor, but the joint target residue field has transcendence degree one. The divisor contracts on the normalized graph; only a curve fiber remains.

### The contracted weak conic

For

\[
(hv+u^3w,\ hw+u^3v),\qquad h=u^2+v^2+w^2,
\]

the weak-conic determinant is

\[
u^3(v^2-w^2).
\]

Again the refinement divisor contracts because its joint target residue field has transcendence degree one.

The determinant calculations and the monomial valuation (1.4) are replayed by `verify_local_rees.py`. These examples rule out any criterion saying that nondegenerate weak normal data, or merely the existence of a refinement divisor, forces nonzero specialization on the normalized dominant graph. They also show that nonzero attachment can occur in the `(v,w)` model. The criterion must use the actual IC gluing map, not only Rees survival.

## 4. Exact missing theorem

To decide the `S subset X` channel one must specify the complete normalized local Rees algebra, including the higher minors (1.6), form the total IC Hodge module on its reducible `F=0` base change, and compute the specialization/Gysin map

\[
\text{vertical strict-support block}
\longrightarrow
R\pi_{\Gamma *}IC_\Gamma^H
\tag{4.1}
\]

on the selected `V`-isotypic summand. Neither (1.1) nor the joint-residue field of a divisor determines (4.1). No such calculation is available for an arbitrary actual landing ideal.

## Exit

```text
SXX-LOCAL-REES-UNDECIDED
```

Exact gap: the rank-two case determines the normalized monomial Rees geometry but not the IC gluing/specialization map; the rank-one case does not determine the normalized Rees algebra without all higher minors. Moreover the ambient restriction functor is governed by `psi_F`, not by `psi_h` alone.
