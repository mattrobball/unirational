# F55 polar-circuit reduction: proof layer and minimal CAS boundary

**Date:** 2026-08-08  
**Baseline:** `agent/f55-audit-obstruction` at `6e0fb5987e42158eb19f4844deef40883ca253a1`  
**Status:** `PROVED-REDUCTIONS / OPEN-COVERAGE`  
**Headline:** the F55/V14 unirationality question remains `OPEN`

This note supplies the proof layer behind items 1--5 of
`F55_REPLACEMENT_OBSTRUCTION_20260808.md` and minimizes the residual
computational interface.  It also corrects one over-broad suggestion in that
note: for unrestricted Laurent supports, collision loci have lattice
lineality and are not reduced to finitely many types merely by taking a
Hilbert basis and quotienting by invariant translations.  Normaliz remains
appropriate for bounded polynomial cones, but an all-support theorem still
requires a separate coverage argument.

The authoritative negative target is

\[
\Phi(a)=\operatorname{Tr}_{E/K}(r_2^{-1}a^2\sigma(a))\ne0
\qquad\text{for every }0\ne a\in E.
\]

Everything below is formulated directly in the trace model.  This eliminates
the five projective-twist cases and all fifth-root phase bookkeeping from the
all-degree problem.

---

## 1. Lattice setup and the order-eleven defect

Let

\[
M=\mathbf Z^5/\mathbf Z(1,1,1,1,1),\qquad
R=\mathbf C[M],\qquad K=\operatorname{Frac}(R)^{\langle\sigma\rangle},
\]

where indices are modulo five and \(\sigma(e_i)=e_{i+1}\).  Write
\(\chi^m\) for the Laurent monomial attached to \(m\in M\), and put
\(c=\chi^{-e_2}\).  Then

\[
\Phi(a)=\sum_{i=0}^4\sigma^i\!\left(ca^2\sigma(a)\right).
\]

### Lemma 1.1 — no fixed lattice direction

For \(d=1,2,3,4\),

\[
M^{\sigma^d}=0.
\]

**Proof.**  Suppose \(\sigma^d[m]=[m]\).  For a lift
\(m\in\mathbf Z^5\),

\[
\sigma^dm-m=t(1,1,1,1,1)
\]

for some \(t\in\mathbf Z\).  Summing coordinates gives \(0=5t\), so
\(t=0\).  Since \(\sigma^d\) is a five-cycle, its fixed vectors in
\(\mathbf Z^5\) are diagonal.  Their classes in \(M\) vanish.  ∎

Consequences used below:

1. the only \(\sigma\)-invariant Laurent monomial units are constants;
2. if \(\sigma^i x=\sigma^j x\) for \(x\ne0\), then \(i=j\) modulo five;
3. the slot classification in §4 has no hidden fixed-direction exceptions.

### Lemma 1.2 — the cokernel of \(2+\sigma\)

The endomorphism \(2+\sigma:M\to M\) is injective and

\[
|\operatorname{coker}(2+\sigma)|=11.
\]

Moreover the functional

\[
\lambda([m_0,\ldots,m_4])
 =m_0+9m_1+4m_2+3m_3+5m_4\pmod {11}
\]

annihilates \((2+\sigma)M\), and \(\lambda(e_2)=4\ne0\).

**Proof.**  Over \(\mathbf Q\), the eigenvalues of \(\sigma\) on
\(M\) are the four nontrivial fifth roots of unity.  Hence

\[
\det(2+\sigma)
 =\prod_{j=1}^4(2+\zeta_5^j)
 =\Phi_5(-2)=11.
\]

Thus the map is injective with cokernel of order eleven.  The coefficient
vector \((1,9,4,3,5)\) has sum zero modulo eleven, so \(\lambda\) is
well-defined on \(M\).  Since

\[
2(1,9,4,3,5)+(9,4,3,5,1)=(11,22,11,11,11),
\]

we have \(\lambda((2+\sigma)m)=0\).  Finally
\(\lambda(e_2)=4\).  ∎

This lemma records the genuine eleven-primary defect of the projective
isogeny, but it is not itself a pointlessness theorem: additive cancellation
among several coefficient monomials remains possible.

### Lemma 1.3 — no common exponent-translation gauge

Suppose multiplication by \(\chi^t\) factors out of all five trace summands by
the same Laurent monomial.  Then \(t=0\).

**Proof.**  Put \(q=(2+\sigma)t\).  Directly,

\[
\Phi(\chi^ta)=
\sum_{i=0}^4
\chi^{\sigma^iq}\,\sigma^i(ca^2\sigma(a)).
\]

