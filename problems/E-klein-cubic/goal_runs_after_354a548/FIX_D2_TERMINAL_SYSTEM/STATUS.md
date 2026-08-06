# FIX-D2 — the terminal system (D2″) and the rung-independence check (C2′)

**Packet:** `goal_runs_after_354a548/FIX_D2_TERMINAL_SYSTEM/`
**Program:** FIX ([E56]). **Named by:** `theory/FIX_IV_closure.md` §§5.24–5.27.
**Date:** 2026-08-06.
**Frame reused verbatim (not rebuilt from conventions):**
`goal_runs_after_9094303/FIX_L1_FRAME_CONSTANTS/` (α = 3(3+√33) = 12c, β = 1,
`ρ|_{W⁺}`, the four `V_m[twist]` generators, the isotypic pairings).
Conventions from `goal_runs_after_541e12f/FIX_H1_EQUALIZER/payloads/PAYLOAD_theorem.txt`.

## Primary exit

```text
FIX-D2-TERMINAL-SOLVABLE
```

with the mandatory secondary exit

```text
FIX-D2-CORRECTION-IV-f   (Theorem 5.25-A, the "Brutality Theorem", is FALSE
                          as stated; its inference step is invalid)
```

and

```text
FIX-C2PRIME-INDEPENDENT-AT-m=1 / FIX-C2PRIME-DEPENDENT-AT-m=3
FIX-D3-NOT-KILLED   (the image-in-line slot survives the corrected system)
```

**Problem E headline: OPEN.** These verdicts feed the DIRECTOR'S assembly of
Note IV Theorem 3.1; nothing here is a headline, and the full-chain audit is
still owed. This packet *removes* a step the chain was relying on.

---

## 0. One-paragraph summary

The `w ≠ 0` branch of [U1] is **not** killed by the terminal system. Theorem
5.25-A's total kill (`w ≠ 0 ⟹ Θ⁽⁰⁾ ≡ 0`) does not follow from `I₀`: the
substitution `y ↦ Ψ⁻¹y` produces the vanishing of the **diagonal contraction**
`κ_Ψ(Θ⁽⁰⁾)`, not of a quadratic form, because `Θ⁽⁰⁾` carries its own
`y`-argument (`y`-order `m+1`). `κ_Ψ` is surjective with a **4-dimensional
kernel** at `m = 1` (9 → 5) — verified twice, with an explicit basis — and
FIX-L1's own banked verdict (transfer solution space **1-dimensional**, not 0)
is an independent contradiction of the total kill. Everything §§5.25–5.27
built on that premise (the plus-deep reduction (C7), the departure recursion,
the `I^{(4)}` symbolic-power degree budget) loses its input hypothesis. What
survives, exactly and unchanged, is §5.26-A's κ-structure and §5.25-B's
count — they are correct, and they apply one level *earlier* than the note
places them, at `I₀` itself. (C2′) is then computed on the corrected
structure: the rungs are independent at `m = 1` and **dependent** at `m = 3`,
and in both cases the residual `Θ`-freedom **grows** with the rung index, so
the `I₀`-ladder can never exhaust the `Θ`-jet space.

---

## 1. Correction IV-f — Theorem 5.25-A is false as stated

### 1.1 The inference step, and where it slips

§5.25-A reads:

> at every point where `Ψ` is invertible the I₀-identity
> `Q(Θ⁽⁰⁾; Ψy, Ψy) = 0 ∀y` substitutes `y ↦ Ψ⁻¹y` to give `Q(Θ⁽⁰⁾; ·) ≡ 0`
> as a quadratic form — and `Q` is an ISOMORPHISM `W⁺ ≅ (Sym²W⁻)*`.

The final step is valid only if `Θ⁽⁰⁾` is a **constant** element of `W⁺`.
It is not. By §5.7's own bookkeeping `Θ⁽⁰⁾` has `y`-order `m+1`:

```
   Theta^(0)  in  Hom(Sym^{m+1} W-, W+)      (y-order m+1)
   Phi^(0)    in  Hom(Sym^m W-, W-)          (y-order m)
   I0 level   =   (m+1) + m + m  =  3m+1     <- section 5.7's own level count
```

So after the substitution the identity reads, with
`Θ′ := Θ⁽⁰⁾ ∘ Sym^{m+1}(Ψ⁻¹)`,

```
        Q( Theta'(y^{m+1}) ; y (x) y )  ==  0    for all y ,
```

which is the vanishing of the **degree-(3m+1) diagonal contraction**, i.e.
`κ(Θ′) = 0` — *exactly the same kind of object as §5.26-A's κ*, one level
down. It is emphatically not the vanishing of a quadratic form, and
`Q`'s isomorphy (which we re-verified: `det` of the Gram is `δ ≠ 0`) does not
apply to it.

