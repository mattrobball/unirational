# Intrinsic boundary map

## 1. Marked group law

Fix an involution \(t\). The installed geometry gives

\[
N_G(\langle t\rangle)/\langle t\rangle\simeq S_3
\]

and, after choosing a type-I point as origin,

\[
M_t=E_t[2]+\langle q_t\rangle,\qquad
0\ne q_t\in E_t[3].
\]

The type-I points form \(\langle q_t\rangle\); the nine type-II points are the
three nonzero \(E_t[2]\)-cosets of \(\langle q_t\rangle\). Hence \(M_t\) is a
subgroup and

\[
M_t\subset E_t[6].
\]

The actual ambiguity between two type-I origins lies in
\(\langle q_t\rangle\subset E_t[3]\). Even if one permits any marked point as
origin, the difference lies in \(M_t\subset E_t[6]\).

## 2. Correction to the simultaneous reflection formulas

Choose a type-I origin \(O\). Its stabilizer in the residual \(S_3\) is a
reflection. Since \(j(E_t)=8192/11\), one has
\(\operatorname{Aut}(E_t,O)=\{\pm1\}\), so this reflection is inversion.

With \(\rho(P)=P+q_t\) and \(s(P)=-P\), the three residual reflections are

\[
s_k=\rho^k s,\qquad s_k(P)=kq_t-P,\qquad k=0,1,2.
\]

They are not simultaneously the three maps \(P\mapsto e-P\) for three
different \(e\in E_t[2]\). The product of two such latter maps would be
translation by a nonzero two-torsion point, whereas the product of two
reflections in this \(S_3\) is translation by \(\pm q_t\).

This correction does not alter the marked set. The fixed points of the three
\(s_k\) satisfy \(2P=kq_t\), and their union is precisely

\[
E_t[2]+\langle q_t\rangle=M_t.
\]

## 3. Origin independence of \([-5]\)

Let the old origin be \(O=0\), and let the new origin be \(b\). Multiplication
by \(n\) in the new group law is

\[
[n]_b(P)=[n]_0(P)+(1-n)b.
\]

For \(n=-5\),

\[
[-5]_b(P)=[-5]_0(P)+6b.
\]

Every permitted origin displacement is killed by \(6\). Therefore

\[
[-5]_b=[-5]_0.
\]

This proves intrinsic definition without choosing coordinates.

## 4. Residual \(S_3\)-equivariance

For the order-three translation,

\[
[-5](P+q_t)=[-5]P-5q_t=[-5]P+q_t.
\]

For the three reflections,

\[
[-5](kq_t-P)=-5kq_t+5P
            =kq_t-[-5]P.
\]

The congruence used in both equations is \(-5\equiv1\pmod3\). Thus \([-5]\)
commutes with all of the residual \(S_3\).

Equivalently, every residual affine automorphism has the form
\(P\mapsto\epsilon P+a\), with \(\epsilon=\pm1\) and \(a\in M_t\); since
\([-5]a=a\), it commutes with \([-5]\).

## 5. Pointwise fixation of the marked set

For every \(m\in M_t\subset E_t[6]\),

\[
[-5]m-m=-6m=0.
\]

Hence \([-5]\) fixes all type-I and type-II marked points pointwise.

## 6. Conjugation by \(G\)

For \(g\in G\), the linear action carries

\[
E_t\longrightarrow E_{gtg^{-1}},
\]

and transports the type-I set, type-II set, and residual action. If \(O\) is
an allowed origin on \(E_t\), then \(gO\) is an allowed origin on the conjugate
elliptic, and \(g\) is an isomorphism of the resulting group laws. Therefore

\[
g\circ[-5]_{E_t}
=
[-5]_{E_{gtg^{-1}}}\circ g.
\]

Origin independence removes the choice of \(O\). Thus the collection of
elliptic maps is globally \(G\)-equivariant. The identity maps on the fixed
lines are plainly transported by conjugation as well.
