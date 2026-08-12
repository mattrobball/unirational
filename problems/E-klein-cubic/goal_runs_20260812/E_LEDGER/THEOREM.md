# E_LEDGER — the intersection ledger E2 / E3 / E4 (the concrete L10)

**Packet:** `goal_runs_20260812/E_LEDGER/` · opened 2026-08-12 (Lane 1 of
`DATA_SPEC_PIPELINE_FLUSH_20260812.md`).
**Headline: Problem E remains OPEN; this packet excludes no degree.**

Mathematical authority: `theory/SCHEME_MAP_CONSEQUENCES_20260812.md` §3.1
(E2 base-orbit congruences, E3 movable-cone LP, E4 system), with
`theory/CONSTRAINT_ADDITIONS_20260811.md` C1 as the cross-check anchor.
Executed against the data spec's Lane-1 pins with flag-and-stop discipline:
where the spec or the authority diverges from what the files and the
mathematics actually give, the divergence is **FLAGGED** in §7 and that
branch is **STOPPED**, never patched by judgement.

*(Filename note: the main document is `THEOREM.md`; the harness refuses
`REPORT.md`.)*

## Exit ledger

```text
E-LEDGER-ANCHORS-PASS
E-LEDGER-C1-REPRODUCED
E-LEDGER-CENSUS-REBUILT
E-LEDGER-FILTER-LEMMA-PROVED
E-LEDGER-E2-CONGRUENCE-TABLE
E-LEDGER-D35-ORDER11-CONDITIONAL
E-LEDGER-E3-COVERING-FAMILIES-CERTIFIED
E-LEDGER-E3-LP-EXACT
E-LEDGER-E3-DEGREE-BOUND-7
E-LEDGER-E4-SYSTEM-EMITTED-RANK-4
E-LEDGER-ND-COROLLARY-CONDITIONAL
E-LEDGER-SPEC-DIVERGENCE-FLAGS
E-LEDGER-NO-DEGREE-EXCLUSION
```

Machine markers: `E_LEDGER_VERIFY_OK` / `ALLGREEN`
(`python3 verifier.py` — **214 checks, 0 failures, 0 skips**; groups
A = 9, B = 8, C = 9, D = 16, E = 6, F = 160, G = 6). Exact integer /
rational arithmetic throughout (`fractions.Fraction`, no floats);
`python3` standard library only; two split primes 331 and 661 wherever the
computation is modular. No `gap`/`gp`/`sage`/`magma` was invoked; no git.

---

## 0. What is and is not claimed

**Claimed.** (i) A calibrated blowup intersection layer: the Chow numbers of
`Bl_Z P^4` for linear centres `Z` of every dimension, *derived* from the
Grothendieck relation on `P(N)` and independently cross-checked two ways
(§1). (ii) The sealed C1 relation family reproduced by that layer's own
expansion at level 3 (§2). (iii) The **mod-p filter lemma, proved here from
orbit sizes**, and the three E2 congruences with their coefficient tables
(§3). (iv) The `d = 35` order-11 instance, stated only in its conditional
form with its hypotheses named in the same sentence (§4). (v) An exactly
certified list of degree-1 covering families of the wonderful model, and the
resulting movable-cone LP in exact rational arithmetic with stored duality
certificates (§5). (vi) The E4 system emitted machine-readably with its rank
and the (empty) set of forced entries, plus one conditional narrowing (§6).

**Not claimed.** No degree is excluded. The LP is an **outer approximation**
of the movable-cone constraints (FLAG E3-DEGREE, §7). The E2 congruences in
the form §3.1 displays require an unproved hypothesis (FLAG E2-G-ORBIT, §7).
Nothing here cuts any of the 22 live `d = 35` cells. See §8.

---

## 1. Calibration (fatal gate) — `scripts/chow.py`

Every blowup intersection number this packet uses comes from one function,
`blowup_numbers(delta)`, built from the standard presentation: for a linear
centre `Z = P^delta ⊂ P^4` of codimension `r = 4 − delta`,
`N = N_{Z/P^4} = O_Z(1)^{⊕r}`, `E = P(N)`, `xi = c_1(O_{P(N)}(1))`,

