# The multiplicity route to the SPIN-LINKING LEMMA — verdict: REFUTED

Route 1 of `KLEIN_SPIN_COMPLEX.md` §7 ("multiplicity, Thm 7.4") is the last
named route past the boxed SPIN-LINKING LEMMA, route 2 having been closed by
`V14_S3_D10_MEASUREMENT.md` Thm V3. This file executes it and finds that the
linking it predicts **does not exist**, at any multiplicity and at any order,
and that the strongest resolution-free form of the same data (the
`V14^{D_10} = empty` route) is also destructible. The exits are in §8.

Everything numerical is machine-checked by `verify_spin_multiplicity.py`
(marker `SPIN_MULTIPLICITY_OK`), exactly, over `Q(i)` inside the integral
12-dimensional monomial model of `spin_network_lib`, with no sampling and no
search. Sealed inputs are cited, never recomputed.

## 0. The verdicts

```text
SPIN-MULTIPLICITY-REFUTED       the m >= 2 linking of Thm 7.4 does not exist,
                                at any m and at any order
SPIN-LINKING-LEMMA-FALSE        as boxed ("in every G-equivariant resolution")
D10-FIXED-POINT-ROUTE-DEAD      V14^{D_10} = empty exports no obstruction
SPIN-CHAIN-OBSTRUCTION-UNDECIDED  (unchanged; both named routes are now closed)
```

`SPIN-CHAIN-OBSTRUCTION-PROVED` is **NOT** claimed and is now known not to be
reachable by either named route.

## 1. Setting: what multiplicity does and does not change

`G = PSL(2,F_11)`, `Gtilde = SL(2,F_11)`, `U` the 6-dimensional spin
irreducible, `V = U^{(+)m} = U (x) C^m` with `G` acting through the first
factor only, `m >= 1`. `Y = V14`.

> **Lemma M0 (multiplicity is a tensor factor).** For every subgroup
> `Htilde <= Gtilde` and every linear character `mu` of `Htilde`,
> `V_mu = U_mu (x) C^m`. Hence for any two subspaces `S, S'` of `U` cut out by
> eigenvalue conditions,
> `(S (x) C^m) n (S' (x) C^m) = (S n S') (x) C^m`. Every isotypic
> multiplicity and every intersection dimension is multiplied by `m`; **no
> emptiness is changed**.

*Proof.* `V|_{Htilde} = U|_{Htilde} (x) C^m` with trivial action on `C^m`, and
isotypic projection commutes with `(x) C^m`. For the intersection: both sides
are the `C^m`-tensor of the corresponding subspace of `U`, because a subspace
of the form `S (x) C^m` is exactly the set of `u (x) e`-combinations with all
`u`-components in `S`. `QED`

**Consequence (the re-verification the brief asked for, done file by file).**

| statement | multiplicity-sensitive? | why |
|---|---|---|
| Prop 2.2 / Cor 2.3 (`P(V)^{V_4} = empty`) | no | `Q_8` has no spin linear character at all; independent of `V` |
| Thm 4.1 (carriers) | no | `Pi_sigma^eps = P(V_{eps i}(sigma)) = P^{3m-1}` is still irreducible, rational, pointwise `sigma`-fixed, `N_0`-stable |
| K1 (carriers on `V14`) | no | same |
| K2 (stabilisers exactly `C_6`) | no | pure target-side; uses only `V14^{D_12} = empty` (sealed) |
| K3 (rigidity) | no | K2 + Thm 5.1 |
| K4 (352 loci in `Ind(phi)`) | no | Thm 5.2; needs only that two planes of distinct involutions meet, which M0 preserves (dimension `m-1` instead of `0`) |
| K5 / Thm 7.3 (first-order separation) | **yes** | the only one; see §2 |
| K6 / Thm 6.1 (no scalar birth) | no | `dim V_{eps i} = 3m >= 2` |

So K1-K4 survive verbatim, as the brief stated; K5 is the only sensitive one,
and §2-§3 show it survives too, in the correct form.

## 2. Where the `m - 1` invariants actually sit

Thm 7.4 records `<chi_{T_x}, 1_K> = m - 1 >= 1` for `m >= 2`. That equality is
correct. Its reading — "the two traces on the exceptional divisor **do** meet,
so the first-order separation of K5 disappears" — is a statement about blowing
up the **point** `x`. It is an artifact of that choice of centre.

