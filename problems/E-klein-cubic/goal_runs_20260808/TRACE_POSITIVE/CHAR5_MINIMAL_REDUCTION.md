# Minimal-counterexample reductions in characteristic five

**Date:** 2026-08-08  
**Status:** `ALL-DEGREE STRUCTURAL REDUCTION / NO DEGREE CUTOFF`  
**Scope:** the faithful `F55` self-covariants and the Klein landing equation

Let `k` be algebraically closed of characteristic five, let

\[
 R=k[x_0,\ldots,x_4],\qquad \rho e_j=e_{j+1},
\]

and let `f` be a nonzero homogeneous polynomial of `C11`-weight one.  Write

\[
 T_f=(f,\rho f,\ldots,\rho^4f),\qquad
 K(T_f)=\sum_i(\rho^if)^2\rho^{i+1}f.                  \tag{0.1}
\]

The conclusions below use no degree search.

## 1. A minimal nondominant covariant is p-primitive

### Proposition 1.1

If `T_f` is nondominant and `f` has least possible positive degree among all
such weight-one coordinates, then

\[
                         df\ne0.                        \tag{1.1}
\]

The same conclusion holds for a least-degree nonzero solution of
`K(T_f)=0`.

### Proof

Over the perfect field `k`, the equality `df=0` is equivalent to

\[
                              f=h^5                    \tag{1.2}
\]

for a homogeneous polynomial `h`.  Since `f` has weight one, `h` has weight
nine.  A suitable cyclic translate `h'=rho^j h` has weight one.  The tuple
`T_(h')`, followed by coordinatewise Frobenius and a cyclic permutation of
the target coordinates, is `T_f`.  Coordinatewise Frobenius is finite and
surjective, so

