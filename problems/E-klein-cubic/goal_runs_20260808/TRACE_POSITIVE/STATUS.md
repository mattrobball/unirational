# `TRACE_POSITIVE` status

**Date:** 2026-08-08  
**Verdict:** `CHAR5-ED-UNDECIDED / EXACT BOUNDARY ESTABLISHED`

For an algebraically closed field `k` of characteristic five,

```text
2 <= ed_k(F55) <= 4.
```

The value four is equivalent to the assertion that every nonzero homogeneous
polynomial self-covariant of the irreducible faithful five-space is dominant.
That all-degree assertion is not proved, and no three-dimensional compression
is constructed.

Established in `CHAR5_ED_AUDIT.md`:

1. the exact five-dimensional modular module and the Loetscher
   `covdim = ed + 1` reduction;
2. every monomial covariant is dominant, in every degree;
3. every additive/Frobenius-polynomial covariant is dominant, in every degree;
4. every nonzero homogeneous covariant of degree `1,2,3,4` is dominant;
5. the complete degree-five, trivial-character covariant landing scheme on
   the Klein cubic is projectively empty;
6. `ed(A;11)=1` for the degree-five twisted kernel does not imply absolute
   `ed(A)=1`; the absolute mixed-prime problem survives.

Exact markers:

```text
F55-CHAR5-ALL-DEGREE-LT5-COVARIANTS-DOMINANT
F55-CHAR5-DEGREE5-LANDING-EMPTY
```

No covariant degree above five was computed.

## Artin--Schreier/difference-field boundary

`CHAR5_AS_CYCLIC_COUNTERMODEL.md` gives exact witnesses over
`F_(5^5)/F_5` for all four remaining progression systems.  They impose
cyclic conjugacy on both universal values and the multiplicative equation
`a_i=u_i^2u_(i+1)`, while avoiding both pure Klein landings.  Hence the
progression systems cannot be closed by an abstract cyclic-difference-field
or Newton-determinant identity alone.  Polynomiality, homogeneity, the
`C11` weight, or special geometric ramification must enter any valid proof.

This is a method boundary, not a landing covariant.
