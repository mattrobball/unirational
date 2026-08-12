# The landing cone against the 22 patterns' open demands

**Packet:** `goal_runs_20260812/CONE_VS_PATTERN/` · 2026-08-12.
**Headline: Problem E remains OPEN; this packet excludes no degree.**

*(Filename note: the main document is `THEOREM.md`; the harness refuses the
literal name `REPORT.md`.)*

The 22 degree-35 survivors live in one 37-dimensional cell. A point of the
landing cone `V = {c : F(T_c(x)) ≡ 0}` is a counterexample only if it
realizes one of the 22, which requires that pattern's OPEN
(required-nonzero) readings to hold on `V`. Those readings are linear
forms on the 37 parameters. This packet extracts them (rigidity-checked)
and tests whether they vanish identically on `V`.

Machine markers: `CONE_VS_PATTERN_VERIFY_OK` / `ALLGREEN`
(`python3 verifier.py`).

## Exit ledger

```text
CONE-VS-PATTERN-EXTRACT-RIGID
CONE-VS-PATTERN-Z37-KILLS
CONE-VS-PATTERN-I3-NO-EXTRA
CONE-VS-PATTERN-RABIN-TAUTOLOGY
CONE-VS-PATTERN-22-DEAD-FLAGGED
CONE-VS-PATTERN-NO-DEGREE-EXCLUSION
```

---

## 0. What is and is not claimed

**Claimed (modular, two-prime).** Every extracted functional used below
has transverse `W^-` rigidity 0 at jet levels `κ = 0,1,2,3` (0 / 31850
checks per level per prime). On the sealed 37-cell, five linearly
distinct open-demand forms are the zero form (`Z37`). In particular:

* rid-2 keep `T(w)` is the zero map at four of the seven assigned
  line-row children (independent evaluation: the 37×5 matrix is the
  zero matrix);
* every period-1 forced-deeper keep has rigid deeper readings
  `κ = 1,2,3` equal to the zero form;
* every period-3 non-mod-0 reading (`κ = 1` or `2`) and every period-3
  lab0 recurrence (`κ = 3`) is the zero form.

Under the sealed demand semantics, every one of the 22 patterns is
therefore unrealizable on the 37-cell, hence on `V`.

**FLAGGED, not claimed.** That all 22 are unrealizable on `V` would
exclude `d = 35` without deciding whether `V = {0}`. This packet
**flags** that outcome. It does not promote it. No ODDZERO adversarial
audit has run.

**Not claimed.** Emptiness of `V`. Any characteristic-zero
Nullstellensatz. Any degree exclusion.

---

## 1. Open demands

Source patterns: content-addressed 22 from `D35_AUDIT` repair, ids
`[5,7,13,15,21,23,29,31,37,39,45,47,53,55,61,63,69,71,697,699,701,703]`.
Frames and jets: `director_worked_example` / `keep_pass_22` (Reynolds
`jet_rows`, attaching pairs, `U0`/`Ut`/`W^+` frame). Depth: sealed
period table (periods 1, 2, 3; a vanishing level-0 reading is delivered
deeper; the *value* changes with depth only when period `> 1`).

| kind | meaning | kill rule |
|---|---|---|
| rid-1 live keep | level-0 `U0` reading nonzero | this form |
| rid-1 period-1 forced-deeper | some rigid deeper `U0` reading nonzero | all of `κ=1,2,3` |
| rid-1 period-3 lab0 | recurrence at `κ=3` nonzero | this form |
| rid-1 period-3 non-mod-0 | reading at the assigned level nonzero | this form |
| rid-2 keep | `T(w) ≠ 0` (5 linear forms) | all 5 components |

Level `κ = 4` (`t^5`) fails rigidity (2544 / 31850 at `p=331`) and is
not used.

---

## 2. Vanishing tests

1. **Z37.** The form is identically zero on the 37-cell. Then it
   vanishes on `V`. This is the certificate that fires.
2. **I3.** `λ^3` in the sealed landing-cubic span
   (`D35_LANDING` echelon, shape 1380×9139). Suffices for
   `λ ∈ rad(I)`. Among the nonzero forms: **0 extra** memberships.