```
E|_E = −xi ,      Σ_{i=0}^{r} c_i(N) xi^{r−i} = 0 ,      p_*(xi^{r−1+k}) = s_k(N),
deg(H^{4−b} E^b) = ∫_E (−xi)^{b−1} h^{4−b},     h = c_1(O_Z(1)).
```

The relation and the normalisation `∫_E xi^{r−1} h^delta = 1` are the only
inputs. Output (all reproduced by `verifier.py` group A):

| centre | `H⁴` | `H³E` | `H²E²` | `HE³` | `E⁴` | `a_E = codim − 1` |
|---|---:|---:|---:|---:|---:|---:|
| point (`delta = 0`) | 1 | 0 | 0 | **0** | **−1** | 3 |
| line  (`delta = 1`) | 1 | 0 | 0 | 1 | 3 | 2 |
| plane (`delta = 2`) | 1 | 0 | −1 | −2 | −3 | 1 |

The spec's fatal anchor — `H³E = H²E² = HE³ = 0` and `E⁴ = −1` on
`Bl_pt P⁴` — is the first row and it comes out of the implementation.
Two independent cross-checks are run on the same table:

* **Segre closed form** (Fulton 4.4): `π_*(E^b) = (−1)^{b−1} s_{b−r}(N)∩[Z]`
  with `s_k(O(1)^r) = (−1)^k C(r+k−1,k) h^k` gives
  `deg(H^{4−b}E^b) = (−1)^{delta+1} C(b−1, b−4+delta)` — agrees in all 12
  entries.
* **Projection identity**: linear projection away from a centre of dimension
  `delta ≤ 2` has image of dimension `≤ 3`, so `(H − E)^4 = 0`. All three
  rows satisfy it. (Equivalently: `m = d` is permitted for a *single* centre
  of any of the three types, and the level-4 identity then reads `0 = 0`.)

**Derived local forms** (one centre, transverse, multiplicity `m`; these are
the `s_j` and `t_j` of §3.1 in the nondegenerate local model):

```
level 4:  s(point) = m⁴            s(line) = 4dm³ − 3m⁴     s(plane) = 6d²m² − 8dm³ + 3m⁴
level 3:  t(point) = 0             t(line) = m³             t(plane) = 3dm² − 2m³
```

The first of these is exactly the "nondegenerate value `μ⁴`" that §3.1's
`d = 35` corollary invokes; it is **derived here**, not assumed.

## 2. The C1 cross-check at one degree lower (fatal gate)

With `D = q^*H_X = dH − Σ m_k E_k`, the fibre class defined by `3[C] = D³`
(E1, using `H_X³ = 3[pt]` on the cubic threefold), `ν = H·C`,
`ē_k = E_k·C`, and `K_X = O_X(−2)`, the packet's own expansion reproduces
C1 as **polynomial identities in `(d, m_1, …, m_k)`**, all verified exactly:

| C1 item | identity reproduced |
|---|---|
| `C1a` | `K_{Z/X} = K_Z + 2q^*H_X = (2d−5)H + Σ (a_k − 2m_k)E_k`, with `a_k = 3 − dim` |
| `C1b` | `3(d·ν − Σ_k m_k ē_k) ≡ deg(D⁴)` — so `d·ν = Σ m_E e_E` exactly when `D⁴ = 0` |
| `C1c` | `3(2g−2) = 3[(2d−5)ν + Σ (a_k − 2m_k) ē_k]` |
| `C1d` | the level-3 row `3ν = d³ − Σ_k t(delta_k; d, m_k)` |
| `C1e` | the level-4 row `d⁴ = Σ_k s(delta_k; d, m_k)` |

Consistent with the sealed C1. Gate green.

## 3. E2 — the filter lemma, proved in-packet, and the congruences

### 3.1 Setup

`(q^*H_X)^4 = q^*(H_X^4) = 0`. Push forward by `π`: the `d°⁴H⁴` term
survives with degree `d°⁴`; every other term is supported on
`π^{-1}(Bs(T°))`. `π` has connected fibres, so the connected components of
that locus are the preimages of the connected components of `Bs(T°)`, and
the degree splits into one integer per component, constant along `G`-orbits
of components (the tower is choosable `G`-equivariant):

