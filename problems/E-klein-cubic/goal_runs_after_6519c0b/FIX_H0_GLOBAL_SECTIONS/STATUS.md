# Status — FIX-H0, the global constraint-satisfaction problem on `𝒜/G`

**Primary exit:** `FIX-H0-H0-PARTIAL` — `H⁰` is **not** decided; what is decided
is a strict, exact reduction of the stalk:

| scoped exit | content |
|---|---|
| `FIX-H0-PT-EMPTY` | **theorem** — `x_L = pt` is impossible: the exceptional divisor over every plus-plane `P_σ` maps **onto** `L_σ`. |
| `FIX-H0-PURE-EVENM-EMPTY` | **theorem** — every **even-`m`** stalk component is globally empty (so `(0,3)`, `(2,6)`, `(2,7)`, all `(2k, 3δ+3k)`, `(6,12)`, …). |
| `FIX-H0-PURE-M1-UNDECIDED` | the primitive `m = 1` Chebyshev branch (`r = 7`, and its `q^k`-translates at every odd `r ≥ 9`) **survives every constraint decided here**. |
| `FIX-H0-PURE-M3-UNDECIDED` | the odd-`m ≥ 3` `D_B` branches (`(3,6)` = the T5 witness, `(3,8)`, `(3,9)`, `(7,12)`, …) **survive every constraint decided here**. |
| `FIX-H0-CSP-INCOMPLETE-AS-DRAFTED` | **finding** — Note III §4b's constraint list 1–6 is *missing a constraint class*, and the class it is missing is the one that decides the even rows. Precise statement in §4. |
| `FIX-H0-B-REDUCTION-CONFIRMED-WITH-SHARPENING` | the equivariance-forces-uniformity reduction is **correct**; three sharpenings recorded in §5. |
| `FIX-H0-D-ONE-TRACE-GEOMETRY` | **finding** — the two branches' parameter loci **do** embed in one reciprocal-cover geometry, and the `m = 1` locus carries **both** character-surface parameters, tied by the exact Klein identity `(κ₊+2)(κ₋+2) = 27/4`. §7. |

**Problem E headline: OPEN.**

Packet: `goal_runs_after_6519c0b/FIX_H0_GLOBAL_SECTIONS/`.
Frame: `theory/FIX_III_cosheaf.md` §4b/§4c; stalks from `theory/FIX_II_jets.md` §4.
Verification class: **ALGEBRAIC-RECOMPUTE** (`verify_h0.py`, 27 checks, 0
failures, harness self-test included; terminal marker `FIX_H0_VERIFY_OK`).
Toolchain: `python3` exact arithmetic in `Q(ζ₁₁)` (a local copy of FIX-A0's
`klein_exact.py`), `sympy` exact, Macaulay2. No GAP/Sage/Magma/PARI. No msolve
was needed, so the msolve parenthesis landmine is not in play; the one M2 input
is nevertheless emitted with bare integer coefficient vectors.

---

## 0. Conventions

`G = PSL(2,11)`, `W` the 5-dimensional Weil representation, `X = V(F) ⊂ P(W)`
the Klein cubic. `f : P(W) ⇢ X` is `G`-equivariant and dominant; since `G` is
perfect the twisting character is trivial, so `f` is given by a tuple `T` of
`W`-valued forms of some degree `d` with `gcd = 1` and

```
T(g·v) = ρ(g) T(v)   for all g ∈ G,        F(T) ≡ 0 .
```

For an involution `σ`: `W = W⁺_σ ⊕ W⁻_σ` with `dim = 3, 2`;
`P_σ = P(W⁺_σ)` (the plus-plane, in the **source**), `L_σ = P(W⁻_σ) ⊂ X`,
`E_σ = X ∩ P_σ` (a smooth plane cubic). Write `v = w + y`, `w ∈ W⁺`,
`y ∈ W⁻`, and `T = T⁺ + T⁻` for the corresponding split of the tuple.

`ord_{P_σ}` is the `(y)`-adic order (order of vanishing along `P_σ`),
`ord_{ℓ_V}` the `(x,y,z)`-adic order along a `V₄`-triple line. Per Note II §1
the multi-order of the local landing family is `(ord_{ℓ_V}; ord_{P_1},
ord_{P_2}, ord_{P_3}) = (r; m, m, m)` — the three plane orders agree because
the three involutions of a `V₄` are `G`-conjugate; and `m, r` are the **same
for all 55 lines / 55 `V₄`s**, all being `G`-conjugate. So `(m, r)` is a single
global invariant of `f`, which is exactly why the quotient CSP has one line
variable.

