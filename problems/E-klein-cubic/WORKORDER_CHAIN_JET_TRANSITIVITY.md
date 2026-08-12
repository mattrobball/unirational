# WORKORDER — Chain-level jet transitivity (morphism ledger L9)

Issued 2026-08-12 (director). python3 only (never gap/gp/sage/magma);
primes 331, 661; no git; packet
`goal_runs_20260812/CHAIN_TRANSITIVITY/` only. HOLD-FOR-DISPATCH: launch
after a worker slot frees (three lanes in flight).

## A. The layer

Along a closure chain `S ⊇ S′ ⊇ S″` of census strata, the morphism's
level/value data compose: the value and depth at `S″` computed through
`S′` (two steps of the stratified rule) must agree with the direct
`S → S″` rule. The coherence machinery imposes row→children
(length-2) consistency only; for the RELAXATION, composite-vs-direct
agreement along length-3 chains is a new, finite constraint layer
(values via character rules; depths via level additivity). Prove the
necessity lemma first (an actual morphism satisfies it — iterated
leading-term extraction), then impose.

## B. Tasks

1. Enumerate length-3 chains of the census closure poset on orbit
   representatives (the 145 order-0 relations generate; coordinate with
   `COCYCLE_COHERENCE`'s 2-chain enumeration if its packet exists — its
   triangles are the transversal side, yours is the jet side; do not
   duplicate its audit).
2. The transitivity conditions: per chain and per class, the composite
   level/value versus the direct rule; impose on the J census; per
   residue before/after; all-degree semantics; zero-class discipline as
   always (FLAG, audit gate).
3. Degree-35 application with the 22-anchor.

## C. Framing

Headline and packet protocol as standard (`THEOREM.md`, replayable
`verifier.py`, `REGISTRATION_SNIPPET.md`, ODDZERO format, E56, goal_run,
tracked true; exits `CHAINJET-*`). Summary ≤ 20 lines.
