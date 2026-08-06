p = 397; kk = ZZ/p
w = null; s33 = null;
for t from 2 to p-1 do (tk = t_kk; if tk^3 == 1 and tk != 1 then (w = tk; break));
for t from 1 to p-1 do (tk = t_kk; if tk^2 == 33_kk then (s33 = tk; break));
kp = (13_kk + 3_kk*s33) / 16_kk; km = (13_kk - 3_kk*s33) / 16_kk;
R = kk[a,b,x,y,z]
F = kp*a^3 + km*b^3 + (a+b)*x^2 + (w*a + w^2*b)*y^2 + (w^2*a + w*b)*z^2 + x*y*z
H = det matrix table(5,5,(i,j) -> diff(R_i, diff(R_j, F)))
I = saturate(ideal H + ideal jacobian matrix{{H}}, ideal vars R);
-- the four rho-fixed points (from the split quadratics)
ptA1 = matrix{{1_kk, 0, -167_kk, -167_kk*w, -167_kk*w^2}}
ptA2 = matrix{{1_kk, 0, 54_kk, 54_kk*w, 54_kk*w^2}}
ptB1 = matrix{{0_kk, 1, -191_kk, -191_kk*w^2, -191_kk*w}}
ptB2 = matrix{{0_kk, 1, -141_kk, -141_kk*w^2, -141_kk*w}}
pts = {ptA1, ptA2, ptB1, ptB2}; names' = {"A1(Vw)","A2(Vw)","B1(Vw2)","B2(Vw2)"};
-- eigenbasis change: rows = eigencoordinates (a; b; (1,1,1)/3-comp; (1,w2,w)-dual for Vw-comp?; ...)
-- decompose tangent vector v = (da,db,dx,dy,dz): components:
--   c_a = da (weight w), c_b = db (w2), and (dx,dy,dz) = c1*(1,1,1) + cw*(1,w,w2) + cw2*(1,w2,w)
-- solve: cw = (dx + w2*dy + w*dz)/3 etc.
scan(4, i -> (
  pt = pts#i;
  onC = all(flatten entries gens I, f -> sub(f, pt) == 0);
  K = gens ker transpose sub(jacobian gens I, pt);
  << names'#i << " on C: " << onC << "  kernel dim: " << numColumns K << endl;
  -- kernel is 2-dim: Euler (the point) + tangent; pick a kernel vector independent of pt
  v1 = K_{0}; v2 = K_{1};
  -- tangent rep: v2 - proj onto pt... just take both, decompose both, report eigencomponents
  scan({v1, v2}, v -> (
    da = v_(0,0); db = v_(1,0); dx = v_(2,0); dy = v_(3,0); dz = v_(4,0);
    c1 = (dx + dy + dz)/3_kk; cw = (dx + w^2*dy + w*dz)/3_kk; cw2 = (dx + w*dy + w^2*dz)/3_kk;
    << "   v: comps  a:" << da << " b:" << db << " (111):" << c1 << " (1ww2):" << cw << " (1w2w):" << cw2 << endl;
  ));
))
