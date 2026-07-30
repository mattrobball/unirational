# Gate A1 — \(\mathbf P^1\) reduction for qualifying degree-19 curves

**Date:** 2026-07-30  
**Packet:** `certificates/schur_krylov/`  
**Path:** A (Schur–Krylov rational parametrization)  
**Gate:** A1  
**Decision:** `A1-PASS`  
**Headline:** OPEN (no curve constructed; reduction only)  
**Pinned base:** `89c27e2`

---

## 0. Statement

Let

\[
F=K_{\mathrm{Schur}}=\mathbf C\bigl(\mathbf P(V_6)\bigr)^G,
\]

let \(Z\subset X_T\) be the exact degree-55 closed point on the generic Schur
twist, and let \(C\subset\mathbf P(W_T)\) (or, after the accepted
torsor-dependent hyperplane choice, \(C\subset M\simeq\mathbf P^3_F\)) be a
**qualifying** geometrically integral curve with Hilbert polynomial

\[
p_C(t)=19t+1.
\]

Then

\[
C(F)\neq\varnothing
\qquad\text{and}\qquad
C\simeq\mathbf P^1_F.
\]

In particular every qualifying degree-19 curve is an \(F\)-rational normal
parametrized curve of degree 19, and the Krylov incidence of Gate A3 is an
exhaustive search for such curves through \(Z\).

**Hard prerequisite.**  No Krylov parametrization, interpolation, or incidence
solve is used in this note.  The argument is pure curve arithmetic over \(F\).

---

## 1. Inputs used (no re-derivation)

| Fact | Source | Role |
|---|---|---|
| Qualifying \(\Rightarrow\) geometrically integral of degree 19 | `certificates/schur_degree19/IMPLICATION_AUDIT.md` Q6; `tmp/schur_degree19_structural_design` component theorem | geometric integrality of \(C\) |
| Hilbert polynomial \(19t+1\) | marked Hilbert packet | \(\deg C=19\), \(p_a(C)=0\) |
| \(Z\) is a closed point of residue degree 55 on \(C\) | qualifying Q5 + degree-55 point existence | index divides 55 |
| \(\operatorname{char} F=0\) | \(F\subset\mathbf C(Y)\) | separability / classical genus theory |

The implication audit (Gate 1 of Attempt 3) is **not** re-proved here.  This
gate only reduces the search for qualifying curves to maps
\(\mathbf P^1_F\to\mathbf P^3_F\).

---

## 2. Step 1 — arithmetic genus zero and geometric integrality imply smooth genus zero

### Setup

Let \(C/F\) be a projective, geometrically integral curve with Hilbert
polynomial \(19t+1\).  Writing the Hilbert polynomial of a pure
one-dimensional subscheme of \(\mathbf P^n\) as

\[
p_C(t)=\deg(C)\,t+\bigl(1-p_a(C)\bigr),
\]

one reads

\[
\deg C=19,\qquad p_a(C)=0.
\]

(The same numerical conclusion holds in \(\mathbf P^3\) or \(\mathbf P^4\).)

### Geometric integrality and base change

Geometric integrality means \(C_{\overline F}\) is integral (reduced and
irreducible).  Arithmetic genus is preserved by field extension:

\[
p_a\bigl(C_{\overline F}\bigr)=p_a(C)=0.
\]

### Singularities would raise arithmetic genus

Let \(\nu:\widetilde C\to C_{\overline F}\) be the normalization of the
integral projective curve \(C_{\overline F}\).  Write \(g=\mathrm{g}(\widetilde C)\)
for the geometric genus of the smooth projective model.  For each singular
point \(p\) of \(C_{\overline F}\) the \(\delta\)-invariant satisfies
\(\delta_p\ge 1\), and the arithmetic genus formula for integral curves
reads

\[
p_a\bigl(C_{\overline F}\bigr)
=
g+\sum_{p}\delta_p.
\]

(Reference form: Hartshorne IV, Ex. 1.8; equivalently the conductor exact
sequence \(0\to\mathcal O_C\to\nu_*\mathcal O_{\widetilde C}\to\mathcal Q\to 0\)
with \(\operatorname{length}\mathcal Q=\sum\delta_p\).)

Both \(g\) and every \(\delta_p\) are non-negative integers.  Therefore

\[
p_a\bigl(C_{\overline F}\bigr)=0
\quad\Longrightarrow\quad
g=0
\quad\text{and}\quad
\sum_p\delta_p=0
\quad\Longrightarrow\quad
\text{every }\delta_p=0.
\]

Hence \(C_{\overline F}\) is smooth, and \(\widetilde C=C_{\overline F}\) is a
smooth projective curve of genus 0 over \(\overline F\).

### Conclusion of Step 1

\[
C_{\overline F}\simeq\mathbf P^1_{\overline F}
\quad\text{as }\overline F\text{-schemes (after choosing any }\overline F\text{-point)}.
\]

More invariantly: \(C\) is a smooth genus-zero curve over \(F\) (a conic /
Severi–Brauer curve of dimension one).  Smoothness over \(F\) follows from
geometric smoothness in characteristic zero (the singular locus would base
change nontrivially).

**No loophole at singularities.**  A geometrically integral curve with
\(p_a=0\) cannot be singular: every singularity contributes a positive
\(\delta\)-invariant and would force \(p_a\ge 1\).

---

## 3. Step 2 — the degree-55 point forces \(\operatorname{index}(C)\mid 55\)

### Index

For a geometrically integral variety \(V\) over a field \(K\), the **index**
is

\[
\operatorname{index}(V)
:=
\gcd\bigl\{\,[L:K]\;:\; V(L)\neq\varnothing\,\bigr\}
=
\gcd\bigl\{\deg Z\;:\; Z\subset V\text{ closed point}\,\bigr\}.
\]

