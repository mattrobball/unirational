# Admissible-centre closure audit

## 1. Why D2.1 is conditional

Goal D2 orders D2.0 first and explicitly says to exit before a large
computation if no valid invariant and bridge are found.  `THEOREM_AUDIT.md`
finds none.  Consequently this packet does not launch a Hilbert-scheme,
base-ideal, or all-degree centre classification and does not pretend that a
bounded list would be exhaustive.

## 2. Explicit test of Goal D's free-orbit Prym centre

Goal D uses a genus-eleven Prym curve `C` embedded with trivial setwise
stabilizer and the smooth centre

\[
D=\coprod_{g\in G}gC.
\]

As a quotient stack,

\[
[D/G]\simeq C.                                   \tag{2.1}
\]

Thus a free-orbit blowup centre contributes ordinary curve data and induced
regular `G`-modules, but no new stabilizer group.  This has two consequences
for D2:

1. It still reproduces the unrestricted integral lattice and rational motive
   from Goal D.
2. It does **not** rescue the selected additive stack obstruction: that
   obstruction is already zero by Sylow detection before centres enter.

Hence the free-orbit centre is tested explicitly and neither falsely declared
admissible nor silently ignored.

## 3. Actual base-locus admissibility remains a separate theorem

A centre in a resolution of a landing covariant must arise from the
successive transforms of its base ideal.  The present repository has no
all-degree theorem imposing a finite list of stabilizers, genera, normal
bundles, or orbit types on such nonlinear centres.  Equivariant embedded
resolution by itself permits the free-orbit construction; it does not prove
that the curve occurs in an actual base ideal.

Accordingly:

- unrestricted closure is too large by Goal D;
- admissible closure is not characterized;
- and no candidate passing D2.0 exists to justify computing it.

This is an exact `D2-NO-VALID-BRIDGE` stopping point, not a statement that the
admissible closure equals the unrestricted closure.

## 4. What would reopen D2.1

One of the following would be sufficient to re-enter the closure package:

- an invariant with a proved relative-dimension-one transfer independent of
  `n`;
- a nonadditive stack class with an equivariant blowup formula;
- a structural theorem bounding all base-locus centre orbit types;
- or a theorem forcing the generic fibre degree subgroup to avoid one of the
  primes `2,3,5,11`.

None is installed at the consumed commit.
