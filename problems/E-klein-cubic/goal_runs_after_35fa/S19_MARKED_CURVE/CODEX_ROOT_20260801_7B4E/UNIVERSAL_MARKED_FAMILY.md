# Canonical universal marked 55-point family

## Integral presentation

Work over

`Z[z,h0,h1,h2,h3,h4,Delta^-1]/(1+z+...+z^10)`.

The exact D12 projector produces 55 ordered lines `L_i=<u_i,v_i>` over the
cyclotomic ring.  The globally cleared line denominator is 22.  For the
hyperplane `h.X=0`, its point on `L_i` is represented by

`p_i(h)=(h.v_i)u_i-(h.u_i)v_i`.

Every coefficient of every `p_i` is serialized in
`universal_marked_family.json` as a 55 x 5 x 5 x 10 integral tensor.  The
point ideal is

`I_i=<p_i,a(h) X_b-p_i,b(h) X_a : 0<=a<b<=4>`,

and the marked ideal is the exact finite intersection

`I_Z=intersection_{i=0}^{54} I_i`

after localization at `Delta`.  This is a universal ideal, not an
interpolation description.

## The named good open

`Delta` contains:

- 55 line-chart factors, ensuring no selected line lies in the hyperplane;
- 1,485 explicit pair-separation minors;
- the `h4` chart factor;
- exact nonzero evaluation minors in degrees 0 through 6;
- an exact degree-five kernel-independence minor for
  `f3*S2 + <f5>`;
- one linear form nonzero on every section, used for propagation.

The finite-field witness is `z=64` and `h=(1,1,1,2,7)` over F67.  It is used
only to prove that the displayed integral determinant polynomials are
nonzero.  It is not promoted to characteristic-zero curve evidence.

On this localization the 55 sections are disjoint, hence their union is
finite free of rank 55.  The named evaluation minors give lower ranks

`1,4,10,19,31,45,55`.

The cubic, its multiples, and the independent eleven quintic kernel forms
give matching upper ranks.  Constant-rank localization therefore makes the
degree pieces locally free with exactly those ranks.  The named linear form
propagates rank 55 from degree six to every higher degree.  This is the exact
generic-freeness proof requested by S19.0.

The serialized S and T permutations verify equivariance of the labelled
family.  Twisting this presentation gives the marked family on the genuine
Schur twist; the constant witness itself is only a split nonemptiness
witness.

Replay:

```bash
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 produce_universal_marked_family.py --check
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 verify_universal_marked_family.py
```
