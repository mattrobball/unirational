# Goal D theorem and bridge audit

## 1. Binary route verdict

The exact exit is:

~~~text
D-INVARIANT-REPRODUCIBLE
~~~

The selected closure invariant consists of:

- the integral \(G\)-lattice \(H^3(X,\mathbf Z)\);
- its rational polarized Hodge realization, at the strength detected by a
  relatively ample splitting;
- the rational \(G\)-Chow motive of \(X\);
- the characteristic-number residues used by the audited
  Rost/Merkurjev-type degree formulas.

The first three are reproduced by the explicit allowed centre in
BLOWUP_CLOSURE.md. The last item yields no congruence because every torsor
twist has index one. Thus this invariant cannot prove the requested negative
headline without new geometric restrictions on which nonlinear centres can
occur.

This verdict is not D-MOTIVE-HEADLINE-NEGATIVE: the main Klein-cubic problem
remains open.

## 2. The relative-dimension-one bridge

Let

\[
f:Z^4\longrightarrow X^3
\]

be a projective dominant \(G\)-morphism obtained after resolving a
hypothetical rational map from \(\mathbf P^4\). Let \(L\) be a
\(G\)-linearized relatively ample line bundle and put
\(\lambda=c_1(L)\). On integral cohomology, or in any oriented theory where
the projection formula is available, define

\[
i=f^*,\qquad r(\beta)=f_*(\lambda\cdot\beta).
\]

Since \(f_*(\lambda)=n[X]\), where

\[
n=\deg(L|_{Z_\eta})>0
\]

is the degree on the generic curve fibre, the projection formula gives the
exact identity

\[
\boxed{r\circ i=n\,\mathrm{id}.}
\tag{2.1}
\]

Consequences:

1. \(i\) is injective over \(\mathbf Q\), and integrally when the target
   cohomology is torsion-free.
2. The image need not be primitive. Modulo a prime dividing \(n\), (2.1)
   gives no splitting and reduction of \(i\) need not remain injective.
3. The target is a summand only with coefficients in \(\mathbf Z[1/n]\).
4. Replacing \(L\) by \(L^{\otimes m}\) replaces \(n\) by \(mn\); the
   hypothesis supplies no canonical degree.
5. A divisor representing \(\lambda\) gives a generically finite cycle over
   \(X\) of degree \(n\), after resolving its components. A smooth
   \(G\)-stable divisor is not automatic; orbit-summing a divisor is enough
   for a correspondence but multiplies its degree by an orbit size.

Therefore a statement that the integral or mod-\(p\) motive of \(X\) is a
summand is not a consequence of relative-dimension-one dominance. It would
require an independently proved \(n=1\), or at least \(p\nmid n\), statement.
That missing hypothesis is precisely why Goal D prohibits applying a
same-dimension formula directly to \(f\).

## 3. Degree-formula audit

| theorem family | exact applicable input | output | result here |
|---|---|---|---|
| Merkurjev, Steenrod degree formula, Theorem 6.4 | a projective morphism of projective varieties of the same positive dimension; characteristic prime to \(p\) | \(R_p(Y)=\deg(Y/X)R_p(X)\) in \(\mathbf Z/n_X\mathbf Z\) | after a multisection reduction it applies, but \(n_X=1\) on every twist, so the target group is zero |
| Rost degree formula and canonical \(p\)-dimension | a same-dimensional rational map or correspondence plus a nonzero index-valued characteristic number | non-compressibility when the index and characteristic number meet the required divisibility hypotheses | the Klein twist has index one, so the needed nonzero residue cannot exist |
| Levine--Morel algebraic-cobordism degree formula | a same-dimensional projective morphism, with lower-dimensional correction terms | a cobordism relation between source, degree times target, and images of lower-dimensional varieties | arbitrary nonlinear blowup centres supply correction terms; BLOWUP_CLOSURE.md reproduces the middle motive |
| connective \(K\)-theory and Euler-characteristic formulas | same-dimensional projective data and an index modulus | congruences involving \(\chi(\mathcal O)\) and characteristic numbers | \(\chi(\mathcal O_X)=1\), but the modulus is again \(n_X=1\) |
| equivariant localization | a specified equivariant oriented theory, localization of Euler classes, and complete fixed and exceptional data | equality in a localized coefficient ring | localization denominators erase the sought integral conclusion, and resolved exceptional terms remain; no audited theorem converts this into a relative-dimension-one integral congruence |

Merkurjev's theorem explicitly defines \(n_X\) as the gcd of closed-point
degrees and states the formula in \(\mathbf Z/n_X\mathbf Z\). It also
explicitly assumes equal dimensions. Those are load-bearing hypotheses.

## 4. Why the index modulus is zero

For every \(G\)-torsor \(T/K\), the twisted Klein cubic \(X_T\) lies in a
split \(\mathbf P^4_K\). The installed fixed-point theorem gives effective
zero-cycles of degrees

\[
60,\quad132,\quad165,\quad220
\]

from \(C_{11},C_5,V_4,C_3\), respectively. The exact identity

\[
-13\cdot60+3\cdot132+165+220=1
\]

therefore proves

\[
\boxed{\operatorname{ind}(X_T)=1\quad\text{for every }T/K.}
\tag{4.1}
\]

