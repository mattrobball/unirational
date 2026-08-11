# Census cell (O3): the odd-order point supports `C_11` and `F_55`

`SUPPORT_CENSUS.md` §6 calls `(O3)` *"the sharpest arithmetically"*: at a
point whose stabiliser is `C_11` (orbit 60) or `F_55` (orbit 12) the
restriction `Res_H T` is **`Q`-irreducible with no invariants**, so a single
support must carry the whole of `T` — all five copies of `E_{-11}` at once
(Theorem C7, Cor S4 with `k = 5`).  This file works the cell out.

The verdict is **OPEN, WITH A WITNESS**, and the cell delivers three things
on the way:

1. an **unconditional** proof that `V14^{F_55} = empty` — replacing the
   worker-grade mod-397 input of `theory/FIX_IX_v14.md` §8 — and, from it,
   a **new mandatory base locus**: the 12 `F_55`-fixed points of `P(U)` lie
   in `Ind(phi)` for every `G`-equivariant rational map, at every degree;
2. a complete, exact tabulation of the candidate points: `12 + 60 = 72` of
   them on `P(U)`, with their `F_55`-action;
3. a proof that the arithmetic demand is **not** a contradiction but a
   *tautology*: the forced CM type is the quadratic-residue type of
   `Q(zeta_11)`, which is **induced** from `Q(sqrt(-11))`, so
   `Q(zeta_11)`-multiplication and `E_{-11}^5`-isogeny are the *same*
   condition, realised canonically by `J(V14)`.  There is no
   field-mismatch kill, and the director's caution was the right one.

Machine: `python3 verify_o3_odd_order.py` → `O3_ODD_ORDER_OK`, 86 assertions,
exact, well under a second.  Section references `§A`-`§G` point at that
script.  The witness itself is Theorem W1 of `TOTAL_DEGENERATION.md`
(`verify_total_degeneration.py`).

---

## 1. The candidate points, exactly

> **Theorem O3-1 (the 72 points).**  On the minimal spin source `P(U) = P^5`:
>
> 1. `U|_{C_11} = 1 (+) (+)_{a in QR} psi_a`, where `QR = {1,3,4,5,9}` is the
>    set of quadratic residues mod 11; hence `dim U^{C_11} = 1` and
>    `P(U)^{C_11}` is **6 isolated points**, one per eigenline;
> 2. `N_G(C_11) = F_55 = C_11 : C_5` and the `C_5` acts on the characters of
>    `C_11` by multiplication by a **quadratic residue** of order 5; the
>    single `C_5`-orbit on `QR` is all of `QR`.  So `C_5` fixes the
>    trivial-character eigenline and permutes the five others cyclically and
>    freely;
> 3. there are **12** Sylow 11-subgroups, so `P(U)` carries exactly
>    `12 x 1 = 12` points with `Stab_G = F_55` (one `G`-orbit of size 12)
>    and `12 x 5 = 60` points with `Stab_G = C_11` exactly (one `G`-orbit of
>    size 60).  These are cells `P8` and `P7`;
> 4. at the `F_55`-point `x_0`, the tangent representation is
>    `T_{x_0} = Hom(L, U/L) = theta_1`, the **irreducible** 5-dimensional
>    representation of `F_55`.  Hence `P(T_{x_0})^{F_55} = empty` and
>    `P(T_{x_0})^{C_11}` is 5 points cyclically permuted by `C_5`.

