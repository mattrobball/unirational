# Sources

## A. External provenance

The mathematical content of this packet originates in an **external ChatGPT
session**, transcript messages `[10]`, `[15]`, `[20]` (three successive reports;
`[15]` revises `[10]`, `[20]` corrects both and withdraws five claims), and a
later round `[21]` (the slice classification and the claimed refutation of the
pointed-rational-curve exclusion). All of it was **unaudited**. It has been
adjudicated here claim by claim; see `ADJUDICATION.md` for per-claim verdicts,
including one refutation of an external claim, several claims whose proofs had
to be supplied, one weakening, one citation correction, one cited repository
input that does not exist as cited, and — for round 3 — one **scope
correction** to a headline that overstated what its own construction refutes.

**Round 3 (`[21]`), added on branch `agent/rt-slice-classification-20260811`.**
Ported into `SLICE_CLASSIFICATION.md`,
`REFUTATION_POINTED_CURVE_EXCLUSION.md`, the revised
`BOXED_GLOBAL_COVARIANT.md`, the new verifier `verify_slice_universality.py`
and blocks `C7`–`C7d` of `verify_conic_slice.py`. Per-claim verdicts are the
`R1`–`R23` table in `ADJUDICATION.md`. Summary of what had to be repaired:
Zariski–Lipman applied to a possibly non-`m`-primary ideal; the residue field of
`eta_S` is not algebraically closed; "complete classification" needed an
equivalence relation; the proof of `B_C` iso; the proof of
`beta_D pi_D^* = k M_{a,m}`; the vanishing of the `xi`-term in `M_{a,m}` (which
strengthens the result); the ampleness hypothesis on `L_{a,m}`; and the scope of
the refutation.

The external session's own bibliographic pointers were opaque tokens
(`fileciteturn...`, `citeturn...`) with no resolvable targets. Every
repository citation below was located independently; every literature citation
below was verified independently against a primary source unless flagged.

## B. Repository artifacts used (all paths relative to `problems/E-klein-cubic/`)

