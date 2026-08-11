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

## D. Machine tools

Macaulay2 and `python3`/`sympy` only, per the repository toolchain. No GAP,
Sage, Magma or PARI. See `REPLAY.md`.
