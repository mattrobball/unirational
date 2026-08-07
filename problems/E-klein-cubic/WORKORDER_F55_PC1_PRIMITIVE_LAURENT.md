# Work order F55-PC1 — primitive Laurent reduction and lattice seal

**Runner:** local exact-CAS agent  
**Parent proof:** `F55_POLAR_CIRCUIT_PROOF_REDUCTION_20260808.md`, §§1--2  
**Scope:** tiny regression/seal only; no support search  
**Headline:** Problem E remains `OPEN`

## Mission

Seal the conventions and the two algebraic reductions that every later polar-
circuit job consumes:

1. the cyclic lattice has no nonzero fixed directions;
2. `2 + sigma` has cokernel of order 11 with the stated defect functional;
3. invariant denominator clearing is an exact symbolic identity;
4. primitive reduction removes invariant polynomial factors, not exponent
   translations.

All proofs are already in the parent note.  The runner must verify their exact
matrix and Laurent-polynomial interfaces and emit a small machine-readable
certificate.  Do not launch any degree search, Gröbner basis, or finite-field
experiment.

## Accepted mathematics — do not re-prove computationally

Let

```text
M = Z^5 / Z*(1,1,1,1,1)
sigma(e_i) = e_(i+1)
R = Q[M]
c = chi^(-e2)
Phi(a) = sum_i sigma^i(c*a^2*sigma(a)).
```

Accepted:

```text
M^(sigma^d) = 0 for d=1,2,3,4;
det(2+sigma on M) = Phi_5(-2) = 11;
N(Q)=prod_i sigma^i(Q) is invariant;
Phi(b*a)=b^3 Phi(a) for invariant b;
Newt(f*g)=Newt(f)+Newt(g).
```

## Exact coordinate frame

Use the quotient basis

```text
b0 = e0-e4, b1 = e1-e4, b2 = e2-e4, b3 = e3-e4.
```

Construct the integral `4 x 4` matrix `S` induced by `sigma`.  Every output
must state this matrix explicitly.  Do not import a matrix from an older
packet without rebuilding it from the quotient definition.

The mod-11 functional is represented in five-coordinate notation by

```text
lambda = (1,9,4,3,5).
```

It is well-defined because its coordinate sum is `0 mod 11`.

## Tasks

### PC1.1 — lattice checks

Rebuild `S` and verify exactly:

```text
S^5 = I;
ker_Z(S^d-I) = 0 for d=1,2,3,4;
SNF(2I+S) has product of diagonal entries 11;
det(2I+S) = 11.
```

The fixed-lattice test must be over `Z`, not only modulo a prime or over
floating point.

### PC1.2 — defect functional

Translate `lambda` to the quotient basis and verify

```text
lambda*(2I+S) = 0 mod 11;
lambda(e2-e4) != 0 mod 11.
```

Record the resulting nonzero residue.

### PC1.3 — denominator-clearing regression

Implement sparse Laurent polynomials as dictionaries `exponent -> rational
coefficient`.  On at least 100 deterministic random sparse pairs `(P,Q)` with
`Q != 0`, verify by literal expansion that

```text
A = P * sigma(Q) * sigma^2(Q) * sigma^3(Q) * sigma^4(Q)
    / Q
```

reduces to the Laurent polynomial

```text
P * sigma(Q) * sigma^2(Q) * sigma^3(Q) * sigma^4(Q) / Q
= P * product_{i=1}^4 sigma^i(Q),
```

and verify the polynomial identity

```text
Phi(N(Q)*P/Q) = N(Q)^3 * Phi(P/Q)
```

by clearing denominators on both sides.  The random tests are regression only;
the certificate must also include a symbolic derivation string identifying the
three occurrences of the invariant factor.

### PC1.4 — primitive-factor interface

Provide a function that, given a Laurent polynomial `a` and an explicitly
supplied invariant divisor `b`, checks:

```text
sigma(b)=b;
a=b*d in R;
Phi(a)=b^3*Phi(d);
width(a)=width(b)+width(d).
```

No general invariant-factorization algorithm is required.  This function is
an interface test for future claimed reductions.

## Deliverables

Create:

```text
problems/E-klein-cubic/certificates/f55_polar_circuit/pc1/
  produce.py
  verify.py
  lattice.json
  primitive_reduction.json
  README.md
  SEAL.json
```

`SEAL.json` must include SHA-256 hashes of every payload file and the exact
Python, FLINT/SymPy, or OSCAR version used.

## Acceptance conditions

The independent verifier must rebuild all matrices and Laurent identities from
first principles and print exactly:

```text
F55-PC1-PRIMITIVE-LAURENT-OK
```

It must reject any payload that:

- uses a five-dimensional matrix without quotienting the diagonal;
- reports only a modular rank for a lattice claim;
- treats multiplication by an invariant polynomial as a common exponent
  translation;
- claims pointlessness from the order-11 cokernel.

## Resource gate

```text
wall < 30 seconds
RSS  < 512 MB
```

Exceeding either bound indicates an incorrectly enlarged task.

## Theorem boundary

Successful completion seals only the shared input reduction.  It proves no
support obstruction and no F55 headline statement.
