# WORKORDER — The tuple-level joint residue system: hunting a class-at-infinity zero
# (cycle 5, lane B: the transport program's first live shot)

Issued 2026-08-12 (director). python3 only (never gap/gp/sage/magma —
shell aliases trap); primes 331, 661; no git; packet
`goal_runs_20260812/TUPLE_JOINT_RESIDUE/` only.

## A. The strategic situation (read the transport note first)

`theory/EXCLUSION_TRANSPORT_20260811.md`: a TUPLE-LEVEL exclusion of a
single residue class mod 6, at all sufficiently large degrees, closes
Problem E (Corollary 3.4, unconditional — quintic invariant). The
corrected σ-band table alone has no zeros (`STAGE1_STRATIFIED`:
K = 11068/1178/1512/6216/1344/756). But the σ-band was never JOINED, at
tuple level, with the other tuple-level layers now on the books:

  * the cone order: `ord_{ℓ_V}(T) ≥ 6` for every landing tuple at every
    degree — audited tuple-level 2026-08-12
    (`goal_runs_20260812/CONE_ORDER_AUDIT`, FIX-N2 Thm A + Note II);
  * the parity layers (H0-1: `m` odd; `ord_{L_σ} ≡ d+1 mod 2`);
  * the sealed general depth-value table
    (`goal_runs_20260812/DEPTH_TABLE_GENERAL`) — which levels are
    arc-consistent per class, both full-flag rows.

The join question: per residue class mod 6, do the σ-band's coherent
patterns REMAIN coherent once the ℓ_V-band rows are included with the
cone-order constraint and the depth table's admissible levels — or does
some class die? The prize justifies real care: a tuple-level zero at ONE
class (all large degrees; Theorem-S-style saturation makes σ-band
verdicts all-degree) plus transport is full closure. Extraordinary-claims
discipline is mandatory.

## B. Tasks

1. **Extend the coherence system** (the `STAGE1_STRATIFIED` semantics +
   `GLOBAL_COHERENCE` join machinery) to include the ℓ_V-band rows of the
   census — the rows over the V4-triple-lines — with their multidegree
   bookkeeping tied to `r = ord_{ℓ_V}(T) ≥ 6` (the profile slot data;
   Theorem-S periodicity applies to them like any slots, `g_r | 6`).
   Impose the depth table's arc-consistent-level menus everywhere (no
   module-level degeneracy shortcuts — the ODDZERO lesson).
2. **Recompute the joint tuple-level pattern count per residue mod 6**
   (all-degree semantics via saturation; verify the saturation
   thresholds on the new rows the same way Theorem S(d) did — up-set
   checks on boxes, both primes).
3. **Anchors:** trivializing the new layers must reproduce the corrected
   K table exactly; the two sealed parities must fall out; sharing-off
   consistency with `GLOBAL_COHERENCE` where comparable.
4. **Report per class:** count, and the mechanism profile (which layer
   cut what). **If any class is ZERO:** flag, do not claim; state the
   transport consequence conditionally ("would close Problem E via
   Corollary 3.4 subject to adversarial audit"); an ODDZERO-standard
   audit is the named gate; double-check tuple-completeness of every
   layer used (the σ-band model, the cone order and parities are
   tuple-level; nothing map-normalized may enter — in particular do NOT
   use STAGE2 pinning values, which are reduced-lift statements).

## C. Framing

Headline: "Problem E remains OPEN; this packet excludes no degree" — even
under a zero, the claim waits for the audit. Packet protocol as always
(`THEOREM.md` — never REPORT.md — scripts/, results/, replayable
`verifier.py`, `REGISTRATION_SNIPPET.md`, ODDZERO format, entry E56,
goal_run, tracked true; honesty tiering; exits `TUPLE-JOINT-*`; "Not
claimed"). Summary ≤ 25 lines: per-class joint counts with mechanism
attribution, saturation evidence, anchor status, any flags.
