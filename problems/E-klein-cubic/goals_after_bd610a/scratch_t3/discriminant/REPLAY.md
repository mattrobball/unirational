# Replay

Run from `goals_after_bd610a` with `/opt/homebrew/bin/python3` and Singular
4.4.1 available.

```sh
/opt/homebrew/bin/python3 scratch_t3/discriminant/produce_discriminant.py
/opt/homebrew/bin/python3 scratch_t3/discriminant/produce_boundary_contacts.py
/opt/homebrew/bin/python3 scratch_t3/discriminant/analyze_affine_plane.py
/opt/homebrew/bin/python3 scratch_t3/discriminant/check_plane_codim3.py
/opt/homebrew/bin/python3 scratch_t3/discriminant/check_plane_local_types.py
/opt/homebrew/bin/python3 scratch_t3/discriminant/check_conductor_delta.py
/opt/homebrew/bin/python3 scratch_t3/discriminant/projective_slice_audit.py --primes 1009
/opt/homebrew/bin/python3 scratch_t3/discriminant/verify.py
```

Expected final markers, in order, are

```text
T3_FIXED_FRAME_DISCRIMINANT_PRODUCED
T3_BOUNDARY_CONTACTS_PRODUCED
T3_AFFINE_PLANE_CONTACT_EXACT_2
T3_PLANE_CODIM3_CHECK_DONE
T3_BOUNDARY_PLANE_LOCAL_TYPES_DONE
T3_CONDUCTOR_DELTA_NONZERO_DONE
T3_PROJECTIVE_SLICE_AUDIT_DONE
T3_DISCRIMINANT_PACKET_VERIFIED
```

The projective-slice step is a deterministic good-reduction audit, not an
authoritative normalization computation.  The conductor step certifies only
the conditional RUR noncontainment stated in `REPORT.md`.
