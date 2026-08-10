# V14 formalization — centralizer obstruction

Lean 4 + Mathlib formalization of writeup Theorem 3.1 and Corollary 6.1
(`../writeups/v14_not_weakly_versal.tex`).

**Policy: zero project axioms, zero `sorry`/`admit`, full proofs.**

## Build / verify

```bash
lake build
lake env lean AxiomAudit.lean
./scripts/verify.sh
```

Toolchain: Lean `v4.32.1`, Mathlib `v4.32.1`.

## Headline theorems

| Lean | Writeup |
|------|---------|
| `centralizerObstruction` | Thm 3.1: ∀ faithful linear V, no G-eq. rational map ℙ(V) ⇢ Y |
| `noDegenerates_of_centerless_involution` | Thm 3.1 parenthetical (**proved**) |
| `V14App.V14_not_weakly_versal` | Cor 6.1 shape: not weakly versal |
| `V14App.V14_no_equivariant_map_from_faithful_rep` | Cor 6.1 ∀ faithful linear rep |
| `V14App.V14_not_GUnirational` | Cor 6.1 not G-unirational (dominant) |

All depend only on classical Lean axioms: `propext`, `Classical.choice`, `Quot.sound`.

## Faithfulness highlights

* **ℙ(V)** = Mathlib `Projectivization` of a `FaithfulLinearRep` (coupled)
* **ℙ(V₊)** = `{x | x.submodule ≤ plusEigenspace ρ(σ)}` (coupled to +1 eigenspace)
* **Rational maps** = resolved `GEquivariantMorphism`; going-down on tracked strata fully proved
* **G-unirational** requires dominance (`HasDominantGEquivariantRationalMap`)
* **Centerless non-degeneracy** fully proved
* **PSL₂(F₁₁)** centerless + involution σ + regular rep fully proved
* **V14 model** = free regular G-set (operational hyp (a)(b); see `FAITHFULNESS_CHECK.md`)

## Module layout

* `Definitions.lean` — vocabulary + projectivization coupling (zero axiom)
* `Foundations.lean` — tracked stratum + RCC image + going-down (proved)
* `CentralizerObstruction.lean` — Theorem 3.1 (proved)
* `V14Application.lean` — PSL₂(F₁₁) + free model + Cor 6.1 shape (proved)
* `AxiomAudit.lean` — `#print axioms` entrypoint
* `scripts/verify.sh` — build + census + classical-axiom gate