```
d°⁴ = Σ_j n_j s_j ,     n_j = 660/|S_j| ,     s_j ∈ Z.            (E2)
```

### 3.2 Lemma F (the mod-p filter) — PROVED

> **Lemma F.** Let `p ∈ {3, 5, 11}`, `S ≤ G = PSL(2,11)`, `n = 660/|S|`.
> Then `p | n` **iff** `p ∤ |S|`.
>
> *Proof.* `660 = 2²·3·5·11`, so `v_p(660) = 1` for each of `p = 3, 5, 11`.
> By Lagrange `|S|` divides 660, so `v_p(|S|) ≤ 1`, and
> `v_p(n) = v_p(660) − v_p(|S|) = 1 − v_p(|S|)`. Hence `v_p(n) ≥ 1` iff
> `v_p(|S|) = 0`. ∎

The proof uses **only** Lagrange and `p² ∤ 660` — no subgroup
classification. It is also sharp in the hypothesis: for `p = 2`,
`v_2(660) = 2` and the equivalence **fails** at `|S| ∈ {2, 6, 10}` — the
verifier runs that control (group D5), which is why the spec's prime list is
`{11, 5, 3}` and not `{11, 5, 3, 2}`.

Machine support, derived from the 660 matrices themselves (not cited): the
set of subgroup orders of `PSL(2,11)` is `{1,2,3,4,5,6,10,11,12,55,60,660}`
(`e2_congruences.derive_subgroup_orders`, closing `⟨rep, h⟩` over conjugacy
class representatives and all `h`; every subgroup here is 2-generated).

### 3.3 The three congruences

Reducing (E2) mod `p` kills every orbit with `p ∤ |S_j|` and leaves, with
coefficient `n_j mod p`:

| `p` | surviving `\|S\|` (coefficient `n mod p`) | matches §3.1's named classes |
|---|---|---|
| 11 | 11 (**5**), 55 (**1**), *660 (1)* | `C11` (60≡5), `F55` (12≡1) |
| 5 | 5 (**2**), 10 (**1**), 55 (**2**), 60 (**1**), *660 (1)* | `C5`, `D10`, `F55`, `A5` |
| 3 | 3 (**1**), 6 (**2**), 12 (**1**), 60 (**2**), *660 (1)* | `C3`, `S3`/`C6`, `A4`/`D12`, `A5` |

Every coefficient §3.1 prints is reproduced. The italic `660` row is the one
§3.1 drops — see **FLAG E2-G-ORBIT** (§7.1). The right-hand side is
`d°⁴ mod p`; for `p ∤ d°`, `d°⁴ ≡ 1 (mod 5)` and `(mod 3)`, and
`d°⁴ ∈ {1,3,4,5,9} (mod 11)` (the fourth powers mod 11 = the QRs) — all
three recomputed.

Which **census** orbits survive the filter (`|Stab|` from the sealed census,
re-derived here):

* `p = 11`: `pt_C11` only (60 ≡ 5). No census orbit has an `F55` or `A5`
  stabiliser.
* `p = 5`: `pt_D10` (66 ≡ 1), `pt_C5(a)` and `pt_C5(b)` (132 ≡ 2 each).
* `p = 3`: `pt_A4(a)`, `pt_A4(b)`, `pt_D12`, `ell_V`, `Lminus_sigma`,
  `P_sigma` (55 ≡ 1 each); `pt_C6(a)`, `pt_C6(b)`, `C3line` (110 ≡ 2 each).

### 3.4 The census, rebuilt independently

Consumed by citation: the 14 orbits of
`TERMINUS_STRATA_PW/results/t3_localmodels.txt` §(1). Rebuilt from scratch
in this packet at **both** split primes from the shared raw 660-matrix model
`psl211.py`: the arrangement of eigen-subspaces of non-trivial elements,
closed under intersection, returns **940 points / 220 lines / 55 planes in
exactly 14 `G`-orbits** with the cited orbit-size multiset, and every orbit
is labelled by intrinsic data (dimension, orbit size, setwise-stabiliser
type, on/off `X`, containment in the plane orbit). `orbit size × |Stab| =
660` for all 14.

## 4. The `d = 35` order-11 instance — conditional, hypotheses named

