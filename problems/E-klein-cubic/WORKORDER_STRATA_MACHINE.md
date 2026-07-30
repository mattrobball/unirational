# Problem E — work order: exact stabilizer strata and the normal-cone transition machine

Worker: local research agent.
Authored: 2026-07-30.
Repository: mattrobball/unirational.
Pinned repository base: `0ec8a2349f8dc749bc100f78404469063337b43a`.
Primary external input: `strata.md`, SHA-256
`df9b12df888c76ef3cc4ae0456f89a27f9fe54285d4f93ebbf8cd63d6ec37512`.
Intended repository path for this order:
`problems/E-klein-cubic/WORKORDER_STRATA_MACHINE.md`.
No Magma dependency is permitted.

## Mission

Turn the candidate stabilizer stratification of

\[
Y=\mathbf P(W)\simeq \mathbf P^4,
\qquad
X=\left\{\sum_{i\in\mathbf Z/5}x_i^2x_{i+1}=0\right\}\subset Y,
\qquad
G=\operatorname{PSL}_2(\mathbf F_{11}),
\]

and the existing Problem E arrangement calculations into a portable,
characteristic-zero, all-degree necessary-condition machine for a hypothetical
nonzero homogeneous landing self-covariant

\[
p:W\longrightarrow W,
\qquad F(p)=0.
\]

The machine must retain:

1. the complete stabilizer-stratum incidence category in `Y` and `X`;
2. tangent and normal representations at every orbit type;
3. first nonzero normal jets along every forced base stratum;
4. the associated-graded Klein-cubic landing equations;
5. compatibility under all relevant incidences and iterated normal cones;
6. the marked residual-normalizer geometry on the involution fixed line and
   elliptic curve;
7. the existing symbolic 55-plane arrangement and relative border/Fitting
   presentation.

The preferred outcome is an all-degree obstruction. A surviving formal state
is not a positive solution: it must be lifted to an actual landing covariant
before any affirmative conclusion is allowed.

## Governing headline and proof standard

Problem E remains open, with the exact reduction

\[
X\text{ is }G\text{-unirational}
\quad\Longleftrightarrow\quad
\operatorname{ed}_{\mathbf C}(G)=3.
\]

A negative result from this work order must therefore exclude every nonzero
homogeneous landing self-covariant in characteristic zero, not merely a finite
degree range, one support pattern, one modular fiber, or one resolution model.

The existing exhaustiveness theorem may be used: any dominant equivariant map
from any honest linear source forces a nonzero homogeneous self-covariant
`W -> W` landing in `X`, and every such nonzero landing covariant is
automatically dominant.

## Repository audit: what already exists

This order is not a restart. Preserve and reuse the following work.

### A. Portable, tracked exact infrastructure

The tracked `certificates/` package already provides:

- exact matrices over `Q(zeta_11)` for the faithful five-dimensional action;
- exact enumeration of all 660 group elements and Klein-cubic invariance;
- exact Molien dimensions and primitive covariants;
- exact subgroup checks in `certificates/subgroup_orbit_check.py`, including:
  - the unique `D12` character line is off `X`;
  - the unique `D10` character line is off `X`;
  - both `A4` character lines are off `X`;
  - the exact `C3 < C6/S3 < D12` index-two chains;
  - irreducibility on `A5` and `11:5`;
- exact `C5` and `C11` secant configurations and the effective orbit degrees
  `60,132,165,220`;
- the portable low-degree and generic-frame certificates listed in
  `certificates/CHECKS.md`.

These files are the characteristic-zero representation source of truth. Do
not reconstruct a different representation unless it is explicitly conjugated
to this one and the conjugacy is certified.

### B. Documented and replayed locally, but presently under ignored `tmp/`

`HANDOFF.md` records the following as completed local work:

1. **Involution geometry.** For every involution,
   `(dim E_plus, dim E_minus)=(3,2)`; the plus-plane section is a smooth plane
   cubic; the minus-line lies entirely on `X`; every plus-plane is a forced
   codimension-two base component; its common transverse order is odd; and the
   leading normal map may dominate the corresponding fixed line.
2. **Local `V4` geometry.** The joint-character dimensions are `(2,1,1,1)`;
   the three fixed lines form a triangle; the three plus elliptics have the
   recorded incidences; the three additional common fixed points form a
   reduced set; triangle vertices and tangent characters were computed.
3. **Finite transition audit.** Both endpoint-preserving and
   endpoint-swapping local transitions occur. The bare Problem F path graph
   closes rather than obstructs.
