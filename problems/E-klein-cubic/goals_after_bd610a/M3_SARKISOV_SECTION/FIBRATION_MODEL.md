# Exact projective-Schur del Pezzo fibration

## Field and convention firewall

Throughout,

\[
K=K_{\mathrm{Schur}}=\mathbf C(\mathbf P(V_6))^{\mathrm{PSL}_2(\mathbf F_{11})}.
\]

This is neither the affine invariant field `C(W)^G` nor
`K_proj=C(P(W))^G`.  The binding frame is the equal-degree projective frame

\[
R_j=Q_j/I_8\quad (0\le j\le4),
\]

where every `Q_j` and `I8` has degree eight on `V6`.  The exact Reynolds
formula and the 35 lazy cubic coefficients (625 ordered triple products) are
sealed in the frame packet listed in `INPUT_MANIFEST.json`.

## Graph and generic fibre

Put

\[
\Phi_{\rm num}(a)=
\sum_{i=0}^4\left(\sum_jQ_{ij}a_j\right)^2
                 \left(\sum_jQ_{i+1,j}a_j\right).
\]

Then `Phi=Phi_num/I8^3`, and the fibration is

\[
Y=\{\Phi_{\rm num}(a)=0,\ a_3t-a_4s=0\}
  \subset\mathbf P^4_K\times\mathbf P^1_K.
\]

On `t != 0`, with `q=s/t`, its generic fibre is the cubic surface

\[
S/K(q):\quad \Phi_{\rm num}(a_0,a_1,a_2,qu,u)=0
\subset\mathbf P^3_{K(q)}.
\]

The only frame denominator is `I8`; the normalized cubic has denominator
`I8^3`.  The basis open is `I8*det(Q) != 0`.  Passing to the displayed base
chart introduces only `t != 0`.  There are no unrecorded candidate-section
denominators.

## Divisors and zero-cycles

For the blowup `pi:Y->X_T`, let `H=pi^*O_X(1)`, let `D` be the exceptional
divisor, and put `L=H-D=f^*O_P1(1)`.  The binding Cox/intersection packet gives

\[
-K_Y=2H-D=H+L,
\qquad
-K_{Y/\mathbf P^1}=D=H-L.
\]

On `S`, `L|S=0`, hence

\[
-K_S=H|S=D|S=:h,
\qquad h^2=3.
\]

The exceptional plane cubic supplies a degree-three zero-cycle.  The
connected orbit of 55 involution minus-lines, all disjoint from the centre,
supplies a degree-55 point.  Thus `ind(S)=gcd(3,55)=1`.  Index one is not a
rational-point theorem.

## Smoothness and Lefschetz reductions

The exact-frame producer reconstructs `Phi_num` and gives smooth generic
fibres at two split reductions.  The independent chart Jacobian checks pass
over `F_23(q)` and `F_67(q)`.  Because smoothness is open and the two
certificates specialize the exact Reynolds circuit, the characteristic-zero
generic surface is smooth.

At each good reduction the entire critical scheme lies in the projective
chart `a0=1`, has length 24, and has a squarefree degree-24 base
discriminant.  The spatial Hessian, base derivative, and full critical
Jacobian are nonzero at every critical point.  The `a0=0` complements and the
fibre at infinity are smooth.
The discriminant factor degrees are

```text
p=23: 4,6,14
p=67: 1,4,4,6,9
```

These are nonvanishing open conditions, so the characteristic-zero generic
Schur pencil has 24 transverse `A1` fibres.  This is a Lefschetz certificate,
not a computation of the actual 27-line monodromy group.  The exact critical
and conditional abstract `W(E6)` ledgers are in `line_monodromy.json`.

## From a section to the authoritative twist

A nonexceptional section has coordinates

\[
[A_0(s,t):A_1(s,t):A_2(s,t):s r(s,t):t r(s,t)]
\]

with no common zero and with the cubic identity holding identically.  A
`K(q)`-point extends over `P1_K` by properness.  Evaluating the resulting
section at any `K`-rational base value and applying `pi` gives a point of the
authoritative `X_T/K`.  No such section was produced in this packet.

The current top-level M2 replay stops on one stale, non-load-bearing upstream
status hash.  The selected-link, centre-census, Mori/Cox, and exact-frame
verifiers all replay independently; the precise drift is recorded in
`INPUT_REPLAY.md`.
