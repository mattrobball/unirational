# Sources and dependencies

## Internal exact inputs

- `F55_AUDIT_20260808.md` for the authoritative trace equation.
- `goal_runs_20260808/TRACE_POSITIVE/ANALYTIC_AUDIT.md`, Sections 2--4,
  for the `2+sigma` divisor residue and the one-eigencharacter exclusion.
- `F55_POLAR_CIRCUIT_PROOF_REDUCTION_20260808.md`, Proposition 2.1,
  for invariant denominator clearing.

## External theorem used

- The ordinary three-term Mason--Stothers theorem for coprime one-variable
  polynomials.  Only its standard inequality
  `max degree <= degree(rad(ABC))-1` is used, after restriction to a generic
  one-parameter torus coset.

## Difference-radical comparison

- K. Ishizaki, R. Korhonen, N. Li, and K. Tohge,
  *A Stothers--Mason theorem with a difference radical*, Math. Z. 298
  (2021), 671--696,
  <https://doi.org/10.1007/s00209-020-02604-7>.

That paper treats a nonzero translation of one variable.  Section 7 of the
theorem packet gives an exact semi-invariant counterexample to replacing its
translation by the present finite-order automorphism.

## Multi-term boundary comparison

- M. de Bondt, *Another generalization of Mason's ABC-theorem*,
  <https://arxiv.org/abs/0707.0434>.

Section 6 uses only the numerical shape of the standard five-term bounds and
the refined local weight by the number of nondivisible summands.  Those
bounds are audited there as nonverdicts, not invoked to claim pointlessness.
