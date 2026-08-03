# H6.2 — constructive lanes

## Discipline

H5 constant-coefficient, bounded Laurent, pure monom, and random finite-fibre
screens are **not** re-run as exhaustive.  This residual uses the H6.1 torsor
structure and only short binding probes.  Expanded push probes live under
`phase_decision_push/` (multi-support Laurent with degeneracy filter, sparse
power-sum K-coefficients, cyclic rational partial sums, ratio-family stats).

## Lane A — rational curves / surfaces in H_tr

`H_tr ≅ P^3`.  Restrict the `mu_11`-torsor (Kummer class of
`psi_B(b c^{-1})`) to low-degree rational families.  A family on which the
class is an identical 11th power would yield a section.

- Residual constant-`z` probes: empty.
- Skip-one lines on the B-frame cubic: Gal-orbit of size 5; not defined over `K`
  (H5 wave-2 geometry bound).
- **Push:** two-support / three-support Laurent and sparse `z_j = a+bp1+cp2`
  screens — all empty after product-one degeneracy filter.
- **No** family with identically trivial class found.

## Lane B — additive Hilbert 90

`ker Tr = {u−σ(u)}`.  Solubility is `c ψ(a)=u−σ(u)`.  No exact factorization
into a decidable conic / Severi–Brauer fibration with a section was obtained
for general `u`.  **Push:** cyclic partial sums with rational coeffs empty;
ratio family `a=(1+s r0)/(1+s r1)` has modular roots but no `s∈K` section.

## Lane C — projection from the degree-five closed point

Degree-five point over `E` (H4) gives index one only.  Projection from a single
skip-one line yields a residual conic bundle over `E`, not over `K`.  Galois
descent of that bundle / its SB class remains open.  Skip-one lines rechecked
modularly on `F` in the push.

## Lane D — multi-prime reconstruction

Specialized fibres over many `F_p` are routinely nonempty (discovery only).
No stable rational component with compatible torsor trivialization was
reconstructed to a `K`-identity.

## Points over `K`

```text
none
```
