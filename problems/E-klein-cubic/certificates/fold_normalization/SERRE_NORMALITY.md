# Path T / T2 — Serre normality computation plan (not executed)

**Status: PLAN ONLY.  No T2 computation has been run under this dispatch.**  
**Depends on:** Gate T1 exit `T-BIRATIONAL` (proved in `FINITE_BIRATIONAL.md`).  
**Does not authorize:** T3 conductor/discriminant pullback, T4 class-group ledger.  
**Headline:** OPEN.

---

## 0. Goal

Prove that the simple-fold algebra

\[
S=\bigl(B[u]/(P,P_u)\bigr)\bigl[\Sigma^{-1}\bigr],
\qquad
B=\mathbf Q[A,B,Y,Z]/(H),
\]

satisfies Serre’s criterion \(S_2+R_1\) on the simple-fold open, hence is normal,
and therefore is the **normalization of \(B\)** on that open.

Exit markers (when eventually run):

- **`T-NORMAL`:** \(S\) normal on the simple-fold open.
- **`T-NONNORMAL`:** further normalization defect + local conductor description.

---

## 1. Why this is cheaper than normalizing \(H\) directly

| Route | Ambient | Equations | Size |
| --- | --- | --- | --- |
| Direct Jacobian of \(H\) (retired for T1–T2) | \(\mathbf A^4\) | \(H,\partial_A H,\partial_B H,\partial_Y H,\partial_Z H\) | deg 43; \(\sim\)32k–38k terms each |
| **Fold presentation (this plan)** | \(\mathbf A^5_{A,B,Y,Z,u}\) | \(P,P_u\) (and gates) | deg\(_u\le 6\); \(P\) has **1 593** terms |

T1 already proves \(S\) is finite birational over \(B\).  Normality of \(S\) is
therefore equivalent to \(S\cong \widetilde B\) on the simple-fold open, without
ever building a GB of the Jacobian of \(H\).

---

## 2. Exact dimensions

| Object | Dimension | Justification |
| --- | --- | --- |
| Ambient \(R[u]=\mathbf Q[A,B,Y,Z,u]\) | 5 | polynomial ring |
| Fold scheme \(V(P,P_u)\subset\mathbf A^5\) (before component selection) | expected 3 | 2 equations; critical locus of a relative \(\mathbf P^1\)-cover of \(\mathbf A^4\) |
| Target branch \(D=V(H)\subset\mathbf A^4\) | 3 | irreducible hypersurface |
| \(S\) (finite over open of \(D\)) | 3 | T1 finiteness + dominance |
| Singular locus of \(S\) for \(R_1\) | need \(\le 1\) | codimension \(\ge 2\) in a 3-fold |

**Complete-intersection expectation.**  
On the open where the complementary resultant factor \(G\) (from
\(\operatorname{Res}_u(P,P_u)=H\cdot G\)) and the gates \(\Sigma\) are inverted, \(H\) is a
consequence of \((P,P_u)\) along the selected component, and \(S\) is a
localization of \(R[u]/(P,P_u)\).  If \((P,P_u)\) is a regular sequence at the
relevant primes, \(R[u]/(P,P_u)\) is a complete intersection of dimension 3,
hence Cohen–Macaulay, hence satisfies \(S_k\) for all \(k\) (in particular \(S_2\)).

---

## 3. Plan for \(S_2\) (Cohen–Macaulay / complete intersection)

### Step S2-a — regular sequence check for \((P,P_u)\)

1. Prove \(P\) is a nonzerodivisor in \(R[u]\) (immediate: \(R[u]\) domain, \(P\neq 0\)).
2. Prove \(P_u\) is a nonzerodivisor in \(R[u]/(P)\).  
   Equivalent: \(P_u\) is not a zerodivisor on the hypersurface \(V(P)\).  
   **Computational form:** show
   \[
   \operatorname{Ann}_{R[u]/(P)}(P_u)=0
   \]
   on the simple-fold open, or that every associated prime of \((P)\) does not
   contain \(P_u\) after inverting \(\Sigma\).
3. **Alternative (preferred if cheaper):** exhibit a Gröbner basis of \((P,P_u)\)
   whose leading-term ideal is a complete intersection / has CM quotient
   (e.g. \({\lt}(P),{\lt}(P_u)\) regular sequence in the monomial ring).

### Step S2-b — localization at \(\Sigma\) preserves CM

Cohen–Macaulayness is local and preserved by localization.  Once
\(R[u]/(P,P_u)\) is CM of dimension 3 at primes meeting \(\Sigma\), so is \(S\).

### Step S2-c — optional Fitting / projective dimension

If a free resolution of \(S\) as \(R[u]\)-module (or as \(B[u]\)-module) is
obtained with projective dimension \(\le 2\) (Hilbert–Burch / Hilbert–Burch-type
for two generators, or pd \(\le \mathrm{depth}\) by Auslander–Buchsbaum), record
the Betti table as a CM certificate.

### Resource floors for \(S_2\)

