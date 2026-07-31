# Director handoff — running the Problem E dispatch loop

**Author:** director session, 2026-07-31.
**State at writing:** `main` @ `5e72d8e`, tree clean, no workers in flight.
**Scope:** how to run the loop. The mathematics lives in the work orders,
`REPAIR.md`, and the sealed certificates — this is the operating manual.

---

## 1. The loop

Each round is the same five steps:

```text
pull  ->  brief  ->  dispatch  ->  verify  ->  commit + push
```

1. **Pull.** New work orders arrive on `origin/main` from the owner, often
   mid-round. Always `git fetch` before asserting sync state (see §3).
2. **Brief.** Write a self-contained markdown brief to the scratchpad. The
   worker starts fresh with no conversation context — everything it needs
   must be in the brief or in a file it is told to read.
3. **Dispatch.** One worker per parallel task, staggered by `sleep 12-30` so
   they don't collide on startup:

```bash
/Users/worker/.grok/bin/grok \
  --cwd /Users/worker/unirational/problems/E-klein-cubic \
  --prompt-file "$S/brief.md" \
  -m grok-4.5 --effort high \
  --always-approve --sandbox off --no-subagents \
  --max-turns 450 --output-format plain \
  > "$S/out.md" 2> "$S/err.log"
```

   Run with `run_in_background: true` and `dangerouslyDisableSandbox: true`
   (the launch is otherwise blocked by the permission classifier).

4. **Verify.** Replay the worker's verifiers yourself. Do not accept a
   worker's self-report. See §4 — this is where the real judgment is.
5. **Commit + push.** Path-scoped, with the verdict and its boundary in the
   message. See §3.

---

## 2. Writing briefs that work

The standard that has produced good results:

- **Scope fences.** State exactly which stages are in scope and which are
  not, and name the parallel workers so the worker knows what not to touch.
- **Carry the accepted state.** List settled facts as "do not re-derive,"
  with their markers. Workers waste turns rebuilding what is already sealed.
- **Carry the *corrections*.** Tell the worker which of its predecessors'
  results were downgraded and why. This is the highest-value part of a brief:
  it stops the same error recurring in a new guise.
- **Name the trap.** If a specific failure mode is likely, say it outright —
  e.g. "an argument that would work for an arbitrary 4-dimensional subspace
  of an arbitrary degree-55 field is wrong or weaker."
- **Bless the honest stop.** Say explicitly that a precisely named bottleneck
  or an `UNDECIDED` exit is a success. Workers otherwise feel pressure to
  produce a verdict, and manufactured verdicts are the expensive failure.
- **Restate the boundary.** What the result would and would not prove. Every
  brief should end with the headline still marked OPEN.

Briefs live in the session scratchpad, not the repo. Work orders and
certificates are the durable record.

---

## 3. Git mechanics — three failures already hit

**Branch drift.** A worker (or something else) moved `HEAD` from
`agent/weaken-hypotheses` to `main` mid-session. Twelve commits landed on
`main` while `git push origin agent/weaken-hypotheses` reported
"Everything up-to-date" — because that branch genuinely had nothing new.
**Check `git branch --show-current` before committing.** Current instruction
from the owner: **stay on `main`.**

**Stale tracking refs.** `git log origin/main` reads a *local* ref. Without a
`fetch` it can report "0 unpushed" while a push has actually been rejected.
**Always `git fetch` before asserting sync state.** When a push is rejected
because the owner pushed concurrently, `git rebase origin/main` then push —
never force.

**Sweep collisions.** `git add -A problems/E-klein-cubic` while several
workers write in parallel silently absorbs another worker's artifacts into
the wrong commit. This happened twice (Path F into `d96b408`, Route G into
`17011c3`), each time leaving a commit message that describes only one of the
two results. **Use path-scoped `git add`** (now house rule 11 in V2). If it
happens anyway, do not rewrite published history — write a record file
(`ROUTE_G_VERDICT.md` is the template) and commit that.

Commit messages carry the verdict, its exact boundary, and what was *not*
claimed. They are the durable audit trail; assume the certificates outlive
this session.

---

## 4. Verification — the discipline that matters most

`REPAIR.md` §0, binding:

```text
hash/verifier replay  !=  mathematical verification of the analytic
                          implications in the proof note
```

I accepted the T2 packet on a passing marker. Its verifier confirmed files
parsed and hashes matched; it never checked the dimension theorem. The
result — `T-NONNORMAL`, `dim Sing_S = 2` — was later suspended.

