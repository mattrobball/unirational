# Census cells (O1) and (O5): free supports, and the higher-multiplicity strata

The two remaining boxed families of `SUPPORT_CENSUS.md` §6.  Both are settled
here, both **OPEN with a witness**, and both contribute one genuinely new
unconditional kill on the way — at the positive-dimensional layer, where the
package still has teeth.

Machine: §C, §D, §E of `verify_total_degeneration.py`
(`TOTAL_DEGENERATION_OK`, 87 assertions) and `verify_min_degree.py`
(`MIN_DEGREE_OK`, 114 assertions).  Both exact.

---

## 1. `(O1)` — free supports

`H_0 = 1`, `H` arbitrary, `s` anywhere in `[0, n-3]`.

### 1.1 There is no character obstruction, in any dimension

`Res_1 T = 10 . triv`, so the pointwise-kernel selection rule (Theorem W3 of
`TOTAL_DEGENERATION.md`) produces **no** dead channel at `H_0 = 1` (§C1), and
neither does any refinement: (5.2) asks for a nonzero Hodge map into a
carrier on which the pointwise kernel acts trivially, and the trivial group
imposes nothing.  Frobenius reciprocity at the setwise stabiliser `H` gives
`Hom_G(T, Ind_H^G M) = Hom_H(Res_H T, M)`, and `dim T^H > 0` for every
`H` other than `C_11` and `F_55`, both of which have
`Res_H T` `Q`-irreducible and hence *also* admit nonzero Homs from a large
enough carrier.  Nothing dies.

### 1.2 The minimal live coordinate degree — named task §7.4, CLOSED

`SUPPORT_CENSUS.md` §7.4 left open *"the smallest even `d` with
`<S^d U^*, 10'> != 0`"*.  It is computed here, exactly
(`verify_min_degree.py` → `MIN_DEGREE_OK`, 114 assertions).

> **Theorem O1-0 (the minimal live degree).**  Let `M` be the coordinate
> module of the sealed model, i.e. the 10-dimensional summand of
> `Lambda^2 U`.  Then `M = 10'`, with character `(10,2,1,0,-1,-1)` on element
> orders `(1,2,3,5,6,11)`; `Lambda^2 U = 5 (+) 10'` and
> `S^2 U = 10 (+) 11`.  Consequently
> \[
> \dim\operatorname{Hom}_{\widetilde G}\bigl(M^*,S^dU^*\bigr)
> =0,0,0,\mathbf 3,0,6,0,22,0,42,0,99\quad (d=1,\dots,12),
> \]
> so the **minimal live coordinate degree for `V = U` is `d = 4`**, with a
> `P^2` of candidate landing tuples.  Odd `d` vanish identically, which
> reproduces Theorem C6 by a second, independent route (and termwise, via
> `chi_{S^d U}(-g) = (-1)^d chi_{S^d U}(g)` and `chi_M(-g) = chi_M(g)` on all
> 1320 elements).
>
> At multiplicity the answer changes.  By Cauchy,
> `S^2(U (x) C^m) = S^2U (x) S^2(C^m) (+) Lambda^2U (x) Lambda^2(C^m)`, and
> `Lambda^2 U` contains `10'` once, so
> `dim Hom(M^*, S^2(U^{(+)m})^*) = \binom m2`.  The **minimal live degree is
> `2` for every `m >= 2`.**

Two consequences for the census, both recorded:

* **Kill `K-g`** (*at `d = 2` all free component orbits die*) is **vacuous
  for `V = U`**: there is no `G`-equivariant map of coordinate degree 2 from
  `P(U)` at all, so nothing needs killing.  It is in force from `m = 2` on,
  where degree 2 genuinely exists.
* At the minimal live degree `d = 4` on `P(U) = P^5`, refined Bézout gives
  `4^5 = 1024 >= 660` at codimension 5 but `4^4 = 256 < 660`,
  `4^3 = 64 < 660`, `4^2 = 16 < 660`: **free positive-dimensional component
  orbits die at `d = 4`**.  They revive at `d = 6` (`6^4 = 1296 >= 660`).
  So the screen is real at exactly one degree and gone at the next.

### 1.3 Capacity is a low-degree screen and nothing more

Refined Bézout on `P^{n-1}`: a `G`-orbit of `N` irreducible base
**components** of codimension `c` needs `N <= d^c`, sharpened by
`sum deg <= d^c` (Prop O4-6).  With `d` even (Theorem C6) the free orbit
`N = 660` gives, on `P^5`:

| `s` | 3 | 2 | 1 | 0 |
|---|---:|---:|---:|---:|
| smallest even `d` | 26 | 10 | 6 | **4** |

