import Mathlib.LinearAlgebra.Matrix.ProjectiveSpecialLinearGroup
import Mathlib.Data.ZMod.Basic
open scoped MatrixGroups
open Classical
#synth DecidableEq (SpecialLinearGroup (Fin 2) (ZMod 11))
#synth Fintype (SpecialLinearGroup (Fin 2) (ZMod 11))
#synth DecidableEq (PSL(2, ZMod 11))
example : (1 : PSL(2, ZMod 11)) = 1 := by decide
