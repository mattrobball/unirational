# J2.0 — Goal D audit and base-locus insertion theorem

## 1. What Goal D did and did not prove

Goal D used a genus-eleven Prym curve

\[
\widetilde\Gamma\longrightarrow\Gamma,
\qquad g(\Gamma)=6,\quad g(\widetilde\Gamma)=11,
\]

coming from projection of the cubic threefold from a general line.  Its
Prym is \(J(X)\).  A general embedding in \(\mathbf P(W)\) has a free
660-component orbit, and blowing up that orbit reproduces the target
rational \(G\)-Hodge structure and motive.  Goal D explicitly did **not**
claim that the free orbit belongs to the base locus of a landing covariant.

The missing base-locus condition can be supplied, but the component
stabilizer then changes from \(1\) to \(C_2\).

## 2. A curve carrying both required factors

Fix an involution \(t\) and its fixed elliptic cubic \(E_t\subset P_t\).
On the smooth surface

\[
S=\widetilde\Gamma\times E_t
\]

choose line bundles \(L_1,L_2\) of degrees \(24\) and \(3\), respectively.
They are very ample, and a general member

\[
C\in|\operatorname{pr}_1^*L_1\otimes\operatorname{pr}_2^*L_2|
\]

is smooth and connected.  Adjunction gives

\[
2g(C)-2=C^2+C\cdot K_S
 =2(24)(3)+(2g(\widetilde\Gamma)-2)3=204,
\]

so \(g(C)=103\).  The projections have degrees

\[
\deg(C\to\widetilde\Gamma)=3,
\qquad \deg(C\to E_t)=24.
\]

Consequently \(H^1(C)\) contains both \(H^1(\widetilde\Gamma)\) and
\(H^1(E_t)\); pullback followed by norm is multiplication by \(3\) and
\(24\), respectively.  In particular \(C\) carries the cubic Prym factor,
while its elliptic map has degree divisible by three.

Choose a very ample line bundle of degree \(2g(C)+1=207\) on \(C\) and a
general three-dimensional generating subspace.  It gives a birational plane
model

\[
\nu:C\longrightarrow\overline C\subset P_t\simeq\mathbf P^2.
\]

Genericity avoids the five nonidentity residual \(S_3\)-symmetries of the
plane, so the setwise stabilizer of \(\overline C\) in \(G\) is exactly
\(H=\langle t\rangle\simeq C_2\).

## 3. Base-locus insertion theorem

Let \(p=(p_0,\ldots,p_4)\) be any nonzero primitive homogeneous landing
covariant and \(I_p=(p_0,\ldots,p_4)\).  The accepted all-order local theorem
says that every plus-plane is a base component and that its common first
order \(m\) is odd.  Scheme-theoretically,

\[
I_p\subset I_{P_t}^{(m)}\subset I_{\overline C}^{m}.
\tag{3.1}
\]

Choose \(\overline C\) not contained in the common zero scheme of the leading
order-\(m\) coefficients.  Then the order along its generic point is exactly
\(m\), not merely at least \(m\).

The \(G\)-orbit of \(\overline C\) has \(660/2=330\) components.  They need
not initially be disjoint: the six normalizer translates in \(P_t\) meet by
Bezout, and curves in incident plus-planes can also meet.  Resolve the
singularities and intersections of their reduced union equivariantly, using
centres above that union.  Every such centre lies over the cosupport of
\(I_p\) by (3.1).  Continue blowing intersection strata until the strict
transforms are a disjoint smooth \(G\)-stable union \(D\), and blow up \(D\).
Finally apply equivariant principalization to the remaining transform of
\(I_p\).

The composite is an equivariant log resolution of the **same** five-form
ideal.  The inserted exceptional divisor has coefficient \(m\) at the
generic point of every component.  No common scalar was multiplied into
\(p\), and no new coefficient identity was imposed.

## 4. Audit against every J2.0 screen

| Proposed exclusion | Exact audit |
|---|---|
| containment in the five-form ideal | automatic from \(I_p\subset I_{P_t}^{(m)}\subset I_{\overline C}^m\) |
| degree or regularity | the curve is a permitted resolution refinement; no all-degree Hilbert bound on refinements exists |
| incidence with 55 planes | every orbit component lies in one of the 55 forced planes |
| stabilizer and orbit | \(C_2\), orbit \(330\); six components over a fixed plane |
| normal characters | \(N^+\) has rank one and \(N^-\) rank two |
| conductor/exceptional multiplicity | exactly the odd plane order \(m\) generically |
| primitive minimality | unchanged because \(p\) itself is unchanged |

Thus none of the stated screens excludes the construction.

## 5. The unavoidable dichotomy

If “resolution” means any equivariant log resolution, the theorem above is a
base-locus-constrained countermodel.  If instead one selects a particular
canonical principalization algorithm, the extra curve might not be chosen,
but then its centre one-motive is algorithm-dependent and cannot satisfy
J2.1's demanded invariance under changing the resolution.  No canonical
minimality theorem of the required kind is among the binding inputs.

This proves the scoped exit

```text
J2-UNRESTRICTED-COUNTERMODEL-EXTENDS
```

It does not decide whether \(p\) exists.
