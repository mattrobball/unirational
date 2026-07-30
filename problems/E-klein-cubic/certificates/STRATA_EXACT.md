# Exact stabilizer stratification (WP-1, first dispatch)

**Headline: OPEN.**

This certificate freezes a characteristic-zero stabilizer stratification of

\[
Y=\mathbf P(W)\simeq\mathbf P^4,\qquad
X=\Bigl\{\sum_{i\in\mathbf Z/5}x_i^2 x_{i+1}=0\Bigr\}\subset Y,\qquad
G=\operatorname{PSL}_2(\mathbf F_{11}),\quad |G|=660,
\]

using the repository representation in `certificates/exact_weil_check.py`.

### Theorem boundary

**Proved here:** conjugacy layer of relevant subgroups; projective eigenspaces of
all non-identity elements; intersection closure to stabilization; G-orbit
structure of the resulting linear subspaces; named ambient and on-`X` orbit
counts in the candidate tables (with two interpretation/incidence
corrections); type-I/type-II elliptic incidence verdict; split-prime
regression at 67, 89, 331.

**Not proved here:** tangent/normal characters (WP-2); marked `S3` / `E[2]`
geometry (WP-3); normal jets or any statement about homogeneous landing
self-covariants; equivariant unirationality; `ed_{\mathbf C}(G)`.

Do not describe any part of this as a short exact Čech complex. Do not
conflate ordinary and symbolic powers.

---

## 1. Group and subgroup layer

### Element orders (exact, all 660 matrices)

| Order | 1 | 2 | 3 | 5 | 6 | 11 |
|------:|--:|--:|--:|--:|--:|---:|
| Count | 1 | 55 | 110 | 264 | 110 | 120 |

### Subgroup conjugacy (GAP 4.15.1 + exact Python enumeration)

Regression targets (also derived by `|G|/|N_G(H)|`):

| Subgroup | Normalizer | Count | Classes |
|----------|------------|------:|---------|
| `C2` | `D12` (order 12) | 55 | 1 |
| `V4≅C2×C2` | `A4` (order 12) | 55 | 1 |
| `C3` | order 12 | 55 | 1 |
| `C5` | `D10` (order 10) | 66 | 1 |
| `C11` | `11:5` (order 55) | 12 | 1 |
| `A4` | self-norm. order 12 | 55 | **1** |
| `D10` | self-norm. order 10 | 66 | 1 |
| `D12` | self-norm. order 12 | 55 | 1 |
| `A5` | self-norm. order 60 | 11+11 | **2** |
| `11:5` | self-norm. order 55 | 12 | 1 |

GAP reports 16 conjugacy classes of subgroups total; marker `GROUP_SUBGROUPS_OK`.

**Interpretation correction (first discrepancy vs naive candidate reading).**
The candidate table’s `A4^(a)`/`A4^(b)` and `C5^(a)`/`C5^(b)` **cannot** be two
conjugacy classes of subgroups: there is one class of each. They are two
`G`-orbits of *fixed points* of those subgroups:

- each of the 55 `A4`s contributes two character lines (off `X`) → orbits 55+55;
- each of the 66 `C5`s contributes two nontrivial projective eigenline types →
  orbits 132+132.

This matches the director’s subgroup regression table and the orbit-11 `A5`
branch (two classes of 11).

Replay:

```text
/opt/homebrew/Caskroom/miniforge/base/bin/gap -q certificates/strata/group_subgroups.g
/opt/homebrew/bin/python3 certificates/strata/verify.py
```

---

## 2. Eigenspaces and intersection closure

Producer `certificates/strata/exact_strata.py`:

1. Builds all 660 modular images of the exact matrices at a split prime.
2. For every non-identity `g` of order `n`, computes `ker(g−λI)` for every
   `n`-th root of unity present in `F_p`.
3. Closes the collection of subspaces under pairwise intersection **until
   stabilization** (not one pass).
4. Partitions by the `G`-action; computes pointwise stabilizer (scalar action
   on the span) and setwise stabilizer; tests identical vanishing of `F` on
   the span when meaningful.

| Prime | `ζ₁₁` | 5th roots? | Raw eigenspaces | After closure | Orbits |
|------:|------:|:----------:|----------------:|--------------:|-------:|
| 67 | 64 | no (`5∤66`) | 621 | 951 | 12 |
| 89 | 78 | no (`5∤88`) | 291 | 511 | 7 |
| 331 | 270 | **yes** (`5∣330`) | 885 | 1215 | 14 |

