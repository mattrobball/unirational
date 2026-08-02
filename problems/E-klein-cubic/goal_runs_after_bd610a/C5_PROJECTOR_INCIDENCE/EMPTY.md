# Emptiness certificate for the prescribed system

The system literally written in Goal C5 is empty in characteristic zero.
The unit-ideal identity is given in `PROJECTOR_INCIDENCE.md` and replayed by
`verify.py` in a generic `6 x 6` splitting matrix.

This file is intentionally not named as an emptiness theorem for
`F_{14,T}`.  The genuine Fano section is geometrically nonempty and its
`K_proj`-point problem remains open.  The false system became empty because a
self-adjoint projector describes a nondegenerate summand whereas the first
Fano form requires that summand to be isotropic.

Authorized packet exit:

```text
C5-UNDECIDED
```

Failure subtype:

```text
C5-CONVENTION-INCONSISTENCY
```

The exit `C5-FULL-FANO-SCHEME-EMPTY-SCOPED` is not asserted.
