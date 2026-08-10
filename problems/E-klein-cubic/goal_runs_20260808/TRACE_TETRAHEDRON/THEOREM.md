# Exact all-exponent exclusion for four Laurent terms

**Date:** 2026-08-08  
**Scope:** constant-coefficient Laurent polynomials with exactly four distinct
support exponents  
**Result:** `F55-TRACE-FOUR-TERM-ALL-EXPONENT-EXCLUSION`

Use

\[
 M=\mathbf Z^5/\mathbf Z(1,1,1,1,1),\qquad
 \Phi(a)=\sum_{i=0}^4\sigma^i\!\left(\chi^{-e_2}a^2\sigma(a)\right).
\]

## Theorem

If

\[
 a=\sum_{j=0}^3A_j\chi^{s_j},\qquad A_0A_1A_2A_3\ne0,
\]

and `s_0,...,s_3` are distinct elements of `M`, then

\[
 \boxed{\Phi(a)\ne0.}
\]

The exponents are unrestricted: there is no degree, width, affine-dimension,
or finite-box assumption.

## Proof synthesis

The five fixed torus points first force the residue partition of the support
degrees modulo five to be either `4` or `2+2`.

1. The `2+2` case has opposite coefficients within each pair.  The tangent
   tensor forces the two pair differences to be rationally parallel; the
   same five tangent equations then force a nonzero two-term polynomial to
   vanish at all fifth roots.  This is impossible.
2. In the one-residue case, affine-rank three is excluded by the norm-fibre
   recurrence in `TETRAHEDRAL_EXCLUSION.md`.  Its only two root shapes are a
   square, killed by the degree-ten trace coefficient, and four vertices of
   a regular pentagon, killed by the order-eleven affine-coset obstruction.
3. Affine-rank one is excluded by two leading one-direction jets followed by
   the four-by-four Vandermonde determinant.
4. For affine rank two, a nonzero first moment is excluded by the mixed
   degree-four and degree-five jets, again followed by a four-by-four
   Vandermonde determinant.  Thus the coefficients form the unique affine
   circuit of the four points.  No three points can be collinear.
5. A `1+3` circuit (one point inside the other three) has a definite second
   moment; positivity contradicts its leading Klein landing identity.  A
   convex `2+2` circuit has a nonzero rational rank-two second moment `Q` and
   would require

   \[
    \sum_iQ_i^2Q_{i+1}=0.
   \]

   `RANK2_QUADRATIC_EXCLUSION.md` proves that no rational rank-two quadratic
   form satisfies this identity.  Its cyclic-factor branch is killed by four
   exact evaluations of one universal normal form.  Its neither-cyclic
   branch is forced by absolute-Galois Fourier zero-patterns into
   `U_14 x U_23`, where four explicit nonzero coefficients contradict the
   identity.

These cases exhaust the affine ranks and the two four-term residue
partitions, proving the theorem.

## Deletion bridge versus the completed theorem

The parallelogram support

\[
 (s_0,s_1,s_2,s_3)=(0,e_0,e_1,e_0+e_1),\qquad
 (A_0,A_1,A_2,A_3)=(1,2,3,-6)
\]

is still a useful counterexample to closing the four-term problem merely by
deleting to the sealed triangle theorem: all four designated deletion
bridges exist and their paired contributions cancel.  It is not a trace
zero.  The two full bridge classes total `-36` and `-24`, and a singleton
trace class survives with coefficient `18`.  The completed proof instead
uses fixed-point jets, affine circuits, and the universal rank-two landing
theorem.

## Consequence and boundary

Together with the sealed `TRACE_TRIANGLE` theorem and the earlier one- and
two-term cases, this excludes every nonzero constant-coefficient Laurent
polynomial supported on at most four monomials.

It does **not** give a support bound for a general solution, exclude supports
of size at least five, handle invariant-field coefficients or arbitrary
rational functions, prove `F55-NO`, or decide the original
`PSL(2,11)`-unirationality question.  The global verdict remains open.

```text
F55-TRACE-FOUR-TERM-ALL-EXPONENT-EXCLUSION
F55-GLOBAL-QUESTION-OPEN
```
