# Goal P25 — decide the exact degree-25 landing scheme

**Repository:** `mattrobball/unirational`  
**Pinned mathematical baseline:** `715faf441289e2589b9325311b6613ea0331bf88`  
**Problem:** PSL\((2,11)\)-unirationality of the Klein cubic threefold  
**Worker role:** autonomous theorem/CAS worker in goal mode  
**Priority:** 3  
**Permitted headline direction:** positive; negative exit is degree-scoped only  
**Current headline:** **OPEN**

## 0. Mission

Decide whether the complete projective degree-25 landing scheme contains a characteristic-zero point. A verified point gives an actual homogeneous \(G\)-equivariant landing self-covariant and therefore a headline-positive route. Empty special fibre at the certified DVR prime gives an exact characteristic-zero exclusion in degree 25, extending the present cutoff but not proving non-\(G\)-unirationality.

The decisive object is the zero locus of the **complete** landing equations, not a sampled residual, a free-fibre tower, a lower presentation survivor, or a compressed incidence point.

## 1. Binding current state

Consume:

```text
problems/E-klein-cubic/HANDOFF.md
problems/E-klein-cubic/CURRENT_PATHS.md
problems/E-klein-cubic/REPAIR.md
problems/E-klein-cubic/WORKORDER_CAS_T11_P25V_C3.md
problems/E-klein-cubic/certificates/p25*/
```

At the pinned baseline:

1. The degree-25 arrangement-compatible coefficient space has a fixed free rank-43 DVR model at \(p=89\), with holdout behaviour at \(p=199\).
2. At \(p=89\), the direct landing row space has **exact** rank 746. This is an upper and lower bound, proved by a 2343-dimensional invariant basis and an invertible unisolvent evaluation matrix. The historical 842-row packet is retired for this purpose.
3. The monic pure-\(K^3\) border closes. Over
   \[
   S=\mathbf F_{89}[q_0,\ldots,q_{36}],
   \qquad
   F=S\oplus S(-1)^6\oplus S(-2)^{21},
   \]
   the 690 seed relations define a lower module \(F/N_0\) surjecting onto the true landing quotient. Empty support of \(F/N_0\) therefore implies empty true landing support, even before exact closure.
4. Exact degree-four closure is settled on the basis-degree-one and basis-degree-two components. The only closure gap is the pure-\(q\), basis-degree-zero membership problem.
5. The stratum \(b_0=b_1=0\) is empty: the kernel contains no nonzero rank-one \(21\times37\) tensor. This does not decide the strata with \(b_0\ne0\) or \(b_0=0,b_1\ne0\).
6. The degree-25 free-fibre lifting tower survives. Nonzero particular residuals are cancellable by later kernel freedom; they are not obstruction theorems.

## 2. Exact theorem boundary

Let \(Z_{25}\) denote the projective scheme of degree-25 \(G\)-equivariant covariants \(p\) satisfying the full identity

\[
F(p(x))=0
\]

for all \(x\in W\), after the accepted arrangement/fixed-locus reduction.

The goal is to prove one of:

### P25-P — actual covariant

Construct

\[
[p]\in Z_{25}(K)
\]

in characteristic zero, verify every global coefficient of \(F(p)\) is zero, and invoke the accepted covariant-to-\(G\)-unirationality bridge.

### P25-N — degree-25 emptiness

Prove the complete projective special fibre \(Z_{25,\mathbf F_{89}}\) is empty. Then use the sealed projective DVR/properness argument to conclude

\[
Z_{25,K}=\varnothing.
\]

This is a degree-25 exclusion only. It must not be called a negative headline theorem.

## 3. Work packages

### P0 — reconstruct the exact decision object

Rebuild independently:

- the rank-43 degree-25 basis;
- the exact 746-row landing span at \(p=89\);
- the 690 seed matrix and its grading;
- the monic \(K^3\) reduction;
- the irrelevant ideals for the coefficient and kernel variables.

Verify by fresh point evaluations that each row evaluates a genuine coefficient functional of \(F(p_c(x))\). Record hashes of every consumed matrix. Do not import the historical 842-row or rank-28-isomorphism claims.

### P1 — close or bypass the remaining degree-four membership

Decide the pure-\(q\), basis-degree-zero membership required for exact \(T\)-stability and commutativity of the lower presentation.

Acceptable outputs:

