# H6A / H6.0 — projective degree-11 torus isogeny

**Exit marker:** `H6-PROJECTIVE-11-ISOGENY-PASS`  
**Headline:** OPEN (structural only)  
**H4 input:** `H-11_5-NORM-MODEL-PASS` (sealed `field_model.json` / `norm_model.json`)

## Group-ring identity

In \(\mathbf Z[C_5]=\mathbf Z[\sigma]/(\sigma^5-1)\),

\[
(2+\sigma)\,(5-3\sigma+\sigma^2-\sigma^3)
=11-(1+\sigma+\sigma^2+\sigma^3+\sigma^4).
\]

## Projective torus

H4 model: \(E=\mathbf C(r_i)/(\prod r_i-1)\), \(\sigma(r_i)=r_{i+1}\),
\(K=E^{\langle\sigma\rangle}=\mathbf C(U_1,\ldots,U_4)\).

Character lattice \(L=\{m\in\mathbf Z^5:\sum m_i=0\}\).  The map
\(\psi(r)_i=r_i^2 r_{i-1}\) acts on characters by \(A=2I+\sigma\).  Dual:
\(B=5I-3\sigma+\sigma^2-\sigma^3\).  On \(L\), \(AB=BA=[11]\).

## Degree 11 and scalar split

\(\det(A|_L)=\pm11\).  On \(\mathbf Z^5\), \(\det A=33=3\cdot11\) (scalar factor 3
separated from projective degree 11).

## Kernel group scheme and Galois action

The isogeny \(\varphi\) of the projective/norm-one torus is finite etale of
degree 11.  Equivalently, \(\mathrm{coker}(A:L\to L)\cong\mathbf Z/11\mathbf Z\).

- **Coker generator:** class of \(e_0=(1,0,0,0)\) in the augmentation chart;
  order 11.
- **\(C_5\)-action:** \(\sigma[e_0]=9[e_0]\) in the coker, and
  \(9\in(\mathbf Z/11\mathbf Z)^\times\) has order 5.
- **Geometric kernel:** over an algebraic closure, with primitive 11th root
  \(\zeta\), the point \(a_i=\zeta^{c_i}\) for
  \(c=(5,3,4,9,1)\) (sum \(0\bmod 11\), \(Ac=0\bmod 11\)) lies in
  \(\ker\psi\) on the product-one torus and generates the \(\mu_{11}\) kernel.
- **Galois on kernel:** \((\sigma\cdot a)_i=a_{i-1}\) multiplies the
  \(\mu_{11}\) coordinate by \(\zeta\mapsto\zeta^9\) (same unit as the coker
  action).
- **Resolvent:** \(X^{11}-1=0\) for the \(\mu_{11}\) coordinate; \(C_5\) acts by
  \(X\mapsto X^9\).  (Trace-hyperplane torsor resolvent is H6.1, not H6.0.)

Modular witnesses at \(p=23,67\) rebuild \(a_i=\zeta^{c_i}\) and check
\(\psi(a)=1\).

## H4 field binding

Verifier loads sealed `field_model.json` and `norm_model.json` (not STATUS
alone): cyclic \(r_i\), product relation, \(\sigma\)-action, det-11 invariant
lattice, coefficient \(c=r_2^{-1}\) with \(N(c)=1\), and order-11 isogeny class
data.  Multiplicative \(\psi\) samples on product-one vectors over good primes
are rebuilt independently.

## Inverse up to \([11]\)

\(B\) is a two-sided inverse of \(A\) up to \([11]\) on \(L\); checked on stored
and random augmentation vectors.

## Out of scope

H6.1 torsor over the trace hyperplane, constructive lanes, valuation
obstruction, and headline point/pointless exits.
