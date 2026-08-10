# Integral Ext and exterior-power audit for the cyclotomic self-isogeny

**Date:** 2026-08-08  
**Status:** `EXACT FINITE-INVARIANT NO-GO / ed_K(A)=4 OPEN`

Let

```text
Gamma=<gamma | gamma^5=1>,       Lambda=Z[Gamma],
I=(gamma-1)Lambda=Z[zeta_5],     M=F_11(9),
alpha=zeta_5^3-zeta_5^2-zeta_5-1.
```

The packet `TWISTED_KERNEL_CYCLOTOMIC` proves

```text
0 -> I --alpha--> I -> M -> 0,                         (0.1)
det(alpha)=11,       SNF(alpha)=(1,1,1,11).
```

This note computes all integral Yoneda groups in which (0.1), or an
exterior power of its rank-four lattice, could give the sought fourth
parameter.  The answer is negative: (0.1) is the unique degree-one class,
all higher Ext groups vanish, and the top exterior residue has the wrong
descent character.

The computation is forced and finite.  It uses only the four roots of
`Phi_5` modulo eleven and the already proved Smith form; it is not a search
over covariants, degrees, supports, or Fano models.

## 1. A general equivariant Ext formula

Let `N` be any torsion-free `Gamma`-lattice.  Then

```text
Hom_Lambda(M,N)=0,

Ext^1_Lambda(M,N)
  = ((N/11N) tensor_F11 M^vee)^Gamma,                    (1.1)

Ext^n_Lambda(M,N)=0                    for every n>=2.   (1.2)
```

Indeed, apply the equivariant-Ext spectral sequence

```text
H^p(Gamma, Ext^q_Z(M,N)) => Ext^(p+q)_Lambda(M,N).       (1.3)
```

Since `N` is torsion-free,

```text
Hom_Z(M,N)=0,
Ext^1_Z(M,N)=N/11N,
Ext^q_Z(M,N)=0                         for q>=2.          (1.4)
```

The action on `Ext^1_Z(M,N)` is the action on `N/11N`
twisted by `M^vee`.  This is an `F_11`-vector space.  Multiplication by
`|Gamma|=5` is invertible on it, so

```text
H^p(Gamma,(N/11N) tensor M^vee)=0       for p>0.         (1.5)
```

Equations (1.1)--(1.2) follow.  In particular, there is no hidden
degree-two, degree-three, or degree-four Yoneda obstruction behind the
rank-four presentation.

## 2. Exact table for the exterior powers of `I`

Modulo eleven, `Phi_5` splits with four distinct roots

```text
{3,4,5,9} subset F_11.                                  (2.1)
```

Thus these are the four eigencharacters of `gamma` on `I/11I`.  Since
`gamma` acts on `M` by `9`, it acts on `M^vee` by `5`.  Formula (1.1)
selects the `9`-eigenspace of `N/11N`.

Taking `N=exterior^q I` gives the complete table

| `q` | eigencharacters on `exterior^q(I/11I)` | multiplicity of `9` | `Ext^1_Lambda(M,exterior^q I)` |
|---:|---|---:|---|
| 0 | `1` | 0 | `0` |
| 1 | `3,4,5,9` | 1 | `F_11` |
| 2 | `1,1,3,4,5,9` | 1 | `F_11` |
| 3 | `3,4,5,9` | 1 | `F_11` |
| 4 | `1` | 0 | `0` |

Together with (1.2), this says

```text
Ext^n_Lambda(M,exterior^q I)=0
for every n>=2 and every 0<=q<=4,                        (2.2)

Ext^1_Lambda(M,exterior^4 I)=0.                          (2.3)
```

The class of (0.1) is the nonzero generator for `q=1`.  It cannot split:
any map from the finite group `M` to the torsion-free group `I` is zero.
Since the group in question is one-dimensional, this also proves that
(0.1) is the unique nonzero integral extension class up to scalar.

The degree-three occurrence is genuine, but it is not a fourth-parameter
obstruction.  It is consistent with the already proved threefold boundary:
the Klein cubic is precisely a nonlinear dimension-three survivor.

## 3. Exterior cokernels of the actual map `alpha`

The Smith form `(1,1,1,11)` determines every exterior Smith form.  Put

```text
Q_q=coker(exterior^q(alpha):exterior^q I -> exterior^q I).
```

Then `Q_q` is killed by eleven and has dimension

```text
dim_F11 Q_q = binomial(3,q-1),             1<=q<=4.       (3.1)
```

Modulo eleven, `alpha` vanishes precisely on the `9`-eigenline and is a
unit on the other three eigenlines.  Hence `Q_q` is spanned by the wedges
which contain that `9`-eigenline.  Its exact character table is

| `q` | `dim Q_q` | `Gamma`-characters of `Q_q` |
|---:|---:|---|
| 1 | 1 | `9` |
| 2 | 3 | `1,3,5` |
| 3 | 3 | `3,4,9` |
| 4 | 1 | `1` |

In particular,

```text
Q_1 = M,
M occurs once in Q_3,
M does not occur in Q_2 or Q_4.                           (3.2)
```

At the top exterior power,

```text
exterior^4(alpha)=det(alpha)=11,
Q_4=F_11(1).                                              (3.3)
```

Thus the tempting determinant residue is nonzero but **split**: it has
trivial `C5` character.  There is no equivariant map

