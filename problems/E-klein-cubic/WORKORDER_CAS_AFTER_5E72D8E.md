# Problem E — CAS decision work order after `5e72d8e`

**Repository:** `mattrobball/unirational`  
**Operational base:** `fa02168279bf8bd420ffafafa7bf3d1cd4b4e334`  
**Research base audited:** `5e72d8e7892d04b10588c25e2e446b83e4783708`  
**Problem:** PSL\((2,11)\)-unirationality of the Klein cubic threefold  
**Worker role:** exact CAS production and independent verification only  
**Headline:** **OPEN**

---

## 0. Purpose and supersession

This order supersedes `WORKORDER_CAS_DECISION_AFTER_7FDBE42_V2.md` for the next dispatch. The earlier work orders, `REPAIR.md`, and the sealed certificates remain binding as historical input and theorem-boundary corrections.

The current two leading exact targets are:

\[
\boxed{
(H,P,P_u,s_1):
(\ell P_{uu}C\delta G)^\infty=(1)
}
\tag{T-unit}
\]

and

\[
\boxed{
V_+\bigl(J_{25,p}\bigr)
\subset \mathbf P^{42}_{\mathbf F_p},
}
\tag{P25-support}
\]

where \(s_1\) is the leading coefficient of the first subresultant of \(P,P_u\), and \(J_{25,p}\) is a rigorously lifted subsystem of direct landing equations for the genuine degree-\(25\) strict covariant space.

Neither target is presently decided.

---

# 1. Binding theorem boundaries

## 1.1 Trusted results

The worker may consume without re-derivation:

1. The generic-twist and exhaustive self-covariant reductions stated in `SPEC.md` and `RESOLUTION.md`, subject to `REPAIR.md`.
2. `T-BIRATIONAL` at its stated common-open/generic theorem boundary.
3. On the chosen \(G\)-open fold algebra \(S_G\), the \(S_2\) conclusion and the upper bound
   \[
   \dim \operatorname{Sing}(S_G)\le 2.
   \]
4. The exact circuits for \(P,H,G,\ell,P_{uu},C,\delta\), and for
   \[
   \operatorname{Sres}_1(P,P_u)=s_1u+s_0.
   \]
5. The exact Molien dimensions
   \[
   \dim M_{25}=189,
   \quad
   \dim \mathrm{Arr}=59,
   \quad
   \dim V_{25}=43,
   \quad
   \dim K=6,
   \quad
   \dim Q=37.
   \]
6. The canonical Reynolds/nullspace construction of \(V_{25}\), its compatible good-prime realizations, the \(868\times43\) restriction matrices modulo good primes, and residual image rank \(7\).
7. Finite truncation of the polar tower and the local free-fibre recurrence from Path G, only at their stated boundaries.

## 1.2 Downgraded or quarantined results

The following are **not** accepted as headline or exact characteristic-zero inputs:

1. `T-NONNORMAL` and `dim Sing = 2` remain suspended.
2. Modular nonvanishing samples for \(s_1\) are discovery only.
3. `P25X0-PASS` means a canonical characteristic-zero construction circuit with compatible finite-field realizations. It does **not** mean that a \(43\times189\) basis or \(868\times43\) restriction matrix has been materialized entrywise over \(K=\mathbf Q(\zeta_{11})\).
4. The sampled rank \(746\) is a certified lower bound for the direct evaluation row space at the tested primes. It is not a proved upper bound or complete coefficient span.
5. The verifier rank \(394\), obtained from \(400\) sample points, is only a low-sample sanity check and is not a second discrepancy.
6. The historical rank-\(842\) row space and the rank-\(28\) border presentation are **quarantined**. They may not be used as the degree-\(25\) landing ideal until rederived from, or proved equivalent to, the direct landing equations.
7. Prime \(67\) is forbidden as the sole decision fibre. It has already produced misleading behavior in this project.
8. A local/free-fibre jet, residual, boundary state, or formal lift is not a covariant.

## 1.3 Analytic bridges

A CAS result may be promoted only through these bridges:

| Exit | CAS result | Analytic consequence |
|---|---|---|
| `T8-INDEX3` | a residue-degree-one target branch retains horizontal degree subgroup \(3\mathbf Z\) | headline negative |
| `P25-COVARIANT` | one exact nonzero primitive degree-\(25\) landing covariant of generic Jacobian rank \(4\) | headline positive |
| `C-FANO-POINT` | a \(K_{\rm proj}\)-point of the genuine twisted Fano section | headline positive |

An empty degree-\(25\) scheme is only a degree-\(25\) exclusion. Proving \(s_1\) is a unit is only a simplification of Track T, not a headline result.

