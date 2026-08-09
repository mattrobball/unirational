# Local normalized-Rees model at a marked `V4` point

## 1. Completed local setup

Let `x` be type I or type II and choose completed equivariant coordinates
\[
A=\widehat{\mathcal O}_{X,x}=\mathbf C[[u,v,w]],
\qquad
u\sim\chi_z,
\quad v\sim\chi_s,
\quad w\sim\chi_r,
\]
where
\[
\chi_z\chi_s\chi_r=1.
\]
Let
\[
J_x=(p_0,\ldots,p_4)\subset A
\]
be the completed primitive ideal of the actual restricted landing tuple.  Its
normalized local graph is
\[
\Gamma_x=\operatorname{Proj}_A\overline{\mathcal R(J_x)}.
\]

The first ordinary blowup of `x` has exceptional divisor
\[
D=\mathbf P(\chi_z\oplus\chi_s\oplus\chi_r).
\]
This `D` is a computational model, not automatically a component of
`Gamma_x`.

## 2. Residue-field survival criterion

Let `v_*` be a divisorial valuation centered at `x`, possibly created by
blowing up a curve in `D` or a later weak base locus.  Choose a minimal target
coordinate `p_j`.  Define
\[
L_{v_*}=\mathbf C\bigl(
\overline{p_i/p_j}
\bigr)\subset\kappa(v_*).
\]
Then the center of `v_*` on `Gamma_x` has dimension
\[
\operatorname{trdeg}_{\mathbf C}L_{v_*}.
\]
Since `Gamma_x` is three-dimensional, `v_*` survives as a prime divisor if and
only if this number is two.

This is the required distinction between:

```text
prime in a weak base locus
        versus
prime divisor of Proj(normalized Rees).
```

A determinant showing that two weak generators generate the normal ideal to a
curve proves that the next blowup resolves the weak ideal generically.  It does
**not** prove that the resulting divisor survives the contraction to the
normalized graph of the original ideal.

## 3. Consequence for fixed target curves

If the initial ratios of a point-centered valuation land in `L_z` or `E_z`,
then `trdeg L_v≤1`; the divisor contracts.  Thus:

> No line-valued or elliptic-valued divisor centered at a marked point is a
> Rees divisor of the restricted base ideal.

A line-valued bypass can still occur as a curve in the actual normalized fiber,
as the special fiber of a divisor centered on an incident source curve, or as a
fixed curve slice in a surface-valued point-centered Rees divisor.

## 4. Exact ordinary bypass model

After a harmless common character twist, the target vector plane whose
projectivization is `L_z` has characters `chi_s` and `chi_r`.  Consider
\[
(p_s,p_r)=(v,w).
\tag{4.1}
\]
The image lies in the actual target line `L_z`, so the Klein landing equation is
identically satisfied.  The ideal is the ideal of the smooth `u`-axis.  Its
normalized graph is the ordinary blowup of that axis.  The exceptional divisor
is a `P1`-bundle, and its fiber over `x` is
\[
\mathbf P(\chi_s\oplus\chi_r).
\]
The map on that fiber is
\[
[V:W]\longmapsto[V:W]\in L_z.
\]
This is a genuine component of the normalized graph for the exact local ideal
(4.1).  It is an ordinary fixed slice, not a point-centered Rees divisor.

The power model
\[
(p_s,p_r)=(v^m,w^m)
\tag{4.2}
\]
has the same normalized source carrier for every `m>=1`; on the special fiber
it maps by `[V^m:W^m]`.  For odd `m` it has the same character parity as (4.1).
This shows that the normalized carrier does not determine the degree of its
actual target morphism.

## 5. A bypass weak divisor that contracts

Consider the `V4`-equivariant pair
\[
p_s=uw+v^3,
\qquad
p_r=uv+w^3.
\tag{5.1}
\]
On the first point blowup, in the chart
`u=eU, v=eV, w=eW`, the weak pair is
\[
UW+eV^3,
\qquad
UV+eW^3.
\]
It vanishes along the line `(U,e)=0` in `D`.  With normal parameters `(U,e)`,
the coefficient determinant is
\[
W^4-V^4,
\]
which is nonzero at the generic point.  Blowing up this weak line creates a
divisor on that refinement.

Nevertheless the original pair maps only to `L_z`.  Its point-centered joint
residue field has transcendence degree one, so the refinement divisor contracts
to a curve on `Gamma_x`.  The ideal in (5.1) has height two and is a complete
intersection; its ordinary blowup has a `P1` fiber at `x`, and normalization is
finite over that fiber.  Thus the actual carrier is a line-valued curve, not the
weak divisor.

## 6. A conic weak divisor that contracts

Put
\[
h=u^2+v^2+w^2
\]
and
\[
p_s=hv+u^3w,
\qquad
p_r=hw+u^3v.
\tag{6.1}
\]
The pair is `V4`-equivariant and lands in `L_z`.  On the first point blowup its
weak transform is
\[
HV+eU^3W,
\qquad
HW+eU^3V,
\qquad H=U^2+V^2+W^2.
\]
It vanishes on the faithful invariant conic `(H,e)=0`.  The determinant in the
normal parameters `(H,e)` is
\[
U^3(V^2-W^2),
\]
nonzero generically on the conic.  Hence the next blowup creates a weak divisor.
The joint-residue theorem again contracts it because its target is a curve.
The pair is a height-two complete intersection, so the normalized graph has a
curve fiber rather than the claimed conic divisor.

This is an explicit obstruction to promoting the abstract invariant conic, or
a determinant on its weak ideal, to an actual Rees component.

## 7. What remains to compute for the genuine ideal

For the actual `J_x`, one must compute both layers:

1. **Divisorial layer:** all point-centered valuations and the transcendence
   degree of their joint target residues; retain only degree-two residue fields.
2. **Curve layer:** all irreducible curve components of the normalized fiber,
   plus all involution-fixed curve slices inside retained stable surfaces.

The first layer is valuative.  The second is not recoverable from the list of
Rees valuations alone.  Both are needed for type-I/type-II propagation.

## 8. Exact verification

`verify_local_models.py` checks the character eigenweights, the two weak
coefficient determinants, coprimality of the complete-intersection pairs, the
Veronese/normalized-power exponent statement for `(v^3,w^3)`, and the Newton
normals in the multiple-valuation adversarial family.  Its output is
`LOCAL_MODELS.json`.
