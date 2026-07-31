# Problem E — repair memorandum

**Repository:** `mattrobball/unirational`  
**Authored:** 2026-07-31  
**Audit base:** `68147f3479000590377bd322adfe6c1112d38d90`  
**Problem:** PSL\((2,11)\)-unirationality of the Klein cubic threefold  
**Headline:** **OPEN**

---

## 0. Purpose and binding status

This memorandum records analytic overreach and theorem-boundary discrepancies found in the existing Problem E packets. It is a correction layer over the historical commits; published history is not rewritten.

The following distinction is binding:

```text
hash/verifier replay
    !=
mathematical verification of every analytic implication in the proof note.
```

In particular, the Phase-0 marker

```text
HEADLINE_CAS_BASELINE_ACCEPT
```

certifies file presence, hashes, internal packet consistency, and replay of the current verifiers. It does **not** certify analytic arguments that those verifiers merely read from JSON or Markdown.

### Immediate route status

| Route / claim | Status after this repair |
|---|---|
| Path T: `T-BIRATIONAL` | retained at its stated generic/open theorem boundary |
| Path T: `T-NONNORMAL` | **suspended; not proved by the current T2 packet** |
| Path T: `dim Sing_S = 2` | **unproved; current exact cuts do not establish it** |
| Path G: finite truncation and isolation cutoff | retained |
| Path G: degree-13/19 “obstruction” labels | downgraded to **sample residuals** |
| Path G4.1 symbolic free-fibre recurrence | retained at its stated free-fibre boundary |
| P25.1 `P25-TOWER-SURVIVES` | retained as a scoped free-fibre/degree-25 continuation |
| Hodge-center conclusion | salvageable, but the proof must be rewritten |
| Path A index-34 duality | retained |
| Path A single-minor formulation | corrected to the ideal of all maximal minors |
| Path A executable `L,V_Z` claim | downgraded to an abstract interface |

No headline exit has been reached.

---

# Part I — critical repair of Path T

## 1. The current T2 dimension inference is invalid

The T2 packet concludes

\[
\dim \operatorname{Sing} S=2
\]

from two pairs of affine linear forms whose exact characteristic-zero intersections with the **unsaturated** singular ideal are nonempty and zero-dimensional.

That implication is false without a proof that the cuts are general for the relevant scheme and that the relevant singular locus is pure-dimensional.

### 1.1 Counterexample to the inference

Let

\[
V=\{(t,0,0,0,0):t\in k\}\subset \mathbf A^5,
\]

so \(\dim V=1\). The independent pair

\[
x_2=0,\qquad x_1=0
\]

cuts \(V\) in one point. A second independent pair

\[
x_3=0,\qquad x_1-1=0
\]

also cuts \(V\) in one point. Thus two independent nonempty zero-dimensional codimension-two sections do not imply that the original scheme has dimension two.

“Independent” is not synonymous with “general.”

### 1.2 What the exact cuts presently support

Subject to the usual dimension inequalities, the exact cuts provide evidence and an upper-bound mechanism for the closed model. They do not provide a certified lower bound of two, purity, or a codimension-one component on the advertised simple-fold open.

The valid current status is:

```text
strong evidence for a two-dimensional singular component;
exact proof of dim Sing_S = 2 not yet supplied.
```

## 2. The exact cuts were not saturated by the simple-fold gates

The exact files used for the T2 conclusion are explicitly `nosat`. Their points may lie entirely in

\[
V(\ell P_{uu}\delta C),
\]

outside the open on which the fold algebra \(S\) is defined.

The modular saturated calculations are discovery data only. Therefore the exact computations do not presently prove even nonemptiness of the singular locus on the full simple-fold open.

## 3. The T2 verifier verifies files, not the dimension theorem

`certificates/fold_normalization/verify_t2.py` checks:

- hashes;
- the msolve output class `zero_dim`;
- JSON consistency;
- the stored integer `dim_Sing_S = 2`.

It does not prove:

- genericity of the two chosen pairs;
- purity of the singular locus;
- a lower bound of two;
- survival after exact saturation by all gates;
- or the analytic implication from the cuts to `R1=false`.

Accordingly, the terminal marker

```text
FOLD_NORMALIZATION_T2_VERIFIER_ACCEPT
```

must not be consumed as a proof of `T-NONNORMAL`.

