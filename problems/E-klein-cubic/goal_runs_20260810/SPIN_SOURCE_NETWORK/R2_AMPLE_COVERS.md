# Residual 2: covers of ample divisors of the `V14` carrying `E_{-11}`

`TOTAL_DEGENERATION.md` §6, Residual 2: granting `delta(x) = 2`, exclude
`H`-equivariant finite covers `Y_x -> Z_x` of ample divisors of `V14` with
`E_{-11}` in `Alb(\widetilde{Y_x})`, in a live channel.

Verdict: **`R2-NARROWED-NOT-CLOSED`.**  The cell is cut down by two new
results — every **cyclic** cover branched along a nef-and-big class is dead
(Thm R2-2), and at the 12 `F_55`-points the image divisor cannot be a
hyperplane section at all (Prop R2-4) — but the residual is nonempty and its
shape is identified exactly (§4).

Machine: `python3 verify_r2_covers.py` → `R2_COVERS_OK`, exact, stdlib only.

Standing notation as in `THEOREM_SPIN_HODGE_SUPPORT.md`; `x in Bs(phi)` a
point support with `dim Y_x = 2`, `H = Stab_G(x) in Sigma_spin`,
`Z_x = q(Y_x) subset V14`, `Y_x -> Z_x` finite and `H`-equivariant (Cor S6),
`\widetilde{Y_x}` a smooth projective model.

---

## 1. The demand, restated as a fibration

> **Proposition R2-1.**  The condition of Corollary C5 — `E_{-11}` occurs, up
> to isogeny, in `Alb(\widetilde{Y_x})` — is equivalent to:
> \[
> \widetilde{Y_x}\ \text{admits a surjective morphism onto an elliptic curve
> isogenous to } E_{-11}.
> \]

*Proof.*  If `E subset Alb` up to isogeny, Poincaré reducibility gives a
surjection `u : Alb(\widetilde{Y_x}) -> E'` with `E'` isogenous to `E`.  The
composite `\widetilde{Y_x} -> Alb -> E'` is nonconstant, because the image of
`\widetilde{Y_x}` generates `Alb` as a group and a constant composite would
force `u = 0`; a nonconstant morphism from a projective variety to a curve is
surjective.  Conversely a surjection `\widetilde{Y_x} -> E'` induces
`Alb(\widetilde{Y_x}) -> E'` surjective, so `E'` is an isogeny factor.  `QED`

So `R2` asks: **can a finite cover of an ample divisor of the `V14` fibre over
`E_{-11}`, `H`-equivariantly?**  Prop O2-3 already says the divisor itself
cannot (`rho(V14) = 1`, `b_1(V14) = 0`, Lefschetz), so the fibration must be
created by the covering.

Two ambient facts, recorded because they pin the geometry of `Z_x` (§A):

* `-K_{V14} = H` (index 1, sealed), so for a **smooth** `Z_x in |kH|`
  adjunction gives `K_{Z_x} = (k-1)H|_{Z_x}`.  In particular
  `k = 1`: `Z_x` is a **K3 surface** of genus 8 and degree 14;
  `k >= 2`: `Z_x` is of general type with ample canonical class.
* `q(Z_x) = 0` in both cases (Prop O2-3), and for `k = 1` also
  `h^1(O_{Z_x}) = 0` directly.

---

## 2. Cyclic covers are dead

> **Theorem R2-2 (new).**  Let `Z` be a smooth surface with `q(Z) = 0` and
> `K_Z` nef (both hold for every smooth `Z_x in |kH|` on the `V14`), let `L`
> be a nef and big line bundle on `Z`, let `B in |nL|` be a smooth divisor and
> let `Y -> Z` be the associated smooth cyclic `n`-cover.  Then
> \[
> q(Y)=0 .
> \]
> Consequently no cyclic cover of a smooth ample divisor of the `V14`,
> branched along a nef-and-big class, satisfies Corollary C5.

*Proof.*  For the cyclic cover `pi : Y -> Z` determined by `L^{n} = O(B)`,
\[
\pi_*\mathcal O_Y=\bigoplus_{i=0}^{n-1}\mathcal O_Z(-iL),
\qquad\text{so}\qquad
q(Y)=h^1(\mathcal O_Y)=\sum_{i=0}^{n-1}h^1\bigl(\mathcal O_Z(-iL)\bigr).
\]
The `i = 0` term is `q(Z) = 0`.  For `i >= 1`, Serre duality gives
`h^1(Z, -iL) = h^1(Z, K_Z + iL)`, and `K_Z + iL` is `K_Z` plus a nef and big
divisor, so Kawamata–Viehweg vanishing gives `h^1 = 0`.  (For `k = 1`,
`K_Z = 0` and ordinary Kodaira vanishing suffices.)  `QED`

