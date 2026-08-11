# Adversarial audit of the odd-residue zero (`STAGE1_TIGHTEN` §2.5)

**Packet:** `goal_runs_20260811/ODDZERO_AUDIT/` · opened 2026-08-11.
**Headline: Problem E remains OPEN.** This packet excludes no degree and
un-excludes none: it audits a finding that was flagged, not claimed.

> # VERDICT: **ODD-ZERO-ARTIFACT**
>
> `STAGE1_TIGHTEN`'s `K(1) = K(3) = K(5) = 0` is **not** an order-0 exclusion of
> odd degrees. The zero is produced by one unsound step, located below. Its
> author was right to withhold the claim.

*(Filename note: the main document is `THEOREM.md`; the harness refuses the
literal name `REPORT.md`.)*

## Exit ledger

```text
ODDZERO-AUDIT-VERDICT-ARTIFACT
ODDZERO-AUDIT-MECHANISM-REPRODUCED
ODDZERO-AUDIT-DEGENERACY-SEMANTICS-ERROR
ODDZERO-AUDIT-ESCAPE-WITNESS
ODDZERO-AUDIT-PSI-MODEL-SOUND
ODDZERO-AUDIT-ANCHORS-REPRODUCED
ODDZERO-AUDIT-NO-DEGREE-EXCLUSION
ODDZERO-AUDIT-STAGE1-COHERENCE-UNDERCOUNTS
```

Machine markers: `ODDZERO_AUDIT_VERIFY_OK` / `ALLGREEN`
(`python3 verifier.py` — **52 checks, 0 failures**, 26 per prime at
`p = 331, 661`).

---

## 0. The verdict in one paragraph

The two dimension-3 divisor rows are the only rows where the covariant degree
enters the order-0 `σ`-band; `STAGE1_TIGHTEN`'s model of them (`ψ = 1`,
`Σ_r a_r = d`, minus-slot degree odd) is **correct**, and this packet re-derives
it from scratch. Running that model, the *generic* section of the `D_{P_σ}`
module evaluates six of its children — the `V4`-strata over the type-I points of
`P(W⁺_σ)` — to the type-I vertex that closure forbids **exactly when `d` is
odd**. That is the whole of the zero, and it reproduces here at both primes.
But Theorem 15.1 has two branches, and the second one is a property of the
individual section, not of the whole module: the sections that **vanish** at
those six points form a subspace of codimension exactly 2, every non-zero member
of it is still a dominant sweep, and for such a section the value of the stratum
is set by the next term of the expansion — whose character is multiplied by
`χ_B`, delivering **precisely the vertex closure demands**. The enumeration
tests degeneracy by the rank of the evaluated *module basis*, so it never sees
those sections and discards every class at every odd residue.

---

## 1. What was rebuilt, independently

Nothing below imports `STAGE1_COMPLEX_MAPS` or `STAGE1_TIGHTEN` code. The only
shared input is the raw 660-element matrix group (`scripts/psl211.py`,
byte-identical to the repository model), as the brief permits.

* **`σ`-adapted coordinates.** `W = W⁺_σ ⊕ W⁻_σ` with explicit bases
  `(u₀,u₁,u₂ | v₀,v₁)`; `Γ = C_G(σ)` of order 12 is block diagonal in that frame
  (A2, A3). The modules are then plain polynomial linear algebra over `F_p`:
  `V(a,b,ψ) = {f ∈ Sym^a(W⁺*) ⊗ Sym^b(W⁻*) ⊗ W⁻ : f(A_γu, B_γv) = ψ(γ)B_γ f(u,v)}`.
  Every computed section is checked against that identity directly, for every
  `γ ∈ Γ` (B1) — a test the dimension count alone cannot pass (an early draft of
  this packet had the substitution transposed; the dimensions were still right,
  the evaluations were not).
