# Degree-25 marked-elliptic extension — status

**Repository base:** `091d4f5d4314c556da96d1804c49be13f48a78c8` (`main`, 2026-08-09)  
**Primary exit:** `DEGREE25-BOUNDARY-EXTENSION-OBSTRUCTED`  
**Scoped positive sub-result:** `DEGREE25-BOUNDARY-MAP-PASS`  
**Problem E headline:** **OPEN**

## Decision

Let

\[
D=\left(\bigcup_{t\text{ involution}}E_t\ \cup
        \bigcup_{t\text{ involution}}L_t\right)_{\mathrm{red}}\subset X.
\]

The component maps

\[
\lambda_D|_{E_t}=[-5],\qquad \lambda_D|_{L_t}=\mathrm{id}
\]

are intrinsically defined, agree scheme-theoretically at every type-I and
type-II incidence, and glue to a genuine `G`-equivariant morphism

\[
\lambda_D:D\longrightarrow X.
\]

The proposed ambient extension theorem is false. There are two nested exact
obstructions.

1. **Literal morphism obstruction.** A degree-`d` homogeneous tuple defining
   `lambda_D` at every point of `D` would require a nowhere-zero section of
   $\mathcal O_D(d)\otimes\lambda_D^*\mathcal O_X(-1)$. Its restrictions have degrees
   `3(d-25)` on every elliptic and `d-1` on every line. Hence the elliptics
   force `d=25`, while the identity lines force `d=1`. No degree works.
2. **Landing obstruction, even after allowing boundary base points.** Every
   homogeneous `G`-equivariant polynomial tuple `p` with `F(p)=0` vanishes
   identically on every involution plus-space `W_+(t)`. Therefore it has zero
   ordinary restriction to every `E_t`, whereas the canonical `[-5]` datum is
   nonzero of ordinary order zero. This survives primitive reduction and
   invariant scalar multiplication.

At degree 25 the exact equivariant ambient source has dimension 189 and the
complete reduced-network target has invariant dimension 41. The canonical
elliptic datum is nevertheless outside the restriction of the **landing**
locus already at order zero. The nonzero elliptic coordinate class
`[beta_t]` modulo the zero landing-restriction image is the minimal obstruction
certificate, so no larger coefficient search is relevant to this construction.

## Existing degree-25 tower

The stored `(m,d)=(1,25)` tower starts with zero ordinary restriction on each
plus-plane and studies the first odd normal jet. It does not encode the
nonzero order-zero map $[-5]:E_t\to E_t$. Its surviving formal state is
therefore **unrelated** to this boundary morphism, except for the numerical
coincidence `d=25` and a possible terminal source-line coefficient.

## Theorem boundary

Proved here:

- intrinsic origin-independence and full residual-`S3` equivariance;
- global `G`-transport;
- reduced, scheme-theoretic gluing at all fixed-curve incidences;
- the exact polarization identity `[-5]^*O_E(1)=O_E(25)`;
- the two obstruction theorems above;
- exact source/target invariant dimensions and the order-zero comparison with
  the existing lifting tower.

Not proved or claimed:

- emptiness of the full degree-25 landing-covariant scheme;
- non-unirationality of the Klein cubic;
- `ed_C(PSL(2,11))=4`;
- any all-degree negative result beyond this exact boundary prescription.
