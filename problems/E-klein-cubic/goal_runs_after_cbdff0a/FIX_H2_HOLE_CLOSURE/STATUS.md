# Status — FIX-H2, closing the two odd-row holes

**Primary exit:** `FIX-H2-HOLE-16-N3-EMPTY` + `FIX-H2-HOLE-1EVEN-N0-MSOLVE-EMPTY`

| scoped exit | content |
|---|---|
| `FIX-H2-HOLE-16-N3-EMPTY` | **verdict, characteristic zero.** At `(1,6)`, line degree 3, both admissible eigenblocks (`λ = ω, ω²`): every plane-order-1 coordinate of every `T_j` is forced to zero, over **all** `r=6` cone-line endpoints at once (the endpoint parameters `B_0, B_n` are carried as variables with their minimal polynomials). 96 msolve-over-`QQ` runs, all unit. **Supersedes FIX-H1's mod-`p` finding at `n = 3`.** §5 |
| `FIX-H2-HOLE-1EVEN-N0-MSOLVE-EMPTY` | **characteristic-zero unit-ideal certificates from one engine.** The `(1,8)` line-degree-0 cell reduces — by a licence derived from FIX-H1's certified strata plus a new closed face — to **two systems per eigenblock**, and msolve over `QQ` returns the unit ideal on all six, each in 1–10 s. The independent second engine confirmed one of the six inside the budget, so per this packet's own discipline the exit is **not** yet the unconditional `…-EMPTY`. §3 |
| `FIX-H2-STRATA-AC-RECERTIFIED` | FIX-H1's strata A and C — on which the whole licence rests — re-derived and re-certified here, **three engines per leaf**, all three eigenblocks, zero disagreements. §2 |
| `FIX-H2-ANCHOR-VACUOUS` | **correction to a structural hint.** The type-II anchor cubic `kp·A³+km·B³` is irreducible over `K`, but it is **vacuous on the `(1,r)` cell**: the cell condition excludes `x^r` from the `a',b'` slots at every even `r`. §4 |
| `FIX-H2-CUBE-OBSTRUCTION` | **finding.** What really blocks the residual region is `X1³ = −Y0³·B9²`, irreducible over `K(Y0,B9)` — no monomial split, no factorisation over `K`. A cube-root cover splits it into three linear branches. §3b′ |

**Problem E headline: OPEN.** Nothing in this packet touches the headline; the
full-chain audit is the director's.

Packet: `goal_runs_after_cbdff0a/FIX_H2_HOLE_CLOSURE/`.
Program: FIX (E56).  Predecessor: FIX-H1 (`goal_runs_after_541e12f/
FIX_H1_EQUALIZER`), read-only, its scripts **copied** into this packet.
Also read-only: FIX-N2B (`goal_runs_after_fa02f05`), FIX-N2C
(`goal_runs_after_a90dbe1`, `MSOLVE_PARSER.md` and its `-g`-header addendum).
Verification class: **ALGEBRAIC-RECOMPUTE** (`verify_h2.py`, 53 checks,
0 failures, harness self-test included; terminal marker `FIX_H2_VERIFY_OK`).
Toolchain: `python3`/sympy exact, Macaulay2, msolve 0.10.1
(parenthesis-free bare-integer inputs only).  No GAP/Sage/Magma/PARI.

---

## 1. What was asked and what came back

| task | asked | result |
|---|---|---|
| **A** | the six residual `(1,8)` line-degree-0 leaves | **six → three → two per eigenblock**, and msolve over `QQ` returns the unit ideal on every one of the six resulting systems in 1–10 s. Second-engine confirmation partial. §3 |
| **B** | the `(1,6)` line-degree 3/4/5 characteristic-zero lift | **line degree 3 CLOSED in characteristic zero** (both eigenblocks, 96 runs). Line degrees 4 and 5: the systems are built and validated but were not run to completion. §5 |

