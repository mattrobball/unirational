C6-DETERMINANTAL-BIRATIONAL-MODEL-PASS

# Goal C6 status — Palatini / determinantal big cell (residual update)

**Primary exit:** `C6-DETERMINANTAL-BIRATIONAL-MODEL-PASS`

**Also achieved:**
- `C6-FIVE-FORM-MATRIX-PASS`
- `C6-RANK-STRATUM-REDUCTION-PASS`
- `C6-EXACT-SPLIT-POINTS-PASS` (residual; split model only)

**Not achieved:**
- `C6-POINT-HEADLINE-POSITIVE`
- `BRIDGE_FANO_POS.md` (no \(K_{\mathrm{proj}}\) Fano point)

**Headline:** **OPEN**

**Pinned goal baseline:** `141f6042f628f984771fc79d8d16beb12cedcb94`

## Decision summary

### C6.0–C6.1 (sealed, retained)

Five-form matrix, \(m(u)=Q(u)\,u\), rank-4 inverse formulas, rank-stratum
reduction.  Not rebuilt in this residual pass.

### C6.2 — point search (residual, deepened)

Lanes A–D re-run with multi-prime exact methods and \(Q(\zeta_{11})\)
arithmetic:

- **Exact** \(u\in D(\mathbf Q)\) with rank \(M(u)=4\) (constant sections).
- Reconstructed common lines over \(\mathbf Q(\zeta_{11})\) with coefficientwise
  Plücker hyperplane identities in \(x\).
- **Not** claimed: \(K_{\mathrm{proj}}\)-points of the twisted \(F_{14,T}\).

Count of height-\(\le 1\) certified points: **12**.
See `POINT.md`, `exact_points.json`, `residual_search.json`.

### C6.3 — headline bridge

Not entered.  Split-model lines still require Morita / \(K_{\mathrm{proj}}\) descent,
Pfaffian–Klein bridge, and G3A dominance.

## Residual gates

1. \(K_{\mathrm{proj}}\) / Morita descent of the \(Q(\zeta_{11})\) common lines.
2. Full C6.3 bridge (Plücker already checked on the split model; open conditions /
   dominance remain).
3. Optional flat secondary-basis expansion of \(M/Q\).
4. Optional scheme-theoretic rank-\(\le 3\) primary decomposition over \(K_{\mathrm{proj}}\).
5. Exact singular locus of the generic quartic (char-0).

## Peak resource (residual)

- wall \(\approx 11.38\) s
- peak RSS \(\approx 80.5\) MB
- GB / msolve: **not invoked** (linear charts + exact cyclotomic linear algebra)

## Replay

See `REPLAY.md`.
