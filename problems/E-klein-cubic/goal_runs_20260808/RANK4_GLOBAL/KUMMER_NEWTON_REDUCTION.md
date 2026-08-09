# Global Kummer--Fine-interior theorem for the rank-four trace branch

**Date:** 2026-08-08  
**Scope:** arbitrary Laurent support, degree, and number of prime orbits  
**Result:** the global mod-eleven incidence span has rank exactly three  
**Headline boundary:** the residue-rank-three additive gluing problem remains open

This note strengthens `THEOREM.md`.  It couples all Laurent-prime orbits at
once by finite Kummer covers of the *one* trace hyperplane system.  The proof
first reduces, by cyclic semisimplicity, to three fixed two-dimensional
character spaces.  A solver-free finite check of their complete toric normal
sets then shows that all three covers are of general type.  There is no
enumeration of Laurent supports, exponents, or degrees.

The conclusion is not `F55-NO`: it forces the only remaining global incidence
space to be the three-dimensional hyperplane `ker(mu)`.

## 1. The global incidence space and its annihilator

Let

\[
 \Lambda=\{(n_0,\ldots,n_4)\in\mathbf Z^5:\sum n_i=0\}
\]

be the character lattice of the projective `y`-torus, and put

\[
 V=\mathbf F_{11}^5/\mathbf F_{11}(1,1,1,1,1),
 \qquad
 V^*=\{\lambda\in\mathbf F_{11}^5:\sum\lambda_i=0\}.
                                                               \tag{1.1}
\]

The displayed spaces are paired perfectly by the coordinate dot product.
For every Laurent prime `P`, let

\[
 s(P)=(v_P(H_0),\ldots,v_P(H_4))\pmod {11}\in V              \tag{1.2}
\]

and define the single global incidence space

\[
 S=\operatorname {span}_{\mathbf F_{11}}\{s(P):P\text{ a Laurent prime}\}
 \subset V.                                                     \tag{1.3}
\]

The exact multiplicative residue theorem gives

\[
 \mu=(1,5,3,4,9)\in V^*,\qquad \mu\cdot s(P)=0
 \quad\hbox{for every }P.                                      \tag{1.4}
\]

Thus, for the annihilator

\[
 A=S^\perp\subset V^*,                                         \tag{1.5}
\]

one has `mu in A`.  Because the five `H_j` form one cyclic Fourier
hyperplane system, both `S` and `A` are stable under cyclic rotation.

## 2. Every annihilator subspace gives one finite Kummer cover

Let `B subset A`.  Choose integral sum-zero lifts `tilde(lambda)` of a basis
of `B` and form the overlattice

\[
 \Lambda_B=\Lambda+
 \sum_{\lambda\in B}\mathbf Z{\widetilde\lambda\over11}
 \subset\Lambda\otimes\mathbf Q.                               \tag{2.1}
\]

It defines a connected finite torus cover `T_B -> T_y` of degree
`11^(dim B)`.  Let `Y_B` be the inverse image in `T_B` of the trace
hyperplane

\[
 H=\{y_0+\cdots+y_4=0\}\cap T_y.                               \tag{2.2}
\]

### Lemma 2.1 (the dominant source map lifts)

After the fixed multiplication-by-eleven isogeny on the rational source
torus, the dominant trace map lifts dominantly to `Y_B`.

### Proof

For `lambda in B`, put

\[
 g_\lambda=\prod_i H_i^{\widetilde\lambda_i}
 \in\operatorname {Frac}(R)^*.                                 \tag{2.3}
\]

At every Laurent prime `P`, (1.2) and `B subset S^perp` give

\[
 v_P(g_\lambda)=0\pmod {11}.                                  \tag{2.4}
\]

Because the Laurent ring is factorial,

\[
 g_\lambda=u_\lambda q_\lambda^{11},
 \qquad u_\lambda\in R^*.                                    \tag{2.5}
\]

Every Laurent unit is a scalar times a character.  Pullback by `[11]` makes
every such unit an eleventh power; its scalar has an eleventh root over
`C`.  Hence the Kummer functions for a basis of `B` acquire compatible
roots in the pulled-back source field.  This is precisely a rational lift
to `T_B`, hence to `Y_B`.  Its composite with the finite map `Y_B -> H` is
the dominant map `h o [11]`.  By Lemma 2.2 below, `Y_B` is integral; a
proper closed subvariety of it cannot dominate `H` through a finite map.
Thus the lift is dominant.  QED.

