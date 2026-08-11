## 2026-08-11 Exclusion transport: residue classes pair up, and the repair's stakes change

Documents: `theory/EXCLUSION_TRANSPORT_20260811.md` (the mechanism and the
level audit) and `WORKORDER_STAGE1_STRATIFIED_DEGENERACY.md` (queue item 1,
re-issued under it). Probe: `director_probes_20260811/`. Problem E remains
**OPEN**; no degree is excluded by this entry.

The mechanism, absent from both the sealed record and the C1-C14 ledger: if
`T` is a dominant landing tuple of degree `d` and `J` any invariant, then
`J.T` is a dominant landing tuple of degree `d + deg J` presenting the SAME
map (`F(J.T) = J^3 F(T)`); precomposition with the double polar
`S_0 = grad(F-check) o grad(F)` (finite, coordinate degree 4) similarly
gives degree `4d`. So the existence set of landing-tuple degrees is closed
under `+3`, and mod-6 residue classes pair as `{0,3} / {1,4} / {2,5}`: a
tuple-level exclusion of one class at all large degrees empties its whole
pair at EVERY degree. Stronger, and unconditional: the director probe
(`director_probes_20260811/molien_director.py`, exact `Q(sqrt(-11))`
power-sum arithmetic, ALL sealed dimension anchors reproduced --
`dim M_25 = 189`, `dim M_34 = 576`, the polar covariants at degrees 2 and 4)
shows the invariant ring has a QUINTIC invariant, with invariants in every
degree `>= 5`; so `d + E` reaches every residue class mod 6 and a
tuple-level exclusion of a SINGLE mod-6 class at all large degrees closes
every degree.

Two consequences recorded. Backward: under the tuple-level reading, the
refuted `K(1)=K(3)=K(5)=0` would have meant "Problem E closed" (the odd
classes meet all three pairs), not "window moves to 36" -- transport was
absent from the program's reasoning, and the episode is the demonstration of
why the mechanism matters. Forward: the queued stratified-degeneracy repair
now carries closure stakes, so its workorder demands (i) tuple-completeness
of the corrected enumeration (imprimitive tuples stay inside the
relaxation -- this is what makes zeros transportable; audited in the note's
section 6: the sigma-band model constrains leading data of arbitrary tuples
and the parity layers are tuple-level, while Stage-2 pinning normalizes to a
reduced lift in its own section 0 and so is map-level like the mu bounds and
the C1/C2 graph ledgers -- those apply at the minimal presentation degree;
inside STAGE1_TIGHTEN the section-2.2 sigma-band factor K is the tuple-level
piece, the assembled mod-330 tables are not), (ii) the corrected saturation
statement Theorem S-prime -- under
stratified semantics the old S(c) monotonicity REVERSES (attainable
level-vector sets grow along `+6e_r` since `h_r(q_j) != 0` preserves every
section's vanishing orders), so only the stabilized pattern speaks for a
class, and (iii) a machine transport gate: multiplication by `F` shifts
`(a, psi, kappa)` by computable row data, and
`Phi_F(coherent at rho) SUBSET coherent at rho+3` must hold at all six
residues, both primes -- a test not expressible in the old semantics and one
that would have caught the odd-zero artifact immediately. Any zero the
repair produces is FLAGGED, not claimed; promotion gate is an adversarial
audit at ODDZERO standard.

Standing gate from this entry on: a claimed tuple-level class zero asserts
emptiness of its whole pair, so witnesses and zeros must be checked across
the pair, not the class; profile counts do not transport (only zeros do).

Also recorded, same day:
`theory/NOTE_NU1_ORDER_ONE_CONGRUENCES_20260811.md` -- the `nu = 1` fiber
lane (fibers-are-lines would force a G-invariant first-order congruence of
lines in P4 with base G-birational to X). Literature sweep (De Poi program,
Peskine): every CLASSIFIED first-order congruence base in P4 is non-cubic
(the quintic del Pezzo V5, products C x S -- both excluded against X by
Clemens-Griffiths -- and rational-surface types), but the classification has
one acknowledged gap (singular reduction of a non-reduced fundamental
surface), so "nu = 1 impossible" is not yet quotable as a theorem. The
equivariant leverage (G-stable congruence in G(1,4), invariant fundamental
surface on the arrangement) is the route to sealing it if C2's
`g_2^2 >= 3 d nu` ever forces small nu. Verdict class (b); secondhand
citations flagged in the note.

Exits: none (theory note + workorder + probe; no theorem about degrees
claimed, no count changed).
