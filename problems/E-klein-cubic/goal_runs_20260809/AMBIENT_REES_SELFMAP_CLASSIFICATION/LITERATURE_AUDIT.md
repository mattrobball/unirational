# Literature audit

**Audit date:** 2026-08-09.

The literature separates sharply into categories that do **not** by themselves
control the present ambient rational landing problem.

## Rees valuations and integral closure

Classical Rees valuation theory identifies the finitely many divisorial
valuations governing integral closures of powers of an ideal and realizes them
on the normalized blowup. Standard sources include D. Rees, *Valuations
associated with ideals* (Proc. LMS, 1956), and Swanson--Huneke, *Integral
Closure of Ideals, Rings, and Modules*. This justifies treating
`Proj(overline{R(I_P)})` as canonical divisorial data. It supplies no special
relation between `v(I_P)` and `v(F_source)` for a tuple satisfying the target
identity `F(P)=0`.

## Regular endomorphisms versus rational selfmaps

Amerik--Rovinsky--Van de Ven, *A boundedness theorem for morphisms between
threefolds* (Ann. Inst. Fourier 49 (1999)), and Beauville,
*Endomorphisms of hypersurfaces and other manifolds* (IMRN 2001;
arXiv:math/0008205), concern **morphisms / regular endomorphisms**. Beauville's
theorem that a smooth hypersurface of degree greater than two and dimension
greater than one admits no endomorphism of degree greater than one does not
apply to dominant rational selfmaps, and therefore does not control the
ambient rational landing category here.

Chen--Stapleton, *Rational endomorphisms of Fano hypersurfaces*
(arXiv:2103.12207), studies degree congruences for rational endomorphisms of
very general Fano/Calabi--Yau hypersurfaces via characteristic-p
specialization. It does not provide a rigidity theorem for this special Klein
cubic or for polynomial maps from ambient projective space landing identically
in the cubic.

## Equivariant birational rigidity and cubic threefolds

Cheltsov--Krylov--Ma'u, *G-birationally rigid cubic threefolds*
(arXiv:2604.20426), classifies relevant `G`-birational rigidity phenomena for
cubic threefolds. This is powerful in degree one, but birational rigidity does
not exclude generically finite rational selfmaps of higher degree and does not
classify ambient landing tuples.

Cheltsov--Tschinkel--Zhang, *Equivariant geometry of singular cubic
threefolds* (arXiv:2401.10974), uses equivariant MMP, intermediate Jacobians,
and Burnside invariants for linearization/birational questions. Again these
are not the exact ambient polynomial landing condition.

Tschinkel--Zhang, *Stable equivariant birationalities of cubic and degree 14
Fano threefolds* (arXiv:2409.08392), develops equivariant
Pfaffian--Grassmannian constructions. It concerns stable equivariant
birationality, not a global identity `F(P)=0` for a rational map from `P^4`.

## Equivariant Burnside groups and essential dimension

Kresch--Tschinkel, *Equivariant birational types and Burnside volume*
(arXiv:2007.12538), *Equivariant Burnside groups: structure and operations*
(arXiv:2105.02929), and *Equivariant Burnside groups and representation
theory* (arXiv:2108.00518), provide birational invariants of group actions.
They distinguish equivariant birational types but do not encode the nonlinear
normal-extension equation for an ambient landing tuple.

Reichstein--Youssin and related essential-dimension work provides equivariant
resolution/compression machinery, but it does not replace the exact landing
identity or determine its normalized Rees algebra.

## Matrix factorizations / MCM modules

Equivariant matrix-factorization theory exists for invariant hypersurfaces, and
matrix factorizations encode MCM modules over `C[W]/(F)`. This is naturally a
theory **on the hypersurface ring**. The present distinction is between an
identity modulo `(F)` and an identity in `C[W]`; no audited result turns the
nonlinear set `{P:F(P)=0}` into an additive finitely generated syzygy module.

## Conclusion of audit

No audited theorem directly classifies dominant rational maps

\[
P(W_5)\dashrightarrow X
\]

defined by a single homogeneous `G`-covariant tuple satisfying the exact
global identity `F(P)=0`.

The most important structural theorem is internal rather than imported:
postcomposition by any rational `G`-selfmap preserves ambient landing. Hence,
if one ambient landing map exists, ambient-extendable restrictions have
unbounded degree. Existing theorems about regular endomorphisms, birational
rigidity, Burnside invariants, or MCM modules cannot be cited as an ambient
identity theorem.