---

# 2. Execution order

Run the first two tracks in parallel at exploratory scale. A third, low-memory Fano interface audit may run concurrently, but no two memory-saturating jobs may overlap.

| Priority | Track | First decision target |
|---:|---|---|
| **1** | T8 — first-subresultant branch | exact `T-unit` certificate or countercomponent |
| **2** | P25Y — direct landing support | exact DVR model and projective support of valid direct equations |
| **3** | C0 — direct twisted Fano interface | executable model/preflight only |

Paths G, A, S19, subgroup sweeps, and KLS computations are parked unless a later director gate explicitly revives them.

---

# 3. Track T8 — exact first-subresultant unit theorem

## 3.0 Exact object

Work in

\[
R=\mathbf Q[A,B,Y,Z,u].
\]

Let

\[
J_{s_1}=(H,P,P_u,s_1)\subset R
\]

and let the common-open gate be

\[
q=\ell\,P_{uu}\,C\,\delta\,G.
\]

The exact question is

\[
J_{s_1}:q^\infty=(1).
\]

Because \(G\) is represented by an exact quotient circuit and has factorization shape

\[
G=L\,M^4Q_4F_{27}^2,
\]

factorwise localization is allowed and preferred. A single giant expanded gate product is not required.

## T8.1 — principal-subresultant algebra before Gröbner work

Before any large saturation:

1. Rebuild the first subresultant circuit independently.
2. Export the exact principal-subresultant identities expressing \(s_1u+s_0\) as a Bézout combination of \(P\) and \(P_u\).
3. Determine the exact subdiscriminant condition represented by \(s_1=0\): gcd degree at least \(2\), degeneration of the linear gcd, or a union with leading-coefficient loci.
4. Factor or decompose every small principal subresultant coefficient that appears.
5. Test whether an identity of the following form exists with a modest exponent:
   \[
   q^N
   =A H+B P+C_1P_u+D s_1.
   \]
   A successful identity is a complete `T8-S1-UNIT` certificate.

No modular interpolation is a proof unless the reconstructed identity is checked exactly in \(R\).

### Deliverables

```text
certificates/fold_decision_t8/
  SUBRESULTANT_UNIT_TARGET.md
  subresultant_identities.json
  factor_ledger.json
  produce_t81.*
  verify_t81.*
```

The verifier must recompute the decisive polynomial identity, not merely read a boolean from JSON.

## T8.2 — factorwise exact saturation

If T8.1 does not close the question, compute

\[
J_{s_1}:q^\infty
\]

sequentially by

```text
ell -> P_uu -> C -> delta -> L -> M -> Q_4 -> F_27.
```

Rules:

1. At each stage record exact generators, Krull dimension, leading monomials, and whether the ideal is the unit ideal.
2. Use the quotient circuit for \(G\); reconstruct the full \(F_{27}\) over characteristic zero only if the preceding stages leave a component that requires it.
3. Modular Gröbner bases are discovery. Any characteristic-zero exit requires exact reconstruction and verification.
4. Empty engine output is a failed run, not the unit ideal.
5. Affine linear sections are not dimension certificates.
6. A precisely named resource stop is an accepted result.

### Exact exits

- `T8-S1-UNIT`:
  \[
  J_{s_1}:q^\infty=(1)
  \]
  with an exact Nullstellensatz, Gröbner, or radical-containment certificate.
- `T8-S1-NONUNIT`: an exact prime/component or exact algebraic point satisfying \(J_{s_1}\) with every gate nonzero.
- `T8-S1-UNDECIDED`: the smallest unresolved factorwise stage and resource floor are sealed.

### Resource authorization

Exploratory ceiling: **8 GiB**. If the exact factorwise problem remains finite but exceeds that ceiling, one preflighted T8 job is authorized up to **64 GiB RSS**, provided:

```text
ring and generator count
term count / circuit size
expected GB or Macaulay dimensions
checkpoint plan
certificate type
independent verifier design
```

are written before launch. It may not run concurrently with a memory-heavy P25 support job.

## T8.3 — conditional graph isomorphism

Run only after `T8-S1-UNIT`.

Prove, using exact subresultant identities, that on the common open

\[
u=-s_0/s_1
\]

and construct mutually inverse algebra maps between the fold algebra and the corresponding branch chart. Verify every gate after substitution.

Do **not** infer normality from this isomorphism. Record separately:

```text
branch chart
Jacobian/singularity ideal
normalization status
conductor status
```

## T8.4 — conditional index-three continuation

After T8.3, construct the pulled-back cubic incidence on the explicit branch chart and compute only the information needed for

