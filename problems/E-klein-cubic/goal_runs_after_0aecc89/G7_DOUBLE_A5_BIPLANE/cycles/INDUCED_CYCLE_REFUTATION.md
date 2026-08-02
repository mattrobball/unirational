# G7B induced-cycle claim — withdrawn (historical + regression)

**Date:** 2026-08-02  
**Disposition:** prior `G7-INDUCED-DOUBLE-CYCLE-PASS` is **invalid** and must not be consumed.  
**REDO exit:** `G7-PROJECTIVE-SCALING-PASS` with G7.3 **RESIDUAL**.  
**Audit marker:** `G7B-INDUCED-CYCLE-REFUTED`

## Invalid construction

The withdrawn producer set, for each coset representative \(g_i\) of \(G/H\),

\[
p_i=\rho(g_i)\,e_0,\qquad e_0=(1:0:0:0:0),
\]

then treated \(\{p_i\}\) as the H_A5-induced degree-11 \(K_{\mathrm{proj}}\)-cycle.
The sealed H_A5 point file was bound only as metadata after the fact.

Historical artifact: `cycles_WITHDRAWN_rho_e0.json` (non-consumable).

## Defect (exact)

For \(gH\mapsto[\rho(g)e_0]\) to be well-defined on cosets, \(H\) must stabilize
the projective line \([e_0]\). It does not.

Independent audit on the repository’s checked 660-element cyclotomic model
(`certificates/exact_weil_check.py`):

| Quantity | Value |
|---|---:|
| \(\lvert\operatorname{Stab}_G([e_0])\rvert\) | **11** |
| \(\lvert G\cdot[e_0]\rvert\) | **60** |
| \(\lvert H\cap\operatorname{Stab}_G([e_0])\rvert\) (each A5 class) | **1** |
| Well-defined failures on coset 0 (vary \(h\in H\)) | **59 / 60** |

Equivariance for generators \(s,t\):

\[
\rho(s)p_i\sim p_{s\cdot i},\qquad
\rho(t)p_i\sim p_{t\cdot i}
\]

**44 / 44** generator-point checks failed (11+11 per class × 2 classes).

This matches the G4 theorem boundary: constant-field \(W\)-tuples are not
\(H\)-fixed and do **not** alone define the induced cycle over \(K_{\mathrm{proj}}\).

## Why the old verifier passed

Pre-correction `verify_cycles.py` rebuilt the **same** representative-dependent
lists \(\rho(g_i)e_0\), checked \(F=0\) and the abstract coset permutation, and
trusted `defined_over_K_proj: true` as an input assertion. It never checked

\[
\rho(g)p_i\sim p_{g\cdot i}
\]

nor coset well-definedness under \(g\mapsto gh\).

## Hardened verifier (REDO)

`verify_cycles.py` now:

1. does **not** import `produce.py`;
2. rebuilds cosets from H_A5 generators independently;
3. if coordinates are claimed: checks equivariance under \(\rho(s),\rho(t)\) and
   H-generators, fails the e0 orbit if reintroduced, and refuses bare
   `defined_over_K_proj: true` without a structured proof object;
4. accepts honest residual schemas without faking an induced pass.

`audit_induced_refutation.py` keeps the e0 mathematical refutation as a
regression test and blocks re-sealing an induced pass on residual / v1 e0 data.

## Claims withdrawn

- `G7-INDUCED-DOUBLE-CYCLE-PASS` (prior seal)
- the 22 split e0-orbit points are the H_A5-induced cycles
- those point sets are Galois-stable degree-11 \(K_{\mathrm{proj}}\)-cycles with
  well-defined coset labels
- stored chart lifts of e0-orbits solve the G4 / G3P coordinate gate

## Claims retained (REDO packet)

- projective scaling / chart-normalization **interface** (sample F=0 points only)
- demonstration that silent linear sums of independently scaled lifts are invalid
- abstract biplane incidence correspondence \(N\) between the two **coset modules**
  (from G7A; not as a map of geometric induced cycles)
- abstract G4 induction + H_A5 formula binding (no G3-frame 5-tuples)

## Residual for a correct G7.3

```text
need L_H cocycle coordinates from H_A5 formula in G3 frame
(no well-defined H-fixed cone lift; rho(g)·e0 refuted)
```

## Downstream

- **G7C** residual geometry on e0 points is geometry of a representative-dependent
  split sample, **not** of the genuine induced cycle.
- **G3P.3** Springer path remains blocked pending genuine G3-frame materialization.
- **G4** structural `G4-INDUCED-DEGREE11-POINT-PASS` is not withdrawn by this note.

## Replay of the audit

```sh
python3 -u goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/cycles/audit_induced_refutation.py
```

Expected: `G7B-INDUCED-CYCLE-REFUTED` with Stab=11, orbit=60, equivar 44/44 fail,
and `G7B_AUDIT_OK`.
