# Goal Q3 — descend a stable cubic from the primitive quartic resolvent

**Pinned state:** `141f6042f628f984771fc79d8d16beb12cedcb94`  
**Priority:** 6  
**Headline direction:** positive  
**Accepted output bridge:** a descended degree-three stable map or generalized twisted cubic gives a `K_Schur`-point

## Mission

Resolve the surviving primitive-quartic frontier for the genuine Schur twist.
In the no-point branch, Voisin's theorem and the existing secant analysis leave
a full-span quartic point whose Galois closure is `A4` or `S4`.  Pairing its
four conjugates gives a cubic-resolvent degree-three point.  The generic
three-point stable-map incidence is an integral cover of degree eight, but the
existing audit does not compute its pullback to the actual Schur-specific
quartic strata.

Compute that pullback and prove that it has a rational point, a forced
odd-degree component, or a rational multisection that descends to a stable
cubic.  Any resulting stable map closes Problem E positively through the
already-proved output bridge.

## Binding inputs

Consume and hash:

```text
goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/
goals_2026-08-01/Q_SCHUR_DESCENT/
goals_after_bd610a/M3_SARKISOV_SECTION/
goal_runs_after_35fa/S19_MARKED_CURVE/
```

and the exact primitive-quartic, resolvent-triple, enumerative degree-eight,
and generalized-twisted-cubic packets cited by Q's `COMPLETION_AUDIT.md`.
Do not replace the installed quartic by a general quartet.

## Q3.0 — canonical primitive quartic and resolvent spaces

Build the exact parameter spaces over `K_Schur` for:

1. the primitive full-span quartic point;
2. its `A4` and `S4` Galois closures;
3. the three pairings of four letters and the cubic resolvent algebra;
4. the corresponding three marked points on the cubic threefold;
5. the degree-eight incidence of degree-three stable maps through those
   points;
6. the generalized-twisted-cubic Hilbert compactification and its boundary.

Verify all maps commute with the actual Galois actions.  Keep the `A4` and
`S4` cases separate until an exact common argument is proved.

Required marker:

```text
Q3-QUARTIC-RESOLVENT-MODEL-PASS
```

## Q3.1 — Schur-specific monodromy of the degree-eight cover

Pull the degree-eight incidence cover back to each primitive quartic stratum.
Compute exactly:

- geometric and arithmetic monodromy;
- decomposition into connected components after the cubic resolvent splits;
- stabilizers of the eight stable maps;
- ramification and boundary monodromy;
- whether the `A4` or `S4` action has a fixed component, odd orbit, or
  invariant effective zero-cycle of degree prime to the remaining cover
  degrees.

The generic fact that the cover is integral after three points split is an
input, not the answer.  The worker must use the special relation among the
three points coming from a primitive quartic on the Schur twist.

Possible decisive outcomes include:

```text
one rational component;
an odd-degree component plus a proved descent theorem;
a degree-one zero-cycle on a rationally connected component with an applicable point theorem;
a canonical boundary stable map fixed by the Schur monodromy.
```

Do not infer a rational point merely from virtual count eight.

## Q3.2 — pullback through the symmetric-cube parameterization

Use the available rational/unirational parameterization of the relevant third
symmetric product.  Form the exact fibre product with the degree-eight
stable-map cover and search for:

1. a rational section over the primitive resolvent locus;
2. a low-degree multisection whose residual construction gives a section;
3. a conic or quadric bundle with a split generic fibre;
4. a rational boundary component corresponding to a reducible stable cubic.

Every rational map must be checked at the installed quartic, not only over a
general triple.

## Q3.3 — reducible and boundary stable cubics

The positive bridge accepts reducible stable maps.  Exhaust the boundary types
of degree three:

```text
line + conic;
three lines;
double line + line;
nonreduced generalized twisted cubics;
embedded-point boundary strata allowed by the Hilbert compactification.
```

For each type, derive exact incidence equations through the resolvent triple,
compute the Galois action, and test for a `K_Schur`-defined object.  A
`K_Schur`-defined conic plus residual line should be converted directly to a
point when possible.

## Q3.4 — bridge and verification

For any descended stable map or generalized twisted cubic:

1. verify the image lies on the authoritative genuine Schur twist;
2. verify degree, stability, and field of definition;
3. execute the existing residual/intersection bridge to a `K_Schur`-point;
4. transport the point to the G3 normalized cubic if useful;
5. invoke the accepted generic-torsor/versality implication and G3 dominance
   audit.

Deliver

```text
BRIDGE_STABLE_CUBIC_POS.md.
```

## Deliverables

Write under

```text
problems/E-klein-cubic/goal_runs_after_141f60/Q3_QUARTIC_RESOLVENT_STABLE_MAP/
```

Provide at least:

```text
INPUT_MANIFEST.json
QUARTIC_RESOLVENT_MODEL.md
quartic_resolvent.json
DEGREE8_PULLBACK.md
monodromy.json
SYMMETRIC_CUBE_PULLBACK.md
BOUNDARY_STABLE_MAPS.md
STABLE_MAP.md or HILBERT_POINT.md when obtained
POINT.md when obtained
BRIDGE_STABLE_CUBIC_POS.md when applicable
produce.py
verify_monodromy.py
verify_stable_map.py
verify_point.py
REPLAY.md
SEAL.json
STATUS.md
```

## Authorized exits

```text
Q3-STABLE-MAP-HEADLINE-POSITIVE
Q3-GENERALIZED-TWISTED-CUBIC-HEADLINE-POSITIVE
Q3-SCHUR-MONODROMY-PASS
Q3-BOUNDARY-REDUCTION-PASS
Q3-QUARTIC-RESOLVENT-MODEL-PASS
Q3-UNDECIDED
Q3-CANONICAL-INPUT-FAIL
```

Only the first two exits are headline candidates.
