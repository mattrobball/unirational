# The global localization ledger (morphism ledger L12)

Opened 2026-08-12 (director derivation, at max effort, per user directive:
the morphism of complexes of groups is the program's engine and its
GLOBAL layers have never been spent). Trust class: hand derivation with
every analytic subtlety flagged; machine enumeration is delegable ONLY
after this note is refereed against the sealed record.

**Headline: Problem E remains OPEN. This note excludes no degree.**

## 1. The point

Every constraint imposed so far — values, multidegrees, depth vectors,
pairwise coherence, and this week's gluing/cocycle/ramification layers —
is LOCAL: it constrains a stratum's data by itself or through finite
contact. A morphism of complexes of groups also has global consistency
invariants. The computable one: equivariant Euler characteristics pushed
through the map. For `g ∈ G` and a `g`-equivariant bundle, the
Atiyah–Bott localization of `χ_g` over the SOURCE tower is a finite sum
of pattern data; the Leray computation over the RECEIVER is a finite sum
involving the fibers' `g`-cohomology — the relative complex. Equality is
forced, in `Q(ζ_{ord g})`, for every twist. No local layer implies it.

## 2. The identity family

Let `T` be a landing map of minimal degree `d`, `q : Z → X` the induced
morphism on an equivariant resolution (map level: everything here is
about the reduced map). For `k ≥ 0` and `g ∈ G`:

```
   χ_g(Z, q*O_X(k))  =  χ_g(X, O_X(k) ⊗ Rq_*O_Z)          (Leray)
```

Left side by Atiyah–Bott over `Z^g`: isolated fixed points `z` contribute
`w_k(q(z)) / det(1 − (dg_z)^{-1})`, where `w_k(x)` is the `g`-weight of
`O_X(k)` at the (pattern-assigned!) value `q(z)`; positive-dimensional
fixed components contribute their standard characteristic-class terms.
Everything on this side — which fixed points the tower has, their
tangent weights, their values — is determined by the boundary pattern
and its chain/jet data (the Stage-2 `(a_k; c_l, μ_l)` bookkeeping).

Right side over `X^g`: `Rq_*O_Z = O_X ⊕ (higher terms)`; the higher
terms carry the fiber cohomology (`R¹` generically of rank = fiber
genus, with `g`-action). Over an isolated `x ∈ X^g` the contribution is
`w_k(x) · tr(g | (Rq_*O)_x) / det(1 − (dg_x)^{-1} | T_xX)`, and
`tr(g | (Rq_*O)_x) = 1 − tr(g | H¹(C_x)) + …` couples in the `g`-fixed
fibers — exactly the C7/C14 objects.

`k = 0` gives `1 = 1` (no information — blowups preserve `H^*(O)`).
`k = 1, 2, 3` give genuinely new equations; `k = 3` interacts with
`F` itself.

## 3. The order-11 instance, fully explicit

Let `g` have order 11, eigenvalues `ζ^{a_i}` on `W`, `a = (1,3,4,5,9)`
(the QR set; L-weights `ζ^{-a_i}` in a fixed SL-lift — both sides of the
identity must use the same lift, which is safe at odd order).

- `P(W)^g` = the five coordinate points `e_j`, and ALL FIVE lie on `X`
  (`F = Σ x_i² x_{i+1}` vanishes at every `e_j`). So `X^g = {e_0..e_4}`.
- Tangent structure of `X` at `e_j`: `∇F(e_j)` has a single nonzero
  entry, `∂F/∂x_{j+1} = 1`, so `T_{e_j}X = span(e_k : k ∉ {j, j+1})`
  with tangent weights `ζ^{a_k − a_j}`, and the conormal weight of
  `X ⊂ P⁴` at `e_j` is `ζ^{a_{j+1} − a_j}`.
- At `d ≡ 2 (mod 11)` (the degree-35 class) all five source points are
  base points with `μ ≥ 1`; the resolution tower over each is encoded by
  the pattern's chain data, its `g`-fixed points and their weights are
  the standard blowup transforms of `(a_k − a_j)`-sets, and each tower
  point's VALUE is pattern-assigned in `X^g`.

The identity for `k = 1, 2, 3`:

```
  Σ_{z ∈ tower fixed pts}  ζ^{-k·a_{v(z)}} / Π (1 − ζ^{-w_t(z)})
      =  Σ_{j=0}^{4}  ζ^{-k·a_j} · (1 − tr g|H¹(C_{e_j})+ …)
                       / Π_{k' ∉ {j, j+1}} (1 − ζ^{a_j − a_{k'}})
```

