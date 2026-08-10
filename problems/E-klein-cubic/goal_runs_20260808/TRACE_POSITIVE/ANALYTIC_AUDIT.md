# Analytic audit of the `F55` trace cubic

**Date:** 2026-08-08  
**Scope:** exact multiplicative/divisor invariants and uniform ansatz exclusions  
**Headline:** `F55-QUESTION-OPEN`

## 1. Audited equation

Put

\[
R=\mathbf C[M],\qquad M=\mathbf Z^5/\mathbf Z(1,1,1,1,1),
\qquad E=\operatorname {Frac}(R),
\]

with `sigma(e_i)=e_(i+1)`, `K=E^sigma`, and

\[
c=\chi^{-e_2}=r_2^{-1},\qquad
\psi(a)=a^2\sigma(a),\qquad
\Phi(a)=\operatorname {Tr}_{E/K}(c\psi(a)).
\]

This agrees term for term with the sealed coordinate formula

\[
\Phi(Z(r_0))=\sum_{i=0}^4
\frac{Z(r_i)^2Z(r_{i+1})}{r_{i+2}}.
\]

Thus a positive answer is exactly a nonzero `a in E` for which, after putting
`b=c psi(a)`, one has `sum sigma^i(b)=0`.

## 2. The complete multiplicative residue of a proposed `b`

The Laurent ring `R` is a UFD and its units are
`C^* chi^M`.  Let `O` be an orbit of prime divisors on the torus.  Its length
is one or five.  For a length-five orbit, label the primes
`P_i=sigma^i(P_0)` and put

\[
w_O(q)=(v_{P_0}(q),\ldots,v_{P_4}(q))\in\mathbf Z^5.
\]

If `q=psi(a)`, then

\[
w_O(q)=(2+P)w_O(a),
\]

where `P` is the five-cycle permutation matrix.  Exact Smith form gives

\[
\operatorname {SNF}(2+P)=\operatorname {diag}(1,1,1,1,33).
\]

The cokernel is detected by

\[
\sum_iw_i\pmod3,
\qquad
\lambda(w)=w_0+9w_1+4w_2+3w_3+5w_4\pmod {11}.
\tag{2.1}
\]

Both functionals annihilate `(2+P)Z^5`, and `e_0` maps to `(1,1)`, so
(2.1) detects the entire cyclic cokernel of order `33`.  At a fixed prime,
the condition is simply divisibility of the valuation by three.

After all prime divisors have been removed, the residual factor is a torus
unit.  On `M`,

\[
\operatorname {SNF}(2+\sigma)=\operatorname {diag}(1,1,1,11),
\tag{2.2}
\]

and the same `lambda` (well defined because its five coefficients sum to zero
modulo eleven) detects the unit obstruction.  Constants cause no obstruction,
because cubing is surjective on `C^*`.

Consequently (2.1), the fixed-prime mod-three residues, and (2.2) are a
necessary and sufficient finite test for whether any *specified* nonzero
`q in E` belongs to `psi(E^*)`.

Projectively one asks whether `q` lies in `K^* psi(E^*)`.  An invariant norm
of a free prime adds the diagonal vector `(1,1,1,1,1)`: this kills the
mod-three part of (2.1) but leaves `lambda` unchanged.  At a fixed prime the
coefficients `3` (from `psi`) and `5` (from an invariant norm) are coprime, so
there is no projective residue.  Thus the genuinely projective residue at
every free prime orbit is exactly one element of `Z/11`, together with the
order-eleven torus-unit residue.  This is the divisor form of the known
degree-eleven projective isogeny; it is not a new pointlessness theorem.

## 3. Uniform exclusion I: one-character trace cancellation

### Lemma 3.1

There is no nonzero `a in E` for which

\[
b=c a^2\sigma(a)
\]

is a projective `sigma`-eigenvector.

### Proof

Assume `sigma(b)=eta b`, with `eta in C^*`, and set
`t=sigma(a)/a`.  Direct division gives

\[
t^2\sigma(t)=\eta\,r_3/r_2.
\tag{3.1}
\]

Take divisors on the torus.  The right side is a unit, hence
`(2+sigma) div(t)=0`.  On every prime orbit the operator is multiplication by
three or the matrix `2+P`; both are injective.  Therefore `div(t)=0`, so

\[
t=\alpha\chi^m
\]

for `alpha in C^*` and `m in M`.  Equation (3.1) now forces

\[
(2+\sigma)m=e_3-e_2.
\tag{3.2}
\]

But `lambda` annihilates `(2+sigma)M`, whereas
`lambda(e_3-e_2)=3-4=-1 mod 11`.  This contradicts (3.2).  QED.

If a conjugate ratio `t=sigma(a)/a` is a Laurent unit, all five conjugates of
`b` are `b` times Laurent units.  If their sum vanished, two of those Laurent
monomials would coincide; then two conjugates of `b` would be constant
multiples.  Since every nonidentity power of `sigma` generates `C_5`, `b`
would be a projective eigenvector, contrary to Lemma 3.1.  Hence:

### Corollary 3.2

The trace cubic has no zero for which `sigma(a)/a` is a Laurent unit.  This
uniformly excludes the entire one-monomial multiplicative Hilbert--90 route,
including all exponent sizes and all fifth-root phases.

## 4. Uniform exclusion II: one-monomial additive Hilbert--90

### Lemma 4.1

Let `H in K^*` and let `u` be a Laurent monomial.  If
`H(u-sigma(u))` is nonzero, then

