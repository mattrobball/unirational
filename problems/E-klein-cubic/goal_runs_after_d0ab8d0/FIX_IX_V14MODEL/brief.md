# FIX-IX-V14MODEL — the equivariant V14: model, arrangement, census, ladder

CAS worker packet. Work ONLY here; repo root /Users/worker/unirational.
Context: theory/FIX_IX_v14.md (read fully). Primes p = 397 primary,
199 control. Director probes to reuse:
director_probes_20260806/{v14_model.py, v14_lambda2.py, v14_a5fix.py,
v14_d12fix2.py} (the corrected Weil normalization S^2 = -I, c^2 = -1/11;
SL closure 1320; Lambda^2 U = 5 + 10'; the 10'-projector recipe).

Hard rules: no git; incremental writes; CHECK lines in results/checks.log;
report < 30 lines; msolve landmine rules if used.

## Stage 1 — the model, exactly
Basis the 10'-summand M (columns of the isotypic projector, echelonized,
deterministic order). Restrict the 15 Plucker quadrics (components of
T wedge T) to P(M): a system of quadrics in 10 variables. CHECKs:
dim_projective_3, degree_14, smooth (Jacobian corank 0 at 30 random
points AND at every special point found below), G_invariant (the
660-action on M-coordinates permutes the ideal; verify on generators),
control prime agrees.

## Stage 2 — the sigma-arrangement (cosheaf stage-A analogue)
The order-4 lift of sigma splits U = U+ + U- (3+3, eigenvalues +-i);
M^sigma = the (U+ wedge U-)-part. Compute V14^sigma = rank-2 locus in
P(M^sigma) exactly: expected a linear section of P(U+) x P(U-);
determine its irreducible components, dimensions, degrees (the
V14-analogue of E_sigma disjoint-union L_sigma). Same for V14^{C3},
V14^{C5}, V14^{C6}, V14^{C11} (cyclic: must be nonempty - verify), and
V14^{V4}: M^{V4} is 4-dim; compute the rank-2 locus in the P^3 exactly
(expected finite; count points and their G-orbit structure). CHECK
condition_A: every abelian subgroup has nonempty fixed locus on V14.
Also CONFIRM (exact, both primes): V14^{A5} empty (the symplectic
invariant, rank 6) and V14^{D12} empty (pencil min-rank 4) - replay
the director probes as checks.

## Stage 3 — curve-orbit census
Find the G-orbit-55 of conics predicted by the Iliev-Markushevich
transfer (conics on V14 <-> lines on the cubic): test whether
V14^sigma contains a conic C_sigma (the natural candidate); if so
verify: G-orbit size 55, D12-stability, pairwise incidence structure
(the V14-analogue of the triangle calculus: what do sibling conics
of a V4 share?). Lines on V14: the Fano scheme of lines: compute its
F_p-point count and any small G-orbits (a G-stable finite set of
lines = small closed points of the twisted V14). Report the smallest
closed-point degrees obtainable and the resulting INDEX bound for
the twisted V14 over K_proj (hyperplane class gives 14; conic-orbits
2*55...; lines 1*orbit; gcd arithmetic - note 14 = 2 mod 3).

## Stage 4 — the ladder
mult_{10'}(S^d W*) for d = 1..14 by Molien (recipe =
director_probes_20260806/hess_window.py, the X10p-row; W-side
eigenvalue data there). For each d with mult > 0 and <= 30: the
landing cone is QUADRATIC (the 15 Plucker quadrics evaluated on
T_c = sum c_i T_i): sample at random points (LAND method,
goal_runs_after_10804b2/FIX_VII_LAND/scripts/), solve with msolve.
Any hit: verify the full identity (all 15 quadrics vanish
identically as polynomials), Jacobian/image dimension, second
prime, report loudly (a verified hit = a G-map P(W) -> V14 = a
K_proj-POINT of the twisted V14 = ed <= 3 = the HEADLINE, positive
- triple-verify before claiming).

## Deliverables
payload/ (model ideal, fixed-locus data, census tables, ladder+cones),
verifier.py (independent: rebuild at 199 with different seeds; recheck
stages 1-2 exactly and any stage-4 hit), REPORT.md <= 60 lines.
Exits: FIX-IX-V14MODEL-ALLGREEN (+ suffix -HIT-D<d> if stage 4 hits) /
FIX-IX-V14MODEL-DEVIATION.
