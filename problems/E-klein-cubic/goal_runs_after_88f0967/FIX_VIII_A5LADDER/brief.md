# FIX-VIII-A5LADDER — the A5 landing ladder (the degree-11 point hunt)

CAS worker packet. Work ONLY here; repo root
`/Users/worker/unirational`. Context: `theory/FIX_VIII_italian.md`
§5 door 1. THE PRIZE: any nonzero A5-equivariant rational map
`P(W) ⇢ X` (any degree, any image dimension) is a point of the
twisted cubic over the degree-11 field — it collapses the descent
gap of the Italian program from 55 to 11. The sealed G-equivariant
ladder emptiness (degrees ≤ 24) does NOT constrain A5-covariants:
this hunt is wide open from degree 2.

## Hard rules
No git. Incremental writes; `CHECK` lines in `results/checks.log`;
report < 30 lines. python3 + numpy + msolve (+M2 optional). msolve
landmine rules (0-byte output = error; `-g` output: strip `#`
lines; see `goal_runs_after_a90dbe1/FIX_N2C_R7_DECISION/MSOLVE_PARSER.md`).

## Stage 1 — the subgroup and the covariant spaces (p = 67)
Rebuild G660 from
`goal_runs_after_ac61998/FIX_VII_GATE/payload/G660_p67.json`
(generators g11, s5, S; BFS closure = 660 projective classes).
Extract an A5: an involution `a` and an order-3 `b` with `ab` of
order 5; closure ⟨a,b⟩ must have order 60 with 15 involutions
(CHECK a5_order_60). Both A5-classes exist; take the first found,
record its generators in the payload (and note: the second class
is reached via any g ∉ N_G(A5) conjugation — not needed for the
hunt).

Map-type covariant spaces: `M_d^{A5} = {T ∈ (S^dW* ⊗ W) :
equivariant for a and b}` — null-space of the two linear
equivariance conditions, d = 1..12. CHECK dims_molien: dimensions
must match the A5-Molien counts computed from characters
(`W|_{A5} = V₅`, χ = (5,1,−1,0,0); compute the expected table
yourself per degree via Newton/Molien exactly as
`director_probes_20260806/hess_window.py` does for G — include
the table in the payload; expected small values start 1, 2, 3 at
d = 1, 2, 3).

## Stage 2 — the landing cone per degree (the LAND method)
For each d = 2..12 (skip 1: the identity does not land): with
basis T₁..T_K of `M_d^{A5}`, sample `F(Σ cᵢTᵢ)` at `max(60, 4K)`
random points of `F_p⁵` (exact tensor expansion of
`Σ(Mᵢ·c)²(Mᵢ₊₁·c)` as in
`goal_runs_after_10804b2/FIX_VII_LAND/scripts/`), obtaining that
many cubics in `c ∈ F_p^K`. Solve with msolve. The sampled
variety CONTAINS the true landing cone, so:
- msolve returns only the origin ⇒ cone EMPTY at this degree
  (decisive mod p): record and move to d+1.
- anything else ⇒ CANDIDATE: extract solution(s) (for
  positive-dimensional output, cut with random hyperplanes to
  reach points). Then VERIFY FULL LANDING: `F(T_c) ≡ 0` as a
  polynomial identity mod p (expand completely, or NF against
  nothing — it must vanish coefficient-wise; CHECK
  full_identity_d<d>). Also CHECK `T_c` is not identically zero
  and not a scalar multiple of a lower-degree hit times an
  invariant.
Time cap per degree: 600 s for msolve; if exceeded, record
UNDECIDED-TIMEOUT for that degree and continue (honesty over
completeness).

## Stage 3 — on a hit (first d with a verified full identity)
1. Image dimension: rank of the 5×5 Jacobian of `T_c` at 20
   random points (generic rank r ⇒ image dimension r − 1).
   Any r ≥ 1 is a win; report r.
2. Reproduce at p2 = 199: rebuild everything (G660 recipe is in
   the GATE payload for 199 too), find the corresponding cone
   point, verify the full identity (CHECK second_prime).
3. Attempt exact recognition: if the hit is isolated mod both
   primes, try CRT + rational reconstruction of the coefficient
   vector in the (echelonized, deterministically ordered) basis;
   report the reconstruction or its failure — do NOT force it.

## Deliverables
`payload/`: A5 generators, dim table, per-degree cone verdicts,
hit data (coefficients, Jacobian rank, both primes).
`verifier.py`: independent — rebuilds the A5 and the spaces at
BOTH primes from scratch with different random seeds, re-checks
dims, re-runs the cone solve at every EMPTY degree with more
sample points (80), and re-verifies any hit's full identity.
`REPORT.md` ≤ 50 lines. Exits: `FIX-VIII-A5LADDER-HIT-D<d>` /
`FIX-VIII-A5LADDER-EMPTY-THROUGH-12` /
`FIX-VIII-A5LADDER-DEVIATION`.
