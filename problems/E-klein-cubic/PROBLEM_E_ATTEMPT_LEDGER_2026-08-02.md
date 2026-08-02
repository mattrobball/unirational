# Problem E (Klein cubic, PSL(2,11)-unirationality) attempt ledger

Date: 2026-08-02
Status: HEADLINE OPEN

## Headline criterion

Decide whether the Klein cubic threefold admits a genuine PSL(2,11)-equivariant dominant rational map from a rational representation. Equivalent positive routes must produce a verified generic twist point or primitive landing covariant. Negative routes must rule out all possible characteristic-zero homogeneous self-covariants/landing mechanisms or prove the genuine generic twist pointless.

## Attempt ledger

| Attempt | State | Current conclusion | Remaining value |
|---|---|---|---|
| A0 canonical audit | TERMINAL PASS | Projection bulk data certified (4140/315) | Infrastructure only |
| A5Q / F / T/T2 / J/J2 / D/D2 / KLS/KLS2 | TERMINAL | Prior local obstructions/witnesses exhausted | Background only |
| B fixed-frame exhaustiveness | TERMINAL NEGATIVE (`B-BRIDGE-REFUTED`) | Fixed-frame bridge is false; cannot certify non-unirationality | Warns against overusing frame reductions |
| G universal object | TERMINAL STRUCTURAL PASS (`G2-FINITE-GENERATION-PASS`) | All-degree reduction achieved | Leaves arithmetic decision of surviving universal object |
| G3 universal cubic arithmetic | OPEN | Decide V(Phi)(K_proj) | Highest priority |
| V residue obstruction | PARTIAL (`V3-RESIDUE-NORMAL-FORM-PASS`) | Mechanics closed, residue binaries remain | Feeds G5/H6 |
| Q descent obstruction | PARTIAL (`Q2.1-DESCENT-OBSTRUCTION-AUDIT-PASS`) | Standard obstruction package insufficient | Q3 stable cubic/resolvent route remains |
| H11:5 trace cubic | OPEN | Need genuine degree-11 torus/isogeny decision | H6 route |
| H5 trace cubic model | PARTIAL | Model sealed but no K-point conclusion | Input to H6 |
| C5/C6 common-line Fano | OPEN | Corrected Plucker/alternating model survives | Possible geometric construction/refutation |
| M3 section vs multisection | OPEN | Multisection closed; section remains | Possible residual Galois route |
| P25 landing support | OPEN/DEFERRED | Finite chart computation only | Not headline without bridge |
| COV m=1 charts | OPEN/DEFERRED | Modular information only | Needs characteristic-zero transfer |
| T3 normalization + Cl/Pic[3] | AUXILIARY OPEN | Fixed-frame/non-headline after B | Local runner only |

## Closed dP-style lesson

The del Pezzo example closed by finding the correct equivariant obstruction mechanism rather than exhausting finite-degree witnesses. Reapply that philosophy: search for the invariant geometric object whose existence is equivalent to the headline, not merely more finite exclusions.

## Ledger rule

Finite computations, modular ranks, and formal states are not headline conclusions unless an explicit characteristic-zero geometric bridge is supplied.
