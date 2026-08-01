# COV.2 degree-31/35 packet

Exit: `COV-UNDECIDED`. The headline remains **OPEN**.

This packet addresses
`goals_after_35fa8f/GOAL_COV_M1_EQUALIZERS_DEG31_35.md` at pinned state
`35fa8f59b6a1423cc89300aeaceefe91552be5ba`. The live head at intake was
`37d61c19a108781cf74af837e24810a9f7f7c3be`.

## What is exact

- Fixed characteristic-zero literal `K1` bases have dimensions `198` and
  `361`. The exact dimension sandwiches use full self-covariant dimensions
  `410,637`, restriction ranks `212,276`, and fixed cross-circuit minors at
  the unused split primes `419,463`.
- The fixed dual list contains the 59 Hironaka generators through degree 24.
  The full numerator also has one degree-27 generator, but it cannot occur in
  a fourfold wedge of total degree at most 35 and is therefore not needed.
- The eight ordered equalizer stages use one literal global coefficient
  vector. All downstream restriction-difference circuits are zero; compact
  special-fibre classes outside the literal global image are excluded.
- Fixed positive-invariant-multiple subspaces have dimensions `197,361`.
  Thus the standard module quotient has dimension at most one in degree 31
  and exactly zero in degree 35.
- `primitive_quotient_counterexample.json` proves that this is not a
  primitive-covariant quotient: in each degree a fixed sum of two
  positive-multiple circuits lies in the quotient kernel but has component
  gcd one, certified by an independently replayed line Bezout identity.
- The complete landing ideals have `5349` cubics on `198` parameters and
  `8555` cubics on `361` parameters. Each is stored as exact Klein-cubic
  expressions in nodal linear forms; the nodal evaluation determinant on the
  full invariant Hironaka basis is nonzero at both primes.
- The `C3`-line/`C6`-point landing gate is imposed before saturation.  Its
  exact ranks `11,13` reduce the decision fibres to `187,348` parameters;
  the result agrees at split primes `463,727`.
- The complete `p=463` factored circuits are materialized on both reduced
  kernels.  The restriction-zero strata have dimensions `177,336`; the
  nonzero-restriction complements have exact covers by `10,12` scalar-form
  normalization charts.
- The based branch is reduced again by its first transverse Taylor landing
  condition.  Cumulative ranks `51,61` leave complete systems on `147,300`
  variables; these split into `17,11` first-normal nonbased charts and
  second-based vector dimensions `130,289`.  The ranks agree at `p=463,727`.
- Pure and mixed second-normal gates continue the based recursion through
  `99,247` and `78,204`.  Their nonzero scalar branches have `7,24` and
  `13,20` charts; the scalar-zero third-based systems have complete factored
  equations on only `65,184` variables.  All ranks agree at both primes.

## Boundary

The nonlinear equation `F(p)=0` does not descend through the linear module
quotient: the sealed witnesses show that a sum of factorable directions need
not itself have a common factor. The projective saturation of the full landing ideals away from the
actual factorable and composition incidence loci remains undecided. Goal
P25.2 is also a binding dependency, since a degree-25 landing covariant can
be multiplied by degree-6 and degree-10 invariants to land in degrees 31 and
35. Accordingly this packet proves neither full-degree emptiness nor a
positive covariant.

## Replay

From this directory, with NumPy available:

```text
/opt/homebrew/bin/python3 make_seal.py
/opt/homebrew/bin/python3 verify_all.py
```

The verifier is read-only and ends with
`COV_M1_DEG31_35_VERIFY_OK`. `SEAL.json` covers only the accepted artifacts;
unsealed exploratory and diagnostic files are not part of the result. The
verifier independently rebuilds the four square invariant evaluation
matrices and their exact modular determinants; the degree-35 step therefore
needs roughly one GiB of available memory.

The three generated degree-31 third-pure msolve inputs exceed GitHub's
100 MB per-file limit and are intentionally local. Rebuild them with
`export_d31_third_pure_msolve.py --chart 0`, `--chart 1`, and `--chart 2`;
the exporter and the compact source arrays are part of this packet.
