# CFOSS `w_1` pin — prime-`3` injectivity

**Packet:** Attempt 1, Gate 1, Task 1B.1  
**Date:** 2026-07-30  
**Headline:** OPEN  
**Theorem boundary:** This file pins a literature input. It does not prove a
point on the generic Klein twist and does not decide `PSL_2(F_11)`-unirationality.

---

## 1. Exact theorem number

**Cremona–Fisher–O’Neil–Simon–Stoll, Explicit n-descent on elliptic curves I:
Algebra, Lemma 3.1.**

Statement (source wording, compressed only for line breaks):

```text
Lemma 3.1. If n is prime then w1 is injective.
```

Proof in the source is by citation:

```text
See [5], Proposition 7, or [14], Corollary 5.1.
```

where the source bibliography’s `[5]` / `[14]` are the Schaefer–Stoll / related
`n`-descent references listed in that paper. The injectivity claim used in this
repository is exactly Lemma 3.1 with `n = 3`.

**Not to be confused with:**

| Object | Statement | Role here |
|---|---|---|
| CFOSS I, Lemma 3.2 | `w2` injective for all `n ≥ 2` | not used for prime-`3` Kummer reverse |
| CFOSS I, Corollary 3.12 | `w1(ξ) = det(M) · (R×)^n` for odd `n` | identification of the repository class `alpha_R` with `w1(ξ)` |
| CFOSS III, §2.5 | component decomposition of the first-descent covering | component-torsor bookkeeping, not injectivity |

---

## 2. Hash-pinned source

| Artifact | Value |
|---|---|
| Bibliographic key | J.E. Cremona, T.A. Fisher, C. O’Neil, D. Simon, M. Stoll, *Explicit n-descent on elliptic curves I. Algebra*, arXiv:math/0606580v1 [math.NT], 23 Jun 2006; dated 1st March 2006 |
| arXiv abs | `https://arxiv.org/abs/math/0606580` |
| PDF URL used for pin | `https://arxiv.org/pdf/math/0606580.pdf` |
| **SHA-256 of PDF** | `86f5b9a156c9afffdb3434670012b48bbfdb058ca22f4b2fefac493d5d7d1e01` |
| Local copy (scratch) | `tmp/a1_pfaffian_bridge/cfoss_I.pdf` |
| HTML mirror (ar5iv) SHA-256 | `bcd025e2263969507e712ae62ac378f11f785a718eca9295d99b77e6abd90419` |
| Extracted layout text (scratch) | `tmp/a1_pfaffian_bridge/cfoss_I.txt` |

The lemma text was verified against the PDF layout extraction at the paragraph
beginning “The map w1 is in fact the composite … Lemma 3.1. If n is prime
then w1 is injective.”

---

## 3. Verbatim hypotheses

From CFOSS I, global standing hypotheses for §3 and Lemma 3.1:

1. `E` is an elliptic curve over a perfect field `K`.
2. `n ≥ 2` is an integer with `char(K)` not dividing `n`.
3. **For Lemma 3.1 only:** `n` is **prime**.
4. `R` is the étale algebra of `E[n]` (definition recalled in §4 below).
5. `w1` is the group homomorphism defined in §3 of the source (definition
   recalled in §4 below).

The paper’s introductory algorithm discussion also assumes number-field
Selmer contexts for computation, but **Lemma 3.1 itself is purely algebraic**
and applies to any perfect field of characteristic not dividing the prime `n`.

**Coverage of repository use.** In the Pfaffian local-Kummer packets the base
fields are completed divisorial fields of `K_proj,C` and their residue fields;
all have characteristic zero, so `char ∤ 3`, and are perfect. Thus Lemma 3.1
with `n = 3` applies **as stated**. No extra number-field or global-Selmer
hypothesis is required for injectivity alone.

---

## 4. Object denoted `w1` in the source

### Étale algebra

```text
R = Map_K(E[n], K)          (Galois-equivariant maps E[n] → K)
R̄ = R ⊗_K K̄ = Map(E[n], K̄)
```

### Weil embedding

```text
w : E[n] ↪ R̄× ,   w(S)(T) = e_n(S, T)
```

### Definition of `w1`

For `ξ ∈ H¹(K, E[n])`, Hilbert 90 supplies `γ ∈ R̄×` with
`w(ξ_σ) = σ(γ)/γ`. Set `α = γ^n ∈ R×`. Then

