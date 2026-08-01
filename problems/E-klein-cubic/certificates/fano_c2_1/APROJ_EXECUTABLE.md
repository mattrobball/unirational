# C2.1 — Reconstruct `L_a`, `L_b` over `K_proj`

**Packet:** `certificates/fano_c2_1`  
**Date:** 2026-07-31  
**Work order:** `WORKORDER_CAS_T10_P25W_C2.md` §0, §1.8, §2 (9–10), §5 C2.1, §8, §9  
**Exit:** `C2-1-UNDECIDED`  
**Headline:** **OPEN**

---

## 0. Scope fence

**In scope.** C2.1 only: modular samples of left-multiplication matrices on the sealed
shortlex word basis; CRT / rational reconstruction of matrix entries as elements of the
rank-12 `K_proj` model; word-basis change matrix; exact/holdout verification.

**Out of scope.** C2.2 (involution, Morita, Hermitian, Plücker) and C2.3 (common isotropic
line). Full `36³ = 46656` structure-constant reconstruction is **forbidden** as a silent
fallback (§1.8, §5 C2.1).

**Writes only:** `certificates/fano_c2_1/`, `tmp/c21_*/`.  
**Read freely:** sealed `fano_c2/`, `kproj_arithmetic/`, alignment, C1.

---

## 1. Accepted inputs (not re-derived)

| Item | Source |
|---|---|
| Pair `a = e_1`, `b = e_2` | C2.0 sealed |
| 36 shortlex words, max length 5 | `certificates/fano_c2/word_basis.json` |
| Unit word-basis dets 16 @ `p=23`, 82 @ `p=89` | C2.0 |
| Rank-12 `K_proj/P_0` arithmetic | `tmp/kproj_arithmetic/` |
| Reynolds seeds + `A→TSTS`, `B→T^8S` | alignment certificate |

§1.8 generation is already sound modularly. This packet does **not** re-prove generation;
it attempts to install executable `L_a, L_b ∈ Mat_36(K_proj)`.

---

## 2. What was achieved

### 2.1 Modular sampling pipeline (installed)

At split primes `p ∈ {23, 89, 199, 331, 353}` (`p ≡ 1 mod 11`, not sole-fibre 67), rebuild
the 660-element conjugation orbit once per prime, evaluate the 36 projective Reynolds frame
at many random geometric points, form `a = e_1`, `b = e_2`, and compute

- `L_a`, `L_b` on the **sealed** shortlex word list (not a greedy re-selection);
- change-of-basis matrix `C` with columns = coordinates of word images in the Reynolds frame.

Cost: ~80 good points/prime in ~4 s wall total for five primes; peak RSS ~95 MiB.

### 2.2 Structure of `L_a` (measured)

| Class | Count (of 1296) | Meaning |
|---|---:|---|
| Constant `0` | 836 | structural zeros |
| Constant `1` | 23 | unit columns: prepending `a` stays in the word basis |
| Varying | **437** | reduction of words that leave the shortlex basis |

The 23 unit columns are exactly the words `w` with `a+w` still among the 36 sealed words
(indices of reduction columns: 23–35). Same pattern is stable across primes and points.

### 2.3 Q-constant reconstruction (characteristic zero, partial)

Using CRT + `certificates/degree25_exact/common_p25x.py:rational_reconstruction` (never
SymPy’s private helper), with **final congruence check** and a **holdout prime** `p = 463`
unused in reconstruction:

| Object | Q-constants sealed | Holdout checks |
|---|---:|---|
| `L_a` | **859 / 1296** | 25770 ok, 0 bad |
| `L_b` | **484 / 1296** | 14520 ok, 0 bad |
| word change `C` | **208 / 1296** | 6240 ok, 0 bad |

Twelve modular “pseudo-constants” of `L_b` produced false rational reconstructions (agreed
on the five training moduli, failed holdout) and were **dropped** (§8.7). Empty solver output
was never treated as a negative theorem.

Independent verifier `verify_c21.py` rebuilds the Reynolds frame at the holdout prime at
three geometric points (including the sealed C2.0 point) **without importing the producer**
and rechecks every sealed Q-constant and the unit-column identities.

### 2.4 Bottleneck: varying entries as genuine `K_proj` elements

Each matrix entry is an element of `K_proj`, uniquely

```text
x = sum_{k=0}^{11} r_k(t_3,t_6,t_8,t_11) · β_k
```

