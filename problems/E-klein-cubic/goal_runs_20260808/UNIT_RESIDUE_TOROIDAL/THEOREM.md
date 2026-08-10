# The unit/free-prime distinction disappears at one toroidal completion

**Date:** 2026-08-08  
**Scope:** completed free divisor orbits, toroidal boundary data, and
coefficient-only higher tame symbols  
**Verdict:** these data do not distinguish `r_2^-1` from the explicit
soluble coefficient; the global trace question remains open

## 1. Setup and the projective local coefficient class

Let

\[
 M=\mathbf Z^5/\mathbf Z(1,1,1,1,1),\qquad
 N=\operatorname {Hom}(M,\mathbf Z)
   =\{(n_i)\in\mathbf Z^5:\sum n_i=0\},
\]

\[
 E=\mathbf C(M),\qquad \sigma(r_i)=r_{i+1},\qquad K=E^\sigma,
 \qquad c=r_2^{-1}.
\]

Put `psi(a)=a^2 sigma(a)`.  At a free orbit of divisorial valuations,
choose the first component and write the five transported germs of a
coefficient `x` as

\[
 x_i=\sigma^{-i}(x),\qquad 0\leq i<5.                 \tag{1.1}
\]

Changing the trace equation by `x -> k*x*psi(a)`, with `k in K*`, does
not change whether it has a zero.  In multiplicative tuple notation this
quotients `(L^*)^5` by the image of

\[
 C=2I+P_-,\qquad (Cu)_i=2u_i+u_{i-1},                 \tag{1.2}
\]

and by the diagonal copy of `L*`.  The augmented integer matrix
`[C | 1]` has Smith form

\[
 \operatorname {diag}(1,1,1,1,11).                   \tag{1.3}
\]

Consequently, for every field `L`, the projective local coefficient
quotient is canonically a copy of

\[
 L^*/L^{*11}.                                         \tag{1.4}
\]

One explicit coordinate on (1.4) is the resolvent

\[
 \rho(x)=\prod_{i=0}^4\sigma^{-i}(x)^{\lambda_i},
 \qquad \lambda=(1,9,4,3,5).                          \tag{1.5}
\]

Indeed,

\[
 \lambda C=(11,22,11,11,11),\qquad
 \sum_i\lambda_i=22,                                  \tag{1.6}
\]

so both `psi(a)` and an invariant scalar change `rho` by an eleventh
power.  Surjectivity follows already from the tuple `(z,1,1,1,1)`, whose
resolvent is `z`; (1.3) then proves that (1.5) detects the full quotient.

Thus any local invariant which survives both allowed changes factors
through the single Kummer class `[rho(x)]`.

## 2. The actual unit class realizes the free-prime vector at infinity

For a primitive cocharacter `n in N`, let `D_n` denote the corresponding
toric divisorial valuation.  Every finite `C5`-orbit of primitive rays can
be inserted into a complete projective `C5`-invariant fan and retained under
an equivariant regular refinement.  Hence `D_n` and its orbit occur as
boundary divisors on a smooth projective equivariant toric model.

If `D_i=sigma^i(D_n)`, then

\[
 v_{D_i}(c)=-n_{2-i}.                                  \tag{2.1}
\]

This gives a useful general relocation lemma.

### Proposition 2.1 (toroidal relocation)

For every primitive vector `w=(w_i) in Z^5` with `sum w_i=0`, put

\[
 n_j=-w_{2-j}.                                         \tag{2.2}
\]

Then `n in N` is primitive, and on a smooth projective equivariant toric
model the unit coefficient `c=r_2^-1` has

\[
 (v_{D_0}(c),\ldots,v_{D_4}(c))=w.                     \tag{2.3}
\]

In particular, for the soluble coefficient of
`SEMILINEAR_RANK3_DESCENT`,

\[
 w_*=(-2,-1,1,1,1),\qquad
 n_*=(-1,1,2,-1,-1).                                   \tag{2.4}
\]

The ray orbit of `n_*` is free, and

\[
 \lambda\mathbin\cdot w_*=1                           \tag{2.5}
\]

as an integer, not merely modulo eleven.  Therefore, at `D_{n_*}`,

\[
 v_{D_{n_*}}(\rho(c))
 =\sum_i\lambda_i v_{D_i}(c)=1.                        \tag{2.6}
\]

So `rho(c)` is a uniformizer in the completed DVR at this toroidal
boundary divisor.

The proposition is stronger than the observation that a blowup can create
new ramification: every primitive sum-zero free-orbit pattern can be
realized by the fixed Laurent unit `r_2^-1`.  Thus the words "unit residue"
and "free-prime residue" refer to the selected affine torus, not to a
birationally local type of divisorial valuation.

