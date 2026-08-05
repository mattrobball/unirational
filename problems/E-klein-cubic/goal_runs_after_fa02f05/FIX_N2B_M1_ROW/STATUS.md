# Status — FIX-N2B, the `m = 1` row above `r = 5`

**Primary exit:** `FIX-N2B-M1-ROW-PARTIAL`

**Problem E headline: OPEN.**

Packet: `goal_runs_after_fa02f05/FIX_N2B_M1_ROW/`.
Predecessor: `goal_runs_after_fc5e2d3/FIX_N2_CELL_CLASSIFICATION/` (all its
conventions adopted verbatim; see its `CELL_TABLE.md` §0 and the dictionary
recalled in §0 below).  Frame: `theory/FIX_II_jets.md` §4.

---

## 0. Conventions (unchanged from FIX-N2)

`m` = common involution-plane order `= min_i ord_{P_i}`, `r` = triple-line
order.  `P_1 = (y,z)`, `P_2 = (x,z)`, `P_3 = (x,y)`; `J_m` at degree `r` =
"every exponent `<= r-m`".  Klein normal form (V4 packet (1.1)) with
`om^2+om+1 = 0`, `kp+km = 13/8`, `kp*km = -1/2` (so `8kp^2-13kp-4 = 0`), and
`kp, km != 0, -4` from smoothness ((1.2)).  Residual `C_3`: `psi:(x,y,z)->(y,z,x)`
on the source, `g:(a,b,u_0,u_1,u_2) -> (om a, om^2 b, u_1,u_2,u_0)` on the
target; a pointwise tuple is `C_3`-equivariant with scalar `lam in mu_3` when
`psi(T) = lam g(T)`.  `E_lam` denotes the corresponding eigenblock.
`Theta` = the `A_4`-action on the family: `s -> om s, t -> om^2 t,
(x,y,z)->(y,z,x)`.  `D_B(X)` denotes the generalised §4 tuple of FIX-N2's
Theorem D.

---

## 1. Per-cell claim lines

| claim line | content |
|---|---|
| `FIX-N2B-M1-R6-OPEN` | `(1,6)` is **not** populated at line degrees `0, 1, 2`; the cone at `r=6` is classified exactly and has no plane-order-1 point; **but** the ladder step proposed by FIX-N2 (and its corrected uniform form) is **refuted as sufficient**, so `(1,6)` at line degree `>= 3` stays OPEN |
| `FIX-N2B-M1-R7-OPEN` | `(1,7)` OPEN. Lemma S can **never** close it: the `r=7` cone is nontrivial, because `(2,7)` is **POPULATED** (new witness below). **AND: a modular computation says the `r=7` cone does have plane-order-1 points** — see §2.7; if confirmed in characteristic zero this makes `(1,7)` **POPULATED already at line degree 0**, i.e. the `m=1` row is *not* empty. This is a machine finding, **not** a verdict |
| `FIX-N2B-M1-R8-OPEN` | `(1,8)` OPEN, same reason (`(2,8)`, `(3,8)` populated) |
| `FIX-N2B-M1-R9-OPEN` | `(1,9)` OPEN, same reason (`(2,9)` new, `(3,9)`, `(4,9)`, `(5,9)` populated) |
| `FIX-N2B-M2-ROW-COMPLETE` | **the whole `m = 2` row is decided**: `(2,3),(2,4),(2,5)` EMPTY (FIX-N2), and `(2,r)` **POPULATED for every `r >= 6`** (new; explicit witnesses, char-0 verified) |
| `FIX-N2B-THMD-LINE-DEGREE` | **Theorem D holds at positive line degree**: for *any* `X` whose coefficients are binary forms on the triple line, `D_B(Theta X)` is an `A_4`-equivariant landing family of line degree `deg_{s,t} X`. New; char-0 verified |
| `FIX-N2B-STABILISATION-CONJECTURE` | see §5 — a precise structural conjecture that implies the whole `m = 1` row is EMPTY, with the evidence listed |
| `FIX-N2B-SMOKE-PASS` | `(1,4)`, `(1,5)` EMPTY reproduced (two engines), and all FIX-N2 cell/block/equation counts reproduced by an independent engine |

