# Path A cycle 2 — structural collapse of the Krylov incidence

**Date:** 2026-07-30  
**Packet:** `certificates/schur_krylov/`  
**Gate:** A3 successor (variable collapse under the 8 GiB exploratory gate)  
**Base pin:** `e050464`  
**Headline:** OPEN  
**Decision exit:** `A-STOP` (refined)

---

## 0. Mission and bound

The previous cycle sealed Gates A1–A2 and formulated the Krylov incidence

\[
\mathcal K
=
\bigl\{
(\tau,\lambda)\in L\times L^\times
:
\lambda\,V_Z\subseteq U_\tau
\bigr\},
\]

then stopped: after linear elimination of the 80 interpolating coefficients the
dense residual in the \(\tau\)-coordinates exceeds 8 GiB.

**Binding rule.**  A job larger than 8 GiB is not authorised.  The task is to
make the computation smaller by a **lossless** structural collapse — one that
discards no qualifying \((\tau,\lambda)\) — or to state precisely that no such
collapse exists and record the minimal irreducible system.

This note audits the four candidate collapses, measures the residual after
every lossless reduction, and seals the exit.

---

## 1. Reformulation used throughout

Identify \(L\simeq\mathbf A^{55}_F\) via the sealed power basis of
`field_algebra.md`.  For primitive \(\tau\) one has \(\dim_F U_\tau=20\).
Containment \(\lambda V_Z\subseteq U_\tau\) is equivalent to nontriviality of

\[
\ker\varphi_\tau,
\qquad
\varphi_\tau\colon L\to(L/U_\tau)^4,
\quad
\lambda\mapsto\bigl(\pi_\tau(\lambda z_0),\ldots,\pi_\tau(\lambda z_3)\bigr),
\]

i.e. \(\operatorname{rank}\varphi_\tau\le 54\) for the structured
\(140\times 55\) matrix of \(\varphi_\tau\) over \(F\).

The 80 coefficients \(c_{jk}\) and the 55 coordinates of \(\lambda\) enter
**linearly** once \(\tau\) is fixed.  They are eliminated by linear algebra
over the function field of the \(\tau\)-space (Cramer / Schur complement on
the \(220\times 135\) block \(A(\tau)\), or directly as \(\ker\varphi_\tau\)).
The nonlinear residual is therefore an ideal in the \(\tau\)-coordinates
alone; \(\lambda\) and \(c\) are reconstructed on the open where the kernel
is nonzero.

**Entry degrees.**  In the power basis of a fixed monogenic generator, the
coordinates of \(\tau^k\) are polynomials of degree \(k\) in the coordinates
of \(\tau\).  Columns of the Krylov block therefore have degree \(\le 19\).
Maximal minors of \(\varphi_\tau\) consequently have degree far above 3
(crude bound \(\le 55\cdot 19=1045\) on a \(55\times 55\) minor; even a
structured \(20\times 20\) block is degree \(\le 380\)).

---

## 2. Candidate 1 — \(\mathrm{PGL}_2\) gauge (lossless, insufficient)

### Action

Domain automorphisms \(\varphi\in\operatorname{PGL}_2(F)\) act by
\(\tau\mapsto\varphi(\tau)=(a\tau+b)/(c\tau+d)\) and reparametrise the same
rational curve.  The incidence \(\mathcal K\) is stable under this action up
to a compensating change of \(\lambda\) and of the interpolating forms
(explicitly: \(U_{\tau^{-1}}=\tau^{-19}U_\tau\), so
\((\tau,\lambda)\in\mathcal K\) iff
\((\tau^{-1},\tau^{-19}\lambda)\) satisfies the transformed containment;
translations and dilations preserve \(U_\tau\) outright).

### Gauge slice (full rigidification)

On the dense open of primitive \(\tau\) with trivial \(\mathrm{PGL}_2\)-stabiliser,
impose the three independent conditions

\[
\operatorname{Tr}_{L/F}(\tau)=0,
\qquad
\operatorname{Tr}_{L/F}(\tau^2)=s_2^{\mathrm{norm}},
\qquad
\text{one further normaliser for inversion}
\]