\[
                   \dim\overline{T_f(\mathbb A^5)}
                    =\dim\overline{T_{h'}(\mathbb A^5)}. \tag{1.3}
\]

Thus nondominance descends from degree `deg(f)` to `deg(f)/5`.  Moreover,

\[
                         K(T_f)=K(T_h)^5,                \tag{1.4}
\]

and the cyclic reindexing does not change the Klein equation.  Landing also
descends.  Either conclusion contradicts minimality.  QED.

Equivalently, after removing the largest common Frobenius power, any proposed
counterexample may be assumed to contain a monomial whose exponent vector is
not divisible by five.

## 2. A minimal counterexample has no common cyclic factor

### Proposition 2.1

Let

\[
                      q=\gcd(f,\rho f,\ldots,\rho^4f).  \tag{2.1}
\]

Up to a scalar, `q` is invariant under both `C5` and `C11`.  If `f=q u`, then
`u` has weight one and

\[
 \dim\overline{T_f(\mathbb A^5)}
   =\dim\overline{T_u(\mathbb A^5)},\qquad
 K(T_f)=q^3K(T_u).                                     \tag{2.2}
\]

Consequently a least-degree nondominant coordinate, or a least-degree Klein
landing coordinate, satisfies `q=1`.

### Proof

The gcd line is preserved by both group generators.  Hence `rho(q)=c q` for
some scalar `c`.  Since `c^5=1` and characteristic is five, `c=1`.  The
`C11` action also makes `q` a semi-invariant.  Its weight is fixed by the
nontrivial order-five multiplier induced by `rho`, so that weight is zero.
This proves the first assertion and gives

\[
                         \rho^if=q\rho^iu.               \tag{2.3}
\]

On the open set `q!=0`, the projective maps defined by `T_f` and `T_u` are
identical.  The affine image closure of every nonzero homogeneous map of
positive degree is the affine cone over its projective image: scaling the
source realizes every scalar after taking a root in `k`.  The two affine
image dimensions are therefore equal.  The cubic identity in (2.2) follows
directly from (2.3).  QED.

## 3. One Frobenius residue class cannot be minimal

For an exponent vector, call its image in `(Z/5)^5` its Frobenius residue.

### Theorem 3.1

Suppose every monomial of `f` has the same Frobenius residue.  If
`K(T_f)=0`, then there is a nonzero homogeneous polynomial `h` of strictly
smaller degree such that a cyclic translate of `h` has weight one and also
lands on the Klein cubic.

Thus a least-degree Klein landing coordinate has at least two distinct
Frobenius residues in its support.

### Proof

Choose the representative `a in {0,1,2,3,4}^5` of the common residue.  Since
`k` is perfect,

\[
                              f=x^a h^5                 \tag{3.1}
\]

for a homogeneous `h`.  Put

\[
                              b=2a+\rho a.               \tag{3.2}
\]

The five summands in the Klein equation are

\[
 (\rho^if)^2\rho^{i+1}f
   =x^{\rho^ib}\bigl((\rho^ih)^2\rho^{i+1}h\bigr)^5.   \tag{3.3}
\]

The polynomial ring is a free module over its fifth-power subring:

\[
 R=\bigoplus_{r\in\{0,1,2,3,4\}^5}x^rR^5.              \tag{3.4}
\]

The residues of the five terms in (3.3) form the cyclic orbit of `b mod 5`.
Because five is prime, this orbit either has length one or length five.  In
the latter case each of the five nonzero terms lies in a different direct
summand of (3.4), so their sum cannot vanish.  Therefore

\[
                             \rho b=b\pmod5.             \tag{3.5}
\]

The operator `2+rho` is invertible on `(F_5)^5`: writing `rho=1+Delta`, it
is `3+Delta` with `Delta^5=0`.  Applying it to `a-rho(a)`, equation (3.5)
therefore gives `a=rho(a)`.  Since the entries of `a` lie between zero and
four,

\[
                              a=r\mathbf1               \tag{3.6}
\]

for some `r`.  With `Q=x_0x_1x_2x_3x_4`, equations (3.1) and (3.6) give

\[
 f=Q^rh^5,\qquad K(T_f)=Q^{3r}K(T_h)^5.                 \tag{3.7}
\]

Thus `K(T_h)=0`.  Its weight is nine, so a cyclic translate has weight one.
Its degree is strictly smaller than that of `f`.  QED.

This result includes, but is stronger than, the pure-fifth-power reduction:
a common nonzero residue vector is allowed at the start and is forced to be
the invariant diagonal residue.

## 4. Exact finite-difference/Tate boundary

Let `R_(n,0)` be the degree-`n`, `C11`-weight-zero piece, and set

\[
                \Delta=\rho-1,\qquad N=1+\rho+\cdots+\rho^4.
\]

In characteristic five, `N=Delta^4`.  Splitting the monomial basis into its
cyclic orbits gives

\[
 {\ker N\over\operatorname {im}\Delta}
 \simeq
 \begin{cases}
 0,&5\nmid n,\\
 k\,[Q^{n/5}],&5\mid n.
 \end{cases}                                           \tag{4.1}
\]

Here every nonfixed monomial orbit is a regular `k[C5]`-module, on which
`ker Delta^4=im Delta`; `Q^(n/5)` is the only fixed monomial.

For `g=f^2rho(f)` one has `g in R_(3d,0)` and

\[
                             K(T_f)=N(g).                \tag{4.2}
\]

Hence:

- if `5` does not divide `d`, the Tate quotient is zero and landing says
  only that `g` is a cyclic finite difference;
- if `5` divides `d`, the only possible Tate class is the coefficient of
  `Q^(3d/5)` in `g`.

The latter coefficient is not constrained by `N(g)=0`: its contribution to
`N(g)` is `5` times itself, hence identically zero.  It is also not a
Frobenius detector on expressions of the special form `f^2rho(f)`.  For

\[
 u=(2,2,3,1,2),\qquad v=(2,2,1,2,3),\qquad
 f=A x^u+B x^v,                                       \tag{4.3}
\]

both monomials have degree ten and weight one, while

\[
 u+v+\rho u=(6,6,6,6,6).                              \tag{4.4}
\]

Thus the Tate coefficient in `f^2rho(f)` contains the unique nonzero term
`2A^2B`, although `f` is p-primitive.  Multiplying (4.3) by any power of `Q`
gives the same phenomenon in every degree `10+5m`.

This sharply limits the modular finite-difference strategy: outside degrees
divisible by five it produces no class, and in the remaining degrees its one
class is invisible to the trace equation and can be nonzero on p-primitive
special cubics.  Additional multiplicative or support information would be
needed to turn it into an obstruction.

## 5. Why this is not a finite cutoff

Every polynomial has the unique Frobenius-residue expansion

\[
                 f=\sum_{a\in A}x^a h_a^5,
       \qquad A\subset\{0,1,2,3,4\}^5.                 \tag{5.1}
\]

Theorem 3.1 excludes `|A|=1` for a minimal landing solution.  When
`|A|>=2`, inserting (5.1) into (0.1) and using (3.4) gives a finite *coupled*
system of lower-degree cubic equations in the different `h_a`.  In general
these equations are not Klein equations for any single `h_a`, so they do not
close an induction.  The degrees of the `h_a` remain unbounded.

Accordingly, the exact minimal-counterexample normal form now is

```text
df != 0;
gcd(f,rho(f),...,rho^4(f)) = 1;
and, for a minimal Klein landing solution, at least two Frobenius residues.
```

These are genuine all-degree reductions, but they imply neither a bounded
degree nor a bounded ordinary support.  The all-degree dominance question
and `ed_k(F55)` remain undecided.

## 6. Exact two-residue classification

Suppose now that a proposed landing coordinate has exactly two Frobenius
residues `a` and `b`, and put `delta=b-a in (F_5)^5`.  Homogeneity gives

\[
                         \sum_j\delta_j=0.              \tag{6.1}
\]

For one cyclic position, the six terms obtained by expanding
`f_i^2 f_(i+1)` have residues

\[
 c,\ c+\rho\delta,\ c+\delta,\ c+\delta+\rho\delta,
 \ c+2\delta,\ c+2\delta+\rho\delta,
 \qquad c=(2+\rho)a.                                  \tag{6.2}
\]

The other positions are the four cyclic shifts of (6.2).  Every term is
nonzero.  Therefore a residue occurring exactly once makes landing
impossible.

### Lemma 6.1 (complete no-singleton classification)

Assume all thirty occurrences obtained from (6.2) have residue multiplicity
at least two.  After adding a common diagonal vector to `a,b`, one has

\[
 \delta=r(1,1,1,1,1),\qquad
 a=d(0,1,2,3,4),\qquad r\in\mathbf F_5^*,\ d\in\mathbf F_5. \tag{6.3}
\]

Conversely, all twenty pairs in (6.3) have no singleton.  For `d=0` the
nonempty bucket sizes are `5,5,10,10`; for `d!=0` they are
`6,6,6,6,6`.

The classification is an exact finite residue statement, not a polynomial
degree search.  Adding a diagonal vector shifts every residue in (6.2) by
the same diagonal vector, so normalize `a_0=0`.  There are then exactly
`5^4=625` choices for `a` and, by (6.1), `5^4-1=624` choices for nonzero
`delta`.  The dependency-free verifier `verify_char5_two_residue.py`
evaluates (6.2), its five shifts, and the bucket multiplicities for these
exactly `390000` pairs.  Its asserted survivor set is the right side of
(6.3); no heuristic or coefficient sampling is used.

The bucket sizes in the surviving cases are also transparent analytically.
Write `v=(0,1,2,3,4)`.  With the shift convention used here,

\[
                  \rho v=v-\mathbf1\pmod5.             \tag{6.4}
\]

If `a=dv` and `delta=r 1`, a term containing `j=0,1,2,3` copies of the
second residue has residue

\[
                         c+(jr-3id)\mathbf1             \tag{6.5}
\]

at cyclic position `i`; the numbers of term types for the four values of
`j` are `1,2,2,1`.  Formula (6.5) gives `5,10,10,5` when `d=0`.  If `d!=0`,
varying `i` permutes all five diagonal offsets for each of the six term
types, giving five buckets of size six.

### Proposition 6.2 (the invariant-residue survivors descend)

The four cases of Lemma 6.1 with `d=0` cannot occur in a least-degree
landing coordinate.

### Proof

After removing a common invariant power of
`Q=x_0x_1x_2x_3x_4` and absorbing fifth-power monomial carries, write

\[
                          f=h^5+Q^r k^5,
                   \qquad r\in\{1,2,3,4\}.             \tag{6.6}
\]

Put `h_i=rho^i h` and `k_i=rho^i k`.  Direct expansion and the freshman's
dream give

\[
\begin{split}
K(T_f)={}&K(T_h)^5\\
 &+Q^r\left(\sum_i(h_i^2k_{i+1}+2h_ik_ih_{i+1})\right)^5\\
 &+Q^{2r}\left(\sum_i(2h_ik_ik_{i+1}+k_i^2h_{i+1})\right)^5\\
 &+Q^{3r}K(T_k)^5.                                    \tag{6.7}
\end{split}
\]

The four displayed summands belong to the four distinct Frobenius residue
components `0,r 1,2r 1,3r 1` of (3.4).  If (6.7) vanishes, each summand
vanishes; in particular

\[
                            K(T_h)=K(T_k)=0.             \tag{6.8}
\]

Both nonzero components in (6.6) have weight one, so `h` and `k` have
weight nine and suitable cyclic translates have weight one.  Equation
(6.8) therefore supplies a lower-degree landing coordinate, contrary to
minimality.  QED.

### The exact remaining two-residue escape

It follows that a least-degree landing coordinate with two Frobenius
residues, if one exists, is forced into one of the sixteen cases

\[
 \delta=r\mathbf1,\qquad
 a=d(0,1,2,3,4),\qquad r,d\in\mathbf F_5^*.             \tag{6.9}
\]

This is a genuine stopping point for residue separation.  If
`m=x^{d(0,1,2,3,4)}`, then

\[
                         {\rho m\over m}
                         =\left({x_0^5\over Q}\right)^d. \tag{6.10}
\]

Thus adjoining a fifth root of the invariant `Q` makes the five cyclic
monomial prefactors differ by fifth powers.  Correspondingly, the pure and
cross terms merge into the five six-term buckets in Lemma 6.1; the four
copy-number components in (6.7) no longer separate.  A coefficientwise
Frobenius root after the substitution `x_j=y_j^5` preserves the original
ordinary degree, so it gives no minimal-degree descent.

No cancellation of those five six-term coefficient equations is proved or
refuted here.  Hence Lemma 6.1 and Proposition 6.2 do **not** exclude all
two-residue landing coordinates.  They reduce that question exactly to the
sixteen nonzero arithmetic-progression residue families (6.9).
