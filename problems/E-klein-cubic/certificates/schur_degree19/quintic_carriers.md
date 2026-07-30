# Special quintic carriers — Attempt 3, Task 3C.3

**Date:** 2026-07-30  
**Branch:** \(\varepsilon=1\) (unique quintic through the selected point)  
**Also records:** liaison control for both branches  
**Headline:** OPEN

---

## 0. Setup

Let \(Y=V(f_3,f_5)\subset M\simeq\mathbf P^3_F\) be the fixed \((3,5)\) complete
intersection for a hyperplane choice with smooth integral \(Y\) (accepted:
degree 15, genus 31; characteristic-zero smoothness of the rank-witness
section, and openness for the descended choice).

\[
H^0(I_Y(5))=f_3 S_2\oplus\langle f_5\rangle,
\qquad
\dim = 10+1=11,
\qquad
\mathbf P H^0(I_Y(5))\simeq\mathbf P^{10}_F.
\]

The \(\varepsilon=1\) branch forces the unique quintic equation of \(C\) to be

\[
F_q=f_5+f_3 q,\qquad q\in S_2,
\]

i.e. the standard affine chart of \(\mathbf P^{10}\) with nonzero
\(f_5\)-coefficient.  Write

\[
S_q \;:=\; V(F_q)\subset M.
\]

---

## 1. Classification of carriers containing \(Y\)

Every quintic surface containing \(Y\) is \(V(\alpha f_5+f_3 q)\) for
\((\alpha:q)\in\mathbf P(F\oplus S_2)\).

| Chart | Equation | Notes |
|---|---|---|
| \(\alpha\neq0\) | \(f_5+f_3 q\) after scaling | the \(\varepsilon=1\) carrier family; dim 10 |
| \(\alpha=0\) | \(f_3 q=0\) | reducible: \(V(f_3)\cup V(q)\); not a prime quintic equation for an integral curve with \(f_3\notin I_C\) |

So the only carriers relevant to an integral proper curve with
\(\dim I_C(5)=1\) are the irreducible members of the \(\alpha\neq0\) chart
(and those \(q\) for which \(F_q\) is irreducible / \(S_q\) is integral).

### Scheme identity on every carrier

\[
V_{S_q}(f_3)=V(f_3,f_5)=Y,
\qquad
Y\sim 3H
\text{ on }S_q
\]

whenever \(S_q\) is a surface on which \(H\) is the hyperplane class.  In
particular \(Y\) contributes **no** Picard class independent of \(H\): any
class group computation must find other curves if \(\operatorname{Pic}\) is
to exceed \(\mathbf Z H\).

---

## 2. Picard / class groups in the marked family

### Conditional obstruction

If \(\operatorname{Pic}(S_q)=\mathbf Z H\), then for every curve \(C\subset S_q\),

\[
\deg C = C\cdot H \in 5\mathbf Z
\]

because \(H^2=5\).  Degree 19 is impossible.  **Conditional exclusion of the
\(\varepsilon=1\) branch for those \(q\) with Picard rank one.**

### Why the standard theorem does not apply

The base-locus Noether–Lefschetz theorem of Lopez / Brevik–Nollet (IMRN 2011,
Thm 1.1 / Cor 1.3) requires global generation of \(\mathcal I_Y(4)\) for
quintic surfaces with base curve \(Y\).  Here

\[
H^0(\mathcal I_Y(4))=f_3 S_1,
\]

and at the explicit point

\[
p=[0:-2:0:1:0]
\]

on the rank-witness hyperplane one has \(f_3(p)=0\), \(f_5(p)=-8\), so
\(p\notin Y\) while every section of \(\mathcal I_Y(4)\) vanishes at \(p\).
Global generation fails.  The standard theorem **cannot be invoked**.

### Why a very-general theorem would not finish the branch

Even a theorem proving \(\operatorname{Pic}(S_q)=\mathbf Z H\) for very
general \(q\) would only force a qualifying carrier into a proper
Noether–Lefschetz locus inside the 10-dimensional \(q\)-family.  The carrier
is selected by the unknown curve \(C\) and may be special.  An all-\(q\)
Picard statement, a classification of the NL locus with an independent
degree-19 obstruction on it, or an actual curve is required.

### What is known about special members

| \(q\) | Picard / geometry | Degree-19 possible? |
|---|---|---|
| very general (if NL applied) | expected \(\mathbf Z H\) | no — but theorem unavailable |
| special NL | \(\operatorname{Pic}\) rank \(\ge2\) | possibly yes |
| singular \(S_q\) | class group may be larger; curve may pass through singularities | possibly yes; purity/properness must be re-checked |
| reducible \(F_q\) | not a prime quintic carrier for integral \(C\) | no for \(\varepsilon=1\) as defined |

