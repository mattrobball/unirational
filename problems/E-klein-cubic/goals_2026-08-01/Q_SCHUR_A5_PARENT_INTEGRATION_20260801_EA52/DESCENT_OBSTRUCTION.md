# Descent and obstruction audit

## Global commutative-torsor no-go

Let `P/K` be a torsor under a commutative algebraic group `A/K`, and suppose
there is a `K`-morphism `X_Schur -> P`.  Every closed point of `X_Schur`
gives a point of `P` over its residue field.  The degree-three and degree-55
points therefore kill the class `[P] in H^1(K,A)` after restriction to two
extensions of those degrees.  Restriction--corestriction gives

\[
3[P]=55[P]=0.
\]

Since `55-18*3=1`, `[P]=0`.  Hence every such torsor recipient is trivial.
This retires elementary, toric, semiabelian, intermediate-Jacobian-torsor,
and other commutative recipients satisfying this functorial hypothesis.  It
does not cover genuinely noncommutative or nonlinear obstructions.

## Exact local narrowing

Let `v` be a valuation of `K=C(P(V6))^G`, trivial on `C`, and let `D,I` be
decomposition and inertia groups after prolongation to `E`.  The imported
audit proves that a henselian local nonpoint can occur only under all of

```text
I = 1
trdeg_C k(v) >= 2
rational_rank(v) <= 3
D in {G, A5_class_1, A5_class_2, 11:5}
```

Ramified sites are soluble by the inertia-centralizer fixed-space theorem;
residue transcendence degree at most one is soluble by smooth reduction and
Graber--Harris--Starr; all other proper decomposition groups are soluble by
the audited subgroup theorem.  Abhyankar's inequality supplies the rank
bound.  The machine record is
`imports/negative_obstruction_audit.json`.

That imported file is explicitly a working-tree snapshot at run start, with
SHA-256 `f9a688...`.  It is not silently represented as the pinned `35fa8f`
blob, whose SHA-256 is `5d1811...`; both values and the distinction are bound
in `SOURCE_MANIFEST.json`.

The child packet `a5_valuation_elimination/` now consumes the later exact
degree-eleven points for both genuine maximal-`A5` twists.  Each point is an
exact rational `A5`-map from the honest irreducible projective plane to the
Klein cubic.  Twisting by an arbitrary `A5` torsor leaves that source a split
`P2`; its nonempty map domain has a rational point over every extension of
`C`.  Hence every twist by either embedded `A5` has a point.  At an
unramified valuation with either `A5` decomposition class, the residue point
lifts smoothly by Hensel's lemma.

Thus the current exact local narrowing is

```text
I = 1
trdeg_C k(v) >= 2
rational_rank(v) <= 3
D in {G, 11:5}.
```

This remains an obstruction interface, not a local nonpoint: neither of the
two surviving residue cubics is proved pointless.

## New complete `11:5` degree-one-through-eight theorem

The maximal Frobenius subgroup `H=11:5` remains one of the local survivors.
In an order-eleven eigenbasis, the irreducible five-space has weights

\[
(1,9,4,3,5)\pmod {11},
\]

an order-five generator cyclically shifts the coordinates, and the unique
invariant cubic is `sum_i x_i^2*x_(i+1)`.

Because `H_ab=C5`, a projectively equivariant homogeneous map may transform
by any of five characters.  For degree `d` and character `chi_k`, let
`M(d,k)` be the full space of polynomial maps `q:W5->W5` satisfying

```text
q(h*x) = chi_k(h) * h*q(x).
```

The first coordinate is an arbitrary degree-`d` monomial combination of
order-eleven weight one; cyclic translation determines the other four.
Consequently the full covariant dimensions in degrees one through eight are

```text
d                 1  2  3  4   5   6   7   8
dim M(d,k)         1  1  3  7  11  19  30  45
```

