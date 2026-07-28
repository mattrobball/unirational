# WP-3 certificate: exact low-degree Klein-covariant exclusions

## Verdict and boundary

The complete homogeneous covariant spaces

\[
\operatorname{Cov}_G(V,V)_d,
\qquad d\in\{9,11,15,18,22\},
\]

contain no nonzero map \(p:V\to V\) for which

\[
q_4(p(x,y,z))=h(x,y,z)^2
\]

with \(h\) a \(G\)-invariant polynomial of degree \(2d\).  Consequently,
none of these five spaces produces a homogeneous
\(G\)-equivariant rational lift
\(\mathbf P(V)\dashrightarrow S\).

This is a delimited negative construction result, **not** a resolution of
Problem F.  By itself it does not exclude covariants of other degrees.
The later exhaustiveness theorem in
[WP3_STRUCTURAL_BOUND.md](WP3_STRUCTURAL_BOUND.md) shows that any positive
map can be returned to this homogeneous \(V\)-covariant model, but still
leaves even degrees starting at \(28\).

The same checker also screens every complete covariant space through degree
22 over \(\mathbf F_{11}\).  That screen finds no
\(\mathbf F_{11}\)-rational coefficient vector, but this is only search
guidance: it does not exclude characteristic-zero coefficient vectors defined
over number fields, and it is not used in the exact exclusions.

## Algebraic model

Put

\[
F=x^3y+y^3z+z^3x,
\quad
D=x^5z+xy^5+yz^5-5x^2y^2z^2,
\]

and let \(C\) be the bordered-Hessian invariant of degree 14 in the
normalization printed in the script.  The classical Klein invariant theory
used here is:

- the reflection-extension invariant ring is
  \(\mathbf Q[F,D,C]\), with weights \(4,6,14\);
- the \(G\)-covariant module is free over this ring on generators of degrees
  \(1,8,9,11,16,18\).

The even generators are constructed intrinsically as

\[
\psi=\nabla F\times\nabla D,
\quad
\phi=\nabla F\times\nabla C,
\quad
f=\nabla D\times\nabla C.
\]

The script reconstructs the printed \(g_9,g_{11}\) exactly from divisibility
by

\[
X=\frac1{14}\det J(F,D,C)=\Phi_{21}
\]

and checks the useful syzygy

\[
7X\,\mathrm{id}=7C\psi-3D\phi+2Ff. \tag{1}
\]

The Molien/module statement is the completeness input.  The explicit
identities, every pullback decomposition, and every exclusion below are
checked from scratch over \(\mathbf Z\) or \(\mathbf Q\).  For the classical
generators and covariant degrees, see Noam Elkies, *The Klein Quartic in
Number Theory*, §1.2, and Scott Crass, *Solving the heptic in two dimensions*,
§5.1 (arXiv:math/0601394).

## Exact exclusions

For an invariant of weighted degree \(n\), the checker indexes the monomial
\(F^aD^bC^c\) by \((a,b,c)\).  If a polynomial of weighted degree \(4d\) is
the square of one of weighted degree \(2d\), its support is contained in the
pairwise sums of the degree-\(2d\) exponent set.  A coefficient outside that
sumset must vanish.  The script expands the entire pullback with exact sparse
arithmetic, decomposes it in \(\mathbf Q[F,D,C]\), and reconstructs the whole
polynomial as a check on the decomposition.

### Degree 9

The full space is

\[
p=aF^2\mathrm{id}+b g_9.
\]

The impossible-support coefficient at \((9,0,0)\) is \(a^4\), hence \(a=0\).
For \(p=g_9\), the coefficients at
\((0,6,0),(3,4,0),(6,2,0)\) are respectively
\(768,176,-64\).  A square of
\(A D^3+B F^3D+CFC\) would satisfy
\(176^2=4(768)(-64)\), which it does not.

### Degree 11

The full space is

\[
p=aFD\,\mathrm{id}+b g_{11}.
\]

