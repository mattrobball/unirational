# Both literal goal-qualified Hilbert branches are empty

## Setup over the generic field

Put `F=K_Schur`, `M=P3_F`, and write `X=V(f3) subset M` for the hyperplane
section of the generic Schur-twisted cubic relevant to the bridge.  Let
`H_Z` be the marked Hilbert scheme with polynomial `19*t+1` and containment
`Z subset C`.  The upstream postulation analysis gives two live strata:

| stratum | `dim I_C(5)` | Rao dimensions in degrees 0 through 5 | upstream status |
|---|---:|---|---|
| `H_Z,0` | 0 | `(0,16,29,38,42,40)` | LIVE |
| `H_Z,1` | 1 | `(0,16,29,38,42,41)` | LIVE |

Their upstream status concerns the coherent ambient-curve incidence problem;
it is not altered by this packet.

## Goal-qualified subfunctors

For `epsilon in {0,1}`, define `G_epsilon` to be the subfunctor of
`H_Z,epsilon` whose families also satisfy every literal exact-target condition:

1. `C subset X`;
2. `C` is pure of relative dimension one and geometrically integral on the
   relevant fibres;
3. `C cap X` is zero-dimensional with total length 57;
4. subtracting the marked length-55 scheme leaves a length-two residual;
5. all conditions Q1--Q6 of the incorporated `BR-SCHUR19-POS` audit hold.

The claim is

\[
\mathcal G_0=\mathcal G_1=\varnothing.
\]

## Scheme-theoretic proof

The proof works after arbitrary base change `T -> Spec(F)`.  If
`C_T subset X_T`, then the ideal sheaves satisfy

\[
\mathcal I_{X_T}=(f_3)\subset\mathcal I_{C_T}.
\]

The fibre product defining the scheme-theoretic intersection has ideal

\[
\mathcal I_{C_T\cap X_T}
=\mathcal I_{C_T}+\mathcal I_{X_T}
=\mathcal I_{C_T}.
\]

Therefore `C_T cap X_T=C_T`.  A family of pure relative curves cannot at the
same time be a finite length-57 intersection over `T`.  In particular the
residual length-two condition is impossible.  This proves emptiness functorially,
not merely absence of `F`-points.

There is also an independent component proof on geometric fibres.  A
geometrically integral curve has a single irreducible component.  Containment
in `X` puts that component in `X`, while Q3 says no component may lie in `X`.

## Branch coverage

The contradiction does not use `dim I_C(5)`, the Rao module, the carrier
degree, the Picard group, or a special hyperplane.  Hence it applies equally
to:

- `epsilon=0`, the no-quintic branch;
- `epsilon=1`, the unique-special-quintic-carrier branch.

It holds over `F`, over its algebraic closure, and over every extension field.
Thus both *literal goal-qualified* branches are exactly empty over the generic
field.

## Boundary of the conclusion

This does not assert that `H_Z,0` or `H_Z,1` themselves are empty.  Removing
the contradictory condition `C subset X` produces the coherent ambient-curve
problem, and both of those upstream strata remain undecided.  Accordingly the
Klein-cubic headline remains OPEN.
