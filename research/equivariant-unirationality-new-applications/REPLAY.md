# Replay

Run from the repository root.

## Requirements

- Python 3.11 or later;
- SymPy.

No Sage, Magma, GAP, Macaulay2, Singular, or external solver is required.

## Smooth quartic double solid

```text
python3 research/equivariant-unirationality-new-applications/verify_klein_quartic_double_solid.py
```

Expected terminal marker:

```text
KLEIN_PSL27_QUARTIC_DOUBLE_SOLID_VERIFY_OK
```

The script checks:

1. projective smoothness of the invariant quartic on all four affine charts;
2. invariance under the explicit \(C_7\) and \(C_3\) generators;
3. the relation \(bab^{-1}=a^4\);
4. the \(C_7\)-fixed branch points and the absence of an \(H\)-fixed branch point;
5. the restriction to the \(C_3\)-fixed line.

The normal-subgroup/\(\operatorname{PGL}_2\) argument excluding residual-stable rational curves is a proof, not a CAS assertion.

## Odd exceptional conic bundles

For any odd integer \(g\ge3\), run

```text
python3 research/equivariant-unirationality-new-applications/verify_odd_exceptional_conic_bundle.py --g 5
```

with `5` replaced by the desired odd genus.

Expected terminal marker:

```text
ODD_EXCEPTIONAL_CONIC_BUNDLE_VERIFY_OK g=5
```

The script checks:

1. squarefreeness of the hyperelliptic branch polynomial;
2. the \(2g+2\) branch-point and genus calculation;
3. the weighted-projective order of the rotation;
4. invariance of the exceptional-conic-bundle equation;
5. the parity that fixes the points over reflection eigendirections.

The classification of abelian subgroups of the odd dihedral group and the central fixed-locus obstruction are proved in the theorem file.

## Cubic-surface-bundle family

For any odd integer \(n\ge3\), run

```text
python3 research/equivariant-unirationality-new-applications/verify_cubic_surface_bundle_family.py --n 5
```

with `5` replaced by the desired odd integer.

Expected terminal marker:

```text
CUBIC_SURFACE_BUNDLE_FAMILY_VERIFY_OK n=5
```

The script checks:

1. squarefreeness of \(S^{2n}+T^{2n}\);
2. the exact degree-\(2n\) dihedral-invariant monomial support used in the construction;
3. the exact central-\(C_3\)-invariant cubic monomial support in \((U,V,X,Y)\);
4. the fixed curve genus \(4n-2\) and the count of the \(4n\) isolated fixed points;
5. the odd-dihedral abelian-subgroup calculation;
6. that the displayed \(\Phi\) of (1.5), with symbolic cubic coefficients, is
   exactly invariant under \(r\) (modulo \(e^n-1\)), under \(s\), and under
   \(z\) (modulo \(w^3-1\)), and is of bidegree \((2n,3)\);
7. that \(\Phi\) restricted to the three components of the \(z\)-fixed locus
   equals \(A_0F_0+A_1F_1\), \(A_0U^3\), and \(A_0V^3\) respectively;
8. the five base-locus derivative identities of Section 3 and the fact that
   \(A_0,A_1\) have no common zero;
9. that the three displayed rational sections lie on \(\Phi=0\).

The nonempty smooth parameter-open set is proved by the Bertini and base-locus derivative argument in `THEOREM_CUBIC_SURFACE_BUNDLE_FAMILY.md`; it is not inferred from finite sampling.

## Double-quadric `C4` rejection screen

```text
python3 research/equivariant-unirationality-new-applications/verify_double_quadric_c4_screen.py
```

Expected terminal marker:

```text
DOUBLE_QUADRIC_C4_SCREEN_OK fixed_points=4
```

The script builds the permutation matrix of the four-cycle on \(\mathbf C^5\), verifies that it has order four, that it preserves the Fermat form, and computes its eigenvalues exactly as \(\{1,1,-1,i,-i\}\). It then verifies each eigenline, evaluates

\[
Q=\{x_0^2+\cdots+x_4^2=0\}\subset\mathbf P^4
\]

on it, checks that the \(+1\)-eigenspace restriction \(4a^2+b^2\) is squarefree of degree two, concludes that the fixed locus consists of four isolated points, and checks that the natural character on every \(\mathcal O_Q(4)\)-fiber is trivial. Finally it computes the exact `c`-character of \(T_pQ\) at each of the four points and verifies that the trivial character does not occur. The geometric screening lemma then proves that a smooth **invariant** quartic branch section avoids all four points, so Condition (A) fails for the direct `C4 x C2deck` extension. The semi-invariant boundary is recorded in `QUADRATIC_DOUBLE_SOLIDS.md`, Section 4.

## Recorded output

The packet records successful surface-family runs at

\[
g=3,5,7,9,
\]

and successful cubic-family runs at

\[
n=3,5,7,9.
\]

The exact double-quadric screen returns four fixed points.

## Theorem dependency order

```text
GENERALIZATIONS.md
    |
    +--> THEOREM_KLEIN_QUARTIC_DOUBLE_SOLID.md
    |
    +--> THEOREM_CUBIC_SURFACE_BUNDLE_FAMILY.md

repository central theorem in FIX_T_gate.md
    |
    +--> THEOREM_ODD_EXCEPTIONAL_CONIC_BUNDLES.md

isolated-fixed-point derivative lemma
    |
    +--> QUADRATIC_DOUBLE_SOLIDS.md (C4 rejection, not a negative theorem)
```

The finite scripts verify only explicit equations, characters, and fixed-locus inputs. They do not substitute for the geometric proofs.
