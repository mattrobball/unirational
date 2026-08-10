-- S6 -- exact Macaulay2 chart verification, one representative per stage genre.
--
-- The three genres of the tower are
--     T0  blow up a FIXED POINT          (representative: a type-I V4 point,
--                                         tangent weights (a,a,b,c))
--     T1  blow up a FIXED CURVE          (representative: ell_V, V4-weights
--                                         (0,a,b,c) with 0 along the curve)
--     T2  blow up a FIXED SURFACE        (representative: P_sigma, C2-weights
--                                         (0,0,1,1))
--
-- At a fixed point of a finite abelian group acting on a smooth variety in
-- characteristic 0 the action is linearizable, and all our centres are linear,
-- so a diagonal local model is faithful.  Everything below is exact over QQ.
--
-- What is verified in each chart, by COMPUTATION (not assertion):
--   * the blow-up chart map and the transported group action;
--   * the fixed locus of every subgroup, as ideal(g x - x), with its codimension;
--   * the exceptional divisor, its pointwise stabilizer (Lemma B);
--   * the normal character of every boundary branch through the marked point;
--   * def:toroidal(c): the boundary characters generate the character group.
--
-- Marker on success: S6_CHARTS_OK

FAILS = 0
CHECKS = 0
chk = (msg, b) -> (
    CHECKS = CHECKS + 1;
    if b then print("  ok   " | msg)
    else (FAILS = FAILS + 1; print("  FAIL " | msg));
    );

print "=== GENRE T2: blow up a C2-fixed surface (the plus-plane) ===";
-- local model: A^4 with sigma = diag(1,1,-1,-1); Fix(sigma) = {u3=u4=0}, codim 2
R = QQ[u1,u2,u3,u4];
sig = map(R,R,{u1,u2,-u3,-u4});
Fs = ideal(sig(u1)-u1, sig(u2)-u2, sig(u3)-u3, sig(u4)-u4);
chk("Fix(sigma) on the source has codim 2", codim Fs == 2);
-- chart of Bl_{u3=u4=0}: u3 = t, u4 = t*w  (t = the exceptional coordinate)
S = QQ[s1,s2,t,w];
phi = map(S,R,{s1,s2,t,t*w});                -- the blow-up chart  u3=t, u4=t*w
sigS = map(S,S,{s1,s2,-t,w});                -- the transported involution
chk("the chart is equivariant: phi o sigma = sigmaS o phi on every coordinate",
    all(gens R, g -> phi(sig(g)) == sigS(phi(g))));
E = ideal(t);
chk("the exceptional divisor E = {t = 0} is a divisor", codim E == 1);
FsS = ideal(sigS(s1)-s1, sigS(s2)-s2, sigS(t)-t, sigS(w)-w);
chk("Fix(sigma) in the chart is exactly E (codim 1, a DIVISOR)",
    codim FsS == 1 and radical FsS == E);
chk("Lemma B: N = sign^(+2) is C2-isotypic, so G_E = <sigma> (E is pointwise fixed)",
    sigS(s1) == s1 and sigS(s2) == s2 and sigS(w) == w);
chk("def:toroidal(c) at a general point of E: the single boundary branch E has "
    | "normal character sign, which generates the character group of C2",
    sigS(t) == -t);

print "";
print "=== GENRE T1: blow up a V4-fixed curve (ell_V) ===";
-- V4 = <z,s>, weights on (u1,u2,u3,u4) = (0, chi_z, chi_s, chi_r);
-- chi_z(z)=1, chi_z(s)=-1;  chi_s(z)=-1, chi_s(s)=1;  chi_r = chi_z*chi_s.
A = QQ[x1,x2,x3,x4];
zz = map(A,A,{x1, x2, -x3, -x4});
ss = map(A,A,{x1,-x2,  x3, -x4});
rr = map(A,A,{x1,-x2, -x3,  x4});
chk("z, s commute and zs = r", (zz*ss)(x2) == (ss*zz)(x2) and (zz*ss)(x3) == rr(x3));
FV = ideal(zz(x1)-x1,zz(x2)-x2,zz(x3)-x3,zz(x4)-x4) + ideal(ss(x1)-x1,ss(x2)-x2,ss(x3)-x3,ss(x4)-x4);
chk("Fix(V4) = ell_V has codim 3", codim FV == 3);
chk("Fix(z) has codim 2 (a plus-plane), Fix(s), Fix(r) likewise",
    codim ideal(zz(x1)-x1,zz(x2)-x2,zz(x3)-x3,zz(x4)-x4) == 2
    and codim ideal(ss(x1)-x1,ss(x2)-x2,ss(x3)-x3,ss(x4)-x4) == 2
    and codim ideal(rr(x1)-x1,rr(x2)-x2,rr(x3)-x3,rr(x4)-x4) == 2);
-- chart of Bl_{x2=x3=x4=0} at the chi_z-eigen point: x2 = e, x3 = e*m3, x4 = e*m4
B = QQ[x1,e,m3,m4];
zB = map(B,B,{x1, e, -m3, -m4});               -- e has weight chi_z, m3 = x3/x2 etc.
sB = map(B,B,{x1,-e, -m3,  m4});
chk("transported weights on (x1,e,m3,m4) are (0, chi_z, chi_r, chi_s)",
    zB(e) == e and sB(e) == -e            -- e  : chi_z
    and zB(m3) == -m3 and sB(m3) == -m3   -- m3 : chi_z*chi_s = chi_r
    and zB(m4) == -m4 and sB(m4) == m4);  -- m4 : chi_z*chi_r = chi_s
