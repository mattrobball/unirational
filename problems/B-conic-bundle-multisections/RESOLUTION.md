# Resolution status for Problem B

## Bottom line

As of 22 July 2026, the unirationality of **every** smooth hypersurface

\[
X_{2,3}\subset \mathbf P^2_x\times \mathbf P^2_y
\]

has an affirmative answer.  There is a line
\(L\subset\mathbf P^2_y\) such that the surface
\(S_L=X\cap(\mathbf P^2_x\times L)\) is rational and fiberwise tangent
residuals in the plane-cubic fibration \(X\to\mathbf P^2_x\) map it
birationally to a horizontal divisor

\[
T_L\sim aH_x+H_y,\qquad 1\leq a\leq10.
\]

The map \(T_L\to\mathbf P^2_y\) has even degree \(2a\leq20\).
Base-changing the conic bundle by \(T_L\) therefore gives a dominant
rational map to \(X\).  For a general equation, \(a=10\) and the degree is
exactly `20`.  The uniform proof is in
[`all_smooth_tangent_residual_theorem.md`](certificates/all_smooth_tangent_residual_theorem.md);
the exact universal resultant and the generic degree-20 refinement are in
[`tangent_residual_theorem.md`](certificates/tangent_residual_theorem.md).

Ordinary rationality is settled negatively for every smooth member, while a
family-specific theorem shows that a very general member is not stably
rational.  Thus every smooth member is unirational but irrational, and very
general members are additionally not stably rational.

The proposed computation in `SPEC.md` could not be used as written.  Its
principal singularity count was wrong: an ordinary triple point of the
double-plane branch produces a \(D_4\) rational double point and does **not**
lower \(p_g\).  In addition, a rational surface on one sampled hypersurface
would prove only that the sample is unirational.  The tangent--residual
construction first gives degree `20` on a dense open of the full
59-dimensional parameter space.  The residual-line Lattès map of the generic
plane cubic then removes the genericity assumption: its critical-value curve
recovers that cubic, so the residual line cannot stay constant for every
choice of `L` on a smooth nonconstant family.

This note records the affirmative proof, the corrected earlier mathematics,
certified low-class exclusions, a certified special positive example, and the
alternative degree-eight descent route together with its exact limitations.

An independent negative byproduct is complete nonexistence of a rational
normalized horizontal divisor of class `(1,1)` on a general `X`.  This settles
that one degree-two class.  Classes `(1,k)` with `k>=2` and many higher-degree
classification questions remain open for a general `X`, but they are no
longer needed for the headline: the all-smooth construction produces a class
`(a,1)` with `1 <= a <= 10`, and the general class is `(10,1)`.

## Literature boundary

