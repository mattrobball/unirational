# FIX-IX-SEAL — director-run seal of the Cor IX.1 hypotheses on the V14

Charge (user, 2026-08-06): "Seal that problem." Bring the two
hypotheses of the centralizer obstruction (Note IX §5) and the
ambient identification to packet grade, independent of the
in-flight FIX-IX-V14MODEL worker (whose directory is untouched).

Items: (a) `V14^sigma` = smooth irreducible genus-1 sextic + 2
reduced points — exact, two primes, char 0, with SMOOTHNESS
explicit (arithmetic-genus trap); (b) `V14^{D12}` = empty in all
four D12-character pieces — exact, two primes, char 0; ambient
V14 smooth, pure dim 3, degree 14 — char 0 via the dual
Pfaffian-adjoint system; `C_G(sigma) = D12` on the explicit
660-group; the isolated sigma-points carry stabilizer exactly C6
and are swapped by D12; `Lambda^2 U = 5 + 10'` and the dual
Pfaffian cubic is the Klein cubic (E38 uniqueness).

Layers: `scripts/seal.py` (python, modes 397/199/353/K — K is the
exact cyclotomic field Q(z)/Phi11 with mod-397 shadow for
projective orders); generated `scripts/m2_*.m2` (Macaulay2,
second engine); `verifier.py` (fresh prime 353 end-to-end +
independent trace-sum identification of 10' + cross-log check).

Exit: FIX-IX-SEAL-PASS / FIX-IX-SEAL-DEVIATION.
