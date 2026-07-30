# Attempt 2, Gate 1 — Global simple-fold component

**Headline: OPEN.**  
**Work package:** Attempt 2, Gate 1 (tasks 2B.1–2B.2) only.  
**Base:** `d9cadc3` (work-order pin).  
**Deliverables:** `certificates/target_branch_global/*`.

## Gate 1 decision

```text
STOP-2
```

The global simple-fold component cannot be extracted over characteristic zero
within the authorized **8 GiB RSS** exploratory envelope.  The exact algebraic
bottleneck is named below.  This demotes the route at Gate 1: do **not** run
Gate 2 (contact exponents) or Gate 3 (class-group assembly) on an unextracted
component.  `STOP-2` with a precise bottleneck is an accepted outcome of the
work order; no `PASS-*` is manufactured.

## 1. Accepted inputs (not re-derived)

| Fact | Status |
| --- | --- |
| `ind(C/F)=3`, `C(F)=∅`, `[K_proj:F]=6` | Accepted reduction |
| `Pic(T_D)=Z H_z ⊕ Z H_λ` | Accepted (SGA2) |
| Multiplicity-one target branch, residue degree `m=1` | Accepted |
| Generic cubic smooth on the branch | Accepted |
| Primitive sextic `P∈ZZ[A,B,Y,Z,u]`, 1593 terms, `u`-deg 6, content 1 | Sealed TSV |
| Simple-fold model `R_fold=V(P,P_u)` away from `P_uu·δ·C=0` | Accepted model |
| Slice `A=0,B=2`: critical/singular locus dim 1, degree 14 | Accepted theorem |
| Line factor `H_21` multiplicity one; `disc_u` shape `(11,2)+(21,1)` | Accepted line cert |
| RUR orbit: corank two, `h_3=h_4=0`; points lie on the critical curve | Accepted |
| House rule 5: no full class group | Binding |
| House rule 6: no pointwise treatment of positive-dim critical locus | Binding |

Source hashes are sealed in `payload.json` / `SEAL.json`.

## 2. Task 2B.1 — extract the global simple-fold component

### What was required

Over characteristic zero: the relevant irreducible component of the
Cramer-saturated simple fold; its normalization `D~`; the conductor; the map
to the target coefficient space; the discriminant divisor of the cubic family
on `D~`.  **A test slice is not the component.**

### What is proved

1. **Content.** The sealed primitive `P` has content `1` in
   `ZZ[A,B,Y,Z,u]` (1593 coefficients, gcd = 1).

2. **Coprimeness of fold generators (char 0).**
   \[
   \gcd(P,\,P_u)=1\quad\text{in }\mathbf Q[A,B,Y,Z,u].
   \]
   Proof: reduce coefficients mod `67` and compute `gcd` in the integer
   polynomial ring with reduced coefficients; the result is a nonzero
   constant.  Any positive-degree primitive common divisor over `ZZ` would
   reduce to a positive-degree common divisor mod `67`, contradiction.  Gauss
   lemma upgrades this to the stated equality over `QQ`.

   Consequence: `(P,P_u)` has no common polynomial factor, so the fold is not
   set-theoretically the whole ambient five-space.  This does **not** by
   itself give primary decomposition or the multiplicity-one component.

### What is not constructed

| Object | Status |
| --- | --- |
| Global irreducible simple-fold component over `QQ` | **NOT EXTRACTED** |
| Normalization `D~` | **NOT CONSTRUCTED** |
| Conductor ideal | **NOT CONSTRUCTED** |
| Map to target coefficient space | **NOT CONSTRUCTED** |
| Discriminant divisor of the cubic family on `D~` | **NOT CONSTRUCTED** |

The working definition remains the ideal-theoretic model

```text
I0 = (P, P_u)  ⊂  QQ[A,B,Y,Z,u],
R_simple_open = V(I0) \ V(P_uu · δ · C).
```

No primary decomposition, saturation certificate, or elimination ideal over
`QQ` is claimed.

### Modular shape (discovery only — not char-0 components)

Under `msolve` at `p=67`, DRL Gröbner basis of `(P,P_u)`:

| Quantity | Value |
| --- | ---: |
| Basis size | 72 |
| Terms in basis | 5 047 581 |
| Max F4 matrix | 184 450 × 529 725 (density ≈ 1.24%) |
| Dimension | positive (output `[1,5,-1,[]]`) |
| Leading ideal contains | `A^21*B^2` (degree-21 signature aligned with line `H_21`) |

Random sampling of `(A,B,Y,Z)` in `F_67` (3000 trials): about 74 simple-fold
points vs 6 higher-fold points among disc hits — shape only.

None of this is promoted to a characteristic-zero component list.

## 3. Task 2B.2 — critical geometry

**Class: NOT DECIDED.**

The positive-dimensional critical locus is treated as geometry, not as a
collection of sample points.  The accepted slice theorem (curve of dimension
1 and degree 14 on `A=0,B=2`) remains the only exact char-0 critical-locus
statement; it is compatible with a Morse–Bott surface sectioned by the plane,
but does **not** prove global Morse–Bott (`xy=0`), nodal contact
(`xy=π^n`), smoothness along a conductor, or a higher `cA` type.

