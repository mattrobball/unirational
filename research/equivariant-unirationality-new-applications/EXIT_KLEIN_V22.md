# EXIT — the Klein `V22` centralizer route

```text
VERDICT MARKER:  V22-D8-GATE-FAILS
```

Target: `X = VSP(C_Klein, 6)`, the smooth rational prime Fano threefold of
genus 12 (degree 22, Mori–Mukai 1.10) with faithful `G = PSL2(F7)`, the
Cheltsov–Shramov Klein `V22`. This was the top-ranked open candidate of the
packet (`TOP5.md` #3, `INDEX1_FANO_THREEFOLDS.md` §4).

**Result.** Of the two gates required by the sealed all-degree centralizer
theorem (`problems/E-klein-cubic/theory/FIX_IX_v14.md`, Cor IX.1):

| gate | statement | verdict |
|---|---|---|
| (a) | every irreducible `D8`-stable RCC subvariety of `X^σ` is a point | **FAILS** |
| (b) | `X^{D8} = ∅` | **HOLDS** |

`X^σ` contains an irreducible **smooth rational curve** which is canonically
`D8`-stable. The centralizer theorem therefore does **not** apply, and no
statement about the `G`-unirationality or weak `G`-versality of the Klein `V22`
follows from it. The route is closed as stated; §6 records exactly what new
theory (not new computation) would reopen it.

Everything below is exact over `Q(√−7)`: rational arithmetic in `python3`
(`fractions.Fraction` plus a quadratic-field class) and Macaulay2 over
`toField(QQ[t]/(t²+7))`. Two finite-field runs (`p = 11, 23`) are corroboration
only; no load-bearing claim rests on them.

---

## 1. The model, and its identification with `VSP(C_Klein, 6)`

Mukai: a prime Fano threefold of genus 12 is

```text
X = { U ∈ Gr(3, A) : U isotropic for every ω ∈ N },   dim A = 7,  dim N = 3,
```

`N ⊂ Λ²A*` a net of skew forms. Isotropy is **linear** in Plücker coordinates —
`U ⊥ ω` iff the contraction `ι_ω(p) ∈ A` vanishes, `p ∈ Λ³A` the Plücker vector
— so the 3 forms give 21 linear equations and `X = Gr(3,7) ∩ P^13`.

Take `A =` the 7-dimensional **rational** irreducible of `G = PSL2(F7)` (the
deleted permutation module on the 8 points of `P¹(F₇)`; character values
`7,−1,1,−1,0,0`). Then

```text
Λ²A  =  3 ⊕ 3' ⊕ 7 ⊕ 8        (character computation, verified in code)
```

so the **only** `G`-invariant Mukai nets on `A` are the two 3-dimensional
irreducibles, which are Galois-conjugate over `Q(√−7)` (equivalently swapped by
the outer automorphism of `PSL2(F7)`). The two resulting varieties are
`G`-isomorphic up to `Out(G)`; since `Out(G)` fixes the unique involution class
and carries `D8` to `D8`, the gate verdicts are insensitive to the choice.

**Identification.** Cheltsov–Shramov, *Three embeddings of the Klein simple
group into the Cremona group of rank three* (arXiv:1010.1918, Transformation
Groups 17 (2012) 303–350), construct `VSP(C_Klein,6)` in exactly this way:
their Appendix A together with Theorem 4.5 gives `U₇ ≅ W₇` (the 7-dimensional
irreducible) and the defining skew forms from `W₃ ⊂ Λ²(U₇^∨)`. Their
Theorem 1.10 records `Bir^G(X) = Aut^G(X) = G` and `G`-birational
superrigidity. Since `Λ²A` contains exactly two 3-dimensional subrepresentations,
the net used here **is** theirs up to Galois conjugation.

**Machine confirmation of the identification** (Macaulay2, exact over `Q(√−7)`;
independently reproduced mod 11 and mod 23):

```text
the 21 linear Plücker conditions have rank exactly 21   →  X = Gr(3,7) ∩ P^13
projective dim X = 3       degree X = 22
minimal generators of I(X) ⊂ P^13 : 45 quadrics
```

`45 = h⁰(P^13, O(2)) − h⁰(X, −2K) = 105 − 60` for a Fano threefold with
`(−K)³ = 22`, the standard numerology of the anticanonical `V22 ⊂ P^13`.

---

## 2. Group data and the character-forced profile

`σ ∈ G` an involution (one class, 21 elements); `C_G(σ) = D8`, the Sylow
2-subgroup, verified by brute force on all 168 elements. `N_G(⟨σ⟩) = C_G(σ)`,
so `D8` is the full residual symmetry of `X^σ`.

Everything that follows is forced by the character table **before** any
geometry:

```text
χ₇(2A) = −1   →   A = A₊ ⊕ A₋ ,  dim A₊ = 3 , dim A₋ = 4
χ₃(2A) = −1   →   N = N₊ ⊕ N₋ ,  dim N₊ = 1 , dim N₋ = 2
```

Restricted to `D8 = ⟨r, s⟩` with `r⁴ = 1`, `r² = σ`:

```text
A|D8  =  ε₁ ⊕ ε₂ ⊕ ε₃ ⊕ 2·W        (ε_i the three NONTRIVIAL linear characters,
                                     W the 2-dimensional irreducible)
        no trivial summand;  A₊ = ε₁ ⊕ ε₂ ⊕ ε₃ ,  A₋ = 2·W
N|D8  =  ε₁ ⊕ W ,                    ω₀ (spanning N₊) has (ε(r),ε(s)) = (+1,−1)
```

A `σ`-invariant skew form is block diagonal for `A₊ ⊕ A₋`; a `σ`-anti-invariant
one is block off-diagonal. Both verified.

---

## 3. `X^σ` — the four strata

A `σ`-fixed `U ∈ Gr(3,A)` splits as `U = U₊ ⊕ U₋`, `U_± ⊂ A_±`; write
`k = dim U₊`. The isotropy conditions become

```text
ω₀|U₊ = 0 ,   ω₀|U₋ = 0 ,   η(U₊, U₋) = 0  for η ∈ N₋ .
```

| stratum | ambient | conditions | result |
|---|---|---|---|
| `k=3`, `U = A₊` | point | `ω₀|A₊ = 0` | **empty**: `rank ω₀|A₊ = 2` |
| `k=2` | `Gr(2,A₊)×P(A₋)`, dim 5 | 1 + 4 | **2 reduced points** |
| `k=1` | `P(A₊)×Gr(2,A₋)`, dim 6 | 1 + 4 | **a plane conic in `P(A₊) ≅ P²`** |
| `k=0`, `U ⊂ A₋` | `P³` | `ω₀|U = 0` | **empty**: `ω₀|A₋` nondegenerate |

Exact certificates (`s = √−7`):

```text
ω₀|A₊  in the eigenbasis (ℓ₁,ℓ₂,ℓ₃):  the single entry (2,3) = 6 − 2s ,
        rank 2, radical = ℓ₁ (the ε₁-line, matching char(ω₀) = ε₁)
Pf(ω₀|A₋)  =  −1/2 + 3/2·s  ≠ 0      →  k=0 stratum empty
```

### 3.1 The `k=1` stratum is a smooth conic

For `u ∈ A₊` let `φ_u : A₋ → N₋^*`, `v ↦ (η₁(u,v), η₂(u,v))`. Where `φ_u` has
rank 2 the plane `U₋` is forced to be `ker φ_u`, and the one remaining condition
`ω₀|_{ker φ_u} = 0` is the vanishing of the 4-form

```text
Q(u)  :=  ω₀|A₋ ∧ η₁(u,·) ∧ η₂(u,·)  ∈  Λ⁴A₋^* ≅ K ,
```

a quadratic form in `u`. By equivariance `Q` is `D8`-**invariant** (both `ω₀`
and the Plücker vector of `ker φ_u` carry the character `ε₁`, which cancels), so
`Q` is diagonal in the eigenbasis. Computed exactly:

```text
Q  =  (−32 − 32 s)·u₁²  +  (48 − 16 s)·u₂²  −  64·u₃²
```

rank 3, all three coefficients nonzero. Hence:

* the conic is **smooth**, i.e. an irreducible rational curve `C ≅ P¹`;
* the three `D8`-fixed points of `P(A₊)` — the coordinate points `[1:0:0]`,
  `[0:1:0]`, `[0:0:1]` — are **not** on `C`, because that would need a diagonal
  coefficient to vanish.

The identity "`ω₀` vanishes on `ker φ_u` ⟺ `Q(u) = 0`" was checked exactly, with
signs, at 70 rational points of `P(A₊)`; `rank φ_u = 2` at all of them and at the
three eigen-directions.

Smoothness of the conic is in fact forced a priori: `X` is smooth, so `X^σ` is
smooth (Cartan), and a rank-≤2 plane conic is singular at its node. The direct
computation confirms it rather than relying on it.

### 3.2 The `k=2` stratum: two points, swapped

`U₊` must be `ω₀|A₊`-isotropic, i.e. `U₊ = ℓ₁ ⊕ ⟨m⟩` with `m = m₁ℓ₂ + m₂ℓ₃`;
then `v ∈ A₋` solves 4 linear equations, solvable exactly on

```text
1024·m₁²  +  (128 + 384 s)·m₂²  =  0 .
```

No `m₁m₂` term, both squares present: the two roots are **not** the `D8`-eigen-
directions `[1:0]`, `[0:1]`, and the reflection `s` (which has
`ε₂(s) = +1 ≠ −1 = ε₃(s)`) **swaps** them, while `r` fixes each. So they form a
single `D8`-orbit of length 2 with stabiliser `⟨r⟩ ≅ C4`.

### 3.3 Independent ideal-theoretic confirmation

`X^σ = X ∩ (P(E₊) ⊔ P(E₋))` where `E_±` are the `σ`-eigenspaces of `Λ³A`
intersected with Mukai's 14-dimensional space (dims 8 and 6). Macaulay2, exact
over `Q(√−7)` (identical mod 11 and mod 23, where `decompose` also runs):

```text
σ = +1 stratum ⊂ P^7 :  dim 1, degree 6, Hilbert polynomial 6i + 1,
                        1 minimal prime   →  irreducible, p_a = 0  →  SMOOTH RATIONAL
σ = −1 stratum ⊂ P^5 :  dim 0, degree 2, 1 minimal prime  →  a conjugate pair of points
```

`p_a = 0` and connected forces smooth rational — this certifies gate (a)'s
failure **without** using the parametrisation of §3.1. Degree 6 is exactly what
the parametrisation predicts: `u` is degree 2 on the conic and `Λ²ker φ_u` is
quadratic in `u`, so `Λ³U` has degree `2 + 4 = 6` in the anticanonical embedding.

### 3.4 Lefschetz consistency

`V22` is one of Mukai's four Fano threefolds with `b₂ = 1, b₃ = 0`, so
`χ(X) = 4`. Any automorphism preserves the ample generator of
`H²(X,Z) = Pic(X) = Z[−K]`, hence acts trivially on `H²`; `H⁴(X,Z) = Z` has a
generator a positive multiple of which is `h²`, so the action there is trivial
too. Therefore `L(g) = 1+1+1+1 = 4` for **every** automorphism, and

```text
χ(X^σ)  =  χ(conic) + χ(2 points)  =  2 + 2  =  4      ✓
```

---

## 4. `X^{D8} = ∅` — gate (b) holds

A `D8`-fixed point of `X` is a `D8`-stable 3-dimensional `U`, i.e. one of

* `L := A₊ = ε₁⊕ε₂⊕ε₃` (the unique choice of three linear characters), or
* `ℓ_i ⊕ P` with `P ⊂ A₋ = 2·W` a `D8`-stable plane (three `P¹`-families).

All are excluded by §3: `L` fails `ω₀|A₊ = 0`; the `ℓ_i ⊕ P` all sit in the
`k=1` stratum, whose points correspond to the conic, which misses the three
`D8`-fixed points of `P(A₊)`; the `k=2` points are swapped and the `k=0`, `k=3`
strata are empty.

Macaulay2 confirms this directly and exactly: a `D8`-fixed point has a Plücker
vector spanning a `D8`-stable line, hence lying in one of the four linear-
character eigenspaces of `Λ³A` (dims 3, 1, 2, 2 after intersecting with Mukai's
`P^13`). All four sections of `X` are **empty**:

```text
(ε(r),ε(s)) = (+1,+1) : ambient P² , X-section EMPTY
(ε(r),ε(s)) = (+1,−1) : ambient P⁰ , X-section EMPTY
(ε(r),ε(s)) = (−1,+1) : ambient P¹ , X-section EMPTY
(ε(r),ε(s)) = (−1,−1) : ambient P¹ , X-section EMPTY
```

(This is also an independent re-derivation of the published
`X^G = ∅`, since `X^G ⊆ X^{D8}`.)

---

## 5. Why no other element of `G` can be substituted

**Lemma (Euler rigidity of the `b₃ = 0` Fanos).** Let `X` be a smooth Fano
threefold with `b₂ = 1`, `b₃ = 0` (Mukai's list: `P³`, `Q³`, `V₅`, `V₂₂`) and
`g ∈ Aut(X)` of finite order. Then `χ(X^g) = 4`; in particular `X^g ≠ ∅`.
*Proof.* As in §3.4: `g` acts trivially on `H^0, H², H⁴, H⁶` and `H³ = 0`, so
the Lefschetz number is 4; the topological Lefschetz fixed-point formula for a
finite-order automorphism of a compact manifold gives `L(g) = χ(X^g)`. ∎

**Consequence.** Hypothesis (b) of the centralizer theorem, `X^{C_G(g)} = ∅`,
can hold on a `V22` only when `C_G(g)` is **non-cyclic**. In `PSL2(F7)`:

```text
order of g   3      4      7      2
C_G(g)       C3     C4     C7     D8
X^{C_G(g)}   ≠ ∅    ≠ ∅    ≠ ∅    ∅   (computed above)
```

(`|3A| = 56, |4A| = 42, |7A| = |7B| = 24` give `|C_G(g)| = 3, 4, 7`.) So the
involution is the **only** element of `G` for which gate (b) can hold — and it
does hold. The route dies solely at gate (a), and there is no alternative
element or subgroup to retry it with.

**The failure at gate (a) is character-forced, not accidental.** The profile
`(dim A₊, dim A₋ ; dim N₊, dim N₋) = (3,4;1,2)` is read off the character table;
given that profile the strata table of §3 shows the positive-dimensional part of
`X^σ` is *always* a plane conic in `P(A₊) ≅ P²`, hence *always* a rational curve
(the smoothness of `X^σ` even rules out its degenerating into two lines that
could have been swapped). No `V22` with this action can have a positive-genus
involution-fixed curve.

---

## 6. What the failure leaves open (named next derivation, NOT a claim)

Gate (a) is a *sufficient* condition inside Cor IX.1, not a necessary one. The
measured geometry is exactly the "escape shape" already recorded on the `V14`
(`FIX_IX_v14.md` §6):

* the residual group `D8/⟨σ⟩ ≅ V4` acts on `C ≅ P¹` as the Klein four-group in
  `PGL₂`, which is **fixed-point free**; `C^{V4} = ∅`;
* the two isolated points of `X^σ` form one `D8`-orbit of length 2 with
  stabiliser `C4` — the `V22` analogue of the `V14`'s swapped `C6`-pair.

A sharpening that would close the case **without** gate (a): in the resolution
tower of Cor IX.1, track a single `N`-fixed point instead of the whole
`P(V₊)`. `N = D8` acts on `V₊` through the abelian `V4` (since `σ|_{V₊} = id`),
so `P(V₊)^N ≠ ∅`. At each blow-up stage with the tracked point `x` inside the
centre `Z`, one needs an `N`-fixed point of `P(N_λ|_x)`:

* if the `σ`-invariant part `N₊|_x ≠ 0`, then `σ` acts trivially there, `N` acts
  through `V4`, and an eigenvector — hence an `N`-fixed point — exists;
* if `N₊|_x = 0`, then `σ` acts by `−id` on `N₋|_x`, so `N₋|_x` is a sum of
  copies of the 2-dimensional irreducible `W` of `D8`, which has **no**
  1-dimensional subrepresentation: `P(N₋|_x)^N = ∅`. Escape.

Excluding that escape would give the conclusion from gate (b) alone — which
**holds** here. So the Klein `V22` is not refuted as a target; it is blocked
behind a `D8`-normal-eigenvalue chain lemma that the current theory does not
have. Named: **`V22-D8-NORMAL-CHAIN`**, a theory task, not a computation.

Nothing here says anything about whether the Klein `V22` is `G`-unirational or
weakly `G`-versal. Both remain **open**, as the literature check confirms:
no source computes `X^σ` or `X^{D8}`, and none decides `G`-unirationality or
versality for this action.

---

## 7. Effect on the packet's candidate ranking

`TOP5.md` #3 (`V22` with `PSL2(F7)`) moves from *"one computation from a
theorem"* to **blocked at gate (a)**. The two remaining unresolved entries are
unaffected and move up:

1. Fermat-discriminant conic bundle No. 2.18 (`TOP5.md` #4);
2. non-`Q8` Kummer subgroup (`TOP5.md` #5).

**Selection criterion extracted from this run**, worth applying before the next
candidate is frozen: on a target with `b₂ = 1` and `b₃ = 0` every automorphism
has `χ(X^g) = 4 ≠ 0`, so gate (b) forces a non-cyclic centralizer; and if the
involution's fixed curve is constrained to a linear-section stratum of a
projective *plane*, gate (a) is lost before any computation. Read the two
eigenvalue profiles off the character table **first**; they decide both gates up
to one sign.

---

## 8. Artifacts

```text
v22_klein_model.py        exact construction of A, Λ²A*, the net N over Q(√−7)
v22_klein_fixed_loci.py   the four strata of X^σ, the conic, the two points
v22_klein_crosscheck.py   the ker φ_u ↔ Q(u) identity, 70 exact points
v22_klein_m2gen.py        emits the Macaulay2 scripts (exact and mod p)
v22_klein_verify.m2       Macaulay2, exact over Q(√−7)
v22_klein_verify_p11.m2   corroboration mod 11   (√−7 = 2)
v22_klein_verify_p23.m2   corroboration mod 23   (√−7 = 4)
verify_klein_v22.py       one-command replay of every load-bearing claim
```

`REPLAY_KLEIN_V22.md` has the run instructions and the expected output.
