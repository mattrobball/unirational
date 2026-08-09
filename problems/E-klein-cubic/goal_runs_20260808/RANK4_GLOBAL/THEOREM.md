# A global contracted-divisor theorem in the full cyclic-rank-four branch

**Date:** 2026-08-08  
**Scope:** arbitrary Laurent support and degree  
**Result:** exact global exclusion of the pairwise-coprime rank-four branch  
**Headline:** the unrestricted `F55` trace question remains open

Let

\[
 R=\mathbf C[M],\qquad M=\mathbf Z^5/\mathbf Z(1,1,1,1,1),
 \qquad T=\operatorname {Spec}R,
\]

and let `sigma` cyclically permute the five coordinates.  Suppose that a
nonzero Laurent trace zero has been replaced, as in
`TRACE_FULL_CYCLIC_REPLACEMENT/THEOREM.md`, by one whose projective trace map
is dominant.  After invariant denominator clearing and removal of the
Laurent gcd, write its five trace summands as

\[
 b_j=QH_j,
 \qquad \sum_{j=0}^4H_j=0,
 \qquad \gcd(H_0,\ldots,H_4)=1.                 \tag{0.1}
\]

The four nontrivial Fourier components are nonzero, and

\[
 h:T\dashrightarrow \mathcal H,qquad
 x\longmapsto[H_0(x):\cdots:H_4(x)],             \tag{0.2}
\]

is dominant onto the trace hyperplane

\[
 \mathcal H=\{y_0+\cdots+y_4=0\}\simeq\mathbf P^3.
\]

The new point is that dominance supplies a global obstruction which is
invisible to every primewise Wronskian or Cartan count.

## Theorem 1 (pairwise-coprime branch is impossible)

Under (0.1)--(0.2), the five Laurent polynomials `H_j` are not pairwise
coprime.  Equivalently, some irreducible Laurent prime divides at least two
of them.

### Proof

Assume that the `H_j` are pairwise coprime.  Fix a Laurent prime `P` dividing
`H_i` to order `s>0`.  Its incidence vector is then the singleton

\[
 (v_P(H_0),\ldots,v_P(H_4))=s e_i.              \tag{1.1}
\]

The exact divisor calculation in
`TRACE_COBOUNDARY/RANK_FOUR_BOUNDARY.md` gives

\[
 \sum_{j=0}^4\mu_jv_P(H_j)=0\pmod {11},
 \qquad \mu=(1,5,3,4,9).                         \tag{1.2}
\]

Every entry of `mu` is invertible modulo eleven, so (1.1)--(1.2) force
`11 | s`.  Unique factorization in the Laurent ring therefore gives

\[
 H_i=u_iY_i^{11},\qquad u_i\in R^*,              \tag{1.3}
\]

for all `i`.

Every Laurent unit has the form `gamma chi^m`.  Pull (1.3) back by the fixed
multiplication-by-eleven isogeny

\[
 [11]:T\longrightarrow T,
 \qquad [11]^*(\chi^m)=\chi^{11m}.               \tag{1.4}
\]

Since `C` contains all eleventh roots, there are Laurent polynomials `Z_i`
such that

\[
 [11]^*H_i=Z_i^{11}.                              \tag{1.5}
\]

Pulling back the trace relation now gives

\[
 Z_0^{11}+Z_1^{11}+Z_2^{11}+Z_3^{11}+Z_4^{11}=0. \tag{1.6}
\]

Thus `Z=[Z_0:\cdots:Z_4]` is a rational map from the rational four-torus to
the Fermat threefold

\[
 F_{11}=\{z_0^{11}+\cdots+z_4^{11}=0\}\subset\mathbf P^4. \tag{1.7}
\]

The coordinatewise eleventh-power map is finite, and

\[
 [Z_0^{11}:\cdots:Z_4^{11}]=h\circ[11].           \tag{1.8}
\]

Both `[11]` and the coordinatewise power map are finite.  Since `h` is
dominant onto a threefold, (1.8) forces `Z` to be dominant onto `F_11`.
Consequently `F_11` would be unirational: one may restrict the rational
four-dimensional source to a general three-dimensional affine linear
section on which the differential still has rank three.

This is impossible in characteristic zero.  The Fermat threefold is smooth,
and adjunction gives

\[
 K_{F_{11}}=\mathcal O_{F_{11}}(11-5)
            =\mathcal O_{F_{11}}(6),              \tag{1.9}
\]

so it has nonzero pluricanonical forms.  A generically finite dominant map
from a rational threefold would pull such a form back nontrivially after
resolution, whereas every smooth projective variety birational to
`P^3` has zero plurigenera.  This contradiction proves the theorem.  QED.

## Corollary 2 (a free orbit contracted to arrangement strata)

Every dominant full-rank trace zero has a Laurent prime `P` which divides
two or three of the `H_j`.  Its `sigma`-orbit has length five.

Indeed, Theorem 1 supplies `P`, while the full-spark Fourier matrix says that
no prime divides four `H_j`.  If `P` were fixed by `sigma` up to a Laurent
unit, the relation

\[
 \sigma(H_j)=L H_{j+1},\qquad L\in R^*,           \tag{2.1}
\]

would make `P` divide all five `H_j`, contrary to (0.1).  Since `sigma` has
prime order five, the orbit is free.

Geometrically, the divisor `D_P` is contracted by (0.2) into a codimension-two
intersection of two of the five distinguished hyperplanes, or into a triple
intersection point.  Its five conjugates are contracted into the
corresponding cyclic orbit of arrangement strata.  Thus shared primes are
not an optional local pathology: a whole cyclic orbit of them is forced by
global dominance.

Combining this with the exact residue table in
`TRACE_COBOUNDARY/RANK_FOUR_BOUNDARY.md`, some free orbit has one of the
following supports and congruences (indices modulo five):

\[
\begin{array}{c|c}
\{i,i+1\}&s_i+5s_{i+1}=0\pmod {11}\\
\{i,i+2\}&s_i+3s_{i+2}=0\pmod {11}\\
\{i,i+1,i+2\}&s_i+5s_{i+1}+3s_{i+2}=0\pmod {11}\\
\{i,i+1,i+3\}&s_i+5s_{i+1}+4s_{i+3}=0\pmod {11}.
\end{array}                                           \tag{2.2}
\]

This is a global necessity, not a point and not a bounded search.

## Exact scope

The theorem proves

```text
dominant full-rank trace zero
  => a free cyclic orbit of pair- or triple-common Fourier primes.
```

It eliminates the pairwise-coprime branch for all Laurent supports and all
degrees.  It does not eliminate the four incidence types in (2.2).  The
formal and semilocal models in `TRACE_COBOUNDARY/RANK_FOUR_BOUNDARY.md` show
that each local residue condition is feasible; the unresolved issue is the
global gluing of one or more forced contracted-divisor orbits.

```text
RANK4-GLOBAL-PAIRWISE-COPRIME-EXCLUSION
RANK4-GLOBAL-CONTRACTED-FREE-PRIME-ORBIT-FORCED
RANK4-SHARED-PRIME-BRANCH-OPEN
F55-GLOBAL-QUESTION-OPEN
```

