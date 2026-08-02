G5-F5-CUBIC-MODEL-PASS

# Goal G5 status — full f5/f6 residue cubics

**Primary exit:** `G5-F5-CUBIC-MODEL-PASS`  
**Also achieved:**
- `G5-RESIDUE-TORSOR-MODEL-PASS` (both sites)
- `G5-F6-CUBIC-MODEL-PASS`

**Not achieved:**
- `G5-F5-RESIDUE-POINT` / `G5-F6-RESIDUE-POINT`
- `G5-F5-POINTLESS-HEADLINE-NEGATIVE` / `G5-F6-POINTLESS-HEADLINE-NEGATIVE`
- `BRIDGE_RESIDUE_NEG.md`

**Headline:** **OPEN**  
**Consumed commit:** `7030ddafb53acdea23070b0d9d20050b592ceb1b`  
**Pinned goal baseline:** `141f6042f628f984771fc79d8d16beb12cedcb94`

## Per-site ledger

| site | torsor model | cubic model | point | pointless |
|---|---|---|---|---|
| `f5` | PASS | `G5-F5-CUBIC-MODEL-PASS` | UNDECIDED | NOT PROVED |
| `f6` | PASS | `G5-F6-CUBIC-MODEL-PASS` | UNDECIDED | NOT PROVED |

## Decision summary

### G5.0 — valuation / residue torsor

Both invariant boundaries \(f_5=0\) and \(f_6=0\) are installed as unramified
rank-one valuations of \(K_{\mathrm{proj}}\) (resp. \(K_{\mathrm{aff}}\)) with:

- geometrically integral centers;
- trivial inertia and full decomposition group \(G\);
- residue transcendence degree three;
- genuine residue \(G\)-torsors by unramified finite-étale reduction;
- gauge independence on the common Hilbert--90 open.

Marker: `G5-RESIDUE-TORSOR-MODEL-PASS`.

### G5.1 — residue cubics

Coefficientwise reduction of the sealed 35-term affine Hilbert--90 cubic
against the free Hironaka module produces exact residue models

\[
\overline X_{f_i}=V(\overline\Phi_{f_i})\subset\mathbf P^4_{\kappa_i}.
\]

- `f5`: all 35 coefficients remain nonzero as module elements.
- `f6`: only `x*x*C` vanishes; 34 nonzero coefficients.
- No common uniformizer content; pure cubes survive; index one via universal
  cycles without claiming a point.
- Smoothness: unramified reduction of the smooth generic twist plus modular
  Jacobian witnesses on specialized fibres.

Markers: `G5-F5-CUBIC-MODEL-PASS`, `G5-F6-CUBIC-MODEL-PASS`.

### G5.2 — point decision

Constant points in a \(\{-2,\ldots,2\}\) box: empty.  
Coordinate-line gcds: units (no line points).  
Modular specializations: always smooth points (discovery only).  
Lane-B pointlessness: not obtained.  
Retired `f5` degree-16 support-\(\le5\) emptiness: **not** used as full
pointlessness.

### G5.3 — bridge

Not entered (no proved pointless residue cubic).

## Theorem boundary

- Structural model pass only. **Not** a Problem-E headline.
- Residue point \(\neq\) global \(X_{\mathrm{gen}}\) point.
- Does not reopen V3-soluble valuation classes.
- Does not claim emptiness from finite support, fixed frames, index one, or
  modular fibres alone.

## Residual gates

1. Exact rational point over \(\kappa_5\) or authorized pointlessness for
   \(\overline X_{f_5}\).
2. Same for \(\kappa_6\).
3. G5.3 bridge only after a proved pointless smooth residue cubic.

## Peak resource

Producer wall \(\approx0.8\) s, peak RSS \(\approx64\) MB (exact free-module
reduction + sympy line gcds + modular probes).  No GB / M2 heavy solve.

## Replay

See `REPLAY.md`. Markers:

```text
G5_MODELS_VERIFY_OK
G5_DECISION_VERIFY_OK
```
