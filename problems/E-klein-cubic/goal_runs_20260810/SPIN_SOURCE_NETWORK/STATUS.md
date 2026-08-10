# Spin-source fixed network — status

**Date:** 2026-08-10.
**Problem:** E (Klein cubic / `V14` twin) — the spin flank of [IX §6], plus
the general engine and one new example.
**Headline:** Problem E remains **OPEN**. The spin flank is not closed; it is
computed exactly, given two new unconditional theorems, and reduced to one
boxed lemma with two concrete routes past it.

## Exit ledger

```text
SPIN-SOURCE-NETWORK-COMPUTED

SPIN-CHAIN-OBSTRUCTION-UNDECIDED

NEW-EXAMPLE-ASSESSED
SPIN-DP2-PSL27-UNDECIDED
```

`SPIN-CHAIN-OBSTRUCTION-PROVED` is **NOT** claimed. The chain system does not
close; the missing step is boxed verbatim in `KLEIN_SPIN_COMPLEX.md` §7 and
`THEORY_SPIN_ENGINE.md` §7, together with a proof (Thm 7.3 / K5 / F4) that
its naive form is FALSE at first order.

## One line per deliverable

1. **Part 1, general engine** (`THEORY_SPIN_ENGINE.md`) — DERIVED. Swapped
   pairs and the index-two stabiliser (Lem 1.2/1.3); the commutator-pairing
   criterion `P(V)^A != empty <=> Atilde abelian` and the `V_4`/`Q_8`
   corollary, valid for *every* faithful spin source (Prop 2.2, Cor 2.3);
   the whole stratum/incidence/stabiliser network from the character table of
   `Gtilde` (Prop 3.2); the spin carrier theorem for swapped pairs (Thm 4.1)
   and why it is non-obstructing alone (Cor 4.2); **new**: rigidity (Thm 5.1)
   and mandatory base locus (Thm 5.2); **new**: no scalar birth on spin
   sources (Thm 6.1) and first-order separation (Thm 7.3) — the two exact
   structural reasons the Problem-F engine does not transplant; the
   multiplicity reduction that discharges the "all spin sources" quantifier
   (Thm 7.4).
2. **Part 2, Klein** (`KLEIN_SPIN_COMPLEX.md`) — `U|_{Q_8} = 3H` for all 55
   four-groups so `P(U)^{V_4}` is empty; the complete incidence table of the
   110 eigenplanes (1980 meeting pairs, 352 distinct incidence points, 36-
   regular connected graph); Theorems K1-K4 (carriers, `Stab = C_6` exactly,
   rigidity, and the 352-point mandatory base locus) proved unconditionally
   on top of the sealed `FIX-IX-SEAL-PASS` data; K5/K6 show why the chain
   stops.
3. **Part 3, new example** (`NEW_EXAMPLE.md`) — `PSL(2,7)` on the Klein
   degree-two del Pezzo from the spin source `P(U) = P^3`: genuinely open
   (Problem F's `SPEC.md` restricts to linear sources; zero in-repo mentions
   of spin; CTZ's published definition excludes it), engine runs completely
   (42 lines, 56 `S_3`-points, 8-regular connected), two new unconditional
   theorems F1/F2, same boxed lemma. Payoff correctly scoped: it would
   complete Problem F over all projectively-linear sources but yields **no**
   new essential-dimension statement, since `ed_C(PSL(2,7)) = 2` is known
   (Duncan) and `P(spin)` is not weakly versal (Duncan-Reichstein Prop 9.1).

## Load-bearing citations, not recomputed

* `V14^sigma` = smooth genus-1 sextic + 2 points; `V14^{D_12} = empty`;
  `C_G(sigma) = D_12` — `goal_runs_after_c53d89a/FIX_IX_SEAL`, exit
  `FIX-IX-SEAL-PASS`, char-0 smoothness DISCHARGED.
* `S^{C_2}` = genus-1 curve + 2 points —
  `problems/F-dp2-psl27/certificates/wp1_fixed_loci.py` / `WP1_FIXED_LOCI.md`.

## Named next tasks (both cheap, both decisive for the box)

1. **`V14^{S_3}` and `V14^{D_10}`** — not measured by any sealed packet. One
   FIX-IX-SEAL-style run each. `V14^{S_3} = empty` converts the
   second-generation route of `KLEIN_SPIN_COMPLEX.md` §7 into a contradiction.
2. **Multiplicity 2.** Re-run the local analysis on `P(U (+) U)`; Thm 7.4
   makes this legitimate (it dominates `P(U)`) and Thm 7.3 shows the
   first-order separation obstruction vanishes there.

## Exact checks

```text
python3 verify_spin_klein_network.py     -> SPIN_SOURCE_NETWORK_OK
python3 verify_spin_dp2_psl27.py         -> SPIN_DP2_PSL27_OK
```

Both are exact, characteristic 0, integer / `Q(i)` arithmetic in dimension
`<= 12`; no sampling, no search, no modular reduction. The second
independently recomputes the whole `q = 11` network through a different code
path and reproduces the first exactly (`crosscheck_q11`).

## Boundaries respected

No withdrawn "every stratum stays RCC" claim is used (the carrier induction
of Thm 4.1 tracks a single stratum, exactly as Cor IX.1 does). No Chow
projectors. The spin statements quantify over all faithful spin sources
wherever they are stated to (Cor 2.3, Thms 4.1, 5.1, 5.2 are
multiplicity-free); where a statement is specific to the multiplicity-free
source `U`, that is said explicitly (Thm 7.3, K5, F4), and Thm 7.4 records
that killing `P(U)` alone is **not** the headline.
