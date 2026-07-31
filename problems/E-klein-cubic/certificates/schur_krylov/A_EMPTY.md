# Path A — attack on \((A_{\mathrm{empty}})\) via the \(G/D_{12}\) orbit code

**Date:** 2026-07-31  
**Packet:** `certificates/schur_krylov/`  
**Base pin:** `17e0e5f`  
**Binding docs:** `WORKORDER_POST_ELO_CONSTRUCTION.md` (Path A),
`WORKORDER_ELO_TEN_PATHS.md` (Path A safeguards)  
**Decision exit:** `A_EMPTY_UNDECIDED`  
**Headline:** OPEN  
**Theorem-boundary repair:** `REPAIR.md` §§9–10 (maximal-minor quantifier;
abstract field-algebra / marked-point interface).  
**\(N\text{-}A\) claimed:** no  
**\(P\text{-}A\) claimed:** no

---

## 0. Exact remaining statement

Path A's \(\mathbf P^1\) reduction is sealed (`P1_REDUCTION.md`, Gate A1-PASS).
It does **not** by itself prove emptiness of the Krylov incidence.  The
director-issued remaining assertion is

```text
(A_empty)     for all primitive tau in L,     K_34(tau, V_Z) = L.
```

Equivalently (pointwise quantifier, `REPAIR.md` §9): **at every** primitive
\(\tau\), **at least one** \(55\times 55\) minor of the block Krylov matrix
\(B_{34}(\tau,V_Z)\) is nonzero.  The minor may depend on \(\tau\).  This is
**not** the stronger assertion that a single minor is globally nonvanishing
on the whole primitive locus.  The correct global certificate is emptiness of

\[
V\bigl(I_{55}(B_{34})\bigr)\cap U_{\mathrm{primitive}},
\]

i.e. the ideal of **all** maximal minors of \(B_{34}\) (or an equivalent
saturation) meets no primitive \(\tau\).

### Theorem boundary of a positive resolution

If \((A_{\mathrm{empty}})\) were proved, the primitive incidence

\[
\mathcal K
=
\bigl\{(\tau,\lambda)\in L\times L^\times:\lambda V_Z\subseteq U_\tau\bigr\}
\]

would be empty, and the degree-19 Krylov rescue route would exit **`N-A`**.
That exit

- closes **only** the degree-19 Krylov route,
- is **not** a headline result,
- does **not** prove non-unirationality of the Klein cubic,
- does **not** decide Paths G/F/T/C or \(\operatorname{ed}_{\mathbf C}(G)\).

This note does **not** claim \(N\text{-}A\).

---

## 1. Index reconciliation (Task 3)

### 1.1 Sealed incidence objects

From `krylov_incidence.md` / `STRUCTURAL_COLLAPSE.md`:

| Object | Shape / value | Role |
|---|---|---|
| \(U_\tau\) | \(\operatorname{span}_F\{1,\tau,\ldots,\tau^{19}\}\), dim 20 if primitive | target Krylov 20-plane for degree-19 maps |
| Matrix \(M(\tau,\lambda)\) | \(55\times 24\) | columns \(1,\tau,\ldots,\tau^{19},\lambda z_0,\ldots,\lambda z_3\); rank \(\le 20\) for containment |
| Linear block \(A(\tau)\) | \(220\times 135\) | 80 coeffs \(c_{jk}\) + 55 \(\lambda\)-coords |
| \(\varphi_\tau:L\to(L/U_\tau)^4\) | **\(140\times 55\)** | \(\ker\neq 0\Leftrightarrow\) incidence at \(\tau\) |
| Degree of map | 19 | \(\Rightarrow\) powers \(0..19\) in \(U_\tau\) |
| Residual budget | \(3\cdot 19-55=2\) | safeguard S6 |

### 1.2 Director index \(K_{34}\)

Post-Elo growth:

\[
K_s(\tau,V)
=
\sum_{j=0}^{s}\tau^j V,
\qquad
B_s(\tau,V)
=
\bigl[V\;\big|\;\tau V\;\big|\;\cdots\;\big|\;\tau^s V\bigr]
\in
\operatorname{Mat}_{55\times 4(s+1)}(F).
\]

For \(s=34\):

| Quantity | Value | Why |
|---|---|---|
| Powers of \(\tau\) | \(0,1,\ldots,34\) | \(34+1=35\) blocks |
| Blocks | 35 | \(=55-20=\dim(L/U_\tau)\) |
| Columns | \(4\cdot 35=140\) | four generators \(z_i\) |
| Matrix \(B_{34}\) | **\(55\times 140\)** | block Krylov |
| Full rank | 55 | \(\Leftrightarrow K_{34}=L\) |