4. **The 55-plane arrangement.** It has 55 triple lines and 121 multiple
   points, comprising 66 `D10` points and 55 `D12` points, all off `X`.
5. **Local symbolic presentations.** The `D10` and `D12` symbolic local
   models have been constructed for every symbolic order `m`.
6. **Global symbolic architecture.** For fixed `m`, the correct construction
   is

   ```text
   plane normalization -> triple-line equalizer -> residual D10/D12 point kernel
   ```

   and computes the sheaf associated to `I^(m)/I^(m+2)`. The tempting short
   four-term Cech complex is false. A finite irrelevant-torsion module `T_m`
   controls the difference between the compact/sheaf construction and literal
   low-degree graded pieces.
7. **Degree-25 compact and nonlinear systems.** The `m=1`, degree-25 compact
   complex, its `59 -> 43 -> 6 -> 0` landing filtration, the complete rank-842
   cubic system, and the rank-28 border presentation have been constructed.
   Degree 25 remains open; the characteristic-zero landing locus is known only
   to have dimension at most 15.

These are not portable GitHub artifacts: `problems/E-klein-cubic/tmp/` is
ignored. The worker must first verify that the local files actually exist and
match the hashes/manifests described in `HANDOFF.md`. Documentation alone is
not a substitute for an artifact.

### C. Genuinely missing or not yet integrated

The repository does not currently contain a portable certificate for:

- the complete ambient and Klein-cubic stabilizer stratifications;
- the full incidence poset including the `C3` lines, the two `C6` point types,
  the two `A4` point types, and the two `V4` point types;
- tangent and normal representations for every stratum and every incident
  flag;
- the marked residual `S3` geometry of the involution fixed line and elliptic
  curve;
- the proposed `E[2]`-charge interpretation of type-I versus type-II `V4`
  points;
- local normal-cone transition modules at the `C3`, `C6`, and two `A4` strata;
- a global all-order inverse-limit/transition object incorporating these new
  strata;
- an all-degree emptiness theorem for the nonlinear landing support.

## Mandatory input reconciliation

The supplied `strata.md` is candidate input, not yet a characteristic-zero
certificate. It also contains an internal inconsistency:

- its incidence table says that every type-II `V4` point lies on three fixed
  elliptic curves;
- its final sentence says that two positive-dimensional fixed-locus closures
  can meet only at type-I points.

These statements cannot both be correct. No later work package may silently
choose one. **WP-1 must decide the exact incidence and update the theorem
statement accordingly.**

The candidate counts to test are:

### Candidate positive-dimensional ambient strata

| Type             | Closure | Number |
|------------------|--------:|-------:|
| involution plane | `P^2`   | 55     |
| involution line  | `P^1`   | 55     |
| `V4` fixed line  | `P^1`   | 55     |
| `C3` eigenline   | `P^1`   | 110    |

### Candidate ambient point orbits

| Exact stabilizer | Number |
|------------------|-------:|
| `D10`            | 66     |
| `C5^(a)`         | 132    |
| `C5^(b)`         | 132    |
| `C11`            | 60     |
| `D12`            | 55     |
| `C6^(line)`      | 110    |
| `C6^(plane)`     | 110    |
| isolated `V4`    | 165    |
| `A4^(a)`         | 55     |
| `A4^(b)`         | 55     |

### Candidate nonfree strata on `X`

| Exact stabilizer | Closure            | Number |
|------------------|-------------------:|-------:|
| `C2`, plus type  | smooth plane cubic | 55     |
| `C2`, minus type | line               | 55     |
| `C6`             | point              | 110    |
| `V4`, type I     | point              | 165    |
| `V4`, type II    | point              | 165    |
| `C11`            | point              | 60     |
| `C5^(a)`         | point              | 132    |
| `C5^(b)`         | point              | 132    |
| `C3`             | point              | 220    |

## The structural theorem to prove before the large computation

Let `S` be a smooth stabilizer stratum in `Y`, with generic projective
stabilizer `H`, ideal `I_S`, and normal bundle `N_{S/Y}`. If a homogeneous
landing covariant `p` has first nonzero order `m` along `S`, then its initial
normal term is an `H`-equivariant section of

\[
\operatorname{Sym}^m N_{S/Y}^{\vee}
\otimes \mathcal O_S(d)
\otimes W,
\]

and its associated-graded Klein cubic must vanish. For an incidence
`S' subset closure(S)`, these initial terms specialize compatibly to the
corresponding normal-cone data at `S'`.

The machine theorem required by this work order is:

> **Normal-cone necessity theorem.** Every nonzero homogeneous landing
> self-covariant determines a compatible element of the all-order inverse
> limit of the stabilizer-decorated associated-graded landing modules defined
> below.

Only the forward implication is required. Thus emptiness of the inverse limit
is a valid negative theorem. Nonemptiness supplies only a necessary formal
configuration and is not a positive solution.

The proof must explicitly handle:

- symbolic rather than ordinary powers along the union of conjugate strata;
- finite irrelevant torsion in low graded degree;
- iterated incidences at triple lines and multiple points;
- the absence of a globally exact short Cech complex;
- arbitrary order and degree, with no global degree bound;
- projective scalar characters and primitive reduction.

## Work package 0 — freeze the audited base and recover local provenance

### Tasks

1. Pin the repository commit and record versions of every free CAS used.
2. Verify the hashes/manifests for every existing `tmp/` packet consumed by
   this order, especially:

   ```text
   tmp/involution_exceptional_divisor/
   tmp/d12_line_restriction/
   tmp/v4_surface_slice_audit/
   tmp/plane_arrangement_hilbert/
   tmp/d12_block_attack/
   tmp/local_symbolic_rees/
   tmp/higher_compatibility_regularity/
   tmp/ordinary_defect_support/
   tmp/symbolic_compatibility_complex/
   tmp/m1_compact_degree25/
   tmp/m1_relative_border_rank28/
   ```

3. Classify each claimed input as:

   ```text
   TRACKED-PORTABLE
   LOCAL-REPLAYED
   LOCAL-MISSING
   DOCUMENTATION-ONLY
   REFUTED/SUPERSEDED
   ```

4. Move or reconstruct only the compact scripts, manifests, hashes, and proof
   notes needed for portability. Do not commit the multi-gigabyte scratch tree.
5. Write `certificates/STRATA_MACHINE_INPUT_AUDIT.md`.

### Acceptance gate

The audit must contain a row for every existing result used later, with an
exact file path, hash, replay command, mathematical conclusion, and theorem
boundary. Missing local artifacts must be marked missing and rebuilt; they may
not be treated as trusted inputs.

## Work package 1 — exact characteristic-zero stabilizer stratification

### Objective

Reproduce and certify the full candidate table and incidence poset using the
repository's exact action, without Magma.

### Algebraic strategy

Use the exact matrices from `certificates/exact_weil_check.py`. Work over
minimal cyclotomic extensions where practical; a single splitting fallback is

\[
K=\mathbf Q(\zeta_{165}),
\]

which contains the eigenvalues required for elements of orders 3, 5, and
11. Do not inflate every calculation to `K` if subgroup idempotents or
minimal extensions suffice.

### Tasks

1. Enumerate all 660 exact matrices and element orders.
2. Enumerate conjugacy classes of relevant subgroups using GAP.
3. Construct every projective eigenspace of every nonidentity element.
4. Close the collection under intersections until stabilization, not just
   through one pairwise pass.
5. For every resulting projective linear subspace:
   - compute its exact generic projective stabilizer;
   - compute its setwise stabilizer and normalizer action;
   - partition its `G`-orbit;
   - identify the abstract stabilizer with GAP;
   - produce an exact basis over a stated number field.
6. Intersect every component with `X` scheme-theoretically.
7. Compute exact irreducible decomposition, reducedness, dimension, degree,
   smoothness, and generic stabilizer of every intersection component.
8. Construct the complete incidence matrix in `Y` and in `X`.
9. Resolve the type-I/type-II incidence inconsistency in the supplied input.
10. Independently replay the orbit and incidence counts at split primes
    `67`, `89`, and `331` as regression checks, without using them as the
    characteristic-zero proof.

### Required artifacts

```text
certificates/strata/exact_strata.py
certificates/strata/group_subgroups.g
certificates/strata/geometry.sage
certificates/strata/verify.py
certificates/strata/strata_exact.json
certificates/strata/incidence_exact.json
certificates/STRATA_EXACT.md
```

The JSON files must record exact defining fields, bases, equations,
stabilizer generators, normalizer generators, orbit sizes, and incidence IDs.

### Acceptance gate

- Every candidate count is either exactly certified or explicitly corrected.
- Every incidence count passes double counting from both sides.
- The positive-dimensional fixed loci on `X` agree with the published fixed
  locus data.
- The characteristic-zero and three split-prime incidence graphs have the
  same labeled orbit structure.
- A second script reconstructs the incidence graph from the JSON without
  calling the producer.

## Work package 2 — tangent and normal character decorations

### Objective

