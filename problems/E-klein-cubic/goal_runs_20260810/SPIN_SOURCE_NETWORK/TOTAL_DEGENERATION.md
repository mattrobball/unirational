# Total degeneration: why no point cell of the spin census can close

`SUPPORT_CENSUS.md` §6 boxes five surviving families.  Three of them —
`(O1)` in its point layer, `(O2)`, `(O3)` — consist **entirely of point
supports**, and the point layer of `(O5)` does too.  `(O4)` was already
shown unclosable by an explicit witness (`O4_EIGENPLANE_CURVES.md`,
Theorem O4-5).

This file settles the remaining four the same way, and with a **single**
witness that works in all nine point cells at once.  The verdict is that the
ambient Hodge-support method, ported or not, **cannot decide** the spin flank:
it constrains the pair `(Y, p)` and the abstract Hodge structure `T`, and
every constraint it produces at a point support is satisfied by the
tautological datum in which the exceptional fibre maps finitely onto the
whole of the `V14`.

Machine: `python3 verify_total_degeneration.py` → `TOTAL_DEGENERATION_OK`,
87 assertions, exact, under a second.  Section references `§A`-`§H` point at
that script.  The `(O3)` layer has its own file and verifier
(`O3_ODD_ORDER_POINTS.md`, `verify_o3_odd_order.py` → `O3_ODD_ORDER_OK`,
86 assertions).

Standing notation as in `THEOREM_SPIN_HODGE_SUPPORT.md`:
`G = PSL(2,F_11)`, `Gtilde = SL(2,F_11)`, `V` a faithful spin source,
`n = dim V >= 6`, `phi : P(V) --> V14` a hypothetical dominant
`G`-equivariant rational map, `Y = Proj R(I_phi)bar` its normalized graph,
`p : Y -> P(V)`, `q : Y -> V14`, `T = H^3(V14,Q)(1)`,
`chi_T = (10,2,-2,0,2,-1)` on element orders `(1,2,3,5,6,11)`.
`Y_x = p^{-1}(x)`, `Z_x = q(Y_x)`.

---

## 1. Exactly what the package constrains at a point support

This is the complete list.  Let `x in P(V)` be a point support of a block
`M_{x,j_0}` carrying part of `alpha_phi(T)`, `H = Stab_G(x)`, `W_x` the
carrier.

| | constraint | source |
|---|---|---|
| **C1** | `H = H_0 in Sigma_spin = {1,C_2,C_3,C_5,C_6,C_11,S_3,D_10,F_55}`; orbit size `660/|H| in {12,60,66,110,132,220,330,660}` | Prop C1, C2, Cor C3 |
| **C2** | `j_0 = 4-n` | Prop S5 |
| **C3** | `W_x` is a weight-three `H`-sub-Hodge structure of `H^{j_0}(Y_x, IC_Y^H)`, `= H^3(Y_x,Q)` when `Y` is smooth near `Y_x` | Prop S5 |
| **C4** | `dim Y_x >= 2` | Prop S5 |
| **C5** | `Y_x -> Z_x = q(Y_x) subset V14` is finite and `H`-equivariant, `dim Z_x >= 2`; hence also `dim Y_x <= 3` | Cor S6 |
| **C6** | `Hom_{HS,H}(Res_H T, W_x(1)) != 0` | (AHS-spin), Thm S3(3) |
| **C7** | the weight-one abelian factor `A_x` contains at least `k(H)` copies of `E_{-11}`, with `k = 1` except `k(C_11) = k(F_55) = 5` | Cor S4 |
| **C8** | `x in Bs(phi)`; and *if* the orbit consists of irreducible base **components**, refined Bézout gives `660/|H| <= d^{n-1}` | Thm S3(1), §3.2 |

Nothing else.  In particular the package contains **no upper bound on
`dim Y_x`** beyond the trivial `<= 3` of C5, and **no constraint on `q`**
beyond its existence, properness and the projection formula used once in
Theorem S1.

---

## 2. Theorem W1 — the total-degeneration witness

