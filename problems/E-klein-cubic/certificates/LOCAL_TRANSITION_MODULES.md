# Local transition modules (WP-4, Gate 3)

**Headline: OPEN.**

This package freezes the universal local normal-cone transition modules for
the stabilizer strata of

\[
Y=\mathbf P(W)\simeq\mathbf P^4,\qquad
X=\Bigl\{\sum_{i\in\mathbf Z/5}x_i^2 x_{i+1}=0\Bigr\}\subset Y,\qquad
G=\operatorname{PSL}_2(\mathbf F_{11}).
\]

It does **not** assemble the global inverse-limit/equalizer object (WP-5), does
**not** run large Gröbner bases, and does **not** prove or disprove existence of
a homogeneous landing self-covariant.  Problem E remains open:

\[
X\text{ is }G\text{-unirational}
\quad\Longleftrightarrow\quad
\operatorname{ed}_{\mathbf C}(G)=3.
\]

### Theorem boundary

**Proved here (WP-4A–4E):** for each named stratum, the bigraded module

\[
M_{m,d}
=
\Bigl[
H^0\bigl(S,\operatorname{Sym}^m N_{S/Y}^{\vee}\otimes\mathcal O_S(d)\bigr)
\otimes W
\Bigr]^{H}
\]

with finite presentation data (or a precise delimitation of failure of finite
generation in the normal-order variable \(m\)), Hilbert/Molien series, generators
and relations as stated, associated-graded landing notes, and restriction
dictionaries to incident lower strata — together with the geometric theorems
listed below.

**Not proved here:** global compatibility (WP-5); nonlinear border/Fitting
integration (WP-6); unirationality; \(\operatorname{ed}_{\mathbf C}(G)\).

**Dependencies (Gates 1–2, accepted):**
`certificates/strata/strata_exact.json`, `incidence_exact.json`,
`normal_characters.json`, `marked_s3_geometry.json`.

**Recovery (hash-checked before use):**
`tmp/involution_exceptional_divisor/`, `tmp/d12_line_restriction/`.

---

## 4A — Involution plus-plane

| Item | Value |
|------|-------|
| Stratum | \(Z_t=P(E_+(t))\simeq\mathbf P^2\), orbit 55 |
| \(H\) | \(C_2=\langle t\rangle\) |
| Normal bundle | \(N\simeq\mathcal O(1)\otimes E_-\) (sign⊕sign) |
| Artifacts | `transitions/involution_plane/{produce,verify,module}.py/json` |
| Terminal marker | `INVOLUTION_PLANE_MODULE_OK` |

**Geometric theorem.** Every plus-plane is a base component; the common first
transverse order \(m\) is odd; a nonzero leading map dominates \(L_t=P(E_-)\).
Full \(C_2\)-character dependence (not merely parity) is recorded.

**Module.** For \(d\ge m\),

\[
\dim M_{m,d}
=
(m+1)\binom{d-m+2}{2}
\times
\begin{cases}
3 & m\text{ even (target }E_+)\\
2 & m\text{ odd (target }E_-).
\end{cases}
\]

Hilbert series

\[
H(s,t)=\frac{3+4st}{(1-t)^3\,(1-(st)^2)^2}.
\]

For each fixed \(m\), \(\bigoplus_d M_{m,d}\) is **free** of rank
\(r_m=(m+1)\delta_m\) over \(R=\operatorname{Sym}(E_+^*)\cong\mathbf Q[x_0,x_1,x_2]\).
As a single bigraded \(R\)-module in both \((m,d)\), finite generation in \(m\)
**fails** (ranks grow linearly in \(m\)); the rational series still controls
**all** orders and degrees.  This failure is expected (infinite normal cone) and
is not papered over.

**Landing at first odd order.** Pure \(E_-\)-valued leading jets automatically
satisfy the cubic on \(E_-\) by parity \(F|_{E_-}\equiv 0\).

**Upstream recovery.** `INVOLUTION_EXCEPTIONAL_DIVISOR_AUDIT_OK`.

---

## 4B — Universal \(D_{12}\) binary line transitions

| Item | Value |
|------|-------|
| Stratum | \(L_t=P(E_-(t))\simeq\mathbf P^1\subset X\), orbit 55 |
| Setwise / residual | \(D_{12}\), residual \(S_3\) |
| Artifacts | `transitions/d12_binary_line/` |
| Terminal marker | `D12_BINARY_LINE_MODULE_OK` |

**Module.** Ordinary and det-twisted binary covariant modules

\[
O_d=\operatorname{Hom}_{D_{12}}(\operatorname{Sym}^d V,V),\qquad
T_d=\operatorname{Hom}_{D_{12}}^{\det}(\operatorname{Sym}^d V,V)
\]

