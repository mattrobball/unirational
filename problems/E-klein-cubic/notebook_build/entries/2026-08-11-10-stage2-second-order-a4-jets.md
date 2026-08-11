## 2026-08-11 Stage-2 second order: mu >= 2 at the A4-points, the C6-exclusion at mu = 3, and 60 Fano lines through the C11-pairs

Packet: `goal_runs_20260811/STAGE2_SECOND_ORDER/`. Problem E remains **OPEN**.

**Stage-2 second-order landed 2026-08-11**
(`goal_runs_20260811/STAGE2_SECOND_ORDER`, `STAGE2-SECOND-ORDER-A4-JET-SEALED`;
marker `STAGE2_SECOND_ORDER_VERIFY_OK` + `ALLGREEN`, 96 checks at `p = 331`
and `p = 661`). Executes the two remainders of the sealed
`STAGE2_ODD_ORDER_PINNING` (PR #37). **Lever 1 — the A4 jet.** At an
A4-point `q` the leading form `Φ = T^{(μ)}` is an A4-equivariant map
`P(N) ⇢ X` of degree `μ = mult_q(T)` with `N = ω ⊕ Θ`; the two immune
`C3`-rows over `q` are the relative-weight-1 `P¹` and the relative-weight-2
point of `P(N)`, and their values are `Φ(θ_b^μ)` for `C3`-eigenvectors of
`Θ`, so the whole question lives in `Sym^μ Θ`. New: **`mult_q(T) ≥ 2`
always** — `μ = 1` forces `Φ = 0`, because the `ω`-summand must land on an
A4-point (both off `X`) and `Hom_{A4}(Θ, W ⊗ ω^{-d})` is 1-dimensional with
injective generator, whose image would be a plane inside a smooth cubic
threefold. Feeding in the sealed Prop. 1.6 as an **eigenline constraint**
(the relative-weight-0 direction must land on the `X^{C6}` point) and
deciding the landing condition `F(Φ) ≡ 0` by two independent exact routes
(univariate gcd over `F_p`; Macaulay2 `dim` of the cubic ideal, 72 decisions,
0 disagreements) gives the order-by-order table: `μ = 2` and `μ = 4` — the
rows carry **no value at all**; `μ = 3` — the value is one of the **two
exact-`C3` points**, the `X^{C6}` point being **excluded**; `μ = 5` — all
three realisable, the jet blind again. So the sealed residual `3⁸ = 6 561`
collapses to `2⁸ = 256` exactly when `μ = 3`, to `1` when `μ ∈ {2,4}`, and
not at all from `μ = 5`; the sealed order-0 count
`43 008 · 23 · 3⁸ = 6 490 036 224` becomes `253 231 104` resp. `989 184` in
those branches. **Order 2 is not blind — it is empty**, and the
`C6`/exact-`C3` distinction first becomes visible at `μ = 3`. **Lever 2 — the
`C11` multiplicity.** New geometry: in the `C11`-eigenbasis `F = Σ_{a∈Q}
x_a² x_{9a}`, so of the ten `C11`-coordinate lines the five with ratio class
`{5,9}` meet `X` only at their endpoints while the five with ratio class
`{3,4}` **lie in `X`** — a `G`-orbit of **60 lines of the Fano surface of `X`
joining pairs of `C11`-fixed points**, each with stabiliser `C11` (so none is
a minus-line). Bounds proved: `μ ≤ d`; `2μ ≤ d` as soon as one
`C11`-coordinate line is not in `Bs(T)`; `d² ≥ 3μ² + 55e²` under a
no-fixed-component hypothesis; and, unconditionally, **`μ = 1` forces the
leading form to be linear with image a linear subspace of `X`, hence of rank
`≤ 2`** — so at most **two** of the four `C11`-rows carry a value (down from
the sealed congruence's four at `d ≡ 1 mod 11`), at most **one** for seven of
the eleven residues, and the two targets must span one of the 60 lines. The
congruence side never forces more than `μ ≥ 1` (`μ_min(d) = 0` for the
quadratic residues, `1` otherwise), so lower and upper bounds never cross:
**no degree exclusion** (`STAGE2-NO-DEGREE-EXCLUSION-II`), and the gap is
recorded precisely — an exclusion needs either a `d`-growing lower bound on
`μ` or an exclusion of `μ = 1` at the `C11`-points, the latter being the live
route. Sealed windows unchanged: `d ≤ 30` empty, `d = 25` dead, `d = 34`
first open.

Exits: `STAGE2-NO-DEGREE-EXCLUSION-II`, `STAGE2-SECOND-ORDER-A4-JET-SEALED`.