*Proof (§A, §B).*  From the integral monomial model
`W = Ind_B^{SL(2,11)}(chi)` the character `chi_W` is `12` at the identity and
`1` on every nontrivial unipotent, so orthogonality inside `Z[zeta_11]` gives
`W|_{C_11} = 2.triv (+) (+)_{k != 0} psi_k`; the halving principle splits
this as `U|_{C_11} = triv (+) (five psi's)` and
`U'|_{C_11} = triv (+) (the other five)`.  The Gauss-sum identities
`eta + eta' = -1` and `eta.eta' = 3` (verified exactly in `Z[zeta_11]`, §B8,
§B9) identify the two halves as the quadratic-residue and non-residue sets
and give `chi_U(g) = 1 + eta = (1 +- sqrt(-11))/2`, matching the sealed value.
(2) is read off the conjugation action in `PSL(2,F_11)`, computed directly:
the multiplier is a quadratic residue of multiplicative order 5, and
`{1,m,m^2,m^3,m^4} = QR`.  For (3), a subgroup of `G` containing `C_11` is
`C_11`, `F_55` or `G`, and `P(U)^G = empty`; the five non-trivial eigenlines
have trivial `C_5`-stabiliser (§B13), so their stabiliser is `C_11` exactly,
and `G` is transitive on the 12 Sylows while `F_55` is transitive on the five
lines, giving one orbit of 60.  For (4), `U|_{F_55} = lambda (+) theta_1`
with `lambda` linear, so `Hom(L,U/L) = lambda^{-1} (x) theta_1 = theta_1`
because `theta_1 = Ind_{C_11}^{F_55}psi_1` is unchanged by twisting by a
character trivial on `C_11`.  `QED`

Part (4) reproduces, and explains, the observation of
`KLEIN_SPIN_COMPLEX.md` §3 that blowing up the `F_55`-point leaves an
exceptional `P^4` with no `F_55`-fixed point and five `C_11`-fixed points
cyclically permuted.

---

## 2. `V14^{F_55} = empty`, unconditionally — and a new mandatory base locus

`theory/FIX_IX_v14.md` §8 records `V14^{C_11}` = 5 points and
`V14^{F_55} = empty` as *"worker-grade, mod 397, to be sealed with its
packet"*.  The second of the two needs no computation at all.

> **Theorem O3-2 (the fixed-point law).**  Let a finite group `H` act
> faithfully on a smooth connected variety `X` over `C` with `X^H != empty`.
> Then `H` has a faithful representation of degree `dim X`.  Consequently,
> for the threefold `V14` with its faithful `G`-action,
> \[
> \mu(H)>3\ \Longrightarrow\ V_{14}^{H}=\emptyset ,
> \]
> `mu(H)` = minimal faithful degree.  Since `mu(F_55) = 5` and
> `mu(PSL(2,11)) = 5`,
> \[
> \boxed{V_{14}^{F_{55}}=\emptyset,\qquad V_{14}^{G}=\emptyset }
> \]
> with no computation and no congruence.

*Proof.*  At a fixed point `y in X^H` the group acts on `T_yX`.  If `h` acts
trivially on `T_yX` then, by Cartan's linearisation lemma in characteristic
zero, `h` acts trivially on a neighbourhood of `y`, hence on all of `X` by
irreducibility; faithfulness gives `h = 1`.  So `H ↪ GL(T_yX)`, of degree
`dim X`.  For `F_55 = C_11 : C_5`: its irreducible degrees are
`1,1,1,1,1,5,5` (§D1), the five linear characters all kill `C_11`, so a
faithful representation must contain `theta_1` or `theta_2` and
`mu(F_55) = 5 > 3`.  For `G = PSL(2,11)` the irreducible degrees are
`1,5,5,10,10,11,12,12` and `mu(G) = 5 > 3`.  `QED`

**Scope, honestly.**  The law explains exactly two of the measured empty
loci and no others: `mu(V_4) = mu(D_12) = mu(D_10) = 2` and `mu(A_5) = 3`, so
`V14^{V_4}`, `V14^{D_12}`, `V14^{D_10}`, `V14^{A_5} = empty` remain genuine
measurements (§D9).  It is also consistent with every measured **non**empty
locus: no subgroup with `V14^H != empty` has `mu(H) > 3` (§D6).

