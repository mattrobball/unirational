-- forced_foliation_witness.m2
--
-- EXACT worked instance of THEOREM_FORCED_FOLIATION.md, in the theorem's own
-- setting: n = 5, a SMOOTH CUBIC THREEFOLD Y = V(F) in P^4, and an explicit
-- PRIMITIVE polynomial tuple T of degree d = 7 with F(T) = 0 whose induced
-- rational map P^4 --> Y is DOMINANT.  The tuple is not G-covariant (that is
-- exactly the object whose existence is undecided); the equivariance step (9)
-- is tested separately, on a genuinely equivariant toy, in
-- verify_forced_foliation.py.
--
-- Everything below is symbolic over QQ.  No random points, no floating point.
--
-- The cubic:  F = Y2^3 + 3 Y2 Y0^2 + Y3^3 + 3 Y3 Y1^2 + 4 Y4^3.
-- This is the Fermat cubic threefold in disguise: under
--   Y0 = y0-y1, Y1 = y2-y3, Y2 = y0+y1, Y3 = y2+y3, Y4 = y4
-- one has F = 4(y0^3+y1^3+y2^3+y3^3+y4^3).  Smoothness is re-proved below from
-- the partials directly, so the disguise is not load-bearing.
--
-- The tuple: the classical Segre unirationality construction for a cubic
-- hypersurface containing a line.  L = {Y2=Y3=Y4=0} lies on F.  Projection
-- from L exhibits F as the conic bundle
--   Phi_z(Y0,Y1,t) = 3 z0 Y0^2 + 3 z1 Y1^2 + C(z) t^2,  C = z0^3+z1^3+4z2^3,
-- over z in P^2, with the P^4-point (Y0, Y1, t z0, t z1, t z2).  Over the
-- rational surface {z0 u^2 + z1 v^2 = 0} the conic acquires the rational point
-- p = (u:v:0), and the second intersection of the line p q with the conic is
--   X = Phi(q) p - 2 B(p,q) q.
-- Substituting u=x0, v=x1, z=(x1^2, -x0^2, x2^2), q=(x3^2, x4^2, 1) gives a
-- weighted-homogeneous, hence honestly homogeneous, degree-7 tuple in
-- QQ[x0..x4].

needsPackage "Elimination";

RESULT := true;
chk = (name, ok) -> (
  << (if ok then "  ok   " else "  FAIL ") << name << endl;
  if not ok then RESULT = false;
);

R = QQ[x0,x1,x2,x3,x4];
n = 5;

------------------------------------------------------------------
-- 0. the cubic and its smoothness
------------------------------------------------------------------
S = QQ[Y0,Y1,Y2,Y3,Y4];
F = Y2^3 + 3*Y2*Y0^2 + Y3^3 + 3*Y3*Y1^2 + 4*Y4^3;
Jideal = ideal jacobian ideal F;
<< "smoothness of the cubic threefold V(F) in P^4" << endl;
chk("F is a cubic form", (first degree F) == 3 and isHomogeneous F);
chk("the 5 partials of F have only the origin as common zero (dim 0)",
      dim Jideal == 0);
chk("the 5 partials form a regular sequence (codim 5)", codim Jideal == 5);

------------------------------------------------------------------
-- 0b. Jacobian-ring socle degree  (used by DEFECT_IDENTITY.md sec.4)
------------------------------------------------------------------
JR = S/Jideal;
hf = apply(0..8, m -> hilbertFunction(m, JR));
<< "  Jacobian ring Hilbert function, degrees 0..8: " << toList hf << endl;
chk("Hilbert function of the Jacobian ring is (1,5,10,10,5,1,0,0,0)",
      toList hf == {1,5,10,10,5,1,0,0,0});
chk("socle degree is 5: (R/J)_5 nonzero", hilbertFunction(5,JR) == 1);
chk("every form of degree 6 lies in the Jacobian ideal", hilbertFunction(6,JR) == 0);
chk("every form of degree 7 lies in the Jacobian ideal", hilbertFunction(7,JR) == 0);
hess = det jacobian ideal jacobian ideal F;
chk("the Hessian of F is a nonzero form of degree 5", hess != 0 and (first degree hess) == 5);
chk("the Hessian is NOT in the Jacobian ideal (it spans the socle)",
      hess % Jideal != 0);

