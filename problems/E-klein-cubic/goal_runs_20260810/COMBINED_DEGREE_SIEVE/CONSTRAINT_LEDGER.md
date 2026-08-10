# Constraint ledger — every degree condition, with provenance

Scope: conditions on the ambient coordinate degree \(d\) of a hypothetical
dominant \(G\)-equivariant landing map \(A:\mathbf P(W)\dashrightarrow X\), on
the primitive restricted degree \(d'\), and on the degree \(\delta\) of the
restricted selfmap \(\varphi=A|_X\).

Sealed status is reported exactly as the repository supports it.  Three levels
are used and each is stated, not inferred:

* **MAIN-PROVED** — the packet is merged on `main`, states a theorem with a
  proof, and carries an exit token; it is not a hash-sealed `certificates/`
  entry, and (for the `goal_runs_2026MMDD/` family) it is outside the reach of
  `scripts/check_manifest_parity.py`.
* **MAIN-REPLAYED** — merged on `main`, machine-replayed, and registered in
  `notebook_build/manifest.json`.
* **CERTIFIED** — a hash-sealed entry under `certificates/`.
* **UNSEALED** — session note, external transcript, or draft-discipline note.

Only rows in §A are used by the sieve.  §B rows are excluded.

---

## A. Constraints used

### A1. All-ambient lower bound \(d\ge22\)

* **Statement:** every nonzero \(P\in(\operatorname{Sym}^dW^\vee\otimes W)^G\)
  with \(F(P)=0\) has \(d\ge22\); hence every dominant \(G\)-equivariant
  ambient landing map has coordinate degree \(\ge22\).
* **Original packet:**
  `problems/E-klein-cubic/goal_runs_20260809/AMBIENT_REES_SELFMAP_CLASSIFICATION/LOW_DEGREE_DOMINANT_MAPS.md`
  (Theorem, boxed `d\ge 22`), restated as Theorem B in the sibling `THEOREM.md`.
* **Exit token:** `AMBIENT-LANDING-COORDINATE-DEGREE-AT-LEAST-22`.
* **Status:** MAIN-PROVED (landed on `main` in commit `67132b5`, "Promote new
  dominant-map theorems").  Degrees \(1..14\) come from earlier sealed
  certificates; \(15..21\) are new in that packet, computed by exact Reynolds
  averaging at the split prime \(67\) with characteristic-zero Molien
  dimensions as the comparison.  The packet's own headline exits
  (`NO-DOMINANT-G-AMBIENT-LANDING-MAP`, `KLEIN-PSL2(11)-NONUNIRATIONAL`) are
  explicitly **not** proved; this bound is a side theorem that is.
* **Used as:** the outer degree window.

### A2. Degree-one retraction bound \(d\ge24\)

* **Statement:** a primitive \(G\)-equivariant landing tuple of coordinate
  degree \(d\) whose restriction to \(X\) is the identity has \(d\ge24\).
* **Original packet:**
  `problems/E-klein-cubic/goal_runs_20260809/AMBIENT_REES_SELFMAP_CLASSIFICATION/RETRACTION_DEGREE_BOUND.md`
  (Theorem, boxed `d\ge24`), restated as Theorem C in `THEOREM.md`.
* **Exit token:** `DELTA1-RETRACTION-COORDINATE-DEGREE-AT-LEAST-24`.
* **Status:** MAIN-PROVED (same commit `67132b5`).  Mechanism: the invariant
  \(J=2H+FR\) of degree \(d-1\) vanishes on all \(55\) involution plus-planes,
  and the scalar plus-plane restriction map is injective through degree \(22\),
  so \(d-1\ge23\).  The packet notes the degree-24 divisibility locus is not
  proved empty.
* **Used as:** the retraction-branch window.
* **Cross-check with A6:** the packet's normal form \(T=Hx+FQ\) restricts on
  \(X\) to \(H|_X\cdot x\), i.e. \(d'=1\) with removed divisor \(\operatorname{div}(H|_X)\)
  of degree \(d-1\) and \(H\) invariant.  This is the \(d'=1\) instance of A6,
  independently derived, and the two agree.

### A3. Unconditional emptiness through \(d=30\)

* **Statement:** all \(107\) corrected-list profiles at \(d=25\ldots30\) have a
  zero slice, unconditionally in characteristic zero; together with the earlier
  window this closes every \(d\le30\).  Degrees \(31\!-\!33\) have partial
  screens only.
* **Original packet:**
  `problems/E-klein-cubic/goal_runs_after_2666fdb/FIX_P2_GATEWAY_D36/STATUS.md`.
* **Exit token:** `FIX-P2-SWEEP2-EMPTY-THROUGH-30`.
* **Status:** MAIN-REPLAYED — manifest record `goal_runs_after_2666fdb/FIX_P2_GATEWAY_D36`,
  entry `E56`, "director-replayed 48/48".  No `-PROVED` suffix on the token.
* **Adjudication used here:** the RT packet's
  `goal_runs_20260810/RT_SPLIT_AND_DICHOTOMY/DEGREE_ACCOUNTING.md` §3 and
  `ADVERSARIAL_TESTS.md` §C1 rule that this, not A1, is the binding precedence
  statement, giving the conservative live window \(\boxed{d\ge31}\).
* **Used as:** the live window; kills every \(d\in[22,30]\) in the table.

### A4. CLEAN forces \(\delta\) to be a norm from \(\mathbf Q(\sqrt{-11})\)

* **Statement:** in the CLEAN branch \(u_\varphi^\dagger u_\varphi=\delta\) on
  \(V=H^3(X,\mathbf Q)(1)\), \(\operatorname{End}_{G\text{-HS}}(V_{\mathbf Z})=\mathcal O_K\)
  with \(K=\mathbf Q(\sqrt{-11})\), \(h(K)=1\), hence
  \(\delta=N(u_\varphi)=x^2+xy+3y^2\).
* **Original packet:**
  `problems/E-klein-cubic/goal_runs_20260810/RT_SPLIT_AND_DICHOTOMY/THEOREM_RESTRICTED_DICHOTOMY.md`
  §§3–4, equation (4.4).
* **Exit tokens:** `RESTRICTED-DICHOTOMY-PROVED`,
  `RESTRICTED-CLEAN-CM-NORM-PROVED`.
* **Status:** MAIN-PROVED (merged via PR #18, commit `263dd8d`).  Accepted
  inputs it rests on are listed in that packet's `SOURCES.md`.
* **Used as:** constraint (d) of the sieve, in the valuation form of Theorem
  4.1 of `THEOREM_COMBINED_SIEVE.md`.

### A5. Refined-Bézout capacity for base components

* **Statement:** \(\sum_{\operatorname{codim}Z=c}\operatorname{mult}_Z\deg Z\le d^c\)
  for the effective Vogel cycles of a primitive degree-\(d\) tuple on
  \(\mathbf P^4\).
* **Original packet:**
  `problems/E-klein-cubic/goal_runs_20260810/RT_SPLIT_AND_DICHOTOMY/DEGREE_ACCOUNTING.md`
  §1, equation (1.1); verifier `verify_degree_accounting.py`.
* **Exit token:** `SUPPORT-ESCAPE-UNDECIDED` (the packet's own exit; (1.1) is
  its established input, and the packet's finding is that **no** orbit-size
  cell dies for \(d\ge31\)).
* **Status:** MAIN-PROVED.
* **Used as:** the bound \(3k\le d^2\) on the removed divisor (Lemma 2.4).
  Non-binding in the window.

### A6. Removed-divisor / invariant-degree splitting  *(new, sealed here)*

* **Statement:** \(d=d'+k\) where the removed divisor is \(G\)-invariant of
  class \(kH\); \(\dim H^0(X,\mathcal O_X(k))^G\ge1\) exactly for
  \(k\in\{0\}\cup\{5,6,7,\ldots\}\); hence
  \(d'\in\{2,\ldots,d-5\}\cup\{d\}\) in the all-ambient branch.
* **Derivation:** `THEOREM_COMBINED_SIEVE.md` Lemmas 2.2–2.3.  One-page
  character computation (Molien series of \(W\) from the
  \(\operatorname{PSL}_2(\mathbf F_{11})\) character table).
* **Exit token:** `COMMON-FACTOR-INVARIANT-DEGREE-SET-PROVED`.
* **Independent confirmation:** the same character data reproduces the
  covariant dimensions \(32,41,49,59,73,86,100\) at \(d=15..21\) of A1's packet,
  which were computed there by a completely different route (Reynolds
  averaging mod \(67\)).  Asserted in `verify_combined_sieve.py`.
* **Used as:** constraint (b).

### A7. Excess-intersection degree identity  *(new, sealed here)*

* **Statement:** \(3\delta=3d'^3-3d'z-e\) with
  \(z=\deg(H\cap s_1(Z,X))\), \(e=\deg s_0(Z,X)\); equivalently
  \(\delta=d'^3-d'\zeta-a\) with \(3\zeta=z\in\mathbf Z_{\ge0}\) and
  \(a\in\mathbf Z_{\ge0}\); with \(z\le3d'^2\) and, when \(\dim Z=1\),
  \(1\le\delta\le d'^3-d'\).
* **Derivation:** `THEOREM_COMBINED_SIEVE.md` §3.  External citation: W.
  Fulton, *Intersection Theory*, 2nd ed., Prop. 4.4 (degree of a rational map
  with base scheme, via \(\int c(L)^n\cap s(Z,X)\)) and §4.3 (top-dimensional
  Segre term is the fundamental cycle).
* **Exit token:** `SELFMAP-EXCESS-DEGREE-IDENTITY-PROVED`.
* **Used as:** constraint (c).  **It contributes an interval and no
  congruence** (Corollary 3.5).

### A8. Nonidentity branch has \(\delta\ge3\)

* **Statement:** a dominant nonidentity \(G\)-equivariant selfmap has
  \(\delta\ge3\).
* **Source:** `problems/E-klein-cubic/goal_runs_20260809/FULL_G_SELFMAP_CLASSIFICATION/STATUS.md`
  ("The accepted degree-one rigidity and degree-two deck arguments then imply
  \(\deg\varphi\ge3\)") and `THEOREM.md` line 242.
* **Exit tokens:** `FULL-G-NONTRIVIAL-RATIONAL-SELFMAPS-EXIST`,
  `FULL-G-SELFMAP-DEGREES-UNBOUNDED`, packet exit
  `FULL-G-SELFMAP-CLASSIFICATION-UNDECIDED`.
* **Status:** MAIN-PROVED for the existence half; the \(\delta\ge3\) half cites
  "accepted" degree-one rigidity and degree-two deck exclusions rather than
  reproving them.
* **Sieve does not depend on it.** In the CLEAN branch \(\delta=2\) is already
  excluded by A4 (2 is inert), and \(\delta=1\) is treated as the separate
  retraction branch.  A8 is recorded because it is the repository's stated
  reason for \(\delta\ge3\); the sieve reaches the same bound from A4 alone.

### A9. Compulsory point links (fixed-stratum census)

* **Statement:** the point-jet modules
  \(M_{m,d}=[\operatorname{Sym}^m(T_yY)^*\otimes\lambda^d\otimes W]^H\) for the
  \(D_{10}\) (66 points), \(D_{12}\) (55), and two \(A_4\) (55+55) orbits, with
  their incidence data \(5/7/3/4/1\).
* **Source:** `problems/E-klein-cubic/certificates/LOCAL_TRANSITION_MODULES.md`
  §4E; markers `POINT_LINKS_MODULE_OK`, `LOCAL_TRANSITION_MODULES_OK`; hash
  seal `certificates/transitions/SEAL.json`; replay
  `certificates/transitions/point_links/verify.py`.
* **Status:** CERTIFIED.
* **Used as:** nothing in the sieve — **this certificate states no numeric
  condition on \(d\)**.  It is cited in §6 of the theorem only as the reason a
  near-base-point-free lower bound on \(\delta\) is implausible.  Its parent
  program is logged `INFRASTRUCTURE-PARTIAL` in `NOTEBOOK.md` with "the machine
  produced no all-degree obstruction".

---

## B. Constraints found and **excluded** (unsealed)

### B1. The mod-330 degree sieve — EXCLUDED

* **Source:** `problems/E-klein-cubic/external_sessions/mathematical-equivariance-query-6a70557e.md`
  §4, "A degree-character sieve from the cyclic strata".  Summarised at
  `NOTEBOOK.md:4725` and `notebook_build/sessions_batch3.md:15,17` as a
  catalogue entry, not an endorsement.
* **Content:** \(D\equiv0\pmod3\Rightarrow p|_{\mathbf P(U_\omega)}=0\);
  \(5\mid D\Rightarrow p\) vanishes at all \(264\) \(C_5\)-points;
  \(D\equiv0\pmod{11}\) or \((D/11)=-1\Rightarrow p\) vanishes at all \(60\)
  \(C_{11}\)-points.
* **Status:** UNSEALED — unedited external transcript, no exit token, no
  verifier, and self-undercut later in the same file.
* **Why excluded, twice over:** (i) unsealed; (ii) **the source itself states
  it is not a degree constraint**, verbatim: *"These congruence statements do
  not by themselves constrain \(D\), because a rational map may be based on
  the corresponding finite orbit.  They do produce a finite residue-class
  sieve, modulo \(2\cdot3\cdot5\cdot11=330\), describing exactly which
  additional lines and point orbits must enter the base scheme in each degree
  class."*  It is base-locus bookkeeping, not an obstruction.  Sealing it would
  not change any row of the survivor table.

### B2. Parity and vanishing-order constraints on \(d\) — EXCLUDED

* **Source:** same transcript, §2: \(m\) odd; \(D\) even \(\Rightarrow
  p|_{L_t^{\rm src}}=0\); for \(D\) odd, \(D\ge6m+1\) with \(e=D-6m\) odd.
* **Status:** UNSEALED.  The geometric input it sits on
  (\(F|_{E_-}\equiv0\), plus-plane order \(m\)) **is** certified in
  `certificates/LOCAL_TRANSITION_MODULES.md` §4A, but that certificate states
  no \(D\)-parity consequence.
* **Why excluded:** unsealed, and the conclusion is a lower bound involving the
  free parameter \(m\), so it cannot kill any degree.

### B3. \(V_4\)-line order bound — EXCLUDED

* **Source (original):** same transcript, §3:
  \(\operatorname{ord}_R(p)\ge\lceil3m/2\rceil=(3m+1)/2\), \(D\ge(3m+1)/2\).
* **Independent in-repo re-derivation:** `problems/E-klein-cubic/theory/FIX_II_jets.md`
  Lemma 2.1 (and Lemma 2.2 for the \((3m+3)/2\) type-II delay).
* **Status:** UNSEALED — `theory/FIX_I_bcomplex.md` still carries
  `Status: DRAFT-FOR-DERIVATION`, although `NOTEBOOK.md` records the T1–T5 gate
  as closed on 2026-08-04 and the note as "cleared for headline-facing work".
* **Why excluded:** it is a **lower** bound on \(d\) in terms of an unknown
  \(m\); a lower bound cannot remove degrees from the live window.

### B4. F55 parity/coefficient constraints — NOT APPLICABLE

Every `F55*` document was inspected.  "F55" there denotes the order-55
Frobenius subgroup \(C_{11}\rtimes C_5\) in a different route (the trace-cubic
twist \(\Phi(a)=\operatorname{Tr}_{E/K}(r_2^{-1}a^2\sigma(a))\)); its parity and
coefficient statements concern Laurent-monomial supports, not the landing-map
coordinate degree.  **No degree-\(d\) consequence is stated in any F55 packet**,
so none enters the ledger.

---

## C. Summary

* Constraints available: **13** rows examined; **9** in §A, of which
  **7** carry usable content (A1–A7) and 2 are recorded without sieve effect
  (A8 restates a bound the sieve derives from A4; A9 states no numeric
  condition).
* Constraints excluded as unsealed or inapplicable: **4** (B1–B4).
* New constraints derived and sealed in this packet: **2** (A6, A7), plus the
  valuation form of A4 (Theorem 4.1).
* **No sealed constraint anywhere in the repository bounds \(\delta\) from
  below beyond \(\delta\ge3\).**  That is the whole reason the sieve produces a
  table rather than a closure.
