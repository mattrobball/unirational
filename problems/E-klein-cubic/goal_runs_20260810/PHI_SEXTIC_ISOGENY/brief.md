# PHI_SEXTIC_ISOGENY — work order

**Question.** On the two Prokhorov `PSL(2,11)`-threefolds there are two
genus-one curves in the two involution fixed loci:

* `E_sigma = X cap P(W_sigma^+)`, the plane cubic in `X^sigma = E_sigma ⊔ L_sigma`
  on the Klein cubic `X` — `j = 8192/11`, sealed
  (`goal_runs_after_2880a28/FIX_A0_INVOLUTION_ARRANGEMENT`, `FIX-A0-ARRANGEMENT-PASS`);
* `C_sigma = V14 cap P(M_+)`, the smooth genus-one sextic in
  `V14^sigma = C_sigma ⊔ {2 points}` — sealed
  (`goal_runs_after_c53d89a/FIX_IX_SEAL`, `FIX-IX-SEAL-PASS`).

A sealed theorem gives a nonconstant `G`-equivariant rational map
`Phi: V14 --> X` (`V14MAP-V14-TO-KLEIN-EXISTS`, PR #19 branch). Equivariance
sends `V14^sigma` into `X^sigma`, so `Phi|_{C_sigma}` lands in `E_sigma` or in
`L_sigma`, and it must respect the residual `S3 = C_G(sigma)/<sigma>`.

**Task.** Decide whether `C_sigma` is isogenous to `E_sigma` over `C`; decide
whether an `S3`-equivariant nonconstant map `C_sigma -> L_sigma = P^1` exists;
state exactly which restrictions `Phi|_{C_sigma}` are possible.

**Method.**
1. Rebuild `C_sigma` from the seal's own model (`T6`, `S6`; `M` = the `10'`
   summand of `Lambda^2 U`; `M_+`), exactly over `K = Q(zeta_11)` and at split
   primes `p = 1 mod 11`.
2. Split `M_+` by an involution `tau` of the residual `S3` (dims 4+2); the
   3 `tau`-odd quadrics give a `3x2` matrix `A(v)` of linear forms, Cramer on
   `A(v).(s,t)^T = 0` gives the parametrisation `nu(s,t)` of the twisted cubic
   `C_sigma/tau`, and a `tau`-even quadric normalised to `w_0^2` gives the
   branch quartic `R(s,t)`. `C_sigma: c^2 = R(s,t)`; then `j` and `#C(F_p)`.
3. Build `E_sigma` inside the SAME framework: `Ann(M) subset Lambda^4 U` is the
   Klein 5-rep, `Pf6` is the invariant cubic, `E_sigma = {Pf6=0} cap P(W^+)`;
   the `tau`-adapted coordinates put it in Weierstrass form directly.
4. Compare `j`, `a_p`, and — since `rho` in `S3` is a translation by a
   3-torsion point `T` — the pairs `(C_sigma, T_C)` and `(E_sigma, T_E)`.
5. Verify formulas on known curves; verify every decisive number two ways.
