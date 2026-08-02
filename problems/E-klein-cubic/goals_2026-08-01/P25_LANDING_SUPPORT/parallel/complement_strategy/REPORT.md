# Stage-B/Stage-C complement strategy audit

## Outcome

This packet does **not** prove Stage B or Stage C empty on `D(H8)`.  It does
three exact things that materially change the remaining strategy:

1. it retires every old-r48 `H8`-complement job by explicit geometric
   contraction witnesses at `q=e12`;
2. it isolates the exact 29-chart r64 augmented-module cover which would prove
   Stage B and Stage C empty together, with a direct polynomial-identity
   certificate protocol; and
3. it proves that the proposed faithful-Segre quadratic full-span certificate
   is impossible.  At least `24,252` quadratic classes must survive, even
   though the actual projective intersection may still be empty.

The global complement therefore remains undecided in this directory.

## 1. Bound inputs and closed stratum

`audit_inputs.py` independently binds and checks:

```text
old r48 P3/P4 packet
  ba6d0533ab7fdb8bd93fb9309ce5b7d615f0a4799b22aa5e502e2dfec0bc21bb

support-balanced r64 P3/P4 packet
  c50de97aa4fc9465793f3fe84b544731b36cec1a2807113e94817c955897be2b

closed-L8 Stage-B certificate
  89ec13bb2672a8b26e5e3e5beed74dfa21bf4374c4d6d57721b0d475f5f9a41a

closed-L8 Stage-C compatibility artifact
  ad64848d98316eff00793814a5e8be09978f61c13057e4256e9a586375093957
```

It rechecks the exact closed-stratum conclusions already independently
certified by the sibling packets:

```text
L8 = P<span(q4,...,q11)>

Stage B: degree-six map rank 10296/10296,
         selected determinant 28 mod 89.

Stage C: complete P3 kernel dimension 3384,
         compatibility degree-eight rank 6435/6435.
```

Thus Stage B and normalized Stage C are both exactly empty on `L8`.

## 2. Exact retirement of old r48 on the complement

The old r48 contractions vanish identically on `L8`, but that is not their
only false locus.  At the outside coordinate point

```text
q=e12 in D(H8)
```

the exact ranks are

```text
rank P3(e12)          = 4/6
rank [P4|P3](e12)     = 4/7.
```

Two explicit witnesses over `F_89` are:

```text
Stage B:
  b1 = (54,14,19,35,1,0),
  P3(e12)b1 = 0.

Normalized Stage C:
  b1 = (74,51,64,74,0,0),
  P4(e12) + P3(e12)b1 = 0.
```

`audit_inputs.py` evaluates all 48 equations directly.  Since `q12 != 0` and
the Stage-B witness has `b1 != 0`, both irrelevant saturations retain it.
Consequently each of the following old-r48 jobs is mathematically guaranteed
to be nonunit:

```text
Stage B on D(H8)
normalized Stage C on D(H8)
combined projective [b0:b1] incidence on D(H8).
```

These are witnesses for the compressed necessary-equation system only.  They
are not points of the 690-row incidence and not landing candidates.  Their
valid conclusion is the retirement of old r48 as an emptiness proof route.

By contrast, the independently verified r64 augmented matrix has exact rank
seven at every one of the 29 outside coordinate axes, and its P3 submatrix has
rank six there.  Axis ranks are only a guard; they do not cover mixed points.

## 3. Exact finite affine cover that remains viable

Let

```text
H8=(q0,q1,q2,q3,q12,...,q36).
```

For the r64 packet form the weighted homogeneous row module

```text
N = < P4_r e0 + sum_j P3_rj e_j : r=1,...,64 >
    subset S e0 direct_sum S(-1)^6.
```

On `D(q_i)`, dehomogenize by `q_i=1`.  If the resulting 64 rows generate the
free rank-seven module over the other 36 q variables, then no nonzero
`[b0:b1]` can annihilate the selected contractions on that chart.  This
simultaneously excludes Stage B and Stage C there.  Therefore the following
29 exact chart tests, together with the closed-`L8` certificates, suffice:

```text
i = 0,1,2,3,12,13,...,36.
```

`produce_affine_augmented_module.py` generates one immutable Singular input at
a time.  The decisive check is that all seven free generators reduce to zero
modulo `std(N_i)`.  A stronger replay artifact can be produced after a unit
result:

```text
U = freemodule(7);
W = lift(N_i,U);
N_i * W = U.
```

