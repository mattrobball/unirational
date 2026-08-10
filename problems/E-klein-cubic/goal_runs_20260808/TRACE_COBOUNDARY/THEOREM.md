# Additive Hilbert--90 and the cyclic-rank-two obstruction

**Date:** 2026-08-08  
**Scope:** all rational/Laurent supports; no exponent, degree, or support search  
**Result:** `F55-TRACE-CYCLIC-SPAN-AT-LEAST-THREE`

Let

\[
 R=\mathbf C[M],\qquad M=\mathbf Z^5/\mathbf Z(1,1,1,1,1),
 \qquad E=\operatorname {Frac}(R),
\]

let `sigma` cyclically permute the five coordinates, put

\[
 c=\chi^{-e_2},\qquad b=c\,a^2\sigma(a),
\]

and suppose that `a` is nonzero and

\[
 \operatorname {Tr}_{E/E^\sigma}(b)
   =\sum_{i=0}^4\sigma^i(b)=0.                 \tag{0.1}
\]

This note proves two uniform facts:

1. the five summands in (0.1) have no proper zero subsum;
2. their complex cyclic span has dimension at least three.

The second assertion is new relative to the one-eigencharacter exclusion in
`TRACE_POSITIVE/ANALYTIC_AUDIT.md`.  It eliminates every trace zero supported
on only two nontrivial additive Fourier characters, for arbitrary rational
functions and arbitrary divisor complexity.

It does **not** exclude cyclic span three or four, and hence does not prove
`F55-NO`.

## 1. The trace relation is automatically nondegenerate

### Lemma 1.1

Let `L` be a field of characteristic different from two with an automorphism
`tau` of order five.  If `q` is nonzero and

\[
 \sum_{i=0}^4\tau^i(q)=0,
\]

then no nonempty proper subset of the five displayed terms has sum zero.

### Proof

The complement of a zero subsum is again a zero subsum.  It is therefore
enough to exclude subsums with one or two terms.  One term is nonzero.  A
two-term relation, after applying a power of `tau`, has the form

\[
 q+\tau^d(q)=0,\qquad d\not\equiv0\pmod5.
\]

But `tau^d` also has order five, so iteration gives

\[
 q=(\tau^d)^5(q)=(-1)^5q=-q,
\]

contrary to `2q != 0`.  QED.

This proof uses neither the support nor the factorization of `q`.

## 2. Additive Hilbert--90 is integral here

Put `b_i=sigma^i(b)`.  The explicit additive Hilbert--90 primitive

\[
 u={1\over5}\sum_{j=0}^4 j\,\sigma^j(b)                 \tag{2.1}
\]

satisfies

\[
 (\sigma-1)u=b.                                        \tag{2.2}
\]

Indeed, the coefficient of `b_0` in `(sigma-1)u` is `4/5`, and the
coefficient of each `b_j`, `j>0`, is `-1/5`; (0.1) turns this into `b_0`.
In particular, if invariant denominator clearing has made `a` Laurent, then
`b` and the primitive (2.1) are Laurent as well.  Thus

\[
 b_i=\sigma^{i+1}(u)-\sigma^i(u)                        \tag{2.3}
\]

is a nondegenerate cyclic five-edge S-unit relation.

Equation (2.2) supplies no extra cohomological obstruction: every trace-zero
`b` has this primitive.  The useful additional input must come from the
factor multiplicities forced by `b=c a^2 sigma(a)`.

## 3. The order-eleven factor-multiplicity test

Fix an irreducible Laurent prime `P`.  Set

\[
 x_j=v_P(\sigma^j(a)),\qquad
 w_j=v_P(b_j).
\]

Since every conjugate of `c` is a Laurent unit,

\[
 w_j=2x_j+x_{j+1},\qquad j\pmod5.                       \tag{3.1}
\]

The row

\[
 \mu=(1,5,3,4,9)\in(\mathbf Z/11)^5                  \tag{3.2}
\]

annihilates (3.1), because

\[
 2\mu_j+\mu_{j-1}=0\pmod {11}.
\]

Also

\[
 \sum_j\mu_j=22=0\pmod {11},\qquad \mu_j\ne0
 \quad\hbox{for every }j.                              \tag{3.3}
\]

Consequently, if at `P` the five valuations have the form

\[
 (w_0,\ldots,w_4)=m(1,1,1,1,1)+s e_i,                 \tag{3.4}
\]

