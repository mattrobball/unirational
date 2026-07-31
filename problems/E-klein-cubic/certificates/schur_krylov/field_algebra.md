# Gate A2 — degree-55 field algebra \(L/F\)

**Date:** 2026-07-30  
**Packet:** `certificates/schur_krylov/`  
**Gate:** A2 (field algebra half)  
**Headline:** OPEN

---

## 0. Objects

| Symbol | Definition | Degree / rank |
|---|---|---|
| \(G=\operatorname{PSL}_2(\mathbf F_{11})\) | automorphism group | \(\lvert G\rvert=660\) |
| \(H\simeq D_{12}\) | full stabilizer of the certified line \(\ell\subset X\) | \(\lvert H\rvert=12\) |
| \(E=\mathbf C(\mathbf P(V_6))\) | function field of the Schur projective source | \(\operatorname{trdeg}_{\mathbf C}=5\) |
| \(F=K_{\mathrm{Schur}}=E^G\) | generic Schur invariant field | — |
| \(L=E^H=F(Z)\) | fixed field of \(H\); residue field of the degree-55 point | \([L:F]=55\) |

Accepted existence of the degree-55 closed point \(Z\) with \(k(Z)=L\) is upstream
(`tmp/schur_unrestricted_point_attack`).  This note installs an **abstract
monogenic algebra schema** for \(L/F\) required before any Krylov search
(`REPAIR.md` §10).  It does **not** install expanded executable coefficients
of \(\mu\) in named invariant generators, nor executable generic multiplication
matrices over a concrete presentation of \(F\).

---

## 1. Monogenic presentation

### Separability and primitivity

The extension \(E/F\) is Galois of degree 660 with group \(G\) (generic free
locus).  The subfield \(L=E^H\) satisfies

\[
[L:F]=\frac{[E:F]}{[E:L]}=\frac{660}{12}=55.
\]

Characteristic zero \(\Rightarrow\) finite extensions are separable.  The
primitive element theorem supplies \(\alpha\in L\) with

\[
L=F(\alpha)=F[t]/(\mu(t)),
\]

where \(\mu\in F[t]\) is monic irreducible of degree 55.

### Galois closure (structural, not a computation of \(\mu\))

The Galois closure of \(L/F\) inside \(E\) is \(E\) itself, with

\[
\operatorname{Gal}(E/F)\simeq G,\qquad
\operatorname{Gal}(E/L)\simeq H.
\]

Since \(H\) is maximal and \(G\) is simple, \(H\) is not normal, so \(L/F\) is
**not** Galois.  In particular \(\operatorname{Aut}(L/F)=N_G(H)/H=1\).  The
55 roots of \(\mu\) in a closure are transitively permuted by \(G\) via its
action on the coset space \(G/H\).

### Sealed monogenic interface

```text
L  ≅  F[t] / (μ(t))
μ  monic in F[t], deg μ = 55, irreducible over F
basis B = (1, α, α², …, α⁵⁴)     (α = t mod μ)
```

The coefficients of \(\mu\) are formal elements of \(F=K_{\mathrm{Schur}}\).
They are **not** expanded here as explicit rational functions on
\(\mathbf P(V_6)\).  The monogenic presentation and the companion arithmetic
below are a **formal algebra schema** over \(F\): exact once any primitive
element is fixed, but **not** expanded executable generic data.  Status
(`REPAIR.md` §10):

```text
abstract degree-55 algebra and marked-evaluation interface installed;
exact executable marked algebra-code pair (L,V_Z) not installed.
```

A producer that later specialises or computes \(\mu\) must feed the same
interface (`field_algebra.json`).

---

## 2. Multiplication matrices (exact companion form)

Write

\[
\mu(t)=t^{55}+c_{54}t^{54}+\cdots+c_1 t+c_0,\qquad c_i\in F.
\]

Multiplication by \(\alpha\) on the ordered \(F\)-basis \(B\) is the companion
matrix \(C_\mu\in\operatorname{Mat}_{55}(F)\):

\[
C_\mu
=
\begin{pmatrix}
0 & 0 & \cdots & 0 & -c_0\\
1 & 0 & \cdots & 0 & -c_1\\
0 & 1 & \cdots & 0 & -c_2\\
\vdots & \vdots & \ddots & \vdots & \vdots\\
0 & 0 & \cdots & 1 & -c_{54}
\end{pmatrix}.
\]

