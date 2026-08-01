# Local infinite descent: exact recurrence and sharp stopping theorem

## Verdict

The stabilizer/normal-cone route does **not** currently close to an
all-degree emptiness theorem.  There is, however, an exact all-order result
which sharply reduces what can still work:

1. the complete symbolic tower at a generic `V4` line has a two-generator
   recurrence, valid in every normal order and every transverse degree;
2. before inverse-character correction, its nonlinear landing locus contains
   a gcd-one characteristic-zero `A4`-equivariant tuple in the
   projective-character model at symbolic order three;
3. this projective-character tuple propagates to every odd symbolic order at
   least three by the recurrence, while the actual `W`-valued correction
   introduces a common inverse-character linear factor;
4. finite point jets can be made zero without killing the generic line state
   by multiplying by common factors, while invariant scalar multiplication
   places any landing class in the `based_minus_lines_odd_m` ledger and makes
   its raw coefficients vanish on the marked source strata;
5. the elliptic trace obstruction is sharp: degree divisible by three is not
   an omitted contradiction, because the marked type-I and type-II triples
   themselves give exact residual-`S3` equivariant degree-three covers.

Consequently, no argument whose input is limited to the generic `V4` normal
cone, its later layers, **unsaturated** finite point-jet conditions, the
unsaturated based-minus-line condition, and the current elliptic trace can
prove

\[
  p\in I^{(m+2)}
\]

from a landing class in `I^(m)/I^(m+2)`.  The missing step remains a
**global nonlinear plane-overlap theorem**, together with any genuinely
saturated/primitive point-link obstruction: it must couple the corrected
order-three line state (and its transported conjugates) to the complete
plus-plane equation after common factors have been removed.  This packet
does not call the surviving local or sheaf-level states covariants.

## 1. Exact all-order `V4` recurrence

At a generic triple line put

\[
 P_x=(y,z),\qquad P_y=(x,z),\qquad P_z=(x,y),
\]

\[
 J_m=P_x^m\cap P_y^m\cap P_z^m,
 \qquad I=J_1=(xy,xz,yz),\qquad h=xyz.
\]

Then, for every `m >= 2`, one has the ideal identity

\[
 \boxed{J_m=hJ_{m-2}+((xy)^m,(xz)^m,(yz)^m).}       \tag{R_m}
\]

Equivalently,

\[
 \boxed{J_m=\sum_{j=0}^{\lfloor m/2\rfloor}
 h^j I^{m-2j}.}                                    \tag{SR_m}
\]

Thus the symbolic Rees algebra is generated over `k[x,y,z]` by

\[
 xy\,u,\quad xz\,u,\quad yz\,u,\quad xyz\,u^2.
\]

This is an `A4`-equivariant statement: the first three generators form the
tetrahedral representation and `xyz u^2` is invariant.

### Proof

A monomial `x^a y^b z^c` belongs to `J_m` exactly when

\[
 b+c\ge m,\qquad a+c\ge m,\qquad a+b\ge m.          \tag{1}
\]

If `a,b,c` are all positive, division by `xyz` changes all three pair sums
by two, so the quotient belongs to `J_(m-2)`.  If one exponent is zero, say
`a=0`, (1) forces `b,c >= m`, and the monomial is divisible by `(yz)^m`.
This proves `R_m`; the reverse inclusion follows immediately from (1).
Iteration gives `SR_m`.

There is also an exact injection on the two-layer symbolic quotients,

\[
 \boxed{
 J_{m-2}/J_m\ \xrightarrow{\ \cdot h\ }\ J_m/J_{m+2}.
 }                                                   \tag{2}
\]

Indeed, `hf` belongs to `J_(m+2)` if and only if `f` belongs to `J_m`,
again by subtracting two from all pair sums.  Formula (2) is the complete
later-layer recurrence which the former first-layer identity did not
provide.

For `m=2r+1`, applying (2) to the first candidate layer recovers

\[
 (J_{2r+1})_{3r+3}=(xyz)^{r-1}(J_3)_6,
\]

but `R_m` controls every later transverse layer as well.

## 2. A gcd-one projective-character landing tuple at `m=3`

The accepted trisection packet identifies either stable `A4` hyperplane
section of the Klein cubic, after a projective character twist, with