A common monomial factor requires \(\sigma^iq\) to be independent of \(i\),
so \(q\in M^\sigma=0\) by Lemma 1.1.  Injectivity in Lemma 1.2 then gives
\(t=0\).  ∎

Thus a common translation of every support exponent is not a symmetry of the
fixed trace equation.  The safe normalization in §2 is by invariant
polynomial factors.

---

## 2. Item 1: rational solutions reduce to primitive finite Laurent support

### Proposition 2.1 — invariant denominator clearing

If \(0\ne a\in\operatorname{Frac}(R)\) and \(\Phi(a)=0\), then there is a
nonzero Laurent polynomial \(a_L\in R\) with \(\Phi(a_L)=0\).

**Proof.**  Write \(a=P/Q\) with \(P,Q\in R\), \(Q\ne0\), and set

\[
N(Q)=\prod_{i=0}^4\sigma^i(Q)\in K^*.
\]

Then

\[
a_L=N(Q)a=P\prod_{i=1}^4\sigma^i(Q)\in R.
\]

For every \(b\in K^*\), \(\sigma(b)=b\), so

\[
\Phi(ba)=b^3\Phi(a).
\]

Taking \(b=N(Q)\) proves the result.  ∎

Thus all subsequent arguments may assume finite support.

### Proposition 2.2 — primitive support-minimal representative

If a Laurent-polynomial zero exists, then one exists satisfying:

1. its Newton width is minimal among all nonzero Laurent-polynomial zeros;
2. among width-minimal zeros, its support cardinality is minimal, hence no
   proper sub-support carries a zero;
3. it has no nonunit divisor in \(R^{\sigma}\).

**Proof.**  Choose a basis \(\ell_1,\ldots,\ell_4\) of
\(M^\vee\), and define

\[
W(f)=\sum_{j=1}^4
\left(\max_{m\in\operatorname{Newt}(f)}\ell_j(m)
      -\min_{m\in\operatorname{Newt}(f)}\ell_j(m)\right).
\]

Among all nonzero Laurent-polynomial zeros, first minimize the nonnegative
integer \(W(f)\), then minimize support size.

If a proper subset of the selected support carried a zero \(f\), then
\(\operatorname{Newt}(f)\subseteq\operatorname{Newt}(a)\), hence
\(W(f)\le W(a)\).  Strict inequality contradicts width minimality, while
equality contradicts support-cardinality minimality.  This proves property 2.

Suppose now that the selected \(a\) is divisible by a nonunit
\(b\in R^\sigma\), say \(a=bd\).  Since \(b\) is invariant,

\[
0=\Phi(a)=b^3\Phi(d),
\]

and the group algebra is a domain, so \(\Phi(d)=0\).  Newton polytopes of
products add:

\[
\operatorname{Newt}(a)
 =\operatorname{Newt}(b)+\operatorname{Newt}(d).
\]

Widths are therefore additive.  By Lemma 1.1, a monomial invariant is a
constant; hence a nonunit invariant \(b\) has positive width in at least one
basis direction.  Thus \(W(d)<W(a)\), contradicting minimality.  ∎

We call such a zero **primitive support-minimal**.  This is the correct
invariant-factor normalization.  It is not a quotient by common exponent
translations, which are excluded by Lemma 1.3.

### Lemma 2.3 — one-term support is impossible

A nonzero Laurent monomial cannot be a zero of \(\Phi\).

**Proof.**  If \(a=A\chi^m\), then

\[
\Phi(a)=A^3\sum_{i=0}^4
\chi^{\sigma^i(2m+\sigma m-e_2)}.
\]

After equal exponents are combined, every coefficient is a positive integer.
A nonzero positive linear combination of distinct group-algebra basis
monomials cannot vanish in characteristic zero.  ∎

No computation remains in item 1 beyond a tiny regression of the lattice
conventions and Smith form.

---

## 3. Item 2: exact support ideals and the smallest possible certificate

Let \(S\subset M\) be finite and write

\[
a=\sum_{s\in S}A_s\chi^s.
\]

For \(i\in\mathbf Z/5\), define the slot map

\[
T_i(p,q;r)=\sigma^i(p+q+\sigma r-e_2).
\]

Here \(p,q\) occupy the squared slot and \(r\) the shifted slot.
After commutativizing \(p,q\), put

\[
\mu(p,q)=
\begin{cases}
1,&p=q,\\
2,&p\ne q.
\end{cases}
\]

### Proposition 3.1 — exact coefficient compiler formula

There are uniquely determined polynomials
\(F_\gamma\in\mathbf Z[A_s:s\in S]\) such that