```text
w1(ξ) := α · (R×)^n  ∈  R× / (R×)^n .
```

Equivalently, `w1` is the composite

```text
H¹(K, E[n]) --w_*--> H¹(K, μ_n(R̄)) --Kummer--> R×/(R×)^n .
```

### Corollary used for class identification (not injectivity)

**Corollary 3.12 (n odd).** If `[C → P^{n-1}]` is the Brauer–Severi diagram of
`ξ` and `M ∈ GL_n(R)` describes the `E[n]`-action on `C`, then

```text
w1(ξ) = (det M) · (R×)^n .
```

---

## 5. Object denoted `w1` / `w_1` in this repository

Across the Pfaffian / depressed-cubic packets, the repository uses:

```text
n = 3,
E = Jac(C),   C = the distinguished smooth plane cubic model
               of the minimal fixed-frame triple (e.g. depressed model),
R = Map_K(E[3], K̄)^{G_K}   (rank-nine étale algebra of E[3]),
xi ∈ H¹(K, E[3])           (class of the degree-three covering),
alpha_R ∈ R× / (R×)^3      (saved first-Kummer representative).
```

Operational definition in the installed circuits:

```text
M0 = L(P2)^{-1} L(P1)     (projective translation lift for flex pair),
c  = ell(M0)              (unit scalar cochain),
M  = M0 / c,
alpha_R = det(M) = det(M0) / c^3  ∈ R× / (R×)^3,
```

and the identification

```text
alpha_R = w1(xi)   in   R×/(R×)^3
```

is asserted via **CFOSS I, Corollary 3.12** (odd `n = 3`), not via Lemma 3.1.

Notation variants in-repo: `w1`, `w_1`, sometimes written only through
`alpha_R = w1(xi)`.

---

## 6. Proof that the two conventions agree

| Slot | CFOSS I | Repository | Agreement |
|---|---|---|---|
| Integer `n` | prime for Lemma 3.1; odd for Cor. 3.12 | `n = 3` | yes |
| Group | `H¹(K, E[n])` | `H¹(K, E[3])` for the Jacobian of the plane cubic covering | same functor |
| Étale algebra | `R = Map_K(E[n], K)` | rank-nine algebra of `E[3]` constructed from the 3-division / curve presentation | same object up to unique isomorphism of étale algebras of `E[3]` |
| Map `w` | Weil pairing embedding into `R̄×` | same Weil pairing on `E[3]` | same |
| Class representative | `α (R×)^n` from Hilbert-90 lift of `w(ξ_σ)` | `alpha_R = det(M)` after unit cochain | Cor. 3.12 identifies the det class with `w1(ξ)` |
| Target of injectivity | `R×/(R×)^n` | `R×/(R×)^3` | same for `n = 3` |

Therefore:

- the repository’s **injectivity** citation is CFOSS I **Lemma 3.1** at `n = 3`;
- the repository’s **class identification** `alpha_R = w1(xi)` is CFOSS I
  **Corollary 3.12**;
- no other map called `w1` appears in the prime-`3` Kummer reverse implication.

**Hypotheses check for Cor. 3.12:** `n = 3` is odd; the depressed / xCD plane
models are genus-one normal cubics in `P²` with the standard Brauer–Severi
diagram (trivial Severi–Brauer, since the ambient is `P²`); the circuits produce
`M ∈ GL_3(R)` on a nonempty open. The corollary applies on that open.

---

## 7. Every repository use-site

### A. Prime-`3` injectivity of `w1` (Lemma 3.1)

These sites use injectivity for the reverse Kummer implication
`w1(xi) ∈ w1(δ(E(K)/3)) ⇒ xi ∈ δ(E(K)/3)`:

