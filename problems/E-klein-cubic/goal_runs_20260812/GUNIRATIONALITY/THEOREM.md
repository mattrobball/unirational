# G-unirationality literature against the map \(\mathbf P(W)\dashrightarrow X\)

**Packet:** `goal_runs_20260812/GUNIRATIONALITY/` · opened 2026-08-12.
**Kind:** literature survey (no new mathematics; no degree census).
**Headline: Problem E remains OPEN; this packet excludes no degree.**

*(Filename note: main document is `THEOREM.md`; the harness refuses `REPORT.md`.)*

## Exit ledger

```text
GUNI-SURVEY-ASSEMBLED
GUNI-NONAME-NO-SHRINK
GUNI-ED-INTERVAL-ONLY
GUNI-CTZ51-KLEIN-OPEN
GUNI-NO-LITERATURE-OBSTRUCTION
GUNI-NO-LITERATURE-CONSTRUCTION
GUNI-IMPORT-CTZ-PROP35
GUNI-NO-DEGREE-EXCLUSION
```

Machine markers: `PACKET_VERIFY_OK` / `ALLGREEN`
(`python3 verifier.py` — **58** checks, 0 failures; exact `python3` arithmetic only).

---

## 0. What is and is not claimed

**Claimed.** A citation-exact survey of the existence literature for
\(G\)-equivariant dominant maps from representations, aimed at the
exact map \(\mathbf P(W)\dashrightarrow X\). Three labels are used
throughout:

- **[READ]** — a statement I extracted from a named paper.
- **[HOUSE]** — already a sealed campaign theorem (SPEC / RESOLUTION);
  recorded so this packet does not reopen it.
- **[INFERRED]** — my assembly; not a theorem of any one paper.

**Not claimed.** See §8. In particular: nothing here cuts any of the 22
live \(d=35\) cells, and no degree is excluded.

---

## 1. The exact question, and three nearby properties

Let \(G=\operatorname{PSL}_2(\mathbf F_{11})\) and let \(W\) be the
faithful irreducible five-dimensional complex representation whose
projectivization preserves the Klein cubic
\(X\subset\mathbf P(W)=\mathbf P^4\). The action lifts to an honest
homomorphism \(G\to\operatorname{GL}(W)\). **[HOUSE]** `SPEC.md`.

Problem E asks whether there is a dominant \(G\)-equivariant rational
map from a linear representation to \(X\). A map
\(\mathbf P(W)\dashrightarrow X\) is one such (compose with
\(W\setminus\{0\}\to\mathbf P(W)\)). **[HOUSE]**

The published hierarchy, as used by Cheltsov–Tschinkel–Zhang, is:

| code | name | meaning |
|---|---|---|
| (U) | \(G\)-unirational / very versal | a dominant \(G\)-map \(\mathbf P(V)\dashrightarrow X\) from some representation \(V\) |
| (SL) | stably \(G\)-linearizable | \(X\times\mathbf P^m\sim_G\mathbf P(V)\) with trivial action on the second factor |
| (L) | \(G\)-linearizable / \(G\)-rational in the birational sense | \(X\sim_G\mathbf P(V)\) |

**[READ]** Cheltsov–Tschinkel–Zhang, *Equivariant unirationality of
Fano threefolds*, arXiv:2502.19598 (2025), §1: they write
\((\mathbf L)\Rightarrow(\mathbf{SL})\Rightarrow(\mathbf U)\), and
state that (U) is equivalent to very versality in the sense of
Duncan–Reichstein.

A fourth, older, notion is Saltman's *generic* action: generically
free, versal, *and* \(k(X)^G\) purely transcendental. **[READ]**
Duncan–Reichstein, *Versality of algebraic group actions and rational
points on twisted varieties*, J. Algebraic Geom. 24 (2015), 499–530,
arXiv:1109.6093, Remark 2.8.

These are not interchangeable for our \(X\):

- **(L) fails.** There is no rational complex threefold with a faithful
  \(G\)-action. **[READ]** Prokhorov, *Simple finite subgroups of the
  Cremona group of rank 3*, J. Algebraic Geom. 21 (2012), 563–600,
  Theorem 1.3; recorded as **[HOUSE]** in SPEC §“Birational rigidity
  is not a negative answer”. Failure of (L) does not touch (U).
