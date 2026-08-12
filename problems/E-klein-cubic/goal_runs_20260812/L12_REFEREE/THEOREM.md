# Hostile referee of the global localization ledger (L12)

**Packet:** `goal_runs_20260812/L12_REFEREE/` · opened 2026-08-12.
**Object:** director derivation `theory/GLOBAL_LOCALIZATION_LEDGER_20260812.md`.
**Mode:** adversarial mathematics only — no machine enumeration of patterns.

> # Headline: Problem E remains OPEN; this packet excludes no degree.
>
> The morphism-ledger identity family is **strategically sound** and may
> proceed to a machine phase **after the R1 denominator correction** (and
> with the R3/R4 caveats below). Nothing here kills a degree class.

*(Filename note: the harness refuses the literal name `REPORT.md`.)*

## Summary (≤ 20 lines)

| Item | Verdict | One-line |
|------|---------|----------|
| **R1** AB conventions | **CORRECTED** | Holomorphic Lefschetz uses `tr / det(1−dg\|T)`, not `det(1−(dg)⁻¹)`. |
| **R2** five points + tangent | **CONFIRMED** | All `e_j ∈ X`; `∇F(e_j)` single nonzero `∂F/∂x_{j+1}=1`; `T_{e_j}X` as stated. |
| **R3** Leray + flags | **CORRECTED** | Projection formula OK; four flags necessary but incomplete (add base-change/virtual fiber). |
| **R4** twist `k` | **CORRECTED** | Localized `k=0` is **not** vacuous; `k=1,2,3` do give independent weight rows. |
| **R5** SL vs PSL lifts | **CONFIRMED** | Odd orders safe; 2/6 need a fixed global linearization. |
| **R6** local ⇏ global | **CONFIRMED** | AB–Leray is one cyclotomic equation on the product of local data. |

**Exact corrections to apply before machine work:**
1. Replace every isolated-fixed-point contribution
   `w / det(1−(dg)⁻¹)` by `w / det(1−dg)`.
2. In the order-11 display, RHS denominators become
   `Π_{k'∉{j,j+1}} (1 − ζ^{a_{k'}−a_j})` (not `ζ^{a_j−a_{k'}}`);
   LHS uses `Π (1 − ζ^{w_t})` with the same weight sign as `dg`.
3. Parenthetical “conormal weight `ζ^{a_{j+1}−a_j}`” is the **normal** weight;
   conormal is the inverse character.
4. Treat localized `k=0` as the constraint `Σ_j (tr_j−1)/D_j = 0`, not as `1=1`.
5. Carry a fifth flag: local AB factor at `x` uses the **derived** fiber
   `χ_g(Z_x,O)`, not underived stalk ranks when jumps occur.

**Machine phase:** may proceed on order 11, `k=1,2,3` (and optionally `k=0`),
genus-0 branch first, with the corrected denominators. No degree excluded.

## Exit ledger

```text
L12-REFEREE-R1-AB-DENOMINATOR-CORRECTED
L12-REFEREE-R2-TANGENT-CONFIRMED
L12-REFEREE-R3-LERAY-FLAGS-CORRECTED
L12-REFEREE-R4-TWIST-K-CORRECTED
L12-REFEREE-R5-LIFT-CONFIRMED
L12-REFEREE-R6-GLOBAL-CONFIRMED
L12-REFEREE-MACHINE-PHASE-MAY-PROCEED
L12-REFEREE-NO-DEGREE-EXCLUSION
```

Machine markers: `L12_REFEREE_VERIFY_OK` / `ALLGREEN`
(`python3 verifier.py` — computational spot-checks for R1 calibration and R2).

---

## 0. Scope and sources

**In scope.** The director note’s analytic claims (R1)–(R6) as written in
`theory/GLOBAL_LOCALIZATION_LEDGER_20260812.md`.

**Out of scope.** Pattern census, residue-class sieves, any degree kill.