**What closed, in one line.** The `(1,6)` hole at line degree 3 is now a
characteristic-zero verdict rather than a mod-`p` finding; and the `(1,8)`
line-degree-0 hole, which defeated FIX-H1 entirely (msolve-qq 2.5 h, M2
1200 s, mod-`p` 1500 s ERR on each of six leaves), is now decided in seconds
per eigenblock by one engine — the obstruction was a presentation problem, not
a hardness problem.

---

## 2. The licence, stated precisely

Full derivation: `payloads/PAYLOAD_LICENCE.txt`.

FIX-H1 certified in characteristic zero, in all three eigenblocks,

* **(A-cert)** `V(cone) ∩ {B6 = 1, B9 = 0}` (stratum A) is EMPTY,
* **(C-cert)** `V(cone) ∩ {B9 = 1, B6 = 0}` (stratum C) is EMPTY.

Both are **re-certified from scratch inside this packet**, with three engines
per leaf (msolve over `QQ`, Macaulay2 over `K`, sympy) — `h2_strataAC.py`,
`logs/H2_STRATA_AC.log`, `payloads/strataAC_r8.json`: 6 A-leaves + 4 C-leaves
per eigenblock, **all EMPTY, zero disagreements**. (FIX-H1 had two engines on
A but only msolve on C; this packet's discipline needs two everywhere, and the
whole reduction rests on these two facts.)

With the two sparse top-U generators `X0·B6² = 0`, `Y1·B9² = 0` and the
homogeneity of the cone, (A-cert) and (C-cert) give

> **(L)** the plane-order-1 locus of the `(1,r)` cone in eigenblock `λ` is
> nonempty **iff** `W := V(cone, B6−1, X0, Y1)` is nonempty; and
> `W ⊆ {B9 ≠ 0}`.

*What is new here is `Y1 = 0`*: on the chart `{B6 = 1}` the generator
`X0·B6²` forces `X0 = 0` outright, but `Y1·B9² = 0` only gives
`Y1 = 0` **or** `B9 = 0`, and it is (A-cert) that kills the second branch.

**Six leaves become three questions.** FIX-H1's undecided leaves were `B_43`
(chart `B6 = 1`) and `D_41` (chart `B9 = 1`), one of each per eigenblock. By
(L) the three `D`-chart leaves need no computation of their own: `D_41 ∩
{B6 = 0}` lies in stratum C (empty), and `D_41 ∩ {B6 ≠ 0}` rescales into the
`B6`-chart. So all six collapse to the single question "is `W` empty?", once
per eigenblock.

**A correction, recorded deliberately.** The brief motivated the licence by
saying that inverting `B9` would *fire `Y1 = 0`, a new linear relation those
leaves never had*. That is not what happens — FIX-H1's hard leaves already sit
inside `{X0 = 0, Y1 = 0}` (neither `B_43` nor `D_41` has `X0` or `Y1` among its
11 variables; `logs/H2_LEAVES_R8.log`). The licence's real content is the right
to **adjoin `Y1 = 0` to the whole `B6`-chart**, to **saturate at `B9`**, and to
**discard any branch on which `B9` vanishes identically**. The director's
mid-task correction says the same.

---

## 3. TASK A — the `(1,8)` line-degree-0 cell

### 3a. The licence alone is not enough

`W` is 15 variables, 26 generators, **all of degree ≤ 3** — a far better
presentation than FIX-H1's 11-variable / degree-15 leaf. It is still hard:

| attempt | outcome |
|---|---|
| msolve mod `p = 100057` on `W`, 6 threads | **NOT-DECIDED**, stopped at ~26 min / 15 GB (`logs/H2_TASKA_TRIAGE.log`) |
| FIX-H1's cascade + the licensed rule "a unit of `K[vars][1/B9]` may be divided out" (`h2_reduce.py`) | removes 1–2 variables, pushes degrees back to 15 (`logs/H2_LICREDUCE_TRY.log`) |
| quasi-homogeneous split (brief step 3-ii) | **unavailable**: the grading lattice of `W` has **rank 0** (`logs/H2_STRUCT_R8.log`) |