---

## 4. The \(S_2\) and \(R_1\) arguments are not on the same open

The fold algebra is declared to be

\[
S=\left(B[u]/(P,P_u)\right)[\Sigma^{-1}],
\qquad
\Sigma=\langle \ell,P_{uu},\delta,C\rangle.
\]

The \(S_2\) proof, however, identifies the algebra with a localization of the complete intersection

\[
R[u]/(P,P_u)
\]

only after the complementary resultant factor \(G\) is also inverted, so that \(H\) becomes redundant through

\[
\operatorname{Res}_u(P,P_u)=H\,G.
\]

The current packets do not prove globally that

\[
V(H,G)\cap D(\Sigma)=\varnothing.
\]

Nonvanishing of \(G\) at one line-branch point proves generic nonvanishing, not that \(G\) is a unit at every codimension-one point of the \(\Sigma\)-open.

Thus the existing proof establishes Cohen–Macaulayness on a potentially smaller open

\[
D(G\Sigma),
\]

while the claimed \(R_1\) statement concerns \(D(\Sigma)\), and the exact cuts were made on a still larger unsaturated closed model.

Serre’s criterion cannot combine these three schemes.

### Required repair

Before any normalization/conductor packet consumes T2, prove one of:

1. **Same-open theorem**
   \[
   V(H,G)\cap D(\Sigma)=\varnothing;
   \]
2. **Restricted-open theorem**: redefine the object as \(S_G\), prove that the removed strata are irrelevant to the valuation/class-group argument, and account separately for every removed codimension-one locus;
3. **Direct \(S_2\) theorem**: prove that the originally declared \(S\) is \(S_2\) without inverting \(G\).

---

## 5. Two conductors have been conflated

There are two finite birational extensions:

\[
B\subseteq S\subseteq \widetilde S.
\]

They have distinct conductors:

\[
\mathfrak c_{B\subset S}=\operatorname{Ann}_B(S/B),
\]

and

\[
\mathfrak c_{S\subset\widetilde S}
=\operatorname{Ann}_S(\widetilde S/S).
\]

The first measures the partial fold modification of the target branch. The second measures the nonnormality of \(S\), if nonnormality is eventually proved.

Nonnormality of \(S\) does not imply that \(\operatorname{Ann}_B(S/B)\) is the normalization conductor or has the support asserted in T2.

All future files must use the two notations separately.

---

## 6. Mandatory T2-repair computation

The active CAS order must insert the following gate before T3.1.

### T2R.1 — exact scheme and localization

Write down one ring representing the exact object to which both \(S_2\) and \(R_1\) will be applied. Record explicitly whether \(G\) is inverted.

### T2R.2 — exact saturated singular ideal

Compute or certify the dimension of

\[
I_{\rm sing}^{\rm open}
=
(H,P,P_u,P_A,P_B,P_Y,P_Z):
(\ell P_{uu}\delta C)^\infty,
\]

with the additional factor \(G\) included if and only if the chosen scheme in T2R.1 inverts it.

### T2R.3 — lower and upper bounds

A valid proof of dimension two requires both directions.

Acceptable lower-bound certificates include:

- an exact height-three prime component meeting the open;
- a finite dominant two-parameter map into the singular locus;
- a Noether normalization with two algebraically independent coordinates;
- an exact irreducible two-dimensional component plus gate nonvanishing.

Acceptable upper-bound certificates include:

- exact Krull dimension of the saturated ideal;
- an exhaustive equidimensional decomposition;
- a certified Noether normalization of dimension at most two.

Random or hand-selected linear sections alone are insufficient.

### T2R exits

- `T2R-NONNORMAL`: \(S_2\) and failure of \(R_1\) are proved on the same exact open.
- `T2R-NORMAL`: \(S_2+R_1\) are proved on that open.
- `T2R-UNDECIDED`: exact remaining scheme and bottleneck recorded.

Until one of these exits is certified, `T-NONNORMAL` is suspended and T3 height-one normalization must not consume it.

---

# Part II — repair of the Hodge-center theorem

## 7. Relative-dimension error

The Hodge-center packet says that

\[
f:Z\to X
\]

is generically finite. But \(Z\) resolves a rational map from \(\mathbf P^4\), so

\[
\dim Z=4,
\qquad
\dim X=3.
\]

