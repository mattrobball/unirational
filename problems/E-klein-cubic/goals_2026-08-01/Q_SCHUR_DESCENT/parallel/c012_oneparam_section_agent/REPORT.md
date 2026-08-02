# `C_012` at `(U2,U3,U4)=(3,5,7)`: a bounded stop

## Exact verdict

Put

\[
 k=\mathbf Q(\epsilon),\qquad
 \epsilon^4+\epsilon^3+\epsilon^2+\epsilon+1=0,
 \qquad U_1=s,\qquad (U_2,U_3,U_4)=(3,5,7).
\]

This packet proves three statements about this one-parameter specialization:

1. it reconstructs the exact specialized plane cubic;
2. it determines the singular fibres of its Jacobian; and
3. it excludes every polynomial-coordinate representative
   `[X(s):Y(s):Z(s)]` with all three degrees at most `3`.

It does **not** decide whether the specialized curve has a point over `k(s)`,
whether the generic `C_012` has a section, or whether the full Schur twist has
a rational point.  The status is `C012_GENERIC_SECTION_UNDECIDED`.

## Exact specialized cubic

The replay reconstructs the trace cubic from the upstream exact packets and
divides it by the harmless scalar `5`.  The normalized equation is

\[
 F(s;X,Y,Z)=X^3+sF_1(X,Y,Z)+s^2F_2(X,Y,Z)+s^3F_3(X,Y,Z).
\]

It has `26` nonzero `(s,X,Y,Z)` monomials.  The complete exact coefficient
table is in `payload.json`: an entry

```text
{"exp":[a,b,c,d],"coeff":[q0,q1,q2,q3]}
```

means

\[
 (q_0+q_1\epsilon+q_2\epsilon^2+q_3\epsilon^3)s^aX^bY^cZ^d.
\]

Its canonical-table hash is

```text
e577a7b5489327d9c6a93474e50941ab4b8d288ca563745ed8c5cb376b382250
```

In particular, `F(0;X,Y,Z)=X^3`: the plane model has a triple line at
`s=0`.

## Exact Jacobian fibres

The upstream Fisher packet gives the normalized Jacobian

\[
 y^2=x^3-27c_4x-54c_6.
\]

After the specialization, exact factorization over `k` gives:

| invariant | degree in `s` | order at `s=0` | factorization pattern |
|---|---:|---:|---|
| `c4` | 12 | 3 | `unit * s^3 * q9` |
| `c6` | 18 | 4 | `unit * s^4 * q14` |
| `Delta_red=c4^3-c6^2` | 35 | 8 | `unit * s^8 * q27` |

Here `q9`, `q14`, and `q27` are irreducible of the indicated degrees over
`k`.  The replay reconstructs every coefficient from the upstream invariant
tables, checks canonical hashes, and asks Singular to reproduce these exact
factor patterns.

The characteristic-zero Kodaira table therefore gives:

| place | fibre |
|---|---|
| `s=0` | `IV*` |
| each of the 27 roots of `q27` | `I1` |
| `s=infinity` | `I1` |

For the last row, put `t=1/s` and use

\[
 t^{12}c_4(1/t),\quad t^{18}c_6(1/t),\quad
 t^{36}\Delta_{\rm red}(1/t).
\]

Their orders at `t=0` are respectively `0`, `0`, and `1`.  At each root of
`q27`, `c4` is a unit because the irreducible residual factors of `c4` and
`Delta_red` have different degrees.  Thus those 27 fibres are nodal `I1`
fibres.

The triple line in the singular plane presentation is not a section
obstruction by itself.  Its Jacobian degeneration is the displayed `IV*`
fibre, and the Jacobian has its zero section regardless of whether the
original genus-one torsor has a section.  These fibre data do not compute the
torsor class.

## Exact degree-at-most-three exclusion

Write

\[
 X(s)=\sum_{i=0}^3x_i s^i,\qquad
 Y(s)=\sum_{i=0}^3y_i s^i,\qquad
 Z(s)=\sum_{i=0}^3z_i s^i.
\]

The identity `F(s;X(s),Y(s),Z(s))=0` gives `13` homogeneous cubic equations
in the `12` coefficient variables.  Thus solutions form a closed subscheme
of `P^11`; lower-degree triples are already included by setting leading
coefficients to zero.

Reduce at the split prime

\[
 (11,\epsilon-3),
 \qquad 3^4+3^3+3^2+3+1=0\pmod {11}.
\]

The replay covers `P^11` by the twelve disjoint first-nonzero-coordinate
charts: preceding coefficients are set to zero and the first nonzero one to
one.  Exact Gröbner computations over `F_11` give the unit ideal in every
chart.  Hence the projective special fibre is empty.

This is a characteristic-zero bounded exclusion, not merely a heuristic
finite-field search.  A characteristic-zero projective coefficient point
would be defined over a finite extension of `k`; properness supplies an
integral model at a place above `(11,epsilon-3)`, whose reduction would be a
point in one of the twelve charts.  No such reduced point exists.  Therefore
there is no nonzero polynomial triple of coordinate degree at most `3`, even
after algebraic extension of `k`, satisfying the specialized cubic identity.

## Why this stops without a generic verdict

A point over `k(s)` can be written, after clearing denominators, as a
primitive polynomial triple of some finite but unbounded degree.  The mod-11
calculation excludes degrees only through `3`; it says nothing about degree
`4` or higher.

Moreover, this is one codimension-three specialization of
`(U2,U3,U4)`.  A hypothetical generic rational section may have a denominator
or indeterminacy along this specialization, so failure on this slice would
not by itself prove generic pointlessness.  Conversely, a point or special
fibre configuration on this slice would not automatically extend to the
generic parameter space.

Accordingly, neither the Jacobian fibre list nor the bounded section search
proves or disproves a generic section.  No further search is part of this
packet.
