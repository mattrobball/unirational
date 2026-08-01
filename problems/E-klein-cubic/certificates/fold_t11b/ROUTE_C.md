# T11.1 Route C — exact localized syzygies for the fold chart

**Exit:** `T11B-UNDECIDED`  
**Headline:** **OPEN**  
**Object:** fold singular locus `Sing(S_G)` — **not** the target branch `B`  
**Chart:** coordinates `(A,u; B,Y,Z)`, generators `(g1,g2,g3)=(P_B,P_Y,P_Z)`  
**Resource:** exploratory ceiling only (peak RSS ≲ 100 MiB); heavy slot **not** used

---

## 1. Criterion recalled

With `Δ = det ∂(P_B,P_Y,P_Z)/∂(B,Y,Z)`, the local-chart equality

```text
(I_sing)_Δ = (P_B, P_Y, P_Z)_Δ
```

on the open where the named fold gates are invertible would prove a horizontal
smooth singular component of relative dimension two, hence (with accepted `S_2`)
that the fold fails `R_1` and is nonnormal (`T11-FOLD-HEIGHT1`).

Route C asks for explicit identities

```text
D^N · f  =  a1 P_B + a2 P_Y + a3 P_Z,    f ∈ {P, P_u, P_A},
```

with `D` a product of `Δ` and **individually named** gates, and `a_i ∈ Q[A,B,Y,Z,u]`,
verified by direct expansion.

---

## 2. What was tried

| Step | Result |
|---|---|
| Build `Δ` mod 101 from Hessian of sealed `P` | 41917 terms, max total deg 31; `Δ(sealed point)=5` |
| N=0 cofactor ansatz scan (eval linear algebra) | inconsistent for `f=P` at total cofactor degrees `d ≤ 8` |
| Search `V(P_B,P_Y,P_Z)` at many integer `(A,u)` over `F_p` | **extraneous Δ-open points with all gates units and `P ≠ 0`** |
| Multi-prime confirmation | bad points at `p ∈ {101,103,89}` |

Macaulay2 parametric / full-ring Gröbner routes (A/B) were **not** retried (out of
scope; already stalled). No msolve char-0 certification was used.

---

## 3. Obstruction (decisive)

### 3.1 Modular witness (p = 101)

At `(A,u)=(2,3)` mod 101, the point

```text
(B,Y,Z) = (76, 12, 65)
```

satisfies

| Quantity | Value mod 101 |
|---|---:|
| `P_B, P_Y, P_Z` | 0, 0, 0 |
| `P, P_u, P_A` | **64, 85, 3** (not all zero) |
| `Δ` | **78 ≠ 0** |
| `ell, C, Q4, P_uu, delta` | 43, 95, 52, 85, 53 |
| `L=A−15, M=B` | 88, 76 |
| `F27, G` | 100, 50 |

So `x` lies on `V(P_B,P_Y,P_Z)`, on the open `{Δ ≠ 0}`, and on the open where every
named gate (including `G` via the sealed F27 circuit) is a unit, yet `P(x) ≠ 0`.

### 3.2 Why this kills Route C for this chart

Suppose there existed `N`, polynomials `a_i`, and a multiplier `D` that is a product of
powers of `Δ` and named gates, with

```text
D^N · P = a1 P_B + a2 P_Y + a3 P_Z
```

in `Q[A,B,Y,Z,u]` (or after reduction in `F_p[...]`). Evaluating at `x` gives
LHS `≠ 0` and RHS `= 0`, contradiction.

The same holds for `P_u` and `P_A` at this witness. Therefore **no** Route C identity
of the required shape exists for **any** `N` and **any** cofactor degrees, for the
sealed chart triple `(P_B,P_Y,P_Z)` with the named gate list.

### 3.3 Multi-prime ledger (Δ-open points of the triple)