on \(V=E_-(t)\) are each **free of rank 2** over the binary invariant ring
\(R=\mathbf Q[u,v]\) with \(u=xy\) (deg 2), \(v=x^6+y^6\) (deg 6), generated in
degrees 1 and 5.  Hilbert series

\[
\frac{t+t^5}{(1-t^2)(1-t^6)}
\]

(\(\dim=0\) for even \(d\), \(\lfloor(d+2)/3\rfloor\) for odd \(d\)).  Controls **all**
source degrees.

**Plus-plane coupling.** For odd plane-order \(m\) and odd \(d\),
\(p|_{E_-}=\Delta_t^m h_t\) with \(\Delta_t=x^6-y^6\) and \(h_t\in T_{d-6m}\).

**Endpoint classification (residual degree \(e=d-6m\)).**

| \(e\) | Local ledgers in the \(D_{12}\) module |
|------:|----------------------------------------|
| 1, 3 | only `swap_both` |
| 5 | `swap_both`, two mixed; not `preserve_both` |
| \(\ge 7\) odd | all four ledgers |

Centralizer symmetry alone does **not** force a unique global transition.
Local models are not claimed to be global \(G\)-covariants.

**C6 points.** The two residual-\(C_3\) fixed points on \(L_t\); det-twisted maps
preserve the pair setwise.  Entire-line based is allowed (always for even \(d\)).

**Upstream recovery.** `D12_LINE_RESTRICTION_AUDIT_OK`.

---

## 4C — \(V_4\) fixed line and \(E[2]\) charges

| Item | Value |
|------|-------|
| Stratum | \(P(A)=P(W^{V_4})\simeq\mathbf P^1\), orbit 55 |
| Residual | \(A_4/V_4\simeq C_3\) |
| Artifacts | `transitions/v4_fixed_line/` |
| Terminal marker | `V4_FIXED_LINE_MODULE_OK` |

**Forced base (4C.1).** Order-zero restriction lands in endomorphisms of \(A\).
Landing on \(X\) would require a residual-\(C_3\) constant at a \(C_3\)-fixed point of
\(X^{V_4}\), but the only \(C_3\)-fixed points of \(P(A)\) are the two \(A_4\) character
lines (**off** \(X\)), while type-I and type-II points form \(C_3\)-orbits of size 3.
Hence \(P(A)\) is a forced base component.

**Module.** \(N\simeq\mathcal O(1)\otimes(\chi_z\oplus\chi_s\oplus\chi_r)\).  For \(d\ge m\),

\[
\dim M_{m,d}
=
\bigl(n_{\mathrm{triv}}(m)+\binom{m+2}{2}\bigr)\,(d-m+1),
\]

with
\(n_{\mathrm{triv}}(2k)=\binom{k+2}{2}\) and
\(n_{\mathrm{triv}}(2k+1)=\binom{k+1}{2}\).
Free over \(\mathbf Q[x,y]\) for each fixed \(m\); finite generation in \(m\) fails
(quadratic growth).

**Normal directions.** Pure \(\chi_z/\chi_s/\chi_r\) jets point to type-I vertices and
elliptics \(E_z/E_s/E_r\); trivial character deforms within \(P(A)\) toward type-II;
triangle edges are the rational minus-lines.

**Charges (WP-3 theorem).** Type-I \(=\langle q\rangle\); type-II \(=e+\langle q\rangle\) for
\(0\neq e\in E[2]\).  Consistent with Gate 1 type-II triple-elliptic meetings.
Explicit Weierstrass coordinates of \(q,e_i\) remain a named remainder
(existence/uniqueness only).

**House rule 7.** Bare \(V_4\) triangle transition graph is accepted from
`V4_REPORT.md` (closes; both preserve and swap occur) and is not re-run.

---

## 4D — \(C_3\) lines and \(C_6\) endpoints

| Item | Value |
|------|-------|
| Stratum | \(P(U_\omega)\) or \(P(U_{\omega^2})\), orbit 110 |
| \(W|_{C_3}\) | dims \((1,2,2)\) for characters \((1,\omega,\omega^2)\) |
| Artifacts | `transitions/c3_lines/` |
| Terminal marker | `C3_LINES_MODULE_OK` |

**Three-point intersection (char 0).** \(F|_{U_\omega}\) is a binary cubic.  Its
discriminant is nonzero in characteristic zero because it reduces to a nonzero
value at good primes (if the discriminant vanished in char 0 it would vanish at
all good reductions).  Hence \(X\cap L\) is a **reduced** length-3 scheme.
(M2 script `disc_identity.m2` records the classical discriminant polynomial.)

