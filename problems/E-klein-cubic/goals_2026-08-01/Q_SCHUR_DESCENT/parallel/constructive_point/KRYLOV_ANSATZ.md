# Constant-Krylov point probe over `K_proj`

Date: 2026-08-01.

## Verdict

No point was found.  Two previously untested structural ansatzes are excluded
exactly, but neither exclusion settles the unrestricted generic cubic.

Let

\[
P_0=\mathbf Q(t_3,t_6,t_8,t_{11})
\]

and use the certified normalized Hironaka basis of the degree-12 extension
`K_proj/P_0`.  In the ordering of `generic_cubic.json`, put

\[
e_0=1,\qquad e_1=f_7/\tau^7,\qquad
e_6=f_7^2/\tau^{14}.
\]

For **each** of the five coordinates `a_i` of the descended Klein cubic, the
two tested forms are

\[
a_i=u_i+v_i e_1
\]

and

\[
a_i=u_i+v_i e_1+w_i e_6,
\]

where all displayed coefficients are arbitrary constants.  These are full
five-coordinate ansatzes inside the first two and first three Krylov vectors
for multiplication by `f7`; they are not coordinate-support or basis-atom
searches.

The exact answers are:

| constant coefficient space in every `a_i` | variables | independent cubics | exact Hilbert function | verdict |
|---|---:|---:|---|---|
| `<1,f7>` | 10 | 140 of 220 | `[1,10,55,80,50,0]` | projectively empty |
| `<1,f7,f7^2>` | 15 | 245 of 680 | `[1,15,120,435,820,351,50,0]` | projectively empty |

For the triple case, exact `msolve` over `GF(199)` returns a reduced leading
ideal with 802 monomials: 245 in degree 3, 65 in degree 4, and 492 in degree
5.  Its standard-monomial count is the displayed Hilbert function and is zero
in degree 7.

## Why the finite-field computation lifts

The producer starts with the certified universal cubic
`G_ALL_DEGREE/generic_cubic.json` and the exact normalized multiplication
table `tmp/kproj_arithmetic/normalized_kproj_table.json`.  It substitutes the
ansatz and expands the result in all twelve field-basis directions.  Sixty-four
deterministic values of `(t3,t6,t8,t11)` supply 768 necessary homogeneous
cubic equations.

The chosen prime is `199`.  It is split modulo 11, does not divide the group
order 660, and none of the 7,722 literal rational denominators in the two
upstream objects vanishes modulo 199.  A characteristic-zero solution of the
full coefficient identity would define a point of the corresponding
projective coefficient scheme.  After passing to a finite extension of the
local DVR, projective properness gives a special-fibre point.  That point must
satisfy every sampled necessary equation.  Since the sampled projective locus
is empty, the displayed characteristic-zero ansatz is empty as well.

The 64 evaluations do not need to reconstruct every coefficient polynomial:
they are used only in the logically safe direction

\[
\{\text{full identities}\}\subseteq
\{\text{sampled necessary equations}\}=\varnothing.
\]

## Exact replay

From this directory:

```sh
/opt/homebrew/bin/python3 probe_kproj_krylov.py pair
/opt/homebrew/bin/python3 probe_kproj_krylov.py triple --timeout 300 --threads 4
/opt/homebrew/bin/python3 verify_kproj_krylov.py
```

The verifier reconstructs all 1,536 sampled field-basis rows from the two
authoritative inputs, checks their semantic hashes, reranks them over
`GF(199)`, regenerates both `msolve` inputs, closes the pair ideal by exact
homogeneous multiplication, reruns `msolve` for the triple ideal, and recounts
standard monomials.  Its terminal marker is

```text
Q_CONSTRUCTIVE_KPROJ_KRYLOV_EXACT
```

## Scope boundary

This proves only the emptiness of the two displayed constant-coefficient
Krylov subspaces.  It does **not** exclude:

- use of any of the other nine normalized field-basis directions;
- coefficients depending nontrivially on `P_0`;
- an arbitrary `K_proj`-rational point;
- an arbitrary `K_Schur`-rational point or rational map from `P(V6)`.

Because there is no candidate, there is no coordinate tuple to verify in the
original Klein equation and no headline bridge to invoke.
