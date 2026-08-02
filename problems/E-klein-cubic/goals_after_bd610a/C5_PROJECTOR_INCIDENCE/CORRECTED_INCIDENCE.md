# Correct genuine-Fano incidence

The binding self-adjoint idempotent system is inconsistent, but the same
15-dimensional symmetric space gives an exhaustive direct incidence after
replacing an idempotent by a square-zero operator.

## Intrinsic model and side conventions

Use the installed Morita data

```text
A=End_D(P),  P=A*epsilon,
h_0(a*epsilon,b*epsilon)=epsilon*sigma(a)*b*epsilon.
```

For an isotropic right `D`-line `U=qD`, put

```text
n_q(v)=q*h_0(q,v).
```

Then `sigma(n_q)=n_q`, `n_q^2=0`, `n_q P=U`, and `n_q A` is the
corresponding right ideal.  Replacing `q` by `qd`, for `d in D^*`, scales
`n_q` by `Nrd_D(d)`.  Thus the canonical dictionary is projective:

```text
[n]  <-->  nA  <-->  nP=qD.
```

It is not a bijection between raw nonzero operators and lines.  Conversely,
write a rank-one operator as
`theta_(q,r)(v)=q*h_0(r,v)`.  Self-adjointness forces `r=q*c`, with
`c=bar(c)`.  The involution on the quaternion algebra `D` is its canonical
symplectic involution, so `Sym(D,bar)=K`; hence every such operator is a
central scalar multiple of `n_q`.  This proves uniqueness projectively.

The corrected projective equations are

```text
sigma(n)=n,
n^2=0,
Trd(n*S_i)=0,  i=0,...,4,
[n] in P(Sym(A,sigma)).
```

All five trace equations are retained.  In particular `S_0=1`, so the first
one is `Trd(n)=0`; it is set-theoretically automatic for square-zero matrices
but is essential scheme-theoretically.

## Exact split proof

After a splitting extension let `Q_0=Q(x)` and write

```text
n=P_U*Q_0,
```

where `P_U` is a skew `6 x 6` matrix.  Self-adjointness is exactly skewness
of `P_U=n*Q_0^(-1)`.  The exact characteristic-zero certificate
`corrected_nilpotent_scheme_QQ.sing` proves

```text
< entries(n^2), Tr(n) >
  = < Tr(n), all fifteen 4x4 Pfaffians of P_U >.
```

Without the trace equation, the square-zero ideal has affine dimension `8`
and projective degree `28`; after adjoining the trace equation it has the
same dimension and degree `14`, exactly the reduced Pluecker/isotropic
Grassmannian ideal.  This rules out a hidden doubled structure.
The calculation applies to the installed `Q_0`: after faithfully flat
splitting, every nondegenerate alternating form is congruent to the displayed
standard form; the induced linear coordinate change transports both ideals,
and ideal equality descends by faithful flatness.

For geometric points, `n^2=0` gives `rank(n)<=3`, while `Q_0 n` is alternating,
so `rank(n)` is even.  Every nonzero solution therefore has ordinary rank
two, equivalently reduced rank two or `D`-rank one.  Conversely every
isotropic `D`-line produces such a projective operator.

Finally, with `S_i=Q_0^(-1)Q_i`,

```text
Trd(n*S_i)=tr(P_U*Q_i)=-2*<Q_i,p_U>.
```

Since the field has characteristic zero, its vanishing is exactly the
installed `i`th Pluecker hyperplane.  On this cone one also has

```text
n*S_i*n=(Trd(n*S_i)/2)*n,
```

so the trace equations are precisely simultaneous isotropy, not merely a
necessary condition.

## Exhaustive exact equation inventory

`corrected_incidence.json` uses the sealed exact basis

```text
q_j=M_k+sigma(M_k),  k=0,...,13,15,
n(t)=sum_j t_j*q_j.
```

It records all `36` rectangle coordinates of `n(t)^2`, all five trace
hyperplanes, and all `15` projective charts `t_j=1`.  No full-algebra
coordinate is discarded.  Every coefficient source is an exact
non-interpolated `R^(-1) vec(-)` circuit over `K_proj`.

The intrinsic target opens are: characteristic different from two, the
degree-six Azumaya/CSA open, `det(R)!=0`, `Pf(Q_0)!=0`, the selected symmetric
basis minor, the five-plane rank minor, and projective `n!=0`.  If the
maximal-etale presentation is invoked verbatim, its `f14*f11!=0` and
`disc(m_a)!=0` factors are also retained.  No target inverse of
`<Q_0,p_U>` is allowed.  The auxiliary projector, its RUR root, and its
Morita Cramer minors are not consumed by this intrinsic model.

## Generic coefficient materialization

