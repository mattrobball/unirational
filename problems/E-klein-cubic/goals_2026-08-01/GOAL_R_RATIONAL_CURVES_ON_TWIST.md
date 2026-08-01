# Goal R — rational curves on the genuine generic Klein twist

**Repository:** `mattrobball/unirational`  
**Pinned mathematical baseline:** `715faf441289e2589b9325311b6613ea0331bf88`  
**Problem:** PSL\((2,11)\)-unirationality of the Klein cubic threefold  
**Worker role:** autonomous Hilbert-scheme/rational-curve worker in goal mode  
**Priority tier:** high-risk positive route  
**Permitted headline direction:** positive  
**Current headline:** **OPEN**

## 0. Mission

Construct a \(K\)-defined rational curve on the genuine generic Klein twist \(X_K\), for the correct versal invariant field \(K\). Any such curve has a \(K\)-rational generic point model and, after an exact residual/secant argument where needed, yields a \(K\)-point of \(X_K\), hence \(G\)-unirationality.

The repository has ruled out rational lines and the audited plane-conic models on the full twist, but has not exhausted twisted cubics, rational quartics, elliptic/quintic constructions with residual descent, or higher rational curves. This route attacks their Hilbert schemes directly rather than through the degree-19 Schur construction.

## 1. Binding current state

1. No rational line exists on the generic Schur/full twist in the audited model.
2. The tested plane-conic and coordinate-line fibration constructions have no section; this does not exclude all conics on all birational models or higher rational curves.
3. A degree-55 closed point and other orbit cycles are available and may be imposed as marked incidence data.
4. The Fano/Pfaffian and Schur degree-19 routes provide specific curve models but do not exhaust the Hilbert schemes of rational curves on the cubic threefold.
5. Any positive curve must be defined over the generic field, not merely over its algebraic closure.

## 2. Exact targets

Construct a curve \(C\subset X_K\) with normalization \(\mathbf P^1_K\), or a genus-zero curve of odd index that is proved to split over \(K\). Preferred degrees are the first geometrically meaningful cases not already closed:

- non-plane conics, if any remain outside the audited model;
- twisted cubics;
- rational quartics;
- rational quintics or elliptic quintics with a residual point construction;
- rational curves forced through a controlled part of the degree-55 orbit.

The final proof must produce an actual \(K\)-point of \(X_K\) and invoke the generic-twist bridge.

## 3. Work packages

### R0 — Hilbert-scheme inventory

For degrees \(2\le e\le e_0\) with a justified bound/ranking:

1. describe the relevant Hilbert components over \(\bar K\);
2. compute dimensions, smoothness, rationality/unirationality, and Abel–Jacobi maps;
3. determine the Galois/twist action on components;
4. identify components whose twists have low-dimensional torsor descriptions;
5. eliminate components already ruled out by line/conic packets.

Use known geometry of rational curves on cubic threefolds but verify hypotheses for the generic twist.

### R1 — descend a Hilbert point

For each promising component, compute its twisted form over \(K\). Seek a \(K\)-point using:

- rationality of the component;
- zero-cycles of coprime degree;
- torsors under Jacobian/Prym varieties;
- incidence with the known degree-55 orbit;
- explicit equations and exact point search;
- rational connectedness plus a valid function-field theorem when applicable.

A \(K\)-point of the Hilbert scheme must be shown to represent a geometrically integral curve, not a reducible cycle.

### R2 — marked incidence and residual constructions

Impose selected orbit points or low-degree cycles to reduce the component dimension. Compute residual intersections with hyperplanes, quadrics, scrolls, or surfaces and use third-intersection/secant operations to obtain a \(K\)-point.

The residual scheme and its field of definition must be computed exactly.

### R3 — exact curve and point verification

For a candidate:

- write its saturated ideal over \(K\);
- verify containment in the original generic twist;
- verify Hilbert polynomial, geometric integrality, normalization, and genus zero;
- construct an explicit \(K\)-point or rational parameterization;
- apply the versal positive bridge.

## 4. Exits

```text
R-RATIONAL-CURVE-HEADLINE-POSITIVE
R-HILBERT-COMPONENT-STRUCTURAL
R-LOW-DEGREE-CURVES-EMPTY-SCOPED
R-UNDECIDED
```

Low-degree emptiness is scoped only and is not a negative headline.

## 5. Prohibitions

1. Do not infer a \(K\)-curve from a Galois-stable geometric component without descent.
2. A Hilbert point representing a reducible cycle is not a rational curve.
3. Failure of lines and plane conics is not exhaustion of rational curves.
4. Do not claim a genus-zero curve has a \(K\)-point without controlling its index.
5. Every curve and residual point must be checked in the original twist.
6. No Magma dependency.

## 6. Output contract

Write only under

```text
problems/E-klein-cubic/goal_runs/R_RATIONAL_CURVES/
```

Provide `STATUS.md`, `HILBERT_INVENTORY.md`, exact component/curve payloads, producers, an independent verifier, and `SEAL.json`.