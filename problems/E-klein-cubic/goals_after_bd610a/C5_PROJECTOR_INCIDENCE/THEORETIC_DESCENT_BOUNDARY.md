# Theoretic odd-degree descent boundary

This note records one unconditional strengthening of the current C5 packet and
its exact limit.  It does not decide the five-form incidence.

## Installed setting

Let

```text
K = K_proj,
A = M_3(D),
H subset Herm_3(D),  dim_K(H)=5,
```

where `K` has characteristic zero, `D/K` is the installed quaternion division
algebra, and `H` is the descended Klein five-plane.  For `h in H`, put

```text
Q_h(q) = h(q,q),  q in D^3.
```

Because the involution on `D` is canonical symplectic,
`Sym(D,bar)=K`; hence `Q_h` is an ordinary homogeneous quadratic form on the
underlying 12-dimensional `K`-vector space of `D^3`.

The accepted `A_4`-fixed point has orbit degree
`[PSL_2(F_11):A_4]=55`.  After twisting, it gives a finite etale degree-55
scheme mapping to `F_{14,T}`.  Therefore some residue field `E/K` has odd
degree.  Such an extension cannot split `D`: restriction followed by
corestriction multiplies the 2-torsion Brauer class `[D]` by the odd integer
`[E:K]`.  Thus `D_E` remains division, and the Morita dictionary gives a
nonzero `q_E in D_E^3` such that

```text
(h_E)(q_E,q_E)=0  for every h in H.
```

Only the oddness of `[E:K]` is used below.

## Pairwise common-line theorem

**Theorem.**  For every `h_0,h_1 in H`, there is a nonzero `q in D^3` with

```text
h_0(q,q)=h_1(q,q)=0.
```

Equivalently, every pencil in the Klein five-plane has a common isotropic
right `D`-line over `K`.

**Proof.**  Set `f=Q_(h_0)` and `g=Q_(h_1)`.  The vector `q_E` above makes
the 12-variable quadratic form

```text
f + t*g
```

isotropic over `E(t)`.  The extension `E(t)/K(t)` has the same odd degree as
`E/K`.  Springer's odd-degree theorem therefore makes `f+t*g` isotropic over
`K(t)`.  The Amer--Brumer theorem, applicable because `char(K)!=2` and there
are 12 (in particular at least three) variables, now gives a nontrivial
common zero of `f` and `g` over `K`.

The resulting nonzero vector `q in D^3` generates a genuine right line `qD`:
`D` is division, so any nonzero coordinate of `q` is invertible.  This line
is isotropic for both `h_0` and `h_1`.  This proves the claim.  (If both forms
are zero, the conclusion is immediate.)

The theorem is uniform in the chosen pair.  It does **not** assert that the
lines obtained for different pencils agree.

## Why this stops at two forms

The Amer--Brumer theorem is specifically a two-form rational-point theorem.
Colliot-Thelene--Levine, Theorem 5.1, treats an arbitrary system by replacing
points with zero-cycles of degree one (equivalently, reduced index one), under
the stated variables-versus-forms hypothesis; that hypothesis is satisfied
here (`12>=5+1`).  It does not recover a simultaneous rational point.

Indeed, in this specific packet the same `q_E` makes the generic five-form
combination isotropic over `E(t_1,...,t_4)`, and Springer descends that
isotropy to `K(t_1,...,t_4)`.  What fails is precisely the reverse inference
from this generic-quadric point to a simultaneous `K`-zero of all five forms.

Their Remark 1 records examples due to Pfister, Cassels, and Coray of
intersections of three quadrics, over fields of characteristic different from
two, which have a zero-cycle of degree one but no rational point.  Such an
example even has a rational point on every two-quadric subsystem: push its
degree-one zero-cycle to that subsystem, use Theorem 3.1 for the generic
pencil, then Springer and Amer--Brumer.  Thus pairwise common solubility does
not imply triple common solubility.  Repeating two of the three forms (or
adjoining two zero forms) gives the same common-zero locus as a five-form
system, so a general five-form point extension fails as well.

Consequently neither of the following is valid:

```text
isotropy of one generic linear combination
    => a common zero of three or five forms;

a common K-line for every pair
    => a common K-line for all five forms.
```

This is a theorem boundary, not a negative result for the special Klein
five-plane.  The pairwise theorem proves that no chosen one- or two-member
subsystem can certify emptiness, but the common zero of all five forms, and
hence the `K_proj`-point of `F_{14,T}`, remains undecided.

## References and theorem labels

1. M. Amer, *Quadratische Formen uber Funktionenkorper*, dissertation,
   Johannes Gutenberg-Universitat Mainz, 1976; and A. Brumer, *Remarques sur
   les couples de formes quadratiques*, C. R. Acad. Sci. Paris Ser. A-B 286
   (1978), no. 16, A679--A681.  A modern numbered reference for the
   Amer--Brumer theorem is R. Elman, N. Karpenko, A. Merkurjev, *The Algebraic
   and Geometric Theory of Quadratic Forms*, AMS Colloquium Publications 56
   (2008), Part III, Proposition 17.14.
2. T. A. Springer, *Sur les formes quadratiques d'indice zero*, C. R. Acad.
   Sci. Paris 234 (1952), 1517--1519.  See also T. Y. Lam, *Introduction to
   Quadratic Forms over Fields*, Graduate Studies in Mathematics 67, AMS
   (2005), Chapter VII, Theorem 2.7.
3. J.-L. Colliot-Thelene and M. Levine, *Une version du theoreme d'Amer et
   Brumer pour les zero-cycles*, in *Quadratic Forms, Linear Algebraic Groups,
   and Cohomology*, Developments in Mathematics 18, Springer (2010),
   215--223, DOI `10.1007/978-1-4419-6211-9_12`: Introduction (the
   Amer--Brumer point theorem), Theorem 3.1 (two-form reduced-index theorem),
   Theorem 5.1 (multi-form zero-cycle theorem), and Remark 1 (failure for
   points from three forms onward).
4. J. W. S. Cassels, *On a problem of Pfister about systems of quadratic
   forms*, Arch. Math. (Basel) 33 (1979/80), 29--32; D. F. Coray, *On a
   problem of Pfister about intersections of three quadrics*, Arch. Math.
   (Basel) 34 (1980), no. 5, 403--411; A. Pfister, *Systems of quadratic
   forms*, Bull. Soc. Math. France, Memoire 59 (1979), 115--123.