## 3. The soluble coefficient has the identical completed class

Let

\[
 d_i=r_i-r_{i+1},\qquad n=\prod_i d_i,
 \qquad c_d={n\over d_0^3d_1^2}.                        \tag{3.1}
\]

Along the ordered prime orbit `(d_0,...,d_4)`,

\[
 (v_{d_i}(c_d))_i=w_*=(-2,-1,1,1,1).                  \tag{3.2}
\]

Using (1.1), at the first prime `d_0=0` one gets

\[
 v_{d_0}(\rho(c_d))=\sum_i\lambda_iw_{*,i}=1.          \tag{3.3}
\]

Hence `rho(c_d)` is also a uniformizer.  The two residue fields are

\[
 \kappa(D_{n_*})\simeq\mathbf C(u_1,u_2,u_3),\qquad
 \kappa(d_0) =\mathbf C(r_1,r_2,r_3),                  \tag{3.4}
\]

both purely transcendental of degree three.  Equal-characteristic Cohen
structure, here visible directly in toric and smooth-divisor coordinates,
therefore gives an isomorphism of complete DVR pairs

\[
 (\widehat E_{D_{n_*}},\rho(c))
 \simeq
 (\widehat E_{d_0},\rho(c_d)),                          \tag{3.5}
\]

chosen to send one displayed uniformizer to the other.  Both divisor orbits
are free.  Transporting (3.5) around the five components makes it an
isomorphism of the split semilocal `C5`-fields.  By (1.3)--(1.5), it carries
the projective local `psi`-class of `c` to that of `c_d`.

This proves the main counterconfiguration.

### Theorem 3.1 (completed local equivalence)

The actual coefficient `r_2^-1` at the toroidal orbit generated by
`n_*=(-1,1,2,-1,-1)` and the soluble coefficient `c_d` at the interior
orbit `(d_i)` define isomorphic completed semilocal projective coefficient
classes.  In particular, no invariant of one completed free divisor orbit
which is unchanged under invariant scaling and multiplication by
`psi(E*)` can distinguish them.

The second coefficient genuinely meets trace zero:

\[
 c_d\,\psi(d_0^2)=n d_0,\qquad
 \operatorname {Tr}(n d_0)=n\sum_i d_i=0.              \tag{3.6}
\]

Therefore the completed local class shared by the actual coefficient is
compatible with the additive trace-zero intersection.  This includes every
depth of local specialization inside the residue divisor, not just its first
valuation.

### Corollary 3.2 (the matching toroidal degeneration is soluble)

Let `q_*` be the divisorial place of `K` below the free orbit generated by
`D_{n_*}`.  The actual trace cubic has a point over `K_(q_*)` with all five
split coordinates nonzero.

Indeed, (3.6) gives such a point after completing at the orbit `(d_i)`.
The isomorphism (3.5), transported around the free orbit, preserves the
cyclic shift and hence the split trace map.  Equality of the projective local
classes means that the two coefficients differ by `k*psi(u)`; replacing the
point by `u` times that point and scaling the equation by `k` transfers it to
the actual coefficient.  Thus this explicit toroidal specialization cannot
be a bad place for the actual twist.

## 4. Why higher tame symbols do not repair the local method

There are two precise statements.

First, the coefficient class itself is a degree-one Kummer class.  Its only
canonical `psi`-invariant orbit combination is `[rho(c)]` by (1.3).  An
iterated Gersten boundary starting in degree one stops after the first step:

\[
 H^1(L,\mu_{11})\longrightarrow H^0(\kappa,\mathbf Z/11),
 \qquad H^{-1}=0.                                       \tag{4.1}
\]

Equivalently in Milnor K-theory, `K_1/11` has a divisorial valuation but no
second tame symbol.  Alternating cup expressions made only from the five
orbit Kummer classes also add nothing: the projective orbit quotient is
one-dimensional over `F_11`, so its exterior powers in degree at least two
vanish.  The Kummer Bockstein vanishes as well because the ground field
contains `mu_121`.

Second, one can create higher symbols by adjoining auxiliary rational
functions, but their full local data already agree under (3.5).  Concretely,

\[
 \{\rho(c_d),r_1,r_2,r_3\}\in K_4^M(E)/11             \tag{4.2}
\]

has iterated residue `1` along the Parshin chain

\[
 d_0=0,\quad r_1=0,\quad r_2=0,\quad r_3=0.             \tag{4.3}
\]

The first residue is `1` by (3.3), and the last three are the standard
coordinate residues in `C(r_1,r_2,r_3)`.  On the toric side, extend the
primitive ray `n_*` to a lattice flag and use a basis of
`M cap n_*^perp`; then

\[
 \{\rho(c),\chi^{m_1},\chi^{m_2},\chi^{m_3}\}          \tag{4.4}
\]