| what | where | exit / label |
|---|---|---|
| Klein cubic, group, module conventions | `SPEC.md`, "Convention and status" | — |
| landing tuple convention `F(A) = 0` | `goal_runs_20260809/AMBIENT_REES_SELFMAP_CLASSIFICATION/THEOREM.md`, Thm B | — |
| dominant-transform theorem (supplies `h`) | `goal_runs_20260809/EXCEPTIONAL_CARRIER_RIGIDITY/AMBIENT_REES_COMPARISON.md` section 2, eq. (2.1) | — |
| ambient support theorem (proper strict supports only) | `goal_runs_20260810/AMBIENT_HODGE_REES_BRIDGE/AMBIENT_SUPPORT.md` section 4; `THEOREM.md` Thm B | — |
| `(RT)` as the open implication | `goal_runs_20260810/AMBIENT_HODGE_REES_BRIDGE/STATUS.md`, tag `(RT)` | — |
| `i_pi, t_pi, i_q, t_q, e_exc, u_phi, r_phi`; CARRIER/CLEAN | `goal_runs_20260810/RT_SPLIT_AND_DICHOTOMY/THEOREM_RESTRICTED_DICHOTOMY.md`, Lemmas 2.1–2.2, Thm 3.1 | `RESTRICTED-DICHOTOMY-PROVED` |
| orbit sizes of `G` (`11,11,12,55,66,...,660`) | `goal_runs_20260810/RT_SPLIT_AND_DICHOTOMY/DEGREE_ACCOUNTING.md` section 2 | — |
| invariant-degree lemma `k ∈ {0} ∪ {5,6,...}` | `goal_runs_20260810/COMBINED_DEGREE_SIEVE/THEOREM_COMBINED_SIEVE.md`, Lemma 2.3 | `COMMON-FACTOR-INVARIANT-DEGREE-SET-PROVED` |
| retraction polar identity `T = Hx + FQ`, `F(x+tQ) = (Ht-F)(St^2-Rt-1)` | `goal_runs_20260808/DELTA1_RETRACTION_POLAR_IDENTITY/THEOREM.md` sections 1–2 | — |
| minimal class `theta^4/4!` algebraic (integral) | `goal_runs_20260808/DELTA1_MINIMAL_CLASS/THEOREM.md`, Thm 3.1 | `KLEIN-IJ-MINIMAL-CLASS-ALGEBRAIC`, `KLEIN-CUBIC-UNIVERSALLY-CH0-TRIVIAL` |
| equivariant minimal class audit (negative) | `goal_runs_20260808/DELTA1_EQUIVARIANT_MINIMAL_CLASS_AUDIT/` | `DELTA1-PRIMITIVE-FIXED-CHOW-LIFT-NOT-FORCED-BY-CITED-THEOREMS` |
| `J(X) ≅ E^5` not as ppav, director-verified quotation | `goal_runs_20260811/RETRACT_LANDSCAPE_NOTE/THEOREM.md` section 2(i); `ADJUDICATION_PR38.md` item 9 | — |
| Auto-CM Lemma | `theory/FIX_VII_carrier.md` section 1, Lemma 1 | — |
| receiver ledger + scope disclaimer (PR #27) | `goal_runs_20260810/RECEIVER_LEDGER_X/THEOREM.md` sections 0, 5.2, 8 | `RECEIVER-LEDGER-X-PASS` |
| `FRONTIER-1/2/3` | `goal_runs_20260810/SPIN_SOURCE_NETWORK/DEPENDENCY_MAP.md` section 5 | — |
| `O4` witness (Hesse cubics) | `goal_runs_20260810/SPIN_SOURCE_NETWORK/O4_EIGENPLANE_CURVES.md`, Thm O4-5 | `O4-EIGENPLANE-CURVES-OPEN-WITH-WITNESS` |
| KLS minimality exit | `goal_runs_after_35fa/KLS_MINIMALITY/STATUS.md` | `KLS2-NO-FINITE-REDUCTION` |
| Fano–Rees retraction carrier | `goal_runs_20260809/RETRACTION_FANO_REES_CARRIER/THEOREM.md` Thm 6.1, section 7 | `DELTA1-IRREDUCIBLE-BASE-DOMINATES-FANO-SURFACE` |

Added for round 3:

| what | where | exit / label |
|---|---|---|
| `End_{G-HS}(V) = K = Q(sqrt(-11))`, eq. (4.1); `End_{G-HS}(V_Z) = O_K`, eq. (4.2); Rosati = complex conjugation; `delta = N(u_phi) = x^2+xy+3y^2`, eq. (4.4) | `goal_runs_20260810/RT_SPLIT_AND_DICHOTOMY/THEOREM_RESTRICTED_DICHOTOMY.md` section 4 | `RESTRICTED-CLEAN-CM-NORM-PROVED` |
| double-hit argument: general `D_0` in a high very ample system on `I` has `e|_{D_0}` generically one-to-one; `G`-stable split divisors in unbounded classes | `goal_runs_20260808/DELTA1_RETRACTION_POLAR_IDENTITY/THEOREM.md` section 5 (eqs. 4.5–4.6) | `DELTA1-INVARIANT-SPLIT-DIVISORS-UNBOUNDED` |
| unbounded blowup depth of `[u^N : v]`, machine-checked | `goal_runs_20260810/SPIN_SOURCE_NETWORK/R1_TOTAL_DEGENERATION.md` section 2; `verify_r1_degeneration.py` `A11` | `R1-INDUCTION-REFUTED`, `R1_DEGENERATION_OK` |
| Klein cubic has no Eckardt points (exact M2) | this packet, `eckardt_klein.m2`; `THEOREM_LEAKAGE_CLASSIFICATION.md` section 4.5 | `KLEIN-CUBIC-NO-ECKARDT-POINTS` |
| `T_D = ±2n·id` for `[D] = r·eta + n·pi^*C` — ported, not replayed | this packet, `COUNTERMODEL_CONIC_SLICE.md` section 5 | `LINE-INCIDENCE-FACTOR-TWO-CONDITIONAL` (`r`-cancellation half now proved) |

Added for round 4:

| what | where | exit / label |
|---|---|---|
| the all-degree theorem: five canonically equivalent sets, including landing covariants in arbitrary degree and `X_T(K_proj)` | `goal_runs_after_35fa/G_UNIVERSAL/ALL_DEGREE_THEOREM.md`; `SEAL.json` (`G2_UNIVERSAL_SEAL_V2`) | `G2-FINITE-GENERATION-PASS` |
| dominance is automatic; no separate Jacobian-rank-four gate. **Step 6 of its ledger is `ACCEPTED_INPUT` (`ed_C(G) >= 3`, Beauville), not a repo proof** | `goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE/DOMINANCE_BRIDGE.md`, `SEAL.json` | `G3A-ARITHMETIC-DOMINANCE-PASS`, `G3-DOMINANCE-AUTOMATIC` |
| `G_UNIVERSAL/DECISION.md` states the opposite about dominance and is **superseded** by `G3A` | `NOTEBOOK.md` §17 | — |
| `C` is `G`-unirational `<=> ed_C(G)=3`; `3 <= ed_C(G) <= 4`; so not `G`-unirational `<=> ed_C(G)=4` | `RESOLUTION.md`, "Exact reduction to essential dimension"; `SPEC.md` essential-dimension audit | — |
| the direct-arithmetic package on `V(Phi)`: no `K_proj`-point produced; Clifford/spinor and 27-line gates `*-PARTIAL` | `goal_runs_after_ff69434/G3D_DIRECT_ARITHMETIC/STATUS.md`, `SEAL.json` (**governs** over the file's internal phase ledger, `NOTEBOOK.md` debt item 17) | `G3D-UNDECIDED` |
| the sealed retraction identity `H + 3Phi(x,x,Q) = FR`, `F(Q)=HS`, `HR+3Phi(x,Q,Q)+FS=0`; `deg H = d-1`, `deg Q = d-3`; the residual `Delta = R^2+4S` and "no invariant-degree reason for `Delta` to be a square" | `goal_runs_20260808/DELTA1_RETRACTION_POLAR_IDENTITY/THEOREM.md` §§1,3,7 | `DELTA1-KLEIN-RETRACTION-BRANCH-OPEN`, `DELTA1-PRIMITIVE-IRREDUCIBLE-NONSQUARE-COUNTERMODEL-EXACT` |
| the binding retraction degree floor `d >= 24` | `goal_runs_20260809/AMBIENT_REES_SELFMAP_CLASSIFICATION/RETRACTION_DEGREE_BOUND.md` | `DELTA1-RETRACTION-COORDINATE-DEGREE-AT-LEAST-24` |
| F55 coefficient circuits bottom out at the headline: "the global statement of Coverage C is equivalent to the original F55 pointlessness problem" | `F55_COVERAGE_C_ADJUDICATION_20260808.md`; `goal_runs_20260810/F55_LADDER_COMPLETION/STATUS.md` §4 | `F55-PC-COVERAGE-C-EQUIVALENT-TO-HEADLINE` |
| the CLEAN sieve bottoms out: "Closing CLEAN needs a geometric exclusion of small `delta`, not more congruences" | `goal_runs_20260810/COMBINED_DEGREE_SIEVE/STATUS.md`, `CONSTRAINT_LEDGER.md` | `COMBINED-SIEVE-NO-PERIODIC-CLOSURE-PROVED` |
| the KLS conductor/minimality program admits no finite reduction | `goal_runs_after_35fa/KLS_MINIMALITY/STATUS.md` | `KLS2-NO-FINITE-REDUCTION` |
| Griffiths-residue Jacobian ring of the Klein cubic: `dim R_d = 1,5,10,10,5,1,0` — same Hilbert function this packet recomputes | `certificates/hodge_centers/HODGE_CENTER_NECESSITY.md` §3 | — |
| the repo already considered, and set aside, plain vector fields tangent to the cubic cone as insufficient to linearize the landing equation | `goal_runs_20260809/AMBIENT_REES_SELFMAP_CLASSIFICATION/LANDING_SYZYGY_MODULE.md` §3 | — |
| `adj(Hess F)·grad F = ½ H x` — the same adjugate vocabulary applied to the Hessian, a **different** object from `adj(J_T)`, and recorded there as not new | `goal_runs_after_ad6746b/FIX_VII_XRING/REPORT.md` | — |

| the kernel foliation registered as a lane (**C5**, "the biggest genuinely new lane"), and `grad F(T)·J_T = 0` as **C4** — from a *different* external audit, the same day | `theory/CONSTRAINT_ADDITIONS_20260811.md` §§C4, C5 | — |

*Novelty check for round 4, stated carefully.* The **lane** is not new: item C5
of the constraint ledger, folded in on the same day from a different external
source, already says the kernel of `d[T]` is a `G`-invariant integrable rank-one
foliation and calls it the biggest new lane. What round 4 adds is the
**theorem**: an explicit polynomial generator `P_T` of that kernel, of pinned
degree `2d-4`, obtained by an exact division that consumes primitivity;
its divergence-freeness; the exact dimensions of the ambient covariant modules;
and an exact witness. "Piola", "first integral" in this sense, and "socle" do
not occur elsewhere in `problems/E-klein-cubic/` prose. The two nearby but
distinct items are `adj(Hess F)·grad F` (a different adjugate, of the Hessian,
recorded there as not new) and the rejected plain-tangent-vector-field
linearization of `LANDING_SYZYGY_MODULE.md` §3.

## C. Literature — verified

Each entry was checked against a primary source (arXiv/journal text) unless
marked. Where the external session's attribution was wrong, the correction is
stated.

1. **G. Barthel, J.-P. Brasselet, K.-H. Fieseler, O. Gabber, L. Kaup**,
   *Relèvement de cycles algébriques et homomorphismes associés en homologie
   d'intersection*, Ann. of Math. (2) **141** (1995), 147–179.
   Construction of `f^*IC_W → IC_Z` compatible with the maps from the constant
   sheaves; **non-canonical** in general (canonical only for a closed embedding
   of irreducible varieties of relative dimension 1).
   *Correction:* the external session credits this to Hanamura–Saito. It is
   their Theorem 2, but they cite BBFGK as the origin; primary credit is BBFGK.

2. **M. Hanamura, M. Saito**, *Weight filtration on the cohomology of algebraic
   varieties*, arXiv:math/0605603. Restates the above as Theorem 2 with a
   shorter proof via Gabber purity, extending it to positive characteristic.
   (Final journal venue unconfirmed.)

3. **A. Weber**, *Pure homology of algebraic varieties*, Topology **43** (2004),
   635–644 (arXiv:math/0302340). For `X` complete,
   `ker(H^k(X,Q) → IH^k(X,Q)) = W_{k-1}H^k(X,Q)`; equivalently the image of
   `H^k → IH^k` is the pure quotient `gr^W_k H^k`. **This is the input that
   repairs the weight step of the transfer theorem** (`ADJUDICATION.md` item 2).

4. **M. Saito**, mixed Hodge modules and the six-functor weight formalism
   (`f^*` preserves weights `≤ w`; `Hom` vanishing from weights `≤ n` to weights
   `> n`; purity of `IC^H`). Used for the object-level form of item 3.
   *Honest flag:* we verified the cohomological form (item 3) against Weber and
   took the object-level form from Saito's package without re-proving it.

5. **S. Bloch, V. Srinivas**, *Remarks on correspondences and algebraic cycles*,
   Amer. J. Math. **105** (1983), 1235–1253. If `CH_0(Y)` is supported on
   `W ⊂ Y` then `N·[Delta_Y] = Z_1 + Z_2` in `CH^d(Y×Y)` for some nonzero
   integer `N`, `Z_1` supported on `D×Y` (`D` a proper divisor), `Z_2` on `Y×W`.
   `N` cannot in general be taken to be `1`. **This is the whole input to the
   refutation** (`REFUTATION_CONDUCTOR_GYSIN.md` Theorem 2.1).
   *Flag:* the 1983 original is paywalled and pre-arXiv; the statement used here
   is Voisin's verbatim restatement (arXiv:1005.1346, eq. 0.2), which is
   standard and uncontested.

6. **C. Voisin**, *On the universal `CH_0` group of cubic hypersurfaces*,
   J. Eur. Math. Soc. **19** (2017), 1619–1653 (arXiv:1407.7261). For cubic
   threefolds: universal triviality of `CH_0(X)` — equivalently a Chow-theoretic
   decomposition of the diagonal — is **equivalent** to algebraicity of the
   minimal class `theta^4/4!` on `J(X)`. Voisin records that for the very
   general cubic threefold this is **open**; it is known only on a countable
   union of special loci.
   *Correction:* the iff is in this 2017 paper, **not** in
   *Abel–Jacobi map, integral Hodge classes and decomposition of the diagonal*,
   J. Alg. Geom. **22** (2013), 141–174 (arXiv:1005.1346), which gives only a
   partial converse under side conditions (`H^4(Y,Z)` algebraic, torsion-free
   cohomology, an Abel–Jacobi surjectivity property). The repository's
   `DELTA1_MINIMAL_CLASS/SOURCES.md` already cites the 2017 paper (as
   "On the universal CH0 group of cubic hypersurfaces, Cor. 4.4"), correctly.

7. **H. Clemens, P. Griffiths**, *The intermediate Jacobian of the cubic
   threefold*, Ann. of Math. (2) **95** (1972), 281–356. Theorem 0.12:
   `(J(V), theta_V)` is not "of level one", i.e. not isomorphic **as a ppav** to
   a direct sum of Jacobians of smooth curves; hence `V` is not rational.
   Theorem 0.9: `[F(X)] = theta^3/3!` for the Fano surface.
   *Correction:* the external session's neighbourhood attributes the Fano-surface
   class to Beauville; the origin is Clemens–Griffiths Thm 0.9. Note also that
   `theta^3/3!` (a 2-cycle class, realised by `F(X)`) is a **different** class
   from the minimal `theta^4/4!` (a 1-cycle class) of item 6.
   *Flag:* the Annals original is paywalled; wording corroborated via the paper's
   introduction as quoted in accessible secondary sources.

8. **X. Roulleau**, *The Fano surface of the Klein cubic threefold*,
   J. Math. Kyoto Univ. **49** (2009), 113–129 (arXiv:1001.4853).
   `J(F) ≅ Alb(S) ≅ E^5` where `E = C/Z[nu]`, `nu = (-1+sqrt(-11))/2`, i.e. CM
   by the maximal order of `Q(sqrt(-11))` — an **isomorphism of abelian
   varieties**, and explicitly *not* an isomorphism of principally polarized
   abelian varieties (consistent with, and forced by, item 7).
   Earlier independent proof: **A. Adler**, *Some integral representations of
   `PSL_2(F_p)` and their applications*, J. Algebra **72** (1981), 115–145.
   (Distinct from Adler's 1978 Amer. J. Math. paper on the automorphism group.)

9. Standard perverse-sheaf and decomposition-theorem facts used without
   citation to a specific source: `i^*i_* = id` for closed immersions; perverse
   amplitude `[-1,0]` of `i^*` for a Cartier divisor; `k^!IC_X ∈ {}^pD^{≥c}` for
   a codimension-`c` closed subvariety of smooth `X`; the fibre-dimension bound
   on perverse degrees (defect of semismallness); `IC_S` a direct summand of
   `Rf_*IC_{S̃}` for a resolution; `nu_*IC_{S^nu} = IC_S` for a finite
   normalization.

Added for round 3:

10. **J. Lipman**, *Rational singularities, with applications to algebraic
    surfaces and unique factorization*, Publ. Math. IHÉS **36** (1969), 195–279.
    The Zariski theory of complete ideals — products of complete ideals are
    complete, and complete `m`-primary ideals factor uniquely into simple
    complete ideals — for **any** two-dimensional regular local ring, i.e.
    without Zariski's hypothesis that the residue field be algebraically closed.
    That generality is what the application needs, since the residue field here
    is `kappa(eta_S)`.
    Original: **O. Zariski**, *Polynomial ideals defined by infinitely near base
    points*, Amer. J. Math. **60** (1938), 151–204; textbook form in
    Zariski–Samuel, *Commutative Algebra* II, Appendix 5.

11. **E. Casas-Alvero**, *Singularities of Plane Curves*, LMS Lecture Notes 276,
    CUP (2000), §4.5 and Thm 8.4.6. Weighted clusters, proximity, point basis,
    excesses, `E_p^* · E_q^* = -delta_{pq}`, `D·E_p = -rho_p`, and the Zariski
    factorization `Ibar = prod_p P_p^{rho_p}`. Used only for the conventions and
    the two displayed formulas, both re-derived in `SLICE_CLASSIFICATION.md` §2.2.

12. **H. Clemens, P. Griffiths**, op. cit. (item 7), §10 and Theorem 11.19: the
    cylinder homomorphism `H_1(F(X),Z) → H_3(X,Z)` is an isomorphism,
    equivalently `Alb(F(X)) ≅ J(X)`. Its transpose is
    `alpha_F = pi_* e^* : H^3(X,Q)(1) → H^1(F,Q)`, the input to (16) and — via
    Poincaré adjunction — to (17). Same paywall flag as item 7.

13. Standard facts used without citation to a specific source, beyond item 9:
    hard Lefschetz on a smooth projective surface; weak Lefschetz for a smooth
    ample divisor in a smooth threefold; `H^*(P(E)) = H^*(F) ⊕ H^{*-2}(F)·xi`
    for a `P^1`-bundle; flat base change and the projection formula for proper
    maps; Poincaré adjunction for algebraic correspondences,
    `<Gamma_* a, b> = <a, {}^tGamma_* b>`; `b_1(X) = 0` and `H^3(X,Z) ≅ Z^{10}`
    torsion-free for a smooth cubic threefold; `Pic X = Z·H` (Lefschetz), hence
    every surface in `X` has degree divisible by 3; six lines through a general
    point of a cubic threefold.

## E. Literature for the foliation lane — orientation only

**Nothing in this section is used as an input to any proof in this packet, and
no claim is made that any of it applies to the classification target (FOL) of
`FOLIATION_REFORMULATION.md`.** These are standard references, given so that a
later run does not rediscover the subject from scratch. They are cited from
memory of the standard literature and have **not** been re-checked against
primary sources in this run; that is flagged deliberately, because unlike
section C they carry no weight.

**E1. Used, and standard.**

* *Piola's identity* — the rows of the cofactor matrix of any `C^2` map are
  divergence-free, `sum_j d_j cof(J)_{ij} = 0`. Classical; appears in continuum
  mechanics as the Piola identity and in algebra as the divergence-freeness of
  Jacobian derivations. **Not taken on trust**: verified symbolically here for
  generic polynomial maps in `n = 3, 4` (`verify_forced_foliation.py` B3) and
  for the degree-7 witness in `n = 5` (`forced_foliation_witness.m2`).
* *Jacobian derivations and rings of constants* — A. Nowicki, *Polynomial
  derivations and their rings of constants*, Toruń 1994, and the surrounding
  literature. `P_T` is a Jacobian derivation divided by one entry of the
  pulled-back gradient. The classical part of `THEOREM_FORCED_FOLIATION.md` is
  exactly this; the equivariance and the degree drop are not.
* *Socle of a graded Artinian complete intersection* — for forms of degrees
  `d_1..d_n` in `n` variables the socle degree is `sum (d_i - 1)`; here
  `5·(2-1) = 5`. Standard (Eisenbud, *Commutative Algebra*, ch. 21). **Not
  taken on trust**: recomputed for the Klein cubic in two independent ways.
* *Serre vanishing* — `H^1(P^n, I_Z(d)) = 0` for `d >> 0`, Hartshorne,
  *Algebraic Geometry*, III.5.2. This is the **only** citation the interpolation
  theorem consumes, and it is not re-proved.
* *Unirationality of a cubic hypersurface containing a line* (the Segre
  construction), used to build the witness tuple. Kollár–Smith–Corti,
  *Rational and Nearly Rational Varieties*, CUP 2004, §5.3. **Not taken on
  trust**: the resulting tuple satisfies `F(T) = 0` symbolically in the
  verifier, so the construction is self-certifying here.

**E2. Orientation, not used.**

* G. Darboux (1878), on algebraic first integrals of polynomial vector fields;
  and J.-P. Jouanolou, *Équations de Pfaff algébriques*, Springer LNM 708
  (1979), for the generic non-existence of algebraic invariant hypersurfaces.
  Our foliations are the extreme opposite: algebraically integrable, with a
  three-dimensional worth of independent first integrals.
* H. Poincaré (1891), *Sur l'intégration algébrique des équations
  différentielles du premier ordre et du premier degré* — the **Poincaré
  problem**: bound the degree of an invariant algebraic curve, or of an
  algebraic first integral, by the degree of the foliation. M. Carnicer, *The
  Poincaré problem in the nondicritical case*, Ann. of Math. 140 (1994), and
  D. Cerveau, A. Lins Neto, Ann. Inst. Fourier 41 (1991), give bounds on `P^2`
  under hypotheses. (FOL) has the shape of a Poincaré problem run backwards —
  the first integrals are prescribed and the foliation degree `2d-4` is what is
  constrained. We know of no bound in `P^4` in a form that applies and assert
  none.
* D. Cerveau, A. Lins Neto, *Irreducible components of the space of holomorphic
  foliations of degree two in CP(n), n >= 3*, Ann. of Math. 143 (1996). By
  analogy only: those are **codimension-one** foliations, ours are **rank one**,
  hence codimension three in `P^4`. The analogy should not be pushed.
* F. Loray, J. V. Pereira, F. Touzet, *Singular foliations with trivial
  canonical class*, Invent. Math. 213 (2018), and the surrounding structure
  theory. A possible source of leverage on the **saturated** foliation, whose
  degree is not pinned by the theorem (see `THEOREM_FORCED_FOLIATION.md` §3).
* A. Beauville, *On finite simple groups of essential dimension 3*,
  arXiv:1101.1372 — already in `SPEC.md`'s reference list; recorded here because
  the `ed_C(G) >= 3` lower bound is the single accepted external input inside
  the `G3-DOMINANCE-AUTOMATIC` bridge on which "dominance is automatic" rests.

## C5. Round 5 — the forced-structure classification (external, unaudited)

Transcript `transcript3.md`, message `[10]`, sections 1–10. Adjudicated in
`ADJUDICATION.md` items `R5-1` … `R5-21`. Ported to
`THEOREM_SOURCE_TANGENCY.md`, `EXCLUSION_DPRIME_2_3.md`,
`BASE_GRADIENT_PACKAGE.md`, `D35_BRANCH_TABLE.md`,
`DEFECT_SMITH_CLASSIFICATION.md`, and sections 5–7 of
`FOLIATION_REFORMULATION.md`, section 6 of `BOXED_GLOBAL_COVARIANT.md`.

Repository inputs newly consumed or re-linked by this round:

* `goal_runs_20260808/FULL_G_RESTRICTION_DOMINANCE/THEOREM.md`, Theorem 1.1 —
  the restricted selfmap `phi = f|_X` is dominant, hence generically finite of
  degree `delta >= 1`. This is the hypothesis the external source omits and
  everything in round 5 needs. Its own accepted external input is
  `ed_C(PSL_2(F_11)) >= 3` (Beauville; Duncan–Reichstein), already recorded in
  section B.
* `goal_runs_20260810/COMBINED_DEGREE_SIEVE/THEOREM_COMBINED_SIEVE.md`,
  Lemma 2.3 — `dim H^0(X,O_X(k))^G = I(k) - I(k-3)` and the invariant-degree
  set `k in {0} ∪ {5,6,...}`; the exclusion of round 5 is the same kind of
  computation performed at `2d'-2` instead of at `k`.
* `goal_runs_20260810/RT_SPLIT_AND_DICHOTOMY/THEOREM_RESTRICTED_DICHOTOMY.md`
  (4.4) — the CLEAN norm form `delta = x^2 + xy + 3y^2`, consumed by the
  `4 | delta` parity observation.
* `theory/CONSTRAINT_ADDITIONS_20260811.md` item **C12**, the postcomposition
  caveat, resolved *within the foliation lane* by
  `FOLIATION_REFORMULATION.md` Proposition 6.1.

Classical inputs used in the supplied proofs, none of them cited from the
source:

* the **Gelfand–Leray / Poincaré residue** form of a hypersurface,
  `dF ^ eta = Omega`, and its scaling weight `n - e`. Standard; see e.g.
  Arnold–Gusein-Zade–Varchenko, *Singularities of Differentiable Maps* II, §12,
  or Griffiths, *On the periods of certain rational integrals*, Ann. of Math. 90
  (1969), §3, where the residue is set up in exactly this homogeneous form.
* **Generic étaleness** of a dominant generically finite morphism in
  characteristic zero (so `Jac != 0`). Standard.
* **Smith normal form** over a discrete valuation ring, and the Cramer
  description of the kernel of a rank-`(m-1)` map `R^m -> R^{m-1}` by signed
  maximal minors. Standard.
* **No plane in a smooth cubic threefold** — proved from scratch in
  `BASE_GRADIENT_PACKAGE.md` §3 (two conics in a plane always meet), rather
  than cited.

## D. Machine tools

Macaulay2 and `python3`/`sympy` only, per the repository toolchain. No GAP,
Sage, Magma or PARI. See `REPLAY.md`.