3. **Rabinowitsch on `m=20`.** `I(L_{20}) + (u·(λ\|L) − 1)` has leading
   ideal `(1)` for a `Z37` form, a surviving form, *and a random linear
   form*. `CONE_LADDER_D35` already has `V ∩ L_{20} = {0}`, so every
   linear form vanishes on that intersection. A positive is
   **tautological** and is not used as evidence.

---

## 3. Outcome (both primes)

| quantity | p=331 | p=661 |
|---|---:|---:|
| unique functionals | 37 | 39 |
| `Z37` | **5** | **5** |
| extra `λ^3 ∈ I3` | 0 | 0 |
| rigidity `κ=0..3` | 0 / 31850 | 0 / 31850 |
| rid-1 branches dead | 3 / 3 | 3 / 3 |
| rid-2 rows with `T ≡ 0` | 4 / 7 | 4 / 7 |
| patterns dead | **22** | **22** |
| patterns live | 0 | 0 |

Four live-row keeps (rows 61, 63 at `p=331`; 62, 64 at `p=661`) survive
as nonzero forms with `λ^3 ∉ I3`. They do not save any pattern: every
branch is already killed by a `Z37` demand (rid-2 and the period-1 / 
period-3 readings).

Row ids are prime-dependent; the counts and the death of all 22 agree.

---

## 4. Honesty

| tier | content |
|---|---|
| `[T2]` two-prime finite exact | rigidity; `Z37` zeros; 22/22 unrealizable on the 37-cell |
| `[T2]` two-prime | `I3` membership of `λ^3`; Rabinowitsch tautology on `L_{20}` |
| `[FLAG]` not promoted | “`d = 35` is excluded because no pattern meets `V`” |
| not claimed | `V = {0}`; any degree exclusion |

---

## 5. Reproduction

```text
cd goal_runs_20260812/CONE_VS_PATTERN
python3 scripts/produce.py          # extract + vanish at 331 and 661
python3 verifier.py                 # stored artefacts
python3 verifier.py --live          # rebuilds T(w) at one dead and one live rid-2 child
```

Hard constraints: python3 + msolve (Rabinowitsch control only, `-t 2`);
no gap / gp / sage / magma; writes only inside this packet.

---

## 6. Not claimed

- Degree 35 is **not** closed.
- `V = {0}` is **not** proved.
- Section Rabinowitsch is **not** a vanishing certificate on `V`.
- Non-rigid jets (`κ ≥ 4`) are **not** used as readings.
- The FLAGGED “all 22 miss `V`” outcome is **not** an ODDZERO theorem.

## Director adjudication (2026-08-12, at landing)

Replayed clean: ALLGREEN. The comparison this packet makes — the
patterns' OPEN demands against the landing cone, rather than against the
ambient cell — is the right object, and it was missing from the campaign
until now (the director had been bounding the cone with no reference to
the boundary data at all).

**Status: FLAGGED, as the packet itself states. NOT promoted.** The
result is that all 22 patterns are unrealizable, which would exclude
`d = 35` without deciding emptiness. Before any promotion, an
ODDZERO-standard adversarial audit must settle ONE question, which is
the exact failure mode that produced this morning's retraction one level
down:

> The vanishing is established at jet levels `κ = 0,1,2,3`, and level 4
> is excluded because it fails transverse rigidity (2544 / 31850 at
> `p = 331`). Rigidity is what makes a "reading" a well-defined point of
> the target (Theorem 15.1, whose hypothesis is a stabilizer containing
> `V4` or `C6`). **A non-rigid level is not a level where no value
> exists — it is a level where the character rule does not pin the
> value.** The audit must establish that a demanded nonzero value cannot
> be supplied at a non-rigid deeper level, or the argument stops at the
> rigid levels for a reason of convenience rather than of geometry.

Everything else stands as delivered: the rigidity anchors (0 violations
of 31850 per level per prime), the `Z37` identification of five linearly
distinct open-demand forms with the zero form, the honest report that
the `I3` radical test adds nothing and the Rabinowitsch test on the
`m = 20` section is tautological for a `Z37` form.
