# WORKORDER — The landing certificate on the 37-cell at d = 35

Issued 2026-08-11 (director, cycle 3). The endgame computation: everything
so far imposed LINEAR necessary conditions; the landing equation itself —
`F(T) ≡ 0`, a cubic system — has never been imposed. The candidate space
is now ONE 37-dimensional linear space (the sealed 39-dim Layer-0 slice
cut by the six universal flip conditions), and the 22 surviving
blueprints are 22 open-condition profiles on it. Decide what the cubic
does to it. python3 + msolve + M2 allowed (never gap/gp/sage/magma); no
git; packet `goal_runs_20260811/D35_LANDING/` only.

Read first: `PAIR_ATTACK_D35/THEOREM.md` §12 and `WORKED_EXAMPLE.md` §6
(what is sound and what was retracted); `theory/
CONSTRAINT_ADDITIONS_20260811.md` (the four-outcome certificate is the
confirmed plan there); the D34 engine (`D34_GUIDED_SWEEP/slicelib.py`)
for evaluating slice covariants at points.

## The object

Inputs on disk (PAIR_ATTACK_D35/results/): `layer0_null_p{331,661}.npy`
(the 39-dim slice in the 637-seed coordinates), the six-flip matrix in
`worked_example_p{331,661}.json` (`universal_matrix_6x39`). The 37-cell =
the kernel of that 6-row system inside the slice. `F = Σ_{i∈Z/5} x_i²
x_{i+1}` is the Klein cubic. For `T` in the cell (coordinates
`c ∈ F_p^37`), each sample point `x ∈ P⁴(F_p)` gives one explicit CUBIC
`F(T_c(x)) = 0` in `c` (evaluate the 37 basis covariants at `x` via the
D34 engine's Reynolds-sum evaluation, then plug the 5-vector into `F`).

## The four-outcome certificate (deliver ONE, with evidence)

- **O1 EMPTY:** the only solution over F̄_p of the sampled cubic system
  (saturated by the degenerate loci below) is 0, at BOTH primes, with a
  Groebner certificate (the sampled ideal is the irrelevant ideal, msolve
  or M2) — the precedent is FIX-VII-LAND's certificate. Then no pair
  survives at d = 35: **FLAG as window-closure candidate, do not claim**
  (audit gate; a modular emptiness certificate at two primes is the
  campaign's standard evidence class).
- **O2 DEGENERATE ONLY:** solutions exist but every component lies in a
  degeneracy locus: `T|_{L_σ} ≡ 0` (kills all 22 blueprints — their line
  branches demand order 0), or the `(34,1)`-datum ≡ 0 (no sweep), or
  `T ≡ 0` on a plus-plane to excess order. Certify component-by-component
  (saturation or per-component witnesses).
- **O3 CANDIDATE:** a solution passes the open conditions (line reading
  nonzero, datum nonzero). Then produce the explicit witness mod both
  primes, attempt rational reconstruction / Hensel lift documentation,
  and FLAG LOUDLY: a candidate landing covariant at d = 35 would be a
  positive-side sensation and gets the same adversarial gate.
- **O4 INCONCLUSIVE:** state exactly where it stuck (degree of the
  computed ideal truncation, msolve resource wall, sampling insufficiency
  with the rank plateau recorded).

## Method requirements

1. Sampling: ≥ 300 points, saturation-checked (the span of the cubics'
   coefficient vectors in `Sym³(37-space)*` must plateau; report the
   plateau dimension — that number is itself a deliverable:
   `dim` of the degree-3 piece of the landing ideal on the cell).
2. Exploit the `G`-structure: the 39-slice is `G`-stable; compute the
   isotypic decomposition of the 37-cell (character of the `G`-action on
   it — the D34 frame gives the 660 matrices) and use it to
   block-structure the system before Groebner; report the character.
3. Two primes end to end; any Groebner emptiness certificate replayable
   by `verifier.py`.
4. The 22 open profiles: after O1/O2/O3 is decided, say per blueprint
   what remains (dead / alive-with-witness / conditional).

## Protocol

Packet `goal_runs_20260811/D35_LANDING/`: `THEOREM.md` (never REPORT.md),
`scripts/`, `results/`, replayable `verifier.py`, `REGISTRATION_SNIPPET.md`
(ODDZERO format, entry E56, goal_run, tracked true), honesty tiering
(modular certificates are Tier 2; say so), exit ledger (`D35-LANDING-*`),
"Not claimed". Headline fixed: "Problem E remains OPEN; this packet
excludes no degree" — even under O1, the claim waits for the audit.
Print a ≤ 25-line summary: outcome, plateau dimension, cell character,
per-prime certificate status.
