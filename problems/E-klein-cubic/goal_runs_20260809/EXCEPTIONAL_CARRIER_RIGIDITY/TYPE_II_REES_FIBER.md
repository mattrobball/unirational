# Type-II normalized-Rees fiber

## 1. Incident directions

At a type-II `V4` point `x`, the three incident source branches are elliptic:
\[
E_z,
\qquad E_s,
\qquad E_r,
\]
with tangent characters `chi_z`, `chi_s`, `chi_r`.  The residual
\[
N_G(V_4)/V_4\simeq C_3
\]
cycles the three branches and character directions.

The first point blowup again has
\[
D=\mathbf P(\chi_z\oplus\chi_s\oplus\chi_r).
\]

## 2. Ordinary elliptic carriers

For each of the three elliptic branches, the forced plus-plane base component
and accepted parity theorem give a canonical ordinary carrier whose target is
the corresponding rational fixed line:
\[
K_{E_z}\to L_z,
\qquad
K_{E_s}\to L_s,
\qquad
K_{E_r}\to L_r.
\]
Each carrier has dimension one or two.  In the curve case it is birational to
the original elliptic curve; in the surface case it is birational to the
ordinary ruled exceptional surface and factors through a target curve.

This is the principal structural change from the abstract reduced network: the
canonical integrated ordinary branches at a type-II point are line-valued, not
three elliptic selfmaps meeting at one target point.

## 3. Point-centered components

For every irreducible component `T` of the normalized point fiber,
\[
\dim T=\dim q(T).
\]
Hence:

- a point-centered line-valued component is a curve;
- a point-centered Rees divisor maps to a surface and has faithful generic
  `V4` action;
- no point-centered Rees divisor can be fixed by one of `z,s,r`.

A fixed curve may nevertheless occur inside a stable surface component, and a
faithful `V4` curve may occur as its own point-fiber component.  Neither is
classified by Rees valuations alone.

## 4. Residual-`C3` coupling

The residual `C3` action transports every component and every incidence.
Consequently:

1. a bypass of one elliptic branch occurs with its two conjugates unless the
   component itself is `C3`-stable;
2. dimensions and map degrees are equal on a three-element component orbit;
3. a `C3`-stable curve may carry a higher-degree action not visible in the
   first character directions;
4. the three ordinary elliptic endpoints cannot be selected independently.

This is genuine coupling, but it is not uniqueness.  The normalized fiber may
contain several `C3`-orbits of curves and stable surfaces.

## 5. Connectivity boundary

The total normalized fiber is connected.  The landing-horizontal fixed
subsets for `z`, `s`, and `r` can each be disconnected, and their union can be
connected only through faithful components.  Therefore none of the following
is proved:

- one elliptic branch cannot be bypassed;
- the fixed carrier incidence graph is connected;
- the incidence graph is a tree;
- the relevant complex is simply connected.

Using connectedness of the total exceptional fiber in place of one of these
statements would repeat the error identified in the accepted classification
packet.

## 6. Faithful conic test

The weak conic model in `LOCAL_REES_MODEL.md` proves that a faithful invariant
conic in the first `P2`, even with a generically nondegenerate weak-transform
matrix, need not survive as a Rees divisor.  It contracts to a line-valued
curve because the target residue field has dimension one.

This does not exclude a faithful `V4` curve component of the actual normalized
point fiber.  Such a curve would map finitely to a faithful `V4`-stable target
curve in `X`, and its existence is an explicit part of the missing local
normalization problem.

## 7. Smallest missing type-II proposition

For the actual completed tuple, prove a `C3`-equivariant decomposition of the
normalized point fiber into:

1. curve components and their finite target maps;
2. surface Rees components and their surface target maps;
3. fixed curve slices for each involution;
4. attachment loci of the three ordinary elliptic carriers.

The proposition must decide whether any one branch endpoint can be omitted from
the landing-horizontal fixed subcomplex.  No current formal transition module
contains this normalization data.
