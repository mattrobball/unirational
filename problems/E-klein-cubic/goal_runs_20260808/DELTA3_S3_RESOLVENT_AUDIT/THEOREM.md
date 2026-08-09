# The first deckless degree: the cubic `S3` resolvent survives

**Date:** 2026-08-08  
**Field:** \(\mathbf C\)  
**Group:** \(G=\operatorname {PSL}_2(\mathbf F_{11})\)  
**Verdict:** degree three is not excluded; each of the normal-closure,
auxiliary-cover, intermediate-Jacobian, and installed fixed-graph screens
passes separately.  No joint geometric realization is claimed.

Let \(X\) be the Klein cubic threefold and suppose that a hypothetical
ambient landing map has produced a dominant \(G\)-equivariant rational
selfmap

\[
 \varphi:X\dashrightarrow X
\]

of degree three.  Put

\[
 L=\mathbf C(X),\qquad K=\varphi^*L\subset L.
\]

This note audits the first branch not eliminated by deck transformations:
\(L/K\) is a non-Galois cubic, hence has trivial deck group, and its normal
closure \(M/K\) has group \(S_3\).  Nothing below constructs \(\varphi\).

## 1. The full group lifts and centralizes `S3`

Let \(\mathcal E\) be the group of semilinear lifts to \(M\) of the given
action of \(G\) on the pair \(L/K\).  Every element of \(G\) extends to the
normal closure, and the kernel consists of the \(K\)-automorphisms of
\(M\).  Thus

\[
 1\longrightarrow S_3\longrightarrow\mathcal E
 \longrightarrow G\longrightarrow1.
 \tag{1.1}
\]

The extension splits in the strongest possible way:

\[
 \boxed{\mathcal E\simeq S_3\times G.}
 \tag{1.2}
\]

Indeed, \(Z(S_3)=1\) and every automorphism of \(S_3\) is inner.  Conjugation
therefore gives a retraction

\[
 c:\mathcal E\longrightarrow\operatorname {Aut}(S_3)
       =\operatorname {Inn}(S_3)\simeq S_3
\]

whose restriction to the kernel is the identity.  Its kernel is the
centralizer \(C_{\mathcal E}(S_3)\), maps isomorphically to \(G\), and
supplies (1.2).

This central copy of \(G\) preserves the cubic subfield
\(L=M^H\), where \(H\cong C_2\) is a point stabilizer in \(S_3\).  Its
restriction to \(L\) is the original action: the difference would be a
\(K\)-automorphism of the deckless cubic \(L/K\), hence the identity.

Thus the normal closure creates no forbidden action of \(G\).  Rather, it
canonically creates a commuting action of \(G\times S_3\) on \(M\).

## 2. The residual correspondence and discriminant cover

At the generic point,

\[
 L\otimes_KL\simeq L\times M.
 \tag{2.1}
\]

The first factor is the diagonal.  The second is the normalization of the
residual component

\[
 R=\overline{X\times_\varphi X-\Delta}.
\]

Both projections \(R\dashrightarrow X\) have generic degree two.  On
function fields they are the two inclusions of conjugate cubic subfields
of \(M\).  The transposition exchanging the two entries is an involution of
\(M\) commuting with \(G\).

There is also the quadratic discriminant field

\[
 D=M^{A_3},\qquad [D:K]=2,
 \tag{2.2}
\]

and \(M/D\) is cyclic of degree three.  On normal projective models one has
the field diagram

\[
 \begin{array}{ccc}
 M&\supset&L=M^{C_2}\\
 \cup&&\cup\\
 D=M^{A_3}&\supset&K=M^{S_3}.
 \end{array}
 \tag{2.3}
\]

The quadratic deck argument from
`FULL_G_SUPERRIGID_SELFMAP_AUDIT` does not apply to either degree-two arrow.
Its contradiction required a deck involution in \(\operatorname {Bir}(X)\)
for an extension whose total field was again \(L\).  Here the residual deck
involution lies in \(\operatorname {Bir}(R)\), and the discriminant
involution lies on the auxiliary cover with field \(D\).  Neither is a
birational selfmap of \(X\).

## 3. The exact branch bound is compatible, and sharp

Let \(Z\to X\) be either connected normal quadratic cover obtained above.
Because \(X\) is smooth and \(\operatorname {Pic}(X)=\mathbf ZH\), its
trace decomposition has the usual form

\[
 \pi_*\mathcal O_Z=\mathcal O_X\oplus\mathcal O_X(-rH),
\]

and its branch divisor satisfies

\[
 B\in|2rH|.
 \tag{3.1}
\]

The branch is nonempty: otherwise purity would make the cover etale, while
the smooth cubic threefold is simply connected.  It is \(G\)-stable.  Since
\(G\) is perfect, its defining semi-invariant is invariant.  The exact
invariant-ring calculation used in `GENERIC_FIBER_STEIN_MORI` says

\[
 H^0(X,\mathcal O_X(m))^G=0\qquad(1\leq m\leq4).
\]

Consequently

\[
 \boxed{2r\geq6,\qquad
        \omega_Z\simeq\pi^*\mathcal O_X((r-2)H).}
 \tag{3.2}
\]

In particular the dualizing sheaf of either auxiliary cover is ample.
This is not a contradiction: neither auxiliary cover is birational to
\(X\), and a general-type threefold may admit a finite map to a Fano
threefold.

