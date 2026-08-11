# Dependency map: which residual controls which census cell

**Step 0 of the residuals campaign, 2026-08-11.**  Written and pushed *before*
any attack on `R1`, `R2`, `R3`, because its answer re-scopes the campaign.

`TOTAL_DEGENERATION.md` §6 boxes three residuals that a stronger-than-
Hodge-support method must supply.  This file asks the prior question: **if all
three closed, what would close?**

Machine: `python3 verify_r0_dependency.py` → `R0_DEPENDENCY_OK`, exact,
stdlib only.  Section references `§A`-`§F` point at that script.

---

## 0. Headline, stated first

```text
+---------------------------------------------------------------------------+
| O4 BLOCKS THE HEADLINE REGARDLESS.                                        |
|                                                                           |
| Closing R1, R2 and R3 together does NOT close the spin route.  Two of     |
| the five boxed families survive all three untouched:                      |
|                                                                           |
|   (O4d)  the Hesse-cubic witness of Thm O4-5 -- a CURVE support with      |
|          CONSTANT coefficients.  R1 and R2 are statements about point     |
|          supports (the fibre dimension delta(x) of q over a base point);  |
|          R3 is a statement about NONCONSTANT local systems.  None of the  |
|          three has any bearing on a constant-coefficient curve support.   |
|                                                                           |
|   (O1)   the POSITIVE-DIMENSIONAL layer of the free cell S0 (H_0 = 1,     |
|          1 <= s <= n-3).  The (O1) box records a witness only for its     |
|          POINT layer (cell P0); its positive-dimensional layer is open,   |
|          unwitnessed AND uncontrolled by R1-R3.                           |
|                                                                           |
| Therefore SPIN-ROUTE-CLOSED-NEGATIVE is NOT reachable by closing R1-R3,   |
| and the Cor IX.5 consequence chain cannot be triggered along this route   |
| however the three residuals come out.  The maximum available prize is a   |
| REDUCTION, boxed in section 5.                                            |
+---------------------------------------------------------------------------+
```

What R1-R3 *do* buy is stated exactly in §5 and is worth having: they
collapse an 18-cell census with five boxed families into a **single
constant-coefficient positive-dimensional frontier**, and — via the
unique-jump ledger of §2 — into one of exactly three mutually exclusive
scenarios indexed by the dimension of the support.

---

## 1. The residuals, restated as the exact predicates they are

Standing notation as in `THEOREM_SPIN_HODGE_SUPPORT.md`.  For a point
`x in Bs(phi)` write

\[
\delta(x)\;:=\;\dim q\bigl(p^{-1}(x)\bigr)\;=\;\dim Z_x ,
\]

which satisfies `2 <= delta(x) <= 3` at any carrying point support
(Prop S5, Cor S6).

| | predicate | scope |
|---|---|---|
| **R1** | `delta(x) < 3` for `x` in each mandatory `G`-orbit — i.e. **no total degeneration** (Lemma W0: not every fibre closure of `phi` passes through `x`) | point supports only |
| **R2** | no `H`-equivariant finite cover `Y_x -> Z_x` of an **ample divisor** `Z_x subset V14` has `E_{-11}` in `Alb(\widetilde{Y_x})` in a live channel — i.e. `delta(x) != 2` | point supports only |
| **R3** | no **nonconstant** local system on an eigen-stratum carries an `E_{-11}`-isotypic weight-one block | positive-dimensional supports with `L != Q` only |

The boxed Residual 1 of `TOTAL_DEGENERATION.md` §6 asks for `delta(x) <= 1`;
that is exactly `R1 and R2`.  We keep them apart because they are attacked by
different machinery and can fail independently.

> **Observation D1 (R2 is not confined to the mandatory points).**  Prop O2-3
> is stated at cells `P5`, `P6`, but its proof uses only `rho(V14) = 1` and
> `b_1(V14) = 0`.  Any `Z_x` of dimension 2 in `V14` is a nonzero effective
> divisor, hence in `|kH|`, hence ample.  So **R2 as a predicate applies
> verbatim at all nine point cells `P0`-`P8`**, not only at `P5`, `P6`.  This
> is what makes "R1 and R2 kill the whole point layer" a coherent statement.