No local class group modulo 3 is computed (that would require a
`FAIL-HIGHER` local model after a higher singularity is identified).

Everything remains shaped to the mod-3 gate: only factors and contact orders
of residual series modulo 3 matter; the full class group is not computed.

## 4. Algebraic bottleneck (why STOP-2 is correct)

### Name

```text
ELIMINATION-ORDER_GB_OF_FOLD_FOR_PROJECTION_AND_CHAR0_COMPONENT_EXTRACTION
```

### Precise statement

Extracting the global simple-fold component over `QQ` requires one of:

1. primary decomposition / minimal primes of
   `saturate((P,P_u), P_uu)` in `QQ[A,B,Y,Z,u]`; or
2. elimination of `u` to obtain `Res_u(P,P_u)∈QQ[A,B,Y,Z]` and factorization
   isolating the multiplicity-one target branch (degree 21 on the accepted
   line); or
3. an equivalent sparse/matrix formulation of the same projection.

All three demand elimination/resultant-scale linear algebra on generators of
size

```text
P : 1593 terms,  coefficients up to ~10^26,
Pu: 1213-term support,  Puu: 881-term support,
ring: 5 variables.
```

### Measured floors

| Probe | Result |
| --- | --- |
| DRL GB of `(P,P_u)` mod 67 (`msolve`, 4 threads) | Completes; basis 72 gens, ~5.05e6 terms; max matrix ~1.8e5 × 5.3e5 |
| ELIM(1) same generators, order `(u,A,B,Y,Z)` mod 67 | **Peak RSS ≥ 9 429 120 KB (~9.2 GiB)**; incomplete; **stopped under the 8 GiB gate** |
| ZZ resultant via Nemo (coeff-reduced) | Multi-GiB growth; killed before completion (not a negative algebraic result) |
| M2 inline poly parse/GB of dense 53 KB scripts | Multi-minute stall without output at ~320 MiB (parse/GB path abandoned) |

### Resource request (successful STOP outcome)

To unblock Gate 1 without violating the house memory gate, authorize one of:

- **(a)** an explicit budget `>8 GiB` for modular ELIM/resultant of `(P,P_u)`; or
- **(b)** a redesign to subresultant / sparse interpolation of `Res_u(P,P_u)`
  with a written memory plan staying under 8 GiB; or
- **(c)** multi-prime sparse reconstruction of the degree-21 factor using the
  accepted line `H_21(s)` as shape, then rational reconstruction.

### Checkpoint plan (if unblocked)

1. Modular factorization of `Res_u(P,P_u)` at several primes under budget.
2. Rational reconstruction of the multiplicity-one degree-21 factor `H`.
3. Char-0 proof that the simple-fold open projects onto `V(H)`.
4. Fresh resource estimate, then normalization of `H=0`.
5. Only then: conductor and cubic-discriminant pullback (Gate 2).

### Independent verifier design

The verifier (`verify.py`) does **not** import the producer.  It reloads `P`
from the sealed TSV, rechecks content `1`, recomputes the modular gcd by an
independent Julia/Nemo path, re-hashes the sealed `msolve` DRL log and checks
basis size / term count, checks that `gate1_decision=STOP-2` with
normalization/conductor `NOT_CONSTRUCTED`, and refuses to launch `>8 GiB`
elimination jobs.

## 5. Exact theorem boundary

**Proved in this packet**

- content of sealed `P` is 1;
- `gcd(P,P_u)=1` over `QQ`;
- Gate 1 ends in `STOP-2` with the named bottleneck and measured modular
  floors above.

**Not proved**

- existence of an explicit global equation of the target branch in
  coefficient space;
- irreducibility or primary decomposition of the simple-fold ideal over `QQ`;
- construction of `D~`, conductor, or discriminant pullback;
- global critical geometry class (MB / nodal / higher);
- vanishing or nonvanishing of `(Cl(T_D)/Pic(T_D))[3]`;
- any conversion of Problem E.

**Not claimed**

- full class group of any scheme;
- that the slice critical curve *is* the global component;
- that modular `msolve` components lift to `QQ` without reconstruction.

## 6. Files

```text
certificates/target_branch_global/NORMALIZED_FOLD.md
certificates/target_branch_global/produce.py
certificates/target_branch_global/verify.py
certificates/target_branch_global/payload.json
certificates/target_branch_global/normalization.json
certificates/target_branch_global/conductor.json
certificates/target_branch_global/SEAL.json
```

Scratch (not sealed as theorems): `tmp/a2_global_fold/`.

## 7. Intended commit split

1. `certificates/target_branch_global/*` — producer, verifier, sealed payload,
   normalization/conductor status stubs, this report.
2. Optional separate commit for `tmp/a2_global_fold/` exploration logs, or
   leave untracked per scratch policy.

No edits to `HANDOFF.md`, `RESOLUTION.md`, `CURRENT_PATHS.md`, or `SPEC.md`.

## Terminal markers

```text
TARGET_BRANCH_GLOBAL_FOLD_GATE1_PRODUCER_SEALED
TARGET_BRANCH_GLOBAL_FOLD_GATE1_VERIFIER_ACCEPT
```
