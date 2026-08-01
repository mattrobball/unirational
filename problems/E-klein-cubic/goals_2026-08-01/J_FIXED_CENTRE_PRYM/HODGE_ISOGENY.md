# Hodge, isogeny, and polarization audit

## 1. Target Hodge structure

For the Klein cubic threefold,

\[
H^{2,1}(X)\simeq W^*,\qquad \dim H^{2,1}(X)=5.
\]

The rational weight-one Hodge structure
\(H^3(X,\mathbf Q)(1)\) defines the principally polarized intermediate
Jacobian \((J(X),\Theta)\).  Roulleau's exact period-lattice calculation
gives, as an unpolarized abelian variety,

\[
J(X)\simeq E_{11}^{5},\qquad
E_{11}=\mathbf C/\mathbf Z\!\left[\frac{-1+\sqrt{-11}}2\right].
\]

Thus \(E_{11}\) has CM by \(\mathbf Q(\sqrt{-11})\).  The isomorphism
with \(E_{11}^5\) is **not** an isomorphism from \((J(X),\Theta)\) to the
product principally polarized abelian variety.  The period lattice and theta
form, not a product polarization, are the natural integral data.

## 2. Subgroup pieces

The exact character screen has fourteen subgroup-class rows.  The invariant
dimensions of \(H^{2,1}(X)\) are:

| subgroup class | invariant dimension | full irreducible multiplicity vector |
|---|---:|---|
| \(C_2\) | 3 | `(3,2)` |
| \(C_3\) | 1 | `(1,2,2)` |
| \(V_4\) | 2 | `(2,1,1,1)` |
| \(C_5\) | 1 | `(1,1,1,1,1)` |
| \(S_3^{(1)}\) | 1 | `(1,0,2)` |
| \(S_3^{(2)}\) | 1 | `(1,0,2)` |
| \(C_6\) | 1 | `(1,0,1,1,1,1)` |
| \(D_{10}\) | 1 | `(1,0,1,1)` |
| \(C_{11}\) | 0 | `(0,1,0,1,1,1,0,0,0,1,0)` |
| \(A_4\) | 0 | `(0,1,1,1)` |
| \(D_{12}\) | 1 | `(1,0,0,0,1,1)` |
| \(11{:}5\) | 0 | `(0,0,0,0,0,0,1)` |
| \(A_5^{(1)}\) | 0 | `(0,0,0,0,1)` |
| \(A_5^{(2)}\) | 0 | `(0,0,0,0,1)` |

For an involution, the \((+/-)\) dimensions are \((3,2)\).  For either
subgroup \(S_3\)-class,

\[
W^*|_{S_3}\simeq\mathbf1\oplus2\,\mathrm{Std};
\]

the sign representation does not occur.

## 3. The fixed elliptics do not supply the target factor

The corrected calculation in `ONE_MOTIVE.md` shows

\[
H^{1,0}(E_t)\simeq\mathrm{sign}
\]

for the residual \(D_{12}/\langle t\rangle\simeq S_3\).  For the actual
setwise stabilizer \(D_{12}\), the exact restriction row is

\[
W^*|_{D_{12}}\simeq \mathbf1\oplus\rho_2\oplus\rho'_2;
\]

all three nontrivial linear characters have multiplicity zero.  In
particular the inflated residual sign character is absent.  Frobenius
reciprocity therefore gives multiplicity zero for the orbit of the 55 fixed
elliptics in the target \(W^*\)-isotypic component.  This corrects the earlier
provisional possibility of a trivial differential character.

There is also an isogeny obstruction for these particular elliptics:

\[
j(E_t)=8192/11
\]

is not an algebraic integer, so \(E_t\) has no CM.  Hence \(E_t\) is not
isogenous to \(E_{11}\), and

\[
\operatorname{Hom}(E_t,E_{11})=0.
\]

