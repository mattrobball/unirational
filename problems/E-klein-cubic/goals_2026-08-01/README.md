# Problem E all-out goal-mode packets — 2026-08-01

**Repository:** `mattrobball/unirational`  
**Pinned mathematical baseline:** `715faf441289e2589b9325311b6613ea0331bf88`  
**Headline at dispatch:** **OPEN**

This directory now contains an all-out portfolio rather than a four-worker shortlist. Each file is a self-contained goal-mode assignment with an exact theorem boundary, valid headline bridges, scoped exits, stopping rules, and an isolated output directory.

Every worker must compare the live repository head with the pinned mathematical baseline before starting, absorb later path-scoped commits relevant to its route, and never overwrite another worker's `goal_runs/` directory.

## Complete route portfolio

### Tier A — closest to a headline or a finite exact decision

| Rank | File | Direction | Exact terminal target |
|---:|---|---|---|
| 1 | [`GOAL_T_TARGET_BRANCH_INDEX3.md`](GOAL_T_TARGET_BRANCH_INDEX3.md) | negative | prove the multiplicity-one target branch retains cubic index three, or directly prove the genuine generic twist pointless |
| 2 | [`GOAL_C_PFAFFIAN_FANO_POINT.md`](GOAL_C_PFAFFIAN_FANO_POINT.md) | positive | construct a genuine \(K_{\rm proj}\)-point of the twisted Fano/common-line scheme |
| 3 | [`GOAL_P25_LANDING_SUPPORT.md`](GOAL_P25_LANDING_SUPPORT.md) | positive or degree-scoped negative | decide the first unrestricted degree-25 landing scheme exactly |
| 4 | [`GOAL_F_CONIC_INTERSECTION_ALGEBRA.md`](GOAL_F_CONIC_INTERSECTION_ALGEBRA.md) | positive | construct an \(F\)-conic whose six-point intersection algebra is \(K_{\rm proj}\) |
| 5 | [`GOAL_S19_SCHUR_CURVE.md`](GOAL_S19_SCHUR_CURVE.md) | positive | construct the marked degree-19 rational curve and execute the audited residual-degree-two bridge |

### Tier B — complete structural routes with a valid headline bridge

| Rank | File | Direction | Exact terminal target |
|---:|---|---|---|
| 6 | [`GOAL_G_ALL_DEGREE_LIFTING.md`](GOAL_G_ALL_DEGREE_LIFTING.md) | negative or positive | repair the full finite-generation gap and decide all nonlinear landing supports |
| 7 | [`GOAL_KLS_MINIMALITY_CONDUCTOR.md`](GOAL_KLS_MINIMALITY_CONDUCTOR.md) | negative | prove the missing minimality-to-discrepancy theorem and eliminate the finite conductor list |
| 8 | [`GOAL_H_SUBGROUP_TWISTS.md`](GOAL_H_SUBGROUP_TWISTS.md) | negative | make one proper-subgroup generic twist pointless, beginning with both maximal \(A_5\) classes |
| 9 | [`GOAL_Q_SCHUR_INDEX_ONE_DESCENT.md`](GOAL_Q_SCHUR_INDEX_ONE_DESCENT.md) | positive or negative | turn the genuine index-one Schur zero-cycle into a point, or prove pointlessness despite index one |
| 10 | [`GOAL_COV_STRUCTURED_POSITIVE_SEARCH.md`](GOAL_COV_STRUCTURED_POSITIVE_SEARCH.md) | positive | find an exact primitive landing covariant in a structurally selected degree beyond 24 |

### Tier C — high-risk independent geometry and obstruction routes

| Rank | File | Direction | Exact terminal target |
|---:|---|---|---|
| 11 | [`GOAL_V_VALUATION_TROPICAL_POINTLESSNESS.md`](GOAL_V_VALUATION_TROPICAL_POINTLESSNESS.md) | negative | find a simpler decisive valuation or tropical degeneration of the genuine generic twist |
| 12 | [`GOAL_M_SARKISOV_BIRATIONAL_MODELS.md`](GOAL_M_SARKISOV_BIRATIONAL_MODELS.md) | positive or negative | construct and descend a useful Sarkisov link, or prove an exhaustive rigidity theorem with a headline bridge |
| 13 | [`GOAL_J_FIXED_CENTRE_PRYM.md`](GOAL_J_FIXED_CENTRE_PRYM.md) | negative | build a resolved fixed-centre \(1\)-motive/Prym/Hodge obstruction covering every equivariant resolution |
| 14 | [`GOAL_R_RATIONAL_CURVES_ON_TWIST.md`](GOAL_R_RATIONAL_CURVES_ON_TWIST.md) | positive | construct a rational curve on the genuine generic twist through a descended Hilbert component |
| 15 | [`GOAL_D_EQUIVARIANT_DEGREE_MOTIVE.md`](GOAL_D_EQUIVARIANT_DEGREE_MOTIVE.md) | negative | find an integral equivariant degree-formula, motive, or canonical-dimension obstruction |

