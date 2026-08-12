#!/usr/bin/env python3
"""Run the five audit targets in cheap-to-expensive order."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import paths

os.environ.setdefault("OMP_NUM_THREADS", "2")
os.environ.setdefault("OPENBLAS_NUM_THREADS", "2")
os.environ.setdefault("MKL_NUM_THREADS", "2")
os.environ.setdefault("NUMEXPR_NUM_THREADS", "2")
os.environ.setdefault("VECLIB_MAXIMUM_THREADS", "2")

assert "slicelib" not in sys.modules


def main():
    os.makedirs(paths.RES, exist_ok=True)
    import produce_r5
    produce_r5.main()
    import produce_r1
    produce_r1.main()
    import produce_r2r3
    produce_r2r3.main()
    import produce_r4
    produce_r4.main()
    print("PRODUCE_ALL_DONE", flush=True)


if __name__ == "__main__":
    main()
