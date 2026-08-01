# Requirement-level completion audit

The declared exit is `M-NEW-MORI-FIBRE-STRUCTURAL`. The goal file lists this
separately from the positive and negative headline exits, so the audit below
does not manufacture a headline verdict.

| requirement | result | evidence / exact boundary |
|---|---|---|
| genuine modification | PASS | ordinary blowup of the descended smooth plane cubic; not a fibration on an unmodified rank-one Fano |
| center invariants | PASS for the used center | `CENTRES.md`: field, \((g,d)=(1,3)\), normal bundle, discrepancy, terminality |
| classical center routing census | PASS at its stated scope | ten smooth geometrically integral weak-Fano curve types in `CENTRES.md`; not an exhaustive rigidity census |
| exact extraction and map | PASS | graph and fibre equations in `THEOREM.md` and JSON payload |
| Picard / nef / effective / movable | PASS | exact basis, ring, cones, and ray pairings in `MORI_CONES.md` |
| flops and contractions | PASS for this link | no flop; the two rays are the blowdown and degree-3 del Pezzo fibration |
| descent | PASS | covariant Hilbert--90 basis and equations over \(K_0\), audited in `DESCENT_AUDIT.md` |
| generic-fibre arithmetic | PARTIAL BY DESIGN | `ARITHMETIC.md` proves index divides 3 and records the exact section implication; no section or no-section theorem |
| positive headline exit | NOT CLAIMED | no generic point or rational section produced |
| negative headline exit | NOT CLAIMED | no exhaustive semilinear-center rigidity theorem or dominance bridge |
| structural exit | PASS | a new terminal \(K_0\)-Mori fibre model with relative Picard rank one is constructed |
| Magma-free independent replay | PASS | SymPy/Python local verifier plus exact upstream group certificate |
| sealed artifacts | PASS after `verify.py` | `SEAL.json` pins every owned file and every upstream input |

Thus the binary claim proved by this directory is:

> Goal M has a valid exact **structural** exit, while the Problem E headline
> and the new cubic-surface section problem remain open.

