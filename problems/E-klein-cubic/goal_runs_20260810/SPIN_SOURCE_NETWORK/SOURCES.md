# Sources

## In-repo, load-bearing (cited, not recomputed)

| source | what is taken from it |
|---|---|
| `problems/E-klein-cubic/theory/FIX_IX_v14.md` §6 | the spin flank: `sigma`-lift of order 4, `C_SL(sigmatilde) = C_12`, the `D_12`-reflections swap the eigenplanes, the "expected quaternionic" prediction for `U|_{Q_8}` (now proved) |
| same, §7 | Lemma IX.3 (folding), Prop IX.4 (transport lattice), **Cor IX.5** (killing spin sources on the `V14` ⟹ `ed_C(PSL_2(F_11)) = 4`), **Cor IX.6** (the `D_12`-level spin escape is realised, so any proof must use more than one involution's centralizer) |
| same, §5 | Cor IX.1 and its carrier induction, which Thm 4.1 here reproduces with `C_G(sigma)` replaced by the index-two `N_0` |
| same, §8 | odd-order transfer; the `F_55` first cut, contrasted here with `dim U^{C_11} = 1` |
| `problems/E-klein-cubic/theory/FIX_T_gate.md` Cor T3.1, Lem T2.1, Lem T2.2 | the central obstruction the spin engine generalises; the **scalar-birth lemma** whose absence on spin sources is Thm 6.1 |
| `problems/E-klein-cubic/theory/FIX_I_bcomplex.md` | Prop 3.3 (equivariant resolution), Lem 4.2 (going-down), Lem 4.3 (RCC of projective subbundles), Obs 4.0 |
| `problems/E-klein-cubic/goal_runs_after_c53d89a/FIX_IX_SEAL/` | exit **`FIX-IX-SEAL-PASS`**: `V14^sigma` = smooth irreducible genus-1 sextic ⊔ 2 reduced points (char-0 smoothness DISCHARGED, `scripts/m2_sigma_K.m2`, `results/m2_sigma_K.out`); `V14^{D_12} = empty`; `C_G(sigma) = D_12`; the two isolated points have stabiliser exactly `C_6` and are swapped by `D_12` |
| same, `scripts/seal.py` | the sealed even-Weil model of `U` (`S^2 = -I`, `c = 1/gauss`), against which the monomial model here is the independent second construction |
| `problems/F-dp2-psl27/certificates/WP3_ALL_DEGREE_PATH_OBSTRUCTION.md` | the chain/parity engine adapted in Part 1 §7: forced endpoint values, the mandatory basepoint, the `V_4`-fixed exceptional path, the tree/path lemma; marker `WP3_ALL_DEGREE_PATH_OBSTRUCTION_OK` |
| `problems/F-dp2-psl27/certificates/WP1_FIXED_LOCI.md`, `wp1_fixed_loci.py` (line 585) | `S^{C_2}` = smooth genus-one curve ⊔ 2 isolated points |
| `problems/F-dp2-psl27/SPEC.md` (lines 62-66) | the scope restriction to **linear** sources — the gap Part 3 addresses |
| `problems/F-dp2-psl27/certificates/WP2_TWIST_OBSTRUCTION_AUDIT.md` (lines 63-65) | in-repo use of Duncan-Reichstein Prop 9.1 for linear `V` |
| `research/equivariant-unirationality-new-applications/EXIT_KLEIN_V22.md`, `CANDIDATE_TABLE.md`, `INDEX1_FANO_THREEFOLDS.md` | read-only; the `V22` normal-chain wall and the index-1 Fano benchmark restating the sealed `V14` facts |

## External literature (checked this session)

* **Tschinkel, Zhang**, *Stable equivariant birationalities of cubic and
  degree 14 Fano threefolds*, arXiv:2409.08392 — Thm 1.1 / Prop 4.1: the
  twisted-stable equivalence whose stable factor is the spin `P(V)` for a
  6-dimensional `SL(2,11)`-irreducible. This is the external source for `U`.
* **Duncan, Reichstein**, *Versality of algebraic group actions and rational
  points on twisted varieties*, arXiv:1109.6093, J. Alg. Geom. 24 (2015)
  499-530 — Thm 10.5; Prop 10.8(a)(b)(c) (the `ed = 3` / `ed = 4`
  disjunction for `PSL(2,11)`); Remark 10.10 (two `G`-birational classes);
  **§9 Prop 9.1**: a finite `G <= PGL_n` on `P^{n-1}` is weakly versal iff
  the extension splits — the reason a spin source carries **no** versality,
  hence no essential-dimension, consequence.
* **Duncan**, *Finite groups of essential dimension 2*, Comment. Math. Helv.
  88 (2013) 555-585, arXiv:0912.1644, Thm 1.1 — `ed_C(PSL(2,7)) = 2`
  (**known**; hence Part 3 yields no new `ed` statement).
* **Beauville**, *Finite simple groups of small essential dimension*,
  arXiv:1101.1372, Prop 16.3 — restates the above.
* **Prokhorov**, *Quasi-simple finite groups of essential dimension 3*,
  arXiv:1703.10780, **Prop 2.6**: `ed_C(SL(2,7)) = 4`; **Lemma 2.6.1**: the
  image `V_4 <= PSL(2,7)` of a `Q_8 <= SL(2,7)` fixes a point on every
  rational `PSL(2,7)`-surface, the degree-2 del Pezzo included. **Citation
  gap flagged:** this paper appears nowhere in `problems/F-dp2-psl27/`. It
  does not contradict anything here (our `P(U)^{V_4} = empty` concerns the
  threefold source `P^3`, not a surface).
* **Cheltsov, Tschinkel, Zhang**, *Equivariant unirationality of Fano
  threefolds*, arXiv:2502.19598, pp. 1-2 — defines `G`-unirationality
  strictly as `P(V) --> X` for `V` a genuine linear `G`-representation.
  Confirms that spin sources are outside the published notion, so the Part 3
  question is open by construction rather than by oversight.
* **Prokhorov**, two-class theorem for rationally connected
  `PSL(2,11)`-threefolds — as cited in `FIX_IX_v14.md` §5 for Cor IX.2.

**Not found externally** (searched): any treatment of dominant equivariant
maps to a del Pezzo surface from a projectively-linear / Severi-Brauer
source; any published statement of "killing spin sources on the `V14` gives
`ed_C(PSL_2(F_11)) = 4`" — that chain is repo-original (Cor IX.5) and marked
open there.

## Toolchain

python3 standard library only. No Macaulay2, msolve, GAP, Sage, Magma or
PARI was used or needed: the permitted envelope (exact character theory and
exact linear algebra in dimension `<= 12`) covers the entire computation,
because the integral model `Ind_B^{SL(2,q)}(chi)` has dimension `q+1 <= 12`
for `q in {7, 11}`.
