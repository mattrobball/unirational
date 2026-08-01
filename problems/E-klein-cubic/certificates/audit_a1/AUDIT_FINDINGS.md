# Audit A1 — findings (ranked by consequence)

**Exit:** `AUDIT-A1-COMPLETE`  
**Headline:** **OPEN**  
**Scope:** standing exit markers only; no new computation; no narrative edits.  
**Method:** read sealed packets, exit JSON, verifiers, and known director
corrections; compare marker/prose claims to what the artifacts actually
recompute.

Already-recorded director corrections are **not** re-reported as new, except
where a **further residual** (sealed prose still active, verifier still
accepts the old exit name, or a downstream packet mis-cites the seal) remains
load-bearing for reuse. Those residuals are marked `known-residual`.

---

## Ranked findings (highest consequence first)

### F1 — `T-BRANCH-NONNORMAL` / T10 local-model attribution  
**Verdict:** `UNSUPPORTED` (completed ordinary-node form) + `SCOPE-DRIFT` (attribution to T9)  
**Severity:** **critical**  
**Exit impact:** marker exit name unchanged if consumed only as **analytic**
work-order input; **cannot** be treated as a CAS-sealed theorem that `B` has
completed local equation `K'[[x,y,z₁,z₂]]/(xy)`.

**Exact text at issue**

`certificates/target_branch_t10/BINODAL_ODD_PRIMARY.md` lines 38–44:

> This is the ordinary-binodal completed local equation sealed at the Hensel  
> point (`T9-HENSEL-NONUNIT-SEALED`): after base change to a finite extension of  
> `Q_101`, one has  
> `Ô_{B,z} ≃ K'[[x,y,z₁,z₂]]/(xy)`.

The same file’s table (lines 162–163) simultaneously lists that equation as
“accepted analytic input,” which is the honest status — and contradicts the
“sealed at … `T9-HENSEL-NONUNIT-SEALED`” attribution.

**What T9 actually seals**

`certificates/fold_binodal_t9/SEAL.json` / `hensel_hypotheses.json` prove:

- unique `Z_101`-lift of the **deflated** system `P(u₁)=P_u(u₁)=P(u₂)=P_u(u₂)=0`;
- gates and `det J₄` units; `H = s₁ = 0` at the lift;
- analytic nonunitness of the gated ideal over `Q` (`T8-S1-NONUNIT-ANALYTIC`).

T9 explicitly **does not** prove global binodal equations, normality of
`S_G`, or `dim Sing(S_G)=2`. It does **not** list a completed local equation
of the hypersurface `B = V(H)`.

**Cross-check from T8-N1**

`certificates/fold_decision_t8n1/exit_t8n1.json`:

```text
"4_normal_crossing": "MODULAR_ONLY"
```

`DEFLATED_SYSTEM.md` §3: rank `{dh₁,dh₂}=2` is the modular transversality
condition; normal crossing in the completed local ring over `Q` is **not**
sealed.

**What the correction actually gives**

`WORKORDER_CAS_T10_P25W_C2_CORRECTION.md` withdraws the “regular extension”
sentence and argues nonnormality of `B` over `Q` from:

1. completed local equation `xy=0` over a finite extension of `Q_101` (singular
   locus dim 2);
2. Jacobian ideal of `H` defined over `Q`;
3. invariance of Krull dimension under field extension.

Step (1) remains **analytic input**, not a CAS identity sealed by T9. There is
no sealed Hessian / formal factorization computation establishing
`H = unit·h₁·h₂` in the completed local ring.

**Repair**

- Rewrite T10 §1 so the completed node is cited as **work-order analytic
  input** (or seal a genuine formal normal-form packet), not as
  `T9-HENSEL-NONUNIT-SEALED`.
- Keep `T-BRANCH-NONNORMAL` on the analytic ledger until a CAS normal-form
  seal exists.
- Do not let later workers treat `T-BRANCH-NONNORMAL` as interchangeable with
  fold nonnormality of `S_G` (packets already separate these; maintain that).

---

### F2 — `T10-BINODAL-NO-3-DEFECT` inherits F1; verifier does not check geometry  
**Verdict:** `SOUND` as pure algebra on an abstract ordinary node;  
**`UNCITED-HYPOTHESIS`** as a geometric statement about the Klein target branch  
**Severity:** **high**  
**Exit impact:** algebraic exit stands **conditionally**; geometric consumption
requires the ordinary-node hypothesis to be named.

