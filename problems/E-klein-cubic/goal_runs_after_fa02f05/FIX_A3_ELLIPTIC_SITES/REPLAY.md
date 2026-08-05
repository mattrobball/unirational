# FIX-A3 — exact replay

Packet: `goal_runs_after_fa02f05/FIX_A3_ELLIPTIC_SITES/`
Repo HEAD when produced: `fa02f05`.
Toolchain: `python3` (stdlib only; the local `klein_exact.py` implements exact
`Q(ζ₁₁)` / `Q(ζ₁₁,ω)` arithmetic from scratch, same as FIX-A0). No GAP, no
Sage, no Magma, no PARI/GP, no Macaulay2 — the whole computation is one plane
cubic and a handful of group elements. No floating point anywhere.

Environment used: Python 3.14.6 (sympy 1.14.0 is installed but not required
by either script — the deliverable does not depend on it).

```sh
cd "$(git rev-parse --show-toplevel)/problems/E-klein-cubic/goal_runs_after_fa02f05/FIX_A3_ELLIPTIC_SITES"

# 1. produce sites.json  (~1 s)
python3 produce_fix_a3.py

# 2. independent recomputation + comparison  (~1.6 s)  -- ALGEBRAIC-RECOMPUTE
python3 verify_fix_a3.py
```

## Expected output

* `produce_fix_a3.py` — ends with `wrote sites.json`, `DONE.`,
  `FIX-A3-SITES-PASS`. Every intermediate `assert` must pass (the script
  aborts with a traceback on any failure — there is no soft-fail path).
  Log lines of note: for each of the two representatives, `disc!=0` and
  `on X: True` for all 3 `V4`-lines/type-I points; `Fix(C3) cap X ... (True=on
  X): [False, False, False]`; `Fix(S3)=Fix(H) ... off X: True`; `Fix(tau_i)
  cap Fix(tau_j) = {D12 point} for all 3 pairs: confirmed`; the type-I
  residual stabilizer printed as `[0, tau]` for each of the 3 `τ`'s; the
  conjugation-transport line; the cross-reference dict with
  `'reconciles_with_our_3_plus_9': True`; the modular spot-check line.
* `verify_fix_a3.py` — ends with
  `VERIFY: PASS -- all FIX-A3 claims independently recomputed ... and
  matched.`; exit code 0. Any failure prints `*** FAIL: <name>` for every
  failing check (not just the first) and exits 1 with `VERIFY: FAIL -- [...]`.

## Files

| file | role |
|---|---|
| `klein_exact.py` | local copy of `goal_runs_after_2880a28/FIX_A0_INVOLUTION_ARRANGEMENT/klein_exact.py` (byte-identical, `md5 12aed53af71b55139184adc217e8db50`); exact `Q(ζ₁₁)`/`Q(ζ₁₁,ω)` arithmetic, linear algebra, the group `⟨S,T⟩`, the Klein cubic, sparse multivariate polynomials |
| `produce_fix_a3.py` | producer: builds the group; for two representative involutions, computes `W±_σ`, the centralizer `C_G(σ)` and a residual-`S3` complement `H`, `Fix(H',P²)` for the 3 conjugate `C2`'s / the `C3` / `S3` itself, intersects each with `E_σ`, runs the residual-stabilizer argument, computes the invariant line `P(std)`, cross-references the FIX-A0/FIX-A1 payload JSONs (read-only), runs a modular irreducibility spot-check; writes `sites.json` |
| `verify_fix_a3.py` | independent recomputation (different algorithms throughout — see STATUS.md "Verification class") + comparison against `sites.json`; **the certificate** |
| `sites.json` | the exact site inventory (see STATUS.md for the reading guide) |
| `STATUS.md` | exits, per-item verdicts, the `Fix(H,P²)` table, findings, cross-reference |
| `REPLAY.md` | this file |

## Determinism

