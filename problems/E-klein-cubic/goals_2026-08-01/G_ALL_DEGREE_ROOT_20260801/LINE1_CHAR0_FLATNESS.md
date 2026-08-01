# Exact degree-one flatness and the characteristic-zero degree-four transfer

## Complete cyclotomic landing ideal

Let

```text
K = Q(zeta_11),
p = (67, zeta_11 - 64),
R = Z[zeta_11]_p.
```

The script `produce_line1_char0.py` reconstructs the representative `A4`
stabilizer from the exact five-dimensional Klein representation over `K`.
It obtains the fixed line and the three incident involution planes from exact
Reynolds projectors.  The resulting adapted basis preserves the three
branches of the triple-line symbolic ideal.  Its reduction differs from the
installed split-67 basis by a line change of basis plus three nonzero branch
scalings.

The complete order-three, transverse-degree-six, line-degree-one covariant
space has dimension eight.  Expanding the Klein equation gives a rank-14
coefficient ideal.  This is an exact characteristic-zero statement, not a
rank inferred from one prime: the producer forms an exact cyclotomic RREF of
14 independent rows and reduces all

```text
4 * 190 = 760
```

rows on the unisolvent binary-degree-three/ternary-degree-eighteen grid
against it.  Every remainder is zero, and every one of the 760 exact rows
reduces coefficientwise to its independently reconstructed split-67 row.
Thus `m3_line1_char0.sing` defines the full landing ideal on the generic and
special fibres of the affine chart `a_0=1`.

Singular computes

```text
field             dimension   vector-space dimension   GB size
Q(zeta_11)             0                 48                36
F_67                    0                 48                36
```

from the independently emitted characteristic-zero and reduction inputs.
Every denominator in the characteristic-zero input is prime to 67.  The
producer also verifies coefficient by coefficient that reduction at
`zeta_11=64` is the reconstructed split model.

## Finite flatness over the cyclotomic DVR

The emitted projective-boundary input sets `a_0=0` and covers the remaining
projective space by `a_i=1`, for `1<=i<=7`.  Singular returns the unit ideal
on all seven charts.  By properness, after localizing `R` if necessary, the
projective family is contained in `a_0=1`.  Its affine coordinate algebra
`A` is therefore a finite `R`-module.

Let `A` now denote the quotient by all 760 integral coefficient equations.
The preceding exact span and reduction checks identify both of its fibres
with the 14-row Gröbner inputs.  The exact calculations therefore give

```text
rank_R(A) = dim_K(A tensor_R K) = 48,
dim_F67(A/pA) = 48.
```

For a finite module over a DVR, the special-fibre dimension equals its free
rank plus the number of nonzero cyclic torsion summands.  Equality of the two
displayed numbers therefore leaves no torsion.  Hence

\[
                         \boxed{A\simeq R^{48}.}
\]

This proves the previously missing finite-flatness lemma.

## Degree-four transfer

Let `X_4` be the projective degree-four central-compatible landing family,
and let `Y_4=D_L X_1`.  Cubic homogeneity gives a closed inclusion

\[
                         Y_4\subseteq X_4.
\]

The eight-chart split-fibre certificate in `LINE4_SCHEME_RIGIDITY.md` proves
`(X_4)_p=(Y_4)_p` scheme-theoretically.  The special fibre of `X_4` is finite,
so projectivity and upper semicontinuity make `X_4` finite over the localized
DVR.  On coordinate algebras the closed inclusion gives

\[
0\longrightarrow N\longrightarrow \mathcal O_{X_4}
 \longrightarrow \mathcal O_{Y_4}\longrightarrow0.
\]

The algebra of `Y_4`, being isomorphic to the degree-one algebra, is flat.
Tensoring with the residue field is therefore left exact.  Special-fibre
equality gives `N/pN=0`, and Nakayama gives `N=0`.  Consequently

\[
 \boxed{X_4=Y_4=D_LX_1\text{ over }R\text{ and over }Q(\zeta_{11}).}
\]

Thus characteristic zero has no primitive degree-four landing point on this
first transverse layer.  This remains a local, single-line-degree theorem:
it does not prove an all-line-degree recurrence, control higher transverse
layers, or decide the generic twisted Klein cubic.

## Replay

```sh
/opt/homebrew/bin/python3 produce_line1_char0.py
/opt/homebrew/bin/python3 verify_line1_char0.py
```

The full verifier regenerates the 760-row exact span certificate, compares
the emitted inputs byte-for-byte, runs the generic, special, and seven-chart
boundary Singular calculations, and ends with

```text
LINE1_CHAR0_VERIFY_OK
```
