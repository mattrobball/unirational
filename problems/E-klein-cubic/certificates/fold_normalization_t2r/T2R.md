# Path T / Gate T2R — same-open saturated singular dimension

**Headline: OPEN.**  
**Exit: `T2R-UNDECIDED`.**  
**Binding:** `REPAIR.md` Part I; `WORKORDER_CAS_HEADLINE_REVISED.md` §4.  
**Base:** `b222573`.  
**Depends on:** T1 `T-BIRATIONAL` (retained).  
**Does not authorize:** T3 height-one normalization consuming nonnormality.

---

## Status summary

| Item | Status |
| --- | --- |
| T2R.1 object \(S_G\), G inverted | proved |
| \(S_2\) on \(S_G\) | proved |
| T2R.4 saturation factors | **`T2R4-PASS`** |
| \(\dim\operatorname{Sing}(S_G)\le 2\) | proved |
| \(\dim\operatorname{Sing}(S_G)\ge 2\) | **not proved** |
| \(R_1\) / normality | null / not decided |
| Overall exit | **`T2R-UNDECIDED`** |

---

## T2R.1 — exact scheme (retained)

\[
S_G
=
\bigl(R[u]/(H,P,P_u)\bigr)\bigl[(\Sigma\cdot G)^{-1}\bigr]
=
\bigl(R[u]/(P,P_u)\bigr)\bigl[(\Sigma\cdot G)^{-1}\bigr]
\quad\text{on }D(G),
\]

with \(\Sigma=\langle\ell,P_{uu},\delta,C\rangle\) and \(G\) the complementary resultant factor.

**G is inverted: yes.**  
\(S_2\) holds by CI + localization on this open.

---

## T2R.4 — saturation factors (`T2R4-PASS`)

Installed under `saturation_factors/`:

| Factor | Form |
| --- | --- |
| \(\ell=\mathrm{lc}_u(P)\) | sparse, 31 terms |
| \(P_{uu}\) | sparse, 881 terms |
| \(C\) | sparse, 2630 terms (sealed content) |
| \(\delta\) | Cramer minor of BKK frame, sparse 10507 terms |
| \(G=\operatorname{Res}_u(P,P_u)/H\) | exact-quotient circuit; \(G=c\cdot L\cdot M^4\cdot Q_4\cdot F_{27}^2\) with \(L=A-15\), \(M=B\), \(Q_4\) (21 terms) sparse; \(F_{27}\) modular-executable |

Identity \(\operatorname{Res}_u=H\cdot G\) verified by modular exact division (many good primes) and evaluation probes. See `RESULTANT_FACTOR_IDENTITY.md`.

---

## T2R.5 — saturated dimension (`T2R-UNDECIDED`)

Ideal:

\[
I_{\mathrm{sing}}^{S_G}
=
(H,P,P_u,P_A,P_B,P_Y,P_Z)
:
(\ell\cdot P_{uu}\cdot\delta\cdot C\cdot G)^\infty.
\]

**Upper bound \(\le 2\):** proved by height/PIT on exact-Q unsaturated cut2 (no genericity).  
**Lower bound \(\ge 2\):** not proved. Acceptable certificates (height-3 prime, Noether, dominant map, irreducible surface + gates) not obtained. Linear sections alone forbidden (REPAIR §1.1).

Equidimensional decomposition: not completed under 8 GiB.

See `SAME_OPEN_DIMENSION.md`.

---

## Conductors

\(\mathfrak c_{B\subset S}\) and \(\mathfrak c_{S\subset\widetilde S}\) remain distinct; neither computed. Nonnormality not proved.

---

## Bottlenecks

```text
BOTTLENECK-T2R-LOWER
BOTTLENECK-T2R-EXACT-SAT-DIM
BOTTLENECK-T2R-F27-SPARSE
```

---

## Artifacts

```text
certificates/fold_normalization_t2r/
  T2R.md
  t2r_payload.json
  scheme_t2r1.json
  dimension_bounds.json
  SAME_OPEN_DIMENSION.md
  RESULTANT_FACTOR_IDENTITY.md
  saturation_factors/*
  upper_bound_certificate.json
  lower_bound_certificate.json
  equidimensional_components.json
  produce_t2r.py
  produce_saturation_factors.py
  verify_t2r.py
  verify_saturation_factors.py
  verify_same_open_dimension.py
  SEAL.json
  msolve/
```

Verifiers:

```text
python3 certificates/fold_normalization_t2r/verify_saturation_factors.py
python3 certificates/fold_normalization_t2r/verify_same_open_dimension.py
python3 certificates/fold_normalization_t2r/verify_t2r.py
```

**Problem E remains OPEN.** T3/T4 deferred behind director gate.
