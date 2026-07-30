# Problem E — Work Order for the Next Five Attempts

**Worker:** local research agent
**Authored:** 2026-07-30
**Repository:** `mattrobball/unirational`
**Pinned base:** `d9cadc3a835c40add65c322ab29ff2b983dc3216`
**Problem:** `PSL(2,11)`-unirationality of the Klein cubic threefold
**Status at issue:** OPEN

---

## 0. Mission and governing boundary

Let

\[
G=\operatorname{PSL}_2(\mathbf F_{11}),\qquad
X=\left\{\sum_{i\in\mathbf Z/5}x_i^2x_{i+1}=0\right\}
\subset \mathbf P(W)\simeq \mathbf P^4.
\]

The accepted reduction is

\[
X\text{ is }G\text{-unirational}
\quad\Longleftrightarrow\quad
\operatorname{ed}_{\mathbf C}(G)=3.
\]

The completed strata and lifting campaigns establish the following strategic
boundary.

1. Finite marked-state obstruction is unavailable.
2. Linear all-order obstruction is unavailable: for fixed odd normal order
   `m`, plane jets grow as `O(d^2)`, while the total linear boundary
   conditions grow as `O(d)`.
3. The first two nonautomatic nonlinear lifting stages do not kill any of the
   three surviving families on their generic loci.
4. The known elliptic `Pic^0`-trace obstruction is valid but specific to the
   previous Fable order-`3/4` ansatz.
5. The Hodge-center theorem is a necessary condition with substantial
   geometric slack.
6. The target-branch three-primary class-group gate remains undecided.
7. The positive Pfaffian construction has the most developed exact existence
   infrastructure.

This order runs the next five attempts in strict priority order. It forbids
another unstructured negative sweep.

### Positive proof standard

A positive resolution must provide either:

- a `K_proj`-point on the generic Klein twist; or
- an explicit nonzero homogeneous landing self-covariant `p: W -> W`,

together with exact verification of every implication needed for:

1. `G`-equivariance;
2. landing in `X`;
3. domain and primitivity control;
4. dominance;
5. conversion to `G`-unirationality.

An abstract idempotent, formal normal state, finite-field point, or point on
an auxiliary variety is insufficient until the complete bridge to the generic
Klein twist is proved.

### Negative proof standard

A negative resolution must prove that the generic Klein twist has no
`K_proj`-point, or equivalently exclude every nonzero homogeneous landing
self-covariant in characteristic zero.

The following do **not** suffice: one failed construction; one fixed support
pattern; one finite degree range; one modular null result; one unresolved
valuation; exclusion of only one formal family.

---

## 1. Accepted inputs

The following tracked packets are accepted and must not be re-derived except
for regression or to repair a stated theorem boundary:

```text
problems/E-klein-cubic/RESOLUTION.md
problems/E-klein-cubic/CURRENT_PATHS.md
problems/E-klein-cubic/HANDOFF.md

problems/E-klein-cubic/certificates/STRATA_EXACT.md
problems/E-klein-cubic/certificates/NORMAL_CHARACTERS.md
problems/E-klein-cubic/certificates/MARKED_S3_GEOMETRY.md
problems/E-klein-cubic/certificates/LOCAL_TRANSITION_MODULES.md
problems/E-klein-cubic/certificates/GLOBAL_TRANSITION_DIAGRAM.md
problems/E-klein-cubic/certificates/TRANSITION_CATEGORY_REPAIR.md
problems/E-klein-cubic/certificates/NONLINEAR_LIFTING_EQUATIONS.md
problems/E-klein-cubic/certificates/lifting/OBSTRUCTION_TOWER.md
problems/E-klein-cubic/certificates/elliptic_lifting/PICARD_OBSTRUCTION.md
problems/E-klein-cubic/certificates/hodge_centers/HODGE_CENTER_NECESSITY.md
problems/E-klein-cubic/certificates/TARGET_BRANCH_MOD3_CLASS_GROUP.md
problems/E-klein-cubic/certificates/WP_Z_GATE_REPORT.md
```

The exact repository strata packet is authoritative. In particular, type-II
`V_4`-points are triple intersections of the three local fixed elliptics. Any
earlier statement that positive-dimensional fixed loci meet only at type-I
points is superseded.

---

## Attempt 1 — Pfaffian–Morita point construction

### 1A. Objective

Establish `G`-unirationality by converting the abstract Pfaffian/Morita data
into a `K_proj`-point on the generic Klein twist.

