# Curve-incidence audit: exact no-forcing result

## Verdict

**Q-UNDECIDED.**  Neither the primitive quartic point nor its cubic-resolvent
point is forced by known rational-curve incidence counts to lie on a
genus-zero curve defined over the ground field.  This audit closes the
suggested counting shortcut; it does not prove pointlessness.

## 1. Correctly normalized Gromov--Witten numbers

Let `X` be a smooth cubic threefold and `H` its hyperplane class.  Since

\[
\int_X H^3=3,\qquad H^3=3[\mathrm{pt}],
\]

an invariant with `d` insertions of `H^3` is `3^d` times the invariant
with `d` point insertions.  Zinger's table on journal page 1058 gives

| degree `d` | raw invariant | point-normalized invariant |
|---:|---:|---:|
| 1 | `18` | `18/3 = 6` |
| 2 | `108/2 = 54` | `54/9 = 6` |
| 3 | `648/3 = 216` | `216/27 = 8` |
| 4 | `15552` | `15552/81 = 192` |

The expected-dimension check is exact: on a cubic threefold

\[
\operatorname{vdim}\overline M_{0,n}(X,d)=2d+n,
\]

and `n=d` point conditions have total codimension `3d`, leaving dimension
zero.  Thus the relevant candidate numbers are `8` twisted cubics through
three general points and the virtual number `192` degree-four stable maps
through four general points.

The divisions by `2` and `3` in the raw column are essential.  Zinger's
display uses the divisor-equation chains
`<H^3,H^3>=(1/2)<H^3,H^3,H>` and
`<H^3,H^3,H^3>=(1/3)<H^3,H^3,H^3,H>`; the printed `108` and `648` are
the divisor-augmented invariants, not the two- and three-point raw values.

Primary source: Aleksey Zinger, *The genus 0 Gromov--Witten invariants of
projective complete intersections*, Geometry & Topology 18 (2014),
1035--1114, DOI `10.2140/gt.2014.18.1035`,
<https://msp.org/gt/2014/18-2/gt-v18-n2-p12-s.pdf>.  Crucially, immediately
after the table Zinger says the displayed invariants are enumerative at
least for `d=1,2,3`.  Degree `4` is not included in that assertion.

## 2. Quartic incidence cannot force descent

Assume the no-point branch of the existing quartic frontier.  The integral
degree-four point has primitive Galois closure `A4` or `S4`.  Even granting
the extra, unproved hypotheses that its four conjugates are in the general
incidence locus and that the degree-four invariant is represented by 192
reduced rational quartics, the Galois-stable set of curves need not contain
a fixed curve:

\[
192=16\,|A_4|=8\,|S_4|.
\]

It can be a disjoint union of 16 regular `A4`-orbits or 8 regular
`S4`-orbits.  A cardinality divisible by the group order gives no fixed-point
congruence.  In reality the conclusion is weaker still: the 192 is a
virtual stable-map invariant, and the Voisin-produced quartic support is
not proved to avoid the evaluation discriminant or stable-map boundary.
Specialization may create nonreduced points, excess components, reducible
maps, or virtual multiplicities.

Harris--Roth--Starr prove that the smooth rational-quartic locus is
irreducible of dimension eight.  That gives the expected zero-dimensional
four-point incidence problem; it gives neither its enumerativity on the
Klein cubic at this support nor a rational section of the incidence map.
Irreducibility of the total space does not force a rational point in a
degree-192 fibre.

## 3. Cubic-resolvent incidence cannot force descent

The three residual points supplied by pairing the quartic conjugates have
Galois closure `C3` in the `A4` case and `S3` in the `S4` case.  Zinger's
degree-three invariant is enumerative for general incidence and gives 8
twisted cubics through three general points.  But

\[
8\equiv2\pmod 3,
\]

so a genuine `C3`-action on a reduced eight-element fibre must have a fixed
point: all nonfixed `C3`-orbits have size three.  This gives a useful
**conditional** descent in the `A4` resolvent branch.  It is not
unconditional here, because the secant-resolvent triple is not proved to lie
in the general-incidence open set; specialization can introduce boundary,
multiplicity, or excess dimension.  In addition, the eight incidence curves
are not proved to be split by the cubic Galois closure, so the full arithmetic
Galois action need not factor through `C3`.

There is no analogous cardinality force in the `S4` branch: `S3` has
fixed-point-free orbits of sizes two and six, and `8=2+6`.  Thus even a
reduced enumerative eight-set with an `S3`-action need not contain a fixed
curve.

The compactification theorem of Bayer--Beentjes--Feyzbakhsh--Hein--
Martinelli--Rezaee--Schmidt does not repair this.  A **ground-field point**
of the generalized twisted-cubic Hilbert component maps through their
theta desingularization and, in the already-audited twist, would yield a
ground-field point of `X`.  A Galois-stable finite Hilbert zero-cycle is not
a ground-field Hilbert point; its individual Abel--Jacobi images live over their
residue fields, so the statement `J_T(K)=0` does not put them in the
exceptional fibre over zero.

Primary geometric sources used for this boundary are:

- Harris--Roth--Starr, *Curves of small degree on cubic threefolds*,
  <https://arxiv.org/abs/math/0202067>;
- Bayer et al., *The desingularization of the theta divisor of a cubic
  threefold as a moduli space*, <https://arxiv.org/abs/2011.12240>.

## 4. Exact boundary

A fixed smooth rational quartic or twisted cubic would indeed be a
ground-field genus-zero curve and hence, by the audited secant bridge, would
give a ground-field point of `X`.  The incidence counts supply only
Galois-stable zero-cycles on parameter spaces.  Taking the union of conjugate
curves produces a ground-field **geometrically reducible** 1-cycle, not the
geometrically integral genus-zero curve required by that bridge.

The two candidate degrees also have

\[
\gcd(8,192)=8,
\]

so combining them does not even manufacture a coprime-degree fixed-point
argument on the curve parameter spaces.  A positive continuation would need
an actual equivariant fixed-curve computation, a canonical selection/section,
or a direct analysis of the specialized incidence fibre; the ordinary GW
degrees alone cannot do it.

```text
Q_SCHUR_CURVE_INCIDENCE_NO_DESCENT_FORCE_EXACT
```
