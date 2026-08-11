# Adjudication of the external restricted-transfer work

Source: an external ChatGPT session, transcript messages `[10]`, `[15]`, `[20]`
(`[15]` revises `[10]`; `[20]` corrects both and withdraws five claims). The
source is **external and unaudited**. Nothing entered this packet without being
re-proved here or checked against a named repository artifact or a verified
literature statement.

Verdict vocabulary: **CONFIRMED** (re-proved here), **CONFIRMED WITH SUPPLIED
PROOF** (true, but the source's justification was incomplete and we supply it),
**WEAKENED** (true only in a weaker form, which we state), **REFUTED**
(false; refuting artifact named), **NOT IN REPO** (a cited repository input does
not exist as cited), **NOT PORTED** (out of scope; reason given).

---

## Summary table

| # | claim | verdict |
|---|---|---|
| 1 | Klein conic-slice countermodel | **CONFIRMED** — exact, `verify_conic_slice.py` PASS |
| 2 | MHM transfer `Theta`, `Theta_H alpha_A = i_q` | **CONFIRMED WITH SUPPLIED PROOF** — the weight step needed repair |
| 2a | `h` supplied by a repo dominant-transform theorem | **CONFIRMED**, notation caveat |
| 3 | Ext/purity leakage classification, `j`-inequalities | **CONFIRMED** |
| 3b | constant-quotient collapse, Hom iso (8) | **CONFIRMED WITH SUPPLIED PROOF** |
| 4a | `H^1(S,O_S)=0` for irreducible Cartier `S ⊂ X` | **CONFIRMED** |
| 4b | `S` normal `=>` `IH^1(S,Q)=0` | **REFUTED** — exact countermodel |
| 4c | CLEAN implies genuinely singular receiver | **WEAKENED** to "not smooth and not normal-with-rational-singularities" |
| 5 | conductor/Gysin exclusion is FALSE | **CONFIRMED**, at `Q` coefficients, by a cheaper unconditional route |
| 5b | provenance: repo proves `theta^4/4!` algebraic | **CONFIRMED** (integral, sealed), but **not needed** |
| 6a | `D_X = 0 => RT` and CARRIER, `u_phi = 0` | **CONFIRMED** |
| 6b | invariant-degree lemma `k ∈ {0} ∪ {5,6,...}` | **CONFIRMED** (sealed in repo) |
| 6c | for `5<=k<=10` every component individually `G`-stable | **NOT IN REPO**; **CONFIRMED**, proved here |
| 6d | retraction corollary `delta=1 => D_X != 0` | **CONFIRMED**, and cross-checks a sealed degree floor |
| 7 | landing-identity system and its compact form | **CONFIRMED** — exact, `verify_landing_identity.py` PASS |
| 8 | cross-references, scope disclaimer, FRONTIER-1 rhyme | **CONFIRMED** |
| W | the five withdrawn claims of `[20]` section 5 | **withdrawn, recorded as REFUTED** |

---

## 1. The conic countermodel — CONFIRMED

Every assertion of `[20]` section 3 replayed exactly:
`F(P) = 0` identically; base ideal `(u,v)^2`; the exceptional `P^1` maps
isomorphically to a **smooth conic** (rank-3 quadratic form
`x_0^2 + x_1x_2 + x_2^2` in the plane `{x_4=0, x_1=x_3}`), degree 2, not a line;
slice `v=0` gives common factor `u^2` with primitive value `[1:-2:1:-2:0]`, which
lies on `X`. See `COUNTERMODEL_CONIC_SLICE.md`, `verify_conic_slice.py`.

The line-only normal form is refuted and the five withdrawn claims stay
withdrawn. **One scope point the source did not make:** the countermodel is a
*local slice* witness, not a global `G`-covariant landing tuple. Recorded in
`COUNTERMODEL_CONIC_SLICE.md` section 4.

## 2. The MHM transfer theorem — CONFIRMED WITH SUPPLIED PROOF

Checked line by line (`THEOREM_ACTUAL_TRANSFER.md` section 2).

* Shift bookkeeping `ĨC_Y = IC_Y[-4]`, `ĨC_Γ = IC_Γ[-3]`, target
  `Rh_*IC_Γ[1]`: **internally consistent**, and `Theta_H : IH^k(Y) → IH^k(Γ)`
  comes out right.
* **The weight step is under-justified in the source.** `[15]` asserts
  "`K_Y = Cone(Q_Y → ĨC_Y)` has weights at most zero". From the triangle alone
  one gets only `w(K_Y) ≤ 1`, which is one unit too weak: the orthogonality
  `Hom(h^*K_Y[-1], ĨC_Γ) = 0` then fails to follow. We supply the proof via a
  resolution and Weber's theorem
  (`ker(H^k(Y) → IH^k(Y)) = W_{k-1}H^k(Y)` for `Y` complete). The claim is
  **true**; the source's one-line justification is not a proof.
* **Non-uniqueness.** Uniqueness of the lift would need
  `Hom(h^*K_Y, ĨC_Γ) = 0`, whose weight bound is `≤ 0` against `≥ 0` — not
  strict. `Theta` is genuinely non-canonical, consistent with the literature
  (see item 2c). `G`-equivariance by averaging over `Q` is valid: the lifts form
  a torsor under a `Q`-vector space.
* `Theta_H alpha_A = i_q` — **CONFIRMED**, and the proof is short once `alpha_A`
  and `i_q` are defined as (natural map `H^3 → IH^3`) ∘ (ordinary pullback):
  it is `Theta_H nat_Y q^* = nat_Γ h^* q^* = nat_Γ q_Γ^* = i_q`, using
  `q h = q_Γ`. Injectivity of `i_q` also confirmed (two independent proofs).

**2a. The comparison morphism `h`.** The repository input exists:
`goal_runs_20260809/EXCEPTIONAL_CARRIER_RIGIDITY/AMBIENT_REES_COMPARISON.md`
section 2, "Dominant-transform theorem", equation (2.1), gives the canonical
`G`-equivariant isomorphism `(X̂_dom)^ν ≅ Γ`. Caveat: the repository states the
compatibilities in words ("the source and landing morphisms on both sides
agree") rather than as `p h = i pi`, `q h = q_Γ`, and never names `h`. Verdict
**CONFIRMED**, with that recorded. A useful fact the source did not use: **`h`
is finite**, being normalization followed by a closed immersion.

**2c. Literature attribution — CORRECTED.** `[10]` and `[15]` attribute the
`f^*IC_W → IC_Z` construction to Hanamura–Saito. Verified: the origin is
**Barthel–Brasselet–Fieseler–Gabber–Kaup**, *Relèvement de cycles algébriques et
homomorphismes associés en homologie d'intersection*, Ann. of Math. 141 (1995)
147–179; Hanamura–Saito (arXiv:math/0605603) restate it as their Theorem 2,
citing BBFGK, and give a shorter proof. Citing "Hanamura–Saito" is defensible
but the primary credit is BBFGK. Fixed in `SOURCES.md`. Also confirmed: the
morphism is **non-canonical** in general, exactly as `[10]` says.

## 3. The leakage classification — CONFIRMED

`THEOREM_LEAKAGE_CLASSIFICATION.md` sections 1–2. Re-derived independently:

* the degree window `j ≤ s-1` from `IH^{s-1-j}(S̄,L)`: **correct**;
* the codimension-Ext vanishing `Ext^a(N,IC_X) = 0` for `a < c`: **correct**,
  proof via `k^!IC_X ∈ {}^pD^{≥c}`;
* `S ⊄ X ⟹ j ≥ 4-s`: **correct**. Both perverse pieces of `i^*M` give it —
  the transverse piece `{}^pH^{-1}` (support dim `≤ s-1`, `c ≥ 4-s`) via
  `Ext^{j}`, and the non-transverse `{}^pH^{0}` (support dim `≤ s-2`,
  `c ≥ 5-s`) via `Ext^{1+j}`. We record that a mis-indexing of the first branch
  as `Ext^{j+2}` would wrongly leave `s=2, S ⊄ X` alive; the source's inequality
  is right.
* `S ⊂ X ⟹ j ≥ 2-s`: **correct** (`i^*i_* = id` for a closed immersion);
* hence `dim S = 2` and `S ⊂ X`: **correct**;
* `S` is a component of `D_X` (factoriality of `X`): **correct**;
* semismallness `⟹ j = 0`, block `IC_S(U)(-1)` with `U` finite-monodromy:
  **correct** (fibre-dimension bound `2d - codim = 0`).

**3b. The constant-quotient collapse (8) — CONFIRMED WITH SUPPLIED PROOF.**
The isomorphism
`Hom(a_*IC_S(U)(-1), IC_X[1]) ≅ Hom_{VHS(S°)}(U,Q)` holds. Three points the
source left implicit and we supply:
(i) the Tate twists cancel exactly (`a^!IC_X[1] = IC_S(-1)` for `S` smooth), a
nontrivial check that validates the `(-1)` in the source's block `(7)`;
(ii) the **singular Cartier Gysin map exists** — not from a fundamental class
(the natural map runs `Q_S[2] → IC_S`, the wrong way) but via a resolution and
the decomposition theorem;
(iii) the uniqueness argument is correct *because* `A` is perverse, so the
factorization through `k_*k^*A` passes through `{}^pH^0` only, and `Ext^1`
against codimension `≥ 2` vanishes. Without (iii) a naive count would allow
`Ext^2, Ext^3` contributions and the argument would fail.

## 4. The surface theorems

**4a. `H^1(S,O_S) = 0` — CONFIRMED.** `X` smooth cubic hypersurface ⟹ `Pic X =
Z·H` (so `S` Cartier, `S ∈ |aH|`) and ACM (so `H^1 = H^2 = 0` for all twists);
the divisor sequence gives the vanishing. Clean.

**4b. `S` normal `⟹ IH^1(S,Q) = 0` — REFUTED.** `[20]` section 2 equation (3).
The error: for `S` normal the natural map is only an **injection**
`H^1(S) ↪ IH^1(S)`, not an isomorphism; `IH^1(S)` is computed on the
*resolution* (`IH^1(S) = H^1(S̃)`), and `H^1(S,O_S) = 0` gives only
`H^1(S̃,O_{S̃}) ↪ H^0(R^1f_*O_{S̃})`, which is nonzero exactly at non-rational
singularities.

Refuting artifact, exact and machine-verified
(`verify_normal_surface_countermodel.py` Part A, `cone_surface_countermodel.m2`):
`X' = {x_0^3+x_1^3+x_2^3+x_3^2x_4+x_4^3 = 0}` is a **smooth** cubic threefold;
`S = X' ∩ {x_4 = 0}` is the projective cone over the Fermat plane cubic, an
irreducible reduced **normal** Cartier surface with `H^1(S,O_S) = 0` and
`IH^1(S,Q) = H^1(E,Q) = Q^2 ≠ 0`.

*New Klein-specific fact.* `eckardt_klein.m2` shows the Klein cubic has **no
Eckardt points** (Eckardt ideal `= ideal 1`), so no hyperplane section of the
Klein cubic is a cone; this `|H|` witness does not occur there. Whether the
Klein cubic contains a normal surface in some `|kH|` with `IH^1 ≠ 0` is
**UNDECIDED** in this packet. This does not rescue (3), whose proof used no
Klein-specific input and is invalid regardless.

**4c. "CLEAN implies a genuinely singular receiver" — WEAKENED.** What survives
is the `[15]` section 4 form, which we prove: a common-factor surface that is
smooth, or normal with **rational** singularities, cannot leak. So CLEAN forces
a component that is nonnormal (conductor genus) **or** normal with a
**non-rational** singularity. `[20]`'s stronger "surface leakage ⟹ nonnormal" is
not available.

## 5. The refutation of the conductor/Gysin exclusion — CONFIRMED, cheaper route

The conclusion is right: the receiver exists. But:

* **The minimal class is not needed.** With `Q` coefficients, Bloch–Srinivas
  applied to any unirational threefold gives `N·[Delta] = Z_1 + Z_2`, hence
  `id_V` factors through `H^1(D̃,Q)(-1)` after dividing by `N`; averaging over
  the finite `G` over `Q` makes it equivariant. Unconditional, on every smooth
  cubic threefold. The leakage question is entirely `Q`-linear, so this is the
  right level.
* **The provenance claim is nevertheless CONFIRMED.** The repository does seal
  `theta^4/4! ∈ H^8(J(X),Z)` algebraic — **integrally**, with an explicit
  integral cycle — at `goal_runs_20260808/DELTA1_MINIMAL_CLASS/THEOREM.md`
  Theorem 3.1, exits `KLEIN-IJ-MINIMAL-CLASS-ALGEBRAIC`,
  `KLEIN-CUBIC-UNIVERSALLY-CH0-TRIVIAL`.
* **Citation corrected.** The iff between universal `CH_0`-triviality and
  algebraicity of `theta^4/4!` for cubic threefolds is Voisin, *On the universal
  `CH_0` group of cubic hypersurfaces*, JEMS 19 (2017) 1619–1653
  (arXiv:1407.7261) — **not** the 2013 J. Alg. Geom. paper, which gives only a
  partial converse with side conditions. Also verified: for the very general
  cubic threefold the algebraicity is **open**; it is known on a countable union
  of special loci, and the Klein cubic's membership is exactly what
  Roulleau's `J(X) ≅ E^5` buys.
* **`J(X) ≅ E^5` is an isomorphism of bare abelian varieties, NOT of ppavs.**
  Roulleau (arXiv:1001.4853) says so explicitly; Clemens–Griffiths Thm 0.12
  ("not of level one") forces it. The repository records this in several places
  and does not make the naive error, nor does the external source.
* **Coefficient-level gap, flagged.** The `G`-equivariant **integral** statement
  is NOT available: the repository's own audit
  (`goal_runs_20260808/DELTA1_EQUIVARIANT_MINIMAL_CLASS_AUDIT/`) shows integral
  averaging forces only `660 · M^{-1}` and that "division by 660 is not
  legitimate in integral Chow", exits including
  `DELTA1-PRIMITIVE-FIXED-CHOW-LIFT-NOT-FORCED-BY-CITED-THEOREMS`. So the
  refutation kills abstract exclusion at `Q` level but leaves an
  integral-equivariant door that we do not claim leads anywhere.

## 6. The consequence chain

**6a. `D_X = 0 ⟹ RT ⟹ CARRIER`, `u_phi = 0` — CONFIRMED.** Chain re-derived in
`THEOREM_ACTUAL_TRANSFER.md` section 4 against the two sealed inputs
(`AMBIENT_HODGE_REES_BRIDGE` Theorem B; `RT_SPLIT_AND_DICHOTOMY` Lemmas 2.1–2.2,
Theorem 3.1) plus the leakage classification of item 3. Both cited exits exist
with the quoted content.

**6b. Invariant-degree lemma — CONFIRMED, sealed.**
`goal_runs_20260810/COMBINED_DEGREE_SIEVE/THEOREM_COMBINED_SIEVE.md`, Lemma 2.3,
`k ∈ {0} ∪ {5,6,7,...}` with the explicit dimension table
`[1,0,0,0,0,1,1,1,1,1,2,2,3]`, exit
`COMMON-FACTOR-INVARIANT-DEGREE-SET-PROVED`.

**6c. `5 ≤ k ≤ 10 ⟹` every component individually `G`-stable — NOT IN REPO,
proved here.** The external source cited this as a repository result; a full
search of `COMBINED_DEGREE_SIEVE` and the rest of the problem tree found no such
lemma. The orbit-size input *is* there
(`RT_SPLIT_AND_DICHOTOMY/DEGREE_ACCOUNTING.md` section 2: smallest nontrivial
orbits `11, 11, 12, 55, 66, ..., 660`), used for a different purpose. The
deduction is one line and we prove it
(`THEOREM_LEAKAGE_CLASSIFICATION.md` Lemma 5.1). The downstream conclusion —
a single `G`-stable component whose `H^1(S̃,Q)` contains the whole of `V`, hence
an `E_{-11}^5`-isotypic Albanese factor by the Auto-CM Lemma — then follows.

**6d. Retraction corollary — CONFIRMED and cross-checked.** If the restricted
map is the identity then `u_phi = id_V ≠ 0`, so `D_X ≠ 0` by 6a; with 6b,
`D_X ∈ |kH|` with `k ≥ 5`. The repository's independent polar-identity route
gives `D_X = div(H|_X)` with `deg H = d-1`, so `d ≥ 6`. The two agree — a real
consistency check on the whole RT chain rather than a new theorem.

## 7. The boxed remaining theorem — CONFIRMED

The identity expansion is exact (`verify_landing_identity.py`, all checks PASS),
and the four-equation system is equivalent to the compact form and to
`F(HB+FC) = 0` given `gcd(H,F)=1` (Gauss's lemma). The system specializes
**exactly**, signs included, to the sealed repository retraction identity
`F(x+tQ) = (Ht-F)(St^2-Rt-1)` at `B = x`, `R_0 = 1`. Boxed unchanged in
`BOXED_GLOBAL_COVARIANT.md`.

Caveat recorded: neither the general `A = HB+FC` decomposition nor the general
system is in the repository; only the `B = x` case is. This packet supplies the
general case.

## 8. Cross-references — CONFIRMED

* The merged receiver-ledger packet (PR #27) is
  `goal_runs_20260810/RECEIVER_LEDGER_X/`, exit `RECEIVER-LEDGER-X-PASS`. Its
  scope disclaimer is verbatim as the external source describes: "**Not proved
  here.** Anything about existence of equivariant maps into `X`; normal jets;
  essential dimension; the Problem-E headline." (`THEOREM.md` section 0), and
  section 8 remainder 4 adds that the dichotomy is "**not** by themselves an
  obstruction to equivariant unirationality". **CONFIRMED.**
* `DEPENDENCY_MAP.md` is at `goal_runs_20260810/SPIN_SOURCE_NETWORK/`;
  `FRONTIER-1` reads "`s = 1`: a `G`-orbit of CURVES in `Bs(phi)` with `E_{-11}`
  in the Jacobian. NONEMPTY: Thm O4-5 (110 Hesse cubics)." **CONFIRMED.**
* The `O4` witness is `O4_EIGENPLANE_CURVES.md` Theorem O4-5, exit
  `O4-EIGENPLANE-CURVES-OPEN-WITH-WITNESS`. The structural rhyme is recorded in
  `REFUTATION_CONDUCTOR_GYSIN.md` section 4: in both cases an
  exclusion-in-the-abstract is impossible because the object is *realised*, and
  the remaining question is about the actual map and the actual tuple.
  `FRONTIER-2` ("`s = 2`: a `G`-orbit of SURFACES ... Status unknown") is, up to
  notation, the same open cell as this packet's surface receiver.
* `KLS2-NO-FINITE-REDUCTION` (`goal_runs_after_35fa/KLS_MINIMALITY/STATUS.md`)
  and the Fano–Rees retraction packet
  (`goal_runs_20260809/RETRACTION_FANO_REES_CARRIER/`, Theorem 6.1, section 7,
  exit `DELTA1-IRREDUCIBLE-BASE-DOMINATES-FANO-SURFACE`) exist as cited.
  **CONFIRMED.**

---

## W. Withdrawn claims, recorded as REFUTED

From `[20]` section 5, refuting artifact `COUNTERMODEL_CONIC_SLICE.md` /
`verify_conic_slice.py`:

```
GENERIC-COMMON-FACTOR-WEIGHTED-LINE-NORMAL-FORM-PROVED     REFUTED
COMMON-FACTOR-TOP-LOCAL-SYSTEM-RANK-ONE-IN-ALL-CASES       REFUTED
AMBIENT-RETRACTION-EXCLUDED                                REFUTED (withdrawn)
CLEAN-DEGREE-DIVISIBLE-BY-4                                REFUTED (withdrawn)
ODD-DEGREE-CLEAN-EXCLUDED                                  REFUTED (withdrawn)
```

Additionally withdrawn by this adjudication, beyond `[20]`'s own list:

```
NORMAL-COMMON-FACTOR-IH1-LEAKAGE-EXCLUDED                  REFUTED
   ([20] section 2 eq. (3); refuting artifact
    verify_normal_surface_countermodel.py Part A)
```

and consequently `[20]`'s final-status line
`NONNORMAL-CONDUCTOR-OR-LOCAL-GENUS-CHANNEL-NECESSARY` is **WEAKENED** to
`CLEAN-IMPLIES-NON-RATIONAL-SINGULAR-RECEIVER-PROVED`.

## Not ported

* `[10]` section 5's conditional Fano-surface receiver discussion and `[20]`
  section 4's cylinder computation `T_D = ±2n·id` are ported only as the
  conditional `LINE-INCIDENCE-FACTOR-TWO-CONDITIONAL`; the computation is not
  replayed because nothing this packet claims depends on it.
* `[10]`'s exit `TARGET-FIXED-RECEIVER-EXCLUSION-INCOMPLETE` is not ported as a
  new exit: it restates the receiver ledger's own scope disclaimer, already in
  the repository.
