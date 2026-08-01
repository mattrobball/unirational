# Primary decomposition and Sylow detection

## 1. General theorem

Let `G` be finite, let `M` be a cohomological Mackey functor, and let
`x in M(G)` be killed by `|G|`.  Decompose `x=sum_p x_p` into its
primary components.  If `P_p` is a Sylow `p`-subgroup and

\[
\operatorname{res}^{G}_{P_p}(x_p)=0,
\]

then `x_p=0`.

Indeed, the cohomological Mackey identity gives

\[
[G:P_p]x_p
=\operatorname{cor}^{G}_{P_p}
 \operatorname{res}^{G}_{P_p}(x_p)=0.            \tag{1.1}
\]

The index `[G:P_p]` is prime to `p`, so multiplication by it is an
automorphism of the `p`-primary group containing `x_p`.  Therefore
`x_p=0`.  Applying this to every prime divisor of `|G|` gives `x=0`.

No semisimplicity or localization theorem is used; this is an integral
restriction--corestriction argument.

## 2. Exact data for `PSL(2,11)`

For

\[
G=\operatorname{PSL}_2(\mathbf F_{11}),\qquad |G|=660,
\]

the Sylow orders and indices are:

| `p` | `|P_p|` | `[G:P_p]` | inverse on the maximal `p`-part |
|---:|---:|---:|---:|
| 2 | 4 | 165 | `165 = 1 mod 4` |
| 3 | 3 | 220 | `220 = 1 mod 3` |
| 5 | 5 | 132 | `3*132 = 1 mod 5` |
| 11 | 11 | 60 | `9*60 = 1 mod 11` |

The same four indices are the installed degrees of zero-cycles on every
twist.  Their gcd is one, with certificate

\[
-13\cdot60+3\cdot132+165+220=1.                 \tag{2.1}
\]

## 3. Application to the Klein cubic

The Klein cubic `X` has a fixed point for every Sylow subgroup:

\[
X^{P_2}\ne\varnothing,\quad
X^{P_3}\ne\varnothing,\quad
X^{P_5}\ne\varnothing,\quad
X^{P_{11}}\ne\varnothing.                       \tag{3.1}
\]

Let `o_G(X)` be an additive Mackey-valued point obstruction as defined in
`INVARIANT_DEFINITION.md`.  For its `p`-primary component `o_p`, restriction
naturality and fixed-point normalization give

\[
\operatorname{res}^{G}_{P_p}(o_p)
=o_{P_p}(X)=0.
\]

The theorem of section 1 yields `o_p=0` for every `p`, hence

\[
\boxed{o_G(X)=0.}                                \tag{3.2}
\]

In torsor language, every `P_p`-twist has a point supplied by the fixed point.
The restriction of the invariant along `P_p -> G`, evaluated on the generic
`P_p`-torsor and extension of its structure group to `G`, therefore vanishes.
The same transfer argument kills the global primary component.  No
restriction of a `G`-torsor to a `P_p`-torsor over the same field is asserted.

## 4. Consequences for the candidate directions

### Integral cohomology and equivariant Chow

Positive-degree `H^*(BG,Z)` and positive-codimension `CH^*(BG)` are killed by
`|G|`: restriction to the trivial subgroup is zero in positive degree, while
corestriction followed by restriction multiplies by `|G|`.  Their obstruction
parts therefore split and are Sylow-detected exactly as above.

### Finite coefficients and power operations

An additive operation with `p`-primary output stays in the `p`-primary
summand.  It cannot glue a nonzero class to a different prime.  Products of
different primary torsion classes vanish.

### Extension data

Extensions of finite abelian coefficient groups also decompose by prime.
Calling such an extension "mixed-prime" does not evade (2.3).  Nonadditive
descent data would evade the theorem, but no functorial point obstruction of
that kind is supplied by the audited sources.

## 5. Relation to versality

Duncan--Reichstein's `p`-versality theorems explain the geometric side of the
same calculation: a Sylow fixed point makes the smooth proper action
`p`-versal.  Their local-to-global versality conjecture would imply full
versality for this Klein action, but it is a conjecture, not a bridge available
to Goal D2.  Prime-local essential dimension therefore cannot decide the
global mixed-prime question.
