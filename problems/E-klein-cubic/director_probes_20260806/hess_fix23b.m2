p = 397; kk = ZZ/p
w = null; s33 = null;
for t from 2 to p-1 do (tk = t_kk; if tk^3 == 1 and tk != 1 then (w = tk; break));
for t from 1 to p-1 do (tk = t_kk; if tk^2 == 33_kk then (s33 = tk; break));
kp = (13_kk + 3_kk*s33) / 16_kk; km = (13_kk - 3_kk*s33) / 16_kk;
<< "check trace: " << (kp + km == 13_kk/8_kk, kp*km == -1_kk/2_kk) << endl
R = kk[a,b,x,y,z]
F = kp*a^3 + km*b^3 + (a+b)*x^2 + (w*a + w^2*b)*y^2 + (w^2*a + w*b)*z^2 + x*y*z
H = det matrix table(5,5,(i,j) -> diff(R_i, diff(R_j, F)))
I = saturate(ideal H + ideal jacobian matrix{{H}}, ideal vars R);
<< "degree: " << degree I << "  HP: " << hilbertPolynomial(I, Projective=>false) << endl
Iplus = I + ideal(y, z); Iminus = I + ideal(a, b, x);
<< "C cap P(V+): dim " << dim Iplus << " deg " << degree Iplus << endl
<< "C cap P(V-): dim " << dim Iminus << " deg " << degree Iminus << endl
pts = {matrix{{1_kk,0,0,0,0}}, matrix{{0,1_kk,0,0,0}}, matrix{{0_kk,0,1,1,1}}, matrix{{0_kk,0,1,w,w^2}}, matrix{{0_kk,0,1,w^2,w}}};
names' = {"pa[w]","pb[w2]","q1[1]","qw[w]","qw2[w2]"};
scan(5, i -> (
  onC = all(flatten entries gens I, f -> sub(f, pts#i) == 0);
  << names'#i << " on C: " << onC << endl;
  if onC then (
    K = gens ker transpose sub(jacobian gens I, pts#i);
    << "  tangent kernel (cols): " << transpose K << endl;
  );
))
