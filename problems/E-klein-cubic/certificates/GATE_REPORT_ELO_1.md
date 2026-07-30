# Director gate report — Elo ten-path order, first cycle

**Author:** director session.
**Date:** 2026-07-30.
**Order:** `WORKORDER_ELO_TEN_PATHS.md`.
**Base:** `e050464`.

## Summary

All three primary paths (A, F, G — 75% of the allocated budget) advanced.
**None was obstructed, and none reached a decision exit.**  Every remaining
blocker is now either a measured resource wall or a well-posed existence
question — not an open structural mystery.

**Headline: OPEN.**  No exit from the order's decision table was reached.

| Path | Elo | Result | Marker |
|---|---:|---|---|
| A Schur–Krylov | 1607 | `A1-PASS`, A2 sealed, `A-STOP` at A3 | `SCHUR_KRYLOV_GATES_A1_A2_A3_VERIFY_OK` |
| F Fixed-frame | 1607 | F1-P chosen, F2 audit **passes**, scheme installed | `PATH_F_F1P_CONIC_ALGEBRA_INTERFACE_ACCEPT` |
| G Global state | 1554 | `G-SCOPED`: containment **FALSE** at `(1,7)` | `GLOBAL_LIFTING_DECISION_VERIFY_OK` |

## The three results

### Path A — a real theorem, then a resource wall

**`A1-PASS` is the most valuable single result of the cycle.**  Any qualifying
curve `C` with Hilbert polynomial `19t+1` is `F`-isomorphic to `P^1`:

```text
geometric integrality + p_a = 0   =>  smooth genus zero
degree-55 point                   =>  index(C) | 55
genus zero                        =>  index(C) | 2
55 odd, so gcd(55,2) = 1          =>  index 1, C(F) != empty, C ~= P^1_F
```

This converts "find a curve" into "find a rational parametrization".  Gate A2
sealed the degree-55 field algebra (presentation, multiplication matrices,
marked-point coordinates, `V_Z`), each independently verified.

Gate A3 is **formulated but stopped**: containment as rank conditions on the
`55 x 24` matrix, the 80 interpolation coefficients eliminated linearly,
`tau` and `lambda` the only nonlinear variables — but the dense residual
exceeds the 8 GiB gate before a structural variable collapse.  Floors were
recorded before elimination, as ordered.

### Path F — the bridge is sound, by explicit audit

Fork **F1-P** was chosen before computation and F1-N correctly not started.
The reasoning holds: `D_3` and `D_5` are retired, F1-N needs a new place with
an *integral homogeneous* gauge, and the `alpha_R` DAG is mixed-weight
(node 3567), so naive reduction there is invalid.

**Gate F2 passes and explicitly excludes a repeat of the auxiliary-idempotent
scope error** — the `P^2_D` / `FAIL-SCOPE` failure mode is ruled out by
construction.  That is exactly what this gate existed to check, and it did so
*before* any computation was spent.  Also proved: the exact fixed-direction
residual `c(X_*,t_1,1) = B * R_B(t_1)` with `R_B(t_1) != 0`.

What remains is existence of an `F`-point on the conic scheme.

### Path G — the machine now points constructive, not obstructive

At `(m,d) = (1,7)`, containment `G_{m,d} subseteq R_{3,m}` is **FALSE**: the
global compatible states **meet the generic-surjective open**.  The
certificate is exact and characteristic-zero, as the gate demanded — the
residual `S3`-trivial free fibre `a_triv = (0,1,1,0)` has `rank L_3 = 7` with
maximal minor `-2` on columns `(0,1,2,5,8,11,14)`, and the pure
`a_triv (x) f` based subfamily of dimension 4 has full free-fibre rank at
explicit `Q`-points of `G`.  Ledger dimensions match accepted values, so this
is not a `G-STOP`.

**Direction:** this points to **Fork G-B (construction)**.  Fork G-A is off
the table at this bidegree.  Strictly scoped: one bidegree, no all-degree
claim, no headline claim.

## Reading of the cycle

The negative program has now failed to obstruct at every level it has been
posed — finite state, linear all-order, first nonlinear stages, `Pic^0` trace
(ansatz-specific), Hodge centers (40 surviving channels), mod-3 class group
(undecided), and now the global state image, which actively **meets** the
unobstructed open.  Meanwhile both top positive routes have sound, audited
bridges and concrete remaining steps.

The evidence has been leaning positive for two cycles.  That is not a proof
and must not be reported as one — but it is a reason to weight construction
over obstruction in allocation.

## Dispatch decision

1. **Path A — structural collapse, not a bigger machine.**  A >8 GiB job is
   **not** authorized.  The order's own rule applies: no route is promoted
   because its computation is largest.  The next dispatch must find the
   variable collapse (gauge fixing, `S_3`/`D_12` isotypic block reduction,
   or elimination order exploiting the `55 x 24` structure) and only then
   re-measure.
2. **Path F — attack existence** on the installed conic scheme, using the
   traces/norms/multiplication-table formulation rather than a six-point
   solve.
3. **Path G — Fork G-B**, beginning with the cheap continuation: test
   `(1,13)` and `(3,19)` for persistence of the open meeting, and seek the
   finite-generation or periodicity theorem that any all-degree claim needs.
4. Paths B, C, H–J remain as allocated; no change without evidence.

## Boundary

No `K_proj`-point, no landing covariant, no pointless twist, no exclusion of
all landing covariants.  **Problem E remains OPEN.**