Deterministic: no randomness, no sampling, no timing-dependent paths. The
group build is BFS from the fixed generators `S,T` in `klein_exact.py`
(identical code to FIX-A0's), so the involution/element indexing matches
FIX-A0's payloads exactly — checked explicitly by the producer
(`same_involution_indexing_as_FIX_A0`) and used only for cross-reference
convenience, never assumed without checking. `sites.json` is not registered
as byte-reproducible across Python versions (dict key ordering / JSON
formatting could vary in principle), but every numeric payload inside it is
exact (integer numerator / integer denominator pairs, never floats).

## Independence of the verifier

| step | producer | verifier |
|---|---|---|
| group certification | BFS from `S,T` only | BFS from `S,T` **plus** a second non-indexed closure (`K.build_group()`) **plus** exact Cayley-graph consistency with `PSL(2,11)` over `F₁₁` (the producer performs none of this) |
| `W±_σ` eigenspaces | `ker(A ∓ I)` | image of the averaging projector `(I ± A)/2` |
| residual-`S3` organizing principle | a chosen complement `H ≅ S3 ≤ C_G(σ)` (`⟨ρ,τ₀⟩`) | the three `V4 = ⟨σ,t⟩ ≤ C_G(σ)` subgroups directly (complement-choice-independent) |
| `V4`-line / type-I point | `act_matrix` on `W⁺` then `eigenspace`, cross-checked against a direct 5-dim `subspace_intersection` | averaging projector over the 4 elements of `V4`, and over `W⁻_t` via `(I-A_t)/2`, throughout |
| type-II reducedness | explicit discriminant formula (`18abcd-4b³d+b²c²-4ac³-27a²d²`) | Sylvester resultant `Res(f,f')` |
| `C3`-eigenpoints | diagonalize the `3×3` `W⁺`-restricted matrix of `ρ` over `Cyc3` | diagonalize the **ambient `5×5`** matrix of `ρ` over `Cyc3` (via the projector `(1/3)Σλ⁻ᵏAᵏ`), then intersect the 2-dim `ω`/`ω²` ambient eigenspaces with `W⁺` |
| `S3`/`D12` fixed point | `fixed_space_5d` (nullspace of stacked `(A-I)` rows) over `cd['C']` | averaging projector over all 12 elements of `C_G(σ)` |
| `P(std)` (invariant line) | `ker(M_ρ² + M_ρ + I)` on the `W⁺`-restricted matrix (`Cyc`-only, no `ω`) | `ker(Π_{C_G(σ)})` (ambient 5-dim projector-kernel) intersected with `W⁺` |
| residual-stabilizer pairwise check | `fixed_space_5d([τᵢ,τⱼ])` (nullspace) | averaging projectors `(I+A_{τᵢ})/2`, `(I+A_{τⱼ})/2`, then `subspace_intersection` |
| modular irreducibility spot-check | `p=23`, 1 line (`σ₀`'s first `V4`) | `p=67`, all 6 lines (both representatives) |
| cross-reference | reads FIX-A0/FIX-A1 payload JSONs directly | re-checks the producer's `xref` block plus the `summary` totals |

## Provenance / dependencies read (read-only, not modified)

* `theory/FIX_III_cosheaf.md` §1 — the mission statement this packet answers.
* `goal_runs_after_2880a28/FIX_A0_INVOLUTION_ARRANGEMENT/payload_arrangement.json`
  — cross-referenced for the involution BFS-index order and the 55-`V4`-subgroup
  list (matching confirmed exactly, not assumed).
* `goal_runs_after_2880a28/FIX_A1_V4_INCIDENCE_REPAIR/v4_exact.json` —
  cross-referenced for `per_involution_counts` (`3` type-I / `9` type-II per
  `E_t`), matched exactly.
* `goal_runs_after_bc93561/FIX_A2_SOURCE_COMPLEX/STATUS.md` — read for the
  `D12`/`D10`/`A4` deep-point taxonomy (not re-derived; cited in STATUS.md
  item 3's discussion of why `D10`/`A4` don't arise from residual-`S3` fixed
  loci at all).

Neither sibling packet's files were edited. No git commits were made by this
packet.
