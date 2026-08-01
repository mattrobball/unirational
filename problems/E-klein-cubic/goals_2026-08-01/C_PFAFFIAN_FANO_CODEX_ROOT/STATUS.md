C-UNDECIDED

# Isolated Codex-root run

This folder is the collision-free workspace for the present Goal C worker.
The shared `../C_PFAFFIAN_FANO/` packet is consumed read-only from this point.

Current exact progress:

- shared exact characteristic-zero polynomials `m_a` and `m_b`, hence the full
  scalar `b^6` block, independently replayed;
- rational interpolation for `L_a[0,1,0]` rejected at `p=353` through total
  numerator/denominator degree eight using 7,500 deterministic good samples;
- `compressed_algebra.json` is an exact lazy maximal-etale multiplication
  interface: both Reynolds generators are rebuilt coefficient-by-coefficient,
  the rectangular frame is `R=(vec(b^j a^i))`, and every `L_a` coordinate is
  the invariant Cramer DAG `R^-1 vec(a b^j)`;
- its independent verifier rebuilt both exact generator matrices from all 660
  Reynolds terms and passed fresh rectangle, unit, multiplication, and
  associativity tests at the unused split primes 331 and 463;
- `involution.json` transports the exact symplectic adjoint
  `sigma(M)=Q^-1 M^t Q`, with `Q(x)=Jx`, to the rectangular frame;
- the independent involution verifier rebuilt `Q` coefficient-by-coefficient,
  checked skewness, invertibility, `sigma^2=1`, and anti-multiplicativity
  exactly at `(0,0,1,-1,-1)`, and recovered fixed/anti-fixed dimensions
  `15/21` at the fresh primes 331 and 463;
- an independent audit of the saved ambient-projector leading ideals gives
  empty mod-23 projective schemes in degrees 9--11 and Hilbert function
  `[1,48,705,1971,3,3,3,3,3]` in degree 12, hence a length-three
  zero-dimensional auxiliary scheme there;
- genuinely independent split-prime reconstructions at 67 and 89 reproduce
  the same 48-element degree-12 seed frame and equation rank 471.  No point
  or characteristic-zero lift has yet been accepted from that scheme;
- `distinguished_five_plane.json` uses the exact equivariant Hilbert--90
  frame `x,C,D,E,K` to install the five specific section elements
  `S_j=Q(x)^-1 Q(V_j(x))`.  An independent exact witness gives rank five and
  the fresh-prime compressed transports at 331 and 463 also have rank five;
- the authoritative exact covariant replay independently checked equivariance
  of `C,D,E,K` under the exact `S,T,P` generators and reproduced
  `det[x,C,D,E,K](-2,-2,-2,-2,-1)=-295136920`.

The exact lazy DAG is an executable compressed interface, but it is not an
adaptive rational reconstruction of the expanded `L_a` entries in the named
Hironaka invariant frame.  The intended five-plane is now identified exactly
inside the algebra-with-involution, but no explicit self-adjoint
reduced-rank-two idempotent, Morita quaternion, `3 x 3` Hermitian realization,
simultaneous common line, original-equation point, or headline proof has been
constructed.  In particular, the abstract Morita projector remains auxiliary
and is not promoted to a Fano point.
