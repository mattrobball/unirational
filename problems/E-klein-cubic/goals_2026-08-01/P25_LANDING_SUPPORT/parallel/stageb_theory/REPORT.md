# Stage-B exact theory audit

## Outcome

Stage B remains **undecided**.  This directory contains no Stage-B point and no
unit, irrelevant-power, or global constant-rank certificate.

The main exact result is instead a correction to the proposed heavy route:
full degree-five surjectivity of the `10,767` linear-syzygy contractions is
mathematically impossible.  The formal source count omitted at least
`3,182,481` multiplication relations.  After those relations, the complete
degree-three polynomial syzygy space has dimension `4,386,720`, while the
degree-five six-component target has dimension `4,496,388`.  The exact deficit
is `109,668`.

This rules out a full degree-five rank certificate, a cubic-leading-term cover
of all degree-five terms, and any purported involutive/Spencer conclusion
`M_5=0`.  It does **not** rule out the much smaller decisive target: 222 exact
identities `q_i^5 e_j` in the contraction module.  A streaming verifier for
such sparse witnesses is supplied.

## 1. Exact vector-bundle and Fitting formulation

Let `V=F_89^37`, `B=F_89^6`, `U=F_89^21`, and `R=F_89^690`.  On
`P(V)=P^36`, the sealed boundary matrix is

```text
A(q) = [M1(q) | M2(q)] : B + U -> R,
```

with degrees two and one in the two blocks.  Stage A proves that `M2(q)` has
rank 21 at every geometric projective point.  Therefore

```text
Q = coker(U tensor O(-1) -> R tensor O)
```

is a vector bundle of rank 669, and Stage B is exactly the rank-drop locus of

```text
B tensor O(-2) -> Q.
```

Equivalently it is `V(I_27(A))` in `P^36`.  This is an exact elimination of
`b1,b2`, not merely a contraction over-approximation.

The expected degeneracy codimension is `669-6+1=664`, but this proves nothing
for the fixed map.  The corresponding Porteous class lives in
`A^664(P^36)=0`; a zero expected class does not exclude an excess degeneracy
locus.  Buchsbaum--Rim/Eagon--Northcott generic perfection would require grade
664.  In the 37-dimensional homogeneous coordinate ring the positive-degree
minor ideal is proper at the affine origin and cannot have that grade.  After
localizing away from the irrelevant ideal, the required grade/unit statement
is precisely the missing conclusion, so it cannot be used as a hypothesis.

There is also no K-theoretic contradiction to an everywhere injective map: its
cokernel would have rank 663 and class

```text
690[O] - 21[O(-1)] - 6[O(-2)],
```

far above the dimension of the base.

## 2. What the systematic `M2` form does and does not give

The replay reconstructs the coefficient map

```text
alpha : V tensor U -> R
```

and certifies an explicit row/tensor-coordinate permutation

```text
alpha = [I_690 | T_690x87].
```

The 87 free coordinates are exactly

```text
q0,...,q4 times b2_j,  j=0,1,2;
q0,...,q3 times b2_j,  j=3,...,20.
```

The identity minor proves surjectivity and gives a cheap projection/lift for
nullspace-free tensor formulas.  It does not give a pointwise polynomial left
inverse to `M2(q)`: the dense tail has 59,375 nonzeros, 82--87 per row and
674--689 per column.  Thus `[I|T]` is a coefficient-space systematic form, not
a direct-sum decomposition of the bundle map.

## 3. Faithful polarization over-approximation

Because 2 is invertible in `F_89`, polarize the quadratic block to obtain

```text
L(q) : (B tensor V) + U -> R,
shape 690 x (222+21) = 690 x 243,
```

with the coefficient identity

```text
L(q)(b1 tensor q, b2) = M1(q)b1 + M2(q)b2.
```

Consequently, everywhere injective `L(q)` would prove Stage B empty.  A kernel
of `L(q)` would be only an over-approximation survivor until its first 222
coordinates were checked to equal `b1 tensor q` with the same `q`.

`result.json` stores a nonzero `243 x 243` minor at each of the 37 coordinate
points.  The replay also found rank 243 at 64 deterministically generated
prime-field points.  The former is exact bounded geometry and the latter is
sampling; neither controls all geometric points of `P^36`.

This linearization is not computationally smaller at the global-module level.
For the dual linear Macaulay map, degree 20 is the first dimensionally possible
surjectivity degree:

```text
source 690*dim S_19 = 193,597,627,818,845,250,
target 243*dim S_20 = 190,904,095,605,713,490.
```

## 4. `1`-genericity is unavailable

The polarized matrix cannot be `1`-generic.  Fix any nonzero column vector
`y`.  The map

```text
R^* -> V^*,  lambda |-> (q |-> lambda(L(q)y))
```

has a 690-dimensional source and a 37-dimensional target, hence a nonzero
kernel.  Such a pair `(lambda,y)` is a generalized zero.