`35 ≡ 2 (mod 11)`; `2` is **not** a fourth power mod 11, and
`35⁴ ≡ 5 (mod 11)`. The mod-11 congruence at `d° = 35` therefore reads

```
5·s(C11-orbits) + 1·s(F55-orbits) + 1·s(G-orbit)  ≡  5   (mod 11),
```

and, dropping the `G` term (hypothesis H-PROPER, §7.1), `5^{-1} ≡ 9` gives
**`s(C11) ≡ 1 − 9·s(F55) (mod 11)`** — exactly §3.1's displayed form,
reproduced.

> **The conditional statement, in the only form this packet asserts it.**
> *If* the only connected components of `Bs(T°)` whose stabiliser order is
> divisible by 11 are the 60 `C11`-points (this subsumes both `s(F55) = 0`
> and hypothesis H-PROPER), *and if* the local level-4 contribution at each
> of them is the nondegenerate value `μ⁴` with `μ` the multiplicity, *then*
> `μ⁴ ≡ 1 (mod 11)`, i.e. **`μ ≡ ±1 (mod 11)`**.

Both clauses are hypotheses of the statement, not results of this packet;
the nondegeneracy clause is exactly what the realisation layer on the 22
cells would have to compute. `μ⁴ ≡ 1 (mod 11) ⟺ μ ≡ ±1 (mod 11)` is
verified by direct enumeration (the solutions mod 11 are `{1, 10}`).

The other two rows at `d = 35`, instantiated (note the mod-5 right-hand
side is **0**, not 1, because `5 | 35` — §3.1's "≡ 1" is stated for
`p ∤ d°`):

```
mod 5:  2 s(|S|=5) + s(|S|=10) + 2 s(|S|=55) + s(|S|=60) [+ s(|S|=660)] ≡ 0
mod 3:  s(|S|=3) + 2 s(|S|=6) + s(|S|=12) + 2 s(|S|=60) [+ s(|S|=660)]  ≡ 1
```

## 5. E3 — the movable-cone LP, exact, with certificates

### 5.1 Which line families are covering (Lemma E3-L, unconditional)

A line through `z` with direction `w` meets a centre with span `V` iff
`w ∈ V + ⟨z⟩`. So lines through `z` meeting `C_1,…,C_k` exist iff
`dim ∩_i (V_i + ⟨z⟩) ≥ 2`, and since
`dim(U ∩ U′) ≥ dim U + dim U′ − 5`, that holds **for every `z`** when
`Σ_i (dim V_i + 1) − 5(k−1) ≥ 2`. For census centres (`dim V = 1, 2, 3` for
point, line, plane) exactly these combinations qualify:

```
one centre of any kind;   two planes;   three planes;   one line-centre + one plane.
```

No genericity hypothesis on `z` is used for existence. What genericity *is*
needed is the open part — the general member is contained in no centre and
meets the `k` centres at `k` distinct points — and that is certified by
witnesses.

### 5.2 What a line's strict transform meets (Lemma E3-T)

On the wonderful model (points blown up, then lines, then planes), for a
line `l` not inside any member and meeting the arrangement `A` at
`y_1,…,y_s` — `A` being closed under intersection, each `y` has a unique
minimal member `V_min(y)` — one has `D_V·c = #{t : V_min(y_t) = V}`: the
deeper stratum absorbs the incidence and the larger members are separated
from `l` by the earlier blowups. The machine applies exactly this rule, so
e.g. a line through a `V4`-type-I point (which lies on a plus-plane) scores
for the point orbit only.

### 5.3 Certification (both primes, all agreeing)

A family is CERTIFIED only if **one fixed tuple of centres** admits a clean
witness line with the exact target incidence through **every** one of 12
sampled general points. Result at `p = 331` and `p = 661`, identical:

* 14 rows `d ≥ m_i`, one per orbit;
* `d ≥ 2 m_{P_sigma}` and `d ≥ 3 m_{P_sigma}`;
* `d ≥ m_{C3line} + m_{P_sigma}`, `d ≥ m_{ell_V} + m_{P_sigma}`,
  `d ≥ m_{Lminus_sigma} + m_{P_sigma}`.