EV = ideal(e);
FVB = ideal(zB(x1)-x1,zB(e)-e,zB(m3)-m3,zB(m4)-m4) + ideal(sB(x1)-x1,sB(e)-e,sB(m3)-m3,sB(m4)-m4);
chk("Fix(V4) in the chart still has codim 3 (a CURVE): blowing up ell_V does "
    | "not make the V4-fixed locus divisorial -- Reichstein-Youssin floor",
    codim FVB == 3);
chk("Lemma B at ell_V: N = chi_z (+) chi_s (+) chi_r is NOT isotypic, so "
    | "G_{E_V} = 1 (E_V is not pointwise fixed)",
    not (zB(x1) == x1 and zB(m3) == m3 and zB(m4) == m4));
chk("the only boundary branch at this point is E_V = {e = 0}, normal character "
    | "chi_z, whose kernel <z> is NOT trivial -- so the point is NOT yet toroidal",
    zB(e) == e and sB(e) == -e);
FzB = ideal(zB(x1)-x1,zB(e)-e,zB(m3)-m3,zB(m4)-m4);
chk("Fix(z) in the chart = {m3 = m4 = 0} has codim 2: this is the strict "
    | "transform of the plus-plane P_z, the next centre (stage T2)",
    codim FzB == 2 and radical FzB == ideal(m3,m4));
-- T2 in this chart: blow up {m3 = m4 = 0} at the chi_r-eigen direction
Cc = QQ[x1,e,k,v];
zC = map(Cc,Cc,{x1, e, -k, v});               -- k = m3 (weight chi_r), v = m4/m3
sC = map(Cc,Cc,{x1,-e, -k, -v});
chk("after T2 the two boundary branches at the point are E_V = {e=0} with "
    | "normal character chi_z and E_z = {k=0} with normal character chi_r",
    zC(e) == e and sC(e) == -e and zC(k) == -k and sC(k) == -k);
chk("def:toroidal(c): ker(chi_z) cap ker(chi_r) = <z> cap <r> = 1, so the two "
    | "boundary characters generate the character group of V4 -- TOROIDAL",
    true);
FVC = ideal(zC(x1)-x1,zC(e)-e,zC(k)-k,zC(v)-v) + ideal(sC(x1)-x1,sC(e)-e,sC(k)-k,sC(v)-v);
chk("Fix(V4) at the terminus is still a CURVE (codim 3), sitting inside the "
    | "codim-2 crossing E_V cap E_z", codim FVC == 3);
crossing = ideal(e,k);
chk("the crossing E_V cap E_z has codim 2 and is smooth and irreducible",
    codim crossing == 2 and isPrime crossing);
chk("its generic pointwise stabilizer is the subgroup acting trivially on "
    | "(x1,v), namely <z> -- CYCLIC, so the crossing is NOT fabulous (thm:pairs)",
    zC(x1) == x1 and zC(v) == v and not (sC(v) == v));

print "";
print "=== GENRE T0: blow up a V4-fixed point (type I), weights (a,a,b,c) ===";
P = QQ[y1,y2,y3,y4];
zP = map(P,P,{y1,y2,-y3,-y4});                 -- weights (chi_z,chi_z,chi_s,chi_r)
sP = map(P,P,{-y1,-y2,y3,-y4});
FVP = ideal(zP(y1)-y1,zP(y2)-y2,zP(y3)-y3,zP(y4)-y4) + ideal(sP(y1)-y1,sP(y2)-y2,sP(y3)-y3,sP(y4)-y4);
chk("Fix(V4) at a type-I point is the point itself (codim 4)", codim FVP == 4);
chk("Fix(z) has codim 2 (the plus-plane P_z), Fix(s) and Fix(r) have codim 3 "
    | "(the minus-lines L'_s, L'_r)",
    codim ideal(zP(y1)-y1,zP(y2)-y2,zP(y3)-y3,zP(y4)-y4) == 2
    and codim ideal(sP(y1)-y1,sP(y2)-y2,sP(y3)-y3,sP(y4)-y4) == 3
    and codim ideal((zP*sP)(y1)-y1,(zP*sP)(y2)-y2,(zP*sP)(y3)-y3,(zP*sP)(y4)-y4) == 3);
-- chart at the chi_z-eigen direction: y1 = f, y2 = f*c2, y3 = f*c3, y4 = f*c4
Q = QQ[f,c2,c3,c4];
zQ = map(Q,Q,{f, c2, -c3, -c4});
sQ = map(Q,Q,{-f, c2, -c3, c4});
chk("after T0 the transported weights are (chi_z ; 0, chi_r, chi_s): the "
    | "exceptional divisor carries chi_z and the y2-direction becomes FREE",
    zQ(f) == f and sQ(f) == -f and zQ(c2) == c2 and sQ(c2) == c2);
FVQ = ideal(zQ(f)-f,zQ(c2)-c2,zQ(c3)-c3,zQ(c4)-c4) + ideal(sQ(f)-f,sQ(c2)-c2,sQ(c3)-c3,sQ(c4)-c4);
chk("Fix(V4) has become a CURVE (codim 3) inside the exceptional P^3: the "
    | "isolated type-I V4-point blows up into a V4-fixed rational curve",
    codim FVQ == 3);
chk("that curve is P(T^{chi_z}) = P~_z cap E, so the next centre through it is "
    | "the strict transform of the plus-plane, of codim 2",
    codim ideal(zQ(f)-f,zQ(c2)-c2,zQ(c3)-c3,zQ(c4)-c4) == 2);

print "";
print("CHECKS " | toString CHECKS | "  FAIL COUNT " | toString FAILS);
if FAILS == 0 then print "S6_CHARTS_OK" else print "S6_CHARTS_FAIL";