* **The census.** The stabilized-strata complex of the terminus is rebuilt as
  *interleaved flags* `0 ⊆ A₀ ⊆ U₁ ⊆ A₁ ⊆ … ⊆ A_k ⊆ W` — a different
  parametrisation from `STAGE1`'s (chain, then eigen-datum per abelian
  subgroup). It returns 940/220/55, 4901 flags, **11 076 components in 80 rows**,
  with the row multiset `(H, dim, #comp, Stab_G)` **equal to the sealed
  `TERMINUS_STRATA_PW` census** (C1, C4).
* **The `σ`-band poset.** 54 components below one `D_{P_σ}`, 18 below one
  `D_{L⁻_σ}` — exactly `STAGE1` §15.2's "20 rows / 54 comps" and
  "7 rows / 18 comps" (C2).

**Anchors demanded by the brief, all reproduced** (§7 for the rest):

| anchor | status |
|---|---|
| H0-1 parity: `m = ord_{P_σ}(T⁻)` odd | **PASS** (B2) — `dim V((d−m,m),1) = 0` for every even `m ≤ d ≤ 12` |
| sealed Layer-3 table `N(d,m)` | **PASS** (B3, B4) — every value for `d ≤ 12`, including `N(12,3) = 73`, from coordinates |
| `STAGE2` Prop 1.4(ii): `ord_{L_σ}(T) ≡ d+1 (mod 2)` | **PASS** (B5) — re-derived as non-vanishing of the `D_{L⁻_σ}` module |
| the sealed `d = 34` closure | **PASS, and independent** — see §7 |

---

## 2. The `ψ` question (audit item 2): the model is sound, and errs the safe way

A stratum's leading datum is the multigraded piece of `T` for the full grading of
`W` that its flag induces. Slots of projective dimension 0 and the directions
transverse to the stratum are 1-dimensional pieces, so their degrees enter only
as a linear character of `Γ`. Hence:

> **Proposition A (re-derivation of `STAGE1_TIGHTEN` Prop 0.1).** The slot
> spaces exhaust `W` exactly on `D_{P_σ} = P(W⁺_σ) × P(W⁻_σ)` (dims 3+2) and
> `D_{L⁻_σ} = P(W⁻_σ) × P(W/W⁻_σ)` (dims 2+3). For those two rows there are no
> transverse directions, so `G`-invariance of `T` (`G` perfect ⟹ no character
> twist) forces `ψ = 1` and `Σ_r a_r = d`. For every other row the transverse
> degrees are real and `ψ` is genuinely twisted.

**And the direction of the residual error matters.** On the other 13 rows the
truth is *narrower* than the model: with 1-dimensional transverse pieces of
characters `χ_1,…,χ_s`, the achievable `ψ` at degree `d` and slot degree `a` is
`{∏χ_i^{b_i} : Σb_i = d − Σa}`, a proper subset of the four characters of `D12`
in general. `STAGE1_TIGHTEN` allows all of them and drops `Σa ≤ d`. So its model
of those rows is a **relaxation**.

> A relaxation can only over-count. **An error in the `ψ` model therefore cannot
> manufacture a zero.** §2.5's concern 2 — "an error in either direction here is
> the most likely artifact source" — is resolved: it is not the source.

---

## 3. The mechanism of the zero, reproduced exactly

Fix an involution `z` and a Klein four-group `K = {1,z,s,r} ⊆ C_G(z)`. Write
`W = A ⊕ B ⊕ C ⊕ D` for the `K`-character decomposition (`A = ℓ_V`, dim 2,
trivial; `B, C, D` of dim 1). Then

```
   W⁺_z = A ⊕ B ,  W⁻_z = C ⊕ D ;   W⁻_s = B ⊕ D ,   W⁻_r = B ⊕ C .
```

`[B]` is a type-I `V4`-point of `P(W)` lying **in the plus-plane** `P(W⁺_z)`.

**Step 1 — the two divisor rows share no child.** No minus-line lies in any
plus-plane (C3), so no component of the census has both a plus-plane and a
minus-line in its chain. The coupling `STAGE1_TIGHTEN` §2.5 attributes to "the
eight `V4`-stabilised `C2`-rows" is therefore genuinely two-step, and it is
local to the exceptional divisor over `[B]`:

