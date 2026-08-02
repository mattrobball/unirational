# Goal G7 — double-`A5` eleven-point design and cross-residual geometry

**Audited parent state:** `0aecc89f0598cfd982295107352e6cc6e9fb04e9`  
**Priority:** 1  
**Parent goals:** G3 and G4  
**Headline direction:** positive

## Mission

Exploit the interaction between the two nonconjugate maximal `A5` classes in

\[
G=\operatorname{PSL}_2(\mathbf F_{11}).
\]

Each class gives an exact generic `A5`-twist point and hence, after induction
to the generic `G`-torsor, an eleven-point closed subscheme of the universal
cubic

\[
X_{\rm gen}=V(\Phi)\subset\mathbf P^4_{K_{\rm proj}}.
\]

Goal G4 treats each induced cycle separately.  G7 must construct the exact
cross-incidence correspondence between the two eleven-element coset schemes
and apply it simultaneously to both point cycles.  The expected constant
combinatorics is the symmetric `2-(11,5,2)` design, but no design identity may
be consumed until reconstructed from the installed group generators.

The target is a `K_proj`-point of `X_gen`, a `K_proj`-defined line on `X_gen`,
or an effective length-two subscheme whose third-intersection construction
gives a `K_proj`-point.

## Binding inputs

Consume and hash

```text
goal_runs_after_35fa/H_A5_TWISTS/
goals_after_35fa8f/H_A5_TWISTS/
goals_after_141f60/GOAL_G4_A5_INDEX11_TRANSFER.md
goal_runs_after_35fa/G_UNIVERSAL/
goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json
```

and, when available,

```text
goal_runs_after_141f60/G4_A5_INDEX11_TRANSFER/
goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE/
```

Keep the two `A5` classes and their two etale algebras distinct.  A coordinate
renaming is not an identification of the classes.

## G7.0 — exact two-class subgroup geometry

From the exact 660-element group, reconstruct:

1. both conjugacy classes
   \(
   \mathcal H=\{H_0,\ldots,H_{10}\}
   \)
   and
   \(
   \mathcal K=\{K_0,\ldots,K_{10}\}
   \)
   of maximal `A5` subgroups;
2. the two degree-eleven permutation actions;
3. every cross-intersection `H_i intersect K_j`, including its order and
   isomorphism type;
4. all `G`-orbits on `mathcal H x mathcal K`.

Identify the unique nontrivial cross-relation, if it exists, giving five
neighbors on each side.  The expected test is that incident pairs have
intersection of order 12 (typically `A4`) and nonincident pairs have the other
intersection type (expected order 10), but the worker must derive rather than
assume this.

Let `N` be the resulting `11 x 11` zero-one incidence matrix.  Prove or refute
exactly:

```text
row sums = column sums = 5;
any two rows meet in 2 columns;
any two columns meet in 2 rows;
N*N^t = 3*I + 2*J;
N^t*N = 3*I + 2*J.
```

Also compute the full automorphism action on the point-block design and verify
that the installed `G` action is the one being used.

Required return:

```text
G7-PALEY-BIPLANE-IDENTIFIED
```

or an exact corrected design statement.  A database label or literature
citation is not a verifier.

## G7.1 — permutation modules and incidence projectors

Over the exact character field and over the actual descent field, decompose
both permutation modules.  Verify rather than assume the expected shape

\[
\mathbf 1\oplus W\oplus W'.
\]

Tasks:

1. compute character values, fields of definition, and primitive central
   idempotents;
2. identify which five-dimensional constituent is the Klein representation
   and which is the companion;
3. determine whether Galois conjugation interchanges them;
4. express all projectors in the two coset bases;
5. compute the action of `N` and `N^t` on every constituent;
6. on the augmentation modules, verify the exact inverse relation arising
   from `N^t*N=3I`, including characteristic and denominator gates;
7. reconcile the two nonconjugate `A5` point formulas with the constituent
   labels.

Deliver exact rational matrices over the smallest correct field.  Do not adjoin
`sqrt(3)` merely to diagonalize an operator if the rational inverse
`(1/3)N^t` on augmentation already suffices.

## G7.2 — projective-lift and scaling gate

The induced cycles consist of projective points.  Addition of point coordinates
is meaningless until compatible cone lifts or multihomogeneous tensors are
specified.

Before applying an incidence sum, prove one of the following exact interfaces:

1. the installed `A5` formulas supply Galois-compatible nonzero vectors in the
   twisted affine cone with a common, audited normalization; or
2. every operation is written as a multihomogeneous projective construction
   independent of the individual scalings.

For any affine normalization, record the nonvanishing coordinate or linear
form, prove it is a unit on the advertised open, and prove Galois compatibility.
For tensor methods, record the degree in every point variable.

The verifier must deliberately rescale every input point independently and
check that each advertised projective output is unchanged.  A packet that
silently sums arbitrary homogeneous representatives fails this gate.

Required marker:

```text
G7-PROJECTIVE-SCALING-PASS
```

## G7.3 — materialize the two induced cycles

Consume `G4-INDUCED-DEGREE11-POINT-PASS` when it exists.  Otherwise this work
package may reconstruct only the minimum required induction, without repeating
G4's later one-class searches.

