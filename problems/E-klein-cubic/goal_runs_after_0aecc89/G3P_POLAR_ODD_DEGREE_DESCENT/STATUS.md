G3P-POLAR-SYSTEM-PASS

# Goal G3P status — tautological polar geometry and odd-degree descent

**Exit:** `G3P-POLAR-SYSTEM-PASS`  
**Headline:** OPEN  
**G3A input:** `G3A-ARITHMETIC-DOMINANCE-PASS`  
**G4 input:** `G4-INDUCED-DEGREE11-POINT-PASS` (both A5 classes; coordinates residual)  
**G2 input:** `G2-FINITE-GENERATION-PASS`  
**Consumed commit:** `7030ddafb53acdea23070b0d9d20050b592ceb1b`  
**Peak RSS:** 84.9 MB  
**Wall time (produce):** 18.70 s  

## Decision

1. **G3P.0.** Canonical ambient point \(q=[1:0:0:0:0]\) from the identity
   equivariant map / tautological torsor point; \(\Phi(q)=t_3\neq 0\) on an
   explicit open; polar objects \(H_q,Q_q,D_q,I_q\) sealed
   (`G3P-POLAR-SYSTEM-PASS` marker).
2. **G3P.1.** Specialization probes: \(\mathrm{rank}\,Q_q=5\) (smooth quadric
   3-fold), restriction to \(H_q\) rank 4. No certified \(K_{\mathrm{proj}}\)
   section. Clifford fully symbolic class residual.
3. **G3P.2.** Constructions A–D run; no promoted \(K_{\mathrm{proj}}\) cubic
   point. Structural residual: section of \(I_q\to D_q\) or point of \(Q_q\).
4. **G3P.3.** Both A5 degree-11 cycles audited separately. Quadratic Springer
   path **blocked** on missing G3-frame coordinates. Illegal pure-cubic
   odd-degree descent **rejected**.
5. **G3P.4.** Not applicable (no candidate point).

## Residual gates

1. K_proj-point (or odd multisection + Springer) of Q_q or H_q∩Q_q
2. rational point of resolved tangent incidence I_q
3. G3-frame coordinates of G4 degree-11 points (G7B) to enter quadratic Springer path
4. optional: full Clifford class of Q_q over Frac(K_proj)

## Theorem boundary

- Structural exit only; **not** a Problem-E headline.
- Does not claim \(X_{\mathrm{gen}}(K_{\mathrm{proj}})\neq\emptyset\) or emptiness.
- Does not re-run G3C/C6 or invent \(q\) by specializing the invariant field.
- Modular/specialized hits are discovery-only.

## Replay

See `REPLAY.md`. Marker: `G3P_VERIFY_ALL_OK`.
