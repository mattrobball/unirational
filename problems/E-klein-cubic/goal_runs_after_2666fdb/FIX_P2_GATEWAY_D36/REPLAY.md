# FIX-P2 — replay

Working directory: this packet. Toolchain: `python3` (numpy) only — every
verdict here is **linear-algebraic or exact number-field linear algebra**, so
no Gröbner engine is invoked. The two-engine requirement is met by two
independent *linear* engines per claim (see `verify_p2.py`'s table).

Reference-machine wall time: ~3 h, dominated by the corrected sweep.

Copied read-only from siblings (as FIX-H2 did with FIX-H1's scripts):
`slicelib.py`, `produce_molien.py`, `produce_sieve.py` from
`goal_runs_after_063da5a/FIX_P1_DEGREE25_GUIDED/`; `k0.py` from
`goal_runs_after_541e12f/FIX_H1_EQUALIZER/`.

---

## 1. Exact Molien dimensions (~3 min)

```
python3 produce_molien.py
```
`DMAX` was raised from 40 to 50. Expected `d=36 dim M_d = 706`,
`d=37 786`, `d=38 865`. Writes `payloads/MOLIEN.json`; the verifier checks it
against FIX-P1's independently produced payload for every `d ≤ 40`.

## 2. Engine 1 — the exact equalizer at the tight window (~17 s)

```
python3 produce_equalizer36.py
```
Exact over `K0 = Q(ω, ν)`, `ν² = −11`. Expected:

```
===== THE GATEWAY WINDOW d = 36 :  (m,r) = (1,6) , e = 5 , d = 36 , n = 30
  H1-1(a) degree bound n >= 6e = 30 :  n = 30  ->  TIGHT (equality)
  L0 = V[sgn^e] ... = < (1) z E_y + (5/6 + -1/6*nu) y E_z >
  L1 = Im(ev_v0) at order 1 ... = < (1) z E_y + (-5/6 + 1/6*nu) y E_z >
  L0 == L1 ?  NO
  VERDICT: WINDOW-EMPTY-BY-EQUALIZER
```
and the control reproducing FIX-H1 §9 branch (ii) verbatim
(`L0 = <id>`, `L1 = <diag(1,−1)>`) and branch (i)'s 3-dimensional order-1
span. Ends with the tight-window scan: **69 of 69 profiles** have
`dim(L0 ∩ L1) = 0`. Writes `payloads/EQUALIZER36.json`,
`payloads/PAYLOAD_equalizer36.txt`.

## 3. Engine 2 — the dimension cascade at `d = 36` (~6 min)

```
python3 produce_cascade.py 67 36 36
```
Expected:
```
  d=36 (m,r)=(1,6)  1: ord_{P_sigma} >= 1              dim = 413
  d=36 (m,r)=(1,6)  2: + ord_{P_sigma}(T^+) >= 2       dim = 413
  d=36 (m,r)=(1,6)  3: + ord_{ell_V} >= 6              dim = 83
  d=36 (m,r)=(1,6)  4: + H1-1(a) (order >= 10)         dim = 83
  d=36 (m,r)=(1,6)  5: + H1-1(b) lambda_10 in L0       dim = 83
  d=36 (m,r)=(1,6)  6: + H1-1(c) lambda_11 in L1       dim = 83
  ... (3,6) (3,7) (5,9) : 0 already at step 1
```
The 83 replicates FIX-P1. Steps 4–6 adding nothing is the *content*: the
whole local content of Theorem H1-1 at `c_σ` is already forced by the
plane/line orders. Writes `payloads/CASCADE_p67_36_36.json`.

## 4. The two diagnostics (~3 min and ~6 min)

```
python3 diag_leading.py 67 36 6      # which bidegrees survive on the slice
python3 diag_d12.py    67 36 6 13    # the three D12-points, order by order
python3 diag_d12.py   199 36 6 11    # second prime
```
`diag_leading` must show the `(a,b) = (5,1)` MINUS entry **nonzero** (rank 12
at 6 sampled points) — the leading `(1,6)` datum is present on the slice — and
zeros exactly where the V4-character rule forbids.
`diag_d12` must show

```
   k :       0    1    2    3    4    5    6    7    8    9   10   11
  c_1:       0    0    0    0    0    0    0    0    0    0    1    2
  c_2:       0    1    2    2    2    2    2    2    2    2    2    2
  c_3:       0    1    2    2    2    2    2    2    2    2    2    2
```
i.e. order `2e = 10` forced at `c_σ` (sharply) and order **1** at the other two
D12-points. This is the measurement behind FINDING P2-C.

## 5. The corrected sweep (~2.5 h)

```
python3 produce_sweep2.py 67 25 33
python3 produce_sweep2.py 67 34 38
```
Enumerates every profile admissible under the **corrected** bound `n ≥ 2e`
(`d ≥ 3r − 2m`) — 357 profile-slices over `d = 25…38`, against FIX-P1's 21 —
and computes each slice. Writes `payloads/SWEEP2_p67_*.json`.
A row printing `slice dim = 0` is a characteristic-zero emptiness verdict for
that `(d,m,r)`; a nonzero row is an upper bound only.

## 6. Independent verifier (~5 min)

```
python3 verify_p2.py 331
```
Ends with `FIX_P2_VERIFY_OK`. Independence table in the script's docstring;
the sharpest check is **[B]**, which re-derives the adapted V4/D12 frame *and*
the bivariate jet engine from the V4-character selection rule on an actual
covariant module (every bidegree must be nonzero exactly when the character
arithmetic allows it), and **[D]**, which recomputes both equalizer lines with
Reynolds projectors instead of nullspaces.

## 7. What a failure would look like

- a nonzero `slice dim` is **not** a candidate: a nonzero modular kernel bounds
  nothing in characteristic zero (`slicelib.__doc__`).
- `assert rk == dim M_d` firing in `basis_seeds` ⇒ the seeds do not span; raise
  the block size. Never read a shortfall as emptiness.
- disagreement between `p = 67` and `p = 199/331` ⇒ both runs discarded,
  `NOT-DECIDED`.
- in `diag_d12`, a `c_1` row that is *not* `0×10` would contradict Theorem
  H1-1(a) at `c_σ` and would mean the extraction, not the theorem, is wrong.
