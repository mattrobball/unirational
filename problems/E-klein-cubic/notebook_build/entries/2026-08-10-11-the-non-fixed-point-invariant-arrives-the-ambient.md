# Notebook supplement — 2026-08-10: the non-fixed-point invariant arrives — the ambient Hodge-support obstruction is ported to spin sources, and the admissible-support census is tabled

## What was asked

PR #28 proved the spin lane's fixed-point flank exhausted
(`SPIN-LINKING-LEMMA-FALSE`, `D10-FIXED-POINT-ROUTE-DEAD`, Cor N4): any
further attack needs an invariant that is **not** of fixed-point type. Port
the one such invariant the repository owns — the ambient normalized-graph
Hodge-support theorem of `goal_runs_20260810/AMBIENT_HODGE_REES_BRIDGE/`
(`AMBIENT-HODGE-SUPPORT-PROVED`) — from the linear source `P^4` on the Klein
cubic to an arbitrary faithful **spin** source `P(V)` on the `V14` twin, and
then classify exactly which support cells remain admissible.

Packet (extending `goal_runs_20260810/SPIN_SOURCE_NETWORK/`):
`THEOREM_SPIN_HODGE_SUPPORT.md`, `SUPPORT_CENSUS.md`, `ADVERSARIAL_TESTS.md`
§§S1-S10, `verify_spin_hodge_census.py`, `REPLAY.md`, `SOURCES.md`,
`STATUS.md`.

## Exits

```text
SPIN-HODGE-SUPPORT-PROVED           the ported theorem (S0-S3, S4-S6)
SPIN-SUPPORT-CENSUS-TABLED          18 cells, 5 boxed OPEN families
SPIN-HODGE-SUPPORT-ESCAPE-UNDECIDED no cell dies uniformly
SPIN-CHAIN-OBSTRUCTION-UNDECIDED    (unchanged)
SPIN_HODGE_CENSUS_OK                (verifier marker)
```

`SPIN-SUPPORT-CENSUS-CLOSED` is **NOT** claimed. No census cell dies for all
degrees and all spin sources, so the headline consequence chain of Cor IX.5
is **not** triggered. Headline unchanged: **OPEN**.

## What was found

**1. The target Hodge structure, identified for the first time.**
`H^3(V14,Q)` as a `G`-module was not computed anywhere in-repo; only
`b_3(V14) = 10` was used, and flagged. Theorem S0 supplies it, and
deliberately **without** the Tschinkel--Zhang equivalence — which could not
have done the job, being only twisted-stable, with [BCDP23] Thm 4.3 ruling
out a plain `G`-birational map between the twins, and with weak factorization
changing `H^3` by `H^1` of blowup centres in any case. Instead: `H^{2,1}` is
a `G`-stable 5-dimensional subspace, which already excludes both absolutely
irreducible 10s; the only 5-dimensional complex `G`-modules are `1^{+5}`, `W`
and `Wbar`; and topological Lefschetz against the **sealed**
`V14^sigma = E_sigma + 2 points` gives `tr(sigma | H^3) = 2`, killing
`1^{+5}` (which predicts `-6`) and selecting `W`. Hence
`T = H^3(V14,Q)(1) = W_Q`, irreducible over `Q`, `End_G(T) = Q(sqrt(-11))`,
and by the accepted Auto-CM Lemma `J(V14) ~ E_{-11}^5`. Independent
corroboration: `chi_T(11) = -1` predicts `chi_top(V14^{C_11}) = 5`, and
`FIX_IX_v14.md` §8 records exactly 5 points — which also re-derives, with no
slack, the `V14^{C_11}` nonemptiness that `MULTIPLICITY_ROUTE.md` §5 could
only get from a Lefschetz congruence. Three further predictions
(`chi_top(V14^g) = 6, 4, 2` at orders 3, 5, 6) are registered as falsifiable
and are each one `verify_v14_s3_d10.py` run away.

**2. The ported theorem.** `q^*` is injective on `H^3` even though `q` now
has generic fibres of dimension `e = n-4 >= 2` (every faithful spin source has
`n >= 6`): the relatively-ample splitting `s(beta) = N^{-1} g_*(eta^e cup
beta)` is a projection-formula identity valid at every relative dimension, and
this is stated explicitly because the *restricted*-graph theorem (Thm D of the
ambient packet), which does use generic finiteness, does **not** port and is
not used. Weight strictness plus Hanamura--Saito give the canonical pure lift
into `IH^3(Y)`. The forcing is `H^3(P(V)) = H^3(P^{n-1}) = 0` — stronger and
more robust than the ambient `H^3(P^4) = 0`, since the perverse indexing
shifts exactly so that the full-support term is always `H^3` of the source
projective space, whatever its dimension. Irreducibility of `T` over `Q` then
gives a unique jump `j_0` and a nonzero projection onto a `G`-orbit of proper
strict-support blocks with supports inside `Bs(phi)`, `dim S <= n-3`, and the
(AHS-spin) condition
`Hom_{HS,H}(Res_H T, H^{4-n-j_0}(P(V), M_{S,j_0})(1)) != 0`.

