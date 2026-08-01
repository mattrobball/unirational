# Read-only input ledger

## Fixed-frame cubic

- `../../tmp/pfaffian_global_fixed_frame_hostile_audit/REPORT.md`
- `../../tmp/pfaffian_global_fixed_frame_hostile_audit/certificate.json`
- `../../certificates/fixed_frame_arithmetic/five_forms.json`

These install

```text
c = F0 + A*FA + B*FB + Y*FY + (Z - 11*A^2/18)*FZ
```

in `[X:v:w]`, with exact coefficients in `Q(zeta_11)`, and prove the generic
curve over `F=C(A,B,Y,Z)` has index three.

## Degree-six field

- `../../tmp/full_scaled_frame_degree_attack/sparse_bkk_certificate.json`
- `../../tmp/full_scaled_frame_degree_hostile_audit/REPORT.md`
- `../../tmp/pathF_existence/monogenic_system.json`
- `../../tmp/pathF_existence/line_eliminant_E_terms.json`

The exact generic presentation uses

```text
t=f5^3,  u=f8/f5,  v=f10*f5
```

and three sparse consequences.  Their determinant divided by `u` is a
degree-six equation for `u`; Cramer reconstruction gives the other two
coordinates after recording its denominator open.

## Criterion

- `../../tmp/sextic_conic_section_gate/REPORT.md`
- `../../certificates/fixed_frame_arithmetic/TERMINALITY_AUDIT.md`
- `../../certificates/fixed_frame_arithmetic/EXISTENCE_STATUS.md`

The criterion is used only at its proved boundary.  In particular, an
abstract `S6` discriminant/resolvent match is not an algebra isomorphism, and
`C(K_proj) != empty` is not by itself the final Klein-unirationality bridge.
