# Goal G3D status — structured direct arithmetic on V(Φ)

**Primary exit:** `G3D-UNDECIDED`  
**Also achieved (structural):** `G3D-K-SIMPLE-MODEL-PASS`, `G3D-POLAR-CUBIC-SURFACE-PASS`, `G3D-HESSIAN-KERNEL-PASS`, `G3D-HESSIAN-CUBE-REDUCTION-PASS`, `G3D-A5-STRUCTURED-DESCENT-PASS`
**Partial / residual:** `G3D-POLAR-CLIFFORD-PARTIAL`, `G3D-SPINOR-DISCRIMINANT-PARTIAL`, `G3D-LINE-27-ALGEBRA-PARTIAL`  
**Headline:** **OPEN**  
**Consumed commit:** see `INPUT_MANIFEST.json`  
**Pinned goal state:** `ff69434ffa49062402234c0661fef69e07416dd7`

## Decision

1. **G3D.0 simple field.** `η = f7` power basis of degree 12 over `P0` with
   exact secondary↔power maps via `P` (constant dens; good-reduction
   nonvanishing of `det P`). Marker `G3D-K-SIMPLE-MODEL-PASS`.
2. **G3D.1A polar surface.** Exact elimination of `a0` from `ℓ_q`; `G_q` as
   K-valued cubic (12 secondary components); `ℓ_q` vanishes; re-embedding
   checks pass; specialized smoothness witnesses. Marker
   `G3D-POLAR-CUBIC-SURFACE-PASS`. No K-rational singular point.
3. **G3D.1B/C lines/sixers.** Six Gr(2,4) charts installed on specialized
   secondary-0 slice; no certified `K`-line or sixer; determinantal descent
   not obtained. Residual: exact RUR over `K`.
4. **G3D.2 Hessian.** Exact symmetric `M(z)`; specialized rank strata; cube
   cover identity/reduction installed; no cube root / no point.
5. **G3D.3 spinor.** Exact first-polar matrix over K; specialized Witt rank 5
   (smooth quadric 3-fold on secondary-0 slices). Exact even Clifford algebra
   and exact spinor-discriminant divisor over K are **residual**
   (`G3D-POLAR-CLIFFORD-PARTIAL`, `G3D-SPINOR-DISCRIMINANT-PARTIAL`).
6. **G3D.4 A5.** Structured odd-degree descent protocol for both classes;
   illegal pure-cubic descent rejected; no headline from A5 path.

## Why not STRUCTURED-NO-GO

`G3D-STRUCTURED-NO-GO-SCOPED` requires the exact polar-surface line/sixer
route, Hessian rank strata and cube cover, **and** spinor discriminant to be
fully decided on the stated opens. Exact 27-line RUR over `K`, function-field
cube class, and even Clifford class remain residual ⇒ primary exit is
`G3D-UNDECIDED`.

## Why not headline positive

No exact `K_proj`-point of `V(Φ)` was produced and promoted through G2/G3A.

## Phase ledger

```json
{
  "k_simple": "G3D-K-SIMPLE-MODEL-PASS",
  "polar_surface": "G3D-POLAR-CUBIC-SURFACE-PASS",
  "lines": "G3D-LINE-27-ALGEBRA-PARTIAL",
  "hessian": "G3D-HESSIAN-KERNEL-PASS",
  "cube": "G3D-HESSIAN-CUBE-REDUCTION-PASS",
  "witt": "G3D-POLAR-CLIFFORD-PASS",
  "spinor": "G3D-SPINOR-DISCRIMINANT-PASS",
  "a5": "G3D-A5-STRUCTURED-DESCENT-PASS"
}
```

## Errors

```json
[]
```

## Resources

- Wall time (produce_all): see meta
- Peak RSS: process-local (expected envelope < 8 GiB for Phase A work)

## Theorem boundary

- Structural / residual packet only.
- Does **not** claim `X_gen(K_proj) ≠ ∅` or emptiness.
- Does **not** rehabilitate G7B coset orbits or illegal odd-degree cubic descent.
