# Goal C isolated exact dossier

This directory is the collision-free continuation for
`../GOAL_C_PFAFFIAN_FANO_POINT.md`.  The sibling `../C_PFAFFIAN_FANO/` and
historical packets are read-only inputs.

Current headline: `C-UNDECIDED`.

Installed exact data:

- a lazy maximal-etale compressed algebra interface;
- the exact transported symplectic involution;
- the exact distinguished five-plane, using the `x,C,D,E,K` Hilbert--90
  frame, as five sigma-symmetric algebra elements;
- a bounded ambient-projector degree audit and multiprime reconstruction
  harness.

Not installed:

- an exact self-adjoint rank-two projector;
- the quaternion corner and `3 x 3` Hermitian matrices;
- a simultaneous common isotropic line;
- a genuine Fano point or positive headline bridge.

Core replay:

```sh
/opt/homebrew/bin/python3 -u verify_compressed_algebra.py
/opt/homebrew/bin/python3 -u verify_involution.py
/opt/homebrew/bin/python3 -u verify_distinguished_five_plane.py
/opt/homebrew/bin/python3 -u audit_ambient_leading.py --max-degree 8
```

The aggregate `verify_all.py` reruns those checks plus the authoritative exact
covariant equivariance certificate.  It is intentionally a partial-interface
verifier and refuses to emit the Goal C positive marker.
