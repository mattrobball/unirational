/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.AbstractTargetHeadline
public import V14Formalization.V14D12CertificateExclusion
public import V14Formalization.V14FixedRationalConstancy
public import V14Formalization.SchemeModelAliases

/-!
# The coordinate V14 satisfies the abstract target interface

`AbstractTargetHeadline` asks a target for three things.  This file supplies
them for `V14SchemeModel.actionOver`, and nothing else: every line below is a
one-line reference to work that already existed.

| interface item | supplied by | where the content lives |
|---|---|---|
| `IsProper Y.V.hom` | `v14_isProper` | `V14SchemeModel.actionOver` is a closed subscheme of `ℙ¹⁴_k` |
| `TargetHypothesisA` | `v14_targetHypothesisA` | `V14FixedRationalConstancy` (elliptic-constancy plus branch, binary-quadratic minus branch) |
| `TargetHypothesisB` | `v14_targetHypothesisB` | `V14D12FixedPointExclusion` + `D12CertificateK` — the checked four-piece matrix certificate |

Hypothesis (b) is where the certificate corpus is load-bearing, and it stays
load-bearing: `v14_targetHypothesisB` is literally
`no_centralizer_fixed_section_of_certificate` applied to
`D12CertificateK.certificate`.
-/

noncomputable section

open CategoryTheory
open scoped AlgebraicGeometry

namespace V14Formalization.SchemeGeometry

open AlgebraicGeometry BConicBundleMultisections GeometricV14Carrier

/-- **Interface item 1.**  The coordinate V14 is proper over `Spec k`: it is a
closed subscheme of `ℙ¹⁴_k`, and `ℙ¹⁴_k` is proper.

Kept as a theorem rather than an instance so that it is applied only where the
abstract theorem asks for it. -/
public theorem v14_isProper : IsProper V14SchemeModel.actionOver.V.hom := by
  change IsProper
    (V14SchemeModel.v14Schemeι ≫ ProjectiveSpace.toSpec 14 V14SchemeModel.k)
  infer_instance

/-- **Interface item 2 — hypothesis (a).**  Every rational map over `Spec k`
from a biprojective space to `V14^σ` is constant.  This is
`rationalMapIsConstantOver_v14FixedBy`, repackaged. -/
public theorem v14_targetHypothesisA :
    TargetHypothesisA V14SchemeModel.k V14SchemeModel.actionOver sigma :=
  fun p q z hz => rationalMapIsConstantOver_v14FixedBy p q z hz

/-- **Interface item 3 — hypothesis (b).**  `V14^{D₁₂}(k) = ∅`.  This is the
checked four-piece matrix certificate of `D12CertificateK`, applied through
`no_centralizer_fixed_section_of_certificate`. -/
public theorem v14_targetHypothesisB :
    TargetHypothesisB V14SchemeModel.k V14SchemeModel.actionOver sigma :=
  no_centralizer_fixed_section_of_certificate D12CertificateK.certificate
    D12CertificateK.certificate_P D12CertificateK.certificate_R
    D12CertificateK.certificate_F

end V14Formalization.SchemeGeometry
