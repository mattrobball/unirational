# Proximity exclusion of the squarefree \([4,3,2]\) profile

## Statement

Let \(B\subset\mathbf P^2\) be a degree-twelve branch divisor, and resolve
it by the canonical double-cover procedure.  There is no reduced \(B\)
whose essential correction profile is

\[
\boxed{[4,3,2].}
\tag{0.1}
\]

More precisely, every proximity/parity realization of (0.1), except one
globally impossible satellite row, forces a line to occur at least twice in
\(B\).  The conclusion is independent of the determinantal presentation of
the branch.  In particular it excludes the \([4,3,2]\) row for every
squarefree quadratic-triple branch, including triples with an isolated base
scheme.

Terminal or side \(t=1\) centers containing no essential descendant are not
part of the essential span.  They do not affect the argument below.  Every
\(t=1\) center which does lie in the essential span is included in the
classification.

## 1. Conventions and the two-pass line lemma

At a canonical center \(v\), use the notation

\[
m_v=\operatorname {mult}_v(B_v^{\mathrm {strict}}),\qquad
e_v=\#\{\text{branch exceptionals through }v\},\qquad
r_v=m_v+e_v.
\tag{1.1}
\]

The exceptional created at \(v\) belongs to the corrected branch exactly
when \(r_v\) is odd.  If \(v\) is proximate to the centers in \(P(v)\),
then

\[
e_v=\sum_{u\in P(v)}(r_u\bmod2),
\qquad
m_u\geq\sum_{v\succ u}m_v.
\tag{1.2}
\]

The second relation is the proximity inequality for strict
multiplicities.

We repeatedly use the following elementary form of Bezout.  Suppose a line
\(L\) follows marked proper and infinitely-near centers
\(v_1,\ldots,v_s\) of a degree-\(d\) divisor \(C\).  If

\[
\sum_i m_{v_i}>d,
\tag{1.3}
\]

