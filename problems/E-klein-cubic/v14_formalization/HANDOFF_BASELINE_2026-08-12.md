# Faithful V14 handoff baseline

This file identifies the source snapshot audited while writing
`WORK_ORDERS_2026-08-12.md`.  Hash mismatch after an intentional edit is not a
failure; record the before/after hashes in `COMPLETION_STATUS_2026-08-12.md`.

## Environment

- Repository: `/Users/worker/unirational/problems/E-klein-cubic/v14_formalization`
- Git HEAD: `deaafa5ad5cc2b913c7d55e7ca2e9398e0da2a2c`
- Lean: `4.32.1`, commit `f054605aea4b840552cca2e725580bffd1e1b704`
- Lake: `5.0.0-src+f054605`
- Mathlib revision: `v4.32.1`
- Problem B revision: `746c781234c412e1000f8c57d3be9212e756beea`

The worktree contains many user-owned modifications and untracked files.  The
critical new formalization modules listed below were untracked at the snapshot.
Do not infer that untracked means disposable.

Handoff document hashes at final validation:

```text
a353fb1d73a30e41093ee6535115b6d18ee3dafc29ab41e061afb7c121781bde  HANDOFF_2026-08-12.md
90e35de308bf12f4f47a5e29a719fdf4e7893587f0e0542322e65e934c26f158  WORK_ORDERS_2026-08-12.md
f63be757ec8b25e8f7d16bfec5b176cecaa13fc3a301bdc16fc6d2eacc7ae9ac  COMPLETION_STATUS_2026-08-12.md
3e6dbd14986dea4f62d067edd19586f8704ad12c233df7c66712adbfe3073e0b  handoff_artifacts/2026-08-12/README.md
```

## Critical source hashes

```text
d5b599b927b6141197d361c83214da962e09141f254a5b2fb749b3f087ea32ec  lakefile.toml
8e3538e0ab5f81a3ee04927d8838c8c674e0e112838b4b3ce87ec218143276af  lean-toolchain
6d340e12916376cf7b77616adf59e6a31f9a48f92a792cb1134dcab3ad519be2  V14Formalization.lean
a6e248063af113186532d714774ef5d073e1a78cb5ac6c0dcc2783e9781e45d1  V14Formalization/TrustGuard.lean
5b752648674ec18e6a42bbcc0f8d2768cc7e4ed373ec4db2c16eb1cd5373ce84  V14Formalization/FaithfulHeadlineReduction.lean
31610823b9f64500028617d2b5828bcf10cd8b1c6bc1e989b8ea5ec2a4be602d  V14Formalization/SchemeRationalConstancy.lean
cd241a486a566f7f6163e15af0b5555f0e3a9f9341948ac82828abe0b9596737  V14Formalization/BlockNormalSigma.lean
640a2749e629c138b80c071c3d1d6d50535df1fc46dadec234258826119ffce7  V14Formalization/GenericCharts.lean
ca78e77edf10488e16548c83d5081fc393acbee22d66a8896f9f08ebfaae2174  V14Formalization/V14FixedPointEquations.lean
201a5cd24638a943b6bb38961f4375d70958c0a9b47aa8f0f5734750360170a9  V14Formalization/V14FixedPointCarrierConcrete.lean
8d9dd9eb394fddfac518e6457520b587b4c1a94311745f46d5da2e69fc6ad71b  V14Formalization/V14FixedPointSegreBridge.lean
9903ced80788473d384393e0946f8c423b689005012c24f6f1e6f371c156676c  V14Formalization/ProjectiveFamilyFieldPoint.lean
5eca88c1aba75359ce08b45ea92b1e00806bb8476a27696121e1c7b029e68960  V14Formalization/ProjectiveEigenvectorReduction.lean
3d543822e41bb780d62b7a6570532b34ea8d92d1b1dbf29574ea1da5244bc16b  V14Formalization/D12SigmaCarrierConcrete.lean
4f971023dc143ed82bbac64f57629be66d846f5573aa67a372b359cf6c2e5470  V14Formalization/D12SigmaMinusNormalForm.lean
f088a1e045919f9279ca0257589060bd6a1a0ee07de3c19937d7a90accf0d370  V14Formalization/D12SigmaMinusNormalFormData.lean
a723fc14383f8ff683201d36b76093bdfc45dc1f727cab4b46ae4599278ee1d1  V14Formalization/D12SigmaMinusAmbient.lean
2111fd4f4313eff08e874195ea55ef49a346be4584ad67faaea78c65a4485c47  V14Formalization/D12SigmaMinusReference.lean
0c20364ae0a0984162349f4e1439f2ccc96ba92d5864329af3f2a9f875a805f8  V14Formalization/D12SigmaMinusConcrete.lean
8d553435a5320fd920d2eb4cb068474504be797cc2655c973e8f265016364adb  scripts/export_sigma_minus_normal_form_lean.py
5acf62797d355f7e38fc30ba51da7888bd21f98703e4556f2fe90181809394da  V14Formalization/EllipticPolynomialConstancy.lean
51a24d37dfd259b054780cbc705b633e340244c5ac21e75ae6876b78cc99c842  V14Formalization/WeierstrassSchemeDescent.lean
4a9412fdc0ee894d051de1ee71c08616d76e96382bb0795c2a3b77aae31ac246  V14Formalization/GeometricV14Carrier.lean
fe236ce7e282d806489f9849bbd957700d6962697cebd536173f4395c8e842cd  scripts/export_sigma_normal_form.py
76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0  results/d12_lean_K.json
69c98b2df53b0689df935306fbe647014c7a8d46ea05c486f756ba20a61b426a  results/sigma_normal_form_K.json
```

## Archived and ephemeral plus inputs

The generator, M2 replay, and report are exact byte copies under
`handoff_artifacts/2026-08-12/`.  The generated JSON remains under `/tmp` until
WO-00 is complete:

```text
9b4cd263916bd321ea53fb09d5028a4d4e62f835f6bbff029f40359bf37d7424  handoff_artifacts/2026-08-12/export_sigma_plus_segre.py
52c1280a0a5e84128432db79e4d95753efe52a73d49a0fa450e69798a64965dc  /tmp/sigma_plus_segre_Ki.json
e254e8a6bb2852fa843b1ab732c97723268047e7e319cc98b89f91cfe9c35f2d  handoff_artifacts/2026-08-12/sigma_plus_smooth_mod89.m2
9ab7111c33b72ee188569c7a41e459ac3293a738e05f5d04b2d57ea2392a46a2  handoff_artifacts/2026-08-12/sigma_plus_segre_REPORT.md
```

If an archived file is missing or has a different hash before WO-00 begins,
mark WO-00 `BLOCKED`.  If only the JSON is missing, rerun the archived
generator and require the stated hash; do not substitute a remembered packet.

## Baseline verification state

Green at the snapshot:

```bash
lake build V14Formalization.FaithfulHeadlineReduction
lake build V14Formalization.TrustGuard
```

Intentionally red at the snapshot:

```bash
lake build V14Formalization.D12SigmaMinusConcrete
```

Its first independent errors were:

- unknown namespace/identifier `D12SigmaCarrierConcrete` because the direct
  import is missing;
- eight proof-dependent `Fin 4` rewrite failures in `linears_zero_of_quadrics`;
- failed scalar-extension proof for `hPhi`;
- failed scalar-extension normalization for the discriminant.

The red module is not imported by `V14Formalization.lean`, so the green
umbrella and TrustGuard state does not cover it.
