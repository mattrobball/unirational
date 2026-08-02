# Integral degree-four multisections

Let `F=K(q)` and let `S/F` be the smooth generic cubic-surface fibre.

## Unconditional nonemptiness theorem

An integral degree-four closed point on `S` exists in both possible section
branches.

If `S(F)` is empty, the certified degree-55 point meets the hypotheses of
Voisin's characteristic-zero point-or-degree-four theorem.  It supplies a
point over an extension of degree four.  The residue degree divides four.
Degree one contradicts the hypothesis, and degree two gives an `F`-point by
the conjugate-pair secant residual construction.  Hence the residue degree is
exactly four.

If `S(F)` is nonempty, Kollár's theorem makes `S` `F`-unirational.  Put

\[
L=F(\theta),\qquad \theta^4=q.
\]

`T^4-q` is Eisenstein at the `q`-adic valuation.  Since `mu_4` is contained
in `C`, `L/F` is cyclic of degree four with unique quadratic subfield
`F(theta^2)`.  Weil restriction of a dominant unirational parametrization
gives

\[
\mathbf A_F^{4m}\dashrightarrow \operatorname{Res}_{L/F}(S_L).
\]

The locus fixed by the order-two subgroup is proper: after base change to an
algebraic closure it is the pairwise diagonal in `S^4`, of dimension four
inside dimension eight.  Delete the indeterminacy locus and the inverse image
of this fixed locus.  The remainder is a nonempty open in affine space, and
it has an `F`-point because `F` is infinite.  Its image is an `L`-point not
fixed by the order-two subgroup, so its residue field is exactly `L`.

In either case, normalize `B=P1_K` in the quartic residue field.  The
normalization is finite because `B` is excellent.  It gives an integral
normal degree-four cover `C->B`, finite flat because its module is finite
torsion-free over the regular curve `B`.  Properness of `Y/B` extends the
generic point to `C->Y`.
Thus `C` is an integral degree-four multisection.

The external inputs are Voisin, arXiv:2509.17996v2, and Kollár,
arXiv:math/0005146v1.  Their exact URLs and scopes are pinned in
`INPUT_MANIFEST.json`.

## What the theorem selects

This proves the authorized structural exit

```text
M3-INTEGRAL-DEGREE4-MULTISECTION
```

but not a section.  In fact the full integral quartic locus is never empty,
so emptiness cannot select the section alternative.

More sharply, an imprimitive integral quartic exists if and only if `S(F)` is
nonempty.  The forward implication uses its invariant `2+2` block and
quadratic secant descent; the reverse implication is the cyclic construction
above.  Therefore a quartic that occurs in the no-section branch is
primitive.  Its Galois closure is `A4` or `S4`, it spans `P3`, and its cubic
resolvent is irreducible.  The surviving object is an arithmetic stratum, not
a geometric component of `Sym^4(S_bar)`.

## Exact field-algebra interface

On each of four projective charts use

\[
g(T)=T^4+c_2T^2+c_1T+c_0
\]

and write the three unfixed surface coordinates as cubics in `T`.  This gives
15 variables and four equations obtained by reducing the cubic-surface
equation modulo `g`.  A primitive no-section certificate must also verify:

1. `g` is irreducible and separable over `K(q)`;
2. the four coordinate coefficient vectors have nonzero `4 x 4` determinant;
3. the cubic resolvent
   `y^3-c2*y^2-4*c0*y+(4*c2*c0-c1^2)` is irreducible;
4. the quartic discriminant distinguishes `A4` from `S4`;
5. all four remainders vanish and every Schur denominator is nonzero.

The exact theorem-level existence proof above does not provide one explicit coefficient
tuple in this chart.  Producing such a primitive `A4/S4` tuple would refine
the structural theorem but still would not prove that a section is absent.