This accounts for all Laurent units and all base divisors.  It uses the
valuation at every prime, not merely a selected support.

### Lemma 2.2 (the pulled-back hyperplane is integral)

For every `B`, the variety `Y_B` is geometrically integral.  In particular,
the lifted source cannot land in a special component omitted by the
birational obstruction below.

### Proof

Compactify `H` as the hyperplane `bar(H) = P^3` in `P^4`, and let

\[
 D_i=\{y_i=0\}\cap\bar H.
\]

These are five distinct prime divisors.  For an integral sum-zero character
`lambda`, the unit `u_lambda=prod_i y_i^(lambda_i)` on `H` has

\[
 \operatorname {div}_{\bar H}(u_\lambda)=\sum_i\lambda_iD_i.   \tag{2.6}
\]

If a product of the Kummer units belonging to a basis of `B` were an
eleventh power in `C(H)^*`, every coefficient of its divisor along the
distinct `D_i` would be divisible by eleven.  Reduction modulo eleven would
give a zero linear combination of that basis in `B`.  Thus their classes
are independent in `C(H)^*/C(H)^{*11}`.  Kummer theory therefore gives

\[
 [\mathbf C(Y_B):\mathbf C(H)]=11^{\dim B}.                    \tag{2.7}
\]

The generic pullback is a field, so `Y_B` is connected and irreducible.
The nondegeneracy check in Section 3 makes it smooth on the torus, hence
geometrically integral.  QED.

## 3. Newton polytope, nondegeneracy, and rational domination

Divide (2.2) by `y_0`.  Its Newton polytope in the lattice `Lambda_B` is the
four-simplex

\[
 \Delta=\operatorname {conv}
 \big(0,e_1-e_0,e_2-e_0,e_3-e_0,e_4-e_0\big).
                                                               \tag{3.1}
\]

The polynomial is nondegenerate for this lattice.  Indeed, on every face
its exponent vectors are affinely independent.  A common torus zero of a
face polynomial and all its logarithmic derivatives would give a nonzero
affine dependence among those vertices, which is impossible.

We use the Fine interior

\[
 F(\Delta)=\{x\in\Delta:\langle x,n\rangle
       \geq \operatorname {ord}_\Delta(n)+1
       \text{ for every }0\ne n\in N_B\},                      \tag{3.2}
\]

where `N_B=Hom(Lambda_B,Z)` and
`ord_Delta(n)=min_{x in Delta}<x,n>`.

Batyrev's theorem for a nondegenerate toric hypersurface with a
`d`-dimensional Newton polytope states, when the Fine interior is nonempty,

\[
 \kappa(Y_B)=\min\{d-1,\dim F(\Delta)\}.                       \tag{3.3}
\]

Here `d=4`.  Thus a full-dimensional Fine interior makes every smooth
projective model of `Y_B` a threefold of general type.  This formulation
incorporates all toric boundary valuations and the pluricanonical forms
created after resolving noncanonical boundary strata; a level-one interior
lattice point is not required.

### Lemma 3.1 (general type forbids the lifted rational source)

If `dim F(Delta)=4`, no rational fourfold dominates `Y_B`.

### Proof

Suppose `P^4 dashrightarrow Y_B` were dominant.  At a point where it is a
morphism of differential rank three, choose a linear `P^3` through that
point whose tangent space is transverse to the one-dimensional differential
kernel.  The restricted rational map has three-dimensional image and hence
is dominant and generically finite.

Resolve this map and replace `Y_B` by a smooth projective model.  Pullback
under a generically finite map injects nonzero pluricanonical forms.  But
all positive plurigenera of a variety birational to `P^3` vanish, whereas
(3.3) gives Kodaira dimension three on the target.  This is impossible.
QED.

## 4. Exact reduction of all Fine inequalities

Write a point of `Delta` in barycentric coordinates

\[
 \alpha=(\alpha_0,\ldots,\alpha_4),\qquad \sum_i\alpha_i=1.
                                                               \tag{4.1}
\]

A member of `N_B` is represented by an integer vector `g`, modulo addition
of a common constant, satisfying

\[
 g\bmod11\in B^\perp.                                         \tag{4.2}
\]

Normalize it uniquely by `min_i g_i=0`.  Then

\[
 g=q+11k,quad 0\leq q_i\leq10,quad \min_iq_i=0,quad k_i\geq0,
                                                               \tag{4.3}
\]

with `q mod 11 in B^perp`.  For this normal, the Fine inequality is exactly

