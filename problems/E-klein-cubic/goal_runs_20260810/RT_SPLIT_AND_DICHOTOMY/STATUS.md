# RT split and restricted dichotomy — status

Problem E remains **OPEN**.

## Exit ledger

```text
RESTRICTED-DICHOTOMY-PROVED
CARRIER-INTRINSIC-RESTRICTED-AHS
CLEAN-CORRECTION-VANISHES
CLEAN-CM-NORM-EQUATION

CLEAN-CASE-TRANSFER-UNDECIDED
SUPPORT-ESCAPE-UNDECIDED
SXX-LOCAL-REES-UNDECIDED
```

## Current theorem boundary

Task 1 is proved at the Hodge-module level.  The birational unit--trace maps
for `pi:Gamma->X` canonically split the unique full-support `IC_X` summand from
the proper-support complement, without a Chow projector.  The actual class
`q_Gamma^*V` therefore has the intrinsic CARRIER/CLEAN dichotomy.  In the
CLEAN branch the exceptional correction vanishes and
`u_phi^dagger u_phi=delta` on `V`.

The integral `G`-Hodge commutant is the maximal order
`Z[(1+sqrt(-11))/2]`; hence a CLEAN degree is represented by
`x^2+xy+3y^2`.  The mandatory comparison with every degree datum in
`FULL_G_SELFMAP_CLASSIFICATION` passes.  In particular degree two is not a
norm, degree three and degree five are norms, and the elliptic multiplier
`[-5]` has scalar norm `25`, not `5`.

Tasks 2--4 remain under active audit.  No fixed-carrier/type-I/type-II
enumeration is resumed.