> **Theorem M1 (the invariants are tangential).** Let `sigma != tau` be
> involutions with `K = <sigma,tau>` in `{S_3, D_10}`, let `lambda` be a spin
> linear character of `Ktilde` occurring in `U`, and put
>
> ```text
> Z  =  P(V_lambda)  =  P(U_lambda (x) C^m)  ~  P^{m-1}.
> ```
>
> Then, for every `m >= 1`:
>
> 1. `Ktilde` acts on `V_lambda` by the scalar `lambda`, so `Z` is **pointwise
>    `K`-fixed**; and `P(V)^K = Z | | Z'`, where `Z' = P(V_{lambda'})` belongs
>    to the second (and last) spin linear character of `Ktilde`. In particular
>    `Z` is a connected component of `P(V)^K`.
> 2. `Pi_sigma^{eps} n Pi_tau^{delta} = Z` for the aligned sign pair, and
>    `= empty` for the two mixed pairs; the anti-aligned pair meets in `Z'`.
> 3. For `x` in `Z`: `T_x^K = T_x Z`, of dimension `m - 1`. The **whole**
>    trivial isotypic of `T_x` is tangent to `Z`.
> 4. `N = N_{Z/P(V)} = (V/V_lambda) (x) O_Z(1)` is a `K`-equivariant bundle
>    with constant fibre representation
>
>    ```text
>    K = S_3  :   N  =  m . sign  (+)  2m . std
>    K = D_10 :   N  =  m . sign  (+)  m . W_1  (+)  m . W_2
>    ```
>
>    and therefore **`m_triv(N) = 0` for every `m`**.

*Proof.* (1) `Ktilde` is `Q_12` or `Q_20`, with abelianisation `C_4`, hence
exactly two spin linear characters (`KLEIN_SPIN_COMPLEX.md` §2), each of
multiplicity 1 in `U` and so `m` in `V` (M0). `P(V)^K` is the disjoint union of
the `P(V_chi)` over spin linear characters (Prop 3.2), i.e. `Z | | Z'`.
(2) Prop 3.2(3) plus M0; the four sign combinations have intersection
dimensions `(1,0,0,1)` in `U` — verified on all 1980 incident pairs — hence
`(m,0,0,m)` in `V`.
(3) `T_x = lambda^{-1} (x) (V/L)` as an honest `K`-representation, so
`m_triv(T_x) = dim V_lambda - 1 = m - 1`; and `T_x Z = Hom(L, V_lambda/L)` is
trivial of dimension `m - 1`. `T_x Z <= T_x^K` and the dimensions agree.
(4) `Z = P(S)` is a linear subspace, so `N = (V/S) (x) O_Z(1)` with constant
fibre `lambda^{-1} (x) (V/V_lambda)`; at `m = 1` this is `T_x` minus its
(then zero) invariants, i.e. exactly Thm K5's `sign (+) 2.std` resp.
`sign (+) W_1 (+) W_2`. Multiply by `m` (M0). Finally
`m_triv(N) = m_triv(T_x) - dim T_x Z = 0`. `QED`

The numerical coincidence that made the route look promising is

```text
       m_triv(T_x)  =  m - 1  =  dim Z .
```

The trivial multiplicity grows with `m` **for exactly the reason the `K`-fixed
locus does, and no faster**. There are no invariant normal directions at any
multiplicity, so there is nothing to run a persistence induction on: the
induction the brief proposed fails at step 1, at every `m` including `m = 1`,
because the trivial multiplicity of the *normal* character is `0`, not `>= 1`.

## 3. One equivariant blowup separates everything, at every `m`

Let `W = | |_{e=1}^{352} Z_e` be the union of all 352 incidence loci (2 orbits
of 110 `S_3`-loci, 2 orbits of 66 `D_10`-loci), each `~ P^{m-1}`.

> **Lemma M2.** The 352 loci are pairwise disjoint. Hence `W` is a smooth
> closed `G`-invariant subvariety of `P(V)`, of pure dimension `m - 1`, and
> `B := Bl_W P(V)` is a smooth projective `G`-variety.