(the `s = 0` entry `4` is exactly the minimal live degree of Theorem O1-0 —
capacity and existence agree at the boundary), and, as the spin source grows,
the free **point** orbit needs (§E4)

| `n` | 6 | 7 | 8 | 9 | 10 | 11 | 12 |
|---|---:|---:|---:|---:|---:|---:|---:|
| smallest even `d` | 4 | 4 | 4 | 4 | 4 | **2** | 2 |

> **Proposition O1-1 (no all-degree, all-source capacity kill).**  There is
> no `(n,s)` for which the free orbit dies at every live `d`: the bound
> `660 <= d^{n-1-s}` is satisfied by `d = 4` for every `n >= 6` at `s = 0`,
> by `d = 6` at `s = 1`, and by `d = 2` for every `n >= 11`.  Since the spin
> lane has **no** unconditional no-map degree window (the `d <= 30` window of
> `DEGREE_ACCOUNTING.md` is for the linear ambient ladder), and since the live
> degrees on `P(U)` start at `d = 4` (Theorem O1-0), capacity screens exactly
> the single degree `d = 4`, and only in the positive-dimensional rows.

The structural point the mission asks for, stated once: closure would need a
statement uniform in `d`, and capacity is monotone in `d` in the wrong
direction.  There is no structural argument to find, because the quantity
being bounded grows without bound.  The caveat of
`THEOREM_POINT_SUPPORT.md` §1 makes this worse, not better: a strict support
need not be an irreducible component of the base scheme, so the rows above
are necessary conditions on **component** orbits only, and a support hidden
inside a larger base component is not counted at all.

### 1.4 Verdict

> **Theorem O1-2.**  `(O1)` is **OPEN with a witness**.  Cell `P0` (the free
> point orbit, `N = 660`, `H = 1`) carries the total-degeneration witness of
> Theorem W1, with `dim End_1(Res_1 T) = 100` (§B9) and the Cor S4 floor
> `k(1) = 1` met five times over.  The only screen, capacity, is satisfied at
> the minimal live degree `d = 4` already (`4^5 = 1024 >= 660`) and at every
> live degree above it.

