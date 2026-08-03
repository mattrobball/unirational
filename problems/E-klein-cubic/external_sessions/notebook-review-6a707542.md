# ChatGPT conversation

## [1] user

Thoroughly review NOTEBOOK.md in mattrobball/unitational. Does it accurately capture the attempts, outcomes, and states of the works? 

## [2] assistant

I’ll audit `NOTEBOOK.md` against repository history, task ledgers, work orders, returns, theorem-status files, and completed artifacts, identifying accurate summaries, omissions, contradictions, and stale statuses.

## [3] assistant

```
bash -lc ls -la /mnt/data | sed -n '1,120p' && find /mnt/data -maxdepth 2 -type d -iname '*unirational*' -print
```

## [4] tool

The output of this plugin was redacted.

## [5] assistant

> [thought] I’m breaking the repository file into smaller sections so I can audit all 55 entries thoroughly. I’ll continue using the available connected source and avoid relying on truncated results.

## [6] assistant

> [thought] I’m continuing the audit in manageable sections, checking the full set of entries and their supporting artifacts rather than relying only on the notebook’s summary. I’ll track evidence, conflicts, and unresolved verification gaps carefully.

## [7] assistant

> [thought] I’m separating the audit into completeness, source comparison, citation and path checks, and substantive mathematical claims. I’m also watching for places where “all corrections applied” may coexist with unresolved conflicts or unverified assertions.

## [8] assistant

> [thought] I’m checking whether statuses, rankings, and claimed completions remain current, especially for geometry, subgroup twists, degree bounds, lens arguments, and the V4 classification. I’ll distinguish genuine closure from partial progress or stale summaries.

## [9] assistant

The prompt’s repository name appears mistyped; I’m auditing `mattrobball/unirational/problems/E-klein-cubic/NOTEBOOK.md`, prioritizing `REPAIR.md` and `CURRENT_PATHS.md`. Reconciliations look fair, but some “PASS/certified” labels overstate verifier coverage.

## [10] assistant

> [thought] I’m comparing the notebook’s 55 entries with its own precedence rules, provenance, and verification caveats. The central question is whether “pass,” “closed,” and “certified” consistently distinguish infrastructure from mathematical proof.

## [11] assistant

```
bash -lc rm -rf /tmp/unirational-notebook-audit && git clone --filter=blob:none --no-checkout --depth 1 https://github.com/mattrobball/unirational.git /tmp/unirational-notebook-audit && cd /tmp/unirational-notebook-audit && git sparse-checkout init --cone && git sparse-checkout set problems/E-klein-cubic && git checkout main && printf 'HEAD=' && git rev-parse HEAD && printf '\nFILES=' && find problems/E-klein-cubic -type f | wc -l
```

## [12] tool

The output of this plugin was redacted.

## [13] assistant

```
{"search_query":[{"q":"site:github.com/mattrobball/unirational \"P25-TOWER-SURVIVES\""}],"response_length":"short"}
```

## [14] assistant

Degree 25 appears wrongly open: later V4 closes its surviving branch. E32 also misstates T/T2R; the headline route is refuted, while R2’s explicit index-two obstruction is underreported.

## [15] assistant

> [thought] I’m finding several concrete mismatches: A0’s verification debt is outdated, degree 25 appears closed at its bounded level, T/T2 is refuted rather than suspended, and R2 has more established content than recorded.

> [thought] I’ve identified further material issues: R2 and Audit A1 are underreported or misattributed, G3 phase passes overstate verification, precedence is chronologically unsafe, and “55 attempts” should be “55 ledger entries.”

## [16] assistant

```
{"uri":"skills://plugins/github/github/skill.md","start_line":1,"num_lines":240}
```

## [17] tool

The output of this plugin was redacted.

## [18] tool

The output of this plugin was redacted.

## [19] assistant

```
{"paths":["GitHub"],"query":"repository"}
```

## [20] tool

The output of this plugin was redacted.

## [21] tool

The output of this plugin was redacted.

## [22] tool

The output of this plugin was redacted.

## [23] tool

The output of this plugin was redacted.

## [24] tool

The output of this plugin was redacted.

## [25] tool

The output of this plugin was redacted.

## [26] tool

The output of this plugin was redacted.

## [27] tool

The output of this plugin was redacted.

## [28] tool

