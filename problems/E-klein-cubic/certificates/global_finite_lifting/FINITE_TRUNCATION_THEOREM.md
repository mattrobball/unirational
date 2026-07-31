# G1 — Finite truncation of the normal landing expansion

**Headline: OPEN.**  
**Gate G1: PASS.**  
**Path:** Post-Elo Dispatch G (finite global lifting).  
**No formal lift is a covariant** (house rule 3).

---

## Theorem (finite truncation)

Let \(W=E_+\oplus E_-\) with \(\dim E_+=3\), \(\dim E_-=2\), and let
\(Z_t=\mathbf P(E_+)\subset\mathbf P(W)\). Write homogeneous coordinates
\((z,y)\) with \(z\) dual to \(E_+\) and \(y=(y_0,y_1)\) dual to \(E_-\), so that
the saturated homogeneous ideal of the cone on \(Z_t\) is the prime

\[
I_{Z_t}=(y_0,y_1)\subset\mathbf Q[z,y].
\]

Let \(F\in\operatorname{Sym}^3 W^*\) be the Klein cubic (degree \(3\)), and let
\(p:W\to W\) be a **homogeneous polynomial map of degree \(d\ge 1\)** (each
component of \(p\) is a form of degree \(d\)). Set

\[
F(p)\;:=\;F\circ p\;\in\;\operatorname{Sym}^{3d}W^*.
\]

Then \(F(p)\) is a single homogeneous form of degree \(3d\), and

\[
\boxed{
F(p)\in I_{Z_t}^{\,3d+1}
\quad\Longrightarrow\quad
F(p)=0.
}
\]

### Grading (the only place a proof can fail)

Grade \(\mathbf Q[z,y]\) by **total degree** \(\deg(z_i)=\deg(y_j)=1\). Then:

1. \(F\) has degree \(3\), \(p\) has degree \(d\), so \(F(p)\) is homogeneous of
   **total degree \(3d\)**:
   \[
   F(p)\in \mathbf Q[z,y]_{3d}.
   \]
2. The ideal power \(I_{Z_t}^{N}=(y_0,y_1)^{N}\) is spanned by monomials of
   **\(y\)-degree at least \(N\)** (and arbitrary \(z\)-degree).
3. Any homogeneous element of total degree \(3d\) that lies in
   \((y_0,y_1)^{3d+1}\) is a \(\mathbf Q\)-linear combination of monomials
   \(z^\alpha y^\beta\) with \(|\alpha|+|\beta|=3d\) and \(|\beta|\ge 3d+1\).
4. The inequality \(|\beta|\ge 3d+1\) forces \(|\alpha|=3d-|\beta|\le -1\), which is
   impossible. Hence the only such form is \(0\).

Equivalently: the associated graded piece
\(\operatorname{gr}^{N}_{I}(\mathbf Q[z,y])_{3d}\) vanishes for all
\(N>3d\). Membership \(F(p)\in I^{3d+1}\) is membership in the vanishing of
every graded piece of weight \(\le 3d\), so \(F(p)=0\).

### What this is *not*

- It is **not** a claim about infinite formal series in \(y\). A formal series
  \(f=\sum_{N\ge 0}f_N(z,y)\) with \(\deg_y f_N=N\) can vanish to every finite
  order without being zero. The theorem uses **homogeneity of total degree
  \(3d\)**, which formal series lack.
- It is **not** a bound on the normal order of \(p\) itself. The jet \(p_r\) of
  normal order \(r\) in a degree-\(d\) polynomial obeys \(r\le d\) separately
  (same grading: total degree \(d\), \(y\)-degree \(r\)).
- The constant \(3d+1\) is sharp in the graded sense: nonzero forms of degree
  \(3d\) can lie in \(I^{3d}\) (e.g. \(y_0^{3d}\)).

### Normal order = \(y\)-adic order

The normal expansion of a form \(f\) along the involution plus-plane is the
\(y\)-adic expansion

\[
f(z,y)=\sum_{N\ge 0}f_N(z,y),\qquad f_N\in\mathbf Q[z]_{3d-N}\otimes\mathbf Q[y]_N
\]

(when \(f\) has total degree \(3d\)). Thus