```text
M=F_11(9) -> Q_4=F_11(1),                                (3.4)
```

and (2.3) says that it cannot be repaired by an integral extension class.
The determinant `11` therefore cannot be promoted to the missing
mixed-prime codimension-four obstruction.

## 4. Stable lattice data also cannot distinguish the cover

Multiplication by `alpha` identifies the kernel lattice `J=alpha I` with
`I` as an integral `Gamma`-lattice.  Consequently source and target tori
have identical:

```text
rational representation,
Tate-cohomology tables,
flabby/coflabby and stable-permutation classes,
ordinary birational torus invariants.                    (4.1)
```

This is stronger than equality after tensoring with `Q`: the lattices are
actually isomorphic over `Z[Gamma]`.  The only datum not forgotten by
(4.1) is the embedding `alpha I subset I`, equivalently the unique
extension (0.1).  Sections 1--3 show that its ordinary Yoneda/exterior
characteristic tower stops before exterior degree four.

There is an exact Tate-cohomology strengthening.  Each `Q_q` in Section 3
is an eleven-primary `Gamma`-module.  Since `|Gamma|=5` is invertible on
`Q_q`,

```text
Tate H^n(Gamma,Q_q)=0                    for every n.      (4.2)
```

The long exact Tate sequence for

```text
0 -> exterior^q I --exterior^q(alpha)--> exterior^q I
  -> Q_q -> 0
```

therefore shows that

```text
exterior^q(alpha):Tate H^n(Gamma,exterior^q I)
                    -> Tate H^n(Gamma,exterior^q I)
is an isomorphism for all n and q.                        (4.3)
```

For `q=1` this is visible without any formalism:

```text
Tate H^(odd)(Gamma,I)=I/(gamma-1)I=Z/5,
Tate H^(even)(Gamma,I)=0,
alpha(1)=-2=3 mod 5.                                     (4.4)
```

Thus `alpha` acts by the unit `3` on the only nonzero Tate group.  The
isogeny is equally invisible to every exterior Tate-cohomology table, not
just to the abstract isomorphism class of its endpoint lattices.

## 5. The mod-eleven group-cohomology route also vanishes

There is a parallel finite calculation for ordinary group-cohomology
characteristic classes.  Over a splitting field,

```text
H^*(B C11,F_11)=F_11[v] tensor exterior(u),
deg(u)=1,       deg(v)=2,       v=beta(u).                 (5.1)
```

An automorphism of `C11` by an order-five multiplier acts by the same
order-five scalar on `u` and `v`.  Hence a monomial `u^epsilon v^a` is
invariant only when

```text
a+epsilon=0 mod 5.                                       (5.2)
```

The first positive invariant monomials are therefore

```text
u v^4 in degree 9,          v^5 in degree 10.             (5.3)
```

In particular, the geometric invariant ring has no positive class in
degrees one through eight, so it has no candidate degree-four class.

More strongly, these first classes do not evaluate on the torsors at hand.
The constant field `C` contains `mu_121`.  Every Kummer `C11`-torsor
therefore lifts to a `C121`-torsor, so its Kummer Bockstein `v=beta(u)` is
zero.  Every positive invariant in (5.2) contains `v`: the only monomial
without it is `u`, which is not invariant under the order-five descent.
Thus all classes in the descended mod-eleven group-cohomology subring
evaluate to zero after the degree-five splitting extension.  Restriction is
injective on eleven-primary classes, because corestriction followed by
restriction is multiplication by five.  They therefore already evaluate to
zero over the original field on the versal self-isogeny.

For coefficient primes different from eleven, positive group cohomology of
`C11` vanishes because eleven is invertible.  Consequently ordinary
single-prime group-cohomology characteristic classes provide no mixed
`5`--`11` obstruction here.  This is the group-cohomological counterpart
of the Tate calculation (4.2)--(4.4); it makes no assertion about a new,
genuinely mixed-prime nonlinear invariant.

## 6. Consequence and strict boundary

This calculation refutes the following proposed route:

```text
det(alpha)=11 plus the rank-four cyclotomic lattice
  => a nonzero degree-four equivariant exterior/Yoneda class
  => ed_K(A)>=4.
```

The first implication is false.  The top residue is `F_11(1)`, while the
torsor kernel is `F_11(9)`, and every possible higher Yoneda correction
vanishes.

This does **not** construct a three-dimensional compression.  It proves
that any proof of `ed_K(A)=4` must use information outside the integral
lattice extension and its ordinary exterior/Yoneda operations—for example
a genuinely nonlinear birational invariant of the self-isogeny or a
theorem excluding all surviving terminal Fano descents.

```text
CYCLOTOMIC-EXT1-UNIQUE-NONZERO
CYCLOTOMIC-HIGHER-EXT-ALL-ZERO
CYCLOTOMIC-TOP-EXTERIOR-RESIDUE-TRIVIAL-CHARACTER
CYCLOTOMIC-EXTERIOR-TATE-MAPS-ALL-ISOMORPHISMS
CYCLOTOMIC-MOD11-GROUP-COHOMOLOGY-EVALUATION-ZERO
CYCLOTOMIC-LATTICE-EXTERIOR-ed4-ROUTE-EMPTY
ordinary-ed_K(A)=4                                  OPEN
Klein-PSL2(F11)-NO                                  OPEN
```
