# Characteristic-five normal-fan and Tate addendum

**Date:** 2026-08-08  
**Status:** `ARBITRARY-SUPPORT INITIAL-TERM STRATEGY REFUTED / TWO ALL-DEGREE SUBCASES PROVED`  
**Scope:** homogeneous polynomial self-covariants of the faithful five-space

This addendum gives three exact analytic results.

1. A proposed arbitrary-support degeneration lemma is false already in
   degree four: there is a three-point weight-one support for which every
   coherent tuple of five initial monomials has singular exponent matrix.
2. The desired full-rank initial tuple does exist in every degree when the
   Newton polytope is a segment, or is a translate of a cyclically invariant
   polytope in the precise sense of Theorems 2.1 and 3.1.
3. The characteristic-five trace equation says that one cubic expression is
   a cyclic coboundary, up to one explicit Tate line.  It does not force
   Frobenius descent.

The first result refutes only this sufficient initial-term strategy.  It does
**not** show that the corresponding covariant is nondominant.  Indeed, the
degree-four theorem in `CHAR5_ED_AUDIT.md` shows that every nonzero covariant
on the counterexample support is dominant.

## 1. A degree-four counterexample to the arbitrary-support lemma

Use indices modulo five, put

\[
 W=(1,9,4,3,5),\qquad \rho e_j=e_{j+1},
\]

and consider

\[
 \begin{split}
 P&=(0,0,0,4,0),\\
 Q&=(2,0,0,0,2),\\
 R&=(3,1,0,0,0).
 \end{split}                                      \tag{1.1}
\]

All three vectors have total degree four, and

\[
                 W\mathbin\cdot P=W\mathbin\cdot Q
                  =W\mathbin\cdot R=12\equiv1\pmod {11}. \tag{1.2}
\]

For a real weight vector `w`, let `P_i=rho^i P`, and similarly for `Q_i`
and `R_i`.  Their scores are

\[
 p_i=4w_{i+3},\qquad q_i=2w_i+2w_{i-1},\qquad
 r_i=3w_i+w_{i+1}.                                  \tag{1.3}
\]

Set

\[
 y_i=q_i-p_i=2w_i+2w_{i-1}-4w_{i-2}.
\]

Then

\[
             \sum_i y_i=0,\qquad r_i-q_i={y_{i+1}\over2}. \tag{1.4}
\]

Avoid the finitely many tie hyperplanes.  The winner at position `i` is
therefore determined by the signs of `(y_i,y_(i+1))`:

\[
 --\longmapsto P,\qquad ++\longmapsto R,\qquad
 +-\longmapsto Q,                                    \tag{1.5}
\]

while at a `-+` transition it is `P` or `R` according as

\[
                    2y_i+y_{i+1}<0\quad\hbox{or}\quad>0. \tag{1.6}
\]

Both signs occur by (1.4).  The six nonconstant cyclic sign necklaces give
the following complete table, where winner words are also taken up to cyclic
rotation:

| sign necklace | possible winner necklaces |
|---|---|
| `+----` | `PPPPQ`, `PPPRQ` |
| `++---` | `PPPRQ`, `PPRRQ` |
| `+-+--` | `PPQPQ`, `PQPRQ`, `PPQRQ`, `PRQRQ` |
| `+++--` | `PPRRQ`, `PRRRQ` |
| `++-+-` | `PQPRQ`, `PQRRQ`, `PRQRQ` |
| `++++-` | `PRRRQ` |

There are only two apparent omissions from the choices in (1.6).  For the
pattern `++-+-`, choosing `R` at both `-+` transitions would give

\[
 y_3>-2y_2,\qquad y_0>-2y_4,
\]

and hence `y_0+y_3>-2(y_2+y_4)`, contrary to
`y_0+y_1+y_3=-(y_2+y_4)`.  For `++++-`, the omitted choice would give
`y_0>-2y_4`, while the zero-sum relation gives `y_0<-y_4`.

Thus every chamber has, up to rotation, one of precisely nine winner words:

\[
\begin{gathered}
 PPPPQ,\ PPPRQ,\ PPQPQ,\ PPQRQ,\ PPRRQ,\\
 PQPRQ,\ PQRRQ,\ PRQRQ,\ PRRRQ.                       \tag{1.7}
\end{gathered}
\]

