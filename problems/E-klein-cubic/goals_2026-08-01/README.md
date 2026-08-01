# Problem E goal-mode packets — 2026-08-01

**Repository:** `mattrobball/unirational`  
**Pinned mathematical baseline:** `715faf441289e2589b9325311b6613ea0331bf88`  
**Headline at dispatch:** **OPEN**

These files are intended for four independent goal-mode workers, one per route. Each worker must compare the current repository head with the pinned baseline before starting, absorb later path-scoped commits, and avoid overwriting another worker's output directory.

## Ranked dispatch

| Rank | File | Direction | Terminal value |
|---:|---|---|---|
| 1 | [`GOAL_T_TARGET_BRANCH_INDEX3.md`](GOAL_T_TARGET_BRANCH_INDEX3.md) | negative | prove the multiplicity-one branch retains index three, or directly prove the genuine generic twist pointless |
| 2 | [`GOAL_C_PFAFFIAN_FANO_POINT.md`](GOAL_C_PFAFFIAN_FANO_POINT.md) | positive | construct a genuine \(K_{\rm proj}\)-point of the twisted Fano section/common-line scheme |
| 3 | [`GOAL_P25_LANDING_SUPPORT.md`](GOAL_P25_LANDING_SUPPORT.md) | positive or degree-scoped negative | decide the first unrestricted degree-25 landing scheme exactly |
| 4 | [`GOAL_G_ALL_DEGREE_LIFTING.md`](GOAL_G_ALL_DEGREE_LIFTING.md) | negative or positive | prove an all-degree nonlinear landing theorem after repairing the finite-generation gap |

## Why there is no separate elementary fixed-locus packet

The exact stabilizer census and the global transition machine have already tested the direct OD16/Fermat-style mechanism on the original linear source:

- the involution plus-planes and the \(V_4\) fixed lines are forced base strata;
- the exceptional normal directions provide allowed exits;
- \(C_3\) lines are not forced base strata;
- the finite marked-state screen has global survivors;
- the linear inverse-limit module is nonzero for every odd plane order and all sufficiently large source degrees.

Thus a worker cannot reach a negative headline merely by choosing another subgroup \(H\) and inspecting the set-theoretic image of one component of \(\mathbf P(W)^H\). A new fixed-locus invariant would have to see the resolved normal-cone/centre tree — for example a functorial Albanese, Picard, Prym, or \(1\)-motive constraint — and then cut the surviving nonlinear families. That possibility is allowed as an optional strengthening inside Goal G, but it is not presently a fifth route of comparable maturity.

## Shared theorem discipline

1. **State the bridge first.** Every worker must identify the exact implication from its terminal algebraic statement to \(G\)-unirationality or non-\(G\)-unirationality before running a large computation.
2. **Distinguish headline and scoped exits.** In particular, a degree-25 exclusion is not a negative solution, and emptiness of the Pfaffian common-line model is not a negative solution without a new necessity theorem.
3. **One common open.** Gates, localizations, component selections, and normality/class-group claims must be made on one exact common open.
4. **Good reduction is not characteristic zero by assertion.** Use projectivity/properness, DVR freeness, rational reconstruction with holdouts, or another proved transfer theorem.
5. **No solver folklore.** Empty output is a failed run. On the T systems, `msolve` has returned a false characteristic-zero emptiness result; it cannot be the sole emptiness engine.
6. **Original-equation substitution.** Every positive candidate must be checked against the original Klein/Pfaffian/Fano equations and exact group generators.
7. **Independent verification.** Verifiers must recompute load-bearing ranks, normal forms, points, or class-group data. Reading a stored `true` field is not verification.
8. **Resource gates.** Record matrix dimensions, sparsity, and memory floor before any job expected to exceed 8 GiB. Stop rather than silently changing the mathematical object.
9. **No edits to sealed history.** Put new artifacts only in the route-specific `goal_runs/` directory named by the assigned file.
10. **No Magma dependency.** Use the installed exact toolchain or provide portable source for any substitute.

## Minimum return format

Each worker returns:

```text
STATUS.md       # first line is the exact exit code
THEOREM/DECISION narrative
machine-readable payload
producer scripts
independent verifier
SEAL.json       # content hashes, no timing-dependent self-hash
```

Every `STATUS.md` must record the exact repository commit consumed and the exact commit produced. If the route remains undecided, it must name the smallest remaining theorem or finite computation rather than offering a generic continuation plan.