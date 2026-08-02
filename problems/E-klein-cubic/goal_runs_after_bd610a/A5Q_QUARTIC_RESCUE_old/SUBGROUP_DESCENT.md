# A5Q.0 subgroup descent and fixed-field interface

## Scope and present status

This note fixes the exact construction for both conjugacy classes of maximal
`A_5` subgroups.  The fixed fields and their primitive resolvents are
certified below.  The exact transport formulas are now paired with raw
nonvanishing, free-locus, cubic-landing, and projective-separation witnesses
at `p=89`, plus an unused `p=199` holdout, in
`modular_index11_discovery.json`.  The good-reduction argument in
`CHARACTERISTIC_ZERO_LIFT.md` lifts the recorded nonzero minors to the exact
characteristic-zero rational functions.

Thus this note proves the A5Q.0 index-eleven closed-point package.  Its exit
is strictly scoped: it does not assert a `K`-point, a quartic interpolation,
a residual point, a rational curve, or a Problem E headline.

## 1. The two fixed fields

Let

\[
G=\operatorname{PSL}_2(\mathbf F_{11}),\qquad
E=\mathbf C(\mathbf P(V_6)),\qquad K=E^G,
\]

where `V6` is the installed six-dimensional Schur module.  The central
involution of the Schur cover acts by a scalar, so its action on
`P(V6)` and on `E` is the honest `G`-action.  Let `H_1,H_2` be exactly the
records `A5_class_1,A5_class_2` in

```text
goals_2026-08-01/H_SUBGROUP_TWISTS_ROOT_019FBE10/twists.json.
```

The installed enumeration gives

\[
|G|=660,\qquad |H_i|=60,
\]

and `H_1,H_2` are the two conjugacy classes of maximal `A_5` subgroups.
Put

\[
L_i=E^{H_i}.
\]

Then `E/L_i` is the induced generic `H_i`-torsor and
`[L_i:K]=[G:H_i]=11`.  This definition binds the field to the full Schur
torsor; it is not the abstract invariant field from the earlier `A_5`
packet.

## 2. Exact primitive elements

Use the following linear forms and even exponents:

```text
ell_1(v) = 2*v0 + 3*v1 + 5*v2 + 7*v3 + 11*v4 + 13*v5,  d_1=18,
ell_2(v) = v0,                                             d_2=8.
```

For `i=1,2`, define

\[
N_i(v)=\sum_{h\in H_i}\ell_i(\rho _6(h)v)^{d_i},\qquad
D_i(v)=\sum_{g\in G}\ell_i(\rho _6(g)v)^{d_i},\qquad
\tau_i=N_i/D_i.                                           \tag{2.1}
\]

The same `ell_i,d_i` are used in the numerator and denominator.  Since
`d_i` is even, changing any Schur lift by the central sign changes neither
sum.  Reindexing `h` by `hk` shows `N_i(kv)=N_i(v)` for `k in H_i`, and
reindexing `g` by `gk` shows `D_i(kv)=D_i(v)` for every `k in G`.
Therefore `tau_i` is a well-defined element of `E^{H_i}=L_i` on `D_i!=0`.

Choose left-coset representatives for `H_i\G`.  With the evaluation
convention in (2.1), the conjugates are

\[
\tau_{i,H_i g}(v)=\tau_i(\rho _6(g)v),
\]

which is independent of the representative of the left coset.  Define the
exact lazy resolvent

\[
p_i(T)=\prod_{H_i g\in H_i\backslash G}
       \bigl(T-\tau_i(\rho _6(g)v)\bigr).                 \tag{2.2}
\]

The group permutes the factors, hence every coefficient of `p_i` lies in
`K`.  No expansion of the 660-sheeted Galois field is involved.

### The characteristic-23 certificate

Reduce the installed matrices at `p=23`, take `zeta_11=2`, and specialize

```text
v*=(22,2,13,21,22,4).
```

The audited values are:

| class | `D_i(v*)` | values of `N_i(g v*)` | sorted values of `tau_i(g v*)` | `disc(p_i) mod 23` |
|---|---:|---|---|---:|
| 1 | 11 | `0,1,2,3,11,15,16,17,18,21,22` | `0,1,2,4,10,12,14,16,17,19,21` | 16 |
| 2 | 7 | `3,5,7,8,9,11,12,14,16,17,20` | `1,2,4,5,7,9,11,16,18,21,22` | 18 |

The numerator lists are the eleven coset values; the root lists are sorted
multisets after division by `D_i(v*)`.  Both denominators and both
discriminants are nonzero.  The corresponding monic coefficient lists, in
the order `T^11,T^10,...,T,1`, are