\[
\Phi(a)=\sum_{\gamma\in M}F_\gamma(A)\chi^\gamma,
\]

and explicitly

\[
F_\gamma
 =\sum_{\substack{i,\,p\le q,\,r\in S\\T_i(p,q;r)=\gamma}}
 \mu(p,q)A_pA_qA_r,
\]

where identical commutative coefficient monomials are combined.

**Proof.**  Expand \(a^2\sigma(a)\), apply \(c\), then apply each
\(\sigma^i\).  The two ordered occurrences of distinct squared-slot indices
produce multiplicity two, while a repeated index occurs once.  The Laurent
monomials \(\chi^\gamma\) form a basis of the group algebra, so collecting
equal exponents gives the unique displayed coefficients.  ∎

Important minimization: all coefficients are ordinary integers.  The five
projective twists and exact \(\mathbf Q(\zeta_5)\) arithmetic are unnecessary
for the authoritative trace-support compiler.

### Theorem 3.2 — exact-support torus criterion

Let

\[
I_S=(F_\gamma:\gamma\in M)
 \subset \mathbf Q[A_s:s\in S],
\qquad
m_S=\prod_{s\in S}A_s.
\]

Then a trace-cubic zero with support exactly \(S\) exists over \(\mathbf C\)
if and only if

\[
I_S:m_S^\infty\ne(1).
\]

Equivalently, exact-support nonexistence is certified by one identity

\[
m_S^N=\sum_\gamma H_\gamma F_\gamma
\tag{3.1}
\]

for some \(N\ge0\) and
\(H_\gamma\in\mathbf Q[A_s:s\in S]\).

**Proof.**  Exact support means a common zero of the \(F_\gamma\) in the
algebraic torus \(D(m_S)\).  This common-zero set is empty exactly when the
localized ideal \(I_S\mathbf Q[A_s^{\pm1}:s\in S]\) is the unit ideal.  By
localization and the Nullstellensatz, this is equivalent to
\(1\in I_S:m_S^\infty\), hence to \(m_S^N\in I_S\) for some \(N\), which is
exactly (3.1).  ∎

Identity (3.1), checked by sparse expansion over \(\mathbf Q\), is the
smallest general CAS certificate.  A Gröbner basis, primary decomposition,
or numerical solution set need not be retained.

### Proposition 3.3 — exact face equation above the PL shadow

Let \(h_a(\omega)=\max_{s\in S}\langle\omega,s\rangle\).  The maximum
\(\omega\)-weight of the \(i\)-th trace summand is

\[
q_i(\omega)=
-\langle\omega,\sigma^ie_2\rangle
+2h_a(\sigma^{-i}\omega)
+h_a(\sigma^{-(i+1)}\omega).
\]

If \(\Phi(a)=0\), the sum of the exact face polynomials belonging to the
indices attaining \(\max_i q_i(\omega)\) is zero.

**Proof.**  Initial forms commute with multiplication in a group algebra, and
\(\operatorname{in}_\omega(\sigma^if)
 =\sigma^i(\operatorname{in}_{\sigma^{-i}\omega}f)\).  Taking the initial
form of \(\Phi(a)=0\) gives the asserted equation.  ∎

The former twice-min condition records only which \(q_i\) are maximal.  The
replacement obstruction retains the face coefficients and their exact
multiplicities.

---

## 4. Item 3: all two-row polar diamonds are one affine slot template

A clean two-row obstruction has monomial pattern

\[
\begin{aligned}
f&=\alpha X_u^2X_v+\beta X_uX_w^2,\\
g&=\alpha'X_uX_vX_z+\beta'X_zX_w^2,
\end{aligned}
\tag{4.1}
\]

with \(z\ne u\), no other active monomials in these rows, and all displayed
coefficients nonzero.  The compiler computes the four integer coefficients;
we do not assume in advance that they are \(1,1,2,1\).

### Theorem 4.1 — polar-slot classification

Suppose the four monomials in (4.1) arise respectively from

\[
T_i(u,u;v),\quad T_j(w,w;u),\quad
T_i(u,z;v),\quad T_j(w,w;z),
\]

and the first pair has equal output exponent while the second pair has equal
output exponent.  Then necessarily

\[
j=i-1\pmod5
\tag{4.2}
\]

and

\[
2w=\sigma u+\sigma^2v+e_2-\sigma e_2.
\tag{4.3}
\]

Conversely, (4.2)--(4.3) imply both output collisions for every \(z\).

