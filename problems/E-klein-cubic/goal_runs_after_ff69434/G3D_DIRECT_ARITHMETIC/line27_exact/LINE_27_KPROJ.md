# Line-27 algebra toward full K_proj

## Markers
- Specialized secondary-0 RUR: `G3D-LINE-27-RUR-SPECIALIZED-PASS`
- K_t Fano: `G3D-WEIL-FANO-KT-DEGREE27-PASS` (see `WEIL_FANO_KT.md`)
- Progress partial (QQ multi-component): `G3D-LINE-27-KPROJ-PARTIAL`
- **Residual (K_proj only):** `G3D-LINE-27-RUR-KPROJ-OPEN`

## Proven

### Specialized secondary-0 RUR
Degree 27, reduced, irreducible minpoly over QQ, shape-lemma RUR (prior packet).

### No QQ-parameter line on full multi-component equation
All secondary components of G_q imposed; chart params in QQ: empty at tested
specializations.

### Secondary-0 RUR lines are not full S_q lines
Modular secondary-0 RUR point fails higher secondary components.

### K_t = QQ(f7) at t=(2,3,5,7)
Degree-12 field. Chart-0 Fano over K_t: modular multi-prime **degree 27**
(`G3D-WEIL-FANO-KT-DEGREE27-PASS`). Reducedness: residual non-verdict (radical
timeout). No K_t-line certified.

## Residual
**Only free unspecialized `K_proj`** (symbolic t3,t6,t8,t11 and free secondary
generators). The specialized K_t Fano is **decided** — see `weil_fano_kt.json`.

## Non-claims
No K_proj-line, no full free-K_proj RUR, no headline point.
