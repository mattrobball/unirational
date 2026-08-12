/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
import V14Formalization.GrassmannianLinearSection
import Mathlib.LinearAlgebra.Matrix.Nondegenerate

/-!
# A kernel-checkable matrix interface for the D12 fixed-locus certificate

This file contains no sealed numerical data.  It proves that the finite matrix
identities exported separately imply absence of a nonzero decomposable vector
in any of the four one-dimensional characters of the projective dihedral
centralizer.
-/

noncomputable section

open scoped BigOperators

namespace V14Formalization
namespace D12Certificate

universe u

variable {Ω : Type u} [Field Ω]

/-- The coordinate Plücker quadratic associated to a four-subset. -/
def pluckerValue (v : Fin 15 → Ω) (q : Fin 15) : Ω :=
  let d := SchemeGeometry.pluckerRelation q
  v d.p1 * v d.p2 - v d.p3 * v d.p4 + v d.p5 * v d.p6

/-- Degree-two monomials in the two parameters of the `(+,+)` pencil. -/
def squareMonomials (t : Fin 2 → Ω) : Fin 3 → Ω :=
  ![t 0 * t 0, t 0 * t 1, t 1 * t 1]

/-- Three independent Plücker equations eliminate a two-dimensional
character piece when their coefficient matrix has nonzero determinant. -/
theorem plucker_empty_fin2_of_coeff
    (BK : Matrix (Fin 15) (Fin 2) Ω) (C : Matrix (Fin 3) (Fin 3) Ω)
    (hdet : C.det ≠ 0)
    (hcoeff : ∀ t : Fin 2 → Ω,
      C.mulVec (squareMonomials t) =
        ![pluckerValue (BK.mulVec t) 1,
          pluckerValue (BK.mulVec t) 2,
          pluckerValue (BK.mulVec t) 9]) :
    ∀ t : Fin 2 → Ω,
      (∀ q : Fin 15, pluckerValue (BK.mulVec t) q = 0) → t = 0 := by
  intro t hq
  have hC : C.mulVec (squareMonomials t) = 0 := by
    rw [hcoeff]
    funext i
    fin_cases i <;> simp [hq]
  have hm : squareMonomials t = 0 := Matrix.eq_zero_of_mulVec_eq_zero hdet hC
  have ht0sq := congrFun hm 0
  have ht1sq := congrFun hm 2
  have ht0 : t 0 = 0 := mul_self_eq_zero.mp (by simpa [squareMonomials] using ht0sq)
  have ht1 : t 1 = 0 := mul_self_eq_zero.mp (by simpa [squareMonomials] using ht1sq)
  funext i
  fin_cases i
  · exact ht0
  · exact ht1

/-- A nonzero scalar multiple of the square parameter eliminates a
one-dimensional character piece. -/
theorem plucker_empty_fin1_of_coeff
    (BK : Matrix (Fin 15) (Fin 1) Ω) (q : Fin 15) (delta : Ω)
    (hdelta : delta ≠ 0)
    (hcoeff : ∀ t : Fin 1 → Ω,
      pluckerValue (BK.mulVec t) q = delta * (t 0 * t 0)) :
    ∀ t : Fin 1 → Ω,
      (∀ q : Fin 15, pluckerValue (BK.mulVec t) q = 0) → t = 0 := by
  intro t hq
  have hz : delta * (t 0 * t 0) = 0 := by rw [← hcoeff]; exact hq q
  have hsq : t 0 * t 0 = 0 := (mul_eq_zero.mp hz).resolve_left hdelta
  have ht : t 0 = 0 := mul_self_eq_zero.mp hsq
  funext i
  fin_cases i
  exact ht

/-- The zero-dimensional character piece is tautologically empty in
projective space. -/
theorem plucker_empty_fin0
    (BK : Matrix (Fin 15) (Fin 0) Ω) :
    ∀ t : Fin 0 → Ω,
      (∀ q : Fin 15, pluckerValue (BK.mulVec t) q = 0) → t = 0 := by
  intro t _
  exact Subsingleton.elim _ _

