# Problem E — G3H A5 semilinear Springer execution order

**Pinned main:** `eb21458bea684d2399ad18f003e2be8ebdd161ce`

## Mission

Complete Route 1: convert the genuine maximal \(A_5\) degree-11 point over \(L_H/K_{\mathrm{proj}}\) into an executable normalized G3-frame point, then decide the quadratic Springer bridge.

The current G7B representative-dependent orbit construction is quarantined. Do not use split vectors \(\rho(g_i)e_0\) as induced cycles unless stabilizer and coset equivariance are proved.

## Required phases

### 1. G7B quarantine

Produce an exact audit showing:

- the proposed base line is not stabilized by the relevant \(A_5\);
- the coset representative assignment is not a well-defined \(G/H\) map;
- historical G7B files are not rewritten.

Exit:

`G3H-G7B-QUARANTINE-PASS`

### 2. Cubic compression

For each maximal \(A_5\) class construct the unique cubic compression

\[
Y_i:W\dashrightarrow U_i
\]

with

\[
\dim\operatorname{Hom}_{A_5}(\operatorname{Sym}^3W,U_i)=1.
\]

Verify exact equivariance, normalization, and a nonzero Jacobian minor.

Exit:

`G3H-CUBIC-COMPRESSION-PASS`

### 3. Genuine semilinear landing point

Compose the exact H-A5 degree-11 landing covariant with \(Y_i\):

\[
P_i=\Psi_i\circ Y_i.
\]

Verify:

- \(A_5\)-equivariance;
- \(P_i\neq0\);
- exact Klein landing identity \(F(P_i)=0\);
- independent verification.

Exit:

`G3H-SEMILINEAR-LANDING-PASS`

### 4. Degree-11 field and G3 frame

Construct an explicit degree-11 algebra

\[
L_i/K_{\mathrm{proj}}
\]

with primitive element, resolvent, multiplication, trace, and norm.

Reduce

\[
a_i=\bar M^{-1}(P_i/\tau^{33})
\]

into the basis

\[
1,\theta_i,\dots,\theta_i^{10}.
\]

Verify direct \(\Phi(a_i)=0\).

Exit:

`G3H-SEMILINEAR-G3-FRAME-PASS`

### 5. Quadratic Springer interface

Compute the polar data from the genuine point:

\[
A=\Phi(q),\quad C=B(q,q,a_i),\quad D=B(q,a_i,a_i).
\]

Only accept Springer if there is:

1. a quadratic object defined over \(K_{\mathrm{proj}}\);
2. an \(L_i\)-point on that object;
3. odd degree \([L_i:K_{\mathrm{proj}}]=11\);
4. an explicit map back to \(X_{\mathrm{gen}}\).

Forbidden:

`Q_q(L_i) nonempty => X_gen(K_proj) nonempty`

without a map-back theorem.

Exit:

`G3H-QUADRATIC-SPRINGER-REDUCTION-PASS`

## CAS requirements

Local CAS only. No GitHub runners.

Allowed:

- SageMath / Python exact arithmetic;
- Singular for sparse elimination;
- FLINT through Sage;
- local Magma or Macaulay2 only if required.

Required CAS tasks:

- exact \(A_5\) Hom-space computation;
- degree-33 composition;
- degree-11 resolvent construction;
- trace-pairing reduction into the G3A rank-12 field model;
- exact quadratic square-class and conic/quadric elimination.

Store scripts, exact outputs, and resource information.

## Deliverables

Directory:

`problems/E-klein-cubic/goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER/`

Required:

- manifests and seals;
- independent producer/verifier pairs;
- semilinear point certificates;
- field arithmetic certificates;
- quadratic decision certificate;
- replay instructions.

## Final exits

Allowed:

- `G3P-POINT-HEADLINE-POSITIVE`
- `G3H-QUADRATIC-SPRINGER-REDUCTION-PASS`
- `G3H-SEMILINEAR-G3-FRAME-PASS`
- `G3H-QUADRATIC-INTERFACE-NO-GO-SCOPED`
- `G3H-UNDECIDED`
- `G3H-CANONICAL-INPUT-FAIL`