where `v(z)` is the value index of tower point `z` and `w_t(z)` its
tangent weights — ALL pattern data on the left; on the right the only
unknowns are the fiber traces `tr g|H¹(C_{e_j})` (algebraic integers in
`Z[ζ]` constrained by C7's Riemann–Hurwitz on 11-curves and by the C14
trichotomy: in a genus-0 fiber branch they VANISH and the identity
becomes a CLOSED test on the pattern alone).

The analogous instances at orders 5 (isolated on both sides after the
`5 ∤ μ` bookkeeping), and 2/3/6 (fixed CURVES contribute — heavier,
standard, second phase) complete the family.

## 4. Flags (each one blocks machine work until settled)

1. **Connected fibers.** `q_*O_Z = O_X` needs Stein-trivial fibers; a
   nontrivial Stein factor is a `G`-equivariant branched cover of the
   simply-connected `X` — allowed, but then its degree and branch data
   enter the right side as one more constrained unknown. The identity
   family remains valid with `Rq_*O` in full; the enumeration must carry
   the Stein degree as a variable with its own (small) menu.
2. **Fiber jumps.** Over special points the fiber can acquire surface
   components (`R²` terms). Bounded, positivity-constrained, must be
   carried, not assumed away.
3. **Map level.** Everything here is at `d_min` (the resolution is of
   the reduced map): verdicts kill patterns at their own degree class;
   no transport without the tuple-level upgrade.
4. **Lift consistency** of weights (SL vs PSL) — fix one convention
   globally; order-11/5/3 are safe, order-2/6 need the check.

## 5. Why this is the blood

This is the FIRST family in the campaign where a boundary pattern's data
must satisfy a global equation — one whose failure cannot be localized
to any stratum — and simultaneously the bridge to the fiber complex that
the realization program (C7/C8/C14) needs. Per conjugacy class and per
twist `k` it is exact cyclotomic arithmetic over the census: enumerable
against the 22 live cells at `d = 35`, against the extended J census per
residue class, and — because the tower combinatorics depend only on
residue data — capable of ALL-DEGREE verdicts in each class. It subsumes
and sharpens C8 (the topological Lefschetz coupling) on the `O`-level,
and it is precisely "the constrained scheme map of the complex of
groups" acting as one object rather than a list of local shadows.

## 6. Execution order (after this note is refereed)

1. Machine enumeration of the order-11 identity over the 22 cells and
   the residue-5 pattern class (k = 1, 2, 3; genus-0 branch first as the
   closed test; then the bounded fiber-trace menus).
2. Order-5 instance; then the curve-contribution classes (2, 3, 6).
3. Join as a new layer on the J census (per class; zero-class discipline
   as always).

## 7. Not claimed

No degree excluded; no pattern yet tested; the identity family is
derived, not yet machine-instantiated; flags 1–4 gate everything.

## 8. Referee corrections (2026-08-12, same day — `goal_runs_20260812/L12_REFEREE`, adopted in full)

The derivation stands (R2, R5, R6 CONFIRMED — including the strategic
claim that no local layer implies the identities), with these corrections
superseding the corresponding formulas above:

1. **Fixed-point contribution (R1):** `w_k(q(z)) / det(1 − dg_z | T_z)`
   — the note's `det(1 − (dg)^{-1})` convention is replaced by the
   sealed-usage convention throughout.
2. **Order-11 denominators:** `Π_{k' ∉ {j, j+1}} (1 − ζ^{a_{k'} − a_j})`.
3. **Wording:** the weight `ζ^{a_{j+1} − a_j}` at `e_j` is the NORMAL
   weight of `X ⊂ P⁴`, not the conormal.
4. **The `k = 0` identity is NOT vacuous (R4, referee's improvement):**
   localized it reads `Σ_j (tr_j − 1)/D_j = 0` with
   `tr_j = tr(g | (Rq_*O)_{e_j})` — a sum rule on the fiber traces alone,
   FREE of the twist bookkeeping: the cleanest first machine target.
5. **Flag 5 added (R3):** the local receiver factor is the derived
   `χ_g(Z_x, O)` (derived base change), not naively `1 − tr H¹`.

Machine phase cleared for order 11, genus-0 branch first, under these
formulas.