This is the escape the ambient packet already flagged as surviving
(`THEOREM.md` Test 4; `THEOREM_POINT_SUPPORT.md` §1: *"the exit
`FREE-SUPPORT-EXCLUDED` is unavailable"*).  It survives here, and Theorem W2
upgrades "unavailable" to "unavailable in principle".

---

## 2. `(O5)` — the higher-multiplicity strata `S4`-`S8`

For `V = U` the five strata with pointwise kernel `C_6`, `C_11`, `S_3`,
`D_10`, `F_55` are **finite** (6, 6, 2, 2, 1 points respectively), so cells
`S4`-`S8` are dead for `U`: there is no positive-dimensional support to be
had.  For `V = U^{(+)m}` every stratum is multiplied by `P^{m-1}` (Lemma M0),
so all five revive at `m >= 2`.  This is the multiplicity route of
`MULTIPLICITY_ROUTE.md`, and it is the only route that discharges the "all
faithful spin sources" quantifier the headline needs.

### 2.1 Two new unconditional kills at the stratum layer

Theorem W3 (`TOTAL_DEGENERATION.md` §5) applies directly, because on these
strata the pointwise kernel acts **trivially**: the carrier of a simple
constituent is `IH^i(Sbar, L) (x) rho` with `rho in Irr(H_0)` acting alone,
so `rho` must occur in `Res_{H_0}T`.

> **Kill `K-m` (cell `S5`, `H_0 = C_11`).**  `Res_{C_11}T` has **no
> invariants**, so the constant-coefficient channel (`rho = 1`) is **DEAD**
> on every `C_11`-stratum: every spin source, every `m`, every degree, every
> support dimension, every local system `L`.  Only `rho = psi_k`, `k != 0`,
> survives.

> **Kill `K-n` (cell `S8`, `H_0 = F_55`).**  `Res_{F_55}T = theta_1 (+)
> theta_2` contains **no linear character** of `F_55`, so **every rank-one
> equivariant structure is DEAD** on every `F_55`-stratum — again for all
> sources, all `m`, all degrees, all dimensions.  The only survivors are the
> two five-dimensional structures `theta_1`, `theta_2`.

Both are checked exactly (§C8, §C9, §D5, §D6).  `K-n` is the strongest
channel statement in the census: it removes an entire *rank* of equivariant
structures, not merely one character, and it does so uniformly in the source.

The remaining rows of the selection rule reproduce `K-d` at `H_0 = C_6, S_3,
D_10` (`psi_3`, `sign`, `sign`) and give nothing at `H_0 = 1, C_2, C_3, C_5`
(§C13).

### 2.2 Why the cells still do not close

Two independent reasons, either sufficient.

1. **The surviving channels are not empty.**  At `C_11` every nontrivial
   `psi_k` survives; at `F_55` both `theta_i` survive.  A carrier in those
   channels must satisfy the CM demand of Cor S4 with `k = 5` — which
   `O3_ODD_ORDER_POINTS.md` Theorem O3-4 shows is self-consistent and
   canonically realisable, not contradictory.
2. **Every stratum has a point layer.**  A single point of `P(V)^{C_11}`,
   `P(V)^{F_55}`, `P(V)^{C_6}`, `P(V)^{S_3}` or `P(V)^{D_10}` is cell `P7`,
   `P8`, `P4`, `P5`, `P6`, and Theorem W1 witnesses all five (§D7).  A
   stratum-level kill can never empty a cell whose point layer survives,
   because the census's forcing (Thm S3(3)) only asks that **some** orbit of
   supports carry `T`, and a `G`-orbit of points inside the stratum is such
   an orbit.

> **Theorem O5-1.**  `(O5)` is **OPEN with a witness** for every `m >= 1` and
> every faithful spin source, with the two new kills `K-m`, `K-n` in force at
> the positive-dimensional layer only.

### 2.3 The uncomputed part, flagged

The fixed-point networks of the `10`- and `12`-dimensional spin irreducibles
are still not computed in-repo (`SUPPORT_CENSUS.md` §7.5).  Nothing above
depends on them: Theorems W1 and W3 are uniform in the source, and the
verdict `OPEN with a witness` holds for any `V` whose relevant stratum is
nonempty, while for a `V` whose stratum is empty the corresponding cell is
vacuous.  What is **not** available without them is a *count* of candidate
supports per source, which no verdict here uses.

---

## 3. Adversarial tests

### O15-T1.  The mandatory `D_12` test — PASSED

The two new kills live at strata whose pointwise kernel has order divisible
by 11, and `11` does not divide `|D_12| = 12` (§H3, §H4), so neither is
visible to the realised dominant `D_12`-equivariant spin map of Cor IX.6.
The `(O1)` verdict claims no kill at all.  `dim T^{D_12} = 2 > 0`, so the
channel the realised map needs is left open by everything here (§H6).
**PASS.**

### O15-T2.  Does `K-n` contradict Cor S4's floor `k(F_55) = 5`? — NO, it explains it

`K-n` says the equivariant structure must be five-dimensional; Cor S4 says
the abelian factor must contain five copies of `E_{-11}`.  These are the same
phenomenon seen twice — `Res_{F_55}T` is `Q`-irreducible of dimension 10 with
`theta_1 (+) theta_2` its complex decomposition — and they are consistent.
A rank-one channel could not have supplied the five copies anyway; `K-n` is
the sheaf-level shadow of the arithmetic floor.

### O15-T3.  Is Theorem W3 applied at the right group? — YES

W3 is an `H_0`-level rule and needs `H_0` to act **trivially** on `S`.  On
`P(V)^{C_11}` and `P(V)^{F_55}` the kernel acts trivially by definition of
the fixed locus, so the hypothesis holds.  It is *not* applied at `(O4)`,
where `H_0 = C_2` acts trivially on the eigenplane but the interesting group
`C_3` does not — there the finer Prop O4-3 governs, and W3 correctly gives
nothing (`C_2` has no dead channel).

### O15-T4.  Does `(O1)`'s verdict make the capacity table pointless? — NO

The table is still the only screen that touches `d = 2` (kill `K-g`), and it
is what forces the 364 mandatory points onto positive-dimensional base
components at that degree.  What Prop O1-1 denies is only that capacity can
be promoted into an all-degree obstruction.

---

## 4. Exit

```text
O1-OPEN-WITH-WITNESS
O5-OPEN-WITH-WITNESS
MIN-LIVE-DEGREE-COMPUTED                   (Thm O1-0: d = 4 for V = U,
                                            d = 2 for V = U^{(+)m}, m >= 2;
                                            closes named task sec.7.4)
MIN_DEGREE_OK                              (verifier marker, 114 assertions)
K-m  C_11-STRATUM-CONSTANT-CHANNEL-DEAD    (new, all sources, all m)
K-n  F_55-STRATUM-RANK-ONE-CHANNELS-DEAD   (new, all sources, all m)
```

`O1-DEAD` and `O5-DEAD` are **not** claimed and are unreachable by this
machinery.
