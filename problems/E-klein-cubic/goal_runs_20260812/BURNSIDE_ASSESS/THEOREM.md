# BURNSIDE_ASSESS — equivariant Burnside groups against Problem E

**Packet:** `goal_runs_20260812/BURNSIDE_ASSESS/` · opened 2026-08-12.

**Headline: Problem E remains OPEN; this packet excludes no degree.**

*(Filename note: main document is `THEOREM.md`; the harness refuses `REPORT.md`.)*

This is a literature-and-ledger assessment of the equivariant Burnside group of Kresch–Tschinkel, and of the related Hassett / Kontsevich / Tschinkel / Pirutka specialization and equivariant-birational toolkit. It is not a morphism derivation.

## Exit ledger

```text
BURNSIDE-ASSESS-SCOPE-BIRATIONAL-NOT-DOMINANT
BURNSIDE-ASSESS-DIMENSION-MISMATCH
BURNSIDE-ASSESS-X-SYMBOLS-ASSEMBLED
BURNSIDE-ASSESS-ASSUMPTION2-GAPS-FLAGGED
BURNSIDE-ASSESS-AMITSUR-AND-A-VANISH
BURNSIDE-ASSESS-SPECIALIZATION-NO-FAMILY
BURNSIDE-ASSESS-CTZ-LISTS-THIS-ACTION-OPEN
BURNSIDE-ASSESS-PRIOR-E44-CONSISTENT
BURNSIDE-ASSESS-ORTHOGONAL-NO-NEW-OBSTRUCTION
BURNSIDE-ASSESS-NO-DEGREE-EXCLUSION
```

Machine markers: `ASSEMBLE_BURNSIDE_OK` / `BURNSIDE_ASSESS_VERIFY_OK` / `ALLGREEN`
(61 checks, 0 failures, 0 skips; groups A=13, B=27, C=8, D=9, E=4).
`python3` standard library only. No gap, gp, sage, magma, M2, or msolve.

---

## 0. What is and is not claimed

**Claimed.** (i) The Burnside class is a \(G\)-birational invariant and has no
proved variance under a dominant non-birational \(G\)-map. (ii) The
unirationality-side necessary conditions that *do* have dominance variance
(Condition (A), Amitsur, universal-torsor lift) all vanish for this action.
(iii) An explicit symbol list for the current model of \(X\), assembled from
the sealed receiver ledger, and a citation of the sealed FIX-B list for
\(\mathbf P(W)\). (iv) Verdict: the machinery supplies **no new obstruction**
to Problem E.

**Not claimed.** See §8. In particular: the fully reduced class
\([X\mathrel{\circlearrowleft} G]\) in \(\mathrm{Burn}_3(G)\) after
divisorialification is not computed; no degree is excluded; E44 is not reopened.

---

## 1. The question, pinned

Work over \(\mathbf C\). \(G=\mathrm{PSL}_2(\mathbf F_{11})\), \(|G|=660\).
\(W\) is the faithful irreducible 5-dimensional Klein representation.
\(X=\{F=0\}\subset\mathbf P(W)=\mathbf P^4\) is the Klein cubic, with
\(F=\sum_{i\in\mathbf Z/5}x_i^2 x_{i+1}\) and \(\mathrm{Aut}(X)=G\).

**Problem E** (SPEC): existence of a finite-dimensional \(G\)-representation
\(U\) and a **dominant** \(G\)-equivariant rational map \(U\dashrightarrow X\).
Equivalently: \(X\) is \(G\)-unirational; equivalently \(\mathrm{ed}_{\mathbf C}(G)=3\).

Reserved language, used as in SPEC:

| word | meaning |
|---|---|
| \(G\)-linearizable | \(X\) is \(G\)-**birational** to \(\mathbf P(V)\) |
| \(G\)-unirational | there is a **dominant** \(G\)-map \(\mathbf P(V)\dashrightarrow X\) |
| Condition (A) | \(X^H\neq\varnothing\) for every abelian \(H\le G\) |

Linearizability is false (superrigidity). Ordinary unirationality of \(X\) is
true and irrelevant. The campaign's complex-of-groups / b-complex program
attacks the **dominance** question, with degree as a parameter.

---

## 2. What the invariants obstruct — and what they do not

### 2.1 The equivariant Burnside group `[T1]` read

