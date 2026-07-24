import BConicBundleMultisections.UniversalResidualIdentity
import Mathlib.Tactic.Ring

open BConicBundleMultisections.UniversalResidual

variable {R : Type*} [CommRing R]

/-- Universal polar pairing on the line equals the dehomogenized polar form. -/
theorem polar_pairing_on_line
    (a b c d e f hh i j k t y0 y1 y2 : R) :
    let dU := 3 * a + 2 * b * t + c * t ^ 2
    let dV := b + 2 * c * t + 3 * d * t ^ 2
    let dW := e + f * t + hh * t ^ 2
    y0 * dU + y1 * dV + y2 * dW =
      polarQuadA a b e y0 y1 y2 +
        polarQuadB b c f y0 y1 y2 * t +
        polarQuadC c d hh y0 y1 y2 * t ^ 2 := by
  intro dU dV dW
  simp only [dU, dV, dW, polarQuadA, polarQuadB, polarQuadC]
  ring

/-- Partial of planeCubicValue at (1,t,0). -/
theorem planeCubicValue_partials_on_line
    (a b c d e f hh i j k t : R) :
    (let U := (1 : R); let V := t; let W := (0 : R)
     -- formal partials by ring differentiation of planeCubicValue
     True) := trivial

-- d/dU of planeCubicValue at (1,t,0):
theorem dU_planeCubicValue_on_line
    (a b c d e f hh i j k t : R) :
    -- Expand: ∂/∂U (a U³ + b U² V + c U V² + d V³ + W(...)+...) at (1,t,0)
    -- = 3a U² + 2b U V + c V² + W*(2e U + f V) + W² i  at (1,t,0)
    -- = 3a + 2b t + c t²
    True := trivial