> **Theorem W1.**  Fix any `n >= 6`, any point `x in P(V)` and any
> `H = Stab_G(x) in Sigma_spin`.  The datum
> \[
> \boxed{\;Y_x=V_{14},\qquad q|_{Y_x}=\mathrm{id}_{V_{14}},\qquad
> W_x=H^3(V_{14},\mathbf Q)=T(-1)\;}
> \]
> satisfies **C1-C8**.  Moreover:
>
> 1. the Hom of **C6** is not merely nonzero — it contains the identity, so
>    it is an **isomorphism** `Res_H T -> W_x(1)`, and its dimension over
>    `C` is `dim End_H(Res_H T) = (100, 52, 36, 20, 20, 20, 12, 10, 2)` in
>    cells `P0,...,P8` (§B);
> 2. the abelian factor is `A_x = J(V_{14}) ~ E_{-11}^5` (Theorem S0(2)), so
>    the floor of **C7** is met for every `H` and met **exactly** at
>    `H = C_11` and `H = F_55`, where `k = 5`;
> 3. none of the twelve cross-cutting kills `K-a` … `K-l` of
>    `SUPPORT_CENSUS.md` §5.3 applies (§B, kill audit).

*Proof.*  **C1** is the hypothesis.  **C2** is Prop S5, which is a statement
about the perverse degree only.  **C5**: `Z_x = V14` is a closed
`H`-invariant subvariety of `V14` of dimension `3 >= 2`, and the identity is
finite; `dim Y_x = 3 <= 3`.  **C4**: `3 >= 2`.  **C3**: `H^3(V14,Q)` is pure
of weight three because `V14` is smooth projective, and it is an
`H`-submodule of itself; with `Y_x` smooth the stalk identification of
Prop S5 reads `W_x subset H^3(Y_x,Q) = H^3(V14,Q)`, an equality.  **C6**:
`W_x(1) = H^3(V14,Q)(1) = T`, so `Res_H T -> W_x(1)` may be taken to be the
identity; it is `H`-equivariant and a morphism of Hodge structures, hence a
nonzero element of the Hom in (AHS-spin).  **C7**: the image is all of `T`,
so `A_x` is the abelian variety with `H^1(A_x,Q) = T`, which by Theorem S0(2)
is `J(V14) ~ E_{-11}^5`; five copies is `>= k(H)` for every `H` in the table
of Cor S4, with equality exactly at `C_11` and `F_55`.  **C8**: `x` lies in
`Bs(phi)` by Theorem S3(1) — that is a hypothesis on the configuration, not
on the witness — and the capacity row for the orbit is satisfied for all
even `d >= 4` in every cell, and for all even `d >= 2` in cell `P8`
(§B, §E of `verify_o3_odd_order.py`).

For (3), the audit is cell-independent and is printed in full by the
verifier: `K-a` is a hypothesis on `phi`; `K-b` fails because
`dim Y_x = 3 > 1`; `K-c` fails because the orbit sizes `12, 60, 66, 110,
132, 220, 330, 660` avoid `1, 11, 55`; `K-d` fails because
`Res_H W_x(1) = Res_H T` contains the trivial character at every
`H != C_11, F_55` and is never sign- or `psi_3`-isotypic
(`Res_{S_3}T = 2.triv + 4.std`, `Res_{D_10}T = 2.triv + 2W_1 + 2W_2`,
`Res_{C_6}T` omits only `psi_3`); `K-e` fails because
`A_x = J(V14) ~ E_{-11}^5` and `Hom(E_sigma, E_{-11}) = 0` means precisely
that `E_sigma` does **not** occur in it; `K-f`, `K-i`, `K-j`, `K-k`, `K-l`
are statements about positive-dimensional supports; `K-g` needs `N = 660`
**and** `d = 2`, and `d = 2` is excluded in every cell but `P8` where the
orbit is 12; `K-h` needs `H_0 != H`, impossible at a point.  `QED`

### 2.1 Why this is a witness and not a cheat