### 1.3 Why the index is 34 (not 19, not 35)

If \(\lambda V\subseteq U_\tau=\operatorname{span}\{1,\ldots,\tau^{19}\}\), then

\[
K_s(\tau,\lambda V)
\;\subseteq\;
\operatorname{span}_F\{1,\tau,\ldots,\tau^{19+s}\},
\qquad
\dim\le\min(55,\,20+s).
\]

- For \(s\le 34\): \(20+s\le 54\), so containment forces \(K_s\neq L\).
- For \(s=35\): \(20+35=55\), so \(K_{35}=L\) is **compatible** with
  containment and does **not** obstruct incidence.
- Index \(34=55-20-1\) is therefore the **largest** window for which
  \(K_s=L\) is incompatible with \(\lambda V\subseteq U_\tau\).

### 1.4 Discrepancy report

**No discrepancy in dimensions.**  The sealed \(\varphi_\tau\) is \(140\times 55\)
and the block Krylov \(B_{34}\) is \(55\times 140\); both use the count
\(140=4\cdot 35\) with \(35=55-20=34+1\).  They are dual formulations of the
same incidence condition (Theorem in `orbit_code.md` §5.3):

\[
\operatorname{rank} B_{34}(\tau,V_Z)<55
\quad\Longleftrightarrow\quad
\operatorname{rank}\varphi_\tau<55
\quad\Longleftrightarrow\quad
\exists\lambda\in L^\times:\;\lambda V_Z\subseteq U_\tau.
\]

The sealed packet emphasised the \(\varphi_\tau\) / \(U_\tau\) side (linear
elimination of \(\lambda\)); the director's \((A_{\mathrm{empty}})\) emphasises
the controllability side \(K_{34}\).  Same predicate on the primitive locus.

### 1.5 Exact shape used in this packet

```text
L / F          degree 55, monogenic schema (abstract interface; mu not expanded)
V_Z            dim_F = 4  (geometric construction; power-basis coords not expanded)
U_tau          span{1, tau, ..., tau^19}     dim 20 if primitive
B_34           55 x 140   blocks: tau^0 V_Z | ... | tau^{34} V_Z
phi_tau        140 x 55   (L/U_tau)^4 <- L
(A_empty)      rank B_34(tau, V_Z) = 55 for all primitive tau
               <=> I_55(B_34) misses U_primitive
               (NOT: one fixed 55x55 minor nonzero for all tau)
full rank      <=>  K_34(tau, V_Z) = L  <=>  no incidence at tau
executable (L,V_Z)  NOT installed (REPAIR.md §10)
```

---

## 2. Task 1 — power-basis expansion of \(V_Z\)

**Result:** expansion **not available**.  
**Artifact:** `vz_power_basis.md`, `vz_power_basis.json`.

The sealed A2 interfaces install **abstract** monogenic \(L/F\) and the geometric
construction of \(z\in\mathbf P^3(L)\) as formal algebra schemas — not expanded
executable generic data (`REPAIR.md` §10) — and explicitly set

```text
mu_coefficients_expanded_in_invariants: false
coordinates.expanded_coefficients_in_F: false
```

Producing \(a_{ik}\in F\) requires generators of \(K_{\mathrm{Schur}}\) and of
\(E^H\), the torsor-dependent hyperplane, and the twisted-line intersection
as elements of \(L\).  None of that is sealed.  Weaker data retained:

- \(\dim V_Z=4\) from \(H_Z(1)=4\);
- geometric construction from twisted \(D_{12}\)-line meets \(M\);
- base-change description as the \(\mathcal O(1)\)-evaluation image in
  \(\overline F[G/H]\);
- fibre witness rank 4 over \(\mathbf Q(\zeta_{11})\) (shape only).

---

## 3. Task 2 — orbit-code attack

**Result:** formulation complete; proof **not closed**.  
**Artifact:** `orbit_code.md`, `orbit_code.json`, `orbit_code.g`.

### 3.1 Structure exploited

- \(L=E^H\), degree-55 closed point \(\leftrightarrow\) coset space \(G/D_{12}\);
- \(D_{12}\) maximal \(\Rightarrow\) no intermediate fields, \(\operatorname{Aut}(L/F)=1\);
- \(H\)-subdegrees \(1,3,3,6,6,6,6,12,12\) geometric only (not \(F\)-splitting);
- permutation module \(\operatorname{Ind}_H^G\mathbf 1\simeq
  1\oplus 5a\oplus 5b\oplus 2\cdot 10\oplus 12a\oplus 12b\);
- \(V_Z\otimes\overline F=\) evaluation image of \(\mathcal O_M(1)\) on the orbit;
- Krylov filtration \(K_s(\tau,V_Z)\) = controllability window for
  multiplication by \(\tau\).

