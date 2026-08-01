# Exact reduced criterion and remaining equation

## 1. Fields and cubic

Put

```text
F = C(A,B,Y,Z),
t = f5^3,  u = f8/f5,  v = f10*f5.
```

The payload in `payload/` installs three exact linear relations in columns
`(1,v,t)` with matrix `M` and

```text
det(M) = u * C(A,B,Y,Z) * P(A,B,Y,Z,u).
```

The primitive `P` has `u`-degree six.  On the recorded open,

```text
K_proj = F[u]/(P),
```

and the selected residue embedding is the class of `u`; `t` and `v` are the
two Cramer quotients recorded in `FIELD_PRESENTATION.md`.  This is an ordered
embedding, not merely an unordered degree-six algebra.

The fixed-frame cubic is

```text
c = F0 + A*FA + B*FB + Y*FY + (Z - 11*A^2/18)*FZ
```

in `[X:y:w]`.  All five forms are the exact cyclotomic rows in the accepted
`five_forms.json` input.

## 2. Why the affine chart `w=1` is exhaustive

Suppose a `K_proj`-point had `w=0`.  Then `y` cannot also vanish, and
`xi=X/y` satisfies the cubic-at-infinity polynomial in `F[xi]`.  Hence
`F(xi)` is an intermediate field of `K_proj/F` of degree at most three.
The accepted `S6`-primitivity says that `K_proj/F` has no proper intermediate
field, so `xi` must lie in `F`.  This would be an `F`-point of `C`, contrary
to the accepted `C(F)=empty`.  Therefore every `K_proj`-point lies on `w=1`.

## 3. Smallest exact point system

Localize at the leading coefficient of `P` and make it monic.  Write

```text
X(u) = x0 + x1*u + ... + x5*u^5,
y(u) = y0 + y1*u + ... + y5*u^5,
```

where the twelve coefficients are unknowns in `F`.  Reduce the original
fixed-frame equation in the basis `(1,u,...,u^5)`:

```text
c(X(u),y(u),1) mod P = R0 + R1*u + ... + R5*u^5.
```

The exact residual problem is

```text
R0 = R1 = ... = R5 = 0,
3*X(u)^2 + q(y(u),1) != 0 in K_proj.
```

Thus the original exact decision object is six cubics in twelve
`F`-unknowns plus one open.
Equivalently, it is the projector-open part of
`Res_{K_proj/F}(C_K_proj)(F)`.  The divisibility presentation

```text
c(X(u),y(u),1) = H(u)*P(u),  deg(H)<=9
```

is a denominator-free equivalent with ten auxiliary coefficients and sixteen
coefficient equations.

No finite specialization or bounded ansatz decides whether this `F`-scheme
has an `F`-point.  Section 5 decides it instead by an exhaustive valuation
and class-group argument.

## 4. Exact point-to-conic equivalence

Assume the point system has a solution `P0`.  The absence of intermediate
fields and `C(F)=empty` force its residue field to be all of `K_proj`.  Its
six conjugates form an `F`-rational effective divisor `D` of degree six on
`C`.  Since the accepted input gives `Pic^0(C)(F)=0`,

```text
O_C(D) = O_C(2).
```

For a plane cubic, restriction gives an isomorphism

```text
H^0(P^2,O(2)) -> H^0(C,O_C(2));
```

the kernel is `H^0(P^2,O(-1))=0`, and both sides have dimension six.  Hence
there is a unique `F`-conic cutting out `D`.  It is nondegenerate: a double
line would give a nonreduced intersection, while a rank-two conic would give
an `F`-stable block decomposition (and hence a proper subfield) of the
primitive degree-six residue algebra.

Conversely, an `F`-algebra isomorphism from a length-six conic intersection
algebra to `K_proj`, together with the selected embedding, evaluates to a
genuine `K_proj`-point of the original cubic.  This proves the bidirectional
criterion at the exact boundary used here.

## 5. Decision

`INFINITY_OBSTRUCTION.md` proves that a residue-degree-one infinity place of
`K_proj/F` has residual cubic of index three.  Proper specialization gives

```text
C(K_proj)=empty.
```

Therefore the six remainder equations plus the projector open have no
`F`-point, and the bidirectional equivalence above proves that the entire
conic-intersection criterion is empty.  The exact exit is

```text
F-CONIC-CRITERION-EMPTY
```

This is scoped fixed-frame pointlessness, not a headline theorem about the
genuine Klein twist.