(e.g. a fixed value of a non-constant \(\mathrm{PGL}_2\)-semi-invariant, or the
classical monic-trace-zero-plus-second-moment slice of the binary form of the
minimal polynomial).  Residual projective scaling of \(\lambda\) is absorbed
by working projectively in \(\mathbf P(L)\) or by the chart \(\lambda_0=1\).

### Losslessness

Every \(\mathrm{PGL}_2(F)\)-orbit of a primitive incidence point meets the
gauge slice in a nonempty finite set (generically once after full
rigidification).  No qualifying curve is discarded: each curve still
contributes at least one gauged representative.

### Residual after this collapse

| Quantity | Before gauge | After full \(\mathrm{PGL}_2\) |
|---|---:|---:|
| Nonlinear variables (\(\tau\)) | 55 | **52** |
| Linear unknowns \((c,\lambda)\) | 135 | 135 (unchanged; eliminated after) |
| Dense Macaulay \(D=2\) (qq, 32 B/entry est.) | \(\sim 0.08\) GiB | \(\sim 0.06\) GiB |
| Dense Macaulay \(D=3\) | \(\sim 28.4\) GiB | \(\sim 20.5\) GiB |
| Dense Macaulay \(D\ge 4\) | \(\gg 8\) GiB | \(\gg 8\) GiB |

The residual equations have degree \(\gg 3\) (§1).  Already the \(D=3\)
Macaulay matrix at \(n=52\) is \(\sim 20.5\) GiB in the 32-byte exact
estimate and is **over** the 8 GiB gate; the true residual degree makes the
gap worse by many orders of magnitude.

**Verdict.**  Lossless and mandatory, but **not enough**.

---

## 3. Candidate 2 — isotypic / \(S_3\)–\(D_{12}\) block reduction (no \(F\)-lossless collapse)

### What the geometry supplies

1. \(H=D_{12}\) is the full stabiliser of the certified line; \(|G:H|=55\).
2. Upstream maximality of \(H\) in \(G\) (certified by transporter generation
   on the line orbit and by the component theorem of
   `tmp/schur_degree19_structural_design`) implies there is **no** subgroup
   strictly between \(H\) and \(G\).
3. Therefore the only fields \(F\subseteq K\subseteq L=E^H\) are \(K=F\) and
   \(K=L\): **no intermediate field of degree 5 or 11**.  (Lagrange would
   allow degrees in \(\{1,5,11,55\}\); maximality removes 5 and 11.)
4. \(\operatorname{Aut}(L/F)=N_G(H)/H=1\): no nontrivial \(F\)-automorphism
   of \(L\).
5. The \(H\)-subdegrees on \(G/H\) are \(1,3,3,6,6,6,6,12,12\).  These are
   geometric orbit sizes after base change, not an \(F\)-rational splitting
   of the \(F\)-vector space \(L\).
6. Residual \(S_3\subset\operatorname{PGL}(E_+)\) appears in the
   stabilizer-normal-cone machine for plane jets; it does **not** act
   \(F\)-linearly on \(L=E^H\).

### Why this does not block-diagonalise the residual over \(F\)

An isotypic decomposition of the residual ideal over \(F\) would require
either

- an \(F\)-algebra decomposition \(L\simeq\prod L_i\) (ruled out: \(L\) is a
  field), or
- an \(F\)-linear action of a finite group on the ambient of \(\varphi_\tau\)
  commuting with the equations and splitting them into independent blocks
  whose vanishing is equivalent to \(\operatorname{rank}\varphi_\tau\le 54\).

Neither structure exists over \(F\):

- After base change to a splitting field, \(L\otimes_F\overline F\simeq
  \overline F^{55}\) and the 55 geometric points carry the permutation
  representation \(\operatorname{Ind}_H^G\mathbf 1\), which does decompose
  into \(G\)-isotypics.  That decomposition is Galois-equivariant, but the
  residual ideal of \(\mathcal K\) is already defined over \(F\); writing it
  as a product of ideals in geometric coordinates does not reduce the number
  of **\(F\)-rational** nonlinear variables below the gauge count of §2.
- The \(H\)-orbit partition of the 55 cosets is not a partition of an
  \(F\)-basis of \(L\) into independent \(F\)-subspaces preserved by
  multiplication by a variable \(\tau\in L\).  Krylov spaces \(U_\tau\) mix
  the geometric coordinates.

