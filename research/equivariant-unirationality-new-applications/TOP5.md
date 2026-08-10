# Top five actions: exact obstruction tests

## 1. Smooth quartic double solid with `(C7:C3) x C2deck`

Let

\[
B=2x_0^4+6x_0x_1x_2x_3+x_1x_3^3+x_1^3x_2+x_2^3x_3,
\qquad
X=\{w^2=B\}\subset\mathbf P(1,1,1,1,2).
\]

For a primitive seventh root `zeta`, set

\[
a=\operatorname{diag}(1,\zeta^4,\zeta^2,\zeta),
\qquad
b(x_0,x_1,x_2,x_3)=(x_0,x_2,x_3,x_1).
\]

Then `bab^{-1}=a^4`, so `H=<a,b>=C7:C3`. Let `tau:w->-w` and
`G=H x <tau>`.

The deck involution is central. Its fixed locus is the smooth K3 surface
`B`, with

\[
B^H=\varnothing,
\qquad
B^{C_7}=\{e_1,e_2,e_3\}.
\]

An `H`-stable rational curve would induce an action of `H` on its
normalization. The kernel is `1`, `C7`, or `H`. The faithful case is
impossible because the nonabelian group of order 21 is not a finite subgroup
of `PGL2`; the other two cases force the curve into `B^{C7}` or `B^H`.
Thus `B` has no positive-dimensional `H`-stable RCC subvariety.

```text
Condition (A)                                      PROVED
residual-RCC fixed-locus hypothesis                PROVED
X^G                                                 EMPTY
equivariant universal-torsor obstruction           ZERO
all higher Amitsur groups                          ZERO
```

Therefore

\[
\boxed{X\text{ is not weakly }G\text{-versal}.}
\]

The underlying smooth quartic double solid is ordinarily unirational. See
`THEOREM_KLEIN_QUARTIC_DOUBLE_SOLID.md`.

---

## 2. Cubic-surface bundles with `C3 x D_{2n}`

For every odd `n>=3`, let

\[
A_0=S^{2n}+T^{2n},\qquad A_1=(ST)^n
\]

on `P1`, let `D_{2n}` act by

\[
r[S:T]=[\epsilon S:\epsilon^{-1}T],
\qquad s[S:T]=[T:S],
\]

and let the central element `z` of `C3` act on the fiber `P3` by

\[
z[U:V:X:Y]=[\omega U:\omega^2V:X:Y].
\]

For general binary cubics `F0,F1`, define

\[
\begin{aligned}
\mathcal X_n:\quad
0={}&A_0(U^3+V^3)+UV(A_0X+A_1Y)\\
&+A_0F_0(X,Y)+A_1F_1(X,Y)
\end{aligned}
\]

inside `P1 x P3`. The action is

\[
G_n=C_3\times D_{2n}.
\]

### Target fixed locus

The projective `z`-fixed locus in the fiber is the line `P<X,Y>` and the
two eigenpoints `[1:0:0:0]`, `[0:1:0:0]`. Hence

\[
\mathcal X_n^z=C_n\sqcup P_U\sqcup P_V,
\]

where

\[
C_n:\ A_0F_0+A_1F_1=0
\subset\mathbf P^1\times\mathbf P^1
\]

is a smooth bidegree-`(2n,3)` curve and

\[
g(C_n)=4n-2,
\qquad |P_U|=|P_V|=2n.
\]

The full group has no fixed point because the dihedral base action has none:
the rotation fixes `0,infinity`, and the reflection swaps them.

### Condition (A)

Every abelian subgroup of `D_{2n}` is cyclic when `n` is odd. It fixes a
base point. Over that point the binary cubic `A0F0+A1F1` has a root, and
the resulting point of `C_n` is fixed by the central `C3` and by the
projected dihedral subgroup. Thus every abelian subgroup of `G_n` fixes a
point.

### Ordinary geometry and silent invariants

The bundle has three sections

\[
[U:V:X:Y]=[1:-\rho:0:0],\qquad \rho^3=1.
\]

Its smooth generic cubic surface therefore has a rational point and is
unirational by Kollár; spreading out proves that the total threefold is
unirational. Grothendieck--Lefschetz gives

\[
\operatorname{Pic}(\mathcal X_n)=
\mathbf Z\mathcal O(1,0)\oplus\mathbf Z\mathcal O(0,1),
\]

and both generators are genuinely linearized. Hence the universal-torsor
obstruction and every higher Amitsur group vanish.

```text
smoothness                                         PROVED BY BERTINI + BASE-LOCUS CHECK
ordinary unirationality                            PROVED
Condition (A)                                      PROVED
central fixed curve genus 4n-2                     PROVED
X_n^{G_n}                                          EMPTY
higher Amitsur hierarchy                           ZERO
```

The central theorem gives

\[
\boxed{\mathcal X_n\text{ is not weakly }G_n\text{-versal}.}
\]

See `THEOREM_CUBIC_SURFACE_BUNDLE_FAMILY.md`.

---

