# Hostile audit of the director landing-cone probes

**Packet:** `goal_runs_20260812/CONE_PROBE_AUDIT/` · 2026-08-12.
**Headline: Problem E remains OPEN; this packet excludes no degree.**

Independent check of `director_probes_20260812/`
(`jacobian_rank_probe.py`, `section_deficiency_probe.py`,
`cone_dimension_probe.py`, README). No import of `slicelib`. Own Weil
frame, own Reynolds values, own chain-rule Jacobian, own cubic expansion,
own `F_p` linear algebra. Primes `331` and `661`. Writes only here.

Machine markers: `CONE_PROBE_AUDIT_VERIFY_OK` / `ALLGREEN`
(`python3 verifier.py`).

## Exit ledger

```text
CONE-PROBE-AUDIT-R1-CONFIRMED
CONE-PROBE-AUDIT-R2-CONFIRMED
CONE-PROBE-AUDIT-R3-CORRECTED
CONE-PROBE-AUDIT-R4-CONFIRMED
CONE-PROBE-AUDIT-R5-CONFIRMED
CONE-PROBE-AUDIT-DIMV-LE-17-MODULAR
CONE-PROBE-AUDIT-NO-DEGREE-EXCLUSION
```

## Summary

| target | verdict | what stands |
|---|---|---|
| **R1** Jacobian rank 5, Euler `J(w)·w = 35 T(w)` | **CONFIRMED** | 5/5 cell and 5/5 ambient trials at both primes; own derivative |
| **R2** section ranks `56/120/220/1140/1330` full, `1380` at `m=20,22` | **CONFIRMED** | both primes; own expansion; form-check `8/8`; `P3=1380` |
| **R3** free argument `m=18,19` ⇒ `dim V ≤ 18` | **CORRECTED** | conclusion stands; genericity is not needed (exact fix below) |
| **R4** `m=20` leading-ideal ⇒ `dim V ≤ 17` | **CONFIRMED** | director artefact + own full-span `msolve -t 2` at both primes |
| **R5** semi-regular `dreg = 21/7/5` at `m=55/520/1380` | **CONFIRMED** | Hilbert numbers match; use the full span |

**`dim V ≤ 17` stands as a modular bound** (two primes, two generator
sets). It is not a characteristic-zero theorem and it excludes no degree.

---

## 0. What was audited

`V` is the landing cone `{c ∈ 37-cell : F(T_c(x)) ≡ 0}` at `d = 35`.
`F = ∑_k y_k² y_{k+1}`. The 37-cell is the six-flip kernel inside the
sealed 39-slice (`PAIR_ATTACK_D35` nullspaces and `universal_matrix_6x39`).

Director claims, in order: generic Jacobian rank 5 on the cell; no
section deficiency through `m = 22`; at `m = 18,19` the restricted cubics
fill `Sym³(L)` so `V ∩ L = {0}` and `dim V ≤ 18`; at `m = 20` an
`msolve` leading ideal is zero-dimensional so `dim V ≤ 17`; semi-regular
degree of regularity forces feeding the full cubic span, not a subset.

---

## 1. R1 — Jacobian rank: **CONFIRMED**

Own derivative: for each seed `s = x^α e_{c0}`,

```text
∂/∂x_j R(s)(w) = ∑_g ρ(g)^{-1}  (chain rule of x^α at ρ(g)w
                                 in direction ρ(g) e_j).
```

This is not a truncated `t`-series and does not call `jet_rows`.

| prime | cell ranks (5 trials) | Euler exact | ambient ranks |
|------:|---|---|---|
| 331 | `5,5,5,5,5` | 5/5 | `5,5,5,5,5` |
| 661 | `5,5,5,5,5` | 5/5 | `5,5,5,5,5` |

Control: `J(w)·w = 35·T(w)` holds on every trial. A second path
(Reynolds values contracted against the same `vec`) matches `T(w)`.

The director's rank-5 reading stands. `det J = 0` is a nontrivial closed
condition on the 37-cell. This packet does not run the dominance
membership test (Lane 3).

---

## 2. R2 — section deficiency: **CONFIRMED**

Own expansion of `F(∑_i t_i v_i)` uses the full `(i,j,ℓ)` tensor of the
two `A`-slots and one `B`-slot (different loop from the director's
`i ≤ j` / multiplicity code). Check: at 8 random `(t, x)` per section,
the reconstructed cubic equals `F` of the linear combination.

