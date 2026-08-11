# WORKORDER — The pair attack at d = 35: r-side compiler over the classified patterns
# (handoff queue item 4, first engagement)

Issued 2026-08-11 (director). python3 exact / two primes `331, 661` for
modular linear algebra; `msolve` and `M2` (Macaulay2) are available for any
Groebner step (NEVER `gap`/`gp`/sage/magma — shell aliases trap). No git
operations; no edits outside your new packet
`goal_runs_20260811/PAIR_ATTACK_D35/`.

## A. The object

A pair `(T, r)`: `T ∈ M_35 = (Sym³⁵W* ⊗ W)^G` a reduced landing tuple
(map-level, `d_min = 35`; `dim M_35 = 637`), `r` a classified complex-of-
groups boundary pattern at the residue of 35. The attack: for each `r`,
compile the linear conditions `r` forces on `M_35` together with the sealed
degree-35 cuts, and decide the cell — empty (that `r` is dead at 35) or a
surviving slice (explicit basis, queued for realization tests).

Residues of 35: `5 (mod 6)`, `0 (mod 5)`, `2 (mod 11)`, `2 (mod 3)`.
Consequences you must impose from the sealed record (verify each citation
before use):

* σ-band: `K(5) = 756` corrected patterns
  (`goal_runs_20260811/STAGE1_STRATIFIED`, regenerate the actual patterns
  via its `scripts/`); minus-lines NOT all in `Bs` (`d` odd);
  `ord_{L_σ}(T)` even (0 allowed) — `STAGE2` §4 mod-6 row.
* `5 | 35`: all 264 C5-points in `Bs(T)`; `5 ∤ μ` constraints.
* `35 ≡ 2 (mod 11)`, non-residue: all 60 C11-points in `Bs(T)`, `μ ≥ 1`.
* `35 ≡ 2 (mod 3)`: each C3-eigenline contracts to the `X^{C6}` point on
  the other line; `X^{C6}`: `T` swaps the two points (`d ≡ 5 mod 6`).
* A4-points: `μ ≥ 2` (`STAGE2_SECOND_ORDER`, sealed).
* The handoff (§1) records "ambient dimension ≤ 39 after the sealed cuts"
  at `d = 35`: locate the sealed cut list that produces it (follow the
  handoff's citations; the D34 window packet's structure is the pattern),
  recompute the cut slice yourself, and cross-check its dimension — if you
  cannot reproduce ≤ 39, STOP on that branch and report the discrepancy
  prominently rather than proceeding on an unverified slice.
* Route filters (handoff §2): no factoring through V14; central-character
  ledger (spin only through even pairs — at odd `d = 35`, spin→spin
  allowed, linear→spin impossible); Duncan imports by label.
* Compiler constraints from `theory/CONSTRAINT_ADDITIONS_20260811.md`:
  C4 (polar/Hessian tower — linear in jets), C6 (tangent/obstruction),
  C13 (tropical/Newton prefilter) — fold into the linear layer per that
  file's imposition order.
* Peer-lane inputs (cite, do NOT recompute or touch their methods):
  `goal_runs_20260811/RT_ACTUAL_LANDING/D35_BRANCH_TABLE.md` — restricted
  degrees `d′ = 2,3,4,5` are excluded in all degrees, `k = 32, 33`
  excluded; their 27 open cells are a T-side decomposition; yours is
  r-side. Where a forced condition of yours meets one of their cells,
  record the intersection, do not re-derive their cell.

## B. Architecture — hierarchical compiler, prune-as-you-go

Do NOT enumerate the full product `756 × D10 × F_odd` flat. Build a tree:

1. **Layer 0 (r-independent):** the sealed cuts + C4/C6/C13 on `M_35` →
   the base slice (target: reproduce ≤ 39). Exact rank computations at
   both primes; keep the constraint matrix factored (shared rows reused
   across the tree).
2. **Layer 1 (σ-band):** for each of the 756 patterns: the full-flag
   leading-datum conditions (multidegree class, values, stratified levels
   from `s3jet.py` semantics) → per-pattern slice; kill and record dead
   branches immediately.
3. **Layer 2 (D10 + odd-order):** impose the D10 branch (μ₁-parity;
   `d = 35` odd) and the odd-order value assignments lazily. If
   `goal_runs_20260811/GLOBAL_COHERENCE/results/` exists (a parallel
   worker is producing the exact shared-μ vectors and `G(35 mod 330)`),
   consume its value-vectors; otherwise run with free odd-order values and
   state that the tree only shrinks under the join.
4. **Survivors:** explicit `(r, slice basis)` per live leaf, ranked by
   slice dimension; per-layer death statistics (which mechanism killed how
   many branches — this feeds strategy).

## C. Verdict semantics, stakes, framing (mandatory)

Everything here is map-level (`d_min = 35`). If EVERY branch dies at the
linear layer, that is "no map with minimal presentation degree 35 passes
the order-0 + pinning + compiler constraints" — a window-closure-adjacent
statement: FLAG IT, DO NOT CLAIM IT; name an ODDZERO-standard adversarial
audit as the promotion gate; the window statement stays "first open window
d = 35" until promotion. If survivors exist, no exclusion is claimed and
the survivor list is the deliverable. Headline fixed: "Problem E remains
OPEN; this packet excludes no degree." Any use of a transport argument is
out of scope here (map-level; see
`theory/EXCLUSION_TRANSPORT_20260811.md` §6).

## D. Packet protocol

`goal_runs_20260811/PAIR_ATTACK_D35/` with `THEOREM.md` (main document —
the harness refuses `REPORT.md`; ≤ 500 lines), `scripts/`, `results/`
(machine-readable survivor list + death statistics), replayable
`verifier.py` (check groups: slice-dimension cross-check vs the sealed
≤ 39; anchor replays of every consumed sealed constraint; per-layer
counts; cross-prime; spot re-verification of ≥ 20 random dead branches
and EVERY survivor), `REGISTRATION_SNIPPET.md` (ODDZERO format,
`entry: E56`, `kind: goal_run`, `tracked: true`). Honesty tiering; exit
ledger (`PAIR-ATTACK-D35-*`); "Not claimed". Do not commit. Print a
≤ 30-line summary: base-slice dim, per-layer death table, survivor count
(with dims) or the all-dead flag, verifier totals.