The `64 x 7` polynomial matrix `W` is a direct Bézout/module identity.  An
independent verifier need only regenerate `N_i` from the sealed r64 packet and
multiply, without recomputing a Groebner basis.

The 29 coordinate opens are not an arbitrary over-splitting: an ideal whose
radical is the height-29 linear ideal `H8` needs at least 29 generators by the
height theorem.  Without a separately certified symmetry on the q-space, no
smaller linear principal-open cover is justified.

The local q0 input has SHA-256

```text
c9fb79809264cd5c5b0f396cce88e85310e7b4f4c036ed7d124ace497f097bcf.
```

This worker's duplicate bounded run was deliberately stopped when another
worker launched the identical test.  Its partial log reached `s(214)` and is
stored as `affine_q0_r64_augmented_module.superseded.log`, SHA-256
`c73e7cc315c1691edb7eb6928ff7ffa30d9f67daa95ae190bcb8e37cefa6206f`.
It is explicitly a nonverdict.

## 4. Faithful outer-Segre audit for Stage A plus Stage B

Set

```text
V = F_89^37,
Y = (B1 tensor V) direct_sum B2,             dim Y=243,
W = (Sym^2 V tensor B1) direct_sum (V tensor B2), dim W=4995.
```

Embed `W` in `V tensor Y`.  If a nonzero outer rank-one tensor `q tensor y`
lies in `W`, symmetry forces each `B1 tensor V` component of `y` to be a scalar
multiple of the same `q`.  Thus rank-one tensors in the 690-seed kernel

```text
K' = ker(W -> F_89^690),   dim K'=4305
```

are exactly the Stage-A/Stage-B incidence.  This faithful restriction corrects
the dimensionally impossible unrestricted `37 x 243` shortcut.

The raw quadratic counts look favorable:

```text
outer 2x2 minors             19,582,398
dim Sym^2(K'^*)               9,268,665.
```

### Exact systematic/free block

FFLAS returns a systematic kernel in which the 690 pivot W-coordinates are
exactly `0,...,689`, all in the first `B1` symmetric block.  The other 4,305
coordinates are identity free variables.  Quotienting by every outer minor
whose four cells are free is then a binomial connected-component computation.
The exact result is:

```text
all-free minors                       14,078,658
nonzero binomial edges                14,078,658
independent binomial rank              6,734,578
quadratic target                       9,268,665
free-minor quotient                    2,534,087.
```

The remaining minors are distributed by their number of pivot cells as:

```text
1 pivot cell       153,408
2 pivot cells    4,912,248
3 pivot cells       21,312
4 pivot cells      416,772.
```

The free quotient has an exact canonical decomposition.  The only special
free coordinates are W-indices `690,...,702`, the 13 monomials
`q0*q12,...,q0*q1,q0^2` in the first B1 block.  The quotient pieces are:

```text
main-main core                                              2,492,838
  Sym^4(V) tensor Sym^2(F^5)           1,370,850
  Sym^3(V) tensor F^5 tensor B2          959,595
  Sym^2(V) tensor Sym^2(B2)               162,393

special-main                                                41,158
Sym^2(special)                                                   91
total                                                     2,534,087.
```

The producer completed in about four seconds.  This is an exact quotient, but
not yet the quotient by pivot-containing minors.

### Decisive quadratic obstruction

Let `A` be the homogeneous coordinate ring of the faithful rank-one variety.
Its first two graded dimensions are

```text
A_1 = (Sym^2 V tensor B1) + (V tensor B2),
dim A_1 = 4,995,

A_2 = (Sym^4 V tensor Sym^2 B1)
    + (Sym^3 V tensor B1 tensor B2)
    + (Sym^2 V tensor Sym^2 B2),
dim A_2 = 1,919,190 + 1,151,514 + 162,393
        = 3,233,097.
```

The 690 independent seed linear forms span `L subset A_1`.  Degree two of the
linear section is the cokernel of

```text
mu : L tensor A_1 -> A_2.
```

Although the source has dimension

```text
690 * 4,995 = 3,446,550,
```

commutativity gives an injective alternating subspace

```text
Lambda^2 L -> ker(mu),
dim Lambda^2 L = C(690,2) = 237,705.
```

Therefore

```text
rank(mu) <= 3,208,845,
dim (A/(L))_2 >= 3,233,097 - 3,208,845 = 24,252.
```

Equivalently, the restricted outer minors can have rank at most

```text
9,268,665 - 24,252 = 9,244,413,
```

and the pivot-minor residual rank can be at most

