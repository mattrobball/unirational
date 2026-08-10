# Contracted positive-genus geometry: an exact model

## 1. Construction

Let `C` be a smooth projective curve of genus `g>0`, and let `L` be a sufficiently
ample line bundle.  Let

\[
S=\operatorname{Cone}_{L}(C)
\]

be the projective cone.  Its standard resolution is the ruled surface

\[
\tau:T=\mathbf P_C(\mathcal O_C\oplus L^{-1})\longrightarrow S.
\]

The negative section

\[
E\simeq C
\]

is contracted to the vertex, and `tau` is an isomorphism away from `E`.

This is an exact algebraic contraction.  It is not asserted to be the local
model of a Klein landing ideal; it is the mandatory abstract test of any
proposed ordinary-Albanese descent theorem.

## 2. Ordinary \(H^1\) is destroyed

The projection `T→C` is a `P1`-bundle, so

\[
H^1(T,\mathbf Q)\simeq H^1(C,\mathbf Q).
\tag{2.1}
\]

Topologically, `S` is the quotient of `T` obtained by collapsing `E` to a
point.  Hence

\[
\widetilde H_k(S,\mathbf Q)
\simeq H_k(T,E;\mathbf Q).
\]

The long exact sequence of the pair contains

\[
H_1(E)\longrightarrow H_1(T)
\longrightarrow H_1(T,E)
\longrightarrow H_0(E)\longrightarrow H_0(T).
\]

The first and last displayed maps are isomorphisms: `E` is a section of the
ruled surface and both spaces are connected.  Therefore

\[
H_1(S,\mathbf Q)=0,
\qquad
H^1(S,\mathbf Q)=0,
\qquad
\operatorname{Alb}(S)=0.
\tag{2.2}
\]

The positive-genus center has disappeared completely from ordinary Albanese
data on its contracted image.

## 3. Intersection cohomology retains the factor

The resolution `tau` is semismall.  The decomposition theorem has the form

\[
R\tau_*\mathbf Q_T[2]
\simeq
IC_S\oplus \mathcal T_0,
\tag{3.1}
\]

where `T_0` is a point-supported Tate summand determined by the exceptional
intersection form.  A point-supported perverse summand contributes nothing to
cohomological degree one.  Consequently

\[
IH^1(S,\mathbf Q)
\simeq H^1(T,\mathbf Q)
\simeq H^1(C,\mathbf Q).
\tag{3.2}
\]

Thus the Hodge structure survives canonically in intersection cohomology even
though it is invisible to `Alb(S)`.

## 4. Consequence for the ambient theorem

This model refutes each unconditional implication

```text
positive-genus resolution center
    => positive irregularity of its image,
```

```text
H^1(center) descends through the contraction,
```

and

```text
residue-field inclusion forces an Albanese factor on the center image.
```

The strongest surviving invariant is the strict-support intersection-complex
summand, exactly as used in `AMBIENT_SUPPORT.md`.

The example does not refute the ambient intersection-cohomology support
theorem.  It demonstrates why that theorem cannot generally be weakened to an
ordinary subvariety or ordinary Albanese statement.
