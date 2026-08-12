# TANGENT_C6 — deformation theory of the landing scheme, in campaign coordinates

**Packet:** `goal_runs_20260812/TANGENT_C6/` · opened 2026-08-12.
**Headline: Problem E remains OPEN; this packet excludes no degree.**

Item C6 of `theory/CONSTRAINT_ADDITIONS_20260811.md` (audit §25). Every
packet that met C6 deferred it because it “needs a candidate point.”
This packet writes the tangent and obstruction spaces at a general point
`c` of the 37-cell, computes them at the one point everyone has (the
origin), and records why that computation cannot be a reason to defer
the item again.

*(Filename note: main document is `THEOREM.md`; the harness refuses `REPORT.md`.)*

## Exit ledger

```text
TANGENT-C6-POLAR-FORMULAS
TANGENT-C6-RANKS-AS-FUNCTIONS
TANGENT-C6-ORIGIN-VACUOUS
TANGENT-C6-GENERIC-RANK-37
TANGENT-C6-JUMP-LOCUS
TANGENT-C6-NEW-VS-RESTATEMENT
TANGENT-C6-NO-DEGREE-EXCLUSION
```

Machine markers: `TANGENT_C6_VERIFY_OK` / `ALLGREEN`
(`python3 verifier.py` — 62 checks, 0 failures, 1 skip for `--live`;
`python3 verifier.py --live` — 69 checks, 0 failures, 0 skips). Exact
integer arithmetic; python3 + numpy; no floats; no gap/gp/sage/magma; no
git; nothing outside this packet directory was written. One thread.

---

## 0. What is and is not claimed

**Claimed.** (i) The first- and second-order conditions of audit (25.1)–(25.2)
written in the campaign coordinates of `F` and of the 37-cell, with ranks
as functions of the point `[T1]`. (ii) At the origin those conditions
vanish identically, because it is the vertex of a cubic cone; the first
nonzero condition is third order and *is* the landing equation `[T1]`.
(iii) The tangent rank `ρ(c)` is a computable function on the cell; it
is `0` at the origin and `37` at every nonzero sample tested (12 random
+ 37 basis rays + 8 weight-2, both `p = 331` and `p = 661`) `[T2]`.
(iv) The first jump locus `{ρ ≤ 36}` is a proper closed subset of the
cell and contains `V \ {0}` by Euler; intersecting it with the landing
conditions cuts nothing. Further jumps `{ρ ≤ 35}` are Jacobian-criterion
cuts, not equations that every landing point must satisfy `[T1]`/`[T2]`.

**Not claimed.** See §8. No degree is excluded. No nonzero point of `V`
is produced. C6 on a genuine landing point remains deferred, for the
right reason.

---

## 1. Coordinates

`X = {F = 0} ⊂ P(W) = P⁴` with campaign cubic
`F = Σ_{k ∈ Z/5} y_k² y_{k+1}`. Source and target use the same five
linear coordinates on `W`. The sealed `d = 35` cell is the 37-dimensional
space of `G`-covariants remaining after the Layer-0 linear cuts and the
six flip conditions (`PAIR_ATTACK_D35`: `layer0_null_p*` and
`universal_matrix_6x39`, rank `U = 2`). A point `c ∈ A^{37}` determines
`T_c = Σ_α c_α B_α`, linear in `c`. The landing scheme is the cubic cone

```
V = { c : F(T_c) ≡ 0 as a form in x } ⊂ A^{37}.
```

The sealed span of landing cubics is `P3 = 1380` (full generator span;
this packet never subsets it, and does not run a landing Gröbner basis).

Gradient and Hessian of `F`, derived by hand and checked over `Z`
(`scripts/polar.py`, 121 identities, 0 failures):

```
∂F/∂y_k = 2 y_k y_{k+1} + y_{k-1}²
(H_F)_{k,k} = 2 y_{k+1},    (H_F)_{k,k+1} = (H_F)_{k+1,k} = 2 y_k
```

all other Hessian entries zero. Polarisation: `3 Φ(y,y,v) = ∇F(y)·v`,
`6 Φ(y,u,v) = uᵀ H_F(y) v`, `Φ(y,y,y) = F(y)`. Euler:
`∇F(y)·y = 3 F(y)`. At the origin of `W`: `F(0) = ∇F(0) = H_F(0) = 0`.

---

## 2. Tangent space and obstruction space at a point `c`

Write `T(ε) = T_c + ε T_s + ε² T_r` with `s, r ∈ k^{37}` (same linear
identification: deformations of `c` *are* points of the cell). Because
`F` is cubic,

```
F(T+εS+ε²R) = F(T)
  + ε     ∇F(T)·S
  + ε²  ( ∇F(T)·R + ½ Sᵀ H_F(T) S )
  + ε³  ( … )
```

