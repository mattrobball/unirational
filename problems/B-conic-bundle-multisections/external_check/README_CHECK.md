# External sanity check: explicit unirational parametrization of a random (2,3)

Purpose: end-to-end falsification test of the tangent-residual theorem
(RESOLUTION.md, "Affirmative resolution by tangent residuals") on externally
drawn random coefficients.  The generator follows the construction
mechanically; everything below can be re-verified in any CAS with **no trust
in the generator**.

## Instance provenance

- 60 integer coefficients drawn from /dev/urandom on 2026-07-22 (recorded in
  `build_explicit_map.py` as `RAW`, and echoed in the run log).  Monomial
  order: x-monomials [x0^2, x0*x1, x0*x2, x1^2, x1*x2, x2^2] (outer) times
  y-monomials [U^3, U^2V, UV^2, V^3, U^2W, UVW, V^2W, UW^2, VW^2, W^3]
  (inner), row-major.
- CONDITIONING: the four coefficients of x0^2*{U^3, U^2V, UV^2, V^3} are
  zeroed, i.e. F((1,0,0), y) vanishes on L = {W=0}.  This is a
  codimension-4 LINEAR slice of P^59 whose only role is to give the Tsen
  surface S = X ∩ (P^2 x L) a rational section over Q, so that the final map
  has exact rational coefficients.  (Over C the theorem needs no such
  conditioning; a fully general F would force stage 1 through a conic over
  Q(t) with no rational point in general.)  The tangent-residual stages 2-3
  are unconditioned, and all genericity the theorem needs is re-verified for
  the drawn F by the checks below.
- To use YOUR OWN coefficients: put `{"coefficients": [60 ints]}` in a JSON
  file and run `python3 build_explicit_map.py --coeffs file.json`.  Keep the
  four conditioned slots zero (slots 0-3), or supply any F for which you can
  hand the script a rational section of S -> L.

## What the map is

`map_instance.txt` contains the staged straight-line program over Q:

- F: the hypersurface equation (bidegree (2,3)).
- Stage 1: x*(t,m), the chord parametrization of the conic F(., (t,1,0))
  through its rational point (1,0,0).  Point (x*(t,m); (t,1,0)) lies on X.
- Stage 2: r(t,m) (three explicit polynomials), the tangent residual of the
  marked point (t,1,0) on the plane cubic F(x*(t,m), .) = 0.
- Stage 3 (recipe, not expanded): d = (0,1,n),
  Qd2 = F(d, r), Bpol = F(x*+d, r) - F(x*, r) - Qd2,
  x'_k = Qd2 * x*_k - Bpol * d_k.
- Phi(t,m,n) = (x'(t,m,n); r(t,m)):  a rational map A^3 --> X, claimed
  dominant of degree 20.

## How to check it externally (any CAS)

1. **Containment (the main check).**  Verify F(Phi(t,m,n)) = 0.
   Recommended: evaluate the staged recipe at many random rational (t,m,n)
   with exact arithmetic and check F = 0 exactly each time.  For a full
   symbolic proof, verify instead the two small identities it follows from:
   (a) f*(r) = 0 where f* = F(x*(t,m), .)  [bivariate identity in (t,m);
       provable by expansion or by vanishing on any 100 x 53 grid, since
       its bidegree is at most (99, 52)];
   (b) the generic conic reflection identity
       Q(Q(d) x - (Q(x+d)-Q(x)-Q(d)) d) = Q(d)^2 Q(x)
       for a generic ternary quadratic form Q [one-line expansion];
   then F(x', r) = Qd2^2 * f*(r) = 0.
2. **Point of X.**  Check that at random (t,m,n) neither x' nor r is the
   zero vector (so Phi lands in P^2 x P^2, on X by 1).
3. **Dominance.**  Jacobian of the four affine coordinates
   (x'_1/x'_0, x'_2/x'_0, r_1/r_0, r_2/r_0) with respect to (t,m,n) has
   rank 3 at a random point.  (X is a threefold, so rank 3 = dominant.)
4. **Degree 20.**  For a random y0 in P^2_y, the fiber of
   T = closure(Phi restricted to n-independent part) over y0 is
   {x : F(x,y0) = 0, q_F(x,y0) = 0} with q_F the degree-(10,1) covariant
   (construction in RESOLUTION.md / the universal identity).  Check
   Res_{x2}(F(x,y0), q_F(x,y0)) (dehomogenized at x1=1) is squarefree of
   degree 20: then T -> P^2_y has 20 distinct points over y0, so the
   parametrization has degree 20.
5. **Independence.**  All of 1-4 use only F and the displayed formulas; you
   can also re-derive x*, r, x' yourself from the three-stage description
   and compare.

## Does the conditioning hide anything?  (No — and here is the proof.)

A fair objection: maybe the checks pass only on the conditioned
codimension-4 slice.  Three facts close this:

1. The conditioning is used ONLY to give stage 1 a rational point (Tsen's
   theorem is not effective over Q).  It appears nowhere in the theorem,
   whose two machine inputs — the universal identity (verified with all
   ten coefficients symbolic, i.e. for every F) and the genericity
   witnesses — are conditioning-free.
2. `unconditioned_check.py` (+ `.log`) runs the full mechanism on a fresh
   /dev/urandom draw with NO coefficient zeroed.  Since no rational point
   exists, it works in the cubic etale algebra K = Q[th]/(g0), where the
   three marked points of C_{x0} ∩ L actually live; reduction mod the FULL
   cubic verifies every identity at all three conjugate points at once.
   Checks U1–U4: primitivity of q_F; the witness conditions; tangency,
   residual-on-cubic, residual-on-covariant-line, off-L (via
   Res(g0, r_W) ≠ 0), and the stage-3 chord point, all mod g0; and the
   squarefree degree-20 fiber.  All pass.
3. Geometrically the conditioned family is just {X : X ⊇ {e} x L} for one
   point e, and PGL_3 x PGL_3 moves (e, L) anywhere; the construction is
   equivariant, so the slice is not a special position for anything the
   theorem uses.

What genuinely cannot be done without SOME rational point is writing the
composite parametrization with Q-coefficients — an arithmetic statement
about Q, not a geometric gap over C.

## What passing means / doesn't mean

Passing certifies: for THIS randomly drawn F, the construction yields an
explicit rational dominant degree-20 map P^3 --> X, i.e. this X is
unirational, exactly as the theorem's mechanism predicts, with no human in
the loop choosing F.  It does not by itself prove the "general X" statement
(that needs the openness/properness arguments and the universal identity,
which are proven in tangent_residual_theorem.md and independently verified);
it is a strong falsification test that would have failed loudly if any step
of the construction were wrong.
