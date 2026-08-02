# T3 fixed-frame cubic discriminant discovery

Status: exact discriminant constructed and factored; the plane boundary
`A=15,Y=12` is certified to have contact order two and one generic ordinary
node.  This is not yet the full T3.D contact ledger.

## Authoritative cubic

The sealed tracked coefficient source is
`certificates/fixed_frame_arithmetic/five_forms.json` (SHA-256
`61377d6e464f7c78cf1fa91d13610b76dc4567de7b7214256e04de50066c83a4`).
It represents coefficients in the ascending basis
`1,zeta11,...,zeta11^9` of `QQ(zeta11)`.

Write

```text
Q_i = q0_i + A*qA_i + Y*qY_i                         (i=0,1,2)
R_j = r0_j + A*rA_j + B*rB_j + Y*rY_j
      + (Z-11*A^2/18)*rZ_j                           (j=0,1,2,3).
```

Then the authoritative fixed-frame cubic is

```text
F = X^3 + X*(Q0*v^2 + Q1*v*w + Q2*w^2)
        + R0*v^3 + R1*v^2*w + R2*v*w^2 + R3*w^3.
```

The `q*` and `r*` vectors are the `binary_slots` in `five_forms.json`.
Equivalently, they are reconstructed from the exact normalized coefficient
rows by `tmp/pfaffian_global_fixed_frame_hostile_audit/verify.py`.

On the certified target line `(A,B,Y,Z)=(1,2,3,s)`, this becomes

```text
F_s = X^3 + X*(q0+qA+3*qY)
            + r0+rA+2*rB+3*rY+(s-11/18)*rZ.
```

The degree-21 polynomial `H21(s)` in
`tmp/full_scaled_frame_branch_line_hostile_audit/certificate.json` selects the
same target divisor as the exact global degree-43 factor
`certificates/target_branch_global/H_factor/H_primitive_integer.tsv`.

## Exact discriminant convention

For scalar coefficient variables `(q0,q1,q2,r0,r1,r2,r3)`, the independently
audited universal formulas are

```text
c4 = 16*q0^2*q2^2 - 8*q0*q1^2*q2 + 144*q0*r1*r3
     - 48*q0*r2^2 + q1^4 - 216*q1*r0*r3 + 24*q1*r1*r2
     + 144*q2*r0*r2 - 48*q2*r1^2

c6 = 64*q0^3*q2^3 + 864*q0^3*r3^2 - 48*q0^2*q1^2*q2^2
     - 864*q0^2*q1*r2*r3 - 864*q0^2*q2*r1*r3
     + 576*q0^2*q2*r2^2 + 12*q0*q1^4*q2
     + 648*q0*q1^2*r1*r3 + 72*q0*q1^2*r2^2
     + 1296*q0*q1*q2*r0*r3 - 720*q0*q1*q2*r1*r2
     - 864*q0*q2^2*r0*r2 + 576*q0*q2^2*r1^2 - q1^6
     - 540*q1^3*r0*r3 - 36*q1^3*r1*r2
     + 648*q1^2*q2*r0*r2 + 72*q1^2*q2*r1^2
     - 864*q1*q2^2*r0*r1 + 864*q2^3*r0^2
     + 5832*r0^2*r3^2 - 3888*r0*r1*r2*r3
     + 864*r0*r2^3 + 864*r1^3*r3 - 216*r1^2*r2^2

Delta_cub = (c4^3-c6^2)/1728.
```

They are stored as exact 9-term and 25-term integer tables in
`tmp/pfaffian_minimal_ternary_model/certificate.json` (SHA-256
`02adb86f676cdef7c4200c483d7309de5e8ae207d64becc541ac33122ef42895`).

## Constructed polynomial and exact tests

After fixed-frame substitution:

```text
c4:        32 terms, total degree 5, multidegrees (5,2,3,2)
c6:        88 terms, total degree 7, multidegrees (7,3,4,3)
Delta_cub: 719 terms, total degree 15, multidegrees (15,6,9,6)
```

Singular exact factorization over `QQ(zeta11)` returns a unit and one
exponent-one degree-15 factor with 719 terms: `Delta_cub` is irreducible over
`QQ(zeta11)`.  At the good split reduction `zeta11=9 mod 67`, it remains one
exponent-one irreducible degree-15 factor (715 nonzero terms).

Exact pullback tests:

- On `(1,2,3,s)`, `deg Delta_cub=6`, `deg H21=21`, and their gcd over
  `QQ(zeta11)` is one.  Thus the selected target component is not contained in
  the cubic discriminant.
- On the characteristic-zero degree-12 RUR at `A=0,B=2`, substituting
  `Y=NY/Hprime`, `Z=NZ/Hprime` gives a nonzero degree-11 remainder modulo `H`
  with gcd one.  None of those twelve RUR points lies on `Delta_cub=0`.
- Among the 65 saved mod-67 slice critical samples, exactly one lies on
  `Delta_cub=0`: `(A,B,Y,Z,u)=(0,2,45,35,22)`.  The old binary-sextic proxy
  also labels `(0,2,30,41,56)` singular, but the true discriminant there is
  `41 mod 67`; this confirms that the proxy can have false positives.

## Exact plane boundary `A=15,Y=12`

Put `a=A-15` and `y=Y-12`.  Direct restriction of the exact degree-43 target
polynomial `H` and `Delta_cub` gives

```text
H|plane = H_Y|plane = 0,       H_A|plane != 0,
Delta|plane = Delta_Y|plane = 0, Delta_A|plane != 0.
```