1. an exact membership certificate proving \(F/N_0\simeq R/J\); or
2. a certified failed membership vector, followed by enlargement by all required closure/commutator columns and a new finite presentation; or
3. a proof of empty lower-module support, in which case exact closure is unnecessary for the emptiness implication.

The known matrix floor exceeds the ordinary 8-GiB exploratory fence. Use a sparse/blocked computation, a representation decomposition, or a preflighted heavy-slot run. Do not repeat the previously failed unstructured degree-four F4 computation in all 43 coefficient variables.

### P2 — decide the multigraded kernel incidence

The equations \(M(q)b=0\) have the established bidegree. Saturate by both irrelevant ideals and treat the remaining projective strata separately.

1. **Stage A:** \(b_0=b_1=0\) is already empty; replay its independent certificate.
2. **Stage B:** \(b_0=0,\ b_1\ne0\). Decide the saturated incidence exactly. Use determinantal/rank-one geometry, representation decomposition, or a rigorously safe row compression. A nonempty compressed scheme is only a candidate.
3. **Stage C:** \(b_0\ne0\). Normalize projectively by \(b_0=1\) on this chart and decide the resulting incidence, including the overlap with the other charts.
4. Prove that the union of the decided strata is the complete projective kernel incidence.

For emptiness it is enough to show a safe over-approximation is empty. For nonemptiness, every candidate must be tested against all 690 seed relations and then all 746 complete landing cubics.

### P3 — exact candidate verification or emptiness certificate

#### If a candidate survives

1. verify all 746 special-fibre landing equations;
2. compute its local deformation/DVR lifting equations;
3. obtain an exact characteristic-zero point, not merely a modular or \(p\)-adic approximation;
4. reconstruct the degree-25 covariant in the original \(W\)-coordinates;
5. substitute into the original Klein cubic and check the full polynomial identity \(F(p)=0\);
6. verify nonzero/projectively nonconstant and the required \(G\)-equivariance.

#### If no candidate survives

Provide one of:

- a unit ideal after correct projective saturation;
- a finite affine cover with a unit ideal on every chart;
- a Fitting/annihilator certificate whose radical contains a power of the irrelevant ideal;
- an equivalent exact determinantal certificate.

Empty solver output is not a certificate.

### P4 — transfer and headline discipline

- Empty special fibre: apply the sealed projective-DVR theorem and record `degree 25 excluded` only.
- Characteristic-zero point: apply the accepted landing-covariant bridge and state the headline-positive theorem.

## 4. Acceptance and exits

### Headline-positive success

```text
P25-COVARIANT-HEADLINE-POSITIVE
```

Required payload:

- exact characteristic-zero coefficient vector;
- exact \(G\)-equivariance check;
- full original identity \(F(p)=0\);
- nontriviality/dominance bridge;
- independent verifier.

### Scoped negative success

```text
P25-DEGREE25-EMPTY
```

Required payload:

- exact empty projective special-fibre certificate;
- independent replay;
- DVR transfer to characteristic zero;
- explicit statement that the headline remains open.

### Honest stop

```text
P25-UNDECIDED
```

Name the smallest unresolved saturated stratum, membership test, or lifting equation and give a measured resource floor.

## 5. Prohibitions and stopping rules

1. Do not use the historical 842-row packet or claim the old rank-28 presentation is exact.
2. Do not promote a compressed-incidence survivor without checking all 690 and all 746 equations.
3. Do not promote a modular point to characteristic zero without an exact lift.
4. Do not require characteristic-zero row-rank reconstruction for the emptiness direction.
5. Do not infer emptiness from sample residuals, free-fibre towers, Hilbert-function truncation, or empty solver output.
6. Prime 67 is never the sole decision fibre.
7. Every positive point must be substituted into the original polynomial identity.
8. A degree-25 exclusion is not non-\(G\)-unirationality.
9. No Magma dependency is permitted.

## 6. Output contract

Write only under

```text
problems/E-klein-cubic/goal_runs/P25_LANDING_SUPPORT/
```

and do not modify sealed historical packets. Provide:

```text
STATUS.md
SUPPORT.md
candidate_or_empty.json
produce_*.py / *.m2 / *.jl as appropriate
verify_*.py
SEAL.json
```

`STATUS.md` must begin with one of the three exits above. The independent verifier must rebuild the decisive rank, saturation, candidate substitution, or emptiness certificate rather than read a stored result.