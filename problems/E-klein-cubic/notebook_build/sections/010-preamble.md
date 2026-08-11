# Problem E notebook — PSL(2,11)-unirationality of the Klein cubic

A canonical record of all recoverable Problem E route families, executed runs,
dispatched-but-unexecuted proposals, correction layers, and imported session
records represented in the tracked repository as of the as-of commit below,
with branch-level and local-only supplements noted inline. Each record carries
its justification, status, verification class, and outcome. Supersedes
`PROBLEM_E_ATTEMPT_LEDGER_2026-08-02.md` and
`GOALS_NEXT_10_ROUTES_2026-08-02.md` as the tracking documents; mathematical
status is resolved by the layered precedence rule in Binding rules below (the
theorem-boundary correction layers `REPAIR.md` and `certificates/audit_a1`,
then explicit supersession, then chronology and dependency).

Canonical route-family ledger: individual runs, sub-runs, and certificate
packets are indexed one-per-record in `notebook_build/manifest.json` (the
per-artifact crosswalk, parity-checked by `scripts/check_manifest_parity.py`);
this document is not an event-by-event log.

**Coverage contract.** Complete at canonical route-family level as of the
stated parent head. Machine-parity coverage applies to `goal_runs_after_*`
run directories and direct `certificates/*` packets (structural checks plus
coverage-by-mention for `goals_*` worker roots, `external_sessions/`, and
`external_packets/`); proposal, session, branch, and local-only evidence is
manually indexed. The checker verifies structure and pins, not mathematical
semantics.

**Coverage frontier (closed 2026-08-03).** The full space of places Problem E
work can exist, enumerated and swept: (i) top-level documents — swept (7
lenses); (ii) `goal_runs_after_*` run dirs — swept, manifest+checker (75);
(iii) `certificates/*` — swept, manifest+checker (47); (iv) `goals_*` goal
files — swept; (v) `goals_*` worker roots — swept (43; 7 unpromoted results
recorded); (vi) `tmp/` — fully inventoried in
`notebook_build/tmp_disposition.md` (362 dirs: 245 corpus-cited, 117 triaged,
19 previously unrecorded now in [E16](#e16)/[E35](#e35)); checker-enforced;
(vii) deleted-in-history paths — swept, closed (233 regenerable msolve inputs
+ 2 accounted files); (viii) remote branches — inventoried (15 after this
publication; 2 unique packets archived); (ix) PRs/issues — swept (6 PRs all
recorded, 0 issues); (x) other
problems' directories — swept (no substantive E work; only cross-references
and the F-side source of E14's transfer story, `F-dp2-psl27/RESOLUTION.md`);
(xi) NON-ENUMERABLE remainder, permanently outside any sweep: scratch trees
on other workers' machines, and external sessions never shared into
`external_sessions/`. Families (i)–(x) were manually swept as of 2026-08-03.
The checker **continuously** enforces only: the enumerated run/certificate
structure, manifest typing, pinned branch heads, the remote-branch inventory,
and name-level mention coverage (goal roots, sessions, packets, top-level
documents, `tmp/` against its disposition inventory). It does not detect new
content placed inside an already-mentioned directory, new PRs/issues, future
deletions, cross-problem placement, or semantic drift inside packets — those
families require periodic manual resweeps. The non-enumerable remainder is a
disclosed boundary, not a coverage claim.

Core manifest last rebuilt: 2026-08-03. Research supplement last updated:
2026-08-10. Headline status: **OPEN**.
Snapshot metadata — notebook parent head: recorded in
`notebook_build/parent_head` (the repository state this revision was authored
against — a file cannot carry its own commit hash, so the committing revision
is always `git log -1 -- problems/E-klein-cubic/NOTEBOOK.md`).
`scripts/check_manifest_parity.py` verifies at pre-commit time that the
recorded parent equals the current HEAD. **This file is GENERATED** from
`notebook_build/sections/` and `notebook_build/entries/` by
`notebook_build/generate_notebook.py`: edit those sources, never this file, and
regenerate with `notebook_build/reconcile.py` — protocol in
`notebook_build/PROTOCOL.md`.
Manifest snapshot: the `as_of_commit` block inside
`notebook_build/manifest.json`. Branch inventory: 2026-08-09, including the
additional `agent/f55-audit-obstruction` head `851e9ac…` and this notebook's
publication branch; previously archived unique heads remain `086e0892…`
(G3P) and `6fdac74f…` (M3). This file's own commit is the child of the audited
state.

Citation-verified 2026-08-03: a four-agent sweep checked 92 status labels, 279 cited
paths, and 103 commit hashes against artifacts. **Paths, labels, and hashes were
citation-checked; semantic and theorem-boundary conflicts are not thereby settled and
are tracked in Open conflicts below.** A second review round (2026-08-03, an external
review confirmed/refuted claim-by-claim against repo artifacts) is recorded in
`## 2026-08-03 review round`. Lens and session provenance in `notebook_build/`.

Content provenance is two-stage: `notebook_build/canonical_attempts.md` is the
frozen PRE-adjudication merge of seven lens reports (it retains pre-correction
states for E03, E25, E17, E28, E32 and the retired static precedence rule — do
not regenerate from it); the 2026-08-03 review rounds then applied adjudicated
corrections directly in this file. Machine-readable current state:
`notebook_build/manifest.json`. External-session content:
`notebook_build/sessions_batch1.md` … `sessions_batch4.md`. History anchors:
`notebook_build/lens_gitlog.md`.
