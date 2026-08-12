# WORKORDER — T6: the cone-order premise, audited at general degree
# (cycle 4, move 2 — the one unaudited premise)

Issued 2026-08-12 (director). python3 only (never gap/gp/sage/magma);
primes 331, 661; no git; packet `goal_runs_20260812/CONE_ORDER_AUDIT/`.

## A. The premise and why it matters at every degree

The sealed window machinery takes the profile `(m, r)` with
`r = ord_{ℓ_V}(T)` along the 55 V4-triple-lines and works in cells with
`r ≥ 6` ("the cone order r = 6": `D34_GUIDED_SWEEP/THEOREM.md` Tier note 4
says this reading is INHERITED from FIX-P1's `produce_slice.py` and
FIX-P2's `line_block`, not re-derived; the origin should be theory note
Note II — `theory/FIX_II_jets.md` is the likely file, confirm). Every
window at every degree (34 closed, 35 current, the 36–42 alive-table) is
scoped by it. If `r < 6` were possible for a landing covariant, cells
outside all those spaces exist AT EVERY DEGREE and the campaign's window
bookkeeping needs a correction. Nobody has audited this premise.

## B. Tasks

1. **Provenance:** locate the exact sealed statement and proof that
   forces `ord_{ℓ_V}(T) ≥ 6` (or whatever the true general statement is:
   a lower bound as a function of `d mod k`? an exact order?) — follow
   the FIX-P1 / Note II trail; quote it verbatim in the packet; classify
   its level per the transport note's discipline (tuple vs reduced-map).
2. **Independent machine verification, GENERAL DEGREE:** for a sweep of
   degrees covering all residues mod 6 (at least `d ∈ {31, …, 42}`, plus
   35 and 36 with extra care), compute the dimension of the space of
   covariants satisfying the OTHER sealed structure conditions but with
   `ord_{ℓ_V}(T) = r` for each `r < 6` (impose ord ≥ r, subtract
   ord ≥ r+1, or rank-compare). The premise predicts these cells are
   empty (dim of `ord ≥ r` equals dim of `ord ≥ 6` for r < 6, i.e. the
   conditions between r and 6 are free). Use the D34 engine's line-jet
   machinery (`line_block` analogues); both primes; saturation checks.
3. **Verdict:** CONFIRMED-AT-GENERAL-DEGREE (with the verified degree
   sweep and the located proof), or REFUTED (exhibit a degree and an
   explicit covariant with `r < 6` — a scope correction to every window
   statement including the current 22-cell census; flag loudly), or
   PROVENANCE-GAP (the machine confirms but no sealed proof exists —
   then the statement must be flagged as an empirical regularity and a
   proof demanded before further windows consume it).

## C. Framing

Headline: "Problem E remains OPEN; this packet excludes no degree."
Packet protocol as always (`THEOREM.md`, replayable `verifier.py`,
`REGISTRATION_SNIPPET.md`, tiering, exits `CONE-ORDER-*`, "Not claimed").
Summary ≤ 20 lines: the located statement and proof status, the degree
sweep table, the verdict.