Form the matrix whose row `i` is `P_i`, `Q_i`, or `R_i` according to the
letter in position `i`.  For the words in (1.7), respective nonzero right
kernels are

\[
 e_2,\ e_1,\ e_0,\ e_0,\ e_0,\ e_2,\ e_1-e_0,\ e_0,\ e_0. \tag{1.8}
\]

Most matrices simply have a zero column; for `PQRRQ`, columns zero and one
coincide.  A cyclic rotation of a word permutes rows and columns, so it
preserves rank.  Consequently no generic `w` selects five exponent rows of
full rational rank from the five shifted copies of the support (1.1).

This is the promised counterexample to the arbitrary-support normal-fan
claim.  Singularity of every monomial initial tuple is not a converse to the
usual initial-term dominance criterion.

## 2. The segment theorem

### Theorem 2.1

Let `S` be a finite set of nonnegative exponent vectors of the same positive
degree and the same nonzero `C11`-weight.  If `conv(S)` is a segment, then
there is a generic weight vector for which the five selected cyclic initial
monomials have a full-rank exponent matrix.  Hence every polynomial
covariant with support `S` is dominant, over every field in which the stated
weight decomposition is defined.

### Proof

The point case is the all-degree monomial lemma from `CHAR5_ED_AUDIT.md`.
Otherwise let `a` and `b` be the two endpoints.  Let `A` and `B` be the
circulant matrices with rows `rho^i a` and `rho^i b`.  The monomial lemma
gives

\[
                         \det A\det B\ne0.              \tag{2.1}
\]

Put `D=B-A`.  The nonzero vector `delta=b-a` has coordinate sum zero.  The
circulant matrix `D` has rational rank four: if the polynomial associated to
`delta` vanished at a primitive fifth root, irreducibility of `Phi_5` would
make all coordinates of `delta` equal, and their zero sum would then make
`delta=0`.  Therefore

\[
                 \operatorname {im}(D)=
                 \{(y_i):\sum_i y_i=0\}.                \tag{2.2}
\]

Every nonempty proper subset `I` of the five rows is consequently coherent:
choose a zero-sum vector positive on `I` and negative off `I`, and lift it
through (2.2) to a weight vector.  The initial row is from `B` exactly on
`I`.

It remains to show that some mixed choice is nonsingular.  Suppose otherwise
and put

\[
                              C=BA^{-1}.
\]

If `M_I` is obtained from `A` by replacing the rows in `I` by the
corresponding rows of `B`, expansion along the unchanged identity rows gives

\[
              \det(M_I)=\det(A)\det(C[I,I]).             \tag{2.3}
\]

Thus every nonempty proper principal minor of `C` would vanish.  The
principal-minor formula for the characteristic polynomial would give

\[
                          \det(xI-C)=x^5-\det C.          \tag{2.4}
\]

Both `A` and `B` have row sum equal to the common degree, so `C 1=1`.
Equation (2.4) then gives `det C=1`, and Cayley--Hamilton gives `C^5=I`.

The rational circulant algebra is

\[
             \mathbf Q[C_5]\simeq\mathbf Q\times\mathbf Q(\zeta _5).
\]

A fifth root of unity in its second factor is `zeta_5^j`; the first factor
of `C` is one because `C 1=1`.  Hence `C=rho^j`.  It follows that
`b=rho^j a`.  But cyclic shifting multiplies the nonzero `C11`-weight by
`9^j`, so equality of the weights forces `j=0`; this contradicts `a!=b`.
Some coherent mixed matrix is therefore nonsingular.

Finally, full rational rank makes its five monomials algebraically
independent in every characteristic.  Initial terms of distinct products of
the five coordinate polynomials cannot cancel, so the coordinate
polynomials themselves are algebraically independent.  This proves
dominance.  QED.

## 3. An invariant-translate theorem

### Theorem 3.1

Let `P=conv(S)` be the Newton polytope of a weight-one homogeneous
coordinate polynomial.  Suppose there is an exponent `a in S` and a
polytope `Q` such that

\[
                         P=a+Q,\qquad \rho Q=Q.           \tag{3.1}
\]

Then every polynomial covariant with Newton polytope `P` is dominant.

### Proof