A dominant \(f\) has relative dimension one. Consequently the packet’s direct pushforward

\[
f_*:H^3(Z)\to H^3(X)
\]

has the wrong cohomological degree, and the displayed degree-\(d\) identity is invalid.

## 8. Correct split injection

Choose a \(G\)-invariant ample class

\[
\eta\in H^2(Z,\mathbf Q).
\]

Then

\[
f_*(\eta)=n\in H^0(X,\mathbf Q)
\]

for some \(n>0\), the degree of \(\eta\) on the generic curve fibre. Define

\[
s:H^3(Z,\mathbf Q)\to H^3(X,\mathbf Q),
\qquad
s(\beta)=\frac1n f_*(\eta\cup\beta).
\]

For \(\alpha\in H^3(X)\), the projection formula gives

\[
s(f^*\alpha)
=
\frac1n f_*(\eta\cup f^*\alpha)
=
\frac1n f_*(\eta)\cup\alpha
=
\alpha.
\]

Thus \(f^*\) is a split injection of rational Hodge structures. Averaging \(\eta\) makes the splitting \(G\)-equivariant.

The conclusion of the Hodge-center theorem may be retained after replacing the incorrect proof with this one. No new CAS computation is required.

---

# Part III — repair of Path A

## 9. Quantifier correction for maximal minors

The exact target is

\[
\forall\tau\text{ primitive},
\qquad
\operatorname{rank}B_{34}(\tau,V_Z)=55.
\]

Pointwise, this means

\[
\forall\tau\ \exists M_\tau
\quad
M_\tau(\tau)\neq0,
\]

where \(M_\tau\) is a maximal minor allowed to depend on \(\tau\).

It is **not** equivalent to the stronger assertion

\[
\exists M\ \forall\tau,
\qquad
M(\tau)\neq0.
\]

The correct global certificate is

\[
V(I_{55}(B_{34}))\cap U_{\rm primitive}=\varnothing,
\]

or an equivalent saturation of the ideal generated by **all** maximal minors. No single minor need be globally nonvanishing.

Future notes must replace the phrase

```text
some 55x55 minor is nonzero at every primitive tau
```

by

```text
at every primitive tau, at least one 55x55 minor is nonzero.
```

## 10. The installed field algebra and marked point are abstract interfaces

The A2 packet does not contain:

- the expanded coefficients of \(\mu(t)\in F[t]\) in named invariant generators;
- executable generic multiplication matrices over a concrete presentation of \(F\);
- the power-basis coordinates of \(z_0,\ldots,z_3\);
- the exact Plücker point of \(V_Z\subset L\).

It contains a monogenic schema with formal coefficients and a geometric construction of the marked point.

Therefore the correct status is:

```text
abstract degree-55 algebra and marked-evaluation interface installed;
exact executable marked algebra-code pair (L,V_Z) not installed.
```

The later `A_EMPTY_UNDECIDED` packet correctly records this boundary and supersedes earlier summaries saying that A2 had installed exact generic coordinates.

---

# Part IV — repair of Path G labels and inference

## 11. Nonzero sample residual is not an obstruction theorem

The degree-13 and degree-19 packets compute nonzero terminal residuals on selected `ker_L1` free-fibre samples. They do not compute the zero locus of the residual map over the full global state space.

The same packets record a `based_zero` sample with vanishing residual. Therefore the free-fibre residual map already has zeros. A nonzero evaluation proves only that the map is not identically zero.

The correct labels are:

```text
G13-SAMPLE-RESIDUAL
G19-SAMPLE-RESIDUAL
G-PATTERN
```

not degree-wide obstruction exits.

The valid universal results remain:

\[
F(p)\in I^{3d+1}\Rightarrow F(p)=0,
\]

and

\[
N_\star=d+2m+1.
\]

## 12. P25.1 confirms the correction

At \((m,d)=(1,25)\), the particular terminal residual is nonzero on sample directions, but later high-order kernel freedom cancels it and the zero locus is nonempty in both live free-fibre families.

Thus terminal nonzero sample values are not evidence of an empty global zero locus. The decisive object is always

\[
\Theta^{-1}(0),
\]

with all global equalizers and coefficient couplings imposed.

