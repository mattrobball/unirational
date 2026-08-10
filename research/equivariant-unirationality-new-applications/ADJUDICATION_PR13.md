# Adjudication of PR #13 (`agent/equivariant-unirationality-new-applications-packet`)

PR #13 is superseded by the packet already on `main` except for the files
salvaged onto this branch. Every salvaged claim was rechecked against the
artifacts. Verdict codes: `CONFIRMED`, `FIXED-IN-PLACE`, `REFUTED`.

## A. Ruled conic-bundle threefold (`THEOREM_RULED_CONIC_BUNDLE_THREEFOLD.md`)

| # | claim | verdict |
|---|---|---|
| A1 | `X={uv=fw^2}` over `F_1` with `f=p^*(x^6+y^6)`, `L=p^*O(3)`, is smooth and rational; the two sections split the generic conic | `CONFIRMED` |
| A2 | `X^z = T = F_1 x_{P^1} C` with `C : q^2=x^6+y^6` of genus two, and `T -> C` a `P^1`-bundle | `CONFIRMED` |
| A3 | `C^{S3}=empty`, because `r` fixes only `0,infinity` and `s` exchanges them | `CONFIRMED` |
| A4 | every RCC subvariety of `T` maps to a point of `C`; an `S3`-stable one would need a point of `C^{S3}`; hence Hypothesis 1 of the residual-RCC theorem | `CONFIRMED` |
| A5 | `X^G=empty`, hence Hypothesis 2 | `CONFIRMED` |
| A6 | `X` is not weakly `G`-versal by the central form of the accepted theorem in `GENERALIZATIONS.md` | `CONFIRMED` |
| A7 | the `S3`-action on the base is induced by a linear lift that linearizes `O(1)` | `FIXED-IN-PLACE` |
| A8 | Condition (A) for every abelian `A <= C2 x S3` | `FIXED-IN-PLACE` |
| A9 | "the same witnesses apply to Sylow 2- and 3-subgroups, so the usual Amitsur and higher-Amitsur audits vanish" | `REFUTED` — removed |
| A10 | "Running the relative `G`-MMP therefore retains the displayed conic-bundle contraction as a `G`-Mori model" | `REFUTED` as stated — trimmed to the part that is proved |
| A11 | "the first application in this packet that genuinely uses the stronger residual-RCC/MRC formulation" | `REFUTED` — removed |

The argument shape is exactly the sound one: every rational curve in `T`
maps to a point of the genus-two curve `C`, so an irreducible `S3`-stable RCC
subvariety would force a point of `C^{S3}=empty`; and `T` itself is not RCC
because it dominates `C`. Only accepted machinery is invoked.

### Notes on the fixes and refutations

**A7.** The original file wrote `r[x:y]=[omega x:y]` and appealed to "the
standard two-dimensional linear lift". Those two are incompatible:
`diag(omega,1)` and the swap generate a group of order eighteen in `GL2`,
not `S3`, because `s r s = omega r^{-1}` as matrices. The genuine
two-dimensional irreducible representation of `S3` is
`r=diag(omega,omega^{-1})`, `s=swap`, which induces
`r[x:y]=[omega^2 x:y]` on the base — the same kind of rotation, relabelled.
The file now uses that lift, and `x^6+y^6` is still invariant. This matters
because the `S3`-equivariant structure on `F_1` is what makes `X` an
`S3`-variety at all.

**A8.** The original Condition-(A) proof said "the surface theorem gives a
point `c in C^B`", citing `THEOREM_DIHEDRAL_CONIC_BUNDLE.md`, which is not
salvaged. The witnesses are now inlined and checked: `[1:0:1]` for the
rotation subgroup, and for a transposition the two points of `C` over either
base eigendirection (`[1:1:sqrt 2]` for `s`). The step from `C^B` to `X^A`
was also stated in a garbled order; it now says explicitly that the action of
`A` on the ruling fiber `T_c` factors through the cyclic group `B` because
`z` is trivial on `T`, which is what makes the fixed point exist. (Without
that remark the step is not valid: `C2 x C2` acts on `P^1` without fixed
points in general.)

**A9. REFUTED.** Sylow fixed points do not by themselves give vanishing of
the Amitsur groups, and no Picard or universal-torsor computation was
performed for this threefold. The sentence was deleted; the theorem does not
need it. Item 3 of the theorem statement (Sylow subgroups have fixed points)
survives, and is now derived from Condition (A) plus the observation that
both Sylow subgroups of `C2 x S3` are abelian.

**A10. REFUTED as stated.** What is actually provable, and is retained, is
that `N^1(X/F_1)^G` has rank one — the six discriminant components pair up
into `z`-anti-invariant difference classes — and that `-K_X` is `pi`-ample.
The further assertion about what a relative `G`-MMP "retains" is not proved
and is not needed. This also matches the posture of the corrective commit
`bb62f5f` on `main`, which removed an unsupported `G`-Mori claim from the
conic-bundle theorem there.

**A11. REFUTED.** The quartic-double-solid theorem already on `main` uses the
residual-RCC theorem, so this is not the first such application. The word
"MRC" was also wrong: this proof uses an honest equivariant morphism onto a
positive-genus curve, which `VALIDATION.md` itself says. The Significance
section was replaced by a factual Scope section.

## B. What the salvaged verifier scripts certify

