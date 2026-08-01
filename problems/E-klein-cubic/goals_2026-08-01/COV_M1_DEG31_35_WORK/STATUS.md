COV-UNDECIDED

# Status

The repository headline remains **OPEN**.  This run constructs the missing
literal characteristic-zero `m=1` modules and the complete landing equations,
but it does not decide their projective saturations and therefore does not
authorize either scoped full-degree emptiness exit or a positive headline.

## Exact results

- The full self-covariant bases have dimensions `410` and `637`.  Fixed
  Reynolds circuits have full rank at the unused split primes `419` and `463`.
- A fixed Hironaka set of dual Reynolds covariants produces fourfold-wedge
  circuits vanishing on every involution plus-plane.  Fixed sets of `198` and
  `361` such circuits are independent at both primes.  The full plane
  restriction ranks are `212` and `276`, so these are the complete
  characteristic-zero literal `K1` bases.
- All triple-line, point-link, source-line, `C3/C6`, and marked-elliptic
  equalizers are installed on the same global coefficient vector.  After the
  first plane restriction their defect maps are coefficientwise zero by
  transitivity of Taylor restriction.  The degree-35 compact special-fibre
  defect `362-361=1` is excluded by intersection with the literal global
  polynomial image; it is not promoted to characteristic zero.
- The fixed positive-invariant-multiple subspaces have dimensions `197` and
  `361`.  Thus the standard linear indecomposable-module quotient is exactly
  zero in degree 35 and has characteristic-zero dimension at most one in
  degree 31; both displayed fibres give dimension one in degree 31.
- This linear quotient is now refuted as a primitive-covariant quotient by
  exact module-specific witnesses.  In degrees 31 and 35, respectively, the
  sums of fixed positive-multiple directions `(0,9)` and `(0,18)` lie in
  `R_+K1` but have component gcd one.  A stored `F_419[u]` Bezout identity on
  a fixed projective line proves primitivity and, by good reduction, excludes
  a common factor in characteristic zero.
- The complete landing ideals are written in factored nodal coordinates.  In
  degrees 31 and 35 they have respectively `5349` cubics on `198` variables
  and `8555` cubics on `361` variables.  The nodal evaluation determinants are
  nonzero at both unused primes, so these are complete coefficient systems,
  not sampled necessary equations.
- A further exact landing pre-elimination comes from a representative `C3`
  eigenline.  Its reduced length-three Klein section makes every nonzero
  projectivized restriction constant; the setwise `C6` stabilizer selects the
  unique `C6`-fixed point.  This gives linear gate ranks `11` and `13`, hence
  special-fibre decision spaces of dimensions `187` and `348`.  The same
  ranks occur at split primes `463` and `727`.
- At `p=463` the complete `5349` and `8555` factored cubics are explicitly
  restricted to those two kernels.  The zero-restriction (based) strata have
  vector-space dimensions `177` and `336`; their complements are covered by
  `10` and `12` affine normalization charts from independent scalar-form
  coordinates.  These are exact decision circuits, not a saturation result.
- On the based branch, the first transverse Taylor coefficient gives further
  necessary linear landing gates.  Their cumulative ranks are `51` and `61`,
  leaving dimensions `147` and `300`; the complete factored equations are
  materialized on both kernels.  The remaining first-normal nonbased pieces
  have `17` and `11` normalization charts, while the second-based pieces have
  dimensions `130` and `289`.  Every rank agrees at `p=463` and `p=727`.
- On the second-based branch, the pure quadratic normal blocks reduce the
  fibres to `99` and `247` variables, with `7` and `24` nonbased charts.  If
  those scalars vanish, the mixed quadratic block reduces to `78` and `204`,
  with `13` and `20` nonbased charts.  Vanishing of the mixed scalar leaves
  true third-based dimensions `65` and `184`; the complete landing cubics are
  explicitly materialized there.  These ranks also agree at both primes.
- No one- or two-basis-direction survivor exists at `F_419`.  This is a
  discovery diagnostic only.

## Why no stronger exit is sound

The nonlinear equation does not descend to the linear module quotient.  The
sealed Bezout witnesses prove—not merely warn—that a sum of factorable
directions can have component gcd one even though its class in
`K1/(R_+ K1)` is zero.  Consequently the zero degree-35 module quotient
cannot be relabelled as `COV35-FULL-DEGREE-EMPTY-SCOPED`.

There is also a binding lower-degree dependency.  If `q` is a degree-25
landing covariant, then `f6*q` and `f10*q` are landing covariants in degrees
31 and 35 because `F(f*q)=f^3 F(q)`.  Goal P25.2 remains undecided.  Hence a
negative full-degree exit here would in particular settle an unresolved
subscheme of P25.2, which this run has not done.

The remaining exact cover consists of the original `10+12` C3-nonbased
charts, `17+11` first-normal charts, `7+24` pure second-normal charts, `13+20`
mixed second-normal charts, and the third-based projective strata of vector
dimensions `65` and `184`.  Each must be saturated away from the actual
scalar-factor and known composition incidence loci.  Until every branch is
decided, the only authorized exit is `COV-UNDECIDED`.
