# Goal COV.2 — full plane-order-one equalizers in degrees 31 and 35

**Pinned state:** `35fa8f59b6a1423cc89300aeaceefe91552be5ba`  
**Priority:** 4  
**Possible headline direction:** positive  
**Shared degree-25 dependency:** Goal P25.2

## Mission

Complete the part of the structured positive search that neither August COV packet reached: construct the full characteristic-zero global `m=1` coefficient modules in degrees 31 and 35, quotient nonprimitive directions, and decide their complete nonlinear landing schemes.

The higher-plane-order families selected to represent `e=1` and `e=5` are now exactly zero. Therefore every surviving degree-31 or degree-35 covariant has `m=1`, with large residual degree. Do not continue searching the dead `(31,5,1)` or `(35,5,5)` branches.

## Binding facts

- Complete self-covariant dimensions are 410 and 637.
- At good fibres, value restriction leaves dimensions 198 and 361.
- The selected higher-order global modules are zero after the first normal coefficients.
- Named composition/cross-gradient/mixed ansätze are empty.
- The full triple-line, point-link, `C3`, marked-elliptic, and primitive equalizers for `m=1` are not installed.

## Work packages

### COV2.0 — canonical characteristic-zero bases

For each degree, reconstruct a fixed integral/cyclotomic basis of the full self-covariant space and a fixed basis of the `m=1` plane-restriction kernel. Do not rely on fibrewise RREF bases that change with the prime.

Required checks:

- exact Reynolds circuits;
- Molien dimension equality;
- independence at two unused good primes;
- explicit integral lattice/open for reduction;
- hashes tying every later matrix to this basis.

### COV2.1 — complete global linear equalizer

Impose, in the correct order:

1. all 55 symbolic plus-plane restrictions at order one;
2. the 55 `V4` triple-line equalizers;
3. residual multiple-point kernels;
4. `D12` source minus-line restrictions;
5. `C3` lines and `C6` endpoints;
6. `A4`, `D10`, and `D12` point links;
7. marked type-I/type-II elliptic compatibility;
8. finite irrelevant-torsion corrections where literal graded pieces differ from sheaf sections.

Produce one global coefficient vector space; no local patching is allowed. Reconstruct the characteristic-zero equalizer or prove a good-reduction rank theorem with a fixed integral matrix and a nonzero maximal minor.

### COV2.2 — primitive quotient

Compute and remove:

- scalar invariant multiples of lower-degree covariants;
- compositions with the primitive quartic endomorphism;
- all known lower-degree endomorphism/composition images;
- common scalar factors that do not change the projective map.

Record the exact primitive quotient and prove that the quotient operation preserves every global restriction.

### COV2.3 — nonlinear landing ideal

Write every coefficient of

\[
F(p)=0
\]

on the primitive quotient. Decompose by invariant weight, normal order, and target/source character blocks. Apply linear, bilinear, and determinantal elimination before projective saturation.

A named-ansatz emptiness theorem does not decide this ideal. A modular candidate must be reconstructed exactly and checked in the original equation.

### COV2.4 — candidate certification

For a survivor:

- verify exact `G`-equivariance;
- verify all coefficients of `F(p)` vanish;
- prove primitivity and absence of a common scalar factor;
- compute a nonzero generic projective Jacobian rank-four minor;
- invoke `BR-COV-POS`.

If a selected full degree is empty, record only a scoped finite-degree exclusion.

## Exits

```text
COV31-COVARIANT-HEADLINE-POSITIVE
COV35-COVARIANT-HEADLINE-POSITIVE
COV31-FULL-DEGREE-EMPTY-SCOPED
COV35-FULL-DEGREE-EMPTY-SCOPED
COV-M1-EQUALIZER-PASS
COV-UNDECIDED
```

Do not use `COV-STRUCTURED-DEGREES-EMPTY-SCOPED` unless the complete `m=1` degree has actually been eliminated.

## Output contract

Write under

```text
problems/E-klein-cubic/goal_runs_after_35fa/COV_M1_DEG31_35/
```

Provide fixed bases, all equalizer matrices, primitive quotient payloads, landing ideals, candidate/emptiness certificates, independent verifiers, and `SEAL.json`.