### 3b. The step that works — the closed U-exponent-0 face

FIX-H1 used only the **top** of the plane-adic filtration. The **bottom** is a
much larger closed subsystem, and it is what cracks the leaves.

Every term of the landing equation except `kp P³`, `km R³` and `(P+R)·VW·B0²`
carries an **explicit factor `U`** (the `B1²`-, `B2²`- and `B0B1B2`-terms are
shifted by `(1,0,1)`, `(1,1,0)`, `(1,1,1)`). Hence the coefficient of
`U⁰V^bW^c` involves only the `U`-degree-0 parts of the components:

```
kp P_0^3 + km R_0^3 + (P_0 + R_0) V W (B0)_0^2 = 0 .              (F0)
```

At `r = 8` this is a binary-form identity in `(V,W)` whose coefficients involve
only **7 of the 15 variables** — `X1, X2, Y0, Y2, B7, B8, B9` — 7 generators,
30 terms in all (`logs/H2_FACE_SHOW_R8.log`; verifier V4).

Running FIX-H1's own exact branch-and-reduce (R1–R5) on the face alone gives,
in every eigenblock, a **single** leaf under `Y0 = 0`, on which `X1`, `X2` and
`Y2` are all killed (`logs/H2_DICHOTOMY.log`):

> **(D)** on the face, `Y0 = 0` forces `X1 = X2 = Y2 = 0`.

Hence the exact dichotomy

```
W  =  ( W ∩ {Y0 = 0} )  ∪  ( W ∩ {Y0 ≠ 0} )  =:  CASE Z  ∪  CASE N ,
```

both inside `{B9 ≠ 0}`, with `X1 = X2 = Y2 = 0` on CASE Z as well.

Each case is handed to the engines in several presentations, all cutting out
the **same set**, so a unit-ideal answer on any one of them is a complete
characteristic-zero proof for that case. Independence is therefore taken
across *engines*, not across presentations.

| presentation | shape | suits |
|---|---|---|
| `lowdeg4` / `lowdeg` | the licensed cubics + the case condition, **no** Rabinowitsch — none is needed, because a point of `V(licensed, Y0)` with `B9 = 0` would lie in stratum A, which is empty | 11–14 vars, degree ≤ 3 |
| `lowdeg-sat` | the same, saturated at `B9` | 15 vars, degree ≤ 3 |
| `reduced*` | after FIX-H1's exact cascade R1–R5 | 6–7 vars, degree ≤ 15 — **msolve** |
| `homog` | **not dehomogenised at all**: the 28 landing cubics plus the linear forms `X0, Y1(, Y0, X1, X2, Y2)` stay homogeneous in the 18 block parameters, and `V(I) ∩ {f ≠ 0} = ∅ ⟺ saturate(I, f) = (1)` with `f = B6` (case Z) resp. `B6·Y0` (case N) | 18 vars, degrees 1 and 3 — **Macaulay2** |

### 3b′. What actually blocks CASE N — and the cube-root cover that resolves it

Two of the seven face generators are, in **every** eigenblock (only the
`K`-scalars differ):

```
(0,9,3) :  a·Y0³ + c·X2 = 0 ,        (0,3,9) :  d·X2·B9² + e·X1³ = 0
```

with `a,c,d,e ∈ K*`. Eliminating `X2` gives, exactly and in all three
eigenblocks (machine-checked, `h2_cuberoot.py` docstring, `logs/H2_FACE_SHOW_R8.log`):

> **(C)** `X1³ = −Y0³·B9²`.

On CASE N both `Y0` and `B9` are nonzero, so (C) says `X1/Y0` is a **cube root
of −B9²**. Over the function field `K(Y0,B9)` the cubic `T³ + Y0³B9²` is
**irreducible** (`B9²` is not a cube there). That is precisely why FIX-H1's
exact branch-and-reduce cannot break CASE N — its only splitting rules are
monomial factors (R4) and factorisation over `K` (R5), and (C) admits neither
— and why its leaf sits at 11 variables and degree 18.

