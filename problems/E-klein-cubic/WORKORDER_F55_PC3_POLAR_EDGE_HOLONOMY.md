# Work order F55-PC3 — polar determinant and binomial holonomy

**Runner:** local exact-CAS agent  
**Parents:**

```text
F55_POLAR_CIRCUIT_PROOF_REDUCTION_20260808.md, §§4--5
certificates/f55_polar_circuit/pc2/   (required input)
```

**Scope:** complete exact decision for the two cheapest obstruction classes  
**Headline:** Problem E remains `OPEN`

## Mission

Given the exact integer rows of one finite trace support:

1. find every clean polar pair without a four-slot brute-force search;
2. emit a two-row monomial certificate whenever its polar determinant is
   nonzero;
3. otherwise find and test every integral holonomy relation in the binomial
   subsystem by Smith/Hermite normal form;
4. pass only genuine multinomial exceptions to PC4/PC5.

No Gröbner basis is allowed in this work order.

## Accepted polar classification

Use the slot map from PC2.  Every polar pair of the pattern

```text
A_u^2*A_v  <->  A_u*A_w^2
A_u*A_v*A_z <-> A_z*A_w^2
```

arises, after matching cyclic slots, from the single affine relation

```text
2*w = sigma(u) + sigma^2(v) + e2 - sigma(e2).
```

The paired cyclic slots differ by exactly one.  This theorem is proved in the
parent note and must be used to reduce candidate generation.

A pair is **clean** only when the two selected output rows have exactly the two
displayed active coefficient monomials.  Read their compiled integer
coefficients as

```text
f = alpha*A_u^2*A_v + beta*A_u*A_w^2
g = alpha_prime*A_u*A_v*A_z + beta_prime*A_z*A_w^2.
```

The obstruction determinant is

```text
Delta = alpha*beta_prime - alpha_prime*beta.
```

If `Delta != 0`, retain the exact identity

```text
alpha*A_u*g - alpha_prime*A_z*f
    = Delta*A_u*A_z*A_w^2.
```

## Tasks

### PC3.1 — polar-edge index

For every ordered pair `(u,v)` in the support:

1. compute the right side of the affine relation;
2. test divisibility by `2` in the free lattice `M`;
3. if divisible, obtain the unique candidate `w`;
4. continue only if `w` lies in the support;
5. enumerate `z in S - {u}` and locate the two output rows through the PC2
   occurrence index.

The producer must report:

```text
number of ordered (u,v) pairs;
number passing parity;
number with w in S;
number of candidate z;
number of clean row pairs;
number with Delta != 0.
```

Do not loop over arbitrary `(u,v,w,z,i,j)` tuples.

### PC3.2 — polar certificates

For each clean pair with `Delta != 0`, write a standalone JSON certificate:

```json
{
  "support_hash": "...",
  "indices": {"u":0,"v":1,"w":2,"z":3},
  "row_outputs": [[...],[...]],
  "coefficients": [1,1,2,1],
  "delta": -1,
  "identity": {...}
}
```

The independent verifier must fetch the two rows from `rows.json`, rebuild both
sides as sparse polynomials, and compare them exactly.

One certificate is enough to kill a support.  Stop polar enumeration after the
lexicographically first verified obstruction unless `--census` is requested.

### PC3.3 — extract the binomial subsystem

If no polar determinant kills the support, collect every row containing exactly
two coefficient monomials:

```text
alpha_e*A^a_e + beta_e*A^b_e.
```

Normalize by:

```text
delta_e = a_e-b_e in Z^S;
rho_e = -beta_e/alpha_e in Q*;
primitive sign convention: first nonzero entry of delta_e is positive.
```

When the sign is reversed, replace `rho_e` by its inverse.  Merge duplicate
`delta_e`; if the same exponent difference receives inconsistent ratios, emit
that two-row contradiction immediately.

### PC3.4 — complete holonomy test

Form the integer matrix whose rows are the distinct `delta_e`.  Compute an
exact basis of

```text
ker_Z(D^T).
```

For each basis vector `n`, evaluate

```text
rho(n) = product_e rho_e^(n_e) in Q*.
```

If a basis product is not one, output the corresponding cycle.  If all basis
products are one, state that the entire relation lattice passes: checking a
basis is sufficient because `rho` is multiplicative.

For smaller certificates, apply LLL only **after** an exact kernel basis is
known, and verify any shortened relation against the original integer matrix.
LLL output is optional and never authoritative.

### PC3.5 — complete-binomial positive control

If every nonzero row of the support is binomial and all holonomy products pass,
construct one torus solution over an explicit radical extension using the SNF
coordinates.  Verify all rows there symbolically.  This is a positive finite-
support control, not a rational point over `K` and not an F55 headline result.

## Deliverables

Create:

```text
problems/E-klein-cubic/certificates/f55_polar_circuit/pc3/
  polar_index.py
  holonomy.py
  verify.py
  certificates/
  census.json
  README.md
  SEAL.json
```

Accepted result labels per support:

```text
POLAR-DETERMINANT
BINOMIAL-HOLONOMY
BINOMIAL-COMPATIBLE
MULTINOMIAL-EXCEPTION
```

## Regression

Reproduce the degree-7 clean diamond from
`director_probes_20260808/f55_phase_holonomy_d7.py` at the level of its
coefficient rows.  The trace compiler and the covariant compiler are distinct;
therefore this regression checks the polar identity engine, not a claimed
identity of their support spaces.

Also include synthetic controls:

1. a compatible binomial cycle;
2. an incompatible rational holonomy cycle;
3. duplicate exponent differences with inconsistent ratios;
4. a clean polar pair with non-atomic integer multiplicities;
5. a polluted polar pair that must not be called clean.

## Acceptance conditions

The verifier must print exactly:

```text
F55-PC3-POLAR-HOLONOMY-OK
```

It must reject:

- a polar candidate not satisfying the affine relation;
- a row with hidden additional monomials;
- a determinant computed from assumed rather than compiled coefficients;
- a rational-kernel basis in place of the integral kernel;
- numerical logarithms for return products;
- a claim that holonomy compatibility of a proper binomial subsystem solves
  remaining multinomial rows.

## Resource gate

For support size `n`, polar candidate generation is `O(n^3)` after the affine
index, and the holonomy matrix is sparse.  Reference bounds:

```text
wall < 2 minutes for n <= 50
RSS  < 2 GB
```

## Theorem boundary

A failed polar determinant or failed holonomy cycle is a complete exact
negative certificate for that finite support.  A `MULTINOMIAL-EXCEPTION` is
not evidence for a point; it is only the input to PC4/PC5.
