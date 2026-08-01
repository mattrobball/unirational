# Full Schur Palatini point model (exact, nonterminal)

## Outcome

The full Schur twist has been reduced to one explicit quartic point identity, but no
`K_Schur` point (and no pointlessness proof) was found.  Therefore this packet does
**not** decide the binary Q mission.

Let `V=V6` be the genuine six-dimensional representation of the Schur cover and
let `B5` be the invariant five-plane in `Lambda^2(V*)`.  For a vector `p`, form the
`6 x 5` contraction matrix

```
C(p) = [ omega_0 p | ... | omega_4 p ].
```

Exact computation over `F_23` proves that all signed maximal minors are
`p_i I4(p)`, up to one common nonzero scalar, where `I4` is the unique degree-four
Schur invariant in that fibre.  The characteristic-zero lift is source-bound as
follows.  `tmp/pfaffian_representation_alignment/core.py` constructs the exact
six-dimensional matrices and the unique `15 x 5` intertwiner over
`Q(zeta_11)`.  `verify_char0_palatinian_lift.py` reduces both at the unramified
prime `(23,zeta_11-2)`, matches the two exact generator matrices entry by entry,
and proves that the reduced exact intertwiner and the modular `B5` have the same
rank-five column space.  CRT character traces at 23, 67, and 89 then prove
`dim Sym^4(V*)^(2.G)=1` (residues `[1,1,1]`, modulus `137149 > 126`).

Universally, the signed maximal minors of a `6 x 5` matrix `[omega_j p]` are
`p_i` times a quartic because `p^t omega_j p=0`.  Stability of the exact `B5`
makes that quartic invariant (the perfect Schur group has no nontrivial scalar
character).  Its compatible reduction is nonzero, so uniqueness identifies the
characteristic-zero Palatini quartic with the Reynolds `I4`, up to scalar.  A
`K_Schur` point on it gives a `K_Schur`-defined kernel of dimension at least two,
hence a point of the twisted `V14`; the installed birational link then gives a
point of the twisted Klein cubic.

## Explicit Hilbert-90/projective frame

For `i=0,...,5`, define the degree-seven Reynolds self-covariants

```
r_i(v) = sum_{g in 2.PSL(2,11)} (g v)_5^7 g^(-1)e_i.
```

At `v=(9,18,15,18,2,19)` modulo 23 the six columns `r_i(v)` have exact rank six.
Consequently they give a generic projective frame for the split twist of `P(V)`.
In frame coordinates the remaining point problem is the single explicit identity

```
Psi(b_0,...,b_5) = I4(sum_i b_i r_i) = 0,
```

with invariant rational coefficients `b_i in K_Schur`, not all zero.  Finding such
`b_i` is the concrete missing identity; kernel extraction from `C(sum b_i r_i)` is
then mechanical.

## Exact low-degree exclusion

CRT character computation at 23, 67, and 89 gives self-covariant multiplicities
in degrees 0 through 7:

```
0, 1, 0, 1, 0, 3, 0, 8.
```

The degree-one and degree-three generators do not land in `I4=0`.  For degree five,
the coefficient landing equations span all 15 quartic monomials, so the projective
landing scheme is empty.  For degree seven, 319 independent quartic equations in
330 coefficient monomials have a Groebner basis of size 330; Singular returns
affine dimension zero and vector-space dimension 176.  Because the ideal is
homogeneous, its projectivization is empty.  Good reduction then excludes a
characteristic-zero constant-coefficient Schur self-covariant of degree at most
seven landing identically in the Palatini/Reynolds quartic `I4=0`.

This does not exclude degree at least nine, non-polynomial invariant-rational
coefficients, or an isolated `K_Schur` point of `Psi=0`.

## Replay

Run:

```
/opt/homebrew/bin/python3 verify.py
```

Expected terminal marker:

```
FULL_SCHUR_CHAR0_PALATINI_PACKET_OK
SCOPE: exact char-0 quartic model and bounded exclusions; no K_Schur point and no binary Q verdict
```

Requirements: `/opt/homebrew/bin/python3` with NumPy and `Singular` on `PATH`.
The scripts read the pre-existing exact representation constructors listed in
`source_manifest.json`.  `verify.py` checks every source hash before importing
them; the manifest also records the one transitive import.