Source: Kresch–Tschinkel, *Equivariant birational types and Burnside volume*,
arXiv:2007.12538 (2020), Definitions 4.1–4.4 and Theorem 5.1 (read on ar5iv).

After equivariant blow-ups one may assume all stabilizers are abelian
(Bergh / Bergh–Rydh divisorialification). To each \(N_G(H)\)-orbit \(Y\) of
components with generic abelian stabilizer \(H\) one attaches a symbol
\[
\bigl(H,\; N_G(H)/H \mathrel{\circlearrowleft} k(Y),\; \beta_Y\bigr),
\]
where \(\beta_Y\) is the generic normal representation of \(H\) (a sequence of
characters, no invariants, generating \(H^\vee\)). The class
\([X\mathrel{\circlearrowleft} G]\) is the sum of these symbols, in the
quotient \(\mathrm{Burn}_n(G)\) by conjugation and the blow-up relations (B1),
(B2).

**Theorem 5.1 of loc. cit.** If \(X\) and \(X'\) are smooth projective of
dimension \(n\), with generically free \(G\)-actions, and are
\(G\)-**birational**, then
\([X\mathrel{\circlearrowleft} G]=[X'\mathrel{\circlearrowleft} G]\) in
\(\mathrm{Burn}_n(G)\).

That is the only variance theorem. The same paper constructs an equivariant
**specialization** map \(\rho^G_\pi:\mathrm{Burn}_{n,K}(G)\to\mathrm{Burn}_{n,k}(G)\)
for a DVR, and concludes: if the generic fibres of two smooth projective
\(G\)-families are \(G\)-birational, then the special fibres are
\(G\)-birational (Corollary 6.8). Again: birationality, not dominance.

The 2021 rewrite (Kresch–Tschinkel, *Equivariant Burnside groups and
representation theory*, arXiv:2108.00518) gives an equivalent presentation
with centralizers, a restriction / induction / product formalism, a
computation of \([\mathbf P(V)\mathrel{\circlearrowleft} G]\) via De
Concini–Procesi models, and the incompressible-divisor summand. All of this
still compares **birational types**. I read §§1–5 and the linear-class
setup; I did not re-run their \(\mathbf P^2/\mathbf P^3\) examples.

### 2.2 What this does obstruct `[T1]`

- \(G\)-birationality of two \(n\)-folds.
- \(G\)-linearizability: a necessary condition is
  \([X]=[\mathbf P(V)]\) in \(\mathrm{Burn}_n(G)\).
- Specialization of \(G\)-birational type along a DVR.
- Distinguishing two linear actions up to Cremona (the 2108.00518 application).

### 2.3 What this does **not** obstruct `[T1]` read + `[T3]` no counter-theorem found

There is **no** theorem of the shape

> a dominant \(G\)-map \(Y\dashrightarrow X\) of degree \(d\ge 1\) forces a
> relation between \([Y]\) and \([X]\) in a Burnside group.

In particular there is no pullback, no pushforward, no summand statement, and
no degree-weighted identity. Kresch–Tschinkel 2105.02929 (*structure and
operations*; cited from 2108.00518 §3, not re-read in full) supplies
restriction, induction, products, and a **fibration** operation for a
\(G\)-equivariant fibration of a single \(G\)-variety. A dominant map
\(\mathbf P(U)\dashrightarrow X\) is not that.

Consequence for Problem E, which asks for a dominant map **into** \(X\) from
a linear source, of unspecified degree:

- \([X]\neq[\mathbf P(U)]\) is exactly the already-known failure of
  linearizability. It is silent on a degree-\(>1\) map.
- \([X]\) lives in \(\mathrm{Burn}_3(G)\) and \([\mathbf P(W)]\) lives in
  \(\mathrm{Burn}_4(G)\). Comparing them is a type error.
- Even in the essential-dimension-3 window, where a source \(\mathbf P(U)\)
  would be a 3-fold and the two classes would live in the same group,
  equality is birationality, already excluded.

The campaign's own b-complex (`theory/FIX_I_bcomplex.md`, DRAFT) was written
precisely to keep the blow-up calculus **and** a pushforward under dominant
maps. Burnside is the quotient of that calculus by the relations that kill
map-level information. `[T2]` this reading of FIX I matches 2007.12538 Thm 5.1.

### 2.4 The 2025–26 unirationality papers use a different toolkit `[T1]` read

Once the question is changed from birationality to dominance, the literature
switches invariants.

- **Condition (A).** Necessary for \(G\)-unirationality, because abelian
  groups have fixed points on every linear space (Kresch–Tschinkel
  arXiv:2506.07152, §1; Cheltsov–Tschinkel–Zhang arXiv:2502.19598, §2).
  Read both.
- **Amitsur \(\mathrm{Am}^j(X,H)\), \(j=2,3\).** Necessary: a dominant
  \(G\)-morphism \(Y\to X\) forces \(\mathrm{Am}^j(X,H)\subseteq\mathrm{Am}^j(Y,H)\),
  and linear sources have vanishing Amitsur (Tschinkel–Zhang
  arXiv:2504.10204, Proposition 1, read; 2506.07152, (2.1) and Proposition 2.1).
- **Universal-torsor class \(\partial(1_{\mathrm{Pic}})\).** Necessary for
  \(G\)-unirationality of a *rational* \(G\)-variety (2506.07152, Proposition 5.1,
  read). \(X\) is **not rational** (Clemens–Griffiths), so this theorem does
  not apply verbatim; the underlying Amitsur vanishing still does, because
  \(\mathcal O_X(1)\) is honestly linearized.
- **None of these papers uses inequality of Burnside classes as a
  unirationality obstruction.** CTZ Theorem 5.1 (read) lists the Klein cubic
  with \(G=\mathsf{PSL}_2(\mathbf F_{11})\) and with \(C_{11}\rtimes C_5\) as
  **explicit open exceptions** to their \(G\)-unirationality theorem for
  smooth cubics satisfying (A). If Burnside gave a dominance obstruction,
  that list would not be open.

### 2.5 Specialization (Kontsevich, Hassett, Pirutka, Tschinkel) `[T1]` / `[EXT]`

| paper | what I did | what it does |
|---|---|---|
| Kontsevich–Tschinkel, *Specialization of birational types*, arXiv:1708.05699, Invent. Math. 2019 | abstract + citations in 2007.12538 | non-equivariant specialization of birational type |
| Kontsevich–Pestun–Tschinkel, *Equivariant birational geometry and modular symbols*, arXiv:1902.09894 | title / abstract | abelian Burnside / modular symbols; birational |
| Kresch–Tschinkel 2007.12538 §6 | read | equivariant Burnside volume; specializes **birationality** |
| Hassett–Kresch–Tschinkel, *Symbols and equivariant birational geometry in small dimensions* (2020) | title + secondary cites | survey of the same symbols |
| Hassett–Pirutka–Tschinkel degeneration papers | **not read in full**; role inferred from 2007.12538's introduction and the standard HPT story | specialize **stable rationality** (non-equivariant) |

Specialization of birational type cannot obstruct a dominant map. The
equivariant HPT analogue would at best recover failure of stable
linearizability, already known. There is also no family: the Klein cubic is
the unique smooth cubic with this automorphism group (Wei–Yu, used as
`[EXT]` by CTZ). Nothing to specialize.

---

## 3. The vanishing necessary conditions, for *this* action

All of these were already on the campaign books (RESOLUTION.md ll. 3417–3435,
DELTA1, E44). Re-stated with sources and honesty.

**Condition (A).** Sealed in `RECEIVER_LEDGER_X`: every abelian class
\(C_2,C_3,V_4,C_5,C_6,C_{11}\) has nonempty fixed locus on \(X\). `[T2]`
re-read of `results/ledger_exact.json`.

**\(\mathrm{Am}^2(X,H)=\mathrm{Am}^3(X,H)=0\) for all \(H\le G\).** Lefschetz
gives \(\mathrm{Pic}(X)=\mathbf Z\cdot\mathcal O(1)\). The hyperplane is
linearized by \(W\), so \(\delta_2=0\). \(G\) (and every subgroup we care
about, after restriction) acts trivially on that \(\mathbf Z\), and
\(\mathrm{H}^1(H,\mathbf Z)=\mathrm{Hom}(H,\mathbf Z)=0\), so \(\delta_3=0\).
`[T1]` from the Leray sequence as written in 2504.10204 (2.1), plus the
sealed Picard rank. Same argument on \(\mathbf P(W)\).

**No \(Q_8\) to feed the TZ examples.** The Sylow 2-subgroup is \(V_4\),
order 4. Tschinkel–Zhang 2504.10204 produce nontrivial \(\mathrm{Am}^3\)
from \(Q_8\)-actions on del Pezzo surfaces of degree 2 and on Kummer double
solids. That mechanism is unavailable. `[T1]` read of TZ Theorems 4–5 plus
the sealed Sylow.

**Bogomolov multiplier \(\mathrm{B}_0(G)=0\), inferred.** Schur multiplier of
\(\mathrm{PSL}_2(\mathbf F_{11})\) is \(C_2\), realized by
\(\mathrm{SL}_2\to\mathrm{PSL}_2\); restriction to \(V_4\) is the quaternion
extension, so the restriction \(\mathrm{H}^2(G,\mathbf C^\times)\to\mathrm{H}^2(V_4,\mathbf C^\times)\)
is injective. `[EXT]`, not recomputed. Used only as a consistency check:
Condition (A) already forces \(\mathrm{Am}^j\subseteq\mathrm{B}^j\), and both
sides vanish.

**Universal torsor.** For a *rational* variety with linearized Picard rank
one, \(\partial(1_{\mathrm{Pic}})=\mathrm{Am}^2=0\). \(X\) is not rational, so
2506.07152 Theorem 6.1 (sufficiency for toric actions) is off-scope. The
necessary vanishing that does not use rationality is the Amitsur vanishing
above.

---

## 4. Symbols that the theory attaches

Notation: a symbol is written
\((H;\; W(H,Y)\mathrel{\circlearrowleft} k(Y);\; \beta)\), with
\(\dim Y+\lvert\beta\rvert=n\). Character residues are with respect to a
fixed generator of a cyclic group. The list for \(X\) is the **naive class
on the current model**. Two strata fail Assumption 2 of 2007.12538 on this
model (the \(\mathrm{Pic}^G\to H^\vee\) map is not surjective). The actual
class in \(\mathrm{Burn}_3(G)\) is the class of a divisorialification, which
adds exceptional symbols and is **not computed**. Flagged, not papered over.

### 4.1 \(X\), dimension 3, all stabilizers abelian `[T1]`/`[T2]`

Sealed fact (RECEIVER_LEDGER_X §2): \(X^H=\varnothing\) for every nonabelian
class. So the abelian-stabilizer half of Assumption 2 holds without blow-ups.
Orbit types on \(X\): type-I \(V_4\) (165), type-II \(V_4\) (165), \(C_6\)
(110), exact-\(C_3\) (220), two \(C_5\)-orbits (132+132), \(C_{11}\) (60).

| id | \(H\) | \(\dim Y\) | residual | \(k(Y)\) | \(\beta\) | \(\mathrm{Pic}^G\)-pairing | Ass. 2? |
|---|---|---:|---|---|---|---|---|
| X.1 | \(1\) | 3 | \(G\) on \(k(X)\) | Klein function field | \(\varnothing\) | triv | yes |
| X.C2.E | \(C_2\) | 1 | \(S_3\) on \(E_\sigma\) | \(j=8192/11\), non-CM | \((\mathrm{sgn},\mathrm{sgn})\) | triv | **no** |
| X.C2.L | \(C_2\) | 1 | \(S_3\) on \(\mathbf P^1\) | \(k(\mathbf P^1)\) | \((\mathrm{sgn},\mathrm{sgn})\) | \(\mathrm{sgn}\) | yes |
| X.C3 | \(C_3\) | 0 | \(V_4\) free on 4 pts | \(k^4\) | \(\{1,1,2\}\) | \(\omega\) or \(\omega^2\), fused | yes |
| X.V4.I | \(V_4\) | 0 | \(C_3\) free on 3 pts | \(k^3\) | \(\chi_1+\chi_2+\chi_3\) | \(\chi_i\) | yes |
| X.V4.II | \(V_4\) | 0 | \(C_3\) free on 3 pts | \(k^3\) | \(\chi_1+\chi_2+\chi_3\) | triv | **no** |
| X.C5.a | \(C_5\) | 0 | \(C_2\) on \(\{\chi,\chi^4\}\) | \(k\times k\) | \(\{1,2,3\}\) | generator | yes |
| X.C5.b | \(C_5\) | 0 | \(C_2\) on \(\{\chi^2,\chi^3\}\) | \(k\times k\) | \(\{1,2,4\}\) | generator | yes |
| X.C6 | \(C_6\) | 0 | \(C_2\) on \(\{\chi^1,\chi^5\}\) | \(k\times k\) | \(\{1,3,4\}\) | generator | yes |
| X.C11 | \(C_{11}\) | 0 | \(C_5\), one 5-cycle | \(k^5\) | \(\{2,3,4\}\) mod 11 | QR character | yes |

Every row has \(\dim Y+\lvert\beta\rvert=3\). Derivations, all from the sealed
character decompositions of \(W\) plus Euler + \(G\)-invariance of \(F\):

- **\(C_2\).** \(W=W^+\oplus W^-\) with \(\dim 3+2\). On \(E=X\cap\mathbf P(W^+)\)
  the two extra directions are the sign representation; \(dF\) cuts the
  residual plus-direction (smooth plane cubic). On \(L=\mathbf P(W^-)\subset X\)
  the three plus-directions are sign and \(dF\) cuts one of them. Same
  \(\beta\), different function fields, different pairings. `[T1]`
- **\(C_3\).** \(W=\mathbf 1\oplus 2\omega\oplus 2\omega^2\). An exact-\(C_3\)
  point on the \(\omega\)-line has \(T_p\mathbf P^4=\mathbf 1\oplus 2\omega\oplus\omega^2\);
  \(dF\) is the trivial covector (binary cubic étale), so
  \(\beta=\{1,1,2\}\). Residual \(C_2\) swaps the two eigenlines. `[T1]`
- **\(V_4\).** \(W=\mathbf 1^2\oplus\chi_1\oplus\chi_2\oplus\chi_3\). At a
  character point, \(T_p X\cong\chi_i\oplus\chi_j\oplus\chi_k\). At a type-II
  point of \(\ell_V\), \(dF\) cuts \(T\ell_V\) and again
  \(\beta=\chi_1+\chi_2+\chi_3\). The two symbols are distinguished by the
  \(\mathrm{Pic}^G\)-pairing (2108.00518 Definition 2.3, read). `[T1]`
- **\(C_5\).** Regular representation; trivial eigenpoint off \(X\) (\(F=5\)).
  At character \(\chi^a\), ambient \(\beta=\{1,2,3,4\}\) and \(dF\) removes
  weight \(-a\). Residual \(C_2\) is inversion, so two orbits and two symbols
  \(\{1,2,3\}\) and \(\{1,2,4\}\). The automorphism \(\times 2\) of \(C_5\)
  would identify them but is **not** inner in \(G\). On \(\mathbf P(W)\) these
  two orbits collided (FIX-B Finding 1); on \(X\) they split. `[T2]`
  recomputed in the verifier.
- **\(C_6\).** Characters on \(W\) are \(\{0,1,2,4,5\}\). The two points on
  \(X\) are \(\chi^1,\chi^5\) (\(t\)-eigenvalue \(-1\)). Removing the trivial
  line leaves \(\{1,3,4\}\) and \(\{2,3,5\}\), identified by inversion. `[T2]`
- **\(C_{11}\).** \(T\)-weights \((1,9,4,3,5)\). At \(e_i\), \(dF=dx_{i+1}\)
  (only the monomial \(x_i^2 x_{i+1}\) survives). The five leftover triples
  are the QR-orbit of \(\{2,3,4\}\) in \(\mathbf F_{11}\). `[T2]`

The two Assumption-2 failures (E and type-II) mean the displayed sum is
**not** yet the class in \(\mathrm{Burn}_3(G)\). Divisorialification will
blow up a \(G\)-stable center supported on the type-II / \(V_4\) incidence
and adjoin exceptional symbols. That computation is not done; it cannot
create a dominance obstruction that the unreduced list lacks.

### 4.2 \(\mathbf P(W)\), dimension 4 `[T2]` cite FIX-B

Sealed packet `goal_runs_after_fc5e2d3/FIX_B_BURNSIDE_SYMBOLS/`, exit
`FIX-B-SYMBOLS-PASS`. Twenty \(G\)-orbits of strata, nineteen distinct
symbols, fourteen with abelian generic stabilizer. Collision:
\(C_5/\chi\) and \(C_5/\chi^2\) share \((C_5;\;1\mathrel{\circlearrowleft} k;\;\{1,2,3,4\})\).
Six nonabelian point-orbits (\(S_3\) twice, \(D_{10}\), \(D_{12}\), \(A_4\)
twice) enter only after standard form. Non-removable core of nine symbols,
of which the plus-plane is unconditionally rigid. This packet does not
re-run that census; the verifier only checks the file is present.

### 4.3 Comparison is the wrong operation

\(\mathrm{Burn}_3(G)\not\cong\mathrm{Burn}_4(G)\). The one comparison that
would be well-typed — \([X]\) against \([\mathbf P(U)]\) for a 4-dimensional
\(U\) — is the linearizability test, already negative.

---

## 5. Verdict

**The equivariant Burnside group, and the Hassett–Kontsevich–Tschinkel–Pirutka
specialization calculus, do not give a new obstruction for Problem E.**

They are not merely unused. They are **orthogonal** to the question as posed:

1. Problem E is dominance. Burnside is a birational-type invariant. The
   implication “classes differ \(\Rightarrow\) no dominant map” is false, and
   no paper in this family claims it. `[T1]`
2. The dominance-capable cousins (Condition (A), Amitsur, torsor lift) vanish.
   CTZ 2502.19598, having used exactly those cousins, leave this action open.
   `[T1]`
3. The input to a Burnside class is a coarsening of the sealed
   stabilizer/normal-weight data that the complex-of-groups program already
   keeps, **plus** relations that forget dominant-map functoriality. Anything
   Burnside can see, the b-complex sees with more variance. `[T1]` from the
   definitions; `[T3]` that no secret extra relation in \(\mathrm{Burn}_n(G)\)
   creates a dominance obstruction (no such relation is stated in the papers
   read).
4. Specialization has no family and the wrong variance.

**Prior campaign state, not contradicted.** E44 is REJECTED (wrong
implication). DELTA1 recorded “Burnside comparison: no retraction-variance
theorem.” FIX-B computed the \(\mathbf P(W)\) shadow and already warned that
it “carries no map-compatibility information.” RESOLUTION.md ll. 3417–3435
says the same of the equivariant diagonal. This packet is the 2025–26
literature pass and the \(X\)-side symbol assembly; it does not reopen E44.

**What would have made the verdict different.** A theorem that a dominant
\(G\)-map induces a relation in \(\mathrm{Burn}_n\), or a nonvanishing of
\(\mathrm{Am}^3(X,H)\) or of \(\partial(1_{\mathrm{Pic}})\) for some \(H\).
Neither exists in the sources read.

---

## 6. Verification

```text
python3 scripts/assemble_symbols.py
python3 verifier.py
```

Assembler writes `results/assembled_symbols.json`. Verifier re-reads the
sealed ledger and FIX-B, rebuilds the \(C_{11}/C_5/C_6\) cuts from the
formulae in §4, checks \(\dim+\lvert\beta\rvert=3\), checks the type error
\(\mathrm{Burn}_3\) vs \(\mathrm{Burn}_4\), and runs the ODDZERO zero/all-dead
audit (no exclusions). Group A is a fatal dependency on the sealed ledger
path.

---

## 7. Flags

1. **Assumption 2 fails on two \(X\)-strata.** The listed \(X\)-class is naive.
2. **FIX I is DRAFT-FOR-DERIVATION.** Used only as a campaign-side reading of
   the same blow-up calculus, not as a theorem.
3. **HPT papers not read in full.** Specialization verdict uses 2007.12538 §6
   (read) and the uniqueness of the Klein cubic (`[EXT]`).
4. **\(\mathrm{B}_0(G)=0\) is `[EXT]`**, not used in the verdict.
5. **No Kresch–Tschinkel relation (B1)/(B2) is applied.** No symbol is set
   to zero. Same honesty constraint as FIX-B.

---

## 8. Not claimed

- Any exclusion of any degree, or of any of the 22 live \(d=35\) cells.
- That \(X\) is or is not \(G\)-unirational.
- The reduced class \([X\mathrel{\circlearrowleft} G]\in\mathrm{Burn}_3(G)\).
- A computation of \([\mathbf P(U)]\) for any \(U\) other than the sealed
  FIX-B list for \(W\).
- A new proof of superrigidity, of Condition (A), or of \(\mathrm{Pic}(X)=\mathbf Z\).
- That Burnside is useless in general; it is the right tool for
  \(G\)-birational classification, which is not Problem E.

---

## 9. Citations, with reading status

**Read (ar5iv HTML, sometimes truncated after §6–8).**

- A. Kresch and Yu. Tschinkel, *Equivariant birational types and Burnside volume*, arXiv:2007.12538 (2020).
- A. Kresch and Yu. Tschinkel, *Equivariant Burnside groups and representation theory*, arXiv:2108.00518 (2021).
- A. Kresch and Yu. Tschinkel, *Equivariant unirationality of toric varieties*, arXiv:2506.07152 (2025).
- I. Cheltsov, Yu. Tschinkel, Zh. Zhang, *Equivariant unirationality of Fano threefolds*, arXiv:2502.19598 (2025).
- Yu. Tschinkel and Zh. Zhang, *Cohomological obstructions to equivariant unirationality*, arXiv:2504.10204 (2025).

**Title / abstract / secondary citation only.**

- A. Kresch and Yu. Tschinkel, *Equivariant Burnside groups: structure and operations*, arXiv:2105.02929 (2021).
- A. Kresch and Yu. Tschinkel, *Equivariant Burnside groups and toric varieties*, arXiv:2112.05123 (2021).
- M. Kontsevich and Yu. Tschinkel, *Specialization of birational types*, arXiv:1708.05699, Invent. Math. 217 (2019).
- M. Kontsevich, V. Pestun, Yu. Tschinkel, *Equivariant birational geometry and modular symbols*, arXiv:1902.09894.
- B. Hassett, A. Kresch, Yu. Tschinkel, *Symbols and equivariant birational geometry in small dimensions*, in *Rationality of Varieties*, Progr. Math. 342 (2020).
- A. Kresch and Yu. Tschinkel, *Invariants in equivariant birational geometry*, arXiv:2602.23998 (2026).
- A. Kresch and Yu. Tschinkel, *Linearizability notions in equivariant birational geometry*, arXiv:2606.10965 (2026).
- F. Scavia, Yu. Tschinkel, Zh. Zhang, *Birational invariance of higher Amitsur groups*, arXiv:2605.02763 (2026).
- A. Pirutka and Zh. Zhang, *Computing the equivariant Brauer group*, arXiv:2410.05072 (2024).

**Sealed campaign artefacts consumed by citation, not re-proved.**

- `SPEC.md` (Problem E).
- `goal_runs_20260810/RECEIVER_LEDGER_X/` (fixed loci, characters, \(j(E_\sigma)\)).
- `goal_runs_after_fc5e2d3/FIX_B_BURNSIDE_SYMBOLS/` (\(\mathbf P(W)\) symbols).
- `goal_runs_20260808/DELTA1_EQUIVARIANT_DIAGONAL_OBSTRUCTION_AUDIT/` (no retraction variance).
- `RESOLUTION.md` ll. 3417–3435 (E44 / Amitsur / diagonal).
- `theory/FIX_I_bcomplex.md` (draft; b-complex vs Burnside shadow).

---

## 10. Honesty tiering

| tier | content |
|---|---|
| `[T1]` | variance of \(\mathrm{Burn}_n\) is birational only (2007.12538 Thm 5.1); CTZ open list; Amitsur vanishing from linearized \(\mathcal O(1)\); \(C_2/C_3/V_4\) normal-weight deductions; no dominance functoriality in the papers read |
| `[T2]` | ledger re-read; \(C_5/C_6/C_{11}\) cuts; FIX-B file present; \(\dim+\lvert\beta\rvert=3\); zero/all-dead |
| `[T3]` | no hidden Burnside relation creates a dominance obstruction (absence of a theorem, not a proof that none exists); HPT role inferred |
| `[EXT]` | uniqueness of the Klein cubic; \(\mathrm{B}_0(G)=0\); Clemens–Griffiths; superrigidity |

Downstream edits this packet implies (for the director, **not** made here):
none. E44 stays REJECTED. The b-complex remains the map-level object.