**Support that exists**

- Abstract conductor Mayer–Vietoris: split unit map surjective; split punctured
  Pic vanishes (UFD/regular argument in the note); unsplit case has no
  3-primary torsion via `cor∘res = ×2`.
- Verifier `verify_binodal_local_model.py` / `verify_binodal_result.json`
  recomputes truncated power-series unit-map surjectivity (40/40) and
  bijectivity of mult-by-2 on `Z/3`, `Z/9`, `Z/27`, `(Z/3)²`.

**What the verifier does *not* recompute**

- The identification of the geometric completed stalk of `B` with
  `K'[[x,y,z₁,z₂]]/(xy)`.
- Any Jacobian ideal of `H`, any dimension of `Sing(B)`, any Hensel chart of
  `B` itself.

`verify_binodal_result.json` `proves` strings are pure algebra. A `PASS` here
does **not** independently bear on “the Klein cubic target branch has no
3-primary local Picard defect at its binodal locus” without the model
hypothesis.

**Repair**

State the exit as: *if* the completed local ring is an ordinary node, *then*
no 3-primary local Picard defect. Do not cite T9 as sealing the hypothesis.

---

### F3 — `P25Z-FINITE-PRESENTATION` sealed name still claims exact isomorphism  
**Verdict:** `SCOPE-DRIFT` / known residual of `DIRECTOR_CORRECTION_P25Z1.md`  
**Severity:** **high** (nonempty support direction; emptiness still safe)  
**Exit impact:** work order already renames to `P25Z-FINITE-PRESENTATION-LOWER`;
sealed packet still says the old marker.

**Exact fields**

| Location | Claim |
|---|---|
| `exit_p25z1.json:12` | `"exit": "P25Z-FINITE-PRESENTATION"` |
| `exit_p25z1.json:20` | `"iso": "M = F/N ≅ R/J_N …"` |
| `exit_p25z1.json:54` | proves full isomorphism |
| `FINITE_PRESENTATION.md:5,236` | exit marker without `-LOWER` |
| `closure_ledger.json:25` | “T-stable hull coincides with seed span on a Zariski-dense open” from 40 fibres |
| `verify_presentation.py:309` | accepts exit `== "P25Z-FINITE-PRESENTATION"` |
| `verify_presentation_result.json` | specialized `T_stable` / `comm_in_span` only (25 trials) |

**What is supported**

- Monic `K³` rules (56/56), operators `T_i`, 690 residual seeds, shape
  `690×28`.
- `N_seed ⊆ N_true`, hence `Supp(R/J_N) ⊆ Supp(F/N_seed)` — emptiness direction
  safe (director correction §3).

**What is not supported**

- `N_seed = N_true` over `S` (only specialized fibres).
- Verifier `PASS 20/20` does not close that gap.

**Further residual (beyond the known correction text)**

The sealed producer/verifier still *endorse* the non-LOWER exit string. A later
worker who greps exits without reading `DIRECTOR_CORRECTION_P25Z1.md` will
consume an exact presentation.

**Repair**

Director rename of sealed exit + verifier expectation to
`P25Z-FINITE-PRESENTATION-LOWER`; demote `iso` claims; optional graded
membership of commutator defects (director §5).

---

### F4 — Sealed T8 prose still asserts uncomputed Jacobian determinants  
**Verdict:** `UNSUPPORTED` residual in sealed packet  
(`DIRECTOR_CORRECTION_T8.md` already records the falsehood)  
**Severity:** **high** for naive consumers of `SUBRESULTANT_UNIT_TARGET.md`  
**Exit impact:** none — `T8-S1-UNDECIDED` remains correct.

**Exact sentence**

`certificates/fold_decision_t8/SUBRESULTANT_UNIT_TARGET.md` line 100:

> At L4/`p=101` and L4/`p=199`, the Jacobian of `(H,s₁)|_Λ` w.r.t. `(s,t)` is  
> invertible (dets 96 and 29), so these points are **isolated** …

Confirmed still present; `rg -i 'jac|det'` on the three T8 scripts still empty;
`96`/`29` still arise as `Puu` / `C` in discovery JSON (director correction).
`verify_t81.py` never examines this sentence.

**Repair**

Leave sealed bytes or overlay; consumers must read
`DIRECTOR_CORRECTION_T8.md`. Downstream Hensel path is the **deflated** system
(T9), not naive plane Jacobian.

