# Path F / F4 — Consequences ledger (binary still open)

**Date:** 2026-07-31  
**Base pin:** `c5e71be`  
**Headline:** OPEN  
**Binary status:** `UNDECIDED`

This dispatch completed **F1** (restricted étale algebra) and emitted **F2/F3
plans only**. It does **not** decide

```text
res_{K_proj/F}(ξ) = 0 ?
```

The sections below record **exactly** what each eventual answer buys, so that
a later F2/F3 execution can close the ledger without re-litigating bridges.

---

## 0. What is installed now

| Item | Status |
|---|---|
| `R ≅ F × L`, `L/F` field degree 8 | proved (F1) |
| `R_K ≅ K_proj × L_K`, `L_K/K_proj` field degree 8 | proved (F1 + `S₆` rigidity) |
| `α_R = w₁(ξ)` with CFOSS I Lemma 3.1 + Cor. 3.12 pin | accepted / matched |
| Identity component of `α_R` is a cube | accepted (installed DAG) |
| `D₃`, `D₅` local obstructions | retired |
| Conic / intersection-algebra scheme | interface terminal; existence `EXISTENCE-UNDECIDED` |
| `res(ξ) = 0?` | **not decided** |
| `ed_C(G)` | **OPEN** |

---

## 1. If `res_{K_proj/F}(ξ) = 0`

### What becomes available immediately

By the Kummer sequence and CFOSS I Lemma 3.1 (`n=3`),

```text
res(ξ) = 0  ⟺  α_R ∈ (R_Kˣ)³  ⟺  ξ|_{K_proj} is trivial in H¹(K_proj, E[3]).
```

Exactness of

```text
E(K_proj)/3E(K_proj) → H¹(K_proj, E[3]) → H¹(K_proj, E)[3]
```

then implies that the image of `ξ` in `H¹(K_proj, E)[3]` is trivial. That
image is the class of the genus-one curve `C` (the fixed-frame torsor).
Therefore

```text
[C] = 0 in H¹(K_proj, E)  ⇒  C(K_proj) ≠ ∅.
```

So a vanishing restriction supplies a **`K_proj`-point of the fixed-frame
curve `C`**.

### Reconstruction interface (positive)

With `C(K_proj) ≠ ∅` one may:

1. reconstruct an explicit point by solving the now-trivial covering
   `G(P) = α_R z³` over `K_proj` (ten variables / nine cubics interface
   already assembled in the depressed packets), **or**
2. feed the point into the sealed conic / intersection-algebra bridge
   (F2 terminality audit): a conic-algebra solution also yields
   `C(K_proj) ≠ ∅`, and conversely a point produces intersection algebras;
3. verify the projector-open condition `∂_X c ≠ 0` at the point.

### What still stands between that and `ed_C(G) = 3`

A `K_proj`-point of the **fixed-frame** genus-one curve is **not** a
`K_proj`-point of a generic versal Klein twist, and it is **not** a
polynomial landing self-covariant.

The missing arrows are exactly those that killed the Pfaffian route when
assumed:

| Missing bridge | Why it is not automatic |
|---|---|
| Fixed-frame `C(K_proj) ≠ ∅` ⇒ point on the **generic versal** Klein twist | The fixed-frame cubic is a specific four-parameter slice / resolvent geometry, not the full versal family. Descent or specialization arguments need a separate theorem. |
| Point ⇒ `G`-unirationality of the Klein cubic | Accepted reduction is `X` `G`-unirational ⇔ `ed_C(G)=3`, which requires a rational point on a **generic versal twist** (or an explicit nonzero homogeneous landing self-covariant), not merely a point on one fixed-frame torsor. |
| Auxiliary Morita / Pfaffian idempotent ⇒ Klein point | Already **FAIL-SCOPE** (`BRIDGE_AUDIT.md`): a `σ`-self-adjoint rank-two idempotent is a point of auxiliary `P²_D`, not of `C_gen` or `F_{14,T}`. **Do not** reopen that arrow. |