*Proof.* `Z_e n Z_f = P((U_{lambda_e} n U_{lambda_f}) (x) C^m)` and the 352
lines `U_lambda` of `U` are pairwise distinct with pairwise zero intersection —
verified exactly on all `61776` pairs. (Equivalently: a common point would have
stabiliser containing two distinct `S_3`/`D_10`'s, i.e. `A_5`, `F_55` or `G`,
and `P(U)^{A_5} = P(U)^G = empty`; the `F_55` case is excluded because the
incidence loci have stabiliser exactly `S_3` or `D_10`.) `QED`

Write `E_e` for the exceptional divisor over `Z_e` and `Pitilde` for the strict
transform of a plane `Pi` (note `Pi` is never contained in `W`:
`dim Pi = 3m-1 > m-1`).

> **Theorem M3 (the fixed locus of `B`).** Fix `e`, write `Z = Z_e`,
> `K = K(Z) = Stab_G(Z)`, and let `lambda, lambda'` be the two spin linear
> characters of `Ktilde`. Then `Stab_G(Z) = K` exactly, so the only involutions
> of `G` fixing a point of `E_Z` are those of `K`; and for each involution
> `rho` of `K`, with `Pi_rho^{eps_rho}` the plane of `rho` through `Z`,
>
> ```text
> E_Z^rho  =  A_rho  | |  B_rho ,
> A_rho = Z x P( V_{eps_rho i}(rho) / V_lambda )   ~ P^{m-1} x P^{2m-1}
>       = Pitilde_rho^{eps_rho}  n  E_Z ,
> B_rho = Z x P( V_{-eps_rho i}(rho) )             ~ P^{m-1} x P^{3m-1} ,
> ```
>
> with
>
> ```text
> A_rho n A_rho'  =  empty        (all rho != rho')
> A_rho n B_rho'  =  empty        (all rho, rho', including rho = rho')
> B_rho n B_rho'  =  S_Z := Z x P(V_lambda')  ~ P^{m-1} x P^{m-1}  != empty.
> ```
>
> Consequently the closed set `Fix(B) = U_{rho involution} B^rho` has exactly
>
> ```text
> 110 + 352  =  462   connected components:
> ```
>
> one for each plane (`Pitilde` together with the twelve `A`-loci it carries)
> and one for each incidence locus (the `|Inv K|` loci `B_rho`, glued along
> `S_Z`).

*Proof.* `Stab_G(Z) = Stab_G([U_lambda])` is the stabiliser of the underlying
incidence point of `P(U)`, which is exactly `S_3` or `D_10`
(`KLEIN_SPIN_COMPLEX.md` §2, re-verified). An involution fixing a point of
`E_Z` preserves `E_Z`, hence lies in `Stab_G(Z)`.

`N = (V/V_lambda) (x) O_Z(1)`. Splitting `V = V_{eps_rho i}(rho) (+)
V_{-eps_rho i}(rho)` and remembering `V_lambda <= V_{eps_rho i}(rho)` gives the
displayed eigen-subbundles; `rho` acts on the fibre of `O(-1)` by `eps_rho i`,
so the `(+1)`-eigenbundle is `(V_{eps_rho i}/V_lambda)(x)O(1)` and the
`(-1)`-eigenbundle is `V_{-eps_rho i}(x)O(1)`. Being sub-bundles with constant
fibre, both are products with `Z`.

The three intersection statements are `P` of the four sign combinations of M1(2)
(after dividing by `V_lambda` where relevant):
`A n A' = P((V_{eps} n V_{eps'})/V_lambda) = P(V_lambda/V_lambda) = empty`;
`A n B' = P(V_{eps} n V_{-eps'}) = P(0) = empty` (a mixed pair);
`B n B' = P(V_{-eps} n V_{-eps'}) = P(V_{lambda'})`, of dimension `m-1`.
`A_rho n B_rho = empty` because they lie in different eigenbundles of `rho`.

Finally the components. Away from the exceptional divisors, `Fix(B)` is
`(| |_{110} Pi) \ W`, and the 110 planes are pairwise disjoint there because
**every** nonempty intersection of two planes is one of the 352 loci (verified
on all 1980 edges), hence blown up. `Pitilde_rho^{eps}` meets `E_Z` iff
`Pi_rho^{eps}` meets `Z`, iff `Z <= Pi_rho^{eps}`, iff `rho` in `Inv(K)` and
`eps = eps_rho` (verified: the planes containing a locus are exactly its
incident planes, twelve per plane). So each `E_Z` contributes the `A_rho`,
absorbed into the planes, and the `B_rho`, which form one cluster of their own.
`QED`

