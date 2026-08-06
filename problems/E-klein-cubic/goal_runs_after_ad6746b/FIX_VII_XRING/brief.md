# FIX-VII-XRING — explicit equivariant covariant algebra, both ladders, true ideal multiplicities

CAS worker packet. Work ONLY in this directory. Repo root
`/Users/worker/unirational`. Everything is a WORKED PLAN — execute,
verify, report deviations honestly. Primary prime p = 397, control
prime p2 = 1321 (both ≡ 1 mod 132 with 33 a QR — all of ζ₁₁, ω,
√−11, √33 exist).

## Hard rules

- NEVER `git commit` / touch `.git`.
- Output discipline: results INCREMENTALLY to `results/*`; payloads
  to `payload/*` (JSON/plain text); final chat report < 30 lines.
- Machine check lines: append `CHECK <name> PASS|FAIL` to
  `results/checks.log`. Record FAILs honestly; never tune to pass.
- Engines: python3 (+numpy int64 arithmetic mod p; reduce after
  every product — entries < 2¹¹, products safe), Macaulay2. No
  msolve needed.

## Stage 1 — the explicit group G ⊂ GL₅(F_p)

Cyclic frame: Klein cubic `F = x0²x1 + x1²x2 + x2²x3 + x3²x4 +
x4²x0`. Generators:
- `g11 = diag(ζ, ζ⁹, ζ⁴, ζ³, ζ⁵)` (ζ any fixed primitive 11th root
  mod p). CHECK g11_preserves_F.
- `s5 = the cyclic shift x_i ↦ x_{i+1 mod 5}` (permutation matrix;
  fix the direction so F is preserved). CHECK s5_preserves_F.
- The Weil involution `S`: construct via the antisymmetrized
  Fourier kernel. Protocol: basis correspondence x_i ↔ v_{b_i} with
  `b = (1, 2, 4, 3, 5)` (from exponents (1,9,4,3,5) mod ±). Try the
  family `M_{jk} = c·(ζ^{t·b_j·b_k} − ζ^{−t·b_j·b_k})`, j,k = 0..4,
  for t = 1..5 and c = 1/√−11 (both square roots), possibly composed
  with an overall sign. ACCEPT when: M is invertible, M² = scalar·I,
  and F∘M = scalar·F. If the family fails, extend: allow the b-map
  replaced by any of the 8 relabelings (b_i ↦ u·b_i mod ±, u ∈
  {1..5}) — report which (t, root, relabeling) worked. CHECK
  S_matrix_found (record the exact recipe in payload).
- Normalize all three into SL₅ if possible (det = 1; adjust by
  μ₅-scalars) — report.

BFS closure over words in {g11, s5, S} storing PROJECTIVE classes
(canonicalize: scale so the first nonzero entry is 1). CHECK
group_order_660 (cap the BFS at 1000 classes; must terminate at
exactly 660). CHECK triple_2_3_11 (some pair of elements of orders
2, 3 with product of order 11 — existence inside the closure).
Payload: `payload/G660_p397.json` (the 660 matrices).

## Stage 2 — covariant spaces, both types, d = 1..12