The latest G4.1 symbolic recurrence is useful, but G4.2 correctly stops because finite generation of the full equalizer/Fitting layers over the proposed pure \((m,d)\)-semigroup grading has not been proved.

No degree ladder may substitute for that finite-generation theorem.

---

# Part V — narrative corrections

## 13. Auxiliary Pfaffian cubic

Any sentence of the form

```text
The cubic has a K_proj-point abstractly.
```

must specify:

```text
The auxiliary Pfaffian characteristic cubic in Sym(A,sigma)
has a K_proj-point abstractly.
```

This is not a point of \(F_{14,T}\) or of the generic Klein twist. The `FAIL-SCOPE` bridge audit is authoritative.

## 14. Generic Schur twist

The sentence

```text
The generic Schur twist has index one, but no rational point.
```

must be replaced by

```text
The generic Schur twist has index one, but no rational point is currently known.
```

Pointlessness has not been proved. If it had been proved for the generic Schur torsor, the headline negative result would already follow.

---

# Part VI — required repository edits

The historical certificates remain useful as computation records, but the following current-status files must be amended before a final proof consumes them.

## 15. Files requiring theorem-boundary repair

### Path T

```text
certificates/fold_normalization/SERRE_NORMALITY.md
certificates/fold_normalization/r1_singular_locus.json
certificates/fold_normalization/serre_payload.json
certificates/fold_normalization/SEAL.json
certificates/fold_normalization/verify_t2.py
```

Required status:

```text
T2-UNDECIDED pending exact saturated same-open dimension proof.
```

The old msolve artifacts remain valid records of the exact cut computations.

### Hodge center

```text
certificates/hodge_centers/HODGE_CENTER_NECESSITY.md
```

Replace the generically finite argument by the relatively ample class argument of §8.

### Path G

```text
certificates/global_finite_lifting/degree13/TOWER.md
certificates/global_finite_lifting/degree19/TOWER.md
certificates/global_finite_lifting/TERMINAL_PATTERN.md
```

Retain the exact sample data and rename degree-wide obstruction language.

### Path A

```text
certificates/schur_krylov/A_EMPTY.md
certificates/schur_krylov/orbit_code.md
certificates/schur_krylov/field_algebra.md
certificates/schur_krylov/marked_point.md
certificates/schur_krylov/README.md
```

Repair the quantifier wording and distinguish formal algebra schemas from expanded executable generic data.

### Narrative state

```text
CURRENT_PATHS.md
SPEC.md
HANDOFF.md
RESOLUTION.md
```

Apply §§13–14 and point these files to this repair memorandum.

---

# Part VII — accepted state after repair

## 16. Trusted results

The following remain accepted at their exact stated boundaries:

- exact degree-43 resultant-factor reconstruction;
- Path T finite generic-rank-one/birational fold construction on its stated open;
- regular-sequence theorem for \(P,P_u\) in \(R[u]\);
- Path G finite truncation;
- Path G isolation cutoff \(N_\star=d+2m+1\);
- exact Path G sample residual calculations;
- G4.1 symbolic free-fibre recurrence at its stated scope;
- P25.1 scoped survival result;
- Path A \(\mathbf P^1\)-reduction;
- Path A index-34 duality;
- Pfaffian `FAIL-SCOPE` audit;
- corrected Hodge-center split-injection theorem after §8 is substituted.

## 17. Suspended or downgraded results

| Historical statement | Accepted replacement |
|---|---|
| `dim Sing_S = 2` | unproved; exact same-open saturated computation required |
| `T-NONNORMAL` | suspended |
| “normalization defect is divisorial” | unproved |
| `Ann_B(S/B)` is the normalization conductor | false notation; conductors separated |
| `G13-OBSTRUCTION` / `G19-OBSTRUCTION` | nonzero selected sample residuals |
| exact executable generic \(L,V_Z\) | abstract interface only |
| one universal nonzero Krylov minor | ideal of all maximal minors / pointwise cover |
| generic Schur twist has no rational point | no rational point currently known |

---

## 18. Headline

No positive or negative headline bridge has been completed.

\[
\boxed{\text{Problem E remains OPEN.}}
\]

The immediate priority is T2R. The active T3 normalization work must not assume a divisorial singular locus until T2R supplies a same-open saturated proof. Path G may continue through the finite-generation obstruction identified at G4.2, and P25 may continue through its exact characteristic-zero support computation.
