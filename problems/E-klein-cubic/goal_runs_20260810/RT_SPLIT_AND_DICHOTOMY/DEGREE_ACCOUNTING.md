# Degree/orbit accounting and point-supported escape

## 1. Refined Bezout bounds

Let `B=Bs(I_A)` be the base scheme of a primitive tuple of five degree-`d`
forms on `P4`.  Refined Bezout (equivalently, the distinguished-variety form
of the degree bound for an ideal generated in degree `d`) gives

\[
\sum_{\substack{Z\subset B\\\operatorname{codim}Z=c}}
 m_Z\deg Z\le d^c
\qquad(c=2,3,4),
\tag{1.1}
\]

where the sum is over the codimension-`c` irreducible components and the
multiplicities are positive.  Therefore

\[
\begin{array}{c|c}
\text{component dimension}&\text{total reduced-orbit degree bound}\\ \hline
2&d^2\\
1&d^3\\
0&d^4
\end{array}
\tag{1.2}
\]

No proper-intersection assumption between all five generators is being made;
(1.1) is precisely the refined, mixed-dimensional version needed here.

If a support has orbit size `n`, every distinct component has degree at least
one, so a necessary condition is

\[
n\le d^{4-\dim S}.
\tag{1.3}
\]

## 2. Exact orbit thresholds

The relevant smallest orbit sizes are the indices of maximal subgroups

\[
11,11,12,55,66,
\]

and a free orbit has size `660`.  The smallest coordinate degree permitted by
(1.3) is:

| orbit type | size | surface (`d^2`) | curve (`d^3`) | point (`d^4`) |
|---|---:|---:|---:|---:|
| first index-11 class | 11 | 4 | 3 | 2 |
| second index-11 class | 11 | 4 | 3 | 2 |
| index 12 | 12 | 4 | 3 | 2 |
| index 55 | 55 | 8 | 4 | 3 |
| index 66 | 66 | 9 | 5 | 3 |
| free | 660 | 26 | 9 | 6 |

These are exact integer ceilings, replayed by
`verify_degree_accounting.py`.

## 3. Comparison with the live ambient degree range

The accepted all-ambient lower bound is

\[
d\ge22,
\]

and there is no upper bound.  Hence the cells killed by degree/orbit size are
exactly:

| dimension | orbit type | dead ambient degrees |
|---|---|---|
| surface | free | `22,23,24,25` |

Every nonfree surface cell survives throughout the live range; every curve and
point cell, including the free orbit, already survives at `d=22`.  From
`d=26` onward even the free surface cell survives.

For the degree-one retraction subproblem the accepted bound is `d>=24`, so the
only dead cells are:

| dimension | orbit type | dead retraction degrees |
|---|---|---|
| surface | free | `24,25` |

Thus degree accounting does **not** exclude the free-support escape.  It only
removes four low-degree free-surface cells (two in the retraction window).

## 4. Point support in perverse degree `j0=-1`

Let `x` be a point support for

\[
{}^pH^{-1}(Rp_*IC_Y^H),
\]

and put `H=Stab_G(x)`.  Its strict-support summand has the form

\[
i_{x*}W_x,
\]

where `W_x` is a pure weight-three rational Hodge structure.  Proper base
change realizes it as a direct summand

\[
W_x\subset
\mathbb H^{-1}\bigl(p^{-1}(x),IC_Y^H\bigr).
\tag{4.1}
\]

If `Y` is smooth along the fiber, the right side is the degree-three
cohomology of the fiber in ordinary indexing.  In general it is
intersection-complex hypercohomology and must not be replaced by ordinary
`H^3` without that hypothesis.

A point orbit receives the actual Klein class only if

\[
\boxed{
\operatorname{Hom}_{\mathrm{HS},H}
\left(
\operatorname{Res}_H V,
W_x(1)
\right)\ne0.
}
\tag{4.2}
\]

Equivalently, over the whole orbit the point block is

\[
\operatorname{Ind}_H^G W_x,
\]

and its `V`-isotypic projection is nonzero.  The twist `W_x(1)` is effective
of weight one, so it has the same CM-isotypic requirement as the ambient
support abelian factor.

The proper morphism `q` maps the complete fiber onto the target-limit
subvariety

\[
Z_x=q\bigl(p^{-1}(x)\bigr)\subset X.
\tag{4.3}
\]

The map in (4.3) is surjective onto its image by definition and properness.  It
need not be finite, generically finite, or equidimensional.  Condition (4.2)
therefore constrains the weight-three intersection cohomology and the
`H`-representation of the fiber, not merely the cohomology of `Z_x` and not a
finite cover of it.

The `j0=-1` channel is exactly where the Artin injection from the proposed
clean transfer fails: its relevant base cohomological degree is zero.

## Surviving cells and exits

All free curve and point cells survive for every live ambient degree `d>=22`;
free surfaces survive for every `d>=26`.  No existing degree cutoff removes
those cells.

```text
POINT-SUPPORT-CHARACTERIZED
SUPPORT-ESCAPE-UNDECIDED
```
