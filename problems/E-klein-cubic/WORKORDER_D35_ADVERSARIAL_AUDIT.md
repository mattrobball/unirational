# WORKORDER — Adversarial audit of the d = 35 kill tables, plus the linkage repair

Issued 2026-08-11 (director, cycle 3). Mission: try to BREAK the new
degree-35 facts. Confirmation is only meaningful if refutation was
genuinely attempted (the ODDZERO standard). python3 only (never gap/gp/
sage/magma — shell aliases trap); no git; packet
`goal_runs_20260811/D35_AUDIT/` only.

Context to read first: `goal_runs_20260811/PAIR_ATTACK_D35/THEOREM.md`
(§§10–12) and `WORKED_EXAMPLE.md` (all sections, including the §6
retraction — one census was already withdrawn, which is why this audit
exists); scripts `director_worked_example.py`, `director_finish_d35.py`,
`director_survivors22.py`.

## Targets (verdict CONFIRMED or REFUTED per item, with witnesses)

- **T1 (the big one): `ord ≥ 2` impossibility.** On the sealed 39-dim
  Layer-0 slice, vanishing on one minus-line plus vanishing of all three
  transverse first derivatives has rank exactly 39 (dim 0). This killed
  398 patterns. Rebuild WITHOUT the incumbent evaluation path
  (`slicelib.jet_rows`): construct the slice's covariants by your own
  Reynolds-sum evaluation code, sample your own points/directions, use a
  THIRD prime (991 works: 990 is divisible by 5 and 11) in addition to
  331/661, different random seeds.
- **T2: the universal six-flip cut** (rank 2 on the slice; ambient rank
  exactly 2 — matching ODDZERO F1 by construction-independent routes).
- **T3: the 14-row vanishing table** (level-0 readings identically zero
  on the slice at 14 of the 18 value-defined rows of the plus divisor
  row) — with the CORRECT interpretation: readings live deeper; NOT a
  value contradiction except at period-2 children.
- **T4: the depth-parity semantics.** Verify against
  `STAGE1_TIGHTEN`/`s3jet.py` and ODDZERO that exactly the six
  type-I-plus-plane V4-children have arc-character period 2 on the
  `D_{P_σ}` row (value alternates with depth) and every other child's
  value is depth-constant. This is the assumption whose earlier misuse
  forced the §6 retraction — pin it to a machine check.
- **T5 (new observation, verify or refute):** the six flip functionals
  lie in the span of the plain line-evaluation functionals
  (joint rank 10 = rank V1; on the 37-cell the line-vanishing system has
  rank 8). If confirmed, record the geometric reason if you can find one.
- **T6 (premise inheritance — added 2026-08-11 after a director check):**
  the 39-space is the sealed `(m, r) = (1, 6)` window cell
  (`D34_GUIDED_SWEEP/THEOREM.md`, the `d = 35` box). The plane conditions
  are theorem-forced (parity: `m` odd hence `≥ 1`; sweep: plus-part
  `≥ 2`), and the space CONTAINS every profile with `r ≥ 6` (deeper
  line-vanishing is a subspace), so those cells inherit the kills. What
  the session did NOT re-derive: that `ord_{ℓ_V}(T) ≥ 6` holds for every
  landing covariant ("the cone order r = 6", inherited by D34 from
  FIX-P1/Note II rather than re-proved). Verify that Note II / FIX-P1
  chain: if `r < 6` were possible, cells outside the 39-space would exist
  at `d = 35` and the census scope statement must be corrected.

## The linkage repair (required, same packet)

The pattern pipeline (`patterns_r5.py` + `build_tagged_ff_tables`)
rebuilds its tables non-deterministically (observed: same command,
different flip/keep splits for the same stored pattern across runs).
1. Locate the nondeterminism source (unseeded randomness or order
   dependence in `Stage1`/tagged construction) and fix it by explicit
   seeding/ordering IN YOUR PACKET's re-emitter (do not edit sealed
   scripts).
2. Re-emit the 756 patterns with their full assignment dictionaries
   EMBEDDED and content-hashed (`patterns_r5_content_p{331,661}.json`) —
   no index-into-rebuilt-tables indirection.
3. Verify: three independent runs byte-identical; the splits
   756 = 336 (multidegree) + 398 (ord ≥ 2 branches only) + 22 (a
   line-order-0 branch) reproduce; the 22 ids/hashes match
   `results/survivors22_p*.json`.

## Protocol

Packet `goal_runs_20260811/D35_AUDIT/`: `THEOREM.md` (the harness refuses
the name REPORT.md), `scripts/`, `results/`, replayable `verifier.py`
(check groups T1–T5 + repair), `REGISTRATION_SNIPPET.md` (ODDZERO format,
entry E56, kind goal_run, tracked true). Honesty tiering; exit ledger
(`D35-AUDIT-*`); "Not claimed" section. Headline fixed: "Problem E
remains OPEN; this packet excludes no degree." Any REFUTED verdict is
more valuable than a confirmation — state it loudly, with the witness.
Print a ≤ 25-line summary: per-target verdicts, third-prime results,
repair status.
