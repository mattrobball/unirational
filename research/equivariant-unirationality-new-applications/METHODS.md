# Methods and theorem boundary

## Repository machinery consumed

The audit used the following as binding inputs.

- `problems/E-klein-cubic/theory/FIX_I_bcomplex.md`: fixed-stratum and incidence bookkeeping, together with its correction against unrestricted RCC propagation.
- `problems/E-klein-cubic/theory/FIX_T_gate.md`: central fixed-locus obstruction and the surface-resolution framework.
- `problems/E-klein-cubic/goal_runs_after_691986b/FIX_T34_CENTRAL_OBSTRUCTION/`: exact Fermat del Pezzo and Fermat cubic applications.
- `problems/E-klein-cubic/theory/FIX_IX_v14.md` and the later `V14` writeup: the centerless centralizer obstruction and the controlled surviving eigenspace.
- `problems/F-dp2-psl27/RESOLUTION.md` and `certificates/WP3_ALL_DEGREE_PATH_OBSTRUCTION.md`: the all-degree exceptional-path theorem.
- later Problem-E packets recording the corrected distinction between formal fixed-network data and actual components on a resolved graph.

## Exact usable principles

### Central or centralizer survivor

For \(\sigma\in G\), each projectivized \(\sigma\)-eigenspace of a faithful linear source is rationally connected, pointwise \(\sigma\)-fixed, and stable under \(C_G(\sigma)\). A chosen survivor can be followed through a functorial equivariant resolution.

### Surface exceptional path

For a rational map from a smooth surface, the reduced local total transform over a base point is a tree. A stabilizer fixing the endpoints fixes the unique path. Birth characters force every intermediate exceptional \(\mathbf P^1\) to be pointwise fixed by some nontrivial element. If all corresponding target fixed loci contain no rational curve capable of receiving that component, endpoint values propagate to equality.

### Residual-RCC refinement

The source survivor need not contract merely because the target fixed component contains some rational curves. It contracts when the fixed component contains no residual-group-stable positive-dimensional RCC subvariety. This is proved in `GENERALIZATIONS.md` and is the decisive refinement for the smooth quartic double solid.

## Literature workflow

For each candidate the audit checked, in order:

1. an explicit equation or intrinsic action;
2. ordinary rationality or unirationality;
3. current papers on equivariant unirationality, weak versality, linearizability, stable linearizability, and birational rigidity;
4. Condition (A);
5. ordinary, higher-Amitsur, and universal-torsor obstructions where computations exist;
6. one central or centralizer element and its exact fixed locus;
7. the deeper fixed locus under the residual group;
8. rational curves or RCC subvarieties stable under that residual group;
9. the amount of new fixed-network theory and finite computation still needed.

A case is called `OPEN-CONFIRMED` only when the action was searched under its original model, its automorphism-group model, and its principal birational models, and no theorem deciding equivariant unirationality or weak versality was found. Linearizability results alone were not counted as decisions.

## Scoring

Headline feasibility is scored from 0 to 100. The largest weights are:

- 20: explicit finite group and action;
- 15: ordinary rationality/unirationality already known;
- 15: Condition (A) passes;
- 15: standard cohomological obstructions vanish or are inconclusive;
- 15: positive-genus or non-uniruled fixed geometry with an empty deeper fixed locus;
- 10: the repository theorem applies with at most a small extension;
- 5: finite exact verification burden;
- 5: literature novelty.

Cases already decided, failing Condition (A), or requiring an unresolved ordinary-unirationality theorem are strongly penalized.

## CAS discipline

Only two computations were run.

1. Smoothness, invariance, semidirect relation, and fixed points for one smooth quartic surface.
2. Squarefreeness, weighted order, genus, and reflection parity for one theorem-defined conic-bundle family.

No group sweep, degree sweep, random search, or unrestricted Gröbner computation was used.
