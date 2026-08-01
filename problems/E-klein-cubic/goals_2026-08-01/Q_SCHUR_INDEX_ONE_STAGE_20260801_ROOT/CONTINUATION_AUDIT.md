# Continuation audit — 2026-08-01

## Binary gate

The continuation did not construct a `K_Schur`-point and did not prove the
genuine twist pointless.  The only honest exit remains

```text
Q-UNDECIDED
```

The new computations below are exact at their stated scopes.  None is an
index-one-to-point principle, an all-degree covariant theorem, or a
pointlessness obstruction on the full proper twist.

## New exact results

1. **Exact genuine-Schur frame and full cubic.**  Five degree-eight Reynolds
   columns give a characteristic-zero Hilbert--90 frame for the genuine
   torsor.  Exact covariance, a nonzero determinant witness, and the complete
   35-entry descended cubic table (625 ordered products) are independently
   replayed.  This closes the explicit-frame/table part of Q2.0, but supplies
   neither a zero nor a minimal invariant-field presentation; the inherited
   ten-fibration comparison is not replayed in coordinates here.
2. **Both maximal `A5` valuation classes eliminated.**  Exact degree-eleven
   landing maps from honest three-dimensional `A5` representations twist to
   rational maps from split projective planes.  Every twist by either
   embedded `A5` is therefore soluble.  Exact Hensel lifting reduces the
   unramified nonpoint frontier from four decomposition classes to `{G,11:5}`.
3. **Degree nine for `11:5`.**  The complete coefficient space has dimension
   65.  All five projective-character landing systems have the same 697125
   term supports in 2860 equations.  Exhaustive reverse deletion visits
   26912397 unique supports and finds no nonempty stopping support.  Hence
   every degree-nine landing scheme is empty, and the complete bounded range
   is now `1..9`.  The independent terminal replay took `1:05:10.6`
   (`3910.6` seconds).
4. **All-exponent two-Laurent theorem.**  For
   `Phi(a)=Tr(r2^-1*a^2*sigma(a))`, no nonzero Laurent polynomial supported
   on at most two monomials with coefficients in `C` is isotropic.  The proof
   enumerates all 203 partitions and 7125 exact Smith systems; the only hits
   give the zero expression.
5. **Full-`K` two-Fourier-basis theorem.**  In the exact Kummer presentation,
   `Phi(R2*(alpha^p+t*alpha^q))` is nonzero for all ten pairs `p<q` and every
   `t in C(U1,U2,U3,U4)`.  Primitive monomial valuations give one-segment
   Newton polygons whose root valuations have denominator three.
6. **Ten exact three-Kummer genus-one frontiers.**  Every three-coordinate
   restriction is reconstructed by both compact trace formulas and an
   ordered 27-term expansion cross-check.  Exact Singular certificates at
   `(U1,U2,U3,U4)=(2,3,5,7)` prove all ten generic plane cubics geometrically
   smooth and integral.  Any `K`-point must lie in `XYZ!=0`, but no point or
   torsor obstruction is obtained.
7. **All-exponent three-coordinate Laurent-monomial theorem.**  On each of
   the ten planes, no point has three coordinates that are single Laurent
   monomials with nonzero complex constants and arbitrary exponent vectors.
   The exact support proof tests 673010 integral candidates and all parallel
   collision families.  It does not allow coordinate sums or arbitrary
   rational functions.
8. **Exact `C_012` Jacobian.**  Fisher's normalized Hessian-pencil formulas
   give exact canonical `c4` and `c6` tables with 14 and 40 grouped terms and
   the Jacobian `y^2=x^3-27*c4*x-54*c6`.  The torsor class and rational-point
   question are not decided.
9. **Characteristic-zero full-Schur Palatini model.**  The exact
   `Q(zeta_11)` Schur five-plane is matched to its good reduction.  The
   rank-drop quartic is the unique invariant `I4`, and six degree-seven
   Reynolds covariants give a generic projective frame.  The missing positive
   identity is `I4(sum b_i r_i)=0` with invariant-rational `b_i`.
10. **Fixed-curve bridge.**  An actual odd-degree genus-zero stable map over
   `K_Schur` forces a point, including reducible domains.  An actual point of
   the generalized-twisted-cubic Hilbert component also forces a point.  A
   coarse moduli point without a lift, a Galois-stable orbit, or a virtual
   count does not satisfy either premise.

## Audited nonresults

- Factorization of the Fourier-pair cubic over `Q(zeta_5)` was not used to
  infer irreducibility after extending constants to `C`; the final proof is
  the constant-field-safe Newton valuation certificate.
- The ten three-Kummer equations, their generic smoothness, the all-exponent
  single-Laurent-coordinate exclusion, and the `C_012` Jacobian are sealed.
  Rank-one tropical and bounded Laurent-coefficient searches found no point
  and gave no torsor obstruction; those searches remain unsealed discovery
  work.  Computing the Jacobian does not compute the torsor class.
- A modular Palatini identity alone was initially insufficient for a
  characteristic-zero claim.  The final packet adds the exact intertwiner,
  reduction match, and characteristic-zero invariant-multiplicity proof.
- A first Laurent rerun in the Fourier `R_i` coordinates mixed the simple-root
  and projective cyclic-action matrices and was rejected.  With the correct
  matrix, the `R`-coordinate system is integrally conjugate to the already
  certified `r`-coordinate theorem, so it supplies no additional result.
- The degree-nine singleton theorem ends at degree nine.  The recorded
  Hilbert numerator and invariant translations still provide no all-degree
  cutoff.

## Smallest surviving gates

Positive:

```text
find 0 != a in K^5 with F(Q(v)a)=0,

or

find 0 != a in E with Tr_E/K(r2^-1*a^2*sigma(a))=0,
```

or solve the full-Schur Palatini identity, or construct an actual descended
odd-degree genus-zero curve/Hilbert point.

Negative: construct a functorial obstruction or a pointless henselian
specialization for the full genuine twist, with one of the two surviving
decomposition groups.  The nontrivial order-eleven multiplicative class and
the bounded covariant exclusions do not by themselves supply that theorem.
