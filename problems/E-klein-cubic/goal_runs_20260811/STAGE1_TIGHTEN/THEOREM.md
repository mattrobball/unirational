# Stage 1, tightened: the degree-indexed boundary-pattern count, and saturation

**Packet:** `goal_runs_20260811/STAGE1_TIGHTEN/` · opened 2026-08-11.
**Headline: Problem E remains OPEN.** This packet contains no headline claim and
**excludes no degree** (see §2.5 for the one thing that looks like it might, and
why it is flagged rather than claimed).

Two deliverables, both building on `STAGE1_COMPLEX_MAPS` (branch
`agent/stage1-complex-maps-20260810`, PR #32) and `STAGE2_ODD_ORDER_PINNING`
(branch `agent/stage2-odd-order-pinning-20260810`):

1. **the residue-indexed count** — where the covariant degree `d` enters the
   order-0 `σ`-band, and the boundary-pattern count as a function of `d`;
2. **the saturation theorem** — `STAGE1` §15.6(1) flagged that the coherence
   tables were computed to a bounded multidegree with no proof of saturation.
   That is now a theorem with an explicit threshold **Θ = 6**, and the empirical
   stability at maxdeg 3–6 is a corollary.

*(Filename note: the main document is `THEOREM.md`; the harness refuses the
literal name `REPORT.md`.)*

## Exit ledger

```text
STAGE1-TIGHTEN-SATURATION-THEOREM
STAGE1-TIGHTEN-THRESHOLD-SIX
STAGE1-TIGHTEN-FULL-FLAG-DICHOTOMY
STAGE1-TIGHTEN-RESIDUE-TABLE
STAGE1-TIGHTEN-D10-ROW-SPLIT
STAGE1-TIGHTEN-NO-DEGREE-EXCLUSION-CLAIMED
```

Machine markers: `STAGE1_TIGHTEN_VERIFY_OK` / `ALLGREEN` (`python3 verifier.py`,
both primes).

---

## 0. What was consumed, and one correction to a tempting shortcut

`STAGE2_ODD_ORDER_PINNING` Lemma 0.1: `G = PSL(2,11)` is perfect, so a landing
covariant carries **no character twist** — `T ∈ (Sym^d W* ⊗ W)^G` exactly. The
tempting shortcut is to conclude that every Layer-2 component of `STAGE1` must
have `ψ = 1` (trivial character of `Γ = Stab_G(F_S)`) and multidegree summing to
`d`, which would index the whole `σ`-band by `d`.

> **That shortcut is wrong for 13 of the 15 sweep rows, and this packet does not
> take it.**

`STAGE1`'s parametrisation of a Layer-2 component by (multidegree `a` on the
positive-dimensional slots, linear character `ψ` of `Γ`) is correct *because* `ψ`
absorbs the degrees along the directions **transverse** to the stratum. The
leading datum of `T` along a stratum is a multigraded piece of `T` with respect
to a full grading of `W`; the stratum's own slots capture only part of it, and
the rest sits in transverse eigen-directions whose degrees contribute exactly a
character of `Γ`. Forcing `ψ = 1` is legitimate only when the slots **exhaust**
`W`.

> **Proposition 0.1 (the full-flag dichotomy).** Of the 15 sweep-capable rows of
> the terminus, exactly **two** have slot dimensions summing to 5:
>
> | row | slots | dims |
> |---|---|---|
> | `D_{P_σ}` (dim 3, `Stab = D12`) | `P(W⁺_σ) × P(W⁻_σ)` | `3 + 2` |
> | `D_{L⁻_σ}` (dim 3, `Stab = D12`) | `P(W⁻_σ) × P(W⁺_σ)` | `2 + 3` |
>
> For these two, and only these two, `G`-invariance of `T` forces `ψ = 1` and
> `Σ_r a_r = d`. (`verifier.py` D1.)

The two full-flag rows are exactly the two rows `STAGE1` Theorem 3 forces to
sweep and `STAGE1` §15.2 found to have **non-surjective** evaluation maps. The
degree enters the order-0 `σ`-band through them and through nothing else.

**Immediate confirmation that the model is the right one.** With `ψ = 1`:

