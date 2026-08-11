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