> **Corollary M4 (the SPIN-LINKING LEMMA is FALSE).** Let
> `phi : P(V) --> V14` be any `G`-equivariant rational map. Let
> `X -> B -> P(V)` be the equivariant resolution obtained by first blowing up
> `W` and then equivariantly resolving the induced map `B --> V14`. Then in `X`
> the carriers of `Pi_sigma^{eps}` and `Pi_tau^{delta}` are **not** joined by
> any connected chain of irreducible RCC subvarieties each pointwise fixed by
> an involution of `G` — for any two of the 110 planes, in particular for
> `sigma != tau`.

*Proof.* Chains push forward. Let `pi : X -> B` be the structure morphism
(proper, birational, `G`-equivariant). If `T <= X` is irreducible, RCC and
pointwise `rho`-fixed, then `pi(T)` is closed (properness), irreducible
(continuous image), RCC (a morphism carries rational chains to rational chains
or points) and pointwise `rho`-fixed (`rho.pi(t) = pi(rho.t) = pi(t)`).
Consecutive members meet, so their images meet. Hence a chain in `X` maps to a
connected subset of `Fix(B)`.

The carrier of `Pi_sigma^{eps}` in `X` maps **onto** `Pitilde_sigma^{eps}` in
`B`: the Thm 4.1 tower replaces `F` either by its strict transform (birational
onto `F`) or by `P(N_mu|_F)` (a projective bundle onto `F`), and the tower from
`P(V)` to `X` passes through `B`, where the carrier is `Pitilde_sigma^{eps}`.

So a chain joining the two carriers in `X` would put `Pitilde_sigma^{eps}` and
`Pitilde_tau^{delta}` in one connected component of `Fix(B)`, contradicting
M3. `QED`

Nothing in §2-§3 used `m` except through M0, which multiplies dimensions and
changes no emptiness. **The refutation is uniform in `m`.**

### 3.1 The exact logical strength of M4

Theorem 7.2 needs the chain in **one** resolution (the carrier images `y(sigma,
eps)` are resolution-independent: two resolutions are compared through a common
dominating one, on which the carrier surjects onto both). So M4 does not by
itself say that no chain exists in any resolution whatsoever. What it says
exactly is:

* the boxed lemma, which quantifies over **every** `G`-equivariant resolution,
  is **false**;
* no chain exists in **any** resolution that admits a morphism to `B` — in
  particular in any resolution obtained by blowing up `W` first, which is
  always a legitimate first step;
* so a Theorem 7.2 argument would now have to produce, for each `phi`, a chain
  in some resolution that does **not** dominate `B`, i.e. it would have to show
  that resolving `phi` is incompatible with blowing up `W` first. Since K4 puts
  all of `W` inside `Ind(phi)` and `W` is smooth and `G`-invariant, no such
  incompatibility exists.

Route 1 is therefore closed, and with V3 having closed route 2, the boxed lemma
has no named route left.

## 4. The resolution-free form of the same data, and its refutation

The `V14^{D_10} = empty` datum supports a statement much stronger than
Theorem V1, and one that needs no chain at all:

> **Observation N1.** If `X` is a smooth projective `G`-variety with an
> equivariant **morphism** to `V14`, then `X^H` maps into `V14^H` for every
> `H <= G`. So `V14^{D_10} = empty` forces `X^{D_10} = empty` for every
> equivariant resolution `X` of every equivariant rational map
> `P(V) --> V14`. Hence:
>
> > a `G`-equivariant rational map `P(V) --> V14` exists **only if** some
> > smooth projective `G`-variety `X`, `G`-equivariantly birational to `P(V)`,
> > has `X^{D_10} = empty`.

This subsumes Thm V1 and route 2, and it is resolution-free: it is a pure
birational question about the `G`-variety `P(V)`. It is exactly the setting of
Reichstein-Youssin fixed-point theory, and the criterion is elementary:

> **Lemma N2 (destruction criterion).** Let `H` be finite acting on a smooth
> `X`, let `C <= X` be a smooth `H`-invariant subvariety and `p` in `C^H`.
> Then the `H`-fixed points of `Bl_C X` in the fibre over `p` are
> `| |_chi P((N_{C,p})_chi)`, the union over the **linear** characters `chi` of
> `H`. So the fixed locus over `p` is destroyed iff `N_{C,p} = T_pX / T_pC`
> contains no linear character of `H`. Fixed points of `Bl_C X` lie over fixed
> points of `X`, so a fixed locus can only be destroyed this way.

For **abelian** `H` every irreducible is a linear character, so nothing can
ever be destroyed — this is the Reichstein-Youssin abelian fixed-point theorem,
recovered as the degenerate case, and it is the reason the criterion has teeth
only for nonabelian `H`. `D_10` is nonabelian, and here it has teeth:

> **Theorem N3 (`X^{D_10} = empty` is achievable, at every `m`).** Let
> `C_5 <= D_10` be the Sylow 5-subgroup, `C_10` its preimage in `Gtilde`, and
> `ell_0 = ker(c + 1) <= U` the `(-1)`-eigenspace of a generator `c` of
> `C_10`, of dimension **2**. Put `L = P(ell_0 (x) C^m) ~ P^{2m-1}`. Then:
>
> 1. `L` is pointwise `C_5`-fixed, and `P(V)^{D_10} = Z | | Z' <= L`: both
>    `D_10`-fixed loci of `P(V)` lie on `L`.
> 2. `T_z^{C_5} = T_z L` for every `z` in `L`. Hence `N_{L/P(V)}` has **no
>    `C_5`-invariants**, so no trivial and no sign character of `D_10`, so **no
>    linear character of `D_10` at all**.
> 3. The 66 `G`-translates of `L` are pairwise disjoint except that exactly 11
>    of them pass through each of the 12 loci
>    `P_F = P(U^{F_55} (x) C^m) ~ P^{m-1}`, `F_55` running over the 12 Borel
>    subgroups; the 12 loci `P_F` are pairwise disjoint and are fixed by **no**
>    involution of `G` (`|F_55|` is odd).
> 4. Therefore: blow up `| |_{12} P_F` (smooth, `G`-invariant, and disjoint
>    from every involution's fixed locus, so no involution fixed locus is
>    altered), then blow up the 66 now-pairwise-disjoint strict transforms of
>    the `L`'s (smooth, `G`-invariant). The resulting smooth projective
>    `G`-variety `X_0` has
>
>    ```text
>    X_0^{D_10}  =  empty .
>    ```

*Proof.* (1) `lambda|_{C_10}` is the character `c |-> -1`: `C_5` lies in
`[Q_20, Q_20]` so `lambda` kills it, and `lambda(z) = -1` forces
`lambda(c) = -1`. Its multiplicity in `U` is `2` (verified: `dim ker(c+1) = 4`
in the 12-dimensional model, halved), hence `2m` in `V`, so `L ~ P^{2m-1}`;
and `V_lambda, V_{lambda'} <= ell_0 (x) C^m` (verified for all 132 `D_10`
loci), i.e. `Z, Z' <= L`. Both are pointwise `C_5`-fixed since `C_5` acts
trivially on `ell_0`.
(2) `m_triv(T_z | C_5) = dim V_{lambda|C_10} - 1 = 2m - 1 = dim L`, and
`T_z L <= T_z^{C_5}` because `L` is smooth and pointwise `C_5`-fixed; the
dimensions agree. Both linear characters of `D_10` are trivial on `C_5`, so a
linear character of `D_10` inside `N_L` would produce a `C_5`-invariant.
(3) Verified exactly: of the `2145` pairs of the 66 spaces `ell_0`, `1485` meet
in `0` and `660` meet in a line; the `660` are precisely the pairs of Sylow
5-subgroups lying in a common Borel `F_55` (`55` pairs in each of `12`), and
the common line is `U^{F_55}`, of dimension 1. `Stab_G` of a point of `P_F` has
odd order, so no involution fixes it.
(4) After blowing up the `P_F`'s, two `L`'s that met along `P_F` have disjoint
strict transforms (they are linear subspaces meeting exactly along `P_F`; the
blowup of the intersection separates them). The `D_10`-fixed loci `Z, Z'` are
disjoint from every `P_F` (stabilisers `D_10` and `F_55` are distinct and
`D_10 n F_55 = C_5`), so they survive the first blowup untouched, together with
`L`'s tangent behaviour along them. Blowing up the strict transform of `L`
removes `Z` and `Z'` from the variety and, by N2 and (2), creates no `D_10`-fixed
point in the exceptional divisor. Fixed points lie over fixed points, so
`X_0^{D_10} = empty`. `QED`

