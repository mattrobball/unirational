# Goal C Codex-root isolated continuation

This is the unique continuation directory for the current root task after a
concurrent worker began using the initially chosen
`../C_PFAFFIAN_FANO/` directory.

The shared directory is now a read-only input for this continuation.  In
particular, commit `80f2469` incorporated the exact characteristic-zero
`a`/`b` minimal-polynomial work while another worker added an independent
verifier and a compressed-algebra continuation.  This directory does not
overwrite those files.

All subsequent files authored by this continuation are contained here.

Current accepted addition:

- `produce_c1_involution.py` writes the exact lazy transport of the universal
  symplectic adjoint to both the original frame and the maximal-etale
  rectangle;
- `verify_c1_involution.py` independently rebuilds the exact `Q,a,b` digests
  and replays unused split-prime transports at 353 and 617.
- `ambient_degree12_rur_char0.json` is an exact degree-three RUR over
  `Q(zeta11)` for a decomposable degree-12 ambient covariant;
- `verify_ambient_degree12_global.py` proves all fifteen Pluecker identities
  globally from a rank-40 degree-24 invariant evaluation certificate;
- `c2_morita.json` installs `e=-P Q/s`, the four-dimensional quaternion
  corner, a rank-three Morita module basis, and the five intended Hermitian
  matrices as exact lazy circuits;
- `verify_c2_morita.py` independently rebuilds the RUR reduction, projector,
  corner operations, Morita basis, and five-matrix transport;
- `search_c3_constant_morita.py` exactly audits the first five finite
  invariant-coordinate ansatz spaces.  Their emptiness is scoped and is not
  a C3 verdict.

Replay with the SymPy-capable interpreter:

```sh
/opt/homebrew/bin/python3 produce_c1_involution.py
/opt/homebrew/bin/python3 verify_c1_involution.py
/opt/homebrew/bin/python3 verify_ambient_degree12_global.py --workers 4
/opt/homebrew/bin/python3 produce_c2_morita.py
/opt/homebrew/bin/python3 verify_c2_morita.py
/opt/homebrew/bin/python3 search_c3_constant_morita.py --function-count 5
```

Current headline: `C-UNDECIDED`.  C3 is the sole construction gate; the
ambient projector is not relabelled as a genuine Fano point.