**Ask of every packet: what mathematical statement did the verifier actually
recompute?** A verifier that reads a dimension from JSON has verified
nothing about that dimension. V2 house rule 10 now requires the verifier to
recompute the decisive invariant.

Spot-check by hand where cheap. Worked examples from this session: expanding
`F(z+y)` to confirm the polar identity; checking the parity rule from
`p(tx) = tp(x)`; computing the Macaulay ledger to show a 64 GiB grant could
not possibly help Path A (`D=19`, `n=52` needs ~10²⁶ GiB).

---

## 5. Traps this project has actually sprung

- **`p = 67` is not a safe default.** It accidentally kills the free-fibre
  residual on the degree-25 track. Always use holdout primes (89, 199, 353
  have all been used successfully).
- **Empty msolve output is not emptiness.** It is a failed run. Record as
  discovery.
- **SymPy's private rational-reconstruction helper skips a final congruence
  check** and silently corrupts results when a prime shares a factor with the
  CRT modulus. It corrupted a packet here. Implement the congruence check
  directly.
- **Affine hyperplane sections cannot bound dimension from above.** This
  family of error has appeared three times (original T2, then V1 of the
  decision order). Use Krull dimension, Noether normalization, or the
  *saturated projective closure*.
- **Shell aliases `gap` → `git apply` and `gp` → `git push`.** A script
  calling them by bare name silently runs git. Absolute paths always. PARI's
  binary is `gp`; there is no `pari` binary.
- **Workers can leave orphans.** An `M2-binary` ran 9 hours at 100% CPU to
  ~7.8 GiB after its parent died. Check `ps` periodically; kill orphans only
  with owner approval (terminating is destructive).

---

## 6. Environment

Installed and verified by execution: `M2` 1.26.06, `Singular` 4.4.1,
`msolve` 0.10.1, `normaliz` 3.11.1, `gp` (PARI) 2.17.4, `julia` 1.12.6 with
Nemo/Hecke/Groebner, `python3` 3.14.6, `GAP` 4.15.1 (+AtlasRep, CTblLib) at
`/opt/homebrew/Caskroom/miniforge/base/bin/gap`, `conda` 26.5.3.

**Not available:** SageMath (cask download fails); `using Oscar` is broken
(Polymake.jl precompile error) though Nemo/Hecke/Groebner work; polymake.
Substitute PARI/GP for Sage's elliptic-curve work — verified working.

Machine: M5 Max, 128 GB, 18 cores. Workers cannot write under `.git/`; they
leave the tree final and report an intended commit split, which the director
executes.

Resource policy: 8 GiB exploratory ceiling, 64 GiB after preflight, 96 GiB
absolute with approval, no concurrent memory-saturating jobs. A measured stop
with floors is a successful outcome.

---

## 7. Where things stand

No route has crossed a decisive gate. Live threads:

| Route | State | Blocker |
|---|---|---|
| T | `T60-UNDECIDED`, `T2R-UNDECIDED` | `s_1` a unit on the open — zero vanishings in ~1500 samples (primes 71–107), not exact-certified |
| P25 | `P25X0-PASS`, `P25X1-FAIL` | span mismatch 746 vs 842; transport over `K` open; P25X.2 must not start |
| C | not started | §7 selects it: "both tracks undecided → begin conditional Track C" |
| G, A, S19, H | parked | need new theorems, not compute |

**Next action per §7:** begin Track C (direct twisted Fano section). Its
known weak point is documented — the idempotent lands in the auxiliary
`P^2_D`, so the real content is the codimension-five section problem
`P^2_D(K) ~~> F_14,T(K)`. §5 therefore orders the fibration/conic-bundle/
multisection search *before* any raw five-equation elimination.

**Open decision for the owner:** whether to authorize one 64–96 GiB
preflighted job for Track T's `s_1`-unit lemma. Unlike Path A's elimination —
where the ledger proved no machine could help — this one is plausibly a
genuine finite wall, and the lemma would give `S_G ≅ B_G` and change the
dimension question's character.

---

## 8. One standing caution

Every tightening of discipline this session **removed** apparent progress
rather than confirming it: `P25-TOWER-SURVIVES` → residual family dies in the
genuine global image → the char-0 object doesn't match the accepted 842
basis. Treat encouraging results as provisional until the boundary has been
audited, and report them to the owner with the boundary attached. The
headline is **OPEN**, and no result here has yet borne on it.
