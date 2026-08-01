# Unrestricted fibration audit

The installed exact birational models are:

1. the original smooth Picard-rank-one cubic threefold;
2. the ten blowups of connected coordinate degree-three schemes, producing
   genus-one fibrations with generic period and index three;
3. after the degree-55 extension, projection from one `D12`-line, producing
   the usual conic-bundle model only over that extension;
4. the blowup of the connected degree-55 point.

The original Picard-rank-one model has no nonconstant regular fibration to a
lower-dimensional projective base.  The ten coordinate genus-one fibrations
have no sections.  The 55 conjugate conic bundles do not descend to a single
`K`-conic bundle with a section, and restriction--corestriction of their
points yields only the known degree-55 cycle.

No exhaustive two-ray-game or Galois-equivariant Mori classification is
known after blowing up the degree-55 point or other noncoordinate centers.
In particular, a `K`-point of the full threefold can lie on a special fibre
of every installed coordinate model.

## Schur-split Pfaffian link

The Schur boundary vanishes over `K_Schur`, so the Pfaffian section space is
the split `P(V6*)=P5_K`.  Its nonempty smooth open has a `K`-point.  Hence
`X_Schur` unconditionally contains a smooth geometrically integral elliptic
normal quintic `C`, and the Fano--Iskovskikh construction gives a `K`-defined
birational link to

```text
V14 = Gr(2,V6) cap P(B5^perp).
```

This new model does not yet produce a point.  The tautological Schur point
is the generic point of `P(V6)` and lies off the proper Palatini quartic swept
out by the lines represented by `V14`.  Schubert intersections give only
degree-4 and degree-5 cycles on `V14`.  The known degree-3 linear section is
disjoint from `C`, while the degree-55 cycle supplies no divisor degree
coprime to the existing degree-five polarization.  These statements and the
line-restriction ranks are replayed in `schur_enq_v14/`.

Formally, if `C` met the descended orbit of 66 `D10` lines, descent and the
absence of trisecants would force a degree-66 divisor; `gcd(5,66)=1` would
then give `C(K)` and hence `X_Schur(K)`.  The exact orbit computation closes
this possibility inside the selected family.  At the split good prime 331,
the 66 `D10` incidence quadrics span all 21 quadrics on the section `P5`; so
do the 55 `D12` incidence quadrics.  Their common projective loci are empty,
and nonzero rank-21 minors lift the conclusion to characteristic zero.
Every descended Pfaffian quintic is therefore disjoint from both line unions.

## Full-Schur Palatini point model

The exact Schur `B5` five-plane in `Lambda^2(V6*)` defines the contraction
matrix `C(p)=[omega_0 p|...|omega_4 p]`.  The source-bound characteristic-zero
audit in `full_schur_palatinian/` proves that all signed maximal minors are
`p_i I4(p)` up to one scalar, where `I4` is the unique Schur-invariant
quartic.  The proof matches the exact `Q(zeta_11)` intertwiner to the good
fibre `(23,zeta_11-2)` and proves the characteristic-zero invariant
multiplicity is one by CRT.

Six degree-seven Reynolds self-covariants form a generic projective
Hilbert--90 frame.  Thus the point gate on the associated twisted `V14` is
the explicit invariant-field identity

```text
I4(sum_i b_i r_i)=0,  b_i in K_Schur, not all zero.
```

Constant-coefficient polynomial self-covariants landing on this quartic are
excluded through degree seven.  No invariant-rational solution `b_i`, and
hence no `V14(K_Schur)` or `X_Schur(K_Schur)` point, is constructed.

The independent `fixed_curve_bridge/` theorem gives another exact positive
interface: any actual `K_Schur`-defined odd-degree genus-zero stable map, or
any actual point of the generalized-twisted-cubic Hilbert component, forces
`X_Schur(K_Schur)` to be nonempty.  The available virtual count and
Galois-stable curve orbits do not supply such an actual descended object.

Thus this run adds an unrestricted birational model and closes a natural
incidence route, but gives no covering family, multisection-to-point
execution, or rational
point.  The exit `Q-NEW-FIBRATION-PASS` therefore does not fire.
