# The repeated-root six-center shortcut audit

## Verdict

Work in the squarefree six-\(t=2\) row of
[`k1_double_decic_frontier.md`](k1_double_decic_frontier.md).  This note
originally isolated the first repeated-root partition and audited two
plausible global shortcuts.  Neither shortcut is a valid proof, but the
partition itself has since been excluded by the direct conic incidence in
[`k1_two_essential_partition_exclusion.md`](k1_two_essential_partition_exclusion.md).

The first repeated-root partition was

\[
\boxed{[2,1,1,1,1].}
\tag{0.1}
\]

Here the entries count essential \(t=2\) centers in each proper-origin tree.
Thus (0.1) consists of one two-essential tree and four singleton trees.  It
is the unique coarsening of the excluded partition
\([1,1,1,1,1,1]\) having five roots.  No subrow of (0.1) is excluded by the
shortcut arguments in this note.  Its adjacent and separated essentials,
free and satellite centers, odd exceptional branch components, and rank-two
base-point positions are instead classified and excluded in
`k1_two_essential_tree_classification.md` and
`k1_two_essential_partition_exclusion.md`.

The exact negative verdict is therefore:

1. the raw adjoint class has the numerical invariants of a homaloidal net,
   but it need not be its mobile class after unloading;
2. the tempting enlargement \(B\in H^0(\mathcal J_{4D}(10))\) does not have
   the required dimension bound: a concrete repeated-root diagram gives a
   twenty-seven-dimensional cluster incidence, although every member of that
   enlarged system has a line component and is therefore outside the retained
   no-low-component locus;
3. a fixed-determinant fiber has a useful uniform dimension bound, but the
   curve-side dimension estimate needed to combine with it requires an
   unproved independence statement for the repeated clusters; and
4. Problem B's completed three-center package does not transfer formally,
   because its low-degree cluster vanishings and its determinant restriction
   spaces are different.

Accordingly, this note is a limits-of-shortcuts result, not the current
frontier.  The later theorem
[`k1_uniform_six_center_conic_exclusion.md`](k1_uniform_six_center_conic_exclusion.md)
excludes every remaining root partition without using either failed
shortcut and closes the squarefree six-center row.

## 1. The raw quintic adjoint and the unloading obstruction

Use the total-transform basis on the canonical resolution \(Y\).  Let

\[
D=\sum_{i=1}^6 E_i
\]

be the sum of the six essential \(t=2\) weights, and let \(D_1\) collect the
\(t=1\) weights.  The natural doubled adjoint class is

\[
M=5H-2D.
\tag{1.1}
\]

The rationality condition \(H^0(\mathcal J_{2D}(4))=0\), Riemann--Roch, and
Serre duality give

\[
M^2=1,\qquad K_YM=-3,\qquad \chi(O_Y(M))=3,
\qquad h^0(O_Y(M))\ge3.
\tag{1.2}
\]

Indeed, \(H^2(O_Y(M))=H^0(O_Y(K_Y-M))=0\), since \(K_Y-M\) has negative
plane degree.  The corrected branch class is

\[
B_Y=10H-4D-2D_1,
\]

and hence, again in the orthogonal total-transform basis,

\[
B_YM=2.
\tag{1.3}
\]

Equations (1.2)--(1.3) are tempting: if \(|M|\) were a base-point-free
two-dimensional net with mobile self-intersection one, it would give a
birational map to \(\mathbf P^2\), and (1.3) would make the branch look like
a conic in that model.  The italicized premise is not available.

The obstruction already occurs in the excluded singleton-root row.  At a
proper essential center the doubled cluster pushes down to
\(\mathfrak m_p^2\), with point basis \((2)\) and self-intersection cost
four.  At a first-near singleton of type

\[
(m_p,m_q)=(3,3),\qquad(r_p,r_q)=(3,4),
\]

the same total-transform weight pushes down, after unloading, to

\[
(x^2,y),
\]