```text
2,534,087 - 24,252 = 2,509,835.
```

Thus the proposed quadratic full-span certificate is rigorously impossible.
The `24,252` survivors are not a point and do not refute emptiness; they only
force any faithful-Segre proof to continue to degree at least three.

## 5. Simultaneous all-stage quadratic audit

For completeness, the exact all-stage faithful space is

```text
W3 = Sym^3(V)
   + (Sym^2(V) tensor B1)
   + (V tensor B2),
dim W3=14,134,
dim ker(690 seeds)=13,444,
Y3 dimension=946.
```

Outer rank one plus the two symmetry conditions is exactly the union of all
three stages.  Raw counts alone again mislead: there are `297,692,010` outer
minors and `90,377,290` quadrics on the kernel, but the faithful coordinate
ring has

```text
dim A_2 = 14,894,461,
690 * dim A_1 = 9,752,460.
```

Even before Koszul relations the source is short by `5,142,001`; including
`Lambda^2 L` gives the rigorous lower bound

```text
dim (A/(L))_2 >= 5,379,706.
```

No simultaneous quadratic full-span computation should be launched.

## 6. Resource floor for a higher-degree faithful-Segre continuation

It remains logically possible that the pivot-minor residual attains its
Koszul maximum rank `2,509,835`, leaving exactly `24,252` degree-two classes,
and that their degree-one prolongation vanishes in degree three.  No honest
sub-8-GiB/10-minute exact implementation was found:

```text
canonical multiplication matrix       3,233,097 x 3,446,550
raw polynomial-product terms          14,673,616,695
values alone at one byte               13.67 GiB
ordinary CSR (value + int32 index)      68.33 GiB

residual quotient columns               2,534,087
required residual rank                  2,509,835

if equality held, Q_2 dimension            24,252
A_1 times Q_2 formal products         121,138,740
ambient A_3 dimension                 767,100,243.
```

The pivot forms themselves have 4,234--4,276 nonzero free coefficients, so
the 5.50 million pivot-containing minor rows do not form a genuinely sparse
small matrix.  A matrix-free black-box discovery would not by itself provide
the required deterministic rank certificate, and scalar Wiedemann at this
dimension is outside the fence.  This line is therefore stopped at the exact
`24,252` lower bound and canonical quotient.

## Replay

From `goals_2026-08-01`:

```text
/opt/homebrew/bin/python3 -u \
  P25_LANDING_SUPPORT/parallel/complement_strategy/audit_inputs.py

/opt/homebrew/bin/python3 -u \
  P25_LANDING_SUPPORT/parallel/complement_strategy/analyze_faithful_segre.py

/opt/homebrew/bin/python3 -u \
  P25_LANDING_SUPPORT/parallel/complement_strategy/audit_free_quotient.py

/opt/homebrew/bin/python3 -u \
  P25_LANDING_SUPPORT/parallel/complement_strategy/faithful_segre_dimension_audit.py

/opt/homebrew/bin/python3 -u \
  P25_LANDING_SUPPORT/parallel/complement_strategy/verify_seal.py
```

Observed markers:

```text
PASS_EXACT_INPUT_AUDIT_NONVERDICT
PASS_FAITHFUL_SEGRE_FREE_BLOCK_NONVERDICT
PASS_CANONICAL_FREE_QUOTIENT_NONVERDICT
PASS_QUADRATIC_FULL_SPAN_REFUTED_BY_EXACT_DIMENSIONS
PASS_COMPLEMENT_STRATEGY_SEAL
```

## Theorem boundary

Proved exactly here:

- Stage B and Stage C are already empty on closed `L8`, with sibling
  independent certificates bound here;
- old r48 has explicit Stage-B and Stage-C contraction points at `e12` and
  cannot decide the complement;
- the stated r64 axis ranks and exact 29-chart augmented-module criterion;
- the faithful Stage-A/Stage-B outer-Segre equivalence;
- the systematic all-free minor rank and canonical `2,534,087` quotient;
- the unavoidable `24,252` faithful degree-two quotient lower bound;
- the unavoidable `5,379,706` all-stage degree-two quotient lower bound.

Not proved here:

- a unit r64 affine chart, let alone all 29 charts;
- maximal pivot-minor residual rank;
- vanishing of the faithful quotient in degree three;
- global Stage-B or Stage-C emptiness on `D(H8)`;
- a true point of the 690/746-row landing scheme;
- degree-25 emptiness or a characteristic-zero covariant.

The exact global theorem status remains `P25-UNDECIDED`.
