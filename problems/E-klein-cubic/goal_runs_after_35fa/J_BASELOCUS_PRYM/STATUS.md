J2-UNRESTRICTED-COUNTERMODEL-EXTENDS

# Goal J2 status

Overall Problem E headline: **OPEN**.

The base-locus-constrained Albanese/Prym route is decided negatively at its
stated resolution-invariant scope.  Conditional on the existence of any
primitive homogeneous landing covariant \(p:\mathbf P(W)\dashrightarrow X\),
there is an equivariant log resolution of its actual five-form base ideal
which contains a Prym-bearing positive-genus curve centre.

The point is forced by the installed local theorem.  For every involution
\(t\), the plus-plane

\[
P_t=\mathbf P(E_+(t))\simeq\mathbf P^2
\]

is a base component of odd order \(m\).  A plane model of a curve carrying
both the cubic Prym factor and the fixed elliptic factor may therefore be
inserted inside \(P_t\), separated equivariantly from its translates, and
blown up before principalizing the remaining transform of the same ideal.
The covariant, its degree, its primitive minimality, and all equations
\(F(p)=0\) are unchanged.

## Exact theorem boundary

Proved in this packet:

1. every hypothetical primitive landing covariant admits such a refined
   equivariant resolution;
2. the centre has stabilizer \(C_2\), orbit size \(330\), and exactly six
   components fixed by the chosen involution, forming the regular residual
   \(S_3\)-set;
3. its normal eigenranks are \((1,2)\), and its exceptional multiplicity is
   the same odd generic plane order \(m\);
4. its blowup contribution contains a split copy of
   \(H^3(X,\mathbf Q)(1)\), with the exact averaging scalar \(198\), the
   CM \(-11\) factor, and the polarization up to positive rational scalar;
5. its fixed-centre system has an \(S_3\)-equivariant quotient carrying the
   order-three affine Albanese class of \(E_t\);
6. centre one-motives are consequently not invariant under changing the
   equivariant resolution.

Not proved:

- existence or nonexistence of a landing covariant;
- that a canonical maximum-order or otherwise minimal principalization
  selects this curve;
- an integral principally polarized Prym summand forced by a dominant
  relative-dimension-one map.

Thus this is not `J2-HEADLINE-NEGATIVE` and not
`J2-BASELOCUS-PRYM-OBSTRUCTION`.  A future obstruction would first need a
canonical resolution invariant coupled to the five coefficients, rather
than data of freely refinable centres.

## Replay

From this directory:

```bash
python3 produce.py
python3 verify.py
python3 make_seal.py
python3 verify.py
```

Expected terminal markers:

```text
J_BASELOCUS_PRYM_PRODUCE_OK
J_BASELOCUS_PRYM_VERIFY_OK
J_BASELOCUS_PRYM_SEAL_OK
J_BASELOCUS_PRYM_VERIFY_OK
```
