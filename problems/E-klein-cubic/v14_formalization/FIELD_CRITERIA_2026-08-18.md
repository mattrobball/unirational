# Which fields the V14 no-map argument actually needs

Written 2026-08-18. Companion to `CERTIFICATE_COST_2026-08-16.md`.

The published theorems fix one base field,

```
V14SchemeModel.k = GeometricV14Carrier.k = GeometricFanoCarrier.k
                 = WeilRep.K = AdjoinRoot Φ11 = ℚ(ζ₁₁)
```

and quantify over `FaithfulLinearRep k G V`, i.e. over `ℚ(ζ₁₁)`-representations
only. That is narrower than intended in two ways, both real:

* A rational map over `ℂ` does not descend to `ℚ(ζ₁₁)`. "No `ℚ(ζ₁₁)`-map" is the
  weaker of the two directions.
* `PSL(2,11)` has two 12-dimensional irreducibles with character field `ℚ(√5)`.
  The only quadratic subfield of `ℚ(ζ₁₁)` is `ℚ(√−11)`, so `ℚ(√5) ⊄ ℚ(ζ₁₁)` and
  those two representations — faithful, since `G` is simple — are not in the
  scope of the statement. (Their sum is defined over `ℚ` and *is* in scope; the
  individual summands are not.)

This note answers: under what hypotheses on a field does the argument *as the
Lean implements it* go through, and where exactly does each hypothesis bite.

## The argument the Lean actually runs

It is **not** the paper's argument. The paper (`writeups/v14_not_weakly_versal.tex`,
Thm 3.1) resolves the graph of the rational map by Hironaka plus equivariant
weak factorization (AKMW), and that step needs characteristic 0 for real and
irremovably. The Lean replaces it with a resolution-free step:

1. `σ` an involution in `G`; `ρ(σ) ≠ ±id` because `G` is centerless;
   `V = V₊ ⊕ V₋` with both summands nonzero.
2. Blow up `ℙ(V)` along `ℙ(V₊)`. The exceptional divisor is `ℙ(V₊) × ℙ(V₋)` and
   `σ` acts trivially on it.
3. `V14` is proper over the base, so the **valuative criterion** extends the
   generic point of the blow-up chart to a `k(E)`-point of `V14`, `σ`-fixed by
   uniqueness of the lift.
4. `k(E)` is purely transcendental over `k`, so hypothesis (a) forces that point
   down to a `k`-point.
5. `E` is `N`-stable, so the `k`-point is `N = D₁₂`-fixed; hypothesis (b) says
   there is no such point.

Steps 1–3 and 5 carry almost no field hypotheses. Step 4 carries all of them.

## Hypothesis by hypothesis

### Step 1 — eigenspace splitting: char ≠ 2 mathematically, `CharZero` as written

`UniversalNormalDivisor.lean` and `CentralizerObstruction.lean` carry
`[CharZero k]` on the `±1`-eigenspace splitting. Mathematically the splitting
needs only `1/2`, i.e. `char ≠ 2`; `CharZero` is a blanket, not a necessity.
`NeZero (2 : L)` is what several downstream files actually ask for
(`V14FixedPointCarrierConcrete`, `SchemeFixedProjectiveCoordinates`, …), which
is the honest form.

### Steps 2–3 — blow-up chart, properness, valuative criterion: no field hypothesis

`SchemeNormalSpecialization.lean` has `variable {S X E Y : Scheme.{u}}` and no
field anywhere; it is pure valuative-criterion category theory.
`SchemeEquivariant*.lean`, `SchemeFixedLocus.lean`, `SchemeBaseChangeAction.lean`
likewise. `SchemeProjectiveAction.lean`, `GenericCharts.lean`, the
`Biprojective*` family and `SchemeRationalConstancy.lean` take a bare
`[Field k]`. `GrassmannianLinearSection.lean` needs only `[CommRing R]`.
`BlockNormalSigma.lean` carries `[CharZero Omega]` on one theorem (the
`σ`-triviality of the function-field action), again as a blanket over char ≠ 2.