\[
 \sum_i\alpha_i g_i\geq1.                                    \tag{4.4}
\]

Consequently the infinite family (3.2) is equivalent to the finite family

\[
 11\alpha_i\geq1\quad(0\leq i\leq4),
 \qquad
 \sum_i\alpha_iq_i\geq1                                      \tag{4.5}
\]

for every nonzero `q` satisfying

\[
 0\leq q_i\leq10,qquad \min_iq_i=0,qquad q\in B^\perp.
                                                               \tag{4.6}
\]

Indeed, `q=0` reduces to the five coordinate cases `k=e_i`; for `q!=0`,
the choice `k=0` makes its inequality necessary, and nonnegative `k` can
only increase the left side once (4.5) holds.  This proves completeness of
the dual-normal audit without assuming that the facet normals alone
suffice.

## 5. Cyclic semisimplicity leaves only three planes

On `V*`, cyclic rotation has characteristic polynomial

\[
 t^4+t^3+t^2+t+1=(t-3)(t-4)(t-5)(t-9)\quad\text{over }\mathbf F_{11}.
                                                               \tag{5.1}
\]

It is therefore semisimple with four one-dimensional eigenspaces, and
`mu` spans the eigenline of eigenvalue `9`.  If the cyclically stable `A`
had dimension at least two, it would contain `mu` together with one of the
other three eigenlines.  Hence it would contain one of exactly three
invariant planes:

\[
\begin{aligned}
 A_0&=\langle\mu,(0,1,3,8,10)\rangle,\\
 A_+&=\langle\mu,(0,1,8,5,8)\rangle,\\
 A_-&=\langle\mu,(0,1,9,6,6)\rangle.                         \tag{5.2}
\end{aligned}
\]

This is the complete analytic reduction.  The remaining computation checks
only these three fixed planes.  For each plane, the complete set (4.6) has
500 elements, and the exact minimum of `sum_i q_i` is

\[
\begin{array}{c|c|c}
 B&\min\sum_iq_i&\text{one minimizing }q\\
\hline
 A_0&6&(0,1,1,0,4)\\
 A_+&8&(0,0,4,3,1)\\
 A_-&8&(0,1,4,0,3).
\end{array}                                                   \tag{5.3}
\]

The barycenter `alpha_i=1/5` therefore satisfies every inequality strictly:

\[
 11\alpha_i={11\over5}>1,qquad
 \sum_i\alpha_iq_i\geq{6\over5}>1.                           \tag{5.4}
\]

Thus `F(Delta)` is full-dimensional for every plane (5.2).  Lemmas 2.1 and
3.1 exclude all three.  We conclude

\[
 \boxed{A=\langle\mu\rangle,\qquad
        S=\ker(\mu),\qquad \dim_{\mathbf F_{11}}S=3.}          \tag{5.5}
\]

This is an exact unrestricted theorem: it has no support or degree bound.

## 6. The two level-one exceptional planes and the full divisor lift

The planes `A_+` and `A_-` are exceptional only for the weaker test asking
for a level-one interior *lattice point* of `Delta`.  Neither contains a
residue vector with all entries positive and sum eleven.  Section 5 shows
why that test was insufficient: their Fine interiors are nevertheless
full-dimensional, so pluricanonical forms occur after toric resolution.

It is still instructive to record why every primewise multiplicative test
accepts them.  Let `S_+=A_+^perp` and `S_-=A_-^perp`.  Among their projective
directions having a representative supported on at most three indices, all
have support exactly three and split into two cyclic orbits.  Representatives
are

\[
\begin{array}{c|c|c}
 &\text{consecutive triple}&\text{gapped triple}\\
\hline
S_+&(0,1,9,3,0)&(1,0,10,6,0)\\
S_-&(0,1,10,5,0)&(1,0,4,5,0).
\end{array}                                                   \tag{6.1}
\]

For these four directions, positive residue representatives and exact
nonnegative solutions of

\[
 m\mathbf1+s=(2I+\operatorname {shift})x                     \tag{6.2}
\]

include

\[
\begin{array}{c|c|c|c}
 &s&m&x\\
\hline
S_+\text{ consecutive}&(0,4,3,1,0)&2&(0,2,2,1,1)\\
S_+\text{ gapped}&(2,0,9,1,0)&6&(4,0,6,3,1)\\
S_-\text{ consecutive}&(0,9,2,1,0)&6&(0,6,3,2,3)\\
S_-\text{ gapped}&(3,0,1,4,0)&2&(2,1,0,3,0).
                                                               \tag{6.3}
\end{array}
\]

