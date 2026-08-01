# Low-rank and nonstandard valuation attack

## Verdict

No pointless completion was found.  Instead, the attack proves the following
exact additional local-solubility class for the genuine generic twist:

> For every Krull valuation `v` of `K_proj`, of arbitrary rank and trivial on
> `C`, whose residue field is `C1`, the genuine twisted Klein cubic has a point
> over the henselization `K_v^h`.

Since every field of transcendence degree at most one over `C` is `C1`, this
rules out all rank-one, rank-two, and nonstandard valuation sites with such a
residue field.  It also gives points over ordinary rank-one completions and
over every explicitly presented successive complete-DVR tower with `C1`
terminal residue.

The proof is special to the genuine twist and is stronger than a
value-group tropical statement.  If torsor inertia is nontrivial, the exact
`PSL_2(F_11)` centralizer classification gives a stable point or contained
`P1`.  If inertia is trivial, the torsor extends etale; its honest
five-dimensional representation twists to a free rank-five module over the
local valuation ring, so the residue object is a cubic in a split `P4`.
Tsen--Lang then applies by the literal inequality `5>3`, and smooth Hensel
lifting gives the local point.

`VALUATION_FOUNDATIONS.md` audits the arbitrary-rank steps separately.  It
derives tame-inertia centrality from the ramification pairing and constructs
the unramified model through the finite-etale equivalence for henselian
local rings.  In particular, it does not assume noetherianity or finiteness
of an integral closure.

## Exact advance over the installed packets

The installed valuation census proved local solubility for residue field
`C` and, separately, used the degree-55 cycle plus Coray for standard
geometric length-three/four successive completions.  The new theorem:

1. replaces `residue field C` by the full `C1` class;
2. applies directly to henselizations of arbitrary-rank valuations;
3. includes non-Abhyankar rank-one/rank-two valuations with residue
   transcendence degree at most one;
4. covers arbitrary specified successive complete-DVR towers with `C1`
   terminal residue, not only standard geometric Parshin completions;
5. requires neither an index-to-point inference nor Coray's theorem;
6. shows, independently of residue dimension, that an unramified negative
   site must have decomposition group `G`, one of the two maximal `A5`
   classes, or maximal `11:5`.

## What this rigorously refutes

A valuation shortcut cannot be obtained merely by lowering the residue
transcendence degree to zero or one, even at a rank-one/rank-two or
nonstandard valuation.  Both torsor-inertia possibilities give an actual
point.  Likewise, replacing a standard Parshin completion by another
successive complete-DVR tower with the same `C1` terminal residue cannot
create pointlessness.

## Remaining valuation gate

The central geometric cases still include:

- unramified divisorial valuations with residue transcendence degree three;
- unramified saturated rank-two chains with terminal residue transcendence
  degree two.

More generally, every unramified valuation whose residue is not known to be
`C1` remains outside the theorem.  After the subgroup-twist refinement, a
negative site in this larger class must have decomposition group `G`, one of
the two maximal `A5` classes, or maximal `11:5`.  Thus the two displayed
geometric rows are important unresolved sites, not an exhaustive census of
all nongeometric valuations.

The named `f5` and `f6` divisors lie in the first class.  Nothing in this
packet decides their full five-coordinate residue cubics.  No global
`K_proj`-point and no all-degree landing covariant is asserted.

## Replay

From `goals_2026-08-01`, run

```sh
/opt/homebrew/bin/python3 \
  G_ALL_DEGREE/attacks/low_rank_valuations_v2/verify.py
```

The terminal marker is

```text
G_LOW_RANK_C1_RESIDUE_LOCAL_SOLUBILITY_EXACT
```
