# G3H phase 3 — semilinear landing

Marker: `G3H-SEMILINEAR-LANDING-PASS`

## Construction

For each maximal \(A_5\) class,

\[
P_i=\Psi_i\circ Y_i:W\dashrightarrow W,
\]

where \(Y_i\) is the cubic compression of phase 2 and \(\Psi_i=J_i\Phi_i\) is the
exact degree-11 landing covariant of the sealed H-A5 point packet
(`H-A5-CLASS*-RATIONAL-POINT`).

## Identities

1. **Landing.** The H-A5 packet proves \(F_{\mathrm{Klein}}(\Psi_i(y))=0\) as a
   polynomial identity on the source three-space. Substituting \(y=Y_i(w)\) yields
   \(F_{\mathrm{Klein}}(P_i(w))=0\) identically.
2. **Equivariance.** \(Y_i(hw)=\sigma_i(h)Y_i(w)\) and
   \(\Psi_i(\sigma_i(h)y)=\rho_i(h)\Psi_i(y)\) imply
   \(P_i(hw)=\rho_i(h)P_i(w)\).
3. **Nonvanishing.** Phase-2 Jacobian minor gives a nonempty open where \(Y_i\ne0\);
   the H-A5 chart \(a_0=1\) gives \(\Psi_i\ne0\) on a nonempty open of the source;
   the composition is nonzero on a nonempty open of \(W\).

Degree of \(P_i\) as a homogeneous map is \(33=11\cdot 3\).

Independent verifier rebuilds \(Y_i\), re-binds H-A5 hashes, and re-checks the
structural chain without importing this producer.