For any row, introduce a free cyclic orbit of prime symbols
`P_i`, `sigma(P_i)=P_(i+1)`, and put

\[
 \mathcal H_j=\prod_iP_i^{s_{j-i}},\qquad
 \mathcal Q=\prod_iP_i^m,\qquad
 \mathcal A_j=\prod_iP_i^{x_{j-i}}.                           \tag{6.4}
\]

Then

\[
 \sigma(\mathcal H_j)=\mathcal H_{j+1},\qquad
 \mathcal Q\mathcal H_j=\mathcal A_j^2\mathcal A_{j+1},
 \qquad
 \prod_j\mathcal Q\mathcal H_j=
       \left(\prod_j\mathcal A_j\right)^3.                   \tag{6.5}
\]

The gcd of the five `mathcal H_j` is one and every prime is triple-incident.
Thus the two discarded planes pass the full integral `2+sigma` lift, cyclic
conjugacy, and the norm-cube identity.  The construction is deliberately a
divisor counterconfiguration: its independent prime symbols do not satisfy
`sum_j mathcal H_j=0`.  It does not contradict the Fine-interior exclusion;
it pinpoints the genuinely global additive geometry absent from all the
primewise tests.

## 7. Relation to the Klein cover and the exact boundary branch

For `B=<mu>`, the cover `T_B -> T_y` is the degree-eleven monomial isogeny

\[
 [x_i]\longmapsto[y_i]=[x_i^2x_{i+1}].                        \tag{7.1}
\]

Indeed, its Smith form on `Lambda` is `diag(1,1,1,11)`, and the extra
character in the domain lattice is `mu/11`.  Therefore `Y_<mu>` is the
dense-torus part of

\[
 \sum_i x_i^2x_{i+1}=0,                                      \tag{7.2}
\]

so it is birational to the original Klein cubic.

Each exceptional plane `A_+` or `A_-` contains `<mu>`.  Hence

\[
 Y_{A_\pm}\longrightarrow Y_{\langle\mu\rangle}              \tag{7.3}
\]

is a connected cyclic cover of degree eleven.  With sum-zero integral lifts
`tilde(nu)_+=(0,1,8,5,-14)` and
`tilde(nu)_-=(0,1,9,6,-16)`, its function field is obtained by adjoining

\[
 z^{11}=\prod_i y_i^{\widetilde\nu_{\pm,i}}.                  \tag{7.4}
\]

The cover is etale over the dense torus.  Its divisorial branch on toroidal
compactifications can be stated exactly.  Let a toroidal valuation over
`bar H` be represented by `g in Z^5/Z1`.  The relative cover (7.3) ramifies
precisely when

\[
 \mu\cdot g=0\pmod {11},\qquad
 \nu_\pm\cdot g\ne0\pmod {11}.                               \tag{7.5}
\]

If `mu dot g` is nonzero, the original Klein cover already has ramification
index eleven and the total two-character cover has the same index, so the
relative degree-eleven step is unramified there.  If it is zero, the new
Kummer character branches exactly when the second pairing is nonzero.  In
particular, at a generic coordinate boundary divisor `D_i`, `mu_i` is
nonzero, so (7.3) adds no branch.  Its new branch occurs only on toroidal
exceptional divisors over higher boundary intersections satisfying (7.5).
The complete normal family used in the Fine interior calculation includes
these divisors and all further weighted toroidal blowups.

## 8. Exact boundary

The proved conclusions are

```text
RANK4-GLOBAL-INCIDENCE-RESIDUE-RANK-EXACTLY-THREE
RANK4-GLOBAL-KUMMER-ANNIHILATOR-EXACTLY-MU
RANK4-RANK2-EXCEPTIONAL-COVERS-GENERAL-TYPE
RANK4-GLOBAL-EXCEPTIONAL-PLANES-PASS-INTEGRAL-NORM-LIFT
RANK4-RESIDUE-RANK3-ADDITIVE-GLUING-OPEN
F55-GLOBAL-QUESTION-OPEN
```

What remains is the rank-three case `S=ker(mu)`: the additive equation
`sum H_j=0`, the codimension-two intersections of its five Fourier
hyperplanes, and the multiplicative `2+sigma` lift must still be coupled.
No theorem in this packet excludes that case, so it does not prove `F55-NO`
or non-`PSL(2,11)`-unirationality.
