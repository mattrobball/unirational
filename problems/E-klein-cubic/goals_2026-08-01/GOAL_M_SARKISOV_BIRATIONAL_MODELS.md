# Goal M — equivariant Sarkisov links and birational fibration models

**Repository:** `mattrobball/unirational`  
**Pinned mathematical baseline:** `715faf441289e2589b9325311b6613ea0331bf88`  
**Problem:** PSL\((2,11)\)-unirationality of the Klein cubic threefold  
**Worker role:** autonomous birational-geometry/CAS worker in goal mode  
**Priority tier:** high-risk structural route  
**Permitted headline direction:** positive or negative  
**Current headline:** **OPEN**

## 0. Mission

Construct an exact \(G\)-equivariant or generic-twist Sarkisov link from the Klein cubic, the twisted Fano model \(F_{14,T}\), or a controlled blowup to a Mori fibre space whose rationality, section, or arithmetic obstruction decides the headline.

The original prime Fano threefold \(F_{14}\) has geometric Picard rank one, so it admits no conic bundle, del Pezzo fibration, or rational fibration **on the unmodified model**. This route must use a genuine birational modification along a Galois/\(G\)-stable centre and run the MMP; it must not restate a fibration forbidden by Picard rank one.

## 1. Binding current state

1. The Pfaffian/twisted-Fano model is related to the generic Klein twist by an accepted positive bridge when a rational point/common line exists.
2. The geometric \(F_{14}\) model has \(ho=1\); direct fibration mechanisms on that model are closed.
3. The repository identifies natural \(A_4\), \(D_{12}\), \(A_5\), \(C_{11}\), and other orbit schemes, including degree-55 and degree-60 Galois-stable cycles, but no complete Sarkisov analysis after blowing them up.
4. Odd-degree multisections do not split the relevant 2-torsion Brauer class and individual isotropy does not produce a common line.
5. Birational models obtained after modification remain genuinely open.

## 2. Exact targets

### Positive target

Produce a birational model over the correct generic field with a Mori fibration having a rational section or rational generic fibre, yielding a rational point and hence \(G\)-unirationality.

### Negative target

Prove equivariant/twisted birational rigidity strong enough that every possible \(G\)-compression or rational-point-producing Sarkisov link is excluded, and connect that rigidity theorem to non-\(G\)-unirationality. Ordinary birational rigidity of a threefold over an algebraically closed field is not automatically an obstruction to a dominant map from \(\mathbf P^4\); the bridge must be stated precisely.

## 3. Work packages

### M0 — classify admissible centres

Enumerate \(G\)-orbits and Galois-stable centres on the Klein and \(F_{14}\) models that can initiate a Sarkisov link:

- points and zero-dimensional orbit schemes;
- lines, conics, twisted cubics, and higher rational curves;
- the \(A_4/D_{12}\) marked schemes;
- fixed elliptics and other positive-genus curves where admissible;
- centres appearing on small \(\mathbf Q\)-factorial modifications.

Compute normal bundles, discrepancies, anticanonical degrees, orbit sizes, fields of definition, and whether the blowup remains terminal/\(\mathbf Q\)-factorial.

### M1 — run the two-ray game

For each viable centre:

1. construct the blowup or weighted extraction exactly;
2. compute the Picard lattice, nef/effective/movable cones, and anticanonical class;
3. identify flops and divisorial contractions;
4. run the two-ray game to all terminal Mori fibre spaces;
5. track the \(G\)-action or Galois descent throughout.

Use exact intersection theory and toric/Cox computations where possible. A link over the splitting field must be descended.

### M2 — test rationality and sections

For every resulting fibration:

- conic bundle: compute discriminant and Brauer class, seek a section or prove none;
- del Pezzo fibration: compute generic fibre index and rational points;
- genus-one fibration: compute Jacobian/torsor and section obstruction;
- rational surface fibration: prove rationality/stable rationality over the base;
- Fano-to-Fano link: compare to known versal models or explicit rational charts.

A multisection is not a section without a valid descent theorem.

### M3 — exhaustiveness or constructive exit

If a positive link is found, write explicit rational maps in both directions on dense opens and verify the resulting generic point. If claiming negative rigidity, prove that the centre list and links are exhaustive under the relevant equivariance/Galois constraints and explain why this excludes every headline-positive compression mechanism.

## 4. Exits

```text
M-SARKISOV-HEADLINE-POSITIVE
M-EQUIVARIANT-RIGIDITY-HEADLINE-NEGATIVE
M-NEW-MORI-FIBRE-STRUCTURAL
M-UNDECIDED
```

The negative exit requires a separately proved bridge from rigidity to the absence of a \(G\)-unirational map; do not infer it automatically.

## 5. Prohibitions

1. Do not propose a fibration on the unmodified \(ho=1\) model.
2. Do not treat a splitting-field link as descended without exact Galois data.
3. Do not confuse a multisection with a rational section.
4. Do not claim birational rigidity obstructs a relative-dimension-one dominant map without a theorem.
5. Every positive link must produce an exact point/map over the generic field.
6. No Magma dependency.

## 6. Output contract

Write only under

```text
problems/E-klein-cubic/goal_runs/M_SARKISOV/
```

Provide `STATUS.md`, `CENTRES.md`, `MORI_CONES.md`, one directory per link, exact map/intersection payloads, independent verifiers, and `SEAL.json`.