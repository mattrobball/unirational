# Status — FIX-C1, the Chebyshev ladder (the constructive experiment)

**Primary exit:** `FIX-C1-LADDER-M1-EXTENDS-THROUGH-3` — **mixed**: the
parameter locus on which the ladder extends is the complement of one
`K`-rational point per eigenblock, where the first genuine obstruction sits
(`FIX-C1-OB2-NONZERO-AT-K-RATIONAL-POINT`).

| scoped exit | content |
|---|---|
| `FIX-C1-PARAMETER-SPLIT` | **theorem (new)** — both defining cubics of FIX-N2C's nine-point scheme are **reducible over `K = QQ(om,kp)`**: `c_0 = (4kp-1)/3 = B+B^{-1}` and `P1_0 = (4/3) om^{j+1} c_0` are `K`-rational roots, so each eigenblock's nine witnesses split Galois-stably as `1 + 2 + 2 + 4`. |
| `FIX-C1-LADDER-M1-EXTENDS-THROUGH-3` | levels 1 and 2 are solvable at all 24 witnesses of parts B, C, D (`Ob_2 ≡ 0` identically), and level 3 as well at the 12 witnesses of parts B and C (`Ob_3 ≡ 0` identically, for **every** `(e_1, e_2)`; part D's level-3 run did not finish, §7). At the 3 witnesses of part A levels 1 and 2 are solvable exactly on the hyperplane `{ℓ_0 = 0}` of the (there 4-dimensional) level-1 kernel. |
| `FIX-C1-OB2-NONZERO-AT-K-RATIONAL-POINT` | **the first obstruction** — at the `K`-rational point (part A, 1 witness per eigenblock, all three blocks) `dim ker D_{p0}` jumps from 3 to 4 and the level-2 Kuranishi map `Ob_2` is a **nonzero** quadratic map whose zero locus is exactly a hyperplane of `ker D_{p0}` (Macaulay2, exact: `dim 3, degree 4`). The extra level-1 direction that exists only there is precisely the obstructed one. |
| `FIX-C1-CONTROL-CALIBRATION-WEAK` | **calibration finding** — the control `(3,6)` `D_B` seed (the T5 witness, Fable's boundary data) is **unobstructed at every level this machinery computes**, although the Fable branch is closed at its `I^{(11)}/I^{(13)}` gate. The single-stratum ladder is therefore strictly weaker than Fable's 55-plane symbolic-power ladder: a "survives" verdict from it carries little weight; only its *obstructed* verdicts are new information. |

**Problem E headline: OPEN.** Nothing here changes it; see §6.

Packet: `goal_runs_after_541e12f/FIX_C1_CHEBYSHEV_LADDER/`.
Frame: `theory/FIX_II_jets.md` §2–§3 (the ladder and its differential), §4 (the cell
table); seeds from `goal_runs_after_a90dbe1/FIX_N2C_R7_DECISION/` and
`goal_runs_after_f1f0be/V4_SIMULTANEOUS_ODD_NORMALS_20260802/` §4; the
multi-order refinement from `goal_runs_after_6519c0b/FIX_H0_GLOBAL_SECTIONS/`
(Theorem H0-1).
Verification class: **ALGEBRAIC-RECOMPUTE** (`verify_c1.py`, terminal marker
`FIX_C1_VERIFY_OK`).
Toolchain: `python3`/`sympy` exact over `QQ`, own exact linear algebra over the
finite `QQ`-algebras of the branch parameters, Macaulay2 for the obstruction
locus. No msolve was needed (so the parenthesis landmine of
`FIX_N2C_R7_DECISION/MSOLVE_PARSER.md` is not in play); the one M2 input is
written with plain integer coefficients anyway.

---

## 1. What was computed, exactly

### 1.1 The ladder

Source `= P(W)`, `W = A ⊕ B ⊕ C ⊕ D` at a representative `K ≅ V4`, coordinates
`(a,b,x,y,z)`; the triple line is `ℓ_V = P(A) = {x=y=z=0}` and `x,y,z` are its
normal coordinates, of `V4`-characters `B, C, D`. A germ of a landing covariant
along `ℓ_V` is its `(x,y,z)`-adic expansion

```
    T = Σ_{n ≥ r} T_n ,     T_n homogeneous of degree n in (x,y,z),
```

and the level-`ℓ` equation is the `(x,y,z)`-degree-`(3r+ℓ)` part of `F(T) = 0`:

```
    D_{p0}(e_ℓ) := 3 Φ(p0, p0, e_ℓ)  =  − R_ℓ ,        p0 := T_r ,  e_ℓ := T_{r+ℓ}
    R_ℓ = Σ_{i+j=ℓ, i,j≥1} 3 Φ(p0, e_i, e_j) + Σ_{i+j+k=ℓ, i,j,k≥1} Φ(e_i,e_j,e_k).
```

Each `e_ℓ` is constrained to `V_{r+ℓ}(m, λ)`: `V4`-equivariant (one parity
pattern per slot, Note II Lemma 2.2), residual-`C3`-equivariant with the seed's
own scalar `λ`, and of plane order `ord_{P_i} ≥ m` — the last because
`ord_{P_i}(T) = min_n ord_{P_i}(T_n)`, so a single graded piece of plane order
`< m` would destroy the branch label. **Theorem H0-1's refinement
(`ord(T⁻_σ) < ord(T⁺_σ)`, `m` odd) is then automatic by parity** — the
`σ`-plus half `(a',b',u_0')` always has *even* and the minus half `(u_1',u_2')`
always *odd* plane order (verified for all levels, check `H0-AUTO`).

Because `F(p0) = 0` **exactly**, `R_1 = 0`: level 1 is homogeneous, `e_1` ranges
over `ker D_{p0}`, and the first equation with a right-hand side is level 2,
whose obstruction is the quadratic **Kuranishi map**

```
    Ob_2 : ker D_{p0}|_{V_{r+1}}  →  coker D_{p0}|_{V_{r+2}} ,
    Ob_2(e_1) = [ 3 Φ(p0, e_1, e_1) ] .
```

### 1.2 The trivial part of the ladder

Two families of solutions exist for *every* seed and produce **no new map**:

* `G·p0` for an `A4`-invariant `G` of degree `ℓ` (this is FIX-N2C's `q^k`
  translation);
* `(V·∇)p0` for an `A4`-equivariant vector field `V` of degree `ℓ+1` — the
  derivative of the *source reparametrisation* `p0 ∘ (id + εV)`, which solves
  the entire ladder identically because `F(p0∘φ) = F(p0)∘φ = 0`.

At level 1 the only such direction is `V = (yz, zx, xy)` (there is no invariant
of degree 1), so the trivial part of `ker D_{p0}|_{V_{r+1}}` is exactly
**1-dimensional** for both seeds. The reparametrisation ladder is used as the
verifier's calibration instrument (check `calibration`).

---

## 2. Per-level table (exact, characteristic zero)

`dim V` = dimension of the `A4`-equivariant graded piece over the branch ring;
`rows` = number of `ψ`-orbits of target monomials (the level equation is
`ψ`-invariant — verified exactly, so this loses nothing);
`coker` = `rows − rank`.

### 2.1 The primitive `m = 1`, `r = 7` Chebyshev branch — parts B, C, D
(24 of the 27 witnesses: 8 per eigenblock)

| level | `n = 7+ℓ` | `dim V_n` | rows | rank `D_{p0}` | `dim ker` | `dim coker` | right-hand side | verdict |
|---|---|---|---|---|---|---|---|---|
| 1 | 8 | 18 | 23 | **15** | 3 (1 trivial + 2 essential) | 8 | `R_1 = 0` | solvable |
| 2 | 9 | 20 | 21 | **15** | 5 | 6 | `3Φ(p0,e_1,e_1)` | **`Ob_2 ≡ 0`** — solvable for every `e_1` |
| 3 | 10 | 27 | 28 | **20** | 7 | 8 | `6Φ(p0,e_1,e_2)+Φ(e_1,e_1,e_1)` | **`Ob_3 ≡ 0`** — all 25 coefficients (10 cubic in `t`, 15 bilinear in `(t,s)`) vanish |

Level 3 is **completed exactly for parts B and C**; part D (the 4-point family,
whose branch ring is twice as large) has the same level-1 and level-2 profile
and its level-3 run was **still going at close** — see §7. The level-3 row above
is the common B/C answer.

### 2.2 The same branch — part A, the `K`-rational point
(3 of the 27 witnesses: 1 per eigenblock; `c = c_0`, `P1 = P1_0`)

| level | `n = 7+ℓ` | `dim V_n` | rows | rank `D_{p0}` | `dim ker` | `dim coker` | right-hand side | verdict |
|---|---|---|---|---|---|---|---|---|
| 1 | 8 | 18 | 23 | **14** | **4** (1 trivial + 3 essential) | 9 | `R_1 = 0` | solvable |
| 2 | 9 | 20 | 21 | **14** | 6 | 7 | `3Φ(p0,e_1,e_1)` | **OBSTRUCTED** — all ten coefficients of `Ob_2` are nonzero |

Identical in all three eigenblocks `λ = 1, ω, ω²` (`m1_lam0_A`, `m1_lam1_A`,
`m1_lam2_A`), so the block symmetry the brief asked about **holds**: the exact
level-1 and level-2 verdicts at part A were computed independently in each
block, and a rank scan over **all 12 (block, part) pairs at every point of
`Spec R`, three primes** (`payloads/PAYLOAD_block_symmetry.txt`) gives the same
profile everywhere —

```
   levels 1 and 2 :  rank 14 at part A,  rank 15 at parts B, C, D,
                     in every eigenblock j = 0, 1, 2.
```

(The `[14,15]` entries in that scan at part D, level 2, are accidental modular
rank drops at isolated points/primes: modular rank is only a *lower* bound, and
the exact unit-pivot computation gives 15 uniformly.)

### 2.3 Control: the `(3,6)` `D_B` seed (T5 witness, `λ = ω²`)

| level | `n = 6+ℓ` | `dim V_n` | rows | rank `D_{p0}` | `dim ker` | `dim coker` | verdict |
|---|---|---|---|---|---|---|---|
| 1 | 7 | 7 | 5 | **4** | 3 (1 trivial + 2 essential) | 1 | solvable |
| 2 | 8 | 11 | 7 | **6** | 5 | 1 | **`Ob_2 ≡ 0`** — solvable for every `e_1` |
| 3 | 9 | 15 | 9 | **8** | 7 | 1 | **`Ob_3 ≡ 0`** — all 25 coefficients vanish |

### 2.4 Reading the level-3 row

`Ob_3` is a map of the pair `(e_1, e_2)`: with `e_1 = Σ t_i k_i` ranging over
`ker D_{p0}|_{V_{r+1}}` and `e_2 = Σ_{i≤j} t_i t_j e_2^{(ij)} + Σ_l s_l k^{(2)}_l`
(a particular solution of level 2 plus the level-2 kernel), the level-3
residual is a polynomial in `(t,s)` — cubic in `t`, bilinear in `(t,s)` — with
coefficients in `coker D_{p0}|_{V_{r+2}}`. **Every one of its coefficients is
exactly zero**, in the `m = 1` branch (parts B, C, D) and in the control. So
level 3 imposes no condition at all on the level-1/level-2 freedom.

---

## 3. The finding: the parameter scheme splits, and the obstruction sits on the
   `K`-rational point

**Theorem C1-1 (exact, char 0).** Both cubics of FIX-N2C's nine-point scheme
are reducible over `K = QQ(om,kp)`:

```
    c^3 − 3c − kap                       = (c − c_0)(c^2 + c_0 c + c_0^2 − 3),
        c_0  = (4 kp − 1)/3   ( = B + B^{-1} ; 4c_0^4 − 21c_0^2 + 9 = 0 )

    P1^3 − (8/9) om^{j+1} kap P1^2 + (32/27) kap = (P1 − P1_0)·(quadratic),
        P1_0 = (4/3) om^{j+1} c_0 .
```

Hence the nine witnesses of each eigenblock split, Galois-stably, as
`1 + 2 + 2 + 4` (parts A, B, C, D) — the 27 primitive `(1,7)` witnesses split
`3 + 6 + 6 + 12`. The distinguished point is the **untwisted** Chebyshev root:
`c_0 = B + B^{-1}`, i.e. exactly the value the `m = 1` branch shares with the
`D_B` families on FIX-H0's single reciprocal `B`-cover.

**Theorem C1-2 (the first obstruction, exact).** On parts B, C, D the ladder
differential has rank 15 on `V_8` and `Ob_2 ≡ 0`. On part A the rank drops to
14, `ker D_{p0}|_{V_8}` is 4-dimensional, and

```
    Ob_2 ≠ 0 :  every one of the ten coefficients  t_i t_j  of Ob_2 has a
                nonzero image in coker D_{p0}|_{V_9} (5 of the 7 cokernel
                coordinates are hit).
```

Its zero locus is computed exactly (Macaulay2, saturated at the origin, over
`QQ[om,kp]/(om^2+om+1, 8kp^2−13kp−4)`): `dim = 3`, `degree = 4`, i.e. **one
hyperplane of `ker D_{p0}` over each of the four `(om,kp)`-points** — the same
answer in all three eigenblocks. Equivalently the five obstruction quadrics
have a **common linear factor** `ℓ_0`, and

```
    Ob_2  =  ℓ_0 ⊗ L ,      Z(Ob_2) = { ℓ_0 = 0 } ⊂ ker D_{p0} .
```

For the `λ = 1` block, in the kernel basis printed by
`payloads/LADDER_m1_lam0_A.txt`, the exact factor is

```
  ℓ_0 = t0
      + ((688 kp om + 344 kp − 559 om + 4)/927) t1
      + ((752 kp om + 376 kp − 611 om − 319)/927) t2
      + ((128 kp om +  64 kp − 104 om − 337)/309) t3
```

(reconstructed from two 14-digit primes and then **verified exactly**: every
obstruction quadric vanishes identically on `{ℓ_0 = 0}`; see
`payloads/OB2_LINEAR_FACTOR.json`). The zero hyperplane is 3-dimensional —
exactly the dimension of the kernel at the *other* eight points — so the
structural reading is:

> the level-1 deformation space of the primitive `m = 1` branch is
> 3-dimensional along the whole branch; at the single `K`-rational point it
> acquires **one extra direction**, and that direction is the one the level-2
> Kuranishi map kills.

This is the packet's new invariant: a distinguished `K`-rational point of the
`m = 1` stalk, detected by a *jump of the ladder differential* and confirmed by
a *nonzero quadratic obstruction*, invisible to every FIX-N2/N2b/N2c
computation (all of which see the nine points as a single undifferentiated
`0`-dimensional scheme of degree 9).

---

## 4. The contrast control, and what it calibrates

The `(3,6)` `D_B` seed of the V4 packet §4 — the T5 witness, and exactly the
"fixed line germ / normal-order-3" boundary data of the closed Fable branch
([E15]) — runs the same ladder with the same code. Result: **rank 4 on `V_7`,
`Ob_2 ≡ 0`, no obstruction at any level this machinery computes.**

The Fable record is that this boundary data dies at the `I^{(11)}/I^{(13)}`
gate. There is **no contradiction**, and the comparison is the point:

* Fable's ladder is graded by the **symbolic powers `I^{(m)}` of the whole
  55-plane arrangement** — a global object coupling all 55 `V4`-frames;
* this packet's ladder is graded by the `(x,y,z)`-adic filtration at **one**
  `V4` triple line, with only `A4 = N_G(V4)`-equivariance imposed.

The single-stratum ladder is a strictly coarser instrument. The control shows
it does **not** reproduce a known death, so "extends through level `N`" from
this machinery is *weak* evidence and must not be read as progress toward a
construction. Its *obstructed* verdicts, by contrast, are unconditional
(§5) — which is why §3 is the deliverable and §2.1/§2.3 are not.

---

## 5. Line degree: which verdicts are uniform

The computation above is at **line degree 0** (constant coefficients along
`ℓ_V`), which is what the branch datum is: by the cell classification the
leading piece of any global map with this germ is `T_7 = h(a,b)·T_0` with `T_0`
one of the nine points and `h` a binary form of degree `d−7`. Substituting:

```
  level 1 :   h^2 · D_{T_0}(T_8) = 0                    ⟹ coefficientwise in (a,b)
  level 2 :   h  · D_{T_0}(T_9) = −3 Φ(T_0, T_8, T_8)
```

so at positive line degree the level-2 equation carries an **extra divisibility
condition** `h | 3Φ(T_0,T_8,T_8)`. Consequently:

* an **obstructed** verdict at line degree 0 (part A) implies obstruction at
  every line degree — `h·im D ⊆ im D`;
* an **unobstructed** verdict at line degree 0 (parts B, C, D and the control)
  does *not* imply solvability at positive line degree.

---

## 6. What remains between this and a construction (the algebraization gap)

Honestly and completely, per `theory/FIX_III_cosheaf.md` §3 semantics and
Note II §5:

1. **This is jet data, not a map.** The ladder produces graded pieces of a
   formal germ along one `V4` triple line. The `(x,y,z)`-expansion of a genuine
   polynomial covariant is finite, so a *terminating* solution with the correct
   line degrees would be an actual tuple — but three levels is not a
   termination proof, and no degree bound exists (E16/`REPAIR.md` §11–12: finite
   generation gives **no** finite degree cutoff).
2. **The trivial solutions are not maps.** `G·p0` and `(V·∇)p0` reproduce the
   same image; the germ `T = h(a,b)·T_0(x,y,z)` has image of dimension `≤ 2` in
   `P(W)` and cannot be dominant onto the 3-fold `X`. A construction needs
   level-`ℓ` pieces outside the trivial subspace **and** dominance, neither of
   which the ladder certifies.
3. **`A4` is not `G`.** Only `N_G(V4) ≅ A4`-equivariance in one frame is
   imposed. A global covariant must satisfy the analogous data at all 55
   `V4`-frames *simultaneously*, coupled through the plus-planes — which is
   exactly FIX-H1's `S3`-equalizer at the 55 `D12`-points, and is undecided.
4. **Local ⇏ global.** By the T5 gate and Note II §5, no configuration of
   single-stratum statements decides the headline; the headline-relevant object
   is `H⁰` of the Note-III cosheaf, which FIX-H0 leaves `FIX-H0-H0-PARTIAL`
   with the `m = 1` Chebyshev branch and the odd-`m ≥ 3` `D_B` branches both
   `UNDECIDED`.
5. **Section 4's calibration.** The control's survival proves this machinery
   would not have detected the Fable death either. Extension verdicts from it
   are therefore not evidence for a construction.

Accordingly: **no construction is claimed, no branch is closed, and the Problem
E headline stays OPEN.**

---

## 7. Not decided here

* **Level 3 at part D** (4 of the 9 points per eigenblock). Its level-1 and
  level-2 verdicts are exact and identical to parts B and C (rank 15, 15;
  `Ob_2 ≡ 0`); its level-3 run was still executing when the packet closed
  (`logs/LADDER_m1_lam0_D.log`). Parts B and C both give `Ob_3 ≡ 0`, so the
  expectation is the same at D, but this packet does **not** assert it.
* Levels `≥ 4` for any seed, and level 3 for part A restricted to the
  unobstructed hyperplane `{ℓ_0 = 0}`.
* Whether `Z(Ob_2)` at part A has components below the hyperplane (M2 gives the
  top-dimensional part exactly: `dim 3, degree 4`).
* The exact `ℓ_0` for the `λ = ω, ω²` blocks (the two-prime reconstruction did
  not stabilise at 10^13; the *structure* — linear common factor, hyperplane
  zero locus — is exact in all three blocks via the M2 saturation).
* Positive line degree (§5) for the unobstructed parts.
* Whether the `K`-rationality of part A has a representation-theoretic cause
  (it is the point where the `m = 1` branch meets the `D_B` parameter
  `c = B+B^{-1}`, which is suggestive but not proved here).

---

## 8. Replay

See `REPLAY.md`. Terminal line of the verifier: `FIX_C1_VERIFY_OK`.