Negative controls, all confirming Lemma E3-L: four planes; two line-centres
(all six orbit pairs); a point-centre plus a plane; a line-centre plus two
planes — eleven controls in all, and **none** is a covering family (the best
tuple in any control covers at most 4 of the 12 general points; the sporadic
hits are the degenerate cases where the two centres meet, and Lemma E3-T then
collapses the incidence to the shared deeper stratum).

### 5.4 The LP

Variables `x_i = m_i/d` (the system is homogeneous of degree 1), rows
`Σ a_i x_i ≤ 1`, exact `Fraction` simplex with Bland's rule; every optimum is
stored with **both** a primal and a dual vector and re-verified
independently by exact LP duality (`lp.check_certificate`).

**Outcome.** `max x_{P_sigma} = 1/3` — i.e. `m_{P_sigma} ≤ ⌊d/3⌋`, which is
`m_{P_sigma} ≤ 11` at `d = 35` — with the certificate
`x = (0,…,0,1/3)`, `y` supported on the `three_planes` row with value `1/3`.
For all other 13 orbits `max x_i = 1`, i.e. the degree-1 movable cone alone
gives only `m_i ≤ d` there.

Adding the one sealed non-E3 coupling that is linear in the same variables
— `3 m_{P_sigma} ≤ 2 m_{ell_V}` (the order-cone bound `ord_R ≥ ⌈3m/2⌉` of
`theory/FIX_II_jets.md`:42, relaxed to a rational inequality) — changes no
optimum: the coupling bounds `x_P` by `2/3·x_{ell_V} ≤ 2/3`, which the
`three_planes` row already beats.

**With the sealed pinned lower bounds at `d = 35`** (table in
`scripts/e3_movable.py::PINNED_D35`, each entry carrying its citation:
`pt_C11 ≥ 1`, `pt_D10 ≥ 1`, `pt_A4(a),(b) ≥ 2`, `pt_C5(a),(b) ≥ 1`,
`pt_D12 ≥ 1`, `ell_V ≥ 6`, `P_sigma ≥ 1`; `pt_V4I`, `pt_C6(a),(b)`,
`C3line`, `Lminus_sigma` have no sealed positive bound at `d = 35`):

* the system is **FEASIBLE** at `d = 35` — no row is violated, so **E3
  excludes no degree**;
* the binding row is `d ≥ m_{ell_V} + m_{P_sigma} ≥ 6 + 1`, giving the
  degree bound **`d ≥ 7`** from the certified degree-1 movable cone together
  with the pinning. This is far weaker than the sealed window (`d = 35` is
  the first open degree); it is recorded because it is what E3 actually
  delivers, not as progress.

## 6. E4 — the system, machine-readable, with rank

`results/e_ledger.json → e4` carries the full declaration: 62 variables
(`m_i`, `s_i`, `s_G`, `s_extra`, `n_extra`, `t_i`, `t_G`, `ν`, `ē_i`, `g`)
each with kind and role, and four equations with their sources:

```
R1  Σ_i n_i s_i + s_G + Σ_extra n_extra s_extra      = d⁴          (level 4)
R2  Σ_i n_i t_i + t_G + 3ν                            = d³          (level 3)
R3  d ν − Σ_i m_i ē_i                                 = 0           (C1b)
R4  (2d−5) ν + Σ_i (a_i − 2m_i) ē_i − 2g + 2          = 0           (C1c)
```

`ē_i := Σ_{E ∈ orbit i} E·C` is the **orbit-summed** fibre degree (the
generic fibre `C` is not `G`-invariant, so per-divisor `e_E` is not
orbit-constant; the orbit sum is).

**Rank of the linear part: 4**, over `Q(d, m_1,…,m_14)` — computed exactly
at five integer specialisations (all giving 4) and certified by the explicit
non-singular `4 × 4` minor on the columns
`(s_G, t_G, ē_{pt_C11}, g)`. **Forced entries: none** — 4 equations in 46
declared columns plus the unknown extra-orbit columns that Group G forces to
exist. This is the honest state of "one linear system over the census": it
is the E2 congruences (the mod-p reductions of R1, R2) and the E3
inequalities that carry the arithmetic, not the rank.