The datum is an honest projective variety with an honest `H`-action and an
honest polarizable weight-three Hodge structure.  The hypothetical content —
that it occurs as `p^{-1}(x)` for an actual dominant `phi` — is **exactly**
the hypothetical content of `O4_EIGENPLANE_CURVES.md` Theorem O4-5, whose
Hesse cubic is likewise an honest curve that is not known to be a strict
support of an actual map.  The standard is the packet's own
(`ADVERSARIAL_TESTS.md` §T3: *"is the witness real, or an existence claim in
disguise? — REAL"*), and W1 meets it in the same sense: the object exists,
its equivariant Hodge theory is computed, and every necessary condition is
checked against it.

What W1 does **not** claim: that total degeneration occurs; that a dominant
`phi` exists; or that the skyscraper summand at `x` is forced.  It claims
only that the package cannot rule the configuration out.

---

## 3. What total degeneration is, geometrically

> **Lemma W0.**  `Z_x = V14` if and only if **every** fibre closure of `phi`
> passes through `x`:
> \[
> \overline{\phi^{-1}(v)}\ni x\qquad\text{for all }v\in V_{14}.
> \]

*Proof.*  `Y` maps finitely onto the closure `Gamma` of the graph in
`P(V) x V14`, so `Z_x = q(p^{-1}(x)) = Gamma_x`, and `(x,v) in Gamma` iff
`x in p(q^{-1}(v)) = overline{phi^{-1}(v)}`.  `QED`

This is a completely ordinary phenomenon.  For the linear projection
`P^5 --> P^3`, `[x_0:\dots:x_5] \mapsto [x_1:x_2:x_3:x_4]`, every fibre
closure is a plane through `x = (1:0:\dots:0)` and the graph fibre over `x`
is the **whole target**.  Any map whose defining forms all vanish at `x`
with leading terms sweeping the target behaves the same way.  Nothing in the
spin situation makes it exotic: the maps in question are given by forms of
even degree `d` vanishing on a base locus that provably contains 364
prescribed points (`O3_ODD_ORDER_POINTS.md` Thm O3-2).

Two structural facts, both new, both consequences of C5 and worth recording
because they show the package's own geometry is compatible with total
degeneration rather than hostile to it.

> **Lemma W0' (the base locus is never finite; a lower bound on its
> dimension).**  For every dominant `G`-equivariant `phi : P(V) --> V14`,
> \[
> \dim \operatorname{Bs}(\phi)\ \ge\ n-5 .
> \]
> In particular on `P(U) = P^5` the base locus has a component of dimension
> at least one: `Bs(phi)` is **never** a finite set of points.

*Proof.*  `Exc(p)` is nonempty: `Bs(phi) != empty` by Theorem K4 (the 352
incidence points), and `p` is an isomorphism exactly over the complement of
`Bs(phi)`.  `p : Y -> P(V)` is proper birational, `Y` is normal and `P(V)` is
smooth (hence locally factorial), so by purity of the exceptional locus
(van der Waerden) every irreducible component `E_i` of `Exc(p)` has
codimension one in `Y`, i.e. `dim E_i = n-2`.  By C5 every fibre of `p` has
dimension at most `3`, since `p^{-1}(x) -> V14` is finite.  Hence
`dim p(E_i) >= (n-2)-3 = n-5`, and `p(Exc(p)) subset Bs(phi)`.  `QED`

(Consistency: Theorem S3(1) gives `dim Bs(phi) <= n-3`, and `n-5 <= n-3`.
At `n = 6` the window is `1 <= dim Bs <= 3`.)

> **Remark W0'' (first-order data are not the whole fibre).**  Restricting
> `phi` to the lines through `x` produces a rational map
> `P(T_x) = P^{n-2} --> Z_x`, so *if* `Z_x` were the image of the
> tangent-direction family alone, total degeneration at `x` would require a
> dominant `H`-equivariant rational map `P^{n-2} --> V14`.  It is not: `Y_x`
> is a fibre of the blowup of `I_phi`, computed by the fibre cone
> `Proj (+)_k I^k (x) k(x)`, and arcs through `x` with degenerate leading
> terms contribute limits that no tangent direction sees.  So the
> first-order question is a **sufficient** route to total degeneration, not
> a necessary one, and the package cannot convert it into an obstruction.

---

## 4. Theorem W2 — no point cell closes, hence the census does not close

> **Theorem W2.**  Let `c` be any of the nine point cells `P0,...,P8` of
> `SUPPORT_CENSUS.md` §5.1.  No argument built solely from Theorems S0-S3,
> Corollaries S4, S6, Proposition S5 and the kills `K-a`…`K-l` can prove
> that `c` carries no part of `alpha_phi(T)`.

*Proof.*  Such an argument would have to contradict at least one of C1-C8
for every admissible `(Y_x, q|_{Y_x}, W_x)`.  Theorem W1 exhibits an
admissible triple for every cell.  `QED`

> **Corollary W2.1 (the census is unclosable).**  `(O1)` contains cell `P0`,
> `(O2)` is cells `P5`, `P6`, `(O3)` is cells `P7`, `P8`, `(O5)` contains
> cells `P4`-`P8` inside the revived strata, and `(O4)` is witnessed by
> Theorem O4-5.  Hence **every** boxed open family carries a witness, the
> exit `SPIN-SUPPORT-CENSUS-CLOSED` is unreachable by this machinery, and the
> `FIX_IX_v14.md` Cor IX.5 consequence chain cannot be triggered by it.