- **(SL) is strictly stronger than (U).** A proof or disproof of
  stable linearizability is not a proof or disproof of (U).
  **[HOUSE]** RESOLUTION.md on Kresch–Tschinkel.
- **(U) is the headline.** **[HOUSE]**
- **Saltman-generic is stronger still:** it would require
  \(\mathbf C(W)^G\) rational (Noether's problem for this \(G\)).
  Kunyavskiĭ proves \(B_0(G)=0\) for every finite simple group, so the
  unramified Brauer group of \(W/G\) vanishes and does not decide
  Noether. **[READ]** Kunyavskiĭ, *The Bogomolov multiplier of finite
  simple groups*, arXiv:0712.4069 (2007); published 2010,
  Corollary 1.2.

---

## 2. Existence of equivariant dominant maps from representations

### 2.1 The no-name lemma, and when it reduces the source

**Statement. [READ]** Domokos, *Covariants and the no-name lemma*,
J. Lie Theory 18 (2008), 839–858, arXiv:0803.1327, Introduction and
Theorem 2.3 (char. 0, \(G\) finite): if \(G\) acts generically freely
on an irreducible variety \(Y\) and \(E\to Y\) is a \(G\)-vector
bundle of rank \(r\), then \(E\) is \(G\)-birational to
\(Y\times\mathbf A^r\) with *trivial* action on the second factor.
Equivalently, \(k(Y\times V)^G\) is purely transcendental over
\(k(Y)^G\) for any \(G\)-module \(V\). The same lemma, for a
generically free action, is Reichstein, *On the notion of essential
dimension for algebraic groups*, Transform. Groups 5 (2000), 265–304,
Lemma 2.18 (the “usual form”).

**What it does.** It *adds* a linear factor with trivial action. It
lets one replace a \(G\)-vector bundle over a generically free base
by a product. Duncan's consequence: if \(X\) is \(G\)-unirational at
all, then for *every* faithful representation \(V\) there is a
dominant \(G\)-map \(V\times\mathbf A^n\dashrightarrow X\).
**[READ]** Duncan, *Equivariant unirationality of del Pezzo surfaces
of degree 3 and 4*, Eur. J. Math. 2 (2016), 897–916,
arXiv:1410.8434, Proposition 2.7.

**What it does not do.** It does not produce a dominant map from a
*smaller* representation. The complex irreps of \(G\) have dimensions
\(1,5,5,10,10,11,12,12\); the smallest faithful one is \(\dim W=5\).
**[INFERRED]** from the ATLAS character degrees, checked only by the
sum-of-squares identity \(1+2\cdot25+2\cdot100+121+2\cdot144=660=|G|\)
in `scripts/produce.py`. So no-name cannot replace \(\mathbf P(W)\) by
a linear \(\mathbf P^3\) or \(\mathbf P^2\). The campaign's source
\(\mathbf P(W)\) is already the smallest honest linear projective
source.

**Campaign status.** The phrase “no-name lemma” occurs in the
campaign only to say it was *not* used. **[HOUSE]**
`goal_runs_20260808/SCHUR_QUARTIC_MODULI/THEOREM.md`.

### 2.2 Essential dimension of \(G\), and what it bounds

**Definition. [READ]** Buhler–Reichstein, *On the essential dimension
of a finite group*, Compositio Math. 106 (1997), 159–179: \(\operatorname{ed}(G)\)
is the minimal dimension of a compression of a faithful representation
(equivalently, of a faithful \(G\)-unirational variety). Merkurjev's
survey, *Essential dimension*, extended version of the 2010 ICM
address (online update), Proposition 3.14: a versal incompressible
\(G\)-scheme \(Z\) is unirational of dimension \(\operatorname{ed}(G)\)
(here \(\dim G=0\)).

**The interval. [READ]** Duncan–Reichstein 2015, proof of
Proposition 10.8: \(3\le\operatorname{ed}(G)\le4\). Upper bound: the
projection \(\mathbf C^5\setminus\{0\}\to\mathbf P^4\) is a
generically free very versal \(G\)-map. Lower bound: \(G\) admits no
faithful action on a unirational surface (Prokhorov; Duncan's
classification of groups of essential dimension 2). Same statement:
Merkurjev survey, Theorem 3.25; Beauville, *Finite simple groups of
essential dimension 3*, Comment. Math. Helv. / arXiv:1101.1372 (2011);
Dolgachev, *The essential and Cremona dimensions of a group*,
arXiv:2507.15096 (v3, 2026), §7.

**Does \(\operatorname{ed}(G)\) bound our question?** Only through
the already-sealed equivalence
\[
X\text{ is }G\text{-unirational}
\quad\Longleftrightarrow\quad
\operatorname{ed}_{\mathbf C}(G)=3.
\]
**[HOUSE]** RESOLUTION.md “Exact reduction to essential dimension”.
A proof that \(\operatorname{ed}(G)=4\) would kill every map
\(\mathbf P(W)\dashrightarrow X\); a proof that \(\operatorname{ed}(G)=3\)
would produce one. Neither value is known. **[READ]** Merkurjev,
Theorem 3.25, still in the 2010s-updated survey; Dolgachev 2026 still
lists \(L_2(11)\) as the remaining simple group of possible
essential dimension 3.

Prime-local essential dimension cannot force the value 4: for a
\(p\)-group, \(\operatorname{ed}(G,p)\) equals the minimal dimension
of a faithful representation (Karpenko–Merkurjev), and the Sylows of
\(G\) are small. **[HOUSE]** SPEC: the prime-local numbers are
\(2,1,1,1\) at \(2,3,5,11\).

Reichstein–Youssin, *Essential dimensions of algebraic groups and a
resolution theorem for \(G\)-varieties*, Canad. J. Math. 52 (2000),
1018–1056, supply the going-down theorem used to turn abelian fixed
points into a versality obstruction. That obstruction *vanishes*
here: every abelian subgroup of \(G\) fixes a point of \(X\).
**[HOUSE]** SPEC, Condition (A); **[READ]** Duncan–Reichstein,
Remark 2.7 and Corollary 10.6.

### 2.3 Versality and \(G\)-torsors over the function field of \(X\)

**Dictionary. [READ]** Duncan–Reichstein 2015, Theorem 1.1:

- weakly versal \(\Leftrightarrow\) every twist \({}^TX\) has a
  \(K\)-point;
- versal \(\Leftrightarrow\) \(K\)-points are dense on every twist;
- very versal \(\Leftrightarrow\) every twist is \(K\)-unirational.

For a smooth cubic hypersurface in \(\mathbf P(V)\) with
\(\dim V\ge4\), these three coincide. **[READ]** Duncan–Reichstein,
Theorem 10.5. Kollár, *Unirationality of cubic hypersurfaces*,
J. Eur. Math. Soc. 4 (2002), 237–245, upgrades a \(K\)-point to
\(K\)-unirationality.

So the headline is equivalent to: *every* \(G\)-torsor \(T/K\) makes
the twisted Klein cubic \({}^TX\) have a \(K\)-point. One generic
torsor is enough, by simplicity of \(G\): a point of the generic
twist of \(X\) over \(\mathbf C(\mathbf P(W))^G\) *is* a dominant
\(G\)-map \(W\dashrightarrow X\), and the image must be all of \(X\).
**[HOUSE]** SPEC §“Exact equivalent formulations”.

Serre's original language (letter reprinted as the appendix to
Duncan–Reichstein 2015; also Serre, *Cohomological invariants, Witt
invariants, and trace forms*, in *Cohomological invariants in Galois
cohomology*, AMS 2003): a \(G\)-torsor \(P\to S\) is versal if every
\(G\)-torsor over an infinite field is a pullback of \(P\) along a
point of \(S\). If \(X\) is very versal, the generic fibre of a dense
\(G\)-invariant open of \(X\) over its quotient is such a versal
torsor, of transcendence degree 3. That is the content of
\(\operatorname{ed}(G)=3\).

