# Sources and binding inputs

## Primary literature

1. A. Kuznetsov, *Derived categories of cubic and V14 threefolds*,
   arXiv:math/0303037.  Propositions 2.11 and 2.15 and Theorem 2.17 give the
   two small resolutions of the Palatini quartic.  Proposition 3.23 contains
   the line-bundle transform `y=4e-x` used to distinguish degrees `0,...,4`.

2. F. Flamini and E. Sernesi, *The curve of lines on a prime Fano threefold of
   genus 8*, arXiv:0811.0523.  In their general-Palatini setting, Proposition
   3.8 proves that the kernel-line map is a closed embedding and a component
   of the line scheme, of degree 24; Remark 3.12 gives the five-component
   description.  We use the latter only as a component inventory.  The special
   Klein component statement is instead proved directly from the regular-net
   small resolution and its trivial fibre normal bundle.

3. Yu. Tschinkel and Zh. Zhang, *Stable equivariant birationalities of cubic
   and degree 14 Fano threefolds*, arXiv:2409.08392, diagram (3.2) and
   Proposition 3.3.  This supplies the equivariance needed for twisting.

The available text extraction of the Flamini--Sernesi display is ambiguous
about a factor of two.  The Pfaffian cofactor formula gives
`h^*O_Gr(1)=O_Y(2)=-K_Y`, and its degree is 24.  The exact script independently
verifies that all Pluecker coordinates are quadratic, so the ambiguous
extraction is not used.

## Binding repository inputs consumed read-only

* `../SCHUR_CONIC_CURVES/THEOREM.md`;
* `../SCHUR_QUARTIC_MODULI/THEOREM.md`;
* `../../tmp/pfaffian_representation_alignment/core.py`;
* `../../tmp/pfaffian_representation_alignment/certificate.json`.

The certificate is the sealed exact `15 x 5` intertwiner over
`Q(zeta_11)`.  The scripts in this packet do not recompute it or search for a
different Pfaffian presentation.