> **Corollary W2.2 (the ambient packet inherits this).**  The proof of W1
> uses only `n >= 4`, `dim V14 = 3` and the purity of `H^3` of the target.
> Run at `n = 5` with target the Klein cubic `X` it gives the same verdict
> for the point cells of `RT_SPLIT_AND_DICHOTOMY/THEOREM_POINT_SUPPORT.md`.
> Nothing there is damaged: that file's exit is
> `POINT-SUPPORT-CHARACTERIZED` and it already records that
> `FREE-SUPPORT-EXCLUDED` is unavailable.  W1 upgrades "unavailable" to
> "unavailable in principle".

---

## 5. Theorem W3 — the pointwise-kernel selection rule, and two new kills

The one place where the package still bites is the **positive-dimensional**
layer, and there it bites harder than the census recorded.

> **Theorem W3 (selection rule).**  Let `S` be an irreducible strict support
> with `dim S = s >= 1`, pointwise kernel `H_0` (so `H_0` acts trivially on
> `S`), and let `IC_{Sbar}(N) subset M_{S,j_0}` be a simple constituent of
> the equivariant strict-support block.  Then `N = L (x) rho` with `L` an
> irreducible local system on `S^{sm}` and `rho in Irr(H_0)`, the carrier is
> \[
> IH^{\,s+4-n-j_0}(\overline S,\mathcal L)\otimes\rho ,
> \]
> with `H_0` acting through `rho` alone, and (5.2) forces
> \[
> \boxed{\ \rho\ \text{occurs in}\ \operatorname{Res}_{H_0}T\ }.
> \]

*Proof.*  `H_0` acts trivially on `S`, so the equivariant fundamental group
of `S^{sm}` for `H_0` is the direct product `pi_1(S^{sm}) x H_0`, and its
irreducible representations are exactly the outer tensor products
`L (x) rho`.  Hence an irreducible `H_0`-equivariant local system on
`S^{sm}` has this shape and
`IH^i(Sbar, L (x) rho) = IH^i(Sbar,L) (x) rho` as `H_0`-modules, with `H_0`
acting only on the second factor.  A nonzero
`Hom_{HS,H'}(Res_{H'}T, \cdot(1))` restricts to a nonzero
`Hom_{H_0}(Res_{H_0}T, IH^i (x) rho)`, and since `H_0` acts on the target
`rho`-isotypically, `rho` must occur in `Res_{H_0}T`.  `QED`

The dead channels, computed exactly (§C):

| `H_0` | `Irr(H_0)` occurring in `Res_{H_0}T` | **dead** channels |
|---|---|---|
| `1` | `triv` (mult 10) | none |
| `C_2` | `triv` (6), `sign` (4) | none |
| `C_3` | `triv` (2), `omega` (4), `omega^2` (4) | none |
| `C_5` | `triv` (2), each `psi_k` (2) | none |
| `C_6` | `psi_0,psi_1,psi_2,psi_4,psi_5` (2 each) | `psi_3` |
| `C_11` | each `psi_k`, `k != 0` (1 each) | **`psi_0` — the constant channel** |
| `S_3` | `triv` (2), `std` (4) | `sign` |
| `D_10` | `triv` (2), `W_1` (2), `W_2` (2) | `sign` |
| `F_55` | `theta_1` (1), `theta_2` (1) | **all five linear characters** |

Two of these rows are new:

> **Kill K-m.**  A positive-dimensional strict support contained in
> `P(V)^{C_11}` carries nothing in the **constant-coefficient** channel, for
> every spin source, every multiplicity `m`, every degree and every
> dimension.  (`Res_{C_11}T` has no invariants.)

> **Kill K-n.**  A positive-dimensional strict support contained in
> `P(V)^{F_55}` carries nothing in **any rank-one** equivariant channel.  The
> only surviving equivariant structures are the two five-dimensional
> `theta_1, theta_2`.  (`Res_{F_55}T` contains no linear character of
> `F_55`.)

`K-m` and `K-n` subsume, at `H_0 = C_11, F_55`, the constant-coefficient half
of Prop C8 / `K-f` — and they prove it by character arithmetic rather than by
`IH^1(P^k) = 0`, so they apply to supports of any shape inside those strata,
not only to the whole linear stratum.  The `C_6`, `S_3`, `D_10` rows
reproduce `K-d` in the case `H = H_0`.

