# Abel--Jacobi descent and low-degree rational curves on the generic Klein twist

## 1. Setup

Let

\[
G=\operatorname{PSL}_2(\mathbf F_{11}),\qquad
X=\{x_0^2x_1+x_1^2x_2+x_2^2x_3+x_3^2x_4+x_4^2x_0=0\}
\subset\mathbf P(W),
\]

and let

\[
E=\mathbf C(\mathbf P(W)),\qquad K=E^G=K_{\rm proj}.
\]

The generic point of the free locus gives the genuine generic torsor
\(T=\operatorname{Spec}E\to\operatorname{Spec}K\).  A superscript \({}^T\)
denotes twisting by this torsor.  Write \(J=J(X)\) for the intermediate
Jacobian and \(J_e\) for the \(J\)-torsor of codimension-two cycle classes of
degree \(e\).

## 2. The structural theorem

### Theorem R.1 -- fixed intermediate Jacobian

\[
J(\mathbf C)^G=0,\qquad {}^T J(K)=\{0\}.
\]

### Theorem R.2 -- every degree torsor has one descended value

For every \(e\in\mathbf Z\), the torsor \(J_e\) has a unique
\(G\)-fixed complex point \(q_e\).  Equivalently,

\[
{}^T J_e(K)=\{q_e\}.
\]

The points are compatible with addition and \(q_{e+3}=q_e+[H^2]\).

### Theorem R.3 -- conics

The threefold \({}^T X\) contains no geometrically integral conic defined
over \(K\).

### Theorem R.4 -- degree three

1. A geometrically integral plane cubic of geometric genus zero defined over
   \(K\) forces \({}^T X(K)\ne\varnothing\): its unique geometric singular
   point is \(K\)-rational.
2. Let \(\overline{\mathcal T}\) be the generalized twisted-cubic Hilbert
   component and \(M_X\to\Theta\) the canonical moduli desingularization of
   the theta divisor.  Then

   \[
   {}^T\overline{\mathcal T}(K)\ne\varnothing
   \quad\Longrightarrow\quad
   {}^T X(K)\ne\varnothing.
   \]

### Theorem R.5 -- elliptic normal quintics

The twist of the elliptic-normal-quintic Hilbert component has no
\(K\)-point.  More precisely, the only possible Abel--Jacobi fibre is the
nonsplit Severi--Brauer fivefold attached to the Schur double cover, and

\[
{}^T\mathbf P(H^0(E_0(1)))
\simeq \operatorname{SB}(A_{\rm proj}^{\rm op}),
\qquad \operatorname{ind}(A_{\rm proj})=2.
\]

### Theorem R.6 -- exact quartic boundary

Every \(K\)-point of the rational-normal-quartic Hilbert locus maps to the
single Abel--Jacobi value \(q_4\).  Neither the fixed-line quartic pencil nor
the generic-cubic identification of a general Abel--Jacobi fibre descends to
a proof for the Klein cubic.  Producing a geometrically rational point of
this distinguished fibre would already prove \({}^T X(K)\ne\varnothing\).

## 3. Proof of Theorem R.1

A \(K\)-point of \({}^T J\) is, by twisting adjunction, a
\(G\)-equivariant rational map \(\mathbf P(W)\dashrightarrow J\).  Every
rational map from projective space to an abelian variety is constant, so

\[
{}^T J(K)=J(\mathbf C)^G.
\]

Roulleau computes the period lattice \(\Lambda=H_1(J,\mathbf Z)\).  Put

\[
\nu^2+\nu+3=0,\qquad \mathcal O=\mathbf Z[\nu],\qquad
\delta=1+2\nu.
\]

In the Fourier vectors \(v_0,\ldots,v_4\), an \(\mathcal O\)-basis is

\[
\frac{v_0-3v_1+3v_2-v_3}{\delta},\quad
\frac{v_1-3v_2+3v_3-v_4}{\delta},\quad
v_0,\quad v_1,\quad v_2.
\]

For the subgroup \(C_{11}\rtimes C_5\), let

\[
\tau(v_k)=v_{k+1},\qquad \sigma(v_k)=v_{5k},\qquad
\sigma\tau\sigma^{-1}=\tau^5.
\]

`produce_fixed_jacobian.py` reconstructs their integral \(10\times10\)
matrices and proves

\[
|\det(\tau-1)|=11,
\]

while the common fixed equations for \(\tau\) and \(\sigma\) have full rank
ten on both the 5-primary and 11-primary parts.  The subgroup norm kills
every fixed point, so these are the only relevant primes.  Hence
\(J^{C_{11}\rtimes C_5}=0\), and therefore \(J^G=0\).

The independent verifier reconstructs the lattice action from the quadratic
order and recomputes the group relations, determinant, and modular ranks; it
does not import the producer.

## 4. Proof of Theorem R.2

The full Weil action is conjugated into the same integral period lattice in
`probe_full_group_h1_mod3.py`.  Over \(\mathbf F_3\), a Cayley enumeration
of all 660 elements treats a derivation as its two generator values.  The
exact ranks are

\[
\dim Z^1(G,J[3])=10,\qquad
\dim B^1(G,J[3])=10,
\]

so

\[
H^1(G,J[3])=0.                                            \tag{4.1}
\]

`verify_group_cohomology.py` independently re-enumerates
\(\operatorname{PSL}_2(\mathbf F_{11})\), reconstructs every consistency
equation, and repeats both rank calculations from the serialized integral
generator matrices.

The Kummer sequence gives

\[
H^1(G,J)[3]=0.                                            \tag{4.2}
\]