| script | certifies | verdict |
|---|---|---|
| `verify_dihedral_conic_bundle.py` | group axioms, the full subgroup lattice, and the abelian subgroups of `C2 x D_{2n}` for `n=3,5,7,9`; that no abelian subgroup mixes a nontrivial rotation with a reflection and that it contains at most one reflection; an explicit fixed-point witness on `q^2=x^(2n)+y^(2n)` for each, with the reflection witness obtained by solving `2k=j mod n` | `CONFIRMED`, `FIXED-IN-PLACE` |
| `verify_dihedral_sylow_exact.py` | the same group with the *full* `p`-primary rotation subgroup, so it covers the non-squarefree cases `n=9,25,27` that the first script's prime-order rotations miss; Sylow 2 is `⟨z,s⟩` of order four and abelian | `CONFIRMED`, `FIXED-IN-PLACE` |
| `verify_fermat_dp2_s3.py` | the group `C2 x S3`, its subgroup lattice, and a Condition-(A) witness for every abelian subgroup on the Fermat degree-two del Pezzo `w^2=x^4+y^4+z^4`; the exact identity `1+omega^4+omega^8=0` in `Z[omega]`; genus three for the branch quartic; both Sylow subgroups | `CONFIRMED`, `FIXED-IN-PLACE` |
| `verify_new_applications.py` | the union of the two above, in less detail; it is the combined replay entry point | `CONFIRMED`, `FIXED-IN-PLACE` |

**Model identification.** The curve `q^2 = x^(2n)+y^(2n)` used by the two
dihedral scripts is **not** the fixed curve of
`THEOREM_ODD_EXCEPTIONAL_CONIC_BUNDLES.md` on `main`, whose branch form is
`T_0T_1(T_0^{2g}+T_1^{2g})` with `2g+2` roots and genus `g`. The witness
`[0:1:1]` is not even a point of that curve. What the scripts do certify is
the group-theoretic skeleton shared by both families, plus the witnesses for
the model `q^2=x^(2n)+y^(2n)` — which is exactly the residual curve of the
salvaged threefold theorem at `n=3`. The docstrings now say so, so the
scripts are no longer orphaned by the removal of
`THEOREM_DIHEDRAL_CONIC_BUNDLE.md`.

**Vacuous assertions, fixed.** All four scripts used exact integer or
cyclotomic arithmetic, but several geometric facts were recorded as
tautologies rather than computed. Removed and replaced with real checks:

- `assert not residual_full_fixed` and
  `assert residual_full_fixed_base is False` (both scripts) — replaced by an
  exact exponent check that `2k = 0 mod n` forces `k = 0` for odd `n`;
- `assert 2 != 0 and 4 != 0`, `assert 3 != 0` (both Fermat sections) —
  replaced by an exact coefficient check on the binary quartic `2x^4+z^4`,
  and by an exact verification that `span(1,1,1)` is the unique invariant
  line of the permutation representation together with `1+1+1=3 != 0`;
- `one_plus_omega_plus_omega2 = (0,0); assert ... == (0,0)` in
  `verify_new_applications.py` — replaced by an exact reduction of
  `1+omega^4+omega^8` in `Z[t]/(t^2+t+1)`, matching what
  `verify_fermat_dp2_s3.py` already did honestly;
- the `all(True for _ in h)` no-op Sylow filter — replaced by a check that
  each selected subgroup has `p`-power order and that the number of Sylow
  `p`-subgroups is `1 mod p` and divides the group order.

All six markers replay after the changes.

## C. Adjudication of the two claims that lost their theorem files

Both are correct; neither theorem file is salvaged, so the statements are
recorded here.

**C1. Fermat degree-two del Pezzo with `C2^Geiser x S3`.** `CONFIRMED`.
Let `S_F={w^2=x^4+y^4+z^4}` with `S3` permuting `x,y,z` and `tau` the Geiser
involution. `S_F^tau` is the smooth Fermat plane quartic of genus three, so
it contains no rational curve; `(P^2)^{S3}=\{[1:1:1]\}` and `3 != 0`, so
`S_F^{C2 x S3}` is empty; Condition (A) holds by the witnesses above. The
central form of the residual-RCC theorem then shows `S_F` is not weakly
`C2 x S3`-versal. This is a routine instance of accepted machinery, but it is
not covered by the repository's existing Fermat degree-two work in
`FIX_T34_CENTRAL_OBSTRUCTION`, which enumerates only the order-16 subgroups.
The original file's further claim that "restriction-corestriction kills the
universal-torsor/ordinary Amitsur class" is plausible from the Sylow fixed
points but was not carried out; it is not recorded as established.

**C2. Odd-dihedral conic-bundle surfaces `uv=(x^(2n)+y^(2n))w^2`.**
Superseded. `main` already carries a stronger and differently modelled
infinite family in `THEOREM_ODD_EXCEPTIONAL_CONIC_BUNDLES.md`. Only the
group and witness bookkeeping is salvaged, as a certificate for the
threefold theorem at `n=3`.

## D. Gap left open

`THEOREM_RULED_CONIC_BUNDLE_THREEFOLD.md` has no dedicated verifier. Its
finite inputs are the `n=3` case of `verify_dihedral_conic_bundle.py`; the
smoothness, eigenpoint, and fiber-product steps are proof-only. This is
recorded rather than papered over.
