# Attempt 2, Gate 1 — Global simple-fold component (option (c) continuation)

**Headline: OPEN.**  
**Work package:** Attempt 2, Gate 1 (tasks 2B.1–2B.2).  
**Authorized route:** option **(c)** multi-prime sparse reconstruction (option (a) refused; (b) not needed).  
**Base:** `b7be961` / work-order pin.  
**Deliverables:** `certificates/target_branch_global/*`.

## Gate 1 decision

```text
STOP-2
```

Option **(c) succeeded** for the projection equation of the multiplicity-one
target branch: the global factor

\[
H\in\mathbf Z[A,B,Y,Z]
\]

of \(\operatorname{Res}_u(P,P_u)\) that specializes to the accepted line
certificate \(H_{21}(s)\) has been reconstructed over characteristic zero and
independently verified.  What remains of Gate 1 — normalization \(\widetilde D\),
conductor, and the cubic-discriminant divisor on \(\widetilde D\) — is blocked
by a **new, measured** bottleneck on the Jacobian ideal of this degree-43
hypersurface (38 992 terms).  Full `PASS-MB` / `PASS-NODAL` / `FAIL-HIGHER`
requires that geometry.  No Gate 2/3 work is started.

## 1. Accepted inputs (not re-derived)

| Fact | Status |
| --- | --- |
| Primitive sextic \(P\in\mathbf Z[A,B,Y,Z,u]\), 1593 terms, content 1 | Sealed TSV |
| \(\gcd(P,P_u)=1\) over \(\mathbf Q\) | Proved (mod-67 reduction) |
| Line \((A,B,Y,Z)=(1,2,3,s)\): \(\operatorname{disc}_u = c\cdot Q_{11}(s)^2\cdot H_{21}(s)\) | Accepted |
| \(H_{21}\) irreducible deg 21, mult 1, smooth-cubic open on the line | Accepted |
| House rules 5–6, 8 GiB exploratory gate | Binding |

## 2. Task 2B.1 — global simple-fold / target-branch equation

### What is proved (new)

1. **Modular eliminant factorization (discovery + shape).**  
   For every good prime \(p\) in a 93-prime set with \(\operatorname{coeff}(A^{43})=1\)
   on the monic factor,
   \[
   \operatorname{Res}_u(P,P_u)\bmod p
   \]
   factors in \(\mathbf F_p[A,B,Y,Z]\) with a unique multiplicity-one factor
   \(H_p\) whose restriction to the accepted line has degree 21.  Peak RSS for
   resultant+factor under Nemo/Flint stayed **≤ 8.0 GiB** (taskpolicy 7800 MiB;
   observed max resident ≈ 8.0 GiB on several primes).  Total degree of `Res`
   is about 100–106 (leading form vanishes at some primes).

2. **Global factor \(H\) by multi-prime rational reconstruction.**  
   The monic-in-\(A\) factor (leading term \(A^{43}\)) was reconstructed from
   the modular images by CRT + Farey rational reconstruction with an
   **implemented congruence check** on every coefficient:
   \[
   a\cdot b^{-1}\equiv e\pmod M
   \]
   (no SymPy private ratrecon helper).  Cleared denominators yield a primitive
   integer polynomial
   \[
   H_{\mathrm{prim}}\in\mathbf Z[A,B,Y,Z],
   \]
   content 1, total degree 43, **37 992 terms**, \(\operatorname{coeff}(A^{43})>0\).

3. **Exact line verification.**  
   Specializing \(H_{\mathrm{prim}}\) (equivalently the monic rational form)
   to \((A,B,Y,Z)=(1,2,3,s)\) recovers \(H_{21}(s)\) up to a nonzero rational
   scale, checked by integer cross-multiplication against the exact char-0
   factorization of \(\operatorname{Res}_u(P,P_u)|_{(1,2,3,s)}\).

4. **Holdout prime.**  
   At \(p=641\) (not used in the CRT set), recomputing
   \(\operatorname{Res}_u\) and its mult-1 line-deg-21 factor matches the
   reduction of the reconstructed monic \(H\) with **0** coefficient mismatches
   on the union of supports.

5. **Irreducibility over \(\mathbf Q\).**  
   The mult-1 factor is irreducible in \(\mathbf F_{67}[A,B,Y,Z]\) (single
   deg-43 factor in the Nemo factorization).  Hence \(H_{\mathrm{prim}}\) is
   irreducible over \(\mathbf Q\).

### Interpretation (theorem boundary)

- \(D:=V(H_{\mathrm{prim}})\subset\mathbf A^4_{A,B,Y,Z}\) is the **zero set of the
  multiplicity-one factor of \(\operatorname{Res}_u(P,P_u)\) selected by the
  accepted line \(H_{21}\)**.  This is the equation of the target branch in
  coefficient space (the projection of the simple mult-1 fold locus along \(u\)).
- The Cramer-saturated simple-fold component in \((A,B,Y,Z,u)\)-space still has
  working model
  \[
  R_{\mathrm{simple}}\subset V(P,P_u)\setminus V(P_{uu}\cdot\delta\cdot C)
  \]
  lying over \(D\).  Scheme-theoretic primary decomposition of the fold ideal
  over \(\mathbf Q\) is **not** claimed beyond this eliminant factor.

### What is not constructed

