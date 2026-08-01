# Requirement-by-requirement audit

| Goal requirement | Evidence | Verdict |
|---|---|---|
| Work isolated from other agents | `WORK_SCOPE.md`; all post-collision files are under this uniquely named directory | proved |
| Exact restriction bridge | `BRIDGE.md`, section `BR-SUBGROUP-NEG` | proved |
| Exact generic torsor and generic freeness | `BRIDGE.md`; projective-kernel checks in `verify.py` | proved for A5, A4, and 11:5 |
| Treat both maximal A5 classes separately | `twists.json`; disjoint conjugacy orbits of sizes 11 and 11 independently recomputed | proved |
| Restrict exact five-dimensional Klein representation | concrete `rho(h)` subgroup elements in `twists.json` | proved |
| Exact Hilbert--90 frame | degree-zero frame formula plus nonzero characteristic-zero determinants | proved |
| Exact twisted Klein equation | `F(A_H(y)z)=0`, invariant coefficient proof, and full good-reduction coefficient payload | proved |
| Invariant/quotient field | exact invariant fields `C(P(V))^H` specified | proved |
| H-A valuation obstruction | no certified obstruction | not achieved; no claim made |
| H-B fixed-locus screen | exact upstream census replayed; D10/D12 contained lines reconstructed | proved at stated fixed-line scope; no global obstruction |
| H-C index computation | `INDEX_AND_VALUATIONS.md`, `index_valuation.json`, independent subgroup replay | index exactly one for all selected groups |
| H-D direct exact point search | full A4 projective polynomial covariant landing schemes through degree four, for all three character multipliers | proved only through degree four; no point found |
| Secondary 11:5 twist | exact P4 generic torsor, frame, equation, index one | proved; rational point undecided |
| Secondary A4 twist | exact P2 generic torsor, frame, equation, index one | proved; rational point undecided |
| Secondary D10 and D12 | stable contained subrepresentation lines twist to P1 | soluble for every torsor |
| Do not identify A5 classes | separate records and nonconjugacy verification | satisfied |
| Do not equate index one with a point | explicit warnings in status and payload | satisfied |
| No special-twist substitution | genuine generic projective torsors used | satisfied |
| No auxiliary-model bridge gap | equation is directly the twist of the original Klein cubic | satisfied |
| Characteristic-zero transfer for modular work | determinant lifting and proper projective emptiness arguments stated | satisfied |
| No Magma dependency | Python/SymPy and existing exact Weil certificate only | satisfied |
| One directory per selected subgroup | six named subgroup directories | satisfied |
| Producer, independent verifier, payload, seal | `produce.py`, `a4_direct_search.py`, `verify.py`, JSON payloads, `SEAL.json` | satisfied after seal replay |

## Terminal conclusion

The negative mission is not achieved: no selected generic twist is proved
pointless.  The exact work-order exit is therefore `H-SWEEP-UNDECIDED`.
The smallest unresolved theorem is whether the installed (A_4)-twist has a
rational point; degree five is only the next polynomial-covariant gate, not
the whole theorem.
