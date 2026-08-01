# Goal G work log

## Isolation and intake

All artifacts made by this run are confined to this directory.  The sibling
goal folders and the sealed packets under `../certificates/` and `../tmp/`
are read-only inputs.

The live repository state consumed at intake is

```text
HEAD = 2140419410cfff2f7d7dcca166acef8c16a0d41b
pinned mathematical baseline = 715faf441289e2589b9325311b6613ea0331bf88
```

The pinned baseline is an ancestor of `HEAD`.  The binding Goal G inputs are
unchanged on that ancestry interval; the later degree-25 work is relevant
only as an additional warning that sampled closure can fail.

During the run the shared worktree advanced through the committed waypoint
`53e267a59b2d24de93c58dd9ddacc2f995fc2d68`.  The Goal G directory was
re-audited after that change.  All edits and generated artifacts from this
run remain confined to this directory; sibling worker changes were neither
rewritten nor staged.

## Requirement audit

The requested headline is not a bounded covariant exclusion.  It requires
one of the following:

1. a proof that every complete global landing support is empty in every
   admissible `(m,d)`, followed by the source-exhaustiveness bridge; or
2. one exact global coefficient vector satisfying the original Klein cubic
   identity and the dominance bridge.

The following installed facts cannot be promoted to either conclusion:

- the nonzero linear inverse limit;
- the degree-13 and degree-19 sample residuals;
- the degree-25 particular residual;
- finite generation of fixed-order local modules;
- the sheaf-level line-kernel/point-kernel architecture;
- a finite presentation of the full covariant module without deciding its
  cubic isotropy locus.

## Rejected shortcuts

### Local symbolic finite generation

For each fixed plane order `m`, the sheaf architecture is exact and literal
graded pieces agree after the bound `d >= 55m+109`.  This is not uniform
finite generation in `m`.  The degree-35 split-fibre torsion defect also
refutes the proposed all-degree `f3`-colon shortcut for `m=1`.

### Finite covariant generators

The complete self-covariant module is finite, and in fact free of rank 60
over the five-primary polynomial ring.  Its landing set is not a submodule.
The first isotropic element is therefore not bounded by the degrees of the
module generators.  Localizing at the five-vector frame turns the question
into the same generic twisted cubic, not a finite degree ladder.

### Existing Fable lift

The high-twist Fable class is a genuine compatible section through the first
cubic gate, but its prescribed order-three/order-four boundary is killed by
the exact Veronese-syzygy and elliptic-trace obstruction.  It is not a formal
all-order solution and cannot be algebraized into a positive covariant.

## Live structural route

`UNIVERSAL_OBJECT.md` replaces the false claim that the local inverse limit
itself is the universal coefficient object.  The exact object is the global
covariant module together with its symbolic filtration and all restriction
maps.  Its generic fiber is the explicit twisted Klein cubic.  The remaining
support question is therefore a single rational-point problem, while the
symbolic equalizer remains a necessary filtration used to attack that point.

The next new theorem under development is the all-order first-plane gate:
at every odd plane order, the first nonautomatic landing equation is a
quadratic-Veronese syzygy.  It forces the even successor jet into the ideal
of the primitive components of the odd leading jet.  Any divisorial common
factor on which the successor is nonzero carries an equivariant map to the
fixed elliptic cubic; its finite trace excludes factor degree not divisible
by three.  This is degree-independent, but by itself it does not yet kill
the primitive case or common factors of degree divisible by three.

## Exact generic cubic

The abstract generic-frame reduction was materialized as 35 coefficient
vectors in the certified Hironaka basis.  The producer expands the original
Klein cubic in the literal frame, groups coefficients by invariant degree,
and asks Macaulay2 to solve exact `QQ` coefficient identities.  The verifier
does not trust those solved rows: it rebuilds every primary-secondary
polynomial and compares sparse expanded dictionaries with the original
polar coefficient.

The exact replay returns

```text
G_GENERIC_CUBIC_35_COEFFICIENT_IDENTITIES_OK
G_PROJECTIVE_NORMALIZATION_35_COEFFICIENTS_OK
```

No rational point or pointlessness certificate emerged.  Adjacent route
audits also show that index one, selected subgroup points, locally soluble
axis valuations, and bounded composition ansatzes do not decide this generic
support.  They are not imported as evidence for either headline.

## Parallel exact attacks

The post-reduction phase used four isolated subdirectories.  Every theorem
below has its own verifier and is included in the aggregate replay.

1. `attacks/constructive_point/` rebuilt all ten binary frame restrictions
   from the original covariants.  Absolute factorization excludes every
   two-frame point even over `C(W)`.  A separate full-rank coefficient
   certificate excludes constant normalized coordinates.  The finite
   signed-basis probe is retained only as bounded discovery.
2. `attacks/local_infinite_descent/` completed the symbolic triple-line
   recurrence in all layers.  The accepted order-three trisection is gcd-one
   in the abstract projective-character model, but the actual `W`-character
   correction adds a common line factor.  Propagation and scalar finite-jet
   annihilation therefore establish unsaturated local survival, not a
   primitive actual covariant and not failure of every saturated point-link
   obstruction.  The sharp degree-three elliptic trace and scalar-gcd audit
   locate precisely where local descent stops before saturation and global
   nonlinear plane compatibility.
3. `attacks/valuation_obstruction/` applied Coray's complete-DVR theorem to
   the universal effective degree-55 cycle.  This proves actual points over
   the standard successive complete-DVR fields of saturated geometric
   length-three/four Parshin chains; it makes no claim for arbitrary
   rank-valuations, henselizations, or a local-global principle.
4. `attacks/zero_cycle_containment/` applies Voisin's cubic-surface theorem
   to the genuine degree-55 line-orbit point, reducing the no-point branch to
   one primitive quartic point with `A4` or `S4` closure.  It then isolates
   the missing splitting-field hypothesis in the small-residual route,
   verifies a smooth cubic countermodel, and checks that the installed
   closed-point degree bound does not yield a decreasing iteration.

The consolidated requirement ledger is `ATTACKS.md`.  These are structural
route decisions only; the binary generic-cubic support remains undecided.

## Exit discipline

The completed work proves a corrected universal object, a counterexample to
the proposed finite-generator cutoff, an exact finite generic cubic, and a
new all-odd-order first gate.  This meets the work order's structural exit,
but not its positive or negative headline.  The status is therefore
`G-STRUCTURAL-UNDECIDED`.