### 1.2 The exact kernel — the refutation, computed twice

Define, for `Θ ∈ Hom(Sym^n W⁻, W⁺)` and `Ψ ∈ Hom(Sym^m W⁻, W⁻)`,

```
      kappa_Psi(Theta)(y) :=  Q( Theta(y) ; Psi(y) (x) Psi(y) )
                              in  Sym^{n+2m}(W-)* .
```

Exact ranks in the certified σ-frame (producer and independent verifier agree
on every entry):

| level | `n` | `m` | `Ψ` | source | target | rank | **kernel** |
|---|---|---|---|---|---|---|---|
| `I₀` `Θ⁽⁰⁾` | 2 | 1 | `V₁[triv] = id` | 9 | 5 | 5 | **4** |
| `I₀` `Θ⁽⁰⁾` | 2 | 1 | `V₁[sgn]` | 9 | 5 | 5 | **4** |
| `I₀` `Θ⁽⁰⁾` | 2 | 1 | generic | 9 | 5 | 5 | **4** |
| `I₁` `Θ⁽¹⁾` | 4 | 1 | any | 15 | 7 | 7 | 8 |
| `I₂` `Θ⁽²⁾` | 6 | 1 | any | 21 | 9 | 9 | 12 |
| `I₀` `Θ⁽⁰⁾` | 4 | 3 | `V₃[triv]` | 15 | 11 | **7** | **8** |
| `I₀` `Θ⁽⁰⁾` | 4 | 3 | `V₃[sgn]` | 15 | 11 | **7** | **8** |
| `I₀` `Θ⁽⁰⁾` | 4 | 3 | generic | 15 | 11 | 11 | 4 |
| `I₁` `Θ⁽¹⁾` | 6 | 3 | `V₃[*]` | 21 | 13 | 9 | 12 |

`w ≠ 0` makes `Ψ(c_σ) = w·id` invertible, so the relevant `m = 1` row is the
first: **the kernel is 4-dimensional, not 0.** An explicit basis (each element
re-verified to satisfy `κ_id(Θ) ≡ 0` identically) is printed in
`payloads/PAYLOAD_D2.txt` part D2 and stored in `payloads/d2_partD.json`.

### 1.3 The second, independent refutation: FIX-L1's own banked verdict

FIX-L1 computed the `S3`-equivariant transfer condition at `c_σ` and recorded
**solution dimension 1 in all four `(m, twist)` cases** ("NONVACUOUS (proper
hyperplane)"). We re-derived that table from scratch here:

```
   m=1 gamma=V1[triv] : dim Theta^{S3} = 2 , rank 1 , KERNEL 1   survivor != 0
   m=1 gamma=V1[sgn]  : dim Theta^{S3} = 2 , rank 1 , KERNEL 1   survivor != 0
   m=3 gamma=V3[triv] : dim Theta^{S3} = 3 , rank 2 , KERNEL 1   survivor != 0
   m=3 gamma=V3[sgn]  : dim Theta^{S3} = 3 , rank 2 , KERNEL 1   survivor != 0
```

Each survivor is exhibited explicitly and re-checked to satisfy the identity.
A nonzero `Θ⁽⁰⁾(c_σ)` therefore exists on the `w ≠ 0` branch. **`Θ⁽⁰⁾ ≡ 0` is
not forced.** §5.25-A directly contradicts §5.8's own FIX-L1-certified
verdict, which the note quotes two sections earlier.


### 1.6 Two objections a reviewer will raise, answered in advance

**"Maybe `Θ⁽⁰⁾` was meant as a fixed vector in `W⁺`."** No: §5.8 itself writes
`(θ_t, θ_s) := Θ⁽⁰⁾(c_σ) ∈ Hom(Sym²std, triv ⊕ std)^{S3}` — a Hom *from*
`Sym²`, i.e. `y`-dependent — and §5.7's level count `3m+1` only balances if
`Θ⁽⁰⁾` carries `y`-order `m+1`. Both of the note's own bookkeeping devices say
the `y`-argument is there.

**"The identity holds for every `w`; maybe `⋂_w ker κ_{Ψ(w)} = 0`."** That
intersection is the wrong object. `Θ⁽⁰⁾` is a *section*, not a constant: the
condition is `Θ⁽⁰⁾(w) ∈ ker κ_{Ψ(w)}` **for each `w` separately**, i.e. a
section of a rank-4 subbundle. It would only reduce to the intersection if
`Θ⁽⁰⁾` were `w`-independent, which it is not (it is a section of
`O(d−m−1) ⊗ Hom(Sym^{m+1}W⁻, W⁺)`). Whether that subbundle has global sections
of the right degree is precisely the (re-aimed) degree-budget question of §5.3.