For a cubic threefold,

\[
c(T_X)=\frac{(1+H)^5}{1+3H}
=1+2H+4H^2-2H^3,
\]

and \(\int_XH^3=3\). Hence

\[
c_1^3=24,\qquad c_1c_2=24,\qquad c_3=-6,
\]

and the third Newton number is

\[
s_3(T_X)=c_1^3-3c_1c_2+3c_3=-66.
\]

For the \(p=2\), dimension-three additive class, the class of \(-T_X\) has
degree \(66\), so the half-number is \(33\). Its residue nevertheless lives
in

\[
\mathbf Z/\operatorname{ind}(X_T)\mathbf Z
=\mathbf Z/1\mathbf Z.
\]

Thus even the numerically odd Rost input is zero in the theorem's actual
target group.

## 5. Motive theorem audit

The smooth blowup formula for a codimension-\(c\) centre \(C\subset V\) is

\[
h(\operatorname{Bl}_C V)
\simeq h(V)\oplus\bigoplus_{j=1}^{c-1}h(C)(j).
\tag{5.1}
\]

It is equivariant when the centre is \(G\)-stable. In a fourfold, a curve
centre has codimension three and contributes \(h^1(C)(1)\) to degree three.

For a smooth cubic threefold, the rational Chow--Künneth decomposition has
the form

\[
h(X)_{\mathbf Q}\simeq
\mathbf1\oplus\mathbf L\oplus h^1(J(X))(1)
\oplus\mathbf L^2\oplus\mathbf L^3.
\tag{5.2}
\]

Projection from a general line produces a smooth plane quintic \(\Gamma\), a
connected étale double cover
\(\widetilde\Gamma\to\Gamma\), and the classical Prym identification

\[
J(X)\simeq\operatorname{Prym}(\widetilde\Gamma/\Gamma).
\tag{5.3}
\]

The projector \((1-\iota)/2\) makes \(h^1(J(X))\) a rational summand of
\(h^1(\widetilde\Gamma)\). Formula (5.1), applied to the free-orbit
construction in BLOWUP_CLOSURE.md, therefore reproduces the entire rational
\(G\)-motive of \(X\). The factor \(1/2\) is exactly why this is not promoted
to an integral statement.

## 6. Quotient-stack and cohomological branch

The exact equivariant tangent class is

\[
c_G(T_X)=\frac{c_G(W\otimes\mathcal O_X(1))}{1+3H}.
\tag{6.1}
\]

This follows from the equivariant Euler and normal sequences; the invariant
cubic equation supplies the honest linearization of the normal bundle.

The already-audited quotient-stack invariants do not leave a class to use:

- \(\operatorname{Pic}(X)=\mathbf Z[H]\), and \(H\) is honestly
  \(G\)-linearized;
- the equivariant universal-torsor obstruction and all higher Amitsur groups
  vanish, also after restriction to subgroups;
- \(\operatorname{ed}(G;2)=2\), while
  \(\operatorname{ed}(G;p)=1\) for \(p=3,5,11\).

Consequently any quotient-stack obstruction forcing global essential
dimension four would have to be a genuinely new mixed-prime invariant. The
known groups cannot be renamed as such an invariant.

## 7. Scope of the exit

This packet decisively closes the chosen invariant route:

- the degree-formula residue is zero for every twist;
- the integral-summand implication is not a valid theorem under the given
  hypotheses;
- the target integral \(G\)-lattice and rational \(G\)-motive lie inside the
  unrestricted blowup closure.

It does not prove that every possible integral equivariant invariant is
reproducible. In particular, it does not construct an integral equivariant
Chow projector at the bad primes \(2,3,5,11\). Such a projector is not forced
by (2.1), so its absence is not a surviving obstruction to the hypothetical
map.

## 8. Primary references and installed evidence

- A. Merkurjev, *Steenrod operations and degree formulas*, especially
  Theorem 6.4: <https://www.math.ucla.edu/~merkurev/papers/steenrod.pdf>.
- D. Abramovich and J. Wang, *Equivariant resolution of singularities in
  characteristic 0*: <https://arxiv.org/abs/alg-geom/9609013>.
- C. H. Clemens and P. A. Griffiths, *The intermediate Jacobian of the cubic
  threefold*: <https://annals.math.princeton.edu/1972/95-2/p06>.
- C. Vial, *Projectors on the intermediate algebraic Jacobians*:
  <https://arxiv.org/abs/0907.3539>.
- Yu. Tschinkel and Zh. Zhang, *Cohomological obstructions to equivariant
  unirationality*: <https://arxiv.org/abs/2504.10204>.
- F. Scavia, Yu. Tschinkel, and Zh. Zhang, *Birational invariance of higher
  Amitsur groups*: <https://arxiv.org/abs/2605.02763>.
- Installed relative-dimension repair:
  problems/E-klein-cubic/REPAIR.md, Sections 7--8.
- Installed Hodge character screen:
  problems/E-klein-cubic/certificates/hodge_centers/HODGE_CENTER_NECESSITY.md.
- Installed all-twist index and essential-dimension audit:
  problems/E-klein-cubic/tmp/step4_essential_dimension/REPORT.md.