\[
\left(\operatorname{Cl}/\operatorname{Pic}\right)[3].
\]

Required sequence:

1. height-one normalization data;
2. discriminant contact multiplicities modulo \(3\);
3. codimension-two local class groups modulo \(3\);
4. residual codimension-three Picard/parafactoriality audit;
5. global horizontal degree subgroup.

Exit `T8-INDEX3` requires an exact proof that the horizontal degree subgroup remains \(3\mathbf Z\).

---

# 4. Track P25Y — direct landing equations without the historical 842 packet

## 4.0 Governing principle

The authoritative object is

\[
I_{25}
=
\operatorname{coeff}_x
F\!\left(\sum_{i=1}^{43}c_i p_i(x)\right).
\]

The historical \(842\)-row and rank-\(28\) packets are not on the critical path. They may be compared only after the direct object is independently defined.

A subsystem of genuine landing equations can prove emptiness. A point of a subsystem cannot prove existence until the full landing identity is verified.

## P25Y.1 — certify one fixed DVR coefficient model

Use \(p=89\), with \(p=199\) or \(353\) as holdout. Since \(p>75\), degree-\(75\) source evaluation has no elementary finite-field aliasing by individual variable degree.

Construct a fixed local model over

\[
\mathcal O_{K,\mathfrak p},
\qquad K=\mathbf Q(\zeta_{11}).
\]

Required certificate:

1. exact integral Reynolds seed lattice;
2. exact integral arrangement and strict restriction matrices as circuits;
3. a pivot minor whose determinant is a unit at \(\mathfrak p\);
4. proof that the strict kernel is locally free of rank \(43\);
5. a basis-lift circuit whose reduction is the stored \(43\)-basis at \(p=89\);
6. the induced local \(868\times43\) restriction-map circuit;
7. exact denominator/unit ledger.

An entrywise global \(K\)-matrix is optional. A fixed DVR basis-lift with unit-pivot proof is sufficient. Per-prime unrelated RREF bases are not sufficient.

### Exit

- `P25Y-DVR-PASS`: one fixed integral projective landing scheme is defined at \(p=89\).
- `P25Y-DVR-FAIL`: no common lift was certified; projective support may not begin.

## P25Y.2 — deterministic direct equation subsystem

Run only after `P25Y-DVR-PASS`.

1. Choose a deterministic, replayable source-point sequence in \(\mathbf F_{89}^5\).
2. For each point \(x_j\), construct the cubic equation
   \[
   F(p_c(x_j))=0
   \]
   in the \(43\) coefficient variables.
3. Prove that each row is the reduction of a section of the fixed DVR landing ideal.
4. Row-reduce incrementally and record the rank after every block.
5. Use \(p=199\) as a structural holdout, not as a substitute for the fixed \(p=89\) model.

The rank plateau is recorded only as a lower bound unless an exact unisolvence or representation-theoretic upper bound is proved.

### Deliverables

```text
certificates/degree25_direct_support/
  DVR_MODEL.md
  deterministic_points.*
  direct_rows_p89.*
  rank_growth.json
  produce_rows.*
  verify_rows.*
```

## P25Y.3 — decide projective support of the subsystem

Let \(J_N\) be the ideal generated by the certified direct rows.

Compute

\[
V_+(J_N)\subset \mathbf P^{42}_{\mathbf F_{89}}.
\]

Preferred methods, in order:

1. sparse homogeneous Gröbner/F4;
2. degree-by-degree Macaulay/Hilbert-function calculation;
3. a newly derived border basis from \(J_N\) itself;
4. projective saturation or an irrelevant-power certificate.

The historical border basis may not be imported.

### Empty-support certificate

Projective emptiness must be certified by one of:

- the saturated homogeneous ideal is the unit ideal;
- all monomials of some degree \(D\) lie in \(J_N\);
- an independently verified projective Nullstellensatz certificate.

If \(V_+(J_N)=\varnothing\), then the full landing scheme has empty special fibre. Because the fixed full landing scheme is projective over the DVR from P25Y.1, properness implies its generic fibre is empty. The exit is:

```text
P25-DEGREE25-EMPTY
```

This is a degree-\(25\) exclusion only.

### Nonempty-support branch

If support survives:

1. enlarge the deterministic row set until dimension and degree stabilize;
2. identify components or smooth points;
3. record all nonvanishing open conditions;
4. do not call a subsystem point a covariant.

## P25Y.4 — candidate lift and full identity

For a surviving special point or component:

1. verify the **complete** identity
   \[
   F(p_c(x))\equiv0
   \]
   over the special field by direct sparse coefficient collection for the fixed candidate;