**Standard source for R1.** Kondyrev–Prikhodko, *Categorical proof of
Holomorphic Atiyah–Bott formula*, arXiv:1607.06345, Theorem 3.1.2:

```
L(E,b) = Σ_{x=f(x)}  Tr(b_x | E_x) / det(1 − d_x f) .
```

Their `P¹` rotation example matches `H^•` traces only with this denominator.

**Sealed geometric record for R2.** `goal_runs_20260810/RECEIVER_LEDGER_X`
(`X^{C11}` = five coordinate points, all on `X`); FIX-VII carrier note
(L-weights `ζ^{−a_i}`); `D34_GUIDED_SWEEP/d34lib.stage2_frame` checks
`F`-vanishing and eigenframe geometry but **does not** seal the AB
denominator convention (it never evaluates Lefschetz numbers).

---

## R1 — Atiyah–Bott holomorphic Lefschetz conventions

### Claim in the note

Isolated fixed points contribute

```
w_k(q(z)) / det(1 − (dg_z)⁻¹) ,
```

and the order-11 display uses denominators
`Π (1 − ζ^{−w_t})` and `Π (1 − ζ^{a_j − a_{k'}})`.

### Verdict: **CORRECTED**

**Numerator `w_k`.** For the linearization of `O(1)` dual to the tautological
line, if `g·e_j = ζ^{a_j} e_j` then `g` acts on `O(1)_{e_j}` by `ζ^{−a_j}`.
Hence `w_k(e_j) = ζ^{−k a_j}`. Matches FIX-VII (“L-weights `ζ^{−a_i}`”) and
the sealed QR eigenframe. **Numerator: CONFIRMED.**

**Denominator.** The holomorphic Lefschetz theorem (analytic Dolbeault form
and the algebraic form of Kondyrev–Prikhodko) places

```
det_C(1 − dg |_T_x)
```

in the denominator, **not** `det(1 − (dg)⁻¹)`.

Calibration (classical `P¹`, rotation by `λ = e^{iφ}`, bundle `O(n)`, `n≥0`):

| convention | value | equals `Σ_{k=0}^n λ^k`? |
|------------|-------|-------------------------|
| `tr / det(1−dg)` | `1/(1−λ) + λ^n/(1−λ⁻¹)` | **yes** |
| `tr / det(1−(dg)⁻¹)` | `1/(1−λ⁻¹) + λ^n/(1−λ)` | **no** for `n≥1` |

Replayable in `verifier.py` (complex arithmetic).

**Why the inverse form is not a harmless dual rewrite.** If weights of `dg`
on `T_x` are `λ_i`, then

```
det(1 − (dg)⁻¹) = (−1)^n (Π λ_i)⁻¹ det(1 − dg) .
```

The two conventions differ by the pointwise factor `(−1)^n det(dg|_T_x)`.
Source tower `Z` and receiver `X` have **different dimensions**
(relative dimension 1: `dim Z = 4`, `dim X = 3` for a generically curve-fibred
landing resolution). Applying the inverse form on both sides therefore
multiplies the two AB expansions by incompatible local factors; the
Leray equality of true `χ_g` does **not** imply equality of the two wrong
expansions.

**Corrected order-11 skeleton** (isolated fixed points, same lift both sides):

```
Σ_{z ∈ Z^g}  ζ^{−k·a_{v(z)}} / Π_t (1 − ζ^{w_t(z)})
  =  Σ_{j=0}^{4}  ζ^{−k·a_j} · χ_g(Z_{e_j}, O)
                 / Π_{k' ∉ {j,j+1}} (1 − ζ^{a_{k'} − a_j})
```

where `w_t(z)` are the integer weights of `dg_z` on `T_z Z`, and
`χ_g(Z_{e_j}, O) = 1 − tr(g|H¹) + tr(g|H²) − ⋯` is the virtual fiber.

**Sealed stage2_frame.** Confirms `F`, C6/C5 eigengeometry, and related
base-locus linear algebra. It is **not** a witness for either AB denominator.
No correction to sealed Stage-2 code is implied.

---

