# FIX-A0 — exact replay

Packet: `goal_runs_after_2880a28/FIX_A0_INVOLUTION_ARRANGEMENT/`
Repo HEAD when produced: `2880a28`.
Toolchain: `python3` (stdlib + `sympy` for the symbolic `j`-formula derivation)
and `M2`. No GAP, no Sage, no Magma, no PARI. No floating point anywhere.

Environment used: Python 3.14.6, sympy 1.14.0, Macaulay2 (`/opt/homebrew/bin/M2`).

```sh
cd "$(git rev-parse --show-toplevel)/problems/E-klein-cubic/goal_runs_after_2880a28/FIX_A0_INVOLUTION_ARRANGEMENT"

# 1. produce the payloads  (~70 s)
python3 produce_fix_a0.py

# 2. independent recomputation + comparison  (~50 s)  -- ALGEBRAIC-RECOMPUTE
python3 verify_fix_a0.py

# 3. symbolic derivation of both j-invariant formulas  (<1 s)
python3 verify_j_formulas.py

# 4. smoothness of the Klein cubic threefold, exact over QQ  (<5 s)
M2 --script verify_klein_smooth.m2

# 5. EXTRA (not the certificate): independent modular rebuild + a third
#    j-algorithm over F_23, F_67, F_89  (<1 s)
python3 extra_modular_crosscheck.py
```

## Expected output

* `produce_fix_a0.py` — final line
  `DONE. summary: {'claim1_involutions_trace_and_split': True, 'claim2_line_in_X': True,
  'claim3_smooth_cubic_and_j': True, 'claim3_j': '8192/11', 'claim4_normal_types': True,
  'claim5_centralizer_D12_residual_S3': True, 'claim6_arrangement': True, ...}`
* `verify_fix_a0.py` — `VERIFY: PASS -- all FIX-A0 claims independently
  recomputed and matched.` / `j(E_sigma) = 8192/11 (both routes, all 55
  involutions)`; exit code 0. Any failure prints `*** FAIL: <name>` and exits 1.
* `verify_j_formulas.py` — `J-FORMULA VERIFICATION: PASS (17 checks)`
* `M2 --script verify_klein_smooth.m2` — `dim R/J = 0`,
  `radical = ideal(x4,x3,x2,x1,x0)`, `M2-KLEIN-SMOOTH-PASS`
* `extra_modular_crosscheck.py` — `MODULAR CROSS-CHECK: PASS for p in [23, 67, 89]`

## Files

| file | role |
|---|---|
| `klein_exact.py` | exact `Q(ζ₁₁)` / `Q(ζ₁₁,ω)` arithmetic, linear algebra, the group `⟨S,T⟩` with index arithmetic, the Klein cubic, sparse multivariate polynomials |
| `produce_fix_a0.py` | producer for all six claims |
| `verify_fix_a0.py` | independent recomputation (different algorithms) + comparison; **the certificate** |
| `verify_j_formulas.py` | exact symbolic derivation of `j(H_μ) = 27μ³(μ³+8)³/(μ³−1)³` and `j = 6912I³/(4I³−J²)` |
| `verify_klein_smooth.m2` | Macaulay2 proof that `Sing X = ∅` |
| `extra_modular_crosscheck.py` | *extra*: full modular rebuild + third `j` algorithm |
| `payload_involutions.json` | claims 1, 2, 5 — eigenbases, traces, centralizers, residual `2×2` matrices and characters |
| `payload_elliptic.json` | claim 3 — Hesse coefficients `(a,b,c,d)`, `t = −16/11`, `j = 8192/11`, route-B quartics `(I,J)`, exact points of `E_σ` |
| `payload_normal_types.json` | claim 4 — generic-point identities, resultants, exact tangent computations |
| `payload_arrangement.json` | claim 6 — full 55×55 tables, `V4`/vertex/`D12`/`D10` data |
| `SUMMARY.json` | one-line verdicts |
| `STATUS.md` | exits, findings, cross-reference |

## Determinism

Everything is deterministic: no randomness, no sampling, no timing-dependent
paths. The involution indexing in the payloads is the BFS order of the group
build, which is fixed by the generator order `(S, T)`; `verify_fix_a0.py`
re-derives it and checks it matches (`payload involution order matches`).

## Independence of the verifier

`verify_fix_a0.py` deliberately differs from the producer at every step:

| step | producer | verifier |
|---|---|---|
| group | BFS from `S,T` | BFS from `S,T` **plus** exact Cayley-graph consistency with `PSL(2,11)` over `F₁₁` on all 660 elements |
| eigenspaces | `ker(M ∓ I)` | image of `(I ± M)/2`, then `Mv = ±v` re-checked |
| `F|_{W⁻} = 0` | symbolic expansion | interpolation (5 points ⇒ the 4-coefficient binary cubic is 0) |
| `C_G(σ) ≅ D12` | `Z/2 × S3` decomposition | `⟨r,s : r⁶ = s² = 1, srs = r⁻¹⟩` |
| `j`, route A | order-3 element `ρ`, eigen-order `1, ω, ω²` | the other generator `ρ²`, eigen-order `ω², ω, 1` |
| `j`, route B | first admissible completion basis | reversed completion basis |
| subspace intersections | double annihilator | `dim U + dim V − rank[U;V]` |
| `j` formulas | used | re-derived symbolically in `verify_j_formulas.py` |
