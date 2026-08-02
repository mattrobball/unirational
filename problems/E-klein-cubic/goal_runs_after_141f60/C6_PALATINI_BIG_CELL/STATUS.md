C6-DETERMINANTAL-BIRATIONAL-MODEL-PASS

# Goal C6 status — Palatini / determinantal big cell (positive-degree residual)

**Primary exit:** `C6-DETERMINANTAL-BIRATIONAL-MODEL-PASS`

**Also achieved:**
- `C6-FIVE-FORM-MATRIX-PASS`
- `C6-RANK-STRATUM-REDUCTION-PASS`
- `C6-EXACT-SPLIT-POINTS-PASS` (split model; 12 lines over Q(ζ11))
- `C6-MORITA-DESCENT-OBSTRUCTION` (named residual for constant-line descent)
- `C6-POSITIVE-DEGREE-RESIDUAL` (bounded non-constant / Morita-linear ansätze)

**Not achieved:**
- `C6-POINT-HEADLINE-POSITIVE`
- `BRIDGE_FANO_POS.md` (no \(K_{\mathrm{proj}}\) Fano point)

**Headline:** **OPEN**

**Pinned goal baseline:** `141f6042f628f984771fc79d8d16beb12cedcb94`

## Decision summary

### C6.0–C6.1 (sealed, retained)

Five-form matrix, \(m(u)=Q(u)\,u\), rank-4 inverse formulas, rank-stratum
reduction.  Not rebuilt in residual passes.

### C6.2 — exact split points (sealed, retained)

Twelve height-\(\le 1\) points \(u\in D(\mathbf Q)\) with \(\operatorname{rank} M(u)=4\)
and reconstructed common lines over \(\mathbf Q(\zeta_{11})\).  See
`exact_points.json`, `POINT.md`.

### C6.2b — Morita / \(K_{\mathrm{proj}}\) descent (sealed, retained)

Packet: `phase_morita_descent/`.  Constant lines blocked (Gal orbit 2 +
\((\wedge^2 V)^G=0\)); no new height-bounded \(D(\mathbf Q(\sqrt{-11}))\) points.

### C6.2c — positive-degree / rational-function Morita sections (this pass)

Packet: `phase_positive_degree/`.

1. **Interface.**  Secondary basis of \(K_{\mathrm{proj}}\) over
   \(P_0=\mathbf Q(t_3,t_6,t_8,t_{11})\) and Morita twelve-word module installed
   as the coordinate frame for non-constant sections of \(D\).
2. **Fibre-independence of \(D\).**  Normalized modular \(Q_x\) agrees across
   tested good fibres; sealed points lie on every tested fibre (exact minors
   sample + modular multi-fibre for all twelve).
3. **Bounded ansätze (no constructive survivor):**
   - linear / affine maps \(x\mapsto u\) (deg 1; \(12\mathrm{k}\) random trials each over \(\mathbf F_{23}\));
   - diagonal quadratic + affine (deg 2; \(8\mathrm{k}\) trials);
   - rational degree \(1/1\) (\(6\mathrm{k}\) trials);
   - lines on \(D\) through sealed points: exhaustive direction height \(\le 2\),
     height-3 random sample; multi-prime lift empty;
   - secondary sparse support \(\le 2\) reduces to constants/lines;
   - Morita twelve-word with degree-1 coefficients in \(x\): no survivor on the
     multi-fibre \(\mathbf F_{23}\) screen (\(4\mathrm{k}\) nonconstant trials).
4. **Retained C5 exclusions.**  Homogeneous Fano covariants through deg 16;
   short Morita words; constant twelve-word rank 78; deg-17 support \(\le 4\).

**Not claimed:** emptiness of all of \(D(K_{\mathrm{proj}})\) or of all
positive-degree sections outside the named bounds.

### C6.3 — headline bridge

Not entered.

## Residual gates

1. Constant-split-line Morita descent blocked (Gal orbit 2 + \((\wedge^2 V)^G=0\)).
2. No constructive non-constant section of \(D\) / Morita common line within the
   named positive-degree / rational / Morita-linear bounds.
3. Optional beyond bounds: higher-degree polynomial maps into \(D\); full
   projective degree-17 landing scheme; longer Morita words; secondary
   support \(\ge 3\) with nontrivial relations.
4. Optional: scheme-theoretic rank-\(\le 3\) primary decomposition over \(K_{\mathrm{proj}}\).

## Peak resource (positive-degree residual)

- wall \(\approx 63.2\) s
- peak RSS \(\approx 63.6\) MB
- GB / msolve: **not invoked**

## Replay

See `REPLAY.md`.