Accepted starting facts include: the descended central simple algebra has
period and index `2`; a `sigma`-self-adjoint reduced-rank-two idempotent
exists abstractly; a `15`-element basis of `Sym(A,sigma)` is installed;
coordinate extraction is reduced to `c_3(a)=0, c_2(a)!=0`; the minimal
fixed-frame triple gives an explicit smooth genus-one curve over `K_proj`;
the projector open is `F_u != 0`; rational-flex, rational-`3`-torsion,
rational-`3`-isogeny, support-`<=2`, and coordinate support-`3` shortcuts are
closed.

**This is the primary attempt.**

### 1B. Gate 1 — bridge audit before computation

No large coordinate solve is authorized until both implications below are
written and independently audited.

**Task 1B.1 — pin the descent theorem.** Pin the precise CFOSS statement used
for prime-`3` injectivity of `w_1`. The deliverable must include:

```text
exact theorem number
hash-pinned source
verbatim hypotheses
the object denoted w1 in the source
the object denoted w1 in this repository
proof that the two conventions agree
every repository use-site
```

No argument may cite "CFOSS injectivity" generically.

**Task 1B.2 — verify the positive implication chain.** Prove, with no omitted
arrows, the implication

\[
\text{$\sigma$-self-adjoint reduced-rank-two idempotent}
\Longrightarrow
\text{common isotropic right line}
\Longrightarrow
C_{\mathrm{gen}}(K_{\mathrm{proj}})\neq\varnothing
\Longrightarrow
X\text{ is }G\text{-unirational}.
\]

At every arrow record: source object; target object; field of definition;
open conditions; descent or twisting operation; possible Brauer or
orientation ambiguity; theorem used.

**Gate 1 decision.** `PASS` — both chains exact, proceed to 1C.
`FAIL-REPAIR` — implication true but a missing hypothesis identified; repair
before computation. `FAIL-SCOPE` — the idempotent only gives a point on an
auxiliary space; demote Attempt 1 and report the exact missing bridge.

### 1C. Gate 2 — abstract extraction before raw coordinates

**Task 1C.1 — quaternion-corner reduction.** Use `A ~= M_3(D)`, `D`
quaternion, to replace the `15`-variable symmetric-cubic equation by the
smallest intrinsic Hermitian problem. Required output: an explicit quaternion
corner; the five relevant Hermitian matrices or forms; the
common-isotropic-line equations; the equivalence with `c_3(a)=0, c_2(a)!=0`;
a dimension count and singular-locus analysis.

The primary question is whether the abstract idempotent theorem already
forces a rational point of the installed symmetric cubic, **without choosing
coordinates**.

**Task 1C.2 — rational section or torsor identification.** Determine whether
the space of self-adjoint reduced-rank-two idempotents is: rational over
`K_proj`; a homogeneous space with a known neutral torsor; a quadric,
Severi-Brauer, or unitary Grassmannian with an existing point theorem; or a
genuinely nontrivial torsor. If homogeneous, compute its cohomological class
and prove whether the known algebra-with-involution data neutralizes it.

**Gate 2 decision.** `P1-ABSTRACT` — the abstract idempotent already yields
the required point; assemble the positive theorem immediately.
`P1-REDUCED` — reduces to a lower-dimensional explicit system; proceed to 1D.
`STOP-1` — homogeneous-space obstruction identified and nontrivial; record it
as the exact new point problem; do not launch the original `15`-variable
system.

### 1D. Gate 3 — exact coordinate extraction

Run only if Gate 2 produces a genuinely smaller or structurally decomposed
system.

**Task 1D.1 — solve the symmetric cubic** `c_3(a)=0, c_2(a)!=0` over
`K_proj`, using the quaternion/Hermitian decomposition; the exact
invariant-field arithmetic already installed; sparse elimination only after
block reduction; exact open-condition tracking.

**Task 1D.2 — conic/intersection-algebra formulation.** In parallel, over
`F = C(A,B,Y,Z)` with `[K_proj:F]=6`, construct the exact scheme of `F`-conics
`Q` such that `Q ∩ C` has length `6`; its coordinate algebra is isomorphic to
`K_proj`; and the induced point over `K_proj` lies in the projector open.
Express the algebra-isomorphism condition by traces, norms, and the known
`S_6`-extension, not by an unstructured six-point solve.

### Decision exits for Attempt 1

`P1` exact `K_proj`-point obtained; verify the full bridge and close
positively. `P1-CONDITIONAL` point obtained subject to one named theorem;
isolate and prove it before any headline claim. `N1-SCOPED` the installed
Pfaffian point construction is impossible; this does **not** prove
non-unirationality. `STOP-1` no structural reduction remains and the raw
system is intractable; record the exact smallest unresolved system and pass
to Attempt 2.

