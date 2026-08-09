# Adversarial tests

## Test 1 — nonzero elliptic translation

**Attempt.** Use

\[
u(P)=[n]P+a,\qquad 0\ne a\in E[2].
\]

**Result.** This commutes with the corrected residual `S_3` whenever

\[
n\equiv1\pmod3.
\]

Thus the claim “residual equivariance forces `a=0`” is false. On the
unbroken global network, type-I incidence forces every type-I point to map
to itself and then forces `a=0`. An exceptional carrier need not satisfy
that unbroken argument.

**Verdict:** local counterexample; globally excluded only in the unbroken
case.

## Test 2 — maps `E_t -> L_t`

**Attempt.** Construct an actual map rather than a formal degree state.

Choose disjoint `q`-orbits `D,-D` of degree three with `D~-D`, and a
function `u` with

\[
\operatorname{div}(u)=D-(-D).
\]

**Result.** After normalization,

\[
u(P+q)=\omega u(P),\qquad u(-P)=u(P)^{-1}.
\]

This is a degree-three residual-`S_3`-equivariant morphism
`E_t->L_t`.

**Verdict:** genuine counterexample to any local exclusion of
elliptic-to-line maps. Unbroken type-I incidence excludes it, but an
exceptional detour may not.

## Test 3 — higher-degree maps on `L_t`

**Attempt.** Use

\[
R_m(z)=z^m.
\]

**Result.** It commutes with the residual `S_3` iff `m=1 mod 3`. For every
`m=1 mod 6`, it fixes all six type-I points pointwise. Examples have
arbitrarily large degree.

The degree-five map `z^{-5}` fixes the six type-I points and swaps the two
`C_6` points; `z^7` fixes all eight marked points individually.

**Verdict:** identity is not forced in all degree.

## Test 4 — faithful `V_4` action on an exceptional rational curve

**Attempt.** At a first exceptional divisor

\[
D=\mathbf P(\chi_z\oplus\chi_s\oplus\chi_r),
\]

take the invariant conic

\[
x_z^2+x_s^2+x_r^2=0.
\]

**Result.** The conic is smooth rational and no nonidentity element of
`V_4` acts pointwise on it.

**Verdict:** direct counterexample to the surface-style kernel lemma in
dimension three.

## Test 5 — type-II bypass

**Attempt.** Blow up a type-II triple point.

**Result.** For each involution `z`, the exceptional line

\[
\mathbf P(\chi_s\oplus\chi_r)
\]

connects the other two elliptic tangent directions, is pointwise `z`-fixed,
and may map nonconstantly to `L_z`. A path from `E_s` to `E_r` can bypass
the `E_z` direction.

**Verdict:** unique-path propagation fails at the first blowup.

## Test 6 — disconnected fixed locus in a connected exceptional fiber

**Attempt.** Use the same exceptional `P^2`.

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

**Result.** The transition-repair material proves only a forward necessity
statement: an actual map determines a formal state. It supplies no integration
theorem from a state to a Rees algebra, resolved morphism, or component map.
In particular, first normal maps do not choose a horizontal section of an
exceptional ruled surface.

**Verdict:** no formal state may be promoted to an actual map without a
separate integrability theorem.

## Test 8 — actual network map absent from a small formal-profile list

**Attempt.** Compare the explicit network maps

\[
\Phi_{n,m}
\]

with a proposed finite formal profile list.

**Result.** They are actual morphisms of the reduced network, and there are
infinitely many of them. Most are not known ambient maps. Hence they show
that fixed-network geometry has more actual maps than a small hand-selected
profile list, but they do not contradict the repository's forward necessity
theorem for ambient landing covariants.

The distinguished `Phi_{-5,1}` is now independently certified as a genuine
scheme-theoretic network map. It is nevertheless not the order-one formal
normal state: one is a nonzero order-zero map on the original elliptic, while
the other begins after forced plus-plane vanishing.

**Verdict:** a formal list is not a component-map classification, and a
network map is not automatically an ambient map.

## Test 9 — naive degree-25 extension of `[-5]/id`

**Attempt.** Extend the strict boundary map by a homogeneous degree-25 tuple.

**Result.** On every elliptic, `[-5]^*O_E(1)=O_E(25)`, so an everywhere-defined
tuple inducing `[-5]` forces degree 25. On every line, the identity pulls back
`O(1)` to `O(1)`, so the same tuple forces degree 1. More strongly, every
landing covariant vanishes on every involution plus-space and hence has zero
ordinary restriction on the original elliptic.

**Verdict:** the strict boundary map has no order-zero landing extension in
any degree. This does not exclude an exceptional carrier after
principalization.

## Aggregate conclusion

Every proposed shortcut to a finite actual-profile theorem fails one of these
tests. The remaining route is to prove exceptional-carrier integration and
rigidity for the normalized Rees algebra of the actual landing base ideal.