| Object | Status |
| --- | --- |
| Normalization \(\widetilde D\to D\) | **NOT CONSTRUCTED** |
| Conductor ideal | **NOT CONSTRUCTED** |
| Discriminant divisor of the cubic family on \(\widetilde D\) | **NOT CONSTRUCTED** |
| Critical geometry class (MB / nodal / higher) on the normalized fold | **NOT DECIDED** |

## 3. Task 2B.2 — critical geometry

**Class: NOT DECIDED.**

The accepted slice theorem (curve of dimension 1, degree 14 on \(A=0,B=2\))
remains the only exact char-0 critical-locus statement.  Modular singular-locus
GB of \((H,\partial H)\) was launched under the 8 GiB gate; as of sealing it had
not returned dimension/degree.  No Morse–Bott / nodal / higher claim is made.

## 4. Algebraic bottleneck (updated STOP-2)

### Previous bottleneck (closed by option (c))

```text
ELIMINATION-ORDER_GB_OF_FOLD_FOR_PROJECTION_AND_CHAR0_COMPONENT_EXTRACTION
```

Closed: modular `Res_u` + factorization completes under 8 GiB; multi-prime
reconstruction yields exact \(H\).

### Current bottleneck

```text
NORMALIZATION_JACOBIAN_GB_OF_DEGREE_43_TARGET_BRANCH_HYPERSURFACE_H
```

**Precise statement.**  Completing Gate 1 requires the normalization of
\(D=V(H)\) (or of the fold cover over \(D\)), the conductor, and the pullback of
the cubic discriminant.  The first computational step is control of
\[
J=(H,\partial_A H,\partial_B H,\partial_Y H,\partial_Z H)
\]
(singular locus / Jacobian criterion) in characteristic zero or at enough
good primes with a lift argument.  Generators have ~32k–38k terms each and
total degree 43.  A modular grevlex GB under M2 was running inside the 8 GiB
envelope without a completed dim/deg certificate at seal time.

### Measured floors (option (c))

| Probe | Result |
| --- | --- |
| Nemo `Res_u(P,Pu)` mod \(p\) (4 vars) | Completes; ~9.5e5 terms; deg ~100–106; RSS peak ≤ 8.0 GiB |
| Factor of `Res` mod \(p\); extract line-deg-21 mult-1 factor | Completes; target deg 43, ~37.4k–37.9k terms |
| Multi-prime ratrecon (93 good primes, \(M\) ~ 760 bits) | Full support 37 992 monoms; congruence checks 0 failures |
| Holdout \(p=641\) | Match reconstructed monic \(H\) |
| Jacobian GB of \(H\) mod 67 (M2 grevlex) | **Incomplete at seal** (parse/GB under 8 GiB; no dim yet) |

### Resource request if unblocked

- Finish modular Jacobian GB / dim of \(\operatorname{Sing}(D)\) under 8 GiB, or
  a structured normalization (e.g. partials + saturation) with written memory plan;
- only then: conductor and cubic-discriminant pullback (Gate 2).

## 5. Exact theorem boundary

**Proved in this packet**

- content of sealed \(P\) is 1; \(\gcd(P,P_u)=1\) over \(\mathbf Q\);
- existence and uniqueness of the monic-in-\(A\) mult-1 factor of
  \(\operatorname{Res}_u(P,P_u)\) specializing to \(H_{21}\) on the accepted line;
- explicit primitive integer equation \(H_{\mathrm{prim}}\) (degree 43, 37 992 terms)
  with verified line specialization and holdout modular match;
- Gate 1 still ends in `STOP-2` because normalization/conductor/discriminant
  divisor are not constructed; the bottleneck is renamed as above.

**Not proved**

- scheme-theoretic primary decomposition of \((P,P_u)\) over \(\mathbf Q\);
- normality of \(D\), conductor, or \(\widetilde D\);
- global critical class; \((\operatorname{Cl}(T_D)/\operatorname{Pic}(T_D))[3]\);
- any conversion of Problem E.

## 6. Files

```text
certificates/target_branch_global/NORMALIZED_FOLD.md
certificates/target_branch_global/produce.py
certificates/target_branch_global/verify.py
certificates/target_branch_global/payload.json
certificates/target_branch_global/normalization.json
certificates/target_branch_global/conductor.json
certificates/target_branch_global/SEAL.json
certificates/target_branch_global/H_factor/H_primitive_integer.tsv
certificates/target_branch_global/H_factor/H_monic_rational.tsv
certificates/target_branch_global/H_factor/ratrecon_summary.json
certificates/target_branch_global/H_factor/SHA256SUMS
```

Scratch: `tmp/a2_global_fold/` (modular factor TSVs, logs, reconstruction scripts).

## 7. Intended commit split

1. `certificates/target_branch_global/*` — H factor, producer, verifier, seal, this report.
2. Optional scratch commit for `tmp/a2_global_fold/` modular primes / logs, or leave untracked.

No edits to `HANDOFF.md`, `RESOLUTION.md`, `CURRENT_PATHS.md`, or `SPEC.md`.

## Terminal markers

```text
TARGET_BRANCH_GLOBAL_FOLD_GATE1_PRODUCER_SEALED
TARGET_BRANCH_GLOBAL_FOLD_GATE1_VERIFIER_ACCEPT
```
