# Adversarial tests

## Test 1 — nonzero elliptic translation

**Attempt.** Use

\[
u(P)=[n]P+a,\qquad 0\ne a\in E[2].
\]

**Result.** This commutes with the corrected residual \(S_3\) whenever

\[
n\equiv1\pmod3.
\]

Thus the claim “residual equivariance forces \(a=0\)” is false. On the
unbroken global network, type-I incidence forces every type-I point to map
to itself and then forces \(a=0\). An exceptional carrier need not satisfy
that unbroken argument.

**Verdict:** local counterexample; globally excluded only in the unbroken
case.

## Test 2 — maps \(E_t\to L_t\)

**Attempt.** Construct an actual map rather than a formal degree state.

Choose disjoint \(q\)-orbits \(D,-D\) of degree \(3\) with
\(D\sim-D\), and a function \(u\) with
\(\operatorname{div}(u)=D-(-D)\).

**Result.** After normalization,

\[
u(P+q)=\omega u(P),\qquad u(-P)=u(P)^{-1}.
\]

This is a degree-three residual-\(S_3\)-equivariant morphism
\(E_t\to L_t\).

**Verdict:** genuine counterexample to any local exclusion of
elliptic-to-line maps. Unbroken type-I incidence excludes it, but an
exceptional detour may not.

## Test 3 — higher-degree maps on \(L_t\)

**Attempt.** Use

\[
R_m(z)=z^m.
\]

**Result.** It commutes with the residual \(S_3\) iff
\(m\equiv1\pmod3\). For every \(m\equiv1\pmod6\), it fixes all six type-I
points pointwise. Examples have arbitrarily large degree.

The degree-five map \(z^{-5}\) fixes the six type-I points and swaps the
two \(C_6\) points; \(z^7\) fixes all eight marked points individually.

**Verdict:** identity is not forced in all degree.

## Test 4 — faithful \(V_4\) action on an exceptional rational curve

**Attempt.** At a first exceptional divisor

\[
D=\mathbf P(\chi_z\oplus\chi_s\oplus\chi_r),
\]

take the invariant conic

\[
x_z^2+x_s^2+x_r^2=0.
\]

**Result.** The conic is smooth rational and no nonidentity element of
\(V_4\) acts pointwise on it.

**Verdict:** direct counterexample to the surface-style kernel lemma in
dimension three.

## Test 5 — type-II bypass

**Attempt.** Blow up a type-II triple point.

**Result.** For each involution \(z\), the exceptional line

\[
\mathbf P(\chi_s\oplus\chi_r)
\]

connects the other two elliptic tangent directions, is pointwise
\(z\)-fixed, and may map nonconstantly to \(L_z\). A path from \(E_s\) to
\(E_r\) can bypass the \(E_z\) direction.

**Verdict:** unique-path propagation fails at the first blowup.

## Test 6 — disconnected fixed locus in a connected exceptional fiber

**Attempt.** Use the same exceptional \(\mathbf P^2\).

**Result.**

\[
D^{V_4}=
\{\mathbf P(\chi_z),\mathbf P(\chi_s),\mathbf P(\chi_r)\}
\]

is disconnected, and

\[
D^z=\mathbf P(\chi_z)\sqcup
\mathbf P(\chi_s\oplus\chi_r)
\]

is also disconnected.

**Verdict:** connectedness or rational chain connectedness of the total
fiber does not supply fixed-locus propagation.

## Test 7 — formal localization state without an actual map

**Attempt.** Treat a compatible associated-graded transition state as an
actual component diagram.

**Result.** The transition-repair material itself proves only a forward
necessity statement: an actual map determines a formal state. It supplies
no integration theorem from a state to a Rees algebra, resolved morphism,
or component map. In particular, first normal maps do not choose a
horizontal section of an exceptional ruled surface.

**Verdict:** no formal state may be promoted to an actual map without a
separate integrability theorem.

## Test 8 — actual map absent from the formal state list

**Attempt.** Compare the explicit network maps

\[
\Phi_{n,m}
\]

with the formal state list.

**Result.** They are actual morphisms of the reduced network, but not known
ambient maps. Hence they demonstrate that network geometry has more
actual maps than a small hand-selected profile list, but they do not
contradict the repository's forward necessity theorem for ambient maps.

Conversely, because no ambient map is known, this test cannot exhibit an
ambient counterexample to the formal necessity list.

**Verdict:** test remains blocked exactly at ambient extension.

## Aggregate conclusion

Every proposed shortcut to a finite profile fails one of these tests.
The only surviving route is to prove an ambient base-carrier theorem for
the actual principalized ideal.
