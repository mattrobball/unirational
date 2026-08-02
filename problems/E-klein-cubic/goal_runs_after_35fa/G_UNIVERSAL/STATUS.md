G2-FINITE-GENERATION-PASS

# Goal G / G2 status — universal object and all-degree theorem complete

The structural G/G2 mission is complete.  The correct universal object is not
a finite list of symbolic-order bidegrees.  It is the generic
`PSL(2,11)`-twist of the Klein cubic over the projective invariant field,
with the global covariant lattice retained before localization.

Let

\[
S=\operatorname{Sym}(W^*),\qquad R=S^G,\qquad
M=(S\otimes W)^G,
\]

and let `q(p)=F(p)`.  On the generically free open of `P(W)`, write

\[
K_{\rm proj}=k(\mathbf P(W))^G
\]

and let `T/K_proj` be the generic `G`-torsor.  The universal landing object is

\[
X_T=T\times^G X,
\]

where `X=(F=0) subset P(W)`.  The packet proves the canonical bijections

\[
X_T(K_{\rm proj})
\longleftrightarrow
\{G\text{-equivariant rational maps }\mathbf P(W)\dashrightarrow X\}
\longleftrightarrow
\frac{\{0\ne p\in M_d\text{ for some }d:F(p)=0\}}
     {\text{homogeneous invariant scalar multiplication}}.
\]

For the Klein representation, the homogeneous frame

```text
B = (x,C,D,E,K_7),       degrees = (1,4,5,6,7)
```

and the degree-one element `tau=f3^2/f5` identify `X_T` with the explicit
cubic

\[
V(\Phi)\subset \mathbf P^4_{K_{\rm proj}}.
\]

The 35 coefficients of `Phi` are the already sealed exact data in
`goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json`.  Denominator clearing and
the reverse normalization are proved term by term, so this is an exact
all-degree theorem rather than a degree ladder.

Primitive versus scalar-multiple covariants are also closed.  The gcd of the
coordinates of a genuine covariant is a semi-invariant.  The exact
12-point permutation model verifies that `PSL(2,11)` has order 660 and equals
its commutator subgroup, hence has no nontrivial characters; the gcd is
therefore invariant.  Dividing it out preserves equivariance and landing,
and primitive representatives are unique up to a ground-field scalar.

The 55 symbolic plus-plane orders, `V4` triple-line equalizers, point kernels,
minus-line and `C3/C6/A4/D10/D12` links, marked elliptic data, and finite
irrelevant torsion remain present as functorial restrictions of the one global
polynomial vector obtained after clearing denominators.  No converse from an
independently chosen local inverse-limit state is asserted.

The Hironaka presentation

\[
A=k[f_3,f_5,f_6,f_8,f_{11}],\qquad
\operatorname{rank}_A R=12,\qquad \operatorname{rank}_A M=60
\]

is finite and noetherian.  The packet also proves the necessary scope fence:
finite generation does not imply a bound for the first primitive cubic zero,
and no finite bidegree cutoff is claimed.  The degree-free generic twist is
the corrected effective reduction.

## Headline scope

The Klein cubic headline remains **OPEN**.  This exit proves the universal
object and the all-degree equivalence.  It does not decide

\[
V(\Phi)(K_{\rm proj})=\varnothing
\quad\text{versus}\quad
V(\Phi)(K_{\rm proj})\ne\varnothing.
\]

That single arithmetic alternative is now the only remaining G-route gate.

## Replay

From `problems/E-klein-cubic`:

```text
python3 goal_runs_after_35fa/G_UNIVERSAL/verify.py
```
