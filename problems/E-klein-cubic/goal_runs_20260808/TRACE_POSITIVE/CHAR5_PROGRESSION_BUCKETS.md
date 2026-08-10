# The sixteen characteristic-five progression families

**Date:** 2026-08-08  
**Status:** `FIVE BUCKET EQUATIONS EXACT / FROBENIUS DESCENT SELF-SIMILAR`  
**Strict verdict:** the residue equations do not exclude the sixteen
nonzero-progression families and do not lower their degree.

This note continues `CHAR5_MINIMAL_REDUCTION.md`, Section 6.  It derives the
five six-term equations for the only two-Frobenius-residue families not
already excluded there, and identifies the exact obstruction to a
Frobenius or polarization induction.

## 1. Laurent normalization

Work in characteristic five and use

\[
 \rho e_j=e_{j+1},\qquad
 v=(0,1,2,3,4),\qquad Q=x_0x_1x_2x_3x_4.
\]

The remaining residue pairs are

\[
             a=dv,\qquad b-a=r\mathbf1,
             \qquad d,r\in\mathbf F_5^*.               \tag{1.1}
\]

Changing an exponent vector by a multiple of five only changes its
Frobenius root by a Laurent monomial.  Thus, after absorbing all carries, a
coordinate with the two residues (1.1) has the Laurent form

\[
                 f=m\bigl(h^5+Q^rk^5\bigr),
                 \qquad m=x^{dv},                       \tag{1.2}
\]

where `h,k` are nonzero Laurent polynomials.  This is only a normalization:
the original `f` is still assumed to be an ordinary homogeneous polynomial.

Adjoin the unique fifth root `q` of `Q` and extend `rho` by `rho(q)=q`:

\[
                 q^5=Q,qquad z=q^r.                    \tag{1.3}
\]

For `i=0,...,5`, put

\[
 X_i=x_0x_1\cdots x_{i-1},\qquad X_0=1,\quad X_5=Q.
\]

The integral identity

\[
 \rho^iv=v-i\mathbf1+5(e_0+\cdots+e_{i-1})             \tag{1.4}
\]

gives

\[
 {\rho^im\over m}=Q^{-di}X_i^{5d},\qquad
 A_i:=X_i^dq^{-di},\qquad A_i^5={\rho^im\over m}.       \tag{1.5}
\]

Write `h_i=rho^i h`, `k_i=rho^i k`, and

\[
                         G_i=h_i+zk_i.                  \tag{1.6}
\]

Then

\[
 \rho^if=m(A_iG_i)^5
\]

and hence

\[
 K(T_f)=m^3E^5,qquad
 E=\sum_{i=0}^4(A_iG_i)^2(A_{i+1}G_{i+1}).              \tag{1.7}
\]

Thus landing is equivalent to `E=0` in the purely inseparable extension
`Frac(R)(q)`.

## 2. The five explicit six-term equations

Define the four polar pieces

\[
\begin{aligned}
 P_{i,0}&=h_i^2h_{i+1},\\
 P_{i,1}&=h_i^2k_{i+1}+2h_ik_ih_{i+1},\\
 P_{i,2}&=2h_ik_ik_{i+1}+k_i^2h_{i+1},\\
 P_{i,3}&=k_i^2k_{i+1}.
\end{aligned}                                          \tag{2.1}
\]

Thus `(h_i+t k_i)^2(h_(i+1)+t k_(i+1))` is
`sum_(j=0)^3 t^j P_(i,j)`.  From (1.5),

\[
 A_i^2A_{i+1}=C_iq^{-d(3i+1)},
 \qquad C_i=X_i^{3d}x_i^d.                             \tag{2.2}
\]

Consequently

\[
 E=\sum_{i=0}^4\sum_{j=0}^3
       C_iq^{,rj-d(3i+1)}P_{i,j}.                     \tag{2.3}
\]

For each bucket `s in {0,1,2,3,4}` and each `j in {0,1,2,3}`, let

\[
 i_j(s)\equiv {rj-d-s\over3d}\pmod5,
 \qquad 0\leq i_j(s)<5,                               \tag{2.4}
\]

and put

\[
 \ell_j(s)={rj-d(3i_j(s)+1)-s\over5}\in\mathbf Z.     \tag{2.5}
\]

Reducing the powers of `q` in (2.3) modulo five gives the unique basis
expansion

\[
                       E=\sum_{s=0}^4q^sE_s,            \tag{2.6}
\]

where

