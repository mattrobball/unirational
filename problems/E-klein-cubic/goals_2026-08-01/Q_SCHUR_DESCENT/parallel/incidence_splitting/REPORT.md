# Incidence splitting-field audit

## Verdict

`Q-UNDECIDED`.  The eight twisted cubics through three general points do not
become split merely because the three marked points are split.  In particular,
the cubic resolvent closure does not automatically control the incidence
splitting field.

## Generic non-splitting

Let `H=H_{3,0}(X)` be the smooth twisted-cubic locus on a smooth complex
cubic threefold.  Harris--Roth--Starr prove that `H` is smooth and irreducible
of dimension six.  Its universal curve `U -> H` has geometrically integral
fibres, so the three-marked incidence space

```text
I = U x_H U x_H U
```

is integral of dimension nine.  Zinger's correctly normalized enumerative
invariant says that the evaluation map `I -> X^3` is generically finite of
degree eight.  Therefore over the function field `C(X^3)` its generic fibre
is `Spec L` for one field extension of degree eight.  It is not eight rational
points, even though the three universal marked points are individually
rational over `C(X^3)`.

This remains decisive after imposing a cubic Galois orbit.  Restrict to an
open `B subset X^3` on which `C3` or `S3` acts freely by permuting the three
points, and put `K_H=C(B)^H`, `M=C(B)`.  Over `K_H` the three points form a
degree-three closed point with Galois closure `M/K_H`.  Base-changing the
eight-sheeted incidence cover to `M` recovers the integral generic cover over
`B`; it does not split.  Thus the Galois action on the eight curves need not
factor through `C3` or `S3`, and their splitting field is not forced into the
cubic closure.

Primary inputs:

- Harris--Roth--Starr, *Curves of small degree on cubic threefolds*,
  <https://arxiv.org/abs/math/0202067>, Theorem 4.4;
- Zinger, *The genus 0 Gromov--Witten invariants of projective complete
  intersections*, <https://msp.org/gt/2014/18-2/gt-v18-n2-p12-s.pdf>, p. 1058.

## Exact conditional gate

If the special Schur incidence were a finite Hilbert scheme of length eight
and all its geometric points split over a cyclic cubic closure, then every
nonfixed support orbit would contribute a multiple of three to its length.
Since `8 mod 3 = 2`, a `K`-rational Hilbert point would follow.  For `S3`, a
fixed-point-free action of size eight exists as orbits of sizes two and six.

The generic non-splitting result shows that the cyclic splitting premise
would have to be a new Schur-specific theorem.  No such theorem is present.

```text
Q_SCHUR_INCIDENCE_SPLITTING_BOUNDARY_EXACT
```