Only `p=331` among the three work-order primes splits the full set of element
orders `{1,2,3,5,6,11}`. Counts at 67/89 are regressions for the split
sub-locus; characteristic-zero proofs use exact matrices and (for `C5`
eigenlines) the explicit cyclotomic formula below. Modular fibres are never
the sole char-0 proof.

### Orbit table at full split (`p=331`)

| Label | Vec. dim | Orbit size | `|pstab|` | `|sstab|` | `F≡0` on span? |
|-------|---------:|-----------:|----------:|----------:|:--------------:|
| involution plus-plane | 3 | 55 | 2 | 12 | (cubic section) |
| involution minus-line | 2 | 55 | 2 | 12 | yes |
| V4 fixed line `P(A)` | 2 | 55 | 4 | 12 | no (binary cubic) |
| C3 eigenline | 2 | 110 | 3 | 6 | no |
| V4 type-I point | 1 | 165 | 4 | 4 | yes |
| C5 eigenline (a) | 1 | 132 | 5 | 5 | yes |
| C5 eigenline (b) | 1 | 132 | 5 | 5 | yes |
| C6 point (on X) | 1 | 110 | 6 | 6 | yes |
| C6 point (off X) | 1 | 110 | 6 | 6 | no |
| D10 point | 1 | 66 | 10 | 10 | no (`F=5`) |
| C11 point | 1 | 60 | 11 | 11 | yes |
| A4 character line (a) | 1 | 55 | 12 | 12 | no |
| A4 character line (b) | 1 | 55 | 12 | 12 | no |
| D12 point | 1 | 55 | 12 | 12 | no |

Exact char-0 cross-checks: involution projectors `(I±t)`; V4 joint characters
dims `(2,1,1,1)`; type-I vertices have projective stabilizer exactly `V4` and
lie on `X`; D10 line `[1:1:1:1:1]` has `F=5`; D12 character line off `X`;
standard eigenbasis of `T` gives five `C11` points on `X`.

### C5 eigenlines (exact, not visible at 67/89)

For the standard 5-cycle `P` and `ω^5=1`, `ω≠1`,

\[
v(ω)=(1,ω,ω^2,ω^3,ω^4),\qquad
F(v(ω))=ω\sum_{i=0}^{4}(ω^3)^i=0
\]

since `ω^3` is a nontrivial 5th root of unity. Stabilizer is `C5` (reflections
in `D10` swap `ω↔ω^{-1}`), orbit size `660/5=132`. The two Gal-pairs
`{ζ_5,ζ_5^4}` and `{ζ_5^2,ζ_5^3}` are the two ambient/on-`X` orbits of size 132.

---

## 3. Candidate table reconciliation

### Positive-dimensional ambient

| Type | Candidate | Certified | Status |
|------|----------:|----------:|--------|
| involution plane | 55 | 55 | CERTIFIED |
| involution line | 55 | 55 | CERTIFIED |
| V4 fixed line | 55 | 55 | CERTIFIED |
| C3 eigenline | 110 | 110 | CERTIFIED |

### Ambient point orbits

| Stabilizer label | Candidate | Certified | Status |
|------------------|----------:|----------:|--------|
| D10 | 66 | 66 | CERTIFIED |
| C5^(a) | 132 | 132 | CERTIFIED (as fixed-point orbit) |
| C5^(b) | 132 | 132 | CERTIFIED (as fixed-point orbit) |
| C11 | 60 | 60 | CERTIFIED |
| D12 | 55 | 55 | CERTIFIED |
| C6^(line) | 110 | 110 | CERTIFIED (`F≡0`) |
| C6^(plane) | 110 | 110 | CERTIFIED (`F≢0`) |
| isolated V4 (type I) | 165 | 165 | CERTIFIED |
| A4^(a) | 55 | 55 | CERTIFIED (as fixed-point orbit) |
| A4^(b) | 55 | 55 | CERTIFIED (as fixed-point orbit) |

### Nonfree strata on `X`

