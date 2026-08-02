# H6.1 — trace-hyperplane degree-11 torsor

**Marker:** `H6-TORSOR-CLASS-PASS`
**Consumed:** H6A `H6-PROJECTIVE-11-ISOGENY-PASS` (not re-proved)

## Setup

Fields as in H4/H6A:

```text
E = C(r0,...,r4)/(prod r_i - 1)
sigma(r_i) = r_{i+1}
K = E^{<sigma>} = C(U1,U2,U3,U4)
```

Projective isogeny on the product-one torus:

```text
phi([a]) = [a^2 sigma(a)],   deg phi = 11
```

with dual group-ring operator `B = 5 - 3 sigma + sigma^2 - sigma^3` and
`psi_B o psi_A = [11]` on the product-one torus (machine-checked on modular
samples; lattice identity from H6A).

## Trace hyperplane and fibre product

```text
H_tr = { Tr_{E/K}(b) = 0 } subset P(E)
Y = { ([a],[b]) : [b] = [c phi(a)], Tr(b) = 0 }
```

On the dense torus open of `H_tr`, the map `Y → H_tr` is a degree-11 torsor
under `ker phi ≅ mu_11`, with `C5` acting on the kernel by multiplication by
unit `9` in `(Z/11Z)*`.

Coordinates: ambient product-one / augmentation / Fourier–R charts restricted
by the *additive* equation `Tr(b)=0`. The intersection `H_tr ∩ T` is a
hypersurface in the torus, not a subtorus.

## Kummer / resolvent invariant

For `m` on the product-one torus,

```text
psi_A(r) = m  ⇒  r^{11} = psi_B(m)
```

The class of the fibre is the class of `kappa = psi_B(m)` in `T/T^{11}`.
Geometric kernel generator uses exponents `c = (5,3,4,9,1)`; resolvent of the
kernel coordinate is `X^{11}-1` with `sigma(X)=X^9`.

On the augmentation lattice, `A_aug` has SNF diagonal `(1,1,1,11)`; the
obstruction to solving `A u = v` is measured by `B_aug v mod 11`.

## Translation by `c = r2^{-1}`

The classifying map is `[b] ↦ m = [b c^{-1}] = [b r2]`. The torsor class
therefore contains the fixed factor coming from the order-11 class of `c`
(equivalently of `r2`) in `E*/psi(E*)`, via the witness

```text
d = r1 r2^6 r3^{-2} r4^2  ⇒  psi(d) = r2^{11}
```

**Promotion forbidden:** this order-11 factor is a *term* in the torsor class,
not by itself a pointlessness obstruction (H4/H5/H6A).

## Equivalence with the genuine trace cubic

On the torus open,

```text
Y(K) nonempty  ⇔  exists nonzero a in E with Phi(a) = Tr(c a^2 sigma(a)) = 0
```

Proof sketch: `Tr` is `K`-linear, so `[b]=[c psi(a)]` lies in `H_tr` iff
`Phi(a)=0`. Boundary charts are audited separately in `BOUNDARY_AUDIT.md`.

## Machine payload

See `torsor_class.json` (dual composition samples, Kummer kernel witnesses,
`c`-class exponent check, modular specialized points for discovery only).
