H5-UNDECIDED

# Goal H5 WAVE2 status — multi-support Laurent / projection

**Pinned state:** `bd610a032bb9561d2daeb91a2cb60c48c082ca2f`  
**Parent:** `goal_runs_after_bd610a/H5_11_5_TRACE_CUBIC/` (`H5-UNDECIDED`)  
**H4 input:** `goal_runs_after_35fa/H_11_5_TWIST/` (`H-11_5-NORM-MODEL-PASS`)  
**Headline:** OPEN (Problem E unchanged)

## Exit

```text
H5-UNDECIDED
```

Authorized nonterminal exit. This is **not** `H5-RATIONAL-POINT`,
`H5-POINTLESS-HEADLINE-NEGATIVE`, or any Problem E headline.

## What this wave added (beyond H5 wave 1)

1. **Structure for H5.1.A.** Proved computationally and recorded: the only
   Laurent monoms in `K` are constants (sigma-fixed exponents are diagonal;
   diagonal monoms are constant on the product-one torus). Therefore
   multi-support ansätze with coefficients in `K` must use genuine cyclic
   invariants, not nonconstant Laurent monoms.
2. **Multi-support screens with invariant-menu K-coefficients** (not only `C`):
   two-support, three-cyclic, four-cyclic, binary free-coeff specialized to
   menu, additive/multiplicative H90 with K-scaling, sparse `z` in the power
   basis, local cyclic polynomials, and named geometric formulas. All empty
   of K-identities in scope (`constructive_search.json`).
3. **Projection geometry (H5.1.C first layer).** Skip-one lines
   `span(e_i,e_{i+2})` lie on `F=sum x_i^2 x_{i+1}`; residual conic equation
   after projecting from `L_0` recorded; no linear residual section; Galois
   orbit of lines has size 5 so no single line is defined over `K`. No K-point
   constructed.
4. **Hard-review fix.** `verify.py` independently **re-runs every screen class
   in full** (matching tested counts), not a tiny subset of JSON booleans.

## Points found

```text
none over K
```

## Smallest remaining theorem

\[
 \exists\,0\ne a\in E:
 \operatorname{Tr}_{E/K}(r_2^{-1}a^2\sigma(a))=0\ ?
\]

## Next finite gate

Complete Galois descent of the residual conic bundle from the skip-one line
orbit (or a Brauer/Severi–Brauer obstruction for that descent); **or** exact
binary-cubic solubility for `a=1+s m` over the full field `K` (beyond menu
specialization); **or** one toric valuation with proved residue anisotropy.

## Replay

```sh
/opt/homebrew/bin/python3 -u goal_runs_after_bd610a/H5_WAVE2_LAURENT_PROJ/produce.py
/opt/homebrew/bin/python3 -u goal_runs_after_bd610a/H5_WAVE2_LAURENT_PROJ/seal.py
/opt/homebrew/bin/python3 -u goal_runs_after_bd610a/H5_WAVE2_LAURENT_PROJ/verify.py
```

Terminal marker:

```text
H5_WAVE2_INDEPENDENT_VERIFY_OK
```
