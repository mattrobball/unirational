# T6.1 — Factorwise exact localization

**Headline: OPEN.**  
**Exit: incomplete ledger / no full open ideal sealed.**  
**Binding:** V2 §3 T6.1.  
**Depends on:** T2R4-PASS gates; T6.0 circuit.

---

## Prescription followed

Begin with
\[
J_0=(P,P_u,P_A,P_B,P_Y,P_Z)
\]
and saturate **sequentially** by
\[
\ell,\; P_{uu},\; C,\; \delta,\; A-15,\; B,\; Q_4,
\]
then \(F_{27}\) only if required — **not** by one giant gate product.

---

## Exact characteristic-zero status

| Stage | Exact Krull dim | Projective-closure dim | Unit ideal? |
| --- | --- | --- | --- |
| \(J_0\) unsat | **not completed** (QQ GB stopped) | null | no |
| after each gate | **not completed** | null | no |
| full open \(J_{\mathrm{open}}\) | **not sealed** | null | unknown |

Exact-Q M2/`std` and Singular grevlex on \(J_0\) were started under the exploratory
envelope; after multi-minute runs with multi-GiB RSS and no dim output, they were
**stopped and checkpointed**. Full-product Rabinowitsch was **not** rerun (T2R.5
lesson / V2 resource note).

---

## Modular discovery (not claims)

Portable grevlex bases via `/opt/homebrew/bin/msolve -g 2`:

| Ideal | \(p\) | \(\#\)GB | \(\dim_{\mathrm{LM}}\) | Unit? | Artifact |
| --- | ---: | ---: | ---: | --- | --- |
| \(J_0\) | 101 | 260 | **3** | no | `msolve/J0_p101_g2.out` |
| \(J_0+(1-tB)\) (sat \(M\)) | 101 | 386 | **3** | no | `msolve/J0_sat_M_p101_g2.out` |

Interpretation (discovery):

1. Without \(H\), \(\dim J_0\equiv 3\pmod{101}\) is consistent with a component
   supported in \(V(G)\) (since \(V(P,P_u)\subset V(H)\cup V(G)\)).
2. The retained T2R upper bound \(\dim\operatorname{Sing}(S_G)\le 2\) applies to
   the **\(H\)-forced / \(G\)-open** singular ideal, not automatically to unsat
   \(J_0\) in \(\mathbf A^5\).
3. Saturating by \(M=B\) alone does **not** kill the modular dim-3 piece.

Further sequential modular sats (\(\ell,L,Q_4,P_{uu},C,\delta\)) were queued; only
completed portable GBs are sealed. Empty/incomplete `.out` files are **not**
read as emptiness (REPAIR / p=67 discipline).

---

## \(F_{27}\)

Reconstruction **not** performed this dispatch: not yet required by a sealed
proof that the residual locus after \(L,M,Q_4,\ldots\) lies outside \(G=0\), and
T2R4 status remains `MODULAR_EXECUTABLE_CRT_PENDING`.

---

## Bottleneck

```text
BOTTLENECK-T61-EXACT-FACTORWISE-SAT-DIM
```

Related: `BOTTLENECK-T2R-EXACT-SAT-DIM` (inherited).

---

## Artifacts

```text
certificates/fold_decision_t6/
  FACTORWISE_SATURATION.md
  saturation_ledger.json
  ideals_after_each_gate/   (ledger pointers; exact gens not sealed)
  F27/                      (empty — CRT pending)
  msolve/J0_p101_g2.out
  msolve/J0_sat_M_p101_g2.out
  produce_t61.py
  verify_t61.py
```

**Problem E remains OPEN.**