```text
class 1: 1,22,5,21,21,12,0,7,3,3,20,0
class 2: 1,22,8,5,16,15,5,13,21,19,18,18.
```

Thus all eleven conjugate rational functions in (2.2) are distinct in
characteristic zero: equality of two of them would survive every good
specialization where both are defined.  Hence the stabilizer of `tau_i` is
exactly `H_i`, `K(tau_i)=L_i`, and `p_i` is the separable irreducible
degree-eleven minimal polynomial.  This proves the fixed-field part of
A5Q.0 for both classes.

## 3. Replay without the full Galois closure

Write

\[
p_i(T)=T^{11}+c_{i,10}T^{10}+\cdots+c_{i,1}T+c_{i,0}.
\]

Use the power basis

```text
1,tau_i,tau_i^2,...,tau_i^10.
```

With column-coordinate convention, multiplication by `tau_i` is the
companion matrix `C_i` determined by

```text
C_i[j+1,j] = 1                              for 0 <= j < 10,
C_i[r,10]  = -c_{i,r}                       for 0 <= r <= 10,
all other entries are zero.
```

For `a=sum_r a_r*tau_i^r`, define

```text
M_i(a)=sum_r a_r*C_i^r.
```

Then field multiplication is the matrix-vector product `M_i(a)b`, and

```text
Tr_{L_i/K}(a) = trace(M_i(a)),
Nm_{L_i/K}(a) = det(M_i(a)).
```

Inversion is one exact linear solve `M_i(a)u=e_0`, when the determinant is
nonzero.  Equivalently, traces and norms are the sum and product of the
eleven coset evaluations.  To convert any `H_i`-invariant rational function
`a` to the power basis, evaluate its eleven conjugates `a(gv)` and solve the
Vandermonde system

\[
\sum_{j=0}^{10}a_j\tau_{i,H_i g}^{j}=a(\rho _6(g)v).
\]

The discriminant in Section 2 proves that this system is generically
invertible.  All its solution coefficients are `G`-invariant, hence lie in
`K`.  This is the promised straight-line field interface.

## 4. Polynomial Reynolds specialization of the versal source

Let `sigma_i:H_i -> GL(V_{3,i})` be the honest icosahedral representation
specified by the installed twist record, and let `e_0=(1,0,0)^t`.  The
specialization is made with the **degree-four polynomial** Reynolds frame

\[
B_i(v)=\sum_{h\in H_i}\sigma_i(h)^{-1}
                    \bigl((\rho _6(h)v)_5\bigr)^4,
\qquad Y_i(v)=B_i(v)e_0.                              \tag{4.1}
\]

Here the scalar in (4.1) multiplies the `3 x 3` matrix
`sigma_i(h)^(-1)`.  This is not the degree-zero rational alternative used
in the preliminary audit.

For `k in H_i`, set `u=hk`.  Then

\[
\begin{aligned}
B_i(kv)
 &=\sum_h\sigma_i(h)^{-1}((\rho_6(hk)v)_5)^4\\
 &=\sum_u\sigma_i(uk^{-1})^{-1}((\rho_6(u)v)_5)^4\\
 &=\sigma_i(k)B_i(v).
\end{aligned}
\]

The fourth power again removes Schur-lift signs.  Consequently

\[
Y_i(kv)=\sigma_i(k)Y_i(v).                            \tag{4.2}
\]

On the open set where `Y_i` is nonzero and has trivial projective
stabilizer, (4.2) gives an `H_i`-equivariant map from the specific torsor
`E/L_i` to the free locus in the versal icosahedral three-space.  Passing to
the quotient identifies `E/L_i` with the pullback specialization of the
versal `A_5` torsor used by the point packet.

The class records in `modular_index11_discovery.json` exhibit this open set:
at the `p=89` witnesses they have nonzero `det(B_i)` and projective source
stabilizer of order one.  The same gates pass independently at the unused
`p=199` holdout.  Since the stored determinants and nonidentity projective
minors are reductions of the exact straight-line expressions, their
nonzero reductions prove that the characteristic-zero open is nonempty.
Thus the required specialization of the specific torsor is established,
not merely postulated.

## 5. Transport to the authoritative full twist

Let `Phi_i` be the exact degree-eleven polynomial covariant in
`H_A5_TWISTS/A5_class_i/point.json`.  Denote its target representation by
`r_i`, and let `J_i` be the installed constant intertwiner, with conventions

\[
\Phi_i(\sigma_i(k)y)=r_i(k)\Phi_i(y),\qquad
J_i r_i(k)=\rho_5(k)J_i.                              \tag{5.1}
\]

Define