---

## 2. The unique-jump ledger, and what it forces

This is the structural fact that organizes the whole map, and it is a
consequence of material already in the packet rather than a new input.

> **Proposition D2 (one jump, one dimension).**  Let `phi` be a dominant
> `G`-equivariant spin map, `j_0` its unique perverse jump (Thm S3(2)).  In
> the **constant-coefficient** channel the carrier of a strict support of
> dimension `s` is `IH^{s+4-n-j_0}(\overline S,\mathbf Q)`, which is pure of
> weight `s+4-n-j_0`; the carrier must be a weight-one Hodge structure, so
> \[
> s+4-n-j_0 = 1,\qquad\text{i.e.}\qquad \boxed{\,j_0 = s+3-n\,}.
> \]
> A point support forces `j_0 = 4-n` independently (Prop S5).  Hence, for a
> given `phi`:
>
> 1. all constant-coefficient carrying supports have the **same** dimension
>    `s = j_0 + n - 3`;
> 2. point supports coexist with constant-coefficient **curve** supports and
>    with nothing else (`s = 1` gives `j_0 = 4-n` too);
> 3. surfaces (`j_0 = 5-n`) and threefolds (`j_0 = 6-n`) each exclude points,
>    each other, and curves.

*Proof.*  The displayed weight computation is the packet's own ledger
(`THEOREM_SPIN_HODGE_SUPPORT.md` §7, rows "point support", "curve `H^1`",
"surface `H^1`", "threefold `H^1`"), read backwards: `i = s+4-n-j_0` and
`IH^i` of a projective variety with constant coefficients is pure of weight
`i`, while the carrier receives an injection from the weight-one `T` after the
Tate twist.  Uniqueness of `j_0` is Theorem S3(2), which needs only the
`Q`-irreducibility of `T` (Theorem S0(1)).  `QED`

Proposition D2 is *not* available in the nonconstant-coefficient channel: a
polarizable VHS `L` of weight `w` gives `IH^i(\overline S,L)` of weight `i+w`,
so `i+w = 1` with `w` free, and every `s` is compatible with every `j_0`.
That asymmetry is the whole reason `R3` exists as a separate residual.

**Regression.**  §B of the verifier recomputes the ledger for
`n = 6,...,12` and `s = 0,...,n-3` and checks (1)-(3) and the `n = 5`
ambient regression.

---

## 3. The map, cell by cell

Read: **"controlled by"** = the residual(s) whose closure removes the cell;
**"—"** = no residual in the box touches it.

### 3.1 The nine point cells (`SUPPORT_CENSUS.md` §5.1)

| cell | `H` | orbit | witness | branch `delta=3` | branch `delta=2` | dies under `R1 and R2`? |
|---|---|---:|---|---|---|---|
| `P0` | `1` | 660 | W1 | **R1** | **R2** | **YES** |
| `P1` | `C_2` | 330 | W1 | **R1** | **R2** | **YES** |
| `P2` | `C_3` | 220 | W1 | **R1** | **R2** | **YES** |
| `P3` | `C_5` | 132 | W1 | **R1** | **R2** | **YES** |
| `P4` | `C_6` | 110 | W1 | **R1** | **R2** | **YES** |
| `P5` | `S_3` | 220 | W1 | **R1** | **R2** | **YES** (mandatory orbit) |
| `P6` | `D_10` | 132 | W1 | **R1** | **R2** | **YES** (mandatory orbit) |
| `P7` | `C_11` | 60 | W1 | **R1** | **R2** | **YES** |
| `P8` | `F_55` | 12 | W1 | **R1** | **R2** | **YES** (mandatory orbit) |

A point cell dies **iff both** branches die: `delta(x) in {2,3}` is exhaustive
by C4 and C5, so excluding only one branch leaves the cell witnessed by the
other.  `R1` alone kills nothing; `R2` alone kills nothing.