**Proof.**  Subtract the first output equality from the second.  The left side
is \(\sigma^i(z-u)\); the right side is \(\sigma^{j+1}(z-u)\).  Since
\(z-u\ne0\), Lemma 1.1 forces \(i=j+1\), proving (4.2).

Using \(j=i-1\) in the first equality and applying \(\sigma^{1-i}\) gives

\[
\sigma(2u+\sigma v-e_2)=2w+\sigma u-e_2,
\]

which rearranges to (4.3).  Conversely, the first collision follows by
reversing this calculation, and the two sides change by the same vector when
\(u\) is replaced by \(z\) in the indicated squared slot, so the second
collision follows.  ∎

Thus a CAS runner never has to search arbitrary quadruples of slot equations.
It need only enumerate triples \((u,v,w)\) satisfying the single affine parity
condition (4.3), choose \(z\), and inspect the two compiled rows for
cleanliness.

### Lemma 4.2 — polar-determinant certificate

For clean rows (4.1), set

\[
\Delta=\alpha\beta'-\alpha'\beta.
\]

If \(\Delta\ne0\), the two rows have no common zero on the coefficient torus.
Indeed,

\[
\alpha X_u g-\alpha'X_z f
 =\Delta X_uX_zX_w^2.
\tag{4.4}
\]

**Proof.**  The \(X_u^2X_vX_z\) terms cancel, leaving exactly the right side.
It is a nonzero monomial on the torus.  ∎

The atomic squared-slot multiplicities give
\((\alpha,\beta,\alpha',\beta')=(1,1,2,1)\), hence
\(\Delta=-1\).  Formula (4.4) also handles duplicate slot occurrences and
other integer multiplicities without a separate case analysis.

---

## 5. Item 4: binomial coefficient holonomy is completely decidable by SNF

Consider any binomial subsystem over an algebraically closed field of
characteristic zero:

\[
\alpha_eX^{a_e}+\beta_eX^{b_e}=0,
\qquad e\in E,
\]

with \(\alpha_e\beta_e\ne0\).  Put

\[
\delta_e=a_e-b_e\in\mathbf Z^S,
\qquad
\rho_e=-\beta_e/\alpha_e.
\]

### Theorem 5.1 — exact holonomy criterion

The binomial subsystem has a point in \((\mathbf C^*)^S\) if and only if
for every integral relation \((n_e)\) satisfying

\[
\sum_en_e\delta_e=0,
\]

one has

\[
\prod_e\rho_e^{n_e}=1.
\tag{5.1}
\]

**Proof.**  A torus point defines a character
\(x:\mathbf Z^S\to\mathbf C^*\), and the equations say
\(x(\delta_e)=\rho_e\).  Every relation among the \(\delta_e\) therefore
implies (5.1).

Conversely, (5.1) says that \(\delta_e\mapsto\rho_e\) defines a homomorphism
on the subgroup \(D\subseteq\mathbf Z^S\) generated by the \(\delta_e\).
The group \(\mathbf C^*\) is divisible, hence injective as an abelian group,
so the homomorphism extends from \(D\) to \(\mathbf Z^S\).  The resulting
character is the desired torus point.  Equivalently, Smith normal form gives a
constructive extension by taking the necessary roots.  ∎

In the trace formulation, \(\rho_e\in\mathbf Q^*\).  Hence a failed holonomy
cycle is certified by an integer kernel vector and one exact rational product.
No Gröbner basis and no cyclotomic arithmetic are required.

A failed cycle in any binomial subset already certifies nonexistence for the
full support.  If every nonzero row is binomial, the criterion is also a
complete positive/negative decision for that support.

---

## 6. Item 5: minimal cancellation cores and the exact remaining theorem

The preceding steps do **not** by themselves prove that every primitive
support contains a clean polar determinant or a failed binomial cycle.  The
remaining all-degree issue can, however, be isolated sharply.

### Lemma 6.1 — connectedness of a support-minimal zero

Let \(a\) be a Laurent-polynomial zero with inclusion-minimal support \(S\).
Form the bipartite incidence graph whose left vertices are the variables
\(A_s\), whose right vertices are the nonzero output rows \(F_\gamma\), and
where \(A_s\) is joined to \(F_\gamma\) if it occurs in an active coefficient
monomial of that row.  This graph is connected.

**Proof.**  Every support variable occurs: the term with all three coefficient
indices equal to \(s\) contributes a nonzero multiple of \(A_s^3\) to some
row.  If the graph were disconnected, choose one component and retain the
original nonzero coefficients on its variable vertices while setting all
other variables to zero.  Every row lies in one component, since a monomial
containing variables from two components would join them.  Rows in the chosen
component remain zero; every other row becomes identically zero.  This gives a
zero with strictly smaller support, a contradiction.  ∎