\[
H(u-\sigma(u))\notin c\,\psi(E^*).
\]

### Proof

Write `u=alpha chi^n`.  If `(sigma-1)n=0` in `M`, then `u` is constant and
the displayed coboundary is zero.  Otherwise write
`(sigma-1)n=q d` with `d` primitive.  Over `C`,

\[
1-\chi^{qd}=\prod_{\zeta^q=1}(1-\zeta\chi^d)
\]

with every factor simple.  Choose one factor `P_0`.  Its five conjugates are
distinct: an association between two would give
`sigma^j d=+d` or `-d`; either relation forces `d=0` because five is odd and
`M` has no nonzero fixed vector.

Along this free prime orbit, `u-sigma(u)` has valuation vector `e_0`.
Because `H` is invariant, its valuation vector is diagonal, say `h 1`.
The factor `c` is a torus unit.  Therefore membership in `c psi(E^*)` would
force

\[
e_0+h\mathbf1\in(2+P)\mathbf Z^5.
\]

Applying `lambda` gives `1+0=0 mod 11`, a contradiction.  QED.

This is stronger than the bounded additive-monomial screens in H5: it allows
arbitrary exponents and arbitrary invariant scaling.

## 5. Why the obvious norm and cohomology upgrades stop

Taking norms in `b=c psi(a)` gives

\[
N_{E/K}(b)=N(a)^3,
\tag{5.1}
\]

because `N(c)=1`.  Thus cube norm is necessary.  It is far from sufficient:
if `f` is any nontrivial `sigma`-eigenvector, then `b=f^3` has trace zero and
`N(b)=N(f)^3`, yet Lemma 3.1 proves that it cannot equal `c psi(a)`.

Likewise the order-eleven class of `c`, the Kummer resolvent obtained from an
adjugate of `2+sigma`, and the free-prime residues (2.1) are different forms
of the same multiplicative obstruction.  The corrected eigen-exhaustion in
`theory/FIX_IX_v14.md`, Section 8.28, shows that the only annihilated
eigencomponent recovers this order-eleven congruence; all other components
merely solve for the unknown class of `a`.  No second independent cover is
produced.

The explicit convex-polytope witness from the same section satisfies the
entire boundary valuation shadow.  Therefore a proof using only norms,
divisor orders, Newton support functions, or this single Kummer class cannot
establish pointlessness.  It must also use additive leading coefficients (or
a genuinely new higher invariant).

There is already a tiny local model showing that the additive trace relation
and the order-eleven residue are compatible.  In `C((t))`, take consecutive
differences

\[
(d_0,d_1,d_2,d_3,d_4)
=(1,1,t^2,t,-2-t-t^2).
\]

They sum to zero, their valuation vector is

\[
w=(0,0,2,1,0),
\]

the minimum occurs three times, and

\[
\lambda(w)=4\cdot2+3\cdot1=11=0\pmod {11}.
\]

Thus even the exact local telescoping relation among five conjugate
differences does not contradict the projective divisor residue.  A successful
negative invariant has to couple different prime orbits or retain more than
their orders and first cancellation relation.

## 6. Audit of sparse-support claims and the remaining finite boundary

The authoritative exact compiler and saturation criterion in
`F55_POLAR_CIRCUIT_PROOF_REDUCTION_20260808.md` are sound for each supplied
finite support.  They do not give a support-size bound.  In particular:

- the sealed two-Laurent theorem is genuinely all-exponent, but only for two
  constant Laurent coefficients; its current verifier was replayed and ended
  `H_TRACE_TWO_LAURENT_ALL_EXPONENT_EXCLUSION_OK` after all `203` coefficient
  partitions and `7125` integral shift systems;
- the later H6 push called `two_support_laurent` and
  `three_support_laurent` is discovery-only: its exponents are restricted to
  `[-2,2]^5` with `l1 <= 3`, its coefficient tuples come from short menus,
  and its identity test is modular evaluation;
- Coverage Theorem C is exactly the missing all-support statement.  A
  connected minimal cancellation graph and row-circuit coverage do not bound
  either the number of support points or the circuit lengths.

Invariant denominator clearing proves that a rational zero would yield some
finite Laurent zero.  Multiplication by invariant polynomials can enlarge
support without changing `Phi=0`; taking a primitive support-minimal factor
removes that trivial enlargement but supplies no numerical bound.  The
collision lattices have lineality, and fixed-dimensional toric ideals have
circuits of unbounded degree.  Thus there is presently no analytically proved
finite support universe to enumerate.

The smallest genuinely finite residue left by this audit is not a degree or
support cutoff.  It is:

```text
for each prime orbit appearing in a proposed trace-zero b:
    one lambda residue in Z/11;
after those divisors are removed:
    one torus-unit residue in Z/11.
```

These residues decide the multiplicative lifting of that particular `b`
completely.  What remains infinite is the additive problem of finding or
excluding every `b in ker(Tr)` whose residues equal the class prescribed by
`c`.  No existing bounded scan, polar-circuit packet, or valuation witness
closes that quantifier.

## 7. Verdict

The analytic audit proves two new uniform no-go lemmas, sharpens the exact
projective divisor invariant, and removes the one-character and one-monomial
Hilbert--90 positive routes.  It does **not** prove `F55-NO` or `F55-YES`.

Replay the finite arithmetic inputs with:

```sh
python3 goal_runs_20260808/TRACE_POSITIVE/verify_analytic.py
```

Expected marker:

```text
F55-TRACE-ANALYTIC-LEMMAS-OK
```
