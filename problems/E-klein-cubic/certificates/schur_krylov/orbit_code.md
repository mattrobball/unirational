# Task 2 — \(G/D_{12}\) orbit code for \((A_{\mathrm{empty}})\)

**Packet:** `certificates/schur_krylov/`  
**Date:** 2026-07-31  
**Exit contribution:** `A_EMPTY_UNDECIDED` (formulation complete; proof not closed)  
**Headline:** OPEN  
**Tool:** GAP (`/opt/homebrew/Caskroom/miniforge/base/bin/gap`) with AtlasRep

---

## 0. What this note is

The director's instruction: attack

\[
(A_{\mathrm{empty}})
\qquad
\forall\,\tau\in L\text{ primitive},\quad
K_{34}(\tau,V_Z)=L
\]

with the **orbit combinatorics** of \(G/D_{12}\), not another general-purpose
elimination.  This note installs the permutation-module home of \(V_Z\) and
of the Krylov filtration, records the GAP-certified group facts, and states
exactly what still blocks a proof.

It does **not** claim \((A_{\mathrm{empty}})\), does **not** claim \(N\text{-}A\),
and does **not** treat modular rank samples as characteristic zero.

---

## 1. Group and field lattice (GAP-certified)

| Object | Value | Certificate |
|---|---|---|
| \(G\) | \(\mathrm{PSL}_2(\mathbf F_{11})\), order 660 | Atlas `L2(11)` |
| \(H\) | \(D_{12}\), order 12 | unique conj. class of dihedral order 12 |
| \([G:H]\) | 55 | \(660/12\) |
| Intermediate subgroups \(H\subsetneq K\subsetneq G\) | **none** | `IntermediateSubgroups` count 0 |
| \(N_G(H)\) | \(H\) | \(|N_G(H)|/|H|=1\) |
| \(\operatorname{Aut}(L/F)\) | 1 | \(N_G(H)/H\) |
| Intermediate fields of \(L/F\) | none | maximality \(\Rightarrow\) no degrees 5 or 11 |

**Field dictionary.**

\[
E=\mathbf C\bigl(\mathbf P(V_6)\bigr),\quad
F=E^G=K_{\mathrm{Schur}},\quad
L=E^H=F(Z),\quad
[L:F]=55.
\]

Galois closure of \(L/F\) is \(E/F\) with \(\mathrm{Gal}(E/F)\simeq G\) and
\(\mathrm{Gal}(E/L)\simeq H\).  The 55 embeddings \(L\hookrightarrow\overline F\)
are the coset space \(G/H\).

---

## 2. Subdegrees (geometric, not an \(F\)-splitting)

\(H\) acts on \(G/H\) with orbit lengths

\[
1,\;3,\;3,\;6,\;6,\;6,\;6,\;12,\;12
\]

(sum \(55\)).  Point stabilizers in \(H\) by orbit type (GAP):

| Orbit length | \(\mathrm{Stab}_H\) | Order |
|---:|---|---:|
| 1 | \(D_{12}\) | 12 |
| 3 | \(C_2\times C_2\) | 4 |
| 3 | \(C_2\times C_2\) | 4 |
| 6 | \(C_2\) | 2 |
| 6 | \(C_2\) | 2 |
| 6 | \(C_2\) | 2 |
| 6 | \(C_2\) | 2 |
| 12 | \(1\) | 1 |
| 12 | \(1\) | 1 |

**Collapse-audit warning (binding).**  These subdegrees are orbit sizes after
base change.  They are **not** an \(F\)-rational direct-sum decomposition of
the \(F\)-vector space \(L\), and they do **not** block-diagonalise the
Krylov residual over \(F\) (`STRUCTURAL_COLLAPSE.md` §3).  Misusing them as
an \(F\)-splitting is forbidden.

Number of \(H\backslash G/H\) double cosets \(=9=\dim\operatorname{End}_G\bigl(\mathbf C[G/H]\bigr)\).

---

## 3. Permutation module and its \(G\)-decomposition

Let \(P=\mathbf C[G/H]=\operatorname{Ind}_H^G\mathbf 1\), the permutation
module of dimension 55.  GAP character computation:

\[
P
\;\simeq\;
\mathbf 1
\;\oplus\;
\chi_5^{(a)}
\;\oplus\;
\chi_5^{(b)}
\;\oplus\;
2\cdot\chi_{10}
\;\oplus\;
\chi_{12}^{(a)}
\;\oplus\;
\chi_{12}^{(b)},
\]

where the ordinary irreducible degrees of \(G\) are
\(\{1,5,5,10,10,11,12,12\}\) and the multiplicity vector on that ordered list
of irreps is

\[
(1,1,1,0,2,0,1,1).
\]

Check: \(1+5+5+2\cdot 10+12+12=55\).  The two degree-5 irreps are the
ambient Klein representation \(W\) and its twin; the degree-11 irrep does
**not** appear in \(P\).

**Relation to \(L\).**  As \(F\)-algebras \(L\) is a field, while the product
ring \(\prod_{G/H}\overline F\) is not.  The correct comparison is after
base change:

\[
L\otimes_F\overline F
\;\simeq\;
\prod_{gH\in G/H}\overline F
\qquad\text{as \(\overline F\)-algebras},
\]

with underlying \(G\)-representation \(P\otimes\overline F\).  Multiplication
by a fixed \(\tau\in L\) becomes diagonal in the geometric idempotent basis,
with eigenvalues the 55 conjugates of \(\tau\).

---

## 4. Where \(V_Z\) sits

### 4.1 Over \(F\)

\(V_Z\subset L\) is a 4-dimensional \(F\)-subspace, scaling-invariant image of
the four hyperplane coordinates of the marked point.  It is **not** a
\(G\)-submodule of \(L\) over \(F\) (there is no faithful \(G\)-action on \(L\)
over \(F\)).

### 4.2 After base change (orbit code)

Identify \(L\otimes\overline F\simeq \overline F^{G/H}\).  Then

\[
V_Z\otimes\overline F
=
\operatorname{im}\Bigl(
H^0(M_{\overline F},\mathcal O(1))
\longrightarrow
\overline F^{G/H}
\Bigr),
\]

a Galois-stable 4-plane of full support (no geometric point of the orbit has
all four coordinates zero).  The 55 geometric points lie on the cubic surface
\(X_T\cap M\).

**Specialness used by any honest proof of \((A_{\mathrm{empty}})\).**  The
plane is the evaluation image of \(\mathcal O(1)\) on a \(G/H\)-orbit of
points cut from the Klein cubic by a good hyperplane — not an arbitrary
4-plane in an abstract degree-55 extension.  An argument that never uses
this (or an equivalent invariant of the marked configuration) cannot
distinguish geometric \(V_Z\) from a planted \(V\subset U_{\tau_0}\) and is
therefore either wrong or weaker than \((A_{\mathrm{empty}})\).

### 4.3 Missing refined position

The isotypic decomposition of \(P\) does **not**, by itself, name which
4-plane is \(V_Z\otimes\overline F\).  Descent of isotypics to \(F\) fails for
the residual ideal (`STRUCTURAL_COLLAPSE.md`); the same obstruction blocks
writing \(V_Z\) as an \(F\)-rational sum of named isotypics without the
expanded model of Task 1.  The installed marked-point packet is an **abstract
interface** only (`REPAIR.md` §10): exact executable generic coordinates of
\((L,V_Z)\) are not installed.

---

## 5. Krylov filtration in the orbit code

For \(\tau\in L\) primitive and \(V\subset L\), set

\[
K_s(\tau,V)
:=
\sum_{j=0}^{s}\tau^j V
\;\subset\;
L.
\]

### 5.1 Geometric form

In the geometric eigenbasis of multiplication by \(\tau\),

\[
\bigl(K_s(\tau,V)\bigr)_p
=
\operatorname{span}_F\bigl\{\tau_p^j\,v_p:j\le s,\,v\in V\bigr\}
\]

row-wise: the block Krylov matrix is the \(55\times 4(s+1)\) matrix

\[
B_s(\tau,V)
=
\Bigl[\;
V\;\big|\;
\tau V\;\big|\;
\cdots\;\big|\;
\tau^s V
\;\Bigr]
\in
\operatorname{Mat}_{55\times 4(s+1)}(F),
\]

with geometric entries \(B_{(p),(i,j)}=\tau_p^j\,z_i(p)\).

### 5.2 The case \(s=34\)

