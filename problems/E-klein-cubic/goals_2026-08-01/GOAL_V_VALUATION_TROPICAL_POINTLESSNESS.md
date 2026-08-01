# Goal V — find a decisive valuation of the genuine generic twist

**Repository:** `mattrobball/unirational`  
**Pinned mathematical baseline:** `715faf441289e2589b9325311b6613ea0331bf88`  
**Problem:** PSL\((2,11)\)-unirationality of the Klein cubic threefold  
**Worker role:** autonomous arithmetic-geometry/CAS worker in goal mode  
**Priority tier:** serious independent negative route  
**Permitted headline direction:** negative  
**Current headline:** **OPEN**

## 0. Mission

Prove the genuine generic Klein twist pointless by finding a discrete or higher-rank valuation of its invariant field at which every hypothetical rational point has impossible reduction. The target-branch route studies one highly developed valuation. This route searches systematically for a simpler decisive valuation, possibly visible through Newton polytopes, tropicalization, invariant-coordinate boundary divisors, or subgroup-adapted degenerations.

A valuation of an auxiliary fixed-frame model reaches the headline only after proving the model and field are point-equivalent to the genuine generic twist on the chosen valuation.

## 1. Binding current state

1. The fixed-frame cubic over \(F=\mathbf C(A,B,Y,Z)\) has index three.
2. The genuine field extension \(K_{\rm proj}/F\) has degree six and can split the visible index obstruction; pointlessness over \(K_{\rm proj}\) remains open.
3. A multiplicity-one residue-degree-one target branch is the current leading negative valuation, but normalization and horizontal `Cl/Pic mod 3` remain unresolved.
4. Many line/slice valuations and bounded formal expansions have been computed, but no exhaustive valuation theorem exists.
5. The exact invariant generators, primitive sextic cover, discriminant factors, monodromy, and several subgroup fixed degenerations are installed.

## 2. Exact target

Find a valuation \(v\) of the actual generic field \(K\) and a proper regular/semistable model \(\mathcal X\) of the generic twist over the valuation ring such that one of the following is proved:

- every component of the special fibre has multiplicity divisible by three, so the generic fibre has index divisible by three;
- the specialization map on zero-cycles forces degree subgroup \(3\mathbf Z\);
- the residue variety has no point/degree-prime-to-three zero-cycle and ramification preserves that obstruction;
- a tropical or Newton-polytope obstruction proves no valued-field solution exists;
- a Brauer or unramified residue evaluates nontrivially on every possible section.

Then use properness and the generic-twist bridge to conclude non-\(G\)-unirationality.

## 3. Work packages

### V0 — valuation census

Enumerate natural valuations arising from:

- irreducible divisors of the invariant quotient;
- discriminant and branch divisors of \(K_{\rm proj}/F\);
- coordinate/invariant boundary divisors \(f_d=0\);
- maximal-subgroup quotient divisors;
- weighted monomial valuations of the exact fixed-frame equation;
- exceptional divisors in toroidal resolutions of the coefficient map.

Rank them by residue degree, ramification, simplicity of the reduced cubic, and likelihood that the index-three obstruction survives.

### V1 — tropical/Newton analysis

For promising monomial or higher-rank valuations:

1. compute valuations of every coefficient of the genuine twist after exact Hilbert-90 descent;
2. determine the tropical hypersurface and possible valuation vectors of a point;
3. analyze all initial forms, including boundary charts;
4. prove that every initial degeneration is pointless or forces incompatible residue equations.

A tropical nonintersection must account for projective scaling and all coordinate charts.

### V2 — semistable models and multiplicity index

Construct a proper model after finite blowups/base changes. Compute:

- irreducible components and multiplicities of the special fibre;
- residue fields and incidence complex;
- component indices and specialization of zero-cycles;
- effects of the degree-six extension and its ramification.

Use an exact index specialization theorem. A special fibre with no rational point is not enough if a degree-one zero-cycle can specialize across components.

### V3 — exhaustive point reduction

Assume a \(K_v\)-point and derive its reduction. Use Hensel/Greenberg arguments to classify all possible centres and show each leads to a contradiction. Exact finite residue-field searches may be used only after a theorem proves the finite list exhaustive.

### V4 — headline bridge

Prove the valuation belongs to the genuine versal field and that local pointlessness implies generic pointlessness. Record all open-set and specialization hypotheses.

## 4. Exits

```text
V-VALUATION-HEADLINE-NEGATIVE
V-NEW-INDEX3-DIVISOR-STRUCTURAL
V-ALL-NATURAL-VALUATIONS-SURVIVE
V-UNDECIDED
```

## 5. Prohibitions

1. A pointless special fibre alone does not imply a pointless generic fibre.
2. Do not ignore component multiplicities or zero-cycles across components.
3. Do not work only over \(F\) without tracking the degree-six extension to \(K_{\rm proj}\).
4. Bounded formal vanishing is not an all-orders valuation theorem.
5. Tropical arguments must cover every projective chart and cancellation possibility.
6. No Magma dependency.

## 6. Output contract

Write only under

```text
problems/E-klein-cubic/goal_runs/V_VALUATION_TROPICAL/
```

Provide `STATUS.md`, `VALUATION_CENSUS.md`, `MODEL.md`, exact component/index payloads, independent verifiers, and `SEAL.json`.