whose point basis is \((1,1)\) and whose self-intersection cost is two.
Consequently, if \(n\) of six singleton centers are first-near, the actual
unloaded mobile class has

\[
M_{\mathrm{mob}}^2
=25-4(6-n)-2n
=1+2n,
\tag{1.4}
\]

not the raw value one unless \(n=0\).  Repeated trees introduce further
proximity interactions, so (1.4) is only a warning example, not a formula
for the retained row.

The degree-one-through-four branch-component exclusions do remove a possible
nonexceptional curve \(C\) for which \(M C<0\): then
\(B_YC=2MC-2D_1C<0\), so the plane image of \(C\) would be a branch
component, necessarily of degree at most four because \(h^0(M)\ge3\).
They do not remove exceptional fixed components created by unloading, nor do
they prove that every fixed or contracted nonexceptional curve has negative
intersection with \(M\).  Thus the low-factor theorem does not repair the
homaloidal argument.

## 2. Exact genus and movement bookkeeping

There is a useful global numerical identity, but it stops short of the needed
incidence theorem.  Let

- \(G\) be the sum of the genera of the normalizations of the original
  reduced branch components;
- \(s\) be the number of those components;
- \(o\) be the number of odd corrected blowups;
- \(n_1\) be the number of \(t=1\) blowups;
- \(n_5\) be the number of the six essential centers having corrected
  multiplicity five; and
- \(n_2\) be the number of \(t=1\) centers having corrected multiplicity
  two.

A decic has arithmetic genus 36.  Each essential \(t=2\) correction lowers
the arithmetic genus of the corrected branch by six, whether its corrected
multiplicity is four or five.  Each \(t=1\) correction lowers it by one.
The final smooth corrected branch has \(s+o\) components.  Therefore

\[
G-(s+o)+1=36-6\cdot6-n_1=-n_1,
\]

or

\[
\boxed{G=s+o-n_1-1=s+n_5-n_2-1.}
\tag{2.1}
\]

The second equality uses
\(o=n_5+n_3\) and \(n_1=n_2+n_3\), where \(n_3\) counts the odd
\(t=1\) centers.

Now let \(m_v\) be the strict-branch multiplicity at a resolution center.
A fixed proper point of multiplicity \(m_v\) has \(m_v\) more linear jet
conditions than its \(\delta\)-contribution; allowing the point to move
refunds two parameters.  At a free infinitely-near center it refunds one,
and at a satellite center none.  Write the resulting expected excess as