## 3. Odd exceptional conic bundles with `D_{2g} x C2`

For odd `g>=3`, let `S_g` be the minimal resolution of

\[
T_0T_1(T_0^{2g}+T_1^{2g})+T_2T_3=0
\subset\mathbf P(1,1,g+1,g+1).
\]

Let `xi` be a primitive `2g`-th root and define

\[
r(T_0,T_1)=(\xi T_0,\xi^{-1}T_1),
\qquad
s(T_0,T_1)=(T_1,T_0),
\qquad
j(T_2,T_3)=(T_3,T_2).
\]

In the weighted projective action, `r` has order `g`, `<r,s>=D_{2g}` of
order `2g`, and `j` is central. Put `G_g=D_{2g} x <j>`.

The fixed locus of `j` is

\[
S_g^j=C_g:\ U^2=-T_0T_1(T_0^{2g}+T_1^{2g}),
\qquad g(C_g)=g.
\]

Moreover `C_g^{D_{2g}}=empty`, hence `S_g^{G_g}=empty`. Every abelian
subgroup fixes a point: rotation subgroups fix the ramification points over
`0,infinity`, and reflection subgroups fix points over their base
eigendirections because `g+1` is even.

```text
S_g rational exceptional conic bundle              PROVED
Condition (A)                                      PROVED
central fixed locus has no rational component       PROVED
S_g^G                                               EMPTY
```

Thus

\[
\boxed{S_g\text{ is not weakly }G_g\text{-versal}}
\]

for every odd `g>=3`. See `THEOREM_ODD_EXCEPTIONAL_CONIC_BUNDLES.md`.

---

## 4. Rational genus-12 `V22` with `PSL2(F7)`

**Literature status:** `OPEN-CONFIRMED` through the search cutoff for
equivariant unirationality and weak versality.

Let `C subset P2` be the Klein quartic and

\[
X=\operatorname{VSP}(C,6).
\]

Cheltsov--Shramov identify `X` as a smooth rational prime Fano threefold of
genus 12 and degree 22 with faithful

\[
G=\operatorname{PSL}_2(\mathbf F_7)
\]

action. The entire Mori--Mukai No. 1.10 family satisfies Condition (A).
Since `Pic(X)=Z[-K_X]` and `-K_X` is canonically linearized, the universal
torsor and all higher Amitsur obstructions vanish.

The global fixed locus is empty by a short VSP argument. A `G`-fixed point of
`VSP(C,6)` would give a `G`-stable length-six subscheme of the dual Klein
plane. The irreducible three-dimensional representation has no projective
fixed point, and every nontrivial projective orbit has size at least seven: an
orbit of size at most six would give an injection of the simple group of
order 168 into `S6`, impossible by Lagrange. Hence no such length-six
subscheme exists.

For an involution `sigma`,

\[
N=C_G(\sigma)\simeq D_8.
\]

The exact missing calculation is

\[
X^\sigma
\quad\text{and}\quad
X^{D_8}.
\]

The acceptance test is:

```text
(a) every D8-stable irreducible RCC subvariety of X^sigma is a point;
(b) X^D8 is empty.
```

If both pass, the residual-RCC centralizer theorem proves that `X` is not
weakly `G`-versal. This remains the best unresolved direct-centralizer
target.

---

## 5. Fermat-discriminant Fano conic bundle No. 2.18

**Literature status:** `PARTIALLY-COVERED`--automorphisms and projective
linearizability are studied; equivariant unirationality is not classified.

Abe considers the rational double cover

\[
X_F\longrightarrow\mathbf P^1\times\mathbf P^2
\]

branched over a smooth `(2,2)` divisor determined by

\[
Q_1=ix^2+y^2,
\qquad Q_2=z^2,
\qquad Q_3=ix^2-y^2.
\]

Its conic-bundle discriminant is the Fermat quartic

\[
\Delta_F=\{x^4+y^4+z^4=0\},
\]

and the total automorphism group has order 192. The displayed abelian
subgroup `C4 x C2deck` has a fixed point and is weakly versal, so it is not
the target. The relevant action must be a nonabelian subgroup with Condition
(A) and empty global fixed locus.

The deck-fixed branch surface is a rational degree-2 del Pezzo. Hence the
whole fixed surface is an allowed RCC image and the single-carrier central
theorem cannot fire. The remaining work is:

```text
(a) freeze a nonabelian subgroup with Condition (A) and X^G=empty;
(b) enumerate involution classes and centralizers;
(c) classify residual-stable rational curves on the branch del Pezzo;
(d) prove connected exceptional-fiber propagation in dimension three.
```

This is the best test bed for a genuinely three-dimensional fixed-network
theorem.

## Double-quadric note

The nodal `A6` double quadric is the strongest additional large-group fixed
surface candidate, but it does not enter the top five. Its singular target,
unsettled Condition-(A) audit, and uncertain ordinary-unirationality boundary
outweigh the attractive fact that `A6` cannot act faithfully on a rational
curve. See `QUADRATIC_DOUBLE_SOLIDS.md`.
