# Exact characteristic-zero model of the genuine Schur twist

## Scope

This packet installs an exact Hilbert--90 frame and a complete coefficient
table for the genuine generic Schur twist.  It is a Q2.0 advance.  It does
not prove that the twist has a rational point or that it is pointless.

Let

\[
G=\operatorname{PSL}_2(\mathbf F_{11}),\quad
E=\mathbf C(\mathbf P(V_6)),\quad K=E^G,
\]

where `V6` is the Schur six-dimensional representation of the double cover.
Let `W5` be the five-dimensional Weil representation with invariant Klein
cubic

\[
F(x)=\sum_{i\in\mathbf Z/5}x_i^2x_{i+1}.
\]

All finite calculations are carried out exactly over
`Q(zeta_11)` and then extended to `C`.

## Exact Reynolds frame

The copied representation core identifies the exact Schur generators with
the exact Weil generators by

```text
A -> TSTS,       B -> T^8 S,
S -> BABAB,      T -> AABABAB.
```

It independently enumerates the 660 elements of the projective group.  For
each `j=0,...,4`, define a degree-eight covariant by

\[
Q_j(v)=\sum_{g\in G}\rho_5(g)^{-1}e_j
              \bigl((\rho_6(g)v)_5\bigr)^8,
\]

and define

\[
I_8(v)=\sum_{g\in G}\bigl((\rho_6(g)v)_5\bigr)^8.
\]

The central involution is invisible because the degree is even and it acts
trivially on `W5`; hence the 660-term projective sum is half of the earlier
1320-term sum.  Direct re-evaluation after both exact generators proves

\[
Q(gv)=\rho_5(g)Q(v),\qquad I_8(gv)=I_8(v).
\]

At

```text
v = (22,2,13,21,22,4)
```

the exact values are serialized in `exact_frame.json`.  Under the good
reduction `(23,zeta_11=2)`, they give

```text
Q(v) = [[ 7,10, 3, 2,12],
        [18,15, 1, 3, 1],
        [17, 4, 0,15, 1],
        [18, 8,10,17,14],
        [ 2,17, 8,16,13]],
det Q(v) = 21,
I8(v) = 10.
```

Thus both exact polynomials are nonzero.  The degree-zero columns
`R_j=Q_j/I8` are five linearly independent elements of

\[
N=(E\otimes W_5)^G.
\]

Galois descent gives `dim_K N=5`, so these columns form a `K`-basis.  This is
an explicit Hilbert--90 frame for the genuine Schur torsor.

## Full descended cubic

Write a vector of the descended space as `R(v)a`, with
`a=[a0:...:a4]` in `P4(K)`.  Since division by `I8^3` does not change the
projective zero locus, the twist has the exact equation

\[
\Phi(a)=F(Q(v)a)=
\sum_i\left(\sum_j Q_{ij}(v)a_j\right)^2
       \left(\sum_j Q_{i+1,j}(v)a_j\right)=0.
\]

`exact_frame.json` contains all 35 coefficients of `Phi`.  Each coefficient
is stored as an exact straight-line expression in the 25 Reynolds entries:
the table has 625 ordered triple products in total.  This is a full
coefficient table, not a sample or a finite jet.  The same file contains the
exact source and target matrices and all 660 group words needed to expand
any entry into source monomials if desired.

The independent verifier reconstructs the two representations, checks exact
invariance of `F`, rebuilds the Reynolds sums at the witness, checks exact
covariance under `S,T`, and independently recreates all 35 table entries.

## Binary boundary

A `K`-point of this displayed cubic is exactly a rational
`G`-equivariant map from `P(V6)` to the Klein cubic.  No such zero of `Phi`
is produced here.  Conversely, the coefficient table supplies no
functorial obstruction to every possible zero.  Therefore

```text
X_Schur(K_Schur) nonempty    NOT PROVED
X_Schur(K_Schur) empty       NOT PROVED
```

The remaining Q2.0 presentation gap is a minimal transcendence-basis and
relations presentation of `K` itself.  The exact frame and full cubic are no
longer missing.