> **Theorem O3-3 (the `F_55` stratum is mandatory base locus).**  Let `V` be
> any faithful spin source and `phi : P(V) --> V14` any `G`-equivariant
> rational map — dominant or not, any degree.  Then
> \[
> \mathbf P(V)^{F_{55}}\subset\operatorname{Ind}(\phi).
> \]
> For `V = U^{(+)m}` this locus is `P^{m-1}` per Sylow, so on `P(U)` it is
> **12 additional mandatory base points**, disjoint from the 352 incidence
> points of Theorem K4 (different stabilisers).  The mandatory base locus of
> the spin lane therefore has at least `352 + 12 = 364` points.

*Proof.*  `P(V)^{F_55}` is `F_55`-fixed, so if `phi` were defined at a point
of it the image would lie in `V14^{F_55} = empty` (Theorem O3-2).  `QED`

This is the spin analogue of the linear-source first cut of `FIX_IX_v14.md`
§8, and it is the exact statement that `KLEIN_SPIN_COMPLEX.md` §3 stopped
short of: that file observed that `P(U)` *does* have an `F_55`-fixed point
and concluded only that "the `F_55` route does not obstruct it directly".
It does not obstruct — but it does force base locus.

For the `10`-dimensional spin irreducibles the statement is vacuous
(`V^{C_11} = 0` there, so `P(V)^{F_55} = empty`); for the `12`-dimensional
ones `dim V^{C_11} = 2` and the locus is nonempty.  Those two restrictions
are **not** computed in-repo and are recorded here as expectations, not
inputs; nothing below uses them.

---

## 3. The arithmetic demand, and why it is not a kill

At a `C_11`- or `F_55`-point the carrier must contain a copy of
`Res_H T`, which is `Q`-irreducible of dimension 10 with no invariants
(§C3-C11).  So the support abelian variety `A_x` is an abelian **fivefold**
carrying an action of `Q[C_11]/(Phi_11) = Q(zeta_11)`, i.e. with
`Q(zeta_11)`-multiplication — *and simultaneously* isogenous to `E_{-11}^5`
by Theorem S0(2).  The tempting kill is a field mismatch.  It does not exist.

> **Theorem O3-4 (the CM type is the quadratic-residue type, and it is
> INDUCED).**  Let `A` be an abelian fivefold with
> `H^1(A,Q) ~= Res_{C_11}T` as a `C_11`-Hodge structure.  Then:
>
> 1. `K := Q(sqrt(-11))` is the quadratic subfield of `L := Q(zeta_11)`
>    (because `11 = 3 mod 4`), and `[L:K] = 5`, so `L` embeds in `M_5(K)` as
>    a maximal subfield: `Q(zeta_11)`-multiplication is **compatible** with
>    `End^0(A) = M_5(K)`, not opposed to it;
> 2. the CM type of `A` is
>    `Phi = {tau_a : a in QR}`, the quadratic-residue coset.  It is a CM type
>    (`-1` is a non-residue mod 11, so `Phi` and `Phibar` are disjoint and
>    exhaust the Galois group), and it is a **union of cosets of
>    `Gal(L/K) = QR`**, i.e. it is **induced** from the CM type of `K`;
> 3. an induced CM type of index 5 gives `A ~ B^5` with `B` of CM type
>    `(K, .)`, i.e. `A ~ E_{-11}^5`.  So the two demands are the **same**
>    demand;
> 4. it is realised, canonically: `A = J(V14)` with the `C_11`-action coming
>    from `G`, since `Res_{C_11}T` is exactly this Hodge structure.