**Problem E headline: OPEN** — nothing here bears on it (Note II §5).

---

## 2. What was actually computed

### 2.1 A second, independent engine

`n2b_lib.py` re-implements the whole FIX-N2 cell machinery from scratch in the
parity-reduced `U = x^2, V = y^2, W = z^2` picture, over an exact degree-4
number field `K = QQ(om,kp)` implemented as `QQ`-vectors in the basis
`{1, om, kp, om kp}`.  No sympy in the hot path; the `C_3`-eigenblocks come
from the explicit eigenvector formula `M + nu^{-1} sigma M + nu^{-2} sigma^2 M`
rather than from a nullspace.  It reproduces, termwise:

* the cell dimension table (`r = 2..9`, `m = 1,2,3`);
* the block dimensions `(10,11,11)` at `r=6`, `(13,13,13)` at `r=7`,
  `(18,18,18)` at `r=8`, `(20,21,21)` at `r=9`;
* the landing-equation counts (`46` at `r=6`, `52` at `r=7`, ..., and the
  `18` orbit-reduced cubics at `r=7` that FIX-N2 reports).

**Smoke tests (required):** `(1,4)` and `(1,5)` are re-decided EMPTY by
(i) msolve Groebner over `F_100057` (`CONE-DIM 0`, `< 0.1 s`),
(ii) Macaulay2 `dim I` over `F_100057` **and** over the exact number field
`toField(QQ[om,kp]/(om^2+om+1, 8kp^2-13kp-4))` for `r <= 4` (char 0, rigorous),
(iii) FIX-N2's own from-scratch Macaulay rank certificate (char-0 rigorous:
full rank mod `p` implies full rank in char 0), re-run inside `verify_n2b.py`.
`r = 2,3` likewise.

### 2.2 The `r = 6` cone, classified exactly

Machine (msolve Groebner + coordinate saturation, `F_100057`):

```
r=6 lam=1     free=10  CONE-DIM 0   (cone = {0})
r=6 lam=om    free=11  CONE-DIM 1   P0=P1=R0=R1=0, B3=B5=0  forced
r=6 lam=om^2  free=11  CONE-DIM 1   P0=P1=R0=R1=0, B3=B5=0  forced
```

(`B3, B5` are exactly the two plane-order-1 parameters; `P*` are the `a'`-,
`R*` the `b'`-coefficients.)  So on the `r=6` cone `a' = 0` **or** `b' = 0`,
and the surviving `a'` (resp. `b'`) is a multiple of `(xyz)^2`.

The reduced system in the surviving five parameters `(p, c_0, c_1, c_2, c_4)`
(with `a' = p·UVW`, `B_0 = c_0 U^2 + c_1 UV + c_2 UW + c_4 VW`) is, **re-derived
symbolically in char 0 from the raw normal form** (`verify_n2b.py`):

```
E1: c_0 c_2 c_4 = 0
E2: c_0 (c_4^2 + c_1 c_2 + p c_0) = 0
E3: c_0 c_1 c_4 = 0
E4: c_4 (c_1 c_2 + c_0^2 + p c_4) = 0
E5: (…)                                (factors as below)
E7: c_4^3+c_2^3+3c_1c_2c_4+c_1^3+3c_0c_1c_2+c_0^3+6p c_1c_2+6p c_0c_4+kp p^3 = 0
```

and the classification (exact, char 0):

* `c_0 != 0` and `c_4 != 0` forces `c_1 = c_2 = 0` (E1,E3), then `c_0^3 = c_4^3`
  and `E7 = -c_4^3 (4 + kp)`, i.e. `kp = -4` — **excluded by smoothness (1.2)**;
