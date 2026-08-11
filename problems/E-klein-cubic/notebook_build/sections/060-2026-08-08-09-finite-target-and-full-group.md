## 2026-08-08--09 finite-target and full-group supplement

This supplement records the dependency-closed finite-target and full-group
portion of the dated research wave under `goal_runs_20260808/`.  It postdates
the frozen E01--E55 manifest and does not silently alter the verification
classes of the legacy entries.  Its synthesis and replay inventory are in
`goal_runs_20260808/FINITE_TARGETS_HEADLINE_AUDIT/`.

**Verdict: OPEN.**  The wave did not prove that the Klein cubic is not
`PSL(2,11)`-unirational.  It did deploy CAS on the named theorem-forced finite
targets isolated in the audit.  Those calculations yielded scoped theorems,
counterconfigurations, and exact reductions, but no universal pointlessness or
all-degree landing obstruction.

### Exact `F55` arithmetic gate

For `H=C11:C5`, with

\[
 E=\mathbf C(r_0,\ldots,r_4)/(r_0\cdots r_4-1),
 \qquad K=E^{C_5},
\]

the genuine generic twist has a point exactly when there is \(0\ne a\in E\)
with

\[
 \Phi(a)=\operatorname {Tr}_{E/K}(r_2^{-1}a^2\sigma(a))=0.
\]

The old conserved-eleven/polyhedral contradiction is withdrawn: an explicit
integral convex support function satisfies its boundary system.  Denominator
clearing to finite Laurent support and the support-ideal saturation criterion
are exact, but no theorem bounds the support.  The rank-four
incidence/Newton reduction reaches the original Klein-cover descent again;
local, Brauer, logarithmic, toroidal, and finite-flag packages do not
distinguish the actual unit coefficient from soluble countermodels.

The authoritative correction and reduction corpus is
`F55_AUDIT_20260808.md`, `F55_REPLACEMENT_OBSTRUCTION_20260808.md`,
`F55_POLAR_CIRCUIT_PROOF_REDUCTION_20260808.md`, and
`NOTEBOOK_F55_POLAR_CIRCUIT_20260808.md`.  Its five bounded implementation
lanes are recorded in `WORKORDER_F55_PC1_PRIMITIVE_LAURENT.md`,
`WORKORDER_F55_PC2_TRACE_SUPPORT_COMPILER.md`,
`WORKORDER_F55_PC3_POLAR_EDGE_HOLONOMY.md`,
`WORKORDER_F55_PC4_MINIMAL_CORE_SEARCH.md`, and
`WORKORDER_F55_PC5_EXACT_SATURATION_CERTIFICATES.md`.  These documents preserve
the exact reductions and scoped certificates; the all-support coverage
question they left open was superseded same day by the Coverage-C
adjudication below.

Same day, merged, `F55_COVERAGE_C_ADJUDICATION_20260808.md` adjudicated
Coverage Theorem C, the gate those work orders were aiming at.  Verdict:
under its natural reading, Coverage C's fourth alternative is exactly the
assertion that the relevant exact-support torus is empty, so Coverage C is
equivalent to the original `F55` pointlessness problem, not a smaller
reduction of it (`F55-PC-COVERAGE-C-EQUIVALENT-TO-HEADLINE`).  A
uniform-bound reading was never stated: "A precise uniform circuit theorem
would be a valid new proof strategy, but it would itself be a direct proof
of F55 pointlessness."  The cheap coverage candidate — singleton, clean
polar diamond, initial binomial holonomy — is refuted outright by two
explicit higher-circuit identities, a 16-term deletion-minimal core and a
26-term core, verified by
`director_probes_20260808/f55_coverage_c_adjudicate.py`
(`F55-PC-CHEAP-COVERAGE-REFUTED`, `F55-PC-HIGHER-CIRCUITS-PASS`); the
proof-reduction lemmas themselves are retained
(`F55-PC-PROOF-REDUCTIONS-RETAINED`).  A noncircular negative proof now
needs one of: (1) a stated universal circuit list with an independently
proved coverage theorem; (2) a genuine finite-generation theorem for
primitive cores; (3) a direct arithmetic or geometric obstruction to the
trace cubic.  Status stays `F55-QUESTION-OPEN`.

Characteristic-five calculations close the exact two-Frobenius-residue
families through covariant degree 45.  One fixed three-residue pattern is
closed through degree 45 by dependency-free support replay and through degree
50 by a separately labelled pinned-solver replay without a DRAT/RUP proof.
Other residue patterns, four-or-more residues, and all higher degrees remain
unbounded.  These are bounded theorems, not an `F55` or headline verdict.

### Full-group selfmap reduction

Every hypothetical dominant \(G=\operatorname {PSL}_2(\mathbf F_{11})\)
map \(\mathbf P(W)\dashrightarrow X\) restricts to a dominant generically
finite \(G\)-selfmap of \(X\), of degree \(\delta>0\).

The following consequences are exact.

1. Degree two is impossible.  Its unique deck involution centralizes \(G\),
   hence belongs to \(\operatorname {Bir}^G(X)\); full-\(G\)
   superrigidity identifies this with \(\operatorname {Aut}^G(X)=Z(G)=1\).
   The same argument excludes every cyclic Galois restriction.  Minimal
   faithful permutation degree 11 excludes every Galois degree from 2 through
   11.  This is a **centralizer** argument, not a normalizer claim.
2. The normalizer-coupled `C3`, `C5`, `C11`, and `V4` fixed-graph equations
   eliminate no degree residue.  The first two exceptional `V4` layers have
   explicit compatible formal states; these are not genuine graphs.
3. If \(\delta=1\), superrigidity normalizes the restriction to the identity.
   Every primitive ambient retraction then has

   \[
   T=Hx+FQ,\qquad
   F(x+tQ)=(Ht-F)(St^2-Rt-1).
   \]

   A square \(R^2+4S\) produces two degree-\((d-3)\) landing covariants.  The
   nonsquare branch is genuine and unbounded: an exact degree-nine retraction
   onto an irreducible singular cubic supplies a boundary countermodel.  The
   ordinary minimal-class obstruction and every named direct finite test of
   the equivariant diagonal also pass; neither fact constructs a Klein
   retraction.
4. The first deckless branch, \(\delta=3\), survives each audited screen
   separately: its `S3` extension, auxiliary double covers, a clean
   intermediate-Jacobian norm screen, and the fixed-graph equations.  The
   auxiliary cover, CM endomorphism, and formal localization vector are not
   claimed to arise jointly from one geometric selfmap.

Thus the full-group route stops at a \(G\)-equivariant rational retraction in
degree one or a deckless non-Galois selfmap of degree at least three.  The
missing input is an all-degree theorem controlling the actual ambient landing
base ideal.  In parallel, the `F55` route still requires pointlessness of the
unrestricted trace cubic over \(K\).  A finite computation becomes decisive
only after a theorem supplies a universal degree/support/base-ideal cutoff.

Principal replay markers:

```text
FULL-G-RESTRICTION-DEGREE-TWO-EXCLUDED
FULL-G-GALOIS-DEGREES-TWO-THROUGH-ELEVEN-EXCLUDED
DELTA1-RETRACTION-POLAR-IDENTITY-PACKET-OK
DELTA1-EQUIVARIANT-DIAGONAL-FINITE-AUDIT-OK
DELTA3-S3-RESOLVENT-AUDIT-OK
F55-TRACE-CUBIC-K-POINT-UNDECIDED
KLEIN-PSL2(11)-NONUNIRATIONALITY-NOT-PROVED
```
