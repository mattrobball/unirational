# The maximal justified minimality theorem, and why it is insufficient

## The proved theorem

Assume a rank-four KLS `G`-self-covariant `q:W->W` of degree `d` exists and
choose one of minimal degree.  Let `H=V(F)`, and use the notation of
`INTERFACE_AUDIT.md`.  Then:

1. `h` is `G`-invariant, `f3` does not divide `h`, and `deg(h)<=4` implies
   `h=1`.
2. Every non-stable orbit of irreducible factors of `h` has at least eleven
   members.
3. The dual Gauss covariant `p=(grad F)(q)/h:W->W*` is primitive of rank
   four and degree `m=4d-4-r-t`.
4. The unique quadratic dual Klein polar sends `p` back to a primitive
   rank-four self-covariant of degree `2m`.  Therefore

   ```text
   d <= 2m,
   r+t <= floor((7d-8)/2).
   ```

5. If the KLS foliation is log canonical, its degree satisfies

   ```text
   r mod 11 in {1,3,4,5,9}.
   ```

This is the strongest accepted representation-specific conclusion currently
deduced from minimality.

## Why quartic precomposition is not a minimality argument

Let `C` be the primitive quartic equivariant endomorphism.  Exact
basepoint-freeness makes `[C]` finite.  For a primitive `q`, the preimage of
its codimension-at-least-two base locus under a finite morphism still has
codimension at least two.  Hence `q o C` remains primitive and has saturated
degree `4d`.  The chain rule preserves `det(Dq)=0`, and dominance of `C`
preserves the image and generic rank.

Thus

```text
d < 4d < 4^2 d < ...
```

is a family of larger solutions conditional on one solution.  Minimality
excludes smaller solutions only.  No conductor configuration can turn this
operation itself into a contradiction.  A separate theorem would have to
prove that a particular solution is a *pure quartic pullback* and then
descend it; the installed rank-1,024 module decomposition does not prove
that.

## Exact countermodels to generic substitutes

These countermodels do not satisfy the Klein symmetry plus minimality, so
they do not refute a genuinely representation-specific theorem.  They prove
that every listed extra bridge is necessary.

### Normal image and lc foliation do not imply positive discrepancy

For `e>=3`, let

```text
Q = sum(z_i^(e-1)),
B = sum(z_i^e),
Phi_e = (-B, z_1 Q, ..., z_4 Q).
```

Its coordinates are primitive, its generic rank is four, and its normal
rational image is

```text
F_e = y_0 sum(y_i^(e-1)) + sum(y_i^e) = 0.
```

The pulled-gradient gcd is `Q^(e-2)`, the kernel foliation is log canonical,
and the relevant exceptional log discrepancy is `A_E=5-e`.  At `e=5`, the
target is lc but not klt, `a_D=3`, `beta_D=2`, and one reduced factor
survives.  For `e>=6`, the defect is unbounded in the wrong direction.

### A fixed plt conductor pair does not bound pullback support

For the fixed nodal hypersurface

```text
v^2 = u^2(u+1)
```

with normalization `u=t^2-1`, `v=t(t^2-1)`, set

```text
t = 1 + product_{i=1}^N (x-lambda_i s).
```

For arbitrary `N`, the pullback of the same conductor branch splits into
`N` distinct source divisors.  The normalization pair is fixed and plt.
Therefore plt controls exceptional discrepancies but does not bound the
number or total degree of source divisors dominating the conductor itself.

### Tangency to `P22` is not rigidity

The repository constructs primitive `G`-equivariant logarithmic vector
fields tangent to all eleven `A5` quadrics in degrees at most 25 and 28.
They are not shown to be KLS Jacobian kernels, but they refute any theorem
using only equivariance, primitivity, and logarithmic tangency.

## The exact missing theorem

A finite classification would require both statements below for a minimal
KLS covariant:

1. **Minimal discrepancy lemma.** Every gcd valuation exceptional over a
   codimension-at-least-two center of `(H^nu,C)` has positive log
   discrepancy.  Cartier integrality would then give `A_E>=1` and full
   cancellation of repeated exceptional factors.
2. **Conductor-support lemma.** The reduced source support dominating
   conductor primes has a representation-specific finite degree/orbit bound,
   or is exactly a proved list such as the eleven `P22` quadrics.

Neither statement follows from the proved minimality inequality, foliation
lc, target-pair lc/plt, normality, invariant-ring finite generation, or
quartic precomposition.  No current primary-source theorem located in the
literature audit supplies either statement for a rank-four
relative-dimension-one polynomial map.

Accordingly there is no theorem from which `CONFIGURATIONS.json` could
honestly set `exhaustive=true`.  The correct goal exit is
`KLS-NO-THEOREM`.
