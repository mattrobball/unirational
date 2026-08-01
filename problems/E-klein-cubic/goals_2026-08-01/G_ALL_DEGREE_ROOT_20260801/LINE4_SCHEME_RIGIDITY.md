# Scheme-theoretic rigidity of the split line-degree-four boundary

## Exact split-fibre theorem

Let `X_4` be the projective landing scheme in the eleven-dimensional
central-compatible source for symbolic order three, transverse degree six,
line degree four over `F_67`.  Let

```text
B = P(D_L H_1) subset P(H_4).
```

The three quotient coordinates normal to `B` are

```text
u_0 = 20*z_1 + 63*z_5 + z_6,
u_1 = 66*z_0 + 10*z_4 + z_9,
u_2 = 53*z_2 +  6*z_3 + z_10.
```

The earlier primitive-chart calculation proves that every geometric point
of `X_4` lies in `B`.  The new calculation strengthens this to an equality
of schemes:

\[
             \boxed{X_4=D_L X_1\quad\hbox{scheme-theoretically over }\mathbf F_{67}.}
\]

Indeed, on each of the eight standard projective charts of `B`, Singular
computes a Groebner basis of the full 24-cubic degree-four ideal after the
chart coordinate is set to one.  In every chart:

```text
dim = 0,
vector-space dimension = 48,
NF(u_0) = NF(u_1) = NF(u_2) = 0.
```

Thus the full chart algebra is already a quotient of the inherited
subspace.  Restricting the 24 cubics to `B` is exactly multiplication by
`D_L^3` of the degree-one landing identity, so the reverse closed inclusion
is the scalar-multiplication inclusion `D_L X_1 subset X_4`.  The eight
charts cover the support because the primitive affine charts are unit
ideals.  This proves the displayed scheme equality.

There is also no first-order primitive escape inside the split fibre.  In
the coordinates above, differentiate the 24 cubics with respect to
`u_0,u_1,u_2` and restrict to `u=0`.  The rank-less-than-three locus is cut
out by the 2,024 maximal minors.  On each of the eight charts, the inherited
landing ideal plus these minors is the unit ideal.  Hence the normal
Jacobian has rank three at every geometric point of `D_L X_1`.

## Characteristic-zero boundary

The missing transfer lemma is now proved in `LINE1_CHAR0_FLATNESS.md`.  The
complete degree-one landing algebra is reconstructed over `Q(zeta_11)`.  An
exact RREF checks all 760 coefficient rows, and independent Singular inputs
give length 48 both generically and at `(67,zeta_11-64)`.  Since every
denominator is a unit at that prime, the finite degree-one algebra over the
localized cyclotomic DVR is torsion-free, hence finite flat of rank 48.

The closed inclusion `D_L X_1 subset X_4`, the scheme equality of their
special fibres proved above, flatness of `D_L X_1`, and Nakayama then give

```text
X_4 = D_L X_1
```

over the DVR and over `Q(zeta_11)`.  Thus the characteristic-zero first
transverse layer has no primitive line-degree-four point.  This closes line
degree four only; it does not supply an all-line-degree or higher-transverse-
layer theorem.

## Replay

```sh
/opt/homebrew/bin/python3 produce_line4_normal_rigidity.py
/opt/homebrew/bin/python3 verify_line4_normal_rigidity.py
/opt/homebrew/bin/python3 produce_line1_char0.py
/opt/homebrew/bin/python3 verify_line1_char0.py
```

The verifier reconstructs all chart inputs from the emitted hashes and runs
Singular.  It ends with

```text
LINE4_NORMAL_RIGIDITY_VERIFY_OK
```
