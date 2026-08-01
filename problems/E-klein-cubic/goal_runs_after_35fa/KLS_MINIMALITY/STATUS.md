KLS2-NO-FINITE-REDUCTION

# Status

The KLS2 route is complete at its exact no-finite-reduction exit.  The main
Klein-cubic `G`-unirationality problem remains **OPEN**.  This packet does not
claim `KLS2-COUNTEREXAMPLE` or a headline negative theorem.

## Binary route decision

The requested minimality-to-discrepancy program has two possible readings,
and neither supplies the advertised finite elimination.

1. Under the literal **Klein-landing** reading, a primitive rank-four
   covariant has projective image equal to the smooth Klein cubic.  Its
   pulled-gradient gcd is exactly `h=1`; the image normalization is the image
   itself and its conductor is zero.  The exhaustive conductor ledger is the
   singleton `LANDING_SMOOTH_H1`, whose existence is precisely the original
   all-degree landing-covariant problem.  The historical `P22` eliminations
   do not eliminate this singleton.
2. Under the broader **KLS rank-drop** reading, the image may be a singular
   invariant hypersurface and the conductor identities apply.  Primitive
   least-degree minimality is well-defined, but its strongest proved
   consequence is `d <= 2m`.  Quartic precomposition raises degree, and
   neither it nor primitive saturation controls discrepancies or reduced
   conductor-pullback support.  Exact countermodels show that all generic
   lc/plt/normality substitutes fail.  No representation-specific theorem
   converts this data into a finite exhaustive list.

Thus KLS2.1 does not produce the required nontrivial finite classification;
KLS2.2--KLS2.4 cannot begin without assuming the missing conclusion.  This
is exactly the `KLS2-NO-FINITE-REDUCTION` exit authorized by the goal file.

## Repository state

- Pinned state: `35fa8f59b6a1423cc89300aeaceefe91552be5ba`.
- Live commit consumed: `37d61c19a108781cf74af837e24810a9f7f7c3be`.
- The intervening KLS-relevant change is the KLS2 goal/portfolio itself; no
  new KLS theorem packet was added after the pinned state.
- Commit produced: none; the finalized artifacts are an isolated uncommitted
  route packet.

## Work-package decisions

| Package | Decision |
|---|---|
| KLS2.0 | Complete.  Primitive saturation and least degree give the exact minimal representative; precomposition and source birational changes are not map-preserving equivalences. |
| KLS2.1 | Refuted as a nontrivial theorem on the literal landing category; unavailable on the broader KLS category. |
| KLS2.2 | Literal landing ledger is the singleton `h=1`; the broader KLS ledger is not proved finite. |
| KLS2.3 | Scoped historical `P22` eliminations replayed; the live singleton and open KLS families are not eliminated. |
| KLS2.4 | Not achieved.  No universal KLS or landing-covariant exclusion follows. |

## Verification

From the Problem E directory run:

```sh
/opt/homebrew/bin/python3 -u \
  goal_runs_after_35fa/KLS_MINIMALITY/verify.py

/opt/homebrew/bin/python3 -u \
  goal_runs_after_35fa/KLS_MINIMALITY/verify.py --deep
```

The default verifier recomputes smoothness of the Klein cubic on all five
projective charts, the two exact generic countermodels, all degree and scope
ledgers, source hashes, and the content seal.  `--deep` also reruns the nine
load-bearing historical KLS verifiers.

