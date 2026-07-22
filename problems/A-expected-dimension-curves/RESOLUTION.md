# Resolution of Problem A

## Verdict

For every row labelled **Targets (open)** in `SPEC.md`, every component whose
generic member is birational onto its image has the predicted dimension.
Equivalently, its dimension in the projectivized parametrized-map space is
`exp(n,d,e) + 3`.

| n | d | e | curve dimension | projective-map dimension | reason |
|---|---|---|---:|---:|---|
| 4 | 4 | 2 | 5 | 8 | Coskun--Starr (also the conic argument below) |
| 4 | 4 | 3 | 7 | 10 | Coskun--Starr |
| 5 | 5 | 2 | 6 | 9 | Coskun--Starr (also the conic argument below) |
| 5 | 5 | 3 | 8 | 11 | Coskun--Starr |
| 4 | 5 | 2 | 3 | 6 | conic argument below |
| 4 | 5 | 3 | 4 | 7 | cubic rank stratification below |
| 5 | 6 | 2 | 4 | 7 | conic argument below |

Thus these rows are calibrations, not new open instances.

## Literature correction for the index-two rows

Coskun and Starr use `X_d \subset P^N`.  For a general such hypersurface, at
the end of the proof of their Theorem 1.6 they treat the exceptional cases

    (d,N) = (3,4), (4,5), (5,6)

and prove, for every `e >= 2`, that the Kontsevich space has exactly two
irreducible components, both of expected dimension: the covers-of-lines
component and a component generically parametrizing smooth rational curves.
Their `(4,5)` and `(5,6)` are precisely Harris's `(n,d)=(4,4)` and `(5,5)`.
This settles all four `d=n` rows, and much more than the table asks.

Reference: I. Coskun and J. Starr, *Rational curves on smooth cubic
hypersurfaces*, especially Theorem 1.6 and the exceptional-case argument on
p. 9: <https://homepages.math.uic.edu/~coskun/revcubic.pdf>.

For a smooth complex Fano hypersurface `X_d \subset P^N`, with `N >= 4` and
`d <= 6`, Furukawa proves that every nonempty irreducible component of the
smooth-conic Hilbert locus `R_2(X)` has dimension `3N-2d-2`, provided the
plane spanned by its general conic is not contained in `X`.  A general
hypersurface in every table row contains no plane, because

    3(n-1) - binom(d+2,2) < 0.

Reference: K. Furukawa, *Dimension of the space of conics on a Fano
hypersurface*, Theorem 1.1: <https://arxiv.org/abs/1702.08890>.

## A standalone characteristic-zero proof in degrees two and three

Let

    A_e = P(H^0(P^1,O(e))^(n+2))

be the projective coefficient space, of dimension `(e+1)(n+2)-1`, and let
`H_d` be the projective space of degree-`d` hypersurfaces.  On any component
of the zero locus of the `ed+1` coefficients of `F(c)`, Krull gives

    dim >= (e+1)(n+2)-1-(ed+1)
        = e(n+2-d)+n
        = exp(n,d,e)+3.                                      (1)

We prove the matching upper bound on the birational locus.

### Degree two

A basepoint-free degree-two map birational onto its image has coefficient
matrix of rank three and embeds `P^1` as a plane conic.  These maps form an
irreducible open subset `B_2` of `A_2`.  A conic is projectively normal, so
for each `c in B_2` the condition `F(c)=0` imposes exactly `2d+1` independent
linear conditions on `F`.  Hence the incidence over `B_2` is a projective
bundle.  The generic-fiber dimension theorem gives, for a general `F`,

    dim (B_2)_F <= (3n+5)-(2d+1) = 3n+4-2d.                  (2)

Together, (1) and (2) prove that every degree-two main component has map
dimension `3n+4-2d`, or curve dimension `3n+1-2d` after quotienting by
`PGL_2`.

For completeness, the incidence is dominant in the range used here.  Put

    c = [s^2 : st : t^2 : 0 : ... : 0],
    q = x_0*x_2-x_1^2,
    F = q*A + sum_{i=3}^{n+1} x_i*B_i.

Writing `S_m=H^0(P^1,O(m))`, its normal derivative has image

    a*S_4 + b_3*S_2 + ... + b_(n+1)*S_2  inside S_(2d),

where `a=A|_c in S_(2d-4)` and `b_i=B_i|_c in S_(2d-2)`.  Choose
`a=s^(2d-4)`.  Its multiples cover monomials with `t`-exponents 0 through 4.
Partition the remaining exponents 5 through `2d` into blocks of at most
three and choose monomial `b_i` whose quadratic multiples cover each block.
There are enough `b_i` because

    2d-4 <= 3(n-1)

for `d <= n+1`.  All the chosen binary forms lift to forms on the conic.
Thus one normal derivative is surjective, proving dominance and nonemptiness
for a general hypersurface.

