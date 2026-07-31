# T6.2 — Exact binary \(R_1\) decision

**Headline: OPEN.**  
**Exit: `T2R-UNDECIDED`.**  
**Binding:** V2 §3 T6.2; `REPAIR.md` §§1,6.  
**Same open as \(S_2\):** \(S_G\) with \(G\) inverted (T2R.1).

---

## Binary target

Since \(S_G\) is \(S_2\):

- \(\dim\operatorname{Sing}(S_G)\le 1\) \(\Rightarrow\) `T2R-NORMAL` (\(R_1\));
- \(\dim\operatorname{Sing}(S_G)=2\) \(\Rightarrow\) `T2R-NONNORMAL`.

**Neither proved.** Both decisive exits were treated as live; neither was
manufactured.

---

## Upper bound \(\le 2\) (**retained, proved**)

From T2R / PIT on exact-\(\mathbf Q\) unsaturated codimension-two sections of
\(I_{\mathrm{sing}}\): height \(\ge 3\), so \(\dim\le 2\). No genericity. Open
localization only drops dimension.

Ref: `certificates/fold_normalization_t2r/upper_bound_certificate.json`.

---

## Lower bound \(=2\) (**not proved**)

No accepted nonnormal certificate:

- no exact height-three prime of the **open** singular ideal;
- no two-parameter Noether normalization;
- no finite dominant surface map into \(\operatorname{Sing}(S_G)\);
- no sealed irreducible surface component with gate nonvanishing.

**V2 §0 / REPAIR §1.1 respected:** a zero-dimensional **affine** hyperplane
section is **not** used as a dimension proof. The historical T2 cut pairs remain
upper-bound/PIT input only.

Modular cut2 degrees \(\sim 10^3\) after partial gates remain **discovery**.

---

## Normal certificate \(\dim\le 1\) (**not obtained**)

None of the V2-accepted normal certificates completed on \(J_{\mathrm{open}}\):

1. exact Krull dim \(\le 1\) of the fully factorwise-saturated ideal — blocked by
   T6.1;
2. Noether normalization of dim \(\le 1\) — not obtained;
3. unit ideal — not obtained;
4. **projective** hyperplane section of the \(w\)-saturated homogenization
   proving zero-dimensional Proj — not completed (requires sealed \(J_{\mathrm{open}}\)).

---

## Factorwise / modular context (discovery)

msolve grevlex \(\bmod 101\): unsat \(J_0=(P,P_u,\partial P)\) has
\(\dim_{\mathrm{LM}}=3\); after Rabinowitsch sat by \(B\), still
\(\dim_{\mathrm{LM}}=3\). This does **not** decide \(\dim\operatorname{Sing}(S_G)\);
it indicates unsaturated components outside the \(G\)-open / \(H\)-model that
factorwise \(G\)-saturation must remove before a binary decision.

---

## Exit: `T2R-UNDECIDED`

| Serre half on \(S_G\) | Status |
| --- | --- |
| \(S_2\) | proved |
| \(R_1\) | **null** |
| normality / nonnormality | **not decided** |
| \(\dim\operatorname{Sing}(S_G)\) | \(\in\{-\infty,0,1,2\}\) with proved upper bound \(\le 2\) |

```text
BOTTLENECK-T61-EXACT-FACTORWISE-SAT-DIM
BOTTLENECK-T2R-EXACT-SAT-DIM
BOTTLENECK-T2R-LOWER
```

Track T continues **regardless** of a future normal/nonnormal answer (V2 §3.0).
**T6.3 not started** this dispatch.

**Problem E remains OPEN.**
