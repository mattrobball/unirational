# All-order first-plane landing gate

## Theorem

Fix one involution `t` and split

\[
W=E_+(t)\oplus E_-(t),\qquad (\dim E_+,\dim E_-)=(3,2).
\]

Let a homogeneous landing covariant have true odd order `m` along the
plus-plane `P(E_+)`.  In the completed normal filtration write its first two
parity-allowed terms as

\[
p=a_m+b_{m+1}+a_{m+2}+\cdots,
\]

with `a_i` valued in `E_-` for odd `i` and `b_i` valued in `E_+` for even
`i`.  Choose a basis of `E_-` and write

\[
a_m=Ae_0+Be_1.
\]

In the factorial Cox ring of
`P(E_+) x P(E_-)`, write

\[
A=q a,\qquad B=q b,\qquad \gcd(a,b)=1,
\]

after stripping vertical scalar factors.

Then:

1. after one constant change of the `E_+` basis, the coefficient of normal
   order `3m+1` in `F(p)` is

   \[
   q^2(a^2C_0+abC_1+b^2C_2),
   \]

   where `C` is the coordinate vector of `b_(m+1)`;
2. the landing identity forces

   \[
   C=(bU,-aU+bV,-aV),
   \]

   up to harmless signs and a constant target-basis change; in particular
   `b_(m+1)` belongs to `(a,b)E_+`;
3. on every horizontal component of `V(q)` where `b_(m+1)` is generically
   nonzero, the order-`3m+3` identity forces

   \[
   F(b_{m+1})=0.
   \]

   Hence the projectivized successor defines a rational equivariant map from
   that component to the fixed elliptic cubic
   `E_t=X cap P(E_+)`.

This holds for every odd `m`; it is not an extrapolation from `m=3`.

## Proof

The involution parity puts `a_m` in `E_-` and `b_(m+1)` in `E_+`.
The restriction of the Klein cubic to `E_-` is zero.  Its mixed gradient is
the constant map

\[
\mu:\operatorname{Sym}^2E_-\longrightarrow E_+^*,\qquad
v^2\longmapsto 3\Phi(v,v,-)|_{E_+}.
\]

The exact good-reduction matrices have determinants `9 mod 67` and
`46 mod 89`, so `mu` is an isomorphism in characteristic zero.  Therefore
the first nonautomatic coefficient is the quadratic-Veronese row
`(A^2,AB,B^2)`.

After canceling `q^2`, the Hilbert--Burch resolution of
`(a^2,ab,b^2)` gives the two syzygies

\[
(b,-a,0),\qquad(0,b,-a).
\]

This proves item 2 in every projective local ring; irrelevant saturation
cannot introduce a nonzero value on `V(a,b)`.

On `V(q)`, the odd leading term `a_m` vanishes.  At normal order `3m+3`,
every term other than `F(b_(m+1))` either contains `a_m` and hence a factor
`q`, or is an all-`E_-` polarization and vanishes identically.  Reduction
modulo `q` proves item 3.

## Finite-trace consequence

The effective stabilizer on the fixed elliptic cubic is

\[
C_G(t)/\langle t\rangle\simeq S_3.
\]

Its order-three subgroup acts on `E_t` by translation by a nonzero
`T in E_t[3]`.  Let `D^x` be a stabilizer-stable union of horizontal
components of `V(q)` on which the successor map is generically nonzero, and
let `r_x` be its generic degree over `P(E_+)`.  Taking the elliptic trace of
the resulting degree-`r_x` point gives a rational map
`P^2 -> E_t`, hence a constant.  Equivariance translates that trace by
`r_x T`.  Consequently

\[
3\mid r_x.
\]

Thus every all-degree landing state lies in one of two strictly smaller
first-gate loci:

- the primitive locus, where the successor vanishes on `V(a,b)`; or
- a divisorial-gcd locus whose generically nonzero mapped part has horizontal
  degree divisible by three.

For the installed Fable order-three/order-four boundary the mapped divisor
has degree two, so this theorem recovers its trace obstruction.  In general,
the primitive locus and degrees divisible by three remain possible; this
theorem alone is not an all-degree emptiness proof.

## Triple-line recurrence at the first surviving layer

At a generic `V4` triple line use the monomial normal form

\[
J_m=(y,z)^m\cap(x,z)^m\cap(x,y)^m.
\]

For `m=2r+1 >= 3`, the minimum layer has total transverse degree `3r+2`
and is already excluded by the accepted Klein gate.  The next layer obeys
the exact identity

\[
(J_{2r+1})_{3r+3}
=(xyz)^{r-1}(J_3)_6.
\]

Indeed a monomial `x^a y^b z^c` in the left side satisfies
`a,b,c <= r+2` and `a+b+c=3r+3`, hence every exponent is at least `r-1`.
After subtracting `(r-1,r-1,r-1)`, the three symbolic inequalities become
the order-three inequalities and the total degree becomes six.  The reverse
inclusion is immediate.

This identifies the first post-minimum triple-line source in every odd
order with the installed `m=3` source up to a forced scalar factor.  It does
not identify the higher line layers, where new monomials occur.

The companion `verify_line_constant.py` independently reconstructs the
line-degree-zero systems at `(m,n)=(1,3)` and `(3,6)` from the authoritative
Reynolds matrices.  On every projective coefficient chart it obtains the
unit ideal over `F_67`, so properness excludes characteristic-zero points in
those two literal finite systems.  This certifies the constant boundary used
by the recurrence; it does not exclude positive line degree or any later
layer.

## Geometric emptiness of the line-constant first layer

There is one further exact consequence.  Restrict first to coefficients
which are constant along the representative triple line.  Reynolds
projection for its `A4` stabilizer gives a projective parameter line for
`m=1` and a projective parameter plane for `m=3`.  In filtered-product
monomial order, the coefficient ideals of the Klein equation over
`F_67` have row matrices

```text
m=1:
[1 13  0 53]
[0  1 61  0]
[0  0  1  0]

m=3:
[1 13  0 53  0 24 47 14  0 59]
[0  1 61  0 31 11 50 32  9  0]
[0  0  0  0  0  1  0  0  0  0]
[0  0  1  0  6  0  0  0 32  0]
```

These are not sampled values.  They are row bases for every coefficient of
`F(p)`.  Groebner reduction after setting each parameter in turn equal to
one gives the unit ideal on every standard projective chart.  Hence both
projective schemes are geometrically empty over `F_67`.

The representation and invariant spaces are direct summands over the DVR
at a prime above 67, because `67` does not divide `|G|=660`.  Projectivity of
the parameter space then gives the good-reduction transfer: a
characteristic-zero point would specialize, after finite base extension,
to a geometric point in the empty special fibre.  Thus the two
line-constant schemes are empty in characteristic zero as well.

Since `xyz` is invariant under the tetrahedral transverse action, the
recurrence above identifies the line-constant landing equation for every
`m=2r+1 >= 3` with the `m=3` equation, multiplied by
`(xyz)^(3r-3)`.  Consequently:

> For every odd symbolic order, the first transverse layer which survives
> the linear common-line gate contains no nonzero landing state whose
> coefficient is constant along the triple line.

This is an all-order theorem, but it is deliberately narrower than the
desired all-degree theorem.  Positive line degree tensors the transverse
source with binary forms on the line; it is not controlled by the
line-constant unit certificate.  The installed computations in line degrees
one through four are rank/search data only and are not promoted to
emptiness.