/-- Linear algebra for one simultaneous `(R,F)` character piece. -/
structure PieceCertificate
    (B : Matrix (Fin 15) (Fin 10) Ω)
    (RM SM : Matrix (Fin 10) (Fin 10) Ω)
    (rotSign reflSign : Ω) (d : Type) [Fintype d] [DecidableEq d] where
  A : Matrix (Fin 20) (Fin 10) Ω
  K : Matrix (Fin 10) d Ω
  Y : Matrix d (Fin 10) Ω
  X : Matrix (Fin 10) (Fin 20) Ω
  action_kernel : ∀ m : Fin 10 → Ω,
    A.mulVec m = 0 ↔
      RM.mulVec m = rotSign • m ∧ SM.mulVec m = reflSign • m
  split_identity : X * A + K * Y = 1
  plucker_empty : ∀ t : d → Ω,
    (∀ q : Fin 15, pluckerValue ((B * K).mulVec t) q = 0) → t = 0

namespace PieceCertificate

variable {B : Matrix (Fin 15) (Fin 10) Ω}
  {RM SM : Matrix (Fin 10) (Fin 10) Ω}
  {rotSign reflSign : Ω} {d : Type} [Fintype d] [DecidableEq d]

/-- The emitted splitting identity expresses every vector in the simultaneous
character kernel in the emitted kernel columns. -/
theorem eq_K_mulVec (C : PieceCertificate B RM SM rotSign reflSign d)
    {m : Fin 10 → Ω}
    (hR : RM.mulVec m = rotSign • m)
    (hF : SM.mulVec m = reflSign • m) :
    m = C.K.mulVec (C.Y.mulVec m) := by
  have hA : C.A.mulVec m = 0 := C.action_kernel m |>.2 ⟨hR, hF⟩
  calc
    m = (1 : Matrix (Fin 10) (Fin 10) Ω).mulVec m := (Matrix.one_mulVec m).symm
    _ = (C.X * C.A + C.K * C.Y).mulVec m := by rw [C.split_identity]
    _ = C.X.mulVec (C.A.mulVec m) + C.K.mulVec (C.Y.mulVec m) := by
      rw [Matrix.add_mulVec, Matrix.mulVec_mulVec, Matrix.mulVec_mulVec]
    _ = C.K.mulVec (C.Y.mulVec m) := by rw [hA, Matrix.mulVec_zero, zero_add]

end PieceCertificate

/-- The common projector/action bridge together with the four character
certificates `(+,+)`, `(+,-)`, `(-,+)`, `(-,-)`. -/
structure Certificate where
  P : Matrix (Fin 15) (Fin 15) Ω
  R : Matrix (Fin 15) (Fin 15) Ω
  F : Matrix (Fin 15) (Fin 15) Ω
  B : Matrix (Fin 15) (Fin 10) Ω
  L : Matrix (Fin 10) (Fin 15) Ω
  RM : Matrix (Fin 10) (Fin 10) Ω
  SM : Matrix (Fin 10) (Fin 10) Ω
  left_inverse : L * B = 1
  projector_factor : B * L * P = P
  rot_restrict : R * B = B * RM
  refl_restrict : F * B = B * SM
  pp : PieceCertificate B RM SM 1 1 (Fin 2)
  pa : PieceCertificate B RM SM 1 (-1) (Fin 0)
  ap : PieceCertificate B RM SM (-1) 1 (Fin 1)
  aa : PieceCertificate B RM SM (-1) (-1) (Fin 1)

namespace Certificate

/-- `L` is a left inverse, so the emitted image basis has injective
coordinate map. -/
theorem B_mulVec_injective (C : Certificate (Ω := Ω)) :
    Function.Injective C.B.mulVec := by
  intro x y h
  have h' := congrArg C.L.mulVec h
  simpa [Matrix.mulVec_mulVec, C.left_inverse] using h'

/-- A projector-fixed ambient vector is recovered from its ten coordinates. -/
theorem B_L_coordinates (C : Certificate (Ω := Ω))
    {v : Fin 15 → Ω} (hP : C.P.mulVec v = v) :
    C.B.mulVec (C.L.mulVec v) = v := by
  calc
    C.B.mulVec (C.L.mulVec v) = (C.B * C.L).mulVec v :=
      Matrix.mulVec_mulVec v C.B C.L
    _ = (C.B * C.L).mulVec (C.P.mulVec v) := by rw [hP]
    _ = (C.B * C.L * C.P).mulVec v := Matrix.mulVec_mulVec v _ _
    _ = C.P.mulVec v := by rw [C.projector_factor]
    _ = v := hP

