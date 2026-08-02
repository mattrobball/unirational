# T3 normalization and horizontal `Cl/Pic[3]` — local-runner dispatch

**Repository:** `mattrobball/unirational`  
**Dispatch date:** 2026-08-02  
**Pinned repository state:** `5899d0589c329955fa1b54ffcdd63f5cd80c2483`  
**Output directory:** `problems/E-klein-cubic/goal_runs_after_5899d0/T3_NORMALIZATION_CLPIC3_LOCAL_RUNNER/`  
**Current exit:** `T3-UNDECIDED`  
**Problem E headline:** **OPEN**

This folder replaces the older monolithic T3 request with a dependency-ordered
portfolio for the local work agents and the local CAS runner.  It is designed
to finish the exact normalization and horizontal three-primary class-group
question without sending algebra jobs to GitHub Actions.

## 1. Scope correction

The mathematical target is now deliberately **auxiliary and standalone**.
The fixed-frame exhaustiveness theorem has been refuted at the pinned state:

```text
B-BRIDGE-REFUTED
```

The selected fixed ternary frame occupies only a proper locus in the genuine
degree-14 Fano/common-line threefold.  Earlier T and T2 audits also proved that
pointlessness of the fixed-frame plane cubic does not formally imply
pointlessness of the genuine generic Klein twist.

Therefore a successful T3 computation may prove

```text
(Cl/Pic)[3]_horizontal = 0
ind(C_fix over k(D)) = 3
C_fix(K_proj) = empty
```

but it must **not** claim from these statements alone that the Klein cubic is
not `PSL(2,11)`-unirational.  Conversely, an explicit dangerous three-primary
class settles this auxiliary route negatively without deciding Problem E.

The final integrator must preserve this scope fence.

## 2. Local-only execution policy

All nontrivial CAS work is assigned to the local runner.

```text
NO GitHub Actions jobs.
NO remote CI as a CAS service.
NO workflow files under .github/workflows/ for this goal.
```

The agents may commit compact scripts, exact inputs, certificates, small logs,
machine-readable summaries, and seals.  Regenerable solver inputs and large
solver dumps stay local and must not be committed.  Record the exact local
command, executable version, wall time, peak RSS, and termination status for
every heavy run.

A timeout, killed process, or empty solver output is a nonverdict.  `msolve`
may be used for discovery but is prohibited as the sole characteristic-zero
emptiness or dimension certificate on these systems.

## 3. Authoritative inputs

Consume the following read-only packets and absorb any later path-scoped
corrections before starting:

```text
problems/E-klein-cubic/goals_after_bd610a/GOAL_T3_TARGET_BRANCH_MOD3_FACTS.md
problems/E-klein-cubic/goals_after_bd610a/scratch_t3/T3_ENDOMORPHISM_MODEL.md
problems/E-klein-cubic/goals_after_bd610a/scratch_t3/T3_NODE_Aminus6_uminus6.md
problems/E-klein-cubic/goals_after_bd610a/scratch_t3/discriminant/REPORT.md
problems/E-klein-cubic/goals_after_bd610a/scratch_t3/discriminant/SEAL.json
problems/E-klein-cubic/certificates/fold_normalization/FINITE_BIRATIONAL.md
problems/E-klein-cubic/certificates/fold_normalization/SERRE_NORMALITY.md
problems/E-klein-cubic/certificates/fold_normalization_t2r/T2R.md
problems/E-klein-cubic/certificates/TARGET_BRANCH_MOD3_CLASS_GROUP.md
problems/E-klein-cubic/goal_runs_after_35fa/T_TARGET_BRANCH/THEOREM.md
problems/E-klein-cubic/goal_runs_after_35fa/B_FIXED_FRAME_EXHAUSTIVENESS_20260802/
```

The primitive fold equation is the 1,593-term sextic `P` with SHA-256

```text
921816025f014da4667c53aa64dddf0983e575d3afa907f4e3f821509068c344
```

The corrected trace-dual RUR inputs are

```text
generic_singular_rur_QZ.tsv  23be9dbe72a9a4089924accde05fc9f8d43b13e644a2e2c8528fabdb3608ef9f
generic_singular_rur_NB.tsv  3ffd1fad77d6e66d40ee8f447bb898c87d0fefb936ef6ea1bf24a02ac7a228ee
generic_singular_rur_NY.tsv  5a57c14e530a4ec111731b09a59da510f578f850d8655e31e7c318849a5209ae
```

Write

```text
q   = QZ(A,u,Z),
r_B = B*dq/dZ - NB(A,u,Z),
r_Y = Y*dq/dZ - NY(A,u,Z).
```

The authoritative fixed-frame discriminant in the original `Z` coordinate
has SHA-256

