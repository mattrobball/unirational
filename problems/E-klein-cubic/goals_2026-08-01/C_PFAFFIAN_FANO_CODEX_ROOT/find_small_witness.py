#!/usr/bin/env python3
"""Find a tiny integral point with a good maximal-etale rectangle modulo 23."""

import itertools
import json
import runpy
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]


def main():
    c3 = runpy.run_path(str(ROOT / "certificates/fano_c3/produce_c3.py"))
    c2 = c3["load_c2_helpers"]()
    kproj = {}
    core = ROOT / "tmp/kproj_arithmetic/core.py"
    exec(compile(core.read_text().replace("ROOT = Path(__file__).resolve().parents[2]", f"ROOT = Path(r'{ROOT}')"), str(core), "exec"), kproj)
    forms = kproj["forms"]()
    seeds = json.loads((ROOT / "tmp/pfaffian_representation_alignment/certificate.json").read_text())["end36_reynolds_frame"]["selected_reynolds_seeds"]
    conjugation, inverses = c3["build_group"](c2, 23, 2)
    for point in itertools.product((0, 1, 22), repeat=5):
        if point == (0, 0, 0, 0, 0):
            continue
        try:
            matrices, _vectors = c3["frame_at_point"](c2, conjugation, inverses, seeds, forms, kproj["evaluate_mod"], point, 23)
            compressed = c3["compressed_data_at"](matrices[1], matrices[2], 23)
        except Exception:
            continue
        if compressed is not None:
            signed = tuple(value if value < 12 else value - 23 for value in point)
            print(signed, compressed["rect_det_m6"])
            return
    raise SystemExit("no small witness")


if __name__ == "__main__":
    main()
