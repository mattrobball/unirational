# REPLAY — FIX-D2

Working dir: `/Users/worker/unirational/problems/E-klein-cubic/goal_runs_after_354a548/FIX_D2_TERMINAL_SYSTEM`

Requirements: `python3` only (no sympy, no numpy, no network) for everything
decisive. Macaulay2 (`/opt/homebrew/bin/M2`) only for the indicative (C7)
slice, which decides nothing here.

## 1. Producer (frame, contraction ranks, witnesses, controls)

```sh
python3 produce_d2.py
```
Runtime ≈ 20 s. Writes `payloads/PAYLOAD_D2.txt`, `payloads/d2_partA.json`
… `payloads/d2_partE.json`. Expect `PART A: 23 checks, 0 failures` and
`PART E: 6 controls, 0 harness failures`.

Decisive lines to look for:

```
  m=1  I0   Theta^(0)    Psi=id=V1[triv]      9     5     5      4     <- kernel 4, NOT 0
  m=1  I1   Theta^(1)    Psi=id=V1[triv]     15     7     7      8     <- Thm 5.26-A confirmed
    m=1   V1[triv]       2     1      1                                <- FIX-L1 regression
```

## 2. (C2′) rung ladder

```sh
python3 produce_c2prime.py            # rungs 0..3  (m=3 capped at 0..2)
KMAX=4 python3 produce_c2prime.py     # one rung deeper (slower, ~10x)
```
Runtime ≈ 3 min at the default `KMAX=3`. Writes
`payloads/PAYLOAD_C2PRIME.txt`, `payloads/d2_c2prime.json`.

Expect at `m = 1`: `surjectivity deficit [0,0,0,0]`, `overlap deficit
[0,0,0,0]`, `RUNGS INDEPENDENT: YES`.
Expect at `m = 3`: `surjectivity deficit [0,1,0]`, `overlap deficit [0,1,1]`,
`RUNGS INDEPENDENT: NO`.

## 3. Independent verifier

```sh
python3 verify_d2.py ; echo "exit=$?"
```
Runtime ≈ 40 s. Exit 0 iff every check passes. Writes
`payloads/PAYLOAD_VERIFY.txt`. Expect `VERIFIER: 68 checks, 0 FAILURES`.

The verifier shares **no code and no field model** with the producer: it
builds `K` as `Q[x]/(x⁴+2x³+25x²+24x+111)` (minimal polynomial of `θ = ω+ν`),
recovers `ω = (θ²+10)/(2θ+1)` and `ν = θ − ω` inside it, posits only
`ρ|_{W⁻}`, `τ|_{W⁻}` and the normal-form `Q`, and derives `ρ|_{W⁺}`, `c_σ`,
`kp`, `km` and all four `V_m[twist]` generators itself.

## 4. (C7) plus-deep slice (indicative only — see STATUS §5.1)

```sh
/opt/homebrew/bin/M2 --script m2/C7_nf.m2 > logs/C7_nf.log 2>&1
```
Source system: `goal_runs_after_a90dbe1/FIX_N2C_R7_DECISION/m2/M_nf_one_B5.m2`
(read-only), with `P0` and `R0` appended to the ideal — those are the two
order-2 plus coefficients §5.27 names. Chart `B5 = 1`, so the run does **not**
see the `{a′ = b′ = 0, u₀′ = 0}` component; it is not a component census.
A mod-`p` variant is in `m2/C7_fp.m2` (`F_100057`).

**As run here both TIMED OUT** (~30 min char 0, ~4 min mod `p` before both were
killed): the result is **NOT-DECIDED** by the packet's own discipline, and
nothing in STATUS.md depends on it.

## 5. Read-only inputs

```
theory/FIX_IV_closure.md                                    §§5.7, 5.8, 5.15, 5.21-5.27
goal_runs_after_9094303/FIX_L1_FRAME_CONSTANTS/STATUS.md    the σ-frame (reused verbatim)
goal_runs_after_541e12f/FIX_H1_EQUALIZER/payloads/PAYLOAD_theorem.txt
goal_runs_after_a90dbe1/FIX_N2C_R7_DECISION/m2/M_nf_one_B5.m2   (C7 source, read-only)
```

Nothing outside this packet directory was written. No `git` operations were
performed.