## R2 — Five coordinate points on `X` and the tangent weights

### Claim in the note

`P(W)^g` is the five coordinate points; all lie on `X` because
`F = Σ x_i² x_{i+1}` vanishes at every `e_j`. Gradient `∇F(e_j)` has sole
nonzero entry `∂F/∂x_{j+1} = 1`, so

```
T_{e_j} X = span(e_k : k ∉ {j, j+1})
```

with tangent weights `ζ^{a_k − a_j}`; “conormal” weight `ζ^{a_{j+1}−a_j}`.

### Verdict: **CONFIRMED** (one terminology fix)

**On `X`.** Every monomial of `F` uses two distinct variables (no `x_i³`), so
`F(e_j) = 0`. Sealed as `RECEIVER_LEDGER_X` row `C11` and rechecked in
`verifier.py` over `Z` and at split primes `p ∈ {331,661}` with the modular
QR frame.

**Gradient.** With indices mod 5,

```
∂F/∂x_m = 2 x_m x_{m+1} + x_{m−1}² .
```

At `e_j`: only the second summand of `∂F/∂x_{j+1}` survives, value `1`; all
other partials vanish. Direct check in `verifier.py`.

**Tangent space.** Affine cone: `ker dF_{e_j} = {v : v_{j+1} = 0}`.
Projectivizing and killing the Euler line `⟨e_j⟩` leaves
`span(e_k : k ∉ {j,j+1})`. Weights of `g = diag(ζ^{a_i})` on affine
coordinates `u_k = x_k/x_j` are `ζ^{a_k−a_j}`; restrict to `k ∉ {j,j+1}`.

**Normal vs conormal (terminology).** The normal line
`T_{e_j}P⁴ / T_{e_j}X` is spanned by the `u_{j+1}` direction, weight
`ζ^{a_{j+1}−a_j}`. The **conormal** is dual: weight `ζ^{a_j−a_{j+1}}`.
The note’s exponent is the normal weight. Harmless for the identity
(only `T_X` weights enter the corrected AB sum), but the word “conormal”
should be flipped or the exponent inverted.

**QR set.** `{1,3,4,5,9} =` quadratic residues mod 11. Sealed frames use a
permutation of the same multiset (e.g. `(1,9,4,3,5)`).

---

## R3 — Leray side, `Rq_*O`, and the four flags

### Claim in the note

```
χ_g(Z, q* O_X(k)) = χ_g(X, O_X(k) ⊗ Rq_* O_Z) ,
```

with `Rq_*O = O ⊕ (higher)`, `R¹` generically of rank = fiber genus, possible
`R²` jumps; four flags (Stein, jumps, map level, lift) gate machine work.

### Verdict: **CORRECTED** (sound core; flag list incomplete)

**Projection / Leray identity.** For proper equivariant `q` and a
`g`-linearized bundle `L` on `X`, the projection formula in the derived
category gives

```
RΓ(Z, q* L) ≃ RΓ(X, L ⊗ Rq_* O_Z) .
```

Taking alternating `g`-trace yields the stated equality of equivariant Euler
characteristics. **CONFIRMED.**

**Structure of `Rq_*O` for relative dimension 1.**

- Generically: fibers are curves, so `R^i = 0` for `i > 1` on a Zariski open,
  and for a smooth connected fiber `C` one has `h¹(O_C) = p_a(C)` (arithmetic
  genus). The note’s “fiber genus” is acceptable if read as `p_a`.
- Special fibers may acquire surface components ⇒ possible nonzero `R²`
  (and torsion phenomena). Flag 2 is necessary.
- `q_* O_Z = O_X` iff Stein factorization is trivial (connected fibers, or
  more precisely the finite part of Stein is an isomorphism). A nontrivial
  Stein factor through a `G`-cover of simply-connected `X` is tightly
  constrained; treating its degree as a small menu variable is correct.
  Flag 1 is necessary.

**Flags 3–4.** Map-level / reduced-map discipline (no silent transport across
degree classes) and global SL-lift consistency are real gates. **CONFIRMED
as necessary.**