\[
 \boxed{
 E_s=\sum_{j=0}^3
       Q^{\ell_j(s)}C_{i_j(s)}P_{i_j(s),j}=0,
       \qquad s=0,1,2,3,4.}                            \tag{2.7}
\]

Each equation in (2.7) has exactly six displayed cubic terms: one from
`P_(i,0)`, two from `P_(i,1)`, two from `P_(i,2)`, and one from `P_(i,3)`.
Because `1,q,...,q^4` is a basis over `Frac(R)`, the five equations (2.7)
are jointly equivalent to `E=0`, and therefore to `K(T_f)=0`.

Formula (2.7) is the requested all-degree algebraic system.  Negative values
of `ell_j(s)` merely reflect the Laurent normalization (1.2); multiplying an
equation by a power of `Q` clears them without changing its content.

## 3. Twisted-action interpretation

Put

\[
                    \alpha=A_1=(x_0/q)^d,
                    \qquad \theta(u)=\alpha\rho(u).     \tag{3.1}
\]

The norm of `alpha` is one:

\[
                  \prod_{i=0}^4\rho^i(\alpha)
                   =(Q/q^5)^d=1.                       \tag{3.2}
\]

Moreover `A_(i+1)=alpha rho(A_i)`, so

\[
                         \theta^i(G)=A_iG_i.            \tag{3.3}
\]

In particular `theta^5=1`, and (1.7) becomes the twisted Klein equation

\[
                E=\sum_i(\theta^iG)^2\theta^{i+1}G=0.   \tag{3.4}
\]

Multiplicative Hilbert 90 can untwist `theta` over the rational function
field, but the required coboundary need not be a polynomial or preserve a
smaller degree.  The full Frobenius cover makes the failure of degree descent
completely explicit.

## 4. The Frobenius cover returns the same problem

Substitute

\[
                         x_i=y_i^5,qquad q=Q_y:=\prod_i y_i
                                                               \tag{4.1}
\]

and set

\[
 \beta=y^{dv},\qquad
 g(y)=\beta\bigl(h(y^5)+Q_y^rk(y^5)\bigr).              \tag{4.2}
\]

Then

\[
 f(y_0^5,\ldots,y_4^5)=g(y)^5.                         \tag{4.3}
\]

Also

\[
 {\rho\beta\over\beta}
   =\left({y_0^5\over Q_y}\right)^d
   =\alpha(y^5),                                       \tag{4.4}
\]

so (3.4) is conjugated to the ordinary equation

\[
                         K(T_g)=0.                      \tag{4.5}
\]

Equivalently, directly from (4.3),

\[
 K(T_f)(y_0^5,\ldots,y_4^5)=K(T_g)(y)^5.               \tag{4.6}
\]

This is not a smaller solution.  If `f` has ordinary degree `D`, then the
left side of (4.3) has degree `5D`, so `g` again has degree `D`.  Its two
Frobenius residues are still

\[
                         dv,\qquad dv+r\mathbf1.        \tag{4.7}
\]

Thus the operation returns the same one of the sixteen progression
families, with fifth roots of its coefficients.  Repeating it makes no
progress.

## 5. Why polarization does not split the buckets

The four expressions `P_(i,j)` in (2.1) are the polar coefficients in an
*auxiliary* scalar.  In (2.7), however, the four copy numbers `j` occur at
the four different cyclic positions `i_j(s)` and carry different monomial
coefficients.  Landing is asserted only for the single polynomial `f`; it
does not assert landing after independently scaling its second residue
component.  Therefore one cannot equate the four polar pieces separately.

For `d=0` the positions no longer vary with `j`, and the four copy numbers
occupy distinct Frobenius residues; that is exactly why Proposition 6.2 of
`CHAR5_MINIMAL_REDUCTION.md` descends.  For `d!=0`, equation (2.4) permutes
the positions and merges one contribution of every type into each bucket.

## 6. Exact verdict

The sixteen progression families are governed exactly by the five equations
(2.7).  After adjoining `Q^(1/5)` they form one twisted Klein equation; after
the full Frobenius cover that twist is the ordinary Klein equation for a
polynomial of the same degree and the same residue pattern.  Hence neither
Frobenius descent, Hilbert 90, nor formal polarization excludes these
families.

This is a counterconfiguration to the proposed degree induction, not a
construction of a landing polynomial.  Existence or nonexistence of a
nonzero solution of (2.7) remains open and requires information beyond the
five-bucket residue pattern.