---

## 1. Theorem H0-1 (the plus-plane parity theorem) — `FIX-H0-PURE-EVENM-EMPTY`

> **Theorem H0-1.** Let `f : P(W) ⇢ X` be `G`-equivariant and dominant. Then
> for every involution `σ`
>
> ```
>       ord_{P_σ}(T⁻)  <  ord_{P_σ}(T⁺) ,
> ```
>
> and consequently `m = ord_{P_σ}(T) = ord_{P_σ}(T⁻)` is **ODD** (in
> particular `m ≥ 1`: every one of the 55 plus-planes lies in the base locus
> of `f`).

**Proof.**

*(i) Parity.* `σ` acts as `+1` on `W⁺_σ` and `−1` on `W⁻_σ` (certificate
**A1**, exact, all 55). Equivariance at `σ` reads `T(w, −y) = ρ(σ)T(w,y)`,
i.e. `T⁺(w,−y) = T⁺(w,y)` and `T⁻(w,−y) = −T⁻(w,y)`: `T⁺` is **even** and
`T⁻` is **odd** in `y`. Hence `a := ord_{P_σ}T⁺` is even, `b := ord_{P_σ}T⁻`
is odd, and `a ≠ b`. (Machine-checked non-circularly in Part B: the
`σ`-equivariance conditions are *solved* as an exact linear system on all
degree-`d` tuples, `d = 1,2,3`, and the resulting solution space is read in the
adapted basis — the `W⁺`-block support has `y`-degrees `{0,2}`, the `W⁻`-block
support `y`-degrees `{1,3}`.)

*(ii) Both halves are nonzero.* If `T⁻ ≡ 0`, `f` maps into `P(W⁺_σ)`, hence
into `X ∩ P(W⁺_σ) = E_σ`, contradicting dominance; if `T⁺ ≡ 0`, `f` maps into
`L_σ`, again contradicting dominance. So `a, b < ∞`.

*(iii) Suppose `a < b`.* Blow up `P_σ` (smooth, codimension 2,
`C_G(σ)`-stable): the exceptional divisor is
`D_σ = P(N_{P_σ/P⁴}) = P_σ × P(W⁻_σ)`, because
`N_{P_σ/P⁴} = O_{P_σ}(1) ⊗ W⁻_σ`. The induced rational map on `D_σ` is given
by the `y`-degree-`a` leading form, which is `(T⁺_a , 0)` — the `T⁻`-part
starts only at `y`-degree `b > a`. So the induced map is

```
      φ : D_σ = P_σ × P(W⁻_σ)  ⇢  P(W⁺_σ) ,    φ = [T⁺_a(w;y)] ,
```

nonzero on a dense open set. Its image lies in `X` (the graph closure of `f`
lies in `P⁴ × X`), hence in `X ∩ P(W⁺_σ) = E_σ`.

`E_σ` is a **smooth** plane cubic (certificate **A6**, Macaulay2, all 55), i.e.
a genus-1 curve; `D_σ ≅ P² × P¹` is rational. A rational map from a rational
variety to a curve of genus ≥ 1 is constant (Note I, Lem. 4.2). So `φ` is
constant, with value some `e ∈ E_σ`.

`D_σ` is `C_G(σ)`-stable and `φ` is `C_G(σ)`-equivariant, so `e` is a
`C_G(σ)`-fixed point of `P(W⁺_σ)`. But (certificate **A4**, exact, all 55, two
independent methods) `P(W⁺_σ)` has **exactly one** `C_G(σ)`-fixed point — the
`D12`-point `z_σ = [triv]` — and `F(z_σ) ≠ 0`, i.e. `z_σ ∉ X`. Contradiction.

*(iv)* Therefore `b < a`, so `m = min(a,b) = b` is odd. Applying (iii) with
`a = 0` gives `m ≥ 1`. ∎

**What it excludes.** `m` is a stalk-component label of `𝒮_L` (Note II §1's
multi-order of the *landing family*, i.e. of the whole germ). Hence **every
even-`m` component of `𝒮_L` is globally empty**, whatever its `r` and whatever
its parameters: the `m = 0` seed row, the whole `m = 2` row (`(2,6)` and
`(2,7)`, i.e. Cor. E′ and Thm N2B-3), every `(2k, 3δ+3k)`, and `(6,12)`. Note
this is invisible to the Note-II cell computations, which see only
`m = min_i ord_{P_i}` and never the finer datum *which `σ`-graded half attains
the minimum* — that datum is the content of Theorem H0-1.

