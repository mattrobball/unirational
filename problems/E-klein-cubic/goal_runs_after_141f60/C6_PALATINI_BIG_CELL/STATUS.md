C6-DETERMINANTAL-BIRATIONAL-MODEL-PASS

# Goal C6 status — Palatini / determinantal big cell (Morita descent residual)

**Primary exit:** `C6-DETERMINANTAL-BIRATIONAL-MODEL-PASS`

**Also achieved:**
- `C6-FIVE-FORM-MATRIX-PASS`
- `C6-RANK-STRATUM-REDUCTION-PASS`
- `C6-EXACT-SPLIT-POINTS-PASS` (split model; 12 lines over Q(ζ11))
- `C6-MORITA-DESCENT-OBSTRUCTION` (named residual for constant-line descent)

**Not achieved:**
- `C6-POINT-HEADLINE-POSITIVE`
- `BRIDGE_FANO_POS.md` (no \(K_{\mathrm{proj}}\) Fano point)

**Headline:** **OPEN**

**Pinned goal baseline:** `141f6042f628f984771fc79d8d16beb12cedcb94`

## Decision summary

### C6.0–C6.1 (sealed, retained)

Five-form matrix, \(m(u)=Q(u)\,u\), rank-4 inverse formulas, rank-stratum
reduction.  Not rebuilt in this residual pass.

### C6.2 — exact split points (sealed, retained)

Twelve height-\(\le 1\) points \(u\in D(\mathbf Q)\) with \(\operatorname{rank} M(u)=4\)
and reconstructed common lines over \(\mathbf Q(\zeta_{11})\).  See
`exact_points.json`, `POINT.md`.

### C6.2b — Morita / \(K_{\mathrm{proj}}\) descent (this pass)

Packet: `phase_morita_descent/`.

1. **Galois.**  Every sealed Plücker line has
   \(\mathrm{Gal}(\mathbf Q(\zeta_{11})/\mathbf Q)\)-orbit size **2** and
   coordinates in \(\mathbf Q(\sqrt{-11})\).  Not defined over \(\mathbf Q\).
2. **Twisted equivariance.**  Constant sections cannot satisfy
   \(L(gx)=\rho(g)L(x)\): over \(p=23\), \(\dim(\wedge^2 V)^G=0\) and \(V^G=0\)
   for the sealed 6-dimensional representation (group order 1320).  None of the
   12 planes is G-stable.
3. **New \(D(K_{\mathrm{proj}})\) search.**  No projectively-new height-1 point of
   \(D\) over \(\mathbf Q(\sqrt{-11})\); 0 genuine hits in 200000 random
   height-\(\le 2\) trials; C5 degree-\(\le 16\) covariant / short Morita-word
   exclusions retained.

**Not claimed:** any \(K_{\mathrm{proj}}\)-point of \(F_{14,T}\).

### C6.3 — headline bridge

Not entered.

## Residual gates

1. Constant-split-line Morita descent blocked (Gal orbit 2 + \((\wedge^2 V)^G=0\)).
2. No new exact \(u\in D(K_{\mathrm{proj}})\) beyond sealed constant \(\mathbf Q\)-sections
   in the lanes run.
3. Optional: positive-degree secondary-basis sections / rational-function Morita words.
4. Optional: scheme-theoretic rank-\(\le 3\) primary decomposition over \(K_{\mathrm{proj}}\).
5. Exact singular locus of the generic quartic (char-0).

## Peak resource (Morita descent residual)

- wall \(\approx 20.6\) s
- peak RSS \(\approx 53.7\) MB
- GB / msolve: **not invoked**

## Replay

See `REPLAY.md`.
