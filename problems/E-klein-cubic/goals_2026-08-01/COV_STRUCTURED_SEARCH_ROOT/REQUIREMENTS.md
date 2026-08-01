# Requirement ledger

Authoritative work order: `../GOAL_COV_STRUCTURED_POSITIVE_SEARCH.md`.

The selected residual representatives are

| degree | plane order | residual `e=d-6m` | reason |
|---:|---:|---:|---|
| 25 | 3 | 7 | first unresolved representative of the generic `e>=7` family |
| 31 | 5 | 1 | first unresolved representative of the unique all-swap family |
| 35 | 5 | 5 | first unresolved representative of the three-ledger family |

This is deliberately not a consecutive degree ladder.  The degree ranking
also records the complete self-covariant and landing-target Molien
dimensions and distinguishes characteristic-zero facts from split-fibre
diagnostics.

## Acceptance ledger

| ID | Requirement | Required evidence | Current state |
|---|---|---|---|
| D0 | bounded structured degree theorem | `DEGREE_RANKING.md`, exact Molien producer, independent character verifier | complete |
| COV0.1 | characteristic-zero self-covariant basis in every selected degree | exact Reynolds seed circuit plus dimension proof | complete: dimensions 189, 410, 637 |
| COV0.2 | exact 55-plane symbolic order and line/point/C3/elliptic constraints | direct global jet kernels and local-module comparison | complete at selected `(d,m)` scope: plane-order kernel is zero, so later constraints are vacuous |
| COV0.3 | quotient invariant multiples and known compositions | explicit subspace ranks and primitive quotient | complete at selected scope: quotient of zero module is zero |
| COV0.4 | independent Molien and good-prime holdouts | independent verifier, never prime 67 alone | complete: jets at 67/89; Molien at 199/353 |
| COV1 | structured families with one global coefficient vector | normal-cone families plus invariant/covariant and orbit-sum ansatz payloads | complete at selected scope: complete global modules zero; sparse primary-frame family separately empty |
| COV2 | blockwise landing solve | exact elimination/discovery and holdouts | complete at selected scope: linear jet elimination leaves zero parameters; sparse family exactly excluded |
| COV3 | exact certification of any candidate | exact equivariance, landing, primitivity, rank-four minor, dense-open definition, `BR-COV-POS` | not triggered: exact empty candidate payloads |
| O1 | `STATUS.md` | unconditional exit with exact scope | complete |
| O2 | one directory per selected degree | basis, constraints, candidates, verifier | complete |
| O3 | `SEAL.json` | hashes, replay, theorem boundary | complete |

The existing sparse-family theorem tests triples among the installed exact
frame covariants `x,C,D,E,K`, multiplied by primary-invariant monomials.  It
exhausts 2,988, 16,013, and 32,340 primitive triples in degrees 25, 31, and
35 respectively.  Both good holdout fibres (89 and 199) exclude every
triple by a rank-ten obstruction or a rank-nine/non-Veronese obstruction.
This is a genuine scoped theorem, but it is not COV0 and is not a headline.

## Completion boundary

The run is complete only if the final ledger supports one of the work
order's four exits at its literal scope.  In particular:

- a modular candidate is not an exact covariant;
- a formal or local state is not a global covariant;
- an empty bounded ansatz is not an all-degree theorem;
- a claimed positive exit requires an original-coordinate symbolic landing
  identity and an exact nonzero `4 x 4` Jacobian minor.
