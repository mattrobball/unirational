# Theorems: the multiplicity route closes negatively

Two theorems are **fully proved** here. Both are negative: they close the two
named routes past the boxed SPIN-LINKING LEMMA of `KLEIN_SPIN_COMPLEX.md` §7.
The analysis, the consistency tests and the residual are in
`MULTIPLICITY_ROUTE.md` and `ADVERSARIAL_TESTS.md`; this file states the
theorems, their exact hypotheses, and every input they use.

Notation. `G = PSL(2,F_11)`, `Gtilde = SL(2,F_11)`, `U` the 6-dimensional spin
irreducible, `V = U^{(+)m}` for `m >= 1`, `Y = V14` the twin.
`Pi_sigma^{eps} = P(V_{eps i}(sigma))` the eigenplanes.

## Inputs, all cited

**Sealed / measured (not recomputed here).**

| input | source | exit |
|---|---|---|
| `V14^sigma` = smooth genus-1 sextic `E_sigma` + 2 reduced points; **no rational curve** | `goal_runs_after_c53d89a/FIX_IX_SEAL` | `FIX-IX-SEAL-PASS` |
| `V14^{D_12} = empty`; `C_G(sigma) = D_12` | same | same |
| `V14^{D_10} = empty` (all 66 subgroups) | `V14_S3_D10_MEASUREMENT.md` | `V14-D10-EMPTY` |
| `V14^{S_3}` = 2 reduced points, stabiliser exactly `S_3` | same | `V14-S3-NONEMPTY` |
| `V14^{A_5} = empty`, hence `V14^G = empty` | same | `V14-A5-EMPTY` |

**Source-side, recomputed exactly by `verify_spin_multiplicity.py` (marker
`SPIN_MULTIPLICITY_OK`)**: the 110 eigenplanes, the 1980 incident pairs, the
352 incidence loci with stabilisers exactly `S_3` (220) and `D_10` (132), the
four-sign incidence pattern, the pairwise disjointness of the loci, the 66
`C_5`-fixed lines, the 12 `F_55` points, and the `m = 1` regression against
Thm K5.

**Theory used.** `THEORY_SPIN_ENGINE.md` Prop 3.2 (the stratum network),
Thm 4.1 (carriers), Thm 5.1/5.2 (rigidity, mandatory base locus);
`KLEIN_SPIN_COMPLEX.md` K1-K5. Equivariant Hironaka in characteristic 0
(`FIX_I_bcomplex.md` Prop 3.3). Nothing withdrawn; no Chow projector; no
"every stratum stays RCC".

---

## Theorem A (the SPIN-LINKING LEMMA is false, at every multiplicity)

> Let `m >= 1` and let `phi : P(U^{(+)m}) --> V14` be any `G`-equivariant
> rational map. Let
>
> ```text
> W  =  | |_{e=1}^{352} Z_e ,      Z_e = P(V_{lambda_e}) ~ P^{m-1},
> ```
>
> be the union of the 352 incidence loci, and let `X -> B := Bl_W P(V) ->
> P(V)` be the `G`-equivariant resolution of `phi` obtained by blowing up `W`
> first and then equivariantly resolving `B --> V14`. Then in `X` **no two** of
> the 110 carriers of Theorem 4.1 are joined by a connected chain of
> irreducible RCC subvarieties, each pointwise fixed by an involution of `G`,
> consecutive members meeting.
>
> Consequently the SPIN-LINKING LEMMA, which asserts such a chain in **every**
> `G`-equivariant resolution, is **FALSE**, at every multiplicity `m >= 1`, and
> Theorem 7.2 / K3 yields no contradiction along it.

Proof: `MULTIPLICITY_ROUTE.md` Lemma M0, Theorems M1-M3, Corollary M4. The
three load-bearing computations, all exact:

```text
m_triv(T_x)  =  dim V_lambda - 1  =  m - 1  =  dim Z  =  dim T_x Z
m_triv(N_{Z/P(V)})  =  0                                for every m
Fix(B)  has  110 + 352 = 462  connected components
```

The first says the `K`-invariant tangent directions at an incidence point are
**exactly** the directions along the `K`-fixed component `Z` through it; the
second is the immediate consequence, and it is what kills the persistence
induction at step 1 rather than at some later order; the third is the global
statement, computed over all 110 planes and all 352 exceptional divisors at
once.

**Exact strength.** Theorem 7.2 needs a chain in *one* resolution, so Theorem A
does not exclude a chain in a resolution failing to dominate `B`. That residual
is stated in `MULTIPLICITY_ROUTE.md` §3.1 and is inert: `W` is smooth,
`G`-invariant and contained in `Ind(phi)` (Thm K4), so blowing it up first is
always a legal opening move and nothing can force a resolution to avoid it.