The output of this plugin was redacted.

## [29] assistant

```
{"uri":"/response/turn5","start_line":1,"num_lines":10}
```

## [30] tool

The output of this plugin was redacted.

## [31] tool

The output of this plugin was redacted.

## [32] tool

The output of this plugin was redacted.

## [33] tool

The output of this plugin was redacted.

## [34] tool

The output of this plugin was redacted.

## [35] tool

The output of this plugin was redacted.

## [36] tool

The output of this plugin was redacted.

## [37] tool

The output of this plugin was redacted.

## [38] tool

The output of this plugin was redacted.

## [39] tool

The output of this plugin was redacted.

## [40] tool

The output of this plugin was redacted.

## [41] tool

The output of this plugin was redacted.

## [42] tool

The output of this plugin was redacted.

## [43] tool

The output of this plugin was redacted.

## [44] tool

The output of this plugin was redacted.

## [45] tool

The output of this plugin was redacted.

## [46] tool

The output of this plugin was redacted.

## [47] tool

The output of this plugin was redacted.

## [48] tool

The output of this plugin was redacted.

## [49] tool

The output of this plugin was redacted.

## [50] tool

The output of this plugin was redacted.

## [51] tool

The output of this plugin was redacted.

## [52] tool

The output of this plugin was redacted.

## [53] tool

The output of this plugin was redacted.

## [54] tool

The output of this plugin was redacted.

## [55] tool

The output of this plugin was redacted.

## [56] tool

The output of this plugin was redacted.

## [57] tool

The output of this plugin was redacted.

## [58] tool

The output of this plugin was redacted.

## [59] tool

The output of this plugin was redacted.

## [60] tool

The output of this plugin was redacted.

## [61] tool

The output of this plugin was redacted.

## [62] tool

The output of this plugin was redacted.

## [63] tool

The output of this plugin was redacted.

## [64] tool

The output of this plugin was redacted.

## [65] tool

The output of this plugin was redacted.

## [66] tool

The output of this plugin was redacted.

## [67] tool

The output of this plugin was redacted.

## [68] tool

The output of this plugin was redacted.

## [69] tool

The output of this plugin was redacted.

## [70] tool

The output of this plugin was redacted.

## [71] tool

The output of this plugin was redacted.

## [72] tool

The output of this plugin was redacted.

## [73] tool

The output of this plugin was redacted.

## [74] tool

The output of this plugin was redacted.

## [75] tool

The output of this plugin was redacted.

## [76] tool

The output of this plugin was redacted.

## [77] tool

The output of this plugin was redacted.

## [78] tool

The output of this plugin was redacted.

## [79] tool

The output of this plugin was redacted.

## [80] tool

The output of this plugin was redacted.

## [81] tool

The output of this plugin was redacted.

## [82] tool

The output of this plugin was redacted.

## [83] tool

The output of this plugin was redacted.

## [84] tool

The output of this plugin was redacted.

## [85] tool

The output of this plugin was redacted.

## [86] tool

The output of this plugin was redacted.

## [87] tool

The output of this plugin was redacted.

## [88] tool

The output of this plugin was redacted.

## [89] tool

The output of this plugin was redacted.

## [90] tool

The output of this plugin was redacted.

## [91] tool

The output of this plugin was redacted.

## [92] tool

The output of this plugin was redacted.

## [93] tool

The output of this plugin was redacted.

## [94] tool

The output of this plugin was redacted.

## [95] tool

The output of this plugin was redacted.

## [96] tool

The output of this plugin was redacted.

## [97] tool

The output of this plugin was redacted.

## [98] tool

The output of this plugin was redacted.

## [99] tool

The output of this plugin was redacted.

## [100] tool

The output of this plugin was redacted.

## [101] tool

The output of this plugin was redacted.

## [102] tool

The output of this plugin was redacted.

## [103] tool

The output of this plugin was redacted.

## [104] tool

The output of this plugin was redacted.

## [105] tool

The output of this plugin was redacted.

## [106] tool

The output of this plugin was redacted.

## [107] tool

The output of this plugin was redacted.

## [108] tool

The output of this plugin was redacted.

## [109] tool

The output of this plugin was redacted.

## [110] tool

The output of this plugin was redacted.

## [111] tool

The output of this plugin was redacted.

## [112] tool