### Deliverables

```text
certificates/pfaffian_point/BRIDGE_AUDIT.md
certificates/pfaffian_point/CFOSS_W1_INPUT.md
certificates/pfaffian_point/IDEMPOTENT_TO_KLEIN_POINT.md
certificates/pfaffian_point/quaternion_corner.*
certificates/pfaffian_point/conic_algebra.*
certificates/pfaffian_point/SEAL.json
```

---

## Attempt 2 — Target-branch three-primary obstruction

### 2A. Objective

Disprove `G`-unirationality by preserving index `3` on a residue-degree-one
target branch. The accepted reduction is

\[
\operatorname{ind}(C/F)=3,\qquad C(F)=\varnothing,\qquad [K_{\mathrm{proj}}:F]=6,
\]

and the decisive residue target is `ind(C_{k(D)}) = 3`. Ordinary Picard
theory is complete: `Pic(T_D) = Z H_z (+) Z H_lambda`. The only relevant
escape is `( Cl(T_D)/Pic(T_D) )[3]`. **Do not compute the full class group.**

### 2B. Gate 1 — globalize the fold component

The prior pointwise local approach is retired. The exact slice critical locus
is a curve of dimension `1` and degree `14`; the twelve RUR points are points
on that curve, not isolated singularities.

**Task 2B.1 — extract the global simple-fold component.** Starting from
`R_fold = V(P, P_u)` away from `P_uu * delta_C = 0`, construct: the relevant
irreducible component; its normalization `D~`; the conductor; the map to the
target coefficient space; the discriminant divisor of the cubic family on
`D~`. The output must be global over characteristic zero. **A test slice is
not the component.**

**Task 2B.2 — identify the critical surface/curve geometry.** Determine
whether the normalized fold is smooth along the conductor; Morse-Bott with
local model `xy=0`; nodal contact `xy=pi^n`; or higher `cA`-type. Use the
positive-dimensional critical locus as geometry, not as sample points.

**Gate 1 decision.** `PASS-MB`; `PASS-NODAL`; `FAIL-HIGHER` (compute only its
local class group mod `3`); `STOP-2` (record the exact algebraic bottleneck
and demote the route).

### 2C. Gate 2 — contact exponents modulo 3

**Task 2C.1 — discriminant pullback.** Factor the pullback of the cubic
discriminant to `D~` in codimension one. For every height-one prime `E`
compute `m_E = v_E(Delta_cub)`. **Only the residue class mod `3` is
required.**

**Task 2C.2 — codimension-two local class groups.** For every non-Cartier
codimension-two stratum compute `Cl(O^_{T_D,eta})[3]`. For `xy = pi^n`,
record `Z/n` and whether `3 | n`.

**Task 2C.3 — codimension-three audit.** Either prove the residual bad locus
has codimension `>= 4` so lci parafactoriality applies, or that every
punctured local Picard group in codimension `3` has exponent prime to `3`.
No conclusion from codimension-two analysis alone is permitted.

### 2D. Gate 3 — global class-group assembly

Use normalization/conductor and local-to-global class-group exact sequences
to prove `( Cl(T_D)/Pic(T_D) )[3] = 0`, or exhibit a nonzero explicit class.

### Decision exits for Attempt 2

`N2` defect vanishes; prove `ind(C_{k(D)})=3`, obtain a pointless residue
twist, close negatively. `P2` an explicit horizontal divisor of degree `1` or
`2` is constructed and descends; convert to a point and close positively.
`ESCAPE-2` a dangerous three-primary class exists but gives no degree `1`/`2`
divisor; record and stop. `STOP-2` normalized geometry uncontrolled; do not
return to bounded local jets.

### Deliverables

```text
certificates/target_branch_global/NORMALIZED_FOLD.md
certificates/target_branch_global/normalization.*
certificates/target_branch_global/conductor.*
certificates/target_branch_global/discriminant_contacts_mod3.*
certificates/target_branch_global/local_class_groups_mod3.*
certificates/target_branch_global/GLOBAL_MOD3_ASSEMBLY.md
certificates/target_branch_global/SEAL.json
```

---

## Attempt 3 — Unrestricted Schur degree-19 rescue curve

### 3A. Objective