has the same iterated residue `1`.  This is not merely equality of a
nonvanishing test: (3.5) identifies all such completed flag symbols.

Thus higher or mixed tame symbols at one orbit cannot promote the original
unit/free-prime observation to a pointlessness theorem.

## 5. Every finite set of split local classes can be matched at once

The preceding counterconfiguration can be strengthened from one orbit to an
arbitrary finite collection.  This uses no search.

### Proposition 5.1 (local evaluation is onto)

Let `L` be any field containing `C`.  On the split trace hyperplane

\[
 U(L)=\{(b_0,\ldots,b_4)\in(L^*)^5:\sum_i b_i=0\}/L^*,
\]

the resolvent map

\[
 U(L)\longrightarrow L^*/L^{*11},\qquad
 (b_i)\longmapsto\prod_i b_i^{\lambda_i}               \tag{5.1}
\]

is surjective.

Choose a primitive cube root `omega in C`.  For a target `z in L*`, put

\[
 x=z^{10},\qquad
 (b_0,b_1,b_2,b_3,b_4)=(x,-x,1,\omega,\omega^2).       \tag{5.2}
\]

All entries are nonzero and their sum is zero.  Moreover

\[
 \prod_i b_i^{\lambda_i}
 =x(-x)^9\,1^4\omega^3(\omega^2)^5
 =-\omega x^{10}
 =-\omega z^{100}
 \equiv z\pmod {L^{*11}},                              \tag{5.3}
\]

because `100=1+9*11` and every constant in `C*` is an eleventh
power.  This proves surjectivity.

The formula also explains why no compatibility is lost by imposing trace
zero: two coordinates cancel additively, while the sum of their resolvent
weights is `1+9=10`, a unit modulo eleven; the other three nonzero constants
sum to zero.

### Lemma 5.2 (exact coefficient identity)

For every nonzero trace-zero `b in E`, the coefficient (5.9) below obeys

\[
 [c_b]=[b]\quad\hbox{in}\quad E^*/K^*\psi(E^*),        \tag{5.4}
\]

and, with the orientation (1.5),

\[
 [\rho(c_b)]=[\rho(b)]\quad\hbox{in}\quad E^*/E^{*11}.
                                                               \tag{5.5}
\]

Indeed, the exact identity

\[
 c_b\psi(b^2)=N(b)b                                  \tag{5.6}
\]

kills `psi(b^2)` and the invariant `N(b)` in the first quotient.  For the
second statement, apply `rho`: (1.6) makes `rho(psi(b^2))` an eleventh
power, while

\[
 \rho(N(b))=N(b)^{\sum\lambda_i}=N(b)^{22}
            =(N(b)^2)^{11}.                            \tag{5.7}
\]

This fixes both the orientation and the invariant-scalar bookkeeping.

### Theorem 5.3 (finite split-place matching)

Let `q_1,...,q_s` be finitely many inequivalent divisorial places of `K`
which split completely in `E`, and prescribe arbitrary projective local
coefficient classes

\[
\xi_j\in K_{q_j}^*/K_{q_j}^{*11}.                     \tag{5.8}
\]

There is a single nonzero `b in E` with `Tr(b)=0` such that the globally
soluble coefficient

\[
 c_b={N_{E/K}(b)\over b^3\sigma(b)^2}                  \tag{5.9}
\]

has local projective `psi`-class `xi_j` at every `q_j`.

Proof.  At a split place, identify

\[
 E\otimes_KK_{q_j}\simeq K_{q_j}^5.
\]

Proposition 5.1 supplies a nonzero local trace-zero tuple with class
`xi_j`.  The affine hyperplane

\[
 V=\ker(\operatorname {Tr}_{E/K})
\]

is a four-dimensional `K`-vector space.  Weak approximation on `V` gives
one `b in V(K)` arbitrarily close to all the chosen local tuples.  Choose
the approximation so that each component ratio lies in `1+m_{q_j}`.  In
residue characteristic zero, Hensel's lemma makes `1+m_{q_j}` uniquely
11-divisible, so the local resolvent Kummer classes are unchanged.

Lemma 5.2 gives `[c_b]=[b]` in every local quotient.  Its exact identity
also gives

\[
 \operatorname {Tr}(c_b\psi(b^2))
 =N(b)\operatorname {Tr}(b)=0,                          \tag{5.10}
\]

so `c_b` is globally, not merely locally, soluble.  QED.

### Theorem 5.4 (finite locally-soluble-place matching)

