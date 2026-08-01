# Exact target invariants

Let

\[
X=\left\{\sum_{i\in\mathbf Z/5}x_i^2x_{i+1}=0\right\}
\subset\mathbf P(W)\simeq\mathbf P^4,
\qquad G=\operatorname{PSL}_2(\mathbf F_{11}).
\]

All statements below are over \(\mathbf C\), except the explicitly stated
torsor-twist and coefficient assertions.

## 1. Integral cohomology and Hodge structure

The integral cohomology is torsion-free, with Betti numbers

\[
(b_0,\ldots,b_6)=(1,0,1,10,1,0,1).
\]

The only non-Tate part is

\[
H^3(X,\mathbf Z),\qquad \operatorname{rank}=10,
\]

with

\[
h^{2,1}=h^{1,2}=5.
\]

The Jacobian-ring calculation gives

\[
H^{2,1}(X)\simeq W^*,\qquad H^{1,2}(X)\simeq W
\]

as complex \(G\)-representations. Over \(\mathbf Q\), these conjugate
five-dimensional representations form the ten-dimensional rational
\(G\)-module carried by \(H^3\).

## 2. Chow groups and middle motive

With a line on \(X\) chosen, the cycle-class and Abel--Jacobi descriptions
are

\[
\operatorname{CH}^0(X)=\mathbf Z,
\qquad \operatorname{Pic}(X)=\mathbf Z[H],
\]

\[
\operatorname{CH}^2(X)\simeq
\mathbf Z[\ell]\oplus A^2(X),
\qquad A^2(X)\simeq J(X)(\mathbf C),
\]

and \(\operatorname{CH}^3(X)=\mathbf Z[\mathrm{pt}]\). The rational motive is

\[
h(X)_{\mathbf Q}\simeq
\mathbf1\oplus\mathbf L\oplus h^1(J(X))(1)
\oplus\mathbf L^2\oplus\mathbf L^3.
\]

Thus the only candidate non-Tate motivic obstruction is the middle
intermediate-Jacobian factor. BLOWUP_CLOSURE.md constructs that factor from a
curve centre.

## 3. Chern and characteristic numbers

Adjunction gives

\[
c(T_X)=\frac{(1+H)^5}{1+3H}
=1+2H+4H^2-2H^3,
\qquad \int_XH^3=3.
\]

Therefore:

| invariant | value |
|---|---:|
| \(c_1^3\) | \(24\) |
| \(c_1c_2\) | \(24\) |
| \(c_3=e(X)\) | \(-6\) |
| \(p_1=c_1^2-2c_2\) | \(-4H^2\) |
| \(s_3=c_1^3-3c_1c_2+3c_3\) | \(-66\) |
| \(\chi(\mathcal O_X)=c_1c_2/24\) | \(1\) |

For Merkurjev's \(p=2\) additive class in dimension three,
\(\deg c_{(3)}(-T_X)=66\), hence the half-number is \(33\). On any torsor
twist it defines the zero class because the target group is

\[
\mathbf Z/\operatorname{ind}(X_T)\mathbf Z
=\mathbf Z/1\mathbf Z.
\]

Equivariantly,

\[
c_G(T_X)=\frac{c_G(W\otimes\mathcal O_X(1))}{1+3H}.
\]

This formula retains the full integral representation-theoretic Chern input;
no nonequivariant substitution is passed off as an equivariant calculation.

## 4. Primary Steenrod operations

Because integral cohomology is torsion-free, all Bocksteins of reductions of
integral classes vanish.

On the primitive middle group \(H^3(X,\mathbf F_p)\):

- \(Sq^1=0\);
- \(Sq^2=0\), since \(H^5(X,\mathbf F_2)=0\);
- \(Sq^3(a)=a^2=0\), because every class lifts integrally and the square of an
  odd-degree integral class is zero in the torsion-free group
  \(H^6(X,\mathbf Z)\);
- all odd-primary reduced powers vanish for dimensional reasons.

The Tate part has the expected ambient operation. In particular,

\[
Sq^2(\bar H)=\bar H^2\ne0\qquad(p=2),
\]

whereas

\[
P^1(\bar H)=\bar H^3=3[\mathrm{pt}]=0\qquad(p=3).
\]

There is therefore no nonzero primary Steenrod signature on primitive
\(H^3\) for a blowup-closure argument to exclude. This does not assert that
the integral lattice embedding in BLOWUP_CLOSURE.md is a map of Steenrod
modules. Such a mod-\(p\) map is not forced by the relative-dimension-one
bridge when \(p\mid n\).

## 5. Fixed points and localization boundary

The installed subgroup census and tangent characters remain the authoritative
fixed-point payload. They cannot be evaluated only on the original source:
every equivariant resolution introduces exceptional fixed components and
normal characters. Localization also inverts Euler classes, while the desired
conclusion is integral. Accordingly no fixed-point numerator in this packet is
claimed to survive all exceptional corrections.

## 6. Twist index and quotient-stack data

Every twist has effective zero-cycles of degrees

\[
60,132,165,220.
\]

Their gcd is one, certified by

\[
-13\cdot60+3\cdot132+165+220=1.
\]

The split ambient space also supplies a degree-three linear section. The
hyperplane class is honestly linearized, so the universal-torsor and
higher-Amitsur branches vanish. Prime-local essential dimensions are

\[
\operatorname{ed}(G;2)=2,
\qquad
\operatorname{ed}(G;3)=\operatorname{ed}(G;5)
=\operatorname{ed}(G;11)=1.
\]

Thus a remaining quotient-stack obstruction would have to be new and
mixed-prime; none of the named integral classes above supplies it.
