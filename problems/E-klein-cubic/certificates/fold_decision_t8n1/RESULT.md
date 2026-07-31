# T8-N1 result — binodal witness audit and lift

**Exit:** `T8-N1-UNDECIDED`  
**Headline:** **OPEN**  
**Smallest unresolved stage:** step 3 (characteristic-zero algebraic point).

---

## Exit marker

```text
T8-N1-UNDECIDED
```

Not `T8-S1-NONUNIT`: the exact algebraic point (squarefree minpoly, exact
coordinates, exact gate/`G` nonvanishing) was not sealed. Modular discovery
and deflated Hensel are in place; char-0 reconstruction is the floor.

---

## 1. Jacobian correction (step 1) — sealed

| Claim | Result |
|---|---|
| `∇H` at three gate-passing witnesses | **`(0,0,0,0)`** all three |
| `∇H` at L2/`p`=101 control | `(21,95,74,42) ≠ 0` |
| Jacobian code in T8 packet | **none** (`rg` empty on produce/sres/verify) |
| Origin of 96 and 29 | **`Puu=96`** (L4/199, `u=35`) and **`C=29`** (L2/101 non-witness) in discovery JSON — not determinants |
| Correction | `JACOBIAN_CORRECTION.md` (T8 packet untouched) |

Director findings A–C all survived independent recomputation.

---

## 2. Deflated system (step 2) — sealed modularly

Director branch dets, `P_uu`, `det J_4`, and `dh_i` all reproduced:

| Witness | branch | `P_uu` | `det J_4` | rank `{dh1,dh2}` |
|---|---:|---|---:|---:|
| L4/101 | 14 | 48, 35 | 88 | 2 |
| L4/199 | 155 | 96, 20 | 95 | 2 |
| L2/89 | 40 | 87, 22 | 20 | 2 |

Deflated Hensel hypothesis holds at all three witnesses. No director item failed.

---

## 3. Lift to char 0 (step 3) — **UNDECIDED** (floor)

- Hensel lifts to `p^10` (all three) and `p^40` (L4/101) with residual zero.
- Rational reconstruction yields congruence-valid false positives that fail
  exact `P`-substitution.
- `algdep` unstable through degree 24 at 267 bits.
- `msolve` plane-section RUR degree ~**2000** (with `H=0` and `u1≠u2` saturation).
- Modular `G ≠ 0` via line method: 16, 104, 6 at the three witnesses.

**Floor:** isolate the local factor of the degree-~2000 eliminant at the Hensel
root across many primes, or find a lower-degree chart; full CRT of that RUR is
outside this request's sealed budget.

---

## 4. Normal crossing (step 4) — modular only

`dh_i = ∇_x P(x,u_i)` independent (rank 2) at all three witnesses over `F_p`.
Completed local ring certificate over `Q` blocked on step 3.

---

## 5. Nonunit continuation (step 5) — **UNDECIDED** (dimension floor)

Plane-section point counts show nonemptiness only. No exact component, Noether
normalization, or saturated projective dimension certificate for the binodal
locus. `dim Sing(S_G) = 2` and `T2R-NONNORMAL` remain suspended
(`REPAIR.md` §1, §6). Conductors `c_{B⊂S}` and `c_{S⊂S~}` kept distinct.

---

## Theorem boundary

| Proved in this packet | Not proved |
|---|---|
| T8 line-100 Jacobian claim is false and uncomputed | `T8-S1-NONUNIT` |
| `∇H = 0` at the three witnesses; control `∇H ≠ 0` | exact algebraic binodal point over `Q` |
| Deflated `J_4` nonsingular; Hensel applies to deflation | dim of binodal locus |
| Modular transverse branches (`rank dh = 2`) | `R_1` failure / `T2R-NONNORMAL` |
| Modular `G ≠ 0` at witnesses via line restriction | headline unirationality |

**Proving `s_1` nonunit would only simplify Track T** (work order §1.3) — not a
headline exit.

---

## Headline

**OPEN**