Decorate the exact incidence category with the representation data needed for
first nonzero normal jets.

### Tasks

For one exact representative of every stratum orbit, compute:

1. the generic stabilizer `H` and setwise stabilizer `N_G(S)`;
2. the residual action `N_G(S)/H`;
3. the `H`-linearized restriction of `O_Y(1)`;
4. the tangent representation `T_yY` at a generic point or point stratum;
5. when `y in X`, the tangent representation `T_yX` and normal character of
   `X` in `Y`;
6. for positive-dimensional `S`, the normal bundle and its generic fiber as
   an `H`-module;
7. for every incidence flag `S' subset closure(S)`, the tangent line or normal
   subspace corresponding to that flag;
8. the action of the residual normalizer on the full set of incident flags.

The mandatory orbit types are:

```text
C2 plane
C2 line
V4 line
C3 line
D10 point
D12 point
C6(line) point
C6(plane) point
V4 type-I point
V4 type-II point
A4(a) point
A4(b) point
C5(a), C5(b), C11 points
```

### Regression requirements

Recover exactly the already documented facts:

- involution decomposition `(3,2)`;
- `V4` joint-character dimensions `(2,1,1,1)`;
- the triangle of minus-lines;
- the recorded tangent representation at a triangle vertex;
- `D10`, `D12`, and both `A4` character lines off `X`.

### Required artifacts

```text
certificates/strata/normal_characters.json
certificates/strata/verify_normal_characters.py
certificates/NORMAL_CHARACTERS.md
```

### Acceptance gate

All tangent dimensions, determinant characters, and incidence inclusions must
be verified independently. Character decompositions must be exact over a
stated splitting field, with rational character checks where possible.

## Work package 3 — exact marked `S3` geometry on the involution fixed loci

### Objective

Replace the existing finite endpoint ledger by an exact geometric model of
the residual `S3` action on both fixed components.

Fix an involution `t`, and write

\[
X^t=E_t\sqcup L_t,
\]

where `E_t` is a smooth plane cubic and `L_t` is a line.

### Tasks on `L_t`

1. Write exact coordinates and the residual
   `N_G(<t>)/<t> ~= S3` action.
2. Locate and certify:
   - the two `C6` points;
   - the six type-I `V4` points;
   - their orbit decomposition under `S3`.
3. Determine the two size-three reflection orbits and the size-two
   order-three orbit intrinsically.
4. Compute tangent multipliers and all marked-point cross-ratios needed to
   classify equivariant self-maps of the line.

### Tasks on `E_t`

1. Put `E_t` into an exact Weierstrass model using SageMath/PARI or explicit
   ternary-cubic invariants.
2. Compute its exact `j`-invariant. The finite-field computation in the input
   suggests the candidate `j=-32768`; treat this only as a candidate until
   proved over characteristic zero.
3. Locate the three type-I and nine type-II `V4` points exactly.
4. Compute their residual `S3` orbit decomposition.
5. Determine whether the residual order-three element acts freely. If so,
   identify it as translation by an explicit nonzero `q in E_t[3]`.
6. Prove or refute the proposed torsion labeling:

   ```text
   type-I orbit   = <q>
   type-II orbits = e + <q>, for 0 != e in E_t[2]
   ```

   after an exact choice of origin.
7. Compute tangent directions and intersection multiplicities at every marked
   point, including all elliptic-line and elliptic-elliptic incidences.

### Free-tool implementation

Use SageMath, PARI/GP, Singular, and the existing exact cyclotomic matrices.
OSCAR/Nemo may be used for number-field arithmetic. No result may depend on a
Magma-only genus-one routine.

### Required artifacts

```text
certificates/strata/marked_s3_geometry.sage
certificates/strata/verify_marked_s3.py
certificates/MARKED_S3_GEOMETRY.md
```

### Acceptance gate

The proof note must state exactly which parts of the `E[2]`-charge picture are
theorems. If the proposed charge interpretation fails, retain the actual
finite `S3`-set and continue with that data rather than forcing the model.

## Work package 4 — universal local normal-cone transition modules

### Objective

Compute all local transition modules bigraded in source degree and normal
order, rather than extending the finite degree ladder.

The common format at a stratum `S` is the module

\[
\bigoplus_{m,d}
\left[
H^0\!\left(
S,
\operatorname{Sym}^m N_{S/Y}^{\vee}\otimes\mathcal O_S(d)
\right)
\otimes W
\right]^{H},
\]

with the associated-graded cubic landing equations and restrictions to every
incident lower stratum.

