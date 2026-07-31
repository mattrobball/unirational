# Route G (CAS order) — G4.1 / G4.2 verdict record

**Recorded by:** director session, 2026-07-31.
**Order:** `WORKORDER_CAS_HEADLINE.md` §4.
**Artifacts commit:** `17011c3` (swept in by a directory-wide `git add`
alongside P25.1; that commit's message describes only P25.1 — this file is
the Route G record).
**Verifiers replayed by the director:** `G41_FREE_FORMULA_VERIFY_OK`,
`G42_GLOBAL_MODULE_VERIFY_OK`, `G_A_NO_FINITE_GLOBAL_PRESENTATION`.

## G4.1 — symbolic terminal formula: ACHIEVED

The previous cycle reached only `G-PATTERN` (an interpolated congruence over
three bidegrees). This dispatch obtained the **symbolic identity** §4 demands.

The structural fact that unlocks it: the jet coefficients depend only on the
**relative order `s = order − m`**, not on `m` and `d` separately. That gives
a universal recurrence rather than a per-degree tensor:

- `B_s` is hypergeometric;
- there is an exact **cubic recurrence** for `(alpha_r, beta_r)` via
  `L(b) = B(b; a, a) = −R^pre`, with the inactive monomial classes vanishing.

Verified on sparse checks at `(1,9)`, `(1,11)`, `(3,9)`, `(5,11)`, `(7,15)` —
i.e. **outside** the three sample bidegrees that generated the earlier
conjecture, which is what makes this a test rather than a refit.

## G4.2 / gate G-A — NO finite global presentation

Exit `G_A_NO_FINITE_GLOBAL_PRESENTATION`; obstruction
`G42-OBSTRUCTION-EQUALIZER-REES-GROWTH`.

The split is precise:

| Layer | Finitely presented? |
|---|---|
| Free-fibre `Theta` (universal recurrence as an `(N_star+1) x 2` matrix) | **Yes** |
| Multi-Rees jet / `V_4` equalizer / point kernel / character-block Fitting data | **Not known to be** |

The multi-Rees jet rank grows as a **cubic in `d`**, and the equalizer,
point-kernel and character-block Fitting data are not known to be finitely
generated over the pure `(m,d)` semigroup algebra. **The free-fibre chart is
finitely presented; that is not the full G4.3 object.**

Per §4 the worker reported the exact obstruction and **did not run a degree
ladder**. Regression against the sealed degree 7, 13, 19 packets passes.

## Consequence

`G4.3` cannot proceed on the current gradings, so exit **`G-NEGATIVE` is not
reachable by this construction as posed**. The named prerequisite is now
either a different grading, or a proof of finite generation for the
equalizer/Fitting layers.

Cross-reference: `P25.1` independently showed that a **nonzero terminal
residual does not kill a family** — later kernel freedom absorbed it at
`(1,25)` (rank 27 into a 29-dimensional codomain, both families). Together
these say the terminal-residual route is weaker evidence for an all-degree
obstruction than the sample towers suggested.

**Headline OPEN.**