Multiplication by \(\alpha^k\) is \(C_\mu^k\).  Multiplication by a general
element \(\xi=\sum_{k=0}^{54}x_k\alpha^k\) (\(x_k\in F\)) is the \(F\)-linear
endomorphism

\[
M_\xi=\sum_{k=0}^{54}x_k\,C_\mu^k\in\operatorname{Mat}_{55}(F).
\]

**Sealed claim (schema level).**  For the fixed basis \(B\), the family
\((M_\xi)_{\xi\in L}\) is the complete table of multiplication matrices of
\(L/F\) **as a formal \(F\)-algebra schema**.  It is determined exactly by the
55 (unexpanded) coefficients of \(\mu\) and the coordinate vector of \(\xi\).
This is **not** a claim that executable generic multiplication matrices over
a concrete model of \(F\) are installed.

The machine-readable form is recorded in `field_algebra.json`:

- `presentation`: monogenic;
- `degree`: 55;
- `basis`: power basis;
- `multiplication_by_alpha`: companion pattern (symbolic in the \(c_i\));
- `api`: `mul_matrix(coords) -> 55×55 over F`.

### Hironaka-module reading

As an \(F\)-vector space, \(L\) is free of rank 55 on \(B\).  The structure
constants of the \(F\)-algebra are the entries of the matrices \(M_{\alpha^i}\),
equivalently the single companion matrix and its powers.  This is the
Hironaka free-module presentation of the finite field extension \(L/F\).

---

## 3. Subfield lattice (for Krylov dimension control)

Divisors of 55: \(1,5,11,55\).  Any intermediate field \(F\subset K\subset L\)
has \([K:F]\in\{1,5,11,55\}\).

For \(\tau\in L\) set

\[
U_\tau=\operatorname{span}_F\{1,\tau,\ldots,\tau^{19}\}\subset L.
\]

Then

\[
\dim_F U_\tau=\min\bigl(20,\,[F(\tau):F]\bigr).
\]

Hence \(\dim U_\tau=20\) if and only if \([F(\tau):F]=55\), i.e. \(\tau\) is a
primitive element of \(L/F\).  (Degrees \(1,5,11\) are all \(\le 11<20\).)

Krylov incidence in Gate A3 restricts to the open locus of primitive
\(\tau\), where \(U_\tau\) is a genuine 20-dimensional \(F\)-subspace.

---

## 4. Independent reconstruction checklist

A verifier that does **not** import the producer must be able to:

1. recompute \([G:H]=660/12=55\);
2. confirm the monogenic degree equals 55;
3. rebuild the companion matrix pattern from a monic length-55 coefficient
   list;
4. check \(C_\mu^{55}=-\sum_{i=0}^{54}c_i C_\mu^i\) on the standard basis
   (Cayley–Hamilton);
5. confirm the subfield-degree dichotomy used for \(\dim U_\tau\).

These checks are implemented in `verify_field_algebra.py`.

---

## 5. Theorem boundary (`REPAIR.md` §10)

| Installed (abstract interface) | Not installed (expanded executable generic data) |
|---|---|
| Monogenic schema \(L=F[t]/(\mu)\), \(\deg\mu=55\) | Explicit expanded coefficients of \(\mu\) as elements of \(\mathbf C(\mathbf P(V_6))^G\) |
| Companion multiplication pattern over formal \(c_i\in F\) | Executable generic multiplication matrices over a concrete presentation of \(F\) |
| Subfield lattice and \(\dim U_\tau\) criterion | A numerical minimal polynomial over \(\mathbf Q\) advertised as the generic \(\mu\) |

```text
abstract degree-55 algebra and marked-evaluation interface installed;
exact executable marked algebra-code pair (L,V_Z) not installed.
```

The missing expanded \(\mu\in F[t]\) is an invariant-field computation on
\(\mathbf P(V_6)\).  It is **not** required to seal the abstract multiplication
API or to dimension the Krylov incidence.  It **is** required before any claim
that a concrete coefficient vector in \(\mathbf Q^{55}\) is the generic marked
point over \(F\), or that an executable generic pair \((L,V_Z)\) is installed.
The later `A_EMPTY_UNDECIDED` packet correctly records this boundary and
supersedes earlier summaries that overstated A2 as installing exact generic
coordinates.

---

## 6. Terminal marker

```text
SCHUR_KRYLOV_A2_FIELD_ALGEBRA_SEALED
```