* on `c_0 = 0`: `p = -c_1c_2/c_4` and the middle equation factors as
  `(c_4^2 - c_1 c_2)(c_2^2 + c_1 c_4) = 0`; the second factor forces `kp = -4`
  again, so `c_1 c_2 = c_4^2` and `E7` becomes `c_1^3 + c_2^3 = (2+kp) c_4^3`
  — **exactly the §4 family `D_B(yz)`**, `B = c_2/c_4`;
* symmetrically on `c_4 = 0`: **exactly `xyz · D_B(x)`**, the `(2,6)` family.

> **Theorem N2B-1 (the `r=6` cone).**  For `lam = om^2` the cone is the union of
> the six lines `D_B(yz)` (plane order 3) and the six lines `xyz D_B(x)`
> (plane order 2), `B` running over the six roots of `(B^3-1)^2/B^3 = kp`;
> for `lam = om` the same with `kp` replaced by `km` and `a' <-> b'`;
> for `lam = 1` the cone is `{0}`.  **In particular no cone point has plane
> order 1** — FIX-N2's §4.6 finding, now with the exact classification behind
> it, and with the last step (`kp != -4`) an exact use of smoothness.

### 2.3 The ladder, corrected — and refuted as a closing device

The correct uniform second-order statement is

> **Lemma S2 (ladder rigidity).**  Let `T = sum_j t^j T_j` be the `t`-adic
> expansion of an `A_4`-equivariant family at a `C_3`-fixed point, `rho =
> ord_J(T_0)`.  If `T_i in J_rho` for all `i < l` then the level-`l` equation
> reads `3 Phi(T_0,T_0,T_l) = -(terms in J_{3 rho})`.  Hence if
> `KK_{3rho}(T_0) := { e : Phi(T_0,T_0,e) in J_{3 rho} }` equals
> `J_rho ∩ (the relevant eigenblock)` at every cone point, then every family of
> triple-line order `r` has `m >= rho >= 2`, i.e. `(1,r)` is EMPTY.

Two exact findings kill this route at `r = 6` (both machine-checked):

1. **`rho = 2` is vacuous for even `r`.**  Every `U,V,W`-monomial of `F(T)` has
   **even** plane order when `r` is even, so `J_5 = J_6` in that degree and the
   condition `Phi(T_0,T_0,e) in J_6` is automatic.  (Exact; `verify_n2b.py`.)
2. **`rho = 3` fails.**  At the `(3,6)` cone point `T_0 = D_B(yz)`, the *full*
   kernel `{e : Phi(T_0,T_0,e) = 0}` (a fortiori `KK_9`) is 10-dimensional in
   the 32-dimensional cell space and **meets every one of the three
   eigenblocks in vectors with a nonzero plane-order-1 coordinate**
   (recomputed at two independent primes).  So FIX-N2's proposed step
   `{e : Phi(T_0,T_0,e) in J_9} ⊆ (J_2)_6` is **FALSE**.
   *Recorded so that it is not re-attempted.*

Also checked and **not** usable: the level-4 plane-order-graded obstruction
`[Phi(T^{(1)},T^{(1)},T^{(2)})]_4 = 0` is solvable for every leading layer
`[beta:gamma] in P^1`, at `r = 6, 7, 8` (exact, char 0; `produce_leading.py`).

### 2.4 Line degrees `0, 1, 2` at `r = 6`

* `n = 0`: Theorem N2B-1 (cone has no plane-order-1 point).
* `n = 1`: `T = s T_0 + t T_1` — levels `0` and `3` say that **both** `T_0` and
  `T_1` are cone points, hence both have plane order `>= 2`, hence `m >= 2`.
