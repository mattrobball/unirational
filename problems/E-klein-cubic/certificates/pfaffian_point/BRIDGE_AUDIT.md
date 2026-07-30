# Bridge audit — Attempt 1, Gate 1

**Date:** 2026-07-30  
**Base:** `d9cadc3` (work-order pin); working tree may sit on later commits  
**Headline:** OPEN  
**Gate 1 decision:** `FAIL-SCOPE`

---

## 0. Executive verdict

Two independent audits were required before any large coordinate solve.

1. **CFOSS `w_1` pin (Task 1B.1).** Closed in
   `certificates/pfaffian_point/CFOSS_W1_INPUT.md`. The precise statement is
   **CFOSS I, Lemma 3.1** (`n` prime ⇒ `w1` injective), hash-pinned to the
   arXiv PDF. It covers the repository’s prime-`3` Kummer reverse implication
   on perfect characteristic-zero fields. It does **not** by itself produce a
   Klein point.

2. **Positive implication chain (Task 1B.2).** The claimed chain

   ```text
   σ-self-adjoint reduced-rank-two idempotent
     ⇒ common isotropic right D-line
     ⇒ C_gen(K_proj) ≠ ∅
     ⇒ X is G-unirational
   ```

   has a **broken first arrow**. The abstract idempotent is Morita / structure
   data on the algebra-with-involution `(A,σ)`. It is a point of an
   **auxiliary** open in the rational `D`-plane `P²_D`, not a point of the
   distinguished Fano section. The missing bridge is the simultaneous
   isotropy condition for the descended five-plane `H_T ⊂ Herm_3(D)`.

**Gate 1 decision: `FAIL-SCOPE`.**  
The abstract σ-self-adjoint reduced-rank-two idempotent only gives a point on
an auxiliary space (the space of Morita projectors / nondegenerate right
`D`-lines for the structure form of `σ`). Attempt 1, as currently phrased
through that idempotent, does not yet supply a `K_proj`-point on the generic
Klein twist. The exact remaining geometric problem is recorded in §4 and in
`IDEMPOTENT_TO_KLEIN_POINT.md` / `quaternion_corner.*`.

---

## 1. Accepted inputs used (hash-check discipline)

The following were treated as accepted starting facts, checked against the
tracked narrative packets and the executable Pfaffian `tmp/` certificates
named below (no re-derivation):

| Fact | Source packet |
|---|---|
| `period(A_proj) = index(A_proj) = 2`, so `A_proj ≅ M_3(D_proj)` | `tmp/pfaffian_rank2_idempotent_attack`, `tmp/pfaffian_generic_schur_audit` |
| Twisted `Gr(2,6)` is `SB_2(A) ≅ P²_D` with affine chart `D²` | `tmp/pfaffian_generic_schur_audit` |
| Distinguished degree-14 Fano section becomes five quaternionic Hermitian forms on `D³` | same |
| Every individual member of the five-plane is isotropic (Springer + deg-55 `A4` cycle) | `tmp/pfaffian_explicit_descent` |
| Common line is **not** descended by that argument | same |
| Abstract σ-self-adjoint reduced-rank-two idempotent exists (Morita + Hermitian Gram–Schmidt) | `tmp/pfaffian_rank2_hostile_audit` |
| Installed 15-basis of `Sym(A,σ)`; cubic gate `c_3=0, c_2≠0` | `tmp/pfaffian_rank2_idempotent_attack` |

CFOSS pin: `certificates/pfaffian_point/CFOSS_W1_INPUT.md`.

---

## 2. Task 1B.1 summary (pointer)

Deliverable: `CFOSS_W1_INPUT.md`.

```text
exact theorem:     CFOSS I, Lemma 3.1
hash-pinned PDF:   sha256:86f5b9a156c9afffdb3434670012b48bbfdb058ca22f4b2fefac493d5d7d1e01
hypotheses:        perfect K, char(K) ∤ n, n prime
source w1:         H¹(K,E[n]) → R×/(R×)^n via Weil embedding + Kummer
repo w1:           same with n=3, R = étale algebra of Jac(C)[3], alpha_R = w1(xi)
agreement:         Cor. 3.12 identifies det-class with w1; Lemma 3.1 is injectivity
use-sites:         listed exhaustively in CFOSS_W1_INPUT.md §7
```

No argument in this packet cites “CFOSS injectivity” generically.

---

## 3. Task 1B.2 — implication chain with no omitted arrows

Notation:

```text
K          = K_proj = C(P(W))^G
A          = A_proj   (degree-six CSA, period = index = 2)
σ          = symplectic involution of the first kind on A
             (Pfaffian involution σ_x(M) = Q(x)^{-1} M^t Q(x) on the
              descended frame)
D          = quaternion division algebra with A ≅ M_3(D)
H_T        = five-plane of Hermitian forms on D³ descended from B_5
C_gen      = generic Klein twist over K
F14_T      = twisted Fano of lines / Gr(2,6) ∩ P(B_10) twist
```

### Arrow A — CLAIMED, **FALSE** as written

