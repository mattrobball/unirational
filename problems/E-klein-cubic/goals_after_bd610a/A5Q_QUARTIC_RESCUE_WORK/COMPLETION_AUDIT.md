# A5Q requirement-level completion audit

**Binding work order:** `GOAL_A5Q_INDEX11_QUARTIC_RESCUE.md`  
**Pinned state:** `bd610a032bb9561d2daeb91a2cb60c48c082ca2f`  
**Audit date:** 2026-08-01

## Verdict

Every mandatory A5Q work package has a theorem-level disposition.  Both
maximal `A5` classes produce exact reduced degree-eleven closed points on the
authoritative full Schur twist, and an exact square-space obstruction empties
the complete degree-four interpolation incidence for each of those two
points.  The terminal exits are therefore

```text
A5Q_INDEX11_CLOSED_POINT_OK
A5Q-INDEX11-CLOSED-POINT-PASS
A5Q-DEGREE4-RESCUE-EMPTY-SCOPED
```

No positive A5Q or Problem E headline is claimed.

## A5Q.0 — exact subgroup-to-full-twist descent

| requirement | disposition | certificate |
|---|---|---|
| Define the specific fields | `L_i=E^{H_i}` for the two installed subgroups; `[L_i:K]=11` | `SUBGROUP_DESCENT.md`, `FIELD_L1.json`, `FIELD_L2.json` |
| Give a primitive fixed-field interface | exact `H_i`-orbit-sum primitive elements, lazy degree-eleven resolvents, power bases, companion multiplication, trace and norm rules | `FIELD_L1.json`, `FIELD_L2.json` |
| Identify the induced torsor with a specialization of the versal `A5` torsor | the exact quartic Reynolds frame `B_i` is `H_i`-covariant; nonzero frame and free-locus minors prove a nonempty specialization open | `SUBGROUP_DESCENT.md`, `modular_index11_discovery.json` |
| Transport the exact point | `P_i=Q^{-1}J_i Phi_i(B_i e_0)` is an exact straight-line `H_i`-invariant expression | `SUBGROUP_DESCENT.md`, `INDEX11_POINT_CLASS1.json`, `INDEX11_POINT_CLASS2.json` |
| Verify the authoritative twist equation | exact landing gives `F(QP_i)=F(J_i Phi_i(B_i e_0))=0`; the independent replay reconstructs every reduced substitution | `CHARACTERISTIC_ZERO_LIFT.md`, `verify_all.py` |
| Prove a reduced degree-eleven closed point | all eleven projective conjugates are separated by explicit nonzero minors; characteristic zero is separable | `modular_index11_discovery.json`, `INDEX11_POINT_CLASS1.json`, `INDEX11_POINT_CLASS2.json` |
| Avoid a 660-dimensional expansion | the coset-orbit resolvent and Vandermonde interface reconstruct multiplication, trace, norm, and point coordinates lazily | `FIELD_L1.json`, `FIELD_L2.json` |

The primary specialization is at `p=89`; the unused holdout is `p=199`.
An independent primitive-resolvent replay at `p=23` proves that the exact
fixed-field generators have orbit size eleven.

## A5Q.1 — full degree-four incidence

`INTERPOLATION_INCIDENCE.md` supplies both the general evaluation/Fitting
system and the rank-five reduction.  It treats:

- an exact-degree-eleven parameter `tau=(1:x)` and a multiplier in `L^*`;
- the projective scaling and full `PGL2` freedom without an incomplete gauge;
- the determinantal rank-one multiplication locus and its exact-degree/unit
  opens after geometric base change;
- basepoint freeness and nondegeneracy, which are automatic after the
  certified coordinate rank five; and
- the separate `F(phi)=0` rational-curve and `F(phi)!=0` residual branches.

Thus no omitted affine chart, basepoint component, or `F(phi)` branch is used
to infer emptiness.

## A5Q.2 — solve both class incidences

The two classes are reconstructed and checked separately.  Their exact
coordinate spans have dimension five and their exact quadratic product
spans both have dimension eleven.  Any degree-four interpolation would make
the latter space

```text
Span(1,x,...,x^8),
```

of dimension nine.  The contradiction is independent of `x`, its support,
the multiplier, and every `PGL2` chart, so it disposes of the full incidence
rather than only a bounded or symmetry-adapted search.  Nonzero `11 x 11`
minors at `p=89` prove the characteristic-zero ranks, and the independently
reconstructed `p=199` records are an unused holdout.

Because the incidence is exactly empty, candidate reconstruction,
basepoint verification, and exact interpolation substitution have no
surviving object to process.

## A5Q.3 — residual identity

`RESIDUAL_IDENTITY.md` proves the conditional scheme-theoretic factorization
`F(phi)=g_tau*ell`, including the `F(phi)=0` branch.  The exact incidence is
empty for both installed points, so `phi`, `ell`, `rho`, and `phi(rho)` do
not exist in this packet.  The division gate is correctly reported as

```text
NOT_APPLICABLE_EMPTY_INCIDENCE
```

Consequently `POINT.md` and `BRIDGE_A5Q_POS.md` are not applicable and are
intentionally absent.

## A5Q.4 — scoped exit and variants

`VARIANTS.md` tests the requested directions with their strict theorem
boundaries:

- degree five is the first degree not excluded by the quadratic-rank gate,
  but no compatible quintic or Sarkisov-family comparison is constructed;
- the two nonconjugate coset actions forbid a naive eleven-line matching but
  do not by themselves exclude every common scroll or rational curve; and
- direct secants do not yield a degree-one residual orbit, while tangent
  residuals remain uninstantiated.

None produces an actual point or rational curve, and none is promoted.

## Output and replay audit

All mandatory unconditional artifacts are present: input manifest, subgroup
descent, two field records, two point records, interpolation and residual
notes, producer, raw result, independent verifier, status, replay guide,
completion audit, and seal.  Optional positive-branch files are absent for
the exact reason above.

`verify_all.py` is read-only, does not import the modular producer, rebuilds
the two subgroup actions and representations, verifies the primitive fields,
reconstructs every transported orbit and rank matrix at both transport
primes, and optionally runs the upstream exact characteristic-zero landing
verifier.  `make_seal.py --check` verifies every durable packet file.

## Strict theorem boundary

This packet resolves the named A5Q quartic-rescue goal with its authorized
scoped-empty exit.  It does not prove a rational point, rational curve,
pointlessness, or any positive or negative headline for Problem E.  The
overall Klein-cubic problem remains open.
