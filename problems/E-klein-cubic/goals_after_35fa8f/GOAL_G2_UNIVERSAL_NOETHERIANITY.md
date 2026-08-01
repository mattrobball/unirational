# Goal G2 — prove a noetherian all-degree theorem for the full transition system

**Pinned state:** `35fa8f59b6a1423cc89300aeaceefe91552be5ba`  
**Priority:** 7  
**Possible headline directions:** negative or positive

## Mission

Construct the correct finite-type multigraded object whose fibres are the complete nonlinear landing supports for all polynomial degrees and symbolic plane orders. Prove finite generation, periodicity, or another effective all-degree reduction; then decide the resulting finite problem or algebraize a surviving family.

No degree ladder may replace the structural theorem. The August COV calculation is useful regression data: selected higher plane orders can vanish globally even when local formal families exist, while `m=1` remains live.

## Required universal object

The object must retain:

- degree `d` and symbolic plane order `m` as separate gradings;
- the 55 plus-plane symbolic powers;
- `V4` triple-line equalizers and multiple-point kernels;
- source minus-line, exceptional normal-direction, and target minus-line as distinct objects;
- `C3`, `C6`, `A4`, `D10`, and `D12` links;
- type-I/type-II elliptic markings;
- finite irrelevant torsion and the difference between sheaf sections and literal graded pieces;
- one global coefficient vector;
- the full nonlinear equation `F(p)=0`.

## Work packages

### G2.0 — prove correctness of the multigraded model

Build a multigraded Rees/equalizer algebra, coherent sheaf on an iterated blowup stack, or equivalent finite-type construction. Prove that every `(m,d)` fibre recovers the existing local modules, specialization maps, and global coefficient conditions.

The false short Cech complex and ordinary powers of the union ideal are prohibited.

### G2.1 — finite generation or a counterexample

Prove one of:

1. finite generation of the full equalizer module and nonlinear obstruction ideal over a finitely generated semigroup algebra;
2. eventual quasi-polynomial/periodic behaviour with an effective exceptional range;
3. representation stability with an effective bound;
4. a structural recurrence closing the full equalizer/Fitting layers;
5. a theorem showing the proposed grading is not noetherian, followed by a corrected object.

Finite generation of the free plane module alone does not count.

### G2.2 — effective finite reduction

Produce an explicit finite list of generators, residue classes, or bidegrees whose support decides all degrees. Prove that scalar invariant multiplication, quartic precomposition, and primitive reduction are correctly represented.

Use the exact COV results at `(25,3)`, `(31,5)`, and `(35,5)` and the P25 state as regressions, not as the theorem.

### G2.3 — decide or algebraize

#### Negative

Prove every finite generator and exceptional fibre has empty nonlinear support, and invoke the accepted exhaustive covariant reduction.

#### Positive

Construct one exact compatible point, recover its global coefficient vector, verify `F(p)=0`, and prove the projective Jacobian has rank four.

## Exits

```text
G2-ALL-DEGREE-EMPTY-HEADLINE-NEGATIVE
G2-COVARIANT-HEADLINE-POSITIVE
G2-FINITE-GENERATION-PASS
G2-GRADING-REFUTED-AND-REPAIRED
G2-UNDECIDED
```

## Output contract

Write under

```text
problems/E-klein-cubic/goal_runs_after_35fa/G_UNIVERSAL/
```

Provide `UNIVERSAL_OBJECT.md`, proofs/payloads for fibre recovery and noetherianity, an effective bound, the finite decision packet, independent verifiers, and `SEAL.json`.