then `11` divides `s`.  Notice that this is an exact UFD statement at every
Laurent prime; it is not a Newton-polytope approximation.

## 4. A Laurent power-pencil lemma

### Lemma 4.1

Let `S=C[N]` be any Laurent polynomial ring in finitely many variables.  Let
`F,G in S` be coprime and nonzero, and let `t_0,t_1,t_2` be three distinct
complex numbers.  Suppose

\[
 F+t_iG=U_iY_i^n\quad(i=0,1,2),                         \tag{4.1}
\]

where `U_i` are Laurent units and `n>3`.  Then `F/G` is constant.

### Proof

The three left sides are pairwise coprime and have a constant-coefficient
linear relation in which all three coefficients are nonzero.

Assume first that some `Y_i` is a nonunit.  Choose a generic one-parameter
torus coset on which that `Y_i` remains nonconstant and on which the three
pairwise common zero loci are avoided.  Restriction gives pairwise coprime
Laurent polynomials

\[
 A_i(t)=c_i t^{m_i}y_i(t)^n
\]

in one variable with a three-term linear relation.  Let `e` be the least
of their lowest exponents and multiply the relation by `t^{-e}`.  The result
is a coprime polynomial `abc` relation.  If

\[
 d_i=\max\deg_t(y_i)-\min\deg_t(y_i),\qquad d=\max d_i,
\]

then the maximum polynomial degree is at least `n d`.  The radical has at
most one root at zero and at most `sum d_i` nonzero roots.  Mason--Stothers
therefore gives

\[
 nd\le \sum_i d_i\le3d,
\]

contradicting `n>3` and `d>0`.

Thus all three `Y_i` are units, so all three `F+t_iG` are Laurent monomials.
Their nontrivial linear relation forces those monomials to have the same
exponent.  Subtracting two of them shows that `G` is a scalar multiple of
that monomial, and then so is `F`.  Hence `F/G` is constant.  QED.

The generic-coset step is harmless: pairwise coprimality makes each common
zero locus codimension at least two, and a generic coset of a suitably chosen
one-dimensional subtorus avoids the finitely many such loci.  The cocharacter
can simultaneously be chosen nonconstant on the support of a selected
nonunit `Y_i`.

## 5. Uniform exclusion of additive Fourier rank two

### Theorem 5.1

Under (0.1),

\[
 \dim_{\mathbf C}\operatorname {span}_{\mathbf C}
 \{b,\sigma b,\ldots,\sigma^4b\}\ge3.                  \tag{5.1}
\]

### Proof

The cyclic span is diagonalizable.  Its invariant Fourier component is
`Tr(b)/5=0`.  Dimension one would make `b` a nontrivial projective
`sigma`-eigenvector; this is excluded by the exact order-eleven unit argument
of `TRACE_POSITIVE/ANALYTIC_AUDIT.md`, Lemma 3.1.

Suppose its dimension is two.  There are distinct nontrivial fifth roots
`alpha,beta` and nonzero functions `f,g` such that

\[
 b=f+g,\qquad \sigma(f)=\alpha f,\qquad
 \sigma(g)=\beta g.                                    \tag{5.2}
\]

Put `eta=beta/alpha`, and write the nonconstant eigen-ratio in lowest terms

\[
 {g\over f}={G\over F},\qquad (F,G)=1.                 \tag{5.3}
\]

Then

\[
 b_j=\alpha^j {f\over F}H_j,
 \qquad H_j=F+\eta^jG.                                 \tag{5.4}
\]

The five `H_j` are pairwise coprime.  Let an irreducible `P` occur in `H_i`
with multiplicity `s`.  At `P`, (5.4) gives

\[
 (v_P(b_0),\ldots,v_P(b_4))
 =v_P(f/F)(1,1,1,1,1)+s e_i.                           \tag{5.5}
\]

Equations (3.2)--(3.4) force `11 | s`.  This holds for every irreducible
factor of every `H_i`; hence UFD factorization gives

\[
 H_i=U_iY_i^{11}                                       \tag{5.6}
\]

with `U_i` a Laurent unit.

Choose any three indices.  Their `H_i` form a pencil at three distinct
parameters `1,eta^i`, so Lemma 4.1 applies with `n=11`.  If one `H_i` is a
nonunit, a triple containing it is impossible.  Therefore all five `H_i`
are units.  Three of them are linearly dependent in the two-dimensional
space spanned by `F,G`; linear independence of distinct Laurent monomials
forces those three units to be associates.  Subtracting two shows that `F`
and `G` are associates, so `g/f=G/F` is constant.  But (5.2) then gives

