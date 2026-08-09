# Degree-25 boundary extension theorem — exact decision

Let \(G=\operatorname{PSL}_2(\mathbf F_{11})\), let \(W\) be the five-dimensional
Klein representation, and let \(X=V(F)\subset\mathbf P(W)\) be the Klein cubic.
For an involution \(t\), write

\[
W=E_+(t)\oplus E_-(t),\qquad
X^t=E_t\sqcup L_t,
\]

where \(E_t=X\cap\mathbf P(E_+(t))\) is a smooth plane cubic and
\(L_t=\mathbf P(E_-(t))\).

Let \(D\) be the reduced union of all 55 curves \(E_t\) and all 55 curves
\(L_t\).

## Theorem

### 1. Canonical boundary morphism

There is a canonical \(G\)-equivariant morphism

\[
\lambda_D:D\longrightarrow X
\]

whose restrictions are

\[
\lambda_D|_{E_t}=[-5],\qquad
\lambda_D|_{L_t}=\operatorname{id}.
\]

Here \([-5]\) is independent of every permitted marked-origin choice.

### 2. Elliptic polarization

For the actual plane-cubic embedding,

\[
[-5]^*\mathcal O_{E_t}(1)\simeq \mathcal O_{E_t}(25).
\]

### 3. No homogeneous morphism representative on the complete network

There is no homogeneous polynomial tuple of any single degree \(d\) whose
projectivization is regular on all of \(D\) and equals \(\lambda_D\).

Indeed, regularity on \(E_t\) gives

\[
\mathcal O_{E_t}(d)\simeq[-5]^*\mathcal O_{E_t}(1)
 \simeq\mathcal O_{E_t}(25),
\]

so \(d=25\). Regularity on \(L_t\), where the map is the identity, gives

\[
\mathcal O_{L_t}(d)\simeq\mathcal O_{L_t}(1),
\]

so \(d=1\), a contradiction.

### 4. No landing-covariant representative, even rationally on the components

Let \(p:W\to W\) be any nonzero homogeneous \(G\)-covariant satisfying
\(F(p)=0\). Then

\[
p|_{E_+(t)}=0
\]

for every involution \(t\). Consequently \([p]\) is undefined at the generic
point of every \(E_t\), and it cannot restrict, after any permitted
representative change, to the nonconstant morphism \([-5]:E_t\to E_t\).

Therefore the proposed Degree-25 Boundary Extension Theorem is false.

```text
DEGREE25-BOUNDARY-EXTENSION-OBSTRUCTED
```

## Proof of the landing obstruction

Assume \(p|_{E_+(t)}\) is not the zero tuple. For \(v\in E_+(t)\),

\[
p(v)=p(tv)=t\,p(v),
\]

so \(p(v)\in E_+(t)\). Since \(F(p)=0\), projectivization gives a rational map

\[
\mathbf P(E_+(t))\dashrightarrow
X\cap\mathbf P(E_+(t))=E_t.
\]

A rational map from \(\mathbf P^2\) to a smooth genus-one curve is constant:
resolve indeterminacy by blowups of \(\mathbf P^2\); a nonconstant morphism to
\(E_t\) would pull a nonzero regular one-form on \(E_t\) back to a nonzero
regular one-form on a rational surface, which is impossible.

The constant is forced to be fixed by \(C_G(t)\). But the residual order-three
subgroup acts on \(E_t\) as translation by a nonzero \(q_t\in E_t[3]\), hence
has no fixed point. This contradiction proves \(p|_{E_+(t)}=0\).

This argument is independent of degree and does not assume primitivity.

## Why scalar changes cannot bypass the obstruction

Multiplication by an invariant scalar preserves zero restriction to
\(E_+(t)\).  Suppose conversely that \(p=hq\) and \(h\) is the invariant
coordinate gcd supplied by primitive reduction.  Since
\(F(p)=h^3F(q)=0\) in an integral domain, \(q\) is itself a landing covariant;
the plus-plane theorem applied anew to \(q\) gives \(q|_{E_+(t)}=0\).  Thus a
gcd can vanish on the plus-plane, but dividing it still cannot uncover a
nonzero elliptic value.  After primitive reduction, two polynomial
representatives of the same equivariant projective map differ only by a
constant.  The remaining base component has codimension two and is not a
removable common hypersurface factor.

Nor can the rational map secretly extend across the generic point of \(Z_t\)
with the required elliptic value. Such an extension would send the irreducible
\(Z_t\simeq\mathbf P^2\) into one connected component of \(X^t\). Because its
restriction to \(E_t\) is required to be \([-5]\), that component would be
\(E_t\), producing the forbidden nonconstant map
\(\mathbf P^2\dashrightarrow E_t\).

Blowing up \(Z_t=\mathbf P(E_+(t))\) does produce a first nonzero normal map, but
for the necessarily odd normal order that map lands in the target line
\(L_t\). It is a map on the exceptional normal-direction bundle, not a value
map on \(E_t\). Thus it cannot recover \([-5]\) on \(E_t\).

## Scope

This theorem rules out the specific marked-elliptic boundary construction.
It does not rule out landing covariants that are undefined on the involution
elliptics, and therefore does not settle \(G\)-unirationality of the Klein
cubic.
