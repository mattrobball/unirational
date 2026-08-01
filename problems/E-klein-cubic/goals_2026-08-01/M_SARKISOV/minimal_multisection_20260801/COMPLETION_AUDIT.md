# Requirement-level completion audit

| question | verdict | exact evidence |
|---|---|---|
| Is there a multisection smaller than degree 55? | **YES** | \(M_3=\operatorname{Spec}(K_3)\times\mathbf P^1\subset E\) has degree 3 |
| Is it an actual curve rather than a generic zero-cycle? | **YES** | \(M_3\simeq\mathbf P^1_{K_3}\) embeds in \(E=C\times B\) |
| Is it connected? | **YES** | a transverse cubic divisor on pointless \(C\) cannot have a degree-one factor |
| Is it rational? | **YES over \(K_3\), NO over \(K_0\)** | its normalization is \(\mathbf P^1_{K_3}\), so it is not geometrically integral over \(K_0\) |
| Is it an ordinary three-branch \(G\)-orbit? | **NO** | it is stable under the semilinear descent datum; \(G\) has no index-three subgroup |
| Can degree 2 be a smaller non-section alternative? | **NO** | quadratic conjugate-pair secant gives a residual \(K\)-point and section |
| Is the absolute minimum known to be 3? | **CONDITIONAL** | it is 3 if no section exists; otherwise it is 1 |
| Does this settle the headline? | **NO** | the section branch remains open |

Thus the user-facing existence question is completely answered: degree 55
is not minimal, because degree 3 exists unconditionally.  The only remaining
minimality ambiguity is exactly the pre-existing section question, with no
possible degree-two middle case.

Under the stricter convention that a "rational multisection" must itself be
\(K_0\)-rational or geometrically integral, the degree-three curve does not
qualify as rational.  It does qualify unconditionally as an integral
multisection over \(K_0\), which is the question resolved here.
