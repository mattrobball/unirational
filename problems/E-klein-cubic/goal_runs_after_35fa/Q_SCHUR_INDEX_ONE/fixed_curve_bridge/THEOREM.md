# The exact fixed-curve arithmetic bridge

Let `K=K_Schur` (characteristic zero), let `X=X_Schur/K` be the genuine
generic twist, and use its given embedding `X subset P4_K`.  The conclusions
below distinguish an actual descended curve or map from a point of a coarse
moduli space and from a virtual incidence class.

## Theorem A: an actual odd-degree genus-zero map is enough

Let `f:C -> X` be an **actual morphism over `K`**, where `C` is a proper,
geometrically connected nodal curve of arithmetic genus zero.  If

```text
deg f^* O_X(1)
```

is odd, then `C(K)` and hence `X(K)` are nonempty.  In particular, every
actual `K`-defined genus-zero stable map of degree three forces a
`K`-point of `X`, even when its domain is reducible and has contracted
components.

Proof.  Let a finite quotient `H` of `Gal(Kbar/K)` act on the geometric dual
tree of `C`.  A finite group acting on a tree fixes a vertex or an unoriented
edge.  A fixed edge is a `K`-rational node of `C`, so suppose there is no
fixed edge.  There is then a unique fixed vertex `v`.  The normalization `B`
of the corresponding `K`-component is a smooth projective genus-zero curve
over `K`.

The incident edges at `v` occur in `H`-orbits.  An odd orbit gives an
odd-degree effective divisor on `B`.  If every incident-edge orbit has even
size, the sum of the degrees of `f^*O_X(1)` on every orbit of branches away
from `v` is even; since the total degree is odd, its restriction to `B` has
odd degree.  Thus in either case `B` has an actual `K`-line bundle of odd
degree.

A smooth genus-zero curve is a Brauer--Severi conic.  In the exact sequence

```text
Pic(B) -> Pic(B_Kbar)^Gal = Z -> Br(K),
```

the image of `1` is its Brauer class `alpha`, and `2 alpha=0`.  An actual
line bundle of odd degree `d` gives `d alpha=0`, hence `alpha=0`.  Therefore
`B` is split and has a `K`-point.  Its image gives a point of `C(K)` and then
of `X(K)`.

Two useful special cases are immediate.

1. A smooth embedded twisted cubic over `K` is split: its actual line bundle
   `O_C(1)` has degree three.  This argument does not need the intermediate
   Jacobian.
2. More generally, a `K`-defined geometrically integral genus-zero curve of
   odd projective degree has a split normalization, so it gives `X(K)`.

The word **actual** matters.  The geometric degree-one class on a nonsplit
Brauer--Severi conic is Galois invariant but does not descend to a line
bundle.  A morphism to projective space does supply the required descended
line bundle, which is why an actual odd-degree map is decisive.  By contrast,
an even-degree `K`-defined genus-zero curve can have no `K`-point; an
anisotropic plane conic is the standard example.

## Theorem B: every generalized-twisted-cubic Hilbert point is enough here

Let `Tbar` be the closure of the smooth twisted-cubic locus in the Hilbert
scheme of the cubic threefold, and let `M_X -> Theta subset J(X)` be the
moduli desingularization used in the audited rational-curve packet.  After
twisting by the Schur torsor, every actual point

```text
h in (Tbar)^T(K)
```

forces `X(K)` to be nonempty, including boundary Hilbert subschemes that are
reducible, nonreduced, or non-Cohen--Macaulay.

Indeed, Proposition 7.2 of Bayer--Beentjes--Feyzbakhsh--Hein--Martinelli--
Rezaee--Schmidt gives the functorial morphism `Tbar -> M_X`.  Their Theorem
7.1 identifies `M_X -> Theta` with the blowup at `0`, with scheme-theoretic
exceptional fibre `X`.  These canonical constructions are
`Aut(X)`-equivariant and therefore descend to the Schur twist.  The exact
period-lattice audit in `R_RATIONAL_CURVES_CODEX/` is written for
`K_proj=C(P(W))^G`, so its field label cannot simply be imported.  Its proof
does extend verbatim to the present field: twisting adjunction identifies a
`K_Schur`-point of the Jacobian twist with a rational `G`-map
`P(V6) --> J(X)`; every rational map from projective space to an abelian
variety is constant; and the independently computed period lattice gives
`J(X)(C)^G=0`.  The copied `verify_fixed_jacobian.py` reconstructs the
integral period-lattice action, group relations, and trivial common fixed
subgroup from `fixed_jacobian_payload.json`.  Hence, now over the correct
field,

```text
J(X)^T(K_Schur) = {0}.
```

Consequently the image of `h` in `M_X^T(K)` lies over zero and therefore in
the exceptional fibre `X^T(K)`.  This argument is stronger than inspecting
the support of a degenerate Hilbert subscheme: the resulting point is
obtained through the moduli contraction.

Primary source for the moduli statements: A. Bayer et al., *The
desingularization of the theta divisor of a cubic threefold as a moduli
space*, Theorem 7.1 and Proposition 7.2,
<https://arxiv.org/abs/2011.12240>.

## Stable-map and incidence boundary

The following implications are exact.

| incidence output over `K` | does it force `X(K)`? | reason |
|---|---:|---|
| smooth embedded twisted cubic | yes | actual odd-degree polarization; also a fine Hilbert point |
| actual degree-three genus-zero stable map | yes | Theorem A, including reducible domains |
| actual point of the generalized-twisted-cubic Hilbert component | yes | Theorem B, including all Hilbert boundary points |
| coarse stable-map point with trivial stabilizer | yes | it descends to an actual stable map; embeddings have trivial stabilizer |
| coarse stable-map point with nontrivial stabilizer | not without a lift | a field of moduli need not be a field of definition; the residual gerbe can obstruct descent |
| Galois-stable orbit / zero-cycle of maps or curves | no | it is not an individual `K`-point of either moduli problem |
| virtual Gromov--Witten class or virtual count | no | it need not be a finite reduced incidence scheme or an actual object |
| `K`-defined even-degree genus-zero curve | no in general | its Brauer--Severi normalization can be nonsplit |

The Hilbert scheme is a fine parameter space, so a genuinely Galois-fixed
geometric Hilbert point descends to an actual `K`-subscheme.  The Kontsevich
space is instead naturally a Deligne--Mumford stack: a `K`-point of its
coarse space records only a field of moduli unless the corresponding
residual gerbe is neutral.  A smooth embedded curve has no nontrivial
automorphism as a stable map, so this caveat disappears on that locus.

There is one precise conditional use of the count eight.  Suppose the
special three-point twisted-cubic incidence is represented by a finite
`K`-scheme `Z` of length eight in the **Hilbert** locus and all its geometric
points split over the cyclic cubic resolvent.  Galois orbits then have sizes
one or three (with equal local lengths along each orbit).  Since
`8` is not divisible by `3`, `Z` has a `K`-rational support point.  Theorem B
then gives `X(K)`.  Reducedness is unnecessary for this length argument.

None of the italicized hypotheses is presently proved for the special
secant-resolvent triple: the Gromov--Witten number `8` is known on the general
enumerative locus, but specialization may introduce boundary maps, excess
components, and virtual multiplicities, and the arithmetic splitting field
of the incidence fibre is not controlled by the cubic resolvent.  In the
`S3` resolvent branch even an honest reduced eight-set can be fixed-point
free (`8=2+6`).  Thus the current virtual/incidence data do not supply an
actual object to which Theorem A or B applies.

```text
Q_SCHUR_FIXED_CURVE_BRIDGE_EXACT
```