The output of this plugin was redacted.

## [113] tool

The output of this plugin was redacted.

## [114] tool

The output of this plugin was redacted.

## [115] tool

The output of this plugin was redacted.

## [116] tool

The output of this plugin was redacted.

## [117] tool

The output of this plugin was redacted.

## [118] tool

The output of this plugin was redacted.

## [119] tool

The output of this plugin was redacted.

## [120] tool

The output of this plugin was redacted.

## [121] tool

The output of this plugin was redacted.

## [122] tool

The output of this plugin was redacted.

## [123] tool

The output of this plugin was redacted.

## [124] tool

The output of this plugin was redacted.

## [125] tool

The output of this plugin was redacted.

## [126] tool

The output of this plugin was redacted.

## [127] tool

The output of this plugin was redacted.

## [128] tool

The output of this plugin was redacted.

## [129] tool

The output of this plugin was redacted.

## [130] tool

The output of this plugin was redacted.

## [131] tool

The output of this plugin was redacted.

## [132] tool

The output of this plugin was redacted.

## [133] tool

The output of this plugin was redacted.

## [134] tool

The output of this plugin was redacted.

## [135] tool

The output of this plugin was redacted.

## [136] tool

The output of this plugin was redacted.

## [137] tool

The output of this plugin was redacted.

## [138] tool

The output of this plugin was redacted.

## [139] tool

The output of this plugin was redacted.

## [140] tool

The output of this plugin was redacted.

## [141] tool

The output of this plugin was redacted.

## [142] tool

The output of this plugin was redacted.

## [143] tool

The output of this plugin was redacted.

## [144] tool

The output of this plugin was redacted.

## [145] tool

The output of this plugin was redacted.

## [146] tool

The output of this plugin was redacted.

## [147] tool

The output of this plugin was redacted.

## [148] tool

The output of this plugin was redacted.

## [149] tool

The output of this plugin was redacted.

## [150] tool

The output of this plugin was redacted.

## [151] tool

The output of this plugin was redacted.

## [152] tool

The output of this plugin was redacted.

## [153] tool

The output of this plugin was redacted.

## [154] tool

The output of this plugin was redacted.

## [155] tool

The output of this plugin was redacted.

## [156] tool

The output of this plugin was redacted.

## [157] tool

The output of this plugin was redacted.

## [158] tool

The output of this plugin was redacted.

## [159] tool

The output of this plugin was redacted.

## [160] tool

The output of this plugin was redacted.

## [161] tool

The output of this plugin was redacted.

## [162] tool

The output of this plugin was redacted.

## [163] tool

The output of this plugin was redacted.

## [164] tool

The output of this plugin was redacted.

## [165] tool

The output of this plugin was redacted.

## [166] tool

The output of this plugin was redacted.

## [167] tool

The output of this plugin was redacted.

## [168] tool

The output of this plugin was redacted.

## [169] tool

The output of this plugin was redacted.

## [170] tool

The output of this plugin was redacted.

## [171] tool

The output of this plugin was redacted.

## [172] tool

The output of this plugin was redacted.

## [173] tool

The output of this plugin was redacted.

## [174] assistant

```
{"uri":"/response/turn46","query":"rank 56/56"}
```

## [175] tool

The output of this plugin was redacted.

## [176] tool

The output of this plugin was redacted.

## [177] tool

The output of this plugin was redacted.

## [178] tool

The output of this plugin was redacted.

## [179] tool

The output of this plugin was redacted.

## [180] assistant

# Verdict

I treated `mattrobball/unitational` as a typo for `mattrobball/unirational`. The file is `problems/E-klein-cubic/NOTEBOOK.md`.

**The notebook is a strong historical and provenance index, but it is not accurate enough to serve as the canonical live-state ledger.** It correctly captures most major approaches, preserves much of the chronology, and usually respects theorem boundaries. The headline status **OPEN** is correct. However:

- one important current mathematical state is wrong: **degree 25 is closed, not open**;
- the T10/binodal result and parts of G3 are given stronger verification statuses than their artifacts justify;
- some substantial packets are described as “uncharacterized” or as providing only an exit label;
- its permanent document-precedence rule can cause older summaries to override later theorems;
- the “55 attempts” are actually 55 heterogeneous records: attempts, infrastructure, audits, dispatches, conjectural implications, and unexecuted proposals.