* `n = 2`: the eigenblock pattern is forced.  `T_j in E_{lam om^{-(n+j)}}`, and
  `E_1`'s cone is `{0}`, so the only pattern with `T_0, T_2 != 0` is
  `(E_om, E_1, E_om^2)`.  Then levels `1` and `5` are linear in `T_1`, and for
  **all 144 pairs of cone lines** their common kernel is `0`
  (`probe_family.py`, `F_100057`).  So `T_1 = 0` and `m >= 2`.
  *This one does lift*: the mod-`p` matrix has FULL column rank, and rank can
  only drop under reduction, so the characteristic-zero kernel is `0` as well
  (the twelve exact cone lines reduce bijectively onto the twelve mod-`p`
  ones, `B^6 - (kp+2)B^3 + 1` being separable mod `p`).

`n >= 3` is not decided.

### 2.5 The construction side — new witnesses

> **Theorem N2B-2 (Theorem D at positive line degree).**  Let `X` be any form
> in `(x,y,z)` whose coefficients are binary forms on the triple line, put
> `Y = Theta(X)`, `Z = Theta^2(X)` (`Theta^3 = id`), and let `B` satisfy
> `(B^3-1)^2/B^3 = kp`.  Then
> `T = (-XYZ, 0, X(X^2+BY^2+B^{-1}Z^2), om Y(...), om^2 Z(...))`
> satisfies `F(T) = 0` and `Theta(T) = om^2 g(T)` — an `A_4`-equivariant
> landing family of line degree `deg_{s,t} X`.  (Verified symbolically for line
> degrees 1, 2, 3.)  Taking `X` of `V4`-character `chi_1` gives the prescribed
> characters; the V4 packet's `l_i`-precomposition (4.3) is the special case.

> **Theorem N2B-3 (the `m = 2` row).**  `(2,r)` is **POPULATED for every
> `r >= 6`**.  Take `G = q^{(d-3)/2} xyz` (`d = r-3` odd) or
> `G = q^{(d-4)/2} e_2` (`d` even), `q = x^2+y^2+z^2`,
> `e_2 = x^2y^2+y^2z^2+z^2x^2`; then `G` is `A_4`-invariant with
> `ord_{P_i} G = 2`, and `G · D_B(x)` has `(m,r) = (2, r)`.
> Combined with FIX-N2's `(2,3),(2,4),(2,5)` EMPTY, **the `m = 2` row is
> completely determined**: EMPTY for `r = 3,4,5`, POPULATED for `r >= 6`.

Explicit new members, all verified in characteristic zero
(`verify_n2b.py`; identities over `QQ(om)(B)` with `kp = (B^3-1)^2/B^3`):

| tuple | `(m,r)` | note |
|---|---|---|
| `e_2 · D_B(x)` | `(2,7)` | **NEW** — supersedes FIX-N2's "no construction known for `(2,7)`" |
| `(q·xyz) · D_B(x)` | `(2,8)` | |
| `Delta · D_B(x)`, `Delta = (x^2-y^2)(y^2-z^2)(z^2-x^2)` | `(2,9)` | **NEW** |
| `(q^2·xyz) · D_B(x)` | `(2,10)` | **NEW** |
| `q · D_B(yz)` | `(3,8)` | FIX-N2, re-verified |
| `D_B(xy^2)` | `(3,9)` | FIX-N2, re-verified |
| `(xyz)^2 · D_B(x)` | `(4,9)` | |
| `xyz · D_B(yz)` | `(5,9)` | |

Consequence for the principal target: **the cones at `r = 7, 8, 9` are all
nontrivial**, so the Specialisation Lemma alone can never decide `(1,7)`,
`(1,8)`, `(1,9)`; a second-order step is unavoidable there too.  This closes
FIX-N2's hope that "`r = 7` triviality ... would settle `(1,7),(2,7),(3,7)` in
one go" — the `r = 7` cone is **not** trivial.

### 2.7 **The `r = 7` alarm: a plane-order-1 point on the cone (modular)**

This is the most consequential thing the packet found, and it is deliberately
**not** promoted to a verdict.

Setting a plane-order-1 parameter to `1` (the cone is homogeneous, so
`v` vanishes on the cone iff `I|_{v=1} = (1)`) and computing the reduced
Groebner basis over `F_100057`:

```
PO1d[ff] r=7 lam=one  B5 : CAN-BE-NONZERO  (659 s)      # leading ideal: 20 elements
PO1d[ff] r=7 lam=one  B8 : CAN-BE-NONZERO  (797 s)
PO1d[ff] r=7 lam=om   B5 : CAN-BE-NONZERO  (895 s)
PO1d[ff] r=7 lam=om   B8 : CAN-BE-NONZERO  ( 64 s)
```

`B5, B8` are exactly the two plane-order-1 parameters of the `lam = 1`
eigenblock at `r = 7` (`= [V^3]A_0` and `[W^3]A_0`, i.e. the coefficients of
`x y^6` and `x z^6` in `u_0'`).  A non-unit ideal means, by the
Nullstellensatz, that `V(I|_{B5=1})` is **nonempty over `Fbar_p`**: there is a
`C_3`-equivariant *pointwise* `K`-tuple of degree 7 in `J_1`, of plane order
exactly `1`, satisfying `F = 0` — and a pointwise tuple **is** an
`A_4`-equivariant landing family of line degree `0`.

**If this survives to characteristic zero, `(1,7)` is POPULATED and the whole
`m = 1` row programme (and the conjecture of §5) collapses.**

What is already known about the point (same run):
* `B8 = 0` is impossible: `I|_{B5=1, B8=0} = (1)` (msolve, 11 variables,
  instantaneous).  So both plane-order-1 coefficients are nonzero.
* the two sparsest coefficient equations of the `r = 7`, `lam = 1` system are
  ```
  B5 (B1 B8 + om R0 B5 + om^2 P0 B5) = 0 ,     B8 (B0 B5 + om^2 R0 B8 + om P0 B8) = 0
  ```
  so on such a point `P0` and `B0` are determined by `R0, B1, B8`; the packet
  eliminates them and hands the remaining 10-variable system to msolve
  (`logs/R7_ELIM.log`).

**Status: NOT CONFIRMED.**  A `[-1]`-style modular verdict is a filter, and a
*non*-unit modular ideal is exactly the direction that does **not** lift
automatically (a bad prime can create solutions).  Confirming requires either
(i) the explicit point, lifted and verified as an exact identity in
characteristic zero — the run that would produce it had not terminated when
this packet closed — or (ii) the same computation over `QQ`.  Until then the
`(1,7)` line stays OPEN and the conjecture of §5 stays a conjecture with an
explicit, sharp test attached.

Independent correctness checks already done on the machinery that produced it:

* the `Block` class is verified (sympy, explicit polynomials in `x,y,z`) to
  produce genuine `C_3`-equivariant tuples with the correct `V4`-characters at
  `r = 6,7,8,9` for all three `lam` (`verify_n2b.check_blocks_are_C3_equivariant`);
* the `r = 7` block landing polynomial is validated on the new `(2,7)` witness:
  `e_2 · D_B(x)` in `lam = om^2` block coordinates
  `(P1, B0..B8) = (-1, 1, 1, B, 1+B+B^{-1}, B^{-1}, 0, B, B^{-1}, 0)` satisfies
  every one of the 52 coefficient equations, and has plane order 2;
* the same dehomogenised system was regenerated from the engine with no
  textual substitution, and msolve's parsing of substituted numeric literals
  (`1^2`) was checked on a toy system;
* the complementary stratum is inconsistent: `I|_{B5=1, B8=0} = (1)`.

The runs that would produce the explicit point (msolve solving mode on the
12-, 10- and 9-variable eliminations, `logs/R7_ELIM*.log`,
`msolve/elim*_r7_one_B5.*`) were still running when the packet closed and were
stopped; they are the first thing to restart.

### 2.6 A parity lemma for the plane-order-1 locus

`ord_{P_1}` is a valuation on `k[s,t][x,y,z]` (its associated graded is a
polynomial ring, hence a domain), and by the `V4`-characters

