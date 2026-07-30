# Problem E — successor work order: nonlinear lifting and global blockers

**Worker:** local research agent.  
**Authored:** 2026-07-30.  
**Repository:** `mattrobball/unirational`.  
**Pinned base:** `1fcc576bc0fe3758a0a0a538b44fcbed3a5dd23f`.  
**Status at issue:** Problem E remains **OPEN**.

## Mission

The completed strata-machine campaign proves that the finite marked-state screen and the linear all-order inverse-limit screen do **not** obstruct a homogeneous landing self-covariant

\[
p:W\longrightarrow W,
\qquad F(p)=0,
\]

for the Klein cubic

\[
X=\left\{\sum_{i\in\mathbf Z/5}x_i^2x_{i+1}=0\right\}
\subset \mathbf P(W),
\qquad
G=\operatorname{PSL}_2(\mathbf F_{11}).
\]

WP-5 reaches Exit P: globally compatible first normal states exist, and for every fixed odd plane order \(m\), the linear inverse-limit module \(\Lambda_{m,d}\) is nonzero for all sufficiently large \(d\). WP-6 translates one degree-25 branch into a sparse rank-28 border module but does not decide its projective support. None of this is a positive construction.

This successor order has four goals:

1. repair the local category so that source fixed lines, exceptional normal directions, and target fixed lines are not conflated;
2. replace first-normal-state compatibility by a **nonlinear formal lifting tower**;
3. upgrade the finite \(E[2]\)-charge to a full elliptic \(\operatorname{Pic}^0\)-valued obstruction where possible;
4. pursue two independent global blockers: the target-branch three-primary class-group obstruction and the Hodge-theoretic irregular-center obstruction.

The preferred outcome is a degree-independent obstruction. A surviving formal lift is not a landing covariant until algebraization, equivariance, primitivity, and dominance are certified.

---

## Governing theorem boundary

The accepted reduction remains

\[
X\text{ is }G\text{-unirational}
\quad\Longleftrightarrow\quad
\operatorname{ed}_{\mathbf C}(G)=3.
\]

A negative resolution must exclude every nonzero homogeneous landing self-covariant in characteristic zero. A finite degree exclusion, a finite-field null search, one normal-order branch, or one resolution model is not sufficient.

The following completed packets are trusted inputs and must not be re-derived except for regression:

```text
certificates/strata/*
certificates/transitions/*
certificates/global_transition/*
certificates/border_support/*
certificates/STRATA_EXACT.md
certificates/NORMAL_CHARACTERS.md
certificates/MARKED_S3_GEOMETRY.md
certificates/LOCAL_TRANSITION_MODULES.md
certificates/GLOBAL_TRANSITION_DIAGRAM.md
certificates/BORDER_SUPPORT.md
```

The exact strata packet supersedes the candidate sentence that positive-dimensional fixed loci meet only at type-I points: type-II points are triple meetings of the three local fixed elliptics.

---

# Part I — repair the category before using it negatively

## WP-R0 — source / normal-direction / target separation

### Problem

For an involution \(t\), three copies of \(\mathbf P(E_-(t))\) occur:

1. the **source fixed line**
   \[
   L_t^{\mathrm{src}}=\mathbf P(E_-(t))\subset\mathbf P(W);
   \]
2. the **exceptional normal-direction factor** in
   \[
   \mathbf P(N_{Z_t/Y})
   \simeq Z_t\times\mathbf P(E_-(t)),
   \qquad Z_t=\mathbf P(E_+(t));
   \]
3. the **target fixed line**
   \[
   L_t^{\mathrm{tgt}}=\mathbf P(E_-(t))\subset X^t.
   \]

They are isomorphic as residual \(D_{12}\)-spaces but are not the same geometric object. In particular, \(L_t^{\mathrm{src}}\cap Z_t=\varnothing\). The source-line formula

\[
p|_{E_-}=\Delta_t^m h_t
\]

is a terminal coefficient condition, not an ordinary restriction of the first normal jet on \(Z_t\).

### Tasks

1. Audit every arrow in `certificates/global_transition/diagram.json` and classify it as:

   ```text
   SOURCE-RESTRICTION
   NORMAL-CONE-SPECIALIZATION
   TARGET-EVALUATION
   COEFFICIENT-COUPLING
   ```

