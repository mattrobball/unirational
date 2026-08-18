/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.

The `GradedAlgebra` instance below is joint work with Eric Wieser and is a
candidate for Mathlib (`Mathlib/LinearAlgebra/SymmetricAlgebra/Grading.lean`);
it is vendored here so that the published statements can be made
coordinate-free without waiting on an upstream release.
-/
module

public import Mathlib.LinearAlgebra.SymmetricAlgebra.Basic
public import Mathlib.RingTheory.GradedAlgebra.Basic

/-!
# The grading on `SymmetricAlgebra R M`

Many of these results are copied with minimal modification from the tensor
algebra.  The main result is `SymmetricAlgebra.gradedAlgebra`, which says that
the symmetric algebra is an `ℕ`-graded algebra.

## Implementation notes

Unlike `ExteriorAlgebra.gradedAlgebra`, which is stated in terms of the
exterior powers `⋀[R]^i M`, there is no symmetric power of a module to grade
`SymmetricAlgebra R M` by; so the graded pieces are taken to be the powers of
the range of `SymmetricAlgebra.ι`, exactly as in `TensorAlgebra.gradedAlgebra`.
Mathlib's `SymmetricPower` is ungraded and unconnected to `SymmetricAlgebra`,
so the exterior-algebra shape was unavailable.

The only real difference from the tensor and exterior cases is that
`SymmetricAlgebra.lift` requires its codomain to be commutative.  This is not
an obstacle: `SetLike.gcommSemiring` gives `⨁ i, ↥(LinearMap.range (ι R M) ^ i)`
a `CommSemiring` structure, because the graded pieces are submodules of the
commutative ring `SymmetricAlgebra R M`.
-/

@[expose] public section

namespace SymmetricAlgebra

variable {R M : Type*} [CommSemiring R] [AddCommMonoid M] [Module R M]

open scoped DirectSum

variable (R M)

/-- A version of `SymmetricAlgebra.ι` that maps directly into the graded
structure.  This is primarily an auxiliary construction used to provide
`SymmetricAlgebra.gradedAlgebra`. -/
nonrec def GradedAlgebra.ι : M →ₗ[R] ⨁ i : ℕ, ↥(LinearMap.range (ι R M) ^ i) :=
  DirectSum.lof R ℕ (fun i => ↥(LinearMap.range (ι R M) ^ i)) 1 ∘ₗ
    (ι R M).codRestrict _ fun m => by simpa only [pow_one] using LinearMap.mem_range_self _ m

theorem GradedAlgebra.ι_apply (m : M) :
    GradedAlgebra.ι R M m =
      DirectSum.of (fun i : ℕ => ↥(LinearMap.range (SymmetricAlgebra.ι R M) ^ i)) 1
        ⟨SymmetricAlgebra.ι R M m, by
          simpa only [pow_one] using LinearMap.mem_range_self _ m⟩ :=
  rfl

variable {R M}

/-- The symmetric algebra is graded by the powers of the submodule
`(SymmetricAlgebra.ι R M).range`. -/
instance gradedAlgebra :
    GradedAlgebra ((LinearMap.range (ι R M) ^ ·) : ℕ → Submodule R (SymmetricAlgebra R M)) :=
  fast_instance% GradedAlgebra.ofAlgHom _ (lift (GradedAlgebra.ι R M))
    (by
      ext m
      change DirectSum.coeAlgHom (fun i : ℕ => LinearMap.range (ι R M) ^ i)
          (lift (GradedAlgebra.ι R M) (ι R M m)) = ι R M m
      rw [lift_ι_apply, GradedAlgebra.ι_apply R M, DirectSum.coeAlgHom_of])
    fun i x => by
    obtain ⟨x, hx⟩ := x
    dsimp only [Subtype.coe_mk, DirectSum.lof_eq_of]
    induction hx using Submodule.pow_induction_on_left' with
    | algebraMap r =>
      rw [AlgHom.commutes, DirectSum.algebraMap_apply]; rfl
    | add x y i hx hy ihx ihy =>
      rw [map_add, ihx, ihy, ← map_add]
      rfl
    | mem_mul m hm i x hx ih =>
      obtain ⟨_, rfl⟩ := hm
      rw [map_mul, ih, lift_ι_apply, GradedAlgebra.ι_apply R M, DirectSum.of_mul_of]
      exact DirectSum.of_eq_of_gradedMonoid_eq (Sigma.subtype_ext (add_comm _ _) rfl)

/-- The grading on `SymmetricAlgebra R M`, as a named family.  `grade R M i` is
the `R`-submodule of elements of degree `i`. -/
abbrev grade (R M : Type*) [CommSemiring R] [AddCommMonoid M] [Module R M] :
    ℕ → Submodule R (SymmetricAlgebra R M) :=
  fun i => LinearMap.range (ι R M) ^ i

end SymmetricAlgebra