| Probe | Matrix / module size | Term count | Sparse floor | Dense floor | 8 GiB? |
| --- | --- | --- | --- | --- | --- |
| Grevlex GB of \((P,P_u)\) in 5 vars over \(\mathbf Q\) | 2 generators, \(\deg\le 13\) total | \(P\): 1593; \(P_u\): \(\sim\)1200 | **≪ 1 GiB** expected (fold GB already used in prior modular probes under 8 GiB) | N/A if sparse | **YES — try** |
| Same mod good prime \(p\sim 10^3\)–\(10^9\) | as above | as above | **≪ 1 GiB** | N/A | **YES** |
| Ann / colon \((P:P_u)\) or saturation by \(\Sigma\) | colon ideal in 5 vars | intermediate GB dependent | plan 1–4 GiB RSS | if densifies: stop | **probe under 8 GiB; STOP if floor exceeds** |
| Betti table via M2 `resolution` | pd expected \(\le 2\) | small | **≪ 1 GiB** | N/A | **YES** |

**If any exact-\(\mathbf Q\) GB of \((P,P_u)\) is projected to exceed 8 GiB RSS:** STOP,
emit the monomial-order, variable-order, and measured modular floors, and
request director authorization.  That STOP is a success under house rules.

**Certificate format (S2).**

```text
certificates/fold_normalization/s2_cm_certificate.json
  - presentation: "R[u]/(P,Pu)" or "B[u]/(P,Pu)"
  - regular_sequence: true/false with proof mode
  - dim, depth, codim
  - betti_table (if computed)
  - gates_inverted: ["lc_u","P_uu","delta","C"]
  - no timing fields
```

---

## 4. Plan for \(R_1\) (regular in codimension one)

### Step R1-a — Jacobian criterion on the fold

On the open \(\Sigma\), \(S\) is cut out in \(\mathbf A^5\) by \((P,P_u)\) (CI case) or by
\((H,P,P_u)\) with the relation \(\operatorname{Res}=H\cdot G\).  Form the Jacobian matrix:

**CI presentation (preferred):**

\[
J_{\mathrm{fold}}
=
\begin{pmatrix}
\partial_A P & \partial_B P & \partial_Y P & \partial_Z P & \partial_u P \\
\partial_A P_u & \partial_B P_u & \partial_Y P_u & \partial_Z P_u & \partial_u P_u
\end{pmatrix}
=
\begin{pmatrix}
P_A & P_B & P_Y & P_Z & P_u \\
P_{uA} & P_{uB} & P_{uY} & P_{uZ} & P_{uu}
\end{pmatrix}.
\]

Singular locus of the CI:

\[
\operatorname{Sing}
=
V\bigl(P,\,P_u,\,\text{all }2\times 2\text{ minors of }J_{\mathrm{fold}}\bigr)
\]

inside \(\mathbf A^5\), then restrict / saturate away from \(V(\Sigma)\).

**Need:** \(\dim\operatorname{Sing}_{\Sigma} \le 1\) (codim \(\ge 2\) in the 3-fold \(S\)).

### Step R1-b — structure of minors

- There are \(\binom{5}{2}=10\) minors of size \(2\times 2\).
- One minor is \(P_u\cdot P_{uu}-P_u\cdot P_{u\text{-something}}\) etc.; the minor from
  columns \((Z,u)\) involves \(P_{uu}\) heavily.
- On the simple-fold open \(P_{uu}\neq 0\), several rows simplify: the condition
  \(P=P_u=0\) and \(\operatorname{rank} J_{\mathrm{fold}}<2\) becomes a determinantal condition
  of expected codimension 2 in the fold (standard for \(A_n\) / plane-curve
  singularities of the cover).

### Step R1-c — dimension certificate

1. **Modular discovery (not char-0 claim):** grevlex GB of
   \((P,P_u,\{2\times 2\text{ minors}\})\) mod several good primes; record dim.
2. **Exact char-0:** either
   - complete the same GB over \(\mathbf Q\) under 8 GiB; or
   - a radical membership / saturation proof that every component of the
     critical ideal meets \(V(\Sigma)\) or has dimension \(\le 1\); or
   - a Noether normalization + generic fibre emptiness argument reducing to a
     univariate/bivariate check (analogous to the T1 line method).
3. **Forbidden:** pointwise sampling of a positive-dimensional critical locus
   as a substitute for dimension (house rule).

### Resource floors for \(R_1\)

| Probe | Generators | Expected deg | Sparse floor | Dense floor | 8 GiB? |
| --- | --- | --- | --- | --- | --- |
| 2×2 minors of \(J_{\mathrm{fold}}\) | 10 polys | \(\le 10\)–12 in 5 vars | each minor: products of partials of \(P\); partials of \(P\) have \(\le 1593\) terms, products may reach \(10^5\)–\(10^6\) terms | worst dense monomial basis for deg 12 in 5 vars: \(\binom{12+5}{5}\approx 6188\) mons — **tiny** | **YES for sparse; dense is fine** |
| Ideal \((P,P_u,\text{minors})\) GB mod \(p\) | 12 gens | — | prior fold modular GBs completed under 8 GiB | N/A | **YES — start here** |
| Same over \(\mathbf Q\) | 12 gens | — | estimate **0.5–4 GiB** if modular stays sparse | if intermediate densifies past 8 GiB: **STOP + report** | **conditional** |
| Saturation by \(\ell\cdot P_{uu}\cdot\delta\cdot C\) | + colon steps | — | colon can be the bottleneck | same STOP rule | **probe** |

