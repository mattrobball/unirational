# Global all-order transition diagram (WP-5, Gate 4)

**Headline: OPEN.**

**Exit: P** — nonzero formal configuration (necessary state only).

This package assembles the accepted local modules (Gates 1–3) into the global
necessary-condition object for a hypothetical nonzero homogeneous landing
self-covariant

\[
p\colon W\longrightarrow W,\qquad F(p)=0
\]

on the Klein cubic

\[
X=\Bigl\{\sum_{i\in\mathbf Z/5}x_i^2 x_{i+1}=0\Bigr\}\subset
Y=\mathbf P(W)\simeq\mathbf P^4,\qquad
G=\operatorname{PSL}_2(\mathbf F_{11}).
\]

It does **not** lift formal states to actual covariants (WP-6/WP-7).  It does
**not** prove \(\operatorname{ed}_{\mathbf C}(G)=3\) or \(4\).  Problem E remains
open:

\[
X\text{ is }G\text{-unirational}
\quad\Longleftrightarrow\quad
\operatorname{ed}_{\mathbf C}(G)=3.
\]

---

## Theorem boundary

| Proved here | Not proved here |
|-------------|-----------------|
| Incidence category with bigraded modules and specialization maps | Existence of a landing covariant |
| Level 1: globally compatible marked states exist | Emptiness of nonlinear landing support |
| Level 2: linear inverse-limit module \(\Lambda\neq 0\) in char 0 | Unirationality / \(\operatorname{ed}_{\mathbf C}(G)\) |
| Necessity: every landing covariant maps into \(\Lambda\) | Lifting of formal states (WP-6) |
| All-degree machine coverage (named mechanism) | All-degree emptiness of landing support |

**Dependencies (Gates 1–3, accepted):**
`strata_exact.json`, `incidence_exact.json`, `normal_characters.json`,
`marked_s3_geometry.json`, `transitions/{involution_plane,d12_binary_line,v4_fixed_line,c3_lines,point_links}/`,
`transitions/SEAL.json`.

---

## 1. Incidence category

Objects are orbit types (not individual geometric points).  Each carries its
WP-4 bigraded normal-jet module (or a decoration for marked elliptic data).
Flags are incidence morphisms with exact specialization/equalizer maps.

### Objects (summary)

| Object | Orbit | Forced base? | Module |
|--------|------:|:------------:|--------|
| `C2_plane` | 55 | **yes** (4A) | free rank \(2(m+1)\) (odd \(m\)) over \(\operatorname{Sym}(E_+^*)\) |
| `C2_line` (minus) | 55 | no | free rank 2 over \(\mathbf Q[xy,x^6+y^6]\) |
| `V4_line` (= arrangement triple line) | 55 | **yes** (4C) | free rank \(n_{\mathrm{triv}}(m)+\binom{m+2}{2}\) over \(\mathbf Q[x,y]\) |
| `C3_line` | 110 | **no** (4D) | Reynolds / free over binary ring |
| type-I / type-II points | 165 each | — | charges \(\langle q\rangle\) / \(e+\langle q\rangle\) |
| `D10` / `D12` / `A4^{(a/b)}` | 66 / 55 / 55+55 | off \(X\) | point-link Molien modules |
| elliptic plus | 55 | — | marked residual \(S_3\), \(j=8192/11\), no CM |

**Triple lines of the 55-plane arrangement are the V4 fixed lines \(P(A)\)**, not
the involution minus-lines \(L_t\subset X\).

**C3 / A4 / marked elliptic data are retained as separate objects** and are not
collapsed into the ordinary 55-plane ideal.

### Fixed-\(m\) architecture (house rule 6)

```text
plane normalization → triple-line equalizer → residual point kernel
```

A naive surjective four-term Čech complex is **false**.  The finite
irrelevant-torsion module \(T_m\) is retained: it controls the difference
between sheaf-level \(H^0(\widetilde M_m(d))\) and literal graded pieces
\((M_m)_d\).  Eventual equality holds for \(d\ge 55m+109\) (crude
Derksen–Sidman bound).

### Distinctions (required in every claim)

| Level | Meaning |
|-------|---------|
| Sheaf-level exactness | Architecture formula for \(H^0(\widetilde M_m(d))\) is exact for every \(d\) (kernels only) |
| Literal graded pieces | \((M_m)_d\cong H^0(\widetilde M_m(d))\) for \(d\ge 55m+109\) |
| Finite irrelevant torsion \(T_m\) | Low-degree discrepancy; must not be silently discarded |

Artifacts: `global_transition/diagram.json` (incidence category section).

---

## 2. Level 1 — finite marked-state screen

**Verdict: SURVIVES.**

Coefficients are dropped.  Discrete labels retained: stabilizers, characters,
orbit labels, endpoint permutations, type-I/II charges.

### Surviving families (explicit)

1. **`based_minus_lines_odd_m`** — common odd plane order \(m\); minus-line
   restriction zero; charges as WP-3; C3 not forced base.
2. **`residual_e1_swap_both`** — \(d=6m+1\), residual \(e=1\); unique ledger
   `swap_both`; G-extension by residual uniqueness.
3. **`residual_e_ge7_generic_swap_both`** — generic residual ledger; local
   preserve/mixed not claimed global (WP-4B.5 boundary).

### Adversarial attempts (fail)

| Attempt | Result |
|---------|--------|
| `preserve_both` at \(e=1\) | fails (module 1-dimensional) |
| type-II charge \(=\langle q\rangle\) | fails (WP-3) |
| even plane order | fails for landing (4A.2) |
| order-zero on V4 line landing on \(X\) | fails (4C.1) |
| charge contradiction at type-II triple meeting | no contradiction (WP-3 consistent) |