### 1.4 What is NOT damaged

* **Thm 5.26-A is CORRECT and confirmed exactly.** `κ: (Sym⁴)*⊗(Sym²)* →
  (Sym⁶)*` has rank 7 = full target, kernel 8 = 5 + 3, matching
  Clebsch–Gordan `4 ⊗ 2 = 6 ⊕ 4 ⊕ 2`.
* **Thm 5.25-B's count is CORRECT** as a statement about the map ("I₁ kills
  exactly the 7-dimensional diagonal contraction of `Θ⁽¹⁾`, leaving 8") — only
  its hypothesis (`Θ⁽⁰⁾ ≡ 0`) is unavailable.
* **Thm 5.26-B is CORRECT and in fact more general than stated:** every level
  `I_k` introduces its new plus package through a surjective contraction with
  a computable kernel. The correction is that this is already true at `I₀`,
  which is precisely why `I₀` cannot kill `Θ⁽⁰⁾`.
* **Q's isomorphy `W⁺ ≅ (Sym²W⁻)*`** (the input the director asked to
  re-verify): **CONFIRMED**, `det` of the Gram matrix `= δ`, `δ² = −3 ≠ 0`,
  re-derived independently in the verifier.
* `α = 3(3+√33) = 12c ≠ 0`, `β = 1`, `kp`, `km`, `β_{c_σ}`, `ρ|_{W⁺}` — all
  re-derived here from `ρ|_{W⁻}` alone and matching FIX-L1 exactly.

### 1.5 Error class

Same class as Corrections IV-b/IV-c/IV-e: **an argument of a graded object
dropped at the moment of interpretation.** IV-b dropped a contribution at a
level; IV-c and IV-e dropped `(y,z)`-order/support; IV-f drops `Θ⁽⁰⁾`'s
`y`-argument. Sixth self-caught instance; the first one caught by a worker
rather than the director.

---

## 2. TASK A — the terminal system, corrected and assembled

### 2.1 The system actually in force

Conditions as briefed, with each one's current status:

| brief item | condition | status |
|---|---|---|
| (a) | order-0 equalizer `λ_{2e} = w·id` (`m=1`, `e` even) | **in force** (H1-1(b); `V₁[triv] = ⟨id⟩` re-derived here) |
| (b) | square-root pinning `w² = g_{4e}(c_σ)` | **VACUOUS** — Correction IV-e (`γ̃₀ = [x^r]u₀′ ≡ 0`); not computed, as directed |
| (c) | `I₀`'s leading jet `w²·[α θ_t κ_t + β⟨θ_s, κ_s⟩] = 0` | **in force, and it is exactly `κ_Ψ(Θ⁽⁰⁾) = 0`**; the bracket is a nonzero functional (rank 1 of 2 at `m=1`; rank 2 of 3 at `m=3`) — the briefed nondegeneracy question answered **YES, nonzero**, but it does **not** force `w = 0` |
| (d) | `g`'s jet re-expressed in the `θ`-variables | **VACUOUS** with (b) |
| (e) | `I₁`'s leading binding | **in force**, reduces to `κ_Ψ(Θ⁽¹⁾) = −(cross terms)`, a **surjective** 15 → 7 map; solvable for every right-hand side, kernel 8 |

### 2.2 Order accounting for (e) — the item the brief flagged for care

Both readings of the bookkeeping were carried; **they agree**, so no ambiguity
had to be reported.

