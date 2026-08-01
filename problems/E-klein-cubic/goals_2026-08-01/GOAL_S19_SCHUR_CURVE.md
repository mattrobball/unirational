# Goal S19 — construct the marked degree-19 Schur rescue curve

**Repository:** `mattrobball/unirational`  
**Pinned mathematical baseline:** `715faf441289e2589b9325311b6613ea0331bf88`  
**Problem:** PSL\((2,11)\)-unirationality of the Klein cubic threefold  
**Worker role:** autonomous theorem/CAS worker in goal mode  
**Priority tier:** serious secondary route  
**Permitted headline direction:** positive only  
**Current headline:** **OPEN**

## 0. Mission

Construct a qualifying geometrically integral degree-19 rational curve on the generic Schur twist through the certified degree-55 marked orbit point. Use the audited residual-degree-two argument to obtain a rational point of the generic Schur twist and complete `BR-SCHUR19-POS`, proving \(G\)-unirationality of the Klein cubic.

Emptiness of the selected marked Hilbert component kills only this construction. It is not a negative headline theorem.

## 1. Binding current state

Consume the current Schur packets, especially:

```text
problems/E-klein-cubic/HANDOFF.md
problems/E-klein-cubic/CURRENT_PATHS.md
problems/E-klein-cubic/REPAIR.md
problems/E-klein-cubic/certificates/schur_degree19/
problems/E-klein-cubic/certificates/schur_krylov/
```

The following are established at the pinned baseline.

1. The generic Schur twist has a genuine closed point of degree 55 and index one, but no rational point is currently known.
2. The implication chain `BR-SCHUR19-POS` is audited: a qualifying degree-19 curve through the marked point leaves a residual cycle of degree two, and the residual-line argument produces a rational point over the correct field.
3. For a selected descended hyperplane point, all integral ACM degree-19 curves are excluded.
4. Two non-ACM Rao branches remain. A smooth rational survivor has Rao dimensions
   \[
   (0,16,29,38,42,40+\epsilon),\qquad \epsilon\in\{0,1\}.
   \]
5. In the \(\epsilon=1\) branch there is a unique quintic carrier of the form `f5+f3*q`; the associated `(3,5)` curve has degree 15 and genus 31. Standard very-general Picard theorems do not control the special carrier selected by the unknown curve.
6. The abstract degree-55 algebra/marked point interface is installed, but expanded generic coordinates needed for the Krylov emptiness attack are not fully installed. A negative result there would be scoped only.

## 2. Exact target

Over the correct invariant field \(F=K_{\rm Schur}\), construct a curve

\[
C\subset X_F\cap M
\]

satisfying all of:

- \(C\) is \(F\)-defined, geometrically integral, and rational;
- \(\deg C=19\) in the specified projective embedding;
- \(C\) contains the certified degree-55 marked point/orbit scheme \(Z\) in the required semilinear sense;
- \(C\) lies in the exact hyperplane/ambient section required by the audited implication chain;
- the residual intersection is degree two over \(F\), and the residual line is genuine and defined over \(F\);
- all open and smoothness conditions of `BR-SCHUR19-POS` hold.

A curve over \(\bar F\), a point on a special hyperplane not descending to the generic field, or a curve with the wrong marked scheme does not complete the route.

## 3. Work packages

### S0 — re-audit the positive bridge

Write a concise ledger proving every arrow from a qualifying curve to a rational point of the generic Schur twist, including:

- field of definition of the marked point and curve;
- degree and scheme structure of the residual intersection;
- nonvanishing of the residual line;
- passage from an odd-degree/degree-two residual configuration to an \(F\)-point;
- final comparison of the Schur generic twist with the accepted versal twist.

If an arrow has an unstated hypothesis, repair it before running the Hilbert computation.

### S1 — universal marked 55-point scheme

Over the exact split representation:

1. enumerate the 55 \(D_{12}\)-lines \(\ell_i=\mathbf P\langle a_i,b_i\rangle\);
2. introduce universal hyperplane parameters \(h\);
3. form
   \[
   p_i(h)=h(b_i)a_i-h(a_i)b_i;
   \]
4. construct the relative 55-point scheme \(Z_h\subset\mathbf P^3\) on the good-hyperplane open;
5. prove its Hilbert function and semilinear descent data on a dense open;
6. install exact equations over \(F\), not merely split-field coordinates.

### S2 — construct the two live marked Hilbert/Quot components

For each Rao branch:

1. build a finite presentation of the saturated ideal or Rao module with the 55 marked-point conditions;
2. construct the corresponding marked Hilbert or Quot scheme over \(F\);
3. compute expected and actual tangent-obstruction spaces;
4. separate geometrically integral rational curves from reducible, nonreduced, or wrong-genus components;
5. prove dominance or non-dominance over the hyperplane parameter space.

Use liaison, monads, Beilinson tables, and the special `(3,5)` carrier geometry to avoid a raw coefficient elimination.

### S3 — special-carrier Picard and liaison analysis

For the \(\epsilon=1\) branch, determine the Picard group of the actual special quintic carrier selected by a hypothetical curve, not a very-general replacement. Prove one of:

- the class of a degree-19 rational curve exists and construct it;
- the class is impossible on every carrier in the marked family;
- the family reduces to a finite explicit divisor/extension problem.

For the \(\epsilon=0\) branch, produce an analogous exact geometric classification of possible carriers and residual liaison data.

### S4 — construct and verify a curve

If a component survives:

1. produce an exact \(F\)-rational point of the marked Hilbert component;
2. write the saturated ideal of \(C\);
3. verify degree, Hilbert polynomial, genus, geometric integrality, and rationality;
4. verify the marked-point incidence and every original equation of the Schur twist;
5. compute the residual degree-two cycle and execute the bridge from S0.

A modular or \(p\)-adic Hilbert point must be lifted exactly and checked by substitution.

## 4. Exits

### Headline success

```text
S19-CURVE-HEADLINE-POSITIVE
```

Required: exact curve, exact marked incidence, exact residual cycle, full `BR-SCHUR19-POS` proof, and independent verifier.

### Scoped route closure

```text
S19-NO-CURVE-SCOPED
```

Use only after exact emptiness of both marked branches over the generic field. State explicitly that the headline remains open.

### Special-locus result

```text
S19-SPECIAL-HYPERPLANE
```

Use when curves exist only over a proper hyperplane locus. Record equations, descent fields, and why the locus does or does not meet the generic point.

### Honest stop

```text
S19-UNDECIDED
```

Name the smallest remaining marked Hilbert/Quot/Picard problem.

## 5. Prohibitions

1. Emptiness of this construction is not non-unirationality.
2. Do not replace the special carrier by a very-general carrier.
3. Do not promote a geometric curve over \(\bar F\) without descent.
4. Do not use the abstract degree-55 algebra as if expanded generic coordinates were installed.
5. Every positive curve must be substituted into the original Schur equations.
6. No Magma dependency.

## 6. Output contract

Write only under

```text
problems/E-klein-cubic/goal_runs/S19_SCHUR_CURVE/
```

Provide `STATUS.md`, `BRIDGE.md`, `HILBERT_COMPONENTS.md`, exact curve or emptiness payloads, producers, an independent verifier, and `SEAL.json`.