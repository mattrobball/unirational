# All-degree landing theorem

## Theorem

Let `G=PSL(2,11)` act through the Klein five-dimensional representation `W`,
let `X=V(F) subset P(W)` be the Klein cubic, and let

\[
K_{\rm proj}=k(\mathbf P(W))^G.
\]

Let `T/K_proj` be the generic `G`-torsor and let `X_T=T \times^G X`.  Let

\[
M=(\operatorname{Sym}(W^*)\otimes W)^G.
\]

Then the following sets are canonically equivalent.

1. `X_T(K_proj)`.
2. `G`-equivariant rational maps `P(W) --> X`.
3. Nonzero homogeneous landing covariants `p in M_d`, in arbitrary degree
   `d`, modulo homogeneous invariant scalar multiplication.
4. Primitive homogeneous landing covariants, in arbitrary degree, modulo
   `k^*`.
5. Rational points of the explicit normalized cubic

   \[
   V(\Phi)\subset\mathbf P^4_{K_{\rm proj}}
   \]

   obtained from the frame `(x,C,D,E,K_7)`.

Consequently

\[
\bigcup_{m,d}\mathcal L_{m,d}\ne\varnothing
\quad\Longleftrightarrow\quad
V(\Phi)(K_{\rm proj})\ne\varnothing.
\]

Equivalently, every homogeneous landing support is empty if and only if the
single generic twist has no `K_proj`-point.

## Proof

### Step 1 — torsor descent

On a free open `U subset P(W)`, the quotient map `U -> U/G` is a `G`-torsor.
The associated bundle `U \times^G X -> U/G` has generic fibre `X_T`.
Rational sections of this bundle are equivalent, by pullback and descent, to
`G`-equivariant rational maps `P(W) --> X`.  This proves `1 <-> 2`.

### Step 2 — homogeneous polynomial representatives

A rational projective map has a primitive homogeneous polynomial coordinate
tuple.  For a `G`-equivariant projective map, the tuples `p(gx)` and `g p(x)`
are primitive and represent the same map, so they differ by a constant
`chi(g)`.  The constants form a character of `G`.  The exact permutation
computation in `verify.py` proves `G=[G,G]`; hence `chi=1` and the
tuple is a genuine polynomial covariant.  Its image lies in `X` exactly when
`F(p)=0`.  This proves `2 -> 3`.  The reverse implication is immediate.

### Step 3 — primitive reduction

The coordinate gcd of a genuine covariant is a semi-invariant.  Since `G` has
no characters, it is invariant.  Dividing by it preserves polynomiality,
equivariance, and the identity `F(p)=0`.  Conversely invariant scalar
multiplication preserves landing by cubic homogeneity.  UFD uniqueness of
primitive projective tuples gives uniqueness up to `k^*`.  This proves
`3 <-> 4`.

### Step 4 — explicit frame and normalization

The five homogeneous covariants

\[
B=(x,C,D,E,K_7),\qquad e=(1,4,5,6,7)
\]

form a basis over the invariant fraction field.  The degree-one element
`tau=f3^2/f5` makes `B_j/tau^{e_j}` weight zero, and substitution produces
`Phi`.  A homogeneous landing covariant gives a `K_proj`-point by dividing by
`tau^d` and reading its frame coefficients.  A `K_proj`-point gives a
homogeneous polynomial landing covariant after clearing homogeneous invariant
denominators.  Every cleared frame summand has the same degree and
`F(p)=h^3 Phi(a)`.  This proves `3 <-> 5`.

### Step 5 — symbolic order

Every nonzero polynomial covariant has one true odd symbolic plus-plane order
`m`; hence it lies in exactly one stratum `L_{m,d}`.  Conversely every point of
a stratum is a landing covariant.  This proves the final equivalence.

## Primitive/scalar equivalence relation

For arbitrary homogeneous landing covariants `p` and `p'`, the precise
localization relation is

\[
p\sim p'
\quad\Longleftrightarrow\quad
\exists\,0\ne h,h'\in R\text{ homogeneous with }hp'=h'p.
\]

Under the theorem this is exactly equality of the corresponding projective
`K_proj`-point.  After primitive reduction the relation becomes multiplication
by a scalar in `k^*`.

## Transition-system consequence

The theorem does not replace the transition system by generic data.  It says
that the transition system must be evaluated on the literal global polynomial
produced by denominator clearing.  Therefore every equalizer, point kernel,
marked restriction, and irrelevant-torsion correction is retained.  The
larger inverse limit of independent local states is only a necessary target
and is not part of the bijection.