**One conditional narrowing** (`e4_nd_corollary`, CONDITIONAL, not a
result). At an **isolated** point centre — the census point orbits occurring
in no crossing of `t3_localmodels.txt` §(3) are `pt_C11`, `pt_C5(a)`,
`pt_C5(b)` — the packet's own Chow layer gives `E·D³ = μ³`, while
`E·D³ = 3(E·C)` with `E·C ∈ Z`; hence `3 | μ³`, so `3 | μ`, **under
hypothesis ND** (the only exceptional divisor over the centre is the first
blowup, with multiplicity `μ`). Combined with the `d = 35` order-11
conditional of §4 and E3's `μ ≤ d`, the surviving candidates at `d = 35` are
`μ ∈ {12, 21}`. Every clause of this is a hypothesis; nothing is excluded.

## 7. FLAGS — divergences found, branches stopped

### 7.1 FLAG E2-G-ORBIT (load-bearing)

§3.1's displayed congruences drop the `|S| = 660` row with the parenthetical
"`G` (excluded: proper components)". **Lemma F does not exclude it**: 11, 5
and 3 all divide 660, so a `G`-stabilised connected component of `Bs(T°)`
has orbit size `n = 1`, survives every reduction, and enters each congruence
with coefficient 1 and an unconstrained integer — which removes all bite.
Machine fact from this packet's rebuild, at both primes: **every one of the
1485 pairs of plus-planes meets** (1320 in a point, 165 in a line), so the
union of the 55 plus-planes is **connected** and `G`-stable; `Prop 1.3` of
`STAGE2_ODD_ORDER_PINNING` puts all 55 plus-planes in `Bs(T)` for every `d`.
If they are in `Bs(T°)` too, that union is exactly such a component.

Branch STOPPED. Both forms are reported and neither is exercised:
(i) §3.1's form, valid under **HYPOTHESIS H-PROPER** — `G` acts without a
fixed point on the set of connected components of `Bs(T°)`; (ii) the
unconditional form, carrying the extra term `s_G`. Every conditional
statement in §4 names the hypothesis it needs.

### 7.2 FLAG E3-DEGREE

Only degree-1 covering families are enumerated. Degree ≥ 2 families exist
and are strictly stronger: a general 2-plane `Π` through `z` meets **all 55**
plus-planes (two 2-planes in `P⁴` always meet), so a plane curve of degree
`e` in `Π` through `z` and through `min(55, e(e+3)/2 − 1)` of those points
would give `e·d ≥ min(55, e(e+3)/2 − 1)·m_{P_sigma}`, i.e. `d ≥ (53/9)m_P`
at `e = 9`, beating `d ≥ 3m_P`. Certifying it requires irreducibility of a
member of a 0-dimensional linear system through 54 **non-general** points,
which this packet does not establish. Branch STOPPED. **Consequence,
binding on every use of §5: the LP is an OUTER approximation — its feasible
set contains the true movable-cone-constrained set.** No statement of the
form "the movable cone permits `x`" may be read out of it.

### 7.3 FLAG E-REDUCED (semantics)

E2/E3/E4 are statements about the **reduced** representative `T°` and its
degree `d°`; the sealed pinning statements of `STAGE2_*` are about `T` at
degree `d`. They coincide exactly when `gcd(T) = 1`. The `m_E` of this
packet is `ord_E(q^*H_X) = ord_C(T°)`, the order of vanishing along the
centre of the ideal generated by the five coordinates; several sealed rows
bound only a *part* (`T⁻` or `T⁺`) and are used here only through the
implied bound on the minimum. The §5.4 pinned table is therefore a table of
bounds for `T`, imported to `T°` under `gcd(T) = 1`.

### 7.4 FLAG E2-EXTRA-ORBITS

(E2) sums over **all** `G`-orbits of connected components of `Bs(T°)`,
including the unknown extra orbits that Group G (`AMBIENT_HODGE_REES_BRIDGE`
Thm B) forces to exist. The census supplies candidate components only. The
E4 emission declares the extra columns explicitly; the congruence tables of
§3.3 are stated over **all** subgroup orders, and only the "census orbits
surviving the filter" list of §3.3 is census-restricted.

### 7.5 Minor observations (not divergences)

