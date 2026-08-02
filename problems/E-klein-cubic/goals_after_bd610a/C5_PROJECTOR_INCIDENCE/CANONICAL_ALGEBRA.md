# Canonical exact algebra

The authoritative canonical choice is recorded with SHA-256 hashes in
`INPUT_MANIFEST.json`.

The exact basis is the rectangle

```text
r_(j,i) = b^j a^i,  0 <= j,i < 6,
```

ordered with `j` outermost.  The operations are the sealed lazy circuits

```text
multiply(x,y)      = R^(-1) vec(embed(x) embed(y)),
sigma(x)           = R^(-1) vec(Q(x0)^(-1) embed(x)^t Q(x0)),
reduced_trace(x)   = trace(embed(x)),
S_i                = R^(-1) vec(Q(x0)^(-1)Q(V_i(x0))).
```

Here `x0` denotes the generic five-dimensional source vector, not an algebra
coordinate.  `canonical_algebra.py` exposes these operations as serializable
exact Cramer-circuit nodes.  No interpolation or expanded `36^3` table is
used.

The complete lazy `compressed_algebra.json` supersedes the smaller file whose
own status is `C0-PARTIAL`; they are different versions, not conflicting
authoritative copies.  The five-plane and Morita packets consume the complete
file by its exact hash.  The 15-element symmetric basis is bound separately
from `tmp/pfaffian_rank2_idempotent_attack/certificate.json`: it uses frame
indices `0,...,13,15` and has a nonzero good-fibre minor.  The historical
namespace-mutated conjugate RUR is described but not named or retained by the
audits.  No modular RUR is consumed; the corrected tracked `p=23,zeta=4`
copies are not misclassified as the absent historical blob.

Independent historical replays, rerun for this audit, recover:

```text
sigma eigendimensions = 15/21,
rank(S_x,S_C,S_D,S_E,S_K) = 5,
dim(e_0 A e_0) = 4,
rank_D(Ae_0) = 3.
```

The canonical algebra itself passes:

```text
C5_CANONICAL_ALGEBRA_OK
```

The failure occurs at the next mathematical convention gate because the
canonical API necessarily returns `S_x=1_A`.