* on `D_{P_σ}` the realized multidegrees are exactly those with the `W⁻`-slot
  degree **odd** — the sealed parity `H0-1` / `STAGE1` Thm 9(i), `m` odd;
* on `D_{L⁻_σ}` they are exactly those with the `W⁻`-slot degree `d − ν` odd,
  i.e. `ord_{L_σ}(T) ≡ d + 1 (mod 2)` — `STAGE2` Proposition 1.4(ii), which was
  *new* there and is here re-derived as a module-nonvanishing statement;
* the `D_{P_σ}` module is literally `STAGE1`'s Layer-3 module:
  `dim V((d−m, m), 1) = N(d,m)` for all `d ≤ 12` (`verifier.py` C2).

---

## 1. Saturation (deliverable 2)

Fix a sweep row `S`, `Γ = Stab_G(F_S)`, slots `V_0,…,V_k`, target `W⁻_σ`, and let
`q_1,…,q_N` be the (finitely many) child strata's coordinates, `Λ_j = Γ ∩ H_{R_j}`.
Write `V(a,ψ)` for the space of `Γ`-equivariant `W⁻_σ`-valued multiforms of
multidegree `a` and character `ψ`, and

```
   contribution(a,ψ) = { value tuples } = the single tuple pinned at the children
                       where the evaluation is non-zero, times the free choice at
                       the children where it vanishes ("degenerate").
```

> **Theorem S (saturation).**
> **(a) Periodicity.** By `STAGE1` Theorem 15.1 the value at each child is
> constant on `M_S(a,ψ)` and equals the `Λ_j`-eigenline of `W⁻_σ` of character
> `ψ^{-1}∏_r μ_{j,r}^{a_r}`; it therefore depends on `a` only through
> `a mod 6` (componentwise), since every `μ_{j,r}` has order dividing
> `exp(Λ_j) | 6`.
>
> **(b) Propagation.** For each slot `r` put `h_r = ∏_{γ∈Γ}(γ·ℓ_r)^{6/g_r}`,
> where `ℓ_r` is a linear form on `V_r` avoiding the finitely many points
> `γ^{-1}q_{j,r}`. Then `h_r` is **`Γ`-invariant** (the product is permuted by
> `Γ`), of multidegree `6·e_r`, and `h_r(q_j) ≠ 0` for every `j`. Hence
> `h_r · V(a,ψ) ⊆ V(a + 6e_r, ψ)` and both "`V ≠ 0`" and "the evaluation at
> child `j` is non-zero" **propagate** under `a ↦ a + 6e_r`.
> *Computed input:* the minimal degree `g_r` of such a `Γ`-invariant form
> **divides 6 for every slot of every one of the 15 sweep rows**
> (`g_r ∈ {1,2,3,6}`; `verifier.py` B1), so `6e_r` is always available and the
> step preserves the residue class mod 6.
>
> **(c) Monotone contribution.** Consequently, within a residue class mod 6 all
> components carry the **same** value vector, and their degeneracy sets are
> non-increasing along `+6e_r`. Since a degenerate child contributes a free
> choice, `contribution(a + 6e_r, ψ) ⊆ contribution(a, ψ)`. Therefore
>
> ```
>       Image( all multidegrees )  =  ⋃_ψ ⋃_{a ∈ Min(ψ)} contribution(a, ψ) ,
> ```
> where `Min(ψ)` is the set of coordinatewise-minimal elements of the realized
> set `R(ψ) = {a : V(a,ψ) ≠ 0}` under the order generated by the steps `6e_r`.
>
> **(d) Threshold.** `R(ψ)` **is** the up-set generated by `Min(ψ)` under those
> steps (finite exact check over the box `[0,17]` resp. `[0,11]`, both primes),
> each residue class mod 6 has exactly one minimal element, and every minimal
> element has all coordinates `≤ 6`. Hence
>
> > **Θ = 6: the image of the joint evaluation map over ALL multidegrees equals
> > the image over the box `{a : a_r ≤ 6}`.**

**Corollary S.1.** `STAGE1` §15.6(1) is discharged. The coherence tables there
were computed to maxdeg 4 (two-slot rows) / 6 (one-slot rows) and re-run at
maxdeg 5 and 6 with an unchanged total; Theorem S(d) says maxdeg 6 is already the
whole story. **The stratum-coherent count `1 088 847 395 778 723 840 000` is the
all-multidegree count, not a bounded-degree approximation.**

