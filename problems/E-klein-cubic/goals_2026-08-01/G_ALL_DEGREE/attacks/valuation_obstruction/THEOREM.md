# Complete-DVR and Parshin-chain theorem

## 1. Coray's theorem with exact hypotheses

For a field `k`, let `(CS)_k` mean:

> for every cubic form over `k`, if it has a nontrivial zero over a finite
> extension of degree prime to three, then it has a nontrivial zero over
> `k`.

Daniel F. Coray calls a field `K` **quasi-local** when:

1. `K` is complete for a discrete valuation; and
2. its residue field `kappa` satisfies `(CS)_kappa`.

His Theorem 4.7 proves that `(CS)_K` holds for every quasi-local `K`.
Equivalently, if `F` is a cubic form over `K` and `L/K` is a finite
extension of degree prime to three, then `F` represents zero over `K` if and
only if it represents zero over `L`.

Primary citation:

- D. F. Coray, *Algebraic points on cubic hypersurfaces*, Acta Arithmetica
  **30** (1976), 267--296, Section 4 ("Quasi-local fields"), Theorem 4.7,
  printed pages 281--282, DOI
  <https://doi.org/10.4064/aa-30-3-267-296>.
- Archival full text:
  <http://matwbn.icm.edu.pl/ksiazki/aa/aa30/aa3037.pdf>.

The theorem assumes completeness, not merely henselianity.  It is stated for
cubic forms and does not require the corresponding hypersurface to be
smooth.

## 2. Base fields of transcendence at most one

Let `kappa` be a finite extension of either `C` or a one-variable function
field over `C`.  Then `(CS)_kappa` holds in every number of variables.

- In at least four variables, `kappa` is `C_1`, so every cubic form already
  has a nontrivial `kappa`-zero.
- In three variables, `(CS)` for arbitrary plane cubics is Coray's
  Proposition 2.3.  For a smooth integral cubic it is the degree-one divisor
  plus Riemann--Roch argument; Coray's proposition also covers the singular,
  reducible, and nonreduced cases.  We use the full proposition, not a
  smoothness assumption.
- In two variables, a binary cubic with a closed point of degree one or two
  has a linear factor: a quadratic factor leaves a linear factor because the
  total degree is three.
- The one-variable case is immediate.

Thus Coray's theorem can be iterated through any finite tower

```text
kappa = K_0,
K_1 complete DVR with residue K_0,
...
K_r complete DVR with residue K_(r-1).
```

Every `K_i` satisfies `(CS)`.

## 3. Effective degree-55 cycle on the genuine twist

Let `G=PSL_2(F_11)` and let `X` be the Klein cubic.  The exact cyclotomic
group calculation reconstructs a subgroup `H=D12` of order 12 and the
unique honest two-dimensional `H`-subrepresentation whose projective line
is contained in `X`.  Its full stabilizer is `H`, so the orbit has size

```text
[G:H] = 660 / 12 = 55.
```

For every `G`-torsor `T/K`, let `B=T/H`, a finite etale `K`-scheme of degree
55.  Over `B`, the torsor reduces to `H`.  Twisting the honest
two-dimensional `H`-module gives a rank-two vector bundle `U_T` on `B`, and
the contained line twists to `P(U_T) subset (^T X)_B`.  On each field
component of the zero-dimensional scheme `B`, `U_T` is a two-dimensional
vector space, so `P(U_T)` has a point.  Pushing those componentwise points
from `B` to `K` gives an effective zero-cycle of total degree 55.  Flat
scalar extension preserves its total degree.

Let `E/K` be any extension.  Decompose the base-changed effective cycle into
closed points:

```text
55 = sum_i m_i [E_i:E].
```

At least one `[E_i:E]` is prime to three.  Therefore `^T X_E` has a point
over a finite extension of `E` of degree prime to three.

This argument uses effectivity.  It is stronger than merely observing the
signed identity `55-18*3=1`, and it never infers a point from index one
alone.

## 4. Application to the exact generic cubic

The exact `K_proj` arithmetic presents

```text
P0 = C(t3,t6,t8,t11),
[K_proj:P0] = 12,
trdeg_C(K_proj) = 4.
```

The 35 coefficients in `generic_cubic.json` give the genuine twist

```text
Y : Phi(a0,...,a4)=0 in P4_(K_proj).
```

Let `w` be a saturated geometric Parshin chain on `K_proj`, and form the
standard **successive iterated complete-DVR field** `K_w^comp` attached to
the chain.  Assume the terminal residue field has
transcendence degree at most one over `C`.  Applying Section 2 upward through
the complete-DVR tower shows `(CS)_(K_w^comp)`.  Section 3 gives a finite
prime-to-three extension over which `Y` has a point.  Hence

```text
Y(K_w^comp) is nonempty.
```

For a saturated geometric length-`r` Parshin chain on a four-dimensional
function field, the terminal residue has transcendence degree `4-r`.  Thus
the hypothesis holds for `r=3,4`.  This statement concerns the successive
complete-DVR construction, not an unspecified completion of an arbitrary
rank-`r` valuation.

This proves actual local solubility for all covered completions.  It does not
give a `K_proj`-point, a point over a henselization, or a local-global
principle.

## 5. Sharp boundary

The proof does not cover:

- rank-one divisorial valuations, whose residue fields have transcendence
  degree three;
- rank-two Parshin chains, whose terminal residue fields have transcendence
  degree two;
- arbitrary nongeometric valuations not presented by the stated complete-DVR
  tower.

At those sites `(CS)` for the terminal residue cubic is not supplied by
Tsen--Lang or by the installed arithmetic.  They remain legitimate but
exceptionally difficult negative candidates.