### Degree three

There are two possible coefficient ranks for a basepoint-free birational
degree-three map.

* Rank four gives a twisted cubic.  This is an open subset `B_(3,4)` of
  `A_3`, of dimension `4n+7`.  Projective normality makes `F(c)=0` impose
  `3d+1` independent conditions.  Therefore a general fiber has dimension
  at most

      T = 4n+7-(3d+1) = 4n+6-3d.                            (3)

* Rank three gives the normalization map of an integral singular plane
  cubic.  The rank-three stratum `B_(3,3)` has dimension

      3((n+2)+4-3)-1 = 3n+8.

  A plane cubic has `h^0(O_C(d))=3d`, so containment imposes `3d`
  independent conditions.  Its general fiber therefore has dimension at
  most

      3n+8-3d = T-(n-2) < T                                (4)

  for the dimensions in the table.

Rank at most two is a cover of a line, not a birational map.  If a component
of the full equation scheme were generically rank three and birational, (4)
would give dimension strictly below `T`, contradicting the Krull lower bound
(1).  Every main component is therefore generically rank four; (1) and (3)
give its dimension exactly `T`.

This proves the main-component assertion for all degree-three rows.  To also
certify nonemptiness in the one index-one target `(n,d,e)=(4,5,3)`, take

    c = [s^3 : s^2*t : s*t^2 : t^3 : 0 : 0]

and, with

    q_1 = x_0*x_2-x_1^2,       q_3 = x_1*x_3-x_2^2,

take the quintic

    F = q_1*x_0*x_2^2 + q_3*x_2*x_3^2 + x_4*x_0^4 + x_5*x_3^4.

Along `c`, its six partial derivatives are

    g_0 = s^6*t^6,
    g_1 = -2*s^7*t^5 + s*t^11,
    g_2 = s^8*t^4 - 2*s^2*t^10,
    g_3 = s^3*t^9,
    g_4 = s^12,
    g_5 = t^12.

The linearized map is

    S_3^6 -> S_15,       (h_i) |-> sum g_i*h_i.

Order the basis of `S_15` by increasing `t`-exponent, and denote by `(i,j)`
the column `g_i*s^(3-j)*t^j`.  The 16 columns

    (0,0..3), (1,0..3), (2,0..1), (3,1), (4,0..3), (5,3)

have determinant `-3`.  Thus the incidence projection is submersive at this
pair in characteristic zero, hence dominant.  Its general fiber is nonempty
of projective-map dimension 7, and quotienting by `PGL_2` gives dimension 4.
The exact determinant check is reproduced by `verify_resolution.py`.

## Consequence for the proposed saturations

After common-factor saturation, every surviving irreducible component has a
basepoint-free generic point.  In degrees two and three, a basepoint-free
nonbirational map is necessarily a cover of a line.  Saturating by the
rank-at-most-two ideal therefore takes the closure of the birational locus,
and every surviving component is generically in one of the rank strata
analyzed above.  The saturated top dimensions are consequently the target
dimensions in the table; boundary points may of course remain in the
closures.

## A necessary correction to the finite-field certificate

The fiberwise-saturation certificate in `SPEC.md` is not valid as stated.
Saturation need not commute with specialization.  If `I` is the universal
incidence ideal and `J` is the boundary ideal, only the following inclusion
of ideals

    (I:J^infinity)_b  subseteq  I_b:J_b^infinity

holds in general.  Fiberwise saturation can therefore delete a horizontal
component that specializes entirely into the boundary.

The elementary projective example is

    I=(x-t*y),   J=(x)     in P^1_[x:y] x A^1_t.

Globally `I:J^infinity=I`, but at `t=0`

    I_0:J_0^infinity = (x):(x)^infinity = (1).

The point `[t:1]`, outside `V(J)` generically, specializes to `[0:1]` and
disappears from the fiberwise saturation.  Hence one or two finite-field
runs, or even one rational run, do not prove the generic characteristic-zero
claim merely by saturating after specializing.

For future rows, a rigorous computational certificate must instead do one
of the following:

1. form the universal relative saturation and compute a fiber of that proper
   closure;
2. certify that saturation commutes with base change at the chosen witness
   (for example via a suitable flatness/Groebner certificate); or
3. replace saturation by a proper incidence stratification with constant
   restriction rank, as in the degree-two and degree-three arguments above.

Two related cautions are also material:

* A covers locus having larger dimension does not, by dimension alone, prove
  that it is an irreducible component; a local deformation argument is
  needed.  Coskun--Starr supply it in the `d=n` cases.
* A dimension computation cannot prove that there are exactly two
  components.  Again, the exact two-component statement for the listed
  index-two rows comes from Coskun--Starr.