**This is the load-bearing structural fact**: the entire scheme-geometric spine
of this proof is already polymorphic. `k = ℚ(ζ₁₁)` is hard-wired in exactly five
places: `V14SchemeModel.lean` (the concrete `projectorMatrix` / `v14Scheme` /
`actionOver`), `SchemeModelAliases.lean` + `FaithfulHeadlineReduction.lean` (the
`k`/`G` aliases), `ProjectiveGVariety.v14`, `D12CertificateK.lean`, and the
wrapper `V14D12CertificateExclusion.noEquivariantRationalMap_of_normal_specialization`.

### Step 4, hypothesis (a) — the only genuine characteristic obstruction

The `σ`-fixed locus of `V14` splits into a plus branch and a minus branch
(`V14FixedPointCarrierConcrete`, needs `NeZero (2 : L)`), handled separately.

**Minus branch** (`D12SigmaMinusDescent.lean`). The 4-dimensional minus carrier
meets the Plücker locus in a line-plus-binary-conic; the descent is
`binaryQuadratic_projective_descends_mvfrac`, which needs the discriminant
`B² − 4AC ≠ 0` (an explicit element of `k`) and `4` invertible, so `char ≠ 2`.
The descent itself is the characteristic-free fact that `k` is algebraically
closed in `k(x₁,…,xₙ)` (`MvFracConstantField.lean`, no `CharZero`, no
`IsAlgClosed`).

**Plus branch** (`D12SigmaPlusDescent.lean`). The 6-dimensional plus carrier is
`A ⊗ B` for the `±i` eigenspaces of the order-4 Weil operator `J` (`J² = −1`),
so the decomposable locus is a Segre `ℙ² × ℙ²` and the Plücker conditions cut it
down to a **smooth plane cubic** `Fplus` — a genus-1 curve. That is what
hypothesis (a) is about: no rational curve in the positive-dimensional part of
`V14^σ`.

* `Ki = GeometricV14Carrier.Ladj = k[X]/(X²+1) = ℚ(ζ₁₁, i)`, degree 2 over `k`
  (`irr_X_sq_add_one` proves `X²+1` irreducible over `k`). `Ki` is scaffolding
  only: the proof base-changes to `Ki`, factors the Segre point there, and
  descends the ratios back to `k`. It is **not** a hypothesis on the base field.
* Smoothness of `Fplus` is certified by `Fplus_isSmoothPlaneCubic_map`, stated
  for **any** ring map `f : Ki →+* L` with `[Field L] [Infinite L]`. So
  smoothness base-changes; it is not a `Ki`-only fact.
* The descent is `smoothPlaneCubic_projective_descends_mvfrac`, stated over
  `[Field K] [CharZero K]` — not over an algebraically closed field. It passes
  through `AlgebraicClosure K` internally and descends via
  `mvFrac_eq_constant_of_baseChange_eq_constant`.
* Inside `EllipticPolynomialConstancy.lean`, **`CharZero` is load-bearing**, in
  two places:
  * `Polynomial.eq_C_of_derivative_eq_zero` (line 445–450) — false in char `p`
    (`Xᵖ` has zero derivative and is not constant). This is the real one.
  * `Polynomial.flt_catalan` (Mason–Stothers, line 1050–1059) with side
    conditions `(2:F) ≠ 0`, `(4:F) ≠ 0`.
  Plus an explicit division by 2 at line 804.
* The short-Weierstrass normal form it reduces to
  (`BConicBundleMultisections/.../ShortWeierstrassNormalForm.lean`) needs
  `[Infinite k] [NeZero (2:k)] [NeZero (3:k)] [IsAlgClosed k]` — so `char ≠ 2, 3`
  once you are over the algebraic closure.

So: mathematically, "a genus-1 curve admits no non-constant map from a rational
variety" is true in every characteristic (Lüroth holds in all characteristics).
**As formalized, hypothesis (a) needs characteristic 0**, because the descent
engine is a derivative/Mason–Stothers argument on polynomials. Weakening it to
`char ≠ 2, 3` plus explicit bad primes is a genuine mathematical project, not a
matter of relaxing a typeclass.

### Step 5, hypothesis (b) — settled, and it base-changes

The audit asked the right question: is emptiness ideal-theoretic (base-changes)
or point-counting over `K` (does not)? **Answer: ideal-theoretic.** This is now
proved, not asserted.

`D12Certificate.Certificate` was already stated over an arbitrary `[Field Ω]`,
but two of the four `PieceCertificate` fields quantify over vectors of the
ambient field, so a certificate over one field did not give one over another:

* `action_kernel : ∀ m, A.mulVec m = 0 ↔ (RM·m = r·m ∧ SM·m = s·m)`
* `plucker_empty : ∀ t, (∀ q, pluckerValue ((B*K).mulVec t) q = 0) → t = 0`

Both now transport (`D12CertificateBaseChange.lean`):

* `action_kernel`, because the emitted `A` **is** the character stack
  `[RM − r·1 ; SM − s·1]` and `characterStack` commutes with `Matrix.map`; the
  kernel description is then re-derived over the target by the field-generic
  `characterStack_mulVec_eq_zero_iff`.
* `plucker_empty`, because the `∀ t` coefficient hypothesis of
  `plucker_empty_fin{1,2}_of_coeff` has a **canonical** solution:
  `pluckerValue ((B*K).mulVec t) q` is a quadratic form in `t`, and its
  coefficients are values of that same expression at `t = (1,0), (0,1), (1,1)`.
  Evaluation commutes with every ring map, so what is left is the nonvanishing of
  three explicit scalars.

The three scalars, in the power basis `1, ζ, …, ζ⁹` of `ℚ(ζ₁₁)`:

| piece | scalar | value |
|---|---|---|
| `(+,+)` | `ppDet` = the `3×3` coefficient determinant | `1 + ζ² + 5ζ³ + (9/2)ζ⁴ + (9/2)ζ⁷ + 5ζ⁸ + ζ⁹` |
| `(+,−)` | — | zero-dimensional piece, nothing needed |
| `(−,+)` | `apDelta` | `ζ + (1/2)ζ² + ζ³ + (3/2)ζ⁷ + (3/2)ζ⁸` |
| `(−,−)` | `aaDelta` | `−1 − ζ − ζ² + (1/2)ζ³ + (1/2)ζ⁴ − ζ⁵ − ζ⁶ − ζ⁷ − (1/2)ζ⁹` |

Every denominator is 2. After clearing it the three lie in `ℤ[ζ₁₁]`, with

```
N(2·ppDet)   = 11⁶ = 1 771 561
N(2·apDelta) = 11⁴ =    14 641
N(2·aaDelta) = 11⁴ =    14 641
```

**All three norms are pure powers of 11.** So the three scalars are units in
`ℤ[ζ₁₁][1/22]`: the only primes that can kill them are 2 (the cleared
denominator) and 11 (the ramified prime, where a primitive 11th root of unity
does not exist anyway). There is no hidden large bad prime in hypothesis (b) —
which is the opposite of what the `Segre`/`Smooth` denominators suggested
(`CERTIFICATE_COST_2026-08-16.md` found primes up to 649 573 there).

The remaining ring-level obstruction for hypothesis (b) is the denominators of
the emitted matrices themselves. `CERTIFICATE_COST_2026-08-16.md` measured the
four `D12Piece*Data` families and found they clear at **132 = 2²·3·11**. So a
`ℤ[ζ₁₁, 1/132]`-form of the certificate would give hypothesis (b) in every
characteristic outside `{2, 3, 11}`. That re-emission has not been done; the
Lean statement proved here is over fields receiving a ring map from `ℚ(ζ₁₁)`,
i.e. characteristic 0.

## The criteria

For the argument as formalized:

> **Claim.** Let `F` be a field with a ring homomorphism `ℚ(ζ₁₁) → F` — equivalently,
> `char F = 0` and `F` contains a primitive 11th root of unity. Then, for every
> faithful `F`-linear representation `V` of `G = PSL(2,11)`, there is no
> `G`-equivariant rational map `ℙ(V) ⇢ V14_F` over `F`.

with the following accounting:

| ingredient | needs | status in Lean |
|---|---|---|
| eigenspace splitting | `char ≠ 2` | proved, stated with `CharZero`/`NeZero 2` |
| blow-up chart, exceptional divisor | nothing | proved, polymorphic |
| properness + valuative criterion | nothing | proved, polymorphic |
| (a) minus branch | `char ≠ 2`, an explicit discriminant `≠ 0` | proved over `k`; polymorphic pieces available |
| (a) plus branch | **`char = 0`** (Mason–Stothers / `eq_C_of_derivative_eq_zero`), plus `char ≠ 2,3` from the Weierstrass form | proved over `k`; the cubic-descent lemma is already polymorphic in the field |
| (b) `V14^{D₁₂} = ∅` | nothing beyond `2, 11` invertible (and `3` if one re-bases the emitted matrices on `ℤ[ζ₁₁,1/132]`) | **proved over every field over `ℚ(ζ₁₁)`** |