**3. The perverse ledger changes, and is recomputed.** The refinement
exponent is `i = s + 4 - n - j_0`; at `n = 5` it reproduces the ambient
packet's `s-1-j_0`, the point-support degree `j_0 = -1` and the classical
channels `(1,-1)` and `(2,0)` exactly. At `n = 6` point supports sit at
`j_0 = -2`, and a **threefold** support channel exists that has no ambient
counterpart. New in every `n`: a point-supported block appears in stalk degree
`j_0 + dim Y = 3`, so its carrier is a weight-three piece of `H^3(Y_x)` and
the exceptional fibre must satisfy `dim Y_x >= 2`; since `Y` is finite over
the graph closure, `q(Y_x)` is an `H`-invariant subvariety of the threefold
`V14` of dimension at least 2.

**4. The census: 18 cells.** Nine zero-dimensional cells indexed by the
stabilizer, nine positive-dimensional cells indexed by the pointwise kernel,
plus eight cross-cutting kills. The spin hypothesis bites the stabilizer
layer: recomputing the derived subgroup of the `SL(2,11)`-preimage of a
representative of all 16 conjugacy classes of subgroups shows that only
`Sigma_spin = {1, C_2, C_3, C_5, C_6, C_11, S_3, D_10, F_55}` can fix a point
of a spin source, so **point-support orbit sizes 11, 55 and 1 are impossible**
— the two smallest orbits available to a linear source in
`DEGREE_ACCOUNTING.md` §2 are simply gone. The exact restrictions at the 352
mandatory base points are `Res_{S_3} T = 2.triv + 4.std` and
`Res_{D_10} T = 2.triv + 2.W_1 + 2.W_2`: both **sign-free**, so the sign
channel is DEAD at all 352 points — and the sign point is precisely the
direction the fixed-point analysis had pinned (Thm K5's `m_sign = 1`,
`m_triv = 0`, and Thm V1). The other channels survive, so cells P5 and P6 are
OPEN. Sharpest arithmetic: `Res_{C_11} T` and `Res_{F_55} T` are
**irreducible over `Q`** with no invariants, so a single `C_11`- or
`F_55`-support must carry all of `T`, i.e. `E_{-11}^5` — strictly stronger
than the ambient packet's careful "a single representative need not contain
all five copies". A new degree theorem: the coordinate degree of any
`G`-equivariant spin map is **even** (`-I` acts by `(-1)^d` on `S^d(V^*)` and
trivially on `M^*`; `SL(2,11)` perfect kills the character twist, and
primitivization preserves parity). The refined-Bezout capacity table, redone
on `P^5` and reproducing `DEGREE_ACCOUNTING.md` exactly at `n = 5`, kills free
component orbits only below `d = 26`; five positive-dimensional cells are dead
for the multiplicity-free source `U` alone, because the corresponding fixed
loci are finite there, and revive at `m >= 2`.

**5. Five boxed OPEN families** (`SUPPORT_CENSUS.md` §6): free supports; the
352 mandatory points (needing an `H`-equivariant irregular-surface fibre with
`E_{-11}` in its Albanese, mapping onto an `H`-invariant surface of `V14` —
fixed-point-free at `D_10`); the odd-order points `C_11`/`F_55` (needing all
five `E_{-11}` copies on one support); eigenplane and eigen-line supports
(whole strata dead in the constant-coefficient channel since `H^1(P^k) = 0`,
so what survives is a plane curve of degree `>= 3` in the `sigma`-trivial
`C_6`-channel of dimension 6 — the one cell that looks finite and explicit
enough for the existing machinery); and the higher-multiplicity strata.

## Consistency tests

Recorded in full in `ADVERSARIAL_TESTS.md` §§S1-S10. The **mandatory `D_12`
test PASSES**: Cor IX.6's realised dominant `D_12`-equivariant spin map has
`Res_{D_12} T = 2.(1(x)triv) + 2.(1(x)std) + 2.(eps(x)std)`, all three
channels OPEN in the census; the irreducibility hypothesis of the unique-jump
step correctly **fails** at `D_12` level and the theorem weakens accordingly;
the `S_3`-sign kill is in force at `D_12` level too and is consistent, since
the realised map has the trivial and std channels available; and the
degree-parity theorem survives at `D_12` level because
`-I in [D_12tilde, D_12tilde]`, while it would genuinely fail at a
spin-admissible level such as `S_3` (whose preimage `Q_12` has spin linear
characters) — scope recorded exactly. `D_12` contains no `D_10`, `C_5`,
`C_11` or `F_55`, so the cells the full-`G` question adds — including the two
sharpest ones — are invisible to a single `D_12`. Also tested: the census does
not prove too much (no cell dead uniformly); the identification of `T` is not
circular and does not use Tschinkel--Zhang; Thm N3's fixed-locus
destructibility does **not** touch the Hodge support, because `Y` and the
support package are attached to the normalized graph of `phi` and equivariant
blowups of the source do not change `I_phi`; the `n = 5` regression against
the ambient packet passes in full. One correction recorded: the faithful spin
block of `SL(2,11)` is `6, 6, 10, 10, 10, 12, 12`, not the `6, 6, 10, 10, 12`
of `MULTIPLICITY_ROUTE.md` §7 (nothing there depends on it).

