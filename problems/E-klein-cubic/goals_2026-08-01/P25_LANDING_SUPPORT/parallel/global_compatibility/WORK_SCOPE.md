# Global compatibility work scope

This directory contains only exact, low-memory tests of the complete
degree-one-syzygy contraction space.  The binding inputs are the full 10,767
linear syzygies and their six cubic contractions in
`../stageb_global_basis/`, together with the sealed 690-row lower
presentation.

The primary target is a global compatibility or irrelevant-power certificate
for the augmented row

```text
[ P4(q) | P3_0(q) | ... | P3_5(q) ].
```

Restricted-coordinate certificates are explicitly labelled as partial.  They
do not decide points having larger q-support and cannot by themselves produce
a P25 verdict.