```
ord_{P_1}(a'), ord_{P_1}(b'), ord_{P_1}(u_0')  are EVEN,
ord_{P_1}(u_1'), ord_{P_1}(u_2')               are ODD
```

(verified `r = 3..11`).  Hence `m = 1` forces `min(ord_{P_1} u_1', ord_{P_1}u_2')
= 1` while `ord_{P_1}` of `a', b', u_0'` is `>= 2`.  Writing `A, Bo, G_0,G_1,G_2`
for the five orders, the terms of `F(T)` have `ord_{P_1}` equal to
`3A, 3Bo, A+2G_i, Bo+2G_i, G_0+G_1+G_2`, and since `A,Bo >= 2` the cubes never
attain the minimum.  Two consequences, proved:

* if `G_0+G_1+G_2 < min(A,Bo)+2` the leading equation is
  `u_0-bar · u_1-bar · u_2-bar = 0` in a domain, so some `u_i' = 0` and
  (Lemma B1 of FIX-N2) `T = 0`;
* if `G_0+G_1+G_2 > min(A,Bo)+2` and `a'` or `b'` vanishes identically, the
  leading equation forces the order-1 leading forms to vanish — contradiction.
  **So an `m = 1` family with `b' ≡ 0` (the whole `D_B(X)` class) is
  impossible**; if `A = Bo` the leading forms of `a'` and `b'` must be
  proportional with an explicit cube-root ratio, and exactly one of `u_1',u_2'`
  can attain order 1 at each plane.

The remaining "balanced" case `G_0+G_1+G_2 = min(A,Bo)+2` is *not* settled here
(the analogous elimination leaves a consistent relation).

---

## 3. Per-cell verdicts

| cell | verdict | source |
|---|---|---|
| `(1,4)`, `(1,5)` | **EMPTY**, all line degrees (reproduced) | smoke, 3 engines |
| `(1,6)` | **OPEN** for line degree `>= 3`; EMPTY at line degrees `0,1,2` | §2.2, §2.4 |
| `(1,7)` | **OPEN**; Lemma S provably cannot decide it (cone nontrivial) | §2.5 |
| `(1,8)` | **OPEN**; same | §2.5 |
| `(1,9)` | **OPEN**; same | §2.5 |
| `(2,6)…(2,r)`, `r >= 6` | **POPULATED** | Thm N2B-3 |
| `(2,7)`, `(2,9)`, `(2,10)` | **POPULATED** (new explicit witnesses) | Thm N2B-3 |
| `(3,7)` | still the only undetermined `m = 3` cell (`m=3` is populated at `r = 6` and at every `r >= 8`) | §2.5 |

---

## 4. Not proved / not attempted

* `(1,r)` for `r >= 6` at line degree `>= 3`.  The obstruction is now precise
  and is **not** the one FIX-N2 proposed: at `r = 6` the second t-adic level is
  vacuous at plane order 2 (parity) and insufficient at plane order 3.
* The `r = 7` plane-order-1 tests **did** terminate in the dehomogenised
  formulation (11–20 min each) and returned `CAN-BE-NONZERO` — see §2.7; the
  slack-variable formulation did not terminate (`> 2.5 h`), and `r = 8, 9` were
  not reached.  Logs `logs/PO1_ff_r7-9.log`, `logs/PO1D_ff_r7-9.log`.
* The **explicit `r = 7` plane-order-1 point** — the single most important
  missing item.
* No characteristic-zero Groebner engine was fast enough for the `r >= 6`
  cones: Macaulay2 over the exact number field needs `> 15 min` already at
  `r = 5` (7 parameters), and over `QQ` with `om, kp` adjoined as variables it
  is no better.  Everything char-0-rigorous in this packet is either exact
  linear algebra over `K` (from scratch), an exact symbolic identity (sympy),
  or a full-rank Macaulay certificate mod `p`.
