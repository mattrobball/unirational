# Notebook supplement — 2026-08-10: the spin-source fixed network (the `V14` spin flank, made computable)

## What was asked

Build the spin-source counterpart of the linear-source fixed-locus
obstruction machinery: the machinery for an arbitrary finite group with a
double cover, the concrete Klein-deciding case (`Gtilde = SL(2,F_11)`, `U` a
6-dimensional spin irreducible, target the sealed `V14` network), and one new
example that the linear theorems could not reach.

Packet: `goal_runs_20260810/SPIN_SOURCE_NETWORK/`.

## Exits

```text
SPIN-SOURCE-NETWORK-COMPUTED

SPIN-CHAIN-OBSTRUCTION-UNDECIDED

NEW-EXAMPLE-ASSESSED
SPIN-DP2-PSL27-UNDECIDED
```

`SPIN-CHAIN-OBSTRUCTION-PROVED` is **not** claimed and the headline is
unchanged: Problem E remains **OPEN**.

## What is new and unconditional

The engine (`THEORY_SPIN_ENGINE.md`) states and proves, for any finite `G`
with a double cover `Gtilde` and any faithful spin source `V` (`z` acting as
`-id`):

1. **Swapped pairs.** For a spin-obstructed involution `sigma` (lift of order
   4), `P(V)^sigma = P(V_{+i}) ⊔ P(V_{-i})`; the map
   `eps : C_G(sigma) -> {±1}` defined by `gtilde sigmatilde gtilde^{-1} =
   sigmatilde^{eps(g)}` is a well-defined homomorphism whose kernel `N_0`
   stabilises each eigenspace and whose complement swaps them.
2. **The `V_4` criterion, exactly.** With the commutator pairing
   `c(a,b) = [atilde,btilde] ∈ <z>`: `P(V)^A ≠ ∅` iff the preimage `Atilde`
   is abelian. Since a nonabelian group of order 8 has `[Atilde,Atilde] =
   <z>` and every linear character kills it, `P(V)^{V_4} = ∅` for **every**
   faithful spin source whenever the preimage is `Q_8` or `D_8`. Multiplicity-
   free, so it discharges the "all spin sources" quantifier by itself. On the
   Klein case this proves the `FIX_IX` §6 prediction: `U|_{Q_8} = 3H` for all
   55 four-groups.
3. **The spin carrier theorem** (Thm 4.1) — Cor IX.1's induction with
   `C_G(sigma)` replaced by `N_0` — and the statement that it is
   non-obstructing alone: it forces only a two-element `C_G(sigma)`-orbit
   with stabiliser `N_0`, which is exactly the escape Cor IX.6 shows is
   realised.
4. **Rigidity and a mandatory base locus** (Thms 5.1, 5.2) — the genuinely
   new pairwise-level content. On the `V14`: every `C_6`-fixed point of
   `V14^sigma` has stabiliser exactly `C_6` (re-derived from
   `V14^{D_12} = ∅` plus the subgroup lattice, so it also covers points on
   the genus-1 sextic, which the seal did not measure), hence the carrier
   determines its involution, hence **all 352 incidence points of the
   eigenplane network lie in the indeterminacy locus of every equivariant
   rational map `P(U) --> V14`, dominant or not, at every degree.**
5. **Why the Problem-F engine does not transplant** — two exact structural
   theorems. (i) *No scalar birth*: `sigma` acts on `T_x P(V)` with both
   eigenvalues unless one eigenspace is a line, which cannot happen for a
   swap-realised involution with `dim V ≥ 4`; Problem F's whole chain rests
   on `dz|_q = -1` being scalar at `q = P(E_+(z))`, `dim E_+(z) = 1`. (ii)
   *First-order separation*: at an incidence point,
   `<chi_{T_x}, 1_K> = dim(V_{εi}(σ) ∩ V_{δi}(τ)) - 1 = 0`, so one blowup
   separates the two carriers.

## The Klein numbers (exact, char 0, no sampling)

