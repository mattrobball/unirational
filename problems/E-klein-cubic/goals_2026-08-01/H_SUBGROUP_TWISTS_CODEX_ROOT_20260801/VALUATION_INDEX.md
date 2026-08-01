# Valuation, fixed-locus, and index screens

## Index one for every relevant generic twist

Every twist is a cubic hypersurface in an ordinary `P4`, so a rational
linear section supplies a zero-cycle of degree `3`.

For either maximal `A5`, choose a subgroup `C3`.  Its projective fixed locus
on `X` is nonempty.  The orbit of any such point under `A5` has degree

\[
[A5:\operatorname{Stab}(p)],
\]

where the stabilizer contains `C3`.  Since `|A5|=60` contains only one
factor of `3`, this orbit degree is prime to `3`.  Twisting the invariant
finite orbit gives an effective closed zero-cycle of the same degree on the
generic twist.  Together with degree `3`, this proves index one for both
nonconjugate `A5` generic twists.

For `11:5`, the five `C11` eigenlines form an exact orbit of degree `5` on
the Klein cubic.  Twisting gives a degree-`5` zero-cycle, so the degree-`3`
linear section again proves index one.

Thus screen H-C cannot prove pointlessness.  This is an index statement,
not a rational-point statement.

## Fixed-locus/normalizer screen

The repository's exact fixed-stratum census shows:

- `W|A5` and `W|(11:5)` are irreducible, so neither has a projectively fixed
  line;
- the unique character lines for `D12` and `D10` and both character lines
  for `A4` lie off `X`;
- normal exceptional directions prevent the set-theoretic OD16-style
  fixed-component test from giving a contradiction.

For `D12` and `D10`, the stronger contained-line construction gives points
on all twists.  For `A4`, Theorem 5.1 of Cheltsov--Tschinkel--Zhang applies:
Condition (A) is inherited from the full `G`-action, and `A4` is not among
the theorem's possible exceptions.  Hence the `A4` action is
`A4`-unirational and every `A4`-twist has a point.

The same theorem leaves exactly the irreducible `A5` pencil and `11:5` on
the Klein cubic as possible proper-subgroup exceptions.  Therefore no
smaller proper subgroup remains after the positive cases above.

## Divisorial screen

The icosahedral quotient has natural invariant degrees `2,6,10,15`; their
branch inertia is cyclic.  Condition (A) removes a bare cyclic fixed-point
obstruction, but it does not by itself descend a point through the residue
torsor or prove henselian solubility.  No reduction of either exact generic
twist has been proved to have index greater than one, and the global index
calculation above rules out any valuation argument whose conclusion would
force the global index to be divisible by `3`.

This packet makes no pointlessness claim from a special fibre.  A successor
valuation proof must use the exact Hilbert--90 equations and prove the full
properness/residue implication; a special auxiliary cubic is insufficient.

## Direct exact search

For both maximal `A5` classes, `a5_low_degree_search.json`,
`a5_degree5_7_search.json`, and `a5_degree8_9_search.json` compute the full
spaces

\[
\operatorname{Hom}_{A5}(\operatorname{Sym}^d V_3,W),\qquad 0\le d\le4,
\]

with dimensions `0,0,1,0,2,1,3,2,5,3`.  The unique quadratic covariant does
not land on `X`.  For every degree from four through nine, every standard
affine chart of the complete projective coefficient space has unit landing
ideal modulo 89 (the `P1` cases equivalently have unit gcd and fail at
infinity).  Hence every such geometric landing scheme is empty in the good
fibre.  Maschke exactness and proper specialization transfer these bounded
exclusions to characteristic zero.

Two function-field subspaces were also checked.  In the full degree-four
two-covariant span, the landing polynomial is an irreducible `t`-cubic over
`F_89(y0,y1,y2)` and remains irreducible over the cubic constant extension.
Likewise, the unique `t`-positive factor on each of the ten coordinate lines
in a full five-column covariant frame has `t`-degree three and remains so over
`F_(89^3)`.  Since a geometric `t`-linear factor would have a Frobenius orbit
of size three, these extension checks exclude it on the displayed lines.

This is a complete degree-`<=9` homogeneous screen plus specified frame-line
screens only.  It is not an all-degree
pointlessness theorem and does not replace the function-field rational-point
question.
