# The two one-dimensional cells at `d = 35` are dead

Exits: `D35-K31-CELL-DEAD`, `D35-K30-CELL-DEAD`,
`RESTRICTED-COORDINATE-DEGREE-FOUR-AND-FIVE-EXCLUDED-ALL-DEGREES`,
`NONIDENTITY-RESTRICTED-COORDINATE-DEGREE-AT-LEAST-SIX`,
`DEGREE-FIVE-COVARIANT-EXPLICIT`,
`RESTRICTED-DEGREE-EXCLUSIONS-UNCONDITIONAL-ON-DOMINANCE`.

Supersedes `NONIDENTITY-RESTRICTED-COORDINATE-DEGREE-AT-LEAST-FOUR`
(`EXCLUSION_DPRIME_2_3.md`) and closes
`D35-ONE-DIMENSIONAL-RAMIFICATION-CELLS-IDENTIFIED` from
`D35_BRANCH_TABLE.md` §3, which recorded these two cells as "the concrete next
computation. **Not done in this packet.**"

Verified exactly: `verify_d35_cells.py` (`RESULT: PASS`, 89 checks, ~17 s,
exact over `Q` and over `Q(zeta_11)` carried as length-10 `Fraction` vectors;
no floating point).

---

## 0. One-paragraph summary

Both cells die, and they die one step **earlier** in the chain than the test
this packet was sent to run. `D35_BRANCH_TABLE.md` §3 proposed to decide them by
computing the ramification divisor of the restricted selfmap. There is no
restricted selfmap to compute it for. In each cell the space of candidate
`G`-equivariant restricted tuples is exactly **one-dimensional** — a single
point of projective space, not a family — and that one candidate does not map
`X` into `X`: the nonlinear condition `F(B) = 0` on `X`, which is forced by
`F(T) = 0` (`THEOREM_SOURCE_TANGENCY.md` §4), fails for it. Nothing about
dominance, ramification, base loci or `delta` is needed or even definable. And
because no step of the argument mentions the ambient degree, the exclusion is
**degree-uniform**: `d' = 4` and `d' = 5` are impossible in every ambient
degree `d`, unconditionally — with no dominance hypothesis and hence without
the accepted input `ed_C(PSL_2(F_11)) >= 3` that every previous restricted-degree
exclusion consumed.

## 1. Statement

`G = PSL(2,11)`, `W = C^5` the 5-dimensional irreducible representation used
throughout, `X = V(F) ⊂ P(W)` the Klein cubic threefold,
`F = x_0^2x_1 + x_1^2x_2 + x_2^2x_3 + x_3^2x_4 + x_4^2x_0`. Let `T` be a
primitive `G`-equivariant landing tuple of degree `d` with `F(T) = 0`, let
`T|_X = H·B` with `H` the invariant of degree `k` cutting the divisorial base
locus, `d' = d - k`, and `phi = [B] : X --> X` the primitive restricted selfmap
(`THEOREM_SOURCE_TANGENCY.md` §4).

> **Theorem 1.1.** `d' = 4` and `d' = 5` are impossible, in **every** ambient
> degree `d`. Equivalently the common-factor cells `k = d-4` and `k = d-5` are
> excluded in every ambient degree. In particular the two cells
> `(k, d') = (31, 4)` and `(30, 5)` at `d = 35` are **DEAD**.
>
> The proof uses neither the source-tangency identity (34) nor the dominance of
> `phi`, hence not `ed_C(G) >= 3`.

Combining with the sealed invariant-degree lemma (`k in {0} ∪ {5,6,...}`) and
`EXCLUSION_DPRIME_2_3.md`, the surviving restricted-degree set in ambient
degree `d` is exactly

```
        d' = 1        (retraction, k = d-1)
   or   d' in {6,7,...,d-5}
   or   d' = d        (k = 0, necessarily CARRIER).                    (39')
```

This replaces `(39)` of `EXCLUSION_DPRIME_2_3.md`, whose middle range was
`{4,5,...,d-5}`.

## 2. The candidate space in each cell is a single projective point

This is the step that makes the cells finite, and it is sharper than the
branch table's phrasing.

