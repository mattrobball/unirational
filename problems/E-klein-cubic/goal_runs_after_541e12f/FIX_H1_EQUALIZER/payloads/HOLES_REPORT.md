# FIX-H1 secondary task — the two remaining `m = 1` holes

Packet dir: `goal_runs_after_541e12f/FIX_H1_EQUALIZER/`.
Frame: `theory/FIX_II_jets.md` §4.  Predecessors:
`goal_runs_after_fa02f05/FIX_N2B_M1_ROW` (conventions, engine, Thm N2B-1),
`goal_runs_after_a90dbe1/FIX_N2C_R7_DECISION` (pipeline, `MSOLVE_PARSER.md`).
All sibling code used **read-only**; nothing outside this packet was touched.

---

## 0. Verdict lines

```
FIX-H1-HOLE-1EVEN-PARTIAL(282/288 leaves char-0 certified EMPTY; the r=8 cone
                          has NO plane-order-1 point with exactly one of the two
                          plane-order-1 coefficients nonzero -- that part is a
                          full char-0 verdict in all three eigenblocks; the
                          remaining region {both nonzero} is one 11-variable
                          leaf per eigenblock per chart, still computing)
FIX-H1-HOLE-16-PARTIAL(line degrees 3,4,5 decided as FINDINGS mod p=100057:
                       every plane-order-1 coefficient forced zero over all 144
                       pairs of r=6 cone lines; line degree 6 OPEN/running)
```

**Neither hole is closed.**  What is new and solid is below; what is missing is
stated exactly.

---

## 1. Setup and the structure that does the work

Conventions are FIX-N2B's verbatim (`STATUS.md` §0).  At **even** `r` the cell
`(1,r)` has the shape

```
a' = P(U,V,W),  b' = R(U,V,W)                      deg r/2,  U=x^2,V=y^2,W=z^2
u_0' = yz B0(U,V,W), u_1' = zx B1, u_2' = xy B2    deg r/2 - 1
```

with landing polynomial

```
kp P^3 + km R^3 + (P+R) VW B0^2 + (om P + om^2 R) WU B1^2
                + (om^2 P + om R) UV B2^2 + UVW B0 B1 B2 = 0 .            (*)
```

**Block dimensions reproduced independently** (`holes_setup_r8.py`):
`(10,11,11)` at `r=6`, `(13,13,13)` at `r=7`, **`(18,18,18)` at `r=8`**,
`(20,21,21)` at `r=9`, `(27,27,27)` at `r=10` — matches FIX-N2B §2.1.

**Plane-order-1 parameters.**  At `r=8` they are exactly `B6` (the `V^3`
coefficient of `B0`, i.e. the `y^7z` coefficient of `u_0'`) and `B9` (`W^3`,
i.e. `yz^7`); at `r=10` they are `B10`, `B14`; at `r=6`, `B3`, `B5` (matching
FIX-N2B).  Every other parameter has plane order `>= 2`.  Verified twice: by
`Block.param_plane_orders` and, independently, by reading `x,y,z` exponents off
the sympy rebuild (`holes_indep.py`).

### 1.1 The plane-adic leading equations (the key structure, new here)

`ord_{P_1}(U^aV^bW^c) = 2(deg - a)`, so the plane-adic filtration of `F(T)` is
the filtration by `U`-degree, and the **top** `U`-degree component of `(*)` is a
quadratic form in `V,W`.  With `L_P = p_v V + p_w W` the top-`U` part of `P`
(and `L_R` of `R`), `b_top = [U^top]B0`, `c1 = [U^top]B1`, `c2 = [U^top]B2`:

```
(om L_P + om^2 L_R) W c1^2 + (om^2 L_P + om L_R) V c2^2 + VW b_top c1 c2 = 0
```

i.e.

```
W^2 :  (om  p_w + om^2 r_w) c1^2 = 0
V^2 :  (om^2 p_v + om  r_v) c2^2 = 0
VW  :  (om p_v + om^2 r_v) c1^2 + (om^2 p_w + om r_w) c2^2 + b_top c1 c2 = 0
```

**and `m = 1` iff `c1 != 0` or `c2 != 0`** — the plane-order-1 coordinates are
exactly those two, via the `C_3`-relations `[U^t]B1 = lam^{-1}[W^t]B0`,
`[U^t]B2 = lam^{-2}[V^t]B0`.

