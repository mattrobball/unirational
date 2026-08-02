# Polarization and derivatives

The cubic form \(\Phi\) determines a unique symmetric trilinear polarization
\(B\) with \(B(a,a,a)=\Phi(a)\).  In coordinates, if

\[
\Phi(a)=\sum_{i,j,k}\alpha_{ijk}a_ia_ja_k
\]

with \(\alpha\) symmetric, then \(B(u,v,w)=\sum \alpha_{ijk}u_iv_jw_k\).

The G3A API builds \(\alpha\) from the 35 nondecreasing triples in
`generic_cubic.json` by equal distribution over ordered permutations.

First derivatives: \(\partial_{a_r}\Phi=3B(e_r,a,a)\).  
Second derivatives: \(\partial_{a_i}\partial_{a_j}\Phi=6B(e_i,e_j,a)\).

Projective linear substitutions act by \(a\mapsto Ma\) on the five ambient
coordinates.  Specialization of coefficients uses the projective \(t\)-exponents
and a secondary-generator slice (documented in `phi_api.py`).
