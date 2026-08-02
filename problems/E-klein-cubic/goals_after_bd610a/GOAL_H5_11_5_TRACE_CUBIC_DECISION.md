# Goal H5 — decide the genuine `11:5` cyclic trace cubic

**Pinned state:** `bd610a032bb9561d2daeb91a2cb60c48c082ca2f`  
**Priority:** 2  
**Possible headline direction:** negative  
**Accepted bridge:** `BR-SUBGROUP-NEG`

## Mission

Decide whether the exact generic twist for

```text
H = C_11 semidirect C_5
```

has a rational point.  The authoritative post-pinned model is the genuine
cyclic trace cubic

```text
Phi(a) = Tr_{E/K}(c a^2 sigma(a)) = 0,
c = r_2^(-1),
E = C(r_0,...,r_4)/(r_0 r_1 r_2 r_3 r_4 - 1),
sigma(r_i)=r_{i+1},
K=E^<sigma> = C(U_1,U_2,U_3,U_4).
```

A proof that `Phi` is pointless over `K` closes the full Klein-cubic headline
negatively.  An exact `K`-point retires this subgroup obstruction and must be
fed back into the genuine-Schur valuation route, but is not itself a full
positive headline.

## Binding inputs and retired searches

Consume the exact field maps, Hilbert--90 comparison, cyclic basis, trace
formula, and independent verifier in

```text
problems/E-klein-cubic/goal_runs_after_35fa/H_11_5_TWIST/
```

The following are already known and must not be rerun as if exhaustive:

- homogeneous `11:5` landing covariants in degrees one through nine are empty;
- constant-coefficient two-Laurent ansatze at arbitrary exponents are empty;
- two-Kummer-basis ansatze with arbitrary coefficient ratio are empty;
- single-monomial coordinate patterns on the three-coordinate restrictions
  are empty;
- `c` has norm one but nontrivial exact order eleven modulo
  `d -> d^2 sigma(d)`.

These facts constrain a point but do not prove pointlessness.

## Work packages

### H5.0 — exact minimal field and model audit

Reconstruct independently:

1. the four-parameter presentation of `K` and the inverse birational map;
2. the degree-five cyclic extension `E/K` on an explicit open;
3. the matrix of `sigma` in the basis `1,r_0,...,r_0^4` or the installed
   authoritative basis;
4. all coefficients of `Phi` over `K`;
5. the birational maps to and from the installed Hilbert--90 twist;
6. smoothness of the generic cubic and every denominator/open condition.

Deliver one small canonical payload.  Do not expand through unrelated Schur
frames.

### H5.1 — constructive point search beyond the retired ansatze

Search for a point using structures not covered by the prior exclusions.
Run in the following order.

#### A. Three- and four-term cyclic supports

Let

```text
a = sum_j b_j m_j
```

with `m_j` Laurent monomials forming complete or nearly complete `sigma`-orbits.
Classify supports up to cyclic shift, common monomial multiplication, inversion,
and the exact `d^2 sigma(d)` gauge action.  For each minimal support:

- derive the exact coefficient equations;
- eliminate linear variables first;
- detect rational components, conic bundles, or genus-one fibres;
- reconstruct any point over `K` and verify it in the canonical trace model.

A bounded support search may produce a point but cannot certify pointlessness.

#### B. Trace-zero and norm-one parameterizations

Test substitutions built from additive Hilbert 90 and the norm-one torus, for
example

```text
a = b/sigma(b),
a = b-sigma(b),
a = u + v sigma(u) + w sigma^2(u),
```

only after deriving how `Phi` transforms.  Search for a factorization or a
fibration with rational generic fibre.  Every denominator must be checked on
the final point.

#### C. Projection from the degree-five closed point

The five `C_11` eigenpoints form an exact degree-five point.  Project from its
span or from Galois-stable secant data and compute the resulting residual map.
Determine whether the cubic is birational to a conic bundle, quadric bundle,
or lower-dimensional torsor whose class can be decided exactly.

### H5.2 — toric valuation and tropical pointlessness

In parallel with H5.1, search for a genuine anisotropic completion.

1. Construct a `C_5`-equivariant toric compactification of
   `r_0...r_4=1` and enumerate orbits of primitive boundary valuations.
2. Descend each orbit to a valuation of `K`; compute all extensions to `E`,
   ramification, residue fields, and the leading form of `c`.
3. For a hypothetical nonzero solution `a`, compute the minimum valuations of
   the five conjugate summands of `Phi(a)` and enumerate every possible
   tropical cancellation pattern.
4. For each surviving pattern, derive the exact residue equation.  Prove it
   anisotropic or continue to the next residue/graded layer.
5. If one completion is anisotropic, prove the implication

   ```text
   Phi(K)=empty
   ```

   with a complete valuation-theoretic argument and independent arithmetic
   replay.

Finite tropical enumeration without residue anisotropy is only a structural
exit.  A valuation on the split extension `E` is not enough unless it descends
to a valuation of `K` and treats every extension relevant to a `K`-point.

### H5.3 — audit the order-eleven coefficient class

The exact class of `c` has order eleven modulo `d -> d^2 sigma(d)`.  Determine
whether this class controls rational points of the trace cubic.

Acceptable outcomes are:

- a proved obstruction theorem, instantiated here, implying pointlessness;
- an exact counterexample showing that the class can be nontrivial while the
  trace cubic is soluble;
- a reduction to a named cohomology or norm-torus torsor with computable local
  invariants;
- a proof that the class is only a coordinate-normalization invariant and has
  no point obstruction.

Do not promote the order computation itself.

### H5.4 — exact binary decision and bridge

#### Pointless branch

Provide a theorem and verifier proving `X_H(K)=empty` for the genuine generic
`H`-twist.  Then write `BRIDGE_SUBGROUP_NEG.md` checking:

- the installed twist is the generic/versal `H`-twist;
- the model is birational on a nonempty exact open;
- the obstruction survives passage between projective models;
- restriction of a hypothetical `G`-unirational map would make the generic
  `H`-twist soluble.

This authorizes `H5-POINTLESS-HEADLINE-NEGATIVE`.

#### Point branch

Give exact nonzero coordinates over `K`, verify `Phi=0`, and transport them to
the authoritative Klein equation.  Record the effect on the valuation route:
a decomposition-group obstruction can no longer stop at `11:5`.

## Exits

```text
H5-POINTLESS-HEADLINE-NEGATIVE
H5-RATIONAL-POINT
H5-VALUATION-REDUCTION-PASS
H5-COEFFICIENT-CLASS-REFUTED
H5-UNDECIDED
H5-CANONICAL-INPUT-FAIL
```

## Output contract

Write under

```text
problems/E-klein-cubic/goal_runs_after_bd610a/H5_TRACE_CUBIC/
```

Provide at least:

```text
INPUT_MANIFEST.json
FIELD_AND_MODEL.md
TRACE_CUBIC.json
CONSTRUCTIVE_SEARCH.md
VALUATION_LEDGER.md
COEFFICIENT_CLASS.md
POINT.md or POINTLESSNESS.md
BRIDGE_SUBGROUP_NEG.md when applicable
produce.py
verify.py
SEAL.json
STATUS.md
```

The independent verifier must reconstruct the field action and trace form and
must directly check the final point or the finite arithmetic data used by the
pointlessness theorem.