Use the unrestricted Schur model either positively, by constructing a
degree-`19` curve through the degree-`55` closed point and obtaining a
residual degree-`2` cycle; or negatively, by constructing a boundary-zero
torsor with a pointless Klein twist. Excluding one degree-`19` family alone
is **not** a negative resolution.

### 3B. Gate 1 — certify the implication chain

Prove the exact positive implication

\[
\text{qualifying degree-19 curve}
\Longrightarrow
\text{residual degree-2 zero-cycle}
\Longrightarrow
K_{\mathrm{proj}}\text{-point on the cubic}.
\]

Record: field of definition; intersection multiplicities; purity and
geometric integrality hypotheses; the quadratic descent step; possible
boundary components.

### 3C. Gate 2 — classify the two surviving Rao branches

Accepted: ACM integral curves are excluded for the selected descended point;
a smooth rational survivor has degree-five Rao dimension `40` or `41`; the
live branches are (1) no-quintic marked incidence, (2) degree-`19` divisors
on special quintic carriers.

**Task 3C.1 — minimal free resolutions.** For each Rao branch enumerate all
compatible Betti tables and minimal free resolutions. Reject tables violating
degree `19`; genus `0`; the marked-point Hilbert function; the accepted Rao
ledger; semilinear `D_12`-stabilizer constraints.

**Task 3C.2 — marked Hilbert scheme.** Construct the relevant marked Hilbert
or Quot scheme **over `F`**, not merely over `Fbar`. Determine nonemptiness;
component dimensions; fields of definition; incidence with the degree-`55`
point; whether a component contains a geometrically integral rational curve.

**Task 3C.3 — special quintic carriers.** Classify the special quintic
surfaces containing the `(3,5)`-curve; compute their Picard/class groups in
the actual marked family; decide whether a divisor of degree `19` and genus
`0` exists; use liaison only with full control of disconnected and nonreduced
residuals.

### 3D. Negative subroute

If all rescue curves are excluded, test the independent negative criterion:
construct a boundary-zero torsor over an infinite field whose Klein twist is
pointless. This requires an explicit torsor and pointlessness proof. Failure
of the degree-`19` construction is not enough.

### Decision exits for Attempt 3

`P3` qualifying curve constructed; residual degree two gives a point; close
positively. `N3` explicit boundary-zero pointless twist constructed; close
negatively. `N3-SCOPED` all qualifying degree-`19` curves excluded; only the
Schur rescue branch is closed. `STOP-3` marked Hilbert components survive
without a decision; record exact equations and dimensions; pass to Attempt 4.

### Deliverables

```text
certificates/schur_degree19/IMPLICATION_AUDIT.md
certificates/schur_degree19/betti_tables.json
certificates/schur_degree19/rao_resolutions.*
certificates/schur_degree19/marked_hilbert.*
certificates/schur_degree19/quintic_carriers.*
certificates/schur_degree19/SEAL.json
```

---

## Attempt 4 — KLS minimality, conductor, and foliation

### 4A. Objective

Prove an all-degree negative theorem for a primitive minimal rank-four
self-covariant by coupling minimality to conductor geometry. The exact
missing structure is

\[
\text{minimality}\Longrightarrow\text{avoidance/control of non-plt conductor places}
\]

together with control of how many source components dominate each conductor
component. Normality, log canonicity, or plt alone are **not** accepted
substitutes; explicit countermodels already show they are insufficient.

### 4B. Gate 1 — formalize the target theorem

Before calculation, state a theorem with hypotheses strong enough to imply a
contradiction and weak enough to be forced by minimality. It must explicitly
control: conductor components with `A_E(H^nu, C) <= 0`; multiplicities of
source components above each conductor divisor; invariant common factors `h`;
degree loss in the normalized Gauss map; Darboux-invariant leaf divisors; the
relation to primitive minimal degree. No proof by slogan "minimality removes
the conductor" is allowed.

### 4C. Gate 2 — minimality descent

**Task 4C.1 — degree-lowering operation.** From a forbidden conductor
configuration produce a lower-degree primitive rank-four covariant; or a
factorization through a lower-degree equivariant endomorphism; or a
contradiction to saturation/primitivity. Track every gcd and conductor factor.

**Task 4C.2 — source-component bound.** Prove a uniform bound on the number
and multiplicity of source components dominating one conductor component,
derived from the map, not assumed from plt geometry.

**Task 4C.3 — Hodge-center coupling.** Use the Hodge-center theorem only
after surviving center channels are geometrically constrained by KLS. The
desired contradiction has the form: required Hodge-carrying centers +
minimal conductor budget `>` available base-locus/intersection budget. A
character count without geometric realizability is insufficient.