| component over `[B]` | what it is | divisor above it | `C2`-row above it |
|---|---|---|---|
| `R_C` | `V4`, dim 1, chain `([B], W⁺_z)`, last slot `D` | `D_{P_z}` | the `C2`-surface sweeping `L_r` |
| `R_D` | `V4`, dim 1, chain `([B], W⁺_z)`, last slot `C` | `D_{P_z}` | the `C2`-surface sweeping `L_s` |
| two more | `V4`, chain `([B], W⁻_s)` | `D_{L⁻_s}` | the same two |
| two more | `V4`, chain `([B], W⁻_r)` | `D_{L⁻_r}` | the `C2`-curve sweeping `L_z` |

**Step 2 — closure pins the vertex, on both branches.** The `C2`-surface above
`R_C` either sweeps `L_r` or contracts.

* *It sweeps.* Then `R_C` lies under `D_{P_z}` (image `L_z`) and under it (image
  `L_r`), so its value is `L_z ∩ L_r = [C]`; symmetrically `R_D` is `[D]`. Pure
  closure monotonicity — it survives on every model, degenerate or not (D1).
* *It contracts* to a point `v`. Then `v` is also the value of its other
  `V4`-child, which lies under `D_{L⁻_s}` and so has value in `L_s`; and
  `v = value(R_C) ∈ L_z`. So `v ∈ L_z ∩ L_s = [D]`, forcing `value(R_C) = [D]`
  and `value` of that other child `= [D]` — while `D_{L⁻_s}` evaluates it to
  `[B]` at every degree. The clash simply moves to the other divisor.

Both branches therefore end in a clash at odd `d` under the enumeration's
semantics; that is why the zero is total.

*(The two `V4`-points over `[B]` that sit under `D_{L⁻_s}` and `D_{L⁻_r}` with a
one-dimensional last slot also show a parity flip in `results/local_system_331.txt`,
but they need no repair: at odd `d` the `C2`-curve above them contracts to `[B]`,
which is exactly what those divisors evaluate. Only the `D_{P_σ}` side needs the
argument of §5 — as `STAGE1_TIGHTEN` §2.5 predicted when it said that row is
"doing all the work".)*

**Step 3 — the evaluation.** On `D_{P_z}` the class is `(a, b) = (d−m, m)`, `m`
odd, `ψ = 1`; `R_C` attaches at the point `([B],[D])`, where `Λ = K` acts by
`μ₀ = χ_B` on the first coordinate and `μ₁ = χ_D` on the second. Theorem 15.1
gives the value as the `K`-eigenline of character

```
        χ = χ_B^a · χ_D^b = χ_B^a · χ_D          (b = m odd) .
```

Since `χ_Bχ_D = χ_C`, this is `[D]` for `a` even and `[C]` for `a` odd — and
`a = d − m ≡ d − 1 (mod 2)`. **So the generic section gives the required `[C]`
when `d` is even and the forbidden `[D]` when `d` is odd.** Machine-verified
against explicit sections at every available class, both primes: 0 agreements
and 120 clashes at odd `d`, 90 agreements and 0 clashes at even `d` (E1, E2).

That is the entire zero. Everything else in the `σ`-band that depends on `d`
depends on it only through `d mod 3` (the `C6`-children), and `m mod 3` is free.

---

## 4. The error (audit item 6): file, line, formula

`STAGE1_TIGHTEN` `scripts/s3residue.py:55` drops a class whose contribution
leaves a child's arc-consistent domain:

```python
c = contribution(S, a, E)
if c is None or any(v not in E.dom[r0] for r0, v in c.items()):
    continue
```

That filter is legitimate. The unsound step is one level down, in how
`contribution` decides that a child is **degenerate** —
`scripts/s3sat.py:72-78`:

```python
nV, ev = S.explicit(a, psi)
for kid in S.kids:
    rk, w = ev[kid["idx"]]
    if rk == 0:          # <-- degenerate
        continue
    assert rk == 1
```

and `scripts/s3sweep.py:271-276`, where `rk` is computed:

```python
V = nullspace(p, rows, n)                     # a BASIS of the whole module
for kid in self.kids:
    q  = [kid["qs"][i][0] for i in range(self.nslot)]
    ev = [self._eval(basis, v, q) for v in V]
    out[kid["idx"]] = (rank2(p, ev), ...)     # <-- rank over the whole basis
```

(the same test upstream at `STAGE1_COMPLEX_MAPS/scripts/s1coherence.py:293-296`).

> **The error.** `rk == 0` says *the whole module vanishes at `q`*. Theorem
> 15.1's second branch — "or `s(q) = 0`, in which case `φ` is undefined along
> `R`" — is a statement about the **individual section `s`**. The locus
> `{s ∈ V(a,ψ) : s(q) = 0}` is a linear subspace of codimension 1 (the value is
> confined to a line, so it is one condition), sitting inside the *same*
> connected component of the moduli. `rk == 1` therefore reports "pinned to this
> vertex" for a component in which a positive-dimensional family of sections is
> not pinned to it at all.

---

## 5. The refutation

Let `V₀ = { f ∈ V((d−m, m), 1) : f(q) = 0 at all six attaching points }`.

> **Proposition B (the escape).** For every odd `d` and every odd `m` with
> `N(d,m) ≥ 3`:
>
> **(i)** the six vanishing conditions have rank exactly **2**, so
> `dim V₀ = N(d,m) − 2 ≥ 1` (F1);
> **(ii)** every non-zero `f ∈ V₀` is still a **dominant** sweep of `L_σ`,
> because `W⁻_σ` is `Γ`-irreducible and hence has no `Γ`-stable line, so no
> non-zero equivariant multiform can be constant (A5, F5);
> **(iii)** the value of `R_C` for such an `f` is the coefficient of `t¹` in
> `f(B + tα, D)`, `α ∈ ℓ_V`, and equivariance forces the `t^k` coefficient to be
> a `K`-eigenvector of character `χ_B^{a+k}·χ_D`. With `a` even (`d` odd),
> `k = 0` gives `χ_D` (forbidden) and `k = 1` gives `χ_Bχ_D = χ_C` — **exactly
> the vertex closure demands** (F3, F4);
> **(iv)** the switch really is the leading datum of `T`, not an artifact of
> working inside the divisor. Near `R_C` write `w = B + t₁α + t₁t₂·D`, so that
> `{t₁ = 0} = E_{[B]}` and `{t₂ = 0} = D_{P_z}`. Then `T⁻_j(w)` contributes
> `t₁^{j+k} t₂^{j}` with `j ≥ m` (and `j` odd, by the sealed parity theorem),
> while `T⁺_j` contributes the same pattern with `j ≥ m⁺`, where `m⁺` is even
> (parity theorem) and `m⁺ > m` because Theorem 3 puts the image of `D_{P_σ}` on
> `L_σ` and not on `E_σ`. So `e₂ = m` always, and `e₁ = m` if `h₀ ≠ 0`,
> `e₁ = m+1` if `h₀ = 0`. In the second case the coefficient of
> `t₁^{m+1}t₂^{m}` needs `j = m, k = 1` — the plus half sits at `j ≥ m+1` and
> cannot reach it. The leading datum is `h₁`;
> **(v)** an `f ∈ V₀` changes **no other child's value** — the only children it
> makes degenerate are the six (F6).

Machine witnesses at both primes for every odd `d ∈ {3,5,7,9,11}` with
`m = 1` (F3); for the degrees that matter (`d = 25`: `N(25,3) = 368`;
`d = 35`: `N(35,1) = 420`) `dim V₀` is in the hundreds.

**Consequence.** The classes discarded at odd residues are not excluded. The
derivation of `K(1) = K(3) = K(5) = 0` is invalid, and with it the reading
"all odd degrees excluded at order 0" and "the first open window moves from
`d = 35` to `d = 36`". **The first open window stays at `d = 35`.**

---

## 6. The corrected residue table

What is established here:

| `d mod 6` | `STAGE1_TIGHTEN` §2.2 | corrected |
|---:|---:|---|
| `0`, `2`, `4` | 10 752 / 672 / 672 | **≥** those values (see below) |
| `1`, `3`, `5` | **0** | **not 0**; not determined here |

Two honest qualifications, and no number is asserted for the odd rows:

1. On the `D_{P_σ}` row the corrected contribution at odd `d` is *identical* to
   the contribution at the even residue with the same `d mod 3` (F6). If nothing
   else moved, `K` would depend only on `d mod 3`
   (`K(3) = K(0)`, `K(1) = K(4)`, `K(5) = K(2)`). **Something else does move**:
   at odd `d` the `C2`-curve over the type-I point contracts to `[B]` where at
   even `d` it must sweep, so the sweep pattern differs and the count must be
   re-run, not transported.
2. The same correction applies at the even residues, and upstream: `STAGE1`
   §15.2's "38 of the 48 computed components of `M_{D_{P_σ}}` evaluate some
   child outside its arc-consistent domain" uses the identical test, so those 38
   are not all excluded either. **`STAGE1`'s coherent count
   `1 088 847 395 778 723 840 000` is a lower bound, not the count**, and the
   reduction factor `64 = 2⁶` against arc consistency is an upper bound on the
   true cut. This is collateral damage from the same line, and it is the reason
   no corrected number is offered here.

**Recommended repair.** Replace the degeneracy test by the *order-stratified*
one: for each child, compute the filtration of `V(a,ψ)` by order of vanishing at
`π(F_R)`, and let the class contribute, for each attained order `k`, the value
`ψ^{-1}∏_r μ_r^{a_r}·(the character of the k-th term)`. For the two full-flag
rows this is a two-step filtration and the second step is exactly the vertex
flip above.

---

## 7. Anchors and consistency probes (audit items 3, 5)

**Anchors** — all four reproduce; see the table in §1 for the first three. The
fourth:

* **the sealed `d = 34` closure** (`D34_GUIDED_SWEEP`, branch
  `origin/agent/d34-guided-sweep-20260811`). Its two closing conditions are
  `(M)` = `STAGE2` Prop 1.4(i) (`34` even ⟹ `T|_{L_σ} ≡ 0`) and `(E)` =
  Prop 1.6 (`34 ≡ 1 mod 3`). It quotes `N(34,1) = 397` and `N(34,3) = 704` only
  as background, explicitly recording that "the sieve's bite at `d = 34` must
  come from higher order … **not from the sweep datum**", and its verifier uses
  `N_leading` only as an independent recomputation, never in the cascade. Its
  `(M)`-corank-2 measurement (rank 16 against budget 18) is a statement about
  the restriction `M_34 → (Sym^{34}(W⁻)* ⊗ W)^{D12}`, unrelated to the
  evaluation layer. **`d = 34` neither depends on the odd-zero mechanism nor
  conflicts with this audit.**

**Consistency probes.**

* **(a) No sealed object induces a coherent order-0 section at odd `d`.**
  `T5`'s `Q_{B,ℓ}` is a local witness on the `ℓ_V` band (line degree 6, plane
  order `m` odd; implied total degrees `12, 15, 18, 21, …`), and its own gate
  verdict says the formalism "cannot close Problem E on local data".
  `FIX-D2`'s survivors `(7;1,1,1)` and `(6;3,3,3)` are "level-local / jet-level
  algebra at `c_σ`", admissible from `d ≥ 19` (odd) and `d ≥ 12` under the
  corrected bound. Neither is an order-0 boundary pattern. So there was no
  sealed contradiction to find — which is why the refutation had to be built,
  not looked up.
* **(b) `STAGE2` Theorem 4.1** ranges over the odd-order rows (`C3`, `C5`,
  `C11`) plus the single-involution `C6`/`L_σ` layer needed to reach mod 330. It
  explicitly defers the `V4` band and the `D_{P_σ}` coupling (its named
  remainders 4 and 5). **No theorem-level conflict either way** — confirming
  `STAGE1_TIGHTEN` §2.5's own reading.
