# T2R.5 — Same-open saturated singular dimension

**Headline: OPEN.**  
**Gate: T2R.5 (after T2R4-PASS).**  
**Exit: `T2R-UNDECIDED`.**  
**Binding:** `WORKORDER_CAS_HEADLINE_REVISED.md` §4 T2R.5; `REPAIR.md` §§1,6.  
**Base:** `b222573`.

---

## Exact object

On the common open \(S_G\) (G inverted; T2R.1):

\[
I_{\mathrm{sing}}^{S_G}
=
(H,P,P_u,P_A,P_B,P_Y,P_Z)
:
(\ell\cdot P_{uu}\cdot\delta\cdot C\cdot G)^\infty
\subset
\mathbf Q[A,B,Y,Z,u].
\]

Saturation factors installed in T2R.4:

| Factor | Status |
| --- | --- |
| \(\ell,P_{uu},C,\delta\) | sparse integer TSVs |
| \(G=\operatorname{Res}_u/H\) | exact-quotient circuit; factorization \(c\cdot L\cdot M^4\cdot Q_4\cdot F_{27}^2\) with \(L=A-15\), \(M=B\), \(Q_4\) sparse; \(F_{27}\) modular-executable |

---

## Upper bound \(\dim\le 2\) (**proved**, retained)

Unchanged from T2R.3: exact-Q unsaturated cut2 pairs A,B are zero-dimensional and nonempty; generalized PIT in \(\mathbf A^5\) gives \(\operatorname{height}(I_{\mathrm{sing}})\ge 3\), hence

\[
\dim V(I_{\mathrm{sing}})\le 2
\quad\Rightarrow\quad
\dim\operatorname{Sing}(S_G)\le 2.
\]

No genericity. Open loci only drop dimension.

Certificates: `msolve/Hsing_cut2_nosat_qq.out`, `msolve/Hsing_cut2b_qq.out`.

---

## Lower bound \(\dim\ge 2\) on \(D(G\Sigma)\) (**not proved**)

Acceptable certificates (repair §6 / workorder T2R.5) were **not** obtained:

1. exact height-three prime of \(I_{\mathrm{sing}}^{S_G}\) meeting the open — **no**;
2. exact Noether normalization with two independent parameters — **no**;
3. finite dominant two-parameter map into \(\operatorname{Sing}(S_G)\) — **no**;
4. exact irreducible surface component plus gate nonvanishing — **no**.

**Forbidden argument not used:** hand-selected linear sections alone (REPAIR.md §1.1).

### Discovery (not claims)

| Probe | Result | Status |
| --- | --- | --- |
| Exact Q cut2 unsaturated | 0-dim nonempty | upper bound only |
| Modular \(p=67\) sat \(\ell P_{uu}\) cut2 | 0-dim, deg ~1113–1128 | discovery |
| Modular \(p=67,641\) historical full-ish sat cut2 | 0-dim, deg 1115/1129 | discovery |
| Exact Q sat \(\ell P_{uu}\) cut2 under 8 GiB | unfinished / STOP | not a theorem |
| Full product \(\ell P_{uu}\delta C G\) as single Rabinowitsch gate | densifies (gate deg \(\gtrsim 50\), multi‑10 MB input); not completed under 8 GiB | resource |
| Height-3 prime / Noether / dominant map / Jac-rank surface | not obtained | bottleneck |

---

## Equidimensional decomposition

**Not completed** in characteristic zero under the exploratory ceiling.

Modular shape (discovery): after partial gates, cut2 sections remain zero-dimensional of degree ~10³, consistent with a pure 2-dimensional component on the open, but **not** a purity or lower-bound certificate.

---

## Combined status

\[
\dim\operatorname{Sing}(S_G)
\in\{-\infty,0,1,2\}
\quad\text{with proved upper bound }\le 2.
\]

Nonemptiness of the fully gate-open locus and equality with 2 remain open. Therefore neither \(R_1\) nor its failure is proved on \(S_G\).

| Serre half | Status on \(S_G\) |
| --- | --- |
| \(S_2\) | **proved** (CI + localization; T2R.1) |
| \(R_1\) | **null** (dim unknown) |
| normality / nonnormality | **not decided** |

---

## Conductors (repair §5)

Keep distinct; neither computed:

- \(\mathfrak c_{B\subset S}=\operatorname{Ann}_B(S/B)\)
- \(\mathfrak c_{S\subset\widetilde S}=\operatorname{Ann}_S(\widetilde S/S)\)

---

## Exit: `T2R-UNDECIDED`

### Proved (this dispatch + retained)

1. **T2R4-PASS:** saturation factors \(\ell,P_{uu},C,\delta,G\) executable (G as exact-div circuit with partial factorization).
2. **T2R.1 / \(S_2\)** on \(S_G\) with G inverted.
3. **Upper bound** \(\dim\operatorname{Sing}(S_G)\le 2\).

### Not proved

1. Lower bound \(\dim\operatorname{Sing}(S_G)\ge 2\).
2. Exact Krull dimension / equidimensional decomposition of \(I_{\mathrm{sing}}^{S_G}\).
3. Full char-0 simultaneous saturation by the expanded product including sparse \(F_{27}\).
4. \(R_1\) true or false; normality or nonnormality.

### Named bottlenecks (precise)

```text
BOTTLENECK-T2R-LOWER:
  Produce one of:
    (a) exact height-3 prime of I_sing^{S_G} meeting D(G*Sigma);
    (b) finite dominant map A^2 --> Sing(S_G);
    (c) Noether normalization of I_sing^{S_G} with trdeg = 2;
    (d) exact irreducible 2-dim component + all gates units on a dense open.
  Linear sections alone are forbidden as the sole lower-bound argument.

BOTTLENECK-T2R-EXACT-SAT-DIM:
  With factors installed (T2R4-PASS), compute equidimensional decomposition
  or certified Krull dimension of
    I_sing : (ell*Puu*delta*C*G)^infinity
  in characteristic zero.  Sequential saturation by L,M,Q4,ell,Puu,C,delta
  and modular F27 is available; simultaneous grevlex densifies past 8 GiB.

BOTTLENECK-T2R-F27-SPARSE (optional refinement):
  CRT-expand monic F27 (~6300 terms, large coeffs) for exact sequential
  saturation by that factor without modular reduction.
```

### What T3 must not do

Until a later packet upgrades this exit to `T2R-NONNORMAL` or `T2R-NORMAL`,
**T3 must not consume `T-NONNORMAL`**.

---

## Artifacts

```text
certificates/fold_normalization_t2r/
  SAME_OPEN_DIMENSION.md          # this file
  equidimensional_components.json
  upper_bound_certificate.json
  lower_bound_certificate.json
  verify_same_open_dimension.py
  saturation_factors/*            # T2R.4
  RESULTANT_FACTOR_IDENTITY.md    # T2R.4
  T2R.md, t2r_payload.json, SEAL.json  # updated
```

Independent verifier: `python3 certificates/fold_normalization_t2r/verify_same_open_dimension.py`  
Terminal marker: `FOLD_NORMALIZATION_T2R5_VERIFIER_ACCEPT`.

**Problem E remains OPEN.**
