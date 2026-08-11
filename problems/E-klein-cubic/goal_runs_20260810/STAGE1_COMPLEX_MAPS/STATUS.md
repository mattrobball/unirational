# STAGE1_COMPLEX_MAPS — status

**Problem E headline: OPEN.** This packet contains no headline claim.

| | |
|---|---|
| opened | 2026-08-10 |
| main document | `THEOREM.md` |
| machine markers | `STAGE1_COMPLEX_MAPS_VERIFY_OK` / `ALLGREEN` — **127 checks, 0 failures** |
| replay | `python3 verifier.py` (both primes, ~20 min) |
| state | complete; adversarial audit applied (§14); director coherence-correction applied (§15) |

## What it is

Stage 1 of the two-stage program: the complete classification of morphisms of
decorated complexes of groups from the terminus source complex `𝔽(Z)` of the
`STANDARD_FORM_PW` tower over `P(W) = P⁴` (plus the order-0 delta for the corner
refinement `Z⁺`) to the complex of the Klein cubic `X`, under the sealed
constraint rows, for a dominant `G`-equivariant `P(W) ⇢ X`, `G = PSL(2,11)`.
Realization by an honest map is Stage 2 and out of scope.

## Headline numbers

```
stratum-coherent order-0 boundary patterns   1 088 847 395 778 723 840 000
    = 2¹¹ · 21 · 23 · 6⁸ · 4¹⁰ · 5⁴
    = 43 008  (coupled core, 51 rows)
    ×     23  (the D10 C2-line: 21 points + 2 one-parameter families)
    × 6⁸·4¹⁰·5⁴ = 1 100 753 141 760 000   (coherence-immune, odd-order rows)

value-set-consistent only (superseded as headline)
                                            69 686 233 329 838 325 760 000
ratio                                                            64 = 2⁶
```

**The count is of boundary patterns, not a moduli of maps** (§15.4).

## Timeline

| date | event |
|---|---|
| 2026-08-10 | packet produced: Layers 1–3, witness sections, extension-variable report, Stage-2 boundary |
| 2026-08-10 | adversarial audit — verdict REGISTER-WITH-EDITS; edits applied, §14 added (incl. the audit-derived closed formula removing the `d ≤ 45` restriction in Theorem 9(ii)) |
| 2026-08-10 | landed on `agent/stage1-complex-maps-20260810` (PR #32) |
| 2026-08-10 | **director correction order** — the count treated the constraint blocks as independent; evaluation coherence imposed, count re-issued, §15 added, verifier grown from 95 to 123 checks |
| 2026-08-11 | adjudication (`ADJUDICATION_PR32.md`): revision confirmed a correction, not a weakening; verifier replayed identically; §14's closed formula and §15.6's saturation stability were unverified assertions and are now checked (F7/F8, `scripts/s1saturation.py`); verifier 123 → **127 checks** |

## Exits

```
STAGE1-COMPLEX-MAPS-CLASSIFIED
STAGE1-BOUNDARY-PATTERNS-SEALED            (was STAGE1-SECTION-MODULI-SEALED)
STAGE1-EVALUATION-RIGIDITY                 (new)
STAGE1-TYPE-II-EXCLUSION-ON-Z
STAGE1-EIGHT-FORCED-SWEEPS                 (was STAGE1-THREE-FORCED-SWEEPS)
STAGE1-NO-GENUS-BUYING-ADMISSIBLE
STAGE1-WITNESS-SECTION-VERIFIED
TERMINUS-CENSUS-INDEPENDENTLY-REPRODUCED
STAGE1-ORDER0-WINDOW-PARITY-ONLY
STAGE1-COHERENCE-IMMUNE-FACTOR-ISOLATED    (new)
```

## What is settled

* Only two positive-dimensional images occur: `X` (free stratum) and the 55
  lines `L_σ`. **Eight** rows sweep in every coherent section; fifteen may.
* All 18 `V4`-rows of `Z` land on **type-I** vertices — (F2)'s exclusion,
  unconditionally and for 18 rows rather than 0 rows of `Z` (§2 Thm 4); twelve
  of the eighteen are rigid (§2 Thm 5′).
* No admissible refinement ever buys genus; no non-free stratum can dominate an
  `E_σ`; exactly one row can land in the open part of an `E_σ`.
* The H0-1 parity is re-derived by character theory; `N(d,m) > 0` for every odd
  `m ≤ d`, so order 0 imposes nothing beyond the parity.
* Evaluation rigidity: the value of a deep row under a sweep is constant on each
  connected component of the sweep's Layer-2 moduli. 13 of the 15 evaluation
  maps are surjective; the two dim-3 divisors are not.

## What is open / handed on

* **Stage 2.** All-order jets against a specific pattern; algebraization (the T5
  gate); dominance; the degree window; the cross-`V4` coupling through one `σ`.
* **The coherence-immune factor** `6⁸·4¹⁰·5⁴ ≈ 1.1 × 10¹⁵` (22 rows with
  odd-order stabilizer, only parent the free stratum) plus the `D10` row's 23 —
  untouchable at order 0, and therefore the measurement of where Stage-2's work
  lives (§15.5).
* **`Z⁺`'s three new rows.** Their type-II exclusion is covered only by (F2),
  which is conditional on EXTERNAL-UNVERIFIED Duncan imports (§7).
* **Saturation of the coherence tables** in the multidegree (§15.6(1)):
  empirically stable at maxdeg 3, 4, 5, 6; not proved.
