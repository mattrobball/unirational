# V14MAP_DEGREE345_REPLAY — no covariant realization of `Phi` in degree ≤ 5

Exit: **`V14MAP-DEGREE-3-4-5-REPLAYED`**, which **supersedes the marker
`V14MAP-DEGREE-3-4-5-IMPORT-UNREPLAYED`** of
`goal_runs_20260810/V14_MAP_DICHOTOMY` (see §10).

Machine layer: `verifier.py`, pure `python3` (Macaulay2 used only for one
cross-check), primes **397, 199, 661**, 95 CHECK lines, ALLGREEN
(`results/checks.log`).

No headline claim. Problem E stays **OPEN**. Nothing here touches Theorem A or
Theorem B of the parent packet; this is the degree-by-degree *non-constructive­ness*
statement that the parent packet left as a work order.

---

## 1. What was open

The parent packet sealed the dichotomy (`V14MAP-DICHOTOMY-SEALED`) and replayed
the external session's degrees 1–2 at two primes, correcting the session's
`Sym^2(10')` decomposition and adding the second 5-dimensional target slot. It
recorded the session's degree-3/4/5 exclusion as **unreplayed**: it was run at
the single prime `p = 397` and covered only **one** of the two 5-dimensional
slots. This packet discharges that work order.

## 2. Setup

`G = PSL(2,11)`; `U` the 6-dimensional even Weil representation of `SL(2,11)`;
`M` the `10'` summand of `Lambda^2 U`; `A = Ann(M)` inside `Lambda^4 U`, a
5-dimensional irreducible; `X = {Pf = 0}` in `P(A)` the Klein cubic threefold
(sealed identification, `FIX_IX_SEAL` item 5); `V14 = Gr(2,U) cap P(M)`, a
prime Fano threefold of genus 8 and degree 14 in `P(M) = P^9`. The two
5-dimensional irreducibles of `G` are complex conjugates: `A` and `A^dual`.
Each slot carries exactly one invariant cubic up to scale (trivial multiplicity
1 in `Sym^3` of each, verified); on `A` it is a nonzero multiple of `Pf6`, so on
`A^dual` it is the conjugate Klein cubic — which is the `alpha`-twisted target
for the outer automorphism `alpha` of `G`, so covering both slots covers the
twisted question as well. Model conventions are those of
`FIX_IX_SEAL/scripts/seal.py`, re-used verbatim from the parent verifier.

**Definition.** A *degree-`d` covariant into the slot `S`* is a `G`-equivariant
polynomial map `F: M -> S`, homogeneous of degree `d`; equivalently an element
of `C_d(S) = Hom_G(Sym^d(M*), S) = (Sym^d(M*) (x) S)^G`. It *realizes a map into
the cubic* if `F|_V14` is not identically zero and the invariant cubic of `P(S)`
vanishes on the image of `V14`.

## 3. Three completeness lemmas

These are what make a finite computation into a statement about *all* maps of
that degree.

**L1 (lifting).** Every `G`-equivariant 5-tuple of degree-`d` forms *on* `V14`
extends to an ambient covariant. Indeed `Sym^d(M*) ->> R_d = H^0(V14, O(d))` is
`G`-equivariant and surjective (`V14` is projectively normal, being a linear
section of the arithmetically Cohen–Macaulay `Gr(2,U)`), and `|G| = 660` is
invertible, so `(Sym^d(M*) (x) S)^G ->> (R_d (x) S)^G` is surjective. Nothing is
missed by working in the ambient `P^9`.

**L2 (identically vanishing covariants).** If `F|_V14 = 0` then `F` defines no
rational map on `V14` at all. The only escape would be `F = h · F'` with `h` a
scalar-valued factor vanishing on `V14`; since `G` is perfect it has no
nontrivial characters, so the content `h` is `G`-invariant and `F'` is a
covariant of strictly smaller degree, which is covered at its own degree. Since
degrees 1–5 are all covered, the union statement is safe.