*Proof (§F).*  (1) is degree arithmetic.  For (2), `H^{1,0}(A)` is a
5-dimensional `L`-stable subspace of `H^1(A,C) = (+)_{tau} C_tau`, hence a
CM type `Phi`; since `A ~ E_{-11}^5` as a Hodge structure, the `K`-action has
`H^{1,0}` entirely inside one `K`-eigenspace, so `Phi` is exactly the set of
`tau` restricting to that embedding of `K`, which is a coset of
`Gal(L/K) = QR` — and `Phi = QR` after labelling.  `Phi cap Phibar = empty`
and `Phi u Phibar = (Z/11)^*` are verified exactly, and
`QR . QR = QR` shows `Phi` is `Gal(L/K)`-stable.  (3) is the standard
splitting of an induced CM type (Shimura–Taniyama): if `(L,Phi)` is induced
from `(F,Phi_0)` with `[L:F] = m`, the CM abelian variety of type `(L,Phi)`
is isogenous to the `m`-th power of the one of type `(F,Phi_0)`.  (4) is
Theorem S0(2) plus §C3-C5.  `QED`

**Consequence, stated flatly.**  The sharpest arithmetic in the whole census
is *self-consistent*.  Demanding all five copies of `E_{-11}` on a single
support is not an over-demand: it is exactly what an abelian fivefold with
`Q(zeta_11)`-multiplication of quadratic-residue type **is**.  The naive
"`Q(zeta_11)` is too big for `M_5(Q(sqrt(-11)))`" kill is refuted (§F10);
so is the reverse "`E_{-11}^5` cannot carry `Q(zeta_11)`" kill.

---

## 4. The witness

> **Theorem O3-5.**  Cells `P7` and `P8` are **OPEN with a witness**: the
> total-degeneration datum
> `(Y_x, q|_{Y_x}, W_x) = (V14, id, H^3(V14,Q))` of `TOTAL_DEGENERATION.md`
> Theorem W1 satisfies every necessary condition the package imposes at a
> `C_11`- or `F_55`-point, with the Hom of (AHS-spin) an **isomorphism** and
> the floor `k = 5` of Cor S4 met **exactly**.

*Proof.*  Theorem W1, instantiated at `H = C_11` and `H = F_55`, together
with the kill audit (§G9): `dim Y_x = 3 >= 2` (Prop S5); `Z_x = V14` is
`H`-invariant of dimension `3 >= 2` (Cor S6); `W_x(1) = T ⊇ Res_H T` with the
identity as the Hom; `A_x = J(V14) ~ E_{-11}^5` supplies exactly the five
copies Cor S4 demands; the orbit sizes 60 and 12 satisfy capacity for all
even `d >= 4` resp. `d >= 2`; and none of `K-a` … `K-l` applies (§G9).
`QED`

Note what makes this cell *look* sharp and is not: the demand for five copies
is the largest in the census, and it is met by the cheapest possible carrier,
the target's own `H^3`.  Corollary S4's floor is tight, and tightness is
exactly what a witness needs.

**What it would take to close `(O3)`.**  Precisely the boxed Residual 1 of
`TOTAL_DEGENERATION.md` §6: a bound `dim q(p^{-1}(x)) <= 1` at the `C_11`- or
`F_55`-points.  By Lemma W0 this is the statement that not every fibre
closure of `phi` can pass through such a point.  Theorem O3-3 makes the
`F_55`-points *mandatory* base points, which if anything makes total
degeneration there **more** available, not less.

---

## 5. Adversarial tests

### O3-T1.  The mandatory `D_12` test — PASSED, vacuously and informatively

`gcd(55,12) = 1`, and `D_12` has element orders `1,2,3,6` only: it contains
no element of order 11 (§G11, §G12).  So cells `P7` and `P8` are **invisible**
to the realised dominant `D_12`-equivariant spin map of Cor IX.6, and nothing
in this file constrains it.  Furthermore this file claims **zero kills** in
the cell (§G13) — a witness cannot contradict an existence theorem.  The two
things it does prove — `V14^{F_55} = empty` and `P(V)^{F_55} ⊂ Ind(phi)` —
are also invisible at `D_12` level for the same reason.  **PASS.**

### O3-T2.  Is the fixed-point law circular? — NO

