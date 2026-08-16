# The generated certificate layer is what makes this proof unverifiable

Written 2026-08-16. Read this before touching the `D12Piece*` generators or
trying to run Comparator again.

## What happened

Comparator has now failed three ways, and none of them were configuration:

| where | outcome |
|---|---|
| GitHub Actions, 4 cores | killed at GitHub's 6h job ceiling, 3845/4350 build jobs, never reached verification |
| Apple container, 6 CPU / 24 GB | guest OOM-killed at 16h14m, `COMPARATOR_EXIT_CODE=137`, after the build had succeeded |
| — | no verdict has ever been produced |

The OOM is unambiguous — from the guest kernel log:

    oom-kill: constraint=CONSTRAINT_NONE, global_oom,
      task_memcg=/container/comparator-base, task=comparator
    Out of memory: Killed process 9803 (comparator)
      total-vm:30279488kB, anon-rss:12406840kB

`comparator` reached 12.4 GB resident / 30 GB virtual while `lean4export` held
11.5 GB concurrently. The container had 24 GB. `lean4export V14Solution` alone
ran **3h33m of wall clock for 2h31m of CPU**, single-threaded, and had not
finished when the pair blew the limit.

Raising the container to 48 GB would probably get past this specific kill. It
does not fix the underlying problem, and it leaves the artifact checkable only
on a very large machine — uncomfortable for something whose entire purpose is
independent verification.

## Where the weight actually is

Measured from the built oleans (12.29 GB across 1760 modules):

| family | modules | GB | % of all oleans |
|---|---|---:|---:|
| D12PiecePASplitEntry | 100 | 2.34 | 19.1% |
| D12PieceAPSplitEntry | 100 | 2.09 | 17.0% |
| D12PiecePPSplitEntry | 100 | 1.79 | 14.5% |
| D12PieceAASplitEntry | 84 | 1.72 | 14.0% |
| D12SigmaPlusSegreUM | 315 | 0.89 | 7.2% |
| D12SigmaPlusSegreHM | 189 | 0.51 | 4.1% |
| D12SigmaPlusSegreVQ | 189 | 0.39 | 3.2% |

**Generated data families are 11.03 GB = 89.8% of the entire proof.** The four
`SplitEntry` families alone are 64.6%.

For contrast: the *trusted base* — everything the statement's meaning depends
on — is **172 declarations**, published at
`artifacts/trusted_base.lean` and verified to elaborate at zero errors. Nine
tenths of what the kernel must check is generated arithmetic, not mathematics
anyone reads.

## What one generated module contains

`V14Formalization/D12PieceAPSplitEntry7_9.lean` — 1362 lines, 44 KB source,
**22 MB olean, ~420 s to compile** — exists to prove one matrix entry:

```lean
theorem entry_eq_matrixOne :
    (matrixMul XVec AVec + matrixMul KVec YVec) 7 9 = matrixOne (Fin 10) 7 9
```

To do that it emits **181 theorems, 36 defs, 22 products, 121 `norm_num`
calls**. The pattern per product is a value table plus one theorem per index:

```lean
def xaProduct0Value (i : Fin 10) : ℚ := match i.val with | 0 => (2/121 : ℚ) | ...

theorem xaProduct0_apply_0 : xaProduct0 0 = xaProduct0Value 0 := by
  norm_num [xaProduct0, xaProduct0Value, XCell7_0, ACell0_9,
            mul, conv, coeffAt, Fin.sum_univ_succ]
theorem xaProduct0_apply_1 : ...   -- ten of these, per product
```

Each re-unfolds the whole convolution and carries its own `norm_num`
certificate for rational arithmetic. Multiply by 400 modules.

## Why it is this expensive: the representation

`V14Formalization/D12CyclotomicVec.lean`:

```lean
abbrev Vec := Fin 10 → ℚ          -- a FUNCTION, in a noncomputable section

def conv (a b : Vec) (n : ℕ) : ℚ :=
  ∑ i : Fin 10, if hi : i.val ≤ n then a i * coeffAt b (n - i.val) else 0

def mul (a b : Vec) : Vec := fun k =>
  conv a b k.val + conv a b (k.val + 11) - conv a b 10
```

Three consequences, all measured on the v4.32.1 toolchain:

1. **Function equality is not decidable**, so every fact goes through `funext`
   and pointwise reasoning. That is *why* the generator emits ten
   `_apply_k` lemmas instead of one equation — the representation forces it.
