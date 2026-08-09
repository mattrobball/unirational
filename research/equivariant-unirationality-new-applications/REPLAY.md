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

## Recorded output

See `verification_output.txt` for successful runs at

\[
g=3,5,7,9.
\]

## Theorem dependency order

```text
GENERALIZATIONS.md
    |
    +--> THEOREM_KLEIN_QUARTIC_DOUBLE_SOLID.md

repository central theorem in FIX_T_gate.md
    |
    +--> THEOREM_ODD_EXCEPTIONAL_CONIC_BUNDLES.md
```

The finite scripts verify only the explicit equations and fixed-locus inputs. They do not substitute for the geometric proofs.