The shape is **uniform in even `r >= 6`** and **uniform in `lam`** (only the
overall `K`-scalar of each equation depends on `lam`).  In the coordinates
`X_i = om^2 P_i + om R_i`, `Y_i = om P_i + om^2 R_i` (an invertible linear
change, `holes_xy.py`, checked against the original system at random points
mod `p`) it is literally two coordinate equations:

```
r = 6 :  X0 * B3^2 = 0 ,  Y1 * B5^2 = 0
r = 8 :  X0 * B6^2 = 0 ,  Y1 * B9^2 = 0
r = 10:  X0 * B10^2 = 0,  Y1 * B14^2 = 0
```

**Confirmed in the RAW system**: `holes_indep.py` rebuilds all 82 coefficient
equations at `r=8` in sympy from the Klein normal form (never touching
`n2b_lib`) and finds among them exactly `(om^2 P0 + om R0)*B6^2` and
`(om P1 + om^2 R1)*B9^2`.

### 1.2 The four strata (an exact decomposition, no saturation)

`m = 1` means `B6 != 0` or `B9 != 0`, and the cone is homogeneous (the landing
equations are homogeneous cubics in the block parameters), so

```
{m=1} = {B6!=0} u {B9!=0}
      SUBSET (A) {B6=1,B9=0} u (B) {B6=1,Y1=0} u (C) {B9=1,B6=0} u (D) {B9=1,X0=0}
```

because on `{B6!=0}` the generator `Y1 B9^2 = 0` forces `B9=0` or `Y1=0`, and
symmetrically on `{B9!=0}`.  Each stratum is an honest ideal — no saturation,
no slack variable.  Sharper:

```
{B6!=0, B9=0}  ⊆ A        {B6=0, B9!=0}  ⊆ C
{B6!=0, B9!=0} ⊆ B  and  ⊆ D   (both X0 = 0 and Y1 = 0 hold there)
```

---

## 2. The exact solver and the engines

`holes_solve.py` / `holes_track.py`.  Every step is a rigorous characteristic-
zero operation on the affine variety over `K = QQ(om,kp)`:

| rule | operation | justification |
|---|---|---|
| R1 | drop duplicate / zero generators | — |
| R2 | a nonzero constant among the generators ⇒ branch EMPTY | — |
| R3 | `c*w + rest`, `c` a nonzero constant of `K` ⇒ `w := -rest/c` | graph of a regular function: variety isomorphism |
| R4 | `g = m*h`, `m` a nonconstant monomial ⇒ branch on `V(v)`, `v | m`, and on `V(h)` | `V(mh) = V(m) u V(h)` |
| R5 | `g` not squarefree ⇒ replace by `rad g`; several distinct factors ⇒ branch | `V(g) = V(rad g) = u V(h_i)` |

R5 uses exact factorisation over `K = QQ(sqrt-3, sqrt33)` (`holes_factor.py`,
sympy `factor_list(..., extension=[sqrt(-3),sqrt(33)])`, with an exact
round-trip assertion on every coefficient).  It is what cracks perfect-cube
generators such as `c*(B2 + Y3*B9)^3` (radical ⇒ the linear relation
`B2 = -Y3 B9`); without it several leaves stay at 9–11 variables and neither
engine terminates.

Leaf verdicts, three independent **characteristic-zero** engines:

* **qq** — msolve over `QQ` with `om, kp` adjoined as variables and their
  minimal polynomials added.  Both minimal polynomials are irreducible over
  `QQ`, so `Gal(Qbar/QQ)` is transitive on their roots: the ideal is `(1)` iff
  the system has no solution for the packet's `(om, kp+)`.  Every input is
  emitted fully expanded with bare integer coefficients and **asserted
  parenthesis-free** (`MSOLVE_PARSER.md`); a zero-byte output is an ERROR,
  never a verdict.
* **m2** — Macaulay2 over `K = toField(QQ[om,kp]/(om^2+om+1, 8kp^2-13kp-4))`,
  `1 % I == 0`.
* **sp** — sympy Gröbner over `QQ[vars,om,kp] +` minimal polynomials.

plus a **three-prime modular cross-check** (`p = 100057, 100153, 1048609`, all
split), which is a FINDING only.

### 2.1 Controls, in both directions (mandatory)