### WP-4A — portable involution-plane theorem

1. Recover the local `tmp/involution_exceptional_divisor/` result.
2. Produce a tracked proof that every plus-plane is a base component, the
   common first order is odd, and a nonzero leading map dominates the fixed
   minus-line.
3. Record the complete normal-character dependence, not only parity.

### WP-4B — universal `D12` binary line transitions

1. Recover `tmp/d12_line_restriction/`.
2. Present the full module of residual-`S3`-equivariant rational maps
   `P^1 -> P^1` over the binary invariant ring.
3. Classify in all degrees and normal orders:
   - endpoint preservation;
   - endpoint swapping;
   - extra endpoint vanishing;
   - behavior of the two `C6` points;
   - the possibility that the entire line remains based.
4. Express every transition as a restriction map to the exact marked strata
   from WP-3.

A finite list of examples is insufficient; the output must be a finite module
presentation or a theorem proving exhaustive periodicity/congruence classes.

### WP-4C — the `V4` fixed line and type-I/type-II charges

1. Prove that the ambient `V4` fixed line is a forced base component whenever
   its generic order-zero image would require an `A4`-fixed point on `X`.
2. Compute its normal bundle and all first nonzero normal-jet modules.
3. Determine which normal directions lead to:
   - the type-I triangle sector;
   - a type-II state;
   - an elliptic component;
   - a rational fixed line.
4. Track the exact marked state or `E[2]` charge under every incident flag.

### WP-4D — `C3` lines and `C6` endpoint data

For each of the two projective `C3` eigenline types:

1. compute the exact three-point intersection with `X`;
2. distinguish the `C6` point and the two exact-`C3` points;
3. compute the setwise stabilizer and residual action;
4. decide all possible order-zero restrictions;
5. if the line is forced into the base locus, compute its complete first
   normal-jet module and restrictions to its `C6` and `A4` endpoints.

### WP-4E — compulsory point links

Compute the complete associated-graded landing problem at:

```text
D10
D12
A4(a)
A4(b)
```

Retain every incident direction from the certified strata table:

- `D10`: five involution planes;
- `D12`: seven involution planes and three `V4` lines;
- each `A4` type: three involution planes, four `C3` lines, and one `V4` line.

For every possible first nonzero order and character, output:

```text
allowed type-I states
allowed type-II states / E[2] charges
allowed C6 states
allowed elliptic components
allowed rational-line components
restriction to every incident flag
```

### Required artifacts

```text
certificates/transitions/...
certificates/LOCAL_TRANSITION_MODULES.md
```

Each module must have a producer, a small independent verifier, a Hilbert or
Molien series, generators, relations, and an exact statement of the degrees
and orders it controls.

### Acceptance gate

The universal modules must reproduce all previously checked low-degree and
finite-state behavior as regression tests. Failure of finite generation or of
an expected periodicity is an acceptable result, but it must be proved or
precisely delimited.

## Work package 5 — global all-order transition diagram

### Objective

Assemble the local modules into the exact global necessary-condition object.
Do not call it a short Cech complex: the repository has already refuted that
model.

### Tasks

1. Define the stabilizer incidence category from `incidence_exact.json`.
2. Attach the bigraded local normal-jet module to every object.
3. Attach exact specialization/equalizer maps to every flag.
4. Incorporate the established fixed-`m` architecture:

   ```text
   plane normalization -> triple-line equalizer -> residual point kernel
   ```

5. Add the new `C3`, `C6`, `A4`, and marked elliptic/line data without
   collapsing it into the ordinary 55-plane ideal.
6. Separate three levels of computation:

   **Level 1: finite marked-state screen.**
   Ignore coefficients but retain stabilizers, characters, orbit labels,
   endpoint permutations, and type-I/type-II charges.

   **Level 2: linear bigraded inverse limit.**
   Compute compatible leading jets before imposing the cubic landing
   equations.

   **Level 3: nonlinear landing support.**
   Impose the associated-graded cubic equations and compute the projective
   support.

7. Prove that every actual landing covariant maps into this inverse limit.
8. Prove that all degrees and all possible odd plane orders are covered,
   through finite generation, a Rees-module presentation, or an exact
   semigroup/periodicity theorem.

### Decision exits

**Exit N1 — finite-state obstruction.**
If no globally compatible marked state exists, write the all-degree geometric
proof immediately. No Gröbner computation is needed.

**Exit N2 — linear-module obstruction.**
If finite states survive but the exact bigraded inverse-limit module is zero,
write the all-degree representation-theoretic proof.

