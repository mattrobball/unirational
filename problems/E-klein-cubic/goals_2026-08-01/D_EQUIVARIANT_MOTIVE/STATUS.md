D-INVARIANT-REPRODUCIBLE

# Goal D status

**Headline for the Klein cubic:** **OPEN**. This packet does not prove or
disprove \(G\)-unirationality.

**Route verdict:** the selected integral equivariant cohomology lattice and
rational equivariant motive are reproducible inside the unrestricted closure
of \(\mathbf P^4\) under smooth equivariant blowups. The standard
Rost/Merkurjev index-valued degree formulas are vacuous on every Klein twist
because every twist has index one. The proposed integral-summand bridge is
also false without controlling the multisection degree \(n\): the actual
identity is \(r i=n\,\mathrm{id}\), not \(r i=\mathrm{id}\).

This is the exact scoped exit authorized by Goal D. A future negative route
must add a genuine base-locus restriction on nonlinear centres or introduce a
new mixed-prime quotient-stack invariant; it cannot use the audited invariant
alone.

## Repository state

- pinned mathematical baseline: 715faf441289e2589b9325311b6613ea0331bf88
- initial inspection head: 2140419410cfff2f7d7dcca166acef8c16a0d41b
- live repository commit consumed after concurrent waypoint audit:
  80f24697dd8fcb1ee0e8fff86e3d8e38a9cfc09c
- produced commit: PENDING-SCOPED-COMMIT
- work is contained in D_EQUIVARIANT_MOTIVE/

## Replay

From this directory:

~~~text
/opt/homebrew/bin/python3 produce.py
/opt/homebrew/bin/python3 seal.py
/opt/homebrew/bin/python3 verify.py
~~~

Expected terminal markers:

~~~text
D_EQUIVARIANT_MOTIVE_PRODUCE_OK
D_EQUIVARIANT_MOTIVE_SEAL_OK
D_EQUIVARIANT_MOTIVE_VERIFY_OK
~~~

The producer is deterministic. verify.py independently recomputes the Chern
and index arithmetic, enumerates
\(\operatorname{PSL}_2(\mathbf F_{11})
=\operatorname{SL}_2(\mathbf F_{11})/\{\pm I\}\)
as a 660-element group, checks the equivariance identity for all \(660^2\)
pairs, and verifies every sealed content hash.

## Theorem boundary

Proved:

1. all classical index-valued same-dimension degree formulas in the audited
   family have target group \(\mathbf Z/1\mathbf Z\) on every torsor twist;
2. relative-dimension-one dominance forces a summand only after inverting the
   uncontrolled fibre degree \(n\);
3. a concrete free orbit of Prym curves supplies a smooth equivariant blowup
   centre whose contribution contains \(H^3(X,\mathbf Z)\) primitively as a
   \(G\)-lattice and contains the rational \(G\)-Hodge structure and rational
   \(G\)-motive of \(X\) as summands;
4. the target Chern, ordinary Chow, cohomology, and Steenrod data recorded in
   TARGET_INVARIANTS.md are exact.

Not proved:

1. the existence or nonexistence of a dominant \(G\)-equivariant map to \(X\);
2. an integral or mod-\(p\) equivariant Chow-motive splitting at
   \(p=2,3,5,11\);
3. that the constructed curve orbit occurs in the base locus of a landing
   covariant.

Those exclusions are part of the verdict, not deferred claims.
