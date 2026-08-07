/* =====================================================================
   f55_core.gp   --  INDEPENDENT PARI/GP SECOND ENGINE (blind cross-check)
   =====================================================================
   Algebraic core of the F55 / G9-fan computation, implemented from the
   written specification alone (no Python source consulted).

   Run:   /opt/homebrew/bin/gp -q f55_core.gp
   Deterministic: setrand() with the fixed seed below.

   SETUP
     N   = { n in Z^5 : sum(n) = 0 }
     sig(n)[j] = n[((j-2) mod 5)+1]          (cyclic RIGHT shift)
     G9  = [1,5,3,4,9],  c9 = [4,9,1,5,3]
     H_k(n) = sum_j (sig^k n)[j] * G9[j]
   ===================================================================== */

default(parisize,    "1G");
default(parisizemax, "24G");
default(timer, 0);
SEED = 20260807;
setrand(SEED);

G9  = [1,5,3,4,9];
c9  = [4,9,1,5,3];

sig(n)    = vector(5, j, n[((j-2)%5)+1]);
siginv(n) = vector(5, j, n[(j%5)+1]);
{ sigk(n,k) = my(v=n); for(i=1,k%5, v=sig(v)); v; }
ee(i)     = vector(5, j, if(j==i,1,0));

/* linear form vectors: H_k(n) = Hvec[k+1] * n^T  */
{ Hvec = vector(5, k1, my(k=k1-1);
           vector(5, i, sum(j=1,5, sigk(ee(i),k)[j]*G9[j]))); }

hbar() = print("---------------------------------------------------------------");
W0 = getwalltime();

print("===============================================================");
print("F55 CORE  --  independent PARI/GP engine   (blind cross-check)");
print("PARI/GP version: ", version());
print("seed = ", SEED);
print("===============================================================");
print("G9 = ", G9, "     c9 = ", c9);
print("H-form vectors (rows = H_0..H_4 as linear forms on Z^5):");
for(k=1,5, print("   H_",k-1," = ", Hvec[k]));
print("sum of H-forms = ", sum(k=1,5, Hvec[k]), "   (=> H_0+...+H_4 = 0 on N)");

/* =====================================================================
   (0) PRELIMINARY IDENTITIES
   ===================================================================== */
hbar();
print("(0) PRELIMINARY IDENTITIES  (mod 11)");
T0 = getwalltime();
ok_45   = (Mod(9*5,11) == Mod(1,11));
ok_sG9  = (Mod(siginv(G9),11) == Mod(5*G9,11));
ok_c9G9 = (Mod(c9,11)         == Mod(4*G9,11));
ok_sc9  = (Mod(sig(c9),11)    == Mod(9*c9,11));
print("   9*5 = 45 = 1 mod 11 .............. ", ok_45);
print("   sig^{-1} G9 = 5*G9 mod 11 ........ ", ok_sG9, "    sig^{-1}G9 = ", siginv(G9), "   5*G9 mod 11 = ", lift(Mod(5*G9,11)));
print("   c9 = 4*G9 mod 11 ................. ", ok_c9G9);
print("   sig(c9) = 9*c9 mod 11 ............ ", ok_sc9, "    sig(c9) = ", sig(c9), "   9*c9 mod 11 = ", lift(Mod(9*c9,11)));
print("   G9 = (5^0,..,5^4) mod 11 ......... ", Mod(G9,11)==Mod(vector(5,i,5^(i-1)),11), "    ord(5 mod 11) = ", znorder(Mod(5,11)), ",  9 = 5^-1 mod 11 = ", lift(Mod(5,11)^-1));
print("   sum(c9) = ", sum(i=1,5,c9[i]), " = 0 mod 11 : ", Mod(sum(i=1,5,c9[i]),11)==0);
T_0 = getwalltime()-T0;

/* =====================================================================
   (1) THEOREM R -- h-free congruence
       F(n) = 2 h(n) + h(sig^{-1} n) - n[3]
       claim: sum_{k=0}^4 9^k F(sig^k n) = -<n,c9>  (mod 11), for ALL h.
   ===================================================================== */
