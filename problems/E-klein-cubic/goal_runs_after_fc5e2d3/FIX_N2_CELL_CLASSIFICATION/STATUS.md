# Status — FIX-N2, local cell classification at the V4 stratum

**Primary exit:** `FIX-N2-CELLS-PARTIAL`

**Problem E headline: OPEN.**

Packet: `goal_runs_after_fc5e2d3/FIX_N2_CELL_CLASSIFICATION/`.
Frame: `theory/FIX_II_jets.md` §4.  Base packet:
`goal_runs_after_f1f0be/V4_SIMULTANEOUS_ODD_NORMALS_20260802/`.

## Per-task exits

| task | claim | exit |
|---|---|---|
| 1 | `m=1`, `r <= 2`: the cone forbids `r <= 1`; the cell `(1,2)` has the unique shape `(0,0,A yz,B zx,C xy)` and landing equation `ABC = 0`; residual `C_3` kills it. EMPTY for all line degrees. | `FIX-N2-M1-RLE2-EMPTY` |
| 2 | `m=1`, `r >= 4`, all line degrees: **EMPTY for `r = 4` and `r = 5`** (new; and the same argument re-proves and strengthens the base packet's Theorem 2.12 at `r=3`). At `r = 6`: **not populated at line degree zero** (no plane-order-1 point on the `C_3`-equivariant cone); positive line degree at `r=6` reduces to one explicit ladder step (`CELL_TABLE.md` §5). `r >= 7` not decided (the Groebner computation did not terminate). **No `m=1` cell is populated anywhere in the computed range**, and `m=1` is provably unreachable by multiplying a lower cell by an invariant (invariants have even `ord_{P_i}`), unlike `m=2`. | `FIX-N2-M1-R4PLUS-EMPTY-THROUGH-R5` (principal target **PARTIAL**) |
| 3 | odd `m >= 3` above the first permissible layer: **POPULATED**, with two explicit `A_4`-equivariant witnesses at `m=3`: `(3,8)` (imprimitive: `(x^2+y^2+z^2)` times the base packet's §4 family) and `(3,9)` (**primitive**, from a new generalised §4 construction with `X = x y^2`). General odd `m = 2k+1`: multiply by `(xyz)^{k-1}`, so the layers `r = 3k+5` and `r = 3k+6` above the first layer `r = 3k+3` are populated. | `FIX-N2-ODD-M-ABOVE-FIRST-LAYER-POPULATED` |
| 4 | even `m`: the bottom cell `(m, 3m/2)` is EMPTY for all line degrees, **for every even `m`** (uniform proof: the layer is one-dimensional, spanned by `(xyz)^{m/2}` of trivial character, landing equation `kp p^3 + km q^3 = 0`), and `(2,3),(2,4),(2,5)` are EMPTY.  **BUT `(2,6)` is POPULATED** — an explicit `A_4`-equivariant witness, `xyz` times the `delta = 1` seed of the generalised §4 construction; more generally `(2k, 3delta+3k)` for odd `delta`.  So even `m` is *not* uniformly empty; the empty/populated boundary in the even rows is `r = 3m/2 .. 3m/2+2` empty, `r = 3m/2+3` populated at `m = 2`. | `FIX-N2-EVEN-M-BOTTOM-EMPTY` **and** `FIX-N2-M2-R6-POPULATED` |
| 5 | cross-checks: the base packet's `(2.1),(2.4),(2.5),(2.6),(2.7),(2.8)` are reconstructed termwise by independent code; Theorem 2.12 is re-obtained by a *different* argument (Specialisation Lemma) and in stronger form; the §4 family's landing identity **and** its residual-`C_3` equivariance (scalar `lam = om^2`, with the exact rescaling `a=w, u_0=v_0, u_1=om v_1, u_2=om^2 v_2`) are verified from scratch. | `FIX-N2-CROSSCHECKS-PASS` |

## New instrument

**Specialisation Lemma** (`CELL_TABLE.md` §2).  The `t`-adic graded pieces of an
`A_4`-equivariant landing family at a `C_3`-fixed point of the triple line are
`C_3`-equivariant *pointwise* tuples, the bottom one is nonzero and satisfies
`F = 0`.  Hence emptiness of a whole order-`r` stratum, for **all line degrees at
once**, is decided by a finite computation in a space of dimension `~ (cell
dim)/3`.  This is what makes `r = 4, 5` reachable at all; the base packet's
`[p:q]`-constancy argument does not generalise past `r = 3`.

## Convention reconciliation (stated, as required)

* `m` = common involution-plane order, `r` = triple-line order (the FIX-N2 brief
  and Note II §4).  **The base packet's §4 uses `r` for a different quantity** —
  the index in `m = 2r+1`, `(J_m)_{3r+3} = (xyz)^{r-1}(J_3)_6`.  Here that index
  is written `k`: `m = 2k+1`, first permissible layer at `r = 3k+3`.  So the
  packet's §2 stratum is the cell `(1,3)` and its §3/§4 stratum is `(3,6)`.
* Characters are encoded as in the base packet's `verify.py`
  (`char(x^A y^B z^C) = ((A+C)%2,(B+C)%2)`); the verifier re-derives the same
  partition from the explicit `V4` sign action, so no result depends on the
  labelling.
* `J_m` at degree `r` = "all exponents `<= r-m`", so `m = r - (max exponent)`.
* Klein constants exact: `om^2+om+1=0`, `8 kp^2-13 kp-4=0`, `km = 13/8 - kp`.

## Proved

1. Cell dimension table and the explicit `K`-equivariant shape of every cell
   (parity table made explicit; `PAYLOAD_dims.txt`, `PAYLOAD_shapes.txt`).
2. Specialisation Lemma.
3. **Theorem A**: for `r = 2,3,4,5` there is *no* `A_4`-equivariant landing
   family with `m >= 1`, in any line degree.  Three independent engines agree
   (Macaulay2 `dim I`; a from-scratch Macaulay rank certificate over
   `F_100057`; msolve coordinate-saturation).
4. **Theorem B**: every even-`m` bottom cell `(m,3m/2)` is empty, all line
   degrees.
5. **Lemma C**: `(J_{m+2})_{r+3} = xyz (J_m)_r` when `r <= 2m`, so emptiness
   propagates along `(m,r) -> (m+2,r+3)`.
6. **Theorem D**: generalised §4 construction — every character-`chi_1` form `X`
   of degree `delta` gives an `A_4`-equivariant landing family of triple-line
   order `3 delta` at line degree 0 (positive line degree after the `l_i`
   precomposition).  Exact residual-`C_3` scalar `lam = om^2` (the base packet
   asserts the equivariance but does not exhibit the scalars; they force the
   rescaling `a=w, u_0=v_0, u_1=om v_1, u_2=om^2 v_2`).
7. **Theorem E**: that construction yields `m = 0` or `m >= 3`; with the
   `xyz`-shift the reachable orders are `{2k} ∪ {m_0+2k : m_0 >= 3}` —
   **never `m = 1`**.
8. **Corollary E'**: `(2,6)` is POPULATED (explicit char-0 witness).
9. **Theorem F**: the layers above the first permissible layer at odd `m` are
   populated; explicit primitive and imprimitive witnesses.
10. `r = 6` resolved by plane order: no plane-order-1 point on the
    `C_3`-equivariant cone; plane-order-2 points exist and are exactly
    `xyz * seed`.

## Not proved

* `m = 1` for `r >= 6` (positive line degree at `r=6`; anything at `r >= 7`) —
  the principal target is **PARTIAL**.  The `r = 6` obstruction is reduced to
  one explicit finite linear-algebra step (`CELL_TABLE.md` §5); the
  plane-order-graded shortcut is shown to be vacuous there, so that route should
  not be retried.
* `r = 7` triviality: the Groebner computation (13 parameters, 18 orbit-reduced
  cubics) did not terminate in Macaulay2, msolve or the Macaulay-rank verifier
  within this packet's budget.  It is a finite, well-posed computation and would
  settle `(1,7), (2,7), (3,7)` in one go.
* Whether triple-line order divisible by 3 is *necessary* for population
  (all known families have `r = 3 delta`; `r = 2,3,4,5` are empty, consistent).
* Nothing about the Problem E headline.  By Note II §5 no configuration of cell
  statements decides it.

## Replay

See `REPLAY.md`.  Terminal line of the verifier:
`FIX_N2_CELL_CLASSIFICATION_VERIFY_OK`.