`B` is a tuple of five degree-`d'` forms **on `X`**, i.e. modulo `F`, and it is
`G`-equivariant (the character `G -> C^*` implicit in the equivariance of `T`
and the semi-invariance of `H` is trivial because `G` is perfect). So

```
B in ((S/F)_{d'} ⊗ W)^G,        S = C[x_0,...,x_4].                    (C1)
```

Multiplication by `F` is an injective `G`-map `S_{d'-3} ⊗ W -> S_{d'} ⊗ W`, and
taking `G`-invariants is exact in characteristic zero, so with
`C(m) := dim (Sym^m W^v ⊗ W)^G = dim Cov_m`,

```
dim ((S/F)_{d'} ⊗ W)^G = C(d') - C(d'-3),                              (C2)
```

and the restriction `Cov_{d'} -> ((S/F)_{d'} ⊗ W)^G` is **surjective**: every
equivariant tuple on `X` lifts to an ambient covariant. The sealed dimension
table `C(1..8) = 1,0,0,2,1,2,4,5` (`FOLIATION_REFORMULATION.md` §2,
triple-confirmed, and re-derived from scratch in §B of the verifier) gives

| `d'` | `C(d')` | `C(d'-3)` | `dim ((S/F)_{d'} ⊗ W)^G` | spanned by |
|---:|---:|---:|---:|---|
| 1 | 1 | — | 1 | `x` (the identity tuple) |
| 2 | 0 | — | **0** | — |
| 3 | 0 | 0 | **0** | — |
| **4** | 2 | 1 | **1** | `D_4 mod F` |
| **5** | 1 | 0 | **1** | `D_5 mod F` |
| 6 | 2 | 0 | 2 | — |
| 7 | 4 | 2 | 2 | — |
| 8 | 5 | 1 | 4 | — |

So the branch table's "pencil, 2-dimensional family" at `d' = 4` is a pencil
**upstairs only**. `Cov_4 = span{F·x, D_4}` (verified: both lie in it and
`dim Cov_4 = 2`), and the member `F·x` restricts to `0` on `X` — it is not a
map at all. **The degeneration locus of the pencil is exactly that one member**,
and every other member restricts to a nonzero scalar multiple of `D_4|_X`. The
verifier establishes this by solving, parametrically in `(lambda : mu)`, for
the members of `lambda F·x + mu D_4` that vanish modulo `F`; the answer is
`mu = 0` and nothing else.

At `d' = 5` there is no pencil at all: `Cov_5` is one-dimensional and
`ker(restriction) = F·Cov_2 = 0` because `C(2) = 0`.

### The two named candidates

`D_4` is the degree-`4` divergence-free covariant already in the repository
(`FOLIATION_REFORMULATION.md` §3, `verify_low_degree_covariants.py`, audited in
`verify_d4_covariant.py`), primitive and defined over `Q`, seven terms per
component.

`D_5` is **new**, and is boxed here. It is the generator of the one-dimensional
`Cov_5`, hence automatically divergence-free (the sealed table has
`dim divfree(Cov_5) = 1 = C(5)`), primitive, and defined over `Q`:

```
D_5[0] =  x_1^5 + 5x_2^2x_4^3 + 5x_1x_3^3x_4 - 5x_1^3x_2x_3 - 10x_0x_1x_3x_4^2
          + 5x_0x_1x_2^2x_4 + 5x_0^2x_2x_3^2 + 5x_0^2x_1^2x_3 - 5x_0^3x_2x_4
D_5[1] =  x_2^5 - 5x_2^3x_3x_4 + 5x_1^2x_3x_4^2 + 5x_1^2x_2^2x_4 + 5x_0x_2x_4^3
          + 5x_0x_1x_2x_3^2 - 5x_0x_1^3x_3 - 10x_0^2x_1x_2x_4 + 5x_0^3x_3^2
D_5[2] =  x_3^5 + 5x_1x_2x_3x_4^2 - 5x_1x_2^3x_4 + 5x_1^3x_4^2 - 5x_0x_3^3x_4
          + 5x_0x_2^2x_3^2 - 10x_0x_1^2x_2x_3 + 5x_0^2x_2^2x_4 + 5x_0^3x_1x_3
D_5[3] =  x_4^5 + 5x_1x_3^2x_4^2 - 10x_1x_2^2x_3x_4 + 5x_1^3x_2x_4 - 5x_0x_2x_3^3
          - 5x_0x_1x_4^3 + 5x_0x_1^2x_3^2 + 5x_0^2x_2x_3x_4 + 5x_0^2x_2^3
D_5[4] =  x_0^5 - 5x_1x_3x_4^3 + 5x_1x_2^2x_4^2 + 5x_1^2x_3^3 - 10x_0x_2x_3^2x_4
          + 5x_0x_2^3x_3 + 5x_0x_1^2x_3x_4 + 5x_0^2x_2x_4^2 - 5x_0^3x_1x_2
```