The mandatory orbits are the ones at which `R1`/`R2` need only be proved for a
*single* `phi`-independent reason: the 220 `S_3`-points and 132 `D_10`-points
(Thm K4) and the 12 `F_55`-points (Thm O3-3) are in `Bs(phi)` for **every**
`G`-equivariant map.  At the other six cells the point is not known to be in
`Bs(phi)` at all, so those cells are conditional on the configuration and die
for free once the mandatory ones do — *no*: they do not.  A carrying point
support may be a free point (`P0`) that no theorem places in `Bs(phi)` in
advance.  So `R1`/`R2` must be proved **for an arbitrary base point of a
dominant equivariant spin map**, not merely at the 364 mandatory ones.  This
is a strictly larger demand than the `TOTAL_DEGENERATION.md` §6 box states,
and it is recorded here as a correction to that box.

### 3.2 The nine positive-dimensional cells (`SUPPORT_CENSUS.md` §5.2)

| cell | `H_0` | live layer for `V = U` | witness | controlled by | dies under `R1 and R2 and R3`? |
|---|---|---|---|---|---|
| `S0` | `1` | `s in [1, n-3]`, any `H`, constant or not | none | **—** (constant part); `R3` (nonconstant part) | **NO** |
| `S1` | `C_2` | eigenplane curves `s = 1` (`O4d`, `O4e`); whole plane `s = 2` only with `L != Q` (`O4g`) | **Thm O4-5** (`O4d`) | **—** for `O4d`/`O4e`; `R3` for `O4g` | **NO** |
| `S2` | `C_3` | eigen-lines: constant channel already DEAD (K-k); residual `O4g` | none | `R3` | **YES** (for `V = U`) |
| `S3` | `C_5` | eigen-lines: constant channel already DEAD (K-k); residual `O4g` | none | `R3` | **YES** (for `V = U`) |
| `S4` | `C_6` | empty for `U`; `P^{m-1}` for `m >= 2` | point layer `P4` | point layer `R1`+`R2`; positive-dim layer **—** | **NO** (for `m >= 2`) |
| `S5` | `C_11` | empty for `U`; `P^{m-1}` for `m >= 2`, constant channel DEAD (K-m) | point layer `P7` | point layer `R1`+`R2`; residual `R3` | **YES** (for `m >= 2`, given K-m) |
| `S6` | `S_3` | empty for `U`; `m >= 2` | point layer `P5` | point layer `R1`+`R2`; positive-dim layer **—** | **NO** (for `m >= 2`) |
| `S7` | `D_10` | empty for `U`; `m >= 2` | point layer `P6` | point layer `R1`+`R2`; positive-dim layer **—** | **NO** (for `m >= 2`) |
| `S8` | `F_55` | empty for `U`; `m >= 2`, only `theta_1`, `theta_2` (K-n) | point layer `P8` | point layer `R1`+`R2`; residual `R3` + the `theta` channels | **NO** (the `theta_i` channels are rank 5, not rank one, and `K-n` does not touch them) |

### 3.3 Summary by boxed family

| family | closed by `R1 and R2 and R3`? | what survives |
|---|---|---|
| `(O1)` free supports | **NO** | the whole positive-dimensional layer `s in [1,n-3]`, `H_0 = 1`, constant coefficients |
| `(O2)` 352 mandatory points | **YES** | — |
| `(O3)` odd-order points | **YES** | — |
| `(O4)` eigen-strata | **NO** | `O4d` (the Hesse cubic `~= E_{-11}`), `O4e` (higher-degree eigenplane curves) |
| `(O5)` multiplicity strata | **NO** | positive-dimensional constant-coefficient supports inside the `C_6`, `S_3`, `D_10`, `F_55` strata at `m >= 2`, and the `theta_i` channels at `F_55` |

---

## 4. Does the `O4` witness survive `R1`, `R2`, `R3`? — line by line

