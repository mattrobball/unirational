# Exact ternary attack over the certified projective invariant field

## Verdict

This packet proves one unbounded plane-section theorem and two finite-ansatz
theorems:

1. **The normalized `x,C,D` ternary plane has no
   `K_proj,C`-rational point.**  This is an unconditional theorem for that
   plane, not a bounded coefficient search.
2. On every one of the ten ternary frame planes, 110 continuous common-pencil
   ansatze and one uniform batch of ten continuous common-plane ansatze are projectively empty in
   characteristic zero.

No point on another unrestricted ternary plane was found, and the full cubic
in four or five frame coordinates remains undecided.  Nothing here proves
`V(Phi)(K_proj,C)=empty`.

## 1. Literal identification of the `x,C,D` curve

Let

```text
beta_s = b_s/tau^degree(b_s),
tau = f3^2/f5,
K_proj,QQ = QQ(t3,t6,t8,t11)(beta_0,...,beta_11).
```

The ten coefficients of the restriction of `G_ALL_DEGREE/generic_cubic.json`
to frame indices `0,1,2` are compared with the ten normalized coefficients in
`tmp/xcd_genuine_descent/kproj_e3_presentation.json`:

| xCD name | Goal-G triple |
|---|---|
| `A` | `x*x*x` |
| `A2` | `x*x*C` |
| `A3` | `x*x*D` |
| `B1` | `x*C*C` |
| `M` | `x*C*D` |
| `C1` | `x*D*D` |
| `B` | `C*C*C` |
| `B3` | `C*C*D` |
| `C2` | `C*D*D` |
| `C` | `D*D*D` |

For every row, `make_xcd_binding.py` checks literal equality as a length-12
vector of sparse polynomials in `QQ[t3,t6,t8,t11]`.  It also checks that the
upstream xCD presentation is hash-bound to the same
`normalized_kproj_table.json` and uses the same normalization

```text
tau=f3^2/f5; each degree-d invariant is divided by tau^d.
```

Thus this is not merely a similarly named `xCD` model: it is exactly the
coordinate plane

```text
V(Phi) intersect {a3=a4=0}
```

over the same field

```text
K_proj,C = K_proj,QQ tensor_QQ C.
```

`verify.py` replays the original 35-coefficient reconstruction from the Klein
form, the certified rank-12 field arithmetic, the upstream normalized xCD
bind, and the sealed general-slice theorem.  The last theorem proves, by the
`Q6:f6=0` residue and properness, that this particular curve has no
`K_proj,C`-point.  Consequently the Goal-G `x,C,D` plane has no point.

The curve is smooth.  It has no quadratic point either: the line through a
quadratic point and its conjugate is defined over the base field, and its
third intersection with a plane cubic is a base-field point, contradicting
the theorem.  This observation is still only about the `x,C,D` plane.

## 2. Exact continuous common-support ansatze

The field arithmetic has the certified basis `beta_0,...,beta_11`, with
`beta_0=1`.  For each of the ten frame triples `T`, the packet constructs the
complete coefficient identity for the following families.

### Common pencils: 110 systems

For every `s=1,...,11`, each of the three active frame coordinates is an
arbitrary element of

```text
Span_C{beta_0,beta_s}.
```

There are six independent scalar coefficients, hence a projective `P5`
parameter space for each pair `(T,s)`.  All `10*11=110` systems are empty.

### One common three-dimensional support: 10 systems

On each frame triple, every active coordinate is an arbitrary element of

```text
Span_C{beta_0,beta_1,beta_2}.
```

There are nine scalar coefficients, hence a projective `P8` parameter space.
All ten fixed-support `P8` systems are empty.  A larger exploratory support
sweep was deliberately capped; no incomplete system is retained or counted.

These are genuinely continuous families, strictly larger than choosing
signed basis atoms inside the displayed common supports.  They are still
**finite ansatze**: the scalar coefficients are constants in `C`, not
arbitrary rational functions of `t3,t6,t8,t11`, and the three active
coordinates must share one listed basis support.  This is not an
unrestricted `K_proj` search.

## 3. Exact equations and transfer from characteristic 101

For each of the 120 recorded systems, `common_pencil.py` performs arithmetic in the exact
12-dimensional multiplication table.  It substitutes the six- or
nine-variable ansatz into the relevant ten polar terms of `Phi`, expands the
result in the twelve `beta` coordinates, and then equates every coefficient
of every monomial in the four algebraically independent parameters.  The
resulting equations are homogeneous cubics over `QQ`; they are the literal
characteristic-zero coefficient equations, not evaluations at finitely many
parameter values.

The producer clears rational coefficients by reduction at the good prime
`101`.  Every denominator occurring in the reconstructed equations is a unit
in `Z_(101)`.  Linear row reduction over `F_101` preserves the generated
homogeneous ideal.  For every one of the 120 recorded systems, exact `msolve`
output gives a leading ideal containing a positive pure power of every
coefficient variable.  Thus the affine special-fibre support is only the
origin and the projective special fibre over the algebraic closure of
`F_101` is empty.

Here is the transfer direction.  Let `X` be the projective coefficient locus
over `Z_(101)` defined by the unreduced homogeneous equations after clearing
denominators.  If its geometric characteristic-zero fibre were nonempty, the
closure of a geometric generic point in the proper scheme `X` would have
closed image containing the generic point of `Spec Z_(101)`, hence would meet
the closed fibre.  The certified empty closed fibre forbids this.  Therefore
the corresponding projective ansatz locus is empty over `QQbar`, and after
base change also over `C`.

Reduction is used in this one valid direction only.  No finite-field
nonfinding and no parameter specialization is promoted to a theorem.

## 4. Remaining boundary

The `x,C,D` plane is closed completely.  The exact live alternatives are:

- a point on one of the other nine ternary frame planes with unrestricted
  `K_proj,C` coordinates;
- a point with four or five nonzero frame coordinates;
- an obstruction applying to all of `V(Phi)`.

The ten common-plane exclusions do not bound rational-function height and do
not imply pointlessness of any other full ternary curve.  No positive
candidate survived, so this packet has no coefficient vector to clear back
to a global covariant.

## Replay

From `goals_2026-08-01`:

```sh
/opt/homebrew/bin/python3 G_ALL_DEGREE/attacks/ternary_kproj_v2/make_xcd_binding.py
/opt/homebrew/bin/python3 G_ALL_DEGREE/attacks/ternary_kproj_v2/build_common_pencils.py
/opt/homebrew/bin/python3 G_ALL_DEGREE/attacks/ternary_kproj_v2/build_common_planes.py --prune
/opt/homebrew/bin/python3 -u G_ALL_DEGREE/attacks/ternary_kproj_v2/verify.py
```

Add `--rerun-solvers` to rerun all 120 exact Gröbner calculations after the
independent equation reconstruction.

The verifier ends with

```text
THEOREM Goal-G x,C,D plane has no K_proj,C-point (literal 10-coefficient bind)
CHAR0_TRANSFER projective special-fibre emptiness at p=101 => geometric QQ/C emptiness
STRICT_SCOPE xCD plane theorem plus 120 finite common-secondary ansatze; full cubic remains open
G_TERNARY_KPROJ_V2_VERIFY_OK
```
