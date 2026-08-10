# Point-supported ambient Hodge blocks

Let `x` support a simple summand of

\[
{}^pH^{-1}(Rp_*IC_Y^H)
\]

and let `H=Stab_G(x)`.  Then the summand is `i_{x*}W_x` for a pure
weight-three rational Hodge structure `W_x`, canonically occurring as a direct
summand of

\[
\mathbb H^{-1}(p^{-1}(x),IC_Y^H).
\]

If the actual ambient class projects nontrivially to the `G`-orbit of this
point block, then

\[
\operatorname{Hom}_{\mathrm{HS},H}
\left(\operatorname{Res}_H V,W_x(1)\right)\ne0.
\]

Conversely, this nonzero projection is equivalent by Frobenius reciprocity to
a nonzero `V`-isotypic map into the orbit block
`Ind_H^G W_x`.  The map from the complete fiber to its target-limit
subvariety is proper and onto its image, but need not be finite; consequently
the condition is on weight-three fiber intersection cohomology, not on a
finite target cover.

The degree/orbit accounting in `DEGREE_ACCOUNTING.md` does not eliminate this
channel in the live coordinate range.

```text
POINT-SUPPORT-CHARACTERIZED
```
