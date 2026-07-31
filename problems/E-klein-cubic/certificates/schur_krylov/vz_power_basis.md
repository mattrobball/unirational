# Task 1 — power-basis expansion of \(V_Z\)

**Packet:** `certificates/schur_krylov/`  
**Date:** 2026-07-31  
**Exit contribution:** `A_EMPTY_UNDECIDED` (coordinates not expanded)  
**Headline:** OPEN  
**Inputs:** sealed A2 `field_algebra.*`, `marked_point.*` (not rebuilt)

---

## 0. Requested object

Exact coordinates of the marked point

\[
z=[z_0:z_1:z_2:z_3]\in\mathbf P^3(L)
\]

with respect to a generic power basis \(1,\tau,\tau^2,\ldots,\tau^{54}\) of
\(L/F\), or equivalently a \(4\times 55\) matrix \((a_{ik})\) over \(F\) with

\[
z_i=\sum_{k=0}^{54}a_{ik}\,\alpha^k,\qquad
V_Z=\operatorname{span}_F(z_0,z_1,z_2,z_3),
\]

where \(\alpha\) is a fixed monogenic generator of \(L/F\) as in
`field_algebra.md`.

---

## 1. Verdict: expansion **not available** from sealed A2 data

| Requested | Status |
|---|---|
| Coefficients \(a_{ik}\in F=K_{\mathrm{Schur}}\) as explicit elements of \(\mathbf C(\mathbf P(V_6))^G\) | **not produced** |
| Minimal polynomial \(\mu\in F[t]\) with expanded coefficients in \(F\) | **not produced** (already recorded as open in `field_algebra.json`) |
| A single numerical \(4\times 55\) matrix over \(\mathbf Q\) advertised as generic \(V_Z\) | **forbidden** (would violate char-0 / genericity house rules) |

The sealed A2 interfaces deliberately stop at the **abstract** monogenic
presentation and the **geometric** construction of \(z\in\mathbf P^3(L)\).
Both JSON seals set

```text
mu_coefficients_expanded_in_invariants: false
coordinates.expanded_coefficients_in_F: false
```

Rebuilding a different algebra or substituting a fibre model for the generic
point is out of scope for this task (director: use sealed A2 artifacts; do not
rebuild a different algebra).

---

## 2. Why the expansion is blocked (precise obstruction)

To expand \(z_i\) in a power basis of \(L/F\) one must exhibit **all** of:

1. **Model of \(F\).**  Generators and relations for
   \(F=K_{\mathrm{Schur}}=\mathbf C(\mathbf P(V_6))^G\), or an equivalent
   birational model of the invariant field (Molien / primary+secondary
   invariants for \(G=\mathrm{PSL}_2(\mathbf F_{11})\) on \(V_6\)).
2. **Model of \(L=E^H\).**  Generators for the \(H=D_{12}\)-invariants on
   \(\mathbf P(V_6)\), or a primitive element \(\alpha\in E^H\) with
   explicit minimal polynomial \(\mu\in F[t]\).
3. **Torsor-dependent hyperplane.**  The good hyperplane
   \(M\simeq\mathbf P^3_F\) of `marked_point.md` §1.2, as an \(F\)-point of
   the \(G\)-stable open \(\mathcal U\subset\mathbf P(W^\vee)\).
4. **Twisted line intersection.**  Coordinates of
   \({}^T U_-\cap M_L\) as elements of \(L\), then reduction to the four
   \(M\)-coordinates \(z_i\).

Steps 1–2 are a classical invariant-theory computation for \(G\) on \(V_6\)
that the repository has **not** sealed.  Steps 3–4 depend on that model.
Nothing in the sealed A2 packet, the fibre witness, or the strata packet
supplies the missing invariant-field generators.

**This is the specific gap named by the director:** abstract \(V_Z\) and its
Hilbert function are sealed; expanded generic power-basis coordinates are
not.  Closing the gap is a genuine invariant-field problem, not a
rearrangement of existing certificates.

---

## 3. Weaker data that **is** available (and sealed)