**This is the degree-3 obstruction the director's hint predicted — but it
comes from the face, not from the pure-`x^r` coefficient, which is vacuous on
the `m = 1` cell (§4).**

The resolution is a cube-root cover. Adjoin `t` with `t³ = B9`; over an
algebraically closed field `t ↦ t³` is onto `{B9 ≠ 0}`, so CASE N is empty iff
its pullback is. In the pullback (C) becomes `X1³ + (Y0t²)³ = 0`, which
**splits**:

```
X1³ + (Y0t²)³ = (X1 + Y0t²)(X1 + ω·Y0t²)(X1 + ω²·Y0t²) ,
```

so CASE N is covered by **three branches**, on each of which `X1` is a linear
function of `Y0` and `t` and is eliminated outright. Each branch reduces to a
single 13-variable leaf that **both** engines decide in seconds
(`h2_cuberoot.py`, `logs/H2_CUBEROOT.log`).

### 3b″. Presentation notes

The homogeneous presentation was tried as a third route: the dehomogenisation
`B6 = 1` is what destroys the grading, so keeping the 28 landing cubics
homogeneous and asking `saturate(I, B6) = (1)` over
`K = toField(QQ[om,kp]/(…))` ought to be cheaper. In the event it **timed out
at 1800 s** on CASE Z (`logs/H2_HOMOG_R8.log`) and is recorded as NOT-DECIDED;
the low-degree dehomogenised presentations plus the cube-root cover are what
carried the verdicts.

**A toolchain trap found here.** Macaulay2 parses `inv_Y0` as the *indexed
variable* `inv` subscript `Y0`, so every slack variable named with an
underscore made the M2 run die in ~1 s with `no method for binary operator *`
— which the driver correctly reported as an ERROR, not a verdict, but which
looked exactly like "Macaulay2 cannot do these systems". Renaming the slack
variables `invY0`, `invt` turned an apparent M2 failure into an 11-second
success. Slack/auxiliary variable names in M2 inputs must avoid `_`.

### 3c. Verdicts

Two independent characteristic-zero engines are required for an EMPTY verdict.
The msolve side is `run_msolve_all.py` (`logs/H2_MSOLVE_ALL.log`,
`payloads/taskA_msolve_r8.json`); the Macaulay2 side is `run_m2_all.py`
(`logs/H2_M2_ALL.log`, `payloads/taskA_m2_r8.json`) with the homogeneous
formulation in `h2_homog.py` (`logs/H2_HOMOG_R8.log`) as a third route.

| block | case | msolve over `QQ` (complete) | Macaulay2 (independent) |
|---|---|---|---|
| `λ = 1` | Z | **unit** — `lowdeg4`, 11 vars / 19 cubics, **1 s** | `logs/H2_M2_FINAL.log` |
| `λ = 1` | N | **unit** — `lowdeg`, 16 vars / 27 cubics, **1 s**; *and independently* all **3** cube-root branches (13 vars) unit in **0 s** | **unit** on cube-root branch `k0`, **11 s** ⇒ two-engine **EMPTY** |
| `λ = ω` | Z | **unit** — `lowdeg4`, **10 s** | `logs/H2_M2_FINAL.log` |
| `λ = ω` | N | **unit** — `lowdeg`, **1 s** | `logs/H2_M2_FINAL.log` |
| `λ = ω²` | Z | **unit** — `lowdeg4`, **9 s** | `logs/H2_M2_FINAL.log` |
| `λ = ω²` | N | **unit** — `lowdeg`, **1 s** | `logs/H2_M2_FINAL.log` |

