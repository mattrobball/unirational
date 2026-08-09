# Refinement-invariant carrier definitions

## 1. Minimal model

The intrinsic carrier model for the restricted map `g:X⇢X` is the normalized
graph
\[
\Gamma=\operatorname{Proj}_X\overline{\mathcal R(J)}.
\]
A smooth equivariant principalization
\[
r:Y\to\Gamma
\]
is computational scaffolding.  A curve chosen only on `Y` is not an essential
carrier unless its image on `Gamma` is one of the objects below.

Call a subvariety **landing-horizontal** when the target morphism `q` is
nonconstant on it.  This terminology is used also for varieties lying over a
point of `X`; it refers to the landing map, not to `pi`.

## 2. Valuative carriers

For a divisorial valuation `v` of `C(X)`, define the **valuative carrier**
\[
\mathfrak C(v)=(v,K_v,\pi|_{K_v},q|_{K_v}),
\]
where `K_v` is the center of `v` on `Gamma`.

This is invariant under every common refinement.  If `v` appears as a divisor
`D_v` on `Y`, then `D_v→K_v` is dominant.  The divisor is essential as a Rees
divisor exactly when `K_v` is itself a divisor on `Gamma`.  Otherwise the
refinement divisor is contracted and contributes only the map already carried
by `K_v`.

The ordinary blowup valuation of an original fixed curve is a named valuative
carrier even when its center has dimension one rather than two.

## 3. Essential fixed carriers

Let `H` be an involution or a relevant `V4` subgroup and let `Z` be an
irreducible fixed stratum in the source.

An **essential `H`-fixed carrier over `Z`** is the normalization of an
irreducible component `C` of
\[
(\Gamma^H)_{red}\cap\pi^{-1}(Z)
\]
which is maximal under inclusion among components satisfying:

1. `pi(C)` is dense in `Z` when `dim Z>0`;
2. `q|_C` is nonconstant.

Maximality prevents an arbitrary section inside a fixed carrier surface from
being promoted to a new carrier.  A later fixed curve lying inside such a
surface carries only the restriction of the already installed surface map.

When `Z` is a point, the carrier is an actual component of the normalized point
fiber or a maximal fixed subvariety inside a stable surface component.

## 4. Stable junction carriers

A faithful-`V4` curve is not contained in `Gamma^{V4}`.  To record such
objects, an **essential stable junction carrier over a marked point `x`** is
the normalization of a `V4`-stable irreducible component of
\[
\pi^{-1}(x)_{red}
\]
on which `q` is nonconstant, again maximal under inclusion.  Surface
components are allowed.  The involution-fixed curves inside them are recorded
as fixed slices of that stable carrier rather than as independent divisorial
valuations.

## 5. Strict and ordinary carriers over `E_t` and `L_t`

For `S=E_t` or `L_t` there are two canonical cases.

- If `g` is defined at the generic point of `S`, the strict transform of `S` in
  `Gamma` is a canonical carrier, birational to `S`.
- If the generic point is in the base scheme, use the ordinary blowup valuation
  `v_S`.  Its center `K_S` is canonical and has dimension one or two.

No section of `P(N_{S/X})` is selected.  The normalized graph selects the
center by its function field.

## 6. Refinement theorem

Let `Y→Gamma` be any proper equivariant birational refinement.

1. Every divisor on `Y` maps to the valuative carrier of its valuation.
2. Every landing-horizontal irreducible component of `Y^H` maps into an
   essential fixed carrier on `Gamma`.
3. Every landing-horizontal `V4`-stable component of the fiber over a marked
   point maps into an essential stable junction carrier.
4. The induced morphism to `X` is the pullback of the morphism on the intrinsic
   carrier.

Thus refinements may separate branches or create exceptional sections, but
cannot create a new essential target map.

## 7. Finite profile for a fixed ideal

Because `Gamma` and all finite-group fixed loci are Noetherian, a fixed ideal
has finitely many intrinsic carriers.  This is the exact finiteness obtained in
this packet.  A uniform bound over all homogeneous landing ideals would require
a theorem bounding their Rees valuations and normalized fiber components; no
such theorem is currently installed.
