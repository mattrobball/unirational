# Remaining gate — fixed-frame emptiness to genuine generic twist

**Exit of this packet:** `B-UNDECIDED`  
**Upstream Goal F exit (input, not re-proved here):** `F-CONIC-CRITERION-EMPTY`  
**Headline:** **OPEN**

This note isolates the single missing implication.  It does not re-run the
conic search and does not claim a negative or positive headline.

---

## 0. Accepted input (scoped)

Goal F seals

```text
C(K_proj) = ∅
```

for the **selected fixed ternary characteristic cubic**

```text
C/F :  F0 + A·FA + B·FB + Y·FY + (Z − 11 A²/18)·FZ = 0
       in [X : y : w],
```

after the ordered base change to

```text
K = K_proj = Frac( F[u] / (P(A,B,Y,Z,u)) ),   [K:F] = 6.
```

Scope fence (from Goal F `SEAL.json` and `STATUS.md`):

- proved only for the auxiliary fixed-frame plane cubic and its exhaustive
  conic criterion;
- **not** proved: pointlessness of the genuine generic Klein twist;
- **not** proved: Klein-cubic unirationality or non-unirationality.

This Goal B packet **consumes** that theorem as a black-box input.  It does
not enlarge F's scope and does not treat `C(K)=∅` as a headline.

---

## 1. Precise missing implication

Write `K = K_proj`.  Let

| Symbol | Object |
|---|---|
| `C_K` | selected fixed ternary cubic over `K` |
| `I_σ` | open of right `D`-lines nondegenerate for `h_struct` |
| `F14_T` | twisted Fano section = common isotropic right `D`-lines for `H_T` |
| `X_gen` | genuine generic Klein twist `T_proj ×^G X` |

**Installed facts**

1. `C(K) = ∅` (Goal F).
2. `I_σ(K) ≠ ∅` (exact Gram–Schmidt / Morita).
3. No accepted map sends a hypothetical point of `F14_T` or `X_gen` into
   `C_K` while preserving the distinguished five-plane `H_T`.
4. Goal F's infinity place is **not** the `BR-T-NEG` target branch
   (`e=1` on `c6=0` vs `e=2` on `H=0`, `c6` unit); see `BRANCH_COMPARISON.md`.

**Missing implication (neither proved nor refuted)**

```text
(★)   C(K) = ∅   ⇒   F14_T(K) = ∅
```

and, one step further along the accepted sufficient chain,

```text
(★★)  C(K) = ∅   ⇒   X_gen(K) = ∅.
```

Only (★) or a direct emptiness theorem for `X_gen` would convert Goal F into
a negative headline.  Both remain open.  The currently proposed *proofs* of
(★)/(★★) fail (auxiliary projector ≠ five-plane incidence; infinity ≠ target
branch); failure of those proofs is **not** a counterexample to (★) itself.

---

## 2. Two mutually exclusive closures of the gate

The live decision object is the functor

```text
F14_T(R) = {
  locally free rank-one right D_R-summands L ⊂ D_R³
  :  h_i |_{L×L} = 0  for i = 1,…,5
}.
```

On the standard affine chart `q = (1,x,y) ∈ D²` this is five scalar equations
in eight scalar unknowns.  Explicit quaternion matrices for the five `h_i`
are **not** installed in the accepted B inputs (live C0/C5 gate).

### 2A — Positive bypass (refutes (★) as a bridge)

Construct a single point

```text
L ∈ F14_T(K)
```

that is not the image of any `K`-point of the selected ternary open under the
installed functional-calculus / frame map.  Equivalently: a common isotropic
right `D`-line for the distinguished five-plane **outside** the selected
ternary frame.

- Such an `L` is already a common line, hence (by accepted Pfaffian incidence)
  supplies a `K`-point of `X_gen` and blocks any negative promotion of Goal F.
- An auxiliary projector in `I_σ(K)` is **not** enough: it need not satisfy
  any of the five equations `h_i(q,q)=0`.  Goal B forbids promoting ambient
  projector non-exhaustiveness to a missed `F14_T` orbit.

### 2B — Negative exhaustiveness (proves (★))

Prove that the selected ternary frame is exhaustive for the **genuine**
five-plane data:

```text
Every L ∈ F14_T(K) can be moved, by a K-rational automorphism
that preserves h_struct and the subspace H_T, into the image of
the selected ternary slice.
```

The only gauge group that is allowed for this statement is

```text
Γ = PGU(h_struct) ∩ Stab_{PGL_3(D)}(H_T),
```

not the full Morita group `GL_3(D)` (which transports `H_T` as well as the
line).  A change of Morita basis available only after a splitting extension
is not a `K`-rational gauge.

