# FIX-C5 : OSCAR route for the branch quartic Delta_v.
# packet goal_runs_after_9094303/FIX_C5_BRANCH_QUARTIC ; theory sec. 5.18-5.19
#
# Field: K = Q(u) with u^4 + 28u^2 + 64 = 0, a PRIMITIVE element for
#        Q(sqrt-3, sqrt-11) = Q(om, nu) = the frame field:
#            u  = delta + nu   (delta = om - om^2 = 2om+1, delta^2 = -3, nu^2 = -11)
#            delta = (u^2+8)/(2u),   om = (delta-1)/2,
#            nu    = u - delta,      sqrt33 = -nu*delta = -(u^2+14)/2 .
#        (The identity (delta+nu)(delta-nu) = delta^2-nu^2 = 8 gives delta-nu = 8/u.)
#
# Everything exact; no floating point.   run:  julia c5_oscar.jl

using Oscar

println("== FIX-C5 / OSCAR ", Oscar.VERSION_NUMBER, " ==")

Qx, X = polynomial_ring(QQ, :X)
K, u = number_field(X^4 + 28*X^2 + 64, "u")
delta = (u^2 + 8)//(2*u)
om    = (delta - 1)//2
nu    = u - delta
s33   = -(u^2 + 14)//2

@assert om^2 + om + 1 == 0
@assert nu^2 == -11
@assert delta^2 == -3
@assert s33^2 == 33
@assert s33 == -nu*delta
@assert delta == 2*om + 1
println("field K = Q(u), u^4+28u^2+64 : om, nu, delta, sqrt33 all verified")

R, (a, b, y, z) = polynomial_ring(K, [:a, :b, :y, :z])
kp = (13 + 3*s33)//16
km = (13 - 3*s33)//16
@assert kp + km == 13//8
@assert kp * km == -1//2
Q1 = a + b
Q2 = om*a + om^2*b
Q3 = om^2*a + om*b
C  = kp*a^3 + km*b^3
c  = one(K)
D  = c^2*y^2*z^2 - 4*Q1*(Q2*y^2 + Q3*z^2 + C)
println("Delta_v = ", D)
@assert is_homogeneous(D) && total_degree(D) == 4

# ---------------------------------------------------------------- (1) factor
fa = factor(D)
println("factor(Delta_v): number of irreducible factors = ", length(fa))
for (p, e) in fa
    println("    multiplicity ", e, ", degree ", total_degree(p))
end
@assert length(fa) == 1
@assert first(fa)[2] == 1
println("VERDICT: Delta_v is IRREDUCIBLE over K (single factor, multiplicity 1).")

# controls: the factoriser must be able to see a factorisation when there is one
fc = factor((a*b - y*z)*(a^2 + b^2 + y^2 + z^2))
println("CONTROL reducible quartic: ", length(fc), " factors (expected 2)")
@assert length(fc) == 2
fq = factor((a^2 + b^2 + y^2 + z^2)^2)
println("CONTROL square quartic:    multiplicity ", first(fq)[2], " (expected 2)")
@assert first(fq)[2] == 2

# ------------------------------------------------------- (2) singular locus
J = ideal(R, [derivative(D, t) for t in [a, b, y, z]])
irr = ideal(R, [a, b, y, z])
Js = saturation(J, irr)
println("Sing = unit ideal? ", is_one(Js))
println("dim(affine cone over Sing) = ", dim(Js), "   PROJECTIVE dim = ", dim(Js) - 1)
println("degree Sing = ", degree(Js))
println("Sing is radical? ", Js == radical(Js))
@assert !is_one(Js)
@assert dim(Js) == 1          # affine cone over a 0-dimensional projective scheme
@assert degree(Js) == 6
@assert Js == radical(Js)

pd = primary_decomposition(Js)
println("number of primary components over K: ", length(pd))
for (i, (q, p)) in enumerate(pd)
    println("  component ", i, " : proj dim ", dim(p) - 1, ", degree ", degree(p),
            ", primary == prime? ", q == p)
    println("      P = ", gens(p))
end
@assert length(pd) == 4
@assert sort([degree(p) for (q, p) in pd]) == [1, 1, 2, 2]
@assert all(q == p for (q, p) in pd)

# all six nodes lie on {Q1 = 0}
println("Q1 vanishes on Sing? ", Q1 in Js)
@assert Q1 in Js

# ------------------------------------- (3) contracted locus = incidence system
I5 = ideal(R, [Q1, c*y*z, C + Q2*y^2 + Q3*z^2])
Is = saturation(I5, irr)
println("contracted locus: proj dim ", dim(Is) - 1, ", degree ", degree(Is))
println("contracted locus == Sing(Delta_v)  (as IDEALS)? ", Is == Js)
@assert Is == Js

# ------------------------------------------- (4) the quotient by V4, in P(1,1,2,2)
S, (aa, bb, YY, ZZ) = polynomial_ring(K, [:a, :b, :Y, :Z])
Q1s = aa + bb; Q2s = om*aa + om^2*bb; Q3s = om^2*aa + om*bb
Cs  = kp*aa^3 + km*bb^3
Dbar = YY*ZZ - 4*Q1s*(Q2s*YY + Q3s*ZZ + Cs)
hyp  = (YY - 4*Q1s*Q3s)*(ZZ - 4*Q1s*Q2s) - 4*Q1s*(4*Q1s*Q2s*Q3s + Cs)
println("Delta_bar == hyperbola form? ", Dbar == hyp)
@assert Dbar == hyp
println("4 Q1Q2Q3 + C == (4+kp)a^3 + (4+km)b^3 ? ",
        4*Q1s*Q2s*Q3s + Cs == (4 + kp)*aa^3 + (4 + km)*bb^3)
@assert 4*Q1s*Q2s*Q3s + Cs == (4 + kp)*aa^3 + (4 + km)*bb^3
println("(4+kp)(4+km) = ", (4 + kp)*(4 + km), "   (nonzero => the cubic is honest)")
@assert (4 + kp)*(4 + km) == 22

println("FIX_C5_OSCAR_OK")