### Lemma 6.2 — row circuits cover the support

At a torus zero, every coefficient monomial in a row belongs to an
inclusion-minimal zero-sum subset of that row containing it.  Consequently the
union of row circuits covers every support variable.

**Proof.**  The full finite set of evaluated terms in a row sums to zero.
Among the zero-sum subsets containing a selected term, choose one of minimal
cardinality.  The final assertion follows from the \(A_s^3\) occurrence used
in Lemma 6.1.  ∎

These lemmas reduce a hypothetical counterexample to a connected complex of
minimal row cancellations.  They do not bound the number or size of
multinomial row circuits.

### Coverage Theorem C — the sole all-degree structural gap

A negative proof by polar circuits will follow from the following statement:

> Every connected cancellation core of a primitive support-minimal trace zero
> either (i) has a singleton row, (ii) contains a clean polar pair with nonzero
> determinant, (iii) contains a binomial subsystem with failed holonomy, or
> (iv) admits an explicitly bounded sparse polynomial combination of landing
> rows equal to a nonzero coefficient monomial.

For any finite core, alternatives (i)--(iv) are decidable and have tiny exact
certificates.  What is not yet proved is a uniform bound or a theorem forcing
one of them for arbitrary Laurent support.

This is not merely an omitted large computation.  Unrestricted collision
solutions form affine lattices with lineality, and bounded-degree toric ideals
can have long circuits.  Therefore the earlier suggestion

```text
all Laurent supports -> finite Hilbert basis -> quotient by invariant shifts
```

is invalid without an additional pointed cone or a separate finite-generation
theorem.  Lemma 1.3 separately rules out a nonzero common exponent-translation
gauge.  Normaliz may be used for a fixed polynomial degree or a fixed pointed
support cone, but such calculations are calibration only.

### Conditional negative theorem

Assume Coverage Theorem C.  Then the generic F55 trace cubic has no nonzero
\(K\)-point, and the Klein cubic and its V14 twin are not F55-unirational.

**Proof.**  A rational point gives a primitive support-minimal finite Laurent
zero by Propositions 2.1--2.2.  Its cancellation core is connected by Lemma
6.1.  Coverage Theorem C supplies one of alternatives (i)--(iv).  Each places
a monomial in the localized support ideal: directly for (i), by (4.4) for
(ii), by Theorem 5.1 for (iii), or by the polynomial identity in (iv).  This
contradicts Theorem 3.2.  ∎

---

## 7. Minimized computational DAG

The proof layer leaves only the following finite checks.

### C0 — one exact compiler regression

For a supplied finite support, compile the integer rows of Proposition 3.1 and
compare them with direct Laurent expansion.  This is shared by every later
stage.  It is run once per support, not once per twist.

### C1 — polar determinant and binomial holonomy

Use (4.3) to generate all candidate polar pairs; inspect only the two relevant
rows and compute \(\Delta\).  On the remaining binomial rows, compute one
integer kernel and its rational return products.  Retain only a failed cycle or
a statement that all tested cycles pass.

### C2 — exceptional finite-core saturation

Only if C1 finds neither obstruction, compute
\(I_S:m_S^\infty\).  The retained negative artifact is solely an identity
(3.1), preferably a lower-support monomial consequence.  Modular Gröbner
bases may discover the shape but are not certificates.

### Non-CAS theorem gate

Coverage Theorem C, or a theorem reducing it to finitely many cores, remains a
mathematical task.  A bounded search can falsify proposed bounds and locate the
smallest exceptional core, but it cannot be promoted to an all-degree proof.

This is the smallest honest interface: one compiler, one lattice/holonomy
check, and saturation only on genuine exceptions.

---

## 8. Work-order map

The local-runner instructions are:

```text
WORKORDER_F55_PC1_PRIMITIVE_LAURENT.md
WORKORDER_F55_PC2_TRACE_SUPPORT_COMPILER.md
WORKORDER_F55_PC3_POLAR_EDGE_HOLONOMY.md
WORKORDER_F55_PC4_MINIMAL_CORE_SEARCH.md
WORKORDER_F55_PC5_EXACT_SATURATION_CERTIFICATES.md
```

The research-notebook update is
`NOTEBOOK_F55_POLAR_CIRCUIT_20260808.md`.

Terminal theorem boundary:

```text
F55-PC-PROOF-REDUCTION-COMPLETE
F55-PC-COVERAGE-THEOREM-OPEN
F55-QUESTION-OPEN
```
