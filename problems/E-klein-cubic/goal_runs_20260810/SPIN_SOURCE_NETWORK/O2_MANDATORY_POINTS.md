# Census cell (O2): the 352 mandatory incidence points

`SUPPORT_CENSUS.md` §6 boxes `(O2)` as the cell whose closing move is
*"excluding `H`-equivariant `E_{-11}`-carrying irregular surfaces as
exceptional fibres over those points, **or bounding `dim Y_x <= 1`
there**"*, and §2.2 records that *"nothing in the repository bounds
`dim Y_x`"*.  This file settles the cell.

Verdict: **OPEN, WITH A WITNESS**.  The `dim Y_x = 2` branch — the one the
census analysed — is genuinely narrowed here (Prop O2-3: the *image* surface
in `V14` has irregularity zero whenever it is smooth, so the required
`E_{-11}` can only be created by branching or by singularities).  But the
branch the census did not analyse, `dim Y_x = 3`, is unconstrained and
carries the total-degeneration witness of `TOTAL_DEGENERATION.md`
Theorem W1.  The alternative offered by the census — *"or bounding
`dim Y_x <= 1`"* — is the real content, and it is a statement about `q`,
which the package cannot see.

Machine: the character layer and the narrowing are §F of
`verify_total_degeneration.py` (`TOTAL_DEGENERATION_OK`, 87 assertions).

---

## 1. The cell, restated

The 352 points are Theorem K4's: `2` orbits of `110` with `Stab_G = S_3` and
`2` orbits of `66` with `Stab_G = D_10`, all inside `Ind(phi)` for **every**
`G`-equivariant rational map, at every degree, dominant or not
(`KLEIN_SPIN_COMPLEX.md` §5).  They are cells `P5`, `P6`.

Restrictions (§F3, §F4, recomputed here from `chi_T` alone):

\[
\operatorname{Res}_{S_3}T=2\cdot\mathbf 1\ \oplus\ 4\cdot\mathrm{std},
\qquad
\operatorname{Res}_{D_{10}}T=2\cdot\mathbf 1\ \oplus\ 2W_1\ \oplus\ 2W_2 .
\]

Both are sign-free, which is Theorem C4 (kill `K-d`): the **sign channel is
dead**, and it is precisely the channel the source geometry singles out —
`T_x = sign (+) 2.std` resp. `sign (+) W_1 (+) W_2` (Thm K5), so the
`H`-fixed point of the exceptional `P(T_x)` sits in the one direction the
Hodge obstruction cannot use.  Everything else is live.

The geometric floor is Prop S5 / Cor S6: `j_0 = 4-n`, the carrier is a
weight-three sub-Hodge structure of `H^3(Y_x,Q)`, `dim Y_x >= 2`, and
`Y_x -> Z_x = q(Y_x) subset V14` is finite with `dim Z_x >= 2`.  Since
`Y -> Gamma subset P(V) x V14` is finite, also `dim Y_x <= 3`.  So exactly
two branches: `dim Y_x = 2` and `dim Y_x = 3`.

---

## 2. The `dim Y_x = 2` branch — narrowed, not closed

> **Proposition O2-3 (the image surface is regular).**  Suppose
> `dim Y_x = 2`.  Then `Z_x = q(Y_x)` is an irreducible surface in `V14`.
> Because `rho(V14) = 1` (sealed, `SEAL_V14_BETTI.md`), `Z_x` is an
> **ample divisor**, `Z_x in |kH|` with `k >= 1`.  If `Z_x` is smooth then
> the Lefschetz hyperplane theorem for ample divisors gives
> `H^1(V14,Q) ~= H^1(Z_x,Q)`, and `b_1(V14) = 0`, so
> \[
> q(Z_x)=0,\qquad \operatorname{Alb}(Z_x)=0 .
> \]
> Hence the `E_{-11}` that Cor C5 demands in `Alb(\widetilde{Y_x})` cannot
> come from `Z_x`: it must be created by the finite map
> `Y_x -> Z_x` (branching) or by singularities of `Z_x`.

*Proof.*  `Pic(V14) = Z.H` with `H` ample, and an irreducible surface is a
nonzero effective divisor, so its class is `kH` with `k >= 1`, which is
ample.  Lefschetz for an ample divisor on a smooth projective threefold gives
an isomorphism on `H^1`; `b(V14) = (1,0,1,10,1,0,1)` is sealed (§F6, §F7).
`QED`

This is a real narrowing — it removes the most natural way to satisfy Cor C5
(`Y_x` birational onto an irregular surface of `V14`) — and it is
*compatible with everything*: `V14` contains no irregular smooth surface at
all, because it contains no smooth surface of positive irregularity, by the
same argument.

It is **not** a kill, for the standard reason: a finite cover of a regular
surface, branched along a divisor, can have arbitrarily large irregularity
(already for cyclic covers of `P^2` branched along a curve of high degree).
Nothing bounds the degree of `Y_x -> Z_x`, nothing bounds the branch divisor,
and nothing forces `Z_x` to be smooth.

> **Corollary O2-4 (the `D_10` sharpening, resolved).**  `SUPPORT_CENSUS.md`
> Cor C5 highlights that at `H = D_10` the image `Z_x` must carry a
> fixed-point-free `D_10`-action because `V14^{D_10} = empty` (measured), and
> calls this *"the sharpest form of what the `D_10` cell asks for"*.  With
> `Z_x = V14` (the `dim Y_x = 3` branch) the condition is satisfied by the
> **measurement itself**: `V14` is a `D_10`-invariant subvariety of `V14`
> with `V14^{D_10} = empty`.  The measurement that was meant to close the
> cell is what makes the witness work.

