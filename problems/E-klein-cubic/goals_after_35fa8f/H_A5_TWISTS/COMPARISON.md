# Comparison of the two maximal `A5` classes

The authoritative representatives are

| class | generators in `PSL_2(F_11)` | canonical cubic parameter |
|---|---|---|
| `A5_class_1` | `[0,1,10,0]`, `[0,2,5,1]` | \(t_1=(4+\sqrt{-11})/9\) |
| `A5_class_2` | `[0,1,10,0]`, `[0,2,5,10]` | \(t_2=(4-\sqrt{-11})/9\) |

Their inner-conjugacy orbits in `PSL_2(F_11)` are disjoint and each has
size 11.  Conjugation by a determinant-nonsquare element of
`PGL_2(F_11)` exchanges the two orbits.  On the exact Klein representation,
the corresponding outer action is realized by a cyclotomic coefficient
automorphism and sends \(\sqrt{-11}\) to \(-\sqrt{-11}\).  Thus the two
models are outer/Galois conjugate, but they are not identified as subgroups
of the installed inner group.

In the six-letter augmentation model, let

\[
S=\sum_{i=0}^5X_i^3,
\qquad
D=\sum_{I\in O_+}X_I-\sum_{I\in O_-}X_I,
\qquad \sum_iX_i=0.
\]

The restricted Klein cubics are exactly scalar multiples of
\(S+t_iD\).  The degree-11 point calculation uses the basis
\(C_0=-O_+\), \(C_1=-O_-\), in which the same two members are

\[
C_0+\lambda_1C_1,
\quad \lambda_1=\frac{13-\sqrt{-11}}{18},
\qquad
C_0+\lambda_2C_1,
\quad \lambda_2=\frac{13+\sqrt{-11}}{18}.
\]

The parameters satisfy `9*T^2-8*T+3` and `9*L^2-13*L+5`, respectively.
Although conjugation predicts parallel behavior, the final point payloads
contain two separately generated exact ideals, Gröbner bases, lexicographic
coordinate certificates, and transcripts.

