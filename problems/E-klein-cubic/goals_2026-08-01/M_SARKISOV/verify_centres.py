#!/usr/bin/env python3
"""Independent semantic audit for the standard center census payload."""

from __future__ import annotations

import importlib.util
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent


def load_producer():
    spec = importlib.util.spec_from_file_location("m_sarkisov_producer", HERE / "produce.py")
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def main():
    producer = load_producer()
    stored = json.loads((HERE / "payload" / "weak_fano_centres.json").read_text())
    assert producer.payload() == stored
    assert len(stored["centres"]) == 10

    for centre in stored["centres"]:
        expected = 22 - 4 * centre["d"] + 2 * centre["g"]
        assert centre["volume"] == expected

    link = stored["plane_cubic_link"]
    assert link["centre"] == {"g": 1, "d": 3}
    assert link["generic_fibre_degree"] == 3
    assert link["zero_cycle_degrees"] == [3, 55]
    assert link["generic_fibre_index"] == 1
    assert link["section_frontier"] == "rational section or degree-4 multisection"

    print("PASS stored center census equals producer output")
    print("PASS all ten anticanonical volumes equal 22-4d+2g")
    print("PASS plane-cubic structural and section frontiers remain distinct")


if __name__ == "__main__":
    main()