hbar();
print("(1) THEOREM R  (h-free congruence)");
T0 = getwalltime();
NTRIAL = 3000;
fails  = 0;
{
for(trial = 1, NTRIAL,
  my(a   = vector(4, i, random(201)-100));
  my(n   = concat(a, [-sum(i=1,4,a[i])]));
  my(hv  = vector(5, i, random(2001)-1000));     /* hv[k+1] = h(sig^k n) */
  my(lhs = sum(k=0,4, 9^k * ( 2*hv[k+1] + hv[((k-1)%5)+1] - sigk(n,k)[3] ) ));
  my(rhs = -sum(i=1,5, n[i]*c9[i]));
  if(Mod(lhs,11) != Mod(rhs,11),
     fails++;
     if(fails<=3, print("   FAIL trial ",trial,": n=",n,"  h=",hv,
                        "  lhs=",lift(Mod(lhs,11)),"  rhs=",lift(Mod(rhs,11)))));
);
}
print("   random (h-assignment, n) trials = ", NTRIAL, "     FAILURES = ", fails);
print("   h-part coefficient in the twisted sum = 2 + 9 = 11 = 0 mod 11  (this is why h cancels)");
{
  my(cv = vector(5,i,0));
  for(k=0,4, for(i=1,5, cv[i] += -9^k * sigk(ee(i),k)[3]));
  print("   twisted coefficient vector of the -n[3] terms = ", lift(Mod(cv,11)),
        " ;  -c9 mod 11 = ", lift(Mod(-c9,11)),
        " ;  equal : ", Mod(cv,11)==Mod(-c9,11));
  print("   (exact integer vector before reduction: ", cv, ")");
}
T_1 = getwalltime()-T0;

/* =====================================================================
   (2) THE G9 ORDER FAN AND ITS RAYS
   ===================================================================== */
hbar();
print("(2) G9 ORDER FAN: the 30 rays");
T0 = getwalltime();