*Grading remark (a real subtlety, recorded).* Note II §1 defines the
multi-order on the **full germ**, whereas FIX-N2's cell computations work with
a single `(x,y,z)`-homogeneous piece of degree `r`. For a general germ
`T = Σ_{j≥r} T_j` one has `ord_{P_σ}(T) = min_j ord_{P_σ}(T_j) ≤
ord_{P_σ}(T_r)`, so the plane order of the *leading graded piece* can be
strictly larger than the germ's. This does not weaken anything above:
Theorem H0-1 is a statement about `ord_{P_σ}(T)`, which is exactly Note II's
`m` and hence exactly the component label of `𝒮_L`; and FIX-N2's cell
statements are statements about the strata "plane order **≥** `m`", so the
leading piece `T_r` of a global map with germ multi-order `(r; m,m,m)` is a
legitimate nonzero element of the `(≥m, r)` stratum. Every witness in the
branch table of §3 is `(x,y,z)`-homogeneous, so for those germ = graded piece
and the table entries are literally the components' labels.

**Certificates (all exact, characteristic 0, all 55 involutions).**

| id | statement | producer method | verifier method (independent) |
|---|---|---|---|
| A1 | `σ = diag(1,1,1,−1,−1)` in the adapted basis | nullspaces of `M ∓ I` | images of the projectors `(I ± M)/2` |
| A2 | `F|_{W⁻_σ} ≡ 0` | symbolic restriction | grid interpolation on `{0,1,2,3}²` (deg 3 ⇒ a proof) |
| A3 | `F(w+y)` has only `y`-degrees `0, 2` | symbolic expansion | `F(w+y) − F(w−y) ≡ 0` by grid interpolation on `{0,1,2,3}⁵` |
| A4 | exactly one `C_G(σ)`-invariant line in `W⁺`; its point is **off** `X`; algebra generated on `W⁺` has dim 5 | Reynolds-projector ranks per linear character | character inner products `⟨χ_{W⁺}, λ⟩` from **traces only**; `z_σ` from the Reynolds projector on `W` |
| A5 | **no** `C_G(σ)`-invariant line in `W⁻`; Burnside algebra dim `= 4` (irreducible) | projector ranks + algebra closure | character inner products from traces |
| A6 | `E_σ = X ∩ P(W⁺_σ)` is smooth | — | Macaulay2 over `toField(QQ[a]/Φ₁₁)`, `dim (jacobian ideal) = 0`, `n_singular = 0` of 55, marker `FIX_H0_EPLANE_SMOOTH_OK` |
| — | the 55 involutions form one `G`-class | conjugation by all 660 | closure under generator-conjugation |

---

## 2. Theorem H0-2 (the `pt` option is impossible) — `FIX-H0-PT-EMPTY`

> **Theorem H0-2.** With `m` odd (Thm H0-1) the induced map on the exceptional
> divisor `D_σ` is `ψ = [0 : T⁻_m(w;y)] : D_σ ⇢ P(W⁻_σ) = L_σ`, and `ψ` is
> **non-constant, hence dominant onto `L_σ`**.

*Proof.* `T⁻_m ≠ 0`, so `ψ` is defined on a dense open of `D_σ` and is
`C_G(σ)`-equivariant. A constant value would be a `C_G(σ)`-fixed point of
`P(W⁻_σ)`; certificate **A5** says there is none (`W⁻_σ` is an irreducible
`C_G(σ)`-module — Burnside dimension 4 on a 2-dimensional space, and every
linear-character multiplicity is 0). So `ψ` is non-constant; its image is an
irreducible curve in the curve `L_σ`, i.e. all of `L_σ`. ∎

So the `{pt}` component of `𝒮_L` carries no section: **the all-`pt` section is
excluded before constraint 5 (dominance) is invoked** — the exclusion is
residual-`S3` geometry, not a dominance bookkeeping step. (Dominance is still
used, in step (ii) of Thm H0-1.)

---

## 3. A — the pure-branch table