`holes_controls.py`:

```
control NON-EMPTY  (a^2-2, b-a)   : sympy-unit=False  M2-unit=False
control EMPTY      (a, a-1)       : sympy-unit=True   M2-unit=True
control a=om, a^2+a+1             : sympy-unit=False  M2-unit=False
control a=kp, 8a^2-13a-5          : sympy-unit=True   M2-unit=True
CONTROLS PASS
```

**A parser bug found and fixed here.**  msolve's `-g` output begins with a
`#`-comment header, so a naive `startswith('[1]')` test reports *every* run as
non-unit.  That bug was live for one round in this packet and produced a
spurious "the `r=8` cone HAS plane-order-1 points" reading.  It is now
`body in ('1','-1')` after stripping the header (matched to FIX-N2B's own
parser) and is self-tested against a deliberately non-unit control
(`[b^2, a*b, a^2]`) and a unit control (`[1]`).  **This is the exact failure
mode FIX-N2B's `0-byte output` incident belongs to and it should be added to
`MSOLVE_PARSER.md`.**

### 2.2 Validation on a case with a known answer

The identical pipeline at **`r = 6`**, where Theorem N2B-1 proves in char 0 that
the cone has no plane-order-1 point, returns **zero leaves in every stratum**
for `lam = 1` and empties the others — it reproduces Theorem N2B-1.  The `r=6`
cone lines are also rebuilt and re-checked here (`holes_ld.py`): 24 lines, 12 in
`E_om` and 12 in `E_om^2`, plane orders 3 (`D_B(yz)`) and 2 (`xyz D_B(x)`) —
exactly Thm N2B-1.

---

## 3. TASK 6 — `(1,8)` at line degree 0

`holes_parallel.py`, `logs/PAR_R8.log`; earlier two-engine pass in
`logs/C2_R8_*.log`; Macaulay2 second-engine pass in `logs/M2PASS_R8.log`.

Leaf counts per eigenblock: **A 6, B 44, C 4, D 42** (identical for
`lam = 1, om, om^2`), 288 leaves in total.

| coverage | count | engines |
|---|---|---|
| leaves char-0 certified EMPTY | **282 / 288** | msolve-qq `[1]` + `100057/100153/1048609` all UNIT |
| of those, also Macaulay2 over `K` | 40 | `1 % I == 0` |
| of those, also M2 **and** sympy | 48 (16 per block) | `logs/C2_R8_*.log` |
| leaves NOT certified | 0 | — |
| leaves still computing | **6** | `B_43` and `D_41` in each of the three blocks: 11 variables, 22 generators |

**Complete sub-verdicts (these are full characteristic-zero verdicts):**

> **Stratum A `{B6 != 0, B9 = 0}` and stratum C `{B6 = 0, B9 != 0}` are EMPTY in
> all three eigenblocks** (6 + 4 leaves per block, every one certified by
> msolve over `QQ`, and every stratum-A leaf also by Macaulay2 over `K`).
> Hence: **any plane-order-1 point of the `r = 8` cone must have BOTH
> plane-order-1 coefficients `B6` and `B9` nonzero.**

and 43 of the 44 leaves of B, 41 of the 42 leaves of D are certified empty in
every block.  The whole outstanding region is the single generic leaf
`B_43` (equivalently `D_41`) intersected with `{B9 != 0}`.

Equation cross-check (`logs/INDEP_R8.log`): for each of the three `lam`, the
independent sympy rebuild from the raw Klein normal form gives **82 = 82**
coefficient equations, **0 mismatches**, identical parameter names, identical
parameter plane orders, identical plane-order-1 parameters `{B6, B9}`.

**Reading.**  Every completed computation points to EMPTY: 282/288 leaves are
unit ideals in characteristic zero, all 288 leaves are unit ideals at three
split primes wherever the modular run finished, and nothing anywhere behaves
like the `r = 7` alarm (which showed up as a *non*-unit modular ideal within
minutes at 12 variables).  But the discipline is explicit: **this is not yet an
EMPTY verdict**, because six leaves are undecided and a witness, if it exists,
lives exactly there.

