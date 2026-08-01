# Goal C.2–C.4 — explicit projector, Morita model, and genuine common line

**Pinned state:** `35fa8f59b6a1423cc89300aeaceefe91552be5ba`  
**Priority:** 3  
**Possible headline direction:** positive

## Mission

Consume the exact lazy compressed algebra, involution, and distinguished five-plane already produced, construct an explicit exact Morita/quaternion realization, and solve the five simultaneous isotropy equations defining the genuine twisted Fano section.

Do not spend the round reconstructing expanded `L_a` entries in a Hironaka frame. The Cramer-DAG multiplication oracle is already exact and fresh-prime verified. The remaining problem is geometric/algebraic, not interpolation bookkeeping.

## Canonical inputs pending Goal A0

The canonical merge must include:

- exact minimal polynomials of `a` and `b` and the `b^6` block;
- the rectangular basis and lazy exact multiplication interface;
- the transported symplectic involution with fixed dimensions `15/21`;
- the exact distinguished five-plane `S_j=Q(x)^{-1}Q(V_j(x))`;
- quarantine of the namespace-mutated cyclotomic RUR and any stale sibling data.

## Work packages

### C2.0 — explicit self-adjoint rank-two projector

Construct one exact sigma-self-adjoint reduced-rank-two idempotent in the specific algebra.

Preferred routes:

1. lift the correctly reconstructed length-three degree-12 auxiliary projector scheme to characteristic zero and extract an exact point;
2. parameterize the known rational projector variety using the lazy algebra and solve a low-dimensional exact chart;
3. use the auxiliary characteristic cubic plus a polynomial projector formula, with every denominator checked.

The projector is an auxiliary coordinate choice for Morita reduction. It need not lie in the distinguished five-plane, but it must be exact over `K_proj`, not merely over an uncontrolled extension.

### C2.1 — quaternion corner and Morita equivalence

From the idempotent `e`, construct

\[
D=eAe,
\qquad
A\simeq\operatorname{End}_D(D^3),
\]

and identify the induced involution as an adjoint involution. Supply:

- a four-dimensional exact basis and multiplication table/symbol for `D`;
- the right `D`-module basis of `Ae` or `eA` used in the equivalence;
- mutually inverse exact maps between the lazy rectangular algebra and `Mat_3(D)`;
- exact checks of involution compatibility and Brauer class.

A theorem valid for an arbitrary degree-six CSA is insufficient unless all maps are instantiated in the installed aligned algebra.

### C2.2 — transport the distinguished five-plane

Transport the five exact section elements to

\[
H_1,\ldots,H_5\in\operatorname{Herm}_3(D).
\]

Verify:

- each matrix is Hermitian for the correct quaternion involution;
- the five are linearly independent over `K_proj`;
- mapping them back gives exactly the installed distinguished five-plane;
- no auxiliary ambient-projector equations have replaced the Fano section.

### C3 — solve the common-line scheme

Construct the projective scheme of right `D`-lines `ell subset D^3` satisfying

\[
H_i|_\ell=0,
\qquad i=1,\ldots,5.
\]

Exploit the exact projector chart, quaternion norm, and linear/quadratic elimination before any raw solve. Acceptable methods include:

- a rational chart on the quaternionic projective plane;
- elimination after solving linear Hermitian equations;
- a fibration whose generic fibre is a conic or genus-one torsor with exact point;
- modular discovery followed by exact reconstruction and holdout checks.

A line isotropic for each form after separate field extensions is not a simultaneous `K_proj`-line.

### C4 — original Fano and headline verification

Translate a common line back to the original Plucker/Fano coordinates and verify all defining equations and open conditions. Then execute `BR-FANO-POS` through the genuine generic Klein twist and prove `G`-unirationality.

## Exits

```text
C-POINT-HEADLINE-POSITIVE
C-MORITA-MODEL-PASS
C-COMMON-LINE-SCOPED-EMPTY
C-UNDECIDED
C-CANONICAL-INPUT-FAIL
```

Emptiness of this sufficient Fano model is not a negative headline unless a new necessity theorem is separately proved.

## Output contract

Write under

```text
problems/E-klein-cubic/goal_runs_after_35fa/C_MORITA_COMMON_LINE/
```

Provide `CANONICAL_INPUTS.json`, `PROJECTOR.md`, `MORITA_MODEL.md`, `HERMITIAN_FORMS.md`, `POINT.md`, exact payloads, independent verifiers, and `SEAL.json`.