Two impossible-support coefficients are \(-1792b^4\) and \(44b^4\), so
\(b=0\).  The remaining pullback is \(a^4F^5D^4\), whose leading exponent
has odd \(F\)-coordinate and cannot be a square.

### Degree 15

The full space is

\[
p=aF^2D\,\mathrm{id}+bC\,\mathrm{id}+cDg_9+dFg_{11}.
\]

Impossible-support coefficients \(-1792d^4\) and \(b^3(b+d)\) force
\(d=b=0\).  Then \(p=D(aF^2\mathrm{id}+cg_9)\), and the degree-9 obstruction,
shifted by the evident fourth power \(D^4\), applies.

### Degree 18

The full space is

\[
p=aFD\psi+b f.
\]

The impossible-support coefficient at \((0,5,3)\) is
\(-2919616b^4\), so \(b=0\).  After removing the square factor \((FD)^4\),
the pullback \(F(\psi)\) has coefficient \(32\) at \((3,1,1)\).  An invariant
of degree 16 is a combination only of \(F^4\) and \(FD^2\); its square has
no \(C\)-term.  Thus \(F(\psi)\) is not a square.

### Degree 22

By (1), the full space may be written

\[
p=aC\psi+bF^2D\psi+cD\phi+dFf.
\]

The four impossible-support coefficients are

\[
\begin{aligned}
&(1,14,0): &&-265531392c^3(c+2d),\\
&(0,3,5):  &&-4a(3a+7c)^2(3a+14c),\\
&(1,0,6):  &&-a^3(3a-14d),
\end{aligned}
\]

and, at \((3,1,5)\), twice

\[
\begin{aligned}
16a^4-6a^3b+400a^3c-856a^3d+21a^2bd-3360a^2cd
&+5838a^2d^2\\
&+12348acd^2-6860ad^3-19208cd^3.
\end{aligned}
\]

Their common zero locus has two relevant branches:

1. \(a=c=0\), which after a common factor \(F\) reduces to the excluded
   degree-18 family \(bFD\psi+df\);
2. the single projective direction
   \([a:b:c:d]=[42:232:-18:9]\).

At the isolated direction, the \((22,0,0)\) coefficient vanishes and the
lexicographically leading term is

\[
4129544208384\,F^{19}D^2.
\]

Its exponent vector has an odd coordinate, whereas a leading monomial of a
square has an even exponent vector.  This excludes the last branch.

## Replay

From the problem directory, with Python 3 and SymPy installed:

```text
$ python3 certificates/wp3_covariant_exclusions.py
EXACT generators: g9/g11 divisibility and degree-22 syzygy PASS
EXACT d=9: full 2-dimensional covariant space EXCLUDED
EXACT d=11: full 2-dimensional covariant space EXCLUDED
EXACT d=15: full 4-dimensional covariant space EXCLUDED
EXACT d=18: full 2-dimensional covariant space EXCLUDED
EXACT d=22: full 4-dimensional covariant space EXCLUDED
EXACT_EXCLUSIONS_OK degrees=9,11,15,18,22
HEURISTIC ONLY: the following mod-11 screen is not a characteristic-zero proof
...
MOD11_SCREEN_OK degrees<=22
WP3_COVARIANT_EXCLUSIONS_OK
```

On the 2026-07-28 checkout this takes about 25 seconds.  The exact stage runs
before the line explicitly marked `HEURISTIC ONLY`.

## Generic exact per-degree checker

[`klein_covariant_landing_search.py`](klein_covariant_landing_search.py)
builds the complete odd or even covariant space in any requested degree,
introduces the full invariant square root, and checks every projective
coefficient patch by an exact Gröbner basis.  For example:

    python3 certificates/klein_covariant_landing_search.py even 20

It prints `NO_NONZERO_LANDING_COVARIANT` only when every patch has unit
ideal.  A non-unit patch is conservatively reported as `OPEN`; it is not
called a solution without an explicit point and dominance check.  This is
a reusable search tool, not an all-degree termination proof; the structural
certificate is what uniformly excludes odd degrees and bounds the even
ones.