**Bottom line if `res(ξ)=0`:** Path F positive objective for the fixed-frame
curve is achieved after reconstructing and verifying a point; the headline
`ed_C(G)=3` remains open until the versal-twist (or covariant) bridge is
proved separately. The Pfaffian failure mode was precisely assuming an
analogous unbridged arrow.

---

## 2. If `res_{K_proj/F}(ξ) ≠ 0`

### What negative consequence follows

```text
res(ξ) ≠ 0  ⇒  ξ|_{K_proj} ≠ 0 in H¹(K_proj, E[3])
            ⇒  α_R is not a cube in R_Kˣ
            ⇒  C is not in the image of E(K_proj)/3E(K_proj)
```

In particular, the first-descent covering associated to `ξ` has **no**
`K_proj`-point. Combined with the relation between the covering and the
torsor class, this is the F2-style obstruction to Kummer solubility of the
class over `K_proj`.

For the fixed-frame curve itself:

- it does **not** by itself prove `C(K_proj)=∅` unless one also knows that
  every rational point would force the restricted class into the Kummer
  image (i.e. that the covering is the correct first descent of `[C]`).
  Under the accepted identification `α_R = w₁(ξ)` with `ξ` mapping to
  `[C]`, nontriviality of `res(ξ)` implies `[C]` remains nontrivial over
  `K_proj` only after checking that `res([C])` cannot die while `res(ξ)`
  survives in a way compatible with the exact sequence — standardly,
  `res([C]) = 0` would force `res(ξ)` into the image of
  `E(K_proj)/3E`, not necessarily to zero. So:

```text
res(ξ) ≠ 0  does NOT by itself prove C(K_proj)=∅.
```

It **does** prove that this particular first-descent class stays nontrivial,
so any construction that required the covering (or a cube root of `α_R` in
`R_K`) over `K_proj` fails.

### What it does **not** exclude

| Not excluded | Reason |
|---|---|
| `C(K_proj) ≠ ∅` | requires a separate argument from `res(ξ)≠0` to `res([C])≠0` / pointless covering ⇒ pointless curve; the covering may be a nontrivial twist of a soluble torsor in edge cases — seal the exact sequence diagram before claiming emptiness |
| emptiness of the conic scheme | independent algebraic interface; could still be empty or nonempty |
| `ed_C(G)=4` or non-unirationality of the Klein cubic | negative proof standard requires a generic versal twist without points, or impossibility of every nonzero landing self-covariant — far beyond one fixed-frame class |
| Path G polynomial covariant | completely independent constructive route |
| Path T fold-normalization / class group | independent |
| other presentations of the same torsor (different gauges, different models) | only this `ξ` / `α_R` class is obstructed over `K_proj` |

### Careful fixed-frame statement

If F2/F3 return nonzero restriction, record:

```text
The fixed-frame first-descent class remains nontrivial over K_proj.
This closes constructions that need a K_proj-cube root of α_R / trivial
E[3]-torsor for this ξ. It does not by itself close the generic Klein-twist
point problem, nor Path G, nor prove ed_C(G)=4.
```

---

## 3. Restriction–corestriction reminder (already accepted)

```text
cores ◦ res = ×[K_proj:F] = ×6 ≡ 0 (mod 3)
```

on classes of order dividing 3. Therefore restriction–corestriction
**neither** forces `res(ξ)=0` **nor** forces `res(ξ)≠0`. The binary question
is genuine arithmetic, not formal degree parity.

---

## 4. Director-gate language (for later)

When F2/F3 execute, the director options from the work order include:

3. **F restricted class decided:** reconstruct a point or assemble the exact
   negative consequence (use §§1–2 of this file verbatim).

Until then, ranking is unchanged by this dispatch: Path F remains the
restricted-class track with F1 installed and F2/F3 planned.

---

## 5. Explicit non-claims

- No `P-F`, `N-F`, `F-STOP`, `F-LOCAL-SOLUBLE`.
- No `ed_C(G) ∈ {3,4}`.
- No conic-scheme existence decision (still `EXISTENCE-UNDECIDED`).
- No use of the auxiliary Morita idempotent as a Klein point.