In particular \(\operatorname{End}^0(E_t)=\mathbf Q\), whereas
\(\operatorname{End}^0(E_{11})=\mathbf Q(\sqrt{-11})\).

This eliminates the most visible 55-elliptic Hodge channel.  It does **not**
eliminate arbitrary positive-genus centres.

## 4. Hodge stabilization theorem

Let \(S=F(X)\) be the Fano surface of lines of \(X\).  Its Albanese is the
intermediate Jacobian:

\[
\operatorname{Alb}(S)\simeq J(X).
\]

Choose a smooth sufficiently ample curve \(C\subset S\).  Weak Lefschetz
injects \(H^1(S,\mathbf Q)\) into \(H^1(C,\mathbf Q)\); dually,
\(J(C)\twoheadrightarrow J(X)\), and Poincare reducibility makes \(J(X)\)
an isogeny factor of \(J(C)\).

Embed the abstract curve \(C\) generally in \(\mathbf P(W)=\mathbf P^4\).
Because \(G\) is finite and acts faithfully projectively, the embedding can
be chosen so that the 660 translates \(gC\) are pairwise disjoint.  Their
union \(B\) is a smooth disconnected \(G\)-invariant centre with free action
on its connected components.  Blowing up \(B\) adds

\[
H^1(C,\mathbf Q)(-1)\otimes\mathbf Q[G]
\]

to \(H^3\).

Let \(V=H^3(X,\mathbf Q)(1)\), and choose a Hodge embedding
\(i:V\hookrightarrow H^1(C,\mathbf Q)\).  In the regular summand define

\[
\Phi(v)=\sum_{g\in G}i(g^{-1}v)\otimes e_g.
\]

For \(h\in G\), reindexing gives \(h\Phi(v)=\Phi(hv)\).  Thus \(\Phi\)
is a \(G\)-equivariant Hodge embedding.  Semisimplicity makes it split.

No nonidentity subgroup fixes a component of \(B\); because the components
are disjoint, the exceptional locus over \(B\) contributes nothing to
\(Z^H\) for \(H\ne1\).  The Hodge stabilization is therefore invisible to
all nontrivial-subgroup fixed-component one-motives.

## 5. Polarization boundary

Restrict the product Jacobian polarization on the 660 components to
\(\Phi(V)\).  It is the sum of the \(G\)-translates of one positive form.
Hence it is \(G\)-invariant.  Since \(W^*\) is complex irreducible, a
\(G\)-invariant positive Hermitian form on \(W^*\) is unique up to positive
scalar.  The restricted form is therefore a positive rational multiple of
the natural theta form.

This is exactly the polarization strength forced by the current cohomological
splitting.  For a dominant morphism \(f:Z^4\to X^3\), the left inverse is

\[
\beta\longmapsto \frac1n f_*(\eta\cup\beta),
\]

where \(\eta\) is a chosen relatively ample class and \(n\) is its degree
on a generic fibre.  It supplies a rational Hodge splitting, not a primitive
integral decomposition of principally polarized abelian varieties.

Accordingly:

- a rational isogeny factor must not be promoted to polarized Prym equality;
- the exact product principal polarization on \(E_{11}^5\) is not the theta
  polarization of \(J(X)\);
- an integral principal-factor obstruction would require a new theorem
  showing that \(f^*\) preserves a primitive unimodular form.  No such theorem
  follows from the relative-dimension-one setup, and ordinary unirationality
  of cubic threefolds is a sanity check against it.

Any Prym presentation of \(J(X)\) realizes the same rational polarized Hodge
structure.  The stabilization above therefore receives every Prym/isogeny
condition that is legitimately implied by \(f^*\), while making no false
claim of integral Prym equality.

## 6. J2 verdict

The fixed elliptics fail both the character and CM tests, but an admissible
free-orbit curve centre supplies the entire target \(G\)-Hodge structure and
its polarization at the strength actually forced.  Hodge/isogeny refinement
therefore does not close Goal J.
