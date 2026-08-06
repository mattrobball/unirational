p = 397; kk = ZZ/p
w = null; s33 = null; r3 = null;
for t from 2 to p-1 do (tk = t_kk; if tk^3 == 1 and tk != 1 then (w = tk; break));
for t from 1 to p-1 do (tk = t_kk; if tk^2 == 33_kk then (s33 = tk; break));
r3 = 2*w + 1  -- sqrt(-3)
kp = (13_kk + 3_kk*s33) / 16_kk; km = (13_kk - 3_kk*s33) / 16_kk;
R = kk[a,b,x,y,z]
F = kp*a^3 + km*b^3 + (a+b)*x^2 + (w*a + w^2*b)*y^2 + (w^2*a + w*b)*z^2 + x*y*z
H = det matrix table(5,5,(i,j) -> diff(R_i, diff(R_j, F)))
I = saturate(ideal H + ideal jacobian matrix{{H}}, ideal vars R);
Iplus = saturate(I + ideal(y, z), ideal vars R);
-- conic parameterization
T = kk[t]
par = map(T, R, {(t-2)*(t+2), -4*(t+1), -2*(t^2+2*t+4), 0_T, 0_T});
<< "param on conic check: " << (par (x^2 - 4*(a^2-a*b+b^2)) == 0) << endl
gs = apply(flatten entries gens Iplus, g -> par g);
gs = select(gs, g -> g != 0);
sx = gs#0; scan(drop(gs,1), g -> sx = gcd(sx, g));
<< "sextet poly degree: " << first degree sx << endl
-- conjugate to s: t = (t2*s - t1)/(s-1), t12 = -1 +- r3; check evenness
S2 = kk[s]
t1 = -1 + r3; t2 = -1 - r3;
n = first degree sx
cf = apply(n+1, i -> coefficient(t^i, sx));
-- numerator of sx(t(s)): sum cf_i (t2 s - t1)^i (s-1)^(n-i)
ps = sum(0..n, i -> cf#i * (t2*s - t1)^i * (s - 1)^(n-i));
<< "s-poly degree: " << first degree ps << endl
oddc = select(1..n, i -> odd i and coefficient(s^i, ps) != 0);
<< "odd coefficients nonzero at: " << oddc << endl
-- if even: cubic in u = s^2, compute j of v^2 = c(u) and v^2 = u c(u)
if #oddc == 0 then (
  U = kk[u];
  c3 = coefficient(s^6, ps); c2 = coefficient(s^4, ps); c1 = coefficient(s^2, ps); c0 = coefficient(s^0, ps);
  -- monic normalize
  a2 = c2/c3; a1 = c1/c3; a0 = c0/c3;
  g2 = (4_kk/3)*a2^2 - 4*a1; g3 = (-8_kk/27)*a2^3 + (4_kk/3)*a1*a2 - 4*a0;
  jp = 1728 * g2^3 / (g2^3 - 27*g3^2);
  << "j(E'+) mod p: " << jp << "   [-32768 mod p = " << (-32768_kk) << ", 8192/11 = " << (8192_kk/11) << "]" << endl;
  -- E'-: v^2 = u*c(u): binary quartic invariants
  b4 = 1_kk; b3 = a2; b2 = a1; b1 = a0; b0 = 0_kk;
  Sq = b0*b4 - b1*b3/4 + b2^2/12;
  Tq = b0*b2*b4/6 - b0*b3^2/16 - b1^2*b4/16 + b1*b2*b3/48 - b2^3/216;
  jm = 1728*Sq^3/(Sq^3 - 27*Tq^2);
  << "j(E'-) mod p: " << jm << endl;
)