The current `main` head is the notebook commit itself, `3a486fbdd3be38044ece1651d445ee92aaf35eda`, so these discrepancies are not caused by later repository changes. fileciteturn60file0L3-L4

I audited document-to-artifact consistency and inspected representative theorem files and verifiers. I did not rerun every local CAS computation.

## What the notebook gets right

The notebook correctly presents the central state:

\[
X\text{ is }G\text{-unirational}
\quad\Longleftrightarrow\quad
\operatorname{ed}_{\mathbf C}(G)=3,
\]

and reduces the self-covariant approach to the rational-point problem for the explicit generic twisted cubic \(V(\Phi)\) over \(K_{\mathrm{proj}}\). It also correctly says that finite generation does not produce a degree cutoff and that the rational-point binary remains open. fileciteturn62file0L2-L2

It properly imports most of the July 31 repair layer: `T-NONNORMAL` and \(\dim\operatorname{Sing}(S_G)=2\) are suspended, the degree-13 and degree-19 “obstructions” are only sample residuals, the Path-A single-minor formulation is invalid, and the generic Schur twist is not known to be pointless. fileciteturn15file0L2-L2

Several important route boundaries are accurately reported:

- `B-BRIDGE-REFUTED` really does refute the fixed-frame exhaustiveness mechanism, without proving the genuine Fano twist pointless. fileciteturn61file0L2-L2
- `M3-INTEGRAL-DEGREE4-MULTISECTION` gives a degree-four multisection, while the rational-section question remains undecided. fileciteturn58file0L2-L2
- G4 produces an exact degree-11 closed point, not a \(K_{\mathrm{proj}}\)-point. fileciteturn59file0L2-L2
- J2 closes only the unrestricted resolution-dependent Prym/one-motive obstruction, by constructing countermodels under refinements. fileciteturn56file0L2-L2
- R2 closes the selected Pfaffian elliptic-quintic/residual-quartic route, not all rational-curve routes. fileciteturn54file0L2-L2
- L1 is correctly scoped as formal-recursion infrastructure, not a headline exit. fileciteturn57file0L2-L2

The notebook is also commendably explicit that verifier replay does not prove analytic implications and that external ChatGPT-session claims are not evidence until rederived in-repository. fileciteturn69file0L2-L2

# Material corrections required

## 1. E25, degree 25: the notebook’s state is stale

This is the most important error.

The notebook retains:

> `P25 — OPEN/DEFERRED`

and says the conflict with `DEGREE25-LANDING-EMPTY` is genuinely unresolved because only the order-three branch was newly proved and the order-two and order-at-least-four branches were inherited without verification. fileciteturn83file0L2-L2

That is not the best reading of the current repository evidence.

The exact degree-25 filtration recorded in `HANDOFF.md` is:

\[
59 \longrightarrow 43
  \xrightarrow[\text{order }3]{\operatorname{rank}37}
  6
  \xrightarrow[\text{order }4]{\operatorname{rank}6}
  0.
\]

More explicitly:

1. the three-dimensional first-jet kernel has exact plane order two and is parity-excluded;
2. the exact common-line order-two quotient is parity-excluded;
3. the exact order-three branch is the 37-dimensional quotient;
4. the order-at-least-four branch is six-dimensional and its necessary landing cubics span all \(56/56\) forms.

Crucially, the same passage says that a **from-scratch independent audit rebuilt the complete degree-25 space, both jet filtrations, the point maps, the \(56/56\) landing span, and the \(3124/3124\) overlap rank**. fileciteturn90file0L2-L2

The later V₄ theorem then proves, for every line degree, that there is no \(A_4\)-equivariant simultaneous landing family with involution-plane order \(m=1\) and exact triple-line order three. That kills precisely the remaining 37-dimensional branch. fileciteturn91file0L2-L2

The resulting corollary states:

> `DEGREE25-LANDING-EMPTY`

and combines the three exhaustive branches to conclude that the homogeneous degree-25 landing scheme is empty in characteristic zero. It remains explicitly bounded and does not settle the headline. fileciteturn86file0L2-L2

### Correct state

E25 should read:

> **TERMINAL-NEGATIVE-FOR-DEGREE-25 / BOUNDED-ONLY**  
> `DEGREE25-LANDING-EMPTY`; the characteristic-zero bounded exclusion now extends through degree 25. No all-degree conclusion follows.