---

### F5 — `P25Y-DVR-PASS`: “Exact Molien dimensions” for `Arr` and `V₂₅`  
**Verdict:** `SCOPE-DRIFT` / known residual (`MOLIEN_BOUND.md` §5; brief §2)  
**Severity:** **medium** (freeness not overturned)  
**Exit impact:** none for `P25Y-DVR-PASS`.

**Exact text**

`certificates/degree25_direct_support/DVR_MODEL.md` lines 29–35:

> Exact Molien dimensions (trusted):  
> `dim M₂₅=189`, `dim Arr=59`, `dim V₂₅=43=37+6`.

| Quantity | Actual status |
|---|---|
| `189 = c₂₅` | pure Molien self-covariant (`molien_values.json`) |
| `Arr = 59` | construction / multiprime filtration dimension |
| `V₂₅ = 43` | construction dimension; equals invariant Molien `m₂₅` only numerically |

Unit minors and special-fibre ranks **are** recomputed
(`dvr_certificate.json`: arr det 14, o2 det 43, monic left det 1;
`verify_dvr.py` recomputes them). Constant-rank freeness over the DVR is
supported by those minors, not by the Molien label.

**Repair**

Wording only: call `189` Molien; call `59,43` trusted construction dimensions.

---

### F6 — Stale “746 is lower bound only” after `P25Z-ROW-RANK-746`  
**Verdict:** `SCOPE-DRIFT` (cross-packet currency)  
**Severity:** **medium**  
**Exit impact:** none for the Molien / P25YB *exits*; confuses consumers of
rank status.

| Location | Stale claim |
|---|---|
| `degree25_molien/molien_values.json` `row_rank_bound.observed_746` | “Observed F₈₉-rank 746 is a lower bound only” |
| `MOLIEN_BOUND.md` §0 | same |
| `degree25_support_f4/support_result.json` `ring.rank_is_lower_bound_only` | `true` |
| `support_result.json` `what_not_proved` | “That rank 746 is the full direct-landing row span” |

`P25Z-ROW-RANK-746` later seals **exact** rank 746 over `F₈₉` via unisolvence
(`rank_certificate.json`, `verify_report.json` recomputed rank 746 / pivot
product 68). Those older packets are not wrong *at sealing time*, but they are
no longer the authority on special-fibre completeness.

**Repair**

Director currency note beside Molien / P25YB; do not reopen their exits.

---

### F7 — `P25X0-PASS` titled as char-0 model; materialization is multiprime  
**Verdict:** `SCOPE-DRIFT` (mild)  
**Severity:** **low–medium**  
**Exit impact:** none if exit is read as “executable circuit + multiprime
lattice.”

**Exact text**

`COEFFICIENT_MODEL.md` title/§1: “Executable characteristic-zero coefficient
model” / `P25X0-PASS`.  
§4: entrywise Q-RREF reconstruction fails holdouts; model is multimodular monic
lattice + replayable circuit over `K`.

**Support that exists**

Multiprime structural dimensions (`exit_p25x0.json`: rank-43 monic pivots
0..42, order-2 rank 16, residual 7, `Q|K = 37|6` at primes 67,89,199,331,353).
Basis sha at `p=89` matches DVR (`4709fdbe…`).

**Repair**

Prose: “executable multiprime / circuit model of the char-0 object,” not an
installed entrywise `K`-matrix.

---

### F8 — `C0` order-12 structure table  
**Verdict:** known residual `UNSUPPORTED` clause (`DIRECTOR_CORRECTION_C0.md`)  
**Severity:** **low** for load-bearing orbit degrees  
**Exit impact:** none — `C0-UNDECIDED` stands.

`C0_STRUCTURE_TABLE.md` line 55–56 still says 110 order-12 subgroups “all
`StructureDescription = A4`.” True: 55 `A₄` + 55 `D₁₂`. Indices 55,60,132 and
`gcd=1` remain sound.

---

## Marker-by-marker bill

### Fold / target branch

#### `T9-HENSEL-NONUNIT-SEALED` / `T8-S1-NONUNIT-ANALYTIC`  
**Verdict:** `SOUND`