with `D_5[i]` the `i`-th component and `sigma`-covariance `D_5[i](x_{j+1}) =
D_5[i+1](x)` visible on the nose. Nine terms per component; every coefficient
other than the leading one is divisible by `5`, so `D_5 ≡ (x_1^5, x_2^5, x_3^5,
x_4^5, x_0^5) (mod 5)` — the Frobenius-times-`sigma` tuple in characteristic
`5`. That congruence is a remark, not an input.

Because `D_5` is a new named object entering the repository, §C of the verifier
audits it on a **second, code-disjoint arithmetic path**, exactly as
`verify_d4_covariant.py` does for `D_4`: `sigma`-covariance by direct
substitution, `tau`-covariance as a weight condition mod `11`, and
`iota`-covariance with `iota` rebuilt from the repository's own Gauss-sum
formula inside `Q[z]/(z^11-1)` rather than imported. Since `<sigma,tau,iota>`
has order `660` (re-enumerated), those three conditions are exactly
`G`-covariance.

## 3. The kill

> **Lemma 3.1 (sealed, `THEOREM_SOURCE_TANGENCY.md` §4).** `F(B) = 0` on `X`.
>
> *Proof (the packet's, restated).* `0 = F(T)|_X = H^3 F(B)` and `H|_X != 0`. ∎

So a candidate `B` must satisfy `F(B) in (F)`. This is a single, finite,
scale-invariant test — `F(cB) = c^3 F(B)`, so it is a condition on the point of
projective space, and each cell has exactly one point to test.

> **Proposition 3.2.** `F(D_4) not in (F)` and `F(D_5) not in (F)`.

Two independent verifications, either of which suffices.

**(a) Ideal membership.** `{F}` is a Gröbner basis of the principal ideal `(F)`,
so the multivariate division algorithm's remainder is a genuine normal form and
`nf(P) = 0 <=> P in (F)`. Computed exactly over `Q` in `grevlex`:

```
nf(F(D_4))   is nonzero:  92 terms, degree 12 = 3·4
nf(F(D_5))   is nonzero: 185 terms, degree 15 = 3·5
```

(`sympy.div` on multivariate input is **not** a full reduction and gives a
larger, non-canonical remainder — 159 terms for `F(D_4)`. It was used and
discarded during this work; only `sympy.reduced` appears in the verifier. The
verdict is the same either way, since a nonzero true normal form is what
decides, but the distinction is recorded because a nonzero `div` remainder
alone would **not** have been a proof.)

**(b) A point certificate, needing no ideal theory.** `p = (1,1,1,-2,0)` lies on
`X` (`F(p) = 1 + 1 - 2 = 0`). If `F(B)` were in `(F)` then `F(B(p)) = 0`. But,
in exact integers,

```
D_4(p) = (56, -28,  6, 34,  34),  F(D_4(p)) =    22160  != 0
D_5(p) = (21,  51, -2, 65, -54),  F(D_5(p)) =  -149365  != 0
```

Five further points of `X` are tabulated in the verifier; four of them are
witnesses for both tuples. (The sixth, `p = (1,0,0,0,0)`, gives `0` for both —
a reminder that a single point can only ever certify the **positive**
direction.)

Therefore, in each cell, the unique candidate up to scalar does not map `X` into
`X`, and no candidate exists.

> **Corollary 3.3.** There is no `G`-equivariant rational selfmap of `X` of
> primitive coordinate degree `4` or `5`, dominant or not. Hence no landing
> tuple in any degree has `d' in {4,5}`. ∎

The clause "dominant or not" is the point: the previous restricted-degree
exclusions ran through `j_phi != 0`, which needs `phi` dominant, which needs
`FULL_G_RESTRICTION_DOMINANCE` and therefore `ed_C(G) >= 3`. This one does not.

### 3.4 The controls (why the test is not vacuously always-failing)

`nf(F(B)) = 0` is a real discriminator, not a condition nothing satisfies:

* `B = x`, the identity tuple (`d' = 1`, the retraction branch): `F(x) = F`, so
  `nf = 0`. **PASSES**, as it must.
* `B = sigma(x) = (x_1,x_2,x_3,x_4,x_0)`, a group element: `nf = 0`. **PASSES**.
* `B = (x_0^4,...,x_4^4)`, not equivariant: `nf != 0`. Fails.

## 4. Verdicts

> **Cell `k = 31`, `d' = 4`: DEAD.** Killing condition: the candidate space
> `((S/F)_4 ⊗ W)^G` is one-dimensional, spanned by `D_4 mod F`, and
> `F(D_4) not in (F)`. The Cov_4 pencil's only other behaviour is its
> degeneration locus `F·x`, which restricts to the zero tuple. Certificate:
> `p = (1,1,1,-2,0) in X`, `F(D_4(p)) = 22160`.
>
> **Cell `k = 30`, `d' = 5`: DEAD.** Killing condition: the candidate space
> `((S/F)_5 ⊗ W)^G` is one-dimensional, spanned by `D_5 mod F`, and
> `F(D_5) not in (F)`. There is no pencil: `ker(Cov_5 -> Cov_5 mod F) = 0`
> because `C(2) = 0`. Certificate: `p = (1,1,1,-2,0) in X`,
> `F(D_5(p)) = -149365`.

Neither cell has a residual. There is no surviving candidate to box.

## 5. The tests that were not reached, and why

The mission's downstream tests are not "not computed"; their inputs do not
exist. Recorded explicitly so that nothing here reads as an evasion:

| test | status | reason |
|---|---|---|
| dominance of `[B\|_X] : X --> X` (generic Jacobian rank 3) | **not defined** | there is no `B` with `F(B) = 0` on `X`, so there is no restricted selfmap whose Jacobian to take |
| `j_phi` exactly; spans `H^0(X,O(6))^G` resp. `H^0(X,O(8))^G` | **not defined** | `j_phi = Jac(beta)` presupposes `beta`, the cone lift of `phi` |
| forced consistency check of the sealed identity (34) | **vacuous** | (34) is conditional on a dominant restricted selfmap; there is none in these cells. **No anomaly:** nothing sealed is contradicted, and none of §§2–3 uses (34) |
| restricted base locus of `B` on `X` (dim, degree) | **not defined** | same |
| topological degree `delta` (`<= d'^3` = 64 at `d' = 4`) | **not defined** | `delta = deg phi` |
| CLEAN norm test `delta = x^2+xy+3y^2` | **not reached** | needs `delta` |

No computation was launched and abandoned; no blowup point to record.

## 6. What this changes in the `d = 35` table

| `k` | `d'` | previous status | now |
|---:|---:|---|---|
| 30 | 5 | open — one-dimensional, actionable | **EXCLUDED** (this packet) |
| 31 | 4 | open — one-dimensional, actionable | **EXCLUDED** (this packet) |

Open cells at `d = 35` go from **29** to **27**: `k = 0` (CARRIER), `k = 5..29`,
`k = 34` (retraction). The exclusion is degree-uniform, so it removes two cells
from every ambient degree, not just from `d = 35`.

Note which cells are gone and which survive. The excluded band is the
*small-`d'`* end — the end where the restricted selfmap is nearly the identity.
The sealed sieve's surviving cell `(k, d', zeta, a, delta) = (0, d, 1, d^3-d-3,
3)` has `k = 0`, `d' = d`, and is **untouched**, exactly as
`EXCLUSION_DPRIME_2_3.md` §3(a) warns. This packet does not revive the
arithmetic sieve and does not close any branch.

