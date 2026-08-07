# Work order F55-PC2 — exact trace-support compiler

**Runner:** local exact-CAS agent  
**Parent proof:** `F55_POLAR_CIRCUIT_PROOF_REDUCTION_20260808.md`, §3  
**Scope:** one authoritative compiler, shared by all later checks  
**Headline:** Problem E remains `OPEN`

## Mission

Implement and seal the smallest exact compiler for finite Laurent supports of

\[
\Phi(a)=\sum_{i=0}^4\sigma^i\!\left(\chi^{-e_2}a^2\sigma(a)\right).
\]

The output is a sparse list of integer coefficient rows.  There are no
projective twists and no cyclotomic coefficients in this formulation.  Every
later polar, holonomy, and saturation job must consume this compiler rather
than maintain a separate expansion.

## Input format

A support file contains:

```json
{
  "lattice": "Z5/diag",
  "sigma": "e_i -> e_(i+1)",
  "support": [[m00,m01,m02,m03,m04], ...]
}
```

Each five-vector is interpreted modulo the diagonal.  Canonicalize it by
subtracting the fifth coordinate, producing a four-vector.  Reject duplicate
canonical exponents.

Coefficient variables are named by canonical support index, not by a monomial
string supplied by the caller.

## Accepted formula

For `i in Z/5`, squared-slot indices `p,q` and shifted-slot index `r`, define

```text
T_i(p,q;r) = sigma^i(p + q + sigma(r) - e2).
mu(p,q) = 1 if p=q, else 2.
```

For each output exponent `gamma`, the exact row is

```text
F_gamma = sum mu(p,q) * A_p*A_q*A_r
```

over all `i`, `p<=q`, and `r` with `T_i(p,q;r)=gamma`, after identical
commutative coefficient monomials are combined.

## Tasks

### PC2.1 — primary compiler

Write `compile_support.py` producing:

```text
support.canonical.json
rows.json
rows.txt
```

`rows.json` must encode each row as a sorted list

```json
{
  "output_exponent": [g0,g1,g2,g3],
  "terms": [
    {"coefficient": 2, "coefficient_monomial": [[index,power], ...]},
    ...
  ]
}
```

with positive integer coefficients and no duplicate coefficient monomials.
Rows and terms must be sorted deterministically.

### PC2.2 — independent direct-expansion verifier

Implement a second expansion path that does **not** call the slot compiler:

1. construct the sparse Laurent polynomial `a` with formal commutative
   coefficient-monomial keys;
2. multiply `a*a*sigma(a)` by `chi^(-e2)`;
3. apply all five powers of `sigma`;
4. add and collect Laurent exponents.

Compare its complete dictionary with `rows.json` exactly.

The producer and verifier may share elementary lattice normalization but must
not share the row-construction loop.

### PC2.3 — coefficient invariants

Verify for every compiled support:

```text
all coefficients are positive integers;
total ordered contribution count = 5*|S|^3;
commutativized weighted contribution count agrees with that total;
all output exponents are canonical;
no zero row is retained.
```

The second equality means summing each commutative term coefficient before
combining equal output rows.

### PC2.4 — regression supports

Include exact regressions for:

1. every one- and two-point support in a small box `[-1,1]^4`;
2. the degree-7 support used by
   `director_probes_20260808/f55_phase_holonomy_d7.py`, translated into the
   trace-support interface where applicable;
3. at least ten random supports of sizes `3,4,5,8` in `[-3,3]^4`.

The degree-7 projective-covariant packet is a comparison regression only; do
not force a false term-by-term identification between the covariant and trace
models.

### PC2.5 — saturation export

Provide a deterministic exporter to Singular and Macaulay2 containing only:

```text
Q coefficient field;
variables A_0,...,A_(n-1);
row generators F_gamma;
monomial m_S = product A_i.
```

Do not compute a Gröbner basis in this work order.

## Deliverables

Create:

```text
problems/E-klein-cubic/certificates/f55_polar_circuit/pc2/
  compile_support.py
  direct_expand.py
  verify.py
  regressions/
  schema.json
  README.md
  SEAL.json
```

The README must give one command for compiling an arbitrary support and one
command for verifying it.

## Acceptance conditions

The independent verifier must print exactly:

```text
F55-PC2-TRACE-COMPILER-OK
```

It must fail if:

- ordered squared-slot terms are not commutativized;
- the multiplicity `2` for distinct squared-slot indices is lost;
- identical coefficient monomials arising from different slots are not
  combined;
- any fifth-root phase or projective twist appears in the authoritative trace
  output;
- only random evaluation, rather than dictionary equality, is used.

## Resource gate

For support size `n`, the reference implementation is allowed `O(5 n^3)`
time and sparse output memory.  Regression sizes must satisfy:

```text
wall < 60 seconds
RSS  < 1 GB
```

## Theorem boundary

Successful completion certifies the finite support ideal input.  It does not
perform the torus-saturation decision and does not establish a uniform support
bound.