2. **`conv` is a `Finset.sum` over `Fin 10`** and `mul` calls it three times,
   so one coefficient is a 30-term unfolding before any arithmetic.
3. **`ℚ` cannot reduce in the Lean kernel at all.** Verified:

   ```
   (mkRat 2 121).add (mkRat 3 121) = mkRat 5 121 := rfl     -- TYPE MISMATCH
   #print axioms Rat.add
     'Rat.add' depends on axioms: [propext, Classical.choice, Quot.sound]
   ```

   A definition resting on `Classical.choice` has no computational content for
   the kernel to unfold, however good the compiled implementation is.
   **`norm_num` is not a poor choice here — it is the only option available
   over `ℚ`.** Certificates are the price of the element type.

## The fix, and the evidence for it

Every coefficient seen so far has a denominator that is a power of 11
(`ACell` entries are `k/11`, products land in `1/121`). 11 is the only
ramified prime in `ℚ(ζ₁₁)`, so this is expected rather than lucky.

If that holds everywhere, the identity rescales to **ℤ[ζ₁₁]**, and integer
arithmetic *does* reduce in the kernel, GMP-accelerated (`Nat.add`, `mul`,
`sub`, `div`, `mod`, `gcd`, `beq`, `ble` dispatch to native bignum ops).

Verified end-to-end on v4.32.1, non-tautologically:

```lean
abbrev VecZ := Vector Int 10        -- Vector IS in core, with DecidableEq
def convZ (x y : VecZ) (n : Nat) : Int := ...
def mulZ (x y : VecZ) : VecZ :=
  Vector.ofFn (fun k : Fin 10 => convZ x y k.val + convZ x y (k.val+11) - convZ x y 10)

theorem prod_eq :
    mulZ X A = #v[215, 427, 142, 184, 396, 198, 790, -84, 491, 464] := by decide
```

That is a full reduced product in ℤ[ζ₁₁] — three ten-term convolutions per
coefficient — and **the file elaborates in 264 ms**, most of it Lean starting
up. Changing one entry of the literal makes `decide` prove the statement
*false*, so the check has real content.

**420 s and 22 MB of olean, versus 264 ms.**

## What to do next

1. **Confirm the scaling.** Scan all four `*Data` families for the worst
   denominator. If every one is `2^a · 11^b`, the LCM is the scaling factor.
   Any other prime factor kills the plan as stated — report it first.
2. **Prototype one entry end-to-end over ℤ**, scaling lemma included, and
   compare olean size and compile time against `D12PieceAPSplitEntry7_9`.
3. **Change the generator, not the output.** These files come from
   `scripts/export_d12_*.py`. The mathematics does not change; only the
   representation and the tactic do.
4. **Add the scaling lemma once**, not per entry: multiplication by 11 is
   injective on the module, so the ℤ identity implies the ℚ one. A single
   `Matrix.smul` cancellation argument.
5. **Then re-run Comparator.** If the closure shrinks by the order of
   magnitude this suggests, `lean4export` and both kernel replays shrink with
   it, and the check may fit in CI rather than needing a 48 GB container.

## Open risks

- Only two of four `*Data` families have been read by hand. Step 1 exists to
  settle that.
- `Vec` is used well beyond the generated modules — `eval`, `eval_add`,
  `eval_smul` feed into `WeilRep.K`. Changing the representation means
  providing the same API over the new type, or an equivalence between them,
  without disturbing the hand-written proofs above it.
- Nothing here has been tried at scale. The 264 ms is one entry, not 400.

## Also worth knowing

- Comparator **cannot** run on a GitHub-hosted runner: the build alone
  overruns the 6h ceiling, and the memory is out of reach. It wipes
  `.lake/build` by design, so the expensive part is uncacheable and
  unsplittable.
- The harness copies the *entire* repo directory into the container,
  including `.lake` — 16 GB locally, plus an 18 GB symlinked package tree.
  That caused an XPC timeout on 2026-08-15. Stage a source-only copy
  (`rsync -a --exclude .lake`, 42 MB) and point the harness at that. This
  should be folded into `run-comparator.sh`.
- `artifacts/trusted_base.lean` is regenerated by
  `.github/workflows/v14-trusted-base.yml`, which now refuses to publish a
  file that does not elaborate.
