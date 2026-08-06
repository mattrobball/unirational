#!/bin/sh
# FIX-VI-PRYM-SEAL -- full clean run.  Usage: sh run_all.sh
set -e
D=$(cd "$(dirname "$0")" && pwd)
rm -f "$D/results/checks.log" "$D/results/verifier.log"
python3 "$D/scripts/run_A.py" > "$D/results/A_stdout.txt" 2>&1
python3 "$D/scripts/run_B.py" > "$D/results/B_stdout.txt" 2>&1
python3 "$D/scripts/run_C.py" > "$D/results/C_stdout.txt" 2>&1
python3 "$D/scripts/run_M2.py" > "$D/results/M2_stdout.txt" 2>&1
python3 "$D/verifier.py"      > "$D/results/verifier_stdout.txt" 2>&1
python3 "$D/scripts/parity.py"
