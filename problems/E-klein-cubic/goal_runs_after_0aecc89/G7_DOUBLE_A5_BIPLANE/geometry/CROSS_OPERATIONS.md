# G7.4 — full cross-class operation space

## Scope

Finite design-generated operations through cubic arity, consuming G7A projectors
(`1⊕10`, naive `1⊕5⊕5` refuted) and G7B scale-safe chart lifts.

## Families enumerated

1. **Incidence / complementary-incidence transforms** — row/column sums of
   chart lifts of `Q` (resp. `P`) against `N` and `J−N`.
2. **Augmentation + projectors** — `P₁ = J/11`, `P₁₀ = I−P₁` applied to lifts;
   ambient residuals `p_i − (sum P)/11`.
3. **First moments** — total sums of `P` and `Q` lifts.
4. **Second/third moment contractions with `B`** — polar traces
   `sum_i B(e_a,p_i,p_i)`, cross polars `sum_N B(e_a,p_i,q_j)`, and cubic
   contractions `sum_i B(p_i,p_i,e_a) p_i`.
5. **Design-weighted third-intersection sums** — chart-normalized residual
   sums over incident and nonincident partners.
6. **Isotypic notes** — no Klein/companion summand in `Ind`; no new
   G-invariant ambient line from the op space.

## Scale safety

Cone-lift sums use G7B first-nonzero chart lifts only. Silent unnormalized sums
are forbidden (G7B scaling gate). Multihomogeneous ops (third intersections,
`B`-contractions) are projectively meaningful of the stated multi-degree.

## Landing

| quantity | value |
|---|---|
| operations enumerated | 116 |
| nonzero on cubic | 0 |
| nonzero off cubic | 116 |
| Q-rational on cubic | 0 |

**No** design-generated ambient vector lands on `F=0`. **No** `K_proj`-point of
`X_gen` from this operation space.

Machine data: `operations.json`.