**Exit N3 — nonlinear support obstruction.**
If the linear module survives but its projective landing support is empty in
characteristic zero, combine the machine theorem with the exact elimination
certificate to close Problem E negatively.

**Exit P — formal positive configuration.**
If a nonzero formal configuration survives, record it explicitly. It is only a
necessary state. Pass to WP-6 for lifting; do not call it a parametrization.

### Required artifacts

```text
certificates/global_transition/...
certificates/GLOBAL_TRANSITION_DIAGRAM.md
```

The proof note must distinguish sheaf-level exactness, literal graded pieces,
and finite irrelevant torsion in every claim.

## Work package 6 — integrate the surviving support with the border/Fitting system

Run this package only if WP-5 leaves a nonzero formal configuration.

### Existing input

Reuse the exact degree-25 data:

- compact ledger `673 -> 364 -> 59`;
- landing filtration `59 -> 43 -> 6 -> 0`;
- rank-842 cubic system;
- 833 monic relations plus a nine-equation determinantal tail;
- rank-28 border basis `{1,K_i,K_iK_j}`;
- finite projection to `P(Q)`;
- characteristic-zero bound `dim L_25 <= 15`.

### Tasks

1. Translate the WP-5 surviving state into sparse linear conditions on the
   rank-28 border module.
2. Add the new `C3`/`A4`/`C6` restrictions as sparse block rows, not by
   rebuilding the raw 43-variable system.
3. Compute commutator closure, neighbor syzygies, saturation, and Fitting
   support of the restricted module.
4. Use finite fields only for discovery and matrix-shape selection.
5. For any decisive empty projective support, produce either:
   - an exact characteristic-zero certificate; or
   - a projective-DVR properness argument with a complete good fiber and
     certified rank preservation.
6. If a point survives, reconstruct an exact candidate covariant and verify:
   landing, equivariance, primitivity, and dominance in characteristic zero.

### Stopping rule

Do not launch:

- a raw 43-variable projective solve;
- another unstructured degree ladder;
- a standard-chart sweep with no structural reduction;
- dense expansion of the global 5.49-GB degree-four block;
- isolated finite-field point tests advertised as geometric support.

A large run is authorized only after a precise sparse module and an expected
certificate format have been fixed.

## Work package 7 — theorem and certificate package

### Negative exit

A negative resolution must contain:

1. the normal-cone necessity theorem;
2. the exact strata and normal-character certificate;
3. the exact local transition modules;
4. the global all-order emptiness proof;
5. a clear implication from emptiness to absence of every homogeneous landing
   self-covariant;
6. the existing generic-torsor/exhaustiveness argument converting this to
   non-`G`-unirationality and `ed_C(G)=4`.

### Positive exit

A positive resolution must contain an explicit nonzero homogeneous covariant
and exact checks of:

1. `G`-equivariance;
2. `F(p)=0`;
3. primitivity/common-domain control;
4. characteristic-zero dominance.

A compatible formal state or point over one finite field is not sufficient.

### Repository deliverables

```text
problems/E-klein-cubic/WORKORDER_STRATA_MACHINE.md
problems/E-klein-cubic/certificates/STRATA_MACHINE_INPUT_AUDIT.md
problems/E-klein-cubic/certificates/STRATA_EXACT.md
problems/E-klein-cubic/certificates/NORMAL_CHARACTERS.md
problems/E-klein-cubic/certificates/MARKED_S3_GEOMETRY.md
problems/E-klein-cubic/certificates/LOCAL_TRANSITION_MODULES.md
problems/E-klein-cubic/certificates/GLOBAL_TRANSITION_DIAGRAM.md
```

Update `RESOLUTION.md`, `CURRENT_PATHS.md`, `HANDOFF.md`, and
`certificates/CHECKS.md` in the same final commit.

## Free software stack

Use freely available tools only.

### Group theory and representation bookkeeping

- GAP with AtlasRep, CTblLib, and standard subgroup/character tools;
- the repository's exact Python `Q(zeta_11)` implementation;
- SageMath for matrix groups, cyclotomic fields, and exact linear algebra.

### Algebraic geometry and commutative algebra

- Singular for exact ideals, primary decomposition, saturation,
  Jacobian/smoothness, and local computations;
- Macaulay2 for multigraded modules, symbolic powers, sheaf modules,
  Fitting ideals, and Hilbert functions;
- OSCAR / Nemo / Hecke / Singular.jl when their integrated
  number-field and module interfaces are advantageous;
- Normaliz and polymake for semigroups, incidence complexes, and
  combinatorial checks where relevant.