private theorem restricted_eigen
    (C : Certificate (Ω := Ω))
    {v : Fin 15 → Ω} {c : Ω}
    (hv : C.B.mulVec (C.L.mulVec v) = v)
    (hR : C.R.mulVec v = c • v) :
    C.RM.mulVec (C.L.mulVec v) = c • C.L.mulVec v := by
  apply C.B_mulVec_injective
  calc
    C.B.mulVec (C.RM.mulVec (C.L.mulVec v)) =
        (C.B * C.RM).mulVec (C.L.mulVec v) := Matrix.mulVec_mulVec _ _ _
    _ = (C.R * C.B).mulVec (C.L.mulVec v) := by rw [C.rot_restrict]
    _ = C.R.mulVec (C.B.mulVec (C.L.mulVec v)) :=
      (Matrix.mulVec_mulVec _ _ _).symm
    _ = C.R.mulVec v := by rw [hv]
    _ = c • v := hR
    _ = c • C.B.mulVec (C.L.mulVec v) := by rw [hv]
    _ = C.B.mulVec (c • C.L.mulVec v) := (Matrix.mulVec_smul _ _ _).symm

private theorem restricted_refl_eigen
    (C : Certificate (Ω := Ω))
    {v : Fin 15 → Ω} {c : Ω}
    (hv : C.B.mulVec (C.L.mulVec v) = v)
    (hF : C.F.mulVec v = c • v) :
    C.SM.mulVec (C.L.mulVec v) = c • C.L.mulVec v := by
  apply C.B_mulVec_injective
  calc
    C.B.mulVec (C.SM.mulVec (C.L.mulVec v)) =
        (C.B * C.SM).mulVec (C.L.mulVec v) := Matrix.mulVec_mulVec _ _ _
    _ = (C.F * C.B).mulVec (C.L.mulVec v) := by rw [C.refl_restrict]
    _ = C.F.mulVec (C.B.mulVec (C.L.mulVec v)) :=
      (Matrix.mulVec_mulVec _ _ _).symm
    _ = C.F.mulVec v := by rw [hv]
    _ = c • v := hF
    _ = c • C.B.mulVec (C.L.mulVec v) := by rw [hv]
    _ = C.B.mulVec (c • C.L.mulVec v) := (Matrix.mulVec_smul _ _ _).symm

private theorem no_piece
    (C : Certificate (Ω := Ω))
    {rotSign reflSign : Ω} {d : Type} [Fintype d] [DecidableEq d]
    (D : PieceCertificate C.B C.RM C.SM rotSign reflSign d)
    {v : Fin 15 → Ω}
    (hne : v ≠ 0) (hP : C.P.mulVec v = v)
    (hplucker : ∀ q : Fin 15, pluckerValue v q = 0)
    (hR : C.R.mulVec v = rotSign • v)
    (hF : C.F.mulVec v = reflSign • v) : False := by
  let m := C.L.mulVec v
  have hv : C.B.mulVec m = v := C.B_L_coordinates hP
  have hmR : C.RM.mulVec m = rotSign • m :=
    C.restricted_eigen hv hR
  have hmF : C.SM.mulVec m = reflSign • m :=
    C.restricted_refl_eigen hv hF
  let t := D.Y.mulVec m
  have hm : m = D.K.mulVec t := D.eq_K_mulVec hmR hmF
  have hBK : (C.B * D.K).mulVec t = v := by
    rw [← Matrix.mulVec_mulVec, ← hm, hv]
  have ht : t = 0 := D.plucker_empty t fun q ↦ by rw [hBK]; exact hplucker q
  apply hne
  calc
    v = C.B.mulVec m := hv.symm
    _ = C.B.mulVec (D.K.mulVec t) := by rw [← hm]
    _ = C.B.mulVec (D.K.mulVec 0) := by rw [ht]
    _ = 0 := by simp

theorem no_pp (C : Certificate (Ω := Ω))
    {v : Fin 15 → Ω} (hne : v ≠ 0) (hP : C.P.mulVec v = v)
    (hplucker : ∀ q, pluckerValue v q = 0)
    (hR : C.R.mulVec v = v) (hF : C.F.mulVec v = v) : False :=
  C.no_piece C.pp hne hP hplucker (by simpa using hR) (by simpa using hF)

theorem no_pa (C : Certificate (Ω := Ω))
    {v : Fin 15 → Ω} (hne : v ≠ 0) (hP : C.P.mulVec v = v)
    (hplucker : ∀ q, pluckerValue v q = 0)
    (hR : C.R.mulVec v = v) (hF : C.F.mulVec v = -v) : False :=
  C.no_piece C.pa hne hP hplucker (by simpa using hR) (by simpa using hF)