```text
σ-self-adjoint reduced-rank-two idempotent  ⇒  common isotropic right D-line
```

| Attribute | Record |
|---|---|
| **Source object** | `e ∈ A` with `e² = e`, `σ(e) = e`, reduced rank `2` |
| **Target object** | right `D`-line `L = qD ⊂ D³` with `h(q,q) = 0` for all `h ∈ H_T` |
| **Field of definition** | `K = K_proj` |
| **Open conditions** | reduced rank exactly two (equivalently `c_2(e) ≠ 0` in the Pfaffian calculus); nondegeneracy of `e` as Hermitian projector for the **structure** form of `σ` |
| **Descent / twisting** | none beyond the already-descended `(A,σ)` |
| **Brauer / orientation ambiguity** | choice of Morita identification `A ≅ End_D(D³)` is unique up to `GL_3(D)` / unitary change of basis; does not create a new Brauer class. Orientation of the symplectic involution is fixed by the Pfaffian `Q` |
| **Theorem used** | Morita theory for algebras with involution (Book of Involutions); Hermitian Gram–Schmidt in char 0 |

**What the source actually produces.**

After Morita,

```text
(A, σ) ≅ ( End_D(D³), ad_{h_struct} )
```

for a nonsingular Hermitian form `h_struct` on `D³` (the structure form of
`σ`). A σ-self-adjoint reduced-rank-two idempotent is precisely the
orthogonal projector onto a right line `L_e` that is **nondegenerate for
`h_struct`**. Such projectors exist over `K` (hostile audit:
`tmp/pfaffian_rank2_hostile_audit`). Equivalently, they are `K`-points of a
Zariski-open subset of

```text
SB_2(A) ≅ P²_D ,
```

which is `K`-rational with affine chart `D²`.

**Why the arrow fails.**

The common isotropic line for the **Klein five-plane** `H_T` is the condition

```text
h_i(q, q) = 0,   i = 1, …, 5,
```

i.e. a point of the twisted Fano section `F14_T`, not an arbitrary point of
`P²_D`. The structure projector `e` satisfies no a priori relation forcing
`L_e` into `F14_T(K)`. Individual isotropy of each `h ∈ H_T` (Springer +
degree-55 cycle) does not produce a simultaneous line.

**Exact missing bridge for Arrow A:**

```text
point of P²_D(K)  ⇝  point of F14_T(K)
```

is a codimension-five linear section problem on an eight-dimensional rational
variety (five scalar equations on `D² ≅ A^8`). Expected dimension three. This
is not automatic from the existence of Morita projectors.

**Status of Arrow A:** **FAIL** (scope). Idempotent ⇒ auxiliary Morita point
only.

---

### Arrow B — TRUE (classical Pfaffian dictionary, twisted)

```text
common isotropic right D-line  ⇒  C_gen(K) ≠ ∅
```

| Attribute | Record |
|---|---|
| **Source object** | `0 ≠ q ∈ D³` with `h_i(q,q) = 0` for all five descended forms; line `L = qD` |
| **Target object** | `K`-point of the generic Klein twist `C_gen ⊂ P(W_T)` |
| **Field of definition** | `K = K_proj` |
| **Open conditions** | `q ≠ 0`; line primitive as right `D`-module rank one |
| **Descent / twisting** | Plücker / rank-one Hermitian identification of `SB_2(A)` with the pure rank-one locus in `P(Herm_3(D))`; Fano section `F14_T = { lines isotropic for H_T }` is the twist of `Gr(2,6) ∩ P(B_10)` |
| **Brauer / orientation ambiguity** | none that affects existence: a `K`-line on `C_gen` is a `P¹_K` of points. The residual Brauer class of `D` need not split (Fano point does not split `D`) |
| **Theorem used** | Pfaffian–Grassmannian correspondence of the Klein cubic / degree-14 Fano partner (Tschinkel–Zhang; repository writeup in `tmp/pfaffian_generic_schur_audit` §4, equation (12)); incidence projection `I → F14` is a `P¹`-bundle, so `F14_T(K) ≠ ∅ ⇒ C_gen(K) ≠ ∅` |

**Status of Arrow B:** **PASS**, conditional only on the standard incidence
geometry of the Pfaffian dual pair (accepted in the audited Pfaffian packets).

---

### Arrow C — TRUE under the accepted essential-dimension equivalence

```text
C_gen(K_proj) ≠ ∅  ⇒  X is G-unirational
```

| Attribute | Record |
|---|---|
| **Source object** | `K_proj`-point of the generic Klein twist |
| **Target object** | existence of a dominant rational `G`-map from a projective space (honest representation, or after the accepted quadratic projective-source lemma) onto `X` |
| **Field of definition** | base change to `C`; essential dimension over `C` |
| **Open conditions** | point lies on a free open of the versal torsor so that the compression is dominant; nonconstancy automatic from freeness / simplicity of `G` |
| **Descent / twisting** | standard versal-compression dictionary: a rational point of the generic twist is a compression of the versal torsor; dimension of the image is at least `ed(G)`, and `ed(G) ≥ 3` by known lower bounds for this `G` |
| **Brauer / orientation ambiguity** | if the projective source is the nonsplit `P(V_6)` twist, one must not claim a map from an honest `P(V)` without the quadratic splitting lemma; see §5 stable-factor trap |
| **Theorem used** | accepted reduction `X` is `G`-unirational `⇔ ed_C(G) = 3` (work order §0); versal compression ⇒ upper bound on `ed` |

