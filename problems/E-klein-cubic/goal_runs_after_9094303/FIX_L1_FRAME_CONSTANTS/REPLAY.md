# REPLAY — FIX-L1 (exact σ-frame constants for the [L] transfer condition)

Everything is exact (no floating point in any decision) and runs in seconds.
Toolchain: `python3` only. No Macaulay2, no msolve, no external data.

## 0. Prerequisites

* `python3` (3.9+). `mpmath` (ships with sympy) is used **only** for the
  40-digit sanity numerics in the verifier.
* Read-only dependency: the shared exact-arithmetic library
  `goal_runs_after_6519c0b/FIX_H0_GLOBAL_SECTIONS/klein_exact.py`
  (used by the **producer** only; the verifier imports nothing from siblings).
* Regression targets (read-only, not required to run):
  `goal_runs_after_541e12f/FIX_H1_EQUALIZER/produce_h1_frame.py`,
  `.../payloads/PAYLOAD_frame.txt`, `.../payloads/PAYLOAD_theorem.txt`.

## 1. Produce

```sh
cd /Users/worker/unirational/problems/E-klein-cubic/goal_runs_after_9094303/FIX_L1_FRAME_CONSTANTS
python3 produce_l1.py > logs/PRODUCE.log 2>&1
tail -1 logs/PRODUCE.log        # -> FIX_L1_PRODUCE_OK
```

Runtime ≈ 3 s. Writes

* `payloads/l1_constants.json` — machine-readable; every constant in three
  encodings (`cyc33` = exact vector in `Q(ζ₃₃)`, `K4` = coordinates in
  `1, ω, ν, √33`, `num` = double), plus all structural verdicts.
* `payloads/PAYLOAD_CONSTANTS.txt` — the compact constants table + verdicts.
* `payloads/PAYLOAD_L1.txt` — the full log (parts A–G).

What the producer does, part by part:

| part | content |
|---|---|
| A | rebuilds PSL(2,11) in the 5-dim Weil representation from generators; finds σ, `W^±`, `c_σ`, `K₁`, ψ, the A₄-adapted frame with the ω-pattern; **rescales to normal-form coordinates** (the ratios `s_j/s_i` all lie in `Q(ζ₃₃)`; the cube root `X` itself is never needed); regression against the H1 closed forms |
| B | `F` in normal form; the A3 split `F(w+y) = F₀(w) + Q(w;y,y)`; `F₀(c_σ) ≠ 0`; exact `ρ`/`τ`-invariance of `F`, `F₀`, `Q` |
| C | isotypic bases `Ω, q₀, c_σ, u±, v±`; `α`, `β`; Schur cross-checks; the identities `α = 12c = 16kp − 4`, `F(c_σ) = c³` |
| D | generators of `V_m[triv]`, `V_m[sgn]` for `m = 1,3`; Lemma 5.1 dimension check; H1 `V₃[sgn]` regression; the `diag(1,−1)` disambiguation |
| E | `(γ⊗γ)_t`, `(γ⊗γ)_s`; the vectors `α(γ⊗γ)_t`, `β(γ⊗γ)_s` |
| F | `Hom(Sym^{m+1}W⁻,W⁺)^{S3}` in the canonical t/s-adapted basis; the §5.8 channel identities; the rank of the transfer map and the verdicts |
| G | frame independence over 11 `(σ, V4)` rebuilds |

## 2. Verify (independent)

```sh
python3 verify_l1.py        # writes payloads/PAYLOAD_VERIFY.txt (+ logs/VERIFY.log)
                            # prints FIX_L1_VERIFY_OK (272 checks)
```

Runtime ≈ 0.3 s. `verify_l1.py` is **self-contained**: it implements its own
exact number field `K = Q(ω,ν)` (`ω²+ω+1 = 0`, `ν² = −11`, degree 4 over `Q`)
from scratch — no `klein_exact`, no `sympy`, no group theory — and rebuilds the
frame by a **different route**:

* inputs are only the two certified H1 closed forms `ρ|_{W⁻}`, `τ|_{W⁻}` and
  the *shape* of the V4-packet normal form (1.1);
* it proves `Q : W⁺ → (Sym²W⁻)*` is an isomorphism (`det = δ ≠ 0`) and
  therefore **derives** `ρ|_{W⁺}`, `τ|_{W⁺}` from `ρ|_{W⁻}`, `τ|_{W⁻}`;
* it **derives** `β_{c_σ} = −(7+√33)/4` as the S3-fixed point of `W⁺`
  (not by picking a root of `β³+3β²+kp`);
* it **derives** `(kp, km) = ((13±3√33)/16)` from S3-invariance of `F₀`;
* then it recomputes `Ω, q₀, ℓ, α, β`, all four generators, all `(γ⊗γ)_{t,s}`,
  all four transfer ranks/kernels, and compares **every** number against
  `payloads/l1_constants.json`;
* finally it re-evaluates the closed forms to 40 digits with `mpmath` and
  checks agreement to `< 1e−35`.

Failure mode: any mismatch raises `AssertionError: CHECK FAILED: …`.

## 3. What to look at

```sh
cat payloads/PAYLOAD_CONSTANTS.txt          # the constants table + verdicts
sed -n '/== C\./,/== D\./p' payloads/PAYLOAD_L1.txt   # alpha, beta and the identities
sed -n '/== F\./,/== G\./p' payloads/PAYLOAD_L1.txt   # the transfer condition, in full
sed -n '/== 5\./,$p' payloads/PAYLOAD_VERIFY.txt      # the 40-digit numerics
```

## 4. Determinism

`Grp()` builds `PSL(2,11)` by BFS in a fixed generator order, so `σ = invs[0]`
is the same element as in `FIX_H1_EQUALIZER/produce_h1_frame.py`
(`σ = g[1]`, `K₁ = (1, 385, 454)`, `ψ = g[138]`, `ρ = g[145]`, `τ = g[385]`);
the log prints these so a drift would be visible immediately. Part G re-runs
the whole frame construction for 10 further `(σ, V4)` pairs and asserts the
same closed forms, so the results do not depend on that choice.