| Label | Candidate | Certified | Status |
|-------|----------:|----------:|--------|
| C2 plus (elliptic) | 55 | 55 | CERTIFIED |
| C2 minus (line) | 55 | 55 | CERTIFIED |
| C6 | 110 | 110 | CERTIFIED |
| V4 type I | 165 | 165 | CERTIFIED |
| V4 type II | 165 | 165 | CERTIFIED (not a linear eigenspace: `X∩P(A)`) |
| C11 | 60 | 60 | CERTIFIED |
| C5^(a), C5^(b) | 132 each | 132 each | CERTIFIED |
| C3 | 220 | — | **PARTIAL** — expected as residual points of 110 C3-lines on `X` (each line meets `X` in three points: one C6 + two exact-C3); full scheme-theoretic reducedness/smoothness of those residual points is a named remainder |

### First discrepancy (called out)

**ID:** `A4_and_C5_are_fixed_point_types_not_subgroup_classes`.

The candidate notation suggests two conjugacy classes of `A4` and of `C5`. Exact
enumeration and GAP refute that reading. After reinterpreting `(a)/(b)` as
fixed-point orbit types, all numerical orbit sizes match.

---

## 4. Type-I / type-II incidence inconsistency — verdict

Candidate input asserts both:

1. every type-II `V4` point lies on three fixed elliptic curves;
2. two positive-dimensional fixed-locus closures meet only at type-I points.

These cannot both hold.

### Local exact geometry (one `V4=<z,s>`, `r=zs`)

Joint characters: `W=A⊕B⊕C⊕D` with dims `(2,1,1,1)`.

| Object | Definition |
|--------|------------|
| Minus-lines | `L_z=P(C+D)`, `L_s=P(B+D)`, `L_r=P(B+C)` ⊂ `X` |
| Elliptics | `E_z=X∩P(A+B)`, etc. |
| Type I | `[B],[C],[D]` — triangle vertices; stab `V4`; on `X` |
| Type II | three points of `R=X∩P(A)`; stab `V4`; on `X` |

**Incidences:**

| Point | Elliptics | Minus-lines |
|-------|-----------|-------------|
| type I `[B]` | only `E_z` | `L_s`, `L_r` |
| type I `[C]` | only `E_s` | `L_z`, `L_r` |
| type I `[D]` | only `E_r` | `L_z`, `L_s` |
| each type II in `R` | **all three** `E_z,E_s,E_r` | none of the triangle edges |

### Verdict

| Claim | Decision |
|-------|----------|
| (1) type-II on three elliptics | **SURVIVES** |
| (2) positive-dim fixed loci meet only at type-I | **REFUTED** |

**Corrected statement.** Positive-dimensional fixed-locus closures meet at
type-II points: each type-II point is a triple intersection of the three local
plus-plane elliptics (and lies on the V4 fixed line `P(A)`). Type-I points are
the triangle vertices where one elliptic meets two minus-lines.

Code marker in JSON: `CLAIM_1_SURVIVES_CLAIM_2_REFUTED`.

### Double counting

| Count | From subgroups | From orbit-stab | Flags |
|-------|----------------|-----------------|-------|
| type-I points | 55×3 = 165 | 660/4 = 165 | agree |
| type-II points | 55×3 = 165 | 660/4 = 165 | agree |
| (type-II, local elliptic) flags | 55×9 = 495 | 165×3 = 495 | agree |

Independent verifier rebuilds the incidence edges from
`incidence_exact.json` without importing the producer and rechecks the V4
joint geometry on the exact matrices.

---

## 5. Portable JSON packets

| File | Role |
|------|------|
| `certificates/strata/strata_exact.json` | Exact subgroup counts, char-0 representatives, modular regression at 67/89/331, candidate reconciliation, type-I/II verdict |
| `certificates/strata/incidence_exact.json` | Incidence graph data and double-count seals |

Fields include defining notes for fields/bases, stabilizer descriptions, orbit
sizes, and incidence IDs. Bases of cyclotomic points are given by exact
formulae (`C5`) or by the certified `Q(ζ₁₁)` model (`C11`, involution, V4).

### Independent replay

```text
/opt/homebrew/bin/python3 certificates/strata/verify.py
# terminal marker:
STRATA_EXACT_VERIFY_OK
```

The verifier does **not** import `exact_strata.py`. It rebuilds the group layer
from `exact_weil_check.py`, rebuilds V4 type-I/II geometry, and rebuilds the
incidence edge set from the JSON alone.