**Scope, stated to avoid over-reading.**  W3 is an `H_0`-level rule and is
therefore *coarser* than an `H`-level analysis whenever `H_0 subsetneq H`.
Cell `(O4)` is the example: there `H_0 = C_2` and `H = C_6`, W3 gives nothing
(`C_2` has no dead channel), and the finer statement is
`O4_EIGENPLANE_CURVES.md` Prop O4-3, which uses the residual `C_3`-action on
the curve.  No contradiction, and no overlap.

**Why the new kills do not close cells `S5` and `S8`.**  Two reasons, each
sufficient: (i) the `theta_i` channels survive at `F_55` and every nontrivial
`psi_k` survives at `C_11`; (ii) every stratum contains **points**, and a
point of `P(V)^{C_11}` or `P(V)^{F_55}` is cell `P7` or `P8`, which W1
witnesses.  A stratum-level kill never empties a cell that has a point layer.

---

## 6. The boxed insufficiency statement

```text
+---------------------------------------------------------------------------+
| SPIN HODGE-SUPPORT METHOD: INSUFFICIENT.  What a stronger method needs.    |
|                                                                           |
| The package (Thms S0-S3, Cors S4, S6, Prop S5, kills K-a..K-n) is a        |
| function of                                                               |
|         ( Y, p, the abstract G-Hodge structure T )                        |
| alone.  It uses q only through its existence, its properness, and one      |
| projection-formula step (Thm S1).  Consequently it cannot see, and does    |
| not bound, the quantity                                                   |
|                                                                           |
|         delta(x)  :=  dim q(p^{-1}(x))   for x in Bs(phi),                |
|                                                                           |
| beyond  2 <= delta(x) <= 3  at a carrying point support.  Every necessary  |
| condition it imposes is satisfied by delta(x) = 3 with the tautological    |
| carrier W_x = q^* H^3(V14).                                               |
|                                                                           |
| RESIDUAL 1 (the decisive one).  Prove, for a dominant G-equivariant        |
|   phi : P(V) --> V14 with V a faithful spin source, that                   |
|         delta(x) <= 1   for some x in each G-orbit of Bs(phi),            |
|   or at least at the 352 mandatory incidence points or the 12 mandatory    |
|   F_55-points.  Equivalently (Lemma W0): show that NOT every fibre         |
|   closure of phi can pass through such a point.  This is a statement       |
|   about the map -- its degree, the local structure of I_phi at x, the      |
|   fibre cone -- and is invisible to the support decomposition.            |
|                                                                           |
| RESIDUAL 2.  Even granting delta(x) = 2, exclude H-equivariant irregular   |
|   surfaces with E_{-11} in the Albanese as finite covers of ample          |
|   divisors of V14.  Prop O2-3 narrows this (a SMOOTH ample divisor of      |
|   V14 has irregularity 0, by Lefschetz and b_1(V14) = 0), so the E_{-11}   |
|   would have to be created by branching or by singularities -- but         |
|   branched covers of regular surfaces have unbounded irregularity, so      |
|   the narrowing is not a kill.                                            |
|                                                                           |
| RESIDUAL 3.  Nonconstant local systems on the eigen-strata (cell O4g)      |
|   remain untouched, as `O4_EIGENPLANE_CURVES.md` sec.8 already recorded.  |
|                                                                           |
| NOT a residual: the arithmetic.  O3_ODD_ORDER_POINTS.md Thm O3-4 proves    |
| that the CM demand at C_11 / F_55 -- Q(zeta_11)-multiplication AND         |
| E_{-11}^5-isogeny at once -- is not merely consistent but FORCED and       |
| REALISED: the CM type is the quadratic-residue type, which is induced      |
| from Q(sqrt(-11)), and J(V14) itself is a model.  There is no              |
| field-mismatch kill to be found.                                          |
+---------------------------------------------------------------------------+
```

---

## 7. Adversarial tests

### W-T1.  The mandatory `D_12` test (Cor IX.6) — PASSED

`theory/FIX_IX_v14.md` Cor IX.6: the `V14` **is** `D_12`-spin-unirational, by
a realised dominant `D_12`-equivariant map.  Two verdicts are recorded in
this file and both must be consistent with it.

* **W1 is a witness, not a kill.**  A witness cannot contradict an existence
  theorem: it only says a configuration is not excluded.  Informatively, the
  realised `D_12`-map is itself free to be totally degenerate at any of its
  own base points, and `dim T^{D_12} = 2 > 0` (§H), so the channel it needs
  is left open.
* **W3's new kills `K-m`, `K-n`** live at strata whose pointwise kernel has
  order divisible by 11.  `11` does not divide `|D_12| = 12`, so `D_12`
  contains no element of order 11 and neither kill is visible to the
  realised map (§H).  **PASS.**