## 7. Robustness: the outer-twisted equivariance convention

`PSL(2,11)` has two 5-dimensional irreducible representations, `W` and `W'`,
interchanged by its outer automorphism and by complex conjugation
(`W' = gamma ∘ W` for the field automorphism `gamma : zeta_11 -> zeta_11^2`,
`2` a non-residue mod `11`, so `gamma` negates `sqrt(-11)`). `F` is invariant
under `W'` too (verified). So one could ask about tuples intertwining the two
actions, `T(rho(g)x) = rho'(g)T(x)` — a convention the packets do not use but do
not explicitly exclude either. §G of the verifier settles it:

```
dim Cov^theta_k  for k = 1..5 :  0, 1, 0, 1, 2
twisted candidate space at d' = 4 :  1 - 0 = 1   (generator Q_4, over Q)
twisted candidate space at d' = 5 :  2 - 1 = 1   (generator P_0, over Q)
```

Both twisted cells are again a single projective point, and both fail the same
test: `nf(F(Q_4)) != 0` and `nf(F(P_0)) != 0`, with point certificates
`F(Q_4(p)) = -5625` and `F(P_0(p)) = -10105` at the same `p = (1,1,1,-2,0)`.
The twisted `d' = 5` pencil is handled parametrically: `nf(F(lambda P_0 + mu
P_1)) = (lambda + mu)^3 · nf(F(P_0))` exactly, so the only member that passes is
the degenerate one `lambda = -mu`, which is `F` times the twisted quadratic
covariant `Q_2 = -(x_i^2 + 2x_{i+1}x_{i+2})_i` and restricts to `0` on `X`.

