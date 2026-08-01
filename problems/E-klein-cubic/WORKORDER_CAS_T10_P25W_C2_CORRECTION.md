# Binding correction to `WORKORDER_CAS_T10_P25W_C2.md`

**Applies to:** §1.2, the sentence calling \(\mathbf Q\to\mathbf Q_{101}\) a
“regular extension.”  
**Headline:** OPEN.

That description of the field extension should not be used.  The desired
conclusion that the target branch is nonnormal over \(\mathbf Q\) follows
without it.

At the Hensel point the base change of the target branch to
\(\mathbf Q_{101}\) has completed local equation

\[
K'[[x,y,z_1,z_2]]/(xy),
\]

whose singular locus is \(V(x,y)\), of dimension two.  The singular locus of
the hypersurface \(H=0\) is defined over \(\mathbf Q\) by the Jacobian ideal

\[
(H,H_A,H_B,H_Y,H_Z).
\]

Krull dimension is unchanged by field extension.  Hence the Jacobian singular
locus over \(\mathbf Q\) also has dimension at least two.  The target branch is
a threefold, so this is a codimension-one singular component.  A normal
Noetherian scheme satisfies \(R_1\), and therefore cannot have a codimension-one
singular component.  Thus the target branch is nonnormal over \(\mathbf Q\).

All other instructions and analytic inputs in
`WORKORDER_CAS_T10_P25W_C2.md` remain unchanged.  In particular, this correction
does not decide normality of the fold algebra \(S_G\).
