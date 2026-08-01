# Exact degree-three multisection and minimal-degree dichotomy

## Statement

Let

\[
 X\xleftarrow{\pi}Y=\operatorname{Bl}_C X
   \xrightarrow{f}B=\mathbf P^1_{K_0}
\]

be the exact `xCD` plane-cubic fibration.  Then:

1. \(f\) has a connected integral constant-field multisection of exact degree
   three, with normalization \(\mathbf P^1_{K_3}\) for a cubic field
   \(K_3/K_0\);
2. every degree-one multisection is a rational section;
3. every degree-two multisection produces a rational section;
4. consequently the minimum multisection degree is one if a section exists,
   and otherwise it is exactly three.

In particular, the previously constructed degree-55 multisection is not
minimal.

## 1. The exceptional divisor

The center \(C=X\cap\Pi\) is a smooth plane cubic over \(K_0\), and

\[
 N_{C/X}\simeq\mathcal O_C(1)\oplus\mathcal O_C(1).
\]

Hence

\[
 E=\mathbf P_C(N_{C/X})\simeq C\times\mathbf P^1_{K_0}.
\]

In the graph model

\[
 Y=\{\Phi(a)=0,\ a_3t-a_4s=0\}
   \subset\mathbf P^4_a\times\mathbf P^1_{[s:t]},
\]

the exceptional direction \([s:t]\) is exactly the pencil coordinate.
Thus

\[
 f|_E:C\times B\longrightarrow B
\]

is the second projection.

## 2. A connected cubic point on the center

The sealed `xCD` theorem proves

\[
 C(K_0)=\varnothing. \tag{1}
\]

The field \(K_0\) is infinite.  In the dual plane, the lines transverse to
the smooth cubic \(C\) form a nonempty Zariski-open subset, so choose a
\(K_0\)-line \(\lambda\) in that open.  Then

\[
 Z=C\cap\lambda
\]

is finite etale of degree three over \(K_0\).

If \(Z\) were disconnected, its finite-etale algebra would have a field
factor of degree one: the only nontrivial partition of three is
\(3=1+2\) (or \(1+1+1\)).  That factor would give a \(K_0\)-point of
\(C\), contradicting (1).  Therefore

\[
 Z=\operatorname{Spec}K_3,
 \qquad [K_3:K_0]=3.
\]

## 3. The degree-three constant-field multisection

Embed

\[
 M_3=Z\times_{K_0}B\hookrightarrow C\times B=E\hookrightarrow Y.
\]

Since \(Z=\operatorname{Spec}K_3\),

\[
 M_3\simeq B_{K_3}\simeq\mathbf P^1_{K_3}.
\]

It is integral over \(K_0\), rational over its constant field \(K_3\), and
the composite

\[
 M_3\longrightarrow B
\]

is the constant-field finite-etale cover of exact degree three.  This is an
actual connected integral multisection, not merely a degree-three zero-cycle
on the generic fibre.

The field of constants matters: \(M_3\) is not \(K_0\)-rational and is not
geometrically integral over \(K_0\).  Thus, if one reserves the phrase
"rational multisection" for a \(K_0\)-rational or geometrically integral
curve, this construction is not a rational multisection in that stricter
sense.  It is a \(K_3\)-rational integral constant-field multisection.

All ingredients are defined on the \(K_0\)-twist.  Equivalently, after
untwisting, the construction is stable under the semilinear descent datum.
No choice of one of the three geometric points is made over \(K_0\).  This
must not be rephrased as an ordinary three-element \(G\)-orbit: the simple
group \(G=\operatorname{PSL}_2(\mathbf F_{11})\) has no subgroup of index
three, so \(K_3\) is not a cubic subfield of the generic \(G\)-torsor field.

## 4. Why degree two forces degree one

Let \(K=K_0(B)\), and let \(S/K\subset\mathbf P^3_K\) be the smooth cubic-
surface generic fibre.  A degree-two multisection gives an effective
degree-two zero-cycle \(D\) on \(S\).

If \(D\) has a degree-one component, then \(S(K)\ne\varnothing\).  Otherwise
\(D\) is one separable quadratic point.  Its two geometric conjugates span a
\(K\)-line \(\ell\subset\mathbf P^3_K\).  If \(\ell\not\subset S\), the
cubic divisor \(\ell\cap S\) has \(D\) plus a residual degree-one divisor,
which is a \(K\)-point.  If \(\ell\subset S\), then the \(K\)-line itself
has \(K\)-points.  In all cases

\[
 \text{degree-two multisection}\Longrightarrow S(K)\ne\varnothing.
\]

Because \(f\) is proper over the smooth curve \(B\), the generic point
extends to a rational section.  Thus a degree-two multisection can exist only
when a degree-one multisection already exists.

## 5. Exact minimum

A degree-one multisection is a rational section by definition.  We have
constructed degree three, and degree two implies degree one.  Hence

\[
 \boxed{
 \min\deg(\text{multisection})\in\{1,3\},\qquad
 \min=3\ \Longleftrightarrow\ f\text{ has no rational section}.}
\]

The current repository does not decide whether a rational section exists,
so it does not select between one and three.  It does unconditionally prove
the existence of a degree-three multisection and exclude degree two as a new
intermediate possibility.
