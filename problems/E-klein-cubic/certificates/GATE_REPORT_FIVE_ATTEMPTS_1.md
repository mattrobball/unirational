# Director gate report — five-attempt order, first dispatch

**Author:** director session.
**Date:** 2026-07-30.
**Order:** `WORKORDER_FIVE_ATTEMPTS.md` §6.3.
**Base:** `b7be961`.

## Ranking selected

\[
\textbf{5. No route crosses its first gate.}
\]

Per §6.3 option 5: **start Attempt 3, and retain Attempts 4–5 as structural
tracks.**

Options 1–4 are all excluded by the returned evidence:

| Option | Why not selected |
|---|---|
| 1. Pfaffian bridge closes abstractly | Gate 1 returned **FAIL-SCOPE** — the bridge does not close |
| 2. Pfaffian coordinate system now small — authorize solve | Gate 2 did return `P1-REDUCED`, but solving it cannot reach the headline while Arrow A is broken |
| 3. Target-branch normalization near closure | Gate 1 returned **STOP-2**; normalization and conductor were not constructed |
| 4. Global states forced into rank drop | containment is **UNDECIDED**; no sampled verdict was accepted |

**Headline: OPEN.**

## What each gate returned

| Item | Decision | Marker |
|---|---|---|
| Attempt 1 Gate 1 (bridge audit) | `FAIL-SCOPE` | — |
| Attempt 1 Gate 2 (abstract extraction) | `P1-REDUCED` | — |
| Attempt 2 Gate 1 (globalize fold) | `STOP-2` | `TARGET_BRANCH_GLOBAL_FOLD_GATE1_VERIFIER_ACCEPT` |
| Attempt 5 Gate 1 (global state image) | containment `UNDECIDED` | `GLOBAL_STATE_IMAGE_VERIFY_OK` |

## The decisive finding, and a correction to prior status language

Attempt 1's bridge audit is the most consequential result of the campaign.
The four-arrow implication chain **breaks at Arrow A**:

```text
sigma-self-adjoint reduced-rank-two idempotent
   -->  point of an AUXILIARY space: an open subset of the rational
        D-plane P^2_D (a Morita projector / nondegenerate right line)
   -/-> point of the distinguished degree-14 Fano section
```

The exact missing bridge is now written down:

```text
point of P^2_D(K)   ~~>   point of F14_T(K)
```

a **codimension-five linear section problem on an eight-dimensional rational
chart**.  Springer plus the degree-55 zero-cycle gives isotropy of each
individual member of the five-plane but does **not** produce the simultaneous
line.  The Morita identification is unique up to `GL_3(D)` and introduces no
new Brauer class, so this is a failure of *scope*, not of bookkeeping.

**Correction to be carried into the status files.**  The standing conditional
"common isotropic line `=>` headline positive" remains true, but the abstract
idempotent does **not** deliver its antecedent.  Language in earlier status
notes and routing summaries treating the idempotent as nearly sufficient —
including the director session's own summaries — was too strong.  House
rule 1 exists to catch exactly this, and the gate-before-compute discipline
prevented a large coordinate solve on a system that could not have closed the
headline.

One genuine simplification did come out of Gate 2: the idempotent space
`I_sigma` is open in rational `P^2_D` and **has `K`-points**; it is *not* a
nontrivial obstructing torsor.  So no cohomological obstruction sits at that
step — the entire difficulty is concentrated in the codimension-five section
problem above.

## Debts closed

**CFOSS `w_1` is pinned.**  CFOSS I, Lemma 3.1 (`w_1` injective for prime
`n`), with verbatim hypotheses, both source and repository `w_1` conventions,
their agreement via Cor. 3.12 (`alpha_R = w_1(xi)`), and every repository
use-site enumerated in `certificates/pfaffian_point/CFOSS_W1_INPUT.md`.  This
debt had been outstanding across two prior work orders and may now be cited
specifically rather than generically.

## Attempt 2 resource request — director decision

Attempt 2 stopped at a **measured** bottleneck: elimination on the fold ideal
`(P, P_u)` reached ~9.4 GB RSS against the 8 GiB ceiling.  `msolve` produced a
72-generator modular Gröbner basis; dimension extraction and
elimination/saturation are where it breaks.  Three options were returned.

**Decision: (c), with (b) as fallback — both under the existing 8 GiB gate.**

- **(c) multi-prime sparse reconstruction of the degree-21 factor**, using the
  accepted line `H_21(s)` as shape.  Cheapest, and it exploits structure we
  already own.
- **(b) subresultant / sparse interpolation of `Res_u`** with a written memory
  plan under 8 GiB, if (c) stalls.
- **(a) is NOT authorized.**  A >8 GB job is reserved for director approval
  under §7.2 and is not justified while a structured route under the gate
  remains untried.  Note also the earlier campaign lesson: a raw elimination
  is precisely the shape of computation this order forbids.

## Dispatch decision

1. **Attempt 3** (Schur degree-19 rescue curve) — begins now, per option 5.
   Attempt 1 Gate 1 is complete, which was its stated precondition (§6.1).
2. **Attempt 2** continues as a structural track under option (c)/(b).
3. **Attempt 5** remains a structural track; its containment question is
   well-posed and estimated, and must not be advanced by sampling.
4. **Attempt 1** is demoted per the `FAIL-SCOPE` rule.  It is *not* retired:
   the codimension-five section problem is now the exact object to attack,
   and it is a cleaner target than the 15-variable system it replaces.
5. **Attempt 4** remains a background structural track.

## Boundary

No exit from §9's decision table has been reached.  No `K_proj`-point, no
landing covariant, no pointless twist, and no exclusion of all landing
covariants.  **Problem E remains OPEN.**