For the two classes, construct

\[
P=\{p_0,\ldots,p_{10}\},
\qquad
Q=\{q_0,\ldots,q_{10}\}
\]

as reduced degree-eleven finite-etale subschemes of `X_gen`.  Verify:

- all 22 points satisfy `Phi=0`;
- the Galois actions agree with the two computed coset actions;
- the cycles are defined over `K_proj`;
- both degree-eleven algebras are integral on an explicit common open, or give
  the exact factorization if not;
- every field and frame map agrees with G3A.

Construct the incidence correspondence as an exact map between the two etale
algebras, not merely as a constant matrix detached from their descent data.

## G7.4 — complete cross-class operation space

Enumerate the canonical operations generated by the incidence correspondence
through cubic arity.  At minimum include:

```text
incidence and complementary-incidence transforms;
augmentation and the two five-dimensional projectors;
first, second, and third moment tensors of P and Q;
contractions with the polarization B of Phi;
cross-incidence sums in every scale-safe affine chart;
kernels and images of the induced tensor maps;
G-invariant and W-isotypic lines in the resulting operation space.
```

For each nonzero projective vector output:

1. express it in the G3A frame;
2. evaluate `Phi` exactly;
3. if it does not land, compute the smallest canonical one- or two-parameter
   family generated by the same operation space;
4. solve the resulting cubic, conic, or genus-one equation over `K_proj`;
5. verify any point independently.

The worker must enumerate the full finite operation space specified above,
not test one aesthetically chosen incidence sum.

## G7.5 — cross-secants and third intersections

For every ordered pair of points `p_i,q_j`, let `B` be normalized by
`Phi(x)=B(x,x,x)`.  When the line is not contained in the cubic, its third
intersection is represented by

\[
r_{ij}=
B(p_i,q_j,q_j)p_i-B(p_i,p_i,q_j)q_j.
\]

Derive and verify this formula in the installed polarization convention.  It
is multihomogeneous of the same bidegree in the two points and hence
projectively meaningful.

Separate the 55 incident and 66 nonincident pairs.  Compute exactly:

1. vanishing, coincidence, and line-contained loci;
2. the Galois orbit decomposition of the third points;
3. linear spans and equations of the incident and nonincident residual cycles;
4. all design-weighted traces, moment tensors, and residual intersections;
5. whether either residual cycle contains a `K_proj`-rational component,
   fixed point, line, plane conic with residual line, or effective degree-two
   subscheme;
6. all secant, trisecant, tangent, scroll, and low-degree surface loci forced by
   the `2-(11,5,2)` incidence identities.

Any reduction in cycle degree must be an **effective scheme-theoretic**
construction.  Signed zero-cycle arithmetic or a class in `CH_0` is not enough.

## G7.6 — effective degree two and headline bridge

If the construction gives a `K_proj`-defined effective length-two subscheme
`Z subset X_gen`, take its scheme-theoretic span.

- If the span is a line not contained in `X_gen`, compute the residual third
  intersection and prove it is a `K_proj`-point.
- If the line is contained in `X_gen`, prove that the descended line is an
  actual `P^1_{K_proj}` inside the cubic and choose a rational point.
- For a nonreduced length-two scheme, use the tangent-line intersection with
  exact multiplicity control.

For any direct point, line, or residual point:

1. verify it in `Phi` over the authoritative field;
2. clear denominators through G2;
3. verify the original Klein equation and equivariance;
4. consume the G3A dominance ledger;
5. provide `BRIDGE_DOUBLE_A5_POS.md`.

## Deliverables

Write under

```text
problems/E-klein-cubic/goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/
```

Provide at least

```text
INPUT_MANIFEST.json
SUBGROUP_CLASSES.md
subgroups.json
DESIGN.md
incidence_matrix.json
PERMUTATION_MODULES.md
projectors.json
PROJECTIVE_SCALING.md
INDUCED_CYCLES.md
induced_cycles.json
CROSS_OPERATIONS.md
operations.json
THIRD_INTERSECTIONS.md
residual_cycles.json
EFFECTIVE_CYCLES.md
POINT.md when obtained
BRIDGE_DOUBLE_A5_POS.md when applicable
produce_group.py
produce_cycles.py
produce_geometry.py
verify_design.py
verify_scaling.py
verify_cycles.py
verify_geometry.py
verify_point.py
verify_all.py
REPLAY.md
SHA256SUMS
SEAL.json
STATUS.md
```

## Authorized exits

```text
G7-POINT-HEADLINE-POSITIVE
G7-EFFECTIVE-DEGREE2-HEADLINE-POSITIVE
G7-PALEY-BIPLANE-IDENTIFIED
G7-CROSS-CLASS-PROJECTOR-PASS
G7-INDUCED-DOUBLE-CYCLE-PASS
G7-RESIDUAL-GEOMETRY-PASS
G7-DESIGN-CORRECTION
G7-UNDECIDED
G7-CANONICAL-INPUT-FAIL
```

Only the first two exits are Problem-E headline candidates.  The design and
cycle exits are structural inputs for the next stage.