**Composition.** Exactly **one** \(C_6\)-point and **two** exact-\(C_3\) points per
line.  Global: \(110\times 2=220\) residual \(C_3\)-points on \(X\).

**220 remainder: CLOSED** by the char-0 square-freeness argument above.

**Order zero.** Constants to any of the three points of \(X\cap L\) are locally
allowed; nonconstant order-zero landing is impossible.  The \(C_3\)-line is
**not** forced into the base locus by local \(C_3\)-symmetry alone (contrast 4A/4C).

**Module.** Reynolds enumeration on
\(\operatorname{Sym}^m N_0^*\otimes\operatorname{Sym}^{d-m}U^*\otimes W\) with
\(N_0^*\simeq\omega\oplus\omega^2\oplus\omega^2\).  Free over the binary coordinate
ring for each fixed \(m\); ranks control all \((m,d)\).

---

## 4E — Compulsory point links

| Point | Orbit | Off \(X\)? | Incident flags |
|-------|------:|:----------:|----------------|
| \(D_{10}\) | 66 | yes, \(F=5\) | 5 involution planes |
| \(D_{12}\) | 55 | yes | 7 planes + 3 \(V_4\)-lines |
| \(A_4^{(a)}\) | 55 | yes | 3 planes + 4 \(C_3\)-lines + 1 \(V_4\)-line |
| \(A_4^{(b)}\) | 55 | yes | same |

| Artifacts | `transitions/point_links/` |
| Terminal marker | `POINT_LINKS_MODULE_OK` |

**Module form.** At a point \(y\) with stabilizer \(H\) and \(\mathcal O(1)\)-character
\(\lambda\),

\[
M_{m,d}
=
\bigl[\operatorname{Sym}^m(T_y Y)^*\otimes\lambda^d\otimes W\bigr]^H.
\]

Finitely generated in \(m\) over the invariant ring of \(H\) on \(T_y Y^*\) (Molien);
\(d\)-dependence is through \(\lambda^d\).  **House rule 4:** finite generation does
not by itself give an all-degree emptiness theorem.

**Allowed states.** Type-I / type-II / \(C_6\) / elliptic / rational-line states at
first nonzero order are the restrictions of the point module along the incident
flags to the modules of 4A–4D, with \(E[2]\)-charges from WP-3.

---

## Regression checklist (acceptance gate)

| Check | Status |
|-------|--------|
| Involution \((\dim E_+,\dim E_-)=(3,2)\) | PASS |
| \(F|_{E_-}\equiv 0\) | PASS |
| Plus-plane base + odd order + dominates \(L_t\) | PASS (4A) |
| \(D_{12}\) binary dims \(\lfloor(d+2)/3\rfloor\) (odd \(d\)) | PASS (4B) |
| Free rank-2 Hilbert series match \(d\le 60\) | PASS (4B) |
| Four local endpoint ledgers by explicit models | PASS (4B) |
| \(V_4\) joint dims \((2,1,1,1)\) | PASS (4C) |
| \(n_{\mathrm{triv}}\) closed form (even/odd binomial) | PASS (4C) |
| \(A_4\) character lines off \(X\) | PASS (accepted Gate 1/2) |
| \(C_3\) dims \((1,2,2)\); binary cubic square-free | PASS (4D) |
| 220 \(C_3\)-points remainder closed | PASS (4D) |
| \(D_{10}\) \(F=5\); incidence 5/7/3/4/1 | PASS (4E) |
| Charges via WP-3 \(E[2]\) theorem | PASS (4C, 4E) |
| No bare \(V_4\) transition rerun | PASS (house rule 7) |
| Headline OPEN everywhere | PASS |

---

## Replay

```text
# Recovery (upstream)
/opt/homebrew/bin/python3 tmp/involution_exceptional_divisor/verify.py
/opt/homebrew/bin/python3 tmp/d12_line_restriction/verify.py

# WP-4 modules
/opt/homebrew/bin/python3 certificates/transitions/involution_plane/verify.py
/opt/homebrew/bin/python3 certificates/transitions/d12_binary_line/verify.py
/opt/homebrew/bin/python3 certificates/transitions/v4_fixed_line/verify.py
/opt/homebrew/bin/python3 certificates/transitions/c3_lines/verify.py
/opt/homebrew/bin/python3 certificates/transitions/point_links/verify.py
```

Terminal markers:

```text
INVOLUTION_PLANE_MODULE_OK
D12_BINARY_LINE_MODULE_OK
V4_FIXED_LINE_MODULE_OK
C3_LINES_MODULE_OK
POINT_LINKS_MODULE_OK
```

---

## Seal (content hashes written after last byte on disk)

See `certificates/transitions/SEAL.json` (produced by the seal script; excludes
timing fields).

**LOCAL_TRANSITION_MODULES_OK**