Theorem O3-2 uses only: `G` acts faithfully on the smooth connected
threefold `V14` (the sealed model, and Theorem S0's proof re-derives
faithfulness from `chi_{H^3}(sigma) != 10`); Cartan linearisation; and the
character table of `F_55`.  It uses no fixed-point measurement, no
`chi_top`, no Lefschetz count, and in particular not the mod-397 computation
it replaces.  It is checked for consistency against every measured locus
(§D6, §D9) and contradicts none.

### O3-T3.  Does Theorem O3-3 prove too much? — NO

If it did, it would forbid `G`-equivariant maps outright.  It does not: it
forces `P(V)^{F_55}` into `Ind(phi)`, exactly as Theorem K4 forces the 352
incidence points there.  `Bs(phi)` has codimension `>= 2` and, by Lemma W0'
of `TOTAL_DEGENERATION.md`, dimension `>= n-5 >= 1`; 364 points fit inside a
positive-dimensional base locus with room to spare.  The only quantitative
bite is at `d = 2`, where `364 > 2^5 = 32` shows the mandatory points cannot
all be isolated base components (§E6) — which the census already said for the
352 alone.

### O3-T4.  Is the CM-type argument doing real work, or assuming its conclusion? — REAL

It is stated in the direction that matters.  The **hypothesis** is only that
`H^1(A) ~= Res_{C_11}T` as a `C_11`-Hodge structure; the CM type is then
*computed*, shown to be induced, and the isogeny `A ~ E_{-11}^5` *deduced*
from the Shimura–Taniyama splitting.  The point of the theorem is negative —
it removes a whole class of attempted kills — and negative results of that
shape are exactly what a "would close by" line in the census needs
adjudicated before more effort is spent.  §F verifies each combinatorial step
(`Phi cap Phibar = empty`, `Phi u Phibar` = everything, `QR.QR = QR`,
`[L:K] = 5`) exactly.

### O3-T5.  The `j = 8192/11` trap — NOT ENTERED

The tempting bad move — "the carrier is `E_sigma`, whose `j` is not an
algebraic integer, so `Hom(E_sigma,E_{-11}) = 0` and the cell dies" — is
unavailable here for a fourth reason on top of the three recorded in
`O4_EIGENPLANE_CURVES.md` §8.2: `C_11` and `F_55` contain **no involution**,
so `sigma` is not in the stabiliser and `E_sigma` never enters the picture.
The carrier of the witness is `J(V14) ~ E_{-11}^5`, in which `E_sigma` does
not occur precisely because `Hom(E_sigma,E_{-11}) = 0`.

### O3-T6.  Could `dim Y_x = 2` be forced at these points? — NOT BY THIS PACKAGE

`dim Y_x <= 3` comes from finiteness of `Y -> Gamma` and `dim V14 = 3`;
`dim Y_x >= 2` from Prop S5.  Nothing in the package selects between them,
and Prop O2-3 of `O2_MANDATORY_POINTS.md` shows that even the `dim Y_x = 2`
branch is not closable (a smooth ample divisor of `V14` has irregularity
zero, but its finite covers do not).  Recorded as Residual 1 and 2.

---

## 6. Exit

```text
O3-OPEN-WITH-WITNESS
V14-F55-EMPTY-UNCONDITIONAL        (Theorem O3-2; discharges a worker-grade
                                    input of FIX_IX_v14.md sec.8)
F55-STRATUM-MANDATORY              (Theorem O3-3; 12 new mandatory base
                                    points on P(U), total 364)
O3-CM-TYPE-INDUCED                 (Theorem O3-4; no field-mismatch kill)
O3_ODD_ORDER_OK                    (verifier marker, 86 assertions)
```

`O3-DEAD` is **not** claimed and is unreachable by this machinery.  The cell
that looked sharpest arithmetically turns out to be the one where the
arithmetic is a tautology: the demand for `E_{-11}^5` is met exactly, by the
target's own intermediate Jacobian.