Computed twice: `produce_h0_cd.py` (sympy over `QQ(om, B)` / the degree-36
field `K` of the Chebyshev witness) and `verify_h0.py` (an independent
dict-based expansion in `QQ(om)[B, B^{-1}][x,y,z]` plus 40-digit numerics at
all nine `(c, P₁)` points). `T⁺ = (a', b', u₀')`, `T⁻ = (u₁', u₂')` at
`σ₁`, `P₁ = (y,z)`.

| stalk witness | cell `(m,r)` | `ord_{P₁}T⁺` | `ord_{P₁}T⁻` | leading half | global verdict |
|---|---|---|---|---|---|
| `D_B` seed `X = x` | `(0,3)` | **0** | 1 | PLUS | **EXCLUDED** |
| `xyz·D_B(x)` (Cor. E′) | `(2,6)` | **2** | 3 | PLUS | **EXCLUDED** |
| `e₂·D_B(x)` (Thm N2B-3) | `(2,7)` | **2** | 3 | PLUS | **EXCLUDED** |
| `D_B(x²yz)` | `(6,12)` | **6** | 7 | PLUS | **EXCLUDED** |
| `D_B(yz)` — the **T5 witness** | `(3,6)` | 4 | **3** | MINUS | survives |
| `q·D_B(yz)` | `(3,8)` | 4 | **3** | MINUS | survives |
| `D_B(xy²)` primitive | `(3,9)` | 4 | **3** | MINUS | survives |
| `(xyz)²·D_B(yz)` | `(7,12)` | 8 | **7** | MINUS | survives |
| **FIX-N2C primitive Chebyshev** | `(1,7)` | 2 | **1** | MINUS | survives |
| `q^k ·` (Chebyshev), odd `r ≥ 9` | `(1,r)` | 2 | **1** | MINUS | survives |

`ord_{P_i}(q) = 0` for `q = x²+y²+z²`, so the whole populated `m = 1` row
inherits `(2,1)`.

> **The table's last two columns are redundant, which is what makes the
> verdict robust.** `ord_{P_σ}T⁺` is always even and `ord_{P_σ}T⁻` always odd
> (step (i) of Thm H0-1), so `m = min` is odd **iff** the minus half leads.
> Theorem H0-1 is therefore literally the single sentence "`m` is odd", and
> **any** stalk component — including ones not yet discovered — is excluded
> exactly when its `m` is even. In particular the concurrent FIX-N2C upgrade
> (Theorem N2C-1′: all three `λ`-eigenblocks at `(1,7)` are populated, `27`
> points in all, every one with `(ord_{P₁},ord_{P₂},ord_{P₃}) = (1,1,1)`)
> changes nothing here: all `27` have `m = 1`, odd, hence all survive.

The nine leading coefficients of the `λ = 1` Chebyshev witness were
certified **nonzero in the degree-36 field**
`K = Q(ω, κ₊, c, P₁)` by reduction modulo the Gröbner basis
`{ω²+ω+1, 8κ₊²−13κ₊−4, c³−3c−(κ₊+2), 27P₁³−24ω(κ₊+2)P₁²+32(κ₊+2)}`
(pairwise-coprime leading monomials, so `K` is a field), and independently by
40-digit numerics at all nine points.

**Scoped exits.** `FIX-H0-PURE-M0-EMPTY`, `FIX-H0-PURE-M2-EMPTY`,
`FIX-H0-PURE-EVENM-EMPTY` (uniform, every even `m`);
`FIX-H0-PURE-M1-UNDECIDED`, `FIX-H0-PURE-M3-UNDECIDED`,
`FIX-H0-PURE-ODDM-UNDECIDED`.

---

## 4. `FIX-H0-CSP-INCOMPLETE-AS-DRAFTED` — the correction to Note III §4b

Three structural findings, in increasing order of consequence.

**(4a) Constraints 1, 3, 6 are already discharged by the stalk itself, and
constraint 2's ×2 vertex gluing inside one triangle is too.** An element of a
Note-II cell is a germ at the `V₄` **triple line** `ℓ_V`, which is contained in
all three plus-planes of that `V₄` at once and is already imposed to be
`A₄`-equivariant with the residual scalar `λ ∈ μ₃`. That *is* constraint 3
(the `C₃ = A₄/V₄` rotation of the three incident line germs) and constraint 6
(the cone/parity gradings, built in), and constraint 1's `S3`-equivariance is
imposed only in its `C₃`-shadow. This is precisely the sense in which "T5
solves the local star at one `V₄`": a populated cell **is** a solution of the
drafted constraints 1/3/6 at one triangle, so those constraints have no
residual content once the cell table is known.

