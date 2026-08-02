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

The child packet `a5_valuation_elimination/` consumes the later exact
degree-eleven landing maps for both genuine maximal-`A5` twists.  Each map
has the honest irreducible projective plane as source.  Twisting by an
arbitrary `A5` torsor leaves that source a split `P2`; its nonempty rational-map
domain has a rational point over every extension of `C`.  Hence every twist
by either embedded `A5` has a point.  At an unramified valuation with either
`A5` decomposition class, the residue point lifts smoothly by Hensel's
lemma.

Thus the current exact local narrowing is

```text
I = 1
trdeg_C k(v) >= 2
rational_rank(v) <= 3
D in {G, 11:5}.
```

This is still an obstruction interface, not a local nonpoint: neither of the
two surviving residue cubics is proved pointless.

Applying the same `A5` theorem to the degree-11 intermediate field of the
full generic torsor gives an additional global consequence.  The full Schur
twist has an effective zero-cycle of degree 11, so the index-one identity can
be written `4*3-11=1`.  The six explicit transferred cycles and their secant
incidence are replayed in `a5_degree11_cycle_next/`,
`degree11_secant_descent_agent/`, and `incidence_splitting/`.  They do not
decide whether the prime-degree point descends.

## Complete `11:5` degree-one-through-nine theorem

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
Consequently the full covariant dimensions in degrees one through nine are

