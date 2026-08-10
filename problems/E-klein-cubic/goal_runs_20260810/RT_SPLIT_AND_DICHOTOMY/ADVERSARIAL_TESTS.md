# Adversarial tests

## A. Restricted dichotomy

### A1. Does the proof choose a decomposition-theorem splitting?

No.  The full-support idempotent is the canonical unit--trace composite
`e_0=i_pi t_pi`; the exceptional idempotent is `1-e_0`.  The perverse
filtration and grouping by strict support are canonical.  No Chow projector
is used.

### A2. Could a full-support summand occur in another perverse degree?

No.  Over the generic locus where `pi` is an isomorphism,
`Rpi_*IC_Gamma` restricts to `IC_X`, concentrated in perverse degree zero.
Any full-support constituent must restrict nontrivially there, so the unique
one is `IC_X` in degree zero.

### A3. Does `q_*q^*=delta` by itself imply the norm identity?

No.  In general
\[
\delta-u_\varphi^\dagger u_\varphi
=t_qe_{\rm exc}i_q.
\]
The identity follows only in the CLEAN branch `e_exc i_q|_V=0`.  This is
consistent with the earlier warning in `INTERMEDIATE_JACOBIAN.md`.

### A4. Does a nonnorm degree contradict the known nonidentity selfmap?

No.  The tangent-residual construction records only `delta>=3`, not an exact
degree.  If its actual degree is not represented, the dichotomy puts it in the
CARRIER branch.  The sieve is conditional on CLEAN.

### A5. Is `[-5]` incorrectly counted as degree five?

No.  The elliptic multiplier is the scalar integer `-5`, whose field norm and
square are 25.  The fixed-carrier formula begins with `3*25=75`.

## B. Task 2 transfer

### B1. Is the Artin range one degree too large?

No.  Injection uses only vanishing of the term to the left,
`H_c^k(U,j^*M)=0` for `k<0`; hence `k<=-1`.  Substituting
`k=-1-j_0` gives exactly `j_0>=0`.  It says nothing about `j_0=-1`.

### B2. Is “finite normalization preserves IC” asserted?

No.  The statement is
`nu_*IC_Gamma=IC_D plus proper-support semisimple summands`.
Branch-separation summands are explicitly allowed.

### B3. Could CT1 still follow just from `S not subset X`?

No.  For `I=(x,y)(x,y,t)`, the normalized toric fan has no cone containing
both the ray over `S=(x,y)` and the strict-transform ray of `X=(t)`.  The
intervening ray over `S cap X` separates them.  The finite exact script checks
all cones.

## C. Degree accounting and point support

### C1. Is the live window `d>=22`?

No.  The later notebook precedence correction proves the unconditional
no-map statement only through `d=30`.  Degrees 31--33 have additional partial
screens but are not fully closed.  The conservative live range is `d>=31`.

### C2. Does Bézout kill a free surface orbit in that live window?

No.  The threshold is `ceil(sqrt(660))=26`; hence a free surface-component
orbit is already compatible with the crude bound at every live degree.

### C3. Do component degree bounds count arbitrary strict-support strata?

No.  A decomposition-theorem support can lie inside a larger base component.
The tables apply to actual irreducible base components and residual isolated
points only.  This prevents a false claim of support-escape closure.

### C4. Is point support ordinary `H^3` of the fiber without hypotheses?

No.  The unconditional object is
`H^{-1}(Y_x,IC_Y)`, pure of weight three.  It becomes ordinary `H^3(Y_x)` only
when `Y` is smooth near the fiber.

### C5. Is the fiber-to-target map finite?

No.  Properness gives only surjectivity onto its image `Z_x`.

## D. The `S subset X` local model

### D1. Does a unit cross-difference really give `(F,h^m)`?

Yes.  Cross differences give `F`; then the unit `a_0` gives `h^m`.  The
reverse containment is immediate.

### D2. Is the normalized second chart actually normal?

Yes.  `K[[F,h,w]]/(Fw-h^m)` is the two-dimensional affine toric
`A_{m-1}` singularity and is normal.  The cone determinant is `m`, as checked
exactly.

### D3. Does the vertical strict-support block have nonzero `psi_h`?

No.  Once isolated as a module supported on `h=0`, its restriction to
`h!=0` is zero and so is its usual nearby cycle.  The relevant map is gluing
inside the total direct-image object; in the unit-minor branch its
cohomological realization is Gysin.

### D4. Does geometric incidence force nonzero Hodge transfer?

No.  Even though `D cap E` is nonempty in the rank-two chart, the selected
class transfers exactly when its Gysin image is nonzero.  No local equation
forces that nonvanishing.

### D5. Do the weak `V4` determinants imply Rees-divisor survival?

No.  The weak line and conic divisors have nonzero generic determinants but
joint target residue transcendence degree one, so both contract.  The exact
`(v,w)` model survives because its joint residue and normalized source carrier
are both genuine.

## E. Held work

No fixed-carrier/type-I/type-II enumeration is performed.  The future target
is exclusion of actual landing data—source/target degree, monodromy, base
multiplicity, conductor correction, and compatibility across the 55
configurations—not the false blanket vanishing
`Hom_H(V,H^1(C))=0`.