**L3 (degree is the only parameter).** `Pic(V14) = Z·H` with `H = -K` for a
smooth prime Fano threefold of genus 8 (classical, Iskovskikh; smoothness of the
model's `V14` is sealed — `goal_runs_after_c53d89a/FIX_IX_SEAL/REPORT.md`, the
Jacobian-emptiness item: "`V14` is smooth, pure dim 3, degree 14"), so any
rational map `V14 --> P(S)` is given by a linear system
inside `|dH|` for a unique `d ≥ 1` after removing the fixed part. Degrees are
therefore an honest exhaustive parameter; only the *bound* `d ≤ 5` is a
limitation. (This lemma is used only for the corollary in §8; the main theorem
does not need it.)

## 4. Exact multiplicities, and why the two slots can never be separated

`chi_M` is rational (`10'` takes the values `10, 2, 1, 0, -1, -1` on the
projective-order classes `1, 2, 3, 5, 6, 11`), hence so is `chi_{Sym^d M}` for
every `d`; and `chi_{A^dual} = conj(chi_A)`. Therefore

>   `dim Hom_G(Sym^d(M*), A) = dim Hom_G(Sym^d(M*), A^dual)` for every `d`.

**No symmetric power of `M` can tell the two 5-slots apart.** (They *are*
separated on `V14`, see §6 — which is exactly why the single-slot import was
insufficient.) Computed exactly from the ATLAS character table of `L2(11)` with
rational arithmetic:

| `d` | 0 | 1 | 2 | 3 | 4 | 5 |
|---|---|---|---|---|---|---|
| `dim Sym^d(M)` | 1 | 10 | 55 | 220 | 715 | 2002 |
| `dim C_d(A) = dim C_d(A^dual)` | 0 | **0** | **1** | **2** | **7** | **18** |
| invariants `dim (Sym^d M*)^G` | 1 | 0 | 1 | 2 | 4 | 8 |

`d = 1` reproduces `Hom_G(M,A) = 0` and `d = 2` reproduces the parent packet's
corrected count (one covariant into each slot).

Explicit bases of `C_d(A)` and `C_d(A^dual)` are built by group averaging: seeds
`y^e (x) f_k` are chosen `<T>`-invariant (`T` = the order-11 generator, which
acts on `M` with the ten distinct nontrivial characters and on each slot with
five of them), so that the average over `G` equals the average over the 60
cosets of `<T>`; every basis element is then checked to be equivariant for both
generators, and the number of independent averages is checked to equal the exact
multiplicity above. That is the completeness of the basis.

## 5. The kernel is exactly the Plücker ideal — no sampling assumption

Write `K_d(S) = {F in C_d(S) : F|_V14 = 0}` and `n'_d(S) = dim C_d(S) - dim K_d(S)`
(the number of independent degree-`d` equivariant 5-tuples *on* `V14`). The
computation pins `K_d` from two sides:

* **from above**: evaluation at the sampled `V14` points has rank `n'`, so
  `{F : F(sample) = 0}` has dimension `dim C_d - n'`, and it contains `K_d`;
* **from below**: exactly `dim C_d - n'` **independent covariants are constructed
  whose seeds are (restricted Plücker quadric) × (monomial)**. The ideal
  generated by the 15 restricted Plücker quadrics is `G`-stable, so the group
  average of such a seed still lies in it, and therefore vanishes identically on
  `V14` — by construction, not by sampling.

The two dimensions agree in every case, so `{F : F(sample) = 0} = K_d` exactly.
**No Zariski-density assumption about the sample is used anywhere.**

Independent cross-check of `n'` by the equivariant Koszul complex: `A` is a
5-dimensional space of linear forms on `Lambda^2 U`, `dim Gr(2,U) - 5 = 8 - 5 = 3
= dim V14`, so those forms are a regular sequence on the Cohen–Macaulay ring
`R(Gr(2,U)) = (+)_d S_{(d,d)}(U*)` and

