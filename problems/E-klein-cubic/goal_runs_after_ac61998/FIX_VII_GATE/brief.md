# FIX-VII-GATE — the d = 34 gateway: explicit (1,6)-profile space, Hessian-carrier cut

CAS worker packet. Work ONLY in this directory; repo root
`/Users/worker/unirational`, problem dir `problems/E-klein-cubic`.
This is a WORKED PLAN with self-certifying checkpoints; execute,
verify, report honestly. Primes p = 67 primary, p2 = 199 control
(both support ζ₁₁, ω, √33, √−11; both are the FIX-P2 primes, which
matters for the cross-check below).

## Question

Let M₃₄ = the space of G-equivariant W-valued degree-34 covariant
tuples (maps P(W) → P(W)); banked dim = 576. Compute:

  n1 = dim { T ∈ M₃₄ : (1,6)-profile conditions along the arrangement }
  n2 = dim { T as above : T also vanishes on the Hessian curve C₂₀ }

n2 ≥ 1 means explicit Hessian-ansatz candidates exist at the
gateway (dump them); n2 = 0 kills the Hessian-carrier ansatz at
d = 34 (mod-p at two primes). Either outcome is the deliverable.

## Hard rules

As all packets: no git; incremental writes to `results/`,
`payload/`; `CHECK <name> PASS|FAIL` lines in `results/checks.log`;
final chat report < 30 lines; honest FAILs; engines python3
(+numpy) and M2.

## Stage 1 — explicit group (known-good recipe)

`g11 = diag(ζ^1, ζ^9, ζ^4, ζ^3, ζ^5)`; `s5` = the cyclic shift
preserving `F = x0²x1 + x1²x2 + x2²x3 + x3²x4 + x4²x0`; Weil
involution `S_{jk} = c·s_j s_k (ζ^{b_j b_k} − ζ^{−b_j b_k})` with
the SQUARE-ROOT labeling `b = (1,3,2,5,4)`, signs
`s = (1,1,−1,1,1)`, c normalized so S² = I, det S = 1 (this is the
FIX-VII-XRING corrected recipe — see that packet's
`payload/S_family_analysis.json`; the naive labeling does NOT
work). CHECK closure_660 (BFS closure of the three generators has
exactly 660 linear elements; class profile {1:1, 2:55, 3:110,
5:264, 6:110, 11:120}). CHECK F_preserved (all three generators).

## Stage 2 — span M₃₄ explicitly, self-certified

Building blocks from FIX-VII-XRING
(`goal_runs_after_ad6746b/FIX_VII_XRING/payload/`, plus recompute
at p = 67/199 as needed — XRING ran at 397/1321, so RECOMPUTE the
generators at the present primes with the same recipes):
- map-type generators through d = 12 (dims 1,0,0,2,1,2,4,5,6,10,
  12,16 at d = 1..12), polar-type likewise (0,1,0,1,2,2,4,5,6,10,
  12,15), via generator-equivariance null-spaces (three generator
  conditions; sizes ≤ 9100 — cheap).
- Invariant ring: build a degree-graded invariant basis up to
  degree 33 multiplicatively from: F (3), H (5), J₆, J₇, plus
  CONTRACTIONS ⟨map_e, polar_k⟩ (component-wise dot of a map-type
  and a polar-type tuple is an invariant of degree e + k — this
  gives a large supply at every degree), plus products of lower
  invariants. Banked invariant dims d = 3..33 (MUST match; a
  shortfall at degree k means a missing generator — then extend
  with a direct trivial-type null-space at that degree, feasible
  to d ≈ 20, and report):
  1,0,1,2,1,2,3,3,4,6,5,8,10,10,13,17,17,22,26,28,33,40,43,50,58,
  63,72,84,89,102,115.
  CHECK invariant_ladder_full (dims match banked at every
  d ≤ 33).
- M₃₄ spanning set: all products (invariant basis at degree
  34 − e) × (map-type generator basis at degree e), e ≤ 12. Rank
  over F_p of the coefficient matrix (5·C(38,4) = 369075 columns;
  use streaming/chunked Gaussian elimination, uint32 with periodic
  reduction, or M2 rank — your choice; wall-time budget hours,
  fine). CHECK span_576: rank = 576 EXACTLY. If rank < 576:
  extend map-type generators to d = 13, 14, 15 by direct
  null-space (≤ 19380 unknowns — cheap) and retry; if still short,
  REPORT the achieved rank and continue with the honest subspace,
  labeling every later number a LOWER-BOUND figure.

