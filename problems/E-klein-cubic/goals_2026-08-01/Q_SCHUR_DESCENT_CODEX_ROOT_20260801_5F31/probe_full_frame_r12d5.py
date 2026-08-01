#!/usr/bin/env python3
"""Probe a five-dimensional scalar R12 slice on all five Schur columns.

The full scalar invariant space R12 has dimension 14.  This gate uses the
first five independent exact Reynolds seeds selected by the audited engine,
so it has 25 coefficient variables.  Emptiness is only a theorem for this
displayed slice; a survivor is only a discovery signal until checked against
the complete characteristic-zero identity.
"""

from __future__ import annotations

import probe_full_frame_r8 as engine


engine.DEGREE = 12
engine.DIMENSION = 5
engine.VARIABLE_COUNT = 5 * engine.DIMENSION
engine.BASIS_SEED = 202608011205
engine.SAMPLE_SEED = 202608011206
engine.PREFIX = "full_frame_r12d5"
engine.BASIS_LIMIT = 5
engine.LABEL = "R12D5"


if __name__ == "__main__":
    engine.main()