The old 63 prepared-but-unrun charts accurately describe an earlier computational route, but they have been **superseded mathematically** for the degree-25 binary. They should be retained as history, not as the live gate.

## 2. E32, T10/binodal: the notebook overstates what is proved

The notebook’s E32 entry says that among the things “actually established” are:

- a divisorial binodal locus;
- `T10-BINODAL-NO-3-DEFECT`.

That is too strong. fileciteturn81file0L2-L2

The direct A1 theorem-boundary audit says:

- the completed ordinary-node model
  \[
  \widehat{\mathcal O}_{B,z}\simeq K'[[x,y,z_1,z_2]]/(xy)
  \]
  was **not** sealed by T9;
- `T-BRANCH-NONNORMAL` is unsupported as a CAS-sealed geometric theorem and survives only as an analytic work-order input;
- the T10 local Picard calculation is sound as algebra for an abstract ordinary node, but its application to the geometric Klein target branch is conditional on that unsealed local-model hypothesis. fileciteturn55file0L2-L2

### Correct state

E32 should distinguish:

- `T-BIRATIONAL`: retained;
- \(S_2\) and \(\dim\operatorname{Sing}(S_G)\le 2\): retained;
- `T-NONNORMAL`, \(R_1\), and exact singular-locus dimension: undecided;
- `T-BRANCH-NONNORMAL`: analytic hypothesis, not independently sealed;
- `T10-BINODAL-NO-3-DEFECT`: **conditional theorem**—if the completed stalk is an ordinary node, there is no relevant 3-primary local Picard defect.

The direct A1 audit is effectively a second correction layer beyond `REPAIR.md`; leaving E03 uncharacterized prevented its corrections from propagating into E32.

## 3. E17, G3H: `PASS` currently means interface installation, not an executable arithmetic point

The G3H status advertises:

> `G3H-SEMILINEAR-G3-FRAME-PASS`.

But the actual frame document leaves the degree-11 extension in abstract form. Its primitive element is “any separating invariant,” and the alleged point is given formally by

\[
a_i=\overline M^{-1}(P_i/\tau^{33}).
\]

It does not install an explicit primitive element, minimal polynomial, multiplication table, power-basis coordinates, or an exact substitution into the 35-coefficient cubic over an executable field model. fileciteturn26file0L2-L2

The phase-4 verifier principally checks hashes, marker strings, degree bookkeeping, list lengths, and the presence of declarations such as `Phi(a_i)=0`; it does not reconstruct \(L_i/K_{\mathrm{proj}}\) and verify the point by field arithmetic. fileciteturn27file0L2-L2

### Correct state

The appropriate label is closer to:

> **G3H-SEMILINEAR-FRAME-INTERFACE-INSTALLED**  
> formula-level descent data present; executable degree-11 field point not independently materialized or verified.

The scoped quadratic-interface no-go may stand at its stated level, but G3H should not be presented as having installed an exact arithmetic point on the full generic cubic.

## 4. E17, G3D: the phase ledger contains unresolved PASS/PARTIAL contradictions

The G3D top-level exit is correctly `G3D-UNDECIDED`. Its prose describes the Clifford and spinor-discriminant stages as partial, while an embedded phase ledger labels corresponding stages as PASS. The 27-line algebra is also partial. fileciteturn31file0L2-L2

The notebook notices this conflict but does not normalize it. The canonical state should be:

- simple-field model, polar cubic surface, Hessian-kernel calculation, and cube reduction: structural passes at their explicit scope;
- Clifford algebra, spinor discriminant, and 27-line algebra: **PARTIAL**;
- rational-point decision: **UNDECIDED**.

Preserving contradictory sublabels is useful for provenance, but they should not both appear as current mathematical states.

## 5. E03 and E28 show that the lens merge missed substantive packet contents

### E03

E03 describes `certificates/audit_a1` as an “uncharacterized” infrastructure packet and says no lens characterized its contents.

The actual file is a substantial theorem-boundary audit with ranked findings, including critical corrections to T10, P25Z, T8, P25Y, older rank-746 claims, and C0. It is not an orphan consisting only of an exit marker. fileciteturn55file0L2-L2

