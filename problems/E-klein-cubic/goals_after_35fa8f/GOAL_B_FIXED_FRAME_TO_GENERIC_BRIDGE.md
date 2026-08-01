# Goal B — promote or refute the fixed-frame pointlessness bridge

**Pinned state:** `35fa8f59b6a1423cc89300aeaceefe91552be5ba`  
**Priority:** 1  
**Possible headline direction:** negative  
**Primary input:** `goals_2026-08-01/F_CONIC_ALGEBRA/`

## Mission

The conic worker proves exactly that the installed fixed-frame plane cubic satisfies

\[
C(K_{\rm proj})=\varnothing.
\]

Determine whether this theorem implies pointlessness of the genuine versal Klein twist, pointlessness of the genuine twisted Fano section, or neither. A valid bridge would immediately convert the strongest new scoped theorem into a negative headline. A refutation must identify the precise missing moduli/gauge parameter and retire the bridge cleanly.

Do not rerun the conic search. The pointlessness theorem is an input, pending Goal A0 replay.

## Exact objects to distinguish

Write explicit functors/fields/equations for:

1. the genuine generic Klein twist over the accepted versal invariant field;
2. the twisted Fano section `F_{14,T}`;
3. the full auxiliary self-adjoint Pfaffian characteristic cubic;
4. the selected fixed ternary frame cubic `C/F`;
5. the degree-six field `K_proj/F` and its ordered embedding.

For every arrow currently used in prose, state whether it is:

- an equivalence;
- a dominant rational map;
- a sufficient construction only;
- a choice of slice not meeting every rational orbit;
- defined only after a field extension.

## Work packages

### B0 — recover the exact incidence diagram

From the Pfaffian representation alignment, Hilbert--90 frame, and five-plane data, construct the incidence relating:

- a point of the generic Klein twist;
- a point/common line of `F_{14,T}`;
- a self-adjoint rank-two projector;
- a point of the full auxiliary characteristic cubic;
- a point of the selected fixed-frame ternary cubic.

Track all quotient groups and gauge choices. A change of Morita basis over an extension is not a rational gauge over `K_proj` without descent.

### B1 — test exhaustiveness of the fixed frame

Prove one of:

1. every rational point of the relevant genuine object can be moved, by a rationally available automorphism preserving all distinguished data, into the selected ternary frame; or
2. the selected frame misses a rational orbit, with an exact counterexample or a nontrivial torsor/quotient obstruction.

The ambient rank-two projector variety is not enough: the automorphism must preserve the distinguished five-plane defining `F_{14,T}`.

### B2 — identify the infinity divisor with a versal target branch

Compare the irreducible reciprocal-leading factor `D` and its `(e,f)=(1,1)` place with the multiplicity-one target branch used by `BR-T-NEG`.

Required exact checks:

- equality or dominant birational relation of branch fields;
- compatibility of the residual cubic families;
- the same ordered residue embedding;
- proper models on one common open;
- residue-degree-one and index-three hypotheses of `BR-T-NEG`.

If the branches are the same at the theorem level, invoke the accepted negative bridge. If they are different, record the precise obstruction to transferring the index-three result.

### B3 — terminal theorem

#### Negative headline

Prove that any point of the genuine generic Klein twist would induce a point of the fixed-frame cubic or of the index-three residual branch. Combine with the exact `C(K_proj)=empty` theorem and state non-`G`-unirationality.

#### Bridge refutation

Produce a commutative diagram showing the fixed-frame condition is merely sufficient and not necessary. Identify the smallest remaining incidence/torsor whose rational point would bypass the fixed frame.

## Exits

```text
B-FIXED-FRAME-BRIDGE-HEADLINE-NEGATIVE
B-TARGET-BRANCH-IDENTIFIED-HEADLINE-NEGATIVE
B-BRIDGE-REFUTED
B-UNDECIDED
```

No headline exit is allowed from equality of dimensions, generic geometric transitivity, or an isomorphism after algebraic closure.

## Output contract

Write under

```text
problems/E-klein-cubic/goal_runs_after_35fa/B_FIXED_FRAME_BRIDGE/
```

Provide `OBJECT_DICTIONARY.md`, `INCIDENCE_DIAGRAM.md`, exact field/equation payloads, `BRIDGE_THEOREM.md` or `COUNTEREXAMPLE.md`, independent verifiers, and `SEAL.json`.