**Verdict.**  No lossless \(F\)-rational isotypic block reduction of the
elimination ideal exists from the residual \(S_3\)/\(D_{12}\) structure.
Geometric block structure may still aid **fibre discovery** after base
change; it does not cut the generic residual under 8 GiB.

---

## 4. Candidate 3 — elimination order / sparse Schur complement (evaluation cheap, symbolic residual not)

The matrix \(\varphi_\tau\) is structured (multiplication operators commuting
with the algebra structure; Krylov columns).  Structured rank tests at a
**specialised** \(\tau\) are cheap: a single \(140\times 55\) exact rank over
a finite field is well under 8 GiB (modular discovery in
`tmp/pathA_collapse/modular_rank_profile.py`).

Keeping the Schur complement sparse does **not** reduce the number of
symbolic generators' ambient dimension.  Expanding even one maximal minor as
a polynomial in 52 gauge-fixed coordinates produces

\[
\binom{52+d}{d}
\]

monomials at degree \(d\); already for \(d=20\) this is \(\sim 3\cdot 10^{17}\)
terms.  Sparse storage of the unexpanded structured matrix is small; the
**elimination ideal** that must be decided is not.

**Verdict.**  Order and sparsity are mandatory engineering, not a variable
collapse.  Pointwise rank is authorised for discovery; symbolic residual
generation remains over gate.

---

## 5. Candidate 4 — specialising \(\lambda\) (only \(F^\times\)-scaling is lossless)

| Specialisation | Lossless? | Reason |
|---|---|---|
| \(\lambda\sim a\lambda\) for \(a\in F^\times\) (charts \(\lambda_i=1\), or \(\operatorname{Norm}(\lambda)=1\)) | **yes** | projective nature of the target point; already absorbed in \(\ker\varphi_\tau\) |
| \(\lambda\in F^\times\) (force \(\lambda\) rational) | **no** | forces \(V_Z\subseteq U_\tau\); discards solutions with genuinely nonrational \(\lambda\in L^\times\) |
| \(\lambda=1\) | **no** | same as above on a single chart of \(F^\times\) |
| \(\tau=\) fixed monogenic generator \(\alpha\) | **no** | forces the degree-55 divisor on \(\mathbf P^1\) into a single \(\mathrm{PGL}_2\)-orbit of binary forms; moduli of binary 55-ics have dimension \(55-3=52\), so almost all divisors are excluded |
| \(\operatorname{Norm}_{L/F}(\tau)=1\) alone | partial | one hypersurface in the \(\mathrm{PGL}_2\) gauge package; not a further cut beyond §2 |

**Verdict.**  Only the projective \(F^\times\)-scaling of \(\lambda\) is
lossless, and it does not add nonlinear variables once \(\lambda\) is
eliminated linearly.

---

## 6. Minimal irreducible system (after every lossless collapse)

### Ambient

Let \(S\subset L\simeq\mathbf A^{55}_F\) be a full \(\mathrm{PGL}_2(F)\)-gauge
slice of dimension 52 on the primitive locus (e.g. monic minimal polynomial
with vanishing \(t^{54}\) and \(t^{53}\) coefficients after the classical
normalisation of binary forms, plus the residual inversion normaliser).

### Equations

\[
\mathcal I
=
\bigl(
\text{all \(55\times 55\) minors of }\varphi_\tau
\bigr)
\;\subset\;
F[S],
\]

saturated at the non-primitive locus \(\{\dim U_\tau<20\}\) and at the locus
where the reconstructed map fails the open conditions needed for
\(\lambda\neq 0\).

Equivalently: the Fitting ideal of coker\(\varphi_\tau\) in codimension one
along the \(\lambda\)-space, pulled back to \(S\).

### Reconstruction and safeguards

On \(V(\mathcal I)\cap S\):

1. recover \(\lambda\in\ker\varphi_\tau\setminus\{0\}\);
2. recover \(c_{jk}\) by solving \(\lambda z_j=\sum_k c_{jk}\tau^k\) in \(U_\tau\);
3. run safeguards S1–S6 (`candidate_verifier.py`);
4. a rank-only point is **not** a qualifying curve.