| p | sample `(A,u)` | # F_p triple pts | # Δ≠0 | good (full sing) | **bad (P≠0)** |
|---:|---|---:|---:|---:|---:|
| 101 | (63,35) | 103 | 1 | 1 | 0 |
| 101 | (2,3) | 125 | 1 | 0 | **1** |
| 101 | (5,7) | 121 | 3 | 0 | **3** |
| 101 | (100,50) | 93 | 2 | 1 | **1** |
| 103 | (63,35) | 121 | 8 | 4 | **4** |
| 103 | (2,3) | 140 | 5 | 2 | **3** |
| 89 | (2,3) | 94 | 3 | 0 | **3** |
| 89 | (10,10) | 100 | 1 | 0 | **1** |

The sealed fibre `(63,35)` mod 101 is not itself a counterexample (its only Δ-open
F_p-point is the simple singular point). Other fibres and other primes supply the
obstruction. A single obstructing point in affine 5-space is enough to rule out a
global polynomial identity.

### 3.4 Side observation (not a gate)

The factor `H` (target-branch discriminant factor, 37992 terms) vanishes at all
checked **good** singular points and is nonzero at checked **bad** points. Thus `H`
behaves like an extra equation of `Sing`, not like a gate to invert. Inverting `H`
would delete the true singular chart. `H` is **not** used as a Route C multiplier.

---

## 4. Consistency table (ansatz scan)

Evaluation linear algebra mod 101 for `N = 0` (identity `P = Σ a_i g_i` with
`deg a_i ≤ d`):

| N | d | f | status | rank A | rank aug |
|---:|---:|---|---|---:|---:|
| 0 | 0 | P | inconsistent | 3 | 4 |
| 0 | 4 | P | inconsistent | 378 | 379 |
| 0 | 8 | P | inconsistent | 3861 | 3862 |

For `N ≥ 1` with `D` among named gates and `Δ`, the modular witness of §3 makes every
`(N,d)` **obstructed** — the linear system cannot become consistent by raising degree.

---

## 5. Floor / next computation

```text
BOTTLENECK-T11B-ROUTEC-EXTRANEOUS-CHART-COMPONENTS
```

On the open where `Δ` and the named fold gates are units, `V(P_B,P_Y,P_Z)` properly
contains `Sing(S_G)`. Route C cannot separate the extraneous components with the
allowed multipliers.

Named next steps (out of this dispatch’s fence, for a later worker):

1. Route A/B style finite `Q(A,u)`-algebra for the **full** gate-saturated `I_sing`
   (degree-6 evidence from specialized exact fibres), or
2. a different chart triple / coordinate pair whose Δ-open zero locus matches Sing,
3. not a pure cofactor hunt for `(P_B,P_Y,P_Z)` with only named-gate/`Δ` multipliers.

---

## 6. Theorem boundary

- **Fold `S_G`:** still undecided for normality / height-one singular component.
  This packet does **not** prove `T11-FOLD-HEIGHT1` and does **not** claim
  `T11-PAIR-EMPTY`.
- **Target branch `B`:** separately sealed nonnormal (`T-BRANCH-NONNORMAL`);
  ordinary binodal node has no 3-primary local Picard defect (`T10-BINODAL-NO-3-DEFECT`).
  No statement here concerns `B`.
- Specialized exact degree-6 fibres of `I_sing` at integer `(A,u)` (sealed in
  `certificates/fold_t11/`) remain discovery for a horizontal component, not a
  generic-function-field theorem.

---

## 7. Artifacts

| Path | Role |
|---|---|
| `exit_t11b.json` | machine exit + obstruction ledger |
| `produce_routeC.py` | producer (this scan) |
| `verify_routeC.py` | independent verifier (no producer import) |
| `verify_routeC_result.json` | verifier output |
| `tmp/t11b_routeC/` | scratch (Delta TSV, fibre dumps) |

**Peak RSS (producer):** ~637 MiB (N=0 degree-8 linear algebra; obstruction scan alone ≲ 100 MiB)  

**Intended commit split (path-scoped, no git run by this worker):**

1. `certificates/fold_t11b/` — Route C undecided packet + verifier  
2. `tmp/t11b_routeC/` — scratch only if policy retains tmp; else omit  

---

## 8. Exit

```text
T11B-UNDECIDED
```

**Headline:** **OPEN**
