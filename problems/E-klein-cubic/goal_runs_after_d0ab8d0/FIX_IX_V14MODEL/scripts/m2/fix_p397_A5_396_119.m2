kk = ZZ/397;
R = kk[x0];
I = saturate ideal(193*x0*x0, 304*x0*x0, 239*x0*x0, 64*x0*x0, 155*x0*x0, 241*x0*x0, 241*x0*x0, 281*x0*x0, 138*x0*x0, 346*x0*x0, 157*x0*x0, 323*x0*x0, 374*x0*x0, 269*x0*x0, 220*x0*x0);
if I == ideal(1_R) then print("A5:396.119 EMPTY") else (
  cs = minimalPrimes I;
  print("A5:396.119 dim " | toString(dim I - 1) | " degree " | toString degree I | " ncomp " | toString(#cs));
  for c in cs do print("A5:396.119   comp dim " | toString(dim c - 1) | " degree " | toString degree c | " genus " | toString(if dim c == 2 then genus c else -999));
);