| Path | Role |
|---|---|
| `tmp/pfaffian_alpha_local_kummer/REPORT.md` | primary local Kummer reduction; uses `w_1` on the connecting image |
| `tmp/pfaffian_alpha_local_kummer/PROOF_AUDIT.md` | ledger; reverse implication |
| `tmp/pfaffian_alpha_local_kummer/core.py` | encoded class `alpha_R = w_1(xi)` |
| `tmp/pfaffian_alpha_local_kummer/certificate.json` | sealed class string |
| `tmp/pfaffian_alpha_local_kummer_audit/REPORT.md` | hostile audit; **first place that names the prime-`n` lemma** |
| `tmp/pfaffian_alpha_local_kummer_audit/PROOF_AUDIT.md` | “CFOSS section 3 first lemma, prime `n=3`” |
| `tmp/pfaffian_alpha_local_kummer_audit/certificate.json` | `w1_reference` string (generic, now superseded by this pin) |
| `tmp/pfaffian_alpha_local_kummer_audit/verify.py` | asserts injectivity flag |
| `tmp/xcd_first_descent_next/REPORT.md` | “for prime `3`, injectivity of `w1` makes any …” |
| `HANDOFF.md` (Pfaffian closure / torsor layer) | “prime-`3` injectivity of `w1` made explicit” |
| `CURRENT_PATHS.md` | same local Kummer chain |
| `RESOLUTION.md` | same local Kummer chain |
| `WORKORDER_FIVE_ATTEMPTS.md` | Task 1B.1 (this pin) |
| `certificates/WP_Z_GATE_REPORT.md` | flags that the citation must be pinned |

### B. Identification `alpha_R = w1(xi)` (Corollary 3.12), not injectivity

| Path | Role |
|---|---|
| `tmp/xcd_generic_cech_next/REPORT.md` | Cor. 3.12 det-normalization |
| `tmp/xcd_generic_cech_next/build_alpha_corrected.py` | encodes Cor. 3.12 |
| `tmp/xcd_generic_cech_next/build_alpha_pilot.py` | pilot citation |
| `tmp/xcd_generic_cech_next/verify_alpha_corrected.py` | replay lock |
| `tmp/pfaffian_depressed_alpha_r/REPORT.md` | `alpha_R = w_1(xi)` |
| `tmp/pfaffian_depressed_alpha_r/PROOF_AUDIT.md` | component-torsor sanity via `w1` |
| `tmp/pfaffian_depressed_alpha_r/build_interface.py` | interface theorem string |
| `tmp/pfaffian_depressed_alpha_r/first_descent_interface.json` | sealed interface |
| `tmp/pfaffian_depressed_alpha_r/verify_interface.py` | component-torsor pass |
| `tmp/pfaffian_depressed_alpha_r/core.py` | construction ledger |

### C. Related CFOSS citations that are **not** Lemma 3.1

| Path | Actual CFOSS object |
|---|---|
| `tmp/xcd_first_descent_next/*` | CFOSS III §2.5 component decomposition |
| `CURRENT_PATHS.md` / `HANDOFF.md` / `SPEC.md` / `RESOLUTION.md` | “CFOSS identifies a distinguished base-defined component” (III §2.5) |

### D. Sites that previously cited injectivity **generically** (debt closed here)

Prior wording such as “CFOSS injectivity”, “lemma: w1 is injective for prime n”,
or “section 3 first lemma” without theorem number and hash is superseded by
§1–§2 of this file. Future arguments must cite:

```text
CFOSS I, Lemma 3.1 (n=3), PDF sha256:86f5b9a156c9afffdb3434670012b48bbfdb058ca22f4b2fefac493d5d7d1e01
```

---

## 8. Does the cited statement cover the repository use?

**Yes, for injectivity of the prime-`3` map**

```text
w1 : H¹(K, E[3]) → R×/(R×)^3
```

on perfect characteristic-zero fields (completed divisorial fields and residue
fields of the Pfaffian models).

**Scope delimiters (not failures of Lemma 3.1):**

1. Lemma 3.1 does **not** by itself identify `alpha_R` with `w1(xi)`; that is
   Corollary 3.12 plus the circuit that builds `M`.
2. Lemma 3.1 does **not** decide local or global solubility; it only makes
   membership of `alpha_R` in the Kummer image equivalent to membership of
   `xi` in `δ(E(K)/3)`.
3. Lemma 3.1 is **not** part of the abstract Hermitian / common-isotropic-line
   bridge from a Morita idempotent to `C_gen` (see `BRIDGE_AUDIT.md`). It is a
   theorem input for the **genus-one first-descent coordinate path** on the
   depressed / plane models of the symmetric cubic.

---

## 9. Strict boundary

- No Selmer computation.
- No point or nonpoint on the residual cubic, the full fixed-frame cubic, or
  the generic Klein twist.
- Headline remains **OPEN**.
