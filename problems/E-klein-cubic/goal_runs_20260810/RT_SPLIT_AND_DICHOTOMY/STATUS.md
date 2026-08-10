# RT split, restricted dichotomy, and support-escape closure

Parent main head: `4b057ac4ed05027e1307409e7821094f74279581`.
Branch: `agent/rt-split-dichotomy-20260810`.

Problem E remains **OPEN**.

## Exits

```text
RESTRICTED-DICHOTOMY-PROVED
RESTRICTED-CARRIER-BRANCH-PROVED
RESTRICTED-CLEAN-CM-NORM-PROVED
CLEAN-CASE-TRANSFER-UNDECIDED
POINT-SUPPORT-CHARACTERIZED
SUPPORT-ESCAPE-UNDECIDED
SXX-LOCAL-REES-UNDECIDED
```

## One-line ledger

- **Task 1:** the canonical middle-cohomology projector `e0=pi^*pi_*` gives an intrinsic CARRIER/CLEAN split; in CLEAN the exceptional correction is zero and `u_phi^dagger u_phi=[delta]`. The strict-support decomposition is canonical per perverse cohomology; no canonical splitting of the whole derived object is claimed.
- **CM sieve:** `End_{G-HS}(V)=Q(sqrt(-11))`, the integral scalar order is `Z[(1+sqrt(-11))/2]`, and CLEAN degrees are `x^2+xy+3y^2`. Degrees 1, 3, 5 and norm 25 pass; degree 2 fails and is independently excluded. The full selfmap degree ledger has no mismatch.
- **Task 2:** Artin vanishing proves injectivity into the raw derived base change for `S not subset X`, `j0>=0`, but an iterated normalized-blowup model refutes the proposed automatic direct CT1 incidence; normalization does not supply CT3.
- **Task 3:** refined Bezout kills only free surfaces at ambient degrees 22--25 (retraction degrees 24--25). Free curves, free points, and free surfaces from degree 26 survive. Point support is characterized by a weight-three fiber-IC Hodge block and the stabilizer Hom condition.
- **Task 4:** the rank-two generic local ideal normalizes to `(F,h^m)`, while rank one needs all higher minors. Rees data do not determine the IC gluing map; ambient restriction is governed by `psi_F`, not `psi_h` alone.

## Task 5 precedence

Fixed-carrier/type-I/type-II enumeration was not resumed. If Tasks 2 and 4 are later closed, the target is exclusion of the **actual landing data** on the known genus-four/Prym/Fano carriers: source and target degree, monodromy, base multiplicity, conductor correction, and compatibility across all 55 configurations. A blanket assertion `Hom_H(V,H^1(C))=0` is false and is not used.

## Exact replay

```text
python3 verify_norm_sieve.py
python3 verify_degree_accounting.py
python3 verify_local_rees.py
```

Expected final markers:

```text
FULL_G_SELFMAP_DEGREE_LEDGER_COMPATIBLE_OK
FREE_SURFACE_CELL_SURVIVES_FROM_D26_OK
PRIMITIVE_RESTRICTION_REMOVES_H_POWER_OK
```
