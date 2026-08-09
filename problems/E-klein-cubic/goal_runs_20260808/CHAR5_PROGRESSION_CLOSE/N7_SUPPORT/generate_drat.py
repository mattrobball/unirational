#!/usr/bin/env python3
"""Development-only CaDiCaL DRAT generator for the exact n=7 CNF."""

import argparse
import importlib.util
from pathlib import Path

from pysat.solvers import Cadical195


HERE = Path(__file__).resolve().parent
CNF_SOURCE = HERE / "cnf_search.py"


def load_cnf():
    spec = importlib.util.spec_from_file_location("n7_cnf", CNF_SOURCE)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("d", type=int)
    parser.add_argument("r", type=int)
    parser.add_argument("output", type=Path)
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)

    module = load_cnf()
    nx, nrows, supports, clause_sets = module.cnf_case(args.d, args.r)
    clauses = [sorted(clause, key=lambda value: (abs(value), value))
               for clause in clause_sets]
    nvars = nx + len(supports)
    cnf_path = args.output / f"case_{args.d}_{args.r}.cnf"
    drat_path = args.output / f"case_{args.d}_{args.r}.drat"
    with cnf_path.open("w") as stream:
        stream.write(f"p cnf {nvars} {len(clauses)}\n")
        for clause in clauses:
            stream.write(" ".join(map(str, clause)) + " 0\n")

    solver = Cadical195(bootstrap_with=clauses, with_proof=True)
    result = solver.solve()
    if result:
        model = solver.get_model()
        mask = sum(1 << (i - 1) for i in model if 1 <= i <= nx)
        print("SAT", args.d, args.r, "MASK", mask)
        return
    proof = solver.get_proof()
    assert proof is not None and proof
    with drat_path.open("w") as stream:
        for line in proof:
            stream.write(line + "\n")
    print("UNSAT", args.d, args.r, "X_VARS", nx, "AUX_VARS", len(supports),
          "ROWS", nrows, "CLAUSES", len(clauses), "DRAT_LINES", len(proof),
          "CNF", cnf_path, "DRAT", drat_path, flush=True)


if __name__ == "__main__":
    main()