For U ∈ {W (target P(W̄), "polar type"), W̄ (target P(W), "map
type")}: the space of G-equivariant tuples = solutions T of the
linear equivariance conditions for the THREE GENERATORS ONLY (they
generate G — closure verified in Stage 1):
`ρ_{S^d}(g) ∘ T = T ∘ ρ_U(g)`, T ∈ Hom(U*, S^dW*) as a
5·dim(S^d)-column. Here ρ_U(g) for U = W̄ is the entrywise-
conjugate... CAREFUL, over F_p use: W̄-action = the action by the
CONJUGATE class — concretely take ρ_{W̄}(g) := (ρ_W(g)⁻¹)ᵀ
(contragredient of the dual — verify on characters: trace
ρ_{W̄}(g11) must equal the mod-p image of λ̄ = (−1−√−11)/2). CHECK
conjugate_convention (trace test for g11, s5, S).

Solve by null-space mod p (numpy Gaussian elimination mod p; sizes
≤ 9100 — fine). CHECK dims_match_banked: expected dimensions
(director-banked, Atiyah–Bott/Molien, `director_probes_20260806/
dual_dims.py`):
  map-type (W̄): d=1..12: 1,0,0,2,1,2,4,5,6,10,12,16
  polar-type (W): d=1..12: 0,1,0,1,2,2,4,5,6,10,12,15
Any mismatch is a FAIL — report, do not adjust.

## Stage 3 — restriction to the Hessian curve; TRUE ideal multiplicities

`I_C` = saturate(ideal(H) + jacobian ideal of H), H = det Hess(F)
(recipe verified: dim 1, degree 20, HP 20i−25 — CHECK
IC_degree_20). For each space from Stage 2: restriction rank onto
`(R/I_C)_d` (evaluate a basis of the covariant space modulo a
degree-d Gröbner/normal-form basis of I_C); TRUE ideal-type
multiplicity = dim − rank. Report the full table d = 1..12 both
types. CHECKs: ideal_table_consistent (every true mult ≥ the banked
lower bound: map-type bounds 0,0,0,0,0,2,2,4,5,8,11,14 (d=1..12);
polar-type 0,0,0,1,1,1,3,3,5,8,10,14) and
surjectivity_where_HF_says (restriction surjective at d = 3,4,5,6
per HF {35,55,75,95}; at those d the true mult must EQUAL the
bound).

## Stage 4 — canonical generators and identities

Explicit candidate covariants (compute symbolically mod p from F):
- `∇F` (polar, d=2), `∇H` (polar, d=4): CHECK gradF_is_polar2,
  gradH_is_polar4 (each spans the corresponding 1-dim piece / lies
  in the computed space; for d=4 polar: mult 1 → ∇H spans).
- d=5 polar (mult 2) candidate spanning set: {F·∇F, ∇J₆?, HessF·∇H,
  HessH·∇F} where HessF·∇H means the matrix (∂i∂jF) applied to the
  ∇H-vector (check types by fit — if a candidate fails the linear
  system membership, record and move on; identities among members
  = linear dependencies: OUTPUT the exact dependency coefficients).
  J₆ = a new degree-6 fundamental invariant: compute the invariant
  ladder (trivial-type solutions) at d = 5, 6, 7 first: dims must
  be 1 (=(H)), 2 (F², J₆), 1+... d=7 invariants dim: banked 1;
  wait — banked invariant dims (mult_triv(S^d), d=3..7): 1, 0, 1,
  2, 1. Extract J₆ as the complement of F² (echelon). ∇J₆ is then
  a d=5 polar candidate.
- d=6 map-type (mult 2, BOTH in the ideal — the canonical pair):
  output echelonized explicit pair `payload/pair_d6.json`. Test
  membership/matching of: `∇F̌∘∇F`-pullback-composites do not exist
  at 6 — instead test the two obvious degree-6 constructions:
  (i) (adj Hess F)-type contractions: (cofactor matrix of HessF —
  entries deg 3) applied to ∇F̌... skip theory: test the concrete
  list: {HessH·∇F (if it fit d=5 polar, skip here), (∂i∂jH)·(∂j F)
  summed (deg 3+2 = 5 — polar-5 again), F·(the d=3 map-type: none),
  ∇F̌∘∇F composed with... }. If no listed candidate matches,
  REPORT the pair as new (that is a fine outcome — the coefficients
  ARE the deliverable). Also CHECK pair_vanishes_on_C (both tuples
  restrict to 0 mod I_C).
- The d=4 map-type pair (mult 2, ideal-part 0): identify the
  composition `∇F̌ ∘ ∇F` (dual-polar after polar: apply the dual
  Klein cubic's gradient — over the dual basis the invariant cubic
  F̌ has the SAME pentagonal shape by invariant-uniqueness; verify
  by computing the invariant cubic on W̄ directly as the d=3
  trivial-type solution for the contragredient action) as a member.
  CHECK dual_polar_composition.

## Stage 5 — control prime

Repeat Stages 1–3 (not 4) at p2 = 1321. CHECK
control_prime_agrees (all dimension tables identical).

## Deliverables

`payload/`: G660 matrices (both primes), all space dimensions, true
ideal tables, the d=6 pair, identities found. `verifier.py`:
independent re-implementation checking: group order; dims for
d = 4, 5, 6 both types by a DIFFERENT method (character-projector
trace: for each type, dim = (1/660)Σ_g χ_{S^d}(g)·χ_U(g)⁻¹-side —
evaluate traces from the stored 660 matrices directly); the d=6
pair's equivariance and vanishing on C. `REPORT.md` ≤ 60 lines.
Exits: `FIX-VII-XRING-ALLGREEN` / `FIX-VII-XRING-DEVIATION`.
