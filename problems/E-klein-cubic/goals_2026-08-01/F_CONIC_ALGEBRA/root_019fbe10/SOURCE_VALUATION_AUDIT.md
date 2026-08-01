# Source-hyperplane and valuation audit

## Verdict

These continuations do not change the binding exit: F-UNDECIDED.

They produce useful exact reductions and rule out several tempting false
proofs, but they do not construct a point/conic or prove the full criterion
empty.

## Exact source-hyperplane fact

The hyperplane H given by x0 + x1 = 0 has trivial setwise stabilizer in the
exact projective PSL(2,11) representation.
verify_source_hyperplane_stabilizer.py reduces all 660 exact matrices at the
good split prime 331, verifies that they remain distinct, and finds
stabilizer size one. It also checks that H is not contained in either f3=0
or f5=0.

This implies that the generic point of H maps birationally to its image
divisor in the quotient. It does **not** determine the index of the
specialized plane cubic. That requires a divisor-class computation for the
fourfold incidence over H.

## Why the prospective Lefschetz proof is not sealed

The cleared pullback incidence over a source hyperplane is a (3,12)
hypersurface in P2 x P3. If it had only isolated singularities, local
factoriality plus Grothendieck-Lefschetz would force all generic-fibre divisor
degrees to be multiples of three.

The modular Jacobian computations do not supply that hypothesis:

- the coordinate witness x4=0 has positive-dimensional singular schemes on
  the y and w charts modulo 23;
- the sparse exact-stabilizer hyperplane has substantially larger Jacobian
  systems, and the attempted Groebner computations were stopped without a
  dimension certificate;
- the full-source chart computation was likewise stopped without a result.

An unfinished or positive-dimensional modular screen is not a Picard or
class-group theorem.

## Infinity-divisor audit

Parsing the exact primitive sextic gives the following useful Newton shapes.

### The divisor B=0

The B-adic valuations of the coefficients (c0,...,c6) are
(0,0,0,0,0,1,2). Thus two roots go to infinity and their total residue
degree is at most two. This looks compatible with an index-three
obstruction, but the four-form specialization on B=0 has modular projective
base points at both split primes 67 and 89. No characteristic-zero
basepoint-free or index-three theorem was obtained.

### The divisor A=15

After writing A=15+h, the exact coefficient valuations are
(0,0,0,0,0,0,1). The Newton polygon therefore has a rational length-one
infinity branch. Again, the specialized four-form system has modular base
points at 67 and 89, so the needed index-three residue theorem is absent.

### Nonlinear factors of c6

The shifted nonlinear factor used by build_infinity_quartic_probe.py has 18
homogeneous terms. Its modular Jacobian ideals have positive-dimensional
singular schemes on every projective chart tested. These computations are
discovery evidence only: they neither prove characteristic-zero singularity
nor compute the required normalization/class group.

## Exact remaining boundary

The smallest unconditional target remains the six cubic remainder equations
in twelve F-coefficients plus the projector open, exactly as recorded in
../CRITERION.md.

An alternative sufficient completion would be an exact class-group
certificate for a trivial-stabilizer source hyperplane showing that the
generic plane cubic over its function field has index three. No such
certificate is present.