**Exit N1 closed.**

Artifact: `global_transition/level1_marked_states.json`.

---

## 3. Level 2 — linear bigraded inverse limit

**Verdict: NONZERO** in characteristic zero.

### Definition

\[
\Lambda=\lim_{\longleftarrow} M_\bullet
\]

is the residual-equivariant equalizer of the incidence diagram of local
bigraded modules (G-equivariant data \(\simeq\) residual-equivariant data on
orbit representatives).  The 55-plane subdiagram is presented by the fixed-\(m\)
architecture above; C3, A4, minus-line D12, and marked elliptic restrictions
are additional equalizer factors.

### Nonemptiness (char 0)

For each fixed odd \(m\ge 1\):

- Residual-invariant plane jets grow as \(O(d^2)\) with positive leading
  coefficient (finite-group invariants of a free module of rank
  \(r_m=2(m+1)\) over the ternary coordinate ring).
- Specialization targets (lines, V4, points, C3) total growth \(O(d)\).
- Hence \(\dim\Lambda_{m,d}\ge c_m d^2-C_m d-C'_m>0\) for all large \(d\).

**Structural witness:** based-along-minus-line residual-invariant plane jets
(kernel of restriction to \(L_t\); Reynolds-stable because \(L_t\) is residual-stable).

The argument uses Hilbert–Serre and the accepted WP-4 free presentations.  It
does **not** lift modular ranks such as \(\dim K_{25}\equiv 59\pmod{67}\)
(house rule 9: regression only).

**Exit N2 closed.**

Artifacts: `global_transition/level2_inverse_limit.json`,
`dimension_tables.json`.

---

## 4. Necessity theorem

**Proved (forward implication only).**

Every nonzero homogeneous landing self-covariant determines a compatible
element of \(\Lambda\).  The proof handles:

- symbolic powers along the union of conjugate plus-planes;
- associated-graded exact order \(m\);
- iterated incidences (triple lines, multiple points);
- finite irrelevant torsion \(T_m\);
- projective scalar characters and residual det twists;
- C3 / A4 / marked elliptic restrictions;
- no false short Čech complex.

Emptiness of \(\Lambda\) would exclude all such \(p\).  Nonemptiness of
\(\Lambda\) is **not** existence of \(p\).

Artifact: `global_transition/necessity_theorem.json`.

---

## 5. All-degree coverage

**Named mechanism:** finite generation over the correct base rings (ternary
\(R=\operatorname{Sym}(E_+^*)\), binary \(D_{12}\) invariant ring, binary
\(V_4\) ring, Molien rings at points) **plus** rational Hilbert series in the
normal-order variable \(m\) (Rees-style generating function for the normal cone)
**plus** the quadratic-vs-linear growth argument for \(\Lambda_{m,d}\).

This is **not** “finite generation alone ⇒ unbounded emptiness” (house rule 4).
The quartic equivariant endomorphism producing degrees \(4^n d\) is recorded as
a warning against that trap; it does not affect the nonemptiness proof for
\(\Lambda\).

---

## 6. Level 3 — nonlinear landing support

Levels 1–2 both survive, so Level 3 is **authorized**.  It was **not** executed
as a raw unstructured solve.

**Verdict: NOT DECIDED** at headline standard.

Missing for Exit N3: an exact all-degree elimination certificate that the
projective landing support of \(\Lambda\) is empty in characteristic zero, or a
structural identity cutting \(\Lambda\) to zero under the associated-graded
cubic.  Portable exclusions exist only through degree 12; degree 25 remains
open in the existing compact work.

**Exit N3 not reached.**

---

## 7. Decision exit

| Exit | Status |
|------|--------|
| N1 finite-state obstruction | **closed** |
| N2 linear-module obstruction | **closed** |
| N3 nonlinear support obstruction | **not reached** |
| **P formal configuration** | **reached** |

### Exit P — necessary state only

Recorded necessary formal configuration:

- Level-1 families: based minus-lines; \(e=1\) `swap_both`; generic \(e\ge 7\)
  `swap_both`;
- Level-2 module \(\Lambda_{m,d}\ne 0\) for every odd \(m\ge 1\) and all
  sufficiently large \(d\);
- structural witness: based-along-minus-line residual-invariant plane jets;
- charges: type-I \(=\langle q\rangle\), type-II \(=e+\langle q\rangle\);
- V4 lines forced base; C3 lines not forced base.

This is **not** a parametrization and **not** a proof that a landing covariant
exists.  Pass to WP-6 only for lifting attempts.

### Headline

**OPEN.**  Even a future negative exit would state precisely that no homogeneous
landing self-covariant exists; conversion to \(\operatorname{ed}_{\mathbf C}(G)=4\)
uses the accepted exhaustiveness theorem as a **separate** step.

---

## Replay

```text
/opt/homebrew/bin/python3 certificates/global_transition/produce.py
/opt/homebrew/bin/python3 certificates/global_transition/verify.py
```

Terminal markers:

```text
GLOBAL_TRANSITION_INCIDENCE_OK
LEVEL1_MARKED_STATE_SURVIVES
LEVEL2_INVERSE_LIMIT_NONZERO
NECESSITY_THEOREM_OK
ALL_DEGREE_COVERAGE_OK
EXIT_P_FORMAL_CONFIGURATION
GLOBAL_TRANSITION_DIAGRAM_OK
GLOBAL_TRANSITION_VERIFY_OK
```

---

## Seal

See `certificates/global_transition/SEAL.json` (content hashes only; no timing
fields; self-hashes written after last byte on disk).

**GLOBAL_TRANSITION_DIAGRAM_OK**