## Stage 3 — profile conditions at one representative (equivariance globalizes)

Adapted frame: use the FIX-P2 machinery
(`goal_runs_after_2666fdb/FIX_P2_GATEWAY_D36/p2lib.py` —
`adapted_frame` gives, at these very primes, the V4-line data:
`ellV` (2-dim), `E1 = ⟨e_x⟩`, `E2 = ⟨e_y⟩`, `E3 = ⟨e_z⟩`, the
plane/line/point geometry). The (1,6) profile at d = 34, line
degree n = 28, e = r − m = 5:

(a) PLANE: all 5 components of T vanish identically on the
    plus-plane Π_σ (the sealed base-locus containment). As linear
    functionals: coefficients of T|_{y=z=0}-analogue in the
    adapted coordinates (use the frame's plane parameterization).
(b) LINE ORDERS: along L_σ, in the adapted VALUE-decomposition of
    W (LINE ⊕ E1 ⊕ E2 ⊕ E3), the germ multi-order is
    (r; m, m, m) = (6; 1, 1, 1). IMPORTANT — do NOT guess the
    assignment of orders to components: extract the exact
    condition encoding from the FIX-P2 sieve implementation
    (`produce_sweep2.py` + `p2lib.py` — the row machinery that
    produced the sealed (1,6) table) and translate its LOCAL
    slice conditions into GLOBAL jet functionals along L_σ. The
    packet's decisive self-test is (d) below; if the translation
    is ambiguous at any point, implement the alternatives and let
    (d) discriminate — report which survived.
(c) c_σ-POINT conditions: NONE imposed — sealed exit
    FIX-P2-H11-LOCAL-CONFIRMED proves every H1-1 clause at c_σ is
    forced by (a) + (b). (State this in the report; do not add
    conditions.)
(d) CROSS-CHECK (mandatory, the packet's keystone): run the
    FIX-P2 pipeline itself (its scripts are in the packet, its
    primes are yours) to reproduce the sealed (1,6)/d=34 slice
    dimension; call it s₃₄ (the sealed table says the row is the
    first nonzero, ≤ 16 — read the exact value from
    `payloads/SWEEP2_p67_34_38.json`). Then compute
    n1 = dim(M₃₄ ∩ (a) ∩ (b)). CHECK profile_dim_matches_P2:
    n1 = s₃₄ at BOTH primes. If they differ, STOP the main line,
    report both numbers and your translation — a mismatch is
    itself a finding (either the slice is a strict upper bound or
    the translation is wrong; do NOT tune conditions to force
    agreement).
    PAYLOAD: an explicit basis of the n1-dim space as honest
    5-tuples of degree-34 polynomials (coefficient files, one per
    basis element) — `payload/profile_basis_p67/`. This artifact
    matters independently of everything else.

## Stage 4 — the carrier cut

`I_C = saturate((H) + jacobian(H))` at each prime (verify: dim 1,
degree 20, HP 20i − 25 — CHECK IC_ok). Compute a degree-34 normal
form (Gröbner basis mod p, then NF of each of the 5 components of
each profile-basis element; target space (R/I_C)₃₄ has dim 655).
n2 = n1 − rank(NF map on the profile basis). CHECK
carrier_cut_both_primes: same n2 at p and p2. If n2 > 0: PAYLOAD
`payload/candidates_p67/` — an explicit basis of the final space,
plus for each candidate: (i) sanity `T` not identically zero on
X-relevant loci: report `T mod (F)`-nonvanishing (is the tuple
nonzero as a map on X's complement — trivial check `T ≠ 0`), (ii)
the values of `⟨T, x⟩ = Σ T_i x_i` (degree 35) and `F(T)` (the
composition F ∘ T, degree 102 — compute mod p by NF; `F(T) ≡ 0 mod
(F)` would mean T maps V(F)... just REPORT `F(T) mod F` zero or
not; no interpretation required).

## Stage 5 — report

REPORT.md ≤ 60 lines: the chain 576 → n1 (= s₃₄?) → n2 at both
primes; every CHECK; wall times; deviations. Exits:
`FIX-VII-GATE-CANDIDATES-EXIST` (n2 ≥ 1 both primes),
`FIX-VII-GATE-HESSIAN-ANSATZ-EMPTY` (n2 = 0 both primes),
`FIX-VII-GATE-DEVIATION` (anything else, incl. profile mismatch).