2. Replace the present `C2_plane -> C2_line` abstraction by the span

   \[
   Z_t^{\mathrm{src}}
   \longleftarrow
   \mathbf P(N_{Z_t/Y})
   \longrightarrow
   L_t^{\mathrm{tgt}},
   \]

   together with the separate source restriction

   \[
   L_t^{\mathrm{src}}\dashrightarrow X^t.
   \]

3. Write the coefficient coupling explicitly. For

   \[
   x=z+y,
   \qquad z\in E_+(t),\quad y\in E_-(t),
   \]

   decompose a degree-\(d\) covariant as

   \[
   p(z,y)=\sum_{r=0}^d p_r(z,y),
   \qquad
   p_r\in
   \operatorname{Sym}^{d-r}E_+^\vee
   \otimes\operatorname{Sym}^{r}E_-^\vee
   \otimes W.
   \]

   Record exactly that \(p_r\) is \(E_+\)-valued for even \(r\) and \(E_-\)-valued for odd \(r\), and that

   \[
   p|_{E_-}=p_d(0,y).
   \]

4. Re-prove the necessity theorem with the corrected category. The expected verdict is that the corrected linear state space is at least as large as the current one; no negative conclusion should be inferred merely from the repair.

### Deliverables

```text
certificates/transition_repair/CATEGORY_AUDIT.md
certificates/transition_repair/category_repaired.json
certificates/transition_repair/produce.py
certificates/transition_repair/verify.py
certificates/TRANSITION_CATEGORY_REPAIR.md
```

### Acceptance gate

The verifier must reject any arrow identifying the disjoint source line with a subvariety of the plus-plane. It must distinguish all three copies of \(\mathbf P(E_-)\) by path and type.

---

# Part II — nonlinear formal lifting

## WP-L1 — universal polar expansion

The cubic is even in the normal variable \(y\):

\[
F(z+y)=F_+(z)+B(z;y,y),
\]

where

\[
B:E_+\otimes\operatorname{Sym}^2E_-\longrightarrow\mathbf C
\]

is the mixed polar form.

For odd first normal order \(m\), write

\[
\begin{aligned}
p_-&=a_m+a_{m+2}+a_{m+4}+\cdots,\\
p_+&=b_{m+1}+b_{m+3}+b_{m+5}+\cdots.
\end{aligned}
\]

The first nonzero term \(a_m\) lands automatically because \(F|_{E_-}=0\). The next equations are not automatic. In particular, derive and certify the universal equations at orders \(3m+1\) and \(3m+3\):

\[
B(b_{m+1};a_m,a_m)=0,
\]

and

\[
B(b_{m+3};a_m,a_m)
+2B(b_{m+1};a_m,a_{m+2})
+F_+(b_{m+1})=0.
\]

### Tasks

1. Construct the exact symmetric trilinear polarization \(\Phi\) of \(F\) and derive the coefficient of every normal order in

   \[
   F\left(\sum_r p_r\right).
   \]

2. Implement a symbolic order ledger valid for arbitrary \(m,d\), with no instantiated degree.

3. For each order \(r\), isolate the newest correction linearly:

   \[
   L_r(p_{m+r})=-R_r(p_m,\ldots,p_{m+r-1}).
   \]

4. Record the obstruction class

   \[
   \omega_r\in\operatorname{coker}(L_r).
   \]

5. Verify compatibility of these local equations under all corrected source and normal-cone incidences.

### Deliverables

```text
certificates/lifting/polar_expansion.py
certificates/lifting/polar_expansion.json
certificates/lifting/verify_polar_expansion.py
certificates/NONLINEAR_LIFTING_EQUATIONS.md
```

### Acceptance gate

The proof note must show the order formulas algebraically from the exact Klein cubic, not by samples. It must preserve the distinction between local normal order and global polynomial degree.

## WP-L2 — relative obstruction tower on WP-5 survivors

For each irreducible survivor family \(B_0\) from the corrected WP-5 state space, define

\[
B_0\supseteq B_1\supseteq B_2\supseteq\cdots,
\]

where \(B_r\) parametrizes states liftable through the first \(r\) nonlinear equations.

### Required families

1. `based_minus_lines_odd_m`;
2. `residual_e1_swap_both`;
3. `residual_e_ge7_generic_swap_both`;
4. any additional family created by the category repair.

### Tasks

1. Present \(L_r\) and \(\omega_r\) as relative matrices over the coordinate ring of each survivor component.
2. Define the next lifting locus by a relative Fitting or determinantal ideal of

   \[
   [L_r\mid\omega_r].
   \]

