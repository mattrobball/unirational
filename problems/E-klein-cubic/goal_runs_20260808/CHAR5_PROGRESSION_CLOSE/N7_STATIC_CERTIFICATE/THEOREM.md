# Exact support obstruction in root degree seven

**Date:** 2026-08-08  
**Result:** `F55-CHAR5-DEGREE45-SUPPORT-UNSAT-CERTIFICATE-OK`  
**Scope:** the sixteen exact-two-residue characteristic-five progression
families only

## Theorem

Let the characteristic-five progression coordinate be

\[
 f=x^aH^5+x^bK^5,
 \qquad
 a_j=dj\pmod 5,
 \qquad
 b_j=a_j+r\pmod 5,
\]

where \(d,r\in\{1,2,3,4\}\), and let both root-degree-seven
semi-invariants \(H,K\) be nonzero.  Then

\[
 \sum_{i=0}^4 \rho^i(f)^2\rho^{i+1}(f)\ne0.
\]

Consequently, none of the sixteen families gives a Klein-cubic landing
coordinate of covariant degree

\[
                         10+5\cdot7=45.
\]

The assertion holds over every field of characteristic five: extending to
an algebraic closure cannot create a solution because the support
certificate is already impossible.

## Finite reduction

For each family, the two forced root-weight spaces both have dimension 30.
Rename the fifth powers of their coefficients as 60 Boolean support
variables.  Expanding the landing identity over \(\mathbf F_5\) gives between
7,285 and 9,020 nonzero target-exponent rows.

If an algebraic solution existed, every row would have either zero or at
least two active coefficient monomials.  Exactly one active monomial cannot
cancel.  Also, the H block and K block must each contain a nonzero
coefficient.  `proof.bin` is a complete semantic-DPLL exhaustion of this
necessary Boolean condition for all sixteen families.

### Boolean-support lemma

Let

\[
                         P=\sum_m c_mY^m
\]

be one reconstructed target row after equal coefficient monomials have been
combined over \(\mathbf F_5\), so the displayed monomials are distinct and
every \(c_m\ne0\).  For any coefficient assignment with nonzero-variable
support \(S\), if \(P=0\), then the number of monomials whose variable support
is contained in \(S\) is not one.  Indeed, if exactly one such monomial were
active, its value would be nonzero and all other monomials would vanish, so
the row could not vanish.  This necessary lemma, together with nonempty H and
K supports, is exactly the Boolean system exhausted by the certificate.

The checker reconstructs every weight basis and every landing row from the
displayed formulas.  Each proof step carries a local justification:

- the sole remaining variable in a required H/K block is forced nonzero;
- with one active term, a factor common to every possible alternative is
  forced nonzero;
- when only one possible term remains, its sole undecided factor is forced
  zero;
- a leaf exhibits either an exhausted H/K block or a row with exactly one
  active term.

The final certificate contains 141,092 tree nodes and 70,554 conflicting
leaves.  The dependency-free checker uses only Python's standard library and
does not trust a stored solver status, floating MILP result, or CAS output.

## Combined bounded consequence

Together with the independently checked root degrees one through six, this
gives

```text
F55-CHAR5-TWO-RESIDUE-EMPTY-THROUGH-45
```

## Boundary

This is not an all-degree cutoff.  Root degree at least eight,
three-or-more Frobenius residues, the full characteristic-five dominance
problem, and the characteristic-zero `PSL(2,11)`-unirationality headline all
remain open.