---

## Theorem B (`V14^{D_10} = empty` exports no obstruction)

> For every `m >= 1` there is a smooth projective `G`-variety `X_0`,
> `G`-equivariantly birational to `P(U^{(+)m})`, with
>
> ```text
> X_0^{D_10}  =  empty .
> ```
>
> Explicitly, `X_0` is obtained from `P(V)` by blowing up first the 12 loci
> `P(U^{F_55} (x) C^m) ~ P^{m-1}` (`F_55` the 12 Borel subgroups) and then the
> 66 pairwise-disjoint strict transforms of `L_{C_5} = P(ell_0 (x) C^m) ~
> P^{2m-1}`, where `ell_0 <= U` is the 2-dimensional `(-1)`-eigenspace of a
> generator of the lift `C_10` of a Sylow 5-subgroup.
>
> Consequently the resolution-free necessary condition that the sealed
> `V14^{D_10} = empty` imposes on an equivariant map `P(V) --> V14` — namely
> that some smooth projective model have empty `D_10`-fixed locus — is
> **satisfiable**, and yields no obstruction. This supersedes route 2 and
> subsumes Theorem V1.

Proof: `MULTIPLICITY_ROUTE.md` Observation N1, Lemma N2, Theorem N3. The
load-bearing computations, all exact:

```text
dim_U ker(c + 1)  =  2                (c a generator of C_10)
m_triv(T_z | C_5)  =  2m - 1  =  dim L                  for every m
so  N_L  has no C_5-invariants, hence no linear character of D_10,
hence  P(N_L)^{D_10} = empty .
the 66 spaces ell_0 pairwise meet in  0 (1485 pairs)  or in  U^{F_55} (660),
the 660 being exactly the Sylow-5 pairs inside a common Borel: 55 in each
of the 12 Borels; no involution fixes an F_55 point (|F_55| odd).
```

**Why this is not too strong.** The same criterion (Lemma N2) applied to an
abelian subgroup destroys nothing — every irreducible of an abelian group is a
linear character — which is the Reichstein-Youssin fixed-point theorem
recovered as a special case. Blowing up `L` kills the `D_10`-fixed locus and
leaves the `C_5`-fixed locus alive, exactly as it must.

---

## Corollary C (the fixed-point flank is exhausted)

> No obstruction of fixed-point type to the existence of a `G`-equivariant
> rational map `P(V) --> V14` is available on the sealed and measured data, at
> any multiplicity.

The possible stabilisers of a point of a spin source are
`1, C_2, C_3, C_5, C_6, C_11, S_3, D_10, F_55`. For the **abelian** ones — the
only ones whose fixed-point emptiness is a birational invariant (Lemma N2) —
`P(U)^A != empty` implies `V14^A != empty` in every case. For the nonabelian
ones, `V14^{S_3} != empty`; `V14^{D_10} = empty` but the locus is destructible
(Theorem B); the `F_55` point was already known destructible
(`KLEIN_SPIN_COMPLEX.md` §3). See `MULTIPLICITY_ROUTE.md` §5 for the table, and
for the one flagged non-in-repo input (`V14^{C_5}`, `V14^{C_11}` argued
nonempty from `chi(V14) = -6`, using the literature `b_3(V_14) = 10`; nothing
proved here depends on it).

---

## What is NOT claimed

* **Not** `SPIN-CHAIN-OBSTRUCTION-PROVED`. Nothing here obstructs anything.
* **Not** that no `G`-equivariant map `P(U) --> V14` exists — the question is
  untouched and remains OPEN.
* **Not** that `ed_C(PSL_2(F_11)) = 4`. The consequence chain of
  `KLEIN_SPIN_COMPLEX.md` §7 was conditional on the boxed lemma; the lemma is
  false as boxed, so the chain is **not** triggered. Neither is its negation:
  nothing here says `V14` **is** spin-unirational.
* **Not** any statement about spin sources other than `U^{(+)m}` and (by the
  Galois symmetry of the integral model `W = U (+) U'`) `U'^{(+)m}`. The
  higher-dimensional faithful spin irreducibles of `SL(2,11)` are untouched,
  and Lemma IX.3 does not reduce them to `U` — see `MULTIPLICITY_ROUTE.md` §7.

## Exit

```text
SPIN-MULTIPLICITY-REFUTED
SPIN-LINKING-LEMMA-FALSE
D10-FIXED-POINT-ROUTE-DEAD
SPIN-CHAIN-OBSTRUCTION-UNDECIDED
```