The lower bound is attained by an actual auxiliary \(G\)-cover.  The
standard degree-six Klein invariant \(f_6\) restricts nontrivially to \(X\):
at

\[
 (-2,-2,1,2,1)\in X
\]

its value is \(960\).  It is not a square in \(L\).  Otherwise half of its
divisor would define a \(G\)-stable divisor of class \(3H\); perfection of
\(G\) would give a nonzero invariant section of \(\mathcal O_X(3)\), which
does not exist.  The normalization of

\[
 w^2=f_6|_X
 \tag{3.3}
\]

is therefore a connected \(G\)-equivariant double cover with branch class
\(6H\).  This is an auxiliary cover, not the discriminant cover of a
constructed cubic selfmap, but it proves that the exact branch/Hurwitz
target at the first allowed class is nonempty.

## 4. The candidate intermediate-Jacobian norm screen has an exact solution

Roulleau's period lattice gives

\[
 J(X)\simeq E^5,
 \qquad
 E=\mathbf C/\mathbf Z[\nu],
 \qquad
 \nu=\frac{-1+\sqrt{-11}}2.
 \tag{4.1}
\]

Scalar multiplication by \(\nu\) preserves this lattice and commutes with
\(G\).  For the actual theta polarization, its Rosati adjoint is scalar
multiplication by \(\bar\nu\).  Since

\[
 \boxed{\nu\bar\nu=3,}
 \tag{4.2}
\]

the strongest clean polarization identity one could ask of a degree-three
pullback,

\[
 \alpha^\dagger\alpha=[3],
 \tag{4.3}
\]

has the exact integral solution \(\alpha=[\nu]\).  This identity is a sanity
screen, not a theorem-forced equality for a rational map with exceptional
correction terms.

The residual `S3` Hecke operator satisfies generically

\[
 T^2=T+2.
 \tag{4.4}
\]

For the clean solution (4.2), the residual action is
\(T=\alpha\alpha^\dagger-1=2\), and (4.4) becomes \(4=4\).
Thus this clean polarization and residual-correspondence screen is
compatible with degree three.  For a rational map, exceptional
curve-centre summands only weaken this test, as shown in
`FULL_G_SELFMAP_DEGREE/ADDENDUM.md`.

## 5. The installed fixed-graph equations have a common formal witness

The exact normalizer-coupled fixed localization packets admit \(\delta=3\).
For `C11`, with

\[
 q=(1,9,4,3,5),
\]

the coefficient vector

\[
 k=(0,6,0,0,0)\in\mathbf F_{11}^5
 \tag{5.1}
\]

satisfies

\[
 \sum k_sq_s^{-3}=2,
 \qquad
 \sum k_s=2\delta.
\]

Its mixed-degree residues are

\[
 (a_0,a_1,a_2,a_3)=(3,5,1,9)\pmod {11}.
 \tag{5.2}
\]

For `C5`, the \(\delta\equiv3\) row is

\[
 v=(0,0,1,0,0,1,0,0),
\]

with mixed residues \((3,1,2,4)\pmod5\).  For `C3`, the
\(\delta\equiv0\) row is

\[
 u=(0,0,0,2,0,0,0,0,0,1),
\]

and all four mixed residues vanish modulo three.  The odd `V4` equation is
solved by the identity on both three-point orbits.

All three cyclic systems have the single positive integral lift

\[
 \boxed{(a_0,a_1,a_2,a_3)=(3,126,177,9).}
 \tag{5.3}
\]

Indeed, \(a_1=3\cdot42\), \(a_3=3\delta\), and

\[
 126^2\geq3\cdot177,
 \qquad
 177^2\geq126\cdot9.
\]

Thus (5.3) also passes integrality, positivity, and both immediate
Khovanskii--Teissier inequalities.  These are formal fixed restrictions and
bidegrees, not an effective irreducible graph.

## 6. Exact stopping boundary

No individual audited finite screen excludes degree three:

```text
DELTA3-S3-LIFT-EXTENSION-SPLITS-AS-S3-TIMES-G
DELTA3-RESIDUAL-CORRESPONDENCE-HAS-BIDEGREE-TWO
DELTA3-QUADRATIC-DECK-INVOLUTION-IS-NOT-IN-BIR-X
DELTA3-DISCRIMINANT-BRANCH-DEGREE-AT-LEAST-SIX
DELTA3-BRANCH-BOUND-SHARP-BY-INVARIANT-SEXTIC-COVER
DELTA3-IJ-NORM-EQUATION-SOLVED-BY-NU
DELTA3-ALL-FIXED-LOCALIZATION-EQUATIONS-COMPATIBLE
DELTA3-NOT-EXCLUDED
DELTA3-SELFMAP-NOT-CONSTRUCTED
HEADLINE-OPEN
```

There is therefore no remaining theorem-forced finite emptiness target in
the resolvent alone.  To exclude \(\delta=3\), one must use a realizability
condition on the actual ambient landing ideal \(F(P)=0\), or prove that the
normalized cubic Stein model belongs to the terminal, \(\mathbf Q\)-factorial,
rank-one Fano class.  Neither condition is supplied by the `S3` normal
closure.  A bounded CAS search in coordinate degree would again lack an
all-degree cutoff.
