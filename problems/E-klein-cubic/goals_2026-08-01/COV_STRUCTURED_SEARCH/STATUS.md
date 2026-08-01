COV-NEW-ANSATZ-STRUCTURAL

# Status

**Repository headline: OPEN.**  No landing covariant was found, so this run
does not prove `PSL(2,11)`-unirationality of the Klein cubic and does not invoke
`BR-COV-POS`.

## Exact structural result

The bounded structured list is degrees 25, 31, and 35: respectively the first
unresolved representatives of the residual `e>=7`, `e=1`, and `e=5` families.
For each degree the run supplies exact Reynolds seed labels for a full
characteristic-zero self-covariant basis and independently checked good-fibre
restriction modules at primes 89 and 199.

The combined first- and second-normal-jet map is injective on the full
arrangement kernel in every selected degree at each good fibre.  Since the
models and conditions are integral, one injective special fibre excludes a
nonzero characteristic-zero kernel.  Consequently any landing covariant in
degrees 25, 31, or 35 must have plane order exactly one.  In particular, the
formal order-three and order-five branches do not globalize in these degrees.

The run also constructs two globally equivariant families:

- invariant-scaled `x,C,D,E,K` and every homogenizable ordered two-fold
  composition;
- invariant multiples of generalized cross products of four invariant
  gradients.  The latter vanish on every one of the 55 involution plus-planes
  identically, by a characteristic-zero determinant argument.

Their full linear span has dimensions 18, 28, and 32.  Its polarized cubic
landing matrices have ranks/coranks

```text
degree 25: 1127 / 1140, corank 13
degree 31: 4036 / 4060, corank 24
degree 35: 5963 / 5984, corank 21
```

at both primes 199 and 353.  An exact dual contraction/integrability
calculation gives zero quartic dual in all six cases.  Thus the quartic closure
of each landing ideal is the full quartic parameter space, and the projective
special fibres are empty.  Proper specialization for the integral projective
families proves that all three combined ansätze are empty in characteristic
zero.  This includes every mixed composition/cross term, not merely the two
subfamilies separately.

## Scope and remainder

This is not `COV-STRUCTURED-DEGREES-EMPTY-SCOPED`: the full self-covariant
spaces in degrees 25, 31, and 35 were not subjected to complete nonlinear
landing elimination.  The good-fibre arrangement dimensions `59,198,361` and
common-line strict dimensions `43,176,335` agree across primes, but agreement
alone is not a characteristic-zero reconstruction of those kernels.

The smallest remaining global computation is the already-known degree-25
43-dimensional strict landing support.  For the new residual classes, the
next task is to reconstruct the full characteristic-zero plane-order-one
equalizer in degree 31 (then 35), impose all triple-line, point-link, `C3`, and
marked-elliptic maps, quotient the primitive module, and solve its landing
ideal.  No candidate exists here, so primitivity, dense-open definition, and a
Jacobian rank-four minor are not applicable.

## Repository binding

- pinned mathematical baseline: `715faf441289e2589b9325311b6613ea0331bf88`;
- live head consumed at start: `2140419410cfff2f7d7dcca166acef8c16a0d41b`;
- shared verification-time head: `53e267a59b2d24de93c58dd9ddacc2f995fc2d68`;
- produced state: uncommitted isolated worktree directory; no commit or push
  was requested, and unrelated concurrent worktree changes were not touched.

Exact parent-input hashes are in `INPUTS.json`; content hashes are in
`SEAL.json`.
