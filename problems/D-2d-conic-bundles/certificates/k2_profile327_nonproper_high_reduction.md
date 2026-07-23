# The nonproper high center in \([3,2^7]\)

## Statement

Let a reduced degree-twelve branch have correction profile

\[
[3,2^7].
\tag{0.1}
\]

For the unloading-defect bound and its singleton corollary below, assume
also that the doubled sextic adjoint system vanishes, as it must when the
resolved double plane is rational.  The local proximity classification
itself does not need this extra hypothesis.

If its unique \(t=3\) center \(q\) is nonproper, then its immediate
predecessor \(p\) is one of the seven \(t=2\) centers, \(p\) is proper,
and \(q\) is free first-near to \(p\).  The local corrected and strict
multiplicities are uniquely

\[
\boxed{(r_p,r_q)=(5,6),\qquad(m_p,m_q)=(5,5).}
\tag{0.2}
\]

There is no separator and no satellite alternative.

For the cubic adjoint, the raw local weights \((1,2)\) unload to the
consistent point basis \((2,1)\), of colength four.  For the doubled
sextic adjoint, the raw weights \((2,4)\) unload to \((3,3)\), of
colength twelve rather than the virtual thirteen.  Thus the nonproper-high
(p<q) subcluster has unloading defect one.  Under the singleton-tree
hypothesis below it is the whole essential high tree, so it consumes
exactly one of the at-most-three defects allowed by sextic-adjoint
vanishing.

In particular, if the other six \(t=2\) centers lie in six distinct
singleton proper-origin trees and \(n\) of them are nonproper, then

\[
\boxed{n\le2.}
\tag{0.3}
\]

This is an intrinsic proximity and adjoint reduction.  It does not by
itself exclude the retained diagrams.

## 1. Exhaustion of the predecessor types

At a canonical center \(v\), write

\[
m_v=\operatorname {mult}_v(B_v^{\rm strict}),\qquad
e_v=\#\{\text{branch exceptional curves through }v\},\qquad
r_v=m_v+e_v.
\tag{1.1}
\]

The exceptional curve created at \(v\) is a branch component exactly when
\(r_v\) is odd, and strict multiplicities satisfy the proximity
inequalities.  Since the displayed profile has no center of \(t\ge4\) and
\(q\) is its unique \(t=3\) center, every predecessor has corrected
multiplicity at most five.

Let \(w\) be the immediate predecessor of \(q\).  One has
\(r_q\in\{6,7\}\) and \(e_q\le2\), hence \(m_q\ge4\).  Nonincrease gives

\[
m_w\ge m_q,\qquad r_w\le5.
\tag{1.2}
\]

The case \(e_q=0\) would give \(m_q\ge6\), contradicting (1.2).
Suppose \(e_q=1\).  Then (1.2) forces

\[
r_q=6,\quad m_q=5,\quad r_w=m_w=5,\quad e_w=0.
\tag{1.3}
\]

The branch exceptional through \(q\) is therefore the exceptional curve
created at \(w\).  If \(q\) were satellite, it would also be proximate to
an older center \(u\), and both \(w\) and \(q\) would load \(u\).  Then
\(m_u\ge m_w+m_q\ge10\), impossible.  Thus \(q\) is free over \(w\).

The center \(w\) must be proper.  If it were nonproper, every predecessor
would have to support its strict multiplicity five.  But \(e_w=0\) says
the exceptional through \(w\) is nonbranch, so its creator has even
corrected multiplicity at most four, an immediate contradiction to
proximity.  Hence \(w=p\) is a proper \(t=2\) center and (1.3) is exactly
(0.2).

Finally suppose \(e_q=2\).  Then \(q\) is the intersection of two branch
exceptionals, created at its immediate predecessor \(w\) and an older
center \(u\).  The point \(w\) is also proximate to \(u\).  Since
\(m_w\ge m_q\ge4\), proximity at \(u\) gives

\[
m_u\ge m_w+m_q\ge8,
\tag{1.4}
\]

again impossible because \(u\) is not a second \(t=3\) center.  This
exhausts every free, satellite, and separator position and proves the
local classification.

## 2. Exact unloading

On the free chain \(p<q\), raw total-transform weights \((a,b)\) have
prime-exceptional coefficients \((a,a+b)\).  A consistent point basis
\((\mu_p,\mu_q)\) must satisfy

\[
\mu_p\ge\mu_q,\qquad
\mu_p\ge a,\qquad
\mu_p+\mu_q\ge a+b.
\tag{2.1}
\]

For the cubic adjoint \((a,b)=(1,2)\), the least solution is
\((2,1)\), with colength

\[
\binom{3}{2}+\binom{2}{2}=4.
\tag{2.2}
\]

For the doubled adjoint \((a,b)=(2,4)\), the least solution is
\((3,3)\), with colength

\[
2\binom{4}{2}=12,
\tag{2.3}
\]

one below the raw virtual value
\(\binom32+\binom52=13\).

The full doubled profile has virtual colength

\[
\binom52+7\binom32=31.
\tag{2.4}
\]

Sextic-adjoint vanishing injects the twenty-eight-dimensional sextic space
into the complete-cluster quotient, so total unloading defect is at most
three.  Under the singleton hypothesis of (0.3), the high tree has no
other essential center and uses one.  A nonproper singleton among the
other six has doubled local ideal \((x^2,y)\), of colength two instead of
three, and therefore uses one further defect.  The seven proper-origin
supports are distinct, so these defects add.  Thus

\[
1+n\le3,\qquad n\le2,
\tag{2.5}
\]

as claimed.

The proximity alternatives, point bases, and defect count are replayed by
[`k2_profile327_nonproper_high_checks.py`](k2_profile327_nonproper_high_checks.py).