Algebraic closure is **not** needed anywhere as a hypothesis on the base field.
Where `IsAlgClosed` appears it is always on an `AlgebraicClosure` of the field at
hand, with the conclusion descended afterwards (`EllipticPolynomialConstancy`'s
`ArbitraryField` section, `SmoothPlaneCubicMvFracDescent`). A primitive 11th root
of unity is needed, because the model — `WeilRep`, `Λ²U`, `projectorMatrix` — is
built out of one. A square root of `−1` is *not* needed in the base field: `Ki`
is internal scaffolding and the proof descends out of it.

So the honest answer is the middle one: **not "char 0 and algebraically closed",
but also not "any characteristic"** — char 0 containing `ζ₁₁`, with char 0
required only by hypothesis (a)'s plus branch, and only by its *proof technique*.

## What is implemented, and what is not

Implemented on `v14/module-system` (2026-08-18):

* `V14Formalization/D12CertificateBaseChange.lean` — `Certificate.mapRingHom` /
  `Certificate.mapOfInjective`, with the three explicit nonvanishing conditions.
* `V14Formalization/D12CertificateOverField.lean` — `D12CertificateK.certificateOver F`,
  the checked four-piece certificate over any field `F` over `ℚ(ζ₁₁)`, plus
  `ppDet_eq`, `apDelta_eq`, `aaDelta_eq` identifying the three scalars.
* `V14Formalization/V14D12FixedPointExclusionOverField.lean` —
  `no_centralizer_fixed_point_over (L : Type) [Field L] [Algebra k L]`:
  hypothesis (b) over every field over `ℚ(ζ₁₁)`.
* `V14Formalization/V14D12FixedPointExclusionComplex.lean` —
  `no_centralizer_fixed_point_complex`, the same over `ℂ` along an embedding from
  `IsAlgClosed.lift`.

All four use only `propext`, `Classical.choice`, `Quot.sound`, and are audited by
`AxiomAudit.lean`.

**Not implemented**: the general-field headline itself. What blocks it is
hypothesis (a) over `F`, i.e. an `F`-version of
`rationalMapIsConstantOver_v14FixedBy`. Concretely the remaining work is:

1. `plusCarrier_commonPluckerZero_descends_mvfrac` over `F` — most of the Segre
   packet (`plusCarrier_commonPluckerZero_to_determinantalCubic`,
   `eval_map_Fplus_eq_det`, `bilinearNOn_*`, `segrVecOn_*`, `L_map_mulVec_map`,
   `Fplus_isSmoothPlaneCubic_map`) is already stated for an arbitrary ring map
   `Ki →+* F`, and `smoothPlaneCubic_projective_descends_mvfrac` is already
   polymorphic. What is still `Ki`-only: `smooth_detCubic_rank_eq_two`,
   `N_mulVec_segrVec`, `eq_H_mulVec_L_of_N_mulVec`.
2. `minusCarrier_commonPluckerZero_descends_mvfrac` over `F` —
   `common_plucker_zero_parametric` and `binaryQuadratic_projective_descends_mvfrac`
   are both already field-generic; this is mostly rewriting.
3. `V14FixedFieldPointDescent.lean` over `F` (the `k`-point becomes an `F`-point).
4. `rationalMapIsConstantOver_v14FixedBy` over `F`.
5. Base-change plumbing: `FixedBy (actionOverBaseChange F) σ` versus
   `FixedBy actionOver σ`, and a relativized `RationalMapIsConstantOver` whose
   constant point lives over `Spec F` rather than `Spec k`.

Note for (5): a rational map `ℙ(W) ⇢ V14_F` over `Spec F` is the same thing as a
rational map `ℙ(W) ⇢ V14` over `Spec k` for `ℙ(W)` regarded as a `k`-scheme
(universal property of the fibre product), so the *statement* need not mention
the base change; only the constancy step does, because the point it produces is
an `F`-point and `RationalMapIsConstantOver` as written demands a `k`-point.