\[
f\in I_{Z_t}^{N}
\quad\Longleftrightarrow\quad
f_0=f_1=\cdots=f_{N-1}=0.
\]

The theorem says: if every normal component of \(F(p)\) through order \(3d\)
vanishes, then \(F(p)=0\) identically as a polynomial on \(W\).

### C2-evenness (compatible refinement, not required for the bound)

If \(p\) is covariant for the involution \(t(z,y)=(z,-y)\), then \(F(p)\) is even
in \(y\), so only **even** normal orders of \(F(p)\) can be nonzero. The same
grading bound applies with the weaker hypothesis
\(F(p)\in I^{3d+1}\) (odd orders already vanish). The terminal even order is
\(3d\) when \(3d\) is even and \(3d-1\) when \(3d\) is odd; either way,
vanishing through total degree forces \(F(p)=0\).

---

## Corollaries (required by the work order)

### (1) The lifting tower terminates by normal order \(3d\)

Landing \(F(p)=0\) is equivalent to the vanishing of the finitely many normal
components

\[
\bigl(F(p)\bigr)_{N}=0
\qquad\text{for all }0\le N\le 3d
\]

(with odd \(N\) automatic under \(t\)-covariance). There is no equation at order
\(>3d\).

### (2) No infinite Artin-approximation problem at fixed \(d\)

At fixed global degree \(d\), the unknown is a point of the finite-dimensional
vector space

\[
\operatorname{Hom}\bigl(\operatorname{Sym}^{d}W^*,\,W\bigr)
\]

(or its residual-equivariant / \(G\)-equivariant linear subspace). The landing
locus is cut by finitely many homogeneous equations of degree \(3\) in those
coefficients (the coefficients of \(F(p)\)). Artin approximation along the
normal cone is not needed: the algebraization problem is already algebraic and
finite.

### (3) The true algebraization problem is a finite terminal system

Write the normal expansion of a degree-\(d\) map with first normal order \(m\)
(odd) as

\[
p
=
\sum_{\substack{r\ge m\\r\equiv m\pmod 2}}a_r
+
\sum_{\substack{s\ge m+1\\s\not\equiv m\pmod 2}}b_s,
\]

with \(a_r\) of order \(r\le d\) valued in \(E_-\) and \(b_s\) of order \(s\le d\)
valued in \(E_+\). Each jet lives in a finite multi-Rees piece

\[
a_r\in
\operatorname{Sym}^{d-r}E_+^*
\otimes
\operatorname{Sym}^{r}E_-^*
\otimes E_-,
\qquad
b_s\in
\operatorname{Sym}^{d-s}E_+^*
\otimes
\operatorname{Sym}^{s}E_-^*
\otimes E_+.
\]

The polar equations \((F(p))_N=0\) for even \(N\le 3d\) form a **finite**
polynomial system in these finitely many coefficients. Formal smoothness of the
free polar operators \(L_r\) on an open of leading jets produces formal series
solutions; the finite system is the precise obstruction to those series being
polynomial of degree \(d\).

---

## Gate G1

| check | status |
|-------|--------|
| \(F(p)\) has total degree \(3d\) | PROVED |
| \(I_{Z_t}=(y_0,y_1)\) | PROVED (linear subspace \(E_+\)) |
| \(f\in I^{3d+1}\cap\mathbf Q[z,y]_{3d}\Rightarrow f=0\) | PROVED |
| tower terminates by order \(3d\) | PROVED |
| no infinite Artin problem at fixed \(d\) | PROVED |
| algebraization = finite terminal system | PROVED |

**Gate G1: PASS.** Proceed to G2.

### Failure mode guarded against

A grading mistake that would break the argument is treating \(F(p)\) as having
degree \(d\) (degree of \(p\)) rather than \(3d\), or confusing the \(y\)-adic
order with the multi-Rees base degree. The verifier checks the degree identity
and the graded vanishing on explicit bases.

---

## Files

```text
certificates/global_finite_lifting/FINITE_TRUNCATION_THEOREM.md
certificates/global_finite_lifting/verify_finite_truncation.py
```

### Terminal marker

```text
FINITE_TRUNCATION_G1_PASS
```