The split hypothesis in Theorem 5.3 can be replaced by the exact condition
needed for a given coefficient.  Let `v_1,...,v_s` be finitely many
inequivalent Henselian divisorial places of `K`, of residue characteristic
prime to `33`.  Put `E_v=E tensor_K K_v`.  Suppose a coefficient `c in E*`
has at each `v_j` a **dense-torus** local trace point: there is
`a_j in E_{v_j}^*` such that

\[
 \beta_j=c\psi(a_j)\in E_{v_j}^*,\qquad
 \operatorname {Tr}_{E_{v_j}/K_{v_j}}(\beta_j)=0.      \tag{5.11}
\]

Then one globally soluble coefficient `c_b` of the form (5.9) has the same
projective local `psi`-class as `c` at all the `v_j`.

To prove this, use weak approximation on `V=ker(Tr)` to choose global
`b in V(K)` close to every `beta_j`.  The isogeny `psi` is etale on the
unit neighborhood: its tangent operator is `2+sigma`, whose determinant on
`R_(E_v/K_v)G_m` is `33`, a unit under the stated residue-characteristic
hypothesis.  Hensel's lemma therefore gives an open neighborhood

\[
 1+\mathfrak m_{E_v}^{\,N_v}\subseteq\psi(E_v^*)       \tag{5.12}
\]

for some `N_v >= 1`.  Arrange
`b/beta_j` to lie there.  Then

\[
 [b]=[\beta_j]=[c]\quad\hbox{locally},                 \tag{5.13}
\]

and Lemma 5.2 gives `[c_b]=[b]`.  Global solubility again follows from
(5.10).

The dense-torus condition is essential to this formulation.  A projective
local point with zero split coordinates does not provide an invertible
`beta_j`, and the theorem makes no assertion at a place where the actual
coefficient has no local point.  At every split place, Proposition 5.1
supplies the required dense point for every coefficient, so Theorem 5.3 is
unconditional there.

### Corollary 5.5 (finite toric reciprocity ledgers cannot obstruct)

Every nonzero ray on a `C5`-invariant toric model has a free orbit, because
`N^{C5}=0`.  Apply Theorem 5.3 to one quotient place below every ray orbit
of any fixed finite invariant fan, prescribing the local classes of the
actual coefficient `c=r_2^-1`.  One globally soluble `c_b` then agrees with
`c` in the completed projective coefficient quotient at every boundary
ray simultaneously.

This includes two ray orbits whose divisors meet.  Equality in each complete
DVR is equality of the Kummer class before taking residues, so cups with
fixed auxiliary functions, all flags below those divisors, and their
codimension-two Gersten compatibilities agree as well.  Any extra global
reciprocity contribution for `c_b` is carried by new interior prime orbits;
it cannot be detected from the chosen finite boundary ledger.

More generally, Theorem 5.3 matches any preassigned finite collection of
split interior or boundary places.  Therefore a negative theorem cannot be
a finite list of separate conditions at such split places, even when those
conditions are assembled through all faces of one finite toroidal
compactification.  It must find a genuinely bad completion, constrain the
*unbounded, solution-dependent global divisor support*, or use an invariant
not determined by finitely many already-soluble completions.

## 6. Exact boundary

What remains globally different is the placement of all divisor orbits and
the way their leading coefficients glue on one function field.  The local
isomorphism (3.5) does not identify the global `C5`-fields, and it does not
produce an element of `E` solving the actual trace equation.  It proves only
the following sharp exclusions:

```text
UNIT-FREE-PRIME-LABEL-NOT-TOROIDALLY-BIRATIONAL-LOCAL
ACTUAL-AND-SOLUBLE-CLASSES-MATCH-AT-A-FREE-ORBIT-COMPLETION
MATCHING-ACTUAL-TOROIDAL-DEGENERATION-HAS-A-LOCAL-POINT
COEFFICIENT-ONLY-HIGHER-TAME-SYMBOLS-COLLAPSE-TO-LAMBDA-RESIDUE
MIXED-FLAG-SYMBOL-NONVANISHING-COMPATIBLE-WITH-TRACE-ZERO
SINGLE-ORBIT-DEGENERATION-CANNOT-PROVE-F55-NO
ANY-FINITE-SET-OF-SPLIT-LOCAL-CLASSES-HAS-A-GLOBALLY-SOLUBLE-MATCH
TWO-ORBIT-AND-FINITE-FAN-BOUNDARY-RECIPROCITY-OBSTRUCTIONS-REFUTED
MULTI-ORBIT-GLOBAL-GLUING-OBSTRUCTION-STILL-POSSIBLE
F55-GLOBAL-QUESTION-OPEN
```

Any viable next invariant must constrain the unbounded, solution-dependent
global divisor support (including the new interior primes of a putative
trace-zero representative), or use a global moduli invariant not determined
by any fixed finite family of completions.  The theorem does not address a
genuinely bad completion or identify the entire global reciprocity class.