### Gröbner and sparse linear algebra

- msolve for finite-field and rational zero-dimensional screening;
- Groebner.jl for exact finite-field bases and change matrices when the
  interface fits the scale;
- FLINT-backed arithmetic through SageMath, python-flint, or Nemo;
- custom sparse/circuit linear algebra where the repository already has a
  verified format.

### Elliptic curves

- SageMath and PARI/GP;
- exact ternary-cubic invariant formulas checked in Singular/Sage;
- no Magma-only conversion or torsion routine.

## Hardware and execution policy

Assume a fully specified M5 Max MacBook Pro with approximately 128 GB unified
memory.

1. Parallelize by orbit type and independent prime, not by launching several
   memory-saturating Gröbner jobs simultaneously.
2. Every job expected to exceed 8 GB RSS must first emit:
   - matrix dimensions;
   - term count;
   - estimated sparse and dense memory floors;
   - certificate format;
   - checkpoint plan.
3. The ordinary exploratory gate is 8 GB.
4. A structurally justified sealed job may use up to 96 GB RSS, leaving system
   headroom, but only after the director gate accepts its formulation.
5. Stream matrices and transformation circuits; do not materialize a dense
   object when a sparse row/circuit verifier suffices.
6. Hash all large inputs and outputs. The committed certificate should be
   compact even when its producer uses large local files.
7. Use deterministic seeds and record package versions, thread counts, wall
   time, peak RSS, and exit status.

## House rules and known traps

1. **No Magma dependency.** Reproduce every useful Magma-derived claim from
   `strata.md` independently with the free stack.
2. **No silent repair of the strata table.** Resolve its type-II incidence
   inconsistency explicitly.
3. **No finite null search as a negative theorem.**
4. **No unbounded degree claim from finite module generation alone.** The
   quartic equivariant endomorphism produces degrees `4^n d` from one solution.
5. **No ordinary/symbolic conflation.** The ordinary point-supported defect
   theorem does not replace the symbolic line-supported cokernel.
6. **No false short Cech complex.** Use the proved iterative
   normalization/equalizer/kernel architecture and retain irrelevant torsion.
7. **No bare `V4` transition rerun.** The local triangle graph is already known
   to close.
8. **No claim that an `E[2]` charge exists until WP-3 proves it.**
9. **No characteristic-zero conclusion from one modular fiber** unless the
   properness/rank-lifting argument is written and its hypotheses checked.
10. **No positive claim from a formal leading state.** Lifting is a separate
    theorem.
11. **No proof depending only on ignored `tmp/`.** Every final input must have a
    portable script, proof note, and verifier.

## Dispatch order and review gates

**Gate 0 — input audit.**
Complete WP-0. Stop if essential local artifacts are missing until they are
reconstructed or removed from the trusted base.

**Gate 1 — exact strata.**
Complete WP-1 and WP-2. Director review must approve the characteristic-zero
strata table, incidence graph, and normal-character data before any new large
elimination.

**Gate 2 — marked fixed geometry.**
Complete WP-3. Decide whether the type-I/type-II distinction has an exact
`E[2]` interpretation or must remain a raw marked `S3`-set.

**Gate 3 — universal local modules.**
Complete WP-4, beginning with portable recovery of the existing involution and
`D12` packets, then the genuinely new `C3`/`C6`/`A4` links.

**Gate 4 — global structural decision.**
Complete Levels 1 and 2 of WP-5 before any nonlinear large job. An obstruction
here closes the problem without WP-6.

**Gate 5 — sparse nonlinear support.**
Only a surviving global state authorizes WP-5 Level 3 and WP-6.

## First dispatch

The first agent assignment is deliberately narrow:

1. complete `STRATA_MACHINE_INPUT_AUDIT.md`;
2. implement the GAP orbit/subgroup layer of WP-1;
3. implement exact eigenspace/intersection closure using the existing
   `Q(zeta_11)` matrices and minimal cyclotomic extensions;
4. reproduce the candidate orbit counts and identify the first discrepancy;
5. stop for Gate 1 review before computing normal jets or running any large
   Gröbner basis.

A successful first dispatch ends with a portable exact strata JSON packet and
an explicit verdict on the type-II elliptic-incidence inconsistency.

---

# Environment addendum (director, 2026-07-30)

*Appended by the director session on filing. Nothing above this line is
altered; the following are verified facts about the machine and repository
that the first dispatch will hit immediately.*

## Toolchain: most of the named stack is NOT installed

Verified on this machine (Apple M5 Max, 128 GB unified memory, 18 cores —
matching the hardware policy above):