### 4D. Gate 3 — global inequality

Derive a degree/discrepancy inequality excluding every non-Klein minimal
image, covering stable invariant components; proper-stabilizer component
orbits; nonnormal images; repeated conductor factors; the known orbit lengths.

### Decision exits for Attempt 4

`N4` every primitive minimal rank-four covariant excluded; combine with
exhaustiveness and close negatively. `P4-STRUCTURE` the argument forces a
unique geometric configuration; use it as an explicit construction target.
`COUNTEREXAMPLE-4` a genuine countermodel satisfying all proposed hypotheses
is found; record it and retire the theorem. `STOP-4` the missing implication
is isolated but not proved; do not launch a bounded KLS scan.

### Deliverables

```text
certificates/kls_minimality/TARGET_THEOREM.md
certificates/kls_minimality/degree_lowering.*
certificates/kls_minimality/component_bound.*
certificates/kls_minimality/hodge_coupling.*
certificates/kls_minimality/GLOBAL_INEQUALITY.md
certificates/kls_minimality/SEAL.json
```

---

## Attempt 5 — Globalized nonlinear strata machine

### 5A. Objective

Re-evaluate the obstruction machine at the only remaining meaningful level:
determine whether the **global** compatible leading states are forced into
the rank-drop locus of the nonlinear lifting operators, or meet the
generic-surjective locus. Do not continue generic local lifting computations
without first answering this global-image question.

### 5B. Gate 1 — image of global states in leading-jet space

Let `Lambda_{m,d}` be the corrected global inverse-limit module and
`B_{m,d}` the leading-jet parameter space for `a_m`. Construct the
scheme-theoretic image `G_{m,d} subseteq B_{m,d}` of global compatible
states. Compare with the rank-drop loci

\[
\mathcal R_{1,m}=V(\operatorname{Fitt}\operatorname{coker}L_1),
\qquad
\mathcal R_{3,m}=V(\operatorname{Fitt}\operatorname{coker}L_3).
\]

Required decision: `G_{m,d} subseteq R_{3,m}` or
`G_{m,d} ∩ (B_{m,d} \ R_{3,m}) != empty`. A sample point is insufficient
unless characteristic-zero and global compatibility are certified.

### 5C. Fork A — obstruction on rank drop

Only if global states are forced into rank drop.

**5C.1** Compute the restriction of `omega_3 in coker L_3` to `G_{m,d}`.
**5C.2** Impose simultaneously: source-line coefficient coupling; `V_4`-line
conditions; `C_3/A_4/C_6` restrictions; marked elliptic data; irrelevant
torsion; all global `G`-equalizers.
**5C.3** Prove periodicity, finite generation, or a monotonicity theorem
reducing all odd `m` and degrees `d` to finitely many obstruction
calculations. Without such a theorem, finite bidegree kills remain scoped.

Exit: `N5` every global family killed; close negatively. `N5-SCOPED` one
family or bidegree killed; record only that.

### 5D. Fork B — construction through generic surjectivity

If a global state meets the generic-surjective locus.

**5D.1** Upgrade the observed `m=1,3` pattern to a proof for every odd `m`:
`L_1` and `L_3` generically surjective, with nullities `4` and `8`, or state
corrected formulas.
**5D.2** Derive the general polar recursion; identify the newest correction
operator at every nonautomatic order; prove surjectivity at all stages on a
common open, or a finite periodic pattern.
**5D.3** Global formal lifting via equivariant Serre vanishing, corrected
coefficient couplings, exact character projectors. **No naive averaging of
affine solution torsors.**
**5D.4** Algebraization: prove the compatible formal lift comes from an
actual polynomial covariant — finite determinacy; Artin approximation plus
equivariant algebraization; explicit termination; or a finitely generated
Rees-module solution. **A formal power series alone is not a positive
result.**

Exit: `P5` actual homogeneous landing covariant obtained; verify and close
positively. `P5-FORMAL` unobstructed formal lift proved but algebraization
open; record exact algebraization gate. `STOP-5` neither fork advances;
retire the strata machine from the active queue.

### Deliverables

```text
certificates/global_lifting/GLOBAL_STATE_IMAGE.md
certificates/global_lifting/global_state_image.*
certificates/global_lifting/rank_drop_restriction.*
certificates/global_lifting/all_m_rank_theorem.*
certificates/global_lifting/higher_recursion.*
certificates/global_lifting/algebraization.*
certificates/global_lifting/SEAL.json
```

---