The addition law on cycle components gives
\([J_e]=e[J_1]\in H^1(G,J)\).  The invariant algebraic cycle \(H^2\) has
degree three and supplies a \(G\)-fixed point of \(J_3\); hence
\(3[J_1]=0\).  Equation (4.2) forces \([J_1]=0\), and therefore every
\(J_e\) has a fixed point.  Its set of fixed points is a torsor under
\(J^G=0\), proving uniqueness.

A rational map from \(\mathbf P(W)\) to the complex torsor \(J_e\) is again
constant after choosing any complex origin.  Twisting adjunction therefore
identifies its \(K\)-points with \(J_e(\mathbf C)^G=\{q_e\}\).

## 5. Proof of Theorem R.3

Every geometrically integral conic spans a plane, and formation of its span
commutes with base change.  If \(C\subset{}^T X\) is a \(K\)-conic and
\(\Pi=\langle C\rangle\), then on \(\Pi\)

\[
F|_\Pi=q\ell
\]

for a quadratic equation \(q\) of \(C\) and a \(K\)-linear form \(\ell\).
The residual component is a \(K\)-line on \({}^T X\), contradicting the
binding no-line theorem.  This eliminates all integral conics, not just a
chosen family of plane models.

## 6. Proof of Theorem R.4

A geometrically integral plane cubic of geometric genus zero has arithmetic
genus one and total delta invariant one.  Its geometric singular locus is a
single point.  Galois stability of that singleton in characteristic zero
makes it a \(K\)-point of the cubic threefold.

For nonplanar degree-three curves, the generalized twisted-cubic component
maps Aut\((X)\)-equivariantly to a smooth fourfold \(M_X\), and
\(M_X\to\Theta\subset J\) is the blowup of the unique singular point
\(0\in\Theta\).  Its exceptional divisor is canonically \(X\).  After
twisting, any \(K\)-point maps to the only point of \({}^T J(K)\), namely
zero, and thus lies over the exceptional divisor \({}^T X\).  This includes
boundary Hilbert points.  A smooth twisted cubic gives the same conclusion
more directly: its odd-degree hyperplane class forces its genus-zero
normalization to split.

## 7. Proof of Theorem R.5

Beauville's all-smooth-cubic theorem describes the elliptic-normal-quintic
Hilbert locus as an etale-locally trivial \(\mathbf P^5\)-bundle over the
open moduli space of stable rank-two bundles \(E\) with \(c_1=0,c_2=2\):

\[
E\longmapsto \mathbf P(H^0(E(1))),\qquad h^0(E(1))=6.
\]

The Abel--Jacobi map from this moduli space is an open embedding into the
degree-two cycle torsor (equivalently the degree-five torsor after adding
\(H^2\)).

The exact Pfaffian alignment in the repository embeds the Klein module as

\[
B_5\subset\bigwedge^2 V_6^*,
\]

where \(V_6\) is an irreducible representation of the Schur cover
\(\operatorname{SL}_2(\mathbf F_{11})\), with its central involution acting
as \(-1\).  The associated kernel bundle \(\mathcal K\) on \(X\) gives a
\(G\)-invariant stable bundle \(E_0\) satisfying

\[
E_0(1)\simeq\mathcal K^*,\qquad
H^0(E_0(1))\simeq V_6^*.
\]

Its Abel--Jacobi value is fixed, hence equals the unique \(q_2\) of Theorem
R.2.  Since the Abel--Jacobi map on the bundle moduli is an open embedding,
this is the unique bundle over \(q_2\).  Consequently every descended
elliptic-quintic Hilbert point would lie in the twist of
\(\mathbf P(V_6^*)\).

The binding generic Schur-class theorem proves that on the genuine
projective torsor

\[
0\ne\alpha_{\rm proj}\in\operatorname{Br}(K)[2],\qquad
\operatorname{ind}(A_{\rm proj})=2.
\]

Dualization changes \(\alpha_{\rm proj}\) to its negative, which is equal to
it because the class is 2-torsion.  Thus
\({}^T\mathbf P(V_6^*)\) is nonsplit and has no \(K\)-point.  Neither the
smooth elliptic-normal-quintic locus nor any of its points in this
\(\mathbf P^5\)-fibre can descend.

This is a component-scoped emptiness theorem.  It is not an assertion about
all degree-five curves.

## 8. Proof and boundary of Theorem R.6

The rational-normal-quartic locus is locally smooth of expected dimension
eight.  Its Abel--Jacobi map is dominant for a smooth cubic in the classical
fixed-line construction, but that construction first chooses a line.  The
generic twist has no line, so the fixed-line \(\mathbf P^1\)-fibre cannot be
descended as written.

Iliev--Markushevich prove that, for a **generic cubic** and a generic
Abel--Jacobi value, the fibre is a smooth irreducible threefold birational to
the cubic.  Their theorem states both genericity hypotheses explicitly.  The
Klein cubic is a special cubic with automorphism group \(G\), and the unique
value \(q_4\) is a special fixed value.  Neither hypothesis is available.

Theorem R.2 nevertheless gives an exact reduction: any descended quartic
must lie in the single fibre over \(q_4\).  A geometrically rational quartic
over \(K\) has a point over an extension of degree at most two.  The twist is
embedded in a split \(\mathbf P^4_K\); joining a quadratic point to its
conjugate gives a \(K\)-line, whose third intersection with the cubic is a
\(K\)-point.  If the line were contained in the cubic it would contradict
the no-line theorem.  Hence a point of this quartic fibre is already a
positive headline result.

## 9. The theorem boundary

The output is structural, not a positive or negative solution of Problem E.
It closes all conics, reduces all rational cubics to the headline, excludes
the elliptic-normal-quintic component, and identifies the exact quartic
fibre that remains.  Rational quartics, rational quintics, and higher
rational curves remain open.  No bounded inventory is asserted to exhaust
all degrees.

