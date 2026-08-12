# WORKORDER — The cocycle layer: 2-chain coherence of the pattern census

Issued 2026-08-12 (director). python3 only (never gap/gp/sage/magma);
primes 331, 661 where modular data enters (the core is exact finite
group theory); no git; packet `goal_runs_20260812/COCYCLE_COHERENCE/`.

## A. The unused layer

The pattern census works on orbit representatives: rows carry
transversal elements (`kid["tr"]` in the Stage-1 machinery), and
coherence is imposed PAIRWISE (shared-child value equality after
transversal transport). A morphism of quotient complexes must also
satisfy the cocycle condition on 2-CHAINS: for every triangle of
closures `S'' ⊆ closure(S') ⊆ closure(S)` met through orbit
representatives, the composed transversal transports and the direct one
must give the SAME identification of value data (up to the target
stabilizer). Pairwise consistency does not imply triangle consistency.
Nothing in the record imposes the triangle layer.

## B. Tasks

1. **Audit first:** determine exactly what `s1coherence` / the join
   machinery already impose (document with line references) — if the
   triangle layer is already implied by their `canon`/transversal
   scheme, PROVE it and stop (that is a valuable verdict too:
   `COCYCLE-ALREADY-IMPLIED`).
2. If not implied: enumerate the 2-chains of the census closure poset
   (orbit representatives; the 145 order-0 relations generate the
   edges), compute the triangle conditions as finite group-theoretic
   compatibility tests on value assignments, and re-run the tuple-level
   census (`TUPLE_JOINT_RESIDUE` semantics) with the triangle layer ON:
   the joint table `J` per residue mod 6, before/after. Degree enters
   only through residue classes — verdicts are ALL-DEGREE.
3. Apply at the degree-35 class: which of the 22 (and of the dead-1242
   bookkeeping) change status. The 22-anchor discipline as usual.

## C. Framing

Headline: "Problem E remains OPEN; this packet excludes no degree." A
class-count DROP is expected and fine; a class ZERO is the transport
scenario — FLAG, never claim, ODDZERO-standard audit named as gate,
tuple-completeness re-verified (the triangle layer must be a necessary
condition of an actual equivariant morphism — prove that lemma in the
packet before using it). Packet protocol as always (`THEOREM.md`,
replayable `verifier.py`, `REGISTRATION_SNIPPET.md`, ODDZERO format,
entry E56, goal_run, tracked true; tiering; exits `COCYCLE-*`; "Not
claimed"). Summary ≤ 25 lines: audit verdict, triangle-layer size, J
before/after per class, effects at 35.