### W-T2.  Does W1 prove too much? — NO, and the transfer is recorded

Run at `n = 5` against the Klein cubic, W1's proof is unchanged and gives the
same verdict for the ambient packet's point cells.  That is a real
consequence and it is recorded (Cor W2.2).  It damages nothing: the ambient
packet's exit is `AMBIENT-HODGE-SUPPORT-PROVED` +
`POINT-SUPPORT-CHARACTERIZED`, and `THEOREM_POINT_SUPPORT.md` §1 already
states that `FREE-SUPPORT-EXCLUDED` is unavailable.  What W1 adds there is
the word *"in principle"*.

W1 does **not** prove that no obstruction exists: it proves that no
obstruction of **this shape** exists.  Residuals 1-3 are exactly the shapes
that survive.

### W-T3.  Is the witness compatible with Theorems K1 and K4? — YES

* K1 (each of the 110 eigenplanes is contracted to a point `y(Pi)` of
  `V14^{sigma}`) constrains the limit of `phi` **along the plane**.  At a
  point `x in Pi cap Bs(phi)` it forces `y(Pi) in Z_x` and nothing more;
  limits along arcs transverse to `Pi` are unconstrained by K1.  So
  `Z_x = V14` is compatible, and indeed `y(Pi) in V14` trivially.
* The `C_11`- and `F_55`-fixed points lie on **no** eigenplane at all: their
  stabilisers `C_11` and `F_55` have odd order and contain no involution, so
  K1 does not even apply to cells `P7`, `P8`.
* K4 (the 352 incidence points are mandatory base points) is a *hypothesis*
  the witness satisfies, not a constraint it violates.

### W-T4.  Is the `dim Y_x <= 3` bound of C5 correct, and could it be `<= 2`? — CORRECT, AND NO

`Y -> Gamma subset P(V) x V14` is finite (normalization of the graph), so
`Y_x -> Gamma_x subset V14` is finite and `dim Y_x = dim Gamma_x <= 3`.  It
cannot be improved to `<= 2` by any argument in the package: `Gamma_x = V14`
is exactly the ordinary "projection from `x`" behaviour of Lemma W0, and
Lemma W0' shows the package's own purity geometry *requires* positive
dimensional base locus, i.e. it pushes in the opposite direction.

### W-T5.  Does W3 contradict Prop O4-3? — NO (different levels)

Prop O4-3 works at `H = C_6` with `H_0 = C_2` and uses the residual
`C_3`-action **on the curve**; W3 works at `H_0` and is silent when
`H_0 = C_2` (which has no dead channel).  The two are consistent and
non-overlapping; §5 says so explicitly.

### W-T6.  Is the identity map really a morphism of Hodge structures? — YES, trivially

`W_x(1) = H^3(V14,Q)(1) = T` by definition of `T`.  The identity of a
rational Hodge structure is a morphism of rational Hodge structures and is
equivariant for any group acting.  The only content in C6 is *nonvanishing*,
and the identity supplies it.  This is the whole point: the necessary
condition compares the carrier with `T` itself, and the carrier is allowed
to **be** `T`.

### W-T7.  No withdrawn machinery — PASSED

No Chow projector, no canonical splitting of `Rp_*IC_Y^H`, no restricted-graph
transfer, no fixed-point statement, no use of the Tschinkel–Zhang equivalence
to transport `H^3`.  W1 uses C1-C8 and nothing else; W3 uses the equivariant
strict-support decomposition and Clifford theory for a trivial action.

---

## 8. Exit

```text
SPIN-HODGE-SUPPORT-METHOD-INSUFFICIENT
TOTAL-DEGENERATION-WITNESS-PROVED       (Theorem W1)
POINT-CELLS-UNCLOSABLE                  (Theorem W2, Cor W2.1)
POINTWISE-KERNEL-SELECTION-RULE-PROVED  (Theorem W3; new kills K-m, K-n)
BASE-LOCUS-DIMENSION-BOUND              (Lemma W0': dim Bs(phi) >= n-5)
TOTAL_DEGENERATION_OK                   (verifier marker, 87 assertions)
```

`SPIN-SUPPORT-CENSUS-CLOSED` is **not** claimed and is now known to be
**unreachable**: all five boxed families carry witnesses, four of them the
same one.  The Problem E headline is **not** decided by this route; the exact
residuals a stronger method must attack are boxed in §6.