3. Compute the first two nonautomatic lifting stages exactly for every family.
4. Before a large calculation, exploit representation-theoretic decompositions by stabilizer character and residual \(S_3\)-type.
5. If one family is empty at a finite stage, write an all-degree theorem for that family immediately.
6. If a family survives, output the exact formal parameters and the next obstruction module; do not call it a covariant.

### All-degree requirement

The tower must be formulated over a bigraded or multi-Rees coefficient algebra. A run at \(m=1,d=25\) is permitted only as a regression or as a consequence of a theorem reducing the universal family to that bidegree.

### Deliverables

```text
certificates/lifting/families/...
certificates/lifting/OBSTRUCTION_TOWER.md
certificates/lifting/SEAL.json
```

### Decision exits

- **L-N:** every corrected WP-5 family is killed at a finite formal order; combine with the necessity theorem for a negative resolution.
- **L-P:** one family survives to the computed order; record the formal lift and continue.
- **L-F:** the obstruction modules become periodic or finitely generated in a way that reduces the infinite tower to finitely many stages; prove the reduction before computing the terminal stages.

---

# Part III — full elliptic Picard obstruction

## WP-E1 — replace the finite charge by a \(\operatorname{Pic}^0\)-class

WP-3 proves

\[
j(E_t)=\frac{8192}{11},
\]

and residual order three acts as translation by nonzero \(q\in E_t[3]\). After an origin choice,

\[
\text{type I}=\langle q\rangle,
\qquad
\text{type II}=e+\langle q\rangle,
\quad 0\neq e\in E_t[2].
\]

The finite \(E[2]\)-label is globally consistent and cannot by itself obstruct lifting. The next invariant should be the full divisor or line-bundle class on \(E_t\).

### Tasks

1. For each leading and correction jet in WP-L2, compute the induced divisor class on the marked elliptic \(E_t\).
2. Express its transformation under

   \[
   P\longmapsto P+q
   \]

   and under the residual reflections.
3. Construct trace and norm maps on the resulting \(\operatorname{Pic}^0(E_t)\)-valued data.
4. Recover the already accepted order-twelve quadratic-trace obstruction as a regression theorem.
5. Test whether the same trace obstruction applies to:
   - arbitrary odd \(m\) in the based-minus-line family;
   - the unique \(e=1\) all-swap family;
   - generic odd \(e\ge7\);
   - non-planewise corrections.
6. Distinguish carefully:
   - a divisor identity on one elliptic;
   - a residual-\(S_3\)-equivariant identity;
   - a global \(G\)-equivariant gluing theorem.

### Deliverables

```text
certificates/elliptic_lifting/PICARD_OBSTRUCTION.md
certificates/elliptic_lifting/produce.py
certificates/elliptic_lifting/verify.py
certificates/elliptic_lifting/SEAL.json
```

### Obstruction protocol

If an invariant class survives every allowed correction, exhibit it in an exact finite quotient of \(\operatorname{Pic}^0\), prove independence of all choices, and stop. Do not add higher-order correction terms around a certified nonzero class.

---

# Part IV — bounded border-module branch

## WP-B1 — stable closure of the seven based rows

WP-6 adds seven degree-one generators to the degree-25 rank-28 border module for the based-minus-line branch but does not compute their full \(T_i\)-stable closure.

Let

\[
N'=\operatorname{Sat}_{T_0,\ldots,T_5}
\bigl(N+\langle L_0,\ldots,L_6\rangle\bigr).
\]

### Tasks

