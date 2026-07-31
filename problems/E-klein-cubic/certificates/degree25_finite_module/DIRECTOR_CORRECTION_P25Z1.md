# Director correction — P25Z.1 closure is sampled, not proved over `S`

**Author:** director session, 2026-07-31, verifying the P25Z.1 packet.
**Applies to:** the exit marker `P25Z-FINITE-PRESENTATION` and the isomorphism claim in
`iso_proof.json` / `FINITE_PRESENTATION.md`.
**Effect on the next step:** **none for the emptiness direction.** P25Z.2 may proceed. The
nonempty branch is affected — see §3.

The packet is left byte-identical; this is the correction layer, following the
`DIRECTOR_CORRECTION_C0.md` / `DIRECTOR_CORRECTION_T8.md` pattern.

---

## 1. What the work order required

`WORKORDER_CAS_T9_P25Z.md` §4, P25Z.1, step 3 requires adding **all** overlap and commutator
relations needed for confluence, `(T_i T_j − T_j T_i) b` for `b ∈ B`, and states explicitly:

```text
A matrix obtained from the 690 residual cubic rows alone is insufficient unless
all overlap and multiplication consequences are included.
```

The sealed presentation matrix is exactly `690 × 28` — the 690 residual seeds alone
(`relation_matrix.json`: `"Presentation matrix columns = the 690 seeds as polyvectors"`).

## 2. What was actually established

The commutator defects are **not** zero as operators. `closure_ledger.json` records
`comm_nonzero_operator_pairs: 15` (all `C(6,2)` pairs) and
`comm_nonzero_defect_columns_sample: 315`. Their redundancy was established by **specialization
only**:

| Claim | Evidence in the packet |
|---|---|
| `T`-stable hull = seed span | `T_stable_count: 40`, `trials: 40` — 40 random fibres `q_0` |
| commutator defects in seed span | `comm_in_seed_span_count: 40` — same 40 fibres |
| verifier's independent check | `specialized_T_stable`, `specialized_comm_in_span`, `trials = 25` |

The ledger's own wording is `"T-stable hull coincides with seed span on a Zariski-dense open of
Spec S"` — which is an *inference from sampling*, not a computation over `S`. The verifier
reproduces the same specialization rather than closing the gap, so `PASS 20/20` does not
certify it.

This is the family of error house rule 7 of the previous order names: a fibrewise/local kernel
promoted to a global module statement.

## 3. What survives, and what does not

Let `N_seed ⊆ F = S^28` be the `S`-span of the 690 seeds, and `N_true = ker(F → R/J_N)`.

**Proved, and not in question:**

- the 56 monic `K³` rewrite rules and the operators `T_i`;
- each seed is the `K³`-normal form of a generator of `J_N`, hence zero in `R/J_N`, so
  `N_seed ⊆ N_true`;
- consequently `F/N_seed ↠ F/N_true = R/J_N`, and therefore
  `Supp(R/J_N) ⊆ Supp(F/N_seed)`.
- the commutator defects lie in `N_true` — this is a *theorem*, not a sample, since `R` is
  commutative, so `[T_i,T_j]` vanishes modulo the kernel. What is unproved is only their
  membership in `N_seed`.

**Not proved:** `N_seed = N_true`, hence not `M ≅ R/J_N`. The isomorphism argument in
`iso_proof.json` assumes `N` is "the smallest `T`-stable submodule containing the seeds" *and*
that this equals the seed span; only the first is a definition, and the second is the sampled
claim.

**Asymmetric consequence — this is the operative point:**

- **Emptiness direction is SAFE.** Because `Supp(R/J_N) ⊆ Supp(F/N_seed)`, a unit saturation
  `(Fitt_0(F/N_seed) : q^∞) = (1)` proves `Proj(R/J_N) = ∅` regardless of whether the closure
  is complete. So P25Z.2 may run on the sealed matrix as-is and, if it returns unit saturation,
  `P25-DEGREE25-EMPTY` is legitimate.
- **Nonempty direction is NOT safe.** A surviving component of `Supp(F/N_seed)` need not lie in
  `Supp(R/J_N)`; it may be an artefact of an under-closed relation module. Any nonempty exit
  must close this gap before interpretation — in addition to the subsystem caveat that already
  applies (`J_N` is a subsystem, so a point of it is not a landing candidate until the complete
  identity `F(p_c) ≡ 0` is verified).

## 4. Corrected status

```text
P25Z-FINITE-PRESENTATION-LOWER
    presentation matrix certified to generate a submodule of the true relation
    module; F/N_seed surjects onto R/J_N; closure to equality is sampled, not proved.
```

## 5. How to close it

Membership of each commutator defect in `N_seed` is a module-membership problem over
`S = F_89[q_0,…,q_36]`. Everything in sight is graded, so the honest route is a **graded,
degree-by-degree** membership check: the defects `(T_iT_j − T_jT_i)b` are specific graded
elements, and membership need only be decided in their own degrees, not by a full 37-variable
syzygy computation. If that is out of reach, the alternative is to *include* the defect columns
in the presentation and accept a larger `r` — which is what the work order asked for, and which
costs nothing in the emptiness direction.

**Problem E remains OPEN.**
