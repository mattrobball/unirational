# Goal Q — turn the generic Schur index-one zero-cycle into a point, or prove pointlessness

**Repository:** `mattrobball/unirational`  
**Pinned mathematical baseline:** `715faf441289e2589b9325311b6613ea0331bf88`  
**Problem:** PSL\((2,11)\)-unirationality of the Klein cubic threefold  
**Worker role:** autonomous theorem/CAS worker in goal mode  
**Priority tier:** serious arithmetic/geometric route  
**Permitted headline direction:** positive or negative  
**Current headline:** **OPEN**

## 0. Mission

Attack the genuine generic Schur twist directly. It has index one because the repository constructs closed points/zero-cycles of coprime degrees, but no rational point is known. Prove either:

\[
X_{\rm Schur}(K_{\rm Schur})\ne\varnothing
\]

and obtain the positive headline, or

\[
X_{\rm Schur}(K_{\rm Schur})=\varnothing
\]

with a genuine obstruction despite index one, obtaining the negative headline through the accepted generic-twist bridge.

This route is broader than the degree-19 rescue curve: it may use any exact zero-cycle descent, rational-curve, torsor, valuation, or birational construction on the full generic Schur twist.

## 1. Binding current state

1. The generic Schur twist and its exact invariant field are installed.
2. There is a genuine degree-55 closed point and enough additional orbit data to prove index one.
3. Index one has **not** been upgraded to a rational point. The repository explicitly corrects any statement claiming pointlessness was proved.
4. Ten coordinate-line genus-one fibrations have fibre-degree image \(3\mathbf Z\) and no rational section. These ten fibrations do not exhaust all rational points or all birational models.
5. The full twist has no rational line, no plane conic in the audited sense, and no regular lower-dimensional fibration among the tested models. This does not imply pointlessness.
6. The degree-19 curve route is one sound positive bridge but is not the only possible use of the degree-55 point.

## 2. Exact targets

### Positive target

Construct a \(K_{\rm Schur}\)-rational point of the full generic Schur twist and verify the accepted versal equivalence to \(G\)-unirationality.

### Negative target

Construct an invariant of rational points that can remain nontrivial when the index is one, for example:

- an elementary obstruction on a torsor under a nontrivial semiabelian variety;
- a Brauer–Manin or higher unramified obstruction over the function field, with a proved local-global implication in this setting;
- a valuation/residue obstruction at every possible specialization of a point;
- a birationally invariant torsor/Picard obstruction on an exact proper model;
- an exact failure of all rational-section possibilities in an exhaustive birational fibration classification.

The invariant must apply to the genuine twist, not only to one of the ten coordinate fibrations.

## 3. Work packages

### Q0 — exact model and zero-cycle ledger

Rebuild the generic Schur twist, invariant field, degree-55 point, and all known zero-cycles. Determine:

- their residue fields and Galois closures;
- exact rational equivalences, if any;
- whether the index-one combination is effective, signed, or supported on disjoint models;
- the Albanese/Picard torsors and elementary obstruction of the twist;
- the relationship to the ten genus-one fibrations.

### Q1 — constructive zero-cycle descent

Try to convert the coprime-degree cycles into a point using the special geometry of a cubic threefold, not a false general principle that index one implies a point. Plausible mechanisms include:

- secant and third-intersection operations on conjugate cycles;
- rational maps from symmetric powers or Hilbert schemes of points;
- descent on spaces of lines, conics, twisted cubics, or rational quartics;
- a universal torsor or Cox-coordinate parameterization;
- explicit R-equivalence chains between orbit cycles;
- a low-degree rational curve through a controlled subcycle.

Every operation must be defined over \(K_{\rm Schur}\) and checked to lower degree or produce a rational point.

### Q2 — exhaustive birational models

Classify plausible Sarkisov links or rational fibrations initiated by the known zero-cycles/marked orbits. The ten coordinate-line fibrations are not enough. Determine whether blowing up other Galois-stable zero-dimensional schemes or rational curves produces:

- a conic bundle;
- a del Pezzo fibration;
- a genus-one fibration with a section;
- a rational surface fibration;
- a birational model with an obvious rational point.

If claiming exhaustiveness, prove it through the Mori cone and Galois action.

### Q3 — pointlessness despite index one

If constructive descent fails, compute exact obstructions on a proper model. Separate:

- Picard/Albanese torsors;
- Brauer and higher unramified groups;
- zero-cycle versus point obstructions;
- valuation residues along all relevant quotient divisors.

A nontrivial class must be shown to vanish on every rational point and to survive on the generic twist. The repository's already-vanishing universal-torsor/higher-Amitsur branch must not be repackaged as a new obstruction.

### Q4 — headline bridge

For a point, verify the exact twist/versal construction and conclude positively. For pointlessness, verify that the Schur twist is genuinely generic/versal for the \(G\)-action and conclude negatively.

## 4. Exits

```text
Q-SCHUR-POINT-HEADLINE-POSITIVE
Q-SCHUR-POINTLESS-HEADLINE-NEGATIVE
Q-SCHUR-BIRATIONAL-MODEL-STRUCTURAL
Q-UNDECIDED
```

A structural exit must record a new exhaustive model or exact obstruction interface, not merely another failed point search.

## 5. Prohibitions

1. Index one is not a rational point.
2. Failure of the ten coordinate fibrations is not pointlessness.
3. Do not use a zero-cycle operation unless it descends over the invariant field.
4. Do not duplicate the known vanishing Amitsur obstruction.
5. Every positive point must be checked in the original generic Schur equation.
6. No Magma dependency.

## 6. Output contract

Write only under

```text
problems/E-klein-cubic/goal_runs/Q_SCHUR_DESCENT/
```

Provide `STATUS.md`, `ZERO_CYCLE_LEDGER.md`, `BIRATIONAL_MODELS.md`, exact point or obstruction payloads, independent verifiers, and `SEAL.json`.