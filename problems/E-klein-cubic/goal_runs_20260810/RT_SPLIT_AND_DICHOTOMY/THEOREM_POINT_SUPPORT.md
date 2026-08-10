# Point support and the surviving free-orbit escape

## 1. Degree/orbit accounting comes first

Let the primitive ambient landing tuple have degree `d`.  For irreducible
components of the base scheme of codimension `c`, refined Bézout with `c`
general members gives the conservative bounds
\[
\sum_{\operatorname{codim}Z=2}\deg Z\le d^2,
\qquad
\sum_{\operatorname{codim}Z=3}\deg Z\le d^3,
\tag{1.1}
\]
and, after removing the positive-dimensional components, the residual
zero-dimensional length is at most
\[
\operatorname{length}B_0\le d^4.
\tag{1.2}
\]
The exact orbit table and its scope are in `DEGREE_ACCOUNTING.md`.

The current unconditional no-map range ends at `d=30`; therefore the
conservative live window is
\[
d\ge31.
\tag{1.3}
\]
Every orbit-size/codimension cell requested in the work order survives (1.1)
--(1.3), including a free orbit of 660 surface components.  Hence the exit
`FREE-SUPPORT-EXCLUDED` is unavailable.

There is a second limitation: a strict support in the decomposition theorem
need not be an irreducible component of the base scheme.  It may be a smaller
stratum lying inside a positive-dimensional component.  Bézout component
bounds do not count arbitrary collections of such subvarieties.  This only
strengthens the surviving escape.

## 2. The point perverse degree is forced

Let
\[
p:Y\to\mathbf P^4
\]
be the ambient normalized graph.  A perverse Hodge module with support equal
to a point `x` has global hypercohomology only in degree zero.  Its ambient
contribution to `(AHS)` is
\[
H^{-1-j_0}(\mathbf P^4,\mathcal M_{x,j_0})(1).
\]
Therefore a point-supported copy of `V` forces
\[
-1-j_0=0,
\qquad
\boxed{j_0=-1.}
\tag{2.1}
\]
This is exactly the channel missed by the Artin injection in Task 2.

## 3. Fiber-cohomology characterization

Put
\[
H=\operatorname{Stab}_G(x),
\qquad
Y_x=p^{-1}(x).
\]
Proper base change identifies the stalk of `Rp_*IC_Y^H` with
\[
R\Gamma(Y_x,IC_Y^H).
\]
A point strict-support summand of `{}^pH^{-1}` therefore yields a pure
weight-three `H`-Hodge substructure
\[
W_x\subset H^{-1}(Y_x,IC_Y^H)
\tag{3.1}
\]
satisfying
\[
\boxed{
\operatorname{Hom}_{H\text{-HS}}
\left(\operatorname{Res}^G_HV,W_x(1)\right)\ne0.
}
\tag{3.2}
\]
If `Y` is smooth near `Y_x`, then `IC_Y^H=Q_Y^H[4]` there and (3.1) becomes
\[
W_x\subset H^3(Y_x,\mathbf Q).
\tag{3.3}
\]
Without that smoothness hypothesis, (3.1), not ordinary fiber cohomology, is
the correct statement.

Let
\[
q_x:Y_x\longrightarrow X
\]
be the target map and set
\[
Z_x=q_x(Y_x).
\]
Properness implies that `q_x` maps **onto** the closed target-limit subvariety
`Z_x`.  Nothing in the point-support argument makes `q_x` finite,
generically finite, or equidimensional.  In particular the required
weight-three Hodge structure may be carried by higher-dimensional fibers or
intersection cohomology, not by the ordinary `H^1` of a target curve.

For a free point orbit, `H=1`, so (3.2) imposes a Hodge occurrence but no
nontrivial stabilizer-representation obstruction.

## 4. Exit

```text
POINT-SUPPORT-CHARACTERIZED
SUPPORT-ESCAPE-UNDECIDED
```

The exact surviving cells are all cells in `DEGREE_ACCOUNTING.md` for
`d>=31`; there is no live cell table with a Bézout death.