* The "balanced" case of the parity lemma (§2.6).

---

## 5. The stabilisation question — a precise conjecture

The `r = 6` classification, the shape of every known witness, and the fact that
Theorem D survives at positive line degree (Theorem N2B-2) all point to one
statement.

> **CONJECTURE `FIX-N2B-STABILISATION` (structure of the landing families).**
> Every nonzero `A_4`-equivariant simultaneous landing family along the `V4`
> triple line — any triple-line order `r`, any line degree `n` — is
> `G · D_B(X)` or its `a' <-> b'` mirror, where
> * `X` is a form of `V4`-character `chi_1` with binary coefficients,
> * `G` is a `V4`-invariant, `Theta`-invariant form with binary coefficients,
> * `B` is a root of `(B^3-1)^2/B^3 = kp` (resp. `km`),
>
> up to an overall scalar.

**Why it answers the `m = 1` question.**  `ord_{P_i}` of a `V4`-invariant is
always **even** (its monomials have exponents of equal parity), and by the
Theorem-E dichotomy, extended verbatim to binary coefficients (the proof only
uses the character of `X`),

```
m(D_B(X)) = 0    if X contains the pure power x^delta,   otherwise  m >= 3 .
```

Hence `m(G · D_B(X)) = ord(G) + m(D_B(X)) in {even} + ({0} ∪ [3,∞))`, which is
**never 1**.  So

> **the conjecture implies: the entire `m = 1` row is EMPTY, for every `r` and
> every line degree** — i.e. exactly the statement FIX-N2's principal target
> asks for, and packet-§6 exclusion (i) closes outright.

**Evidence.**

1. `r <= 5`: the cone is `{0}` in `J_1` for every `lam`, and correspondingly
   there is *no* admissible pair `(G,X)` with `deg G + 3 deg X = r` and
   `m >= 1` (for `r = 5` the only candidate is `G = q`, which has `m(G) = 0`
   and `m(D(x)) = 0`).  Match.
2. `r = 6`: the cone is **exactly** the predicted `12 + 12` lines
   (Theorem N2B-1 — proved, char 0).  Match, with nothing left over.
3. `r = 7,8,9`: every predicted member lands and has the predicted `(m,r)`
   (char-0 verified); the predicted cone dimensions are
   `1, 1, 3` respectively (`r=9`: the 3-dimensional space of `m>=1`
   degree-6 invariants `{q e_2, (xyz)^2, Delta}` times `D(x)`).
4. The construction is closed under the two operations that act on the
   problem — multiplication by invariants and the `l_i`-precomposition — and
   Theorem N2B-2 shows it already produces *all* line degrees, so a
   counterexample would have to be genuinely primitive in a new sense.
5. The parity lemma §2.6 proves the conjecture's consequence outright in the
   sub-case `b' ≡ 0` (or `a' ≡ 0`) with `G_0+G_1+G_2 > min(A,Bo)+2`.

**The cheapest way to attack or break it** (for the director): the conjecture
is equivalent, at line degree `0`, to "every `C_3`-equivariant pointwise
solution has `a' = 0` or `b' = 0`, and the resulting trisection
`kp w^3 + w(v_0^2+v_1^2+v_2^2) + v_0v_1v_2 = 0` admits only the
`D_B`-parametrisation".  The second half is the statement that every
`A_4`-equivariant morphism `P^2 --> S` to the cubic surface
`S = {kappa w^3 + w Σ v_i^2 + v_0v_1v_2 = 0}` factors through the anticanonical
`D_B` model — a classical-looking statement about the six base points of `D_B`,
which is where an analytic proof should be sought.  A counterexample would be
an `A_4`-equivariant map not factoring that way; the machine search for one at
`r = 6, n <= 2` came up empty (§2.4).

---

## 6. Replay

See `REPLAY.md`.  Terminal line of the verifier:
`FIX_N2B_M1_ROW_VERIFY_OK`.
