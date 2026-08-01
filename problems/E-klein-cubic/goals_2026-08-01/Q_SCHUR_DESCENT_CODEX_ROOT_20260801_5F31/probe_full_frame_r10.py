#!/usr/bin/env python3
"""Exact good-fibre probe of the full five-coordinate R10 Schur frame.

This reuses the audited full-frame engine with the complete four-dimensional
R10 invariant space and disjoint seeds/output names.  It is a positive
candidate search and, on an Artinian-at-the-origin leading ideal, a scoped
characteristic-zero exclusion only.
"""

from __future__ import annotations

import probe_full_frame_r8 as engine


engine.DEGREE = 10
engine.DIMENSION = engine.core.INVARIANT_DIMENSIONS[engine.DEGREE]
engine.VARIABLE_COUNT = 5 * engine.DIMENSION
engine.BASIS_SEED = 202608011001
engine.SAMPLE_SEED = 202608011002
engine.PREFIX = "full_frame_r10"
engine.LABEL = "R10"


if __name__ == "__main__":
    engine.main()