**Corollary S.2.** The empirical stabilisation observed there — image of
`D_{P_σ}` constant from maxdeg 3, of `D_{L⁻_σ}` from maxdeg 4 — is explained: by
(c) the low-degree components are the *most generous*, so the image is attained
early; (d) says nothing new can appear after 6.

*Spot check beyond the threshold:* the image of `D_{P_σ}` computed on the box
`a_r ≤ 8` equals the image on `a_r ≤ 6` (`verifier.py` B4).

**No obstruction to saturation exists.** The threshold is uniform and small
because `g_r | 6` in every slot — the invariant-theoretic reason is that each
slot is a `Γ`-module for a group of exponent dividing 6, so `Sym^6(V_r^*)^Γ`
already separates the children's coordinates from the coordinate hyperplanes.

---

## 2. The residue-indexed count (deliverable 1)

### 2.1 Where `d` enters

By Proposition 0.1 the covariant degree constrains the order-0 `σ`-band exactly
through the two full-flag divisors: their available component classes at degree
`d` are the realized classes `ρ ∈ (Z/6)²` with `Σ_r ρ_r ≡ d (mod 6)`. Each of the
two rows has 18 realized classes (half of 36 — the parity), and after dropping
the classes whose evaluations fall outside the arc-consistent domains, exactly
**3 usable classes per residue** remain for each (`verifier.py` D3). Everything
else in the band keeps its `STAGE1` table, because forcing `ψ = 1` there would be
the error of §0.

### 2.2 The `σ`-band factor, per residue

Running `STAGE1`'s coherent enumeration with the two degree-restricted tables:

| `d mod 6` | `σ`-band factor `K(d)` | coherent total with `STAGE1`'s immune factor |
|---:|---:|---:|
| `0` | **10 752** | `272 211 848 944 680 960 000` |
| `2` | **672** | `17 013 240 559 042 560 000` |
| `4` | **672** | `17 013 240 559 042 560 000` |
| `1, 3, 5` | **0** — see §2.5 | `0` |

(`K(d) = total / (23 · 6⁸·4¹⁰·5⁴)`.) Degree-blind, `STAGE1` had `K = 43 008`;
so knowing `d mod 6` divides the `σ`-band freedom by **4** (`d ≡ 0`) or **64**
(`d ≡ 2, 4`).

### 2.3 The `D10` row: 23 → 13 or 10 (new)

`STAGE1`'s only coherence-immune positive-dimensional row is the `C2`-line in the
exceptional `P³` over a `D10`-point (dim 1, 330 components, `Stab_G = C2`), with
23 values. Applying `STAGE2` Theorem 1.2 with `g = τ` (the `D10`-involution)
splits them by the `τ`-weight `w = d·a_k + μ₁ (mod 2)` of the value:

| `w` | where the value lies | # values |
|---|---|---:|
| `0` | `P(W⁺_τ) ∩ X = E_τ` — the generic point of `E_τ`, the 3 type-I vertices on `E_τ`, the 9 type-II points | **13** |
| `1` | `P(W⁻_τ) = L_τ` — sweeping `L_τ`, the generic point of `L_τ`, the 6 type-I vertices on `L_τ`, the 2 `X^{C6}` points | **10** |

> **Proposition 2.1.** For a *fixed* map the `D10` row has at most **13** values,
> never 23: the parity of `d·a_k + μ₁` selects one branch. Both branches occur
> for every `d` (`μ₁` is a free invariant of the map), so this is a
> per-map refinement, not a per-residue one.

This is the first constraint of any kind on that row — `STAGE1` §15.5 recorded it
as untouchable at order 0, and it is untouchable by *coherence*; the weight
congruence reaches it.

### 2.4 The table, `d mod 330`

`330 = lcm(165, 2)`. Combining §2.2, §2.3 and `STAGE2`'s odd-order collapse
(`6⁸·4¹⁰·5⁴ = 1 100 753 141 760 000 → 3⁸ = 6 561`, all residues):

```
   count(d)  =  K(d mod 6)  ×  D10(d, μ₁)  ×  3⁸ ,      D10 ∈ {13, 10}
```