\[
x_i(v)=J_i\Phi_i(Y_i(v)),\qquad
P_i(v)=Q(v)^{-1}x_i(v),                               \tag{5.2}
\]

where the authoritative full Schur frame is

\[
Q(v)=\sum_{g\in G}\rho_5(g)^{-1}
                   \bigl((\rho_6(g)v)_5\bigr)^8.
\]

The same reindexing as above gives `Q(kv)=rho_5(k)Q(v)`.  Combining
(4.2), (5.1), and (5.2) gives the exact covariance chain

```text
x_i(kv) = rho_5(k)*x_i(v),
P_i(kv) = Q(kv)^(-1)*x_i(kv) = P_i(v)       (k in H_i).
```

Therefore, wherever `det(Q)` and the relevant projective coordinate are
nonzero, the coordinate ratios of `P_i` lie in `E^{H_i}=L_i`.  The upstream
landing identity and target intertwiner give

\[
F(QP_i)=F(x_i)=0,
\]

so a defined nonzero `P_i` is a point of the authoritative full twist
`X_T(L_i)`.

There are three unrelated degrees here and they must not be conflated:

- `B_i` has polynomial degree 4;
- `Phi_i` has polynomial degree 11 in its three source variables;
- the field/residue degree 11 is `[G:H_i]`, certified by the resolvent
  (2.2), and does **not** follow from the polynomial degree of `Phi_i`.

## 6. Modular certificate and characteristic-zero conclusion

The raw certificate is

```text
modular_index11_discovery.json
```

and is regenerated from the retained exact inputs by
`discover_modular_index11.py`.  It reconstructs `G`, both `H_i`, the
representations `rho_6,rho_5,sigma_i`, the intertwiners `J_i`, the quartic
frames `B_i`, the full frame `Q`, and all eleven rows

\[
P_{i,r}=Q(v)^{-1}\rho_5(g_r)^{-1}
        J_i\Phi_i(Y_i(\rho_6(g_r)v))                  \tag{6.1}
\]

in one common descended frame.  It stores the matrices, denominators,
coset representatives, point rows, rank minors, and a nonzero projective
minor for every pair of rows; its replay marker is
`A5Q_MODULAR_INDEX11_DISCOVERY_REPLAY_OK`.

The decisive summarized values are:

| prime and role | class | witness | `det B_i` | `det Q` | `det J_i` | source stabilizer | coordinate rank | product rank |
|---|---|---|---:|---:|---:|---:|---:|---:|
| 89, discovery | 1 | `(22,2,13,21,22,4)` | 55 | 86 | 57 | 1 | 5 | 11 |
| 89, discovery | 2 | `(71,10,17,18,13,44)` | 78 | 12 | 62 | 1 | 5 | 11 |
| 199, unused holdout | 1 | `(22,2,13,21,22,4)` | 55 | 179 | 3 | 1 | 5 | 11 |
| 199, unused holdout | 2 | `(1,1,2,3,5,8)` | 181 | 167 | 136 | 1 | 5 | 11 |

For every row of the table, the result also records that all rational input
denominators are nonzero, all eleven canonical and installed cubic landings
vanish, and the eleven full-twist rows (6.1) are pairwise projectively
distinct.  At `p=89`, the products of the 55 recorded noncollision minors
are respectively `45` and `33`; at the `p=199` holdout they are `6` and
`51`.  These are raw nonzero witnesses, not unproved success flags.

The covariance and cubic equalities in Sections 4 and 5 hold exactly by
reindexing and the retained characteristic-zero landing identity.  The
good-reduction lemma in `CHARACTERISTIC_ZERO_LIFT.md` says that each nonzero
specialized determinant or minor is the reduction of a nonzero exact
rational function.  It follows that `B_i,Y_i,x_i,Q,P_i` are defined on a
nonempty characteristic-zero open, `P_i` lies on `X_T(L_i)`, and the eleven
conjugates of `P_i` remain pairwise projectively distinct.

The last assertion is essential.  The primitive `tau_i` proves
`[L_i:K]=11`, while projective separation proves that the coordinate field
of `P_i` is all of `L_i` rather than `K`.  Therefore the scheme-theoretic
image

\[
\operatorname{Spec}(L_i)\longrightarrow X_T
\]

is a closed point of degree eleven.  Since `L_i/K` is separable in
characteristic zero, this closed point is reduced.  This conclusion holds
for both maximal `A_5` classes.

The A5Q.0 marker and its matching scoped exit are therefore:

```text
A5Q_INDEX11_CLOSED_POINT_OK
A5Q-INDEX11-CLOSED-POINT-PASS
```

No residual-point or rational-curve headline is claimed here.