theorem no_ap (C : Certificate (Ω := Ω))
    {v : Fin 15 → Ω} (hne : v ≠ 0) (hP : C.P.mulVec v = v)
    (hplucker : ∀ q, pluckerValue v q = 0)
    (hR : C.R.mulVec v = -v) (hF : C.F.mulVec v = v) : False :=
  C.no_piece C.ap hne hP hplucker (by simpa using hR) (by simpa using hF)

theorem no_aa (C : Certificate (Ω := Ω))
    {v : Fin 15 → Ω} (hne : v ≠ 0) (hP : C.P.mulVec v = v)
    (hplucker : ∀ q, pluckerValue v q = 0)
    (hR : C.R.mulVec v = -v) (hF : C.F.mulVec v = -v) : False :=
  C.no_piece C.aa hne hP hplucker (by simpa using hR) (by simpa using hF)

/-- If the two matrices satisfy the dihedral relations `F² = 1` and
`FRFR = 1`, the four signed certificates exclude every common projective
eigenline in the Plücker locus.  Indeed, the corresponding eigenvalues must
both be signs, so one of `no_pp`, `no_pa`, `no_ap`, or `no_aa` applies. -/
theorem no_common_projective_eigenline
    (C : Certificate (Ω := Ω))
    (hF2 : C.F * C.F = 1)
    (hFRFR : C.F * C.R * C.F * C.R = 1)
    {v : Fin 15 → Ω} (hne : v ≠ 0)
    (hP : C.P.mulVec v = v)
    (hplucker : ∀ q, pluckerValue v q = 0)
    {a b : Ω}
    (hR : C.R.mulVec v = a • v)
    (hF : C.F.mulVec v = b • v) : False := by
  have hbvec : (b * b) • v = v := by
    calc
      (b * b) • v = b • (b • v) := by rw [smul_smul]
      _ = C.F.mulVec (b • v) := by rw [Matrix.mulVec_smul, hF]
      _ = C.F.mulVec (C.F.mulVec v) := by rw [hF]
      _ = (C.F * C.F).mulVec v := Matrix.mulVec_mulVec _ _ _
      _ = v := by rw [hF2, Matrix.one_mulVec]
  have hb2 : b * b = 1 := by
    have hz : (b * b - 1) • v = 0 := by
      rw [sub_smul, hbvec, one_smul, sub_self]
    exact sub_eq_zero.mp ((smul_eq_zero.mp hz).resolve_right hne)
  have habvec : (b * a * b * a) • v = v := by
    have hop :
        C.F.mulVec (C.R.mulVec (C.F.mulVec (C.R.mulVec v))) =
          (b * a * b * a) • v := by
      simp only [hR, Matrix.mulVec_smul, hF, smul_smul]
      congr 1
      ring
    calc
      (b * a * b * a) • v =
          C.F.mulVec (C.R.mulVec (C.F.mulVec (C.R.mulVec v))) := hop.symm
      _ = (C.F * C.R * C.F * C.R).mulVec v := by
        rw [Matrix.mulVec_mulVec, Matrix.mulVec_mulVec, Matrix.mulVec_mulVec]
      _ = v := by rw [hFRFR, Matrix.one_mulVec]
  have ha2 : a * a = 1 := by
    have hab : b * a * b * a = 1 := by
      have hz : (b * a * b * a - 1) • v = 0 := by
        rw [sub_smul, habvec, one_smul, sub_self]
      exact sub_eq_zero.mp ((smul_eq_zero.mp hz).resolve_right hne)
    calc
      a * a = (b * b) * (a * a) := by rw [hb2, one_mul]
      _ = b * a * b * a := by ring
      _ = 1 := hab
  rcases mul_self_eq_one_iff.mp ha2 with ha | ha <;>
    rcases mul_self_eq_one_iff.mp hb2 with hb | hb
  · exact C.no_pp hne hP hplucker (by simpa [ha] using hR) (by simpa [hb] using hF)
  · exact C.no_pa hne hP hplucker (by simpa [ha] using hR) (by simpa [hb] using hF)
  · exact C.no_ap hne hP hplucker (by simpa [ha] using hR) (by simpa [hb] using hF)
  · exact C.no_aa hne hP hplucker (by simpa [ha] using hR) (by simpa [hb] using hF)

end Certificate

end D12Certificate
end V14Formalization
