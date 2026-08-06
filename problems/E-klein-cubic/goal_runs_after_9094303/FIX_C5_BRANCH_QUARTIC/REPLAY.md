# REPLAY — FIX-C5 (the branch quartic `Δ_v` of the χ₁-vertex projection)

Everything is exact characteristic zero; no floating point enters any decision.
Total wall time for the whole packet ≈ 4 minutes.

```sh
cd /Users/worker/unirational/problems/E-klein-cubic/goal_runs_after_9094303/FIX_C5_BRANCH_QUARTIC
```

## 0. Prerequisites

* `python3` (3.9+) with `sympy` (`mpmath` ships with it; used **only** for the
  printed 40-digit sanity block in the verifier).
* `M2` (Macaulay2) and `julia` with `Oscar` — for the two CAS routes.
* Read-only dependencies (never written to):
  * `goal_runs_after_9094303/FIX_L1_FRAME_CONSTANTS/produce_l1.py` — `build_frame`,
    used by the producer **only** for the 55-arrangement-line question;
  * `goal_runs_after_6519c0b/FIX_H0_GLOBAL_SECTIONS/klein_exact.py` — the shared
    exact `PSL(2,11)` library (same use);
  * `goal_runs_after_a90dbe1/FIX_N2C_R7_DECISION/` — the sealed `λ = 1` witness,
    used by `smoke_gamma.py`.
* The **verifier imports nothing from any sibling packet.**

## 1. Produce

```sh
python3 produce_c5.py > logs/PRODUCE.log 2>&1
tail -1 logs/PRODUCE.log        # -> FIX_C5_PRODUCE_OK      (139 exact checks, ~85 s)
```

Runtime is dominated by the sympy number-field factorisation in part D (~80 s).
Writes

* `payloads/PAYLOAD_GEOMETRY.txt` — the compact sheet (closed forms, node table,
  line census, V4 structure). **Read this first.**
* `payloads/PAYLOAD_C5.txt` — the full log, parts A–F.
* `payloads/c5_data.json` — machine-readable.

| part | content |
|---|---|
| A | `v ∈ X`; §5.19's `(ℓ,q,k)` verbatim and the `x′`-cancellation; the independent "quadratic in `x`" route; the closed form; `Δ_v ≡ (cyz)² mod Q₁`; V4-invariance; the frame specialisation |
| B | the incidence system, the six lines, their images, the machine-computed V4-orbit table |
| C | the exact 8-case analysis of `Sing(Δ_v)`; the six nodes; the Hessian (node) test; position relative to `{Q₁=0}`, `{y=0}`, `{z=0}` |
| D | Lemma C5-I; sympy factorisation over `K`; the Galois action as coordinate swaps |
| E | V4-characters on `P³`; `Fix(V4)`; the elliptic-curve cross-check; the quotient `Δ_v/V4` in `P(1,1,2,2)` |
| F | the 55-arrangement-line question, decided three ways (enumeration, eigenline identification, `Stab(v)`) |

## 2. Verify (independent)

```sh
python3 verify_c5.py > logs/VERIFY.log 2>&1
tail -1 logs/VERIFY.log         # -> FIX_C5_VERIFY_OK       (180 exact checks, ~0.1 s)
```

`verify_c5.py` is **self-contained**: it implements its own exact number field
`K = Q(ω,ν)` (basis `1, ω, ν, ων`, its own multiplication table and inversion),
its own quadratic extensions `K(ρ)` with `ρ² = ±3ν/8`, and its own sparse
multivariate polynomial arithmetic — **no sympy, no `klein_exact`, no group
theory**. It re-derives `Δ_v` by a **third** bookkeeping (the Sylvester
resultant `Res_x(F, ∂F/∂x) = −Q₁Δ_v`), re-runs the whole singular-locus case
analysis, re-checks every node and every Hessian, **proves from scratch** that
`±3ν/8` are nonsquares in `K` (with four controls), re-derives the quotient
identities, and finally compares every structural field of
`payloads/c5_data.json`.

It opens with a **self-test** (§0 of its log): that `check()` really fires on a
false statement, that its field/quadratic-extension/polynomial arithmetic obey
`(ω+ν)² `, inversion, conjugation, `(p+q)³`, differentiation and evaluation
identities, and that `is_rational_square` accepts `49/25` and rejects `2`.

Failure mode: `AssertionError: CHECK FAILED: …`.

