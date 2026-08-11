<!-- D35_CELLS_20260811 -->

## 2026-08-11 The two one-dimensional cells at `d = 35` are dead, and `d' = 4, 5` die in every degree

Packet: `goal_runs_20260811/RT_ACTUAL_LANDING/D35_K30_K31_CELLS.md`,
`verify_d35_cells.py` (`RESULT: PASS`, 89 exact checks, ~17 s). Branch
`agent/d35-onedim-cells-20260811`. Problem E remains **OPEN**.

`D35_BRANCH_TABLE.md` §3 registered two cells of the `d = 35` table as
"immediately actionable" and left them open: `k = 31` (`d' = 4`) and `k = 30`
(`d' = 5`), where the ramification section `j_phi` spans a one-dimensional
invariant space. Both are now **DEAD**, and they die one step earlier in the
chain than the ramification test that was registered for them.

**The candidate space is one projective point, not a pencil.** The branch table
expected a two-dimensional family at `d' = 4`, from `dim Cov_4 = 2`. But `B`
lives *on `X`*, i.e. modulo `F`, and one of the two basis members is `F·x`,
which restricts to the zero tuple. Multiplication by `F` is an injective
`G`-map and `G`-invariants are exact in characteristic zero, so the right count
is

```
dim ((S/F)_{d'} (x) W)^G = C(d') - C(d'-3),
```

which is `2 - 1 = 1` at `d' = 4` and `1 - 0 = 1` at `d' = 5` (`C(2) = 0`, so
there is no pencil at all in the second cell). Each cell offers exactly one
candidate up to scalar: `D_4 mod F` and `D_5 mod F`. The degeneration locus of
the `d' = 4` pencil is exactly the member `F·x`, confirmed parametrically.

**That candidate does not map `X` into `X`.** A restricted tuple must satisfy
`F(B) = 0` on `X` - forced by `0 = F(T)|_X = H^3 F(B)`, `THEOREM_SOURCE_TANGENCY.md`
§4. The test is scale-invariant (`F(cB) = c^3 F(B)`), so each cell is a single
finite check, and both fail: `nf(F(D_4))` has 92 terms and `nf(F(D_5))` has 185,
where `nf` is the Gröbner normal form modulo the principal ideal `(F)`. Second,
independent certificate needing no ideal theory: at `p = (1,1,1,-2,0) in X`,

```
D_4(p) = (56,-28,6,34,34),   F(D_4(p)) =   22160 != 0
D_5(p) = (21,51,-2,65,-54),  F(D_5(p)) = -149365 != 0
```

Three further points of `X` witness the same. So there is no `G`-equivariant
restricted selfmap of coordinate degree `4` or `5` at all, and every test the
branch table queued behind this one - dominance, `j_phi`, its membership in the
one-dimensional `H^0(X,O(6))^G` / `H^0(X,O(8))^G`, the base locus, `delta`, the
CLEAN norm test - is **undefined rather than uncomputed**. Recorded as such.

**Degree-uniform, and unconditional.** No step mentions the ambient degree, so
`d' = 4` and `d' = 5` are impossible in **every** `d`, and the surviving
restricted-degree set becomes `d' = 1` (retraction), `d' in {6,...,d-5}`, or
`d' = d` (`k = 0`, CARRIER) - the middle range of (39) shrinks from `{4,...}`.
And nothing uses the dominance of `phi`: unlike `EXCLUSION_DPRIME_2_3.md`, this
exclusion does **not** consume the accepted input `ed_C(PSL_2(F_11)) >= 3`. The
same bookkeeping re-proves `d' in {2,3}` on those weaker hypotheses
(`C(2) = C(3) = 0`: no candidate exists, dominant or not), so that sealed
exclusion loses its conditionality too.

**A new named object, `D_5`.** The generator of the one-dimensional `Cov_5`:
primitive, defined over `Q`, nine terms per component, automatically
divergence-free (the sealed table has `dim divfree(Cov_5) = C(5) = 1`), with
leading terms `(x_1^5, x_2^5, x_3^5, x_4^5, x_0^5)` and every other coefficient
divisible by `5`. Audited on a second, code-disjoint arithmetic path - `sigma`
by substitution, `tau` as a weight condition mod `11`, `iota` rebuilt from the
repository's Gauss-sum formula inside `Q[z]/(z^11-1)` - exactly as `D_4` was in
`verify_d4_covariant.py`.

**Convention-independent.** `PSL(2,11)` has two 5-dimensional irreps, swapped by
its outer automorphism, and both preserve the Klein cubic; the packets use the
untwisted convention without excluding the twisted one. Under the twist the
candidate spaces are again one-dimensional (`1 - 0` and `2 - 1`) and again fail,
with point certificates `-5625` and `-10105`; the twisted `d' = 5` pencil
reduces exactly as `nf(F(B)) = (lambda+mu)^3 nf(F(P_0))`, its degenerate member
being `F` times the twisted quadratic covariant
`Q_2[i] = -(x_i^2 + 2x_{i+1}x_{i+2})`. So the verdict does not depend on the
convention.

**A method note worth keeping.** `sympy.div` on multivariate input is not a full
reduction: it returned a 159-term "remainder" for `F(D_4)` where the true normal
form has 92. A nonzero `div` remainder is therefore **not** a proof of
non-membership. Only `sympy.reduced` (and the point certificates) appear in the
verifier. The verdict was the same either way here, but the distinction is
recorded because it would not always be.

**Net.** Two more cells die in every ambient degree; the two cells the previous
round flagged as the concrete next computation are resolved, negatively; one
sealed exclusion is upgraded to unconditional; one new covariant is boxed. Open
cells at `d = 35` go from 29 to 27 (`k = 0`, `k = 5..29`, `k = 34`). No branch
closes - the excluded band is the small-`d'` end, and the sealed sieve's
`delta = 3` survivor lives at `k = 0`, `d' = d`, untouched.
`PROBLEM-E-HEADLINE-OPEN`.

Exits added by this round:

```text
D35-K31-CELL-DEAD
D35-K30-CELL-DEAD
RESTRICTED-COORDINATE-DEGREE-FOUR-AND-FIVE-EXCLUDED-ALL-DEGREES
NONIDENTITY-RESTRICTED-COORDINATE-DEGREE-AT-LEAST-SIX
DEGREE-FIVE-COVARIANT-EXPLICIT
RESTRICTED-DEGREE-EXCLUSIONS-UNCONDITIONAL-ON-DOMINANCE
```

Superseded (still true, no longer sharp):
`NONIDENTITY-RESTRICTED-COORDINATE-DEGREE-AT-LEAST-FOUR`.