The converse direction — “the structure of \(G\)-torsors over
\(k(X)\) decides (U)” — is exactly this dictionary. It does not, by
itself, produce a point or an empty twist.

---

## 3. Obstruction or construction for this exact map?

**Published existence theorems that fire for other cubics, and fail
here.**

1. *Fixed-point construction.* A \(G\)-fixed point on a cubic implies
   very versality. **[READ]** Duncan–Reichstein, Corollary 10.6;
   Cheltsov–Tschinkel–Zhang, Proposition 3.2. **Fails:** \(W\) is
   irreducible, so \(X^G=\varnothing\). **[HOUSE]**

2. *Index-two descent.* If \(H\subset G\) has index 2 and \(X\) is
   \(H\)-unirational, then \(X\) is \(G\)-unirational. **[READ]**
   Duncan 2016, Theorem 3.2 (cubic surfaces; the same argument is
   Duncan–Reichstein Theorem 10.5 plus quadratic descent for cubics);
   Cheltsov–Tschinkel–Zhang, Proposition 3.3. **Fails:** \(G\) is
   simple, so it has no subgroup of index 2. **[T1]** \(|G|=660\) is
   even, but simplicity is **[READ]** (standard).

3. *Invariant hyperplane section + no-name.* If a \(G\)-invariant
   irreducible hyperplane section \(S\subset X\) is \(G\)-unirational
   (generic stabilizer allowed), the tangent bundle of \(X\) along
   \(S\) plus no-name gives a dominant \(G\)-map to \(X\). **[READ]**
   Cheltsov–Tschinkel–Zhang, Proposition 3.5. **Fails for a
   hyperplane:** \(W\) irreducible \(\Rightarrow\) no \(G\)-invariant
   hyperplane. The same holds for the Borel
   \(H=C_{11}\rtimes C_5\): \(W\) remains \(H\)-irreducible (the five
   quadratic-residue characters of \(C_{11}\), cycled by \(C_5\)).
   **[INFERRED]**