**Missing flag (add before machine work).**

5. **Derived fiber / base change.** The local receiver factor is the
   alternating trace of `g` on the **derived** fiber cohomology
   `χ_g(Z_x, O)`, which equals the virtual stalk of `Rq_*O` at `x` by proper
   base change. Underived ranks of `R^i q_* O` at `x` can misreport jumps.
   Machine code must use virtual representations of derived fibers
   (especially when Flag 2 is live).

Optional sharpenings (do not block order-11 isolated phase): positive-
dimensional fixed components at orders 2/3/6 need full AB characteristic-
class terms (the note already defers them); non-flat `q` is already covered
by writing `Rq_*`.

**Completeness.** The four listed flags are **necessary and almost
sufficient** for a correct enumerator; they are **not** the complete list
without Flag 5 (and the R1 denominator fix, which is not a “flag” but a
formula correction).

---

## R4 — Twist `k = 0` vs `k = 1,2,3`

### Claim in the note

`k = 0` gives `1 = 1` (no information — blowups preserve `H^*(O)`);
`k = 1,2,3` give genuinely new equations; `k = 3` interacts with `F`.

### Verdict: **CORRECTED**

**Global vs localized.** Blowups along smooth centers satisfy `Rπ_* O = O`,
so `χ_g(Z, O_Z) = χ_g(P⁴, O) = 1`. Cubic threefolds are Fano with
`H^{i,0}(X) = 0` for `i > 0`, so `χ_g(X, O_X) = 1`. The **global** equality
at `k = 0` is indeed `1 = 1`.

The **localized** ledger, however, equates two AB expansions. With corrected
denominators `D_j = det(1 − dg|_{T_{e_j}X})` and virtual fiber traces
`tr_j = χ_g(Z_{e_j}, O)`,

```
Σ_j tr_j / D_j  = 1 ,
```

while AB for `O_X` alone gives `Σ_j 1/D_j = 1`. Subtracting,

```
Σ_j (tr_j − 1) / D_j  = 0 .
```

That is a real linear constraint on the fiber characters whenever some
`tr_j ≠ 1`. It is vacuous on the pure genus-0 Stein-trivial branch
(`tr_j = 1` for all `j`), and then reduces at best to an independent check
of the receiver AB sum for `O_X`. **The note’s “no information” is true
only globally, not for the localized ledger that the machine is asked to run.**

**`k = 1,2,3`.** The receiver unknowns (fiber virtual traces at the five
points) are probed against weight rows

```
( ζ^{−k a_0}, …, ζ^{−k a_4} ) ,  k = 1,2,3 .
```

These are three distinct characters of the free `C11`-action on the five
points (Vandermonde in the QR multiset). They are linearly independent over
`Q(ζ_11)` as row vectors in the five-dimensional coordinate space of
functions on `X^g`. Hence they give genuinely independent linear data on the
fiber-trace vector. **CONFIRMED.**

**`k = 3` and `F`.** The hypersurface sequence `0 → O_{P}(k−3) → O_{P}(k) → O_X(k) → 0`
relates ambient and receiver Euler characteristics; at `k = 3` the kernel is
`O_P`, so the identity couples to the equation of `X`. Soft but correct.

---

## R5 — Lift consistency (SL vs PSL) by order

### Claim in the note

Fix one weight convention globally; orders 11/5/3 are safe; orders 2/6 need
the check.

### Verdict: **CONFIRMED**

`G = PSL(2,11)` acts on `P(W)`. Equivariant AB needs a linearization of the
action on `W` and on `O(1)` — an SL-lift (or any fixed lift to `GL(W)`).

- For cyclic groups of **odd** order, `H²(C_n, C*) = 0` and a projective
  representation of `C_n` lifts to a linear representation of the same order
  (unique up to scalar; det-1 or product-of-eigenvalues pins the scalar).
  Orders **3, 5, 11** are safe once one global lift of the Weil generators is
  fixed (the sealed QR diagonal `T` already does this).
