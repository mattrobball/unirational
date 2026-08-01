# Primitive quartic and linked quintic descent audit

## Verdict

`Q-UNDECIDED`.

Nothing in this audit crosses the Cassels--Swinnerton-Dyer boundary.  In the
hypothetical no-point branch, the strongest exact package is

\[
\Gamma _4\subset S,
\qquad
C_\Gamma\cap S=\Gamma _4+Q_5,
\]

where `Gamma_4` is a primitive full-span quartic point, `C_Gamma` is a
`K_Schur`-defined twisted cubic, and `Q_5` is an integral quintic point.
Balestrieri's Theorem 3.8 is exactly this `4+5` construction.  Applying the
same construction to `Q_5` returns `Gamma_4`; it does not descend further.

This file assumes the binding reduction in the parent packet: `S/K` is the
general smooth cubic-surface hyperplane section, `K=K_Schur`, `E/K` is the
Schur splitting field with group `PSL2(F11)`, and, if `S(K)` is empty,
Voisin's degree-four alternative is a primitive separable point whose Galois
closure is `A4` or `S4` and whose span is all of `P3`.

## 1. Balestrieri Theorem 3.8 is the canonical `4+5` link

The word *simple* in Balestrieri's theorem modifies the field extension:
the hypothesis is `L_4=K(alpha)` of degree four.  It is not a geometric
smoothness or multiplicity condition on the point.  Since `K` has
characteristic zero, the separable quartic residue field is simple.

Let `f_4(t)` be the minimal polynomial of `alpha`.  Write the coordinates of
the quartic point in the power basis `1,alpha,alpha^2,alpha^3`.  Full span
means that the resulting four coordinate polynomials `s_i(t)` form a basis
of the polynomials of degree at most three.  Thus

\[
t\longmapsto [s_0(t):s_1(t):s_2(t):s_3(t)]
\]

is a `K`-defined transport of the rational normal cubic.  If `F` is the cubic
equation of `S`, Balestrieri's proof writes

\[
F(s(t))=f_4(t)g(t).
\]

When `S(K)` is empty, `deg F(s)=9`: cancellation of the leading term would
give a nonzero `K`-vector on which `F` vanishes.  Hence `deg g=5`.  This is
precisely Bezout on the twisted cubic.

In the no-point branch `g` is irreducible.  Any nontrivial partition of five
has a part of degree one or two; a degree-one point is already a `K`-point,
and a degree-two point descends by the secant construction.  The quartic
factor also occurs with multiplicity one, since a second copy would leave a
linear residual factor.  Therefore

\[
C_\Gamma\cap S=\Gamma _4\sqcup Q_5
\]

is reduced and has the integral partition `4+5`.

There is an exact reverse check which is easy to miss.  Let `beta` be a root
of `g`.  The quintic point is represented by the **same** vector `s(beta)`.
For the degree-five input the same lift has degree three, which is less than
five, and division gives

\[
F(s(t))=g(t)f_4(t).
\]

Thus Balestrieri's construction on this linked quintic returns the original
quartic:

\[
4\longmapsto5\longmapsto4.
\]

For an arbitrary simple quintic point, Corollary 3.10 with `(d,n)=(3,5)`
only guarantees a point of degree coprime to `15` and at most `7`, hence a
degree in `{1,2,4,7}`.  In the no-point branch the first two are excluded,
leaving `4` or `7`.  The `4` branch loops through Theorem 3.8 and the `7`
branch is larger.  There is no forced strictly decreasing ladder.