## 3. The two CAS routes

```sh
M2 --script m2/c5_sing.m2 > payloads/PAYLOAD_M2.txt 2>&1
tail -1 payloads/PAYLOAD_M2.txt        # -> FIX_C5_M2_OK        (~5 s)

julia oscar/c5_oscar.jl > payloads/PAYLOAD_OSCAR.txt 2>&1
tail -1 payloads/PAYLOAD_OSCAR.txt     # -> FIX_C5_OSCAR_OK     (~60 s incl. startup)
```

* **M2** works over `toField(QQ[om,s]/(om²+om+1, s²−33))`. It returns
  `dim Sing = 0`, `degree 6`, `Q₁ ∈ Js`, and
  `intersect(P_y,P_z,N_y,N_z) == Js`, and it checks the incidence ideal of the
  contracted lines **equals** the jacobian ideal.
  *Note (toolchain limitation):* M2's `factor`, `minimalPrimes` and `radical`
  are **not available over a number field** built with `toField` — they error
  with "expected coefficient ring of the form ZZ/n, ZZ, QQ, or GF" resp. "no
  applicable strategy". Only `dim`/`degree`/`saturate`/ideal comparison are used
  from M2; factorisation and primary decomposition come from OSCAR and sympy.
* **OSCAR** works over the primitive-element field `K = Q(u)`,
  `u⁴+28u²+64 = 0`, with `delta = (u²+8)/(2u)`, `om = (delta−1)/2`,
  `nu = u − delta`, `sqrt33 = −(u²+14)/2` (all four defining relations asserted
  at the top). It returns the factorisation (1 irreducible factor), the
  radicality of `Js`, and the 4-component primary decomposition.

**Controls** (so that no "empty"/"zero-dimensional" answer is vacuous) are built
into both scripts: a deliberately reducible quartic must give `dim Sing = 1`
(and 2 factors), a perfect square must give `dim Sing = 2` (and multiplicity 2),
a smooth quartic must give the unit ideal, and `Js ≠ (1)` is printed explicitly.

## 4. The γ-criterion smoke test (secondary)

```sh
python3 smoke_gamma.py > logs/SMOKE.log 2>&1
tail -1 logs/SMOKE.log          # -> FIX_C5_SMOKE_OK        (61 exact checks, ~55 s)
```

Rebuilds and re-verifies the sealed FIX-N2C `λ = 1` witness **in place**
(read-only; the script `chdir`s into that packet so its own relative imports
work, then restores the cwd), extracts the parity shapes `(Ã,B̃,γ̃,Ỹ,Z̃)`, and
evaluates §5.19's single invariant-variables identity in three sign
conventions. Result: **FINDING C5-1** (the dictionary is `γ = −u₀′`, not
`u₀′ = xγ̃`) and **FINDING C5-2** (the identity carries exactly 52 occupied
coefficients out of 55, matching the raw 52-equation slot system one-to-one).
See `payloads/PAYLOAD_SMOKE.txt` and STATUS §7.

## 5. What to look at

```sh
cat payloads/PAYLOAD_GEOMETRY.txt                  # the whole answer on one page
sed -n '/^A2 /,/^A7 /p' payloads/PAYLOAD_C5.txt    # the sec.5.19 verification
sed -n '/^C2 /,/^C7 /p' payloads/PAYLOAD_C5.txt    # the singular-locus case analysis
sed -n '/^B3 /,/^B5 /p' payloads/PAYLOAD_C5.txt    # the line census + orbits
sed -n '/^F1 /,/^F5 /p' payloads/PAYLOAD_C5.txt    # the 55-line verdict
sed -n '/^S3 /,/^S6 /p' payloads/PAYLOAD_SMOKE.txt # the gamma-criterion sign finding
```

## 6. Determinism

* The producer's part F calls `FIX_L1_FRAME_CONSTANTS.build_frame(0, 0)`, which
  builds `PSL(2,11)` by BFS in a fixed generator order; it reproduces FIX-L1's
  own frame (`σ = invs[0] = g[1]`, `K₁ = (1, 385, 454)`), and those indices are
  printed in the log, so any drift would be visible immediately. The **verdict**
  (two arrangement lines through `v`, both in the frame V4) is frame-independent
  by construction, since it is stated as an identification of eigenlines.
* Nothing else depends on any ordering. The verifier and both CAS scripts are
  fully deterministic.