**First order (25.1), campaign form.** `s` is tangent at `c` iff

```
A(c)(s) := Σ_k (2 T_{c,k} T_{c,k+1} + T_{c,k-1}²) T_{s,k}  ≡  0
```

as a form of degree `105`. Equivalently `3 Φ(T_c, T_c, T_s) ≡ 0`.

**Second order (25.2), campaign form.** A first-order `s` lifts through
`r` iff

```
Σ_k (2 T_{c,k+1} T_{s,k}² + 4 T_{c,k} T_{s,k} T_{s,k+1})
  + 2 Σ_k (2 T_{c,k} T_{c,k+1} + T_{c,k-1}²) T_{r,k}  ≡  0
```

Equivalently `Φ(T_c, T_s, T_s) + Φ(T_c, T_c, T_r) ≡ 0`. The primary
obstruction of `s` is the class of `½ T_sᵀ H_F(T_c) T_s` in
`coker A(c)`.

**Ranks as functions of the point.** Let `Φ_land : A^{37} → Sym^{105}`
be `c ↦ F(T_c)`. Then `A(c) = d(Φ_land)_c`, a `37`-column matrix of
quadratic forms in `c`.

```
ρ(c)        := rank A(c)
dim Tan(c)  := 37 − ρ(c)
dim Obs_P3(c) := 1380 − ρ(c)     (cokernel in the 1380-cubic presentation)
```

`Tan(c)` is the Zariski tangent space of the scheme `V(landing cubics)`
at `c` when `c ∈ V`. Two identities hold on the whole cell, not just on
`V`:

```
A(c) · c  =  3 F(T_c)          (Euler)
A(λc)     =  λ² A(c)           (A is quadratic)
```

Hence `ρ(λc) = ρ(c)` for `λ ≠ 0`, and `c ∈ V` implies `ρ(c) ≤ 36`.

C4 is the *source* derivative of `F(T(x)) = 0` (`∇F(T) · J_T ≡ 0`); C6
is the *coefficient* derivative above. They share the polar calculus of
`F` and are not the same map.

---

## 3. The origin is the cone vertex (why C6 was deferred for the right reason)

At `c = 0` one has `T_0 = 0`, so `∇F(T_0) = 0` and `H_F(T_0) = 0`.
Therefore `A(0) = 0` identically: **every** `s` satisfies (25.1), and
**every** `(s, r)` satisfies (25.2). The `λ`-expansion of
`F(T_{λs})` is `λ³ F(T_s)` — the first nonzero condition is third order
and is the landing cubic itself.

Machine, both primes (`results/origin_p{331,661}.json`): `ρ(0) = 0` and
the sampled matrix `A(0)` is the zero matrix. This is not a numerical
accident; it is `H_F(0) = ∇F(0) = 0`.

So the origin is uninformative for the reason C6 exists: it cannot
separate reduced isolated points from nonreduced phantoms from invariant
multiples from genuine families. It only restates that `V` is a cubic
cone. The record that “C6 needs a candidate point” is correct. The
record that the theory at the one available point was not written is
what this packet closes.

---

## 4. `ρ` as a function; the jump locus

`ρ(c)` is the rank of the `n × 37` matrix with rows
`∇F(T_c(x_q)) · T_{e_α}(x_q)` at sample points `x_q`. Sampling cannot
overestimate rank. Measuring `37` therefore *is* `rank d(Φ_land)_c = 37`.

| locus | `p = 331` | `p = 661` |
|---|:---:|:---:|
| origin | **0** | **0** |
| 12 random `c` | all **37** | all **37** |
| 37 basis rays | all **37** | all **37** |
| 8 weight-2 | all **37** | all **37** |
| Euler `A(c)c = 3F(T_c)` | holds | holds |
| `A(λc) = λ² A(c)` | holds | holds |
| (25.2) = polarisation | holds | holds |
| common kernel of 4 random `A(c)` | 0 | 0 |

Generic rank on the cell is therefore **37**: `Φ_land` is immersive at
every tested nonzero point. The first degeneracy locus

```
Z_{36} = { c : ρ(c) ≤ 36 }
```

is a proper closed subset of `A^{37}` (it misses the samples), cut by
the `37 × 37` minors of `A` (degree-74 polynomials, Jacobian ideal of
the landing cubics). Euler puts `V \ {0} ⊂ Z_{36}`. Intersecting the
landing conditions with `Z_{36}` therefore cuts nothing.

Whether `Z_{36} = V ∪ {0}` is not proved. Samples are consistent with
it (no off-`V` drop was seen). Either equality or a thin extension, the
intersection with `V` is `V`.