**(4b) The genuinely new coupling in constraint 1 is across the *three* `V₄`s
through one `σ`, not inside one triangle.** Certified exactly here
(`produce_h0_e.py`, `E2`, all 55):

* `σ` lies in exactly **3** `V₄`s; for each, `C_G(σ) ∩ N_G(V₄) = V₄`;
* the three images of those `V₄`s in the residual `S3 = C_G(σ)/⟨σ⟩` are
  **three distinct order-2 subgroups**, and **they generate `S3`**.

So a single `V₄`-germ sees only *one transposition* of the residual `S3` on
`L_σ`, and imposing full residual-`S3`-equivariance couples the three
`V₄`-stars through `σ`. This is the "second line at each vertex" closure. Note
also (`E3`, exact, all `55 × 55` pairs) that `ℓ_V ∩ L_σ = ∅`: the Note-II
stalk datum lives on a stratum **disjoint** from the line whose germ class it
is supposed to be. The honest object for `x_L` is the leading form on
`D_σ = P_σ × P(W⁻_σ)` — a `C_G(σ)`-equivariant `W⁻`-valued form of bidegree
`(d−m, m)` — whose restrictions over the three `V₄`-lines of `P_σ` are the
three cell data. This coupling was **not** computed here (see §8).

**(4c) The drafted list is missing a constraint class, and it is the decisive
one.** §4b writes "the elliptic class acting purely as a relay (its only sites
are the type-I/II points already listed)". That demotion loses Theorem H0-1:
`E_σ` is not only a relay, it is the **landing target of the exceptional
divisor over the 2-dimensional stratum `P_σ`** whenever the plus half leads,
and the impossibility of that landing (rational source, genus-1 target, no
`C_G(σ)`-fixed point on `E_σ`) is what forces `m` odd. The corrected CSP needs
a **seventh constraint class**:

> **(7) Plus-plane leading half.** At the representative line class, the
> exceptional datum over `P_σ` must land in `L_σ`, not in `E_σ`; equivalently
> `ord_{P_σ}(T⁻) < ord_{P_σ}(T⁺)`, equivalently `m` is odd.

Constraint 7 is a first-order, `O(1)`-cost condition on the stalk label, and
it is the only constraint in this packet that actually removed stalk
components.

---

## 5. B — the reduction argument (verified, with three sharpenings)

**Statement (confirmed).** `𝒜/G` has one line class; `Stab_G(L_σ) = C_G(σ)
= D12` (certified exactly here, `E1`, all 55: the stabiliser of the subspace
`W⁻_σ` in `G` is exactly the centraliser, order 12). A `G`-equivariant section
is by definition a `G`-equivariant assignment of stalk elements to strata,
i.e. exactly a choice, at one representative per orbit, of a **`Stab`-fixed**
stalk element; its `G`-translates fill in the other 54 lines. There is no
"stabiliser-twisted" freedom: a section of a sheaf of *sets* over a single
orbit is a fixed point of the stabiliser action, and twisting would require a
nontrivial cocycle, which has no meaning for a set-valued stalk. **Mixing
branches across lines is therefore impossible.** ✔

**Sharpening 1 (purity is forced, not assumed).** The component labels `(m,r)`
are the multi-order of the landing family, hence conjugation-invariant; all 55
`V₄`s and all 55 involutions are single `G`-classes (recomputed here twice).
So one `(m,r)` is attached to the whole section *before* any equivariance
argument. "Pure-branch" is a theorem, not a case split.

**Sharpening 2 (the `pt` case does not need dominance).** Theorem H0-2
excludes `x_L = pt` outright. So the drafted reduction — "the pure-branch
decisions from A plus the all-`pt` section (excluded by dominance)" — is
correct, and its second half is strictly stronger than drafted.

**Sharpening 3 (the reduction is right but not sufficient).** The reduction is
about *which* stalk components can appear; it says nothing about whether a
component that survives actually supports a section. Because of (4a), the
drafted constraints do not test that, and because of (4b)–(4c) the genuinely
testing constraints are the residual-`S3` coupling and constraint 7. Only
constraint 7 was decided in this packet.

---

## 6. C — the verdict, and its conditionality

**`FIX-H0-H0-PARTIAL`.** `H⁰(𝒜, 𝒯^land)` is **not** decided.

