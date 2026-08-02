# G3D.0 — simple field model for `K_proj`

## Choice of primitive element

eta = f7 = b_1 (secondary basis element of degree 7).

## Left multiplication and minimal polynomial

L_eta is the 12x12 matrix of left multiplication by eta on the G3A secondary basis over P0 = QQ(t3,t6,t8,t11). The monic minimal polynomial is m_eta(T) = det(T I - L_eta) in P0[T].

## Degree 12

The power-basis matrix P has constant integer denominators only. Good specializations:

- t = [2, 3, 5, 7]: det P = 213752879502447493766016134679190872521926430584781635389873247045324600784332233725110764325948443794378843211801034752/25
- t = [3, 5, 7, 11]: det P = -35892342118272314957270184866351911069364620368118620011284585465884464924592360058977119504132906437798022592675148633004412070591769608192/18225
- t = [5, 2, 3, 1]: det P = -52165330378376427437461060468553914267692220603322510431370292508511573952821593376689872880329274966967538127643979578272378763963323421712622474342068045980224165097223749632/5147278302366225
- t = [4, 1, 1, 2]: det P = -1701567010645112722638663094418165468596595328840741799059655283875015597120729123261869676643000736129773565826540180801093237061796039979568606857734699096161124352/5147278302366225

Hence det P is not identically zero, and on the principal open det P != 0 the set {1, eta, ..., eta^11} is a P0-basis. Thus [P0(eta):P0] = 12 and deg m_eta = 12.

## Two-way maps

- Power to secondary: sum c_k * (column k of P).
- Secondary to power: P^{-1} * secondary_vector on det P != 0.
- Multiplication: convert to secondary, apply the certified 78 structure constants (field_api.multiply), convert back.

Trace, norm, and inversion are delegated to field_api on the secondary model and transported by P.

## Marker

```text
G3D-K-SIMPLE-MODEL-PASS
```

This is an arithmetic interface, not a headline exit.
