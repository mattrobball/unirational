# Sources and dependency ledger

## Binding repository inputs

- `goal_runs_20260810/AMBIENT_HODGE_REES_BRIDGE/THEOREM.md`
- `goal_runs_20260810/AMBIENT_HODGE_REES_BRIDGE/AMBIENT_SUPPORT.md`
- `goal_runs_20260810/AMBIENT_HODGE_REES_BRIDGE/RESTRICTED_TRANSFER.md`
- `goal_runs_20260810/AMBIENT_HODGE_REES_BRIDGE/ADVERSARIAL_TESTS.md`
- `goal_runs_20260809/EXCEPTIONAL_CARRIER_RIGIDITY/THEOREM.md`
- `goal_runs_20260809/EXCEPTIONAL_CARRIER_RIGIDITY/LOCAL_REES_MODEL.md`
- `goal_runs_20260809/EXCEPTIONAL_CARRIER_RIGIDITY/AMBIENT_REES_COMPARISON.md`
- `goal_runs_20260809/FULL_G_SELFMAP_CLASSIFICATION/`
- `NOTEBOOK.md`, including the ambient-Hodge precedence note and the later
  unconditional cutoff through degree 30.

## External mathematical sources

- A. Beilinson, J. Bernstein, P. Deligne, *Faisceaux pervers*, Astérisque 100
  (1982): perverse sheaves, intermediate extension, strict supports, and the
  decomposition theorem framework.
- M. Saito, *Modules de Hodge polarisables*, Publ. RIMS 24 (1988), and
  *Mixed Hodge Modules*, Publ. RIMS 26 (1990): polarizable Hodge modules,
  weights, proper direct image, duality, and strictness.
- M. A. de Cataldo and L. Migliorini, *The Decomposition Theorem and the
  topology of algebraic maps*, Bull. AMS 46 (2009): decomposition theorem and
  perverse Leray filtration conventions.
- X. Roulleau, *The Fano surface of the Klein cubic threefold*, J. Math. Kyoto
  Univ. 49 (2009), arXiv:1001.4853: explicit period lattice of the Klein
  intermediate Jacobian and the `Z[(-1+sqrt(-11))/2]` action.
- W. Fulton, *Intersection Theory*, 2nd ed.: refined Bézout, excess
  intersection, and the Gysin calculation in the smooth rank-two local model.
- Standard toric normalization of monomial blowups: the normalized Rees fan is
  the normal fan of the Newton polyhedron; this is used only in the explicitly
  checked ideals `(x,y)(x,y,t)` and `(F,h^m)`.

## Accepted inputs not reproved here

- relatively ample splitting and injectivity of target pullback;
- irreducibility of `V` over `Q` as a `G`-module;
- Auto-CM and the `E_{-11}`-isotypic conclusion;
- PR #15 Theorems A, B, and D;
- the exact `V4` joint-residue theorem and local landing ideals;
- the selfmap-classification packet's degree-one, degree-two, and
  tangent-residual conclusions.

## Tool boundary

Load-bearing finite checks use `python3` with exact integer/polynomial
arithmetic.  No floating-point computation and no unavailable GAP, Sage,
Magma, PARI, Macaulay2, or msolve claim is used.
