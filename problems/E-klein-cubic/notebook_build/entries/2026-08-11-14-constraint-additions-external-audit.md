## 2026-08-11 Fourteen constraint mechanisms folded in from an adjudicated external audit

Documents: `theory/CONSTRAINT_ADDITIONS_20260811.md` (the fold-in) and
`external_docs/chatgpt_20260811_T_constraint_audit.md` (the archived source).
Problem E remains **OPEN**.

An external exhaustive constraint audit of landing tuples `T` was extracted,
read in full, and adjudicated against the sealed state: no conflicts; its one
pending dependency (the odd-residue zero) had already been resolved as
ARTIFACT by `ODDZERO_AUDIT`, killing its hoped-for shortcut to closing
`d = 35`; its "must not be counted as established" list matches our
corrections ledger. Most of its content is a recital of sealed results; the
genuinely new mechanisms were folded into the constraint ledger as C1-C14:

**FORMAL (ready to impose):** C1 the relative-canonical genus identity
`2g - 2 = (2d-5)nu + Sigma(a_E - 2m_E)e_E` with `d nu = Sigma m_E e_E`
(at `d = 35`: `65 nu`); C2 graph multidegrees with log-concavity
`g_2^2 >= 3 d nu`; C3 dominance as commutative algebra (special-fiber
algebra `= C[y]/(F)`, analytic spread 4, Gorenstein, Hilbert series
`(1-z^3)/(1-z)^5`, equivariant syzygies); C4 the polar/Hessian tower
`grad F(T) . J_T = 0` (linear in jets -- goes into the `d = 35` compiler);
C6 landing-scheme tangent/obstruction spaces; C13 tropical/Newton prefilter.

**NEW-LANE:** C5 the kernel foliation of the one-dimensional fibers (the
missing differential package); C7 fixed-fiber realizability
(Riemann-Hurwitz + Burnside/Dress mark congruences); C8 Lefschetz-trace
coupling of the CM norm `delta` to fixed-locus data; C9 the integral
polarized `O_{-11}`-lattice strengthening of CLEAN; C10 orbit-summed
Abel-Jacobi (the corrected global form of the refuted componentwise
exclusion); C11 spin Brauer residues along Rees divisors and index reduction
along the generic fiber; C14 the generic-fiber trichotomy tied to ambient
Hodge support.

**CAVEAT:** C12 all classifications must be stated up to the semigroup of
postcompositions by dominant self-maps of `X`.

The audit's recommended attack order coincides with `HANDOFF_2026-08-11.md`
section 4 (which now carries a pointer to the fold-in); no re-planning
needed.

Exits: none (documentation integration; no theorem claimed, no degree
touched).