then \(L\) is a component of \(C\).  If it occurs only once, put
\(C'=C-L\).  At every marked center followed by \(L\), the strict
multiplicity drops by one.  Therefore

\[
\sum_i(m_{v_i}-1)>d-1
\tag{1.4}
\]

forces \(L\) to be a component of \(C'\), so \(L^2\mid C\).  The same
argument applies to a line joining two distinct proper clusters, by adding
the local intersection contributions at its two endpoints.

There is one useful alternative.  Suppose \(q\) is proximate to \(p\), a
forced line component passes through \(p\), and its strict transform does
not pass through \(q\).  Subtracting the line lowers \(m_p\) but not
\(m_q\).  If this makes \(m_p-1<m_q\), the residual divisor violates
proximity.  Thus either the line follows \(q\), or the proposed cluster is
impossible.

## 2. Exhaustive structural reduction

For the four possible correction weights, the corrected and strict
multiplicities satisfy

\[
\begin{array}{c|c|c}
t&r&\text{possible range of }m=r-e\\ \hline
4&8,9&6\le m\le9\\
3&6,7&4\le m\le7\\
2&4,5&2\le m\le5\\
1&2,3&0\le m\le3.
\end{array}
\tag{2.1}
\]

Consequently no negligible center can immediately precede a \(t=3\) or
\(t=4\) center.  A nonproper \(t=4\) center has a \(t=3\) predecessor,
and a nonproper \(t=3\) center has a \(t=4\) or \(t=2\) predecessor.

The \(t=4\) and \(t=3\) centers in one proper-origin tree are comparable.
Indeed, if their paths fork after a center \(a\), the first centers on the
two paths have strict multiplicities at least six and four.  Proximity
would give \(m_a\ge10\), while every center in this profile has
\(m_a\le r_a\le9\).

It remains to audit the two upward parity jumps and the possible
\(4\to2\to3\) chain.

### 2.1 The jump \(2\to3\)

Let \(p\) be a \(t=2\) center immediately preceding the \(t=3\) center
\(q\).  Put \(\epsilon=r_p\bmod2\).  If \(q\) is satellite, let \(\delta\)
be the branch status of its older exceptional; otherwise put
\(\delta=0\).  Then

\[
e_q=\epsilon+\delta,\qquad e_p\ge\delta,\qquad
m_p=r_p-e_p,\qquad m_q=r_q-\epsilon-\delta.
\tag{2.2}
\]

The inequality \(m_p\ge m_q\) first forces

\[
(r_p,r_q)=(5,6),\qquad e_p=\delta,\qquad
(m_p,m_q)=(5-\delta,5-\delta).
\tag{2.3}
\]

If \(\delta=0\) and \(p\) is proper, this is the free chain

\[
(r;m)=(5,6;5,5).
\tag{2.4}
\]

If \(p\) is nonproper, its predecessor must be the \(t=4\) center.  Its
exceptional is nonbranch, and (2.3) gives the successive-free row

\[
F_{423}:\quad
(r_4,r_2,r_3)=(8,5,6),\qquad(m_4,m_2,m_3)=(8,5,5).
\tag{2.5}
\]

If \(\delta=1\), both \(p\) and \(q\) are proximate to the creator of the
older branch exceptional.  Proximity forces that creator to be the
\(t=4\) center, and the unique row is

\[
S_{423}:\quad
(r_4,r_2,r_3)=(9,5,6),\qquad(m_4,m_2,m_3)=(9,4,4),
\tag{2.6}
\]

where the \(t=2\) center is free over the \(t=4\) center and the \(t=3\)
center is satellite to both.

### 2.2 The jump \(3\to4\)

Apply the same calculation with
\(r_p\in\{6,7\}\) and \(r_q\in\{8,9\}\).  The only numerical solution is

\[
A_{34}:\quad
(r_3,r_4)=(7,8),\qquad(e_3,e_4)=(0,1),\qquad
(m_3,m_4)=(7,7).
\tag{2.7}
\]

The \(t=3\) center is proper and the \(t=4\) center is its free first-near
successor.  The satellite alternative would make the older creator carry
proximate load at least twelve, which is impossible in this profile.

### 2.3 Negligible centers

Every negligible center in the essential span lies on the path to the
unique \(t=2\) center.  There is at most one.  To see this, let \(z\) be
the last negligible predecessor of the \(t=2\) center \(q\).  If
\(e_q=0\), then \(m_q\ge4>m_z\).  If \(e_q=1\), the only possible
continuation has

\[
(r_z,e_z,m_z;r_q,e_q,m_q)=(3,0,3;4,1,3),
\]

and \(z\) cannot itself have a negligible predecessor.  If \(e_q=2\), the
only possible continuation has strict multiplicities \((m_z,m_q)=(2,2)\).
Both \(z\) and \(q\) are then proximate to the older branch-exceptional
creator, so that creator has load at least four and is essential.  Again
there is only one negligible center.

Thus the essential span has three or four centers.  Exact enumeration of
all free and satellite Enriques diagrams, both parities at every center,
and all proximity inequalities gives respectively 55 and 30 diagrams.
They collapse to the following six classes.

\[
\begin{array}{c|l|r}
\text{class}&\text{high-center core}&\text{number of diagrams}\\ \hline
D_{43}&t=4\text{ and }t=3\text{ proper at distinct roots}&40\\
D_{4|23}&t=4\text{ proper, separate from the free chain }(2.4)&2\\
A_{43}&t=4\text{ proper, }t=3\text{ free first-near}&34\\
A_{34}&\text{the exact row }(2.7)&7\\
F_{423}&\text{the exact row }(2.5)&1\\
S_{423}&\text{the exact row }(2.6)&1.
\end{array}
\tag{2.8}
\]

The counts include every allowed position and parity of the remaining
\(t=2\) center and of the possible negligible center.  Their sum is
\(85=55+30\).  The accompanying checker constructs the diagrams rather
than storing this table.

## 3. Every class is excluded

### 3.1 Distinct proper \(t=4\) and \(t=3\) centers

In class \(D_{43}\), let \(L\) join the two proper centers.  Their strict
multiplicities are at least eight and six, so

\[
I(B,L)\ge8+6=14>12.
\]

After subtracting \(L\), the residual contact is at least

\[
(8-1)+(6-1)=12>11.
\]

The two-pass line lemma gives \(L^2\mid B\).

### 3.2 Adjacent \(t=4\) and \(t=3\) centers

In class \(A_{43}\), write

\[
r_4=8+a,\qquad r_3=6+b,\qquad a,b\in\{0,1\}.
\]

The centers are a proper point and a free first-near point, so

\[
m_4+m_3=(8+a)+(6+b-a)=14+b.
\tag{3.1}
\]

The tangent line therefore occurs twice by the two-pass lemma.  In class
\(A_{34}\), (2.7) gives the same contact \(7+7=14\), with the same
conclusion.

### 3.3 The free \(2\to3\) rows

In class \(D_{4|23}\), join the proper \(t=4\) center to the proper
\(t=2\) center in (2.4).  In class \(F_{423}\), take the tangent line at
the \(t=4\) center represented by the free \(t=2\) successor.  In both
cases

\[
m_4+m_2\ge8+5=13>12,
\tag{3.2}
\]

so the selected line is a component.  If its strict transform does not
pass through the following \(t=3\) center, subtracting the line changes
\(m_2=5\) to four but leaves \(m_3=5\), contradicting proximity.  Hence
the line follows all three marked centers.  After subtracting it, its
residual contact is at least

\[
(8-1)+(5-1)+(5-1)=15>11.
\]

It is therefore a doubled line.

### 3.4 The satellite row

In \(S_{423}\), let \(L\) be the tangent line represented by the free
\(t=2\) center.  Equation (2.6) gives

\[
m_4+m_2=9+4=13>12,
\]

so \(L\) is a component.  After the two indicated blowups, the strict
transform of a line does not pass through the satellite point
\(E_4\cap E_2\).  Subtracting \(L\) consequently changes \(m_2=4\) to
three and leaves \(m_3=4\), violating proximity.  Thus this numerical row
is not realized by any degree-twelve plane divisor.

Every realization in (2.8) is now excluded: five classes force a doubled
line, and the sixth is globally impossible.  A squarefree branch has no
doubled component, proving (0.1).