E03 should either be merged into E55 as a later residual audit or identified as a distinct post-repair audit layer.

### E28

E28 says:

> “What was actually established: the exit label only.”

The direct R2 `STATUS.md` gives a detailed theorem:

- the Pfaffian kernel bundle and universal section family;
- smooth elliptic normal quintic verification;
- fixed-point and group-cohomology calculations;
- identification of the descended Hilbert fibre with
  \[
  \operatorname{SB}(A_{\mathrm{proj}}^{\mathrm{op}});
  \]
- index two, hence no \(K_{\mathrm{proj}}\)-point on that selected component.

It also carefully lists the rational-curve routes not excluded. fileciteturn54file0L2-L2

The state `TERMINAL-OBSTRUCTED` is correct, but the recorded outcome is materially incomplete.

These two cases show that checking paths, labels, and hashes did not amount to reading every cited artifact semantically.

## 6. E02/A0 needs a weaker verification class

The notebook calls the A0 packet terminal infrastructure and describes it as certified and replayable, but elsewhere acknowledges that decisive counts such as \(4140/315\) were read from producer JSON rather than independently recomputed. fileciteturn50file0L2-L2

The better description is:

> **PACKET-CONSISTENCY-PASS / INDEPENDENT-RECOMPUTATION-INCOMPLETE**

This does not invalidate the data. It distinguishes an internally consistent producer/verifier pair from a genuinely independent reconstruction.

## 7. E37’s mathematical state is plausible, but its provenance is broken

The notebook cites:

- `tmp/step4_essential_dimension/REPORT.md`;
- `verify_reductions.py`.

That tracked packet is absent from the repository. The substantive proof instead appears directly in `RESOLUTION.md`. It uses:

1. minimal-dimensional versality;
2. Prokhorov’s threefold classification;
3. the cubic/Fano-\(14\) stable birational bridge;
4. the index-\(\le2\) splitting argument;
5. quadratic descent for cubic hypersurfaces;
6. the weakly-versal to very-versal upgrade. fileciteturn68file0L2-L2

The same document then proves the exhaustive passage from an arbitrary honest linear source to a homogeneous self-covariant on \(W\), and the automatic dominance of every nonzero landing covariant. fileciteturn67file0L2-L2

I did not find a fatal issue in that in-repository analytic argument. The problem is the evidence classification:

> **PROVED-ANALYTIC-IN-RESOLUTION**, not “verified by the cited tmp packet.”

The missing artifact should be removed from provenance or restored.

## 8. E07/E08/E26 overstate the Fano common-line gate as an equivalence

The notebook repeatedly says that a \(K_{\mathrm{proj}}\)-point of the twisted Fano \(F_{14,T}\), equivalently a common isotropic right \(D\)-line, is equivalent to the positive headline.

The audited implication is:

\[
F_{14,T}(K_{\mathrm{proj}})\ne\varnothing
\Longrightarrow
C_{\mathrm{gen}}(K_{\mathrm{proj}})\ne\varnothing
\Longrightarrow
\operatorname{ed}(G)=3.
\]

That is a strong **sufficient** positive route. The bridge audit does not prove the converse. Indeed, it explicitly warns that the stable Tschinkel–Zhang product cannot transfer points through the nonsplit Severi–Brauer factor. fileciteturn80file0L2-L2

The entries should say:

> “A common isotropic line is sufficient to settle the headline positively.”

They should not say “equivalent” unless a separate converse theorem is supplied.

# Structural problems with the notebook format

## The precedence rule is not safe

The notebook imposes the fixed order

\[
\texttt{REPAIR.md}
>
\texttt{CURRENT\_PATHS.md}
>
\texttt{STATUS.md}
>
\text{workorders}
>
\text{narrative}.
\]

That is useful for protecting against pre-repair overclaims, but it cannot be permanent. A later theorem can legitimately supersede an older repair or current-paths document. Degree 25 is the concrete failure: the older live ledger says open, while the later V₄ theorem closes the remaining branch.

The rule should instead be:

1. identify the exact mathematical object and scope;
2. apply theorem-boundary corrections;
3. order artifacts chronologically;
4. require an explicit supersession/dependency relationship;
5. compare verification classes;
6. preserve older results only as historical states.

## “55 attempts” is a category error

The index contains, among other things:

- mathematical attempts;
- theorem infrastructure;
- audits and repair layers;
- resource-allocation processes;
- ledger refreshes;
- literature reinterpretations;
- conditional conjectural consequences;
- unexecuted specifications.

Thus “55 canonical records” is accurate. “55 attempts” is not. The conflation also makes terminality statistics misleading: a completed audit and a failed construction are not comparable outcomes.

A `record_type` field should separate:

- `construction`;
- `obstruction`;
- `reduction`;
- `bounded computation`;
- `infrastructure`;
- `audit/repair`;
- `dispatch/process`;
- `conditional implication`;
- `proposal/unrun`.

## “All corrections applied” is too strong

The header says a citation sweep checked 92 status labels, 279 paths, and 103 hashes and that “all corrections” were applied. Yet the notebook itself retains unresolved degree-25 and G3 conflicts, and direct packet inspection reveals the unincorporated A1 and R2 contents. fileciteturn69file0L2-L2

The accurate claim would be:

> “Paths, labels, and hashes were citation-checked; unresolved semantic and theorem-boundary conflicts remain.”

# Corrected current state

The most defensible present ledger is:

1. **Headline:** OPEN.

2. **Central exact reduction:** the problem is equivalent to the arithmetic binary
   \[
   C_{\mathrm{gen}}(K_{\mathrm{proj}})\ne\varnothing
   \quad\text{versus}\quad
   C_{\mathrm{gen}}(K_{\mathrm{proj}})=\varnothing,
   \]
   equivalently the corresponding point problem for \(V(\Phi)\). G/G2 is a structural pass. fileciteturn62file0L2-L2

3. **Dominance:** G3A correctly removes the separate dominance gate once a genuine generic-twist point or nonzero landing covariant is found.

4. **Bounded landing ladder:** no homogeneous landing self-covariant exists in degrees at most **25**. Degree 25 is a bounded negative theorem, not an open chart computation. There remains no all-degree bound. fileciteturn90file0L2-L2 fileciteturn91file0L2-L2

5. **G3 arithmetic:** OPEN. G3H is an installed symbolic interface rather than an independently executable degree-11 point; G3D is partial/undecided.

6. **Principal live positive gates:** the direct generic cubic point problem; the corrected Fano/common-isotropic-line problem; the residual M3 rational-section problem; potentially the Schur and rational-curve classes not closed by R2.

7. **Principal live negative gates:** the genuine \(11{:}5\) trace cubic and other genuine-twist arithmetic. The fixed-frame B bridge is dead. The T normalization route is auxiliary after B and remains suspended at its exact normality/class-group gates.

8. **Scoped terminal results:** B bridge refuted; J2 unrestricted invariant neutralized; R2 selected elliptic-quintic component obstructed; theta/Schwarz candidate refuted; finite binary secant constructions excluded; several KLS and Fable subfamilies closed. None is a headline theorem.

# Required notebook edits

The minimum repair set is:

1. Change E25 to `DEGREE25-LANDING-EMPTY — bounded only`.
2. Update the bounded cutoff from 24 to 25 wherever it appears.
3. Demote G3H to an installed formula/interface pending executable field arithmetic.
4. Normalize G3D’s Clifford, spinor, and 27-line stages to PARTIAL.
5. Incorporate the direct A1 audit into E03/E55 and propagate its T10 corrections.
6. Make T10’s no-3-defect result conditional on the ordinary-node hypothesis.
7. Replace E28’s “exit label only” account with the actual R2 theorem and scope.
8. Reclassify A0 as packet-consistency verified, not independently recomputed.
9. Repair E37’s provenance to point to the analytic proof actually present in `RESOLUTION.md`.
10. Replace “equivalent” by “sufficient” for the \(F_{14,T}\)-point route.
11. Rename the index “55 canonical records.”
12. Replace static document precedence with chronological, dependency-aware supersession.
13. Add fields for `as_of_commit`, `record_type`, `verification_class`, `supersedes`, and `superseded_by`.

**Final assessment:** `NOTEBOOK.md` is substantially better than the earlier ledgers and is valuable as a comprehensive research history. It accurately preserves most attempts and most route-scoped outcomes. It does **not** presently give a fully accurate account of the live mathematical state. Until the corrections above are made, it should be treated as a high-coverage audit narrative and provenance map, not as the canonical source of truth.
