# Del Pezzo surfaces of degrees 1 and 2

## 1. Degree two: exact new theorem

The Fermat surface

\[
S_F=\{w^2=x^4+y^4+z^4\},
\quad G_F=C_2(\text{Geiser})\times S_3
\]

is treated in `THEOREM_FERMAT_DP2_S3.md`.

This action has:

- Condition (A): pass;
- fixed curve of the central Geiser involution: the genus-three Fermat
  quartic;
- deeper fixed locus: empty;
- fixed points for every Sylow subgroup;
- universal-torsor and all higher Amitsur obstructions: zero;
- verdict: not weakly `G_F`-versal.

Tschinkel--Zhang's current negative degree-two cases with Condition (A)
contain `Q_8` and are detected by nonzero `Am^3`. The `C_2 x S_3` theorem
is outside that mechanism.

## 2. A general Geiser-central recipe

Let

\[
S_B=\{w^2=F_4(x,y,z)\}
\]

be a degree-two del Pezzo surface, let `tau` be Geiser, and let
`H<=Aut(B)` preserve the smooth branch quartic `B={F_4=0}`. For
`G=<tau> x H`, the central theorem applies whenever:

1. `B^H=emptyset`;
2. every abelian subgroup `A<=H` fixes a point of `B`.

Indeed, any abelian subgroup of `G` can be enlarged by `tau`, forcing its
fixed point onto `B`, while `S_B^G=B^H`.

The Fermat `H=S_3` case is the smallest verified instance. This recipe
suggests a finite follow-up scan through the classified automorphism groups
of smooth plane quartics, but the scan must be by conjugacy class of the
action, not abstract group type.

## 3. Is there another Problem-F exceptional path?

No second action was certified in this packet. The Problem-F proof needs
much more than a positive-genus involution curve:

- a source arrangement with forced distinct endpoint values;
- nonabelian birth stabilizers with scalar tangent involutions;
- `V_4`-stable exceptional paths;
- target fixed curves incapable of carrying rational components.

The Fermat `C_2 x S_3` action closes before this machinery is needed. It
shows Problem F is not isolated as a negative degree-two phenomenon, but it
does not show that the exceptional-path mechanism itself occurs in a
family.

The best next path-specific search is among `G`-minimal degree-two actions
with no central element satisfying the simple theorem, especially groups
with several `V_4` and `D_8` stabilizers and vanishing `Am^3`.

## 4. Degree one

Every automorphism of a degree-one del Pezzo preserves the unique base
point of `|-K|`; hence every finite group has a global fixed point. This
immediately kills the simple central theorem's deeper-fixed-locus
hypothesis. In particular, the central Bertini involution is not an easy
analogue of Geiser: its positive-genus fixed curve comes with a globally
fixed base point.

The current cohomological invariants also vanish for every subgroup. Thus
degree one remains genuinely interesting, but the next theorem must use
incidence or exceptional paths rather than a one-stratum central funnel.

Potential configurations to inspect are:

- Bertini fixed curve plus the anticanonical base point under a residual
  nonabelian stabilizer;
- chains born over the base point whose endpoint values are forced to the
  Bertini curve and to a different fixed section;
- special degree-one surfaces with large automorphism groups in the
  Dolgachev--Iskovskikh tables.

No exact action was found for which all endpoint hypotheses could be proved
without a new surface calculation.

**Status:** `LITERATURE-STATUS-UNCERTAIN`; no theorem claimed.
