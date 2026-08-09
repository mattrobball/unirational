# Adversarial tests for normalized-Rees carriers

Every test is applied to the intrinsic normalized graph, not merely to a chosen
principalization.

## 1. Rees component supported on the bypass line

**Test.** Blow up the weak bypass line in the first exceptional `P2` and treat
the new divisor as a carrier.

**Result.** Refuted in that form.  If the divisor is centered at the marked
point and maps to `L_z`, its joint target residue field has transcendence degree
one, so it contracts to a curve on the normalized graph.

**Retained escape.** The bypass line can be the special fiber of a Rees divisor
centered on an incident source curve, as in the exact ideal `(v,w)`, or a fixed
curve slice in a stable surface.

## 2. Faithful `V4` rational conic

**Test.** Use the invariant conic `u^2+v^2+w^2=0` and a generically invertible
weak-transform matrix.

**Result.** The explicit pair
\[
((u^2+v^2+w^2)v+u^3w,
 (u^2+v^2+w^2)w+u^3v)
\]
has weak determinant `U^3(V^2-W^2)`, but the resulting divisor maps to a line
and contracts.

**Retained escape.** A faithful conic may still be an intrinsic curve component
of the normalized point fiber or lie in a surface-valued carrier.  This is not
excluded.

## 3. Carrier dominating `E_t` with degree greater than one

**Test.** Allow a fixed multisection of a carrier surface.

**Result.** The canonical ordinary **curve** carrier is birational to `E_t`, so
its degree is one.  A secondary fixed curve inside a surface can have degree
`delta>1`; current Rees theory does not exclude it.

## 4. Positive base correction

**Test.** Set `B·C>0` in the polarization formula.

**Result.** Compatible with every theorem in the packet.  No base-neutrality
result is proved.  Consequently `n=-5` does not force `d=25`.

## 5. Formal normal jet that dies under normalization

**Test.** Promote a weak line or conic divisor to a normalized-Rees component.

**Result.** Both explicit weak-divisor models contract by the joint-residue
dimension theorem.  This is an exact example of a formal/refinement carrier
that dies as a distinct normalized-Rees component.

## 6. Two formal jets integrating to the same carrier

**Test.** Compare `(v,w)` and `(v^3,w^3)`.

**Result.** Their normalized source carrier is the ordinary blowup of `(v,w)`,
but the fiber maps have degrees one and three.  Thus the same carrier supports
distinct morphisms, and the associated graded state does not determine the
map.

## 7. One formal state integrating to multiple valuations

**Test.** Use
\[
I_N=(x^2,xy,y^N),
\qquad N\ge3.
\]
The first low-order state sees `(x^2,xy)` independently of `N`.

**Result.** The Newton polygon has compact-edge normals
\[
(1,1),
\qquad(N-1,1),
\]
so the normalized blowup has two monomial Rees valuations.  A first formal
state can therefore feed multiple intrinsic divisors.

This is a local algebra adversary, not a Klein landing tuple.

## 8. Type-II fiber bypassing one elliptic branch

**Test.** Attach two branch endpoints through a line-valued curve while omitting
the third.

**Result.** Connectedness of the total fiber does not prohibit it.  Residual
`C3` either produces a three-element orbit of such bypasses or requires a
`C3`-stable component.  No current theorem forces all three ordinary endpoints
onto one fixed component.

## 9. Carrier profile absent from the transition-state list

**Test.** Allow the ordinary carrier to be a surface or allow a finite normal
branch over the joint jet image.

**Result.** Both are genuine normalized-Rees possibilities.  The family
`(v^m,w^m)` has one normalized carrier with arbitrary odd fiber-map degree, and
surface ordinary carriers retain the normal parameter.  These data are not
encoded by a list of formal endpoint labels.

## 10. Surface carrier whose induced map becomes one-dimensional only after factoring

**Test.** Let the ordinary valuation over a fixed curve survive as a Rees
divisor.

**Result.** This is exactly the `dim K_S=2` outcome.  The surface is birational
to `P(N_{S/X})`, maps to one component of `X^t`, and has a canonical Stein
factorization through a normal curve.  Choosing a section is noncanonical.

For a point-centered surface, however, a curve-valued target is impossible;
that surface must map to a target surface.

## 11. Two weak divisors with one actual curve carrier

**Test.** Treat the bypass-line and conic weak divisors as distinct Rees
valuations because their weak centers differ.

**Result.** Both can contract to curve centers on their respective normalized
graphs.  Weak-center geometry is not an injective label for actual Rees
components.

## 12. A constant positive-dimensional point-fiber component

**Test.** Allow a curve or surface in `pi^{-1}(x)` on which `q` is constant.

**Result.** Impossible on the normalized graph.  Normalization is finite over
the graph closure, so the point fiber maps finitely to its target image and
preserves dimension.  Positive-dimensional constant components can occur only
on a later refinement and are contracted there.

## 13. Final adversarial verdict

The residue-dimension theorem survives all tests.  A unique or uniformly finite
carrier profile does not.  The unresolved adversaries are precisely intrinsic
curve components, fixed slices in faithful surfaces, secondary multisections,
and positive base correction.