\[
 S_B:\quad
 \frac{(B^3-1)^2}{B^3}w^3
 +w(u_0^2+u_1^2+u_2^2)+u_0u_1u_2=0.                \tag{3}
\]

Here `B` is transcendental (or any admissible algebraic specialization).
Precompose the universal trisection with the triangle Cremona map

\[
 [x:y:z]\longmapsto[yz:zx:xy].
\]

Writing `X=yz`, `Y=zx`, `Z=xy`, the resulting tuple is

\[
\begin{aligned}
 w&=-XYZ,\\
 u_0&=X(X^2+BY^2+B^{-1}Z^2),\\
 u_1&=Y(Y^2+BZ^2+B^{-1}X^2),\\
 u_2&=Z(Z^2+BX^2+B^{-1}Y^2).
\end{aligned}                                      \tag{4}
\]

Direct expansion gives (3) identically.  The orders along the three axes
are

```text
w  : (4,4,4)
u0 : (4,3,3)
u1 : (3,4,3)
u2 : (3,3,4).
```

Therefore (4) is a nonzero class in `J_3/J_5`.  Its four components have
gcd one in `Q(B)[x,y,z]`, but this is a primitive statement only in the
projective-character model before inverse-character correction.  It is
`A4`-equivariant in the standard tetrahedral coordinates.  The
one-dimensional projective character discrepancy with the actual
restriction of `W` is removed by multiplying all four components by the
accepted inverse-character line factor.  Hence the actual `W`-valued class
has positive line degree one, acquires that common nonconstant linear factor,
and is **not literally primitive**.

After the character correction this is an exact characteristic-zero,
nonprimitive local landing state.  It is not a global `G`-covariant.

## 3. Every odd order at least three survives locally

For `m=2r+1 >= 3`, define

\[
 p_m=h^{r-1}(w,u_0,u_1,u_2).                       \tag{5}
\]

Since `h` has order two along each of the three axes, `p_m` has exact
symbolic order `m`, transverse degree `3r+3`, and represents a nonzero class
in `J_m/J_(m+2)`.  Cubic homogeneity gives

\[
 F(p_m)=h^{3r-3}F(p_3)=0.                          \tag{6}
\]

For `m>3` this particular propagated state has the displayed local scalar
factor.  At `m=3` the displayed tuple is gcd-one only in the
projective-character model; its actual `W`-valued correction already has the
common inverse-character factor.  This distinction is essential: the
recurrence gives all-order local survivors, not a primitive actual
`W`-valued class or a family of primitive global covariants.

The conclusion is decisive only for the unsaturated local descent: already
at `m=3`, the generic-line nonlinear landing support is nonempty in
characteristic zero.  Later `V4` layers alone cannot eliminate this corrected
nonprimitive state.  This does not rule out a descent argument imposed after
primitive saturation.

## 4. Unsaturated point jets and fixed-order torsion leave local states

Let `Z` be any finite stabilizer-stable subscheme of the representative
triple line, including the three incident `D12` points with any prescribed
finite infinitesimal thickness.  A stabilizer norm gives a nonzero invariant
binary form `delta_Z` vanishing on `Z`.  Replacing (5) by

\[
 \delta_Z^N p_m
\]

for sufficiently large `N` makes every prescribed finite point jet zero,
while it remains nonzero at the generic point of the line and continues to
land because

\[
 F(\delta_Z^N p_m)=\delta_Z^{3N}F(p_m)=0.           \tag{7}
\]

This multiplication argument refutes only **unsaturated** point constraints:
the imposed jet vanishing is carried by a common scalar factor.  After gcd
saturation that factor is cancelled, so this construction does not provide a
primitive class satisfying a saturated point-link condition.  A
saturated/primitive point-link obstruction remains open.

The accepted all-centre compatibility theorem applies this construction
at `m=3`: after imposing zero fat-point data at the `D10` and `D12` orbits
and sufficiently high twist, it produces a nonzero **linear symbolic
section** in the complete nested line/point kernel.  Multiplication by
`h^(r-1)` gives the same generic-line input for every odd `m >= 3`; the
same finite-support/Serre argument applies order by order.

This statement includes zero fat-point data at the level of the unsaturated
linear symbolic kernel, but not a saturated primitive point-link theorem and
not the global nonlinear landing equation: the plane interpolation used to
build the global symbolic section need not preserve (6).  Those are part of
the remaining overlap problem.