### Variable / degree summary

| Item | Value |
|---|---|
| Nonlinear variables after lossless collapse | **52** (\(\tau\) on the \(\mathrm{PGL}_2\) slice) |
| Linear unknowns eliminated | 80 \(c_{jk}\) + 55 \(\lambda\)-coords |
| Structured matrix | \(\varphi_\tau\in\operatorname{Mat}_{140\times 55}(F)\) |
| Residual generators | maximal minors / Fitting of \(\varphi_\tau\) |
| Entry degree in \(\tau\)-coords | \(\le 19\) |
| Minor degree | \(\gg 3\) (far above Macaulay \(D=3\)) |
| Dense Macaulay at \(n=52\), \(D=3\) | \(\sim 20.5\) GiB \(> 8\) GiB |
| Max \(n\) with residual degree \(\ge 19\) under 8 GiB (qq 32 B/entry) | **\(n\le 4\)** |

No lossless collapse from the candidate list reduces the nonlinear count from
52 to \(\le 4\).  Binary-form invariant coordinates still parametrise a
52-dimensional moduli space.  Intermediate-field and isotypic reductions over
\(F\) do not exist (§3).

**Therefore no lossless structural collapse brings the residual under the
8 GiB gate.**

---

## 7. Modular discovery (authorised, non-decisional)

Script: `tmp/pathA_collapse/modular_rank_profile.py`  
Output: `tmp/pathA_collapse/modular_rank_profile.json`

Over a random monogenic \(\mathbf F_{101}\)-algebra of degree 55 with a
**random** 4-plane \(V_Z\) (explicitly not the geometric Schur \(V_Z\)):

| Check | Result |
|---|---|
| Primitive \(\tau\) sampled | 80 |
| \(\operatorname{rank}\varphi_\tau=55\) (full) | 80 / 80 |
| Rank drops | 0 |
| Planted control \(V_Z\subset U_{\tau_0}\) | rank 54, nullity 1 (detects incidence) |

Interpretation: the rank test is live; for generic \(V_Z\) the sampled fibre
of \(\mathcal K\) is empty.  This is **not** a proof that the geometric
\(\mathcal K\) over \(F=K_{\mathrm{Schur}}\) is empty, and is **not** `N-A`.

---

## 8. Decision exit

| Exit | Status |
|---|---|
| `P-A` | not reached (no qualifying curve) |
| `N-A` | **not claimed** (would require \(\mathcal K=\varnothing\) and exhaustiveness; closes only the degree-19 Krylov route even if proved) |
| `A-SURVIVE` | not reached (no residual component equations computed) |
| `A-STOP` | **confirmed, refined** |

**Refined bottleneck.**  After every lossless collapse the residual is the
Fitting / minor ideal of the structured \(140\times 55\) matrix \(\varphi_\tau\)
on a 52-dimensional \(\mathrm{PGL}_2\)-gauge slice of \(L\).  Equation degree
is \(\gg 3\); dense exact linear algebra at Macaulay degree 3 already exceeds
8 GiB (\(\sim 20.5\) GiB at \(n=52\)).  Fitting the true degree under 8 GiB
would require \(\le 4\) nonlinear variables, which no lossless collapse
provides.

**Headline:** OPEN.

---

## 9. What would unblock a future exact residual

Any one of the following would change the gate (none is claimed here):

1. A theorem that qualifying \(\tau\) lie on an explicitly described
   subvariety of dimension \(\le 4\) (or that \(\mathcal K=\varnothing\)) by
   pure geometry of the Klein / Schur configuration, without expanding
   minors.
2. Expanded coefficients of \(\mu\in F[t]\) and of \(z_i\in L\) together with
   a new structural equation of low degree in few invariants.
3. A certified isotypic splitting over a finite extension that reduces to
   independent residuals each under gate, with a descent theorem back to \(F\).

Until one of these appears, the minimal irreducible system of §6 is the
correct computational target, and it remains over the exploratory memory
gate.

---

## 10. Terminal marker

```text
SCHUR_KRYLOV_A3_STRUCTURAL_COLLAPSE_A_STOP
```
