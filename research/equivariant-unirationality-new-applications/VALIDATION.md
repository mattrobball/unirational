# Validation checklist

This file records the final adversarial checks before publication.

## Structural theorem boundary

- [x] Uses the controlled strict-transform/eigenbundle induction from `FIX_IX_v14.md`.
- [x] Does **not** use the withdrawn assertion that arbitrary fixed strata remain RCC through arbitrary equivariant blowups.
- [x] Surface conclusions do not require the higher-dimensional b-complex conjecture.
- [x] The ruled-fixed-surface application uses an honest equivariant morphism to a positive-genus curve, not a merely rational MRC quotient.

## Odd-dihedral conic bundles

- [x] Branch polynomial `x^(2n)+y^(2n)` is squarefree in characteristic zero.
- [x] The total-space Jacobian has no zero on the projective conic bundle.
- [x] The two global sections split the generic conic, so the surface is rational.
- [x] The central fixed scheme is exactly `q^2=x^(2n)+y^(2n)`; the negative projective eigenspace misses the conic.
- [x] Riemann-Hurwitz gives genus `n-1`.
- [x] The full odd-dihedral group has no common fixed point on the base.
- [x] Every abelian subgroup has one of the explicit rotation/reflection witnesses.
- [x] Every Sylow subgroup has a fixed point.

## Fermat degree-two del Pezzo

- [x] The branch plane quartic is smooth and has genus three.
- [x] The common `S3`-fixed line in the permutation representation is `span(1,1,1)`, which misses the branch curve.
- [x] A transposition has fixed branch points on `x=y`.
- [x] A three-cycle has the exact cyclotomic fixed points `[1:omega:omega^2]` and `[1:omega^2:omega]`.
- [x] Every abelian subgroup and every Sylow subgroup receives a fixed-point witness.

## Exact replay

Run:

```bash
python3 research/equivariant-unirationality-new-applications/verify_dihedral_conic_bundle.py
python3 research/equivariant-unirationality-new-applications/verify_fermat_dp2_s3.py
python3 research/equivariant-unirationality-new-applications/verify_new_applications.py
```

Expected terminal markers:

```text
DIHEDRAL_CONIC_BUNDLE_CERTIFICATE: PASS
FERMAT_DP2_S3_CERTIFICATE: PASS
ODD_DIHEDRAL_CONIC_BUNDLE_AUDIT: PASS
FERMAT_DP2_S3_AUDIT: PASS
NEW_APPLICATIONS_EXACT_CHECKS: PASS
```

## Literature labels

The labels `OPEN-CONFIRMED` in this packet mean only:

> no theorem deciding the exact weak-versality or equivariant-unirationality question was located in the primary, citing, current-preprint, or adjacent-birational-model literature searched through 2026-08-09.

They do not mean that non-linearizability, stable non-linearizability, quotient irrationality, or ordinary irrationality was absent from the literature.