\[
 \sigma(g/f)=\eta(g/f),
\]

impossible for a nonzero constant and `eta != 1`.  Thus dimension two is
also impossible.  QED.

This proof is uniform in the support and degrees of `a`.  Its only
arithmetic input is the analytically forced modulus eleven from the
`2+sigma` isogeny.

## 6. Why the full five-term Mason estimates still stop

Theorem 5.1 removes cyclic ranks one and two.  For the remaining five-term
relation, the standard Wronskian bounds range from the general
`binom(4,2)=6` S-unit coefficient to the more favorable `5-2=3`
radical-product coefficient under the usual stronger rank/coprimality
hypotheses.  Even the latter, stronger numerical inequality is too weak for
the squarefree free-orbit divisor pattern.

Indeed, at one free prime orbit, a single simple factor of `a` gives rotations
of

\[
 (2,1,0,0,0).                                          \tag{6.1}
\]

At each of the five places the valuation range is two, so this orbit
contributes `10 deg(P)` to the projective height.  Its radical contributes
`5 deg(P)`.  The five-term estimate allows

\[
 10\deg(P)\le3\cdot5\deg(P).                           \tag{6.2}
\]

Thus arbitrary collections of squarefree free orbits remain compatible even
with the favorable coefficient three; the general coefficient six is weaker
still.  The refined vanishing-sum bound also sees no contradiction: at each
prime in (6.1), exactly two of the five terms are divisible, so the number
`m_P` of nondivisible terms is three.  In the full-rank five-term formula its
local radical weight is

\[
 {4\choose2}-{m_P-1\choose2}=6-1=5,                    \tag{6.3}
\]

again much larger than the valuation range two.  Hence no such estimate
gives a bound on the number of prime orbits or on Laurent support.

The local additive relation

\[
 (1,\ t,\ t^2,\ 1,\ -2-t-t^2)                         \tag{6.4}
\]

is nondegenerate, sums to zero, has valuation vector `(0,1,2,0,0)`, and

\[
 \mu\cdot(0,1,2,0,0)=5+2\cdot3=11.                    \tag{6.5}
\]

Its cyclic vertices are

\[
 0,\ 1,\ 1+t,\ 1+t+t^2,\ 2+t+t^2,\ 0.               \tag{6.6}
\]

So even nondegeneracy, additive telescoping, the exact `2+sigma`
multiplicity residue, and the first local leading cancellation coexist.
This is a local counterconfiguration only, not a trace-zero element of `E`.

## 7. Why the published difference radical does not transfer

The Stothers--Mason difference radical of Ishizaki--Korhonen--Li--Tohge is
built for the infinite-order translation `z -> z+kappa`.  Its proof uses
that a finite difference lowers ordinary polynomial degree.  A finite-order
cyclic automorphism has the opposite behavior on semi-invariants.

For example, with a primitive fifth root `zeta`,

\[
 p=r_0+\zeta^{-1}r_1+\zeta^{-2}r_2
       +\zeta^{-3}r_3+\zeta^{-4}r_4
\]

is a nonunit Laurent polynomial satisfying

\[
 \sigma(p)=\zeta p,\qquad (\sigma-1)p=(\zeta-1)p.       \tag{7.1}
\]

Hence the naive cyclic difference radical
`deg(p)-deg(gcd(p,sigma(p)))` is zero although `p` is nonconstant, and the
difference does not lower support or degree.  Therefore that published
three-term theorem cannot be imported with `sigma` substituted for a
translation.  The valid use of Mason in this packet is the ordinary
three-term theorem inside the power-pencil Lemma 4.1.

## 8. Boundary

The exact new conclusion is

```text
F55-TRACE-NO-PROPER-CONJUGATE-SUBSUM
F55-TRACE-CYCLIC-SPAN-AT-LEAST-THREE
F55-TRACE-RANK-THREE-AND-FOUR-OPEN
F55-GLOBAL-QUESTION-OPEN
```

Any continuation of this route must use the simultaneous factor incidence
among at least three nontrivial Fourier eigenspaces.  A generic five-term
Mason estimate or a finite-order version of the translation difference
radical cannot close the remaining cases.