## Route separation and overlap

Some routes share source artifacts but have genuinely different terminal objects.

- **C versus F:** C reconstructs the specific descended algebra, involution, quaternion corner, and five-form common-line problem. F bypasses that reconstruction and attacks the exact degree-six intersection algebra of a conic with the fixed-frame cubic.
- **S19 versus Q versus R:** S19 is one tightly audited marked degree-19 construction. Q attacks the full index-one Schur twist by any zero-cycle descent or pointlessness invariant. R attacks Hilbert schemes of rational curves on the genuine twist directly.
- **T versus V:** T develops the known multiplicity-one branch and its `Cl/Pic mod 3`. V searches for a different valuation or degeneration with a simpler index obstruction.
- **P25 versus COV versus G:** P25 decides one exact degree. COV seeks a positive seed in a few structurally chosen higher degrees. G is the only covariant route authorized to claim an all-degree negative theorem.
- **J versus D:** J follows fixed components, blowup centres, Albanese/Prym factors, and polarized Hodge structures. D seeks integral degree-formula, motive, Chow, cobordism, or quotient-stack invariants.
- **M:** may consume output from C, Q, R, or H, but must construct an actual birational link and run the two-ray game rather than restating those routes.

## Status of elementary fixed-locus obstruction

The direct OD16/Fermat-style mechanism on the original linear source has been systematically tested:

- involution plus-planes and \(V_4\) fixed lines are forced base strata;
- exceptional normal directions provide allowed exits;
- \(C_3\) lines are not forced base strata;
- the finite marked-state screen has global survivors;
- the linear inverse-limit module is nonzero for every odd plane order and all sufficiently large source degrees.

Thus no worker should merely choose another subgroup and inspect the set-theoretic image of one component of \(\mathbf P(W)^H\). Route H studies **generic subgroup twists**, which has a separate headline bridge. Route J studies a genuinely stronger resolved-centre invariant. Route G may incorporate a fixed-centre invariant only after converting it into an exact constraint on the live nonlinear families.

## Suggested all-out concurrency

The repository paths are separated so all 15 workers may reason concurrently. Heavy computations still require resource coordination.

- **Likely heavy CAS:** T, P25, C, S19, F, COV.
- **Primarily theorem-first before large CAS:** G, KLS, J, D, M.
- **Moderate independent arithmetic:** H, Q, V, R.

Do not let multiple workers launch unrelated \(>8\) GiB jobs simultaneously without an external resource scheduler. A worker that cannot establish a credible matrix/resource floor must stop rather than reserve the heavy slot indefinitely.

## Shared theorem discipline

1. **State the bridge first.** Identify the exact implication from the terminal algebraic statement to \(G\)-unirationality or non-\(G\)-unirationality before a large computation.
2. **Distinguish headline and scoped exits.** A finite-degree exclusion, a failed Hilbert construction, or emptiness of a merely sufficient positive model is not a negative solution.
3. **Use one common open.** Gates, localizations, component selections, normalization, and class-group claims must be made on one exact common open.
4. **Good reduction is not characteristic zero by assertion.** Use projectivity/properness, DVR freeness, rational reconstruction with holdouts, Hensel plus exact algebraization, or another proved transfer theorem.
5. **No solver folklore.** Empty output is a failed run. On the T systems, `msolve` has returned a false characteristic-zero emptiness result and cannot be the sole emptiness engine.
6. **Substitute into original equations.** Every positive point, curve, conic, common line, or covariant must be checked in the original Klein/Pfaffian/Fano/Schur equations and under the exact group generators.
7. **Independent verification.** Verifiers must recompute load-bearing ranks, normal forms, points, divisors, or class-group data. Reading stored booleans is not verification.
8. **Record resource floors first.** Give dimensions, sparsity, and expected memory before any job expected to exceed 8 GiB.
9. **Do not edit sealed history.** Put new artifacts only in the route-specific `goal_runs/` directory named by the assignment.
10. **No Magma dependency.** Use the installed exact toolchain or provide portable source for a substitute.
11. **No silent weakening.** A worker may prove a scoped theorem, but `STATUS.md` must use the scoped exit specified in its file.
12. **Counterexamples are valuable exits.** If the route's proposed bridge or structural theorem is false, produce and certify the counterexample rather than forcing the route forward.

## Minimum return format

Each worker returns:

```text
STATUS.md       # first line is the exact exit code
THEOREM / DECISION narrative
machine-readable payload
producer scripts
independent verifier
SEAL.json       # content hashes, no timing-dependent self-hash
```

Every `STATUS.md` must record the exact repository commit consumed and the exact commit produced. An undecided exit must name the smallest remaining theorem or finite computation, not a generic continuation plan.