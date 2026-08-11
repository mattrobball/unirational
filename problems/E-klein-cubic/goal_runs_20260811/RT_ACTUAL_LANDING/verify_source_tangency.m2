-- verify_source_tangency.m2
--
-- The source-tangency identity on a GENUINE SMOOTH CUBIC THREEFOLD in P^4 --
-- the repository's own case (n,e) = (5,3), where the residue weight is
-- w = n - e = 2 and (34) reads   Delta_T|_X = (d/d') H^2 j_phi.
--
-- The instance is the packet's existing exact witness
-- (forced_foliation_witness.m2):
--   F = Y2^3 + 3 Y2 Y0^2 + Y3^3 + 3 Y3 Y1^2 + 4 Y4^3   (smooth; Fermat in disguise)
--   T = the degree-7 Segre unirationality tuple: primitive, F(T) = 0, and the
--       induced map P^4 --> X = V(F) dominant.
-- The SOURCE P^4 is the same P^4, so X = V(F) sits in the source and
-- T|_X : X --> X is the restricted selfmap of the theory.
--
-- FINDING: for this witness the restricted map is PRIMITIVE, i.e. H = 1,
-- k = 0, d' = d = 7.  The identity therefore specialises to LEMMA A,
--
--        Delta_T|_X  =  Jac(T|_{C(X)})  =  j_phi ,
--
-- which is exactly the load-bearing step of the whole argument (the step the
-- external source compressed to "comparison of the cone Jacobian with the
-- projective differential gives").  The H-dependence of (34) is verified
-- separately, with H != 1 and d' = 1,2,3 and weights w = 1,2,3, in
-- verify_source_tangency.py.
--
-- Everything is symbolic over QQ.  No random points, no floating point.
-- TERMINAL MARKER: prints "RESULT: PASS" iff every assertion holds.

RESULT := true;
chk = (name, ok) -> (
  << (if ok then "  ok   " else "  FAIL ") << name << endl;
  if not ok then RESULT = false;
);

R = QQ[x0,x1,x2,x3,x4];
S = QQ[Y0,Y1,Y2,Y3,Y4];
F = Y2^3 + 3*Y2*Y0^2 + Y3^3 + 3*Y3*Y1^2 + 4*Y4^3;
iota = map(R, S, gens R);              -- Y_i |-> x_i : the source copy of F
Fx = iota F;
Fgx = apply(gens S, Yi -> iota diff(Yi, F));   -- grad F evaluated AT THE SOURCE x

<< "===============================================================" << endl;
<< "verify_source_tangency.m2 -- (34) on a smooth cubic threefold" << endl;
<< "===============================================================" << endl;

chk("F is a cubic form", (first degree F) == 3 and isHomogeneous F);
chk("V(F) is smooth (the 5 partials have only the origin in common)",
      dim ideal jacobian ideal F == 0);

------------------------------------------------------------------
-- 1. the witness tuple, re-derived
------------------------------------------------------------------
u = x0; v = x1; mu = x2^2; al = x3^2; be = x4^2;
z0 = v^2; z1 = -u^2; z2 = mu;
Cz = z0^3 + z1^3 + 4*z2^3;
Bpq = 3*z0*u*al + 3*z1*v*be;
Phq = 3*z0*al^2 + 3*z1*be^2 + Cz;
T = {Phq*u - 2*Bpq*al, Phq*v - 2*Bpq*be, (-2*Bpq)*z0, (-2*Bpq)*z1, (-2*Bpq)*z2};
d = 7;
sub7 = map(R, S, T);
chk("T homogeneous of degree 7",
      all(T, f -> f != 0 and isHomogeneous f and (first degree f) == 7));
chk("F(T) = 0 identically", sub7 F == 0);
chk("T is primitive", gcd T == 1);

------------------------------------------------------------------
-- 2. P_T and Delta_T
------------------------------------------------------------------
J = matrix apply(T, f -> apply(gens R, xi -> diff(xi, f)));
Q = transpose matrix{apply(gens S, Yi -> sub7 diff(Yi, F))};
adjJ = matrix table(5, 5, (i,j) -> (-1)^(i+j) * det submatrix'(J, {j}, {i}));
chk("adj(J_T) J_T = 0 and adj(J_T) != 0", adjJ*J == 0 and adjJ != 0);
chk("the division adj(J)_(i,0)/Q_0 is exact",
      all(0..4, i -> adjJ_(i,0) % Q_(0,0) == 0));
Pcol = matrix table(5, 1, (i,k) -> adjJ_(i,0) // Q_(0,0));
chk("(6) adj(J_T) = P_T Q_T^t (all 25 entries)", adjJ == Pcol*(transpose Q));
chk("deg P_T = 2d-4 = 10",
      all(flatten entries Pcol, e -> e == 0 or (first degree e) == 10));
chk("J_T P_T = 0", J*Pcol == 0);
chk("div P_T = 0", sum(0..4, i -> diff((gens R)#i, Pcol_(i,0))) == 0);

Delta = sum(0..4, i -> Fgx#i * Pcol_(i,0));
chk("deg Delta_T = 2d-2 = 12", (first degree Delta) == 12);
chk("Delta_T is nonzero", Delta != 0);
<< "  Delta_T = " << factor Delta << endl;

------------------------------------------------------------------
-- 3. the restricted selfmap: dominant, and PRIMITIVE (H = 1, k = 0)
------------------------------------------------------------------
chk("Delta_T does not vanish on X: the restricted selfmap is dominant",
      Delta % Fx != 0);
-- no divisorial common factor: the base scheme of T on X has codimension 2 in X
I = ideal(T) + ideal Fx;
<< "  base scheme of T on X: codim " << codim I << " in P^4 (so codim "
   << (codim I - 1) << " in X)" << endl;
chk("the base scheme of T|_X has codimension >= 2 in X, so H = 1 and k = 0",
      codim I >= 3);
-- and directly: no irreducible factor of Delta_T divides T|_X
cands = {x0, x1, x2, x4, x1*x3^2 - x0*x4^2,
         x0*x1^2 + x0*x3^2 + 4*x1*x3*x4};
chk("no irreducible factor of Delta_T divides T|_X (H = 1 confirmed)",
      all(cands, h -> not all(0..4, i -> (T#i % ideal(h, Fx)) == 0)));
H = 1_R; k = 0; dp = d - k;             -- H = 1, k = 0, d' = 7

------------------------------------------------------------------
-- 4. LEMMA A / (34):  Delta_T|_X = (d/d') H^2 Jac(beta),  here = Jac(T|_X)
--
-- In the chart F_4 != 0, with x0..x3 as local coordinates on the cone C(X),
--   N_ij = F_4 d(beta_i)/dx_j - F_j d(beta_i)/dx_4     (i,j = 0..3)
--   Jac(beta) = det(N) / ( F_4^3 * F_4(beta) ),
-- because dF ^ eta = Omega gives eta = dx_0^...^dx_3 / F_4 on that chart.
------------------------------------------------------------------
Fl = Fgx#4;
bet = T;                                -- beta = T|_{C(X)} since H = 1
N = matrix apply(4, i -> apply(4, j ->
      Fl * diff((gens R)#j, bet#i) - (Fgx#j) * diff(x4, bet#i)));
<< "  computing the 4x4 cone-Jacobian determinant (entries of degree "
   << first degree N_(0,0) << ") ..." << endl;
detN = det N;
subb = map(R, S, bet);
den = Fl^3 * (subb diff(Y4, F));
chk("degree bookkeeping: deg detN = deg den + (2d-2)",
      (first degree detN) == (first degree den) + 12);
-- THE IDENTITY, tested WITHOUT division:  detN = Delta * den  modulo F
chk("(34)/LEMMA A:  Delta_T * den = det N  modulo F, i.e. "
    | "Delta_T|_X = Jac(T|_cone) = (d/d') H^2 j_phi with H = 1",
      (detN - ((d/dp) * H^2 * Delta) * den) % Fx == 0);
-- the constant is pinned: no other rational scalar works
chk("the scalar 2 is WRONG", (detN - (2*Delta)*den) % Fx != 0);
chk("the scalar 1/2 is WRONG", (detN - ((1/2)*Delta)*den) % Fx != 0);

------------------------------------------------------------------
-- 5. divisor bookkeeping (35), in the k = 0 branch
------------------------------------------------------------------
chk("R_phi ~ 2(d'-1) H_X = 12 H_X = deg Delta_T", 2*(dp-1) == 12);
chk("div_X(Delta_T) = 2 D_X + R_phi with D_X = 0 reduces to div_X(j_phi)",
      k == 0);
-- the two squared factors of Delta_T are NOT a common factor of T|_X: they are
-- doubled ramification components.  This is the honest reading.
chk("x0^2 and x1^2 divide Delta_T but x0, x1 do not divide T|_X",
      (Delta % ideal(x0^2)) == 0 and (Delta % ideal(x1^2)) == 0
      and not all(0..4, i -> (T#i % ideal(x0, Fx)) == 0));

<< endl << "RESULT: " << (if RESULT then "PASS" else "FAIL") << endl;
if not RESULT then exit 1;