for every `k`.  Expanding `F(q)` gives a homogeneous cubic ideal in the
covariant coefficients.  Over the split good prime `331` (`331=1 mod 55`),
all 25 complete ideals have affine dimension zero, hence their projective
landing schemes are empty.  Their quotient vector-space dimensions are

| degree | `k=0` | `k=1,2,3,4` |
|---:|---:|---:|
| 1 | 3 | 3 |
| 2 | 3 | 3 |
| 3 | 10 | 10 |
| 4 | 96 | 96 |
| 5 | 541 | 553 |

The degree-one-through-five landing schemes are projective over the
localization of the cyclotomic integer ring at this good split prime.  A
characteristic-zero point would
have a proper closure meeting the special fibre.  Since the special fibres
are empty, the characteristic-zero landing schemes are empty as well.

`f55_covariant_results.json` contains every input/output hash.  The producer
is `run_f55_covariants.py`.  The standalone `verify_f55_covariants.py`
imports no producer code: it reconstructs the group, invariant cubic, all
25 covariant spaces, and the equations over
`Z[t]/(t^4+t^3+t^2+t+1)`, specializes `t=64`, byte-compares every Singular
input, and reruns every solver transcript.

The next three degrees are closed by exact support arguments over the same
good split fibre:

| degree | variables | equations | exhaustive conclusion |
|---:|---:|---:|---|
| 6 | 19 | 640 | all `2^19-1=524287` nonzero supports have a singleton equation |
| 7 | 30 | 1125 | deletion leaves exactly 32 no-singleton supports; all five characters are killed by 160 explicit incompatible binomial pairs |
| 8 | 45 | 1845 | two independent deletion orders visit 746332 and 142634 supports and find no stopping support |

For a fixed coefficient support, a landing equation with exactly one active
coefficient monomial cannot vanish on its coefficient torus.  Deleting each
variable of that monomial exhausts every possible solution support.  The
degree-seven residual binomials impose the same Laurent coefficient monomial
equal to two unequal constants.  The self-contained certificates and
independent replays are in `f55_degree6_degree7/` and `f55_degree8/`.
Their special-fibre emptiness transfers to characteristic zero by the same
proper-projective specialization argument.

### Scope

This proves a complete degree-`<=8`, all-projective-character exclusion for
`11:5`.  It neither excludes degrees at least nine nor proves the generic
`11:5` twist pointless.  Therefore it does not remove `11:5` from the local
survivor list and does not decide the genuine Schur twist.

## Exact all-degree boundary

Under the invariant-theory input of a homogeneous system of parameters of
degrees `(3,5,6,8,11)` and freeness over it, the covariant Hilbert numerator
has 720 secondary generators, with nonzero terms through degree 26.  The
packet verifier recomputes the numerical numerator but does not reconstruct
the hsop or prove freeness.  This finite free module does not bound the degree
of a rational solution after passing to the invariant field.  More sharply,
if `e1,e2` are secondary generators of degrees one and two and `f3,f5` are
parameters of degrees three and five, then

```text
f3^(2+5k)*e1 + f5^(1+3k)*e2
```

is homogeneous of degree `7+15k` and has coprime parameter-ring
coefficients.  Thus even primitive module combinations occur in unbounded
degree; this statement does not claim that those combinations land on the
cubic.

There is also an exact 18-variable degree-seven coefficient support with no
singleton landing equation.  It is nevertheless impossible, by the literal
pair `A+B=0` and `2A+B=0`.  Multiplication by
`(x0*x1*x2*x3*x4)^k` transports its complete support pattern to every degree
`7+5k`.  Hence a universal unique-exposed-monomial proof is false, while a
new primitive all-support theorem could still settle the gate.  These facts
are reconstructed in `f55_all_degree_boundary/`.

Kaur--Reichstein, *Essential Dimension of Small Finite Groups*, section 8,
table row `GAP (55,1)`, records `C11 semidirect C5` with representation
dimension five and essential dimension only bounded between three and four:
<https://arxiv.org/abs/2407.21449>.  The known classification therefore does
not decide this five-dimensional compression problem.