```text
14f1209efc4a60613d4c28cffd666a0e97861ad891440e7b9a726e211d814d4f
```

## 4. Exact facts already available

The workers must replay these facts rather than start over.

1. The simple-fold algebra is finite birational over the irreducible target
   branch on the accepted open.
2. On the restricted open `S_G`, the fold is a three-dimensional complete
   intersection and hence Cohen–Macaulay.  Normality is not yet proved.
3. The corrected RUR satisfies all six critical equations over `Q(A,u)`.
   The existing exact A-grid certificate uses 233 values against a proved
   A-degree bound 232; an independent u-grid certificate uses 451 values
   against a proved u-degree bound 450.
4. `q` is irreducible and squarefree over `Q(A,u)`, witnessed by the exact
   irreducible degree-six specialization at `(A,u)=(17,1)`.
5. Exact gate-saturated special fibres have length six.  This is not by itself
   a generic no-escape theorem.
6. At `(A,u)=(-6,-6)`, the degree-six residue field carries a nonsplit
   transverse node.  The normalization residue degree is two, the delta
   invariant is one, and the conductor exponent is one.
7. The fixed-frame discriminant is an irreducible exponent-one polynomial.
8. On the normalized generic affine boundary plane
   `S=(A-15L,Y-12L)`, its contact order is exactly two.
9. At the sole projective boundary divisor `E=(L,A)`, every Newton branch has
   discriminant valuation four.
10. The generic cusp line, second-node cubic, and nonsplit cancellation line
    inside `S` have no actual-field three-primary local class.
11. The raw-target singular curves `J1`, `J2`, and `F15`, the conductor
    identification, and global component exhaustiveness remain open.
12. Exact specializations show the discriminant is generically nonzero on the
    candidate RUR prime, conditional on that prime being the conductor.

## 5. Dependency graph

Run the packets in this order:

```text
T3A: exact RUR exhaustiveness and common open
        |
        v
T3B: one-step normalization and conductor
        |
        +--------------------+
        |                    |
        v                    v
T3C: local/boundary       T3D: global localization
     discriminant ledger      and horizontal degree theorem
        |                    |
        +----------+---------+
                   v
              T3E integration
```

T3C may perform discovery while T3B runs, but its final statements must use
the authoritative normal model and common open from T3A–T3B.  T3D may prepare
the abstract localization sequence early, but it cannot close the theorem
until T3C supplies an exhaustive local ledger.

## 6. Goal files

```text
GOAL_T3A_RUR_EXHAUSTIVENESS.md
GOAL_T3B_NORMALIZATION_CONDUCTOR.md
GOAL_T3C_LOCAL_DISCRIMINANT_MOD3.md
GOAL_T3D_GLOBAL_CLPIC3.md
GOAL_T3E_INTEGRATE_SEAL.md
LOCAL_RUNNER_PROTOCOL.md
TASK_LEDGER.md
```

Each worker writes only inside the output directory named above, using a
worker-specific subdirectory until integration.  Do not edit sealed historical
packets.

## 7. Terminal exits

The integrated run must use exactly one of:

```text
T3-CLPIC3-VANISHES
T3-DANGEROUS-3-CLASS
T3-NORMALIZATION-COMPLETE-MOD3-UNDECIDED
T3-GLOBAL-MODEL-REFUTED
T3-UNDECIDED
```

`T3-CLPIC3-VANISHES` means the horizontal three-primary quotient vanishes for
the normalized fixed-frame incidence and the horizontal degree image is
`3 Z`.  It is not a Problem E headline exit.

`T3-DANGEROUS-3-CLASS` requires an exact local or global Weil divisor class,
with a proof that it survives over the actual residue field and maps to a
horizontal degree prime to three.

## 8. Integrated output contract

The final output directory must contain at least

```text
STATUS.md
INPUT_MANIFEST.json
COMMON_OPEN.md
RUR_EXHAUSTIVENESS.md
NORMALIZATION.md
CONDUCTOR.md
DOMINANT_COMPONENTS.md
LOCAL_MODELS.md
LOCAL_CLASS_GROUPS.md
DISCRIMINANT_CONTACTS_MOD3.md
RESIDUAL_PICARD.md
GLOBAL_DEGREE_IMAGE.md
THEOREM.md
proof_payload.json
produce_*.py / *.m2 / *.sing / *.cpp as needed
independent verify_*.py
REPLAY.md
SEAL.json
```

`STATUS.md` must record both the pinned dispatch commit and the live commit
actually consumed.  `THEOREM.md` must contain an explicit paragraph stating
that Task B refutes the fixed-frame exhaustiveness bridge and that no Klein
unirationality conclusion follows from T3 alone.