* **(c) `d = 25`.** `FIX_P1_DEGREE25_GUIDED` killed it by a *dimension*
  computation: `dim M_25 = 189`, and the forced-profile slice collapses
  `189 → 59 → 3 → 0`. It exhibits **no** order-0 coherent section at `d = 25`,
  only module dimensions. So there is no conflict in either direction — the
  slice sweep was not doing work a congruence had already done, because there
  was no such congruence.

---

## 8. Honesty tiering

**Tier 1 — exact, prime-free.** Proposition A (a dimension count on the flag,
plus `G` perfect). The relaxation argument of §2. Proposition B(ii) (`W⁻_σ`
irreducible under `D12`), B(iii) (a two-line character computation), B(iv) (the
exponent bookkeeping, using only the sealed parity theorem).

**Tier 2 — finite exact computation at two split primes (331, 661).** The census
rebuild and its agreement with the sealed row multiset; the 54/18 child counts;
`N(d,m)` for `d ≤ 12`; the parity anchors; evaluation rigidity; the clash tables
(E1, E2); `dim V₀ = N(d,m) − 2` and the escape witnesses for `d ≤ 11`.

**Tier 3 — flagged.**

1. **No corrected count.** This packet invalidates a derivation; it does not
   re-run the enumeration. `K(1), K(3), K(5)` are shown to be non-zero-by-this-
   argument, not computed. §6 says why the even residues are affected too.
2. Proposition B is verified for `d ≤ 11`; for larger `d` it rests on
   `N(d,m) ≥ 3`, which is Tier-1 arithmetic from `STAGE1` §14's closed form, and
   on the character identity, which is prime-free. The *witness sections* were
   exhibited only in the verified range.
3. The escape is exhibited on the `D_{P_σ}` row — the row `STAGE1_TIGHTEN` §2.5
   itself says is "doing all the work". The corresponding question on
   `D_{L⁻_σ}` was not needed (at odd `d` its generic evaluation is already
   arc-consistent once the `C2`-curve over the type-I point contracts) and was
   not pursued.
4. The `d = 25`, `T5`, `FIX-D2` and `STAGE2` Thm 4.1 readings in §7 are
   consumed from the sealed record, not re-derived.

## 9. Not claimed

* No headline. Problem E remains OPEN.
* **No degree is excluded, and none is shown to survive.** The odd residues are
  returned to "unresolved", which is where `STAGE1_TIGHTEN` §2.5 left them.
* No claim that a landing covariant exists at any degree, odd or even.
* No claim that `STAGE1_TIGHTEN` §§1–2.4 (the saturation theorem, `Θ = 6`, the
  full-flag dichotomy, the `D10` split) are wrong. They are not touched, except
  that the count they feed inherits §6's caveat.
* No re-run of `STAGE1`'s coherence layer, and no corrected value for its total.

## 10. Dependencies

| import | used for | grade |
|---|---|---|
| `scripts/psl211.py` (raw 660 matrices) | the group model | shared input, byte-identical |
| `STAGE1_TIGHTEN` (`agent/stage1-tighten-20260811`) | the audit target | model re-derived; the filter step **refuted** |
| `STAGE1_COMPLEX_MAPS` (`agent/stage1-complex-maps-20260810`) | Thm 15.1, the census, `N(d,m)` | Thm 15.1 re-proved and re-verified; census **independently rebuilt**; `s1coherence.py` carries the same degeneracy error |
| `STAGE2_ODD_ORDER_PINNING` (`agent/stage2-odd-order-pinning-20260810`) | Lemma 0.1, Props 1.3/1.4, Thm 4.1 scope | Prop 1.4(ii) **re-derived**; Thm 4.1 scope confirmed |
| `TERMINUS_STRATA_PW` (`inputs/terminus_t2_strata.json`) | cross-check only | the rebuild reproduces it |
| `D34_GUIDED_SWEEP`, `FIX_P1_DEGREE25_GUIDED`, `FIX_T_gate` T5, `FIX_D2_TERMINAL_SYSTEM` | consistency probes | consumed as sealed statements |