The replay makes this obstruction concrete for `y=e_(b1=0,q-slot=0)`: its
coefficient matrix has rank 37, and `result.json` stores a verified row-dual
kernel vector with 38 nonzero entries.  Thus a determinantal-height theorem
whose hypothesis is `1`-genericity is not applicable.  This failure does not
imply that `L(q)` loses pointwise column rank.

The original `[M1|M2]` is mixed quadratic/linear, so linear-matrix
`1`-genericity theorems do not apply to it either.

## 5. Full-syzygy degree-five correction

Write

```text
mu_r : S_r^690 -> S_(r+1)^21,  C |-> C M2.
```

The sealed linear-syzygy matrix has full target rank

```text
rank(mu_1) = 21*dim S_2 = 14,763.
```

Since `S_(r+1)=S_(r-1) S_2`, multiplication propagates surjectivity to every
`mu_r`, `r>=1`.  Hence

```text
dim ker(mu_3)
 = 690*9,139 - 21*91,390
 = 4,386,720.
```

Every degree-five contraction of a quadratic multiple of a linear syzygy is
the contraction by some element of `ker(mu_3)`.  Therefore its image in
`S_5^6` has rank at most `4,386,720`, less than

```text
dim S_5^6 = 6*749,398 = 4,496,388.
```

The earlier source count

```text
10,767*703 = 7,569,201
```

ignored at least

```text
7,569,201 - 4,386,720 = 3,182,481
```

relations produced by commuting polynomial multiplication and any higher
syzygies.  A full degree-five rank run must therefore not be launched.

The systematic-kernel exact sequence

```text
0 -> L_1
  -> wedge^2(V^*) tensor U^*
  -> V^* tensor K^*
  -> 0
```

has dimensions

```text
0 -> 10,767 -> 13,986 -> 3,219 -> 0.
```

It removes the 2-GiB explicit nullspace, but after multiplication by `S_2` its
mapping cone still has the same `109,668` degree-five deficit.  It is a useful
operator formulation, not a surjectivity certificate.

## 6. Compact decisive target and verifier

For every `i=0,...,36` and `j=0,...,5`, an identity

```text
C_ij(q) M2(q) = 0,
C_ij(q) M1(q) = q_i^5 e_j,
C_ij in S_3^690,
```

would be decisive.  On the chart `q_i != 0`, the six contracted Stage-B
equations force `b1=0`.  All 37 charts would therefore be empty.

Each identity is one membership problem for

```text
Theta_6 : S_3^690 -> S_5^6 + S_4^21,
source dimension 6,305,910,
target dimension 6,415,578,
RHS (q_i^5 e_j,0).
```

`verify_pure_power_witnesses.py` accepts a sparse degree-three row multiplier,
streams it through the sealed blocks without building `Theta_6`, and checks all
coefficients.  With `--require-complete` it accepts only the complete 222-target
cover.  A successful replay would be a genuine Stage-B emptiness certificate.

No such witnesses were found here.  A timeout, failed search, or absent sparse
witness says nothing about membership.  A negative membership result would
require an exact dual cokernel functional nonzero on the requested RHS.

The monomial-order implications and the exact failure of a full degree-five
initial-module cover are detailed in `REPORT_COMPACT.md`.

## Replay

From the goal-run directory:

```text
/opt/homebrew/bin/python3 -u \
  P25_LANDING_SUPPORT/parallel/stageb_theory/verify_stageb_theory.py
```

It rebuilds the systematic flattening, the polarization tensor, all coordinate
minors, the generalized zero, and every dimension assertion.  It ends:

```text
PASS_EXACT_THEORY_NONVERDICT
coordinate polarized ranks: 37 copies of 243
deterministic sampled ranks: 64 copies of 243 (sampling only)
```

Artifact hashes from this run are:

```text
result.json                         d996b17b3416d286a1f7d45f6466627bfa7b9298f9b51c1bd9129f10b50a35c8
verify_stageb_theory.py             21f68cd6a0d3479cf825fa4885f597a8481904808c3e18e7e904684584c533f6
verify_pure_power_witnesses.py      49a085b19fda9fc55da76fe188fce968d7720478d2dd25edb323894ec4fd98dc
```

## Theorem boundary

Proved exactly:

- the systematic `690+87` coefficient decomposition;
- the faithful polarization identity and its safe implication;
- full polarized rank at all coordinate points;
- failure of the `1`-genericity hypothesis by an explicit generalized zero;
- the exact `109,668` obstruction to full degree-five surjectivity; and
- correctness of the 222-witness certificate criterion and streaming replay.

Not proved:

- global injectivity of the polarized matrix;
- any one of the 222 pure-power memberships;
- irrelevant-power containment, Stage-B emptiness, or a genuine Stage-B point;
- Stage C, degree-25 emptiness, or the Problem E headline.

The result is therefore an exact theory and algorithm audit with status
`STAGE_B_UNDECIDED`.
