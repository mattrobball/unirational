# Goal H — obstruct a proper-subgroup generic twist

**Repository:** `mattrobball/unirational`  
**Pinned mathematical baseline:** `715faf441289e2589b9325311b6613ea0331bf88`  
**Problem:** PSL\((2,11)\)-unirationality of the Klein cubic threefold  
**Worker role:** autonomous theorem/CAS worker in goal mode  
**Priority tier:** serious independent negative route  
**Permitted headline direction:** negative  
**Current headline:** **OPEN**

## 0. Mission

Find a subgroup \(H\le G=\operatorname{PSL}_2(\mathbf F_{11})\) for which the generic \(H\)-twist of the Klein cubic is pointless. By the accepted restriction principle `BR-SUBGROUP-NEG`, this disproves \(G\)-unirationality.

The first targets are the two conjugacy classes of maximal \(A_5\) subgroups. If both fail, continue through a proved priority list of maximal/proper subgroups, including \(11{:}5\), \(D_{12}\), \(A_4\), and \(D_{10}\), only where the generic torsor and twist are explicitly manageable.

## 1. Exact bridge

Before computation, prove and record:

\[
X\text{ \(G\)-unirational}
\Longrightarrow
X\text{ \(H\)-unirational for every }H\le G
\Longrightarrow
X_{	au_H}(K_H)\ne\varnothing
\]

for the chosen versal/generic \(H\)-torsor \(	au_H\). Therefore

\[
X_{	au_H}(K_H)=\varnothing
\]

for one \(H\) gives the negative headline.

Specify the exact generic torsor, base field, faithfulness/generic freeness, and the specialization/versal theorem used. A pointless auxiliary model without a birational or point-equivalence bridge to the twisted Klein cubic is insufficient.

## 2. Primary route: the two maximal \(A_5\) classes

For each maximal \(A_5\) conjugacy class:

1. choose the faithful three-dimensional \(A_5\)-representation and construct the generic torsor over
   \[
   K_{A_5}=\mathbf C(\mathbf P^2)^{A_5};
   \]
2. restrict the exact five-dimensional Klein representation to this \(A_5\);
3. compute an exact Hilbert-90 frame and write the twisted Klein cubic over \(K_{A_5}\);
4. verify the two maximal classes separately rather than assuming their restrictions are equivalent;
5. compute the invariant ring/quotient field, discriminant divisors, fixed schemes, zero-cycles, and local valuation models.

The lower transcendence degree and simpler subgroup representation are the expected advantage over the full \(G\)-twist.

## 3. Pointlessness attacks

Run several independent exact screens, each with a complete bridge.

### H-A — divisorial valuation/index obstruction

Enumerate natural invariant divisors of the \(A_5\) quotient and compute the reduction of the twisted cubic at their henselian valuations. Seek a residue cubic or torsor with index \(3\), no degree-prime-to-three zero-cycle, or another exact obstruction that survives to the generic field.

Prove residue degrees, ramification indices, and properness/valuative implications exactly.

### H-B — fixed-locus and normalizer obstruction

Compute the complete stabilizer/fixed-locus census for the restricted \(A_5\)-action and test the exact OD16/Fermat-style image obstruction. If normal exits remain, construct the subgroup version of the normal-cone machine far enough to decide whether a genuine contradiction occurs.

Do not infer a contradiction from the abstract non-rational-connectedness of one target component when a normal exceptional direction can exit to another component.

### H-C — explicit zero-cycle/index computation

Determine the index of the generic twist using all natural subgroup orbits and Hilbert schemes. If index is \(>1\), pointlessness follows. If index is one, record explicit coprime-degree cycles and move to a stronger obstruction rather than equating index one with a point.

### H-D — direct exact point search

A rational point refutes that subgroup as a negative route but may provide a positive construction or a simpler parametrization. Any point must be checked in the original twisted equation and descended to \(K_H\).

## 4. Secondary subgroup sweep

If both \(A_5\) classes are soluble or remain intractable, rank remaining subgroups by:

- transcendence degree and explicitness of a versal representation;
- simplicity of \(W|_H\);
- fixed-locus geometry;
- availability of a residue/index obstruction;
- whether \(H\)-unirationality is already forced by known low-dimensional versal varieties.

Prioritize maximal \(11{:}5\), \(D_{12}\), and \(A_4\). Avoid spending time on a subgroup whose generic twist is immediately shown rational or whose essential dimension makes the obstruction impossible for formal reasons.

## 5. Exits

### Headline success

```text
H-SUBGROUP-TWIST-POINTLESS-HEADLINE-NEGATIVE
```

Required: exact subgroup/torsor, exact twisted Klein equation, pointlessness theorem, and `BR-SUBGROUP-NEG` verification.

### Subgroup soluble

```text
H-SUBGROUP-SOLUBLE
```

Record the exact point and whether it has any positive consequence for \(G\).

### All selected subgroups survive

```text
H-SWEEP-UNDECIDED
```

Give a theorem-backed ranking of remaining subgroups and the smallest unresolved twist.

## 6. Prohibitions

1. Do not identify the two \(A_5\) classes without exact conjugacy/representation comparison.
2. Index one is not a rational point.
3. A special twist is not the generic twist without a versal specialization argument.
4. A pointless auxiliary Fano/Pfaffian model is not enough without point-equivalence.
5. Every modular claim requires a characteristic-zero transfer.
6. No Magma dependency.

## 7. Output contract

Write only under

```text
problems/E-klein-cubic/goal_runs/H_SUBGROUP_TWISTS/
```

Provide `STATUS.md`, `BRIDGE.md`, one directory per subgroup class, exact twist equations, valuation/index payloads, independent verifiers, and `SEAL.json`.