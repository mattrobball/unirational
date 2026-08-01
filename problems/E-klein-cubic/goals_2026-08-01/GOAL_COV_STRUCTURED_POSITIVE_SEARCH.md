# Goal COV — structured search for an explicit landing covariant beyond degree 24

**Repository:** `mattrobball/unirational`  
**Pinned mathematical baseline:** `715faf441289e2589b9325311b6613ea0331bf88`  
**Problem:** PSL\((2,11)\)-unirationality of the Klein cubic threefold  
**Worker role:** autonomous invariant-theory/CAS worker in goal mode  
**Priority tier:** serious positive search route  
**Permitted headline direction:** positive  
**Current headline:** **OPEN**

## 0. Mission

Construct one exact nonzero primitive homogeneous \(G\)-equivariant self-covariant

\[
p:W\to W
\]

of degree \(d\ge25\) satisfying

\[
F(p)=0.
\]

Verify generic Jacobian rank four and invoke `BR-COV-POS` to prove \(G\)-unirationality.

This is not a blind degree ladder. The route must exploit the invariant/covariant module structure, the exact fixed-locus restrictions, the surviving normal-cone families, and composition symmetries to choose a small number of high-value structured degrees and ansätze.

## 1. Binding current state

1. Every degree \(1\le d\le24\) is excluded.
2. Degree 25 is the first unrestricted degree and has a dedicated exact support route.
3. The global transition machine identifies three surviving formal families and supplies complete local restriction modules.
4. A primitive quartic equivariant endomorphism of \(\mathbf P(W)\) exists; precomposition sends a degree-\(d\) covariant to degree \(4d\), so any positive primitive seed generates infinitely many nonprimitive solutions.
5. Formal free-fibre solutions at degrees 13, 19, and 25 do not automatically globalize, but they supply structured leading jets and coefficient patterns.
6. The invariant and self-covariant Hilbert/Molien series are computable in arbitrary degree.

## 2. Degree selection theorem

Before searching, compute the exact self-covariant and arrangement-compatible dimensions for a bounded list of degrees and rank them by:

- admissible odd plane orders \(m\);
- residual degree \(e=d-6m\) and \(D_{12}\) line modules;
- size of the global equalizer kernel;
- number of nonlinear landing equations after symmetry decomposition;
- availability of composition/factorization ansätze;
- whether the degree is primitive under known invariant and quartic operations.

Prioritize degrees that are the first representatives of new semigroup/residual classes, rather than simply \(25,26,27,\ldots\). Candidate degrees should include the first unresolved representatives of the \(e=1\), \(e=5\), and \(e\ge7\) families and any degree where Molien dimensions or character blocks jump favorably.

## 3. Work packages

### COV0 — exact global coefficient modules

For each selected degree:

1. construct a characteristic-zero basis of
   \[
   \operatorname{Hom}_G(\operatorname{Sym}^dW,W);
   \]
2. impose the exact 55-plane symbolic order, triple-line, point-link, \(C_3\), and marked-elliptic linear constraints;
3. quotient out scalar invariant multiples and compositions of known lower-degree endomorphisms to isolate primitive directions;
4. verify all dimension statements with independent character/Molien calculations and good-prime holdouts.

### COV1 — structured ansatz families

Build low-dimensional families from:

- the three surviving normal-cone families;
- Reynolds lifts of residual \(D_{12}\) binary generators;
- Koszul/syzygy constructions on the 55-plane arrangement;
- compositions and linear combinations of known invariant gradients/Hessians;
- orbit-sums supported on special monomial or weight patterns;
- deformations of formal degree-25 and high-twist trisection states.

Every ansatz must retain one global coefficient vector and exact \(G\)-equivariance. Do not patch independent local data.

### COV2 — solve landing equations blockwise

Use target/source character blocks, normal order, and invariant monomial classes to decompose

\[
F(p)=0.
\]

Apply, in order:

1. linear and bilinear elimination;
2. determinantal/rank conditions;
3. sparse homotopy or modular discovery;
4. exact rational reconstruction with holdouts;
5. final symbolic substitution.

A modular zero or formal jet is only discovery. A nonzero sample residual is not an obstruction and should not terminate a positive search.

### COV3 — exact certification

For a candidate:

- reconstruct every coefficient in the exact cyclotomic/invariant field;
- verify \(G\)-equivariance under exact generators;
- verify every coefficient of \(F(p)\) vanishes;
- remove common scalar factors and prove primitivity;
- compute generic Jacobian rank four by an exact nonzero minor;
- verify the projective map is defined on a dense open;
- apply `BR-COV-POS`.

## 4. Exits

```text
COV-EXPLICIT-HEADLINE-POSITIVE
COV-STRUCTURED-DEGREES-EMPTY-SCOPED
COV-NEW-ANSATZ-STRUCTURAL
COV-UNDECIDED
```

Empty selected degrees are scoped only. Do not call them evidence of an all-degree negative theorem without a proved structural reduction.

## 5. Prohibitions

1. No unstructured consecutive degree ladder.
2. No modular candidate without exact reconstruction and original-equation substitution.
3. No formal compatible state called a covariant.
4. Quotient scalar invariant multiples and known compositions before interpreting dimension.
5. Empty bounded searches are not a negative headline.
6. Prime 67 is never the sole decision fibre.
7. No Magma dependency.

## 6. Output contract

Write only under

```text
problems/E-klein-cubic/goal_runs/COV_STRUCTURED_SEARCH/
```

Provide `STATUS.md`, `DEGREE_RANKING.md`, one directory per selected degree, exact basis and candidate payloads, independent verifiers, and `SEAL.json`.