* It is **not** `H⁰ = ∅`: the `m = 1` (Chebyshev, `r = 7` and every odd
  `r ≥ 9`) and odd-`m ≥ 3` (`D_B`) components survive every constraint decided
  here, and no constraint decided here even touches their parameters.
* It is **not** `H⁰ ≠ ∅`: no triple `(x_L, x_I, x_{II})` was exhibited that
  satisfies the residual-`S3` coupling of §4b/(4b); a populated Note-II cell
  is only a `C₃`-shadow of `x_L`.

**Conditionality of the negative part.** The even-`m` exclusion
(`FIX-H0-PURE-EVENM-EMPTY`) and the `pt` exclusion (`FIX-H0-PT-EMPTY`) are
**unconditional theorems** in characteristic 0, resting only on the exact
certificates A1–A6 and on dominance of `f`. They are *not* conditional on the
`m = 1` holes, because they are statements about even `m`, and the holes
(`(1,6)` above line degree 2; even `r ≥ 8` in the `m = 1` row) lie in the
`m = 1` row, which is odd and therefore untouched. Conversely, **the standing
"`H⁰ = ∅`" route now needs exactly the odd rows**: `m = 1` (all `r`) and odd
`m ≥ 3`. Any future `H⁰ = ∅` verdict will be conditional on the `m = 1` holes
in the usual way (unclassified components can only *add* stalk support).

**Problem E headline: OPEN.** Nothing here is an unconditional headline: the
surviving odd rows are exactly where the T5 witness lives.

---

## 7. D — the uniformisation finding (`FIX-H0-D-ONE-TRACE-GEOMETRY`)

All exact (sympy), reconfirmed at 50 digits.

1. `(B³−1)²/B³ = B³ + B⁻³ − 2` identically, so the `D_B` parameter satisfies
   `B³ + B⁻³ = κ₊ + 2 =: κap`.
2. `(z + z⁻¹)³ − 3(z + z⁻¹) = z³ + z⁻³` identically, so the first Chebyshev
   cubic `c³ − 3c = κap` has roots exactly `c = ω^k B + ω^{−k}B⁻¹`,
   `k = 0,1,2` (verified symbolically for all three `k`).
3. The odd-`m` genus-2 reciprocal cover `τ + τ⁻¹ = 2 + (κ₊p³+κ₋q³)/(p³+q³)`
   takes the value `2 + κ₊ = κap` at the character point `[p:q] = [1:0]`,
   i.e. `τ = B^{±3}`.

> **Finding D-1.** Both branches live on the **same reciprocal cover**
> `t ↦ t + t⁻¹`. The odd-`m ≥ 3` `D_B` locus sits at `τ = B³`; the primitive
> `m = 1` Chebyshev locus sits at `τ₁ = ω^k B`, i.e. **directly above it under
> the cubic isogeny `τ₁ ↦ τ₁³`**. The `m = 1` parameter `c` is literally the
> *cube-root trace* of the `D_B` parameter.

4. The Klein constants satisfy the exact identity
   `(κ₊+2)(κ₋+2) = κ₊κ₋ + 2(κ₊+κ₋) + 4 = −1/2 + 13/4 + 4 = 27/4`.
   Hence `−27/(4κap) = −(κ₋+2)` **exactly**, so the **second** Chebyshev cubic
   of the `m = 1` witness, `v³ − 3v = −27/(4κap)`, is
   `(−v)³ − 3(−v) = κ₋ + 2` — the trace-cubic of the **other** character
   surface `S_{κ₋}`.

> **Finding D-2.** The primitive `m = 1` stalk is the fibre product of the two
> cube-root covers of the reciprocal cover over its **two** character points
> `[p:q] = [1:0]` and `[0:1]`: it carries `B₊` (`B₊³+B₊⁻³ = κ₊+2`, giving `c`)
> **and** `B₋` (`B₋³+B₋⁻³ = κ₋+2`, giving `−v`). The `D_B` branch carries only
> `B₊`. Degrees: `3 × 3 = 9` — exactly the degree of the `(1,7)` locus over
> `K = Q(ω, κ₊)` reported by FIX-N2C. The relation `(κ₊+2)(κ₋+2) = 27/4` is
> Klein-specific (it is `κ₊κ₋ = −1/2`, `κ₊+κ₋ = 13/8` in disguise) and is what
> makes the two Chebyshev cubics mirror images.