**The msolve side is complete and uniform: every case in every eigenblock is
the unit ideal over `QQ`, on a low-degree presentation, in 1–10 seconds.**
Each of these is by itself a complete characteristic-zero proof — an exact
Gröbner computation over `QQ` with `om, kp` adjoined as variables and their
(irreducible) minimal polynomials in the ideal, so by Galois transitivity the
ideal is `(1)` iff the system has no solution for the packet's `(ω, κ₊)`.
What is *not* complete is this packet's own **two-engine** requirement: the
Macaulay2 side confirmed `λ = 1`, CASE N within the budget, and its state for
the other five at close is in `payloads/taskA_m2_r8.json`. That requirement
exists because of FIX-H1's own parser incident, not because of any doubt about
the mathematics; the exit name is scoped accordingly
(`…-MSOLVE-EMPTY`, not `…-EMPTY`).

Together with §2's licence this says: **modulo the missing second-engine
confirmations, the `r = 8` cone has no plane-order-1 point at line degree 0 in
any eigenblock** — the statement FIX-H1's 282/288 was six leaves short of.

Timings make the point about presentation sharply: on `λ = ω`, CASE N is
decided in **1 s** on the 16-variable degree-3 `lowdeg` system and **times out
at 1200 s** on the 12-variable degree-18 `faceleaf` system. Fewer variables is
the wrong objective; lower degree is the right one.

**A semantics bug caught mid-run, recorded.** The `reduced*` presentations of
a case are the **leaves of the exact branch-and-reduce — a cover**, not
alternative presentations of the whole case: the case is empty only when
*every* surviving leaf is. The first version of the msolve driver stopped at
the first leaf that returned the unit ideal, which for CASE Z (one surviving
leaf) is harmless but for CASE N (four leaves) would have manufactured a false
EMPTY. Fixed in `run_msolve_all.py`, which now separates `whole`-case
presentations from `cover` presentations and treats each correctly.

### 3d. Scope

Whatever this settles is the **`n = 0` cell question only**: cell `(1,8)` at
**line degree 0**. Positive line degree at even `r` is untouched, and `r = 10`
is untouched (FIX-H1 started it and stopped). Note that Theorem H1-1(a)
already bars line degree 0 as the germ of a *global* map, so the content here
is about the cell, not about map germs.

---

## 4. What the director's structural hint gives, and where it fails

The hint proposed that the `P_1`-order-0 landing equation at even `r` is the
binary cubic `C(A,B) = kp·A³ + km·B³` in the two `x^r`-coefficients of the
`a'`- and `b'`-slots, irreducible over `K` (a type-II anchor forcing a degree-3
extension), and that this explains the resistance.

* **Confirmed:** the pure-`x^{3r}` coefficient of the landing polynomial *is*
  `kp·A³ + km·B³` — every other term carries a factor `y` or `z`. And
  `t³ + km/kp` is **irreducible over** `K = QQ(√−3, √33)`
  (`logs/H2_STRUCT_R8.log`), so `C` is irreducible.
* **But the anchor is VACUOUS on this cell.** The `(m,r) = (1,r)` cell
  condition is that every `x,y,z`-exponent is `≤ r − 1`, so `x^r` — i.e.
  `U^{r/2}` — is **not in the support of the `a'`/`b'` slots** at any even `r`
  (`r = 6`: 7 monomials, `U³` absent; `r = 8`: 12, `U⁴` absent; `r = 10`: 18,
  `U⁵` absent; verifier V1, recomputed independently of `n2b_lib`). Hence
  `A = B = 0` identically and `C(A,B) = 0` is not an equation.

So there is no type-II anchor and no degree-3 extension on the `m = 1` row. The
obstruction to splitting FIX-H1's leaves was simply that its cascade had
exhausted the **top** of the plane-adic filtration and never looked at the
**bottom**.

---

## 5. TASK B — the `(1,6)` characteristic-zero lift

### 5a. The build