### 3.2 Self-attack on candidate proofs

| Candidate argument | Verdict |
|---|---|
| “Any 4-plane in any degree-55 field has \(K_{34}=L\) for all primitive \(\tau\)” | **False.** Planted \(V\subset U_{\tau_0}\) has rank 54 at \(\tau_0\). Any proof of \((A_{\mathrm{empty}})\) must use special information about the marked \(V_Z\). |
| \(F\)-isotypic collapse of the residual using subdegrees | **Ruled out** by maximality / \(\operatorname{Aut}=1\) / geometric-only subdegrees (sealed collapse audit). |
| Unique degree-19 curve through the 55 points \(\Rightarrow G\hookrightarrow\mathrm{PGL}_2\) impossible | **Gap.** \(G\) does not act by automorphisms of the **torsor-dependent** hyperplane \(M\simeq\mathbf P^3\). The argument would require a projective realisation of the Galois action on \(M\) that is not installed. |
| 80/80 modular full rank | **Not a proof.** Random \(V_Z\), finite field; planted control only validates the probe. |
| Dense Fitting elimination of \(\varphi_\tau\) on 52-dim PGL₂ slice | **Forbidden.** Over 8 GiB; retired by post-Elo Path A scope. |

### 3.3 Remaining obstruction (named)

After the orbit code is installed, the exact remaining obstruction is:

> **Position of \(V_Z\) inside the permutation module is known only up to
> dimension four and the geometric \(\mathcal O(1)\)-evaluation description.
> Without expanded power-basis coordinates (Task 1) or a geometric
> no-degree-19-curve theorem for the marked \(G/H\)-orbit on \(X_T\cap M\),
> the ideal of all maximal minors of \(B_{34}(\tau,V_Z)\) cannot be certified
> to miss every primitive \(\tau\) (equivalently: one cannot certify that at
> every primitive \(\tau\) at least one \(55\times 55\) minor is nonzero),
> and no contradiction from \(\lambda V_Z\subseteq U_\tau\) is obtained.**

That is why the exit is `A_EMPTY_UNDECIDED` rather than `A_EMPTY_PROVED`
or `A_EMPTY_REFUTED`.

---

## 4. Modular discovery (shape only, not char 0)

| Probe | Result | Scope |
|---|---|---|
| Random \(V_Z\), 80 primitive \(\tau\) over \(\mathbf F_{101}\) | 80/80 rank \(\varphi_\tau=55\) | `tmp/pathA_collapse/` — not geometric |
| Planted \(V\subset U_{\tau_0}\) | rank 54 | probe is live |
| Random \(B_{34}\) vs \(\varphi_\tau\) agreement | 40/40 both full; planted both 54 | `tmp/a_empty/compare_ranks.json` |

None of these is advertised as characteristic-zero evidence for geometric
\(V_Z\).

---

## 5. Safeguards (still binding if a candidate ever appears)

A pair with \(\operatorname{rank} B_{34}<55\) is **at most** an incidence
candidate.  Qualifying-curve status still requires S1–S6
(`candidate_verifier.py`, `WORKORDER_ELO_TEN_PATHS.md`):

1. four binary forms, no common zero;
2. degree exactly 19;
3. birational onto image;
4. \(Z\) in the image, multiplicity one at all conjugates;
5. no component in the cubic;
6. residual cubic intersection of length exactly two.

No candidate is exhibited in this packet.

---

## 6. Decision exit

| Exit | Status |
|---|---|
| `A_EMPTY_PROVED` | **not taken** — no proof of full rank for geometric \(V_Z\) |
| `A_EMPTY_REFUTED` | **not taken** — no primitive \(\tau\) with rank \(<55\) for geometric \(V_Z\) |
| `A_EMPTY_UNDECIDED` | **taken** — expanded-coordinate status + orbit-code formulation delivered; remaining obstruction named in §3.3 |

**Headline:** OPEN.  
**\(N\text{-}A\):** not claimed.  Even a future proof of \((A_{\mathrm{empty}})\)
would close only the degree-19 Krylov route, not the headline.

### Deliverables

```text
certificates/schur_krylov/A_EMPTY.md
certificates/schur_krylov/vz_power_basis.md
certificates/schur_krylov/vz_power_basis.json
certificates/schur_krylov/orbit_code.md
certificates/schur_krylov/orbit_code.json
certificates/schur_krylov/orbit_code.g
certificates/schur_krylov/verify_a_empty.py
certificates/schur_krylov/SEAL.json   (updated)
```

### Terminal marker

```text
SCHUR_KRYLOV_A_EMPTY_UNDECIDED_HEADLINE_OPEN
```