This is the mission's decisive question, so it is answered against the witness
itself rather than against the cell label.  Theorem O4-5's datum is: an
irreducible **curve** `S subset Pi` inside an involution eigenplane, smooth,
`S ~= E_{-11}`, `Stab_G(S) = H = C_6`, pointwise kernel `H_0 = C_2`, the
residual `C_3` acting by translation, the local system **constant**, the
equivariant structure `psi_j` with `j != 3`, carrier `H^1(S,Q) (x) psi_j`,
orbit 110, `j_0 = 4-n`.

| residual | its hypothesis | does the witness satisfy the hypothesis? | effect on the witness |
|---|---|---|---|
| `R1` | the block is supported at a **point** `x`, and one bounds `delta(x) = dim q(p^{-1}(x))` | **NO** — `dim S = 1 > 0`, so the block is `IC_{\overline S}(Q)`, not a skyscraper.  There is no `Y_x` in the statement and no `delta` to bound | **none** |
| `R2` | `delta(x) = 2`, so `Y_x` is a surface finite over an ample divisor of `V14` | **NO** — same reason.  Prop O2-3 is about exceptional fibres of `p`, and the witness constrains no fibre of `p` at all | **none** |
| `R3` | the local system `L` on the support is **nonconstant** | **NO** — the witness uses `L = Q`.  `O4_EIGENPLANE_CURVES.md` §7 puts nonconstant systems in the disjoint subcell `O4g` | **none** |

So all three miss, and they miss for a structural reason rather than by an
accident of statement: `R1` and `R2` are constraints on the **fibres of `p`**,
`R3` is a constraint on the **coefficients**, and the `O4` witness is a
constant-coefficient block on a positive-dimensional **support**, which is the
one combination none of them addresses.

The same three-line audit applied to the free cell `S0` at any `s >= 1` gives
the same answer, with the additional point that `S0` has no eigen-stratum
structure at all, so even a strengthened `R3` covering *all* strata rather than
the eigen-strata would leave the constant-coefficient part of `S0` untouched.

**Consistency with Cor IX.6 (the realised `D_12`-map).**  Nothing in this file
is a kill, so the mandatory `D_12` test is passed vacuously; informatively, the
two families that survive `R1`-`R3` are exactly the two the realised
`D_12`-equivariant map is free to occupy (`dim T^{D_12} = 2 > 0`, all three
`D_12`-channels of multiplicity 2 — `O4_EIGENPLANE_CURVES.md` §8, O4-T1).  A
dependency map that had shown `R1`-`R3` closing everything would have been in
tension with Cor IX.6 at once, since the realised map has base points too.

---

## 5. Re-scoped campaign: the reduced frontier that `R1`-`R3` actually buy

```text
+---------------------------------------------------------------------------+
| REDUCED FRONTIER (what remains if R1, R2 and R3 all close).               |
|                                                                           |
| Let phi : P(V) --> V14 be dominant G-equivariant, V a faithful spin        |
| source.  Then there is a G-orbit of irreducible subvarieties               |
|         S subset Bs(phi),     1 <= s := dim S <= n-3,                     |
| with pointwise kernel H_0 = Stab_G(S)_{ptwise} in Sigma_spin and setwise   |
| stabiliser H, carrying a CONSTANT-COEFFICIENT strict-support block whose   |
| carrier                                                                   |
|         IH^1(Sbar, Q) = H^1(Stilde, Q)   (Stilde a smooth model)          |
| admits a nonzero H-equivariant map of Hodge structures from Res_H T; i.e.  |
|         E_{-11}  is an isogeny factor of  Jac(Stilde) resp. Alb(Stilde),  |
| in a channel not killed by K-d, K-f, K-i, K-j, K-k, K-l, K-m, K-n.        |
|                                                                           |
| Moreover (Prop D2) the perverse jump is j_0 = s+3-n, so ALL carrying       |
| supports of that phi have the SAME dimension s, and the frontier splits    |
| into exactly three mutually exclusive scenarios:                          |
|                                                                           |
|   FRONTIER-1  s = 1: a G-orbit of CURVES in Bs(phi) with E_{-11} in the   |
|               Jacobian.  NONEMPTY: Thm O4-5 (110 Hesse cubics).           |
|   FRONTIER-2  s = 2: a G-orbit of SURFACES in Bs(phi) with E_{-11} in     |
|               the Albanese.  Status unknown.                             |
|   FRONTIER-3  s = 3: a G-orbit of THREEFOLDS in Bs(phi) with E_{-11} in   |
|               the Albanese; only for n >= 6, i.e. only on a spin source.  |
|               Status unknown.                                            |
|                                                                           |
| FRONTIER-1 IS WITNESSED, so the reduction is a reduction and never a      |
| closure.  What R1-R3 remove is the entire POINT layer (nine cells) and    |
| the entire NONCONSTANT-COEFFICIENT layer.                                 |
+---------------------------------------------------------------------------+
```

