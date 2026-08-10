kk = ZZ/397;
R = kk[x0,x1];
I = saturate ideal(219*x0*x0+290*x0*x1+231*x1*x1, 99*x0*x0+127*x0*x1+64*x1*x1, 141*x0*x0+301*x0*x1+329*x1*x1, 102*x0*x0+228*x0*x1+180*x1*x1, 172*x0*x0+221*x0*x1+34*x1*x1, 343*x0*x0+335*x0*x1+71*x1*x1, 354*x0*x0+208*x0*x1+177*x1*x1, 374*x0*x0+196*x0*x1+19*x1*x1, 175*x0*x0+67*x0*x1+282*x1*x1, 351*x0*x0+332*x0*x1+246*x1*x1, 345*x0*x0+275*x0*x1+326*x1*x1, 151*x0*x0+303*x0*x1+319*x1*x1, 376*x0*x0+195*x0*x1+31*x1*x1, 66*x0*x0+198*x0*x1+298*x1*x1, 9*x0*x0+372*x0*x1+77*x1*x1);
if I == ideal(1_R) then print("C6:362 EMPTY") else (
  cs = minimalPrimes I;
  print("C6:362 dim " | toString(dim I - 1) | " degree " | toString degree I | " ncomp " | toString(#cs));
  for c in cs do print("C6:362   comp dim " | toString(dim c - 1) | " degree " | toString degree c | " genus " | toString(if dim c == 2 then genus c else -999));
);