Computation exists: sealed `P`, modular witness L4/`p=101`, recomputed gates,
`det J₄` (formula 88 ≡ −13 mod 101 vs direct 4×4), multivariate Hensel
hypotheses in `hensel_hypotheses.json`; verifier
`verify_hensel_hypotheses.py` recomputes residuals and gates from sealed `P`
(does not import a producer). Analytic nonunitness via a `Q_p`-point with unit
gates is a valid characteristic-zero ideal statement. Scope fences against
`S_G` normality and global binodal equations are correct.

#### `T-BRANCH-NONNORMAL`  
**Verdict:** `UNSUPPORTED` as CAS-sealed local form; analytic work-order claim  
See **F1**. Separation from `S_G` is maintained in work orders and T10 prose.

#### `T10-BINODAL-NO-3-DEFECT`  
**Verdict:** conditional `SOUND` / geometric `UNCITED-HYPOTHESIS`  
See **F2**. Scope fence “not about `S_G`” is correct.

#### `T10-FOLD-UNDECIDED` (ten-pair table)  
**Verdict:** `SOUND`

Modular nonempty fibres for all ten pairs with stable degrees 6–24 are
recorded as **discovery** (`TEN_PAIR_TABLE.md`, `modular_fibre_table.json`).
Exact generic fibre not sealed; bottleneck named
`BOTTLENECK-T101-EXACT-FUNCTION-FIELD-GB`. Object is explicitly `S_G`, not `B`.
Honest `UNDECIDED` — not a deficiency.

#### `T8-S1-UNDECIDED`  
**Verdict:** `SOUND` as exit; sealed prose residual **F4**

Witnesses and nonunit discovery stand; exit correctly refuses char-0 algebraic
point.

#### `T8-N1-UNDECIDED`  
**Verdict:** `SOUND`

Jacobian correction sealed; deflated modular nonsingularity sealed; char-0
lift and dimension floors named. Does not overclaim `T8-S1-NONUNIT` or
`dim Sing(S_G)=2`.

#### `T2R4-PASS`  
**Verdict:** `SOUND`

Sparse factors `ℓ, P_uu, C, δ` installed; `G = Res_u/H` as exact-quotient
circuit; modular exact division + evaluation probes
(`RESULTANT_FACTOR_IDENTITY.md`). `F₂₇` sparse CRT pending is disclosed.
Verifier path independent of producer.

#### `S₂` (on `S_G` / `D(GΣ)`)  
**Verdict:** `SOUND`

Regular-sequence / CI argument in `s2_cm_certificate.json` and
`SERRE_NORMALITY.md`: content(`P`)=1, `Res_u ≠ 0` via sealed `H`, height 2,
localization after inverting `G·Σ`. Scoped: **not** claimed on full `D(Σ)`
without `G`.

#### `dim Sing(S_G) ≤ 2`  
**Verdict:** `SOUND` as upper bound only

Exact-Q unsaturated cut2 zero-dimensional sections + generalized PIT
(`upper_bound_certificate.json`, `r1_singular_locus.json`). Packets correctly
refuse `dim = 2` from linear sections alone. Lower bound not proved
(`T2R-UNDECIDED`).

---

### Degree 25

#### `P25Y-DVR-PASS`  
**Verdict:** `SOUND` with wording residual **F5**

Unit-pivot freeness of `V₂₅` over `O` at `p=89` is supported by recomputed
minors and monic basis-lift; holdouts structural. Sufficient for DVR
properness arguments used downstream.

#### `P25Z-ROW-RANK-746`  
**Verdict:** `SOUND` (exactly at `p=89`)

Unisolvent evaluation of `Inv₇₅` (2343×2343 invertible, pivot product 68) +
landing-row echelon rank 746. Verifier recomputes independence, unisolvence,
and landing rank (`verify_report.json`). Theorem boundary in
`rank_certificate.json` and `ROW_RANK.md` correctly states **over `F₈₉` only**;
not promoted to char-0. Comparison shows historical sampling lower bound had
the same rowspace.

#### `P25W-RANK-K-UNDECIDED`  
**Verdict:** `SOUND`

Exact modular ranks 746 at `p ∈ {89,199,353}`; therefore `rank_K ≥ 746`;
equality not sealed. Explicit theorem boundary forbids promoting modular
agreement. Verifier recomputes all three primes.

#### `P25Z-FINITE-PRESENTATION-LOWER`  
**Verdict:** standing name correct in work order; sealed packet residual **F3**

#### `P25YB-UNDECIDED`  
**Verdict:** `SOUND` as support undecided; rank-currency residual **F6**