The polytope `Q` lies in the coordinate-sum-zero hyperplane.  For a generic
weight `w`, let `q` be its unique maximizing vertex on `Q`.  Because `Q` is
cyclically invariant, the five maximizing exponent rows are

\[
                         \rho^i a+q.                     \tag{3.2}
\]

Let `A` have rows `rho^i a`.  Its determinant is nonzero by the monomial
lemma.  If the common degree is `d`, then

\[
 A\mathbf1=d\mathbf1,\qquad q^t\mathbf1=0.
\]

The matrix in (3.2) is `A+1 q^t`, so the matrix determinant lemma gives

\[
 \det(A+\mathbf1q^t)
   =\det(A)\bigl(1+q^tA^{-1}\mathbf1\bigr)
   =\det(A)\ne0.                                       \tag{3.3}
\]

The same algebraic-independence argument as in Theorem 2.1 proves dominance
in every characteristic.  QED.

## 4. What the modular trace equation actually implies

Let `k` have characteristic five, let

\[
 R_n=k[x_0,\ldots,x_4]_n,\qquad
 \Delta=\rho-1,\qquad N=1+\rho+\cdots+\rho^4.
\]

Since `rho^5=1`,

\[
                             N=\Delta^4.                 \tag{4.1}
\]

Every monomial orbit in `R_n` has length five except for the single fixed
monomial

\[
                  (x_0x_1x_2x_3x_4)^{n/5},              \tag{4.2}
\]

which exists only when `5` divides `n`.  A length-five orbit spans the
regular `k[C_5]`-module, on which `ker Delta^4=im Delta`.  Orbit by orbit,
this gives the exact decomposition

\[
 \ker(N:R_n\to R_n)=\operatorname {im}\Delta\ \oplus
 \begin{cases}
 k(x_0x_1x_2x_3x_4)^{n/5},&5\mid n,\\
 0,&5\nmid n.
 \end{cases}                                           \tag{4.3}
\]

For a weight-one degree-`d` coordinate `f`, put `g=f^2 rho(f)`.  The Klein
landing equation is exactly

\[
       0=\sum_i(\rho^if)^2\rho^{i+1}f=N(g).              \tag{4.4}
\]

Consequently (4.4) says only

\[
 g=\Delta h
 \quad(5\nmid d),\qquad
 g=\Delta h+c(x_0x_1x_2x_3x_4)^{3d/5}
 \quad(5\mid d).                                       \tag{4.5}
\]

It does not imply that `g`, much less `f`, is a fifth power.  For example,

\[
                     \Delta(x_0^{33})                   \tag{4.6}
\]

has `C11`-weight zero, lies in `ker N`, and has nonzero ordinary derivative.
This example refutes a Frobenius conclusion from trace-zero alone; it is not
asserted to have the special form `f^2 rho(f)`.

Nor is the exceptional Tate summand in (4.5) vacuous for the special cubic
form.  Set

\[
 u=(2,2,3,1,2),\qquad v=(2,2,1,2,3).                    \tag{4.7}
\]

Both have degree ten and weight `45=1 mod 11`, while

\[
                     u+v+\rho u=(6,6,6,6,6).            \tag{4.8}
\]

Thus for `f=a x^u+b x^v`, the coefficient of the fixed monomial
`(x_0x_1x_2x_3x_4)^6` in `f^2 rho(f)` is the nonzero term `2a^2b`; direct
inspection of the other five products shows that none has exponent (4.8).

There is one valid minimality reduction.  If `f=h^5`, then

\[
              K(T_f)=K(T_h)^5.                          \tag{4.9}
\]

The weight of `h` is nine, and a cyclic translate has weight one.  Since the
Klein equation is cyclically invariant, a landing solution `f=h^5` would
give a lower-degree weight-one landing solution.  Hence a landing solution
of minimal degree cannot be a pure fifth power.  Equations (4.3)--(4.8) show
that the modular finite-difference/Tate formalism supplies no stronger
Frobenius descent by itself.

## 5. Strict verdict

The arbitrary-support normal-fan strategy is false.  The segment and
invariant-translate theorems are genuine all-degree dominance results, but
they do not cover arbitrary Newton polytopes.  The Tate decomposition gives
a precise p-primitive minimality observation and an equally precise no-go:
trace zero alone cannot force Frobenius descent.  None of these statements
decides the all-degree dominance theorem or `ed_k(F55)`.