| Tool                 | Status                        |
|----------------------|-------------------------------|
| `M2` (Macaulay2)     | present, `/opt/homebrew/bin/M2` |
| `msolve`             | present, `/opt/homebrew/bin/msolve` |
| `normaliz`           | present, `/opt/homebrew/bin/normaliz` |
| `python3`            | present, `/opt/homebrew/bin/python3` |
| **GAP**              | **NOT INSTALLED**             |
| **SageMath**         | **NOT INSTALLED**             |
| **Singular**         | **NOT INSTALLED**             |
| **PARI/GP**          | **NOT INSTALLED**             |
| Julia (OSCAR/Nemo/Hecke/Groebner.jl) | **NOT INSTALLED** |
| polymake             | **NOT INSTALLED**             |
| Magma                | not installed (and banned above) |

This directly blocks **First dispatch item 2** ("implement the GAP
orbit/subgroup layer"), WP-1 tasks 2 and 5, the required artifacts
`group_subgroups.g` and `geometry.sage`, and all of WP-3's SageMath/PARI
elliptic-curve work.

**SHELL ALIAS TRAP — read before scripting.** In this environment `gap` is
aliased to `git apply` and `gp` to `git push`. A script that invokes `gap`
expecting the CAS will **silently run a git command instead of failing**.
Never invoke `gap`/`gp` by bare name; use an absolute path and verify the
binary first.

**Resolution required before Gate 0 completes.** Either (a) install the
missing tools — note `brew info gap` reports no such formula, so GAP needs
`conda install -c conda-forge gap-defaults` or the gap-system.org bundle, and
SageMath likewise needs conda or the binary app; or (b) obtain director
approval to re-scope WP-1/WP-3 onto the present stack. Option (b) is
mathematically viable: the subgroup/conjugacy and character bookkeeping for
a 660-element group is well within exact Python over `Q(zeta_11)` (the
repository already enumerates all 660 matrices and does subgroup orbit checks
this way in `certificates/subgroup_orbit_check.py`), and the WP-3 Weierstrass
reduction can be done with explicit ternary-cubic invariant formulas in
exact arithmetic. Do not silently substitute tools without recording the
substitution in the input audit.

## Pinned base is four commits behind current `HEAD`

The pin `0ec8a23` is valid but now trails `origin/agent/weaken-hypotheses`.
Landed since, all on Problem E unless noted:

- `32c95ee` — foothold acceptance; `WORKORDER_ORDER12.md` issued.
- `71ba6bd` — overnight-campaign acceptance. **Relevant here:** the Fable
  positive branch was closed by two obstruction theorems (elliptic
  quadratic-trace; Veronese/Hilbert–Burch syzygy dichotomy), and the route
  ranking was rewritten to (1) Pfaffian descent, (2) unrestricted Schur,
  (3) KLS, (4) Fable-as-redesign.
- `79d3b89` — Problem G snapshot (unrelated).
- `5f555f8` — in-flight Klein-cubic delta: `D5` residue gate closed
  positively, `[K_proj : C(A,B,Y,Z)] = 6` proved.

Nothing in those commits contradicts this order — it attacks the **negative**
prong (all-degree exclusion of landing self-covariants) while the current
lead route attacks the positive prong (a `K_proj`-point via Pfaffian
descent). The two are complementary and share no machinery. Rebase the pin
to `5f555f8` or later unless the author intended the older base
deliberately.

## `strata.md` is not present on this machine

The "Primary external input" with SHA-256 `df9b12df…37512` was not found
anywhere on disk. Consequences:

- the hash-binding required by WP-0 cannot be performed until the file is
  supplied;
- however, the candidate tables **and** the exact type-I/type-II
  inconsistency to be resolved are reproduced verbatim in this order above,
  so WP-1 can proceed against the embedded data;
- record `strata.md` as `LOCAL-MISSING` in the input audit and do not cite
  any claim attributed to it beyond what is embedded here.

## WP-0 input packets: all eleven exist

All eleven `tmp/` packets named in WP-0 task 2 are present, each with a
`REPORT.md` and a `verify.py`. Hash/manifest verification against
`HANDOFF.md` is still required — existence is not provenance.

## Concurrency warning

A separate long-running worker is active in this same problem directory,
writing new packets under `tmp/` and periodically rewriting `HANDOFF.md`,
`RESOLUTION.md`, `CURRENT_PATHS.md`, and `SPEC.md`. Coordinate before editing
those four files, and expect `tmp/` to change underneath a long audit.
