# J2.3 — induced Prym factor, lattice, and polarization audit

## 1. The exact curve correspondences

Write

\[
L=H^3(X,\mathbf Q)(1),\qquad M=H^1(C,\mathbf Q).

\]

The target has rational rank \(10\).  The curve \(C\) has genus \(103\), so
\(\dim_{\mathbf Q}M=206\).  Let
\(a:L\to H^1(\widetilde\Gamma,\mathbf Q)\) and
\(b:H^1(\widetilde\Gamma,\mathbf Q)\to L\) be the Prym correspondences with
\(ba=1\).  For the degree-three projection
\(\pi_1:C\to\widetilde\Gamma\), set

\[
a_C=\pi_1^*a,
\qquad b_C=\frac13 b\,\pi_{1*}.

\]

Then \(b_Ca_C=1\).  This retains the classical Prym factor, including its
CM field \(\mathbf Q(\sqrt{-11})\), inside \(J(C)\).

## 2. Induction from the forced \(C_2\)-stabilizer

Let \(H=\langle t\rangle\).  The \(H\)-action on \(C\subset P_t\) is
trivial.  Put \(e_+=(1+t)/2\) on \(L\) and define

\[
I(x)=\sum_{gH\in G/H}[gH]\otimes a_C(e_+g^{-1}x)
   \in\operatorname{Ind}_H^G M.
\tag{2.1}
\]

This is independent of coset representatives and is \(G\)-equivariant.  The
exact \(C_2\)-restriction has complex invariant dimension \(3\), hence
\(\dim_{\mathbf Q}L^H=6\).  Injectivity will follow from the explicit left
inverse below; no semisimplicity shortcut is needed.

For \(c=e_+b_C\), the conjugate-projector sum is central.  Each of the 55
conjugate involutions occurs six times in the 330-coset sum.  The exact
character value of an involution on each five-dimensional complex
constituent is \(1\), so its class sum acts by \(55/5=11\).  Consequently

\[
\sum_{gH\in G/H}g e_+g^{-1}
=\frac12(330+6\cdot11)\,\mathrm{id}
=198\,\mathrm{id}.
\tag{2.2}
\]

Therefore

\[
R([gH]\otimes y)=\frac1{198}g\,c(y)
\]

satisfies \(RI=1\).  The curve orbit contributes total rank

\[
330\cdot206=67980

\]

to \(H^3\), and contains the target as a split rational \(G\)-Hodge
substructure.

## 3. Integral scope

All displayed maps are algebraic correspondences over \(\mathbf Q\).  The
Prym projector uses \(2^{-1}\), the curve norm uses \(3^{-1}\), and the
equivariant retraction uses \(198^{-1}\).  Thus

\[
\mathbf Z[1/198]

\]

is a safe common coefficient ring.  Clearing denominators gives an injective
map of the target integral lattice into the centre contribution.  No
primitive or unimodular integral direct summand is claimed.

This matches the actual dominance bridge: for a resolved fourfold-to-
threefold map, \(r\circ f^*=n\,\mathrm{id}\), so only a rational or
\(\mathbf Z[1/n]\)-splitting is forced.  J2 supplies no theorem making
\(n=1\) or preserving a principal integral form.

## 4. Polarization and Prym type

Restrict the product Jacobian polarization on the 330 curve components to
the image of \(I\).  It is a positive \(G\)-invariant rational form.  On the
complex irreducible five-dimensional constituent it is a positive rational
multiple of the natural theta form.  Hence the centre realizes precisely
the polarized-Hodge strength forced by the relative-dimension-one
splitting.

The construction retains an actual Prym presentation of \(J(X)\) through
\(\widetilde\Gamma\), not merely an abstract character copy.  It does not
identify an integral principally polarized factor of \(J(C)^{330}\) with
\((J(X),\Theta)\); such an identification is stronger than the bridge and is
not a valid necessary condition.

## 5. Residual parity and Mackey data

For the chosen involution, the six fixed components form the regular
\(S_3\)-set, whose linear decomposition is

\[
\mathbf1\oplus\operatorname{sign}\oplus2\,\mathrm{Std}.

\]

Thus restriction and Mackey decomposition contain all residual parities.
The target restriction \(W^*|_{S_3}=\mathbf1\oplus2\,\mathrm{Std}\) is a
direct constituent; the extra sign channel causes no obstruction.  The
CM \(-11\) structure is carried by the Prym factor itself.

## 6. Verdict

Integral lattice, polarization, CM, residual parity, Prym type, and Mackey
induction all fit at the strength genuinely forced by dominance.  An
integral principal-polarization obstruction would require an additional
bridge theorem which is presently false or unproved at this relative
dimension.