```text
d                 1  2  3  4   5   6   7   8   9
dim M(d,k)         1  1  3  7  11  19  30  45  65
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

The next four degrees are closed by exact support arguments over the same
good split fibre:

| degree | variables | equations | exhaustive conclusion |
|---:|---:|---:|---|
| 6 | 19 | 640 | all `2^19-1=524287` nonzero supports have a singleton equation |
| 7 | 30 | 1125 | deletion leaves exactly 32 no-singleton supports; all five characters are killed by 160 explicit incompatible binomial pairs |
| 8 | 45 | 1845 | two independent deletion orders visit 746332 and 142634 supports and find no stopping support |
| 9 | 65 | 2860 | exhaustive reverse deletion visits 26912397 unique supports and finds no stopping support |

For a fixed coefficient support, a landing equation with exactly one active
coefficient monomial cannot vanish on its coefficient torus.  Deleting each
variable of that monomial exhausts every possible solution support.  The
degree-seven residual binomials impose the same Laurent coefficient monomial
equal to two unequal constants.  The degree-nine generator reconstructs all
697125 coefficient monomials and all five character supports; its 11165448-byte
instance has SHA-256 `6d76ef...be03` and is regenerated rather than checked in.
The self-contained certificates and independent replays are in
`f55_degree6_degree7/`, `f55_degree8/`, and `f55_degree9/`.
Their special-fibre emptiness transfers to characteristic zero by the same
proper-projective specialization argument.

## Exact cyclic-trace ansatz exclusions

For the same `11:5` survivor, the source-bound Fourier/Kummer presentation
rewrites the genuine subgroup twist as

\[
 \Phi(a)=\operatorname{Tr}_{E/K}(r_2^{-1}a^2\sigma(a)),
 \qquad K=\mathbf C(U_1,U_2,U_3,U_4),\quad E=K(\alpha),\quad
 \alpha^5=U_1.
\]

Four infinite ansatz families and two complete constant five-coordinate
families are now excluded exactly, the first three-coordinate frontier is
determined geometrically, and one of its Jacobians is extracted.

1. `h_trace_two_laurent/` enumerates all 203 partitions of the six terms in
   the expansion for `a=m+t*n`, all 7125 cyclic-shift lattice systems, and
   their full rational nullspaces.  For arbitrary Laurent exponents and
   coefficients in `C`, the only nine hits have `m=n` and `t=-1`, hence
   `a=0`.  This is all-exponent, but it does not allow nonconstant `K`
   coefficients.
2. `h_trace_fourier_pair_k/` allows the coefficient ratio to be an arbitrary
   element of the full field `K`.  For each `0<=p<q<=4`, it proves
   `Phi(R2*(alpha^p+t*alpha^q)) != 0` for every `t in K`.  The verifier
   reconstructs all ten coefficient cubics.  A primitive monomial valuation
   makes each lower Newton polygon one segment of length three and slope with
   denominator three, while every element of `K*` has integral value.
3. `h_trace_three_kummer_planes/` reconstructs the restriction to every
   `0<=p<q<r<=4`.  Each of the ten ternary cubics has ten exact coefficients,
   each with seven `U`-monomials.  Exact gradient-chart unit-ideal
   certificates at `(U1,U2,U3,U4)=(2,3,5,7)` prove that their discriminants
   are nonzero, so all ten generic curves are geometrically smooth, integral
   genus-one curves.  The full-`K` pair theorem excludes points with exactly
   two nonzero coordinates, and the nonzero diagonal coefficients exclude
   the vertices.  Hence the coordinate boundaries have no `K`-points, but no
   interior point or torsor class is computed.
4. `h_trace_three_kummer_laurent/` treats all ten planes at arbitrary exponent
   size.  For nonzero `c_p,c_q,c_r in C` and arbitrary exponent vectors in
   `Z^4`, it excludes a point whose three coordinates are
   `(c_p U^m_p,c_q U^m_q,c_r U^m_r)`.  The verifier exhausts 673010 integral
   exponent candidates and every parallel collision family.  This does not
   allow any coordinate to be a sum of Laurent monomials.
5. `h_trace_four_kummer_laurent/` treats all five four-coordinate
   hyperplanes.  Reducing the 140 labelled contributions modulo three leaves
   one of `3^12` exponent residues for each hyperplane.  Exact collision-rank
   exhaustion then checks 177365 integral rank-three exponent triples, 37770
   rank-two restrictions, and 605 rank-one restrictions, with no viable
   support.  Hence no four-coordinate point exists when each nonzero
   coordinate is one Laurent monomial with an arbitrary complex constant.
   Coordinate sums and arbitrary rational-function coefficients are not
   covered.
6. `h_trace_plane_012_jacobian/` computes the exact Fisher-normalized
   invariants of `C_012`: `c4` has 14 grouped terms, `c6` has 40, and
   `J_012` is `y^2=x^3-27*c4*x-54*c6`.  It computes neither the class of
   `C_012` in `H^1(K,J_012)` nor a rational point or pointlessness theorem.
7. `full_trace_tropical_obstruction_next/` treats all five coordinates at
   once but only with constant complex coefficients.  Exact projective-chart
   unit-ideal certificates at both split primes 11 and 31 exclude nonzero
   vectors in the normalized Kummer basis and independently in the direct
   `R_i` basis.  Coefficients in `K` are not covered.
8. `c012_oneparam_section_agent/` specializes
   `(U2,U3,U4)=(3,5,7)` while retaining `s=U1`.  It obtains an elliptic
   surface with `IV*` at zero, 27 finite `I1` fibres, and `I1` at infinity.
   Exact mod-11 charts exclude polynomial-coordinate representatives of
   degree at most three.  Higher-degree rational sections and the generic
   four-parameter torsor remain undecided.

These theorems rule out every two-coordinate point in the displayed Kummer
basis, every constant-coefficient two-Laurent-term point, both constant
five-coordinate families, and every three- or four-coordinate point whose
nonzero coordinates are single Laurent monomials with constant coefficients.
The ten three-coordinate sections are explicit genus-one torsors rather than
candidate singular parametrizations, and the Jacobian of `C_012` is exact,
but their `K`-points and torsor classes remain undecided.  Coordinate sums,
arbitrary rational functions, the five-coordinate Laurent-monomial case, and
the full trace cubic remain open.

### Scope

This proves a complete degree-`<=9`, all-projective-character exclusion for
`11:5`.  It neither excludes degrees at least ten nor proves the generic
`11:5` twist pointless.  The all-exponent statements above remain confined
to their stated sparse ansatzes.  Therefore they do not remove `11:5` from
the local survivor list and do not decide the genuine Schur twist.

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
