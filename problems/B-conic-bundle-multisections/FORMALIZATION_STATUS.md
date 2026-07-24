# Formalization status

Authoritative statement of what the Lean development does and does not prove, as of
commit `2d7c428`. Supersedes the status claims in `HANDOFF.md` where they conflict.

## Headline

The main theorem is **conditional**:

```lean
theorem smooth_bidegree23_hasUnirationalParametrization
    (k : Type u) [Field k] [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (Bidegree23ZeroLocus.toSpec k F)]
    (hXT : HasResidualBaseChangeUnirationalParametrization3 F) :
    HasUnirationalParametrization 3 (Bidegree23ZeroLocus.toSpec k F)
```

`hXT` is an assumption, not a theorem. The development does **not** currently prove that
smooth bidegree-(2,3) hypersurfaces in `P² × P²` are unirational.

The tree is free of `sorry` / `admit` / `axiom` across all 72 modules. That is a real
property but it is *not* evidence of completeness: the outstanding content sits in the
hypothesis `hXT`, not in holes. Check the statement, not the hole count.

The gate to watch is
`#print axioms smooth_bidegree23_hasUnirationalParametrization` (should show only
`propext` / `Classical.choice` / `Quot.sound`) **together with** the hypothesis list,
which must contain only `Field`/`IsAlgClosed`/`CharZero`, `IsBidegree23`, `F ≠ 0`,
`Smooth`. An axiom check alone cannot detect a smuggled hypothesis.

## Proved unconditionally

- `residualImageXCoords_ne_zero_of_smooth` — residual X-coordinates nonvanishing, from
  smoothness alone (`SpecializedConicFreeDir.lean`).
- `specializedConicFreeDirForm_ne_zero_of_smooth` — free-direction nonvanishing, via the
  singular-point argument on `{X₂ = Y₂ = 0}`.
- `residual_baseChange_package_summary` — `IsDominant` of the multisection base change,
  plus existence of a Tsen section.
- `hasUnirationalParametrization2_residualComponent` — **the residual component `T_L` is
  unirational over `Spec k`**, with dominance supplied by Mathlib's `IsDominant f.toImage`
  rather than assumed (`ResidualComponent.lean`).
- The multisection principle, and the `2 + 1 = 3` assembly
  (`hasResidualBaseChangeUnirationalParametrization3_ofHom`).

## Remaining obligations

| # | Obligation | Status | Difficulty |
|---|---|---|---|
| 1 | `IsDominant (residualComponentMultisection …).baseChangeFst` | reduced, not proved | coordinate computation |
| 2 | `residualYCoords ≠ 0` off the pure-`t` branch | open | **mathematics, possibly false as stated** |
| 3 | `IsResidualPointedConicRational` | not started | substantial scheme theory |

**(1)** is now reduced by `isDominant_residualComponentToBase_iff`: because
`residualComponentPoint` is dominant, component horizontality is *equivalent* to
`IsDominant (residualImagePointOfNormalizedLoc … ≫ residualImageToBase F)`, a concrete
assertion about the residual coordinates (the residual surface is not contained in a
fibre) with no scheme-theoretic image in it.

**(2) is the load-bearing blocker.** Residual Y-nonvanishing is proved only on the
pure-`t` L-branch (`freeDirPureT`). `HANDOFF.md` §4.7 lists unconditional `freeDirPureT`
under *"Suspect FALSE or overstated as currently targeted"*, and §3 records that the
complementary branch is unhandled with no parallel argument. If it is false as stated,
this is not a matter of more effort: a different argument is required. This is the item to
put to a human expert.

**(3)** was previously described as "packaging, not mathematics." **That was wrong.**
`PointedConicRational.lean` contains field-level statements about `K`-points of one model
conic (`pointed_model_conic_rational_points`, `model_conic_eq_veronese_image`). The target
`IsPointedConicRationalOver` unfolds to `BirationalOver (pullback.snd π t) (𝔸¹_T ↘ T)` —
a birational equivalence *in families over an arbitrary base*, with the section varying.
The distance between those is the work.

## Corrections to earlier records

Three findings that contradict statements elsewhere in the repo history:

1. **`residualImage F` was the wrong target.** It is the complete intersection
   `V(F) ∩ V(q_F)`. When the degree-ten coefficients of `q_F` share a common factor,
   `V(q_F)` acquires a vertical divisor and `residualImage F` gains components the
   residual map never meets. Since `𝔸²` is irreducible, the closure of its image under any
   rational map is irreducible, so a dominant rational map onto a reducible target cannot
   exist: `HasUnirationalParametrization 2 (residualImageToSpec F)` is **false** in that
   case, not merely hard. `RESOLUTION.md:246` already took the class `aH_x + H_y` only
   "after removing their common factor and any components over special x-curves"; the Lean
   definition never performed that removal. Fixed in `1731498` by retargeting to the
   scheme-theoretic image.

2. **Two of the four former sorries were attempts to prove that false statement**
   (`TODO(WP10-dense)`, `TODO(loc-dom)`), and the other two were infrastructure for them.
   `ResidualImageDominance.lean` was deleted in `cb34fbf`; recoverable from `404658c`.

3. **The `ker-bot-map` proof sketch in `HANDOFF.md` §4.6 is unsound, not merely slow.**
   It requires `f.ker ≤ (f.ker.map ι).comap ι`. Mathlib's ideal-sheaf Galois connection
   supplies only `comap_map_le`, the opposite inequality, and no map-injectivity lemma for
   closed immersions exists to bridge the gap. The recorded elaborator timeout was masking
   this.

## Provenance

Lean sources are machine-generated. The claims in the "Proved unconditionally" table were
checked by reading the statements and confirming compilation; the whole tree has not been
line-by-line reviewed.
