G4-INDUCED-DEGREE11-POINT-PASS

# Goal G4 status — A5 index-11 transfer

**Primary exit:** `G4-INDUCED-DEGREE11-POINT-PASS`  
**Also achieved (structural):** coset projectors `1+10` over `Q`; low-arity catalogue  
**Not achieved:** `G4-POINT-HEADLINE-POSITIVE`, `G4-SECANT-RESIDUAL-PASS` (no residual deg 1–2)  
**Headline:** **OPEN**  
**Consumed commit:** `7030ddafb53acdea23070b0d9d20050b592ceb1b`

## Decision

### G4.0 — induction (primary target)

Both nonconjugate maximal A5 classes yield executable induced degree-11 cycles:

1. Coset actions `G ↷ G/H` reconstructed from installed generators; image order 660.
2. Finite étale `L_H/K_proj` of degree 11 (lazy coset basis; no 660-dim expansion).
3. Binding to sealed H_A5 points (`H-A5-CLASS1/2-RATIONAL-POINT`) kept separate.
4. Eleven coset-labeled conjugates; Galois-stable unordered 11-set over `K_proj`.
5. `Phi=0` by H_A5 landing + specialization/equivariance of the generic G-twist
   (G3-frame numeric substitution is residual for G7B, not required for this marker).
6. Cycle defined over `K_proj`, reduced on an explicit open, exact degree 11.

### G4.1 — projectors

Character theory: `||χ_perm||²=2`, `||χ_aug||²=1` ⇒ **`1 + 10`**, not `1+5+5`.
Klein/companion 5-dim irreps of `G` are **not** summands of `Ind_H^G 1`.
Orthogonal projectors `P₁`, `P₁₀` over `Q` verified. Restriction to A5 recovers
an internal `5⊕5` of A5-modules (not the G-pair).

### G4.2 — landing

Formal coset-algebra ops on the pure-trivial cycle give `P₁₀(cycle)=0` and no
`K_proj`-valued W-candidate. Residual: coordinate materialization in G3 frame.

### G4.3 — secants

Abstract Galois-stable secant gates recorded; no residual degree-1/2 intersection
and no certified line/conic. No nonfunctorial chord tree. Next gates: G7B / G7.

### G4.4 — promotion

Not applicable (no `K_proj`-point).

## Theorem boundary

- Structural exit only; **not** a Problem-E headline.
- Degree-11 zero-cycle alone does not improve the already-known index-one statement.
- Does not re-seal H_A5 or G2; does not claim pointlessness.
- Modular-only points were not used as exits.

## Peak resource

Producer: ~0.6 s wall, ~62 MB RSS (exact group of order 660 + sympy projectors).

## Replay

See `REPLAY.md`. Markers:

```text
G4_INDUCTION_VERIFY_OK
G4_OPS_VERIFY_OK
G4_POINT_BOUNDARY_OK
```
