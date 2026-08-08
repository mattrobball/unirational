# Coverage C adjudication: equivalence, higher circuits, and corrected theorem boundary

**Date:** 2026-08-08  
**Branch:** `agent/f55-coverage-c-adjudication`  
**Supersedes:** §6 and the `F55-PC-COVERAGE-THEOREM-OPEN` framing in
`F55_POLAR_CIRCUIT_PROOF_REDUCTION_20260808.md`  
**Status:** `COVERAGE-C-WITHDRAWN-AS-A-REDUCTION`  
**Headline:** `F55-QUESTION-OPEN`

## 0. Verdict

Coverage Theorem C cannot honestly be completed as a separate final lemma of
the polar-circuit reduction. Under its natural reading, its fourth
alternative is exactly the assertion that the relevant exact-support torus is
empty. Consequently the global statement of Coverage C is equivalent to the
original F55 pointlessness problem.

This is a logical adjudication, not a computational setback. The earlier
support-ideal theorem already proves the equivalence.

The coefficient-circuit programme remains useful as a source of short exact
certificates for individual supports. It has now produced two new
higher-circuit identities below. What is withdrawn is the claim that
"Coverage C" names a smaller theorem standing between those certificates and
the headline.

---

## 1. Exact equivalence with F55 pointlessness

Retain the notation of the parent proof note:

\[
\Phi(a)=\sum_{i=0}^{4}\sigma^i
  \left(\chi^{-e_2}a^2\sigma(a)\right)
\]

in \(R=\mathbf C[M]\), where
\(M=\mathbf Z^5/\mathbf Z(1,1,1,1,1)\). For a finite support
\(S\subset M\), write

\[
a=\sum_{s\in S}A_s\chi^s,\qquad
I_S=(F_\gamma)\subset\mathbf Q[A_s:s\in S],
\qquad m_S=\prod_{s\in S}A_s.
\]

Theorem 3.2 of the parent note says

\[
V(I_S)\cap(\mathbf C^*)^S=\varnothing
\quad\Longleftrightarrow\quad
I_S:m_S^\infty=(1)
\quad\Longleftrightarrow\quad
A^u=\sum_\gamma H_\gamma F_\gamma
\tag{1.1}
\]

for some nonzero coefficient monomial \(A^u\).

### Theorem 1.1 — equivalence

The following are equivalent.

1. The generic F55 trace cubic has no nonzero \(K\)-point.
2. There is no nonzero Laurent polynomial \(a\in R\) with \(\Phi(a)=0\).
3. For every finite support \(S\subset M\),
   \(I_S:m_S^\infty=(1)\).
4. For every finite support \(S\subset M\), there is a monomial identity
   of the form (1.1).
5. Coverage C holds under the reading that alternative (iv) permits an
   arbitrary finite monomial certificate depending on the supplied core.

**Proof.**

- (1) implies (2) because a Laurent zero is a rational zero.
- (2) implies (1) by invariant denominator clearing: every rational zero
  produces a Laurent-polynomial zero.
- (2), (3), and (4) are equivalent support by support by Theorem 3.2.
- (4) implies (5) using alternative (iv) alone.
- (5) implies (2): choose a primitive support-minimal Laurent zero. Its
  incidence core is connected. Each of alternatives (i)--(iv) puts a
  nonzero monomial in the localized support ideal, contradicting evaluation
  at the torus point supplied by the zero.

Thus Coverage C is the desired anisotropy theorem in different words. ∎

### Uniform-bound reading

The adjective "bounded" could instead be intended to mean a bound uniform in
all supports, for example a fixed number of rows and a fixed multiplier
degree. No such bound was stated in Coverage C, and it does not follow from
the Nullstellensatz equivalence above.

A precise uniform circuit theorem would be a valid new proof strategy, but it
would itself be a direct proof of F55 pointlessness. It must specify the
bound and prove a genuine coverage statement independently of bounded
experiments.

Therefore the former formulation is:

```text
unbounded reading  -> equivalent to the headline;
uniform reading    -> incomplete until the uniform bound is stated and proved.
```

It is not a minimized residual lemma in either reading.

---

## 2. Exact failure of the three cheap alternatives

The following homogeneous degree-four support is written in the order
defining coefficient variables \(A_0,\ldots,A_{15}\):

\[
\begin{aligned}
S_{16}=\{&
(0,1,0,0,3),(0,1,3,0,0),(0,2,0,0,2),(0,2,0,1,1),\\
&(0,2,1,0,1),(0,2,2,0,0),(0,3,0,1,0),(1,1,0,0,2),\\
&(1,1,0,2,0),(1,1,2,0,0),(1,2,0,0,1),(1,2,0,1,0),\\
&(1,2,1,0,0),(1,3,0,0,0),(2,1,0,0,1),(2,1,1,0,0)\}.
\end{aligned}
\tag{2.1}
\]

The checked-in verifier rebuilds every trace row from Proposition 3.1 and
proves exactly:

1. no nonzero row is a singleton;
2. deleting any one point of \(S_{16}\) creates a singleton row;
3. there is no clean polar pair with nonzero determinant;
4. the initial binomial subsystem has eleven distinct rows, rank eleven,
   and Smith diagonal \((1,\ldots,1)\); hence it has no integral holonomy
   relation to fail.