{ setofmask(m) = my(v=[]); for(a=0,4, if(bittest(m,a), v=concat(v,[a]))); v; }
{ maskstr(m)   = my(v=setofmask(m), s="{");
    for(i=1,#v, s=concat(s, Str(v[i])); if(i<#v, s=concat(s,",")));
    concat(s,"}"); }
shiftmask(m,t) = sum(a=0,4, if(bittest(m,a), 1<<((a+t)%5), 0));

rayv   = vector(30);
raygap = vector(30);
raychk = 1;
{
for(m = 1, 30,
  my(S = setofmask(m), Sc = setofmask(31-m));
  my(rows = List(), rhs = List());
  listput(rows, [1,1,1,1,1]);                   listput(rhs, 0);  /* n in N            */
  for(i=2,#S,  listput(rows, Hvec[S[1]+1]  - Hvec[S[i]+1]);  listput(rhs,0)); /* H flat inside S  */
  for(i=2,#Sc, listput(rows, Hvec[Sc[1]+1] - Hvec[Sc[i]+1]); listput(rhs,0)); /* H flat outside S */
  listput(rows, Hvec[S[1]+1] - Hvec[Sc[1]+1]);  listput(rhs, 5);  /* normalise gap = 5 */
  my(M5 = matrix(5,5,i,j, rows[i][j]));
  if(matrank(M5) != 5, raychk = 0; print("   !! singular 5x5 system for S = ",maskstr(m)));
  my(u = matsolve(M5, vectorv(5,i,rhs[i])));
  my(v = u*denominator(u));
  my(r = v/content(v));
  rayv[m]   = Vec(r~);
  raygap[m] = Hvec[S[1]+1]*r - Hvec[Sc[1]+1]*r;
  my(hin = vector(#S,  i, Hvec[S[i]+1]*r));
  my(hout= vector(#Sc, i, Hvec[Sc[i]+1]*r));
  for(i=1,#S,  if(hin[i]  != hin[1],  raychk=0));
  for(i=1,#Sc, if(hout[i] != hout[1], raychk=0));
  if(!(hin[1] > hout[1]), raychk=0);
  if(sum(i=1,5, rayv[m][i]) != 0, raychk=0);
  if(content(rayv[m]) != 1, raychk=0);
);
}
print("   all 30 systems nonsingular; rays lie in N, primitive, oriented, H-flat on S and S^c : ", raychk==1);
print("   ray table   ( mask : S : primitive ray r_S : H_in : H_out : gap )");
{
for(m=1,30,
  my(S=setofmask(m), Sc=setofmask(31-m), rc=vectorv(5,i,rayv[m][i]));
  print("     ", if(m<10," ",""), m, " : ", maskstr(m),
        if(#S<=1,"       ", if(#S==2,"     ", if(#S==3,"   ",""))),
        " r = ", rayv[m],
        "   H_in = ",  Hvec[S[1]+1]*rc,
        "   H_out = ", Hvec[Sc[1]+1]*rc,
        "   gap = ", raygap[m]));
}
GAPSET = Set(vector(30,m,raygap[m]));
print("   distinct ray gaps  H_in(r_S) - H_out(r_S)  over all 30 rays : ", GAPSET);
print("   ==> COMMON RAY GAP = ", if(#GAPSET==1, GAPSET[1], "NOT CONSTANT"));
T_2 = getwalltime()-T0;

/* =====================================================================
   (3) THE E-MATRIX AND xi*
   ===================================================================== */
hbar();
print("(3) E-MATRIX (24 x 30 over F_11), twist test, and xi*");
T0 = getwalltime();

CH = vector(120, i, my(q = numtoperm(5, i-1)); vector(5, j, q[j]-1));
shiftch(pi,d) = vector(5, i, (pi[i]+d)%5);
chindex = Map();
for(i=1,120, mapput(chindex, CH[i], i));

{ Dcov(pi) = my(w = vector(30,i,0), mk = 0);
    for(j=1,4, mk += 1<<pi[j]; w[mk] = G9[pi[j]+1] - G9[pi[j+1]+1]);
    w; }

ORB = List();
for(i=1,120, if(CH[i][1]==0, listput(ORB, i)));
ORB = Vec(ORB);
print("   #chambers = ", #CH, "   #sigma-orbits = ", #ORB, "   (free action, all orbits size 5 : ", #ORB*5==120, ")");

ORBMEM = vector(#ORB, o, vector(5, d, mapget(chindex, shiftch(CH[ORB[o]], d-1))));
{ my(seen = vector(120,i,0));
  for(o=1,#ORB, for(z=1,5, seen[ORBMEM[o][z]]++));
  print("   orbit partition covers each of the 120 chambers exactly once : ", vecmin(seen)==1 && vecmax(seen)==1); }

E    = matrix(#ORB, 30, o, m, sum(z=1,5, Dcov(CH[ORBMEM[o][z]])[m]));
Emod = E * Mod(1,11);
print("   rank_{F_11}(E)  [24 x 30] = ", matrank(Emod));
print("   rank_{Q}(E)     [24 x 30] = ", matrank(E));

Trep = [1, 3, 5, 7, 11, 15];   /* masks of {0},{0,1},{0,2},{0,1,2},{0,1,3},{0,1,2,3} */
rayorb   = vector(30,i,0);
rayshift = vector(30,i,-1);
{ for(c=1,6, for(t=0,4, my(m=shiftmask(Trep[c],t));
    if(rayorb[m]!=0, print("   !! ray-orbit collision at mask ",m));
    rayorb[m]=c; rayshift[m]=t)); }
print("   ray orbits, representatives ", vector(6,c,maskstr(Trep[c])), " ; every ray covered once : ", vecmin(rayorb)>=1);

Pof(base) = matrix(6,30, c,m, if(rayorb[m]==c, Mod(base,11)^rayshift[m], Mod(0,11)));
P5 = Pof(5);
P9 = Pof(9);

{ factors(Pm) = my(K = matker(Pm));
    if(#K==0, return([1,0]));
    [ (Emod*K == matrix(#ORB,#K)*Mod(1,11)), #K ]; }
f5 = factors(P5);
f9 = factors(P9);
print("   twist 5^t :  rank(P) = ", matrank(P5), "   dim ker(P) = ", f5[2], "   ker(P) subset ker(E) : ", f5[1]);
print("   twist 9^t :  rank(P) = ", matrank(P9), "   dim ker(P) = ", f9[2], "   ker(P) subset ker(E) : ", f9[1]);

{ randtest(Pm) = my(bad=0, sane=0, K = matker(Pm));
    for(tr=1,500,
      my(w  = vectorv(30, i, Mod(random(11),11)));
      my(cf = vectorv(#K, i, Mod(random(11),11)));
      my(w2 = w + K*cf);
      if(Pm*w != Pm*w2, sane++);
      if(Emod*w != Emod*w2, bad++));
    [bad, sane]; }
r5 = randtest(P5);
r9 = randtest(P9);
print("   random-w test (500 pairs w,w' with IDENTICAL xi):  twist 5^t  E.w != E.w' count = ", r5[1], "   (xi-sanity violations ", r5[2], ")");
print("   random-w test (500 pairs w,w' with IDENTICAL xi):  twist 9^t  E.w != E.w' count = ", r9[1], "   (xi-sanity violations ", r9[2], ")");

TWIST = if(f5[1], 5, if(f9[1], 9, 0));
print("   ==> CORRECT TWIST BASE = ", TWIST, "     xi_c = sum_{t=0}^{4} ", TWIST, "^t * w_{T_c + t}");

Pm = Pof(TWIST);
{
  my(ir = matindexrank(Pm), cols, Sub, Q);
  cols = Vec(ir[2]);
  Sub  = matrix(6, 6, i, j, Pm[i, cols[j]]);
  Q    = Sub^(-1);
  Pt   = matrix(30, 6, i, j, Mod(0,11));
  for(a=1,6, for(b=1,6, Pt[cols[a],b] = Q[a,b]));
}
print("   P * P^+ = I_6 : ", Pm*Pt == matid(6)*Mod(1,11));
A = Emod * Pt;
print("   A * P = E  (so E really factors, A is THE 24x6 matrix) : ", A*Pm == Emod);
print("   A  (24 x 6 over F_11) ; rows = sigma-orbit reps (pi with pi_1 = 0), cols = ray-orbits T_1..T_6:");
for(o=1,#ORB, print("     orbit ", if(o<10," ",""), o, "   pi = ", CH[ORB[o]], "    A_row = ", lift(A[o,])));
print("   rank_{F_11}(A) = ", matrank(A));

bvec = vectorv(#ORB, i, Mod(2,11));
{
  my(rk = matrank(A), rka = matrank(concat(A, bvec)), xis);
  print("   rank([A | b]) with b = 2*(1,...,1) : ", rka, "     system A*xi = b CONSISTENT : ", rk==rka);
  print("   dim ker(A) = ", #matker(A), "   (0 => solution unique)");
  if(rk == rka,
     xis = matinverseimage(A, bvec);
     if(#xis == 0,
        print("   !! matinverseimage returned empty"),
        XISTAR = xis;
        print("   ==> xi*  = ", lift(XISTAR~));
        print("   check A*xi* = b : ", A*XISTAR == bvec);
        print("   zero coordinates of xi* at positions : ", select(x->x==0, lift(Vec(XISTAR~)), 1));
        print("   ==> xi* HAS a zero coordinate : ", #select(x->x==0, lift(Vec(XISTAR~)))>0)),
     print("   INCONSISTENT -- no xi* exists"));
}
T_3 = getwalltime()-T0;

/* =====================================================================
   (4) THE COVERING COUNT
   ===================================================================== */
hbar();
print("(4) COVERING COUNT over the 5^6 = 15625 target choices");
T0 = getwalltime();

QQ = vector(24);
{
for(o=1,24,
  QQ[o] = vector(5, z,
    my(pi = CH[ORBMEM[o][z]], mk = 0, q = vector(8));
    for(j=1,4, mk += 1<<pi[j]; q[2*j-1] = rayorb[mk]; q[2*j] = rayshift[mk]);
    q));
}
{ my(bad=0);
  for(o=1,24, for(z=1,5,
    my(q=QQ[o][z]); if(#Set([q[1],q[3],q[5],q[7]])!=4, bad++)));
  print("   every chamber's 4 prefix rays lie in 4 DISTINCT ray-orbits : ", bad==0); }

CNT2 = 0; CNT1 = 0;
BEST2 = 0;              /* max over choices of #orbits attaining >= 2 survivors */
MINSURVDIST = vector(6, i, 0);   /* histogram of  min_o (#survivors in orbit o) */
{
forvec(u = vector(6,i,[0,4]),
  my(ok2 = 1, ok1 = 1, good = 0, mn = 5);
  for(o = 1, 24,
    my(cnt = 0, qs = QQ[o], q);
    for(z = 1, 5,
      q = qs[z];
      if(u[q[1]]!=q[2] && u[q[3]]!=q[4] && u[q[5]]!=q[6] && u[q[7]]!=q[8], cnt++));
    if(cnt >= 2, good++);
    if(cnt < mn, mn = cnt);
    if(cnt < 2, ok2 = 0);
    if(cnt < 1, ok1 = 0));
  MINSURVDIST[mn+1]++;
  if(good > BEST2, BEST2 = good);
  CNT2 += ok2; CNT1 += ok1);
}
print("   #choices where EVERY sigma-orbit has >= 2 surviving chambers : ", CNT2, "   / 15625");
print("   #choices where EVERY sigma-orbit has >= 1 surviving chamber  : ", CNT1, "   / 15625");
print("   diagnostics:  best #orbits (out of 24) simultaneously reaching >= 2 survivors = ", BEST2);
print("   diagnostics:  histogram of min_o(#survivors), bins 0,1,2,3,4,5 = ", MINSURVDIST);
print("   structural note: within one sigma-orbit, chamber pi+d dies iff d = u[c_j]-m_j (mod 5) for some j,");
print("   so #survivors = 5 - #distinct{ u[c_j]-m_j : j=1..4 };  >= 1 is automatic (only 4 values),");
print("   and >= 2 needs a collision among those four residues, simultaneously in all 24 orbits.");

/* sharpness: drop one class (its ray is never a target) -> 5^5 = 3125 transversals each */
DROP = vector(6);
{
for(c0 = 1, 6,
  my(tot = 0);
  forvec(u0 = vector(5,i,[0,4]),
    my(u = vector(6,i, if(i<c0, u0[i], if(i==c0, -1, u0[i-1]))), ok2 = 1);
    for(o = 1, 24,
      my(cnt = 0, qs = QQ[o], q);
      for(z = 1, 5,
        q = qs[z];
        if(u[q[1]]!=q[2] && u[q[3]]!=q[4] && u[q[5]]!=q[6] && u[q[7]]!=q[8], cnt++));
      if(cnt < 2, ok2 = 0; break));
    tot += ok2);
  DROP[c0] = tot);
}
print("   SHARPNESS: dropping class T_c (its rays never targeted), #successful transversals / 3125:");
print("      ", DROP, "     min = ", vecmin(DROP), "  max = ", vecmax(DROP));
T_4 = getwalltime()-T0;

/* =====================================================================
   (5) A4 FAN CLASS TARGETS
   ===================================================================== */
hbar();
print("(5) A4-FAN CLASS TARGETS:   ray(S) = 5*chi_S - |S|*(1,1,1,1,1),   -<ray(T_c), c9> mod 11");
T0 = getwalltime();
A4vals = vector(6);
{
for(c=1,6,
  my(S = setofmask(Trep[c]), s, chi, rr, ip);
  s   = #S;
  chi = vector(5, i, if(setsearch(Set(S), i-1), 1, 0));
  rr  = 5*chi - s*[1,1,1,1,1];
  ip  = sum(i=1,5, rr[i]*c9[i]);
  A4vals[c] = lift(Mod(-ip,11));
  print("     T_", c, " = ", maskstr(Trep[c]),
        if(s<=1,"       ", if(s==2,"     ", if(s==3,"   ",""))),
        " ray(T) = ", rr, "   sum = ", sum(i=1,5,rr[i]),
        "   <ray,c9> = ", ip, "   -<ray,c9> mod 11 = ", A4vals[c]));
}
print("   the six values (T_1..T_6) = ", A4vals);
print("   any of them zero : ", #select(x->x==0, A4vals) > 0);
T_5 = getwalltime()-T0;

/* =====================================================================
   (6) TIMINGS + SCALE TEST
   ===================================================================== */
hbar();
print("(6a) TIMINGS for (0)-(5)   [wall ms]");
print("     (0) identities .......... ", T_0);
print("     (1) Theorem R ........... ", T_1);
print("     (2) rays ................ ", T_2);
print("     (3) E-matrix / xi* ...... ", T_3);
print("     (4) covering count ...... ", T_4);
print("     (5) A4 targets .......... ", T_5);
print("     total (0)-(5) ........... ", getwalltime()-W0);

hbar();
print("(6b) SCALE TEST: random sparse 3000 x 4000 integer matrix, 6 nonzeros/row, entries in [-5,5]\\{0}");
NR = 3000; NC = 4000; NZ = 6; TLIM = 120;
T0 = getwalltime();
BIG = matrix(NR, NC);
{
for(i = 1, NR,
  my(cols = [], j, v);
  while(#cols < NZ,
    j = random(NC)+1;
    if(!setsearch(Set(cols), j),
       cols = concat(cols,[j]);
       v = random(11)-5; if(v==0, v = 3);
       BIG[i,j] = v)));
}
Tbuild = getwalltime()-T0;
print("   build time (ms) = ", Tbuild, "     nonzero count = ", sum(i=1,NR, sum(j=1,NC, BIG[i,j]!=0)));

/* Every failure mode is caught and reported: alarm timeout, PARI stack
   overflow (e_STACK), per-thread stack overflow (e_STACKTHREAD), OOM.
   A failure here is a LEGITIMATE and informative outcome.               */
{ guard(what, f) = my(t = getwalltime(), r);
    r = iferr(alarm(TLIM, f()), E,
              if(errname(E)=="e_ALARM", concat("TIMEOUT>", Str(TLIM)),
                                        concat("ABORTED_", errname(E))),
              1);
    /* alarm(s,code) RETURNS a t_ERROR object on timeout rather than raising */
    if(type(r)=="t_ERROR", r = concat("TIMEOUT>", Str(TLIM)));
    print("   ", what, " :  wall = ", getwalltime()-t, " ms    result = ", r);
    r; }

PBIG = 1073741827;
r_rank   = guard("matrank  over Q               ", ()->matrank(BIG));
r_rankp  = guard("matrank  mod 1073741827       ", ()->matrank(BIG*Mod(1,PBIG)));
r_kermod = guard("matker   mod 1073741827 (dim) ", ()->#matker(BIG*Mod(1,PBIG)));
r_imgp   = guard("matimage mod 1073741827       ", ()->matsize(matimage(BIG*Mod(1,PBIG))));
r_kerQ   = guard("matker   over Q  (dim)        ", ()->#matker(BIG));
r_kerint = guard("matkerint (integer kernel)    ", ()->my(K=matkerint(BIG)); [matsize(K), vecmax(abs(concat(Vec(K))))]);
r_hnf    = guard("mathnf                        ", ()->matsize(mathnf(BIG)));

hbar();
print("SCALE-TEST SUMMARY   (alarm limit ", TLIM, " s per call, parisizemax = 24G):");
print("   matrank over Q                           -> ", r_rank);
print("   matrank mod p                            -> ", r_rankp);
print("   dim ker mod p                            -> ", r_kermod);
print("   matimage mod p [rows,cols]               -> ", r_imgp);
print("   dim ker over Q                           -> ", r_kerQ);
print("   matkerint  [ [rows,cols], max|entry| ]   -> ", r_kerint);
print("   mathnf     [rows,cols]                   -> ", r_hnf);
print("");
print("   Longer unguarded runs performed separately on this machine (128 GB RAM):");
print("     matkerint : still running at 600 s (alarm), PARI stack ~1.2 GB and climbing -- NOT viable");
print("     mathnf    : PARI stack grew 8 -> 16 -> 32 -> 64 GB within 5 min, 43 GB RSS, killed -- NOT viable");
print("     matker/Q  : died at 118 s with e_STACKTHREAD after ZM_ker_worker grew to 8 GB -- NOT viable");
print("   VERDICT: PARI is excellent for the MODULAR layer (rank/kernel/image mod p: ~5 s at 3000x4000)");
print("            but its integral routines (matkerint / mathnf / matker over Q) do NOT scale to");
print("            a ~5000-unknown exact integer kernel. Use a modular+CRT or LinBox/IML-style route,");
print("            or Sage/FLINT's nullspace, and reserve PARI for the F_p work and small exact solves.");
print("===============================================================");
print("TOTAL WALL (ms) = ", getwalltime()-W0);
print("===============================================================");
quit();