### 3.1 Abstract \(F\)-linear data

| Item | Value | Source |
|---|---|---|
| \([L:F]\) | 55 | \(G/H\), `field_algebra` |
| Monogenic form | \(L=F[t]/(\mu)\), \(\deg\mu=55\) | `field_algebra` |
| Multiplication API | companion \(C_\mu\) and \(M_\xi=\sum x_k C_\mu^k\) | `field_algebra` |
| \(\dim_F V_Z\) | 4 | \(H_Z(1)=4\), `marked_point` |
| Hilbert function of \(Z\) | \((1,4,10,19,31,45,55,55,\ldots)\) | `marked_point` |
| \(\operatorname{Aut}(L/F)\) | 1 | \(N_G(H)=H\) |
| Intermediate fields of \(L/F\) | none (degrees 5,11 absent) | \(H\) maximal |

### 3.2 Geometric construction (not expanded)

\[
z
=
\text{unique point of }
{}^T\ell\cap M_L
\subset
X_T(L)\cap M(L),
\]

with \({}^T\ell=\mathbf P({}^T U_-)\) the twisted \(D_{12}\)-line and \(M\) the
torsor-dependent hyperplane (`marked_point.md` §1).  Each \(z_i\in L\) exists
uniquely up to \(L^\times\)-scaling of the homogeneous 4-tuple; \(V_Z\) is
scaling-invariant.

### 3.3 Geometric base-change picture (orbit code input)

After extension to a splitting field of \(\mu\),

\[
L\otimes_F\overline F
\;\simeq\;
\prod_{gH\in G/H}\overline F
\]

as \(\overline F\)-algebras, and as a \(G\)-representation the underlying
vector space is the permutation module \(\overline F[G/H]\).  Under this
identification, \(V_Z\otimes\overline F\) is the image of the evaluation map

\[
H^0\bigl(M_{\overline F},\mathcal O(1)\bigr)
\longrightarrow
\bigoplus_{p\in Z(\overline F)}\overline F
\;\simeq\;
\overline F^{55},
\]

which is injective of rank 4 by \(H_Z(1)=4\).  Columns of the resulting
\(4\times 55\) matrix are homogeneous coordinates of the 55 geometric points
of the Galois orbit of \(Z\).  Those points lie on the cubic surface
\(X_T\cap M\).

This describes \(V_Z\) as a **Galois-stable 4-plane in the permutation
module** with support the full \(G/H\)-orbit.  It does **not** produce
\(F\)-coordinates in a power basis.

### 3.4 Fibre witness (shape only — not generic)

Constant hyperplane \((1,1,1,2,7)\) on the certified \(D_{12}\)-line over
\(\mathbf Q(\zeta_{11})\):

| Check | Result |
|---|---|
| on hyperplane | yes |
| on Klein cubic | yes |
| \(\operatorname{rank}_{\mathbf Q}\) of four \(\mathbf P^3\) coordinates | 4 |

Data: `tmp/pathA_krylov/fibre_marked_point.json`, `d12_line_basis.json`.  
**House rule.**  Fibre \(\neq\) generic Schur point over \(F\).  Not a
substitute for §0.

---

## 4. What would count as closing Task 1

Any one of the following, sealed with independent verifier:

1. Explicit generators of \(F\) and of \(L/F\) with \(\mu\in F[t]\) expanded,
   and a \(4\times 55\) matrix \((a_{ik})\) over that model with
   \(f_3(z)=0\) and \(H_Z(1)=4\) checks; or
2. A birational \(F\)-model in which the power-basis matrix of \(V_Z\) is
   written in closed form (e.g. as invariants of the twisted line), with the
   same checks; or
3. A theorem that identifies \(V_Z\) with a **named** \(F\)-subspace of the
   permutation module (e.g. a specific isotypic projection after descent)
   strongly enough that all Krylov ranks are determined without expanding
   coefficients.

None of (1)–(3) is available in the repository at this pin.

---

## 5. Terminal marker

```text
SCHUR_KRYLOV_VZ_POWER_BASIS_NOT_EXPANDED
```