4. *Sylow detection.* If versality on every Sylow implied versality,
   we would be done: every Sylow of \(G\) fixes a point of \(X\),
   hence is very versal on \(X\). **[HOUSE]** That implication is
   Duncan–Reichstein Conjecture 8.8. It is false in general.
   **[READ]** Scavia, *A counterexample to a conjecture of Duncan on
   versal actions*, arXiv:2607.25118 (2026). The counterexample is a
   different group on a degree-2 del Pezzo; it does not decide the
   Klein cubic, but it kills the published shortcut that would have
   given \(\operatorname{ed}(G)=3\).

5. *Cohomological Amitsur / \(\operatorname{Am}^3\).* Nonvanishing
   \(\operatorname{Am}^j(X,H)\) obstructs (U). **[READ]**
   Tschinkel–Zhang, *Cohomological obstructions to equivariant
   unirationality*, arXiv:2504.10204 (2025). Their examples with
   Condition (A) and \(\operatorname{Am}^3\neq0\) are built from
   \(Q_8\). The 2-Sylow of \(G\) has order 4, hence is not \(Q_8\).
   **[T1]** \(|G|=4\cdot3\cdot5\cdot11\). This obstruction does not
   fire. The campaign already recorded vanishing of the ordinary
   Amitsur / universal-torsor obstruction. **[HOUSE]**

6. *Classification of cubic-threefold actions.* **[READ]**
   Cheltsov–Tschinkel–Zhang, Theorem 5.1: a generically free action
   on a smooth cubic threefold satisfying Condition (A) is
   \(G\)-unirational, *with the possible exception of* (among a short
   list) \(G=\operatorname{PSL}_2(\mathbf F_{11})\) and
   \(G=C_{11}\rtimes C_5\) on the Klein cubic. This is the published
   name of our question. SPEC already records the exception
   (item 6 of the unconditional starting point). **[HOUSE]** as
   status; **[READ]** as the 2025 theorem.

**Conditional forks, still open and incompatible.**

- Cassels–Swinnerton-Dyer (a cubic with a prime-to-3 zero-cycle has
  a point) would make \(X\) very versal, hence \(\operatorname{ed}(G)=3\).
  **[READ]** Duncan–Reichstein, Proposition 10.8(b) and Theorem 10.5.
- Dolgachev's inequality \(\operatorname{Crd}(G)\le\operatorname{ed}(G)\)
  would force \(\operatorname{ed}(G)=4\), hence no map. **[READ]**
  Duncan–Reichstein, Proposition 10.8(c); Dolgachev, arXiv:2507.15096
  (2026), still presents the inequality as a conjecture and the
  Klein cubic as the incompatibility with CSD. Here
  \(\operatorname{Crd}(G)=4\): Prokhorov gives \(\ge4\), and the
  action on \(\mathbf P(W)\) gives \(\le4\). **[HOUSE]**

