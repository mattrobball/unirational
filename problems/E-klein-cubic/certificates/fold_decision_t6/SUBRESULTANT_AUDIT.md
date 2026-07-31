# T6.0 — First-subresultant and finite rank-one algebra audit

**Headline: OPEN.**  
**Exit: `T60-UNDECIDED`.**  
**Binding:** `WORKORDER_CAS_DECISION_AFTER_7FDBE42_V2.md` §3 T6.0; `REPAIR.md` §0.  
**Base pin:** `6318461` (worker base).  
**Depends on:** T2R4-PASS factors; T2R.1 object \(S_G\).

---

## Objects

\[
\operatorname{Sres}_1(P,P_u)=s_1(A,B,Y,Z)\,u+s_0(A,B,Y,Z)\in R[u],
\qquad R=\mathbf Q[A,B,Y,Z].
\]

Principal subresultant coefficients: \(\mathrm{PSC}_0=\operatorname{Res}_u(P,P_u)=H\cdot G\)
(installed), \(\mathrm{PSC}_1=s_1\) when \(\deg\operatorname{Sres}_1=1\).

---

## Computation

### Exact circuit (sealed)

`s_0,s_1` are **not** expanded as sparse char-0 multipolynomials. They are installed
as an **exact Ducos subresultant PRS circuit**
(`subresultant_1.circuit.json`):

1. Input sealed \(P\) (1593 terms, \(\deg_u=6\)).
2. \(P_u=\partial_u P\).
3. Ducos PRS until degree \(\le 1\).
4. Read coefficients of \(u^1\) and \(u^0\).

Workorder explicitly allows “exact sparse polynomials **or** exact straight-line
circuits.” Expansion was attempted mod \(67\): intermediate degree-\(2\) PRS poly
had \(\sim 3.5\cdot 10^5\) multipoly terms; the final exact QQ expansion was not
completed under the exploratory densification budget. Circuit remains executable
by evaluation / modular reduction.

### Bézout / subresultant identity

Classically \(\operatorname{Sres}_1\in(P,P_u)\). On \(D(s_1)\) with
\(\deg\gcd=1\), \(u=-s_0/s_1\) in the quotient. The independent verifier replays
this **pointwise** over \(\mathbf Q\) and \(\mathbf F_p\) (univariate PRS), not by
hash alone.

### Is \(s_1\) a unit on \(D(\ell P_{uu}C\delta G)\cap V(H)\)?

**Not proved exactly.** Accepted exact certificates (radical/Nullstellensatz,
factor containment in gates, Bézout with invertible coefficient) were **not**
obtained for the full open.

**Modular discovery only** (not a theorem):

| Prime | \(V(H)\) hits (sampled) | gates-ok (\(L,M,Q_4,\ell,C,P_{uu}\mathrm{-content}\)) | \(s_1=0\) |
| ---: | ---: | ---: | ---: |
| 71 | 475 | 410 | **0** |
| 101 | 429 | 375 | **0** |
| 103 | 398 | 352 | **0** |
| 107 | 445 | 411 | **0** |

Rare \(s_1=0\) points on unrestricted \(V(H)\) always had \(\ell=0\) (and often
\(M=0\) or \(L=0\)) in the recorded samples (`s1_zero_points.out`). This is
**discovery**, not an exact containment \(V(H,s_1)\subset V(\ell)\).

### Relative differentials

On the \(P_{uu}\)-open, pointwise/generic vanishing of \(\Omega_{S/B}\) is
consistent with rank-one fibres. **Not** used to infer flatness or isomorphism
(workorder prohibition).

### Conductors

\(\mathfrak c_{B\subset S}\) and \(\mathfrak c_{S\subset\widetilde S}\) kept
distinct; neither sealed as an ideal. Normalization conductor is null while
\(R_1\) is undecided.

---

## Exit: `T60-UNDECIDED`

| Claim | Status |
| --- | --- |
| Circuit for \(\operatorname{Sres}_1\) | installed |
| Map \(u\mapsto -s_0/s_1\) on \(D(s_1)\) | classical on \(D(s_1)\) |
| \(s_1\) unit on full open | **not proved** |
| \(S_G\simeq B_G\) | **not proved** |
| Normality | **not inferred** (forbidden from isomorphism even if it held) |

Bottleneck:

```text
BOTTLENECK-T60-S1-UNIT-EXACT
```

Secondary: `BOTTLENECK-T60-SRES1-SPARSE-EXPANSION` (optional; circuit is
workorder-legal).

**Do not infer normality from a future `T60-ISOMORPHISM`.**

---

## Artifacts

```text
certificates/fold_decision_t6/
  SUBRESULTANT_AUDIT.md
  subresultant_1.circuit.json
  principal_subresultants.json
  rank_one_algebra_map.json
  relative_differentials.json
  s1_unit_mod_summary.json
  s1_zero_points.out
  produce_t60.py
  verify_t60.py
```

Verifier:

```text
python3 certificates/fold_decision_t6/verify_t60.py
```

**Problem E remains OPEN.**
