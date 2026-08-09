# Deep dives: the top five nonredundant actions

The first four entries are closed in this packet. The fifth is the
highest-value audited near-miss from a pre-existing open birational action.

## 1. Six-fiber odd-dihedral conic-bundle surface

### A. Action

Let

\[
S_3=\{UV=(X^6+Z^6)W^2\}\subset
\mathbf P_{\mathbf P^1}(\mathcal O\oplus\mathcal O(3)\oplus\mathcal O(3)).
\]

Let `r[X:Z]=[zeta_3 X:Z]`, `s[X:Z]=[Z:X]`, and let the induced
linearizations act identically on the two `O(3)` summands. Let
`delta(W,U,V)=(W,V,U)`. Then

\[
G=C_2(\delta)\times D_6\simeq C_2\times S_3.
\]

### B. Subgroup configuration

Use the central involution `delta`; its centralizer is all of `G`.

### C. Fixed loci

\[
S_3^\delta=C:\ y^2=x^6+1,
\]

a smooth genus-2 curve. The residual `D_6`-action is

\[
r(x,y)=(\zeta_3x,y),\qquad
s(x,y)=(x^{-1},x^{-3}y).
\]

It has no common fixed point, so `S_3^G=emptyset`.

### D. Obstruction test

- central fixed locus has no rational curve: **PROVED**;
- deeper fixed locus is empty: **PROVED**;
- Condition (A): **PROVED**, by rotation and reflection witnesses;
- UT and all higher Amitsur groups: **ZERO**, by the Sylow
  restriction--corestriction audit;
- Bogomolov multiplier: **ZERO**, since every subgroup is
  cyclic-by-abelian.

### E. Theorem

Corollary T3.1 of `theory/FIX_T_gate.md` applies. Hence `S_3` is not
weakly `G`-versal and not `G`-unirational. See
`THEOREM_DIHEDRAL_DEJONQUIERES.md` and `TOP_CANDIDATE_PROOF.md`.

## 2. Rational conic-bundle threefold with a ruled fixed divisor

### A. Action

Take

\[
X_3=\mathbf P^1\times S_3
\]

with the action above on `S_3` and the trivial action on the first factor.
This is a rational threefold and a conic bundle over
`P^1 x P^1`.

### B. Subgroup configuration

Again use `delta in Z(G)`.

### C. Fixed loci

\[
X_3^\delta=\mathbf P^1\times C,
\]

where `g(C)=2`. This is a ruled surface containing a one-parameter family
of rational curves. Its residual quotient is the projection to `C`.

### D. Obstruction test

The original no-rational-curve hypothesis **FAILS**. The refined hypothesis
holds: any irreducible RCC subvariety of `P^1 x C` maps to a point of `C`,
and a `G`-stable one would give a `D_6`-fixed point of `C`, which does not
exist. Also `X_3^G=emptyset`.

### E. Theorem

Theorem G1, or Corollary G3, proves that `X_3` is not weakly `G`-versal.
This is the cleanest example in which a central fixed divisor contains
rational curves but none can be the residual-stable RCC image selected from
a linear source.

## 3. Fermat degree-two del Pezzo with Geiser times `S_3`

### A. Action

\[
S_F=\{w^2=x^4+y^4+z^4\}\subset\mathbf P(2,1,1,1),
\]

with `tau(w,x,y,z)=(-w,x,y,z)` and coordinate permutations by `S_3`.
Thus `G_F=C_2(tau) x S_3`.

### B. Subgroup configuration

Use the central Geiser involution `tau`.

### C. Fixed loci

\[
S_F^\tau=B_F=\{x^4+y^4+z^4=0\}\subset\mathbf P^2,
\]

a smooth genus-3 plane quartic. The only common projective eigenline for all coordinate permutations
is represented by `[1:1:1]`, which is not on `B_F`; hence
`S_F^{G_F}=emptyset`.

### D. Obstruction test

- no rational curve in `B_F`: **PROVED**;
- deeper fixed locus empty: **PROVED**;
- Condition (A): **PROVED**. A transposition fixes the branch section
  `x=y`; a 3-cycle fixes the two branch eigenpoints
  `[1:omega:omega^2]` and `[1:omega^2:omega]`;
- UT and every higher Amitsur group: **ZERO**;
- `B_0(H)=0` for every subgroup: **PROVED** by cyclic-by-abelian
  structure.

### E. Theorem

The central theorem applies. `S_F` is not weakly `G_F`-versal and not
`G_F`-unirational. This gives another degree-2 theorem not explained by
the published quaternionic `Am^3` obstruction.

## 4. Rational index-one Fano product

### A. Action

Take

\[
Y_F=\mathbf P^1\times S_F
\]

with `G_F` acting trivially on the first factor. Since
`-K_{Y_F}=2H+(-K_{S_F})` and `-K_{S_F}` is primitive, `Y_F` is a smooth
rational Fano threefold of index one.

### B. Subgroup configuration

Use the central Geiser involution `tau`.

### C. Fixed loci

\[
Y_F^\tau=\mathbf P^1\times B_F.
\]

It contains rational rulings but has MRC base `B_F` with no `S_3`-fixed
point.

### D. Obstruction test

The old central hypothesis **FAILS** because of the rulings. Theorem G1
holds by projection to `B_F`; the deeper fixed locus is empty.

### E. Theorem

`Y_F` is not weakly `G_F`-versal. This is an index-one Fano application of
the residual-RCC theorem. It is deliberately not advertised as a prime
Picard-rank-one analogue of `V_14`.

## 5. Burkhardt quartic with `C_3 rtimes C_4`: audited near-miss

### A. Action

Use the Burkhardt model

\[
X_B=\{y_1(y_1^3+y_2^3+y_3^3+y_4^3+y_5^3)
      +3y_2y_3y_4y_5=0\}\subset\mathbf P^4
\]

and the subgroup `G=<sigma_3,sigma_4> ~= C_3 rtimes C_4` given explicitly
in Section 7 of Cheltsov--Tschinkel--Zhang. Its linearizability is one of
the four cases left open there. This does not by itself make
`G`-unirationality open-confirmed, so the status remains
**PARTIALLY-COVERED**.

### B. Subgroup configuration

The center is generated by `z=sigma_4^2`.

### C. Fixed loci

On the positive `z`-eigenspace, substitution into the Burkhardt equation
gives

\[
D:\ a^4+2ab^3+2ac^3+3q^2b^2c^2=0,\qquad q^2+q+1=0.
\]

It has the three nodes

\[
[-q^2t^2:1:t],\qquad t^3=1.
\]

A plane quartic has arithmetic genus 3, so these three ordinary nodes make
its normalization rational. The negative eigenspace contributes two
points.

### D. Obstruction test

The central/residual-RCC hypothesis **FAILS**: the fixed curve `D` is a
rational, `G`-stable possible RCC carrier. Thus the attractive central
involution does not yield a theorem. In a separate coordinate-transposition
lane, an anti-invariant point lies on `X_B` and is fixed by the relevant
centralizer, so the deeper-fixed-locus hypothesis fails there as well.

### E. Conclusion

No non-`G`-unirationality theorem is claimed. A successful Burkhardt
application would need a different conjugacy class or an incidence-network
argument controlling the rational fixed curve. See `BURKHARDT_AUDIT.md`.