Primary source: F. Balestrieri, *Degrees of closed points on hypersurfaces*,
[arXiv:2304.04562v2](https://arxiv.org/abs/2304.04562), Theorem 3.6,
Theorem 3.8, and Corollary 3.10.

## 2. Exact quartic--quintic field lattice

Write

- `L_4/K` for the quartic residue field and `N/K` for its Galois closure;
- `L_5/K` for the linked quintic residue field and `R/K` for its Galois
  closure.

The residue fields themselves have coprime degrees, so

\[
L_4\cap L_5=K,
\qquad [L_4L_5:K]=20.
\]

The Galois closures can overlap, but only as follows.  The transitive
subgroups of `S5` and their nontrivial quotient orders are

| quintic group | nontrivial quotient orders |
|---|---|
| `C5` | `5` |
| `D10` | `2,10` |
| `F20` | `2,4,20` |
| `A5` | `60` |
| `S5` | `2,120` |

The nontrivial quotient orders of `A4` are `3,12`; those of `S4` are
`2,6,24`.  Since `N cap R` is Galois over `K`, its Galois group must be a
common quotient.  Consequently:

1. if `Gal(N/K)=A4`, then `N cap R=K`;
2. if `Gal(N/K)=S4`, then `N cap R` is either `K` or the unique discriminant
   quadratic subfield of `N`.

In the second case, the possible quintic groups are `D10`, `F20`, or `S5`.
Their index-two kernels are respectively `C5`, `D10`, and `A5`, and each is
still transitive on five letters.  Thus even over the possible common
quadratic field the linked quintic remains an integral degree-five point.
Moreover, if that quadratic field supplied an `S`-point, quadratic secant
descent would already contradict the no-point hypothesis.

The exhaustive finite computation generating all `156` subgroups of `S5`
and all `30` subgroups of `S4`, rather than consulting a group database, is
in `produce_linked_quintic_certificate.py`; the independent replay is
`verify_linked_quintic_certificate.py`.

## 3. The entire linked package is independent of the Schur field

The previously known independence strengthens from each field separately to
the combined link:

\[
E\cap NR=K.
\]

Indeed, `Gal(E/K)=PSL2(F11)` is simple.  A nontrivial Galois intersection
would therefore have Galois group of order `660`.  But

\[
|\operatorname{Gal}(NR/K)|\mid 24\cdot120=2880,
\]

and `11` does not divide `2880`.  No such quotient exists.

Consequences:

- the quartic stays degree `4` over `E` and over the degree-`55` line field
  `E^D12`;
- its cubic resolvent stays degree `3`;
- the linked quintic stays degree `5`;
- the linked pair stays degree `20`;
- the raw product orbit sizes with the Schur line orbit are respectively
  `220`, `165` for a line and a pairing, `275` for a line and a quintic, and
  `1100` for a line and the marked linked pair.

This rules out a purely field-theoretic claim that splitting the `55` Schur
lines selects a quartic vertex, a pairing, or a quintic root.  It does not
rule out a genuinely geometric correspondence whose image orbit collapses;
no such degree-lowering correspondence was found here.

The simplicity, stabilizers, cubic resolvents, and product orbits are
replayed by `produce_field_certificate.py` and
`verify_field_certificate.py`.

## 4. The shared twisted cubic imposes no hidden splitting relation

For the standard twisted cubic

\[
[s:t]\longmapsto[s^3:s^2t:st^2:t^3],
\]

restriction sends a cubic monomial in the four ambient coordinates to a
binary monomial `s^(9-w)t^w`.  The twenty cubic monomials realize every
weight `w=0,...,9`.  Therefore

\[
H^0(\mathbf P^3,\mathcal O(3))
\longrightarrow H^0(\mathbf P^1,\mathcal O(9))
\]

has rank ten and is surjective.

It follows that an arbitrary binary product `f_4 g_5` can occur as the
restriction of some cubic form to this twisted cubic.  In particular, the
mere fact that the factors share `C_Gamma` cannot impose equality or
containment between their splitting fields.  The geometry certificate uses

\[
f_4=t^4-t+1,
\qquad g_5=t^5-t-1,
\]

which are irreducible modulo `2` and `3`, respectively.  Their product has
no rational root and is exactly realized by the restriction matrix.

This is a countermodel only to a proposed **linkage mechanism**.  It is not a
pointless smooth cubic surface and therefore is not a counterexample to the
Cassels--Swinnerton-Dyer conjecture.

## 5. What the degree-55 postulation does and does not add

For the hyperplane-selected Schur point `Z_55`, the repository-certified
Hilbert function in degrees zero through six is

\[
1,4,10,19,31,45,55.
\]

After quotienting the point ideal by multiples of the cubic equation of
`S`, the dimensions of proper hypersurface carriers on `S` are

\[
0,0,0,0,0,1,9.
\]

Thus no proper divisor of degree at most four on `S` contains `Z_55`.  There
is a unique proper quintic carrier; its curve on `S` is a `(3,5)` complete
intersection of degree `15` and genus `31`.  Its canonical bundle is
`O(4)`, of degree `60`, and the same postulation gives no canonical section
vanishing on `Z_55`.  Hence the unique carrier does not itself convert a
quartic point into a rational point.

There is also a clean complete-intersection obstruction.  If two proper
hypersurfaces contain `Z_55+Gamma_4`, their degrees are at least five.  A
proper intersection with `S` has length `3ab`, so its residual length is

\[
3ab-59\ge75-59=16.
\]

Residual length one would require `ab=20`, incompatible with `a,b>=5`, and
residual length two would require `3ab=61`.  The elementary
complete-intersection carrier therefore cannot close the descent.  Contact,
non-complete-intersection, and special Schur-equivariant curves remain open.

Exact positive interfaces, none supplied by this audit, include:

- a proper `K`-curve of degree `20` through `Z_55+Gamma_4` with simple
  intersection, leaving one point;
- a proper `K`-curve of degree `22` through
  `Z_55+Gamma_4+Q_5`, leaving a degree-two cycle;
- a `K`-rational curve of degree `d` having contact multiplicity `m` at all
  four quartic embeddings, leaving degree `3d-4m`.  The first unexcluded
  arithmetic gates are `(d,m)=(3,2)` for residual one, `(6,4)` for residual
  two, and `(7,5)` for residual one.  The tangent-twisted-cubic audit in the
  parent packet already shows that `(3,2)` is not automatic.

## 6. Why `CH_0`, symmetric powers, and `A4` do not finish the proof

The difference `Q_5-Gamma_4` is a signed degree-one zero-cycle.  This adds no
effectivity: index one was already known.  Although `C_Gamma` is isomorphic
to `P1_K`, it is not contained in `S`; rational equivalences of divisors on
`C_Gamma` therefore do not push forward to rational equivalences on `S`.
Its `K`-points normally lie off the cubic surface.

Ma's Proposition 4.1 constructs a rational map from `Sym^d(S)` to one of
`Sym^1(S)`, `Sym^4(S)`, or `Sym^10(S)`.  It does not force the first target,
and a quartic can remain quartic.  Voisin's current theorem sharpens the
effective alternative to degree four but stops there.  These are precisely
the surviving CSD boundary, not a hidden symmetric-power proof.

Finally, `A4` here is the Galois group permuting the four embeddings of one
closed point.  It is not an installed faithful subgroup of `Aut_K(S)`.
Duncan's theorem on cubic surfaces with an honest `A4` automorphism action
therefore does not apply.

## 7. Honest status

The audit proves new exact independence and linkage statements, and it
eliminates Balestrieri iteration, raw Schur-field splitting, elementary
complete intersections, and a divisor-on-the-twisted-cubic argument as
automatic descents.  It neither constructs a `K_Schur`-point nor proves
pointlessness.

The current external headline is consistent with this boundary: Cheltsov,
Tschinkel, and Zhang, *Equivariant unirationality of Fano threefolds*, dated
2026-07-18, still list the `PSL2(F11)` action on the Klein cubic as open.