1. Promote the seven discovery-fibre rows to characteristic zero, or supply a complete projective-DVR rank-preservation argument.
2. Compute the sparse \(T_i\)-stable closure using streamed rows and hashed transformation circuits.
3. Compute one of:

   \[
   \operatorname{Ann}(F/N'),
   \qquad
   \operatorname{Fitt}_0(F/N'),
   \qquad
   \operatorname{Sat}_{(q_0,\ldots,q_{36})}N'.
   \]

4. Decide the projective support of this restricted module.

### Scope

A negative result here excludes only the based-minus-line degree-25 branch unless a separate theorem propagates it to all \((m,d)\). State that boundary in every artifact.

### Large-run gate

The M5 Max may use up to 96 GB RSS only after the producer emits:

- matrix dimensions;
- nonzero term count;
- sparse and dense memory floors;
- checkpoint format;
- independent verifier design.

Raw dense degree-four or degree-seven matrices remain forbidden.

---

# Part V — independent global blocker A: target-branch index three

## WP-T1 — normalized multiplicity-one target branch

The current fixed-frame route proves over

\[
F=\mathbf C(A,B,Y,Z)
\]

that

\[
\operatorname{ind}(C/F)=3,
\qquad
C(F)=\varnothing,
\qquad
\operatorname{Pic}^0(C)(F)=0,
\]

and

\[
[K_{\mathrm{proj}}:F]=6
\]

with geometric monodromy \(S_6\) and no proper intermediate fields. A multiplicity-one target branch has residue degree one and smooth generic cubic. The remaining negative gate is

\[
\operatorname{ind}(C_{k(D)})=3.
\]

The ordinary Picard calculation is already complete:

\[
\operatorname{Pic}(T_D)=\mathbf ZH_z\oplus\mathbf ZH_\lambda.
\]

Only the three-primary non-Cartier defect can lower the degree subgroup:

\[
\bigl(\operatorname{Cl}(T_D)/\operatorname{Pic}(T_D)\bigr)[3].
\]

### Tasks

1. Cramer-saturate and normalize the multiplicity-one target branch.
2. Construct the normalized dominant cubic incidence over it.
3. Enumerate codimension-two singular strata on the normalized incidence.
4. Compute only the local class groups or contact exponents **modulo 3**.
5. Prove that every vertical Weil class has order prime to three, or exhibit the precise dangerous three-primary class.
6. Conclude either:
   - the horizontal divisor-degree subgroup remains \(3\mathbf Z\); or
   - a genuine three-primary escape survives.

### Local singularity interface

At the accepted degree-12 RUR orbit, the primitive sextic \(P\) satisfies

\[
P=P_A=P_B=P_Y=P_Z=P_u=0,
\]

while \(P_{uu}\) and a transverse Hessian determinant are units. The current all-orders question is

\[
P\in(P_A,P_B,P_Y)_{\mathfrak m}.
\]

After formal Morse splitting, the residual singularity has form

\[
xy-h(z,w).
\]

For the class-group gate, full equality \(h=0\) is stronger than necessary. Determine the irreducible factors and contact orders of \(h\) modulo three. In the model \(xy=\pi^n\), only \(3\mid n\) is dangerous.

### Deliverables

```text
certificates/target_branch_mod3/...
certificates/TARGET_BRANCH_MOD3_CLASS_GROUP.md
```

### Decision exit

A proof that the three-primary defect vanishes gives a pointless residue twist and should be assembled immediately into the negative resolution of Problem E.

---

# Part VI — independent global blocker B: irregular resolution centers

## WP-H1 — equivariant Hodge-center necessity theorem

Assume a dominant rational map

\[
\mathbf P^4\dashrightarrow X
\]

and resolve it equivariantly:

\[
Z\longrightarrow\mathbf P^4,
\qquad
f:Z\longrightarrow X.
\]

For a \(G\)-invariant ample class \(\eta\) on \(Z\), projection formula gives a split injection

\[
f^*:H^3(X,\mathbf Q)\hookrightarrow H^3(Z,\mathbf Q).
\]

For a blowup along a smooth center \(C\),

\[
H^3(\operatorname{Bl}_C Y)
\simeq
H^3(Y)\oplus H^1(C)(-1).
\]

Since \(H^3(\mathbf P^4)=0\), the five-dimensional Klein representation

\[
H^{2,1}(X)
\]

must be supplied by \(H^{1,0}\) of positive-irregularity blowup centers.

### Tasks

1. Prove the split injection and equivariant blowup decomposition at the exact level used.
2. Compute \(H^{2,1}(X)\) as a \(G\)-representation from the Jacobian ring.
3. For every subgroup type \(H\) in the exact strata table, compute

   \[
   \operatorname{Hom}_H
   \left(
   H^{2,1}(X)|_H,\rho
   \right)
   \]

   for every irreducible \(H\)-representation \(\rho\).
4. For each surviving \((H,\rho)\), use Riemann–Hurwitz and Chevalley–Weil to bound the minimum genus of a curve center carrying \(\rho\).
5. Record orbit size \([G:H]\), minimum genus, and the minimum possible contribution to the base locus.
6. Combine these with the intersection budget of a primitive **minimal** landing covariant.

### Required theorem boundary

The certified linear strata and point centers contribute no \(H^1\). Therefore any actual lift of the strata machine must create additional nonlinear positive-genus curves or irregular surfaces. This is a necessary condition, not by itself a contradiction.

### Deliverables

```text
certificates/hodge_centers/HODGE_CENTER_NECESSITY.md
certificates/hodge_centers/character_screen.g
certificates/hodge_centers/character_screen.json
certificates/hodge_centers/verify.py
```

### Escalation

Only after the character screen should the worker search equivariant Hilbert schemes or invariant ideals for admissible hidden centers.

---

# Part VII — theorem assembly and route ranking

## WP-Z — director gate

After WP-R0, WP-L1, and the first obstruction stage of WP-L2, issue a gate report with exactly one of the following rankings:

1. **Nonlinear lifting obstruction active:** continue WP-L2/WP-E1 first.
2. **Target-branch mod-3 gate near closure:** prioritize WP-T1.
3. **Hodge-center numerical contradiction visible:** prioritize WP-H1 plus minimality/intersection theory.
4. **All three survive:** document the exact survivors and reassess the positive Pfaffian construction rather than launching another unstructured negative sweep.

No route may be promoted merely because its computation is largest.

---

## Free software stack

No Magma dependency.

### Exact group and representation work

- GAP using an absolute binary path;
- repository exact \(\mathbf Q(\zeta_{11})\) Python implementation;
- PARI/GP, python-flint, or Nemo/Hecke for number-field arithmetic.

### Commutative algebra

- Macaulay2 for Rees modules, Fitting ideals, saturation, local rings, and class groups where supported;
- Singular or Singular.jl for local standard bases and elimination;
- OSCAR/Nemo/Groebner.jl for sparse exact matrices and number-field algebra;
- msolve for terminal zero-dimensional systems only;
- Normaliz for semigroup and multigraded cone computations.

### Hodge and curve calculations

- exact Jacobian-ring linear algebra in Python/GAP;
- PARI/GP or OSCAR for elliptic and curve arithmetic;
- custom Chevalley–Weil and orbifold calculations with independent verification.

---

## Hardware and certificate policy

Assume an M5 Max MacBook Pro with 128 GB unified memory.

1. The ordinary exploratory gate is 8 GB RSS.
2. A structurally justified job may use up to 96 GB RSS after a director gate.
3. Stream sparse rows and transformation circuits; do not materialize dense global matrices.
4. Hash all large inputs, checkpoints, and terminal outputs.
5. Every decisive producer must have an independent verifier that does not import the producer.
6. Every finite-field calculation is discovery or shape selection unless accompanied by a written characteristic-zero lifting argument.
7. Record package versions, exact commands, threads, wall time, peak RSS, and exit status.

---

## House rules

1. **Do not conflate the three copies of \(\mathbf P(E_-)\).**
2. **Do not infer a negative theorem from first-normal-state nonexistence or existence without the corrected necessity proof.**
3. **Do not call a formal lift a covariant.** Algebraization and global coefficient compatibility are separate.
4. **Do not return to finite degree ladders unless a structural theorem reduces the universal problem to those degrees.**
5. **Do not discard finite irrelevant torsion in low degree.**
6. **Do not average affine solution torsors naively.** Use the correct character projector and prove invariance of the affine space.
7. **Do not use only the \(E[2]\)-charge once a full \(\operatorname{Pic}^0\)-class is available.**
8. **Do not compute a full class group when only its three-primary quotient is relevant.**
9. **Do not treat WP-B1 as an all-degree theorem without a propagation lemma.**
10. **Do not use birational superrigidity against a higher-degree dominant map.**
11. **Do not advertise a modular survivor or null result as characteristic zero.**
12. **Stop and certify any exact invariant obstruction independent of all admissible corrections.**

---

## First dispatch

The first worker assignment is deliberately limited to:

1. complete WP-R0 and write the corrected necessity statement;
2. complete WP-L1 through normal order \(3m+3\) universally;
3. instantiate the resulting operators on the three accepted WP-5 survivor families without running a large elimination;
4. estimate the sizes and character decompositions of the first relative Fitting problems;
5. return for a director gate before WP-L2, WP-T1, or any >8 GB job.

A successful first dispatch ends with either:

- a certified finite-order obstruction for at least one full survivor family; or
- a corrected, sealed nonlinear lifting interface with exact next matrices and a justified resource request.