Two remarks on the value of the reduction, stated without inflation.

* It is a genuine simplification: the surviving question is about
  **subvarieties of the base locus and their Albanese varieties**, an
  ordinary projective-geometry question, with no perverse sheaf, no fibre of
  `p` and no local system in it.  The census's five families, nine point
  cells and fifteen kills collapse to one line.
* It is not a route to the headline.  `FRONTIER-1` is occupied by an explicit
  curve, so no argument that closes `R1`, `R2` and `R3` can, by itself, reach
  `SPIN-ROUTE-CLOSED-NEGATIVE`.  Reaching it would additionally require
  excluding `E_{-11}` from the Jacobians of the `G`-orbits of curves inside
  `Bs(phi)` — and `O4_EIGENPLANE_CURVES.md` Thm O4-5 already proves that
  exclusion **false** for the eigenplane family.  The only way the headline
  could still be reached along this route is a *different* input that
  forbids those particular curves from being strict supports (as opposed to
  forbidding their Hodge theory), and the package has no such input:
  `THEOREM_POINT_SUPPORT.md` §1's caveat — a strict support need not be a
  base component — removes even the capacity screen.

---

## 6. What this changes in the campaign, concretely

1. `R1` is still worth attacking, but its prize is the **point layer**, not
   the headline.  Its correct target is *every* base point of a dominant
   equivariant spin map, not only the 364 mandatory ones (§3.1).
2. `R2` and `R3` are worth attacking only to the extent that they finish the
   point layer (`R2`) and the coefficient layer (`R3`); neither can reach a
   cell that `R1` leaves alive.
3. The cell that decides the route is **not** among `R1`-`R3` at all.  It is
   `FRONTIER-1`, i.e. cell `S1`/`(O4d)` together with the constant-coefficient
   curve layer of `S0`/`(O1)`.  If a future campaign wants the headline, that
   is where the new input has to go.
4. `SPIN-ROUTE-CLOSED-METHOD-INSUFFICIENT` (2026-08-11) is therefore
   **not** upgradable by this campaign.  The reachable exits are
   `RESIDUALS-PARTIAL` plus the boxed reduction, or per-residual
   `METHOD-INSUFFICIENT` with witnesses.

---

## 7. Exit

```text
DEPENDENCY-MAP-COMPUTED
O4-BLOCKS-HEADLINE-REGARDLESS      (section 4: R1, R2, R3 all miss the Thm O4-5 witness)
FREE-LAYER-BLOCKS-HEADLINE-REGARDLESS (section 3.2: cell S0, s >= 1, is uncontrolled)
UNIQUE-JUMP-DIMENSION-RULE         (Prop D2)
R2-SCOPE-IS-ALL-POINT-CELLS        (Observation D1)
REDUCED-FRONTIER-BOXED             (section 5)
R0_DEPENDENCY_OK                   (verifier marker)
```

`RESIDUALS-ALL-CLOSED => SPIN-ROUTE-CLOSED-NEGATIVE` is **refuted** as an
implication.  The campaign is re-scoped accordingly, at its start rather than
at its end.
