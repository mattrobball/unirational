# Canonical genuine Schur twist

Let

\[
G=\operatorname{PSL}_2(\mathbf F_{11}),\qquad |G|=660,
\]

let `V6` be the six-dimensional Schur module of the double cover, and put

\[
E=\mathbf C(\mathbf P(V_6)),\qquad K=E^G=K_{\rm Schur}.
\]

The projective action is generically free, so `Spec(E) -> Spec(K)` is the
genuine generic `G`-torsor and `trdeg_C(K)=5`.  This field is distinct from
`K_proj=C(P(W5))^G` used by the projective Klein frame.

The target is the honest five-dimensional `G`-module `W5` and the invariant
Klein cubic

\[
F(x)=\sum_{i\in\mathbf Z/5}x_i^2x_{i+1}.
\]

Twisting the pair `(P(W5),X)` by `Spec(E)/Spec(K)` gives an ordinary split
`P4_K` and a smooth cubic threefold `X_Schur={F_T=0}`.  Equivalently, after
a Hilbert--90 frame `A(v)` over `E`, its equation is `F(A(v)z)=0` with
coefficients in `K`.  The immutable arithmetic reconstruction used here is
`imports/q0_ledger.json`.

### Exact Hilbert--90 frame and coefficient table

The child packet `exact_schur_frame/` installs the previously missing exact
frame.  Over `Q(zeta_11)`, it enumerates a canonical 660-element projective
transversal and defines

\[
Q_j(v)=\sum_{g\in G}\rho_5(g)^{-1}e_j
       \bigl((\rho_6(g)v)_5\bigr)^8,
\qquad
I_8(v)=\sum_{g\in G}\bigl((\rho_6(g)v)_5\bigr)^8.
\]

Exact re-evaluation under both generators proves covariance of `Q` and
invariance of `I8`.  At `v=(22,2,13,21,22,4)`, good reduction at
`(23,zeta_11=2)` gives `det(Q)=21` and `I8=10`.  Hence the columns
`Q_j/I8` form a `K`-basis of `(E tensor W5)^G` and are an explicit
Hilbert--90 frame for the genuine Schur torsor.

The same child stores all 35 coefficients of

\[
F(Q(v)a)=\sum_i\left(\sum_jQ_{ij}(v)a_j\right)^2
                 \left(\sum_jQ_{i+1,j}(v)a_j\right)
\]

as a complete exact 625-product straight-line table.  Its independent
verifier reconstructs both representations, all Reynolds sums, exact
covariance, Klein-cubic invariance, the nonzero witness, and every table
entry.

### Remaining presentation boundary

The packet still does not install a minimal generators-and-relations or
transcendence-basis presentation for `K`.  Likewise, the ten fibration
statements below are inherited structural input rather than a machine-replayed
coordinate comparison inside this packet.  The separate
`full_schur_palatinian/` frame gives another birational point gate, not a zero
of this original cubic.  Thus Q2.0 remains partial, but the explicit-frame and
full-coefficient-table gaps are closed.

## Exact degree-55 point

The split Klein cubic has the certified orbit of 55 lines with stabilizer
`D12`.  Intersecting that orbit with a general `K`-hyperplane gives a reduced
effective closed point `Z55` on `X_Schur` with

```text
residue field E^D12
degree 660/12 = 55
Galois closure E
```

This is an actual closed point, not merely a formal cycle class.  A general
linear `P1_K` section independently gives an effective degree-three cycle.

## Effective degree-11 cycle and the residual-quartic gate

For either maximal subgroup `H=A5`, put `L=E^H`.  The two exact
`A5` landing maps have honest three-dimensional source representations, so
their twists give an `L`-point of `X_Schur`.  Since `[L:K]=11`, pushforward
gives an effective zero-cycle `Z11` of degree 11 on the full genuine twist.
Because 11 is prime, either this point descends to `K` or it has exact residue
degree 11.  The construction does not decide that dichotomy.

The new cycle shortens the signed index-one identity to

```text
4 H3 - Z11,  of degree 1.
```

It also creates an exact positive incidence gate.  If the reduced degree-11
orbit lies on a `K`-defined rational normal quartic not contained in the
cubic, Bezout leaves a Galois-invariant residual intersection of degree
`3*4-11=1`.  The child `incidence_splitting/` gives the unique seven-point
quartic and reduces the remaining four membership tests to four explicit
rank-at-most-two conditions.  Its geometric incidence locus has dimension 21
and generic degree 120 over an open subset of `X^7`; no theorem makes this
geometric nonemptiness into a `K`-point.

The packet `degree11_secant_descent_agent/` separately closes this route for
six displayed transferred cycles: all have linear span `P4` and quadric
evaluation rank 11, whereas a rational normal quartic has rank at most 9.
Their four-quadric bases recover exactly the reduced degree-11 orbit on the
cubic, with no extra cubic point.  Their 55 pair secants give a distinct
`D12`-type degree-55 orbit and the exact relation

```text
10[Z11] + [R55] = 55 H3  in CH0(X).
```

These are exact residual and rational-equivalence statements, not a point.

## Coordinate fibrations and original model

For each of the ten coordinate lines in the exact Schur frame, its
intersection with `X_Schur` is a connected degree-three scheme.  Blowing it
up and projecting gives a genus-one fibration over `P2_K`; its generic fibre
has period and index three.  These ten fibrations have no section, but they
do not cover all possible rational points of the proper threefold.

## Generic-twist bridge

A `K`-point of `X_Schur` is the same descent datum as a rational
`G`-equivariant map from the generic Schur projective source to `X`.  Any
positive exit must supply such a point/map and verify the original cubic
identity.  Conversely, a negative exit needs a functorial obstruction on the
full proper twist, not on one coordinate fibration or an auxiliary plane
cubic.

No such point or full obstruction is installed in this packet.
