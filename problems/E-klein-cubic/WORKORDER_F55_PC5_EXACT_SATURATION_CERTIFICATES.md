# Work order F55-PC5 — exact saturation certificates for exceptional cores

**Runner:** local exact commutative-algebra agent  
**Required inputs:** one PC2 support packet labeled `MULTINOMIAL-EXCEPTION` by PC3/PC4  
**Scope:** exact torus decision for that finite support  
**Headline:** this packet can exit either finite-support `NO` or global `F55-YES`

## Mission

For the smallest exceptional finite support `S`, decide exactly whether

```text
I_S : (product A_s)^infinity
```

is the unit ideal.  Retain the smallest possible certificate:

- negative support exit: one sparse polynomial identity placing a monomial in
  `I_S`;
- positive support exit: one exact torus point, verified by direct Laurent
  expansion.

Do not retain a large Gröbner basis as the final mathematical artifact unless
it is needed to verify one of those two objects.

## Authoritative ideal

Consume `rows.json` from PC2 without recompiling it inside the primary CAS
script.  Let

```text
P = Q[A_0,...,A_(n-1)]
I = ideal(F_gamma)
m = product_i A_i.
```

The torus intersection is represented by the Rabinowitsch ideal

```text
J = I + (1 - t*m) in Q[A_0,...,A_(n-1),t].
```

Then:

```text
J=(1)     <=> I:m^infinity=(1) <=> no exact-support trace zero;
J proper  <=> an algebraic torus coefficient point exists.
```

A proper `J` is potentially a positive solution of the authoritative generic
trace cubic, not merely a bounded covariant survivor.

## Decision ladder — run in this order

### PC5.1 — torus simplification

Before any Gröbner basis:

1. remove the gcd monomial from each row, since every variable is a unit on the
   torus;
2. normalize primitive rational content and leading sign;
3. merge duplicate rows;
4. apply PC3 binomial substitutions where they strictly reduce the number of
   variables or terms;
5. identify linear equations in coefficient monomials.

Record every transformation and its inverse on the torus.  Do not divide by a
polynomial that is not a monomial unit.

### PC5.2 — sparse consequence search

Search for a monomial consequence before computing a full saturation:

```text
sum h_gamma*F_gamma = c*A^q,  c != 0.
```

Use increasing multiplier degree and sparse monomial support.  This is a
linear-algebra problem once a multiplier monomial basis is fixed.

Required progression:

```text
multiplier degree 0,1,2,3;
then increase only if the matrix size report is below the resource gate.
```

If found, divide by `c` and output the exact identity.  Any monomial `A^q` is
sufficient because it is invertible on the coefficient torus; it need not be a
power of the full product `m`.

### PC5.3 — exact Rabinowitsch decision

If the sparse consequence search fails, compute an exact Gröbner basis of `J`
using, in preferred order:

```text
Singular/FLINT modular reconstruction with rational verification;
msolve only for a zero-dimensional terminal system;
Macaulay2 as an independent verifier or representation extractor.
```

Use a block/elimination order only when required.  Report the term order and
variable order exactly.

Modular primes may select pivots and leading monomials.  The final verdict must
be reconstructed over `Q` and verified there.

### PC5.4N — negative support exit

If `J=(1)`, extract a representation of `1` in the Rabinowitsch ideal and
eliminate `t` to obtain, preferably,

```text
A^q = sum h_gamma*F_gamma.
```

If the first extraction yields only

```text
m^N = sum h_gamma*F_gamma,
```

attempt one pass of sparse reduction to lower `N` or shrink the multiplier
support.  Stop after the first independently verified exact identity; global
minimality is not required.

Write:

```text
certificate.json
certificate.txt
verify_certificate.py
```

The independent verifier must rebuild the `F_gamma` by the PC2 direct-expansion
path and compare the two sides coefficient-by-coefficient over `Q`.

Exit label:

```text
PC5-SUPPORT-NO
```

### PC5.4P — positive support exit

If `J` is proper, stop the negative program immediately.  Produce an exact
coefficient point with every `A_i != 0`.

Preferred extraction:

1. if zero-dimensional, output an exact rational univariate representation;
2. if positive-dimensional, intersect with deterministic rational affine
   hyperplanes that avoid the coordinate boundary and reduce to a nonempty
   zero-dimensional slice;
3. record the proof that the slicing ideal remains proper;
4. output one algebraic point in a specified number field.

Then form

```text
a = sum_i A_i*chi^(s_i)
```

and verify literally in the Laurent group algebra over that number field that

```text
Phi(a)=0;
a != 0.
```

This is an explicit `K`-point of the generic F55 twist and therefore a
candidate global positive resolution.  Open an immediate theorem-assembly
handoff rather than continuing bounded searches.

Exit label:

```text
PC5-TRACE-ZERO-FOUND
```

## Independent engines

The producer and verifier must use different paths:

```text
producer: Singular, msolve, or Macaulay2;
verifier: Python-flint/Nemo sparse identity evaluation and direct Laurent
          expansion.
```

A second Gröbner basis with the same script is not independent verification.

## Deliverables

Create one directory per support hash:

```text
problems/E-klein-cubic/certificates/f55_polar_circuit/pc5/<support-hash>/
  INPUT_MANIFEST.json
  simplified_rows.json
  producer.*
  RESULT.md
  certificate.json        # negative exit
  point.json              # positive exit
  verify.py
  run.log
  SEAL.json
```

The top-level PC5 directory also contains an index mapping support hashes to
result labels.

## Size report before GB

Before PC5.3, commit or print:

```text
number of variables;
number of rows;
term-count distribution;
maximum row degree;
Rabinowitsch variable count;
chosen order;
modular and rational memory estimates;
checkpoint strategy.
```

## Acceptance conditions

The verifier prints exactly one of:

```text
F55-PC5-SATURATION-NO-OK
F55-PC5-TRACE-ZERO-OK
```

It must reject:

- a finite-field-only unit ideal;
- a numerical coefficient point;
- a point with a zero support coefficient;
- division by a nonmonomial polynomial during torus simplification;
- a certificate checked against producer rows but not direct Laurent expansion;
- a proper-ideal claim without an exact nonempty torus certificate.

## Resource gate

Begin under:

```text
wall <= 30 minutes
RSS  <= 16 GB
```

A larger run requires a committed size report and restartable checkpoints.
Do not form dense Macaulay matrices when sparse modular reconstruction is
available.

## Theorem boundary

`PC5-SUPPORT-NO` kills exactly the supplied support, unless a separate coverage
theorem places every primitive zero in its symmetry/template class.

`PC5-TRACE-ZERO-FOUND`, once independently verified, is not merely scoped: it
constructs a nonzero Laurent solution to the authoritative trace equation and
must be assembled immediately into `F55-YES`.