\[
\epsilon=\sum_v m_v-
  (2\#\{\text{proper}\}+\#\{\text{free}\}).
\tag{2.2}
\]

At a proper, free, or satellite essential center, respectively, the number
of exceptional branch components through the point is at most zero, one, or
two.  Hence an essential corrected multiplicity four contributes at least
two to (2.2), and corrected multiplicity five contributes at least three.
Every \(t=1\) center contributes nonnegatively.  Thus

\[
\boxed{\epsilon\ge12+n_5.}
\tag{2.3}
\]

The componentwise equigeneric dimension for reduced plane decics with data
\((G,s)\) is at most

\[
30+G-s=29+n_5-n_2.
\tag{2.4}
\]

If the repeated multiplicity clusters imposed all the expected additional
conditions independently in degree ten, then subtracting (2.3) from (2.4)
would give the very strong projective bound

\[
\dim\mathcal C_{\mathrm{frontier}}\le17-n_2\le17.
\tag{2.5}
\]

But (2.5) is conditional.  It amounts to a global
\(T\)-smoothness/jet-surjectivity statement for every retained complete
Enriques diagram.  The two known vanishings

\[
H^0(\mathcal J_D(2))=0,
\qquad H^0(\mathcal J_{2D}(4))=0
\]

do not imply the required degree-ten evaluation surjectivity for the strict
multiplicity point basis.  Proximity and unloading are exactly where the
naive sum of local expected codimensions can acquire superabundance.
Equisingular families are not automatically \(T\)-smooth; see the survey of
Greuel--Shustin,
[*Plane algebraic curves with prescribed singularities*](https://arxiv.org/abs/2008.02640).
This is not a counterexample to (2.5) for the present decics.  It is the
precise missing theorem that prevents (2.5) from being used as a proof.

Without the unsupported subtraction, (2.4) can be as large as 35, far above
the dimension needed below.

## 3. A sharp failure of the \(\mathcal J_{4D}\)-only enlargement

The predecessor divisor \(D_1\) cannot be discarded in order to estimate the
degree-ten system.  Here is a concrete repeated-root test.

Take a free chain

\[
q_0<q_1<q_2<q_3<q_4
\]

over one proper origin.  Mark \(q_0,q_2,q_4\) essential and let \(q_1,q_3\)
be \(t=1\) separators.  Add three distinct proper essential centers
\(r_1,r_2,r_3\).  Thus

\[
D=E_{q_0}+E_{q_2}+E_{q_4}+E_{r_1}+E_{r_2}+E_{r_3}.
\tag{3.1}
\]

Choose affine coordinates at \(q_0\) so that the free chain follows the
successive transforms of \(y=0\).  For a monomial \(x^ay^b\), membership in
the local complete cluster ideal attached to \(nD\) is equivalent to

\[
a+b\ge n,\qquad a+3b\ge2n,\qquad a+5b\ge3n.
\tag{3.2}
\]

Counting the monomials which fail \( (3.2) \), and then adding the independent jets
at the three proper centers, gives

\[
\begin{array}{c|c|c|c|c}
\text{system}&\text{chain rank}&\text{proper rank}&\text{total rank}&h^0\\ \hline
\mathcal J_D(2)&3&3&6&0\\
\mathcal J_{2D}(4)&6&9&15&0\\
\mathcal J_{4D}(10)&21&30&51&15.
\end{array}
\tag{3.3}
\]

These are actual simultaneous ranks, not only sums of local lengths.  For
example, with \(q_0=(0,0)\) and

\[
(r_1,r_2,r_3)=((1,2),(3,1),(2,5)),
\]

the corresponding coefficient/jet matrices have ranks \(6,15,51\).  Rank is
open, so (3.3) holds for a general configuration of this diagram.  The free
five-point chain moves in dimension \(2+4=6\), and the other three proper
points move in dimension six.  Consequently the enlarged incidence of pairs

\[
(D,B),\qquad 0\ne B\in H^0(\mathcal J_{4D}(10)),
\]

has affine dimension

\[
12+15=27.
\tag{3.4}
\]

Thus the proposed bound \(20\) is false for this natural enlargement.  This
does not yet show that the image in the space of branches has dimension
twenty-seven, and it is not a counterexample to the retained branch locus.
Indeed, setting \(b=0\) in the last inequality of \( (3.2) \) would require
\(a\ge12\), impossible in degree ten.  Hence every member of
\(H^0(\mathcal J_{4D}(10))\) is divisible by the tangent line \(y=0\).  The
line-component theorem already excludes this diagram for a general
determinantal branch.

The comparison with the complete canonical weights is nevertheless sharp.
The corrected and strict multiplicity sequences along the chain are

\[
(r_{q_i})=(4,3,4,3,4),\qquad
(m_{q_i})=(4,3,3,3,3).
\tag{3.5}
\]

Thus the full corrected degree-ten class uses chain weights
\((4,2,4,2,4)\), including \(2D_1\).  Unloading gives the strict point basis
\((4,3,3,3,3)\).  Either description has local degree-ten rank twenty-eight;
after the three proper quadruple jets the total rank is fifty-eight.  The
full system therefore has affine dimension eight and the corresponding
cluster incidence has dimension

\[
12+8=20.
\tag{3.6}
\]

It still has the tangent line as a component, since its total contact along
the chain is sixteen.  Equations (3.3)--(3.6) isolate the exact boundary:
the desired global estimate must retain \(D_1\), perform the unloading, and
use the absence of components of degrees one through four.  A bound for
\(H^0(\mathcal J_{4D}(10))\) alone cannot prove it.

## 4. What the fixed-determinant bound does prove

The determinant side of the proposed global count does admit a uniform
bound.  Choose a fixed smooth plane quintic \(T\).

For rank three, restriction of

\[
H^0\bigl(\operatorname {Sym}^2(E^\vee)\otimes O(4)\bigr)
\]

to \(T\) is injective because
\(H^0(\mathcal Q(-5))=0\).  On \(T\), the relevant globally generated
rank-two bundle has degree five and the twisting line bundle has degree
twenty.  For rank two, choose \(T\) away from the base point.  Restriction
of the three coefficient spaces is again injective, since the three kernels
are

\[
H^0(H-2E)=H^0(-E)=H^0(-H)=0,
\]

and the same two degrees are \((5,20)\).

The rank-one-cone estimate from Section 5 of
`k1_double_decic_frontier.md` gives

\[
R(5,20)=31.
\tag{4.1}
\]

Scaling a fixed nonzero determinant fiber to the zero fiber therefore shows
that every fixed-branch fiber in either sixty-dimensional fixed-\(\sigma\)
restriction space has affine dimension at most 31.

If (2.5) were proved, the affine branch cone would have dimension at most 18,
so the bad incidence would have affine dimension at most

\[
18+31=49.
\]

Its fixed-\(\sigma\) codimension would be at least eleven, larger than the
rank-three orbit dimension eight and the rank-two orbit dimension seven.
This would close the entire row.  By contrast, the unconditional maximum 35
from (2.4) gives only \(36+31=67\), which supplies no positive codimension in
a sixty-dimensional source.  Thus the determinant calculation is useful but
not sufficient on its own.

## 5. Why Problem B does not transfer formally

Problem B's class-\((1,1)\) proof eventually excludes all three root
partitions of its squarefree three-\(t=2\) octic row.  In particular it has
detailed theorems for a repeated pair plus a singleton and for a three-center
chain.  Those theorems are structural guides for (0.1), not black-box inputs.

There are two concrete mismatches.

1. The B proofs use the complete three-center vanishings

   \[
   H^0(\mathcal J_D(1))=0,
   \qquad H^0(\mathcal J_{2D}(2))=0,
   \]

   to force particular lines, conics, separators, and contact cubics.
   Selecting a repeated pair and one singleton from the six D centers does
   not give these vanishings for the selected subcluster.  The four omitted
   essential centers also contribute predecessors and odd exceptional
   components to the full cluster.

2. The B determinant restrictions are for an octic and the D restrictions
   are shifted by two degrees.  The residual contact left on a test line or
   conic, the rank-two base-point twist, and every fixed-fiber dimension must
   therefore be recomputed.  Extra D centers need not lie on the B test
   divisor and cannot simply be discarded from the moving-configuration
   count.

The required direct task was a full marked incidence for
\([2,1,1,1,1]\), beginning with a classification of the two-essential tree
including all intervening \(t=1\) centers.  The two companion certificates
cited above retain the full six-center vanishings and verify codimension at
least nine in rank three and eight in rank two.

## 6. Mechanical scope

The accompanying checker
`k1_repeated_root_frontier_checks.py` replays:

- the raw adjoint intersections and Riemann--Roch number;
- the singleton unloading warning (1.4);
- the genus identity (2.1) and charge bound (2.3);
- the conditional and unconditional global dimension arithmetic;
- the sharp repeated-chain ranks (3.3), the enlarged incidence dimension
  twenty-seven, and the full-\(D_1\) dimension twenty;
- the fixed-determinant bound (4.1); and
- the historical first-repeated-partition statement (0.1).

It does not certify the missing jet-independence theorem.  The exclusion of
(0.1) comes from the separate direct conic proof, not from that shortcut.
