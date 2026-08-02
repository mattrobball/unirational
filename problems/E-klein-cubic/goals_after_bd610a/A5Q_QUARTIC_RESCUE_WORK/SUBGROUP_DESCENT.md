# Exact subgroup-to-full-twist descent

## Objects and conventions

Let

\[
G=\operatorname {PSL}_2(\mathbf F_{11}),\qquad
E=\mathbf C(\mathbf P(V_6)),\qquad K=E^G,
\]

where `V6` is the authoritative six-dimensional Schur module.  Its central
involution acts by a scalar, so the action on `P(V6)` and on `E` is an honest
`G`-action.  For the two sealed maximal subgroups `H_i` in
`H_SUBGROUP_TWISTS_ROOT_019FBE10/twists.json`, put

\[
L_i=E^{H_i}.
\]

The exact enumeration gives `|G|=660`, `|H_i|=60`, and eleven left cosets.
Thus `L_i/K` is separable of degree eleven.  This is the specific
fixed-field extension of the full Schur torsor, not the abstract invariant
field used in the earlier `A5` point packet.

The full Schur packet supplies the exact degree-eight Reynolds frame

\[
Q(v)\in\operatorname {Mat}_{5\times5}(E),\qquad
Q(gv)=\rho_5(g)Q(v),
\]

whose determinant is nonzero.  In descended coordinates the authoritative
twist is

\[
X_T:\quad F(Q(v)a)=0,
\qquad F(x)=\sum_{j\in\mathbf Z/5}x_j^2x_{j+1}.
\]

## Specializing the versal `A5` source

For each class let `sigma_i` be the honest icosahedral three-dimensional
representation obtained from the exact map `H_i -> A5`.  The producer defines
the degree-four Reynolds frame

\[
B_i(v)=\sum_{h\in H_i}
 \sigma_i(h)^{-1}\bigl((\widetilde\rho _6(h)v)_5\bigr)^4,
\qquad Y_i(v)=B_i(v)e_0,
\tag{1}
\]

where the scalar in the sum multiplies the displayed `3 x 3` matrix.
Formula (1) is an exact straight-line formula over the compositum of the
sealed constant fields.  Signs in the projective Schur lift disappear because
the seed degree is even.
Replacing `h` by `hk` proves directly that

\[
B_i(kv)=\sigma_i(k)B_i(v),\qquad
Y_i(kv)=\sigma_i(k)Y_i(v)\qquad(k\in H_i).
\tag{2}
\]

The good-reduction witness verifies `det(B_i) != 0`; it also verifies that
`Y_i` has projective `H_i`-orbit of size 60.  Hence the generic frame is
invertible and its first column is in the free locus of `P^2`.  Equation (2)
therefore identifies the `H_i`-torsor `E/L_i` with the pullback, at this
explicit `L_i`-point of the quotient, of the versal icosahedral torsor used by
the point packet.  This supplies the field comparison that was absent from
the subgroup result itself.

## Transporting the sealed landing maps

Let

\[
\Phi_i:\mathbf P^2\dashrightarrow X
\]

be the selected exact degree-eleven Reynolds landing map in
`H_A5_TWISTS/A5_class_i/point.json`, and let `J_i` be the exact constant
intertwiner from the rational augmentation target to the installed Weil
target.  Put

\[
\Psi_i(v)=J_i\Phi_i(Y_i(v)),\qquad
P_i(v)=Q(v)^{-1}\Psi_i(v).
\tag{3}
\]

The sealed landing identity gives `F(Psi_i)=0` identically.  Exact
intertwining, (2), and covariance of `Q` give

\[
\Psi_i(hv)=\rho_5(h)\Psi_i(v),\qquad P_i(hv)=P_i(v).
\]

Thus the five projective coordinates in (3) are `H_i`-invariant ratios and
define

\[
P_i\in X_T(L_i).
\]

Substitution in the full twist is structural and exact:

\[
F(QP_i)=F(\Psi_i)=0.
\tag{4}
\]

The independent replay also reconstructs (4) at good reduction rather than
reading a stored landing flag.

## Residue degree and reduced closed points

Choose the eleven recorded left-coset representatives `g_r`.  Over `E`, the
conjugates of (3), all expressed in the one descended frame `Q(v)`, are

\[
P_{i,r}(v)=Q(v)^{-1}\rho_5(g_r)^{-1}
             J_i\Phi_i(Y_i(g_rv)).
\tag{5}
\]

The modular certificate reconstructs the eleven rows (5) and exhibits a
nonzero `11 x 11` minor of their quadratic Veronese evaluation matrix.  A
nonzero reduction of that exact straight-line minor proves that it is
nonzero in characteristic zero.  In particular the eleven projective points
in (5) are pairwise distinct.  Since `H_i` is maximal, the projective
stabilizer of `P_i` is exactly `H_i`, not `G`.  Consequently the
scheme-theoretic image

\[
Z_i=\operatorname {Spec}(L_i)\longrightarrow X_T
\]

is a reduced effective closed point of degree eleven.

## Fixed-field replay interface

`FIELD_L1.json` and `FIELD_L2.json` record a projective coordinate ratio
`tau_i` whose eleven values in (5) are distinct at good reduction.  Hence
`tau_i` is primitive.  The exact lazy resolvent is

\[
g_i(S,T)=\prod_{r=1}^{11}(S-\tau_i^{g_r}T)\in K[S,T].
\]

Its coefficients are invariant because `G` permutes the cosets.  The same
files specify trace and norm as the orbit sum and product, and multiplication
by `tau_i` as the companion matrix of `g_i(T,1)` in
`1,tau_i,...,tau_i^10`.  Coordinates of `P_i` in that basis are reconstructed
without expanding `E/K` by the recorded orbit/Lagrange formula.  Only the
eleven cosets are needed; no 660-dimensional expansion of the Galois closure
is used.

Therefore the required marker is established for both classes:

```text
A5Q_INDEX11_CLOSED_POINT_OK
```