*Sanity check built into the statement.* The same criterion applied to the
abelian `C_5` says the `C_5`-fixed locus survives every blowup, because each
isotypic piece of `N_L` **is** a `C_5`-linear-character piece — as Reichstein-
Youssin requires. The destruction is possible for `D_10` and impossible for
`C_5` for exactly the reason the criterion isolates: `N_L = m W_1 (+) m W_2`
consists of 2-dimensional `D_10`-irreducibles.

So Theorem V1 (the sign point of `Bl_x P(U)` stays in the base locus) is true
but not extendable: the resolution never has to create that sign point at all.

## 5. The audit: no fixed-point obstruction remains

The possible stabilisers of a point of a spin source are
`1, C_2, C_3, C_5, C_6, C_11, S_3, D_10, F_55` (`KLEIN_SPIN_COMPLEX.md` §2).
Against the target:

| `H` | `P(U)^H` | `V14^H` | verdict |
|---|---|---|---|
| `C_2` | two `P^2`'s | sextic + 2 points (sealed) | no obstruction |
| `C_3` | three `P^1`'s | contains `V14^{S_3} != empty` | no obstruction |
| `C_5` | 4 points + a line | nonempty (see below) | no obstruction |
| `C_6` | 6 points | 2 points (sealed) | no obstruction |
| `C_11` | 6 points | nonempty (see below) | no obstruction |
| `V_4` | **empty** (`Q_8`) | — | vacuous |
| `S_3` | 2 points | 2 points (measured) | no obstruction |
| `D_10` | 2 points | **empty** (measured) | **destructible, Thm N3** |
| `F_55` | 1 point | unmeasured | destructible (`KLEIN_SPIN_COMPLEX.md` §3: the exceptional `P^4` has no `F_55`-fixed point) |
| `A_4, A_5, D_12, G` | empty | — | vacuous |

`V14^{C_5}` and `V14^{C_11}` are the only entries not settled in-repo. Both are
nonempty by the Lefschetz congruence `chi(V14^{C_p}) = chi(V14) mod p` with
`chi(V14) = -6` (`b_3 = 2 h^{1,2} = 10` for the genus-8 Fano threefold):
`-6 = 4 mod 5` and `-6 = 5 mod 11`, both nonzero. ~~**This uses a literature
value for `b_3(V_14)` and is flagged as such**~~ — **flag discharged
2026-08-11**: `chi_top(V14) = -6` and `b_3 = 10` are now derived in-repo from
the sealed model by exact Schubert calculus on `Gr(2,6)`
(`SEAL_V14_BETTI.md`, exit `V14-BETTI-SEALED`, verifier `V14_BETTI_OK`).
Both loci are also decidable in-repo
by one run of `verify_v14_s3_d10.py`'s machinery (`M|_{C_11}` is 10 isolated
points of `P^9`, `M|_{C_5}` is five `P^1`'s), and neither is load-bearing for
anything proved here — they only affect the completeness of this audit row.

For the **abelian** subgroups — the only ones whose fixed-point emptiness is a
birational invariant (N2 / Reichstein-Youssin) — every `A` with
`P(U)^A != empty` has `V14^A != empty`. So:

> **Corollary N4.** No obstruction of fixed-point type is available on the
> sealed and measured data, at any multiplicity. Every nonabelian candidate is
> destructible by an explicit `G`-invariant centre, and no abelian candidate
> exists.

## 6. Consistency tests

Recorded in full, with outcomes, in `ADVERSARIAL_TESTS.md`. Summary:

1. **D12 test — PASSED, and informative.** Cor IX.6 says `V14` **is**
   `D_12`-spin-unirational: a dominant `D_12`-equivariant map exists. A single
   `D_12` does see incidence points: two of its reflections whose product has
   order 3 generate an `S_3`, and their planes meet. So an argument proving
   linking at `S_3` points would contradict Cor IX.6. Our result is the
   opposite sign — it *proves separation* — and the separating blowup `Bl_W` is
   `G`-equivariant, hence a fortiori `D_12`-equivariant, so it exhibits
   concretely how the realised `D_12`-map's resolution separates the carriers
   it must separate. A proof of the linking lemma would have failed this test;
   the refutation passes it and explains the escape.