The next locus `Z_{35} = {ρ ≤ 35}` is the Jacobian-criterion /
singular-locus cut on `P(V)`. It is a proper closed condition on the
cell (generic rank 37). It is *not* implied by the landing cubics: it
does not vanish on all of `V` unless `P(V)` is everywhere non-smooth.
No nonzero point of `V` is known, so membership of `V` in `Z_{35}` is
not evaluated. That is the remaining right reason to defer C6 at a
genuine landing point.

---

## 5. What is new, and what is a restatement

**Restatement.** Audit (25.1)–(25.2); that `V` is a cubic cone; Euler
`A(c)c = 3 F(T_c)`; that the landing cubics are the coefficients of
`F(T_c)`; that C6 at a point of `V` distinguishes reduced / nonreduced /
content / deformable components (the purpose statement of C6, unused
here for lack of a point).

**New.** The gradient and Hessian of `F` in campaign coordinates, and
the ranks `ρ(c)`, `dim Tan(c)`, `dim Obs_P3(c)` as functions of `c`.
The origin computation and the precise reason it is vacuous (cone
vertex, not “theory missing”). The measurement `ρ = 37` generically,
two primes. The analysis that `Z_{36}` is a proper closed condition
which *contains* `V \ {0}` and therefore does **not** give equations on
the 37 parameters independent of the landing cubics in the sense that
would cut `V`; and that `Z_{35}` *would* be such an extra closed
condition, but only as an optional singular-locus intersection, not as
a constraint every landing point must satisfy.

**Verdict on the useful question.** Deformation theory does not produce
new equations that every point of `V` must satisfy, independent of the
landing cubics. The first jump is Euler’s restatement of landing. Later
jumps are diagnostic, not cutting.

---

## 6. Honesty

| tier | content |
|---|---|
| `[T1]` | Polar calculus of `F`; (25.1)–(25.2) in campaign coordinates; origin vacuity; Euler ⇒ `V \ {0} ⊂ Z_{36}`; homogeneity of `A`; the new/restatement split |
| `[T2]` | Cell `37 × 637`, `rank U = 2`; `ρ(0) = 0`; generic `ρ = 37`; Euler, homogeneity, and (25.2) on samples; both primes `331` and `661` |
| `[T3]` | Whether `Z_{36} = V ∪ {0}`; whether `V ⊂ Z_{35}`; C6 at a genuine landing point |
| `[EXT]` | Klein `F` and the 37-cell construction (sealed `PAIR_ATTACK_D35`); `P3 = 1380` (sealed `LANDING_INVARIANT_SIDE` / `CONE_LADDER_D35`); audit §25 as the source of (25.1)–(25.2) |

Zero / all-dead: this packet returns no zero count of a live census and
no all-dead outcome. The number `ρ(0) = 0` is a rank at the cone
vertex, not a census zero.

---

## 7. Flags

* **FLAG-1.** No nonzero `c ∈ V` is known. C6 at a landing point stays
  deferred. The origin is no longer a valid excuse for not writing the
  theory.
* **FLAG-2.** `Z_{36} =? V ∪ {0}` is consistent with samples and not
  proved. Not used as a substitute Gröbner basis for the landing cubics.
* **FLAG-3.** `dim Obs_P3(c) = 1380 − ρ(c)` is the cokernel in the
  sealed 1380-cubic *presentation*, not an intrinsic `T²`.

---

## 8. Not claimed

* **No headline.** Problem E remains **OPEN**. This packet **excludes no
  degree** and cuts **none** of the 22 live `d = 35` cells.
* Emptiness of `V`. Any characteristic-zero Nullstellensatz.
* Any nonzero landing point. Any evaluation of `ρ` on `V \ {0}`.
* That `Z_{36}` equals `V ∪ {0}`. That `V` is singular or smooth.
* Any exclusion from Jacobian rank of `T` (that is C5 / dominance, a
  different matrix).
* No git operation was performed and nothing outside this packet
  directory was written.

---

## 9. Verification

```
python3 verifier.py           # stored artefacts + polar replay
python3 verifier.py --live    # also rebuild the cell at p=331 and re-rank
```

Groups: `H` packet protocol; `A` polar identities (fatal gate); `B`
sealed cell / summary; `C` origin, generic rank, Euler, jump analysis;
`L` live (optional).

---

## 10. Dependencies consumed as sealed (read-only)

* `theory/CONSTRAINT_ADDITIONS_20260811.md` C6; audit §25.
* `goal_runs_20260811/PAIR_ATTACK_D35/results/` (`layer0_null_p*`,
  `universal_matrix_6x39`, seed tables `layer0_A/C_p331`).
* `goal_runs_20260811/D34_GUIDED_SWEEP/slicelib.py` (frame, Reynolds
  jets, rank).
* Sealed `P3 = 1380` cited from `LANDING_INVARIANT_SIDE` /
  `CONE_LADDER_D35`; not recomputed here.
