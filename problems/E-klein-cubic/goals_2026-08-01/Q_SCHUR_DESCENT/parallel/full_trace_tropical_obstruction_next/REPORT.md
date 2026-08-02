# Two constant five-coordinate trace exclusions

## Exact outcome

Let

\[
K=\mathbf C(U_1,U_2,U_3,U_4),\qquad
E=K(\alpha),\quad \alpha^5=U_1,\quad
\sigma(\alpha)=\epsilon\alpha,
\]

and retain the authoritative trace cubic

\[
\Phi(a)=\operatorname{Tr}_{E/K}
\left(r_2^{-1}a^2\sigma(a)\right),
\qquad r_2^{-1}=R_3/R_2.
\]

This packet proves the following structured-family theorem.

> **Constant five-coordinate exclusion.** There is no nonzero constant
> coefficient vector in either of the following families satisfying the trace
> identity in `K`:
>
> 1. `a=R2*b`, where `b=sum_(i=0)^4 c_i alpha^i` and `c_i in C`;
> 2. `a=sum_(i=0)^4 c_i R_i`, where `c_i in C`.

It does **not** exclude coefficients in `K`, and therefore does not prove
pointlessness of the trace cubic or of the twisted Klein cubic.

## The two coefficient schemes

The installed normalization has

\[
R_i=1+\epsilon^i\alpha+\epsilon^{2i}U_2\alpha^2
 +\epsilon^{3i}U_3\alpha^3+\epsilon^{4i}U_4\alpha^4,
\qquad \sigma(R_i)=R_{i+1}.
\]

For the Kummer-coordinate family, substituting `a=R2*b` cancels the trace
coefficient:

\[
\Phi(R_2b)=\operatorname{Tr}_{E/K}
\left(Hb^2\sigma(b)\right),\qquad H=R_2R_3^2.
\]

Expanding `b=sum c_i alpha^i` and grouping by the independent `U`-monomials
gives 55 homogeneous cubic equations in `[c0:...:c4]`, with 245 total
nonzero coefficient terms over `Q(epsilon)`.

For the `R_i` family, put `N=product_i R_i`.  This is a nonzero invariant in
`K`, so multiplication by `N` preserves the zero identity and may be moved
through the trace.  The exact denominator-clearing identity is

\[
N\Phi(a)=\operatorname{Tr}_{E/K}
\left(R_0R_1R_3^2R_4\,a^2\sigma(a)\right).
\]

Indeed, `N*(R3/R2)=R0*R1*R3^2*R4`.  Substitution of
`a=sum c_i R_i` gives 99 homogeneous cubic equations with 3444 total terms.
This explains the repeated `R3` in the producer: it is required by the exact
cleared coefficient, not an extra normalization.

## Projective-emptiness certificates

Both coefficient schemes are reduced at two split good primes of
`Z[epsilon]`:

| family | prime | image of `epsilon` | nonzero equations | charts `c_j=1` |
|---|---:|---:|---:|---|
| Kummer | 11 | 3 | 52 | all five unit ideals |
| Kummer | 31 | 2 | 55 | all five unit ideals |
| `R_i` | 11 | 3 | 99 | all five unit ideals |
| `R_i` | 31 | 2 | 99 | all five unit ideals |

For each chart, Singular computes a standard basis `G_j` after substituting
`c_j=1` and verifies `reduce(1,G_j)=0`, equivalently `1` belongs to the chart
ideal.  Every geometric projective point has at least one nonzero coordinate,
so these five charts prove projective emptiness over the algebraic closure of
the residue field.

The equations define projective schemes over the cyclotomic integer base.  If
the characteristic-zero generic fibre were nonempty, properness would force
its closure to meet every good special fibre (after extending a valuation if
needed).  Hence either empty special fibre already proves characteristic-zero
emptiness.  The primes 11 and 31 are independent exact replays; the theorem
does not require combining them heuristically.

## Hash binding

The standalone verifier reconstructs the cyclotomic arithmetic, both complete
coefficient systems, and all four Singular programs.  It checks the four
authoritative `H_11_5_TWIST` source hashes before doing so.

```text
producer search_constant_five_kummer.py
  fd76b6f315a60086bac5ac3ee2ed507d02a276eba6b8d54968f75f29ab8f3325
verifier verify.py
  51ac27c78d4eded4221f29b3a7a6a402c26c0350cb6f54a3271d839967b8e803
constant_kummer_p11.sing
  afff727b049e03693c7dfab89f0997b60e28feb4b1d76cac722fd0411f47707b
constant_kummer_p31.sing
  30da719303760722eb9cd13ec59e6c0653897db7d764f600b4c8736dedb04e41
constant_r_basis_p11.sing
  338b49fec4b37b66d3e93d6bf914d796cc1224ed97d7550f129771ff902c0529
constant_r_basis_p31.sing
  67cf365ec5f620ea4c7e509e954a0f3a3e590e313802a6de07922381908c9433
```

The older `constant_five_kummer_p*.sing` files are byte-for-byte duplicates of
the canonical `constant_kummer_p*.sing` files and are also checked by the
verifier.

## Strict scope

Proved:

- no nonzero `C`-constant vector in all five normalized Kummer coordinates;
- no nonzero `C`-constant vector in all five `R_i` coordinates;
- projective emptiness independently modulo 11 and modulo 31 for both
  coefficient schemes.

Not proved:

- exclusion of vectors with coefficients in `K=C(U1,U2,U3,U4)`;
- exclusion of arbitrary rational functions, larger Laurent families, or
  other structured ansatzes;
- a valuation obstruction, generic pointlessness, or either binary headline
  for Problem E.

Thus this is a complete theorem for two five-parameter **constant** families,
not a pointlessness theorem for the ambient generic trace cubic.
