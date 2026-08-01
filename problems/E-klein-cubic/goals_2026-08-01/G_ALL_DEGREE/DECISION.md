# Decision ledger

## Current exact reduction

The all-degree union of homogeneous landing schemes is nonempty if and only
if the affine invariant-field cubic

\[
\Phi_{\rm aff}(u)=F([x\ C\ D\ E\ K_7]u)=0
\]

has a rational point over (K_{\rm aff}=k(W)^G), equivalently if the normalized
projective cubic

\[
\Phi(a)=F\!\left(\sum_j a_jB_j/\tau^{\deg B_j}\right)=0
\]

has a point over `K_proj`.

This is now an executable equation rather than only an abstract reduction:
`generic_cubic.json` gives every one of its 35 coefficients in the certified
twelve-element `K_proj` basis, and `verify_generic_cubic.py` independently
reconstructs the corresponding expanded invariant polynomials.

## Structural all-order theorem

For every true odd plane order, the first nonautomatic equation is the
quadratic-Veronese row `(a^2,ab,b^2)`.  Its full syzygy module forces the
successor into `(a,b)E_+`.  Every gcd component on which that successor is
nonzero maps to the fixed elliptic cubic, and elliptic trace forces its
degree over the plus-plane to be divisible by three.  At every `V4` triple
line, for `m=2r+1`, the first post-minimum symbolic layer satisfies

\[
(J_{2r+1})_{3r+3}=(xyz)^{r-1}(J_3)_6.
\]

The proof is in `FIRST_GATE.md`; `verify_structural.py` reconstructs the
Veronese syzygies and the monomial recurrence.  The primitive locus,
degree-divisible-by-three gcd locus, and later line layers survive, so the
theorem is structural rather than a headline-negative certificate.

## Evidence that does not decide it

The following installed results remain strictly nondecisive:

* landing schemes are empty through degree 24;
* degree 25 has only a characteristic-zero dimension bound, not emptiness;
* the linear inverse-limit module is nonzero in every fixed odd order for
  sufficiently high degree;
* the degree-13 and degree-19 terminal values are sample residuals;
* later kernel freedom cancels the sampled degree-25 residual;
* the existing order-three/order-four Fable boundary is obstructed by the
  Veronese-syzygy and elliptic-trace theorem;
* finite generation of the global covariant module supplies no rational
  height bound.

## Exact parallel-attack boundary

Seven independent attack packets were replayed after materializing the generic
cubic.

* **Constructive frame support.**  Each binary cubic `F(U+tV)` for a pair of
  frame columns is absolutely irreducible over characteristic zero, and the
  98-by-35 constant-coordinate coefficient matrix has rank 35.  A point must
  use at least three frame columns and genuinely nonconstant invariant-field
  ratios.  This is not pointlessness of the full cubic.
* **Ternary support.**  Literal coefficient binding to the sealed general-slice
  theorem proves that the `x,C,D` plane has no `K_proj,C`-point.  Exact good
  reduction also excludes 110 common-pencil `P5` and ten fixed common-plane
  `P8` constant-secondary-support ansatze.  These finite families do not
  bound rational-function height; the other nine unrestricted ternary planes
  and all four-/five-frame points remain undecided.
* **All-order local tower.**  At a generic `V4` triple line,
  `J_m=xyz*J_(m-2)+((xy)^m,(xz)^m,(yz)^m)`.  The order-three tuple is gcd-one
  only in the abstract projective-character model before character
  correction; the actual `W`-valued tuple has a common inverse-character
  line factor.  Its local state propagates to every odd order, and scalar
  point-jet factors show only that unsaturated finite-point constraints do
  not kill it.  Primitive saturation and the global nonlinear plus-plane
  overlap remain possible sources of an obstruction.
* **Standard valuation completions.**  The effective degree-55 cycle plus
  Coray's complete-DVR theorem gives actual points over the standard
  successive complete-DVR fields attached to saturated geometric Parshin
  chains of length three or four on `K_proj`.  A negative proof cannot be
  purely tropical on those retired successive completions.
* **Arbitrary-rank `C1` residues.**  For every Krull valuation of `K_proj`
  trivial on `C`, of arbitrary rank and with `C1` residue, the genuine twist
  has a point over its henselization.  Any negative site in this convention
  is unramified with non-`C1` residue and decomposition group `G`, one of the
  two maximal `A5` classes, or maximal `11:5`.  The divisorial trdeg-three and
  saturated rank-two trdeg-two residues are central remaining cases, not an
  exhaustive list of all unresolved valuations.
* **Zero-cycle containment.**  A general cubic-surface section and Voisin's
  theorem give the unconditional alternative: a point on the genuine twist,
  or a primitive quartic point with Galois closure `A4` or `S4`.  A
  degree-two/four residual split by the known connected `PSL(2,11)`
  extension would force a ground-field point, but ground-field definition
  does not imply that splitting.  Balestrieri's degree bound permits the
  nondecreasing sequence `55,107,211,419,...`, so its theorem alone does not
  reach degree two.
* **Primitive quartic.**  If `N/K` is the `A4/S4` closure of the primitive
  quartic and `E/K` is the generic `PSL_2(F_11)` extension, then
  `E cap N=K`; the quartic is forced to stay primitive over `E`.  Pairing its
  four conjugates gives a canonical point over the degree-three cubic
  resolvent, but no ground-field descent.  The surviving full-span quartic
  locus is four explicit remainder equations on five charts, and a smooth
  `S4` countermodel excludes a universal smoothness shortcut.

The exact proofs and independent replays are under `attacks/`; none supplies
the missing rational point or pointlessness certificate.

## Remaining binary decision

Positive: find either (0\ne u\in K_{\rm aff}^5) with
(\Phi_{\rm aff}(u)=0) or equivalently (0\ne a\in K_{\rm proj}^5) with
(\Phi(a)=0), clear its coordinates, and verify the resulting homogeneous
global covariant in the original Klein equation and group generators.

Negative: prove (V(\Phi)(K_{\rm proj})=\varnothing).  By the all-degree
equivalence this is exactly emptiness of every homogeneous landing support;
the accepted source-exhaustiveness bridge must then be replayed separately.

No weaker local, bounded, formal, or modular statement changes the headline.
The correct packet exit is `G-STRUCTURAL-UNDECIDED`: a valid all-degree
reduction and recurrence have been proved, while the displayed binary
rational-point statement remains undecided.