* §3.1's `p = 3` row lists a `C3` class (orbit 220); the census has **no**
  orbit with pointwise-and-setwise stabiliser `C3` (`C3line` has
  `Stab_G = C6`). The general table is right; the census simply does not
  realise that class. Same for `S3`, `F55`, `A5`.
* §3.1's "`d°⁴ ≡ 1 mod 5` and `mod 3` (Fermat)" holds for `p ∤ d°`; at
  `d° = 35` the mod-5 right-hand side is 0. Instantiated correctly in §4.
* Only the *orders* of subgroups matter for the coefficients, so the two
  order-6 classes (`C6`, `S3`) and the two order-12 classes (`A4`, `D12`)
  share a row. The packet's derivation is by order and needs no subgroup
  classification.

## 8. Not claimed

* No degree is excluded, and nothing here cuts any of the 22 live `d = 35`
  cells. The first open window stays at `d = 35`.
* `μ ≡ ±1 (mod 11)` is **not** claimed: it is the conclusion of a two-clause
  conditional (§4), and both clauses are open.
* `μ ∈ {12, 21}` at `d = 35` is **not** claimed: it adds hypothesis ND on
  top of §4's clauses (§6).
* The LP's `m_{P_sigma} ≤ ⌊d/3⌋` is a valid necessary condition but is
  **not** the movable-cone bound: FLAG E3-DEGREE says the true bound is at
  least as strong and probably strictly stronger.
* The E2 congruences as §3.1 displays them are **not** claimed
  unconditionally: FLAG E2-G-ORBIT.
* The census constants are consumed by citation and re-derived; nothing here
  corrects them.
* No claim is made about char-0 lifting beyond the repository standard: the
  arrangement facts are exact finite computations at two split primes 331
  and 661, agreeing; the intersection-theory layer, Lemma F, Lemma E3-L,
  Lemma E3-T and the LP are prime-free.

## 9. Files

```
THEOREM.md                     this document
verifier.py                    214 checks, groups A-G; E_LEDGER_VERIFY_OK / ALLGREEN
REGISTRATION_SNIPPET.md        manifest row (no manifest edit made by this packet)
scripts/chow.py                blowup Chow ring, anchors, C1 reproduction
scripts/census.py              cited census + independent arrangement rebuild + labeller
scripts/psl211.py              byte-identical copy of ODDZERO_AUDIT/scripts/psl211.py
scripts/e2_congruences.py      Lemma F, subgroup orders, congruences, d = 35 instance
scripts/e3_movable.py          Lemmas E3-L / E3-T, family certification, pinned table
scripts/lp.py                  exact rational simplex with stored duality certificates
scripts/e4_system.py           the E4 emission, rank, ND corollary
scripts/pipeline.py            producer; writes results/e_ledger.json
results/e_ledger.json          every number in this document
results/verifier_output.json   per-check record
results/verifier_stdout.txt    human-readable check log
```

Replay: `python3 scripts/pipeline.py && python3 verifier.py` (about 4
minutes; `E_LEDGER_PRIMES=331` halves it).

## Director adjudication (2026-08-12, appended at sealing)

Referee: `REFEREE_REPORT.md` (replay 214/214 byte-identical; 116
independent referee checks, 0 failures). R1/R2/R4/R5 CONFIRMED (with
the §5.3 rewording adopted and every named hypothesis shown necessary
by enlargement controls); R6 CORRECTED — the "no forced entries" claim
had a non-sequitur justification, and the referee ran the correct
rowspace test itself: the conclusion is true and now certified (test to
be folded into verifier G3 at next touch). R3: this packet's
E2-G-ORBIT flag is CONFIRMED as against the extraction document's
original form — and the referee supplied the rescue: re-indexed by
G-orbits of irreducible exceptional divisors, the full-stabilizer row
requires only **H-IRR** (no G-invariant IRREDUCIBLE center; G simple,
minimum census orbit 55), which the reducible plane union does not
violate (its 55 divisors enter with coefficient 55 ≡ 0 mod 11 and mod
5). The displayed congruence tables therefore stand under H-IRR; the
correction banner is on `theory/SCHEME_MAP_CONSEQUENCES_20260812.md`
§3.1. The d = 35 conditional is to be read divisor-wise per the
referee's recommendation.
