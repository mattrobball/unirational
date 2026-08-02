# Local-runner commands

These commands are an execution recipe, not a proof substitute. Run them on
the local macOS worker checkout. Do not translate them into a GitHub Actions
workflow.

## 1. Checkout and result directory

```bash
cd /Users/worker/unirational
git fetch origin
git switch main
git pull --ff-only
BASE=$(git rev-parse HEAD)

ROOT=problems/E-klein-cubic
GOAL=$ROOT/goals_after_5899d0/T3_NORMALIZATION_CLPIC3_LOCAL_RUNNER
OUT=$ROOT/goal_runs_after_5899d0/T3_NORMALIZATION_CLPIC3
mkdir -p "$OUT"/{logs,cas,certificates}

printf '%s\n' "$BASE" > "$OUT/CONSUMED_COMMIT"
{
  /opt/homebrew/bin/python3 --version
  /opt/homebrew/bin/Singular --version | head -20
  /opt/homebrew/bin/M2 --version
  uname -a
} > "$OUT/SOFTWARE.txt" 2>&1
```

Use a dedicated session:

```bash
tmux new -s t3-clpic3
```

Recommended resource wrapper for large jobs:

```bash
/usr/sbin/taskpolicy -m 32768 COMMAND
```

Raise the local memory limit only when the log records the previous measured
floor. Never move a job to a hosted runner.

## 2. Replay the corrected RUR inputs

```bash
cd /Users/worker/unirational/problems/E-klein-cubic/goals_after_bd610a

PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  scratch_t3/verify_t111_generic_rur_identities.py --workers 4 \
  2>&1 | tee ../goal_runs_after_5899d0/T3_NORMALIZATION_CLPIC3/logs/rur_identities.log

PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  scratch_t3/verify_t111_q_and_special_fibre.py \
  2>&1 | tee ../goal_runs_after_5899d0/T3_NORMALIZATION_CLPIC3/logs/rur_special_fibre.log

PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  scratch_t3/verify_t3_node_Aminus6_uminus6.py \
  2>&1 | tee ../goal_runs_after_5899d0/T3_NORMALIZATION_CLPIC3/logs/node_Aminus6_uminus6.log
```

The hard-coded paths in historical scripts assume this checkout location. If
a path-only repair is needed, copy the script into `OUT/cas/`; do not alter the
sealed historical file.

## 3. Decisive generic exhaustiveness calculation

Emit the existing exact generic calculation:

```bash
cd /Users/worker/unirational/problems/E-klein-cubic/goals_after_bd610a
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  scratch_t3/emit_mod101_generic_upper_bound.py \
  2>&1 | tee ../goal_runs_after_5899d0/T3_NORMALIZATION_CLPIC3/logs/emit_mod101.log
```

Run it locally:

```bash
/usr/sbin/taskpolicy -m 32768 /opt/homebrew/bin/Singular -q \
  scratch_t3/mod101_generic_upper_bound.sing \
  2>&1 | tee ../goal_runs_after_5899d0/T3_NORMALIZATION_CLPIC3/logs/mod101_generic_upper_bound.log
```

Copy the exact script and output into the result packet:

```bash
cp scratch_t3/mod101_generic_upper_bound.sing \
  ../goal_runs_after_5899d0/T3_NORMALIZATION_CLPIC3/cas/
cp ../goal_runs_after_5899d0/T3_NORMALIZATION_CLPIC3/logs/mod101_generic_upper_bound.log \
  ../goal_runs_after_5899d0/T3_NORMALIZATION_CLPIC3/certificates/
```

Success requires the final saturated quotient to have dimension zero and
length six. Save the final Groebner basis, leading monomial ideal, and standard
monomial basis. Add an independent parser/verifier; do not certify success by
`grep` alone.

If prime 101 is bad, parameterize the emitter by the prime, record the bad
factor, and repeat at two good primes. Keep all variants under `OUT/cas/`.

## 4. Rebuild the discriminant packet

```bash
cd /Users/worker/unirational/problems/E-klein-cubic/goals_after_bd610a/scratch_t3/discriminant

PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u verify.py \
  2>&1 | tee ../../../goal_runs_after_5899d0/T3_NORMALIZATION_CLPIC3/logs/discriminant_verify.log

PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u check_plane_local_types.py \
  2>&1 | tee ../../../goal_runs_after_5899d0/T3_NORMALIZATION_CLPIC3/logs/plane_local_types.log

PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u check_conductor_delta.py \
  2>&1 | tee ../../../goal_runs_after_5899d0/T3_NORMALIZATION_CLPIC3/logs/conductor_delta.log
```

For the boundary `E=(L,A)`, add a new local script under `OUT/cas/` that
reconstructs `c4,c6,Delta`, evaluates their valuations on both Newton branches,
and determines the minimal local cubic type. This is a required new
calculation; the stored contact-order-four result alone does not determine the
local class group.

## 5. Normalization and conductor scripts

Implement the stable-ideal computation in `OUT/cas/`, preferably as separate
producer and verifier scripts:

```text
produce_dominant_prime.(m2|sing|py)
verify_dominant_prime.(m2|sing|py)
produce_stable_ideal_normalization.(m2|sing|py)
verify_stable_ideal_normalization.(m2|sing|py)
```

The producer must export exact witnesses for

```text
p=(c,d),
p^2=c*p,
(c:d)=p,
d^2=alpha*c^2+beta*c*d.
```

The verifier must rebuild each ideal independently from `P,QZ,NB,NY` and
check the witnesses. A saved boolean or a producer-imported result is not an
independent verification.

## 6. Hash and seal

From the repository root:

```bash
find "$OUT" -type f ! -name SEAL.json -print0 \
  | sort -z \
  | xargs -0 shasum -a 256 \
  > "$OUT/SHA256SUMS"
```

Create `SEAL.json` only after every claimed theorem can be reconstructed by
`verify_all.py`. The final local replay must be:

```bash
cd /Users/worker/unirational/problems/E-klein-cubic/goal_runs_after_5899d0/T3_NORMALIZATION_CLPIC3
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u verify_all.py
```

Accepted terminal markers:

```text
T3_FIXED_FRAME_INDEX3_VERIFIER_ACCEPT
T3_DANGEROUS_3_CLASS_VERIFIER_ACCEPT
T3_NORMALIZATION_PARTIAL_VERIFIER_ACCEPT
```

The marker must agree with the first line of `STATUS.md`.
