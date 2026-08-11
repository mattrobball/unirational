<!-- RT_SPLIT_AND_DICHOTOMY_20260810 -->

## 2026-08-10 RT split and restricted dichotomy: packet opened

Packet:

`goal_runs_20260810/RT_SPLIT_AND_DICHOTOMY/`

**Exit:** `RESTRICTED-DICHOTOMY-UNDECIDED`, `CLEAN-CASE-TRANSFER-UNDECIDED`,
`SUPPORT-ESCAPE-UNDECIDED`, `SXX-LOCAL-REES-UNDECIDED`.
**Headline:** Problem E remains **OPEN**.  Work in flight (PR #16 opened the
packet; branch `agent/rt-split-dichotomy-20260810`).

This packet executes the director work order implementing the ambient-Hodge
precedence note: Task 1 the restricted-graph dichotomy (intrinsic restricted
Hodge carrier versus the clean CM norm equation `u^t u = [delta]` in the
order of `Q(sqrt(-11))`, norm form `x^2+xy+3y^2`, with the mandatory sieve
consistency check against `FULL_G_SELFMAP_CLASSIFICATION` degrees before any
claim); Task 2 the clean-case transfer theorem (`S` not contained in `X`,
perverse-degree hypothesis exactly `j_0 >= 0` via Artin vanishing on the
affine complement); Task 3 point-support and free-orbit closure by
degree/orbit-size accounting on `Bs(I_A)` (660 versus refined Bezout) before
any fiber characterization; Task 4 the `S` contained in `X` local Rees model
(`P_i = h^m a_i + F b_i`, nearby-cycle specialization from the vertical to
the dominant component, validated against the two exact `V4`-equivariant
landing ideals).  Task 5 (fixed-carrier resumption) is held under the
precedence rule.  No theorem is claimed at packet creation.



## 2026-08-10 RT split, restricted dichotomy, and support-escape audit

This entry supersedes the earlier same-day packet-opened entry and all interim RT-split publication notes.

Packet: `goal_runs_20260810/RT_SPLIT_AND_DICHOTOMY/`.
Problem E remains **OPEN**.

```text
RESTRICTED-DICHOTOMY-PROVED
RESTRICTED-CARRIER-BRANCH-PROVED
RESTRICTED-CLEAN-CM-NORM-PROVED
CLEAN-CASE-TRANSFER-UNDECIDED
POINT-SUPPORT-CHARACTERIZED
SUPPORT-ESCAPE-UNDECIDED
SXX-LOCAL-REES-UNDECIDED
```

Task 1 is proved at the Hodge-module level.  Canonical unit and trace for
`pi:Gamma->X` split the unique full-support `IC_X` summand from the
proper-support complement without a chosen decomposition-theorem splitting
and without a Chow projector.  A nonzero exceptional projection gives the
intrinsic restricted condition `(AHS-Gamma)`.  In the CLEAN branch the
exceptional correction vanishes and

\[
u_\varphi^\dagger u_\varphi=\delta\operatorname{id}_V.
\]

The integral `G`-Hodge commutant is
`Z[(1+sqrt(-11))/2]`; hence every CLEAN degree is
`x^2+xy+3y^2`.  The mandatory audit passes: 2 is not represented; 3 and 5
are; the tangent-residual selfmap has only an unspecified degree `delta>=3`
and is CARRIER if that degree is not a norm; and the elliptic multiplier
`[-5]` has norm and square 25, yielding 75 in the carrier formula rather than
a threefold selfmap degree five.

Task 2 remains undecided at CT1.  Artin vanishing proves the restriction
injection exactly for `j_0>=0`, and finite normalization gives `IC` of the
dominant component plus possible proper-support summands.  But the exact
normalized toric model `I=(x,y)(x,y,t)`, with `X=(t)` and
`S=(x,y) not subset X`, has no fan cone containing both the divisor ray over
`S` and the strict-transform ray of `X`; the intervening valuation over
`S cap X` separates them.

Task 3 does not close free support.  Refined Bezout capacities are `d^2`,
`d^3`, and `d^4`.  The binding unconditional live range is `d>=31`, not
`d>=22`; a free orbit of 660 surface components is already compatible from
`d=26`, so no requested live cell dies.  Point support is characterized:
`j_0=-1` and a weight-three summand
`W_x subset H^{-1}(p^{-1}(x),IC_Y)` must contain the restricted stabilizer
representation after twist.  The fiber maps onto its target-limit image but
need not map finitely.

Task 4 proves the unit-minor local branch only.  There `I=(F,h^m)`, the
normalized Rees ray is `(m,1)`, and the dominant/vertical components meet;
the cohomological transfer is the Gysin map from `S`.  The usual `psi_h` of an
already isolated vertical block is zero, so gluing must be computed in the
total `IC` object.  The rank-one Rees fan and nonzero Gysin/IC gluing remain
open.  The criterion reproduces the exact `V4` behavior: `(v,w)` survives,
while the weak line and conic divisors with determinants `W^4-V^4` and
`u^3(v^2-w^2)` contract.

Task 5 remains held; no fixed-carrier/type-I/type-II enumeration was resumed.
The future target is exclusion of actual landing data, not the false blanket
vanishing `Hom_H(V,H^1(C))=0`.

`verify_norm_sieve.py`, `verify_degree_accounting.py`,
`verify_local_rees.py`, and `scripts/check_manifest_parity.py` all pass.  The
packet is on `agent/rt-split-dichotomy-20260810`, draft PR #18.  This notebook
revision was authored against parent head `d9bcd995bcc6b03cbdd164366f11e8175dedf696`.