- Over an algebraically closed field of characteristic zero, Mella proves that
  a standard conic bundle over \(\mathbf P^2\) is
  unirational when its discriminant has degree at most 8, and also in degree 9
  when the discriminant is singular.  Thus that result already covers smooth
  `(2,3)` total spaces with singular discriminant.  The remaining boundary was
  the smooth degree-9 discriminant case, not covered by Corollary 1.2.  See
  [Mella, Theorem 1.1 and Corollary
  1.2](https://arxiv.org/abs/1403.7055).
- Over \(\mathbf C\), Böhning and Graf von Bothmer prove that for every
  \(n\geq2\), a very general \((2,n)\) hypersurface in
  \(\mathbf P^2\times\mathbf P^2\) is not stably rational.  See [Theorem
  1.1](https://ems.press/journals/cmh/articles/15336).
- Over \(\mathbf C\), every smooth `(2,3)` member is irrational.  Its conic
  projection is flat with relative Picard rank one and has degree-9
  discriminant (possibly nodal); Beauville's conic-bundle criterion applies
  once the discriminant degree is at least `6`.  See [Beauville, Théorème
  4.9](https://www.numdam.org/articles/10.24033/asens.1329/) and [Prokhorov,
  Theorem 9.1](https://arxiv.org/abs/1712.05564).
- The high-discriminant unirational examples of
  [Massarenti--Mella](https://arxiv.org/abs/2110.10057) are special families in
  nontrivial projective bundles; they did not settle this full
  trivial-bundle family.
- Del Centina and Verdi give an explicit \((3,2)\) equation and argue that it
  is a smooth unirational ordinary conic bundle, hence after interchanging the
  factors a special \((2,3)\) example.  Their displayed hypersurface, branch,
  and discriminant contain apparent coefficient/sign inconsistencies.  They
  further assert, without displaying the pencil, that the example lies in a
  pencil whose generic member is unirational.  A pencil is far too small to
  establish the assertion for a general point of \(\mathbf P^{59}\).  See
  [Del Centina--Verdi, Sections 4--5](http://www.bdim.eu/item?fmt=pdf&id=RLINA_1980_8_69_6_338_0).
- Current work of Ji--Diller--Riedl studies degree-two rational multisections;
  an [April 2026 BICMR
  announcement](https://bicmr.pku.edu.cn/content/show/35-3877.html) says they
  study when these exist, while the [June 2026 Obihiro
  abstract](https://webhomes.maths.ed.ac.uk/cheltsov/obihiro/abstracts.pdf)
  explicitly mentions nonexistence.  The public abstracts do not identify the
  \((2,3)\) family, and I found no associated preprint or public theorem
  statement in this audit.  This is a collision risk requiring an author check,
  not evidence that the exact frontier here is already covered.

Stable irrationality does not obstruct unirationality: the
[Artin--Mumford threefold](https://doi.org/10.1112/plms/s3-25.1.75) is the
standard counterexample.

## Extension from general to every smooth member

Let `X` now be an arbitrary smooth `(2,3)` hypersurface and put

\[
K=\mathbf C(\mathbf P^2_x),\qquad
C=X_K\subset\mathbf P^2_{y,K}.
\]

Generic smoothness makes `C` a smooth plane cubic.  It is not a constant
embedded cubic: otherwise its equation over `K` would be proportional to a
fixed cubic \(f_0(y)\), and homogeneity would give
\(F(x,y)=Q(x)f_0(y)\), contradicting smoothness of `X`.

For any smooth plane cubic `C`, tangent residuals define the quartic Lattès
morphism

\[
\delta_C:(\mathbf P^2_y)^\vee\longrightarrow(\mathbf P^2_y)^\vee,
\qquad
L\cap C=p+q+r\longmapsto
\overline{(-2p)(-2q)(-2r)}.
\]

Its reduced critical-value curve is exactly the dual sextic \(C^\vee\).
One algebraic proof writes the line-section plane as the quotient
\(C^2/S_3\).  If \(\pi:C^2\to(\mathbf P^2_y)^\vee\) is the quotient and
\(\mu=[-2]^2\), then

\[
\pi\mu=\delta_C\pi,
\qquad
\pi^*R_{\delta_C}=\mu^*R_\pi-R_\pi.
\]

The ramification of `pi` consists of the three reflection curves where two
points of a line section coincide.  Pullback by `mu` adds their translates by
the three nonzero two-torsion points.  Those translated curves are precisely
the ramification of \(\delta_C\), and their images are \(C^\vee\).  Therefore
\(\delta_C\) determines the embedded cubic by biduality.  This Lattès map and
its critical values are also recorded explicitly by
[McMullen--Mukamel--Wright, equation (2.6)](https://doi.org/10.4007/annals.2017.185.3.6)
and [Dabija--Jonsson, Section 4.3](https://doi.org/10.5565/PUBLMAT_54110_07).

It follows that \(\delta_C\) is not defined over the constant field
\(\mathbf C\): otherwise its critical-value sextic, and hence `C`, would be
constant.  A morphism over \(K=\mathbf C(s,t)\) that takes a Zariski-dense
set of constant points to constant points descends to \(\mathbf C\) (apply
the two \(\mathbf C\)-derivations of `K` to affine coordinate ratios).
Consequently there is a constant line `L`, chosen simultaneously away from
the tangent and two-torsion chord loci, such that

\[
\delta_C(L)\notin(\mathbf P^2_y)^\vee(\mathbf C).
\]

For this `L`, the surface \(S_L\) is integral and rational by Tsen, and
tangent residuals map it birationally to an irreducible surface \(T_L\) of
degree three over \(\mathbf P^2_x\).  If `T_L` were vertical over
\(\mathbf P^2_y\), Grothendieck--Lefschetz and the two fiber intersections
would give

\[
[T_L]=H_y.
\]

It would therefore be the inverse image of a constant line `M`, forcing
\(\delta_C(L)=M\), a contradiction.  Thus `T_L` is horizontal.

Finally, the universal residual line has coefficients of degree ten in `x`.
After removing their common factor and any components over special
\(x\)-curves, the image has class

\[
[T_L]=aH_x+H_y,\qquad1\le a\le10.
\]

It is rational and has degree \(2a\le20\) over the conic-bundle base, so the
multisection principle proves unirationality.  Full details are in
[`all_smooth_tangent_residual_theorem.md`](certificates/all_smooth_tangent_residual_theorem.md).

## Generic degree-20 refinement by tangent residuals

Fix a general line \(L\subset\mathbf P^2_y\) and set

\[
S=X\cap(\mathbf P^2_x\times L).
\]

The projection \(S\to L\simeq\mathbf P^1\) is a conic bundle.  Its generic
conic is defined over the \(C_1\)-field \(\mathbf C(L)\simeq\mathbf C(t)\),
so Tsen's theorem gives a rational point.  Projection from that point makes
\(\mathbf C(S)\simeq\mathbf C(t)(z)\); hence \(S\) is rational.

Now use the other projection.  For a general \(x\in\mathbf P^2_x\), let
\(C_x\subset\mathbf P^2_y\) be the smooth cubic \(F(x,-)=0\).  If
\(p\in C_x\cap L\), define \(r=\tau_x(p)\) by

\[
T_pC_x\cdot C_x=2p+r.
\]

Taking the third intersection point is algebraic, so this gives a rational
map \(\tau:S\dashrightarrow X\).  The exact class of its image follows from
a universal resultant identity.  Choose coordinates \([U:V:W]\) with
\(L=\{W=0\}\) and write

\[
f=g(U,V)+Wh(U,V)+W^2(iU+jV)+kW^3.
\]

For \(p=[u:v:0]\), its tangent line evaluated at \([U:V:W]\) is

\[
P_{U,V,W}(u,v)=Ug_u(u,v)+Vg_v(u,v)+Wh(u,v).
\]

The universal computation gives

\[
\operatorname{Res}_{u,v}(g,P_{U,V,W})+\Delta(g)f=W^2q_f,
\]

where \(q_f\) is linear in \(U,V,W\) and each of its coefficients is
homogeneous of degree five in the coefficients of \(f\).  Since the
coefficients of \(F(x,-)\) are quadratic in \(x\), the line \(q_f=0\) varies
with coefficients of degree ten in \(x\).  On \(X\), the term involving
\(f\) vanishes, and the factor \(W^2\) is exactly the doubled original
intersection with \(L\).  Therefore the residual divisor is

\[
\boxed{T\sim10H_x+H_y.}
\]

Equivalently, on each cubic the three identities
\(2p_i+r_i\sim H_y|_{C_x}\), together with
\(p_1+p_2+p_3\sim H_y|_{C_x}\), show that
\(r_1+r_2+r_3\sim H_y|_{C_x}\); the three residual points are collinear on
the line \(q_f=0\).  For a general cubic-line pair they are distinct.  Since
\(S\) is irreducible, the degree-three generic fiber is transitive, and the
residual map is a bijection of its three geometric points.  Thus
\(S\dashrightarrow T\) is birational and \(T\) is rational.

Finally, if \(c_y\) is a general conic fiber of
\(X\to\mathbf P^2_y\), then

\[
T\cdot c_y=(10H_x+H_y)\cdot c_y=20.
\]

Thus \(T\) is horizontal of degree 20.  Its normalization \(\widetilde T\)
is rational, and the conic bundle pulled back to \(\widetilde T\) has the
tautological point and is birational to
\(\widetilde T\times\mathbf P^1\).  Projection back to \(X\) is a dominant rational map
of degree 20, proving that a general \(X_{2,3}\) is unirational.

The full proof, including a second Chow-cycle derivation of the class and all
genericity qualifications, is
[`tangent_residual_theorem.md`](certificates/tangent_residual_theorem.md).
The universal symbolic identity, primitivity of the residual-line
coefficients, a base-factor-free quadratic specialization, and an exact smooth
fiber witness are checked by
[`tangent_residual_local_checks.py`](certificates/tangent_residual_local_checks.py)
and its [`log`](certificates/tangent_residual_local_checks.log).

## Corrections to the structural setup

The following parts of the setup remain valid over an algebraically closed field
of characteristic zero.

1. Grothendieck--Lefschetz gives
   \(\operatorname{Pic}(X)=\mathbf ZH_x\oplus\mathbf ZH_y\).  A horizontal
   divisor \(aH_x+bH_y\) has degree \(2a\) over the conic-bundle base, so every
   multisection has even degree.
2. A horizontal surface with rational normalization makes \(X\) unirational by
   base change and projection from the tautological point.  Conversely, the
   image of a general plane under a dominant map \(\mathbf P^3\dashrightarrow
   X\) is a horizontal unirational surface, hence a rational surface over
   \(\mathbf C\).
3. Every effective divisor class has \(a,b\geq0\).  This follows from
   \(H^1(\mathbf P^2\times\mathbf P^2,\mathcal O(u,v))=0\) and the restriction
   sequence.  Thus a smooth horizontal member has effective or trivial
   canonical class and cannot be rational.
4. For a basepoint-free triple \(\sigma\) defining an integral member \(S\), the
   normalization of \(\mathbf P^2_y\) in \(\mathbf C(S)\)—equivalently, the
   normalized finite model obtained from Stein factorization—is the double plane
   with branch
   \[
   B_\sigma=\sigma^T\operatorname{adj}(A)\sigma,
   \qquad \deg B_\sigma=2k+6.
   \]

Several qualifications are necessary.

- The projection to \(\mathbf P^2_x\) is a **genus-one** fibration, not an
  elliptic fibration.  A divisor \(aH_x+bH_y\) has degree \(3b\) on its
  generic plane cubic, so the Picard calculation rules out a section.
- A singular normal member has no conductor correction under normalization;
  discrepancies appear on its resolution.  A conductor enters only for a
  nonnormal member.
- If the three entries of \(\sigma\) have a common zero, the map to the dual
  plane is rational rather than regular and the surface contains an entire
  conic fiber there.  One must resolve this base locus and use the square-free
  branch of the normalized double cover.  A common curve factor produces a
  vertical divisor component.
- For \(d=2\), a general \((1,0)\) member is geometrically a rational
  degree-two del Pezzo surface.  Over \(\mathbf F_p\) or \(\mathbf Q\),
  geometric rationality does not by itself emit a parametrization over the
  ground field; that needs a rational-point/unirationality argument.

## Correct canonical-resolution calculation

Let \(B\in|2L|\) on \(\mathbf P^2\), where
\(L=\mathcal O_{\mathbf P^2}(m)\) and \(m=k+3\).  Blow up an ordinary branch
point of multiplicity \(r\), and put \(t=\lfloor r/2\rfloor\).  On the blown-up
plane,

\[
L'=f^*L-tE,\qquad
B'=\widetilde B+(r\bmod 2)E,
\]

so

\[
K_{Y'}+L'=f^*(K_Y+L)-(t-1)E.
\]

Consequently:

- \(r=2\) gives an \(A_1\) point and no adjunction condition;
- \(r=3\) gives a \(D_4\) point and no adjunction condition;
- \(r=4\) is the first ordinary multiplicity that imposes a nonzero adjunction
  condition: one simple-point condition on degree-\(k\) adjoints (it can be
  redundant in a special cluster);
- \(r=4,5\) impose order 1, while \(r=6,7\) impose order 2.

Assume that square branch factors have been removed and the normalized double
cover is connected.  For distinct ordinary proper points,

\[
p_g(\widetilde S)=
h^0\!\left(\mathbf P^2,
\mathcal O(k)\otimes\bigcap_i\mathfrak m_{p_i}^{t_i-1}\right),
\]

and

\[
\chi(\mathcal O_{\widetilde S})
=1+\binom{k+2}{2}-\sum_i\binom{t_i}{2},
\qquad q=1+p_g-\chi.
\]

Dependent adjunction conditions can therefore increase \(q\).  Killing
\(p_g\) is not a rationality certificate.  One must also verify \(q=0\) and
\(P_2=0\) on a resolution (or give a direct rational parametrization).

For infinitely-near centers, replace the intersection of proper-point ideals
in the display by the cluster ideal

\[
f_*\mathcal O_Y\!\left(-\sum_i(t_i-1)E_i\right)
\]

with its proximity conditions.  On the canonical resolution, writing \(L_Y\)
for the corrected half-branch divisor,

\[
P_2=h^0(Y,2K_Y+2L_Y)+h^0(Y,2K_Y+L_Y).
\]

For distinct ordinary proper centers these simplify respectively to
degree-\(2k\) plane curves with multiplicities \(2(t_i-1)\), and
degree-\((k-3)\) curves with multiplicities \(\max(t_i-2,0)\).  For a general
infinitely-near cluster the two systems instead use the pushforwards

\[
f_*\mathcal O_Y\!\left(-2\sum_i(t_i-1)E_i\right),\qquad
f_*\mathcal O_Y\!\left(-\sum_i(t_i-2)E_i\right),
\]

where the second divisor can have mixed signs.  Both must be unloaded with
all proximity relations; replacing its coefficients pointwise by
\(\max(t_i-2,0)\) is not valid in general.

The high-multiplicity shortcut also needs a connectedness hypothesis.  For a
reduced irreducible branch of degree \(n=2m\), multiplicity \(n-2\) or
\(n-1\) makes the pencil through the point a genus-zero fibration and Tsen gives
rationality over \(\mathbf C\).  The statement with unrestricted multiplicity
\(\ge n-2\) is false: \(2m\) concurrent lines give, after normalization, a
surface birational to \(C\times\mathbf P^1\), where
\(C:w^2=f_{2m}(u,v)\) has genus \(m-1\).

Thus every ordinary-triple-point budget in `SPEC.md` must be replaced by an
adjoint-ideal budget involving quadruple/higher points, non-negligible
infinitely-near clusters, or even branch components removed by normalization.

## Certified special positive pencil

A branch-compatible correction of the Del Centina--Verdi example provides a
useful calibration for the corrected singularity calculation.  With conic
coordinates \(x_i\) and base coordinates \(y_i\), consider the pencil

\[
A_\lambda(y)=
\begin{pmatrix}
2y_2^3-\lambda y_1^3 & y_0^3+y_2^3 & y_0^3\\
y_0^3+y_2^3 & y_0^3 & -6y_1^3\\
y_0^3 & -6y_1^3 & -12y_2^3
\end{pmatrix}.
\]

The value \(\lambda=1\) matches the branch curve displayed by Del
Centina--Verdi, but is not a literal transcription of their inconsistent
displayed hypersurface equation.  For the constant line \(x_2=0\), the branch
sextic is

\[
B_\lambda=-(y_0^6+y_2^6+\lambda y_0^3y_1^3).
\]

For every \(\lambda\ne0\), it has one proper triple point
\(p=(0:1:0)\).  Its strict transform has another triple point in the tangent
direction.  Because the first multiplicity is odd, the first exceptional curve
is part of the corrected branch; consequently the successive **total** branch
multiplicities in the canonical resolution are \((3,4)\), not \((3,3)\).
Thus \(t=(1,2)\), and the formulas above give

\[
p_g=0,\qquad \chi=1,\qquad q=0,\qquad P_2=0.
\]

After the second blowup the corrected branch is smooth, so Castelnuovo's
criterion makes the bisection rational.  At \(\lambda=1\), the hypersurface and
its degree-nine discriminant are both smooth; smoothness is open in the pencil.
Consequently a nonempty open subset of this explicit pencil consists of smooth
unirational, irrational \((2,3)\) hypersurfaces.

The reproducible check is
[`certificates/special_unirational_example.m2`](certificates/special_unirational_example.m2),
with output in
[`certificates/special_unirational_example.log`](certificates/special_unirational_example.log).
The script checks the \(\lambda=1\) smooth witness, the resolution charts, and
the generic cluster over \(\mathbf Q(\lambda)\); the displayed formula shows
that the same rational cluster persists for every \(\lambda\ne0\).  This is a
special-pencil theorem and supplies no dominance over \(\mathbf P^{59}\).

## Certified first exclusion: class \((1,0)\)

For a general \((2,3)\) hypersurface, no branch sextic

\[
B_{\sigma}=\sigma^T\operatorname{adj}(A)\sigma,
\qquad \sigma\in\mathbf P^2,
\]

has a point of multiplicity at least 3.

The certificate is [`certificates/k0_no_triple.m2`](certificates/k0_no_triple.m2),
with its verified output in
[`certificates/k0_no_triple.log`](certificates/k0_no_triple.log).
It reduces one explicit dense integral symmetric matrix of ternary cubics modulo
each of \(32003\) and \(65537\).  In every one of the nine
affine charts covering \(\mathbf P^2_\sigma\times\mathbf P^2_y\), the six
second derivatives of \(B_\sigma\) generate the unit ideal.  Thus these charts
have no points even over \(\overline{\mathbf F}_p\), not merely no
\(\mathbf F_p\)-rational points.  The script also checks that each witness
hypersurface and its degree-9 discriminant are smooth.

For a sextic in characteristic not dividing \(30\), Euler's identities give

\[
\sum_i y_iB_{ij}=5B_j,
\qquad
\sum_i y_iB_i=6B.
\]

Thus the six second derivatives vanish at a projective point exactly when the
sextic has multiplicity at least three there.  The analogous Euler identities
justify omitting the defining equations from the two smoothness ideals in the
script.  Both chosen primes avoid all relevant characteristics.

Here is why this is a characteristic-zero theorem rather than a random test.
Over \(\mathbf Z[1/30]\), let \(I\) be the closed projective incidence of
triples \((A,\sigma,y)\) with
\(\operatorname{mult}_yB_\sigma\ge3\).  Its projection to
\(\mathbf P^{59}_A\) is proper, hence has closed image.  If that image contained
the entire generic \(\mathbf Q\)-fiber, closedness would make it contain the
closure of that fiber, namely the whole parameter space and hence every good
special fiber.  The displayed finite-field witness lies outside the image, so
the generic characteristic-zero fiber is not contained in it.  Therefore a
general complex \(A\) has no such pair \((\sigma,y)\).

For a general smooth \(X\), members of \(|H_x|\) are integral by the Picard and
effectivity calculation.  If a branch sextic had a doubled component and a
positive-degree residual component, the two would meet and give a point of
multiplicity at least 3, which the certificate excludes.  If it were a pure
square, its generic double algebra would split, contradicting integrality.
Thus the branch is reduced.

Let \(T_\sigma\) be the normalization of \(\mathbf P^2_y\) in \(\mathbf C(S)\).
It is the connected normal double cover branched along \(B_\sigma\).  A reduced
plane-curve singularity of multiplicity 2 is analytically of type \(A_n\), and
the corresponding double-cover singularity is Du Val.  Therefore the minimal
resolution of \(T_\sigma\) is a K3 surface.  Since
\(\mathbf C(T_\sigma)=\mathbf C(S)\), the normalization of \(S\) is not
rational.  (An arbitrary nonminimal resolution need not itself be a K3 surface.)

This is only the \(k=0\) edge of the degree-two problem; it does not exclude
\((1,k)\) for \(k>0\).

## Exact frontier and certified exclusions for class \((1,1)\)

The next case has an exhaustive finite rationality frontier, and every row is
now excluded for a general \(X\).  This includes every square-factor row, the
square-free one-\(t=3\) row, and all proper and infinitely-near diagrams in
the square-free three-\(t=2\) row.  Write
the degree-eight branch as

\[
B_\sigma=G^2C,
\]

where \(G\) is the maximal square factor and \(C\) is reduced of degree \(2m\).
Along the complete canonical resolution of \(C\), put
\(t_i=\lfloor r_i/2\rfloor\) for the **corrected total** branch
multiplicities.  Over \(\mathbf C\), for \(C\ne0\) and the connected normalized
double plane, Castelnuovo's criterion and the formulas above give the exhaustive
possibilities:

| \(\deg C\) | necessary and sufficient resolution data for rationality |
|---:|---|
| 8 | either one \(t_i=3\) and every other \(t_j=1\), or three \(t_i=2\) and every other \(t_j=1\); in the latter case both the linear-adjoint cluster system and the doubled-weight conic cluster system must vanish |
| 6 | exactly one \(t_i=2\), with every other \(t_j=1\) |
| 4 | every \(t_i=1\) |
| 2 | automatic for a nonzero reduced conic |

More precisely, in the octic row put

\[
D=\sum_i(t_i-1)E_i,\qquad
\mathcal J_D=f_*O_Y(-D),\qquad
\mathcal J_{2D}=f_*O_Y(-2D),
\]

with exceptional divisors in the total-transform basis.  Rationality requires

\[
H^0(\mathcal J_D(1))=H^0(\mathcal J_{2D}(2))=0.
\]

The second vanishing implies the first, but the first does not imply the
second for infinitely-near centers: the raw weights must be unloaded as
divisorial-valuation ideals.  For example, the reduced octic

\[
(xz-y^2)\,z\,x\,(x-2y+z)\,
\bigl[xz(x-2y+z)+(xz-y^2)(x+z)\bigr]
\]

has three noncollinear `(3,4)` corrected clusters.  Their three `t=2` centers
kill all line adjoints, but the conic `xz-y^2` lies in the doubled-weight
cluster system, so `P_2>0`.  A single `t=3` center in the correction-sum-three
case is necessarily proper, and both vanishings are then automatic.  For an
octic with correction sum \(s<3\), \(q=0\) can still occur, but then
\(p_g=3-s>0\), so \(P_2>0\); if `s>3`, then `q>0`.

The corrected table includes reducible residual branches, rank-two triples
\(\sigma\), and infinitely-near centers.  Rank-one \(\sigma\) reduces to a
vertical component plus the already excluded \((1,0)\) horizontal component.
The construction and its finiteness justification are recorded in
[`certificates/k1_frontier.md`](certificates/k1_frontier.md).

The one-\(t=3\) row is now a theorem, not a solver screen.  For a fixed
full-rank \(\sigma\), restriction to its incidence threefold gives a
42-dimensional space of binary quadratic forms.  Restriction to two
transverse lines through a proposed sixfold point is surjective, and the two
order-six determinant contacts, sharing their constant quadratic form, have
codimension 11.  Moving the point leaves codimension at least 9, which is
strictly greater than the 8-dimensional full-rank matrix orbit.  For
rank-two \(\sigma\), the corresponding bounds are 9 away from its base point
and 8 at the base point, both greater than the 7-dimensional rank-two orbit.
Rank one reduces to the \((1,0)\) theorem.  Since the frontier proves that a
lone \(t=3\) center must be proper, this excludes that entire rationality
stratum.  The proof and exact local height checks are
[`proper_sixfold_theorem.md`](certificates/k1_work/proper_sixfold_theorem.md),
[`proper_sixfold_local_checks.m2`](certificates/k1_work/proper_sixfold_local_checks.m2),
and [`its log`](certificates/k1_work/proper_sixfold_local_checks.log).

There is also no squared line factor for rank-two or rank-three \(\sigma\).
For full rank, restriction to a doubled line is a 27-dimensional quotient;
the determinant and first-normal equations have fixed-line codimension at
least 12, hence codimension 10 after the line moves, again greater than the
orbit dimension 8.  Rank two has the same bound away from its base point; a
separate exhaustive calculation for lines through the base point gives
fixed-line codimension 11 and moving-line codimension 10, greater than 7.
Rank one again has only the nonrational \((1,0)\) horizontal component.  This
removes the entire residual-sextic row, every reducible quadratic or cubic
maximal square factor, and the branch-map base locus \(B_\sigma=0\).  See
[`square_line_theorem.md`](certificates/k1_work/square_line_theorem.md), its
[`exact rank checks`](certificates/k1_work/square_line_local_checks.py), and
[`log`](certificates/k1_work/square_line_local_checks.log).

The irreducible-conic row is also absent.  In fact, for rank two or three a
general \(A\) has no branch divisible even once by an irreducible conic.  On
the conic normalization the restricted binary quadratic form has degree
pattern \((8,8,8)\) in rank three, \((10,8,6)\) in rank two away from its
base point, and \((8,7,6)\) when the conic passes through the base point.
The corresponding determinant-zero loci have fixed-conic codimensions
17, 16, and 15.  After the conic moves, the codimensions are 12, 11, and 11,
strictly greater than the matrix-orbit dimensions 8, 7, and 7.  The proof and
exact restriction-rank checks are
[`conic_factor_theorem.md`](certificates/k1_work/conic_factor_theorem.md),
[`conic_factor_local_checks.py`](certificates/k1_work/conic_factor_local_checks.py),
and [`its log`](certificates/k1_work/conic_factor_local_checks.log).

The irreducible-cubic row is absent as well.  More strongly, for rank two or
three a general \(A\) has no branch divisible even once by an integral cubic.
For a smooth cubic, the restricted rank-two bundle has degree three (or degree
two when a rank-two \(\sigma\) has its base point on the cubic); a saturated
line-subbundle/Quot estimate bounds the determinant-zero locus by dimension 15
or 13.  Nodal and cuspidal cubics are controlled on their normalization, with
bounds 16 and 14.  When the cubic is singular at the rank-two base point, the
restriction has exact rank 32 in a 33-dimensional normalization target, and
the rank-one locus has dimension at most 12.  After every cubic family moves,
the fixed-\(\sigma\) codimension is at least 12 (and 14 in the last case),
strictly greater than the orbit dimensions 8 and 7.  See
[`cubic_factor_theorem.md`](certificates/k1_work/cubic_factor_theorem.md),
[`cubic_factor_local_checks.py`](certificates/k1_work/cubic_factor_local_checks.py),
and [`its log`](certificates/k1_work/cubic_factor_local_checks.log).

The all-proper part of the last square-free row is absent too.  Three proper
essential centers satisfying the adjoint vanishings are three distinct
noncollinear points.  Restricting the binary quadratic form to their triangle
gives a 36-dimensional target in rank three.  On each edge the degree pattern
is \((5,4,3)\), and endpoint multiplicity four forces the determinant into the
one-dimensional span of \(s^4t^4\); the complete edge locus has dimension at
most 7.  Thus the fixed-triangle codimension is at least
\(36-3\cdot7=15\), and moving the vertices leaves 9, greater than the
rank-three orbit dimension 8.  On the rank-two blowup, the three possible
positions of its base point give fixed-triangle codimensions \(15,14,13\);
after the appropriate vertex motion every case again leaves 9, greater than
7.  The proof and exact arithmetic checks are
[`proper_three_center_theorem.md`](certificates/k1_work/proper_three_center_theorem.md),
[`proper_three_center_local_checks.py`](certificates/k1_work/proper_three_center_local_checks.py),
and [`its log`](certificates/k1_work/proper_three_center_local_checks.log).

Further infinitely-near subrows are absent.  The adjacent-nesting
theorem excludes a proper essential center followed immediately by a second
essential center when the singleton tree is either proper or an isolated
first-near `(3,4)` cluster.  It also excludes the free chain of three adjacent
essential centers starting at a proper point.  The auxiliary tangent-line and
conic restrictions leave fixed-`sigma` codimension at least 9 in rank three;
in rank two the minimum is 8 in one aligned base-point stratum, still greater
than the orbit dimension 7.  See
[`adjacent_nested_pair_theorem.md`](certificates/k1_work/adjacent_nested_pair_theorem.md),
its [`exact arithmetic checks`](certificates/k1_work/adjacent_nested_pair_local_checks.py),
and [`log`](certificates/k1_work/adjacent_nested_pair_local_checks.log).

The remaining three-singleton diagrams are absent as well.  In root type
`[1,1,1]`, each nonproper essential center is an immediate first-near
`(3,4)` cluster.  A line component through its proper origin must have the
marked tangent direction; this component-direction lemma, together with
smooth conics through the three distinct origins, treats every possible
tangent alignment.  After the marked configuration moves, the fixed-`sigma`
codimension is at least 9 in rank three and at least 8 in rank two (and 9 for
three nonproper centers), exceeding the orbit dimensions 8 and 7.  See
[`three_singleton_first_near_theorem.md`](certificates/k1_work/three_singleton_first_near_theorem.md),
its [`exact arithmetic checks`](certificates/k1_work/three_singleton_first_near_local_checks.py),
and [`log`](certificates/k1_work/three_singleton_first_near_local_checks.log).

The two ancestor root types admit a final exact reduction.  If consecutive
essential centers are separated, there is exactly one intervening `t=1`
center, and its corrected multiplicities are either

\[
 (4,3,4)\quad\text{(free)},\qquad
 (5,3,4)\quad\text{(free then satellite)}.
\]

The separator proof also rules out essential forks.  In root type `[2,1]`,
the theorem
[`root_two_one_separator_theorem.md`](certificates/k1_work/root_two_one_separator_theorem.md)
treats both separator patterns, both proper and first-near singleton trees,
all line-continuation and tangent alignments, and every rank-two base-point
position.  Its fixed-`sigma` minima are 9 in rank three and 8 in rank two,
strictly greater than the orbit dimensions 8 and 7.  Together with the
adjacent theorem, this excludes all of `[2,1]`.  See its
[`arithmetic checker`](certificates/k1_work/root_two_one_separator_local_checks.py)
and [`log`](certificates/k1_work/root_two_one_separator_local_checks.log).

In root type `[3]`, the exact separator theorem leaves only the edge patterns
`A-F`, `A-S`, and `F-F`.  Correct unloading of the cluster ideal makes every
aligned `A-F` and proper-minimal `F-F` tangent line a forbidden section of
`H-D`; the nonaligned cases are excluded by a line--conic incidence.  The
`A-S` pattern has a forced tangent-line component whose residual strict
multiplicities violate proximity.  In the last nonproper-minimal `F-F` chain,
a unique smooth conic and the tangent line give codimension 9 in rank three
after retaining one constant-term gluing condition; the four rank-two strata
have codimensions `8,9,9,8`.  See
[`root_three_separator_theorem.md`](certificates/k1_work/root_three_separator_theorem.md),
[`root_three_free_separator_theorem.md`](certificates/k1_work/root_three_free_separator_theorem.md),
[`root_three_completion_theorem.md`](certificates/k1_work/root_three_completion_theorem.md),
and their exact checkers and logs.

The three root types `[1,1,1]`, `[2,1]`, and `[3]` are exhaustive.  Therefore

\[
 \boxed{\text{No rational normalized horizontal divisor of class }(1,1)
 \text{ occurs on a general }X_{2,3}.}
\]

This is a complete class-`(1,1)` nonexistence theorem for one degree-two
class, not a theorem about every degree-two multisection and not a
non-unirationality theorem.  The classes `(1,k)` for `k>=2` remain, and the
Enriques criterion supplies no bound reducing an arbitrary rational
multisection to any finite list of classes.

There is also always a cubic in the doubled cluster ideal:
\[
 H^0(\mathcal J_{2D}(3))\ne0.
\]
On the terminal blowup, Riemann--Roch for `3H-2D` gives this section and its
intersection with the corrected branch is zero.  If they share no component,
the original octic restricts with even divisor to every normalized
nonexceptional cubic component.  Odd exceptional branch components can be
fixed shared components, so this observation does not by itself yield an
incidence exclusion; the completed proof above instead retains the marked
cluster data.

The proof, the root-type lemma, the explicit `[2,1]` realization, and the
numerical limit of the unmarked contact-cubic incidence are in
[`contact_cubic_observation.md`](certificates/k1_work/contact_cubic_observation.md).

The first proposed equigeneric shortcut is false.  The explicit reduced octic
in
[`three_center_genus_counterexample.md`](certificates/k1_work/three_center_genus_counterexample.md)
has exactly the three required `t=2` centers and both cluster-system
vanishings, but its normalization has total genus four.  Its
[`Macaulay2 certificate`](certificates/k1_work/three_center_genus_counterexample.m2)
checks absolute irreducibility of the septic component, complete singular
support, local types, cluster ranks, and genus.  In general the exact identity
is
\[
 G=2+s+o-n_1,
\]
where `s` is the number of original components, `o` the number of odd
corrected blowups, and `n_1` the number of `t=1` centers.  A possible sharp
replacement `G<=4` remains unproved, but is no longer needed for the direct
class-`(1,1)` exclusion.

Even if that replacement were established, singular determinant fibers remain
a separate obstacle: the required bounds would be at most 5 in rank three and
8 in rank two.  Singular non-ADE curves can have positive-dimensional families
of torsion-free theta-characteristics, so generic finiteness on smooth octics
does not provide those bounds.  The adjusted count and its precise limitations
are
[`three_center_equigeneric_attempt.md`](certificates/k1_work/three_center_equigeneric_attempt.md).
The independent source-and-deformation audit
[`determinant_fiber_limits.md`](certificates/k1_work/determinant_fiber_limits.md)
shows more precisely that a fixed resolution-compatible sheaf contributes only
finitely many projective forms, while its local self-dual type can vary.  It
also gives dimension at least six for the projective fixed-determinant tangent
space at any nonzero-determinant point of a natural ambient jet stratum.  An
exact symmetric-cubic witness has reduced octic determinant, so the phenomenon
does occur on the reduced locus.  It is explicitly only a first-order
obstruction, not a six-dimensional determinant fiber; nonlinear obstruction
equations were the missing input for that abandoned shortcut.  The marked
separator incidences avoid this uniform-fiber problem.

The older F4 generator
[`generate_k1_sixfold.py`](certificates/generate_k1_sixfold.py) and
[`screen log`](certificates/k1_sixfold_screen.log) are retained as
computational provenance, but the conceptual theorem supersedes that partial
27-chart computation for the proper-sixfold row.

## Alternative degree-eight descent route

The following route was the sharpest positive reduction before the
tangent--residual construction.  Its arithmetic descent question remains
interesting, but it is not needed for the affirmative theorem above.

Choose a smooth point \(p\in\Delta\) and the pencil of lines through \(p\).
Over \(K=\mathbf C(t)\), restriction to the generic line gives a conic-bundle
surface with nine singular fibers, one a fixed split fiber at \(p\).  Put that
fiber in the form \(x_1x_2=0\), choose a component, substitute
\(x_1=uX_0\), and divide the equation by \(u\).  The transformed coefficients
have degrees

\[
(4,3,3,2,2,2),
\]

so this is a degree-eight conic bundle of balanced type \((2,1,1)\), in
\(\mathbf P(\mathcal O(2)\oplus\mathcal O(1)\oplus\mathcal O(1))\).
The coefficient calculation, its inverse, and the arithmetic descent argument
are recorded in
[`certificates/degree8_descent.md`](certificates/degree8_descent.md).

This is optimal among reductions obtained from a rational pencil or ruling of a
birational model of the base: the residual discriminant degree is the degree of
the induced map \(\Delta\to\mathbf P^1\), and a smooth plane nonic has gonality
8, attained by projection from a point of the curve.  It does not rule out
unrelated birational constructions.

[The Casarotti--Gammelgaard--Massarenti preprint, Theorem
3.10](https://arxiv.org/abs/2511.17213) proves that, over \(K=\mathbf C(t)\),
the general point of a Zariski-dense subset is \(K\)-unirational for this
balanced type.  It proves a general/open result only for type \((3,1,0)\).
In the balanced coefficient space
\(V\simeq\mathbf P^{21}\), its fixed equal-tangent locus is a rational
16-dimensional quadric \(U\), and

\[
\operatorname{Aut}(T_{2,1,1})\times U\longrightarrow V
\]

is dominant; the geometric generic fiber has dimension \(11+16-21=6\).

The geometric-incidence and arithmetic-descent deductions below are not
statements quoted from the preprint; they are the audited arguments of this
resolution.

With the point, component, and coordinates of the elementary transform fixed,
the transform and its inverse identify its coefficient space with the
hyperplane

\[
H_z=\{Q(z)=0\}=\{a(0)=0\}\simeq\mathbf P^{20}.
\]

The dense CGM image is invariant under the automorphism group, which is
transitive on \(T_{2,1,1}\setminus\{y_0=0\}\).  The universal incidence of a
form and a point therefore shows that the CGM image meets every such
\(H_z\) densely.  Together with the surjectivity of restriction of ternary
cubics to a fixed line, this proves geometric membership for a general point
of the universal marked coefficient family.

This membership persists after fixing a general \(X\).  Indeed, the incidence

\[
\widetilde{\mathcal C}=
\{(A,p,L):p\in\mathbf P_y^2, L\subset\mathbf P_x^2, A(p)|_L=0\}
\]

is a \(\mathbf P^{56}\)-bundle over
\(\mathbf P_y^2\times(\mathbf P_x^2)^*\), hence is irreducible of dimension
60 and dominates \(\mathbf P_A^{59}\).  Its general fiber parametrizes a
point \(p\in\Delta_A\) together with a chosen component \(L\) of the singular
conic.  After choosing base and fiber frames and passing to
\(K=\mathbf C(t)\), the restriction maps

\[
H^0(\mathcal O_{\mathbf P^2}(3))\twoheadrightarrow H^0(\mathcal O_{\mathbf
P^1_K}(3)),
\qquad
H^0(\mathcal I_p(3))\twoheadrightarrow uH^0(\mathcal O_{\mathbf P^1_K}(2))
\]

make the transform map to \(H_z\) dominant.  Pulling back a nonempty invariant
open contained in the CGM image gives a dense open in this irreducible framed
incidence.  It meets the general fixed-\(A\) fiber in a nonempty open.
Consequently, for a general fixed \(X\), a nonempty open set of pairs
\((p,L)\) has transformed surface in the geometric CGM good image.

Thus geometric membership is no longer a gap.  It gives only a
\(\overline K\)-point of the CGM fiber, however, not a \(K\)-point.

The missing assertion for the equal-tangent route can be stated precisely.  Let
\(U^\circ\) be the open part of the paper's equal-tangent locus where its
remaining generality hypotheses hold.  For the transformed surface \(Q\), prove
that

\[
I_Q^\circ=
\{g\in\operatorname{Aut}(T_{2,1,1}):g^{-1}Q\in U^\circ\}
\]

has a \(K\)-point.  Geometrically, a point of this good locus chooses two points
on distinct fibers whose images on the quartic-with-double-line model share a
tangent plane, and the construction produces a geometrically integral rational
two-section.  On a dense open, \(I_Q^\circ\) is a rational
five-dimensional bundle over the curve of ordered equal-tangent pairs: the
five-dimensional fiber is the rational stabilizer of two ordered points on
distinct fibers.  Thus \(I_Q^\circ\) has dimension six, but this description
does not make its total space rational and supplies no point on the contact
curve.

There is a strictly weaker sufficient descent condition.  Let
\(C_Q^{\mathrm{un},\circ}\) be the admissible open of the quotient of the
ordered contact curve by swapping its two points.  Here admissibility includes
the geometrically integral quartic section with three noncollinear ordinary
nodes and a geometrically integral conic Cremona image.  A
\(K\)-point of \(C_Q^{\mathrm{un},\circ}\) gives a Galois-stable length-two
subscheme \(p+q\) on \(Q\), even if neither point is individually rational.
Its image \(p'+q'\) on the quartic, the common tangent plane, and the third
node \(x\) where that plane meets the double line are defined over \(K\).
The quadratic Cremona transformation through \(p'+q'+x\) is defined over
\(K\) and sends the plane quartic two-section to a conic.  The \(C_1\)
property of \(K=\mathbf C(t)\) gives a
point on this final conic, hence a rational two-section.  A point merely on a
compactification, at coincident contacts, on \(\{y_0=0\}\), or on the same
fiber does not suffice.

The contact curve now has an explicit binary-sextic model.  For a plane
\(\Pi=(\ell_0:\ell_1:\ell_2:\ell_3)\) in the quartic model, put

\[
L_{\Pi,s}=(\ell_0s_0+\ell_1s_1,\ell_2,\ell_3),\qquad
R_\Pi=L_{\Pi,s}^{\mathsf T}\operatorname{adj}(M(s))L_{\Pi,s}.
\]

Then \(R_\Pi\) is a binary sextic.  On the admissible integral locus, the
two equal-tangent contacts are equivalent to

\[
R_\Pi=g_2^2h_2,
\]

where \(g_2,h_2\) are square-free coprime binary quadratics.  Thus the
unordered contact curve is the admissible open of the fiber product of the
rational quadratic map
\(\rho_Q:\mathbf P^3_\Pi\dashrightarrow\mathbf P^6\) with
\((g,h)\mapsto g^2h\) from \(\mathbf P^2\times\mathbf P^2\).

This model gives useful but deliberately conditional intersection numbers.
If the rational branch map is resolved without excess components and the
diagonal pullback is a regular connected curve, its class has plane degree
96, canonical degree 528, and arithmetic genus 265.  In the correctly
compactified pencil on \(\mathbb F_1=\operatorname{Bl}_p\mathbf P^2\), the
fixed-root construction has expected degree 48 over the direction line and,
under the analogous regularity assumptions, virtual arithmetic genus 705.
Base points and boundary singularities have not been controlled for the
special family attached to a fixed general \(X\), so these are **not** claims
about the geometric genus or irreducible components of its actual contact
curve.  In particular they neither prove nor exclude a rational component
dominating the direction line.  The model, Chow calculation, and all
qualifications are in
[`contact_curve_model.md`](certificates/descent_work/contact_curve_model.md).

Two tempting shortcuts can also be ruled out exactly.  The tangent plane at
the marked transformed point pulls back to the other component of the old
split fiber and hence cuts the already excluded class-\((1,0)\) K3 surface.
The determinant-preserving lattice shift from type \((2,1,1)\) to
\((3,1,0)\) would require, after choosing a low-weight direction,
\(g(0)=0\) and \(u^2\mid h\); the marked point does not impose these jet
conditions.  Therefore the open type-\((3,1,0)\) theorem cannot be invoked by
that formal shift.

Neither dominance nor the \(C_1\) property proves that either
\(I_Q^\circ(K)\) or \(C_Q^{\mathrm{un},\circ}(K)\) is nonempty.  Nor does an
arbitrary finite residue extension close the direct argument.  A closed point
over \(L=\mathbf C(B)\) spreads to a ruled surface over \(B\); this gives a
rational horizontal surface only when the cover is rational, equivalently
when the construction is realized after a finite extension
\(\mathbf C(s)/\mathbf C(t)\).  A positive-genus \(B\) cannot be dominated by
\(\mathbf P^1\) by Riemann--Hurwitz.  This limitation and the failure of the
standard all-class obstruction shortcuts are proved in
[`program_limits.md`](certificates/alternate_work/program_limits.md).

For even one fixed choice of \(p\), a \(K\)-point under either sufficient
criterion would give the rational two-section just described.  Spreading it
over the pencil parameter would produce a horizontal rational surface in
\(X\) and prove unirationality.  These conditions are sufficient for this
construction, not necessary for unirationality by some other route.  They are
the exact unresolved conditions internal to this alternative route, not gaps
in the tangent--residual proof or in the headline answer.

## Why the standard negative shortcuts did not resolve the question

The Enriques equivalence does not reduce the negative problem to degree two.
If the geometric generic member were unirational, then after a generically
finite change of the 59-dimensional parameter base one fixed divisor class
\((a,b)\) would occur in a dominating rational-map/Hilbert family.  This is
an existential boundedness statement, not an effective bound on \((a,b)\).
Moreover, a degree-\(2a\) splitting field of the generic conic need not have a
quadratic intermediate field: primitive even-degree covers occur.  Therefore
even a complete exclusion of every \((1,b)\) surface would not exclude
rational multisections of degrees 4, 6, and higher.

The standard torsion unramified invariants of the smooth threefold are also
silent.  Lefschetz, universal coefficients, and
\(H^2(X,\mathcal O_X)=0\) give

\[
\operatorname{Br}(X)=0.
\]

[Colliot-Th\'el\`ene--Voisin, Theorem
1.2](https://arxiv.org/abs/1005.2778) gives
\(H^3_{\mathrm{nr}}(X,\mathbf Q/\mathbf Z(2))=0\) for this uniruled complex
threefold, and torsion cohomological dimension three removes the higher
standard Galois-cohomology groups.  This rules out the ordinary unramified
cohomology program, not every conceivable invariant.

The [B\"ohning--Graf von Bothmer](https://arxiv.org/abs/1605.03029)
specialization for \((2,3)\) proves failure of coefficient one in the
decomposition-of-diagonal sense, but its odd-degree reducible degeneration
does not establish a divisibility obstruction for every possible degree of a
unirational map.  Finally, a generically finite parametrization would make the
intermediate Jacobian only an isogeny factor of a product of Jacobians, and
every complex abelian variety satisfies that condition.  The detailed proofs
and qualifications are in
[`program_limits.md`](certificates/alternate_work/program_limits.md).

## Completion criteria and how they are met

1. The construction must work for every smooth characteristic-zero equation,
   not one sample or merely a coefficient-space open.  The generic cubic is
   smooth and nonconstant; its residual-line Lattès map cannot descend to the
   constant field because its critical-value sextic recovers that cubic.
   Hence a suitable constant line `L` always exists.
2. The source of the horizontal map must be rational.  Here
   \(S\to L\simeq\mathbf P^1\) has a rational generic conic by Tsen, so
   \(\mathbf C(S)=\mathbf C(t)(z)\).
3. Horizontality must be proved, not inferred from a sample.  If the residual
   image for the selected `L` were vertical, its fiber degrees and
   \(\operatorname{Pic}(X)=\mathbf ZH_x\oplus\mathbf ZH_y\) would force it
   to be a constant line section, contradicting the choice of `L`.
4. The parametrization degree must remain bounded after specialization.  The
   universal resultant gives a divisor of nominal class `(10,1)`; removing
   common factors and special vertical components leaves
   \([T]=aH_x+H_y\) with \(1\le a\le10\), hence degree \(2a\le20\).
5. The rational source must actually supply a point on the pulled-back conic.
   The map \(S\dashrightarrow T\subset X\) is birational, and the inclusion of
   \(T\) is the tautological point after base change.
6. The exact generic refinement must still be verified.  The
   tangent--residual checker verifies the universal resultant identity,
   coefficient degree and primitivity, a base-factor-free specialization, the
   smooth distinct-residual witness, and the generic degree-20 divisor
   arithmetic; its output matches the committed log.

The earlier standards remain relevant to the independent exclusion
certificates: a single finite-field hit does not establish generality, and
finite searches cannot establish a global negative answer.  They no longer
limit the positive theorem proved here.