---

## 6. Named remainders (honest, in-scope)

1. **C3 residual points on `X` (candidate 220):** combinatorial expectation
   sealed; scheme-theoretic primary decomposition / reducedness of
   `X ∩ (C3-eigenline)` at the two non-`C6` points is not yet a separate
   Singular/M2 certificate in this packet.
2. **WP-2 normal characters** — not started (Gate 1 review stop).
3. **Global arrangement incidence** beyond the sealed V4 local picture and the
   classical 55-plane D10/D12 counts already in HANDOFF — portable JSON lists
   the D10/D12 double-count sketch; full flag enumeration as a pure JSON graph
   for every stratum pair can be extended after review.
4. **SageMath** still missing; `geometry.sage` is a stub.

---

## 7. Seal block (hashes after final write)

Compute after this file and the audit are on disk:

```text
/opt/homebrew/bin/python3 certificates/strata/verify.py   # STRATA_EXACT_VERIFY_OK
shasum -a 256 certificates/strata/strata_exact.json \
              certificates/strata/incidence_exact.json \
              certificates/STRATA_EXACT.md \
              certificates/STRATA_MACHINE_INPUT_AUDIT.md
```

Known content hashes at producer/verifier freeze (JSON stable; markdown sealed
next):

| Artifact | SHA-256 |
|----------|---------|
| `certificates/strata/strata_exact.json` | `62277c3bb054dd2beb8f5535ad4aef7c1e5baf75b0f5c23c82f5edfa594db91b` |
| `certificates/strata/incidence_exact.json` | `21a1d40b6e84e1673885c52e30fafb8f27d58cf2494b42851440a1d922ac2aa9` |
| `certificates/exact_weil_check.py` | `14c9bda195ccc39e3ae2cd6d6d42bbb8f45397e114b5137947fb41dd665cc2b2` |
| `certificates/strata/group_subgroups.g` | `f0daa9ddc1599bf78aa121e483188fbdc6cac748da4008822015ace3b176666e` |
| `certificates/strata/verify.py` | `1af9cb843c1179c6cbb094fff181382575751147c027df3045bf007baa4bab24` |

Markdown certificates (content hashes of the files as first written to disk on
2026-07-30, before any subsequent footer edit):

| Artifact | SHA-256 |
|----------|---------|
| `certificates/STRATA_MACHINE_INPUT_AUDIT.md` | `017526b15883cd90b2d618c6b32d467de08e3a76a1d9e44a616e41fc48c7ff74` |
| `certificates/STRATA_EXACT.md` (pre-footer) | `0bbb1efae414e8fd87bdad5925645f2694ee5ecb5fc30bdfe02c9434eb07c6dc` |

**STRATA_EXACT_OK** (documentation seal; machine marker is `STRATA_EXACT_VERIFY_OK`).

## Director audit note (2026-07-30)

Independent adversarial audit of this Gate 1 packet: **sound as committed**.
Three independent verification paths converge (GAP's own `PSL(2,11)` library,
the repository's exact `Q(zeta_11)` matrices, and a verifier that reads only
the JSON — confirmed to contain no import of the producer). The verifier
recomputes rather than rubber-stamps: it rebuilds the 55 `V4`s from commuting
involution pairs, derives `|cl(A5)|=660/60=11` from a brute-force order-60
`(2,3,5)` subgroup search, and re-derives the `V4` incidence geometry by an
independent mod-67 rank test.

Two caveats recorded for downstream packages:

1. **Seal hash is not bit-reproducible.** `strata_exact.json` records
   `wall_time_sec`, and the file hashes its own prior bytes, so a fresh
   replay changes exactly two lines (the timing field and the dependent
   self-hash). All substantive fields are byte-identical and
   `incidence_exact.json` is unchanged. Cosmetic; do not treat a differing
   seal line as a content mismatch. Future producers should exclude timing
   from sealed payloads.
2. **The type-II incidence is single-representative plus symmetry.** The
   "three fixed elliptics" verdict is verified exactly on one representative
   `V4 = <z,s>` and extended to all 55 subgroups / 165 points by the
   single-conjugacy-class orbit argument (`A4` is one class of 55, certified
   above). This is legitimate but was implicit; it is stated here explicitly.
   Any downstream use requiring pointwise-independent verification at all 165
   points must say so and redo it.
