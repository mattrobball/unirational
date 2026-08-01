# Compact full-syzygy degree-five audit

## Exact correction

The previously proposed full degree-five contraction rank cannot be full.
This is an unconditional dimension obstruction, not a resource estimate.

Let

```text
S = F_89[q0,...,q36],
mu_r : S_r^690 -> S_(r+1)^21,    C |-> C M2.
```

The sealed degree-one computation proves that `mu_1` is onto: its rank is

```text
21*dim S_2 = 21*703 = 14,763.
```

Multiplying degree-two preimages by `S_(r-1)` proves that `mu_r` is onto for
every `r>=1`.  Therefore the complete space of degree-three polynomial left
syzygies has dimension

```text
dim ker(mu_3)
  = 690*dim S_3 - 21*dim S_4
  = 690*9,139 - 21*91,390
  = 6,305,910 - 1,919,190
  = 4,386,720.
```

Contraction with the quadratic `M1` block maps this space to

```text
S_5^6,  dimension 6*749,398 = 4,496,388.
```

Thus its image has codimension at least

```text
4,496,388 - 4,386,720 = 109,668.
```

In particular:

- the map from `10,767*703 = 7,569,201` formal products of linear syzygies
  has at least `3,182,481` multiplication relations before contraction;
- full degree-five surjectivity is impossible;
- no fixed monomial/module term order can give cubic leading terms whose
  degree-two multiples cover every degree-five module monomial; and
- an involutive, Janet, Pommaret, or Spencer calculation cannot validly end in
  `M_5=0` for this module.

The count `10,767*703 > 4,496,388` by itself was therefore not a valid
dimension preflight.

## A smaller decisive certificate remains possible

Full degree-five surjectivity is stronger than needed.  For each

```text
0 <= i < 37,  0 <= j < 6,
```

it is enough to exhibit a degree-three row vector `C_ij(q) in S_3^690` with

```text
C_ij(q) M2(q) = 0,
C_ij(q) M1(q) = q_i^5 e_j.
```

Indeed, at a projective point choose `i` with `q_i != 0`.  Multiplying a
Stage-B equation by the six `C_ij` forces every coordinate of `b1` to vanish,
contrary to the Stage-B condition `b1 != 0`.  Hence these 222 identities would
prove Stage B empty.  They may all lie in the proper degree-five image; the
`109,668` deficit does not decide their membership.

Equivalently, each target is one exact membership problem for the mixed
Macaulay map

```text
Theta_6 : S_3^690 -> S_5^6 direct_sum S_4^21,
          C |-> (C M1, C M2),

source dimension = 6,305,910,
target dimension = 6,415,578,
target RHS        = (q_i^5 e_j, 0).
```

`verify_pure_power_witnesses.py` is an executable certificate replay that
never constructs this matrix.  A witness is stored as sorted sparse triples
`(relation row, degree-three monomial, coefficient)`.  The verifier streams
those triples through the sealed `M1` and `M2` tensors, accumulates only the
`6*dim S_5 + 21*dim S_4` output coefficients, and checks the two displayed
identities exactly.  With `--require-complete`, it rejects unless all 222
targets occur.

Replay syntax after witnesses exist is:

```text
/opt/homebrew/bin/python3 -u \
  P25_LANDING_SUPPORT/parallel/stageb_theory/verify_pure_power_witnesses.py \
  --require-complete witness_*.npz
```

No witnesses were found in this light theory run.  Therefore this is a
certificate format and verifier, not a Stage-B verdict.

## Monomial-order and initial-module guard

A triangular leading-term proof is valid only with one fixed multiplicative
module term order.  If cubic elements `g_a` have leading module monomials whose
degree-two cones contain every degree-five module monomial, choosing one
`h*g_a` for every target produces a triangular square minor.  The lower terms
stay lower by multiplicativity, so its determinant is the product of the
leading coefficients.

That criterion is exact, but the dimension theorem above proves that it cannot
hold here in degree five.  Using a different order for each coordinate does
not produce one triangular minor: the separate lower-term relations can form
cycles.  Likewise, pivot columns from a row reduction are useful only relative
to the single column order actually used; coordinatewise rank six does not
imply pure-power membership.

Once a complete cubic contraction matrix is available, the strictly smaller
test

```text
q_i^3 e_j in row-span(P3_full)
```

can be decided by exact augmented ranks.  All 222 positive memberships would
already prove Stage B empty with exponent three.  A rank increase proves only
failure of that particular cubic identity, not Stage-B nonemptiness and not
failure at exponent five.

## Systematic structure and search boundary

The `[I_690 | T_690x87]` coefficient flattening makes matrix-vector products
with `M2` cheap and nullspace-free: pivot contributions are monomial shifts,
and the tail is one `87 x 690` finite-field matrix multiplication followed by
87 shifts.  The `M1` part remains dense.  A single exact search still has
`6,305,910` unknown coefficients and `6,415,578` equations; forming it would
create roughly 26 billion nonzeros.  Normal equations are unsafe over
`F_89` because isotropic vectors can change rank.  Randomized Wiedemann or
preconditioned searches would be discovery tools only; any returned sparse
witness is decisive after the supplied direct replay, while failure or timeout
is a nonverdict.

No compact triangular or involutive certificate was found.  The exact next
gate is the 222 targeted mixed-Macaulay memberships, preferably by a
matrix-free solver that emits sparse witnesses or exact dual nonmembership
vectors.
