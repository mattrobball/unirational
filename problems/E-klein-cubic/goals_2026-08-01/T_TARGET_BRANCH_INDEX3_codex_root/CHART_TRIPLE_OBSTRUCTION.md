# T1 chart theorem — all ten raw derivative triples fail

## Theorem

Fix the parameter/fibre split

```text
(A,u ; B,Y,Z)
```

and let the full fold-singular ideal be

```text
I_sing=(P,P_u,P_A,P_B,P_Y,P_Z).
```

For every three-element subset `T` of

```text
(P_u,P_A,P_B,P_Y,P_Z),
```

the Delta-open zero scheme of `T`, even after every named fold gate is
inverted, strictly contains the full singular scheme after base change to
characteristic zero.  Therefore none of these ten raw triples is a valid T1
local chart for the coordinate pair `(A,u;B,Y,Z)`.

## Exact proof

For each triple the payload gives integers `A0,u0` and a point
`(B0,Y0,Z0)` over `F_101` such that:

1. all three equations in `T` vanish;
2. the determinant of their Jacobian in `(B,Y,Z)` is nonzero;
3. `P` is nonzero;
4. `ell,C,P_uu,delta,G` and the installed factors used to evaluate `G` are
   all nonzero.

The independent verifier recomputes these facts termwise from the sealed
1,593-term primitive and gate TSVs.  Put

```text
A=A0+s,  u=u0+t
```

in the complete local ring `R=Z_101[[s,t]]`.  Apply nonsingular multivariate
Hensel (equivalently, the formal implicit-function theorem) to the three
equations over `R`.  The invertible Jacobian gives a unique lift

```text
(B_hat,Y_hat,Z_hat) in R^3.
```

Every polynomial nonzero modulo the maximal ideal `(101,s,t)` remains an
`R`-unit at the lift.  In
particular `P(B_hat,Y_hat,Z_hat) != 0`, while the selected triple vanishes and
all localizing gates are units.  Thus the lifted point over `Frac(R)` lies on
the localized triple but not on `V(I_sing)`.  The map

```text
Q(A,u) -> Frac(R),  A |-> A0+s,  u |-> u0+t
```

is injective because `s,t` are algebraically independent.  Hence any
localized ideal equality over `Q(A,u)` would persist under this base change,
which is impossible.

A triple containing `P` cannot supply the required chart minor at a full
critical point: the `(B,Y,Z)` row of its Jacobian is
`(P_B,P_Y,P_Z)=(0,0,0)` there.  Hence the ten triples above exhaust raw
three-subsets of the six named singular generators for this coordinate pair.

## Scope

This closes only the raw-subset chart variant.  It does not exclude:

- suitable polynomial linear combinations of the six generators;
- a different parameter/fibre coordinate pair;
- the direct full six-generator finite algebra over `Q(A,u)`;
- direct normalization of the target branch.

It is nevertheless stronger than a bounded cofactor search: the obstruction
is an actual two-parameter characteristic-zero formal point over
`Frac(Z_101[[s,t]])` for every candidate raw triple.

## Replay

```sh
/opt/homebrew/bin/python3 T_TARGET_BRANCH_INDEX3_codex_root/screen_all_chart_triples.py
/opt/homebrew/bin/python3 T_TARGET_BRANCH_INDEX3_codex_root/produce_chart_triple_obstructions.py
/opt/homebrew/bin/python3 T_TARGET_BRANCH_INDEX3_codex_root/verify_chart_triple_obstructions.py
```

Expected terminal markers:

```text
ALL_CHART_TRIPLES_SCREEN_COMPLETE
CHART_TRIPLE_OBSTRUCTION_PRODUCER_SEALED
CHART_TRIPLE_OBSTRUCTION_VERIFIER_ACCEPT
```