**Status of Arrow C:** **PASS** as a citation of the accepted equivalence,
**provided** the point is genuinely on the generic Klein twist (not on an
auxiliary model). House rule 1 forbids promoting Arrow C from an auxiliary
point.

**Parallel ed-route (not needed for the chain as written, recorded for
completeness).** A `K_proj`-point of `F14_T` alone already yields a rational
`G`-map `P(W) ⇢ F14` which, by simplicity of `G` and `ed(G) ≥ 3`, is a
dominant versal compression of dimension three; then `ed(G) = 3`. That route
still requires the common isotropic line (Arrow A’s target), not the bare
Morita idempotent.

---

## 4. Corrected bridge (what remains)

The sound chain is:

```text
(A,σ) with period = index = 2
  ⇒  Morita: A ≅ M_3(D), σ = ad_{h_struct}
  ⇒  P²_D ≅ SB_2(A) is K-rational
  ⇒  [SEPARATE ARITHMETIC GATE]
         F14_T(K) ≠ ∅
         ⇔  common isotropic right D-line for H_T
  ⇒  C_gen(K) ≠ ∅
  ⇒  ed_C(G) = 3
  ⇒  X is G-unirational.
```

The abstract σ-self-adjoint reduced-rank-two idempotent is the first two
arrows only (Morita setup). It does **not** cross the arithmetic gate.

**Exact missing bridge:**

```text
construct, over K_proj, a right D-line isotropic for all five forms of H_T;
equivalently, a K_proj-point of the twisted Fano section F14_T.
```

Coordinates of a Morita projector in the installed 15-basis of `Sym(A,σ)` are
a separate implementation problem (useful for writing `D` and `H_T`
explicitly) but are **not** logically sufficient for the headline.

---

## 5. Stable-factor trap (Tschinkel–Zhang)

**Trap.** The stable equivalence in Tschinkel–Zhang of the form

```text
X × P² × P(V)  ~_G  Y × P² × P(V)
```

does **not** transport unirationality in the twisted setting when the factor
`P(V)` is replaced by a nonsplit Severi–Brauer variety without a rational
point.

**Repository status.** The audited Pfaffian path correctly **refuses** this
trap:

- `tmp/pfaffian_generic_schur_audit/REPORT.md` §2: generic twist of `P(V_6)`
  is the nonsplit Severi–Brauer fivefold `SB(A_proj)`, not stably rational,
  and admits no stable replacement by projectivizations of honest
  representations.
- Positive criterion is written through **dominance from the rational
  `D`-plane chart** `P²_D ≅ SB_2(A)` and the Fano section, then Pfaffian
  incidence / ed-compression — not through stable factors of the nonsplit
  `P(V_6)`.

**Flag.** No repair needed on this point in the audited packets. Any future
argument that cites only the stable Tschinkel–Zhang product formula to move a
point from an auxiliary factor to `C_gen` is invalid in the twisted setting.

---

## 6. Role of CFOSS in Attempt 1 (scope control)

CFOSS I Lemma 3.1 is used on the **genus-one first-descent path** that attacks
the depressed plane model of the installed symmetric cubic (coordinate search
for a Morita projector). Even a complete success of that path would only
construct coordinates of an auxiliary idempotent. It would **not** repair
Arrow A.

Thus CFOSS is necessary bookkeeping for one implementation route to Morita
data; it is not the bridge to `C_gen`.

---

## 7. Gate 1 decision

```text
FAIL-SCOPE
```

**Reason.** The σ-self-adjoint reduced-rank-two idempotent only gives a point
on the auxiliary space of Morita projectors inside the rational variety
`P²_D`. The missing bridge is the common-isotropic-line / `F14_T(K_proj)`
problem.

**Demotion note (as required by the work order).** Attempt 1 must not be
advertised as “idempotent ⇒ Klein point.” It remains a viable **research
route** only after re-centering on the Hermitian five-plane common-line
system (Gate 2 / `P1-REDUCED`). That re-centering is documentation and
target selection, not a large solve, and is carried out in the Gate 2
deliverables of this dispatch.

**What is proved here.**

- CFOSS `w1` injectivity is pinned to Lemma 3.1 with full fields.
- Arrow A of the claimed chain fails; Arrows B and C hold under the stated
  theorems.
- Stable-factor trap is identified and the repository’s positive Pfaffian
  path avoids it.

**What remains.**

- Common isotropic right `D`-line over `K_proj` (or a proof that none exists).
- Explicit quaternion corner and five Hermitian matrices in executable
  `K_proj` coordinates (implementation; not claimed in this dispatch).
- No Gate 3 solve was attempted.

**Headline:** OPEN.