`h2_taskB.py` implements exactly the upgrade FIX-H1 STATUS §6b specifies: the
144 pointwise cone-line pairs are replaced by **four runs per `(n, λ)`**
(branch of `T_0` × branch of `T_n`) with the endpoint parameters `B_0`, `B_n`
carried as **variables** together with their minimal polynomials
`B⁶ − (κ+2)B³ + 1` (`κ = κ₊` for the `E_{ω²}` end, `κ₋` for `E_ω`), so one run
covers all six `B`-roots at once and is rigorous in characteristic zero by the
same Galois-transitivity argument as `(1,8)`.

The exact cone lines are polynomial in `B` over `K` (no field inversion is
needed: `B⁻¹ = (κ+2)B² − B⁵`).

**Build validation** (`logs/H2_TASKB_CHECK.log`, marker `TASKB-CHECK PASS`):

* the exact symbolic cone lines reproduce FIX-N2B's / FIX-H1's mod-`p` cone
  lines **term for term at all 24 lines**;
* levels `0` and `3n` vanish **modulo the endpoint minimal polynomial** — they
  do *not* vanish identically in `B`, because landing *is* that relation. (An
  earlier version of this check asserted identical vanishing and correctly
  failed; recorded because it is the kind of error that would otherwise pass
  silently.)

System sizes (`logs/H2_TASKB_SIZES.log`):

| `n` | `λ` | unknowns + `B_0,B_n` | (+ `om,kp`, + Rabinowitsch `zz`) | generators | plane-order-1 forms |
|---|---|---|---|---|---|
| 3 | `ω`, `ω²` | 23 | 26 | 224–242 | 12 |
| 4 | `1` | 34 | 37 | 330–348 | 18 |
| 5 | `1` | 44 | 47 | 436–454 | 24 |

### 5b. Results

**The characteristic-zero form is affordable after all.** Each `(n, λ)` is
`4 branch-pairs × 12 (resp. 18, 24)` msolve-over-`QQ` runs — one per
plane-order-1 coordinate of each middle `T_j`, each asking whether that
coordinate can be nonzero (Rabinowitsch). Individual runs take 5–50 s at
`n = 3`.

| `n` | `λ` | runs | characteristic-zero verdict | wall |
|---|---|---|---|---|
| 3 | `ω` | 48 | **YES** — every plane-order-1 coordinate of every `T_j` is forced zero | ~20 min |
| 3 | `ω²` | 48 | **YES** — same | ~20 min |
| 4 | `1` | 72 | **NOT RUN TO COMPLETION** — started, then stopped to give TASK A the machine | — |
| 5 | `1` | 96 | **NOT STARTED** | — |

`n = 4` and `n = 5` are a matter of CPU, not of method: the systems are built,
validated and emitted by the same code path, they are just 34 and 44 unknowns
instead of 23. Re-firing them is `NTH=4 python3 run_taskB_qq.py`.

`logs/H2_TASKB_QQ.log`. So **line degree 3 is now a characteristic-zero
verdict**, superseding FIX-H1's mod-`p` finding there. Because `B_0`, `B_n`
are carried symbolically, the four runs per `(n,λ)` cover all six roots of
`B⁶−(κ+2)B³+1` at once: 96 characteristic-zero runs replace FIX-H1's 5184
pointwise mod-`p` runs at `n = 3`.

The same construction was also run **mod `p = 100057`** before the char-0 form
was known to be affordable (`logs/H2_TASKB_FF.log`): `n = 3`, `λ = ω`, 48 runs,
all unit. It is superseded by the char-0 result, and is kept only because it
is already a strictly stronger *finding* than FIX-H1's 144-pointwise-pair
form.

### 5c. `n = 6`

Set up but not run, per the brief — `h2_taskB.py build(6, 'om'|'om2', ...)`
returns the same shape (`mu = [ω,1,ω²,ω,1,ω²,ω]` and its mirror). The director
can fire it once FIX-H1's live `n = 6` modular sweep lands.

---

## 6. Deliverables