Thus alternatives (i)--(iii) do not cover even this deletion-minimal finite
core.

The core is nevertheless empty on the coefficient torus. Four exact trace
rows are

\[
\begin{aligned}
f_1&=A_0^2A_8+A_6^2A_{15},\\
f_2&=A_0^2A_{11}+2A_3A_6A_{15},\\
f_3&=2A_0A_2A_8+A_6^2A_9,\\
h&=2A_0A_2A_{11}+2A_0A_4A_8+2A_3A_6A_9.
\end{aligned}
\]

They satisfy

\[
A_0A_6h-2A_2A_6f_2-2A_0A_3f_3+4A_2A_3f_1
 =2A_0^2A_4A_6A_8.
\tag{2.2}
\]

The right side is a unit on the coefficient torus. This is the first exact
higher-circuit certificate beyond singletons, clean diamonds, and initial
binomial holonomy.

---

## 3. Universal four-row polar rectangle

Identity (2.2) is an instance of a universal algebraic circuit.

### Lemma 3.1 — four-row rectangle

Let

\[
\begin{aligned}
f_{00}&=a^2p+b^2q,\\
f_{10}&=a^2r+2bcq,\\
f_{01}&=2adp+b^2e,\\
f_{11}&=2adr+2afp+2bce.
\end{aligned}
\]

Then

\[
abf_{11}-2dbf_{10}-2acf_{01}+4dcf_{00}
 =2a^2bfp.
\tag{3.1}
\]

**Proof.** Expand the left side. The \(a^2bdr\),
\(acb^2e\), \(a^2cdp\), and \(b^2cdq\) terms cancel pairwise; only
\(2a^2bfp\) remains. ∎

This identity is bounded—four rows and quadratic monomial multipliers—but
there is currently no theorem forcing every primitive core to contain this
rectangle.

---

## 4. A second completion circuit

A separate 26-term degree-four support found during the exact search also
passes all three cheap filters:

```text
no singleton;
no clean polar determinant;
six independent saturated binomial rows;
no initial holonomy relation.
```

It contains the rows

\[
\begin{aligned}
B&=A_7^2A_{23}+A_{23}^2A_{24},\\
R&=A_7^2A_{10}
   +2A_{10}A_{23}A_{24}
   +A_{21}A_{23}^2,\\
H&=2A_{10}A_{13}A_{24}
   +2A_{10}A_{23}A_{25}
   +2A_{13}A_{21}A_{23}.
\end{aligned}
\]

They satisfy

\[
A_{23}^2H-2A_{13}A_{23}R+2A_{10}A_{13}B
 =2A_{10}A_{23}^3A_{25}.
\tag{4.1}
\]

The general identity is the following.

### Lemma 4.1 — three-row completion

If

\[
\begin{aligned}
B&=a^2p+p^2b,\\
R&=a^2c+2cpb+dp^2,\\
H&=2ceb+2cpf+2edp,
\end{aligned}
\]

then

\[
p^2H-2epR+2ecB=2cp^3f.
\tag{4.2}
\]

**Proof.** Direct expansion cancels the \(a^2cep\), \(cep^2b\), and
\(dep^3\) terms and leaves \(2cp^3f\). ∎

This explains the iterative binomial-completion observation: a binomial row
can be used to reduce a trinomial row, after which the next row becomes a
monomial consequence. Again, the identity is exact but no all-support
coverage theorem has been proved.

---

## 5. Corrected computational boundary

The finite-support pipeline remains valid:

```text
C0  exact integer trace-row compiler;
C1  singleton, clean-diamond, and full binomial-holonomy tests;
C1R four-row rectangle and three-row completion tests;
C2  exact saturation only for surviving finite cores.
```

The retained output for a negative finite support is one monomial identity.
A positive exact torus point remains globally decisive because it gives a
literal Laurent solution of the authoritative trace equation.

What a bounded search cannot establish is the universal quantifier over
supports. In particular:

- the degree-four identities above do not imply a support bound;
- absence of exceptions through any finite degree does not prove anisotropy;
- a finite Hilbert-basis computation requires a pointed cone supplied by a
  separate theorem;
- calling the remaining step "Coverage C" does not reduce its logical
  strength.

A noncircular negative proof now needs one of the following:

1. a stated universal circuit list with an independently proved coverage
   theorem;
2. a genuine finite-generation theorem for primitive cores;
3. a direct arithmetic or geometric obstruction to the trace cubic.

The rectangle identities enlarge option 1's candidate circuit list. They do
not complete its coverage proof.

---

## 6. Reproducer and theorem markers

Exact verifier:

```text
director_probes_20260808/f55_coverage_c_adjudicate.py
```

It rebuilds the trace rows, independently checks the filters and Smith forms,
and expands both monomial identities. Terminal marker:

```text
F55_COVERAGE_C_ADJUDICATION_OK
```

Corrected status markers:

```text
F55-PC-CHEAP-COVERAGE-REFUTED
F55-PC-HIGHER-CIRCUITS-PASS
F55-PC-COVERAGE-C-EQUIVALENT-TO-HEADLINE
F55-QUESTION-OPEN
```