(The two descriptions agree for proper geometrically integral varieties over
a field: a closed point of degree \(d\) is a point over a degree-\(d\)
extension, and conversely a point over a finite extension yields a closed
point of degree dividing that extension degree; taking gcds coincides.)

### Application

The support of the degree-55 closed point \(Z\) lies on \(C\) by the
qualifying hypothesis (multiplicity one at each geometric point of the orbit
is stronger than needed here; containment of the closed point as a
subscheme of \(C\) is enough).  Therefore \(C\) has a closed point of degree
55, and

\[
\operatorname{index}(C)\;\Bigm|\; 55.
\]

Factorization: \(55=5\cdot 11\), so

\[
\operatorname{index}(C)\in\{1,5,11,55\}.
\]

---

## 4. Step 3 — a genus-zero curve has index \(1\) or \(2\)

### Classification

A smooth projective genus-zero curve \(C\) over a field \(K\) of
characteristic not 2 is \(K\)-isomorphic to a plane conic (the anticanonical
embedding by \(|-K_C|=\mathcal O(2)\) on \(\mathbf P^1\) after splitting, or
equivalently the Severi–Brauer variety of a quaternion algebra over \(K\)).
In particular \(C\) is a twisted form of \(\mathbf P^1\).

### Quadratic splitting

Any smooth plane conic over \(K\) acquires a rational point over some
separable extension of degree at most 2:

- if the conic already has a \(K\)-point, degree 1;
- otherwise the binary quadratic form (or the reduced norm of the
  quaternion algebra) has a zero over a quadratic extension.

Hence there exists \(L/K\) with \([L:K]\le 2\) and \(C(L)\neq\varnothing\), so

\[
\operatorname{index}(C)\;\Bigm|\; 2.
\]

Possible values: \(\operatorname{index}(C)\in\{1,2\}\).

### Elementary form without quaternion algebras

Embed \(C_{\overline K}\simeq\mathbf P^1_{\overline K}\).  The Galois cocycle
takes values in \(\operatorname{PGL}_2\).  The connecting map

\[
H^1\bigl(K,\operatorname{PGL}_2\bigr)\longrightarrow\operatorname{Br}(K)[2]
\]

lands in 2-torsion.  Period equals index for Severi–Brauer varieties of
dimension one, and both divide 2.  Same conclusion.

**No loophole at index 5 or 11.**  Genus zero forbids every odd index
strictly larger than 1.

---

## 5. Step 4 — the odd-index step (the whole content of the reduction)

### Arithmetic

From Steps 2 and 3,

\[
\operatorname{index}(C)\;\Bigm|\; 55
\qquad\text{and}\qquad
\operatorname{index}(C)\;\Bigm|\; 2.
\]

Therefore

\[
\operatorname{index}(C)
\;\Bigm|\;
\gcd(55,2).
\]

Now \(55\) is **odd**:

\[
55=2\cdot 27+1,\qquad \gcd(55,2)=1.
\]

Hence

\[
\operatorname{index}(C)=1.
\]

### Rational point and isomorphism with \(\mathbf P^1\)

Index one means \(C\) has a closed point of degree 1, i.e.

\[
C(F)\neq\varnothing.
\]

A smooth genus-zero curve with an \(F\)-point is \(F\)-isomorphic to
\(\mathbf P^1_F\): choose the point as \(\infty\), and the complete linear
system of \(\mathcal O(1)\) (or any degree-one divisor class, unique up to
linear equivalence on a genus-zero curve with a rational point) gives the
isomorphism.

### Explicit odd-index checklist

```text
[x] index(C) divides 55          (degree-55 closed point on C)
[x] index(C) divides 2           (genus-zero / conic)
[x] 55 is odd, so gcd(55,2) = 1
[x] therefore index(C) = 1
[x] therefore C(F) nonempty
[x] therefore C ≅ P^1_F
```

This step is the entire content of the reduction.  If the marked point had
even degree, index 2 could survive and \(C\) could be a pointless conic; the
oddness of 55 kills that possibility.

---

## 6. Boundary and non-claims

| Claimed | Not claimed |
|---|---|
| Every qualifying \(C\) with \(p_C=19t+1\) is \(F\)-isomorphic to \(\mathbf P^1\) | Existence of any qualifying \(C\) |
| Krylov search is exhaustive among qualifying degree-19 curves | Exhaustiveness among all curves of all degrees |
| Smoothness of \(C\) over \(F\) | ACM, carrier quintic, or Rao vanishing |
| Index arithmetic uses only 55 and genus zero | A point of \(X_T(F)\) (that needs a constructed curve) |

**Singular loophole status:** closed by Step 1 (\(\delta\)-formula).  
**Even-index loophole status:** closed by Step 4 (55 odd).  
**Geometric-integrality loophole status:** closed by the accepted component
theorem for qualifying curves (input, not re-proved).

### Gate A1 exit

**`A1-PASS`.**  Proceed to Gate A2.  No singular or index loophole remains
inside the qualifying hypotheses.

---

## 7. Independent verification

```bash
/opt/homebrew/bin/python3 -u certificates/schur_krylov/verify_p1_reduction.py
```

Expected markers:

```text
A1_P1_REDUCTION_ARITHMETIC_OK
A1_P1_REDUCTION_PASS
HEADLINE_OPEN
```

The verifier does not import any producer.  It rechecks the integer
arithmetic \(\gcd(55,2)=1\), the Hilbert-polynomial dictionary
\((d,p_a)=(19,0)\), the index candidate sets, and the presence of the
odd-index checklist in this document.

---

## 8. Terminal marker

```text
SCHUR_KRYLOV_A1_P1_REDUCTION_PASS_HEADLINE_OPEN
```