Neither conjecture is proved. They cannot both be true.

---

## 4. Verdict

**What I read.** The existence literature — Buhler–Reichstein,
Merkurjev, Serre, Reichstein–Youssin, Duncan, Duncan–Reichstein,
Cheltsov–Tschinkel–Zhang, Tschinkel–Zhang, Scavia, Dolgachev 2026 —
does not contain an unconditional construction of a dominant
\(G\)-map \(\mathbf P(W)\dashrightarrow X\), and does not contain an
unconditional obstruction. The 2025 classification of
\(G\)-unirational cubic threefolds *names this pair
\((X,G)\) as an open exception*. Essential dimension of \(G\) is
still \(\{3,4\}\). No-name does not shrink the source. The standard
constructions (fixed point, index 2, invariant hyperplane, Sylow
detection, Amitsur) all miss.

**What I inferred.** The only published construction that is not
already blocked by a named hypothesis is Cheltsov–Tschinkel–Zhang
Proposition 3.5 *with \(S\) not a hyperplane*: a \(G\)-invariant
irreducible divisor on \(X\), cut by an invariant of degree
\(\ge5\), which is \(G\)-unirational (necessarily with nontrivial
generic stabilizer, because \(\operatorname{ed}(G)\ge3\)). That is
not a theorem in any paper I read; it is the leftover of their
Proposition 3.5 / Remark 3.6.

**What is already house, and is not reopened.** The equivalence of
(U) with \(\operatorname{ed}(G)=3\); the interval \(3\le\operatorname{ed}(G)\le4\);
the twist dictionary; Condition (A); Sylow versality; vanishing of
the ordinary Amitsur obstruction; failure of (L); death of
Duncan–Reichstein 8.8; the V14 non-unirationality seal.

**Headline.** Problem E remains OPEN. This packet excludes no degree.

---

## 5. The single most promising concrete import

**Cheltsov–Tschinkel–Zhang, Proposition 3.5 (and Remark 3.6), via
the no-name lemma, applied to a \(G\)-invariant divisor on \(X\)
that is not a hyperplane section.**

Reason: it is the one existence machine in the 2025 Fano paper that
(i) is written for cubics, (ii) allows a nontrivial generic
stabilizer (required here, since a generically free \(G\)-surface
cannot be \(G\)-unirational), and (iii) has never been run by the
campaign. The first candidate surface is the unique degree-5
invariant divisor, the Hessian section (campaign PIN / STEIN_LERAY
Proposition PIN). Either that surface has nontrivial generic
stabilizer *and* is \(G\)-unirational, in which case Proposition 3.5
gives the headline map, or it is generically free, in which case it
cannot be \(G\)-unirational and the construction does not start.
That dichotomy is a finite, geometric question about one named
surface, not another open-ended covariant search.

---

## Honesty tiering

| tag | meaning | used for |
|---|---|---|
| **[READ]** | quoted or paraphrased from a named paper I opened | §§1–3 citations |
| **[HOUSE]** | already sealed in SPEC / RESOLUTION / a 2026-08-12 packet | ed-equivalence, Condition (A), no-name unused |
| **[T1]** | complete elementary arithmetic in this packet | \(\lvert G\rvert=660\); character-degree sum of squares; 2-Sylow order 4 |
| **[INFERRED]** | assembly, not a theorem of one paper | leftover of CTZ 3.5; \(H\)-irreducibility of \(W\) |
| **[EXT]** | classical import, named at the point of use | Kollár 2002; Prokhorov 2012; ATLAS degrees |

No unverified external mathematics enters any **[T1]** claim. No
**[INFERRED]** line is treated as a theorem.

---

## 8. Not claimed

* **No headline.** Problem E remains **OPEN**. This packet **excludes
  no degree** and cuts none of the 22 live \(d=35\) cells.
* No construction of a dominant \(G\)-map \(\mathbf P(W)\dashrightarrow X\).
* No obstruction to every such map, and no proof that
  \(\operatorname{ed}(G)\) equals 3 or 4.
* No claim that Cheltsov–Tschinkel–Zhang Proposition 3.5 applies to
  the Hessian section (that is the suggested next computation, not a
  theorem).
