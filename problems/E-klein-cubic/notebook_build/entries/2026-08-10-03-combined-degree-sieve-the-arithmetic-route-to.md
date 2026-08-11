<!-- COMBINED_DEGREE_SIEVE_20260810 -->

## 2026-08-10 Combined degree sieve: the arithmetic route to closing CLEAN is exhausted

Packet: `goal_runs_20260810/COMBINED_DEGREE_SIEVE/`.
Problem E remains **OPEN**.

```text
COMBINED-SIEVE-TABLE
SELFMAP-EXCESS-DEGREE-IDENTITY-PROVED
COMMON-FACTOR-INVARIANT-DEGREE-SET-PROVED
CLEAN-INERT-VALUATION-CRITERION-PROVED
COMBINED-SIEVE-NO-PERIODIC-CLOSURE-PROVED
```

`COMBINED-SIEVE-ALL-DEGREE-CLOSURE` was the target and is **not** obtained.
The packet instead proves it is unobtainable from the sealed ledger.

**Ledger.** Thirteen degree conditions were traced to their original packets.
Seven usable sealed rows: `AMBIENT-LANDING-COORDINATE-DEGREE-AT-LEAST-22` and
`DELTA1-RETRACTION-COORDINATE-DEGREE-AT-LEAST-24` (both
`goal_runs_20260809/AMBIENT_REES_SELFMAP_CLASSIFICATION/`, merged on `main` in
`67132b5`), `FIX-P2-SWEEP2-EMPTY-THROUGH-30`
(`goal_runs_after_2666fdb/FIX_P2_GATEWAY_D36`, manifest-replayed, and the
binding live-window statement per `RT_SPLIT_AND_DICHOTOMY/DEGREE_ACCOUNTING.md`
§3), `RESTRICTED-CLEAN-CM-NORM-PROVED`, the refined-Bézout capacity (1.1), and
two new lemmas sealed in this packet.  Four rows are **excluded as unsealed**:
the mod-330 residue sieve, the `D`-parity/vanishing-order statements, and the
`V4`-line order bound all trace to the single unedited external transcript
`external_sessions/mathematical-equivariance-query-6a70557e.md` (the
`V4` bound is independently re-derived in `theory/FIX_II_jets.md` Lemma 2.1,
whose parent note still carries `DRAFT-FOR-DERIVATION`); no `F55` packet states
any consequence for the coordinate degree.  The mod-330 sieve is excluded twice
over — its own text says it "do[es] not by themselves constrain `D`, because a
rational map may be based on the corresponding finite orbit."  Sealing it would
change no row of the table.

**New sealed lemmas.**  (i) The divisor removed when the ambient tuple is
restricted to `X` is `G`-invariant, so its degree `k` satisfies
`dim H^0(X,O_X(k))^G >= 1`; a Molien computation gives that this holds exactly
for `k` in `{0} u {5,6,7,...}`, hence `d'` is never `d-1, d-2, d-3, d-4`.  The
character data is confirmed independently: it reproduces the covariant
dimensions `32,41,49,59,73,86,100` at `d = 15..21` that
`LOW_DEGREE_DOMINANT_MAPS.md` obtained by Reynolds averaging modulo the split
prime 67.  (ii) The excess-intersection identity `3 delta = 3 d'^3 - 3 d' z - e`
(Fulton Prop. 4.4, with `z = deg(H . s_1(Z,X))`, `e = deg s_0(Z,X)`), refined by
`3 | z` (integrality of `p_* g^* l` on `H^4(X,Z) = Z l`) and `2 d' z + e = 3a`
with `a >= 0` (effectivity of `g_*[E]`), giving `delta = d'^3 - d' zeta - a` and,
for a one-dimensional base scheme, `1 <= delta <= d'^3 - d'`, with
`deg Z <= 3 d'^2` by Bézout on `X`.  **This identity yields an interval and no
congruence** — that is the structural reason the sieve cannot close.

**Norm condition.** `delta` is a norm from `Q(sqrt(-11))` iff `v_p(delta)` is
even at every inert `p`, and `p != 11` is inert iff `p = 2,6,7,8,10 (mod 11)`.
Two is inert, so `v_2(delta)` is even and `delta = 2 (mod 4)` is impossible.
Checked against direct representation by `x^2+xy+3y^2` on `[1,20000]`.

**Table.** For `22 <= d <= 30` both branches die by
`FIX-P2-SWEEP2-EMPTY-THROUGH-30`.  For `31 <= d <= 60` both live: the
retraction branch at the single value `delta = 1`, the all-ambient branch at
exactly the norms in `[3, d^3-d]` — 6782 values at `d = 31`, 44364 at `d = 60`,
minimum always 3.  Where CLEAN survives, **CARRIER remains**; the CARRIER
branch was out of scope and is not analysed.

**Why no closure exists.** At every `d >= 31` the cell
`(k, d', zeta, a, delta) = (0, d, 1, d^3-d-3, 3)` satisfies every sealed
constraint at once, and `3 = N((-1+sqrt(-11))/2)` is a norm.  So for every
modulus `M` and every residue `r`, some `d = r (mod M)` survives; no residue
class dies.  Certified for 10724 `(M,r)` pairs.  Every sealed constraint in the
repository is either an upper bound on `delta` or a membership condition on
`delta`; **none is a lower bound past `delta >= 3`.**  The missing ingredient is
therefore not another congruence but a geometric exclusion of the small-degree
cells, above all `delta = 3` — precisely the cell the tangent-residual
construction of `goal_runs_20260809/FULL_G_SELFMAP_CLASSIFICATION` makes
plausible and whose degree that packet does not compute.

Scope: dominance of the restricted selfmap is inherited from
`RT_SPLIT_AND_DICHOTOMY/THEOREM_RESTRICTED_DICHOTOMY.md` §1 and is not proved
here; no upper bound on `d` is claimed.

`verify_combined_sieve.py` and `scripts/check_manifest_parity.py` pass.  The
packet is on `agent/combined-degree-sieve-20260810`, draft PR #20; its manifest
record lands with the merge, as with the sibling 2026-08-10 packets.  This
notebook revision was authored against parent head
`82aaf2c95c4b443b4fcaa27a606a61c88e24b13a`.