2. **m = 1 test — INVERTED, and reported as such.** The brief asked for the
   place where a persistence induction drops to trivial multiplicity `0` at
   `m = 1`. There is no such place, because the induction never gets off the
   ground: `m_triv(N_Z) = 0` at **every** `m`, `m = 1` included. The `m = 1`
   specialisation of M1 reproduces Thm K5 exactly (`Z` a point,
   `m_triv(T_x) = 0`, `T_x = sign (+) 2 std` / `sign (+) W_1 (+) W_2`), which
   is the regression check in §B of the verifier.
3. **Definedness test — PASSED.** Nothing here evaluates `phi` anywhere. M3
   and M4 are statements about `Fix(B)` for the *abstract* blowup `B`, and the
   only use of `phi` is through the pushforward of chains along `X -> B` and
   through K4 (which puts `W` in `Ind(phi)`, i.e. is used only to say that
   blowing `W` up is natural, never that `phi` is defined anywhere).
4. **No withdrawn machinery — PASSED.** No Chow projector, no "every stratum
   stays RCC" claim: RCC-ness is used only in the direction "image of RCC is
   RCC", which is elementary. Thm N3 uses only Lemma N2, which is the
   definition of a blowup.

An additional self-test that the refutation must pass and does: applied to an
**abelian** subgroup, the destruction criterion N2 correctly refuses to destroy
anything (§4), reproducing Reichstein-Youssin. A criterion that destroyed
abelian fixed loci would be wrong.

## 7. Quantifier discharge — status

Not reached, and moot: nothing is proved about `P(U)`, so there is nothing to
discharge. For the record, the state of the discharge argument, checked line by
line:

* **Thm 7.4 direction 1** ("a dominant `P(U) --> Y` gives a dominant
  `P(U^{(+)m}) --> Y`") is correct and is what route 1 was going to use. It is
  now useless in that direction, since `P(U^{(+)m})` is not obstructed either.
* **Thm 7.4 direction 2** ("kill `P(V_reg^{spin,(+)k})` uniformly in `k`")
  remains the only stated way to reach "all faithful spin sources". It requires
  obstructing sources that are **not** multiples of `U`: the Galois-conjugate
  `U'` and the other faithful spin irreducibles of `SL(2,11)` (dimensions
  `6, 6, 10, 10, 12`, the spin block). Everything proved in this packet about
  `U` transfers verbatim to `U'` by the Galois symmetry of the monomial model
  (`W = U (+) U'` with `rho` integral), but **nothing** here covers the
  higher-dimensional spin irreducibles.
* **Lemma IX.3 folding** (`FIX_IX_v14.md` §7(ii)) is about dominating a product
  of sources by a single spin source; it reduces "all sources" to "all spin
  sources", not "all spin sources" to "`U`". So even a complete obstruction for
  `P(U^{(+)m})` would have covered only the sources containing `U` as a
  summand. This is stated exactly here so that no future packet over-reads it.

## 8. Exit

```text
SPIN-MULTIPLICITY-REFUTED
SPIN-LINKING-LEMMA-FALSE
D10-FIXED-POINT-ROUTE-DEAD
SPIN-CHAIN-OBSTRUCTION-UNDECIDED
```

The headline `ed_C(PSL_2(F_11)) = 4` is **not** established and its
consequence chain is **not** triggered: the chain was conditional on the boxed
SPIN-LINKING LEMMA, which this packet shows to be false as boxed. Problem E's
spin flank remains OPEN, and it now has no named route: any future attack must
use an invariant that is not of fixed-point type — the fixed-point flank is
provably exhausted (Cor N4).

## 9. Replay

From `problems/E-klein-cubic/goal_runs_20260810/SPIN_SOURCE_NETWORK/`:

```text
python3 verify_spin_multiplicity.py        # marker SPIN_MULTIPLICITY_OK
```

Python 3 standard library only. No Macaulay2, no msolve, no network, no data
files. Runtime about 40 s on one core.