---

## 3. The `dim Y_x = 3` branch — the witness

> **Theorem O2-5.**  Cells `P5` and `P6` are **OPEN with a witness**: the
> datum `(Y_x, q|_{Y_x}, W_x) = (V14, id, H^3(V14,Q))` of Theorem W1
> satisfies C1-C8 at every one of the 352 points, in the trivial and
> `std` / `W_1,W_2` channels, with `dim End_{S_3}(Res_{S_3}T) = 20` and
> `dim End_{D_10}(Res_{D_10}T) = 12` (§B9).  The dead sign channel is not
> used, so kill `K-d` is respected.

*Proof.*  Theorem W1 with `H = S_3` and `H = D_10`; `Res_H W_x(1) = Res_H T`
is `2.triv + 4.std` resp. `2.triv + 2W_1 + 2W_2`, neither sign-isotypic.
`QED`

Geometrically (Lemma W0): the witness says that at a mandatory incidence
point **every fibre closure of `phi` passes through `x`**.  That is not only
allowed but natural: `x` is in `Bs(phi)` unconditionally, `Bs(phi)` has a
positive-dimensional component (Lemma W0'), and the maps in play are given by
forms of even degree vanishing at 364 prescribed points.

Compatibility with Theorem K1 is checked in `TOTAL_DEGENERATION.md` §7,
W-T3: K1 constrains the limit of `phi` **along** each eigenplane through `x`
(it is the constant `y(Pi)`), and imposes nothing on limits along arcs
transverse to the plane.  `y(Pi_1), y(Pi_2) in Z_x = V14` is trivially true;
the failure of `y(Pi_1) = y(Pi_2)` is exactly why `x in Ind(phi)`, which is
the hypothesis, not a contradiction.

---

## 4. What would close `(O2)`

The census's own second alternative, made precise:

```text
+---------------------------------------------------------------------------+
| (O2) RESIDUAL.  Prove, for a dominant G-equivariant phi : P(V) --> V14     |
| with V a faithful spin source, that at some point x of each of the four    |
| mandatory orbits                                                          |
|         dim q(p^{-1}(x))  <=  1,                                          |
| equivalently (Lemma W0) that NOT every fibre closure of phi passes         |
| through x.  Then Prop S5 kills the cell outright (K-b).                   |
|                                                                           |
| Failing that, close the dim = 2 branch by excluding H-equivariant finite   |
| covers Y_x -> Z_x of ample divisors of V14 with E_{-11} in Alb(Y_x~), in   |
| the trivial or std / W_1,W_2 channel.  Prop O2-3 reduces this to the       |
| branching: Z_x itself is regular whenever smooth.                          |
+---------------------------------------------------------------------------+
```

Both are statements about the **map**, not about the support decomposition.
That is the content of the campaign exit.

---

## 5. Adversarial tests

### O2-T1.  The mandatory `D_12` test — PASSED

This file claims **no kill**.  Its two positive results are Prop O2-3 (a
narrowing, valid for any group) and Theorem O2-5 (a witness).  Neither can
contradict Cor IX.6.  Informatively, `D_12` contains `S_3` but not `D_10`
(`|D_10| = 10` does not divide 12), so the `P5` half of the cell *is* visible
at `D_12` level — and it is left **open** there, which is the correct sign: a
kill covering `P5` in the trivial channel would have refuted the realised
`D_12`-map, since `dim T^{D_12} = 2 > 0` (§H2).

### O2-T2.  Does Prop O2-3 contradict the sealed `V14^{sigma} = E_sigma ⊔ 2 pts`? — NO

`E_sigma` is a **curve** of genus one in `V14`, not a surface; Prop O2-3 is
about surfaces.  Nor does it contradict `J(V14) ~ E_{-11}^5`: that is
`H^3(V14)`, not `H^1`, and `b_1(V14) = 0` is exactly what makes `V14` a Fano
threefold with `H^{3,0} = 0` and all of its weight-one geometry hidden in the
intermediate Jacobian.

### O2-T3.  Does Prop O2-3 accidentally kill the `dim Y_x = 2` branch after all? — NO

It would if `Y_x -> Z_x` were forced birational.  It is not: Cor S6 gives
only finiteness, the degree is unbounded, and the packet contains nothing
about the local structure of `p` over `x`.  The proposition is recorded as a
narrowing and marked as such in the boxed residual.

### O2-T4.  Is the sign-channel kill still in force? — YES, and untouched

`K-d` kills sign-isotypic blocks at the 352 points.  The witness's carrier
is `Res_H T`, which contains no sign constituent at all, so it lives entirely
in the surviving channels.  Theorem V1's forced base locus at the sign point
of the exceptional `P(T_x)` is likewise untouched (`ADVERSARIAL_TESTS.md`
§S8).

---

## 6. Exit

```text
O2-OPEN-WITH-WITNESS
O2-IMAGE-SURFACE-REGULAR           (Prop O2-3: rho(V14) = 1 and b_1 = 0 force
                                    q(Z_x) = 0 for a smooth Z_x)
```

`O2-DEAD` is **not** claimed.  The cell's residual is Residual 1 of
`TOTAL_DEGENERATION.md` §6, restricted to the four mandatory orbits.
