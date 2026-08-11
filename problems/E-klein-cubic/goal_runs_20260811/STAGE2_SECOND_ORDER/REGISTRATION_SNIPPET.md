# Proposed registration for `goal_runs_20260811/STAGE2_SECOND_ORDER`

**Not applied.** This session was told not to edit `NOTEBOOK.md` or
`notebook_build/manifest.json` (concurrent sessions race on them). The text
below is ready to paste by whoever holds the notebook lock; it should ride the
same commit as the packet, and `scripts/check_manifest_parity.py` should be run
before that commit lands.

---

## 1. Text to append to the `### E56 — FIX — Equivariant fixed-locus b-complex program` **Status** paragraph

> **Stage-2 second-order landed 2026-08-11**
> (`goal_runs_20260811/STAGE2_SECOND_ORDER`, `STAGE2-SECOND-ORDER-A4-JET-SEALED`;
> marker `STAGE2_SECOND_ORDER_VERIFY_OK` + `ALLGREEN`, 96 checks at `p = 331`
> and `p = 661`). Executes the two remainders of the sealed
> `STAGE2_ODD_ORDER_PINNING` (PR #37). **Lever 1 — the A4 jet.** At an
> A4-point `q` the leading form `Φ = T^{(μ)}` is an A4-equivariant map
> `P(N) ⇢ X` of degree `μ = mult_q(T)` with `N = ω ⊕ Θ`; the two immune
> `C3`-rows over `q` are the relative-weight-1 `P¹` and the relative-weight-2
> point of `P(N)`, and their values are `Φ(θ_b^μ)` for `C3`-eigenvectors of
> `Θ`, so the whole question lives in `Sym^μ Θ`. New: **`mult_q(T) ≥ 2`
> always** — `μ = 1` forces `Φ = 0`, because the `ω`-summand must land on an
> A4-point (both off `X`) and `Hom_{A4}(Θ, W ⊗ ω^{-d})` is 1-dimensional with
> injective generator, whose image would be a plane inside a smooth cubic
> threefold. Feeding in the sealed Prop. 1.6 as an **eigenline constraint**
> (the relative-weight-0 direction must land on the `X^{C6}` point) and
> deciding the landing condition `F(Φ) ≡ 0` by two independent exact routes
> (univariate gcd over `F_p`; Macaulay2 `dim` of the cubic ideal, 72 decisions,
> 0 disagreements) gives the order-by-order table: `μ = 2` and `μ = 4` — the
> rows carry **no value at all**; `μ = 3` — the value is one of the **two
> exact-`C3` points**, the `X^{C6}` point being **excluded**; `μ = 5` — all
> three realisable, the jet blind again. So the sealed residual `3⁸ = 6 561`
> collapses to `2⁸ = 256` exactly when `μ = 3`, to `1` when `μ ∈ {2,4}`, and
> not at all from `μ = 5`; the sealed order-0 count
> `43 008 · 23 · 3⁸ = 6 490 036 224` becomes `253 231 104` resp. `989 184` in
> those branches. **Order 2 is not blind — it is empty**, and the
> `C6`/exact-`C3` distinction first becomes visible at `μ = 3`. **Lever 2 — the
> `C11` multiplicity.** New geometry: in the `C11`-eigenbasis `F = Σ_{a∈Q}
> x_a² x_{9a}`, so of the ten `C11`-coordinate lines the five with ratio class
> `{5,9}` meet `X` only at their endpoints while the five with ratio class
> `{3,4}` **lie in `X`** — a `G`-orbit of **60 lines of the Fano surface of `X`
> joining pairs of `C11`-fixed points**, each with stabiliser `C11` (so none is
> a minus-line). Bounds proved: `μ ≤ d`; `2μ ≤ d` as soon as one
> `C11`-coordinate line is not in `Bs(T)`; `d² ≥ 3μ² + 55e²` under a
> no-fixed-component hypothesis; and, unconditionally, **`μ = 1` forces the
> leading form to be linear with image a linear subspace of `X`, hence of rank
> `≤ 2`** — so at most **two** of the four `C11`-rows carry a value (down from
> the sealed congruence's four at `d ≡ 1 mod 11`), at most **one** for seven of
> the eleven residues, and the two targets must span one of the 60 lines. The
> congruence side never forces more than `μ ≥ 1` (`μ_min(d) = 0` for the
> quadratic residues, `1` otherwise), so lower and upper bounds never cross:
> **no degree exclusion** (`STAGE2-NO-DEGREE-EXCLUSION-II`), and the gap is
> recorded precisely — an exclusion needs either a `d`-growing lower bound on
> `μ` or an exclusion of `μ = 1` at the `C11`-points, the latter being the live
> route. Sealed windows unchanged: `d ≤ 30` empty, `d = 25` dead, `d = 34`
> first open.

## 2. Manifest record to append to `notebook_build/manifest.json` `records`

```json
{
 "path": "goal_runs_20260811/STAGE2_SECOND_ORDER",
 "entry": "E56",
 "kind": "goal_run",
 "verification_class": "ALGEBRAIC-RECOMPUTE",
 "primary_exit": "STAGE2-SECOND-ORDER-A4-JET-SEALED",
 "superseded_by": null,
 "char0_scope": "The representation-theoretic layer is characteristic-free: the decomposition W|_{A4} = omega + omega^2 + Theta, Theta = the sum of the three non-trivial V4-eigenspaces, W^{A4} = 0, the twisted equivariance Phi(psi_h w) = omega(h)^{-d} h Phi(w), the weight dictionary b - a_q for the three C3-fixed loci of P(N), the reduction of the whole question to Sym^mu Theta by the A4-summand splitting of Sym^mu N, Prop 2.1 (mu >= 2, which uses only 'a smooth cubic threefold contains no plane' and 'both A4-points are off X'), Prop 3.1 (the line geometry, immediate from F = sum_a x_a^2 x_{9a} in the C11-eigenbasis), Prop 3.2(a),(b),(d) and Theorem 3.3. The two split primes p = 331 and p = 661 (330 | p-1, p does not divide |G| = 660, so equivariant-space dimensions equal the characteristic-zero ones) carry the finite decisions: the jet-space dimensions, the eigenline cut, and the landing decisions. Landing realisability is decided twice: by a univariate gcd over F_p when the kernel of the evaluation map is 1-dimensional (field-independent, so no rationality assumption on the auxiliary parameter), and by a Macaulay2 dim computation otherwise (dim = -1 exactly for the unit ideal, i.e. no solution over the algebraic closure). CAVEAT recorded in THEOREM.md Tier 3.2: the two exact-C3 points on a C3-eigenline are F_p-rational at 331 but not at 661, so the exact-C3 REALISATIONS are decided at 331 only; the load-bearing X^{C6} EXCLUSION at mu = 3 and 4 is confirmed at both primes. mu = 6 was submitted to Macaulay2 and did not return in budget: Theorem 2.2's table is complete for mu <= 5 only.",
 "tracked": "main",
 "notes": "Executes the two named remainders of the sealed STAGE2_ODD_ORDER_PINNING. LEVER 1 (A4 second-order jet, the residual 3^8): mult_q(T) >= 2 at every A4-point (mu = 1 impossible); with the sealed eigenline contraction imposed as a local constraint, the landing condition gives the table mu = 2 -> rows carry no value; mu = 3 -> exactly the two exact-C3 points, the X^{C6} point EXCLUDED; mu = 4 -> no value; mu = 5 -> all three, jet blind. Hence 3^8 -> 2^8 = 256 iff mu = 3, -> 1 iff mu in {2,4}, and no collapse from mu = 5; order 2 is not blind but empty, and the C6/exact-C3 distinction first appears at mu = 3. Sealed order-0 count 6490036224 becomes 253231104 (mu=3) resp. 989184 (mu in {2,4}). LEVER 2 (C11 multiplicity): new geometry - the ten C11-coordinate lines split 5+5 by ratio class, and the five with ratio in {3,4} LIE IN X, giving a G-orbit of 60 lines of the Fano surface joining pairs of C11-fixed points, stabiliser C11, none a minus-line. Bounds: mu <= d; 2mu <= d if some such line is not in Bs(T); d^2 >= 3mu^2 + 55e^2 under a no-fixed-component hypothesis; and unconditionally mu = 1 forces rank <= 2 (no plane in X), so at most TWO of the four C11-rows carry a value - at most ONE for seven of the eleven residues - and their targets must span one of the 60 lines. This sharpens the sealed C11 quadruple obstruction. mu_min(d) <= 1 always, so no exclusion follows; the gap is recorded. Marker STAGE2_SECOND_ORDER_VERIFY_OK + ALLGREEN, 96 checks. No contradiction with any sealed certificate; the sealed packet on PR #37 is untouched."
}
```

## 3. Secondary exits

```text
STAGE2-A4-MULT-AT-LEAST-3        Prop 2.1 (mu >= 2) + Thm 2.2 (mu = 2 valueless)
STAGE2-C6-POINT-EXCLUDED-AT-MU-3 Thm 2.2
STAGE2-C11-LINE-GEOMETRY         Prop 3.1 (60 lines of X through C11-point pairs)
STAGE2-C11-MULT-BOUNDS-PARTIAL   Prop 3.2
STAGE2-NO-DEGREE-EXCLUSION-II    Thm 3.3   (NEGATIVE exit)
```

## 4. Remainder note

Closes nothing; contradicts nothing. Creates four remainders (THEOREM.md §9):
`mu = 6` undecided; whether a `mu = 1` jet exists at a `C11`-point (the only
visible route from lever 2 to an exclusion); what pins `mu` at the A4-points
(Theorem 2.2 makes the whole residual factor a function of it); and the place of
the 60 new lines in the inventory of the Fano surface of `X`.