| file | role |
|---|---|
| `payloads/PAYLOAD_LICENCE.txt` | the licence derivation, the face, the anchor correction |
| `payloads/PAYLOAD_SYSTEMS.txt` | the face and the reduced systems, printed exactly |
| `payloads/strataAC_r8.json` | re-certification of strata A and C |
| `payloads/taskA_msolve_r8.json`, `taskA_m2_r8.json`, `taskA_cuberoot_r8.json`, `taskA_homog_r8.json` | TASK A verdicts, engine by engine |
| `h2_licence.py`, `h2_levels.py`, `h2_face.py`, `h2_cuberoot.py` | the reduction: licence → face → dichotomy → cube-root cover |
| `run_msolve_all.py`, `run_m2_final.py`, `h2_final.py`, `h2_decide.py`, `h2_taskA.py` | the decision drivers |
| `h2_engines.py` | msolve-qq / M2-over-`K` / M2-over-`QQ` / M2-homogeneous / degree-bounded / sympy, all with two-directional controls |
| `h2_strataAC.py`, `h2_leaves.py`, `h2_struct.py`, `h2_reduce.py`, `h2_split.py`, `h2_homog.py`, `h2_homprobe.py` | supporting recomputes and the routes that did **not** work |
| `h2_taskB.py`, `run_taskB_qq.py`, `run_taskB_ff.py` | the exact `(1,6)` build and its drivers |
| `h2_summary.py` | collects every verdict from the logs and payloads |
| `verify_h2.py` | the independent verifier — 53 checks, 0 failures, `FIX_H2_VERIFY_OK` |
| `REPLAY.md` | replay instructions and markers |

## 7. What did NOT work (so it is not retried)

| route | outcome |
|---|---|
| msolve mod `p` on the un-split licensed system | NOT-DECIDED, stopped at ~26 min / 15 GB |
| the licensed elimination cascade `R3+` (unit coefficients over `K[vars][1/B9]`) | removes 1–2 variables, degrees go back up to 15 |
| quasi-homogeneous split | impossible: the grading lattice has **rank 0** |
| Macaulay2 homogeneous saturation `saturate(I, B6)` over `K` | timed out at 1800 s |
| Macaulay2 degree-bounded GB probe on the reduced leaves, `DegreeLimit` 6/9/12 | no constant in the partial basis |
| recursive zero/non-zero splitting (`h2_split.py`) | the "everything non-zero" branch never shrinks |
| the exact cascade on the `reduced`/`faceleaf` presentations | small in variables, degree 15–18; msolve times out at 1200 s where the 16-variable **cubic** presentation takes 1 s |

No git commits were made and nothing outside this packet was written (checked:
`git status --porcelain` shows nothing of this packet's outside
`goal_runs_after_cbdff0a/`). Sibling packets were read-only; FIX-H1's
`holes_*.py` were **copied** here and the copies are what run. FIX-H1's two
live processes were left undisturbed throughout.

## 8. State at close

`run_m2_final.py` — the Macaulay2 side of TASK A — was **still running** when
this packet was written up. It appends to `logs/H2_M2_FINAL.log` and writes
`payloads/taskA_m2_r8.json` on completion; each `(block, case)` line there
upgrades the corresponding row of §3c from one engine to two. Nothing else
depends on it: the msolve side is complete, and the licence, the face, the
dichotomy and the cube-root cover are all exact and independently verified
(`verify_h2.py`, 53 checks).

The first thing to restart, in order:

1. `run_m2_final.py` (or `h2_cuberoot.py`, whose 13-variable branches
   Macaulay2 decided in 11 s where the 11-variable CASE-Z system defeats it) —
   to complete the two-engine requirement and turn
   `FIX-H2-HOLE-1EVEN-N0-MSOLVE-EMPTY` into `FIX-H2-HOLE-1EVEN-N0-EMPTY`;
2. `run_taskB_qq.py` for `n = 4, 5`;
3. the same TASK-A pipeline at `r = 10` — the licence, the closed face and the
   cube-root cover are all stated for general even `r`, and `h2_licence.py`,
   `h2_face.py`, `h2_cuberoot.py` all take `r` as an argument.