Combined with `C(K)=∅`, exhaustiveness under `Γ(K)` yields `F14_T(K)=∅`,
and the accepted sufficient arrow

```text
F14_T(K) ≠ ∅  ⇒  X_gen(K) ≠ ∅
```

then blocks the usual Pfaffian route to a twist point.  (A full negative
headline still needs the converse direction for `X_gen`, or an independent
emptiness theorem for the contracted product; Goal B's negative exits
explicitly allow the common-line / residual-branch route when sealed.)

### 2C — Alternative negative routes (not fixed-frame bridges)

These close emptiness of `F14_T` or `X_gen` **without** using `C(K)=∅`:

- direct valuation / class-group argument on a proper model of `F14_T` or
  `X_gen`;
- completion of the genuine target-branch `Cl/Pic mod 3` calculation
  (`BR-T-NEG`), which is a **different** place from Goal F's infinity
  divisor.

They are out of scope for promoting Goal F; they are recorded so the gate is
not confused with those separate fronts (C/C5, T3).

---

## 3. Why the fixed frame is known non-exhaustive only on the auxiliary space

Exact pair of theorems:

```text
I_σ(K) ≠ ∅,     C(K) = ∅.
```

Hence on **K-points of the auxiliary projector open**,

```text
I_σ(K)  \  image( C_K^open(K) → I_σ(K) )  ≠ ∅.
```

This is **not** B1 for `F14_T`:

- `F14_T ↪ P²_D` is the five-form incidence locus, not contained a priori in
  `I_σ`;
- the known projector need not obey `h_i(q,q)=0`;
- no `Γ`-torsor or quotient obstruction for `Stab(H_T)` is proved.

The formal plane-section counterexample in `INCIDENCE_DIAGRAM.md` shows that
index-three of a plane cubic cannot force ambient pointlessness in general;
any genuine bridge must use Klein five-plane incidence, not the formal slice
principle alone.

---

## 4. Consistency with `F-CONIC-CRITERION-EMPTY`

| Claim | Status under this packet |
|---|---|
| `C(K_proj)=∅` for the fixed ternary cubic | accepted Goal F input; not re-proved; not enlarged |
| Full conic criterion empty on that cubic | accepted Goal F input |
| `F14_T(K)=∅` | **not** claimed |
| `X_gen(K)=∅` | **not** claimed |
| `ed_C(PSL(2,F_11))=3` / headline negative | **not** claimed |
| Goal F infinity place = target branch | **refuted** (distinct valuations) |
| Auxiliary projector ⇒ common line | **refuted** as an implication |
| Actual implication (★) | **undecided** |

Thus Goal B remains strictly consistent with F's scope fence: fixed-frame
emptiness is a scoped theorem; the bridge to the genuine twist is the open
problem documented here.

Cross-check of sealed F markers used by `verify.py`:

- `goal_f["exit"] == "F-CONIC-CRITERION-EMPTY"`
- `"pointlessness of the genuine generic Klein twist" ∈ goal_f["not_proved"]`
- F `scope` string: auxiliary fixed-frame plane cubic and exhaustive conic
  criterion

---

## 5. Smallest remaining object (machine form)

```text
remaining_gate = {
  "implication": "C(K)=empty  =>  F14_T(K)=empty",
  "status": "UNDECIDED",
  "positive_closure":
    "common isotropic right D-line for H_T outside the selected ternary frame",
  "negative_closure":
    "exhaustiveness of the ternary frame under Gamma = PGU(h_struct) ∩ Stab(H_T)",
  "not_sufficient": [
    "I_sigma(K) nonempty",
    "dimension counts or geometric transitivity after splitting D",
    "identifying Goal F infinity place with BR-T-NEG target branch"
  ],
  "heavy_solve_deferred_to": "Goals C / C5 (executable five-form incidence)",
  "exit": "B-UNDECIDED"
}
```

No light exact work in this pass produces either closure: the five Hermitian
matrices over the executable ordered `K/F` presentation are still missing,
and no five-plane-preserving rational gauge theorem is available from the
accepted inputs.  Heavy Fano / projector incidence is explicitly out of scope
for Goal B (owned by C/C5).

---

## 6. Terminal boundary

```text
B-UNDECIDED
```

Allowed subexits **not** reached:

- `B-FIXED-FRAME-BRIDGE-HEADLINE-NEGATIVE` — needs (★) or (★★) proved;
- `B-TARGET-BRANCH-IDENTIFIED-HEADLINE-NEGATIVE` — infinity ≠ target (B2 closed negative);
- `B-BRIDGE-REFUTED` — would need a genuine `F14_T(K)` orbit missed by the frame,
  or a proved stabilizer torsor obstruction; auxiliary non-exhaustiveness is
  insufficient by the goal contract.

Klein-cubic headline remains **OPEN**.