## 6. Dispatch order and resource allocation

### 6.1 Priority

1. Attempt 1: primary positive route.
2. Attempt 2: parallel negative route.
3. Attempt 3: begin after Attempt 1 Gate 1 is complete.
4. Attempt 4: structural background track only.
5. Attempt 5: begin only with the global-state-image calculation; no generic
   higher tower before that.

### 6.2 First dispatch

The first dispatch is limited to:

1. Attempt 1, Gate 1: CFOSS `w_1` source audit; common-isotropic-line
   implication audit.
2. Attempt 1, Gate 2: quaternion-corner formulation; homogeneous-space/torsor
   classification.
3. Attempt 2, Gate 1: exact specification of the global Cramer-saturated fold
   component; normalization and conductor data model.
4. Attempt 5, Gate 1: formulate the scheme-theoretic image of global states in
   leading-jet space; emit size estimates only.

**No large elimination is part of the first dispatch.**

### 6.3 Director gate after first dispatch

The gate report must select exactly one of:

1. Pfaffian bridge closes abstractly: finish Attempt 1.
2. Pfaffian coordinate system is now small: authorize its exact solve.
3. Target-branch normalization is near closure: prioritize Attempt 2.
4. Global states are forced into rank drop: prioritize Attempt 5A.
5. No route crosses its first gate: start Attempt 3 and retain Attempts 4-5
   as structural tracks.

---

## 7. Software and hardware policy

### 7.1 Free software only

No Magma dependency. Preferred: GAP, Macaulay2, Singular/Singular.jl,
OSCAR/Nemo/Hecke, Groebner.jl, PARI/GP, python-flint, msolve, Normaliz,
custom sparse exact linear algebra. Use absolute binary paths where shell
aliases are known to be dangerous.

### 7.2 Memory gates

- Ordinary exploratory ceiling: 8 GB RSS.
- Structurally justified sealed job: up to 96 GB RSS after director approval.
- No concurrent memory-saturating jobs.
- Stream sparse rows, transformation circuits, and checkpoints.

Before any job expected to exceed 8 GB, emit: matrix/module dimensions; term
count; sparse memory floor; dense memory floor; expected certificate;
checkpoint plan; independent verifier design.

### 7.3 Characteristic-zero discipline

Finite fields may be used for discovery; rank-shape selection; pivot
selection; sparse support design. A characteristic-zero claim requires exact
computation over `Q` or the relevant number/function field, or a written
DVR/properness/rank-preservation argument with every hypothesis checked.

---

## 8. Universal house rules

1. No headline claim from an auxiliary point. Prove the bridge to the generic
   Klein twist.
2. No unstructured degree or chart sweep.
3. No finite-state or linear-strata obstruction campaign. Those routes are
   structurally closed.
4. No generic local lifting continuation before computing the image of global
   states.
5. No full class-group computation when only the `3`-primary quotient matters.
6. No pointwise singularity treatment when the critical locus is
   positive-dimensional.
7. No naive averaging of affine torsors. Use character projectors and prove
   stability.
8. No formal lift called a covariant.
9. No exclusion of one construction advertised as non-unirationality.
10. No positive claim from a divisor of degree `2` until the residual-line
    argument is checked over the correct field.
11. No KLS theorem based only on normality, lc, or plt.
12. Stop and certify any exact invariant obstruction independent of all
    admissible corrections.
13. Every producer has an independent verifier that does not import it.
14. Every artifact states its exact theorem boundary.
15. Update route ranking only at a director gate.

---

## 9. Final decision table

| Exit | Meaning | Headline consequence |
|---|---|---|
| `P1`, `P3`, or `P5` | exact `K_proj`-point or landing covariant | `G`-unirational; `ed_C(G)=3` |
| `N2`, `N3`, or `N4` | exact pointless generic/residue twist or exclusion of all landing covariants | not `G`-unirational; `ed_C(G)=4` |
| scoped negative | one construction/family excluded | no headline conclusion |
| formal survivor | formal state or lift survives | no headline conclusion |
| dangerous `3`-class | target-branch negative route fails | no headline conclusion |
| no gate crossed | all five attempts remain open | preserve exact interfaces; no new sweep |

---

## 10. Required status update

After each accepted gate, update only `HANDOFF.md`, `CURRENT_PATHS.md`,
`RESOLUTION.md`, `SPEC.md`. Each update must include: exact commit and
artifact hashes; theorem boundary; replay commands; director decision;
revised ranking; explicit statement that Problem E remains open unless a
final exit above has been reached.
