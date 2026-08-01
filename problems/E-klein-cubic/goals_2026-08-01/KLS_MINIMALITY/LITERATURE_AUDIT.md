# Primary-literature audit

Checked 2026-08-01.  This is a scope audit, not a claim that a literature
search proves nonexistence of a theorem.

## Sources checked

- Spicer--Tasin, *Rank one foliations on toroidal varieties*,
  <https://arxiv.org/abs/2604.08100>.  Its main construction assumes the
  rank-one foliation is log canonical.  It produces an lc ambient divisor
  linearly equivalent to the foliation canonical class; it does not prove
  log canonicity of the KLS foliation, identify that divisor with `V(h)`, or
  bound conductor pullback support.
- Cascini--Liu--Spicer--Svaldi, *Birational boundedness of stable families*,
  <https://arxiv.org/abs/2604.24106>.  Its foliated boundedness statement
  assumes bounded adjoint volume.  In the KLS ledger, supplying that bound
  would already require control of the unknown foliation degree and still
  would not bound the residual adjugate degree.
- Trushin, *Contracted divisors and Degree-Two Maps*,
  <https://arxiv.org/abs/2605.26390>.  Its classification concerns dominant
  polynomial self-maps of equal-dimensional affine spaces and its sharper
  conclusions concern generically finite degree-two maps.  A KLS map has
  image dimension four from a five-dimensional source and is not in that
  setting.
- Cheltsov--Tschinkel--Zhang, *Equivariant unirationality of Fano
  threefolds*, <https://arxiv.org/abs/2502.19598>, checked as the current
  surrounding status source.  It does not supply a KLS
  minimality-to-conductor theorem.

## Decision

No checked primary source supplies either load-bearing missing assertion:

1. minimality forces positive discrepancies for all extracted KLS gcd
   valuations; or
2. minimality bounds the total reduced support above conductor primes.

The repository's use of these papers is therefore at the correct limited
scope.  None licenses a finite conductor classification or an all-degree
negative conclusion.