**Contrast with retired \(H\)-Jacobian route.**

| | Fold minors (this plan) | \(H\)-Jacobian (avoid) |
| --- | --- | --- |
| # variables | 5 | 4 |
| generator terms | \(\sim 10^3\)–\(10^6\) | \(\sim 3\cdot 10^4\) each × 5 |
| degree | \(\le 12\) | 43 |
| prior modular status | fold structure probes completed | grevlex of \((H,\partial H)\) **incomplete** at seal under 8 GiB |

---

## 5. Checkpoint plan

```text
CKPT-0  inputs: sealed P, H, Σ definitions, T1 seal
CKPT-1  modular dim of (P, Pu) and of Sing_fold mod {67, 641, ...}
CKPT-2  exact regular-sequence / CM certificate for (P, Pu)[Σ^{-1}]
CKPT-3  exact dim of Sing_fold after Σ-saturation  (need ≤ 1)
CKPT-4  assemble T-NORMAL or T-NONNORMAL + local equations of defect
CKPT-5  SEAL.json (self-hashes after last payload byte; no timing fields)
```

Each checkpoint writes a JSON ledger under

```text
certificates/fold_normalization/t2_ckpts/CKPT-k.json
tmp/postelo_T/t2/          # scratch only
```

Abort rules:

- any step with projected RSS \(> 8\) GiB → STOP with formulation + floors;
- no pointwise treatment of positive-dimensional sing loci;
- modular ranks are discovery only until a char-0 lift/argument is written;
- do not start T3/T4 from this plan without a director gate.

---

## 6. Certificate format (when T2 is executed)

```text
certificates/fold_normalization/SERRE_NORMALITY.md      # this plan → update to proof
certificates/fold_normalization/s2_cm_certificate.json
certificates/fold_normalization/r1_singular_locus.json
certificates/fold_normalization/serre_payload.json
certificates/fold_normalization/SEAL.json                # refreshed after T2
```

Each JSON must state:

1. what is proved / not proved;
2. exact dimensions and degrees;
3. gate list \(\Sigma\);
4. independent verifier command;
5. **no timing fields**;
6. self-hashes only after the last payload byte.

---

## 7. Independent verifier design

**Producer / verifier split (mandatory).**

| Role | Path | Imports |
| --- | --- | --- |
| Producer | `certificates/fold_normalization/produce_t2.py` (future) | may use scratch builders under `tmp/postelo_T/t2/` |
| Verifier | `certificates/fold_normalization/verify_t2.py` (future) | **must not import producer**; reloads sealed polynomials from TSV; recomputes dim/degree/minors or checks sealed GB certificates |

**Verifier obligations:**

1. Reload \(P\) from the primitive TSV; recompute \(P_u,P_{uu}\) by differentiation.
2. Reload sealed \(H\) only as the base ring equation (not re-eliminated).
3. Recompute the Jacobian minors from \(P\) (not from a sealed minor cache without check).
4. Re-run dimension of the singular ideal over \(\mathbf Q\) or check a sealed
   Gröbner/basis certificate with an independent engine (M2 ↔ Singular cross-check).
5. Confirm \(\dim\operatorname{Sing}\le 1\) and CM/depth claims match the payload.
6. Confirm headline remains OPEN unless a full Problem E proof standard is met.
7. Print a terminal marker, e.g. `FOLD_NORMALIZATION_T2_VERIFIER_ACCEPT`.

**Engines (absolute paths):**

```text
/opt/homebrew/bin/M2
/opt/homebrew/bin/Singular
/opt/homebrew/bin/python3
```

(`gap`/`gp` remain git aliases — never bare names.)

---

## 8. Memory and house-rule summary

| Rule | Application to T2 |
| --- | --- |
| 8 GiB exploratory gate | all T2 GBs and saturations |
| Exact arithmetic for conclusions | modular = discovery/shape only |
| No full class group | T2 does not touch Cl |
| No pointwise positive-dim sing | dim certificates only |
| No re-elim of \(u\) for \(H\) | \(H\) is sealed input |
| No T3/T4 in this dispatch | plan stops at Serre |

---

## 9. Decision boundary after a future T2 run

- If \(S_2+R_1\) hold: seal **`T-NORMAL`**, authorize T3 (conductor + discriminant
  pullback mod 3) at a director gate.
- If \(R_1\) fails along an explicit divisor: seal **`T-NONNORMAL`**, compute only
  the local normalization defect needed for the 3-primary conductor analysis.
- If resource floors block exact dim: seal **`T2-STOP-RESOURCE`** with the
  formulation above — counts as a successful resource report, not a silent fail.

---

## 10. Explicit non-claims of this document

This file is a **plan**.  It does **not** prove \(S_2\), does **not** prove \(R_1\),
does **not** claim \(S\) is the normalization, and does **not** compute conductors
or class groups.  Problem E remains **OPEN**.
