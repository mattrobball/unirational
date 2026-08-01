# T10.0 — Ordinary binodal gluing contributes no 3-primary local Picard defect

**Exit:** `T10-BINODAL-NO-3-DEFECT`  
**Headline:** **OPEN**  
**Scope:** local completed ordinary node of the **target branch** `B` only.  
**Does not decide:** normality of the fold algebra `S_G`, nor any global class group of `B` or of `S_G`.

---

## 1. Local model (split ordinary node)

After a finite separable extension of the residue field that separates the two
branches of the completed ordinary node of `B`, the completed local ring is the
conductor fibre product

```text
A = B₁ ×_D B₂,
```

with

```text
B₁ = K'[[x, z₁, z₂]],
B₂ = K'[[y, z₁, z₂]],
D  = K'[[z₁, z₂]],
```

and the two maps `B_i → D` are the quotient maps `x ↦ 0` and `y ↦ 0`
respectively. Equivalently,

```text
A ≅ K'[[x, y, z₁, z₂]] / (xy).
```

The conductor ideal of `B₁ × B₂` over `A` is `(x, y)` in the ambient
coordinates, with conductor quotient `D`.

This is the ordinary-binodal completed local equation sealed at the Hensel
point (`T9-HENSEL-NONUNIT-SEALED`): after base change to a finite extension of
`Q_101`, one has

```text
Ô_{B,z} ≃ K'[[x,y,z₁,z₂]]/(xy).
```

(The singular locus of that completed ring is `V(x,y) ≅ Spec K'[[z₁,z₂]]`, of
dimension two. Combined with the Jacobian ideal of `H` over `Q` and invariance
of Krull dimension under field extension, this is the corrected argument that
the **target branch** `B` is nonnormal over `Q` — see
`WORKORDER_CAS_T10_P25W_C2_CORRECTION.md`. That argument concerns `B`, not
`S_G`.)

---

## 2. Split unit map is surjective

The conductor Mayer–Vietoris exact sequence of units on the punctured spectra
contains the unit map

```text
B₁^× × B₂^× × D^×  →  D^× × D^×,
(u₁, u₂, d)        ↦  (u₁|_D / d,  u₂|_D / d).
```

**Claim.** This map is surjective.

**Proof.** Each restriction `B_i^× → D^×` is surjective: every unit of the
formal power series ring `D = K'[[z₁,z₂]]` lifts to a unit of `B₁` (resp.
`B₂`) by the same power-series coefficients with free `x` (resp. `y`)
coefficient set to zero, or more simply because `B_i → D` is a continuous
surjection of complete local rings with regular parameters and the constant
term of a unit is nonzero. Concretely, for any `v ∈ D^×` the triple
`(ṽ₁, ṽ₂, 1)` with `ṽ_i` any lift of `v` maps to `(v, v)`, and for
`(v, 1)` one takes `(ṽ₁, 1, 1)`. Hence every pair in `D^× × D^×` is hit.

The independent verifier recomputes this on a truncated power-series model of
order `N = 4` over `F_101`: every unit class of `D_N^×` is hit by a unit of
`B₁,N`, and the two-component map is therefore onto `D_N^× × D_N^×`.

---

## 3. Split punctured Picard group vanishes

Each of `B₁`, `B₂`, and `D` is a formal power series ring over a field, hence
a UFD (and regular). On the spectrum of a regular UFD the Picard group is
trivial; on the punctured spectrum of a regular local ring of dimension
`≥ 2` one still has `Pic = 0` (every height-one prime is principal, and the
punctured spectrum of a regular local ring of dim ≥ 2 is locally factorial
with trivial class group). Dimensions:

```text
dim B₁ = dim B₂ = 3,   dim D = 2.
```

So

```text
Pic(Spec° B₁) = Pic(Spec° B₂) = Pic(Spec° D) = 0.
```

The conductor Mayer–Vietoris sequence for Picard groups of the fibre product
therefore collapses at the unit-cokernel term: the local Picard group of the
**split** completed node vanishes.

```text
Pic(Spec° A_split) = 0.
```

---

## 4. Unsplit case: no odd-primary torsion

Suppose the two branches are Galois-conjugate over the unsplit residue field
`K`, exchanged by a quadratic separable extension `K'/K` with
`Gal = {1, σ}`. Let `A_0` be the completed local ring over `K` and `A` its
base change to `K'` (the split node above). Restriction–corestriction on
punctured Picard groups satisfies

```text
cor ∘ res : Pic(Spec° A_0) → Pic(Spec° A_0)
```

and equals **multiplication by `[K' : K] = 2`**.

By §3 the split group vanishes, so `res(α) = 0` for every class `α` of the
unsplit group, and therefore

```text
2 · α = cor(res(α)) = 0.
```

Hence every class of `Pic(Spec° A_0)` is killed by `2`. In particular the
group has **no odd-primary torsion**: if `3^k · α = 0` then, writing
`2b ≡ 1 (mod 3^k)`, one has `α = 2b · α = 0`.

The independent verifier records the elementary arithmetic fact that
multiplication by `2` is an automorphism of every finite abelian
`3`-group (since `gcd(2, 3^k) = 1`), and checks it on the explicit modules
`Z/3`, `Z/9`, and `(Z/3)²`.

---

## 5. CAS consequence (binding)

Ordinary binodal gluing of the target branch contributes **no 3-primary local
Picard defect**. Do **not** reconstruct a global binodal closed point solely
to analyse its local class group.

The remaining 3-primary dangers (for later T10.2–T10.3, out of scope here)
are:

1. additional height-one defects of the **fold** normalization (if any);
2. cubic-discriminant contacts of order divisible by three;
3. residual codimension-two / codimension-three local Picard defects.

---

## 6. Theorem boundary

| Statement | Object | Status |
|---|---|---|
| completed local equation `K'[[x,y,z₁,z₂]]/(xy)` at Hensel point | target branch `B` | accepted analytic input |
| `B` nonnormal over `Q` (codim-1 singular component of `H=0`) | target branch `B` | accepted via correction argument |
| split ordinary node has vanishing punctured Pic | local model of `B` | sealed here |
| unsplit ordinary node has no odd-primary Pic torsion | local model of `B` | sealed here |
| `S_G` normal / nonnormal / `R_1` | fold algebra | **not decided by this packet** |

Markers `T-BRANCH-NONNORMAL` and `T10-BINODAL-NO-3-DEFECT` concern `B`.
Markers `T-NONNORMAL` / `dim Sing_S = 2` for `S_G` remain suspended.

---

## 7. Artifacts

| File | Role |
|---|---|
| `BINODAL_ODD_PRIMARY.md` | this note |
| `verify_binodal_local_model.py` | recomputes truncated unit-map surjectivity and mult-by-2 on 3-groups |

---

## 8. Exit

```text
T10-BINODAL-NO-3-DEFECT
```

**Headline:** **OPEN**