The numeric values: `κ₊ = 1.8896054962…`, `κap = 3.8896054962…`,
`κ₋+2 = 1.7353945037…`, `B₊ = 1.53443497384…` (real), `c = B₊+B₊⁻¹ =
2.18614066163…`, `B₋ = 0.98500124404 + 0.17254723770 i` (on the unit circle),
`v = −(B₋+B₋⁻¹) = −1.97000248808…`.

---

## 8. Not decided here (the honest list)

1. **The residual-`S3` coupling** of §4b/(4b): does the `D_B` germ, or the
   Chebyshev germ, extend to an `S3`-equivariant leading form
   `φ_σ : P_σ × P(W⁻_σ) ⇢ P(W⁻_σ)` of bidegree `(d−m, m)` whose restrictions
   over the three `V₄`-lines of `P_σ` are the three `C₃`-germs? This is the
   binding constraint after Theorem H0-1 and it is a finite computation once
   `d` is bounded — but `d` is not bounded here.
2. **The vertex elimination at working order 8** as scoped in the brief was
   **not run**. Reason recorded so it is not re-attempted blind: the decisive
   constraint fires at the *leading* plane order (`m ≤ 3` for every classified
   branch), five orders below the drafted working order, and — by (4a) — the
   drafted order-8 vertex gluing has no residual content inside one triangle,
   because the two incident line germs at a type-I vertex are two of the three
   plane-orders of a **single** Note-II cell datum. What order 8 *would* test
   is the cross-`V₄` coupling of item 1, which is not a jet-matching condition
   at a point but an `S3`-equivariance condition on a bidegree-`(d−m, m)` form.
3. **Constraint 4 (type-II relay) is vacuous at first order.** `T_ξX =
   χ₁⊕χ₂⊕χ₃` at every point of `X^{V₄}` (FIX-A1, A1-C4), so each character
   occurs once and [I, Lem 4.5]'s containment `mult_χ(im dq̃) ≤ min(…)` imposes
   nothing. No exact coordinates for the type-II points were needed (as
   FIX-A3 predicted).
4. **Degree bookkeeping.** Restricting `f` to a general plane gives
   `d² − 55m² = deg(map)·deg(image) ≥ 3` (surfaces in `X` have degree in `3Z`
   by Lefschetz), so `d ≥ 8` for `m = 1` and `d ≥ 23` for `m = 3`. Recorded as
   a lower bound only; no upper bound on `d` is known, so this route does not
   close.
5. **The `D12`-point `z_σ`** lies on 7 plus-planes at once and is `D12`-fixed;
   the multiplicity of `f` there is a deep-point constraint that was not
   extracted. Flagged as the natural next probe.
6. The `m = 1` holes ( `(1,6)` above line degree 2; even `r ≥ 8` ) are
   untouched — they are in the surviving row.

---

## 9. Deliverables and timings

| file | role | wall |
|---|---|---|
| `klein_exact.py` | local copy of FIX-A0's exact `Q(ζ₁₁)` library | — |
| `produce_h0.py` | Parts A (certificates A1–A6, all 55) and B (parity lemma solved as a linear system) | 65 s |
| `produce_h0_cd.py` | Part C (branch table) and Part D (uniformisation) | 0.5 s |
| `produce_h0_e.py` | Part E (quotient-complex bookkeeping E1–E4) | 44 s |
| `emit_m2.py` + `m2/eplane_smooth.m2` | smoothness of all 55 plus-plane cubics | 0.6 s |
| `verify_h0.py` | independent verifier, ALGEBRAIC-RECOMPUTE, 27 checks, 0 failures, harness self-test | 9 s |
| `payloads/h0_certificates.json` | per-involution A1–A6 data and the Part-B supports | |
| `payloads/h0_branches.json` | the branch table and the uniformisation data | |
| `payloads/PAYLOAD_geometry.txt`, `PAYLOAD_branch_table.txt`, `PAYLOAD_quotient_complex.txt` | human-readable transcripts | |
| `logs/*.log` | run logs including `M2_EPLANE.log` | |
| `REPLAY.md` | replay instructions and markers | |

No git commits were made and nothing outside this packet was written. Sibling
packets were read-only (`klein_exact.py` copied; the `(1,7)` witness quoted
verbatim from `goal_runs_after_a90dbe1/FIX_N2C_R7_DECISION/payloads/PAYLOAD_witness.txt`).