Finite irrelevant torsion cannot reinstate a generic-line obstruction.
For each fixed `m`, take the ambient twist beyond the accepted literal/sheaf
comparison bound `d >= 55m+109`; then the literal graded piece equals the
sheaf-level section space.  This is an asymptotic exact statement, not a
claim about the exceptional low degrees.

## 5. The elliptic trace threshold `3 | r` is sharp

Suppose a horizontal component of a gcd divisor has degree `r` and its
successor maps equivariantly to the marked elliptic `E_t`.  The accepted
order-three element acts by translation by nonzero `T in E_t[3]`.  Taking
the elliptic trace gives the necessary condition

\[
 rT=0,
\]

hence `3 | r`.

There is no further contradiction at `r=3` from residual `S3` symmetry or
the marked data.  Choose an origin fixed by a reflection and write

\[
 \rho(P)=P+T,\qquad \sigma(P)=-P.
\]

On the split degree-three cover with sheets `i in Z/3`, let

\[
 \rho(i)=i+1,\qquad\sigma(i)=-i,
 \qquad f(i)=iT.                                   \tag{8}
\]

Then `f` is exactly `S3`-equivariant and its trace is
`0+T+2T=0`.  Its image is the marked type-I triple `<T>`.  Replacing it by

\[
 f_e(i)=e+iT,\qquad 0\ne e\in E_t[2],              \tag{9}
\]

gives the marked type-II triple `e+<T>` and is again equivariant because
`-e=e`.

Thus the degree-divisible-by-three branch is a genuinely live branch of
the trace formalism.  A proof excluding it must use more than the trace and
finite `E[2]` charge labels.

## 6. Based-minus-line scalar saturation

Let `F_src` be the invariant Klein cubic on the source and let `q` be any
homogeneous landing covariant.  For every `N >= 0`,

\[
 p=F_{src}^Nq
\]

is again equivariant and

\[
 F_{tgt}(p)=F_{src}^{3N}F_{tgt}(q)=0.              \tag{10}
\]

For `N>0`, `p` vanishes on every source stratum contained in `X`, in
particular all involution minus-lines and all marked points on the elliptic
slices.  Since a plus-plane is not contained in `X`, multiplication by
`F_src` does not change the generic symbolic plane order.  Therefore the
linear family `based_minus_lines_odd_m` necessarily contains scalar
multiples of every landing class, in arbitrarily high degrees.

This is raw coefficient vanishing, not deletion of the resolved marked
transition of the underlying rational map: after canceling the common
factor `F_src`, that transition is exactly the one carried by `q`.  This is
why scalar saturation must precede any use of the marked ledger.

Conversely, if all components of a global tuple have a common divisor,
the gcd divisor is `G`-stable.  Because `G=PSL(2,11)` has no nontrivial
characters, its defining gcd is invariant up to a constant; dividing it
out preserves `G`-equivariance.  In the polynomial domain, cubic
homogeneity then shows that a scalar multiple lands if and only if its
primitive quotient lands.

Hence a future negative theorem must impose the based/marked conditions
**after saturation by common invariant scalar factors**.  The based ledger
alone is not an obstruction and is not a primitive support condition.

## 7. Exact remaining theorem

The local recurrence, unsaturated point jets, marked elliptic trace, based
family, and irrelevant torsion now leave the following coupled unresolved
issue:

> Decide whether an actual `W`-valued global class can realize the gcd-one
> projective-character `m=3` tuple (4) after inverse-character correction,
> satisfy every saturated/primitive point-link condition, and admit a
> simultaneous global plus-plane lift whose complete cubic coefficients
> vanish; equivalently, decide the nonlinear landing map on the full global
> compatibility fibre after saturation by invariant scalar gcds.

The accepted all-centre construction supplies a compatible linear symbolic
section, but its plane interpolation is not a landing-preserving operation.
Therefore this packet is a stopping theorem for the local infinite-descent
strategy, not a resolution of Goal G.

## Replay

```sh
/opt/homebrew/bin/python3 \
  G_ALL_DEGREE/attacks/local_infinite_descent/verify.py
```

Expected terminal marker:

```text
LOCAL_INFINITE_DESCENT_RECURRENCE_OK
```