\[
B_{34}(\tau,V_Z)\in\operatorname{Mat}_{55\times 140}(F),\qquad
140=4\cdot 35=4\cdot(34+1).
\]

\[
K_{34}(\tau,V_Z)=L
\quad\Longleftrightarrow\quad
\operatorname{rank} B_{34}(\tau,V_Z)=55
\quad\Longleftrightarrow\quad
\text{at least one \(55\times 55\) minor of \(B_{34}\) is nonzero at \(\tau\)}.
\]

**Quantifier (`REPAIR.md` §9).**  The third clause is a **pointwise** statement:
for each fixed primitive \(\tau\) there exists a maximal minor \(M_\tau\)
(allowed to depend on \(\tau\)) with \(M_\tau(\tau)\neq 0\).  It is **not**
equivalent to the existence of one minor that is nonzero for every primitive
\(\tau\).  The correct global certificate is

\[
V\bigl(I_{55}(B_{34})\bigr)\cap U_{\mathrm{primitive}}=\varnothing,
\]

the vanishing locus of the ideal of **all** maximal minors.

### 5.3 Equivalence with incidence (proved)

Let \(U_\tau=\operatorname{span}_F\{1,\tau,\ldots,\tau^{19}\}\) (dim 20 on the
primitive locus).  The sealed incidence is

\[
\mathcal K
=
\bigl\{(\tau,\lambda)\in L\times L^\times:\lambda V_Z\subseteq U_\tau\bigr\}.
\]

**Theorem (index-34 duality).**  For primitive \(\tau\in L\) and any
finite-dimensional \(F\)-subspace \(V\subset L\),

\[
\operatorname{rank} B_{34}(\tau,V)<55
\quad\Longleftrightarrow\quad
\exists\,\lambda\in L^\times\text{ with }\lambda V\subseteq U_\tau.
\]

*Proof sketch (exact, standard residue form).*  
(\(\Rightarrow\) of containment \(\Rightarrow\) rank drop.)  If
\(\lambda V\subseteq U_\tau\) then
\(\tau^j\lambda V\subseteq\operatorname{span}\{1,\ldots,\tau^{19+j}\}\), so
\(K_{34}(\tau,\lambda V)\subseteq\operatorname{span}\{1,\ldots,\tau^{53}\}\)
has dimension \(\le 54\).  Multiplication by \(\lambda\neq 0\) is an
\(F\)-linear automorphism, hence
\(\operatorname{rank} B_{34}(\tau,V)=\operatorname{rank} B_{34}(\tau,\lambda V)<55\).

(\(\Leftarrow\) rank drop \(\Rightarrow\) containment.)  After base change to
a splitting field, \(\tau\) has 55 distinct conjugates \(\tau_p\) (primitive).
Rank drop means there is \(0\neq a\in\overline F^{55}\) with

\[
\sum_p a_p\,z_i(p)\,\tau_p^j=0
\qquad\text{for all }i\text{ and all }j=0,\ldots,34.
\]

