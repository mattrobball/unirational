# Q Schur exact-frame packet

This self-contained packet lifts the degree-eight Schur Reynolds frame to
exact characteristic zero and installs the full descended Klein cubic as a
35-coefficient straight-line table.

Replay from this directory with:

```sh
/opt/homebrew/bin/python3 verify_all.py
```

The direct producer replay is slower and may be run separately:

```sh
/opt/homebrew/bin/python3 produce_exact_frame.py --write
```

Important files:

- `THEOREM.md`: mathematical statement and strict boundary;
- `exact_frame.json`: exact matrices, group words, witness, and all 35 cubic
  coefficients;
- `verify_exact_frame.py`: independent reconstruction;
- `exact_representation_core.py`: pinned exact representation arithmetic;
- `SEAL.json`: recursive packet hash manifest.