| `d mod 6` | `K` | `E`-branch total | `L`-branch total |
|---:|---:|---:|---:|
| `0` | 10 752 | **917 070 336** | 705 438 720 |
| `2` | 672 | **57 316 896** | 44 089 920 |
| `4` | 672 | **57 316 896** | 44 089 920 |
| `1, 3, 5` | 0 (flagged) | — | — |

For comparison: `STAGE1` alone gave `1 088 847 395 778 723 840 000`;
`STAGE1 × STAGE2` (degree-blind) gives `43 008 · 23 · 3⁸ = 6 490 036 224`. The
degree input tightens that by a further factor **7** (`d ≡ 0 mod 6`) or **113**
(`d ≡ 2, 4 mod 6`).

**Refinements from `d mod 5`, `d mod 11`, `d mod 3` are already inside the `3⁸`.**
`STAGE2` §4 shows the `C11` block collapses to a single pattern for every
`d mod 11` (only the *number of rows at which `T` is defined* varies: 4 / 3 / 2
according as `d` is a QR, a non-residue, or `0`), the `C5` block to a single
pattern for every `d mod 5`, and the eight `C3`-rows to three values each for
every `d mod 3`. So the odd-order factor is `3⁸` uniformly, and the residue
dependence of the total is carried entirely by `d mod 6`.

The `d`-dependence that `STAGE2` records but that does **not** change the count —
`X^{C6} ⊆ Bs(T)` unless `d ≡ ±1 (mod 6)`, all 55 minus-lines in `Bs(T)` for even
`d`, `m ≡ d (mod 3)` for a non-degenerate `C6`-band — is subsumed: those are
statements about which *source* strata are blown up and to what order, and in
this packet they are the multidegree bookkeeping `Σ_r a_r = d` on the two
full-flag rows.

### 2.5 The odd residues: FLAGGED, NOT CLAIMED

The enumeration returns **0** for `d ≡ 1, 3, 5 (mod 6)`. Taken at face value that
would exclude every odd degree at order 0 — a headline-adjacent claim. **It is
not claimed here.** What is established:

* each degree constraint **alone** is consistent at every residue: restricting
  only `D_{P_σ}` gives `6.8 × 10¹⁹` patterns at every odd residue, and
  restricting only `D_{L⁻_σ}` gives `1.4 × 10²⁰` (`verifier.py` E4). The zero is
  a **joint** effect, propagated through the eight `V4`-stabilised `C2`-rows
  whose two children lie one under each divisor;
* the model is verified where it can be: the modules agree with the sealed
  Layer-3 table `N(d,m)`, the character rule agrees with explicit evaluation in
  1176 cases, and the parities it produces are the two sealed ones (§0);
* it is reproduced identically at `p = 331` and `p = 661`.

Reasons to withhold the claim, all of which need an adversarial audit this packet
did not run:

1. `d = 25` (odd) was treated as a **live** window by sealed packets until an
   independent slice sweep (`FIX-P1-WINDOW-25-EMPTY`) killed it. If odd degrees
   died at order 0, that sweep was doing work that a congruence already did — and
   nothing in the record noticed.
2. `STAGE2` Theorem 4.1 states, and machine-verifies, that its congruence system
   is consistent for **every** residue mod 165 and mod 330. That is a statement
   about the odd-order rows only, so there is no formal contradiction — but it is
   the nearest sealed statement and it points the other way.
3. The zero depends on the arc-consistent domains of the two rows `STAGE1`
   Theorem 5 pins uniquely (the `V4`-rows over the `D12`-points inside `P_σ`);
   an error in that pinning, or in the transversal bookkeeping between the two
   divisors' frames, would produce exactly this signature.
4. The `contribution` filter discards a component class whose evaluation leaves a
   child's arc-consistent domain. That filter is what makes the odd residues
   empty. It is legitimate (such a component cannot be the restriction of a
   global section) but it is doing all the work, and it has not been checked
   against an independently-built model of the two divisors.

**Recommended next computation** (not run here): rebuild `D_{P_σ}` and
`D_{L⁻_σ}` and their children from scratch in explicit `σ`-adapted coordinates,
without reusing `STAGE1`'s component indexing, and re-derive the odd-`d`
verdict. If it survives that, it is a genuine order-0 exclusion of all odd
degrees and deserves its own packet.