in the certified free basis over `P_0 = Q(t_3,t_6,t_8,t_11)`.

Modular linear algebra (Julia/Nemo, 1000 samples @ `p = 331`) shows that for **every tested
varying entry**, the polynomial ansatz `deg r_k ≤ D` is **inconsistent** for

```text
D = 0, 1, 2, 3, 4
```

(`rank A = nunk` but `rank [A|b] = nunk+1`). A rational ansatz with numerator/denominator
total degree ≤ 3 has nullity 0 at 500 samples (only the zero solution).

**Lower bound:** total degree of the `P_0`-coefficients is at least **5** if they are
polynomials (1512 unknowns per entry at `D = 5`). Clearing the modular word-basis
determinant to powers 1–3 does not restore consistency at `D ≤ 3`.

This is the named resource floor. The compressed route (2592 entries vs 46656 structure
constants) remains the right shape; the obstruction is multivariate rational-function
height/degree of the ~437 + ~800 varying entries, not the 46656 path.

---

## 3. Open set of validity

The two-generator regular representation is valid on the dense open of the projective
parameter space where:

1. the sealed shortlex **word-basis determinant is nonzero** (unit at good split primes;
   C2.0: 16 @ `F_23`, 82 @ `F_89` at point `(1,2,3,4,5)`);
2. the projective Reynolds **frame determinant is nonzero**;
3. homogenization denominators `f_14` and `f_(14-d)` for the Reynolds seed degrees are
   nonzero.

Downstream C2.2 must restrict to this open (or a dense open thereof).

---

## 4. Specific inputs / trap

**Consumes:** descended PSL(2,11) Reynolds-frame seeds; alignment words `A→TSTS`,
`B→T^8S`; certified projective homogenization; sealed pair `(e_1,e_2)` and shortlex words;
executable rank-12 `K_proj` model.

**Trap named:** a construction for an arbitrary degree-6 CSA over an arbitrary field is too
weak for later Morita/Hermitian steps. This packet only addresses the specific descended
`A_proj` frame.

**Language:** no claim that “the cubic has a `K_proj`-point abstractly”; no claim that “the
generic Schur twist has no rational point.” No auxiliary Morita projector is a Fano point.

---

## 5. Theorem boundary

**Proved (characteristic zero, partial).** The 859 (resp. 484) entries of `L_a` (resp. `L_b`)
that are constant on the sampled geometric open equal the sealed rational integers (all in
`{0,1}` after holdout filtering), verified by multiprime CRT/ratrecon with congruence checks
and independent holdout rebuild. The 23 unit columns of `L_a` are structural.

**Proved (modular).** Sampling pipeline reproduces sealed C2.0 `L_a` at `p = 23` on Q-constant
positions; word-basis dets are units on all accepted samples at five split primes.

**Not proved.** Full `L_a, L_b ∈ Mat_36(K_proj)` (varying entries); min/char polys of `a,b`
over `K_proj`; complete word-change matrix over `K_proj`; involution; Morita; Hermitian
five-plane; any point of `F_{14,T}`.

**Modular is not silently promoted to characteristic zero** for varying entries.

---

## 6. Resource floor (measured)

| Quantity | Value |
|---|---|
| Peak RSS (producer) | ~94.6 MiB |
| Wall (producer, 5 primes × 80 pts) | ~4.2 s |
| Varying `L_a` entries | 437 |
| Varying `L_b` entries | ~798 |
| Poly degree lower bound | **≥ 5** |
| Unknowns/entry at `D = 5` | 1512 |
| Estimated full recon | entrywise multiprime GE of size ~1500; hours–days one core; streamable under 8 GiB |
| Forbidden alternative | 46656 independent structure constants (~18× more objects) |

---

## 7. Exit

```text
C2-1-UNDECIDED
```

Smallest unreconstructed objects: the **437 varying entries of `L_a`** and **~798 of `L_b`**
as rank-12 `K_proj` elements (P0-coefficients of total degree ≥ 5).

**Problem E remains OPEN.**

---

## 8. Deliverables

```text
certificates/fano_c2_1/
  APROJ_EXECUTABLE.md
  L_a.npz  L_a.json
  L_b.npz  L_b.json
  word_change.npz  word_change.json
  reconstruction_ledger.json
  produce_c21.py
  verify_c21.py
  verify_c21_result.json
  exit_c21.json
```

Scratch: `tmp/c21_work/`, `tmp/c21_probe/`.