The exact polynomial

```text
N = Delta_YY*H_A - Delta_A*H_YY
```

is nonzero (404 terms, total `B,Z` degree 27).  Consequently, at the generic
point of this plane, `H` is smooth and

```text
a = -(H_YY/(2*H_A))*y^2 + O(y^3),
Delta|H = (N/(2*H_A))*y^2 + O(y^3).
```

Thus the contact multiplicity on the normalization is exactly two.  This
plane is contained in the boundary factor `A-15` inverted in the earlier
`S_G` packet, so it must be entered separately in the T3.D ledger.

## Generic cubic singularity on that plane

Over `QQ(zeta11)(B,Z)`, the common gcd of the two parameter directions
`rB(t),rZ(t)` is exactly `(t-t0)^2`.  The resulting point
`[x0:t0:1]`, with `x0=-r_base'(t0)/q'(t0)`, is independent of `B,Z` and
satisfies all singular-point equations exactly.

In translated coordinates `du=X-x0`, `ds=t-t0`, the cubic identity is

```text
f = Q2 + C3,
Q2 = 3*x0*du^2 + q'(t0)*du*ds + (F_tt/2)*ds^2,
C3 = du^3 + (q''/2)*du*ds^2 + r0(B,Z)*ds^3.
```

At any further affine singular point, homogeneous Euler identities force
`Q2=C3=0`.  Their exact direction resultant is a nonzero 10-term polynomial
of total `B,Z` degree three, so no such point exists generically.  In the
chart `v=1,w=0`, the nonzero six-term obstruction
`3*r1(B,Z)^2+q0*q1^2` excludes a singular point at infinity.

Finally, the Hessian determinant at `[x0:t0:1]` is a nonzero three-term
linear polynomial in `B,Z`.  Hence the local Jacobian algebra has length one
and the quadratic tangent cone is nondegenerate: the generic cubic has
exactly one ordinary node, not a cusp or multiple node.  As an independent
mod-67 replay at `zeta11=9,(B,Z)=(37,56)`, the direction resultant, Hessian
determinant, and infinity obstruction are respectively `66,15,17`; exhaustive
enumeration finds the single affine singular point `(X,t)=(53,46)` and none
at infinity.

## Discovery artifacts

```text
t3_disc_build.py                                b99d27a08f9aca24d0b8ca184d2118427fc889e1f9ab6b198515313550c8aeae
t3_disc_delta_cub_qzeta11.json.gz               88ec8a6449117463debc54eb51e03dbd79e6c391e815f021fb19dd81f28ff014
t3_disc_summary.json                            5e406a3b6d173d77423b99b25930e2faae69f572082f98a549ce47ba2769a540
t3_disc_factor_singular.py                      21a411f11ec115a595354c26de906985901b1ad65f7c91bc062427f895018819
t3_disc_factor_singular_result.json             09857f3ce54e24be02bb0e878f73eea8fb1ea7c5cf18f368a8851004f5e0e503
t3_disc_factor_qzeta11.log                      96713bf1de1b2e66b9dd841616ca31457f375db81c228541cc0c437f5f1425b3
t3_disc_factor_mod67.log                        2b2f84c15a41a2a69e7dea4df63f40dd182ce65c8dae852e64b58f15b3dad50e
t3_disc_plane_contact.py                        b757d2cfdf23ef34bd5a50613653b1f0647f7b7832f48dfa923e5add3be668e6
t3_disc_plane_contact_qzeta11.json.gz           87570b9cef31f09c3f6c29550b00744a25998c2acb8121f5c3653aca641c97aa
t3_disc_plane_summary.json                      d7452f45870b8ae032c8290ab80a4824cdca730be18f732ba59308817702d90b
t3_disc_plane_node.py                           f9ebf732bd0e54c0d8167a7c6647cd176d8d034a32220773a941f93b99d9e014
t3_disc_plane_node_payload.json.gz              ab09938b59c23f656dcc60e096f1b6d49a444b8fbde3e997464b70b0741b08dc
t3_disc_plane_node_summary.json                 765d6776a406b4e0f41b908d13764ed700ab73e0b195a7e003297a959bcac3c5
```

The compressed payload is 57,422 bytes (441,556 bytes uncompressed).  Its
canonical 719-term list has SHA-256
`8dc4c9bfda27b8b28148202dd9faa9487e4ac7ad4e02de89d69e2b2d5802becf`.

## Replay

```sh
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  goals_after_bd610a/scratch_t3/t3_disc_build.py \
  --factor-exact-seconds 10 --write

PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  goals_after_bd610a/scratch_t3/t3_disc_factor_singular.py --timeout 180

PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  goals_after_bd610a/scratch_t3/t3_disc_plane_contact.py

PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  goals_after_bd610a/scratch_t3/t3_disc_plane_node.py
```

Expected markers:

```text
T3_FIXED_FRAME_DISCRIMINANT_DISCOVERY_DONE
T3_DISC_FACTOR_SINGULAR_DRIVER_DONE
T3_DISC_PLANE_CONTACT_EXACT_2
T3_DISC_PLANE_GENERIC_ONE_ORDINARY_NODE
```

## Strict boundary

This supplies the authoritative fixed-frame polynomial, establishes generic
smoothness of the selected target divisor, and completes the generic contact
and nodal analysis for the single boundary plane `A=15,Y=12`.  It does not
factor the pullback of `Delta_cub` on an authoritative normalization globally,
classify special proper closed loci inside that plane, audit all other
height-one/conductor/infinity components, or prove T3.D exhaustiveness.
