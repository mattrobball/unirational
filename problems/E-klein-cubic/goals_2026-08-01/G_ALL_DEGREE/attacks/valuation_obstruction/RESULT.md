# Valuation obstruction result

## Verdict

No pointlessness theorem is obtained.  The exact conclusion is instead a
large positive local-solubility theorem:

> The generic twisted Klein cubic has a rational point over every iterated
> complete-DVR field attached to a geometric Parshin chain on
> `K_proj` whose terminal residue field has transcendence degree at most one
> over `C`.  In particular this covers the standard successive iterated
> completions attached to every saturated geometric Parshin chain of length
> three or four on the four-dimensional field `K_proj`, including the
> corresponding lexicographic geometric monomial chains.

Consequently none of those valuations can prove
`V(Phi)(K_proj)=empty`.  An exhaustive higher-rank tropical obstruction in
that family is impossible, independently of coordinate choices, Newton
polytopes, or cancellation patterns.

This is not a global point and is not a Goal G headline decision.  Among
standard geometric Parshin towers, the uncovered ranks one and two have
terminal residue transcendence degrees three and two.  Nongeometric
valuations and nonstandard higher-rank completion models are also outside
the theorem, regardless of their residue fields.

## Inputs actually used

1. `G_ALL_DEGREE/generic_cubic.json` reconstructs one cubic form in five
   variables over the degree-twelve field
   `K_proj/QQ(t3,t6,t8,t11)`.
2. `Q_SCHUR_DESCENT/verify_zero_cycle_ledger.py` independently reconstructs
   the `D12`-stable line contained in the Klein cubic, proves its full
   stabilizer has order 12, and hence proves orbit degree `660/12=55`.
   Over the degree-55 finite etale quotient, twisting this honest
   two-dimensional subrepresentation gives a rank-two vector bundle whose
   projectivization has a point on every field component.  Pushforward gives
   an effective degree-55 zero-cycle on every twist, including after
   arbitrary scalar extension.
3. Coray's complete-DVR theorem, stated precisely in `THEOREM.md`, says that
   the Cassels--Swinnerton-Dyer property for cubic forms ascends from a
   residue field to a complete discretely valued field.
4. A field of transcendence degree at most one over `C` has the required
   base property: for at least four variables this is Tsen--Lang; plane
   cubics have the property over every field; binary and unary cubics are
   elementary.

The decisive arithmetic is effective, not merely an index calculation.
After any scalar extension, the degree-55 cycle decomposes as

```text
55 = sum multiplicity_i * residue_degree_i.
```

Since `55` is prime to `3`, at least one residue degree is prime to `3`.
That closed point is exactly the finite extension point required by Coray's
Theorem 4.7.

## Why the earlier negative shortcuts fail

- `Q_SCHUR_DESCENT` correctly proves index one, not a rational point.  This
  packet does not make that fallacy: it invokes a theorem that is valid only
  for the specified complete-DVR towers.
- `V_VALUATION_TROPICAL_CODEX_ROOT_20260801` correctly rules out index-three
  specialization and ordinary Brauer evaluation.  The present theorem is
  stronger for the stated rank-three/four successive Parshin completions: it
  proves actual local points.
- A real tropical hypersurface being nonempty is not enough, and an
  integral-value screen can in general be stronger.  Here, however, any
  purported integral tropical pointlessness certificate on the covered
  completions would contradict Coray plus the effective degree-55 cycle.
- Prime 67 is not used for the decision.  The verifier reconstructs the
  characteristic-zero `D12` orbit calculation; the theorem is
  characteristic zero.

## Exact remaining negative problem

A valuation proof must now use a completion not covered above, such as a
rank-one divisor with residue field of transcendence three or a rank-two
chain with residue field of transcendence two, and it must detect an
index-one cubic without using the constant ordinary Brauer group.  Proving
such a completion pointless would produce a special counterexample to the
general Cassels--Swinnerton-Dyer prediction for cubic hypersurfaces.

## Completion versus henselization

Every assertion here concerns the **successive complete-DVR fields** in the
Parshin tower.  No point over a henselization is asserted.  A completion
point is sufficient to retire that completion as a negative obstruction,
but this packet does not use an approximation theorem to descend it to the
henselization.

## Replay

From `goals_2026-08-01` run:

```sh
/opt/homebrew/bin/python3 \
  G_ALL_DEGREE/attacks/valuation_obstruction/produce_certificate.py
/opt/homebrew/bin/python3 \
  G_ALL_DEGREE/attacks/valuation_obstruction/verify.py
```

The terminal verifier marker is

```text
G_VALUATION_PARSHIN_COMPLETIONS_SOLUBLE_EXACT
```

The primary-source PDF used to confirm Coray's theorem number, section, and
printed pages had SHA-256
`ea2dcf48c17b9a2c5c5ec8a73d3ccf1c9178033da8d5e1e33fbf5323624c73c6`.
After downloading the archival URL in `THEOREM.md`, its bytes can optionally
be checked with

```sh
/opt/homebrew/bin/python3 \
  G_ALL_DEGREE/attacks/valuation_obstruction/verify.py \
  --coray-pdf /path/to/aa3037.pdf
```