**No complete classification of \(\operatorname{Pic}(S_q)\) or
\(\operatorname{Cl}(S_q)\) in the marked family is obtained.**  The family is
recorded with its exact linear structure and the conditional rank-one
obstruction.

---

## 3. Degree-19, genus-0 divisors on carriers

On a fixed integral \(S_q\), a divisor of degree 19 and arithmetic genus 0 is
a curve \(C\subset S_q\) with

\[
C\cdot H=19,
\qquad
p_a(C)=0.
\]

By adjunction on a quintic surface (\(K_{S}=H\) for a smooth quintic in
\(\mathbf P^3\)):

\[
2p_a(C)-2 = C\cdot(C+K_S)=C^2+C\cdot H,
\]

so \(p_a=0\) forces

\[
C^2+19=-2,
\qquad C^2=-21.
\]

Existence of a class \(C\in\operatorname{Pic}(S_q)\) with
\(C\cdot H=19\) and \(C^2=-21\) is a lattice-theoretic condition on
\(\operatorname{Pic}(S_q)\).  For \(\operatorname{Pic}=\mathbf Z H\) no such
class exists.  For rank \(\ge2\), the condition is nontrivial and not
decided without the lattice.

**Smooth rational** additionally requires geometric genus 0 and smoothness,
i.e. the class is represented by a smooth rational curve.

---

## 4. Liaison — only with residual control

### Setup

If \(C\subset S_q\) and an independent surface \(S'\) of degree \(s\) cuts a
complete-intersection residual \(C'\) with \(C\cup C'=S_q\cap S'\), then

\[
\deg C'=5s-19,
\qquad
p_a(C)-p_a(C')=\frac{5+s-4}{2}\bigl(\deg C-\deg C'\bigr).
\]

With \(p_a(C)=0\):

| \(s\) | \(\deg C'\) | \(p_a(C')\) | Reduced connected residual? |
|---|---|---|---|
| 6 | 11 | \(-28\) | **no** |
| 7 | 16 | \(-12\) | **no** |
| 8 | 21 | 9 | possible |
| 9 | 26 | 35 | possible |
| 10 | 31 | 66 | possible |

### Residual control (binding)

1. **Negative \(p_a(C')\)** excludes a reduced connected residual.  Allowed
   residuals of negative arithmetic genus include: disconnected unions of
   smooth curves; nonreduced structures; curves with embedded points (if
   not required to be lcm).  None of these is excluded by the genus number
   alone.
2. **Existence of \(S'\)** is not free: \(S'\) must be independent of \(S_q\)
   and the link must be proper.  For \(\varepsilon=0\) there is no quintic
   carrier, so a first carrier has degree \(\ge6\) and the liaison table
   shifts.
3. **Disconnected residual** of degree 11 and \(p_a=-28\) could in principle
   be a union of rational curves with excess intersections; controlling it
   requires a separate analysis not carried out here.
4. Therefore liaison **constrains** low-degree second carriers but **does
   not exclude** the \(\varepsilon=1\) branch.

---

## 5. Interaction with the no-quintic branch

Branch \(\varepsilon=0\) has no quintic carrier.  Quintic Picard theory is
silent on it.  The first possible surface carrier has degree \(\ge6\).
Liaison starting from a sextic carrier through a degree-19 curve has residual
degree \(6s-19\), a different table; the same residual-control house rule
applies.

---

## 6. Theorem boundary

| Proved | Not proved |
|---|---|
| unique carrier form \(F_q=f_5+f_3 q\) for \(\varepsilon=1\) | \(\operatorname{Pic}(S_q)\) for general or special \(q\) |
| \(Y\sim 3H\) on every such carrier | emptiness of degree-19 genus-0 classes |
| failure of Brevik–Nollet / Lopez hypothesis | all-\(q\) Picard rank one |
| liaison genera for \((5,s)\) | exclusion of disconnected/nonreduced residuals |
| conditional: Pic rank one \(\Rightarrow\) no degree 19 | that every special carrier has rank one |

**Decision contribution:** the \(\varepsilon=1\) branch is **not closed**.
Special quintic carriers remain a live geometric locus for a degree-19
genus-0 divisor, subject to Picard lattice constraints not fully evaluated.

Terminal marker:

```text
SCHUR_DEGREE19_QUINTIC_CARRIERS_CLASSIFIED
```