- For **even** order, a projective involution may lift to order 4, and
  weight multisets of `g` vs `−g` on `W` differ by a global sign that
  propagates into `O(1)`-weights and into `det(1−dg)`. Orders **2 and 6**
  must use the **same** sealed matrices as the rest of the campaign
  (`certificates/exact_weil_check.py` / modular `build_frame`), not an
  independent sign choice per packet.

Both sides of each identity must use that single lift. The note is right.

---

## R6 — No local layer implies these identities

### Claim in the note

Every prior constraint is local (stratum data or finite contact). The
AB–Leray family is a global consistency invariant that no local layer forces.

### Verdict: **CONFIRMED**

**Argument.** Write a boundary pattern’s data as a point of a product
(inverse limit over the stratum poset) of local solution spaces `L_s`
(multidegrees, depths, jets, gluing/cocycle/ramification data at contacts).
Each existing layer is the pullback of a closed condition along a projection
to finitely many factors `L_{s_1} × ⋯ × L_{s_m}`.

The corrected order-`g` identity at twist `k` is a single equation in
`Q(ζ_{ord g})` of the form

```
Σ_{z ∈ tower(g)}  N_k(z) / D(z)  =  Σ_{x ∈ X^g}  N_k(x) · τ(x) / D(x) ,
```

where tower points `z`, tangent weights in `D(z)`, and values `v(z)` assemble
from **many** strata’s chain data at once, and the fiber traces `τ(x)` are
coupled across all of `X^g` through one weighted sum. This function on
`∏_s L_s` is not constant on the fibers of any proper subproduct projection:
one may vary local jet data at two different `C11`-towers so as to preserve
every local residue/RH constraint while changing a single summand of the
left-hand side, or reassign fiber characters among the five points inside
the C7/C14 menus so as to preserve each point’s local menu while breaking
the weighted sum.

**Toy counter-model (existence, not a Klein witness).** Take five formal
slots with fixed denominators `D_j ∈ Q(ζ)*` and local menus `τ_j ∈ M_j ⊂ Z[ζ]`
each containing at least two values. The local layer `τ_j ∈ M_j` is a product
condition. The hyperplane `Σ_j w_j τ_j / D_j = c` is a nontrivial diagonal
condition on the product whenever some `w_j/D_j ≠ 0`. Product-local search
can return a tuple that fails the hyperplane.

Hence the identity family is strictly new. **CONFIRMED.**

---

## Machine-phase gate

| Gate | Status after this referee |
|------|---------------------------|
| R1 denominator formula | **must patch** before any numeric AB sum |
| R2 geometry | sealed / reconfirmed — free to use |
| R3 flags 1–4 + new flag 5 | carry as enumerator variables / checks |
| R4 | run `k=1,2,3`; optionally `k=0` as the `(tr−1)` sum |
| R5 | use sealed Weil lift; odd-order first |
| R6 | no substitute from local layers |

**Proceed:** order-11 identity over the live cells and residue-5 class,
corrected denominators, genus-0 branch as closed pattern test, then bounded
fiber-trace menus. Then order 5; then curve-contribution orders 2/3/6.

**Not authorized by this packet:** any degree exclusion, any claim that a
pattern already fails, any transport of a reduced-map kill to a tuple class
without the map-level upgrade (Flag 3).

---

## Replay

```bash
cd problems/E-klein-cubic/goal_runs_20260812/L12_REFEREE
python3 verifier.py
```

Expected: `L12_REFEREE_VERIFY_OK`, `ALLGREEN`, exit 0.
)
## Director adjudication (2026-08-12, appended before sealing)

Replayed clean: ALLGREEN. All five corrections adopted verbatim into the
L12 note (§8 there), including the referee's improvement (the localized
k=0 sum rule — now the first machine target). The machine phase is
cleared for order 11 under the corrected formulas, genus-0 branch first;
dispatched as `WORKORDER_L12_ORDER11.md`.