*Reading 1 (`y`-grading, §5.7's own).* `I₁` sits at `y`-level `3m+3`. Its three
terms have `y`-orders
`2Q(Θ⁽⁰⁾;Φ⁽⁰⁾,Φ⁽¹⁾)`: `(m+1)+m+(m+2) = 3m+3`;
`Q(Θ⁽¹⁾;Φ⁽⁰⁾,Φ⁽⁰⁾)`: `(m+3)+m+m = 3m+3`;
`F₀(Θ⁽⁰⁾)`: `3(m+1) = 3m+3`. All three coincide — the level is exactly
`3m+3` and no term is missed. The **new** unknown at this level is `Θ⁽¹⁾`, and
it enters only through `κ_{Φ⁽⁰⁾}`, i.e. the 15 → 7 contraction.

*Reading 2 (`D`-divided / `x`-grading, §5.8's).* Dividing by `D^{2e}` shifts
every term by the same `2e` (`Φ⁽⁰⁾ = D^eΨ` appears exactly twice in each term,
and `F₀(Θ⁽⁰⁾)` carries no `Φ` — it is the term whose `D`-order is *not*
automatically `2e`). This is the only place the two readings could diverge:
`F₀(Θ⁽⁰⁾)` is cubic in `Θ⁽⁰⁾` and contributes to the divided identity only if
`ord_D F₀(Θ⁽⁰⁾) ≥ 2e`. Both branches were run:
 * if `ord_D Θ⁽⁰⁾ ≥ ⌈2e/3⌉`, `F₀(Θ⁽⁰⁾)` survives division and adds an
   inhomogeneity to the `Θ⁽¹⁾`-equation;
 * otherwise the divided `I₁` is homogeneous in `(Θ⁽¹⁾, Φ⁽¹⁾)`.
**Neither changes the verdict**, because the `Θ⁽¹⁾`-map is *surjective*
(rank 7 = full target): an arbitrary inhomogeneity is absorbable, with an
8-dimensional solution set either way. This is §5.26-B's mechanism, and it
is the reason the order-bookkeeping ambiguity is harmless here.

### 2.3 VERDICT (TASK A)

```text
FIX-D2-TERMINAL-SOLVABLE
```

**The system admits solutions with `w ≠ 0`, at every jet order computed.**
Exact solution locus, `m = 1` (branch (ii), `e = 6`, twist triv):

* `w ∈ C∖{0}` — free (it is only a scale; no condition pins it);
* `Θ⁽⁰⁾(c_σ)` — a **1-dimensional line** inside the 2-dimensional
  `Hom(Sym²W⁻,W⁺)^{S3}`; generator printed exactly in
  `payloads/d2_partD.json` (`survivor_m=1_V1[triv]`);
* `Θ⁽⁰⁾`'s higher jets at `c_σ` — residual dimensions
  **`1, 2, 4, 7`** at jet orders `0, 1, 2, 3` (see §3), i.e. the constraints
  never catch up with the unknowns;
* `Θ⁽¹⁾` — free in the **8-dimensional** kernel of the 15 → 7 contraction
  (`ker κ ≅ (Sym⁴)* ⊕ (Sym²)*`, §5.26-A's description, confirmed);
* `Φ⁽¹⁾` and all deeper minus data — unconstrained level-locally (§5.26-B);
* H1-1's order-1 condition `u_{2e+1} + v_{2e+1} = 0` — satisfiable: the
  allowed order-1 datum is `λ_{2e+1} ∈ ⟨diag(1,−1)⟩` (H1 §9), which is exactly
  the traceless diagonal, and imposes nothing on `w`.

At `m = 3` (branch (i), `e = 3`, twist sgn) the same conclusion holds with
`Θ⁽⁰⁾(c_σ)` on a 1-dimensional line in a 3-dimensional space and residual
jet freedoms `1, 4, 7`.

**Interpretation.** This is a *jet-level* candidate, not a map. Nothing here
produces a dominant `G`-equivariant `P(W) ⇢ X`; it says the negative
program's terminal system does not close by itself. The decisive question
returns to the global degree budget (§5), which is now a different budget from
the one §5.27 planned for (`I^{(2)}`-type with a rank-4 subbundle condition,
not `I^{(4)}`).

### 2.4 What `I₀` DOES force (the corrected replacement statement)

> **Corrected 5.25-A.** On the `w ≠ 0` branch, `I₀` forces, at every `w ∈ P_σ`
> where `Ψ(w)` is invertible (hence on a dense open set, hence everywhere by
> continuity), `Θ⁽⁰⁾(w) ∈ ker κ_{Ψ(w)}`, a **rank-4 subbundle** of the rank-9
> bundle `Hom(Sym²W⁻,W⁺) ⊗ O(d−m−1)`. Equivalently
> `Θ⁽⁰⁾ ∘ Sym²(Ψ⁻¹) ∈ ker κ_id ≅ (Sym²W⁻)* ⊕ C` (Clebsch–Gordan
> `2 ⊗ 2 = 4 ⊕ 2 ⊕ 0`, kernel `3 + 1 = 4`).

This is a genuine, strong, *first-order* condition — it is **not** a
vanishing statement and does **not** raise the order of `T⁺` along the plane.
In particular `T⁺` is **not** driven into `I^{(4)}`-type symbolic-power loci.

---

## 3. TASK B — (C2′), rung independence

### 3.1 Setup

Rungs are the `s`-graded pieces of the divided-`I₀` identity in the
`S3`-adapted affine chart at `c_σ` (`std = ⟨u₊, u₋⟩`, FIX-L1's basis):

```
   RUNG k :  R_k = sum_{i+j+l=k} Q( Theta_i ; Psi_j , Psi_l ) = 0
             in  C_k := ( Sym^k(std*) (x) Sym^{3m+1}(W-)* )^{S3, twist}
```

with `Ψ_0` the (1-dimensional, forced) `V_m[sgn^e]` generator and `Ψ_{≥1}`
generic equivariant jets. Rungs `k = 0,1,2,3` computed exactly (`k ≤ 2` at
`m = 3`).

### 3.2 Results

**`m = 1`, branch (ii) (`e = 6`, twist triv) — the main case:**

```
   jet order k                 0    1    2    3
   dim Theta-jet   J_k         2    3    5    6
   dim target      C_k         1    2    3    3
   rung rank (own target)      1    2    3    3     <- SURJECTIVE at every rung
   NEW conditions per rung     1    2    3    3
   surjectivity deficit        0    0    0    0
   overlap deficit             0    0    0    0
   stacked rank through k      1    3    6    9
   residual Theta freedom      1    2    4    7
```

```text
VERDICT  m=1 :  FIX-C2PRIME-INDEPENDENT
```

Every rung is surjective onto its own target and contributes its full rank as
new conditions; there are **no dependencies**. The same holds for the
sgn-twisted `Θ` control and the `e`-odd control, and — notably — also when the
higher `Ψ`-jets are set to zero (the degenerate control), so the independence
is not an artefact of genericity.

**`m = 3`, branch (i) (`e = 3`, twist sgn):**

```
   jet order k                 0    1    2
   dim Theta-jet   J_k         3    5    8
   dim target      C_k         2    4    6
   rung rank (own target)      2    3    6
   NEW conditions per rung     2    2    5
   surjectivity deficit        0    1    0
   overlap deficit             0    1    1
   stacked rank through k      2    4    9      (vs sum dim C_k = 2, 6, 12)
   residual Theta freedom      1    4    7
```

```text
VERDICT  m=3 :  FIX-C2PRIME-DEPENDENT   (exact pattern below)
```

**The exact dependency pattern.** Two distinct deficits, both located:

1. *Surjectivity deficit at rung 1 (1 of 4).* Rung 1's image is a proper
   3-dimensional subspace of the 4-dimensional `C_1`.
2. *Overlap deficits at rungs 1 and 2 (1 each).* One condition of rung 1 is a
   consequence of rung 0; likewise one of rung 2.

Total: through rung 2 the ladder delivers **9** independent conditions where
the naive count `Σ dim C_k` predicts **12** — a deficit of **3**.

### 3.3 The structural cause (new finding, exact)

```
        V_3[triv]  =  ( y^2 - ((5+nu)/6) z^2 ) . V_1[triv]
        V_3[sgn]   =  ( ((-5+nu)/6) y^2 + z^2 ) . V_1[sgn]
```

Both `m = 3` generators **factor**: an `S3`-semi-invariant binary quadratic
times the corresponding `m = 1` generator. Verified as exact identities in the
producer and re-derived independently in the verifier (the `V_m[twist]` spaces
are computed there from `ρ|_{W⁻}`, not posited).

Consequently the `m = 3` leading minus-datum that H1-1(b) **forces**
(`λ_{2e} ∈ V₃[sgn^e]`, a 1-dimensional space — there is no generic choice) is
degenerate: `Ψ_0 = h·(linear map)`, so `κ_{Ψ_0} = h² · κ_{V₁[*]}` and its rank
collapses from the generic 11 to **7**. That collapse is exactly what produces
the rung dependencies. It is forced by the representation theory, not by a bad
choice.

### 3.4 What this does and does not do to [L]

* It **does not** touch Theorem 5.15's budget: that argument counts zeros of a
  degree-`n` binary form across three points and is condition-count-agnostic
  (§5.15′ says so explicitly, and the statement survives).
* It **does** change §5.15′'s bookkeeping: at `m = 3` the rungs deliver fewer
  independent conditions than one per target dimension, so any argument that
  counted "one new condition per rung" must be re-indexed with the deficits
  above.
* **The load-bearing observation, common to both `m`:** the residual `Θ`-jet
  freedom **grows** (`1, 2, 4, 7` and `1, 4, 7`). `dim J_k` grows like
  `3(m+2)(k+1)/6` and `dim C_k` like `(3m+2)(k+1)/6`; the difference is
  positive and linear in `k`. **The `I₀`-ladder can never exhaust the
  `Θ`-jet space**, at either `m`, at any rung index. So (C2′) — even with its
  `m = 1` INDEPENDENT verdict — does not deliver a kill on its own; it only
  says the conditions it does impose are non-redundant.

---

## 4. The image-in-line stratum — the (D3) slot

`§5.24-C`'s one-line kill was already withdrawn by Correction IV-e; §5.25 asked
whether the corrected system re-kills it. **It does not.**

Run through the corrected system as a special case (`T⁺ ≡ 0`):

1. **Every plus-coupling is vacuous, and so is the landing identity.** With
   `T⁺ ≡ 0`, `F(T) = F₀(T⁺) + Q(T⁺; T⁻, T⁻) ≡ 0` *identically* — both terms
   carry a `T⁺` factor. There are no "minus-only landing levels" to appeal to:
   the image lies in `L_σ = P(W⁻) ⊂ X`, and `L_σ ⊂ X` is exactly why landing is
   automatic (FIN(7) §5.22 says the same).
2. **`I₀, I₁, I₂, …` are all vacuous** — every term of every level contains a
   `Θ`-factor.
3. **Only H1-1 survives, and it does not force `w = 0`.** The two conditions
   are `λ_{2e} ∈ V[sgn^e]` and `λ_{2e+1} ∈ Im(ev_{v₀})`. At `m = 1`, `e` even,
   `V₁[triv] = ⟨id⟩` (re-derived here) so the order-0 condition *is*
   `λ_{2e} = w·id`, satisfied for **any** `w` including `w ≠ 0`; the order-1
   condition is `λ_{2e+1} ∈ ⟨diag(1,−1)⟩` (H1 §9), i.e. traceless — again no
   constraint on `w`. From order 2 on H1 records "no condition".

```text
VERDICT (D3 slot):  FIX-D3-NOT-KILLED
```

The image-in-line leading data pass the corrected terminal system with
`w ≠ 0`. They are excluded from being *counterexample maps* only by
**non-dominance** (their image is a line), which is a different argument and
one that applies to the component, not to a germ/stalk datum whose deeper
layers may leave the line. Closing the slot therefore needs §5.27's departure
recursion or an equivalent — **and that recursion's premise (C7) is itself
conditioned on Theorem 5.25-A, which §1 refutes.**

---

## 5. (C7), the departure recursion, and the E15 degree budget — route status

### 5.1 (C7): premise withdrawn; run anyway as indicative evidence

§5.27's plus-deep reduction is derived **from** Theorem 5.25-A ("Brutality
forces every FIBER … plus-half has order ≥ 4 on all three planes"). With
§1's refutation the germ is *not* forced into the plus-deep sub-locus, so
(C7) is no longer route-deciding: whatever it returns, the `w ≠ 0` fibers need
not lie in the locus it describes.

The slice was nevertheless located and set up exactly, since it is cheap and
the answer is worth banking:

* system: `goal_runs_after_a90dbe1/FIX_N2C_R7_DECISION/m2/M_nf_one_B5.m2` —
  the C3-orbit-reduced form of the 52 raw coefficient equations, **18
  generators in 12 variables** `P0,P1,R0,R1,B0,B1,B2,B3,B4,B6,B7,B8` over
  `K = QQ(ω, kp)`, chart `B5 = 1`;
* the order-2 plus coefficients named by §5.27 are, in this packet's actual
  variables, **`P0` (order-2 part of `a′`) and `R0` (order-2 part of `b′`)**;
  `B0, B1` are the order-2 parts of `u₀′` and `B5, B8` are the *order-1*
  parameters (a different pair — not part of the plus-deep condition);
* the slice run here is `I + (P0, R0)`, in `m2/C7_nf.m2` (char 0) and
  `m2/C7_fp.m2` (`F_100057`), logs in `logs/C7_nf.log`, `logs/C7_fp.log`.

```text
(C7) RESULT:  NOT-DECIDED  (timeout)
```

Neither run produced output past its header: **~30 min** for the char-0
Gröbner basis over `K = QQ(ω, kp)`, **~4 min** before the mod-`p` run was
killed alongside it. Per the packet's own discipline a timeout is
NOT-DECIDED, and — because (C7)'s premise is withdrawn (§1) — **nothing in
this packet depends on it**. The setup is left in place and replayable; a
future attempt should budget FIN(7)-scale time (that packet's producer took
~64 min on the 39-variable non-equivariant system) and should run the
complementary charts, not just `B5 = 1`.

**Scope caveat, stated plainly.** The `B5 = 1` chart *excludes* the
image-in-line component `{a′ = b′ = 0, u₀′ = 0}` (which has `B5 = 0`), so a
chart-complete (C7) needs the complementary charts as well. This run is
therefore indicative, not a complete component census, and is reported as
such. The three dim-17 image-in-line components live in the **non-equivariant**
FIN(7) system (`goal_runs_after_9094303/FIX_U1_FIN7/`, 39 variables), not in
N2C's equivariant one; a chart-complete (C7) should be run there, at FIN(7)'s
cost (producer ≈ 64 min).

### 5.2 The departure recursion

Not verified: its stated entry condition is "(C7) returns image-in-line-only",
which in turn presumes the plus-deep reduction, which presumes 5.25-A. Recorded
as **blocked on Correction IV-f**, not as refuted — the self-similarity idea is
independent of 5.25-A and may well survive a corrected derivation.

### 5.3 The E15 symbolic-power degree budget (the designated fallback)

The fallback was to count `h⁰(I^{(k)}(d))` for the 55-plane arrangement in the
`I^{(4)}` regime. **That regime is not the one the corrected theory produces**
(§2.4: a rank-4 subbundle condition on the order-2 jet, not a deeper symbolic
power), so the count as specified would answer the wrong question. Recording
what is and is not banked, so the director can re-aim it:

**Banked and directly usable**
* `tmp/plane_arrangement_hilbert/REPORT.md` — exact `dim I(A)_d` for the
  *reduced* 55-plane ideal, `d = 0..18` (`I(A)_d = 0` for `d ≤ 14`;
  `42, 171, 412, 797` at `d = 15..18`), plus the incidence census.
* `HANDOFF.md` (≈1022–1031), duplicated in `RESOLUTION.md` and
  `CURRENT_PATHS.md`, and `tmp/covariant_arrangement_module/REPORT.md` — the
  `m = 1` global ladder `[(I^{(1)})_d ⊗ W]^G`, degrees 16–25:
  ```
  degree             16  17  18  19  20  21  22  23  24  25
  Molien dim         41  49  59  73  86 100 121 140 161 189
  restriction rank   41  47  56  66  75  84  96 106 117 130
  arrangement kernel  0   2   3   7  11  16  25  34  44  59
  ```
* `goal_runs_after_35fa/COV_M1_DEG31_35/STATUS.md` — the same ladder at
  `d = 31, 35`; `tmp/graded_symbolic_architecture/REPORT.md` — the
  `M₁ = I^{(1)}/I^{(3)}` discrepancy table `d = 18..35`.
* `tmp/local_symbolic_rees/REPORT.md` (+ independent audit) — the exact
  all-`m` LOCAL symbolic Rees theorem at the `D10`/`D12` points
  (`α(J_m) = 3m`, closed-form graded pieces).
* Arrangement data in char 0: `goal_runs_after_2880a28/FIX_A0_INVOLUTION_ARRANGEMENT/payload_involutions.json`
  (exact `Q(ζ₁₁)` bases of all 55 `W⁺_σ`/`W⁻_σ`).

**NOT banked (would have to be computed)**
* Any global `h⁰(I^{(k)}(d))` for `k ≥ 2` for the full 55-plane arrangement.
  Only local point/edge-model ranks at small transverse grades exist. The
  `I^{(11)}/I^{(13)}` numbers §5.26 alludes to are **local** `D12` tables
  (`tmp/fable_d12_bulk_correction_rank/`, `tmp/fable_d12_triangular_bulk_closure/`),
  not ambient Hilbert functions.
* There is **no** degree-55 arrangement hypersurface: each `P_σ` is a
  codimension-2 linear subspace of `P⁴`, so `I(A)` is an intersection of 55
  codim-2 ideals — the "product of 55 linear forms" the budget sketch assumes
  does not exist. Any `I^{(k)}` computation must saturate that intersection.
* `tmp/fable_second_gate_order12/`, the packet `WORKORDER_ORDER12.md` dispatches,
  was never produced.

**Honest cost note.** Computing global `h⁰(I^{(k)}(d))` for `k = 2, 3, 4` on a
55-plane codim-2 arrangement in `P⁴` over `Q(ζ₁₁)` is a saturation of a large
intersection; FIN(7)'s experience (M2 `gb`/`dim` not finishing on 17–21
variable slices, msolve not finishing 52 dense cubics in 20 variables) says
this should be budgeted as a real computation, not an afternoon. It is not
attempted here, and per the brief a timeout would be NOT-DECIDED anyway.

---

## 6. Cross-checks actually run

| check | route | result |
|---|---|---|
| frame regression | producer rebuilds FIX-L1's σ-frame constants and matrices verbatim; `F₀`, `Q` `ρ`/`τ`-invariance as polynomial identities; `c_σ` `S3`-fixed; `F₀(c_σ) = c³`; `α = 12c`; `α = 16kp − 4`; `β = 1` | **23 checks, 0 failures** |
| Q-isomorphy | Gram matrix of `Q : W⁺ → (Sym²W⁻)*`, `det = δ`, `δ² = −3` | **PASS (both scripts)** |
| independent frame derivation | verifier posits **only** `ρ|_{W⁻}`, `τ|_{W⁻}` and the normal-form `Q`; derives `ρ|_{W⁺}` from `ρ_+^T G ρ_S = G`, `c_σ` as the joint fixed vector, `(kp, km)` from `S3`-invariance of `F₀`, and all four `V_m[twist]` generators as isotypic lines | every closed form matches FIX-L1 exactly |
| independent field model | `K = Q[x]/(x⁴+2x³+25x²+24x+111)`, minimal polynomial of `θ = ω+ν`; `ω`, `ν` recovered inside `K`; extended-Euclid inversion | `ω²+ω+1 = 0`, `ν² = −11`, `δ² = −3`, `(√33)² = 33` all exact |
| independent algorithms | verifier expands every contraction as a **dense multivariate polynomial** in `(s₁,s₂,y,z)` (dict of exponent tuples); producer uses graded coefficient arrays | all ranks identical |
| contraction ranks | 9 rows of the `κ` table, `m ∈ {1,3}`, four generators + generic controls | **producer and verifier agree on every entry** |
| FIX-L1 transfer regression | equivariant `Θ`-space dims `2/2/3/3`, transfer ranks `1/1/2/2`, kernels `1/1/1/1` | **MATCH FIX-L1's banked table exactly** |
| survivor verification | each 1-dimensional kernel generator re-substituted into `κ_γ(Θ) ≡ 0` and confirmed nonzero | **PASS, all four cases, both scripts** |
| `V₃ = h · V₁` factorisation | exact division check in the producer; independent linear-solve in the verifier (generators derived, not posited) | **MATCH, both twists** |
| Clebsch–Gordan | `ker κ` dims `4 = 3+1` (`2⊗2`), `8 = 5+3` (`4⊗2`), `12 = 7+5` (`6⊗2`) | **PASS** |
| (C2′) rung ladder | four rungs at `m = 1`, three at `m = 3`; four control variants (sgn-`Θ`, opposite `e`-parity, degenerate `Ψ`-jets) | table in §3 |
| must-fail controls | producer 6, verifier 5 (`β := 0` `Q` must break invariance; `κ` must NOT be injective at `I₀` and `I₁`; `[1:1:0]` must not be `S3`-fixed; `id` must not lie in `V₁[sgn]`; `dim V₁[sgn] ≠ 2`; `dim Sym⁴(W⁻)*^{S3} ≠ 2`; `V₃[triv] ≠ h·V₁[sgn]`) | **11 controls, 0 harness failures** |

Totals: producer **23 + 6 = 29** asserted checks (0 failures), verifier
**68** asserted checks (0 failures). Exact arithmetic throughout; **no
floating point enters any decision** (none is used at all). No `git`
operations; nothing written outside this packet.

### Scope and limits, stated plainly

* Everything decided here is **level-local / jet-level** algebra at `c_σ`,
  in the certified σ-frame. No global existence statement is made or implied.
* `FIX-D2-TERMINAL-SOLVABLE` is **not** a counterexample and **not** a map:
  it says the terminal system does not close, not that a dominant equivariant
  map exists.
* The (C7) run in `logs/` is chart-restricted (`B5 = 1`) and therefore
  indicative only; see §5.1.
* These verdicts feed the **DIRECTOR'S** assembly of Note IV Theorem 3.1.
  **Problem E headline: OPEN**, regardless of outcome, pending the full-chain
  audit. Correction IV-f in particular means §§5.25–5.27 need re-derivation
  before any of them can be consumed.

---

## 7. Files

```
d2field.py                    exact field Q(om,nu), structure-constant model (producer only)
produce_d2.py                 producer: parts A (frame), B (contraction ranks),
                              C (equivariant restriction / L1 regression),
                              D (explicit kernel witnesses), E (must-fail controls)
produce_c2prime.py            (C2') the rung ladder, six cases
verify_d2.py                  INDEPENDENT verifier: own field (primitive element,
                              polynomial quotient), own frame derivation, own
                              algorithms (dense multivariate polynomials), own controls
m2/C7_nf.m2                   the (C7) plus-deep slice: N2C's 18-generator ideal + (P0, R0)
payloads/PAYLOAD_D2.txt       full producer log (parts A-E)
payloads/PAYLOAD_C2PRIME.txt  full (C2') log
payloads/PAYLOAD_VERIFY.txt   full verifier log
payloads/d2_partA..E.json     machine-readable: checks, ranks, kernels, witnesses
payloads/d2_c2prime.json      machine-readable: per-case rung tables
logs/C7_nf.log                the (C7) M2 run
REPLAY.md
```
