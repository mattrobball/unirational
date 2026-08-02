# G3H phase 2 — cubic compression

Marker: `G3H-CUBIC-COMPRESSION-PASS`

For each maximal \(A_5\) class, with \(W\) the rational five-dimensional
augmentation module and \(U_i\) the icosahedral three-dimensional module
(or its Galois conjugate \(3'\) for class 2),

\[
\dim\operatorname{Hom}_{A_5}(\operatorname{Sym}^3 W, U_i)=1.
\]

The unique (up to scalar) equivariant cubic \(Y_i:W\to U_i\) is computed by
exact linear algebra over \(\mathbf Q(\sqrt5)\), normalized so the first
nonzero coefficient equals \(1\), and checked by:

1. full formal equivariance on all 60 group elements;
2. a nonzero \(3\times 3\) Jacobian minor at an explicit rational point.

Character theory independently predicts the Hom-dimension one for both \(3\)
and \(3'\). Coefficient tables: `Y_class_1.json`, `Y_class_2.json`.
