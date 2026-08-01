# Goal J2 completion audit

## Requirement-level verdict

The exact exit is

```text
J2-UNRESTRICTED-COUNTERMODEL-EXTENDS
```

The “unrestricted” construction extends in the precise sense relevant to
Goal J2: conditional on any primitive landing covariant, a Prym-bearing
centre can be inserted **inside its forced base cosupport** and included in
an equivariant log resolution of the same five-form ideal.  This refutes a
resolution-invariant centre/Prym obstruction.  It does not construct a
landing covariant and does not settle Problem E, whose headline remains
**OPEN**.

## Work-package ledger

| package | delivered result | status |
|---|---|---|
| J2.0 | Goal D reconstructed; every proposed base-locus screen audited; \(C_2\)-stabilized replacement inserted in a forced plane | complete, countermodel extends |
| J2.1 | exact fixed exceptional eigenbundles, six-component regular \(S_3\) system, affine order-three quotient; resolution invariance disproved | complete by refutation |
| J2.2 | ideal containment, odd multiplicity, incidence, normal characters, transition and coefficient non-coupling | complete, no contradiction |
| J2.3 | exact genus/projection data, induced Hodge map, scalar 198, lattice/localization, CM, polarization, parity, Mackey audit | complete, compatible |
| J2.4 | admissible conditional base-locus centre system and exact route exit | complete |

## Logical dependencies

The result uses exactly these installed inputs:

1. every involution plus-plane is a base component of common odd order;
2. the plane stabilizer is \(D_{12}\), with generic point stabilizer \(C_2\)
   and residual \(S_3\);
3. \(H^{2,1}(X)|_{C_2}\) has invariant dimension \(3\);
4. \(J(X)\) is the Prym of the connected etale double cover of a genus-six
   plane quintic;
5. characteristic-zero equivariant embedded resolution/principalization;
6. the corrected relative-dimension-one identity
   \(r\circ f^*=n\,\mathrm{id}\).

No bounded search, sampled coefficient computation, or assumed landing
covariant is promoted to an unconditional theorem.

## Independent checks

`produce.py` derives `payload.json` from the upstream certificates and exact
arithmetic.  `verify.py` does not import the producer.  It independently:

- enumerates \(\operatorname{PSL}_2(\mathbf F_{11})\) as 660 projective
  matrix classes;
- verifies the chosen involution, its centralizer of order 12, the orbit
  size 330, and six fixed components;
- recomputes the genus, projection degrees, plane degree, normal ranks,
  rank 67980, and averaging scalar 198;
- recomputes the regular \(S_3\) character decomposition and the order-three
  affine cohomology class;
- checks upstream source hashes, self-hash, status boundary, document
  markers, and every sealed digest.

## Remaining theorem boundary

No required J2 artifact remains open.  What remains open is the main
existence problem and any future attempt to define a canonical coefficient-
coupled invariant which survives changes of principalization.  Those are
new goals, not incomplete portions of this packet.