## Verification

`verify_spin_hodge_census.py` (`SPIN_HODGE_CENSUS_OK`), 206 exact assertions,
about 30 s, Python standard library only, self-contained (it builds
`SL(2,F_11)` from `2x2` matrices mod 11 and does not import
`spin_network_lib`): the full subgroup lattice recomputed by cyclic extension
(620 subgroups, 16 conjugacy classes, 14 isomorphism types, matching Dickson,
with `S_3` and `A_5` each in two `G`-classes); the derived subgroup of the
preimage of each class, giving `Sigma_spin`; the normalizers and the complete
`(H_0, H)` table; `Res_H T` for all fourteen types by order-summed character
tables that self-validate against three exact identities before any
multiplicity is read; the Lefschetz identification and its five fixed-locus
predictions; the perverse ledger with the `n = 5` ambient regression; the
degree-parity and capacity tables with the `DEGREE_ACCOUNTING.md` regression;
the 18-cell table cross-checked against all of the above; and the `D_12`
consistency test.

`verify_spin_hodge_census.py` and `scripts/check_manifest_parity.py` pass.
The packet is on `agent/spin-hodge-support-20260810`. This notebook revision
was authored against parent head
`91ee67947f54c6a346cfea520c56a11abf75854e`.

### `STANDARD_FORM_PW` (08-10, `goal_runs_20260810/`) — the source-side atlas

Exit: `SOURCE-STANDARD-FORM-TOWER-SEALED` (marker `STANDARD_FORM_PW_VERIFY_OK`, ALLGREEN, 158 checks).

**No headline claim; source-side normal form only.** Problem E remains OPEN.

The complete standard (toroidal) reduction of the source `P(W) = P⁴`,
`G = PSL(2,11)`. The tower is **three blowups** — the 940 points of the point
strata, then the 220 lines, then the 55 plus-planes, i.e. *every stratum of the
level-0 stabilizer stratification in order of increasing dimension, and nothing
else*. Terminus: **1215 boundary divisors in 14 `G`-orbits**, exactly **110 in
2 orbits** with pointwise stabilizer (always `C2`); point stabilizers exactly
the seven abelian types `{1, C2, C3, V4, C5, C6, C11}` in 42 local models;
crossings up to `|I| = 3` with stabilizer `1` or `C2`.

Four things worth carrying forward:

1. **`A4` is the hard case, and it is a terminal cycle.** Blowing up an
   `A4`-point regenerates it forever (`T_q = 1' ⊕ 3 ↦ 1' ⊕ 3`); the only
   eliminating centre is a curve tangent to the `1'`-line — which is `ℓ_V`,
   because `W^{V4} = 1' ⊕ 1''` as an `A4`-module, so `ℓ_V` joins the two
   `A4`-points and they are its residual-`C3` eigenpoints. `D12` and `D10` need
   one round; **no stratum of `P(W)` has stabilizer `S3`** (both `S3`-classes fix
   only `D12`-points).
2. **The minimal standard form has no fabulous corner.** Every crossing of the
   terminus has cyclic generic stabilizer. `DUNCAN_CORNER_F2`'s 330 `V4`-corners
   need **one further legal blowup** (their T3). That packet's inventory is
   confirmed complete — `V4` is the only non-cyclic crossing stabilizer reachable
   at all — but any argument using the corners must say "pass to a further
   toroidal model", which `cor:cofinal` licenses.
3. **`C5`-, `C6`- and `C11`-fixed loci stay zero-dimensional** through the whole
   recursion (their tangent weights are four distinct nontrivial characters and
   twisting never yields a trivial one), while **`Fix(C2)` is not purely
   divisorial** at the terminus — it has components of dimension 1 and 2 as well
   as the 110 divisors.
4. **The `V4` row is the source-class invariant.** It is the unique non-cyclic
   entry of the permanent abelian atlas, hence the whole reason the Duncan corner
   mechanism has purchase here — and it is exactly what a spin source lacks
   (`P(U)^{V4} = ∅`, `Q8` preimage; `SPIN_SOURCE_NETWORK/KLEIN_SPIN_COMPLEX.md`
   §1, closing `theory/FIX_IX_v14.md:261–266`).

Machine: `python3 verifier.py` → `STANDARD_FORM_PW_VERIFY_OK`, `ALLGREEN`,
158 CHECK lines, 0 failures; both split primes 331 and 661, exact character
arithmetic for the automaton, exact `QQ` in Macaulay2 for the charts.
Re-verifies `STRATA_EXACT.md:108–123` and `NORMAL_CHARACTERS.md:71–90` from
scratch. Sampled and flagged: global irreducibility of every crossing `D_I`.
