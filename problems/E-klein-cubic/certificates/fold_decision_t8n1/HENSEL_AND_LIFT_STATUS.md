# Hensel lifts and characteristic-zero status

**Request:** T8-N1 step 3.  
**Exit contribution:** this stage is the unresolved floor for `T8-N1-UNDECIDED`.

---

## 1. p-adic Hensel lifts (sealed modularly)

Linear Hensel on the deflated system, inverting `J_4` only mod `p` (field),
lifting `p^k → p^{k+1}`. Residual `E ≡ 0 mod p^k` verified at each step.

| Witness | `p` | lift | `E = 0` at final mod? |
|---|---:|---|---|
| L4 | 101 | to `p^40` (267 bits) | yes |
| L4 | 199 | to `p^10` | yes |
| L2 | 89 | to `p^10` | yes |

Artifacts: `tmp/t8n1_work/hensel_results.json`,
`tmp/t8n1_work/hensel_L4_p101_high.json`.

Producer: `tmp/t8n1_work/hensel_lift.py` (does not import T8 producer).

---

## 2. G ≠ 0 along lines (modular, director method)

At the witnesses `H = 0`, so pointwise `G = Res/H` is `0/0`. Interpolating
`Res` along a line is invalid when `deg Res = 106` exceeds the field size
(`p ∈ {89,101}`). Instead: restrict `P` to a line through the point, form
`Res_u` and `H` as univariate polynomials in the line parameter by sampling
with `p > deg G ≤ 63`, take the quotient `G|line`, evaluate at the point.

Consistent values (several directions):

| Witness | `G(point) mod p` | `v_τ(H|line)` |
|---|---:|---:|
| L4/`p`=101 | **16** | 2–3 |
| L4/`p`=199 | **104** | 2 |
| L2/`p`=89 | **6** | 2 |

All nonzero. Multiplicity of `H` along generic lines is ≥ 2, consistent with
`∇H = 0`.

---

## 3. Characteristic-zero obstruction (measured floor)

### 3.1 Rational reconstruction false positives

Wang-style RR with final congruence check (`common_t8n1.rational_reconstruction`,
same algorithm as `common_p25x.py:226`) produces rational candidates for
coordinates of the `p^10` and `p^40` lifts that pass the modular congruence
but **fail exact substitution** into `P` / `P_u` over `Q`. Example: L4/`p`=101
at `p^10` gave four rational coordinates with correct reductions, yet
`P(u_i) ≠ 0` as rational numbers. These are lattice artifacts, not the point.

### 3.2 `algdep` unstable through degree 24

PARI `algdep` on the `p^40` lift of `s` (L4/`p`=101) yields polynomials whose
coefficients **do not stabilize** as degree increases (heights drop, leading
terms keep changing through deg 24). No squarefree minpoly of modest degree
is certified.

### 3.3 Plane-section RUR degree

`msolve` on the saturated deflated system over `F_101`:

| System | degree of ideal | sqfr elim deg |
|---|---:|---:|
| deflated + `(u1−u2)w−1` + `ell·w'−1` | 2678 | 1418 |
| same + `H|_L4 = 0` | **2054** | **1262** |

(The first system includes the `G = 0` locus; adding `H = 0` removes some but
not most of the degree — most points of the 0-dim scheme are non-rational over
`F_p` and were invisible to the affine grid scan.)

A generic line through the L4/`p`=101 witness cuts the `H`-binodal scheme in
degree **2** (the two orderings `u1 ↔ u2` of the same base point). That is
consistent with an isolated plane-section point, but does not give the
extension degree over `Q`.

### 3.4 Floor

```text
CHAR0-FLOOR: full plane-section RUR has degree ~2000 over F_p;
single-point minpoly not isolated below deg 24 at 267 bits of p-adic data;
multi-prime CRT of a degree-O(10^3) RUR is outside the sealed budget of this
request (memory-heavy slot used for the modular audit + high Hensel + msolve
probes). Next step: component isolation (local factor of the eliminant at the
Hensel root across many primes) or a Noether-normalized chart of smaller
degree.
```

---

## 4. Required NONUNIT checklist (status)

| # | Requirement | Status |
|---:|---|---|
| 1 | squarefree minpoly of the algebraic point | **missing** |
| 2 | exact `s,t,u1,u2` | **missing** (p-adic only) |
| 3 | exact `P = P_u = H = 0` | **missing** over `Q` |
| 4 | `u1 − u2 ≠ 0` exactly | modular yes; exact missing |
| 5 | all gates nonzero exactly | modular yes; exact missing |
| 6 | `G ≠ 0` exactly (line/Bareiss) | modular yes; exact missing |

Hence **no** `T8-S1-NONUNIT` exit from this packet.

---

## 5. What this proves / does not prove

**Proves:**
- unique `p`-adic lifts of all three witnesses through the deflated system;
- modular `G ≠ 0` at the witnesses via line restriction.

**Does not prove:**
- an exact algebraic point over `Q` or a number field;
- `T8-S1-NONUNIT`.