* No claim that Scavia's counterexample decides the Klein cubic.
* No claim that \(B_0(G)=0\) implies Noether's problem for \(G\), or
  that it implies (U).
* No claim that (L) or (SL) is equivalent to (U).
* No reopening of the sealed ed-equivalence, the V14 seal, or the
  degree-35 census.
* No git operation was performed and nothing outside this packet
  directory was written.

---

## Replay

```text
python3 verifier.py
```

from this directory. The verifier checks file presence, the fixed
headline, the exit ledger, the honesty / “Not claimed” sections, the
ODDZERO registration fields, the **[T1]** arithmetic, and that every
citation key listed in `results/citations.json` occurs in
`THEOREM.md`. It does not re-derive any external theorem.

---

## Dependencies (read-only)

### A. Published theorems (cited exactly; not independently re-derived)

- J. Buhler and Z. Reichstein, *On the essential dimension of a finite
  group*, Compositio Math. 106 (1997), 159–179.
- Z. Reichstein, *On the notion of essential dimension for algebraic
  groups*, Transform. Groups 5 (2000), 265–304.
- Z. Reichstein and B. Youssin, *Essential dimensions of algebraic
  groups and a resolution theorem for \(G\)-varieties*, Canad. J. Math.
  52 (2000), 1018–1056.
- J.-P. Serre, letter reprinted as the appendix to Duncan–Reichstein
  2015; also *Cohomological invariants, Witt invariants, and trace
  forms*, in *Cohomological invariants in Galois cohomology*, AMS
  Univ. Lecture Series 28 (2003).
- A. Merkurjev, *Essential dimension* (survey; online update of the
  ICM address), Theorem 3.25.
- A. Duncan and Z. Reichstein, *Versality of algebraic group actions
  and rational points on twisted varieties*, J. Algebraic Geom. 24
  (2015), 499–530, arXiv:1109.6093. Theorems 1.1, 10.5; Proposition
  10.8; Remarks 2.6–2.8.
- A. Duncan, *Equivariant unirationality of del Pezzo surfaces of
  degree 3 and 4*, Eur. J. Math. 2 (2016), 897–916, arXiv:1410.8434.
  Theorem 1.4, Proposition 2.7, Theorem 3.2.
- J. Kollár, *Unirationality of cubic hypersurfaces*, J. Eur. Math.
  Soc. 4 (2002), 237–245.
- Yu. Prokhorov, *Simple finite subgroups of the Cremona group of
  rank 3*, J. Algebraic Geom. 21 (2012), 563–600, Theorems 1.3, 1.5.
- B. Kunyavskiĭ, *The Bogomolov multiplier of finite simple groups*,
  arXiv:0712.4069 (2007); in *Cohomological and Geometric Approaches
  to Rationality Problems*, Progr. Math., Birkhäuser, 2010.
  Corollary 1.2.
- M. Domokos, *Covariants and the no-name lemma*, J. Lie Theory 18
  (2008), 839–858, arXiv:0803.1327.
- I. Cheltsov, Yu. Tschinkel, Zh. Zhang, *Equivariant unirationality
  of Fano threefolds*, arXiv:2502.19598 (2025). Theorem 5.1,
  Propositions 3.2, 3.3, 3.5.
- Yu. Tschinkel and Zh. Zhang, *Cohomological obstructions to
  equivariant unirationality*, arXiv:2504.10204 (2025).
- F. Scavia, *A counterexample to a conjecture of Duncan on versal
  actions*, arXiv:2607.25118 (2026).
- I. Dolgachev, *The essential and Cremona dimensions of a group*,
  arXiv:2507.15096v3 (2026), §7.
- A. Beauville, *Finite simple groups of essential dimension 3*,
  arXiv:1101.1372 (2011).

### B. Campaign documents consulted, not rewritten

`HANDOFF_2026-08-12.md`, `SPEC.md`, `RESOLUTION.md` (ed-reduction and
the (L)/(U) split), `goal_runs_20260808/SCHUR_QUARTIC_MODULI/`
(no-name unused).

### C. Assembled-chain status

Section 5 is an **[INFERRED]** leftover of Cheltsov–Tschinkel–Zhang
Proposition 3.5. It is not a theorem of that paper, and it is not a
claim that the Hessian section works.
