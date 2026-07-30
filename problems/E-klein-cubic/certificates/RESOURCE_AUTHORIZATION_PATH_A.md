# Resource authorization — Path A elimination

**Authorized by:** repository owner (director), 2026-07-30.
**Recorded by:** director session.
**Order:** `WORKORDER_ELO_TEN_PATHS.md` §7.2.
**Supersedes:** the refusal recorded in `GATE_REPORT_ELO_1.md` ("no >8 GiB
job authorized for Path A").

## Grant

Path A's Krylov-incidence elimination is authorized to exceed the ordinary
8 GiB exploratory ceiling, up to

```text
64 GiB RSS
```

for a single sealed job.

## Why 64 GiB and not 96 GiB

§7.2 permits up to 96 GB after a director gate but also states **"No
concurrent memory-saturating jobs."**  Paths F and G are live in the same
repository and will spawn their own compute.  A 96 GiB Path A job would
starve them and violate that clause.  64 GiB leaves roughly 60 GiB of
headroom on the 128 GB machine for F, G, and the system.

If F and G have both returned when the Path A job is launched, the cap may be
raised to 96 GiB without a further gate — record that fact in the job's
pre-flight if it applies.

## Preconditions — all still binding

The grant relaxes the memory ceiling only.  It does **not** relax any other
rule.

1. **Pre-flight emission is mandatory** before launch (§7.2): matrix/module
   dimensions; nonzero term count; sparse memory floor; dense memory floor;
   expected certificate; checkpoint plan; independent verifier design.
2. **Structural collapse is still attempted first.**  The in-flight Path A
   dispatch is hunting a lossless variable collapse (gauge fixing, isotypic
   block reduction, sparse-preserving elimination order).  A collapse that
   makes the job small is strictly preferable to spending the grant; the
   grant exists so the route is not blocked if no collapse is found.
3. **Losslessness must be proved** for any collapse used to shrink the
   system: no qualifying `(tau, lambda)` may be silently discarded.
4. **All six candidate safeguards still bind** — four binary forms with no
   common zero; degree exactly 19; birational onto image; `Z` in the image
   with multiplicity one at all conjugates; no component in the cubic;
   residual cubic intersection of length exactly two.  A rank-condition
   solution is not a qualifying curve.
5. **Characteristic-zero discipline unchanged** (§7.3): finite fields for
   discovery, shape, and pivot selection only.  Any modular reconstruction
   must implement its own congruence check — never SymPy's private
   `ratrecon` helper, which skips the final check and silently corrupted an
   earlier packet in this repository.
6. Stream sparse rows and checkpoints; do not materialize a dense global
   matrix merely because the ceiling now permits it.

## Sequencing

The currently running Path A dispatch was briefed under the old 8 GiB refusal
and cannot be updated mid-flight.  This authorization therefore takes effect
**on its return**, which is the correct order anyway: by then the route will
either have a lossless collapse (making the large job cheaper or
unnecessary) or a characterization of the minimal irreducible system (making
the large job better targeted).

## Boundary

This is a resource decision only.  It changes no mathematical status.  No
route is promoted because its computation is largest, and **Problem E remains
OPEN**.