This is strictly stronger than Prop O2-3, which only removed the birational
case.  It says the branching cannot create the irregularity **as long as the
covering is cyclic and the branch class is positive** — precisely the two
hypotheses the `TOTAL_DEGENERATION.md` §6 box left open when it wrote
*"branched covers of regular surfaces have unbounded irregularity"*.  That
sentence is true, and Theorem R2-2 locates exactly where the unboundedness has
to come from:

> **Corollary R2-3 (the residual, exactly).**  If `dim Y_x = 2` and Cor C5
> holds, then at least one of the following is true:
>
> 1. `Z_x` is **singular**;
> 2. the cover `Y_x -> Z_x` is **not cyclic** (equivalently, its Galois
>    closure has non-cyclic group, or it is non-Galois);
> 3. the branch divisor's class is **not nef and big** — which, since
>    `Pic(V14) = Z H`, requires `Pic(Z_x)` to be strictly larger than the
>    restriction of `Pic(V14)`.

Item 3 is not vacuous: `Z_x` is `H`-invariant, hence not a general member of
`|kH|`, so Noether–Lefschetz does not apply to it and `Pic(Z_x)` may well
exceed `Z\cdot H|_{Z_x}`.

---

## 3. What the equivariance adds

> **Proposition R2-4 (the `F_55` narrowing).**  `H^0(V14,\mathcal O(1)) = M^*`
> (the model is anticanonical, `h^0(-K) = 10 = dim M`, sealed).  A
> `K`-invariant divisor in `|H|` is a `K`-stable line in `M^*`.  Since
> `Res_{F_55}M^* = theta_1 (+) theta_2` contains **no** linear character (§B),
> there is no `F_55`-invariant hyperplane section of the `V14`.  Hence at the
> 12 mandatory `F_55`-points,
> \[
> Z_x\in|kH|\quad\text{with}\quad k\ge 2,
> \]
> so `Z_x` is of **general type**, never a K3.
>
> For the other stabilisers the corresponding obstruction is absent:
> `dim (M^*)^{S_3} = 3`, `dim (M^*)^{D_{10}} = 2`, and every character `psi^a`
> of `C_{11}` occurs once in `M^*`, so `S_3`-, `D_{10}`- and `C_{11}`-stable
> hyperplane sections all exist (§B).

*Proof.*  The multiplicities are `<Res_H chi_M, chi>` for `chi` linear,
computed exactly in §B from `chi_M = (10,2,1,0,-1,-1)` on orders
`(1,2,3,5,6,11)`.  `QED`

At `k >= 2` the `F_55`-case is not excluded: `(S^2M)^{C_{11}}` is
five-dimensional and carries the **regular** representation of
`C_5 = F_{55}/C_{11}` (the five `C_{11}`-weight pairs `\{a,-a\}` form one
`\langle 3\rangle`-orbit, §B), so each of the five linear characters of
`F_55` occurs once among the `F_55`-semi-invariant quadrics of `P(M)`.

**Channel bookkeeping.**  The live channels at `dim Y_x = 2` are the ones the
census leaves open: trivial and `std` at `S_3`, trivial and `W_1`, `W_2` at
`D_10` (sign dead, `K-d`), and only `theta_1`, `theta_2` at `F_55` (`K-n`
kills every rank-one channel).  Cor S4's floor is `k(H) = 1` except at
`C_11`, `F_55`, where it is `5`: at those two cells `Alb(\widetilde{Y_x})`
must contain `E_{-11}^5`, i.e. `\widetilde{Y_x}` must fibre over five
independent copies (Prop R2-1 applied to a `5`-dimensional isotypic factor),
so `q(\widetilde{Y_x}) >= 5`.

---

## 4. The shape of a witness, and why one is not constructed here

Corollary R2-3 says a witness needs a singular `Z_x` or a non-cyclic cover.
The natural candidate is the classical one:

```text
+---------------------------------------------------------------------------+
| CANDIDATE WITNESS SHAPE for R2 (not constructed, and not claimed).        |
|                                                                           |
|   Z_x  = a NODAL member of |kH| whose minimal resolution is a Kummer       |
|          surface Km(A) with A ~ E_{-11} x E_{-11};                        |
|   Y_x  = A itself, with A -> A/{+-1} = Z_x the degree-two quotient,        |
|          which is FINITE, and Alb(A) = A contains E_{-11} twice.          |
|                                                                           |
| Every hypothesis of Cor C5 is then met except that Z_x must actually sit   |
| inside the V14 with the right H-action.  Theorem R2-2 does not apply,      |
| because Z_x is singular and the "cover" is the quotient by an involution   |
| acting freely nowhere.                                                    |
|                                                                           |
| WHY IT IS NOT CLAIMED.  A 16-nodal member of |H| cannot exist: |H| = P^9   |
| is 9-dimensional and imposing 16 nodes is 16 conditions.  So k >= 2 is     |
| forced for this shape too, and deciding whether a 16-nodal K-invariant     |
| member of |kH| exists for some k is an unresolved projective-geometry      |
| question that this file does not settle.                                   |
+---------------------------------------------------------------------------+
```

The honest statement is therefore: `R2` is **not** closed, and it is **not**
witnessed either.  It is the one residual of the three whose status is
genuinely undetermined rather than settled negatively.  That is worth saying
plainly, because `R1` and `R3` are both settled negatively below and in
`R1_TOTAL_DEGENERATION.md`.

Note also, from `DEPENDENCY_MAP.md`: even a full closure of `R2` removes only
the `delta(x) = 2` branch of the nine point cells, and the point cells die only
in conjunction with `R1`.

---

## 5. Adversarial tests

### R2-T1.  The mandatory `D_12` test (Cor IX.6) — PASSED

Theorem R2-2 is a kill, so it must be checked against the realised
`D_12`-equivariant map.  `D_12` contains `S_3` and `C_6` but not `D_10`,
`C_11` or `F_55` (`10, 11, 55` do not divide `12`), so the cells visible at
`D_12` level are `P4`, `P5`.  Theorem R2-2 does not empty them: it removes one
*construction* of the required cover (cyclic, positively branched), leaving
the non-cyclic and singular cases, and it says nothing about the
`delta(x) = 3` branch, which `TOTAL_DEGENERATION.md` Thm W1 witnesses at every
cell including `P4`, `P5`.  Since `dim T^{D_12} = 2 > 0`, the channel the
realised map needs stays open.  **PASS.**

Proposition R2-4 is invisible at `D_12` level (it is a statement about `F_55`,
of order 55, coprime to 12).  **No interaction.**

### R2-T2.  Does Theorem R2-2 contradict "branched covers have unbounded irregularity"? — NO

The standard examples (cyclic covers of `P^2` branched along a curve of high
degree) have `q > 0` only when the vanishing fails, i.e. when `-iL` is not in
the Kodaira range — for `P^2` and `L = O(e)` one has
`h^1(-iL) = h^1(K + iL) = h^1(O(ie-3)) = 0`, so those covers are in fact
regular too.  Irregular cyclic covers of a regular surface require a branch
divisor that is **not** a multiple of a nef and big class (or a non-reduced /
singular branch locus).  Theorem R2-2 is consistent with the literature and
sharpens the box's own remark.

### R2-T3.  Is Prop R2-4 an overreach about `H^0(O(1))`? — NO

`h^0(-K_{V14}) = 10 = dim M` and `V14 subset P(M) = P^9` is the anticanonical
embedding are both sealed (`SEAL_V14_BETTI.md`, exit `V14-BETTI-SEALED`,
regression `h^0(-K) = 10`), so the restriction `M^* -> H^0(V14,O(1))` is an
isomorphism and the argument is about `Res_{F_55}M^*` alone.

### R2-T4.  Does `R2` interact with the `j = 8192/11` exclusion? — NO

`E_sigma` never appears here: the carrier is `H^1` of a cover of a surface,
not of the `sigma`-fixed sextic, and `SUPPORT_CENSUS.md` §4.1's caveat (covers
and Pryms over `E_sigma` are **not** excluded) is respected.  Nothing in this
file replaces the actual carrier by `E_sigma`.

---

## 6. Exit

```text
R2-NARROWED-NOT-CLOSED
R2-CYCLIC-COVERS-DEAD        (Thm R2-2, new: q(Y) = 0 for cyclic covers with nef-and-big branch class)
R2-FIBRATION-REFORMULATION   (Prop R2-1)
R2-F55-NO-HYPERPLANE-SECTION (Prop R2-4, new: Z_x in |kH| with k >= 2 at the 12 F_55-points)
R2_COVERS_OK                 (verifier marker)
```

`R2-CLOSED` is **not** claimed and no witness is claimed either.  The residual
is Corollary R2-3: a singular image divisor, a non-cyclic cover, or a branch
class outside the restriction of `Pic(V14)`.
