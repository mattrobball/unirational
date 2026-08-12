# WORKORDER — Sieving the 508 extended blueprints at d = 35

Issued 2026-08-12 (director). python3 only (never gap/gp/sage/magma —
shell aliases trap); primes 331, 661; no git; packet
`goal_runs_20260812/D35_EXTENDED_SIEVE/` only.

Context: `TUPLE_JOINT_RESIDUE` shows the tuple-level census at the
degree-35 class is J(5) = 1264, not 756 — the extra 508 blueprints use
period-3 level-2 value assertions licensed by the sealed depth table
(`DEPTH_TABLE_GENERAL`) but absent from the period-≤2 enumeration that
the 756→22 sieve ran on. Sieve the 508 with the audited instruments.

Read first: TUPLE_JOINT_RESIDUE (THEOREM + results — regenerate its ρ=5
joint patterns; they carry the level assertions), PAIR_ATTACK_D35
(THEOREM §§10–12, WORKED_EXAMPLE incl. §7; scripts director_worked_example.py,
director_finish_d35.py, director_survivors22.py — reuse the machinery),
DEPTH_TABLE_GENERAL (the level menus and the d=35 keep-pass: level-1/2
functionals vanish identically on the 37-cell at the period-3 rows),
D35_AUDIT (canonical content-addressed blueprint format — emit the 508
the same way).

Tasks:
1. Materialize the 508 as content-addressed records (assignments + level
   assertions embedded).
2. Kill layers, in order, on the 39-slice/37-cell: multidegree
   (`m ∈ {3,5}` slices are empty — sealed); the line-order finisher
   (`ν ≥ 2` impossible — sealed); the universal six flips (rank 2).
   Report per-layer deaths.
3. The genuinely new layer: at the 12 period-3 children, extend the
   arc-jet ladder on the cell to `κ = 3, 4, 5` (the DEPTH machinery plus
   `p2lib.jet_rows2`-style double jets; rigidity anchors mandatory at
   every level). A blueprint asserting a level-2 value needs the κ=2
   reading — identically zero on the cell — so its assertion rides on
   κ = 5 (period 3): if the κ=5 functional also vanishes identically on
   the blueprint's cut, iterate to κ = 8; a level-`κ≡2` assertion with
   ALL its admissible levels identically zero and a DIFFERENT value
   demanded by closure is dead — state each death's exact mechanism.
4. Final d=35 census: 1264 = (dead by each layer) + (live cells with
   dims ≤ 37). The 22 must reappear unchanged (anchor). Cross-prime.

Framing: headline "Problem E remains OPEN; this packet excludes no
degree"; any all-dead outcome FLAGGED behind an ODDZERO-standard audit,
never claimed. Packet protocol as always (`THEOREM.md` — never
REPORT.md — scripts/, results/, replayable `verifier.py`,
`REGISTRATION_SNIPPET.md`, ODDZERO format, entry E56, goal_run, tracked
true; tiering; exits `D35-EXT-SIEVE-*`; "Not claimed"). Summary ≤ 25
lines: per-layer death table over the 508, the final live count and
dims, the 22-anchor status.
