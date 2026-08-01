# Exact zero-cycle and index ledger

The genuine twist has two effective zero-cycles of coprime degrees:

| source | degree | effective | exact role |
|---|---:|---|---|
| general linear section | 3 | yes | universal cubic intersection |
| `D12` line orbit plus general hyperplane | 55 | yes | genuine closed point over `E^D12` |

Therefore

\[
Z_{55}-18H_3
\]

is a signed zero-cycle of degree

\[
55-18\cdot3=1,
\]

and `ind(X_Schur)=1`.  The signed coefficient `-18` is not effective, so
this identity is not a rational point.

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
- Any negative proof must survive index one and the honest degree-3 and
  degree-55 point fields.

Thus the usual index obstruction is exhausted and cannot be reused as a
headline.