**Conclusion:** the verdict does not depend on the equivariance convention.

## 8. A by-product: `d' = 2, 3` become unconditional

The same bookkeeping re-proves `EXCLUSION_DPRIME_2_3.md` by a different and
strictly weaker-hypothesis route. By (C2),

```
d' = 2 :  C(2) - C(-1) = 0 - 0 = 0
d' = 3 :  C(3) - C(0)  = 0 - 0 = 0        (C(0) = dim W^G = 0)
```

so there is no `G`-equivariant tuple of quadrics or cubics on `X` **at all**.
The sealed proof instead argued that `j_phi` would have to be a nonzero element
of `H^0(X,O_X(2))^G = 0` resp. `H^0(X,O_X(4))^G = 0` — which needs `phi`
dominant, which needs `ed_C(G) >= 3`. The covariant-space route needs neither.

Sealing note: `EXCLUSION_DPRIME_2_3.md` §4 records the `d' in {2,3}` exclusion
as "conditional on exactly the accepted inputs the rest of the repository's
dominance chain already carries". That conditionality can now be dropped. The
theorem is unchanged; its hypothesis list shrinks.

## 9. Non-claims

* **No branch closes and the headline does not move.** Twenty-seven cells remain
  open at `d = 35`, including `k = 0` (CARRIER) and the whole band
  `d' = 6..30`. `Problem E headline: OPEN.`
* The exclusion says nothing about `delta`, the topological degree, and in
  particular nothing about the sealed sieve's `delta = 3` survivor, which lives
  at `k = 0`, `d' = d`.
* The one-dimensionality in §2 is a statement about the **candidate tuple**
  `B` at small `d'`. It is unrelated to the one-dimensionality of `j_phi`'s
  target space that the branch table §3 used to call these cells actionable;
  the two happen to coincide in these cells and would not in general.
* At `d' >= 6` the candidate space has dimension `>= 2` and the condition
  `F(B) in (F)` becomes a nontrivial variety condition on it rather than a
  single check. Nothing here suggests that computation is easy, and nothing
  here was tried at `d' >= 6`.
* `D_5` is written down and audited; whether the foliation it defines is
  realised by anything is not addressed. Same non-claim as for `D_4` in
  `FOLIATION_REFORMULATION.md` §3.
* The argument consumes the equivariance and the specific `F` — which is exactly
  what `INTERPOLATION_THEOREM.md`'s scope boundary says any real exclusion must
  do, and is why it is not blocked by that theorem. It is nonetheless not an
  all-degree closure: it removes two values of `d'`, uniformly in `d`.

**Problem E headline: OPEN.**
