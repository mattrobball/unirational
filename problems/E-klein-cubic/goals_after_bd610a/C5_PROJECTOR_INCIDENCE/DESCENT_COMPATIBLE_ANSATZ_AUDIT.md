# C5 descent-compatible ansatz audit

Date: 2026-08-01

## Verdict

This is a bounded negative audit, not a resolution of C5.  It supplies three exact finite-field exclusions for natural descent-compatible formulas, but it neither constructs nor rules out a `K_proj`-rational point of the corrected Pluecker incidence.

The strongest new finite-field statement is that a twelve-dimensional constant-coefficient Morita-word ansatz has full quadratic obstruction rank `78` over `F_23`.  Separately, every degree-17 Reynolds-basis coefficient support of size at most four is excluded by the installed `1597` landing equations.  Neither statement is an all-degree conclusion.

The machine-readable record is `descent_compatible_ansatz_audit.json`; `verify_descent_compatible_ansatz.py` independently reconstructs the accepted algebraic data and reruns the ranks without importing a search producer.

## Corrected equation and descent mechanism

Let `q` be the accepted alternating form, let

```text
sigma(g) = q^(-1) transpose(g) q,
```

and let `S_0=1,S_1,...,S_4` be the installed self-adjoint section endomorphisms.  Let `e_0` be the accepted rank-two auxiliary projector coming from the degree-12 decomposable covariant.  For a word-polynomial `g=g(S_1,...,S_4)`, the image of `g e_0` is automatically expressed in the accepted Morita model.  It is a common isotropic two-plane precisely when

```text
e_0 sigma(g) S_i g e_0 = 0       (i=0,...,4)
rank(g e_0) = 2.
```

These are the genuine bilinear isotropy equations.  They avoid the inconsistent literal self-adjoint-idempotent model, in which the `S_0=1` equation would force a self-adjoint idempotent to be zero.

## Short-word screen

All `341=1+4+16+64+256` words in the alphabet `{1,2,3,4}` of length at most four were reconstructed over `F_23`.  On seven regular fibres, the audit tested:

* every single word; and
* every `W+cW'` for distinct unordered words and every `c in F_23^*`.

There were no survivors among `341` single-word tests or among

```text
binomial(341,2) * 22 = 1,275,340
```

two-word scalar tests.  Each rejection is by an exact nonzero residual in the displayed equations (or, if those residuals vanished, by the rank condition).  The verifier recomputes all tests from the pinned upstream sources.

This excludes only the literal good-reduction formula class just described.  It does not exclude longer words, combinations with three or more short words, formulas with nonconstant `K_proj` coefficients, or formulas whose chosen model has bad reduction at `23`.

## Full constant twelve-word screen

Consider the first twelve words

```text
1,
S1,S2,S3,S4,
S1*S1,S1*S2,S1*S3,S1*S4,S2*S1,S2*S2,S2*S3.
```

At the primary fibre `(1,2,3,4,5)`, their matrices `W e_0` have vector-space rank `12`, the full Morita-module dimension at that fibre.  Write

```text
g(c) = sum(j=0..11) c_j W_j.
```

Expanding the five isotropy matrices in the `78=12*13/2` symmetric monomials `c_a c_b`, and successively adding the equations from sixteen regular fibres, gives cumulative ranks

```text
5, 10, 15, 20, 23, 28, 33, 38,
43, 48, 53, 58, 63, 68, 73, 78.
```

Thus the finite collection of identities spans all of `Sym^2(F_23^12)`: no nonzero constant vector `c` satisfies those identities.  This is a complete exclusion of this constant twelve-word coefficient ansatz over `F_23`, not an exclusion of a `K_proj`-rational coefficient vector `c(x)`.

## Degree-17 sparse support screen

The accepted degree-17 file records the complete `98`-dimensional homogeneous polynomial-covariant space and `1597` independent sampled Pluecker landing equations in `4851` quadratic coefficient monomials.  For a coefficient support `T` of size `k`, restrict the equation matrix to the `k(k+1)/2` monomials supported on `T`.  Full column rank forces the only supported solution to be zero.

The audit exhausts every support of sizes one through four:

| support size | supports checked | restricted columns | deficient supports |
|---:|---:|---:|---:|
| 1 | 98 | 1 | 0 |
| 2 | 4,753 | 3 | 0 |
| 3 | 152,096 | 6 | 0 |
| 4 | 3,612,280 | 10 | 0 |

The replay uses six deterministic `10`-row linear projections.  Full column rank of a projected matrix rigorously implies full column rank of the original restricted matrix.  Any support not certified by a projection is checked directly against the original `1597`-row matrix.  Randomness only chooses reproducible witnesses; it is not used as a probabilistic inference.

This result is basis-dependent, finite-prime, and finite-support.  It is not a verdict that the full degree-17 projective scheme is empty, and it says nothing by itself about higher degree.

## Why the smooth `p=23` seed does not reconstruct a generic section

The smooth modular seed is valuable: the Jacobian criterion gives formal or etale-local lifting near that split fibre.  It does not provide a rational section over the global function field `K_proj`.  A local branch at one closed fibre need not extend rationally across the base, and the computations above find no descent-compatible word formula that would supply such an extension.

Likewise, the known degree-55 orbit and degree-14 intersection zero-cycles have coprime degrees and therefore give index one, but index one is not a general rational-point theorem for this Fano threefold.  No accepted theorem in the packet upgrades that zero-cycle statement to a `K_proj`-point.  The V14/cubic-threefold birational description does not create such an upgrade.

## Exact scope and next attacks

Established here:

1. the short-word and two-word exclusions at `p=23` on the listed regular fibres;
2. the full constant twelve-word quadratic-rank exclusion at `p=23`; and
3. the degree-17 support-at-most-four exclusion at `p=23` in the installed basis.

Not established here:

1. existence or nonexistence of a `K_proj`-point;
2. exclusion of rational-function coefficients in the Morita words;
3. emptiness of the full degree-17 projective landing scheme; or
4. any all-degree obstruction.

The most direct remaining computational attacks are therefore to allow invariant rational-function coefficients in the twelve-word module, or to finish an exact projective-scheme computation for the full degree-17 landing ideal.  The modular smooth seed remains a useful local consistency check, not a substitute for either task.