2. verify equivariance, primitivity, and generic Jacobian rank \(4\);
3. if the point is smooth on the complete landing scheme, Hensel-lift it to characteristic zero;
4. alternatively reconstruct an exact algebraic characteristic-zero point and substitute into the original equations.

Only then claim:

```text
P25-COVARIANT
```

and pass to the positive analytic bridge.

### Resource authorization

P25Y.1–Y.2 must remain under **8 GiB**. P25Y.3 may use one preflighted job up to **64 GiB**, but not concurrently with the T8 large job. Absolute ceiling remains **96 GiB** with explicit director approval.

---

# 5. Conditional Track C0 — genuine twisted Fano interface

This track is low-priority during the first dispatch and must not consume resources needed by T8 or P25Y. A low-memory structural audit may proceed.

The target is the genuine twisted Fano section

\[
F_{14,T}(K_{\rm proj}),
\]

not the auxiliary Morita projector cubic.

## C0.1 — choose and certify one executable representation

Produce either:

1. an exact quaternion algebra \(D/K_{\rm proj}\) and five Hermitian matrices
   \[
   h_1,\ldots,h_5\in\operatorname{Herm}_3(D),
   \]
   with the common-isotropic-line equations; or
2. exact descended restricted Plücker/rank-one equations for \(F_{14,T}\).

After a splitting extension, verify that the model is the classical smooth degree-\(14\) Fano threefold.

## C0.2 — structural point search only

Before raw elimination, search for:

```text
rational fibration
conic bundle
odd-degree multisection
homogeneous-space description
low-degree rational section
```

The idempotent-to-Fano broken arrow remains binding. An auxiliary point does not count.

C0 exits only with:

- `C0-MODEL-PASS` — executable genuine Fano model installed;
- `C-FANO-POINT` — exact point, headline positive after bridge;
- `C0-UNDECIDED` — smallest exact system and resource floor.

---

# 6. First dispatch and director gate

## Parallel first dispatch

```text
Worker T:   T8.1, then T8.2 if required
Worker P:   P25Y.1, then P25Y.2 and P25Y.3 preflight
Worker C:   C0.1 structural/interface audit only
```

Stagger starts. Use path-scoped commits only. Never use `git add -A` while workers run concurrently.

## Director gate

Select the continuation in this order:

1. `T8-S1-UNIT` or `T8-S1-NONUNIT` — continue T8.3/T8.4 immediately.
2. `P25-DEGREE25-EMPTY` or a complete special-fibre point — finish the corresponding P25 theorem boundary.
3. `P25Y-DVR-PASS` with support still computing — continue P25Y.3.
4. Both T and P stop honestly — promote C0 to the primary route.
5. No precise gate crossed — issue a bottleneck report; do not substitute a degree ladder or a generic sweep.

---

# 7. Universal verification and house rules

1. Every producer has an independent verifier that does not import the producer.
2. A verifier must recompute the decisive invariant; hash consistency is insufficient.
3. Modular reconstruction includes an implemented final congruence check and at least one holdout prime.
4. Prime \(67\) is never the sole decision fibre.
5. Empty solver output is not an empty variety.
6. Affine hyperplane sections are not used as projective or Krull-dimension certificates.
7. No free local kernel is promoted to a global correction space.
8. No sampled row span is called complete without an upper-bound certificate.
9. No historical \(842\)-row or rank-\(28\) packet is used before direct equivalence is proved.
10. Every candidate is substituted into the original equations.
11. Every artifact states exactly what it proves and does not prove.
12. A measured `UNDECIDED` exit with a named bottleneck is successful work.
13. The headline remains **OPEN** until an accepted final exit and analytic bridge are both independently verified.

---

# 8. Final exit table

| Exit | Meaning | Consequence |
|---|---|---|
| `T8-S1-UNIT` | first subresultant coefficient is a unit on the common fold open | simplify T; no headline yet |
| `T8-S1-NONUNIT` | exact gated component with \(s_1=0\) | analyze normalization defect; no headline yet |
| `T8-INDEX3` | horizontal degree subgroup remains \(3\mathbf Z\) on residue branch | headline negative |
| `P25-DEGREE25-EMPTY` | direct degree-\(25\) landing scheme empty | scoped exclusion only |
| `P25-COVARIANT` | exact primitive dominant degree-\(25\) landing covariant | headline positive |
| `C-FANO-POINT` | exact point on genuine twisted Fano section | headline positive |
| `*-UNDECIDED` | exact bottleneck and resource floor | no headline claim |

**Problem E remains OPEN.**
