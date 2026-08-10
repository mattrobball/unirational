kk = ZZ/397;
R = kk[x0];
I = saturate ideal(157*x0*x0, 5*x0*x0, 60*x0*x0, 325*x0*x0, 203*x0*x0, 168*x0*x0, 328*x0*x0, 324*x0*x0, 373*x0*x0, 282*x0*x0, 95*x0*x0, 323*x0*x0, 108*x0*x0, 255*x0*x0, 236*x0*x0);
if I == ideal(1_R) then print("D12:1.396.34.363.362.205 EMPTY") else (
  cs = minimalPrimes I;
  print("D12:1.396.34.363.362.205 dim " | toString(dim I - 1) | " degree " | toString degree I | " ncomp " | toString(#cs));
  for c in cs do print("D12:1.396.34.363.362.205   comp dim " | toString(dim c - 1) | " degree " | toString degree c | " genus " | toString(if dim c == 2 then genus c else -999));
);