------------------------------------------------------------------
-- 0c. the SAME socle computation for the ACTUAL Klein cubic
--     F_K = x0^2 x1 + x1^2 x2 + x2^2 x3 + x3^2 x4 + x4^2 x0.
--     This is the one used by DEFECT_IDENTITY.md section 4.
------------------------------------------------------------------
RK = QQ[w0,w1,w2,w3,w4];
FK = sum(0..4, i -> (gens RK)#i^2 * (gens RK)#((i+1)%5));
JK = ideal jacobian ideal FK;
chk("Klein cubic: partials cut out only the origin (smooth)", dim JK == 0);
chk("Klein cubic: partials are a regular sequence (codim 5)", codim JK == 5);
KR = RK/JK;
hfK = apply(0..8, m -> hilbertFunction(m, KR));
<< "  Klein Jacobian ring Hilbert function, degrees 0..8: " << toList hfK << endl;
chk("Klein Jacobian ring Hilbert function is (1,5,10,10,5,1,0,0,0)",
      toList hfK == {1,5,10,10,5,1,0,0,0});
chk("Klein: socle degree 5, and (R/J)_m = 0 for m = 6,7,8",
      hilbertFunction(5,KR) == 1 and hilbertFunction(6,KR) == 0
      and hilbertFunction(7,KR) == 0 and hilbertFunction(8,KR) == 0);
-- the first-order tangent-extension gate (18): H + sum F_i(x) Q_i = F R.
-- Solvability for a GIVEN H is exactly H in J + (F) = J (Euler: 3F = sum x_i F_i).
chk("Euler: 3 F_K = sum x_i dF_K/dx_i, so F_K lies in its own Jacobian ideal",
      3*FK - sum(0..4, i -> (gens RK)#i * diff((gens RK)#i, FK)) == 0
      and FK % JK == 0);
-- an explicit witness that the gate is NOT vacuous in degree 5: the Hessian.
hessK = det jacobian ideal jacobian ideal FK;
chk("Klein: the degree-5 Hessian is not in the Jacobian ideal, so the gate is a "
    | "genuine (one-dimensional) condition exactly in degree 5",
      hessK != 0 and (first degree hessK) == 5 and hessK % JK != 0);

------------------------------------------------------------------
-- 1. the tuple T
------------------------------------------------------------------
u = x0; v = x1; mu = x2^2; al = x3^2; be = x4^2;
z0 = v^2; z1 = -u^2; z2 = mu;
Cz = z0^3 + z1^3 + 4*z2^3;
Bpq = 3*z0*u*al + 3*z1*v*be;          -- B(p,q), p = (u,v,0), q = (al,be,1)
Phq = 3*z0*al^2 + 3*z1*be^2 + Cz;     -- Phi(q)
X0 = Phq*u - 2*Bpq*al;
X1 = Phq*v - 2*Bpq*be;
Xt = -2*Bpq;
T = {X0, X1, Xt*z0, Xt*z1, Xt*z2};
d = 7;

phi = map(R, S, T);                    -- substitution Y_i |-> T_i

<< endl << "the tuple T (degree " << d << ")" << endl;
chk("T is homogeneous of degree d = 7 in every coordinate",
      all(T, f -> f != 0 and isHomogeneous f and (first degree f) == d));
chk("(4) F(T) = 0 identically", phi F == 0);
chk("T is PRIMITIVE: gcd(T_0,...,T_4) = 1", gcd T == 1);

------------------------------------------------------------------
-- 2. Jacobian, gradient, chain rule (5), dominance
------------------------------------------------------------------
J = transpose jacobian matrix{T};      -- J_(i,j) = d T_i / d x_j
Q = transpose matrix{apply(gens S, Yi -> phi diff(Yi, F))};   -- column Q = grad F (T)

chk("J has entries of degree d-1 = 6",
      all(flatten entries J, e -> e == 0 or (first degree e) == 6));
chk("Q has entries of degree 2d = 14",
      all(flatten entries Q, e -> e == 0 or (first degree e) == 14));
chk("(5) chain rule: Q^t J = 0", (transpose Q)*J == 0);
chk("det J = 0 identically (T lands in the cubic cone)", det J == 0);

-- dominance: rank J = 4 at one exact rational point is enough, since
-- rank is lower semicontinuous and rank <= 4 everywhere by (5).
ptmap = map(QQ, R, {2_QQ, 3_QQ, 5_QQ, 7_QQ, 11_QQ});
Jpt = matrix apply(entries J, row -> apply(row, e -> ptmap e));
chk("DOMINANCE: rank J_T = 4 at the exact point (2,3,5,7,11)", rank Jpt == 4);
Qpt = matrix apply(entries Q, row -> apply(row, e -> ptmap e));
chk("Q_T is nonzero at that point", Qpt != 0);

------------------------------------------------------------------
-- 3. primitivity of the pulled-back gradient
------------------------------------------------------------------
chk("Q_T is PRIMITIVE: gcd of the five F_i(T) is 1",
      gcd flatten entries Q == 1);

------------------------------------------------------------------
-- 4. the adjugate, and the forced covariant P_T
------------------------------------------------------------------
-- adj(J)_(i,j) = (-1)^(i+j) det( J with row j and column i deleted )
adjJ = matrix table(n, n, (i,j) -> (-1)^(i+j) * det submatrix'(J, {j}, {i}));
chk("adj(J) J = 0", adjJ*J == 0);
chk("J adj(J) = 0", J*adjJ == 0);
chk("adj(J) is nonzero (generic rank of J is exactly 4)", adjJ != 0);
chk("adj(J) has entries of degree 4(d-1) = 24",
      all(flatten entries adjJ, e -> e == 0 or (first degree e) == 24));

-- extract P_T by exact division of one column of adj(J) by one entry of Q.
-- any j with Q_j != 0 must give the same answer; we verify that too.
j0 = 0;
Qj0 = Q_(j0,0);
Pcol = matrix table(n, 1, (i,k) -> adjJ_(i,j0) // Qj0);
chk("the division adj(J)_(i,j0) / Q_(j0) is EXACT (no remainder)",
      all(0..n-1, i -> adjJ_(i,j0) % Qj0 == 0));
chk("(7) deg P_T = 2d-4 = 10",
      all(flatten entries Pcol, e -> e == 0 or (first degree e) == 10));
chk("P_T is nonzero", Pcol != 0);

chk("(6) adj(J_T) = P_T Q_T^t  (all 25 entries)", adjJ == Pcol*(transpose Q));
chk("UNIQUENESS: P_T does not depend on the column used (all five agree)",
      all(0..n-1, j -> Q_(j,0) == 0 or
            matrix table(n,1,(i,k) -> adjJ_(i,j) // Q_(j,0)) == Pcol));

------------------------------------------------------------------
-- 5. (8) J_T P_T = 0, (10) the T_i are first integrals
------------------------------------------------------------------
chk("(8) J_T P_T = 0", J*Pcol == 0);
DP = f -> sum(0..n-1, i -> Pcol_(i,0) * diff((gens R)#i, f));
chk("(10) D_{P_T}(T_i) = 0 for all five landing coordinates",
      all(T, f -> DP f == 0));
chk("(10') D_{P_T}(F_i(T)) = 0 for all five pulled-back partials",
      all(flatten entries Q, f -> DP f == 0));

------------------------------------------------------------------
-- 6. (11) Piola, (12) divergence-free
------------------------------------------------------------------
-- cof(J) = adj(J)^t ; Piola: sum_j d/dx_j cof(J)_(i,j) = 0 for every i.
cofJ = transpose adjJ;
chk("(11) Piola identity for J_T: every row of cof(J_T) is divergence-free",
      all(0..n-1, i -> sum(0..n-1, j -> diff((gens R)#j, cofJ_(i,j))) == 0));
divP = sum(0..n-1, i -> diff((gens R)#i, Pcol_(i,0)));
<< "  div P_T = " << divP << endl;
chk("(12) div P_T = 0", divP == 0);

------------------------------------------------------------------
-- 7. the foliation is genuinely two-dimensional in its dependence:
--    P_T is not a constant vector field times a scalar (i.e. the leaves are
--    not the lines of a fixed pencil) -- this rules out the degenerate
--    instances in which T factors through a linear projection.
------------------------------------------------------------------
Pl = flatten entries Pcol;
Pg = gcd Pl;
Pred = apply(Pl, f -> f // Pg);
<< "  gcd of the components of P_T has degree "
   << (if Pg == 0 then -1 else first degree Pg) << endl;
chk("P_T/gcd is not a constant vector: the leaves are not a pencil of lines",
      not all(Pred, f -> f == 0 or (first degree f) == 0));

------------------------------------------------------------------
-- 8. first integrals: the field they generate
------------------------------------------------------------------
-- the leaves are the fibres of T, which are curves; we confirm the fibre
-- dimension by the rank computation above (rank J = 4 => 1-dimensional fibres).
chk("fibre dimension of T is 1 (5 - rank J_T = 1), so the foliation has rank one",
      5 - rank Jpt == 1);

<< endl << (if RESULT then "RESULT: PASS" else "RESULT: FAIL") << endl;
if not RESULT then exit 1;
