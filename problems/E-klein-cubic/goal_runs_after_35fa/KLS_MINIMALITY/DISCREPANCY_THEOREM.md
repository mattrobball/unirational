# Discrepancy/conductor decision

## Theorem A — literal landing maps have trivial conductor data

Let `q` be a primitive homogeneous Klein-landing tuple of generic
differential rank four.  Then:

```text
projective image([q]) = X,
h_X := gcd_i (partial_i f3)(q) = 1,
X^nu = X,
C_X = 0.
```

### Proof

The projective image of `[q]` has dimension three and is an irreducible
closed subvariety of the irreducible threefold `X`; hence it is `X`.

Suppose a prime polynomial `g` divided all five entries
`(partial_i f3)(q)`.  Primitivity of `q` means that not all `q_i` vanish at
the generic point of `V(g)`, so `[q]` defines a point of `P(W)` over that
function field.  All five partial derivatives of `f3` vanish at this point.
Euler's identity also gives `f3=0`; it would therefore be a geometric
singular point of the Klein cubic.  The Klein cubic is smooth, a fact
independently recomputed by the verifier on the five standard projective
charts.  This contradiction proves `h_X=1`.

Since `X` is smooth it is normal, its normalization is the identity, and the
normalization conductor divisor is zero.

## Corollary — the literal finite configuration list is vacuous

Every literal landing representative has the single conductor configuration

```text
LANDING_SMOOTH_H1:
  h=1, conductor=[], exceptional_conductor_centers=[].
```

This list is finite and exhaustive, but it has no elimination content.
Deciding whether `LANDING_SMOOTH_H1` is empty is exactly deciding whether a
landing covariant exists in any degree.  None of the `P22`, degree-25, or
degree-28 conductor packets applies to it.

Therefore the requested chain

```text
minimal landing map
  => finite conductor list
  => exact elimination
```

reduces to

```text
landing map
  => h=1
  => decide the original landing problem.
```

It is not a finite reduction of the original problem.

## Theorem B — the broader KLS inputs do not supply the missing reduction

For a general rank-four KLS tuple with image `H=V(F)`, the accepted exact
identities are

```text
s = r+t+d(e-5)+4,
beta_D-a_D = epsilon_D A_E(H^nu,C)-1.
```

At a source divisor dominating a conductor prime of coefficient `c_T` and
normalization-differential order `mu_T`, they specialize to

```text
a_D    = epsilon_D(c_T+mu_T),
beta_D = (epsilon_D-1)+epsilon_D mu_T.
```

These identities classify a configuration once its support, multiplicities,
centers, and discrepancies are already known.  They do not bound those data.
Least-degree minimality contributes only the dual-Gauss inequality recorded
in `MINIMALITY.md`.

The exact generic countermodels establish three independent nonimplications:

1. primitive rank four + normal image + lc foliation does not force positive
   target discrepancy;
2. even a fixed plt nodal normalization pair does not bound the number or
   total degree of source divisors over one conductor branch;
3. `G`-equivariance + primitivity + tangency to all eleven `P22` quadrics
   does not force radiality or a `P22` multiple.

These models do not satisfy both Klein equivariance and minimality, so they
are not a `KLS2-COUNTEREXAMPLE`.  They prove that a KLS2.1 theorem must use a
new representation-specific consequence of minimality.  No such consequence
is present in KLS2.0, the exact invariant identities, or the current
foliation literature.

## No-finite-reduction theorem

From the definitions and accepted inputs specified in the KLS2 goal, there
is no nontrivial finite conductor reduction:

- literally, the conductor ledger is the uneliminated singleton `h=1`;
- broadly, finiteness requires two additional unproved assertions:

  ```text
  minimal discrepancy:
    A_E(H^nu,C) >= 1 at every exceptional gcd valuation;

  conductor support:
    bounded reduced degree/orbit support above conductor primes.
  ```

Assuming either assertion would assume the missing KLS2.1 content.  Starting
a finite CAS table without them would violate the goal's theorem-first gate.
This proves the route exit `KLS2-NO-FINITE-REDUCTION`; it does not prove that
no future representation-specific theorem can exist.