**`r = 10`** (`logs/PAR_R10.log`, `logs/C2_R10_one.log`): the strata
decomposition applies verbatim (`X0*B10^2 = 0`, `Y1*B14^2 = 0`), leaf counts are
A 54, B 120, C 56, D 122 per block; two stratum-A leaves were certified EMPTY by
msolve-qq **and** Macaulay2 over `K` before the run was stopped for CPU.  Not
decided.

---

## 4. The general even-`r` pattern

* `(1,8)` is not populated (all evidence), so the `q`-multiplication of
  FIX-N2C Cor. N2C-2 has nothing to propagate at even `r`.
* **No automatic propagation exists in either direction.**  FIX-N2's Lemma 2.4
  (`(m,r)` empty with `r <= 2m` ⇒ `(m+2,r+3)` empty) needs `r <= 2m = 2`, so it
  is vacuous on the `m = 1` row.  Emptiness at `r = 8` therefore says **nothing**
  about `r = 10`, and `(1,10)` needs its own run (started, not finished).
* **Why even `r` is genuinely different from odd `r`.**  `(1,r)` is POPULATED
  for every odd `r >= 7` because `q = x^2+y^2+z^2` is `A_4`-invariant with
  `ord_{P_i} q = 0` and `deg q = 2`, so `q^k` moves `r` by **even** steps only.
  To reach an even `r` from the `r = 7` witness one would need an
  `A_4`-invariant of **odd** degree with `ord_{P_i} = 0`; the invariant ring is
  generated by `q` (2), `xyz` (3), `e_2` (4), `Delta` (6), and every odd-degree
  invariant is divisible by `xyz`, which has `ord_{P_i} = 2`.  **So the parity
  of `r` is a real obstruction: the primitive `m = 1` branch of FIX-N2C cannot
  be transported to even `r` by any invariant multiplication.**  That is the
  structural reason to expect (and the computations to confirm) that even `r`
  behaves like `r = 6`, not like `r = 7`.
* What *is* uniform is the **structure**: for every even `r >= 6` the two sparse
  leading generators of §1.1 exist with the same shape, so the four-strata
  decomposition and this solver apply verbatim at every even `r`.  Verified at
  `r = 6` (reproduces Thm N2B-1), `r = 8`, `r = 10`.

---

## 5. TASK 5 — `(1,6)` above line degree 2

### 5.1 The line-degree bookkeeping, re-derived and checked

With `T = sum_{j=0}^n s^{n-j}t^j T_j` and `Theta: s -> om s, t -> om^2 t,
(x,y,z) -> (y,z,x)`, `Theta(T) = lam g(T)` gives

```
Theta(T) = sum_j om^{n-j}om^{2j} s^{n-j}t^j psi(T_j) = sum_j om^{n+j}s^{n-j}t^j psi(T_j)
=>  psi(T_j) = lam om^{-(n+j)} g(T_j),  i.e.  T_j in E_{mu_j},  mu_j = lam om^{-(n+j)}
```

— **reproducing FIX-N2B §2.4's indexing exactly**.  Levels:
`level l : sum_{a+b+c=l} Phi(T_a,T_b,T_c) = 0`, `l = 0..3n` (ordered triples);
level `0` is `F(T_0)=0`, level `3n` is `F(T_n)=0`.

**Degenerate ends reduce the line degree** (new, and it is what makes the
enumeration finite): if `T_0 = 0` then `t | T` and `T/t` is `A_4`-equivariant of
line degree `n-1` with scalar `lam*om`; if `T_n = 0` then `s | T` and `T/s` has
line degree `n-1` with scalar `lam*om^2`.  Dividing by `s` or `t` changes
neither `r` nor the plane orders, so an induction on `n` need only treat
`T_0 != 0 != T_n`, i.e. `mu_0 != 1 != mu_n` (the `E_1` cone at `r=6` is `{0}`).
That leaves one or two admissible `lam` per `n`:

| `n` | admissible `lam` | `mu_0 .. mu_n` |
|---|---|---|
| 3 | `om`, `om^2` | `(om,1,om^2,om)` / `(om^2,om,1,om^2)` |
| 4 | `1` | `(om^2,om,1,om^2,om)` |
| 5 | `1` | `(om,1,om^2,om,1,om^2)` |
| 6 | `om`, `om^2` | `(om,1,om^2,om,1,om^2,om)` / mirror |

