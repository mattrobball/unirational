# Replay: cubic-surface-bundle family

From the repository root:

```bash
python3 research/equivariant-unirationality-new-applications/verify_cubic_surface_bundle_family.py --n 3
python3 research/equivariant-unirationality-new-applications/verify_cubic_surface_bundle_family.py --n 5
python3 research/equivariant-unirationality-new-applications/verify_cubic_surface_bundle_family.py --n 7
python3 research/equivariant-unirationality-new-applications/verify_cubic_surface_bundle_family.py --n 9
```

Expected output:

```text
CUBIC_SURFACE_BUNDLE_FAMILY_VERIFY_OK n=3
CUBIC_SURFACE_BUNDLE_FAMILY_VERIFY_OK n=5
CUBIC_SURFACE_BUNDLE_FAMILY_VERIFY_OK n=7
CUBIC_SURFACE_BUNDLE_FAMILY_VERIFY_OK n=9
```

The verifier checks only finite exact inputs:

- squarefreeness and degree of `S^(2n)+T^(2n)`;
- the complete `D_{2n}`-invariant degree-`2n` monomial support used by the construction;
- the complete central-`C3` invariant cubic monomial support in `(U,V,X,Y)`;
- the genus `4n-2` of the fixed bidegree-`(2n,3)` curve;
- the `4n` isolated central fixed points;
- the odd-dihedral abelian-subgroup calculation;
- exact `r`-, `s`- and `z`-invariance of the displayed equation `Phi`, with
  symbolic binary-cubic coefficients, and its bidegree;
- the restriction of `Phi` to each of the three components of the `z`-fixed
  locus;
- the five base-locus derivative identities of Section 3 and the fact that
  `A0`, `A1` have no common zero;
- the three rational sections, checked against the full equation `Phi`.

The general-member smoothness statement is not delegated to sampling. It is the Bertini and base-locus derivative argument in `THEOREM_CUBIC_SURFACE_BUNDLE_FAMILY.md`, Section 3.

Recorded local replay during construction:

```text
CUBIC_SURFACE_BUNDLE_FAMILY_VERIFY_OK n=3
CUBIC_SURFACE_BUNDLE_FAMILY_VERIFY_OK n=5
CUBIC_SURFACE_BUNDLE_FAMILY_VERIFY_OK n=7
```