55 involutions and 55 four-groups (a `55_3` configuration), all preimages
`Q_8`, `U|_{Q_8} = 3H`, `P(U)^{V_4} = ∅`. 110 eigenplanes `P^2 ⊂ P^5`,
stabiliser `C_6`, swapped by the six `D_12`-reflections. Incidence over all
5995 pairs: commuting pairs and `D_12`-generating pairs are **disjoint**
(`P(U)^{D_12} = ∅`, the source-side mirror of the sealed `V14^{D_12} = ∅`);
`S_3`- and `D_10`-pairs meet, giving 1980 edges through **352 distinct
points** — 220 with stabiliser exactly `S_3` (2 orbits of 110) and 132 with
stabiliser exactly `D_10` (2 orbits of 66). The network is **connected**,
36-regular, eccentricity 3; `D_12`-paired planes are never adjacent but sit
at distance 2. Odd strata: `P(U)^{C_3}` = three lines, `P(U)^{C_5}` = 4
points + a line, `P(U)^{C_6}` = 6 points, `P(U)^{C_11}` = 6 points with
`dim U^{C_11} = 1` (so `P(U)^{F_55}` is a single point — the `F_55` first cut
of §8 does not apply to this source).

## The boxed gap

> **SPIN-LINKING LEMMA (open).** In every equivariant resolution, the carriers
> over two incident eigenplanes are joined by a connected chain of irreducible
> RCC subvarieties each pointwise fixed by an involution. One instance with
> `sigma ≠ tau` would give a contradiction and hence the headline.

Proved here: the naive form is **false at first order** for the
multiplicity-free source `U`. Two concrete routes past it are recorded: (a)
work at multiplicity `≥ 2` — legitimate because `P(V ⊕ W) --> P(V)` is
dominant equivariant, so killing the bigger source kills the smaller, and it
is in any case what the "all faithful spin sources" quantifier of Cor IX.5
actually demands (killing `P(U)` alone is **not** the headline); there
`<chi_{T_x},1_K> = m-1 ≥ 1` and the first-order separation disappears; (b)
measure `V14^{S_3}` and `V14^{D_10}`, which **no sealed packet has** — one
FIX-IX-SEAL-style run each, and `V14^{S_3} = ∅` would close the
second-generation route.

## The new example

`PSL(2,7)` on the Klein degree-two del Pezzo from the spin source
`P(U) = P^3` (`U` a 4-dimensional `SL(2,7)` spin irreducible). Genuinely
open: Problem F's `SPEC.md` restricts to linear sources, `problems/F-dp2-psl27/`
has zero occurrences of "spin"/"projectively linear"/"Severi-Brauer", and
CTZ arXiv:2502.19598 defines `G`-unirationality only for genuine linear `V`.
The engine runs completely: 21 involutions, 14 four-groups, `U|_{Q_8} = 2H`,
42 eigenlines in `P^3`; `V_4`- and `D_8`-pairs disjoint (`P(U)^{D_8} = ∅` via
the generalised quaternion `Q_16`), `S_3` the only incidence type, 168 edges
through 56 points each on 3 lines with stabiliser exactly `S_3`; connected,
8-regular. Rigidity holds here **without any new target computation**: the
target is a surface, so `Stab_G(y)` embeds in `GL_2`, and neither `S_4` nor
`PSL(2,7)` has a faithful 2-dimensional representation — which is what the
`V14` case had to get from the seal. Same boxed lemma; not decided.

Payoff scoped honestly: closing it would complete Problem F over **all**
projectively-linear sources, but yields **no** new essential-dimension
statement — `ed_C(PSL(2,7)) = 2` is known (Duncan, arXiv:0912.1644 Thm 1.1;
Beauville arXiv:1101.1372 Prop 16.3), and by Duncan-Reichstein
arXiv:1109.6093 Prop 9.1 a spin source is itself not weakly versal. The
essential-dimension payoff of the spin flank exists only on the `PSL(2,11)`
side, via Cor IX.5.

## Citation gap flagged

Yu. Prokhorov, *Quasi-simple finite groups of essential dimension 3*,
arXiv:1703.10780, Prop 2.6 proves `ed_C(SL(2,7)) = 4`, and its Lemma 2.6.1
proves that the image `V_4 ≤ PSL(2,7)` of a `Q_8 ≤ SL(2,7)` fixes a point on
every rational `PSL(2,7)`-surface — an independent published analogue of
Problem F's own `V_4` computation. It is cited nowhere in
`problems/F-dp2-psl27/`. It contradicts nothing here (our `P(U)^{V_4} = ∅` is
about the threefold source `P^3`, not a surface).

`verify_spin_klein_network.py` (`SPIN_SOURCE_NETWORK_OK`),
`verify_spin_dp2_psl27.py` (`SPIN_DP2_PSL27_OK`, and it recomputes the whole
`q = 11` network through a second code path as a cross-check), and
`scripts/check_manifest_parity.py` all pass. The packet is on
`agent/spin-source-network-20260810`. This notebook revision was authored
against parent head `263dd8d07877365b8ef05820545642c6fb2a963b`.
