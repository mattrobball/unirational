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

---
---

# ROUND 3 — adjudication of external message `[21]` (slice classification and
# the claimed refutation)

Source: a further external ChatGPT-derived report, transcript message `[21]`,
also **external and unaudited**. Same vocabulary of verdicts, plus
**SCOPE-CORRECTED** (the mathematics is right but the statement it is claimed to
refute is not the statement it refutes).

Ported files: `SLICE_CLASSIFICATION.md`,
`REFUTATION_POINTED_CURVE_EXCLUSION.md`, revised `BOXED_GLOBAL_COVARIANT.md`,
verifier `verify_slice_universality.py` (`RESULT: PASS`, 314 exact assertions),
and blocks `C7`–`C7d` added to `verify_conic_slice.py`.

## R3 summary table

| # | claim | verdict |
|---|---|---|
| R1 | local normal form `I = (a, fJ)`, `J` the Plücker ideal, gauge invariance, `I mod f = (H)` | **CONFIRMED** — symbolic, `S1a`–`S1f` |
| R2 | Zariski–Lipman unique factorization of complete ideals | **CONFIRMED WITH REPAIR** — quoted correctly (Lipman IHÉS 36 for the non-closed residue field), but applied to a possibly non-`m`-primary `I`; the `(gcd) × (m-primary)` split is supplied |
| R3 | `D·E_p = -rho_p`, Zariski factorization `Ibar = prod P_p^{rho_p}` | **CONFIRMED** — standard, quoted correctly |
| R4 | excess = degree, `(q_Z|_{E_p})^*O_X(1) = O(rho_p)` (8)–(9) | **CONFIRMED** — derivation from `Ibar O_Z = O_Z(-D)` is right |
| R5 | decoration is a pointed genus-zero stable map | **CONFIRMED WITH CAVEAT** — over `kappa(p)`, with Galois action; the source's data list includes it, its conclusion does not |
| R6 | "complete classification" | **CONFIRMED WITH REPAIR** — stated as a bijection up to units (Prop. 2.5); it is a dictionary, not a finiteness theorem |
| R7 | universality (11): every pointed rational curve occurs, `A = HB+fC = P`, identities by mod-`s`/mod-`t^e` | **CONFIRMED** — full symbolic derivation supplied and machine-checked; `R_0 = 0` is *forced*, which the source does not remark |
| R8 | depth family `A_N = (s^N,0,t,0,0)`, cluster (13) | **CONFIRMED** — `F(A_N)=0`, ideal `(t,s^N)` complete, free chain of `N` points, excesses `(0,...,0,1)`, last component degree 1; `N = 1..12` |
| R9 | exact conic cell `R_0=0, R_1=8, R_3=-8v` (15) | **CONFIRMED** exactly, twice; **plus** the new observation that the conic cell *is* the `e=2` instance of R7 |
| R10 | (16) Clemens–Griffiths `alpha_F` iso | **CONFIRMED** — citation correct (Ann. Math. 95 (1972) §10, Thm 11.19) |
| R11 | (17) `B_C` iso via "hard Lefschetz + homological cylinder" | **CONFIRMED WITH SUPPLIED PROOF** — hard Lefschetz plus Poincaré adjunction `<Gamma_* a, b>_X = <a, alpha_F b>_F`; "homological cylinder" was Clemens–Griffiths again, dualized |
| R12 | (18) `M_{a,m} = aA + mB_C` iso for all but finitely many `m` | **CONFIRMED, CORRECTED, STRENGTHENED** — `A = 0` (projection formula + `H^1(X)=0`), so `M_{a,m} = mB_C` and the determinant polynomial is the monomial `m^{10} det B_C`; iso for **every** `m != 0` |
| R12' | `L_{a,m}` very ample | **HYPOTHESIS SUPPLIED** — needs `e : I → X` finite; proved from `KLEIN-CUBIC-NO-ECKARDT-POINTS`, new exit `KLEIN-INCIDENCE-MAP-FINITE` |
| R13 | (19) weak Lefschetz `pi_D^*` iso | **CONFIRMED** |
| R14 | `alpha_D = pi_D^* alpha_F` | **CONFIRMED WITH SUPPLIED PROOF** — flat base change on the cartesian square |
| R15 | `beta_D pi_D^* = k M_{a,m}` | **CONFIRMED WITH SUPPLIED PROOF** — projection formula for `j : D ↪ I`, `[D] = kL_{a,m}` |
| R16 | (20) `T_D ∈ Aut_HS(V)` | **CONFIRMED**, with closed form `T_D = km·B_C∘alpha_F` — the divisor contributes only the scalar |
| R17 | (21) cycle formula and `G`-equivariance | **CONFIRMED AND SHARPENED** — `[D]` is `G`-invariant for every member; the orbit sum is needed only to make the *receiver* `G`-stable |
| R18 | (22) integrality, `End_{G-HS}(V)=Q(sqrt(-11))`, automatic norm identity | **CONFIRMED** against `RT_SPLIT_AND_DICHOTOMY` (4.1), (4.2), Rosati = complex conjugation |
| R19 | (23) generic slice of `D` is line-type, all `R_i = 0` | **CONFIRMED**, machine-verified |
| **R20** | **§7 headline / §8: "the requested CLEAN correspondence exclusion is false"** | **SCOPE-CORRECTED — the boxed statement is NOT refuted** |
| R21 | "no obstruction depending only on slice ideals, jets and orbit-summed correspondences can close the branch" (the source's line 9) | **CONFIRMED** — this, not the headline, is what was proved |

## R20 in full — the decisive item

The box quantifies over the slices **of an actual `G`-covariant landing tuple**
and over **components `S ⊂ D_X` of that tuple's own divisorial common factor**.
`T_D` is built from a general divisor in a linear system on the incidence
threefold `I`; no landing tuple appears anywhere in its construction, and
`e(D) ⊂ X` is not exhibited as a component of any `D_X`. Therefore the boxed
exclusion is untouched.

What is refuted is the **slice-local** version (drop items 1, 2 and 5 of the
sharpened box): "no family of pointed rational curves on `X` whose slices satisfy
`(10)` can produce a nonzero `V → IH^1(S,Q) → V`". That is false, decisively,
and the witness sits in the *simplest* slice cell.

The source concedes this itself in its closing paragraph — "it refutes the
local-to-global exclusion without deciding Problem E" — while its verdict box
and its §8 exit line say the opposite. We keep the concession and discard the
headline. Accordingly the source's proposed exit
`POINTED-RATIONAL-CURVE-FULL-SUPPORT-EXCLUSION-REFUTED` is **not ported**; it is
replaced by `SLICE-LOCAL-POINTED-RATIONAL-CURVE-FULL-SUPPORT-EXCLUSION-REFUTED`.
`GLOBAL-COVARIANT-POINTED-RATIONAL-CURVE-EXCLUSION-UNDECIDED` is unchanged, and
the box is sharpened rather than deleted.

This is the second time in this packet that an external round has produced a
correct object and an overstated headline (compare item 5: the conductor/Gysin
refutation is real but was routed through an input it did not need). The
pattern is worth naming: the external line is reliable about *existence* and
unreliable about *scope*.

## R22 — repository cross-references checked

* "repo double-hit argument for high very ample divisors; split divisors occur
  in unbounded classes" — **EXISTS AS CITED**:
  `goal_runs_20260808/DELTA1_RETRACTION_POLAR_IDENTITY/THEOREM.md` §5, exit
  `DELTA1-INVARIANT-SPLIT-DIVISORS-UNBOUNDED`. Its hypothesis "on the finite
  locus of `e`" is upgraded to "everywhere" for the Klein cubic by
  `KLEIN-INCIDENCE-MAP-FINITE`.
* "same mechanism as the `[u^N : v]` examples elsewhere in the repo" —
  **EXISTS AS CITED**:
  `goal_runs_20260810/SPIN_SOURCE_NETWORK/R1_TOTAL_DEGENERATION.md` §2 and
  `verify_r1_degeneration.py` `A11`, exit `R1-INDUCTION-REFUTED`.
* `LINE-INCIDENCE-FACTOR-TWO-CONDITIONAL` (`COUNTERMODEL_CONIC_SLICE.md` §5,
  "`T_D = ±2n·id`, the coefficient `r` cancelling") — the **`r`-cancellation half
  is now proved** (it is `A = 0`, R12). The residual `±2` factor is the classical
  double-cylinder relation and is still not replayed; the exit stays conditional.
* The Zariski–Lipman vocabulary (*complete ideal*, *weighted cluster*,
  *infinitely near point*) does **not** occur anywhere else in
  `problems/E-klein-cubic/` prose. This material is new to the repository.

## R23 — new composed corollaries recorded

1. `KLEIN-INCIDENCE-MAP-FINITE`: no Eckardt points ⟹ `e : I → X` finite of
   degree 6 ⟹ `xi = e^*H_X` ample. The packet's own Macaulay2 Eckardt
   computation, made for the `|H|` cone countermodel, turns out to be the
   ampleness input for the incidence polarization.
2. `e(D)` is non-normal or has a non-rational singularity — the `T_D`
   construction is a **witness for**
   `CLEAN-IMPLIES-NON-RATIONAL-SINGULAR-RECEIVER-PROVED`, not a
   counterexample to it, and it *proves* the double locus of `e|_D` is nonempty
   (`REFUTATION_POINTED_CURVE_EXCLUSION.md` Cor. 6.2).
3. The `T_D` route lives at `k >> 0` (receiver degree `k(6a + lambda m)`,
   `lambda > 0`), hence supplies **no** candidate in the window `5 <= k <= 10`
   where `CLEAN-COMPONENTS-G-STABLE-FOR-k-AT-MOST-10-PROVED` bites, and no
   individually `G`-stable smooth member. It therefore does not interact with
   the retraction corollary or the sealed `d >= 6` floor in either direction.
4. `R_0 = 0` is *forced* in every universality slice, because the marked value
   lies on `X`. The `R_0 = 1` normalization of the sealed retraction identity
   (`DELTA1_RETRACTION_POLAR_IDENTITY`, `B = x`) is therefore the opposite
   extreme of the same system, not a generic case.

---

# ROUND 4 — adjudication of the external round-4 report (interpolation,
# forced foliation, defect identity)

Source: external round 4, a single report in five sections plus a PROVED /
UNDECIDED ledger. **External and unaudited**, from the same session whose
rounds 2–3 were largely right but each needed supplied proofs, and one of which
carried an overclaimed headline. Same verdict vocabulary as above, with one
addition: **DEFLATED** (true, replayable, and inert — ported with its emptiness
stated rather than dressed up).

Ported into `INTERPOLATION_THEOREM.md`, `THEOREM_FORCED_FOLIATION.md`,
`DEFECT_IDENTITY.md`, `FOLIATION_REFORMULATION.md`, sections 3–5 of the revised
`BOXED_GLOBAL_COVARIANT.md`, and the new verifiers
`forced_foliation_witness.m2`, `verify_forced_foliation.py`,
`verify_interpolation_scope.py`, `verify_covariant_dimensions.py`.

## R4 summary table

| # | claim | verdict |
|---|---|---|
| R24 | the equivalence chain (1): covariant `<=>` equivariant dominant map `<=>` `X_gen(K_proj) != ∅` | **CONFIRMED** — sealed in repo, `G2-FINITE-GENERATION-PASS` + `G3-DOMINANCE-AUTOMATIC`; **one accepted input flagged** |
| R25 | proving nonexistence proves `ed_C(PSL(2,11)) = 4` | **CONFIRMED**, conditional on the citations assembled in `RESOLUTION.md` |
| R26 | the direct-arithmetic exit is `G3D-UNDECIDED` | **CONFIRMED**, cited correctly; `SEAL.json` governs |
| R27 | interpolation theorem (2)/(3): Serre + Reynolds | **CONFIRMED WITH SUPPLIED PROOF**, and **SCOPE SHARPENED** (R28) |
| R28 | "finite local/cluster/incidence/attachment data can never give all-degree nonexistence" | **CONFIRMED for FIXED data**; the boundary (data growing with `d`; stabiliser compatibility; nonlinearity of `F(T)=0`) is supplied here and machine-checked |
| R29 | (5) chain rule `Q_T^t J_T = 0` | **CONFIRMED** (immediate) |
| R30 | pulled-back gradient is primitive | **CONFIRMED WITH SUPPLIED PROOF** |
| R31 | (6)(7) adjugate factorization, existence and uniqueness of a **polynomial** `P_T` | **CONFIRMED WITH SUPPLIED PROOF** — the content step is the only non-formal step and the source compresses it to a clause |
| R32 | `deg P_T = 2d-4` | **CONFIRMED**, and generalized to `(n-1)(d-1)-(e-1)d` |
| R33 | (8) `J_T P_T = 0`; (10) the `T_i` are first integrals | **CONFIRMED** |
| R34 | (9) equivariance, character killed by perfectness | **CONFIRMED WITH SUPPLIED PROOF** — the source omits `adj(gJg^{-1}) = g adj(J) g^{-1}`, which is where the two `det(g)` factors cancel |
| R35 | (11) Piola, (12) `div P_T = 0` | **CONFIRMED**; (11) is a general identity, checked with no landing hypothesis |
| R36 | (14) the foliation is `O(5-2d) -> T_{P^4}` | **WEAKENED** — `P_T` need not be primitive; in the exact witness the content has degree `8` of `10` and the saturated foliation has degree `2` |
| R37 | (13) as a package | **CONFIRMED**, and **shown CONSISTENT**: an exact non-equivariant witness satisfies all of (5)–(13), so no contradiction is available from the package alone |
| R38 | (15)(16) K-theory and the global complex | **CONFIRMED** as a statement about `K`-classes; exactness of (16) **NOT RE-PROVED** (scope flag; nothing depends on it) |
| R39 | (17) the `ch_2` defect identity | **CONFIRMED** — replayed symbolically, exact |
| R40 | "an exact compatibility law, not an effectivity contradiction" | **CONFIRMED and DEFLATED** — recorded as a negative exit |
| R41 | (18) socle degree 5, first-order gate vacuous in degree `>= 6` | **CONFIRMED AND SHARPENED** — exactly one linear condition at degree 5; survives equivariance; moot in the surviving retraction range |
| R42 | the nonsquare residual quadratic remains as recorded | **CONFIRMED** — `Delta = R^2+4S`, `DELTA1-KLEIN-RETRACTION-BRANCH-OPEN` |
| R43 | the minimality/conductor program reached the same boundary | **CONFIRMED** — `KLS2-NO-FINITE-REDUCTION` |
| R44 | §5(b): nonequivariant unirational parametrizations exhibit the same structure | **CONFIRMED and UPGRADED** from assertion to an exact worked instance |
| R45 | new here, not in the source: the covariant/divergence-free dimension table and `d >= 4` | added, `LANDING-DEGREE-AT-LEAST-FOUR-PROVED` |

## R24 — the equivalence chain, and the one input that is accepted not proved

The chain is sealed, in three artifacts, and section 3 of
`BOXED_GLOBAL_COVARIANT.md` tabulates them. The audit point is that
`G3A_EXACT_ARITHMETIC_DOMINANCE/DOMINANCE_BRIDGE.md`'s own seven-step ledger
marks step 6 — `dim Z >= ed_C(G) >= 3` — as `ACCEPTED_INPUT` (Beauville), not as
a repository proof, and that `RESOLUTION.md`'s `ed_C(G)=4 <=> not G-unirational`
rests on Duncan–Reichstein, Prokhorov and Tschinkel–Zhang as cited. The source
states (1) flatly. It is right, but "sealed" here means "sealed modulo those
citations", and this packet does not re-derive them. Also recorded: the earlier
`G_UNIVERSAL/DECISION.md` asserts the opposite about dominance and is
superseded by `G3A` (`NOTEBOOK.md` §17).

## R27/R28 — the interpolation theorem, and the boundary that matters

The theorem is two standard steps and the source gets both right. What the
source does **not** state, and what decides which obstruction programs remain
legal, is the quantifier order: `d_0` depends on `Z`, and is unbounded over `Z`.
`verify_interpolation_scope.py` pins this exactly.

* `d_0(Z) = m` for `Z` the order-`m` jet at a point of `P^n` (`n = 2,4`,
  `m = 1..4`): surjective **iff** `d >= m`.
* With `Z_d :=` the order-`(d+1)` jet, the map is non-surjective for **every**
  `d`, with strictly increasing deficiency `2,3,4,5,6,7,8`.
* At a point with nontrivial stabiliser the achievable values are `W^{G_p}` in
  **every** degree — so the word "compatible" in the source's statement is
  load-bearing, not decoration.
* The theorem constrains a **linear** restriction map and is blind to
  `F(T) = 0`.

So the correct reading of the source's boxed (3) is: *fixed finite* data cannot
obstruct. Data that grows with `d` is untouched, and that is where a legal
obstruction program must now live. Ported as `INTERPOLATION_THEOREM.md` §3 and
Corollary 4.1, with the explicit statement that this is the **third lane to
bottom out at the headline**, after the F55 coefficient circuits
(`F55-PC-COVERAGE-C-EQUIVALENT-TO-HEADLINE`) and the CLEAN arithmetic sieve
(`COMBINED-SIEVE-NO-PERIODIC-CLOSURE-PROVED`).

## R31 — the content step, in full, because the source compresses it

The source writes: "with (5) and `Q_T` primitive there is a unique polynomial
vector `P_T`". Two distinct facts are hiding in that clause and only one is
formal.

*Formal.* Over `Frac(R)`, generic rank `4` makes the left kernel of `J_T`
one-dimensional, spanned by `Q_T^t`; every row of `adj(J_T)` lies in it; so
`adj(J_T) = P Q_T^t` with `P` a vector of **rational functions**, uniquely
determined because `R` is a domain and `Q_T != 0`.

*Not formal.* Polynomiality. Write `p_i = A/B` in lowest terms in the UFD `R`.
From `p_i F_j(T) in R` for every `j` one gets `B | F_j(T)` for every `j`, hence
`B | gcd_j F_j(T) = 1`. This is Gauss's lemma applied to the *content of the
pulled-back gradient*, and it is exactly where primitivity of `T` — via
Lemma 2.1, via smoothness of `X` — is consumed.

The step is not removable at the level at which it is used:
`verify_forced_foliation.py` (C2) exhibits a polynomial rank-one matrix
`[[x0x1, x1^2],[x0^2, x0x1]] = P Q^t` with `Q` non-primitive and `P` not
polynomial. It is however only **sufficient**: (C1) records that rescaling a
tuple by a form makes `Q` non-primitive while `P` stays polynomial. The source's
phrasing invites the stronger reading; the weaker one is what is true.

(C1) also records a fact worth keeping: `P_{hT} != h P_T`. Rescaling changes the
cone-level fibration, since `J(hT) = h J_T + T grad(h)^t`. The forced object is
attached to the cone map, not to the projective map.

## R34 — the equivariance step needs one identity the source omits

The source says `P_T(gx)` and `g P_T(x)` "differ by a character; `G` perfect
=> trivial". The step that makes this work is
`adj(g J g^{-1}) = adj(g^{-1}) adj(J) adj(g) = g adj(J) g^{-1}`, in which the
`det(g^{-1})` and `det(g)` cancel exactly; without it one would expect a
`det(g)`-twist and the conclusion would not be a clean character statement. The
identity is checked symbolically with `det g = 13 != 1` (block B1), and on exact
`5x5` integer data (B1').

The character is then genuinely there and genuinely needs perfectness. Blocks
(9a)–(9e) run the entire chain on a `mu_3`-covariant tuple landing on a conic
that `G` only *semi*-invariates (`chi = w^2`): there `P(gx) = chi(g)^{-1} g P(x)`
holds and `P(gx) = g P(x)` **fails**. This is the case in which the source's
argument could have gone wrong, and it does not.

## R36 — the one correction

(14) is stated by the source as though `O(5-2d)` were the foliation's canonical
bundle. `P_T` may have content. In the packet's exact witness

```
P_T = 336 x_0^2 x_1^2 x_2 (x_1 x_3^2 - x_0 x_4^2) (0,0,0, x_0 x_4, x_1 x_3),
```

so `deg P_T = 10 = 2d-4` with `d = 7` as (7) predicts, while the saturated
foliation has degree `2`. The forced covariant has pinned degree; the forced
*foliation* does not. `FOLIATION_REFORMULATION.md` states the classification
target for the covariant for this reason, and flags (F4) so that a future search
does not normalize to primitive fields and miss members.

## R37 — the consistency finding, which is this round's most useful negative

The source asserts in §5(b) that nonequivariant polynomial unirational
parametrizations of cubic threefolds exhibit the same structure. That is right,
and it is worth more as an exact object than as a remark, so the packet builds
one: a smooth cubic threefold, an explicit primitive dominant tuple of degree
`7` from the Segre conic-bundle construction, and machine verification of every
one of (4), (5), (6), (7), (8), (10), (11), (12) symbolically over `Q`
(`forced_foliation_witness.m2`, `RESULT: PASS`).

Consequence, recorded as
`FORCED-FOLIATION-CONDITIONS-CONSISTENT-NON-EQUIVARIANTLY`:
**no argument can derive a contradiction from (5)–(13) alone.** Any exclusion
must consume the equivariance (9), or the specific module
`(Sym^{2d-4}W^v ⊗ W)^G`, or the Klein `F`. This is the same shape as the round-3
refutation and as the `O4` witness: the structure is real, and the structure
alone is not an obstruction.

Related, and worth stating because it is easy to misread: the first-integral
field containing a cubic-threefold function field is **not** paradoxical, since
cubic threefolds are unirational. The whole content of the forced-foliation
theorem beyond the classical Jacobian-derivation picture is the word
*`G`-invariant*.

## R41 — the socle corollary, sharpened in three ways

The source's argument is right: the five partials of a smooth cubic in five
variables are a regular sequence, the Jacobian ring is an Artinian complete
intersection with Hilbert series `(1+t)^5`, socle degree `5`, so every form of
degree `>= 6` is in the Jacobian ideal, and (18) `H + sum F_i Q_i = F R` says
`H in J + (F) = J` (Euler), hence is vacuous. Verified twice for the **actual**
Klein cubic: Macaulay2 Hilbert function `(1,5,10,10,5,1,0,0,0)` with the socle
spanned by the degree-five Hessian, and an independent exact mod-`p` rank bound.
It also agrees with the sealed Griffiths-residue computation in
`certificates/hodge_centers/HODGE_CENTER_NECESSITY.md` §3.

Three sharpenings the source does not make:

1. In degree exactly `5` the gate is **one** linear condition, not none and not
   many, since `dim (R/J)_5 = 1`; the Hessian is an explicit form violating it.
2. The vacuity **survives equivariance**. `H` must be invariant and `Q`
   covariant; the map `Q |-> sum_i F_i(x) Q_i` is a `G`-map onto `J_{d-1}`, so
   for `d >= 7` a covariant solution exists by the same Reynolds exactness the
   interpolation theorem uses. (Proposition 4.2 of `DEFECT_IDENTITY.md`.)
3. In the retraction branch it is **moot**: the sealed floor there is `d >= 24`
   (`DELTA1-RETRACTION-COORDINATE-DEGREE-AT-LEAST-24`), so `deg H >= 23`. The
   first of the three sealed identities carries no information about any
   surviving retraction, and the branch's content is entirely in `F(Q) = HS`,
   `HR + 3Phi(x,Q,Q) + FS = 0`, and the recorded `Delta = R^2 + 4S` nonsquare
   residual.

## R45 — added here, absent from the source

`verify_covariant_dimensions.py` computes `dim (Sym^k W^v)^G` and
`dim (Sym^k W^v ⊗ W)^G` exactly by character theory for `k <= 24`
(reproduced by a second independent implementation), and
`FOLIATION_REFORMULATION.md` Lemma 2.1 shows `div` is onto the invariants, so
the divergence-free dimension is `C(k) - I(k-1)` exactly. Two consequences the
source does not have:

* `C(2) = C(3) = 0` and `C(1) = 1` (spanned by `x`, with `F(x) = F != 0`), so
  **every landing tuple has `d >= 4`** — a floor with no branch hypothesis,
  from nothing but the character table.
* the divergence-free spaces at the bottom are tiny: dimension `1` for
  `d = 4` and `d = 5`, then `4` and `7`. The first cases of the new lane are
  finite and small.

**Third confirmation, by explicit representation theory.**
`verify_low_degree_covariants.py` rebuilds the five-dimensional representation
from `sigma`, `tau = diag(z^{(-2)^i})` and the involution `iota` **reused from
the repository's own** `exact_schur_frame/exact_representation_core.py`
(its `weil_generators()` second matrix was checked to equal `tau` exactly),
enumerates `|<sigma,tau,iota>| = 660`, checks `F` invariant under all three and
the generator traces `0`, `(-1+sqrt(-11))/2`, `1` against the five-dimensional
character, and then computes `Cov_k` for `k <= 8` as a joint kernel over
`Q(zeta_11)`. It reproduces the character-theoretic table exactly —
`1,0,0,2,1,2,4,5` and divergence-free `0,0,0,1,1,1,2,4` — by a route that shares
no arithmetic with it. The `d >= 4` floor is therefore confirmed three
independent ways.

It also returns the unique degree-four divergence-free covariant `D_4`
explicitly, **over `Q`**, primitive, seven terms per component, displayed in
`FOLIATION_REFORMULATION.md` §3. `verify_d4_covariant.py` audits it on a fourth
path — including covariance under `iota`, the generator that cuts `Cov_4` from
`7` to `2` — with `iota` rebuilt from the repository formula rather than
imported and `Q(zeta_11)` implemented as `Q[z]/(z^11-1)`. Exit
`DEGREE-FOUR-DIVERGENCE-FREE-COVARIANT-EXPLICIT`.

Recorded as a **non-claim**: `D_4` is the unique candidate the linear shadow
permits at `d = 4`, not a landing foliation. Whether it is realised is (F1) and
is open.

## R4 — exit-name mapping

The source's exit vocabulary is renamed to repository style. For the record:

| source name | recorded as |
|---|---|
| `FINITE-G-EQUIVARIANT-JET-DATA-ASYMPTOTICALLY-INTERPOLABLE` | `FINITE-EQUIVARIANT-JET-DATA-ASYMPTOTICALLY-INTERPOLABLE-PROVED` |
| `LOCAL-CLUSTER-CONDITIONS-NOT-AN-ALL-DEGREE-OBSTRUCTION` | `FIXED-FINITE-LOCAL-DATA-NOT-AN-ALL-DEGREE-OBSTRUCTION-PROVED` (**"fixed" added**, per R28) |
| `GLOBAL-JACOBIAN-ADJUGATE-FACTORIZATION` | `GLOBAL-JACOBIAN-ADJUGATE-FACTORIZATION-PROVED` |
| `GLOBAL-RIGHT-KERNEL-COVARIANT-DEGREE-2D-MINUS-4` + `GLOBAL-RIGHT-KERNEL-DIVERGENCE-FREE` | `FORCED-DIVERGENCE-FREE-COVARIANT-DEGREE-2D-MINUS-4-PROVED` |
| `GLOBAL-LANDING-COORDINATES-ARE-FIRST-INTEGRALS` | `LANDING-COORDINATES-ARE-FIRST-INTEGRALS-PROVED` |
| `GLOBAL-JACOBIAN-COMPLEX-DEFECT-IDENTITY` | `GLOBAL-JACOBIAN-COMPLEX-DEFECT-IDENTITY-PROVED`, plus the negative `DEFECT-IDENTITY-IMPOSES-NO-EFFECTIVITY-CONSTRAINT` |
| — | `FORCED-FOLIATION-WITNESS-EXACT`, `FORCED-FOLIATION-CONDITIONS-CONSISTENT-NON-EQUIVARIANTLY`, `JACOBIAN-SOCLE-DEGREE-FIVE-EXACT`, `FIRST-ORDER-TANGENT-EXTENSION-GATE-VACUOUS-ABOVE-DEGREE-FIVE-PROVED`, `LANDING-DEGREE-AT-LEAST-FOUR-PROVED`, `BOXED-OBJECT-IS-THE-HEADLINE-OBJECT`, `RT-OBSTRUCTION-LADDER-CLOSED`, `DECORATED-CLUSTER-OBSTRUCTION-PROGRAM-BOTTOMED-OUT`, `FOLIATION-CLASSIFICATION-TARGET-REGISTERED`, `COVARIANT-AND-DIVERGENCE-FREE-DIMENSIONS-EXACT` (all new here) |

The source's UNDECIDED list — `NO-SINGLE-HOMOGENEOUS-G-COVARIANT-LANDING-TUPLE`,
`X_GEN(K_PROJ)-EMPTY`, `KLEIN-PSL2(11)-NON-G-UNIRATIONAL` — is confirmed, and by
R24 all three are the **same** statement. The repository records it once, as
`PROBLEM-E-HEADLINE-OPEN`.