Seed `0xE56A0D17` (not the director's). Two independent sections at the
free rungs. Sample of 2200 points.

| `m` | `dim Sym³` | rank 331 | rank 661 | director |
|----:|----------:|---------:|---------:|---|
| 6 | 56 | 56 | 56 | full |
| 8 | 120 | 120 | 120 | full |
| 10 | 220 | 220 | 220 | full |
| 18 | 1140 | 1140, 1140 | 1140, 1140 | full |
| 19 | 1330 | 1330, 1330 | 1330, 1330 | full |
| 20 | 1540 | 1380 | 1380 | 1380 |
| 22 | 2024 | 1380 | 1380 | 1380 |

Global sampled `P3 = 1380` at both primes. Every section had rank `m`.
Form-check `8/8` throughout.

Record note, not a refutation: the director JSON on disk contains only
the last run (`m = 19`). The README table was not stored. The table
recomputes.

Sampling `x` only *lowers* the observed cubic rank. Full rank is
decisive. Rank `1380` at `m ≥ 20` is a lower bound matching the global
span, hence the restriction map is injective there.

---

## 3. R3 — free argument: **CORRECTED**

Director chain:

1. at `m = 18` and `m = 19` the restricted cubics span all of `Sym³(L)`;
2. hence every `t_i³` lies in the restricted ideal;
3. hence `V ∩ L = {0}`;
4. hence (cone of dimension `k`, generic `m`-section)
   `dim(V ∩ L) = max(0, k + m − 37)`, so `dim V ≤ 37 − m`
   (`≤ 19` from `m = 18`, `≤ 18` from `m = 19`).

### Steps 1–3, confirmed

Step 1 is R2. Two random sections at each of `m = 18,19`, both primes,
all four full. The sections themselves have rank `m`.

Step 2: the restricted ideal is generated in degree 3. If those
generators span `Sym³(L)`, then `I_3 = Sym³(L)`, so each `t_i³` is in
`I`. Sampling is safe: a spanning *subset* of the landing cubics still
forces `I_3` full.

Step 3: over any field, `t_i³ = 0` implies `t_i = 0`. The ideal is
homogeneous, so the only point of `V ∩ L` is the origin. This is
algebraic (not an `F_p`-point count).

### Step 4 — exact fix

The director invoked the *generic* expected-dimension formula and the
biconditional "`V ∩ L = {0}` iff `k ≤ 37 − m`". They exhibited
specific random `F_p`-linear sections, not a generic complex section.
The biconditional needs genericity. The direction they *use* does not.

**Replacement.** Let `V ⊂ A^{37}` be a cone of affine dimension `k`,
and let `L` be *any* linear `m`-plane through the origin. Projectively:
`PV ⊂ P^{36}` has dimension `k − 1` and `PL` is a `P^{m−1}`. Every
linear subspace of dimension `≥ 36 − (k − 1) = 37 − k` meets `PV`.
So if **any** such `L` satisfies `V ∩ L = {0}`, then
`m − 1 < 37 − k`, i.e. `k ≤ 37 − m`.

Genericity is not a hypothesis of the upper bound. The
cone-through-the-origin setup is the correct one: the sections in the
probe are linear through the origin (the vertex). An affine `m`-plane
*off* the origin could miss a large cone, and that is not what was run.

**Conclusion, after the fix:** `dim V ≤ 18` from `m = 19` (and `≤ 19`
from `m = 18`). The full-rank Macaulay matrix lifts from `F_p` to `Q`
for the integer lift of that section. Identifying the modular cell with
the complex 37-cell is the usual reduction caveat; the bound is stated
as modular-plus-lift of a matrix rank, not a sealed char-0 theorem.

---

## 4. R4 — `m = 20` leading ideal: **CONFIRMED**

**Criterion (correct).** For any monomial order, a homogeneous ideal
`I ⊂ k[t_1,…,t_n]` is zero-dimensional if and only if `in(I)` contains
a pure power of every variable. Homogeneous plus zero-dimensional
implies `V(I) = {0}` over an algebraic closure. Then
`V ∩ L = {0}` and the corrected incidence bound gives `dim V ≤ 17`.

**Director artefact** `cone_m20_lead.out`: grevlex, char 331, 20
variables, 11201 leading monomials. Pure powers
`t1..t10³, t11..t15⁴, t16..t20⁵`. None missing. Exponent multiset
matches the README. 240 generators is a *subset*; `V(subset) ⊇ V`, so
a trivial subset locus still kills `V ∩ L`. Valid, and weaker than a
full-span run.

**Independent re-derivation.** Own `m = 20` section, own cubics, full
restricted span (1380 independent generators, never a subset),
`msolve -g 1 -t 2`:

| prime | gens | homogeneous | nlead | pure powers | time | 0-dim |
|------:|-----:|---|-----:|---|---:|---|
| 331 | 1380 | yes | 1540 | `t1..t19³`, `t20⁴` | 11.0 s | yes |
| 661 | 1380 | yes | 1540 | `t1..t19³`, `t20⁴` | 8.5 s | yes |

The criterion applies. The director's `dim V ≤ 17` stands modularly.
Groebner leading ideals need not lift from `F_p` to `Q`; two primes
agreeing is evidence, not a char-0 proof. The free-argument bound
`≤ 18` is the one with a matrix-rank lift.

---

## 5. R5 — degree of regularity: **CONFIRMED**

Semi-regular model (Bardet–Faugère–Salvy): `d_reg` is the first `d`
with non-positive coefficient in `(1 − t³)^m (1 − t)^{-37}`. This is a
complexity model for a generic sequence of that size, not a measurement
of the landing ideal.

| `m` | `d_reg` (claimed) | recomputed | Macaulay columns |
|----:|---:|---:|---:|
| 55 | 21 | 21 | `C(57,21) ≈ 2.13 × 10¹⁵` |
| 520 | 7 | 7 | `C(43,7) = 32 224 114` |
| 1380 | 5 | 5 | `C(41,5) = 749 398` |

Nearby coefficients at `m = 1380`: `HF(3) = 7759`, `HF(4) = 40330`,
`HF(5) = −220742`. Degree 4 cannot surject (`37 × 1380 = 51060 < 91390`).
Degree 5 is the first degree that can (`1380 × 703 = 970140 > 749398`).

**Practical conclusion, confirmed:** feed the full cubic span. A
55-element subset is unreachable; a 520-element subset is the walled
sealed attempt; 1380 generators have semi-regular `d_reg = 5`. A subset
is valid for emptiness (`V(subset) ⊇ V`) and the wrong cost. This
packet's `m = 20` run used the full span.

---

## 6. Honesty

| tier | content |
|---|---|
| `[T2]` machine, two-prime | R1 ranks and Euler; R2 table; R3 full-span; R4 own leading ideals |
| `[T2]` machine, one-prime artefact | director `cone_m20_lead.out` reparsed |
| `[T1]` exact arithmetic | R5 Hilbert coefficients |
| `[EXT]` | `msolve -g 1 -t 2` only; no gap / gp / sage / magma |

Char-0 scope: a full-rank Macaulay matrix mod `p` is full rank over `Q`
for that integer matrix (R3). An `msolve` leading ideal is a statement
over `F_p` (R4). The 37-cell basis is modular. No exclusion is claimed,
so no ODDZERO adversarial audit is triggered.

## 7. Replay

```text
python3 scripts/produce_r5.py
python3 scripts/produce_r1.py
python3 scripts/produce_r2r3.py
python3 scripts/produce_r4.py    # rebuilds own m=20 .ms and reruns msolve -t 2
python3 verifier.py
python3 verifier.py --live       # Hilbert + lead reparse + one Euler trial
```

Never gap / gp / sage / magma. Threads 2. Heavy `Vseed_*.npy` and
`own_cone_m20_p*.ms` are regenerable and not kept (50 MB hosting limit).
Leading ideals and JSON ledgers are the stored record.

## 8. Not claimed

- emptiness of `V`
- any characteristic-zero Nullstellensatz on the 37-cell
- any exclusion of degree 35 or any other degree
- the unrestricted `m = 37` system
- any dominance / 4×4-minor membership statement (Lane 3)
- that the landing cubics *are* a semi-regular sequence
- any `d ≠ 35` cone bound
- any bound tighter than `dim V ≤ 17` (other packets; not this audit)

## Director adjudication (2026-08-12, at landing)

Replayed clean: ALLGREEN. This packet audits the DIRECTOR's own probes.
R1/R2 CONFIRMED; R3 CORRECTED with the conclusion standing (the free
argument needs no genericity hypothesis — the exact fix is in the
report, and the bound `dim V ≤ 18` is unaffected); R4/R5 as reported.
The director's claims of today therefore survive independent rebuild,
including the degree-of-regularity redirect that reshaped the whole
computation. Accepted.
