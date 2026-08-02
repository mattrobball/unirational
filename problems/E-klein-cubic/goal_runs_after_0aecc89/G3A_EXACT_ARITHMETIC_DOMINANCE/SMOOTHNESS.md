# Smoothness of \(X_{\mathrm{gen}}=V(\Phi)\)

## Twist argument

The Klein cubic \(X\subset\mathbf P(W)\) is a smooth hypersurface (the classical
Klein threefold).  The universal object of G2 is the generic twist

\[
X_T=T\times^G X
\]

over \(K_{\mathrm{proj}}\), identified with \(V(\Phi)\subset\mathbf P^4_{K_{\mathrm{proj}}}\)
on the exact twisting open where the frame
\((x,C,D,E,K_7)/\tau^{\bullet}\) is a basis (denominator ledger: powers of
\(\tau=f_3^2/f_5\) and the Hironaka parameter open).  Smoothness is preserved by
Galois descent/twisting of a smooth proper scheme: every geometric fibre of the
twist is isomorphic to \(X_{\overline{k}}\), hence smooth.  Therefore
\(X_{\mathrm{gen}}\) is smooth over \(K_{\mathrm{proj}}\) on the installed open.

No generic five-variable Gröbner re-proof is required.

## Jacobian consistency check (specialization)

`verify_phi.py` evaluates a modular Jacobian row of the specialized secondary-0
slice of \(\Phi\) at a nonzero test point for primes \(67\) and \(89\) and checks
that the gradient is not identically zero, confirming the derivative API is
consistent with a nondegenerate cubic form after specialization.  This is a
consistency check, not an independent smoothness proof (the twist argument
supplies smoothness).

## Conclusion

Smoothness of \(X_{\mathrm{gen}}\) is settled by the twisting/descent argument
from the smooth Klein cubic, with one specialized Jacobian consistency check.
