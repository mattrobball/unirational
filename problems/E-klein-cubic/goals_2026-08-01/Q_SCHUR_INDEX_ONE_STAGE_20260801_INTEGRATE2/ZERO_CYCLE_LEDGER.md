# Exact zero-cycle and index ledger

The genuine twist has three independently constructed effective zero-cycles:

| source | degree | effective | exact role |
|---|---:|---|---|
| general linear section | 3 | yes | universal cubic intersection |
| maximal-`A5` reduction | 11 | yes | an actual point after the prime-degree extension `E^A5/K`, pushed forward to a degree-11 cycle |
| `D12` line orbit plus general hyperplane | 55 | yes | genuine closed point over `E^D12` |

Therefore

\[
4H_3-Z_{11}
\]

is a signed zero-cycle of degree

\[
4\cdot3-11=1,
\]

and `ind(X_Schur)=1`.  The negative coefficient of `Z11` is not effective,
so this shorter identity is still not a rational point.  The earlier identity
`Z55-18H3` remains valid.

The degree-11 construction is functorial.  For either maximal `A5` subgroup
`H`, the exact landing map makes the full twist soluble after
`L=E^H`, where `[L:K]=11`.  Pushing the resulting `L`-point forward gives
`Z11`.  Since 11 is prime, this says more precisely that the twist has either
a `K`-point or a closed point of exact degree 11; the packet does not decide
which alternative occurs.

The child `degree11_secant_descent_agent/` tests six explicit transferred
cycles.
For each, the four quadrics through its eleven points cut a length-16 complete
intersection.  Intersecting that base with the Klein cubic recovers exactly
the reduced length-11 orbit, so the linked length-five residual supplies no
new point on the cubic.  Pairwise secants instead give a second degree-55
orbit `R55` and the exact relation

\[
10[Z_{11}]+[R_{55}]=55H_3\quad\text{in }CH_0(X).
\]

This relation is also signed when solved for either cycle and does not identify
`R55` with the installed line-supported `Z55`.

The immutable machine records are `imports/q0_ledger.json` and
`imports/zero_cycle_payload.json`.  They also record the larger Sylow-orbit
degrees `60,132,165,220` and the earlier signed identity
`-13*60+3*132+165+220=1`.

## Consequences and nonconsequences

- The elementary, Picard-torsor, relative Brauer, higher Amitsur, and
  commutative restriction--corestriction base-kernel mechanisms vanish.
- A degree-one class in `CH_0` or a signed degree-one cycle is not an
  effective degree-one point.
- Failure of sections on period-index-three genus-one fibrations does not
  imply the total threefold is pointless.
- Any negative proof must survive index one and the honest degree-3,
  degree-11, and degree-55 point fields.

Thus the usual index obstruction is exhausted and cannot be reused as a
headline.