The discrete measure with weights \(w_i(p)=a_p z_i(p)\) has vanishing moments
of order \(0,\ldots,34\).  Expanding
\(\sum_p w_i(p)/(t-\tau_p)=N_i(t)/\mu_\tau(t)\) at infinity, those vanishings
force \(\deg N_i\le 19\).  Residues give
\(a_p z_i(p)=N_i(\tau_p)/\mu_\tau'(\tau_p)\).  Set
\(\lambda_p=a_p\mu_\tau'(\tau_p)\) (same \(\lambda\) for all \(i\); separable
\(\Rightarrow\mu_\tau'(\tau_p)\neq 0\)).  Then
\(\lambda_p z_i(p)=N_i(\tau_p)\), i.e. \(\lambda z_i\in U_\tau\) for all \(i\).
If \(a\neq 0\) then \(\lambda\neq 0\).  Galois descent returns \(\lambda\in L^\times\).
\(\square\)

**Corollary.**

\[
(A_{\mathrm{empty}})
\quad\Longleftrightarrow\quad
\mathcal K\cap\bigl(\{\text{primitive \(\tau\)}\}\times L^\times\bigr)=\varnothing.
\]

So the director's block-Krylov formulation is exactly emptiness of the
primitive incidence, not a weaker proxy.

### 5.4 Match with the sealed \(\varphi_\tau\)

The sealed structural matrix (`STRUCTURAL_COLLAPSE.md`)

\[
\varphi_\tau:L\to(L/U_\tau)^4,\qquad
\lambda\mapsto\bigl(\pi_\tau(\lambda z_0),\ldots,\pi_\tau(\lambda z_3)\bigr)
\]

is a \(140\times 55\) matrix.  Nontrivial kernel \(\Leftrightarrow\) incidence at
\(\tau\).  By the theorem, \(\operatorname{rank}\varphi_\tau<55\) if and only if
\(\operatorname{rank} B_{34}(\tau,V_Z)<55\).  Same \(140=4\cdot 35\) count:
\(35=\dim(L/U_\tau)=34+1\).

---

## 6. What an orbit-code **proof** of \((A_{\mathrm{empty}})\) must look like

A proof should be a statement about how \(V_Z\) sits in \(P=F[G/D_{12}]\)
(after base change) relative to the \(\tau\)-multiplication filtration —
for example one of:

1. **Support / generation.**  Show that for every primitive diagonal
   multiplication \(m_\tau\), the 4-plane \(V_Z\otimes\overline F\) excites all
   55 geometric modes inside the window of 35 powers (PBH / residue form of
   §5.3 has no nonzero \(a\)).
2. **No rational curve through the orbit.**  Show that the \(G/H\)-orbit of
   points on \(X_T\cap M\) is not the image of any degree-\(\le 19\) map
   \(\mathbf P^1\to M\simeq\mathbf P^3\) defined over \(F\).  (Equivalent by
   §5.3 and the A1 reduction.)
3. **Representation obstruction.**  Derive a contradiction from the
   assumption \(\lambda V_Z\subseteq U_\tau\) using the isotypic content of \(P\),
   the cubic equation, and maximality of \(H\) — without expanding minors in
   52 gauge variables.

### Failed / incomplete routes (recorded so they are not re-tried as proofs)

| Route | Why it does not close |
|---|---|
| General 4-plane in abstract degree-55 field | False: planted \(V\subset U_{\tau_0}\) drops rank; any true proof must use specialness of \(V_Z\) |
| \(F\)-isotypic block diagonalisation of residual | Ruled out: \(H\) maximal, \(\operatorname{Aut}(L/F)=1\), subdegrees geometric only |
| \(G\hookrightarrow\mathrm{PGL}_2\) from a unique curve | \(G\) does **not** act by automorphisms of the torsor-dependent \(M\simeq\mathbf P^3\); the naive uniqueness+\(G\)-action argument does not apply to the twisted hyperplane section |
| 80/80 modular full rank on random \(V_Z\) | Discovery only; not geometric \(V_Z\); not char 0 |
| Dense elimination of Fitting(\(\varphi_\tau\)) | Retired; over 8 GiB even after lossless PGL₂ gauge |

### Residual obstruction (exact)

Without either

- expanded power-basis coordinates of \(V_Z\) (Task 1), or
- a geometric theorem that the marked \(G/H\)-orbit on \(X_T\cap M\) lies on
  no \(F\)-rational degree-\(\le 19\) curve in \(M\),

the orbit code names the home of the problem but does not certify that the
ideal of all maximal minors of \(B_{34}(\tau,V_Z)\) misses the primitive locus
(equivalently: does not evaluate, for every primitive \(\tau\), at least one
nonzero maximal minor) or produce a contradiction from
\(\lambda V_Z\subseteq U_\tau\).

That is the remaining obstruction to \((A_{\mathrm{empty}})\).

---

## 7. Machine artifacts

| File | Role |
|---|---|
| `orbit_code.g` | GAP script: maximality, subdegrees, perm character decomp |
| `orbit_code.json` | machine-readable summary |
| `tmp/a_empty/orbit_perm.out` | GAP transcript (scratch) |
| `tmp/a_empty/compare_ranks.json` | modular \(B_{34}\) vs \(\varphi_\tau\) agreement (discovery only) |

Replay:

```bash
/opt/homebrew/Caskroom/miniforge/base/bin/gap -q -b certificates/schur_krylov/orbit_code.g
```

Expected marker: `ORBIT_CODE_GAP_OK`.

---

## 8. Terminal marker

```text
SCHUR_KRYLOV_ORBIT_CODE_FORMULATED_A_EMPTY_UNDECIDED
```