>   `chi_{R_d(V14)} = sum_{i=0..5} (-1)^i chi_{Lambda^i A} · chi_{S_{(d-i,d-i)}(U*)}`,
>   `s_{(k,k)} = h_k^2 - h_{k+1} h_{k-1}`.

At the identity this returns `1, 10, 40, 105, 219, 396` — the classical
anticanonical `h^0(-dK) = (7/6)d(d+1)(2d+1) + 2d+1` of a genus-8 prime Fano
threefold — and Macaulay2 independently confirms that the ideal of the 15
restricted quadrics has `codim 6`, `dim 4`, `degree 14`, 15 minimal generators
and Hilbert function `1, 10, 40, 105, 219, 396, 650`. The predicted `n'` matches
the observed evaluation rank at every degree, slot and prime.

## 6. The landing certificate, and the result

Modulo `K_d` a covariant is determined by `n'` coordinates `c`, and for every
`y in V14` the value `F_c(y)` depends only on `c`. The landing conditions
`Pf_S(F_c(y)) = 0`, one for each sampled `y`, are **cubic forms in `c`**. In
every case with `n' ≥ 2` these cubic forms **span the full space of cubic forms
in `n'` variables**; that ideal contains `c_1^3, ..., c_{n'}^3`, so its only zero
— over the algebraic closure, not merely over `F_p` — is `c = 0`. For `n' = 1`
the single restriction is unique up to scale and the invariant cubic is nonzero
at every sampled image point. For `n' = 0` every covariant of that degree
vanishes identically on `V14` and defines no map at all.

Results, identical at `p = 397, 199, 661`:

| `d` | slot | `dim C_d` | `n'` | `dim K_d` | why no map into the cubic |
|---|---|---|---|---|---|
| 1 | `A` / `A^dual` | 0 | – | – | no covariant exists |
| 2 | `A` | 1 | 0 | 1 | all vanish identically on `V14`: no map at all |
| 2 | `A^dual` | 1 | 1 | 0 | image misses the conjugate cubic (80/80 points) |
| 3 | `A` | 2 | **1** | 1 | image misses `X` (80/80 points) |
| 3 | `A^dual` | 2 | **0** | 2 | all vanish identically on `V14`: no map at all |
| 4 | `A` | 7 | 2 | 5 | 4 of 4 binary cubics spanned ⇒ only `c = 0` |
| 4 | `A^dual` | 7 | 2 | 5 | 4 of 4 binary cubics spanned ⇒ only `c = 0` |
| 5 | `A` | 18 | 3 | 15 | 10 of 10 ternary cubics spanned ⇒ only `c = 0` |
| 5 | `A^dual` | 18 | 3 | 15 | 10 of 10 ternary cubics spanned ⇒ only `c = 0` |

Degrees 1–2 are the parent packet's sealed results, reproduced here inside the
new machinery as a control (including the asymmetry between the two slots).

> **Theorem.** For `d = 1, 2, 3, 4, 5` and for both 5-dimensional target slots,
> every `G`-equivariant covariant `F: M -> S` of degree `d` either vanishes
> identically on `V14` — and then defines no rational map on `V14` at all — or
> its restriction to `V14` has image not contained in the invariant cubic of
> `P(S)`. Hence **no `G`-equivariant rational map `V14 --> X` (nor into the
> `alpha`-twisted target) is defined by forms of degree ≤ 5**.

Note the positive content the computation also produces: there *are* nonzero
equivariant maps `V14 --> P(A)` of degree 3 (unique up to scale), a
2-parameter family at degree 4 and a 3-parameter family at degree 5, and
likewise into `P(A^dual)` from degree 2 on. They exist; they simply never land
on the cubic. The obstruction is the cubic, not equivariance.

## 7. Characteristic zero

The multiplicities of §4 are exact rational character arithmetic and carry no
prime dependence. The rest is mod `p` at three primes `p ≡ 1 mod 11`, all
coprime to `|G| = 660`, and transfers by the standard good-reduction /
specialisation argument, stated honestly:

1. Over `O = Z[zeta_11, 1/660]` the model is defined (`gauss^2 = -11` and `11`
   invertible), and since `|G|` is invertible the averaging idempotents are
   integral, so `C_d(S)_O` is a direct summand of a free module, of rank equal
   to the character multiplicity, and its formation commutes with base change.
   The mod-`p` dimension observed equals that multiplicity at all three primes.
2. `R_O = O[y]/I` is `O`-flat: the Hilbert function is the same in
   characteristic 0 (Koszul, §5) and mod `p` (Macaulay2, §5), and equal fibre
   dimensions over a Dedekind base give flatness. Hence `I (x) k = I(V14_k)`,
   the 15 quadrics still generate mod `p` (Macaulay2: `mingens 15`), and the
   reduction of any form vanishing on `V14_C` vanishes on `V14_{F_p}`.
3. So a characteristic-0 counterexample `F` — defined over a number field, scaled
   primitive, reduced at a prime above `p` — would give a nonzero mod-`p`
   covariant whose composite with the invariant cubic vanishes at every sampled
   `F_p`-point of `V14`. The certificate of §6 says there is none. Contrapositive:
   there is no characteristic-0 counterexample either.

This is evidence-grade in the usual sense only through step 2 (which is machine
verified at each prime), and unconditional given it.

## 8. Corollary — any explicit `Phi` needs degree ≥ 6

The parent packet's Theorem B (`V14MAP-V14-TO-KLEIN-EXISTS`) is a
non-constructive existence proof: generic torsor, degree ≤ 2 splitting of a
2-torsion Brauer class, Nishimura, cubic-secant descent, Duncan–Reichstein
adjunction. Combining it with the theorem above and L3:

> If the sealed `Phi: V14 --> X` is realized by a linear system on `V14`, that
> system lies in `|dH|` with `d ≥ 6`.

That is the honest state of the constructive question: existence is sealed, and
the smallest possible explicit realization has now been pushed past degree 5 on
**both** targets, not one.

## 9. Not claimed

Dominance of `Phi`; any explicit `Phi` at any degree; any bound above degree 5;
any headline or `ed` value; anything about the `Klein --> V14` direction (that is
Theorem A of the parent packet, untouched). The external session's "generically
dominant via Palatini flop" sketch remains an UNVERIFIED lead, exactly as the
parent packet recorded it.

## 10. Supersession record

`goal_runs_20260810/V14_MAP_DICHOTOMY/REPORT.md` §"Session import, unreplayed
part" states: *"degrees 3–5 remain `V14MAP-DEGREE-3-4-5-IMPORT-UNREPLAYED` —
work order: replay at a second prime with char-0 transfer, covering both 5-dim
targets."* That work order is discharged here:

* three primes (397, 199, 661) instead of one;
* both slots at every degree, and the slot asymmetry at `d = 2, 3` shows the
  single-slot import genuinely could not have settled the question;
* exact character multiplicities rather than mod-`p` ranks;
* the vanishing step upgraded from sampling to explicit Plücker-ideal membership;
* the landing step upgraded from "no `F_p`-solution" to "the landing conditions
  generate all cubic forms", which is an emptiness statement over the algebraic
  closure;
* the char-0 transfer stated with its flatness input machine-verified.

The marker `V14MAP-DEGREE-3-4-5-IMPORT-UNREPLAYED` is therefore **superseded by
`V14MAP-DEGREE-3-4-5-REPLAYED`**. The manifest entry for
`goal_runs_20260810/V14_MAP_DICHOTOMY` should record the supersession in its
notes; this packet does not edit it (see `REGISTRATION_SNIPPET.md`).

## 11. Replay

```
python3 verifier.py            # primes 397 199      (~25 s)
python3 verifier.py 397 199 661   # as recorded      (~38 s)
```

Writes `results/checks.log` (95 CHECK lines, `V14MAP-DEGREE345-VERIFIER:
ALLGREEN`) plus the Macaulay2 input/output per prime. Macaulay2 is used for one
cross-check only; if it is absent that single line reports SKIPPED and the
exclusion is unaffected.
