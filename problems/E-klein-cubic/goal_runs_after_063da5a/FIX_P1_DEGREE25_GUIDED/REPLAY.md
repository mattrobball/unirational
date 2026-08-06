# FIX-P1 — replay

Working directory: this packet. Toolchain: `python3` only (numpy + sympy).
No Macaulay2 / msolve is used: **the Stage-2 verdict is linear-algebraic**, so
there is no polynomial system to hand to a Gröbner engine. The two-engine
requirement is met by two independent *linear* engines (see §3).

Total wall time on the reference machine: ~45 minutes, dominated by the sweep.

---

## 1. Stage 1 — the sieve (seconds)

```
python3 produce_sieve.py
```
Expected tail:
```
d=24 surviving: [(3, 6, 18)]
d=25 surviving: [(3, 6, 19)]
d=26 surviving: [(3, 6, 20)]
first evasion d : 27
first classified-alive d : 33
first non-(3,6) d : 31
```
Writes `payloads/SIEVE_TABLE.json` and `payloads/SIEVE_TABLE.txt`.
The human-readable table has one line per `(d, m, r)`; `d ≤ 23` prints
`-- no admissible profile --` (Theorem P1-A).

## 2. Exact Molien dimensions (~2 minutes)

```
python3 produce_molien.py
```
Expected: `d=25 dim M_d = 189`, `#landing eqns = 2343`; also
`121, 140, 161` at `d = 22, 23, 24` and `410, 459, 511, 576, 637` at
`d = 31 … 35`. All self-tests inside the script are `assert`s
(`⟨χ,χ⟩ = 1`, `⟨χ,1⟩ = 0`, `dim M_0 = 0`, `dim M_1 = 1`,
`dim (Sym³W*)^G = 1` — the Klein cubic). Writes `payloads/MOLIEN.json`.

Cross-check against the repo's independent engine (read-only):
`certificates/exact_molien.py` — same numbers.

## 3. Stage 2 — the degree-25 profile slice (~1 minute per prime)

```
python3 produce_slice.py 67  3000 150
python3 produce_slice.py 199 3000 150
python3 produce_slice.py 331 3000 150
```
Expected, identically at all three primes:
```
[phase1] evaluation rank of the seed set = 189 (dim M_25 = 189)
  ord_{P_sigma} >= 1  (55 plus-planes in base locus) rank  130   dim of slice =   59
  ord_{P_sigma} >= 2                             rank  186   dim of slice =    3
  ord_{P_sigma} >= 3  (m = 3, minus half)        rank  189   dim of slice =    0
  ord_{ell_V} >= 6    (cone order r = 6) ALONE   rank  189   dim of slice =    0
  FULL PROFILE SLICE  (A) and (B) together       rank  189   dim of slice =    0
[verdict] PROFILE-SLICE-EMPTY
```
Writes `payloads/SLICE_p{67,199,331}.json`.

*Note on the sampling parameters.* `nseeds = 3000` is needed only because the
monomial-seed generator is biased; the script `assert`s that the Reynolds
averages actually span `M_25` (evaluation rank `= 189`) before doing anything
else, so an insufficient seed count aborts rather than under-reports.
`npair = 150` is what saturates the *intermediate* ranks (59 and 3); the
headline zero is already reached at `npair = 26`, and more functionals can only
shrink a kernel, never grow it.

## 4. Stage 2, extended — the sweep (~15 min for 24–33, ~25 min for 34–38)

```
python3 produce_sweep.py 67 24 33
python3 produce_sweep.py 67 34 38
```
Expected: `slice dim = 0` on every printed line for `d = 24..35`; from `d = 36`
the `(1,6)` rows become nonzero (`83, 127, 173`) while every `m >= 3` row stays
`0`. Writes
`payloads/SWEEP_p67_24_33.json`, `payloads/SWEEP_p67_34_38.json`.
A degree whose seed search falls short prints `SEED SHORTFALL … NOT DECIDED`
and is recorded as `NOT-DECIDED` — never as empty.

## 4b. Calibration control (~2 minutes)

```
python3 produce_calibration.py 199
```
Expected `plane ladder 189, 59, 3, 0, 0, 0` and
`line ladder 189, 173, 153, 102, 50, 0, 0, 0, 0, 0`, `monotone: True`.

## 5. Independent verifier (~3 minutes)

```
python3 verify_p1.py
```
Ends with `FIX_P1_VERIFY_OK` and a check count. Its independence:

| claim | producer engine | verifier engine |
|---|---|---|
| the sieve | enumeration in `produce_sieve.py` | re-enumerated from the raw constraint list, compared cell by cell for `d = 1..44` |
| `n = 3μ` dictionary | read off Theorem N2B-2 + FIX-H1's `Λ` | degree bookkeeping re-derived from "`D_B` is cubic in `X`", and `ord = 3·min(a,b)` re-derived from the four exponent shapes |
| `dim M_d` | character table + DFT eigenvalue recovery in `Z[z]/Φ₃₃₀` | Faddeev–LeVerrier char polys of the **660 explicit matrices** mod `p`, summed |
| the jets | truncated power series in `t` | 26 point **evaluations** + Vandermonde inversion |
| the frame | — | rebuilt from the defining formulas at a different prime, all self-tests re-run |

Controls inside the verifier: the non-unit controls (`59` and `3` must be
nonzero and must match the repo's independent degree-25 ledger), the unit
control, and a self-test recovering `dim M_d` for `d = 4,5,6,7,10,12,18`.

## 6. What a failure would look like

- `assert rk == DIM_M25` firing ⇒ the seeds do not span; raise `nseeds`.
  (Never interpret a shortfall as emptiness.)
- a nonzero `dim of slice` ⇒ **not** a candidate: a nonzero *modular* kernel
  bounds nothing in char 0. It would have to be lifted (exact `Q(ζ₃₃)` linear
  algebra) before anything is claimed, and then the landing equations
  `F(T) ≡ 0` (2343 of them at `d = 25`) would still have to be solved.
- disagreement between primes ⇒ one of the primes is bad for the frame; both
  runs are discarded and `NOT-DECIDED` is reported.