`(s,t) -> (alpha s, beta t)` preserves `Theta`-equivariance and scales `T_j` by
`alpha^{n-j}beta^j`, so both end scalars are normalised away and the search is
over the **144 ordered pairs** of the 12+12 exact cone lines.

### 5.2 What was computed (`holes_task5.py`, `logs/TASK5_n*.log`)

`T_1` is parametrised by `ker D_{T_0}|E_{mu_1}` (level 1), `T_{n-1}` by
`ker D_{T_n}|E_{mu_{n-1}}` (level `3n-1`), the middle `T_j` by their whole
eigenblock; all levels `1..3n-1` are imposed; for every plane-order-1 coordinate
`v` of every `T_j` the Rabinowitsch system `I + (v z - 1)` goes to msolve over
`F_100057`.

Ladder kernels at the cone points (reproduces FIX-N2B §2.3 item 2):
`dim ker D_{T_0}|E_1 in {3,4}`, `dim ker D_{T_0}|E_om, E_om^2 in {4,5}`, and
**every one of them contains a plane-order-1 vector** — so level 1 alone can
never close any `n`, and the nonlinear levels are unavoidable.

| `n` | `lam` | pairs | outcome |
|---|---|---|---|
| 3 | `om` | 144 | ALL plane-order-1 coordinates FORCED ZERO (103 s) |
| 3 | `om^2` | 144 | ALL plane-order-1 coordinates FORCED ZERO (99 s) |
| 4 | `1` | 144 | ALL plane-order-1 coordinates FORCED ZERO (944 s) |
| 5 | `1` | 144 | ALL plane-order-1 coordinates FORCED ZERO (3433 s, 3456 msolve runs) |
| 6 | `om`, `om^2` | — | running; not decided |

So: at line degrees **3, 4 and 5** every plane-order-1 coefficient of every
`T_j` is forced to zero over all 144 cone-line pairs — i.e. `(1,6)` is not
populated at line degree 3, 4 or 5 — **modulo `p = 100057`**.  Not a single
`CAN-BE-NONZERO` occurred in 2592 + 2592 + 3456 = 8640 msolve runs.

### 5.3 Why these are FINDINGS, not verdicts

The decisive step is "the Rabinowitsch ideal is the unit ideal", computed mod
`p`, and **unit-ideal-mod-`p` does not lift** (a bad prime can destroy
solutions).  The full-column-rank lifting principle FIX-N2B used at `n = 2` is
unavailable because the decisive statement is not a rank statement: level 1 alone
leaves a 3–5 dimensional kernel meeting the plane-order-1 locus.

To upgrade to verdicts, the cheapest route is to replace the 144 pairs by
**4 runs per `(n,lam)`** (branch of `T_0` x branch of `T_n`) over `QQ` with
`om, kp, B_0, B_n` as variables and the minimal polynomials
`om^2+om+1`, `8kp^2-13kp-4`, `B^6-(kp+2)B^3+1` adjoined — rigorous in
characteristic zero by the same Galois-transitivity argument as §2, and it
covers all six `B`-roots at once.  Set up but not run here.

### 5.4 Stabilisation in `n` — not proved, and why

The obstruction has an `n`-independent *shape* (a two-sided ladder: `ker D_{T_0}`
from below, `ker D_{T_n}` from above, with cone-line endpoints), but the number
of free middle blocks grows linearly in `n` and no uniform argument was found.
Honest status:

> line degrees `0,1,2` EMPTY (FIX-N2B, char 0);
> line degrees `3,4,5` — plane-order-1 forced zero over all 144 cone-line pairs,
> **mod `p` FINDING**;  line degrees `>= 6` OPEN (line degree 6 running).

**Where a uniform proof should start.**  The leading plane-adic relations of
§1.1 hold verbatim for a *family*, with `p_v, p_w, r_v, r_w, b_top, c1, c2` all
binary forms of degree `n` in `(s,t)`; `k[s,t]` is a domain, so `c1 != 0` still
forces `om p_w + om^2 r_w = 0` identically and `c2 != 0` forces
`om^2 p_v + om r_v = 0` identically.  Moreover **every** `r=6` cone line has
`a' = -c(xyz)^2, b' = 0` (or the mirror), so `p_v = p_w = r_v = r_w = 0` at both
`j = 0` and `j = n`: those four binary forms are divisible by `st`.  What is
missing is the analogue of the four-strata argument over `k[s,t]`.  Two traps,
both checked here:

* one cannot simply pass to the fraction field `k(s,t)`: the `C_3`-eigenvalue
  `mu_j` varies with `j`, the family is `C_3`-equivariant only for the *twisted*
  action `sigma_R (x) psi`, and there is no descent because `T` is not
  `sigma_R`-homogeneous;
* one cannot drop the `C_3`-equivariance: the full-space (no `C_3`) `r=6` cone
  visibly has plane-order-1 points (`a' = b' = u_2' = 0`, `u_0', u_1'`
  arbitrary), so equivariance is load-bearing.

---

## 6. Files written (all under `goal_runs_after_541e12f/FIX_H1_EQUALIZER/`)

| file | role |
|---|---|
| `holes_lib.py` | shared setup; msolve runner with the parenthesis assertion, the zero-byte guard, the rebuilt+self-tested unit-ideal parser |
| `holes_setup_r8.py` | block dims, plane orders, plane-order-1 parameters, equation counts at `r=6..10` |
| `holes_show_r8.py` | the `(1,r)` equations sorted by sparsity with their plane-adic level |
| `holes_xy.py` | the `(P,R) -> (X,Y)` linear change, checked against the original system |
| `holes_reduce.py` | the exact linear-elimination cascade (degree-capped) |
| `holes_chart.py`, `holes_strata.py` | the plane-order-1 charts and the four strata A,B,C,D |
| `holes_solve.py` | exact branch-and-reduce (R1–R4) |
| `holes_factor.py` | exact factorisation over `K = QQ(sqrt-3,sqrt33)` (rule R5) |
| `holes_track.py` | branch-and-reduce with reconstruction tracking (R1–R5) |
| `holes_leaf.py` | per-leaf char-0 verdicts (sympy over `QQ[.,om,kp]`, Macaulay2 over `K`) |
| `holes_controls.py` | positive/negative controls for both char-0 engines |
| `holes_certify.py`, `holes_certify2.py`, `holes_task6.py`, `holes_leaves_dump.py` | TASK 6 sequential drivers |
| `holes_parallel.py` | TASK 6 leaf-parallel char-0 pass (the one that produced 282/288) |
| `holes_m2pass.py` | the Macaulay2 second-engine pass |
| `holes_indep.py` | independent sympy rebuild from the raw Klein normal form + termwise cross-check |
| `holes_msolve.py` | single msolve runs on the un-reduced dehomogenised systems |
| `holes_ld.py` | TASK 5: `r=6` cone lines (rebuilt, re-checked), `mu_j` bookkeeping, ladder kernels |
| `holes_task5.py` | TASK 5: level systems at line degree `n`, 144 cone-line pairs |
| `logs/`, `msolve/`, `m2/` | all inputs, outputs and logs |
| `payloads/HOLES_REPORT.md` | this file |

Key logs: `PAR_R8.log` (282/288), `M2PASS_R8.log`, `C2_R8_*.log`,
`INDEP_R8.log`, `PAR_R10.log`, `TASK5_n3.log`, `TASK5_n4.log`, `TASK5_n5.log`,
`HARD6.log`/`HARD6b.log` (the six outstanding leaves).

## 7. First things to restart

1. the six `r=8` leaves `B_43` / `D_41` (11 variables, 22 generators) — this is
   the only thing between the packet and a clean `FIX-H1-HOLE-1EVEN-EMPTY`;
   they are the region `{B6 != 0 and B9 != 0}`;
2. `r = 10` (`holes_parallel.py 10`), ~350 leaves per eigenblock;
3. TASK 5 line degree 6 (running) and the char-0 upgrade of §5.3.

## 8. Note on the `msolve/` directory

TASK 5 generates ~10 000 msolve inputs (144 cone-line pairs x 6..30
plane-order-1 tests per `(n,lam)`); the `n >= 4` ones are ~0.5 MB each, so the
raw inputs came to 5.6 GB.  All **outputs** are kept; the oversized
*regenerable* TASK-5 inputs (`msolve/ld_n*.ms` above 50 kB) were deleted and one
representative input per line degree kept as `msolve/SAMPLE_ld_n*.ms`.  Every
deleted file is reproduced byte-for-byte by
`python3 holes_task5.py <n> <lam>`.  All TASK-6 msolve inputs are kept in full.