Until then the honest reading of §2.4 is: **the even residues are tightened as
tabulated; the odd residues are unresolved.**

---

## 3. Verification

```sh
python3 verifier.py          # both primes
```

Check groups: **A** census (1), **B** saturation — invariant degrees, the up-set
property, the threshold `Θ = 6`, and the box-8 spot check (4), **C** the
character rule against explicit evaluation and against the sealed Layer-3 module
(2), **D** the full-flag dichotomy and the two sealed parities re-derived (3),
**E** the residue table and the joint-vs-single diagnosis (4), **F** the `D10`
split (1), **G** the `STAGE2` carry-in arithmetic (4), **H** cross-prime (1).

Everything is replayed at `p = 331` and `p = 661`; the character arithmetic of
Theorem S(a) and of the value rule is exact (finite group characters in `μ_6`),
and the module dimensions are cross-checked against the exact `Z[ζ₆]` values of
`STAGE1` Layer 3.

---

## 4. Honesty tiering

**Tier 1 — exact, prime-free.** Proposition 0.1 (a dimension count on the flag).
Theorem S(a) (`STAGE1` Thm 15.1). Theorem S(b) — the invariance of
`∏_{γ∈Γ}(γ·ℓ_r)` and the propagation are formal; only the *value* of `g_r` is
computed. Theorem S(c). Proposition 2.1's dichotomy (`STAGE2` Thm 1.2 at `g = τ`
plus the sealed incidence "`E_t` carries 3 type-I + 9 type-II, `L_t` carries 6
type-I + 0 type-II").

**Tier 2 — finite exact computation at two split primes.** `g_r | 6` for all 27
slots; the up-set property and `Θ = 6`; the 3-usable-classes-per-residue count;
the `σ`-band factors `K(0) = 10 752`, `K(2) = K(4) = 672`; the `13 + 10` split;
the agreement of the character rule with explicit evaluation.

**Tier 3 — flagged.**

1. **The odd residues (§2.5).** Reproduced, not claimed. This is the single most
   important caveat in the packet.
2. The residue table inherits `STAGE1`'s component indexing and arc-consistent
   domains; it is a *tightening* of that enumeration, not an independent one.
3. `STAGE2`'s `3⁸` is consumed, not re-derived. Its own Tier 3(3) — that the
   factor 3 per `C3`-row is structural, not an artefact — is inherited.
4. Theorem S(d)'s finite check is over the boxes `[0,17]²` and `[0,11]³`; the
   up-set property is what makes that finite check decisive, and it is verified
   rather than proved a priori.
5. `μ₁` in Proposition 2.1 is an invariant of the hypothetical map. "Both
   branches occur for every `d`" is a statement about the arithmetic.

## 5. Not claimed

* No headline. Problem E remains OPEN.
* **No degree is excluded.** In particular the odd residues of §2.5 are *not*
  offered as an exclusion.
* No statement that a landing covariant exists at any degree.
* No re-derivation of `STAGE2`'s odd-order pinning or of the sealed sweeps.
* Nothing about jets beyond the multidegree bookkeeping of the leading data.

## 6. Dependencies

| import | used for | grade |
|---|---|---|
| `STAGE1_COMPLEX_MAPS` (`agent/stage1-complex-maps-20260810`) | the census, the coherence tables, Thm 15.1, the Layer-3 module `N(d,m)` | machinery re-used verbatim; §15.6(1) **discharged** by Theorem S |
| `STAGE2_ODD_ORDER_PINNING` (`agent/stage2-odd-order-pinning-20260810`) | Lemma 0.1 (no character twist), Thm 1.2 (the weight formula), the `3⁸` collapse, Props 1.3/1.4, Cor 1.5, Prop 3.1 | Lemma 0.1 and Thm 1.2 consumed and applied; Prop 1.4(ii) and H0-1 **re-derived** as module-nonvanishing (§0) |
| `TERMINUS_STRATA_PW`, `RECEIVER_LEDGER_X` | source census, target ledger | reached through `STAGE1`, which rebuilt the census independently |
