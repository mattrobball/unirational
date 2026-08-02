# Problem E next ten routes after 2026-08-02 audit

Headline remains OPEN. Ranked routes below prioritize routes that can actually close PSL(2,11)-unirationality.

## 1. G3 universal cubic arithmetic (Priority 0)
Type: CAS + analytic bridge

Goal: Decide whether the surviving universal covariant variety V(Phi) has a K_proj point and whether that point gives a primitive landing covariant.

CAS tasks:
- exact elimination over the projected invariant field;
- rational point search only as certificate generation;
- produce replayable algebraic certificates.

Analytic tasks:
- prove that surviving points correspond to genuine covariants and dominance.

## 2. dP-style invariant geometric obstruction replay
Type: analytic

Goal: Identify the analogue of the successful del Pezzo closure mechanism: a geometric object whose existence is equivalent to equivariant unirationality.

Targets:
- canonical torsor;
- universal family section;
- equivariant intermediate object.

## 3. C6 corrected Palatini/common-line Fano big cell
Type: analytic + CAS

Goal: Use corrected alternating-form/Plucker incidence model to construct or obstruct K_proj points.

CAS:
- exact incidence equations;
- singular locus and component computations.

Analytic:
- prove big-cell coverage.

## 4. G4 degree-11 A5 transfer
Type: analytic

Goal: Transfer exact degree-11 A5 points/twists into a PSL(2,11) projective generic twist point.

Need:
- compatibility of subgroup embeddings;
- field descent argument.

## 5. H6 11:5 trace cubic via torus isogeny
Type: CAS + analytic

Goal: Decide the genuine trace cubic using the degree-11 torus/isogeny structure.

CAS:
- explicit norm/isogeny calculations.

Analytic:
- identify whether the trace cubic point gives the required twist point.

## 6. G5 residue twist full f5/f6 analysis
Type: CAS + analytic

Goal: Resolve the remaining residue binary instead of finite proxies.

CAS:
- exact residue field calculations.

Analytic:
- prove obstruction or lifting.

## 7. Q3 primitive quartic resolvent descent
Type: analytic + CAS

Goal: Replace failed standard descent obstruction with stable cubic/resolvent descent.

CAS:
- resolvent computations.

Analytic:
- prove descent obstruction transfers to headline.

## 8. M3 residual Galois section route
Type: analytic

Goal: Determine whether residual Galois obstruction separates section from multisection.

Need:
- exact section criterion;
- compare with known Sarkisov phenomena.

## 9. Unknown-example search: equivariant cubic/Fano analogues
Type: analytic

Goal: Search literature and internal constructions for previously unknown examples where equivariant unirationality was settled by a hidden intermediate variety rather than representation covariants.

Focus:
- cubic threefolds;
- Fano varieties;
- finite simple group actions.

## 10. P25/COV exhaustive landing search
Type: CAS only initially

Goal: Finish finite landing-support computations as possible inputs to a future bridge.

Restriction:
- do not claim headline closure without characteristic-zero transfer.

---

# Worker dispatch order

1. G3 arithmetic
2. C6 geometry
3. H6 trace cubic
4. G4 transfer
5. dP-style invariant mechanism search
6. G5 residue
7. Q3 descent
8. M3 section
9. unknown-example survey
10. P25/COV finite support

Heavy CAS jobs must use local runners only; do not use GitHub Actions for CAS.