Monic `K³` finite-over-`S` is supported; mixed `QK²` partial; F4/Macaulay
incomplete (empty msolve output correctly treated as failed run). Honest
undecided.

#### `P25X0-PASS`  
**Verdict:** `SOUND` as multiprime/circuit install; mild residual **F7**

#### `P25X1-FAIL`  
**Verdict:** `SOUND`

Sample landing ranks 746 at three primes; equivalence to historical 842 /
border not closed. Honest `FAIL`.

#### Molien `m₇₅ = 2343`, `c₂₅ = 189`  
**Verdict:** `SOUND` for those two numbers

Three independent methods agree (`MOLIEN_BOUND.md`); verifier recomputes via
complex eigenvalues and modular group sum (does not merely read JSON).
`c₂₅ = 189` matches project `M₂₅`. Residual **F5**/**F6** concern labels and
stale rank language, not `m₇₅`/`c₂₅` themselves.

---

### Fano

#### `C0-UNDECIDED`  
**Verdict:** `SOUND` as exit; residual **F8** on subgroup structure sentence

No model install; Option 1 preferred; ρ=1 negatives; degree-55 multisection
lever limits correct. Honest undecided.

#### `C1-UNDECIDED`  
**Verdict:** `SOUND`

Preflight only; five-step table honest (partial / not installed); resource
floor named. Does not claim Fano point.

#### `C2-TWO-GENERATORS-MODULAR`  
**Verdict:** `SOUND`

Unit word-basis dets 16 @ `p=23`, 82 @ `p=89` for sealed pair `(e₁,e₂)` and
shortlex 36 words. SEAL `proves`/`does_not_prove` correctly modular-only.
Verifier independent of producer.

#### `C2-1-UNDECIDED`  
**Verdict:** `SOUND`

Partial Q-constant reconstruction (859/1296 `L_a`, 484/1296 `L_b`); degree ≥5
floor for varying `K_proj` entries; holdout checks. Honest undecided.

---

## Verifier discipline summary

| Packet | Decisive invariant recomputed? | Risk |
|---|---|---|
| T9 Hensel | yes (P, gates, det J₄) | low |
| T8.1 | witnesses only; **not** Jacobian sentence | residual F4 |
| T8-N1 | ∇H, det J₄, dh rank | low |
| T10 binodal | truncated units + mult-by-2 only | residual F2 |
| T10 modular fibres | selected msolve degrees | discovery only |
| T2R4 | factors / Res=HG modular | low |
| P25Y DVR | unit minors | low |
| P25Z row rank | unisolvence + rank 746 | low |
| P25W rank K | three modular ranks | low |
| P25Z presentation | specialized fibres only | residual F3 |
| Molien | group-sum / eigenvalues | low |
| C2 modular | word-basis det | low |
| C2.1 | holdout Q-constants | low |

---

## Markers audited

All markers listed in the Worker A brief were reached:

```text
T9-HENSEL-NONUNIT-SEALED / T8-S1-NONUNIT-ANALYTIC
T-BRANCH-NONNORMAL
T10-BINODAL-NO-3-DEFECT
T10-FOLD-UNDECIDED
T8-S1-UNDECIDED, T8-N1-UNDECIDED
T2R4-PASS, S_2, dim Sing ≤ 2
P25Y-DVR-PASS
P25Z-ROW-RANK-746
P25W-RANK-K-UNDECIDED
P25Z-FINITE-PRESENTATION-LOWER
P25YB-UNDECIDED
P25X0-PASS, P25X1-FAIL
C0-UNDECIDED, C1-UNDECIDED
C2-TWO-GENERATORS-MODULAR, C2-1-UNDECIDED
Molien m_75=2343, c_25=189
```

None deferred.

---

## Intended commit split (path-scoped; no git run)

```text
1. certificates/audit_a1/   # AUDIT-A1-COMPLETE findings only
```

(Optional later, director-owned overlays — not this worker:)

```text
2. certificates/target_branch_t10/DIRECTOR_CORRECTION_T10_MODEL.md
3. certificates/degree25_finite_module/  # exit rename to -LOWER if director elects
```

---

## Process statement

- **No new computation** was performed (no solves, Gröbner bases,
  reconstructions, or searches; no producer runs).
- **No narrative file** was edited.
- **No sealed packet** was edited.
- Writes only under `certificates/audit_a1/` and `tmp/audit_a1/`.
- No `git` commands were run.

---

**Headline:** **OPEN**
