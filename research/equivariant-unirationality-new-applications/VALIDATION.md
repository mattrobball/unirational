# Validation checklist for the salvaged PR #13 content

Salvaged from PR #13 and rescoped; see `ADJUDICATION_PR13.md`. The sections
below are checks on the four verifier scripts in this directory and on
`THEOREM_RULED_CONIC_BUNDLE_THREEFOLD.md`.

## Structural theorem boundary

- [x] The ruled-conic-bundle threefold theorem uses the controlled strict-transform/eigenbundle induction of `FIX_IX_v14.md`, through the central form of the residual-RCC theorem in `GENERALIZATIONS.md`.
- [x] It does **not** use the withdrawn assertion that arbitrary fixed strata remain rationally chain connected through arbitrary equivariant blowups.
- [x] The ruled-fixed-surface application uses an honest equivariant morphism `T -> C` onto a genus-two curve, not a merely rational MRC quotient.
- [x] No Amitsur, higher-Amitsur, or `G`-Mori claim is made for the threefold. The relative Néron--Severi computation in Section 6 of the theorem file is recorded as unused.

## Ruled conic-bundle threefold

- [x] `r=diag(omega,omega^{-1})` and `s=swap` is a genuine linear lift of `S3`, so `O_{P^1}(1)` and hence `F_1` are `S3`-equivariant.
- [x] `x^6+y^6` is invariant under that lift and has six distinct roots.
- [x] Weights match: `u`,`v` carry `L=p^*O(3)`, so `uv` and `f w^2` are both sections of `p^*O(6)`.
- [x] Smoothness in all three fiber charts; on `{w != 0}` the only issue is at `u=v=f=0`, where `df != 0` because `f` is reduced.
- [x] The `z`-anti-invariant eigenpoint `{u=-v, w=0}` misses `X`, so `X^z` is exactly the `+1` locus.
- [x] `X^z = T = F_1 x_{P^1} C` with `C : q^2 = x^6+y^6` of genus two, and `T -> C` a `P^1`-bundle.
- [x] `C^{S3}` is empty because `r` fixes only `0,infinity` and `s` exchanges them.
- [x] Hypothesis 1 holds vacuously: an `S3`-stable irreducible RCC subvariety of `T` would map to an `S3`-fixed point of `C`.
- [x] Hypothesis 2: `X^G` is empty for the same reason.
- [x] Condition (A) is self-contained: explicit `C^B` witnesses for `B` trivial, `C2`, `C3`, then a fixed point in the ruling fiber because the action of `A` on `T_c` factors through the cyclic group `B`.
- [x] Both Sylow subgroups of `C2 x S3` are abelian, so item 3 of the theorem follows from Condition (A).

## Group and witness bookkeeping for `C2 x D_{2n}`, odd `n`

Model: `C_n : q^2 = x^(2n)+y^(2n)` in `P(1,1,n)`, genus `n-1`. The case
`n=3` is the residual curve of the threefold theorem above.

- [x] `x^(2n)+y^(2n)` is squarefree in characteristic zero, so `C_n -> P^1` is branched at `2n` distinct points.
- [x] Riemann--Hurwitz gives genus `n-1 >= 2`.
- [x] Group axioms, the full subgroup lattice, and the abelian subgroups are enumerated exactly for `n = 3,5,7,9`.
- [x] For odd `n`, an abelian subgroup containing a reflection contains no nontrivial rotation, and contains exactly one reflection.
- [x] Every abelian subgroup receives an explicit rotation or reflection witness; the reflection witness solves `2k = j mod n`, which is exactly solvable because `n` is odd.
- [x] The full odd-dihedral group has no common fixed point on the base.
- [x] Every Sylow subgroup has a fixed point, including the non-squarefree cases `n = 9, 25, 27` handled by the prime-power audit.

This is **not** the exceptional conic-bundle surface family of
`THEOREM_ODD_EXCEPTIONAL_CONIC_BUNDLES.md`, whose fixed curve is
`U^2 = -T_0T_1(T_0^{2g}+T_1^{2g})` of genus `g`. Only the abstract group
`C2 x D_{2n}` is shared; the curves, branch loci, and witnesses differ.

## Fermat degree-two del Pezzo with `C2^Geiser x S3`

- [x] The branch plane quartic `x^4+y^4+z^4` is smooth of genus three.
- [x] The permutation representation of `S3` on `C^3` has exactly one invariant line, `span(1,1,1)`; no coordinate line is invariant.
- [x] `1^4+1^4+1^4 = 3 != 0`, so `[1:1:1]` misses the branch curve and the full fixed locus of `C2 x S3` is empty.
- [x] A transposition fixes the line `x=y`, on which the branch equation is the nonzero binary quartic `2x^4+z^4`.
- [x] A three-cycle has the exact cyclotomic fixed points `[1:omega:omega^2]` and `[1:omega^2:omega]`, and `1+omega^4+omega^8 = 0` is verified by exact reduction in `Z[omega]`.
- [x] Every abelian subgroup and every Sylow subgroup receives a fixed-point witness.

## Exact replay

Run:

```bash
python3 research/equivariant-unirationality-new-applications/verify_dihedral_conic_bundle.py
python3 research/equivariant-unirationality-new-applications/verify_dihedral_sylow_exact.py
python3 research/equivariant-unirationality-new-applications/verify_fermat_dp2_s3.py
python3 research/equivariant-unirationality-new-applications/verify_new_applications.py
```

Expected terminal markers:

```text
DIHEDRAL_CONIC_BUNDLE_CERTIFICATE: PASS
DIHEDRAL_SYLOW_PRIME_POWER_AUDIT: PASS
FERMAT_DP2_S3_CERTIFICATE: PASS
ODD_DIHEDRAL_CONIC_BUNDLE_AUDIT: PASS
FERMAT_DP2_S3_AUDIT: PASS
NEW_APPLICATIONS_EXACT_CHECKS: PASS
```

`THEOREM_RULED_CONIC_BUNDLE_THREEFOLD.md` has no dedicated verifier. Its
finite inputs — the group `C2 x S3`, the six distinct branch points, the
genus-two curve, the emptiness of `C^{S3}`, and the cyclic abelian subgroups
— are the `n=3` case of `verify_dihedral_conic_bundle.py`. The remaining
steps (smoothness, the eigenpoint computation, the fiber-product identity)
are proved in the theorem file.

## Literature labels

The label `OPEN-CONFIRMED` means only:

> no theorem deciding the exact weak-versality or equivariant-unirationality
> question was located in the primary, citing, current-preprint, or
> adjacent-birational-model literature searched through 2026-08-09.

It does not mean that non-linearizability, stable non-linearizability,
quotient irrationality, or ordinary irrationality was absent from the
literature.