`build_generic_pluecker_incidence.py` expands the five genuine hyperplanes
coefficient-by-coefficient over `Q(zeta11)[x]`, directly from `Q` and the
Hilbert--90 frame.  The serialized term counts are

```text
75, 450, 675, 1050, 1800.
```

Together with all fifteen Pluecker quadrics and all fifteen standard charts,
this is an exact split presentation of the whole twisted scheme.  Its
independent verifier reconstructs every coefficient and checks the three
recorded primes plus the unused prime `617`.  The file explicitly retains the
descent warning: an arbitrary solution over the splitting field is not yet a
`K_proj`-point.

`morita_generic_dag.json` provides the intrinsic descent presentation.  Write

```text
q_r=sum_alpha u_(4r+alpha)*d_alpha,  r=0,1,2,
```

in the accepted `K_proj` bases of `D=eAe` and `Ae`.  It serializes every one
of the `5*78=390` homogeneous quadratic coefficients and all three
`q_r=1_D` charts.  The denominator-minimal ordered coefficient is

```text
-Tr(P*M_alpha^T*Q*P*G_r^T*B_i*G_s*P*Q*M_beta)/(2*s^3).
```

This formula follows from the original Hermitian pairing by substituting
`e=-PQ/s`, `star(X)=Q^-1 X^T Q`, and `S_i=Q^-1 B_i`, then using `e^2=e` and
cyclicity of trace.  It needs neither a corner Cramer inverse nor an expanded
36-dimensional multiplication tensor.  The three normalized charts cover
all `K_proj`-lines because the generic quaternion is division; the Pluecker
presentation supplies the exhaustive geometric cover after splitting.

`morita_generic_verify.py` independently evaluates all 390 homogeneous and
675 chart records at the accepted good fibre, matches the original corner
multiplication/Hermitian tables, and recovers the sealed smooth common line.
This proves that the generic coefficient DAG is executable and convention
compatible.  It does not turn the residue line into a rational section.

## Structural finite-fibre certificates

`build_corrected_incidence.py` independently specializes the installed
five-plane, eliminates its five linear Pluecker equations, retains all
fifteen restricted Grassmann quadrics, and runs Singular at two discovery
primes and a separately designated holdout prime.

| prime | role | frame det | `det Q_0` | affine dim | projective dim | degree | smooth charts |
|---:|---|---:|---:|---:|---:|---:|---:|
| 331 | discovery | 183 | 79 | 4 | 3 | 14 | 15/15 |
| 463 | discovery | 269 | 185 | 4 | 3 | 14 | 15/15 |
| 419 | holdout | 284 | 387 | 4 | 3 | 14 | 15/15 |

The fifteen standard Grassmann charts cover every geometric point, and on
each chart the ideal generated by the five section equations and the `5x5`
Jacobian minors is the unit ideal.  Hence every listed fibre is geometrically
smooth.  Each is a codimension-five linear complete intersection in the
geometrically integral, arithmetically Cohen--Macaulay `Gr(2,6)`; the
connectedness theorem for positive-dimensional ample complete intersections
makes it geometrically connected.  Smoothness plus geometric connectedness
then gives one geometrically integral component.  The component conclusion
is this written theorem, not a component count emitted by Singular.

`verify_corrected_incidence.py` reconstructs the five forms from the sealed
Hilbert--90 and involution inputs, regenerates every Singular input
byte-for-byte, and reruns all seven exact jobs without importing the builder.

`verify_modular_seed_p23.py` supplies a complementary installed-coordinate
check at the certified split fibre `p=23`, `x=(22,21,8,1,1)`.  It reconstructs
a smooth nonzero solution in the sealed 15-element symmetric basis and maps it
back to a decomposable Pluecker bivector.  The same constant coefficient
vector fails across the other five regular fibres, and the stacked trace
matrix has rank fifteen.  This is a modular seed and a constant-ansatz
boundary, not a rational section.

`MORITA_SEED_P23.md` and `verify_morita_seed_p23.py` give an independent
second `p=23` seed directly
in the accepted quaternionic Morita coordinates.  It rebuilds all five
`q^*H_iq` quadrics, exhausts a normalized `23^4` parameter space, substitutes
one common right-`D` line with five zero `D`-valued residuals, and verifies a
nonzero `5x5` Jacobian minor.  Its scope is again one split finite fibre.

## Scope

This gives an exact serialized split system and a structural three-prime
audit.  The intended intrinsic `K_proj` Morita coefficients are specified by
a universal trace formula, but their serialized source leaves are not yet
resolved by an exact generic interpreter; the current verifier checks only a
good finite specialization.  It supplies neither a `K_proj`-rational point
nor a characteristic-zero rational-point obstruction.  The strongest honest
exit is therefore `C5-UNDECIDED`; neither the positive, executable-full-
incidence, nor empty branch is claimed.
