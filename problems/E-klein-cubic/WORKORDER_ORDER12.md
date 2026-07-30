# Problem E — work order: the order-twelve gate (second Fable gate)

Issued 2026-07-29 on acceptance of the foothold packet (first-gate Koszul
theorem sealed; xCD plane-section route refuted and retired).  Director-derived
plan; the worker executes and seals.

## Standing state (do not re-derive)

- `tmp/fable_first_gate_koszul/` + `_audit/`: there is a sufficiently high
  twist `d` and a nonzero compatible class
  `sigma in H0(~(I^(3)/I^(5))(d) (x) W)^G` carrying the transported projective
  Fable trisection at every one of the 165 plane–line flags, with
  `F(sigma) = 0 mod I^(11)`.  The Koszul ansatz per involution plus-plane is
  `p3 = q*R`, `p4 = iota_{Gamma_R}(eta)`; `q,R` carry the extendable `D12`
  reflection-sign character, `eta` is invariant.
- `tmp/fable_d12_rees_sigma_interface/`: old D10/D12 points are dead as an
  obstruction source under the arbitrary-high-factor policy (Theorem 3.1
  invariant point-killer `H`, `ord_p(H) >= 660`); the raw defect lives in
  `B_desc`.  The nonautomatic equation is NOT an old-point equation: it lives
  on the genuine `Q=0` sections of the resolved centre-line geometry.
- On a genuine `Q=0` section, in the constrained chart, with the saturated
  upper equation `alpha*y - B*beta*z = Q*h` imposed, the first post-boundary
  order-twelve residue is a nonzero unit times `B*beta - 2*z*h`  (interface
  eq. (14)).  Witness of nonautomaticity: `beta=y^3, h=0` gives
  `-c*y^12*(B^6-1) != 0`.  Local solution family: `beta = 2*z*q`, `h = B*q`
  for an arbitrary local scalar `q`, with the certified companion `v4`
  solving the preceding lower covector (interface eq. (15)); `q=0` allowed.
- Odd orders nine and eleven are automatic: the doubled `Q^2` layer has no
  `A4`- or induced `G`-invariants, so invariant defects are `Q^2`-divisible
  (`tmp/fable_constrained_cokernel/`, `tmp/fable_d12_char0_bridge/`).
- The even order-ten/twelve fixed-factor quotient is a rank-one invariant
  residue sheaf along each centre line, not one global scalar; the `D10`
  orbit avoids the centre lines and the three `D12` points per line give a
  finite elementary modification only.

## Target

Prove the second gate:

> There exist a sufficiently high twist `d`, an admissible first-gate class
> `sigma` (Koszul ansatz, free data `R_P, q_P, eta_P, S_L`, high factors
> `H^N`), and a correction
> `e in H0(~(I^(5)/I^(7))(d) (x) W)^G`, such that
>
> `F(sigma + e) = 0` in `H0(~(I^(11)/I^(13))(3d))^G`,
>
> with the same generic projective trisection at every triple line.

Equivalently: kill the class of `F(sigma)` in the even order-twelve residue
sheaf using the section freedoms, then absorb the remainder through the
canonical correction map `I^(5)/I^(7) -> I^(11)/I^(13)`,
`e |-> 3*Phi(p,p,e)` (RESOLUTION item 4, eq. (24)).  Note orders: `e` has
normal order 5, so `3*Phi(p,p,e)` has orders `3+3+5=11` and `3+4+5=12`; both
land inside the target modulus.  A trisection-preserving change of `sigma`
by `I^(5)` moves the cubic first at order `2*3+5=11`, so all freedoms act on
exactly the gate being solved.

## Worked plan

1. **Construct the residue sheaf globally.**  On one representative centre,
   write the rank-one invariant order-twelve residue sheaf on the six genuine
   `Q=0` sections explicitly, with its exact stabilizer linearization
   (extend the flag character calculation of the first-gate audit; the
   verifier there already pins the `D12` reflection-sign extension).  Then
   transport by `G` to all centres.  Deliverable: the sheaf, its
   linearization, and the identification of the residue of `F(sigma)` as an
   invariant section of it.
2. **Solve the residue equation section-by-section.**  The local family
   `beta = 2*z*q, h = B*q` shows the solution set on each section is an
   affine space (torsor) under local scalars `q`.  So the simultaneous
   equivariant solution exists iff a coherent obstruction class vanishes:
   compute the difference cocycle of local solutions as a class in
   `H^1` of the twisting line bundle on the section configuration (six
   sections per centre; finite `D12` modifications; centre-to-centre by
   equivariance).  Use the same three tools that closed the first gate:
   (a) equivariant Serre vanishing at sufficiently high common twist for the
   `H^1` of the relevant isotypic component; (b) Reynolds projection in
   characteristic zero onto the correct character (solutions form an
   invariant affine subspace once the linearization from step 1 is right —
   do NOT average naively; project with the character projectors);
   (c) the invariant point-killer `H^N` to zero out finite overlap/`D12`
   conditions without touching generic trisections.
3. **Check compatibility at section intersections and with `B_desc`.**  The
   prescribed `q` choices must agree in the finite thickened rings where
   sections meet (same discipline as the first gate's thickened
   common-factor lemma — division must hold in the actual branch-thickening
   rings, not just on reduced sections).  Record what is transferred to
   `B_desc` and verify nothing needed later is silently colon-killed.
4. **Absorb the remainder by the canonical correction.**  After step 2 the
   order-twelve class of `F(sigma)` is zero on the genuine `Q=0` sections;
   show the leftover (if any) lies in the image of
   `e |-> 3*Phi(p,p,e)` — this needs only exactness/surjectivity onto the
   relevant finite invariant subquotient, not full surjectivity.  Conclude
   `F(sigma + e) = 0 mod I^(13)`.
5. **Seal.**  Packet `tmp/fable_second_gate_order12/` with REPORT.md,
   PROOF_AUDIT.md, certificate.json, verify.py (marker
   `FABLE_SECOND_GATE_ORDER12_OK`), plus an independent audit packet
   `tmp/fable_second_gate_order12_audit/`.  The verifier must check: the
   explicit residue-sheaf linearization; the local solution family and its
   companion `v4`; the exact character/projector bookkeeping; the finite
   thickened-ring divisibility; the order ledger (11/12 modulo 13); and the
   strict boundary.  Hash-bind all upstream packets.  IMPORTANT: compute
   certificate self-hashes only after the final byte of every sealed file is
   written — the foothold packet raced its own hash ledger and failed replay
   until the write-out settled.

## Obstruction protocol

If a genuine invariant obstruction survives every freedom (the `q` per
section, `v4` companions, `H^N`, `S_L`, and the correction map), then STOP
and certify it exactly: exhibit the nonzero invariant class in the explicit
finite subquotient, independent of all admissible choices, with an exact
witness.  That is a real theorem about the Fable branch and changes the
ranking; do not sweep around it.

## Constraints

- Stopping rule stands: no new bounded degree/support/chart/finite-state
  sweep.  Everything here is structural and all-degree; no degree is to be
  instantiated.
- Exact arithmetic only (`QQ`, cyclotomic fields, split `F_67` for cheap
  confirmation — never as the proof).
- Arbitrary-high-factor policy remains in force.
- After sealing: update HANDOFF.md (delta + ranking), RESOLUTION.md (item 4
  successor), CURRENT_PATHS.md, SPEC.md progress ledger; headline stays
  **OPEN** regardless of outcome.
- What this gate does NOT close (state it in every document): orders
  thirteen and higher, the full formal tower, unsaturated common-factor
  descent, algebraization/effectivity, dominance, and the headline.
