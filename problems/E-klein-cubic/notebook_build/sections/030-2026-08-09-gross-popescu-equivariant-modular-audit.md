<!-- GP-EQUIVARIANT-MODULI-BEGIN -->
## 2026-08-09 Gross--Popescu equivariant modular audit

Packet: `goal_runs_20260809/GROSS_POPESCU_EQUIVARIANT_MODULI/`.
The separately landed dated supplement
`NOTEBOOK_DEGREE25_MARKED_ELLIPTIC_EXTENSION_20260809.md` remains part of the
August 9 research record.

**Headline status: OPEN.**  The audit identifies the natural level symmetry
but supplies no bridge to the standard regular Klein action.

### Natural group and equivariant model

Change of canonical level marking gives an `SL2(F11)` action on the marking
stack.  Its exact ineffective kernel is `{+I,-I}`: `-I` is 2-isomorphic to
the identity via `[-1]_A`.  The effective coarse group is
`G=PSL2(F11)`, acting faithfully and generically freely; the generic
forgetful degree is `1320/2=660`, and

```text
C(A_11^lev)^G = C(A_11).
```

Gross--Popescu's `Theta_11` is functorially equivariant: marking change
transports `H^0(I_A(2))` and its Heisenberg multiplicity plane by the even
Weil representation.  The projected Gross--Popescu basis and repository
cosine basis differ by `diag(1,2,2,2,2,2)`.  Their equations become

```text
2p23+p15=0,  2p26-p13=0,  p14+2p35=0,
p16-2p45=0,  2p46+p12=0,
```

and the exact `Q(zeta_11)` verifier identifies the same invariant `10'`
summand used by `FIX_IX_SEAL`.  Hence `A_11^lev ~_G V14` for the natural
effective level action.

Exits: `GP-NATURAL-PSL2-ACTION-PASS`, `GP-THETA11-G-EQUIVARIANT`, and
`GP-MODULI-EQUIVARIANTLY-BIRATIONAL-V14`.

### Negative theorem for the modular action

The sealed `V14` involution fixed locus is a smooth genus-one sextic plus two
points, and `V14^{D12}` is empty.  The all-degree centralizer obstruction on
the smooth projective `V14` compactification proves that the natural modular
action is not `G`-unirational and is not weakly versal.

Exit: `GP-MODULI-NON-G-UNIRATIONAL`.

### Why nothing transfers to the standard Klein action

For the hyperplane-dependent map `chi_Pi:V14 -->> K`,
`g chi_Pi = chi_{gPi} g`.  The irreducible six-dimensional Weil module has no
invariant hyperplane.  Retaining the projective/vector-bundle parameter gives
the Tschinkel--Zhang twisted stable birationality, not an equivariant map.

The universal incidence does yield controlled correspondences after cutting
the Palatini quartic by a `G`-stable divisor of degree `d`: both projection
degrees are `d`.  But `SL2(F11)` is perfect and its center acts on a degree
`d` equation by `(-1)^d`, so every such `d` is even.  Hyperplane averaging
therefore cannot produce an odd-degree zero-cycle or bridge.

Rigidity proves that the transported modular action and standard regular
Klein action are not `G`-birationally conjugate, even after an automorphism of
`G`.  The visible involution mismatch is elliptic-sextic-plus-points on
`V14` versus `E_sigma disjoint union L_sigma` with a rational fixed line on
the standard Klein cubic.

Exit: `GP-MODULAR-ACTION-IS-V14-NOT-KLEIN`.

Not claimed: `GP-BRIDGE-KLEIN-NONUNIRATIONAL`,
`KLEIN-PSL2(11)-NONUNIRATIONAL`, or
`GP-BRIDGE-KLEIN-HEADLINE-POSITIVE`.
<!-- GP-EQUIVARIANT-MODULI-END -->
