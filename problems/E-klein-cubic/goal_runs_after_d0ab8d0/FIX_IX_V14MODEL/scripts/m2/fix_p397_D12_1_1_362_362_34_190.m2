kk = ZZ/397;
R = kk[x0];
I = saturate ideal(260*x0*x0, 186*x0*x0, 180*x0*x0, 212*x0*x0, 352*x0*x0, 223*x0*x0, 76*x0*x0, 35*x0*x0, 394*x0*x0, 62*x0*x0, 16*x0*x0, 384*x0*x0, 58*x0*x0, 37*x0*x0, 347*x0*x0);
if I == ideal(1_R) then print("D12:1.1.362.362.34.190 EMPTY") else (
  cs = minimalPrimes I;
  print("D12:1.1.362.362.34.190 dim " | toString(dim I - 1) | " degree " | toString degree I | " ncomp " | toString(#cs));
  for c in cs do print("D12:1.1.362.362.34.190   comp dim " | toString(dim c - 1) | " degree " | toString degree c | " genus " | toString(if dim c == 2 then genus c else -999));
);
