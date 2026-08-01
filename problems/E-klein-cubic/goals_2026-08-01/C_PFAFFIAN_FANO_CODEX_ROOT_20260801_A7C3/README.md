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

Replay with the SymPy-capable interpreter:

```sh
/opt/homebrew/bin/python3 produce_c1_involution.py
/opt/homebrew/bin/python3 verify_c1_involution.py
```
